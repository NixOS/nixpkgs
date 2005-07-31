{stdenv, fetchurl, nasm, perl}:

stdenv.mkDerivation {
  name = "syslinux-3.09";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-3.09.tar.bz2;
    md5 = "dd403b15ef18bb0e5d78d3f552f822a5";
  };
 buildInputs = [nasm perl];
 patches = [./syslinux-installpath.patch];
}
