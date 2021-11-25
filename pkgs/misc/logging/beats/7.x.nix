{ lib, fetchFromGitHub, elk7Version, buildGoModule, libpcap, nixosTests, systemd }:

let beat = package: extraArgs: buildGoModule (rec {
  pname = package;
  version = elk7Version;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "beats";
    rev = "v${version}";
    sha256 = "0gjyzprgj9nskvlkm2bf125b7qn3608llz4kh1fyzsvrw6zb7sm8";
  };

  vendorSha256 = "04cwf96fh60ld3ndjzzssgirc9ssb53yq71j6ksx36m3y1x7fq9c";

  subPackages = [ package ];

  meta = with lib; {
    homepage = "https://www.elastic.co/products/beats";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb basvandijk ];
    platforms = platforms.linux;
  };
} // extraArgs);
in
rec {
  filebeat7 = beat "filebeat" { meta.description = "Lightweight shipper for logfiles"; };
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
  journalbeat7 = beat "journalbeat" {
    meta.description = ''
      Journalbeat is an open source data collector to read and forward
      journal entries from Linuxes with systemd.
    '';
    buildInputs = [ systemd.dev ];
    postFixup = let libPath = lib.makeLibraryPath [ (lib.getLib systemd) ]; in
      ''
        patchelf --set-rpath ${libPath} "$out/bin/journalbeat"
      '';
  };
}
