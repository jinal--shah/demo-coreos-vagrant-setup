# .gnupg

Drop in your .gnupg dir here

## gnupg - useful cmds

gpg --list-keys

gpg --list-secret-keys --keyid-format LONG

# export private key to STDOUT
gpg --export-secret-keys -a <key id> (use val from list-keys)

# export public key to file
gpg --armor --export <PASTE_LONG_KEY_HERE> > gpg-key.txt

See also: https://gist.github.com/ankurk91/c4f0e23d76ef868b139f3c28bde057fc

# in .bashrc
export GPG_TTY=$(tty)

# in git config:
    [user]
        name = jinal--shah
        email = jnshah@gmail.com
        signingkey = 6F26BEC06E008008

    [commit]
        gpgsign = true
    [gpg]
        program = /usr/bin/gpg2

