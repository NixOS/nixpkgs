{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "unifi-poller";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "unifi-poller";
    repo = "unifi-poller";
    rev = "v${version}";
    sha256 = "16q9hrbl9qgilj3vb7865l1yx0xhm7m4sx5j1ys5vi63drq59g93";
  };

  vendorSha256 = "1fgcbg34g0a0f85qv7bjanv2lpnnszcrspfppp2lnj9kv52j4c1w";

  buildFlagsArray = ''
    -ldflags=-w -s
      -X github.com/prometheus/common/version.Branch=master
      -X github.com/prometheus/common/version.BuildDate=unknown
      -X github.com/prometheus/common/version.Revision=${src.rev}
      -X github.com/prometheus/common/version.Version=${version}-0
  '';

  meta = with lib; {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unifi-poller/unifi-poller";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
    platforms = platforms.unix;
  };
}
