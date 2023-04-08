{ lib, stdenv, fetchFromGitHub, cmake, zlib, openssl }:

stdenv.mkDerivation rec {
  pname = "unshield";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = version;
    sha256 = "1p2inn93svm83kr5p0j1al0rx47f1zykmagxsblgy04gi942iza3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib openssl ];

  meta = with lib; {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = "https://github.com/twogood/unshield";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
