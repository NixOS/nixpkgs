{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "ldapnomnom";
    rev = "refs/tags/v${version}";
    hash = "sha256-enFTv8RqZpyS6LEqGIi55VMhArJy7Nhv0YhuWAOWyN0=";
  };

  vendorHash = "sha256-Iry9GoKOiXf83YudpmgHQRaP8GV4zokpX2mRAXoxSDQ=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool to anonymously bruteforce usernames from Domain controllers";
    homepage = "https://github.com/lkarlslund/ldapnomnom";
    changelog = "https://github.com/lkarlslund/ldapnomnom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ldapnomnom";
  };
}
