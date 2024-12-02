{
  mkKdeDerivation,
  pkg-config,
  packagekit-qt,
}:
mkKdeDerivation {
  pname = "frameworkintegration";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ packagekit-qt ];
}
