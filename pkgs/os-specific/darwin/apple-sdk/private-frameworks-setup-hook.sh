addPrivateFrameworks() {
    flag="-F/System/Library/PrivateFrameworks"
    if [[ "$NIX_CFLAGS_COMPILE" != *$flag* ]]; then
        NIX_CFLAGS_COMPILE+=" $flag"
    fi
}

addEnvHooks "$hostOffset" addPrivateFrameworks
