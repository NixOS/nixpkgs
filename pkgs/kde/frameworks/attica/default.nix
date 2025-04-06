{
  mkKdeDerivation,
  validatePkgConfig,
  autoPatchPcHook,
}:
mkKdeDerivation {
  pname = "attica";

  extraNativeBuildInputs = [
    validatePkgConfig
    autoPatchPcHook
  ];
}
