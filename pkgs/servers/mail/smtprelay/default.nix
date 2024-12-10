{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "smtprelay";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    rev = "refs/tags/v${version}";
    hash = "sha256-zZ3rgbo8nvrpFMtUmhyXnTgoVd0FIh1kWzuM2hCh5gY=";
  };

  vendorHash = "sha256-assGzM8/APNVVm2vZapPK6sh3tWNTnw6PSFwvEqNDPk=";

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
