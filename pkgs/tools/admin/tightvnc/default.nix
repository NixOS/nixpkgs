{stdenv, fetchurl, x11, zlib, libjpeg, imake, gccmakedep, libXmu, libXaw, libXpm, libXp}:

stdenv.mkDerivation {
  name = "tightvnc-1.3.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/vnc-tight/tightvnc-1.3.9_unixsrc.tar.bz2;
    sha256 = "0nij6kyzwxf7nblwd6riwqhzh8b8xwdffpj379zi5y9mcmiwmalr";
  };
  buildInputs = [x11 zlib libjpeg imake gccmakedep libXmu libXaw libXpm libXp];
}
