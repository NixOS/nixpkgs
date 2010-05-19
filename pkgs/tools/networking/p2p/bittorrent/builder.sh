source $stdenv/setup


# Workaround for:
#  File "...-python-2.4.4/lib/python2.4/posixpath.py", line 62, in join
#    elif path == '' or path.endswith('/'):
# AttributeError: 'NoneType' object has no attribute 'endswith'
export HOME=$TMP


buildPhase() {
    python setup.py build
}


installPhase() {
    python setup.py install --prefix=$out

    # Create wrappers that set the environment correctly.
    for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
            --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH"
    done
}


genericBuild
