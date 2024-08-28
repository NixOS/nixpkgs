{
  mkKdeDerivation,
  qttools,
  pkg-config,
  xz,
}:
mkKdeDerivation {
  pname = "karchive";

  extraNativeBuildInputs = [qttools pkg-config];
  extraBuildInputs = [xz];
}
