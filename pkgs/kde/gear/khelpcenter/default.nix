{
  mkKdeDerivation,
  qtwebengine,
  xapian,
}:
mkKdeDerivation {
  pname = "khelpcenter";

  extraBuildInputs = [qtwebengine xapian];
}
