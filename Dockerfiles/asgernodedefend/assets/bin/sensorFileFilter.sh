#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/defender/queue/*)
if (( ${#files} ))
then
    printf "SensorFileFilter: Found files to process\n"
    for file in "/data/defender/queue"/* ; do
        filename=`basename "$file"`
        mv -f "$file" "/data/filefilter/scan/${filename}"
        
        printf "SensorFileFilter: Processing /data/filefilter/scan/${filename}\n"

        FILE_POLICY_BLOCK=$(/usr/local/bin/detect_filetype.sh "${filename}")

        if [ $FILE_POLICY_BLOCK == "true" ]; then

            printf "  --> SensorFileFilter: File quarantined \n"
            echo "# SensorFileFilter: File quarantined after category filtering." > "/data/defender/report/${filename}.txt"
            mv -f "/data/filefilter/scan/${filename}" "/data/defender/quarantine/${filename}"
            printf "  --> SensorFileFilter: Scan report moved to /data/defender/report/${filename}.txt\n"

        else

            printf "  --> SensorFileFilter: File ok\n"

            if [ "${SENSOR_DLP}" = true ];then
            
                mv -f "/data/filefilter/scan/${filename}" "/data/dlp/queue/${filename}"
                printf "  --> SensorFileFilter: File moved to /data/dlp/queue/${filename}\n"

            elif [ "${SENSOR_MALWARE}" = true ];then

                mv -f "/data/filefilter/scan/${filename}" "/data/malware/queue/${filename}"
                printf "  --> SensorFileFilter: File moved to /data/malware/queue/${filename}\n" 

            else
            
                mv -f "/data/filefilter/scan/${filename}" "/data/defender/finish/${filename}"
                printf "  --> SensorFileFilter: File moved to /data/defender/finish/${filename}\n" 
            
            fi

        fi

    done
    printf "SensorFileFilter: Done with processing\n"
fi
