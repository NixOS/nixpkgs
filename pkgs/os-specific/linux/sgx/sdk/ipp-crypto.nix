{
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  openssl,
  python3,
  extraCmakeFlags ? [ ],
}:
stdenv.mkDerivation rec {
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
  ]
  ++ extraCmakeFlags;

  # Yes, it seems bad for a cryptography library to trigger this
  # warning. We previously pinned an EOL GCC which avoided it, but this
  # issue is present regardless of whether we use a compiler that flags
  # it up or not; upstream just doesn’t test with modern compilers.
  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow";

  nativeBuildInputs = [
    cmake
    nasm
    openssl
    python3
  ];
}
