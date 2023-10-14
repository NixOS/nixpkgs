{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "routedns";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${version}";
    hash = "sha256-whMSqGsZTr6tj9jbUzkNanR69xfmvXC257DsHooqlkE=";
  };

  vendorHash = "sha256-XqrV/eBpKzFgNSG9yoP8iqzIEifXEMOCCfPbHo3YKZw=";

  subPackages = [ "./cmd/routedns" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/folbricht/routedns";
    description = "DNS stub resolver, proxy and router";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jsimonetti ];
  };
}
