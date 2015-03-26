{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.22";

  buildInputs = [ zlib ];

  src = fetchurl {
    url = "ftp://ftp.astron.com/pub/file/${name}.tar.gz";
    sha256 = "02zw14hw3gqlw91w2f2snbirvyrp7r83irvnnkjcb25q9kjaiqy4";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = stdenv.lib.platforms.all;
  };
}
