{
  mkKdeDerivation,
  pkg-config,
  gpgme,
}:
mkKdeDerivation {
  pname = "kgpg";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [gpgme];
  meta.mainProgram = "kgpg";
}
