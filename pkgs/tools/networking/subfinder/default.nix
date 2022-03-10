{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RzZlr0mscJgOGWOn4RU9SOr/WkKOrY39cIUKFKxis6Y=";
  };

  vendorSha256 = "sha256-P98giu0a5FLBsE87XVTurYNGnNk8JUfz1awY49OBj9M=";

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
