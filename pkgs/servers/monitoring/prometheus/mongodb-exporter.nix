{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mongodb_exporter";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "mongodb_exporter";
    rev = "v${version}";
    hash = "sha256-FwY4rAmv7P55EGfEHrs0y15BvU3qnq0VHf37R7W2yA4=";
  };

  vendorHash = "sha256-jF6Of16mMpsCrkvtI3xZcla4/MJGpCX5YVkGM6eFfmo=";

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
