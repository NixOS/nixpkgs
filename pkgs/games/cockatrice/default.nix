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
    sha256 = "0q8ffcklb2b7hcqhy3d2f9kz9aw22pp04pc9y4sslyqmf17pwnz9";
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
