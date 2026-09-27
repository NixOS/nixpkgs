{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "bovo";

  extraNativeBuildInputs = [ _7zz ];
  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "bovo";
}
