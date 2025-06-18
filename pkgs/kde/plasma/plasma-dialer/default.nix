{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  callaudiod,
  libphonenumber,
  protobuf,
}:
mkKdeDerivation {
  pname = "plasma-dialer";

  extraNativeBuildInputs = [
    pkg-config
    qtwayland
  ];

  extraBuildInputs = [
    qtwayland
    callaudiod
    libphonenumber
    protobuf
  ];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];
}
