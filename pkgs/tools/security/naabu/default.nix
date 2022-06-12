{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "v${version}";
    sha256 = "sha256-pfaK2Hj6iHk8njEMEbeSHGIKTn5O3IF83At14iDNI34=";
  };

  vendorSha256 = "sha256-eco1e1A0cDk1Yc0KP9tc3Kf4E+z1av7EDHynVhoHhMk=";

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
