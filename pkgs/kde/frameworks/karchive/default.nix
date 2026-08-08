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
    bzip2
  ];
}
