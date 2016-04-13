{ system      ? builtins.currentSystem
, allPackages ? import ../../..
, platform    ? null
, config      ? {}
}:

rec {
  allPackages = import ../../..;

  bootstrapTools = derivation {
    inherit system;

    name    = "trivial-bootstrap-tools";
    builder = "/usr/local/bin/bash";
    args    = [ ./trivial-bootstrap.sh ];

    mkdir   = "/bin/mkdir";
    ln      = "/bin/ln";
  };

  fetchurl = import ../../build-support/fetchurl {
    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-1";
      inherit system config;

      initialPath  = [ "/" "/usr" ];
      shell        = "${bootstrapTools}/bin/bash";
      fetchurlBoot = null;
      cc = null;
    };
    curl = bootstrapTools;
  };

  stdenvFreeBSD = import ../generic {
    name = "stdenv-freebsd-boot-3";

    inherit system config;

    initialPath  = [ bootstrapTools ];
    shell        = "${bootstrapTools}/bin/bash";
    fetchurlBoot = fetchurl;

    cc = import ../../build-support/cc-wrapper {
      nativeTools  = true;
      nativePrefix = "/usr";
      nativeLibc   = true;
      stdenv = import ../generic {
        inherit system config;
        name         = "stdenv-freebsd-boot-0";
        initialPath  = [ bootstrapTools ];
        shell = stdenvFreeBSD.shell;
        fetchurlBoot = fetchurl;
        cc           = null;
      };
      cc           = {
        name    = "clang-9.9.9";
        cc      = "/usr";
        outPath = "/usr";
      };
      isClang      = true;
    };

    preHook = ''export NIX_NO_SELF_RPATH=1'';
  };
}
