{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-QII93sd/Lh+m6S5HtDsOt2BUnqg+X8I24KoU+MAWWQU=";
  };

  vendorHash = "sha256-khNkh2LufCE3KdPYRCALz66X+Q1U+sTIILh4uDzhKiI=";

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

  meta = with lib;
    {
      description = "A Prometheus exporter for MongoDB including sharding, replication and storage engines";
      homepage = "https://github.com/percona/mongodb_exporter";
      license = licenses.asl20;
      maintainers = with maintainers; [ undefined-moe ];
      mainProgram = "mongodb_exporter";
    };
}
