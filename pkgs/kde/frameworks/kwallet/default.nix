{
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
    kdoctools
  ];
}
