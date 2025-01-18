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
  version = "2023-09-14-Release-2.9.0";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "sha256-mzYh0qRKiHY64LnoOfF4kDEO06IW1SrCqEiOlu81Fso=";
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

  meta = with lib; {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "Cross-platform virtual tabletop for multiplayer card games";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ evanjs ];
    platforms = with platforms; linux;
  };
}
