{ lib, fetchFromGitHub, mkDerivation, cmake, protobuf
, qtbase, qtmultimedia, qttools, qtwebsockets, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "cockatrice";
  version = "2021-02-03-Development-2.8.1-beta";

  src = fetchFromGitHub {
    owner = "Cockatrice";
    repo = "Cockatrice";
    rev = version;
    sha256 = "0g1d7zq4lh4jf08mvvgp6m2r2gdvy4y1mhf46c0s8607h2l8vavh";
  };

  buildInputs = [
     qtbase qtmultimedia protobuf qttools qtwebsockets
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  meta = {
    homepage = "https://github.com/Cockatrice/Cockatrice";
    description = "A cross-platform virtual tabletop for multiplayer card games";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = with lib.platforms; linux;
  };
}
