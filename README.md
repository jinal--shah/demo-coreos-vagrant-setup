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
  * functions to make fleet easier
* automate creation of ephemeral [Docker](https://www.docker.com/what-docker) 'workspaces'
  with volumes shared from the coreos host (and synced with folders on their physical workstation)

This is not a fork, only a limited use-case example.

## See Also

* [automating distribution of ssh keys](files/ssh_keys/README.ssh_keys.md)
