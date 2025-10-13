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
  version = "2025-04-03-Release-2.10.2";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "sha256-zXAK830SdGT3xN3ST8h9LLy/oWr4MH6TZf57gLfI0e8=";
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
