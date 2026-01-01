{
  mkKdeDerivation,
  pkg-config,
  qtlocation,
  qtpositioning,
<<<<<<< HEAD
  qcoro,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  shared-mime-info,
  libical,
}:
mkKdeDerivation {
  pname = "itinerary";

  # FIXME: this should really be fixed at ECM level somehow
  patches = [ ./optional-runtime-dependencies.patch ];

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];
  extraBuildInputs = [
    qtlocation
    qtpositioning
<<<<<<< HEAD
    qcoro
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libical
  ];
  meta.mainProgram = "itinerary";
}
