{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "kollision";

  extraNativeBuildInputs = [ _7zz ];

  meta.mainProgram = "kollision";
}
