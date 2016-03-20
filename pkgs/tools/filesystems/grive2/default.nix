{ stdenv, pkgconfig, fetchurl, yajl, cmake, libgcrypt, curl, expat, boost, binutils }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "grive2-${version}";

  src = fetchurl {
    url = https://github.com/vitalif/grive2/archive/v0.5.0.tar.gz;
    md5 = "f291ffaef831abf3605417995082bcc3";
  };

  buildInputs = [cmake pkgconfig libgcrypt yajl curl expat stdenv binutils boost];

  buildPhase = ''
  cmake .
  make -j4
  '';

  meta = {
    description = "An open source Linux client for Google Drive";
    homepage =https://github.com/vitalif/grive2;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };

}
