source $stdenv/setup

export PLAN9=$out/plan9
export PLAN9_TARGET=$PLAN9

configurePhase()
{
    echo CFLAGS=\"-I${fontconfig_dev}/include -I${xorgproto_exp}/include -I${libX11_dev}/include -I${libXt_dev}/include -I${libXext_dev}/include -I${freetype_dev}/include -I${zlib_dev}/include\" > LOCAL.config
    echo LDFLAGS=\"-L${fontconfig_lib}/lib -L${xorgproto_exp}/lib -L${libX11_exp}/lib -L${libXt_exp}/lib -L${libXext_exp}/lib -L${freetype_exp}/lib -L${zlib_exp}/lib\" >> LOCAL.config    
    echo X11=\"${libXt_dev}/include\" >> LOCAL.config

    for f in `grep -l -r /usr/local/plan9`; do
        sed "s,/usr/local/plan9,${PLAN9},g" -i $f
    done
}

buildPhase()
{
    mkdir -p $PLAN9
    ./INSTALL -b
}

installPhase()
{
    ./INSTALL -c
    # Copy sources
    cp -R * $PLAN9

    # Copy the `9' utility. This way you can use
    # $ 9 awk
    # to use the plan 9 awk
    mkdir $out/bin
    ln -s $PLAN9/bin/9 $out/bin
}

genericBuild
