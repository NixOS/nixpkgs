{
  mkKdeDerivation,
  qtwebengine,
  qttools,
  libxslt,
  phonon,
}:
mkKdeDerivation {
  pname = "mailcommon";

  extraNativeBuildInputs = [ libxslt ];
  extraBuildInputs = [
    qtwebengine
    qttools
    phonon
  ];
}
