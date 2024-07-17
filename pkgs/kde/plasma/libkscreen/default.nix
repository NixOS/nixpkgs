{
  mkKdeDerivation,
  qtwayland,
  qttools,
  jq,
}:
mkKdeDerivation {
  pname = "libkscreen";

  extraNativeBuildInputs = [
    qttools
    qtwayland
    jq
  ];
  extraBuildInputs = [ qtwayland ];
  meta.mainProgram = "kscreen-doctor";
}
