#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
user=$1
tmpDir=$2
homeDir=$3
from_windows=${4:true}

s=$tmpDir/.ssh 

cd $tmpDir

# ... convert any dos files to *nix
for f in $(find . -type f); do
    tr -d '\r' < $file > ${file}.cleaned
    tail -c1 ${file}.cleaned | read -r _ || echo >> ${file}.cleaned
    mv ${file}.cleaned $file
done


if [[ -d $s ]]; then
    chmod 0700 $s
    (
        rc=0
        cd $s
        chmod 0600 config 2>/dev/null
        for file in $(ls -1 id_* | grep -v '.pub$'); do
            chmod 0600 $file;
        done 
    )
fi

chown -R $user:$user $tmpDir/

cp -a --remove-destination $tmpDir/. $homeDir/
