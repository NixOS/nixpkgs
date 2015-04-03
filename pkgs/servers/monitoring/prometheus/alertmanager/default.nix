{ stdenv, lib, goPackages, fetchFromGitHub, protobuf, vim }:

with goPackages;

buildGoPackage rec {
  name = "prometheus-alertmanager-${version}";
  version = "0.1.0";
  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    rev = "942cd35dea6dc406b106d7a57ffe7adbb3b978a5";
    sha256 = "1c14vgn9s0dn322ss8fs5b47blw1g8cxy9w4yjn0f7x2sdwplx1i";
  };

  buildInputs = [
    goPackages.glog
    goPackages.protobuf
    goPackages.fsnotify
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
        -X main.goVersion ${lib.getVersion go}
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
