{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "netdata-go-plugins";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    hash = "sha256-/FlwXSnag4FEUfHqCSj/CCmq2fJ/Sx/1Pc4e/tNQMUo=";
  };

  vendorHash = "sha256-czprCI8/qKMvhuB31ZqvqfmVgeZgMYIRBoSiLL0YoOY=";

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
