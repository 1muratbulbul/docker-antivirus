#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/dlp/queue/*)
if (( ${#files} ))
then
    printf "SensorDLP: Found files to process\n"
    for file in "/data/dlp/queue"/* ; do
        filename=`basename "$file"`
        mv -f "$file" "/data/dlp/scan/${filename}"
        
        printf "SensorDLP: Processing /data/dlp/scan/${filename}\n"

        DLP_POLICY_BLOCK=$(/usr/local/bin/detect_bjlabel.sh "${filename}")

        if [ $DLP_POLICY_BLOCK == "true" ]; then

            printf "  --> SensorDLP: File quarantined \n"
            echo "# SensorDLP: File quarantined as a result of file classification policy." > "/data/defender/report/${filename}.txt"
            mv -f "/data/dlp/scan/${filename}" "/data/defender/quarantine/${filename}"
            printf "  --> SensorDLP: Scan report moved to /data/defender/report/${filename}.txt\n"

        else

            printf "  --> SensorDLP: File ok\n"

            if [ "${SENSOR_MALWARE}" = true ];then
            
                mv -f "/data/dlp/scan/${filename}" "/data/malware/queue/${filename}"
                printf "  --> SensorDLP: File moved to /data/malware/queue/${filename}\n"

            else
            
                mv -f "/data/dlp/scan/${filename}" "/data/defender/finish/${filename}"
                printf "  --> SensorDLP: File moved to /data/defender/finish/${filename}\n" 
            
            fi

        fi

    done
    printf "SensorDLP: Done with processing\n"
fi