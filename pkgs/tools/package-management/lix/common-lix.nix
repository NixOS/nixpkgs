{
  lib,
  suffix ? "",
  version,
  src,
  # For Lix versions >= 2.92, Rust sources are in the Lix repository root.
  cargoDeps ? null,
  # For previous versions, Rust sources are only in a subdirectory for
  # `lix-doc`.
  docCargoDeps ? null,
  patches ? [ ],
  knownVulnerabilities ? [ ],
}@args:

assert lib.assertMsg (
  lib.versionOlder version "2.92" -> docCargoDeps != null
) "`lix-doc` `cargoDeps` must be set for Lix < 2.92";
assert lib.assertMsg (
  lib.versionAtLeast version "2.92" -> cargoDeps != null
) "`cargoDeps` must be set for Lix ≥ 2.92";

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
  capnproto,
  cargo,
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
  libsystemtap,
  llvmPackages,
  lowdown,
  lowdown-unsandboxed,
  lsof,
  mercurial,
  mdbook,
  mdbook-linkcheck,
  nlohmann_json,
  ninja,
  openssl,
  pkgsStatic,
  rustc,
  toml11,
  pegtl,
  buildPackages,
  pkg-config,
  rapidcheck,
  sqlite,
  systemtap-sdt,
  util-linuxMinimal,
  removeReferencesTo,
  xz,
  yq,
  zstd,
  nixosTests,
  rustPlatform,
  # Only used for versions before 2.92.
  lix-doc ? callPackage ./doc {
    inherit src;
    version = "${version}${suffix}";
    cargoDeps = docCargoDeps;
  },

  enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableStrictLLVMChecks ? true,
  withAWS ?
    lib.meta.availableOn stdenv.hostPlatform aws-c-common
    && !enableStatic
    && (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin),
  aws-c-common,
  aws-sdk-cpp,
  # FIXME support Darwin once https://github.com/NixOS/nixpkgs/pull/392918 lands
  withDtrace ?
    lib.meta.availableOn stdenv.hostPlatform libsystemtap
    && lib.meta.availableOn stdenv.buildPlatform systemtap-sdt,
  # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
  withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp,
  libseccomp,
  pastaFod ? lib.meta.availableOn stdenv.hostPlatform passt,
  passt,

  confDir,
  stateDir,
  storeDir,
}:
let
  isLLVMOnly = lib.versionAtLeast version "2.92";
  hasExternalLixDoc = lib.versionOlder version "2.92";
  isLegacyParser = lib.versionOlder version "2.91";
  hasDtraceSupport = lib.versionAtLeast version "2.93";
  parseToYAML = lib.versionAtLeast version "2.93";
  usesCapnp = lib.versionAtLeast version "2.94";
in
# gcc miscompiles coroutines at least until 13.2, possibly longer
# do not remove this check unless you are sure you (or your users) will not report bugs to Lix upstream about GCC miscompilations.
assert lib.assertMsg (enableStrictLLVMChecks && isLLVMOnly -> stdenv.cc.isClang)
  "Lix upstream strongly discourage the usage of GCC to compile Lix as there's known miscompilations in important places. If you are a compiler developer, please get in touch with us.";
stdenv.mkDerivation (finalAttrs: {
  pname = "lix";

  version = "${version}${suffix}";
  VERSION_SUFFIX = suffix;

  inherit src patches;

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals enableDocumentation [
    "man"
    "doc"
    "devdoc"
  ];

  strictDeps = true;
  disallowedReferences = lib.optionals isLLVMOnly [
    # We don't want the Clang.
    stdenv.cc.cc
    # We don't want the underlying GCC neither!
    stdenv.cc.cc.stdenv.cc.cc
  ];
  __structuredAttrs = true;

  # We only include CMake so that Meson can locate toml11, which only ships CMake dependency metadata.
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    # python3.withPackages does not splice properly, see https://github.com/NixOS/nixpkgs/issues/305858
    (buildPackages.python3.withPackages (
      p:
      [ p.python-frontmatter ]
      ++ lib.optionals (lib.versionOlder version "2.94") [ p.toml ]
      ++ lib.optionals finalAttrs.doInstallCheck [
        p.aiohttp
        p.pytest
        p.pytest-xdist
      ]
      ++ lib.optionals usesCapnp [ p.pycapnp ]
    ))
    pkg-config
    flex
    jq
    meson
    ninja
    cmake
    # Required for libstd++ assertions that leaks inside of the final binary.
    removeReferencesTo

    # Tests
    git
    mercurial
    jq
    lsof
  ]
  ++ lib.optionals isLLVMOnly [
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals isLegacyParser [ bison ]
  ++ lib.optionals enableDocumentation [
    (lib.getBin lowdown-unsandboxed)
    mdbook
    mdbook-linkcheck
    doxygen
  ]
  ++ lib.optionals (hasDtraceSupport && withDtrace) [ systemtap-sdt ]
  ++ lib.optionals pastaFod [ passt ]
  ++ lib.optionals parseToYAML [ yq ]
  ++ lib.optionals usesCapnp [ capnproto ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ util-linuxMinimal ]
  ++ lib.optionals (lib.versionAtLeast version "2.94") [ zstd ];

  buildInputs = [
    boost
    brotli
    bzip2
    curl
    capnproto
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
  ]
  ++ lib.optionals hasExternalLixDoc [ lix-doc ]
  ++ lib.optionals (!isLegacyParser) [ pegtl ]
  ++ lib.optionals (lib.versionOlder version "2.94") [ libsodium ]
  # NOTE(Raito): I'd have expected that the LLVM packaging would inject the
  # libunwind library path directly in the wrappers, but it does inject
  # -lunwind without injecting the library path...
  ++ lib.optionals stdenv.hostPlatform.isStatic [ llvmPackages.libunwind ]
  ++ lib.optionals (stdenv.hostPlatform.isx86_64) [ libcpuid ]
  ++ lib.optionals withLibseccomp [ libseccomp ]
  ++ lib.optionals withAWS [ aws-sdk-cpp ]
  ++ lib.optionals (hasDtraceSupport && withDtrace) [ libsystemtap ];

  inherit cargoDeps;

  env = {
    # Meson allows referencing a /usr/share/cargo/registry shaped thing for subproject sources.
    # Turns out the Nix-generated Cargo dependencies are named the same as they
    # would be in a Cargo registry cache.
    MESON_PACKAGE_CACHE_DIR =
      if finalAttrs.cargoDeps != null then
        finalAttrs.cargoDeps
      else
        "lix: no `MESON_PACKAGE_CACHE_DIR`, set `cargoDeps`";
  };

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
    lib.optionalString (lib.versionOlder version "2.91" && !enableStatic) ''
      mkdir -p $out/lib
      cp -pd ${boost}/lib/{libboost_context*,libboost_thread*,libboost_system*} $out/lib
      rm -f $out/lib/*.a
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        chmod u+w $out/lib/*.so.*
        patchelf --set-rpath $out/lib:${lib.getLib stdenv.cc.cc}/lib $out/lib/libboost_thread.so.*
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

  mesonFlags = [
    # Enable LTO, since it improves eval performance a fair amount
    # LTO is disabled on:
    # - static builds (strange linkage errors)
    # - darwin builds (install test failures. see fj#568 & fj#832)
    (lib.mesonBool "b_lto" (
      !stdenv.hostPlatform.isStatic && !stdenv.hostPlatform.isDarwin && (isLLVMOnly || stdenv.cc.isGNU)
    ))
    (lib.mesonEnable "gc" true)
    (lib.mesonBool "enable-tests" true)
    (lib.mesonBool "enable-docs" enableDocumentation)
    (lib.mesonEnable "internal-api-docs" enableDocumentation)
    (lib.mesonBool "enable-embedded-sandbox-shell" (
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic
    ))
    (lib.mesonEnable "seccomp-sandboxing" withLibseccomp)

    (lib.mesonOption "store-dir" storeDir)
    (lib.mesonOption "state-dir" stateDir)
    (lib.mesonOption "sysconfdir" confDir)
  ]
  ++ lib.optionals hasDtraceSupport [
    (lib.mesonEnable "dtrace-probes" withDtrace)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.mesonOption "sandbox-shell" "${busybox-sandbox-shell}/bin/busybox")
  ]
  ++
    lib.optionals
      (stdenv.hostPlatform.isLinux && finalAttrs.doInstallCheck && lib.versionAtLeast version "2.94")
      [
        (lib.mesonOption "build-test-shell" "${pkgsStatic.busybox}/bin")
      ];

  ninjaFlags = [ "-v" ];

  postInstall =
    lib.optionalString enableDocumentation ''
      mkdir -p $doc/nix-support
      echo "doc manual $doc/share/doc/nix/manual" >> $doc/nix-support/hydra-build-products

      mkdir -p $devdoc/nix-support
      echo "devdoc internal-api $devdoc/share/doc/nix/internal-api" >> $devdoc/nix-support/hydra-build-products
    ''
    + lib.optionalString (lib.versionOlder version "2.94" && !hasExternalLixDoc) ''
      # We do not need static archives.
      rm $out/lib/liblix_doc.a
    ''
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      mkdir -p $out/nix-support
      echo "file binary-dist $out/bin/nix" >> $out/nix-support/hydra-build-products
    ''
    + lib.optionalString (lib.versionOlder version "2.91" && stdenv.hostPlatform.isDarwin) ''
      for lib in liblixutil.dylib liblixexpr.dylib; do
        install_name_tool \
          -change "${lib.getLib boost}/lib/libboost_context.dylib" \
          "$out/lib/libboost_context.dylib" \
          "$out/lib/$lib"
      done
    ''
    + ''
      # Drop all references to libstd++ include files due to `__FILE__` leaking in libstd++ assertions.
      find "$out" -type f -exec remove-references-to -t ${stdenv.cc.cc.stdenv.cc.cc} '{}' +
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

  separateDebugInfo = stdenv.hostPlatform.isLinux && !enableStatic;
  enableParallelBuilding = true;

  # Used by (1) test which has dynamic port assignment.
  __darwinAllowLocalNetworking = true;

  passthru = {
    inherit aws-sdk-cpp boehmgc;
    tests = {
      misc = nixosTests.nix-misc.default.passthru.override { nixPackage = finalAttrs.finalPackage; };
      installer = nixosTests.installer.simple.override { selectNixPackage = _: finalAttrs.finalPackage; };
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
    teams = [ lib.teams.lix ];
    platforms = lib.platforms.unix;
    outputsToInstall = [ "out" ] ++ lib.optional enableDocumentation "man";
    mainProgram = "nix";
    inherit knownVulnerabilities;
  };
})
