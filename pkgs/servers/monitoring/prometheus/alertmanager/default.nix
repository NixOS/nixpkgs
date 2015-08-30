{ lib, goPackages, fetchFromGitHub }:

let self = goPackages.buildGoPackage rec {
  name = "prometheus-alertmanager-${rev}";
  rev = "0.0.4";
  goPackagePath = "github.com/prometheus/alertmanager";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    inherit rev;
    sha256 = "0g656rzal7m284mihqdrw23vhs7yr65ax19nvi70jl51wdallv15";
  };

  buildInputs = with goPackages; [
    fsnotify.v0
    httprouter
    prometheus.client_golang
    prometheus.log
    pushover
  ];

  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion=${rev}
        -X main.buildBranch=master
        -X main.buildUser=nix@nixpkgs
        -X main.buildDate=20150101-00:00:00
        -X main.goVersion=${lib.getVersion goPackages.go}
  '';

  meta = with lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/alertmanager;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
};

in self.bin
