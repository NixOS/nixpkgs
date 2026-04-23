{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "kolf";

  extraNativeBuildInputs = [ _7zz ];

  meta.mainProgram = "kolf";
}
