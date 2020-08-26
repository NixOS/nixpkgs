{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  pname = "avfs";
  version = "1.1.3";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1psh8k7g7rb0gn7aygbjv86kxyi9xq07barxksa99nnmq3lc2kjg";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fuse xz ];

  configureFlags = [
    "--enable-library"
    "--enable-fuse"
  ];

  meta = {
    homepage = "http://avf.sourceforge.net/";
    description = "Virtual filesystem that allows browsing of compressed files";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
