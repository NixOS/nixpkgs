{
  lib,
  fetchFromGitHub,
  buildGoModule,
  libpcap,
  nixosTests,
  systemd,
}:

let
  beat =
    package: extraArgs:
    buildGoModule (
      finalAttrs:
      {
        pname = package;
        version = "9.4.0";

        __structuredAttrs = true;

        src = fetchFromGitHub {
          owner = "elastic";
          repo = "beats";
          tag = "v${finalAttrs.version}";
          hash = "sha256-LsIxM141blDowUwN6THmu/uZ+vlpgqWb26HnnPeQXCM=";
        };

        vendorHash = "sha256-alLKZFW+eFaU2jOMU97oL+GKr2puM/gzgzQ73eGYiFM=";

        subPackages = [ package ];

        meta = {
          homepage = "https://www.elastic.co/products/beats";
          license =
            with lib.licenses;
            OR [
              agpl3Only
              elastic20
              sspl
            ];
          maintainers = with lib.maintainers; [
            basvandijk
            dfithian
          ];
          platforms = lib.platforms.linux;
        }
        // (extraArgs.meta or { });
      }
      // removeAttrs extraArgs [
        "meta"
      ]
    );
in
{
  auditbeat9 = beat "auditbeat" {
    meta.description = "Lightweight shipper for audit data";
  };
  filebeat9 = beat "filebeat" {
    meta.description = "Lightweight shipper for logfiles";
    buildInputs = [ systemd ];
    tags = [ "withjournald" ];
    postFixup = ''
      patchelf --set-rpath ${lib.makeLibraryPath [ (lib.getLib systemd) ]} "$out/bin/filebeat"
    '';
  };
  heartbeat9 = beat "heartbeat" {
    meta.description = "Lightweight shipper for uptime monitoring";
  };
  metricbeat9 = beat "metricbeat" {
    meta.description = "Lightweight shipper for metrics";
    passthru = {
      tests = {
        elk = nixosTests.elk.ELK-9;
      };
    };
  };
  packetbeat9 = beat "packetbeat" {
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
