#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
user=$1
tmpDir=$2
homeDir=$3
from_windows=${4:true}

s=$tmpDir/.ssh 

# ... convert any dos files to *nix
for file in $(find $tmpDir -type f); do
    tr -d '\r' < $file > ${file}.cleaned
    tail -c1 ${file}.cleaned | read -r _ || echo >> ${file}.cleaned
    mv ${file}.cleaned $file
done


if [[ -d $s ]]; then
    chmod 0700 $s
    find $s -type f -name 'id_*' -a ! -name '*.pub' -exec chmod 0600 {} \;
    chmod 0600 $s/config || true
fi

chown -R $user:$user $tmpDir/

cp -a --remove-destination $tmpDir/. $homeDir
