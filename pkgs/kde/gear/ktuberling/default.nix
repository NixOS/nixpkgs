{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ktuberling";

  extraNativeBuildInputs = [ qtmultimedia ];

  meta.mainProgram = "ktuberling";
}
