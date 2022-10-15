{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-csYJ8jdk84Uf0Sti5wGK27NH9FFHzUHFJXV8r4FWO68=";
  };

  vendorSha256 = "sha256-+Wpn9VhFDx5NPk7lbp/iP3kdn3bvR+AL5nfivu8944I=";

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
