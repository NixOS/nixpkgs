{stdenv, fetchurl, nasm, perl}:

stdenv.mkDerivation {
  name = "syslinux-3.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-3.20.tar.bz2;
    md5 = "0701e0de1de6d31bdd889384b041e5b7";
  };
 buildInputs = [nasm perl];
 patches = [./syslinux-3.20-installpath.patch];
}
