{
  mkKdeDerivation,
  pkg-config,
  gpsd,
}:
mkKdeDerivation {
  pname = "plasma5support";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [ gpsd ];
}
