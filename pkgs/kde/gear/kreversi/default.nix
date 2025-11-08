{
  mkKdeDerivation,
  qtsvg,
  _7zz,
}:
mkKdeDerivation {
  pname = "kreversi";

  extraNativeBuildInputs = [ _7zz ];
  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "kreversi";
}
