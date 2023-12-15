{ lib
, gcc11Stdenv
, fetchFromGitHub
, cmake
, nasm
, openssl
, python3
, extraCmakeFlags ? [ ]
# We built this derivation in multiple flavors. Adding a suffix makes
# problems easier to pinpoint.
, nameSuffix ? ""
}:

gcc11Stdenv.mkDerivation rec {
  pname = "ipp-crypto${nameSuffix}";
  version = "2021.10.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipp-crypto";
    rev = "ippcp_${version}";
    hash = "sha256-DfXsJ+4XqyjCD+79LUD53Cx8D46o1a4fAZa2UxGI1Xg=";
  };

  cmakeFlags = [ "-DARCH=intel64" ] ++ extraCmakeFlags;

  nativeBuildInputs = [
    cmake
    nasm
    openssl
    python3
  ];
}
