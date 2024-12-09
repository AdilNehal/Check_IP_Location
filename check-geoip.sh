#!/bin/bash

#Counting number of failed login attempts from an IP

LIMIT='10'
LOG_FILE="${1}"

#Making sure file is supplied
if [[ ! -e "$LOG_FILE"  ]];then
	echo "can't open log file ${LOG_FILE}" >&2
	exit 1
fi

#CSV header
echo 'Count,IP,Location'

cat syslog-sample | grep -i Failed | awk -F 'from ' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -n | while read COUNT IP
do
	if [[ "${COUNT}" -gt "$LIMIT" ]]
	then
		LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
		echo "${COUNT},${IP},${LOCATION}"
	fi
done
exit 0
