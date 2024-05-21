{
  mkKdeDerivation,
  qtwebengine,
  xapian,
}:
mkKdeDerivation {
  pname = "khelpcenter";

  extraBuildInputs = [qtwebengine xapian];
  meta.mainProgram = "khelpcenter";
}
