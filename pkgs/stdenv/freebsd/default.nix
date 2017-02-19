{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;
let inherit (localSystem) system; in


[

  ({}: {
    __raw = true;

    bootstrapTools = derivation {
      inherit system;

      name = "trivial-bootstrap-tools";
      builder = "/usr/local/bin/bash";
      args = [ ./trivial-bootstrap.sh ];

      mkdir = "/bin/mkdir";
      ln = "/bin/ln";
    };
  })

  ({ bootstrapTools, ... }: rec {
    __raw = true;

    inherit bootstrapTools;

    fetchurl = import ../../build-support/fetchurl {
      inherit stdenv;
      curl = bootstrapTools;
    };

    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-1";
      inherit system config;
      initialPath = [ "/" "/usr" ];
      shell = "${bootstrapTools}/bin/bash";
      fetchurlBoot = null;
      cc = null;
      overrides = self: super: {
      };
    };
  })

  (prevStage: {
    __raw = true;

    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-0";
      inherit system config;
      initialPath = [ prevStage.bootstrapTools ];
      inherit (prevStage.stdenv) shell;
      fetchurlBoot = prevStage.fetchurl;
      cc = null;
    };
  })

  (prevStage: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = localSystem;
    inherit config overlays;
    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-3";
      inherit system config;

      inherit (prevStage.stdenv)
        initialPath shell fetchurlBoot;

      cc = import ../../build-support/cc-wrapper {
        nativeTools  = true;
        nativePrefix = "/usr";
        nativeLibc   = true;
        inherit (prevStage) stdenv;
        cc           = {
          name    = "clang-9.9.9";
          cc      = "/usr";
          outPath = "/usr";
        };
        isClang      = true;
      };

      preHook = ''export NIX_NO_SELF_RPATH=1'';
    };
  })

]
