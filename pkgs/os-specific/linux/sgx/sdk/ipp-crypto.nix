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
  version = "2021.7";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipp-crypto";
    rev = "ippcp_${version}";
    hash = "sha256-3W0LlJgmrp2Rk7xQ+0GQfkF2UpH4htx9R7IL86smtnY=";
  };

  cmakeFlags = [ "-DARCH=intel64" ] ++ extraCmakeFlags;

  nativeBuildInputs = [
    cmake
    nasm
    openssl
    python3
  ];
}
