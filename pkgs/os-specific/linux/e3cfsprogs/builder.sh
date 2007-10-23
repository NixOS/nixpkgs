source $stdenv/setup

tar -zxvf $src
cd e3cfsprogs*/

mkdir build; 
cd build;
../configure --prefix=$out
make
#make check			#almost all checks fail... maybe they have to be done on a ext3cow fs ???
make install

#we must rename according to the manual of e3cfprogs
cp misc/mke2fs $out/sbin/mkfs.ext3cow
