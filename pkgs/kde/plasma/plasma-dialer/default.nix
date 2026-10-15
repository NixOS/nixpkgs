{
  mkKdeDerivation,
  pkg-config,
  qtbase,
  callaudiod,
  libphonenumber,
  protobuf,
}:
mkKdeDerivation {
  pname = "plasma-dialer";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    callaudiod
    libphonenumber
    protobuf
  ];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtbase}/libexec/qtwaylandscanner"
  ];
}
