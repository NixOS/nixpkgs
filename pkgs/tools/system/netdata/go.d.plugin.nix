{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "netdata-go.d.plugin";
  version = "0.32.3";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "sha256-SayFqr6n6OLLUXseYiR8iBIf2xeDEHXHD0qBrgHY6+o=";
  };

  vendorSha256 = "sha256-tIuHWfAjvr5s2nJSnhnMZIjyy77BbobwgQoDOy4gdGI=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
