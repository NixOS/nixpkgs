{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kirigami-gallery";

  extraNativeBuildInputs = [ qtsvg ];
}
