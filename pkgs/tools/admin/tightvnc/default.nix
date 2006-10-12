{stdenv, fetchurl, x11, zlib, libjpeg, imake, gccmakedep, libXmu, libXaw, libXpm, libXp}:

stdenv.mkDerivation {
  name = "tightvnc-1.3dev7";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/tightvnc-1.3dev7_unixsrc.tar.bz2;
    md5 = "8e9e63f19d8351a5359c0cc15d96c18c";
  };
  buildInputs = [x11 zlib libjpeg imake gccmakedep libXmu libXaw libXpm libXp];
}
