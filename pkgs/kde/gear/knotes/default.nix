{
  mkKdeDerivation,
  libxslt,
}:
mkKdeDerivation {
  pname = "knotes";

  extraNativeBuildInputs = [libxslt];
}
