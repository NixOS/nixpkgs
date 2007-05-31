source $stdenv/setup
source $makeWrapper

# Workaround for:
#  File "...-python-2.4.4/lib/python2.4/posixpath.py", line 62, in join
#    elif path == '' or path.endswith('/'):
# AttributeError: 'NoneType' object has no attribute 'endswith'
export HOME=$TMP

buildPhase=buildPhase
buildPhase() {
    #substituteInPlace BitTorrent/GUI_wx/__init__.py --replace "'2.6'" "'2.8'"
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
            --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH"
    done
}

genericBuild