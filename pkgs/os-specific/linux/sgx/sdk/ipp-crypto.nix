{
  gcc11Stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  openssl,
  python3,
  extraCmakeFlags ? [ ],
}:
gcc11Stdenv.mkDerivation rec {
  pname = "ipp-crypto";
  version = "2021.11.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipp-crypto";
    rev = "ippcp_${version}";
    hash = "sha256-OgNrrPE8jFVD/hcv7A43Bno96r4Z/lb7/SE6TEL7RDI=";
  };

  cmakeFlags = [
    "-DARCH=intel64"
    # sgx-sdk now requires FIPS-compliance mode turned on
    "-DIPPCP_FIPS_MODE=on"
  ] ++ extraCmakeFlags;

  nativeBuildInputs = [
    cmake
    nasm
    openssl
    python3
  ];
}
