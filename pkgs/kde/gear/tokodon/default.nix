{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  qtsvg,
  qtwebsockets,
  qtwebview,
  mpv-unwrapped,
  kitemmodels,
  sonnet,
}:
mkKdeDerivation {
  pname = "tokodon";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtmultimedia qtsvg qtwebsockets qtwebview mpv-unwrapped kitemmodels sonnet];
  meta.mainProgram = "tokodon";
}
