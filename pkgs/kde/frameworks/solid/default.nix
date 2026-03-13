{
  mkKdeDerivation,
  qttools,
  bison,
  flex,
  libimobiledevice,
}:
mkKdeDerivation {
  pname = "solid";

  extraNativeBuildInputs = [
    qttools
    bison
    flex
  ];
  extraBuildInputs = [ libimobiledevice ];
  meta.mainProgram = "solid-hardware6";
}
