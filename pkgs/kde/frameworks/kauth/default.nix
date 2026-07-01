{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kauth";

  # Late resolve paths so things end up in their own prefix
  # FIXME(later): discuss with upstream
  patches = [ ./fix-paths.patch ];

  extraNativeBuildInputs = [ qttools ];
}
