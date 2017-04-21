# EXAMPLES: vagrant + coreos for dev workspaces
[1]: https://github.com/opsgang/docker_devbox_aws "devbox workspace container with aws tools"
[2]: https://github.com/jinal--shah/devbox_aws_coreos "devbox workspace container for engineers working with coreos in aws"

__The base vagrant / coreos parts of this repo are shamelessly ripped from the__
__far superior [coreos-vagrant](https://github.com/coreos/coreos-vagrant/) repo__ 

## Why?

Working with applications running on coreos, it can be useful to run your own
local instance for emulating issues or developing automation for it.

### Customised homedir assets / login config

This variation of the official repo lets you configure the core user's home dir as you'd like.
So you can drop your own .aws dir, .ssh, .gitconfig or profile.d scripts without mounting
from your host to theh VM.

It will also handle files in the homedir with Windows line-endings correctly.

### devbox workspaces

There is a shell helper function `devbox` as part of the deployed [.bashrc](files/.bashrc).
This drops the user in to a docker container with user-defined volumes mapped from the coreos host.

See the [devbox\_aws] [1] and my derived [devbox\_aws\_coreos] [2] containers for more information

I use these to develop automation for dockerised apps on AWS - running on coreos instances, naturally ;)

However the default opsgang/devbox\_aws:stable image used by the `devbox` function is os-agnostic.

## helper functions (.bashrc)

There are a bunch of `fleet` helper functions, to make cluster navigation easier.

Additionally the forwardSsh() shell function will create an ssh-agent (or re-use any existing one)
adding all of the keys under the core user's .ssh dir.

