{ lib, fetchFromGitHub, elk6Version, buildGoPackage, libpcap, nixosTests, systemd }:

let beat = package : extraArgs : buildGoPackage (rec {
      name = "${package}-${version}";
      version = elk6Version;

      src = fetchFromGitHub {
        owner = "elastic";
        repo = "beats";
        rev = "v${version}";
        sha256 = "0jkiz5dfdi9zsji04ipcmcj7pml9294v455y7s2c22k24gyzbaw8";
      };

      goPackagePath = "github.com/elastic/beats";

      subPackages = [ package ];

      meta = with lib; {
        homepage = "https://www.elastic.co/products/beats";
        license = licenses.asl20;
        maintainers = with maintainers; [ fadenb basvandijk ];
        platforms = platforms.linux;
      };
    } // extraArgs);
in rec {
  filebeat6   = beat "filebeat"   {meta.description = "Lightweight shipper for logfiles";};
  heartbeat6  = beat "heartbeat"  {meta.description = "Lightweight shipper for uptime monitoring";};
  metricbeat6 = beat "metricbeat" {
    meta.description = "Lightweight shipper for metrics";
    passthru.tests =
      assert metricbeat6.drvPath == nixosTests.elk.ELK-6.elkPackages.metricbeat.drvPath;
      {
        elk = nixosTests.elk.ELK-6;
      };
  };
  packetbeat6 = beat "packetbeat" {
    buildInputs = [ libpcap ];
    meta.broken = true;
    meta.description = "Network packet analyzer that ships data to Elasticsearch";
    meta.longDescription = ''
      Packetbeat is an open source network packet analyzer that ships the
      data to Elasticsearch.

      Think of it like a distributed real-time Wireshark with a lot more
      analytics features. The Packetbeat shippers sniff the traffic between
      your application processes, parse on the fly protocols like HTTP, MySQL,
      PostgreSQL, Redis or Thrift and correlate the messages into transactions.
    '';
  };
  journalbeat6  = beat "journalbeat" {
    meta.description = ''
      Journalbeat is an open source data collector to read and forward
      journal entries from Linuxes with systemd.
    '';
    buildInputs = [ systemd.dev ];
    postFixup = let libPath = lib.makeLibraryPath [ (lib.getLib systemd) ]; in ''
      patchelf --set-rpath ${libPath} "$out/bin/journalbeat"
    '';
  };
}
