{ lib, stdenv, fetchurl, openssl, python, zlib, libuv, http-parser, icu, bash
, ninja, pkgconf, unixtools, runCommand, buildPackages
, testers
# for `.pkgs` attribute
, callPackage
# Updater dependencies
, writeScript, coreutils, gnugrep, jq, curl, common-updater-scripts, nix, runtimeShell
, gnupg
, darwin
, installShellFiles
}:

{ enableNpm ? true, version, sha256, patches ? [] } @args:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

  majorVersion = lib.versions.major version;
  minorVersion = lib.versions.minor version;

  pname = if enableNpm then "nodejs" else "nodejs-slim";

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

  useSharedHttpParser = !stdenv.hostPlatform.isDarwin && lib.versionOlder "${majorVersion}.${minorVersion}" "11.4";

  sharedLibDeps = { inherit openssl zlib libuv; } // (lib.optionalAttrs useSharedHttpParser { inherit http-parser; });

  copyLibHeaders =
    map
      (name: "${lib.getDev sharedLibDeps.${name}}/include/*")
      (builtins.attrNames sharedLibDeps);

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

  package = stdenv.mkDerivation (finalAttrs:
  let
    /** the final package fixed point, after potential overrides */
    self = finalAttrs.finalPackage;
  in
  {
    inherit pname version;

    src = fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      inherit sha256;
    };

    strictDeps = true;

    env = {
      # Tell ninja to avoid ANSI sequences, otherwise we don’t see build
      # progress in Nix logs.
      #
      # Note: do not set TERM=dumb environment variable globally, it is used in
      # test-ci-js test suite to skip tests that otherwise run fine.
      NINJA = "TERM=dumb ninja";
    } // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) {
      # Make sure libc++ uses `posix_memalign` instead of `aligned_alloc` on x86_64-darwin.
      # Otherwise, nodejs would require the 11.0 SDK and macOS 10.15+.
      NIX_CFLAGS_COMPILE = "-D__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__=101300 -Wno-macro-redefined";
    };

    # NB: technically, we do not need bash in build inputs since all scripts are
    # wrappers over the corresponding JS scripts. There are some packages though
    # that use bash wrappers, e.g. polaris-web.
    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ApplicationServices ]
      ++ [ zlib libuv openssl http-parser icu bash ];

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

    # We currently rely on Makefile and stdenv for build phases, so do not let
    # ninja’s setup hook to override default stdenv phases.
    dontUseNinjaBuild = true;
    dontUseNinjaCheck = true;
    dontUseNinjaInstall = true;

    outputs = [ "out" "libv8" ];
    setOutputFlags = false;
    moveToDev = false;

    configureFlags =
      [
        "--ninja"
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
      ++ lib.optionals (!enableNpm) [ "--without-npm" ]
      ++ lib.concatMap (name: [
        "--shared-${name}"
        "--shared-${name}-libpath=${lib.getLib sharedLibDeps.${name}}/lib"
        /**
          Closure notes: we explicitly avoid specifying --shared-*-includes,
          as that would put the paths into bin/nodejs.
          Including pkg-config in build inputs would also have the same effect!

          FIXME: the statement above is outdated, we have to include pkg-config
          in build inputs for system-icu.
        */
      ]) (builtins.attrNames sharedLibDeps);

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

    passthru.interpreterName = "nodejs";

    passthru.pkgs = callPackage ../../node-packages/default.nix {
      nodejs = self;
    };

    setupHook = ./setup-hook.sh;

    pos = builtins.unsafeGetAttrPos "version" args;

    inherit patches;

    __darwinAllowLocalNetworking = true; # for tests

    doCheck = canExecute;

    # See https://github.com/nodejs/node/issues/22006
    enableParallelChecking = false;

    # Some dependencies required for tools/doc/node_modules (and therefore
    # test-addons, jstest and others) target are not included in the tarball.
    # Run test targets that do not require network access.
    checkTarget = lib.concatStringsSep " " ([
      "build-js-native-api-tests"
      "build-node-api-tests"
      "tooltest"
      "cctest"
    ] ++ lib.optionals (!stdenv.buildPlatform.isDarwin || lib.versionAtLeast version "20") [
      # There are some test failures on macOS before v20 that are not worth the
      # time to debug for a version that would be eventually removed in less
      # than a year (Node.js 18 will be EOL at 2025-04-30). Note that these
      # failures are specific to Nix sandbox on macOS and should not affect
      # actual functionality.
      "test-ci-js"
    ]);

    checkFlags = [
      # Do not create __pycache__ when running tests.
      "PYTHONDONTWRITEBYTECODE=1"
    ] ++ lib.optionals (stdenv.buildPlatform.isDarwin && stdenv.buildPlatform.isx86_64) [
      # Python 3.12 introduced a warning for calling `os.fork()` in a
      # multi‐threaded program. For some reason, the Node.js
      # `tools/pseudo-tty.py` program used for PTY‐related tests
      # triggers this warning on Hydra, on `x86_64-darwin` only,
      # despite not creating any threads itself. This causes the
      # Node.js test runner to misinterpret the warnings as part of the
      # test output and fail. It does not reproduce reliably off Hydra
      # on Intel Macs, or occur on the `aarch64-darwin` builds.
      #
      # This seems likely to be related to Rosetta 2, but it could also
      # be some strange x86‐64‐only threading behaviour of the Darwin
      # system libraries, or a bug in CPython, or something else
      # haunted about the Nixpkgs/Hydra build environment. We silence
      # the warnings in the hope that closing our eyes will make the
      # ghosts go away.
      "PYTHONWARNINGS=ignore::DeprecationWarning"
    ] ++ lib.optionals (!stdenv.buildPlatform.isDarwin || lib.versionAtLeast version "20") [
      "FLAKY_TESTS=skip"
      # Skip some tests that are not passing in this context
      "CI_SKIP_TESTS=${lib.concatStringsSep "," ([
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
        # This is a bit weird, but for some reason fs watch tests fail with
        # sandbox.
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
      ] ++ lib.optionals stdenv.buildPlatform.isDarwin [
        # Disable tests that don’t work under macOS sandbox.
        "test-macos-app-sandbox"
        "test-os"
        "test-os-process-priority"
      ] ++ lib.optionals (stdenv.buildPlatform.isDarwin && stdenv.buildPlatform.isx86_64) [
        # These tests fail on x86_64-darwin (even without sandbox).
        # TODO: revisit at a later date.
        "test-fs-readv"
        "test-fs-readv-sync"
      ])}"
    ];

    postInstall = ''
      HOST_PATH=$out/bin patchShebangs --host $out

      ${lib.optionalString canExecute ''
        $out/bin/node --completion-bash > node.bash
        installShellCompletion node.bash
      ''}

      ${lib.optionalString enableNpm ''
        mkdir -p $out/share/bash-completion/completions
        ln -s $out/lib/node_modules/npm/lib/utils/completion.sh \
          $out/share/bash-completion/completions/npm
        for dir in "$out/lib/node_modules/npm/man/"*; do
          mkdir -p $out/share/man/$(basename "$dir")
          for page in "$dir"/*; do
            ln -rs $page $out/share/man/$(basename "$dir")
          done
        done
      ''}

      # install the missing headers for node-gyp
      # TODO: add dev output and use propagatedBuildInputs instead of copying headers.
      cp -r ${lib.concatStringsSep " " copyLibHeaders} $out/include/node

      # assemble a static v8 library and put it in the 'libv8' output
      mkdir -p $libv8/lib
      pushd out/Release/obj
      find . -path "./torque_*/**/*.o" -or -path "./v8*/**/*.o" | sort -u >files
      $AR -cqs $libv8/lib/libv8.a @files
      popd

      # copy v8 headers
      cp -r deps/v8/include $libv8/

      # create a pkgconfig file for v8
      major=$(grep V8_MAJOR_VERSION deps/v8/include/v8-version.h | cut -d ' ' -f 3)
      minor=$(grep V8_MINOR_VERSION deps/v8/include/v8-version.h | cut -d ' ' -f 3)
      patch=$(grep V8_PATCH_LEVEL deps/v8/include/v8-version.h | cut -d ' ' -f 3)
      mkdir -p $libv8/lib/pkgconfig
      cat > $libv8/lib/pkgconfig/v8.pc << EOF
      Name: v8
      Description: V8 JavaScript Engine
      Version: $major.$minor.$patch
      Libs: -L$libv8/lib -lv8 -pthread -licui18n -licuuc
      Cflags: -I$libv8/include
      EOF
    '';

    passthru.tests = {
      version = testers.testVersion {
        package = self;
        version = "v${version}";
      };
    };

    passthru.updateScript = import ./update.nix {
      inherit writeScript coreutils gnugrep jq curl common-updater-scripts gnupg nix runtimeShell;
      inherit lib;
      inherit majorVersion;
    };

    meta = with lib; {
      description = "Event-driven I/O framework for the V8 JavaScript engine";
      homepage = "https://nodejs.org";
      changelog = "https://github.com/nodejs/node/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ aduh95 ];
      platforms = platforms.linux ++ platforms.darwin;
      mainProgram = "node";
      knownVulnerabilities = optional (versionOlder version "18") "This NodeJS release has reached its end of life. See https://nodejs.org/en/about/releases/.";
    };

    passthru.python = python; # to ensure nodeEnv uses the same version
  });
in package
