{
  mkKdeDerivation,
  extra-cmake-modules,
  qtwebchannel,
  qtwebengine,
  qttools,
  python3Packages,
}:
mkKdeDerivation {
  pname = "falkon";

  extraNativeBuildInputs = [qttools qtwebchannel qtwebengine];
  extraBuildInputs = [extra-cmake-modules qtwebchannel qtwebengine python3Packages.pyside6];
  meta.mainProgram = "falkon";
}
