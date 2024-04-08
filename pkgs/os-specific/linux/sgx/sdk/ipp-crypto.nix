{ gcc11Stdenv
, fetchFromGitHub
, cmake
, nasm
, openssl
, python3
, extraCmakeFlags ? [ ]
}:
gcc11Stdenv.mkDerivation rec {
  pname = "ipp-crypto";
  version = "2021.9.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipp-crypto";
    rev = "ippcp_${version}";
    hash = "sha256-+ITnxyrkDQp4xRa+PVzXdYsSkI5sMNwQGfGU+lFJ6co=";
  };

  cmakeFlags = [ "-DARCH=intel64" ] ++ extraCmakeFlags;

  nativeBuildInputs = [
    cmake
    nasm
    openssl
    python3
  ];
}
