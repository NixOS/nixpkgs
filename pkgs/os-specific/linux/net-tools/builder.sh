buildinputs=""
. $stdenv/setup

tar xvfj $src
cd net-tools-*
cp $config config.h
sed "s^/usr/share/man^/share^"  < man/Makefile > tmp
mv tmp man/Makefile
make
mkdir $out
make BASEDIR=$out install
