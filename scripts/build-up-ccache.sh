#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018 Dirty Unicorns
# Purpose: Run several back to back builds to fill up ccache

# Get main tree location
TREE=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../.." && pwd)

# Set build log location based on tree
LOG=${TREE}/build-$(date +"%Y%m%d-%H%M").log

# Colors
BOLD="\033[1m"
RED="\033[01;31m"
RST="\033[0m"

# Prefix for lunch combos
PREFIX=du_

# Formats the time
function format_time() {
    MINS=$(((${2} - ${1}) / 60))
    SECS=$(((${2} - ${1}) % 60))
    if [[ ${MINS} -ge 60 ]]; then
        HOURS=$((MINS / 60))
        MINS=$((MINS % 60))
    fi

    if [[ ${HOURS} -eq 1 ]]; then
        TIME_STRING+="1 HOUR, "
    elif [[ ${HOURS} -ge 2 ]]; then
        TIME_STRING+="${HOURS} HOURS, "
    fi

    if [[ ${MINS} -eq 1 ]]; then
        TIME_STRING+="1 MINUTE"
    else
        TIME_STRING+="${MINS} MINUTES"
    fi

    if [[ ${SECS} -eq 1 && -n ${HOURS} ]]; then
        TIME_STRING+=", AND 1 SECOND"
    elif [[ ${SECS} -eq 1 && -z ${HOURS} ]]; then
        TIME_STRING+=" AND 1 SECOND"
    elif [[ ${SECS} -ne 1 && -n ${HOURS} ]]; then
        TIME_STRING+=", AND ${SECS} SECONDS"
    elif [[ ${SECS} -ne 1 && -z ${HOURS} ]]; then
        TIME_STRING+=" AND ${SECS} SECONDS"
    fi

    echo "${TIME_STRING}"
}

# Get the devices to compile
function get_devices {
	# Get the list of devices from the vendorsetup.sh file
	if grep -iq "caf" "${TREE}"/.repo/README.md; then
        CAF=caf-
    fi

    read -r -a DEVICES <<< "$(head -1 "${TREE}/vendor/${PREFIX/_/}/${CAF}vendorsetup.sh" | cut -d \; -f 1 | sed 's/^.*in //')"
}

# Prints an error in bold red
function die() {
    echo
    echo "${RED}${1}${RST}"
    [[ ${2} = "-h" ]] && ${0} -h
    exit 1
}

# Parse provided parameters and set appropriate variables
function parse_parameters {
    while [[ ${#} -ge 1 ]]; do
        case ${1} in
            "-d"|"--devices")
                shift
                [[ ${#} -lt 1 ]] && die "Please specify a list of devices!" -h

                IFS=',' read -r -a DEVICES <<< "${1}" ;;

            "-h"|"--help")
                echo
                echo "${BOLD}Script description:${RST} Run several builds continuously to fill up ccache"
                echo
                echo "${BOLD}Parameters:${RST}"
                echo "    -d | --devices"
                echo "        The list of devices to compile (separate by commas). These must match the codenames in vendorsetup.sh. By default, all devices are built."
                echo "        e.g. -d angler,bullhead,taimen"
                echo
                echo "    -n | --number"
                echo "        How many builds should be run per device. Default is five."
                echo ;;

            "-n"|"--number")
                shift
                [[ ${#} -lt 1 ]] && die "Please specify a number of builds to compile!" -h

                NUM=${1} ;;

            "-v"|"--variant")
                shift
                [[ ${#} -lt 1 ]] && die "Please the variant you want (user, userdebug, or eng)!" -h

                case ${1} in
                    "user"|"userdebug"|"eng") VARIANT=${1} ;;
                    *) die "Invalid variant specified!" -h ;;
                esac

                VARIANT=${1} ;;
        esac
        shift
    done

    [[ -z ${DEVICES} ]] && get_devices
    [[ -z ${NUM} ]] && NUM=5
    [[ -z ${VARIANT} ]] && VARIANT=user
}

# Alias for make
function mk() {
    m -j"$(nproc --all)" "${@}"
}

# The meat and potatos
function the_grind() {
    # Move to the source directory, force sync, and setup environment
    cd "${TREE}" || die "Source folder couldn't be found, are you running this in an AOSP tree?"
    repo sync --force-sync -j"$(nproc --all)"
    source build/envsetup.sh

    # For every provided device
    for DEVICE in "${DEVICES[@]}"; do
        COMBO="${PREFIX}${DEVICE}-${VARIANT}"
        # shellcheck disable=SC2034
        for i in $(seq 0 $((NUM-1))); do
            # Setup folders
            OUT_DIR=${TREE}/out/target/product/${DEVICE}

            # Lunch the device
            lunch "${COMBO}"

            # Clean up from previous compiles
            mk clobber

            # Make the zip
            TIME_START="$(date +%s)"
            time mk bacon
            TIME_END="$(date +%s)"

            # Count the zip files in the OUT_DIR
            FILES=$(find "${OUT_DIR}" -name '*.zip')
            # If there is more than one zip file in OUT_DIR, build succeeded
            if [[ -n ${FILES} ]]; then
                BUILD_RESULT_STRING="BUILD SUCCESSFUL"
            else
                BUILD_RESULT_STRING="BUILD FAILED"
            fi

            # Echo the device build and the result + time to the LOG file
            echo -e "${COMBO}\n${BUILD_RESULT_STRING} IN $(format_time "${TIME_START}" "${TIME_END}" )\n" >> "${LOG}"
        done
    done
}

parse_parameters "${@}"
the_grind
