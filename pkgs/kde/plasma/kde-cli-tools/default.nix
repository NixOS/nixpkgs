{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "kde-cli-tools";

  outputs = [
    "out"
    "doc"
    "man"
  ];

  extraBuildInputs = [ qtsvg ];
}
