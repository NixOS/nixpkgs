{
  mkKdeDerivation,
  qt5compat,
  libarchive,
  shared-mime-info,
}:
mkKdeDerivation {
  pname = "kbackup";

  extraNativeBuildInputs = [ shared-mime-info ];
  extraBuildInputs = [
    qt5compat
    libarchive
  ];
  meta.mainProgram = "kbackup";
}
