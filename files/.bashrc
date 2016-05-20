# based on /etc/skel/.bashrc
# vim: et sr ts=4 sw=4 smartindent:
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

DEFAULT_DEVBOX_IMAGE=dev_basic:0.0.6

function pointFleet_help() {

    cat <<EOM
usage:  pointFleet <clusterName>
... sets fleet to operate on a specific cluster using IP or DNS name
e.g
    pointFleet 178.192.1.2

If you don't use an IP, this will check the name resolves (via DNS or host file)
EOM

}
function pointFleet() {
    setClusterName "${1-$clusterName}" || return 1

    echo "... pointing fleet to cluster [$clusterName]"

    # ... if doesn't look like ipV4 of ipV6, test name resolves ...
    if [[ $clusterName =~ [^0-9\.] ]] && [[ $clusterName =~ [^0-9a-fA-F:] ]]; then
        if ! host "$clusterName" >/dev/null 2>&1
        then
                echo "ERROR: pointFleet:[$clusterName] does not resolve via DNS."
                return 1
        fi
    fi
    FLEETCTL_TUNNEL="${clusterName}"

    export FLEETCTL_TUNNEL
}

function forwardSsh_help() {

    cat <<EOM
usage:  forwardSsh
... adds all of your .ssh keys to an ssh-agent for the current shell
EOM

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
    cat <<EOM
usage:  addKey </path/to/private_ssh_key>
... adds key to ssh-agent's keyring
e.g.
    addKey ~/.ssh/id_rsa
EOM

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
    cat <<EOM
usage:  goCluster <clusterName>
... ssh to clusterName with ssh-agent forwarding your keys
e.g.
    goCluster 178.192.1.2

EOM

}
function goCluster() {
    setClusterName "${1-$clusterName}" || return 1
    forwardSsh
    pointFleet || return 1
    ssh -A core@$FLEETCTL_TUNNEL
}

function setClusterName_help() {
    cat <<EOM
usage: setClusterName clusterName e.g setClusterName some_cluster
... sets clusterName env var
... used by other helper functions to determine cluster
EOM
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
    cat <<EOM
usage: devbox <name> [<hostdir1:hostdir2:...>] [<image:-$DEFAULT_DEVBOX_IMAGE>]
... drop in to a docker container, with mapped vols.
  - <name>: will be the container name (only [A-Za-z0-9_]+)
  - <hostdir>: /this/path/example:/that/path/boo will be mounted under
    /example and /boo respectively. These are also added to \$PATH.
  - <image>: will use $DEFAULT_DEVBOX_IMAGE by default.
EOM
}
function devbox() {
    if [[ -z "$1" ]]; then
        echo 'ERROR: you must pass a <name> for the container'
        devbox_help
        return 1
    fi

    if [[ $1 =~ [^-A-Za-z0-9_] ]];then
        echo 'ERROR: <name> contains invalid characters.'
        devbox_help
        return 1
    fi

    container_name="$1"
    host_dirs="$2"
    if [[ -z "$3" ]]; then
        image=$DEFAULT_DEVBOX_IMAGE
    else
        image="$3"
    fi

    # ... if container already exists but not running this will start it.
    # If it is already running, this will exec to it.
    docker_exec="docker exec -it $container_name /bin/bash"

    # ... don't use docker ps 'name' filter - that will match substrings too ...
    if docker ps --format '{{.Names}}' --filter 'status=running' | grep "^$container_name$" >/dev/null 2>&1
    then
        echo "... container $container_name already running. Will open a session in that workspace."
        _warn_immutable_container $container_name

        $docker_exec

    elif docker ps -a --format '{{.Names}}' | grep "^$container_name$" >/dev/null 2>&1
    then
        echo "... container $container_name exists. Will start it and open a session in the workspace."
        _warn_immutable_container $container_name

        docker start $container_name \
        && $docker_exec
    else
        # ... set up new container instance
        container_path_var='export PATH=$PATH'
        vol_str=""
        IFS=':' read -ra paths <<< "$host_dirs"
        for path in "${paths[@]}"; do
            path="${path%/}"
            project=$(basename $path)
            if [[ ! -d "$path" ]]; then
                echo "ERROR: path $path must be a directory on the machine"
                devbox_help
                return 1
            fi
            vol_str="$vol_str -v ${path}:/${project}"
            container_path_var="$container_path_var:/${project}"
        done

        # ... create a .bashrc for the container
        profiles=$(mktemp -d -p /home/core/profile.d/)
        echo "should write to $profiles"
        echo -e "$container_path_var\n">$profiles/path.sh
        echo -e "export PS1='\\[\\033[01;32m\\]$container_name \\[\\033[01;36m\\]\\W$ \\[\\033[00m\\]'\\n">$profiles/bash_prompt.sh
        echo -e "export CONTAINER_NAME=$container_name\\n">$profiles/container_name.sh
        vol_str="$vol_str -v $profiles:/etc/profile.d" 

        docker run -it --name $container_name $vol_str $image /bin/bash
    fi

}

function _warn_immutable_container() {
    container_name="$1"
    cat <<EOF
$(tput bold)$(tput setaf 3)*** WARNING ***
if you want different hostdirs mounted or a different image
choose a different name to $container_name, or kill the existing one:

  docker stop $container_name
  docker rm $container_name
$(tput sgr0)
EOF
}


export clusterName=
export PATH=$PATH:$HOME/local/bin
alias dgc="sudo $(which docker_cleanup)"

echo "HELPER SHELL FUNCTIONS: "
for func in $(set | grep ' ()' | awk {'print $1'} | grep -v '_help$' | grep -v '^_')
do
    oIFS=$IFS
    IFS=$'\n'
    start_line="${func}()"
    for line in $(${func}_help); do
        # ... info lines in cyan 'cos its purrdy Mr. Taggart...
        if [[ $start_line =~ ^[\ ]$ ]]; then
            line="\e[2m\e[36m$line\e[0m\e[22m"
            format_str="%-18s $line\n"
        else
        # ... function names in green with emboldened usage info
            line="\e[1m$line\e[0m"
            format_str="\e[32m%-18s\e[0m $line\n"
        fi
        printf "$format_str" $start_line
        start_line=' ' # omit function name at start of subsequent lines
    done
    IFS=$oIFS
    echo ""
done

