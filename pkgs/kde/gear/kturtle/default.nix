{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kturtle";

  extraBuildInputs = [ qtsvg ];
  meta.mainProgram = "kturtle";
}
