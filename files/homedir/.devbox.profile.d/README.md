# .devbox.profile.d

Files under here are only useful if you are running a devbox workspace container.

This dir is mounted as /etc/profile.d **on the container**, not the VM, and any .sh files
are sourced on login to the container

Use this to set global env vars, or set and run common functions.
