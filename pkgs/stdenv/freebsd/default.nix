{ system      ? builtins.currentSystem
, allPackages ? import ../../top-level/all-packages.nix
, platform    ? null
, config      ? {}
}:

rec {
  allPackages = import ../../top-level/all-packages.nix;

  bootstrapTools = derivation {
    inherit system;

    name    = "trivial-bootstrap-tools";
    builder = "/bin/sh";
    args    = [ ./trivial-bootstrap.sh ];

    mkdir   = "/bin/mkdir";
    ln      = "/bin/ln";
  };

  stage0 = rec {
    fetchurl = import ../../build-support/fetchurl {
      inherit stdenv;
      curl = bootstrapTools;
    };

    stdenv = import ../generic {
      inherit system config;
      name         = "stdenv-freebsd-boot-0";
      shell        = "/usr/local/bin/bash";
      initialPath  = [ bootstrapTools ];
      fetchurlBoot = fetchurl;
      cc           = null;
    };
  };

  buildTools = { #import ../../os-specific/freebsd/command-line-tools
    inherit (stage0) stdenv fetchurl;
    xar  = bootstrapTools;
    gzip = bootstrapTools;
    cpio = bootstrapTools;
  };

  preHook = ''
    export NIX_IGNORE_LD_THROUGH_GCC=1
    export NIX_DONT_SET_RPATH=1
    export NIX_NO_SELF_RPATH=1
    dontFixLibtool=1
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
    xargsFlags=" "
  '';

  stage1 = rec {
    nativePrefix = "/usr";

    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-1";

      inherit system config;
      inherit (stage0.stdenv) shell fetchurlBoot;

      initialPath = stage0.stdenv.initialPath ++ [ nativePrefix ];

      preHook = preHook + "\n" + ''
        export NIX_LDFLAGS_AFTER+=" -L/usr/lib"
        export NIX_ENFORCE_PURITY=
        export NIX_CFLAGS_COMPILE+=" -isystem ${nativePrefix}/include/c++/v1"
        export NIX_CFLAGS_LINK+=" -Wl,-rpath,${nativePrefix}/lib"
      '';

      cc = import ../../build-support/cc-wrapper {
        nativeTools  = true;
        nativePrefix = nativePrefix;
        nativeLibc   = true;
        stdenv       = stage0.stdenv;
        shell        = "/usr/local/bin/bash";
        cc           = {
          name    = "clang-9.9.9";
          cc      = "/usr";
          outPath = nativePrefix;
        };
        isClang      = true;
      };
    };
    pkgs = allPackages {
      inherit system platform;
      bootStdenv = stdenv;
    };
  };

  stage2 = rec {
    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-2";

      inherit system config;
      inherit (stage1.stdenv) shell fetchurlBoot preHook cc;

      initialPath = [ "/usr/local/bin" ] ++ stage1.stdenv.initialPath;
    };
    pkgs = allPackages {
      inherit system platform;
      bootStdenv = stdenv;
    };
  };

  stage3 = with stage2; import ../generic {
    name = "stdenv-freebsd-boot-3";

    inherit system config;
    inherit (stdenv) fetchurlBoot;

    initialPath = [ bootstrapTools ];

    preHook = preHook + "\n" + ''
      export NIX_ENFORCE_PURITY=1
    '';

    cc = import ../../build-support/cc-wrapper {
      inherit stdenv;
      nativeTools   = true;
      nativePrefix  = "/usr/local/bin";
      nativeLibc    = true;
      cc            = stage2.stdenv.cc; #pkgs.llvmPackages.clang-unwrapped; 
      isClang       = true;
    };

    shell = "/usr/local/bin/bash";
  };

  stdenvFreeBSD = stage3;
}
