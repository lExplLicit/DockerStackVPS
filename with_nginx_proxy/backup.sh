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
echo " "

rsync -Aax volumes/ backups/${DIRECTORY_NAME}_${DATESTRING}/ &> /dev/null

DIR="backups/${DIRECTORY_NAME}_${DATESTRING}"
if [ -r "$DIR" ]
then
    echo "     Backup wurde erstellt: "
    echo " "
    echo "     backups/${DIRECTORY_NAME}_${DATESTRING}/"
    echo " "


    cd backups/
    rm -f ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    touch ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    chmod +x ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "#!/bin/bash" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh

    echo "FILE=docker-compose.yml" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "if [ ! -f "$FILE" ]" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "then" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "echo \"$FILE does not exist. Please run this script in the container directory\"" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "exit 2" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "fi" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh

    echo "docker-compose down" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "rsync -Aaxv --delete backups/${DIRECTORY_NAME}_${DATESTRING}/ volumes/" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    echo "docker-compose up -d" >> ${DIRECTORY_NAME}_${DATESTRING}/restore.sh
    cd ..

    cd volumes/
    rm -f restore.sh
    cd ..

    echo "     Backup kann mit:"
    echo " "
    echo "     cd ${DIRECTORY_NAME}/ && ./backups/${DIRECTORY_NAME}_${DATESTRING}/restore.sh"
    echo " "
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