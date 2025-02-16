{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "katomic";

  extraNativeBuildInputs = [ _7zz ];

  meta.mainProgram = "katomic";
}
