{
  mkKdeDerivation,
  qtwayland,
  jq,
  wayland,
}:
mkKdeDerivation {
  pname = "libkscreen";

  extraNativeBuildInputs = [
    qtwayland
    jq
    wayland
  ];
  extraBuildInputs = [ qtwayland ];
  meta.mainProgram = "kscreen-doctor";
}
