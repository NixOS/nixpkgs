{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "telepresence2";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "telepresenceio";
    repo = "telepresence";
    rev = "v${version}";
    sha256 = "1v2jkhdlyq37akqyhb8mwsh7rjdv2fjw8kyzys3dv04k3dy5sl0f";
  };

  vendorSha256 = "1snmp461h8driy1w1xggk669yxl0sjl1m9pbqm7dwk44yb94zi1q";

  ldflags = [
    "-s" "-w" "-X=github.com/telepresenceio/telepresence/v2/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/telepresence" ];

  meta = with lib; {
    description = "Local development against a remote Kubernetes or OpenShift cluster";
    homepage = "https://www.getambassador.io/docs/telepresence/2.1/quick-start/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
