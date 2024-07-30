{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "bomber";

  extraNativeBuildInputs = [_7zz];
  meta.mainProgram = "bomber";
}
