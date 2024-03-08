{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kturtle";

  extraBuildInputs = [qtsvg];
}
