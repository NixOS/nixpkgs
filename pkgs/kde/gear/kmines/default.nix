{
  mkKdeDerivation,
  _7zz,
}:
mkKdeDerivation {
  pname = "kmines";

  extraNativeBuildInputs = [ _7zz ];

  meta.mainProgram = "kmines";
}
