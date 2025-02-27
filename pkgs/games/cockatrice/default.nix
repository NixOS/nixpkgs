{
  lib,
  fetchFromGitHub,
  mkDerivation,
  cmake,
  protobuf,
  qtbase,
  qtmultimedia,
  qttools,
  qtwebsockets,
  wrapQtAppsHook,
}:

mkDerivation rec {
  pname = "cockatrice";
  version = "2025-02-10-Release-2.10.0";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "sha256-+/XmbBky0zdifofCineSIAwu16/g/UBsTJTB959twDM=";
  };

  buildInputs = [
    qtbase
    qtmultimedia
    protobuf
    qttools
    qtwebsockets
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "Cross-platform virtual tabletop for multiplayer card games";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = with lib.platforms; linux;
  };
}
