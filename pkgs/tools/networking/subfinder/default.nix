{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SVfBWOaDh2wE0XwoUzXOFohjHcb5upWILdWuUW0dwr8=";
  };

  vendorHash = "sha256-2Ob2oU7XBnqiWiR3td/lXDWl863ihx7j3iwP2CUGG/U=";

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
