{
  mkKdeDerivation,
  shared-mime-info,
  akonadi-mime,
  kdsingleapplication,
}:
mkKdeDerivation {
  pname = "kleopatra";

  extraNativeBuildInputs = [ shared-mime-info ];
  extraBuildInputs = [
    akonadi-mime
    kdsingleapplication
  ];
}
