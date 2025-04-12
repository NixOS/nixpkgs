{
  mkKdeDerivation,
  qtwebengine,
  qttools,
  libxslt,
}:
mkKdeDerivation {
  pname = "mailcommon";

  extraNativeBuildInputs = [ libxslt ];
  extraBuildInputs = [
    qtwebengine
    qttools
  ];
}
