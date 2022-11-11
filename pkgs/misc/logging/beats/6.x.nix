{ lib, fetchFromGitHub, fetchpatch, elk6Version, buildGoPackage, libpcap, nixosTests, systemd }:

let beat = package : extraArgs : buildGoPackage (rec {
      name = "${package}-${version}";
      version = elk6Version;

      src = fetchFromGitHub {
        owner = "elastic";
        repo = "beats";
        rev = "v${version}";
        sha256 = "1vnw9clsc10cfpjf6vxvc6m507b2q17sgsl079iwqbp4v0286il7";
      };

      goPackagePath = "github.com/elastic/beats";

      subPackages = [ package ];

      patches = [
        (fetchpatch {
          # Build fix for aarch64, possibly other systems, merged in beats 7.x https://github.com/elastic/beats/pull/9493
          url = "https://github.com/elastic/beats/commit/5d796571de1aa2a299393d2045dacc2efac41a04.diff";
          sha256 = "sha256:0b79fljbi5xd3h8iiv1m38ad0zhmj09f187asc0m9rxlqrz2l9r2";
        })
      ];

      meta = with lib; {
        homepage = "https://www.elastic.co/products/beats";
        license = licenses.asl20;
        maintainers = with maintainers; [ fadenb basvandijk dfithian ];
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
