{
  mkKdeDerivation,
  qtmultimedia,
  qttools,
  qtwebengine,
  libxslt,
}:
mkKdeDerivation {
  pname = "mailcommon";

  extraNativeBuildInputs = [ libxslt ];
  extraBuildInputs = [
    qtmultimedia
    qttools
    qtwebengine
  ];
}
