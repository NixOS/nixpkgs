{
  mkKdeDerivation,
  pkg-config,
  qtlocation,
  qtpositioning,
  shared-mime-info,
  libical,
}:
mkKdeDerivation {
  pname = "itinerary";

  extraNativeBuildInputs = [pkg-config shared-mime-info];
  extraBuildInputs = [qtlocation qtpositioning libical];
}
