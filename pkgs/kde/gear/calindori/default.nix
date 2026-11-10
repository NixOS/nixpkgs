{
  mkKdeDerivation,
  qtsvg,
  kirigami-addons,
}:
mkKdeDerivation {
  pname = "calindori";

  extraBuildInputs = [
    qtsvg
    kirigami-addons
  ];
}
