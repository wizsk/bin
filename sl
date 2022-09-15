#!/bin/sh
curl -s 'https://hamariweb.com/islam/tangail_prayer-timing13785.aspx' | grep 'data-label="Fajr"\|data-label="Sunrise"\|data-label="Dhuhr"\|data-label="Asr"\|data-label="Maghrib"\|data-label="Isha"' | sed  's/<td\ data-label="/\ \ \ \ / ; s/">/\ / ; s/<\/td>// ; s/" class="border-0//'
