buildInputs="$python $wxPython"
. $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    python setup.py build
}

installPhase=installPhase
installPhase() {
    python setup.py install --prefix=$out

    # Create wrappers that set the environment correctly.
    mv $out/bin $out/bin-orig
    mkdir $out/bin
    for i in $(cd $out/bin-orig && ls); do
        cat > $out/bin/$i <<EOF
#! /bin/sh
PYTHONPATH=$out/lib/python2.3/site-packages:$wxPython/lib/python2.3/site-packages exec $out/bin-orig/$i "\$@"
EOF
        chmod +x $out/bin/$i
    done
}

genericBuild