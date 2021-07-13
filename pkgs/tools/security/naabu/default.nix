{ buildGoModule
, fetchFromGitHub
, lib
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "v${version}";
    sha256 = "sha256-t5Ij3UeH3z8obOH90cnmwcX9iC97sH7VIKvannSZ+MM=";
  };

  vendorSha256 = "sha256-veOIt3hELk3smrGlTyldtdaz5uI4U8/2SeD0UNykB8A=";

  buildInputs = [ libpcap ];

  preBuild = ''
    mv v2/* .
  '';

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
