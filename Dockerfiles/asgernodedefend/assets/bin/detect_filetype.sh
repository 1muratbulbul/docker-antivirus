#!/bin/bash
# find file type

Filename=$1

FileMimeType=$(exiftool -short -veryShort -MIMEType /data/filefilter/scan/"${Filename}")
#FileMimeType=$(exiftool -short -veryShort -MIMEType "${Filename}")

case $FileMimeType in

  "application/vnd.ms-cab-compressed" | "application/gzip" | "application/x-7z-compressed" | "application/x-alz" | "application/zip" | "application/x-bzip" | "application/x-tar" | "application/x-rar" | "application/x-java-archive" | "application/x-cpio-compressed" | "application/x-compressed-tar" | "application/x-bzip-compressed-tar" | "application/x-ace" | "application/x-arj" | "application/x-lha" | "application/x-ms-wim" | "application/x-archive" | "application/x-cpio" | "application/x-lzma" | "application/x-compress" | "application/x-xz" | "application/x-egg" | "application/x-rar-compressed")
    echo -n $FILEFILTER_ARCHIVE
    ;;
  "application/rtf" | "application/x-hwp" | "application/vnd.ms-word" | "application/vnd.ms-excel" | "application/vnd.ms-powerp" | "application/vnd.ms-works" | "application/vnd.ms-publish" | "application/vnd.ms-access" | "application/vnd.openxmlformats-officedocument"* | "application/msword" | "application/vnd.visio" | "text/csv" )
    echo -n  $FILEFILTER_MSOFFICE
    ;;
  "application/vnd.sun"* | "application/vnd.oasis.opendocument"* | "application/x-karbon" | "application/x-kchart" | "application/x-kformula" | "application/x-kivio" | "application/x-kontour" | "application/x-kpresenter" | "application/x-kspread" | "application/x-kword")
    echo -n  $FILEFILTER_OPENOFFICE
    ;;
  "application/x-ms-dos-executable" | "application/x-executable" | "application/x-ms-dos-executable" | "executable/vba" | "application/x-java-jnlp-file" | "text/x-bash" | "text/x-python"* | "application/x-python-code" | "application/x-sh" | "application/x-csh" | "application/x-bat" | "application/bat" | "application/dos-exe" | "application/x-winexe" | "application/x-msdos-program" | "application/x-exe" | "application/msdos-windows" | "text/x-c" | "text/x-c++")
    echo -n  $FILEFILTER_EXECUTABLE
    ;;
  "application/x-java"* | "application/java"* )
    echo -n  $FILEFILTER_JAVA
    ;;
  "video/"* | "application/vnd.adobe.flash.movie" | "application/vnd.ms-asf" | "application/vnd.rn-realmedia" | "application/ogg" | "application/x-matroska")
    echo -n  $FILEFILTER_VIDEO
    ;;
  "audio/"*)
    echo -n  $FILEFILTER_AUDIO
    ;;
  "multipart/encrypted" | "application/pgp" | "application/pkcs7"* | "multipart/signed" | "application/openssl-encrypted-data")
    echo -n  $FILEFILTER_ENCRYPTED
    ;;
  "image/"*)
    echo -n  $FILEFILTER_IMAGE
    ;;
  "application/pdf" | "application/x-pdf")
    echo -n  $FILEFILTER_PDF
    ;;
  "font/"*)
    echo -n  $FILEFILTER_FONT
    ;;
  "text/plain")
    echo -n  $FILEFILTER_TEXT
    ;;
  "application/x-rpm" | "application/vnd.debian.binary-package")
    echo -n  $FILEFILTER_PACKAGE
    ;;
  "application/octet-stream")
    echo -n  $FILEFILTER_BINARY
    ;;
  "application/x-iso9660-image")
    echo -n  $FILEFILTER_IMAGE
    ;;
  "application/xml" | "application/xhtml+xml" | "application/x-httpd-php" | "text/javascript" | "application/json" | "application/ld+json" | "text/html" | "text/css" )
    echo -n  $FILEFILTER_HTML
    ;;
  *)
    echo -n  $FILEFILTER_UNKNOWN
    ;;
esac