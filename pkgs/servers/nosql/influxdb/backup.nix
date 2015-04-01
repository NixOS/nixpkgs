{ lib, goPackages, fetchgit }:

with goPackages;

buildGoPackage rec {
  rev = "4556edbffa914a8c17fa1fa1564962a33c6c7596";
  name = "influxdb-backup-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/eckardt/influxdb-backup";
  src = fetchgit {
    inherit rev;
    url = https://github.com/eckardt/influxdb-backup.git;
    sha256 = "2928063e6dfe4be7b69c8e72e4d6a5fc557f0c75e9625fadf607d59b8e80e34b";
  };

  subPackages = [ "influxdb-dump" "influxdb-restore" ];

  buildInputs = [ eckardt.influxdb-go ];

  meta = with lib; {
    description = "Backup and Restore for InfluxDB";
    homepage = https://github.com/eckardt/influxdb-backup;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
