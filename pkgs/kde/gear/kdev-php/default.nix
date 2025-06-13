{
  mkKdeDerivation,
  kdevelop-pg-qt,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kdev-php";

  extraNativeBuildInputs = [ kdevelop-pg-qt ];
  extraBuildInputs = [ qt5compat ];
}
