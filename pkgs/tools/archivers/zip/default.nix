{ stdenv, fetchurl, enableNLS ? true, libnatspec ? null, libiconvOrNull }:

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

  buildFlags="-f unix/Makefile ${if stdenv.isCygwin then "cygwin" else "generic"}";

  installFlags="-f unix/Makefile prefix=$(out) INSTALL=cp";

  patches = stdenv.lib.optionals (enableNLS && !stdenv.isCygwin) [ ./natspec-gentoo.patch.bz2 ];

  buildInputs = [ libiconvOrNull ] ++ stdenv.lib.optional enableNLS libnatspec;

  meta = {
    description = "Compressor/archiver for creating and modifying zipfiles";
    homepage = http://www.info-zip.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
