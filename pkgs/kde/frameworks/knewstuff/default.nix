{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  kcmutils,
}:
mkKdeDerivation {
  pname = "knewstuff";

  # Late resolve knsrcdir so other things install to their own prefix
  # FIXME(later): upstream
  patches = [ ./delay-resolving-knsrcdir.patch ];

  extraBuildInputs = [
    qtdeclarative
    qttools
  ];
  extraPropagatedBuildInputs = [ kcmutils ];

  dontQmlLint = true; # weird namespace setup

  meta.mainProgram = "knewstuff-dialog6";
}
