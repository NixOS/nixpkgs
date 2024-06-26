{
  mkKdeDerivation,
  qtwebengine,
  qttools,
}:
mkKdeDerivation {
  pname = "mailcommon";

  extraBuildInputs = [
    qtwebengine
    qttools
  ];
}
