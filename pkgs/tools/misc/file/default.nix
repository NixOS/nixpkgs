{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "file-${version}";
  version = "5.30";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "https://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "694c2432e5240187524c9e7cf1ec6acc77b47a0e19554d34c14773e43dbbf214";
  };

  buildInputs = [ zlib ];

  doCheck = true;


  meta = with stdenv.lib; {
    homepage = "http://darwinsys.com/file";
    description = "A program that shows the type of files";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
