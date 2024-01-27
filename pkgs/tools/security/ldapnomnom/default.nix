{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "ldapnomnom";
    rev = "refs/tags/v${version}";
    hash = "sha256-3s2mLNqnJ+wZ17gy8Yr2Ze0S62A1bmE91E2ciLNO14E=";
  };

  vendorHash = "sha256-3ucnLD+qhBSWY2wLtBcsOcuEf1woqHP17qQg7LlERA8=";

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
