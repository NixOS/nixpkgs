{stdenv, fetchurl, x11, zlib, libjpeg, imake, gccmakedep, libXmu, libXaw, libXpm, libXp , perl, xauth, fontDirectories}:

stdenv.mkDerivation {
  name = "tightvnc-1.3.10";
  builder = ./builder.sh;
  gcc=stdenv.gcc.gcc;
	inherit perl;
  src = fetchurl {
    url = mirror://sourceforge/vnc-tight/tightvnc-1.3.10_unixsrc.tar.bz2;
    sha256 = "f48c70fea08d03744ae18df6b1499976362f16934eda3275cead87baad585c0d";
  };

  # for the builder script
  inherit xauth;

  inherit fontDirectories;

  buildInputs = [x11 zlib libjpeg imake gccmakedep libXmu libXaw libXpm libXp
  	xauth];
}
