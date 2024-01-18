{ lib, fetchFromGitHub, buildGo121Module, nixosTests }:

buildGo121Module rec {
  pname = "netdata-go-plugins";
  version = "0.57.2";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    hash = "sha256-Qtk1/sQxWAGPHid6tPlwylyHvhxwWTJMT8TwCd/gazk=";
  };

  vendorHash = "sha256-SFXf99cSA8sncAzZqj2eiiJFhyD4TXQipGAeM2Hivak=";

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
