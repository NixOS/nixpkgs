{
  mkKdeDerivation,
  qtsvg,
  shared-mime-info,
}:
mkKdeDerivation {
  pname = "palapeli";

  extraNativeBuildInputs = [shared-mime-info];
  extraBuildInputs = [qtsvg];
  meta.mainProgram = "palapeli";
}
