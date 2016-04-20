{ system         ? builtins.currentSystem
, allPackages    ? import ../../..
, platform       ? null
, config         ? {}

# Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
, bootstrapFiles ? let
  fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/4f07c88d467216d9692fefc951deb5cd3c4cc722/${file}";
    inherit sha256 system executable;
  }; in {
    sh      = fetch { file = "sh";    sha256 = "1siix3wakzil31r2cydmh3v8a1nyq4605dwiabqc5lx73j4xzrzi"; };
    bzip2   = fetch { file = "bzip2"; sha256 = "0zvqm977k11b5cl4ixxb5h0ds24g6z0f8m28z4pqxzpa353lqbla"; };
    mkdir   = fetch { file = "mkdir"; sha256 = "13frk8lsfgzlb65p9l26cvxf06aag43yjk7vg9msn7ix3v8cmrg1"; };
    cpio    = fetch { file = "cpio";  sha256 = "0ms5i9m1vdksj575sf1djwgm7zhnvfrrb44dxnfh9avr793rc2w4"; };
    tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "1lz1b0grl4642h6n635xvi6imf0yyy1zyzdr9ing5aphzz0z5iic"; executable = false; };
  }
}:

let
  libSystemProfile = ''
    (import "${./standard-sandbox.sb}")
  '';
in rec {
  allPackages = import ../../..;

  commonPreHook = ''
    export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
    export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
    export NIX_IGNORE_LD_THROUGH_GCC=1
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
    export MACOSX_DEPLOYMENT_TARGET=10.7
    export SDKROOT=
    export CMAKE_OSX_ARCHITECTURES=x86_64
    # Workaround for https://openradar.appspot.com/22671534 on 10.11.
    export gl_cv_func_getcwd_abort_bug=no
  '';

  # The one dependency of /bin/sh :(
  binShClosure = ''
    (allow file-read* (literal "/usr/lib/libncurses.5.4.dylib"))
  '';

  bootstrapTools = derivation rec {
    inherit system;

    name    = "bootstrap-tools";
    builder = bootstrapFiles.sh; # Not a filename! Attribute 'sh' on bootstrapFiles
    args    = [ ./unpack-bootstrap-tools.sh ];

    inherit (bootstrapFiles) mkdir bzip2 cpio tarball;

    __sandboxProfile = binShClosure + libSystemProfile;
  };

  stageFun = step: last: {shell             ? "${bootstrapTools}/bin/sh",
                          overrides         ? (pkgs: {}),
                          extraPreHook      ? "",
                          extraBuildInputs,
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
        initialPath  = [ bootstrapTools ];
        fetchurlBoot = import ../../build-support/fetchurl {
          stdenv = stage0.stdenv;
          curl   = bootstrapTools;
        };

        # The stdenvs themselves don't use mkDerivation, so I need to specify this here
        stdenvSandboxProfile = binShClosure + libSystemProfile;
        extraSandboxProfile  = binShClosure + libSystemProfile;

        extraAttrs = { inherit platform; parent = last; };
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
    extraPreHook = ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    extraBuildInputs = with pkgs; [ xz darwin.CF libcxx ];

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ xz.bin xz.out libcxx libcxxabi icu.out ]) ++
      (with pkgs.darwin; [ dyld Libsystem CF locale ]);

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
        dyld Libsystem xnu configd libdispatch libclosure launchd libiconv locale;
    };
  };

  stage3 = with stage2; stageFun 3 stage2 {
    shell = "${pkgs.bash}/bin/bash";

    # We have a valid shell here (this one has no bootstrap-tools runtime deps) so stageFun
    # enables patchShebangs above. Unfortunately, patchShebangs ignores our $SHELL setting
    # and instead goes by $PATH, which happens to contain bootstrapTools. So it goes and
    # patches our shebangs back to point at bootstrapTools. This makes sure bash comes first.
    extraBuildInputs = with pkgs; [ xz darwin.CF libcxx pkgs.bash ];

    extraPreHook = ''
      export PATH=${pkgs.bash}/bin:$PATH
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ xz.bin xz.out icu.out bash libcxx libcxxabi ]) ++
      (with pkgs.darwin; [ dyld Libsystem locale ]);

    overrides = persistent2;
  };

  persistent3 = orig: with stage3.pkgs; {
    inherit
      gnumake gzip gnused bzip2 gawk ed xz patch bash
      libcxxabi libcxx ncurses libffi zlib gmp pcre gnugrep
      coreutils findutils diffutils patchutils;

    llvmPackages = let llvmOverride = llvmPackages.llvm.override { inherit libcxxabi; };
    in orig.llvmPackages // {
      llvm = llvmOverride;
      clang-unwrapped = llvmPackages.clang-unwrapped.override { llvm = llvmOverride; };
    };

    darwin = orig.darwin // {
      inherit (darwin) dyld Libsystem libiconv locale;
    };
  };

  stage4 = with stage3; stageFun 4 stage3 {
    shell = "${pkgs.bash}/bin/bash";
    extraBuildInputs = with pkgs; [ xz darwin.CF libcxx pkgs.bash ];
    extraPreHook = ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';
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
      inherit (darwin) dyld Libsystem cctools libiconv;
    };
  };

  stage5 = with stage4; import ../generic rec {
    inherit system config;
    inherit (stdenv) fetchurlBoot;

    name = "stdenv-darwin";

    preHook = commonPreHook + ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    stdenvSandboxProfile = binShClosure + libSystemProfile;
    extraSandboxProfile  = binShClosure + libSystemProfile;

    initialPath = import ../common-path.nix { inherit pkgs; };
    shell       = "${pkgs.bash}/bin/bash";

    cc = import ../../build-support/cc-wrapper {
      inherit stdenv shell;
      nativeTools = false;
      nativeLibc  = false;
      inherit (pkgs) coreutils binutils gnugrep;
      inherit (pkgs.darwin) dyld;
      cc   = pkgs.llvmPackages.clang-unwrapped;
      libc = pkgs.darwin.Libsystem;
    };

    extraBuildInputs = with pkgs; [ darwin.CF libcxx ];

    extraAttrs = {
      inherit platform bootstrapTools;
      libc         = pkgs.darwin.Libsystem;
      shellPackage = pkgs.bash;
      parent       = stage4;
    };

    allowedRequisites = (with pkgs; [
      xz.out xz.bin libcxx libcxxabi icu.out gmp.out gnumake findutils bzip2.out
      bzip2.bin llvmPackages.llvm zlib.out zlib.dev libffi.out coreutils ed diffutils gnutar
      gzip ncurses.out ncurses.dev ncurses.man gnused bash gawk
      gnugrep llvmPackages.clang-unwrapped patch pcre.out binutils-raw.out
      binutils-raw.dev binutils gettext
    ]) ++ (with pkgs.darwin; [
      dyld Libsystem CF cctools libiconv locale
    ]);

    overrides = orig: persistent4 orig // {
      clang = cc;
      inherit cc;
    };
  };

  stdenvDarwin = stage5;
}
