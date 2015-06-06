{ stdenv, lib, goPackages, fetchFromGitHub, vim }:

goPackages.buildGoPackage rec {
  name = "prometheus-${version}";
  version = "0.14.0";
  goPackagePath = "github.com/prometheus/prometheus";
  rev = "67e77411ba30b1b0ce0989c85b6684fb3adef430";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "06xsxigimw5i1fla0k83pf5bpmybskvy50433hs8h876gyvgjxp9";
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
