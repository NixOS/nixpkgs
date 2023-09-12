{ gcc11Stdenv
, fetchFromGitHub
, cmake
, nasm
, openssl_1_1
, python3
, extraCmakeFlags ? [ ]
}:
gcc11Stdenv.mkDerivation rec {
  pname = "ipp-crypto";
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
    # TODO(phlip9): The most recent `ipp-crypto` version (2021.9) now uses
    # OpenSSL v3 so we can avoid this EOL version when sgx-sdk updates.
    openssl_1_1
    python3
  ];
}
