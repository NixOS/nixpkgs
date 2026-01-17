{
  lib,
  stdenv,
  mkKdeDerivation,
  pkg-config,
  gpgme,
  libgcrypt,
  libsecret,
  kdoctools,
}:
mkKdeDerivation {
  pname = "kwallet";

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    gpgme
    libgcrypt
    libsecret
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    kdoctools
  ];

  extraCmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "BUILD_KWALLET_QUERY" false)
  ];
}
