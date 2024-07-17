{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "act";
  version = "0.2.62";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zHtRdwBqwQMW/M4TYA609beCrC5B4hyhtcptJSbN6M8=";
  };

  vendorHash = "sha256-+hK1qG0p7MSYACkvzTnuPvlccbHNJRRZdC/LAM1Cp2k=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      kashw2
    ];
  };
}
