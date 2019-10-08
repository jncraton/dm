#!/bin/sh

echo "display mode (dm) usage:"
echo "    dm l - laptop only"
echo "    dm x - extended"
echo "    dm c - cloned"
echo ""

layout=$1

# Find display names for connected internal and external displays
internal=$(xrandr -q | grep " connected" | sed -n 1p | cut -d " " -f1)
external=$(xrandr -q | grep " connected" | sed -n 2p | cut -d " " -f1)

echo "Detected connected internal display $internal."

if [ $external ]
then
  echo "Detected connected external display $external." 
fi

# Disable all disconnected displays
for display in $(xrandr -q | grep disconnected | cut -d " " -f1)
do
  echo "Disabling $display."
  xrandr --output $display --off
done

# Apply the desired layout
if [ ! $external ] || [ "$layout" = "laptop" ] || [ "$layout" = "l" ]
then
  echo "Setting single display layout. $internal will be the active display."
  if [ $external ]
  then
    echo "Disabling connected external display $external."
    xrandr --output $external --off
  fi
else
  if [ "$layout" = "clone" ] || [ "$layout" = "c" ]
  then
    echo "Setting cloned layout. $internal will be the same as $external."
    xrandr --output $internal --auto
    xrandr --output $external --auto --same-as $internal
  else
    echo "Setting extended layout. $external will be to the right of $internal."
    xrandr --output $internal --auto
    xrandr --output $external --auto --right-of $internal
  fi
fi
