{
  lib,
  fetchFromGitHub,
  version,
  suffix ? "",
  hash ? null,
  src ? fetchFromGitHub {
    owner = "lix-project";
    repo = "lix";
    rev = version;
    inherit hash;
  },
  docCargoHash ? null,
  patches ? [ ],
  maintainers ? lib.teams.lix.members,
}@args:
assert (hash == null) -> (src != null);
{
  stdenv,
  meson,
  bash,
  bison,
  boehmgc,
  boost,
  brotli,
  busybox-sandbox-shell,
  bzip2,
  callPackage,
  coreutils,
  curl,
  cmake,
  docbook_xsl_ns,
  docbook5,
  doxygen,
  editline,
  flex,
  git,
  gnutar,
  gtest,
  gzip,
  jq,
  lib,
  libarchive,
  libcpuid,
  libgit2,
  libsodium,
  libxml2,
  libxslt,
  lowdown,
  lsof,
  man,
  mercurial,
  mdbook,
  mdbook-linkcheck,
  nlohmann_json,
  ninja,
  openssl,
  toml11,
  python3,
  perl,
  pkg-config,
  rapidcheck,
  Security,
  sqlite,
  util-linuxMinimal,
  xz,
  nixosTests,

  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  enableStatic ? stdenv.hostPlatform.isStatic,
  withAWS ? !enableStatic && (stdenv.isLinux || stdenv.isDarwin),
  aws-sdk-cpp,
  # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
  withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp,
  libseccomp,

  confDir,
  stateDir,
  storeDir,
}:
let
  lix-doc = callPackage ./doc {
    inherit src;
    version = "${version}${suffix}";
    cargoHash = docCargoHash;
  };
  self = stdenv.mkDerivation {
    pname = "lix";

    version = "${version}${suffix}";
    VERSION_SUFFIX = suffix;

    inherit src patches;

    outputs =
      [
        "out"
        "dev"
      ]
      ++ lib.optionals enableDocumentation [
        "man"
        "doc"
      ];

    strictDeps = true;

    nativeBuildInputs =
      [
        pkg-config
        bison
        flex
        jq
        meson
        ninja
        cmake
        python3
        doxygen

        # Tests
        git
        mercurial
        jq
        lsof
      ]
      ++ lib.optionals (enableDocumentation) [
        (lib.getBin lowdown)
        mdbook
        mdbook-linkcheck
      ]
      ++ lib.optionals stdenv.isLinux [ util-linuxMinimal ];

    buildInputs =
      [
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
        rapidcheck
        toml11
        lix-doc
      ]
      ++ lib.optionals stdenv.isDarwin [ Security ]
      ++ lib.optionals (stdenv.isx86_64) [ libcpuid ]
      ++ lib.optionals withLibseccomp [ libseccomp ]
      ++ lib.optionals withAWS [ aws-sdk-cpp ];

    propagatedBuildInputs = [
      boehmgc
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
        ${lib.optionalString stdenv.isLinux ''
          chmod u+w $out/lib/*.so.*
          patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib $out/lib/libboost_thread.so.*
        ''}
        ${lib.optionalString stdenv.hostPlatform.isDarwin ''
          for LIB in $out/lib/*.dylib; do
            chmod u+w $LIB
            install_name_tool -id $LIB $LIB
            install_name_tool -delete_rpath ${boost}/lib/ $LIB || true
          done
          install_name_tool -change ${boost}/lib/libboost_system.dylib $out/lib/libboost_system.dylib $out/lib/libboost_thread.dylib
        ''}
      '';

    mesonBuildType = "release";
    mesonFlags =
      [
        # LTO optimization
        (lib.mesonBool "b_lto" (!stdenv.isDarwin))
        (lib.mesonEnable "gc" true)
        (lib.mesonBool "enable-tests" true)
        (lib.mesonBool "enable-docs" enableDocumentation)
        (lib.mesonBool "enable-embedded-sandbox-shell" (stdenv.isLinux && stdenv.hostPlatform.isStatic))
        (lib.mesonEnable "seccomp-sandboxing" withLibseccomp)

        (lib.mesonOption "store-dir" storeDir)
        (lib.mesonOption "state-dir" stateDir)
        (lib.mesonOption "sysconfdir" confDir)
      ]
      ++ lib.optionals stdenv.isLinux [
        (lib.mesonOption "sandbox-shell" "${busybox-sandbox-shell}/bin/busybox")
      ];

    # Needed for Meson to find Boost.
    # https://github.com/NixOS/nixpkgs/issues/86131.
    env = {
      BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
      BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
    };

    postInstall =
      ''
        mkdir -p $doc/nix-support
        echo "doc manual $doc/share/doc/nix/manual" >> $doc/nix-support/hydra-build-products
      ''
      + lib.optionalString stdenv.hostPlatform.isStatic ''
        mkdir -p $out/nix-support
        echo "file binary-dist $out/bin/nix" >> $out/nix-support/hydra-build-products
      ''
      + lib.optionalString stdenv.isDarwin ''
        for lib in libnixutil.dylib libnixexpr.dylib; do
          install_name_tool \
            -change "${lib.getLib boost}/lib/libboost_context.dylib" \
            "$out/lib/libboost_context.dylib" \
            "$out/lib/$lib"
        done
      '';

    doCheck = true;
    mesonCheckFlags = [ "--suite=check" ];
    checkInputs = [
      gtest
      rapidcheck
    ];

    doInstallCheck = true;
    mesonInstallCheckFlags = [ "--suite=installcheck" ];

    preInstallCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
      # socket path becomes too long otherwise
      export TMPDIR=$NIX_BUILD_TOP
      # Prevent crashes in libcurl due to invoking Objective-C `+initialize` methods after `fork`.
      # See http://sealiesoftware.com/blog/archive/2017/6/5/Objective-C_and_fork_in_macOS_1013.html.
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    '';

    installCheckPhase = ''
      runHook preInstallCheck
      flagsArray=($mesonInstallCheckFlags "''${mesonInstallCheckFlagsArray[@]}")
      meson test --no-rebuild "''${flagsArray[@]}"
      runHook postInstallCheck
    '';
    # strictoverflow is disabled because we trap on signed overflow instead
    hardeningDisable = [ "strictoverflow" ] ++ lib.optional stdenv.hostPlatform.isStatic "pie";
    # hardeningEnable = lib.optionals (!stdenv.isDarwin) [ "pie" ];
    # hardeningDisable = lib.optional stdenv.hostPlatform.isMusl "fortify";
    separateDebugInfo = stdenv.isLinux && !enableStatic;
    enableParallelBuilding = true;

    passthru = {
      inherit aws-sdk-cpp boehmgc;
      tests = {
        misc = nixosTests.nix-misc.lix;
      };
    };

    # point 'nix edit' and ofborg at the file that defines the attribute,
    # not this common file.
    pos = builtins.unsafeGetAttrPos "version" args;
    meta = with lib; {
      description = "Powerful package manager that makes package management reliable and reproducible";
      longDescription = ''
        Lix (a fork of Nix) is a powerful package manager for Linux and other Unix systems that
        makes package management reliable and reproducible. It provides atomic
        upgrades and rollbacks, side-by-side installation of multiple versions of
        a package, multi-user package management and easy setup of build
        environments.
      '';
      homepage = "https://lix.systems";
      license = licenses.lgpl21Plus;
      inherit maintainers;
      platforms = platforms.unix;
      outputsToInstall = [ "out" ] ++ optional enableDocumentation "man";
      mainProgram = "nix";
      broken = enableStatic;
    };
  };
in
self
