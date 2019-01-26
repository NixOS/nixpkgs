{ stdenv, fetchurl, pkgconfig, fuse, xz }:

stdenv.mkDerivation rec {
  name = "avfs-${version}";
  version = "1.0.6";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${name}.tar.bz2";
    sha256 = "1hz39f7p5vw647xqk161v3nh88qnd599av6nfidpmkh1d9vkl6jc";
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
