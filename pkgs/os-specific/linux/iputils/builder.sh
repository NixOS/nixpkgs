. $stdenv/setup

tar jxvf $src
cd iputils

echo $src
echo $kernelHeaders
echo $glibc

sed -e "s^KERNEL_INCLUDE=.*$^KERNEL_INCLUDE=$kernelHeaders/include^" < Makefile > Makefile.new

mv Makefile.new Makefile
sed -e "s^LIBC_INCLUDE=.*$^LIBC_INCLUDE=$glibc/include^" < Makefile > Makefile.new
mv Makefile.new Makefile

make

mkdir -p $out/bin
mkdir -p $out/sbin

install -c arping $out/sbin/
install -c ping $out/bin/
install -c ping6 $out/sbin/
install -c rdisc $out/sbin/
install -c tracepath $out/sbin/
install -c tracepath6 $out/sbin/
install -c traceroute6 $out/sbin/
