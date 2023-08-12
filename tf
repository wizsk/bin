#!/bin/sh


file="/tmp/tmp-${RANDOM}.${1}"

nvim $file

rm $file 2> /dev/null
