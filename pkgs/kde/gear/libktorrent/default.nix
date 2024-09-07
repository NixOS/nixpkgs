{
  mkKdeDerivation,
  doxygen,
  qt5compat,
  boost,
  gmp,
  libgcrypt,
}:
mkKdeDerivation {
  pname = "libktorrent";

  extraNativeBuildInputs = [doxygen];
  extraBuildInputs = [qt5compat];
  extraPropagatedBuildInputs = [boost gmp libgcrypt];
}
