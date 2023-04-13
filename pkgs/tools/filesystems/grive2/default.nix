{ lib, stdenv, fetchFromGitHub, pkg-config, yajl, cmake, libgcrypt, curl, expat, boost, libiberty }:

stdenv.mkDerivation rec {
  version = "0.5.3";
  pname = "grive2";

  src = fetchFromGitHub {
    owner = "vitalif";
    repo = "grive2";
    rev =  "v${version}";
    sha256 = "sha256-P6gitA5cXfNbNDy4ohRLyXj/5dUXkCkOdE/9rJPzNCg=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libgcrypt yajl curl expat boost libiberty ];

  meta = with lib; {
    description = "A console Google Drive client";
    homepage = "https://github.com/vitalif/grive2";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
