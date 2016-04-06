#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
tmpSshDir=$1
userSshDir=$2
overwriteKeys=$3
authKeysFile=$userSshDir/authorized_keys
if [[ ! -d $userSshDir ]]; then
    echo "ERROR: ... destination dir $userSshDir does not exist on the VM..."
    exit 1
fi
if [[ ! -d $tmpSshDir ]]; then
    echo "ERROR: ... source dir $tmpSshDir does not exist on the VM..."
    exit 1
fi

for key in $(ls -1 $tmpSshDir | grep -v .pub)
do
    srcKey=$tmpSshDir/$key
    userKey=$userSshDir/$key
    if [[ -e ${srcKey}.pub ]]; then
        echo "Found key pair for $key. Will copy to $userSshDir unless already exists."

        for file in $srcKey ${srcKey}.pub
        do
            echo "... removing any dos crlf from $file"
            tr -d '\r' < $file > ${file}.cleaned
            tail -c1 ${file}.cleaned | read -r _ || echo >> ${file}.cleaned
            mv ${file}.cleaned $file
        done

        keyContent=$(cat $srcKey.pub | grep -v '^#')
        keyPattern=$(echo "$keyContent" | awk {'print $1 " " $2'})
        if ! grep "$keyPattern" $authKeysFile 2>/dev/null
        then
            echo "... adding key $srcKey.pub to authorized_keys"
            echo "$keyContent" >>$authKeysFile
        fi

        # ... by default don't overwrite any existing keys
        if [[ -z $overwriteKeys ]]; then
            if [[ -e ${userKey} ]]; then
                echo "... file with that name already exists under $userKey. Skipping ..."
                # ... go on to next key
                continue
            fi
            if [[ -e ${userKey}.pub ]]; then
                echo "... file with that name already exists under $userKey.pub. Skipping ..."
                # ... go on to next key
                continue
            fi
        fi

        chmod 0600 $srcKey
        chmod 0644 $srcKey.pub
        chown core:core $srcKey $srcKey.pub
        echo "... copying $srcKey and $srcKey.pub"
        mv $srcKey $srcKey.pub $userSshDir/
    fi
done
