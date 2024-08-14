{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  writeScript,
  runCommand,
  buildPackages,
  testers,
  fetchpatch2,

  python3,
  python311, # for Node.js v18

  unixtools,
  ninja,
  pkgconf,
  installShellFiles,

  darwin,
  openssl,
  zlib,
  libuv,
  icu,
  bash,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

  # Currently stdenv sets CC/LD/AR/etc environment variables to program names
  # instead of absolute paths. If we add cctools to nativeBuildInputs, that
  # would shadow stdenv’s bintools and potentially break other parts of the
  # build. The correct behavior is to use absolute paths, and there is a PR for
  # that, see https://github.com/NixOS/nixpkgs/pull/314920. As a temporary
  # workaround, we use only a single program we need (and that is not part of
  # the stdenv).
  darwin-cctools-only-libtool =
    # Would be nice to have onlyExe builder similar to onlyBin…
    runCommand "darwin-cctools-only-libtool" { cctools = lib.getBin buildPackages.cctools; } ''
      mkdir -p "$out/bin"
      ln -s "$cctools/bin/libtool" "$out/bin/libtool"
    '';

  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  emulator = stdenv.hostPlatform.emulator buildPackages;

  # See valid_os and valid_arch in configure.py.
  destOS =
    let
      platform = stdenv.hostPlatform;
    in
    if platform.isiOS then
      "ios"
    else if platform.isAndroid then
      "android"
    else if platform.isWindows then
      "win"
    else if platform.isDarwin then
      "mac"
    else if platform.isLinux then
      "linux"
    else if platform.isOpenBSD then
      "openbsd"
    else if platform.isFreeBSD then
      "freebsd"
    else
      throw "unsupported os ${platform.uname.system}";
  destCPU =
    let
      platform = stdenv.hostPlatform;
    in
    if platform.isAarch then
      "arm" + lib.optionalString platform.is64bit "64"
    else if platform.isMips32 then
      "mips" + lib.optionalString platform.isLittleEndian "le"
    else if platform.isMips64 && platform.isLittleEndian then
      "mips64el"
    else if platform.isPower then
      "ppc" + lib.optionalString platform.is64bit "64"
    else if platform.isx86_64 then
      "x64"
    else if platform.isx86_32 then
      "ia32"
    else if platform.isS390x then
      "s390x"
    else if platform.isRiscV64 then
      "riscv64"
    else if platform.isLoongArch64 then
      "loong64"
    else
      throw "unsupported cpu ${platform.uname.processor}";
  destARMFPU =
    let
      platform = stdenv.hostPlatform;
    in
    if platform.isAarch32 && platform ? gcc.fpu then
      lib.throwIfNot (builtins.elem platform.gcc.fpu [
        "vfp"
        "vfpv2"
        "vfpv3"
        "vfpv3-d16"
        "neon"
      ]) "unsupported ARM FPU ${platform.gcc.fpu}" platform.gcc.fpu
    else
      null;
  destARMFloatABI =
    let
      platform = stdenv.hostPlatform;
    in
    if platform.isAarch32 && platform ? gcc.float-abi then
      lib.throwIfNot (builtins.elem platform.gcc.float-abi [
        "soft"
        "softfp"
        "hard"
      ]) "unsupported ARM float ABI ${platform.gcc.float-abi}" platform.gcc.float-abi
    else
      null;
  # TODO: also handle MIPS flags (mips_arch, mips_fpu, mips_float_abi).

  buildNodejs =
    {
      version,
      hash,
      patches,
      # TODO: use python3 from top-level arguments once fixes for Python 3.12
      # land in Node.js v18.
      python ? python3,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = if (!finalAttrs.slim) then "nodejs" else "nodejs-slim";
      inherit version;

      src = fetchurl {
        url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
        inherit hash;
      };

      inherit patches;

      # Used via finalAttrs to disable bundled npm and corepack.
      slim = false;

      outputs = [
        "out"
        "include"
        "dev"
        "libv8"
      ];

      # TODO: remove this once build-support/setup-hooks/multiple-outputs.sh
      # properly sets outputInclude for include output. Currently it defaults to
      # $outputDev.
      outputInclude = "include";

      __structuredAttrs = true;

      outputChecks = {
        out.disallowedReferences = [
          "include"
          "dev"
          "libv8"
          openssl.dev
          zlib.dev
          libuv.dev
          icu.dev
        ];

        libv8.disallowedReferences = [
          "out"
          "include"
          "dev"
        ];
      };

      strictDeps = true;

      env =
        {
          # Tell ninja to avoid ANSI sequences, otherwise we don’t see build
          # progress in Nix logs.
          #
          # Note: do not set TERM=dumb environment variable globally, it is used in
          # test-ci-js test suite to skip tests that otherwise run fine.
          NINJA = "TERM=dumb ninja";
        }
        // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
          # Make sure libc++ uses `posix_memalign` instead of `aligned_alloc` on x86_64-darwin.
          # Otherwise, nodejs would require the 11.0 SDK and macOS 10.15+.
          NIX_CFLAGS_COMPILE = "-D__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__=101300 -Wno-macro-redefined";
        };

      nativeBuildInputs =
        [
          installShellFiles
          ninja
          pkgconf
          python
        ]
        ++ lib.optionals stdenv.buildPlatform.isDarwin [
          # gyp checks `sysctl -n hw.memsize` if `sys.platform == "darwin"`.
          unixtools.sysctl
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # For gyp-mac-tool if `flavor == "mac"`.
          darwin-cctools-only-libtool
        ];

      buildInputs =
        [
          zlib
          libuv
          openssl
          icu
          # For patchShebangsAuto. Technically, we do not need bash in build
          # inputs since all scripts are wrappers over the corresponding JS
          # scripts. There are some packages though that use bash wrappers, e.g.
          # polaris-web.
          bash
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          CoreServices
          ApplicationServices
        ];

      # We currently rely on Makefile and stdenv for build phases, so do not let
      # ninja’s setup hook to override default stdenv phases.
      dontUseNinjaBuild = true;
      dontUseNinjaCheck = true;
      dontUseNinjaInstall = true;

      setOutputFlags = false;

      configureFlags =
        [
          "--ninja"
          "--shared-openssl"
          "--shared-zlib"
          "--shared-libuv"
          "--with-intl=system-icu"
          "--openssl-use-def-ca-store"
          "--no-cross-compiling"
          "--dest-os=${destOS}"
          "--dest-cpu=${destCPU}"
        ]
        ++ lib.optionals (destARMFPU != null) [ "--with-arm-fpu=${destARMFPU}" ]
        ++ lib.optionals (destARMFloatABI != null) [ "--with-arm-float-abi=${destARMFloatABI}" ]
        ++ lib.optionals (!canExecute) [
          # Node.js requires matching bitness between build and host platforms, e.g.
          # for V8 startup snapshot builder (see tools/snapshot) and some other
          # tools. We apply a patch that runs these tools using a host platform
          # emulator and avoid cross-compiling altogether (from the build system’s
          # perspective).
          "--emulator=${emulator}"
        ]
        ++ lib.optionals (lib.versionOlder version "19") [ "--without-dtrace" ]
        ++ lib.optionals finalAttrs.slim [
          "--without-npm"
          "--without-corepack"
        ];

      configurePlatforms = [ ];

      dontDisableStatic = true;

      configureScript = writeScript "nodejs-configure" ''
        exec ${python.executable} configure.py "$@"
      '';

      enableParallelBuilding = true;

      # Don't allow enabling content addressed conversion as `nodejs`
      # checksums it's image before conversion happens and image loading
      # breaks:
      #   $ nix build -f. nodejs --arg config '{ contentAddressedByDefault = true; }'
      #   $ ./result/bin/node
      #   Check failed: VerifyChecksum(blob).
      __contentAddressed = false;

      setupHook = ./setup-hook.sh;

      __darwinAllowLocalNetworking = true; # for tests

      doCheck = canExecute;

      # See https://github.com/nodejs/node/issues/22006
      enableParallelChecking = false;

      # Some dependencies required for tools/doc/node_modules (and therefore
      # test-addons, jstest and others) target are not included in the tarball.
      # Run test targets that do not require network access.
      checkTarget = lib.concatStringsSep " " (
        [
          "build-js-native-api-tests"
          "build-node-api-tests"
          "tooltest"
          "cctest"
        ]
        ++ lib.optionals (!stdenv.buildPlatform.isDarwin || lib.versionAtLeast version "20") [
          # There are some test failures on macOS before v20 that are not worth the
          # time to debug for a version that would be eventually removed in less
          # than a year (Node.js 18 will be EOL at 2025-04-30). Note that these
          # failures are specific to Nix sandbox on macOS and should not affect
          # actual functionality.
          "test-ci-js"
        ]
      );

      checkFlags =
        [
          # Do not create __pycache__ when running tests.
          "PYTHONDONTWRITEBYTECODE=1"
        ]
        ++ lib.optionals (!stdenv.buildPlatform.isDarwin || lib.versionAtLeast version "20") [
          "FLAKY_TESTS=skip"
          # Skip some tests that are not passing in this context
          "CI_SKIP_TESTS=${
            lib.concatStringsSep "," (
              [
                "test-child-process-exec-env"
                "test-child-process-uid-gid"
                "test-fs-write-stream-eagain"
                "test-https-foafssl"
                "test-process-euid-egid"
                "test-process-initgroups"
                "test-process-setgroups"
                "test-process-uid-gid"
                "test-setproctitle"
                "test-tls-cli-max-version-1.3"
                "test-tls-client-auth"
                "test-tls-sni-option"
              ]
              ++ lib.optionals stdenv.buildPlatform.isDarwin [
                # Disable tests that don’t work under macOS sandbox.
                "test-macos-app-sandbox"
                "test-os"
                "test-os-process-priority"
                # This is a bit weird, but for some reason fs watch tests fail with
                # sandbox (only on Darwin).
                "test-fs-promises-watch"
                "test-fs-watch"
                "test-fs-watch-encoding"
                "test-fs-watch-non-recursive"
                "test-fs-watch-recursive-add-file"
                "test-fs-watch-recursive-add-file-to-existing-subfolder"
                "test-fs-watch-recursive-add-file-to-new-folder"
                "test-fs-watch-recursive-add-file-with-url"
                "test-fs-watch-recursive-add-folder"
                "test-fs-watch-recursive-assert-leaks"
                "test-fs-watch-recursive-promise"
                "test-fs-watch-recursive-symlink"
                "test-fs-watch-recursive-sync-write"
                "test-fs-watch-recursive-update-file"
                "test-fs-watchfile"
                "test-runner-run"
                "test-runner-watch-mode"
                "test-watch-mode-files_watcher"
              ]
              ++ lib.optionals (stdenv.buildPlatform.isDarwin && stdenv.buildPlatform.isx86_64) [
                # These tests fail on x86_64-darwin (even without sandbox).
                # TODO: revisit at a later date.
                "test-fs-readv"
                "test-fs-readv-sync"
              ]
            )
          }"
        ];

      postInstall =
        ''
          HOST_PATH=$out/bin patchShebangs --host $out
        ''
        + lib.optionalString canExecute ''
          $out/bin/node --completion-bash >node.bash
          installShellCompletion node.bash
        ''
        + lib.optionalString (!finalAttrs.slim) ''
          installShellCompletion --cmd npm \
            "$out"/lib/node_modules/npm/lib/utils/completion.fish \
            --bash "$out"/lib/node_modules/npm/lib/utils/completion.sh
          installManPage "$out"/lib/node_modules/npm/man/man*/*
        ''
        # Some packages currently use Node.js as v8 library provider because the
        # actual v8 package is extremely outdated. This is wrong and we should
        # instead update v8 package in Nixpkgs.
        # TODO: remove after v8 package is up-to-date and there are no users of
        # libv8 output in Nixpkgs.
        + builtins.readFile ./libv8.sh;

      # Do not use _multioutDevs to avoid pre-fixup hook moving stuff from
      # libv8 output.
      moveToDev = false;
      preFixup = ''
        moveToOutput include/node "''${!outputInclude}"
      '';

      passthru.tests = {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          version = "v${version}";
        };
      };

      passthru.updateScript = callPackage ./update.nix { majorVersion = lib.versions.major version; };

      passthru = {
        interpreterName = "nodejs";

        pkgs = callPackage ../../node-packages/default.nix { nodejs = finalAttrs.finalPackage; };
        inherit python; # to ensure nodeEnv uses the same version
      };

      meta = {
        description = "Event-driven I/O framework for the V8 JavaScript engine";
        homepage = "https://nodejs.org";
        changelog = "https://github.com/nodejs/node/releases/tag/v${version}";
        license = lib.licenses.mit;
        maintainers = builtins.attrValues { inherit (lib.maintainers) aduh95 tie; };
        platforms = lib.platforms.linux ++ lib.platforms.darwin;
        mainProgram = "node";
        knownVulnerabilities = lib.optional (lib.versionOlder version "18") "This NodeJS release has reached its end of life. See https://nodejs.org/en/about/previous-releases";
      };
    });

  backports = {
    # Fixes builds with Nix sandbox on Darwin for gyp.
    # See https://github.com/NixOS/nixpkgs/issues/261820
    # and https://github.com/nodejs/gyp-next/pull/216
    tools-gyp-darwin-sandbox-patch = fetchpatch2 {
      name = "tools-gyp-darwin-sandbox.patch";
      url = "https://github.com/nodejs/gyp-next/commit/706d04aba5bd18f311dc56f84720e99f64c73466.patch?full_index=1";
      hash = "sha256-iV9qvj0meZkgRzFNur2v1jtLZahbqvSJ237NoM8pPZc=";
      stripLen = 1;
      extraPrefix = "tools/gyp/";
    };
    deps-gyp-darwin-sandbox-patch = fetchpatch2 {
      name = "deps-gyp-darwin-sandbox.patch";
      url = "https://github.com/nodejs/gyp-next/commit/706d04aba5bd18f311dc56f84720e99f64c73466.patch?full_index=1";
      hash = "sha256-1iyeeAprmWpmLafvOOXW45iZ4jWFSloWJxQ0reAKBOo=";
      stripLen = 1;
      extraPrefix = "deps/npm/node_modules/node-gyp/gyp/";
    };

    tests-use-python-from-env-patch = fetchpatch2 {
      name = "tests-use-python-from-env.patch";
      url = "https://github.com/nodejs/node/commit/d0a6b605fba6cd69a82e6f12ff0363eef8fe1ee9.patch?full_index=1";
      hash = "sha256-bZJumM1KkB/REPhIiiMCe62t/tEfgVVFrcASn9rvtNo=";
    };

    makefile-skip-tests-patch = fetchpatch2 {
      name = "makefile-skip-tests.patch";
      url = "https://github.com/nodejs/node/commit/534c122de166cb6464b489f3e6a9a544ceb1c913.patch?full_index=1";
      hash = "sha256-Ac1mQwYX1qPKFFo6M1cfthBJ/fgFvglMw5wP2fcKZ+o=";
    };

    v20-openssl-3-0-14-patch = fetchpatch2 {
      name = "v20-openssl-3.0.14.patch";
      url = "https://github.com/nodejs/node/commit/14863e80584e579fd48c55f6373878c821c7ff7e.patch?full_index=1";
      hash = "sha256-gICknl2vGx1iBfHgrtYPka/7dT8XANC0Ndz/BLZispc=";
    };

    do-not-assume-cwd-in-snapshot-tests-patch = fetchpatch2 {
      name = "do-not-assume-cwd-in-snapshot-tests.patch";
      url = "https://github.com/nodejs/node/commit/87598d4b63ef2c827a2bebdfa0f1540c35718519.patch?full_index=1";
      hash = "sha256-2xxNtrexEOJcq3BIe58LX02EwrwcI4yHzgHNILCIqII=";
    };

    v18-do-not-assume-cwd-in-snapshot-tests = fetchpatch2 {
      name = "v18-do-not-assume-cwd-in-snapshot-tests.patch";
      url = "https://github.com/nodejs/node/commit/87598d4b63ef2c827a2bebdfa0f1540c35718519.patch?full_index=1";
      hash = "sha256-1WN3tndfZlvsTJfK9jGS89HKfnqWEhU6BshQLDd68hs=";
      includes = [ "test/common/assertSnapshot.js" ];
    };
  };
in
{
  nodejs_18 = buildNodejs {
    python = python311;

    version = "18.20.4";
    hash = "sha256-p2x+oblq62ljoViAYmDICUtiRNZKaWUp0CBUe5qVyio=";
    patches = [
      ./patches/configure-emulator-node18.patch
      ./patches/configure-armv6-vfpv2.patch
      ./patches/pkgconf-remove-references.patch
      ./patches/cause-segfault-optnone.patch
      ./patches/disable-darwin-v8-system-instrumentation.patch
      ./patches/bypass-darwin-xcrun-node16.patch
      ./patches/revert-arm64-pointer-auth.patch
      ./patches/node-npm-build-npm-package-logic.patch
      ./patches/trap-handler-backport.patch
      ./patches/use-correct-env-in-tests.patch
      ./patches/v18-openssl-3.0.14.patch
      backports.makefile-skip-tests-patch
      backports.v18-do-not-assume-cwd-in-snapshot-tests
      backports.tests-use-python-from-env-patch
      backports.tools-gyp-darwin-sandbox-patch
      backports.deps-gyp-darwin-sandbox-patch
      ./patches/gyp-patches-pre-v22-import-sys.patch
    ];
  };

  nodejs_20 = buildNodejs {
    version = "20.16.0";
    hash = "sha256-zWyPw/8mBqrbxxVdtvfnckfS0AZawY4vfwSQlVhLi0Y=";
    patches = [
      ./patches/configure-emulator.patch
      ./patches/configure-armv6-vfpv2.patch
      ./patches/pkgconf-remove-references.patch
      ./patches/cause-segfault-optnone.patch
      ./patches/disable-darwin-v8-system-instrumentation-node19.patch
      ./patches/bypass-darwin-xcrun-node16.patch
      ./patches/node-npm-build-npm-package-logic.patch
      ./patches/use-correct-env-in-tests.patch
      backports.makefile-skip-tests-patch
      backports.v20-openssl-3-0-14-patch
      backports.do-not-assume-cwd-in-snapshot-tests-patch
      backports.tests-use-python-from-env-patch
      backports.tools-gyp-darwin-sandbox-patch
      backports.deps-gyp-darwin-sandbox-patch
      ./patches/gyp-patches-pre-v22-import-sys.patch
    ];
  };

  nodejs_22 = buildNodejs {
    version = "22.5.1";
    hash = "sha256-kk84GjLPJra+2+lf7t3jSEUPT9MhKD078/eWWqRc6DE=";
    patches = [
      ./patches/configure-emulator.patch
      ./patches/configure-armv6-vfpv2.patch
      ./patches/pkgconf-remove-references.patch
      ./patches/cause-segfault-optnone.patch
      ./patches/disable-darwin-v8-system-instrumentation-node19.patch
      ./patches/bypass-darwin-xcrun-node16.patch
      ./patches/node-npm-build-npm-package-logic.patch
      ./patches/use-correct-env-in-tests.patch
      ./patches/bin-sh-node-run-v22.patch
      backports.tests-use-python-from-env-patch
      backports.tools-gyp-darwin-sandbox-patch
      backports.deps-gyp-darwin-sandbox-patch
      ./patches/gyp-patches-v22-import-sys.patch
    ];
  };
}
