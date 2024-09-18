{
  mkKdeDerivation,
  qtwebengine,
  taglib,
  libmaxminddb,
}:
mkKdeDerivation {
  pname = "ktorrent";

  extraBuildInputs = [qtwebengine taglib libmaxminddb];
}
