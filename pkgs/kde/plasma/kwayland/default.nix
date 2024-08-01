{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
}:
mkKdeDerivation {
  pname = "kwayland";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland];
}
