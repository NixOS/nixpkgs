{
  mkKdeDerivation,
  pkg-config,
  gpgmepp,
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
    gpgmepp
    libgcrypt
    libsecret
    kdoctools
  ];
}
