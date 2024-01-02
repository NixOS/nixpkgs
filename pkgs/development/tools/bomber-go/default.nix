{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bomber-go";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "devops-kung-fu";
    repo = "bomber";
    rev = "refs/tags/v${version}";
    hash = "sha256-TsN/1ZtxVLJIWa7YkkCBzDF3xTeFKzSPLA7tIVe1oCI=";
  };

  vendorHash = "sha256-P2g8KfQ+jNZla5GKONtB4MjDnTGBUtd9kmCi0j1xq7s=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    "-skip=TestEnrich" # Requires network access
  ];

  meta = with lib; {
    description = "Tool to scans Software Bill of Materials (SBOMs) for vulnerabilities";
    homepage = "https://github.com/devops-kung-fu/bomber";
    changelog = "https://github.com/devops-kung-fu/bomber/releases/tag/v${version}";
    license = licenses.mpl20;
    mainProgram = "bomber";
    maintainers = with maintainers; [ fab ];
  };
}
