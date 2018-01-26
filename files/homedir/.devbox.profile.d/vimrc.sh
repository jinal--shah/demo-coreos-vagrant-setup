# vim: et sr sw=4 ts=4 smartindent syntax=sh:
[[ ! -z "$BASH_VERSION" ]] || [[ ! -z "$PS1" ]] || return

if [[ ! -r $HOME/.vimrc ]] && [[ -r /etc/vim/vimrc ]]; then
    echo "... copying default vimrc to HOME dir"
    cp /etc/vim/vimrc $HOME/.vimrc
fi
