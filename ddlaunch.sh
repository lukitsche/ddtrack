#!/bin/sh

DDNETDIR="$HOME/.local/share/ddnet"
MAPTIME="$DDNETDIR/maptime"
if [ ! -d $MAPTIME ]; then
	mkdir -p $MAPTIME
fi
regex_enter="^([[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}) I motd: │ Map: (.*)$"
regex_leave="^([[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}) I client: disconnecting."
seconds=0
initial_seconds=0
pid=0
DDNet |
	while read line; do
		if [[ $line =~ $regex_enter ]]; then
			time_enter=${BASH_REMATCH[1]}
			map=${BASH_REMATCH[2]/ /_}.txt # replace space with _
			echo "entered $map at $time_enter." >> $MAPTIME/log.txt
			if [ -f $MAPTIME/$map ]; then
				initial_seconds=$(cat $MAPTIME/$map)
			else
				initial_seconds=0
			fi
			# check for old counter still running
			if [[ $pid != 0 ]]; then
				if $(ps -p $pid > /dev/null)
				then
					echo "there is already a counter running with process id $pid. killing..."
					kill $pid
				fi
			fi
			while sleep 1s; do
				seconds=$((initial_seconds + $(date -d "now" +%s) - $(date -d "$time_enter" +%s)))
				echo $seconds > $MAPTIME/$map
				echo $seconds | dc -e '?60~r60~r[[0]P]szn[:]ndZ2>zn[:]ndZ2>zp' > $MAPTIME/current.txt
			done&
			pid=$!
		elif [[ $line =~ $regex_leave ]]; then
			kill $pid
			time_leave=${BASH_REMATCH[1]}
			echo "left $map at $time_leave." >> $MAPTIME/log.txt
			map=""
			seconds=0
			initial_seconds=0
			rm $MAPTIME/current.txt
		fi
	done;


##example log
########2024-01-31 09:17:58 I motd: │ Map: Destruction
########2024-01-31 09:19:04 I client: disconnecting. reason='unknown'
########2024-01-31 09:19:05 I motd: │ Map: Multeasymap
########2024-01-31 09:19:51 I client: disconnecting. reason='unknown'
#grep -E ^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2} I motd: │ Map: .*$ track.txt
#echo $(($(date -d "today" +%s)-$(date -d "yesterday" +%s)))
