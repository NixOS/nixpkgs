{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "unstable-2022-09-18";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = pname;
    rev = "c6560a58c74b663f46a5fed7b63986cf96f1e366";
    hash = "sha256-tyPmCIO5ByO7pppe6dNtu+V8gtasQbzMkf5WrVG8S/I=";
  };

  vendorSha256 = "sha256-psITrOXWh+3XXLSdo862ln8n7AkO00KB4mHyTdbDCkY=";

  meta = with lib; {
    description = "Tool to anonymously bruteforce usernames from Domain controllers";
    homepage = "https://github.com/lkarlslund/ldapnomnom";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
