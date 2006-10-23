export NIX_ENFORCE_PURITY=1

if test "$param1" = "static"; then
    export NIX_CFLAGS_LINK="-static"
    export NIX_LDFLAGS_BEFORE="-static"
fi

havePatchELF=1
