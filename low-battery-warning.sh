#!/bin/bash
# Show a notification on the sceen when battery level drops below a given treshold.

BATTERYINFO=$(acpi -b | sed 's/^Battery [0-9]\+: \(Charging\|Discharging\|Full\), \([0-9]\{1,3\}\)%, rate .*/\1#\2/')
BATTERYSTATUS=$(echo "$BATTERYINFO" | cut -d '#' -f1) # Charging, Discharging or Full
BATTERYLEVEL=$(echo "$BATTERYINFO" | cut -d '#' -f2)  # 0-100%
DISP=1 # The display where the message will be shown.

# Check if battery is discharging
if [[ "$BATTERYSTATUS" == "Discharging" ]]
then 
	# Check if battery-level is below 25% and greater than 10%
	if [[ "$BATTERYLEVEL" -le 25 && "$BATTERYLEVEL" -gt 10 ]]
	then
		# Select display
		export DISPLAY=:$DISP
		# Show warning message	
		/usr/bin/notify-send "Low battery" "Battery level is $BATTERYLEVEL%" -i battery-low
		exit 0
	fi
	# Check if battery-level is below 10%
	if [[ "$BATTERYLEVEL" -le 10 ]]
	then
		# Select display
		export DISPLAY=:$DISP
		# Show warning message	
		/usr/bin/notify-send "Very low battery" "Battery level is $BATTERYLEVEL%" -i battery-caution
		exit 0 
	fi
fi
