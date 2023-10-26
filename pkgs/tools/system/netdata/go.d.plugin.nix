{ lib, fetchFromGitHub, buildGo121Module, nixosTests }:

buildGo121Module rec {
  pname = "netdata-go-plugins";
  version = "0.56.3";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    hash = "sha256-T7UB7qrcMTqIFRzBxbXmSqtcEFgZd0/z4EYuH/ydVi4=";
  };

  vendorHash = "sha256-N0p03urHC3d17VQ4TIs7mAemW9ZSpQw20EwwD6lSLLc=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  passthru.tests = { inherit (nixosTests) netdata; };

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    changelog = "https://github.com/netdata/go.d.plugin/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.raitobezarius ];
  };
}
