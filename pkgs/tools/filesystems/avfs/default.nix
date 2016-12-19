{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  name = "avfs-${version}";
  version = "1.0.4";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${name}.tar.bz2";
    sha256 = "005iw01ppjslfzbbx52dhmp1f7a8d071s5pxvjlk11zdv4h22rbb";
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
