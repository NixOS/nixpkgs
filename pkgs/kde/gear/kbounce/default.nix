{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "kbounce";

  extraNativeBuildInputs = [ _7zz ];
  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "kbounce";
}
