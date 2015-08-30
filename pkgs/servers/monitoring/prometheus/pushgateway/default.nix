{ lib, goPackages, fetchFromGitHub }:

with goPackages;

let self = buildGoPackage rec {
  name = "prometheus-pushgateway-${rev}";
  rev = "0.1.1";
  goPackagePath = "github.com/prometheus/pushgateway";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "pushgateway";
    sha256 = "17q5z9msip46wh3vxcsq9lvvhbxg75akjjcr2b29zrky8bp2m230";
  };

  buildInputs = [
    protobuf
    httprouter
    golang_protobuf_extensions
    prometheus.client_golang
  ];

  nativeBuildInputs = [
    go-bindata.bin
  ];

  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion=${rev}
        -X main.buildRev=${rev}
        -X main.buildBranch=master
        -X main.buildUser=nix@nixpkgs
        -X main.buildDate=20150101-00:00:00
        -X main.goVersion=${lib.getVersion go}
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
};

in self.bin
