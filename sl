#!/bin/sh

cache="$HOME/.cache/salah_time"

res=$(curl -Ls 'http://api.aladhan.com/v1/timingsByCity?city=Tangail&country=Bangladesh&method=4&adjustment=1' |
    jq .data.timings |
    sed -E 's/[{}",]//g; s/^\ +//; /^$/d')

if [ "$res" = "" ];then
    printf "showing cached time: "
    cat "$cache"
    exit 0
fi

printf "%s\n\n%s\n" "$(date)" "$res" | tee "$cache"
