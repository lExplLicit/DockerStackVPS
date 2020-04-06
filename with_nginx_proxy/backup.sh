#!/bin/bash


DIRECTORY=$1


if [ -z ${DIRECTORY} ] || [ ! -r ${DIRECTORY} ] 
then 
echo "Bitte gültiges Verzeichnis angeben."
exit 2
fi


STR1=${DIRECTORY}

length=${#STR1}
last_char=${STR1:length-1:1}

[[ $last_char != "/" ]] && STR1="$STR1/"; :

DIRECTORY=${STR1}


STR2=${DIRECTORY}

length=${#STR2}
last_char=${STR2:length-1:1}

[[ $last_char == "/" ]] && STR2=${STR2:0:length-1}; :

DIRECTORY_NAME=${STR2}


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

rsync -Aax volumes/ backups/${DIRECTORY_NAME}_${DATESTRING}/ &> /dev/null

# echo "     Backup wurde erstellt."
echo " "
#echo "     Backup wird komprimiert..."
#echo " "

#cd backups/
#zip -r backup_${DATESTRING}.zip backup_${DATESTRING}/ &> /dev/null
#rm -rf backup_${DATESTRING}/ &> /dev/null
#cd ..

#FILE="backups/backup_${DATESTRING}.zip"
DIR="backups/${DIRECTORY_NAME}_${DATESTRING}"
#if [ -f "$FILE" ]
if [ -r "$DIR" ]
then
    echo "     Backup wurde erstellt: "
    echo " "
    #echo "     backups/backup_${DATESTRING}.zip"
    echo "     backups/${DIRECTORY_NAME}_${DATESTRING}/"
    echo " "
    #echo "     Backup muss mit 'unzip -X -K backups/<filename>' entpackt"
    #echo "     und mit 'rsync -Aaxv --delete backups/<backupname>/ volumes/' wieder"
    echo "     Backup kann mit:"

    cd backups/
    rm -f ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh
    touch ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh
    chmod +x ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh

    echo "#!/bin/bash" >> ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh
    echo "docker-compose down" >> ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh
    echo "rsync -Aaxv --delete backups/${DIRECTORY_NAME}_${DATESTRING}/ volumes/" >> ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh
    echo "docker-compose up -d" >> ${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh
    echo " "
    echo "     cd nextcloud/"
    echo "     ./backups/${DIRECTORY_NAME}_${DATESTRING}/restorescript.sh"
    echo " "
    cd ..

    echo "     wieder eingespielt werden. "
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