{ lib, fetchurl, fetchFromGitHub, callPackage
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
, boehmgc
, stdenv, llvmPackages_6
}:

let

common =
  { lib, stdenv, fetchpatch, perl, curl, bzip2, sqlite, openssl ? null, xz
  , pkgconfig, boehmgc, perlPackages, libsodium, brotli, boost, editline, nlohmann_json
  , autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook_xsl_ns, jq
  , busybox-sandbox-shell
  , storeDir
  , stateDir
  , confDir
  , withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
  , withAWS ? stdenv.isLinux || stdenv.isDarwin, aws-sdk-cpp

  , name, suffix ? "", src, includesPerl ? false, fromGit ? false, libarchive, rustc, cargo

  }:
  let
     sh = busybox-sandbox-shell;
     nix = stdenv.mkDerivation (rec {
      inherit name src;
      version = lib.getVersion name;

      is20 = lib.versionAtLeast version "2.0pre";

      VERSION_SUFFIX = lib.optionalString fromGit suffix;

      outputs = [ "out" "dev" "man" "doc" ];

      nativeBuildInputs =
        [ pkgconfig ]
        ++ lib.optionals (!is20) [ curl perl ]
        ++ lib.optionals fromGit [
          autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook_xsl_ns jq rustc cargo
        ];

      buildInputs = [ curl openssl sqlite xz bzip2 nlohmann_json ]
        ++ lib.optional fromGit libarchive
        ++ lib.optional (stdenv.isLinux || stdenv.isDarwin) libsodium
        ++ lib.optionals is20 [ brotli boost editline ]
        ++ lib.optional withLibseccomp libseccomp
        ++ lib.optional (withAWS && is20)
            ((aws-sdk-cpp.override {
              apis = ["s3" "transfer"];
              customMemoryManagement = false;
            }).overrideDerivation (args: {
              patches = args.patches or [] ++ [(fetchpatch {
                url = https://github.com/edolstra/aws-sdk-cpp/commit/7d58e303159b2fb343af9a1ec4512238efa147c7.patch;
                sha256 = "103phn6kyvs1yc7fibyin3lgxz699qakhw671kl207484im55id1";
              })];
            }));

      propagatedBuildInputs = [ boehmgc ];

      # Seems to be required when using std::atomic with 64-bit types
      NIX_LDFLAGS = lib.optionalString (stdenv.hostPlatform.system == "armv6l-linux") "-latomic";

      preConfigure =
        # Copy libboost_context so we don't get all of Boost in our closure.
        # https://github.com/NixOS/nixpkgs/issues/45462
        if is20 then ''
          mkdir -p $out/lib
          cp -pd ${boost}/lib/{libboost_context*,libboost_thread*,libboost_system*} $out/lib
          rm -f $out/lib/*.a
          ${lib.optionalString stdenv.isLinux ''
            chmod u+w $out/lib/*.so.*
            patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib $out/lib/libboost_thread.so.*
          ''}
        '' else ''
          configureFlagsArray+=(BDW_GC_LIBS="-lgc -lgccpp")
        '';

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
            stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system
        ) ''--with-system=${stdenv.hostPlatform.nix.system}''
           # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
        ++ lib.optional (!withLibseccomp) "--disable-seccomp-sandboxing";

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
        platforms = stdenv.lib.platforms.unix;
        outputsToInstall = [ "out" "man" ];
      };

      passthru = {
        inherit fromGit;

        perl-bindings = if includesPerl then nix else stdenv.mkDerivation {
          pname = "nix-perl";
          inherit version;

          inherit src;

          postUnpack = "sourceRoot=$sourceRoot/perl";

          # This is not cross-compile safe, don't have time to fix right now
          # but noting for future travellers.
          nativeBuildInputs =
            [ perl pkgconfig curl nix libsodium ]
            ++ lib.optionals fromGit [ autoreconfHook autoconf-archive ]
            ++ lib.optional is20 boost;

          configureFlags =
            [ "--with-dbi=${perlPackages.DBI}/${perl.libPrefix}"
              "--with-dbd-sqlite=${perlPackages.DBDSQLite}/${perl.libPrefix}"
            ];

          preConfigure = "export NIX_STATE_DIR=$TMPDIR";

          preBuild = "unset NIX_INDENT_MAKE";
        };
      };
    } // lib.optionalAttrs fromGit {
      # Cargo puts its data into $HOME/.cargo so we need to circumvent the homeless shelter.
      preBuild = "HOME=$PWD";
    });
  in nix;

in rec {

  nix = nixStable;

  nix1 = callPackage common rec {
    name = "nix-1.11.16";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "0ca5782fc37d62238d13a620a7b4bff6a200bab1bd63003709249a776162357c";
    };

    # Nix1 has the perl bindings by default, so no need to build the manually.
    includesPerl = true;

    inherit storeDir stateDir confDir boehmgc;
  };

  nixStable = callPackage common (rec {
    name = "nix-2.3.1";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "bb6578e9f20eebab6d78469ecc59c450ac54f276e5a86a882015d98fecb1bc7b";
    };

    inherit storeDir stateDir confDir boehmgc;
  } // stdenv.lib.optionalAttrs stdenv.cc.isClang {
    stdenv = llvmPackages_6.stdenv;
  });

  nixUnstable = lib.lowPrio (callPackage common rec {
    name = "nix-2.4${suffix}";
    suffix = "pre20191229_b0cadf5";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "b0cadf547bf2f796b550d7555b97761ff1d0a379";
      sha256 = "08zx7afglirsp5rh60kz1jvhgs838bzcq9b8r1h43gc2rp1dfs2q";
    };
    fromGit = true;

    inherit storeDir stateDir confDir boehmgc;
  });

  nixFlakes = lib.lowPrio (callPackage common rec {
    name = "nix-2.4${suffix}";
    suffix = "pre20191229_c786673";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "c7866733d7ce2836fbb43de90dd64d17b0d20753";
      sha256 = "0crpxrlfbzjsf0in9wyfarqw0lkkzgw4c560253f11jca5sac8y2";
    };
    fromGit = true;

    inherit storeDir stateDir confDir boehmgc;
  });

}
