{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X1Ow11ECwu2a/VzimrKGRJKCnZWL8KJ5Gii+pjP5b9E=";
  };

  vendorHash = "sha256-T1xrJ44xB95+ZhQPCYlcbH1gIQm7ETtTnQLl/+TRxVA=";

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
    maintainers = with maintainers; [ fpletz Br1ght0ne Misaka13514 ];
  };
}
