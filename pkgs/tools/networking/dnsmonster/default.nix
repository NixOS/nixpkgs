{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fpyx2/2P2tMx/n5pCZkUie3uU9jarRU2QVMBs8jEc6Q=";
  };

  vendorSha256 = "sha256-kZkzTi3i8J6K8x+nSjGeyzEBRPeDEP6qX5KMv/weAXg=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mosajjal/dnsmonster/util.releaseVersion=${version}"
  ];

  meta = with lib; {
    description = "Passive DNS Capture and Monitoring Toolkit";
    homepage = "https://github.com/mosajjal/dnsmonster";
    changelog = "https://github.com/mosajjal/dnsmonster/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin;
  };
}
