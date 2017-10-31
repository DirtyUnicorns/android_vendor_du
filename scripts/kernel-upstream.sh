#!/usr/bin/env bash
#
# Pull in linux-stable updates to a kernel tree
#
# Copyright (C) 2017 Nathan Chancellor
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>


# Get main tree location
TREE=$( cd $( dirname $( readlink -f "${BASH_SOURCE[0]}" ) )/../../.. && pwd )


# Colors for script
BOLD="\033[1m"
GRN="\033[01;32m"
RED="\033[01;31m"
RST="\033[0m"
YLW="\033[01;33m"


# Alias for echo to handle escape codes like colors
function echo() {
    command echo -e "$@"
}


# Prints a formatted header to point out what is being done to the user
function header() {
    [[ -n ${2} ]] && COLOR=${2} || COLOR=${RED}
    echo ${COLOR}
    echo "====$(for i in $(seq ${#1}); do echo "=\c"; done)===="
    echo "==  ${1}  =="
    echo "====$(for i in $(seq ${#1}); do echo "=\c"; done)===="
    echo ${RST}
}


# Prints an error in bold red
function report_error() {
    echo
    echo ${RED}${1}${RST}
    [[ ${2} = "-h" ]] && ${0} -h
    exit 1
}


# Prints a warning in bold yellow
function report_warning() {
    echo
    echo ${YLW}${1}${RST}
    [[ -z ${2} ]] && echo
}


# Parse the provided parameters
function parse_parameters() {
    while [[ $# -ge 1 ]]; do
        case ${1} in
            # Use git cherry-pick
            "-cp"|"--cherry-pick")
                export UPDATE_METHOD=cherry-pick ;;

            # Help menu
            "-h"|"--help")
                echo
                echo "${BOLD}Script description:${RST} Merges/cherry-picks Linux upstream into a kernel tree"
                echo
                echo "${BOLD}Required parameters:${RST}"
                echo "    -cp | --cherry-pick"
                echo "    -mg | --merge"
                echo "        Call either git cherry-pick or git merge when updating from upstream"
                echo
                echo "    -sf | --source-folder"
                echo "        The device's kernel source's location relative to the kernel folder"
                echo "        If unsure, run \"croot; cd kernel; ls --directory */*\" in your terminal (assuming you ran \". build/envsetup.sh\""
                echo
                echo "${BOLD}Optional parameters"
                echo "    -pl | --print-latest"
                echo "        Prints the latest version available for the current kernel tree upstream then exits"
                echo
                echo "    -u  | --update-only"
                echo "        Simply fetches the linux-stable remote then exits"
                echo
                echo "    -ul | --update-latest"
                echo "        Updates to the latest version available for the current kernel tree upstream"
                echo
                echo "    -v  | --version"
                echo "        Updates to the specified version (e.g. -v 3.18.78)"
                echo
                echo "${BOLD}Notes:${RST}"
                echo "    1. By default, only ONE version is picked at a time (e.g. 3.18.31 to 3.18.32)"
                echo "    2. If you already have a remote for upstream, rename it to linux-stable so that multiple ones do not get added!"
                echo
                exit 1 ;;

            # Use git merge
            "-mg"|"--merge")
                export UPDATE_METHOD=merge ;;

            # Print the latest version from kernel.org
            "-pl"|"--print-latest")
                export PRINT_LATEST=true ;;

            # Kernel source location
            "-sf"|"--source-folder")
                shift
                [[ $# -lt 1 ]] && report_error "Please specify a device directory!"

                export SOURCE_FOLDER=${TREE}/kernel/${1} ;;

            # Only update the linux-stable remote
            "-u"|"--update-only")
                export UPDATE_REMOTE_ONLY=true ;;

            # Update to the latest version upstream unconditionally
            "-ul"|"--update-latest")
                export UPDATE_MODE=2 ;;

            # Update to the specified version
            "-v"|"--version")
                shift
                [[ $# -lt 1 ]] && report_error "Please specify a version to update!"

                export UPDATE_MODE=1
                export VERSION_SUPPLIED=${1} ;;

            *)
                report_error "Invalid parameter!" ;;
        esac

        shift
    done

    # Sanity checks
    [[ ! ${UPDATE_METHOD} ]] && report_error "Neither cherry-pick nor merge were specified, please supply one!" -h
    [[ ! -d ${SOURCE_FOLDER} ]] && report_error "Invalid kernel source location specified! Folder does not exist" -h
    [[ ! -f ${SOURCE_FOLDER}/Makefile ]] && report_error "Invalid kernel source location specified! No Makefile present" -h
    [[ -z ${UPDATE_MODE} ]] && UPDATE_MODE=0
}


# Update the linux-stable remote (and add it if it doesn't exist)
function update_remote() {
    header "Updating linux-stable"

    # Add remote if it isn't already present
    cd ${SOURCE_FOLDER}
    [[ ! $(git remote | grep -m 1 linux-stable) ]] && \
        git remote add linux-stable https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/

    git fetch linux-stable

    [[ $? -ne 0 ]] && report_error "linux-stable update failed!" \
                   || echo "linux-stable updated successfully!"

    [[ ${UPDATE_REMOTE_ONLY} ]] && echo && exit 0
}


# Generate versions
function generate_versions() {
    header "Calculating versions"

    # Full kernel version
    CURRENT_VERSION=$(make kernelversion)
    # First two numbers (3.4 | 3.10 | 3.18 | 4.4)
    CURRENT_MAJOR_VERSION=$(echo ${CURRENT_VERSION} | cut -f 1,2 -d .)
    # Last number
    CURRENT_SUBLEVEL=$(echo ${CURRENT_VERSION} | cut -d . -f 3)

    # Get latest update from upstream
    LATEST_VERSION=$(git tag --sort=-taggerdate -l v${CURRENT_MAJOR_VERSION}* | head -n 1 | sed s/v//)

    # Print the current/latest version and exit if requested
    echo "${BOLD}Current kernel version:${RST} ${CURRENT_VERSION}"
    echo
    echo "${BOLD}Latest kernel version:${RST} ${LATEST_VERSION}"
    [[ ${PRINT_LATEST} ]] && echo && exit 0

    # UPDATE_MODES:
    # 0. Update one version
    # 1. Update to a specified version
    # 2. Update to the latest version
    case ${UPDATE_MODE} in
        0)
            TARGET_SUBLEVEL=$((${CURRENT_SUBLEVEL} + 1))
            TARGET_VERSION=${CURRENT_MAJOR_VERSION}.${TARGET_SUBLEVEL} ;;
        1)
            TARGET_VERSION=${VERSION_SUPPLIED} ;;
        2)
            TARGET_VERSION=${LATEST_VERSION} ;;
    esac

    # Make sure target version is between current version and latest version
    TARGET_SUBLEVEL=$(echo ${TARGET_VERSION} | cut -d . -f 3)
    [[ ${TARGET_SUBLEVEL} -le ${CURRENT_SUBLEVEL} ]] && report_error "Current version is up to date with target version ${TARGET_VERSION}!\n"
    [[ ${TARGET_SUBLEVEL} -gt ${LATEST_SUBLEVEL} ]] && report_error "Target version ${TARGET_VERSION} does not exist!\n"

    export CURRENT_VERSION TARGET_VERSION
    export RANGE=v${CURRENT_VERSION}..v${TARGET_VERSION}
}


function update_to_target_version() {
    case ${UPDATE_METHOD} in
        "cherry-pick")
            git cherry-pick ${RANGE}
            [[ $? -ne 0 ]] && report_error "Cherry-pick needs manual intervention! Resolve conflicts then run:

git add . && git cherry-pick --continue" || header "${TARGET_VERSION} PICKED CLEANLY!" ${GRN} ;;

        "merge")
            git merge v${TARGET_VERSION}
            [[ $? -ne 0 ]] && report_error "Merge needs manual intervention!

Resolve conflicts then run git merge --continue!" || header "${TARGET_VERSION} MERGED CLEANLY!" ${GRN} ;;
    esac
}

parse_parameters $@
update_remote
generate_versions
update_to_target_version
