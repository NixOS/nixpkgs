{
  mkKdeDerivation,
  qtscxml,
  qtsvg,
}:
mkKdeDerivation {
  pname = "konquest";

  extraNativeBuildInputs = [ qtscxml ];
  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "konquest";
}
