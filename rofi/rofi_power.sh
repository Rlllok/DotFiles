#! /bin/sh

options=$(printf "󰐥 Power Off\n󰜉 Restart\n󰍃 Log Out" | rofi -dmenu -p "Power Menu: ")

case "$options" in
  "󰐥 Power Off") poweroff ;;
  "󰜉 Restart") reboot ;;
  "󰍃 Log Out") hyprctl dispatch exit ;;
  *) exit 1 ;;
esac
