{
  mkKdeDerivation,
  pkg-config,
  qt5compat,
  audit,
}:
mkKdeDerivation {
  pname = "ksystemlog";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qt5compat audit];
  meta.mainProgram = "ksystemlog";
}
