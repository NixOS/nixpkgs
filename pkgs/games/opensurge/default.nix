{ lib
, stdenv
, fetchFromGitHub
, cmake
, allegro5
, surgescript
}:

stdenv.mkDerivation rec {
  pname = "opensurge";
  version = "0.6.0.3";

  src = fetchFromGitHub {
    owner = "alemart";
    repo = "opensurge";
    rev = "v${version}";
    hash = "sha256-pawdanCGUzezGlHMia3fpdtNU1FI04uJUYEctRkWKno=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    allegro5
    surgescript
  ];

  cmakeFlags = [
    "-DGAME_BINDIR=${placeholder "out"}/bin"
    "-DGAME_DATADIR=${placeholder "out"}/share/opensurge"
    "-DDESKTOP_ICON_PATH=${placeholder "out"}/share/pixmaps"
    "-DDESKTOP_METAINFO_PATH=${placeholder "out"}/share/metainfo"
    "-DDESKTOP_ENTRY_PATH=${placeholder "out"}/share/applications"
  ];

  meta = with lib; {
    description = "A fun 2D retro platformer inspired by Sonic games and a game creation system";
    homepage = "https://opensurge2d.org/";
    changelog = "https://github.com/alemart/opensurge/blob/${src.rev}/CHANGES.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ federicoschonborn ];
  };
}
