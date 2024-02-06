{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+Xw4fom7lNfVxbGGoeWG7f37Gk1Dic+jzozh6HodplE=";
  };

  vendorHash = "sha256-n+FKmgluRfzhufia5rPqLKt4owCyWO4bP6Zgi+4Ax9w=";

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
