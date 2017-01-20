{ lib
, system, platform, crossSystem, config, overlays

# Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
, bootstrapFiles ? let
  fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/33f59c9d11b8d5014dfd18cc11a425f6393c884a/${file}";
    inherit sha256 system executable;
  }; in {
    sh      = fetch { file = "sh";    sha256 = "1rx4kg6358xdj05z0m139a0zn4f4zfmq4n4vimlmnwyfiyn4x7wk"; };
    bzip2   = fetch { file = "bzip2"; sha256 = "104qnhzk79vkbp2yi0kci6lszgfppvrwk3rgxhry842ly1xz2r7l"; };
    mkdir   = fetch { file = "mkdir"; sha256 = "0d91c19xjzmqisncvldv79d7ddzai9l7vcmajhwlwwv74g6da5yl"; };
    cpio    = fetch { file = "cpio";  sha256 = "0lw057bmcqls96j0gv1n3mgl66q31mba7i413cbkkaf0rfzz3dxj"; };
    tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "13ihbj002pis3fgy1d9c4fi7flca21z9brjsjkklm82h5b4nlwxl"; executable = false; };
  }
}:

assert crossSystem == null;

let
  libSystemProfile = ''
    (import "${./standard-sandbox.sb}")
  '';
in rec {
  commonPreHook = ''
    export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
    export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
    export NIX_IGNORE_LD_THROUGH_GCC=1
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
    export MACOSX_DEPLOYMENT_TARGET=10.10
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
                          overrides         ? (self: super: {}),
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
        overrides  = self: super: (overrides self super) // { fetchurl = thisStdenv.fetchurlBoot; };
      };

    in {
      inherit system platform crossSystem config overlays;
      stdenv = thisStdenv;
    };

  stage0 = stageFun 0 null {
    overrides = self: super: with stage0; rec {
      darwin = super.darwin // {
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
        setupHook = ../../development/compilers/llvm/3.9/libc++/setup-hook.sh;
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

  persistent0 = _: _: _: {};

  stage1 = prevStage: with prevStage; stageFun 1 prevStage {
    extraPreHook = "export NIX_CFLAGS_COMPILE+=\" -F${bootstrapTools}/Library/Frameworks\"";
    extraBuildInputs = [ pkgs.libcxx ];

    allowedRequisites =
      [ bootstrapTools ] ++ (with pkgs; [ libcxx libcxxabi ]) ++ [ pkgs.darwin.Libsystem ];

    overrides = persistent0 prevStage;
  };

  persistent1 = prevStage: self: super: with prevStage; {
    inherit
      zlib patchutils m4 scons flex perl bison unifdef unzip openssl icu python
      libxml2 gettext sharutils gmp libarchive ncurses pkg-config libedit groff
      openssh sqlite sed serf openldap db cyrus-sasl expat apr-util subversion xz
      findfreetype libssh curl cmake autoconf automake libtool ed cpio coreutils;

    darwin = super.darwin // {
      inherit (darwin)
        dyld Libsystem xnu configd libdispatch libclosure launchd;
    };
  };

  stage2 = prevStage: with prevStage; stageFun 2 prevStage {
    extraPreHook = ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    extraBuildInputs = with pkgs; [ xz darwin.CF libcxx ];

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ xz.bin xz.out libcxx libcxxabi icu.out ]) ++
      (with pkgs.darwin; [ dyld Libsystem CF locale ]);

    overrides = persistent1 prevStage;
  };

  persistent2 = prevStage: self: super: with prevStage; {
    inherit
      patchutils m4 scons flex perl bison unifdef unzip openssl python
      gettext sharutils libarchive pkg-config groff bash subversion
      openssh sqlite sed serf openldap db cyrus-sasl expat apr-util
      findfreetype libssh curl cmake autoconf automake libtool cpio
      libcxx libcxxabi;

    darwin = super.darwin // {
      inherit (darwin)
        dyld Libsystem xnu configd libdispatch libclosure launchd libiconv locale;
    };
  };

  stage3 = prevStage: with prevStage; stageFun 3 prevStage {
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

    overrides = persistent2 prevStage;
  };

  persistent3 = prevStage: self: super: with prevStage; {
    inherit
      gnumake gzip gnused bzip2 gawk ed xz patch bash
      libcxxabi libcxx ncurses libffi zlib gmp pcre gnugrep
      coreutils findutils diffutils patchutils;

    llvmPackages = let llvmOverride = llvmPackages.llvm.override { inherit libcxxabi; };
    in super.llvmPackages // {
      llvm = llvmOverride;
      clang-unwrapped = llvmPackages.clang-unwrapped.override { llvm = llvmOverride; };
    };

    darwin = super.darwin // {
      inherit (darwin) dyld Libsystem libiconv locale;
    };
  };

  stage4 = prevStage: with prevStage; stageFun 4 prevStage {
    shell = "${pkgs.bash}/bin/bash";
    extraBuildInputs = with pkgs; [ xz darwin.CF libcxx pkgs.bash ];
    extraPreHook = ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';
    overrides = persistent3 prevStage;
  };

  persistent4 = prevStage: self: super: with prevStage; {
    inherit
      gnumake gzip gnused bzip2 gawk ed xz patch bash
      libcxxabi libcxx ncurses libffi zlib icu llvm gmp pcre gnugrep
      coreutils findutils diffutils patchutils binutils binutils-raw;

    llvmPackages = super.llvmPackages // {
      inherit (llvmPackages) llvm clang-unwrapped;
    };

    darwin = super.darwin // {
      inherit (darwin) dyld Libsystem cctools libiconv;
    };
  };

  stdenvDarwin = prevStage: let pkgs = prevStage; in import ../generic rec {
    inherit system config;
    inherit (pkgs.stdenv) fetchurlBoot;

    name = "stdenv-darwin";

    preHook = commonPreHook + ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    stdenvSandboxProfile = binShClosure + libSystemProfile;
    extraSandboxProfile  = binShClosure + libSystemProfile;

    initialPath = import ../common-path.nix { inherit pkgs; };
    shell       = "${pkgs.bash}/bin/bash";

    cc = import ../../build-support/cc-wrapper {
      inherit (pkgs) stdenv;
      inherit shell;
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

    overrides = self: super: persistent4 prevStage self super // {
      clang = cc;
      inherit cc;
    };
  };

  stagesDarwin = [
    ({}: stage0)
    stage1
    stage2
    stage3
    stage4
    (prevStage: {
      inherit system crossSystem platform config overlays;
      stdenv = stdenvDarwin prevStage;
    })
  ];
}
