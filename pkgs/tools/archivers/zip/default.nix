{ stdenv, fetchurl, enableNLS ? false, libnatspec ? null, libiconv }:

assert enableNLS -> libnatspec != null;

stdenv.mkDerivation {
  name = "zip-3.0";

  src = fetchurl {
    urls = [
      ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz
      https://src.fedoraproject.org/repo/pkgs/zip/zip30.tar.gz/7b74551e63f8ee6aab6fbc86676c0d37/zip30.tar.gz
    ];
    sha256 = "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h";
  };
  patchPhase = ''
    substituteInPlace unix/Makefile --replace 'CC = cc' ""
  '';

  hardeningDisable = [ "format" ];

  makefile = "unix/Makefile";
  buildFlags = if stdenv.isCygwin then "cygwin" else "generic";
  installFlags = "prefix=$(out) INSTALL=cp";

  patches = if (enableNLS && !stdenv.isCygwin) then [ ./natspec-gentoo.patch.bz2 ] else [];

  buildInputs = stdenv.lib.optional enableNLS libnatspec
    ++ stdenv.lib.optional stdenv.isCygwin libiconv;

  meta = with stdenv.lib; {
    description = "Compressor/archiver for creating and modifying zipfiles";
    homepage = http://www.info-zip.org;
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
