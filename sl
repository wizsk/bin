#!/bin/env bash

# change these to your place
latitude="24.2510087"
longitude="89.9169233"

missing=""

for cmd in curl jq awk; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing="$missing $cmd"
  fi
done

if [ -n "$missing" ]; then
  echo "Error: Missing required command(s):$missing" >&2
  echo "Please install them and try again." >&2
  exit 1
fi


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

cat "$res_file" |
    jq ".data[$idx].timings" |
    grep 'Fajr\|Sunrise\|Dhuhr\|Asr\|Maghrib\|Isha' |
    awk -F'"' '
BEGIN {
  is_tty = system("[ -t 1 ]") == 0

  if (is_tty) {
    # True RGB colors: yellow → red → cyan → blue
    colors[1]="\033[38;2;248;252;106m"  # yellow
    colors[2]="\033[38;2;252;223;106m"
    colors[3]="\033[38;2;252;131;131m"  # red
    colors[4]="\033[38;2;147;247;136m"  # cyan?
    # colors[5]="\033[38;2;247;136;183m"  # purple
    colors[5]="\033[38;2;247;136;238m"
    colors[6]="\033[38;2;142;136;247m"  # blue
    reset="\033[0m"
  } else {
    for (i=1;i<=7;i++) colors[i]=""
    reset=""
  }
}

{
  split($4, t, "[ :()]") # split by any char in []
  h=t[1]; m=t[2]

  if (h==0)       { hh=12; ap="AM" }
  else if (h<12)  { hh=h;  ap="AM" }
  else if (h==12) { hh=12; ap="PM" }
  else            { hh=h-12; ap="PM" }

  i++
  printf "%s%-8s %02d:%02d %s%s\n",
         colors[i], $2 ":", hh, m, ap, reset
}'

