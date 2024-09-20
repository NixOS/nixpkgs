{
  mkKdeDerivation,
  qtdeclarative,
  python3,
  gettext,
}:
mkKdeDerivation {
  pname = "ki18n";

  extraNativeBuildInputs = [python3];
  propagatedNativeBuildInputs = [gettext];
  extraBuildInputs = [qtdeclarative];
}
