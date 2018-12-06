{ lib, stdenv, fetchurl, fetchFromGitHub, fetchpatch, perl, curl, bzip2, sqlite, openssl ? null, xz
, pkgconfig, boehmgc, perlPackages, libsodium, brotli, boost
, autoreconfHook, autoconf-archive, bison, flex, libxml2, libxslt, docbook5, docbook_xsl_ns
, busybox-sandbox-shell
, shellcheck, cacert, closureInfo, runCommand
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
, withLibseccomp ? libseccomp.meta.available, libseccomp
, withAWS ? stdenv.isLinux || stdenv.isDarwin, aws-sdk-cpp
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
      ++ lib.optionals is20 [ brotli boost ]
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
      lib.optionalString is20
      ''
        mkdir -p $out/lib
        cp ${boost}/lib/libboost_context* $out/lib
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

  binaryTarball = { nix }:
    let installerClosureInfo = closureInfo { rootPaths = [ nix cacert ]; }; in
    runCommand "nix-binary-tarball-${nix.version}"
      { nativeBuildInputs = lib.optional (stdenv.targetPlatform.system != "aarch64-linux") shellcheck;
        meta.description = "Distribution-independent Nix bootstrap binaries for ${stdenv.targetPlatform.system}";
      }
      ''
        cp ${installerClosureInfo}/registration $TMPDIR/reginfo
        substitute ${./scripts/install-nix-from-closure.sh} $TMPDIR/install \
          --subst-var-by nix ${nix} \
          --subst-var-by cacert ${cacert}

        substitute ${./scripts/install-darwin-multi-user.sh} $TMPDIR/install-darwin-multi-user.sh \
          --subst-var-by nix ${nix} \
          --subst-var-by cacert ${cacert}
        substitute ${./scripts/install-systemd-multi-user.sh} $TMPDIR/install-systemd-multi-user.sh \
          --subst-var-by nix ${nix} \
          --subst-var-by cacert ${cacert}
        substitute ${./scripts/install-multi-user.sh} $TMPDIR/install-multi-user \
          --subst-var-by nix ${nix} \
          --subst-var-by cacert ${cacert}

        if type -p shellcheck; then
          # SC1090: Don't worry about not being able to find
          #         $nix/etc/profile.d/nix.sh
          shellcheck --exclude SC1090 $TMPDIR/install
          shellcheck $TMPDIR/install-darwin-multi-user.sh
          shellcheck $TMPDIR/install-systemd-multi-user.sh

          # SC1091: Don't panic about not being able to source
          #         /etc/profile
          # SC2002: Ignore "useless cat" "error", when loading
          #         .reginfo, as the cat is a much cleaner
          #         implementation, even though it is "useless"
          # SC2116: Allow ROOT_HOME=$(echo ~root) for resolving
          #         root's home directory
          shellcheck --external-sources \
            --exclude SC1091,SC2002,SC2116 $TMPDIR/install-multi-user
        fi

        chmod +x $TMPDIR/install
        chmod +x $TMPDIR/install-darwin-multi-user.sh
        chmod +x $TMPDIR/install-systemd-multi-user.sh
        chmod +x $TMPDIR/install-multi-user
        dir=nix-${nix.version}-${stdenv.targetPlatform.system}
        fn=$out/$dir.tar.bz2
        mkdir -p $out/nix-support
        echo "file binary-dist $fn" >> $out/nix-support/hydra-build-products
        tar cvfj $fn \
          --owner=0 --group=0 --mode=u+rw,uga+r \
          --absolute-names \
          --hard-dereference \
          --transform "s,$TMPDIR/install,$dir/install," \
          --transform "s,$TMPDIR/reginfo,$dir/.reginfo," \
          --transform "s,$NIX_STORE,$dir/store,S" \
          $TMPDIR/install $TMPDIR/install-darwin-multi-user.sh \
          $TMPDIR/install-systemd-multi-user.sh \
          $TMPDIR/install-multi-user $TMPDIR/reginfo \
          $(cat ${installerClosureInfo}/store-paths)
      '';

in rec {

  nix = nixStable;

  nix1 = (common rec {
    name = "nix-1.11.16";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "0ca5782fc37d62238d13a620a7b4bff6a200bab1bd63003709249a776162357c";
    };
  }) // { perl-bindings = nix1; }
  // { binaryTarball = binaryTarball {
    nix = nix1;
  }; };

  nixStable = (common rec {
    name = "nix-2.1.1";
    src = fetchurl {
      url = "http://nixos.org/releases/nix/${name}/${name}.tar.xz";
      sha256 = "63b1d49ea678162ada6996e42abb62cbc6e65cfefa4faa5436ae37100504720b";
    };
  }) // { perl-bindings = perl-bindings {
    nix = nixStable;
    needsBoost = true;
  }; } // { binaryTarball = binaryTarball {
    nix = nixStable;
  }; };

  nixUnstable = (lib.lowPrio (common rec {
    name = "nix-2.1${suffix}";
    suffix = "pre6377_954d1f4d";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "954d1f4d0a35063ff431b258beebadf753cb9efe";
      sha256 = "0wnljxljvcwmniydgxlsjqmbgghmljs75m6083y2nkjql7dnrm7g";
    };
    fromGit = true;
  })) // { perl-bindings = perl-bindings {
    nix = nixUnstable;
    needsBoost = true;
  }; } // { binaryTarball = binaryTarball {
    nix = nixUnstable;
  }; };

}
