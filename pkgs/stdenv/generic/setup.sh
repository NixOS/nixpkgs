set -e

test -z $NIX_GCC && NIX_GCC=@gcc@


# Set up the initial path.
PATH=
for i in $NIX_GCC @initialPath@; do
    PATH=$PATH${PATH:+:}$i/bin
done

if test "$NIX_DEBUG" = "1"; then
    echo "Initial path: $PATH"
fi


# Execute the pre-hook.
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n "@preHook@"; then
    . @preHook@
fi


# Check that the pre-hook initialised SHELL.
if test -z "$SHELL"; then echo "SHELL not set"; exit 1; fi


# Hack: run gcc's setup hook.
if test -f $NIX_GCC/nix-support/setup-hook; then
    . $NIX_GCC/nix-support/setup-hook
fi

    
# Recursively find all build inputs.
findInputs()
{
    local pkg=$1
    pkgs=(${pkgs[@]} $pkg)

    if test -f $pkg/nix-support/setup-hook; then
        . $pkg/nix-support/setup-hook
    fi
    
    if test -f $pkg/nix-support/propagated-build-inputs; then
        for i in $(cat $pkg/nix-support/propagated-build-inputs); do
            addToEnv $pkg
        done
    fi
}

pkgs=()
envHooks=()
for i in $buildinputs; do
    findInputs $i
done


# Set the relevant environment variables to point to the build inputs
# found above.
addToEnv()
{
    local pkg=$1

    if test -d $1/bin; then
        export _PATH=$_PATH:$1/bin
    fi

    for i in "${envHooks[@]}"; do
        $i $pkg
    done
}

for i in "${pkgs[@]}"; do
    addToEnv $i
done


# Add the output as an rpath.
if test "$NIX_NO_SELF_RPATH" != "1"; then
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
fi


# Strip debug information by default.
export NIX_STRIP_DEBUG=1
export NIX_CFLAGS_STRIP="-g0 -Wl,-s"


# Where is the store?  This is required for purity checking.
export NIX_STORE=$(dirname $out)/ # !!! hack


# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC


# Execute the post-hook.
if test -n "@postHook@"; then
    . @postHook@
fi

PATH=$_PATH${_PATH:+:}$PATH
if test "$NIX_DEBUG" = "1"; then
    echo "Final path: $PATH"
fi
