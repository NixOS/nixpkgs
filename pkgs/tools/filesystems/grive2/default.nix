{ stdenv, fetchFromGitHub, pkgconfig, fetchurl, yajl, cmake, libgcrypt, curl, expat, boost, binutils }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "grive2-${version}";

  src = fetchFromGitHub {
    owner = "vitalif";
    repo = "grive2";
    rev =  "v${version}";
    sha256 = "0gyic9228j25l5x8qj9xxxp2cgbw6y4skxqx0xrq6qilhv4lj23c";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libgcrypt yajl curl expat stdenv boost binutils ];

  meta = with stdenv.lib; {
    description = "A console Google Drive client";
    homepage = https://github.com/vitalif/grive2;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
