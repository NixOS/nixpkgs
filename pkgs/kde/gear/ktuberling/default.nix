{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ktuberling";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qtmultimedia ];

  meta.mainProgram = "ktuberling";
}
