{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "smtprelay";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    rev = "refs/tags/v${version}";
    hash = "sha256-8N+JJp0/d59s8rU7t0YtrTepVXpxXc8PET1f+AgEpG0=";
  };

  vendorHash = "sha256-BX1Ll0EEo59p+Pe5oM6+6zT6fvnv1RsfX8YEh9RKkWU=";

  subPackages = [
    "."
  ];

  CGO_ENABLED = 0;

  # We do not supply the build time as the build wouldn't be reproducible otherwise.
  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/decke/smtprelay";
    description = "Simple Golang SMTP relay/proxy server";
    mainProgram = "smtprelay";
    changelog = "https://github.com/decke/smtprelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ juliusrickert ];
  };
}
