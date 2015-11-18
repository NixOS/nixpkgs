{ lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "influxdb-${rev}";
  rev = "v0.9.4";
  goPackagePath = "github.com/influxdb/influxdb";

  src = fetchFromGitHub {
    inherit rev;
    owner = "influxdb";
    repo = "influxdb";
    sha256 = "0yarymppnlpf2xab57i8jx595v47s5mdwnf13719mc1fv3q84yqn";
  };

  excludedPackages = "test";

  propagatedBuildInputs = with goPackages; [
    raft raft-boltdb snappy crypto gogo.protobuf pool pat toml
    gollectd statik liner
  ];

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = https://influxdb.com/;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
