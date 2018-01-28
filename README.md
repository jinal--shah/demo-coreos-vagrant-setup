# EXAMPLES: vagrant + CoreOS for dev workspaces
[1]: https://github.com/opsgang/docker_devbox_aws "devbox workspace container with aws tools"
[2]: https://github.com/jinal--shah/devbox_aws_coreos "devbox workspace container for working with CoreOS in aws"

__The base vagrant / CoreOS parts of this repo are shamelessly ripped from the__ 
__[CoreOS-vagrant](https://github.com/CoreOS/CoreOS-vagrant/) repo__ 

## Why?

Working with applications running on CoreOS, it can be useful to run your own
local instance for emulating issues or developing automation for it.

### Customised homedir assets / login config

This variation of the official repo lets you configure the core user's home dir as you'd like.
So you can drop your own .aws dir, .ssh, .gitconfig or profile.d scripts without mounting
from your host to theh VM.

It will also handle files in the homedir with Windows line-endings correctly.

### devbox workspaces

There is a shell helper function `devbox` as part of the deployed [.bashrc](files/homedir/.bashrc).
This drops the user in to a docker container with user-defined volumes mapped from the CoreOS host.

See the [devbox\_aws][1] and my derived [devbox\_aws\_coreos][2] containers for more information.

I use the latter to develop automation for dockerised apps on AWS - running on CoreOS instances, naturally ;)

However the default opsgang/devbox\_aws:stable image used by the `devbox` function is os-agnostic.

## shell functions (.bashrc)

* forwardSsh(): creates an ssh-agent (or will re-use an existing one)
    adding all of the keys under the core user's .ssh dir.

* devbox(): drops the user in to a new named container, or in to an existing one
    of the same name. You can export the following 2 vars to your env before calling devbox()

    * $DEFAULT\_DEVBOX\_IMAGE defaults to opsgang/devbox\_aws - set this to your own
        custom one as desired.
	
    * $DEFAULT\_DEVBOX\_USER defaults to `root` - set this to the user appropriate for your DEVBOX\_IMAGE
