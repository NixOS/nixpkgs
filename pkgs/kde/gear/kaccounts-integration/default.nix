{
  mkKdeDerivation,
  intltool,
  signon-ui,
}:
mkKdeDerivation {
  pname = "kaccounts-integration";

  propagatedNativeBuildInputs = [intltool];
  extraBuildInputs = [signon-ui];
}
