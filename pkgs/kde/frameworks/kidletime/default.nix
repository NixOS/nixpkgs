{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  xorg,
}:
mkKdeDerivation {
  pname = "kidletime";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland xorg.libXScrnSaver];
}
