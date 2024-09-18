{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  qtsvg,
  qtwebsockets,
  qtwebview,
  mpv-unwrapped,
  sonnet,
}:
mkKdeDerivation {
  pname = "tokodon";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtmultimedia qtsvg qtwebsockets qtwebview mpv-unwrapped sonnet];
  meta.mainProgram = "tokodon";
}
