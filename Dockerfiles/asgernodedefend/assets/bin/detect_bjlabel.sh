#!/bin/bash
# find Boldon James Classification label

Filename=$1
uuid=""

BjDocumentSecurityLabel=$(exiftool -short -veryShort -BjDocumentSecurityLabel /data/dlp/scan/"${Filename}")

# file has no BJ Label. Check BJ element uid
if [ -z $BjDocumentSecurityLabel ];then

    BjDocumentSecurityLabel="unclassified"

    printf "  --> SensorDLP: Classification label is not detected for ${Filename}. Performing element uid extraction process.\n"

    FileMimeType=$(exiftool -short -veryShort -MIMEType /data/dlp/scan/"${Filename}")
    
    case $FileMimeType in
    
        "application/vnd.ms-cab-compressed" | "application/gzip" | "application/x-7z-compressed" | "application/x-alz" | "application/zip" | "application/x-bzip" | "application/x-tar" | "application/x-rar" | "application/x-java-archive" | "application/x-cpio-compressed" | "application/x-compressed-tar" | "application/x-bzip-compressed-tar" | "application/x-ace" | "application/x-arj" | "application/x-lha" | "application/x-ms-wim" | "application/x-archive" | "application/x-cpio" | "application/x-lzma" | "application/x-compress" | "application/x-xz" | "application/x-egg" | "application/x-rar-compressed")

            # get element uid
            uuid=$(exiftool -short -veryShort -Comment /data/dlp/scan/"${Filename}"|grep -o '<element uid="[^"]*"'|awk -F'"' '{print $2}')
            ;;
        *)
            # get element uid
            BjLabelRefreshRequired=$(exiftool -short -veryShort -BjLabelRefreshRequired /data/dlp/scan/"${Filename}")

            if [ $BjLabelRefreshRequired == "FileClassifier" ];then
                uuid=$(exiftool -short -veryShort -BjDocumentLabelXML /data/dlp/scan/"${Filename}"|grep -o '<element uid="[^"]*"'|awk -F'"' '{print $2}')
            fi
            ;;
    esac

    # uid has value
    if [[ $uuid =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then

        printf "  --> SensorDLP: Classification uid is detected for ${Filename} as ${uuid}\n"

        case $uuid in
            "${BOLDONJ_LABEL_1_UID}")
                BjDocumentSecurityLabel="${BOLDONJ_LABEL_1}"
                ;;
            "${BOLDONJ_LABEL_2_UID}")
                BjDocumentSecurityLabel="${BOLDONJ_LABEL_2}"
                ;;
            "${BOLDONJ_LABEL_3_UID}")
                BjDocumentSecurityLabel="${BOLDONJ_LABEL_3}"
                ;;
            "${BOLDONJ_LABEL_4_UID}")
                BjDocumentSecurityLabel="${BOLDONJ_LABEL_4}"
                ;;
            "${BOLDONJ_LABEL_5_UID}")
                BjDocumentSecurityLabel="${BOLDONJ_LABEL_5}"
                ;;
            *)
                BjDocumentSecurityLabel="unclassified"
                ;;
        esac

    fi
    

else

    uuid=$(exiftool -short -veryShort -BjDocumentLabelXML-0 /data/dlp/scan/"${Filename}"|grep -o '<element uid="[^"]*"'|awk -F'"' '{print $2}')

    if [[ $uuid =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then

        printf "  --> SensorDLP: Updating uid value for \"${BjDocumentSecurityLabel}\" label as ${uuid}\n"

        # update label's element uid
        case $BjDocumentSecurityLabel in
            "${BOLDONJ_LABEL_1}")
                export BOLDONJ_LABEL_1_UID="${uuid}"
                ;;
            "${BOLDONJ_LABEL_2}")
                export BOLDONJ_LABEL_2_UID="${uuid}"
                ;;
            "${BOLDONJ_LABEL_3}")
                export BOLDONJ_LABEL_3_UID="${uuid}"
                ;;
            "${BOLDONJ_LABEL_4}")
                export BOLDONJ_LABEL_4_UID="${uuid}"
                ;;
            "${BOLDONJ_LABEL_5}")
                export BOLDONJ_LABEL_5_UID="${uuid}"
                ;;
        esac

    fi


fi

printf "  --> SensorDLP: Classification label is \"${BjDocumentSecurityLabel}\" for ${Filename}\n"

# time to decide
if [ "${BjDocumentSecurityLabel}" == "unclassified" ];then

    if [ $DLP_MODE_UNCLASSIFIED == "block" ];then
        echo -n true
    else
        echo -n false
    fi

else

    if [ "${BjDocumentSecurityLabel}" == "${BOLDONJ_LABEL_1}" ] || [ "${BjDocumentSecurityLabel}" == "${BOLDONJ_LABEL_2}" ] || [ "${BjDocumentSecurityLabel}" == "${BOLDONJ_LABEL_3}" ] || [ "${BjDocumentSecurityLabel}" == "${BOLDONJ_LABEL_4}" ] || [ "${BjDocumentSecurityLabel}" == "${BOLDONJ_LABEL_5}" ];then

        if [ $DLP_MODE == "block" ];then
            echo -n true 
        else
            echo -n false
        fi

    else

        if [ $DLP_MODE == "block" ];then
            echo -n false 
        else
            echo -n true
        fi

    fi

fi