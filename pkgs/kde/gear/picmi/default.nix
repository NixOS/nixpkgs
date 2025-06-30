{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "picmi";

  extraNativeBuildInputs = [ _7zz ];
  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "picmi";
}
