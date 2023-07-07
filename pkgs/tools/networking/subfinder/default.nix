{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oNRQ+71j+i2ED3JJ+7iMh0jTpbxDD+b/P1rTT47YSmc=";
  };

  vendorHash = "sha256-KEmTbMt8gPTEvoLDLpFWO/8JS0So+g9oh0wc8kfeqhw=";

  modRoot = "./v2";

  subPackages = [
    "cmd/subfinder/"
  ];

  meta = with lib; {
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = "https://github.com/projectdiscovery/subfinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz Br1ght0ne ];
  };
}
