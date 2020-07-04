{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "netdata-go.d.plugin";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "03a67kvhickzg96jvzxhg1jih48m96rl4mkg0wgmbi7a676dl7lq";
  };

  vendorSha256 = "0mmnkkzpv8lmxn11idikddmjinxv1y823ny0wxp271agiinyfpn8";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    license = licenses.gpl3;
    maintainers = [ maintainers.lethalman ];
  };
}
