devices=('blueline' 'bonito' 'coral' 'crosshatch' 'emulator' 'lake' 'lavender' 'marlin' 'potter' 'river' 'sunfish' 'taimen')

function lunch_devices() {
    add_lunch_combo du_${device}-user
    add_lunch_combo du_${device}-userdebug
}

for device in ${devices[@]}; do
    lunch_devices
done
