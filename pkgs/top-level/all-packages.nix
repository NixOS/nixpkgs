/* The top-level package collection of nixpkgs.
 * It is sorted by categories corresponding to the folder names in the /pkgs
 * folder. Inside the categories packages are roughly sorted by alphabet, but
 * strict sorting has been long lost due to merges. Please use the full-text
 * search of your editor. ;)
 * Hint: ### starts category names.
 */
{ lib, noSysDirs, config, overlays }:
res: pkgs: super:

with pkgs;

{
  # A module system style type tag
  #
  # Allows the nixpkgs fixpoint, usually known as `pkgs` to be distinguished
  # nominally.
  #
  #     pkgs._type == "pkgs"
  #     pkgs.pkgsStatic._type == "pkgs"
  #
  # Design note:
  # While earlier stages of nixpkgs fixpoint construction are supertypes of this
  # stage, they're generally not usable in places where a `pkgs` is expected.
  # (earlier stages being the various `super` variables that precede
  # all-packages.nix)
  _type = "pkgs";

  # A stdenv capable of building 32-bit binaries.
  # On x86_64-linux, it uses GCC compiled with multilib support; on i686-linux,
  # it's just the plain stdenv.
  stdenv_32bit = lowPrio (if stdenv.hostPlatform.is32bit then stdenv else multiStdenv);

  stdenvNoCC = stdenv.override (
    { cc = null; hasCC = false; }

    // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && (stdenv.hostPlatform != stdenv.buildPlatform)) {
      # TODO: This is a hack to use stdenvNoCC to produce a CF when cross
      # compiling. It's not very sound. The cross stdenv has:
      #   extraBuildInputs = [ targetPackages.darwin.apple_sdks.frameworks.CoreFoundation ]
      # and uses stdenvNoCC. In order to make this not infinitely recursive, we
      # need to exclude this extraBuildInput.
      extraBuildInputs = [];
    }
  );

  mkStdenvNoLibs = stdenv: let
    bintools = stdenv.cc.bintools.override {
      libc = null;
      noLibc = true;
    };
  in stdenv.override {
    cc = stdenv.cc.override {
      libc = null;
      noLibc = true;
      extraPackages = [];
      inherit bintools;
    };
    allowedRequisites =
      lib.mapNullable (rs: rs ++ [ bintools ]) (stdenv.allowedRequisites or null);
  };

  stdenvNoLibs =
    if stdenv.hostPlatform != stdenv.buildPlatform && (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isDarwin.useLLVM or false)
    then
      # We cannot touch binutils or cc themselves, because that will cause
      # infinite recursion. So instead, we just choose a libc based on the
      # current platform. That means we won't respect whatever compiler was
      # passed in with the stdenv stage argument.
      #
      # TODO It would be much better to pass the `stdenvNoCC` and *unwrapped*
      # cc, bintools, compiler-rt equivalent, etc. and create all final stdenvs
      # as part of the stage. Then we would never be tempted to override a later
      # thing to to create an earlier thing (leading to infinite recursion) and
      # we also would still respect the stage arguments choices for these
      # things.
      overrideCC stdenv buildPackages.llvmPackages.clangNoCompilerRt
    else mkStdenvNoLibs stdenv;

  gccStdenvNoLibs = mkStdenvNoLibs gccStdenv;
  clangStdenvNoLibs = mkStdenvNoLibs clangStdenv;

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;

  ### Helper functions.
  inherit lib config overlays;

  # do not import 'appendToName' to get consistent package-names with the same
  # set of package-parameters: https://github.com/NixOS/nixpkgs/issues/68519
  inherit (lib) lowPrio hiPrio makeOverridable;

  inherit (lib) recurseIntoAttrs;

  # This is intended to be the reverse of recurseIntoAttrs, as it is
  # defined now it exists mainly for documentation purposes, but you
  # can also override this with recurseIntoAttrs to recurseInto all
  # the Attrs which is useful for testing massive changes. Ideally,
  # every package subset not marked with recurseIntoAttrs should be
  # marked with this.
  inherit (lib) dontRecurseIntoAttrs;

  stringsWithDeps = lib.stringsWithDeps;

  ### Evaluating the entire Nixpkgs naively will fail, make failure fast
  AAAAAASomeThingsFailToEvaluate = throw ''
    Please be informed that this pseudo-package is not the only part of
    Nixpkgs that fails to evaluate. You should not evaluate entire Nixpkgs
    without some special measures to handle failing packages, like those taken
    by Hydra.
  '';

  tests = callPackages ../test {};

  ### Nixpkgs maintainer tools

  ### Push NixOS tests inside the fixed point

  # See also allTestsForSystem in nixos/release.nix
  nixosTests = import ../../nixos/tests/all-tests.nix {
    inherit pkgs;
    system = stdenv.hostPlatform.system;
    callTest = config: config.test;
  } // {
    # for typechecking of the scripts and evaluation of
    # the nodes, without running VMs.
    allDrivers = import ../../nixos/tests/all-tests.nix {
      inherit pkgs;
      system = stdenv.hostPlatform.system;
      callTest = config: config.test.driver;
    };
  };

  ### BUILD SUPPORT

  auditBlasHook = makeSetupHook
    { name = "auto-blas-hook"; deps = [ blas lapack ]; }
    ../build-support/setup-hooks/audit-blas.sh;

  autoreconfHook = callPackage (
    { makeSetupHook, autoconf, automake, gettext, libtool }:
    makeSetupHook
      { deps = [ autoconf automake gettext libtool ]; }
      ../build-support/setup-hooks/autoreconf.sh
  ) { };

  autoreconfHook264 = autoreconfHook.override {
    autoconf = autoconf264;
    automake = automake111x;
  };

  autoreconfHook269 = autoreconfHook.override {
    autoconf = autoconf269;
  };

  autoPatchelfHook = makeSetupHook {
    name = "auto-patchelf-hook";
    deps = [ bintools ];
    substitutions = {
      pythonInterpreter = "${python3.withPackages (ps: [ ps.pyelftools ])}/bin/python";
      autoPatchelfScript = ../build-support/setup-hooks/auto-patchelf.py;
    };
    meta.platforms = lib.platforms.linux;
  } ../build-support/setup-hooks/auto-patchelf.sh;

  appimageTools = callPackage ../build-support/appimage {
    buildFHSUserEnv = buildFHSUserEnvBubblewrap;
  };

  bindle = callPackage ../servers/bindle {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  canonicalize-jars-hook = makeSetupHook {
    name = "canonicalize-jars-hook";
    substitutions = { canonicalize_jar = canonicalize-jar; };
  } ../build-support/setup-hooks/canonicalize-jars.sh;

  ensureNewerSourcesHook = { year }: makeSetupHook {}
    (writeScript "ensure-newer-sources-hook.sh" ''
      postUnpackHooks+=(_ensureNewerSources)
      _ensureNewerSources() {
        '${findutils}/bin/find' "$sourceRoot" \
          '!' -newermt '${year}-01-01' -exec touch -h -d '${year}-01-02' '{}' '+'
      }
    '');

  ankisyncd = callPackage ../servers/ankisyncd {
    python3 = python39;
  };

  aocd = with python3Packages; toPythonApplication aocd;

  atuin = callPackage ../tools/misc/atuin {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  cve = with python3Packages; toPythonApplication cvelib;

  arti = callPackage ../tools/security/arti {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  binserve = callPackage ../servers/binserve {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  brev-cli = callPackage ../development/misc/brev-cli {
    buildGoModule = buildGo118Module; # build fails with 1.19
  };

  # Zip file format only allows times after year 1980, which makes e.g. Python
  # wheel building fail with:
  # ValueError: ZIP does not support timestamps before 1980
  ensureNewerSourcesForZipFilesHook = ensureNewerSourcesHook { year = "1980"; };

  updateAutotoolsGnuConfigScriptsHook = makeSetupHook
    { substitutions = { gnu_config = gnu-config;}; }
    ../build-support/setup-hooks/update-autotools-gnu-config-scripts.sh;

  gogUnpackHook = makeSetupHook {
    name = "gog-unpack-hook";
    deps = [ innoextract file-rename ]; }
    ../build-support/setup-hooks/gog-unpack.sh;

  /* buildEnv = <moved> */ # not actually a package

  # TODO: eventually migrate everything to buildFHSUserEnvBubblewrap
  buildFHSUserEnv = buildFHSUserEnvChroot;

  cloak = callPackage ../applications/misc/cloak {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  cotp = callPackage ../applications/misc/cotp {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  cocogitto = callPackage ../development/tools/cocogitto {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  coldsnap = callPackage ../tools/admin/coldsnap {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  crow-translate = libsForQt5.callPackage ../applications/misc/crow-translate { };

  databricks-sql-cli = python3Packages.callPackage ../applications/misc/databricks-sql-cli { };

  dinghy = with python3Packages; toPythonApplication dinghy;

  dtv-scan-tables = dtv-scan-tables_linuxtv;

  dufs = callPackage ../servers/http/dufs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  edgedb = callPackage ../tools/networking/edgedb {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  hobbes = callPackage ../development/tools/hobbes { stdenv = gcc10StdenvCompat; };

  html5validator = python3Packages.callPackage ../applications/misc/html5validator { };

  buildcatrust = with python3.pkgs; toPythonApplication buildcatrust;

  probe-rs-cli = callPackage ../development/tools/rust/probe-rs-cli {
    inherit (darwin.apple_sdk.frameworks) AppKit;
    inherit (darwin) DarwinTools;
  };

  probe-run = callPackage ../development/tools/rust/probe-run {
    inherit (darwin.apple_sdk.frameworks) AppKit IOKit;
  };

  prisma-engines = callPackage ../development/tools/database/prisma-engines {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  r3ctl = qt5.callPackage ../tools/misc/r3ctl { };

  enum4linux-ng = python3Packages.callPackage ../tools/security/enum4linux-ng { };

  oletools = with python3.pkgs; toPythonApplication oletools;

  didyoumean = callPackage ../tools/misc/didyoumean {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  diffPlugins = (callPackage ../build-support/plugins.nix {}).diffPlugins;

  dieHook = makeSetupHook {} ../build-support/setup-hooks/die.sh;

  digitalbitbox = libsForQt5.callPackage ../applications/misc/digitalbitbox {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  dockerTools = callPackage ../build-support/docker {
    writePython3 = buildPackages.writers.writePython3;
  };

  # Dotnet

  dotnetCorePackages = recurseIntoAttrs (callPackage ../development/compilers/dotnet {});

  dotnet-sdk_2 = dotnetCorePackages.sdk_2_1;
  dotnet-sdk_3 = dotnetCorePackages.sdk_3_1;
  dotnet-sdk_5 = dotnetCorePackages.sdk_5_0;
  dotnet-sdk_6 = dotnetCorePackages.sdk_6_0;
  dotnet-sdk_7 = dotnetCorePackages.sdk_7_0;

  dotnet-runtime_3 = dotnetCorePackages.runtime_3_1;
  dotnet-runtime_5 = dotnetCorePackages.runtime_5_0;
  dotnet-runtime_6 = dotnetCorePackages.runtime_6_0;
  dotnet-runtime_7 = dotnetCorePackages.runtime_7_0;

  dotnet-aspnetcore_3 = dotnetCorePackages.aspnetcore_3_1;
  dotnet-aspnetcore_5 = dotnetCorePackages.aspnetcore_5_0;
  dotnet-aspnetcore_6 = dotnetCorePackages.aspnetcore_6_0;
  dotnet-aspnetcore_7 = dotnetCorePackages.aspnetcore_7_0;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  dotnet-aspnetcore = dotnetCorePackages.aspnetcore_6_0;

  dotnetenv = callPackage ../build-support/dotnet/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  fetchbower = callPackage ../build-support/fetchbower {
    inherit (nodePackages) bower2nix;
  };

  fetchcvs = if stdenv.buildPlatform != stdenv.hostPlatform
    # hack around splicing being crummy with things that (correctly) don't eval.
    then buildPackages.fetchcvs
    else callPackage ../build-support/fetchcvs { };

  fetchDockerConfig = callPackage ../build-support/fetchdocker/fetchDockerConfig.nix { };

  fetchDockerLayer = callPackage ../build-support/fetchdocker/fetchDockerLayer.nix { };

  fetchgit = (callPackage ../build-support/fetchgit {
    git = buildPackages.gitMinimal;
    cacert = buildPackages.cacert;
    git-lfs = buildPackages.git-lfs;
  }) // { # fetchgit is a function, so we use // instead of passthru.
    tests = pkgs.tests.fetchgit;
  };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

  inherit (callPackage ../build-support/node/fetch-yarn-deps { })
    prefetch-yarn-deps
    fetchYarnDeps;

  prefer-remote-fetch = import ../build-support/prefer-remote-fetch;

  opendrop = python3Packages.callPackage ../tools/networking/opendrop { };

  perseus-cli = callPackage ../development/tools/perseus-cli {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  pe-bear = libsForQt5.callPackage ../applications/misc/pe-bear {};

  mongosh = callPackage ../development/tools/mongosh { };

  mysql-shell = callPackage ../development/tools/mysql-shell {
    inherit (darwin) cctools developer_cmds DarwinTools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    antlr = antlr4_10;
    boost = boost177; # Configure checks for specific version.
    protobuf = protobuf3_19;
    icu =  icu69;
    v8 = v8_8_x;
  };

  fetchpatch = callPackage ../build-support/fetchpatch {
    # 0.3.4 would change hashes: https://github.com/NixOS/nixpkgs/issues/25154
    patchutils = buildPackages.patchutils_0_3_3;
  } // {
    tests = pkgs.tests.fetchpatch;
    version = 1;
  };

  fetchpatch2 = callPackage ../build-support/fetchpatch {
    patchutils = buildPackages.patchutils_0_4_2;
  } // {
    tests = pkgs.tests.fetchpatch2;
    version = 2;
  };

  fetchsvn = if stdenv.buildPlatform != stdenv.hostPlatform
    # hack around splicing being crummy with things that (correctly) don't eval.
    then buildPackages.fetchsvn
    else callPackage ../build-support/fetchsvn { };

  fetchsvnrevision = import ../build-support/fetchsvnrevision runCommand subversion;

  fetchFirefoxAddon = callPackage ../build-support/fetchfirefoxaddon { }
    // {
      tests = pkgs.tests.fetchFirefoxAddon;
    };

  # `fetchurl' downloads a file from the network.
  fetchurl = if stdenv.buildPlatform != stdenv.hostPlatform
    then buildPackages.fetchurl # No need to do special overrides twice,
    else makeOverridable (import ../build-support/fetchurl) {
      inherit lib stdenvNoCC buildPackages;
      inherit cacert;
      curl = buildPackages.curlMinimal.override (old: rec {
        # break dependency cycles
        fetchurl = stdenv.fetchurlBoot;
        zlib = buildPackages.zlib.override { fetchurl = stdenv.fetchurlBoot; };
        pkg-config = buildPackages.pkg-config.override (old: {
          pkg-config = old.pkg-config.override {
            fetchurl = stdenv.fetchurlBoot;
          };
        });
        perl = buildPackages.perl.override { fetchurl = stdenv.fetchurlBoot; };
        openssl = buildPackages.openssl.override {
          fetchurl = stdenv.fetchurlBoot;
          buildPackages = {
            coreutils = buildPackages.coreutils.override {
              fetchurl = stdenv.fetchurlBoot;
              inherit perl;
              xz = buildPackages.xz.override { fetchurl = stdenv.fetchurlBoot; };
              gmp = null;
              aclSupport = false;
              attrSupport = false;
            };
            inherit perl;
          };
          inherit perl;
        };
        libssh2 = buildPackages.libssh2.override {
          fetchurl = stdenv.fetchurlBoot;
          inherit zlib openssl;
        };
        # On darwin, libkrb5 needs bootstrap_cmds which would require
        # converting many packages to fetchurl_boot to avoid evaluation cycles.
        # So turn gssSupport off there, and on Windows.
        # On other platforms, keep the previous value.
        gssSupport =
          if stdenv.isDarwin || stdenv.hostPlatform.isWindows
            then false
            else old.gssSupport or true; # `? true` is the default
        libkrb5 = buildPackages.libkrb5.override {
          fetchurl = stdenv.fetchurlBoot;
          inherit pkg-config perl openssl;
          keyutils = buildPackages.keyutils.override { fetchurl = stdenv.fetchurlBoot; };
        };
        nghttp2 = buildPackages.nghttp2.override {
          fetchurl = stdenv.fetchurlBoot;
          inherit pkg-config;
          enableApp = false; # curl just needs libnghttp2
          enableTests = false; # avoids bringing `cunit` and `tzdata` into scope
        };
      });
    };

  fetchipfs = import ../build-support/fetchipfs {
    inherit curl stdenv;
  };

  fetchzip = callPackage ../build-support/fetchzip { }
    // {
      tests = pkgs.tests.fetchzip;
    };

  resolveMirrorURLs = {url}: fetchurl {
    showURLs = true;
    inherit url;
  };

  installShellFiles = callPackage ../build-support/install-shell-files {};

  ld-is-cc-hook = makeSetupHook { name = "ld-is-cc-hook"; }
    ../build-support/setup-hooks/ld-is-cc-hook.sh;

  copyDesktopItems = makeSetupHook { } ../build-support/setup-hooks/copy-desktop-items.sh;

  copyPkgconfigItems = makeSetupHook { } ../build-support/setup-hooks/copy-pkgconfig-items.sh;

  makeImpureTest = callPackage ../build-support/make-impure-test.nix;

  makeInitrd = callPackage ../build-support/kernel/make-initrd.nix; # Args intentionally left out

  makeInitrdNG = callPackage ../build-support/kernel/make-initrd-ng.nix;

  makeWrapper = makeShellWrapper;

  makeShellWrapper = makeSetupHook
    { deps = [ dieHook ];
      substitutions = {
        # targetPackages.runtimeShell only exists when pkgs == targetPackages (when targetPackages is not  __raw)
        shell = if targetPackages ? runtimeShell then targetPackages.runtimeShell else throw "makeWrapper/makeShellWrapper must be in nativeBuildInputs";
      };
      passthru = {
        tests = tests.makeWrapper;
      };
    }
    ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = { kernel, firmware, rootModules, allowMissing ? false }:
    callPackage ../build-support/kernel/modules-closure.nix {
      inherit kernel firmware rootModules allowMissing;
    };

  mkShellNoCC = mkShell.override { stdenv = stdenvNoCC; };

  nixBufferBuilders = import ../build-support/emacs/buffer.nix { inherit lib writeText; inherit (emacs.pkgs) inherit-local; };

  inherit (
    callPackages ../build-support/setup-hooks/patch-rc-path-hooks { }
  ) patchRcPathBash patchRcPathCsh patchRcPathFish patchRcPathPosix;

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  pruneLibtoolFiles = makeSetupHook { name = "prune-libtool-files"; }
    ../build-support/setup-hooks/prune-libtool-files.sh;

  shortenPerlShebang = makeSetupHook
    { deps = [ dieHook ]; }
    ../build-support/setup-hooks/shorten-perl-shebang.sh;

  nukeReferences = callPackage ../build-support/nuke-references {
    inherit (darwin) signingUtils;
  };

  removeReferencesTo = callPackage ../build-support/remove-references-to {
    inherit (darwin) signingUtils;
  };

  # No callPackage.  In particular, we don't want `img` *package* in parameters.
  vmTools = makeOverridable (import ../build-support/vm) { inherit pkgs lib; };

  inherit (lib.systems) platforms;

  setJavaClassPath = makeSetupHook { } ../build-support/setup-hooks/set-java-classpath.sh;

  fixDarwinDylibNames = makeSetupHook {
    name = "fix-darwin-dylib-names-hook";
    substitutions = { inherit (binutils) targetPrefix; };
    meta.platforms = lib.platforms.darwin;
  } ../build-support/setup-hooks/fix-darwin-dylib-names.sh;

  desktopToDarwinBundle = makeSetupHook {
    deps = [ writeDarwinBundle librsvg imagemagick python3Packages.icnsutil ];
  } ../build-support/setup-hooks/desktop-to-darwin-bundle.sh;

  keepBuildTree = makeSetupHook { } ../build-support/setup-hooks/keep-build-tree.sh;

  enableGCOVInstrumentation = makeSetupHook { } ../build-support/setup-hooks/enable-coverage-instrumentation.sh;

  makeGCOVReport = makeSetupHook
    { deps = [ lcov enableGCOVInstrumentation ]; }
    ../build-support/setup-hooks/make-coverage-analysis-report.sh;

  # intended to be used like nix-build -E 'with import <nixpkgs> {}; enableDebugging fooPackage'
  enableDebugging = pkg: pkg.override { stdenv = stdenvAdapters.keepDebugInfo pkg.stdenv; };

  findXMLCatalogs = makeSetupHook { } ../build-support/setup-hooks/find-xml-catalogs.sh;

  wrapGAppsHook = callPackage ../build-support/setup-hooks/wrap-gapps-hook {
    makeWrapper = makeBinaryWrapper;
  };

  wrapGAppsHook4 = wrapGAppsHook.override { gtk3 = gtk4; };

  wrapGAppsNoGuiHook = wrapGAppsHook.override { isGraphical = false; };

  separateDebugInfo = makeSetupHook { } ../build-support/setup-hooks/separate-debug-info.sh;

  setupDebugInfoDirs = makeSetupHook { } ../build-support/setup-hooks/setup-debug-info-dirs.sh;

  useOldCXXAbi = makeSetupHook { } ../build-support/setup-hooks/use-old-cxx-abi.sh;

  validatePkgConfig = makeSetupHook
    { name = "validate-pkg-config"; deps = [ findutils pkg-config ]; }
    ../build-support/setup-hooks/validate-pkg-config.sh;

  #package writers

  # lib functions depending on pkgs
  inherit (import ../pkgs-lib { inherit lib pkgs; }) formats;

  testers = callPackage ../build-support/testers {};

  ### TOOLS

  _1password-gui = callPackage ../applications/misc/1password-gui { };

  _1password-gui-beta = callPackage ../applications/misc/1password-gui { channel = "beta"; };

  _7zz = darwin.apple_sdk_11_0.callPackage ../tools/archivers/7zz { };

  acquire = with python3Packages; toPythonApplication acquire;

  actdiag = with python3.pkgs; toPythonApplication actdiag;

  adlplug = callPackage ../applications/audio/adlplug {
    inherit (darwin.apple_sdk.frameworks) Foundation Cocoa Carbon CoreServices ApplicationServices CoreAudio CoreMIDI AudioToolbox Accelerate CoreImage IOKit AudioUnit QuartzCore WebKit DiscRecording CoreAudioKit;
    jack = libjack2;
  };
  opnplug = adlplug.override {
    type = "OPN";
  };

  arc_unpacker = callPackage ../tools/archivers/arc_unpacker {
    boost = boost16x; # checkPhase fails with Boost 1.77
    stdenv = gcc10StdenvCompat;
  };

  akkoma-frontends = recurseIntoAttrs {
    pleroma-fe = callPackage ../servers/akkoma/pleroma-fe { };
    admin-fe = callPackage ../servers/akkoma/admin-fe { };
  };
  akkoma-emoji = recurseIntoAttrs {
    blobs_gg = callPackage ../servers/akkoma/emoji/blobs_gg.nix { };
  };

  aegisub = callPackage ../applications/video/aegisub ({
    wxGTK = wxGTK32;
  } // (config.aegisub or {}));

  acme-client = callPackage ../tools/networking/acme-client {
    stdenv = gccStdenv;
  };

  afl = callPackage ../tools/security/afl {
    stdenv = clangStdenv;
  };

  honggfuzz = callPackage ../tools/security/honggfuzz {
    clang = clang_12;
    llvm = llvm_12;
  };

  aflplusplus = callPackage ../tools/security/aflplusplus {
    clang = clang_9;
    llvm = llvm_9;
    python = python3;
    wine = null;
  };

  afsctool = callPackage ../tools/filesystems/afsctool {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  agate = callPackage ../servers/gemini/agate {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  aioblescan = with python3Packages; toPythonApplication aioblescan;

  aiodnsbrute = python3Packages.callPackage ../tools/security/aiodnsbrute { };

  airfield = callPackage ../tools/networking/airfield { };

  apache-airflow = with python3.pkgs; toPythonApplication apache-airflow;

  ajour = callPackage ../tools/games/ajour {
    inherit (gnome) zenity;
    inherit (plasma5Packages) kdialog;
  };

  albert = libsForQt5.callPackage ../applications/misc/albert {};

  butler = callPackage ../games/itch/butler.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  bikeshed = python3Packages.callPackage ../applications/misc/bikeshed { };

  gamemode = callPackage ../tools/games/gamemode {
    libgamemode32 = pkgsi686Linux.gamemode.lib;
  };

  weylus = callPackage ../applications/graphics/weylus  {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa VideoToolbox;
  };

  gh-cal = callPackage ../tools/misc/gh-cal {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  fwbuilder = libsForQt5.callPackage ../tools/security/fwbuilder { };

  inherit (callPackage ../tools/networking/ivpn/default.nix {}) ivpn ivpn-service;

  kanata-with-cmd = kanata.override { withCmd = true; };

  ksnip = libsForQt5.callPackage ../tools/misc/ksnip { };

  linux-router-without-wifi = linux-router.override { useWifiDependencies = false; };

  ocs-url = libsForQt5.callPackage ../tools/misc/ocs-url { };

  qFlipper = libsForQt5.callPackage ../tools/misc/qflipper { };

  veikk-linux-driver-gui = libsForQt5.callPackage ../tools/misc/veikk-linux-driver-gui { };

  ventoy-bin-full = ventoy-bin.override {
    withCryptsetup = true;
    withXfs = true;
    withExt4 = true;
    withNtfs = true;
  };

  winbox = callPackage ../tools/admin/winbox {
    wine = wineWowPackages.staging;
  };

  yabridge = callPackage ../tools/audio/yabridge {
    wine = wineWowPackages.staging;
  };

  yabridgectl = callPackage ../tools/audio/yabridgectl {
    wine = wineWowPackages.staging;
  };

  yafetch = callPackage ../tools/misc/yafetch {
    stdenv = clangStdenv;
  };

  ### APPLICATIONS/VERSION-MANAGEMENT

  git = callPackage ../applications/version-management/git {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
    smtpPerlLibs = [
      perlPackages.libnet perlPackages.NetSMTPSSL
      perlPackages.IOSocketSSL perlPackages.NetSSLeay
      perlPackages.AuthenSASL perlPackages.DigestHMAC
    ];
  };

  # The full-featured Git.
  gitFull = git.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = true;
    withSsh = true;
    withLibsecret = !stdenv.isDarwin;
  };

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (git.override { svnSupport = true; });

  git-doc = lib.addMetaAttrs {
    description = "Additional documentation for Git";
    longDescription = ''
      This package contains additional documentation (HTML and text files) that
      is referenced in the man pages of Git.
    '';
  } gitFull.doc;

  gitMinimal = git.override {
    withManual = false;
    pythonSupport = false;
    perlSupport = false;
    withpcre2 = false;
  };

  bump2version = python3Packages.callPackage ../applications/version-management/bump2version { };

  cgit = callPackage ../applications/version-management/cgit { };

  cgit-pink = callPackage ../applications/version-management/cgit/pink.nix { };

  commitlint = nodePackages."@commitlint/cli";

  delta = callPackage ../applications/version-management/delta {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation Security;
  };

  gfold = callPackage ../applications/version-management/gfold {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gita = python3Packages.callPackage ../applications/version-management/gita { };

  gitoxide = callPackage ../applications/version-management/gitoxide {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  github-cli = gh;

  git-absorb = callPackage ../applications/version-management/git-absorb {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-annex-metadata-gui = libsForQt5.callPackage ../applications/version-management/git-annex-metadata-gui {
    inherit (python3Packages) buildPythonApplication pyqt5 git-annex-adapter;
  };

  git-annex-remote-dbx = callPackage ../applications/version-management/git-annex-remote-dbx {
    inherit (python3Packages)
    buildPythonApplication
    fetchPypi
    dropbox
    annexremote
    humanfriendly;
  };

  git-annex-remote-googledrive = callPackage ../applications/version-management/git-annex-remote-googledrive {
    inherit (python3Packages)
    buildPythonApplication
    fetchPypi
    annexremote
    drivelib
    gitpython
    tenacity
    humanfriendly;
  };

  git-backup = callPackage ../applications/version-management/git-backup {
    openssl = openssl_1_1;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-branchless = callPackage ../applications/version-management/git-branchless {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  git-branchstack = python3.pkgs.callPackage ../applications/version-management/git-branchstack { };

  git-cinnabar = callPackage ../applications/version-management/git-cinnabar {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  git-cliff = callPackage ../applications/version-management/git-cliff {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-credential-keepassxc = callPackage ../applications/version-management/git-credential-keepassxc {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
  };

  git-gone = callPackage ../applications/version-management/git-gone {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-imerge = python3Packages.callPackage ../applications/version-management/git-imerge { };

  git-interactive-rebase-tool = callPackage ../applications/version-management/git-interactive-rebase-tool {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-lfs = lowPrio (callPackage ../applications/version-management/git-lfs { });

  git-machete = python3Packages.callPackage ../applications/version-management/git-machete { };

  git-publish = python3Packages.callPackage ../applications/version-management/git-publish { };

  git-quickfix = callPackage ../applications/version-management/git-quickfix {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  git-recent = callPackage ../applications/version-management/git-recent {
    util-linux = if stdenv.isLinux then util-linuxMinimal else util-linux;
  };

  git-remote-codecommit = python3Packages.callPackage ../applications/version-management/git-remote-codecommit { };

  gitRepo = git-repo;

  git-repo-updater = python3Packages.callPackage ../applications/version-management/git-repo-updater { };

  git-review = python3Packages.callPackage ../applications/version-management/git-review { };

  git-series = callPackage ../applications/version-management/git-series {
    openssl = openssl_1_1;
  };

  git-subset = callPackage ../applications/version-management/git-subset {
    openssl = openssl_1_1;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-trim = callPackage ../applications/version-management/git-trim {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-up = callPackage ../applications/version-management/git-up {
    pythonPackages = python3Packages;
  };

  git-workspace = callPackage ../applications/version-management/git-workspace {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gitlint = python3Packages.callPackage ../applications/version-management/gitlint { };

  gitui = callPackage ../applications/version-management/gitui {
    inherit (darwin.apple_sdk.frameworks) Security AppKit;
  };

  lucky-commit = callPackage ../applications/version-management/lucky-commit {
    inherit (darwin.apple_sdk.frameworks) OpenCL;
  };

  pass-git-helper = python3Packages.callPackage ../applications/version-management/pass-git-helper { };

  qgit = qt5.callPackage ../applications/version-management/qgit { };

  radicle-cli = callPackage ../applications/version-management/radicle-cli {
    inherit (darwin) DarwinTools;
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  svn-all-fast-export = libsForQt5.callPackage ../applications/version-management/svn-all-fast-export { };

  svn2git = callPackage ../applications/version-management/svn2git {
    git = gitSVN;
  };

  inherit (haskellPackages) git-annex;

  inherit (haskellPackages) git-brunch;

  git-autofixup = perlPackages.GitAutofixup;

  ghrepo-stats = with python3Packages; toPythonApplication ghrepo-stats;

  git-filter-repo = with python3Packages; toPythonApplication git-filter-repo;

  git-revise = with python3Packages; toPythonApplication git-revise;

  ### APPLICATIONS/EMULATORS

  bochs = callPackage ../applications/emulators/bochs {
    inherit (darwin) libobjc;
    wxGTK = wxGTK32;
  };

  cdemu-client = callPackage ../applications/emulators/cdemu/client.nix { };

  cdemu-daemon = callPackage ../applications/emulators/cdemu/daemon.nix { };

  citra-canary = callPackage ../applications/emulators/citra {
    branch = "canary";
  };

  citra-nightly = callPackage ../applications/emulators/citra {
    branch = "nightly";
  };

  dosbox = callPackage ../applications/emulators/dosbox {
    SDL = if stdenv.isDarwin then SDL else SDL_compat;
  };

  duckstation = qt6Packages.callPackage ../applications/emulators/duckstation {};

  fceux = callPackage ../applications/emulators/fceux {
    lua = lua5_1;
    inherit (libsForQt5) wrapQtAppsHook;
  };

  firebird-emu = libsForQt5.callPackage ../applications/emulators/firebird-emu { };

  fsuae-launcher = libsForQt5.callPackage ../applications/emulators/fs-uae/launcher.nix { };

  fw = callPackage ../tools/misc/fw {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gcdemu = callPackage ../applications/emulators/cdemu/gui.nix { };

  gensgs = pkgsi686Linux.callPackage ../applications/emulators/gens-gs { };

  image-analyzer = callPackage ../applications/emulators/cdemu/analyzer.nix { };

  kega-fusion = pkgsi686Linux.callPackage ../applications/emulators/kega-fusion { };

  libmirage = callPackage ../applications/emulators/cdemu/libmirage.nix { };

  mame = libsForQt5.callPackage ../applications/emulators/mame { };

  mame-tools = lib.addMetaAttrs {
    description = mame.meta.description + " (tools only)";
  } (lib.getOutput "tools" mame);

  melonDS = libsForQt5.callPackage ../applications/emulators/melonDS { };

  pcsx2 = callPackage ../applications/emulators/pcsx2 {
    wxGTK = wxGTK30;
  };

  ppsspp-sdl = ppsspp;

  ppsspp-sdl-wayland = ppsspp.override {
    forceWayland = true;
    enableVulkan = false; # https://github.com/hrydgard/ppsspp/issues/13845
  };

  ppsspp-qt = ppsspp.override {
    inherit (libsForQt5) qtbase qtmultimedia wrapQtAppsHook;
    enableVulkan = false; # https://github.com/hrydgard/ppsspp/issues/11628
  };

  punes = libsForQt5.callPackage ../applications/emulators/punes { };

  py65 = python3Packages.callPackage ../applications/emulators/py65 { };

  ripes = libsForQt5.callPackage ../applications/emulators/ripes { };

  rpcs3 = libsForQt5.callPackage ../applications/emulators/rpcs3 { };

  snes9x = callPackage ../applications/emulators/snes9x { };

  snes9x-gtk = callPackage ../applications/emulators/snes9x {
    withGtk = true;
  };

  winetricks = callPackage ../applications/emulators/wine/winetricks.nix {
    inherit (gnome) zenity;
  };

  zsnes = pkgsi686Linux.callPackage ../applications/emulators/zsnes { };

  ### APPLICATIONS/EMULATORS/BSNES

  ares = darwin.apple_sdk_11_0.callPackage ../applications/emulators/bsnes/ares { };

  bsnes-hd = darwin.apple_sdk_11_0.callPackage ../applications/emulators/bsnes/bsnes-hd { };

  ### APPLICATIONS/EMULATORS/DOLPHIN-EMU

  dolphin-emu-beta = qt6Packages.callPackage ../applications/emulators/dolphin-emu/master.nix {
    inherit (darwin.apple_sdk.frameworks) CoreBluetooth ForceFeedback IOKit OpenGL VideoToolbox;
    inherit (darwin) moltenvk;
  };

  dolphin-emu-primehack = qt5.callPackage ../applications/emulators/dolphin-emu/primehack.nix {
    inherit (darwin.apple_sdk.frameworks) CoreBluetooth ForceFeedback IOKit OpenGL;
    fmt = fmt_8;
  };

  ### APPLICATIONS/EMULATORS/RETROARCH

  retroarchBare = qt5.callPackage ../applications/emulators/retroarch { };

  retroarchFull = retroarch.override {
    cores = builtins.filter
      # Remove cores not supported on platform
      (c: c ? libretroCore && (lib.meta.availableOn stdenv.hostPlatform c))
      (builtins.attrValues libretro);
  };

  wrapRetroArch = { retroarch }:
    callPackage ../applications/emulators/retroarch/wrapper.nix
      { inherit retroarch; };

  retroarch = wrapRetroArch {
    retroarch = retroarchBare.override {
      withAssets = true;
      withCoreInfo = true;
    };
  };

  libretro = recurseIntoAttrs
    (callPackage ../applications/emulators/retroarch/cores.nix {
      retroarch = retroarchBare;
    });

  kodi-retroarch-advanced-launchers =
    callPackage ../applications/emulators/retroarch/kodi-advanced-launchers.nix { };

  ### APPLICATIONS/EMULATORS/YUZU

  yuzu-mainline = import ../applications/emulators/yuzu {
    branch = "mainline";
    inherit libsForQt5 fetchFromGitHub fetchurl;
  };

  yuzu-early-access = import ../applications/emulators/yuzu {
    branch = "early-access";
    inherit libsForQt5 fetchFromGitHub fetchurl;
  };

  ### APPLICATIONS/EMULATORS/COMMANDERX16

  x16-run = (callPackage ../applications/emulators/commanderx16/run.nix { }) {
    emulator = x16-emulator;
    rom = x16-rom;
  };

  yabause = libsForQt5.callPackage ../applications/emulators/yabause {
    freeglut = null;
    openal = null;
  };

  ### APPLICATIONS/FILE-MANAGERS

  doublecmd = callPackage  ../applications/file-managers/doublecmd {
    inherit (qt5) wrapQtAppsHook;
  };

  joshuto = callPackage ../applications/file-managers/joshuto {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration Foundation;
  };

  krusader = libsForQt5.callPackage ../applications/file-managers/krusader { };

  mc = callPackage ../applications/file-managers/mc {
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  vifm-full = vifm.override {
    mediaSupport = true;
    inherit lib udisks2 python3;
  };

  xfe = callPackage ../applications/file-managers/xfe {
    fox = fox_1_6;
  };

  ### APPLICATIONS/TERMINAL-EMULATORS

  alacritty = callPackage ../applications/terminal-emulators/alacritty {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  contour = libsForQt5.callPackage ../applications/terminal-emulators/contour { fmt = fmt_8; };

  cool-retro-term = libsForQt5.callPackage ../applications/terminal-emulators/cool-retro-term { };

  kitty = darwin.apple_sdk_11_0.callPackage ../applications/terminal-emulators/kitty {
    harfbuzz = harfbuzz.override { withCoreText = stdenv.isDarwin; };
    inherit (darwin.apple_sdk_11_0) Libsystem;
    inherit (darwin.apple_sdk_11_0.frameworks)
      Cocoa
      Kernel
      UniformTypeIdentifiers
      UserNotifications
    ;
  };

  mlterm = darwin.apple_sdk_11_0.callPackage ../applications/terminal-emulators/mlterm {
    libssh2 = null;
    openssl = null;
    inherit (darwin.apple_sdk_11_0.frameworks) Cocoa;
  };

  rxvt-unicode-emoji = rxvt-unicode.override {
    rxvt-unicode-unwrapped = rxvt-unicode-unwrapped-emoji;
  };

  rxvt-unicode-plugins = import ../applications/terminal-emulators/rxvt-unicode-plugins { inherit callPackage; };

  rxvt-unicode-unwrapped-emoji = rxvt-unicode-unwrapped.override {
    emojiSupport = true;
  };

  st = callPackage ../applications/terminal-emulators/st {
    conf = config.st.conf or null;
    patches = config.st.patches or [];
    extraLibs = config.st.extraLibs or [];
  };

  stupidterm = callPackage ../applications/terminal-emulators/stupidterm {
    gtk = gtk3;
  };

  termite = callPackage ../applications/terminal-emulators/termite/wrapper.nix {
    termite = termite-unwrapped;
  };

  tilda = callPackage ../applications/terminal-emulators/tilda {
    gtk = gtk3;
  };

  wezterm = darwin.apple_sdk_11_0.callPackage ../applications/terminal-emulators/wezterm {
    inherit (darwin.apple_sdk_11_0.frameworks) Cocoa CoreGraphics Foundation UserNotifications;
  };

  iqueue = callPackage ../development/libraries/iqueue { stdenv = gcc10StdenvCompat; };

  logseq = callPackage ../applications/misc/logseq {
    electron = electron_20;
  };

  twine = with python3Packages; toPythonApplication twine;

  amazon-qldb-shell = callPackage ../development/tools/amazon-qldb-shell {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  amber = callPackage ../tools/text/amber {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  amber-secret = callPackage ../tools/security/amber {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../development/tools/ammonite {})
    ammonite_2_12
    ammonite_2_13;
  ammonite = if scala == scala_2_12 then ammonite_2_12 else ammonite_2_13;

  android-tools = lowPrio (darwin.apple_sdk_11_0.callPackage ../tools/misc/android-tools
    (lib.optionalAttrs (stdenv.targetPlatform.isAarch64 && stdenv.targetPlatform.isLinux) {
      stdenv = gcc10Stdenv;
    }));

  apk-tools = callPackage ../tools/package-management/apk-tools {
    lua = lua5_3;
  };

  apktool = callPackage ../development/tools/apktool {
    inherit (androidenv.androidPkgs_9_0) build-tools;
  };

  appimage-run-tests = callPackage ../tools/package-management/appimage-run/test.nix {
    appimage-run = appimage-run.override {
      appimage-run-tests = null; /* break boostrap cycle for passthru.tests */
    };
  };

  ArchiSteamFarm = callPackage ../applications/misc/ArchiSteamFarm { };

  # arcanist currently crashes with some workflows on php8.1, use 8.0
  arcanist = callPackage ../development/tools/misc/arcanist { php = php80; };

  arduino = arduino-core.override { withGui = true; };

  apio = python3Packages.callPackage ../development/embedded/fpga/apio { };

  apitrace = libsForQt5.callPackage ../applications/graphics/apitrace {};

  arj = callPackage ../tools/archivers/arj {
    stdenv = gccStdenv;
  };

  inherit (callPackages ../data/fonts/arphic {})
    arphic-ukai arphic-uming;

  asciinema-agg = callPackage ../tools/misc/asciinema-agg {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  asymptote = callPackage ../tools/graphics/asymptote {
    texLive = texlive.combine { inherit (texlive) scheme-small epsf cm-super texinfo media9 ocgx2 collection-latexextra; };
  };

  atomicparsley = callPackage ../tools/video/atomicparsley {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  autoflake = with python3.pkgs; toPythonApplication autoflake;

  aws-google-auth = python3Packages.callPackage ../tools/admin/aws-google-auth { };

  aws-mfa = python3Packages.callPackage ../tools/admin/aws-mfa { };

  binocle = callPackage ../applications/misc/binocle {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreVideo Foundation Metal QuartzCore;
  };

  brewtarget = libsForQt5.callPackage ../applications/misc/brewtarget { } ;

  # Derivation's result is not used by nixpkgs. Useful for validation for
  # regressions of bootstrapTools on hydra and on ofborg. Example:
  #     pkgsCross.aarch64-multiplatform.freshBootstrapTools.build
  freshBootstrapTools = if stdenv.hostPlatform.isDarwin then
    callPackage ../stdenv/darwin/make-bootstrap-tools.nix {
      localSystem = stdenv.buildPlatform;
      crossSystem =
        if stdenv.buildPlatform == stdenv.hostPlatform then null else stdenv.hostPlatform;
    }
  else if stdenv.hostPlatform.isLinux then
    callPackage ../stdenv/linux/make-bootstrap-tools.nix {}
  else throw "freshBootstrapTools: unknown hostPlatform ${stdenv.hostPlatform.config}";

  chars = callPackage ../tools/text/chars {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  crystfel = callPackage ../applications/science/physics/crystfel { };

  crystfel-headless = callPackage ../applications/science/physics/crystfel { withGui = false; };

  amule-daemon = amule.override {
    monolithic = false;
    enableDaemon = true;
  };

  amule-gui = amule.override {
    monolithic = false;
    client = true;
  };

  amule-web = amule.override {
    monolithic = false;
    httpServer = true;
  };

  antennas = nodePackages.antennas;

  apt-dater = callPackage ../tools/package-management/apt-dater {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  bashate = python3Packages.callPackage ../development/tools/bashate { };

  binance = callPackage ../applications/misc/binance {
    electron = electron_13;
  };

  inherit (nodePackages) bitwarden-cli;

  bitwarden-menu = python3Packages.callPackage ../applications/misc/bitwarden-menu { };

  inherit (nodePackages) concurrently;

  blocksat-cli = with python3Packages; toPythonApplication blocksat-cli;

  bonnie = callPackage ../tools/filesystems/bonnie {
    stdenv = gcc10StdenvCompat;
  };

  botamusique = callPackage ../tools/audio/botamusique { };

  bucklespring = bucklespring-x11;
  bucklespring-libinput = callPackage ../applications/audio/bucklespring { };
  bucklespring-x11 = callPackage ../applications/audio/bucklespring { legacy = true; };

  buildbot = with python3Packages; toPythonApplication buildbot;
  buildbot-ui = with python3Packages; toPythonApplication buildbot-ui;
  buildbot-full = with python3Packages; toPythonApplication buildbot-full;
  buildbot-worker = with python3Packages; toPythonApplication buildbot-worker;

  inherit (nodePackages) castnow;

  catcli = python3Packages.callPackage ../tools/filesystems/catcli { };

  chipsec = callPackage ../tools/security/chipsec {
    kernel = null;
    withDriver = false;
  };

  cloud-custodian = python3Packages.callPackage ../tools/networking/cloud-custodian  { };

  coconut = with python3Packages; toPythonApplication coconut;

  coolreader = libsForQt5.callPackage ../applications/misc/coolreader {};

  corsair = with python3Packages; toPythonApplication corsair-scan;

  cosign = callPackage ../tools/security/cosign {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };

  cue = callPackage ../development/tools/cue {
    buildGoModule = buildGo118Module; # tests fail with 1.19
  };

  deltachat-desktop = callPackage ../applications/networking/instant-messengers/deltachat-desktop {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  detect-secrets = with python3Packages; toPythonApplication detect-secrets;

  diopser = callPackage ../applications/audio/diopser { stdenv = gcc10StdenvCompat; };

  diskus = callPackage ../tools/misc/diskus {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  dkimpy = with python3Packages; toPythonApplication dkimpy;

  dotter = callPackage ../tools/misc/dotter {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  echidna = haskell.lib.compose.justStaticExecutables (haskellPackages.callPackage (../tools/security/echidna) { });

  libfx2 = with python3Packages; toPythonApplication fx2;

  fastmod = callPackage ../tools/text/fastmod {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  flirc = libsForQt5.callPackage ../applications/video/flirc { };

  flood = nodePackages.flood;

  foxdot = with python3Packages; toPythonApplication foxdot;

  gbl = callPackage ../tools/archivers/gbl {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  genpass = callPackage ../tools/security/genpass {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  gams = callPackage ../tools/misc/gams (config.gams or {});

  github-desktop = callPackage ../applications/version-management/github-desktop {
    openssl = openssl_1_1;
    curl = curl.override { openssl = openssl_1_1; };
  };

  github-to-sqlite = with python3Packages; toPythonApplication github-to-sqlite;

  gistyc = with python3Packages; toPythonApplication gistyc;

  glances = python3Packages.callPackage ../applications/system/glances { };

  glasgow = with python3Packages; toPythonApplication glasgow;

  glaxnimate = libsForQt5.callPackage ../applications/video/glaxnimate { };

  gmnisrv = callPackage ../servers/gemini/gmnisrv {
    openssl = openssl_1_1;
  };

  go2tv = darwin.apple_sdk_11_0.callPackage ../applications/video/go2tv {
    inherit (darwin.apple_sdk_11_0.frameworks) Carbon Cocoa Kernel UserNotifications;
  };
  go2tv-lite = go2tv.override { withGui = false; };

  guglielmo = libsForQt5.callPackage ../applications/radio/guglielmo { };

  grc = python3Packages.callPackage ../tools/misc/grc { };

  green-pdfviewer = callPackage ../applications/misc/green-pdfviewer {
    SDL = SDL_sixel;
  };

  gremlin-console = callPackage ../applications/misc/gremlin-console {
    openjdk = openjdk11;
  };

  gremlin-server = callPackage ../applications/misc/gremlin-server {
    openjdk = openjdk11;
  };

  grex = callPackage ../tools/misc/grex {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  google-amber = callPackage ../tools/graphics/amber {
    inherit (darwin) cctools;
  };

  himitsu = callPackage ../tools/security/himitsu {
    inherit (harePackages) hare;
  };

  himitsu-firefox = callPackage ../tools/security/himitsu-firefox {
    inherit (harePackages) hare;
  };

  hinit = haskell.lib.compose.justStaticExecutables haskellPackages.hinit;

  hwi = with python3Packages; toPythonApplication hwi;

  pass = callPackage ../tools/security/pass { };

  pass-nodmenu = callPackage ../tools/security/pass {
    dmenuSupport = false;
    pass = pass-nodmenu;
  };

  pass-wayland = callPackage ../tools/security/pass {
    waylandSupport = true;
    pass = pass-wayland;
  };

  passExtensions = recurseIntoAttrs pass.extensions;

  inherd-quake = callPackage ../applications/misc/inherd-quake {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  kerf   = kerf_1; /* kerf2 is WIP */
  kerf_1 = callPackage ../development/interpreters/kerf {
    stdenv = clangStdenv;
    inherit (darwin.apple_sdk.frameworks)
      Accelerate CoreGraphics CoreVideo
    ;
  };

  khd = callPackage ../os-specific/darwin/khd {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  skhd = callPackage ../os-specific/darwin/skhd {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  qes = callPackage ../os-specific/darwin/qes {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  winhelpcgi = callPackage ../development/tools/winhelpcgi {
    libpng = libpng12;
  };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  ssh-import-id = python3Packages.callPackage ../tools/admin/ssh-import-id { };

  ssh-mitm = with python3Packages; toPythonApplication ssh-mitm;

  titaniumenv = callPackage ../development/mobile/titaniumenv { };

  adbfs-rootless = callPackage ../development/mobile/adbfs-rootless {
    adb = androidenv.androidPkgs_9_0.platform-tools;
  };

  adb-sync = callPackage ../development/mobile/adb-sync {
    inherit (androidenv.androidPkgs_9_0) platform-tools;
  };

  androidenv = callPackage ../development/mobile/androidenv { };

  androidndkPkgs = androidndkPkgs_21;
  androidndkPkgs_21 = (callPackage ../development/androidndk-pkgs {})."21";
  androidndkPkgs_23b = (callPackage ../development/androidndk-pkgs {})."23b";
  androidndkPkgs_24 = (callPackage ../development/androidndk-pkgs {})."24";

  androidsdk_9_0 = androidenv.androidPkgs_9_0.androidsdk;

  webos = recurseIntoAttrs {
    cmake-modules = callPackage ../development/mobile/webos/cmake-modules.nix { };

    novacom = callPackage ../development/mobile/webos/novacom.nix { };
    novacomd = callPackage ../development/mobile/webos/novacomd.nix { };
  };

  anevicon = callPackage ../tools/networking/anevicon {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  aoc-cli = callPackage ../tools/misc/aoc-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  apprise = with python3Packages; toPythonApplication apprise;

  aria2 = callPackage ../tools/networking/aria2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  aria = aria2;

  authoscope = callPackage ../tools/security/authoscope {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  avahi = callPackage ../development/libraries/avahi (config.avahi or {});

  avahi-compat = callPackage ../development/libraries/avahi ((config.avahi or {}) // {
    withLibdnssdCompat = true;
  });

  axel = callPackage ../tools/networking/axel {
    libssl = openssl;
  };

  bandwhich = callPackage ../tools/networking/bandwhich {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  base16-builder = callPackage ../misc/base16-builder { };

  badchars = python3Packages.callPackage ../tools/security/badchars { };

  bat = callPackage ../tools/misc/bat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bat-extras = recurseIntoAttrs (callPackages ../tools/misc/bat-extras { });

  beauty-line-icon-theme = callPackage ../data/icons/beauty-line-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  inherit (callPackages ../misc/logging/beats/6.x.nix { })
    filebeat6
    heartbeat6
    metricbeat6
    journalbeat6;

  inherit (callPackages ../misc/logging/beats/7.x.nix { })
    filebeat7
    heartbeat7
    metricbeat7
    packetbeat7;

  filebeat = filebeat6;
  heartbeat = heartbeat6;
  metricbeat = metricbeat6;
  journalbeat = journalbeat6;

  biliass = with python3.pkgs; toPythonApplication biliass;

  binwalk = with python3Packages; toPythonApplication binwalk;

  birdtray = libsForQt5.callPackage ../applications/misc/birdtray { };

  charles = charles4;
  inherit (callPackage ../applications/networking/charles {})
    charles3
    charles4
  ;

  libquotient = libsForQt5.callPackage ../development/libraries/libquotient {};

  quaternion = libsForQt5.callPackage ../applications/networking/instant-messengers/quaternion { };

  mirage-im = libsForQt5.callPackage ../applications/networking/instant-messengers/mirage {};

  tensor = libsForQt5.callPackage ../applications/networking/instant-messengers/tensor { };

  libtensorflow = python3.pkgs.tensorflow.libtensorflow;

  libtorch-bin = callPackage ../development/libraries/science/math/libtorch/bin.nix {
    cudaSupport = config.cudaSupport or false;
  };

  behave = with python3Packages; toPythonApplication behave;

  blockdiag = with python3Packages; toPythonApplication blockdiag;

  # Upstream recommends qt5.12 and it doesn't build with qt5.15
  boomerang = libsForQt5.callPackage ../development/tools/boomerang { };

  bozohttpd = callPackage ../servers/http/bozohttpd { };
  bozohttpd-minimal = callPackage ../servers/http/bozohttpd { minimal = true; };

  bpb = callPackage ../tools/security/bpb { inherit (darwin.apple_sdk.frameworks) Security; };

  brasero-original = lowPrio (callPackage ../tools/cd-dvd/brasero { });

  broot = callPackage ../tools/misc/broot {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  breakpointHook = assert stdenv.buildPlatform.isLinux;
    makeSetupHook { } ../build-support/setup-hooks/breakpoint-hook.sh;

  btlejack = python3Packages.callPackage ../applications/radio/btlejack { };

  bustle = haskellPackages.bustle;

  byobu = callPackage ../tools/misc/byobu {
    # Choices: [ tmux screen ];
    textual-window-manager = tmux;
  };

  bsh = fetchurl {
    url = "http://www.beanshell.org/bsh-2.0b5.jar";
    sha256 = "0p2sxrpzd0vsk11zf3kb5h12yl1nq4yypb5mpjrm8ww0cfaijck2";
  };

  ciano = callPackage ../applications/graphics/ciano {
    inherit (pantheon) granite;
    python = python3;
    gtk = gtk3;
  };

  c3d = callPackage ../applications/graphics/c3d {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  cabal2nix-unwrapped = haskell.lib.compose.justStaticExecutables
    (haskellPackages.generateOptparseApplicativeCompletions [ "cabal2nix" ] haskellPackages.cabal2nix);

  cabal2nix = symlinkJoin {
    inherit (cabal2nix-unwrapped) name meta;
    nativeBuildInputs = [ buildPackages.makeWrapper ];
    paths = [ cabal2nix-unwrapped ];
    postBuild = ''
      wrapProgram $out/bin/cabal2nix \
        --prefix PATH ":" "${lib.makeBinPath [ nix nix-prefetch-scripts ]}"
    '';
  };

  stack2nix = with haskell.lib; overrideCabal (justStaticExecutables haskellPackages.stack2nix) (_: {
    executableToolDepends = [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/stack2nix \
        --prefix PATH ":" "${git}/bin:${cabal-install}/bin"
    '';
  });

  calamares = libsForQt5.callPackage ../tools/misc/calamares {
    python = python3;
    boost = boost.override { enablePython = true; python = python3; };
  };
  calamares-nixos = lowPrio (calamares.override { nixos-extensions = true; });

  candle = libsForQt5.callPackage ../applications/misc/candle { };

  casync = callPackage ../applications/networking/sync/casync {
    sphinx = buildPackages.python3Packages.sphinx;
  };

  cataract          = callPackage ../applications/misc/cataract { };
  cataract-unstable = callPackage ../applications/misc/cataract/unstable.nix { };

  cardpeek = callPackage ../applications/misc/cardpeek { inherit (darwin.apple_sdk.frameworks) PCSC; };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    gflags = null; # only required for examples/tests
  };

  cedille = callPackage ../applications/science/logic/cedille
                          { inherit (haskellPackages) alex happy Agda ghcWithPackages;
                          };

  cfdyndns = callPackage ../applications/networking/dyndns/cfdyndns {
    openssl = openssl_1_1;
  };

  cinny = callPackage ../applications/networking/instant-messengers/cinny { stdenv = stdenvNoCC; };

  cinny-desktop = callPackage ../applications/networking/instant-messengers/cinny-desktop {
    openssl = openssl_1_1;
  };

  clevercsv = with python3Packages; toPythonApplication clevercsv;

  clevis = callPackage ../tools/security/clevis {
    asciidoc = asciidoc-full;
  };

  clickgen = with python3Packages; toPythonApplication clickgen;

  cloud-init = python3.pkgs.callPackage ../tools/virtualization/cloud-init { inherit systemd; };

  coloredlogs = with python3Packages; toPythonApplication coloredlogs;

  commitizen = python3Packages.callPackage ../applications/version-management/commitizen { };

  inherit (callPackage ../tools/misc/coreboot-utils { })
    msrtool
    cbmem
    ifdtool
    intelmetool
    cbfstool
    nvramtool
    superiotool
    ectool
    inteltool
    amdfwtool
    acpidump-all
    coreboot-utils;

  coreboot-configurator = libsForQt5.callPackage ../tools/misc/coreboot-configurator { };

  swaytools = python3Packages.callPackage ../tools/wayland/swaytools { };

  clockify = callPackage ../applications/office/clockify {
    electron = electron_11;
  };

  cplex = callPackage ../applications/science/math/cplex (config.cplex or {});

  contacts = callPackage ../tools/misc/contacts {
    inherit (darwin.apple_sdk.frameworks) Foundation AddressBook;
    xcbuildHook = xcbuild6Hook;
  };

  coloursum = callPackage ../tools/text/coloursum {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  cot = with python3Packages; toPythonApplication cot;

  crossplane = with python3Packages; toPythonApplication crossplane;

  cutemarked-ng = libsForQt5.callPackage ../applications/office/cutemarked-ng { };

  datasette = with python3Packages; toPythonApplication datasette;

  datovka = libsForQt5.callPackage ../applications/networking/datovka { };

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialogbox = libsForQt5.callPackage ../tools/misc/dialogbox { };

  diesel-cli = callPackage ../development/tools/diesel-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  dijo = callPackage ../tools/misc/dijo {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  discourse = callPackage ../servers/web-apps/discourse { };

  discourseAllPlugins = discourse.override {
    plugins = lib.filter (p: p ? pluginName) (builtins.attrValues discourse.plugins);
  };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  dino = callPackage ../applications/networking/instant-messengers/dino {
    inherit (gst_all_1) gstreamer gst-plugins-base;
    gst-plugins-good = gst_all_1.gst-plugins-good.override { gtkSupport = true; };
  };

  dnschef = python3Packages.callPackage ../tools/networking/dnschef { };

  dotenv-linter = callPackage ../development/tools/analysis/dotenv-linter {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (ocamlPackages) dot-merlin-reader;

  dua = callPackage ../tools/misc/dua {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  inherit (ocaml-ng.ocamlPackages_4_10) dune_1;
  inherit (ocamlPackages) dune_2 dune_3 dune-release;

  dvc = callPackage ../applications/version-management/dvc { };

  dvc-with-remotes = callPackage ../applications/version-management/dvc {
    enableGoogle = true;
    enableAWS = true;
    enableAzure = true;
    enableSSH = true;
  };

  easyocr = with python3.pkgs; toPythonApplication easyocr;

  eddy = libsForQt5.callPackage ../applications/graphics/eddy { };

  element-desktop = callPackage ../applications/networking/instant-messengers/element/element-desktop.nix {
    inherit (darwin.apple_sdk.frameworks) Security AppKit CoreServices;
    electron = electron_20;
  };
  element-desktop-wayland = writeScriptBin "element-desktop" ''
    #!/bin/sh
    NIXOS_OZONE_WL=1 exec ${element-desktop}/bin/element-desktop "$@"
  '';

  element-web-unwrapped = callPackage ../applications/networking/instant-messengers/element/element-web.nix { };

  element-web = callPackage ../applications/networking/instant-messengers/element/element-web-wrapper.nix {
    conf = config.element-web.conf or { };
  };

  espanso = callPackage ../applications/office/espanso {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Foundation;
    openssl = openssl_1_1;
  };

  f3d = callPackage ../applications/graphics/f3d {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  fast-cli = nodePackages.fast-cli;

  fast-ssh = callPackage ../tools/networking/fast-ssh {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  fdroidserver = python3Packages.callPackage ../development/tools/fdroidserver { };

  ### TOOLS/TYPESETTING/TEX

  dblatexFull = dblatex.override { enableAllFeatures = true; };

  # Keep the old PGF since some documents don't render properly with
  # the new one.

  pgf = pgf2;

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # TeX Live; see https://nixos.org/nixpkgs/manual/#sec-language-texlive
  texlive = recurseIntoAttrs (callPackage ../tools/typesetting/tex/texlive { });

  fop = callPackage ../tools/typesetting/fop {
    jdk = openjdk8;
  };

  fondu = callPackage ../tools/misc/fondu {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  futhark = haskell.lib.compose.justStaticExecutables haskellPackages.futhark;

  qt-video-wlr = libsForQt5.callPackage ../applications/misc/qt-video-wlr { };

  fwup = callPackage ../tools/misc/fwup {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration;
  };

  g2o = libsForQt5.callPackage ../development/libraries/g2o { };

  inherit (go-containerregistry) crane gcrane;

  geckodriver = callPackage ../development/tools/geckodriver {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  geekbench = geekbench5;

  glslviewer = callPackage ../development/tools/glslviewer {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  gmic-qt = libsForQt5.callPackage ../tools/graphics/gmic-qt { };

  # NOTE: If overriding qt version, krita needs to use the same qt version as
  # well.
  gmic-qt-krita = gmic-qt.override {
    variant = "krita";
  };

  gpg-tui = callPackage ../tools/security/gpg-tui {
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
    inherit (darwin) libobjc libresolv;
  };

  gping = callPackage ../tools/networking/gping {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gpu-burn = callPackage ../applications/misc/gpu-burn {
    # gpu-burn doesn't build on gcc11. CUDA 11.3 is the last version to use
    # pre-gcc11, in particular gcc9.
    stdenv = gcc9Stdenv;
  };

  greg = callPackage ../applications/audio/greg {
    pythonPackages = python3Packages;
  };

  hebbot = callPackage ../servers/matrix-hebbot {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  hiksink = callPackage ../tools/misc/hiksink {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  hocr-tools = with python3Packages; toPythonApplication hocr-tools;

  hopper = qt5.callPackage ../development/tools/analysis/hopper {};

  hypr = callPackage ../applications/window-managers/hyprwm/hypr {
    cairo = cairo.override { xcbSupport = true; };
  };

  hyprland = callPackage ../applications/window-managers/hyprwm/hyprland {
    stdenv = gcc11Stdenv;
  };

  hyprpaper = callPackage ../applications/window-managers/hyprwm/hyprpaper {
    stdenv = gcc11Stdenv;
  };

  intensity-normalization = with python3Packages; toPythonApplication intensity-normalization;

  jellyfin = callPackage ../servers/jellyfin {
    ffmpeg = jellyfin-ffmpeg;
  };

  jellyfin-media-player = libsForQt5.callPackage ../applications/video/jellyfin-media-player {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa CoreAudio MediaPlayer;
    # Disable pipewire to avoid segfault, see https://github.com/jellyfin/jellyfin-media-player/issues/341
    mpv = wrapMpv (mpv-unwrapped.override { pipewireSupport = false; }) {};
  };

  jellyfin-mpv-shim = python3Packages.callPackage ../applications/video/jellyfin-mpv-shim { };

  jellyfin-web = callPackage ../servers/jellyfin/web.nix { };

  jwt-cli = callPackage ../tools/security/jwt-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  kaldi = callPackage ../tools/audio/kaldi {
    inherit (darwin.apple_sdk.frameworks) Accelerate;
  };

  klaus = with python3Packages; toPythonApplication klaus;

  klipper-firmware = callPackage ../servers/klipper/klipper-firmware.nix { };

  klipper-flash = callPackage ../servers/klipper/klipper-flash.nix { };

  klog = qt5.callPackage ../applications/radio/klog { };

  krill = callPackage ../servers/krill {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  lapce = callPackage ../applications/editors/lapce {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Security CoreServices ApplicationServices Carbon AppKit;
  };

  lief = callPackage ../development/libraries/lief {
    python = python3;
  };

  lite-xl = callPackage ../applications/editors/lite-xl {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  kaggle = with python3Packages; toPythonApplication kaggle;

  maliit-framework = libsForQt5.callPackage ../applications/misc/maliit-framework { };

  maliit-keyboard = libsForQt5.callPackage ../applications/misc/maliit-keyboard { };

  maple-mono = (callPackage ../data/fonts/maple-font { }).Mono-v5;
  maple-mono-NF = (callPackage ../data/fonts/maple-font { }).Mono-NF-v5;

  mat2 = with python3.pkgs; toPythonApplication mat2;

  megasync = libsForQt5.callPackage ../applications/misc/megasync {
    ffmpeg = ffmpeg-full;
  };

  # while building documentation meson may want to run binaries for host
  # which needs an emulator
  # example of an error which this fixes
  # [Errno 8] Exec format error: './gdk3-scan'
  mesonEmulatorHook =
    if (!stdenv.buildPlatform.canExecute stdenv.targetPlatform) then
      makeSetupHook
        {
          name = "mesonEmulatorHook";
          substitutions = {
            crossFile = writeText "cross-file.conf" ''
              [binaries]
              exe_wrapper = ${lib.escapeShellArg (stdenv.targetPlatform.emulator buildPackages)}
            '';
          };
        } ../development/tools/build-managers/meson/emulator-hook.sh
    else throw "mesonEmulatorHook has to be in a conditional to check if the target binaries can be executed i.e. (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)";

  metabase = callPackage ../servers/metabase {
    jdk11 = jdk11_headless;
  };

  micropad = callPackage ../applications/office/micropad {
    electron = electron_17;
  };

  miniserve = callPackage ../tools/misc/miniserve {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mkspiffs-presets = recurseIntoAttrs (callPackages ../tools/filesystems/mkspiffs/presets.nix { });

  monado = callPackage ../applications/graphics/monado {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  mpd-discord-rpc = callPackage ../tools/audio/mpd-discord-rpc {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mrkd = with python3Packages; toPythonApplication mrkd;

  nix-template = callPackage ../tools/package-management/nix-template {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  nodepy-runtime = with python3.pkgs; toPythonApplication nodepy-runtime;

  nixpkgs-pytools = with python3.pkgs; toPythonApplication nixpkgs-pytools;

  noti = callPackage ../tools/misc/noti {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  nsz = with python3.pkgs; toPythonApplication nsz;

  ocrmypdf = with python3.pkgs; toPythonApplication ocrmypdf;

  online-judge-template-generator = python3Packages.callPackage ../tools/misc/online-judge-template-generator { };

  online-judge-tools = with python3.pkgs; toPythonApplication online-judge-tools;

  onnxruntime = callPackage ../development/libraries/onnxruntime {
    protobuf = protobuf3_19;
  };

  odafileconverter = libsForQt5.callPackage ../applications/graphics/odafileconverter {};

  pastel = callPackage ../applications/misc/pastel {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (ocamlPackages) patdiff;

  patool = with python3Packages; toPythonApplication patool;

  persepolis = python3Packages.callPackage ../tools/networking/persepolis {
    wrapQtAppsHook = qt5.wrapQtAppsHook;
  };

  pueue = callPackage ../applications/misc/pueue {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

  pixcat = with python3Packages; toPythonApplication pixcat;

  pyCA = python3Packages.callPackage ../applications/video/pyca {};

  pyznap = python3Packages.callPackage ../tools/backup/pyznap {};

  procs = darwin.apple_sdk_11_0.callPackage ../tools/admin/procs {
    inherit (darwin.apple_sdk_11_0.frameworks) Security;
    inherit (darwin.apple_sdk_11_0) Libsystem;
  };

  psrecord = python3Packages.callPackage ../tools/misc/psrecord {};

  rare = python3Packages.callPackage ../games/rare { };

  rmview = libsForQt5.callPackage ../applications/misc/remarkable/rmview { };

  remarkable-mouse = python3Packages.callPackage ../applications/misc/remarkable/remarkable-mouse { };

  ropgadget = with python3Packages; toPythonApplication ropgadget;

  scour = with python3Packages; toPythonApplication scour;

  sheldon = callPackage ../tools/misc/sheldon {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  sheesy-cli = callPackage ../tools/security/sheesy-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  srvc = callPackage ../applications/version-management/srvc {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  step-ca = callPackage ../tools/security/step-ca {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };

  stripe-cli = callPackage ../tools/admin/stripe-cli {
    buildGoModule = buildGo118Module; # tests fail with 1.19
  };

  swappy = callPackage ../applications/misc/swappy { gtk = gtk3; };

  synth = callPackage ../tools/misc/synth {
    inherit (darwin.apple_sdk.frameworks) AppKit Security;
  };

  inherit (callPackages ../servers/rainloop { })
    rainloop-community
    rainloop-standard;

  rav1e = callPackage ../tools/video/rav1e {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  razergenie = libsForQt5.callPackage ../applications/misc/razergenie { };

  ripasso-cursive = callPackage ../tools/security/ripasso/cursive.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Security;
  };

  roundcubePlugins = dontRecurseIntoAttrs (callPackage ../servers/roundcube/plugins { });

  routinator = callPackage ../servers/routinator {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rsyslog = callPackage ../tools/system/rsyslog {
    withHadoop = false; # Currently Broken
    withKsi = false; # Currently Broken
  };

  rsyslog-light = rsyslog.override {
    withKrb5 = false;
    withSystemd = false;
    withJemalloc = false;
    withMysql = false;
    withPostgres = false;
    withDbi = false;
    withNetSnmp = false;
    withUuid = false;
    withCurl = false;
    withGnutls = false;
    withGcrypt = false;
    withLognorm = false;
    withMaxminddb = false;
    withOpenssl = false;
    withRelp = false;
    withKsi = false;
    withLogging = false;
    withNet = false;
    withHadoop = false;
    withRdkafka = false;
    withMongo = false;
    withCzmq = false;
    withRabbitmq = false;
    withHiredis = false;
  };

  rtrtr = callPackage ../servers/rtrtr {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  xmlsort = perlPackages.XMLFilterSort;

  mcelog = callPackage ../os-specific/linux/mcelog {
    util-linux = util-linuxMinimal;
  };

  apc-temp-fetch = with python3.pkgs; callPackage ../tools/networking/apc-temp-fetch { };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (python3.pkgs) pygments matplotlib numpy aafigure recursivePthLoader;
    texlive = texlive.combine { inherit (texlive) scheme-minimal dvipng; };
    w3m = w3m-batch;
    enableStandardFeatures = false;
  };

  asciidoc-full = asciidoc.override {
    enableStandardFeatures = true;
  };

  asciidoc-full-with-plugins = asciidoc.override {
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  };

  asciidoctor = callPackage ../tools/typesetting/asciidoctor {
    bundlerApp = bundlerApp.override {
      # asciidoc supports both ruby 2 and 3,
      # but we don't want to be stuck on it:
      ruby = ruby_3_1;
    };
  };

  b2sum = callPackage ../tools/security/b2sum {
    inherit (llvmPackages) openmp;
  };

  bacula = callPackage ../tools/backup/bacula {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;
  };

  bacon = callPackage ../development/tools/bacon {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  bkcrack = callPackage ../tools/security/bkcrack {
    inherit (llvmPackages) openmp;
  };

  beamerpresenter = beamerpresenter-mupdf;

  beamerpresenter-mupdf = qt6Packages.callPackage ../applications/office/beamerpresenter {
    useMupdf = true;
    usePoppler = false;
  };

  beamerpresenter-poppler = qt6Packages.callPackage ../applications/office/beamerpresenter {
    useMupdf = false;
    usePoppler = true;
  };

  bee = callPackage ../applications/networking/bee/bee.nix {
    version = "release";
  };

  bee-unstable = bee.override {
    version = "unstable";
  };

  beetsPackages = lib.recurseIntoAttrs (callPackage ../tools/audio/beets { });
  inherit (beetsPackages) beets beets-unstable;

  xmlbird = callPackage ../tools/misc/birdfont/xmlbird.nix { stdenv = gccStdenv; };

  bsc = callPackage ../tools/compression/bsc {
    inherit (llvmPackages) openmp;
  };

  bzip3 = callPackage ../tools/compression/bzip3 {
    stdenv = clangStdenv;
  };

  davix = callPackage ../tools/networking/davix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  davix-copy = davix.override { enableThirdPartyCopy = true; };

  cantata = libsForQt5.callPackage ../applications/audio/cantata { };

  cdrtools = callPackage ../tools/cd-dvd/cdrtools {
    inherit (darwin.apple_sdk.frameworks) Carbon IOKit;
  };

  cemu-ti = qt5.callPackage ../applications/science/math/cemu-ti { };

  libceph = ceph.lib;
  inherit (callPackages ../tools/filesystems/ceph {
    lua = lua5_4;
    fmt = fmt_8;
  })
    ceph
    ceph-client;
  ceph-dev = ceph;

  inherit (callPackages ../tools/security/certmgr { })
    certmgr certmgr-selfsigned;

  chit = callPackage ../development/tools/chit {
    openssl = openssl_1_1;
  };

  clementine = libsForQt5.callPackage ../applications/audio/clementine {
    gst_plugins =
      with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav ];
    protobuf = protobuf3_19;
  };

  mellowplayer = libsForQt5.callPackage ../applications/audio/mellowplayer { };

  inherit (callPackage ../applications/networking/remote/citrix-workspace { })
    citrix_workspace_21_09_0
    citrix_workspace_21_12_0
    citrix_workspace_22_05_0
    citrix_workspace_22_07_0
    citrix_workspace_22_12_0
  ;
  citrix_workspace = citrix_workspace_22_12_0;

  cmst = libsForQt5.callPackage ../tools/networking/cmst { };

  hedgedoc = callPackage ../servers/web-apps/hedgedoc {
    inherit (callPackage ../development/tools/yarn2nix-moretea/yarn2nix {
      nodejs = nodejs-16_x;
    }) mkYarnPackage;
    nodejs = nodejs-16_x;
  };

  colord-gtk4 = colord-gtk.override { withGtk4 = true; };

  connmanPackages =
    recurseIntoAttrs (callPackage ../tools/networking/connman { });
  inherit (connmanPackages)
    connman
    connmanFull
    connmanMinimal
    connman_dmenu
    connman-gtk
    connman-ncurses
    connman-notify
  ;

  collectd = callPackage ../tools/system/collectd {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  crabz = callPackage ../tools/compression/crabz {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  unify = with python3Packages; toPythonApplication unify;

  inherit (nodePackages) uppy-companion;

  persistent-evdev = python3Packages.callPackage ../servers/persistent-evdev { };

  twitch-tui = callPackage ../applications/networking/instant-messengers/twitch-tui {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gebaar-libinput = callPackage ../tools/inputmethods/gebaar-libinput { stdenv = gcc10StdenvCompat; };

  inherit (import ../development/libraries/libsbsms pkgs)
    libsbsms
    libsbsms_2_0_2
    libsbsms_2_3_0
  ;

  libskk = callPackage ../development/libraries/libskk {
    inherit (gnome) gnome-common;
  };

  netbird = callPackage ../tools/networking/netbird {
    inherit (darwin.apple_sdk_11_0.frameworks) Cocoa IOKit Kernel UserNotifications WebKit;
  };

  netbird-ui = netbird.override {
    ui = true;
  };

  ibus-engines = recurseIntoAttrs {
    anthy = callPackage ../tools/inputmethods/ibus-engines/ibus-anthy { };

    bamboo = callPackage ../tools/inputmethods/ibus-engines/ibus-bamboo { };

    hangul = callPackage ../tools/inputmethods/ibus-engines/ibus-hangul { };

    kkc = callPackage ../tools/inputmethods/ibus-engines/ibus-kkc { };

    libpinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-libpinyin { };

    libthai = callPackage ../tools/inputmethods/ibus-engines/ibus-libthai { };

    m17n = callPackage ../tools/inputmethods/ibus-engines/ibus-m17n { };

    mozc = callPackage ../tools/inputmethods/ibus-engines/ibus-mozc {
      stdenv = clangStdenv;
      protobuf = pkgs.protobuf.overrideDerivation (_: { stdenv = clangStdenv; });
    };

    rime = callPackage ../tools/inputmethods/ibus-engines/ibus-rime { };

    table = callPackage ../tools/inputmethods/ibus-engines/ibus-table { };

    table-chinese = callPackage ../tools/inputmethods/ibus-engines/ibus-table-chinese {
      ibus-table = ibus-engines.table;
    };

    table-others = callPackage ../tools/inputmethods/ibus-engines/ibus-table-others {
      ibus-table = ibus-engines.table;
    };

    uniemoji = callPackage ../tools/inputmethods/ibus-engines/ibus-uniemoji { };

    typing-booster-unwrapped = callPackage ../tools/inputmethods/ibus-engines/ibus-typing-booster { };

    typing-booster = callPackage ../tools/inputmethods/ibus-engines/ibus-typing-booster/wrapper.nix {
      typing-booster = ibus-engines.typing-booster-unwrapped;
    };
  };

  interception-tools-plugins = {
    caps2esc = callPackage ../tools/inputmethods/interception-tools/caps2esc.nix { };
    dual-function-keys = callPackage ../tools/inputmethods/interception-tools/dual-function-keys.nix { };
  };

  age-plugin-yubikey = callPackage ../tools/security/age-plugin-yubikey {
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation PCSC;
  };

  bore = callPackage ../tools/networking/bore {
    inherit (darwin) Libsystem;
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

  bluetooth_battery = python3Packages.callPackage ../applications/misc/bluetooth_battery { };

  calyx-vpn = libsForQt5.callPackage ../tools/networking/bitmask-vpn {
    provider = "calyx";
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  cask-server = libsForQt5.callPackage ../applications/misc/cask-server { };

  code-browser-qt = libsForQt5.callPackage ../applications/editors/code-browser { withQt = true; };
  code-browser-gtk2 = callPackage ../applications/editors/code-browser { withGtk2 = true; };
  code-browser-gtk = callPackage ../applications/editors/code-browser { withGtk3 = true; };

  chafa = callPackage ../tools/misc/chafa {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  ckb-next = libsForQt5.callPackage ../tools/misc/ckb-next { };

  clamav = callPackage ../tools/security/clamav {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  cloog = callPackage ../development/libraries/cloog {
    isl = isl_0_14;
  };

  cloog_0_18_0 = callPackage ../development/libraries/cloog/0.18.0.nix {
    isl = isl_0_11;
  };

  cmdpack = callPackages ../tools/misc/cmdpack { };

  cobalt = callPackage ../applications/misc/cobalt {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  cobang = python3Packages.callPackage ../applications/misc/cobang {
    gst-plugins-good = gst_all_1.gst-plugins-good.override { gtkSupport = true; };
  };

  cocoapods = callPackage ../development/tools/cocoapods { };

  cocoapods-beta = lowPrio (callPackage ../development/tools/cocoapods { beta = true; });

  cocom = callPackage ../tools/networking/cocom {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  cone = callPackage ../development/compilers/cone {
    llvmPackages = llvmPackages_7;
  };

  coreutils-full = coreutils.override { minimal = false; };
  coreutils-prefixed = coreutils.override { withPrefix = true; singleBinary = false; };

  create-cycle-app = nodePackages.create-cycle-app;

  cromfs = callPackage ../tools/archivers/cromfs {
    stdenv = gcc10StdenvCompat;
  };

  cudaPackages_10_0 = callPackage ./cuda-packages.nix { cudaVersion = "10.0"; };
  cudaPackages_10_1 = callPackage ./cuda-packages.nix { cudaVersion = "10.1"; };
  cudaPackages_10_2 = callPackage ./cuda-packages.nix { cudaVersion = "10.2"; };
  cudaPackages_10 = cudaPackages_10_2;

  cudaPackages_11_0 = callPackage ./cuda-packages.nix { cudaVersion = "11.0"; };
  cudaPackages_11_1 = callPackage ./cuda-packages.nix { cudaVersion = "11.1"; };
  cudaPackages_11_2 = callPackage ./cuda-packages.nix { cudaVersion = "11.2"; };
  cudaPackages_11_3 = callPackage ./cuda-packages.nix { cudaVersion = "11.3"; };
  cudaPackages_11_4 = callPackage ./cuda-packages.nix { cudaVersion = "11.4"; };
  cudaPackages_11_5 = callPackage ./cuda-packages.nix { cudaVersion = "11.5"; };
  cudaPackages_11_6 = callPackage ./cuda-packages.nix { cudaVersion = "11.6"; };
  cudaPackages_11_7 = callPackage ./cuda-packages.nix { cudaVersion = "11.7"; };
  cudaPackages_11_8 = callPackage ./cuda-packages.nix { cudaVersion = "11.8"; };
  cudaPackages_11 = cudaPackages_11_7;

  cudaPackages_12_0 = callPackage ./cuda-packages.nix { cudaVersion = "12.0"; };
  cudaPackages_12 = cudaPackages_12_0;

  # TODO: try upgrading once there is a cuDNN release supporting CUDA 12. No
  # such cuDNN release as of 2023-01-10.
  cudaPackages = recurseIntoAttrs cudaPackages_11;

  # TODO: move to alias
  cudatoolkit = cudaPackages.cudatoolkit;
  cudatoolkit_11 = cudaPackages_11.cudatoolkit;

  curlFull = curl.override {
    ldapSupport = true;
    gsaslSupport = true;
    rtmpSupport = true;
    pslSupport = true;
  };

  curlHTTP3 = curl.override {
    openssl = quictls;
    http3Support = true;
  };

  curl = curlMinimal.override ({
    idnSupport = true;
    zstdSupport = true;
  } // lib.optionalAttrs (!stdenv.hostPlatform.isStatic) {
    gssSupport = true;
    brotliSupport = true;
  });

  curlWithGnuTls = curl.override { gnutlsSupport = true; opensslSupport = false; };

  cve-bin-tool = python3Packages.callPackage ../tools/security/cve-bin-tool { };

  dar = callPackage ../tools/backup/dar {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  deno = callPackage ../development/web/deno {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks)
      Security CoreServices Metal Foundation QuartzCore;
  };

  devilspie2 = callPackage ../applications/misc/devilspie2 {
    gtk = gtk3;
  };

  ddcui = libsForQt5.callPackage ../applications/misc/ddcui { };

  inherit (callPackages ../applications/networking/p2p/deluge {
    libtorrent-rasterbar = libtorrent-rasterbar-1_2_x;
  })
    deluge-gtk
    deluged
    deluge;

  deluge-2_x = deluge;

  dnsviz = python3Packages.callPackage ../tools/networking/dnsviz { };

  diffoscopeMinimal = callPackage ../tools/misc/diffoscope {
    jdk = jdk8;
  };

  diffoscope = diffoscopeMinimal.override {
    enableBloat = !stdenv.isDarwin;
  };

  diffr = callPackage ../tools/text/diffr {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  dir2opus = callPackage ../tools/audio/dir2opus {
    inherit (python2Packages) mutagen python wrapPython;
  };

  dirdiff = callPackage ../tools/text/dirdiff {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  dmd = callPackage ../development/compilers/dmd {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  doctave = callPackage ../applications/misc/doctave {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  dogdns = callPackage ../tools/networking/dogdns {
    openssl = openssl_1_1;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  doggo = callPackage ../tools/networking/doggo {
    buildGoModule = buildGo118Module; # build fails with 1.19
  };

  doomseeker = qt5.callPackage ../applications/misc/doomseeker { };

  sl1-to-photon = python3Packages.callPackage ../applications/misc/sl1-to-photon { };

  slade = callPackage ../applications/misc/slade {
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  sladeUnstable = callPackage ../applications/misc/slade/git.nix {
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  drill = callPackage ../tools/networking/drill {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  drone = callPackage ../development/tools/continuous-integration/drone { };
  drone-oss = callPackage ../development/tools/continuous-integration/drone {
    enableUnfree = false;
  };

  dsview = libsForQt5.callPackage ../applications/science/electronics/dsview { };

  dt-schema = python3Packages.callPackage ../development/tools/dt-schema { };

  duff = callPackage ../tools/filesystems/duff {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  dump_syms = callPackage ../development/tools/dump_syms {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  dvtm = callPackage ../tools/misc/dvtm {
    # if you prefer a custom config, write the config.h in dvtm.config.h
    # and enable
    # customConfig = builtins.readFile ./dvtm.config.h;
  };

  dvtm-unstable = callPackage ../tools/misc/dvtm/unstable.nix {};

  eid-mw = callPackage ../tools/security/eid-mw {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  engauge-digitizer = libsForQt5.callPackage ../applications/science/math/engauge-digitizer { };

  luckybackup = libsForQt5.callPackage ../tools/backup/luckybackup {
    ssh = openssh;
  };

  lychee = callPackage ../tools/networking/lychee {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mozillavpn = qt6Packages.callPackage ../tools/networking/mozillavpn { };

  mozwire = callPackage ../tools/networking/mozwire {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pax = callPackage ../tools/archivers/pax {
    inherit (pkgs.darwin.apple_sdk.libs) utmp;
  };

  rage = callPackage ../tools/security/rage {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  solo2-cli = callPackage ../tools/security/solo2-cli {
    inherit (darwin.apple_sdk.frameworks) PCSC IOKit CoreFoundation AppKit;
  };

  strawberry = libsForQt5.callPackage ../applications/audio/strawberry { };

  schildichat-desktop = callPackage ../applications/networking/instant-messengers/schildichat/schildichat-desktop.nix {
    inherit (darwin.apple_sdk.frameworks) Security AppKit CoreServices;
    electron = electron_20;
  };
  schildichat-desktop-wayland = writeScriptBin "schildichat-desktop" ''
    #!/bin/sh
    NIXOS_OZONE_WL=1 exec ${schildichat-desktop}/bin/schildichat-desktop "$@"
  '';

  schildichat-web = callPackage ../applications/networking/instant-messengers/schildichat/schildichat-web.nix {
    conf = config.schildichat-web.conf or {};
  };

  tealdeer = callPackage ../tools/misc/tealdeer {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tsm-client = callPackage ../tools/backup/tsm-client {
    openssl = openssl_1_1;
  };
  tsm-client-withGui = callPackage ../tools/backup/tsm-client {
    openssl = openssl_1_1;
    enableGui = true;
  };

  tracy = callPackage ../development/tools/tracy {
    inherit (darwin.apple_sdk.frameworks) Carbon AppKit;
  };

  uusi = haskell.lib.compose.justStaticExecutables haskellPackages.uusi;

  uutils-coreutils = callPackage ../tools/misc/uutils-coreutils {
    inherit (python3Packages) sphinx;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  vorta = libsForQt5.callPackage ../applications/backup/vorta { };

  worker-build = callPackage ../development/tools/worker-build {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (nodePackages) wrangler;

  wrangler_1 = callPackage ../development/tools/wrangler_1 {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Security;
  };

  xkcdpass = with python3Packages; toPythonApplication xkcdpass;

  zee = callPackage ../applications/editors/zee {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  zonemaster-cli = perlPackages.ZonemasterCLI;

  ### DEVELOPMENT / EMSCRIPTEN

  emscripten = callPackage ../development/compilers/emscripten {
    llvmPackages = llvmPackages_14;
  };

  emscriptenPackages = recurseIntoAttrs (callPackage ./emscripten-packages.nix { });

  emscriptenStdenv = stdenv // { mkDerivation = buildEmscriptenPackage; };

  # The latest version used by elasticsearch, logstash, kibana and the the beats from elastic.
  # When updating make sure to update all plugins or they will break!
  elk6Version = "6.8.21";
  elk7Version = "7.17.4";

  elasticsearch6 = callPackage ../servers/search/elasticsearch/6.x.nix {
    util-linux = util-linuxMinimal;
    jre_headless = jre8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  elasticsearch6-oss = callPackage ../servers/search/elasticsearch/6.x.nix {
    enableUnfree = false;
    util-linux = util-linuxMinimal;
    jre_headless = jre8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  elasticsearch7 = callPackage ../servers/search/elasticsearch/7.x.nix {
    util-linux = util-linuxMinimal;
    jre_headless = jdk11_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  elasticsearch = elasticsearch6;
  elasticsearch-oss = elasticsearch6-oss;

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ../servers/search/elasticsearch/plugins.nix {
      elasticsearch = elasticsearch-oss;
    }
  );
  elasticsearch6Plugins = elasticsearchPlugins.override {
    elasticsearch = elasticsearch6-oss;
  };
  elasticsearch7Plugins = elasticsearchPlugins.override {
    elasticsearch = elasticsearch7;
  };

  emborg = python3Packages.callPackage ../development/python-modules/emborg { };

  emulsion = callPackage ../applications/graphics/emulsion {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreGraphics CoreServices Foundation OpenGL;
  };

  enblend-enfuse = callPackage ../tools/graphics/enblend-enfuse {
    boost = boost172;
  };

  ericw-tools = callPackage ../applications/misc/ericw-tools { stdenv = gcc10StdenvCompat; };

  encfs = callPackage ../tools/filesystems/encfs {
    tinyxml2 = tinyxml-2;
  };

  ensemble-chorus = callPackage ../applications/audio/ensemble-chorus { stdenv = gcc8Stdenv; };

  envchain = callPackage ../tools/misc/envchain { inherit (darwin.apple_sdk.frameworks) Security; };

  etcher = callPackage ../tools/misc/etcher {
    electron = electron_12;
  };

  ethercalc = callPackage ../servers/web-apps/ethercalc { };

  evillimiter = python3Packages.callPackage ../tools/networking/evillimiter { };

  evtest-qt = libsForQt5.callPackage ../applications/misc/evtest-qt { };

  exa = callPackage ../tools/misc/exa {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  executor = with python3Packages; toPythonApplication executor;

  exiftool = perlPackages.ImageExifTool;

  Fabric = with python3Packages; toPythonApplication Fabric;

  fcitx = callPackage ../tools/inputmethods/fcitx {
    plugins = [];
  };

  fcitx-engines = recurseIntoAttrs {

    anthy = callPackage ../tools/inputmethods/fcitx-engines/fcitx-anthy { };

    chewing = callPackage ../tools/inputmethods/fcitx-engines/fcitx-chewing { };

    hangul = callPackage ../tools/inputmethods/fcitx-engines/fcitx-hangul { };

    unikey = callPackage ../tools/inputmethods/fcitx-engines/fcitx-unikey { };

    rime = callPackage ../tools/inputmethods/fcitx-engines/fcitx-rime { };

    m17n = callPackage ../tools/inputmethods/fcitx-engines/fcitx-m17n { };

    mozc = callPackage ../tools/inputmethods/fcitx-engines/fcitx-mozc {
      python = python2;
      inherit (python2Packages) gyp;
      protobuf = pkgs.protobuf3_8.overrideDerivation (_: { stdenv = clangStdenv; });
    };

    table-extra = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-extra { };

    table-other = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-other { };

    cloudpinyin = callPackage ../tools/inputmethods/fcitx-engines/fcitx-cloudpinyin { };

    libpinyin = libsForQt5.callPackage ../tools/inputmethods/fcitx-engines/fcitx-libpinyin { };

    skk = callPackage ../tools/inputmethods/fcitx-engines/fcitx-skk { };
  };

  chewing-editor = libsForQt5.callPackage ../applications/misc/chewing-editor { };

  fcitx5 = libsForQt5.callPackage ../tools/inputmethods/fcitx5 { };

  fcitx5-with-addons = libsForQt5.callPackage ../tools/inputmethods/fcitx5/with-addons.nix { };

  fcitx5-chinese-addons = libsForQt5.callPackage ../tools/inputmethods/fcitx5/fcitx5-chinese-addons.nix { };

  fcitx5-mozc = libsForQt5.callPackage ../tools/inputmethods/fcitx5/fcitx5-mozc.nix {
    abseil-cpp = abseil-cpp.override {
      cxxStandard = "17";
    };
  };

  fcitx5-unikey = libsForQt5.callPackage ../tools/inputmethods/fcitx5/fcitx5-unikey.nix { };

  fcitx5-configtool = libsForQt5.callPackage ../tools/inputmethods/fcitx5/fcitx5-configtool.nix { };

  fcitx5-lua = callPackage ../tools/inputmethods/fcitx5/fcitx5-lua.nix { lua = lua5_3; };

  featherpad = qt5.callPackage ../applications/editors/featherpad {};

  feroxbuster = callPackage ../tools/security/feroxbuster {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ffsend = callPackage ../tools/misc/ffsend {
    inherit (darwin.apple_sdk.frameworks) Security AppKit;
  };

  flatpak = callPackage ../development/libraries/flatpak { };

  flatpak-builder = callPackage ../development/tools/flatpak-builder {
    binutils = binutils-unwrapped;
  };

  fltrdr = callPackage ../tools/misc/fltrdr {
    icu = icu63;
  };

  file = callPackage ../tools/misc/file {
    inherit (windows) libgnurx;
  };

  findomain = callPackage ../tools/networking/findomain {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bsd-fingerd = bsd-finger.override({ buildClient = false; });

  flent = python3Packages.callPackage ../applications/networking/flent { };

  hmetis = pkgsi686Linux.callPackage ../applications/science/math/hmetis { };

  libbtbb = callPackage ../development/libraries/libbtbb {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  lp_solve = callPackage ../applications/science/math/lp_solve {
    inherit (darwin) cctools autoSignDarwinBinariesHook;
  };

  fmbt = callPackage ../development/tools/fmbt {
    python = python2;
  };

  fontforge = lowPrio (callPackage ../tools/misc/fontforge {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    python = python3;
  });
  fontforge-gtk = fontforge.override {
    withSpiro = true;
    withGTK = true;
    gtk3 = gtk3-x11;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  fontmatrix = libsForQt5.callPackage ../applications/graphics/fontmatrix {};

  fox = callPackage ../development/libraries/fox {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  ferdi = callPackage ../applications/networking/instant-messengers/ferdi {
    mkFranzDerivation = callPackage ../applications/networking/instant-messengers/franz/generic.nix { };
  };

  ferdium = callPackage ../applications/networking/instant-messengers/ferdium {
    mkFranzDerivation = callPackage ../applications/networking/instant-messengers/franz/generic.nix { };
  };

  franz = callPackage ../applications/networking/instant-messengers/franz {
    mkFranzDerivation = callPackage ../applications/networking/instant-messengers/franz/generic.nix { };
  };

  freetalk = callPackage ../applications/networking/instant-messengers/freetalk {
    guile = guile_2_0;
  };

  freqtweak = callPackage ../applications/audio/freqtweak {
    wxGTK = wxGTK32;
  };

  frescobaldi = python3Packages.callPackage ../misc/frescobaldi {};

  freshfetch = callPackage ../tools/misc/freshfetch {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreFoundation DiskArbitration Foundation IOKit;
  };

  fstl = qt5.callPackage ../applications/graphics/fstl { };

  fdbPackages = dontRecurseIntoAttrs (callPackage ../servers/foundationdb {
    openjdk = openjdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    libressl = libressl_3_4;
  });

  inherit (fdbPackages)
    foundationdb51
    foundationdb52
    foundationdb60
    foundationdb61
  ;

  foundationdb = foundationdb61;

  fwknop = callPackage ../tools/security/fwknop {
    texinfo = texinfo6_7; # Uses @setcontentsaftertitlepage, removed in 6.8.
  };

  galculator = callPackage ../applications/misc/galculator {
    gtk = gtk3;
  };

  gallery-dl = python3Packages.callPackage ../applications/misc/gallery-dl { };

  gandi-cli = python3Packages.callPackage ../tools/networking/gandi-cli { };

  gaphor = python3Packages.callPackage ../tools/misc/gaphor { };

  inherit (callPackage ../tools/filesystems/garage {
    inherit (darwin.apple_sdk.frameworks) Security;
  })
    garage
      garage_0_7 garage_0_8
      garage_0_7_3 garage_0_8_0;

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

  gawk-with-extensions = callPackage ../tools/text/gawk/gawk-with-extensions.nix {
    extensions = gawkextlib.full;
  };

  gawkInteractive = gawk.override { interactive = true; };

  gbdfed = callPackage ../tools/misc/gbdfed {
    gtk = gtk2-x11;
  };

  gftp = callPackage ../applications/networking/ftp/gftp {
    gtk = gtk2;
  };

  gibberish-detector = with python3Packages; toPythonApplication gibberish-detector;

  github-runner = callPackage ../development/tools/continuous-integration/github-runner {
     inherit (darwin) autoSignDarwinBinariesHook;
  };

  gitlab = callPackage ../applications/version-management/gitlab {
    openssl = openssl_1_1;
  };
  gitlab-ee = callPackage ../applications/version-management/gitlab {
    openssl = openssl_1_1;
    gitlabEnterprise = true;
  };

  gitlab-workhorse = callPackage ../applications/version-management/gitlab/gitlab-workhorse { };

  gitqlient = libsForQt5.callPackage ../applications/version-management/gitqlient { };

  gitea = callPackage ../applications/version-management/gitea { };

  forgejo = callPackage ../applications/version-management/forgejo {};

  glogg = libsForQt5.callPackage ../tools/text/glogg { };

  gmrender-resurrect = callPackage ../tools/networking/gmrender-resurrect {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav;
  };

  gnome-decoder = callPackage ../applications/graphics/gnome-decoder {
     inherit (gst_all_1) gstreamer gst-plugins-base;
     gst-plugins-bad = gst_all_1.gst-plugins-bad.override { enableZbar = true; };
  };

  dapl = callPackage ../development/interpreters/dzaima-apl {
    buildNativeImage = false;
    stdenv = stdenvNoCC;
    jdk = jre;
  };
  dapl-native = callPackage ../development/interpreters/dzaima-apl {
    buildNativeImage = true;
    jdk = graalvm11-ce;
  };

  gnufdisk = callPackage ../tools/system/fdisk {
    guile = guile_1_8;
  };

  gnupg1 = gnupg1compat;    # use config.packageOverrides if you prefer original gnupg1
  gnupg23 = callPackage ../tools/security/gnupg/23.nix {
    guiSupport = stdenv.isDarwin;
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry-gtk2;
  };
  gnupg = gnupg23;

  gnuplot = libsForQt5.callPackage ../tools/graphics/gnuplot {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  gnuplot_qt = gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };

  # rename to upower-notify?

  goattracker = callPackage ../applications/audio/goattracker { };

  goattracker-stereo = callPackage ../applications/audio/goattracker {
    isStereo = true;
  };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk {
    python = python3;
  };
  google-cloud-sdk-gce = google-cloud-sdk.override {
    python = python38;
    with-gce = true;
  };

  google-clasp = nodePackages."@google/clasp";

  google-compute-engine = with python38.pkgs; toPythonApplication google-compute-engine;

  gdown = with python3Packages; toPythonApplication gdown;

  goverlay = callPackage ../tools/graphics/goverlay {
    inherit (qt5) wrapQtAppsHook;
    inherit (plasma5Packages) breeze-qt5;
  };

  gpredict = callPackage ../applications/science/astronomy/gpredict {
    hamlib = hamlib_4;
  };

  gprof2dot = with python3Packages; toPythonApplication gprof2dot;

  grails = callPackage ../development/web/grails { jdk = null; };

  graylogPlugins = recurseIntoAttrs (
    callPackage ../tools/misc/graylog/plugins.nix { }
  );

  graphviz = callPackage ../tools/graphics/graphviz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  graphviz-nox = callPackage ../tools/graphics/graphviz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
    withXorg = false;
    libdevil = libdevil-nox;
  };

  igrep = callPackage ../tools/text/igrep {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ripgrep = callPackage ../tools/text/ripgrep {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ripgrep-all = callPackage ../tools/text/ripgrep-all {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ucg = callPackage ../tools/text/ucg { stdenv = gcc10StdenvCompat; };

  gromit-mpx = callPackage ../tools/graphics/gromit-mpx {
    gtk = gtk3;
    libappindicator = libappindicator-gtk3;
  };

  grub = pkgsi686Linux.callPackage ../tools/misc/grub ({
    stdenv = overrideCC stdenv buildPackages.pkgsi686Linux.gcc6;
  } // (config.grub or {}));

  trustedGrub = pkgsi686Linux.callPackage ../tools/misc/grub/trusted.nix { };

  trustedGrub-for-HP = pkgsi686Linux.callPackage ../tools/misc/grub/trusted.nix { for_HP_laptop = true; };

  grub2 = grub2_full;

  grub2_full = callPackage ../tools/misc/grub/2.0x.nix {
    # update breaks grub2
    gnulib = pkgs.gnulib.overrideAttrs (_: rec {
      version = "20200223";
      src = fetchgit {
        url = "https://git.savannah.gnu.org/r/gnulib.git";
        rev = "292fd5d6ff5ecce81ec3c648f353732a9ece83c0";
        sha256 = "0hkg3nql8nsll0vrqk4ifda0v4kpi67xz42r8daqsql6c4rciqnw";
      };
    });
  };

  grub2_efi = grub2.override {
    efiSupport = true;
  };

  grub2_light = grub2.override {
    zfsSupport = false;
  };

  grub2_xen = grub2_full.override {
    xenSupport = true;
  };

  grub4dos = callPackage ../tools/misc/grub4dos {
    stdenv = stdenv_32bit;
  };

  gruut = with python3.pkgs; toPythonApplication gruut;

  gruut-ipa = with python3.pkgs; toPythonApplication gruut-ipa;

  sbsigntool = callPackage ../tools/security/sbsigntool {
    openssl = openssl_1_1;
  };

  gsmlib = callPackage ../development/libraries/gsmlib
    { stdenv = gcc10StdenvCompat; autoreconfHook = buildPackages.autoreconfHook269; };

  gtkd = callPackage ../development/libraries/gtkd { dcompiler = ldc; };

  gvm-tools = with python3.pkgs; toPythonApplication gvm-tools;

  pdisk = callPackage ../tools/system/pdisk {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;
  };

  plplot = callPackage ../development/libraries/plplot {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  h5utils = callPackage ../tools/misc/h5utils {
    libmatheval = null;
    hdf4 = null;
  };

  habitat = callPackage ../applications/networking/cluster/habitat {
    openssl = openssl_1_1;
  };

  hash_extender = callPackage ../tools/security/hash_extender {
    openssl = openssl_1_1;
  };

  hassil = with python3Packages; toPythonApplication hassil;

  hatch = python3Packages.callPackage ../development/tools/hatch { };

  hal-hardware-analyzer = libsForQt5.callPackage ../applications/science/electronics/hal-hardware-analyzer { };

  halide = callPackage ../development/compilers/halide {
    llvmPackages = llvmPackages_14;
  };

  harePackages = recurseIntoAttrs (callPackage ../development/compilers/hare { });

  ham = pkgs.perlPackages.ham;

  hdf5 = callPackage ../tools/misc/hdf5 {
    fortranSupport = false;
    fortran = gfortran;
  };

  hdf5-mpi = hdf5.override { mpiSupport = true; };

  hdf5-cpp = hdf5.override { cppSupport = true; };

  hdf5-fortran = hdf5.override { fortranSupport = true; };

  hdf5-threadsafe = hdf5.override { threadsafe = true; };

  heaptrack = libsForQt5.callPackage ../development/tools/profiling/heaptrack {};

  heimdall = libsForQt5.callPackage ../tools/misc/heimdall { };

  heimdall-gui = heimdall.override { enableGUI = true; };

  hobbits = libsForQt5.callPackage ../tools/graphics/hobbits { };

  highlight = callPackage ../tools/text/highlight ({
    lua = lua5;
  });

  hockeypuck = callPackage ../servers/hockeypuck/server.nix { };

  hockeypuck-web = callPackage ../servers/hockeypuck/web.nix { };

  host = bind.host;

  hotspot = libsForQt5.callPackage ../development/tools/analysis/hotspot { };

  hpccm = with python3Packages; toPythonApplication hpccm;

  hqplayer-desktop = libsForQt5.callPackage ../applications/audio/hqplayer-desktop { };

  htmlq = callPackage ../development/tools/htmlq {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  http-prompt = callPackage ../tools/networking/http-prompt { };

  httpie = with python3Packages; toPythonApplication httpie;

  httplz = callPackage ../tools/networking/httplz {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  humanfriendly = with python3Packages; toPythonApplication humanfriendly;

  hw-probe = perlPackages.callPackage ../tools/system/hw-probe { };

  hybridreverb2 = callPackage ../applications/audio/hybridreverb2 {
    stdenv = gcc8Stdenv;
  };

  iannix = libsForQt5.callPackage ../applications/audio/iannix { };

  iaito = libsForQt5.callPackage ../tools/security/iaito { };

  jamulus = libsForQt5.callPackage ../applications/audio/jamulus { };

  icemon = libsForQt5.callPackage ../applications/networking/icemon { };

  icepeak = haskell.lib.compose.justStaticExecutables haskellPackages.icepeak;

  ifcopenshell = with python3Packages; toPythonApplication ifcopenshell;

  ifwifi = callPackage ../tools/networking/ifwifi {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../tools/filesystems/irods rec {
    stdenv = llvmPackages.libcxxStdenv;
    libcxx = llvmPackages.libcxx;
    boost = boost17x.override { inherit stdenv; };
    fmt = fmt_8.override { inherit stdenv; };
    nanodbc_llvm = nanodbc.override { inherit stdenv; };
    avro-cpp_llvm = avro-cpp.override { inherit stdenv boost; };
  })
    irods
    irods-icommands;

  ihaskell = callPackage ../development/tools/haskell/ihaskell/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;

    jupyter = python3.withPackages (ps: [ ps.jupyter ps.notebook ]);

    packages = config.ihaskell.packages or (_: []);
  };

  innernet = callPackage ../tools/networking/innernet {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  input-remapper = python3Packages.callPackage ../tools/inputmethods/input-remapper { };

  internetarchive = with python3Packages; toPythonApplication internetarchive;

  invidious = callPackage ../servers/invidious {
    # needs a specific version of lsquic
    lsquic = callPackage ../servers/invidious/lsquic.nix { };
    # normally video.js is downloaded at build time
    videojs = callPackage ../servers/invidious/videojs.nix { };
  };

  iperf = iperf3;

  ipget = callPackage ../applications/networking/ipget {
    buildGoModule = buildGo118Module; # build fails with 1.19
  };

  i-pi = with python3Packages; toPythonApplication i-pi;

  isl = isl_0_20;
  isl_0_11 = callPackage ../development/libraries/isl/0.11.1.nix { };
  isl_0_14 = callPackage ../development/libraries/isl/0.14.1.nix { };
  isl_0_17 = callPackage ../development/libraries/isl/0.17.1.nix { };
  isl_0_20 = callPackage ../development/libraries/isl/0.20.0.nix { };
  isl_0_24 = callPackage ../development/libraries/isl/0.24.0.nix { };

  ispike = callPackage ../development/libraries/science/robotics/ispike {
    boost = boost16x;
  };

  isrcsubmit = callPackage ../tools/audio/isrcsubmit { stdenv = gcc10StdenvCompat; };

  isync = callPackage ../tools/networking/isync {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  jamesdsp = libsForQt5.callPackage ../applications/audio/jamesdsp { };
  jamesdsp-pulse = libsForQt5.callPackage ../applications/audio/jamesdsp {
    usePipewire = false;
    usePulseaudio = true;
  };

  jaq = callPackage ../development/tools/jaq {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  jc = with python3Packages; toPythonApplication jc;

  jing = res.jing-trang;
  jing-trang = callPackage ../tools/text/xml/jing-trang {
    jdk_headless = jdk8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  jl = haskellPackages.callPackage ../development/tools/jl { };

  jless = callPackage ../development/tools/jless {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  joplin = nodePackages.joplin;

  jpylyzer = with python3Packages; toPythonApplication jpylyzer;

  jsbeautifier = with python3Packages; toPythonApplication jsbeautifier;

  json-schema-for-humans = with python3Packages; toPythonApplication json-schema-for-humans;

  jsonwatch = callPackage ../tools/misc/jsonwatch {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  wrapKakoune = kakoune: attrs: callPackage ../applications/editors/kakoune/wrapper.nix (attrs // { inherit kakoune; });
  kakounePlugins = recurseIntoAttrs (callPackage ../applications/editors/kakoune/plugins { });

  kakoune-unwrapped = callPackage ../applications/editors/kakoune {
    # See comments on https://github.com/NixOS/nixpkgs/pull/198836
    # Remove below when stdenv for linux-aarch64 become recent enough.
    stdenv = if stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU then gcc11Stdenv else stdenv;
  };
  kakoune = wrapKakoune kakoune-unwrapped {
    plugins = [ ];  # override with the list of desired plugins
  };

  kaffeine = libsForQt5.callPackage ../applications/video/kaffeine { };

  kak-lsp = callPackage ../tools/misc/kak-lsp {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  kakoune-cr = callPackage ../tools/misc/kakoune-cr { crystal = crystal_1_2; };

  kbs2 = callPackage ../tools/security/kbs2 {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  kdash = callPackage ../development/tools/kdash {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  kdbplus = pkgsi686Linux.callPackage ../applications/misc/kdbplus { };

  kdiskmark = libsForQt5.callPackage ../tools/filesystems/kdiskmark { };

  keepkey_agent = with python3Packages; toPythonApplication keepkey_agent;

  keybase = callPackage ../tools/security/keybase {
    # Reasoning for the inherited apple_sdk.frameworks:
    # 1. specific compiler errors about: AVFoundation, AudioToolbox, MediaToolbox
    # 2. the rest are added from here: https://github.com/keybase/client/blob/68bb8c893c5214040d86ea36f2f86fbb7fac8d39/go/chat/attachments/preview_darwin.go#L7
    #      #cgo LDFLAGS: -framework AVFoundation -framework CoreFoundation -framework ImageIO -framework CoreMedia  -framework Foundation -framework CoreGraphics -lobjc
    #    with the exception of CoreFoundation, due to the warning in https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-sdk/frameworks.nix#L25
    inherit (darwin.apple_sdk.frameworks) AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox;
  };

  keyscope = callPackage ../tools/security/keyscope {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation IOKit Security;
  };

  keystore-explorer = callPackage ../applications/misc/keystore-explorer {
    jdk = jdk11;
  };

  kibana = kibana7;

  kio-fuse = libsForQt5.callPackage ../tools/filesystems/kio-fuse { };

  kore = callPackage ../development/web/kore {
    openssl = openssl_1_1;
  };

  partition-manager = libsForQt5.callPackage ../tools/misc/partition-manager { };

  kphotoalbum = libsForQt5.callPackage ../applications/graphics/kphotoalbum { };

  krename = libsForQt5.callPackage ../applications/misc/krename { };

  krunner-pass = libsForQt5.callPackage ../tools/security/krunner-pass { };

  krunvm = callPackage ../applications/virtualization/krunvm {
    inherit (darwin) sigtool;
  };

  kronometer = libsForQt5.callPackage ../tools/misc/kronometer { };

  kdiff3 = libsForQt5.callPackage ../tools/text/kdiff3 { };

  kwalletcli = libsForQt5.callPackage ../tools/security/kwalletcli { };

  peruse = libsForQt5.callPackage ../tools/misc/peruse { };

  ksmoothdock = libsForQt5.callPackage ../applications/misc/ksmoothdock { };

  kstars = libsForQt5.callPackage ../applications/science/astronomy/kstars { };

  ligo = callPackage ../development/compilers/ligo {
    coq = coq_8_14;
  };

  ldgallery = callPackage ../tools/graphics/ldgallery {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  leocad = libsForQt5.callPackage ../applications/graphics/leocad { };

  libcoap = callPackage ../applications/networking/libcoap {
    autoconf = buildPackages.autoconf269;
  };

  libcryptui = callPackage ../development/libraries/libcryptui {
    autoreconfHook = buildPackages.autoreconfHook269;
    gtk3 = if stdenv.isDarwin then gtk3-x11 else gtk3;
  };

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix {
    ffmpeg = ffmpeg-full;
  };

  lnx = callPackage ../servers/search/lnx {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
  };

  logstash6 = callPackage ../tools/misc/logstash/6.x.nix {
    # https://www.elastic.co/support/matrix#logstash-and-jvm
    jre = jdk11_headless;
  };
  logstash6-oss = callPackage ../tools/misc/logstash/6.x.nix {
    enableUnfree = false;
    # https://www.elastic.co/support/matrix#logstash-and-jvm
    jre = jdk11_headless;
  };
  logstash7 = callPackage ../tools/misc/logstash/7.x.nix {
    # https://www.elastic.co/support/matrix#logstash-and-jvm
    jre = jdk11_headless;
  };
  logstash7-oss = callPackage ../tools/misc/logstash/7.x.nix {
    enableUnfree = false;
    # https://www.elastic.co/support/matrix#logstash-and-jvm
    jre = jdk11_headless;
  };
  logstash = logstash6;

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    inherit (darwin) xnu;
    lua = lua5_2_compat;
  };

  kdbg = libsForQt5.callPackage ../development/tools/misc/kdbg { };

  kristall = libsForQt5.callPackage ../applications/networking/browsers/kristall { };

  lagrange = callPackage ../applications/networking/browsers/lagrange {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };
  lagrange-tui = lagrange.override { enableTUI = true; };

  kzipmix = pkgsi686Linux.callPackage ../tools/compression/kzipmix { };

  /* Python 3.8 is currently broken with matrix-synapse since `python38Packages.bleach` fails
    (https://github.com/NixOS/nixpkgs/issues/76093) */

  matrix-synapse-plugins = recurseIntoAttrs matrix-synapse.plugins;

  matrix-synapse-tools = recurseIntoAttrs matrix-synapse.tools;

  mautrix-signal = recurseIntoAttrs (callPackage ../servers/mautrix-signal { });

  mautrix-telegram = recurseIntoAttrs (callPackage ../servers/mautrix-telegram { });

  m2r = with python3Packages; toPythonApplication m2r;

  md2gemini = with python3.pkgs; toPythonApplication md2gemini;

  mdbook = callPackage ../tools/text/mdbook {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdbook-graphviz = callPackage ../tools/text/mdbook-graphviz {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdbook-katex = callPackage ../tools/text/mdbook-katex {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdbook-linkcheck = callPackage ../tools/text/mdbook-linkcheck {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mdbook-mermaid = callPackage ../tools/text/mdbook-mermaid {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdbook-pdf = callPackage ../tools/text/mdbook-pdf {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdbook-plantuml = callPackage ../tools/text/mdbook-plantuml {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdbook-admonish = callPackage ../tools/text/mdbook-admonish {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdcat = callPackage ../tools/text/mdcat {
    inherit (darwin.apple_sdk.frameworks) Security;
    inherit (python3Packages) ansi2html;
  };

  medfile = callPackage ../development/libraries/medfile {
    hdf5 = hdf5.override { usev110Api = true; };
  };

  meilisearch = callPackage ../servers/search/meilisearch {
    inherit (darwin.apple_sdk.frameworks) Security DiskArbitration Foundation;
  };

  mhonarc = perlPackages.MHonArc;

  mujmap = callPackage ../applications/networking/mujmap {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mx-puppet-discord = callPackage ../servers/mx-puppet-discord { };

  nagstamon = callPackage ../tools/misc/nagstamon {
    pythonPackages = python3Packages;
  };

  nbtscanner = callPackage ../tools/security/nbtscanner {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  netdata = callPackage ../tools/system/netdata {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;
  };

  netsurf = recurseIntoAttrs (callPackage ../applications/networking/browsers/netsurf { });
  netsurf-browser = netsurf.browser;

  nixnote2 = libsForQt5.callPackage ../applications/misc/nixnote2 { };

  nodejs = hiPrio nodejs-18_x;

  nodejs-slim = nodejs-slim-18_x;

  nodejs-14_x = callPackage ../development/web/nodejs/v14.nix {
    openssl = openssl_1_1;
  };
  nodejs-slim-14_x = callPackage ../development/web/nodejs/v14.nix {
    openssl = openssl_1_1;
    enableNpm = false;
  };
  nodejs-16_x = callPackage ../development/web/nodejs/v16.nix { };
  nodejs-slim-16_x = callPackage ../development/web/nodejs/v16.nix {
    enableNpm = false;
  };
  nodejs-16_x-openssl_1_1 = callPackage ../development/web/nodejs/v16.nix {
    openssl = openssl_1_1;
  };
  nodejs-18_x = callPackage ../development/web/nodejs/v18.nix { };
  nodejs-slim-18_x = callPackage ../development/web/nodejs/v18.nix {
    enableNpm = false;
  };
  nodejs-19_x = callPackage ../development/web/nodejs/v19.nix { };
  nodejs-slim-19_x = callPackage ../development/web/nodejs/v19.nix {
    enableNpm = false;
  };
  # Update this when adding the newest nodejs major version!
  nodejs_latest = nodejs-19_x;
  nodejs-slim_latest = nodejs-slim-19_x;

  inherit (callPackage ../build-support/node/fetch-npm-deps {
    inherit (darwin.apple_sdk.frameworks) Security;
  }) fetchNpmDeps prefetch-npm-deps;

  nodePackages_latest = dontRecurseIntoAttrs nodejs_latest.pkgs;

  nodePackages = dontRecurseIntoAttrs nodejs.pkgs;

  node2nix = nodePackages.node2nix;

  kcollectd = libsForQt5.callPackage ../tools/misc/kcollectd {};

  larynx-train = with python3Packages; toPythonApplication larynx-train;

  ldeep = python3Packages.callPackage ../tools/security/ldeep { };

  ledit = callPackage ../tools/misc/ledit {
    inherit (ocaml-ng.ocamlPackages_4_12) ocaml camlp5;
  };

  lethe = callPackage ../tools/security/lethe {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  # Needed for apps that still depend on the unstable verison of the library (not libhandy-1)

  libint = callPackage ../development/libraries/libint {};
  libintPsi4 = callPackage ../development/libraries/libint {
    enableFortran = false;
    enableSSE = false;
    maxAm = 6;
    eriDeriv = 2;
    eri3Deriv = 2;
    eri2Deriv = 2;
    eriAm = [ 6 5 4 ];
    eri3Am = [ 6 5 4 ];
    eri2Am = [ 6 5 4 ];
    eriOptAm = [ 3 2 2 ];
    eri3OptAm = [ 3 2 2 ];
    eri2OptAm = [ 3 2 2 ];
    enableOneBody = true;
    oneBodyDerivOrd = 2;
    enableGeneric = false;
    enableContracted = false;
    cartGaussOrd = "standard";
    shGaussOrd = "gaussian";
    eri2PureSh = false;
    eri3PureSh = false;
  };

  libirc = libsForQt5.callPackage ../development/libraries/libirc { };

  liblangtag = callPackage ../development/libraries/liblangtag {
    inherit (gnome) gnome-common;
  };

  libportal-gtk3 = libportal.override { variant = "gtk3"; };
  libportal-gtk4 = libportal.override { variant = "gtk4"; };
  libportal-qt5 = libportal.override { variant = "qt5"; };

  rtorrent = callPackage ../applications/networking/p2p/rakshasa-rtorrent {
    libtorrent = callPackage ../applications/networking/p2p/rakshasa-rtorrent/libtorrent.nix { };
  };

  jesec-rtorrent = callPackage ../applications/networking/p2p/jesec-rtorrent {
    libtorrent = callPackage ../applications/networking/p2p/jesec-rtorrent/libtorrent.nix { };
  };


  libreddit = callPackage ../servers/libreddit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  limesuite = callPackage ../applications/radio/limesuite {
    inherit (darwin.apple_sdk.frameworks) GLUT;
  };

  liquidctl = with python3Packages; toPythonApplication liquidctl;

  localstack = with python3Packages; toPythonApplication localstack;

  loki = callPackage ../development/libraries/loki { stdenv = gcc10StdenvCompat; };

  # lsh installs `bin/nettle-lfib-stream' and so does Nettle.  Give the
  # former a lower priority than Nettle.
  lsh = lowPrio (callPackage ../tools/networking/lsh { });

  lunatic = callPackage ../development/interpreters/lunatic {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  lxc = callPackage ../os-specific/linux/lxc {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  luxcorerender = callPackage ../tools/graphics/luxcorerender {
    openimagedenoise = openimagedenoise_1_2_x;
  };

  madlang = haskell.lib.compose.justStaticExecutables haskellPackages.madlang;

  mailnag = callPackage ../applications/networking/mailreaders/mailnag {
    availablePlugins = {
      # More are listed here: https://github.com/pulb/mailnag/#desktop-integration
      # Use the attributes here as arguments to `plugins` list
      goa = callPackage ../applications/networking/mailreaders/mailnag/goa-plugin.nix { };
    };
  };
  mailnagWithPlugins = mailnag.withPlugins(
    builtins.attrValues mailnag.availablePlugins
  );

  mailutils = callPackage ../tools/networking/mailutils {
    sasl = gsasl;
  };

  makemkv = libsForQt5.callPackage ../applications/video/makemkv { };

  man = man-db;

  mangareader = libsForQt5.callPackage ../applications/graphics/mangareader { };

  mangohud = callPackage ../tools/graphics/mangohud {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
    mangohud32 = pkgsi686Linux.mangohud;
    inherit (python3Packages) Mako;
  };

  manix = callPackage ../tools/nix/manix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  maui-shell = libsForQt5.callPackage ../applications/window-managers/maui-shell { };

  mecab =
    let
      mecab-nodic = callPackage ../tools/text/mecab/nodic.nix { };
    in
    callPackage ../tools/text/mecab {
      mecab-ipadic = callPackage ../tools/text/mecab/ipadic.nix {
        inherit mecab-nodic;
      };
    };

  mbutil = python3Packages.callPackage ../applications/misc/mbutil { };

  mcstatus = with python3Packages; toPythonApplication mcstatus;

  minijail-tools = python3.pkgs.callPackage ../tools/system/minijail/tools.nix { };

  mir-qualia = callPackage ../tools/text/mir-qualia {
    pythonPackages = python3Packages;
  };

  mirakurun = callPackage ../applications/video/mirakurun { };

  mitmproxy = with python3Packages; toPythonApplication mitmproxy;

  mjpegtoolsFull = mjpegtools.override {
    withMinimal = false;
  };

  mkcue = callPackage ../tools/cd-dvd/mkcue { stdenv = gcc10StdenvCompat; };

  mkpasswd = hiPrio (callPackage ../tools/security/mkpasswd { });

  monolith = callPackage ../tools/backup/monolith {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  moreutils = callPackage ../tools/misc/moreutils {
    docbook-xsl = docbook_xsl;
  };

  morgen = callPackage ../applications/office/morgen {
    electron = electron_15;
  };

  mhost = callPackage ../applications/networking/mhost {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mtr = callPackage ../tools/networking/mtr {};

  mtr-gui = callPackage ../tools/networking/mtr { withGtk = true; };

  multitran = recurseIntoAttrs (let callPackage = newScope pkgs.multitran; in {
    multitrandata = callPackage ../tools/text/multitran/data { };

    libbtree = callPackage ../tools/text/multitran/libbtree { };

    libmtsupport = callPackage ../tools/text/multitran/libmtsupport { };

    libfacet = callPackage ../tools/text/multitran/libfacet { };

    libmtquery = callPackage ../tools/text/multitran/libmtquery { };

    mtutils = callPackage ../tools/text/multitran/mtutils { };
  });

  mytetra = libsForQt5.callPackage ../applications/office/mytetra { };

  navilu-font = callPackage ../data/fonts/navilu { stdenv = stdenvNoCC; };

  netcdf = callPackage ../development/libraries/netcdf {
    hdf5 = hdf5.override { usev110Api = true; };
  };

  netcdf-mpi = netcdf.override {
    hdf5 = hdf5-mpi.override { usev110Api = true; };
  };

  netcdffortran = callPackage ../development/libraries/netcdf-fortran {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  netcat = libressl.nc;

  libnma-gtk4 = libnma.override { withGtk4 = true; };

  nm-tray = libsForQt5.callPackage ../tools/networking/networkmanager/tray.nix { };

  newsboat = callPackage ../applications/networking/feedreaders/newsboat {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  inherit (callPackage ../servers/nextcloud {})
    nextcloud23 nextcloud24 nextcloud25;

  nextcloud23Packages = ( callPackage ../servers/nextcloud/packages {
    apps = lib.importJSON ../servers/nextcloud/packages/23.json;
  });
  nextcloud24Packages = ( callPackage ../servers/nextcloud/packages {
    apps = lib.importJSON ../servers/nextcloud/packages/24.json;
  });
  nextcloud25Packages = ( callPackage ../servers/nextcloud/packages {
    apps = lib.importJSON ../servers/nextcloud/packages/25.json;
  });

  nextcloud-client = libsForQt5.callPackage ../applications/networking/nextcloud-client { };

  inherit (callPackage ../applications/networking/cluster/nomad { })
    nomad
    nomad_1_2
    nomad_1_3
    nomad_1_4
    ;

  nth = with python3Packages; toPythonApplication name-that-hash;

  nvchecker = with python3Packages; toPythonApplication nvchecker;

  nvfetcher = haskell.lib.compose.justStaticExecutables haskellPackages.nvfetcher;

  mkgmap = callPackage ../applications/misc/mkgmap { };

  mkgmap-splitter = callPackage ../applications/misc/mkgmap/splitter { };

  pandoc-acro = python3Packages.callPackage ../tools/misc/pandoc-acro { };

  pandoc-imagine = python3Packages.callPackage ../tools/misc/pandoc-imagine { };

  pandoc-include = python3Packages.callPackage ../tools/misc/pandoc-include { };

  pandoc-drawio-filter = python3Packages.callPackage ../tools/misc/pandoc-drawio-filter { };

  pandoc-plantuml-filter = python3Packages.callPackage ../tools/misc/pandoc-plantuml-filter { };

  # pandoc-*nos is a filter suite, where pandoc-xnos has all functionality and the others are used for only specific functionality
  pandoc-eqnos = python3Packages.callPackage ../tools/misc/pandoc-eqnos { };
  pandoc-fignos = python3Packages.callPackage ../tools/misc/pandoc-fignos { };
  pandoc-secnos = python3Packages.callPackage ../tools/misc/pandoc-secnos { };
  pandoc-tablenos = python3Packages.callPackage ../tools/misc/pandoc-tablenos { };

  pgbadger = perlPackages.callPackage ../tools/misc/pgbadger { };

  nifskope = libsForQt5.callPackage ../tools/graphics/nifskope { };

  nlopt = callPackage ../development/libraries/nlopt { octave = null; };

  nmapsi4 = libsForQt5.callPackage ../tools/security/nmap/qt.nix { };

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration;
  };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntfy = callPackage ../tools/misc/ntfy { python = python39; };

  ntfy-sh = callPackage ../tools/misc/ntfy-sh { };

  nvfancontrol = callPackage ../tools/misc/nvfancontrol {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  nwdiag = with python3Packages; toPythonApplication nwdiag;

  nxdomain = python3.pkgs.callPackage ../tools/networking/nxdomain { };

  nym = callPackage ../applications/networking/nym {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  nzbget = callPackage ../tools/networking/nzbget {
    openssl = openssl_1_1;
  };

  nzbhydra2 = callPackage ../servers/nzbhydra2 {
    # You need Java (at least 8, at most 15)
    # https://github.com/theotherp/nzbhydra2/issues/697
    # https://github.com/theotherp/nzbhydra2/#how-to-run
    jre = openjdk11;
  };

  octofetch = callPackage ../tools/misc/octofetch {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  oha = callPackage ../tools/networking/oha {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  onetun = callPackage ../tools/networking/onetun {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  opensnitch-ui = libsForQt5.callPackage ../tools/networking/opensnitch/ui.nix { };

  ofono-phonesim = libsForQt5.callPackage ../development/tools/ofono-phonesim { };

  olive-editor = libsForQt5.callPackage ../applications/video/olive-editor {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  onefetch = callPackage ../tools/misc/onefetch {
    inherit (darwin) libresolv;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  onlykey = callPackage ../tools/security/onlykey { node_webkit = nwjs; };

  openapi-generator-cli = callPackage ../tools/networking/openapi-generator-cli { jre = pkgs.jre_headless; };
  openapi-generator-cli-unstable = callPackage ../tools/networking/openapi-generator-cli/unstable.nix { jre = pkgs.jre_headless; };

  openbangla-keyboard = libsForQt5.callPackage ../applications/misc/openbangla-keyboard { };

  openboard = libsForQt5.callPackage ../applications/graphics/openboard { };

  opendbx = callPackage ../development/libraries/opendbx { stdenv = gcc10StdenvCompat; };

  opendht = callPackage ../development/libraries/opendht  {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  opendylan = callPackage ../development/compilers/opendylan {
    opendylan-bootstrap = opendylan_bin;
  };

  ophis = python3Packages.callPackage ../development/compilers/ophis { };

  openhantek6022 = libsForQt5.callPackage ../applications/science/electronics/openhantek6022 { };

  openntpd_nixos = openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  openrgb = libsForQt5.callPackage ../applications/misc/openrgb { };

  openrussian-cli = callPackage ../misc/openrussian-cli {
    lua = lua5_3;
  };

  opensc = callPackage ../tools/security/opensc {
    inherit (darwin.apple_sdk.frameworks) Carbon PCSC;
  };

  opensshPackages = dontRecurseIntoAttrs (callPackage ../tools/networking/openssh {});

  openssh = opensshPackages.openssh.override {
    etcDir = "/etc/ssh";
  };

  openssh_hpn = opensshPackages.openssh_hpn.override {
    etcDir = "/etc/ssh";
  };

  openssh_gssapi = opensshPackages.openssh_gssapi.override {
    etcDir = "/etc/ssh";
  };

  opentrack = libsForQt5.callPackage ../applications/misc/opentrack { };

  inherit (callPackages ../tools/networking/openvpn {})
    openvpn_24
    openvpn;

  openvpn-auth-ldap = callPackage ../tools/networking/openvpn/openvpn-auth-ldap.nix {
    stdenv = clangStdenv;
  };

  update-dotdee = with python3Packages; toPythonApplication update-dotdee;

  update-nix-fetchgit = haskell.lib.compose.justStaticExecutables haskellPackages.update-nix-fetchgit;

  openvswitch = callPackage ../os-specific/linux/openvswitch { };

  openvswitch-lts = callPackage ../os-specific/linux/openvswitch/lts.nix { };

  optifine = optifinePackages.optifine-latest;

  optipng = callPackage ../tools/graphics/optipng {
    libpng = libpng12;
  };

  opl3bankeditor = libsForQt5.callPackage ../tools/audio/opl3bankeditor { };
  opn2bankeditor = libsForQt5.callPackage ../tools/audio/opl3bankeditor/opn2bankeditor.nix { };

  orangefs = callPackage ../tools/filesystems/orangefs {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  osl = libsForQt5.callPackage ../development/compilers/osl {
    boost = boost17x;
  };

  ovftool = callPackage ../tools/virtualization/ovftool {
    libressl = libressl_3_4;
  };

  ovito = libsForQt5.callPackage ../applications/graphics/ovito {
    inherit (darwin.apple_sdk.frameworks) VideoDecodeAcceleration;
  };

  owncloud-client = libsForQt5.callPackage ../applications/networking/owncloud-client { };

  padthv1 = libsForQt5.callPackage ../applications/audio/padthv1 { };

  PageEdit = libsForQt5.callPackage ../applications/office/PageEdit { };

  pakcs = callPackage ../development/compilers/pakcs {
    # Doesn't compile with GHC 9.0 due to whitespace syntax changes
    # see also https://github.com/NixOS/nixpkgs/issues/166108
    haskellPackages = haskell.packages.ghc810;
  };

  paperoni = callPackage ../tools/text/paperoni {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  paperwork = callPackage ../applications/office/paperwork/paperwork-gtk.nix { };

  parcellite = callPackage ../tools/misc/parcellite {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  patchutils = callPackage ../tools/text/patchutils { };

  patchutils_0_3_3 = callPackage ../tools/text/patchutils/0.3.3.nix { };

  patchutils_0_4_2 = callPackage ../tools/text/patchutils/0.4.2.nix { };

  percona-xtrabackup = percona-xtrabackup_8_0;
  percona-xtrabackup_8_0 = callPackage ../tools/backup/percona-xtrabackup/8_0.nix {
    boost = boost177;
    openssl = openssl_1_1;
  };

  pipecontrol = libsForQt5.callPackage ../applications/audio/pipecontrol { };

  pulumiPackages = recurseIntoAttrs (
    callPackage ../tools/admin/pulumi-packages { }
  );

  patch = gnupatch;

  pciutils = callPackage ../tools/system/pciutils {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcsclite = callPackage ../tools/security/pcsclite {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcscliteWithPolkit = pcsclite.override {
    pname = "pcsclite-with-polkit";
    polkitSupport = true;
  };

  pdd = python3Packages.callPackage ../tools/misc/pdd { };

  pdfminer = with python3Packages; toPythonApplication pdfminer-six;

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = libsForQt5.callPackage ../tools/graphics/pfstools { };

  pinentry = libsForQt5.callPackage ../tools/security/pinentry { };

  pinentry-curses = (lib.getOutput "curses" pinentry);
  pinentry-emacs = (lib.getOutput "emacs" pinentry);
  pinentry-gtk2 = (lib.getOutput "gtk2" pinentry);
  pinentry-qt = (lib.getOutput "qt" pinentry);
  pinentry-gnome = (lib.getOutput "gnome3" pinentry);

  pinentry_mac = callPackage ../tools/security/pinentry/mac.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  piping-server-rust = callPackage ../servers/piping-server-rust {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  pinyin-tool = callPackage ../tools/text/pinyin-tool {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  plan9port = darwin.apple_sdk_11_0.callPackage ../tools/system/plan9port {
    inherit (darwin.apple_sdk_11_0.frameworks) Carbon Cocoa IOKit Metal QuartzCore;
    inherit (darwin) DarwinTools;
  };

  platformioPackages = dontRecurseIntoAttrs (callPackage ../development/embedded/platformio { });
  platformio = platformioPackages.platformio-chrootenv;

  playbar2 = libsForQt5.callPackage ../applications/audio/playbar2 { };

  playwright = with python3Packages; toPythonApplication playwright;

  inherit (callPackage ../servers/plik { })
    plik plikd;

  psitransfer = callPackage ../servers/psitransfer { };

  tabview = with python3Packages; toPythonApplication tabview;

  tautulli = python3Packages.callPackage ../servers/tautulli { };

  plfit = callPackage ../tools/misc/plfit {
    python = null;
  };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  pm2 = nodePackages.pm2;

  pngtoico = callPackage ../tools/graphics/pngtoico {
    libpng = libpng12;
  };

  pngpaste = callPackage ../os-specific/darwin/pngpaste {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  po4a = perlPackages.Po4a;

  poac = callPackage ../development/tools/poac {
    inherit (llvmPackages_14) stdenv;
  };

  podman-compose = python3Packages.callPackage ../applications/virtualization/podman-compose {};

  poedit = callPackage ../tools/text/poedit {
    wxGTK32 = wxGTK32.override { withWebKit = true; };
  };

  polaris-web = callPackage ../servers/polaris/web.nix { };

  pantum-driver = callPackage ../misc/drivers/pantum-driver {
    libjpeg8 = libjpeg.override { enableJpeg8 = true; };
  };

  povray = callPackage ../tools/graphics/povray {
    boost = boost175;
  };

  projectlibre = callPackage ../applications/misc/projectlibre {
    jre = jre8;
    jdk = jdk8;
  };

  projectm = libsForQt5.callPackage ../applications/audio/projectm { };

  inherit (callPackages ../tools/security/proxmark3 { gcc-arm-embedded = gcc-arm-embedded-8; })
    proxmark3 proxmark3-unstable;

  proxmark3-rrg = libsForQt5.callPackage ../tools/security/proxmark3/proxmark3-rrg.nix { };

  past-time = python3Packages.callPackage ../tools/misc/past-time { };

  psensor = callPackage ../tools/system/psensor {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  pwninit = callPackage ../development/tools/misc/pwninit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pycflow2dot = with python3.pkgs; toPythonApplication pycflow2dot;

  pyinfra = with python3Packages; toPythonApplication pyinfra;

  pylint = with python3Packages; toPythonApplication pylint;

  pyocd = with python3Packages; toPythonApplication pyocd;

  pypass = with python3Packages; toPythonApplication pypass;

  pyspread = libsForQt5.callPackage ../applications/office/pyspread { };

  pyditz = callPackage ../applications/misc/pyditz {
    pythonPackages = python27Packages;
  };

  pydeps = with python3Packages; toPythonApplication pydeps;

  pywal = with python3Packages; toPythonApplication pywal;

  rbw = callPackage ../tools/security/rbw {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  remarshal = with python3Packages; toPythonApplication remarshal;

  rehex = darwin.apple_sdk_11_0.callPackage ../applications/editors/rehex {
    inherit (darwin.apple_sdk_11_0.frameworks) Carbon Cocoa IOKit;
  };

  riseup-vpn = libsForQt5.callPackage ../tools/networking/bitmask-vpn {
    provider = "riseup";
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  rocket = libsForQt5.callPackage ../tools/graphics/rocket { };

  rtabmap = libsForQt5.callPackage ../applications/video/rtabmap/default.nix {
    pcl = pcl.override { vtk = vtkWithQt5; };
  };

  rtaudio = callPackage ../development/libraries/audio/rtaudio {
    jack = libjack2;
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  rtmidi = callPackage ../development/libraries/audio/rtmidi {
    jack = libjack2;
    inherit (darwin.apple_sdk.frameworks) CoreMIDI CoreAudio CoreServices;
  };

  mpi = openmpi; # this attribute should used to build MPI applications

  openmodelica = recurseIntoAttrs (callPackage ../applications/science/misc/openmodelica {});

  qarte = libsForQt5.callPackage ../applications/video/qarte { };

  qdrant = darwin.apple_sdk_11_0.callPackage ../servers/search/qdrant { };

  qlcplus = libsForQt5.callPackage ../applications/misc/qlcplus { };

  quickbms = pkgsi686Linux.callPackage ../tools/archivers/quickbms { };

  qalculate-qt = qt6Packages.callPackage ../applications/science/math/qalculate-qt { };

  qastools = libsForQt5.callPackage ../tools/audio/qastools { };

  qdigidoc = libsForQt5.callPackage ../tools/security/qdigidoc { } ;

  qgrep = callPackage ../tools/text/qgrep {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreFoundation;
  };

  qjournalctl = libsForQt5.callPackage ../applications/system/qjournalctl { };

  qjoypad = libsForQt5.callPackage ../tools/misc/qjoypad { };

  qmarkdowntextedit = libsForQt5.callPackage  ../development/libraries/qmarkdowntextedit { };

  qosmic = libsForQt5.callPackage ../applications/graphics/qosmic { };

  qownnotes = libsForQt5.callPackage ../applications/office/qownnotes { };

  qscintilla = libsForQt5.callPackage ../development/libraries/qscintilla { };

  qtikz = libsForQt5.callPackage ../applications/graphics/ktikz { };

  qtspim = libsForQt5.callPackage ../development/tools/misc/qtspim { };

  quictls = callPackage ../development/libraries/quictls { };

  quota = if stdenv.isLinux then linuxquota else unixtools.quota;

  qvge = libsForQt5.callPackage ../applications/graphics/qvge { };

  qview = libsForQt5.callPackage ../applications/graphics/qview {};

  radeon-profile = libsForQt5.callPackage ../tools/misc/radeon-profile { };

  rainbowstream = with python3.pkgs; toPythonApplication rainbowstream;

  rdbtools = callPackage ../development/tools/rdbtools { python = python3; };

  retext = qt6Packages.callPackage ../applications/editors/retext { };

  inherit (callPackage ../tools/security/rekor { })
    rekor-cli
    rekor-server;

  rstcheck = with python3Packages; toPythonApplication rstcheck;

  rtmpdump_gnutls = rtmpdump.override { gnutlsSupport = true; opensslSupport = false; };

  qt-box-editor = libsForQt5.callPackage ../applications/misc/qt-box-editor { };

  recoll = libsForQt5.callPackage ../applications/search/recoll { };

  redoc-cli = nodePackages.redoc-cli;

  renderdoc = libsForQt5.callPackage ../development/tools/renderdoc { };

  rescuetime = libsForQt5.callPackage ../applications/misc/rescuetime { };

  inherit (callPackage ../development/misc/resholve { })
    resholve;

  inherit (nodePackages) reveal-md;

  rmlint = callPackage ../tools/misc/rmlint {
    inherit (python3Packages) sphinx;
  };

  # Use `apple_sdk_11_0` because `apple_sdk.libs` does not provide `simd`
  rnnoise-plugin = darwin.apple_sdk_11_0.callPackage ../development/libraries/rnnoise-plugin {
    inherit (darwin.apple_sdk_11_0.frameworks) WebKit MetalKit CoreAudioKit;
    inherit (darwin.apple_sdk_11_0.libs) simd;
  };

  rnote = callPackage ../applications/graphics/rnote {
    inherit (gst_all_1) gstreamer;
  };

  rockbox-utility = libsForQt5.callPackage ../tools/misc/rockbox-utility { };

  rosegarden = libsForQt5.callPackage ../applications/audio/rosegarden { };

  rpi-imager = libsForQt5.callPackage ../tools/misc/rpi-imager { };

  rpm = callPackage ../tools/package-management/rpm {
    python = python3;
    lua = lua5_4;
  };

  rpm-ostree = callPackage ../tools/misc/rpm-ostree {
    gperf = gperf_3_0;
  };

  rsibreak = libsForQt5.callPackage ../applications/misc/rsibreak { };

  rss2email = callPackage ../applications/networking/feedreaders/rss2email {
    pythonPackages = python3Packages;
  };

  rubocop = rubyPackages.rubocop;

  ruplacer = callPackage ../tools/text/ruplacer {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rust-motd = callPackage ../tools/misc/rust-motd {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rustcat = callPackage ../tools/networking/rustcat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rustscan = callPackage ../tools/security/rustscan {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  s3cmd = python3Packages.callPackage ../tools/networking/s3cmd { };

  s3rs = callPackage ../tools/networking/s3rs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  s3-credentials = with python3Packages; toPythonApplication s3-credentials;

  safety-cli = with python3.pkgs; toPythonApplication safety;

  saml2aws = callPackage ../tools/security/saml2aws {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  sasview = libsForQt5.callPackage ../applications/science/misc/sasview {};

  screen = callPackage ../tools/misc/screen {
    inherit (darwin.apple_sdk.libs) utmp;
  };

  scrcpy = callPackage ../misc/scrcpy {
    inherit (androidenv.androidPkgs_9_0) platform-tools;
  };

  scfbuild = python3.pkgs.callPackage ../tools/misc/scfbuild { };

  sd = callPackage ../tools/text/sd {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  securefs = callPackage ../tools/filesystems/securefs {
    stdenv = clangStdenv;
  };

  selectdefaultapplication = libsForQt5.callPackage ../applications/misc/selectdefaultapplication { };

  semgrep = python3.pkgs.callPackage ../tools/security/semgrep { };
  semgrep-core = callPackage ../tools/security/semgrep/semgrep-core.nix { };

  seqdiag = with python3Packages; toPythonApplication seqdiag;

  sequoia = callPackage ../tools/security/sequoia {
    pythonPackages = python3Packages;
  };

  sftpgo = callPackage ../servers/sftpgo {
    buildGoModule = buildGo119Module;
  };

  shadowsocks-rust = callPackage ../tools/networking/shadowsocks-rust {
    inherit (darwin.apple_sdk.frameworks) Security CoreServices;
  };

  shiv = with python3Packages; toPythonApplication shiv;

  shout = nodePackages.shout;

  sigil = libsForQt5.callPackage ../applications/editors/sigil { };

  signalbackup-tools = darwin.apple_sdk_11_0.callPackage ../applications/networking/instant-messengers/signalbackup-tools { };

  inherit (callPackage ../applications/networking/instant-messengers/signal-desktop {}) signal-desktop signal-desktop-beta;

  slither-analyzer = with python3Packages; toPythonApplication slither-analyzer;

  # aka., pgp-tools

  sile = callPackage ../tools/typesetting/sile {
    lua = lua5_3;
  };

  simplescreenrecorder = libsForQt5.callPackage ../applications/video/simplescreenrecorder { };

  sipvicious = python3Packages.callPackage ../tools/security/sipvicious { };

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  sketchybar = darwin.apple_sdk_11_0.callPackage ../os-specific/darwin/sketchybar {
    inherit (darwin.apple_sdk_11_0.frameworks) Carbon Cocoa DisplayServices SkyLight;
  };

  sks = callPackage ../servers/sks {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  skribilo = callPackage ../tools/typesetting/skribilo {
    tex = texlive.combined.scheme-small;
  };

  slstatus = callPackage ../applications/misc/slstatus {
    conf = config.slstatus.conf or null;
  };

  smartmontools = callPackage ../tools/system/smartmontools {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
  };

  smesh = callPackage ../development/libraries/smesh {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  snapcast = darwin.apple_sdk_11_0.callPackage ../applications/audio/snapcast {
    inherit (darwin.apple_sdk_11_0.frameworks) IOKit AudioToolbox;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
  };

  sng = callPackage ../tools/graphics/sng {
    libpng = libpng12;
  };

  so = callPackage ../development/tools/so {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  soapui = callPackage ../applications/networking/soapui {
    jdk = jdk11;
  };

  spglib = callPackage ../development/libraries/spglib {
    inherit (llvmPackages) openmp;
  };

  # to match naming of other package repositories
  spire-agent = spire.agent;
  spire-server = spire.server;

  spoof-mac = python3Packages.callPackage ../tools/networking/spoof-mac { };

  suricata = callPackage ../applications/networking/ids/suricata {
    python = python3;
    libbpf = libbpf_0;
  };

  softhsm = callPackage ../tools/security/softhsm {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  soundkonverter = libsForQt5.soundkonverter;

  sparrow = callPackage ../applications/blockchains/sparrow {
    openimajgrabber = callPackage ../applications/blockchains/sparrow/openimajgrabber.nix {};
  };

  stm32loader = with python3Packages; toPythonApplication stm32loader;

  stremio = qt5.callPackage ../applications/video/stremio { };

  solanum = callPackage ../servers/irc/solanum {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  solc-select = with python3Packages; toPythonApplication solc-select;

  spacebar = callPackage ../os-specific/darwin/spacebar {
    inherit (darwin.apple_sdk.frameworks)
      Carbon Cocoa ScriptingBridge SkyLight;
  };

  splot = haskell.lib.compose.justStaticExecutables haskellPackages.splot;

  squashfs-tools-ng = darwin.apple_sdk_11_0.callPackage ../tools/filesystems/squashfs-tools-ng { };

  sshfs = sshfs-fuse; # added 2017-08-14

  sslsplit = callPackage ../tools/networking/sslsplit {
    openssl = openssl_1_1;
  };

  strip-nondeterminism = perlPackages.strip-nondeterminism;

  subsurface = libsForQt5.callPackage ../applications/misc/subsurface { };

  sumorobot-manager = python3Packages.callPackage ../applications/science/robotics/sumorobot-manager { };

  staticjinja = with python3.pkgs; toPythonApplication staticjinja;

  stoken = callPackage ../tools/security/stoken (config.stoken or {});

  stutter = haskell.lib.compose.justStaticExecutables haskellPackages.stutter;

  strongswanTNC = strongswan.override { enableTNC = true; };
  strongswanNM  = strongswan.override { enableNetworkManager = true; };

  stylish-haskell = haskell.lib.compose.justStaticExecutables haskellPackages.stylish-haskell;

  su = shadow.su;

  subzerod = with python3Packages; toPythonApplication subzerod;

  suckit = callPackage ../tools/networking/suckit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    autoreconfHook = buildPackages.autoreconfHook269;
    libxml2 = libxml2Python;
  };

  privoxy = callPackage ../tools/networking/privoxy {
    w3m = w3m-batch;
  };

  systemdgenie = libsForQt5.callPackage ../applications/system/systemdgenie { };

  tab-rs = callPackage ../tools/misc/tab-rs {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  inherit (callPackages ../applications/networking/taler { })
    taler-exchange taler-merchant;

  tartube = callPackage ../applications/video/tartube { };

  tartube-yt-dlp = callPackage ../applications/video/tartube {
    youtube-dl = yt-dlp;
  };

  tcpreplay = callPackage ../tools/networking/tcpreplay {
    inherit (darwin.apple_sdk.frameworks) Carbon CoreServices;
  };

  inherit (nodePackages) teck-programmer;

  teamviewer = libsForQt5.callPackage ../applications/networking/remote/teamviewer { };

  teleport = callPackage ../servers/teleport {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security AppKit;
  };

  telepresence = callPackage ../tools/networking/telepresence {
    pythonPackages = python3Packages;
  };

  termscp = callPackage ../tools/networking/termscp {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Foundation Security;
  };

  texmacs = if stdenv.isDarwin
    then callPackage ../applications/editors/texmacs/darwin.nix {
      inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
      tex = texlive.combined.scheme-small;
      extraFonts = true;
    } else libsForQt5.callPackage ../applications/editors/texmacs {
      tex = texlive.combined.scheme-small;
      extraFonts = true;
    };

  texmaker = libsForQt5.callPackage ../applications/editors/texmaker { };

  texstudio = libsForQt5.callPackage ../applications/editors/texstudio { };

  texworks = libsForQt5.callPackage ../applications/editors/texworks { };

  inherit (nodePackages) thelounge;

  theLoungePlugins = with lib; let
    pkgs = filterAttrs (name: _: hasPrefix "thelounge-" name) nodePackages;
    getPackagesWithPrefix = prefix: mapAttrs' (name: pkg: nameValuePair (removePrefix ("thelounge-" + prefix + "-") name) pkg)
      (filterAttrs (name: _: hasPrefix ("thelounge-" + prefix + "-") name) pkgs);
  in
  recurseIntoAttrs {
    plugins = recurseIntoAttrs (getPackagesWithPrefix "plugin");
    themes = recurseIntoAttrs (getPackagesWithPrefix "theme");
  };

  thefuck = python3Packages.callPackage ../tools/misc/thefuck { };

  thinkpad-scripts = python3.pkgs.callPackage ../tools/misc/thinkpad-scripts { };

  tiled = libsForQt5.callPackage ../applications/editors/tiled { };

  tikzit = libsForQt5.callPackage ../tools/typesetting/tikzit { };

  tldr-hs = haskellPackages.tldr;

  tmuxPlugins = recurseIntoAttrs (callPackage ../misc/tmux-plugins { });

  tokei = callPackage ../development/tools/misc/tokei {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  topgrade = callPackage ../tools/misc/topgrade {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Foundation;
  };

  toybox = darwin.apple_sdk_11_0.callPackage ../tools/misc/toybox { };

  trackma-curses = trackma.override { withCurses = true; };

  trackma-gtk = trackma.override { withGTK = true; };

  trackma-qt = trackma.override { withQT = true; };

  tpmmanager = libsForQt5.callPackage ../applications/misc/tpmmanager { };

  trezorctl = with python3Packages; toPythonApplication trezor;

  trezord = callPackage ../servers/trezord {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  trezor_agent = with python3Packages; toPythonApplication trezor_agent;

  trunk = callPackage ../development/tools/trunk {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  ttp = with python3.pkgs; toPythonApplication ttp;

  kernelshark = libsForQt5.callPackage ../os-specific/linux/trace-cmd/kernelshark.nix { };

  tracebox = callPackage ../tools/networking/tracebox { stdenv = gcc10StdenvCompat; };

  transifex-client = python39.pkgs.callPackage ../tools/text/transifex-client { };

  translatepy = with python3.pkgs; toPythonApplication translatepy;

  trenchbroom = libsForQt5.callPackage ../applications/misc/trenchbroom { };

  inherit (nodePackages) triton;

  inherit (callPackage ../applications/office/trilium {})
    trilium-desktop
    trilium-server
    ;

  trytond = with python3Packages; toPythonApplication trytond;

  ttfautohint = libsForQt5.callPackage ../tools/misc/ttfautohint {
    autoreconfHook = buildPackages.autoreconfHook269;
  };
  ttfautohint-nox = ttfautohint.override { enableGUI = false; };

  tuifeed = callPackage ../applications/networking/feedreaders/tuifeed {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tunnelto = callPackage ../tools/networking/tunnelto {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  twilight = callPackage ../tools/graphics/twilight {
    libX11 = xorg.libX11;
  };

  twitch-chat-downloader = python3Packages.callPackage ../applications/misc/twitch-chat-downloader { };

  twtxt = python3Packages.callPackage ../applications/networking/twtxt { };

  ubidump = python3Packages.callPackage ../tools/filesystems/ubidump { };

  unetbootin = libsForQt5.callPackage ../tools/cd-dvd/unetbootin { };

  unrpa = with python38Packages; toPythonApplication unrpa;

  vcmi = libsForQt5.callPackage ../games/vcmi { };

  verilog = callPackage ../applications/science/electronics/verilog {
    autoconf = buildPackages.autoconf269;
  };

  video2midi = callPackage ../tools/audio/video2midi {
    pythonPackages = python3Packages;
  };

  vimpager = callPackage ../tools/misc/vimpager { };
  vimpager-latest = callPackage ../tools/misc/vimpager/latest.nix { };

  vimwiki-markdown = python3Packages.callPackage ../tools/misc/vimwiki-markdown { };

  visidata = (newScope python3Packages) ../applications/misc/visidata {
  };

  vkbasalt = callPackage ../tools/graphics/vkbasalt {
    vkbasalt32 = pkgsi686Linux.vkbasalt;
  };

  vpn-slice = python3Packages.callPackage ../tools/networking/vpn-slice { };

  vp = callPackage ../applications/misc/vp {
    # Enable next line for console graphics. Note that
    # it requires `sixel` enabled terminals such as mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
  };

  inherit (openconnectPackages) openconnect openconnect_unstable openconnect_openssl;

  globalprotect-openconnect = libsForQt5.callPackage ../tools/networking/globalprotect-openconnect { };

  sssd = callPackage ../os-specific/linux/sssd {
    inherit (perlPackages) Po4a;
  };

  sentry-cli = callPackage ../development/tools/sentry-cli {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  waifu2x-converter-cpp = callPackage ../tools/graphics/waifu2x-converter-cpp {
    inherit (darwin.apple_sdk.frameworks) OpenCL;
  };

  wakatime = python2Packages.callPackage ../tools/misc/wakatime { };

  watchexec = callPackage ../tools/misc/watchexec {
    inherit (darwin.apple_sdk.frameworks) Cocoa AppKit;
  };

  watchman = callPackage ../development/tools/watchman {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    autoconf = buildPackages.autoconf269;
  };

  webassemblyjs-cli = nodePackages."@webassemblyjs/cli-1.11.1";
  webassemblyjs-repl = nodePackages."@webassemblyjs/repl-1.11.1";
  wasm-strip = nodePackages."@webassemblyjs/wasm-strip";
  wasm-text-gen = nodePackages."@webassemblyjs/wasm-text-gen-1.11.1";
  wast-refmt = nodePackages."@webassemblyjs/wast-refmt-1.11.1";

  wasm-bindgen-cli = callPackage ../development/tools/wasm-bindgen-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
    nodejs = nodejs_latest;
  };

  wasmedge = callPackage ../development/tools/wasmedge {
    llvmPackages = llvmPackages_12;
  };

  whitebophir = callPackage ../servers/web-apps/whitebophir { };

  wg-netmanager = callPackage ../tools/networking/wg-netmanager {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  woodpecker-agent = callPackage ../development/tools/continuous-integration/woodpecker/agent.nix { };

  woodpecker-cli = callPackage ../development/tools/continuous-integration/woodpecker/cli.nix { };

  woodpecker-server = callPackage ../development/tools/continuous-integration/woodpecker/server.nix {
    woodpecker-frontend = callPackage ../development/tools/continuous-integration/woodpecker/frontend.nix { };
  };

  wstunnel = haskell.lib.compose.justStaticExecutables haskellPackages.wstunnel;

  testdisk = libsForQt5.callPackage ../tools/system/testdisk { };

  testdisk-qt = testdisk.override { enableQt = true; };

  htmldoc = callPackage ../tools/typesetting/htmldoc {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration Foundation;
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  tweet-hs = haskell.lib.compose.justStaticExecutables haskellPackages.tweet-hs;

  tremor-rs = callPackage ../tools/misc/tremor-rs {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  truecrack-cuda = truecrack.override { cudaSupport = true; };

  turbovnc = callPackage ../tools/admin/turbovnc {
    # fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc xorg.fontbhlucidatypewriter75dpi ];
    libjpeg_turbo = libjpeg_turbo.override { enableJava = true; };
  };

  uim = callPackage ../tools/inputmethods/uim {
    autoconf = buildPackages.autoconf269;
  };

  unbound-with-systemd = unbound.override {
    withSystemd = true;
  };

  unbound-full = unbound.override {
    python = python3;
    withSystemd = true;
    withPythonModule = true;
    withDoH = true;
    withECS = true;
    withDNSCrypt = true;
    withDNSTAP = true;
    withTFO = true;
    withRedis = true;
  };

  unicorn = callPackage ../development/libraries/unicorn {
    inherit (darwin.apple_sdk.frameworks) IOKit;
    inherit (darwin) cctools;
  };

  units = callPackage ../tools/misc/units {
    enableCurrenciesUpdater = true;
    pythonPackages = python3Packages;
  };

  unrar-wrapper = python3Packages.callPackage ../tools/archivers/unrar-wrapper { };

  xdp-tools = callPackage ../tools/networking/xdp-tools {
    llvmPackages = llvmPackages_14;
  };

  ugarit = callPackage ../tools/backup/ugarit {
    inherit (chickenPackages_4) eggDerivation fetchegg;
  };

  ugarit-manifest-maker = callPackage ../tools/backup/ugarit-manifest-maker {
    inherit (chickenPackages_4) eggDerivation fetchegg;
  };

  unar = callPackage ../tools/archivers/unar {
    inherit (darwin.apple_sdk.frameworks) Foundation AppKit;
    stdenv = clangStdenv;
  };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  inherit (callPackages ../servers/varnish { })
    varnish60 varnish72;
  inherit (callPackages ../servers/varnish/packages.nix { })
    varnish60Packages varnish72Packages;

  varnishPackages = varnish72Packages;
  varnish = varnishPackages.varnish;

  veracrypt = callPackage ../applications/misc/veracrypt {
    wxGTK = wxGTK32;
  };

  vncdo = with python3Packages; toPythonApplication vncdo;

  wagyu = callPackage ../tools/misc/wagyu {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  wget2 = callPackage ../tools/networking/wget2 {
    # update breaks grub2
    gnulib = pkgs.gnulib.overrideAttrs (_: rec {
      version = "20210208";
      src = fetchgit {
        url = "https://git.savannah.gnu.org/r/gnulib.git";
        rev = "0b38e1d69f03d3977d7ae7926c1efeb461a8a971";
        sha256 = "06bj9y8wcfh35h653yk8j044k7h5g82d2j3z3ib69rg0gy1xagzp";
      };
    });
  };

  wgpu-utils = callPackage ../tools/graphics/wgpu-utils {
    inherit (darwin.apple_sdk.frameworks) QuartzCore;
  };

  wiiuse = callPackage ../development/libraries/wiiuse {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation IOBluetooth;
  };

  wkhtmltopdf = libsForQt5.callPackage ../tools/graphics/wkhtmltopdf { };

  wkhtmltopdf-bin = callPackage ../tools/graphics/wkhtmltopdf-bin {
    libjpeg8 = libjpeg.override { enableJpeg8 = true; };
    openssl = openssl_1_1;
  };

  wring = nodePackages.wring;

  wyrd = callPackage ../tools/misc/wyrd {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  xbursttools = callPackage ../tools/misc/xburst-tools {
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross = pkgsCross.ben-nanonote.buildPackages.gccCrossStageStatic;
    autoconf = buildPackages.autoconf269;
  };

  xdot = with python3Packages; toPythonApplication xdot;

  xflux-gui = python3Packages.callPackage ../tools/misc/xflux/gui.nix { };

  libxfs = xfsprogs.dev;

  xmldiff = python3Packages.callPackage ../tools/text/xml/xmldiff { };

  xmlto = callPackage ../tools/typesetting/xmlto {
    w3m = w3m-batch;
  };

  xidlehook = callPackage ../tools/X11/xidlehook {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  xprite-editor = callPackage ../tools/misc/xprite-editor {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  xsv = callPackage ../tools/text/xsv {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  xtreemfs = callPackage ../tools/filesystems/xtreemfs {
    boost = boost17x;
  };

  xvfb-run = callPackage ../tools/misc/xvfb-run { inherit (texFunctions) fontsConf; };

  yapf = with python3Packages; toPythonApplication yapf;

  yarn2nix-moretea = callPackage ../development/tools/yarn2nix-moretea/yarn2nix { pkgs = pkgs.__splicedPackages; };
  yarn2nix-moretea-openssl_1_1 = callPackage ../development/tools/yarn2nix-moretea/yarn2nix {
    pkgs = pkgs.__splicedPackages;
    nodejs = nodejs.override { openssl = openssl_1_1; };
  };

  inherit (yarn2nix-moretea)
    yarn2nix
    mkYarnPackage
    mkYarnModules
    fixup_yarn_lock;

  yamlfix = with python3Packages; toPythonApplication yamlfix;

  yamllint = with python3Packages; toPythonApplication yamllint;

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix {
    haskellPackages = haskell.packages.ghc810;
  };

  zbar = libsForQt5.callPackage ../tools/graphics/zbar {
    inherit (darwin.apple_sdk.frameworks) Foundation;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  zellij = callPackage ../tools/misc/zellij {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
  };

  zenith = callPackage ../tools/system/zenith {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  # Nvidia support does not require any propietary libraries, so CI can build it.
  # Note that when enabling this unconditionally, non-nvidia users will always have an empty "GPU" section.
  zenith-nvidia = callPackage ../tools/system/zenith {
    inherit (darwin.apple_sdk.frameworks) IOKit;
    nvidiaSupport = true;
  };

  zint = qt6Packages.callPackage ../development/libraries/zint { };

  zstd = callPackage ../tools/compression/zstd {
    cmake = buildPackages.cmakeMinimal;
  };


  ### SHELLS

  runtimeShell = "${runtimeShellPackage}${runtimeShellPackage.shellPath}";
  runtimeShellPackage = bash;

  bash = lowPrio (callPackage ../shells/bash/5.nix {
    binutils = stdenv.cc.bintools;
  });
  # WARNING: this attribute is used by nix-shell so it shouldn't be removed/renamed
  bashInteractive = callPackage ../shells/bash/5.nix {
    binutils = stdenv.cc.bintools;
    interactive = true;
    withDocs = true;
  };
  bashInteractiveFHS = callPackage ../shells/bash/5.nix {
    binutils = stdenv.cc.bintools;
    interactive = true;
    withDocs = true;
    forFHSEnv = true;
  };

  fishPlugins = recurseIntoAttrs (callPackage ../shells/fish/plugins { });

  powerline = with python3Packages; toPythonApplication powerline;

  ### DEVELOPMENT / COMPILERS

  temurin-bin-19 = javaPackages.compiler.temurin-bin.jdk-19;
  temurin-jre-bin-19 = javaPackages.compiler.temurin-bin.jre-19;

  temurin-bin-18 = javaPackages.compiler.temurin-bin.jdk-18;
  temurin-jre-bin-18 = javaPackages.compiler.temurin-bin.jre-18;

  temurin-bin-17 = javaPackages.compiler.temurin-bin.jdk-17;
  temurin-jre-bin-17 = javaPackages.compiler.temurin-bin.jre-17;

  temurin-bin-16 = javaPackages.compiler.temurin-bin.jdk-16;
  temurin-bin-11 = javaPackages.compiler.temurin-bin.jdk-11;
  temurin-jre-bin-11 = javaPackages.compiler.temurin-bin.jre-11;
  temurin-bin-8 = javaPackages.compiler.temurin-bin.jdk-8;
  temurin-jre-bin-8 = javaPackages.compiler.temurin-bin.jre-8;

  temurin-bin = temurin-bin-19;
  temurin-jre-bin = temurin-jre-bin-19;

  semeru-bin-17 = javaPackages.compiler.semeru-bin.jdk-17;
  semeru-jre-bin-17 = javaPackages.compiler.semeru-bin.jre-17;
  semeru-bin-16 = javaPackages.compiler.semeru-bin.jdk-16;
  semeru-jre-bin-16 = javaPackages.compiler.semeru-bin.jre-16;
  semeru-bin-11 = javaPackages.compiler.semeru-bin.jdk-11;
  semeru-jre-bin-11 = javaPackages.compiler.semeru-bin.jre-11;
  semeru-bin-8 = javaPackages.compiler.semeru-bin.jdk-8;
  semeru-jre-bin-8 = javaPackages.compiler.semeru-bin.jre-8;

  semeru-bin = semeru-bin-17;
  semeru-jre-bin = semeru-jre-bin-17;

  adoptopenjdk-bin-17-packages-linux = import ../development/compilers/adoptopenjdk-bin/jdk17-linux.nix { inherit stdenv lib; };
  adoptopenjdk-bin-17-packages-darwin = import ../development/compilers/adoptopenjdk-bin/jdk17-darwin.nix { inherit lib; };

  adoptopenjdk-hotspot-bin-16 = javaPackages.compiler.adoptopenjdk-16.jdk-hotspot;
  adoptopenjdk-jre-hotspot-bin-16 = javaPackages.compiler.adoptopenjdk-16.jre-hotspot;
  adoptopenjdk-openj9-bin-16 = javaPackages.compiler.adoptopenjdk-16.jdk-openj9;
  adoptopenjdk-jre-openj9-bin-16 = javaPackages.compiler.adoptopenjdk-16.jre-openj9;

  adoptopenjdk-hotspot-bin-15 = javaPackages.compiler.adoptopenjdk-15.jdk-hotspot;
  adoptopenjdk-jre-hotspot-bin-15 = javaPackages.compiler.adoptopenjdk-15.jre-hotspot;
  adoptopenjdk-openj9-bin-15 = javaPackages.compiler.adoptopenjdk-15.jdk-openj9;
  adoptopenjdk-jre-openj9-bin-15 = javaPackages.compiler.adoptopenjdk-15.jre-openj9;

  adoptopenjdk-hotspot-bin-11 = javaPackages.compiler.adoptopenjdk-11.jdk-hotspot;
  adoptopenjdk-jre-hotspot-bin-11 = javaPackages.compiler.adoptopenjdk-11.jre-hotspot;
  adoptopenjdk-openj9-bin-11 = javaPackages.compiler.adoptopenjdk-11.jdk-openj9;
  adoptopenjdk-jre-openj9-bin-11 = javaPackages.compiler.adoptopenjdk-11.jre-openj9;

  adoptopenjdk-hotspot-bin-8 = javaPackages.compiler.adoptopenjdk-8.jdk-hotspot;
  adoptopenjdk-jre-hotspot-bin-8 = javaPackages.compiler.adoptopenjdk-8.jre-hotspot;
  adoptopenjdk-openj9-bin-8 = javaPackages.compiler.adoptopenjdk-8.jdk-openj9;
  adoptopenjdk-jre-openj9-bin-8 = javaPackages.compiler.adoptopenjdk-8.jre-openj9;

  adoptopenjdk-bin = adoptopenjdk-hotspot-bin-11;
  adoptopenjdk-jre-bin = adoptopenjdk-jre-hotspot-bin-11;

  adoptopenjdk-icedtea-web = callPackage ../development/compilers/adoptopenjdk-icedtea-web {
    jdk = jdk8;
  };

  armips = callPackage ../development/compilers/armips {
    stdenv = gcc10Stdenv;
  };

  asl = callPackage ../development/compilers/asl {
    tex = texlive.combined.scheme-medium;
  };

  ballerina = callPackage ../development/compilers/ballerina {
    openjdk = openjdk11_headless;
  };

  binaryen = callPackage ../development/compilers/binaryen {
    nodejs = nodejs-slim;
    inherit (python3Packages) filecheck;
  };

  bluespec = callPackage ../development/compilers/bluespec {
    gmp-static = gmp.override { withStatic = true; };
    tex = texlive.combined.scheme-full;
  };

  colmap = libsForQt5.callPackage ../applications/science/misc/colmap { cudaSupport = config.cudaSupport or false; };
  colmapWithCuda = colmap.override { cudaSupport = true; };

  chickenPackages = chickenPackages_5;

  inherit (chickenPackages)
    fetchegg
    eggDerivation
    chicken
    egg2nix;

  ccl = callPackage ../development/compilers/ccl {
    inherit (buildPackages.darwin) bootstrap_cmds;
  };

  cdb = callPackage ../development/tools/database/cdb {
    stdenv = gccStdenv;
  };

  chez = callPackage ../development/compilers/chez {
    inherit (darwin) cctools;
  };

  libclang = llvmPackages.libclang;
  clang-manpages = llvmPackages.clang-manpages;

  clang-sierraHack = clang.override {
    name = "clang-wrapper-with-reexport-hack";
    bintools = darwin.binutils.override {
      useMacosReexportHack = true;
    };
  };

  clang = llvmPackages.clang;
  clang_5  = llvmPackages_5.clang;
  clang_6  = llvmPackages_6.clang;
  clang_7  = llvmPackages_7.clang;
  clang_8  = llvmPackages_8.clang;
  clang_9  = llvmPackages_9.clang;
  clang_10 = llvmPackages_10.clang;
  clang_11 = llvmPackages_11.clang;
  clang_12 = llvmPackages_12.clang;
  clang_13 = llvmPackages_13.clang;
  clang_14 = llvmPackages_14.clang;

  clang-tools = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_latest;
  };

  clang-tools_5 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_5;
  };

  clang-tools_6 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_6;
  };

  clang-tools_7 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_7;
  };

  clang-tools_8 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_8;
  };

  clang-tools_9 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_9;
  };

  clang-tools_10 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_10;
  };

  clang-tools_11 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_11;
  };

  clang-tools_12 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_12;
  };

  clang-tools_13 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_13;
  };

  clang-tools_14 = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_14;
  };

  clang-analyzer = callPackage ../development/tools/analysis/clang-analyzer {
    llvmPackages = llvmPackages_latest;
    inherit (llvmPackages_latest) clang;
  };

  #Use this instead of stdenv to build with clang
  clangStdenv = if stdenv.cc.isClang then stdenv else lowPrio llvmPackages.stdenv;
  clang-sierraHack-stdenv = overrideCC stdenv buildPackages.clang-sierraHack;
  libcxxStdenv = if stdenv.isDarwin then stdenv else lowPrio llvmPackages.libcxxStdenv;
  rocmClangStdenv = llvmPackages_rocm.rocmClangStdenv;

  clasp-common-lisp = callPackage ../development/compilers/clasp {
    llvmPackages = llvmPackages_6;
    stdenv = llvmPackages_6.stdenv;
  };

  clickable = python3Packages.callPackage ../development/tools/clickable { };

  cmucl_binary = pkgsi686Linux.callPackage ../development/compilers/cmucl/binary.nix { };

  inherit (coqPackages) compcert;

  computecpp = wrapCCWith rec {
    cc = computecpp-unwrapped;
    extraPackages = [
      llvmPackages.compiler-rt
    ];
    extraBuildCommands = ''
      wrap compute $wrapper $ccPath/compute
      wrap compute++ $wrapper $ccPath/compute++
      export named_cc=compute
      export named_cxx=compute++

      rsrc="$out/resource-root"
      mkdir -p "$rsrc/lib"
      ln -s "${cc}/lib" "$rsrc/include"
      echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
    '';
  };

  cotton = callPackage ../development/tools/cotton {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  inherit (callPackages ../development/compilers/crystal {
    llvmPackages = llvmPackages_13;
    stdenv = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
  })
    crystal_1_2
    crystal_1_7
    crystal;

  scry = callPackage ../development/tools/scry { crystal = crystal_1_2; };

  devpi-client = python3Packages.callPackage ../development/tools/devpi-client {};

  devpi-server = python3Packages.callPackage ../development/tools/devpi-server {};

  elm2nix = haskell.lib.compose.justStaticExecutables haskellPackages.elm2nix;

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  fasm = pkgsi686Linux.callPackage ../development/compilers/fasm {
    inherit (stdenv) isx86_64;
  };

  fbc = if stdenv.hostPlatform.isDarwin then
    callPackage ../development/compilers/fbc/mac-bin.nix { }
  else
    callPackage ../development/compilers/fbc { };

  filecheck = with python3Packages; toPythonApplication filecheck;

  flutterPackages =
    recurseIntoAttrs (callPackage ../development/compilers/flutter { });
  flutter = flutterPackages.stable;
  flutter2 = flutterPackages.v2;

  fnm = callPackage ../development/tools/fnm {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation Security;
  };

  gambit = callPackage ../development/compilers/gambit { };
  gambit-unstable = callPackage ../development/compilers/gambit/unstable.nix { };
  gerbil = callPackage ../development/compilers/gerbil { };
  gerbil-unstable = callPackage ../development/compilers/gerbil/unstable.nix { };
  gerbilPackages-unstable = gerbil-support.gerbilPackages-unstable; # NB: don't recurseIntoAttrs for (unstable!) libraries

  inherit (let
      num =
        if (with stdenv.targetPlatform; isVc4 || libc == "relibc") then 6
        else if (stdenv.targetPlatform.isAarch64 && stdenv.isLinux) then 9
        else 11;
      numS = toString num;
    in {
      gcc = pkgs.${"gcc${numS}"};
      gccFun = callPackage (../development/compilers/gcc + "/${numS}");
    }) gcc gccFun;
  gcc-unwrapped = gcc.cc;

  wrapNonDeterministicGcc = stdenv: ccWrapper:
    if ccWrapper.isGNU then ccWrapper.overrideAttrs(old: {
      env = old.env // {
        cc = old.env.cc.override {
          reproducibleBuild = false;
          profiledCompiler = with stdenv; (!isDarwin && hostPlatform.isx86);
        };
      };
    }) else ccWrapper;

  gccStdenv =
    if stdenv.cc.isGNU
    then stdenv
    else stdenv.override {
      cc = buildPackages.gcc;
      allowedRequisites = null;
      # Remove libcxx/libcxxabi, and add clang for AS if on darwin (it uses
      # clang's internal assembler).
      extraBuildInputs = lib.optional stdenv.hostPlatform.isDarwin clang.cc;
    };

  gcc49Stdenv = overrideCC gccStdenv buildPackages.gcc49;
  gcc6Stdenv = overrideCC gccStdenv buildPackages.gcc6;
  gcc7Stdenv = overrideCC gccStdenv buildPackages.gcc7;
  gcc8Stdenv = overrideCC gccStdenv buildPackages.gcc8;
  gcc9Stdenv = overrideCC gccStdenv buildPackages.gcc9;
  gcc10Stdenv = overrideCC gccStdenv buildPackages.gcc10;
  gcc11Stdenv = overrideCC gccStdenv buildPackages.gcc11;
  gcc12Stdenv = overrideCC gccStdenv buildPackages.gcc12;

  gcc10StdenvCompat = if stdenv.cc.isGNU && lib.versions.major stdenv.cc.version == "11" then gcc10Stdenv else stdenv;

  # This is not intended for use in nixpkgs but for providing a faster-running
  # compiler to nixpkgs users by building gcc with reproducibility-breaking
  # profile-guided optimizations
  fastStdenv = overrideCC gccStdenv (wrapNonDeterministicGcc gccStdenv buildPackages.gcc_latest);

  wrapCCMulti = cc:
    if stdenv.targetPlatform.system == "x86_64-linux" then let
      # Binutils with glibc multi
      bintools = cc.bintools.override {
        libc = glibc_multi;
      };
    in lowPrio (wrapCCWith {
      cc = cc.cc.override {
        stdenv = overrideCC stdenv (wrapCCWith {
          cc = cc.cc;
          inherit bintools;
          libc = glibc_multi;
        });
        profiledCompiler = false;
        enableMultilib = true;
      };
      libc = glibc_multi;
      inherit bintools;
      extraBuildCommands = ''
        echo "dontMoveLib64=1" >> $out/nix-support/setup-hook
      '';
  }) else throw "Multilib ${cc.name} not supported for ‘${stdenv.targetPlatform.system}’";

  wrapClangMulti = clang:
    if stdenv.targetPlatform.system == "x86_64-linux" then
      callPackage ../development/compilers/llvm/multi.nix {
        inherit clang;
        gcc32 = pkgsi686Linux.gcc;
        gcc64 = pkgs.gcc;
      }
    else throw "Multilib ${clang.cc.name} not supported for '${stdenv.targetPlatform.system}'";

  gcc_multi = wrapCCMulti gcc;
  clang_multi = wrapClangMulti clang;

  gccMultiStdenv = overrideCC stdenv buildPackages.gcc_multi;
  clangMultiStdenv = overrideCC stdenv buildPackages.clang_multi;
  multiStdenv = if stdenv.cc.isClang then clangMultiStdenv else gccMultiStdenv;

  gcc_debug = lowPrio (wrapCC (gcc.cc.overrideAttrs (_: {
    dontStrip = true;
  })));

  gccCrossLibcStdenv = overrideCC stdenv buildPackages.gccCrossStageStatic;

  crossLibcStdenv =
    if stdenv.hostPlatform.useLLVM or false || stdenv.hostPlatform.isDarwin
    then overrideCC stdenv buildPackages.llvmPackages.clangNoLibc
    else gccCrossLibcStdenv;

  # The GCC used to build libc for the target platform. Normal gccs will be
  # built with, and use, that cross-compiled libc.
  gccCrossStageStatic = assert stdenv.targetPlatform != stdenv.hostPlatform; let
    libcCross1 = binutilsNoLibc.libc;
    in wrapCCWith {
      cc = gccFun {
        # copy-pasted
        inherit noSysDirs;

        reproducibleBuild = true;
        profiledCompiler = false;

        isl = if !stdenv.isDarwin then isl_0_20 else null;

        # just for stage static
        crossStageStatic = true;
        langCC = false;
        libcCross = libcCross1;
        targetPackages.stdenv.cc.bintools = binutilsNoLibc;
        enableShared = false;
      };
      bintools = binutilsNoLibc;
      libc = libcCross1;
      extraPackages = [];
  };

  gcc48 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.8 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    isl = if !stdenv.isDarwin then isl_0_14 else null;
    cloog = if !stdenv.isDarwin then cloog else null;
    texinfo = texinfo5; # doesn't validate since 6.1 -> 6.3 bump
  }));

  gcc49 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.9 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    isl = if !stdenv.isDarwin then isl_0_11 else null;

    cloog = if !stdenv.isDarwin then cloog_0_18_0 else null;

    # Build fails on Darwin with clang
    stdenv = if stdenv.isDarwin then gccStdenv else stdenv;
  }));

  gcc6 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/6 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    # gcc 10 is too strict to cross compile gcc <= 8
    stdenv = if (stdenv.targetPlatform != stdenv.buildPlatform) && stdenv.cc.isGNU then gcc7Stdenv else stdenv;

    isl = if stdenv.isDarwin
            then null
          else if stdenv.targetPlatform.isRedox
            then isl_0_17
          else isl_0_14;
  }));

  gcc7 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/7 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    # gcc 10 is too strict to cross compile gcc <= 8
    stdenv = if (stdenv.targetPlatform != stdenv.buildPlatform) && stdenv.cc.isGNU then gcc7Stdenv else stdenv;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc8 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/8 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    # gcc 10 is too strict to cross compile gcc <= 8
    stdenv = if (stdenv.targetPlatform != stdenv.buildPlatform) && stdenv.cc.isGNU then gcc7Stdenv else stdenv;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc9 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/9 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    isl = if !stdenv.isDarwin then isl_0_20 else null;
  }));

  gcc10 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/10 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    isl = if !stdenv.isDarwin then isl_0_20 else null;
  }));

  gcc11 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/11 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    isl = if !stdenv.isDarwin then isl_0_20 else null;
  }));

  gcc12 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/12 {
    inherit noSysDirs;

    reproducibleBuild = true;
    profiledCompiler = false;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else {};

    isl = if !stdenv.isDarwin then isl_0_20 else null;
  }));

  gcc_latest = gcc12;

  # Use the same GCC version as the one from stdenv by default
  gfortran = wrapCC (gcc.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran48 = wrapCC (gcc48.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran49 = wrapCC (gcc49.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran6 = wrapCC (gcc6.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran7 = wrapCC (gcc7.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran8 = wrapCC (gcc8.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran9 = wrapCC (gcc9.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran10 = wrapCC (gcc10.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran11 = wrapCC (gcc11.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran12 = wrapCC (gcc12.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  libgccjit = gcc.cc.override {
    name = "libgccjit";
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    langJit = true;
    enableLTO = false;
  };

  gcj = gcj6;
  gcj6 = wrapCC (gcc6.cc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkg-config perl;
    inherit (gnome2) libart_lgpl;
  });

  gnat = gnat12;

  gnat11 = wrapCC (gcc11.cc.override {
    name = "gnat";
    langC = true;
    langCC = false;
    langAda = true;
    profiledCompiler = false;
    # As per upstream instructions building a cross compiler
    # should be done with a (native) compiler of the same version.
    # If we are cross-compiling GNAT, we may as well do the same.
    gnatboot =
      if stdenv.hostPlatform == stdenv.targetPlatform
         && stdenv.buildPlatform == stdenv.hostPlatform
      then buildPackages.gnatboot11
      else buildPackages.gnat11;
  });

  gnat12 = wrapCC (gcc12.cc.override {
    name = "gnat";
    langC = true;
    langCC = false;
    langAda = true;
    profiledCompiler = false;
    # As per upstream instructions building a cross compiler
    # should be done with a (native) compiler of the same version.
    # If we are cross-compiling GNAT, we may as well do the same.
    gnatboot =
      if stdenv.hostPlatform == stdenv.targetPlatform
         && stdenv.buildPlatform == stdenv.hostPlatform
      then buildPackages.gnatboot12
      else buildPackages.gnat12;
    stdenv =
      if stdenv.hostPlatform == stdenv.targetPlatform
         && stdenv.buildPlatform == stdenv.hostPlatform
         && stdenv.buildPlatform.isDarwin
         && stdenv.buildPlatform.isx86_64
      then overrideCC stdenv gnatboot12
      else stdenv;
  });

  gnatboot = gnatboot12;
  gnatboot11 = wrapCC (callPackage ../development/compilers/gnatboot { majorVersion = "11"; });
  gnatboot12 = wrapCCWith ({
    cc = callPackage ../development/compilers/gnatboot { majorVersion = "12"; };
  } // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
    bintools = bintoolsDualAs;
  });

  gccgo = wrapCC ((if stdenv.hostPlatform.isMusl then gcc_latest else gcc).cc.override {
    name = "gccgo";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
    langJit = true;
    profiledCompiler = false;
  });

  ghdl = ghdl-mcode;

  ghdl-mcode = callPackage ../development/compilers/ghdl {
    backend = "mcode";
  };

  ghdl-llvm = callPackage ../development/compilers/ghdl {
    backend = "llvm";
  };

  gcl = callPackage ../development/compilers/gcl {
    gmp = gmp4;
  };

  gcc-arm-embedded = gcc-arm-embedded-12;

  # Has to match the default gcc so that there are no linking errors when
  # using C/C++ libraries in D packages
  gdc = wrapCC (gcc.cc.override {
    name = "gdc";
    langCC = false;
    langC = false;
    langD = true;
    profiledCompiler = false;
  });

  gleam = callPackage ../development/compilers/gleam {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  # Haskell and GHC

  haskell = callPackage ./haskell-packages.nix { };

  haskellPackages = dontRecurseIntoAttrs
    # JS backend is only available for GHC >= 9.6
    (if stdenv.hostPlatform.isGhcjs
     then haskell.packages.native-bignum.ghcHEAD
     # Prefer native-bignum to avoid linking issues with gmp
     else if stdenv.hostPlatform.isStatic
     then haskell.packages.native-bignum.ghc92
     else haskell.packages.ghc92);

  # haskellPackages.ghc is build->host (it exposes the compiler used to build the
  # set, similarly to stdenv.cc), but pkgs.ghc should be host->target to be more
  # consistent with the gcc, gnat, clang etc. derivations
  #
  # We use targetPackages.haskellPackages.ghc if available since this also has
  # the withPackages wrapper available. In the final cross-compiled package set
  # however, targetPackages won't be populated, so we need to fall back to the
  # plain, cross-compiled compiler (which is only theoretical at the moment).
  ghc = targetPackages.haskellPackages.ghc or
    # Prefer native-bignum to avoid linking issues with gmp
    (if stdenv.targetPlatform.isStatic
       then haskell.compiler.native-bignum.ghc92
       else haskell.compiler.ghc92);

  cabal-install = haskell.lib.compose.justStaticExecutables haskellPackages.cabal-install;

  stack = haskell.lib.compose.justStaticExecutables haskellPackages.stack;

  hlint = haskell.lib.compose.justStaticExecutables haskellPackages.hlint;

  krank = haskell.lib.compose.justStaticExecutables haskellPackages.krank;

  stylish-cabal = haskell.lib.compose.justStaticExecutables haskellPackages.stylish-cabal;

  lhs2tex = haskellPackages.lhs2tex;

  all-cabal-hashes = callPackage ../data/misc/hackage { };

  purescript-psa = nodePackages.purescript-psa;

  purenix = haskell.lib.compose.justStaticExecutables haskellPackages.purenix;

  pulp = nodePackages.pulp;

  pscid = nodePackages.pscid;

  coreboot-toolchain = recurseIntoAttrs (callPackage ../development/tools/misc/coreboot-toolchain { });

  tamarin-prover =
    (haskellPackages.callPackage ../applications/science/logic/tamarin-prover {
      # NOTE: do not use the haskell packages 'graphviz' and 'maude'
      inherit maude which;
      graphviz = graphviz-nox;
    });

  inherit (callPackage ../development/compilers/haxe {
    inherit (darwin.apple_sdk.frameworks) Security;
  })
    haxe_4_2
    haxe_4_1
    haxe_4_0
    haxe_3_4
    haxe_3_2
    ;

  haxe = haxe_4_2;
  haxePackages = recurseIntoAttrs (callPackage ./haxe-packages.nix { });
  inherit (haxePackages) hxcpp;

  falcon = callPackage ../development/interpreters/falcon {
    stdenv = gcc10Stdenv;
  };

  fstar = callPackage ../development/compilers/fstar {
    # Work around while compatibility with ppxlib >= 0.26 is unavailable
    # Should be removed when a fix is available
    # See https://github.com/FStarLang/FStar/issues/2681
    ocamlPackages =
      ocamlPackages.overrideScope' (self: super: {
        ppxlib = super.ppxlib.override {
          version = if lib.versionAtLeast self.ocaml.version "4.07"
                    then if lib.versionAtLeast self.ocaml.version "4.08"
                         then "0.24.0" else "0.15.0" else "0.13.0";
        };
        ppx_deriving_yojson = super.ppx_deriving_yojson.overrideAttrs (oldAttrs: rec {
          version = "3.6.1";
          src = fetchFromGitHub {
            owner = "ocaml-ppx";
            repo = "ppx_deriving_yojson";
            rev = "v${version}";
            sha256 = "1icz5h6p3pfj7my5gi7wxpflrb8c902dqa17f9w424njilnpyrbk";
          };
        });
        sedlex = super.sedlex.overrideAttrs (oldAttrs: rec {
          version = "2.5";
          src = fetchFromGitHub {
            owner = "ocaml-community";
            repo = "sedlex";
            rev = "v${version}";
            sha256 = "sha256:062a5dvrzvb81l3a9phljrhxfw9nlb61q341q0a6xn65hll3z2wy";
          };
        });
      });
  };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix {});

  gobang = callPackage ../development/tools/database/gobang {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security SystemConfiguration;
  };

  gwe = callPackage ../tools/misc/gwe {
    nvidia_x11 = linuxPackages.nvidia_x11;
  };

  iay = callPackage ../tools/misc/iay {
    inherit (darwin.apple_sdk.frameworks) AppKit Security Foundation Cocoa;
  };

  idrisPackages = dontRecurseIntoAttrs (callPackage ../development/idris-modules {
    idris-no-deps = haskellPackages.idris;
  });

  idris = idrisPackages.with-packages [ idrisPackages.base ] ;

  inherit (callPackage ../development/tools/database/indradb { })
    indradb-server
    indradb-client;

  irony-server = callPackage ../development/tools/irony-server {
    # The repository of irony to use -- must match the version of the employed emacs
    # package.  Wishing we could merge it into one irony package, to avoid this issue,
    # but its emacs-side expression is autogenerated, and we can't hook into it (other
    # than peek into its version).
    inherit (emacs.pkgs.melpaStablePackages) irony;
  };

  inherit (javaPackages) openjfx11 openjfx15 openjfx17;
  openjfx = openjfx17;

  openjdk8-bootstrap = javaPackages.compiler.openjdk8-bootstrap;
  openjdk8 = javaPackages.compiler.openjdk8;
  openjdk8_headless = javaPackages.compiler.openjdk8.headless;
  jdk8 = openjdk8;
  jdk8_headless = openjdk8_headless;
  jre8 = openjdk8.jre;
  jre8_headless = openjdk8_headless.jre;

  openjdk11-bootstrap = javaPackages.compiler.openjdk11-bootstrap;
  openjdk11 = javaPackages.compiler.openjdk11;
  openjdk11_headless = javaPackages.compiler.openjdk11.headless;
  jdk11 = openjdk11;
  jdk11_headless = openjdk11_headless;

  openjdk17-bootstrap = javaPackages.compiler.openjdk17-bootstrap;
  openjdk17 = javaPackages.compiler.openjdk17;
  openjdk17_headless = javaPackages.compiler.openjdk17.headless;
  jdk17 = openjdk17;
  jdk17_headless = openjdk17_headless;

  openjdk16-bootstrap = javaPackages.compiler.openjdk16-bootstrap;

  openjdk19 = javaPackages.compiler.openjdk19;
  openjdk19_headless = javaPackages.compiler.openjdk19.headless;
  jdk19 = openjdk19;
  jdk19_headless = openjdk19_headless;

  /* default JDK */
  jdk = jdk19;
  jdk_headless = jdk19_headless;

  # Since the introduction of the Java Platform Module System in Java 9, Java
  # no longer ships a separate JRE package.
  #
  # If you are building a 'minimal' system/image, you are encouraged to use
  # 'jre_minimal' to build a bespoke JRE containing only the modules you need.
  #
  # For a general-purpose system, 'jre' defaults to the full JDK:
  jre = jdk;
  jre_headless = jdk_headless;

  jre17_minimal = callPackage ../development/compilers/openjdk/jre.nix {
    jdk = jdk17;
  };
  jre_minimal = callPackage ../development/compilers/openjdk/jre.nix { };

  openjdk = jdk;
  openjdk_headless = jdk_headless;

  graalvmCEPackages =
    recurseIntoAttrs (callPackage ../development/compilers/graalvm/community-edition {
      inherit (darwin.apple_sdk.frameworks) Foundation;
    });
  graalvm11-ce = graalvmCEPackages.graalvm11-ce;
  graalvm17-ce = graalvmCEPackages.graalvm17-ce;
  buildGraalvmNativeImage = callPackage ../build-support/build-graalvm-native-image {
    graalvm = graalvm11-ce;
  };

  openshot-qt = libsForQt5.callPackage ../applications/video/openshot-qt { };

  oraclejdk = jdkdistro true false;

  oraclejdk8 = oraclejdk8distro true false;

  oraclejre = lowPrio (jdkdistro false false);

  oraclejre8 = lowPrio (oraclejdk8distro false false);

  jrePlugin = jre8Plugin;

  jre8Plugin = lowPrio (oraclejdk8distro false true);

  jdkdistro = oraclejdk8distro;

  oraclejdk8distro = installjdk: pluginSupport:
    (callPackage ../development/compilers/oraclejdk/jdk8-linux.nix {
      inherit installjdk pluginSupport;
    });

  java-service-wrapper = callPackage ../tools/system/java-service-wrapper {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  javacard-devkit = pkgsi686Linux.callPackage ../development/compilers/javacard-devkit { };

  julia-lts = julia_16-bin;
  julia-stable = julia_18;
  julia = julia-stable;

  julia_18 = callPackage ../development/compilers/julia/1.8.nix { };
  julia_19 = callPackage ../development/compilers/julia/1.9.nix { };

  julia-lts-bin = julia_16-bin;
  julia-stable-bin = julia_18-bin;
  julia-bin = julia-stable-bin;

  kind2 = callPackage ../development/compilers/kind2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  koka = haskell.lib.compose.justStaticExecutables (haskellPackages.callPackage ../development/compilers/koka { });

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lazarus-qt = libsForQt5.callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
    withQt = true;
  };

  lessc = nodePackages.less;

  lobster = callPackage ../development/compilers/lobster {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks)
      Cocoa AudioToolbox OpenGL Foundation ForceFeedback;
  };

  lld = llvmPackages.lld;
  lld_5 = llvmPackages_5.lld;
  lld_6 = llvmPackages_6.lld;
  lld_7 = llvmPackages_7.lld;
  lld_8 = llvmPackages_8.lld;
  lld_9 = llvmPackages_9.lld;
  lld_10 = llvmPackages_10.lld;
  lld_11 = llvmPackages_11.lld;
  lld_12 = llvmPackages_12.lld;
  lld_13 = llvmPackages_13.lld;
  lld_14 = llvmPackages_14.lld;

  lldb = llvmPackages_latest.lldb;
  lldb_5 = llvmPackages_5.lldb;
  lldb_6 = llvmPackages_6.lldb;
  lldb_7 = llvmPackages_7.lldb;
  lldb_8 = llvmPackages_8.lldb;
  lldb_9 = llvmPackages_9.lldb;
  lldb_10 = llvmPackages_10.lldb;
  lldb_11 = llvmPackages_11.lldb;
  lldb_12 = llvmPackages_12.lldb;
  lldb_13 = llvmPackages_13.lldb;
  lldb_14 = llvmPackages_14.lldb;

  llvm = llvmPackages.llvm;
  llvm_5  = llvmPackages_5.llvm;
  llvm_6  = llvmPackages_6.llvm;
  llvm_7  = llvmPackages_7.llvm;
  llvm_8  = llvmPackages_8.llvm;
  llvm_9  = llvmPackages_9.llvm;
  llvm_10 = llvmPackages_10.llvm;
  llvm_11 = llvmPackages_11.llvm;
  llvm_12 = llvmPackages_12.llvm;
  llvm_13 = llvmPackages_13.llvm;
  llvm_14 = llvmPackages_14.llvm;

  libllvm = llvmPackages.libllvm;
  llvm-manpages = llvmPackages.llvm-manpages;

  llvmPackages = let
    latest_version = lib.toInt
      (lib.versions.major llvmPackages_latest.llvm.version);
    # This returns the minimum supported version for the platform. The
    # assumption is that or any later version is good.
    choose = platform:
      /**/ if platform.isDarwin then 11
      else if platform.isFreeBSD then 12
      else if platform.isAndroid then 12
      else if platform.system == "armv6l-linux" then 7  # This fixes armv6 cross-compilation
      else if platform.isLinux then 11
      else if platform.isWasm then 12
      else latest_version;
    # We take the "max of the mins". Why? Since those are lower bounds of the
    # supported version set, this is like intersecting those sets and then
    # taking the min bound of that.
    minSupported = toString (lib.trivial.max (choose stdenv.hostPlatform) (choose
      stdenv.targetPlatform));
  in pkgs.${"llvmPackages_${minSupported}"};

  llvmPackages_5 = recurseIntoAttrs (callPackage ../development/compilers/llvm/5 {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_5.tools;
    targetLlvm = targetPackages.llvmPackages_5.llvm or llvmPackages_5.llvm;
    targetLlvmLibraries = targetPackages.llvmPackages_5.libraries or llvmPackages_5.libraries;
  });

  llvmPackages_6 = recurseIntoAttrs (callPackage ../development/compilers/llvm/6 {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_6.tools;
    targetLlvm = targetPackages.llvmPackages_6.llvm or llvmPackages_6.llvm;
    targetLlvmLibraries = targetPackages.llvmPackages_6.libraries or llvmPackages_6.libraries;
  });

  llvmPackages_7 = recurseIntoAttrs (callPackage ../development/compilers/llvm/7 {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_7.tools;
    targetLlvm = targetPackages.llvmPackages_7.llvm or llvmPackages_7.llvm;
    targetLlvmLibraries = targetPackages.llvmPackages_7.libraries or llvmPackages_7.libraries;
  });

  llvmPackages_8 = recurseIntoAttrs (callPackage ../development/compilers/llvm/8 {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_8.tools;
    targetLlvm = targetPackages.llvmPackages_8.llvm or llvmPackages_8.llvm;
    targetLlvmLibraries = targetPackages.llvmPackages_8.libraries or llvmPackages_8.libraries;
  });

  llvmPackages_9 = recurseIntoAttrs (callPackage ../development/compilers/llvm/9 {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_9.tools;
    targetLlvm = targetPackages.llvmPackages_9.llvm or llvmPackages_9.llvm;
    targetLlvmLibraries = targetPackages.llvmPackages_9.libraries or llvmPackages_9.libraries;
  });

  llvmPackages_10 = recurseIntoAttrs (callPackage ../development/compilers/llvm/10 {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_10.tools;
    targetLlvm = targetPackages.llvmPackages_10.llvm or llvmPackages_10.llvm;
    targetLlvmLibraries = targetPackages.llvmPackages_10.libraries or llvmPackages_10.libraries;
  });

  llvmPackages_11 = recurseIntoAttrs (callPackage ../development/compilers/llvm/11 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_11.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_11.libraries or llvmPackages_11.libraries;
    targetLlvm = targetPackages.llvmPackages_11.llvm or llvmPackages_11.llvm;
  }));

  llvmPackages_12 = recurseIntoAttrs (callPackage ../development/compilers/llvm/12 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_12.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_12.libraries or llvmPackages_12.libraries;
    targetLlvm = targetPackages.llvmPackages_12.llvm or llvmPackages_12.llvm;
  }));

  llvmPackages_13 = recurseIntoAttrs (callPackage ../development/compilers/llvm/13 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_13.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_13.libraries or llvmPackages_13.libraries;
    targetLlvm = targetPackages.llvmPackages_13.llvm or llvmPackages_13.llvm;
  }));

  llvmPackages_14 = recurseIntoAttrs (callPackage ../development/compilers/llvm/14 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_14.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_14.libraries or llvmPackages_14.libraries;
    targetLlvm = targetPackages.llvmPackages_14.llvm or llvmPackages_14.llvm;
  }));

  llvmPackages_latest = llvmPackages_14;

  llvmPackages_rocm = recurseIntoAttrs (callPackage ../development/compilers/llvm/rocm { });

  lorri = callPackage ../tools/misc/lorri {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  mint = callPackage ../development/compilers/mint { crystal = crystal_1_2; };

  mitscheme = callPackage ../development/compilers/mit-scheme
    { stdenv = gcc10StdenvCompat; texLive = texlive.combine { inherit (texlive) scheme-small epsf texinfo; }; };

  mitschemeX11 = mitscheme.override {
    enableX11 = true;
  };

  inherit (callPackage ../development/compilers/mlton {})
    mlton20130715
    mlton20180207Binary
    mlton20180207
    mlton20210107
    mltonHEAD;

  mlton = mlton20210107;

  mono = mono6;

  mono4 = lowPrio (callPackage ../development/compilers/mono/4.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono5 = callPackage ../development/compilers/mono/5.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  mono6 = callPackage ../development/compilers/mono/6.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  mozart2 = callPackage ../development/compilers/mozart {
    emacs = emacs-nox;
    jre_headless = jre8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  inherit (callPackages ../development/compilers/nim { })
    nim-unwrapped nimble-unwrapped nim;
  nimPackages = recurseIntoAttrs nim.pkgs;

  nextpnr = callPackage ../development/compilers/nextpnr { };

  nextpnrWithGui = libsForQt5.callPackage ../development/compilers/nextpnr {
    enableGui = true;
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  obliv-c = callPackage ../development/compilers/obliv-c
    { stdenv = gcc10StdenvCompat; ocamlPackages = ocaml-ng.ocamlPackages_4_05; };

  ocaml-ng = callPackage ./ocaml-packages.nix { };
  ocaml = ocamlPackages.ocaml;

  ocamlPackages = recurseIntoAttrs ocaml-ng.ocamlPackages;

  ocaml-crunch = ocamlPackages.crunch.bin;

  inherit (callPackage ../development/tools/ocaml/ocamlformat { })
    ocamlformat # latest version
    ocamlformat_0_19_0 ocamlformat_0_20_0 ocamlformat_0_20_1 ocamlformat_0_21_0
    ocamlformat_0_22_4 ocamlformat_0_23_0 ocamlformat_0_24_1;

  opa = callPackage ../development/compilers/opa {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  opam = callPackage ../development/tools/ocaml/opam {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };
  opam_1_2 = callPackage ../development/tools/ocaml/opam/1.2.2.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  open-watcom-v2 = wrapWatcom open-watcom-v2-unwrapped { };
  open-watcom-bin = wrapWatcom open-watcom-bin-unwrapped { };

  ponyc = callPackage ../development/compilers/ponyc {
    # Upstream pony has dropped support for versions compiled with gcc.
    stdenv = llvmPackages_9.stdenv;
  };

  replibyte = callPackage ../development/tools/database/replibyte {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  composable_kernel = callPackage ../development/libraries/composable_kernel {
    inherit (llvmPackages_rocm) openmp clang-tools-extra;
    stdenv = rocmClangStdenv;
  };

  rocprofiler = callPackage ../development/libraries/rocprofiler {
    stdenv = rocmClangStdenv;
  };

  clang-ocl = callPackage ../development/libraries/clang-ocl {
    stdenv = rocmClangStdenv;
  };

  rocclr = callPackage ../development/libraries/rocclr {
    stdenv = rocmClangStdenv;
  };

  hip-common = callPackage ../development/compilers/hip-common {
    inherit (llvmPackages_rocm) llvm;
    stdenv = rocmClangStdenv;
  };

  hipcc = callPackage ../development/compilers/hipcc {
    inherit (llvmPackages_rocm) llvm;
    stdenv = rocmClangStdenv;
  };

  hip = callPackage ../development/compilers/hip {
    inherit (llvmPackages_rocm) llvm;
    inherit (cudaPackages) cudatoolkit;
    stdenv = rocmClangStdenv;
  };

  hip-amd = hip.override {
    useNVIDIA = false;
  };

  hip-nvidia = hip.override {
    useNVIDIA = true;
  };

  hipify = callPackage ../development/compilers/hipify {
    stdenv = rocmClangStdenv;
  };

  hipcub = callPackage ../development/libraries/hipcub {
    stdenv = rocmClangStdenv;
  };

  hipsparse = callPackage ../development/libraries/hipsparse {
    inherit (llvmPackages_rocm) openmp;
    stdenv = rocmClangStdenv;
  };

  hipfort = callPackage ../development/libraries/hipfort {
    stdenv = rocmClangStdenv;
  };

  hipfft = callPackage ../development/libraries/hipfft {
    inherit (llvmPackages_rocm) openmp;
    stdenv = rocmClangStdenv;
  };

  hipsolver = callPackage ../development/libraries/hipsolver {
    stdenv = rocmClangStdenv;
  };

  hipblas = callPackage ../development/libraries/hipblas {
    stdenv = rocmClangStdenv;
  };

  migraphx = callPackage ../development/libraries/migraphx {
    inherit (llvmPackages_rocm) clang-tools-extra openmp;
    stdenv = rocmClangStdenv;
    rocmlir = rocmlir-rock;
  };

  rccl = callPackage ../development/libraries/rccl {
    stdenv = rocmClangStdenv;
  };

  rocm-cmake = callPackage ../development/tools/build-managers/rocm-cmake {
    stdenv = rocmClangStdenv;
  };

  rocm-comgr = callPackage ../development/libraries/rocm-comgr {
    stdenv = rocmClangStdenv;
  };

  rocalution = callPackage ../development/libraries/rocalution {
    inherit (llvmPackages_rocm) openmp;
    stdenv = rocmClangStdenv;
  };

  rocm-device-libs = callPackage ../development/libraries/rocm-device-libs {
    stdenv = rocmClangStdenv;
  };

  rocm-opencl-icd = callPackage ../development/libraries/rocm-opencl-icd {
    stdenv = rocmClangStdenv;
  };

  rocsolver = callPackage ../development/libraries/rocsolver {
    stdenv = rocmClangStdenv;
  };

  rocm-opencl-runtime = callPackage ../development/libraries/rocm-opencl-runtime {
    stdenv = rocmClangStdenv;
  };

  rocm-runtime = callPackage ../development/libraries/rocm-runtime {
    stdenv = rocmClangStdenv;
  };

  rocm-smi = python3Packages.callPackage ../tools/system/rocm-smi {
    stdenv = rocmClangStdenv;
  };

  rocm-thunk = callPackage ../development/libraries/rocm-thunk {
    stdenv = rocmClangStdenv;
  };

  rocminfo = callPackage ../development/tools/rocminfo {
    stdenv = rocmClangStdenv;
  };

  rocmlir = callPackage ../development/libraries/rocmlir {
    stdenv = rocmClangStdenv;
  };

  # Best just use GCC here

  # Best just use GCC here
  rocgdb = callPackage ../development/tools/misc/rocgdb {
    elfutils = elfutils.override { enableDebuginfod = true; };
  };

  rocdbgapi = callPackage ../development/libraries/rocdbgapi {
    stdenv = rocmClangStdenv;
  };

  rocr-debug-agent = callPackage ../development/libraries/rocr-debug-agent {
    stdenv = rocmClangStdenv;
  };

  rocmlir-rock = rocmlir.override {
    buildRockCompiler = true;
  };

  rocm-core = callPackage ../development/libraries/rocm-core {
    stdenv = rocmClangStdenv;
  };

  rocprim = callPackage ../development/libraries/rocprim {
    stdenv = rocmClangStdenv;
  };

  rocsparse = callPackage ../development/libraries/rocsparse {
    stdenv = rocmClangStdenv;
  };

  rocfft = callPackage ../development/libraries/rocfft {
    inherit (llvmPackages_rocm) openmp;
    stdenv = rocmClangStdenv;
  };

  rocrand = callPackage ../development/libraries/rocrand {
    stdenv = rocmClangStdenv;
  };

  tensile = python3Packages.callPackage ../development/libraries/tensile {
    stdenv = rocmClangStdenv;
  };

  rocwmma = callPackage ../development/libraries/rocwmma {
    inherit (llvmPackages_rocm) openmp;
    stdenv = rocmClangStdenv;
  };

  rocblas = callPackage ../development/libraries/rocblas {
    inherit (llvmPackages_rocm) openmp;
    stdenv = rocmClangStdenv;
  };

  miopengemm = callPackage ../development/libraries/miopengemm {
    stdenv = rocmClangStdenv;
  };

  rocthrust = callPackage ../development/libraries/rocthrust {
    stdenv = rocmClangStdenv;
  };

  miopen = callPackage ../development/libraries/miopen {
    inherit (llvmPackages_rocm) llvm clang-tools-extra;
    stdenv = rocmClangStdenv;
    rocmlir = rocmlir-rock;
    boost = boost.override { enableStatic = true; };
  };

  miopen-hip = miopen.override {
    useOpenCL = false;
  };

  miopen-opencl = miopen.override {
    useOpenCL = true;
  };

  # Requires GCC
  roctracer = callPackage ../development/libraries/roctracer {
    inherit (llvmPackages_rocm) clang;
  };

  rtags = callPackage ../development/tools/rtags {
    inherit (darwin) apple_sdk;
  };

  rust_1_66 = callPackage ../development/compilers/rust/1_66.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security SystemConfiguration;
    llvm_14 = llvmPackages_14.libllvm;
    # https://github.com/NixOS/nixpkgs/issues/201254
    stdenv = if stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU then gcc11Stdenv else stdenv;
  };
  rust = rust_1_66;

  mrustc-bootstrap = callPackage ../development/compilers/mrustc/bootstrap.nix {
    stdenv = gcc10StdenvCompat;
    openssl = openssl_1_1;
  };

  rustPackages_1_66 = rust_1_66.packages.stable;
  rustPackages = rustPackages_1_66;

  inherit (rustPackages) cargo cargo-auditable cargo-auditable-cargo-wrapper clippy rustc rustPlatform;

  makeRustPlatform = callPackage ../development/compilers/rust/make-rust-platform.nix {};

  cargo-espflash = callPackage ../development/tools/rust/cargo-espflash {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  cargo-web = callPackage ../development/tools/rust/cargo-web {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  cargo-flamegraph = callPackage ../development/tools/rust/cargo-flamegraph {
    inherit (darwin.apple_sdk.frameworks) Security;
    inherit (linuxPackages) perf;
  };

  cargo-audit = callPackage ../development/tools/rust/cargo-audit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-bisect-rustc = callPackage ../development/tools/rust/cargo-bisect-rustc {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-c = callPackage ../development/tools/rust/cargo-c {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };
  cargo-clone = callPackage ../development/tools/rust/cargo-clone {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };
  cargo-cyclonedx = callPackage ../development/tools/rust/cargo-cyclonedx {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration CoreFoundation;
  };
  cargo-deadlinks = callPackage ../development/tools/rust/cargo-deadlinks {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-edit = callPackage ../development/tools/rust/cargo-edit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-outdated = callPackage ../development/tools/rust/cargo-outdated {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };
  cargo-pgx = callPackage ../development/tools/rust/cargo-pgx {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-tarpaulin = callPackage ../development/tools/analysis/cargo-tarpaulin {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-update = callPackage ../development/tools/rust/cargo-update {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  cargo-asm = callPackage ../development/tools/rust/cargo-asm {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-cache = callPackage ../development/tools/rust/cargo-cache {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-crev = callPackage ../development/tools/rust/cargo-crev {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration CoreFoundation;
  };
  cargo-deny = callPackage ../development/tools/rust/cargo-deny {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-dephell = callPackage ../development/tools/rust/cargo-dephell {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };
  cargo-embed = callPackage ../development/tools/rust/cargo-embed {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };
  cargo-flash = callPackage ../development/tools/rust/cargo-flash {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };
  cargo-fund = callPackage ../development/tools/rust/cargo-fund {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-geiger = callPackage ../development/tools/rust/cargo-geiger {
    inherit (darwin.apple_sdk.frameworks) Security CoreFoundation;
  };

  cargo-hf2 = callPackage ../development/tools/rust/cargo-hf2 {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };
  cargo-inspect = callPackage ../development/tools/rust/cargo-inspect {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-lambda = callPackage ../development/tools/rust/cargo-lambda {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-make = callPackage ../development/tools/rust/cargo-make {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };
  cargo-msrv = callPackage ../development/tools/rust/cargo-msrv {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-nextest = callPackage ../development/tools/rust/cargo-nextest {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-raze = callPackage ../development/tools/rust/cargo-raze {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  cargo-spellcheck = callPackage ../development/tools/rust/cargo-spellcheck {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-supply-chain = callPackage ../development/tools/rust/cargo-supply-chain {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-udeps = callPackage ../development/tools/rust/cargo-udeps {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security SystemConfiguration;
  };
  cargo-ui = darwin.apple_sdk_11_0.callPackage ../development/tools/rust/cargo-ui { };

  cargo-vet = callPackage ../development/tools/rust/cargo-vet {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-wasi = callPackage ../development/tools/rust/cargo-wasi {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-watch = callPackage ../development/tools/rust/cargo-watch {
    inherit (darwin.apple_sdk.frameworks) CoreServices Foundation;
  };
  cargo-workspaces = callPackage ../development/tools/rust/cargo-workspaces {
    inherit (darwin.apple_sdk.frameworks) IOKit Security CoreFoundation AppKit System;
  };

  cargo-whatfeatures = callPackage ../development/tools/rust/cargo-whatfeatures {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  convco = callPackage ../development/tools/convco {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  devserver = callPackage ../development/tools/rust/devserver {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    openssl = openssl_1_1;
  };

  maturin = callPackage ../development/tools/rust/maturin {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  panamax = callPackage ../development/tools/rust/panamax {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rustfmt = rustPackages.rustfmt;
  rust-analyzer-unwrapped = callPackage ../development/tools/rust/rust-analyzer {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };
  rust-cbindgen = callPackage ../development/tools/rust/cbindgen {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  rustup = callPackage ../development/tools/rust/rustup {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };
  rustup-toolchain-install-master = callPackage ../development/tools/rust/rustup-toolchain-install-master {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  sbcl_2_0_8 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.0.8"; };
  sbcl_2_0_9 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.0.9"; };
  sbcl_2_1_1 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.1.1"; };
  sbcl_2_1_2 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.1.2"; };
  sbcl_2_1_9 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.1.9"; };
  sbcl_2_1_10 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.1.10"; };
  sbcl_2_1_11 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.1.11"; };
  sbcl_2_2_4 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.2.4"; };
  sbcl_2_2_6 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.2.6"; };
  sbcl_2_2_9 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.2.9"; };
  sbcl_2_2_10 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.2.10"; };
  sbcl_2_2_11 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.2.11"; };
  sbcl_2_3_0 = callPackage ../development/compilers/sbcl/2.x.nix { version = "2.3.0"; };
  sbcl = sbcl_2_3_0;

  scala_2_10 = callPackage ../development/compilers/scala/2.x.nix { majorVersion = "2.10"; jre = jdk8; };
  scala_2_11 = callPackage ../development/compilers/scala/2.x.nix { majorVersion = "2.11"; jre = jdk8; };
  scala_2_12 = callPackage ../development/compilers/scala/2.x.nix { majorVersion = "2.12"; };
  scala_2_13 = callPackage ../development/compilers/scala/2.x.nix { majorVersion = "2.13"; };
  # deprecated
  dotty = scala_3;

  scala = scala_2_13;
  scala-runners = callPackage ../development/compilers/scala-runners {
    coursier = coursier.override { jre = jdk8; };
  };

  scalafix = callPackage ../development/tools/scalafix {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  sdcc = callPackage ../development/compilers/sdcc {
    gputils = null;
  };

  # smlnjBootstrap should be redundant, now that smlnj works on Darwin natively
  smlnj = callPackage ../development/compilers/smlnj {
    inherit (darwin) Libsystem;
  };

  solc = callPackage ../development/compilers/solc {
    boost = boost172;
  };

  spirv-llvm-translator = callPackage ../development/compilers/spirv-llvm-translator { };

  spirv-llvm-translator_14 = callPackage ../development/compilers/spirv-llvm-translator { llvm = llvm_14; };

  sqldeveloper = callPackage ../development/tools/database/sqldeveloper {
    jdk = oraclejdk;
  };

  sqlx-cli = callPackage ../development/tools/rust/sqlx-cli {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration CoreFoundation Security;
  };

  squirrel-sql = callPackage ../development/tools/database/squirrel-sql {
    drivers = [ jtds_jdbc mssql_jdbc mysql_jdbc postgresql_jdbc ];
  };

  swiProlog = callPackage ../development/compilers/swi-prolog {
    openssl = openssl_1_1;
    inherit (darwin.apple_sdk.frameworks) Security;
    jdk = openjdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  swiPrologWithGui = swiProlog.override { withGui = true; };

  terra = callPackage ../development/compilers/terra {
    llvmPackages = llvmPackages_11;
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
  };

  thrust = callPackage ../development/tools/thrust {
    gconf = gnome2.GConf;
  };

  tinycc = darwin.apple_sdk_11_0.callPackage ../development/compilers/tinycc { };

  tinygo = callPackage ../development/compilers/tinygo {
    llvmPackages = llvmPackages_14;
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    wasi-libc = pkgsCross.wasi32.wasilibc;
  };

  inherit (nodePackages) typescript;

  urweb = callPackage ../development/compilers/urweb {
    icu = icu67;
  };

  inherit (callPackage ../development/compilers/vala { })
    vala_0_48
    vala_0_54
    vala_0_56
    vala;

  vyper = with python3Packages; toPythonApplication vyper;

  wrapCCWith =
    { cc
    , # This should be the only bintools runtime dep with this sort of logic. The
      # Others should instead delegate to the next stage's choice with
      # `targetPackages.stdenv.cc.bintools`. This one is different just to
      # provide the default choice, avoiding infinite recursion.
      # See the bintools attribute for the logic and reasoning. We need to provide
      # a default here, since eval will hit this function when bootstrapping
      # stdenv where the bintools attribute doesn't exist, but will never actually
      # be evaluated -- callPackage ends up being too eager.
      bintools ? pkgs.bintools
    , libc ? bintools.libc
    , # libc++ from the default LLVM version is bound at the top level, but we
      # want the C++ library to be explicitly chosen by the caller, and null by
      # default.
      libcxx ? null
    , extraPackages ? lib.optional (cc.isGNU or false && stdenv.targetPlatform.isMinGW) threadsCross.package
    , nixSupport ? {}
    , ...
    } @ extraArgs:
      callPackage ../build-support/cc-wrapper (let self = {
    nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    noLibc = !self.nativeLibc && (self.libc == null);

    isGNU = cc.isGNU or false;
    isClang = cc.isClang or false;

    inherit cc bintools libc libcxx extraPackages nixSupport zlib;
  } // extraArgs; in self);

  wrapCC = cc: wrapCCWith {
    inherit cc;
  };

  wrapBintoolsWith =
    { bintools
    , libc ? if stdenv.targetPlatform != stdenv.hostPlatform then libcCross else stdenv.cc.libc
    , ...
    } @ extraArgs:
      callPackage ../build-support/bintools-wrapper (let self = {
    nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";

    noLibc = (self.libc == null);

    inherit bintools libc;
    inherit (darwin) postLinkSignHook signingUtils;
  } // extraArgs; in self);

  yaml-language-server = nodePackages.yaml-language-server;

  # prolog

  zulip = callPackage ../applications/networking/instant-messengers/zulip {
    # Bubblewrap breaks zulip, see https://github.com/NixOS/nixpkgs/pull/97264#issuecomment-704454645
    appimageTools = pkgs.appimageTools.override {
      buildFHSUserEnv = pkgs.buildFHSUserEnv;
    };
  };

  ### DEVELOPMENT / INTERPRETERS

  acl2 = callPackage ../development/interpreters/acl2 { };
  acl2-minimal = callPackage ../development/interpreters/acl2 { certifyBooks = false; };

  # BQN interpreters and compilers

  cbqn = cbqn-bootstrap.phase2;
  cbqn-replxx = cbqn-bootstrap.phase2-replxx;
  cbqn-standalone = cbqn-bootstrap.phase0;
  cbqn-standalone-replxx = cbqn-bootstrap.phase0-replxx;

  # Below, the classic self-bootstrapping process
  cbqn-bootstrap = lib.dontRecurseIntoAttrs {
    # Use clang to compile CBQN if we aren't already.
    # CBQN's upstream primarily targets and tests clang which means using gcc
    # will result in slower binaries and on some platforms failing/broken builds.
    # See https://github.com/dzaima/CBQN/issues/12.
    #
    # Known issues:
    #
    # * CBQN using gcc is broken at runtime on i686 due to
    #   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58416,
    # * CBQN uses some CPP macros gcc doesn't like for aarch64.
    stdenv = if !stdenv.cc.isClang then clangStdenv else stdenv;

    mbqn-source = buildPackages.mbqn.src;

    phase0 = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) stdenv;
      genBytecode = false;
      bqn-path = null;
      mbqn-source = null;
    };

    phase0-replxx = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) stdenv;
      genBytecode = false;
      bqn-path = null;
      mbqn-source = null;
      enableReplxx = true;
    };

    phase1 = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      genBytecode = true;
      bqn-path = "${buildPackages.cbqn-bootstrap.phase0}/bin/cbqn";
    };

    phase2 = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      genBytecode = true;
      bqn-path = "${buildPackages.cbqn-bootstrap.phase1}/bin/cbqn";
    };

    phase2-replxx = callPackage ../development/interpreters/bqn/cbqn {
      inherit (cbqn-bootstrap) mbqn-source stdenv;
      genBytecode = true;
      bqn-path = "${buildPackages.cbqn-bootstrap.phase1}/bin/cbqn";
      enableReplxx = true;
    };
  };

  dbqn = callPackage ../development/interpreters/bqn/dzaima-bqn {
    buildNativeImage = false;
    stdenv = stdenvNoCC;
    jdk = jre;
  };
  dbqn-native = callPackage ../development/interpreters/bqn/dzaima-bqn {
    buildNativeImage = true;
    jdk = graalvm11-ce;
  };

  cliscord = callPackage ../misc/cliscord {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  clisp = callPackage ../development/interpreters/clisp {
    # On newer readline8 fails as:
    #  #<FOREIGN-VARIABLE "rl_readline_state" #x...>
    #   does not have the required size or alignment
    readline = readline63;
  };

  clojupyter = callPackage ../applications/editors/jupyter-kernels/clojupyter {
    jre = jre8;
  };

  clojure = callPackage ../development/interpreters/clojure {
    # set this to an LTS version of java
    jdk = jdk17;
  };

  dhall = haskell.lib.compose.justStaticExecutables haskellPackages.dhall;

  dhall-bash = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-bash;

  dhall-docs = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-docs;

  dhall-lsp-server = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-lsp-server;

  dhall-json = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-json;

  dhall-nix = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-nix;

  dhall-nixpkgs = haskell.lib.compose.justStaticExecutables haskellPackages.dhall-nixpkgs;

  dhallPackages = recurseIntoAttrs (callPackage ./dhall-packages.nix { });

  duckscript = callPackage ../development/tools/rust/duckscript {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  evcxr = callPackage ../development/interpreters/evcxr {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  beam = callPackage ./beam-packages.nix { };
  beam_nox = callPackage ./beam-packages.nix { beam = beam_nox; wxSupport = false; };
  beam_minimal = callPackage ./beam-packages.nix {
    beam = beam_minimal;
    wxSupport = false;
    systemdSupport = false;
  };

  inherit (beam.interpreters)
    erlang erlangR25 erlangR24 erlangR23 erlangR22 erlangR21
    erlang_odbc erlang_javac erlang_odbc_javac
    elixir elixir_1_14 elixir_1_13 elixir_1_12 elixir_1_11 elixir_1_10
    elixir_ls;

  erlang_nox = beam_nox.interpreters.erlang;

  inherit (beam.packages.erlang)
    erlang-ls erlfmt elvis-erlang
    rebar rebar3 rebar3WithPlugins
    fetchHex beamPackages;

  inherit (beam.packages.erlangR21) lfe lfe_1_3;

  gnudatalanguage = callPackage ../development/interpreters/gnudatalanguage {
    inherit (llvmPackages) openmp;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    # MPICH currently build on Darwin
    mpi = mpich;
  };

  graphql-client = callPackage ../development/tools/graphql-client {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../applications/networking/cluster/hadoop {
    openssl = openssl_1_1;
  })
    hadoop_3_3
    hadoop_3_2
    hadoop2;
  hadoop3 = hadoop_3_3;
  hadoop = hadoop3;

  ivy = callPackage ../development/interpreters/ivy {
    buildGoModule = buildGo118Module; # tests fail with 1.19
  };

  j = callPackage ../development/interpreters/j {
    stdenv = clangStdenv;
  };

  jacinda = haskell.lib.compose.justStaticExecutables haskell.packages.ghc92.jacinda;

  love = love_0_10;

  ### LUA interpreters
  luaInterpreters = callPackage ./../development/interpreters/lua-5 {};
  inherit (luaInterpreters) lua5_1 lua5_2 lua5_2_compat lua5_3 lua5_3_compat lua5_4 lua5_4_compat luajit_2_1 luajit_2_0 luajit_openresty;

  lua5 = lua5_2_compat;
  lua = lua5;

  lua51Packages = recurseIntoAttrs lua5_1.pkgs;
  lua52Packages = recurseIntoAttrs lua5_2.pkgs;
  lua53Packages = recurseIntoAttrs lua5_3.pkgs;
  lua54Packages = recurseIntoAttrs lua5_4.pkgs;
  luajitPackages = recurseIntoAttrs luajit.pkgs;

  luaPackages = lua52Packages;

  luajit = luajit_2_1;

  luarocks = luaPackages.luarocks;
  luarocks-nix = luaPackages.luarocks-nix;

  toluapp = callPackage ../development/tools/toluapp {
    lua = lua5_1; # doesn't work with any other :(
  };

  ### END OF LUA

  ### CuboCore
  CuboCore = recurseIntoAttrs (import ./cubocore-packages.nix {
    inherit newScope lxqt lib libsForQt5;
  });

  ### End of CuboCore

  maude = callPackage ../development/interpreters/maude {
    stdenv = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;
  };

  octave = callPackage ../development/interpreters/octave {
    python = python3;
    mkDerivation = stdenv.mkDerivation;
  };
  octaveFull = libsForQt5.callPackage ../development/interpreters/octave {
    python = python3;
    enableQt = true;
    overridePlatforms = ["x86_64-linux" "x86_64-darwin"];
  };

  octavePackages = recurseIntoAttrs octave.pkgs;


  # PHP interpreters, packages and extensions.
  #
  # Set default PHP interpreter, extensions and packages
  php = php81;
  phpExtensions = php.extensions;
  phpPackages = php.packages;

  # Import PHP82 interpreter, extensions and packages
  php82 = callPackage ../development/interpreters/php/8.2.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php82Extensions = recurseIntoAttrs php82.extensions;
  php82Packages = recurseIntoAttrs php82.packages;

  # Import PHP81 interpreter, extensions and packages
  php81 = callPackage ../development/interpreters/php/8.1.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php81Extensions = recurseIntoAttrs php81.extensions;
  php81Packages = recurseIntoAttrs php81.packages;

  # Import PHP80 interpreter, extensions and packages
  php80 = callPackage ../development/interpreters/php/8.0.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    pcre2 = pcre2.override {
      withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
    };
  };
  php80Extensions = recurseIntoAttrs php80.extensions;
  php80Packages = recurseIntoAttrs php80.packages;


  # Python interpreters. All standard library modules are included except for tkinter, which is
  # available as `pythonPackages.tkinter` and can be used as any other Python package.
  # When switching these sets, please update docs at ../../doc/languages-frameworks/python.md
  python2 = python27;
  python3 = python310;

  # pythonPackages further below, but assigned here because they need to be in sync
  python2Packages = dontRecurseIntoAttrs python27Packages;
  python3Packages = dontRecurseIntoAttrs python310Packages;

  pypy = pypy2;
  pypy2 = pypy27;
  pypy3 = pypy39;

  # Python interpreter that is build with all modules, including tkinter.
  # These are for compatibility and should not be used inside Nixpkgs.
  python2Full = python2.override {
    self = python2Full;
    pythonAttr = "python2Full";
    x11Support = true;
  };
  python27Full = python27.override {
    self = python27Full;
    pythonAttr = "python27Full";
    x11Support = true;
  };
  python3Full = python3.override {
    self = python3Full;
    pythonAttr = "python3Full";
    bluezSupport = true;
    x11Support = true;
  };
  python38Full = python38.override {
    self = python38Full;
    pythonAttr = "python38Full";
    bluezSupport = true;
    x11Support = true;
  };
  python39Full = python39.override {
    self = python39Full;
    pythonAttr = "python39Full";
    bluezSupport = true;
    x11Support = true;
  };
  python310Full = python310.override {
    self = python310Full;
    pythonAttr = "python310Full";
    bluezSupport = true;
    x11Support = true;
  };
  python311Full = python310.override {
    self = python311Full;
    pythonAttr = "python311Full";
    bluezSupport = true;
    x11Support = true;
  };

  pythonInterpreters = callPackage ./../development/interpreters/python { };
  inherit (pythonInterpreters) python27 python38 python39 python310 python311 python312 python3Minimal pypy27 pypy39 pypy38 pypy37 rustpython;

  # List of extensions with overrides to apply to all Python package sets.
  pythonPackagesExtensions = [ ];
  # Python package sets.
  python27Packages = python27.pkgs;
  python38Packages = python38.pkgs;
  python39Packages = python39.pkgs;
  python310Packages = recurseIntoAttrs python310.pkgs;
  python311Packages = recurseIntoAttrs python311.pkgs;
  python312Packages = python312.pkgs;
  pypyPackages = pypy.pkgs;
  pypy2Packages = pypy2.pkgs;
  pypy27Packages = pypy27.pkgs;
  pypy3Packages = pypy3.pkgs;
  pypy37Packages = pypy37.pkgs;
  pypy38Packages = pypy38.pkgs;
  pypy39Packages = pypy39.pkgs;

  # Should eventually be moved inside Python interpreters.
  python-setup-hook = buildPackages.callPackage ../development/interpreters/python/setup-hook.nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/cpython/docs {});

  setupcfg2nix = python3Packages.callPackage ../development/tools/setupcfg2nix {};

  # These pyside tools do not provide any Python modules and are meant to be here.
  # See ../development/python-modules/pyside for details.

  svg2tikz = with python3.pkgs; toPythonApplication svg2tikz;

  poetry2nix = callPackage ../development/tools/poetry2nix/poetry2nix {
    inherit pkgs lib;
  };

  pipx = with python3.pkgs; toPythonApplication pipx;

  pipewire = callPackage ../development/libraries/pipewire {
    # ffmpeg depends on SDL2 which depends on pipewire by default.
    # Break the cycle by depending on ffmpeg-headless.
    # Pipewire only uses libavcodec (via an SPA plugin), which isn't
    # affected by the *-headless changes.
    ffmpeg = ffmpeg-headless;
  };

  pipewire-media-session = callPackage ../development/libraries/pipewire/media-session.nix {};

  racket = callPackage ../development/interpreters/racket {
    # racket 6.11 doesn't build with gcc6 + recent glibc:
    # https://github.com/racket/racket/pull/1886
    # https://github.com/NixOS/nixpkgs/pull/31017#issuecomment-343574769
    stdenv = if stdenv.isDarwin then stdenv else gcc7Stdenv;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };
  racket_7_9 = callPackage ../development/interpreters/racket/racket_7_9.nix {
    stdenv = if stdenv.isDarwin then stdenv else gcc7Stdenv;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  moarvm = callPackage ../development/interpreters/rakudo/moarvm.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  inherit (ocamlPackages) reason;

  buildRubyGem = callPackage ../development/ruby-modules/gem {
    inherit (darwin) libobjc;
  };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config {
    inherit (darwin) DarwinTools cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };
  bundlerApp = callPackage ../development/ruby-modules/bundler-app { };

  solargraph = rubyPackages.solargraph;

  inherit (callPackage ../development/interpreters/ruby {
    inherit (darwin) libobjc libunwind;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  })
    mkRubyVersion
    mkRuby
    ruby_2_7
    ruby_3_0
    ruby_3_1;

  ruby = ruby_2_7;
  rubyPackages = rubyPackages_2_7;

  rubyPackages_2_7 = recurseIntoAttrs ruby_2_7.gems;
  rubyPackages_3_0 = recurseIntoAttrs ruby_3_0.gems;
  rubyPackages_3_1 = recurseIntoAttrs ruby_3_1.gems;

  self = pkgsi686Linux.callPackage ../development/interpreters/self { };

  inherit (callPackages ../applications/networking/cluster/spark { })
    spark_3_2
    spark_3_1
    spark_2_4;
  spark3 = spark_3_2;
  spark2 = spark_2_4;
  spark = spark3;

  spidermonkey_78 = callPackage ../development/interpreters/spidermonkey/78.nix {
    inherit (darwin) libobjc;
  };
  spidermonkey_91 = callPackage ../development/interpreters/spidermonkey/91.nix {
    inherit (darwin) libobjc;
  };
  spidermonkey_102 = callPackage ../development/interpreters/spidermonkey/102.nix {
    inherit (darwin) libobjc;
  };

  supercollider = libsForQt5.callPackage ../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  supercolliderPlugins = recurseIntoAttrs {
    sc3-plugins = callPackage ../development/interpreters/supercollider/plugins/sc3-plugins.nix {
      fftw = fftwSinglePrec;
    };
  };

  supercollider-with-plugins = callPackage ../development/interpreters/supercollider/wrapper.nix {
    plugins = [];
  };

  supercollider-with-sc3-plugins = supercollider-with-plugins.override {
    plugins = with supercolliderPlugins; [ sc3-plugins ];
  };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };

  wapm-cli = callPackage ../tools/package-management/wapm/cli {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  wasm = ocamlPackages.wasm;

  ### DEVELOPMENT / MISC

  avrlibc      = callPackage ../development/misc/avr/libc {};
  avrlibcCross = callPackage ../development/misc/avr/libc {
    stdenv = crossLibcStdenv;
  };

  jruby = callPackage ../development/interpreters/jruby { };

  # Needed for autogen
  guile_2_0 = callPackage ../development/interpreters/guile/2.0.nix { };

  guile_2_2 = callPackage ../development/interpreters/guile/2.2.nix { };

  guile_3_0 = callPackage ../development/interpreters/guile/3.0.nix { };

  guile = guile_2_2;

  guile-xcb = callPackage ../development/guile-modules/guile-xcb {
    guile = guile_2_0;
  };

  msp430Newlib      = callPackage ../development/misc/msp430/newlib.nix { };
  msp430NewlibCross = callPackage ../development/misc/msp430/newlib.nix {
    newlib = newlibCross;
  };

  pharo-vms = callPackage ../development/pharo/vm { };
  pharo = pharo-vms.multi-vm-wrapper;
  pharo-cog32 = pharo-vms.cog32;
  pharo-spur32 = pharo-vms.spur32;
  pharo-spur64 = assert stdenv.is64bit; pharo-vms.spur64;

  umr = callPackage ../development/misc/umr {
    llvmPackages = llvmPackages_latest;
  };

  xidel = callPackage ../tools/text/xidel {
    openssl = openssl_1_1;
  };

  ### DEVELOPMENT / TOOLS

  inherit (callPackage ../development/tools/alloy {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  })
    alloy5
    alloy6
    alloy;

  anybadge = with python3Packages; toPythonApplication anybadge;

  ansible = ansible_2_14;
  ansible_2_14 = python3Packages.toPythonApplication python3Packages.ansible-core;
  ansible_2_13 = python3Packages.toPythonApplication (python3Packages.ansible-core.overridePythonAttrs (oldAttrs: rec {
    version = "2.13.6";
    src = oldAttrs.src.override {
      inherit version;
      hash = "sha256-Mf4yK2MpBnSo9zhhEN9QHwBEqkSJC+OrMTpuIluaKc8=";
    };
  }));
  ansible_2_12 = python3Packages.toPythonApplication (python3Packages.ansible-core.overridePythonAttrs (oldAttrs: rec {
    version = "2.12.10";
    src = oldAttrs.src.override {
      inherit version;
      hash = "sha256-/rHfYXOM/B9eiTtCouwafeMpd9Z+hnB7Retj0MXDwjY=";
    };
    meta.changelog = "https://github.com/ansible/ansible/blob/v${version}/changelogs/CHANGELOG-v${lib.versions.majorMinor version}.rst";
  }));

  ansible-doctor = with python3.pkgs; toPythonApplication ansible-doctor;

  ### DEVELOPMENT / TOOLS / LANGUAGE-SERVERS

  ccls = callPackage ../development/tools/language-servers/ccls {
    llvmPackages = llvmPackages_latest;
  };

  fortls = python3.pkgs.callPackage ../development/tools/language-servers/fortls { };

  fortran-language-server = python3.pkgs.callPackage ../development/tools/language-servers/fortran-language-server { };

  sumneko-lua-language-server = darwin.apple_sdk_11_0.callPackage ../development/tools/language-servers/sumneko-lua-language-server {
    inherit (darwin.apple_sdk_11_0.frameworks) CoreFoundation Foundation;
  };

  ansible-later = with python3.pkgs; toPythonApplication ansible-later;

  ansible-lint = with python3.pkgs; toPythonApplication ansible-lint;

  antlr3 = antlr3_5;

  inherit (callPackages ../development/tools/parsing/antlr/4.nix { })
    antlr4_8
    antlr4_9
    antlr4_10
    antlr4_11;

  antlr4 = antlr4_11;

  antlr = antlr4;

  ant = apacheAnt;

  apacheKafka = apacheKafka_3_3;
  apacheKafka_2_8 = callPackage ../servers/apache-kafka { majorVersion = "2.8"; };
  apacheKafka_3_0 = callPackage ../servers/apache-kafka { majorVersion = "3.0"; };
  apacheKafka_3_1 = callPackage ../servers/apache-kafka { majorVersion = "3.1"; };
  apacheKafka_3_2 = callPackage ../servers/apache-kafka { majorVersion = "3.2"; };
  apacheKafka_3_3 = callPackage ../servers/apache-kafka { majorVersion = "3.3"; };

  asn2quickder = python3Packages.callPackage ../development/tools/asn2quickder {};

  aws-adfs = with python3Packages; toPythonApplication aws-adfs;

  inherit (callPackages ../development/tools/electron { })
    electron
    electron_9
    electron_10
    electron_11
    electron_12
    electron_13
    electron_14
    electron_15
    electron_16
    electron_17
    electron_18
    electron_19
    electron_20
    electron_21
    electron_22;

  autoconf = autoconf271;

  automake = automake116x;

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake115x = callPackage ../development/tools/misc/automake/automake-1.15.x.nix { };

  automake116x = callPackage ../development/tools/misc/automake/automake-1.16.x.nix { };

  bazel = bazel_3;

  bazel_3 = callPackage ../development/tools/build-managers/bazel/bazel_3 {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk11_headless;
    buildJdkName = "java11";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    bazel_self = bazel_3;
  };

  bazel_4 = callPackage ../development/tools/build-managers/bazel/bazel_4 {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk11_headless;
    buildJdkName = "java11";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else gcc10StdenvCompat;
    bazel_self = bazel_4;
  };

  bazel_5 = callPackage ../development/tools/build-managers/bazel/bazel_5 {
    inherit (darwin) cctools sigtool;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk11_headless;
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    bazel_self = bazel_5;
  };

  bazel_6 = darwin.apple_sdk_11_0.callPackage ../development/tools/build-managers/bazel/bazel_6 {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk_11_0.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk11_headless;
    runJdk = jdk11_headless;
    stdenv = if stdenv.isDarwin then
      darwin.apple_sdk_11_0.stdenv else
      if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    bazel_self = bazel_6;
  };

  buildifier = bazel-buildtools;
  buildozer = bazel-buildtools;
  unused_deps = bazel-buildtools;

  bazel-watcher = callPackage ../development/tools/bazel-watcher {
    go = go_1_18;
  };

  rebazel = callPackage ../development/tools/rebazel {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  buildBazelPackage = darwin.apple_sdk_11_0.callPackage ../build-support/build-bazel-package { };

  binutils-unwrapped = callPackage ../development/tools/misc/binutils {
    autoreconfHook = autoreconfHook269;
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
  };
  binutils-unwrapped-all-targets = callPackage ../development/tools/misc/binutils {
    autoreconfHook = if targetPlatform.isiOS then autoreconfHook269 else autoreconfHook;
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
    withAllTargets = true;
  };
  binutils = wrapBintoolsWith {
    bintools = binutils-unwrapped;
  };
  binutils_nogold = lowPrio (wrapBintoolsWith {
    bintools = binutils-unwrapped.override {
      enableGold = false;
    };
  });
  binutilsNoLibc = wrapBintoolsWith {
    bintools = binutils-unwrapped;
    libc = preLibcCrossHeaders;
  };

  libbfd = callPackage ../development/tools/misc/binutils/libbfd.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  libopcodes = callPackage ../development/tools/misc/binutils/libopcodes.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  # Held back 2.38 release. Remove once all dependencies are ported to 2.39.
  binutils-unwrapped_2_38 = callPackage ../development/tools/misc/binutils/2.38 {
    autoreconfHook = autoreconfHook269;
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
  };

  libbfd_2_38 = callPackage ../development/tools/misc/binutils/2.38/libbfd.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  libopcodes_2_38 = callPackage ../development/tools/misc/binutils/2.38/libopcodes.nix {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  # Here we select the default bintools implementations to be used.  Note when
  # cross compiling these are used not for this stage but the *next* stage.
  # That is why we choose using this stage's target platform / next stage's
  # host platform.
  #
  # Because this is the *next* stages choice, it's a bit non-modular to put
  # here. In theory, bootstraping is supposed to not be a chain but at tree,
  # where each stage supports many "successor" stages, like multiple possible
  # futures. We don't have a better alternative, but with this downside in
  # mind, please be judicious when using this attribute. E.g. for building
  # things in *this* stage you should use probably `stdenv.cc.bintools` (from a
  # default or alternate `stdenv`), at build time, and try not to "force" a
  # specific bintools at runtime at all.
  #
  # In other words, try to only use this in wrappers, and only use those
  # wrappers from the next stage.
  bintools-unwrapped = let
    inherit (stdenv.targetPlatform) linker;
  in     if linker == "lld"     then llvmPackages.bintools-unwrapped
    else if linker == "cctools" then darwin.binutils-unwrapped
    else if linker == "bfd"     then binutils-unwrapped
    else if linker == "gold"    then binutils-unwrapped
    else null;
  bintoolsNoLibc = wrapBintoolsWith {
    bintools = bintools-unwrapped;
    libc = preLibcCrossHeaders;
  };
  bintools = wrapBintoolsWith {
    bintools = bintools-unwrapped;
  };

  bintoolsDualAs = wrapBintoolsWith {
    bintools = darwin.binutilsDualAs-unwrapped;
    wrapGas = true;
  };

  black = with python3Packages; toPythonApplication black;

  black-macchiato = with python3Packages; toPythonApplication black-macchiato;

  bossa = callPackage ../development/embedded/bossa {
    wxGTK = wxGTK30;
  };

  build2 = callPackage ../development/tools/build-managers/build2 {
    # Break cycle by using self-contained toolchain for bootstrapping
    build2 = buildPackages.callPackage ../development/tools/build-managers/build2/bootstrap.nix { };
  };

  # Dependency of build2, must also break cycle for this
  libbutl = callPackage ../development/libraries/libbutl {
    build2 = build2.bootstrap;
  };

  bore-cli = callPackage ../tools/networking/bore-cli/default.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  buildkite-test-collector-rust  = callPackage ../development/tools/continuous-integration/buildkite-test-collector-rust {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bundlewrap = with python3.pkgs; toPythonApplication bundlewrap;

  bcc = callPackage ../os-specific/linux/bcc {
    python = python3;
    llvmPackages = llvmPackages_14;
  };

  bpftrace = callPackage ../os-specific/linux/bpftrace {
    llvmPackages = llvmPackages_14;
  };

  # Wrapper that works as gcc or g++
  # It can be used by setting in nixpkgs config like this, for example:
  #    replaceStdenv = { pkgs }: pkgs.ccacheStdenv;
  # But if you build in chroot, you should have that path in chroot
  # If instantiated directly, it will use $HOME/.ccache as the cache directory,
  # i.e. /homeless-shelter/.ccache using the Nix daemon.
  # You should specify a different directory using an override in
  # packageOverrides to set extraConfig.
  #
  # Example using Nix daemon (i.e. multiuser Nix install or on NixOS):
  #    packageOverrides = pkgs: {
  #     ccacheWrapper = pkgs.ccacheWrapper.override {
  #       extraConfig = ''
  #         export CCACHE_COMPRESS=1
  #         export CCACHE_DIR=/var/cache/ccache
  #         export CCACHE_UMASK=007
  #       '';
  #     };
  # You can use a different directory, but whichever directory you choose
  # should be owned by user root, group nixbld with permissions 0770.
  ccacheWrapper = makeOverridable ({ extraConfig, cc }:
    cc.override {
      cc = ccache.links {
        inherit extraConfig;
        unwrappedCC = cc.cc;
      };
    }) {
      extraConfig = "";
      inherit (stdenv) cc;
    };

  ccacheStdenv = lowPrio (makeOverridable ({ stdenv, ... } @ extraArgs:
    overrideCC stdenv (buildPackages.ccacheWrapper.override ({
      inherit (stdenv) cc;
    } // lib.optionalAttrs (builtins.hasAttr "extraConfig" extraArgs) {
      extraConfig = extraArgs.extraConfig;
    }))) {
      inherit stdenv;
    });

  chromedriver = callPackage ../development/tools/selenium/chromedriver { };

  chruby = callPackage ../development/tools/misc/chruby { rubies = null; };

  cloudcompare = libsForQt5.callPackage ../applications/graphics/cloudcompare { };

  cookiecutter = with python3Packages; toPythonApplication cookiecutter;

  cubiomes-viewer = libsForQt5.callPackage ../applications/misc/cubiomes-viewer { };

  cmake = callPackage ../development/tools/build-managers/cmake { };

  # can't use override - it triggers infinite recursion
  cmakeMinimal = callPackage ../development/tools/build-managers/cmake {
    isBootstrap = true;
  };

  cmakeCurses = cmake.override {
    uiToolkits = [ "ncurses" ];
  };

  cmakeWithGui = cmake.override {
    uiToolkits = [ "ncurses" "qt5" ];
  };

  cmake-format = python3Packages.callPackage ../development/tools/cmake-format { };

  cmake-language-server = python3Packages.callPackage ../development/tools/misc/cmake-language-server {
    inherit cmake cmake-format;
  };

  # Does not actually depend on Qt 5
  inherit (plasma5Packages) extra-cmake-modules;

  credstash = with python3Packages; toPythonApplication credstash;

  creduce = callPackage ../development/tools/misc/creduce {
    inherit (llvmPackages_8) llvm libclang;
  };

  css-html-js-minify = with python3Packages; toPythonApplication css-html-js-minify;

  cvise = python3Packages.callPackage ../development/tools/misc/cvise {
    # cvise keeps up with fresh llvm releases and supports wide version range
    inherit (llvmPackages_latest) llvm libclang;
  };

  dprint = callPackage ../development/tools/dprint {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libcxx = llvmPackages.libcxx;
  libcxxabi = llvmPackages.libcxxabi;

  libgcc = callPackage ../development/libraries/gcc/libgcc {
    stdenvNoLibs = gccStdenvNoLibs; # cannot be built with clang it seems
  };

  # This is for e.g. LLVM libraries on linux.
  gccForLibs =
    if stdenv.targetPlatform == stdenv.hostPlatform && targetPackages.stdenv.cc.isGNU
    # Can only do this is in the native case, otherwise we might get infinite
    # recursion if `targetPackages.stdenv.cc.cc` itself uses `gccForLibs`.
      then targetPackages.stdenv.cc.cc
    else gcc.cc;

  libsigrok = callPackage ../development/tools/libsigrok {
    python = python3;
  };

  distcc = callPackage ../development/tools/misc/distcc {
    libiberty_static = libiberty.override { staticBuild = true; };
  };

  # distccWrapper: wrapper that works as gcc or g++
  # It can be used by setting in nixpkgs config like this, for example:
  #    replaceStdenv = { pkgs }: pkgs.distccStdenv;
  # But if you build in chroot, a default 'nix' will create
  # a new net namespace, and won't have network access.
  # You can use an override in packageOverrides to set extraConfig:
  #    packageOverrides = pkgs: {
  #     distccWrapper = pkgs.distccWrapper.override {
  #       extraConfig = ''
  #         DISTCC_HOSTS="myhost1 myhost2"
  #       '';
  #     };
  #
  distccWrapper = makeOverridable ({ extraConfig ? "" }:
    wrapCC (distcc.links extraConfig)) {};
  distccStdenv = lowPrio (overrideCC stdenv buildPackages.distccWrapper);

  distccMasquerade = if stdenv.isDarwin
    then null
    else callPackage ../development/tools/misc/distcc/masq.nix {
      gccRaw = gcc.cc;
      binutils = binutils;
    };

  dioxus-cli = callPackage ../development/tools/rust/dioxus-cli {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  docutils = with python3Packages; toPythonApplication docutils;

  doit = with python3Packages; toPythonApplication doit;

  dot2tex = with python3.pkgs; toPythonApplication dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt5 = null;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  doxygen_gui = lowPrio (doxygen.override { inherit qt5; });

  dura = callPackage ../development/tools/misc/dura {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  edb = libsForQt5.callPackage ../development/tools/misc/edb { };

  # NOTE: Override and set useIcon = false to use Awk instead of Icon.

  nuweb = callPackage ../development/tools/literate-programming/nuweb {
    tex = texlive.combined.scheme-medium;
  };

  fffuu = haskell.lib.compose.justStaticExecutables (haskellPackages.callPackage ../tools/misc/fffuu { });

  flow = callPackage ../development/tools/analysis/flow {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fswatch = callPackage ../development/tools/misc/fswatch {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  fujprog = callPackage ../development/embedded/fpga/fujprog {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  gede = libsForQt5.callPackage ../development/tools/misc/gede { };

  gdbgui = python3Packages.callPackage ../development/tools/misc/gdbgui { };

  pmd = callPackage ../development/tools/analysis/pmd {
    openjdk = openjdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  jdepend = callPackage ../development/tools/analysis/jdepend {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  gnatcoll-db2ada = callPackage ../development/libraries/ada/gnatcoll/db.nix {
    component = "gnatcoll_db2ada";
  };

  gnatinspect = callPackage ../development/libraries/ada/gnatcoll/db.nix {
    component = "gnatinspect";
  };

  m4 = gnum4;

  gradle-packages = import ../development/tools/build-managers/gradle {
    inherit jdk8 jdk11 jdk17;
  };
  gradleGen = gradle-packages.gen;
  gradle_6 = callPackage gradle-packages.gradle_6 { };
  gradle_7 = callPackage gradle-packages.gradle_7 { };
  gradle = gradle_7;

  # 3.1 changed some parameters from int to size_t, leading to mismatches.

  griffe = with python3Packages; toPythonApplication griffe;

  guile-lint = callPackage ../development/tools/guile/guile-lint {
    guile = guile_1_8;
  };

  gwrap = callPackage ../development/tools/guile/g-wrap {
    guile = guile_2_0;
  };

  hadolint = haskell.lib.compose.justStaticExecutables haskellPackages.hadolint;

  iaca = iaca_3_0;

  ikos = callPackage ../development/tools/analysis/ikos {
    inherit (llvmPackages_9) stdenv clang llvm;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_14;
  };

  inherit (callPackage ../development/tools/build-managers/jam { })
    jam
    ftjam;

  javacc = callPackage ../development/tools/parsing/javacc {
    # Upstream doesn't support anything newer than Java 8.
    # https://github.com/javacc/javacc/blob/c708628423b71ce8bc3b70143fa5b6a2b7362b3a/README.md#building-javacc-from-source
    jdk = jdk8;
    jre = jre8;
  };

  jenkins-job-builder = with python3Packages; toPythonApplication jenkins-job-builder;

  kcc = libsForQt5.callPackage ../applications/graphics/kcc { };

  kconfig-frontends = callPackage ../development/tools/misc/kconfig-frontends {
    gperf = gperf_3_0;
  };

  kubie = callPackage ../development/tools/kubie {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libtool = libtool_2;

  linuxkit = callPackage ../development/tools/misc/linuxkit {
    inherit (darwin.apple_sdk_11_0.frameworks) Virtualization;
  };

  lttng-ust = callPackage ../development/tools/misc/lttng-ust { };

  lttng-ust_2_12 = callPackage ../development/tools/misc/lttng-ust/2.12.nix { };

  luaformatter = callPackage ../development/tools/luaformatter
    (lib.optionalAttrs (stdenv.cc.isClang && lib.versionOlder stdenv.cc.version "9") {
      stdenv = overrideCC stdenv llvmPackages_9.clang;
    });

  massif-visualizer = libsForQt5.callPackage ../development/tools/analysis/massif-visualizer { };

  maven = maven3;

  mavproxy = python3Packages.callPackage ../applications/science/robotics/mavproxy { };

  python-matter-server = with python3Packages; toPythonApplication python-matter-server;

  minizincide = libsForQt5.callPackage ../development/tools/minizinc/ide.nix { };

  mkdocs = with python3Packages; toPythonApplication mkdocs;

  mold = callPackage ../development/tools/mold {
    # C++20 is required, aarch64-linux has gcc 9 by default
    stdenv = if stdenv.isLinux && stdenv.isAarch64
      then llvmPackages_12.libcxxStdenv
      else llvmPackages.stdenv;
  };

  haskell-ci = haskell.lib.compose.justStaticExecutables haskellPackages.haskell-ci;

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
    fontsConf = makeFontsConf {
      fontDirectories = [
        dejavu_fonts.minimal
      ];
    };
  };

  nimbo = with python3Packages; callPackage ../applications/misc/nimbo { };

  gn = callPackage ../development/tools/build-managers/gn { };
  gn1924 = callPackage ../development/tools/build-managers/gn/rev1924.nix { };

  nixbang = callPackage ../development/tools/misc/nixbang {
    pythonPackages = python3Packages;
  };

  nexus = callPackage ../development/tools/repository-managers/nexus {
    jre_headless = jre8_headless;
  };

  nwjs = callPackage ../development/tools/nwjs { };

  nwjs-sdk = callPackage ../development/tools/nwjs {
    sdk = true;
  };

  obelisk = callPackage ../development/tools/ocaml/obelisk { menhir = ocamlPackages.menhir; };

  openai = with python3Packages; toPythonApplication openai;

  openai-whisper = with python3.pkgs; toPythonApplication openai-whisper;

  openai-whisper-cpp = callPackage ../tools/audio/openai-whisper-cpp {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  oprofile = callPackage ../development/tools/profiling/oprofile {
    libiberty_static = libiberty.override { staticBuild = true; };
  };

  pactorio = callPackage ../development/tools/pactorio {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  patchelf = if with stdenv.buildPlatform; isAarch64 && isMusl then
    patchelf_0_13
  else
    patchelfStable;
  patchelf_0_13 = callPackage ../development/tools/misc/patchelf/0.13.nix {
    patchelf = patchelfStable;
  };
  patchelfStable = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = lowPrio (callPackage ../development/tools/misc/patchelf/unstable.nix { });

  pgcli = with pkgs.python3Packages; toPythonApplication pgcli;

  pkgconf = callPackage ../build-support/pkg-config-wrapper {
    pkg-config = pkgconf-unwrapped;
    baseBinName = "pkgconf";
  };
  libpkgconf = pkgconf-unwrapped;

  pkg-config = callPackage ../build-support/pkg-config-wrapper {
    pkg-config = pkg-config-unwrapped;
  };

  pkg-configUpstream = lowPrio (pkg-config.override (old: {
    pkg-config = old.pkg-config.override {
      vanilla = true;
    };
  }));

  inherit (nodePackages) postcss-cli;

  pyprof2calltree = with python3Packages; toPythonApplication pyprof2calltree;

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake5 = callPackage ../development/tools/misc/premake/5.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  premake = premake4;

  pycritty = with python3Packages; toPythonApplication pycritty;

  qtcreator = libsForQt5.callPackage ../development/tools/qtcreator {
    inherit (linuxPackages) perf;
  };

  qxmledit = libsForQt5.callPackage ../applications/editors/qxmledit {} ;

  radare2 = callPackage ../development/tools/analysis/radare2 ({
    lua = lua5;
  } // (config.radare or {}));

  rathole = callPackage ../tools/networking/rathole {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  rizin = pkgs.callPackage ../development/tools/analysis/rizin { };

  cutter = libsForQt5.callPackage ../development/tools/analysis/rizin/cutter.nix { };

  ragel = ragelStable;

  inherit (callPackages ../development/tools/parsing/ragel {
      tex = texlive.combined.scheme-small;
    }) ragelStable ragelDev;

  inherit (regclient) regbot regctl regsync;

  inherit (callPackage ../development/tools/replay-io { })
    replay-io replay-node-cli;

  retdec = callPackage ../development/tools/analysis/retdec {
    stdenv = gcc8Stdenv;
  };
  retdec-full = retdec.override {
    withPEPatterns = true;
  };

  rnginline = with python3Packages; toPythonApplication rnginline;

  muonStandalone = muon.override {
    embedSamurai = true;
    buildDocs = false;
  };

  seer = libsForQt5.callPackage ../development/tools/misc/seer { };

  semantik = libsForQt5.callPackage ../applications/office/semantik { };

  sconsPackages = dontRecurseIntoAttrs (callPackage ../development/tools/build-managers/scons { });
  scons = sconsPackages.scons_latest;

  simpleBuildTool = sbt;

  shadowenv = callPackage ../tools/misc/shadowenv {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  shake = haskell.lib.compose.justStaticExecutables haskellPackages.shake;

  inherit (callPackage ../development/tools/build-managers/shards { })
    shards_0_17
    shards;

  shellcheck = callPackage ../development/tools/shellcheck {
    inherit (__splicedPackages.haskellPackages) ShellCheck;
  };

  scenic-view = callPackage ../development/tools/scenic-view { jdk = jdk11; };

  silicon = callPackage ../tools/misc/silicon {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreText Security;
  };

  slint-lsp = callPackage ../development/tools/misc/slint-lsp {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  sloc = nodePackages.sloc;

  snowman = qt5.callPackage ../development/tools/analysis/snowman { };

  speedtest-cli = with python3Packages; toPythonApplication speedtest-cli;

  splint = callPackage ../development/tools/analysis/splint {
    flex = flex_2_5_35;
  };

  spoofer = callPackage ../tools/networking/spoofer { };

  spoofer-gui = callPackage ../tools/networking/spoofer { withGUI = true; };

  spr = callPackage ../development/tools/spr {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  sqlitebrowser = libsForQt5.callPackage ../development/tools/database/sqlitebrowser { };

  sqlite-utils = with python3Packages; toPythonApplication sqlite-utils;

  sqlmap = with python3Packages; toPythonApplication sqlmap;

  swiftshader = callPackage ../development/libraries/swiftshader { stdenv = gcc10StdenvCompat; };

  swig = swig3;
  swigWithJava = swig;

  swfmill = callPackage ../tools/video/swfmill { stdenv = gcc10StdenvCompat; };

  swftools = callPackage ../tools/video/swftools {
    stdenv = gccStdenv;
  };

  taplo = callPackage ../development/tools/taplo {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tarmac = callPackage ../development/tools/tarmac {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  teensyduino = arduino-core.override { withGui = true; withTeensyduino = true; };

  tytools = libsForQt5.callPackage ../development/embedded/tytools { };

  texinfo4 = texinfo413;
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.2.nix { };
  texinfo6_5 = callPackage ../development/tools/misc/texinfo/6.5.nix { }; # needed for allegro
  texinfo6_7 = callPackage ../development/tools/misc/texinfo/6.7.nix { }; # needed for gpm, iksemel and fwknop
  texinfo6 = callPackage ../development/tools/misc/texinfo/6.8.nix { };
  texinfo = texinfo6;
  texinfoInteractive = texinfo.override { interactive = true; };

  texlab = callPackage ../development/tools/misc/texlab {
    inherit (darwin.apple_sdk.frameworks) Security CoreServices;
  };

  tflint-plugins = recurseIntoAttrs (
    callPackage ../development/tools/analysis/tflint-plugins { }
  );

  tree-sitter = makeOverridable (callPackage ../development/tools/parsing/tree-sitter) {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tree-sitter-grammars = recurseIntoAttrs tree-sitter.builtGrammars;

  turbogit = callPackage ../development/tools/turbogit {
    libgit2 = libgit2_1_3_0;
  };

  uhd3_5 = callPackage ../applications/radio/uhd/3.5.nix { };
  uhd = callPackage ../applications/radio/uhd { };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
  };

  jprofiler = callPackage ../development/tools/java/jprofiler {
    jdk = jdk11;
  };

  valgrind = callPackage ../development/tools/analysis/valgrind {
    inherit (buildPackages.darwin) xnu bootstrap_cmds cctools;
  };
  valgrind-light = res.valgrind.override { gdb = null; };

  qcachegrind = libsForQt5.callPackage ../development/tools/analysis/qcachegrind {};

  whatstyle = callPackage ../development/tools/misc/whatstyle {
    inherit (llvmPackages) clang-unwrapped;
  };

  xc3sprog = callPackage ../development/embedded/xc3sprog { stdenv = gcc10StdenvCompat; };

  xcodebuild = callPackage ../development/tools/xcbuild/wrapper.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreGraphics ImageIO;
  };
  xcodebuild6 = xcodebuild.override { stdenv = llvmPackages_6.stdenv; };
  xcbuild = xcodebuild;
  xcbuildHook = makeSetupHook {
    deps = [ xcbuild ];
  } ../development/tools/xcbuild/setup-hook.sh  ;

  # xcbuild with llvm 6
  xcbuild6Hook = makeSetupHook {
    deps = [ xcodebuild6 ];
  } ../development/tools/xcbuild/setup-hook.sh  ;

  xxdiff = libsForQt5.callPackage ../development/tools/misc/xxdiff { };

  xxdiff-tip = xxdiff;

  ycmd = callPackage ../development/tools/misc/ycmd {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    python = python3;
    boost = boost174;
  };

  yq = python3.pkgs.toPythonApplication python3.pkgs.yq;

  mypy = with python3Packages; toPythonApplication mypy;

  mypy-protobuf = with python3Packages; toPythonApplication mypy-protobuf;

  ### DEVELOPMENT / LIBRARIES

  abseil-cpp = abseil-cpp_202103;

  allegro = allegro4;

  ansi2html = with python3.pkgs; toPythonApplication ansi2html;

  apr = callPackage ../development/libraries/apr {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  aribb25 = callPackage ../development/libraries/aribb25 {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };

  asio_1_10 = callPackage ../development/libraries/asio/1.10.nix { };
  asio = callPackage ../development/libraries/asio { };

  aspellDicts = recurseIntoAttrs (callPackages ../development/libraries/aspell/dictionaries.nix {});

  aspellWithDicts = callPackage ../development/libraries/aspell/aspell-with-dicts.nix {
    aspell = aspell.override { searchNixProfiles = false; };
  };

  # Not moved to aliases while we decide if we should split the package again.
  at-spi2-atk = at-spi2-core;

  aqbanking = callPackage ../development/libraries/aqbanking { };

  audiofile = callPackage ../development/libraries/audiofile {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreServices;
  };

  aws-c-cal = callPackage ../development/libraries/aws-c-cal {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  aws-c-io = callPackage ../development/libraries/aws-c-io {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  aws-sdk-cpp = callPackage ../development/libraries/aws-sdk-cpp {
    inherit (darwin.apple_sdk.frameworks) CoreAudio AudioToolbox;
  };

  inherit (callPackages ../development/libraries/bashup-events { }) bashup-events32 bashup-events44;

  bencode = callPackage ../development/libraries/bencode {
    stdenv = gcc10StdenvCompat;
  };

  beignet = callPackage ../development/libraries/beignet {
    inherit (llvmPackages_6) libllvm libclang;
  };


  bicgl = callPackage ../development/libraries/science/biology/bicgl { inherit (darwin.apple_sdk.frameworks) GLUT; };

  # TODO(@Ericson2314): Build bionic libc from source
  bionic = if stdenv.hostPlatform.useAndroidPrebuilt
    then pkgs."androidndkPkgs_${stdenv.hostPlatform.ndkVer}".libraries
    else callPackage ../os-specific/linux/bionic-prebuilt { };


  bobcat = callPackage ../development/libraries/bobcat
    (lib.optionalAttrs (with stdenv.hostPlatform; isAarch64 && isLinux) {
      # C++20 is required, aarch64-linux has gcc 9 by default
      stdenv = gcc10Stdenv;
    });

  inherit (callPackage ../development/libraries/boost { inherit (buildPackages) boost-build; })
    boost165
    boost166
    boost168
    boost169
    boost170
    boost172
    boost173
    boost174
    boost175
    boost177
    boost178
    boost179
    boost180
    boost181
  ;

  boost16x = boost169;
  boost17x = boost179;
  boost18x = boost181;
  boost = boost17x;

  botan2 = callPackage ../development/libraries/botan/2.0.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  c-ares = callPackage ../development/libraries/c-ares { };

  c-aresMinimal = callPackage ../development/libraries/c-ares {
    withCMake = false;
  };

  # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
  cachix = (haskell.lib.compose.justStaticExecutables haskellPackages.cachix).overrideAttrs(o: {
    passthru = o.passthru or {} // {
      tests = o.passthru.tests or {} // {
        inherit hci;
      };
    };
  });

  cubeb = callPackage ../development/libraries/audio/cubeb {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio CoreServices;
  };

  niv = lib.getBin (haskell.lib.compose.justStaticExecutables haskellPackages.niv);

  ormolu = haskellPackages.ormolu.bin;

  ndn-cxx = callPackage ../development/libraries/ndn-cxx {
    openssl = openssl_1_1;
  };

  ndn-tools = callPackage ../tools/networking/ndn-tools {
    openssl = openssl_1_1;
  };

  cctz = callPackage ../development/libraries/cctz {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  cegui = callPackage ../development/libraries/cegui {
    ogre = ogre1_10;
  };

  certbot = python3.pkgs.toPythonApplication python3.pkgs.certbot;

  certbot-full = certbot.withPlugins (cp: with cp; [
    certbot-dns-cloudflare
    certbot-dns-rfc2136
    certbot-dns-route53
  ]);

  # CGAL 5 has API changes
  cgal_4 = callPackage ../development/libraries/CGAL/4.nix {};
  cgal_5 = callPackage ../development/libraries/CGAL {};
  cgal = cgal_4;

  check = callPackage ../development/libraries/check {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  cl = callPackage ../development/libraries/cl {
    erlang = erlangR23;
  };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  clucene_core_1 = callPackage ../development/libraries/clucene-core {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  clucene_core = clucene_core_1;

  cogl = callPackage ../development/libraries/cogl {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  coinlive = callPackage ../tools/misc/coinlive {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  cpp-netlib = callPackage ../development/libraries/cpp-netlib {
    boost = boost169; # fatal error: 'boost/asio/stream_socket_service.hpp' file not found
  };

  uri = callPackage ../development/libraries/uri { stdenv = gcc10StdenvCompat; };

  crocoddyl = callPackage ../development/libraries/crocoddyl { };

  cxxtools = callPackage ../development/libraries/cxxtools { stdenv = gcc10StdenvCompat; };

  cxxtest = python3Packages.callPackage ../development/libraries/cxxtest { };

  cypress = callPackage ../development/web/cypress { };

  cyrus_sasl = callPackage ../development/libraries/cyrus-sasl {
    libkrb5 = if stdenv.isFreeBSD then heimdal else libkrb5;
  };

  # Make bdb5 the default as it is the last release under the custom
  # bsd-like license
  db = db5;
  db4 = db48;
  db48 = callPackage ../development/libraries/db/db-4.8.nix { };
  db5 = db53;
  db53 = callPackage ../development/libraries/db/db-5.3.nix { };
  db6 = db60;
  db60 = callPackage ../development/libraries/db/db-6.0.nix { };
  db62 = callPackage ../development/libraries/db/db-6.2.nix { };

  makeDBusConf = { suidHelper, serviceDirectories, apparmor ? "disabled" }:
    callPackage ../development/libraries/dbus/make-dbus-conf.nix {
      inherit suidHelper serviceDirectories apparmor;
    };

  dee = callPackage ../development/libraries/dee {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  dillo = callPackage ../applications/networking/browsers/dillo {
    fltk = fltk13;
  };

  discord-rpc = callPackage ../development/libraries/discord-rpc {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  # Multi-arch "drivers" which we want to build for i686.
  driversi686Linux = recurseIntoAttrs {
    inherit (pkgsi686Linux)
      amdvlk
      intel-media-driver
      mesa
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
      beignet
      glxinfo
      vdpauinfo;
  };

  eccodes = callPackage ../development/libraries/eccodes {
    pythonPackages = python3Packages;
  };

  vapoursynth = callPackage ../development/libraries/vapoursynth {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  vapoursynth-editor = libsForQt5.callPackage ../development/libraries/vapoursynth/editor.nix { };

  vmmlib = callPackage ../development/libraries/vmmlib {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  elastix = callPackage ../development/libraries/science/biology/elastix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  emanote = haskell.lib.compose.justStaticExecutables haskellPackages.emanote;

  enchant = enchant2;

  libepoxy = callPackage ../development/libraries/libepoxy {
    inherit (darwin.apple_sdk.frameworks) Carbon OpenGL;
  };

  factor-lang = factor-lang-scope.interpreter;

  far2l = callPackage ../applications/misc/far2l {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    inherit (darwin.apple_sdk.frameworks) IOKit Carbon Cocoa AudioToolbox OpenGL;
  };

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
      gst-libav;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  forge = callPackage ../development/libraries/forge {
    cudatoolkit = buildPackages.cudatoolkit_11;
  };

  ffmpeg_4-headless = callPackage ../development/libraries/ffmpeg/4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia VideoToolbox;

    sdlSupport = false;
    vdpauSupport = false;
    pulseaudioSupport = false;
    libva = libva-minimal;
  };

  ffmpeg_4 = callPackage ../development/libraries/ffmpeg/4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia VideoToolbox;
  };

  ffmpeg_5-headless = callPackage ../development/libraries/ffmpeg/5.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia VideoToolbox;

    sdlSupport = false;
    vdpauSupport = false;
    pulseaudioSupport = false;
    libva = libva-minimal;
  };

  ffmpeg_5 = callPackage ../development/libraries/ffmpeg/5.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia VideoToolbox;
  };

  # Aliases
  # Please make sure this is updated to the latest version on the next major
  # update to ffmpeg
  # Packages which use ffmpeg as a library, should pin to the relevant major
  # version number which the upstream support.
  ffmpeg = ffmpeg_4;

  ffmpeg-headless = ffmpeg_4-headless;

  ffmpeg-full = callPackage ../development/libraries/ffmpeg-full {
    svt-av1 = if stdenv.isAarch64 then null else svt-av1;
    rtmpdump = null; # Prefer the built-in RTMP implementation
    # The following need to be fixed on Darwin
    libjack2 = if stdenv.isDarwin then null else libjack2;
    libmodplug = if stdenv.isDarwin then null else libmodplug;
    libmfx = if stdenv.isDarwin then null else intel-media-sdk;
    libpulseaudio = if stdenv.isDarwin then null else libpulseaudio;
    samba = if stdenv.isDarwin then null else samba;
    inherit (darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio AVFoundation MediaToolbox
      VideoDecodeAcceleration VideoToolbox;
  };

  ffmpeg_5-full = ffmpeg-full.override {
    ffmpeg = ffmpeg_5;
  };

  ffmpeg-normalize = python3Packages.callPackage ../applications/video/ffmpeg-normalize { };

  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwFloat = fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = fftw.override { precision = "long-double"; };
  fftwMpi = fftw.override { enableMpi = true; };

  fltk13 = callPackage ../development/libraries/fltk {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa OpenGL;
  };
  fltk14 = callPackage ../development/libraries/fltk/1.4.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa OpenGL;
  };
  fltk13-minimal = fltk13.override {
    withGL = false;
    withCairo = false;
    withPango = false;
    withExamples = false;
    withDocs = false;
  };
  fltk14-minimal = fltk14.override {
    withGL = false;
    withCairo = false;
    withPango = false;
    withExamples = false;
    withDocs = false;
  };
  fltk = fltk13;
  fltk-minimal = fltk13-minimal;

  inherit (callPackages ../development/libraries/fmt { }) fmt_8 fmt_9;

  fmt = fmt_9;

  freeimage = callPackage ../development/libraries/freeimage {
    inherit (darwin) autoSignDarwinBinariesHook;
    libraw = libraw_unstable;
  };

  freetts = callPackage ../development/libraries/freetts {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  frog = res.languageMachines.frog;

  fontconfig = callPackage ../development/libraries/fontconfig {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  makeFontsConf = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-conf.nix {
      inherit fontconfig fontDirectories;
    };

  makeFontsCache = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-cache.nix {
      inherit fontconfig fontDirectories;
    };

  freenect = callPackage ../development/libraries/freenect {
    inherit (darwin.apple_sdk.frameworks) Cocoa GLUT;
  };

  fam = gamin; # added 2018-04-25

  gcovr = with python3Packages; toPythonApplication gcovr;

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_6 = qt5.callPackage ../development/libraries/gecode { };
  gecode = gecode_6;

  gegl = callPackage ../development/libraries/gegl {
    inherit (darwin.apple_sdk.frameworks) OpenCL;
  };

  geoclue2-with-demo-agent = geoclue2.override { withDemoAgent = true; };

  geocode-glib_2 = geocode-glib.override {
    libsoup = libsoup_3;
  };

  geoipWithDatabase = makeOverridable (callPackage ../development/libraries/geoip) {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  inherit (callPackages ../development/libraries/getdns { })
    getdns stubby;

  gettext = callPackage ../development/libraries/gettext { };

  gd = callPackage ../development/libraries/gd {
    automake = automake115x;
  };

  gdcm = callPackage ../development/libraries/gdcm {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Cocoa;
  };

  ghp-import = with python3Packages; toPythonApplication ghp-import;

  ghcid = haskellPackages.ghcid.bin;

  graphia = libsForQt5.callPackage ../applications/science/misc/graphia { };

  libgit2 = callPackage ../development/libraries/libgit2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libgit2_1_3_0 = libgit2.overrideAttrs (_: rec {
    version = "1.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "libgit2";
      repo = "libgit2";
      rev = "v${version}";
      sha256 = "sha256-7atNkOBzX+nU1gtFQEaE+EF1L+eex+Ajhq2ocoJY920=";
    };
    patches = [];
  });

  glew = callPackage ../development/libraries/glew {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };
  glew110 = callPackage ../development/libraries/glew/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) AGL OpenGL;
  };
  glew-egl = callPackage ../development/libraries/glew {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    enableEGL = true;
  };

  glfw = glfw3;
  glfw-wayland = glfw.override {
    waylandSupport = true;
  };
  glfw3 = callPackage ../development/libraries/glfw/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa Kernel;
  };

  glibc = callPackage ../development/libraries/glibc {
    stdenv = gccStdenv; # doesn't compile without gcc
  };

  # Provided by libc on Operating Systems that use the Extensible Linker Format.
  elf-header =
    if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf"
    then null
    else elf-header-real;

  glibc_memusage = callPackage ../development/libraries/glibc {
    withGd = true;
  };

  # Being redundant to avoid cycles on boot. TODO: find a better way
  glibcCross = callPackage ../development/libraries/glibc {
    stdenv = gccCrossLibcStdenv; # doesn't compile without gcc
  };

  muslCross = musl.override {
    stdenv = crossLibcStdenv;
  };

  # These are used when buiding compiler-rt / libgcc, prior to building libc.
  preLibcCrossHeaders = let
    inherit (stdenv.targetPlatform) libc;
  in     if libc == "msvcrt" then targetPackages.windows.mingw_w64_headers or windows.mingw_w64_headers
    else if libc == "nblibc" then targetPackages.netbsdCross.headers or netbsdCross.headers
    else if libc == "libSystem" && stdenv.targetPlatform.isAarch64 then targetPackages.darwin.LibsystemCross or darwin.LibsystemCross
    else null;

  # We can choose:
  libcCrossChooser = name:
    # libc is hackily often used from the previous stage. This `or`
    # hack fixes the hack, *sigh*.
    /**/ if name == "glibc" then targetPackages.glibcCross or glibcCross
    else if name == "bionic" then targetPackages.bionic or bionic
    else if name == "uclibc" then targetPackages.uclibcCross or uclibcCross
    else if name == "avrlibc" then targetPackages.avrlibcCross or avrlibcCross
    else if name == "newlib" && stdenv.targetPlatform.isMsp430 then targetPackages.msp430NewlibCross or msp430NewlibCross
    else if name == "newlib" && stdenv.targetPlatform.isVc4 then targetPackages.vc4-newlib or vc4-newlib
    else if name == "newlib" && stdenv.targetPlatform.isOr1k then targetPackages.or1k-newlib or or1k-newlib
    else if name == "newlib" then targetPackages.newlibCross or newlibCross
    else if name == "newlib-nano" then targetPackages.newlib-nanoCross or newlib-nanoCross
    else if name == "musl" then targetPackages.muslCross or muslCross
    else if name == "msvcrt" then targetPackages.windows.mingw_w64 or windows.mingw_w64
    else if name == "libSystem" then
      if stdenv.targetPlatform.useiOSPrebuilt
      then targetPackages.darwin.iosSdkPkgs.libraries or darwin.iosSdkPkgs.libraries
      else targetPackages.darwin.LibsystemCross or (throw "don't yet have a `targetPackages.darwin.LibsystemCross for ${stdenv.targetPlatform.config}`")
    else if name == "fblibc" then targetPackages.freebsdCross.libc or freebsdCross.libc
    else if name == "nblibc" then targetPackages.netbsdCross.libc or netbsdCross.libc
    else if name == "wasilibc" then targetPackages.wasilibc or wasilibc
    else if name == "relibc" then targetPackages.relibc or relibc
    else if stdenv.targetPlatform.isGhcjs then null
    else throw "Unknown libc ${name}";

  libcCross = assert stdenv.targetPlatform != stdenv.buildPlatform; libcCrossChooser stdenv.targetPlatform.libc;

  threadsCross = if stdenv.targetPlatform.isMinGW && !(stdenv.targetPlatform.useLLVM or false)
    then {
      # other possible values: win32 or posix
      model = "mcf";
      # For win32 or posix set this to null
      package = targetPackages.windows.mcfgthreads or windows.mcfgthreads;
    } else {};

  wasilibc = callPackage ../development/libraries/wasilibc {
    stdenv = crossLibcStdenv;
  };

  # Only supported on Linux and only on glibc
  glibcLocales =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu
    then callPackage ../development/libraries/glibc/locales.nix { }
    else null;
  glibcLocalesUtf8 =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu
    then callPackage ../development/libraries/glibc/locales.nix { allLocales = false; }
    else null;

  glibcInfo = callPackage ../development/libraries/glibc/info.nix { };

  glibc_multi = callPackage ../development/libraries/glibc/multi.nix {
    glibc32 = pkgsi686Linux.glibc;
  };

  glsurf = callPackage ../applications/science/math/glsurf {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  gmime = gmime2;

  /* gmp4 = <moved> */ # required by older GHC versions
  gmp = gmp6;
  gmpxx = gmp.override { cxx = true; };

  #GMP ex-satellite, so better keep it near gmp

  # A GMP fork

  # gnatcoll-bindings repository
  gnatcoll-gmp = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "gmp"; };
  gnatcoll-iconv = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "iconv"; };
  gnatcoll-lzma = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "lzma"; };
  gnatcoll-omp = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "omp"; };
  gnatcoll-python3 = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "python3"; };
  gnatcoll-readline = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "readline"; };
  gnatcoll-syslog = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "syslog"; };
  gnatcoll-zlib = callPackage ../development/libraries/ada/gnatcoll/bindings.nix { component = "zlib"; };

  # gnatcoll-db repository
  gnatcoll-postgres = callPackage ../development/libraries/ada/gnatcoll/db.nix { component = "postgres"; };
  gnatcoll-sql = callPackage ../development/libraries/ada/gnatcoll/db.nix { component = "sql"; };
  gnatcoll-sqlite = callPackage ../development/libraries/ada/gnatcoll/db.nix { component = "sqlite"; };
  gnatcoll-xref = callPackage ../development/libraries/ada/gnatcoll/db.nix { component = "xref"; };

  gns3Packages = dontRecurseIntoAttrs (callPackage ../applications/networking/gns3 { });
  gns3-gui = gns3Packages.guiStable;
  gns3-server = gns3Packages.serverStable;

  gobject-introspection = callPackage ../development/libraries/gobject-introspection/wrapper.nix { };

  gobject-introspection-unwrapped = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
    inherit (darwin) cctools;
  };

  grpc = callPackage ../development/libraries/grpc {
    # grpc builds with c++17 so abseil must also be built that way
    abseil-cpp = abseil-cpp_202206.override {
      cxxStandard = grpc.cxxStandard;
    };
  };

  gsettings-qt = libsForQt5.callPackage ../development/libraries/gsettings-qt { };

  gst_all_1 = recurseIntoAttrs(callPackage ../development/libraries/gstreamer {
    callPackage = newScope (gst_all_1 // { libav = pkgs.ffmpeg-headless; });
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AVFoundation Cocoa CoreFoundation CoreMedia CoreServices CoreVideo DiskArbitration Foundation IOKit MediaToolbox OpenGL VideoToolbox;
  });


  qxmpp = libsForQt5.callPackage ../development/libraries/qxmpp {};

  gnu-efi = if stdenv.hostPlatform.isEfi
              then callPackage ../development/libraries/gnu-efi { }
            else null;

  gnutls = callPackage ../development/libraries/gnutls {
    inherit (darwin.apple_sdk.frameworks) Security;
    util-linux = util-linuxMinimal; # break the cyclic dependency
    autoconf = buildPackages.autoconf269;
  };

  gpgme = callPackage ../development/libraries/gpgme { };

  glib = callPackage ../development/libraries/glib (let
    glib-untested = glib.overrideAttrs (_: { doCheck = false; });
  in {
    # break dependency cycles
    # these things are only used for tests, they don't get into the closure
    shared-mime-info = shared-mime-info.override { glib = glib-untested; };
    desktop-file-utils = desktop-file-utils.override { glib = glib-untested; };
    dbus = dbus.override { enableSystemd = false; };
  });

  glibmm_2_68 = callPackage ../development/libraries/glibmm/2.68.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  glirc = haskell.lib.compose.justStaticExecutables haskellPackages.glirc;

  # Not moved to aliases while we decide if we should split the package again.
  atk = at-spi2-core;

  cairomm_1_16 = callPackage ../development/libraries/cairomm/1.16.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pango = callPackage ../development/libraries/pango {
    harfbuzz = harfbuzz.override { withCoreText = stdenv.isDarwin; };
  };

  pangolin = callPackage ../development/libraries/pangolin {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  pangomm = callPackage ../development/libraries/pangomm {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pangomm_2_48 = callPackage ../development/libraries/pangomm/2.48.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pangomm_2_42 = callPackage ../development/libraries/pangomm/2.42.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  gtk2 = callPackage ../development/libraries/gtk/2.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gtk2-x11 = gtk2.override {
    cairo = cairo.override { x11Support = true; };
    pango = pango.override { cairo = cairo.override { x11Support = true; }; x11Support = true; };
    gdktarget = "x11";
  };

  gtk3 = callPackage ../development/libraries/gtk/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa QuartzCore;
  };

  gtk4 = callPackage ../development/libraries/gtk/4.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };


  # On darwin gtk uses cocoa by default instead of x11.
  gtk3-x11 = gtk3.override {
    cairo = cairo.override { x11Support = true; };
    pango = pango.override { cairo = cairo.override { x11Support = true; }; x11Support = true; };
    x11Support = true;
  };

  gtk-sharp-2_0 = callPackage ../development/libraries/gtk-sharp/2.0.nix { };

  gtk-sharp-3_0 = callPackage ../development/libraries/gtk-sharp/3.0.nix { };

  gtk-mac-integration = callPackage ../development/libraries/gtk-mac-integration {
    gtk = gtk3;
  };

  gtk-mac-integration-gtk2 = gtk-mac-integration.override {
    gtk = gtk2;
  };

  gtk-mac-integration-gtk3 = gtk-mac-integration;

  gtksourceview = gtksourceview3;

  gtksourceview4 = callPackage ../development/libraries/gtksourceview/4.x.nix { };

  gtksourceview5 = callPackage ../development/libraries/gtksourceview/5.x.nix { };

  gwenhywfar = callPackage ../development/libraries/aqbanking/gwenhywfar.nix { };

  hamlib = hamlib_3;

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security SystemConfiguration;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  harfbuzz = callPackage ../development/libraries/harfbuzz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreText;
  };

  harfbuzzFull = harfbuzz.override {
    withCoreText = stdenv.isDarwin;
    withGraphite2 = true;
    withIcu = true;
  };

  herqq = libsForQt5.callPackage ../development/libraries/herqq { };

  hidapi = callPackage ../development/libraries/hidapi {
    inherit (darwin.apple_sdk.frameworks) Cocoa IOKit;
    # TODO: remove once `udev` is `systemdMinimal` everywhere.
    udev = systemdMinimal;
  };

  highfive-mpi = highfive.override { hdf5 = hdf5-mpi; };

  hivex = callPackage ../development/libraries/hivex {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  hpx = callPackage ../development/libraries/hpx {
    boost = boost17x;
    asio = asio.override { boost = boost17x; };
  };

  hunspellDicts = recurseIntoAttrs (callPackages ../development/libraries/hunspell/dictionaries.nix {});

  hunspellWithDicts = dicts: callPackage ../development/libraries/hunspell/wrapper.nix { inherit dicts; };

  hydra_unstable = callPackage ../development/tools/misc/hydra/unstable.nix { nix = nixVersions.nix_2_11; };

  hydra-cli = callPackage ../development/tools/misc/hydra-cli {
    openssl = openssl_1_1;
  };

  hydra-check = with python310.pkgs; toPythonApplication hydra-check;

  icu58 = callPackage (import ../development/libraries/icu/58.nix fetchurl) ({
    nativeBuildRoot = buildPackages.icu58.override { buildRootOnly = true; };
  });
  icu60 = callPackage ../development/libraries/icu/60.nix ({
    nativeBuildRoot = buildPackages.icu60.override { buildRootOnly = true; };
  });
  icu63 = callPackage ../development/libraries/icu/63.nix ({
    nativeBuildRoot = buildPackages.icu63.override { buildRootOnly = true; };
  });
  icu64 = callPackage ../development/libraries/icu/64.nix ({
    nativeBuildRoot = buildPackages.icu64.override { buildRootOnly = true; };
  });
  icu66 = callPackage ../development/libraries/icu/66.nix ({
    nativeBuildRoot = buildPackages.icu66.override { buildRootOnly = true; };
  });
  icu67 = callPackage ../development/libraries/icu/67.nix ({
    nativeBuildRoot = buildPackages.icu67.override { buildRootOnly = true; };
  });
  icu68 = callPackage ../development/libraries/icu/68.nix ({
    nativeBuildRoot = buildPackages.icu68.override { buildRootOnly = true; };
  });
  icu69 = callPackage ../development/libraries/icu/69.nix ({
    nativeBuildRoot = buildPackages.icu69.override { buildRootOnly = true; };
  });
  icu70 = callPackage ../development/libraries/icu/70.nix ({
    nativeBuildRoot = buildPackages.icu70.override { buildRootOnly = true; };
  });
  icu71 = callPackage ../development/libraries/icu/71.nix ({
    nativeBuildRoot = buildPackages.icu71.override { buildRootOnly = true; };
  });
  icu72 = callPackage ../development/libraries/icu/72.nix ({
    nativeBuildRoot = buildPackages.icu72.override { buildRootOnly = true; };
  });

  icu = icu72;

  idasen = with python3Packages; toPythonApplication idasen;

  imlib2Full = imlib2.override {
    # Compilation error on Darwin with librsvg. For more information see:
    # https://github.com/NixOS/nixpkgs/pull/166452#issuecomment-1090725613
    svgSupport = !stdenv.isDarwin;
    heifSupport = !stdenv.isDarwin;
    webpSupport = true;
    jxlSupport = true;
    psSupport = true;
  };
  imlib2-nox = imlib2.override {
    x11Support = false;
  };

  imlibsetroot = callPackage ../applications/graphics/imlibsetroot { libXinerama = xorg.libXinerama; } ;

  irrlicht = if !stdenv.isDarwin then
    callPackage ../development/libraries/irrlicht { }
  else callPackage ../development/libraries/irrlicht/mac.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL IOKit;
  };

  irrlichtmt = callPackage ../development/libraries/irrlichtmt {
    inherit  (darwin.apple_sdk.frameworks) Cocoa Kernel;
  };

  isort = with python3Packages; toPythonApplication isort;

  ispc = callPackage ../development/compilers/ispc {
    inherit (llvmPackages) stdenv;
  };

  isso = callPackage ../servers/isso {
    nodejs = nodejs-14_x;
  };

  itk_5_2 = callPackage ../development/libraries/itk/5.2.x.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  itk_5 = callPackage ../development/libraries/itk/5.x.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  itk = itk_5;

  json2yaml = haskell.lib.compose.justStaticExecutables haskellPackages.json2yaml;

  kddockwidgets = libsForQt5.callPackage ../development/libraries/kddockwidgets { };

  keybinder = callPackage ../development/libraries/keybinder {
    automake = automake111x;
    lua = lua5_1;
  };

  keybinder3 = callPackage ../development/libraries/keybinder3 {
    gtk3 = if stdenv.isDarwin then gtk3-x11 else gtk3;
    automake = automake111x;
  };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix {
    inherit (buildPackages.darwin) bootstrap_cmds;
  };
  libkrb5 = krb5.override { type = "lib"; };

  l-smash = callPackage ../development/libraries/l-smash {
    stdenv = gccStdenv;
  };

  languageMachines = recurseIntoAttrs (import ../development/libraries/languagemachines/packages.nix {
    inherit pkgs;
  });

  lcms = lcms1;

  lemon-graph = callPackage ../development/libraries/lemon-graph {
    stdenv = if stdenv.isLinux then gcc11Stdenv else stdenv;
  };

  libacr38u = callPackage ../tools/security/libacr38u {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libadwaita = callPackage ../development/libraries/libadwaita {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Foundation;
  };

  libagar = callPackage ../development/libraries/libagar { };
  libagar_test = callPackage ../development/libraries/libagar/libagar_test.nix { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) CoreAudio CoreServices AudioUnit;
  };

  libaom = callPackage ../development/libraries/libaom {
    # Remove circular dependency for libavif
    libjxl = libjxl.override { buildDocs = false; };
  };

  libappindicator-gtk2 = libappindicator.override { gtkVersion = "2"; };
  libappindicator-gtk3 = libappindicator.override { gtkVersion = "3"; };

  libarchive-qt = libsForQt5.callPackage ../development/libraries/libarchive-qt { };

  libav = libav_11; # branch 11 is API-compatible with branch 10
  libav_all = callPackages ../development/libraries/libav { };
  inherit (libav_all) libav_0_8 libav_11 libav_12;

  libbap = callPackage ../development/libraries/libbap {
    inherit (ocaml-ng.ocamlPackages) bap ocaml findlib ctypes;
  };

  libbass = (callPackage ../development/libraries/audio/libbass { }).bass;
  libbass_fx = (callPackage ../development/libraries/audio/libbass { }).bass_fx;

  libbluray = callPackage ../development/libraries/libbluray {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration;
  };

  libcanberra = callPackage ../development/libraries/libcanberra {
    inherit (darwin.apple_sdk.frameworks) Carbon CoreServices AppKit;
  };
  libcanberra-gtk2 = pkgs.libcanberra.override {
    gtkSupport = "gtk2";
  };
  libcanberra-gtk3 = pkgs.libcanberra.override {
    gtkSupport = "gtk3";
  };

  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then pkgs.libcanberra
    else pkgs.libcanberra-gtk2;

  libcdio = callPackage ../development/libraries/libcdio {
    inherit (darwin.apple_sdk.frameworks) Carbon IOKit;
  };

  libcdio-paranoia = callPackage ../development/libraries/libcdio-paranoia {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration IOKit;
  };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain_libsoup3 = libchamplain.override { withLibsoup3 = true; };

  libchipcard = callPackage ../development/libraries/aqbanking/libchipcard.nix { };

  libclc = callPackage ../development/libraries/libclc {
    llvmPackages = llvmPackages_latest;
  };

  libdbiDriversBase = libdbiDrivers.override {
    libmysqlclient = null;
    sqlite = null;
  };

  libdbusmenu-gtk2 = libdbusmenu.override { gtkVersion = "2"; };
  libdbusmenu-gtk3 = libdbusmenu.override { gtkVersion = "3"; };

  libdc1394 = callPackage ../development/libraries/libdc1394 {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  libdeltachat = callPackage ../development/libraries/libdeltachat {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  libdevil = callPackage ../development/libraries/libdevil {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  libdevil-nox = callPackage ../development/libraries/libdevil {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    withXorg = false;
  };

  libdvdcss = callPackage ../development/libraries/libdvdcss {
    inherit (darwin) IOKit;
  };

  libdvdnav_4_2_1 = callPackage ../development/libraries/libdvdnav/4.2.1.nix {
    libdvdread = libdvdread_4_9_9;
  };

  libdwarf = callPackage ../development/libraries/libdwarf { };
  dwarfdump = libdwarf.bin;
  libdwarf_20210528 = callPackage ../development/libraries/libdwarf/20210528.nix { };

  libeatmydata = callPackage ../development/libraries/libeatmydata {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  libelf = if stdenv.isFreeBSD
  then callPackage ../development/libraries/libelf-freebsd { }
  else callPackage ../development/libraries/libelf { };

  libfido2 = callPackage ../development/libraries/libfido2 {
    udev = systemdMinimal;
  };

  libfilezilla = callPackage ../development/libraries/libfilezilla {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  libfm-extra = libfm.override {
    extraOnly = true;
  };

  libgnome-keyring3 = gnome.libgnome-keyring;

  libgrss = callPackage ../development/libraries/libgrss {
    inherit (darwin.apple_sdk_11_0.frameworks) Foundation AppKit;
  };

  libiio = callPackage ../development/libraries/libiio {
    inherit (darwin.apple_sdk.frameworks) CFNetwork CoreServices;
    python = python3;
  };

  libsoundio = callPackage ../development/libraries/libsoundio {
    inherit (darwin.apple_sdk.frameworks) AudioUnit;
  };

  libLAS = callPackage ../development/libraries/libLAS {
    boost = boost172;
  };

  libe-book = callPackage ../development/libraries/libe-book {
    icu = icu67;
  };

  libextractor = callPackage ../development/libraries/libextractor {
    libmpeg2 = mpeg2dec;
  };

  libfive = libsForQt5.callPackage ../development/libraries/libfive { };

  libffiBoot = libffi.override {
    doCheck = false;
  };

  libfreefare = callPackage ../development/libraries/libfreefare {
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
    inherit (darwin) libobjc;
  };

  libftdi = callPackage ../development/libraries/libftdi {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
  };

  libgdiplus = callPackage ../development/libraries/libgdiplus {
      inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  # https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgpg-error.git;a=blob;f=README;h=fd6e1a83f55696c1f7a08f6dfca08b2d6b7617ec;hb=70058cd9f944d620764e57c838209afae8a58c78#l118
  libgpg-error-gen-posix-lock-obj = libgpg-error.override {
    genPosixLockObjOnly = true;
  };

  libgpod = callPackage ../development/libraries/libgpod {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  libguestfs = callPackage ../development/libraries/libguestfs {
    autoreconfHook = buildPackages.autoreconfHook264;
  };
  libguestfs-with-appliance = libguestfs.override {
    appliance = libguestfs-appliance;
    autoreconfHook = buildPackages.autoreconfHook264;
  };


  libhv = callPackage ../development/libraries/libhv {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libimobiledevice = callPackage ../development/libraries/libimobiledevice {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration CoreFoundation;
  };

  libindicator-gtk2 = libindicator.override { gtkVersion = "2"; };
  libindicator-gtk3 = libindicator.override { gtkVersion = "3"; };

  libiodbc = callPackage ../development/libraries/libiodbc {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  liblqr1 = callPackage ../development/libraries/liblqr-1 {
    inherit (darwin.apple_sdk.frameworks) Carbon AppKit;
  };

  librepo = callPackage ../tools/package-management/librepo {
    python = python3;
  };

  librime = callPackage ../development/libraries/librime {
    boost = boost174;
  };

  librsb = callPackage ../development/libraries/librsb {
    # Taken from https://build.opensuse.org/package/view_file/science/librsb/librsb.spec
    memHierarchy = "L3:16/64/8192K,L2:16/64/2048K,L1:8/64/16K";
  };

  libsamplerate = callPackage ../development/libraries/libsamplerate {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon CoreServices;
  };

  # GNU libc provides libiconv so systems with glibc don't need to
  # build libiconv separately. Additionally, Apple forked/repackaged
  # libiconv so we use that instead of the vanilla version on that OS,
  # and BSDs include libiconv in libc.
  #
  # We also provide `libiconvReal`, which will always be a standalone libiconv,
  # just in case you want it regardless of platform.
  libiconv =
    if lib.elem stdenv.hostPlatform.libc [ "glibc" "musl" "nblibc" "wasilibc" ]
      then libcIconv (if stdenv.hostPlatform != stdenv.buildPlatform
        then libcCross
        else stdenv.cc.libc)
    else if stdenv.hostPlatform.isDarwin
      then darwin.libiconv
    else libiconvReal;

  libcIconv = libc: let
    inherit (libc) pname version;
    libcDev = lib.getDev libc;
  in runCommand "${pname}-iconv-${version}" { strictDeps = true; } ''
    mkdir -p $out/include
    ln -sv ${libcDev}/include/iconv.h $out/include
  '';

  libiconvReal = callPackage ../development/libraries/libiconv { };

  # On non-GNU systems we need GNU Gettext for libintl.
  libintl = if stdenv.hostPlatform.libc != "glibc" then gettext else null;

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  # also known as libturbojpeg
  libjpeg = libjpeg_turbo;

  libjson-rpc-cpp = callPackage ../development/libraries/libjson-rpc-cpp {
    libmicrohttpd = libmicrohttpd_0_9_72;
  };

  malcontent = callPackage ../development/libraries/malcontent { };

  malcontent-ui = callPackage ../development/libraries/malcontent/ui.nix { };

  libmatheval = callPackage ../development/libraries/libmatheval {
    autoconf = buildPackages.autoconf269;
    guile = guile_2_0;
  };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  libmicrohttpd_0_9_69 = callPackage ../development/libraries/libmicrohttpd/0.9.69.nix { };
  libmicrohttpd_0_9_71 = callPackage ../development/libraries/libmicrohttpd/0.9.71.nix { };
  libmicrohttpd_0_9_72 = callPackage ../development/libraries/libmicrohttpd/0.9.72.nix { };
  libmicrohttpd = libmicrohttpd_0_9_71;

  libmikmod = callPackage ../development/libraries/libmikmod {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  libmusicbrainz = libmusicbrainz3;

  libnest2d = callPackage ../development/libraries/libnest2d {
    boost = boost174;
  };

  libosmscout = libsForQt5.callPackage ../development/libraries/libosmscout { };

  libp11 = callPackage ../development/libraries/libp11 {
    openssl = openssl_1_1;
  };

  libphonenumber = callPackage ../development/libraries/libphonenumber {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  inherit (callPackages ../development/libraries/prometheus-client-c {
    stdenv = gccStdenv; # Required for darwin
  }) libprom libpromhttp;

  libproxy = callPackage ../development/libraries/libproxy {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration CoreFoundation JavaScriptCore;
  };

  libpwquality = callPackage ../development/libraries/libpwquality {
    python = python3;
  };

  libqt5pas = libsForQt5.callPackage ../development/compilers/fpc/libqt5pas.nix { };

  librsvg = callPackage ../development/libraries/librsvg {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Foundation;
  };

  libsndfile = callPackage ../development/libraries/libsndfile {
    inherit (darwin.apple_sdk.frameworks) Carbon AudioToolbox;
  };

  libstatgrab = callPackage ../development/libraries/libstatgrab {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libticalcs2 = callPackage ../development/libraries/libticalcs2 {
    inherit (darwin) libobjc;
  };

  libtorrent-rasterbar-2_0_x = callPackage ../development/libraries/libtorrent-rasterbar {
    stdenv = if stdenv.isDarwin then llvmPackages_14.stdenv else stdenv;
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
    python = python3;
  };

  libtorrent-rasterbar-1_2_x = callPackage ../development/libraries/libtorrent-rasterbar/1.2.nix {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
    python = python3;
  };

  libtorrent-rasterbar = libtorrent-rasterbar-2_0_x;

  libui = callPackage ../development/libraries/libui {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  libuiohook = callPackage ../development/libraries/libuiohook {
    inherit (darwin.apple_sdk.frameworks) AppKit ApplicationServices Carbon;
  };

  libusb1 = callPackage ../development/libraries/libusb1 {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
    # TODO: remove once `udev` is `systemdMinimal` everywhere.
    udev = systemdMinimal;
  };

  libunwind =
    if stdenv.isDarwin then darwin.libunwind
    else if stdenv.hostPlatform.system == "riscv32-linux" then llvmPackages_latest.libunwind
    else callPackage ../development/libraries/libunwind { };

  libuv = callPackage ../development/libraries/libuv {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  };

  libv4l = lowPrio (v4l-utils.override {
    withUtils = false;
  });

  libva-minimal = callPackage ../development/libraries/libva { minimal = true; };
  libva = libva-minimal.override { minimal = false; };

  libva1-minimal = libva1.override { minimal = true; };

  libvgm = callPackage ../development/libraries/libvgm {
    inherit (darwin.apple_sdk.frameworks) CoreAudio AudioToolbox;
  };

  libvirt = callPackage ../development/libraries/libvirt {
    inherit (darwin.apple_sdk.frameworks) Carbon AppKit;
  };

  libvncserver = callPackage ../development/libraries/libvncserver {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  libxcrypt = callPackage ../development/libraries/libxcrypt {
    fetchurl = stdenv.fetchurlBoot;
    perl = buildPackages.perl.override {
      enableCrypt = false;
      fetchurl = stdenv.fetchurlBoot;
    };
  };

  libxkbcommon = libxkbcommon_8;

  libxml2 = callPackage ../development/libraries/libxml2 {
    python = python3;
  };

  libxml2Python = let
    inherit (python3.pkgs) libxml2;
  in pkgs.buildEnv { # slightly hacky
    name = "libxml2+py-${res.libxml2.version}";
    paths = with libxml2; [ dev bin py ];
    inherit (libxml2) passthru;
    # the hook to find catalogs is hidden by buildEnv
    postBuild = ''
      mkdir "$out/nix-support"
      cp '${libxml2.dev}/nix-support/propagated-build-inputs' "$out/nix-support/"
    '';
  };

  libxslt = callPackage ../development/libraries/libxslt {
    python = python3;
  };

  liquid-dsp = callPackage ../development/libraries/liquid-dsp {
    inherit (darwin) autoSignDarwinBinariesHook cctools;
  };

  luabind = callPackage ../development/libraries/luabind { lua = lua5_1; };

  luabind_luajit = luabind.override { lua = luajit; };

  luksmeta = callPackage ../development/libraries/luksmeta {
    asciidoc = asciidoc-full;
  };

  mapnik = callPackage ../development/libraries/mapnik {
    harfbuzz = harfbuzz.override {
      withIcu = true;
    };
  };

  matterhorn = haskell.lib.compose.justStaticExecutables haskellPackages.matterhorn;

  mbedtls_2 = callPackage ../development/libraries/mbedtls/2.nix { };
  mbedtls = callPackage ../development/libraries/mbedtls/3.nix { };

  mediastreamer = libsForQt5.callPackage ../development/libraries/mediastreamer { };

  memorymappingHook = makeSetupHook {
    deps = [ memorymapping ];
  } ../development/libraries/memorymapping/setup-hook.sh;

  memstreamHook = makeSetupHook {
    deps = [ memstream ];
  } ../development/libraries/memstream/setup-hook.sh;

  ## libGL/libGLU/Mesa stuff

  # Default libGL implementation, should provide headers and
  # libGL.so/libEGL.so/... to link agains them. Android NDK provides
  # an OpenGL implementation, we can just use that.
  libGL = if stdenv.hostPlatform.useAndroidPrebuilt then stdenv
          else callPackage ../development/libraries/mesa/stubs.nix {
            inherit (darwin.apple_sdk.frameworks) OpenGL;
          };

  # Default libGLU
  libGLU = mesa_glu;

  mesa = callPackage ../development/libraries/mesa {
    llvmPackages = llvmPackages_latest;
    stdenv = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
    inherit (darwin.apple_sdk_11_0.frameworks) OpenGL;
    inherit (darwin.apple_sdk_11_0.libs) Xplugin;
  };

  mesa_glu =  callPackage ../development/libraries/mesa-glu {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  ## End libGL/libGLU/Mesa stuff

  microsoft-edge = callPackage (import ../applications/networking/browsers/microsoft-edge).stable { };
  microsoft-edge-beta = callPackage (import ../applications/networking/browsers/microsoft-edge).beta { };
  microsoft-edge-dev = callPackage (import ../applications/networking/browsers/microsoft-edge).dev { };

  MIDIVisualizer = callPackage ../applications/audio/midi-visualizer {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Carbon CoreAudio CoreMIDI CoreServices Kernel;
  };

  mkvtoolnix = libsForQt5.callPackage ../applications/video/mkvtoolnix { };

  mkvtoolnix-cli = mkvtoolnix.override {
    withGUI = false;
  };

  mlv-app = libsForQt5.callPackage ../applications/video/mlv-app { };

  movine = callPackage ../development/tools/database/movine {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  mps = callPackage ../development/libraries/mps { stdenv = gcc10StdenvCompat; };

  mpeg2dec = libmpeg2;

  mqttui = callPackage ../tools/networking/mqttui {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  msoffcrypto-tool = with python3.pkgs; toPythonApplication msoffcrypto-tool;

  mpich = callPackage ../development/libraries/mpich {
    ch4backend = libfabric;
  };

  mtxclient = callPackage ../development/libraries/mtxclient {
    # https://github.com/NixOS/nixpkgs/issues/201254
    stdenv = if stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU then gcc11Stdenv else stdenv;
  };

  mu = callPackage ../tools/networking/mu {
    texinfo = texinfo4;
  };

  muparser = callPackage ../development/libraries/muparser {
    inherit (darwin.stubs) setfile;
  };

  mygpoclient = with python3.pkgs; toPythonApplication mygpoclient;

  mygui = callPackage ../development/libraries/mygui {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    ogre = ogre1_9;
  };

  nanovna-saver = libsForQt5.callPackage ../applications/science/electronics/nanovna-saver { };

  nemo-qml-plugin-dbus = libsForQt5.callPackage ../development/libraries/nemo-qml-plugin-dbus { };

  ncurses5 = ncurses.override {
    abiVersion = "5";
  };
  ncurses6 = ncurses.override {
    abiVersion = "6";
  };
  ncurses =
    if stdenv.hostPlatform.useiOSPrebuilt
    then null
    else callPackage ../development/libraries/ncurses { };

  nettle = import ../development/libraries/nettle { inherit callPackage fetchurl; };

  newt = callPackage ../development/libraries/newt { python = python3; };

  libnghttp2 = nghttp2.lib;

  non = callPackage ../applications/audio/non { stdenv = gcc10StdenvCompat; };

  nspr = callPackage ../development/libraries/nspr {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  nss_latest = callPackage ../development/libraries/nss/latest.nix { };
  nss_esr = callPackage ../development/libraries/nss/esr.nix { };
  nss = nss_esr;
  nssTools = nss.tools;

  nuspellWithDicts = dicts: callPackage ../development/libraries/nuspell/wrapper.nix { inherit dicts; };

  mkNvidiaContainerPkg = { name, containerRuntimePath, configTemplate, additionalPaths ? [] }:
    let
      nvidia-container-runtime = callPackage ../applications/virtualization/nvidia-container-runtime {
        inherit containerRuntimePath configTemplate;
      };
    in symlinkJoin {
      inherit name;
      paths = [
        (callPackage ../applications/virtualization/libnvidia-container { })
        nvidia-container-runtime
        (callPackage ../applications/virtualization/nvidia-container-toolkit {
          inherit nvidia-container-runtime;
        })
      ] ++ additionalPaths;
    };

  nvidia-docker = mkNvidiaContainerPkg {
    name = "nvidia-docker";
    containerRuntimePath = "${docker}/libexec/docker/runc";
    configTemplate = ../applications/virtualization/nvidia-docker/config.toml;
    additionalPaths = [ (callPackage ../applications/virtualization/nvidia-docker { }) ];
  };

  nvidia-podman = mkNvidiaContainerPkg {
    name = "nvidia-podman";
    containerRuntimePath = "${runc}/bin/runc";
    configTemplate = ../applications/virtualization/nvidia-podman/config.toml;
  };

  nvidia-vaapi-driver = lib.hiPrio (callPackage ../development/libraries/nvidia-vaapi-driver { });

  nvtop = callPackage ../tools/system/nvtop { };
  nvtop-nvidia = callPackage ../tools/system/nvtop { amd = false; };
  nvtop-amd = callPackage ../tools/system/nvtop { nvidia = false; };

  ogre = callPackage ../development/libraries/ogre {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  ogrepaged = callPackage ../development/libraries/ogrepaged {
    ogre = ogre1_9;
  };

  openalSoft = callPackage ../development/libraries/openal-soft {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };
  openal = openalSoft;

  openbabel = openbabel3;

  openbabel3 = callPackage ../development/libraries/openbabel {
    python = python3;
  };

  opencascade = callPackage ../development/libraries/opencascade {
    inherit (darwin.apple_sdk.frameworks) OpenCL Cocoa;
  };

  opencsg = callPackage ../development/libraries/opencsg {
    inherit (qt5) qmake;
    inherit (darwin.apple_sdk.frameworks) GLUT;
  };

  opencv2 = callPackage ../development/libraries/opencv {
    inherit (darwin.apple_sdk.frameworks) Cocoa QTKit;
    ffmpeg = ffmpeg_4;
  };

  opencv3 = callPackage ../development/libraries/opencv/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) AVFoundation Cocoa VideoDecodeAcceleration;
    ffmpeg = ffmpeg_4;
  };

  opencv3WithoutCuda = opencv3.override {
    enableCuda = false;
  };

  opencv4 = callPackage ../development/libraries/opencv/4.x.nix {
    inherit (darwin.apple_sdk.frameworks) AVFoundation Cocoa VideoDecodeAcceleration CoreMedia MediaToolbox;
    pythonPackages = python3Packages;
    ffmpeg = ffmpeg_4;
  };

  opencv = opencv4;

  openexr = openexr_2;

  openldap = callPackage ../development/libraries/openldap {
    openssl = openssl_legacy;
  };

  opencolorio = darwin.apple_sdk_11_0.callPackage ../development/libraries/opencolorio {
    inherit (darwin.apple_sdk_11_0.frameworks) Carbon GLUT Cocoa;
  };

  ois = callPackage ../development/libraries/ois {
    inherit (darwin.apple_sdk.frameworks) Cocoa IOKit Kernel;
  };

  openpgp-card-tools = callPackage ../tools/security/openpgp-card-tools {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };

  openscenegraph = callPackage ../development/libraries/openscenegraph {
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Foundation;
  };

  openstackclient = with python3Packages; toPythonApplication python-openstackclient;
  glanceclient = with python3Packages; toPythonApplication python-glanceclient;
  heatclient = with python3Packages; toPythonApplication python-heatclient;
  ironicclient = with python3Packages; toPythonApplication python-ironicclient;
  manilaclient = with python3Packages; toPythonApplication python-manilaclient;

  inherit (callPackages ../development/libraries/libressl { })
    libressl_3_4
    libressl_3_5
    libressl_3_6;

  libressl = libressl_3_6;

  wolfssl = callPackage ../development/libraries/wolfssl {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  openssl = openssl_3;

  openssl_legacy = openssl.override {
    conf = ../development/libraries/openssl/3.0/legacy.cnf;
  };

  inherit (callPackages ../development/libraries/openssl { })
    openssl_1_1
    openssl_3;

  openturns = callPackage ../development/libraries/openturns {
      inherit (darwin.apple_sdk.frameworks) Accelerate;
  };

  openwebrx = callPackage ../applications/radio/openwebrx {
    inherit (python3Packages)
    buildPythonPackage buildPythonApplication setuptools pycsdr pydigiham;
  };

  pcl = libsForQt5.callPackage ../development/libraries/pcl {
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL OpenGL;
  };

  pcre16 = super.pcre.override { variant = "pcre16"; };
  # pcre32 seems unused
  pcre-cpp = super.pcre.override { variant = "cpp"; };

  inherit (callPackage ../development/libraries/physfs {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  })
    physfs_2
    physfs;

  pipelight = callPackage ../tools/misc/pipelight {
    stdenv = stdenv_32bit;
    wine-staging = pkgsi686Linux.wine-staging;
  };

  place-cursor-at = haskell.lib.compose.justStaticExecutables haskellPackages.place-cursor-at;

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };

  poppler_gi = lowPrio (poppler.override {
    introspectionSupport = true;
  });

  poppler_min = poppler.override { # TODO: maybe reduce even more
    # this is currently only used by texlive.bin.
    minimal = true;
    suffix = "min";
  };

  poppler_utils = poppler.override {
    suffix = "utils";
    utils = true;
  };

  portaudio = callPackage ../development/libraries/portaudio {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AudioUnit CoreAudio CoreServices Carbon;
  };

  portmidi = callPackage ../development/libraries/portmidi {
    inherit (darwin.apple_sdk.frameworks) Carbon CoreAudio CoreFoundation CoreMIDI CoreServices;
  };

  proselint = callPackage ../tools/text/proselint {
    inherit (python3Packages)
    buildPythonApplication click future six;
  };

  # https://github.com/protocolbuffers/protobuf/issues/10418
  # protobuf versions have to match between build-time and run-time
  # Using "targetPlatform" in the check makes sure that the version of
  # pkgsCross.armv7l-hf-multiplatform.buildPackages.protobuf matches the
  # version of pkgsCross.armv7l-hf-multiplatform.protobuf
  protobuf = if stdenv.targetPlatform.is32bit then protobuf3_20 else
    protobuf3_21;

  protobuf3_20 = callPackage ../development/libraries/protobuf/3.20.nix { };
  protobuf3_19 = callPackage ../development/libraries/protobuf/3.19.nix { };
  protobuf3_17 = callPackage ../development/libraries/protobuf/3.17.nix { };
  protobuf3_8 = callPackage ../development/libraries/protobuf/3.8.nix { };

  nanopb = callPackage ../development/libraries/nanopb { };
  nanopbMalloc = callPackage ../development/libraries/nanopb { mallocBuild = true; };

  pth = if stdenv.hostPlatform.isMusl then npth else gnupth;

  python-qt = callPackage ../development/libraries/python-qt {
    python = python3;
    inherit (qt5) qmake qttools qtwebengine qtxmlpatterns;
  };

  pyotherside = libsForQt5.callPackage ../development/libraries/pyotherside {};

  qbs = libsForQt5.callPackage ../development/tools/build-managers/qbs { };

  qolibri = libsForQt5.callPackage ../applications/misc/qolibri { };

  qt4 = qt48;

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    inherit (gnome2) libgnomeui GConf gnome_vfs;
    cups = if stdenv.isLinux then cups else null;

    # XXX: mariadb doesn't built on fbsd as of nov 2015
    libmysqlclient = if (!stdenv.isFreeBSD) then libmysqlclient else null;

    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices OpenGL Cocoa AGL;
  };

  qmake48Hook = makeSetupHook
    { substitutions = { qt4 = qt48; }; }
    ../development/libraries/qt-4.x/4.8/qmake-hook.sh;

  qmake4Hook = qmake48Hook;

  qt48Full = qt48.override {
    docs = true;
    demos = true;
    examples = true;
    developerBuild = true;
  };

  qt5 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.15) {
      inherit newScope;
      inherit lib fetchurl fetchpatch fetchgit fetchFromGitHub makeSetupHook makeWrapper;
      inherit bison cups dconf harfbuzz libGL perl gtk3 python3;
      inherit (gst_all_1) gstreamer gst-plugins-base;
      inherit darwin;
      inherit buildPackages;
      stdenv = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
    });

  libsForQt5 = recurseIntoAttrs (import ./qt5-packages.nix {
    inherit lib pkgs qt5;
  });

  # TODO: remove once no package needs this anymore or together with OpenSSL 1.1
  # Current users: mumble, murmur
  qt5_openssl_1_1 = qt5.overrideScope' (_: super: {
    qtbase = super.qtbase.override {
      openssl = openssl_1_1;
      libmysqlclient = libmysqlclient.override {
        openssl = openssl_1_1;
        curl = curl.override { openssl = openssl_1_1; };
      };
    };
  });

  # plasma5Packages maps to the Qt5 packages set that is used to build the plasma5 desktop
  plasma5Packages = libsForQt5;

  qtEnv = qt5.env;
  qt5Full = qt5.full;

  qt6 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-6) {
      inherit newScope;
      inherit lib fetchurl fetchpatch fetchgit fetchFromGitHub makeSetupHook makeWrapper writeText;
      inherit bison cups dconf harfbuzz libGL perl gtk3 ninja;
      inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi;
      inherit darwin buildPackages libglvnd;
      stdenv = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
      cmake = cmake.overrideAttrs (attrs: {
        patches = attrs.patches ++ [
          ../development/libraries/qt-6/patches/cmake.patch
        ];
      });
    });

  qt6Packages = recurseIntoAttrs (import ./qt6-packages.nix {
    inherit lib pkgs qt6;
  });

  quill = callPackage ../tools/security/quill {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  qv2ray = libsForQt5.callPackage ../applications/networking/qv2ray {};

  qwt6_qt4 = callPackage ../development/libraries/qwt/6_qt4.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  rabbitmq-java-client = callPackage ../development/libraries/rabbitmq-java-client {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  readline = readline82;

  readline63 = callPackage ../development/libraries/readline/6.3.nix { };

  readline70 = callPackage ../development/libraries/readline/7.0.nix { };

  readline82 = callPackage ../development/libraries/readline/8.2.nix { };

  kissfftFloat = kissfft.override {
    datatype = "float";
  };

  lambdabot = callPackage ../development/tools/haskell/lambdabot {
    haskellLib = haskell.lib.compose;
  };

  redland = librdf_redland; # added 2018-04-25

  qgnomeplatform = libsForQt5.callPackage ../development/libraries/qgnomeplatform { };

  qgnomeplatform-qt6 = qt6Packages.callPackage ../development/libraries/qgnomeplatform {
    useQt6 = true;
  };

  randomx = darwin.apple_sdk_11_0.callPackage ../development/libraries/randomx { };

  remodel = callPackage ../development/tools/remodel {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rhino = callPackage ../development/libraries/java/rhino {
    javac = jdk8;
    jvm = jre8;
  };

  rocksdb_lite = rocksdb.override { enableLite = true; };

  rocksdb_6_23 = rocksdb.overrideAttrs (_: rec {
    pname = "rocksdb";
    version = "6.23.3";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = pname;
      rev = "v${version}";
     sha256 = "sha256-SsDqhjdCdtIGNlsMj5kfiuS3zSGwcxi4KV71d95h7yk=";
   };
  });

  rshell = python3.pkgs.callPackage ../development/embedded/rshell { };

  /*  This package references ghc844, which we no longer have. Unfortunately, I
      have been unable to mark it as "broken" in a way that the ofBorg bot
      recognizes. Since I don't want to merge code into master that generates
      evaluation errors, I have no other idea but to comment it out entirely.

  sad = callPackage ../applications/science/logic/sad { };
  */

  schroedinger = callPackage ../development/libraries/schroedinger {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  SDL_classic = callPackage ../development/libraries/SDL ({
    inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa GLUT;
  } // lib.optionalAttrs stdenv.hostPlatform.isAndroid {
    # libGLU doesn’t work with Android’s SDL
    libGLU = null;
  });

  SDL_compat = callPackage ../development/libraries/SDL_compat {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  SDL = SDL_classic;

  SDL2 = callPackage ../development/libraries/SDL2 {
    inherit (darwin.apple_sdk.frameworks) AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL;
  };

  SDL2_image = callPackage ../development/libraries/SDL2_image {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  SDL2_mixer = callPackage ../development/libraries/SDL2_mixer {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };

  SDL2_sound = callPackage ../development/libraries/SDL2_sound {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox CoreAudio;
  };

  sdrpp = callPackage ../applications/radio/sdrpp {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  sigdigger = libsForQt5.callPackage ../applications/radio/sigdigger { };

  serf = callPackage ../development/libraries/serf {
    openssl = openssl_1_1;
    aprutil = aprutil.override { openssl = openssl_1_1; };
  };

  simavr = callPackage ../development/tools/simavr {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrlibc = pkgsCross.avr.libcCross;
    inherit (darwin.apple_sdk.frameworks) GLUT;
  };

  simpleitk = callPackage ../development/libraries/simpleitk { lua = lua5_3; };

  sfml = callPackage ../development/libraries/sfml {
    inherit (darwin.apple_sdk.frameworks) IOKit Foundation AppKit OpenAL;
  };

  skawarePackages = recurseIntoAttrs (callPackage ../development/skaware-packages { });

  inherit (skawarePackages)
    execline
    execline-man-pages
    mdevd
    nsss
    s6
    s6-dns
    s6-linux-init
    s6-linux-utils
    s6-man-pages
    s6-networking
    s6-networking-man-pages
    s6-portable-utils
    s6-portable-utils-man-pages
    s6-rc
    sdnotify-wrapper
    skalibs
    skalibs_2_10
    utmps;

  kgt = callPackage ../development/tools/kgt {
    inherit (skawarePackages) cleanPackaging;
  };

  nettee = callPackage ../tools/networking/nettee {
    inherit (skawarePackages) cleanPackaging;
  };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
    texinfo = texinfo4; # otherwise erros: must be after `@defun' to use `@defunx'
  };

  soapyairspy = callPackage ../applications/radio/soapyairspy {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
  };

  soapyaudio = callPackage ../applications/radio/soapyaudio {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreAudio;
  };

  soapybladerf = callPackage ../applications/radio/soapybladerf {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
  };

  soapyhackrf = callPackage ../applications/radio/soapyhackrf {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
  };

  soapysdr = callPackage ../applications/radio/soapysdr { };

  soapysdr-with-plugins = callPackage ../applications/radio/soapysdr {
    extraPackages = [
      limesuite
      soapyairspy
      soapyaudio
      soapybladerf
      soapyhackrf
      soapyremote
      soapyrtlsdr
      soapyuhd
    ];
  };

  soapyrtlsdr = callPackage ../applications/radio/soapyrtlsdr {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
  };

  soapyuhd = callPackage ../applications/radio/soapyuhd {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit Security;
  };

  sofia_sip = callPackage ../development/libraries/sofia-sip {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

  soil = callPackage ../development/libraries/soil {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  speex = callPackage ../development/libraries/speex {
    fftw = fftwFloat;
  };

  speexdsp = callPackage ../development/libraries/speexdsp {
    fftw = fftwFloat;
  };

  sphinx = with python3Packages; toPythonApplication sphinx;

  sphinx-autobuild = with python3Packages; toPythonApplication sphinx-autobuild;

  sphinx-serve = with python3Packages; toPythonApplication sphinx-serve;

  inherit (python3Packages) sphinxHook;

  spice-gtk_libsoup2 = spice-gtk.override { withLibsoup2 = true; };

  suwidgets = libsForQt5.callPackage ../applications/radio/suwidgets { };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite { });

  unqlite = lowPrio (callPackage ../development/libraries/unqlite { });

  inherit (callPackage ../development/libraries/sqlite/tools.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  }) sqlite-analyzer sqldiff;

  sqlite-interactive = (sqlite.override { interactive = true; }).bin;

  stlink = callPackage ../development/tools/misc/stlink { };
  stlink-gui = callPackage ../development/tools/misc/stlink { withGUI = true; };

  sundials = callPackage ../development/libraries/sundials {
    python = python3;
  };

  svxlink = libsForQt5.callPackage ../applications/radio/svxlink { };

  swiftclient = with python3Packages; toPythonApplication python-swiftclient;

  tachyon = callPackage ../development/libraries/tachyon {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  tageditor = libsForQt5.callPackage ../applications/audio/tageditor { };

  tectonic = callPackage ../tools/typesetting/tectonic {
    harfbuzz = harfbuzzFull;
  };

  thrift = callPackage ../development/libraries/thrift {
    openssl = openssl_1_1;
  };

  tinyxml = tinyxml2;

  tk = tk-8_6;

  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tpm2-tss = callPackage ../development/libraries/tpm2-tss {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  unixODBCDrivers = recurseIntoAttrs (callPackages ../development/libraries/unixODBCDrivers { });

  v8 = darwin.apple_sdk_11_0.callPackage ../development/libraries/v8 { };

  v8_8_x = callPackage ../development/libraries/v8/8_x.nix { };

  valhalla = callPackage ../development/libraries/valhalla {
    boost = boost.override { enablePython = true; python = python38; };
  };

  vid-stab = callPackage ../development/libraries/vid-stab {
    inherit (llvmPackages) openmp;
  };

  vigra = callPackage ../development/libraries/vigra {
    hdf5 = hdf5.override { usev110Api = true; };
  };

  vte = callPackage ../development/libraries/vte {
    # Needs GCC ≥10 but aarch64 defaults to GCC 9.
    stdenv = clangStdenv;
  };

  vte-gtk4 = vte.override {
    gtkVersion = "4";
  };

  vtk_8 = libsForQt5.callPackage ../development/libraries/vtk/8.x.nix {
    stdenv = gcc9Stdenv;
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
                                          IOKit CFNetwork Security ApplicationServices
                                          CoreText IOSurface ImageIO OpenGL GLUT;
  };

  vtk_8_withQt5 = vtk_8.override { enableQt = true; };

  vtk_9 = libsForQt5.callPackage ../development/libraries/vtk/9.x.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
                                          IOKit CFNetwork Security ApplicationServices
                                          CoreText IOSurface ImageIO OpenGL GLUT;
  };

  vtk_9_withQt5 = vtk_9.override { enableQt = true; };

  vtk = vtk_8;
  vtkWithQt5 = vtk_8_withQt5;

  vulkan-caps-viewer = libsForQt5.callPackage ../tools/graphics/vulkan-caps-viewer { };

  vulkan-loader = callPackage ../development/libraries/vulkan-loader { inherit (darwin) moltenvk; };
  vulkan-tools = callPackage ../tools/graphics/vulkan-tools {
    inherit (darwin) moltenvk;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  wayland-scanner = wayland.bin;

  waylandpp = callPackage ../development/libraries/waylandpp {
    graphviz = graphviz-nox;
  };

  webkitgtk = callPackage ../development/libraries/webkitgtk {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    inherit (darwin) apple_sdk;
  };

  webkitgtk_4_1 = webkitgtk.override {
    libsoup = libsoup_3;
  };

  webkitgtk_5_0 = webkitgtk.override {
    libsoup = libsoup_3;
    gtk3 = gtk4;
  };

  webrtc-audio-processing_1 = callPackage ../development/libraries/webrtc-audio-processing { stdenv = gcc10StdenvCompat; };
  # bump when majoring of packages have updated
  webrtc-audio-processing = webrtc-audio-processing_0_3;

  wt = wt4;
  inherit (callPackages ../development/libraries/wt {
    boost = boost175;
  })
    wt3
    wt4;

  wxformbuilder = callPackage ../development/tools/wxformbuilder {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  wxGTK30 = callPackage ../development/libraries/wxwidgets/wxGTK30.nix {
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit AVFoundation AVKit WebKit;
  };

  wxmac = callPackage ../development/libraries/wxwidgets/wxmac30.nix {
    inherit (darwin.stubs) derez rez setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa Kernel WebKit;
  };

  wxGTK31 = callPackage ../development/libraries/wxwidgets/wxGTK31.nix {
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit AVFoundation AVKit WebKit;
  };

  wxGTK32 = callPackage ../development/libraries/wxwidgets/wxGTK32.nix {
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit AVFoundation AVKit WebKit;
  };

  wxSVG = callPackage ../development/libraries/wxSVG {
    wxGTK = wxGTK32;
  };

  inherit (callPackages ../development/libraries/xapian { })
    xapian_1_4;
  xapian = xapian_1_4;

  xapian-omega = callPackage ../development/libraries/xapian/tools/omega {
    libmagic = file;
  };

  xcb-util-cursor = xorg.xcbutilcursor;

  xgboostWithCuda = xgboost.override { cudaSupport = true; };

  yubico-piv-tool = callPackage ../tools/misc/yubico-piv-tool {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };

  yubikey-manager-qt = libsForQt5.callPackage ../tools/misc/yubikey-manager-qt { };

  yubikey-personalization-gui = libsForQt5.callPackage ../tools/misc/yubikey-personalization-gui { };

  libdynd = callPackage ../development/libraries/libdynd { stdenv = gcc10StdenvCompat; };

  zeromq = zeromq4;

  # requires a newer Apple SDK
  zig = darwin.apple_sdk_11_0.callPackage ../development/compilers/zig {
    llvmPackages = llvmPackages_13;
  };

  gsignond = callPackage ../development/libraries/gsignond {
    plugins = [];
  };

  gsignondPlugins = recurseIntoAttrs {
    sasl = callPackage ../development/libraries/gsignond/plugins/sasl.nix { };
    oauth = callPackage ../development/libraries/gsignond/plugins/oauth.nix { };
    lastfm = callPackage ../development/libraries/gsignond/plugins/lastfm.nix { };
    mail = callPackage ../development/libraries/gsignond/plugins/mail.nix { };
  };

  ### DEVELOPMENT / LIBRARIES / AGDA

  agdaPackages = callPackage ./agda-packages.nix {
    inherit (haskellPackages) Agda;
  };
  agda = agdaPackages.agda;

  ### DEVELOPMENT / LIBRARIES / BASH

  ### DEVELOPMENT / LIBRARIES / JAVA

  javaCup = callPackage ../development/libraries/java/cup {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  saxonb = saxonb_8_8;

  inherit (callPackages ../development/libraries/java/saxon {
    jre = jre_headless;
    jre8 = jre8_headless;
  })
    saxon
    saxonb_8_8
    saxonb_9_1
    saxon-he;

  swt = callPackage ../development/libraries/java/swt { };
  swt_jdk8 = callPackage ../development/libraries/java/swt {
    jdk = jdk8;
  };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  ### DEVELOPMENT / GO

  # the unversioned attributes should always point to the same go version
  go = go_1_19;
  buildGoModule = buildGo119Module;
  buildGoPackage = buildGo119Package;

  # requires a newer Apple SDK
  go_1_18 = darwin.apple_sdk_11_0.callPackage ../development/compilers/go/1.18.nix {
    inherit (darwin.apple_sdk_11_0.frameworks) Foundation Security;
  };
  buildGo118Module = darwin.apple_sdk_11_0.callPackage ../build-support/go/module.nix {
    go = buildPackages.go_1_18;
  };
  buildGo118Package = darwin.apple_sdk_11_0.callPackage ../build-support/go/package.nix{
    go = buildPackages.go_1_18;
  };

  # requires a newer Apple SDK
  go_1_19 = darwin.apple_sdk_11_0.callPackage ../development/compilers/go/1.19.nix {
    inherit (darwin.apple_sdk_11_0.frameworks) Foundation Security;
  };
  buildGo119Module = darwin.apple_sdk_11_0.callPackage ../build-support/go/module.nix {
    go = buildPackages.go_1_19;
  };
  buildGo119Package = darwin.apple_sdk_11_0.callPackage ../build-support/go/package.nix {
    go = buildPackages.go_1_19;
  };

  # requires a newer Apple SDK
  go_1_20 = darwin.apple_sdk_11_0.callPackage ../development/compilers/go/1.20.nix {
    inherit (darwin.apple_sdk_11_0.frameworks) Foundation Security;
  };
  buildGo120Module = darwin.apple_sdk_11_0.callPackage ../build-support/go/module.nix {
    go = buildPackages.go_1_20;
  };
  buildGo120Package = darwin.apple_sdk_11_0.callPackage ../build-support/go/package.nix {
    go = buildPackages.go_1_20;
  };

  ### DEVELOPMENT / JAVA MODULES

  javaPackages = recurseIntoAttrs (callPackage ./java-packages.nix { });

  ### DEVELOPMENT / LISP MODULES

  asdf = callPackage ../development/lisp-modules/asdf {
    texLive = null;
  };

  # QuickLisp minimal version
  asdf_2_26 = callPackage ../development/lisp-modules/asdf/2.26.nix {
    texLive = null;
  };
  # Currently most popular
  asdf_3_1 = callPackage ../development/lisp-modules/asdf/3.1.nix {
    texLive = null;
  };

  clwrapperFunction = callPackage ../development/lisp-modules/clwrapper;

  wrapLisp = lisp: clwrapperFunction { inherit lisp; };

  lispPackagesFor = clwrapper: callPackage ../development/lisp-modules/lisp-packages.nix {
    inherit clwrapper;
  };

  lispPackages = recurseIntoAttrs (quicklispPackages //
    (lispPackagesFor (wrapLisp sbcl)));

  quicklispPackagesFor = clwrapper: callPackage ../development/lisp-modules/quicklisp-to-nix.nix {
    inherit clwrapper;
  };
  quicklispPackagesClisp = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp clisp));
  quicklispPackagesSBCL = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp sbcl));
  quicklispPackagesECL = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp ecl));
  quicklispPackagesCCL = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp ccl));
  quicklispPackagesABCL = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp abcl));
  quicklispPackagesGCL = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp gcl));
  quicklispPackages = quicklispPackagesSBCL;

  # Alternative lisp-modules implementation
  lispPackages_new = recurseIntoAttrs (callPackage ../development/lisp-modules-new/lisp-packages.nix {});


  ### DEVELOPMENT / PERL MODULES

  perlInterpreters = callPackages ../development/interpreters/perl {};
  inherit (perlInterpreters) perl534 perl536 perldevel;

  perl534Packages = recurseIntoAttrs perl534.pkgs;
  perl536Packages = recurseIntoAttrs perl536.pkgs;
  perldevelPackages = perldevel.pkgs;

  perl = perl536;
  perlPackages = perl536Packages;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;

  sqitchMysql = (callPackage ../development/tools/misc/sqitch {
    mysqlSupport = true;
  }).overrideAttrs (_: { pname = "sqitch-mysql"; });

  sqitchPg = (callPackage ../development/tools/misc/sqitch {
    postgresqlSupport = true;
  }).overrideAttrs (_: { pname = "sqitch-pg"; });

  ### DEVELOPMENT / R MODULES

  R = callPackage ../applications/science/math/R {
    # TODO: split docs into a separate output
    texLive = texlive.combine {
      inherit (texlive) scheme-small inconsolata helvetic texinfo fancyvrb cm-super rsfs;
    };
    withRecommendedPackages = false;
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
    inherit (darwin) libobjc;
  };

  rWrapper = callPackage ../development/r-modules/wrapper.nix {
    recommendedPackages = with rPackages; [
      boot class cluster codetools foreign KernSmooth lattice MASS
      Matrix mgcv nlme nnet rpart spatial survival
    ];
    # Override this attribute to register additional libraries.
    packages = [];
  };

  rstudioWrapper = libsForQt5.callPackage ../development/r-modules/wrapper-rstudio.nix {
    recommendedPackages = with rPackages; [
      boot class cluster codetools foreign KernSmooth lattice MASS
      Matrix mgcv nlme nnet rpart spatial survival
    ];
    # Override this attribute to register additional libraries.
    packages = [];
  };

  rstudioServerWrapper = rstudioWrapper.override { rstudio = rstudio-server; };

  rPackages = dontRecurseIntoAttrs (callPackage ../development/r-modules {
    overrides = (config.rPackageOverrides or (_: {})) pkgs;
  });

  ### SERVERS

  apacheHttpd = apacheHttpd_2_4;

  apacheHttpdPackagesFor = apacheHttpd: self: let callPackage = newScope self; in {
    inherit apacheHttpd;

    mod_auth_mellon = callPackage ../servers/http/apache-modules/mod_auth_mellon { };

    # Redwax collection
    mod_ca = callPackage ../servers/http/apache-modules/mod_ca { };
    mod_crl = callPackage ../servers/http/apache-modules/mod_crl { };
    mod_csr = callPackage ../servers/http/apache-modules/mod_csr { };
    mod_cspnonce = callPackage ../servers/http/apache-modules/mod_cspnonce { };
    mod_ocsp = callPackage ../servers/http/apache-modules/mod_ocsp{ };
    mod_scep = callPackage ../servers/http/apache-modules/mod_scep { };
    mod_pkcs12 = callPackage ../servers/http/apache-modules/mod_pkcs12 { };
    mod_spkac= callPackage ../servers/http/apache-modules/mod_spkac { };
    mod_timestamp = callPackage ../servers/http/apache-modules/mod_timestamp { };

    mod_dnssd = callPackage ../servers/http/apache-modules/mod_dnssd { };

    mod_evasive = throw "mod_evasive is not supported on Apache httpd 2.4";

    mod_perl = callPackage ../servers/http/apache-modules/mod_perl { };

    mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

    mod_python = callPackage ../servers/http/apache-modules/mod_python { };

    mod_tile = callPackage ../servers/http/apache-modules/mod_tile { };

    mod_wsgi  = self.mod_wsgi2;
    mod_wsgi2 = throw "mod_wsgi2 has been removed since Python 2 is EOL. Use mod_wsgi3 instead";
    mod_wsgi3 = callPackage ../servers/http/apache-modules/mod_wsgi { };

    mod_itk = callPackage ../servers/http/apache-modules/mod_itk { };

    mod_mbtiles = callPackage ../servers/http/apache-modules/mod_mbtiles { };

    php = pkgs.php.override { inherit apacheHttpd; };

    subversion = pkgs.subversion.override { httpServer = true; inherit apacheHttpd; };
  };

  apacheHttpdPackages_2_4 = recurseIntoAttrs (apacheHttpdPackagesFor apacheHttpd_2_4 apacheHttpdPackages_2_4);
  apacheHttpdPackages = apacheHttpdPackages_2_4;

  archiveopteryx = callPackage ../servers/mail/archiveopteryx {
    openssl = openssl_1_1;
  };

  cassandra_3_0 = callPackage ../servers/nosql/cassandra/3.0.nix {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  cassandra_3_11 = callPackage ../servers/nosql/cassandra/3.11.nix {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  cassandra_4 = callPackage ../servers/nosql/cassandra/4.nix {
    # Effective Cassandra 4.0.2 there is full Java 11 support
    #  -- https://cassandra.apache.org/doc/latest/cassandra/new/java11.html
    jre = pkgs.jdk11_headless;
  };
  cassandra = cassandra_3_11;

  apache-jena = callPackage ../servers/nosql/apache-jena/binary.nix {
    java = jre;
  };

  apache-jena-fuseki = callPackage ../servers/nosql/apache-jena/fuseki-binary.nix {
    java = jre;
  };

  inherit (callPackages ../servers/asterisk { })
    asterisk asterisk-stable asterisk-lts
    asterisk_16 asterisk_18 asterisk_19 asterisk_20;

  dnsutils = bind.dnsutils;
  dig = bind.dnsutils;

  charybdis = callPackage ../servers/irc/charybdis {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  clickhouse = callPackage ../servers/clickhouse {
    # upstream requires llvm12 as of v22.3.2.2
    inherit (llvmPackages_14) clang-unwrapped lld llvm;
    llvm-bintools = llvmPackages_14.bintools;
    stdenv = llvmPackages_14.stdenv;
  };

  clickhouse-cli = with python3Packages; toPythonApplication clickhouse-cli;

  dcnnt = python3Packages.callPackage ../servers/dcnnt { };

  doh-proxy-rust = callPackage ../servers/dns/doh-proxy-rust {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  dict = callPackage ../servers/dict {
    libmaa = callPackage ../servers/dict/libmaa.nix {};
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix {});

  diod = callPackage ../servers/diod { lua = lua5_1; };

  dmlive = callPackage ../applications/video/dmlive {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  dodgy = with python3Packages; toPythonApplication dodgy;

  engelsystem = callPackage ../servers/web-apps/engelsystem { php = php81; };

  envoy = callPackage ../servers/http/envoy {
    jdk = openjdk11_headless;
    gn = gn1924;
  };

  etcd = etcd_3_3;

  ejabberd = callPackage ../servers/xmpp/ejabberd { erlang = erlangR24; };

  prosody = callPackage ../servers/xmpp/prosody {
    withExtraLibs = [];
    withExtraLuaPackages = _: [];
  };

  elasticmq-server-bin = callPackage ../servers/elasticmq-server-bin {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  fedigroups = callPackage ../servers/fedigroups {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../servers/firebird { }) firebird_4 firebird_3 firebird_2_5 firebird;

  freeradius = callPackage ../servers/freeradius {
    openssl = openssl_1_1;
  };

  freeswitch = callPackage ../servers/sip/freeswitch {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
    openssl = openssl_1_1;
  };

  grafanaPlugins = callPackages ../servers/monitoring/grafana/plugins { };

  hasura-graphql-engine = haskell.lib.compose.justStaticExecutables haskell.packages.ghc810.graphql-engine;

  inherit (callPackage ../servers/hbase {}) hbase_2_4 hbase_2_5 hbase_3_0;
  hbase2 = hbase_2_5;
  hbase3 = hbase_3_0;
  hbase = hbase2; # when updating, point to the latest stable release

  hoard = callPackage ../tools/misc/hoard { inherit (darwin) Security; };

  home-assistant-component-tests = recurseIntoAttrs home-assistant.tests.components;

  hyprspace = callPackage ../applications/networking/hyprspace {
    inherit (darwin) iproute2mac;
  };

  icingaweb2Modules = {
    theme-april = callPackage ../servers/icingaweb2/theme-april { };
    theme-lsd = callPackage ../servers/icingaweb2/theme-lsd { };
    theme-particles = callPackage ../servers/icingaweb2/theme-particles { };
    theme-snow = callPackage ../servers/icingaweb2/theme-snow { };
    theme-spring = callPackage ../servers/icingaweb2/theme-spring { };
  };

  inspircdMinimal = inspircd.override { extraModules = []; };

  knot-resolver = callPackage ../servers/dns/knot-resolver {
    systemd = systemdMinimal; # in closure already anyway
  };

  lemmy-server = callPackage ../servers/web-apps/lemmy/server.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  lemmy-ui = callPackage ../servers/web-apps/lemmy/ui.nix {
    nodejs = nodejs-14_x;
  };

  inherit (mailmanPackages) mailman mailman-hyperkitty;
  mailman-web = mailmanPackages.web;

  materialize = callPackage ../servers/sql/materialize {
    inherit (buildPackages.darwin) bootstrap_cmds;
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
  };

  # Keep around to allow people to migrate their data from the old legacy fs format
  # https://github.com/minio/minio/releases/tag/RELEASE.2022-10-29T06-21-33Z

  mkchromecast = libsForQt5.callPackage ../applications/networking/mkchromecast { };

  # Backwards compatibility.
  mod_dnssd = apacheHttpdPackages.mod_dnssd;
  mod_fastcgi = apacheHttpdPackages.mod_fastcgi;
  mod_python = apacheHttpdPackages.mod_python;
  mod_wsgi = apacheHttpdPackages.mod_wsgi;
  mod_ca = apacheHttpdPackages.mod_ca;
  mod_crl = apacheHttpdPackages.mod_crl;
  mod_csr = apacheHttpdPackages.mod_csr;
  mod_ocsp = apacheHttpdPackages.mod_ocsp;
  mod_scep = apacheHttpdPackages.mod_scep;
  mod_spkac = apacheHttpdPackages.mod_spkac;
  mod_pkcs12 = apacheHttpdPackages.mod_pkcs12;
  mod_timestamp = apacheHttpdPackages.mod_timestamp;

  inherit (callPackages ../servers/mpd {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AudioUnit;
  }) mpd mpd-small mpdWithFeatures;

  mtprotoproxy = python3.pkgs.callPackage ../servers/mtprotoproxy { };

  inherit (callPackage ../applications/networking/mullvad { })
    mullvad;

  napalm = with python3Packages; toPythonApplication (
    napalm.overridePythonAttrs (attrs: {
      # add community frontends that depend on the napalm python package
      propagatedBuildInputs = attrs.propagatedBuildInputs ++ [
        napalm-hp-procurve
      ];
    })
  );

  nginx = nginxStable;

  nginxQuic = callPackage ../servers/http/nginx/quic.nix {
    zlib = zlib-ng.override { withZlibCompat = true; };
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
    # Use latest boringssl to allow http3 support
    openssl = quictls;
  };

  nginxStable = callPackage ../servers/http/nginx/stable.nix {
    zlib = zlib-ng.override { withZlibCompat = true; };
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxMainline = callPackage ../servers/http/nginx/mainline.nix {
    zlib = zlib-ng.override { withZlibCompat = true; };
    withKTLS = true;
    withPerl = false;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474#discussion_r42369334
    modules = [ nginxModules.dav nginxModules.moreheaders ];
  };

  nginxModules = recurseIntoAttrs (callPackage ../servers/http/nginx/modules.nix { });

  # We should move to dynmaic modules and create a nginxFull package with all modules
  nginxShibboleth = nginxStable.override {
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders nginxModules.shibboleth ];
  };

  libmodsecurity = callPackage ../tools/security/libmodsecurity {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  nsd = callPackage ../servers/dns/nsd (config.nsd or {});

  outline = callPackage ../servers/web-apps/outline (lib.fix (super: {
    yarn2nix-moretea = yarn2nix-moretea.override { inherit (super) nodejs yarn; };
    yarn = yarn.override { inherit (super) nodejs; };
    nodejs = nodejs-16_x;
  }));

  openafs = callPackage ../servers/openafs/1.8 { };

  openresty = callPackage ../servers/http/openresty {
    withPerl = false;
    modules = [];
  };

  pict-rs = callPackage ../servers/web-apps/pict-rs {
    inherit (darwin.apple_sdk.frameworks) Security;
    ffmpeg = ffmpeg_4;
  };

  pfixtools = callPackage ../servers/mail/postfix/pfixtools.nix {
    gperf = gperf_3_0;
  };

  system-sendmail = lowPrio (callPackage ../servers/mail/system-sendmail { });

  # PulseAudio daemons

  pulseaudio = callPackage ../servers/pulseaudio {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa CoreAudio;
  };

  qpaeq = libsForQt5.callPackage ../servers/pulseaudio/qpaeq.nix { };

  pulseaudioFull = pulseaudio.override {
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    bluetoothSupport = true;
    advancedBluetoothCodecs = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  libpulseaudio = pulseaudio.override {
    libOnly = true;
  };

  pulseeffects-legacy = callPackage ../applications/audio/pulseeffects-legacy {
    boost = boost172;
  };

  soundux = callPackage ../applications/audio/soundux {
    yt-dlp = yt-dlp.override { withAlias = true; };
  };

  libmysqlclient = libmysqlclient_3_2;
  libmysqlclient_3_1 = mariadb-connector-c_3_1;
  libmysqlclient_3_2 = mariadb-connector-c_3_2;
  mariadb-connector-c = mariadb-connector-c_3_2;
  mariadb-connector-c_3_1 = callPackage ../servers/sql/mariadb/connector-c/3_1.nix { };
  mariadb-connector-c_3_2 = callPackage ../servers/sql/mariadb/connector-c/3_2.nix { };

  inherit (import ../servers/sql/mariadb pkgs)
    mariadb_104
    mariadb_105
    mariadb_106
    mariadb_108
    mariadb_109
  ;
  mariadb = mariadb_106;
  mariadb-embedded = mariadb.override { withEmbedded = true; };

  mongodb = hiPrio mongodb-6_0;

  mongodb-4_2 = callPackage ../servers/nosql/mongodb/v4_2.nix {
    sasl = cyrus_sasl;
    boost = boost169;
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  mongodb-4_4 = callPackage ../servers/nosql/mongodb/4.4.nix {
    sasl = cyrus_sasl;
    boost = boost17x.override { enableShared = false; };
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  mongodb-5_0 = callPackage ../servers/nosql/mongodb/5.0.nix {
    sasl = cyrus_sasl;
    boost = boost17x.override { enableShared = false; };
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  mongodb-6_0 = darwin.apple_sdk_11_0.callPackage ../servers/nosql/mongodb/6.0.nix {
    sasl = cyrus_sasl;
    boost = boost178.override { enableShared = false; };
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
    stdenv = if stdenv.isDarwin then
      darwin.apple_sdk_11_0.stdenv.override (old: {
        hostPlatform = old.hostPlatform // { darwinMinVersion = "10.14"; };
        buildPlatform = old.buildPlatform // { darwinMinVersion = "10.14"; };
        targetPlatform = old.targetPlatform // { darwinMinVersion = "10.14"; };
      }) else
      if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
  };

  # For backwards compatibility with older versions of influxdb2,
  # which bundled the server and CLI into the same derivation. Will be
  # removed in a few releases.

  mysql80 = callPackage ../servers/sql/mysql/8.0.x.nix {
    inherit (darwin) cctools developer_cmds DarwinTools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    boost = boost177; # Configure checks for specific version.
    protobuf = protobuf3_19;
    icu = icu69;
    openssl = openssl_1_1;
  };

  icinga2 = callPackage ../servers/monitoring/icinga2 { };

  icinga2-agent = callPackage ../servers/monitoring/icinga2 {
    nameSuffix = "-agent";
    withMysql = false;
    withNotification = false;
    withIcingadb = false;
  };

  inherit (callPackage ../servers/monitoring/plugins/labs_consol_de.nix { })
    check-mssql-health
    check-nwc-health
    check-ups-health;

  qboot = pkgsi686Linux.callPackage ../applications/virtualization/qboot { };

  OVMF = callPackage ../applications/virtualization/OVMF { };
  OVMFFull = callPackage ../applications/virtualization/OVMF {
    secureBoot = true;
    csmSupport = true;
    httpSupport = true;
    tpmSupport = true;
  };

  patroni = callPackage ../servers/sql/patroni { pythonPackages = python3Packages; };

  tang = callPackage ../servers/tang {
    asciidoc = asciidoc-full;
  };

  inherit (import ../servers/sql/postgresql pkgs)
    postgresql_11
    postgresql_12
    postgresql_13
    postgresql_14
    postgresql_15
  ;
  postgresql = postgresql_14.override { this = postgresql; };
  postgresqlPackages = recurseIntoAttrs postgresql.pkgs;
  postgresql11Packages = recurseIntoAttrs postgresql_11.pkgs;
  postgresql12Packages = recurseIntoAttrs postgresql_12.pkgs;
  postgresql13Packages = recurseIntoAttrs postgresql_13.pkgs;
  postgresql15Packages = recurseIntoAttrs postgresql_15.pkgs;
  postgresql14Packages = postgresqlPackages;

  prometheus-node-exporter = callPackage ../servers/monitoring/prometheus/node-exporter.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;
  };
  prometheus-openldap-exporter = callPackage ../servers/monitoring/prometheus/openldap-exporter.nix {
    buildGoModule = buildGo118Module; # nixosTests.prometheus-exporter.ldap fails with 1.19
  };
  prometheus-unbound-exporter = callPackage ../servers/monitoring/prometheus/unbound-exporter.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  prometheus-wireguard-exporter = callPackage ../servers/monitoring/prometheus/wireguard-exporter.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  public-inbox = perlPackages.callPackage ../servers/mail/public-inbox { };

  spf-engine = python3.pkgs.callPackage ../servers/mail/spf-engine { };

  pypiserver = with python3Packages; toPythonApplication pypiserver;

  qremotecontrol-server = libsForQt5.callPackage ../servers/misc/qremotecontrol-server { };

  rabbitmq-server = callPackage ../servers/amqp/rabbitmq-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon Cocoa;
    elixir = elixir_1_14;
  };

  radicale = radicale3;

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    stdenv = clangStdenv;
    libtool = darwin.cctools;
  };

  # Fails to compile with boost <= 1.72
  rippled = callPackage ../servers/rippled {
    boost = boost172;
  };

  rustic-rs = callPackage ../tools/backup/rustic-rs { inherit (darwin) Security; };

  samba4 = darwin.apple_sdk_11_0.callPackage ../servers/samba/4.x.nix { };

  samba = samba4;

  samba4Full = lowPrio (samba4.override {
    enableLDAP = true;
    enablePrinting = true;
    enableMDNS = true;
    enableDomainController = true;
    enableRegedit = true;
    enableCephFS = !stdenv.hostPlatform.isAarch64;
  });

  sambaFull = samba4Full;

  shairplay = callPackage ../servers/shairplay { avahi = avahi-compat; };

  inherit (callPackages ../servers/monitoring/sensu-go { })
    sensu-go-agent
    sensu-go-backend
    sensu-go-cli;

  shishi = callPackage ../servers/shishi {
      pam = if stdenv.isLinux then pam else null;
      # see also openssl, which has/had this same trick
  };

  spacecookie =
    haskell.lib.compose.justStaticExecutables haskellPackages.spacecookie;

  surrealdb = callPackage ../servers/nosql/surrealdb {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

  inherit (callPackages ../servers/http/tomcat { })
    tomcat9
    tomcat10;

  torque = callPackage ../servers/computing/torque {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  searxng = python3Packages.toPythonModule (callPackage ../servers/web-apps/searxng { });

  inherit (callPackages ../servers/web-apps/matomo {})
    matomo
    matomo-beta;

  inherit (callPackages ../servers/unifi { })
    unifiLTS
    unifi5
    unifi6
    unifi7;

  unifi = unifi7;

  unpackerr = callPackage ../servers/unpackerr {
    inherit (darwin.apple_sdk.frameworks) Cocoa WebKit;
  };

  virtualenv = with python3Packages; toPythonApplication virtualenv;

  virtualenv-clone = with python3Packages; toPythonApplication virtualenv-clone;

  zookeeper_mt = callPackage ../development/libraries/zookeeper_mt {
    openssl = openssl_1_1;
  };

  xqilla = callPackage ../development/tools/xqilla { stdenv = gcc10StdenvCompat; };

  quartz-wm = callPackage ../servers/x11/quartz-wm {
    stdenv = clangStdenv;
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

  xorg = let
    keep = _self: { };
    extra = _spliced0: { };

    # Use `lib.callPackageWith __splicedPackages` rather than plain `callPackage`
    # so as not to have the newly bound xorg items already in scope,  which would
    # have created a cycle.
    overrides = lib.callPackageWith __splicedPackages ../servers/x11/xorg/overrides.nix {
      inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa;
      inherit (darwin.apple_sdk.libs) Xplugin;
      inherit (buildPackages.darwin) bootstrap_cmds;
      udev = if stdenv.isLinux then udev else null;
      libdrm = if stdenv.isLinux then libdrm else null;
      abiCompat = config.xorg.abiCompat # `config` because we have no `xorg.override`
        or (if stdenv.isDarwin then "1.18" else null); # 1.19 needs fixing on Darwin
    };

    generatedPackages = lib.callPackageWith __splicedPackages ../servers/x11/xorg/default.nix {};

    xorgPackages = makeScopeWithSplicing
      (generateSplicesForMkScope "xorg")
      keep
      extra
      (lib.extends overrides generatedPackages);

  in recurseIntoAttrs xorgPackages;

  zabbixFor = version: rec {
    agent = (callPackages ../servers/monitoring/zabbix/agent.nix {}).${version};
    agent2 = (callPackages ../servers/monitoring/zabbix/agent2.nix {}).${version};
    proxy-mysql = (callPackages ../servers/monitoring/zabbix/proxy.nix { mysqlSupport = true; }).${version};
    proxy-pgsql = (callPackages ../servers/monitoring/zabbix/proxy.nix { postgresqlSupport = true; }).${version};
    proxy-sqlite = (callPackages ../servers/monitoring/zabbix/proxy.nix { sqliteSupport = true; }).${version};
    server-mysql = (callPackages ../servers/monitoring/zabbix/server.nix { mysqlSupport = true; }).${version};
    server-pgsql = (callPackages ../servers/monitoring/zabbix/server.nix { postgresqlSupport = true; }).${version};
    web = (callPackages ../servers/monitoring/zabbix/web.nix {}).${version};

    # backwards compatibility
    server = server-pgsql;
  };

  zabbix50 = recurseIntoAttrs (zabbixFor "v50");
  zabbix40 = dontRecurseIntoAttrs (zabbixFor "v40");

  zabbix = zabbix50;

  ### SERVERS / GEOSPATIAL

  martin = callPackage ../servers/geospatial/martin {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  t-rex = callPackage ../servers/geospatial/t-rex {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ### OS-SPECIFIC

  alfred = callPackage ../os-specific/linux/batman-adv/alfred.nix { };

  alsa-utils = callPackage ../os-specific/linux/alsa-project/alsa-utils {
    fftw = fftwFloat;
  };

  inherit (callPackage ../misc/arm-trusted-firmware {})
    buildArmTrustedFirmware
    armTrustedFirmwareTools
    armTrustedFirmwareAllwinner
    armTrustedFirmwareAllwinnerH616
    armTrustedFirmwareQemu
    armTrustedFirmwareRK3328
    armTrustedFirmwareRK3399
    armTrustedFirmwareS905
    ;

  inherit (callPackages ../os-specific/linux/apparmor { })
    libapparmor apparmor-utils apparmor-bin-utils apparmor-parser apparmor-pam
    apparmor-profiles apparmor-kernel-patches apparmorRulesFromClosure;

  ath9k-htc-blobless-firmware = callPackage ../os-specific/linux/firmware/ath9k { };
  ath9k-htc-blobless-firmware-unstable =
    callPackage ../os-specific/linux/firmware/ath9k { enableUnstable = true; };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  bluez5 = callPackage ../os-specific/linux/bluez { };

  bluez5-experimental = callPackage ../os-specific/linux/bluez {
    withExperimental = true;
  };

  bluez = bluez5;

  inherit (python3Packages) bedup;

  busybox-sandbox-shell = callPackage ../os-specific/linux/busybox/sandbox-shell.nix {
    # musl roadmap has RISC-V support projected for 1.1.20
    busybox = if !stdenv.hostPlatform.isRiscV && stdenv.hostPlatform.libc != "bionic"
              then pkgsStatic.busybox
              else busybox;
  };

  cm-rgb = python3Packages.callPackage ../tools/system/cm-rgb { };

  conky = callPackage ../os-specific/linux/conky ({
    lua = lua5_3_compat;
    inherit (linuxPackages.nvidia_x11.settings) libXNVCtrl;
  } // config.conky or {});

  cpupower-gui = python3Packages.callPackage ../os-specific/linux/cpupower-gui {
    inherit (pkgs) meson;
  };

  cpuset = callPackage ../os-specific/linux/cpuset {
    pythonPackages = python3Packages;
  };

  # Darwin package set
  #
  # Even though this is a set of packages not single package, use `callPackage`
  # not `callPackages` so the per-package callPackages don't have their
  # `.override` clobbered. C.F. `llvmPackages` which does the same.
  darwin = callPackage ./darwin-packages.nix { };

  defaultbrowser = callPackage ../os-specific/darwin/defaultbrowser {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  displaylink = callPackage ../os-specific/linux/displaylink {
    inherit (linuxPackages) evdi;
  };

  dmraid = callPackage ../os-specific/linux/dmraid { lvm2 = lvm2_dmeventd; };

  # unstable until the first 1.x release

  firmware-manager = callPackage ../os-specific/linux/firmware/firmware-manager {
    openssl = openssl_1_1;
  };

  libuuid = if stdenv.isLinux
    then util-linuxMinimal
    else null;

  error-inject = callPackages ../os-specific/linux/error-inject { };

  ffado = libsForQt5.callPackage ../os-specific/linux/ffado {
    inherit (linuxPackages) kernel;
  };
  libffado = ffado;

  freefall = callPackage ../os-specific/linux/freefall {
    inherit (linuxPackages) kernel;
  };

  fusePackages = dontRecurseIntoAttrs (callPackage ../os-specific/linux/fuse {
    util-linux = util-linuxMinimal;
  });
  fuse = lowPrio (if stdenv.isDarwin then macfuse-stubs else fusePackages.fuse_2);
  fuse3 = fusePackages.fuse_3;
  fuse-common = hiPrio fusePackages.fuse_3.common;

  gpm = callPackage ../servers/gpm {
    withNcurses = false; # Keep curses disabled for lack of value

    # latest 6.8 mysteriously fails to parse '@headings single':
    #   https://lists.gnu.org/archive/html/bug-texinfo/2021-09/msg00011.html
    texinfo = buildPackages.texinfo6_7;
  };

  gpm-ncurses = gpm.override { withNcurses = true; };

  inherit (nodePackages) gtop;

  htop = callPackage ../tools/system/htop {
    inherit (darwin) IOKit;
  };

  humility = callPackage ../development/tools/rust/humility {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  btop = callPackage ../tools/system/btop {
    stdenv = gcc11Stdenv;
  };

  i7z = qt5.callPackage ../os-specific/linux/i7z { };

  iputils = hiPrio (callPackage ../os-specific/linux/iputils { });
  # hiPrio for collisions with inetutils (ping)

  iptables = callPackage ../os-specific/linux/iptables { };
  iptables-legacy = callPackage ../os-specific/linux/iptables { nftablesCompat = false; };
  iptables-nftables-compat = iptables;

  jfbview = callPackage ../os-specific/linux/jfbview {
    imlib2 = imlib2Full;
  };
  jfbpdf = jfbview.override {
    imageSupport = false;
  };

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  libkrun = callPackage ../development/libraries/libkrun {
    inherit (darwin.apple_sdk.frameworks) Hypervisor;
  };

  libkrun-sev = libkrun.override { sevVariant = true; };

  osx-cpu-temp = callPackage ../os-specific/darwin/osx-cpu-temp {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  macfuse-stubs = callPackage ../os-specific/darwin/macfuse {
    inherit (darwin) libtapi;
    inherit (darwin.apple_sdk.frameworks) DiskArbitration;
  };

  projecteur = libsForQt5.callPackage ../os-specific/linux/projecteur { };

  lkl = callPackage ../applications/virtualization/lkl { };
  lklWithFirewall = callPackage ../applications/virtualization/lkl { firewallSupport = true; };

  inherit (callPackages ../os-specific/linux/kernel-headers { inherit (pkgsBuildBuild) elf-header; })
    linuxHeaders makeLinuxHeaders;

  linuxHeaders_5_19 = linuxHeaders.overrideAttrs (_: rec {
    version = "5.19.16";
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
      sha256 = "13g0c6ljxk3sd0ja39ndih5vrzp2ssj78qxaf8nswn8hgrkazsx1";
    };
  });

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  linuxKernel = recurseIntoAttrs (callPackage ./linux-kernels.nix { });

  inherit (linuxKernel) buildLinux linuxConfig kernelPatches;

  linuxPackagesFor = linuxKernel.packagesFor;

  hardenedLinuxPackagesFor = linuxKernel.hardenedPackagesFor;

  linuxManualConfig = linuxKernel.manualConfig;

  linuxPackages_custom = linuxKernel.customPackage;

  # This serves as a test for linuxPackages_custom
  linuxPackages_custom_tinyconfig_kernel = let
    base = linuxPackages.kernel;
    tinyLinuxPackages = linuxKernel.customPackage {
      inherit (base) version modDirVersion src;
      allowImportFromDerivation = false;
      configfile = linuxConfig {
        makeTarget = "tinyconfig";
        src = base.src;
      };
    };
    in tinyLinuxPackages.kernel;

  # The current default kernel / kernel modules.
  linuxPackages = linuxKernel.packageAliases.linux_default;
  linux = linuxPackages.kernel;

  linuxPackages_latest = linuxKernel.packageAliases.linux_latest;
  linux_latest = linuxPackages_latest.kernel;

  # Testing (rc) kernel
  linuxPackages_testing = linuxKernel.packages.linux_testing;
  linux_testing = linuxKernel.kernels.linux_testing;

  linuxPackages_testing_bcachefs = linuxKernel.packages.linux_testing_bcachefs;
  linux_testing_bcachefs = linuxKernel.kernels.linux_testing_bcachefs;

  # Realtime kernel
  linuxPackages-rt = linuxKernel.packageAliases.linux_rt_default;
  linuxPackages-rt_latest = linuxKernel.packageAliases.linux_rt_latest;
  linux-rt = linuxPackages-rt.kernel;
  linux-rt_latest = linuxPackages-rt_latest.kernel;

  # hardened kernels
  linuxPackages_hardened = linuxKernel.packages.linux_hardened;
  linux_hardened = linuxPackages_hardened.kernel;
  linuxPackages_4_14_hardened = linuxKernel.packages.linux_4_14_hardened;
  linux_4_14_hardened = linuxPackages_4_14_hardened.kernel;
  linuxPackages_4_19_hardened = linuxKernel.packages.linux_4_19_hardened;
  linux_4_19_hardened = linuxPackages_4_19_hardened.kernel;
  linuxPackages_5_4_hardened = linuxKernel.packages.linux_5_4_hardened;
  linux_5_4_hardened = linuxKernel.kernels.linux_5_4_hardened;
  linuxPackages_5_10_hardened = linuxKernel.packages.linux_5_10_hardened;
  linux_5_10_hardened = linuxKernel.kernels.linux_5_10_hardened;
  linuxPackages_5_15_hardened = linuxKernel.packages.linux_5_15_hardened;
  linux_5_15_hardened = linuxKernel.kernels.linux_5_15_hardened;
  linuxPackages_6_1_hardened = linuxKernel.packages.linux_6_1_hardened;
  linux_6_1_hardened = linuxKernel.kernels.linux_6_1_hardened;

  # Hardkernel (Odroid) kernels.
  linuxPackages_hardkernel_latest = linuxKernel.packageAliases.linux_hardkernel_latest;
  linux_hardkernel_latest = linuxPackages_hardkernel_latest.kernel;

  # GNU Linux-libre kernels
  linuxPackages-libre = linuxKernel.packages.linux_libre;
  linux-libre = linuxPackages-libre.kernel;
  linuxPackages_latest-libre = linuxKernel.packages.linux_latest_libre;
  linux_latest-libre = linuxPackages_latest-libre.kernel;

  # zen-kernel
  linuxPackages_zen = linuxKernel.packages.linux_zen;
  linuxPackages_lqx = linuxKernel.packages.linux_lqx;

  # XanMod kernel
  linuxPackages_xanmod = linuxKernel.packages.linux_xanmod;
  linux_xanmod = linuxKernel.kernels.linux_xanmod;
  linuxPackages_xanmod_stable = linuxKernel.packages.linux_xanmod_stable;
  linux_xanmod_stable = linuxKernel.kernels.linux_xanmod_stable;
  linuxPackages_xanmod_latest = linuxKernel.packages.linux_xanmod_latest;
  linux_xanmod_latest = linuxKernel.kernels.linux_xanmod_latest;

  cryptodev = linuxKernel.packages.linux_4_9.cryptodev;

  dpdk = callPackage ../os-specific/linux/dpdk {
    kernel = null; # dpdk modules are in linuxPackages.dpdk.kmod
  };

  libsemanage = callPackage ../os-specific/linux/libsemanage {
    python = python3;
  };

  librasterlite2 = callPackage ../development/libraries/librasterlite2 {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  librealsense = callPackage ../development/libraries/librealsense { };

  librealsenseWithCuda = callPackage ../development/libraries/librealsense {
    cudaSupport = true;
    # librealsenseWithCuda doesn't build on gcc11. CUDA 11.3 is the last version
    # to use pre-gcc11, in particular gcc9.
    stdenv = gcc9Stdenv;
  };

  librealsenseWithoutCuda = callPackage ../development/libraries/librealsense {
    cudaSupport = false;
  };

  librealsense-gui = callPackage ../development/libraries/librealsense {
    enableGUI = true;
  };

  lvm2-2_03 = callPackage ../os-specific/linux/lvm2/2_03.nix {
    # udev is the same package as systemd which depends on cryptsetup
    # which depends on lvm2 again.  But we only need the libudev part
    # which does not depend on cryptsetup.
    udev = systemdMinimal;
    # break the cyclic dependency:
    # util-linux (non-minimal) depends (optionally, but on by default) on systemd,
    # systemd (optionally, but on by default) on cryptsetup and cryptsetup depends on lvm2
    util-linux = util-linuxMinimal;
  };
  lvm2-2_02 = callPackage ../os-specific/linux/lvm2/2_02.nix {
    udev = systemdMinimal;
  };
  lvm2 = if stdenv.hostPlatform.isMusl then lvm2-2_02 else lvm2-2_03;

  lvm2_dmeventd = lvm2.override {
    enableDmeventd = true;
    enableCmdlib = true;
  };
  lvm2_vdo = lvm2_dmeventd.override {
    enableVDO = true;
  };

  mdadm = mdadm4;

  aggregateModules = modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit (buildPackages) kmod;
      inherit modules;
    };

  nushell = callPackage ../shells/nushell {
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation Security;
    inherit (darwin.apple_sdk) sdk;
  };

  nettools = if stdenv.isLinux
    then callPackage ../os-specific/linux/net-tools { }
    else unixtools.nettools;

  noah = callPackage ../os-specific/darwin/noah {
    inherit (darwin.apple_sdk.frameworks) Hypervisor;
  };

  open-vm-tools-headless = open-vm-tools.override { withX = false; };

  gdlv = darwin.apple_sdk_11_0.callPackage ../development/tools/gdlv {
    inherit (darwin.apple_sdk_11_0.frameworks) OpenGL AppKit;
  };

  gotop = callPackage ../tools/system/gotop {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  odp-dpdk = callPackage ../os-specific/linux/odp-dpdk {
    openssl = openssl_1_1;
  };

  okapi = callPackage ../development/libraries/okapi {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pam = if stdenv.isLinux then linux-pam else openpam;

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pktgen = callPackage ../os-specific/linux/pktgen { stdenv = gcc10StdenvCompat; };

  procps = if stdenv.isLinux
    then callPackage ../os-specific/linux/procps-ng { }
    else unixtools.procps;

  qemu_kvm = lowPrio (qemu.override { hostCpuOnly = true; });
  qemu_full = lowPrio (qemu.override { smbdSupport = true; cephSupport = true; glusterfsSupport = true; });

  # See `xenPackages` source for explanations.
  # Building with `xen` instead of `xen-slim` is possible, but makes no sense.
  qemu_xen = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen-slim; });
  qemu_xen-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen-light; });
  qemu_xen_4_10 = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_10-slim; });
  qemu_xen_4_10-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_10-light; });

  qemu_test = lowPrio (qemu.override { hostCpuOnly = true; nixosTestRunner = true; });

  sdrangel = libsForQt5.callPackage ../applications/radio/sdrangel {
    boost = boost172;
  };

  sgx-sdk = callPackage ../os-specific/linux/sgx/sdk { };

  sinit = callPackage ../os-specific/linux/sinit {
    rcinit = "/etc/rc.d/rc.init";
    rcshutdown = "/etc/rc.d/rc.shutdown";
  };

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # sysdig is a client, for a driver look at linuxPackagesFor

  systemd = callPackage ../os-specific/linux/systemd {
    # break some cyclic dependencies
    util-linux = util-linuxMinimal;
    # provide a super minimal gnupg used for systemd-machined
    gnupg = callPackage ../tools/security/gnupg/23.nix {
      enableMinimal = true;
      guiSupport = false;
    };
  };
  systemdMinimal = systemd.override {
    pname = "systemd-minimal";
    withAnalyze = false;
    withApparmor = false;
    withCompression = false;
    withCoredump = false;
    withCryptsetup = false;
    withDocumentation = false;
    withEfi = false;
    withFido2 = false;
    withHostnamed = false;
    withHomed = false;
    withHwdb = false;
    withImportd = false;
    withLibBPF = false;
    withLocaled = false;
    withLogind = false;
    withMachined = false;
    withNetworkd = false;
    withNss = false;
    withOomd = false;
    withPCRE2 = false;
    withPolkit = false;
    withPortabled = false;
    withRemote = false;
    withResolved = false;
    withShellCompletions = false;
    withTimedated = false;
    withTimesyncd = false;
    withTpm2Tss = false;
    withUserDb = false;
  };
  systemdStage1 = systemdMinimal.override {
    pname = "systemd-stage-1";
    withCryptsetup = true;
    withFido2 = true;
    withTpm2Tss = true;
  };
  systemdStage1Network = systemdStage1.override {
    pname = "systemd-stage-1-network";
    withNetworkd = true;
  };


  udev =
    if (with stdenv.hostPlatform; isLinux && isStatic) then libudev-zero
    else systemd; # TODO: change to systemdMinimal

  sysvtools = sysvinit.override {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.

  trinsic-cli = callPackage ../tools/admin/trinsic-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot {})
    buildUBoot
    ubootTools
    ubootA20OlinuxinoLime
    ubootA20OlinuxinoLime2EMMC
    ubootBananaPi
    ubootBananaPim3
    ubootBananaPim64
    ubootAmx335xEVM
    ubootClearfog
    ubootCubieboard2
    ubootGuruplug
    ubootJetsonTK1
    ubootLibreTechCC
    ubootNanoPCT4
    ubootNovena
    ubootOdroidC2
    ubootOdroidXU3
    ubootOlimexA64Olinuxino
    ubootOrangePiPc
    ubootOrangePiZeroPlus2H5
    ubootOrangePiZero
    ubootOrangePiZero2
    ubootPcduino3Nano
    ubootPine64
    ubootPine64LTS
    ubootPinebook
    ubootPinebookPro
    ubootQemuAarch64
    ubootQemuArm
    ubootQemuRiscv64Smode
    ubootQemuX86
    ubootRaspberryPi
    ubootRaspberryPi2
    ubootRaspberryPi3_32bit
    ubootRaspberryPi3_64bit
    ubootRaspberryPi4_32bit
    ubootRaspberryPi4_64bit
    ubootRaspberryPiZero
    ubootRock64
    ubootRockPi4
    ubootRockPro64
    ubootROCPCRK3399
    ubootSheevaplug
    ubootSopine
    ubootUtilite
    ubootWandboard
    ;

  # Upstream Barebox:
  inherit (callPackage ../misc/barebox {})
    buildBarebox
    bareboxTools;

  uclibc-ng = callPackage ../os-specific/linux/uclibc-ng { };

  uclibc-ng-cross = callPackage ../os-specific/linux/uclibc-ng {
    stdenv = crossLibcStdenv;
  };

  # Aliases
  uclibc = uclibc-ng;
  uclibcCross = uclibc-ng-cross;

  eudev = callPackage ../os-specific/linux/eudev { util-linux = util-linuxMinimal; };

  udisks = udisks2;

  util-linux = if stdenv.isLinux then callPackage ../os-specific/linux/util-linux { }
              else unixtools.util-linux;

  util-linuxMinimal = if stdenv.isLinux then util-linux.override {
    nlsSupport = false;
    ncursesSupport = false;
    systemdSupport = false;
    translateManpages = false;
  } else util-linux;

  v4l-utils = qt5.callPackage ../os-specific/linux/v4l-utils { };

  windows = callPackages ../os-specific/windows {};

  wpa_supplicant_ro_ssids = wpa_supplicant.override {
    readOnlyModeSSIDs = true;
  };

  wpa_supplicant_gui = libsForQt5.callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  inherit (callPackages ../os-specific/linux/zfs {
    configFile = "user";
  }) zfsStable zfsUnstable;

  zfs = zfsStable;

  ### DATA

  adwaita-qt = libsForQt5.callPackage ../data/themes/adwaita-qt { };

  adwaita-qt6 = qt6Packages.callPackage ../data/themes/adwaita-qt {
    useQt6 = true;
  };

  androguard = with python3.pkgs; toPythonApplication androguard;

  bibata-cursors = callPackage ../data/icons/bibata-cursors { attrs = python3Packages.attrs; };

  dejavu_fonts = lowPrio (callPackage ../data/fonts/dejavu-fonts {});

  # solve collision for nix-env before https://github.com/NixOS/nix/pull/815
  dejavu_fontsEnv = buildEnv {
    name = dejavu_fonts.name;
    paths = [ dejavu_fonts.out ];
  };

  docbook_xml_dtd_412 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix { };

  docbook_xml_dtd_42 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix { };

  docbook_xml_dtd_43 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix { };

  docbook_xml_dtd_44 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.4.nix { };

  docbook_xml_dtd_45 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix { };

  inherit (callPackages ../data/sgml+xml/stylesheets/xslt/docbook-xsl { })
    docbook-xsl-nons
    docbook-xsl-ns;

  # TODO: move this to aliases
  docbook_xsl = docbook-xsl-nons;
  docbook_xsl_ns = docbook-xsl-ns;

  moeli = eduli;

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
  };

  flat-remix-icon-theme = callPackage ../data/icons/flat-remix-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  font-awesome_4 = (callPackage ../data/fonts/font-awesome { }).v4;
  font-awesome_5 = (callPackage ../data/fonts/font-awesome { }).v5;
  font-awesome_6 = (callPackage ../data/fonts/font-awesome { }).v6;
  font-awesome = font-awesome_6;

  palenight-theme = callPackage ../data/themes/gtk-theme-framework { theme = "palenight"; };

  amarena-theme = callPackage ../data/themes/gtk-theme-framework { theme = "amarena"; };

  gruvterial-theme = callPackage ../data/themes/gtk-theme-framework { theme = "gruvterial"; };

  oceanic-theme = callPackage ../data/themes/gtk-theme-framework { theme = "oceanic"; };

  spacx-gtk-theme = callPackage ../data/themes/gtk-theme-framework { theme = "spacx"; };

  gruvbox-dark-icons-gtk = callPackage ../data/icons/gruvbox-dark-icons-gtk {
    inherit (plasma5Packages) breeze-icons;
  };

  inconsolata-nerdfont = nerdfonts.override {
    fonts = [ "Inconsolata" ];
  };

  iosevka = callPackage ../data/fonts/iosevka {};
  iosevka-comfy = recurseIntoAttrs (callPackages ../data/fonts/iosevka/comfy.nix {});

  kde-rounded-corners = libsForQt5.callPackage ../data/themes/kwin-decorations/kde-rounded-corners { };

  kora-icon-theme = callPackage ../data/icons/kora-icon-theme {
    inherit (gnome) adwaita-icon-theme;
    inherit (libsForQt5.kdeFrameworks) breeze-icons;
  };

  la-capitaine-icon-theme = callPackage ../data/icons/la-capitaine-icon-theme {
    inherit (plasma5Packages) breeze-icons;
    inherit (pantheon) elementary-icon-theme;
  };

  inherit (callPackages ../data/fonts/liberation-fonts { })
    liberation_ttf_v1
    liberation_ttf_v2
    ;
  liberation_ttf = liberation_ttf_v2;

  lightly-qt = libsForQt5.callPackage ../data/themes/lightly-qt { };

  # ltunifi and solaar both provide udev rules but solaar's rules are more
  # up-to-date so we simply use that instead of having to maintain our own rules
  logitech-udev-rules = solaar.udev;

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  luna-icons = callPackage ../data/icons/luna-icons {
    inherit (plasma5Packages) breeze-icons;
  };

  maia-icon-theme = libsForQt5.callPackage ../data/icons/maia-icon-theme { };

  material-kwin-decoration = libsForQt5.callPackage ../data/themes/material-kwin-decoration { };

  mojave-gtk-theme = callPackage ../data/themes/mojave {
    inherit (gnome) gnome-shell;
  };

  mplus-outline-fonts = recurseIntoAttrs (callPackage ../data/fonts/mplus-outline-fonts { });

  netease-cloud-music-gtk = callPackage ../applications/audio/netease-cloud-music-gtk {
    inherit (darwin.apple_sdk.frameworks) Foundation SystemConfiguration;
  };

  inherit (callPackages ../data/fonts/noto-fonts {})
    mkNoto
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-emoji-blob-bin
    noto-fonts-extra;

  nullmailer = callPackage ../servers/mail/nullmailer {
    stdenv = gccStdenv;
  };

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme {
    inherit (gnome) adwaita-icon-theme;
    inherit (plasma5Packages) breeze-icons;
  };

  openmoji-color = callPackage ../data/fonts/openmoji { variant = "color"; };

  openmoji-black = callPackage ../data/fonts/openmoji { variant = "black"; };

  papirus-icon-theme = callPackage ../data/icons/papirus-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  papirus-maia-icon-theme = callPackage ../data/icons/papirus-maia-icon-theme {
    inherit (plasma5Packages) breeze-icons;
  };

  papis = with python3Packages; toPythonApplication papis;

  plata-theme = callPackage ../data/themes/plata {
    inherit (mate) marco;
  };

  polychromatic = libsForQt5.callPackage ../applications/misc/polychromatic { };

  pop-icon-theme = callPackage ../data/icons/pop-icon-theme {
    inherit (gnome) adwaita-icon-theme;
  };

  powerline-rs = callPackage ../tools/misc/powerline-rs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  shaderc = callPackage ../development/compilers/shaderc {
    inherit (darwin) autoSignDarwinBinariesHook cctools;
  };

  sierra-breeze-enhanced = libsForQt5.callPackage ../data/themes/kwin-decorations/sierra-breeze-enhanced { };

  scheherazade = callPackage ../data/fonts/scheherazade { version = "2.100"; };

  scheherazade-new = callPackage ../data/fonts/scheherazade { };

  star-history = callPackage ../tools/misc/star-history {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  starship = callPackage ../tools/misc/starship {
    inherit (darwin.apple_sdk.frameworks) Security Foundation Cocoa;
  };

  inherit (callPackages ../data/fonts/gdouros { })
    aegan aegyptus akkadian assyrian eemusic maya symbola textfonts unidings;

  inherit (callPackages ../data/fonts/pretendard { })
    pretendard
    pretendard-jp
    pretendard-std;

  sourceHanPackages = dontRecurseIntoAttrs (callPackage ../data/fonts/source-han { });
  source-han-sans = sourceHanPackages.sans;
  source-han-serif = sourceHanPackages.serif;
  source-han-mono = sourceHanPackages.mono;

  inherit (callPackages ../data/fonts/tai-languages { }) tai-ahom;

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme {
    gtk = res.gtk2;
  };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) {};

  tela-circle-icon-theme = callPackage ../data/icons/tela-circle-icon-theme {
    inherit (gnome) adwaita-icon-theme;
  };

  terminus-nerdfont = nerdfonts.override {
    fonts = [ "Terminus" ];
  };

  tex-gyre = callPackages ../data/fonts/tex-gyre { };

  tex-gyre-math = callPackages ../data/fonts/tex-gyre-math { };

  vimix-gtk-themes = callPackage ../data/themes/vimix {
    inherit (gnome) gnome-shell;
  };

  whitesur-gtk-theme = callPackage ../data/themes/whitesur {
    inherit (gnome) gnome-shell;
  };

  xkeyboard_config = xorg.xkeyboardconfig;

  xlsx2csv = with python3Packages; toPythonApplication xlsx2csv;

  zafiro-icons = callPackage ../data/icons/zafiro-icons {
    inherit (plasma5Packages) breeze-icons;
  };

  zeal-qt5 = libsForQt5.callPackage ../data/documentation/zeal { };
  zeal-qt6 = qt6Packages.callPackage ../data/documentation/zeal { };
  zeal = zeal-qt5;

  ### APPLICATIONS / GIS

  gmt = callPackage ../applications/gis/gmt {
    inherit (darwin.apple_sdk.frameworks)
      Accelerate CoreGraphics CoreVideo;
  };

  openorienteering-mapper = libsForQt5.callPackage ../applications/gis/openorienteering-mapper { };

  qgis-ltr = callPackage ../applications/gis/qgis/ltr.nix { };

  qgis = callPackage ../applications/gis/qgis { };

  qmapshack = libsForQt5.callPackage ../applications/gis/qmapshack { };

  saga = libsForQt5.callPackage ../applications/gis/saga {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  spatialite_gui = callPackage ../applications/gis/spatialite-gui {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa IOKit;
    wxGTK = wxGTK32;
  };

  whitebox-tools = callPackage ../applications/gis/whitebox-tools {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  zombietrackergps = libsForQt5.callPackage ../applications/gis/zombietrackergps { };

  ### APPLICATIONS

  _2bwm = callPackage ../applications/window-managers/2bwm {
    patches = config."2bwm".patches or [];
  };

  abcde = callPackage ../applications/audio/abcde {
    inherit (python3Packages) eyeD3;
  };

  acd-cli = callPackage ../applications/networking/sync/acd_cli {
    inherit (python3Packages)
      buildPythonApplication appdirs colorama python-dateutil
      requests requests-toolbelt setuptools sqlalchemy fusepy;
  };

  adobe-reader = pkgsi686Linux.callPackage ../applications/misc/adobe-reader { };

  masterpdfeditor = libsForQt5.callPackage ../applications/misc/masterpdfeditor { };

  masterpdfeditor4 = libsForQt5.callPackage ../applications/misc/masterpdfeditor4 { };

  foxitreader = libsForQt5.callPackage ../applications/misc/foxitreader { };

  pdfstudio2021 = callPackage ../applications/misc/pdfstudio {
    year = "2021";
  };

  pdfstudio2022 = callPackage ../applications/misc/pdfstudio {
    year = "2022";
  };

  pdfstudioviewer = callPackage ../applications/misc/pdfstudio {
    program = "pdfstudioviewer";
  };

  afterstep = callPackage ../applications/window-managers/afterstep {
    fltk = fltk13;
    gtk = gtk2;
  };

  alpine = callPackage ../applications/networking/mailreaders/alpine {
    tcl = tcl-8_5;
  };

  amarok = libsForQt5.callPackage ../applications/audio/amarok { };
  amarok-kf5 = amarok; # for compatibility

  androidStudioPackages = recurseIntoAttrs
    (callPackage ../applications/editors/android-studio {
      buildFHSUserEnv = buildFHSUserEnvBubblewrap;
    });
  android-studio = androidStudioPackages.stable;

  antimony = libsForQt5.callPackage ../applications/graphics/antimony {};

  anup = callPackage ../applications/misc/anup {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ao = libfive;

  apkeep = callPackage ../tools/misc/apkeep {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  apostrophe = callPackage ../applications/editors/apostrophe {
    pythonPackages = python3Packages;
    texlive = texlive.combined.scheme-medium;
  };

  aqemu = libsForQt5.callPackage ../applications/virtualization/aqemu { };

  ardour_6 = callPackage ../applications/audio/ardour/6.nix { };
  ardour = callPackage ../applications/audio/ardour { };

  arelle = with python3Packages; toPythonApplication arelle;

  asuka = callPackage ../applications/networking/browsers/asuka {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  atomPackages = dontRecurseIntoAttrs (callPackage ../applications/editors/atom { });

  inherit (atomPackages) atom atom-beta;

  aseprite-unfree = aseprite.override { unfree = true; };

  astroid = callPackage ../applications/networking/mailreaders/astroid {
    vim = vim-full.override { features = "normal"; };
  };

  audacious = libsForQt5.callPackage ../applications/audio/audacious { };
  audacious-plugins = libsForQt5.callPackage ../applications/audio/audacious/plugins.nix {
    # Avoid circular dependency
    audacious = audacious.override { audacious-plugins = null; };
  };
  audaciousQt5 = audacious;

  audacity = darwin.apple_sdk_11_0.callPackage ../applications/audio/audacity {
    inherit (darwin.apple_sdk_11_0.frameworks) AppKit CoreAudioKit;
  };

  avalanchego = callPackage ../applications/networking/avalanchego {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  bambootracker = libsForQt5.callPackage ../applications/audio/bambootracker { };

  cadence = libsForQt5.callPackage ../applications/audio/cadence { };

  ptcollab = libsForQt5.callPackage ../applications/audio/ptcollab { };

  libbitcoin = callPackage ../tools/misc/libbitcoin/libbitcoin.nix {
    boost = boost175; # fatal error: 'boost/interprocess/detail/posix_time_types_wrk.hpp' file not found
  };
  libbitcoin-protocol = callPackage ../tools/misc/libbitcoin/libbitcoin-protocol.nix {
    boost = boost175;
  };
  libbitcoin-client   = callPackage ../tools/misc/libbitcoin/libbitcoin-client.nix {
    boost = boost175;
  };
  libbitcoin-network  = callPackage ../tools/misc/libbitcoin/libbitcoin-network.nix {
    boost = boost175;
  };
  libbitcoin-explorer = callPackage ../tools/misc/libbitcoin/libbitcoin-explorer.nix {
    boost = boost175;
  };


  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  AusweisApp2 = libsForQt5.callPackage ../applications/misc/ausweisapp2 { };

  avidemux = libsForQt5.callPackage ../applications/video/avidemux { };

  awesome = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    inherit (texFunctions) fontsConf;
  };

  awesomebump = libsForQt5.callPackage ../applications/graphics/awesomebump { };

  inherit (gnome) baobab;

  backintime-qt = libsForQt5.callPackage ../applications/networking/sync/backintime/qt.nix { };

  backintime = backintime-qt;

  barrier = libsForQt5.callPackage ../applications/misc/barrier {};

  bespokesynth = callPackage ../applications/audio/bespokesynth {
    inherit (darwin.apple_sdk.frameworks) Cocoa WebKit CoreServices CoreAudioKit;
  };

  bespokesynth-with-vst2 = bespokesynth.override {
    enableVST2 = true;
  };

  bfcal = libsForQt5.callPackage ../applications/misc/bfcal { };

  bibletime = libsForQt5.callPackage ../applications/misc/bibletime { };

  bino3d = libsForQt5.callPackage ../applications/video/bino3d {
    glew = glew110;
  };

  bitscope = recurseIntoAttrs
    (callPackage ../applications/science/electronics/bitscope/packages.nix { });

  bitwig-studio1 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio1.nix {
    inherit (gnome) zenity;
    libxkbcommon = libxkbcommon_7;
  };
  bitwig-studio2 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio2.nix {
    inherit bitwig-studio1;
  };
  bitwig-studio4 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio4.nix {
    libjpeg = libjpeg.override { enableJpeg8 = true; };
  };

  bitwig-studio = bitwig-studio4;

  blender = callPackage  ../applications/misc/blender {
    # LLVM 11 crashes when compiling GHOST_SystemCocoa.mm
    stdenv = if stdenv.isDarwin then llvmPackages_10.stdenv else stdenv;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics ForceFeedback OpenAL OpenGL;
  };

  blender-hip = blender.override { hipSupport = true; };

  blucontrol = callPackage ../applications/misc/blucontrol/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
  };

  bluefish = callPackage ../applications/editors/bluefish {
    gtk = gtk3;
  };

  bluej = callPackage ../applications/editors/bluej {
    jdk = jetbrains.jdk;
  };

  break-time = callPackage ../applications/misc/break-time {
    openssl = openssl_1_1;
  };

  breezy = with python3Packages; toPythonApplication breezy;

  cage = callPackage ../applications/window-managers/cage {
    wlroots = wlroots_0_14;
  };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome2) libglade;
  };

  calcmysky = qt6Packages.callPackage ../applications/science/astronomy/calcmysky { };

  calibre = qt6Packages.callPackage ../applications/misc/calibre { };

  # calico-felix and calico-node have not been packaged due to libbpf, linking issues
  inherit (callPackage ../applications/networking/cluster/calico {})
    calico-apiserver
    calico-app-policy
    calico-cni-plugin
    calico-kube-controllers
    calico-pod2daemon
    calico-typha
    calicoctl
    confd-calico;

  calligra = libsForQt5.callPackage ../applications/office/calligra { };

  carla = libsForQt5.callPackage ../applications/audio/carla { };

  cb2bib = libsForQt5.callPackage ../applications/office/cb2bib { };

  cddiscid = callPackage ../applications/audio/cd-discid {
    inherit (darwin) IOKit;
  };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = callPackage ../applications/audio/cdparanoia {
    inherit (darwin) IOKit;
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  brotab = callPackage ../tools/misc/brotab {
    python = python3;
  };

  chromium = callPackage ../applications/networking/browsers/chromium (config.chromium or {});

  chromiumBeta = lowPrio (chromium.override { channel = "beta"; });

  chromiumDev = lowPrio (chromium.override { channel = "dev"; });

  chuck = callPackage ../applications/audio/chuck {
    inherit (darwin) DarwinTools;
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel MultitouchSupport;
  };

  cligh = python3Packages.callPackage ../development/tools/github/cligh {};

  clipgrab = libsForQt5.callPackage ../applications/video/clipgrab { };

  cmus = callPackage ../applications/audio/cmus {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio VideoToolbox;
    libjack = libjack2;
  };

  communi = libsForQt5.callPackage ../applications/networking/irc/communi { };

  confclerk = libsForQt5.callPackage ../applications/misc/confclerk { };

  copyq = qt6Packages.callPackage ../applications/misc/copyq { };

  corectrl = libsForQt5.callPackage ../applications/misc/corectrl { };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome2) libgnomeui GConf;
  };

  corrscope = libsForQt5.callPackage ../applications/video/corrscope {
    ffmpeg = ffmpeg-full;
  };

  cpeditor = libsForQt5.callPackage ../applications/editors/cpeditor { };

  csound = callPackage ../applications/audio/csound {
    inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate AudioUnit CoreAudio CoreMIDI;
  };

  csound-qt = libsForQt5.callPackage ../applications/audio/csound/csound-qt {
    python = python3;
  };

  codeblocksFull = codeblocks.override { contribPlugins = true; };

  cudatext-qt = callPackage ../applications/editors/cudatext { widgetset = "qt5"; };
  cudatext-gtk = callPackage ../applications/editors/cudatext { widgetset = "gtk2"; };
  cudatext = cudatext-qt;

  comical = callPackage ../applications/graphics/comical {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  cq-editor = libsForQt5.callPackage ../applications/graphics/cq-editor { };

  cqrlog = callPackage ../applications/radio/cqrlog {
    hamlib = hamlib_4;
  };

  cubicsdr = callPackage ../applications/radio/cubicsdr {
    inherit (darwin.apple_sdk.frameworks) Cocoa WebKit;
  };

  cutecom = libsForQt5.callPackage ../tools/misc/cutecom { };

  darcs = haskell.lib.compose.overrideCabal (drv: {
    configureFlags = (lib.remove "-flibrary" drv.configureFlags or []) ++ ["-f-library"];
  }) (haskell.lib.compose.justStaticExecutables haskellPackages.darcs);

  darktable = callPackage ../applications/graphics/darktable {
    lua = lua5_4;
    pugixml = pugixml.override { shared = true; };
  };

  datadog-agent = callPackage ../tools/networking/dd-agent/datadog-agent.nix {
    pythonPackages = datadog-integrations-core {};
  };
  datadog-integrations-core = extras: callPackage ../tools/networking/dd-agent/integrations-core.nix {
    python = python3;
    extraIntegrations = extras;
  };

  deadbeefPlugins = {
    headerbar-gtk3 = callPackage ../applications/audio/deadbeef/plugins/headerbar-gtk3.nix { };
    lyricbar = callPackage ../applications/audio/deadbeef/plugins/lyricbar.nix { };
    mpris2 = callPackage ../applications/audio/deadbeef/plugins/mpris2.nix { };
    musical-spectrum = callPackage ../applications/audio/deadbeef/plugins/musical-spectrum.nix { };
    statusnotifier = callPackage ../applications/audio/deadbeef/plugins/statusnotifier.nix { };
    playlist-manager = callPackage ../applications/audio/deadbeef/plugins/playlist-manager.nix { };
  };

  deadbeef-with-plugins = callPackage ../applications/audio/deadbeef/wrapper.nix {
    plugins = [];
  };

  dfasma = libsForQt5.callPackage ../applications/audio/dfasma { };

  direwolf = callPackage ../applications/radio/direwolf {
    hamlib = hamlib_4;
  };

  djview = libsForQt5.callPackage ../applications/graphics/djview { };
  djview4 = djview;

  dmensamenu = callPackage ../applications/misc/dmensamenu {
    inherit (python3Packages) buildPythonApplication requests;
  };

  dmtx-utils = callPackage ../tools/graphics/dmtx-utils {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  inherit (callPackage ../applications/virtualization/docker {})
    docker_20_10;

  docker = docker_20_10;
  docker-client = docker.override { clientOnly = true; };

  docker-machine-xhyve = callPackage ../applications/networking/cluster/docker-machine/xhyve.nix {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
    inherit (darwin) cctools;
  };

  docker-compose_1 = python3Packages.callPackage ../applications/virtualization/docker/compose_1.nix {};

  drawpile = libsForQt5.callPackage ../applications/graphics/drawpile { };
  drawpile-server-headless = libsForQt5.callPackage ../applications/graphics/drawpile {
    buildClient = false;
    buildServerGui = false;
  };

  droopy = python3Packages.callPackage ../applications/networking/droopy { };

  drumgizmo = callPackage ../applications/audio/drumgizmo {
    stdenv = gcc10StdenvCompat;
  };

  du-dust = callPackage ../tools/misc/dust {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  dexed = darwin.apple_sdk_11_0.callPackage ../applications/audio/dexed {
    inherit (darwin.apple_sdk_11_0.frameworks) Cocoa WebKit MetalKit DiscRecording CoreAudioKit;
    inherit (darwin.apple_sdk_11_0.libs) simd;
  };

  dvdstyler = callPackage ../applications/video/dvdstyler {
    inherit (gnome2) libgnomeui;
  };

  dwm = callPackage ../applications/window-managers/dwm {
    # dwm is configured entirely through source modification. Allow users to
    # specify patches through nixpkgs.config.dwm.patches
    patches = config.dwm.patches or [];
  };

  evilwm = callPackage ../applications/window-managers/evilwm {
    patches = config.evilwm.patches or [];
  };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse { });

  ecpdap = callPackage ../development/embedded/fpga/ecpdap {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  electron-cash = libsForQt5.callPackage ../applications/misc/electron-cash { };

  electrum = libsForQt5.callPackage ../applications/misc/electrum { };

  electrum-grs = libsForQt5.callPackage ../applications/misc/electrum/grs.nix { };

  electrum-ltc = libsForQt5.callPackage ../applications/misc/electrum/ltc.nix { };

  elf-dissector = libsForQt5.callPackage ../applications/misc/elf-dissector {
    libdwarf = libdwarf_20210528;
  };

  elinks = callPackage ../applications/networking/browsers/elinks {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  emacs = emacs28;
  emacs-gtk = emacs28-gtk;
  emacs-nox = emacs28-nox;

  emacs28 = callPackage ../applications/editors/emacs/28.nix {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    gconf = null;
    alsa-lib = null;
    acl = null;
    gpm = null;
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
    inherit (darwin) sigtool;
  };

  emacs28-gtk = emacs28.override {
    withGTK3 = true;
  };

  emacs28-nox = lowPrio (emacs28.override {
    withX = false;
    withNS = false;
    withGTK2 = false;
    withGTK3 = false;
  });

  emacsMacport = callPackage ../applications/editors/emacs/macport.nix {
    withMacport = true;

    gconf = null;

    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
    inherit (darwin) sigtool;
  };

  emacsPackagesFor = emacs: import ./emacs-packages.nix {
    inherit (lib) makeScope makeOverridable dontRecurseIntoAttrs;
    emacs' = emacs;
    pkgs' = pkgs;  # default pkgs used for bootstrapping the emacs package set
  };

  # This alias should live in aliases.nix but that would cause Hydra not to evaluate/build the packages.
  # If you turn this into "real" alias again, please add it to pkgs/top-level/packages-config.nix again too
  emacsPackages = emacs.pkgs;

  entangle = callPackage ../applications/video/entangle {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  epgstation = callPackage ../applications/video/epgstation {
    nodejs = nodejs-16_x;
  };

  inherit (gnome) epiphany;

  epick = callPackage ../applications/graphics/epick {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  espeak-classic = callPackage ../applications/audio/espeak { };

  espeak = super.espeak-ng;

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  etebase-server = with python3Packages; toPythonApplication etebase-server;

  evilpixie = libsForQt5.callPackage ../applications/graphics/evilpixie { };

  eww = callPackage ../applications/window-managers/eww { };
  eww-wayland = callPackage ../applications/window-managers/eww {
    withWayland = true;
  };

  furnace = callPackage ../applications/audio/furnace {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  greenfoot = callPackage ../applications/editors/greenfoot {
    jdk = jetbrains.jdk;
  };

  haruna = libsForQt5.callPackage ../applications/video/haruna { };

  hdrmerge = libsForQt5.callPackage ../applications/graphics/hdrmerge { };

  keepassxc = libsForQt5.callPackage ../applications/misc/keepassx/community.nix { };

  inherit (gnome) evince;
  evolution-data-server = gnome.evolution-data-server;
  evolution-data-server-gtk4 = evolution-data-server.override { withGtk3 = false; withGtk4 = true; };
  evolutionWithPlugins = callPackage ../applications/networking/mailreaders/evolution/evolution/wrapper.nix { plugins = [ evolution evolution-ews ]; };

  fdr = libsForQt5.callPackage ../applications/science/programming/fdr { };

  finalfrontier = callPackage ../applications/science/machine-learning/finalfrontier {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  finalfusion-utils = callPackage ../applications/science/machine-learning/finalfusion-utils {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  firewalld-gui = firewalld.override { withGui = true; };

  flacon = libsForQt5.callPackage ../applications/audio/flacon { };

  fldigi = callPackage ../applications/radio/fldigi {
    hamlib = hamlib_4;
  };

  fluxus = callPackage ../applications/graphics/fluxus { stdenv = gcc10StdenvCompat; };

  flwrap = callPackage ../applications/radio/flwrap { stdenv = gcc10StdenvCompat; };

  fluidsynth = callPackage ../applications/audio/fluidsynth {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio CoreMIDI CoreServices;
  };

  fmit = libsForQt5.callPackage ../applications/audio/fmit { };

  focuswriter = libsForQt5.callPackage ../applications/editors/focuswriter { };

  fossil = callPackage ../applications/version-management/fossil {
    sqlite = sqlite.override { enableDeserialize = true; };
  };

  fritzing = libsForQt5.callPackage ../applications/science/electronics/fritzing { };

  fritzprofiles = with python3.pkgs; toPythonApplication fritzprofiles;

  ft2-clone = callPackage ../applications/audio/ft2-clone {
    inherit (darwin.apple_sdk.frameworks) CoreAudio CoreMIDI CoreServices Cocoa;
  };

  fvwm = fvwm2;

  gazelle-origin = python3Packages.callPackage ../tools/misc/gazelle-origin { };

  ghostwriter = libsForQt5.callPackage ../applications/editors/ghostwriter { };

  gnuradio = callPackage ../applications/radio/gnuradio/wrapper.nix {
    unwrapped = callPackage ../applications/radio/gnuradio {
      inherit (darwin.apple_sdk.frameworks) CoreAudio;
      python = python3;
    };
  };
  gnuradioPackages = lib.recurseIntoAttrs gnuradio.pkgs;
  # A build without gui components and other utilites not needed for end user
  # libraries
  gnuradioMinimal = gnuradio.override {
    doWrap = false;
    unwrapped = gnuradio.unwrapped.override {
      volk = volk.override {
        # So it will not reference python
        enableModTool = false;
      };
      features = {
        gnuradio-companion = false;
        python-support = false;
        examples = false;
        gr-qtgui = false;
        gr-utils = false;
        gr-modtool = false;
        gr-blocktool = false;
        sphinx = false;
        doxygen = false;
        # Doesn't make it reference python eventually, but makes reverse
        # depdendencies require python to use cmake files of GR.
        gr-ctrlport = false;
      };
    };
  };
  gnuradio3_9 = callPackage ../applications/radio/gnuradio/wrapper.nix {
    unwrapped = callPackage ../applications/radio/gnuradio/3.9.nix {
      inherit (darwin.apple_sdk.frameworks) CoreAudio;
      python = python3;
    };
  };
  gnuradio3_9Packages = lib.recurseIntoAttrs gnuradio3_9.pkgs;
  # A build without gui components and other utilites not needed for end user
  # libraries
  gnuradio3_9Minimal = gnuradio.override {
    doWrap = false;
    unwrapped = gnuradio.unwrapped.override {
      volk = volk.override {
        # So it will not reference python
        enableModTool = false;
      };
      features = {
        gnuradio-companion = false;
        python-support = false;
        examples = false;
        gr-qtgui = false;
        gr-utils = false;
        gr-modtool = false;
        gr-blocktool = false;
        sphinx = false;
        doxygen = false;
        # Doesn't make it reference python eventually, but makes reverse
        # depdendencies require python to use cmake files of GR.
        gr-ctrlport = false;
      };
    };
  };
  gnuradio3_8 = callPackage ../applications/radio/gnuradio/wrapper.nix {
    unwrapped = callPackage ../applications/radio/gnuradio/3.8.nix {
      inherit (darwin.apple_sdk.frameworks) CoreAudio;
      python = python3;
    };
  };
  gnuradio3_8Packages = lib.recurseIntoAttrs gnuradio3_8.pkgs;
  # A build without gui components and other utilites not needed if gnuradio is
  # used as a c++ library.
  gnuradio3_8Minimal = gnuradio3_8.override {
    doWrap = false;
    unwrapped = gnuradio3_8.unwrapped.override {
      volk = volk.override {
        enableModTool = false;
      };
      features = {
        gnuradio-companion = false;
        python-support = false;
        examples = false;
        gr-qtgui = false;
        gr-utils = false;
        gr-modtool = false;
        sphinx = false;
        doxygen = false;
        # Doesn't make it reference python eventually, but makes reverse
        # depdendencies require python to use cmake files of GR.
        gr-ctrlport = false;
      };
    };
  };

  grandorgue = callPackage ../applications/audio/grandorgue {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  greetd = recurseIntoAttrs {
    dlm = callPackage ../applications/display-managers/greetd/dlm.nix { };
    greetd = callPackage ../applications/display-managers/greetd { };
    gtkgreet = callPackage ../applications/display-managers/greetd/gtkgreet.nix { };
    tuigreet = callPackage ../applications/display-managers/greetd/tuigreet.nix { };
    wlgreet = callPackage ../applications/display-managers/greetd/wlgreet.nix { };
  };

  goldendict = libsForQt5.callPackage ../applications/misc/goldendict { };

  inherit (ocaml-ng.ocamlPackages_4_12) google-drive-ocamlfuse;

  googler = callPackage ../applications/misc/googler {
    python = python3;
  };

  gpicview = callPackage ../applications/graphics/gpicview {
    gtk2 = gtk2-x11;
  };

  gqrx = qt6Packages.callPackage ../applications/radio/gqrx { };
  gqrx-portaudio = qt6Packages.callPackage ../applications/radio/gqrx {
    portaudioSupport = true;
    pulseaudioSupport = false;
  };
  gqrx-gr-audio = qt6Packages.callPackage ../applications/radio/gqrx {
    portaudioSupport = false;
    pulseaudioSupport = false;
  };

  gtimelog = with python3Packages; toPythonApplication gtimelog;

  inherit (gnome) gucharmap;

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  gurk-rs = callPackage ../applications/networking/instant-messengers/gurk-rs {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  puddletag = libsForQt5.callPackage ../applications/audio/puddletag { };

  welle-io = libsForQt5.callPackage ../applications/radio/welle-io { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices SystemConfiguration;
    libpcap = libpcap.override { withBluez = stdenv.isLinux; };
  };
  wireshark-qt = wireshark;

  tshark = wireshark-cli;
  wireshark-cli = wireshark.override {
    withQt = false;
    libpcap = libpcap.override { withBluez = stdenv.isLinux; };
  };

  fclones = callPackage ../tools/misc/fclones {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  feh = callPackage ../applications/graphics/feh {
    imlib2 = imlib2Full;
  };

  fire = darwin.apple_sdk_11_0.callPackage ../applications/audio/fire {
    inherit (darwin.apple_sdk_11_0.frameworks) Cocoa WebKit CoreServices DiscRecording CoreAudioKit MetalKit;
    inherit (darwin.apple_sdk_11_0.libs) simd;
  };

  buildMozillaMach = opts: callPackage (import ../applications/networking/browsers/firefox/common.nix opts) {};

  firefoxPackages = recurseIntoAttrs (callPackage ../applications/networking/browsers/firefox/packages.nix {});

  firefox-unwrapped = firefoxPackages.firefox;
  firefox-esr-102-unwrapped = firefoxPackages.firefox-esr-102;
  firefox-esr-unwrapped = firefoxPackages.firefox-esr-102;

  firefox = wrapFirefox firefox-unwrapped { };

  firefox-esr = firefox-esr-102;
  firefox-esr-102 = wrapFirefox firefox-esr-102-unwrapped { };

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    inherit (gnome) adwaita-icon-theme;
    channel = "release";
    generated = import ../applications/networking/browsers/firefox-bin/release_sources.nix;
  };

  firefox-bin = wrapFirefox firefox-bin-unwrapped {
    pname = "firefox-bin";
  };

  firefox-beta-bin-unwrapped = firefox-bin-unwrapped.override {
    inherit (gnome) adwaita-icon-theme;
    channel = "beta";
    generated = import ../applications/networking/browsers/firefox-bin/beta_sources.nix;
  };

  firefox-beta-bin = super.wrapFirefox firefox-beta-bin-unwrapped {
    pname = "firefox-beta-bin";
    desktopName = "Firefox Beta";
  };

  firefox-devedition-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    inherit (gnome) adwaita-icon-theme;
    channel = "devedition";
    generated = import ../applications/networking/browsers/firefox-bin/devedition_sources.nix;
  };

  firefox-devedition-bin = super.wrapFirefox firefox-devedition-bin-unwrapped {
    nameSuffix = "-devedition";
    pname = "firefox-devedition-bin";
    desktopName = "Firefox DevEdition";
  };

  librewolf = wrapFirefox librewolf-unwrapped {
    inherit (librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
    libName = "librewolf";
  };

  firefox_decrypt = python3Packages.callPackage ../tools/security/firefox_decrypt { };

  flameshot = libsForQt5.callPackage ../tools/misc/flameshot { };

  formiko = with python3Packages; callPackage ../applications/editors/formiko {
    inherit buildPythonApplication;
  };

  foxotron = callPackage ../applications/graphics/foxotron {
    inherit (darwin.apple_sdk.frameworks) AVFoundation Carbon Cocoa CoreAudio Kernel OpenGL;
  };

  fractal = callPackage ../applications/networking/instant-messengers/fractal {
    openssl = openssl_1_1;
  };

  fractal-next = callPackage ../applications/networking/instant-messengers/fractal-next {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-bad;
  };

  freecad = libsForQt5.callPackage ../applications/graphics/freecad {
    boost = python3Packages.boost;
    inherit (python3Packages)
      gitpython
      matplotlib
      pivy
      ply
      pycollada
      pyside2
      pyside2-tools
      python
      pyyaml
      scipy
      shiboken2;
  };

  freedv = callPackage ../applications/radio/freedv {
    inherit (darwin.apple_sdk.frameworks) AppKit AVFoundation Cocoa CoreMedia;
    codec2 = codec2.override {
      freedvSupport = true;
    };
  };

  freemind = callPackage ../applications/misc/freemind {
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  freeoffice = callPackage ../applications/office/softmaker/freeoffice.nix {};

  inherit (xorg) xlsfonts;

  freerdp = callPackage ../applications/networking/remote/freerdp {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AVFoundation Carbon Cocoa CoreMedia;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  freerdpUnstable = freerdp;

  friture = libsForQt5.callPackage ../applications/audio/friture {
    python3Packages = python39Packages;
  };

  gimp = callPackage ../applications/graphics/gimp {
    autoreconfHook = buildPackages.autoreconfHook269;
    lcms = lcms2;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gimp-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimpPlugins = recurseIntoAttrs (callPackage ../applications/graphics/gimp/plugins {});

  girara = callPackage ../applications/misc/girara {
    gtk = gtk3;
  };

  inherit (gnome) gitg;

  got = darwin.apple_sdk_11_0.callPackage ../applications/version-management/got { };

  gtk-pipe-viewer = perlPackages.callPackage ../applications/video/pipe-viewer { withGtk3 = true; };

  hydrus = python3Packages.callPackage ../applications/graphics/hydrus {
    inherit miniupnpc swftools;
    inherit (qt5) wrapQtAppsHook;
  };

  jetbrains = (recurseIntoAttrs (callPackages ../applications/editors/jetbrains {
    vmopts = config.jetbrains.vmopts or null;
    jdk = jetbrains.jdk;
  }) // {
    jdk = callPackage ../development/compilers/jetbrains-jdk {  };
    jcef = callPackage ../development/compilers/jetbrains-jdk/jcef.nix { };
  });

  librespot = callPackage ../applications/audio/librespot {
    withALSA = stdenv.isLinux;
    withPulseAudio = config.pulseaudio or stdenv.isLinux;
    withPortAudio = stdenv.isDarwin;
  };

  linssid = libsForQt5.callPackage ../applications/networking/linssid { };

  m32edit = callPackage ../applications/audio/midas/m32edit.nix {};

  manuskript = libsForQt5.callPackage ../applications/editors/manuskript { };

  mindforger = libsForQt5.callPackage ../applications/editors/mindforger { };

  molsketch = libsForQt5.callPackage ../applications/editors/molsketch { };

  quvi = callPackage ../applications/video/quvi/tool.nix {
    lua5_sockets = lua51Packages.luasocket;
    lua5 = lua5_1;
  };

  gkrellm = callPackage ../applications/misc/gkrellm {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  gramps = callPackage ../applications/misc/gramps {
        pythonPackages = python3Packages;
  };

  graphicsmagick_q16 = graphicsmagick.override { quantumdepth = 16; };

  grisbi = callPackage ../applications/office/grisbi { gtk = gtk3; };

  q4wine = libsForQt5.callPackage ../applications/misc/q4wine { };

  qrencode = callPackage ../development/libraries/qrencode {
    inherit (darwin) libobjc;
  };

  gnome-recipes = callPackage ../applications/misc/gnome-recipes {
    inherit (gnome) gnome-autoar;
  };

  googleearth-pro = libsForQt5.callPackage ../applications/misc/googleearth-pro { };

  google-chrome-beta = google-chrome.override { chromium = chromiumBeta; channel = "beta"; };

  google-chrome-dev = google-chrome.override { chromium = chromiumDev; channel = "dev"; };

  gosmore = callPackage ../applications/misc/gosmore { stdenv = gcc10StdenvCompat; };

  gpsbabel = libsForQt5.callPackage ../applications/misc/gpsbabel { };

  gpsbabel-gui = gpsbabel.override {
    withGUI = true;
    withDoc = true;
  };

  gpu-screen-recorder = callPackage ../applications/video/gpu-screen-recorder {
    # rm me as soon as this package gains the support for cuda 11
    inherit (cudaPackages_10) cudatoolkit;
  };

  gpxlab = libsForQt5.callPackage ../applications/misc/gpxlab { };

  gpxsee-qt5 = libsForQt5.callPackage ../applications/misc/gpxsee { };

  gpxsee-qt6 = qt6Packages.callPackage ../applications/misc/gpxsee { };

  gpxsee = gpxsee-qt5;

  guvcview = libsForQt5.callPackage ../os-specific/linux/guvcview { };

  hachoir = with python3Packages; toPythonApplication hachoir;

  heimer = libsForQt5.callPackage ../applications/misc/heimer { };

  himalaya = callPackage ../applications/networking/mailreaders/himalaya {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  hledger = haskell.lib.compose.justStaticExecutables haskellPackages.hledger;
  hledger-iadd = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-iadd;
  hledger-interest = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-interest;
  hledger-ui = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-ui;
  hledger-web = haskell.lib.compose.justStaticExecutables haskellPackages.hledger-web;

  homebank = callPackage ../applications/office/homebank {
    gtk = gtk3;
  };

  hollywood = callPackage ../applications/misc/hollywood {
    inherit (python3Packages) pygments;
  };

  hors = callPackage ../development/tools/hors {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  hovercraft = python3Packages.callPackage ../applications/misc/hovercraft { };

  hpack = haskell.lib.compose.justStaticExecutables haskellPackages.hpack;

  hpmyroom = libsForQt5.callPackage ../applications/networking/hpmyroom { };

  xh = callPackage ../tools/networking/xh {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (nodePackages) hueadm;

  hugin = callPackage ../applications/graphics/hugin {
    wxGTK = wxGTK32;
  };

  huggle = libsForQt5.callPackage ../applications/misc/huggle {};

  hushboard = python3.pkgs.callPackage ../applications/audio/hushboard { };

  hydrogen = qt5.callPackage ../applications/audio/hydrogen { };
  /* hydrogen_0 = <moved> */ # Old stable, has GMKit.

  hyper-haskell-server-with-packages = callPackage ../development/tools/haskell/hyper-haskell/server.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = self: with self; [];
  };

  hyper-haskell = callPackage ../development/tools/haskell/hyper-haskell {
    hyper-haskell-server = hyper-haskell-server-with-packages.override {
      packages = self: with self; [
        hyper-extra diagrams csound-catalog
      ];
    };
    extra-packages = [ csound ];
  };

  hyperion-ng = libsForQt5.callPackage ../applications/video/hyperion-ng { };

  musikcube = callPackage ../applications/audio/musikcube {
    inherit (darwin.apple_sdk.frameworks) Cocoa SystemConfiguration;
  };

  mt32emu-qt = libsForQt5.callPackage ../applications/audio/munt/mt32emu-qt.nix { };

  pass2csv = python3Packages.callPackage ../tools/security/pass2csv {};

  pinboard = with python3Packages; toPythonApplication pinboard;

  pinboard-notes-backup = haskell.lib.compose.justStaticExecutables haskellPackages.pinboard-notes-backup;

  pixel2svg = python310Packages.callPackage ../tools/graphics/pixel2svg { };

  pixinsight = libsForQt5.callPackage ../applications/graphics/pixinsight { };

  pmbootstrap = python3Packages.callPackage ../tools/misc/pmbootstrap { };

  shepherd = nodePackages."@nerdwallet/shepherd";

  sosreport = python3Packages.callPackage ../applications/logging/sosreport { };

  spotifyd = callPackage ../applications/audio/spotifyd {
    withALSA = stdenv.isLinux;
    withPulseAudio = config.pulseaudio or stdenv.isLinux;
    withPortAudio = stdenv.isDarwin;
  };

  streamdeck-ui = libsForQt5.callPackage ../applications/misc/streamdeck-ui { };

  inherit (callPackages ../development/libraries/wlroots {})
    wlroots_0_14
    wlroots_0_15
    wlroots_0_16
    wlroots;

  sway-contrib = recurseIntoAttrs (callPackages ../applications/window-managers/sway/contrib.nix { });

  hikari = callPackage ../applications/window-managers/hikari {
    wlroots = wlroots_0_14;
  };

  i3 = callPackage ../applications/window-managers/i3 {
    xcb-util-cursor = if stdenv.isDarwin then xcb-util-cursor-HEAD else xcb-util-cursor;
  };

  i3-balance-workspace = python3Packages.callPackage ../applications/window-managers/i3/balance-workspace.nix { };

  i3-resurrect = python3Packages.callPackage ../applications/window-managers/i3/i3-resurrect.nix { };

  i3-swallow = python3Packages.callPackage ../applications/window-managers/i3/swallow.nix { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

  waybox = callPackage ../applications/window-managers/waybox {
    wlroots = wlroots_0_14;
  };

  ideamaker = libsForQt5.callPackage ../applications/misc/ideamaker { };

  ii = callPackage ../applications/networking/irc/ii {
    stdenv = gccStdenv;
  };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    python = python3;
    inherit (perlPackages.override { pkgs = pkgs // { imagemagick = imagemagickBig;}; }) ImageMagick;
  };

  iksemel = callPackage ../development/libraries/iksemel {
    texinfo = texinfo6_7; # Uses @setcontentsaftertitlepage, removed in 6.8.
  };

  imag = callPackage ../applications/misc/imag {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  imagemagick6_light = imagemagick6.override {
    bzip2Support = false;
    zlibSupport = false;
    libX11Support = false;
    libXtSupport = false;
    fontconfigSupport = false;
    freetypeSupport = false;
    ghostscriptSupport = false;
    libjpegSupport = false;
    djvulibreSupport = false;
    lcms2Support = false;
    openexrSupport = false;
    libpngSupport = false;
    liblqr1Support = false;
    librsvgSupport = false;
    libtiffSupport = false;
    libxml2Support = false;
    openjpegSupport = false;
    libwebpSupport = false;
    libheifSupport = false;
    libde265Support = false;
  };

  imagemagick6 = callPackage ../applications/graphics/ImageMagick/6.x.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Foundation;
  };

  imagemagick6Big = imagemagick6.override {
    ghostscriptSupport = true;
  };

  imagemagick_light = lowPrio (imagemagick.override {
    bzip2Support = false;
    zlibSupport = false;
    libX11Support = false;
    libXtSupport = false;
    fontconfigSupport = false;
    freetypeSupport = false;
    libjpegSupport = false;
    djvulibreSupport = false;
    lcms2Support = false;
    openexrSupport = false;
    libjxlSupport = false;
    libpngSupport = false;
    liblqr1Support = false;
    librsvgSupport = false;
    libtiffSupport = false;
    libxml2Support = false;
    openjpegSupport = false;
    libwebpSupport = false;
    libheifSupport = false;
  });

  imagemagick = lowPrio (callPackage ../applications/graphics/ImageMagick {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Foundation;
  });

  imagemagickBig = lowPrio (imagemagick.override {
    ghostscriptSupport = true;
  });

  inherit (nodePackages) imapnotify;

  img2pdf = with python3Packages; toPythonApplication img2pdf;

  imgbrd-grabber = qt5.callPackage ../applications/graphics/imgbrd-grabber {
    typescript = nodePackages.typescript;
  };

  imgp = python3Packages.callPackage ../applications/graphics/imgp { };

  inkcut = libsForQt5.callPackage ../applications/misc/inkcut { };

  inkscape = callPackage ../applications/graphics/inkscape {
    lcms = lcms2;
  };

  inkscape-extensions = recurseIntoAttrs (callPackages ../applications/graphics/inkscape/extensions.nix {});

  inlyne = callPackage ../applications/misc/inlyne {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) AppKit ApplicationServices CoreFoundation CoreGraphics CoreServices CoreText CoreVideo Foundation Metal QuartzCore Security;
  };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5_1;
  };

  ipe = libsForQt5.callPackage ../applications/graphics/ipe {
    ghostscript = ghostscriptX;
    texlive = texlive.combine { inherit (texlive) scheme-small; };
    lua5 = lua5_3;
  };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  bip = callPackage ../applications/networking/irc/bip {
    openssl = openssl_1_1;
  };

  jabcode = callPackage ../development/libraries/jabcode { };

  jabcode-writer = callPackage ../development/libraries/jabcode {
    subproject = "writer";
  };

  jabcode-reader = callPackage ../development/libraries/jabcode {
    subproject = "reader";
  };

  jabref = callPackage ../applications/office/jabref {
    jdk = javaPackages.compiler.openjdk18;
  };

  jackmix = libsForQt5.callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = jackmix.override { jack = jack1; };

  jameica = callPackage ../applications/office/jameica {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  jigdo = callPackage ../applications/misc/jigdo { stdenv = gcc10StdenvCompat; };

  js8call = qt5.callPackage ../applications/radio/js8call { };

  kapow = libsForQt5.callPackage ../applications/misc/kapow { };

  kchmviewer = libsForQt5.callPackage ../applications/misc/kchmviewer { };

  okteta = libsForQt5.callPackage ../applications/editors/okteta { };

  k4dirstat = libsForQt5.callPackage ../applications/misc/k4dirstat { };

  kbibtex = libsForQt5.callPackage ../applications/office/kbibtex { };

  kaidan = libsForQt5.callPackage ../applications/networking/instant-messengers/kaidan { };

  kdeltachat = libsForQt5.callPackage ../applications/networking/instant-messengers/kdeltachat { };

  kexi = libsForQt5.callPackage ../applications/office/kexi { };

  keyfinder = libsForQt5.callPackage ../applications/audio/keyfinder { };

  kgraphviewer = libsForQt5.callPackage ../applications/graphics/kgraphviewer { };

  kid3 = libsForQt5.callPackage ../applications/audio/kid3 { };

  kile = libsForQt5.callPackage ../applications/editors/kile { };

  kitsas = libsForQt5.callPackage ../applications/office/kitsas { };

  kiwix = libsForQt5.callPackage ../applications/misc/kiwix { };

  klayout = libsForQt5.callPackage ../applications/misc/klayout { };

  klee = callPackage ../applications/science/logic/klee (with llvmPackages_11; {
    clang = clang;
    llvm = llvm;
    stdenv = stdenv;
  });

  kmetronome = libsForQt5.callPackage ../applications/audio/kmetronome { };

  kmplayer = libsForQt5.callPackage ../applications/video/kmplayer { };

  kmymoney = libsForQt5.callPackage ../applications/office/kmymoney { };

  kotatogram-desktop = libsForQt5.callPackage ../applications/networking/instant-messengers/telegram/kotatogram-desktop {
    inherit (darwin.apple_sdk_11_0.frameworks) Cocoa CoreFoundation CoreServices CoreText CoreGraphics
      CoreMedia OpenGL AudioUnit ApplicationServices Foundation AGL Security SystemConfiguration
      Carbon AudioToolbox VideoToolbox VideoDecodeAcceleration AVFoundation CoreAudio CoreVideo
      CoreMediaIO QuartzCore AppKit CoreWLAN WebKit IOKit GSS MediaPlayer IOSurface Metal MetalKit;

    # C++20 is required, aarch64 has gcc 9 by default
    stdenv = if stdenv.isDarwin
      then darwin.apple_sdk_11_0.stdenv
      else if stdenv.isAarch64 then gcc10Stdenv else stdenv;

    # tdesktop has random crashes when jemalloc is built with gcc.
    # Apparently, it triggers some bug due to usage of gcc's builtin
    # functions like __builtin_ffsl by jemalloc when it's built with gcc.
    jemalloc = (jemalloc.override { stdenv = clangStdenv; }).overrideAttrs(_: {
      # no idea how to fix the tests :(
      doCheck = false;
    });

    abseil-cpp = abseil-cpp_202111;
  };

  krita = libsForQt5.callPackage ../applications/graphics/krita { };

  ktimetracker = libsForQt5.callPackage ../applications/office/ktimetracker { };

  kubectl-convert = kubectl.convert;

  linkerd = callPackage ../applications/networking/cluster/linkerd { };
  linkerd_edge = callPackage ../applications/networking/cluster/linkerd/edge.nix { };
  linkerd_stable = linkerd;

  kuma = callPackage ../applications/networking/cluster/kuma { isFull = true; };
  kuma-experimental = callPackage ../applications/networking/cluster/kuma {
    isFull = true;
    enableGateway = true;
    pname = "kuma-experimental";
  };
  kumactl = callPackage ../applications/networking/cluster/kuma {
    components = ["kumactl"];
    pname = "kumactl";
  };
  kuma-cp = callPackage ../applications/networking/cluster/kuma {
    components = ["kuma-cp"];
    pname = "kuma-cp";
  };
  kuma-dp = callPackage ../applications/networking/cluster/kuma {
    components = ["kuma-dp"];
    pname = "kuma-dp";
  };
  kuma-prometheus-sd = callPackage ../applications/networking/cluster/kuma {
    components = ["kuma-prometheus-sd"];
    pname = "kuma-prometheus-sd";
  };

  kubernetes-helm-wrapped = wrapHelm kubernetes-helm {};

  kubernetes-helmPlugins = dontRecurseIntoAttrs (callPackage ../applications/networking/cluster/helm/plugins { });

  kup = libsForQt5.callPackage ../applications/misc/kup { };

  kvirc = libsForQt5.callPackage ../applications/networking/irc/kvirc { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladybird = qt6Packages.callPackage ../applications/networking/browsers/ladybird {
    stdenv = if stdenv.isDarwin then llvmPackages_14.stdenv else gcc11Stdenv;
  };

  leo-editor = libsForQt5.callPackage ../applications/editors/leo-editor { };

  librecad = libsForQt5.callPackage ../applications/misc/librecad {
    boost = boost175;
  };

  libreoffice-bin = callPackage ../applications/office/libreoffice/darwin { };

  libreoffice = hiPrio libreoffice-still;

  libreoffice-unwrapped = (hiPrio libreoffice-still).libreoffice;

  libreoffice-args = {
    inherit (perlPackages) ArchiveZip IOCompress;
    zip = zip.override { enableNLS = false; };
    fontsConf = makeFontsConf {
      fontDirectories = [
        carlito dejavu_fonts
        freefont_ttf xorg.fontmiscmisc
        liberation_ttf_v1
        liberation_ttf_v2
      ];
    };
    clucene_core = clucene_core_2;
    lcms = lcms2;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  };

  libreoffice-qt = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = libsForQt5.callPackage ../applications/office/libreoffice
      (libreoffice-args // {
        kdeIntegration = true;
        variant = "fresh";
      });
  });

  libreoffice-fresh = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = callPackage ../applications/office/libreoffice
      (libreoffice-args // {
        variant = "fresh";
      });
  });
  libreoffice-fresh-unwrapped = libreoffice-fresh.libreoffice;

  libreoffice-still = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = callPackage ../applications/office/libreoffice
      (libreoffice-args // {
        variant = "still";
      });
  });
  libreoffice-still-unwrapped = libreoffice-still.libreoffice;

  libresprite = callPackage ../applications/editors/libresprite {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Foundation;
  };

  littlegptracker = callPackage ../applications/audio/littlegptracker {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  lightburn = libsForQt5.callPackage ../applications/graphics/lightburn { };

  linphone = libsForQt5.callPackage ../applications/networking/instant-messengers/linphone { };

  llpp = callPackage ../applications/misc/llpp {
    inherit (ocaml-ng.ocamlPackages_4_09) ocaml;
  };

  lmms = libsForQt5.callPackage ../applications/audio/lmms {
    lame = null;
    libsoundio = null;
    portaudio = null;
  };

  lsd2dsl = libsForQt5.callPackage ../applications/misc/lsd2dsl { };

  lsp-plugins = callPackage ../applications/audio/lsp-plugins { php = php81; };

  luminanceHDR = libsForQt5.callPackage ../applications/graphics/luminance-hdr { };

  handbrake = callPackage ../applications/video/handbrake {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox Foundation VideoToolbox;
    inherit (darwin) libobjc;
  };

  luakit = callPackage ../applications/networking/browsers/luakit {
    inherit (luajitPackages) luafilesystem;
  };

  luddite = with python3Packages; toPythonApplication luddite;

  goobook = with python3Packages; toPythonApplication goobook;

  lumail = callPackage ../applications/networking/mailreaders/lumail {
    lua = lua5_1;
  };

  lutris-unwrapped = python3.pkgs.callPackage ../applications/misc/lutris {
    wine = wineWowPackages.staging;
  };
  lutris = callPackage ../applications/misc/lutris/fhsenv.nix {
    buildFHSUserEnv = buildFHSUserEnvBubblewrap;
  };
  lutris-free = lutris.override {
    steamSupport = false;
  };

  lxi-tools = callPackage ../tools/networking/lxi-tools { };
  lxi-tools-gui = callPackage ../tools/networking/lxi-tools { withGui = true; };

  lyx = libsForQt5.callPackage ../applications/misc/lyx { };

  macdylibbundler = callPackage ../development/tools/misc/macdylibbundler { inherit (darwin) cctools; };

  magic-wormhole = with python3Packages; toPythonApplication magic-wormhole;

  magic-wormhole-rs = callPackage ../tools/networking/magic-wormhole-rs {
    inherit (darwin.apple_sdk.frameworks) Security AppKit;
  };

  magnetophonDSP = lib.recurseIntoAttrs {
    CharacterCompressor = callPackage ../applications/audio/magnetophonDSP/CharacterCompressor { };
    CompBus = callPackage ../applications/audio/magnetophonDSP/CompBus { };
    ConstantDetuneChorus  = callPackage ../applications/audio/magnetophonDSP/ConstantDetuneChorus { };
    faustCompressors =  callPackage ../applications/audio/magnetophonDSP/faustCompressors { };
    LazyLimiter = callPackage ../applications/audio/magnetophonDSP/LazyLimiter { };
    MBdistortion = callPackage ../applications/audio/magnetophonDSP/MBdistortion { };
    pluginUtils = callPackage ../applications/audio/magnetophonDSP/pluginUtils  { };
    RhythmDelay = callPackage ../applications/audio/magnetophonDSP/RhythmDelay { };
    VoiceOfFaust = callPackage ../applications/audio/magnetophonDSP/VoiceOfFaust { };
    shelfMultiBand = callPackage ../applications/audio/magnetophonDSP/shelfMultiBand  { };
  };

  mandelbulber = libsForQt5.callPackage ../applications/graphics/mandelbulber { };

  mapmap = libsForQt5.callPackage ../applications/video/mapmap { };

  markmind = callPackage ../applications/misc/markmind {
    electron = electron_9;
  };

  mastodon-bot = nodePackages.mastodon-bot;

  matrixcli = callPackage ../applications/networking/instant-messengers/matrixcli {
    inherit (python3Packages) buildPythonApplication buildPythonPackage
      pygobject3 pytest-runner requests responses pytest python-olm
      canonicaljson;
  };

  matrix-commander = python3Packages.callPackage ../applications/networking/instant-messengers/matrix-commander { };

  mdzk = callPackage ../applications/misc/mdzk {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mediaelch = mediaelch-qt5;
  mediaelch-qt5 = libsForQt5.callPackage ../applications/misc/mediaelch { };
  mediaelch-qt6 = qt6Packages.callPackage ../applications/misc/mediaelch { };

  mediathekview = callPackage ../applications/video/mediathekview { jre = temurin-bin-17; };

  meli = callPackage ../applications/networking/mailreaders/meli {
    openssl = openssl_1_1;
  };

  melmatcheq.lv2 = callPackage ../applications/audio/melmatcheq.lv2 { };

  mendeley = libsForQt5.callPackage ../applications/office/mendeley {
    gconf = gnome2.GConf;
  };

  menyoki = callPackage ../applications/graphics/menyoki {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  sapling = callPackage ../applications/version-management/sapling {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Security;
  };

  mercurialFull = mercurial.override { fullBuild = true; };

  merkaartor = libsForQt5.callPackage ../applications/misc/merkaartor { };

  meshlab = libsForQt5.callPackage ../applications/graphics/meshlab { };

  mhwaveedit = callPackage ../applications/audio/mhwaveedit {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  michabo = libsForQt5.callPackage ../applications/misc/michabo { };

  midori = wrapFirefox midori-unwrapped { };

  miniaudicle = callPackage ../applications/audio/miniaudicle { stdenv = gcc10StdenvCompat; };

  minikube = callPackage ../applications/networking/cluster/minikube {
    inherit (darwin.apple_sdk.frameworks) vmnet;
  };

  minitube = libsForQt5.callPackage ../applications/video/minitube { };

  mixxx = libsForQt5.callPackage ../applications/audio/mixxx { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey {
    ocamlPackages = ocaml-ng.mkOcamlPackages (ocaml-ng.ocamlPackages_4_13.ocaml.override {
      unsafeStringSupport = true;
    });
  };

  mmex = callPackage ../applications/office/mmex {
    inherit (darwin) libobjc;
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  mmlgui = callPackage ../applications/audio/mmlgui {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    libvgm = libvgm.override {
      withAllEmulators = false;
      emulators = [
        "_PRESET_SMD"
      ];
      enableLibplayer = false;
    };
  };

  moc = callPackage ../applications/audio/moc {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
    boost = boost170;
  };

  monotoneViz = callPackage ../applications/version-management/monotone-viz {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  monitor = callPackage ../applications/system/monitor {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  moolticute = libsForQt5.callPackage ../applications/misc/moolticute { };

  moonlight-qt = libsForQt5.callPackage ../applications/misc/moonlight-qt { };

  mopidyPackages = callPackages ../applications/audio/mopidy {
    python = python3;
  };

  inherit (mopidyPackages)
    mopidy
    mopidy-bandcamp
    mopidy-iris
    mopidy-jellyfin
    mopidy-local
    mopidy-moped
    mopidy-mopify
    mopidy-mpd
    mopidy-mpris
    mopidy-muse
    mopidy-musicbox-webclient
    mopidy-notify
    mopidy-podcast
    mopidy-scrobbler
    mopidy-somafm
    mopidy-soundcloud
    mopidy-subidy
    mopidy-tidal
    mopidy-tunein
    mopidy-youtube
    mopidy-ytmusic;

  edgetx = libsForQt5.callPackage ../applications/misc/edgetx { };

  mpg123 = callPackage ../applications/audio/mpg123 {
    inherit (darwin.apple_sdk.frameworks) AudioUnit AudioToolbox;
    jack = libjack2;
  };

  mpc-cli = callPackage ../applications/audio/mpc {
    inherit (python3Packages) sphinx;
  };

  jujutsu = callPackage ../applications/version-management/jujutsu {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  pragha = libsForQt5.callPackage ../applications/audio/pragha { };

  rofi-rbw = python3Packages.callPackage ../applications/misc/rofi-rbw { };

  # a somewhat more maintained fork of ympd

  norouter = callPackage ../tools/networking/norouter {
    buildGoModule = buildGo118Module; # tests fail with 1.19
  };

  mpc-qt = libsForQt5.callPackage ../applications/video/mpc-qt { };

  mplayer = callPackage ../applications/video/mplayer ({
    libdvdnav = libdvdnav_4_2_1;
  } // (config.mplayer or {}));

  mpv-unwrapped = callPackage ../applications/video/mpv {
    inherit lua;
  };

  # Wraps without trigerring a rebuild
  mpv = wrapMpv mpv-unwrapped {};

  mpvScripts = recurseIntoAttrs {
    autoload = callPackage ../applications/video/mpv/scripts/autoload.nix {};
    convert = callPackage ../applications/video/mpv/scripts/convert.nix {};
    inhibit-gnome = callPackage ../applications/video/mpv/scripts/inhibit-gnome.nix {};
    mpris = callPackage ../applications/video/mpv/scripts/mpris.nix {};
    mpv-playlistmanager = callPackage ../applications/video/mpv/scripts/mpv-playlistmanager.nix {};
    mpvacious = callPackage ../applications/video/mpv/scripts/mpvacious.nix {};
    simple-mpv-webui = callPackage ../applications/video/mpv/scripts/simple-mpv-webui.nix {};
    sponsorblock = callPackage ../applications/video/mpv/scripts/sponsorblock.nix {};
    thumbnail = callPackage ../applications/video/mpv/scripts/thumbnail.nix { };
    vr-reversal = callPackage ../applications/video/mpv/scripts/vr-reversal.nix {};
    youtube-quality = callPackage ../applications/video/mpv/scripts/youtube-quality.nix { };
    cutter = callPackage ../applications/video/mpv/scripts/cutter.nix { };
  };

  mu-repo = python3Packages.callPackage ../applications/misc/mu-repo { };

  murmur = (callPackages ../applications/networking/mumble {
      avahi = avahi-compat;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
      grpcSupport = config.murmur.grpcSupport or true;
      qt5 = qt5_openssl_1_1;
    }).murmur;

  mumble = (callPackages ../applications/networking/mumble {
      avahi = avahi-compat;
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      qt5 = qt5_openssl_1_1;
    }).mumble;

  mumble_overlay = callPackage ../applications/networking/mumble/overlay.nix {
    mumble_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.mumble
      else null;
  };

  mup = callPackage ../applications/audio/mup {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  # TODO: we should probably merge these 2
  musescore =
    if stdenv.isDarwin then
      callPackage ../applications/audio/musescore/darwin.nix { }
    else
      libsForQt5.callPackage ../applications/audio/musescore { };

  mwic = callPackage ../applications/misc/mwic {
    pythonPackages = python3Packages;
  };

  netmaker = callPackage ../applications/networking/netmaker {subPackages = ["."];};
  netmaker-full = callPackage ../applications/networking/netmaker {};

  newsflash = callPackage ../applications/networking/feedreaders/newsflash {
    webkitgtk = webkitgtk_5_0;
  };

  nncp = darwin.apple_sdk_11_0.callPackage ../tools/misc/nncp { };

  nootka = qt5.callPackage ../applications/audio/nootka { };

  osm2pgsql = callPackage ../tools/misc/osm2pgsql {
    # fmt_9 is not supported: https://github.com/openstreetmap/osm2pgsql/issues/1859
    fmt = fmt_8;
  };

  ostinato = libsForQt5.callPackage ../applications/networking/ostinato { };

  p4 = callPackage ../applications/version-management/p4 {
    inherit (darwin.apple_sdk.frameworks) CoreServices Foundation Security;
    openssl = openssl_1_1;
  };

  pc-ble-driver = callPackage ../development/libraries/pc-ble-driver {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcmanfm-qt = lxqt.pcmanfm-qt;

  pdfmixtool = libsForQt5.callPackage ../applications/office/pdfmixtool { };

  pijuice = with python3Packages; toPythonApplication pijuice;

  pinegrow6 = callPackage ../applications/editors/pinegrow { pinegrowVersion = "6"; };

  pinegrow = callPackage ../applications/editors/pinegrow { };

  pipe-viewer = perlPackages.callPackage ../applications/video/pipe-viewer {};

  playonlinux = callPackage ../applications/misc/playonlinux
    { stdenv = stdenv_32bit; };

  pleroma-bot = python3Packages.callPackage ../development/python-modules/pleroma-bot { };

  polybar = callPackage ../applications/misc/polybar { };

  polybarFull = callPackage ../applications/misc/polybar {
    alsaSupport = true;
    githubSupport = true;
    mpdSupport = true;
    pulseSupport  = true;
    iwSupport = false;
    nlSupport = true;
    i3Support = true;
  };

  polyphone = libsForQt5.callPackage ../applications/audio/polyphone { };

  portfolio = callPackage ../applications/office/portfolio {
    jre = openjdk11;
  };

  pyright = nodePackages.pyright;

  rqbit = callPackage ../applications/networking/p2p/rqbit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rssguard = libsForQt5.callPackage ../applications/networking/feedreaders/rssguard { };

  shotcut = libsForQt5.callPackage ../applications/video/shotcut { };

  shogun = callPackage ../applications/science/machine-learning/shogun {
    opencv = opencv3;
  };

  smplayer = libsForQt5.callPackage ../applications/video/smplayer { };

  smtube = libsForQt5.callPackage ../applications/video/smtube {};

  softmaker-office = callPackage ../applications/office/softmaker/softmaker_office.nix {};

  spacegun = callPackage ../applications/networking/cluster/spacegun {};

  synapse-bt = callPackage ../applications/networking/p2p/synapse-bt {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
    openssl = openssl_1_1;
  };

  taxi-cli = with python3Packages; toPythonApplication taxi;

  mpop = callPackage ../applications/networking/mpop {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  msmtp = callPackage ../applications/networking/msmtp {
    inherit (darwin.apple_sdk.frameworks) Security;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
  };

  muso = callPackage ../applications/audio/muso {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  diffpdf = libsForQt5.callPackage ../applications/misc/diffpdf { };

  diff-pdf = callPackage ../applications/misc/diff-pdf {
    wxGTK = wxGTK32;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  mythtv = libsForQt5.callPackage ../applications/video/mythtv { };

  netbeans = callPackage ../applications/editors/netbeans {
    jdk = jdk17;
  };

  ncspot = callPackage ../applications/audio/ncspot {
    withALSA = stdenv.isLinux;
    withPulseAudio = config.pulseaudio or stdenv.isLinux;
    withPortAudio = stdenv.isDarwin;
    withMPRIS = stdenv.isLinux;
  };

  nheko = libsForQt5.callPackage ../applications/networking/instant-messengers/nheko {
    # https://github.com/NixOS/nixpkgs/issues/201254
    stdenv = if stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU then gcc11Stdenv else stdenv;
  };

  nomacs = libsForQt5.callPackage ../applications/graphics/nomacs { };

  notepad-next = libsForQt5.callPackage ../applications/editors/notepad-next { };

  notepadqq = libsForQt5.callPackage ../applications/editors/notepadqq { };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    gmime = gmime3;
    pythonPackages = python3Packages;
  };

  nufraw = callPackage ../applications/graphics/nufraw { };

  nufraw-thumbnailer = callPackage ../applications/graphics/nufraw {
    addThumbnailer = true;
  };

  nova-filters =  callPackage ../applications/audio/nova-filters {
    boost = boost172;
  };

  gnome-obfuscate = callPackage ../applications/graphics/gnome-obfuscate {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  obs-studio = qt6Packages.callPackage ../applications/video/obs-studio {
    ffmpeg_4 = ffmpeg-full;
  };

  obs-studio-plugins = recurseIntoAttrs (callPackage ../applications/video/obs-studio/plugins {});

  inherit (python3Packages.callPackage ../applications/networking/onionshare { }) onionshare onionshare-gui;

  openambit = qt5.callPackage ../applications/misc/openambit { };

  openbox-menu = callPackage ../applications/misc/openbox-menu {
    stdenv = gccStdenv;
  };

  openbrf = libsForQt5.callPackage ../applications/misc/openbrf { };

  opencpn = darwin.apple_sdk_11_0.callPackage ../applications/misc/opencpn {
    inherit (darwin) DarwinTools;
    inherit (darwin.apple_sdk_11_0.frameworks) AppKit;
  };

  openimageio_1 = callPackage ../development/libraries/openimageio/1.x.nix {
    boost = boost175;
  };

  openimageio = darwin.apple_sdk_11_0.callPackage ../development/libraries/openimageio {
    fmt = fmt_8;
  };

  open-music-kontrollers = lib.recurseIntoAttrs {
    eteroj = callPackage ../applications/audio/open-music-kontrollers/eteroj.nix { };
    jit = callPackage ../applications/audio/open-music-kontrollers/jit.nix { };
    mephisto = callPackage ../applications/audio/open-music-kontrollers/mephisto.nix { };
    midi_matrix = callPackage ../applications/audio/open-music-kontrollers/midi_matrix.nix { };
    moony = callPackage ../applications/audio/open-music-kontrollers/moony.nix { };
    orbit = callPackage ../applications/audio/open-music-kontrollers/orbit.nix { };
    patchmatrix = callPackage ../applications/audio/open-music-kontrollers/patchmatrix.nix { };
    router = callPackage ../applications/audio/open-music-kontrollers/router.nix { };
    sherlock = callPackage ../applications/audio/open-music-kontrollers/sherlock.nix { };
    synthpod = callPackage ../applications/audio/open-music-kontrollers/synthpod.nix { };
    vm = callPackage ../applications/audio/open-music-kontrollers/vm.nix { };
  };

  openrsync = darwin.apple_sdk_11_0.callPackage ../applications/networking/sync/openrsync { };

  openscad = libsForQt5.callPackage ../applications/graphics/openscad {};

  opentimestamps-client = python3Packages.callPackage ../tools/misc/opentimestamps-client {};

  opentoonz = let
    opentoonz-libtiff = callPackage ../applications/graphics/opentoonz/libtiff.nix { };
  in qt5.callPackage ../applications/graphics/opentoonz {
    libtiff = opentoonz-libtiff;
    opencv = opencv.override { libtiff = opentoonz-libtiff; };
  };

  opentx = libsForQt5.callPackage ../applications/misc/opentx { };

  orca = python3Packages.callPackage ../applications/misc/orca {
    inherit pkg-config;
  };

  organicmaps = libsForQt5.callPackage ../applications/misc/organicmaps { };

  osm2xmap = callPackage ../applications/misc/osm2xmap {
    libyamlcpp = libyamlcpp_0_3;
  };

  owofetch = callPackage ../tools/misc/owofetch {
    inherit (darwin.apple_sdk.frameworks) Foundation DiskArbitration;
  };

  openrazer-daemon = python3Packages.toPythonApplication python3Packages.openrazer-daemon;

  orpie = callPackage ../applications/misc/orpie {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  osmscout-server = libsForQt5.callPackage ../applications/misc/osmscout-server { };

  pantalaimon = python3Packages.callPackage ../applications/networking/instant-messengers/pantalaimon { };

  pantalaimon-headless = python3Packages.callPackage ../applications/networking/instant-messengers/pantalaimon {
    enableDbusUi = false;
  };

  paraview = libsForQt5.callPackage ../applications/graphics/paraview { };

  jpsxdec = callPackage ../tools/games/jpsxdec {
    jdk = openjdk8;
  };

  pekwm = callPackage ../applications/window-managers/pekwm {
    awk = gawk;
    grep = gnugrep;
    sed = gnused;
  };

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome2) libgnomecanvas;
  };

  pdfpc = callPackage ../applications/misc/pdfpc {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-libav;
  };

  peaclock = callPackage ../applications/misc/peaclock {
    stdenv = gccStdenv;
  };

  peertube = callPackage ../servers/peertube {
    nodejs = nodejs-16_x;
  };

  photoqt = libsForQt5.callPackage ../applications/graphics/photoqt { };

  photoflare = libsForQt5.callPackage ../applications/graphics/photoflare { };

  phototonic = libsForQt5.callPackage ../applications/graphics/phototonic { };

  pianobooster = qt5.callPackage ../applications/audio/pianobooster { };

  picocom = callPackage ../tools/misc/picocom {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    withOpenssl = config.pidgin.openssl or true;
    withGnutls = config.pidgin.gnutls or false;
    plugins = [];
  };

  pidgin-latex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    texLive = texlive.combined.scheme-basic;
  };

  pithos = callPackage ../applications/audio/pithos {
    pythonPackages = python3Packages;
  };

  pineapple-pictures = libsForQt5.callPackage ../applications/graphics/pineapple-pictures { };

  piston-cli = callPackage ../tools/misc/piston-cli { python3Packages = python39Packages; };

  plater = libsForQt5.callPackage ../applications/misc/plater { };

  plex-media-player = libsForQt5.callPackage ../applications/video/plex-media-player { };

  plex-mpv-shim = python3Packages.callPackage ../applications/video/plex-mpv-shim { };

  plover = recurseIntoAttrs (libsForQt5.callPackage ../applications/misc/plover { });

  pokefinder = qt6Packages.callPackage ../tools/games/pokefinder { };

  poezio = python3Packages.poezio;

  pomotroid = callPackage ../applications/misc/pomotroid {
    electron = electron_9;
  };

  pothos = libsForQt5.callPackage ../applications/radio/pothos { };

  qiv = callPackage ../applications/graphics/qiv {
    imlib2 = imlib2Full;
  };

  processing = callPackage ../applications/graphics/processing {
    jdk = oraclejdk8;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules

  profanity = callPackage ../applications/networking/instant-messengers/profanity ({
  } // (config.profanity or {}));

  protonvpn-cli = python3Packages.callPackage ../applications/networking/protonvpn-cli { };
  protonvpn-cli_2 = python3Packages.callPackage ../applications/networking/protonvpn-cli/2.nix { };

  protonvpn-gui = python3Packages.callPackage ../applications/networking/protonvpn-gui { };

  psi = libsForQt5.callPackage ../applications/networking/instant-messengers/psi { };

  psi-plus = libsForQt5.callPackage ../applications/networking/instant-messengers/psi-plus { };

  pulseview = libsForQt5.callPackage ../applications/science/electronics/pulseview { };

  puredata-with-plugins = plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  pure-maps = libsForQt5.callPackage ../applications/misc/pure-maps { };

  qbittorrent = libsForQt5.callPackage ../applications/networking/p2p/qbittorrent { };
  qbittorrent-nox = qbittorrent.override {
    guiSupport = false;
  };

  qcad = libsForQt5.callPackage ../applications/misc/qcad { };

  qcomicbook = libsForQt5.callPackage ../applications/graphics/qcomicbook { };

  qelectrotech = libsForQt5.callPackage ../applications/misc/qelectrotech { };

  eiskaltdcpp = libsForQt5.callPackage ../applications/networking/p2p/eiskaltdcpp { };

  qdirstat = libsForQt5.callPackage ../applications/misc/qdirstat {};

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor vmnet;
    inherit (darwin.stubs) rez setfile;
    inherit (darwin) sigtool;
  };

  qgroundcontrol = libsForQt5.callPackage ../applications/science/robotics/qgroundcontrol { };

  qjackctl = libsForQt5.callPackage ../applications/audio/qjackctl { };

  qimgv = libsForQt5.callPackage ../applications/graphics/qimgv { };

  qlandkartegt = libsForQt5.callPackage ../applications/misc/qlandkartegt {
    gdal = gdal.override {
      libgeotiff = libgeotiff.override { proj = proj_7; };
      libspatialite = libspatialite.override { proj = proj_7; };
      proj = proj_7;
    };
    proj = proj_7;
  };

  qmediathekview = libsForQt5.callPackage ../applications/video/qmediathekview { };

  qmplay2 = libsForQt5.callPackage ../applications/video/qmplay2 { };

  qmidinet = libsForQt5.callPackage ../applications/audio/qmidinet { };

  qmmp = qt6Packages.callPackage ../applications/audio/qmmp { };

  qnotero = libsForQt5.callPackage ../applications/office/qnotero { };

  qpwgraph = libsForQt5.callPackage ../applications/audio/qpwgraph { };

  qsampler = libsForQt5.callPackage ../applications/audio/qsampler { };

  qscreenshot = callPackage ../applications/graphics/qscreenshot {
    inherit (darwin.apple_sdk.frameworks) Carbon;
    qt = qt4;
  };

  qsstv = qt5.callPackage ../applications/radio/qsstv { };

  qsyncthingtray = libsForQt5.callPackage ../applications/misc/qsyncthingtray { };

  qstopmotion = libsForQt5.callPackage ../applications/video/qstopmotion {
    guvcview = guvcview.override {
      useQt = true;
      useGtk = false;
    };
  };

  qsudo = libsForQt5.callPackage ../applications/misc/qsudo { };

  qsynth = libsForQt5.callPackage ../applications/audio/qsynth { };

  qtbitcointrader = libsForQt5.callPackage ../applications/misc/qtbitcointrader { };

  qtchan = libsForQt5.callPackage ../applications/networking/browsers/qtchan { };

  qtemu = libsForQt5.callPackage ../applications/virtualization/qtemu { };

  qtox = libsForQt5.callPackage ../applications/networking/instant-messengers/qtox {
    inherit (darwin.apple_sdk.frameworks) AVFoundation;
  };

  qtpass = libsForQt5.callPackage ../applications/misc/qtpass { };

  qtractor = libsForQt5.callPackage ../applications/audio/qtractor { };

  quassel = libsForQt5.callPackage ../applications/networking/irc/quassel { };

  quasselClient = quassel.override {
    monolithic = false;
    client = true;
    tag = "-client-kf5";
  };

  quasselDaemon = quassel.override {
    monolithic = false;
    enableDaemon = true;
    withKDE = false;
    tag = "-daemon-qt5";
  };

  quisk = python38Packages.callPackage ../applications/radio/quisk { };

  quiterss = libsForQt5.callPackage ../applications/networking/newsreaders/quiterss {};

  quodlibet = callPackage ../applications/audio/quodlibet {
    inherit (gnome) adwaita-icon-theme;
    kakasi = null;
    keybinder3 = null;
    libappindicator-gtk3 = null;
    libmodplug = null;
  };

  quodlibet-without-gst-plugins = quodlibet.override {
    tag = "-without-gst-plugins";
    withGstPlugins = false;
  };

  quodlibet-xine = quodlibet.override {
    tag = "-xine";
    withGstreamerBackend = false;
    withXineBackend = true;
  };

  quodlibet-full = quodlibet.override {
    inherit gtksourceview webkitgtk;
    kakasi = kakasi;
    keybinder3 = keybinder3;
    libappindicator-gtk3 = libappindicator-gtk3;
    libmodplug = libmodplug;
    tag = "-full";
    withDbusPython = true;
    withMusicBrainzNgs = true;
    withPahoMqtt = true;
    withPyInotify = true;
    withPypresence = true;
    withSoco = true;
  };

  quodlibet-xine-full = quodlibet-full.override {
    tag = "-xine-full";
    withGstreamerBackend = false;
    withXineBackend = true;
  };

  qutebrowser = libsForQt5.callPackage ../applications/networking/browsers/qutebrowser { };
  qutebrowser-qt6 = callPackage ../applications/networking/browsers/qutebrowser {
    inherit (qt6Packages) qtbase qtwebengine wrapQtAppsHook qtwayland;
  };

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  radiotray-ng = callPackage ../applications/audio/radiotray-ng {
    wxGTK = wxGTK30;
  };

  rapid-photo-downloader = libsForQt5.callPackage ../applications/graphics/rapid-photo-downloader { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
  };

  rclone-browser = libsForQt5.callPackage ../applications/networking/sync/rclone/browser.nix { };

  rdedup = callPackage ../tools/backup/rdedup {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  reaper = callPackage ../applications/audio/reaper {
    jackLibrary = libjack2; # Another option is "pipewire.jack".
  };

  reddsaver = callPackage ../applications/misc/reddsaver {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rednotebook = python3Packages.callPackage ../applications/editors/rednotebook { };

  restique = libsForQt5.callPackage ../applications/backup/restique { };

  retroshare = libsForQt5.callPackage ../applications/networking/p2p/retroshare { };

  rgp = libsForQt5.callPackage ../development/tools/rgp { };

  ricochet = libsForQt5.callPackage ../applications/networking/instant-messengers/ricochet { };

  ripcord = if stdenv.isLinux then
    qt5.callPackage ../applications/networking/instant-messengers/ripcord { }
  else
    callPackage ../applications/networking/instant-messengers/ripcord/darwin.nix { };

  rofi = callPackage ../applications/misc/rofi/wrapper.nix { };
  rofi-wayland = callPackage ../applications/misc/rofi/wrapper.nix {
    rofi-unwrapped = rofi-wayland-unwrapped;
  };

  rofimoji = callPackage ../applications/misc/rofimoji {
    inherit (python3Packages) buildPythonApplication configargparse;
  };

  rstudio = libsForQt5.callPackage ../applications/editors/rstudio {
    jdk = jdk8;
  };

  rstudio-server = rstudio.override { server = true; };

  rsync = callPackage ../applications/networking/sync/rsync (config.rsync or {});

  # librtlsdr is a friendly fork with additional features

  rucredstash = callPackage ../tools/security/rucredstash {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  rusty-psn-gui = rusty-psn.override { withGui = true; };

  rymcast = callPackage ../applications/audio/rymcast {
    inherit (gnome) zenity;
  };

  rymdport = callPackage ../applications/networking/rymdport {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  sayonara = libsForQt5.callPackage ../applications/audio/sayonara { };

  scantailor-advanced = libsForQt5.callPackage ../applications/graphics/scantailor/advanced.nix { };

  scribus_1_4 = callPackage ../applications/office/scribus/1_4.nix {
    inherit (gnome2) libart_lgpl;
  };

  scribus_1_5 = libsForQt5.callPackage ../applications/office/scribus/default.nix { };
  scribus = scribus_1_5;

  seafile-client = libsForQt5.callPackage ../applications/networking/seafile-client { };

  seq66 = qt5.callPackage ../applications/audio/seq66 { };

  sfxr-qt = libsForQt5.callPackage ../applications/audio/sfxr-qt { };

  simple-scan = gnome.simple-scan;

  sioyek = callPackage ../applications/misc/sioyek {
    inherit (libsForQt5) qmake qt3d qtbase wrapQtAppsHook;
  };

  sky = libsForQt5.callPackage ../applications/networking/instant-messengers/sky {
    libjpeg_turbo = libjpeg_turbo.override { enableJpeg8 = true; };
  };

  tensorman = callPackage ../tools/misc/tensorman {
    openssl = openssl_1_1;
  };

  spotify-qt = libsForQt5.callPackage ../applications/audio/spotify-qt { };

  spotify-tui = callPackage ../applications/audio/spotify-tui {
    inherit (darwin.apple_sdk.frameworks) AppKit Security;
    openssl = openssl_1_1;
  };

  squishyball = callPackage ../applications/audio/squishyball {
    ncurses = ncurses5;
  };

  sonic-pi = libsForQt5.callPackage ../applications/audio/sonic-pi { };

  stag = callPackage ../applications/misc/stag {
    curses = ncurses;
  };

  linuxstopmotion = libsForQt5.callPackage ../applications/video/linuxstopmotion { };

  sweethome3d = recurseIntoAttrs (
    (callPackage ../applications/misc/sweethome3d { }) //
    (callPackage ../applications/misc/sweethome3d/editors.nix {
      sweethome3dApp = sweethome3d.application;
    })
  );

  sxiv = callPackage ../applications/graphics/sxiv {
    imlib2 = imlib2Full;
  };

  nsxiv = callPackage ../applications/graphics/nsxiv {
    imlib2 = imlib2Full;
  };

  maestral = with python3Packages; toPythonApplication maestral;

  maestral-gui = libsForQt5.callPackage ../applications/networking/maestral-qt { };

  myfitnesspal = with python3Packages; toPythonApplication myfitnesspal;

  insync-v3 = libsForQt5.callPackage ../applications/networking/insync/v3.nix { };

  libstrangle = callPackage ../tools/X11/libstrangle {
    stdenv = stdenv_32bit;
  };

  lightdm = libsForQt5.callPackage ../applications/display-managers/lightdm { };

  lightdm_qt = lightdm.override { withQt5 = true; };

  lightdm-gtk-greeter = callPackage ../applications/display-managers/lightdm/gtk-greeter.nix {
    inherit (xfce) xfce4-dev-tools;
  };

  lightdm-tiny-greeter = callPackage ../applications/display-managers/lightdm-tiny-greeter {
    conf = config.lightdm-tiny-greeter.conf or "";
  };

  slic3r = callPackage ../applications/misc/slic3r {
    boost = boost172; # Building fails with Boost >1.72 due to boost/detail/endian.hpp missing
  };

  curaengine = callPackage ../applications/misc/curaengine { inherit (python3.pkgs) libarcus; };

  cura = libsForQt5.callPackage ../applications/misc/cura { };

  petrinizer = haskellPackages.callPackage ../applications/science/logic/petrinizer {};

  prusa-slicer = darwin.apple_sdk_11_0.callPackage ../applications/misc/prusa-slicer { };

  super-slicer = darwin.apple_sdk_11_0.callPackage ../applications/misc/prusa-slicer/super-slicer.nix { };

  super-slicer-latest = super-slicer.latest;

  routedns = callPackage ../tools/networking/routedns {
    buildGoModule = buildGo118Module; # build fails with 1.19
  };

  skrooge = libsForQt5.callPackage ../applications/office/skrooge {};

  smartgithg = callPackage ../applications/version-management/smartgithg {
    jre = openjdk11;
  };

  smartdeblur = libsForQt5.callPackage ../applications/graphics/smartdeblur { };

  snd = callPackage ../applications/audio/snd {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreMIDI;
  };

  socialscan = with python3.pkgs; toPythonApplication socialscan;

  sonic-lineup = libsForQt5.callPackage ../applications/audio/sonic-lineup {
    bzip2 = bzip2_1_1;
    stdenv = gcc10StdenvCompat;
  };

  sonic-visualiser = libsForQt5.callPackage ../applications/audio/sonic-visualiser { };

  soulseekqt = libsForQt5.callPackage ../applications/networking/p2p/soulseekqt { };

  sox = callPackage ../applications/misc/audio/sox {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  spek = callPackage ../applications/audio/spek {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  squeezelite = callPackage ../applications/audio/squeezelite { audioBackend = "alsa"; };

  squeezelite-pulse = callPackage ../applications/audio/squeezelite { audioBackend = "pulse"; };

  src = callPackage ../applications/version-management/src {
    git = gitMinimal;
    python = python3;
  };

  ssr = callPackage ../applications/audio/soundscape-renderer {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  inherit (ocaml-ng.ocamlPackages_4_12) stog;

  stumpwm = lispPackages.stumpwm;

  sublime3Packages = recurseIntoAttrs (callPackage ../applications/editors/sublime/3/packages.nix { });

  sublime3 = sublime3Packages.sublime3;

  sublime3-dev = sublime3Packages.sublime3-dev;

  inherit (recurseIntoAttrs (callPackage ../applications/editors/sublime/4/packages.nix { }))
    sublime4
    sublime4-dev;

  inherit (callPackage ../applications/version-management/sublime-merge {})
    sublime-merge
    sublime-merge-dev;

  inherit (callPackages ../applications/version-management/subversion {
    openssl = openssl_1_1;
    sasl = cyrus_sasl;
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  }) subversion;

  subversionClient = subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  };

  surf = callPackage ../applications/networking/browsers/surf { gtk = gtk2; };

  surge = callPackage ../applications/audio/surge {
    inherit (gnome) zenity;
    git = gitMinimal;
  };

  survex = callPackage ../applications/misc/survex {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  sylpheed = callPackage ../applications/networking/mailreaders/sylpheed {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  syncplay = python3.pkgs.callPackage ../applications/networking/syncplay { };

  syncplay-nogui = syncplay.override { enableGUI = false; };

  inherit (callPackages ../applications/networking/syncthing { })
    syncthing
    syncthing-discovery
    syncthing-relay;

  syncthingtray = libsForQt5.callPackage ../applications/misc/syncthingtray { };
  syncthingtray-minimal = libsForQt5.callPackage ../applications/misc/syncthingtray {
    webviewSupport = false;
    jsSupport = false;
    kioPluginSupport = false;
    plasmoidSupport = false;
    systemdSupport = true;
  };

  synergy = libsForQt5.callPackage ../applications/misc/synergy {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa CoreServices ScreenSaver;
  };

  synergyWithoutGUI = synergy.override { withGUI = false; };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages taffybar;
  };

  tagainijisho = libsForQt5.callPackage ../applications/office/tagainijisho {};

  taizen = callPackage ../applications/misc/taizen {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  tamgamp.lv2 = callPackage ../applications/audio/tamgamp.lv2 { };

  teams-for-linux = callPackage ../applications/networking/instant-messengers/teams-for-linux {
    electron = electron_21;
  };

  teamspeak_client = libsForQt5.callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };

  taskell = haskell.lib.compose.justStaticExecutables haskellPackages.taskell;

  tdesktop = qt6Packages.callPackage ../applications/networking/instant-messengers/telegram/tdesktop {
    abseil-cpp = abseil-cpp_202206;
  };

  tg = python3Packages.callPackage ../applications/networking/instant-messengers/telegram/tg { };

  termdown = python3Packages.callPackage ../applications/misc/termdown { };

  inherit (callPackage ../applications/graphics/tesseract {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  })
    tesseract3
    tesseract4
    tesseract5;
  tesseract = tesseract3;

  thunderbirdPackages = recurseIntoAttrs (callPackage ../applications/networking/mailreaders/thunderbird/packages.nix {
    callPackage = newScope {
      inherit (rustPackages) cargo rustc;
    };
  });

  thunderbird-unwrapped = thunderbirdPackages.thunderbird;
  thunderbird = wrapThunderbird thunderbird-unwrapped { };

  thunderbird-bin = wrapThunderbird thunderbird-bin-unwrapped {
    applicationName = "thunderbird";
    pname = "thunderbird-bin";
    desktopName = "Thunderbird";
  };
  thunderbird-bin-unwrapped = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    inherit (gnome) adwaita-icon-theme;
    generated = import ../applications/networking/mailreaders/thunderbird-bin/release_sources.nix;
  };

  tickrs = callPackage ../applications/misc/tickrs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  timbreid = callPackage ../applications/audio/pd-plugins/timbreid {
    fftw = fftwSinglePrec;
  };

  timeshift-unwrapped = callPackage ../applications/backup/timeshift/unwrapped.nix { inherit (cinnamon) xapp; };

  timeshift = callPackage ../applications/backup/timeshift { grubPackage = grub2_full; };

  timeshift-minimal = callPackage ../applications/backup/timeshift/minimal.nix { };

  timidity = callPackage ../tools/misc/timidity {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  tiny = callPackage ../applications/networking/irc/tiny {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  tipp10 = qt5.callPackage ../applications/misc/tipp10 { };

  tlp = callPackage ../tools/misc/tlp {
    inherit (linuxPackages) x86_energy_perf_policy;
  };

  torrenttools = callPackage ../tools/misc/torrenttools {
    fmt = fmt_8;
  };

  tony = libsForQt5.callPackage ../applications/audio/tony { };

  tqsl = callPackage ../applications/radio/tqsl {
    openssl = openssl_1_1;
  };
  trustedqsl = tqsl; # Alias added 2019-02-10

  transmission = callPackage ../applications/networking/p2p/transmission {
    # https://github.com/NixOS/nixpkgs/issues/207047
    openssl = openssl_legacy;
  };
  libtransmission = transmission.override {
    installLib = true;
    enableDaemon = false;
    enableCli = false;
  };
  transmission-gtk = transmission.override { enableGTK3 = true; };
  transmission-qt = transmission.override { enableQt = true; };

  traverso = libsForQt5.callPackage ../applications/audio/traverso { };

  treesheets = callPackage ../applications/office/treesheets {
    wxGTK = wxGTK32;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  trojita = libsForQt5.callPackage ../applications/networking/mailreaders/trojita { };

  tumpa = callPackage ../applications/misc/tumpa {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  tuna = python3Packages.callPackage ../os-specific/linux/tuna { };

  tunefish = callPackage ../applications/audio/tunefish {
    stdenv = clangStdenv; # https://github.com/jpcima/tunefish/issues/4
  };

  tuxguitar = callPackage ../applications/editors/music/tuxguitar {
    jre = jre8;
    swt = swt_jdk8;
  };

  twmn = libsForQt5.callPackage ../applications/misc/twmn { };

  t-rec = callPackage ../misc/t-rec {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  twinkle = qt5.callPackage ../applications/networking/instant-messengers/twinkle { };

  terminal-typeracer = callPackage ../applications/misc/terminal-typeracer {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ueberzug = with python3Packages; toPythonApplication ueberzug;

  uhhyou.lv2 = callPackage ../applications/audio/uhhyou.lv2 { };

  uefitoolPackages = recurseIntoAttrs (callPackage ../tools/system/uefitool/variants.nix {});
  uefitool = uefitoolPackages.new-engine;

  ungoogled-chromium = callPackage ../applications/networking/browsers/chromium ((config.chromium or {}) // {
    ungoogled = true;
    channel = "ungoogled-chromium";
  });

  unigine-tropics = pkgsi686Linux.callPackage ../applications/graphics/unigine-tropics { };

  unigine-sanctuary = pkgsi686Linux.callPackage ../applications/graphics/unigine-sanctuary { };

  unigine-superposition = libsForQt5.callPackage ../applications/graphics/unigine-superposition { };

  unison = callPackage ../applications/networking/sync/unison {
    enableX11 = config.unison.enableX11 or true;
  };

  uuagc = haskell.lib.compose.justStaticExecutables haskellPackages.uuagc;

  valentina = libsForQt5.callPackage ../applications/misc/valentina { };

  vcprompt = callPackage ../applications/version-management/vcprompt {
    autoconf = buildPackages.autoconf269;
  };

  vdirsyncer = with python3Packages; toPythonApplication vdirsyncer;

  vengi-tools = darwin.apple_sdk_11_0.callPackage ../applications/graphics/vengi-tools {
    inherit (darwin.apple_sdk_11_0.frameworks) Carbon CoreServices OpenCL;
  };

  verbiste = callPackage ../applications/misc/verbiste {
    inherit (gnome2) libgnomeui;
  };

  veusz = libsForQt5.callPackage ../applications/graphics/veusz { };

  vim = vimUtils.makeCustomizable (callPackage ../applications/editors/vim {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  });

  macvim = callPackage ../applications/editors/vim/macvim-configurable.nix { stdenv = clangStdenv; };

  vim-full = vimUtils.makeCustomizable (callPackage ../applications/editors/vim/configurable.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc;
  });

  vim-darwin = (vim-full.override {
    config = {
      vim = {
        gui = "none";
        darwin = true;
      };
    };
  }).overrideAttrs (_: rec {
    pname = "vim-darwin";
    meta = {
      platforms = lib.platforms.darwin;
    };
  });

  vimv-rs = callPackage ../tools/misc/vimv-rs {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  qpdfview = libsForQt5.callPackage ../applications/misc/qpdfview {};

  # this is a lower-level alternative to wrapNeovim conceived to handle
  # more usecases when wrapping neovim. The interface is being actively worked on
  # so expect breakage. use wrapNeovim instead if you want a stable alternative
  wrapNeovim = neovim-unwrapped: lib.makeOverridable (neovimUtils.legacyWrapper neovim-unwrapped);
  neovim-unwrapped = callPackage ../applications/editors/neovim {
    CoreServices =  darwin.apple_sdk.frameworks.CoreServices;
    lua = if lib.meta.availableOn stdenv.hostPlatform luajit then luajit else lua5_1;
  };

  neovimUtils = callPackage ../applications/editors/neovim/utils.nix {
    lua = lua5_1;
  };
  neovim = wrapNeovim neovim-unwrapped { };

  neovim-qt-unwrapped = libsForQt5.callPackage ../applications/editors/neovim/neovim-qt.nix { };
  neovim-qt = libsForQt5.callPackage ../applications/editors/neovim/qt.nix { };

  gnvim-unwrapped = callPackage ../applications/editors/neovim/gnvim {
    gtk = gtk3;
  };

  virt-manager = callPackage ../applications/virtualization/virt-manager {
    system-libvirt = libvirt;
  };

  virt-manager-qt = libsForQt5.callPackage ../applications/virtualization/virt-manager/qt.nix {
    qtermwidget = lxqt.qtermwidget;
  };

  virtualbox = libsForQt5.callPackage ../applications/virtualization/virtualbox {
    stdenv = stdenv_32bit;
    inherit (gnome2) libIDL;
  };

  virtualboxHardened = lowPrio (virtualbox.override {
    enableHardening = true;
  });

  virtualboxHeadless = lowPrio (virtualbox.override {
    enableHardening = true;
    headless = true;
  });

  virtualboxWithExtpack = lowPrio (virtualbox.override {
    extensionPack = virtualboxExtpack;
  });

  virtualglLib = callPackage ../tools/X11/virtualgl/lib.nix {
    fltk = fltk13;
  };

  virtualgl = callPackage ../tools/X11/virtualgl {
    virtualglLib_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.virtualglLib
      else null;
  };

  primusLib = callPackage ../tools/X11/primus/lib.nix {
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };

  primus = callPackage ../tools/X11/primus {
    stdenv_i686 = pkgsi686Linux.stdenv;
    primusLib_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.primusLib
      else null;
  };

  bumblebee = callPackage ../tools/X11/bumblebee {
    nvidia_x11 = linuxPackages.nvidia_x11;
    nvidia_x11_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.linuxPackages.nvidia_x11.override { libsOnly = true; }
      else null;
    libglvnd_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.libglvnd
      else null;
  };

  viper4linux-gui = libsForQt5.callPackage ../applications/audio/viper4linux-gui { };

  vlc = libsForQt5.callPackage ../applications/video/vlc {
    # Newest libcaca changed the API, and libvlc didn't catch it. Until next
    # version arrives, it is safer to disable it.
    # Upstream thread: https://code.videolan.org/videolan/vlc/-/issues/26389
    libcaca = null;
  };

  libvlc = vlc.override {
    withQt5 = false;
    qtbase = null;
    qtsvg = null;
    qtx11extras = null;
    wrapQtAppsHook = null;
    onlyLibVLC = true;
  };

  vmpk = libsForQt5.callPackage ../applications/audio/vmpk { };

  vorbis-tools = callPackage ../applications/audio/vorbis-tools {
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  vscode = callPackage ../applications/editors/vscode/vscode.nix { };
  vscode-fhs = vscode.fhs;
  vscode-fhsWithPackages = vscode.fhsWithPackages;

  vscode-utils = callPackage ../applications/editors/vscode/extensions/vscode-utils.nix { };

  vscode-extensions = recurseIntoAttrs (callPackage ../applications/editors/vscode/extensions { });

  vscodium = callPackage ../applications/editors/vscode/vscodium.nix { };
  vscodium-fhs = vscodium.fhs;
  vscodium-fhsWithPackages = vscodium.fhsWithPackages;

  openvscode-server = callPackage ../servers/openvscode-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa Security;
    inherit (darwin) cctools;
  };

  code-server = callPackage ../servers/code-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa CoreServices Security;
    inherit (darwin) cctools;
    inherit (nodePackages) node-gyp;
  };

  vuze = callPackage ../applications/networking/p2p/vuze {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  vym = callPackage ../applications/misc/vym {
    inherit (libsForQt5) qmake qtscript qtsvg qtbase wrapQtAppsHook;
  };

  whispers = with python3Packages; toPythonApplication whispers;

  # Should always be the version with the most features
  w3m-full = w3m;

  # Version without X11
  w3m-nox = w3m.override {
    x11Support = false;
    imlib2 = imlib2-nox;
  };

  # Version without X11 or graphics
  w3m-nographics = w3m.override {
    x11Support = false;
    graphicsSupport = false;
  };

  # Version for batch text processing, not a good browser
  w3m-batch = w3m.override {
    graphicsSupport = false;
    mouseSupport = false;
    x11Support = false;
    imlib2 = imlib2-nox;
  };

  wayfireApplications = wayfireApplications-unwrapped.withPlugins (plugins: [ plugins.wf-shell ]);
  inherit (wayfireApplications) wayfire wcm;
  wayfireApplications-unwrapped = recurseIntoAttrs (
    (callPackage ../applications/window-managers/wayfire/applications.nix { }).
    extend (_: _: { wlroots = wlroots_0_14; })
  );
  wayfirePlugins = recurseIntoAttrs (
    callPackage ../applications/window-managers/wayfire/plugins.nix {
      inherit (wayfireApplications-unwrapped) wayfire;
    }
  );

  webcamoid = libsForQt5.callPackage ../applications/video/webcamoid { };

  webmacs = libsForQt5.callPackage ../applications/networking/browsers/webmacs {};

  websploit = python3Packages.callPackage ../tools/security/websploit {};

  webssh = with python3Packages; toPythonApplication webssh;

  weechat-unwrapped = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libobjc;
    inherit (darwin) libresolv;
    guile = guile_2_0;
  };

  weechat = wrapWeechat weechat-unwrapped { };

  weechatScripts = recurseIntoAttrs (callPackage ../applications/networking/irc/weechat/scripts { });

  westonLite = weston.override {
    pango = null;
    freerdp = null;
    libunwind = null;
    vaapi = null;
    libva = null;
    libwebp = null;
    xwayland = null;
    pipewire = null;
  };

  chatterino2 = libsForQt5.callPackage ../applications/networking/instant-messengers/chatterino2 {};

  whalebird = callPackage ../applications/misc/whalebird {
    electron = electron_19;
  };

  wio = callPackage ../applications/window-managers/wio {
    wlroots = wlroots_0_14;
  };

  wings = callPackage ../applications/graphics/wings {
    erlang = erlangR21;
  };

  write_stylus = libsForQt5.callPackage ../applications/graphics/write_stylus { };

  wordnet = callPackage ../applications/misc/wordnet {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  workrave = callPackage ../applications/misc/workrave {
    inherit (python3Packages) jinja2;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  worldengine-cli = python3Packages.worldengine;

  wpsoffice = libsForQt5.callPackage ../applications/office/wpsoffice { };
  wpsoffice-cn = libsForQt5.callPackage ../applications/office/wpsoffice {
    useChineseVersion = true;
  };

  wsjtx = qt5.callPackage ../applications/radio/wsjtx { };

  wxhexeditor = callPackage ../applications/editors/wxhexeditor {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    inherit (llvmPackages) openmp;
    wxGTK = wxGTK32;
  };

  x11basic = callPackage ../development/compilers/x11basic {
    autoconf = buildPackages.autoconf269;
  };

  x2goclient = libsForQt5.callPackage ../applications/networking/remote/x2goclient { };

  x32edit = callPackage ../applications/audio/midas/x32edit.nix {};

  xaos = callPackage ../applications/graphics/xaos {
    libpng = libpng12;
  };

  xastir = callPackage ../applications/misc/xastir {
    rastermagick = imagemagick6;
  };

  xbindkeys-config = callPackage ../tools/X11/xbindkeys-config {
    gtk = gtk2;
  };

  kodiPackages = recurseIntoAttrs (kodi.packages);

  kodi = callPackage ../applications/video/kodi {
    jre_headless = jdk11_headless;
  };

  kodi-wayland = callPackage ../applications/video/kodi {
    jre_headless = jdk11_headless;
    waylandSupport = true;
  };

  kodi-gbm = callPackage ../applications/video/kodi {
    jre_headless = jdk11_headless;
    gbmSupport = true;
  };

  xca = libsForQt5.callPackage ../applications/misc/xca { };

  inherit (xorg) xcompmgr;

  xdg-desktop-portal = callPackage ../development/libraries/xdg-desktop-portal { };

  xdg-utils = callPackage ../tools/X11/xdg-utils {
    w3m = buildPackages.w3m-batch;
  };

  xed-editor = callPackage ../applications/editors/xed-editor {
    xapp = cinnamon.xapp;
  };

  xenPackages = recurseIntoAttrs (callPackage ../applications/virtualization/xen/packages.nix {});

  xen = xenPackages.xen-vanilla;
  xen-slim = xenPackages.xen-slim;
  xen-light = xenPackages.xen-light;

  xen_4_10 = xenPackages.xen_4_10-vanilla;
  xen_4_10-slim = xenPackages.xen_4_10-slim;
  xen_4_10-light = xenPackages.xen_4_10-light;

  gxneur = callPackage ../applications/misc/gxneur  {
    inherit (gnome2) libglade GConf;
  };

  xiphos = callPackage ../applications/misc/xiphos {
    gtkhtml = gnome.gtkhtml;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome2) libgnomecanvas;
  };

  xournalpp = callPackage ../applications/graphics/xournalpp {
    lua = lua5_3;
  };

  xpdf = libsForQt5.callPackage ../applications/misc/xpdf { };

  xmobar = haskellPackages.xmobar;

  xmonad-with-packages = callPackage ../applications/window-managers/xmonad/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = _: [ haskellPackages.xmonad-contrib ];
  };

  xmonadctl = callPackage ../applications/window-managers/xmonad/xmonadctl.nix {
    inherit (haskellPackages) ghcWithPackages;
  };

  xmonad_log_applet = callPackage ../applications/window-managers/xmonad/log-applet {
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmonad_log_applet_mate = xmonad_log_applet.override {
    desktopSupport = "mate";
  };

  xmonad_log_applet_xfce = xmonad_log_applet.override {
    desktopSupport = "xfce4";
  };

  xpra = callPackage ../tools/X11/xpra { };
  xpraWithNvenc = callPackage ../tools/X11/xpra {
    withNvenc = true;
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };


  xplayer = callPackage ../applications/video/xplayer {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad;
    inherit (cinnamon) xapp;
  };

  xsd = callPackage ../development/libraries/xsd {
    stdenv = gcc9Stdenv;
  };

  xmlcopyeditor = callPackage ../applications/editors/xmlcopyeditor {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  xygrib = libsForQt5.callPackage ../applications/misc/xygrib { };

  yabar = callPackage ../applications/window-managers/yabar { };

  yabar-unstable = callPackage ../applications/window-managers/yabar/unstable.nix { };

  ydiff = with python3.pkgs; toPythonApplication ydiff;

  inherit (gnome) yelp;

  yokadi = python3Packages.callPackage ../applications/misc/yokadi {};

  your-editor = callPackage ../applications/editors/your-editor { stdenv = gccStdenv; };

  youtube-dl = with python3Packages; toPythonApplication youtube-dl;

  youtube-dl-light = with python3Packages; toPythonApplication youtube-dl-light;

  yt-dlp = with python3Packages; toPythonApplication yt-dlp;

  yt-dlp-light = with python3Packages; toPythonApplication yt-dlp-light;

  youtube-viewer = perlPackages.WWWYoutubeViewer;

  yuview = libsForQt5.yuview;

  zathura = zathuraPkgs.zathuraWrapper;

  zeroc-ice-cpp11 = zeroc-ice.override { cpp11 = true; };

  zexy = callPackage ../applications/audio/pd-plugins/zexy {
    autoconf = buildPackages.autoconf269;
  };

  zgv = callPackage ../applications/graphics/zgv {
    # Enable the below line for terminal display. Note
    # that it requires sixel graphics compatible terminals like mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
  };

  zine = callPackage ../applications/misc/zine {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  zola = callPackage ../applications/misc/zola {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  inherit (nodePackages) zx;

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx {
    guiModule = "zest";
    fftw = fftwSinglePrec;
  };

  zynaddsubfx-fltk = zynaddsubfx.override {
    guiModule = "fltk";
  };

  zynaddsubfx-ntk = zynaddsubfx.override {
    guiModule = "ntk";
  };

  ### BLOCKCHAINS / CRYPTOCURRENCIES / WALLETS

  aeon = callPackage ../applications/blockchains/aeon {
    boost = boost172;
  };

  alfis = callPackage ../applications/blockchains/alfis {
    inherit (darwin.apple_sdk.frameworks) Cocoa Security WebKit;
    inherit (gnome) zenity;
  };
  alfis-nogui = alfis.override {
    withGui = false;
  };

  balanceofsatoshis = nodePackages.balanceofsatoshis;

  bitcoin  = libsForQt5.callPackage ../applications/blockchains/bitcoin {
    boost = boost17x;
    withGui = true;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoind = callPackage ../applications/blockchains/bitcoin {
    boost = boost17x;
    withGui = false;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoind-knots = callPackage ../applications/blockchains/bitcoin-knots {
    boost = boost17x;
    withGui = false;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  bitcoin-abc  = libsForQt5.callPackage ../applications/blockchains/bitcoin-abc {
    boost = boost17x;
    withGui = true;
  };
  bitcoind-abc = callPackage ../applications/blockchains/bitcoin-abc {
    boost = boost17x;
    mkDerivation = stdenv.mkDerivation;
    withGui = false;
  };

  bitcoin-unlimited  = libsForQt5.callPackage ../applications/blockchains/bitcoin-unlimited {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    withGui = true;
  };
  bitcoind-unlimited = callPackage ../applications/blockchains/bitcoin-unlimited {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    withGui = false;
  };

  btcpayserver = callPackage ../applications/blockchains/btcpayserver { };

  btcpayserver-altcoins = callPackage ../applications/blockchains/btcpayserver { altcoinSupport = true; };

  cryptop = python3.pkgs.callPackage ../applications/blockchains/cryptop { };

  dogecoin  = libsForQt5.callPackage ../applications/blockchains/dogecoin {
    boost = boost17x;
    withGui = true;
  };
  dogecoind = callPackage ../applications/blockchains/dogecoin {
    boost = boost17x;
    withGui = false;
  };

  electrs = callPackage ../applications/blockchains/electrs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  elements  = libsForQt5.callPackage ../applications/blockchains/elements {
    withGui = true;
    boost = boost175;
    inherit (darwin) autoSignDarwinBinariesHook;
  };
  elementsd = callPackage ../applications/blockchains/elements {
    withGui = false;
    boost = boost175;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  fulcrum = libsForQt5.callPackage ../applications/blockchains/fulcrum { };

  go-ethereum = callPackage ../applications/blockchains/go-ethereum {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  groestlcoin  = libsForQt5.callPackage ../applications/blockchains/groestlcoin {
    boost = boost17x;
    withGui = true;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  groestlcoind = callPackage ../applications/blockchains/groestlcoin {
    boost = boost17x;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  ledger_agent = with python3Packages; toPythonApplication ledger_agent;

  litecoin  = libsForQt5.callPackage ../applications/blockchains/litecoin {
    inherit (darwin.apple_sdk.frameworks) AppKit;
    boost = pkgs.boost174;
  };
  litecoind = litecoin.override { withGui = false; };

  monero-cli = callPackage ../applications/blockchains/monero-cli {
    inherit (darwin.apple_sdk.frameworks) CoreData IOKit PCSC;
  };

  haven-cli = callPackage ../applications/blockchains/haven-cli {
    inherit (darwin.apple_sdk.frameworks) CoreData IOKit PCSC;
  };

  monero-gui = libsForQt5.callPackage ../applications/blockchains/monero-gui {
    boost = boost17x;
  };

  oxen = callPackage ../applications/blockchains/oxen
    { stdenv = gcc10StdenvCompat; boost = boost17x; };

  masari = callPackage ../applications/blockchains/masari { boost = boost174; };

  napari = with python3Packages; toPythonApplication napari;

  nano-wallet = libsForQt5.callPackage ../applications/blockchains/nano-wallet
    { stdenv = gcc10StdenvCompat; boost = boost172; };

  namecoin  = callPackage ../applications/blockchains/namecoin { withGui = true; };
  namecoind = callPackage ../applications/blockchains/namecoin { withGui = false; };

  pivx = libsForQt5.callPackage ../applications/blockchains/pivx { withGui = true; };
  pivxd = callPackage ../applications/blockchains/pivx {
    withGui = false;
    qtbase = null;
    qttools = null;
    wrapQtAppsHook = null;
    autoreconfHook = buildPackages.autoreconfHook269;
  };

  pycoin = with python3Packages; toPythonApplication pycoin;

  sumokoin = callPackage ../applications/blockchains/sumokoin {
    boost = boost17x;
  };

  solana-testnet = callPackage ../applications/blockchains/solana {
    inherit (darwin.apple_sdk.frameworks) IOKit Security AppKit;
  };

  solana-validator = callPackage ../applications/blockchains/solana-validator {
    inherit (darwin.apple_sdk.frameworks) IOKit Security AppKit;
  };

  snarkos = callPackage ../applications/blockchains/snarkos {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../applications/blockchains/teos {
    inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
  })
    teos
    teos-watchtower-plugin;

  vertcoin  = libsForQt5.callPackage ../applications/blockchains/vertcoin {
    boost = boost17x;
    withGui = true;
  };
  vertcoind = callPackage ../applications/blockchains/vertcoin {
    boost = boost17x;
    withGui = false;
  };

  wownero = callPackage ../applications/blockchains/wownero {
    boost = boost175;
  };

  zcash = callPackage ../applications/blockchains/zcash {
    inherit (darwin.apple_sdk.frameworks) Security;
    stdenv = llvmPackages_14.stdenv;
  };

  polkadot = callPackage ../applications/blockchains/polkadot {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  samplv1 = libsForQt5.callPackage ../applications/audio/samplv1 { };

  beancount = with python3.pkgs; toPythonApplication beancount;

  beancount-black = with python3.pkgs; toPythonApplication beancount-black;

  bench = haskell.lib.compose.justStaticExecutables haskellPackages.bench;

  digikam = libsForQt5.callPackage ../applications/graphics/digikam {};

  drumkv1 = libsForQt5.callPackage ../applications/audio/drumkv1 { };

  eureka-ideas = callPackage ../applications/misc/eureka-ideas {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  phonemizer = with python3Packages; toPythonApplication phonemizer;

  ### GAMES

  _90secondportraits = callPackage ../games/90secondportraits { love = love_0_10; };

  fmodex = callPackage ../games/zandronum/fmod.nix { };

  heroic = callPackage ../games/heroic/fhsenv.nix {
    buildFHSUserEnv = buildFHSUserEnvBubblewrap;
  };

  ### GAMES/LGAMES

  pro-office-calculator = libsForQt5.callPackage ../games/pro-office-calculator { };

  qgo = libsForQt5.callPackage ../games/qgo { };

  sm64ex = callPackage ../games/sm64ex {
    branch = "sm64ex";
  };

  sm64ex-coop = callPackage ../games/sm64ex {
    branch = "sm64ex-coop";
  };

  alephone-pathways-into-darkness =
    callPackage ../games/alephone/pathways-into-darkness { };

  anki = python39Packages.callPackage ../games/anki {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };
  anki-bin = callPackage ../games/anki/bin.nix { buildFHSUserEnv = buildFHSUserEnvBubblewrap; };

  armagetronad = callPackage ../games/armagetronad { };

  armagetronad-dedicated = callPackage ../games/armagetronad { dedicatedServer = true; };

  arx-libertatis = libsForQt5.callPackage ../games/arx-libertatis { };

  asc = callPackage ../games/asc {
    lua = lua5_1;
    physfs = physfs_2;
  };

  ballAndPaddle = callPackage ../games/ball-and-paddle {
    guile = guile_1_8;
  };

  black-hole-solver = callPackage ../games/black-hole-solver {
    inherit (perlPackages) PathTiny;
  };

  bugdom = callPackage ../games/bugdom {
    inherit (darwin.apple_sdk.frameworks) IOKit Foundation;
  };

  bzflag = callPackage ../games/bzflag {
    inherit (darwin.apple_sdk.frameworks) Carbon CoreServices;
  };

  cataclysm-dda = cataclysmDDA.stable.tiles;

  cataclysm-dda-git = cataclysmDDA.git.tiles;

  chessx = libsForQt5.callPackage ../games/chessx { };

  chiaki = libsForQt5.callPackage ../games/chiaki { };

  cockatrice = libsForQt5.callPackage ../games/cockatrice {  };

  construoBase = lowPrio (callPackage ../games/construo {
    libGL = null;
    libGLU = null;
    freeglut = null;
  });

  construo = construoBase.override {
    inherit libGL libGLU freeglut;
  };

  crawlTiles = callPackage ../games/crawl {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  inherit (import ../games/crossfire pkgs)
    crossfire-server crossfire-arch crossfire-maps crossfire-client;

  curseofwar = callPackage ../games/curseofwar { SDL = null; };
  curseofwar-sdl = callPackage ../games/curseofwar { ncurses = null; };

  cutemaze = qt6Packages.callPackage ../games/cutemaze { };

  deliantra-server = callPackage ../games/deliantra/server.nix {
    stdenv = gcc10StdenvCompat;
  };
  deliantra-arch = callPackage ../games/deliantra/arch.nix {
    stdenv = gcc10StdenvCompat;
  };
  deliantra-maps = callPackage ../games/deliantra/maps.nix {
    stdenv = gcc10StdenvCompat;
  };
  deliantra-data = callPackage ../games/deliantra/data.nix {
    stdenv = gcc10StdenvCompat;
  };

  ddnet = callPackage ../games/ddnet {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa OpenGL Security;
  };

  devilutionx = callPackage ../games/devilutionx {
    SDL2 = SDL2.override {
      withStatic = true;
    };
  };

  duckmarines = callPackage ../games/duckmarines { love = love_0_10; };

  dwarf-fortress-packages = recurseIntoAttrs (callPackage ../games/dwarf-fortress { });

  dwarf-fortress = dwarf-fortress-packages.dwarf-fortress;

  dwarf-therapist = dwarf-fortress-packages.dwarf-therapist;

  inherit (callPackages ../games/dxx-rebirth/assets.nix { })
    descent1-assets
    descent2-assets;

  inherit (callPackages ../games/dxx-rebirth/full.nix { })
    d1x-rebirth-full
    d2x-rebirth-full;

  eduke32 = callPackage ../games/eduke32 {
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa GLUT OpenGL;
  };

  enyo-launcher = libsForQt5.callPackage ../games/enyo-launcher { };

  extremetuxracer = callPackage ../games/extremetuxracer {
    libpng = libpng12;
  };

  flare = callPackage ../games/flare {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  fltrator = callPackage ../games/fltrator {
    fltk = fltk-minimal;
  };

  factorio = callPackage ../games/factorio { releaseType = "alpha"; };

  factorio-experimental = factorio.override { releaseType = "alpha"; experimental = true; };

  factorio-headless = factorio.override { releaseType = "headless"; };

  factorio-headless-experimental = factorio.override { releaseType = "headless"; experimental = true; };

  factorio-demo = factorio.override { releaseType = "demo"; };

  ferium = callPackage ../games/ferium {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  flightgear = libsForQt5.callPackage ../games/flightgear { };

  freeciv = callPackage ../games/freeciv {
    sdl2Client = false;
    gtkClient = true;
    qtClient = false;
  };

  freeciv_sdl2 = freeciv.override {
    sdl2Client = true;
    gtkClient = false;
    qtClient = false;
  };

  freeciv_qt = freeciv.override {
    sdl2Client = false;
    gtkClient = false;
    qtClient = true;
  };

  freeciv_gtk = freeciv;

  garden-of-coloured-lights = callPackage ../games/garden-of-coloured-lights { allegro = allegro4; };

  gargoyle = callPackage ../games/gargoyle {
    inherit (darwin) cctools;
  };

  gcompris = libsForQt5.callPackage ../games/gcompris { };

  gl-gsync-demo = callPackage ../games/gl-gsync-demo {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  gogdl = python3Packages.callPackage ../games/gogdl { };

  gscrabble = python3Packages.callPackage ../games/gscrabble { };

  gshogi = python3Packages.callPackage ../games/gshogi { };

  qtads = qt5.callPackage ../games/qtads { };

  grapejuice = callPackage ../games/grapejuice {
    wine = wineWowPackages.unstable;
  };

  gtetrinet = callPackage ../games/gtetrinet {
    inherit (gnome2) GConf libgnome libgnomeui;
  };

  hedgewars = libsForQt5.callPackage ../games/hedgewars {
    inherit (haskellPackages) ghcWithPackages;
  };

  instaloader = python3Packages.callPackage ../tools/misc/instaloader { };

  iortcw = callPackage ../games/iortcw { };
  # used as base package for iortcw forks
  iortcw_sp = callPackage ../games/iortcw/sp.nix { };

  ja2-stracciatella = callPackage ../games/ja2-stracciatella {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  katagoWithCuda = katago.override {
    enableCuda = true;
  };

  katagoCPU = katago.override {
    enableGPU = false;
  };

  koboredux = callPackage ../games/koboredux { };

  koboredux-free = callPackage ../games/koboredux {
    useProprietaryAssets = false;
  };

  ldmud = callPackage ../games/ldmud { };

  ldmud-full = callPackage ../games/ldmud {
    ipv6Support = true;
    mccpSupport = true;
    mysqlSupport = true;
    postgresSupport = true;
    sqliteSupport = true;
    tlsSupport = true;
    pythonSupport = true;
  };

  leela-zero = libsForQt5.callPackage ../games/leela-zero { };

  legendary-gl = python3Packages.callPackage ../games/legendary-gl { };

  lgogdownloader = libsForQt5.callPackage ../games/lgogdownloader { };

  lincity_ng = callPackage ../games/lincity/ng.nix {
    # https://github.com/lincity-ng/lincity-ng/issues/25
    physfs = physfs_2;
  };

  liquidwar = callPackage ../games/liquidwar {
    guile = guile_2_0;
  };

  macopix = callPackage ../games/macopix {
    gtk = gtk2;
  };

  mindustry = callPackage ../games/mindustry { };
  mindustry-wayland = callPackage ../games/mindustry {
    glew = glew-egl;
  };

  mindustry-server = callPackage ../games/mindustry {
    enableClient = false;
    enableServer = true;
  };

  minecraftServers = import ../games/minecraft-servers { inherit callPackage lib javaPackages; };
  minecraft-server = minecraftServers.vanilla; # backwards compatibility

  inherit (callPackages ../games/minetest {
    inherit (darwin.apple_sdk.frameworks) OpenGL OpenAL Carbon Cocoa;
  })
    minetestclient_5 minetestserver_5;

  minetest = minetestclient;
  minetestclient = minetestclient_5;
  minetestserver = minetestserver_5;

  mnemosyne = callPackage ../games/mnemosyne {
    python = python3;
  };

  mudlet = libsForQt5.callPackage ../games/mudlet {
    lua = lua5_1;
  };

  blightmud = callPackage ../games/blightmud { };

  blightmud-tts = callPackage ../games/blightmud { withTTS = true; };

  nethack = callPackage ../games/nethack { };

  nethack-qt = callPackage ../games/nethack {
    qtMode = true;
    stdenv = gccStdenv;
  };

  nethack-x11 = callPackage ../games/nethack { x11Mode = true; };

  opendungeons = callPackage ../games/opendungeons {
    ogre = ogre1_10;
  };

  openclonk = callPackage ../games/openclonk { stdenv = gcc10StdenvCompat; };

  openmw = libsForQt5.callPackage ../games/openmw { };

  openmw-tes3mp = libsForQt5.callPackage ../games/openmw/tes3mp.nix { };

  openraPackages = import ../games/openra pkgs.__splicedPackages;

  openra = openraPackages.engines.release;

  openrw = callPackage ../games/openrw {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenAL;
  };

  openspades = callPackage ../games/openspades {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  openttd = callPackage ../games/openttd {
    zlib = zlib.override {
      static = true;
    };
  };
  openttd-jgrpp = callPackage ../games/openttd/jgrpp.nix {
    zlib = zlib.override {
      static = true;
    };
  };

  openxcom = callPackage ../games/openxcom { SDL = SDL_compat; };

  pentobi = libsForQt5.callPackage ../games/pentobi { };

  prismlauncher-qt5 = libsForQt5.callPackage ../games/prismlauncher { };

  prismlauncher = qt6Packages.callPackage ../games/prismlauncher { };

  pokerth = libsForQt5.callPackage ../games/pokerth {
    boost = boost16x;
  };

  pokerth-server = libsForQt5.callPackage ../games/pokerth {
    boost = boost16x;
    target = "server";
  };

  pysolfc = python3Packages.callPackage ../games/pysolfc { };

  quake3demo = quake3wrapper {
    name = "quake3-demo-${lib.getVersion quake3demodata}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    paks = [ quake3pointrelease quake3demodata ];
  };

  quakespasm = callPackage ../games/quakespasm {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreAudio CoreFoundation IOKit OpenGL;
  };
  vkquake = callPackage ../games/quakespasm/vulkan.nix {
    inherit (darwin) moltenvk;
  };

  rigsofrods = callPackage ../games/rigsofrods {
    angelscript = angelscript_2_22;
    ogre = ogre1_9;
    ogrepaged = ogrepaged.override {
      ogre = ogre1_9;
    };
    mygui = mygui.override {
      withOgre = true;
    };
  };

  rogue = callPackage ../games/rogue {
    ncurses = ncurses5;
  };

  rott = callPackage ../games/rott { SDL = SDL_compat; };

  rott-shareware = rott.override {
    buildShareware = true;
  };

  space-cadet-pinball = callPackage ../games/space-cadet-pinball {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  starsector = callPackage ../games/starsector {
    openjdk = openjdk8;
  };

  scid = callPackage ../games/scid {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  scid-vs-pc = callPackage ../games/scid-vs-pc {
    tcl = tcl-8_6;
    tk = tk-8_6;
  };

  scummvm = callPackage ../games/scummvm {
    stdenv = if (stdenv.isDarwin && stdenv.isAarch64) then llvmPackages_14.stdenv else stdenv;
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) Cocoa AudioToolbox Carbon CoreMIDI AudioUnit;
  };

  inherit (callPackage ../games/scummvm/games.nix { })
    beneath-a-steel-sky
    broken-sword-25
    drascula-the-vampire-strikes-back
    dreamweb
    flight-of-the-amazon-queen
    lure-of-the-temptress;

  sgtpuzzles = callPackage ../games/sgt-puzzles { };

  sgtpuzzles-mobile = callPackage ../games/sgt-puzzles {
    isMobile = true;
  };

  # get binaries without data built by Hydra
  simutrans_binaries = lowPrio simutrans.binaries;

  soi = callPackage ../games/soi {
    lua = lua5_1;
  };

  # solarus and solarus-quest-editor must use the same version of Qt.
  solarus = libsForQt5.callPackage ../games/solarus { };
  solarus-quest-editor = libsForQt5.callPackage ../development/tools/solarus-quest-editor { };

  # You still can override by passing more arguments.

  spring = callPackage ../games/spring { asciidoc = asciidoc-full; };

  steamPackages = dontRecurseIntoAttrs (callPackage ../games/steam {
    buildFHSUserEnv = buildFHSUserEnvBubblewrap;
  });

  steam = steamPackages.steam-fhsenv;

  steam-run = steam.run;

  steamcmd = steamPackages.steamcmd;

  protontricks = python3Packages.callPackage ../tools/package-management/protontricks {
    inherit winetricks steam-run yad;
  };

  protonup-ng = with python3Packages; toPythonApplication protonup-ng;

  streamlit = python3Packages.callPackage ../applications/science/machine-learning/streamlit { };

  stuntrally = callPackage ../games/stuntrally
    { ogre = ogre1_9; mygui = mygui.override { withOgre = true; }; };

  superTuxKart = callPackage ../games/super-tux-kart {
    inherit (darwin.apple_sdk.frameworks) Cocoa IOKit OpenAL;
  };

  synthv1 = libsForQt5.callPackage ../applications/audio/synthv1 { };

  the-powder-toy = callPackage ../games/the-powder-toy {
    lua = lua5_1;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  tbe = libsForQt5.callPackage ../games/the-butterfly-effect { };

  tengine = callPackage ../servers/http/tengine {
    openssl = openssl_1_1;
    modules = with nginxModules; [ rtmp dav moreheaders modsecurity ];
  };

  tibia = pkgsi686Linux.callPackage ../games/tibia { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    libpng = libpng12;
  };

  ultrastar-creator = libsForQt5.callPackage ../tools/misc/ultrastar-creator { };

  ultrastar-manager = libsForQt5.callPackage ../tools/misc/ultrastar-manager { };

  ue4demos = recurseIntoAttrs (callPackage ../games/ue4demos { });

  ut2004Packages = dontRecurseIntoAttrs (callPackage ../games/ut2004 { });

  ut2004demo = res.ut2004Packages.ut2004 [ res.ut2004Packages.ut2004-demo ];

  # To ensure vdrift's code is built on hydra
  vdrift-bin = vdrift.bin;

  vessel = pkgsi686Linux.callPackage ../games/vessel { };

  voxelands = callPackage ../games/voxelands {
    libpng = libpng12;
  };

  wesnoth = callPackage ../games/wesnoth {
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
  };

  wesnoth-dev = wesnoth;

  xconq = callPackage ../games/xconq {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };


  inherit (callPackage ../games/xonotic { })
    xonotic-data
    xonotic;

  xonotic-glx = (callPackage ../games/xonotic {
    withSDL = false;
    withGLX = true;
  }).xonotic;

  xonotic-dedicated = (callPackage ../games/xonotic {
    withSDL = false;
    withDedicated = true;
  }).xonotic;

  xonotic-sdl = xonotic;
  xonotic-sdl-unwrapped = xonotic-sdl.xonotic-unwrapped;
  xonotic-glx-unwrapped = xonotic-glx.xonotic-unwrapped;
  xonotic-dedicated-unwrapped = xonotic-dedicated.xonotic-unwrapped;


  inherit (callPackage ../games/quake2/yquake2 {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenAL;
  })
    yquake2
    yquake2-ctf
    yquake2-ground-zero
    yquake2-the-reckoning
    yquake2-all-games;

  zandronum = callPackage ../games/zandronum { };

  zandronum-server = zandronum.override {
    serverOnly = true;
  };

  zeroadPackages = recurseIntoAttrs (callPackage ../games/0ad {
    wxGTK = wxGTK32;
  });

  zeroad = zeroadPackages.zeroad;

  ### DESKTOP ENVIRONMENTS

  arcanPackages = recurseIntoAttrs (callPackage ../desktops/arcan { });

  budgie = recurseIntoAttrs (callPackage ../desktops/budgie { });

  cinnamon = recurseIntoAttrs (callPackage ../desktops/cinnamon { });
  inherit (cinnamon) mint-x-icons mint-y-icons;

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment { });

  gnome2 = recurseIntoAttrs (callPackage ../desktops/gnome-2 { });

  gnome = recurseIntoAttrs (callPackage ../desktops/gnome { });

  inherit (callPackage ../desktops/gnome/extensions { })
    gnomeExtensions
    gnome38Extensions
    gnome40Extensions
    gnome41Extensions
    gnome42Extensions
    gnome43Extensions
  ;

  gnustep = recurseIntoAttrs (callPackage ../desktops/gnustep { });

  lumina = recurseIntoAttrs (callPackage ../desktops/lumina { });

  ### DESKTOPS/LXDE

  lxde = recurseIntoAttrs (callPackage ../desktops/lxde { });
  # Backwards compatibility aliases
  inherit (lxde)
    lxappearance
    lxappearance-gtk2
    lxmenu-data
    lxpanel
    lxrandr
    lxsession
    lxtask
  ;

  lxqt = recurseIntoAttrs (import ../desktops/lxqt {
    inherit pkgs;
    inherit (lib) makeScope;
    inherit qt5 libsForQt5;
  });

  mate = recurseIntoAttrs (callPackage ../desktops/mate { });

  pantheon = recurseIntoAttrs (callPackage ../desktops/pantheon { });

  rox-filer = callPackage ../desktops/rox/rox-filer {
    gtk = gtk2;
  };

  xfce = recurseIntoAttrs (callPackage ../desktops/xfce { });

  plasma-applet-volumewin7mixer = libsForQt5.callPackage ../applications/misc/plasma-applet-volumewin7mixer { };

  plasma-theme-switcher = libsForQt5.callPackage ../applications/misc/plasma-theme-switcher {};

  plasma-pass = libsForQt5.callPackage ../tools/security/plasma-pass { };

  inherit (callPackages ../applications/misc/redshift {
    inherit (python3Packages) python pygobject3 pyxdg wrapPython;
    inherit (darwin.apple_sdk.frameworks) CoreLocation ApplicationServices Foundation Cocoa;
    geoclue = geoclue2;
  }) redshift gammastep;

  redshift-plasma-applet = libsForQt5.callPackage ../applications/misc/redshift-plasma-applet { };

  latte-dock = libsForQt5.callPackage ../applications/misc/latte-dock { };

  gnome-themes-extra = gnome.gnome-themes-extra;

  ### SCIENCE/CHEMISTY

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    openbabel = openbabel2;
    eigen = eigen2;
  };

  avogadrolibs = libsForQt5.callPackage ../development/libraries/science/chemistry/avogadrolibs { };

  molequeue = libsForQt5.callPackage ../development/libraries/science/chemistry/molequeue { };

  avogadro2 = libsForQt5.callPackage ../applications/science/chemistry/avogadro2 { };

  jmol = callPackage ../applications/science/chemistry/jmol {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };

  openlp = libsForQt5.callPackage ../applications/misc/openlp { };
  openlpFull = openlp.override {
    pdfSupport = true;
    presentationSupport = true;
    vlcSupport = true;
    gstreamerSupport = true;
  };

  quantum-espresso = callPackage ../applications/science/chemistry/quantum-espresso { };

  quantum-espresso-mpi = callPackage ../applications/science/chemistry/quantum-espresso { useMpi = true; };

  siesta = callPackage ../applications/science/chemistry/siesta { };

  siesta-mpi = callPackage ../applications/science/chemistry/siesta { useMpi = true; };

  ### SCIENCE/GEOMETRY

  drgeo = callPackage ../applications/science/geometry/drgeo {
    inherit (gnome2) libglade;
    guile = guile_1_8;
  };

  /* tetgen = <moved> */ # AGPL3+
  /* tetgen_1_4 = <moved> */ # MIT

  ### SCIENCE/BENCHMARK

  ### SCIENCE/BIOLOGY

  ants = callPackage ../applications/science/biology/ants {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  blast = callPackage ../applications/science/biology/blast {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  bpp-core = callPackage ../development/libraries/science/biology/bpp-core {
    stdenv = gcc10StdenvCompat;
  };

  bpp-phyl = callPackage ../development/libraries/science/biology/bpp-phyl {
    stdenv = gcc10StdenvCompat;
  };

  bpp-popgen = callPackage ../development/libraries/science/biology/bpp-popgen {
    stdenv = gcc10StdenvCompat;
  };

  bpp-seq = callPackage ../development/libraries/science/biology/bpp-seq {
    stdenv = gcc10StdenvCompat;
  };

  bppsuite = callPackage ../applications/science/biology/bppsuite {
    stdenv = gcc10StdenvCompat;
  };

  cd-hit = callPackage ../applications/science/biology/cd-hit {
    inherit (llvmPackages) openmp;
  };

  ciftilib = callPackage ../development/libraries/science/biology/ciftilib {
    boost = boost16x;
  };

  deepdiff = with python3Packages; toPythonApplication deepdiff;

  deeptools = callPackage ../applications/science/biology/deeptools { python = python3; };

  deep-translator = with python3Packages; toPythonApplication deep-translator;

  febio-studio = libsForQt5.callPackage ../applications/science/biology/febio-studio { };

  iv = callPackage ../applications/science/biology/iv {
    neuron-version = neuron.version;
  };

  kallisto = callPackage ../applications/science/biology/kallisto {
    autoconf = buildPackages.autoconf269;
  };

  mirtk = callPackage ../development/libraries/science/biology/mirtk {
    boost = boost16x;
  };

  neuron = callPackage ../applications/science/biology/neuron { python = null; };

  neuron-mpi = neuron.override {useMpi = true; };

  neuron-full = neuron-mpi.override { python = python2; };

  mrtrix = callPackage ../applications/science/biology/mrtrix { python = python3; };

  minc_tools = callPackage ../applications/science/biology/minc-tools {
    inherit (perlPackages) perl TextFormat;
  };

  mmseqs2 = callPackage ../applications/science/biology/mmseqs2 {
    inherit (llvmPackages) openmp;
  };

  raxml-mpi = raxml.override { useMpi = true; };

  samtools_0_1_19 = callPackage ../applications/science/biology/samtools/samtools_0_1_19.nix {
    stdenv = gccStdenv;
  };

  strelka = callPackage ../applications/science/biology/strelka { stdenv = gcc10StdenvCompat; };

  inherit (callPackages ../applications/science/biology/sumatools {})
      sumalibs
      sumaclust
      sumatra;

  ### SCIENCE/MACHINE LEARNING

  ### SCIENCE/MATH

  blas-ilp64 = blas.override { isILP64 = true; };

  clblas = callPackage ../development/libraries/science/math/clblas {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo OpenCL;
  };

  getdp = callPackage ../applications/science/math/getdp { stdenv = gcc10StdenvCompat; };

  lapack-ilp64 = lapack.override { isILP64 = true; };

  liblapack = lapack-reference;

  nota = haskellPackages.callPackage ../applications/science/math/nota { };

  notus-scanner = with python3Packages; toPythonApplication notus-scanner;

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  magma = callPackage ../development/libraries/science/math/magma {
    inherit (llvmPackages_rocm) openmp;
  };

  magma-cuda = magma.override {
    useCUDA = true;
    useROCM = false;
  };

  magma-hip = magma.override {
    useCUDA = false;
    useROCM = true;
  };

  mathematica = callPackage ../applications/science/math/mathematica { };

  mathematica-cuda = callPackage ../applications/science/math/mathematica {
    cudaSupport = true;
  };

  mathematica9 = callPackage ../applications/science/math/mathematica {
    version = "9";
  };

  mathematica10 = callPackage ../applications/science/math/mathematica {
    version = "10";
  };

  mathematica11 = callPackage ../applications/science/math/mathematica {
    version = "11";
  };

  or-tools = callPackage ../development/libraries/science/math/or-tools {
    python = python3;
    # or-tools builds with -std=c++20, so abseil-cpp must
    # also be built that way
    abseil-cpp = abseil-cpp_202111.override {
      static = true;
      cxxStandard = "20";
    };
  };

  p4est-sc = callPackage ../development/libraries/science/math/p4est-sc {
    p4est-sc-debugEnable = false;
  };

  p4est-sc-dbg = callPackage ../development/libraries/science/math/p4est-sc { };

  p4est = callPackage ../development/libraries/science/math/p4est { };

  p4est-dbg = callPackage ../development/libraries/science/math/p4est {
    p4est-sc = p4est-sc-dbg;
  };

  sageWithDoc = sage.override { withDoc = true; };

  suitesparse = suitesparse_5_3;

  trilinos = callPackage ../development/libraries/science/math/trilinos {};

  trilinos-mpi = callPackage ../development/libraries/science/math/trilinos { withMPI = true; };

  wolfram-engine = libsForQt5.callPackage ../applications/science/math/wolfram-engine { };

  gmsh = callPackage ../applications/science/math/gmsh { };

  ### SCIENCE/MOLECULAR-DYNAMICS

  dl-poly-classic-mpi = callPackage ../applications/science/molecular-dynamics/dl-poly-classic { stdenv = gcc10StdenvCompat; };

  lammps = callPackage ../applications/science/molecular-dynamics/lammps {
    fftw = fftw;
  };

  lammps-mpi = lowPrio (lammps.override { withMPI = true; });

  gromacs = callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    fftw = fftwSinglePrec;
  };

  gromacsMpi = lowPrio (gromacs.override {
    singlePrec = true;
    enableMpi = true;
    fftw = fftwSinglePrec;
  });

  gromacsDouble = lowPrio (gromacs.override {
    singlePrec = false;
    fftw = fftw;
  });

  gromacsDoubleMpi = lowPrio (gromacs.override {
    singlePrec = false;
    enableMpi = true;
    fftw = fftw;
  });

  gromacsCudaMpi = lowPrio (gromacs.override {
    singlePrec = true;
    enableMpi = true;
    enableCuda = true;
    cudatoolkit = cudatoolkit_11;
    fftw = fftwSinglePrec;
  });

  zegrapher = libsForQt5.callPackage ../applications/science/math/zegrapher { };

  ### SCIENCE/MEDICINE

  ### SCIENCE/PHYSICS

  mcfm = callPackage ../applications/science/physics/MCFM {
    stdenv = gccStdenv;
    lhapdf = lhapdf.override { stdenv = gccStdenv; python = null; };
  };

  validphys2 = with python3Packages; toPythonApplication validphys2;

  xflr5 = libsForQt5.callPackage ../applications/science/physics/xflr5 { };

  ### SCIENCE/PROGRAMMING

  dafny = dotnetPackages.Dafny;

  ### SCIENCE/LOGIC

  abella = callPackage ../applications/science/logic/abella {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  aspino = callPackage ../applications/science/logic/aspino {
    stdenv = gcc10StdenvCompat;
  };

  boogie = dotnetPackages.Boogie;

  inherit (callPackage ./coq-packages.nix {
    inherit (ocaml-ng)
      ocamlPackages_4_05
      ocamlPackages_4_09
      ocamlPackages_4_10
      ocamlPackages_4_12
      ocamlPackages_4_14
    ;
  }) mkCoqPackages
    coqPackages_8_5  coq_8_5
    coqPackages_8_6  coq_8_6
    coqPackages_8_7  coq_8_7
    coqPackages_8_8  coq_8_8
    coqPackages_8_9  coq_8_9
    coqPackages_8_10 coq_8_10
    coqPackages_8_11 coq_8_11
    coqPackages_8_12 coq_8_12
    coqPackages_8_13 coq_8_13
    coqPackages_8_14 coq_8_14
    coqPackages_8_15 coq_8_15
    coqPackages_8_16 coq_8_16
    coqPackages_8_17 coq_8_17
    coqPackages      coq
  ;

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (_: { dontDisableStatic = true; });
    stdenv = gccStdenv;
  };

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {
    ocaml = ocaml-ng.ocamlPackages_4_14.ocaml.override {
      unsafeStringSupport = true;
    };
  };

  eprover = callPackage ../applications/science/logic/eprover { };

  eprover-ho = callPackage ../applications/science/logic/eprover { enableHO = true; };

  giac-with-xcas = giac.override { enableGUI = true; };

  inherit (ocaml-ng.ocamlPackages_4_12) hol_light;

  isabelle = callPackage ../applications/science/logic/isabelle {
    polyml = polyml.overrideAttrs (_: {
      pname = "polyml-for-isabelle";
      version = "2022";
      configureFlags = [ "--enable-intinf-as-int" "--with-gmp" "--disable-shared" ];
      buildFlags = [ "compiler" ];
      src = fetchFromGitHub {
        owner = "polyml";
        repo = "polyml";
        rev = "bafe319bc3a65bf63bd98a4721a6f4dd9e0eabd6";
        sha256 = "1ygs09zzq8icq1gc8qf4sb24lxx7sbcyd5hw3vw67a3ryaki0qw2";
      };
    });

    java = openjdk17;
  };
  isabelle-components = recurseIntoAttrs (callPackage ../applications/science/logic/isabelle/components { });

  lean3 = lean;
  mathlibtools = with python3Packages; toPythonApplication mathlibtools;

  leo2 = callPackage ../applications/science/logic/leo2
    { inherit (ocaml-ng.ocamlPackages_4_05) ocaml camlp4; };

  prooftree = callPackage  ../applications/science/logic/prooftree {
    ocamlPackages = ocaml-ng.ocamlPackages_4_12;
  };

  satallax = callPackage ../applications/science/logic/satallax { };

  spass = callPackage ../applications/science/logic/spass {
    stdenv = gccStdenv;
  };

  statverif = callPackage ../applications/science/logic/statverif {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  veriT = callPackage ../applications/science/logic/verit {
    stdenv = gccStdenv;
  };

  yices = callPackage ../applications/science/logic/yices {
    gmp-static = gmp.override { withStatic = true; };
  };


  inherit (callPackages ../applications/science/logic/z3 { python = python3; })
    z3_4_11
    z3_4_8;
  z3 = z3_4_8;

  tlaplus = callPackage ../applications/science/logic/tlaplus {
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  };
  tlaps = callPackage ../applications/science/logic/tlaplus/tlaps.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  avy = callPackage ../applications/science/logic/avy {};

  ### SCIENCE / ENGINEERING

  strictdoc = python3.pkgs.callPackage ../applications/science/engineering/strictdoc { };

  ### SCIENCE / ELECTRONICS

  appcsxcad = libsForQt5.callPackage ../applications/science/electronics/appcsxcad { };

  eagle = libsForQt5.callPackage ../applications/science/electronics/eagle/eagle.nix { };

  caneda = libsForQt5.callPackage ../applications/science/electronics/caneda { };

  dataexplorer = callPackage ../applications/science/electronics/dataexplorer {
    # executable fails at startup for jdk > 17
    jdk = jdk17;
  };

  geda = callPackage ../applications/science/electronics/geda {
    guile = guile_2_0;
  };

  # this is a wrapper for kicad.base and kicad.libraries
  kicad-small = kicad.override { pname = "kicad-small"; with3d = false; };
  kicad-unstable = kicad.override { pname = "kicad-unstable"; stable = false; };
  # mostly here so the kicad-unstable components (except packages3d) get built
  kicad-unstable-small = kicad.override {
    pname = "kicad-unstable-small";
    stable = false;
    with3d = false;
  };

  librepcb = libsForQt5.callPackage ../applications/science/electronics/librepcb { };

  openems = callPackage ../applications/science/electronics/openems {
    qcsxcad = libsForQt5.qcsxcad;
  };

  openroad = libsForQt5.callPackage ../applications/science/electronics/openroad { };

  xyce = callPackage ../applications/science/electronics/xyce { };

  xyce-parallel = callPackage ../applications/science/electronics/xyce {
    withMPI = true;
    trilinos = trilinos-mpi;
  };

  ### SCIENCE / MATH

  caffe = callPackage ../applications/science/math/caffe ({
    cudaSupport = config.cudaSupport or false;
    cudaPackages = cudaPackages_10_1;
    opencv3 = opencv3WithoutCuda; # Used only for image loading.
    blas = openblas;
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  } // (config.caffe or {}));

  caffeWithCuda = caffe.override { cudaSupport = true; };

  caffeine-ng = python3Packages.callPackage ../tools/X11/caffeine-ng {};

  cntk = callPackage ../applications/science/math/cntk {
    stdenv = gcc7Stdenv;
    inherit (linuxPackages) nvidia_x11;
    opencv3 = opencv3WithoutCuda; # Used only for image loading.
    cudaSupport = config.cudaSupport or false;
  };

  gap-minimal = lowPrio (gap.override { packageSet = "minimal"; });

  gap-full = lowPrio (gap.override { packageSet = "full"; });

  geogebra6 = callPackage ../applications/science/math/geogebra/geogebra6.nix {
    electron = electron_14;
   };

  maxima = callPackage ../applications/science/math/maxima {
    lisp-compiler = sbcl;
  };
  maxima-ecl = maxima.override {
    lisp-compiler = ecl;
  };

  mxnet = callPackage ../applications/science/math/mxnet {
    inherit (linuxPackages) nvidia_x11;
  };

  wxmaxima = callPackage ../applications/science/math/wxmaxima {
    wxGTK = wxGTK32.override {
      withWebKit = true;
    };
  };

  pari = callPackage ../applications/science/math/pari { tex = texlive.combined.scheme-basic; };

  weka = callPackage ../applications/science/math/weka { jre = openjdk11; };

  yacas = libsForQt5.callPackage ../applications/science/math/yacas { };

  yacas-gui = yacas.override {
    enableGui = true;
    enableJupyter = false;
  };

  speedcrunch = libsForQt5.callPackage ../applications/science/math/speedcrunch { };

  ### SCIENCE / MISC

  celestia = callPackage ../applications/science/astronomy/celestia {
    autoreconfHook = buildPackages.autoreconfHook269;
    inherit (gnome2) gtkglext;
  };

  convertall = qt5.callPackage ../applications/science/misc/convertall { };

  cytoscape = callPackage ../applications/science/misc/cytoscape {
    jre = openjdk11;
  };

  faiss = callPackage ../development/libraries/science/math/faiss {
    pythonPackages = python3Packages;
    # faiss wants the "-doxygen" option
    # available only since swig4
    swig = swig4;
  };

  gplates = libsForQt5.callPackage ../applications/science/misc/gplates {
    boost = boost175;
    # build with Python 3.10 fails, because boost <= 1.78 can't find
    # pythons with double digits in minor versions, like X.YZ
    python3 = python39;
  };

  golly = callPackage ../applications/science/misc/golly {
    wxGTK = wxGTK32;
  };

  nextinspace = python3Packages.callPackage ../applications/science/misc/nextinspace { };

  ns-3 = callPackage ../development/libraries/science/networking/ns-3 { python = python3; };

  root = callPackage ../applications/science/misc/root {
    python = python3;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreSymbolication OpenGL;
    # https://github.com/NixOS/nixpkgs/issues/201254
    stdenv = if stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU then gcc11Stdenv else stdenv;
  };

  root5 = lowPrio (callPackage ../applications/science/misc/root/5.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
    stdenv = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;
  });

  rink = callPackage ../applications/science/misc/rink {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  spyder = with python3.pkgs; toPythonApplication spyder;

  stellarium = qt6Packages.callPackage ../applications/science/astronomy/stellarium { };

  stellarsolver = libsForQt5.callPackage ../development/libraries/science/astronomy/stellarsolver { };

  tulip = libsForQt5.callPackage ../applications/science/misc/tulip { };

  ### SCIENCE / PHYSICS

  applgrid = callPackage ../development/libraries/physics/applgrid {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  geant4 = libsForQt5.callPackage ../development/libraries/physics/geant4 { };

  hepmc3 = callPackage ../development/libraries/physics/hepmc3 {
    python = null;
  };

  lhapdf = callPackage ../development/libraries/physics/lhapdf {
    python = python3;
  };

  pythia = callPackage ../development/libraries/physics/pythia {
    hepmc = hepmc2;
  };

  rivet = callPackage ../development/libraries/physics/rivet {
    hepmc = hepmc2;
    imagemagick = graphicsmagick-imagemagick-compat;
  };

  yoda = callPackage ../development/libraries/physics/yoda {
    python = python3;
  };
  yoda-with-root = lowPrio (yoda.override {
    withRootSupport = true;
  });

  ### SCIENCE/ROBOTICS

  apmplanner2 = libsForQt5.callPackage ../applications/science/robotics/apmplanner2 { };

  ### MISC

  android-file-transfer = libsForQt5.callPackage ../tools/filesystems/android-file-transfer { };

  antimicrox = libsForQt5.callPackage ../tools/misc/antimicrox { };

  areca = callPackage ../applications/backup/areca {
    jdk = jdk8;
    jre = jre8;
    swt = swt_jdk8;
  };

  autotiling = python3Packages.callPackage ../misc/autotiling { };

  avell-unofficial-control-center = python3Packages.callPackage ../applications/misc/avell-unofficial-control-center { };

  brgenml1lpr = pkgsi686Linux.callPackage ../misc/cups/drivers/brgenml1lpr {};

  calaos_installer = libsForQt5.callPackage ../misc/calaos/installer {};

  clinfo = callPackage ../tools/system/clinfo {
    inherit (darwin.apple_sdk.frameworks) OpenCL;
  };

  foomatic-db-ppds = callPackage ../misc/cups/drivers/foomatic-db-ppds {};
  foomatic-db-ppds-withNonfreeDb = callPackage ../misc/cups/drivers/foomatic-db-ppds { withNonfreeDb = true; };

  dcp9020cdwlpr = (pkgsi686Linux.callPackage ../misc/cups/drivers/brother/dcp9020cdw { }).driver;

  dcp9020cdw-cupswrapper = (callPackage ../misc/cups/drivers/brother/dcp9020cdw { }).cupswrapper;

  cups-brother-hl1110 = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1110 { };

  cups-brother-hl1210w = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1210w { };

  cups-brother-hl3140cw = pkgsi686Linux.callPackage ../misc/cups/drivers/hl3140cw { };

  cups-brother-hll2340dw = pkgsi686Linux.callPackage  ../misc/cups/drivers/hll2340dw { };

  # this driver ships with pre-compiled 32-bit binary libraries
  cnijfilter_2_80 = pkgsi686Linux.callPackage ../misc/cups/drivers/cnijfilter_2_80 { };

  deploy-rs = callPackage ../tools/package-management/deploy-rs {
    inherit (darwin.apple_sdk.frameworks) CoreServices SystemConfiguration;
  };

  faust = super.faust2;

  gajim = callPackage ../applications/networking/instant-messengers/gajim {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-libav;
    gst-plugins-good = gst_all_1.gst-plugins-good.override { gtkSupport = true; };
  };

  ghostscriptX = ghostscript.override {
    cupsSupport = true;
    x11Support = true;
  };

  ghostscript_headless = ghostscript.override {
    cupsSupport = false;
    x11Support = false;
  };

  gnuk = callPackage ../misc/gnuk {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  hck = callPackage ../tools/text/hck {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  hplipWithPlugin = hplip.override { withPlugin = true; };

  hyperfine = callPackage ../tools/misc/hyperfine {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  websocat = callPackage ../tools/misc/websocat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  vector = callPackage ../tools/misc/vector {
    inherit (darwin.apple_sdk.frameworks) Security CoreServices;
  };

  hjson = with python3Packages; toPythonApplication hjson;

  idsk = callPackage ../tools/filesystems/idsk { stdenv = gcc10StdenvCompat; };

  lima = callPackage ../applications/virtualization/lima {
    inherit (darwin) sigtool;
  };

  image_optim = callPackage ../applications/graphics/image_optim { inherit (nodePackages) svgo; };

  # using the new configuration style proposal which is unstable

  jack2 = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio Accelerate;
    inherit (darwin) libobjc;
  };

  libjack2 = jack2.override { prefix = "lib"; };

  jack-autoconnect = libsForQt5.callPackage ../applications/audio/jack-autoconnect { };
  jack_autoconnect = jack-autoconnect;

  jacktrip = libsForQt5.callPackage ../applications/audio/jacktrip { };

  j2cli = with python3Packages; toPythonApplication j2cli;

  kompute = callPackage ../development/libraries/kompute {
    fmt = fmt_8;
  };

  # In general we only want keep the last three minor versions around that
  # correspond to the last three supported kubernetes versions:
  # https://kubernetes.io/docs/setup/release/version-skew-policy/#supported-versions
  # Exceptions are versions that we need to keep to allow upgrades from older NixOS releases
  inherit (callPackage ../applications/networking/cluster/kops {})
    mkKops
    kops_1_23
    kops_1_24
    kops_1_25
    ;
  kops = kops_1_25;

  lighthouse = darwin.apple_sdk_11_0.callPackage ../applications/blockchains/lighthouse {
    inherit (darwin.apple_sdk_11_0.frameworks) CoreFoundation Security SystemConfiguration;
  };

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };

  lilypond-unstable-with-fonts = callPackage ../misc/lilypond/with-fonts.nix {
    lilypond = lilypond-unstable;
    openlilylib-fonts = openlilylib-fonts.override {
      lilypond = lilypond-unstable;
    };
  };

  lilypond-with-fonts = callPackage ../misc/lilypond/with-fonts.nix { };

  mailcore2 = callPackage ../development/libraries/mailcore2 {
    icu = icu58;
  };

  muse = libsForQt5.callPackage ../applications/audio/muse { };

  nixVersions = recurseIntoAttrs (callPackage ../tools/package-management/nix {
    storeDir = config.nix.storeDir or "/nix/store";
    stateDir = config.nix.stateDir or "/nix/var";
    inherit (darwin.apple_sdk.frameworks) Security;
  });

  nix = nixVersions.stable;

  nixStatic = pkgsStatic.nix;

  nixops = callPackage ../tools/package-management/nixops { };

  nixops_unstable = lowPrio (callPackage ../applications/networking/cluster/nixops { });

  /*
    Evaluate a NixOS configuration using this evaluation of Nixpkgs.

    With this function you can write, for example, a package that
    depends on a custom virtual machine image.

    Parameter:  A module, path or list of those that represent the
                configuration of the NixOS system to be constructed.

    Result: An attribute set containing packages produced by this
            evaluation of NixOS, such as toplevel, kernel and
            initialRamdisk.
            The result can be extended in the modules by defining
            extra attributes in system.build.
            Alternatively, you may use the result's config and
            options attributes to query any option.

    Example:

        let
          myOS = pkgs.nixos ({ lib, pkgs, config, ... }: {

            config.services.nginx = {
              enable = true;
              # ...
            };

            # Use config.system.build to exports relevant parts of a
            # configuration. The runner attribute should not be
            # considered a fully general replacement for systemd
            # functionality.
            config.system.build.run-nginx = config.systemd.services.nginx.runner;
          });
        in
          myOS.run-nginx

    Unlike in plain NixOS, the nixpkgs.config and
    nixpkgs.system options will be ignored by default. Instead,
    nixpkgs.pkgs will have the default value of pkgs as it was
    constructed right after invoking the nixpkgs function (e.g. the
    value of import <nixpkgs> { overlays = [./my-overlay.nix]; }
    but not the value of (import <nixpkgs> {} // { extra = ...; }).

    If you do want to use the config.nixpkgs options, you are
    probably better off by calling nixos/lib/eval-config.nix
    directly, even though it is possible to set config.nixpkgs.pkgs.

    For more information about writing NixOS modules, see
    https://nixos.org/nixos/manual/index.html#sec-writing-modules

    Note that you will need to have called Nixpkgs with the system
    parameter set to the right value for your deployment target.
  */
  nixos =
    configuration:
      let
        c = import (path + "/nixos/lib/eval-config.nix") {
              modules =
                [(
                  { lib, ... }: {
                    config.nixpkgs.pkgs = lib.mkDefault pkgs;
                    config.nixpkgs.localSystem = lib.mkDefault stdenv.hostPlatform;
                  }
                )] ++ (
                  if builtins.isList configuration
                  then configuration
                  else [configuration]
                );
            };
      in
        c.config.system.build // c;

  /*
    A NixOS/home-manager/arion/... module that sets the `pkgs` module argument.
   */
  pkgsModule = { lib, options, ... }: {
    config =
      if options?nixpkgs.pkgs then {
        # legacy / nixpkgs.nix style
        nixpkgs.pkgs = pkgs;
      }
      else {
        # minimal
        _module.args.pkgs = pkgs;
      };
  };

  nixosOptionsDoc = attrs:
    (import ../../nixos/lib/make-options-doc)
    ({ inherit pkgs lib; } // attrs);

  nix-eval-jobs = callPackage ../tools/package-management/nix-eval-jobs {
    nix = nixVersions.nix_2_12; # fails to build with 2.13
  };

  nix-delegate = haskell.lib.compose.justStaticExecutables haskellPackages.nix-delegate;
  nix-deploy = haskell.lib.compose.justStaticExecutables haskellPackages.nix-deploy;
  nix-diff = haskell.lib.compose.justStaticExecutables haskellPackages.nix-diff;

  nix-du = callPackage ../tools/package-management/nix-du {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  nix-info-tested = nix-info.override { doCheck = true; };

  nix-index-unwrapped = callPackage ../tools/package-management/nix-index {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  nix-linter = haskell.lib.compose.justStaticExecutables (haskellPackages.nix-linter);

  nixos-option = callPackage ../tools/nix/nixos-option { nix = nixVersions.nix_2_3; };

  nix-prefetch-github = with python3Packages;
    toPythonApplication nix-prefetch-github;

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-scripts;

  nix-update = python3Packages.callPackage ../tools/package-management/nix-update { };

  nix-template-rpm = callPackage ../build-support/templaterpm { inherit (python2Packages) python toposort; };

  nix-tree = haskell.lib.compose.justStaticExecutables (haskellPackages.nix-tree);

  nix-repl = throw (
    "nix-repl has been removed because it's not maintained anymore, " +
    "use `nix repl` instead. Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );

  nix-serve-ng = haskell.lib.compose.justStaticExecutables haskellPackages.nix-serve-ng;

  nixfmt = haskell.lib.compose.justStaticExecutables haskellPackages.nixfmt;

  nixos-rebuild = callPackage ../os-specific/linux/nixos-rebuild { };

  solfege = python3Packages.callPackage ../misc/solfege { };

  dysnomia = callPackage ../tools/package-management/disnix/dysnomia (config.disnix or {
    inherit (python2Packages) supervisor;
  });

  DisnixWebService = callPackage ../tools/package-management/disnix/DisnixWebService {
    jdk = jdk8;
  };

  lice = python3Packages.callPackage ../tools/misc/lice {};

  mysql-workbench = callPackage ../applications/misc/mysql-workbench (let mysql = mysql80; in {
    gdal = gdal.override {
      libmysqlclient = mysql;
    };
    mysql = mysql;
    pcre = pcre-cpp;
    jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
  });

  resp-app = libsForQt5.callPackage ../applications/misc/resp-app { };

  stork = darwin.apple_sdk_11_0.callPackage ../applications/misc/stork {
    inherit (darwin.apple_sdk_11_0.frameworks) Security;
  };

  OSCAR = qt5.callPackage ../applications/misc/OSCAR { };

  parsedmarc = with python3Packages; toPythonApplication parsedmarc;

  pgadmin4 = callPackage ../tools/admin/pgadmin { };

  pgmodeler = libsForQt5.callPackage ../applications/misc/pgmodeler { };

  pjsip = callPackage ../applications/networking/pjsip {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  pyupgrade = with python3Packages; toPythonApplication pyupgrade;

  pwncat = python3Packages.callPackage ../tools/security/pwncat { };

  pwntools = with python3Packages; toPythonApplication pwntools;

  putty = callPackage ../applications/networking/remote/putty {
    gtk2 = gtk2-x11;
  };

  qMasterPassword = qt6Packages.callPackage ../applications/misc/qMasterPassword { };

  qmake2cmake = python3Packages.callPackage ../tools/misc/qmake2cmake { };

  qtrvsim = libsForQt5.callPackage ../applications/science/computer-architecture/qtrvsim { };

  rates = callPackage ../tools/misc/rates {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pick-colour-picker = python3Packages.callPackage ../applications/graphics/pick-colour-picker {
    inherit glib gtk3 gobject-introspection wrapGAppsHook;
  };

  romdirfs = callPackage ../tools/filesystems/romdirfs {
    stdenv = gccStdenv;
  };

  xdragon = lowPrio (callPackage ../tools/X11/xdragon { });

  timeloop = pkgs.darwin.apple_sdk_11_0.callPackage ../applications/science/computer-architecture/timeloop { };

  mfcj470dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj470dwlpr { };

  mfcj6510dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj6510dwlpr { };

  mfcl2700dnlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcl2700dnlpr { };

  # This driver is only available as a 32 bit proprietary binary driver
  mfcl3770cdwlpr = (callPackage ../misc/cups/drivers/brother/mfcl3770cdw { }).driver;
  mfcl3770cdwcupswrapper = (callPackage ../misc/cups/drivers/brother/mfcl3770cdw { }).cupswrapper;

  samsung-unified-linux-driver = super.samsung-unified-linux-driver_4_01_17;

  sane-backends = callPackage ../applications/graphics/sane/backends (config.sane or {});

  sc-controller = python3Packages.callPackage ../misc/drivers/sc-controller {
    inherit libusb1; # Shadow python.pkgs.libusb1.
  };

  scylladb = callPackage ../servers/scylladb {
    thrift = thrift-0_10;
  };

  slock = callPackage ../misc/screensavers/slock {
    conf = config.slock.conf or null;
  };

  snscrape = with python3Packages; toPythonApplication snscrape;

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  spacenavd = callPackage ../misc/drivers/spacenavd {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  tellico = libsForQt5.callPackage ../applications/misc/tellico { };

  termpdfpy = python3Packages.callPackage ../applications/misc/termpdf.py {};

  inherit (callPackage ../applications/networking/cluster/terraform { })
    mkTerraform
    terraform_1
    terraform_plugins_test
    ;

  terraform = terraform_1;

  terraform-providers = recurseIntoAttrs (
    callPackage ../applications/networking/cluster/terraform-providers { }
  );

  terraform-compliance = python3Packages.callPackage ../applications/networking/cluster/terraform-compliance {};

  ib-tws = callPackage ../applications/office/ib/tws { jdk=oraclejdk8; };

  ib-controller = callPackage ../applications/office/ib/controller { jdk=oraclejdk8; };

  vnote = libsForQt5.callPackage ../applications/office/vnote { };

  tvheadend = callPackage ../servers/tvheadend {
    dtv-scan-tables = dtv-scan-tables_tvheadend;
  };

  unixcw = libsForQt5.callPackage ../applications/radio/unixcw { };

  vaultenv = haskell.lib.justStaticExecutables haskellPackages.vaultenv;

  vaultwarden = callPackage ../tools/security/vaultwarden {
    inherit (darwin.apple_sdk.frameworks) Security CoreServices;
  };
  vaultwarden-sqlite = vaultwarden;
  vaultwarden-mysql = vaultwarden.override { dbBackend = "mysql"; };
  vaultwarden-postgresql = vaultwarden.override { dbBackend = "postgresql"; };

  vimPlugins = recurseIntoAttrs (callPackage ../applications/editors/vim/plugins {
    llvmPackages = llvmPackages_6;
    luaPackages = lua51Packages;
  });

  vimb = wrapFirefox vimb-unwrapped { };

  vips = callPackage ../tools/graphics/vips {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Foundation;
  };

  vivisect = with python3Packages; toPythonApplication (vivisect.override { withGui = true; });

  vokoscreen = libsForQt5.callPackage ../applications/video/vokoscreen { };

  vokoscreen-ng = libsForQt5.callPackage ../applications/video/vokoscreen-ng {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly;
  };

  wacomtablet = libsForQt5.callPackage ../tools/misc/wacomtablet { };

  wasmer = callPackage ../development/interpreters/wasmer {
    llvmPackages = llvmPackages_12;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation SystemConfiguration Security;
  };

  wasm-pack = callPackage ../development/tools/wasm-pack {
    inherit (darwin.apple_sdk.frameworks) Security;
    libressl = libressl_3_5;
  };

  wibo = pkgsi686Linux.callPackage ../applications/emulators/wibo { };

  wikicurses = callPackage ../applications/misc/wikicurses {
    pythonPackages = python3Packages;
  };

  wiki-tui = callPackage ../misc/wiki-tui {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  winePackagesFor = wineBuild: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit wineBuild;

    inherit (callPackage ./wine-packages.nix {})
      minimal base full stable stableFull unstable unstableFull staging stagingFull wayland waylandFull fonts;
  });

  winePackages = recurseIntoAttrs (winePackagesFor (config.wine.build or "wine32"));
  wine64Packages = recurseIntoAttrs (winePackagesFor "wine64");
  wineWowPackages = recurseIntoAttrs (winePackagesFor "wineWow");

  wine = winePackages.full;
  wine64 = wine64Packages.full;

  wine-staging = lowPrio (winePackages.full.override {
    wineRelease = "staging";
  });

  wine-wayland = lowPrio (winePackages.full.override {
    wineRelease = "wayland";
  });

  wizer = darwin.apple_sdk_11_0.callPackage ../development/tools/wizer {};

  inherit (callPackage ../servers/web-apps/wordpress {}) wordpress wordpress6_1;

  wordpressPackages = ( callPackage ../servers/web-apps/wordpress/packages {
    plugins = lib.importJSON ../servers/web-apps/wordpress/packages/plugins.json;
    themes = lib.importJSON ../servers/web-apps/wordpress/packages/themes.json;
    languages = lib.importJSON ../servers/web-apps/wordpress/packages/languages.json;
  });

  wraith = callPackage ../applications/networking/irc/wraith {
    openssl = openssl_1_1;
  };

  wxsqlite3 = callPackage ../development/libraries/wxsqlite3 {
    wxGTK = wxGTK32;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    inherit (darwin.stubs) setfile rez derez;
  };

  wxsqliteplus = callPackage ../development/libraries/wxsqliteplus {
    wxGTK = wxGTK32;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    inherit (darwin.stubs) setfile;
  };

  xortool = python3Packages.callPackage ../tools/security/xortool { };

  xbps = callPackage ../tools/package-management/xbps {
    openssl = openssl_1_1;
  };

  xhyve = callPackage ../applications/virtualization/xhyve {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin) libobjc;
  };

  xsane = callPackage ../applications/graphics/sane/xsane.nix {
    libpng = libpng12;
    sane-backends = sane-backends.override { libpng = libpng12; };
  };

  xsser = python3Packages.callPackage ../tools/security/xsser { };

  xsw = callPackage ../applications/misc/xsw {
    # Enable the next line to use this in terminal.
    # Note that it requires sixel capable terminals such as mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
  };

  yabai = darwin.apple_sdk_11_0.callPackage ../os-specific/darwin/yabai {
    inherit (darwin.apple_sdk_11_0.frameworks) SkyLight Cocoa Carbon ScriptingBridge;
  };

  yacreader = libsForQt5.callPackage ../applications/graphics/yacreader { };

  yamale = with python3Packages; toPythonApplication yamale;

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  bullet = callPackage ../development/libraries/bullet {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  bullet-roboschool = callPackage ../development/libraries/bullet/roboschool-fork.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  inherit (callPackages ../development/libraries/spdlog { })
    spdlog_0 spdlog_1;

  spdlog = spdlog_1;

  httraqt = libsForQt5.callPackage ../tools/backup/httrack/qt.nix { };

  discord = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "stable";
  };

  discord-ptb = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "ptb";
  };

  discord-canary = import ../applications/networking/instant-messengers/discord {
    inherit lib stdenv;
    inherit (pkgs) callPackage fetchurl;
    branch = "canary";
  };

  golden-cheetah = libsForQt5.callPackage ../applications/misc/golden-cheetah {};

  sccache = callPackage ../development/tools/misc/sccache {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  snowmachine = python3Packages.callPackage ../applications/misc/snowmachine {};

  tora = libsForQt5.callPackage ../development/tools/tora {};

  xulrunner = firefox-unwrapped;

  nitrokey-app = libsForQt5.callPackage ../tools/security/nitrokey-app { };

  hy = with python3Packages; toPythonApplication hy;

  ghc-standalone-archive = callPackage ../os-specific/darwin/ghc-standalone-archive { inherit (darwin) cctools; };

  vdrPlugins = recurseIntoAttrs (callPackage ../applications/video/vdr/plugins.nix { });

  chrome-token-signing = libsForQt5.callPackage ../tools/security/chrome-token-signing {};

  PlistCpp = callPackage ../development/libraries/PlistCpp {
    boost = boost172;
  };

  linode-cli = python3Packages.callPackage ../tools/virtualization/linode-cli {};

  openvino = callPackage ../development/libraries/openvino
    { stdenv = gcc10StdenvCompat; python = python3; };

  phonetisaurus = callPackage ../development/libraries/phonetisaurus {
    # https://github.com/AdolfVonKleist/Phonetisaurus/issues/70
    openfst = openfst.overrideAttrs (_: rec {
      version = "1.7.9";
      src = fetchurl {
        url = "http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-${version}.tar.gz";
        sha256 = "1pmx1yhn2gknj0an0zwqmzgwjaycapi896244np50a8y3nrsw6ck";
      };
    });
  };

  duti = callPackage ../os-specific/darwin/duti {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  dnstracer = callPackage ../tools/networking/dnstracer {
    inherit (darwin) libresolv;
  };

  simple-http-server = callPackage ../servers/simple-http-server {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  diceware = with python3Packages; toPythonApplication diceware;

  xml2rfc = with python3Packages; toPythonApplication xml2rfc;

  ape = callPackage ../applications/misc/ape { };
  apeClex = callPackage ../applications/misc/ape/apeclex.nix { };

  # Unix tools
  unixtools = recurseIntoAttrs (callPackages ./unixtools.nix { });
  inherit (unixtools) hexdump ps logger eject umount
                      mount wall hostname more sysctl getconf
                      getent locale killall xxd watch;

  fts = if stdenv.hostPlatform.isMusl then netbsd.fts else null;

  bsdSetupHook = makeSetupHook {
    name = "bsd-setup-hook";
  } ../os-specific/bsd/setup-hook.sh;

  freebsd = callPackage ../os-specific/bsd/freebsd {};
  freebsdCross = callPackage ../os-specific/bsd/freebsd {
    stdenv = crossLibcStdenv;
  };

  netbsd = callPackage ../os-specific/bsd/netbsd {};
  netbsdCross = callPackage ../os-specific/bsd/netbsd {
    stdenv = crossLibcStdenv;
  };

  alibuild = callPackage ../development/tools/build-managers/alibuild {
    python = python3;
  };

  bcompare = libsForQt5.callPackage ../applications/version-management/bcompare {};

  xp-pen-deco-01-v2-driver = libsForQt5.xp-pen-deco-01-v2-driver;

  xp-pen-g430-driver = libsForQt5.xp-pen-g430-driver;

  newlib = callPackage ../development/misc/newlib { };
  newlibCross = callPackage ../development/misc/newlib {
    stdenv = crossLibcStdenv;
  };

  newlib-nano = callPackage ../development/misc/newlib {
    nanoizeNewlib = true;
  };
  newlib-nanoCross = callPackage ../development/misc/newlib {
    nanoizeNewlib = true;
    stdenv = crossLibcStdenv;
  };

  wfuzz = with python3Packages; toPythonApplication wfuzz;

  kube3d =  callPackage ../applications/networking/cluster/kube3d {
    buildGoModule = buildGo118Module; # tests fail with 1.19
  };

  zfs-replicate = python3Packages.callPackage ../tools/backup/zfs-replicate { };

  kodelife = callPackage ../applications/graphics/kodelife {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  sieveshell = with python3.pkgs; toPythonApplication managesieve;

  jami = callPackages ../applications/networking/instant-messengers/jami {
    # TODO: remove once `udev` is `systemdMinimal` everywhere.
    udev = systemdMinimal;
    jack = libjack2;
  };
  inherit (jami) jami-daemon jami-client;

  zettlr = callPackage ../applications/misc/zettlr {
    texlive = texlive.combined.scheme-medium;
  };

  fac-build = callPackage ../development/tools/build-managers/fac {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  cagebreak = callPackage ../applications/window-managers/cagebreak {
    wlroots = wlroots_0_15;
  };

  ldid = callPackage ../development/tools/ldid {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  zrythm = callPackage ../applications/audio/zrythm {
    inherit (plasma5Packages) breeze-icons;
  };

  aitrack = libsForQt5.callPackage ../applications/misc/aitrack { };

}
