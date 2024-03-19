{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "refs/tags/v${version}";
    hash = "sha256-4aFr0kSKsNVXmYNYSt6mP4HryyIYvUKdzIYWjgPhG1Y=";
  };

  vendorHash = "sha256-QHVB8ovAWECb4n6CKTK4tnGgTrJSFxIV0KZk4PEYInE=";

  buildInputs = [
    libpcap
  ];

  modRoot = "./v2";

  subPackages = [
    "cmd/naabu/"
  ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Fast SYN/CONNECT port scanner";
    mainProgram = "naabu";
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
