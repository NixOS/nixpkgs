{ stdenv, fetchFromGitHub, elk5Version, buildGoPackage, libpcap }:

let beat = package : extraArgs : buildGoPackage (rec {
      name = "${package}-${version}";
      version = elk5Version;

      src = fetchFromGitHub {
        owner = "elastic";
        repo = "beats";
        rev = "v${version}";
        sha256 = "03pvzikl5wa6agf3aszx96xvd6yjbvdf0kdwjsr4vfga0h797s32";
      };

      goPackagePath = "github.com/elastic/beats";

      subPackages = [ package ];

      meta = with stdenv.lib; {
        homepage = https://www.elastic.co/products/beats;
        license = licenses.asl20;
        maintainers = with maintainers; [ fadenb basvandijk ];
        platforms = platforms.linux;
      };
    } // extraArgs);
in {
  filebeat   = beat "filebeat"   {meta.description = "Lightweight shipper for logfiles";};
  heartbeat  = beat "heartbeat"  {meta.description = "Lightweight shipper for uptime monitoring";};
  metricbeat = beat "metricbeat" {meta.description = "Lightweight shipper for metrics";};
  packetbeat = beat "packetbeat" {
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
}
