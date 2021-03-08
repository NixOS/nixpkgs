{ buildGoModule
, fetchFromGitHub
, lib
, libpcap
}:

buildGoModule rec {
  pname = "naabu";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "naabu";
    rev = "v${version}";
    sha256 = "05iybf7q3y0piyw202yzld89fiz2dv2pmnpm1pd905phk5a23n1x";
  };

  vendorSha256 = "111qvkqdcdgir3dz267xckzlnfx72flnyi7ki7fa6ml7mkfyf70y";

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
