{stdenv, fetchurl, x11, zlib, libjpeg, imake, gccmakedep, libXmu, libXaw, libXpm, libXp , perl, xauth}:

# if you have any trouble connecting to the tightvnc server try $ rm ~/.Xauthority
# Dunno what happens here but it works.

stdenv.mkDerivation {
  name = "tightvnc-1.3.9";
  builder = ./builder.sh;
  gcc=stdenv.gcc.gcc;
	inherit perl;
  src = fetchurl {
    url = mirror://sourceforge/vnc-tight/tightvnc-1.3.9_unixsrc.tar.bz2;
    sha256 = "0nij6kyzwxf7nblwd6riwqhzh8b8xwdffpj379zi5y9mcmiwmalr";
  };
  buildInputs = [x11 zlib libjpeg imake gccmakedep libXmu libXaw libXpm libXp
  	xauth];
}
