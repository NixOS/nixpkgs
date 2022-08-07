{ lib, fetchFromGitHub, elk7Version, buildGoModule, libpcap, nixosTests, systemd }:

let beat = package: extraArgs: buildGoModule (rec {
  pname = package;
  version = elk7Version;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    rev = "v${version}";
    sha256 = "sha256-DE7XpzVBu9qL7fMXXYRYLdVXrr0WB0IL0KAG0Zc3TVo=";
  };

  vendorSha256 = "sha256-TQrXUcLv7rFo3PP3bVx0wEC1WbtkJDsCm+/izHAxqBc=";

  subPackages = [ package ];

  meta = with lib; {
    homepage = "https://www.elastic.co/products/beats";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb basvandijk dfithian ];
    platforms = platforms.linux;
  };
} // extraArgs);
in
rec {
  filebeat7 = beat "filebeat" {
    meta.description = "Lightweight shipper for logfiles";
    buildInputs = [ systemd ];
    tags = [ "withjournald" ];
    postFixup = ''
      patchelf --set-rpath ${lib.makeLibraryPath [ (lib.getLib systemd) ]} "$out/bin/filebeat"
    '';
  };
  heartbeat7 = beat "heartbeat" { meta.description = "Lightweight shipper for uptime monitoring"; };
  metricbeat7 = beat "metricbeat" {
    meta.description = "Lightweight shipper for metrics";
    passthru.tests =
      assert metricbeat7.drvPath == nixosTests.elk.ELK-7.elkPackages.metricbeat.drvPath;
      {
        elk = nixosTests.elk.ELK-7;
      };
  };
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
}
