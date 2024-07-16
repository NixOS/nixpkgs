{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "subfinder";
    rev = "refs/tags/v${version}";
    hash = "sha256-A9qSrgQB7AE+9S3SW1eXRGA65RfEzrjYR2XgU8e+zMk=";
  };

  vendorHash = "sha256-j2WO+LLvioBB2EU/6ahyTn9H614Dmiskm0p7GOgqYNY=";

  modRoot = "./v2";

  subPackages = [
    "cmd/subfinder/"
  ];

  ldflags = [
    "-w"
    "-s"
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
    mainProgram = "subfinder";
  };
}
