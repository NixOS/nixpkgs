{
  mkKdeDerivation,
  pkg-config,
  qtsvg,
  flatpak,
}:
mkKdeDerivation {
  pname = "flatpak-kcm";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [flatpak qtsvg];
}
