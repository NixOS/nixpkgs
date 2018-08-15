{ lib, stdenv, fetchurl, fetchFromGitHub, perl, curl, bzip2, sqlite, openssl ? null, xz
, pkgconfig, boehmgc, perlPackages, libsodium, aws-sdk-cpp, brotli, boost
, autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook_xsl_ns
, busybox-sandbox-shell
, hostPlatform, buildPlatform
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
, withLibseccomp ? libseccomp.meta.available, libseccomp
}:

let

  sh = busybox-sandbox-shell;

  common = { name, suffix ? "", src, fromGit ? false }: stdenv.mkDerivation rec {
    inherit name src;
    version = lib.getVersion name;

    is20 = lib.versionAtLeast version "2.0pre";

    VERSION_SUFFIX = lib.optionalString fromGit suffix;

    outputs = [ "out" "dev" "man" "doc" ];

    nativeBuildInputs =
      [ pkgconfig ]
      ++ lib.optionals (!is20) [ curl perl ]
      ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook_xsl_ns ];

    buildInputs = [ curl openssl sqlite xz bzip2 ]
      ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
      ++ lib.optionals is20 [ brotli ] # Since 1.12
      ++ lib.optional withLibseccomp libseccomp
      ++ lib.optional ((stdenv.isLinux || stdenv.isDarwin) && is20)
          (aws-sdk-cpp.override {
            apis = ["s3" "transfer"];
            customMemoryManagement = false;
          })
      ++ lib.optional fromGit boost;

    propagatedBuildInputs = [ boehmgc ];

    # Seems to be required when using std::atomic with 64-bit types
    NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.system == "armv6l-linux") "-latomic";

    configureFlags =
      [ "--with-store-dir=${storeDir}"
        "--localstatedir=${stateDir}"
        "--sysconfdir=${confDir}"
        "--disable-init-state"
        "--enable-gc"
      ]
      ++ lib.optionals (!is20) [
        "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
        "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
        "--with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}"
      ] ++ lib.optionals (is20 && stdenv.isLinux) [
        "--with-sandbox-shell=${sh}/bin/busybox"
      ]
      ++ lib.optional (
          hostPlatform != buildPlatform && hostPlatform ? nix && hostPlatform.nix ? system
      ) ''--with-system=${hostPlatform.nix.system}''
         # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
      ++ lib.optional (!libseccomp.meta.available) "--disable-seccomp-sandboxing";

    makeFlags = "profiledir=$(out)/etc/profile.d";

    installFlags = "sysconfdir=$(out)/etc";

    doInstallCheck = true; # not cross

    # socket path becomes too long otherwise
    preInstallCheck = lib.optional stdenv.isDarwin ''
      export TMPDIR=$NIX_BUILD_TOP
    '';

    separateDebugInfo = stdenv.isLinux;

    enableParallelBuilding = true;

    meta = {
      description = "Powerful package manager that makes package management reliable and reproducible";
      longDescription = ''
        Nix is a powerful package manager for Linux and other Unix systems that
        makes package management reliable and reproducible. It provides atomic
        upgrades and rollbacks, side-by-side installation of multiple versions of
        a package, multi-user package management and easy setup of build
        environments.
      '';
      homepage = https://nixos.org/;
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.all;
      outputsToInstall = [ "out" "man" ];
    };

    passthru = { inherit fromGit; };
  };

  perl-bindings = { nix, needsBoost ? false }: stdenv.mkDerivation {
    name = "nix-perl-" + nix.version;

    inherit (nix) src;

    postUnpack = "sourceRoot=$sourceRoot/perl";

    # This is not cross-compile safe, don't have time to fix right now
    # but noting for future travellers.
    nativeBuildInputs =
      [ perl pkgconfig curl nix libsodium ]
      ++ lib.optionals nix.fromGit [ autoreconfHook autoconf-archive ]
      ++ lib.optional needsBoost boost;

    configureFlags =
      [ "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
        "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
      ];

    preConfigure = "export NIX_STATE_DIR=$TMPDIR";

    preBuild = "unset NIX_INDENT_MAKE";
  };

in rec {

  nix = nixStable;

  nix1 = (common rec {
    name = "nix-1.11.16";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "0ca5782fc37d62238d13a620a7b4bff6a200bab1bd63003709249a776162357c";
    };
  }) // { perl-bindings = nix1; };

  nixStable = (common rec {
    name = "nix-2.0.4";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "166540ff7b8bb41449586b67e5fc6ab9e25525f6724b6c6bcbfb0648fbd6496b";
    };
  }) // { perl-bindings = perl-bindings { nix = nixStable; }; };

  nixUnstable = (lib.lowPrio (common rec {
    name = "nix-2.1${suffix}";
    suffix = "pre6338_45bcf541";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "45bcf5416a0ce53361fd37c6b27ba4ef6a34ce96";
      sha256 = "0ps45n78wnczz99dd9fs54ydxwh2cjq73zbvmak0y49nhc3p0vvv";
    };
    fromGit = true;
  })) // { perl-bindings = perl-bindings {
    nix = nixUnstable;
    needsBoost = true;
  }; };

}
