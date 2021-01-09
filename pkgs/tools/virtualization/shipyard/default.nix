{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shipyard";
  version = "0.1.17";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shipyard-run";
    repo = pname;
    sha256 = "13cp7qpxchnyxdm26xwdcp557nj16f4h8vlj0p4h79z5g7pcklln";
  };
  vendorSha256 = "0gib9s09lz91wawbms9zq4wc5k6bdxfzpxm8q92h0bsjw1bj1hzs";

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "Shipyard is a tool for building modern cloud native development environments";
    homepage = "https://shipyard.run";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
