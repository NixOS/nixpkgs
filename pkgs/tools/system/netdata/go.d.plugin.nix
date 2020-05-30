{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "netdata-go.d.plugin";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "15h4075lwqh58ssdgyq34jj8r4dga0sz7h18dzy4nir75p8a0s7b";
  };

  vendorSha256 = "1pw9pb3rdjzf2dx1p1jiqxs7qhlpjki7fy74nyxza5wzrv4317sj";

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