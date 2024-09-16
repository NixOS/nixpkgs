{
  mkKdeDerivation,
  pkg-config,
  hunspell,
}:
mkKdeDerivation {
  pname = "lokalize";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [hunspell];
}
