#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[[ -f ~/.Xresources ]] && xrdb ~/.Xresources

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 96

xset r rate 220 60

picom -b -d :0 -O 1.0 -I 1.0

eval $(ssh-agent)

exec awesome
