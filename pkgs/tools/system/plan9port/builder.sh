source $stdenv/setup

export PLAN9=$out/plan9

configurePhase()
{
    echo CFLAGS=\"-I${fontconfig}/include -I${libXt}/include\" > LOCAL.config
    echo X11=\"${libXt}/include\" >> LOCAL.config

    for f in `grep -l -r /usr/local/plan9`; do
        sed "s,/usr/local/plan9,${PLAN9},g" -i $f
    done
}

buildPhase()
{
    mkdir -p $PLAN9
    ./INSTALL -b $PLAN9
}

installPhase()
{
    ./INSTALL -c -r $PLAN9
    # Copy sources
    cp -R * $PLAN9

    # Copy the `9' utility. This way you can use
    # $ 9 awk
    # to use the plan 9 awk
    mkdir $out/bin
    ln -s $PLAN9/bin/9 $out/bin
}

genericBuild
