# EXAMPLES: vagrant + coreos for dev workspaces

__The base vagrant / coreos parts of this repo are shamelessly ripped from the__
__far superior [coreos-vagrant](https://github.com/coreos/coreos-vagrant/) repo__ 

## Why?

_Full Disclosure: I love [coreos](https://coreos.com/using-coreos/). If coreos was a person, I'd be arrested for stalking ..._

... However getting dev teams up to speed on using it and containers generally can sometimes be
, um, _time consuming_, particularly when not everyone is running \*nix.

## What?

I use this repo to demonstrate how to
* customise the [coreos-vagrant](https://github.com/coreos/coreos-vagrant/) project to handle
  * users with different git core.autocrlf settings on different o/s
  * automated distribution of personal ssh keys, 
  * example functions to make fleet cluster navigation easier
* automate creation of ephemeral [Docker](https://www.docker.com/what-docker) 'workspaces'
  with volumes shared from the coreos host (and synced with folders on their physical workstation)

This is not a fork, only a limited use-case example.

## _What did you do?_


Vagrantfile is modified to account for new features below

### ssh_keys

Put your cluster adm ssh public and private keys in here (and any others you wish
to use to access this coreos VM as well).


### cluster adm helper functions

Your .bashrc will get replaced by files/.bashrc.

This provides a few useful shortcut functions, to help navigate the different clusters.

### development workspaces

There is a simple example of a docker file that provides an ephemeral workspace. You are expected
to use `docker -v /some/projectdir/on/coreos:/projectdir` to make your src (or other tools) available
and persist longer than the docker container.

There is a shell helper function `devbox` as part of the deployed [.bashrc](files/.bashrc).
This drops the user in to a docker container with user-defined volumes mapped from the coreos host.

## See Also

* [automating distribution of ssh keys](files/ssh_keys/README.ssh_keys.md)
* [example helper functions for cluster navigation](files/.bashrc)
* [example Dockerfile for a basic workspace](files/builds/docker/images/dev_basic/Dockerfile)
* [useful info for vagrant shared/synced folders on Windows](README.windows-shared-folders.md)
