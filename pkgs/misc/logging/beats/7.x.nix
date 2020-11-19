{ stdenv, lib, fetchFromGitHub, elk7Version, buildGoPackage, libpcap, systemd }:

let beat = package : extraArgs : buildGoPackage (rec {
      name = "${package}-${version}";
      version = elk7Version;

      src = fetchFromGitHub {
        owner = "elastic";
        repo = "beats";
        rev = "v${version}";
        sha256 = "192ygz3ppfah8d2b811x67jfqhcr5ivz7qh4vwrd729rjfr0bbgb";
      };

      goPackagePath = "github.com/elastic/beats";

      subPackages = [ package ];

      meta = with stdenv.lib; {
        homepage = "https://www.elastic.co/products/beats";
        license = licenses.asl20;
        maintainers = with maintainers; [ fadenb basvandijk ];
        platforms = platforms.linux;
      };
    } // extraArgs);
in {
  filebeat7   = beat "filebeat"   {meta.description = "Lightweight shipper for logfiles";};
  heartbeat7  = beat "heartbeat"  {meta.description = "Lightweight shipper for uptime monitoring";};
  metricbeat7 = beat "metricbeat" {meta.description = "Lightweight shipper for metrics";};
  packetbeat7 = beat "packetbeat" {
    buildInputs = [ libpcap ];
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
  journalbeat7  = beat "journalbeat" {
    meta.description = ''
      Journalbeat is an open source data collector to read and forward
      journal entries from Linuxes with systemd.
    '';
    buildInputs = [ systemd.dev ];
    postFixup = let libPath = stdenv.lib.makeLibraryPath [ (lib.getLib systemd) ]; in ''
      patchelf --set-rpath ${libPath} "$out/bin/journalbeat"
    '';
  };
}
