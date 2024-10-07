{
  mkKdeDerivation,
  _7zz,
  qtsvg,
}:
mkKdeDerivation {
  pname = "granatier";

  extraNativeBuildInputs = [ _7zz ];
  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "granatier";
}
