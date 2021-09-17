{ lib, fetchurl, fetchFromGitHub, fetchpatch, callPackage
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
, boehmgc
, Security
}:

let

common =
  { lib, stdenv, perl, curl, bzip2, sqlite, openssl ? null, xz
  , bash, coreutils, util-linuxMinimal, gzip, gnutar
  , pkg-config, boehmgc, libsodium, brotli, boost, editline, nlohmann_json
  , autoreconfHook, autoconf-archive, bison, flex
  , jq, libarchive, libcpuid
  , lowdown, mdbook
  # Used by tests
  , gtest
  , busybox-sandbox-shell
  , storeDir
  , stateDir
  , confDir
  , withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp, libseccomp
  , withAWS ? !enableStatic && (stdenv.isLinux || stdenv.isDarwin), aws-sdk-cpp
  , enableStatic ? stdenv.hostPlatform.isStatic
  , enableDocumentation ? lib.versionOlder version "2.4pre" ||
                          stdenv.hostPlatform == stdenv.buildPlatform
  , pname, version, suffix ? "", src
  , patches ? [ ]
  }:
  let
     sh = busybox-sandbox-shell;
     nix = stdenv.mkDerivation rec {
      inherit pname version src patches;

      is24 = lib.versionAtLeast version "2.4pre";

      VERSION_SUFFIX = suffix;

      outputs =
        [ "out" "dev" ]
        ++ lib.optionals enableDocumentation [ "man" "doc" ];

      hardeningEnable = [ "pie" ];

      nativeBuildInputs =
        [ pkg-config ]
        ++ lib.optionals stdenv.isLinux [ util-linuxMinimal ]
        ++ lib.optionals (is24 && enableDocumentation) [
          (lib.getBin lowdown) mdbook
        ]
        ++ lib.optionals is24
          [ autoreconfHook
            autoconf-archive
            bison flex
            jq
           ];

      buildInputs =
        [ curl libsodium openssl sqlite xz bzip2 nlohmann_json
          brotli boost editline
        ]
        ++ lib.optionals stdenv.isDarwin [ Security ]
        ++ lib.optionals is24 [ libarchive gtest lowdown ]
        ++ lib.optional (is24 && stdenv.isx86_64) libcpuid
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
        # On all versions before c9f51e87057652db0013289a95deffba495b35e7, which
        # removes config.nix entirely and is not present in 2.3.x, we need to
        # patch around an issue where the Nix configure step pulls in the build
        # system's bash and other utilities when cross-compiling.
        lib.optionalString (
          stdenv.buildPlatform != stdenv.hostPlatform && !is24
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
          "--enable-gc"
        ]
        ++ lib.optional (!enableDocumentation) "--disable-doc-gen"
        ++ lib.optionals (!is24) [
          # option was removed in 2.4
          "--disable-init-state"
        ]
        ++ lib.optionals stdenv.isLinux [
          "--with-sandbox-shell=${sh}/bin/busybox"
        ]
        ++ lib.optional (
            stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system
        ) "--with-system=${stdenv.hostPlatform.nix.system}"
           # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
        ++ lib.optional (!withLibseccomp) "--disable-seccomp-sandboxing";

      makeFlags = [ "profiledir=$(out)/etc/profile.d" ]
        ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "PRECOMPILE_HEADERS=0";

      installFlags = [ "sysconfdir=$(out)/etc" ];

      doInstallCheck = true; # not cross

      # socket path becomes too long otherwise
      preInstallCheck = lib.optionalString stdenv.isDarwin ''
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
        license = lib.licenses.lgpl2Plus;
        maintainers = [ lib.maintainers.eelco ];
        platforms = lib.platforms.unix;
        outputsToInstall = [ "out" ] ++ lib.optional enableDocumentation "man";
      };

      passthru = {
        perl-bindings = perl.pkgs.toPerlModule (stdenv.mkDerivation {
          pname = "nix-perl";
          inherit version;

          inherit src;

          postUnpack = "sourceRoot=$sourceRoot/perl";

          # This is not cross-compile safe, don't have time to fix right now
          # but noting for future travellers.
          nativeBuildInputs =
            [ perl pkg-config curl nix libsodium boost autoreconfHook autoconf-archive nlohmann_json ];

          configureFlags =
            [ "--with-dbi=${perl.pkgs.DBI}/${perl.libPrefix}"
              "--with-dbd-sqlite=${perl.pkgs.DBDSQLite}/${perl.libPrefix}"
            ];

          preConfigure = "export NIX_STATE_DIR=$TMPDIR";

          preBuild = "unset NIX_INDENT_MAKE";
        });
        inherit boehmgc;
      };
    };
  in nix;

  boehmgc_nix = boehmgc.override {
    enableLargeConfig = true;
  };

  boehmgc_nixUnstable = boehmgc_nix.overrideAttrs (drv: {
    patches = (drv.patches or []) ++ [
      # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
      (fetchpatch {
        url = https://github.com/hercules-ci/nix/raw/5c58d84a76d96f269e3ff1e72c9c9ba5f68576af/boehmgc-coroutine-sp-fallback.diff;
        sha256 = "sha256-JvnWVTlkltmQUs/0qApv/LPZ690UX1/2hEP+LYRwKbI=";
      })
    ];
  });

in rec {

  nix = nixStable;

  nixStable = callPackage common (rec {
    pname = "nix";
    version = "2.3.15";
    src = fetchurl {
      url = "https://nixos.org/releases/nix/${pname}-${version}/${pname}-${version}.tar.xz";
      sha256 = "sha256-N+MxClX94eUOfUMh0puRgNHp16+cjSEdtqZn5u5OtBA=";
    };

    boehmgc = boehmgc_nix;

    inherit storeDir stateDir confDir;
  });

  nixUnstable = lib.lowPrio (callPackage common rec {
    pname = "nix";
    version = "2.4${suffix}";
    suffix = "pre20210908_${lib.substring 0 7 src.rev}";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "3c56f62093601143838af923195f630d8ffae2d4";
      sha256 = "sha256-pjdzLOEt8i1NQe4drLpp8+LrRd2MgsISSQEsMebz2kc=";
    };

    boehmgc = boehmgc_nixUnstable;

    inherit storeDir stateDir confDir;

  });

}
