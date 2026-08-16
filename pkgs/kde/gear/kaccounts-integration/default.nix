{
  mkKdeDerivation,
  intltool,
}:
mkKdeDerivation {
  pname = "kaccounts-integration";

  propagatedNativeBuildInputs = [ intltool ];
}
