{
  mkKdeDerivation,
  shared-mime-info,
}:
mkKdeDerivation {
  pname = "bluedevil";

  outptus = [
    "out"
    "doc"
  ];

  extraNativeBuildInputs = [ shared-mime-info ];
}
