BACKUP_DIRECTORY=$1
ZIEL_DIRECTORY=$2

if [ -z ${BACKUP_DIRECTORY} ] || [ ! -f ${BACKUP_DIRECTORY} ] 
then 
echo "Bitte gültiges Backup Archiv angeben."
exit 2
fi

if [ -z ${ZIEL_DIRECTORY} ] || [ ! -r ${ZIEL_DIRECTORY} ] 
then 
echo "Bitte gültiges Zielverzeichnis angeben."
exit 2
fi

STR=${ZIEL_DIRECTORY}
length=${#STR}
last_char=${STR:length-1:1}
[[ $last_char != "/" ]] && STR="$STR/"; :
ZIEL_DIRECTORY=${STR}


unzip -X -V -q ${BACKUP_DIRECTORY}
rsync -Aaxv --delete ${BACKUP_DIRECTORY:0:length-4}/ ${ZIEL_DIRECTORY}
