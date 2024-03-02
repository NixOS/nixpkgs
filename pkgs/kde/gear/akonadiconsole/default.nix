{
  mkKdeDerivation,
  xapian,
}:
mkKdeDerivation {
  pname = "akonadiconsole";

  extraBuildInputs = [xapian];
}
