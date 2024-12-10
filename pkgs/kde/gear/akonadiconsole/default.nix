{
  mkKdeDerivation,
  xapian,
}:
mkKdeDerivation {
  pname = "akonadiconsole";

  extraBuildInputs = [ xapian ];
  meta.mainProgram = "akonadiconsole";
}
