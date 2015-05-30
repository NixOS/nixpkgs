{ stdenv, lib, goPackages, fetchFromGitHub, vim }:

goPackages.buildGoPackage rec {
  name = "prometheus-${version}";
  version = "0.14.0rc3";
  goPackagePath = "github.com/prometheus/prometheus";
  rev = "d7b471f3cc3147f8f0a94f60ab6e4394bdf1d373";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "1vvy4v95khzzr3qivbb4yzvxs3jb42gb6garwy68fqp0f8kbxlgi";
  };

  buildInputs = [
    goPackages.consul
    goPackages.dns
    goPackages.fsnotify.v1
    goPackages.goleveldb
    goPackages.logrus
    goPackages.net
    goPackages.prometheus.client_golang
    goPackages.prometheus.log
    goPackages.yaml-v2
    vim  # for xxd, used in embed-static.sh
  ];

  # Metadata that gets embedded into the binary
  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion ${version}
        -X main.buildRevision ${builtins.substring 0 6 rev}
        -X main.buildBranch master
        -X main.buildUser nix@nixpkgs
        -X main.buildDate 20150101-00:00:00
        -X main.goVersion ${lib.getVersion goPackages.go}
  '';

  preBuild = ''
  (
    cd "go/src/$goPackagePath/web"
    ${stdenv.shell} ../utility/embed-static.sh static templates \
      | gofmt > blob/files.go
  )
  '';

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = http://prometheus.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
