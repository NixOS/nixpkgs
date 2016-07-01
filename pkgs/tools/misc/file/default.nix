{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.28";

  buildInputs = [ zlib ];

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "http://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "04p0w9ggqq6cqvwhyni0flji1z0rwrz896hmhkxd2mc6dca5xjqf";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = stdenv.lib.platforms.all;
  };
}
