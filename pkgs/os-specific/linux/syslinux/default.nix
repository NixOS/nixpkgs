{stdenv, fetchurl, nasm, perl}:

stdenv.mkDerivation {
  name = "syslinux-3.11";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-3.11.tar.bz2;
    md5 = "513ff71287a4397d507879a1a836c2e8";
  };
 buildInputs = [nasm perl];
 patches = [./syslinux-installpath.patch];
}
