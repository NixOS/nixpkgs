{ stdenv, lib, go, fetchgit }:

stdenv.mkDerivation rec {
  version = "4556edb";
  name = "influxdb-backup-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o influxdb-dump github.com/eckardt/influxdb-backup/influxdb-dump
    go build -v -o influxdb-restore github.com/eckardt/influxdb-backup/influxdb-restore
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv influxdb-dump $out/bin
    mv influxdb-restore $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Backup and Restore for InfluxDB";
    homepage = https://github.com/eckardt/influxdb-backup;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
