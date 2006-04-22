source $stdenv/setup
source $makeWrapper

unpackPhase
mkdir -p $out
cd $name
$python/bin/python setup.py install --prefix=$out

for i in $(cd $out/bin && ls); do
	mv $out/bin/$i $out/bin/.orig-$i
	makeWrapper $out/bin/.orig-$i $out/bin/$i \
		--set PYTHONPATH "$python/site-packages:$out/lib/python2.4/site-packages:$pysqlite/lib/python2.4/site-packages:$subversion/lib/svn-python:$clearsilver/site-packages"
done
