{ stdenv, lib, goPackages, fetchFromGitHub, protobuf, vim }:

goPackages.buildGoPackage rec {
  name = "prometheus-alertmanager-${version}";
  version = "0.0.1";
  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    rev = "2b6c5caf89a492b013204e8d7db99fbb78c5dcd4";
    sha256 = "13rdqnvmx11ks305dlnzv9gwf8c4zjyi5fkwcd69xgjfars2m4f3";
  };

  buildInputs = [
    goPackages.glog
    goPackages.protobuf
    goPackages.fsnotify.v0
    goPackages.httprouter
    goPackages.prometheus.client_golang
    goPackages.pushover
    protobuf
    vim
  ];

  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion ${version}
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
