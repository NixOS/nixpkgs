source $stdenv/setup

tar xfvz $src
cd tomcat-connectors-*-src/native
./configure --with-apxs=$apacheHttpd/bin/apxs --with-java-home=$jdk
make
ensureDir $out/modules
cp apache-2.0/mod_jk.so $out/modules
