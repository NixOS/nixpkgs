{
  mkKdeDerivation,
  qtwayland,
  qttools,
  jq,
  wayland,
}:
mkKdeDerivation {
  pname = "libkscreen";

  extraNativeBuildInputs = [qttools qtwayland jq wayland];
  extraBuildInputs = [qtwayland];
  meta.mainProgram = "kscreen-doctor";
}
