#!/bin/bash


DIRECTORY=$1


if [ -z ${DIRECTORY} ] || [ ! -r ${DIRECTORY} ] 
then 
echo "Bitte gültiges Verzeichnis angeben."
exit 2
fi




STR=${DIRECTORY}

length=${#STR}
last_char=${STR:length-1:1}

[[ $last_char != "/" ]] && STR="$STR/"; :

DIRECTORY=${STR}

cd ${DIRECTORY}

if [ ! -r "volumes/" ] 
then 
echo "Kein Volume Verzeichnis gefunden!"
exit 2
fi


echo " "
echo "------------------------------------------------------------------------"
echo " "
echo "     Folgende Container werden beendet und gesichert..."
echo " "
docker-compose ps
echo "------------------------------------------------------------------------"
echo " "

DATESTRING=$(date +"%Y-%m-%d-%H-%M")

docker-compose down &> /dev/null

echo "     Backup wird durchgeführt..."

rsync -Aax volumes/ backup_full_${DATESTRING}/ &> /dev/null

echo "     Backup wurde erstellt."
echo " "
echo "     Backup wird komprimiert..."
echo " "
zip -r backup_full_${DATESTRING}.zip backup_full_${DATESTRING}/ &> /dev/null

FILE="backup_full_${DATESTRING}.zip"
if [ -f "$FILE" ]
then
    echo "     Backup wurde erstellt: "
    echo " "
    echo "     backup_full_${DATESTRING}.zip"
    echo " "
    echo "     Backup muss mit 'unzip -X -K <filename>' entpackt"
    echo "     und mit 'rsync -Aaxv --delete <backupname> volumes/' wieder"
    echo "     eingespielt werden. "
    echo " "
else
    echo "     Backup wurde nicht erstellt!"
    echo " "
    echo "     Es ist ein Fehler aufgetreten."
    echo " "
fi






rm -rf backup_full_${DATESTRING}/

echo "------------------------------------------------------------------------"
echo " "
echo "     Container werden wieder gestartet..."
docker-compose up -d &> /dev/null

echo "     Backup wurde erfolgreicht erstellt."
echo " "
echo "------------------------------------------------------------------------"
echo " "