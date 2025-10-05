{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "qrca";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtmultimedia ];
}
