#!/bin/env bash

# change these to your place
latitude="24.2510087"
longitude="89.9169233"


year=$(date '+%Y')
month=$(date '+%m' | sed 's/^0//')
day=$(date '+%d' | sed 's/^0//')
month_name=$(date '+%B')

res_file="$HOME/.cache/salah_time_$(date '+%B_%Y').json"

# using hanafi
api_url="https://api.aladhan.com/v1/calendar/$year/$month?method=1&school=1&latitude=$latitude&longitude=$longitude"

# check if already have the data; then get it
if [ ! -s "$res_file" ]; then
    if ! command -v curl &> /dev/null; then
        echo "curl not found, please install curl!"
        exit 1
    fi

    http_code=-1
    temp_file=$(mktemp)

    echo "Attempting to fetch data using curl for the month of $month_name"
    echo "Wait... This happens once every Month. This may take some time..."
    http_code=$(curl -s -w "%{http_code}" -o "$temp_file" "$api_url")

    if [ "$http_code" -eq 200 ]; then
        mv "$temp_file" "$res_file"
        echo "Success! Data saved to $res_file"
        echo
    else
        echo "Error: curl returned HTTP status code $http_code" >&2
        rm -f "$temp_file"
        exit 1
    fi
fi

idx=$(($day - 1))
data_file=$(mktemp)
cat "$res_file" | jq ".data[$idx].timings" | sed '/[{}]/d; s/^ *//; s/[",]//g; s/ *(.*)//' > $data_file

while read -r l
do
    name=$(echo $l | cut -d ':' -f 1)
    case "$name" in
        Fajr | Sunrise | Dhuhr | Asr | Sunset | Maghrib | Isha)

        # converiting to AM/PM format
        hour=$(echo $l | cut -d ':' -f 2 | sed 's/^[ 0]*//')
        min=$(echo $l | cut -d ':' -f 3)

        if [ "$hour" -gt 12 ]; then
            t="$(($hour - 12)):$min PM" # do not need to care about leading 0
        else
            t="$hour:$min AM"
        fi

        echo "$name: $t"
        ;;
    esac

    # skip these for now
    # Imsak
    # Midnight
    # Firstthird
    # Lastthird
done < "$data_file"

rm "$data_file"
