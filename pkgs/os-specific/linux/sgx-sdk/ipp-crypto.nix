{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, nasm
, extraCmakeFlags ? []
}:

stdenv.mkDerivation rec {
  pname = "ipp-crypto";
  version = "2020_update3";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipp-crypto";
    rev = "ipp-crypto_${version}";
    sha256 = "02vlda6mlhbd12ljzdf65klpx4kmx1ylch9w3yllsiya4hwqzy4b";
  };

  cmakeFlags = [ "-DARCH=intel64" ] ++ extraCmakeFlags;

  nativeBuildInputs = [ cmake python3 nasm ];
}
