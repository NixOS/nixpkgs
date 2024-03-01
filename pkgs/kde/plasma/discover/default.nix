{
  mkKdeDerivation,
  qtwebview,
  pkg-config,
  discount,
  flatpak,
  fwupd,
}:
mkKdeDerivation {
  pname = "discover";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwebview discount flatpak fwupd];
}
