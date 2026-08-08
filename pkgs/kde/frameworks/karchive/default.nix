{
  mkKdeDerivation,
  qttools,
  pkg-config,
  xz,
  bzip2,
}:
mkKdeDerivation {
  pname = "karchive";

  extraNativeBuildInputs = [
    qttools
    pkg-config
  ];
  extraBuildInputs = [
    xz
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    bzip2
  ];
}
