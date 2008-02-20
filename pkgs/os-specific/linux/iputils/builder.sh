source $stdenv/setup

makeFlags="KERNEL_INCLUDE=$kernelHeaders/include LIBC_INCLUDE=$glibc/include"

preConfigure="sed -e 's@check-kernel @@' -i Makefile"

installPhase="
mkdir -pv $out/bin $out/sbin
install -c arping $out/sbin/
install -c ping $out/bin/
install -c ping6 $out/sbin/
install -c rdisc $out/sbin/
install -c tracepath $out/sbin/
install -c tracepath6 $out/sbin/
install -c traceroute6 $out/sbin/
";

genericBuild
