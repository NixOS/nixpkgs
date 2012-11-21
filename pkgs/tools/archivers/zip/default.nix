{ stdenv, fetchurl, enableNLS ? true, libnatspec ? null }:

assert enableNLS -> libnatspec != null;

stdenv.mkDerivation {
  name = "zip-3.0";

  src = fetchurl {
    urls = [
      ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz
      http://pkgs.fedoraproject.org/repo/pkgs/zip/zip30.tar.gz/7b74551e63f8ee6aab6fbc86676c0d37/zip30.tar.gz
    ];
    sha256 = "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h";
  };

  buildFlags="-f unix/Makefile generic";

  installFlags="-f unix/Makefile prefix=$(out) INSTALL=cp";

  patches = if enableNLS then [ ./natspec-gentoo.patch.bz2 ] else [];

  buildInputs = if enableNLS then [ libnatspec ] else [];

  meta = {
    homepage = http://www.info-zip.org;
    platforms = stdenv.lib.platforms.all;
    maintainer = [ stdenv.lib.maintainers.urkud ];
  };
}
