#! /bin/sh -e

buildinputs="$python $wxPython"
. $stdenv/setup

tar xvfz $src
cd BitTorrent-*
python setup.py build install --prefix=$out

mv $out/bin $out/bin-orig
mkdir $out/bin
for i in $(cd $out/bin-orig && ls); do
  cat > $out/bin/$i <<EOF
#! /bin/sh
PYTHONPATH=$out/lib/python2.3/site-packages:$wxPython/lib/python2.3/site-packages exec $out/bin-orig/$i \$*
EOF
  chmod +x $out/bin/$i
done