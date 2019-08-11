{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  name = "avfs-${version}";
  version = "1.1.0";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${name}.tar.bz2";
    sha256 = "19rk2c0xd3mi66kr88ykrcn81fv09c09md0gf6mnm9z1bd7p7wx7";
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
