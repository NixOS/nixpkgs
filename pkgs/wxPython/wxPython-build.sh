#! /bin/sh

. $stdenv/setup || exit 1

export PATH=$pkgconfig/bin:$PATH
envpkgs="$gtk"
. $setenv || exit 1

tar xvfz $src || exit 1
cd wxPythonSrc-* || exit 1
./configure --prefix=$out --enable-gtk2 --enable-rpath=$out/lib --with-opengl || exit 1
make || exit 1
make install || exit 1
cd wxPython || exit 1
python setup.py WX_CONFIG=$out/bin/wx-config WXPORT=gtk2 build install --root=$out/python || exit 1

echo $envpkgs > $out/envpkgs || exit 1
