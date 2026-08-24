{
  lib,
  fetchFromGitHub,
  buildGoModule,
  libpcap,
}:

let
  beat =
    package: extraArgs:
    buildGoModule (
      finalAttrs:
      {
        pname = package;
        version = "8.19.25";

        __structuredAttrs = true;

        src = fetchFromGitHub {
          owner = "elastic";
          repo = "beats";
          tag = "v${finalAttrs.version}";
          hash = "sha256-2wpagQ5/jbalZgsflf2gxsBNv3YOff04vx5eNboJC3Q=";
        };

        vendorHash = "sha256-G4MmTHKUq87UkZQaFZviMixIsb0hKQignwqxhzMsUGQ=";

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
  auditbeat8 = beat "auditbeat" {
    meta.description = "Lightweight shipper for audit data";
  };
  heartbeat8 = beat "heartbeat" {
    meta.description = "Lightweight shipper for uptime monitoring";
  };
  metricbeat8 = beat "metricbeat" {
    meta.description = "Lightweight shipper for metrics";
  };
  packetbeat8 = beat "packetbeat" {
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
