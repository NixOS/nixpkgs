{ lib, stdenv, fetchurl, pkg-config, fuse, xz }:

stdenv.mkDerivation rec {
  pname = "avfs";
  version = "1.1.4";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0ax1zbw4pmggx1b784bfabdqyn39k7109cnl22p69y2phnpq2y9s";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse xz ];

  configureFlags = [
    "--enable-library"
    "--enable-fuse"
  ];

  meta = {
    homepage = "http://avf.sourceforge.net/";
    description = "Virtual filesystem that allows browsing of compressed files";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
  };
}
