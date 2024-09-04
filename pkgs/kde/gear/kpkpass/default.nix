{
  mkKdeDerivation,
  shared-mime-info,
}:
mkKdeDerivation {
  pname = "kpkpass";

  extraNativeBuildInputs = [shared-mime-info];
}
