{ stdenv, lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "prometheus-pushgateway-${version}";
  version = "0.1.0";
  goPackagePath = "github.com/prometheus/pushgateway";
  rev = "3f1d42dade342ddb88381607358bae61a0a6b6c7";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "pushgateway";
    sha256 = "1wqxbl9rlnxszp9ylvdbx6f5lyj2z0if3x099fnjahbqmz8yhnf4";
  };

  buildInputs = [
    go-bindata
    protobuf
    httprouter
    golang_protobuf_extensions
    prometheus.client_golang
  ];

  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion ${version}
        -X main.buildRev ${rev}
        -X main.buildBranch master
        -X main.buildUser nix@nixpkgs
        -X main.buildDate 20150101-00:00:00
        -X main.goVersion ${lib.getVersion go}
  '';

  preBuild = ''
  (
    cd "go/src/$goPackagePath"
    go-bindata ./resources/
  )
  '';

  meta = with lib; {
    description =
      "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    homepage = https://github.com/prometheus/pushgateway;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
