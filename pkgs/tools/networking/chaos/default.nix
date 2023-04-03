{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-TpzTDNkfwL2CgEZwk2b5Zojhh61hXBm3PgjLkav6B3M=";
  };

  vendorHash = "sha256-Zu3TxBFTrXkAOmtUELjSdyzlE6CIr4SUBSdvaRnKy+k=";

  subPackages = [
    "cmd/chaos/"
  ];

  meta = with lib; {
    description = "Tool to communicate with Chaos DNS API";
    homepage = "https://github.com/projectdiscovery/chaos-client";
    changelog = "https://github.com/projectdiscovery/chaos-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
