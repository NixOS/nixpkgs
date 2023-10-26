{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "refs/tags/v${version}";
    hash = "sha256-MxIAWVcMiLLmddvyjPNprJWseOw+9ZEYV+LSMeH2Igo=";
  };

  vendorHash = "sha256-4lTik5POzK4aE3c1gGi3NuefEdbMdTLvJIkvTRSPraI=";

  buildInputs = [
    libpcap
  ];

  modRoot = "./v2";

  subPackages = [
    "cmd/naabu/"
  ];

  meta = with lib; {
    description = "Fast SYN/CONNECT port scanner";
    longDescription = ''
      Naabu is a port scanning tool written in Go that allows you to enumerate
      valid ports for hosts in a fast and reliable manner. It is a really simple
      tool that does fast SYN/CONNECT scans on the host/list of hosts and lists
      all ports that return a reply.
    '';
    homepage = "https://github.com/projectdiscovery/naabu";
    changelog = "https://github.com/projectdiscovery/naabu/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
