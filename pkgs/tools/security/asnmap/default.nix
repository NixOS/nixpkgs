{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "asnmap";
    rev = "refs/tags/v${version}";
    hash = "sha256-dGSWUuM4Zcz9QYjYaHur3RYryxe1wJycx/wUL5yqCpM=";
  };

  vendorHash = "sha256-bSpMYQvrlR9T06dYF8gaTZmMAp6Gnb2cfsYCUes7i2s=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    mainProgram = "asnmap";
    homepage = "https://github.com/projectdiscovery/asnmap";
    changelog = "https://github.com/projectdiscovery/asnmap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
