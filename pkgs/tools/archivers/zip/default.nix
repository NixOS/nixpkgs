{ stdenv, fetchurl, libnatspec }:

stdenv.mkDerivation {
  name = "zip-3.0";

  src = fetchurl {
    url = ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz;
    sha256 = "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h";
  };

  buildFlags="-f unix/Makefile generic";

  installFlags="-f unix/Makefile prefix=$(out) INSTALL=cp";

  patches = [ ./natspec-gentoo.patch.bz2 ];

  buildInputs = [ libnatspec ];

  meta = {
    homepage = http://www.info-zip.org;
    platforms = stdenv.lib.platforms.all;
    maintainer = [ stdenv.lib.maintainers.urkud ];
  };
}

