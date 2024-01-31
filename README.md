# ddtrack
Track how much time you've spent on which map (locally).

## Usage
You need to use linux and check for your ddnet folder. The script assumes it is at ~/.local/share/ddnet.
Use the script to launch your client. It will save the number of seconds you've played on a certain map to
`~/.local/share/ddnet/maptimes/$mapname.txt`. Additionally the file current.txt in the same folder holds
a better formatted time count for the current map.

## Bugs
The script assumes there will always be a disconnect message in stdout, when leaving a server.
It also writes every second to the current maptime file.

## Resources
* Print date format: https://stackoverflow.com/a/54541337/13259463
* Check for running process: https://stackoverflow.com/a/15774758/13259463
* Get pid of background process: https://stackoverflow.com/a/1911387/13259463
* Bash: https://learnxinyminutes.com/docs/bash/

## Notes
I believe it would also be possible to use the following script: https://github.com/ddnet/ddnet-scripts/blob/master/servers/scripts/teeworlds.py.
It is a python2 script that I think runs the page https://ddnet.org/status/.
However I didn't want to dig into python or python2 and into the script.
Also doing it locally has a lower digital footprint.

