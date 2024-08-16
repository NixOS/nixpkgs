{
  mkKdeDerivation,
  ki18n,
}:
mkKdeDerivation {
  pname = "kmime";

  extraBuildInputs = [ki18n];
}
