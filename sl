#!/bin/sh

cache="$HOME/.cache/salah_time"
url='https://hamariweb.com/islam/tangail_prayer-timing13785.aspx'

res=$(curl -s "$url" |
    grep 'data-label="Fajr"\|data-label="Sunrise"\|data-label="Dhuhr"\|data-label="Asr"\|data-label="Maghrib"\|data-label="Isha"' |
    sed -E 's/<[a-zA-Z =-]*"//; s/ *class="[0-9a-zA-Z -]*"//; s/">/ /; s/<\/td>//; s/^ +//') # ; s/<\/[a-zA-Z "=-]*>//'

if [ "$res" = "" ];then
    printf "showing cached time: "
    cat "$cache"
    exit 0
fi

printf "%s\n\n%s" "$(date)" "$res" | tee "$cache"
