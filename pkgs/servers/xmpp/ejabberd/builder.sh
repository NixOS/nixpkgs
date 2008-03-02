source $stdenv/setup

tar xfvz $src
cd ejabberd-*/src
./configure --prefix=$out
make
make install

# Fix runtime dependency for erlang
sed -i -e "s|erl \\\|$erlang/bin/erl \\\|" $out/sbin/ejabberdctl
