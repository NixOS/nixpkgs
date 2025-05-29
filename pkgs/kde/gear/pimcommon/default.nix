{
  mkKdeDerivation,
  qttools,
  libxslt,
}:
mkKdeDerivation {
  pname = "pimcommon";

  extraBuildInputs = [ qttools ];
  extraNativeBuildInputs = [ libxslt ];
}
