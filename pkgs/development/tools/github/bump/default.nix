{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bump";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DFgNx0H9/hZ+wUdPkEybRCIjnLsmuoYWruYgbDuFRhU=";
  };

  vendorHash = "sha256-AiXbCS3RXd6KZwIo7qzz3yM28cJloLRR+gdWqEpyims=";

  doCheck = false;

  ldflags = [
    "-X main.buildVersion=${version}" "-X main.buildCommit=${version}" "-X main.buildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/mroth/bump";
    description = "CLI tool to draft a GitHub Release for the next semantic version";
    maintainers = with maintainers; [ doronbehar ];
  };
}
