{
  mkKdeDerivation,
  qtwebengine,
  taglib,
  libmaxminddb,
}:
mkKdeDerivation {
  pname = "ktorrent";

  extraNativeBuildInputs = [ qtwebengine ];

  extraBuildInputs = [
    qtwebengine
    taglib
    libmaxminddb
  ];
}
