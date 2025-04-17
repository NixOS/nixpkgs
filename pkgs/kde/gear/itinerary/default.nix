{
  mkKdeDerivation,
  fetchpatch,
  pkg-config,
  qtlocation,
  qtpositioning,
  shared-mime-info,
  libical,
}:
mkKdeDerivation {
  pname = "itinerary";

  patches = [
    # FIXME: this should really be fixed at ECM level somehow
    ./optional-runtime-dependencies.patch
    # make compatible with Qt 6.9 (QTBUG-98101)
    (fetchpatch {
      name = "Make-code-work-with-Qt-6.9-too.patch";
      url = "https://invent.kde.org/pim/itinerary/-/commit/4ac22f865b0577f0a11440417e416670231cf9dd.patch";
      hash = "sha256-JiDuGD71g0xtGolbP2NrXIW0owjJy5JeguGFwbLFAys=";
    })
  ];

  # make compatible with Qt 6.9 (QTBUG-98101)
  postPatch = ''
    substituteInPlace src/app/PassPage.qml \
      --replace-fail \
        'import Qt.labs.qmlmodels as Models' \
        'import Qt.labs.qmlmodels
    import QtQml.Models' \
      --replace-fail \
        'Models.DelegateChoice' \
        'DelegateChoice' \
      --replace-fail \
        'Models.DelegateChooser' \
        'DelegateChooser'
  '';

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];
  extraBuildInputs = [
    qtlocation
    qtpositioning
    libical
  ];
  meta.mainProgram = "itinerary";
}
