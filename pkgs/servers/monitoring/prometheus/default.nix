{ stdenv, lib, goPackages, fetchFromGitHub, vim }:

goPackages.buildGoPackage rec {
  name = "prometheus-${version}";
  version = "0.15.1";
  goPackagePath = "github.com/prometheus/prometheus";
  rev = "64349aade284846cb194be184b1b180fca629a7c";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "0gljpwnlip1fnmhbc96hji2rc56xncy97qccm7v1z5j1nhc5fam2";
  };

  buildInputs = with goPackages; [
    consul
    dns
    fsnotify.v1
    go-zookeeper
    goleveldb
    httprouter
    logrus
    net
    prometheus.client_golang
    prometheus.log
    yaml-v2
  ];

  # Metadata that gets embedded into the binary
  buildFlagsArray = let t = "${goPackagePath}/version"; in
  ''
    -ldflags=
        -X ${t}.Version=${version}
        -X ${t}.Revision=${builtins.substring 0 6 rev}
        -X ${t}.Branch=master
        -X ${t}.BuildUser=nix@nixpkgs
        -X ${t}.BuildDate=20150101-00:00:00
        -X ${t}.GoVersion=${lib.getVersion goPackages.go}
  '';

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = http://prometheus.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
