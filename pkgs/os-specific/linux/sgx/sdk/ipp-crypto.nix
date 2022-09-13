{ lib
, stdenv
, fetchFromGitHub
, cmake
, nasm
, openssl_1_1
, python3
, extraCmakeFlags ? [ ]
}:

stdenv.mkDerivation rec {
  pname = "ipp-crypto";
  version = "2021.3";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipp-crypto";
    rev = "ippcp_${version}";
    hash = "sha256-QEJXvQ//zhQqibFxXwPMdS1MHewgyb24LRmkycVSGrM=";
  };

  # Fix typo: https://github.com/intel/ipp-crypto/pull/33
  postPatch = ''
    substituteInPlace sources/cmake/ippcp-gen-config.cmake \
      --replace 'ippcpo-config.cmake' 'ippcp-config.cmake'
  '';

  cmakeFlags = [ "-DARCH=intel64" ] ++ extraCmakeFlags;

  nativeBuildInputs = [
    cmake
    nasm
    openssl_1_1
    python3
  ];
}
