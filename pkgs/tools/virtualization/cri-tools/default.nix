{ buildGoPackage, fetchurl, lib }:

buildGoPackage
  { name = "cri-tools-1.0.0-alpha.0";
    src = fetchurl
      { url = "https://github.com/kubernetes-incubator/cri-tools/archive/v1.0.0-alpha.0.tar.gz";
        sha256 = "1la26f38xafb7g9hrppjq7gmajiyr8idcwbian7n412q9m0lb3ic";
      };

    goPackagePath = "github.com/kubernetes-incubator/cri-tools";
    subPackages = [ "cmd/crictl" "cmd/critest" ];

    meta = {
      license = lib.licenses.asl20;
    };

    goDeps = ./deps.nix;
  }

