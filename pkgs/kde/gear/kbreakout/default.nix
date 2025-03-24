{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "kbreakout";

  extraNativeBuildInputs = [ _7zz ];
  meta.mainProgram = "kbreakout";
}
