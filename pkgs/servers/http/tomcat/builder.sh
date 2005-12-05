source $stdenv/setup || exit 1

tar zxf $src
cd jakarta-tomcat*/bin

# install jsvc

tar xvfz jsvc.tar.gz
cd jsvc-src
sh ./configure --with-java=$jdk
make
cp jsvc ..
cd ..

# done jsvc

cd ../..

mkdir $out
mv jakarta-tomcat* $out
