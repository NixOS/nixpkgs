{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  name = "avfs-${version}";
  version = "1.0.3";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${name}.tar.bz2";
    sha256 = "1j7ysjkv0kbkwjagcdgwcnbii1smd58pwwlpz0l7amki5dxygpn6";
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
