{ system      ? builtins.currentSystem
, allPackages ? import ../../top-level/all-packages.nix
, platform    ? null
, config      ? {}
}:

let
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

  fetch = { file, sha256 }: derivation ((import <nix/fetchurl.nix> {
    url = "https://dl.dropboxusercontent.com/u/2857322/${file}";
    inherit sha256;
    executable = true;
  }).drvAttrs // {
    __impureHostDeps = libSystemClosure;
  });

  bootstrapFiles = {
    sh    = fetch { file = "sh";    sha256 = "1qakpg37vl61jnkplz13m3g1csqr85cg8ybp6jwiv6apmg26isnm"; };
    bzip2 = fetch { file = "bzip2"; sha256 = "1gxa67255q9v00j1vn1mzyrnbwys2g1102cx02vpcyvvrl4vqxr0"; };
    mkdir = fetch { file = "mkdir"; sha256 = "1yfl8w65ksji7fggrbvqxw8lp0gm02qilk11n9axj2jxay53ngvg"; };
    cpio  = fetch { file = "cpio";  sha256 = "0nssyg19smgcblwq1mfcw4djbd85md84d2f093qcqkbigdjg484b"; };
  };
  tarball = fetch { file = "bootstrap-tools.9.cpio.bz2"; sha256 = "0fd79k7gy3z3sba5w4f4lnrcpiwff31vw02480x1pdry8bbgbf2j"; };
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

        cc = if isNull last then "/dev/null" else import ../../build-support/cc-wrapper {
          inherit shell;
          inherit (last) stdenv;
          inherit (last.pkgs.darwin) dyld;

          nativeTools  = true;
          nativePrefix = bootstrapTools;
          nativeLibc   = false;
          libc         = last.pkgs.darwin.Libsystem;
          isClang      = true;
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
        linkCxxAbi = false;
        setupHook = ../../development/compilers/llvm/3.6/libc++/setup-hook.sh;
      };

      libcxxabi = stdenv.mkDerivation {
        name = "bootstrap-libcxxabi";
        buildCommand = ''
          mkdir -p $out/lib
          ln -s ${bootstrapTools}/lib/libc++abi.dylib $out/lib/libc++abi.dylib
        '';
      };

    };

    extraBuildInputs = [];
  };

  persistent0 = _: {};

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
        dyld Libsystem xnu configd libdispatch libclosure launchd libiconv;
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
      gnumake gzip gnused bzip2 gawk ed xz patch bash
      libcxxabi libcxx ncurses libffi zlib llvm gmp pcre gnugrep
      coreutils findutils diffutils patchutils;

    llvmPackages = orig.llvmPackages // {
      inherit (llvmPackages) llvm clang-unwrapped;
    };

    darwin = orig.darwin // {
      inherit (darwin) dyld Libsystem libiconv;
    };
  };

  stage4 = with stage3; stageFun 4 stage3 {
    shell = "${pkgs.bash}/bin/bash";
    extraInitialPath = [ pkgs.bash ];
    overrides = persistent3;
  };

  persistent4 = orig: with stage4.pkgs; {
    inherit
      gnumake gzip gnused bzip2 gawk ed xz patch bash
      libcxxabi libcxx ncurses libffi zlib icu llvm gmp pcre gnugrep
      coreutils findutils diffutils patchutils binutils binutils-raw;

    llvmPackages = orig.llvmPackages // {
      inherit (llvmPackages) llvm clang-unwrapped;
    };

    darwin = orig.darwin // {
      inherit (darwin) dyld Libsystem cctools CF libiconv;
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
      cc   = pkgs.llvmPackages.clang-unwrapped;
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
      coreutils ed diffutils gnutar gzip ncurses gnused bash gawk
      gnugrep llvmPackages.clang-unwrapped patch pcre binutils-raw binutils gettext
    ]) ++ (with pkgs.darwin; [
      dyld Libsystem CF cctools libiconv
    ]);

    overrides = orig: persistent4 orig // {
      clang = cc;
      inherit cc;
    };
  };
}
