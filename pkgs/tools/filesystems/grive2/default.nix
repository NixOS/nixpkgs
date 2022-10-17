{ lib, stdenv, fetchFromGitHub, pkg-config, yajl, cmake, libgcrypt, curl, expat, boost, libiberty }:

stdenv.mkDerivation rec {
  version = "0.5.1";
  pname = "grive2";

  src = fetchFromGitHub {
    owner = "vitalif";
    repo = "grive2";
    rev =  "v${version}";
    sha256 = "1kv34ys8qarjsxpb1kd8dp7b3b4ycyiwjzd6mg97d3jk7405g6nm";
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
