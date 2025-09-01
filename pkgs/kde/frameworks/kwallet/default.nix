{
  mkKdeDerivation,
  pkg-config,
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
    libgcrypt
    libsecret
    kdoctools
  ];
}
