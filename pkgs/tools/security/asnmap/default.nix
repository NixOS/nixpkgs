{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "asnmap";
    rev = "refs/tags/v${version}";
    hash = "sha256-Of4IVra6kMHY9btWcF9grM/r3lTWFP/geeT309Seasw=";
  };

  vendorHash = "sha256-RDv8vkBI3miyeNAbhUsMpuZCYRUZ0ATfXYHxaTgTVfA=";

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
