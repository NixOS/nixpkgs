{ lib
, fetchFromGitHub
, version
, suffix ? ""
, hash ? null
, src ? fetchFromGitHub { owner = "NixOS"; repo = "nix"; rev = version; inherit hash; }
, patches ? [ ]
, maintainers ? with lib.maintainers; [ eelco lovesegfault artturin ]
, self_attribute_name
}@args:
assert (hash == null) -> (src != null);
let
  atLeast224 = lib.versionAtLeast version "2.24pre";
  atLeast225 = lib.versionAtLeast version "2.25pre";
  atLeast226 = lib.versionAtLeast version "2.26pre";
in
{ stdenv
, Security
, autoconf-archive
, autoreconfHook
, bash
, bison
, boehmgc
, boost
, brotli
, busybox-sandbox-shell
, bzip2
, callPackage
, cmake
, coreutils
, curl
, darwin
, docbook5
, docbook_xsl_ns
, doxygen
, editline
, flex
, git
, gnutar
, gtest
, gzip
, jq
, lib
, libarchive
, libcpuid
, libgit2
, libsodium
, libxml2
, libxslt
, lowdown
, lowdown-unsandboxed
, man
, mdbook
, mdbook-linkcheck
, meson
, ninja
, nixosTests
, nlohmann_json
, openssl
, perl
, perlPackages
, pkg-config
, python3
, rapidcheck
, rsync
, sqlite
, toml11
, util-linuxMinimal
, xz
, enableDocumentation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, enableStatic ? stdenv.hostPlatform.isStatic
, withAWS ? !enableStatic && (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin), aws-sdk-cpp
, withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp, libseccomp

, confDir
, stateDir
, storeDir

  # passthru tests
, pkgsi686Linux
, pkgsStatic
, runCommand
, pkgs
}: let
self = stdenv.mkDerivation (finalAttrs: {
  pname = "nix";

  version = "${version}${suffix}";
  VERSION_SUFFIX = suffix;

  inherit src patches;

  outputs =
    [ "out" "dev" ]
    ++ lib.optionals enableDocumentation [ "man" "doc" ];

  hardeningEnable = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "pie" ];

  hardeningDisable = [
    "shadowstack"
  ] ++ lib.optional stdenv.hostPlatform.isMusl "fortify";

  nativeBuildInputs = [
    pkg-config
    bison
    flex
    jq
  ]
  ++ lib.optionals (enableDocumentation && atLeast226) [
    doxygen
    rsync
  ]
  ++ lib.optionals (enableDocumentation && atLeast225) [
    python3
  ]
  ++ lib.optionals (enableDocumentation && atLeast224) [
    (lib.getBin lowdown-unsandboxed)
    mdbook
    mdbook-linkcheck
  ]
  ++ lib.optionals (enableDocumentation && !atLeast224) [
    libxslt
    libxml2
    docbook_xsl_ns
    docbook5
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linuxMinimal
  ]
  ++ lib.optionals (!atLeast226) [
    autoconf-archive
    autoreconfHook
  ]
  ++ lib.optionals atLeast226 [
    meson
    ninja
    cmake
    perl
    perlPackages.DBDSQLite
    perlPackages.DBI
  ];

  buildInputs = [
    boost
    brotli
    bzip2
    curl
    editline
    libsodium
    openssl
    sqlite
    xz
    gtest
    libarchive
    lowdown
  ] ++ lib.optionals atLeast224 [
    libgit2
    toml11
    rapidcheck
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ] ++ lib.optionals (stdenv.hostPlatform.isx86_64) [
    libcpuid
  ] ++ lib.optionals withLibseccomp [
    libseccomp
  ] ++ lib.optionals withAWS [
    aws-sdk-cpp
  ] ++ lib.optional (atLeast224 && stdenv.hostPlatform.isDarwin) [
    darwin.apple_sdk.libs.sandbox
  ];

  propagatedBuildInputs = [
    boehmgc
  ] ++ lib.optionals atLeast224 [
    nlohmann_json
  ];

  postPatch = ''
    patchShebangs --build tests
  '';

  preConfigure =
    # Copy libboost_context so we don't get all of Boost in our closure.
    # https://github.com/NixOS/nixpkgs/issues/45462
    lib.optionalString (!enableStatic) ''
      mkdir -p $out/lib
      cp -pd ${boost}/lib/{libboost_context*,libboost_thread*,libboost_system*} $out/lib
      rm -f $out/lib/*.a
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        chmod u+w $out/lib/*.so.*
        patchelf --set-rpath $out/lib:${lib.getLib stdenv.cc.cc}/lib $out/lib/libboost_thread.so.*
      ''}
    '' +
    # On all versions before c9f51e87057652db0013289a95deffba495b35e7, which
    # removes config.nix entirely and is not present in 2.3.x, we need to
    # patch around an issue where the Nix configure step pulls in the build
    # system's bash and other utilities when cross-compiling.
    lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform && !atLeast224) ''
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
    '' +
    # https://github.com/NixOS/nix/blob/442a2623e48357ff72c77bb11cf2cf06d94d2f90/packaging/dependencies.nix#L69-L83
    lib.optionalString atLeast226 ''
      case "$mesonBuildType" in
      release|minsize) appendToVar mesonFlags "-Db_lto=true"  ;;
      *)               appendToVar mesonFlags "-Db_lto=false" ;;
      esac
    '';

  configureFlags = [
    "--with-store-dir=${storeDir}"
    "--localstatedir=${stateDir}"
    "--sysconfdir=${confDir}"
    "--enable-gc"
  ] ++ lib.optionals (!enableDocumentation) [
    "--disable-doc-gen"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--with-sandbox-shell=${busybox-sandbox-shell}/bin/busybox"
  ] ++ lib.optionals (atLeast224 && stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) [
    "--enable-embedded-sandbox-shell"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system) [
    "--with-system=${stdenv.hostPlatform.nix.system}"
  ] ++ lib.optionals (!withLibseccomp) [
    # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
    "--disable-seccomp-sandboxing"
  ] ++ lib.optionals (atLeast224 && stdenv.cc.isGNU && !enableStatic) [
    "--enable-lto"
  ];

  makeFlags = [
    # gcc runs multi-threaded LTO using make and does not yet detect the new fifo:/path style
    # of make jobserver. until gcc adds support for this we have to instruct make to use this
    # old style or LTO builds will run their linking on only one thread, which takes forever.
    "--jobserver-style=pipe"
    "profiledir=$(out)/etc/profile.d"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "PRECOMPILE_HEADERS=0"
    ++ lib.optional (stdenv.hostPlatform.isDarwin) "PRECOMPILE_HEADERS=1";

  mesonBuildType = "release";
  mesonFlags = lib.optionals atLeast226 [
    (lib.mesonBool "doc-gen" enableDocumentation)
    (lib.mesonEnable "tests:perl" (finalAttrs.doCheck && !stdenv.isDarwin))
    (lib.mesonEnable "cpuid:nix-util" stdenv.hostPlatform.isx86_64)
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.mesonOption "sandbox-shell:nix-store" "${busybox-sandbox-shell}/bin/busybox")
  ];
  mesonCheckFlags = [ "--print-errorlogs" ];

  installFlags = [ "sysconfdir=$(out)/etc" ];

  doCheck = atLeast226;
  nativeCheckInputs =
    finalAttrs.nativeInstallCheckInputs
    ++ lib.optionals (atLeast226 && !stdenv.isDarwin) [
      perlPackages.Test2Harness
    ];
  preCheck = finalAttrs.preInstallCheck;

  doInstallCheck = !atLeast226;
  installCheckTarget = if atLeast224 then "installcheck" else null;
  nativeInstallCheckInputs = lib.optionals atLeast224 [ git man ];

  # socket path becomes too long otherwise
  preInstallCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export TMPDIR=$NIX_BUILD_TOP
  ''
  # Prevent crashes in libcurl due to invoking Objective-C `+initialize` methods after `fork`.
  # See http://sealiesoftware.com/blog/archive/2017/6/5/Objective-C_and_fork_in_macOS_1013.html.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
  ''
  # See https://github.com/NixOS/nix/issues/5687
  + lib.optionalString (atLeast224 && stdenv.hostPlatform.isDarwin) ''
    echo "exit 99" > tests/gc-non-blocking.sh
  '' # TODO: investigate why this broken
  + lib.optionalString (atLeast224 && stdenv.hostPlatform.system == "aarch64-linux") ''
    echo "exit 0" > tests/functional/flakes/show.sh
  ''
  + ''
    # nixStatic otherwise does not find its man pages in tests.
    export MANPATH=$man/share/man:$MANPATH
  '';

  separateDebugInfo = stdenv.hostPlatform.isLinux && (atLeast224 -> !enableStatic);

  enableParallelBuilding = true;

  passthru = {
    inherit aws-sdk-cpp boehmgc;

    perl-bindings = perl.pkgs.toPerlModule (callPackage ./nix-perl.nix { nix = self; inherit Security; });

    tests = {
      srcVersion = runCommand "nix-src-version" {
        inherit version;
      } ''
        # This file is an implementation detail, but it's a good sanity check
        # If upstream changes that, we'll have to adapt.
        srcVersion=$(cat ${src}/.version)
        echo "Version in nix nix expression: $version"
        echo "Version in nix.src: $srcVersion"
        if [ "$version" != "$srcVersion" ]; then
          echo "Version mismatch!"
          exit 1
        fi
        touch $out
      '';

      /** Intended to test `lib`, but also a good smoke test for Nix */
      nixpkgs-lib = import ../../../../lib/tests/test-with-nix.nix {
        inherit lib pkgs;
        nix = self;
      };
    } // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      nixStatic = pkgsStatic.nixVersions.${self_attribute_name};

      # Basic smoke tests that needs to pass when upgrading nix.
      # Note that this test does only test the nixVersions.stable attribute.
      misc = nixosTests.nix-misc.default;
      upgrade = nixosTests.nix-upgrade;
      simpleUefiSystemdBoot = nixosTests.installer.simpleUefiSystemdBoot;
    } // lib.optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
      nixi686 = pkgsi686Linux.nixVersions.${self_attribute_name};
    };
  };

  # point 'nix edit' and ofborg at the file that defines the attribute,
  # not this common file.
  pos = builtins.unsafeGetAttrPos "version" args;
  meta = with lib; {
    description = "Powerful package manager that makes package management reliable and reproducible";
    longDescription = ''
      Nix is a powerful package manager for Linux and other Unix systems that
      makes package management reliable and reproducible. It provides atomic
      upgrades and rollbacks, side-by-side installation of multiple versions of
      a package, multi-user package management and easy setup of build
      environments.
    '';
    homepage = "https://nixos.org/";
    license = licenses.lgpl21Plus;
    inherit maintainers;
    platforms = platforms.unix;
    outputsToInstall = [ "out" ] ++ optional enableDocumentation "man";
    mainProgram = "nix";
  };
});
in self
