#!/bin/bash
printf "Defender: Updating antivirus configuration ...\n"
sed -i -e "s/{ALERT}/0/g" /usr/local/maldetect/conf.maldet
sed -i -e "s/{EMAIL}//g" /usr/local/maldetect/conf.maldet
if [[ $# -eq 1 && $1 = *[!\ ]* ]] ; then
    email=$1
    /usr/local/install_alerts.sh $email
fi
printf "Done\n"

PATHS=(/data/defender/queue /data/defender/finish /data/defender/quarantine /data/defender/report /data/filefilter/scan /data/dlp/queue /data/dlp/scan /data/malware/queue /data/malware/scan /var/log/cron)
for i in ${PATHS[@]}; do
    mkdir -p ${i}
done

printf "Defender: Fetching latest ClamAV virus definitions ...\n"
freshclam

printf "Defender: Fetching latest Maldet malware signatures ...\n"
maldet -u -d

# start supervisors, which spawns cron and inotify launcher
printf "Defender: Starting supervisord ...\n"

/usr/bin/supervisord -c /usr/local/supervisor.conf
