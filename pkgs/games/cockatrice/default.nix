{ lib, fetchFromGitHub, mkDerivation, cmake, protobuf
, qtbase, qtmultimedia, qttools, qtwebsockets, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "cockatrice";
  version = "2021-01-26-Release-2.8.0";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "sha256-6Vt+T3AVe6o18YldAu4Vgqv0Z3KiDQ8xg2eJRSdzDmE=";
  };

  buildInputs = [
     qtbase qtmultimedia protobuf qttools qtwebsockets
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "A cross-platform virtual tabletop for multiplayer card games";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = with lib.platforms; linux;
  };
}
