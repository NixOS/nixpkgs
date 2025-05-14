{
  mkKdeDerivation,
  qtwebsockets,
  kdeclarative,
  kpackage,
}:
mkKdeDerivation {
  pname = "kunifiedpush";

  extraBuildInputs = [
    qtwebsockets
    kdeclarative
    kpackage
  ];

  meta.mainProgram = "kunifiedpush-distributor";
}
