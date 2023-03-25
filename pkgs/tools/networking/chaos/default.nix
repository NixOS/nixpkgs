{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-3snVQKmtIhyWNBbSLnBQIvz0bEFs8ur5FhTne3gb/h4=";
  };

  vendorHash = "sha256-tyH3gqD5HpEvIoki0XnGDKD08iW8tENkCPuLC9GUDQk=";

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
