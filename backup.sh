#!/bin/bash
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
echo "     Backup wurde erstellt: "
echo " "
echo "     backup_full_${DATESTRING}.zip"
echo " "
echo "     Backup kann mit 'unzip -X -K <filename>' wiederhergestellt"
echo "     und mit 'rsync -Aaxv --delete <backupname> volumes/' wieder"
echo "     eingespielt werden. "
echo " "

rm -rf backup_full_${DATESTRING}/

echo "------------------------------------------------------------------------"
echo " "
echo "     Container werden wieder gestartet..."
docker-compose up -d &> /dev/null

echo "     Backup wurde erfolgreicht erstellt."
echo " "
echo "------------------------------------------------------------------------"
echo " "