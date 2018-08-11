supported_devices=(
  'angler'
  'cheeseburger'
  'dragon'
  'dumpling'
  'flo'
  'hammerhead'
  'marlin'
  'nash'
  'oneplus3'
  'potter'
  'shamu'
  'taimen'
  'tenderloin'
)

for device in ${supported_devices[@]}; do
    add_lunch_combo du_${device}-user
    add_lunch_combo du_${device}-userdebug
done
