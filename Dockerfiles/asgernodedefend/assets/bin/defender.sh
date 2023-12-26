#!/bin/bash
# inotify watches the queue and launches the AV scanner when new files are written, keeps the docker container running as well!
#
#  -m /data/defender/queue       monitor /data/defender/queue forever
#  -r                            watched directory recursively
#  -q                            quiet (only print events)
#  -t 0                          never timeout
#  -e moved_to,close_write       only fire if a file is moved to or written into the watched directory
#
printf "Defender: Waiting for changes to /data/defender/queue ...\n"
inotifywait -m -r -q -t 0 -e moved_to,close_write /data/defender/queue |
while read -r path action file; do
     /usr/local/bin/sensorFileFilter.sh
     /usr/local/bin/sensorDLP.sh
     /usr/local/bin/sensorMalware.sh
done