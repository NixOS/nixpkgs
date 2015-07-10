{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.24";

  buildInputs = [ zlib ];

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "http://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "0z0mwqayrrf3w734rjp9rysf0y8az191ff7fxjsxyb1y2kzv72ia";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = stdenv.lib.platforms.all;
  };
}
