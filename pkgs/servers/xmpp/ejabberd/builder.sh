buildInputs="$expat $erlang $zlib $openssl"

source $stdenv/setup

tar xfvz $src
cd ejabberd-*/src
./configure --prefix=$out
make
make install
