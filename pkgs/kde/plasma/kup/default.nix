{
  mkKdeDerivation,
  libgit2,
}:
mkKdeDerivation {
  pname = "kup";

  extraBuildInputs = [ libgit2 ];
}
