{
  lib,
  fetchFromGitHub,
  version,
  suffix ? "",
  hash ? null,
  src ? fetchFromGitHub {
    owner = "NixOS";
    repo = "nix";
    rev = version;
    inherit hash;
  },
  patches ? [ ],
  maintainers ? [
    lib.maintainers.artturin
    lib.maintainers.philiptaron
    lib.maintainers.lovesegfault
  ],
  teams ? [ lib.teams.nix ],
  self_attribute_name,
}@args:
assert (hash == null) -> (src != null);
{
  stdenv,
  bison,
  boehmgc,
  boost,
  brotli,
  busybox-sandbox-shell,
  bzip2,
  callPackage,
  cmake,
  curl,
  doxygen,
  editline,
  flex,
  git,
  gtest,
  jq,
  lib,
  libarchive,
  libblake3,
  libcpuid,
  libgit2,
  libsodium,
  lowdown,
  lowdown-unsandboxed,
  toml11,
  man,
  meson,
  ninja,
  mdbook,
  mdbook-linkcheck,
  nlohmann_json,
  nixosTests,
  openssl,
  perl,
  python3,
  pkg-config,
  rapidcheck,
  rsync,
  sqlite,
  util-linuxMinimal,
  xz,
  enableDocumentation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  enableStatic ? stdenv.hostPlatform.isStatic,
  withAWS ?
    lib.meta.availableOn stdenv.hostPlatform aws-c-common
    && !enableStatic
    && (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin),
  aws-c-common,
  aws-sdk-cpp,
  withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp,
  libseccomp,

  confDir,
  stateDir,
  storeDir,

  # passthru tests
  pkgsi686Linux,
  pkgsStatic,
  runCommand,
  pkgs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nix";

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
  ];

  hardeningEnable = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "pie" ];

  hardeningDisable = [
    "shadowstack"
  ]
  ++ lib.optional stdenv.hostPlatform.isMusl "fortify";

  nativeCheckInputs = [
    git
    man
  ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    jq
    meson
    ninja
    pkg-config
    rsync
  ]
  ++ lib.optionals enableDocumentation [
    (lib.getBin lowdown-unsandboxed)
    mdbook
    mdbook-linkcheck
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linuxMinimal
  ]
  ++ lib.optionals enableDocumentation [
    python3
    doxygen
  ];

  buildInputs = [
    boost
    brotli
    bzip2
    curl
    editline
    libgit2
    libsodium
    lowdown
    openssl
    sqlite
    toml11
    xz
  ]
  ++ lib.optionals (lib.versionAtLeast version "2.26") [
    libblake3
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    libcpuid
  ]
  ++ lib.optionals withLibseccomp [
    libseccomp
  ]
  ++ lib.optionals withAWS [
    aws-sdk-cpp
  ];

  propagatedBuildInputs = [
    boehmgc
    nlohmann_json
    libarchive
  ];

  checkInputs = [
    gtest
    rapidcheck
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
    '';

  dontUseCmakeConfigure = true;

  mesonFlags = [
    (lib.mesonBool "unit-tests" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
    (lib.mesonBool "bindings" false)
    (lib.mesonOption "libstore:store-dir" storeDir)
    (lib.mesonOption "libstore:localstatedir" stateDir)
    (lib.mesonOption "libstore:sysconfdir" confDir)
    (lib.mesonEnable "libutil:cpuid" stdenv.hostPlatform.isx86_64)
    (lib.mesonEnable "libstore:seccomp-sandboxing" withLibseccomp)
    (lib.mesonBool "libstore:embedded-sandbox-shell" (
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic
    ))
    (lib.mesonBool "doc-gen" enableDocumentation)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.mesonOption "libstore:sandbox-shell" "${busybox-sandbox-shell}/bin/busybox")
    # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
  ]
  ++ lib.optionals (stdenv.cc.isGNU && !enableStatic) [
    # TODO: do we still need this?
    # "--enable-lto"
  ];

  doCheck = true;

  # socket path becomes too long otherwise
  preInstallCheck =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      export TMPDIR=$NIX_BUILD_TOP
    ''
    # See https://github.com/NixOS/nix/issues/5687
    + lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
      echo "exit 0" > tests/functional/flakes/show.sh
    ''
    + ''
      # nixStatic otherwise does not find its man pages in tests.
      export MANPATH=$man/share/man:$MANPATH
    '';

  separateDebugInfo = stdenv.hostPlatform.isLinux && !enableStatic;

  passthru = {
    inherit aws-sdk-cpp boehmgc;

    # TODO:
    perl-bindings = perl.pkgs.toPerlModule (
      callPackage ./nix-perl.nix {
        nix = finalAttrs.finalPackage;
      }
    );

    tests = import ./tests.nix {
      inherit
        runCommand
        version
        src
        lib
        stdenv
        pkgs
        pkgsi686Linux
        pkgsStatic
        nixosTests
        self_attribute_name
        ;
      nix = finalAttrs.finalPackage;
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
    inherit maintainers teams;
    platforms = platforms.unix;
    # Gets stuck in functional-tests in cross-trunk jobset and doesn't timeout
    # https://hydra.nixos.org/build/298175022
    # probably https://github.com/NixOS/nix/issues/13042
    broken = stdenv.hostPlatform.system == "i686-linux" && stdenv.buildPlatform != stdenv.hostPlatform;
    outputsToInstall = [ "out" ] ++ optional enableDocumentation "man";
    mainProgram = "nix";
  };
})
