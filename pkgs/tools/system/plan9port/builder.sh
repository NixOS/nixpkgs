source $stdenv/setup

export PLAN9=$out/plan9
export PLAN9_TARGET=$PLAN9

plan9portLinkFlags()
{
    eval set -- "$NIX_LDFLAGS"
    local flag
    for flag in "$@"; do
        printf ' -Wl,%s' "$flag"
    done
}

configurePhase()
{
    (
        echo CC9=\"$(command -v $CC)\"
        echo CFLAGS=\"$NIX_CFLAGS_COMPILE\"
        echo LDFLAGS=\"$(plan9portLinkFlags)\"
        echo X11=\"${libXt_dev}/include\"
        case "$system" in
          x86_64-*) echo OBJTYPE=x86_64;;
          i?86-*)   echo OBJTYPE=386;;
          *power*)  echo OBJTYPE=power;;
          *sparc*)  echo OBJTYPE=sparc;;
          *) exit 12
        esac
        if [[ $system =~ .*linux.* ]]; then
          echo SYSVERSION=2.6.x
        fi
    ) >config

    for f in `grep -l -r /usr/local/plan9`; do
        sed "s,/usr/local/plan9,${PLAN9},g" -i $f
    done
}

buildPhase()
{
    mkdir -p $PLAN9

    # Copy sources, some necessary bin scripts
    cp -R * $PLAN9

    local originalPath="$PATH"
    export PATH="$PLAN9/bin:$PATH"
    export NPROC=$NIX_BUILD_CORES
    pushd src
    ../dist/buildmk
    mk clean
    mk libs-nuke
    mk all
    mk -k install
    if [[ -f $PLAN9/bin/quote1 ]]; then
        cp $PLAN9/bin/quote1 $PLAN9/bin/'"'
        cp $PLAN9/bin/quote2 $PLAN9/bin/'""'
    fi
    popd
    export PATH="$originalPath"
}

installPhase()
{
    # Copy the `9' utility. This way you can use
    # $ 9 awk
    # to use the plan 9 awk
    mkdir $out/bin
    ln -s $PLAN9/bin/9 $out/bin
}

genericBuild
