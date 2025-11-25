{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  kirigami-addons,
}:
mkKdeDerivation {
  pname = "qrca";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtmultimedia
    kirigami-addons
  ];
}
