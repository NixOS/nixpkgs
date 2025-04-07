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
  version = "2025-03-27-Release-2.10.1";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    tag = version;
    sha256 = "sha256-vM12ufqoItlDeYXHhyN3Jkqm+chGgm9gB4xtIdDbI94=";
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
