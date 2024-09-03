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
  docCargoLock ? null,
  patches ? [ ],
  maintainers ? lib.teams.lix.members,
}@args:
assert (hash == null) -> (src != null);
{
  stdenv,
  meson,
  bison,
  boehmgc,
  boost,
  brotli,
  busybox-sandbox-shell,
  bzip2,
  callPackage,
  curl,
  cmake,
  doxygen,
  editline,
  flex,
  git,
  gtest,
  jq,
  lib,
  libarchive,
  libcpuid,
  libsodium,
  lowdown,
  lsof,
  mercurial,
  mdbook,
  mdbook-linkcheck,
  nlohmann_json,
  ninja,
  openssl,
  toml11,
  pegtl,
  python3,
  pkg-config,
  rapidcheck,
  Security,
  sqlite,
  util-linuxMinimal,
  xz,
  nixosTests,
  lix-doc ? callPackage ./doc {
    inherit src;
    version = "${version}${suffix}";
    cargoHash = docCargoHash;
    cargoLock = docCargoLock;
  },

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
assert lib.assertMsg (docCargoHash != null || docCargoLock != null)
  "Either `lix-doc`'s cargoHash using `docCargoHash` or `lix-doc`'s `cargoLock.lockFile` using `docCargoLock` must be set!";
let
  isLegacyParser = lib.versionOlder version "2.91";
in
stdenv.mkDerivation {
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
      "devdoc"
    ];

  strictDeps = true;

  nativeBuildInputs =
    [
      pkg-config
      flex
      jq
      meson
      ninja
      cmake
      python3

      # Tests
      git
      mercurial
      jq
      lsof
    ]
    ++ lib.optionals isLegacyParser [ bison ]
    ++ lib.optionals enableDocumentation [
      (lib.getBin lowdown)
      mdbook
      mdbook-linkcheck
      doxygen
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
    ++ lib.optionals (!isLegacyParser) [ pegtl ]
    ++ lib.optionals stdenv.isDarwin [ Security ]
    ++ lib.optionals (stdenv.isx86_64) [ libcpuid ]
    ++ lib.optionals withLibseccomp [ libseccomp ]
    ++ lib.optionals withAWS [ aws-sdk-cpp ];

  propagatedBuildInputs = [
    boehmgc
    nlohmann_json
  ];

  postPatch = ''
    patchShebangs --build tests doc/manual
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

  # -O3 seems to anger a gcc bug and provide no performance benefit.
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=114360
  # We use -O2 upstream https://gerrit.lix.systems/c/lix/+/554
  mesonBuildType = "debugoptimized";

  mesonFlags =
    [
      # Enable LTO, since it improves eval performance a fair amount
      # LTO is disabled on static due to strange linking errors
      (lib.mesonBool "b_lto" (!stdenv.hostPlatform.isStatic))
      (lib.mesonEnable "gc" true)
      (lib.mesonBool "enable-tests" true)
      (lib.mesonBool "enable-docs" enableDocumentation)
      (lib.mesonEnable "internal-api-docs" enableDocumentation)
      (lib.mesonBool "enable-embedded-sandbox-shell" (stdenv.isLinux && stdenv.hostPlatform.isStatic))
      (lib.mesonEnable "seccomp-sandboxing" withLibseccomp)

      (lib.mesonOption "store-dir" storeDir)
      (lib.mesonOption "state-dir" stateDir)
      (lib.mesonOption "sysconfdir" confDir)
    ]
    ++ lib.optionals stdenv.isLinux [
      (lib.mesonOption "sandbox-shell" "${busybox-sandbox-shell}/bin/busybox")
    ];

  ninjaFlags = [ "-v" ];

  postInstall =
    lib.optionalString enableDocumentation ''
      mkdir -p $doc/nix-support
      echo "doc manual $doc/share/doc/nix/manual" >> $doc/nix-support/hydra-build-products

      mkdir -p $devdoc/nix-support
      echo "devdoc internal-api $devdoc/share/doc/nix/internal-api" >> $devdoc/nix-support/hydra-build-products
    ''
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      mkdir -p $out/nix-support
      echo "file binary-dist $out/bin/nix" >> $out/nix-support/hydra-build-products
    ''
    + lib.optionalString stdenv.isDarwin ''
      for lib in liblixutil.dylib liblixexpr.dylib; do
        install_name_tool \
          -change "${lib.getLib boost}/lib/libboost_context.dylib" \
          "$out/lib/libboost_context.dylib" \
          "$out/lib/$lib"
      done
    '';

  # This needs to run after _multioutDocs moves the docs to $doc
  postFixup = lib.optionalString enableDocumentation ''
    mkdir -p $devdoc/share/doc/nix
    mv $doc/share/doc/nix/internal-api $devdoc/share/doc/nix
  '';

  doCheck = true;
  mesonCheckFlags = [
    "--suite=check"
    "--print-errorlogs"
  ];
  checkInputs = [
    gtest
    rapidcheck
  ];

  doInstallCheck = true;
  mesonInstallCheckFlags = [
    "--suite=installcheck"
    "--print-errorlogs"
  ];

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
  hardeningDisable = [
    "shadowstack"
    # strictoverflow is disabled because we trap on signed overflow instead
    "strictoverflow"
  ]
  # fortify breaks the build with lto and musl for some reason
  ++ lib.optional stdenv.hostPlatform.isMusl "fortify";

  # hardeningEnable = lib.optionals (!stdenv.isDarwin) [ "pie" ];
  separateDebugInfo = stdenv.isLinux && !enableStatic;
  enableParallelBuilding = true;

  # Used by (1) test which has dynamic port assignment.
  __darwinAllowLocalNetworking = true;

  passthru = {
    inherit aws-sdk-cpp boehmgc;
    tests = {
      misc = nixosTests.nix-misc.lix;
    };
  };

  # point 'nix edit' and ofborg at the file that defines the attribute,
  # not this common file.
  pos = builtins.unsafeGetAttrPos "version" args;
  meta = {
    description = "Powerful package manager that makes package management reliable and reproducible";
    longDescription = ''
      Lix (a fork of Nix) is a powerful package manager for Linux and other Unix systems that
      makes package management reliable and reproducible. It provides atomic
      upgrades and rollbacks, side-by-side installation of multiple versions of
      a package, multi-user package management and easy setup of build
      environments.
    '';
    homepage = "https://lix.systems";
    license = lib.licenses.lgpl21Plus;
    inherit maintainers;
    platforms = lib.platforms.unix;
    outputsToInstall = [ "out" ] ++ lib.optional enableDocumentation "man";
    mainProgram = "nix";
  };
}
