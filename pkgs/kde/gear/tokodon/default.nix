{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  qtsvg,
  qtwebsockets,
  qtwebview,
  mpv,
  kitemmodels,
  sonnet,
}:
mkKdeDerivation {
  pname = "tokodon";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtmultimedia qtsvg qtwebsockets qtwebview mpv kitemmodels sonnet];
  meta.mainProgram = "tokodon";
}
