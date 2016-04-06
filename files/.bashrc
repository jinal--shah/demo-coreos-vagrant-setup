# based on /etc/skel/.bashrc
# vim: sr ts=4 sw=4 smartindent:
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

. /etc/skel/.bashrc

# Put your fun stuff here.
function pointFleet_help() {
    echo "usage: pointFleet clusterName e.g pointFleet dynpub-uk # sets FLEETCTL_TUNNEL env var (used by fleet to access cluster)"
}
function pointFleet() {
    setClusterName "${1-$clusterName}" || return 1

    echo "... pointing fleet to cluster [$clusterName]"
    domainSuffix="tunnel-up.ft.com"

    FLEETCTL_TUNNEL="${clusterName}-${domainSuffix}"

    if ! host "$FLEETCTL_TUNNEL" >/dev/null 2>&1
    then
            echo "ERROR: $FLEETCTL_TUNNEL:[$FLEETCTL_TUNNEL] does not resolve via DNS."
            return 1
    fi
    export FLEETCTL_TUNNEL
}

function forwardSsh_help() {
    echo "usage: forwardSsh # adds all of your .ssh keys to an ssh-agent for the current shell"
}
function forwardSsh() {
    echo "... generating agent for ssh forwarding in cluster"
    pkill ssh-agent
    eval $(ssh-agent)
    for privateKey in $(ls -1 $HOME/.ssh/id_* | grep -v '\.pub')
    do
        addKey "$privateKey"
    done
    ssh-add -l # verify your key has been added to the key-ring
}

function addKey_help() {
    echo "usage: addKey private_ssh_key e.g. addKey id_rsa - adds key to ssh-agent's keyring"
}
function addKey() {
    key="$1"
    if [[ -r ${key}.pub ]]; then
        echo "... adding key $key"
        ssh-add $key
    else
        echo "... no public key found for $key. Will skip ..."
    fi
}

function goCluster_help() {
    echo "usage: goCluster clusterName e.g. goCluster dynpub-uk # will set up an ssh agent with full keyring and ssh you to the cluster with agent forwarding"
}
function goCluster() {
    setClusterName "${1-$clusterName}" || return 1
    forwardSsh
    pointFleet || return 1
    ssh -A core@$FLEETCTL_TUNNEL
}

function setClusterName_help() {
    echo "usage: setClusterName clusterName e.g setClusterName dynpub-uk # sets clusterName env var (used by other helper functions to determine cluster)"
}
function setClusterName() {
    if [[ -z "$1" ]]; then
        echo '... you must pass a cluster name to setClusterName()'
        return 1
    fi

    if [[ "$clusterName" != "$1" ]]; then
        export clusterName="$1"
        echo "... cluster set to [$clusterName]"
    fi
}

function devbox_help() {
        echo 'usage: devbox <host dir> [<image:-dev_basic>] # start up a bash session on a dev_basic docker container, mounting your project dir'
}
function devbox() {
    if [[ -z "$1" ]]; then
        echo 'ERROR: usage: devbox <hostdir1:hostdir2:...> [<image:-devbox>]'
        echo '... hostdir /this/path/example:/that/path/boo will be mounted under'
        echo '    /example and /boo respectively'
        return 1
    fi

    host_dirs="$1"
    if [[ -z "$2" ]]; then
        image=dev_basic
    else
        image="$2"
    fi

    container_path_var='export PATH=$PATH'
    vol_str=""
    IFS=':' read -ra paths <<< "$host_dirs"
    for path in "${paths[@]}"; do
        path="${path%/}"
        project=$(basename $path)
        if [[ ! -d "$path" ]]; then
            echo "ERROR: path $path must be a directory on the machine" 
            echo 'usage: devbox <hostdir1:hostdir2:...> [<image:-devbox>]'
            echo '... hostdir /this/path/example:/that/path/boo will be mounted under'
            echo '    /example and /boo respectively'
            return 1
        fi
        vol_str="$vol_str -v ${path}:/${project}"
        container_path_var="$container_path_var:/${project}"
    done

    bashrc=$(mktemp)
    echo -e "$container_path_var\n">$bashrc
    vol_str="$vol_str -v $bashrc:/root/.bashrc:ro -v $HOME/.bash_history:/root/.bash_history"

    docker run -it $vol_str $image /bin/bash
}

export clusterName=
export PATH=$PATH:$HOME/local/terraform_0.6.14

echo "HELPER SHELL FUNCTIONS: "
for func in $(set | grep ' ()' | awk {'print $1'} | grep -v '_help$')
do
    printf "%15s () $(${func}_help)\n" $func
done


