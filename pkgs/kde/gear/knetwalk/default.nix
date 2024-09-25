{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "knetwalk";

  extraNativeBuildInputs = [ _7zz ];
  meta.mainProgram = "knetwalk";
}
