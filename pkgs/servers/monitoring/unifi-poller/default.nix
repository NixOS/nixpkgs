{ stdenv, buildGoModule, fetchFromGitHub }:

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

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/prometheus/common/version.Version=${version}" ];

  meta = with stdenv.lib; {
    description = "Unifi-polles collects UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unifi-poller/unifi-poller";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
  };
}
