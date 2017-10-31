{ stdenv, go, buildGoPackage, go-bindata, fetchFromGitHub }:

buildGoPackage rec {
  name = "pushgateway-${version}";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/pushgateway";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "pushgateway";
    sha256 = "19hsv42addcx4dsjdbh64y7ggjvaaay9gag0342gz7gyl9sr719f";
  };

  buildInputs = [ go-bindata ];

  preBuild = ''
  (
    cd "go/src/$goPackagePath"
    go-bindata ./resources/
  )
  '';

  buildFlagsArray = ''
    -ldflags=
        -X main.buildVersion=${version}
        -X main.buildRev=${rev}
        -X main.buildBranch=${rev}
        -X main.buildUser=nix@nixpkgs
        -X main.buildDate=19700101-00:00:00
        -X main.goVersion=${stdenv.lib.getVersion go}
  '';

  meta = with stdenv.lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    homepage = https://github.com/prometheus/pushgateway;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
