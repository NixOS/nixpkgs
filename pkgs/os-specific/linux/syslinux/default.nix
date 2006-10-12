{stdenv, fetchurl, nasm, perl}:

stdenv.mkDerivation {
  name = "syslinux-3.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/syslinux-3.20.tar.bz2;
    md5 = "0701e0de1de6d31bdd889384b041e5b7";
  };
 buildInputs = [nasm perl];
 patches = [./syslinux-3.20-installpath.patch];
}
