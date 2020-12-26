{ lib, fetchurl, fetchFromGitHub, fetchpatch, callPackage
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
, boehmgc
}:

let

common =
  { lib, stdenv, perl, curl, bzip2, sqlite, openssl ? null, xz
  , bash, coreutils, gzip, gnutar
  , pkgconfig, boehmgc, perlPackages, libsodium, brotli, boost, editline, nlohmann_json
  , autoreconfHook, autoconf-archive, bison, flex
  , jq, libarchive
  , lowdown, mdbook
  # Used by tests
  , gmock
  , busybox-sandbox-shell
  , storeDir
  , stateDir
  , confDir
  , withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
  , withAWS ? !enableStatic && (stdenv.isLinux || stdenv.isDarwin), aws-sdk-cpp
  , enableStatic ? stdenv.hostPlatform.isStatic
  , name, suffix ? "", src
  , patches ? [ ]
  }:
  let
     sh = busybox-sandbox-shell;
     nix = stdenv.mkDerivation rec {
      inherit name src patches;
      version = lib.getVersion name;

      is24 = lib.versionAtLeast version "2.4pre";

      VERSION_SUFFIX = suffix;

      outputs = [ "out" "dev" "man" "doc" ];

      nativeBuildInputs =
        [ pkgconfig ]
        ++ lib.optionals is24
          [ autoreconfHook
            autoconf-archive
            bison flex
            lowdown mdbook
            jq
           ];

      buildInputs =
        [ curl openssl sqlite xz bzip2 nlohmann_json
          brotli boost editline
        ]
        ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
        ++ lib.optionals is24 [ libarchive gmock ]
        ++ lib.optional withLibseccomp libseccomp
        ++ lib.optional withAWS
            ((aws-sdk-cpp.override {
              apis = ["s3" "transfer"];
              customMemoryManagement = false;
            }).overrideDerivation (args: {
              patches = args.patches or [] ++ [
                ./aws-sdk-cpp-TransferManager-ContentEncoding.patch
              ];
            }));

      propagatedBuildInputs = [ boehmgc ];

      # Seems to be required when using std::atomic with 64-bit types
      NIX_LDFLAGS =
        # need to list libraries individually until
        # https://github.com/NixOS/nix/commit/3e85c57a6cbf46d5f0fe8a89b368a43abd26daba
        # is in a release
          lib.optionalString enableStatic "-lssl -lbrotlicommon -lssh2 -lz -lnghttp2 -lcrypto"

        # need to detect it here until
        # https://github.com/NixOS/nix/commits/74b4737d8f0e1922ef5314a158271acf81cd79f8
        # is in a release
        + lib.optionalString (stdenv.hostPlatform.system == "armv5tel-linux" || stdenv.hostPlatform.system == "armv6l-linux") "-latomic";

      preConfigure =
        # Copy libboost_context so we don't get all of Boost in our closure.
        # https://github.com/NixOS/nixpkgs/issues/45462
        lib.optionalString (!enableStatic) ''
          mkdir -p $out/lib
          cp -pd ${boost}/lib/{libboost_context*,libboost_thread*,libboost_system*} $out/lib
          rm -f $out/lib/*.a
          ${lib.optionalString stdenv.isLinux ''
            chmod u+w $out/lib/*.so.*
            patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib $out/lib/libboost_thread.so.*
          ''}
        '' +
        # On all versions before c9f51e87057652db0013289a95deffba495b35e7,
        # released with 2.3.8, we need to patch around an issue where the Nix
        # configure step pulls in the build system's bash and other utilities
        # when cross-compiling.
        lib.optionalString (
          stdenv.buildPlatform != stdenv.hostPlatform &&
          (lib.versionOlder "2.3.8" version && !is24)
          # The additional is24 condition is required as versionOlder doesn't understand nixUnstable version strings
        ) ''
          mkdir tmp/
          substitute corepkgs/config.nix.in tmp/config.nix.in \
            --subst-var-by bash ${bash}/bin/bash \
            --subst-var-by coreutils ${coreutils}/bin \
            --subst-var-by bzip2 ${bzip2}/bin/bzip2 \
            --subst-var-by gzip ${gzip}/bin/gzip \
            --subst-var-by xz ${xz}/bin/xz \
            --subst-var-by tar ${gnutar}/bin/tar \
            --subst-var-by tr ${coreutils}/bin/tr
          mv tmp/config.nix.in corepkgs/config.nix.in
          '';

      configureFlags =
        [ "--with-store-dir=${storeDir}"
          "--localstatedir=${stateDir}"
          "--sysconfdir=${confDir}"
          "--disable-init-state"
          "--enable-gc"
        ]
        ++ lib.optionals stdenv.isLinux [
          "--with-sandbox-shell=${sh}/bin/busybox"
        ]
        ++ lib.optional (
            stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system
        ) ''--with-system=${stdenv.hostPlatform.nix.system}''
           # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
        ++ lib.optional (!withLibseccomp) "--disable-seccomp-sandboxing";

      makeFlags = [ "profiledir=$(out)/etc/profile.d" ]
        ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "PRECOMPILE_HEADERS=0";

      installFlags = [ "sysconfdir=$(out)/etc" ];

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
        homepage = "https://nixos.org/";
        license = stdenv.lib.licenses.lgpl2Plus;
        maintainers = [ stdenv.lib.maintainers.eelco ];
        platforms = stdenv.lib.platforms.unix;
        outputsToInstall = [ "out" "man" ];
      };

      passthru = {
        perl-bindings = stdenv.mkDerivation {
          pname = "nix-perl";
          inherit version;

          inherit src;

          postUnpack = "sourceRoot=$sourceRoot/perl";

          # This is not cross-compile safe, don't have time to fix right now
          # but noting for future travellers.
          nativeBuildInputs =
            [ perl pkgconfig curl nix libsodium boost autoreconfHook autoconf-archive nlohmann_json ];

          configureFlags =
            [ "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
              "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
            ];

          preConfigure = "export NIX_STATE_DIR=$TMPDIR";

          preBuild = "unset NIX_INDENT_MAKE";
        };
      };
    };
  in nix;

in rec {

  nix = nixStable;

  nixStable = callPackage common (rec {
    name = "nix-2.3.10";
    src = fetchurl {
      url = "https://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "a8a85e55de43d017abbf13036edfb58674ca136691582f17080c1cd12787b7ab";
    };

    patches = [(
      fetchpatch {
        url = "https://github.com/NixOS/nix/pull/4316.patch";
        sha256 = "0bqlm4n9sac9prgr9xlfng92arisp1hiqvc9pfh4fibsppkgdfc5";
      }
    )];

    inherit storeDir stateDir confDir boehmgc;
  });

  nixUnstable = lib.lowPrio (callPackage common rec {
    name = "nix-2.4${suffix}";
    suffix = "pre20201205_a5d85d0";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "a5d85d07faa94cf3518e98273be4bee3d495f06a";
      sha256 = "0g9jjhh0vs4hjrff5yx88x6sh7rk87ngvni3gnyxajqia957dipg";
    };

    patches = [
      (fetchpatch { # Fix build on gcc10
        url = "https://github.com/NixOS/nix/commit/d4870462f8f539adeaa6dca476aff6f1f31e1981.patch";
        sha256 = "mTvLvuxb2QVybRDgntKMq+b6da/s3YgM/ll2rWBeY/Y=";
      })
    ];

    inherit storeDir stateDir confDir boehmgc;
  });

  nixFlakes = nixUnstable;

}
