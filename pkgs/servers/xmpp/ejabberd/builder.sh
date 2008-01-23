buildInputs="$expat $erlang $zlib $openssl"

source $stdenv/setup

tar xfvz $src
cd $name/src
./configure --prefix=$out
make
make install
