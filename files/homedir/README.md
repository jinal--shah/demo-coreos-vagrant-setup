# homedir
[1]: https://github.com/opsgang/docker_devbox_aws "devbox workspace container with aws tools"

_drop your own .bashrc, .gitconfig, .ssh or .aws dirs, or login scripts in here_

These will be copied across to your vm.

If you use devbox, these will be mounted automatically on your workspace container.

CRLF endings from files created on windows are dealt with on the remote end ;)

.sh files dropped under profile.d will be sourced on login to the VM.

See files/homedir/profile.d/README.md for more info.


Files under .devbox.profile.d are for use with [devbox workspace containers] [1]
to be mounted under /etc/profile.d on the container.

Additionaly, if you run the `devbox` shell function to launch a devbox container,
your own .gitconfig, .ssh and .aws will be available in the container regardless
of which user you run the container as.

