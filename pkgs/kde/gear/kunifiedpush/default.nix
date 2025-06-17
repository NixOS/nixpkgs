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
    qtwebsockets
    kdeclarative
    kpackage
  ];

  meta.mainProgram = "kunifiedpush-distributor";
}
