{ lib, stdenv, fetchurl, fetchFromGitHub, perl, curl, bzip2, sqlite, openssl ? null, xz
, pkgconfig, boehmgc, perlPackages, libsodium, aws-sdk-cpp, brotli
, autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook5_xsl
, libseccomp, busybox
, hostPlatform
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
}:

let
  # We want the new fixed S3 retry behavior for nixUnstable, but it's a breaking
  # change so we don't want to update the top-level package.
  aws-sdk-cpp-1_3 = aws-sdk-cpp.overrideAttrs (_: rec {
    name = "aws-sdk-cpp-${version}";
    version = "1.3.22";

    src = fetchFromGitHub {
      owner = "awslabs";
      repo = "aws-sdk-cpp";
      rev = version;
      sha256 = "0sdgy8kqhxnw7n0sw4m3p3ay7yic3rhad5ab8m5lbx61ad9bq3c2";
    };
  });

  sh = busybox.override {
    useMusl = true;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_ASH y
      CONFIG_ASH_BUILTIN_ECHO y
      CONFIG_ASH_BUILTIN_TEST y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y
    '';
  };

  common = { name, suffix ? "", src, fromGit ? false }: stdenv.mkDerivation rec {
    inherit name src;
    version = lib.getVersion name;

    is112 = lib.versionAtLeast version "1.12pre";

    VERSION_SUFFIX = lib.optionalString fromGit suffix;

    outputs = [ "out" "dev" "man" "doc" ];

    nativeBuildInputs =
      [ pkgconfig ]
      ++ lib.optionals (!is112) [ perl ]
      ++ lib.optionals fromGit [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook5_xsl ];

    buildInputs = [ curl openssl sqlite xz ]
      ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
      ++ lib.optionals fromGit [ brotli ] # Since 1.12
      ++ lib.optional stdenv.isLinux libseccomp
      ++ lib.optional ((stdenv.isLinux || stdenv.isDarwin) && is112)
          (aws-sdk-cpp-1_3.override {
            apis = ["s3"];
            customMemoryManagement = false;
          });

    propagatedBuildInputs = [ boehmgc ];

    # Note: bzip2 is not passed as a build input, because the unpack phase
    # would end up using the wrong bzip2 when cross-compiling.
    # XXX: The right thing would be to reinstate `--with-bzip2' in Nix.
    postUnpack =
      '' export CPATH="${bzip2.dev}/include"
         export LIBRARY_PATH="${bzip2.out}/lib"
         export CXXFLAGS="-Wno-error=reserved-user-defined-literal"
      '';

    configureFlags =
      [ "--with-store-dir=${storeDir}"
        "--localstatedir=${stateDir}"
        "--sysconfdir=${confDir}"
        "--disable-init-state"
        "--enable-gc"
      ]
      ++ lib.optionals (!is112) [
        "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
        "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
        "--with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}"
      ] ++ lib.optionals (is112 && stdenv.isLinux) [
        "--with-sandbox-shell=${sh}/bin/busybox"
      ];

    makeFlags = "profiledir=$(out)/etc/profile.d";

    installFlags = "sysconfdir=$(out)/etc";

    doInstallCheck = true;

    # socket path becomes too long otherwise
    preInstallCheck = lib.optional stdenv.isDarwin "export TMPDIR=/tmp";

    separateDebugInfo = stdenv.isLinux;

    crossAttrs = {
      postUnpack =
        '' export CPATH="${bzip2.crossDrv}/include"
           export NIX_CROSS_LDFLAGS="-L${bzip2.crossDrv}/lib -rpath-link ${bzip2.crossDrv}/lib $NIX_CROSS_LDFLAGS"
        '';

      configureFlags =
        ''
          --with-store-dir=${storeDir} --localstatedir=${stateDir}
          --with-dbi=${perlPackages.DBI}/${perl.libPrefix}
          --with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}
          --with-www-curl=${perlPackages.WWWCurl}/${perl.libPrefix}
          --disable-init-state
          --enable-gc
        '' + stdenv.lib.optionalString (
            hostPlatform ? nix && hostPlatform.nix ? system
        ) ''--with-system=${hostPlatform.nix.system}'';

      doInstallCheck = false;
    };

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

  nixStable = (common rec {
    name = "nix-1.11.16";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "0ca5782fc37d62238d13a620a7b4bff6a200bab1bd63003709249a776162357c";
    };
  }) // { perl-bindings = nixStable; };

  nixUnstable = (lib.lowPrio (common rec {
    name = "nix-unstable-1.12${suffix}";
    suffix = "pre5873_b76e282d";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "b76e282da8824b679368370e43c994e588994a9a";
      sha256 = "11clfc8fh8q8s3k4canmn36xhh3zcl2zd8wwddp4pdvdal16b5n6";
    };
    fromGit = true;
  })) // { perl-bindings = perl-bindings { nix = nixUnstable; }; };

}
