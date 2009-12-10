export NIX_ENFORCE_PURITY=1
export NIX_IGNORE_LD_THROUGH_GCC=1

if test "$system" = "i686-darwin" -o "$system" = "powerpc-darwin" -o "$system" = "x86_64-darwin"; then
    export NIX_DONT_SET_RPATH=1
    export NIX_NO_SELF_RPATH=1
    dontFixLibtool=1
    NIX_STRIP_DEBUG=0 # !!! do we still need this?
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s" 
    xargsFlags=" "
fi
