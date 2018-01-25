#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
user=$1
tmpDir=$2
homeDir=$3
from_windows=${4:true}

s=$tmpDir/.ssh 
g=$tmpDir/.gnupg

# ... convert any dos files to *nix
files_to_convert=$(find $tmpDir -type d \( -path $tmpDir/.gnupg -o -path $tmpDir/.ssh \) -prune -o -type f -print)
for file in $files_to_convert ; do
    tr -d '\r' < $file > ${file}.cleaned
    tail -c1 ${file}.cleaned | read -r _ || echo >> ${file}.cleaned
    mv ${file}.cleaned $file
done


if [[ -d $s ]]; then
    chmod 0700 $s
    find $s -type f -name 'id_*' -a ! -name '*.pub' -exec chmod 0600 {} \;
    chmod 0600 $s/config || true
fi

if [[ -d $g ]]; then
    touch $g/S.gpg-agent{,.browser,.extra,.ssh}
    chmod 0700 $g
    chmod 0600 $g/*.conf || true
    find $g -type d -exec chmod 0700 {} \;
    find $g -type f -name '*.key' -exec chmod 0600 {} \;
    find $g -type f -name '*.rev' -exec chmod 0600 {} \;
    find $g -type f -name 'S.gpg-agent*' -exec chmod 0700 {} \;
    find $g -type f -name 'trustdb.gpg' -exec chmod 0600 {} \;
    find $g -type f -name 'pubring.kbx' -exec chmod 0644 {} \;
    find $g -type f -name 'pubring.kbx~' -exec chmod 0700 {} \;
fi

chown -R $user:$user $tmpDir/

cp -a --remove-destination $tmpDir/. $homeDir
