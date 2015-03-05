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
    args    = [ ./trivialBootstrap.sh ];

    mkdir   = "/bin/mkdir";
    ln      = "/bin/ln";
  };

  # The simplest stdenv possible to run fetchadc and get the Apple command-line tools
  stage0 = rec {
    fetchurl = import ../../build-support/fetchurl {
      inherit stdenv;
      curl = bootstrapTools;
    };

    stdenv = import ../generic {
      inherit system config;
      name         = "stdenv-darwin-boot-0";
      shell        = "/bin/bash";
      initialPath  = [ bootstrapTools ];
      fetchurlBoot = fetchurl;
      cc           = "/no-such-path";
    };
  };

  buildTools = import ../../os-specific/darwin/command-line-tools {
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
    export MACOSX_DEPLOYMENT_TARGET=10.7
    export SDKROOT=$(/usr/bin/xcrun --sdk macosx$(/usr/bin/xcrun --show-sdk-version) --show-sdk-path 2> /dev/null || echo /)
    export NIX_CFLAGS_COMPILE+=" --sysroot=/var/empty -idirafter $SDKROOT/usr/include -F$SDKROOT/System/Library/Frameworks -Wno-multichar -Wno-deprecated-declarations"
    export NIX_LDFLAGS_AFTER+=" -L$SDKROOT/usr/lib"
    export CMAKE_OSX_ARCHITECTURES=x86_64
  '';

  # A stdenv that wraps the Apple command-line tools and our other trivial symlinked bootstrap tools
  stage1 = rec {
    nativePrefix = "${buildTools.tools}/Library/Developer/CommandLineTools/usr";

    stdenv = import ../generic {
      name = "stdenv-darwin-boot-1";

      inherit system config;
      inherit (stage0.stdenv) shell initialPath fetchurlBoot;

      preHook = preHook + "\n" + ''
        export NIX_LDFLAGS_AFTER+=" -L/usr/lib"
        export NIX_ENFORCE_PURITY=
        export NIX_CFLAGS_COMPILE+=" -isystem ${nativePrefix}/include/c++/v1 -stdlib=libc++"
        export NIX_CFLAGS_LINK+=" -stdlib=libc++ -Wl,-rpath,${nativePrefix}/lib"
      '';

      cc = import ../../build-support/cc-wrapper {
        nativeTools  = true;
        nativePrefix = nativePrefix;
        nativeLibc   = true;
        stdenv       = stage0.stdenv;
        shell        = "/bin/bash";
        cc           = {
          name    = "clang-9.9.9";
          cc      = "/usr";
          outPath = "${buildTools.tools}/Library/Developer/CommandLineTools/usr";
        };
      };
    };
    pkgs = allPackages {
      inherit system platform;
      bootStdenv = stdenv;
    };
  };

  stage2 = rec {
    stdenv = import ../generic {
      name = "stdenv-darwin-boot-2";

      inherit system config;
      inherit (stage1.stdenv) shell fetchurlBoot preHook cc;

      initialPath = [ stage1.pkgs.xz ] ++ stage1.stdenv.initialPath;
    };
    pkgs = allPackages {
      inherit system platform;
      bootStdenv = stdenv;
    };
  };

  # Use stage1 to build a whole set of actual tools so we don't have to rely on the Apple prebuilt ones or
  # the ugly symlinked bootstrap tools anymore.
  stage3 = with stage2; import ../generic {
    name = "stdenv-darwin-boot-3";

    inherit system config;
    inherit (stdenv) fetchurlBoot;

    initialPath = (import ../common-path.nix) { inherit pkgs; };

    preHook = preHook + "\n" + ''
      export NIX_ENFORCE_PURITY=1
    '';

    cc = import ../../build-support/cc-wrapper {
      inherit stdenv;
      nativeTools  = false;
      nativeLibc   = true;
      binutils  = pkgs.darwin.cctools;
      cc        = pkgs.llvmPackages.clang;
      coreutils = pkgs.coreutils;
      shell     = "${pkgs.bash}/bin/bash";
      extraPackages = [ pkgs.libcxx ];
    };

    shell = "${pkgs.bash}/bin/bash";
  };

  stdenvDarwin = stage3;
}
