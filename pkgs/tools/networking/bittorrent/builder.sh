source $stdenv/setup
source $makeWrapper

buildPhase=buildPhase
buildPhase() {
    python setup.py build
}

installPhase=installPhase
installPhase() {
    python setup.py install --prefix=$out

    # Create wrappers that set the environment correctly.
    for i in $(cd $out/bin && ls); do
        # Note: the GUI apps except to be in a directory called `bin',
        # so don't move them. 
        mv $out/bin/$i $out/bin/.orig-$i
        makeWrapper $out/bin/.orig-$i $out/bin/$i \
            --set PYTHONPATH "$out/lib/python2.4/site-packages:$pygtk/lib/python2.4/site-packages/gtk-2.0"
    done
}

genericBuild