{
  mkKdeDerivation,
  bison,
  flex,
  recastnavigation,
  kcontacts,
}:
mkKdeDerivation {
  pname = "kosmindoormap";

  extraNativeBuildInputs = [
    bison
    flex
  ];
  extraBuildInputs = [ recastnavigation ];

  extraPropagatedBuildInputs = [ kcontacts ];
}
