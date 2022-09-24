{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+lUEsnSUcGs8knkYaI6l1r5YJU82iMlcI6E/+aqyCoY=";
  };

  vendorSha256 = "sha256-psITrOXWh+3XXLSdo862ln8n7AkO00KB4mHyTdbDCkY=";

  meta = with lib; {
    description = "Tool to anonymously bruteforce usernames from Domain controllers";
    homepage = "https://github.com/lkarlslund/ldapnomnom";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
