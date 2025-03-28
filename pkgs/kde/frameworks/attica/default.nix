{
  mkKdeDerivation,
  autoPatchPcHook,
}:
mkKdeDerivation {
  pname = "attica";

  extraNativeBuildInputs = [ autoPatchPcHook ];
}
