# ssh_keys

Used by Vagrant to add your own keys to the VM's authorized keys file
and the core user's .ssh dir.

Put your cluster adm ssh public and private keys in here (and any others you wish
to use to access this coreos VM as well).

The ssh_keys folder in this project under files/ssh_keys should contain
*openssl* style ssh key-pairs i.e. a key and the .pub counterpart.

Vagrant will make sure the .pub keys are added to the VM's authorized_keys file
as well as adding the keys to the _core_ user's .ssh dir.

## MASSIVE CAVEAT

*Just don't go pushing your private keys in to public version control ...*

(The .gitignore will only allow additions of changes to this README or .pub files
under files/ssh_keys/)

**Pro-tip**: Use this to add the key-pair you use to access the cluster

**Bonus Pro-tip** : Use this to add your _putty_ (or other client's) key-pair.
You will need to export any putty keys as openssl keys (use puttygen for this)

