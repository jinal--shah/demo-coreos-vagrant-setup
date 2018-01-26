# vim: et sr sw=4 ts=4 smartindent syntax=sh:

devbox_build() {

    local d="$1" || return 1
    if docker images --format '{{.Repository}}:{{.Tag}}' | grep "^$DI" >/dev/null 2>&1
    then
        echo "... found image $DI"
        return 0
    else
        echo "... building image $DI"
        if [[ -d $d ]]; then
            echo "WARNING: can not build as dir $d exists already."
            echo "... delete it first and log in again to build $DI"
            return 0
        fi
        git clone git@github.com:jinal--shah/$d || return 1
        (
            cd $d/assets \
            && git clone git@github.com:opsgang/alpine_build_scripts
        ) || return 1

        (
            cd $d \
            && ./build.sh
        )

        [[ $? -ne 0 ]] && echo "ERROR: failed to build $DI" && return 1

    fi

    return 0
}

# only works because git repo name same as docker image name
BUILD_DIR=devbox_aws_coreos
DI=jinal--shah/$BUILD_DIR:candidate
export DEFAULT_DEVBOX_IMAGE=$DI
export DEFAULT_DEVBOX_USER="core"

devbox_build $BUILD_DIR || return 1
unset DI
