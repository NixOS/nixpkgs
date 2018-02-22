{ lib, stdenv, fetchurl, fetchFromGitHub, perl, curl, bzip2, sqlite, openssl ? null, xz
, pkgconfig, boehmgc, perlPackages, libsodium, aws-sdk-cpp, brotli
, autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook5_xsl
, libseccomp, busybox-sandbox-shell
, hostPlatform, buildPlatform
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
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
      ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook5_xsl ];

    buildInputs = [ curl openssl sqlite xz bzip2 ]
      ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
      ++ lib.optionals fromGit [ brotli ] # Since 1.12
      ++ lib.optional (stdenv.isLinux && !hostPlatform.isRiscV) libseccomp
      ++ lib.optional ((stdenv.isLinux || stdenv.isDarwin) && is20)
          (aws-sdk-cpp.override {
            apis = ["s3"];
            customMemoryManagement = false;
          });

    propagatedBuildInputs = [ boehmgc ];

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
      ++ lib.optional hostPlatform.isRiscV "--disable-seccomp-sandboxing";

    makeFlags = "profiledir=$(out)/etc/profile.d";

    installFlags = "sysconfdir=$(out)/etc";

    doInstallCheck = true; # not cross

    # socket path becomes too long otherwise
    preInstallCheck = lib.optional stdenv.isDarwin "export TMPDIR=/tmp";

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

  perl-bindings = { nix }: stdenv.mkDerivation {
    name = "nix-perl-" + nix.version;

    inherit (nix) src;

    postUnpack = "sourceRoot=$sourceRoot/perl";

    nativeBuildInputs =
      [ perl pkgconfig curl nix libsodium ]
      ++ lib.optionals nix.fromGit [ autoreconfHook autoconf-archive ];

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
  }) // { perl-bindings = nixStable; };

  nixStable = (common rec {
    name = "nix-2.0";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "7024d327314bf92c1d3e6cccd944929828a44b24093954036bfb0115a92f5a14";
    };
  }) // { perl-bindings = perl-bindings { nix = nixStable; }; };

  nixUnstable = (lib.lowPrio (common rec {
    name = "nix-2.0${suffix}";
    suffix = "pre5968_a6c0b773";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "a6c0b773b72d4e30690e01f1f1dcffc28f2d9ea1";
      sha256 = "0i8wcblcjw3291ba6ki4llw3fgm8ylp9q52kajkyr58dih537346";
    };
    fromGit = true;
  })) // { perl-bindings = perl-bindings { nix = nixUnstable; }; };

}
