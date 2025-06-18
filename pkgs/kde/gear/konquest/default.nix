{
  mkKdeDerivation,
  qtscxml,
  qtsvg,
}:
mkKdeDerivation {
  pname = "konquest";

  extraNativeBuildInputs = [ qtscxml ];

  extraBuildInputs = [
    qtscxml
    qtsvg
  ];

  meta.mainProgram = "konquest";
}
