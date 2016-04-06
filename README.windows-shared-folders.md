# CAVEAT: syncing folders with vagrant on windows

Not something that will work out of the box ...

Be aware that the automatic syncing is one-way - _from vagrant host to coreos guest_.

Also, the only vagrant sync method that reliably works from a windows host is _rsync_. However, by default
vagrant will run rsync --delete (so if you haven't synced new files created on the guest back to the host
they will be deleted on the next `vagrant up`.

In addition rsync on windows does not currently support the ssh params that vagrant insists on sending, so you'll also need to massage some vagrant code ...

See [this issue](https://github.com/coreos/coreos-vagrant/issues/185) and [this issue](https://github.com/mitchellh/vagrant/issues/6702) for information about this.

If you need to make sync'ed folders available to windows users, this worked for me: 

* install rsync + ssh as supplied by MinGW/msys
* install git for windows (comes with git bash) although if you're using this repo, you probably already have ...
* in a git bash window, symlink the msys rsync.exe and ssh.exe to $HOME/bin/{rsync.exe,ssh.exe}
  
  e.g.
  `ln -s /c/MinGW/msys/1.0/bin/ssh.exe $HOME/bin/ssh.exe`
  `ln -s /c/MinGW/msys/1.0/bin/rsync.exe $HOME/bin/rsync.exe`

* In addition I needed to actually _change some vagrant lib code_.
  Yes. You read that right. Swallow the bile, and your pride and open this file:

  # $VAGRANT\_HOME is probably /c/Hashicorp/Vagrant on a default install
  $VAGRANT\_HOME/embedded/gems/gems/vagrant-1.8.1/plugins/synced\_folders/rsync/helper.rb


  Comment out these lines in that file:

    ```
    #          "-o ControlMaster=auto " +
    #          "-o ControlPath=#{controlpath} " +
    #          "-o ControlPersist=10m " +
    ```

* **MOST IMPORTANT**: give the devs a means to easily sync back from the coreos guest to
  the vagrant host machine's 'shared' folder.

  e.g set up an ssh server on their machine, and add a script to coreos so on shutdown
  rsync is run in the opposited direction.
  
  Alternatively, give your devs a .bat that runs an rsync or scp -r from their host machine
  and hang a _caveat emptor! Switch to Linux_ banner above your desk ...
