{ stdenv, lib, goPackages, fetchFromGitHub, protobuf, vim }:

goPackages.buildGoPackage rec {
  name = "prometheus-alertmanager-${rev}";
  rev = "0.0.4";
  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    inherit rev;
    sha256 = "0g656rzal7m284mihqdrw23vhs7yr65ax19nvi70jl51wdallv15";
  };

  buildInputs = [
    goPackages.protobuf
    goPackages.fsnotify.v0
    goPackages.httprouter
    goPackages.prometheus.client_golang
    goPackages.prometheus.log
    goPackages.pushover
    protobuf
    vim
  ];

  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion ${rev}
        -X main.buildBranch master
        -X main.buildUser nix@nixpkgs
        -X main.buildDate 20150101-00:00:00
        -X main.goVersion ${lib.getVersion goPackages.go}
  '';

  preBuild = ''
  (
    cd "go/src/$goPackagePath"
    protoc --proto_path=./config \
           --go_out=./config/generated/ \
           ./config/config.proto
    cd web
    ${stdenv.shell} blob/embed-static.sh static templates \
      | gofmt > blob/files.go
  )
  '';

  meta = with lib; {
    description = "Alerting dispather for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
