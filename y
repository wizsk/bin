#! /bin/sh

s_t=$( echo "$*" |  sed "s/[[:space:]]/+/g" )

query="https://vid.puffyan.us/search?q=$s_t"

vid_id=$( curl -s  "$query" | grep -o "/watch?v=.*" | cut -d '"' -f 1 | head -1 )

echo "-----------------------------------------------"
echo " \"$*\"  is loading w8"
echo "  Hope yout are wathcing something good 😅"
echo "-----------------------------------------------"

mpv -fs "https://youtube.com/$vid_id"
