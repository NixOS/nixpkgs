{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-rHSILxd0Zl8+3CzaR4c1PBKDjI8P7Tp5A11eTXUdTH0=";
  };

  vendorHash = "sha256-CUD6tTcWxLY/oGlRWSWjDcRQw0ecZYcUtGdav/UbctU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.Branch=unknown"
    "-X main.buildDate=unknown"
  ];

  subPackages = [ "." ];

  # those check depends on docker;
  # nixpkgs doesn't have mongodb application available;
  doCheck = false;

  meta = with lib; {
    description = "Prometheus exporter for MongoDB including sharding, replication and storage engines";
    homepage = "https://github.com/percona/mongodb_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ undefined-moe ];
    mainProgram = "mongodb_exporter";
  };
}
