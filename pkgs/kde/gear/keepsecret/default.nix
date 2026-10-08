{
  mkKdeDerivation,
  pkg-config,
  libsecret,
}:
mkKdeDerivation {
  pname = "keepsecret";

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    libsecret
  ];
}
