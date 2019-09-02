{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  pname = "avfs";
  version = "1.1.1";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0fxzigpyi08ipqz30ihjcpqmmx8g7r1kqdqq1bnnznvnhrzyygn8";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fuse xz ];

  configureFlags = [
    "--enable-library"
    "--enable-fuse"
    "--disable-static"
  ];

  meta = {
    homepage = http://avf.sourceforge.net/;
    description = "Virtual filesystem that allows browsing of compressed files";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
