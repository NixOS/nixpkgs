{
  mkKdeDerivation,
  qttools,
  accounts-qt,
  kaccounts-integration,
  shared-mime-info,
  xz,
}:
mkKdeDerivation {
  pname = "akonadi";

  # FIXME(later): investigate nixpkgs patches

  extraNativeBuildInputs = [qttools shared-mime-info];
  extraBuildInputs = [kaccounts-integration accounts-qt xz];
}
