# $HOME/profile.d


_drop in any additions, or amendments to the .bashrc here_

(The .bashrc will source all files in here)

If you split stuff in to multiple files, and order of
sourcing matters, then prefix the file names with numbers
so they run in the desired order.

# EXAMPLE - build a missing docker image on login.

# drop this file in to your files/homedir/profile.d dir
    
        # sourced by ~/.bashrc - builds my own customised devbox docker image
        # if it doesn't already exist ...

        devbox_build() {

            DI=jinal--shah/devbox_aws_coreos:candidate
            if docker images --format '{{.Repository}}:{{.Tag}}' | grep "^$DI" >/dev/null 2>&1
            then
                echo "... found image $DI"
                return 0
            else
                echo "... building image $DI"
                git clone git@github.com:jinal--shah/devbox_aws_coreos || return 1
                (
                    cd devbox_aws_coreos/assets \
                    && git clone git@github.com:opsgang/alpine_build_scripts
                ) || return 1

                ./build.sh

                [[ $? -ne 0 ]] && echo "ERROR: failed to build $DI" && return 1

                export DEFAULT_DEVBOX_IMAGE=$DI
                export DEFAULT_DEVBOX_USER="core"

            fi
        }

        devbox_build

