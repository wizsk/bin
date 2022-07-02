#! /bin/sh

# Raper script for mpv temp

[ "$1" = "-t" ] && yt="ytfzf -t" || yt="ytfzf"

echo "-----------------------------------------------"
echo " \"$*\"  is loading w8"
echo "  Hope you are wathcing something good 😅"
echo "-----------------------------------------------"
link=$( $yt -I -L $* )
mpv "$link"
