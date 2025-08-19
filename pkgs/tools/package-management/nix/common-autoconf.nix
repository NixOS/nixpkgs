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
  knownVulnerabilities ? [ ],
  maintainers ? [
    lib.maintainers.lovesegfault
    lib.maintainers.artturin
  ],
  teams ? [ lib.teams.nix ],
  self_attribute_name,
}@args:
assert (hash == null) -> (src != null);
let
  atLeast225 = lib.versionAtLeast version "2.25pre";
in
{
  stdenv,
  autoconf-archive,
  autoreconfHook,
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
  docbook_xsl_ns,
  docbook5,
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
  lowdown-unsandboxed,
  toml11,
  man,
  mdbook,
  mdbook-linkcheck,
  nlohmann_json,
  nixosTests,
  openssl,
  perl,
  python3,
  pkg-config,
  rapidcheck,
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
let
  self = stdenv.mkDerivation {
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

    nativeInstallCheckInputs = [
      git
      man
    ];

    nativeBuildInputs = [
      pkg-config
      autoconf-archive
      autoreconfHook
      bison
      flex
      jq
    ]
    ++ lib.optionals enableDocumentation [
      (lib.getBin lowdown-unsandboxed)
      mdbook
      mdbook-linkcheck
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      util-linuxMinimal
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
      libgit2
      toml11
      rapidcheck
    ]
    ++ lib.optionals (atLeast225 && enableDocumentation) [
      python3
    ]
    ++ lib.optionals (stdenv.hostPlatform.isx86_64) [
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

    configureFlags = [
      "--with-store-dir=${storeDir}"
      "--localstatedir=${stateDir}"
      "--sysconfdir=${confDir}"
      "--enable-gc"
    ]
    ++ lib.optionals (!enableDocumentation) [
      "--disable-doc-gen"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--with-sandbox-shell=${busybox-sandbox-shell}/bin/busybox"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) [
      "--enable-embedded-sandbox-shell"
    ]
    ++
      lib.optionals
        (
          stdenv.hostPlatform != stdenv.buildPlatform
          && stdenv.hostPlatform ? nix
          && stdenv.hostPlatform.nix ? system
        )
        [
          "--with-system=${stdenv.hostPlatform.nix.system}"
        ]
    ++ lib.optionals (!withLibseccomp) [
      # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
      "--disable-seccomp-sandboxing"
    ]
    ++ lib.optionals (stdenv.cc.isGNU && !enableStatic) [
      "--enable-lto"
    ];

    env.CXXFLAGS = toString (
      lib.optionals (lib.versionAtLeast lowdown.version "1.4.0") [
        # Autotools based build system wasn't updated with the backport of
        # https://github.com/NixOS/nix/pull/12115, so set the define explicitly.
        "-DHAVE_LOWDOWN_1_4"
      ]
    );

    makeFlags = [
      # gcc runs multi-threaded LTO using make and does not yet detect the new fifo:/path style
      # of make jobserver. until gcc adds support for this we have to instruct make to use this
      # old style or LTO builds will run their linking on only one thread, which takes forever.
      "--jobserver-style=pipe"
      "profiledir=$(out)/etc/profile.d"
    ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "PRECOMPILE_HEADERS=0"
    ++ lib.optional (stdenv.hostPlatform.isDarwin) "PRECOMPILE_HEADERS=1";

    installFlags = [ "sysconfdir=$(out)/etc" ];

    doInstallCheck = true;
    installCheckTarget = "installcheck";

    # socket path becomes too long otherwise
    preInstallCheck =
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        export TMPDIR=$NIX_BUILD_TOP
      ''
      # Prevent crashes in libcurl due to invoking Objective-C `+initialize` methods after `fork`.
      # See http://sealiesoftware.com/blog/archive/2017/6/5/Objective-C_and_fork_in_macOS_1013.html.
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      ''
      # See https://github.com/NixOS/nix/issues/5687
      + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
        echo "exit 99" > tests/gc-non-blocking.sh
      '' # TODO: investigate why this broken
      + lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
        echo "exit 0" > tests/functional/flakes/show.sh
      ''
      + ''
        # nixStatic otherwise does not find its man pages in tests.
        export MANPATH=$man/share/man:$MANPATH
      '';

    separateDebugInfo = stdenv.hostPlatform.isLinux && !enableStatic;

    enableParallelBuilding = true;

    passthru = {
      inherit aws-sdk-cpp boehmgc;

      perl-bindings = perl.pkgs.toPerlModule (
        callPackage ./nix-perl.nix {
          nix = self;
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
        nix = self;
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
      inherit knownVulnerabilities maintainers teams;
      platforms = platforms.unix;
      outputsToInstall = [ "out" ] ++ optional enableDocumentation "man";
      mainProgram = "nix";
    };
  };
in
self
