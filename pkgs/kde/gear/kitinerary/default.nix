{
  mkKdeDerivation,
  qtsvg,
  qtdeclarative,
  shared-mime-info,
  poppler,
  libphonenumber,
  protobuf,
}:
mkKdeDerivation {
  pname = "kitinerary";

  extraNativeBuildInputs = [ shared-mime-info ];
  extraBuildInputs = [
    qtsvg
    qtdeclarative
    poppler
    libphonenumber
    protobuf
  ];
}
