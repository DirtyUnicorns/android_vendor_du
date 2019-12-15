devices=('blueline' 'bonito' 'coral' 'crosshatch' 'dragon' 'emulator' 'marlin' 'oneplus3' 'potter' 'sargo' 'taimen')

function lunch_devices() {
    add_lunch_combo du_${device}-user
    add_lunch_combo du_${device}-userdebug
}

for device in ${devices[@]}; do
    lunch_devices
done
