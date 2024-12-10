{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gowitness";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    rev = "refs/tags/${version}";
    hash = "sha256-37OorjzxDu27FNAz4LTtQdFjt0tL9jSb9tGZhlq797Q=";
  };

  vendorHash = "sha256-Exw5NfR3nDYH+hWMPOKuVIRyrVkOJyP7Kwe4jzQwnsI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Web screenshot utility";
    mainProgram = "gowitness";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
