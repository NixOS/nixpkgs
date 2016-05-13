{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-5.26";

  buildInputs = [ zlib ];

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "http://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "1kshpybd75x5gs617wbd7dk1d9w6c3jxq8d0b5xzzc1nr572pwrf";
  };

  meta = {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    platforms = stdenv.lib.platforms.all;
  };
}
