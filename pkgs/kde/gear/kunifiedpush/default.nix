{
  mkKdeDerivation,
  qtwebsockets,
  kdeclarative,
  kpackage,
}:
mkKdeDerivation {
  pname = "kunifiedpush";

  extraNativeBuildInputs = [ qtwebsockets ];

  extraBuildInputs = [
    kdeclarative
    kpackage
  ];

  meta.mainProgram = "kunifiedpush-distributor";
}
