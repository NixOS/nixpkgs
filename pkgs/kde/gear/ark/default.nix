{
  mkKdeDerivation,
  libarchive,
  libzip,
}:
mkKdeDerivation {
  pname = "ark";

  extraBuildInputs = [libarchive libzip];
}
