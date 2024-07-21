{
  mkKdeDerivation,
  shared-mime-info,
  akonadi-mime,
}:
mkKdeDerivation {
  pname = "kleopatra";

  extraNativeBuildInputs = [shared-mime-info];
  extraBuildInputs = [akonadi-mime];
}
