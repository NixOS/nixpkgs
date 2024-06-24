{ lib
, buildGoModule
, fetchFromGitHub
, unstableGitUpdater
}:

buildGoModule {
  pname = "bodyclose";
  version = "0-unstable-2024-01-26";

  src = fetchFromGitHub {
    owner = "timakin";
    repo = "bodyclose";
    rev = "f835fa56326ac81b2d54408f1a3a6c43bca4d5aa";
    hash = "sha256-yPvBDJx6ECrSLDazdNDRl79iogsZO2qNWHuUuwQoRHU=";
  };

  vendorHash = "sha256-8grdJuV8aSETsJr2VazC/3ctfnGh3UgjOWD4/xf3uC8=";

  ldflags = [ "-s" "-w" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "Golang linter to check whether HTTP response body is closed and a re-use of TCP connection is not blocked";
    mainProgram = "bodyclose";
    homepage = "https://github.com/timakin/bodyclose";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
