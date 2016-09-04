{ stdenv, lib, go, buildGoPackage, go-bindata, fetchFromGitHub }:

buildGoPackage rec {
  name = "pushgateway-${version}";
  version = "0.3.0";
  rev = version;

  goPackagePath = "github.com/prometheus/pushgateway";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "pushgateway";
    sha256 = "1bj0s4s3gbcnlp2z2yx7jf3jx14cdg2v4pr0yciai0g6jwwg63hd";
  };

  goDeps = ./pushgateway_deps.json;

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
        -X main.buildBranch=master
        -X main.buildUser=nix@nixpkgs
        -X main.buildDate=20150101-00:00:00
        -X main.goVersion=${stdenv.lib.getVersion go}
  '';

  meta = with stdenv.lib; {
    description = "Allows ephemeral and batch jobs to expose metrics to Prometheus";
    homepage = https://github.com/prometheus/pushgateway;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
