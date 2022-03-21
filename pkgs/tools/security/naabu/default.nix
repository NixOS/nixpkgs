{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "v${version}";
    sha256 = "0kbpfb1ryfqy8a54ksm7zm8pqy8f4adh06jc1ccpdxks3k0rygid";
  };

  vendorSha256 = "17x60x68hd2jm84xw5mgsclv6phn6ajkp92kpcz013vlkcdaqrxs";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
