source $stdenv/setup

unpackPhase
mkdir -p $out
cd $name
$python/bin/python setup.py install --prefix=$out

for i in $(cd $out/bin && ls); do
    wrapProgram $out/bin/$i \
        --prefix PYTHONPATH : "$(toPythonPath $python):$(toPythonPath $out):$(toPythonPath $pysqlite):$subversion/lib/svn-python:$clearsilver/site-packages"
done
