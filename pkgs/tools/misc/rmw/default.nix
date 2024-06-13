{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, canfigger
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "rmw";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "theimpossibleastronaut";
    repo = "rmw";
    rev = "v${version}";
    hash = "sha256-5/oOV0FAXo/QchoIF/hwCwaNVBwsTyDSe65UE3/03PQ=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    canfigger
    ncurses
  ];

  meta = with lib; {
    description = "Trashcan/ recycle bin utility for the command line";
    homepage = "https://github.com/theimpossibleastronaut/rmw";
    changelog = "https://github.com/theimpossibleastronaut/rmw/blob/${src.rev}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "rmw";
  };
}
