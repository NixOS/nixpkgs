{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1tYC76g3GOqMaosAYYXOrOKTdW7muPTaeeLzGUsjogE=";
  };

  vendorSha256 = "sha256-2gWifzBjAx+c/if6ZZQ/s73oPPTY9eJfHYL4F/058h0=";

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
