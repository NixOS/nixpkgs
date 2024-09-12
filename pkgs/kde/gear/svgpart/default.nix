{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "svgpart";

  extraBuildInputs = [qtsvg];
}
