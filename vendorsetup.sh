supported_devices=(
  'cheeseburger'
  'dragon'
  'dumpling'
  'flo'
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
