# Customisations to default CoreOS Vagrant box

# Vagrantfile

Vagrantfile is modified to account for new features below

## ssh_keys

Put your cluster adm ssh public and private keys in here (and any others you wish
to use to access this coreos VM as well).

See [here for more info](files/ssh_keys/README.ssh_keys.md).

## cluster adm helper functions

Your .bashrc will get replaced by files/.bashrc.

This provides a few useful shortcut functions, to help navigate the different clusters.

# development workspaces

There is a simple example of a docker file that provides an ephemeral workspace. You are expected
to use `docker -v /some/projectdir/on/coreos:/projectdir` to make your src (or other tools) available
and persist longer than the docker container.
