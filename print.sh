initial_time=$(date -d "today" +%s)-$(date -d "yesterday" +%s)
seconds=$initial_time
while sleep 1s; do
	echo $initial_time | dc -e '?1~r60~r60~r[[0]P]szn[:]ndZ2>zn[:]ndZ2>zn[[.]n]sad0=ap';
	((seconds++))
done
