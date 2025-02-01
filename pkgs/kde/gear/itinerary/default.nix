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

  # FIXME: this should really be fixed at ECM level somehow
  patches = [./optional-runtime-dependencies.patch];

  extraNativeBuildInputs = [pkg-config shared-mime-info];
  extraBuildInputs = [qtlocation qtpositioning libical];
  meta.mainProgram = "itinerary";
}
