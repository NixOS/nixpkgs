{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.24";

  buildInputs = [ zlib ];

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "http://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "1kjhqwmi1sjw8jcf6li725c59wm00zajrdfwgkwqxs295vgb6b40";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = stdenv.lib.platforms.all;
  };
}
