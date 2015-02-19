{ system      ? builtins.currentSystem
, allPackages ? import ../../top-level/all-packages.nix
, platform    ? null
, config      ? {}
}:

let
  fetch = { file, sha256 }: import <nix/fetchurl.nix> {
    url = "https://dl.dropboxusercontent.com/u/361503/${file}";
    inherit sha256;
    executable = true;
  };

  bootstrapFiles = {
    sh    = fetch { file = "sh";    sha256 = "1amnaql1rc6fdsxyav7hmhj8ylf4ccmgsl7v23x4sgw94pkipz78"; };
    bzip2 = fetch { file = "bzip2"; sha256 = "1f4npmrhx37jnv90by8b39727cam3n811lvglsc6da9xm80g2f5l"; };
    mkdir = fetch { file = "mkdir"; sha256 = "0x9jqf4rmkykbpkybp40x4d0v0dq99i0r5yk8096mjn1m7s7xa0p"; };
    cpio  = fetch { file = "cpio";  sha256 = "1a5s8bs14jhhmgrf4cwn92iq8sbz40qhjzj7y35ri84prp9clkc3"; };
  };
  tarball = fetch { file = "bootstrap-tools.9.cpio.bz2"; sha256 = "1qfcdavsmfvai6izg5fl0d3j9r61h2hnkmnr8gzqzjjrl71zyhky"; };
in rec {
  allPackages = import ../../top-level/all-packages.nix;

  commonPreHook = ''
    export NIX_ENFORCE_PURITY=1
    export NIX_IGNORE_LD_THROUGH_GCC=1
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
    export MACOSX_DEPLOYMENT_TARGET=10.7
    export SDKROOT=
    export CMAKE_OSX_ARCHITECTURES=x86_64
  '';

  # libSystem and its transitive dependencies. Get used to this; it's a recurring theme in darwin land
  libSystemClosure = [
    "/usr/lib/libSystem.dylib"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/libobjc.A.dylib"
    "/usr/lib/libobjc.dylib"
    "/usr/lib/libauto.dylib"
    "/usr/lib/libc++abi.dylib"
    "/usr/lib/libc++.1.dylib"
    "/usr/lib/libDiagnosticMessagesClient.dylib"
    "/usr/lib/system"
  ];

  # The one dependency of /bin/sh :(
  binShClosure = [ "/usr/lib/libncurses.5.4.dylib" ];

  bootstrapTools = derivation rec {
    inherit system tarball;

    name    = "bootstrap-tools";
    builder = bootstrapFiles.sh; # Not a filename! Attribute 'sh' on bootstrapFiles
    args    = [ ./unpack-bootstrap-tools.sh ];

    inherit (bootstrapFiles) mkdir bzip2 cpio;

    __impureHostDeps  = binShClosure ++ libSystemClosure;
  };

  stageFun = step: last: {shell             ? "${bootstrapTools}/bin/sh",
                          overrides         ? (pkgs: {}),
                          extraPreHook      ? "",
                          extraBuildInputs  ? with last.pkgs; [ xz darwin.CF libcxx ],
                          extraInitialPath  ? [],
                          allowedRequisites ? null}:
    let
      thisStdenv = import ../generic {
        inherit system config shell extraBuildInputs allowedRequisites;

        name = "stdenv-darwin-boot-${toString step}";

        cc = if isNull last then "/no-such-path" else import ../../build-support/cc-wrapper {
          inherit shell;
          inherit (last) stdenv;
          inherit (last.pkgs.darwin) dyld;

          nativeTools  = true;
          nativePrefix = bootstrapTools;
          nativeLibc   = false;
          libc         = last.pkgs.darwin.Libsystem;
          cc           = { name = "clang-9.9.9"; outPath = bootstrapTools; };
        };

        preHook = stage0.stdenv.lib.optionalString (shell == "${bootstrapTools}/bin/sh") ''
          # Don't patch #!/interpreter because it leads to retained
          # dependencies on the bootstrapTools in the final stdenv.
          dontPatchShebangs=1
        '' + ''
          ${commonPreHook}
          ${extraPreHook}
        '';
        initialPath  = extraInitialPath ++ [ bootstrapTools ];
        fetchurlBoot = import ../../build-support/fetchurl {
          stdenv = stage0.stdenv;
          curl   = bootstrapTools;
        };

        # The stdenvs themselves don't use mkDerivation, so I need to specify this here
        __stdenvImpureHostDeps = binShClosure ++ libSystemClosure;
        __extraImpureHostDeps  = binShClosure ++ libSystemClosure;

        extraAttrs = { inherit platform; };
        overrides  = pkgs: (overrides pkgs) // { fetchurl = thisStdenv.fetchurlBoot; };
      };

      thisPkgs = allPackages {
        inherit system platform;
        bootStdenv = thisStdenv;
      };
    in { stdenv = thisStdenv; pkgs = thisPkgs; };

  stage0 = stageFun 0 null {
    overrides = orig: with stage0; rec {
      darwin = orig.darwin // {
        Libsystem = stdenv.mkDerivation {
          name = "bootstrap-Libsystem";
          buildCommand = ''
            mkdir -p $out
            ln -s ${bootstrapTools}/lib $out/lib
            ln -s ${bootstrapTools}/include-Libsystem $out/include
          '';
        };
        dyld = bootstrapTools;
      };

      libcxx = stdenv.mkDerivation {
        name = "bootstrap-libcxx";
        phases = [ "installPhase" "fixupPhase" ];
        installPhase = ''
          mkdir -p $out/lib $out/include
          ln -s ${bootstrapTools}/lib/libc++.dylib $out/lib/libc++.dylib
          ln -s ${bootstrapTools}/include/c++      $out/include/c++
        '';
        setupHook = ../../development/compilers/llvm/3.5/libc++/setup-hook.sh;
      };

      libcxxabi = stdenv.mkDerivation {
        name = "bootstrap-libcxxabi";
        buildCommand = ''
          mkdir -p $out/lib
          ln -s ${bootstrapTools}/lib/libc++abi.dylib $out/lib/libc++abi.dylib
        '';
      };

      xz = stdenv.mkDerivation {
        name = "bootstrap-xz";
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${bootstrapTools}/bin/xz $out/bin/xz
        '';
      };
    };

    extraBuildInputs = [];
  };

  persistent0 = _: { inherit (stage0.pkgs) xz; };

  stage1 = with stage0; stageFun 1 stage0 {
    extraPreHook = "export NIX_CFLAGS_COMPILE+=\" -F${bootstrapTools}/Library/Frameworks\"";
    extraBuildInputs = [ pkgs.libcxx ];

    allowedRequisites =
      [ bootstrapTools ] ++ (with pkgs; [ libcxx libcxxabi ]) ++ [ pkgs.darwin.Libsystem ];

    overrides = persistent0;
  };

  persistent1 = orig: with stage1.pkgs; {
    inherit
      zlib patchutils m4 scons flex perl bison unifdef unzip openssl icu python
      libxml2 gettext sharutils gmp libarchive ncurses pkg-config libedit groff
      openssh sqlite sed serf openldap db cyrus-sasl expat apr-util subversion xz
      findfreetype libssh curl cmake autoconf automake libtool ed cpio coreutils;

    darwin = orig.darwin // {
      inherit (darwin)
        dyld Libsystem xnu configd libdispatch libclosure launchd;
    };
  };

  stage2 = with stage1; stageFun 2 stage1 {
    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ xz libcxx libcxxabi icu ]) ++
      (with pkgs.darwin; [ dyld Libsystem CF ]);

    overrides = persistent1;
  };

  persistent2 = orig: with stage2.pkgs; {
    inherit
      patchutils m4 scons flex perl bison unifdef unzip openssl python
      gettext sharutils libarchive pkg-config groff bash subversion
      openssh sqlite sed serf openldap db cyrus-sasl expat apr-util
      findfreetype libssh curl cmake autoconf automake libtool cpio
      libcxx libcxxabi;

    darwin = orig.darwin // {
      inherit (darwin)
        dyld Libsystem xnu configd libdispatch libclosure launchd;
    };
  };

  stage3 = with stage2; stageFun 3 stage2 {
    shell = "${pkgs.bash}/bin/bash";

    # We have a valid shell here (this one has no bootstrap-tools runtime deps) so stageFun
    # enables patchShebangs above. Unfortunately, patchShebangs ignores our $SHELL setting
    # and instead goes by $PATH, which happens to contain bootstrapTools. So it goes and
    # patches our shebangs back to point at bootstrapTools. This makes sure bash comes first.
    extraInitialPath = [ pkgs.bash ];

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ icu bash libcxx libcxxabi ]) ++
      (with pkgs.darwin; [ dyld Libsystem ]);

    overrides = persistent2;
  };

  persistent3 = orig: with stage3.pkgs; {
    inherit
      gnumake gzip gnused bzip2 gnutar gawk ed xz patch libiconv bash
      libcxxabi libcxx ncurses libffi zlib icu llvm gmp pcre gnugrep
      coreutils findutils diffutils patchutils;

    llvmPackages = orig.llvmPackages // {
      inherit (llvmPackages) llvm clang;
    };

    darwin = orig.darwin // {
      inherit (darwin) dyld Libsystem CF;
    };
  };

  stage4 = with stage3; stageFun 4 stage3 {
    shell = "${pkgs.bash}/bin/bash";
    extraInitialPath = [ pkgs.bash ];
    overrides = persistent3;
  };

  persistent4 = orig: with stage4.pkgs; {
    inherit
      gnumake gzip gnused bzip2 gnutar gawk ed xz patch libiconv bash
      libcxxabi libcxx ncurses libffi zlib icu llvm gmp pcre gnugrep
      coreutils findutils diffutils patchutils binutils binutils-raw;

    llvmPackages = orig.llvmPackages // {
      inherit (llvmPackages) llvm clang;
    };

    darwin = orig.darwin // {
      inherit (darwin) dyld Libsystem cctools CF;
    };
  };

  stage5 = with stage4; import ../generic rec {
    inherit system config;
    inherit (stdenv) fetchurlBoot;

    name = "stdenv-darwin";

    preHook = commonPreHook;

    __stdenvImpureHostDeps = binShClosure ++ libSystemClosure;
    __extraImpureHostDeps  = binShClosure ++ libSystemClosure;

    initialPath = import ../common-path.nix { inherit pkgs; };
    shell       = "${pkgs.bash}/bin/bash";

    cc = import ../../build-support/cc-wrapper {
      inherit stdenv shell;
      nativeTools = false;
      nativeLibc  = false;
      inherit (pkgs) coreutils binutils;
      inherit (pkgs.darwin) dyld;
      cc   = pkgs.llvmPackages.clang;
      libc = pkgs.darwin.Libsystem;
    };

    extraBuildInputs = with pkgs; [ darwin.CF libcxx ];

    extraAttrs = {
      inherit platform bootstrapTools;
      libc         = pkgs.darwin.Libsystem;
      shellPackage = pkgs.bash;
    };

    allowedRequisites = (with pkgs; [
      xz libcxx libcxxabi icu gmp gnumake findutils bzip2 llvm zlib libffi
      coreutils ed diffutils gnutar gzip ncurses libiconv gnused bash gawk
      gnugrep llvmPackages.clang patch pcre binutils-raw binutils gettext
    ]) ++ (with pkgs.darwin; [
      dyld Libsystem CF cctools
    ]);

    overrides = orig: persistent4 orig // {
      clang = cc;
      inherit cc;

      # TODO: do this more generally (requires some cleverness due to libtool depending on cctools
      # depending on libtool)
      inherit (pkgs.darwin) libtool;
    };
  };

  stdenvDarwin = stage5;
}
