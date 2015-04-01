{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  name = "avfs-${version}";
  version = "1.0.2";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${name}.tar.bz2";
    sha1 = "e4f8377ea2565c1ac59f7b66893905b778ddf849";
  };

  buildInputs = [ pkgconfig fuse xz ];

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
