{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2k/WyAM8h2P2gCLt2J9m/ZekrzCyf/LULGOQYy5bsZs=";
  };

  vendorHash = "sha256-gAjR1MoudBAx1dxGObIVPqJdfehWkKckKtwM7sTP0w4=";

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
    mainProgram = "dnsmonster";
  };
}
