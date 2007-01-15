export PATH=@wrapperDir@:@systemPath@/bin:@systemPath@/sbin
export MODULE_DIR=@kernel@/lib/modules
export NIX_CONF_DIR=/nix/etc/nix
export PAGER=less

PROMPT_COLOR="1;31m"
PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]$\[\033[0m\] "
if test "x$TERM" == "xxterm"; then
    PS1="\033]2;\h:\u:\w\007\033]1;$PS1"
fi

if test "$USER" != root; then
    export NIX_REMOTE=daemon
fi


# Set up the per-user profile.
NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER
mkdir -m 0755 -p $NIX_USER_PROFILE_DIR
if test "$(stat --printf '%U' $NIX_USER_PROFILE_DIR)" != "$USER"; then
    echo "WARNING: bad ownership on $_NIX_PROFILE_DIR" >&2
fi

if ! test -L $HOME/.nix-profile; then
    echo "creating $HOME/.nix-profile" >&2
    ln -s $NIX_USER_PROFILE_DIR/profile $HOME/.nix-profile
fi

NIX_PROFILES="/nix/var/nix/profiles/default $NIX_USER_PROFILE_DIR/profile"

for i in $NIX_PROFILES; do # !!! reverse
    export PATH=$i/bin:$PATH
done


# Set up a default Nix expression from which to install stuff.
if ! test -L $HOME/.nix-defexpr; then
    echo "creating $HOME/.nix-defexpr" >&2
    ln -s /etc/nixos/install-source.nix $HOME/.nix-defexpr
fi


# Some aliases.
alias ls="ls --color=tty"
alias ll="ls -l"
alias which="type -p"


# Read system-wide modifications.
if test -f /etc/profile.local; then
    source /etc/profile.local
fi


# Read user modifications.
test -r $HOME/.bashrc && source $HOME/.bashrc
