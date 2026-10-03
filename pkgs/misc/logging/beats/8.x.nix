{
  lib,
  fetchFromGitHub,
  buildGoModule,
  libpcap,
  nixosTests,
}:

let
  beat =
    package: extraArgs:
    buildGoModule (
      finalAttrs:
      {
        pname = package;
        version = "8.19.16";

        __structuredAttrs = true;

        src = fetchFromGitHub {
          owner = "elastic";
          repo = "beats";
          tag = "v${finalAttrs.version}";
          hash = "sha256-OBPaSbPAp7SvhEi2yycgT70yRfCtIEdkL4/GSR2YrO4=";
        };

        vendorHash = "sha256-sHR/CxY46bjCU8xhDJ9uDMnYrX3Kc91y2Poyq4cqncw=";

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
# Note: `filebeat8` lives at `pkgs/by-name/fi/filebeat8/package.nix`, not here.
# It diverges from the shared `beat` helper in ways that don't fit cleanly
# through `extraArgs`: it needs `proxyVendor` (distinct `vendorHash`),
# libsystemd linkage for the `withjournald` build tag (`buildInputs` +
# `postFixup` `patchelf`), `versionCheckHook`, and a different license.
# by-name's uniqueness rule prevents re-exporting it through this file as well.
{
  auditbeat8 = beat "auditbeat" {
    meta.description = "Lightweight shipper for audit data";
  };
  heartbeat8 = beat "heartbeat" {
    meta.description = "Lightweight shipper for uptime monitoring";
  };
  metricbeat8 = beat "metricbeat" {
    meta.description = "Lightweight shipper for metrics";
    passthru = {
      tests = {
        elk = nixosTests.elk.ELK-8;
      };
    };
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
