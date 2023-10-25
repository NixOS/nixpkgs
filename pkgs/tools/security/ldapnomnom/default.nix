{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-o29vcPKRX8TWRCpa20DVsh/4K7d3IbaLS3B+jJGBEmo=";
  };

  vendorHash = "sha256-3ucnLD+qhBSWY2wLtBcsOcuEf1woqHP17qQg7LlERA8=";

  meta = with lib; {
    description = "Tool to anonymously bruteforce usernames from Domain controllers";
    homepage = "https://github.com/lkarlslund/ldapnomnom";
    changelog = "https://github.com/lkarlslund/ldapnomnom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
