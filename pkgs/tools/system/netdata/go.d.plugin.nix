{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "netdata-go-plugins";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    hash = "sha256-FHcETEAQArzNyvlzEaOYzwtXk6jPA2b6Kp8pI7FeTo8=";
  };

  vendorHash = "sha256-8JpeP2p09j45dkuQMtBj1j0C5CjNMshofHFVnvZvNQY=";

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
    maintainers = [ ];
  };
}
