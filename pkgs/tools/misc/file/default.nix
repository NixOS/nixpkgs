{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.25";

  buildInputs = [ zlib ];

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "http://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "1jhfi5mivdnqvry5la5q919l503ahwdwbf3hjhiv97znccakhd9p";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = stdenv.lib.platforms.all;
  };
}
