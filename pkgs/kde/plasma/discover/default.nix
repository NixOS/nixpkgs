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

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwebview
    discount
    flatpak
    fwupd
  ];

  # The PackageKit backend doesn't work for us and causes Discover
  # to freak out when loading. Disable it to not confuse users.
  excludeDependencies = [ "packagekit-qt" ];
}
