{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bomber-go";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "devops-kung-fu";
    repo = "bomber";
    rev = "refs/tags/v${version}";
    hash = "sha256-vFdXtkz2T6kP/j/j9teHpf4XesqOmKFliZJRyGZKdwg=";
  };

  vendorHash = "sha256-GHzJQVq748kG+X9amsQmqZ2cRzwQDO5LfBqvZwVn6W8=";

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
