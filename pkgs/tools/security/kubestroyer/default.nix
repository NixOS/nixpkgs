{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubestroyer";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Rolix44";
    repo = "Kubestroyer";
    rev = "refs/tags/v${version}";
    hash = "sha256-M/abb2IT0mXwj8lAitr18VtIgC4NvapPywBwcUWr9i8=";
  };

  vendorHash = "sha256-x0lIi4QUuYn0kv0HV4h8k61kRu10LCyELudisqUdTAg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Kubernetes exploitation tool";
    homepage = "https://github.com/Rolix44/Kubestroyer";
    changelog = "https://github.com/Rolix44/Kubestroyer/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "kubestroyer";
  };
}
