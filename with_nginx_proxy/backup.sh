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
mkdir -p backups

if [ ! -r "volumes/" ] 
then 
echo "Kein Volumes-Ordner in ${DIRECTORY}/ gefunden!"
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

rsync -Aax volumes/ backups/backup_full_${DATESTRING}/ &> /dev/null

echo "     Backup wurde erstellt."
echo " "
echo "     Backup wird komprimiert..."
echo " "

cd backups/
zip -r backup_full_${DATESTRING}.zip backup_full_${DATESTRING}/ &> /dev/null
rm -rf backup_full_${DATESTRING}/ &> /dev/null
cd ..

FILE="backups/backup_full_${DATESTRING}.zip"
if [ -f "$FILE" ]
then
    echo "     Backup wurde erstellt: "
    echo " "
    echo "     backups/backup_full_${DATESTRING}.zip"
    echo " "
    echo "     Backup muss mit 'unzip -X -K backups/<filename>' entpackt"
    echo "     und mit 'rsync -Aaxv --delete backups/<backupname>/ volumes/' wieder"
    echo "     eingespielt werden. "
    echo " "
    echo "------------------------------------------------------------------------"
    echo " "
    echo "     Container werden wieder gestartet..."
    docker-compose up -d &> /dev/null
    echo "     Backup wurde erfolgreicht erstellt."
    echo " "
    echo "------------------------------------------------------------------------"
    echo " "
else
    echo "     Backup wurde nicht erstellt!"
    echo " "
    echo "     Es ist ein Fehler aufgetreten."
    echo " "
    echo "------------------------------------------------------------------------"
    echo " "
    echo "     Container werden wieder gestartet..."
    docker-compose up -d &> /dev/null
    echo " "
    echo "------------------------------------------------------------------------"
    echo " "
fi