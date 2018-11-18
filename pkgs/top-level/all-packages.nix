/* The top-level package collection of nixpkgs.
 * It is sorted by categories corresponding to the folder names
 * in the /pkgs folder. Inside the categories packages are roughly
 * sorted by alphabet, but strict sorting has been long lost due
 * to merges. Please use the full-text search of your editor. ;)
 * Hint: ### starts category names.
 */
{ lib, noSysDirs, config}:
self: pkgs:

with pkgs;

{

  # Allow callPackage to fill in the pkgs argument
  inherit pkgs;

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (if stdenv.hostPlatform.is32bit then stdenv else multiStdenv);

  stdenvNoCC = stdenv.override { cc = null; };

  stdenvNoLibs = let
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

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Helper functions.
  inherit lib config;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  stringsWithDeps = lib.stringsWithDeps;

  ### Evaluating the entire Nixpkgs naively will fail, make failure fast
  AAAAAASomeThingsFailToEvaluate = throw ''
    Please be informed that this pseudo-package is not the only part of
    Nixpkgs that fails to evaluate. You should not evaluate entire Nixpkgs
    without some special measures to handle failing packages, like those taken
    by Hydra.
  '';

  tests = recurseIntoAttrs (callPackages ../test {});

  ### Nixpkgs maintainer tools

  nix-generate-from-cpan = callPackage ../../maintainers/scripts/nix-generate-from-cpan.nix { };

  nixpkgs-lint = callPackage ../../maintainers/scripts/nixpkgs-lint.nix { };

  common-updater-scripts = callPackage ../common-updater/scripts.nix { };

  ### Push NixOS tests inside the fixed point

  nixosTests = import ../../nixos/tests/all-tests.nix {
    inherit pkgs;
    system = stdenv.hostPlatform.system;
    callTest = t: t.test;
  };

  ### BUILD SUPPORT

  autoreconfHook = makeSetupHook
    { deps = [ autoconf automake gettext libtool ]; }
    ../build-support/setup-hooks/autoreconf.sh;

  autoreconfHook264 = makeSetupHook
    { deps = [ autoconf264 automake111x gettext libtool ]; }
    ../build-support/setup-hooks/autoreconf.sh;

  autoPatchelfHook = makeSetupHook { name = "auto-patchelf-hook"; }
    ../build-support/setup-hooks/auto-patchelf.sh;

  ensureNewerSourcesHook = { year }: makeSetupHook {}
    (writeScript "ensure-newer-sources-hook.sh" ''
      postUnpackHooks+=(_ensureNewerSources)
      _ensureNewerSources() {
        '${findutils}/bin/find' "$sourceRoot" \
          '!' -newermt '${year}-01-01' -exec touch -h -d '${year}-01-02' '{}' '+'
      }
    '');

  # Zip file format only allows times after year 1980, which makes e.g. Python wheel building fail with:
  # ValueError: ZIP does not support timestamps before 1980
  ensureNewerSourcesForZipFilesHook = ensureNewerSourcesHook { year = "1980"; };

  updateAutotoolsGnuConfigScriptsHook = makeSetupHook
    { substitutions = { gnu_config = gnu-config;}; }
    ../build-support/setup-hooks/update-autotools-gnu-config-scripts.sh;

  gogUnpackHook = makeSetupHook {
    name = "gog-unpack-hook";
    deps = [ innoextract file-rename ]; }
    ../build-support/setup-hooks/gog-unpack.sh;

  buildEnv = callPackage ../build-support/buildenv { }; # not actually a package

  buildFHSUserEnv = callPackage ../build-support/build-fhs-userenv { };

  buildMaven = callPackage ../build-support/build-maven.nix {};

  dhallToNix = callPackage ../build-support/dhall-to-nix.nix {
    inherit dhall-nix;
  };

  diffPlugins = (callPackage ../build-support/plugins.nix {}).diffPlugins;

  dieHook = makeSetupHook {} ../build-support/setup-hooks/die.sh;

  archiver = callPackage ../applications/misc/archiver { };

  digitalbitbox = libsForQt5.callPackage ../applications/misc/digitalbitbox { };

  dockerTools = callPackage ../build-support/docker { };

  docker-compose = python3Packages.callPackage ../applications/virtualization/docker-compose {};

  dotnetenv = callPackage ../build-support/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  dotnet-sdk = callPackage ../development/compilers/dotnet/sdk { };

  etBook = callPackage ../data/fonts/et-book { };

  fetchbower = callPackage ../build-support/fetchbower {
    inherit (nodePackages) bower2nix;
  };

  fetchdocker = callPackage ../build-support/fetchdocker { };

  fetchDockerConfig = callPackage ../build-support/fetchdocker/fetchDockerConfig.nix { };

  fetchDockerLayer = callPackage ../build-support/fetchdocker/fetchDockerLayer.nix { };

  fetchgit = callPackage ../build-support/fetchgit {
    git = gitMinimal;
  };

  fetchgitPrivate = callPackage ../build-support/fetchgit/private.nix { };

  fetchgitLocal = callPackage ../build-support/fetchgitlocal { };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

  fetchMavenArtifact = callPackage ../build-support/fetchmavenartifact { };

  global-platform-pro = callPackage ../development/tools/global-platform-pro/default.nix { };

  pet = callPackage ../development/tools/pet { };

  fetchpatch = callPackage ../build-support/fetchpatch { };

  fetchsvn = callPackage ../build-support/fetchsvn {
    sshSupport = true;
  };

  fetchsvnrevision = import ../build-support/fetchsvnrevision runCommand subversion;

  fetchsvnssh = callPackage ../build-support/fetchsvnssh {
    sshSupport = true;
  };

  fetchhg = callPackage ../build-support/fetchhg { };

  # `fetchurl' downloads a file from the network.
  fetchurl = import ../build-support/fetchurl {
    inherit lib stdenvNoCC;
    # On darwin, libkrb5 needs bootstrap_cmds which would require
    # converting many packages to fetchurl_boot to avoid evaluation cycles.
    curl = buildPackages.curl.override (lib.optionalAttrs stdenv.isDarwin { gssSupport = false; });
  };

  fetchRepoProject = callPackage ../build-support/fetchrepoproject { };

  fetchipfs = import ../build-support/fetchipfs {
    inherit curl stdenv;
  };

  # fetchurlBoot is used for curl and its dependencies in order to
  # prevent a cyclic dependency (curl depends on curl.tar.bz2,
  # curl.tar.bz2 depends on fetchurl, fetchurl depends on curl).  It
  # uses the curl from the previous bootstrap phase (e.g. a statically
  # linked curl in the case of stdenv-linux).
  fetchurlBoot = stdenv.fetchurlBoot;

  fetchzip = callPackage ../build-support/fetchzip { };

  fetchCrate = callPackage ../build-support/rust/fetchcrate.nix { };

  fetchFromGitHub = {
    owner, repo, rev, name ? "source",
    fetchSubmodules ? false, private ? false,
    githubBase ? "github.com", varPrefix ? null,
    ... # For hash agility
  }@args: assert private -> !fetchSubmodules;
  let
    baseUrl = "https://${githubBase}/${owner}/${repo}";
    passthruAttrs = removeAttrs args [ "owner" "repo" "rev" "fetchSubmodules" "private" "githubBase" "varPrefix" ];
    varBase = "NIX${if varPrefix == null then "" else "_${varPrefix}"}_GITHUB_PRIVATE_";
    # We prefer fetchzip in cases we don't need submodules as the hash
    # is more stable in that case.
    fetcher = if fetchSubmodules then fetchgit else fetchzip;
    privateAttrs = lib.optionalAttrs private {
      netrcPhase = ''
        if [ -z "''$${varBase}USERNAME" -o -z "''$${varBase}PASSWORD" ]; then
          echo "Error: Private fetchFromGitHub requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}USERNAME and ${varBase}PASSWORD env vars set." >&2
          exit 1
        fi
        cat > netrc <<EOF
        machine ${githubBase}
                login ''$${varBase}USERNAME
                password ''$${varBase}PASSWORD
        EOF
      '';
      netrcImpureEnvVars = [ "${varBase}USERNAME" "${varBase}PASSWORD" ];
    };
    fetcherArgs = (if fetchSubmodules
        then { inherit rev fetchSubmodules; url = "${baseUrl}.git"; }
        else ({ url = "${baseUrl}/archive/${rev}.tar.gz"; } // privateAttrs)
      ) // passthruAttrs // { inherit name; };
  in fetcher fetcherArgs // { meta.homepage = baseUrl; inherit rev; };

  fetchFromBitbucket = {
    owner, repo, rev, name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
    meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
    extraPostFetch = ''rm -f "$out"/.hg_archival.txt''; # impure file; see #12002
  } // removeAttrs args [ "owner" "repo" "rev" ]) // { inherit rev; };

  # cgit example, snapshot support is optional in cgit
  fetchFromSavannah = {
    repo, rev, name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "http://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
    meta.homepage = "http://git.savannah.gnu.org/cgit/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; };

  # gitlab example
  fetchFromGitLab = {
    owner, repo, rev, domain ? "gitlab.com", name ? "source", group ? null,
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "https://${domain}/api/v4/projects/${lib.optionalString (group != null) "${group}%2F"}${owner}%2F${repo}/repository/archive.tar.gz?sha=${rev}";
    meta.homepage = "https://${domain}/${lib.optionalString (group != null) "${group}/"}${owner}/${repo}/";
  } // removeAttrs args [ "domain" "owner" "group" "repo" "rev" ]) // { inherit rev; };

  # gitweb example, snapshot support is optional in gitweb
  fetchFromRepoOrCz = {
    repo, rev, name ? "source",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "http://repo.or.cz/${repo}.git/snapshot/${rev}.tar.gz";
    meta.homepage = "http://repo.or.cz/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; };

  fetchNuGet = callPackage ../build-support/fetchnuget { };
  buildDotnetPackage = callPackage ../build-support/build-dotnet-package { };

  resolveMirrorURLs = {url}: fetchurl {
    showURLs = true;
    inherit url;
  };

  ld-is-cc-hook = makeSetupHook { name = "ld-is-cc-hook"; }
    ../build-support/setup-hooks/ld-is-cc-hook.sh;

  makeDesktopItem = callPackage ../build-support/make-desktopitem { };

  makeAutostartItem = callPackage ../build-support/make-startupitem { };

  makeInitrd = { contents, compressor ? "gzip -9n", prepend ? [ ] }:
    callPackage ../build-support/kernel/make-initrd.nix {
      inherit contents compressor prepend;
    };

  makeWrapper = makeSetupHook { deps = [ dieHook ]; }
                              ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = { kernel, firmware, rootModules, allowMissing ? false }:
    callPackage ../build-support/kernel/modules-closure.nix {
      inherit kernel firmware rootModules allowMissing;
    };

  mkShell = callPackage ../build-support/mkshell { };

  nixBufferBuilders = import ../build-support/emacs/buffer.nix { inherit (pkgs) lib writeText; inherit (emacsPackagesNg) inherit-local; };

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  pruneLibtoolFiles = makeSetupHook { name = "prune-libtool-files"; }
    ../build-support/setup-hooks/prune-libtool-files.sh;

  closureInfo = callPackage ../build-support/closure-info.nix { };

  setupSystemdUnits = callPackage ../build-support/setup-systemd-units.nix { };

  srcOnly = args: callPackage ../build-support/src-only args;

  substituteAll = callPackage ../build-support/substitute/substitute-all.nix { };

  substituteAllFiles = callPackage ../build-support/substitute-files/substitute-all-files.nix { };

  replaceDependency = callPackage ../build-support/replace-dependency.nix { };

  nukeReferences = callPackage ../build-support/nuke-references { };

  referencesByPopularity = callPackage ../build-support/references-by-popularity { };

  removeReferencesTo = callPackage ../build-support/remove-references-to { };

  vmTools = callPackage ../build-support/vm { };

  releaseTools = callPackage ../build-support/release { };

  composableDerivation = callPackage ../../lib/composable-derivation.nix { };

  inherit (lib.systems) platforms;

  setJavaClassPath = makeSetupHook { } ../build-support/setup-hooks/set-java-classpath.sh;

  fixDarwinDylibNames = makeSetupHook { } ../build-support/setup-hooks/fix-darwin-dylib-names.sh;

  keepBuildTree = makeSetupHook { } ../build-support/setup-hooks/keep-build-tree.sh;

  enableGCOVInstrumentation = makeSetupHook { } ../build-support/setup-hooks/enable-coverage-instrumentation.sh;

  makeGCOVReport = makeSetupHook
    { deps = [ pkgs.lcov pkgs.enableGCOVInstrumentation ]; }
    ../build-support/setup-hooks/make-coverage-analysis-report.sh;

  # intended to be used like nix-build -E 'with import <nixpkgs> {}; enableDebugging fooPackage'
  enableDebugging = pkg: pkg.override { stdenv = stdenvAdapters.keepDebugInfo pkg.stdenv; };

  findXMLCatalogs = makeSetupHook { } ../build-support/setup-hooks/find-xml-catalogs.sh;

  wrapGAppsHook = makeSetupHook {
    deps = [ gnome3.dconf.lib gnome3.gtk librsvg makeWrapper ];
  } ../build-support/setup-hooks/wrap-gapps-hook.sh;

  separateDebugInfo = makeSetupHook { } ../build-support/setup-hooks/separate-debug-info.sh;

  setupDebugInfoDirs = makeSetupHook { } ../build-support/setup-hooks/setup-debug-info-dirs.sh;

  useOldCXXAbi = makeSetupHook { } ../build-support/setup-hooks/use-old-cxx-abi.sh;

  iconConvTools = callPackage ../build-support/icon-conv-tools {};


  ### TOOLS

  _1password = callPackage ../applications/misc/1password { };

  _9pfs = callPackage ../tools/filesystems/9pfs { };

  acme-sh = callPackage ../tools/admin/acme.sh { };

  acoustidFingerprinter = callPackage ../tools/audio/acoustid-fingerprinter {
    ffmpeg = ffmpeg_1;
  };

  actdiag = with python3.pkgs; toPythonApplication actdiag;

  aegisub = callPackage ../applications/video/aegisub {
    wxGTK = wxGTK30;
    spellcheckSupport = config.aegisub.spellcheckSupport or true;
    automationSupport = config.aegisub.automationSupport or true;
    openalSupport     = config.aegisub.openalSupport or false;
    alsaSupport       = config.aegisub.alsaSupport or true;
    pulseaudioSupport = config.aegisub.pulseaudioSupport or true;
    portaudioSupport  = config.aegisub.portaudioSupport or false;
  };

  acme-client = callPackage ../tools/networking/acme-client { inherit (darwin) apple_sdk; };

  amass = callPackage ../tools/networking/amass { };

  afew = callPackage ../applications/networking/mailreaders/afew { pythonPackages = python3Packages; };

  afl = callPackage ../tools/security/afl {
    stdenv = clangStdenv;
  };

  aha = callPackage ../tools/text/aha { };

  airspy = callPackage ../applications/misc/airspy { };

  aj-snapshot  = callPackage ../applications/audio/aj-snapshot { };

  albert = libsForQt5.callPackage ../applications/misc/albert {};

  alacritty = callPackage ../applications/misc/alacritty {
    inherit (xorg) libXcursor libXxf86vm libXi;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  apktool = callPackage ../development/tools/apktool {
    buildTools = androidenv.buildTools;
  };

  arduino = arduino-core.override { withGui = true; };

  arduino-core = callPackage ../development/arduino/arduino-core {
    jdk = jdk;
    withGui = false;
  };

  apitrace = libsForQt5.callPackage ../applications/graphics/apitrace {};

  arguments = callPackage ../development/libraries/arguments { };

  argus = callPackage ../tools/networking/argus {};

  inherit (callPackages ../data/fonts/arphic {})
    arphic-ukai arphic-uming;

  ascii = callPackage ../tools/text/ascii { };

  asymptote = callPackage ../tools/graphics/asymptote {
    texLive = texlive.combine { inherit (texlive) scheme-small epsf cm-super; };
    gsl = gsl_1;
  };

  atomicparsley = callPackage ../tools/video/atomicparsley {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  avfs = callPackage ../tools/filesystems/avfs { };

  aws_shell = pythonPackages.callPackage ../tools/admin/aws_shell { };

  azure-cli = nodePackages.azure-cli;

  azure-storage-azcopy = callPackage ../development/tools/azcopy { };

  azure-vhd-utils  = callPackage ../tools/misc/azure-vhd-utils { };

  ec2_api_tools = callPackage ../tools/virtualization/ec2-api-tools { };

  ec2_ami_tools = callPackage ../tools/virtualization/ec2-ami-tools { };

  amule = callPackage ../tools/networking/p2p/amule { };

  amuleDaemon = appendToName "daemon" (amule.override {
    monolithic = false;
    daemon = true;
  });

  amuleGui = appendToName "gui" (amule.override {
    monolithic = false;
    client = true;
  });

  apt = callPackage ../tools/package-management/apt {
    inherit (perlPackages) Po4a;
    # include/c++/6.4.0/cstdlib:75:25: fatal error: stdlib.h: No such file or directory
    stdenv = overrideCC stdenv gcc5;
  };

  go-check = callPackage ../development/tools/check { };

  cozy = callPackage ../applications/audio/cozy-audiobooks { };

  dkimpy = with pythonPackages; toPythonApplication dkimpy;

  encryptr = callPackage ../tools/security/encryptr {
    gconf = gnome2.GConf;
  };

  enpass = callPackage ../tools/security/enpass { };

  esh = callPackage ../tools/text/esh { };

  gams = callPackage ../tools/misc/gams {
    licenseFile = config.gams.licenseFile or null;
    optgamsFile = config.gams.optgamsFile or null;
  };

  gitter = callPackage  ../applications/networking/instant-messengers/gitter { };

  green-pdfviewer = callPackage ../applications/misc/green-pdfviewer {
   SDL = SDL_sixel;
  };

  ipgrep = callPackage ../tools/networking/ipgrep { };

  pass = callPackage ../tools/security/pass { };

  passExtensions = recurseIntoAttrs pass.extensions;

  gopass = callPackage ../tools/security/gopass {
    buildGoPackage = buildGo110Package;
  };

  kwm = callPackage ../os-specific/darwin/kwm { };

  khd = callPackage ../os-specific/darwin/khd {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  m-cli = callPackage ../os-specific/darwin/m-cli { };

  skhd = callPackage ../os-specific/darwin/skhd {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  qes = callPackage ../os-specific/darwin/qes {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  adbfs-rootless = callPackage ../development/mobile/adbfs-rootless {
    adb = androidenv.platformTools;
  };

  androidenv = callPackage ../development/mobile/androidenv {
    pkgs_i686 = pkgsi686Linux;
    licenseAccepted = (config.android_sdk.accept_license or false);
  };

  inherit (androidenv) androidndk;

  androidsdk = androidenv.androidsdk_8_0;

  androidsdk_extras = self.androidenv.androidsdk_8_0_extras;

  webos = recurseIntoAttrs {
    cmake-modules = callPackage ../development/mobile/webos/cmake-modules.nix { };

    novacom = callPackage ../development/mobile/webos/novacom.nix { };
    novacomd = callPackage ../development/mobile/webos/novacomd.nix { };
  };

  arc-theme = callPackage ../misc/themes/arc { };

  arc-kde-theme = callPackage ../misc/themes/arc-kde { };

  adapta-gtk-theme = callPackage ../misc/themes/adapta { };

  adapta-kde-theme = callPackage ../misc/themes/adapta-kde { };

  aria2 = callPackage ../tools/networking/aria2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  aria = aria2;

  at = callPackage ../tools/system/at { };

  autogen = callPackage ../development/tools/misc/autogen {
    guile = guile_2_0;
  };

  avahi = callPackage ../development/libraries/avahi {
    qt4Support = config.avahi.qt4Support or false;
  };

  avro-c = callPackage ../development/libraries/avro-c { };

  avro-cpp = callPackage ../development/libraries/avro-c++ { boost = boost160; };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  axel = callPackage ../tools/networking/axel {
    libssl = openssl;
  };

  axoloti = callPackage ../applications/audio/axoloti {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };
  dfu-util-axoloti = callPackage ../applications/audio/axoloti/dfu-util.nix { };
  libusb1-axoloti = callPackage ../applications/audio/axoloti/libusb1.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  backblaze-b2 = python.pkgs.callPackage ../development/tools/backblaze-b2 { };

  bar = callPackage ../tools/system/bar {};

  bat = callPackage ../tools/misc/bat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bc = callPackage ../tools/misc/bc { };

  bcat = callPackage ../tools/text/bcat {};

  inherit (callPackages ../misc/logging/beats/6.x.nix { })
    filebeat6
    heartbeat6
    metricbeat6
    packetbeat6;

  filebeat = filebeat6;
  heartbeat = heartbeat6;
  metricbeat = metricbeat6;
  packetbeat = packetbeat6;

  inherit (callPackages ../misc/logging/beats/5.x.nix { })
    filebeat5
    heartbeat5
    metricbeat5
    packetbeat5;

  bfr = callPackage ../tools/misc/bfr { };

  bitbucket-cli = python2Packages.bitbucket-cli;

  blink = callPackage ../applications/networking/instant-messengers/blink { };

  libqmatrixclient = libsForQt5.callPackage ../development/libraries/libqmatrixclient { };

  quaternion = libsForQt5.callPackage ../applications/networking/instant-messengers/quaternion { };

  tensor = libsForQt5.callPackage ../applications/networking/instant-messengers/tensor { };

  libtensorflow = callPackage ../development/libraries/libtensorflow {
    cudaSupport = config.cudaSupport or false;
    inherit (linuxPackages) nvidia_x11;
    cudatoolkit = cudatoolkit_9_0;
    cudnn = cudnn_cudatoolkit_9_0;
  };

  blitz = callPackage ../development/libraries/blitz {
    boost = boost160;
  };

  blockdiag = with python3Packages; toPythonApplication blockdiag;

  blsd = callPackage ../tools/misc/blsd {
    libgit2 = libgit2_0_27;
  };

  bmon = callPackage ../tools/misc/bmon { };

  borgbackup = callPackage ../tools/backup/borg { };

  boomerang = libsForQt5.callPackage ../development/tools/boomerang { };

  boot = callPackage ../development/tools/build-managers/boot { };

  brasero-original = lowPrio (callPackage ../tools/cd-dvd/brasero { });

  brasero = callPackage ../tools/cd-dvd/brasero/wrapper.nix { };

  brltty = callPackage ../tools/misc/brltty {
    alsaSupport = (!stdenv.isDarwin);
    systemdSupport = stdenv.isLinux;
  };
  bro = callPackage ../applications/networking/ids/bro { };

  breakpointHook = assert stdenv.isLinux;
    makeSetupHook { } ../build-support/setup-hooks/breakpoint-hook.sh;

  bsod = callPackage ../misc/emulators/bsod { };

  btrbk = callPackage ../tools/backup/btrbk {
    asciidoc = asciidoc-full;
  };

  bustle = haskellPackages.bustle;

  bwm_ng = callPackage ../tools/networking/bwm-ng { };

  byobu = callPackage ../tools/misc/byobu {
    # Choices: [ tmux screen ];
    textual-window-manager = tmux;
  };

  bsh = fetchurl {
    url = http://www.beanshell.org/bsh-2.0b5.jar;
    sha256 = "0p2sxrpzd0vsk11zf3kb5h12yl1nq4yypb5mpjrm8ww0cfaijck2";
  };

  c3d = callPackage ../applications/graphics/c3d {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  cabal2nix = haskell.lib.overrideCabal (haskell.lib.generateOptparseApplicativeCompletion "cabal2nix" haskellPackages.cabal2nix) (drv: {
    isLibrary = false;
    enableSharedExecutables = false;
    executableToolDepends = (drv.executableToolDepends or []) ++ [ makeWrapper ];
    postInstall = ''
      exe=$out/libexec/${drv.pname}-${drv.version}/${drv.pname}
      install -D $out/bin/${drv.pname} $exe
      rm -rf $out/{bin,lib,share}
      makeWrapper $exe $out/bin/${drv.pname} \
        --prefix PATH ":" "${nix}/bin" \
        --prefix PATH ":" "${nix-prefetch-scripts}/bin"
    '' + (drv.postInstall or "");
  });

  stack2nix = with haskell.lib; overrideCabal (justStaticExecutables haskellPackages.stack2nix) (drv: {
    executableToolDepends = [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/stack2nix \
        --prefix PATH ":" "${git}/bin:${cabal-install}/bin"
    '';
  });

  calamares = libsForQt5.callPackage ../tools/misc/calamares {
    python = python3;
    boost = pkgs.boost.override { python = python3; };
  };

  casync = callPackage ../applications/networking/sync/casync {
    sphinx = python3Packages.sphinx;
  };

  cataract          = callPackage ../applications/misc/cataract { };
  cataract-unstable = callPackage ../applications/misc/cataract/unstable.nix { };

  catch = callPackage ../development/libraries/catch { };

  catdoc = callPackage ../tools/text/catdoc { };

  cde = callPackage ../tools/package-management/cde { };

  cdemu-daemon = callPackage ../misc/emulators/cdemu/daemon.nix { };

  cdemu-client = callPackage ../misc/emulators/cdemu/client.nix { };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    google-gflags = null; # only required for examples/tests
  };

  gcdemu = callPackage ../misc/emulators/cdemu/gui.nix { };

  image-analyzer = callPackage ../misc/emulators/cdemu/analyzer.nix { };

  cddl = callPackage ../development/tools/cddl { };

  cedille = callPackage ../applications/science/logic/cedille
                          { inherit (haskellPackages) alex happy Agda ghcWithPackages;
                          };

  clasp = callPackage ../tools/misc/clasp { };

  clib = callPackage ../tools/package-management/clib { };

  clingo = callPackage ../applications/science/logic/potassco/clingo.nix { };

  colord-kde = libsForQt5.callPackage ../tools/misc/colord-kde {};

  consul = callPackage ../servers/consul { };

  cplex = callPackage ../applications/science/math/cplex { releasePath = config.cplex.releasePath or null; };

  contacts = callPackage ../tools/misc/contacts {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Foundation AddressBook;
  };

  crip = callPackage ../applications/audio/crip { };

  crunch = callPackage ../tools/security/crunch { };

  deis = callPackage ../development/tools/deis {};

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialog = callPackage ../development/tools/misc/dialog { };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  dosage = callPackage ../applications/graphics/dosage {
    pythonPackages = python3Packages;
  };

  dpic = callPackage ../tools/graphics/dpic { };

  dragon-drop = callPackage ../tools/X11/dragon-drop {
    gtk = gtk3;
  };

  dtools = callPackage ../development/tools/dtools { };

  dune = callPackage ../development/tools/ocaml/dune { };

  enca = callPackage ../tools/text/enca { };

  ent = callPackage ../tools/misc/ent { };

  esptool = callPackage ../tools/misc/esptool { };

  et = callPackage ../applications/misc/et {};

  f3 = callPackage ../tools/filesystems/f3 { };

  fac = callPackage ../development/tools/fac { };

  fastJson = callPackage ../development/libraries/fastjson { };

  fast-cli = nodePackages.fast-cli;

  fd = callPackage ../tools/misc/fd { };

  fop = callPackage ../tools/typesetting/fop { };

  futhark = haskell.lib.justStaticExecutables haskellPackages.futhark;

  fwup = callPackage ../tools/misc/fwup { };

  fzy = callPackage ../tools/misc/fzy { };

  gdrivefs = python27Packages.gdrivefs;

  gdrive = callPackage ../applications/networking/gdrive { };

  go-2fa = callPackage ../tools/security/2fa {};

  go-dependency-manager = callPackage ../development/tools/gdm { };

  gist = callPackage ../tools/text/gist { };

  glslviewer = callPackage ../development/tools/glslviewer {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  gmic = callPackage ../tools/graphics/gmic { };

  gmic_krita_qt = libsForQt5.callPackage ../tools/graphics/gmic_krita_qt { };

  goa = callPackage ../development/tools/goa {
    buildGoPackage = buildGo110Package;
  };

  greg = callPackage ../applications/audio/greg {
    pythonPackages = python3Packages;
  };

  gringo = callPackage ../tools/misc/gringo { scons = scons_2_5_1; };

  gti = callPackage ../tools/misc/gti { };

  hr = callPackage ../applications/misc/hr { };

  klaus = with pythonPackages; toPythonApplication klaus;

  lief = callPackage ../development/libraries/lief {};

  loccount = callPackage ../development/tools/misc/loccount { };

  mathics = pythonPackages.mathics;

  masscan = callPackage ../tools/security/masscan {
    stdenv = gccStdenv;
  };

  mkspiffs = callPackage ../tools/filesystems/mkspiffs { };

  mkspiffs-presets = recurseIntoAttrs (callPackages ../tools/filesystems/mkspiffs/presets.nix { });

  noti = callPackage ../tools/misc/noti {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  nyx = callPackage ../tools/networking/nyx { };

  scour = with python3Packages; toPythonApplication scour;

  syslogng = callPackage ../tools/system/syslog-ng { };

  syslogng_incubator = callPackage ../tools/system/syslog-ng-incubator { };

  inherit (callPackages ../servers/rainloop { })
    rainloop-community
    rainloop-standard;

  riot-web = callPackage ../applications/networking/instant-messengers/riot/riot-web.nix {
    conf = config.riot-web.conf or null;
  };

  rsyslog = callPackage ../tools/system/rsyslog {
    hadoop = null; # Currently Broken
    czmq = czmq3;
  };

  rsyslog-light = rsyslog.override {
    libkrb5 = null;
    systemd = null;
    jemalloc = null;
    mysql = null;
    postgresql = null;
    libdbi = null;
    net_snmp = null;
    libuuid = null;
    gnutls = null;
    libgcrypt = null;
    liblognorm = null;
    openssl = null;
    librelp = null;
    libgt = null;
    libksi = null;
    liblogging = null;
    libnet = null;
    hadoop = null;
    rdkafka = null;
    libmongo-client = null;
    czmq = null;
    rabbitmq-c = null;
    hiredis = null;
  };

  mar1d = callPackage ../games/mar1d { } ;

  mcrypt = callPackage ../tools/misc/mcrypt { };

  mozlz4a = callPackage ../tools/compression/mozlz4a {
    pylz4 = python3Packages.lz4;
  };

  mcelog = callPackage ../os-specific/linux/mcelog {
    utillinux = utillinuxMinimal;
  };

  appleseed = callPackage ../tools/graphics/appleseed {
    eigen = eigen3_3;
  };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (python2Packages) matplotlib numpy aafigure recursivePthLoader;
    w3m = w3m-batch;
    enableStandardFeatures = false;
  };

  asciidoc-full = appendToName "full" (asciidoc.override {
    inherit (python2Packages) pygments;
    enableStandardFeatures = true;
  });

  asciidoc-full-with-plugins = appendToName "full-with-plugins" (asciidoc.override {
    inherit (python2Packages) pygments;
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  });

  assh = callPackage ../tools/networking/assh { };

  b2sum = callPackage ../tools/security/b2sum {
    inherit (llvmPackages) openmp;
  };

  beegfs = callPackage ../os-specific/linux/beegfs { };

  beets = callPackage ../tools/audio/beets {
    pythonPackages = python3Packages;
  };

  bfg-repo-cleaner = gitAndTools.bfg-repo-cleaner;

  bfs = callPackage ../tools/system/bfs { };

  bgs = callPackage ../tools/X11/bgs { };

  biber = callPackage ../tools/typesetting/biber { };

  blastem = callPackage ../misc/emulators/blastem {
    inherit (python27Packages) pillow;
  };

  blueman = callPackage ../tools/bluetooth/blueman {
    withPulseAudio = config.pulseaudio or true;
  };

  bmrsa = callPackage ../tools/security/bmrsa/11.nix { };

  btar = callPackage ../tools/backup/btar {
    librsync = librsync_0_9;
  };

  bud = callPackage ../tools/networking/bud {
    inherit (pythonPackages) gyp;
  };

  bup = callPackage ../tools/backup/bup { };

  burp = callPackage ../tools/backup/burp { };

  buku = callPackage ../applications/misc/buku { };

  ori = callPackage ../tools/backup/ori { };

  atool = callPackage ../tools/archivers/atool { };

  bsc = callPackage ../tools/compression/bsc {
    inherit (llvmPackages) openmp;
  };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  cantata = libsForQt5.callPackage ../applications/audio/cantata {
    inherit vlc;
    ffmpeg = ffmpeg_2;
  };

  ccid = callPackage ../tools/security/ccid { };

  libceph = ceph.lib;
  ceph = callPackage ../tools/filesystems/ceph {
    boost = boost166.override { enablePython = true; };
  };
  ceph-dev = ceph;

  cfdg = callPackage ../tools/graphics/cfdg {
    ffmpeg = ffmpeg_2;
  };

  cipherscan = callPackage ../tools/security/cipherscan {
    openssl = if stdenv.hostPlatform.system == "x86_64-linux"
      then openssl-chacha
      else openssl;
  };

  clementine = callPackage ../applications/audio/clementine {
    gst_plugins =
      with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav ];
  };

  clementineUnfree = clementine.unfree;

  citrix_receiver_unwrapped = callPackage ../applications/networking/remote/citrix-receiver { };
  citrix_receiver_unwrapped_13_10_0 = citrix_receiver_unwrapped.override { version = "13.10.0"; };
  citrix_receiver_unwrapped_13_9_1  = citrix_receiver_unwrapped.override { version = "13.9.1";  };
  citrix_receiver_unwrapped_13_9_0  = citrix_receiver_unwrapped.override { version = "13.9.0";  };
  citrix_receiver_unwrapped_13_8_0  = citrix_receiver_unwrapped.override { version = "13.8.0";  };

  citrix_receiver = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped;
  };
  citrix_receiver_13_10_0 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_10_0;
  };
  citrix_receiver_13_9_1 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_9_1;
  };
  citrix_receiver_13_9_0 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_9_0;
  };
  citrix_receiver_13_8_0 = callPackage ../applications/networking/remote/citrix-receiver/wrapper.nix {
    citrix_receiver = citrix_receiver_unwrapped_13_8_0;
  };

  citra = libsForQt5.callPackage ../misc/emulators/citra { };

  cmst = libsForQt5.callPackage ../tools/networking/cmst { };

  colord = callPackage ../tools/misc/colord { };

  connect = callPackage ../tools/networking/connect { };

  connman = callPackage ../tools/networking/connman { };

  connman_dmenu = callPackage ../tools/networking/connman/connman_dmenu  { };

  collectd = callPackage ../tools/system/collectd {
    libsigrok = libsigrok-0-3-0; # not compatible with >= 0.4.0 yet
  };

  collectd-data = callPackage ../tools/system/collectd/data.nix { };

  cpuminer = callPackage ../tools/misc/cpuminer { };

  usb-modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };
  usb-modeswitch-data = callPackage ../development/tools/misc/usb-modeswitch/data.nix { };

  anthy = callPackage ../tools/inputmethods/anthy { };

  libpinyin = callPackage ../development/libraries/libpinyin { };

  libskk = callPackage ../development/libraries/libskk {
    inherit (gnome3) gnome-common libgee;
  };

  m17n_db = callPackage ../tools/inputmethods/m17n-db { };

  m17n_lib = callPackage ../tools/inputmethods/m17n-lib { };

  libotf = callPackage ../tools/inputmethods/m17n-lib/otf.nix {
    inherit (xorg) libXaw;
  };

  libkkc-data = callPackage ../data/misc/libkkc-data {
    inherit (pythonPackages) marisa;
  };

  libkkc = callPackage ../tools/inputmethods/libkkc {
    inherit (gnome3) libgee;
  };

  ibus = callPackage ../tools/inputmethods/ibus {
    gconf = gnome2.GConf;
    inherit (gnome3) dconf glib;
  };

  ibus-qt = callPackage ../tools/inputmethods/ibus/ibus-qt.nix { };

  ibus-engines = recurseIntoAttrs {
    anthy = callPackage ../tools/inputmethods/ibus-engines/ibus-anthy { };

    hangul = callPackage ../tools/inputmethods/ibus-engines/ibus-hangul { };

    kkc = callPackage ../tools/inputmethods/ibus-engines/ibus-kkc { };

    libpinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-libpinyin { };

    m17n = callPackage ../tools/inputmethods/ibus-engines/ibus-m17n { };

    mozc = callPackage ../tools/inputmethods/ibus-engines/ibus-mozc rec {
      python = python2;
      inherit (python2Packages) gyp;
      protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
    };

    table = callPackage ../tools/inputmethods/ibus-engines/ibus-table {
      inherit (gnome3) dconf;
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

  ibus-with-plugins = callPackage ../tools/inputmethods/ibus/wrapper.nix {
    inherit (gnome3) dconf;
    plugins = [ ];
  };

  interception-tools = callPackage ../tools/inputmethods/interception-tools { };
  interception-tools-plugins = {
    caps2esc = callPackage ../tools/inputmethods/interception-tools/caps2esc.nix { };
  };

  brotli = callPackage ../tools/compression/brotli { };

  c14 = callPackage ../applications/networking/c14 { };

  ckb-next = libsForQt5.callPackage ../tools/misc/ckb-next { };

  clex = callPackage ../tools/misc/clex { };

  cloc = callPackage ../tools/misc/cloc {
    inherit (perlPackages) perl AlgorithmDiff ParallelForkManager RegexpCommon;
  };

  cloog = callPackage ../development/libraries/cloog {
    isl = isl_0_14;
  };

  cloog_0_18_0 = callPackage ../development/libraries/cloog/0.18.0.nix {
    isl = isl_0_11;
  };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  compass = callPackage ../development/tools/compass { };

  cool-retro-term = libsForQt5.callPackage ../applications/misc/cool-retro-term { };

  coreutils = callPackage ../tools/misc/coreutils { };
  coreutils-full = coreutils.override { minimal = false; };
  coreutils-prefixed = coreutils.override { withPrefix = true; singleBinary = false; };

  cpio = callPackage ../tools/archivers/cpio { };

  create-cycle-app = nodePackages.create-cycle-app;

  cron = callPackage ../tools/system/cron { };

  inherit (callPackages ../development/compilers/cudatoolkit { })
    cudatoolkit_6
    cudatoolkit_6_5
    cudatoolkit_7
    cudatoolkit_7_5
    cudatoolkit_8
    cudatoolkit_9
    cudatoolkit_9_0
    cudatoolkit_9_1
    cudatoolkit_9_2
    cudatoolkit_10
    cudatoolkit_10_0;

  cudatoolkit = cudatoolkit_9;

  inherit (callPackages ../development/libraries/science/math/cudnn { })
    cudnn_cudatoolkit_7
    cudnn_cudatoolkit_7_5
    cudnn6_cudatoolkit_8
    cudnn_cudatoolkit_8
    cudnn_cudatoolkit_9
    cudnn_cudatoolkit_9_0
    cudnn_cudatoolkit_9_1
    cudnn_cudatoolkit_9_2
    cudnn_cudatoolkit_10
    cudnn_cudatoolkit_10_0;

  cudnn = cudnn_cudatoolkit_9;

  curlFull = curl.override {
    idnSupport = true;
    ldapSupport = true;
    gssSupport = true;
    brotliSupport = true;
  };

  curl_7_59 = callPackage ../tools/networking/curl/7_59.nix rec {
    fetchurl = fetchurlBoot;
    http2Support = true;
    zlibSupport = true;
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
    gssSupport = !stdenv.hostPlatform.isWindows;
  };

  curl = callPackage ../tools/networking/curl rec {
    fetchurl = fetchurlBoot;
    http2Support = true;
    zlibSupport = true;
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
    gssSupport = !stdenv.hostPlatform.isWindows;
  };

  curl_unix_socket = callPackage ../tools/networking/curl-unix-socket rec { };

  cunit = callPackage ../tools/misc/cunit { };
  cutter = callPackage ../tools/networking/cutter { };

  cvs_fast_export = callPackage ../applications/version-management/cvs-fast-export { };

  daemonize = callPackage ../tools/system/daemonize { };

  dar = callPackage ../tools/backup/dar { };

  dcraw = callPackage ../tools/graphics/dcraw { };

  debian-devscripts = callPackage ../tools/misc/debian-devscripts {
    inherit (perlPackages) CryptSSLeay LWP TimeDate DBFile FileDesktopEntry;
  };

  deer = callPackage ../shells/zsh/zsh-deer { };

  devilspie2 = callPackage ../applications/misc/devilspie2 {
    gtk = gtk3;
  };

  dex = callPackage ../tools/X11/dex { };

  ddccontrol = callPackage ../tools/misc/ddccontrol { };

  ddrescue = callPackage ../tools/system/ddrescue { };

  deluge = callPackage ../applications/networking/p2p/deluge {
    pythonPackages = python2Packages;
  };

  desktop-file-utils = callPackage ../tools/misc/desktop-file-utils { };

  dfc  = callPackage ../tools/system/dfc { };

  diskrsync = callPackage ../tools/backup/diskrsync {
    buildGoPackage = buildGo110Package;
  };

  djbdns = callPackage ../tools/networking/djbdns { };

  dnscrypt-proxy = callPackage ../tools/networking/dnscrypt-proxy/1.x { };

  dnscrypt-proxy2 = callPackage ../tools/networking/dnscrypt-proxy/2.x {
    buildGoPackage = buildGo110Package;
  };

  dnsmasq = callPackage ../tools/networking/dnsmasq { };

  dhcp = callPackage ../tools/networking/dhcp { };

  di = callPackage ../tools/system/di { };

  diction = callPackage ../tools/text/diction { };

  diffoscope = callPackage ../tools/misc/diffoscope {
    jdk = jdk8;
  };

  dir2opus = callPackage ../tools/audio/dir2opus {
    inherit (pythonPackages) mutagen python wrapPython;
  };

  docbook2odf = callPackage ../tools/typesetting/docbook2odf {
    inherit (perlPackages) PerlMagick;
  };

  docbook2x = callPackage ../tools/typesetting/docbook2x {
    inherit (perlPackages) XMLSAX XMLSAXBase XMLParser XMLNamespaceSupport;
  };

  dog = callPackage ../tools/system/dog { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dolphinEmu = callPackage ../misc/emulators/dolphin-emu { };
  dolphinEmuMaster = callPackage ../misc/emulators/dolphin-emu/master.nix {
    inherit (darwin.apple_sdk.frameworks) CoreBluetooth ForceFeedback IOKit OpenGL;
    inherit (darwin) cf-private;
  };

  doomseeker = qt5.callPackage ../applications/misc/doomseeker { };

  doom-bcc = callPackage ../games/zdoom/bcc-git.nix { };

  slade = callPackage ../applications/misc/slade {
    wxGTK = wxGTK30;
  };

  sladeUnstable = callPackage ../applications/misc/slade/git.nix {
    wxGTK = wxGTK30;
  };

  drive = callPackage ../applications/networking/drive { };

  drone = callPackage ../development/tools/continuous-integration/drone { };

  duc = callPackage ../tools/misc/duc { };

  duplicity = callPackage ../tools/backup/duplicity {
    gnupg = gnupg1;
  };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvtm = callPackage ../tools/misc/dvtm {
    # if you prefer a custom config, write the config.h in dvtm.config.h
    # and enable
    # customConfig = builtins.readFile ./dvtm.config.h;
  };

  ecmtools = callPackage ../tools/cd-dvd/ecm-tools { };

  easyrsa = callPackage ../tools/networking/easyrsa { };

  easyrsa2 = callPackage ../tools/networking/easyrsa/2.x.nix { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  ecryptfs-helper = callPackage ../tools/security/ecryptfs/helper.nix { };

  edit = callPackage ../applications/editors/edit { };

  eff = callPackage ../development/interpreters/eff { };

  uutils-coreutils = callPackage ../tools/misc/uutils-coreutils {
    inherit (pythonPackages) sphinx;
  };

  ### DEVELOPMENT / EMSCRIPTEN

  buildEmscriptenPackage = callPackage ../development/em-modules/generic { };

  emscriptenVersion = "1.37.36";

  emscripten = callPackage ../development/compilers/emscripten { };

  emscriptenfastcompPackages = callPackage ../development/compilers/emscripten/fastcomp { };

  emscriptenfastcomp = emscriptenfastcompPackages.emscriptenfastcomp;

  emscriptenPackages = recurseIntoAttrs (callPackage ./emscripten-packages.nix { });

  emscriptenStdenv = stdenv // { mkDerivation = buildEmscriptenPackage; };

  # The latest version used by elasticsearch, logstash, kibana and the the beats from elastic.
  elk5Version = "5.6.9";
  elk6Version = "6.3.2";

  elasticsearch5 = callPackage ../servers/search/elasticsearch/5.x.nix { };
  elasticsearch6 = callPackage ../servers/search/elasticsearch { };
  elasticsearch6-oss = callPackage ../servers/search/elasticsearch {
    enableUnfree = false;
  };
  elasticsearch = elasticsearch6;
  elasticsearch-oss = elasticsearch6-oss;

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ../servers/search/elasticsearch/plugins.nix { }
  );

  embree2 = callPackage ../development/libraries/embree/2.x.nix { };

  emem = callPackage ../applications/misc/emem { };

  emv = callPackage ../tools/misc/emv { };

  cryfs = callPackage ../tools/filesystems/cryfs {
    spdlog = spdlog_0;
  };

  encfs = callPackage ../tools/filesystems/encfs {
    tinyxml2 = tinyxml-2;
  };

  entr = callPackage ../tools/misc/entr { };

  envoy = callPackage ../tools/networking/envoy {
    bazel = bazel_0_4;
  };

  eot_utilities = callPackage ../tools/misc/eot-utilities { };

  escrotum = callPackage ../tools/graphics/escrotum {
    inherit (pythonPackages) buildPythonApplication pygtk numpy;
  };

  ettercap = callPackage ../applications/networking/sniffers/ettercap { };

  exa = callPackage ../tools/misc/exa { };

  exempi = callPackage ../development/libraries/exempi {
    stdenv = if stdenv.isi686 then overrideCC stdenv gcc6 else stdenv;
  };

  execline = skawarePackages.execline;

  exif = callPackage ../tools/graphics/exif { };

  exiftool = perlPackages.ImageExifTool;

  extract_url = callPackage ../applications/misc/extract_url {
    inherit (perlPackages) MIMEtools HTMLParser CursesUI URIFind;
  };

  Fabric = python2Packages.Fabric;

  fast-neural-doodle = callPackage ../tools/graphics/fast-neural-doodle {
    inherit (python27Packages) numpy scipy h5py scikitlearn python
      pillow;
  };

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

    mozc = callPackage ../tools/inputmethods/fcitx-engines/fcitx-mozc rec {
      python = python2;
      inherit (python2Packages) gyp;
      protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
    };

    table-extra = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-extra { };

    table-other = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-other { };

    cloudpinyin = callPackage ../tools/inputmethods/fcitx-engines/fcitx-cloudpinyin { };

    libpinyin = libsForQt5.callPackage ../tools/inputmethods/fcitx-engines/fcitx-libpinyin { };

    skk = callPackage ../tools/inputmethods/fcitx-engines/fcitx-skk { };
  };

  fcitx-configtool = callPackage ../tools/inputmethods/fcitx/fcitx-configtool.nix { };

  feedreader = callPackage ../applications/networking/feedreaders/feedreader {};

  fgallery = callPackage ../tools/graphics/fgallery {
    inherit (perlPackages) ImageExifTool CpanelJSONXS;
  };

  flatpak = callPackage ../development/libraries/flatpak { };

  file = callPackage ../tools/misc/file {
    inherit (windows) libgnurx;
  };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  iprange = callPackage ../applications/networking/firehol/iprange.nix {};

  firehol = callPackage ../applications/networking/firehol {};

  fio = callPackage ../tools/system/fio { };

  firebird-emu = libsForQt5.callPackage ../misc/emulators/firebird-emu { };

  flashtool = pkgsi686Linux.callPackage ../development/mobile/flashtool {
    platformTools = androidenv.platformTools;
  };

  flent = python3Packages.callPackage ../applications/networking/flent { };

  hmetis = pkgsi686Linux.callPackage ../applications/science/math/hmetis { };

  fdk_aac = callPackage ../development/libraries/fdk-aac { };

  fbv = callPackage ../tools/graphics/fbv { };

  fmbt = callPackage ../development/tools/fmbt {
    python = python2;
  };

  fontforge = lowPrio (callPackage ../tools/misc/fontforge {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  });
  fontforge-gtk = fontforge.override {
    withSpiro = true;
    withGTK = true;
    gtk2 = gtk2-x11;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  fontforge-fonttools = callPackage ../tools/misc/fontforge/fontforge-fonttools.nix {};

  fox = callPackage ../development/libraries/fox {
    libpng = libpng12;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fping = callPackage ../tools/networking/fping {};

  fpm = callPackage ../tools/package-management/fpm { };

  freetalk = callPackage ../applications/networking/instant-messengers/freetalk {
    guile = guile_2_0;
  };

  frostwire = callPackage ../applications/networking/p2p/frostwire { };
  frostwire-bin = callPackage ../applications/networking/p2p/frostwire/frostwire-bin.nix { };

  ftop = callPackage ../os-specific/linux/ftop { };

  fstl = qt5.callPackage ../applications/graphics/fstl { };

  fdbPackages = callPackage ../servers/foundationdb {
    stdenv49 = overrideCC stdenv gcc49;
  };

  inherit (fdbPackages)
    foundationdb51
    foundationdb52
    foundationdb60;

  foundationdb = foundationdb60;

  exfat = callPackage ../tools/filesystems/exfat { };

  galculator = callPackage ../applications/misc/galculator {
    gtk = gtk3;
  };

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

  gawkInteractive = appendToName "interactive"
    (gawk.override { interactive = true; });

  gazeboSimulator = recurseIntoAttrs rec {
    sdformat = gazeboSimulator.sdformat4;

    sdformat3 = callPackage ../development/libraries/sdformat/3.nix { };

    sdformat4 = callPackage ../development/libraries/sdformat { };

    gazebo6 = callPackage ../applications/science/robotics/gazebo/6.nix { boost = boost160; };

    gazebo6-headless = gazebo6.override { withHeadless = true;  };

    gazebo7 = callPackage ../applications/science/robotics/gazebo { };

    gazebo7-headless = gazebo7.override { withHeadless = true; };

  };

  # at present, Gazebo 7.0.0 does not match Gazebo 6.5.1 for compatibility
  gazebo = gazeboSimulator.gazebo6;

  gazebo-headless = gazeboSimulator.gazebo6-headless;

  gbdfed = callPackage ../tools/misc/gbdfed {
    gtk = gtk2-x11;
  };

  getopt = callPackage ../tools/misc/getopt { };

  git-lfs = lowPrio (callPackage ../applications/version-management/git-lfs { });

  git-lfs1 = callPackage ../applications/version-management/git-lfs/1.nix { };

  gitlab = callPackage ../applications/version-management/gitlab { };
  gitlab-ee = callPackage ../applications/version-management/gitlab { gitlabEnterprise = true; };

  glogg = libsForQt5.callPackage ../tools/text/glogg { };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gmrender-resurrect = callPackage ../tools/networking/gmrender-resurrect {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav;
  };

  gnaural = callPackage ../applications/audio/gnaural {
    stdenv = overrideCC stdenv gcc49;
  };

  gnome15 = callPackage ../applications/misc/gnome15 {
    inherit (gnome2) gnome_python gnome_python_desktop;
  };

  gnuapl = callPackage ../development/interpreters/gnu-apl { };

  gnufdisk = callPackage ../tools/system/fdisk {
    guile = guile_1_8;
  };

  gnulib = callPackage ../development/tools/gnulib { };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1orig = callPackage ../tools/security/gnupg/1.nix { };
  gnupg1compat = callPackage ../tools/security/gnupg/1compat.nix { };
  gnupg1 = gnupg1compat;    # use config.packageOverrides if you prefer original gnupg1
  gnupg20 = callPackage ../tools/security/gnupg/20.nix {
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry;
  };
  gnupg22 = callPackage ../tools/security/gnupg/22.nix {
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry;
  };
  gnupg = gnupg22;

  gnuplot = libsForQt5.callPackage ../tools/graphics/gnuplot { };

  gnuplot_qt = gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };

  gnused = if !stdenv.hostPlatform.isWindows then
             callPackage ../tools/text/gnused { } # broken on Windows
           else
             gnused_422;
  # This is an easy work-around for [:space:] problems.
  gnused_422 = callPackage ../tools/text/gnused/422.nix { };

  # rename to upower-notify?
  go-upower-notify = callPackage ../tools/misc/upower-notify { };

  google-cloud-sdk = python2.pkgs.google-cloud-sdk;
  google-cloud-sdk-gce = python2.pkgs.google-cloud-sdk-gce;

  google-compute-engine = python2.pkgs.google-compute-engine;

  gpart = callPackage ../tools/filesystems/gpart { };

  gpp = callPackage ../development/tools/gpp { };

  grails = callPackage ../development/web/grails { jdk = null; };

  graylog = callPackage ../tools/misc/graylog { };
  graylogPlugins = recurseIntoAttrs (
    callPackage ../tools/misc/graylog/plugins.nix { }
  );

  graphviz = callPackage ../tools/graphics/graphviz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  graphviz-nox = graphviz.override {
    xorg = null;
    libdevil = libdevil-nox;
  };

  /* Readded by Michael Raskin. There are programs in the wild
   * that do want 2.32 but not 2.0 or 2.36. Please give a day's notice for
   * objections before removal. The feature is libgraph.
   */
  graphviz_2_32 = lib.overrideDerivation (callPackage ../tools/graphics/graphviz/2.32.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  }) (x: { configureFlags = x.configureFlags ++ ["--with-cgraph=no"];});

  grin = callPackage ../tools/text/grin { };

  ripgrep = callPackage ../tools/text/ripgrep {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  groff = callPackage ../tools/text/groff {
    ghostscript = null;
    psutils = null;
    netpbm = null;
  };

  gromit-mpx = callPackage ../tools/graphics/gromit-mpx {
    gtk = gtk3;
    libappindicator = libappindicator-gtk3;
    inherit (xorg) libXdmcp;
  };

  groonga = callPackage ../servers/search/groonga { };

  grub = pkgsi686Linux.callPackage ../tools/misc/grub {
    buggyBiosCDSupport = config.grub.buggyBiosCDSupport or true;
    stdenv = overrideCC stdenv pkgsi686Linux.gcc6;
  };

  trustedGrub = pkgsi686Linux.callPackage ../tools/misc/grub/trusted.nix { };

  trustedGrub-for-HP = pkgsi686Linux.callPackage ../tools/misc/grub/trusted.nix { for_HP_laptop = true; };

  grub2 = grub2_full;

  grub2_full = callPackage ../tools/misc/grub/2.0x.nix { };

  grub2_efi = grub2.override {
    efiSupport = true;
  };

  grub2_light = grub2.override {
    zfsSupport = false;
  };

  grub2_xen = grub2_full.override {
    xenSupport = true;
  };

  grub2_pvgrub_image = callPackage ../tools/misc/grub/pvgrub_image { };

  grub4dos = callPackage ../tools/misc/grub4dos {
    stdenv = stdenv_32bit;
  };

  gx = callPackage ../tools/package-management/gx {
    buildGoPackage = buildGo110Package;
  };
  gx-go = callPackage ../tools/package-management/gx/go {
    buildGoPackage = buildGo110Package;
  };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome2) libsoup;
  };

  gtest = callPackage ../development/libraries/gtest {};
  gmock = gtest; # TODO: move to aliases.nix

  gtkd = callPackage ../development/libraries/gtkd { };

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gup = callPackage ../development/tools/build-managers/gup {};

  gupnp = callPackage ../development/libraries/gupnp {
    inherit (gnome2) libsoup;
  };

  gzip = callPackage ../tools/compression/gzip { };

  pgf_graphics = callPackage ../tools/graphics/pgf { };

  pg_topn = callPackage ../servers/sql/postgresql/topn {};

  h2 = callPackage ../servers/h2 { };

  h5utils = callPackage ../tools/misc/h5utils {
    libmatheval = null;
    hdf4 = null;
  };

  haproxy = callPackage ../tools/networking/haproxy { };

  halide = callPackage ../development/compilers/halide {
    eigen = eigen3_3;
  };

  hdf4 = callPackage ../tools/misc/hdf4 {
    szip = null;
  };

  hdf5 = callPackage ../tools/misc/hdf5 {
    gfortran = null;
    szip = null;
    mpi = null;
  };

  hdf5_1_8 = callPackage ../tools/misc/hdf5/1_8.nix {
    gfortran = null;
    szip = null;
    mpi = null;
  };

  hdf5-mpi = appendToName "mpi" (hdf5.override {
    szip = null;
    mpi = pkgs.openmpi;
  });

  hdf5-cpp = appendToName "cpp" (hdf5.override {
    cpp = true;
  });

  hdf5-fortran = appendToName "fortran" (hdf5.override {
    inherit gfortran;
  });

  hdf5-threadsafe = appendToName "threadsafe" (hdf5.overrideAttrs (oldAttrs: {
      # Threadsafe hdf5
      # However, hdf5 hl (High Level) library is not considered stable
      # with thread safety and should be disabled.
      configureFlags = oldAttrs.configureFlags ++ ["--enable-threadsafe" "--disable-hl" ];
  }));

  hdfview = callPackage ../tools/misc/hdfview {
    javac = jdk;
  };

  hdf_java = callPackage ../tools/misc/hdfjava {
    javac = jdk;
  };

  heaptrack = libsForQt5.callPackage ../development/tools/profiling/heaptrack {};

  heimdall = libsForQt5.callPackage ../tools/misc/heimdall { };

  heimdall-gui = heimdall.override { enableGUI = true; };

  hexd = callPackage ../tools/misc/hexd { };
  highlight = callPackage ../tools/text/highlight ({
    lua = lua5;
  } // lib.optionalAttrs stdenv.isDarwin {
    # doesn't build with clang_37
    inherit (llvmPackages_38) stdenv;
  });

  host = bind.host;

  hotspot = libsForQt5.callPackage ../development/tools/analysis/hotspot { };

  http-getter = callPackage ../applications/networking/flent/http-getter.nix { };

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  i2p = callPackage ../tools/networking/i2p {};

  i2pd = callPackage ../tools/networking/i2pd {
    boost = boost165;
  };

  i-score = libsForQt5.callPackage ../applications/audio/i-score { };

  iannix = libsForQt5.callPackage ../applications/audio/iannix { };

  deco = callPackage ../applications/misc/deco { };

  inherit (callPackages ../tools/filesystems/irods rec {
            stdenv = llvmPackages_38.libcxxStdenv;
            libcxx = llvmPackages_38.libcxx;
            boost = boost160.override { inherit stdenv; };
            avro-cpp_llvm = avro-cpp.override { inherit stdenv boost; };
          })
      irods
      irods-icommands;

  ignition = recurseIntoAttrs {

    math = callPackage ../development/libraries/ignition-math { };

    math2 = ignition.math;

    transport0 = callPackage ../development/libraries/ignition-transport/0.9.0.nix { };

    transport1 = callPackage ../development/libraries/ignition-transport/1.0.1.nix { };

    transport = ignition.transport0;
  };


  ihaskell = callPackage ../development/tools/haskell/ihaskell/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;

    jupyter = python3.withPackages (ps: [ ps.jupyter ps.notebook ]);

    packages = config.ihaskell.packages or (self: []);
  };

  innoextract = callPackage ../tools/archivers/innoextract { };

  intecture-agent = callPackage ../tools/admin/intecture/agent.nix { };

  intecture-auth = callPackage ../tools/admin/intecture/auth.nix { };

  intecture-cli = callPackage ../tools/admin/intecture/cli.nix { };

  invoice2data  = callPackage ../tools/text/invoice2data  { };

  iodine = callPackage ../tools/networking/iodine { };

  ior = callPackage ../tools/system/ior { };

  ip2location = callPackage ../tools/networking/ip2location { };

  iperf2 = callPackage ../tools/networking/iperf/2.nix { };
  iperf3 = callPackage ../tools/networking/iperf/3.nix { };
  iperf = iperf3;

  ipfs = callPackage ../applications/networking/ipfs { };
  ipget = callPackage ../applications/networking/ipget {
    buildGoPackage = buildGo110Package;
  };

  ipmitool = callPackage ../tools/system/ipmitool {
    static = false;
  };

  ipcalc = callPackage ../tools/networking/ipcalc {};

  isl = isl_0_17;
  isl_0_11 = callPackage ../development/libraries/isl/0.11.1.nix { };
  isl_0_12 = callPackage ../development/libraries/isl/0.12.2.nix { };
  isl_0_14 = callPackage ../development/libraries/isl/0.14.1.nix { };
  isl_0_15 = callPackage ../development/libraries/isl/0.15.0.nix { };
  isl_0_17 = callPackage ../development/libraries/isl/0.17.1.nix { };

  isync = callPackage ../tools/networking/isync { };
  isyncUnstable = callPackage ../tools/networking/isync/unstable.nix { };

  jackett = callPackage ../servers/jackett {
    mono = mono514;
  };

  jade = callPackage ../tools/text/sgml/jade { };

  jd = callPackage ../development/tools/jd { };

  jing = self.jing-trang;
  jing-trang = callPackage ../tools/text/xml/jing-trang { };

  jira-cli = callPackage ../development/tools/jira_cli { };

  jl = haskellPackages.callPackage ../development/tools/jl { };

  jp = callPackage ../development/tools/jp { };

  jo = callPackage ../development/tools/jo { };

  jupyter = callPackage ../applications/editors/jupyter { };

  jupyter-kernel = callPackage ../applications/editors/jupyter/kernel.nix { };

  kdbplus = pkgsi686Linux.callPackage ../applications/misc/kdbplus { };

  kde2-decoration = libsForQt5.callPackage ../misc/themes/kde2 { };

  keybase = callPackage ../tools/security/keybase {
    inherit (darwin) cf-private;
    # Reasoning for the inherited apple_sdk.frameworks:
    # 1. specific compiler errors about: AVFoundation, AudioToolbox, MediaToolbox
    # 2. the rest are added from here: https://github.com/keybase/client/blob/68bb8c893c5214040d86ea36f2f86fbb7fac8d39/go/chat/attachments/preview_darwin.go#L7
    #      #cgo LDFLAGS: -framework AVFoundation -framework CoreFoundation -framework ImageIO -framework CoreMedia  -framework Foundation -framework CoreGraphics -lobjc
    #    with the exception of CoreFoundation, due to the warning in https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-sdk/frameworks.nix#L25
    inherit (darwin.apple_sdk.frameworks) AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox;
  };

  keybase-gui = callPackage ../tools/security/keybase/gui.nix { };

  keychain = callPackage ../tools/misc/keychain { };

  kibana5 = callPackage ../development/tools/misc/kibana/5.x.nix { };
  kibana6 = callPackage ../development/tools/misc/kibana/default.nix { };
  kibana6-oss = callPackage ../development/tools/misc/kibana/default.nix {
    enableUnfree = false;
  };
  kibana = kibana6;
  kibana-oss = kibana6-oss;

  klick = callPackage ../applications/audio/klick { };

  kore = callPackage ../development/web/kore { };

  partition-manager = libsForQt5.callPackage ../tools/misc/partition-manager { };

  krename = libsForQt5.callPackage ../applications/misc/krename { };

  krunner-pass = libsForQt5.callPackage ../tools/security/krunner-pass { };

  kronometer = libsForQt5.callPackage ../tools/misc/kronometer { };

  elisa = libsForQt5.callPackage ../applications/audio/elisa { };

  kdiff3 = libsForQt5.callPackage ../tools/text/kdiff3 { };

  kwalletcli = libsForQt5.callPackage ../tools/security/kwalletcli { };

  peruse = libsForQt5.callPackage ../tools/misc/peruse { };

  kst = libsForQt5.callPackage ../tools/graphics/kst { gsl = gsl_1; };

  ldc = callPackage ../development/compilers/ldc { };

  less = callPackage ../tools/misc/less { };

  lf = callPackage ../tools/misc/lf {};

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix {
    ffmpeg = ffmpeg-full;
  };

  loc = callPackage ../development/misc/loc { };

  lockfileProgs = callPackage ../tools/misc/lockfile-progs { };

  logstash5 = callPackage ../tools/misc/logstash/5.x.nix { };
  logstash6 = callPackage ../tools/misc/logstash { };
  logstash6-oss = callPackage ../tools/misc/logstash {
    enableUnfree = false;
  };
  logstash = logstash6;

  logstash-contrib = callPackage ../tools/misc/logstash/contrib.nix { };

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    lua = lua5_2_compat;
  };

  kdbg = libsForQt5.callPackage ../development/tools/misc/kdbg { };

  kzipmix = pkgsi686Linux.callPackage ../tools/compression/kzipmix { };

  mdbook = callPackage ../tools/text/mdbook {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  medfile = callPackage ../development/libraries/medfile {
    hdf5 = hdf5_1_8;
  };

  minergate = callPackage ../applications/misc/minergate { };

  mmv = callPackage ../tools/misc/mmv { };

  most = callPackage ../tools/misc/most { };

  motion = callPackage ../applications/video/motion { };

  nagstamon = callPackage ../tools/misc/nagstamon {
    pythonPackages = python3Packages;
  };

  netdata = callPackage ../tools/system/netdata {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;
  };

  netsurf = recurseIntoAttrs (let callPackage = newScope pkgs.netsurf; in rec {
    # ui could be gtk, sixel or framebuffer. Note that console display (sixel)
    # requires a terminal that supports `sixel` capabilities such as mlterm
    # or xterm -ti 340
    ui = "sixel";

    uilib = if ui == "gtk" then "gtk" else "framebuffer";

    SDL = if ui == "gtk" then null else if ui == "sixel" then SDL_sixel else SDL;

    buildsystem = callPackage ../applications/misc/netsurf/buildsystem { };

    libwapcaplet = callPackage ../applications/misc/netsurf/libwapcaplet { };

    nsgenbind = callPackage ../applications/misc/netsurf/nsgenbind { };

    libparserutils = callPackage ../applications/misc/netsurf/libparserutils { };

    libcss = callPackage ../applications/misc/netsurf/libcss { };

    libhubbub = callPackage ../applications/misc/netsurf/libhubbub { };

    libdom = callPackage ../applications/misc/netsurf/libdom { };

    libnsbmp = callPackage ../applications/misc/netsurf/libnsbmp { };

    libnsgif = callPackage ../applications/misc/netsurf/libnsgif { };

    libnsfb = callPackage ../applications/misc/netsurf/libnsfb { };

    libnsutils = callPackage ../applications/misc/netsurf/libnsutils { };

    libutf8proc = callPackage ../applications/misc/netsurf/libutf8proc { };

    browser = callPackage ../applications/misc/netsurf/browser { };

  });

  nixnote2 = libsForQt5.callPackage ../applications/misc/nixnote2 { };

  nodejs = hiPrio nodejs-8_x;

  nodejs-slim = nodejs-slim-6_x;

  nodejs-6_x = callPackage ../development/web/nodejs/v6.nix {};
  nodejs-slim-6_x = callPackage ../development/web/nodejs/v6.nix { enableNpm = false; };

  nodejs-8_x = callPackage ../development/web/nodejs/v8.nix {};
  nodejs-slim-8_x = callPackage ../development/web/nodejs/v8.nix { enableNpm = false; };

  nodejs-10_x = callPackage ../development/web/nodejs/v10.nix {
    openssl = openssl_1_1;
  };
  nodejs-slim-10_x = callPackage ../development/web/nodejs/v10.nix {
    enableNpm = false;
    openssl = openssl_1_1;
  };

  nodePackages_10_x = callPackage ../development/node-packages/default-v10.nix {
    nodejs = pkgs.nodejs-10_x;
  };

  nodePackages_8_x = callPackage ../development/node-packages/default-v8.nix {
    nodejs = pkgs.nodejs-8_x;
  };

  nodePackages_6_x = callPackage ../development/node-packages/default-v6.nix {
    nodejs = pkgs.nodejs-6_x;
  };

  nodePackages = nodePackages_10_x;

  npm2nix = nodePackages.npm2nix;

  file-rename = callPackage ../tools/filesystems/file-rename { };

  kea = callPackage ../tools/networking/kea {
    boost = boost165;
  };

  ldns = callPackage ../development/libraries/ldns {
    openssl = openssl_1_1;
  };

  lftp = callPackage ../tools/networking/lftp { };

  liblangtag = callPackage ../development/libraries/liblangtag {
    inherit (gnome2) gtkdoc;
    inherit (gnome3) gnome-common;
  };

  libtirpc = callPackage ../development/libraries/ti-rpc { };

  libmongo-client = callPackage ../development/libraries/libmongo-client { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  libiberty = callPackage ../development/libraries/libiberty { };

  libiberty_static = libiberty.override { staticBuild = true; };

  libxc = callPackage ../development/libraries/libxc { };

  libxl = callPackage ../development/libraries/libxl {};

  limesuite = callPackage ../applications/misc/limesuite { };

  linuxquota = callPackage ../tools/misc/linuxquota { };

  logcheck = callPackage ../tools/system/logcheck {
    inherit (perlPackages) mimeConstruct;
  };

  lr = callPackage ../tools/system/lr { };

  # lsh installs `bin/nettle-lfib-stream' and so does Nettle.  Give the
  # former a lower priority than Nettle.
  lsh = lowPrio (callPackage ../tools/networking/lsh { });

  lxc = callPackage ../os-specific/linux/lxc { };
  lxcfs = callPackage ../os-specific/linux/lxcfs {
    enableDebugBuild = config.lxcfs.enableDebugBuild or false;
  };
  lxd = callPackage ../tools/admin/lxd { };

  xz = callPackage ../tools/compression/xz { };
  lzma = xz; # TODO: move to aliases.nix

  lz4 = callPackage ../tools/compression/lz4 { };

  madlang = haskell.lib.justStaticExecutables haskellPackages.madlang;

  mailnag = callPackage ../applications/networking/mailreaders/mailnag {
    pythonPackages = python2Packages;
  };

  mailutils = callPackage ../tools/networking/mailutils {
    guile = guile_2_0;  # compilation fails with guile 2.2
    sasl = gsasl;
  };

  email = callPackage ../tools/networking/email { };

  # See https://github.com/NixOS/nixpkgs/issues/15849. I'm switching on isLinux because
  # it looks like gnulib is broken on non-linux, so it seems likely that this would cause
  # trouble on bsd and/or cygwin as well.
  man = if stdenv.isLinux then man-db else man-old;

  man-old = callPackage ../tools/misc/man { };

  man-db = callPackage ../tools/misc/man-db { };

  mbox = callPackage ../tools/security/mbox { };

  mecab =
    let
      mecab-nodic = callPackage ../tools/text/mecab/nodic.nix { };
    in
    callPackage ../tools/text/mecab {
      mecab-ipadic = callPackage ../tools/text/mecab/ipadic.nix {
        inherit mecab-nodic;
      };
    };

  memtest86 = callPackage ../tools/misc/memtest86 { };

  memtest86plus = callPackage ../tools/misc/memtest86+ { };

  meo = callPackage ../tools/security/meo {
    boost = boost155;
  };

  mc = callPackage ../tools/misc/mc { };

  mcron = callPackage ../tools/system/mcron {
    guile = guile_1_8;
  };

  mdbtools = callPackage ../tools/misc/mdbtools { };

  mdbtools_git = callPackage ../tools/misc/mdbtools/git.nix {
    inherit (gnome2) scrollkeeper;
  };

  mdp = callPackage ../applications/misc/mdp { };

  mednafen = callPackage ../misc/emulators/mednafen { };

  mednafen-server = callPackage ../misc/emulators/mednafen/server.nix { };

  mednaffe = callPackage ../misc/emulators/mednaffe {
    gtk2 = null;
  };

  mencal = callPackage ../applications/misc/mencal { } ;

  mfoc = callPackage ../tools/security/mfoc { };

  mgba = libsForQt5.callPackage ../misc/emulators/mgba { };

  minio-client = callPackage ../tools/networking/minio-client {
    buildGoPackage = buildGo110Package;
  };

  inherit (callPackage ../tools/networking/miniupnpc
            { inherit (darwin) cctools; })
    miniupnpc_1 miniupnpc_2;
  miniupnpc = miniupnpc_1;

  mir-qualia = callPackage ../tools/text/mir-qualia {
    pythonPackages = python3Packages;
  };

  mjpegtools = callPackage ../tools/video/mjpegtools {
    withMinimal = true;
  };

  mjpegtoolsFull = mjpegtools.override {
    withMinimal = false;
  };

  mkpasswd = hiPrio (callPackage ../tools/security/mkpasswd { });

  modemmanager = callPackage ../tools/networking/modem-manager {};

  modsecurity_standalone = callPackage ../tools/security/modsecurity { };

  monit = callPackage ../tools/system/monit { };

  moreutils = callPackage ../tools/misc/moreutils {
    inherit (perlPackages) IPCRun TimeDate TimeDuration;
    docbook-xsl = docbook_xsl;
  };

  mosh = callPackage ../tools/networking/mosh {
    inherit (perlPackages) IOTty;
  };

  motuclient = callPackage ../applications/science/misc/motu-client { };

  mpw = callPackage ../tools/security/mpw { };

  mr = callPackage ../applications/version-management/mr { };

  mtools = callPackage ../tools/filesystems/mtools { };

  mtr = callPackage ../tools/networking/mtr {};

  mtx = callPackage ../tools/backup/mtx {};

  multitran = recurseIntoAttrs (let callPackage = newScope pkgs.multitran; in rec {
    multitrandata = callPackage ../tools/text/multitran/data { };

    libbtree = callPackage ../tools/text/multitran/libbtree { };

    libmtsupport = callPackage ../tools/text/multitran/libmtsupport { };

    libfacet = callPackage ../tools/text/multitran/libfacet { };

    libmtquery = callPackage ../tools/text/multitran/libmtquery { };

    mtutils = callPackage ../tools/text/multitran/mtutils { };
  });

  mytetra = libsForQt5.callPackage ../applications/office/mytetra { };

  nano-wallet = libsForQt5.callPackage ../applications/altcoins/nano-wallet { };

  nbd = callPackage ../tools/networking/nbd { };
  inherit (callPackages ../development/libraries/science/math/nccl { })
    nccl_cudatoolkit_8
    nccl_cudatoolkit_9;

  nccl = nccl_cudatoolkit_9;

  nestopia = callPackage ../misc/emulators/nestopia { };

  netcdf = callPackage ../development/libraries/netcdf { };

  netcdf-mpi = appendToName "mpi" (netcdf.override {
    hdf5 = hdf5-mpi;
  });

  netcdfcxx4 = callPackage ../development/libraries/netcdf-cxx4 { };

  netcdffortran = callPackage ../development/libraries/netcdf-fortran { };

  nco = callPackage ../development/libraries/nco { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = libressl.nc;

  netcat-gnu = callPackage ../tools/networking/netcat { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  # stripped down, needed by steam
  networkmanager098 = callPackage ../tools/networking/network-manager/0.9.8 { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager-iodine = callPackage ../tools/networking/network-manager/iodine { };

  networkmanager-openvpn = callPackage ../tools/networking/network-manager/openvpn { };

  networkmanager-l2tp = callPackage ../tools/networking/network-manager/l2tp { };

  networkmanager-vpnc = callPackage ../tools/networking/network-manager/vpnc { };

  networkmanager-openconnect = callPackage ../tools/networking/network-manager/openconnect { };

  networkmanager-fortisslvpn = callPackage ../tools/networking/network-manager/fortisslvpn { };

  networkmanager_strongswan = callPackage ../tools/networking/network-manager/strongswan.nix { };

  networkmanagerapplet = callPackage ../tools/networking/network-manager/applet.nix { };

  networkmanager_dmenu = callPackage ../tools/networking/network-manager/dmenu.nix  { };

  nextcloud = callPackage ../servers/nextcloud { };

  nextcloud-client = libsForQt5.callPackage ../applications/networking/nextcloud-client { };

  nextcloud-news-updater = callPackage ../servers/nextcloud/news-updater.nix { };

  ngrok = ngrok-2;

  ngrok-2 = callPackage ../tools/networking/ngrok-2 { };

  nomad = callPackage ../applications/networking/cluster/nomad {
    buildGoPackage = buildGo110Package;
  };

  mpack = callPackage ../tools/networking/mpack { };

  pa_applet = callPackage ../tools/audio/pa-applet { };

  niff = callPackage ../tools/package-management/niff { };

  nifskope = libsForQt59.callPackage ../tools/graphics/nifskope { };

  nms = callPackage ../tools/misc/nms { };

  nkf = callPackage ../tools/text/nkf {};

  nlopt = callPackage ../development/libraries/nlopt { octave = null; };

  npapi_sdk = callPackage ../development/libraries/npapi-sdk {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap { };

  nmap-graphical = nmap.override {
    graphicalSupport = true;
  };

  nmapsi4 = libsForQt5.callPackage ../tools/security/nmap/qt.nix { };

  notary = callPackage ../tools/security/notary {
    buildGoPackage = buildGo110Package;
  };

  notify-osd = callPackage ../applications/misc/notify-osd { };

  nox = callPackage ../tools/package-management/nox { };

  nq = callPackage ../tools/system/nq { };

  nss_pam_ldapd = callPackage ../tools/networking/nss-pam-ldapd {};

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntfy = pythonPackages.ntfy;

  ntp = callPackage ../tools/networking/ntp {
    libcap = if stdenv.isLinux then libcap else null;
  };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nwdiag = with python3Packages; toPythonApplication nwdiag;

  oathToolkit = callPackage ../tools/security/oath-toolkit { inherit (gnome2) gtkdoc;  };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  offlineimap = callPackage ../tools/networking/offlineimap { };

  ola = callPackage ../applications/misc/ola { };

  onioncircuits = callPackage ../tools/security/onioncircuits {
    inherit (gnome3) defaultIconTheme;
  };

  opendylan = callPackage ../development/compilers/opendylan {
    opendylan-bootstrap = opendylan_bin;
  };

  opendylan_bin = callPackage ../development/compilers/opendylan/bin.nix { };

  openntpd = callPackage ../tools/networking/openntpd { };

  openntpd_nixos = openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  opensc = callPackage ../tools/security/opensc {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  opensm = callPackage ../tools/networking/opensm { };

  openssh =
    callPackage ../tools/networking/openssh {
      hpnSupport = false;
      etcDir = "/etc/ssh";
      pam = if stdenv.isLinux then pam else null;
    };

  openssh_hpn = pkgs.appendToName "with-hpn" (openssh.override { hpnSupport = true; });

  openssh_gssapi = pkgs.appendToName "with-gssapi" (openssh.override {
    withGssapiPatches = true;
  });

  opensp = callPackage ../tools/text/sgml/opensp { };

  openvpn = callPackage ../tools/networking/openvpn { };

  openvpn_learnaddress = callPackage ../tools/networking/openvpn/openvpn_learnaddress.nix { };

  openvpn-auth-ldap = callPackage ../tools/networking/openvpn/openvpn-auth-ldap.nix {
    stdenv = clangStdenv;
  };

  update-resolv-conf = callPackage ../tools/networking/openvpn/update-resolv-conf.nix { };

  optipng = callPackage ../tools/graphics/optipng {
    libpng = libpng12;
  };

  ostree = callPackage ../tools/misc/ostree { };

  owncloud = owncloud70;

  inherit (callPackages ../servers/owncloud { })
    owncloud70
    owncloud80
    owncloud81
    owncloud82
    owncloud90
    owncloud91;

  owncloud-client = libsForQt5.callPackage ../applications/networking/owncloud-client { };

  packagekit = callPackage ../tools/package-management/packagekit { };

  packagekit-qt = libsForQt5.callPackage ../tools/package-management/packagekit/qt.nix { };

  pal = callPackage ../tools/misc/pal { };

  pandoc = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.pandoc) (drv: {
    configureFlags = drv.configureFlags or [] ++ ["-fembed_data_files"];
    buildDepends = drv.buildDepends or [] ++ [haskellPackages.file-embed];
  });

  paper-gtk-theme = callPackage ../misc/themes/paper { };

  parallel = callPackage ../tools/misc/parallel { };

  parted = callPackage ../tools/misc/parted { };

  pell = callPackage ../applications/misc/pell { };

  percona-xtrabackup = callPackage ../tools/backup/percona-xtrabackup {
    boost = boost159;
  };

  pitivi = callPackage ../applications/video/pitivi {
    gst = gst_all_1 //
      { gst-plugins-bad = gst_all_1.gst-plugins-bad.overrideDerivation
          (attrs: { nativeBuildInputs = attrs.nativeBuildInputs ++ [ gtk3 ];
                    # Fix this build error in ./tests/examples/waylandsink:
                    #   main.c:28:2: error: #error "Wayland is not supported in GTK+"
                    configureFlags = attrs.configureFlags or [] ++ [ "--enable-wayland=no" ];
                  });
      };
  };

  ipsecTools = callPackage ../os-specific/linux/ipsec-tools { flex = flex_2_5_35; };

  patch = gnupatch;

  pcsclite = callPackage ../tools/security/pcsclite {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcsctools = callPackage ../tools/security/pcsctools {
    inherit (perlPackages) pcscperl Glib Gtk2 Pango Cairo;
  };

  pdd = python3Packages.callPackage ../tools/misc/pdd { };

  pdf-redact-tools = callPackage ../tools/graphics/pdfredacttools { };

  fmodex = callPackage ../games/zandronum/fmod.nix { };

  pdfmod = callPackage ../applications/misc/pdfmod { mono = mono4; };

  pdfread = callPackage ../tools/graphics/pdfread {
    inherit (pythonPackages) pillow;
  };

  brickd = callPackage ../servers/brickd {
    libusb = libusb1;
  };

  pg_top = callPackage ../tools/misc/pg_top { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pinentry = callPackage ../tools/security/pinentry {
    libcap = if stdenv.isDarwin then null else libcap;
  };

  pinentry_ncurses = self.pinentry.override {
    gtk2 = null;
  };

  pinentry_emacs = self.pinentry.override {
    enableEmacs = true;
  };

  pinentry_gnome = self.pinentry.override {
    gcr = gnome3.gcr;
  };

  pinentry_qt4 = self.pinentry.override {
    qt = qt4;
  };

  pinentry_qt5 = self.pinentry.override {
    qt = qt5.qtbase;
  };

  pinentry_mac = callPackage ../tools/security/pinentry/mac.nix {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  platformioPackages = callPackage ../development/arduino/platformio { };
  platformio = platformioPackages.platformio-chrootenv;

  playbar2 = libsForQt5.callPackage ../applications/audio/playbar2 { };

  plex = callPackage ../servers/plex { enablePlexPass = config.plex.enablePlexPass or false; };

  plexpy = callPackage ../servers/plexpy { python = python2; };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  pngcheck = callPackage ../tools/graphics/pngcheck {
    zlib = zlibStatic;
  };

  pngtoico = callPackage ../tools/graphics/pngtoico {
    libpng = libpng12;
  };

  pngpp = callPackage ../development/libraries/png++ { };

  polkit_gnome = callPackage ../tools/security/polkit-gnome { };

  ppl = callPackage ../development/libraries/ppl { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  prey-bash-client = callPackage ../tools/security/prey { };

  pws = callPackage ../tools/misc/pws { };

  psutils = callPackage ../tools/typesetting/psutils { };

  psensor = callPackage ../tools/system/psensor {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  pv = callPackage ../tools/misc/pv { };

  pycangjie = pythonPackages.pycangjie;

  pythonIRClib = pythonPackages.pythonIRClib;

  pythonSexy = pythonPackages.libsexy;

  rocket = libsForQt5.callPackage ../tools/graphics/rocket { };

  rtaudio = callPackage ../development/libraries/audio/rtaudio { };

  rtmidi = callPackage ../development/libraries/audio/rtmidi { };

  openmpi = callPackage ../development/libraries/openmpi { };

  qlcplus = libsForQt5.callPackage ../applications/misc/qlcplus { };

  qastools = libsForQt5.callPackage ../tools/audio/qastools { };

  qesteidutil = libsForQt5.callPackage ../tools/security/qesteidutil { } ;
  qdigidoc = libsForQt5.callPackage ../tools/security/qdigidoc { } ;
  qpdf = callPackage ../development/libraries/qpdf { };

  qscintilla = callPackage ../development/libraries/qscintilla { };

  qtikz = libsForQt5.callPackage ../applications/graphics/ktikz { };

  quilt = callPackage ../development/tools/quilt { };

  quota = if stdenv.isLinux then linuxquota else unixtools.quota;

  radeon-profile = libsForQt5.callPackage ../tools/misc/radeon-profile { };

  rainbowstream = pythonPackages.rainbowstream;

  rarian = callPackage ../development/libraries/rarian { };

  rc = callPackage ../shells/rc { };

  redir = callPackage ../tools/networking/redir { };

  redmine = callPackage ../applications/version-management/redmine { ruby = pkgs.ruby_2_4; };

  rt = callPackage ../servers/rt { };

  rtmpdump = callPackage ../tools/video/rtmpdump { };
  rtmpdump_gnutls = rtmpdump.override { gnutlsSupport = true; opensslSupport = false; };

  reaverwps = callPackage ../tools/networking/reaver-wps {};

  reaverwps-t6x = callPackage ../tools/networking/reaver-wps-t6x {};

  recordmydesktop = callPackage ../applications/video/recordmydesktop { };

  gtk-recordmydesktop = callPackage ../applications/video/recordmydesktop/gtk.nix {
    jack2 = jack2Full;
  };

  qt-recordmydesktop = callPackage ../applications/video/recordmydesktop/qt.nix {
    jack2 = jack2Full;
  };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome2) gnome_vfs GConf;
  };

  remmina = callPackage ../applications/networking/remote/remmina {
    adwaita-icon-theme = gnome3.adwaita-icon-theme;
    gsettings-desktop-schemas = gnome3.gsettings-desktop-schemas;
  };

  rename = callPackage ../tools/misc/rename { };

  renderdoc = libsForQt5.callPackage ../applications/graphics/renderdoc { };

  replace = callPackage ../tools/text/replace { };

  reckon = callPackage ../tools/text/reckon { };

  riemann_c_client = callPackage ../tools/misc/riemann-c-client { };
  rmlint = callPackage ../tools/misc/rmlint {
    inherit (pythonPackages) sphinx;
  };

  rq = callPackage ../development/tools/rq {
    v8 = v8_static;
  };

  rockbox_utility = libsForQt5.callPackage ../tools/misc/rockbox-utility { };

  rosegarden = libsForQt5.callPackage ../applications/audio/rosegarden { };

  rpPPPoE = callPackage ../tools/networking/rp-pppoe { };

  rpiboot-unstable = callPackage ../development/misc/rpiboot/unstable.nix { };

  rpm = callPackage ../tools/package-management/rpm { };

  rpm-ostree = callPackage ../tools/misc/rpm-ostree {
    gperf = gperf_3_0;
  };

  rrdtool = callPackage ../tools/misc/rrdtool { };

  rsibreak = libsForQt5.callPackage ../applications/misc/rsibreak { };

  rss2email = callPackage ../applications/networking/feedreaders/rss2email {
    pythonPackages = python3Packages;
  };

  rubber = callPackage ../tools/typesetting/rubber { };

  rw = callPackage ../tools/misc/rw { };

  rzip = callPackage ../tools/compression/rzip { };

  s6-dns = skawarePackages.s6-dns;

  s6-linux-utils = skawarePackages.s6-linux-utils;

  s6-networking = skawarePackages.s6-networking;

  s6-portable-utils = skawarePackages.s6-portable-utils;

  salt = callPackage ../tools/admin/salt {};

  salut_a_toi = callPackage ../applications/networking/instant-messengers/salut-a-toi {};

  screen = callPackage ../tools/misc/screen {
    inherit (darwin.apple_sdk.libs) utmp;
  };

  scrcpy = callPackage ../misc/scrcpy {
    inherit (androidenv) platformTools;
  };

  screencloud = callPackage ../applications/graphics/screencloud {
    quazip = quazip_qt4;
  };

  screenkey = python2Packages.callPackage ../applications/video/screenkey {
    inherit (gnome3) defaultIconTheme;
  };

  quazip_qt4 = libsForQt5.quazip.override {
    qtbase = qt4; qmake = qmake4Hook;
  };

  scfbuild = python2.pkgs.callPackage ../tools/misc/scfbuild { };

  scrot = callPackage ../tools/graphics/scrot { };

  scrypt = callPackage ../tools/security/scrypt { };

  sec = callPackage ../tools/admin/sec { };

  secp256k1 = callPackage ../tools/security/secp256k1 { };

  setroot = callPackage  ../tools/X11/setroot { };

  seqdiag = with python3Packages; toPythonApplication seqdiag;

  shout = nodePackages.shout;

  sic = callPackage ../applications/networking/irc/sic { };

  sigal = callPackage ../applications/misc/sigal {
    inherit (pythonPackages) buildPythonApplication fetchPypi;
  };

  sigil = libsForQt5.callPackage ../applications/editors/sigil { };

  # aka., pgp-tools
  silc_client = callPackage ../applications/networking/instant-messengers/silc-client { };

  silc_server = callPackage ../servers/silc-server { };

  sile = callPackage ../tools/typesetting/sile {
  inherit (lua52Packages) lua luaexpat luazlib luafilesystem lpeg;
  };

  simplescreenrecorder = libsForQt5.callPackage ../applications/video/simplescreenrecorder { };

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  sit = callPackage ../applications/version-management/sit {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  sks = callPackage ../servers/sks { inherit (ocaml-ng.ocamlPackages_4_02) ocaml camlp4; };

  skribilo = callPackage ../tools/typesetting/skribilo {
    tex = texlive.combined.scheme-small;
  };

  slimrat = callPackage ../tools/networking/slimrat {
    inherit (perlPackages) WWWMechanize LWP;
  };

  slstatus = callPackage ../applications/misc/slstatus {
    conf = config.slstatus.conf or null;
  };

  smartmontools = callPackage ../tools/system/smartmontools {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
  };

  smarty3 = callPackage ../development/libraries/smarty3 { };
  smbldaptools = callPackage ../tools/networking/smbldaptools {
    inherit (perlPackages) perlldap CryptSmbHash DigestSHA1;
  };

  smenu = callPackage ../tools/misc/smenu { };

  smugline = python3Packages.smugline;

  snabb = callPackage ../tools/networking/snabb { } ;

  sng = callPackage ../tools/graphics/sng {
    libpng = libpng12;
  };

  softhsm = callPackage ../tools/security/softhsm {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  stdman = callPackage ../data/documentation/stdman { };

  fusesmb = callPackage ../tools/filesystems/fusesmb { samba = samba3; };

  sl = callPackage ../tools/misc/sl { };

  socat = callPackage ../tools/networking/socat { };

  socat2pre = lowPrio (callPackage ../tools/networking/socat/2.x.nix { });

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  spaceFM = callPackage ../applications/misc/spacefm { };

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  sshfs-fuse = callPackage ../tools/filesystems/sshfs-fuse { };
  sshfs = sshfs-fuse; # added 2017-08-14

  subsurface = libsForQt5.callPackage ../applications/misc/subsurface { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = callPackage ../tools/system/suid-chroot { };

  super = callPackage ../tools/security/super { };

  super-user-spark = haskellPackages.callPackage ../applications/misc/super_user_spark { };

  sslscan = callPackage ../tools/security/sslscan {
    openssl = openssl_1_0_2.override { enableSSL2 = true; };
  };

  ssmtp = callPackage ../tools/networking/ssmtp {
    tlsSupport = true;
  };

  stress = callPackage ../tools/system/stress { };

  stoken = callPackage ../tools/security/stoken {
    withGTK3 = config.stoken.withGTK3 or true;
  };

  storeBackup = callPackage ../tools/backup/store-backup { };

  stun = callPackage ../tools/networking/stun { };

  stutter = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.stutter) (drv: {
    preCheck = "export PATH=dist/build/stutter:$PATH";
  });

  strongswan    = callPackage ../tools/networking/strongswan { };
  strongswanTNC = strongswan.override { enableTNC = true; };
  strongswanNM  = strongswan.override { enableNetworkManager = true; };

  su = shadow.su;

  swec = callPackage ../tools/networking/swec {
    inherit (perlPackages) LWP URI HTMLParser HTTPServerSimple Parent;
  };

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    libxml2 = libxml2Python;
    pythonPackages = python3Packages;
   };

  staruml = callPackage ../tools/misc/staruml { inherit (gnome2) GConf; libgcrypt = libgcrypt_1_5; };

  otter-browser = qt5.callPackage ../applications/networking/browsers/otter {};

  privoxy = callPackage ../tools/networking/privoxy {
    w3m = w3m-batch;
  };

  t = callPackage ../tools/misc/t { };

  tarsnap = callPackage ../tools/backup/tarsnap { };

  tboot = callPackage ../tools/security/tboot { };

  ted = callPackage ../tools/typesetting/ted { };

  teamviewer = libsForQt5.callPackage ../applications/networking/remote/teamviewer { };

  telepresence = callPackage ../tools/networking/telepresence {
    pythonPackages = python3Packages;
  };

  texmacs = if stdenv.isDarwin
    then callPackage ../applications/editors/texmacs/darwin.nix {
      inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
      tex = texlive.combined.scheme-small;
      extraFonts = true;
    } else callPackage ../applications/editors/texmacs {
      tex = texlive.combined.scheme-small;
      extraFonts = true;
    };

  texmaker = libsForQt5.callPackage ../applications/editors/texmaker { };

  texstudio = libsForQt5.callPackage ../applications/editors/texstudio { };

  thefuck = python3Packages.callPackage ../tools/misc/thefuck { };

  tiled = libsForQt5.callPackage ../applications/editors/tiled { };

  tinc = callPackage ../tools/networking/tinc { };

  tie = callPackage ../development/tools/misc/tie { };

  tikzit = libsForQt5.callPackage ../tools/typesetting/tikzit { };

  tinc_pre = callPackage ../tools/networking/tinc/pre.nix { };

  tiny8086 = callPackage ../applications/virtualization/8086tiny { };

  tio = callPackage ../tools/misc/tio { };

  tldr = callPackage ../tools/misc/tldr { };

  tldr-hs = haskellPackages.tldr;

  tmpwatch = callPackage ../tools/misc/tmpwatch  { };

  tmux = callPackage ../tools/misc/tmux { };

  tmuxPlugins = recurseIntoAttrs (callPackage ../misc/tmux-plugins { });

  tmsu = callPackage ../tools/filesystems/tmsu {
    go = go_1_10;
  };

  tor = callPackage ../tools/security/tor {
    openssl = openssl_1_1;
    # remove this, when libevent's openssl is upgraded to 1_1_0 or newer.
    libevent = libevent.override {
      sslSupport = false;
    };
  };

  tor-arm = callPackage ../tools/security/tor/tor-arm.nix { };

  tor-browser-bundle-bin = callPackage ../applications/networking/browsers/tor-browser-bundle-bin {
    inherit (gnome3) defaultIconTheme;
  };

  tor-browser-bundle = callPackage ../applications/networking/browsers/tor-browser-bundle {
    stdenv = stdenvNoCC;
    tor-browser-unwrapped = firefoxPackages.tor-browser;
    inherit (python27Packages) obfsproxy;
  };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  traceroute = callPackage ../tools/networking/traceroute { };

  inherit (nodePackages) triton;

  tryton = callPackage ../applications/office/tryton { };

  ttfautohint = libsForQt5.callPackage ../tools/misc/ttfautohint { };
  ttfautohint-nox = ttfautohint.override { enableGUI = false; };

  twilight = callPackage ../tools/graphics/twilight {
    libX11 = xorg.libX11;
  };

  twitterBootstrap3 = callPackage ../development/web/twitter-bootstrap {};
  twitterBootstrap = twitterBootstrap3;

  ua = callPackage ../tools/networking/ua { };

  ucl = callPackage ../development/libraries/ucl { };

  udpt = callPackage ../servers/udpt { };

  ufraw = callPackage ../applications/graphics/ufraw {
    stdenv = overrideCC stdenv gcc6; # doesn't build with gcc7
  };

  uget = callPackage ../tools/networking/uget { };

  up = callPackage ../tools/misc/up { };

  usbmuxd = callPackage ../tools/misc/usbmuxd {};

  uwsgi = callPackage ../servers/uwsgi {
    plugins = [];
    withPAM = stdenv.isLinux;
    withSystemd = stdenv.isLinux;
  };

  vampire = callPackage ../applications/science/logic/vampire {};

  vcsh = callPackage ../applications/version-management/vcsh {
    inherit (perlPackages) ShellCommand TestMost TestDifferences TestDeep
      TestException TestWarn;
  };

  viking = callPackage ../applications/misc/viking {
    inherit (gnome2) scrollkeeper;
    inherit (gnome3) gexiv2;
  };

  visidata = (newScope python3Packages) ../applications/misc/visidata {
  };

  vit = callPackage ../applications/misc/vit { };

  volume_key = callPackage ../development/libraries/volume-key { };

  vpnc = callPackage ../tools/networking/vpnc { };

  vp = callPackage ../applications/misc/vp {
    # Enable next line for console graphics. Note that
    # it requires `sixel` enabled terminals such as mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
  };

  openconnect_pa = callPackage ../tools/networking/openconnect_pa {
    openssl = null;
  };

  openconnect = openconnect_gnutls;

  openconnect_openssl = callPackage ../tools/networking/openconnect {
    gnutls = null;
  };

  openconnect_gnutls = callPackage ../tools/networking/openconnect {
    openssl = null;
  };

  sssd = callPackage ../os-specific/linux/sssd {
    inherit (perlPackages) Po4a;
    inherit (python27Packages) ldap;
  };

  wakatime = pythonPackages.callPackage ../tools/misc/wakatime { };

  weather = callPackage ../applications/misc/weather { };

  wal_e = callPackage ../tools/backup/wal-e { };

  watchexec = callPackage ../tools/misc/watchexec {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreFoundation;
  };

  watchman = callPackage ../development/tools/watchman {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    CoreFoundation = darwin.cf-private;
  };

  webassemblyjs-cli = nodePackages."@webassemblyjs/cli";
  webassemblyjs-repl = nodePackages."@webassemblyjs/repl";
  wasm-strip = nodePackages."@webassemblyjs/wasm-strip";
  wasm-text-gen = nodePackages."@webassemblyjs/wasm-text-gen";
  wast-refmt = nodePackages."@webassemblyjs/wast-refmt";

  whois = callPackage ../tools/networking/whois { };

  wolfebin = callPackage ../tools/networking/wolfebin {
    python = python2;
  };

  xe = callPackage ../tools/system/xe { };

  testdisk = callPackage ../tools/misc/testdisk { };

  htmldoc = callPackage ../tools/typesetting/htmldoc {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration Foundation;
  };

  rcm = callPackage ../tools/misc/rcm {};

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc xorg.fontbhlucidatypewriter75dpi ];
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = callPackage ../tools/misc/time { };

  tweet-hs = haskell.lib.justStaticExecutables haskellPackages.tweet-hs;

  tkgate = callPackage ../applications/science/electronics/tkgate/1.x.nix { };

  tm = callPackage ../tools/system/tm { };

  tre = callPackage ../development/libraries/tre { };

  ts = callPackage ../tools/system/ts { };

  transfig = callPackage ../tools/graphics/transfig {
    libpng = libpng12;
  };

  unclutter = callPackage ../tools/misc/unclutter { };

  units = callPackage ../tools/misc/units { };

  xar = callPackage ../tools/compression/xar { };

  xarchive = callPackage ../tools/archivers/xarchive { };

  ugarit = callPackage ../tools/backup/ugarit { };

  unar = callPackage ../tools/archivers/unar { stdenv = clangStdenv; };

  unp = callPackage ../tools/archivers/unp { };

  unzip = callPackage ../tools/archivers/unzip { };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  urjtag = callPackage ../tools/misc/urjtag {
    svfSupport = true;
    bsdlSupport = true;
    staplSupport = true;
    jedecSupport = true;
  };

  valum = callPackage ../development/web/valum {
    inherit (gnome3) libgee;
  };

  inherit (callPackages ../servers/varnish { })
    varnish4 varnish5 varnish6;
  inherit (callPackages ../servers/varnish/packages.nix { })
    varnish4Packages
    varnish5Packages
    varnish6Packages;

  varnishPackages = varnish5Packages;
  varnish = varnishPackages.varnish;

  venus = callPackage ../tools/misc/venus {
    python = python27;
  };

  veracrypt = callPackage ../applications/misc/veracrypt {
    wxGTK = wxGTK30;
  };

  waf = callPackage ../development/tools/build-managers/waf { python = python3; };

  wdiff = callPackage ../tools/text/wdiff { };

  wget = callPackage ../tools/networking/wget {
    inherit (perlPackages) IOSocketSSL LWP;
    libpsl = null;
  };

  which = callPackage ../tools/system/which { };

  wipe = callPackage ../tools/security/wipe { };

  wol = callPackage ../tools/networking/wol { };

  wring = nodePackages.wring;

  wrk = callPackage ../tools/networking/wrk { };

  wv = callPackage ../tools/misc/wv { };

  wyrd = callPackage ../tools/misc/wyrd {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = callPackage ../tools/misc/xburst-tools {
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross = pkgsCross.ben-nanonote.buildPackages.gccCrossStageStatic;
  };

  xdelta = callPackage ../tools/compression/xdelta { };
  xdeltaUnstable = callPackage ../tools/compression/xdelta/unstable.nix { };

  xflux = callPackage ../tools/misc/xflux { };
  xflux-gui = callPackage ../tools/misc/xflux/gui.nix {
    gnome_python = gnome2.gnome_python;
  };

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { utillinux = utillinuxMinimal; };
  libxfs = xfsprogs.dev;

  xml2 = callPackage ../tools/text/xml/xml2 { };

  xmlto = callPackage ../tools/typesetting/xmlto {
    w3m = w3m-batch;
  };

  xmpppy = pythonPackages.xmpppy;

  xpf = callPackage ../tools/text/xml/xpf {
    libxml2 = libxml2Python;
  };

  xsecurelock = callPackage ../tools/X11/xsecurelock {
    xset = xorg.xset;
  };

  xtreemfs = callPackage ../tools/filesystems/xtreemfs {
    boost = boost165;
  };

  xvfb_run = callPackage ../tools/misc/xvfb-run { inherit (texFunctions) fontsConf; };

  yarn = callPackage ../development/tools/yarn  { };

  yarn2nix = callPackage ../development/tools/yarn2nix { };
  inherit (yarn2nix) mkYarnPackage;

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix { };

  you-get = python3Packages.callPackage ../tools/misc/you-get { };

  zinnia = callPackage ../tools/inputmethods/zinnia { };
  par = callPackage ../tools/text/par { };

  zip = callPackage ../tools/archivers/zip { };

  zpaq = callPackage ../tools/archivers/zpaq { };
  zpaqd = callPackage ../tools/archivers/zpaq/zpaqd.nix { };

  ### SHELLS

  runtimeShell = "${runtimeShellPackage}${runtimeShellPackage.shellPath}";
  runtimeShellPackage = bash;

  bash = lowPrio (callPackage ../shells/bash/4.4.nix { });

  # WARNING: this attribute is used by nix-shell so it shouldn't be removed/renamed
  bashInteractive = callPackage ../shells/bash/4.4.nix {
    interactive = true;
    withDocs = true;
  };

  bash-completion = callPackage ../shells/bash/bash-completion { };

  dash = callPackage ../shells/dash { };

  es = callPackage ../shells/es { };

  fish = callPackage ../shells/fish { };

  ion = callPackage ../shells/ion { };

  mksh = callPackage ../shells/mksh { };

  oh = callPackage ../shells/oh { };

  oil = callPackage ../shells/oil { };

  rush = callPackage ../shells/rush { };

  zsh = callPackage ../shells/zsh { };

  zsh-completions = callPackage ../shells/zsh/zsh-completions { };

  ### DEVELOPMENT / COMPILERS

  adoptopenjdk-bin-11-packages-linux = import ../development/compilers/adoptopenjdk-bin/jdk11-linux.nix;
  adoptopenjdk-bin-11-packages-darwin = import ../development/compilers/adoptopenjdk-bin/jdk11-darwin.nix;

  adoptopenjdk-hotspot-bin-11 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-11-packages-linux.jdk-hotspot {}
    else callPackage adoptopenjdk-bin-11-packages-darwin.jdk-hotspot {};
  adoptopenjdk-jre-hotspot-bin-11 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-11-packages-linux.jre-hotspot {}
    else callPackage adoptopenjdk-bin-11-packages-darwin.jre-hotspot {};

  adoptopenjdk-openj9-bin-11 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-11-packages-linux.jdk-openj9 {}
    else callPackage adoptopenjdk-bin-11-packages-darwin.jdk-openj9 {};
  adoptopenjdk-jre-openj9-bin-11 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-11-packages-linux.jre-openj9 {}
    else callPackage adoptopenjdk-bin-11-packages-darwin.jre-openj9 {};

  adoptopenjdk-bin = adoptopenjdk-hotspot-bin-11;
  adoptopenjdk-jre-bin = adoptopenjdk-jre-hotspot-bin-11;

  ats = callPackage ../development/compilers/ats { };
  avian = callPackage ../development/compilers/avian {
    inherit (darwin.apple_sdk.frameworks) CoreServices Foundation;
    stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
  };

  eggDerivation = callPackage ../development/compilers/chicken/eggDerivation.nix { };

  chicken = callPackage ../development/compilers/chicken {
    bootstrap-chicken = chicken.override { bootstrap-chicken = null; };
  };

  egg2nix = callPackage ../development/tools/egg2nix {
    chickenEggs = callPackage ../development/tools/egg2nix/chicken-eggs.nix { };
  };

  ccl = callPackage ../development/compilers/ccl {
    inherit (darwin) bootstrap_cmds;
  };

  chez = callPackage ../development/compilers/chez {
    inherit (darwin) cctools;
  };

  clang = llvmPackages.clang;
  clang-manpages = llvmPackages.clang-manpages;

  clang-sierraHack = clang.override {
    name = "clang-wrapper-with-reexport-hack";
    bintools = darwin.binutils.override {
      useMacosReexportHack = true;
      bintools = darwin.binutils.bintools.override {
        cctools = darwin.cctools.override {
          enableDumpNormalizedLibArgs = true;
        };
      };
    };
  };

  clang_7  = llvmPackages_7.clang;
  clang_6  = llvmPackages_6.clang;
  clang_5  = llvmPackages_5.clang;
  clang_4  = llvmPackages_4.clang;
  clang_39 = llvmPackages_39.clang;
  clang_38 = llvmPackages_38.clang;
  clang_37 = llvmPackages_37.clang;
  clang_35 = wrapCC llvmPackages_35.clang;

  #Use this instead of stdenv to build with clang
  clangStdenv = if stdenv.cc.isClang then stdenv else lowPrio llvmPackages.stdenv;
  clang-sierraHack-stdenv = overrideCC stdenv clang-sierraHack;
  libcxxStdenv = if stdenv.isDarwin then stdenv else lowPrio llvmPackages.libcxxStdenv;

  clasp-common-lisp = callPackage ../development/compilers/clasp {};

  clean = callPackage ../development/compilers/clean { };

  closurecompiler = callPackage ../development/compilers/closure { };

  cmucl_binary = pkgsi686Linux.callPackage ../development/compilers/cmucl/binary.nix { };

  # Users installing via `nix-env` will likely be using the REPL,
  # which has a hard dependency on Z3, so make sure it is available.
  cryptol = haskellPackages.cryptol.overrideDerivation (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or []) ++ [ makeWrapper ];
    installPhase = (oldAttrs.installPhase or "") + ''
      wrapProgram $out/bin/cryptol \
        --prefix 'PATH' ':' "${lib.getBin z3}/bin"
    '';
  });

  inherit (callPackages ../development/compilers/crystal {})
    crystal_0_25
    crystal_0_26
    crystal;

  icr = callPackage ../development/tools/icr {};

  scry = callPackage ../development/tools/scry {};

  dotty = callPackage ../development/compilers/scala/dotty.nix { jre = jre8;};

  ecl = callPackage ../development/compilers/ecl { };
  ecl_16_1_2 = callPackage ../development/compilers/ecl/16.1.2.nix { };

  eli = callPackage ../development/compilers/eli { };

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  fasm = pkgsi686Linux.callPackage ../development/compilers/fasm {
    inherit (stdenv) isx86_64;
  };
  fasm-bin = callPackage ../development/compilers/fasm/bin.nix { };

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { stdenv = gccStdenv; };
  gambit-unstable = callPackage ../development/compilers/gambit/unstable.nix { stdenv = gccStdenv; };
  gerbil = callPackage ../development/compilers/gerbil { stdenv = gccStdenv; };
  gerbil-unstable = callPackage ../development/compilers/gerbil/unstable.nix { stdenv = gccStdenv; };

  gccFun = callPackage ../development/compilers/gcc/7;
  gcc = gcc7;
  gcc-unwrapped = gcc.cc;

  gccStdenv = if stdenv.cc.isGNU then stdenv else stdenv.override {
    allowedRequisites = null;
    cc = gcc;
    # Remove libcxx/libcxxabi, and add clang for AS if on darwin (it uses
    # clang's internal assembler).
    extraBuildInputs = lib.optional stdenv.hostPlatform.isDarwin clang.cc;
  };

  gcc7Stdenv = overrideCC gccStdenv gcc7;
  gcc8Stdenv = overrideCC gccStdenv gcc8;

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

  gccMultiStdenv = overrideCC stdenv gcc_multi;
  clangMultiStdenv = overrideCC stdenv clang_multi;
  multiStdenv = if stdenv.cc.isClang then clangMultiStdenv else gccMultiStdenv;

  gcc_debug = lowPrio (wrapCC (gcc.cc.override {
    stripped = false;
  }));

  libstdcxxHook = makeSetupHook
    { substitutions = { gcc = gcc-unwrapped; }; }
    ../development/compilers/gcc/libstdc++-hook.sh;

  crossLibcStdenv = overrideCC stdenv buildPackages.gccCrossStageStatic;

  # The GCC used to build libc for the target platform. Normal gccs will be
  # built with, and use, that cross-compiled libc.
  gccCrossStageStatic = assert stdenv.targetPlatform != stdenv.hostPlatform; let
    libcCross1 =
      if stdenv.targetPlatform.libc == "msvcrt" then targetPackages.windows.mingw_w64_headers
      else if stdenv.targetPlatform.libc == "libSystem" then darwin.xcode
      else null;
    binutils1 = wrapBintoolsWith {
      bintools = binutils-unwrapped;
      libc = libcCross1;
    };
    in wrapCCWith {
      cc = gccFun {
        # copy-pasted
        inherit noSysDirs;
        # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
        profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));
        isl = if !stdenv.isDarwin then isl_0_17 else null;

        # just for stage static
        crossStageStatic = true;
        langCC = false;
        libcCross = libcCross1;
        targetPackages.stdenv.cc.bintools = binutils1;
        enableShared = false;
      };
      bintools = binutils1;
      libc = libcCross1;
  };

  gcc48 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isSunOS && !isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
    cloog = if !stdenv.isDarwin then cloog else null;
    texinfo = texinfo5; # doesn't validate since 6.1 -> 6.3 bump
  }));

  gcc49 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.9 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_11 else null;

    cloog = if !stdenv.isDarwin then cloog_0_18_0 else null;
  }));

  gcc5 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/5 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gcc6 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/6 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gcc7 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/7 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc8 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc-snapshot = lowPrio (wrapCC (callPackage ../development/compilers/gcc/snapshot {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;

    isl = isl_0_17;
  }));

  gfortran = gfortran7;

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

  gfortran5 = wrapCC (gcc5.cc.override {
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

  gcj = gcj6;
  gcj6 = wrapCC (gcc6.cc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig perl;
    inherit (gnome2) libart_lgpl;
  });

  gnu-smalltalk = callPackage ../development/compilers/gnu-smalltalk {
    emacsSupport = config.emacsSupport or false;
  };

  gccgo = gccgo6;
  gccgo6 = wrapCC (gcc6.cc.override {
    name = "gccgo6";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
    profiledCompiler = false;
  });

  gcl = callPackage ../development/compilers/gcl {
    gmp = gmp4;
  };

  gcl_2_6_13_pre = callPackage ../development/compilers/gcl/2.6.13-pre.nix { };

  # Haskell and GHC

  haskell = callPackage ./haskell-packages.nix { };

  haskellPackages = haskell.packages.ghc844.override {
    overrides = config.haskellPackageOverrides or haskell.packageOverrides;
  };

  inherit (haskellPackages) ghc;

  cabal-install = haskell.lib.justStaticExecutables haskellPackages.cabal-install;

  stack = haskell.lib.justStaticExecutables haskellPackages.stack;
  hlint = haskell.lib.justStaticExecutables haskellPackages.hlint;

  all-cabal-hashes = callPackage ../data/misc/hackage { };

  purescript = haskell.lib.justStaticExecutables haskellPackages.purescript;
  psc-package = haskell.lib.justStaticExecutables
    (haskellPackages.callPackage ../development/compilers/purescript/psc-package { });

  tamarin-prover =
    (haskellPackages.callPackage ../applications/science/logic/tamarin-prover {
      # NOTE: do not use the haskell packages 'graphviz' and 'maude'
      inherit maude which sapic;
      graphviz = graphviz-nox;
    });

  inherit (ocaml-ng.ocamlPackages_4_05.haxe) haxe_3_2 haxe_3_4;
  haxe = haxe_3_4;
  haxePackages = recurseIntoAttrs (callPackage ./haxe-packages.nix { });
  inherit (haxePackages) hxcpp;

  hop = callPackage ../development/compilers/hop { };

  fsharp = callPackage ../development/compilers/fsharp { };

  fsharp41 = callPackage ../development/compilers/fsharp41 {
    mono = mono46;
  };

  pyre = callPackage ../development/tools/pyre { };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix {});

  go_bootstrap = if stdenv.isAarch64 then
    srcOnly {
      name = "go-1.8-linux-arm64-bootstrap";
      src = fetchurl {
        url = "https://cache.xor.us/go-1.8-linux-arm64-bootstrap.tar.xz";
        sha256 = "0sk6g03x9gbxk2k1djnrgy8rzw1zc5f6ssw0hbxk6kjr85lpmld6";
      };
    }
  else
    callPackage ../development/compilers/go/1.4.nix {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

  go_1_9 = callPackage ../development/compilers/go/1.9.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go_1_10 = callPackage ../development/compilers/go/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go_1_11 = callPackage ../development/compilers/go/1.11.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go = go_1_11;

  gox = callPackage ../development/tools/gox { };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  icedtea8_web = callPackage ../development/compilers/icedtea-web {
    jdk = jdk8;
  };

  icedtea_web = icedtea8_web;

  idrisPackages = callPackage ../development/idris-modules {
    idris-no-deps = haskellPackages.idris;
  };

  idris = idrisPackages.with-packages [ idrisPackages.base ] ;

  irony-server = callPackage ../development/tools/irony-server {
    # The repository of irony to use -- must match the version of the employed emacs
    # package.  Wishing we could merge it into one irony package, to avoid this issue,
    # but its emacs-side expression is autogenerated, and we can't hook into it (other
    # than peek into its version).
    inherit (emacsPackagesNg.melpaStablePackages) irony;
  };

  bootjdk = callPackage ../development/compilers/openjdk/bootstrap.nix { version = "10"; };

  openjdk8 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin/8.nix { }
    else
      callPackage ../development/compilers/openjdk/8.nix {
        bootjdk = bootjdk.override { version = "8"; };
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk11 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin/11.nix { }
    else
      callPackage ../development/compilers/openjdk/11.nix {
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk = openjdk8;

  jdk8 = if stdenv.isAarch32 || stdenv.isAarch64 then oraclejdk8 else openjdk8 // { outputs = [ "out" ]; };
  jre8 = if stdenv.isAarch32 || stdenv.isAarch64 then oraclejre8 else lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}"
    (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
      (openjdk8.jre // { outputs = [ "jre" ]; }));
  jre8_headless =
    if stdenv.isAarch32 || stdenv.isAarch64 then
      oraclejre8
    else if stdenv.isDarwin then
      jre8
    else
      lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}-headless"
        (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
          ((openjdk8.override { minimal = true; }).jre // { outputs = [ "jre" ]; }));

  jdk11 = openjdk11 // { outputs = [ "out" ]; };
  jdk11_headless =
    if stdenv.isDarwin then
      jdk11
    else
      lib.setName "openjdk-${lib.getVersion pkgs.openjdk11}-headless"
        (lib.addMetaAttrs {}
          ((openjdk11.override { minimal = true; }) // {}));

  jdk = jdk8;
  jre = jre8;
  jre_headless = jre8_headless;

  inherit (callPackages ../development/compilers/graalvm { }) mx jvmci8 graalvm8;

  openshot-qt = libsForQt5.callPackage ../applications/video/openshot-qt { };

  oraclejdk = pkgs.jdkdistro true false;

  oraclejdk8 = pkgs.oraclejdk8distro true false;

  oraclejdk8psu = pkgs.oraclejdk8psu_distro true false;

  oraclejre = lowPrio (pkgs.jdkdistro false false);

  oraclejre8 = lowPrio (pkgs.oraclejdk8distro false false);

  oraclejre8psu = lowPrio (pkgs.oraclejdk8psu_distro false false);

  jrePlugin = jre8Plugin;

  jre8Plugin = lowPrio (pkgs.oraclejdk8distro false true);

  jdkdistro = oraclejdk8distro;

  oraclejdk8distro = installjdk: pluginSupport:
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8cpu-linux.nix { inherit installjdk pluginSupport; });

  oraclejdk8psu_distro = installjdk: pluginSupport:
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8psu-linux.nix { inherit installjdk pluginSupport; });

  javacard-devkit = pkgsi686Linux.callPackage ../development/compilers/javacard-devkit { };

  jikes = callPackage ../development/compilers/jikes { };

  julia_06 = callPackage ../development/compilers/julia {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
    llvm = llvm_39;
  };

  julia_07 = callPackage ../development/compilers/julia/0.7.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia_10 = callPackage ../development/compilers/julia/1.0.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia = julia_06;

  jwasm =  callPackage ../development/compilers/jwasm { };

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lessc = nodePackages.less;

  lld = llvmPackages.lld;
  lld_4 = llvmPackages_4.lld;
  lld_5 = llvmPackages_5.lld;
  lld_6 = llvmPackages_6.lld;
  lld_7 = llvmPackages_7.lld;

  lldb = llvmPackages.lldb;
  lldb_4 = llvmPackages_4.lldb;
  lldb_5 = llvmPackages_5.lldb;
  lldb_6 = llvmPackages_6.lldb;
  lldb_7 = llvmPackages_7.lldb;

  llvm = llvmPackages.llvm;
  llvm-manpages = llvmPackages.llvm-manpages;

  llvm_7  = llvmPackages_7.llvm;
  llvm_6  = llvmPackages_6.llvm;
  llvm_5  = llvmPackages_5.llvm;
  llvm_4  = llvmPackages_4.llvm;
  llvm_39 = llvmPackages_39.llvm;
  llvm_38 = llvmPackages_38.llvm;
  llvm_37 = llvmPackages_37.llvm;
  llvm_35 = llvmPackages_35.llvm;

  llvmPackages = recurseIntoAttrs llvmPackages_5;

  llvmPackages_35 = callPackage ../development/compilers/llvm/3.5 ({
    isl = isl_0_14;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_37 = callPackage ../development/compilers/llvm/3.7 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_37.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_37.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_38 = callPackage ../development/compilers/llvm/3.8 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_38.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_38.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_39 = callPackage ../development/compilers/llvm/3.9 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_39.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_39.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_4 = callPackage ../development/compilers/llvm/4 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_4.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_4.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6;
  });

  llvmPackages_5 = callPackage ../development/compilers/llvm/5 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_5.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_5.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_6 = callPackage ../development/compilers/llvm/6 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_6.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_6.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_7 = callPackage ../development/compilers/llvm/7 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_7.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_7.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });

  mercury = callPackage ../development/compilers/mercury { };

  mint = callPackage ../development/compilers/mint { };

  mitscheme = callPackage ../development/compilers/mit-scheme {
   texLive = texlive.combine { inherit (texlive) scheme-small; };
   texinfo = texinfo5;
   xlibsWrapper = null;
  };

  mitschemeX11 = mitscheme.override {
   texLive = texlive.combine { inherit (texlive) scheme-small; };
   texinfo = texinfo5;
   enableX11 = true;
  };

  inherit (callPackage ../development/compilers/mlton {})
    mlton20130715
    mlton20180207Binary
    mlton20180207
    mltonHEAD;

  mlton = mlton20180207;

  mono  = mono5;
  mono5 = mono58;
  mono4 = mono48;

  mono46 = lowPrio (callPackage ../development/compilers/mono/4.6.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono48 = lowPrio (callPackage ../development/compilers/mono/4.8.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono50 = lowPrio (callPackage ../development/compilers/mono/5.0.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono54 = lowPrio (callPackage ../development/compilers/mono/5.4.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono58 = callPackage ../development/compilers/mono/5.8.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  mono514 = callPackage ../development/compilers/mono/5.14.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  mozart-binary = callPackage ../development/compilers/mozart/binary.nix { };
  mozart = mozart-binary;

  nim = callPackage ../development/compilers/nim { };
  neko = callPackage ../development/compilers/neko { };

  nextpnr = libsForQt5.callPackage ../development/compilers/nextpnr { };

  nvidia_cg_toolkit = callPackage ../development/compilers/nvidia-cg-toolkit { };

  obliv-c = callPackage ../development/compilers/obliv-c {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  ocaml-ng = callPackage ./ocaml-packages.nix { };
  ocaml = ocamlPackages.ocaml;

  ocamlPackages = recurseIntoAttrs ocaml-ng.ocamlPackages;

  orc = callPackage ../development/compilers/orc { };

  metaocaml_3_09 = callPackage ../development/compilers/ocaml/metaocaml-3.09.nix { };

  ber_metaocaml = callPackage ../development/compilers/ocaml/ber-metaocaml.nix { };

  ocaml_make = callPackage ../development/ocaml-modules/ocamlmake { };

  opa = callPackage ../development/compilers/opa {
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  opam = callPackage ../development/tools/ocaml/opam { };
  opam_1_2 = callPackage ../development/tools/ocaml/opam/1.2.2.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  picat = callPackage ../development/compilers/picat {
    stdenv = overrideCC stdenv gcc49;
  };

  ponyc = callPackage ../development/compilers/ponyc {
    llvm = llvm_39;
  };

  pony-stable = callPackage ../development/compilers/ponyc/pony-stable.nix { };

  rtags = callPackage ../development/tools/rtags {
    inherit (darwin) apple_sdk;
  };

  # For beta and nightly releases use the nixpkgs-mozilla overlay
  rust = callPackage ../development/compilers/rust ({
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  } // stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
    stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  });
  inherit (rust) cargo rustc;

  buildRustCrate = callPackage ../build-support/rust/build-rust-crate { };
  buildRustCrateHelpers = callPackage ../build-support/rust/build-rust-crate/helpers.nix { };
  buildRustCrateTests = recurseIntoAttrs (callPackage ../build-support/rust/build-rust-crate/test { }).tests;
  cratesIO = callPackage ../build-support/rust/crates-io.nix { };
  cargo-web = callPackage ../development/tools/cargo-web {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  carnix = (callPackage ../build-support/rust/carnix.nix { }).carnix { };

  defaultCrateOverrides = callPackage ../build-support/rust/default-crate-overrides.nix { };

  rustPlatform = recurseIntoAttrs (makeRustPlatform rust);

  makeRustPlatform = rust: lib.fix (self:
    let
      callPackage = newScope self;
    in {
      inherit rust;

      buildRustPackage = callPackage ../build-support/rust {
        inherit rust;
      };

      rustcSrc = callPackage ../development/compilers/rust/rust-src.nix {
        inherit (rust) rustc;
      };
    });

  cargo-asm = callPackage ../development/tools/rust/cargo-asm {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  rustracer = callPackage ../development/tools/rust/racer { };
  rustracerd = callPackage ../development/tools/rust/racerd { };
  rust-bindgen = callPackage ../development/tools/rust/bindgen { };
  rust-cbindgen = callPackage ../development/tools/rust/cbindgen {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  rustup = callPackage ../development/tools/rust/rustup {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  sbclBootstrap = callPackage ../development/compilers/sbcl/bootstrap.nix {};
  sbcl = callPackage ../development/compilers/sbcl {};

  scala_2_10 = callPackage ../development/compilers/scala/2.10.nix { };
  scala_2_11 = callPackage ../development/compilers/scala/2.11.nix { };
  scala_2_12 = callPackage ../development/compilers/scala { jre = jre8; };
  scala = scala_2_12;

  sdcc = callPackage ../development/compilers/sdcc {
    gputils = null;
  };

  smlnjBootstrap = callPackage ../development/compilers/smlnj/bootstrap.nix { };
  smlnj = if stdenv.isDarwin
            then callPackage ../development/compilers/smlnj { }
            else pkgsi686Linux.callPackage ../development/compilers/smlnj { };

  sqldeveloper = callPackage ../development/tools/database/sqldeveloper { };

  # sqldeveloper_18 needs JavaFX, which currently only is available inside the
  # (non-free and net yet packaged for Darwin) OracleJDK
  # we might be able to get rid of it, as soon as we have an OpenJDK with OpenJFX included
  sqldeveloper_18 = callPackage ../development/tools/database/sqldeveloper/18.2.nix {
    jdk = oraclejdk;
  };

  squirrel-sql = callPackage ../development/tools/database/squirrel-sql {
    drivers = [ mysql_jdbc postgresql_jdbc ];
  };

  metaBuildEnv = callPackage ../development/compilers/meta-environment/meta-build-env { };

  swift = callPackage ../development/compilers/swift { };

  swiProlog = callPackage ../development/compilers/swi-prolog { };

  terra = callPackage ../development/compilers/terra {
    llvmPackages = llvmPackages_38 // {
      llvm = llvmPackages_38.llvm.override { enableSharedLibraries = false; };
    };
    lua = lua5_1;
  };

  teyjus = callPackage ../development/compilers/teyjus {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
    omake = omake_rc1;
  };

  thrust = callPackage ../development/tools/thrust {
    gconf = pkgs.gnome2.GConf;
  };

  inherit (ocaml-ng.ocamlPackages_4_02) trv;

  urn = callPackage ../development/compilers/urn { };

  inherit (callPackage ../development/compilers/vala { })
    vala_0_34
    vala_0_36
    vala_0_38
    vala_0_40
    vala;

  wrapCCWith =
    { cc
    , # This should be the only bintools runtime dep with this sort of logic. The
      # Others should instead delegate to the next stage's choice with
      # `targetPackages.stdenv.cc.bintools`. This one is different just to
      # provide the default choice, avoiding infinite recursion.
      bintools ? if stdenv.targetPlatform.isDarwin then darwin.binutils else binutils
    , libc ? bintools.libc
    , ...
    } @ extraArgs:
      callPackage ../build-support/cc-wrapper (let self = {
    nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    noLibc = !self.nativeLibc && (self.libc == null);

    isGNU = cc.isGNU or false;
    isClang = cc.isClang or false;

    inherit cc bintools libc;
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
  } // extraArgs; in self);

  # prolog
  yap = callPackage ../development/compilers/yap { };

  yosys = callPackage ../development/compilers/yosys { };

  zulu8 = callPackage ../development/compilers/zulu/8.nix { };
  zulu = callPackage ../development/compilers/zulu { };

  ### DEVELOPMENT / INTERPRETERS

  angelscript = callPackage ../development/interpreters/angelscript {};

  angelscript_2_22 = callPackage ../development/interpreters/angelscript/2.22.nix {};

  clips = callPackage ../development/interpreters/clips { };

  clisp = callPackage ../development/interpreters/clisp { };
  clisp-tip = callPackage ../development/interpreters/clisp/hg.nix { };

  clojure = callPackage ../development/interpreters/clojure { };

  clooj = callPackage ../development/interpreters/clojure/clooj.nix { };

  dhall = callPackage ../development/interpreters/dhall { };

  dhall-nix = haskell.lib.justStaticExecutables haskellPackages.dhall-nix;

  dhall-bash = haskell.lib.justStaticExecutables haskellPackages.dhall-bash;

  dhall-json = haskell.lib.justStaticExecutables haskellPackages.dhall-json;

  dhall-text = haskell.lib.justStaticExecutables haskellPackages.dhall-text;

  dhallPackages = import ../development/dhall-modules { inherit pkgs; };

  beam = callPackage ./beam-packages.nix { };

  inherit (beam.interpreters)
    erlang erlangR18 erlangR19 erlangR20 erlangR21
    erlang_odbc erlang_javac erlang_odbc_javac erlang_nox erlang_basho_R16B02
    elixir elixir_1_7 elixir_1_6 elixir_1_5 elixir_1_4 elixir_1_3
    lfe lfe_1_2;

  inherit (beam.packages.erlang)
    rebar rebar3-open rebar3
    hexRegistrySnapshot fetchHex beamPackages
    hex2nix;

  inherit (beam.packages.erlangR18) relxExe;
  inherit (beam.packages.erlangR19) cuter;

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  # Needed for autogen
  guile_2_0 = callPackage ../development/interpreters/guile/2.0.nix { };

  guile_2_2 = callPackage ../development/interpreters/guile { };

  guile = guile_2_2;

  inherit (callPackages ../applications/networking/cluster/hadoop { })
    hadoop_2_7
    hadoop_2_8
    hadoop_2_9
    hadoop_3_0
    hadoop_3_1;
  hadoop = hadoop_2_7;

  io = callPackage ../development/interpreters/io { };

  j = callPackage ../development/interpreters/j {};

  lumo = callPackage ../development/interpreters/clojurescript/lumo {
    nodejs = nodejs-10_x;
  };

  lxappearance = callPackage ../desktops/lxde/core/lxappearance {
    gtk2 = gtk2-x11;
  };

  lxappearance-gtk3 = lxappearance.override {
    withGtk3 = true;
  };

  lxmenu-data = callPackage ../desktops/lxde/core/lxmenu-data.nix { };

  lxpanel = callPackage ../desktops/lxde/core/lxpanel {
    gtk2 = gtk2-x11;
  };

  kona = callPackage ../development/interpreters/kona {};

  love_0_7 = callPackage ../development/interpreters/love/0.7.nix { lua=lua5_1; };
  love_0_8 = callPackage ../development/interpreters/love/0.8.nix { lua=lua5_1; };
  love_0_9 = callPackage ../development/interpreters/love/0.9.nix { };
  love_0_10 = callPackage ../development/interpreters/love/0.10.nix { };
  love_11 = callPackage ../development/interpreters/love/11.1.nix { };
  love = love_0_10;

  ### LUA MODULES

  lua5_1 = callPackage ../development/interpreters/lua-5/5.1.nix { };
  lua5_2 = callPackage ../development/interpreters/lua-5/5.2.nix { };
  lua5_2_compat = callPackage ../development/interpreters/lua-5/5.2.nix {
    compat = true;
  };
  lua5_3 = callPackage ../development/interpreters/lua-5/5.3.nix { };
  lua5_3_compat = callPackage ../development/interpreters/lua-5/5.3.nix {
    compat = true;
  };
  lua5 = lua5_2_compat;
  lua = lua5;

  lua51Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_1; });
  lua52Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_2; });
  lua53Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_3; });
  luajitPackages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = luajit; });

  luaPackages = lua52Packages;

  inherit (callPackages ../development/interpreters/luajit {})
    luajit luajit_2_0 luajit_2_1;

  luarocks = luaPackages.luarocks;

  toluapp = callPackage ../development/tools/toluapp {
    lua = lua5_1; # doesn't work with any other :(
  };

  ### END OF LUA

  lush2 = callPackage ../development/interpreters/lush {};

  maude = callPackage ../development/interpreters/maude { };

  mesos = callPackage ../applications/networking/cluster/mesos {
    sasl = cyrus_sasl;
    inherit (pythonPackages) python boto setuptools wrapPython;
    pythonProtobuf = pythonPackages.protobuf;
    perf = linuxPackages.perf;
  };

  nix-exec = callPackage ../development/interpreters/nix-exec {
    git = gitMinimal;
  };

  inherit (
    let
      defaultOctaveOptions = {
        qt = null;
        ghostscript = null;
        graphicsmagick = null;
        llvm = null;
        hdf5 = null;
        glpk = null;
        suitesparse = null;
        jdk = null;
        openblas = if stdenv.isDarwin then openblasCompat else openblas;
      };

      hgOctaveOptions =
        (removeAttrs defaultOctaveOptions ["ghostscript"]) // {
          overridePlatforms = stdenv.lib.platforms.none;
        };
    in {
      octave = callPackage ../development/interpreters/octave defaultOctaveOptions;
      octaveHg = lowPrio (callPackage ../development/interpreters/octave/hg.nix hgOctaveOptions);
  }) octave octaveHg;

  octaveFull = (lowPrio (octave.override {
    qt = qt4;
    overridePlatforms = ["x86_64-linux" "x86_64-darwin"];
    openblas = if stdenv.isDarwin then openblasCompat else openblas;
  }));

  inherit (callPackages ../development/interpreters/perl {}) perl526 perl528 perldevel;

  php = php72;
  phpPackages = php72Packages;

  php71Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php71;
  });

  php72Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php72;
  });


  inherit (callPackages ../development/interpreters/php { })
    php71
    php72;

  php-embed = php72-embed;

  php71-embed = php71.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  php72-embed = php72.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  picoc = callPackage ../development/interpreters/picoc {};

  polyml = callPackage ../development/compilers/polyml { };
  polyml56 = callPackage ../development/compilers/polyml/5.6.nix { };

  pure = callPackage ../development/interpreters/pure {
    llvm = llvm_35;
  };
  purePackages = recurseIntoAttrs (callPackage ./pure-packages.nix {});

  # Python interpreters. All standard library modules are included except for tkinter, which is
  # available as `pythonPackages.tkinter` and can be used as any other Python package.
  # When switching these sets, please update docs at ../../doc/languages-frameworks/python.md
  python = python2;
  python2 = python27;
  python3 = python36;
  pypy = pypy27;

  # Python interpreter that is build with all modules, including tkinter.
  # These are for compatibility and should not be used inside Nixpkgs.
  pythonFull = python.override{x11Support=true;};
  python2Full = python2.override{x11Support=true;};
  python27Full = python27.override{x11Support=true;};
  python3Full = python3.override{x11Support=true;};
  python35Full = python35.override{x11Support=true;};
  python36Full = python36.override{x11Support=true;};
  python37Full = python37.override{x11Support=true;};

  # pythonPackages further below, but assigned here because they need to be in sync
  pythonPackages = python.pkgs;
  python2Packages = python2.pkgs;
  python3Packages = python3.pkgs;

  python27 = callPackage ../development/interpreters/python/cpython/2.7 {
    self = python27;
    inherit (darwin) CF configd;
  };
  python35 = callPackage ../development/interpreters/python/cpython/3.5 {
    inherit (darwin) CF configd;
    self = python35;
  };
  python36 = callPackage ../development/interpreters/python/cpython/3.6 {
    inherit (darwin) CF configd;
    self = python36;
  };
  python37 = callPackage ../development/interpreters/python/cpython/3.7 {
    inherit (darwin) CF configd;
    self = python37;
  };

  pypy27 = callPackage ../development/interpreters/python/pypy/2.7 {
    self = pypy27;
    python = python27.override{x11Support=true;};
    db = db.override { dbmSupport = true; };
  };

  # Python package sets.
  python27Packages = lib.hiPrioSet (recurseIntoAttrs python27.pkgs);
  python35Packages = python35.pkgs;
  python36Packages = recurseIntoAttrs python36.pkgs;
  python37Packages = python37.pkgs;
  pypyPackages = pypy.pkgs;

  # Should eventually be moved inside Python interpreters.
  python-setup-hook = callPackage ../development/interpreters/python/setup-hook.nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/cpython/docs {});

  pypi2nix = callPackage ../development/tools/pypi2nix {
    pythonPackages = python3Packages;
  };

  setupcfg2nix = python3Packages.callPackage ../development/tools/setupcfg2nix {};

  # These pyside tools do not provide any Python modules and are meant to be here.
  # See ../development/python-modules/pyside/default.nix for details.
  pysideApiextractor = callPackage ../development/python-modules/pyside/apiextractor.nix { };
  pysideGeneratorrunner = callPackage ../development/python-modules/pyside/generatorrunner.nix { };

  svg2tikz = python27Packages.svg2tikz;

  pew = callPackage ../development/tools/pew {};
  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  racket = callPackage ../development/interpreters/racket {
    # racket 6.11 doesn't build with gcc6 + recent glibc:
    # https://github.com/racket/racket/pull/1886
    # https://github.com/NixOS/nixpkgs/pull/31017#issuecomment-343574769
    stdenv = if stdenv.isDarwin then stdenv else gcc7Stdenv;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };
  racket-minimal = callPackage ../development/interpreters/racket/minimal.nix { };

  rakudo = callPackage ../development/interpreters/rakudo {
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  red = callPackage ../development/interpreters/red { };

  inherit (ocamlPackages) reason;

  renpy = callPackage ../development/interpreters/renpy {
    ffmpeg = ffmpeg_2;
  };

  pixie = callPackage ../development/interpreters/pixie { };
  dust = callPackage ../development/interpreters/pixie/dust.nix { };

  buildRubyGem = callPackage ../development/ruby-modules/gem { };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config { };
  bundler = callPackage ../development/ruby-modules/bundler { };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };
  bundlerApp = callPackage ../development/ruby-modules/bundler-app { };

  inherit (callPackage ../development/interpreters/ruby {
    inherit (darwin) libiconv libobjc libunwind;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  })
    ruby_2_3
    ruby_2_4
    ruby_2_5;

  ruby = ruby_2_5;

  self = pkgsi686Linux.callPackage ../development/interpreters/self { };

  spark = spark_22;
  spark_22 = callPackage ../applications/networking/cluster/spark { version = "2.2.1"; };

  spidermonkey_1_8_5 = callPackage ../development/interpreters/spidermonkey/1.8.5.nix { };
  spidermonkey_17 = callPackage ../development/interpreters/spidermonkey/17.nix {
    inherit (darwin) libobjc;
    stdenv = gccStdenv;
  };
  spidermonkey_31 = callPackage ../development/interpreters/spidermonkey/31.nix { };
  spidermonkey_38 = callPackage ../development/interpreters/spidermonkey/38.nix ({
    inherit (darwin) libobjc;
  } // (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
  }));
  spidermonkey_52 = callPackage ../development/interpreters/spidermonkey/52.nix { };
  spidermonkey = spidermonkey_31;

  supercollider = libsForQt5.callPackage ../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };

  ### DEVELOPMENT / MISC

  amdadlsdk = callPackage ../development/misc/amdadl-sdk { };

  amdappsdk26 = amdappsdk.override {
    version = "2.6";
  };

  amdappsdk27 = amdappsdk.override {
    version = "2.7";
  };

  amdappsdk28 = amdappsdk.override {
    version = "2.8";
  };

  amdappsdk = callPackage ../development/misc/amdapp-sdk { };

  amdappsdkFull = amdappsdk.override {
    samples = true;
  };

  avrlibc      = callPackage ../development/misc/avr/libc {};
  avrlibcCross = callPackage ../development/misc/avr/libc {
    stdenv = crossLibcStdenv;
  };

  avr8burnomat = callPackage ../development/misc/avr8-burn-omat { };

  betaflight = callPackage ../development/misc/stm32/betaflight {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  sourceFromHead = callPackage ../build-support/source-from-head-fun.nix {};

  guile-gnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome2.GConf;
    guile = guile_2_0;
    inherit (gnome2) gnome_vfs libglade libgnome libgnomecanvas libgnomeui;
  };

  guile-lib = callPackage ../development/guile-modules/guile-lib {
    guile = guile_2_0;
  };

  guile-sdl = callPackage ../development/guile-modules/guile-sdl { };

  guile-xcb = callPackage ../development/guile-modules/guile-xcb {
    guile = guile_2_0;
  };

  inav = callPackage ../development/misc/stm32/inav {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  pharo-vms = callPackage ../development/pharo/vm { };
  pharo = pharo-vms.multi-vm-wrapper;
  pharo-cog32 = pharo-vms.cog32;
  pharo-spur32 = pharo-vms.spur32;
  pharo-spur64 = assert stdenv.is64bit; pharo-vms.spur64;
  pharo-launcher = callPackage ../development/pharo/launcher { };

  ### DEVELOPMENT / TOOLS

  activator = throw ''
    Typesafe Activator was removed in 2017-05-08 as the actual package reaches end of life.

    See https://github.com/NixOS/nixpkgs/pull/25616
    and http://www.lightbend.com/community/core-tools/activator-and-sbt
    for more information.
  '';

  inherit (callPackage ../development/tools/alloy { })
    alloy4
    alloy5
    alloy;

  inherit (callPackages ../tools/admin/ansible {})
    ansible_2_4
    ansible_2_5
    ansible_2_6
    ansible_2_7
    ansible2
    ansible;

  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3_4 = callPackage ../development/tools/parsing/antlr/3.4.nix { };
  antlr3_5 = callPackage ../development/tools/parsing/antlr/3.5.nix { };
  antlr3 = antlr3_5;

  antlr4_7 = callPackage ../development/tools/parsing/antlr/4.7.nix { };
  antlr4 = antlr4_7;

  apacheAnt = callPackage ../development/tools/build-managers/apache-ant { };
  apacheAnt_1_9 = callPackage ../development/tools/build-managers/apache-ant/1.9.nix { };
  ant = apacheAnt;

  apacheKafka = apacheKafka_2_0;
  apacheKafka_0_9 = callPackage ../servers/apache-kafka { majorVersion = "0.9"; };
  apacheKafka_0_10 = callPackage ../servers/apache-kafka { majorVersion = "0.10"; };
  apacheKafka_0_11 = callPackage ../servers/apache-kafka { majorVersion = "0.11"; };
  apacheKafka_1_0 = callPackage ../servers/apache-kafka { majorVersion = "1.0"; };
  apacheKafka_1_1 = callPackage ../servers/apache-kafka { majorVersion = "1.1"; };
  apacheKafka_2_0 = callPackage ../servers/apache-kafka { majorVersion = "2.0"; };

  kt = callPackage ../tools/misc/kt {};

  asn2quickder = python2Packages.callPackage ../development/tools/asn2quickder {};

  awf = callPackage ../development/tools/misc/awf { };

  electron = callPackage ../development/tools/electron { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };
  autoconf264 = callPackage ../development/tools/misc/autoconf/2.64.nix { };

  autocutsel = callPackage ../tools/X11/autocutsel{ };

  automake = automake116x;

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake116x = callPackage ../development/tools/misc/automake/automake-1.16.x.nix { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  avarice = callPackage ../development/tools/misc/avarice {
    gcc = gcc49;
  };

  bam = callPackage ../development/tools/build-managers/bam {};

  bazel_0_4 = callPackage ../development/tools/build-managers/bazel/0.4.nix { };
  bazel = callPackage ../development/tools/build-managers/bazel {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
  };
  bazel_jdk11 = callPackage ../development/tools/build-managers/bazel {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    runJdk = jdk11;
  };

  bazel-buildtools = callPackage ../development/tools/build-managers/bazel/buildtools { };
  buildifier = bazel-buildtools;
  buildozer = bazel-buildtools;
  unused_deps = bazel-buildtools;

  bazel-deps = callPackage ../development/tools/build-managers/bazel/bazel-deps {
    buildBazelPackage = buildBazelPackage.override { enableNixHacks = false; };
  };

  buildBazelPackage = callPackage ../build-support/build-bazel-package { };

  bear = callPackage ../development/tools/build-managers/bear { };

  binutils-unwrapped = callPackage ../development/tools/misc/binutils {
    # FHS sys dirs presumably only have stuff for the build platform
    noSysDirs = (stdenv.targetPlatform != stdenv.hostPlatform) || noSysDirs;
  };
  binutils = wrapBintoolsWith {
    bintools = binutils-unwrapped;
  };
  binutils_nogold = lowPrio (wrapBintoolsWith {
    bintools = binutils-unwrapped.override {
      gold = false;
    };
  });

  bison2 = callPackage ../development/tools/parsing/bison/2.x.nix { };
  bison3 = callPackage ../development/tools/parsing/bison/3.x.nix { };
  bison = bison3;
  yacc = bison; # TODO: move to aliases.nix

  blackmagic = callPackage ../development/tools/misc/blackmagic {
    stdenv = overrideCC stdenv gcc6;
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  bossa = callPackage ../development/tools/misc/bossa {
    wxGTK = wxGTK30;
  };

  buck = callPackage ../development/tools/build-managers/buck { };

  buildkite-agent = buildkite-agent2;
  buildkite-agent2 = callPackage ../development/tools/continuous-integration/buildkite-agent/2.x.nix { };
  buildkite-agent3 = callPackage ../development/tools/continuous-integration/buildkite-agent/3.x.nix { };

  casperjs = callPackage ../development/tools/casperjs {
    inherit (texFunctions) fontsConf;
  };

  ccache = callPackage ../development/tools/misc/ccache { };

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
  ccacheWrapper = makeOverridable ({ extraConfig ? "" }:
     wrapCC (ccache.links extraConfig)) {};
  ccacheStdenv = lowPrio (overrideCC stdenv ccacheWrapper);

  chromedriver = callPackage ../development/tools/selenium/chromedriver { gconf = gnome2.GConf; };

  chruby = callPackage ../development/tools/misc/chruby { rubies = null; };

  cookiecutter = pythonPackages.cookiecutter;

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = callPackage ../development/tools/misc/ctags/wrapped.nix {};

  cmake_2_8 = callPackage ../development/tools/build-managers/cmake/2.8.nix { };

  cmake = libsForQt5.callPackage ../development/tools/build-managers/cmake { };

  cmakeCurses = cmake.override { useNcurses = true; };

  cmakeWithGui = cmakeCurses.override { withQt5 = true; };
  cmakeWithQt4Gui = cmakeCurses.override { useQt4 = true; };

  # Does not actually depend on Qt 5
  inherit (kdeFrameworks) extra-cmake-modules kapidox kdoctools;

  coccinelle = callPackage ../development/tools/misc/coccinelle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  cquery = callPackage ../development/tools/misc/cquery {
    llvmPackages = llvmPackages_7;
  };

  creduce = callPackage ../development/tools/misc/creduce {
    inherit (perlPackages) perl
      ExporterLite FileWhich GetoptTabular RegexpCommon TermReadKey;
    inherit (llvmPackages_6) llvm clang-unwrapped;
  };

  csmith = callPackage ../development/tools/misc/csmith {
    inherit (perlPackages) perl SysCPU;
  };

  libcxx = llvmPackages.libcxx;
  libcxxabi = llvmPackages.libcxxabi;

  libstdcxx5 = callPackage ../development/libraries/gcc/libstdc++/5.nix { };

  libsigrok = callPackage ../development/tools/libsigrok { };
  # old version:
  libsigrok-0-3-0 = libsigrok.override {
    version = "0.3.0";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };

  dfeet = callPackage ../development/tools/misc/d-feet { };

  dfu-util = callPackage ../development/tools/misc/dfu-util { };

  distcc = callPackage ../development/tools/misc/distcc { };

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
  distccStdenv = lowPrio (overrideCC stdenv distccWrapper);

  distccMasquerade = if stdenv.isDarwin
    then null
    else callPackage ../development/tools/misc/distcc/masq.nix {
      gccRaw = gcc.cc;
      binutils = binutils;
    };

  docutils = pythonPackages.docutils;

  doit = callPackage ../development/tools/build-managers/doit { };

  dot2tex = pythonPackages.dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt4 = null;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  doxygen_gui = lowPrio (doxygen.override { inherit qt4; });

  drip = callPackage ../development/tools/drip { };

  egypt = callPackage ../development/tools/analysis/egypt { };

  emma = callPackage ../development/tools/analysis/emma { };

  epm = callPackage ../development/tools/misc/epm { };

  eweb = callPackage ../development/tools/literate-programming/eweb { };

  eztrace = callPackage ../development/tools/profiling/EZTrace { };

  flow = callPackage ../development/tools/analysis/flow {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    inherit (darwin) cf-private;
  };

  framac = callPackage ../development/tools/analysis/frama-c { };

  frame = callPackage ../development/libraries/frame { };

  gede = libsForQt59.callPackage ../development/tools/misc/gede { };

  flex_2_5_35 = callPackage ../development/tools/parsing/flex/2.5.35.nix { };
  flex = callPackage ../development/tools/parsing/flex { };

  flexcpp = callPackage ../development/tools/parsing/flexc++ { };

  geis = callPackage ../development/libraries/geis {
    inherit (xorg) libX11 libXext libXi libXtst;
  };

  global = callPackage ../development/tools/misc/global { };

  gnome-doc-utils = callPackage ../development/tools/documentation/gnome-doc-utils {};

  gnome-latex = callPackage ../applications/editors/gnome-latex/default.nix { };

  gnum4 = callPackage ../development/tools/misc/gnum4 { };
  m4 = gnum4;

  gnumake42 = callPackage ../development/tools/build-managers/gnumake/4.2 { };
  gnumake = gnumake42;

  gnustep = recurseIntoAttrs (callPackage ../desktops/gnustep {});

  gputils = callPackage ../development/tools/misc/gputils { };

  gradleGen = callPackage ../development/tools/build-managers/gradle { };
  gradle = self.gradleGen.gradle_latest;
  gradle_2_14 = self.gradleGen.gradle_2_14;
  gradle_2_5 = self.gradleGen.gradle_2_5;
  gradle_3_5 = self.gradleGen.gradle_3_5;

  gperf = callPackage ../development/tools/misc/gperf { };
  # 3.1 changed some parameters from int to size_t, leading to mismatches.
  gperf_3_0 = callPackage ../development/tools/misc/gperf/3.0.x.nix { };

  grail = callPackage ../development/libraries/grail { };

  gtk-doc = callPackage ../development/tools/documentation/gtk-doc { };

  guile-lint = callPackage ../development/tools/guile/guile-lint {
    guile = guile_1_8;
  };

  gwrap = callPackage ../development/tools/guile/g-wrap {
    guile = guile_2_0;
  };

  help2man = callPackage ../development/tools/misc/help2man {
    inherit (perlPackages) LocaleGettext;
  };

  heroku = callPackage ../development/tools/heroku {
    nodejs = nodejs-10_x;
  };

  iaca_2_1 = callPackage ../development/tools/iaca/2.1.nix { };
  iaca_3_0 = callPackage ../development/tools/iaca/3.0.nix { };
  iaca = iaca_3_0;

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils {
    inherit (perlPackages) XMLSimple;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_6;
  };

  indent = callPackage ../development/tools/misc/indent { };

  ino = callPackage ../development/arduino/ino { };

  ired = callPackage ../development/tools/analysis/radare/ired.nix { };

  jam = callPackage ../development/tools/build-managers/jam { };

  jenkins = callPackage ../development/tools/continuous-integration/jenkins { };

  jenkins-job-builder = pythonPackages.jenkins-job-builder;

  kati = callPackage ../development/tools/build-managers/kati { };

  kconfig-frontends = callPackage ../development/tools/misc/kconfig-frontends {
    gperf = gperf_3_0;
  };

  kind = callPackage ../development/tools/kind {  };

  lcov = callPackage ../development/tools/analysis/lcov { };

  lemon = callPackage ../development/tools/parsing/lemon { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  lit = callPackage ../development/tools/misc/lit { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  massif-visualizer = libsForQt5.callPackage ../development/tools/analysis/massif-visualizer { };

  maven = maven3;
  maven3 = callPackage ../development/tools/build-managers/apache-maven { };

  go-md2man = callPackage ../development/tools/misc/md2man {};

  mage = callPackage ../development/tools/build-managers/mage { };

  mk = callPackage ../development/tools/build-managers/mk { };

  haskell-ci = haskell.lib.justStaticExecutables haskellPackages.haskell-ci;

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
    fontsConf = makeFontsConf {
      fontDirectories = [
        dejavu_fonts.minimal
      ];
    };
  };

  gn = callPackage ../development/tools/build-managers/gn { };

  nixbang = callPackage ../development/tools/misc/nixbang {
    pythonPackages = python3Packages;
  };

  nwjs = callPackage ../development/tools/nwjs {
    gconf = pkgs.gnome2.GConf;
  };

  nwjs-sdk = callPackage ../development/tools/nwjs {
    gconf = pkgs.gnome2.GConf;
    sdk = true;
  };

  # only kept for nixui, see https://github.com/matejc/nixui/issues/27
  nwjs_0_12 = callPackage ../development/tools/node-webkit/nw12.nix {
    gconf = pkgs.gnome2.GConf;
  };

  nuweb = callPackage ../development/tools/literate-programming/nuweb { tex = texlive.combined.scheme-small; };

  obuild = callPackage ../development/tools/ocaml/obuild { };

  omake = callPackage ../development/tools/ocaml/omake { };

  inherit (ocamlPackages) omake_rc1;

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = lowPrio (callPackage ../development/tools/misc/patchelf/unstable.nix { });

  peg = callPackage ../development/tools/parsing/peg { };

  phantomjs = callPackage ../development/tools/phantomjs { };

  phantomjs2 = libsForQt5.callPackage ../development/tools/phantomjs2 { };

  pkgconfig = callPackage ../development/tools/misc/pkgconfig {
    fetchurl = fetchurlBoot;
  };
  pkgconfigUpstream = lowPrio (pkgconfig.override { vanilla = true; });

  pyprof2calltree = pythonPackages.callPackage ../development/tools/profiling/pyprof2calltree { };

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake5 = callPackage ../development/tools/misc/premake/5.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  premake = premake4;

  pup = callPackage ../development/tools/pup { };

  qtcreator = libsForQt5.callPackage ../development/tools/qtcreator { };

  radare = callPackage ../development/tools/analysis/radare {
    inherit (gnome2) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };

  inherit (callPackages ../development/tools/analysis/radare2 {
    inherit (gnome2) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  }) radare2 r2-for-cutter;

  radare2-cutter = libsForQt5.callPackage ../development/tools/analysis/radare2/cutter.nix { };

  ragel = ragelStable;

  inherit (callPackages ../development/tools/parsing/ragel {
      tex = texlive.combined.scheme-small;
    }) ragelStable ragelDev;

  hammer = callPackage ../development/tools/parsing/hammer { };

  redo = callPackage ../development/tools/build-managers/redo { };

  reno = callPackage ../development/tools/reno { };

  remake = callPackage ../development/tools/build-managers/remake { };

  retdec = callPackage ../development/tools/analysis/retdec { };
  retdec-full = retdec.override {
    withPEPatterns = true;
  };

  rman = callPackage ../development/tools/misc/rman { };

  rr = callPackage ../development/tools/analysis/rr { };

  selenium-server-standalone = callPackage ../development/tools/selenium/server { };

  sconsPackages = callPackage ../development/tools/build-managers/scons { };
  scons = sconsPackages.scons_3_0_1;
  scons_2_5_1 = sconsPackages.scons_2_5_1;

  sbt = callPackage ../development/tools/build-managers/sbt { };
  sbt-with-scala-native = callPackage ../development/tools/build-managers/sbt/scala-native.nix { };
  simpleBuildTool = sbt;

  shellcheck = haskell.lib.justStaticExecutables haskellPackages.ShellCheck;

  simpleTpmPk11 = callPackage ../tools/security/simple-tpm-pk11 { };

  sloc = nodePackages.sloc;

  smatch = callPackage ../development/tools/analysis/smatch {
    buildllvmsparse = false;
    buildc2xml = false;
  };

  smc = callPackage ../tools/misc/smc { };

  snakemake = callPackage ../applications/science/misc/snakemake { python = python3Packages; };

  snowman = qt5.callPackage ../development/tools/analysis/snowman { };

  sparse = callPackage ../development/tools/analysis/sparse { };

  speedtest-cli = with python3Packages; toPythonApplication speedtest-cli;

  spin = callPackage ../development/tools/analysis/spin { };

  splint = callPackage ../development/tools/analysis/splint {
    flex = flex_2_5_35;
  };

  spoofer = callPackage ../tools/networking/spoofer { };

  spoofer-gui = callPackage ../tools/networking/spoofer { withGUI = true; };

  sqlitebrowser = libsForQt5.callPackage ../development/tools/database/sqlitebrowser { };

  sselp = callPackage ../tools/X11/sselp{ };

  strace = callPackage ../development/tools/misc/strace { };

  swig1 = callPackage ../development/tools/misc/swig { };
  swig2 = callPackage ../development/tools/misc/swig/2.x.nix { };
  swig3 = callPackage ../development/tools/misc/swig/3.x.nix { };
  swig = swig3;
  swigWithJava = swig;

  swftools = callPackage ../tools/video/swftools {
    stdenv = gccStdenv;
  };

  teensyduino = arduino-core.override { withGui = true; withTeensyduino = true; };

  texinfo413 = callPackage ../development/tools/misc/texinfo/4.13a.nix { };
  texinfo4 = texinfo413;
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.2.nix { };
  texinfo6 = callPackage ../development/tools/misc/texinfo/6.5.nix { };
  texinfo = texinfo6;
  texinfoInteractive = appendToName "interactive" (
    texinfo.override { interactive = true; }
  );

  tweak = callPackage ../applications/editors/tweak { };

  uhd = callPackage ../development/tools/misc/uhd { };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
  };

  valgrind = callPackage ../development/tools/analysis/valgrind {
    inherit (darwin) xnu bootstrap_cmds cctools;
  };
  valgrind-light = self.valgrind.override { gdb = null; };

  qcachegrind = libsForQt5.callPackage ../development/tools/analysis/qcachegrind {};

  vulnix = callPackage ../tools/security/vulnix {
    pythonPackages = python3Packages;
  };

  xcodebuild = callPackage ../development/tools/xcbuild/wrapper.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreGraphics ImageIO;
  };
  xcbuild = xcodebuild;
  xcbuildHook = makeSetupHook {
    deps = [ xcbuild ];
  } ../development/tools/xcbuild/setup-hook.sh  ;

  xxdiff = callPackage ../development/tools/misc/xxdiff {
    bison = bison2;
  };
  xxdiff-tip = libsForQt5.callPackage ../development/tools/misc/xxdiff/tip.nix { };

  ycmd = callPackage ../development/tools/misc/ycmd {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    python = python2;
  };

  yq = callPackage ../development/tools/yq {
    inherit (python3Packages) buildPythonApplication fetchPypi pyyaml xmltodict;
  };

  mypy = with python3Packages; toPythonApplication mypy;

  ### DEVELOPMENT / LIBRARIES

  acl = callPackage ../development/libraries/acl { };

  activemq = callPackage ../development/libraries/apache-activemq { };

  agg = callPackage ../development/libraries/agg { };

  allegro = allegro4;
  allegro4 = callPackage ../development/libraries/allegro {};
  allegro5 = callPackage ../development/libraries/allegro/5.nix {};

  amrwb = callPackage ../development/libraries/amrwb { };

  anttweakbar = callPackage ../development/libraries/AntTweakBar { };

  appstream = callPackage ../development/libraries/appstream { };

  appstream-qt = libsForQt5.callPackage ../development/libraries/appstream/qt.nix { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    bdbSupport = true;
    db = if stdenv.isFreeBSD then db4 else db;
    # XXX: only the db_185 interface was available through
    #      apr with db58 on freebsd (nov 2015), for unknown reasons
  };

  arb = callPackage ../development/libraries/arb {};
  arb-git = callPackage ../development/libraries/arb/git.nix {};

  asio = asio_1_12;
  asio_1_10 = callPackage ../development/libraries/asio/1.10.nix { };
  asio_1_12 = callPackage ../development/libraries/asio/1.12.nix { };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (callPackages ../development/libraries/aspell/dictionaries.nix {});

  aspellWithDicts = callPackage ../development/libraries/aspell/aspell-with-dicts.nix {
    aspell = aspell.override { searchNixProfiles = false; };
  };

  attica = callPackage ../development/libraries/attica { };

  attr = callPackage ../development/libraries/attr { };

  aqbanking = callPackage ../development/libraries/aqbanking { };

  audiofile = callPackage ../development/libraries/audiofile {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreServices;
  };

  babl = callPackage ../development/libraries/babl { };

  bctoolbox = callPackage ../development/libraries/bctoolbox {
    mbedtls = mbedtls_1_3;
  };

  beignet = callPackage ../development/libraries/beignet {
    inherit (llvmPackages_39) llvm clang-unwrapped;
  };

  bicpl = callPackage ../development/libraries/science/biology/bicpl { };

  # TODO(@Ericson2314): Build bionic libc from source
  bionic = assert stdenv.hostPlatform.useAndroidPrebuilt;
    androidenv."androidndkPkgs_${stdenv.hostPlatform.ndkVer}".libraries;

  boehmgc = callPackage ../development/libraries/boehm-gc { };
  boehmgc_766 = callPackage ../development/libraries/boehm-gc/7.6.6.nix { };

  boost155 = callPackage ../development/libraries/boost/1.55.nix { };
  boost159 = callPackage ../development/libraries/boost/1.59.nix { };
  boost15x = boost159;
  boost160 = callPackage ../development/libraries/boost/1.60.nix { };
  boost162 = callPackage ../development/libraries/boost/1.62.nix { };
  boost163 = callPackage ../development/libraries/boost/1.63.nix { };
  boost164 = callPackage ../development/libraries/boost/1.64.nix { };
  boost165 = callPackage ../development/libraries/boost/1.65.nix { };
  boost166 = callPackage ../development/libraries/boost/1.66.nix { };
  boost167 = callPackage ../development/libraries/boost/1.67.nix { };
  boost168 = callPackage ../development/libraries/boost/1.68.nix { };
  boost16x = boost167;
  boost = boost16x;

  boost_process = callPackage ../development/libraries/boost-process { };

  botan = callPackage ../development/libraries/botan { };
  botan2 = callPackage ../development/libraries/botan/2.0.nix { };

  box2d = callPackage ../development/libraries/box2d { };

  bwidget = callPackage ../development/libraries/bwidget { };

  c-ares = callPackage ../development/libraries/c-ares {
    fetchurl = fetchurlBoot;
  };

  cachix = (haskell.lib.justStaticExecutables haskellPackages.cachix).overrideAttrs (drv: {
    meta = drv.meta // {
      hydraPlatforms = stdenv.lib.platforms.unix;
    };
  });

  cdo = callPackage ../development/libraries/cdo {
    stdenv = gccStdenv;
  };

  cimg = callPackage  ../development/libraries/cimg { };

  ccrtp = callPackage ../development/libraries/ccrtp { };

  ccrtp_1_8 = callPackage ../development/libraries/ccrtp/1.8.nix { };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  caf = callPackage ../development/libraries/caf {};

  cgal = callPackage ../development/libraries/CGAL {};

  check = callPackage ../development/libraries/check {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  cl = callPackage ../development/libraries/cl { };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix { };

  clucene_core_1 = callPackage ../development/libraries/clucene-core { };

  clucene_core = clucene_core_1;

  clutter = callPackage ../development/libraries/clutter { };

  clutter-gst = callPackage ../development/libraries/clutter-gst {
  };

  clutter-gtk = callPackage ../development/libraries/clutter-gtk { };

  confuse = callPackage ../development/libraries/confuse { };

  ctl = callPackage ../development/libraries/ctl { };

  uri = callPackage ../development/libraries/uri { };

  cre2 = callPackage ../development/libraries/cre2 { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  cutelyst = libsForQt5.callPackage ../development/libraries/cutelyst { };

  cyrus_sasl = callPackage ../development/libraries/cyrus-sasl {
    kerberos = if stdenv.isFreeBSD then libheimdal else kerberos;
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

  dbus = callPackage ../development/libraries/dbus { };
  dbus_cplusplus  = callPackage ../development/libraries/dbus-cplusplus { };
  dbus-glib       = callPackage ../development/libraries/dbus-glib { };
  dbus_java       = callPackage ../development/libraries/java/dbus-java { };

  dbus-sharp-1_0 = callPackage ../development/libraries/dbus-sharp/dbus-sharp-1.0.nix { };
  dbus-sharp-2_0 = callPackage ../development/libraries/dbus-sharp { };

  dbus-sharp-glib-1_0 = callPackage ../development/libraries/dbus-sharp-glib/dbus-sharp-glib-1.0.nix { };
  dbus-sharp-glib-2_0 = callPackage ../development/libraries/dbus-sharp-glib { };

  makeDBusConf = { suidHelper, serviceDirectories }:
    callPackage ../development/libraries/dbus/make-dbus-conf.nix {
      inherit suidHelper serviceDirectories;
    };

  dee = callPackage ../development/libraries/dee { };

  dillo = callPackage ../applications/networking/browsers/dillo {
    fltk = fltk13;
  };

  dlib = callPackage ../development/libraries/dlib { };

  # Multi-arch "drivers" which we want to build for i686.
  driversi686Linux = recurseIntoAttrs {
    inherit (pkgsi686Linux)
      mesa_drivers
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
      beignet
      glxinfo
      vdpauinfo;
  };

  dssi = callPackage ../development/libraries/dssi {};

  eigen = callPackage ../development/libraries/eigen {};
  eigen3_3 = callPackage ../development/libraries/eigen/3.3.nix {};

  eigen2 = callPackage ../development/libraries/eigen/2.0.nix {};

  vmmlib = callPackage ../development/libraries/vmmlib {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  enchant = callPackage ../development/libraries/enchant { };

  enchant2 = callPackage ../development/libraries/enchant/2.x.nix { };

  enet = callPackage ../development/libraries/enet { };

  esdl = callPackage ../development/libraries/esdl { };

  exiv2 = callPackage ../development/libraries/exiv2 { };

  expat = callPackage ../development/libraries/expat { };

  factor-lang = callPackage ../development/compilers/factor-lang {
    inherit (pkgs.gnome2) gtkglext;
  };

  far2l = callPackage ../applications/misc/far2l {
    stdenv = if stdenv.cc.isClang then llvmPackages_4.stdenv else stdenv;
  };

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
      gst-libav;
    inherit (pythonPackages) gst-python;
  };

  fcgi = callPackage ../development/libraries/fcgi { };

  fflas-ffpack = callPackage ../development/libraries/fflas-ffpack {
    # We need to use blas instead of openblas on darwin,
    # see https://github.com/NixOS/nixpkgs/pull/45013.
    blas = if stdenv.isDarwin then blas else openblas;
  };

  fflas-ffpack_1 = callPackage ../development/libraries/fflas-ffpack/1.nix {};
  linbox = callPackage ../development/libraries/linbox {
    # We need to use blas instead of openblas on darwin, see
    # https://github.com/NixOS/nixpkgs/pull/45013 and
    # https://github.com/NixOS/nixpkgs/pull/45015.
    blas = if stdenv.isDarwin then blas else openblas;
  };

  ffmpeg_0_10 = callPackage ../development/libraries/ffmpeg/0.10.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_1_2 = callPackage ../development/libraries/ffmpeg/1.2.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_2_8 = callPackage ../development/libraries/ffmpeg/2.8.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_3_4 = callPackage ../development/libraries/ffmpeg/3.4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };
  ffmpeg_4 = callPackage ../development/libraries/ffmpeg/4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };

  # Aliases
  ffmpeg_0 = ffmpeg_0_10;
  ffmpeg_1 = ffmpeg_1_2;
  ffmpeg_2 = ffmpeg_2_8;
  ffmpeg_3 = ffmpeg_3_4;
  ffmpeg = ffmpeg_3;

  ffmpeg-full = callPackage ../development/libraries/ffmpeg-full {
    # The following need to be fixed on Darwin
    frei0r = if stdenv.isDarwin then null else frei0r;
    game-music-emu = if stdenv.isDarwin then null else game-music-emu;
    libjack2 = if stdenv.isDarwin then null else libjack2;
    libmodplug = if stdenv.isDarwin then null else libmodplug;
    openal = if stdenv.isDarwin then null else openal;
    libpulseaudio = if stdenv.isDarwin then null else libpulseaudio;
    samba = if stdenv.isDarwin then null else samba;
    vid-stab = if stdenv.isDarwin then null else vid-stab;
    x265 = if stdenv.isDarwin then null else x265;
    xavs = if stdenv.isDarwin then null else xavs;
    inherit (darwin) CF;
    inherit (darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio AVFoundation MediaToolbox
      VideoDecodeAcceleration;
  };

  ffmpegthumbnailer = callPackage ../development/libraries/ffmpegthumbnailer {
    ffmpeg = ffmpeg_2;
  };

  ffms = callPackage ../development/libraries/ffms {
    ffmpeg = ffmpeg_2;
  };

  fftw = callPackage ../development/libraries/fftw { };
  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwFloat = fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = fftw.override { precision = "long-double"; };

  flann = callPackage ../development/libraries/flann { };

  flint = callPackage ../development/libraries/flint { };

  flite = callPackage ../development/libraries/flite { };

  fltk13 = callPackage ../development/libraries/fltk {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL GLUT;
  };
  fltk = self.fltk13;

  fmt = callPackage ../development/libraries/fmt/default.nix { };

  fplll = callPackage ../development/libraries/fplll {};
  fplll_20160331 = callPackage ../development/libraries/fplll/20160331.nix {};

  frog = self.languageMachines.frog;

  fontconfig_210 = callPackage ../development/libraries/fontconfig/2.10.nix { };

  fontconfig = callPackage ../development/libraries/fontconfig { };

  makeFontsConf = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-conf.nix {
      inherit fontconfig fontDirectories;
    };

  makeFontsCache = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-cache.nix {
      inherit fontconfig fontDirectories;
    };

  freeglut = callPackage ../development/libraries/freeglut { };

  freenect = callPackage ../development/libraries/freenect {
    inherit (darwin.apple_sdk.frameworks) Cocoa GLUT;
  };

  freetype = callPackage ../development/libraries/freetype { };

  frei0r = callPackage ../development/libraries/frei0r { };

  gamin = callPackage ../development/libraries/gamin { };
  fam = gamin; # added 2018-04-25

  gdome2 = callPackage ../development/libraries/gdome2 {
    inherit (gnome2) gtkdoc;
  };

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_4 = callPackage ../development/libraries/gecode { };
  gecode = gecode_4;

  gegl = callPackage ../development/libraries/gegl {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  gegl_0_3 = callPackage ../development/libraries/gegl/3.0.nix {
    gtk = self.gtk2;
  };

  gegl_0_4 = callPackage ../development/libraries/gegl/4.0.nix {
    gtk = self.gtk2;
  };

  geoclue2 = callPackage ../development/libraries/geoclue {};

  geoipWithDatabase = makeOverridable (callPackage ../development/libraries/geoip) {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  gettext = callPackage ../development/libraries/gettext { };

  gd = callPackage ../development/libraries/gd {
    libtiff = null;
    libXpm = null;
  };

  gdal = callPackage ../development/libraries/gdal { };

  gdal_1_11 = callPackage ../development/libraries/gdal/gdal-1_11.nix { };

  givaro = callPackage ../development/libraries/givaro {};
  givaro_3 = callPackage ../development/libraries/givaro/3.nix {};
  givaro_3_7 = callPackage ../development/libraries/givaro/3.7.nix {};

  icon-lang = callPackage ../development/interpreters/icon-lang { };

  libgit2 = callPackage ../development/libraries/git2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libgit2_0_27 = callPackage ../development/libraries/git2/0.27.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gle = callPackage ../development/libraries/gle { };

  glew = callPackage ../development/libraries/glew { };
  glew110 = callPackage ../development/libraries/glew/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  glfw = glfw3;
  glfw2 = callPackage ../development/libraries/glfw/2.x.nix { };
  glfw3 = callPackage ../development/libraries/glfw/3.x.nix {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa Kernel;
  };

  glibc = callPackage ../development/libraries/glibc {
    installLocales = config.glibc.locales or false;
  };

  # Provided by libc on Operating Systems that use the Extensible Linker Format.
  elf-header =
    if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf"
    then null
    else elf-header-real;

  elf-header-real = callPackage ../development/libraries/elf-header { };

  glibc_memusage = callPackage ../development/libraries/glibc {
    installLocales = false;
    withGd = true;
  };

  # Being redundant to avoid cycles on boot. TODO: find a better way
  glibcCross = callPackage ../development/libraries/glibc {
    installLocales = config.glibc.locales or false;
    stdenv = crossLibcStdenv;
  };

  muslCross = musl.override {
    stdenv = crossLibcStdenv;
  };

  # We can choose:
  libcCrossChooser = name:
    # libc is hackily often used from the previous stage. This `or`
    # hack fixes the hack, *sigh*.
    /**/ if name == "glibc" then targetPackages.glibcCross or glibcCross
    else if name == "bionic" then targetPackages.bionic or bionic
    else if name == "uclibc" then targetPackages.uclibcCross or uclibcCross
    else if name == "avrlibc" then targetPackages.avrlibcCross or avrlibcCross
    else if name == "newlib" then targetPackages.newlibCross or newlibCross
    else if name == "musl" then targetPackages.muslCross or muslCross
    else if name == "msvcrt" then targetPackages.windows.mingw_w64 or windows.mingw_w64
    else if stdenv.targetPlatform.useiOSPrebuilt then targetPackages.darwin.iosSdkPkgs.libraries or darwin.iosSdkPkgs.libraries
    else if name == "libSystem" then targetPackages.darwin.xcode
    else throw "Unknown libc";

  libcCross = assert stdenv.targetPlatform != stdenv.buildPlatform; libcCrossChooser stdenv.targetPlatform.libc;

  # Only supported on Linux, using glibc
  glibcLocales = if stdenv.hostPlatform.libc == "glibc" then callPackage ../development/libraries/glibc/locales.nix { } else null;

  glibcInfo = callPackage ../development/libraries/glibc/info.nix { };

  glibc_multi = callPackage ../development/libraries/glibc/multi.nix {
    glibc32 = pkgsi686Linux.glibc;
  };

  glm = callPackage ../development/libraries/glm { };

  globalplatform = callPackage ../development/libraries/globalplatform { };
  gppcscconnectionplugin =
    callPackage ../development/libraries/globalplatform/gppcscconnectionplugin.nix { };

  glog = callPackage ../development/libraries/glog { };

  glpk = callPackage ../development/libraries/glpk { };

  glsurf = callPackage ../applications/science/math/glsurf {
    libpng = libpng12;
    giflib = giflib_4_1;
    ocamlPackages = ocaml-ng.ocamlPackages_4_01_0;
  };

  gmime2 = callPackage ../development/libraries/gmime/2.nix { };
  gmime3 = callPackage ../development/libraries/gmime/3.nix { };
  gmime = gmime2;

  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { }; # required by older GHC versions
  gmp5 = callPackage ../development/libraries/gmp/5.1.x.nix { };
  gmp6 = callPackage ../development/libraries/gmp/6.x.nix { };
  gmp = gmp6;
  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  #GMP ex-satellite, so better keep it near gmp
  # A GMP fork
  mpir = callPackage ../development/libraries/mpir {};

  gns3Packages = callPackage ../applications/networking/gns3 { };
  gns3-gui = gns3Packages.guiStable;
  gns3-server = gns3Packages.serverStable;

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
    inherit (darwin) cctools;
    python = python2;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };
  goocanvas2 = callPackage ../development/libraries/goocanvas/2.x.nix { };

  google-gflags = callPackage ../development/libraries/google-gflags { };
  gflags = google-gflags; # TODO: move to aliases.nix

  grpc = callPackage ../development/libraries/grpc { };

  gsettings-qt = libsForQt5.callPackage ../development/libraries/gsettings-qt { };

  gst_all_1 = recurseIntoAttrs(callPackage ../development/libraries/gstreamer {
    callPackage = pkgs.newScope (pkgs // { libav = pkgs.ffmpeg; });
  });

  gstreamer = callPackage ../development/libraries/gstreamer/legacy/gstreamer {
    bison = bison2;
  };

  gst-plugins-base = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-base {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  gst-plugins-good = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-good {};

  gst-plugins-bad = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-bad {};

  gst-plugins-ugly = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-ugly {};

  gst-ffmpeg = callPackage ../development/libraries/gstreamer/legacy/gst-ffmpeg {
    ffmpeg = ffmpeg_0;
  };

  gst-python = callPackage ../development/libraries/gstreamer/legacy/gst-python {};

  qt-gstreamer = callPackage ../development/libraries/gstreamer/legacy/qt-gstreamer {};

  qt-gstreamer1 = callPackage ../development/libraries/gstreamer/qt-gstreamer { boost = boost155; };

  gnet = callPackage ../development/libraries/gnet { };

  gnu-config = callPackage ../development/libraries/gnu-config { };

  gnu-efi = if stdenv.hostPlatform.isEfi
              then callPackage ../development/libraries/gnu-efi { }
            else null;

  gnutls = callPackage
    (if stdenv.isDarwin
      # Avoid > 3.5.10 due to frameworks for now; see discussion on:
      # https://github.com/NixOS/nixpkgs/commit/d6454e6a1
      then ../development/libraries/gnutls/3.5.10.nix
      else ../development/libraries/gnutls/3.6.nix)
    {
      guileBindings = config.gnutls.guile or false;
    };

  gnutls-kdh = callPackage ../development/libraries/gnutls-kdh/3.5.nix {
    guileBindings = config.gnutls.guile or false;
    gperf = gperf_3_0;
  };

  gpac = callPackage ../applications/video/gpac { };

  gpgme = callPackage ../development/libraries/gpgme { };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsl_1 = callPackage ../development/libraries/gsl/gsl-1_16.nix { };

  gsm = callPackage ../development/libraries/gsm {};

  gss = callPackage ../development/libraries/gss { };

  glib = callPackage ../development/libraries/glib (let
    glib-untested = glib.override { doCheck = false; };
  in {
    # break dependency cycles
    # these things are only used for tests, they don't get into the closure
    shared-mime-info = shared-mime-info.override { glib = glib-untested; };
    desktop-file-utils = desktop-file-utils.override { glib = glib-untested; };
    dbus = dbus.override { systemd = null; };
  });

  glibmm = callPackage ../development/libraries/glibmm { };

  ace = callPackage ../development/libraries/ace { };

  atk = callPackage ../development/libraries/atk { };

  atkmm = callPackage ../development/libraries/atkmm { };

  cairo = callPackage ../development/libraries/cairo {
    glSupport = config.cairo.gl or (stdenv.isLinux &&
      !stdenv.isAarch32 && !stdenv.isMips);
  };


  pango = callPackage ../development/libraries/pango { };

  pangolin = callPackage ../development/libraries/pangolin {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  pangomm = callPackage ../development/libraries/pangomm {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pangox_compat = callPackage ../development/libraries/pangox-compat { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gnome-sharp = callPackage ../development/libraries/gnome-sharp { mono = mono4; };

  gtk2 = callPackage ../development/libraries/gtk+/2.x.nix {
    cupsSupport = config.gtk2.cups or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gtk2-x11 = gtk2.override {
    gdktarget = "x11";
  };

  gtk3 = callPackage ../development/libraries/gtk+/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  # On darwin gtk uses cocoa by default instead of x11.
  gtk3-x11 = gtk3.override {
    x11Support = true;
  };

  gtkmm2 = callPackage ../development/libraries/gtkmm/2.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.x.nix { };

  gtk-sharp-2_0 = callPackage ../development/libraries/gtk-sharp/2.0.nix {
    inherit (gnome2) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtk-sharp-3_0 = callPackage ../development/libraries/gtk-sharp/3.0.nix {
    inherit (gnome2) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtk-mac-integration = callPackage ../development/libraries/gtk-mac-integration {
    gtk = gtk3;
  };

  gtk-mac-integration-gtk2 = gtk-mac-integration.override {
    gtk = gtk2;
  };

  gtk-mac-integration-gtk3 = gtk-mac-integration;

  gtksourceview = gtksourceview3;

  gtksourceview3 = callPackage ../development/libraries/gtksourceview/3.x.nix { };

  gtksourceview4 = callPackage ../development/libraries/gtksourceview/4.x.nix { };

  gtkspell2 = callPackage ../development/libraries/gtkspell { };

  gtkspell3 = callPackage ../development/libraries/gtkspell/3.nix { };

  gvfs = callPackage ../development/libraries/gvfs {
    gnome = self.gnome3;
  };

  gwenhywfar = callPackage ../development/libraries/aqbanking/gwenhywfar.nix { };

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security SystemConfiguration;
  };
  libheimdal = heimdal;

  harfbuzz = callPackage ../development/libraries/harfbuzz {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreText;
  };

  harfbuzzFull = harfbuzz.override {
    withCoreText = stdenv.isDarwin;
    withGraphite2 = true;
    withIcu = true;
  };

  herqq = libsForQt5.callPackage ../development/libraries/herqq { };

  heyefi = haskellPackages.heyefi;

  hidapi = callPackage ../development/libraries/hidapi {
    libusb = libusb1;
  };

  hiredis = callPackage ../development/libraries/hiredis { };

  hivex = callPackage ../development/libraries/hivex {
    inherit (perlPackages) IOStringy;
  };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hunspell = callPackage ../development/libraries/hunspell { };

  hunspellDicts = recurseIntoAttrs (callPackages ../development/libraries/hunspell/dictionaries.nix {});

  hunspellWithDicts = dicts: callPackage ../development/libraries/hunspell/wrapper.nix { inherit dicts; };

  hwloc = callPackage ../development/libraries/hwloc {};

  hwloc-nox = hwloc.override {
    x11Support = false;
  };

  hydra = callPackage ../development/tools/misc/hydra { };

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  hyena = callPackage ../development/libraries/hyena { mono = mono4; };

  icu58 = callPackage (import ../development/libraries/icu/58.nix fetchurl) ({
    nativeBuildRoot = buildPackages.icu58.override { buildRootOnly = true; };
  } //
    (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu59 = callPackage ../development/libraries/icu/59.nix ({
    nativeBuildRoot = buildPackages.icu59.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu60 = callPackage ../development/libraries/icu/60.nix ({
    nativeBuildRoot = buildPackages.icu60.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.cc.isGNU && stdenv.hostPlatform.isi686) {
      stdenv = overrideCC stdenv gcc6; # with gcc-7: undefined reference to `__divmoddi4'
    }));

  icu = icu59;

  ilbc = callPackage ../development/libraries/ilbc { };

  imlib = callPackage ../development/libraries/imlib {
    libpng = libpng12;
  };

  iml = callPackage ../development/libraries/iml { };

  imlib2 = callPackage ../development/libraries/imlib2 { };
  imlib2-nox = imlib2.override {
    x11Support = false;
  };

  imlibsetroot = callPackage ../applications/graphics/imlibsetroot { libXinerama = xorg.libXinerama; } ;

  indicator-application-gtk2 = callPackage ../development/libraries/indicator-application/gtk2.nix { };
  indicator-application-gtk3 = callPackage ../development/libraries/indicator-application/gtk3.nix { };

  ios-cross-compile = callPackage ../development/compilers/ios-cross-compile/9.2.nix {};

  isocodes = callPackage ../development/libraries/iso-codes { };

  ispc = callPackage ../development/compilers/ispc {
    llvmPackages = llvmPackages_6;
    stdenv = llvmPackages_6.stdenv;
  };

  itk = callPackage ../development/libraries/itk { };

  jemalloc = callPackage ../development/libraries/jemalloc { };

  jemalloc450 = callPackage ../development/libraries/jemalloc/jemalloc450.nix { };

  json_c = callPackage ../development/libraries/json-c { };

  libjson = callPackage ../development/libraries/libjson { };

  kdeFrameworks =
    let
      mkFrameworks = import ../development/libraries/kde-frameworks;
      attrs = {
        inherit libsForQt5;
        inherit lib fetchurl;
      };
    in
      recurseIntoAttrs (makeOverridable mkFrameworks attrs);

  keybinder = callPackage ../development/libraries/keybinder {
    automake = automake111x;
    lua = lua5_1;
  };

  keybinder3 = callPackage ../development/libraries/keybinder3 {
    automake = automake111x;
  };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix {
    inherit (darwin) bootstrap_cmds;
  };
  krb5Full = krb5;
  libkrb5 = krb5.override {
    fetchurl = fetchurlBoot;
    type = "lib";
  };
  kerberos = libkrb5; # TODO: move to aliases.nix

  languageMachines = recurseIntoAttrs (import ../development/libraries/languagemachines/packages.nix { inherit callPackage; });

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  ldb = callPackage ../development/libraries/ldb {
    python = python2;
  };

  lmdb = callPackage ../development/libraries/lmdb { };

  libagar = callPackage ../development/libraries/libagar { };
  libagar_test = callPackage ../development/libraries/libagar/libagar_test.nix { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) CoreAudio CoreServices AudioUnit;
  };

  libappindicator-gtk2 = libappindicator.override { gtkVersion = "2"; };
  libappindicator-gtk3 = libappindicator.override { gtkVersion = "3"; };
  libappindicator = callPackage ../development/libraries/libappindicator { };

  libass = callPackage ../development/libraries/libass { };

  libav = libav_11; # branch 11 is API-compatible with branch 10
  libav_all = callPackage ../development/libraries/libav { };
  inherit (libav_all) libav_0_8 libav_11 libav_12;

  libbap = callPackage ../development/libraries/libbap {
    inherit (ocaml-ng.ocamlPackages_4_05) bap ocaml findlib ctypes;
  };

  libbass = (callPackage ../development/libraries/audio/libbass { }).bass;
  libbass_fx = (callPackage ../development/libraries/audio/libbass { }).bass_fx;

  libcaca = callPackage ../development/libraries/libcaca {
    inherit (xorg) libX11 libXext;
  };

  libcanberra = callPackage ../development/libraries/libcanberra {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };
  libcanberra-gtk3 = pkgs.libcanberra.override {
    gtk = gtk3;
  };
  libcanberra-gtk2 = pkgs.libcanberra-gtk3.override {
    gtk = gtk2.override { gdktarget = "x11"; };
  };

  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then pkgs.libcanberra
    else pkgs.libcanberra-gtk2;

  libcec = callPackage ../development/libraries/libcec { };
  libcec_platform = callPackage ../development/libraries/libcec/platform.nix { };

  libcef = callPackage ../development/libraries/libcef { inherit (gnome2) GConf; };

  libcdio = callPackage ../development/libraries/libcdio {
    inherit (darwin.apple_sdk.frameworks) Carbon IOKit;
  };

  libcdio-paranoia = callPackage ../development/libraries/libcdio-paranoia {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration IOKit;
  };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome2) libsoup;
  };

  libchipcard = callPackage ../development/libraries/aqbanking/libchipcard.nix { };

  libclthreads = callPackage ../development/libraries/libclthreads  { };

  libclxclient = callPackage ../development/libraries/libclxclient  { };

  inherit (gnome3) libcroco;

  libdbi = callPackage ../development/libraries/libdbi { };

  libdbiDriversBase = libdbiDrivers.override {
    mysql = null;
    sqlite = null;
  };

  libdbiDrivers = callPackage ../development/libraries/libdbi-drivers { };

  libunity = callPackage ../development/libraries/libunity {
    inherit (gnome3) gnome-common;
  };

  libdbusmenu = callPackage ../development/libraries/libdbusmenu { };
  libdbusmenu-gtk2 = libdbusmenu.override { gtkVersion = "2"; };
  libdbusmenu-gtk3 = libdbusmenu.override { gtkVersion = "3"; };

  libdbusmenu_qt = callPackage ../development/libraries/libdbusmenu-qt { };

  libdc1394 = callPackage ../development/libraries/libdc1394 {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  libde265 = callPackage ../development/libraries/libde265 {};

  libdevil = callPackage ../development/libraries/libdevil {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  libdevil-nox = libdevil.override {
    libX11 = null;
    libGL = null;
  };

  libdigidoc = callPackage ../development/libraries/libdigidoc { };

  libdrm = callPackage ../development/libraries/libdrm { };

  libdv = callPackage ../development/libraries/libdv { };

  libdvdcss = callPackage ../development/libraries/libdvdcss {
    inherit (darwin) IOKit;
  };

  libdvdnav = callPackage ../development/libraries/libdvdnav { };
  libdvdnav_4_2_1 = callPackage ../development/libraries/libdvdnav/4.2.1.nix {
    libdvdread = libdvdread_4_9_9;
  };

  libdvdread = callPackage ../development/libraries/libdvdread { };
  libdvdread_4_9_9 = callPackage ../development/libraries/libdvdread/4.9.9.nix { };

  inherit (callPackage ../development/libraries/libdwarf { })
    libdwarf dwarfdump;

  libeb = callPackage ../development/libraries/libeb { };

  libelf = if stdenv.isFreeBSD
  then callPackage ../development/libraries/libelf-freebsd { }
  else callPackage ../development/libraries/libelf { };

  libfm = callPackage ../development/libraries/libfm { };
  libfm-extra = libfm.override {
    extraOnly = true;
  };

  gap-libgap-compatible = let
    version = "4r8p6";
    pkgVer = "2016_11_12-14_25";
  in
    (gap.override { keepAllPackages = false; }).overrideAttrs (oldAttrs: {
      name = "libgap-${oldAttrs.pname}-${version}";
      src = fetchurl {
        url = "https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap${version}_${pkgVer}.tar.bz2";
        sha256 = "19n2p1mdg33s2x9rs51iak7rgndc1cwr56jyqnah0g1ydgg1yh6b";
      };
      patches = (oldAttrs.patches or []) ++ [
        # don't install any packages by default (needed for interop with libgap, probably obsolete  with 4r10
        (fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gap/patches/nodefaultpackages.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "1xwj766m3axrxbkyx13hy3q8s2wkqxy3m6mgpwq3c3n4vk3v416v";
        })
      ];
  });
  libgap = callPackage ../development/libraries/libgap { };

  libgdata = gnome3.libgdata;

  libgnome-keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome-keyring3 = gnome3.libgnome-keyring;

  libglvnd = callPackage ../development/libraries/libglvnd { };

  libsoundio = callPackage ../development/libraries/libsoundio {
    inherit (darwin.apple_sdk.frameworks) AudioUnit;
  };

  liblo = callPackage ../development/libraries/liblo { };

  libev = callPackage ../development/libraries/libev {
    fetchurl = fetchurlBoot;
  };

  libevent = callPackage ../development/libraries/libevent { };

  libexosip = callPackage ../development/libraries/exosip {};

  libextractor = callPackage ../development/libraries/libextractor {
    libmpeg2 = mpeg2dec;
  };

  libfive = callPackage ../development/libraries/libfive {
    eigen = eigen3_3;
  };

  libffi = callPackage ../development/libraries/libffi { };

  libfreefare = callPackage ../development/libraries/libfreefare {
    inherit (darwin) libobjc;
  };

  libftdi = callPackage ../development/libraries/libftdi { };

  libftdi1 = callPackage ../development/libraries/libftdi/1.x.nix { };

  libgcrypt = callPackage ../development/libraries/libgcrypt { };

  libgcrypt_1_5 = callPackage ../development/libraries/libgcrypt/1.5.nix { };

  libgdiplus = callPackage ../development/libraries/libgdiplus {
      inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  libgpgerror = callPackage ../development/libraries/libgpg-error { };

  # https://github.com/gpg/libgpg-error/blob/70058cd9f944d620764e57c838209afae8a58c78/README#L118-L140
  libgpgerror-gen-posix-lock-obj = libgpgerror.override {
    genPosixLockObjOnly = true;
  };

  libgpod = callPackage ../development/libraries/libgpod {
    inherit (pkgs.pythonPackages) mutagen;
    monoSupport = false;
  };

  libguestfs-appliance = callPackage ../development/libraries/libguestfs/appliance.nix {};
  libguestfs = callPackage ../development/libraries/libguestfs {
    inherit (perlPackages) libintl_perl GetoptLong SysVirt;
    appliance = libguestfs-appliance;
  };

  libheif = callPackage ../development/libraries/libheif {};

  libindicate-gtk2 = libindicate.override { gtkVersion = "2"; };
  libindicate-gtk3 = libindicate.override { gtkVersion = "3"; };
  libindicate = callPackage ../development/libraries/libindicate { };

  libindicator-gtk2 = libindicator.override { gtkVersion = "2"; };
  libindicator-gtk3 = libindicator.override { gtkVersion = "3"; };
  libindicator = callPackage ../development/libraries/libindicator { };

  libiodbc = callPackage ../development/libraries/libiodbc {
    useGTK = config.libiodbc.gtk or false;
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  liblqr1 = callPackage ../development/libraries/liblqr-1 { };

  liblogging = callPackage ../development/libraries/liblogging { };

  liblognorm = callPackage ../development/libraries/liblognorm { };

  libmysqlconnectorcpp = callPackage ../development/libraries/libmysqlconnectorcpp {
    mysql = mysql57;
  };

  libqglviewer = callPackage ../development/libraries/libqglviewer {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  libre = callPackage ../development/libraries/libre {};
  librelp = callPackage ../development/libraries/librelp { };

  libsamplerate = callPackage ../development/libraries/libsamplerate {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon CoreServices;
  };

  # GNU libc provides libiconv so systems with glibc don't need to build
  # libiconv separately. Additionally, Apple forked/repackaged libiconv so we
  # use that instead of the vanilla version on that OS.
  #
  # We also provide `libiconvReal`, which will always be a standalone libiconv,
  # just in case you want it regardless of platform.
  libiconv =
    if (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.libc == "musl")
      then glibcIconv (if stdenv.hostPlatform != stdenv.buildPlatform
                       then libcCross
                       else stdenv.cc.libc)
    else if stdenv.hostPlatform.isDarwin
      then darwin.libiconv
    else libiconvReal;

  glibcIconv = libc: let
    inherit (builtins.parseDrvName libc.name) name version;
    libcDev = lib.getDev libc;
  in runCommand "${name}-iconv-${version}" {} ''
    mkdir -p $out/include
    ln -sv ${libcDev}/include/iconv.h $out/include
  '';

  libiconvReal = callPackage ../development/libraries/libiconv {
    fetchurl = fetchurlBoot;
  };

  # On non-GNU systems we need GNU Gettext for libintl.
  libintl = if stdenv.hostPlatform.libc != "glibc" then gettext else null;

  libid3tag = callPackage ../development/libraries/libid3tag {
    gperf = gperf_3_0;
  };

  libidn = callPackage ../development/libraries/libidn { };

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  libjpeg_original = callPackage ../development/libraries/libjpeg { };
  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };
  libjpeg_drop = callPackage ../development/libraries/libjpeg-drop { };
  libjpeg = libjpeg_turbo;

  libksi = callPackage ../development/libraries/libksi { };

  libmatheval = callPackage ../development/libraries/libmatheval {
    guile = guile_2_0;
  };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmikmod = callPackage ../development/libraries/libmikmod {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  libminc = callPackage ../development/libraries/libminc {
    hdf5 = hdf5_1_8;
  };

  libmirage = callPackage ../misc/emulators/cdemu/libmirage.nix { };

  libmodplug = callPackage ../development/libraries/libmodplug {};

  libmusicbrainz3 = callPackage ../development/libraries/libmusicbrainz { };

  libmusicbrainz5 = callPackage ../development/libraries/libmusicbrainz/5.x.nix { };

  libmusicbrainz = libmusicbrainz3;

  libnet = callPackage ../development/libraries/libnet { };

  libogg = callPackage ../development/libraries/libogg { };

  libopus = callPackage ../development/libraries/libopus { };

  libosinfo = callPackage ../development/libraries/libosinfo {
    inherit (gnome3) libsoup;
  };

  libosip = callPackage ../development/libraries/osip {};

  libosip_3 = callPackage ../development/libraries/osip/3.nix {};

  libpcap = callPackage ../development/libraries/libpcap { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = libpng.override { apngSupport = true; };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  libproxy = callPackage ../development/libraries/libproxy {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration CoreFoundation JavaScriptCore;
  };

  libpsl = callPackage ../development/libraries/libpsl { };

  librsvg = callPackage ../development/libraries/librsvg { };

  librsync = callPackage ../development/libraries/librsync { };

  librsync_0_9 = callPackage ../development/libraries/librsync/0.9.nix { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsndfile = callPackage ../development/libraries/libsndfile {
    inherit (darwin.apple_sdk.frameworks) Carbon AudioToolbox;
  };

  libsoup = callPackage ../development/libraries/libsoup { };

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

  libstatgrab = callPackage ../development/libraries/libstatgrab {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtorrentRasterbar = callPackage ../development/libraries/libtorrent-rasterbar { };

  # this is still the new version of the old API
  libtoxcore-new = callPackage ../development/libraries/libtoxcore/new-api.nix { };

  inherit (callPackages ../development/libraries/libtoxcore {})
    libtoxcore_0_1 libtoxcore_0_2;
  libtoxcore = libtoxcore_0_2;

  libtxc_dxtn = callPackage ../development/libraries/libtxc_dxtn { };

  libui = callPackage ../development/libraries/libui {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  libupnp = callPackage ../development/libraries/pupnp { };

  giflib = giflib_5_1;
  giflib_4_1 = callPackage ../development/libraries/giflib/4.1.nix { };
  giflib_5_1 = callPackage ../development/libraries/giflib/5.1.nix { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libunique = callPackage ../development/libraries/libunique { };
  libunique3 = callPackage ../development/libraries/libunique/3.x.nix { inherit (gnome2) gtkdoc; };

  libusb = callPackage ../development/libraries/libusb {};

  libusb1 = callPackage ../development/libraries/libusb1 {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libunwind = if stdenv.isDarwin
    then darwin.libunwind
    else callPackage ../development/libraries/libunwind { };

  libv4l = lowPrio (v4l_utils.override {
    withUtils = false;
  });

  libva = callPackage ../development/libraries/libva { };
  libva-minimal = libva.override { minimal = true; };
  libva1 = callPackage ../development/libraries/libva/1.0.0.nix { };
  libva1-minimal = libva1.override { minimal = true; };

  libvdpau = callPackage ../development/libraries/libvdpau { };

  libvdpau-va-gl = callPackage ../development/libraries/libvdpau-va-gl { };

  libvirt = callPackage ../development/libraries/libvirt { };

  libvpx = callPackage ../development/libraries/libvpx { };
  libvpx-git = callPackage ../development/libraries/libvpx/git.nix { };

  libvterm = callPackage ../development/libraries/libvterm { };
  libwebp = callPackage ../development/libraries/libwebp { };

  libwnck = libwnck2;
  libwnck2 = callPackage ../development/libraries/libwnck { };
  libwnck3 = callPackage ../development/libraries/libwnck/3.x.nix { };

  libwpd = callPackage ../development/libraries/libwpd { };

  libwpd_08 = callPackage ../development/libraries/libwpd/0.8.nix { };

  libx86 = callPackage ../development/libraries/libx86 {};

  libxdg_basedir = callPackage ../development/libraries/libxdg-basedir { };

  libxml2 = callPackage ../development/libraries/libxml2 { };

  libxml2Python = pkgs.buildEnv { # slightly hacky
    name = "libxml2+py-${self.libxml2.version}";
    paths = with libxml2; [ dev bin py ];
    inherit (libxml2) passthru;
    # the hook to find catalogs is hidden by buildEnv
    postBuild = ''
      mkdir "$out/nix-support"
      cp '${libxml2.dev}/nix-support/propagated-build-inputs' "$out/nix-support/"
    '';
  };

  libxmlxx = callPackage ../development/libraries/libxmlxx { };
  libxmlxx3 = callPackage ../development/libraries/libxmlxx/v3.nix { };

  libixp_hg = callPackage ../development/libraries/libixp-hg { };

  libyaml = callPackage ../development/libraries/libyaml { };

  libyamlcpp = callPackage ../development/libraries/libyaml-cpp { };

  libyamlcpp_0_3 = pkgs.libyamlcpp.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchurl {
      url = "https://github.com/jbeder/yaml-cpp/archive/release-0.3.0.tar.gz";
      sha256 = "12aszqw6svwlnb6nzhsbqhz3c7vnd5ahd0k6xlj05w8lm83hx3db";
      };
  });

  lightning = callPackage ../development/libraries/lightning { };

  lightlocker = callPackage ../misc/screensavers/light-locker { };

  linenoise = callPackage ../development/libraries/linenoise { };

  luabind = callPackage ../development/libraries/luabind { lua = lua5_1; };

  luabind_luajit = luabind.override { lua = luajit; };

  luaffi = callPackage ../development/libraries/luaffi { lua = lua5_1; };

  lzo = callPackage ../development/libraries/lzo { };

  marisa = callPackage ../development/libraries/marisa {};

  matio = callPackage ../development/libraries/matio { };

  mbedtls = callPackage ../development/libraries/mbedtls { };
  mbedtls_1_3 = callPackage ../development/libraries/mbedtls/1.3.nix { };
  polarssl = mbedtls; # TODO: add to aliases.nix

  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mediastreamer-openh264 = callPackage ../development/libraries/mediastreamer/msopenh264.nix { };

  mergerfs = callPackage ../tools/filesystems/mergerfs { };

  mergerfs-tools = callPackage ../tools/filesystems/mergerfs/tools.nix { };

  ## libGL/libGLU/Mesa stuff

  # Default libGL implementation, should provide headers and libGL.so/libEGL.so/... to link agains them
  libGL = mesa_noglu.stubs;

  # Default libGLU
  libGLU = mesa_glu;

  # Combined derivation, contains both libGL and libGLU
  # Please, avoid using this attribute.  It was meant as transitional hack
  # for packages that assume that libGLU and libGL live in the same prefix.
  # libGLU_combined propagates both libGL and libGLU
  libGLU_combined = buildEnv {
    name = "libGLU-combined";
    paths = [ libGL libGLU ];
    extraOutputsToInstall = [ "dev" ];
  };

  # Default derivation with libGL.so.1 to link into /run/opengl-drivers (if need)
  libGL_driver = mesa_drivers;

  libGLSupported = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;

  mesa_noglu = callPackage ../development/libraries/mesa {
    llvmPackages = llvmPackages_6;
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };
  mesa = mesa_noglu;

  mesa_glu =  callPackage ../development/libraries/mesa-glu { };

  # NOTE: 2018-07-12: legacy alias:
  # gcsecurity bussiness is done: https://www.theregister.co.uk/2018/02/08/bruce_perens_grsecurity_anti_slapp/
  # floating point textures patents are expired,
  # so package reduced to alias
  mesa_drivers = mesa_noglu.drivers;

  ## End libGL/libGLU/Mesa stuff

  mkvtoolnix = libsForQt5.callPackage ../applications/video/mkvtoolnix { };

  mkvtoolnix-cli = callPackage ../applications/video/mkvtoolnix {
    withGUI = false;
  };

  mlt = callPackage ../development/libraries/mlt {};

  mps = callPackage ../development/libraries/mps { };

  libmpeg2 = callPackage ../development/libraries/libmpeg2 { };

  mpeg2dec = libmpeg2;

  msgpack = callPackage ../development/libraries/msgpack { };

  libmpc = callPackage ../development/libraries/libmpc { };

  mtpfs = callPackage ../tools/filesystems/mtpfs { };

  mu = callPackage ../tools/networking/mu {
    texinfo = texinfo4;
  };

  mygpoclient = pythonPackages.mygpoclient;

  mygui = callPackage ../development/libraries/mygui {
    ogre = ogre1_9;
  };

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

  neon = callPackage ../development/libraries/neon { };

  neon_0_29 = callPackage ../development/libraries/neon/0.29.nix { };

  nettle = callPackage ../development/libraries/nettle { };

  newt = callPackage ../development/libraries/newt { };

  nghttp2 = callPackage ../development/libraries/nghttp2 {
    fetchurl = fetchurlBoot;
  };
  libnghttp2 = nghttp2.lib;

  nix-plugins = callPackage ../development/libraries/nix-plugins {
    nix = nixUnstable;
  };

  non = callPackage ../applications/audio/non { };

  ntl = callPackage ../development/libraries/ntl { };

  nspr = callPackage ../development/libraries/nspr {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  nss = lowPrio (callPackage ../development/libraries/nss { });
  nssTools = nss.tools;

  nsss = skawarePackages.nsss;

  ntk = callPackage ../development/libraries/audio/ntk { };

  ntrack = callPackage ../development/libraries/ntrack { };

  nvtop = callPackage ../tools/system/nvtop {
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };

  ocl-icd-oclhGen = oclh: callPackage ../development/libraries/ocl-icd { opencl-headers = oclh; };
  ocl-icd-oclh_1_2 = ocl-icd-oclhGen opencl-headers_1_2;
  ocl-icd-oclh_2_2 = ocl-icd-oclhGen opencl-headers_2_2;
  ocl-icd = ocl-icd-oclh_2_2;

  ode = callPackage ../development/libraries/ode { };

  ogre = callPackage ../development/libraries/ogre {};
  ogre1_9 = callPackage ../development/libraries/ogre/1.9.x.nix {};

  ogrepaged = callPackage ../development/libraries/ogrepaged { };

  olm = callPackage ../development/libraries/olm { };

  openalSoft = callPackage ../development/libraries/openal-soft {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };
  openal = openalSoft;

  opencl-headersGen = v: callPackage ../development/libraries/opencl-headers { version = v; };
  opencl-headers_1_2 = opencl-headersGen "12";
  opencl-headers_2_2 = opencl-headersGen "22";
  opencl-headers = opencl-headers_2_2;

  opencv = callPackage ../development/libraries/opencv {
    ffmpeg = ffmpeg_2;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa QTKit;
  };

  opencv3 = callPackage ../development/libraries/opencv/3.x.nix {
    enableCuda = config.cudaSupport or false;
    inherit (darwin.apple_sdk.frameworks) AVFoundation Cocoa QTKit VideoDecodeAcceleration;
  };

  opencv3WithoutCuda = opencv3.override {
    enableCuda = false;
  };

  openexr = callPackage ../development/libraries/openexr { };

  openldap = callPackage ../development/libraries/openldap { };

  ois = callPackage ../development/libraries/ois {};

  opal = callPackage ../development/libraries/opal {
    ffmpeg = ffmpeg_2;
    stdenv = overrideCC stdenv gcc6;
  };

  openh264 = callPackage ../development/libraries/openh264 { };

  openjpeg_1 = callPackage ../development/libraries/openjpeg/1.x.nix { };
  openjpeg_2 = callPackage ../development/libraries/openjpeg/2.x.nix { };
  openjpeg = openjpeg_2;

  openpa = callPackage ../development/libraries/openpa { };

  openscenegraph = callPackage ../development/libraries/openscenegraph { };
  openscenegraph_3_4 = callPackage ../development/libraries/openscenegraph/3.4.0.nix { };

  inherit (callPackages ../development/libraries/libressl { })
    libressl_2_6
    libressl_2_7
    libressl_2_8;

  libressl = libressl_2_7;

  openssl = openssl_1_0_2;

  inherit (callPackages ../development/libraries/openssl {
      fetchurl = fetchurlBoot;
      cryptodevHeaders = linuxPackages.cryptodev.override {
        fetchurl = fetchurlBoot;
        onlyHeaders = true;
      };
    })
    openssl_1_0_2
    openssl_1_1;

  openssl-chacha = callPackage ../development/libraries/openssl/chacha.nix {
    cryptodevHeaders = linuxPackages.cryptodev.override {
      fetchurl = fetchurlBoot;
      onlyHeaders = true;
    };
  };

  opensubdiv = callPackage ../development/libraries/opensubdiv {
    cudaSupport = config.cudaSupport or false;
    cmake = cmake_2_8;
  };

  osinfo-db = callPackage ../data/misc/osinfo-db { };
  pcaudiolib = callPackage ../development/libraries/pcaudiolib {
    pulseaudioSupport = config.pulseaudio or true;
  };

  pcg_c = callPackage ../development/libraries/pcg-c { };

  pcl = libsForQt5.callPackage ../development/libraries/pcl {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL OpenGL;
  };

  pcre = callPackage ../development/libraries/pcre { };
  pcre16 = self.pcre.override { variant = "pcre16"; };
  # pcre32 seems unused
  pcre-cpp = self.pcre.override { variant = "cpp"; };

  pcre2 = callPackage ../development/libraries/pcre2 { };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  plv8 = callPackage ../servers/sql/postgresql/plv8 {
    v8 = callPackage ../development/libraries/v8/plv8_6_x.nix {
      inherit (python2Packages) python;
    };
  };

  phonon = callPackage ../development/libraries/phonon {};

  phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix {};

  # TODO(@Ma27) get rid of that as soon as QT4 can be dropped
  phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix {
    withQt4 = true;
  };

  inherit (callPackage ../development/libraries/physfs { })
    physfs_2
    physfs;

  pipelight = callPackage ../tools/misc/pipelight {
    stdenv = stdenv_32bit;
    wine-staging = pkgsi686Linux.wine-staging;
  };

  plib = callPackage ../development/libraries/plib { };

  podofo = callPackage ../development/libraries/podofo { lua5 = lua5_1; };

  polkit = callPackage ../development/libraries/polkit { };

  polkit_qt4 = callPackage ../development/libraries/polkit-qt-1/qt-4.nix { };

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };
  poppler_0_61 = callPackage ../development/libraries/poppler/0.61.nix { lcms = lcms2; };

  poppler_gi = lowPrio (poppler.override {
    introspectionSupport = true;
  });

  poppler_min = poppler.override { # TODO: maybe reduce even more
    # this is currently only used by texlive.bin.
    minimal = true;
    suffix = "min";
  };

  poppler_utils = poppler.override { suffix = "utils"; utils = true; };

  popt = callPackage ../development/libraries/popt { };

  portaudio = callPackage ../development/libraries/portaudio {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AudioUnit CoreAudio CoreServices Carbon;
  };

  portaudio2014 = portaudio.overrideAttrs (oldAttrs: {
    src = fetchurl {
      url = http://www.portaudio.com/archives/pa_stable_v19_20140130.tgz;
      sha256 = "0mwddk4qzybaf85wqfhxqlf0c5im9il8z03rd4n127k8y2jj9q4g";
    };
  });

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  proselint = callPackage ../tools/text/proselint {
    inherit (python3Packages)
    buildPythonApplication click future six;
  };

  protobuf = protobuf3_6;

  protobuf3_6 = callPackage ../development/libraries/protobuf/3.6.nix { };
  protobuf3_5 = callPackage ../development/libraries/protobuf/3.5.nix { };
  protobuf3_4 = callPackage ../development/libraries/protobuf/3.4.nix { };
  protobuf3_1 = callPackage ../development/libraries/protobuf/3.1.nix { };
  protobuf2_5 = callPackage ../development/libraries/protobuf/2.5.nix { };

  protobufc = callPackage ../development/libraries/protobufc/1.3.nix { };

  gnupth = callPackage ../development/libraries/pth { };
  pth = if stdenv.hostPlatform.isMusl then npth else gnupth;

  pugixml = callPackage ../development/libraries/pugixml { };

  re2 = callPackage ../development/libraries/re2 { };

  qbs = libsForQt5.callPackage ../development/tools/build-managers/qbs { };

  qca2 = callPackage ../development/libraries/qca2 { qt = qt4; };
  qca2-qt5 = qca2.override { qt = qt5.qtbase; };

  qt3 = callPackage ../development/libraries/qt-3 {
    openglSupport = libGLSupported;
    libpng = libpng12;
  };

  qt4 = qt48;

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    inherit (pkgs.gnome2) libgnomeui GConf gnome_vfs;
    cups = if stdenv.isLinux then cups else null;

    # XXX: mariadb doesn't built on fbsd as of nov 2015
    mysql = if (!stdenv.isFreeBSD) then mysql else null;

    inherit (pkgs.darwin) cf-private libobjc;
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices OpenGL Cocoa AGL;
  };

  qmake48Hook = makeSetupHook
    { substitutions = { qt4 = qt48; }; }
    ../development/libraries/qt-4.x/4.8/qmake-hook.sh;

  qmake4Hook = qmake48Hook;

  qt48Full = appendToName "full" (qt48.override {
    docs = true;
    demos = true;
    examples = true;
    developerBuild = true;
  });

  qt56 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.6) {
      inherit newScope;
      inherit stdenv fetchurl makeSetupHook;
      bison = bison2; # error: too few arguments to function 'int yylex(...
      inherit cups;
      harfbuzz = harfbuzzFull;
      inherit libGL;
      inherit perl;
      inherit (gst_all_1) gstreamer gst-plugins-base;
    });

  libsForQt56 = lib.makeScope qt56.newScope mkLibsForQt5;

  qt59 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.9) {
      inherit newScope;
      inherit stdenv fetchurl makeSetupHook;
      bison = bison2; # error: too few arguments to function 'int yylex(...
      inherit cups;
      harfbuzz = harfbuzzFull;
      inherit libGL;
      inherit perl;
      inherit (darwin) cf-private;
      inherit (gst_all_1) gstreamer gst-plugins-base;
      inherit (gnome3) gtk3 dconf;
    });

  libsForQt59 = lib.makeScope qt59.newScope mkLibsForQt5;

  qt511 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.11) {
      inherit newScope;
      inherit stdenv fetchurl fetchFromGitHub makeSetupHook;
      bison = bison2; # error: too few arguments to function 'int yylex(...
      inherit cups;
      harfbuzz = harfbuzzFull;
      inherit libGL;
      inherit perl;
      inherit (darwin) cf-private;
      inherit (gnome3) gtk3 dconf;
      inherit (gst_all_1) gstreamer gst-plugins-base;
    });

  libsForQt511 = recurseIntoAttrs (lib.makeScope qt511.newScope mkLibsForQt5);

  qt5 = qt511;
  libsForQt5 = libsForQt511;

  qt5ct = libsForQt5.callPackage ../tools/misc/qt5ct { };

  mkLibsForQt5 = self: with self; {

    ### KDE FRAMEWORKS

    inherit (kdeFrameworks.override { libsForQt5 = self; })
      attica baloo bluez-qt kactivities kactivities-stats
      karchive kauth kbookmarks kcmutils kcodecs kcompletion kconfig
      kconfigwidgets kcoreaddons kcrash kdbusaddons kdeclarative kdelibs4support
      kdesignerplugin kdnssd kemoticons kfilemetadata kglobalaccel kguiaddons
      khtml ki18n kiconthemes kidletime kimageformats kio kitemmodels kitemviews
      kjobwidgets kjs kjsembed kmediaplayer knewstuff knotifications
      knotifyconfig kpackage kparts kpeople kplotting kpty kross krunner
      kservice ktexteditor ktextwidgets kunitconversion kwallet kwayland
      kwidgetsaddons kwindowsystem kxmlgui kxmlrpcclient modemmanager-qt
      networkmanager-qt plasma-framework prison solid sonnet syntax-highlighting
      syndication threadweaver kirigami2 kholidays kpurpose;

    ### KDE PLASMA 5

    inherit (plasma5.override { libsForQt5 = self; })
      kdecoration khotkeys libkscreen libksysguard;

    ### KDE APPLICATIONS

    inherit (kdeApplications.override { libsForQt5 = self; })
      libkdcraw libkexiv2 libkipi libkomparediff2 libksane;

    ### LIBRARIES

    accounts-qt = callPackage ../development/libraries/accounts-qt { };

    alkimia = callPackage ../development/libraries/alkimia { };

    fcitx-qt5 = callPackage ../tools/inputmethods/fcitx/fcitx-qt5.nix { };

    qgpgme = callPackage ../development/libraries/gpgme { };

    grantlee = callPackage ../development/libraries/grantlee/5 { };

    kdb = callPackage ../development/libraries/kdb { };

    kdiagram = callPackage ../development/libraries/kdiagram { };

    kproperty = callPackage ../development/libraries/kproperty { };

    kreport = callPackage ../development/libraries/kreport { };

    libcommuni = callPackage ../development/libraries/libcommuni { };

    libdbusmenu = callPackage ../development/libraries/libdbusmenu-qt/qt-5.5.nix { };

    libkeyfinder = callPackage ../development/libraries/libkeyfinder { };

    libktorrent = callPackage ../development/libraries/libktorrent { };

    libopenshot = callPackage ../applications/video/openshot-qt/libopenshot.nix { };

    libopenshot-audio = callPackage ../applications/video/openshot-qt/libopenshot-audio.nix { };

    libqtav = callPackage ../development/libraries/libqtav { };

    kpmcore = callPackage ../development/libraries/kpmcore { };

    mlt = callPackage ../development/libraries/mlt/qt-5.nix {
      ffmpeg = ffmpeg_2;
    };

    openbr = callPackage ../development/libraries/openbr { };

    phonon = callPackage ../development/libraries/phonon {
      withQt5 = true;
    };

    phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix {
      withQt5 = true;
    };

    phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix { };

    polkit-qt = callPackage ../development/libraries/polkit-qt-1/qt-5.nix { };

    poppler = callPackage ../development/libraries/poppler {
      lcms = lcms2;
      qt5Support = true;
      suffix = "qt5";
    };

    qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

    qmltermwidget = callPackage ../development/libraries/qmltermwidget { };
    qmlbox2d = libsForQt59.callPackage ../development/libraries/qmlbox2d { };

    qscintilla = callPackage ../development/libraries/qscintilla {
      withQt5 = true;
    };

    qtinstaller = callPackage ../development/libraries/qtinstaller { };

    qtkeychain = callPackage ../development/libraries/qtkeychain {
      withQt5 = true;
    };

    qtstyleplugins = callPackage ../development/libraries/qtstyleplugins { };

    qtstyleplugin-kvantum = libsForQt5.callPackage ../development/libraries/qtstyleplugin-kvantum { };

    quazip = callPackage ../development/libraries/quazip { };

    qwt = callPackage ../development/libraries/qwt/6.nix { };

    telepathy = callPackage ../development/libraries/telepathy/qt { };

    vlc = callPackage ../applications/video/vlc {};

    qtwebkit-plugins = callPackage ../development/libraries/qtwebkit-plugins { };

  };

  qtEnv = qt5.env;
  qt5Full = qt5.full;

  qtkeychain = callPackage ../development/libraries/qtkeychain { };

  quickder = callPackage ../development/libraries/quickder {};

  qwt = callPackage ../development/libraries/qwt {};

  qwt6_qt4 = callPackage ../development/libraries/qwt/6_qt4.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  rabbitmq-c = callPackage ../development/libraries/rabbitmq-c {};

  readline = readline6;
  readline6 = readline63;

  readline5 = callPackage ../development/libraries/readline/5.x.nix { };

  readline62 = callPackage ../development/libraries/readline/6.2.nix { };

  readline63 = callPackage ../development/libraries/readline/6.3.nix { };

  readline70 = callPackage ../development/libraries/readline/7.0.nix { };

  lambdabot = callPackage ../development/tools/haskell/lambdabot {
    haskellLib = haskell.lib;
  };

  leksah = callPackage ../development/tools/haskell/leksah {
    inherit (haskellPackages) ghcWithPackages;
  };

  librdf_raptor = callPackage ../development/libraries/librdf/raptor.nix { };

  librdf_raptor2 = callPackage ../development/libraries/librdf/raptor2.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf_redland = callPackage ../development/libraries/librdf/redland.nix { };
  redland = librdf_redland; # added 2018-04-25

  librdf = callPackage ../development/libraries/librdf { };
  liblrdf = librdf; # added 2018-04-25

  lv2 = callPackage ../development/libraries/audio/lv2 { };
  lv2Unstable = callPackage ../development/libraries/audio/lv2/unstable.nix { };

  qgnomeplatform =  libsForQt5.callPackage ../development/libraries/qgnomeplatform { };

  rhino = callPackage ../development/libraries/java/rhino {
    javac = jdk;
    jvm = jre;
  };

  rocksdb = callPackage ../development/libraries/rocksdb { jemalloc = jemalloc450; };

  rocksdb_lite = rocksdb.override { enableLite = true; };

  rshell = python3.pkgs.callPackage ../development/tools/rshell { };

  rubberband = callPackage ../development/libraries/rubberband {
    inherit (vamp) vampSDK;
  };

  sad = callPackage ../applications/science/logic/sad { };

  sbc = callPackage ../development/libraries/sbc { };

  SDL = callPackage ../development/libraries/SDL {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa;
  };

  SDL_sixel = callPackage ../development/libraries/SDL_sixel { };

  SDL_stretch= callPackage ../development/libraries/SDL_stretch { };

  SDL2 = callPackage ../development/libraries/SDL2 {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL;
  };

  SDL2_image = callPackage ../development/libraries/SDL2_image {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  SDL2_mixer = callPackage ../development/libraries/SDL2_mixer {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };

  serf = callPackage ../development/libraries/serf {};

  graphite2 = callPackage ../development/libraries/silgraphite/graphite2.nix {};

  simavr = callPackage ../development/tools/simavr {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrbinutils = pkgsCross.avr.buildPackages.binutils;
    avrlibc = pkgsCross.avr.libcCross;
  };

  simgear = callPackage ../development/libraries/simgear { openscenegraph = openscenegraph_3_4; };

  simpleitk = callPackage ../development/libraries/simpleitk { lua = lua51Packages.lua; };

  sfml = callPackage ../development/libraries/sfml {
    inherit (darwin.apple_sdk.frameworks) IOKit Foundation AppKit OpenAL;
  };
  skalibs = skawarePackages.skalibs;

  skawarePackages = recurseIntoAttrs {
    buildPackage = callPackage ../build-support/skaware/build-skaware-package.nix { };

    skalibs = callPackage ../development/libraries/skalibs { };
    execline = callPackage ../tools/misc/execline { };

    s6 = callPackage ../tools/system/s6 { };
    s6-dns = callPackage ../tools/networking/s6-dns { };
    s6-linux-utils = callPackage ../os-specific/linux/s6-linux-utils { };
    s6-networking = callPackage ../tools/networking/s6-networking { };
    s6-portable-utils = callPackage ../tools/misc/s6-portable-utils { };
    s6-rc = callPackage ../tools/system/s6-rc { };

    nsss = callPackage ../development/libraries/nsss { };
    utmps = callPackage ../development/libraries/utmps { };

  };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
    texinfo = texinfo4; # otherwise erros: must be after `@defun' to use `@defunx'
  };

  smpeg = callPackage ../development/libraries/smpeg { };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

  soapyairspy = callPackage ../applications/misc/soapyairspy { };

  soapybladerf = callPackage ../applications/misc/soapybladerf { };

  soapyhackrf = callPackage ../applications/misc/soapyhackrf { };

  soapysdr = callPackage ../applications/misc/soapysdr { inherit (python3Packages) python numpy; };

  soapyremote = callPackage ../applications/misc/soapyremote { };

  soapysdr-with-plugins = callPackage ../applications/misc/soapysdr {
    inherit (python3Packages) python numpy;
    extraPackages = [
      limesuite
      soapyairspy
      soapybladerf
      soapyhackrf
      soapyremote
      soapyuhd
    ];
  };

  soapyuhd = callPackage ../applications/misc/soapyuhd { };

  sofia_sip = callPackage ../development/libraries/sofia-sip { };

  sonic = callPackage ../development/libraries/sonic { };

  sord = callPackage ../development/libraries/sord {};

  spatialite_tools = callPackage ../development/libraries/spatialite-tools { };

  speechd = callPackage ../development/libraries/speechd { };

  speex = callPackage ../development/libraries/speex {
    fftw = fftwFloat;
  };

  speexdsp = callPackage ../development/libraries/speexdsp {
    fftw = fftwFloat;
  };

  spice = callPackage ../development/libraries/spice {
    celt = celt_0_5_1;
    inherit (pythonPackages) pyparsing;
  };

  srm = callPackage ../tools/security/srm { };

  srtp = callPackage ../development/libraries/srtp {
    libpcap = if stdenv.isLinux then libpcap else null;
  };

  stxxl = callPackage ../development/libraries/stxxl { parallel = true; };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite { });

  sqlite-analyzer = lowPrio (callPackage ../development/libraries/sqlite/analyzer.nix { });

  sqlar = callPackage ../development/libraries/sqlite/sqlar.nix { };

  sqlite-interactive = appendToName "interactive" (sqlite.override { interactive = true; }).bin;

  sqlite-jdbc = callPackage ../servers/sql/sqlite/jdbc { };

  sqlite-replication = sqlite.overrideAttrs (oldAttrs: rec {
    name = "sqlite-${version}";
    version = "3.24.0+replication3";
    src = pkgs.fetchFromGitHub {
      owner = "CanonicalLtd";
      repo = "sqlite";
      rev = "version-${version}";
      sha256 = "19557b7aick1pxk0gw013cf5jy42i7539qn1ziza8dzy16a6zs8b";
    };
    nativeBuildInputs = [ pkgs.tcl ];
    configureFlags = oldAttrs.configureFlags ++ [
      "--enable-replication"
      "--disable-amalgamation"
      "--disable-tcl"
    ];
    preConfigure = ''
      echo "D 2018-08-01T13:22:18" > manifest
      echo -n "c94dbda1a570c1ab180e7694afd3cc7116268c06" > manifest.uuid
    '';
  });

  sqlcipher = lowPrio (callPackage ../development/libraries/sqlcipher {
    readline = null;
    ncurses = null;
  });

  stfl = callPackage ../development/libraries/stfl { };

  streamlink = callPackage ../applications/video/streamlink { pythonPackages = python3Packages; };

  strigi = callPackage ../development/libraries/strigi { clucene_core = clucene_core_2; };

  suil = callPackage ../development/libraries/audio/suil { };

  suil-qt5 = suil.override {
    withQt4 = false;
    withQt5 = true;
  };
  suil-qt4 = suil.override {
    withQt4 = true;
    withQt5 = false;
  };

  sutils = callPackage ../tools/misc/sutils { };

  sword = callPackage ../development/libraries/sword { };

  szip = callPackage ../development/libraries/szip { };

  tachyon = callPackage ../development/libraries/tachyon {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  taglib = callPackage ../development/libraries/taglib { };
  taglib_1_9 = callPackage ../development/libraries/taglib/1.9.nix { };

  taglib_extras = callPackage ../development/libraries/taglib-extras { };

  talloc = callPackage ../development/libraries/talloc {
    python = python2;
  };

  ntdb = callPackage ../development/libraries/ntdb {
    python = python2;
  };

  tdb = callPackage ../development/libraries/tdb {
    python = python2;
  };

  tectonic = callPackage ../tools/typesetting/tectonic {
    harfbuzz = harfbuzzFull;
  };

  tepl = callPackage ../development/libraries/tepl { };

  telepathy-glib = callPackage ../development/libraries/telepathy/glib { };

  telepathy-farstream = callPackage ../development/libraries/telepathy/farstream {};

  telepathy-qt = callPackage ../development/libraries/telepathy/qt { qtbase = qt4; };

  tevent = callPackage ../development/libraries/tevent {
    python = python2;
  };

  tet = callPackage ../development/tools/misc/tet { };

  thrift = callPackage ../development/libraries/thrift {
    inherit (pythonPackages) twisted;
  };

  tinyxml = tinyxml2;

  tinyxml2 = callPackage ../development/libraries/tinyxml/2.6.2.nix { };

  tinyxml-2 = callPackage ../development/libraries/tinyxml-2 { };

  tix = callPackage ../development/libraries/tix { };

  tk = tk-8_6;

  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tnt = callPackage ../development/libraries/tnt { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };

  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  torch = callPackage ../development/libraries/torch {
    openblas = openblasCompat;
  };

  umockdev = callPackage ../development/libraries/umockdev {
    vala = vala_0_40;
  };

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (callPackages ../development/libraries/unixODBCDrivers {});

  ustr = callPackage ../development/libraries/ustr { };

  usbredir = callPackage ../development/libraries/usbredir {
    libusb = libusb1;
  };

  utmps = skawarePackages.utmps;

  ucommon = ucommon_openssl;

  ucommon_openssl = callPackage ../development/libraries/ucommon {
    gnutls = null;
  };

  ucommon_gnutls = lowPrio (ucommon.override {
    openssl = null;
    zlib = null;
    gnutls = gnutls;
  });

  # 3.14 is needed for R V8 module in ../development/r-modules/default.nix
  v8_3_14 = callPackage ../development/libraries/v8/3.14.nix {
    inherit (python2Packages) python gyp;
    cctools = darwin.cctools;
    stdenv = overrideCC stdenv gcc5;
  };

  v8_3_16_14 = callPackage ../development/libraries/v8/3.16.14.nix {
    inherit (python2Packages) python gyp;
    cctools = darwin.cctools;
    stdenv = if stdenv.isDarwin then stdenv else overrideCC stdenv gcc5;
  };

  v8_6_x = callPackage ../development/libraries/v8/6_x.nix {
    inherit (python2Packages) python;
  };

  v8 = callPackage ../development/libraries/v8 ({
    inherit (python2Packages) python gyp;
    icu = icu58; # v8-5.4.232 fails against icu4c-59.1
  } // lib.optionalAttrs stdenv.isLinux {
    # doesn't build with gcc7
    stdenv = overrideCC stdenv gcc6;
  });

  v8_static = lowPrio (self.v8.override { static = true; });

  vaapiIntel = callPackage ../development/libraries/vaapi-intel { };

  vaapiVdpau = callPackage ../development/libraries/vaapi-vdpau { };

  vale = callPackage ../tools/text/vale { };

  vamp = callPackage ../development/libraries/audio/vamp { };

  vc = callPackage ../development/libraries/vc { };

  vc_0_7 = callPackage ../development/libraries/vc/0.7.nix { };

  vid-stab = callPackage ../development/libraries/vid-stab { };

  vrb = callPackage ../development/libraries/vrb { };

  vtk = callPackage ../development/libraries/vtk {
    inherit (darwin) cf-private libobjc;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
                                          IOKit CFNetwork Security ApplicationServices
                                          CoreText IOSurface ImageIO OpenGL GLUT;
  };

  vtkWithQt4 = vtk.override { qtLib = qt4; };

  vxl = callPackage ../development/libraries/vxl {
    libpng = libpng12;
    stdenv = overrideCC stdenv gcc6; # upstream code incompatible with gcc7
  };

  wayland = callPackage ../development/libraries/wayland { };

  wayland_1_9 = callPackage ../development/libraries/wayland/1.9.nix { };

  wayland-protocols = callPackage ../development/libraries/wayland/protocols.nix { };

  webkit = webkitgtk;

  webkitgtk = webkitgtk220x;

  webkitgtk24x-gtk3 = callPackage ../development/libraries/webkitgtk/2.4.nix {
    harfbuzz = harfbuzzFull.override {
      icu = icu58;
    };
    gst-plugins-base = gst_all_1.gst-plugins-base;
    inherit (darwin) libobjc;
  };

  webkitgtk220x = callPackage ../development/libraries/webkitgtk/2.20.nix {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    stdenv = overrideCC stdenv gcc6;
  };

  webkitgtk222x = callPackage ../development/libraries/webkitgtk/2.22.nix {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    stdenv = overrideCC stdenv gcc6;
  };


  webkitgtk24x-gtk2 = webkitgtk24x-gtk3.override {
    withGtk2 = true;
    enableIntrospection = false;
  };

  websocketpp = callPackage ../development/libraries/websocket++ { };

  wt = wt4;
  inherit (callPackages ../development/libraries/wt {})
    wt3
    wt4;

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxwidgets/2.8 {
    inherit (gnome2) GConf;
    withMesa = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;
  };

  wxGTK29 = callPackage ../development/libraries/wxwidgets/2.9 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QuickTime;
    withMesa = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;
  };

  wxGTK30 = callPackage ../development/libraries/wxwidgets/3.0 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit;
    withMesa = lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms;
  };

  wxGTK31 = callPackage ../development/libraries/wxwidgets/3.1 {};

  wxmac = callPackage ../development/libraries/wxwidgets/3.0/mac.nix {
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa Kernel;
    inherit (darwin.stubs) setfile rez derez;
    inherit (darwin) cf-private;
  };

  wxSVG = callPackage ../development/libraries/wxSVG {
    wxGTK = wxGTK30;
  };

  x265 = callPackage ../development/libraries/x265 { };

  inherit (callPackages ../development/libraries/xapian { })
    xapian_1_2_22 xapian_1_4;
  xapian = xapian_1_4;

  xapian-omega = callPackage ../development/libraries/xapian/tools/omega {
    libmagic = file;
  };

  xavs = callPackage ../development/libraries/xavs { };

  Xaw3d = callPackage ../development/libraries/Xaw3d { };

  xbase = callPackage ../development/libraries/xbase { };

  xcb-util-cursor = xorg.xcbutilcursor;
  xcb-util-cursor-HEAD = callPackage ../development/libraries/xcb-util-cursor/HEAD.nix { };

  xcbutilxrm = callPackage ../servers/x11/xorg/xcb-util-xrm.nix { };

  xdo = callPackage ../tools/misc/xdo { };

  xineLib = callPackage ../development/libraries/xine-lib {
    ffmpeg = ffmpeg_2;
  };

  xgboost = callPackage ../development/libraries/xgboost {
    cudaSupport = config.cudaSupport or false;
  };

  # Avoid using this. It isn't really a wrapper anymore, but we keep the name.
  xlibsWrapper = callPackage ../development/libraries/xlibs-wrapper {
    packages = [
      freetype fontconfig xorg.xproto xorg.libX11 xorg.libXt
      xorg.libXft xorg.libXext xorg.libSM xorg.libICE
      xorg.xextproto
    ];
  };

  xmlrpc_c = callPackage ../development/libraries/xmlrpc-c { };

  yubikey-personalization = callPackage ../tools/misc/yubikey-personalization {
    libusb = libusb1;
  };

  yubikey-personalization-gui = libsForQt5.callPackage ../tools/misc/yubikey-personalization-gui { };

  zlib = callPackage ../development/libraries/zlib {
    fetchurl = fetchurlBoot;
  };

  zlibStatic = lowPrio (appendToName "static" (zlib.override {
    static = true;
  }));

  zeromq3 = callPackage ../development/libraries/zeromq/3.x.nix {};
  zeromq4 = callPackage ../development/libraries/zeromq/4.x.nix {};
  zeromq = zeromq4;

  czmq3 = callPackage ../development/libraries/czmq/3.x.nix {};
  czmq4 = callPackage ../development/libraries/czmq/4.x.nix {};
  czmq = czmq4;

  czmqpp = callPackage ../development/libraries/czmqpp {
    czmq = czmq3;
  };

  zmqpp = callPackage ../development/libraries/zmqpp { };

  zig = callPackage ../development/compilers/zig {
    llvmPackages = llvmPackages_7;
  };

  gsignond = callPackage ../development/libraries/gsignond {
    plugins = [];
  };

  gsignondPlugins = {
    sasl = callPackage ../development/libraries/gsignond/plugins/sasl.nix { };
    oauth = callPackage ../development/libraries/gsignond/plugins/oauth.nix { };
    lastfm = callPackage ../development/libraries/gsignond/plugins/lastfm.nix { };
    mail = callPackages ../development/libraries/gsignond/plugins/mail.nix { };
  };

  ### DEVELOPMENT / LIBRARIES / AGDA

  agda = callPackage ../build-support/agda {
    glibcLocales = if pkgs.stdenv.isLinux then pkgs.glibcLocales else null;
    extension = self : super : { };
    inherit (haskellPackages) Agda;
  };

  agdaBase = callPackage ../development/libraries/agda/agda-base { };

  agdaIowaStdlib = callPackage ../development/libraries/agda/agda-iowa-stdlib { };

  agdaPrelude = callPackage ../development/libraries/agda/agda-prelude { };

  AgdaStdlib = callPackage ../development/libraries/agda/agda-stdlib {
    inherit (haskellPackages) ghcWithPackages;
  };

  AgdaSheaves = callPackage ../development/libraries/agda/Agda-Sheaves { };

  categories = callPackage ../development/libraries/agda/categories { };

  pretty = callPackage ../development/libraries/agda/pretty { };

  ### DEVELOPMENT / LIBRARIES / JAVA

  commonsBcel = callPackage ../development/libraries/java/commons/bcel { };

  commonsBsf = callPackage ../development/libraries/java/commons/bsf { };

  commonsCompress = callPackage ../development/libraries/java/commons/compress { };

  commonsFileUpload = callPackage ../development/libraries/java/commons/fileupload { };

  commonsLang = callPackage ../development/libraries/java/commons/lang { };

  commonsLogging = callPackage ../development/libraries/java/commons/logging { };

  commonsIo = callPackage ../development/libraries/java/commons/io { };

  commonsMath = callPackage ../development/libraries/java/commons/math { };

  gwtdragdrop = callPackage ../development/libraries/java/gwt-dragdrop { };

  gwtwidgets = callPackage ../development/libraries/java/gwt-widgets { };

  javaCup = callPackage ../development/libraries/java/cup { };

  junit = callPackage ../development/libraries/java/junit { antBuild = releaseTools.antBuild; };

  lucene = callPackage ../development/libraries/java/lucene { };

  lucenepp = callPackage ../development/libraries/lucene++ {
    boost = boost155;
  };

  saxonb = saxonb_8_8;

  inherit (callPackages ../development/libraries/java/saxon { })
    saxon
    saxonb_8_8
    saxonb_9_1
    saxon-he;

  swt = callPackage ../development/libraries/java/swt {
    inherit (gnome2) libsoup;
  };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  buildBowerComponents = callPackage ../development/bower-modules/generic { };

  ### DEVELOPMENT / GO MODULES

  buildGo19Package = callPackage ../development/go-modules/generic {
    go = go_1_9;
  };
  buildGo110Package = callPackage ../development/go-modules/generic {
    go = go_1_10;
  };
  buildGo111Package = callPackage ../development/go-modules/generic {
    go = go_1_11;
  };

  buildGoPackage = buildGo111Package;

  go2nix = callPackage ../development/tools/go2nix { };

  ws = callPackage ../development/tools/ws { };

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

  lispPackages = recurseIntoAttrs (quicklispPackages_asdf_3_1 //
    lispPackagesFor ((wrapLisp sbcl).override { asdf = asdf_3_1; }));

  quicklispPackagesFor = clwrapper: callPackage ../development/lisp-modules/quicklisp-to-nix.nix {
    inherit clwrapper;
  };
  quicklispPackagesClisp = quicklispPackagesFor (wrapLisp clisp);
  quicklispPackagesSBCL = quicklispPackagesFor (wrapLisp sbcl);
  quicklispPackages = quicklispPackagesSBCL;
  quicklispPackages_asdf_3_1 = quicklispPackagesFor
    ((wrapLisp sbcl).override { asdf = asdf_3_1; });

  ### DEVELOPMENT / PERL MODULES

  perl526Packages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perl526;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });
  # the latest Maint version
  perl528Packages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perl528;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });
  # the latest Devel version
  perldevelPackages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    perl = perldevel;
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });

  perlPackages = perl528Packages;
  inherit (perlPackages) perl;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;

  sqitchPg = callPackage ../development/tools/misc/sqitch {
    name = "sqitch-pg";
    databaseModule = perlPackages.DBDPg;
    sqitchModule = perlPackages.AppSqitch;
  };

  ### DEVELOPMENT / R MODULES

  R = callPackage ../applications/science/math/R {
    # TODO: split docs into a separate output
    texLive = texlive.combine {
      inherit (texlive) scheme-small inconsolata helvetic texinfo fancyvrb cm-super;
    };
    openblas = openblasCompat;
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

  rstudioWrapper = callPackage ../development/r-modules/wrapper-rstudio.nix {
    recommendedPackages = with rPackages; [
      boot class cluster codetools foreign KernSmooth lattice MASS
      Matrix mgcv nlme nnet rpart spatial survival
    ];
    # Override this attribute to register additional libraries.
    packages = [];
  };

  rPackages = callPackage ../development/r-modules {
    overrides = (config.rPackageOverrides or (p: {})) pkgs;
  };

  ### SERVERS

  _389-ds-base = callPackage ../servers/ldap/389 {
    kerberos = libkrb5;
  };

  rdf4store = callPackage ../servers/http/4store { };

  apacheHttpd_2_4 = callPackage ../servers/http/apache-httpd/2.4.nix { };
  apacheHttpd = pkgs.apacheHttpd_2_4;

  apacheHttpdPackagesFor = apacheHttpd: self: let callPackage = newScope self; in {
    inherit apacheHttpd;

    mod_auth_mellon = callPackage ../servers/http/apache-modules/mod_auth_mellon { };

    mod_dnssd = callPackage ../servers/http/apache-modules/mod_dnssd { };

    mod_evasive = callPackage ../servers/http/apache-modules/mod_evasive { };

    mod_perl = callPackage ../servers/http/apache-modules/mod_perl { };

    mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

    mod_python = callPackage ../servers/http/apache-modules/mod_python { };

    mod_wsgi = callPackage ../servers/http/apache-modules/mod_wsgi { };

    php = pkgs.php.override { inherit apacheHttpd; };

    subversion = pkgs.subversion.override { httpServer = true; inherit apacheHttpd; };
  };

  apacheHttpdPackages_2_4 = apacheHttpdPackagesFor pkgs.apacheHttpd_2_4 pkgs.apacheHttpdPackages_2_4;
  apacheHttpdPackages = apacheHttpdPackages_2_4;

  appdaemon = callPackage ../servers/home-assistant/appdaemon.nix { };

  atlassian-confluence = callPackage ../servers/atlassian/confluence.nix { };
  atlassian-crowd = callPackage ../servers/atlassian/crowd.nix { };
  atlassian-jira = callPackage ../servers/atlassian/jira.nix { };

  cassandra_2_1 = callPackage ../servers/nosql/cassandra/2.1.nix { };
  cassandra_2_2 = callPackage ../servers/nosql/cassandra/2.2.nix { };
  cassandra_3_0 = callPackage ../servers/nosql/cassandra/3.0.nix { };
  cassandra_3_11 = callPackage ../servers/nosql/cassandra/3.11.nix { };
  cassandra = cassandra_3_11;

  apache-jena = callPackage ../servers/nosql/apache-jena/binary.nix {
    java = jdk;
  };

  apache-jena-fuseki = callPackage ../servers/nosql/apache-jena/fuseki-binary.nix {
    java = jdk;
  };

  asterisk = asterisk-stable;

  inherit (callPackages ../servers/asterisk { })
    asterisk-stable asterisk-lts;

  bind = callPackage ../servers/dns/bind {
    enablePython = config.bind.enablePython or false;
    python3 = python3.withPackages (ps: with ps; [ ply ]);
  };
  dnsutils = bind.dnsutils;

  inherit (callPackages ../servers/bird { })
    bird bird6 bird2;

  clickhouse = callPackage ../servers/clickhouse {
    inherit (llvmPackages_6) clang-unwrapped lld llvm;
  };

  couchdb = callPackage ../servers/http/couchdb {
    spidermonkey = spidermonkey_1_8_5;
    sphinx = python27Packages.sphinx;
    erlang = erlangR19;
  };

  couchdb2 = callPackage ../servers/http/couchdb/2.0.0.nix {
    spidermonkey = spidermonkey_1_8_5;
  };

  dex-oidc = callPackage ../servers/dex { };

  dict = callPackage ../servers/dict {
      libmaa = callPackage ../servers/dict/libmaa.nix {};
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix {});

  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix {};

  diod = callPackage ../servers/diod { lua = lua5_1; };

  dkimproxy = callPackage ../servers/mail/dkimproxy {
    inherit (perlPackages) Error MailDKIM MIMETools NetServer;
  };

  dovecot = callPackage ../servers/mail/dovecot { };
  dovecot_pigeonhole = callPackage ../servers/mail/dovecot/plugins/pigeonhole { };

  dspam = callPackage ../servers/mail/dspam {
    inherit (perlPackages) libnet;
  };

  etcd = callPackage ../servers/etcd { };

  hyp = callPackage ../servers/http/hyp { };

  prosody = callPackage ../servers/xmpp/prosody {
    # _compat can probably be removed on next minor version after 0.10.0
    lua5 = lua5_2_compat;
    inherit (lua52Packages) luasocket luasec luaexpat luafilesystem luabitop luaevent luadbi;
  };

  eventstore = callPackage ../servers/nosql/eventstore {
    mono = mono46;
    v8 = v8_6_x;
  };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { icu = null; stdenv = overrideCC stdenv gcc5; };
  firebirdSuper = firebird.override { icu = icu58; superServer = true; stdenv = overrideCC stdenv gcc5; };

  freeswitch = callPackage ../servers/sip/freeswitch {
    openssl = openssl_1_0_2;
  };

  fusionInventory = callPackage ../servers/monitoring/fusion-inventory { };

  grafana = callPackage ../servers/monitoring/grafana { };

  grafana_reporter = callPackage ../servers/monitoring/grafana-reporter { };

  hbase = callPackage ../servers/hbase {};

  home-assistant = callPackage ../servers/home-assistant { };

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  rdkafka = callPackage ../development/libraries/rdkafka { };

  livepeer = callPackage ../servers/livepeer { ffmpeg = ffmpeg_3; };

  labelImg = callPackage ../applications/science/machine-learning/labelimg { };

  mattermost = callPackage ../servers/mattermost { };
  matterircd = callPackage ../servers/mattermost/matterircd.nix { };
  meguca = callPackage ../servers/meguca {
    buildGoPackage = buildGo110Package;
  };

  memcached = callPackage ../servers/memcached {};

  minio = callPackage ../servers/minio {
    buildGoPackage = buildGo110Package;
  };

  # Backwards compatibility.
  mod_dnssd = pkgs.apacheHttpdPackages.mod_dnssd;
  mod_fastcgi = pkgs.apacheHttpdPackages.mod_fastcgi;
  mod_python = pkgs.apacheHttpdPackages.mod_python;
  mod_wsgi = pkgs.apacheHttpdPackages.mod_wsgi;

  mpd = callPackage ../servers/mpd {
    aacSupport    = config.mpd.aacSupport or true;
    clientSupport = config.mpd.clientSupport or true;
    ffmpegSupport = config.mpd.ffmpegSupport or true;
    opusSupport   = config.mpd.opusSupport or true;

  };

  mpd_clientlib = callPackage ../servers/mpd/clientlib.nix { };

  miniHttpd = callPackage ../servers/http/mini-httpd {};

  nas = callPackage ../servers/nas { };

  neard = callPackage ../servers/neard { };

  nginx = nginxStable;

  nginxStable = callPackage ../servers/http/nginx/stable.nix {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxMainline = callPackage ../servers/http/nginx/mainline.nix {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.dav nginxModules.moreheaders ];
  };

  nginxModules = callPackage ../servers/http/nginx/modules.nix { };

  # We should move to dynmaic modules and create a nginxFull package with all modules
  nginxShibboleth = nginxStable.override {
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders nginxModules.shibboleth ];
  };

  nsd = callPackage ../servers/dns/nsd (config.nsd or {});

  openafs = callPackage ../servers/openafs/1.6 { tsmbac = null; ncurses = null; };
  openafs_1_8 = callPackage ../servers/openafs/1.8 { tsmbac = null; ncurses = null; };

  opensmtpd = callPackage ../servers/mail/opensmtpd { };
  opensmtpd-extras = callPackage ../servers/mail/opensmtpd/extras.nix { };

  postfix = callPackage ../servers/mail/postfix { };

  pfixtools = callPackage ../servers/mail/postfix/pfixtools.nix {
    gperf = gperf_3_0;
  };
  pflogsumm = callPackage ../servers/mail/postfix/pflogsumm.nix { };

  # PulseAudio daemons

  pulseaudio = callPackage ../servers/pulseaudio {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  pulseaudioFull = pulseaudio.override {
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  # libpulse implementations
  libpulseaudio-vanilla = pulseaudio.override {
    libOnly = true;
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  apulse = callPackage ../misc/apulse { };

  libpressureaudio = callPackage ../misc/apulse/pressureaudio.nix {
    libpulseaudio = libpulseaudio-vanilla; # headers only
  };

  libcardiacarrest = callPackage ../misc/libcardiacarrest {
    libpulseaudio = libpulseaudio-vanilla; # meta only
  };

  libpulseaudio = libpulseaudio-vanilla;

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  mariadb = callPackage ../servers/sql/mariadb {
    asio = asio_1_10;
    inherit (darwin) cctools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };
  mysql = mariadb; # TODO: move to aliases.nix

  mongodb = callPackage ../servers/nosql/mongodb {
    sasl = cyrus_sasl;
    boost = boost160;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  percona-server56 = callPackage ../servers/sql/percona/5.6.x.nix { };
  percona-server = percona-server56;

  riak = callPackage ../servers/nosql/riak/2.2.0.nix {
    erlang = erlang_basho_R16B02;
  };

  riak-cs = callPackage ../servers/nosql/riak-cs/2.1.1.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    erlang = erlang_basho_R16B02;
  };

  stanchion = callPackage ../servers/nosql/riak-cs/stanchion.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    erlang = erlang_basho_R16B02;
  };

  mysql55 = callPackage ../servers/sql/mysql/5.5.x.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mysql57 = callPackage ../servers/sql/mysql/5.7.x.nix {
    inherit (darwin) cctools developer_cmds;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    boost = boost159;
  };

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  nagios = callPackage ../servers/monitoring/nagios { };

  monitoring-plugins = callPackage ../servers/monitoring/plugins { };

  inherit (callPackage ../servers/monitoring/plugins/labs_consol_de.nix { inherit (perlPackages) DBDsybase NetSNMP; })
    check-mssql-health
    check-nwc-health
    check-ups-health;

  checkSSLCert = callPackage ../servers/monitoring/nagios/plugins/check_ssl_cert.nix { };

  check-esxi-hardware = callPackage ../servers/monitoring/plugins/esxi.nix {};

  net_snmp = callPackage ../servers/monitoring/net-snmp { };

  riemann = callPackage ../servers/monitoring/riemann { };
  oracleXE = callPackage ../servers/sql/oracle-xe { };

  softether_4_18 = callPackage ../servers/softether/4.18.nix { };
  softether_4_20 = callPackage ../servers/softether/4.20.nix { };
  softether_4_25 = callPackage ../servers/softether/4.25.nix { };
  softether = softether_4_25;

  qboot = pkgsi686Linux.callPackage ../applications/virtualization/qboot { };

  OVMF = callPackage ../applications/virtualization/OVMF { seabios = null; openssl = null; };
  OVMF-CSM = OVMF.override { openssl = null; };
  #WIP: OVMF-secureBoot = OVMF.override { seabios = null; secureBoot = true; };

  seabios = callPackage ../applications/virtualization/seabios { };

  pgpool93 = pgpool.override { postgresql = postgresql_9_3; };
  pgpool94 = pgpool.override { postgresql = postgresql_9_4; };

  pgpool = callPackage ../servers/sql/pgpool {
    pam = if stdenv.isLinux then pam else null;
    libmemcached = null; # Detection is broken upstream
  };

  postgresql = postgresql_9_6;

  inherit (callPackages ../servers/sql/postgresql { })
    postgresql_9_3
    postgresql_9_4
    postgresql_9_5
    postgresql_9_6
    postgresql_10
    postgresql_11;

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  inherit (callPackage ../servers/monitoring/prometheus {
    buildGoPackage = buildGo110Package;
  })
      prometheus_1
      prometheus_2
      ;

  prom2json = callPackage ../servers/monitoring/prometheus/prom2json.nix { };
  prometheus = prometheus_1;
  prometheus-alertmanager = callPackage ../servers/monitoring/prometheus/alertmanager.nix { };
  prometheus-bind-exporter = callPackage ../servers/monitoring/prometheus/bind-exporter.nix { };
  prometheus-blackbox-exporter = callPackage ../servers/monitoring/prometheus/blackbox-exporter.nix { };
  prometheus-collectd-exporter = callPackage ../servers/monitoring/prometheus/collectd-exporter.nix { };
  prometheus-consul-exporter = callPackage ../servers/monitoring/prometheus/consul-exporter.nix { };
  prometheus-dnsmasq-exporter = callPackage ../servers/monitoring/prometheus/dnsmasq-exporter.nix { };
  prometheus-dovecot-exporter = callPackage ../servers/monitoring/prometheus/dovecot-exporter.nix { };
  prometheus-fritzbox-exporter = callPackage ../servers/monitoring/prometheus/fritzbox-exporter.nix { };
  prometheus-haproxy-exporter = callPackage ../servers/monitoring/prometheus/haproxy-exporter.nix { };
  prometheus-json-exporter = callPackage ../servers/monitoring/prometheus/json-exporter.nix { };
  prometheus-mesos-exporter = callPackage ../servers/monitoring/prometheus/mesos-exporter.nix { };
  prometheus-minio-exporter = callPackage ../servers/monitoring/prometheus/minio-exporter { };
  prometheus-mysqld-exporter = callPackage ../servers/monitoring/prometheus/mysqld-exporter.nix { };
  prometheus-nginx-exporter = callPackage ../servers/monitoring/prometheus/nginx-exporter.nix { };
  prometheus-node-exporter = callPackage ../servers/monitoring/prometheus/node-exporter.nix { };
  prometheus-openvpn-exporter = callPackage ../servers/monitoring/prometheus/openvpn-exporter.nix { };
  prometheus-postfix-exporter = callPackage ../servers/monitoring/prometheus/postfix-exporter.nix { };
  prometheus-pushgateway = callPackage ../servers/monitoring/prometheus/pushgateway.nix { };
  prometheus-rabbitmq-exporter = callPackage ../servers/monitoring/prometheus/rabbitmq-exporter.nix { };
  prometheus-snmp-exporter = callPackage ../servers/monitoring/prometheus/snmp-exporter.nix {
    buildGoPackage = buildGo110Package;
  };
  prometheus-tor-exporter = callPackage ../servers/monitoring/prometheus/tor-exporter.nix { };
  prometheus-statsd-exporter = callPackage ../servers/monitoring/prometheus/statsd-bridge.nix { };
  prometheus-surfboard-exporter = callPackage ../servers/monitoring/prometheus/surfboard-exporter.nix { };
  prometheus-unifi-exporter = callPackage ../servers/monitoring/prometheus/unifi-exporter { };
  prometheus-varnish-exporter = callPackage ../servers/monitoring/prometheus/varnish-exporter.nix { };
  prometheus-jmx-httpserver = callPackage ../servers/monitoring/prometheus/jmx-httpserver.nix {  };

  pypolicyd-spf = python3.pkgs.callPackage ../servers/mail/pypolicyd-spf { };

  qpid-cpp = callPackage ../servers/amqp/qpid-cpp {
    boost = boost155;
    inherit (pythonPackages) buildPythonPackage qpid-python;
  };

  rabbitmq-server = callPackage ../servers/amqp/rabbitmq-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon Cocoa;
    elixir = elixir_1_6;
    erlang = erlang_nox;
  };

  radicale1 = callPackage ../servers/radicale/1.x.nix { };
  radicale2 = callPackage ../servers/radicale { };

  radicale = radicale2;

  rake = callPackage ../development/tools/build-managers/rake { };

  redis = callPackage ../servers/nosql/redis { };

  restic = callPackage ../tools/backup/restic { };

  restic-rest-server = callPackage ../tools/backup/restic/rest-server.nix { };

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    libtool = darwin.cctools;
  };

  rippled = callPackage ../servers/rippled {
    boost = boost159;
  };

  s6 = skawarePackages.s6;

  s6-rc = skawarePackages.s6-rc;

  spamassassin = callPackage ../servers/mail/spamassassin {
    inherit (perlPackages) HTMLParser NetDNS NetAddrIP DBFile
      HTTPDate MailDKIM LWP IOSocketSSL;
  };

  deadpixi-sam-unstable = callPackage ../applications/editors/deadpixi-sam { };
  deadpixi-sam = deadpixi-sam-unstable;

  samba3 = callPackage ../servers/samba/3.x.nix { };

  samba4 = callPackage ../servers/samba/4.x.nix {
    python = python2;
  };

  sambaMaster = callPackage ../servers/samba/master.nix { };

  samba = samba4;

  # A lightweight Samba 3, useful for non-Linux-based OSes.
  samba3_light = lowPrio (samba3.override {
    pam = null;
    fam = null;
    cups = null;
    acl = null;
    openldap = null;
    # libunwind 1.0.1 is not ported to GNU/Hurd.
    libunwind = null;
  });

  samba4Full = lowPrio (samba4.override {
    enableLDAP = true;
    enablePrinting = true;
    enableMDNS = true;
    enableDomainController = true;
    enableRegedit = true;
    enableCephFS = true;
    enableGlusterFS = true;
  });

  sambaFull = samba4Full;

  serfdom = callPackage ../servers/serf { };

  shishi = callPackage ../servers/shishi {
      pam = if stdenv.isLinux then pam else null;
      # see also openssl, which has/had this same trick
  };

  sickbeard = callPackage ../servers/sickbeard { };

  sickgear = callPackage ../servers/sickbeard/sickgear.nix { };

  sickrage = callPackage ../servers/sickbeard/sickrage.nix { };

  spawn_fcgi = callPackage ../servers/http/spawn-fcgi { };

  squid = callPackage ../servers/squid { };
  squid4 = callPackage ../servers/squid/4.nix { };

  storm = callPackage ../servers/computing/storm { };

  slurm = callPackage ../servers/computing/slurm { gtk2 = null; };

  inherit (callPackages ../servers/http/tomcat { })
    tomcat7
    tomcat8
    tomcat85
    tomcat9;

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  tt-rss = callPackage ../servers/tt-rss { };
  tt-rss-plugin-tumblr-gdpr = callPackage ../servers/tt-rss/plugin-tumblr-gdpr { };
  tt-rss-theme-feedly = callPackage ../servers/tt-rss/theme-feedly { };

  shaarli = callPackage ../servers/web-apps/shaarli { };

  shaarli-material = callPackage ../servers/web-apps/shaarli/material-theme.nix { };

  inherit (callPackages ../servers/unifi { })
    unifiLTS
    unifiStable
    unifiTesting;
  unifi = unifiStable;

  virtlyst = libsForQt5.callPackage ../servers/web-apps/virtlyst { };

  virtuoso6 = callPackage ../servers/sql/virtuoso/6.x.nix { };

  virtuoso7 = callPackage ../servers/sql/virtuoso/7.x.nix { };

  virtuoso = virtuoso6;

  zookeeper = callPackage ../servers/zookeeper { };

  xquartz = callPackage ../servers/x11/xquartz {
    inherit (darwin) cf-private;
  };

  quartz-wm = callPackage ../servers/x11/quartz-wm {
    stdenv = clangStdenv;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

  # Use `lib.callPackageWith __splicedPackages` rather than plain `callPackage`
  # so as not to have the newly bound xorg items already in scope,  which would
  # have created a cycle.
  xorg = recurseIntoAttrs ((lib.callPackageWith __splicedPackages ../servers/x11/xorg {
  }).overrideScope' (lib.callPackageWith __splicedPackages ../servers/x11/xorg/overrides.nix {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa;
    inherit (darwin.apple_sdk.libs) Xplugin;
    bootstrap_cmds = if stdenv.isDarwin then darwin.bootstrap_cmds else null;
    python = python2; # Incompatible with Python 3x
    udev = if stdenv.isLinux then udev else null;
    libdrm = if stdenv.isLinux then libdrm else null;
    abiCompat = config.xorg.abiCompat # `config` because we have no `xorg.override`
      or (if stdenv.isDarwin then "1.18" else null); # 1.19 needs fixing on Darwin
  }) // { inherit xlibsWrapper; } );

  xwayland = callPackage ../servers/x11/xorg/xwayland.nix { };

  yaws = callPackage ../servers/http/yaws {
    erlang = erlangR18;
  };

  youtrack = callPackage ../servers/jetbrains/youtrack.nix { };

  zabbix = recurseIntoAttrs (callPackages ../servers/monitoring/zabbix {});

  zabbix20 = callPackage ../servers/monitoring/zabbix/2.0.nix { };
  zabbix22 = callPackage ../servers/monitoring/zabbix/2.2.nix { };
  zabbix34 = callPackage ../servers/monitoring/zabbix/3.4.nix { };

  ### OS-SPECIFIC

  autofs5 = callPackage ../os-specific/linux/autofs { };

  _915resolution = callPackage ../os-specific/linux/915resolution { };

  nfs-utils = callPackage ../os-specific/linux/nfs-utils { };

  acpi = callPackage ../os-specific/linux/acpi { };

  alfred = callPackage ../os-specific/linux/batman-adv/alfred.nix { };

  alsaLib = callPackage ../os-specific/linux/alsa-lib { };

  alsaPlugins = callPackage ../os-specific/linux/alsa-plugins { };

  alsaPluginWrapper = callPackage ../os-specific/linux/alsa-plugins/wrapper.nix { };

  alsaUtils = callPackage ../os-specific/linux/alsa-utils { };
  alsaOss = callPackage ../os-specific/linux/alsa-oss { };
  alsaTools = callPackage ../os-specific/linux/alsa-tools { };

  inherit (callPackage ../misc/arm-trusted-firmware {})
    buildArmTrustedFirmware
    armTrustedFirmwareAllwinner
    armTrustedFirmwareQemu
    armTrustedFirmwareRK3328
    ;

  microcodeAmd = callPackage ../os-specific/linux/microcode/amd.nix { };

  microcodeIntel = callPackage ../os-specific/linux/microcode/intel.nix { };

  iucode-tool = callPackage ../os-specific/linux/microcode/iucode-tool.nix { };

  inherit (callPackages ../os-specific/linux/apparmor { python = python3; })
    libapparmor apparmor-utils apparmor-bin-utils apparmor-parser apparmor-pam
    apparmor-profiles apparmor-kernel-patches;

  atop = callPackage ../os-specific/linux/atop { };

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43Firmware_6_30_163_46 = callPackage ../os-specific/linux/firmware/b43-firmware/6.30.163.46.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  bluez5 = callPackage ../os-specific/linux/bluez { };

  bluez = bluez5;

  inherit (python3Packages) bedup;

  busybox = callPackage ../os-specific/linux/busybox { };
  busybox-sandbox-shell = callPackage ../os-specific/linux/busybox/sandbox-shell.nix { };

  conky = callPackage ../os-specific/linux/conky ({
    lua = lua5_1; # conky can use 5.2, but toluapp can not
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
    pulseSupport = config.pulseaudio or false;
  } // config.conky or {});

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  # Darwin package set
  #
  # Even though this is a set of packages not single package, use `callPackage`
  # not `callPackages` so the per-package callPackages don't have their
  # `.override` clobbered. C.F. `llvmPackages` which does the same.
  darwin = callPackage ./darwin-packages.nix { };

  disk_indicator = callPackage ../os-specific/linux/disk-indicator { };

  displaylink = callPackage ../os-specific/linux/displaylink {
    inherit (linuxPackages) evdi;
  };

  dmraid = callPackage ../os-specific/linux/dmraid {
    lvm2 = lvm2.override {enable_dmeventd = true;};
  };

  # unstable until the first 1.x release
  fscrypt-experimental = callPackage ../os-specific/linux/fscrypt {
    buildGoPackage = buildGo110Package;
  };
  fscryptctl-experimental = callPackage ../os-specific/linux/fscryptctl { };

  fwupd = callPackage ../os-specific/linux/firmware/fwupd { };

  libossp_uuid = callPackage ../development/libraries/libossp-uuid { };

  libuuid = if stdenv.isLinux
    then utillinuxMinimal
    else null;

  light = callPackage ../os-specific/linux/light { };

  ffado = callPackage ../os-specific/linux/ffado {
    inherit (python2Packages) python pyqt4 dbus-python;
  };
  libffado = ffado.override { prefix = "lib"; };

  freefall = callPackage ../os-specific/linux/freefall {
    inherit (linuxPackages) kernel;
  };

  fusePackages = callPackage ../os-specific/linux/fuse {
    utillinux = utillinuxMinimal;
  };
  fuse = lowPrio fusePackages.fuse_2;
  fuse3 = fusePackages.fuse_3;
  fuse-common = hiPrio fusePackages.fuse_3.common;

  fusionio-util = callPackage ../os-specific/linux/fusionio/util.nix { };

  gpm = callPackage ../servers/gpm {
    ncurses = null;  # Keep curses disabled for lack of value
  };

  gpm-ncurses = gpm.override { inherit ncurses; };

  htop = callPackage ../tools/system/htop {
    inherit (darwin) IOKit;
  };

  i7z = qt5.callPackage ../os-specific/linux/i7z { };

  pcm = callPackage ../os-specific/linux/pcm { };

  iptstate = callPackage ../os-specific/linux/iptstate { } ;

  iw = callPackage ../os-specific/linux/iw { };

  jfbview = callPackage ../os-specific/linux/jfbview { };
  jfbpdf = jfbview.override {
    imageSupport = false;
  };

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  kbd = callPackage ../os-specific/linux/kbd { };

  kbdKeymaps = callPackage ../os-specific/linux/kbd/keymaps.nix { };

  kmsxx = callPackage ../development/libraries/kmsxx {
    stdenv = overrideCC stdenv gcc6;
  };

  ldm = callPackage ../os-specific/linux/ldm { };

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  openiscsi = callPackage ../os-specific/linux/open-iscsi { };

  openisns = callPackage ../os-specific/linux/open-isns { };

  tgt = callPackage ../tools/networking/tgt { };

  # -- Linux kernel expressions ------------------------------------------------

  inherit (callPackages ../os-specific/linux/kernel-headers { })
    linuxHeaders;

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  klibc = callPackage ../os-specific/linux/klibc { };

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  linux_mptcp = linux_mptcp_94;
  linux_mptcp_94 = callPackage ../os-specific/linux/kernel/linux-mptcp.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ]
      ++ lib.optionals ((stdenv.hostPlatform.platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_mptcp_93 = callPackage ../os-specific/linux/kernel/linux-mptcp-93.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.p9_fixes
        kernelPatches.cpu-cgroup-v2."4.9"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_rpi = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
    ];
  };

  linux_4_4 = callPackage ../os-specific/linux/kernel/linux-4.4.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.4"
        kernelPatches.modinst_arg_list_too_long
        # https://github.com/NixOS/nixpkgs/issues/42755
        # Remove these xen-netfront patches once they're included in
        # upstream! Fixes https://github.com/NixOS/nixpkgs/issues/42755
        kernelPatches.xen-netfront_fix_mismatched_rtnl_unlock
        kernelPatches.xen-netfront_update_features_after_registering_netdev
      ];
  };

  linux_4_9 = callPackage ../os-specific/linux/kernel/linux-4.9.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.9"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_4_14 = callPackage ../os-specific/linux/kernel/linux-4.14.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_4_18 = callPackage ../os-specific/linux/kernel/linux-4.18.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        # kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_4_19 = callPackage ../os-specific/linux/kernel/linux-4.19.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        # kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_testing = callPackage ../os-specific/linux/kernel/linux-testing.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.modinst_arg_list_too_long
    ];
  };

  linux_testing_bcachefs = callPackage ../os-specific/linux/kernel/linux-testing-bcachefs.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_hardkernel_4_14 = callPackage ../os-specific/linux/kernel/linux-hardkernel-4.14.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.modinst_arg_list_too_long
    ];
  };

  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit kernel;
    inherit (kernel) stdenv; # in particular, use the same compiler by default

    # Obsolete aliases (these packages do not depend on the kernel).
    inherit (pkgs) odp-dpdk pktgen; # added 2018-05

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    amdgpu-pro = callPackage ../os-specific/linux/amdgpu-pro { };

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bcc = callPackage ../os-specific/linux/bcc {
      python = python3;
    };

    bpftrace = callPackage ../os-specific/linux/bpftrace { };

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    beegfs-module = callPackage ../os-specific/linux/beegfs/kernel-module.nix { };

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    blcr = callPackage ../os-specific/linux/blcr { };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    dpdk = callPackage ../os-specific/linux/dpdk { };

    exfat-nofuse = callPackage ../os-specific/linux/exfat { };

    evdi = callPackage ../os-specific/linux/evdi { };

    hyperv-daemons = callPackage ../os-specific/linux/hyperv-daemons { };

    e1000e = callPackage ../os-specific/linux/e1000e {};

    ixgbevf = callPackage ../os-specific/linux/ixgbevf {};

    ena = callPackage ../os-specific/linux/ena {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    fusionio-vsl = callPackage ../os-specific/linux/fusionio/vsl.nix { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta { };

    tbs = callPackage ../os-specific/linux/tbs { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidiaPackages = callPackage ../os-specific/linux/nvidia-x11 { };

    nvidia_x11_legacy304 = nvidiaPackages.legacy_304;
    nvidia_x11_legacy340 = nvidiaPackages.legacy_340;
    nvidia_x11_beta      = nvidiaPackages.beta;
    nvidia_x11           = nvidiaPackages.stable;

    ply = callPackage ../os-specific/linux/ply { };

    r8168 = callPackage ../os-specific/linux/r8168 { };

    rtl8192eu = callPackage ../os-specific/linux/rtl8192eu { };

    rtl8723bs = callPackage ../os-specific/linux/rtl8723bs { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    rtl8814au = callPackage ../os-specific/linux/rtl8814au { };

    rtlwifi_new = callPackage ../os-specific/linux/rtlwifi_new { };

    openafs = callPackage ../servers/openafs/1.6/module.nix { };
    openafs_1_8 = callPackage ../servers/openafs/1.8/module.nix { };

    facetimehd = callPackage ../os-specific/linux/facetimehd { };

    jool = callPackage ../os-specific/linux/jool { };

    mba6x_bl = callPackage ../os-specific/linux/mba6x_bl { };

    mwprocapture = callPackage ../os-specific/linux/mwprocapture { };

    mxu11x0 = callPackage ../os-specific/linux/mxu11x0 { };

    /* compiles but has to be integrated into the kernel somehow
       Let's have it uncommented and finish it..
    */
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    netatop = callPackage ../os-specific/linux/netatop { };

    perf = callPackage ../os-specific/linux/kernel/perf.nix { };

    phc-intel = callPackage ../os-specific/linux/phc-intel { };

    prl-tools = callPackage ../os-specific/linux/prl-tools { };

    sch_cake = callPackage ../os-specific/linux/sch_cake { };

    spl = callPackage ../os-specific/linux/spl { };

    sysdig = callPackage ../os-specific/linux/sysdig {};

    systemtap = callPackage ../development/tools/profiling/systemtap { };

    tmon = callPackage ../os-specific/linux/tmon { };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    usbip = callPackage ../os-specific/linux/usbip { };

    v86d = callPackage ../os-specific/linux/v86d { };

    vhba = callPackage ../misc/emulators/cdemu/vhba.nix { };

    virtualbox = callPackage ../os-specific/linux/virtualbox {
      virtualbox = pkgs.virtualboxHardened;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions {
      virtualbox = pkgs.virtualboxHardened;
    };

    wireguard = callPackage ../os-specific/linux/wireguard { };

    x86_energy_perf_policy = callPackage ../os-specific/linux/x86_energy_perf_policy { };

    inherit (callPackage ../os-specific/linux/zfs {
      configFile = "kernel";
      inherit kernel spl;
     }) zfsStable zfsUnstable;

     zfs = zfsStable;

     can-isotp = callPackage ../os-specific/linux/can-isotp { };
  });

  # The current default kernel / kernel modules.
  linuxPackages = linuxPackages_4_14;
  linux = linuxPackages.kernel;

  # Update this when adding the newest kernel major version!
  linuxPackages_latest = linuxPackages_4_19;
  linux_latest = linuxPackages_latest.kernel;

  # Build the kernel modules for the some of the kernels.
  linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_rpi = linuxPackagesFor pkgs.linux_rpi;
  linuxPackages_4_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_4);
  linuxPackages_4_9 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_9);
  linuxPackages_4_14 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_14);
  linuxPackages_4_18 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_18);
  linuxPackages_4_19 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_19);
  # Don't forget to update linuxPackages_latest!

  # Intentionally lacks recurseIntoAttrs, as -rc kernels will quite likely break out-of-tree modules and cause failed Hydra builds.
  linuxPackages_testing = linuxPackagesFor pkgs.linux_testing;

  linuxPackages_custom = { version, src, configfile, allowImportFromDerivation ? true }:
    recurseIntoAttrs (linuxPackagesFor (pkgs.linuxManualConfig {
      inherit version src configfile stdenv allowImportFromDerivation;
    }));

  # This serves as a test for linuxPackages_custom
  linuxPackages_custom_tinyconfig_kernel = let
    base = pkgs.linuxPackages.kernel;
    tinyLinuxPackages = pkgs.linuxPackages_custom {
      inherit (base) version src;
      allowImportFromDerivation = false;
      configfile = pkgs.linuxConfig {
        makeTarget = "tinyconfig";
        src = base.src;
      };
    };
    in tinyLinuxPackages.kernel;

  # Build a kernel with bcachefs module
  linuxPackages_testing_bcachefs = recurseIntoAttrs (linuxPackagesFor pkgs.linux_testing_bcachefs);

  # Build a kernel for Xen dom0
  linuxPackages_xen_dom0 = recurseIntoAttrs (linuxPackagesFor (pkgs.linux.override { features.xen_dom0=true; }));

  linuxPackages_latest_xen_dom0 = recurseIntoAttrs (linuxPackagesFor (pkgs.linux_latest.override { features.xen_dom0=true; }));

  # Hardened linux
  hardenedLinuxPackagesFor = kernel: linuxPackagesFor (kernel.override {
    extraConfig = import ../os-specific/linux/kernel/hardened-config.nix {
      inherit stdenv;
      inherit (kernel) version;
    };
  });

  linuxPackages_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor pkgs.linux);
  linux_hardened = linuxPackages_hardened.kernel;

  linuxPackages_latest_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor pkgs.linux_latest);
  linux_latest_hardened = linuxPackages_latest_hardened.kernel;

  linuxPackages_testing_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor pkgs.linux_testing);
  linux_testing_hardened = linuxPackages_testing_hardened.kernel;

  linuxPackages_xen_dom0_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor (pkgs.linux.override { features.xen_dom0=true; }));

  linuxPackages_latest_xen_dom0_hardened = recurseIntoAttrs (hardenedLinuxPackagesFor (pkgs.linux_latest.override { features.xen_dom0=true; }));

  # Hardkernel (Odroid) kernels.
  linuxPackages_hardkernel_4_14 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_hardkernel_4_14);
  linuxPackages_hardkernel_latest = linuxPackages_hardkernel_4_14;
  linux_hardkernel_latest = linuxPackages_hardkernel_latest.kernel;

  # GNU Linux-libre kernels
  linuxPackages-libre = recurseIntoAttrs (linuxPackagesFor linux-libre);
  linux-libre = callPackage ../os-specific/linux/kernel/linux-libre.nix {};
  linuxPackages_latest-libre = recurseIntoAttrs (linuxPackagesFor linux_latest-libre);
  linux_latest-libre = linux-libre.override { linux = linux_latest; };

  # A function to build a manually-configured kernel
  linuxManualConfig = makeOverridable (callPackage ../os-specific/linux/kernel/manual-config.nix {});

  # Derive one of the default .config files
  linuxConfig = { src, makeTarget ? "defconfig", name ? "kernel.config" }:
    stdenv.mkDerivation {
      inherit name src;
      buildPhase = ''
        set -x
        make ${makeTarget}
      '';
      installPhase = ''
        cp .config $out
      '';
    };

  buildLinux = attrs: callPackage ../os-specific/linux/kernel/generic.nix attrs;

  dpdk = callPackage ../os-specific/linux/dpdk {
    kernel = null; # dpdk modules are in linuxPackages.dpdk.kmod
  };

  # Using fetchurlBoot because this is used by kerberos (on Linux), which curl depends on
  keyutils = callPackage ../os-specific/linux/keyutils { fetchurl = fetchurlBoot; };

  libselinux = callPackage ../os-specific/linux/libselinux { };

  libsemanage = callPackage ../os-specific/linux/libsemanage { };

  libraw = callPackage ../development/libraries/libraw { };

  libsexy = callPackage ../development/libraries/libsexy { };

  lm_sensors = callPackage ../os-specific/linux/lm-sensors { };

  kmod = callPackage ../os-specific/linux/kmod { };

  libcap = callPackage ../os-specific/linux/libcap { };

  libcap_ng = callPackage ../os-specific/linux/libcap-ng {
    swig = null; # Currently not using the python2/3 bindings
    python2 = null; # Currently not using the python2 bindings
    python3 = null; # Currently not using the python3 bindings
  };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  mdadm = mdadm4;
  mdadm4 = callPackage ../os-specific/linux/mdadm { };

  aggregateModules = modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit modules;
    };

  musl = callPackage ../os-specific/linux/musl { };

  nettools = if stdenv.isLinux then callPackage ../os-specific/linux/net-tools { }
             else unixtools.nettools;

  open-vm-tools = callPackage ../applications/virtualization/open-vm-tools {
    inherit (gnome3) gtk gtkmm;
  };
  open-vm-tools-headless = open-vm-tools.override { withX = false; };

  dep = callPackage ../development/tools/dep { };

  go-bindata = callPackage ../development/tools/go-bindata { };

  gocode = callPackage ../development/tools/gocode { };

  go-langserver = callPackage ../development/tools/go-langserver {
    buildGoPackage = buildGo110Package;
  };

  impl = callPackage ../development/tools/impl { };

  linux-pam = callPackage ../os-specific/linux/pam { };

  odp-dpdk = callPackage ../os-specific/linux/odp-dpdk { };

  openpam = callPackage ../development/libraries/openpam { };

  pam = if stdenv.isLinux then linux-pam else openpam;

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_ldap = callPackage ../os-specific/linux/pam_ldap { };

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils {
    firmware = config.pcmciaUtils.firmware or [];
    config = config.pcmciaUtils.config or null;
  };

  pktgen = callPackage ../os-specific/linux/pktgen { };

  plymouth = callPackage ../os-specific/linux/plymouth { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  procps = if stdenv.isLinux then callPackage ../os-specific/linux/procps-ng { }
           else unixtools.procps;

  qemu_kvm = lowPrio (qemu.override { hostCpuOnly = true; });

  # See `xenPackages` source for explanations.
  # Building with `xen` instead of `xen-slim` is possible, but makes no sense.
  qemu_xen = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen-slim; });
  qemu_xen-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen-light; });
  qemu_xen_4_8 = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_8-slim; });
  qemu_xen_4_8-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_8-light; });
  qemu_xen_4_10 = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_10-slim; });
  qemu_xen_4_10-light = lowPrio (qemu.override { hostCpuOnly = true; xenSupport = true; xen = xen_4_10-light; });

  qemu_test = lowPrio (qemu.override { hostCpuOnly = true; nixosTestRunner = true; });

  firmwareLinuxNonfree = callPackage ../os-specific/linux/firmware/firmware-linux-nonfree { };

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi {};
  raspberrypiWirelessFirmware = callPackage ../os-specific/linux/firmware/raspberrypi-wireless { };

  raspberrypi-tools = callPackage ../os-specific/linux/firmware/raspberrypi/tools.nix {};

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  riscv-pk = callPackage ../misc/riscv-pk { };

  riscv-pk-with-kernel = riscv-pk.override {
    payload = "${linux_riscv}/vmlinux";
  };

  rt5677-firmware = callPackage ../os-specific/linux/firmware/rt5677 { };

  sass = callPackage ../development/tools/sass { };

  shadow = callPackage ../os-specific/linux/shadow { };

  sinit = callPackage ../os-specific/linux/sinit {
    rcinit = "/etc/rc.d/rc.init";
    rcshutdown = "/etc/rc.d/rc.shutdown";
  };

  smem = callPackage ../os-specific/linux/smem { };

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # pkgs.sysdig is a client, for a driver look at linuxPackagesFor

  systemd = callPackage ../os-specific/linux/systemd {
    utillinux = utillinuxMinimal; # break the cyclic dependency
  };
  udev = systemd; # TODO: move to aliases.nix

  # standalone cryptsetup generator for systemd
  systemd-cryptsetup-generator = callPackage ../os-specific/linux/systemd/cryptsetup-generator.nix { };

  # In nixos, you can set systemd.package = pkgs.systemd_with_lvm2 to get
  # LVM2 working in systemd.
  systemd_with_lvm2 = pkgs.appendToName "with-lvm2" (pkgs.lib.overrideDerivation pkgs.systemd (p: {
      postInstall = p.postInstall + ''
        cp "${pkgs.lvm2}/lib/systemd/system-generators/"* $out/lib/systemd/system-generators
      '';
  }));

  sysvinit = callPackage ../os-specific/linux/sysvinit { };

  sysvtools = sysvinit.override {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcp_wrappers = callPackage ../os-specific/linux/tcp-wrappers { };

  twa = callPackage ../tools/networking/twa { };

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot {})
    buildUBoot
    ubootTools
    ubootA20OlinuxinoLime
    ubootBananaPi
    ubootBeagleboneBlack
    ubootClearfog
    ubootGuruplug
    ubootJetsonTK1
    ubootNovena
    ubootOdroidXU3
    ubootOrangePiPc
    ubootOrangePiZeroPlus2H5
    ubootPcduino3Nano
    ubootPine64
    ubootQemuAarch64
    ubootQemuArm
    ubootRaspberryPi
    ubootRaspberryPi2
    ubootRaspberryPi3_32bit
    ubootRaspberryPi3_64bit
    ubootRaspberryPiZero
    ubootSheevaplug
    ubootSopine
    ubootUtilite
    ubootWandboard
    ;

  # Non-upstream U-Boots:
  ubootNanonote = callPackage ../misc/uboot/nanonote.nix { };

  ubootRock64 = callPackage ../misc/uboot/rock64.nix { };

  uclibc = callPackage ../os-specific/linux/uclibc { };

  uclibcCross = callPackage ../os-specific/linux/uclibc {
    stdenv = crossLibcStdenv;
  };

  udisks1 = callPackage ../os-specific/linux/udisks/1-default.nix { };
  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks2;

  udisks_glue = callPackage ../os-specific/linux/udisks-glue { };

  upower = callPackage ../os-specific/linux/upower { };

  usbguard = libsForQt5.callPackage ../os-specific/linux/usbguard {
    libgcrypt = null;
  };

  utillinux = if stdenv.isLinux then callPackage ../os-specific/linux/util-linux { }
              else unixtools.utillinux;

  utillinuxCurses = utillinux;

  utillinuxMinimal = if stdenv.isLinux then appendToName "minimal" (utillinux.override {
    minimal = true;
    ncurses = null;
    perl = null;
    systemd = null;
  }) else utillinux;

  v4l_utils = qt5.callPackage ../os-specific/linux/v4l-utils { };

  windows = callPackages ../os-specific/windows {};

  wirelesstools = callPackage ../os-specific/linux/wireless-tools { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant { };

  wpa_supplicant_gui = libsForQt5.callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  xf86_input_mtrack = callPackage ../os-specific/linux/xf86-input-mtrack { };

  xf86_input_multitouch = callPackage ../os-specific/linux/xf86-input-multitouch { };

  xf86_input_wacom = callPackage ../os-specific/linux/xf86-input-wacom { };

  xf86_video_nested = callPackage ../os-specific/linux/xf86-video-nested { };

  xorg_sys_opengl = callPackage ../os-specific/linux/opengl/xorg-sys { };

  zd1211fw = callPackage ../os-specific/linux/firmware/zd1211 { };

  inherit (callPackage ../os-specific/linux/zfs {
    configFile = "user";
  }) zfsStable zfsUnstable;

  zfs = zfsStable;

  ### DATA

  anonymousPro = callPackage ../data/fonts/anonymous-pro { };

  arkpandora_ttf = callPackage ../data/fonts/arkpandora { };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

  inherit (kdeFrameworks) breeze-icons;

  carlito = callPackage ../data/fonts/carlito {};

  coreclr = callPackage ../development/compilers/coreclr {
    debug = config.coreclr.debug or false;
  };

  cm_unicode = callPackage ../data/fonts/cm-unicode {};

  dejavu_fonts = lowPrio (callPackage ../data/fonts/dejavu-fonts {});

  # solve collision for nix-env before https://github.com/NixOS/nix/pull/815
  dejavu_fontsEnv = buildEnv {
    name = "${dejavu_fonts.name}";
    paths = [ dejavu_fonts.out ];
  };

  dina-font = callPackage ../data/fonts/dina { };

  dina-font-pcf = callPackage ../data/fonts/dina-pcf { };

  docbook5 = callPackage ../data/sgml+xml/schemas/docbook-5.0 { };

  docbook_sgml_dtd_31 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/3.1.nix { };

  docbook_sgml_dtd_41 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/4.1.nix { };

  docbook_xml_dtd_412 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix { };

  docbook_xml_dtd_42 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix { };

  docbook_xml_dtd_43 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix { };

  docbook_xml_dtd_44 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.4.nix { };

  docbook_xml_dtd_45 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix { };

  docbook_xml_ebnf_dtd = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf { };

  inherit (callPackages ../data/sgml+xml/stylesheets/xslt/docbook-xsl { })
    docbook_xsl
    docbook_xsl_ns;

  cabin = callPackage ../data/fonts/cabin { };

  dosemu_fonts = callPackage ../data/fonts/dosemu-fonts { };

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
  };

  envdir = callPackage ../tools/misc/envdir-go { };

  fira = callPackage ../data/fonts/fira { };

  fira-code = callPackage ../data/fonts/fira-code { };
  fira-code-symbols = callPackage ../data/fonts/fira-code/symbols.nix { };

  font-awesome_4 = callPackage ../data/fonts/font-awesome-4 { };
  font-awesome_5 = callPackage ../data/fonts/font-awesome-5 { };

  freefont_ttf = callPackage ../data/fonts/freefont-ttf { };

  font-droid = callPackage ../data/fonts/droid { };

  gentium = callPackage ../data/fonts/gentium {};

  geolite-legacy = callPackage ../data/misc/geolite-legacy { };

  gnome_user_docs = callPackage ../data/documentation/gnome-user-docs { };

  inherit (gnome3) gsettings-desktop-schemas;

  gyre-fonts = callPackage ../data/fonts/gyre {};

  hack-font = callPackage ../data/fonts/hack { };

  hyperscrypt-font = callPackage ../data/fonts/hyperscrypt { };

  inconsolata = callPackage ../data/fonts/inconsolata {};
  inconsolata-lgc = callPackage ../data/fonts/inconsolata/lgc.nix {};

  iosevka = callPackage ../data/fonts/iosevka {
    nodejs = nodejs-8_x;
  };
  iosevka-bin = callPackage ../data/fonts/iosevka/bin.nix {};

  kawkab-mono-font = callPackage ../data/fonts/kawkab-mono {};

  kochi-substitute = callPackage ../data/fonts/kochi-substitute {};

  latinmodern-math = callPackage ../data/fonts/lm-math {};

  lato = callPackage ../data/fonts/lato {};

  inherit (callPackages ../data/fonts/redhat-liberation-fonts { })
    liberation_ttf_v1_from_source
    liberation_ttf_v1_binary
    liberation_ttf_v2_from_source
    liberation_ttf_v2_binary;
  liberation_ttf = liberation_ttf_v2_binary;

  liberationsansnarrow = callPackage ../data/fonts/liberationsansnarrow { };
  liberationsansnarrow_binary = callPackage ../data/fonts/liberationsansnarrow/binary.nix { };

  lmmath = callPackage ../data/fonts/lmodern/lmmath.nix {};

  lmodern = callPackage ../data/fonts/lmodern { };

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  man-pages = callPackage ../data/documentation/man-pages { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  inherit (callPackages ../data/fonts/noto-fonts {})
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra;

  nullmailer = callPackage ../servers/mail/nullmailer {
    stdenv = gccStdenv;
  };

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme { };

  inherit (kdeFrameworks) oxygen-icons5;

  papis = python3Packages.callPackage ../tools/misc/papis { };

  paratype-pt-mono = callPackage ../data/fonts/paratype-pt/mono.nix {};
  paratype-pt-sans = callPackage ../data/fonts/paratype-pt/sans.nix {};
  paratype-pt-serif = callPackage ../data/fonts/paratype-pt/serif.nix {};

  poly = callPackage ../data/fonts/poly { };

  posix_man_pages = callPackage ../data/documentation/man-pages-posix { };

  powerline-rs = callPackage ../tools/misc/powerline-rs {
    inherit (darwin.apple_sdk.frameworks) Security;
    openssl = openssl_1_1;
  };

  shared-mime-info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  soundfont-fluid = callPackage ../data/soundfonts/fluid { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  inherit (callPackages ../data/fonts/gdouros { })
    symbola aegyptus akkadian anatolian maya unidings musica analecta textfonts aegan abydos;

  poppler_data = callPackage ../data/misc/poppler-data { };

  qgo = libsForQt5.callPackage ../games/qgo { };

  qmc2 = libsForQt5.callPackage ../misc/emulators/qmc2 { };

  quattrocento = callPackage ../data/fonts/quattrocento {};

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  roboto = callPackage ../data/fonts/roboto { };

  sourceHanSansPackages = callPackage ../data/fonts/source-han-sans { };
  source-han-sans-japanese = sourceHanSansPackages.japanese;
  source-han-sans-korean = sourceHanSansPackages.korean;
  source-han-sans-simplified-chinese = sourceHanSansPackages.simplified-chinese;
  source-han-sans-traditional-chinese = sourceHanSansPackages.traditional-chinese;
  sourceHanSerifPackages = callPackage ../data/fonts/source-han-serif { };
  source-han-serif-japanese = sourceHanSerifPackages.japanese;
  source-han-serif-korean = sourceHanSerifPackages.korean;
  source-han-serif-simplified-chinese = sourceHanSerifPackages.simplified-chinese;
  source-han-serif-traditional-chinese = sourceHanSerifPackages.traditional-chinese;

  inherit (callPackages ../data/fonts/tai-languages { }) tai-ahom;

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme {
    gtk = self.gtk2;
  };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) {};

  tempora_lgc = callPackage ../data/fonts/tempora-lgc { };

  terminus_font = callPackage ../data/fonts/terminus-font { };

  terminus_font_ttf = callPackage ../data/fonts/terminus-font-ttf { };

  tex-gyre = callPackages ../data/fonts/tex-gyre { };

  tex-gyre-math = callPackages ../data/fonts/tex-gyre-math { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  twemoji-color-font = callPackage ../data/fonts/twemoji-color-font {
    inherit (nodePackages) svgo;
  };

  ubuntu_font_family = callPackage ../data/fonts/ubuntu-font-family { };

  unifont = callPackage ../data/fonts/unifont { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  vistafonts-chs = callPackage ../data/fonts/vista-fonts-chs { };

  wqy_microhei = callPackage ../data/fonts/wqy-microhei { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xkeyboard_config = xorg.xkeyboardconfig;

  xlsx2csv = pythonPackages.xlsx2csv;

  zeal = libsForQt5.callPackage ../data/documentation/zeal { };

  ### APPLICATIONS

  _2bwm = callPackage ../applications/window-managers/2bwm {
    patches = config."2bwm".patches or [];
  };

  abcde = callPackage ../applications/audio/abcde {
    inherit (perlPackages) MusicBrainz MusicBrainzDiscID;
    inherit (pythonPackages) eyeD3;
  };

  abiword = callPackage ../applications/office/abiword {
    iconTheme = gnome3.defaultIconTheme;
  };

  abook = callPackage ../applications/misc/abook { };

  acd-cli = callPackage ../applications/networking/sync/acd_cli {
    inherit (python3Packages)
      buildPythonApplication appdirs colorama dateutil
      requests requests_toolbelt sqlalchemy fusepy;
  };

  adobe-reader = pkgsi686Linux.callPackage ../applications/misc/adobe-reader { };

  masterpdfeditor = libsForQt5.callPackage ../applications/misc/masterpdfeditor { };

  afterstep = callPackage ../applications/window-managers/afterstep {
    fltk = fltk13;
    gtk = gtk2;
    stdenv = overrideCC stdenv gcc49;
  };

  ahoviewer = callPackage ../applications/graphics/ahoviewer {
    useUnrar = config.ahoviewer.useUnrar or false;
  };

  alchemy = callPackage ../applications/graphics/alchemy { };

  inherit (python2Packages) alot;

  alpine = callPackage ../applications/networking/mailreaders/alpine {
    tcl = tcl-8_5;
  };

  amarok = libsForQt5.callPackage ../applications/audio/amarok { };
  amarok-kf5 = amarok; # for compatibility

  androidStudioPackages = recurseIntoAttrs
    (callPackage ../applications/editors/android-studio { });
  android-studio = androidStudioPackages.stable;
  android-studio-preview = androidStudioPackages.beta;

  antimony = libsForQt5.callPackage ../applications/graphics/antimony {};

  ao = callPackage ../applications/graphics/ao {};

  aqemu = libsForQt5.callPackage ../applications/virtualization/aqemu { };

  ardour = callPackage ../applications/audio/ardour {
    inherit (gnome2) libgnomecanvas libgnomecanvasmm;
    inherit (vamp) vampSDK;
  };

  inherit (python3Packages) arelle;

  atomEnv = callPackage ../applications/editors/atom/env.nix {
    gconf = gnome2.GConf;
  };

  atomPackages = callPackage ../applications/editors/atom { };

  inherit (atomPackages) atom atom-beta;

  aseprite = callPackage ../applications/editors/aseprite { };
  aseprite-unfree = aseprite.override { unfree = true; };

  audacious = callPackage ../applications/audio/audacious { };
  audaciousQt5 = libsForQt5.callPackage ../applications/audio/audacious/qt-5.nix { };

  cadence =  libsForQt5.callPackage ../applications/audio/cadence { };

  altcoins = recurseIntoAttrs ( callPackage ../applications/altcoins { } );

  bitcoin = altcoins.bitcoin;
  clightning = altcoins.clightning;

  bitcoin-xt = altcoins.bitcoin-xt;
  cryptop = altcoins.cryptop;

  libbitcoin = callPackage ../tools/misc/libbitcoin/libbitcoin.nix {
    secp256k1 = secp256k1.override { enableECDH = true; };
  };

  libbitcoin-protocol = callPackage ../tools/misc/libbitcoin/libbitcoin-protocol.nix { };
  libbitcoin-client   = callPackage ../tools/misc/libbitcoin/libbitcoin-client.nix { };
  libbitcoin-network  = callPackage ../tools/misc/libbitcoin/libbitcoin-network.nix { };
  libbitcoin-explorer = callPackage ../tools/misc/libbitcoin/libbitcoin-explorer.nix { };


  go-ethereum = self.altcoins.go-ethereum;
  ethabi = self.altcoins.ethabi;

  parity = self.altcoins.parity;
  parity-beta = self.altcoins.parity-beta;
  parity-ui = self.altcoins.parity-ui;

  stellar-core = self.altcoins.stellar-core;

  particl-core = self.altcoins.particl-core;

  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  avidemux = libsForQt5.callPackage ../applications/video/avidemux { };

  avxsynth = callPackage ../applications/video/avxsynth {
    libjpeg = libjpeg_original; # error: 'JCOPYRIGHT_SHORT' was not declared in this scope
    ffmpeg = ffmpeg_2;
  };

  awesome-4-0 = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    luaPackages = luaPackages.override { inherit lua; };
  };
  awesome = awesome-4-0;

  awesomebump = libsForQt5.callPackage ../applications/graphics/awesomebump { };

  inherit (gnome3) baobab;

  backintime-common = callPackage ../applications/networking/sync/backintime/common.nix { };

  backintime-qt4 = callPackage ../applications/networking/sync/backintime/qt4.nix { };

  backintime = backintime-qt4;

  baresip = callPackage ../applications/networking/instant-messengers/baresip {
    ffmpeg = ffmpeg_1;
  };

  barrier = callPackage ../applications/misc/barrier {};

  batti = callPackage ../applications/misc/batti { };

  bazaar = callPackage ../applications/version-management/bazaar { };

  bazaarTools = callPackage ../applications/version-management/bazaar/tools.nix { };

  bb =  callPackage ../applications/misc/bb { };

  beast = callPackage ../applications/audio/beast {
    inherit (gnome2) libgnomecanvas libart_lgpl;
    guile = guile_1_8;
  };

  bitcoinarmory = callPackage ../applications/misc/bitcoinarmory { pythonPackages = python2Packages; };

  bitkeeper = callPackage ../applications/version-management/bitkeeper {
    gperf = gperf_3_0;
  };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };
  bitlbee-plugins = callPackage ../applications/networking/instant-messengers/bitlbee/plugins.nix { };

  bitscope = recurseIntoAttrs
    (callPackage ../applications/science/electronics/bitscope/packages.nix { });

  bitwig-studio1 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio1.nix {
    inherit (gnome3) zenity;
  };
  bitwig-studio2 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio2.nix {
    inherit (gnome3) zenity;
    inherit (self) bitwig-studio1;
  };
  bitwig-studio = bitwig-studio2;

  blackbox = callPackage ../applications/version-management/blackbox { };

  blender = callPackage  ../applications/misc/blender {
    cudaSupport = config.cudaSupport or false;
    pythonPackages = python35Packages;
    stdenv = overrideCC stdenv gcc6;
  };

  bluefish = callPackage ../applications/editors/bluefish {
    gtk = gtk3;
  };

  bluejeans = callPackage ../applications/networking/browsers/mozilla-plugins/bluejeans { };

  bluejeans-gui = callPackage ../applications/networking/instant-messengers/bluejeans {
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.xorg) libX11 libXrender libXtst libXdamage
                        libXi libXext libXfixes libXcomposite;
  };

  bomi = libsForQt5.callPackage ../applications/video/bomi {
    pulseSupport = config.pulseaudio or true;
    ffmpeg = ffmpeg_2;
  };

  brackets = callPackage ../applications/editors/brackets { gconf = gnome2.GConf; };

  bspwm = callPackage ../applications/window-managers/bspwm { };

  bspwm-unstable = callPackage ../applications/window-managers/bspwm/unstable.nix { };

  bvi = callPackage ../applications/editors/bvi { };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome2) libglade;
      stdenv = overrideCC stdenv gcc5;
  };

  calibre = libsForQt5.callPackage ../applications/misc/calibre { };

  calligra = libsForQt5.callPackage ../applications/office/calligra {
    inherit (kdeApplications) akonadi-calendar akonadi-contacts;
    openjpeg = openjpeg_1;
  };

  cb2bib = libsForQt5.callPackage ../applications/office/cb2bib { };

  cddiscid = callPackage ../applications/audio/cd-discid {
    inherit (darwin) IOKit;
  };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = callPackage ../applications/audio/cdparanoia {
    inherit (darwin) IOKit;
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  cgit = callPackage ../applications/version-management/git-and-tools/cgit {
    inherit (python3Packages) python wrapPython pygments markdown;
  };

  cgminer = callPackage ../applications/misc/cgminer {
    amdappsdk = amdappsdk28;
  };

  chirp = callPackage ../applications/misc/chirp {
    inherit (pythonPackages) pyserial pygtk;
  };

  chromium = callPackage ../applications/networking/browsers/chromium ({
    channel = "stable";
    pulseSupport = config.pulseaudio or true;
    enablePepperFlash = config.chromium.enablePepperFlash or false;
    enableWideVine = config.chromium.enableWideVine or false;
  } // (if stdenv.isAarch64 then {
          stdenv = gcc8Stdenv;
        } else {
          llvmPackages = llvmPackages_7;
          stdenv = llvmPackages_7.stdenv;
        })
   );

  chromiumBeta = lowPrio (chromium.override { channel = "beta"; });

  chromiumDev = lowPrio (chromium.override { channel = "dev"; });

  chuck = callPackage ../applications/audio/chuck {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel;
  };

  claws-mail = callPackage ../applications/networking/mailreaders/claws-mail {
    inherit (gnome3) gsettings-desktop-schemas;
    inherit (xorg) libSM;
    enableNetworkManager = config.networking.networkmanager.enable or false;
  };

  cligh = python3Packages.callPackage ../development/tools/github/cligh {};

  cmus = callPackage ../applications/audio/cmus {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    libjack = libjack2;
    ffmpeg = ffmpeg_2;

    pulseaudioSupport = config.pulseaudio or false;
  };

  cni = callPackage ../applications/networking/cluster/cni {};
  cni-plugins = callPackage ../applications/networking/cluster/cni/plugins.nix {};

  communi = libsForQt5.callPackage ../applications/networking/irc/communi { };

  copyq = libsForQt5.callPackage ../applications/misc/copyq { };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome2) libgnomeui GConf;
  };

  csound = callPackage ../applications/audio/csound { };

  cinepaint = callPackage ../applications/graphics/cinepaint {
    fltk = fltk13;
    libpng = libpng12;
    cmake = cmake_2_8;
  };

  codeblocks = callPackage ../applications/editors/codeblocks { };
  codeblocksFull = codeblocks.override { contribPlugins = true; };

  conkeror-unwrapped = callPackage ../applications/networking/browsers/conkeror { };
  conkeror = wrapFirefox conkeror-unwrapped { };

  cpp_ethereum = callPackage ../applications/misc/cpp-ethereum { };

  ctop = callPackage ../tools/system/ctop { };

  cutecom = libsForQt5.callPackage ../tools/misc/cutecom { };

  cutegram =
    let callpkg = libsForQt56.callPackage;
    in callpkg ../applications/networking/instant-messengers/telegram/cutegram rec {
      libqtelegram-aseman-edition = callpkg ../applications/networking/instant-messengers/telegram/libqtelegram-aseman-edition { };
      telegram-qml = callpkg ../applications/networking/instant-messengers/telegram/telegram-qml {
        inherit libqtelegram-aseman-edition;
      };
    };

  cvs = callPackage ../applications/version-management/cvs { };

  cyclone = callPackage ../applications/audio/pd-plugins/cyclone  { };

  darcs = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.darcs) (drv: {
    configureFlags = (stdenv.lib.remove "-flibrary" drv.configureFlags or []) ++ ["-f-library"];
  });

  darktable = callPackage ../applications/graphics/darktable {
    lua = lua5_3;
    pugixml = pugixml.override { shared = true; };
  };

  dd-agent = callPackage ../tools/networking/dd-agent/5.nix { };
  datadog-agent = callPackage ../tools/networking/dd-agent/6.nix {
    pythonPackages = datadog-integrations-core {};
  };
  datadog-process-agent = callPackage ../tools/networking/dd-agent/datadog-process-agent.nix { };
  datadog-trace-agent = callPackage ../tools/networking/dd-agent/datadog-trace-agent.nix { };
  datadog-integrations-core = extras: callPackage ../tools/networking/dd-agent/integrations-core.nix {
    python = python27;
    extraIntegrations = extras;
  };

  deadbeef = callPackage ../applications/audio/deadbeef {
    pulseSupport = config.pulseaudio or true;
  };

  deadbeefPlugins = {
    headerbar-gtk3 = callPackage ../applications/audio/deadbeef/plugins/headerbar-gtk3.nix { };
    infobar = callPackage ../applications/audio/deadbeef/plugins/infobar.nix { };
    mpris2 = callPackage ../applications/audio/deadbeef/plugins/mpris2.nix { };
    opus = callPackage ../applications/audio/deadbeef/plugins/opus.nix { };
  };

  deadbeef-with-plugins = callPackage ../applications/audio/deadbeef/wrapper.nix {
    plugins = [];
  };

  dfasma = libsForQt5.callPackage ../applications/audio/dfasma { };

  dfilemanager = libsForQt5.callPackage ../applications/misc/dfilemanager { };

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome2) libart_lgpl libgnomeui;
  };

  dit = callPackage ../applications/editors/dit { };

  djview = callPackage ../applications/graphics/djview { };
  djview4 = pkgs.djview;

  dmenu = callPackage ../applications/misc/dmenu { };

  dmensamenu = callPackage ../applications/misc/dmensamenu {
    inherit (python3Packages) buildPythonApplication requests;
  };

  dmtx-utils = callPackage (callPackage ../tools/graphics/dmtx-utils) {
  };

  inherit (callPackage ../applications/virtualization/docker {})
    docker_18_09;

  docker = docker_18_09;
  docker-edge = docker_18_09;

  docker-proxy = callPackage ../applications/virtualization/docker/proxy.nix { };

  docker-gc = callPackage ../applications/virtualization/docker/gc.nix { };

  docker-machine = callPackage ../applications/networking/cluster/docker-machine { };
  docker-machine-kvm = callPackage ../applications/networking/cluster/docker-machine/kvm.nix { };
  docker-machine-kvm2 = callPackage ../applications/networking/cluster/docker-machine/kvm2.nix { };
  docker-machine-xhyve = callPackage ../applications/networking/cluster/docker-machine/xhyve.nix {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
  };

  docker-distribution = callPackage ../applications/virtualization/docker/distribution.nix { };

  doodle = callPackage ../applications/search/doodle { };

  drawpile = libsForQt5.callPackage ../applications/graphics/drawpile { };

  droopy = callPackage ../applications/networking/droopy {
    inherit (python3Packages) wrapPython;
  };

  du-dust = callPackage ../tools/misc/dust { };

  denemo = callPackage ../applications/audio/denemo {
    inherit (gnome3) gtksourceview;
  };

  dvb_apps  = callPackage ../applications/video/dvb-apps { };

  dvdstyler = callPackage ../applications/video/dvdstyler {
    inherit (gnome2) libgnomeui;
  };

  dwm = callPackage ../applications/window-managers/dwm {
    patches = config.dwm.patches or [];
  };

  dwm-git = callPackage ../applications/window-managers/dwm/git.nix {
    patches = config.dwm.patches or [];
    conf = config.dwm.conf or null;
  };

  dwm-status = callPackage ../applications/window-managers/dwm/dwm-status.nix { };

  evilwm = callPackage ../applications/window-managers/evilwm {
    patches = config.evilwm.patches or [];
  };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse {
    jdk = jdk11;
  });

  ed = callPackage ../applications/editors/ed { };

  electron-cash = libsForQt5.callPackage ../applications/misc/electron-cash { };

  electrum = callPackage ../applications/misc/electrum { };

  electrum-dash = callPackage ../applications/misc/electrum/dash.nix { };

  electrum-ltc = callPackage ../applications/misc/electrum/ltc.nix { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs26;
  emacsPackages = emacs26Packages;
  emacsPackagesNg = emacs26PackagesNg;

  emacs26 = callPackage ../applications/editors/emacs {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
  };

  emacs26-nox = lowPrio (appendToName "nox" (emacs26.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacs25 = callPackage ../applications/editors/emacs/25.nix {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
  };

  emacs25-nox = lowPrio (appendToName "nox" (emacs25.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacsMacport = callPackage ../applications/editors/emacs/macport.nix {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
  };

  emacsPackagesFor = emacs: self: let callPackage = newScope self; in rec {
    inherit emacs;

    autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };

    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };

    bbdb3 = callPackage ../applications/editors/emacs-modes/bbdb/3.nix {};

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    calfw = callPackage ../applications/editors/emacs-modes/calfw { };

    cedille = callPackage ../applications/editors/emacs-modes/cedille { cedille = pkgs.cedille; };

    coffee = callPackage ../applications/editors/emacs-modes/coffee { };

    colorTheme = callPackage ../applications/editors/emacs-modes/color-theme { };

    colorThemeSolarized = callPackage ../applications/editors/emacs-modes/color-theme-solarized { };

    cryptol = callPackage ../applications/editors/emacs-modes/cryptol { };

    cua = callPackage ../applications/editors/emacs-modes/cua { };

    d = callPackage ../applications/editors/emacs-modes/d { };

    darcsum = callPackage ../applications/editors/emacs-modes/darcsum { };

    # ecb = callPackage ../applications/editors/emacs-modes/ecb { };

    emacsClangCompleteAsync = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };

    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };

    emms = callPackage ../applications/editors/emacs-modes/emms { };

    ensime = callPackage ../applications/editors/emacs-modes/ensime { };

    erlangMode = callPackage ../applications/editors/emacs-modes/erlang { };

    ess = callPackage ../applications/editors/emacs-modes/ess { };

    flymakeCursor = callPackage ../applications/editors/emacs-modes/flymake-cursor { };

    gh = callPackage ../applications/editors/emacs-modes/gh { };

    graphvizDot = callPackage ../applications/editors/emacs-modes/graphviz-dot { };

    gist = callPackage ../applications/editors/emacs-modes/gist { };

    haskellMode = callPackage ../applications/editors/emacs-modes/haskell { };

    hsc3Mode = callPackage ../applications/editors/emacs-modes/hsc3 { };

    hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };

    htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };

    ido-ubiquitous = callPackage ../applications/editors/emacs-modes/ido-ubiquitous { };

    icicles = callPackage ../applications/editors/emacs-modes/icicles { };

    idris = callPackage ../applications/editors/emacs-modes/idris { };

    jabber = callPackage ../applications/editors/emacs-modes/jabber { };

    jade = callPackage ../applications/editors/emacs-modes/jade { };

    jdee = callPackage ../applications/editors/emacs-modes/jdee { };

    js2 = callPackage ../applications/editors/emacs-modes/js2 { };

    let-alist = callPackage ../applications/editors/emacs-modes/let-alist { };

    logito = callPackage ../applications/editors/emacs-modes/logito { };

    loremIpsum = callPackage ../applications/editors/emacs-modes/lorem-ipsum { };

    markdownMode = callPackage ../applications/editors/emacs-modes/markdown-mode { };

    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };

    metaweblog = callPackage ../applications/editors/emacs-modes/metaweblog { };

    monky = callPackage ../applications/editors/emacs-modes/monky { };

    notmuch = lowPrio (pkgs.notmuch.override { inherit emacs; });

    ocamlMode = callPackage ../applications/editors/emacs-modes/ocaml { };

    offlineimap = callPackage ../applications/editors/emacs-modes/offlineimap {};

    # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
    # we want it to have higher precedence.
    org = hiPrio (callPackage ../applications/editors/emacs-modes/org { });

    org2blog = callPackage ../applications/editors/emacs-modes/org2blog { };

    pcache = callPackage ../applications/editors/emacs-modes/pcache { };

    phpMode = callPackage ../applications/editors/emacs-modes/php { };

    prologMode = callPackage ../applications/editors/emacs-modes/prolog { };

    proofgeneral = callPackage ../applications/editors/emacs-modes/proofgeneral/4.4.nix {
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };
    proofgeneral_HEAD = callPackage ../applications/editors/emacs-modes/proofgeneral/HEAD.nix {
      texinfo = texinfo4 ;
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };

    quack = callPackage ../applications/editors/emacs-modes/quack { };

    rainbowDelimiters = callPackage ../applications/editors/emacs-modes/rainbow-delimiters { };

    rectMark = callPackage ../applications/editors/emacs-modes/rect-mark { };

    remember = callPackage ../applications/editors/emacs-modes/remember { };

    rudel = callPackage ../applications/editors/emacs-modes/rudel { };

    s = callPackage ../applications/editors/emacs-modes/s { };

    sbtMode = callPackage ../applications/editors/emacs-modes/sbt-mode { };

    scalaMode1 = callPackage ../applications/editors/emacs-modes/scala-mode/v1.nix { };
    scalaMode2 = callPackage ../applications/editors/emacs-modes/scala-mode/v2.nix { };

    structuredHaskellMode = haskellPackages.structured-haskell-mode;

    sunriseCommander = callPackage ../applications/editors/emacs-modes/sunrise-commander { };

    tuaregMode = callPackage ../applications/editors/emacs-modes/tuareg { };

    writeGood = callPackage ../applications/editors/emacs-modes/writegood { };

    xmlRpc = callPackage ../applications/editors/emacs-modes/xml-rpc { };

    cask = callPackage ../applications/editors/emacs-modes/cask { };
  };

  emacs25Packages = emacsPackagesFor emacs25 pkgs.emacs25Packages;
  emacs26Packages = emacsPackagesFor emacs26 pkgs.emacs26Packages;

  emacsPackagesNgFor = emacs: import ./emacs-packages.nix {
    inherit lib newScope stdenv;
    inherit fetchFromGitHub fetchgit fetchhg fetchurl fetchpatch;
    inherit emacs texinfo makeWrapper runCommand writeText;
    inherit (xorg) lndir;

    trivialBuild = callPackage ../build-support/emacs/trivial.nix {
      inherit emacs;
    };

    melpaBuild = callPackage ../build-support/emacs/melpa.nix {
      inherit emacs;
    };

    external = {
      inherit (haskellPackages) ghc-mod structured-haskell-mode Agda hindent;
      inherit (pythonPackages) elpy;
      inherit
        autoconf automake git libffi libpng pkgconfig poppler rtags w3m zlib;
    };
  };

  emacs25PackagesNg = emacsPackagesNgFor emacs25;
  emacs25WithPackages = emacs25PackagesNg.emacsWithPackages;
  emacs26PackagesNg = emacsPackagesNgFor emacs26;
  emacs26WithPackages = emacs26PackagesNg.emacsWithPackages;
  emacsWithPackages = emacsPackagesNg.emacsWithPackages;

  inherit (gnome3) empathy;

  epeg = callPackage ../applications/graphics/epeg { };

  inherit (gnome3) epiphany;

  errbot = callPackage ../applications/networking/errbot {
    pythonPackages = python3Packages;
  };

  espeak-classic = callPackage ../applications/audio/espeak { };

  espeak-ng = callPackage ../applications/audio/espeak-ng { };
  espeak = self.espeak-ng;

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  eteroj.lv2 = libsForQt5.callPackage ../applications/audio/eteroj.lv2 { };

  evilvte = callPackage ../applications/misc/evilvte {
    configH = config.evilvte.config or "";
  };

  keepassx = callPackage ../applications/misc/keepassx { };
  keepassx2 = callPackage ../applications/misc/keepassx/2.0.nix { };
  keepassxc = libsForQt5.callPackage ../applications/misc/keepassx/community.nix { };

  inherit (gnome3) evince;
  evolution-data-server = gnome3.evolution-data-server;

  keepass = callPackage ../applications/misc/keepass {
    buildDotnetPackage = buildDotnetPackage.override { mono = mono54; };
  };

  keepass-keeagent = callPackage ../applications/misc/keepass-plugins/keeagent { };

  keepass-keepasshttp = callPackage ../applications/misc/keepass-plugins/keepasshttp { };

  keepass-keepassrpc = callPackage ../applications/misc/keepass-plugins/keepassrpc { };

  fbreader = callPackage ../applications/misc/fbreader {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  fdr = libsForQt5.callPackage ../applications/science/programming/fdr { };

  flink = callPackage ../applications/networking/cluster/flink { };
  flink_1_5 = flink.override { version = "1.5"; };

  fluidsynth = callPackage ../applications/audio/fluidsynth {
     inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio CoreMIDI CoreServices;
  };

  fmit = libsForQt5.callPackage ../applications/audio/fmit { };

  focuswriter = libsForQt5.callPackage ../applications/editors/focuswriter { };

  fossil = callPackage ../applications/version-management/fossil { };

  fribid = callPackage ../applications/networking/browsers/mozilla-plugins/fribid { };

  fritzing = libsForQt5.callPackage ../applications/science/electronics/fritzing { };

  gcal = callPackage ../applications/misc/gcal { };

  geany = callPackage ../applications/editors/geany { };
  geany-with-vte = callPackage ../applications/editors/geany/with-vte.nix { };

  ghostwriter = libsForQt5.callPackage ../applications/editors/ghostwriter { };

  gitweb = callPackage ../applications/version-management/git-and-tools/gitweb { };

  gksu = callPackage ../applications/misc/gksu { };

  gnss-sdr = callPackage ../applications/misc/gnss-sdr { boost=boost166; };

  gnuradio = callPackage ../applications/misc/gnuradio {
    inherit (python2Packages) cheetah lxml Mako matplotlib numpy python pyopengl pyqt4 scipy wxPython pygtk;
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    fftw = fftwFloat;
    qwt = qwt6_qt4;
  };

  gnuradio-with-packages = callPackage ../applications/misc/gnuradio/wrapper.nix {
    inherit (python2Packages) python;
    extraPackages = [ gnuradio-nacl gnuradio-osmosdr gnuradio-gsm gnuradio-ais gnuradio-rds gnuradio-limesdr ];
  };

  gnuradio-nacl = callPackage ../applications/misc/gnuradio/nacl.nix { };

  gnuradio-gsm = callPackage ../applications/misc/gnuradio/gsm.nix { };

  gnuradio-ais = callPackage ../applications/misc/gnuradio/ais.nix { };

  gnuradio-limesdr = callPackage ../applications/misc/gnuradio/limesdr.nix { };

  gnuradio-rds = callPackage ../applications/misc/gnuradio/rds.nix { };

  gnuradio-osmosdr = callPackage ../applications/misc/gnuradio/osmosdr.nix { };

  goldendict = libsForQt5.callPackage ../applications/misc/goldendict { };

  inherit (ocamlPackages) google-drive-ocamlfuse;

  google-musicmanager = callPackage ../applications/audio/google-musicmanager {
    inherit (qt5) qtbase qtwebkit;
    # Downgrade to 1.34 to get libidn.so.11
    libidn = (libidn.overrideAttrs (oldAttrs: {
      src = fetchurl {
        url = "mirror://gnu/libidn/libidn-1.34.tar.gz";
        sha256 = "0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p";
      };
    })).out;
  };

  googler = callPackage ../applications/misc/googler {
    python = python3;
  };

  gopher = callPackage ../applications/networking/gopher/gopher { };

  gopherclient = libsForQt5.callPackage ../applications/networking/gopher/gopherclient { };

  gpa = callPackage ../applications/misc/gpa { };

  gpicview = callPackage ../applications/graphics/gpicview {
    gtk2 = gtk2-x11;
  };

  gpx = callPackage ../applications/misc/gpx { };

  gqrx = qt5.callPackage ../applications/misc/gqrx { };

  grip = callPackage ../applications/misc/grip {
    inherit (gnome2) libgnome libgnomeui vte;
  };

  gthumb = callPackage ../applications/graphics/gthumb { };

  gtimelog = pythonPackages.gtimelog;

  inherit (gnome3) gucharmap;

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  welle-io = libsForQt5.callPackage ../applications/misc/welle-io { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark {
    withQt = true;
    qt5 = qt59;
    withGtk = false;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices SystemConfiguration;
  };
  wireshark-qt = wireshark;

  # The GTK UI is deprecated by upstream. You probably want the QT version.
  wireshark-gtk = wireshark.override { withGtk = true; withQt = false; };
  wireshark-cli = wireshark.override { withGtk = false; withQt = false; };

  feh = callPackage ../applications/graphics/feh { };

  filezilla = callPackage ../applications/networking/ftp/filezilla { };

  firefoxPackages = recurseIntoAttrs (callPackage ../applications/networking/browsers/firefox/packages.nix {
    callPackage = pkgs.newScope {
      inherit (gnome2) libIDL;
      libpng = libpng_apng;
      python = python2;
      gnused = gnused_422;
      icu = icu59;
      inherit (darwin.apple_sdk.frameworks) CoreMedia ExceptionHandling
                                            Kerberos AVFoundation MediaToolbox
                                            CoreLocation Foundation AddressBook;
      inherit (darwin) libobjc;
    };
  });

  firefox-unwrapped = firefoxPackages.firefox;
  firefox-esr-52-unwrapped = firefoxPackages.firefox-esr-52;
  firefox-esr-60-unwrapped = firefoxPackages.firefox-esr-60;
  tor-browser-unwrapped = firefoxPackages.tor-browser;

  firefox = wrapFirefox firefox-unwrapped { };
  firefox-esr-52 = wrapFirefox firefox-esr-52-unwrapped { };
  firefox-esr-60 = wrapFirefox firefox-esr-60-unwrapped { };
  firefox-esr = firefox-esr-60;

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    channel = "release";
    generated = import ../applications/networking/browsers/firefox-bin/release_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-bin = wrapFirefox firefox-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-bin-" +
      (builtins.parseDrvName firefox-bin-unwrapped.name).version;
    desktopName = "Firefox";
  };

  firefox-beta-bin-unwrapped = firefox-bin-unwrapped.override {
    channel = "beta";
    generated = import ../applications/networking/browsers/firefox-bin/beta_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-beta-bin = self.wrapFirefox firefox-beta-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-beta-bin-" +
      (builtins.parseDrvName firefox-beta-bin-unwrapped.name).version;
    desktopName = "Firefox Beta";
  };

  firefox-devedition-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    channel = "devedition";
    generated = import ../applications/networking/browsers/firefox-bin/devedition_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  firefox-devedition-bin = self.wrapFirefox firefox-devedition-bin-unwrapped {
    browserName = "firefox";
    nameSuffix = "-devedition";
    name = "firefox-devedition-bin-" +
      (builtins.parseDrvName firefox-devedition-bin-unwrapped.name).version;
    desktopName = "Firefox DevEdition";
  };

  firestr = libsForQt5.callPackage ../applications/networking/p2p/firestr
    { boost = boost155;
    };

  flac = callPackage ../applications/audio/flac { };

  flameshot = libsForQt5.callPackage ../tools/misc/flameshot { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer {
    debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer/standalone.nix {
    debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone-debugger = flashplayer-standalone.override {
    debug = true;
  };

  fme = callPackage ../applications/misc/fme {
    inherit (gnome2) libglademm;
  };

  freecad = callPackage ../applications/graphics/freecad { mpi = openmpi; };

  inherit (xorg) xlsfonts;

  freerdp = callPackage ../applications/networking/remote/freerdp {
    inherit libpulseaudio;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  freerdpUnstable = freerdp;

  # This must go when weston v2 is released
  freerdp_legacy = callPackage ../applications/networking/remote/freerdp/legacy.nix {
    cmake = cmake_2_8;
    ffmpeg = ffmpeg_1;
  };

  fte = callPackage ../applications/editors/fte { };

  game-music-emu = callPackage ../applications/audio/game-music-emu { };

  ghq = gitAndTools.ghq;

  gimp = callPackage ../applications/graphics/gimp {
    gegl = gegl_0_4;
    lcms = lcms2;
    inherit (gnome3) gexiv2;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gimp-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimpPlugins = recurseIntoAttrs (callPackage ../applications/graphics/gimp/plugins {});

  girara = callPackage ../applications/misc/girara {
    gtk = gtk3;
  };

  gitAndTools = recurseIntoAttrs (callPackage ../applications/version-management/git-and-tools {});

  inherit (gitAndTools) git gitFull gitSVN git-cola svn2git git-radar git-secret git-secrets transcrypt git-crypt;

  gitMinimal = git.override {
    withManual = false;
    pythonSupport = false;
    withpcre2 = false;
  };

  gitRepo = callPackage ../applications/version-management/git-repo {
    python = python27;
  };

  inherit (gnome3) gitg;

  giv = callPackage ../applications/graphics/giv { };

  gnucash = callPackage ../applications/office/gnucash {
    inherit (gnome3) dconf;
  };

  gnucash24 = callPackage ../applications/office/gnucash/2.4.nix {
    inherit (gnome2) libgnomeui libgtkhtml gtkhtml libbonoboui libgnomeprint libglade libart_lgpl;
    gconf = gnome2.GConf;
    guile = guile_1_8;
    slibGuile = slibGuile.override { scheme = guile_1_8; };
    goffice = goffice_0_8;
  };

  gnucash26 = lowPrio (callPackage ../applications/office/gnucash/2.6.nix {
    inherit (gnome2) libgnomecanvas;
    inherit (gnome3) dconf;
    gconf = gnome2.GConf;
    goffice = goffice_0_8;
    webkit = webkitgtk24x-gtk2;
    guile = guile_1_8;
    slibGuile = slibGuile.override { scheme = guile_1_8; };
    glib = glib;
  });

  goffice = callPackage ../development/libraries/goffice { };

  goffice_0_8 = callPackage ../development/libraries/goffice/0.8.nix {
    inherit (pkgs.gnome2) libglade libgnomeui;
    gconf = pkgs.gnome2.GConf;
    libart = pkgs.gnome2.libart_lgpl;
  };

  jetbrains = (recurseIntoAttrs (callPackages ../applications/editors/jetbrains {
    jdk = jetbrains.jdk;
  }) // {
    jdk = callPackage ../development/compilers/jetbrains-jdk {  };
  });

  libquvi = callPackage ../applications/video/quvi/library.nix { };

  linssid = libsForQt5.callPackage ../applications/networking/linssid { };

  m32edit = callPackage ../applications/audio/midas/m32edit.nix {};

  moe =  callPackage ../applications/editors/moe { };

  quvi = callPackage ../applications/video/quvi/tool.nix {
    lua5_sockets = lua51Packages.luasocket;
    lua5 = lua5_1;
  };

  quvi_scripts = callPackage ../applications/video/quvi/scripts.nix { };

  gkrellm = callPackage ../applications/misc/gkrellm {
    inherit (darwin) IOKit;
  };

  gmu = callPackage ../applications/audio/gmu { };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer { };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gnunet_git = lowPrio (callPackage ../applications/networking/p2p/gnunet/git.nix { });

  gocr = callPackage ../applications/graphics/gocr { };

  gobby5 = callPackage ../applications/editors/gobby { };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = callPackage ../applications/misc/gphoto2/gphotofs.nix { };

  gramps = callPackage ../applications/misc/gramps {
        pythonPackages = python3Packages;
  };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };
  graphicsmagick_q16 = graphicsmagick.override { quantumdepth = 16; };

  graphicsmagick-imagemagick-compat = callPackage ../applications/graphics/graphicsmagick/compat.nix { };

  grisbi = callPackage ../applications/office/grisbi { gtk = gtk2; };

  jbidwatcher = callPackage ../applications/misc/jbidwatcher {
    java = if stdenv.isLinux then jre else jdk;
  };

  qrencode = callPackage ../tools/graphics/qrencode { };

  google-chrome = callPackage ../applications/networking/browsers/google-chrome { gconf = gnome2.GConf; };

  google-chrome-beta = google-chrome.override { chromium = chromiumBeta; channel = "beta"; };

  google-chrome-dev = google-chrome.override { chromium = chromiumDev; channel = "dev"; };

  google-play-music-desktop-player = callPackage ../applications/audio/google-play-music-desktop-player {
    inherit (gnome2) GConf;
  };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin {
    libpng = libpng12;
  };

  gpsbabel = libsForQt56.callPackage ../applications/misc/gpsbabel {
    inherit (darwin) IOKit;
  };

  gpxsee = libsForQt5.callPackage ../applications/misc/gpxsee { };

  gspell = callPackage ../development/libraries/gspell { };

  gtk2fontsel = callPackage ../applications/misc/gtk2fontsel {
    inherit (gnome2) gtk;
  };

  guake = callPackage ../applications/misc/guake {
    inherit (gnome3) vte;
  };

  guitone = callPackage ../applications/version-management/guitone {
    graphviz = graphviz_2_32;
  };

  gv = callPackage ../applications/misc/gv { };

  guvcview = callPackage ../os-specific/linux/guvcview {
    pulseaudioSupport = config.pulseaudio or true;
    ffmpeg = ffmpeg_2;
  };

  hackrf = callPackage ../applications/misc/hackrf { };

  hamster-time-tracker = callPackage ../applications/misc/hamster-time-tracker {
    inherit (gnome2) gnome_python;
  };

  hello = callPackage ../applications/misc/hello { };
  heme = callPackage ../applications/editors/heme { };

  hexedit = callPackage ../applications/editors/hexedit { };

  hledger = haskell.lib.justStaticExecutables haskellPackages.hledger;
  hledger-ui = haskell.lib.justStaticExecutables haskellPackages.hledger-ui;
  hledger-web = haskell.lib.justStaticExecutables haskellPackages.hledger-web;

  homebank = callPackage ../applications/office/homebank {
    gtk = gtk3;
  };

  hovercraft = python3Packages.callPackage ../applications/misc/hovercraft { };

  ht = callPackage ../applications/editors/ht { };

  hugin = callPackage ../applications/graphics/hugin {
    wxGTK = wxGTK30;
  };

  hyper = callPackage ../applications/misc/hyper { };

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

  slack = callPackage ../applications/networking/instant-messengers/slack { };

  singularity = callPackage ../applications/virtualization/singularity { };

  spectral = qt5.callPackage ../applications/networking/instant-messengers/spectral { };

  sway = callPackage ../applications/window-managers/sway { };
  sway-beta = callPackage ../applications/window-managers/sway/beta.nix { };

  velox = callPackage ../applications/window-managers/velox {
    stConf = config.st.conf or null;
    stPatches = config.st.patches or null;
  };

  i3 = callPackage ../applications/window-managers/i3 {
    xcb-util-cursor = if stdenv.isDarwin then xcb-util-cursor-HEAD else xcb-util-cursor;
  };

  i3-gaps = callPackage ../applications/window-managers/i3/gaps.nix { };

  i3-easyfocus = callPackage ../applications/window-managers/i3/easyfocus.nix { };

  i3blocks = callPackage ../applications/window-managers/i3/blocks.nix { };

  i3blocks-gaps = callPackage ../applications/window-managers/i3/blocks-gaps.nix { };

  i3ipc-glib = callPackage ../applications/window-managers/i3/i3ipc-glib.nix { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

  i3lock-color = callPackage ../applications/window-managers/i3/lock-color.nix { };

  i3lock-fancy = callPackage ../applications/window-managers/i3/lock-fancy.nix { };

  i3pystatus = callPackage ../applications/window-managers/i3/pystatus.nix { };

  i3status = callPackage ../applications/window-managers/i3/status.nix { };

  i3status-rust = callPackage ../applications/window-managers/i3/status-rust.nix { };

  i3-wk-switch = callPackage ../applications/window-managers/i3/wk-switch.nix { };

  wmfocus = callPackage ../applications/window-managers/i3/wmfocus.nix { };

  ii = callPackage ../applications/networking/irc/ii {
    stdenv = gccStdenv;
  };

  ike = callPackage ../applications/networking/ike { };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    inherit (perlPackages) TextMarkdown URI HTMLParser HTMLScrubber
      HTMLTemplate TimeDate CGISession DBFile CGIFormBuilder LocaleGettext
      RpcXML XMLSimple YAML YAMLLibYAML HTMLTree Filechdir
      AuthenPassphrase NetOpenIDConsumer LWPxParanoidAgent CryptSSLeay;
    inherit (perlPackages.override { pkgs = pkgs // { imagemagick = imagemagickBig;}; }) PerlMagick;
  };

  imagemagick_light = imagemagick.override {
    bzip2 = null;
    zlib = null;
    libX11 = null;
    libXext = null;
    libXt = null;
    fontconfig = null;
    freetype = null;
    ghostscript = null;
    libjpeg = null;
    lcms2 = null;
    openexr = null;
    libpng = null;
    librsvg = null;
    libtiff = null;
    libxml2 = null;
    openjpeg = null;
    libwebp = null;
    libheif = null;
    libde265 = null;
  };

  imagemagick = callPackage ../applications/graphics/ImageMagick {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
    ghostscript = null;
  };

  imagemagickBig = imagemagick.override { inherit ghostscript; };

  imagemagick7_light = lowPrio (imagemagick7.override {
    bzip2 = null;
    zlib = null;
    libX11 = null;
    libXext = null;
    libXt = null;
    fontconfig = null;
    freetype = null;
    ghostscript = null;
    libjpeg = null;
    lcms2 = null;
    openexr = null;
    libpng = null;
    librsvg = null;
    libtiff = null;
    libxml2 = null;
    openjpeg = null;
    libwebp = null;
    libheif = null;
  });

  imagemagick7 = lowPrio (imagemagick7Big.override {
    ghostscript = null;
  });

  imagemagick7Big = lowPrio (callPackage ../applications/graphics/ImageMagick/7.0.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  });

  inherit (nodePackages) imapnotify;

  # Impressive, formerly known as "KeyJNote".
  inferno = pkgsi686Linux.callPackage ../applications/inferno { };

  inkscape = callPackage ../applications/graphics/inkscape {
    lcms = lcms2;
    poppler = poppler_0_61;
  };

  inspectrum = libsForQt5.callPackage ../applications/misc/inspectrum { };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5_1;
  };

  ipe = libsForQt5.callPackage ../applications/graphics/ipe {
    ghostscript = ghostscriptX;
    texlive = texlive.combine { inherit (texlive) scheme-small; };
  };

  iptraf = callPackage ../applications/networking/iptraf { };

  irssi = callPackage ../applications/networking/irc/irssi { };

  irssi_fish = callPackage ../applications/networking/irc/irssi/fish { };

  irssi_otr = callPackage ../applications/networking/irc/irssi/otr { };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  bip = callPackage ../applications/networking/irc/bip { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jack_oscrolloscope = callPackage ../applications/audio/jack-oscrolloscope { };

  jack_rack = callPackage ../applications/audio/jack-rack { };

  jackmix = callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = jackmix.override { jack = jack1; };

  jameica = callPackage ../applications/office/jameica {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  japa = callPackage ../applications/audio/japa { };

  jwm = callPackage ../applications/window-managers/jwm { };

  jwm-settings-manager = callPackage ../applications/window-managers/jwm/jwm-settings-manager.nix { };

  k3d = callPackage ../applications/graphics/k3d {
    inherit (pkgs.gnome2) gtkglext;
    stdenv = overrideCC stdenv gcc6;
  };

  k9copy = libsForQt5.callPackage ../applications/video/k9copy {};

  kdeApplications =
    let
      mkApplications = import ../applications/kde;
      attrs = {
        inherit lib libsForQt5 fetchurl;
        inherit okteta;
      };
    in
      recurseIntoAttrs (makeOverridable mkApplications attrs);

  inherit (kdeApplications)
    akonadi akregator ark dolphin dragon ffmpegthumbs filelight gwenview k3b
    kaddressbook kate kcachegrind kcalc kcolorchooser kcontacts kdenlive kdf kdialog keditbookmarks
    kget kgpg khelpcenter kig kleopatra kmail kmix kolourpaint kompare konsole kpkpass kitinerary
    kontact korganizer krdc krfb ksystemlog kwalletmanager marble minuet okular spectacle;

  okteta = libsForQt5.callPackage ../applications/editors/okteta { };

  kdeconnect = libsForQt5.callPackage ../applications/misc/kdeconnect { };

  kdecoration-viewer = libsForQt5.callPackage ../tools/misc/kdecoration-viewer { };

  inherit (kdeFrameworks) kdesu;

  kdevelop-pg-qt = libsForQt5.callPackage ../applications/editors/kdevelop5/kdevelop-pg-qt.nix {};

  kdevelop = libsForQt5.callPackage ../applications/editors/kdevelop5/kdevelop.nix {
    llvmPackages = llvmPackages_38;
  };

  kega-fusion = pkgsi686Linux.callPackage ../misc/emulators/kega-fusion { };

  kexi = libsForQt5.callPackage ../applications/office/kexi { };

  keyfinder = libsForQt5.callPackage ../applications/audio/keyfinder { };

  keyfinder-cli = libsForQt5.callPackage ../applications/audio/keyfinder-cli { };

  keymon = callPackage ../applications/video/key-mon { };

  kgraphviewer = libsForQt5.callPackage ../applications/graphics/kgraphviewer { };

  khard = callPackage ../applications/misc/khard { };

  kid3 = libsForQt5.callPackage ../applications/audio/kid3 { };

  kile = libsForQt5.callPackage ../applications/editors/kile { };

  kino = callPackage ../applications/video/kino {
    inherit (gnome2) libglade;
    ffmpeg = ffmpeg_2;
  };

  kipi-plugins = libsForQt5.callPackage ../applications/graphics/kipi-plugins { };

  kmplayer = libsForQt5.callPackage ../applications/video/kmplayer { };

  kmymoney = libsForQt5.callPackage ../applications/office/kmymoney {
    inherit (kdeApplications) kidentitymanagement;
    inherit (kdeFrameworks) kdewebkit;
  };

  konversation = libsForQt5.callPackage ../applications/networking/irc/konversation { };

  krita = libsForQt5.callPackage ../applications/graphics/krita {
    openjpeg = openjpeg_1;
  };

  krusader = libsForQt5.callPackage ../applications/misc/krusader { };

  ktorrent = libsForQt5.callPackage ../applications/networking/p2p/ktorrent { };

  kubernetes = callPackage ../applications/networking/cluster/kubernetes {  };

  kubectl = (kubernetes.override { components = [ "cmd/kubectl" ]; }).overrideAttrs(oldAttrs: {
    name = "kubectl-${oldAttrs.version}";
  });

  kubernetes-helm = callPackage ../applications/networking/cluster/helm { };

  kubetail = callPackage ../applications/networking/cluster/kubetail { } ;

  lame = callPackage ../development/libraries/lame { };

  lash = callPackage ../applications/audio/lash { };

  ladspaH = callPackage ../applications/audio/ladspa-sdk/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladspa-sdk = callPackage ../applications/audio/ladspa-sdk { };

  caps = callPackage ../applications/audio/caps { };

  lbdb = callPackage ../tools/misc/lbdb { abook = null; gnupg = null; goobook = null; khard = null; mu = null; };

  lci = callPackage ../applications/science/logic/lci {};

  lemonbar = callPackage ../applications/window-managers/lemonbar { };

  lemonbar-xft = callPackage ../applications/window-managers/lemonbar/xft.nix { };

  libreoffice = hiPrio libreoffice-still;
  libreoffice-unwrapped = libreoffice.libreoffice;

  libreoffice-args = {
    inherit (perlPackages) ArchiveZip IOCompress;
    inherit (gnome2) GConf ORBit2 gnome_vfs;
    inherit (gnome3) defaultIconTheme;
    zip = zip.override { enableNLS = false; };
    fontsConf = makeFontsConf {
      fontDirectories = [
        carlito dejavu_fonts
        freefont_ttf xorg.fontmiscmisc
        liberation_ttf_v1_binary
        liberation_ttf_v2_binary
      ];
    };
    clucene_core = clucene_core_2;
    lcms = lcms2;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  };

  libreoffice-fresh = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = callPackage ../applications/office/libreoffice
      (libreoffice-args // {
      });
  });
  libreoffice-fresh-unwrapped = libreoffice-fresh.libreoffice;

  libreoffice-still = lowPrio (callPackage ../applications/office/libreoffice/wrapper.nix {
    libreoffice = callPackage ../applications/office/libreoffice/still.nix
      (libreoffice-args // {
          poppler = poppler_0_61;
      });
  });
  libreoffice-still-unwrapped = libreoffice-still.libreoffice;

  liferea = callPackage ../applications/networking/newsreaders/liferea {
    inherit (gnome3) libpeas gsettings-desktop-schemas dconf;
  };

  lightworks = callPackage ../applications/video/lightworks {
    portaudio = portaudio2014;
  };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome2) libglade;
  };

  ledger2 = callPackage ../applications/office/ledger/2.6.3.nix { };
  ledger3 = callPackage ../applications/office/ledger {
    boost = boost15x;
  };
  ledger = ledger3;
  ledger-web = callPackage ../applications/office/ledger-web { };

  linphone = callPackage ../applications/networking/instant-messengers/linphone rec {
    polarssl = mbedtls_1_3;
  };

  llpp = ocaml-ng.ocamlPackages_4_04.callPackage ../applications/misc/llpp { };

  lmms = libsForQt5.callPackage ../applications/audio/lmms {
    lame = null;
    libsoundio = null;
    portaudio = null;
  };

  luminanceHDR = libsForQt5.callPackage ../applications/graphics/luminance-hdr { };

  lilyterm = callPackage ../applications/misc/lilyterm {
    inherit (gnome2) vte;
    gtk = gtk2;
    flavour = "stable";
  };

  lilyterm-git = lilyterm.override {
    flavour = "git";
  };

  luakit = callPackage ../applications/networking/browsers/luakit {
    inherit (lua51Packages) luafilesystem;
    lua5 = lua5_1;
  };

  lumail = callPackage ../applications/networking/mailreaders/lumail {
    lua = lua5_1;
  };

  lyx = libsForQt5.callPackage ../applications/misc/lyx { };

  mac = callPackage ../development/libraries/mac { };

  magic-wormhole = with python3Packages; toPythonApplication magic-wormhole;

  magnetophonDSP = {
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

  mapmap = libsForQt5.callPackage ../applications/video/mapmap { };

  marathon = callPackage ../applications/networking/cluster/marathon { };
  marathonctl = callPackage ../tools/virtualization/marathonctl { } ;

  matchbox = callPackage ../applications/window-managers/matchbox { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  mediainfo = callPackage ../applications/misc/mediainfo { };

  mediathekview = callPackage ../applications/video/mediathekview { };

  meteo = callPackage ../applications/networking/weather/meteo { };

  mendeley = libsForQt5.callPackage ../applications/office/mendeley {
    gconf = pkgs.gnome2.GConf;
  };

  menumaker = callPackage ../applications/misc/menumaker { };

  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
    guiSupport = false; # use mercurialFull to get hgk GUI
  };

  mercurialFull = appendToName "full" (pkgs.mercurial.override { guiSupport = true; });

  merkaartor = libsForQt5.callPackage ../applications/misc/merkaartor { };

  meshlab = libsForQt5.callPackage ../applications/graphics/meshlab { };

  metersLv2 = callPackage ../applications/audio/meters_lv2 { };

  midori-unwrapped = callPackage ../applications/networking/browsers/midori { };
  midori = wrapFirefox midori-unwrapped { };

  mikmod = callPackage ../applications/audio/mikmod { };

  minikube = callPackage ../applications/networking/cluster/minikube {
    inherit (darwin.apple_sdk.frameworks) vmnet;
  };

  minitube = libsForQt5.callPackage ../applications/video/minitube { };

  mimic = callPackage ../applications/audio/mimic {
    pulseaudioSupport = config.pulseaudio or false;
  };

  meh = callPackage ../applications/graphics/meh {};

  mirage = callPackage ../applications/graphics/mirage { };

  mixxx = callPackage ../applications/audio/mixxx {
    inherit (vamp) vampSDK;
  };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  mmex = callPackage ../applications/office/mmex {
    wxGTK30 = wxGTK30.override { withWebKit  = true ; };
  };

  moc = callPackage ../applications/audio/moc {
    ffmpeg = ffmpeg_2;
  };

  monero = callPackage ../applications/altcoins/monero {
    inherit (darwin.apple_sdk.frameworks) CoreData IOKit PCSC;
    boost = boost15x;
  };

  monero-gui = libsForQt5.callPackage ../applications/altcoins/monero-gui {
    boost = boost15x;
  };

  xmr-stak = callPackage ../applications/misc/xmr-stak {
    stdenvGcc6 = overrideCC stdenv gcc6;
    hwloc = hwloc-nox;
  };

  xmrig = callPackage ../applications/misc/xmrig { };

  xmrig-proxy = callPackage ../applications/misc/xmrig/proxy.nix { };

  monkeysAudio = callPackage ../applications/audio/monkeys-audio { };

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
  };

  inherit (ocaml-ng.ocamlPackages_4_01_0) monotoneViz;

  mop = callPackage ../applications/misc/mop { };

  mopidy = callPackage ../applications/audio/mopidy { };

  mopidy-gmusic = callPackage ../applications/audio/mopidy/gmusic.nix { };

  mopidy-local-images = callPackage ../applications/audio/mopidy/local-images.nix { };

  mopidy-local-sqlite = callPackage ../applications/audio/mopidy/local-sqlite.nix { };

  mopidy-spotify = callPackage ../applications/audio/mopidy/spotify.nix { };

  mopidy-moped = callPackage ../applications/audio/mopidy/moped.nix { };

  mopidy-mopify = callPackage ../applications/audio/mopidy/mopify.nix { };

  mopidy-spotify-tunigo = callPackage ../applications/audio/mopidy/spotify-tunigo.nix { };

  mopidy-youtube = callPackage ../applications/audio/mopidy/youtube.nix { };

  mopidy-soundcloud = callPackage ../applications/audio/mopidy/soundcloud.nix { };

  mopidy-musicbox-webclient = callPackage ../applications/audio/mopidy/musicbox-webclient.nix { };

  mopidy-iris = callPackage ../applications/audio/mopidy/iris.nix { };

  mp3splt = callPackage ../applications/audio/mp3splt { };

  mpc_cli = callPackage ../applications/audio/mpc { };

  clerk = callPackage ../applications/audio/clerk { };

  ncmpc = callPackage ../applications/audio/ncmpc { };

  nload = callPackage ../applications/networking/nload { };

  normalize = callPackage ../applications/audio/normalize { };

  mm = callPackage ../applications/networking/instant-messengers/mm { };

  matrique = libsForQt5.callPackage ../applications/networking/instant-messengers/matrique { };

  mpc-qt = libsForQt5.callPackage ../applications/video/mpc-qt { };

  mplayer = callPackage ../applications/video/mplayer ({
    pulseSupport = config.pulseaudio or false;
    libdvdnav = libdvdnav_4_2_1;
  } // (config.mplayer or {}));

  MPlayerPlugin = browser:
    callPackage ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      # !!! should depend on MPlayer
    };

  mpv = callPackage ../applications/video/mpv rec {
    inherit (luaPackages) luasocket;
    waylandSupport     = stdenv.isLinux;
    alsaSupport        = !stdenv.isDarwin;
    pulseSupport       = !stdenv.isDarwin;
    rubberbandSupport  = !stdenv.isDarwin;
    dvdreadSupport     = !stdenv.isDarwin;
    dvdnavSupport      = !stdenv.isDarwin;
    drmSupport         = !stdenv.isDarwin;
    vaapiSupport       = !stdenv.isDarwin;
    x11Support         = !stdenv.isDarwin;
    xineramaSupport    = !stdenv.isDarwin;
    xvSupport          = !stdenv.isDarwin;
  };

  mpv-with-scripts = callPackage ../applications/video/mpv/wrapper.nix { };

  mpvScripts = {
    convert = callPackage ../applications/video/mpv/scripts/convert.nix {};
    mpris = callPackage ../applications/video/mpv/scripts/mpris.nix {};
  };

  inherit (callPackages ../applications/networking/mumble {
      avahi = avahi.override {
        withLibdnssdCompat = true;
      };
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
    }) mumble mumble_git murmur;

  inherit (callPackages ../applications/networking/mumble {
      avahi = avahi.override {
        withLibdnssdCompat = true;
      };
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or false;
      iceSupport = false;
    }) murmur_git;

  mumble_overlay = callPackage ../applications/networking/mumble/overlay.nix {
    mumble_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.mumble
      else null;
  };

  # TODO: we should probably merge these 2
  musescore =
    if stdenv.isDarwin then
      callPackage ../applications/audio/musescore/darwin.nix { }
    else
      libsForQt5.callPackage ../applications/audio/musescore { };

  mutt = callPackage ../applications/networking/mailreaders/mutt { };
  mutt-with-sidebar = mutt.override {
    withSidebar = true;
  };

  mwic = callPackage ../applications/misc/mwic {
    pythonPackages = python3Packages;
  };

  p4v = libsForQt5.callPackage ../applications/version-management/p4v { };

  pcmanfm = callPackage ../applications/misc/pcmanfm { };

  pcmanfm-qt = lxqt.pcmanfm-qt;

  pig = callPackage ../applications/networking/cluster/pig { };

  planner = callPackage ../applications/office/planner { };

  playonlinux = callPackage ../applications/misc/playonlinux {
     stdenv = stdenv_32bit;
  };

  qtcurve = libsForQt5.callPackage ../misc/themes/qtcurve {};

  rssguard = libsForQt5.callPackage ../applications/networking/feedreaders/rssguard { };

  shotcut = libsForQt5.callPackage ../applications/video/shotcut {
    libmlt = mlt;
  };

  smplayer = libsForQt5.callPackage ../applications/video/smplayer { };

  smtube = libsForQt5.callPackage ../applications/video/smtube {};

  sup = callPackage ../applications/networking/mailreaders/sup {
    ruby = ruby_2_3.override { cursesSupport = true; };
  };

  synapse = callPackage ../applications/misc/synapse {
    inherit (gnome3) libgee;
  };

  synapse-bt = callPackage ../applications/networking/p2p/synapse-bt {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  synfigstudio = callPackage ../applications/graphics/synfigstudio {
    inherit (gnome3) defaultIconTheme;
    mlt-qt5 = libsForQt5.mlt;
  };

  librep = callPackage ../development/libraries/librep { };

  sidplayfp = callPackage ../applications/audio/sidplayfp { };

  sxhkd = callPackage ../applications/window-managers/sxhkd { };

  sxhkd-unstable = callPackage ../applications/window-managers/sxhkd/unstable.nix { };

  mpop = callPackage ../applications/networking/mpop {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  msmtp = callPackage ../applications/networking/msmtp {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
 };

  maxscale = callPackage ../tools/networking/maxscale {
    stdenv = overrideCC stdenv gcc6;
  };

  diffpdf = libsForQt5.callPackage ../applications/misc/diffpdf { };

  diff-pdf = callPackage ../applications/misc/diff-pdf { wxGTK = wxGTK31; };

  mypaint = callPackage ../applications/graphics/mypaint { };

  mythtv = libsForQt5.callPackage ../applications/video/mythtv { };

  micro = callPackage ../applications/editors/micro { };

  nano = callPackage ../applications/editors/nano { };

  navit = libsForQt5.callPackage ../applications/misc/navit { };

  ncview = callPackage ../tools/X11/ncview { } ;

  ne = callPackage ../applications/editors/ne { };

  nheko = libsForQt5.callPackage ../applications/networking/instant-messengers/nheko { };

  nomacs = libsForQt5.callPackage ../applications/graphics/nomacs { };

  notepadqq = libsForQt5.callPackage ../applications/editors/notepadqq { };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    gmime = gmime3;
  };

  notmuch-mutt = callPackage ../applications/networking/mailreaders/notmuch/mutt.nix { };

  muchsync = callPackage ../applications/networking/mailreaders/notmuch/muchsync.nix { };

  nova-filters =  callPackage ../applications/audio/nova-filters { };

  nvi = callPackage ../applications/editors/nvi { };

  obconf = callPackage ../tools/X11/obconf {
    inherit (gnome2) libglade;
  };

  obs-linuxbrowser = callPackage ../applications/video/obs-studio/linuxbrowser.nix { };

  obs-studio = libsForQt5.callPackage ../applications/video/obs-studio {
    alsaSupport = stdenv.isLinux;
    pulseaudioSupport = config.pulseaudio or true;
  };

  octoprint = callPackage ../applications/misc/octoprint { };

  octoprint-plugins = callPackage ../applications/misc/octoprint/plugins.nix { };

  omegat = callPackage ../applications/misc/omegat.nix { };

  openbox = callPackage ../applications/window-managers/openbox { };

  openbrf = libsForQt5.callPackage ../applications/misc/openbrf { };

  openimageio = callPackage ../applications/graphics/openimageio {
    stdenv = overrideCC stdenv gcc6;
  };

  openorienteering-mapper = libsForQt5.callPackage ../applications/gis/openorienteering-mapper { };

  opentimestamps-client = python3Packages.callPackage ../tools/misc/opentimestamps-client {};

  opentx = callPackage ../applications/misc/opentx {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  orca = python3Packages.callPackage ../applications/misc/orca {
    inherit (gnome3) yelp-tools;
  };

  osm2xmap = callPackage ../applications/misc/osm2xmap {
    libyamlcpp = libyamlcpp_0_3;
  };

  vivaldi = callPackage ../applications/networking/browsers/vivaldi {};

  vivaldi-ffmpeg-codecs = callPackage ../applications/networking/browsers/vivaldi/ffmpeg-codecs.nix {};

  opusTools = callPackage ../applications/audio/opus-tools { };

  orpie = callPackage ../applications/misc/orpie {
    gsl = gsl_1;
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  osmo = callPackage ../applications/office/osmo { };

  palemoon = callPackage ../applications/networking/browsers/palemoon {
    # https://forum.palemoon.org/viewtopic.php?f=57&t=15296#p111146
    stdenv = overrideCC stdenv gcc49;
  };

  pamix = callPackage ../applications/audio/pamix { };

  pamixer = callPackage ../applications/audio/pamixer { };

  pan = callPackage ../applications/networking/newsreaders/pan { };

  paraview = libsForQt59.callPackage ../applications/graphics/paraview { };

  packet = callPackage ../development/tools/packet { };

  pcsxr = callPackage ../misc/emulators/pcsxr {
    ffmpeg = ffmpeg_2;
  };

  pcsx2 = pkgsi686Linux.callPackage ../misc/emulators/pcsx2 { };

  pencil = callPackage ../applications/graphics/pencil {
  };

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome2) libgnomecanvas;
  };

  pdfgrep  = callPackage ../tools/typesetting/pdfgrep { };

  pdfpc = callPackage ../applications/misc/pdfpc {
    inherit (gnome3) libgee;
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  peek = callPackage ../applications/video/peek { };

  photoqt = libsForQt5.callPackage ../applications/graphics/photoqt { };

  phototonic = libsForQt5.callPackage ../applications/graphics/phototonic { };

  picard = callPackage ../applications/audio/picard { };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    openssl = if config.pidgin.openssl or true then openssl else null;
    gnutls = if config.pidgin.gnutls or false then gnutls else null;
    libgcrypt = if config.pidgin.gnutls or false then libgcrypt else null;
    startupnotification = libstartup_notification;
    plugins = [];
  };

  pidgin-latex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    texLive = texlive.combined.scheme-basic;
  };

  pidgin-msn-pecan = callPackage ../applications/networking/instant-messengers/pidgin-plugins/msn-pecan { };

  pidgin-carbons = callPackage ../applications/networking/instant-messengers/pidgin-plugins/carbons { };

  pidgin-otr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidgin-sipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  pidgin-window-merge = callPackage ../applications/networking/instant-messengers/pidgin-plugins/window-merge { };

  toxprpl = callPackage ../applications/networking/instant-messengers/pidgin-plugins/tox-prpl {
    libtoxcore = libtoxcore-new;
  };

  pithos = callPackage ../applications/audio/pithos {
    pythonPackages = python3Packages;
  };

  pinpoint = callPackage ../applications/office/pinpoint {
    inherit (gnome3) clutter clutter-gtk;
  };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtk-sharp-2_0;
  };

  plex-media-player = libsForQt59.callPackage ../applications/video/plex-media-player { };

  plover = recurseIntoAttrs (callPackage ../applications/misc/plover { });

  pmenu = callPackage ../applications/misc/pmenu { };

  poezio = python3Packages.poezio;

  pommed = callPackage ../os-specific/linux/pommed {};

  pommed_light = callPackage ../os-specific/linux/pommed-light {};

  pond = callPackage ../applications/networking/instant-messengers/pond { };

  qiv = callPackage ../applications/graphics/qiv { };

  processing = processing3;
  processing3 = callPackage ../applications/graphics/processing3 {
    jdk = oraclejdk8;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  profanity = callPackage ../applications/networking/instant-messengers/profanity {
    notifySupport   = config.profanity.notifySupport   or true;
    traySupport     = config.profanity.traySupport     or true;
    autoAwaySupport = config.profanity.autoAwaySupport or true;
    python = python3;
  };

  protonmail-bridge = libsForQt5.callPackage ../applications/networking/protonmail-bridge { };

  psi = callPackage ../applications/networking/instant-messengers/psi { };

  pulseview = libsForQt5.callPackage ../applications/science/electronics/pulseview { };

  puredata = callPackage ../applications/audio/puredata { };
  puredata-with-plugins = plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qbittorrent = libsForQt5.callPackage ../applications/networking/p2p/qbittorrent { };

  qcomicbook = libsForQt5.callPackage ../applications/graphics/qcomicbook { };

  eiskaltdcpp = callPackage ../applications/networking/p2p/eiskaltdcpp {
    lua5 = lua5_1;
    miniupnpc = miniupnpc_1;
  };

  qdirstat = libsForQt5.callPackage ../applications/misc/qdirstat {};

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa;
    inherit (darwin.stubs) rez setfile;
  };

  qgis = callPackage ../applications/gis/qgis {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
    saga = saga_2_3_2;
  };

  qgroundcontrol = libsForQt5.callPackage ../applications/science/robotics/qgroundcontrol { };

  qjackctl = libsForQt5.callPackage ../applications/audio/qjackctl { };

  qmapshack = libsForQt5.callPackage ../applications/misc/qmapshack { };

  qmediathekview = libsForQt5.callPackage ../applications/video/qmediathekview { };

  qmmp = libsForQt5.callPackage ../applications/audio/qmmp { };

  qsampler = libsForQt5.callPackage ../applications/audio/qsampler { };

  qscreenshot = callPackage ../applications/graphics/qscreenshot {
    inherit (darwin.apple_sdk.frameworks) Carbon;
    qt = qt4;
  };

  qsstv = qt5.callPackage ../applications/misc/qsstv { };

  qsyncthingtray = libsForQt5.callPackage ../applications/misc/qsyncthingtray { };

  qstopmotion = libsForQt5.callPackage ../applications/video/qstopmotion { };

  qsynth = libsForQt5.callPackage ../applications/audio/qsynth { };

  qtchan = callPackage ../applications/networking/browsers/qtchan {
    qt = qt5;
  };

  qtox = libsForQt5.callPackage ../applications/networking/instant-messengers/qtox { };

  qtpass = libsForQt5.callPackage ../applications/misc/qtpass { };

  quassel = libsForQt5.callPackage ../applications/networking/irc/quassel {
    monolithic = true;
    daemon = false;
    client = false;
    withKDE = true;
    dconf = gnome3.dconf;
    tag = "-kf5";
  };

  quasselClient = quassel.override {
    monolithic = false;
    client = true;
    tag = "-client-kf5";
  };

  quasselDaemon = quassel.override {
    monolithic = false;
    daemon = true;
    tag = "-daemon-qt5";
    withKDE = false;
  };

  quassel-webserver = nodePackages.quassel-webserver;

  quiterss = libsForQt5.callPackage ../applications/networking/newsreaders/quiterss {};

  falkon = libsForQt5.callPackage ../applications/networking/browsers/falkon { };

  quodlibet = callPackage ../applications/audio/quodlibet {
    keybinder3 = null;
    libmodplug = null;
    kakasi = null;
    libappindicator-gtk3 = null;
  };

  quodlibet-without-gst-plugins = quodlibet.override {
    withGstPlugins = false;
    tag = "-without-gst-plugins";
  };

  quodlibet-xine = quodlibet.override { xineBackend = true; tag = "-xine"; };

  quodlibet-full = quodlibet.override {
    inherit (gnome3) gtksourceview webkitgtk;
    withDbusPython = true;
    withPyInotify = true;
    withMusicBrainzNgs = true;
    withPahoMqtt = true;
    keybinder3 = keybinder3;
    libmodplug = libmodplug;
    kakasi = kakasi;
    libappindicator-gtk3 = libappindicator-gtk3;
    tag = "-full";
  };

  quodlibet-xine-full = quodlibet-full.override { xineBackend = true; tag = "-xine-full"; };

  qutebrowser = libsForQt5.callPackage ../applications/networking/browsers/qutebrowser { };

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  radiotray-ng = callPackage ../applications/audio/radiotray-ng {
    wxGTK = wxGTK30;
  };

  rapcad = libsForQt5.callPackage ../applications/graphics/rapcad { boost = boost159; };

  rapid-photo-downloader = libsForQt5.callPackage ../applications/graphics/rapid-photo-downloader { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
  };

  rclone = callPackage ../applications/networking/sync/rclone { };

  rclone-browser = libsForQt5.callPackage ../applications/networking/sync/rclone/browser.nix { };

  rcs = callPackage ../applications/version-management/rcs { };

  realpine = callPackage ../applications/networking/mailreaders/realpine {
    tcl = tcl-8_5;
  };

  rednotebook = python3Packages.callPackage ../applications/editors/rednotebook { };

  retroshare = libsForQt5.callPackage ../applications/networking/p2p/retroshare { };
  retroshare06 = retroshare;

  ricochet = libsForQt5.callPackage ../applications/networking/instant-messengers/ricochet { };

  ries = callPackage ../applications/science/math/ries { };

  rkt = callPackage ../applications/virtualization/rkt { };

  rofi-unwrapped = callPackage ../applications/misc/rofi { };
  rofi = callPackage ../applications/misc/rofi/wrapper.nix { };

  rofi-pass = callPackage ../tools/security/pass/rofi-pass.nix { };

  rpcs3 = libsForQt5.callPackage ../misc/emulators/rpcs3 { };

  rstudio = libsForQt5.callPackage ../applications/editors/rstudio {
    boost = boost166;
  };
  rstudio-preview = libsForQt5.callPackage ../applications/editors/rstudio/preview.nix {
    boost = boost166;
    llvmPackages = llvmPackages_7;
  };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS || stdenv.isFreeBSD);
    enableCopyDevicesPatch = (config.rsync.enableCopyDevicesPatch or false);
  };
  rrsync = callPackage ../applications/networking/sync/rsync/rrsync.nix {};

  runc = callPackage ../applications/virtualization/runc {};

  rxvt = callPackage ../applications/misc/rxvt { };

  # urxvt
  rxvt_unicode = callPackage ../applications/misc/rxvt_unicode {
    perlSupport = true;
    gdkPixbufSupport = true;
    unicode3Support = true;
  };

  rxvt_unicode-with-plugins = callPackage ../applications/misc/rxvt_unicode/wrapper.nix {
    plugins = [
      urxvt_autocomplete_all_the_things
      urxvt_perl
      urxvt_perls
      urxvt_tabbedex
      urxvt_font_size
      urxvt_theme_switch
      urxvt_vtwheel
    ];
  };

  # urxvt plugins
  urxvt_autocomplete_all_the_things = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-autocomplete-all-the-things { };
  urxvt_perl = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perl { };
  urxvt_perls = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perls { };
  urxvt_tabbedex = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-tabbedex { };
  urxvt_font_size = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-font-size { };
  urxvt_theme_switch = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-theme-switch { };
  urxvt_vtwheel = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-vtwheel.nix { };

  udiskie = python3Packages.callPackage ../applications/misc/udiskie { };

  sakura = callPackage ../applications/misc/sakura {
    vte = gnome3.vte;
  };

  scantailor = callPackage ../applications/graphics/scantailor { };

  scantailor-advanced = qt5.callPackage ../applications/graphics/scantailor/advanced.nix { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome2) libart_lgpl;
  };

  scribusUnstable = libsForQt5.callPackage ../applications/office/scribus/unstable.nix { };

  seafile-client = libsForQt5.callPackage ../applications/networking/seafile-client { };

  seeks = callPackage ../tools/networking/p2p/seeks {
    protobuf = protobuf3_1;
  };

  seg3d = callPackage ../applications/graphics/seg3d {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  sent = callPackage ../applications/misc/sent { };

  sfxr-qt = libsForQt5.callPackage ../applications/audio/sfxr-qt { };

  simple-scan = gnome3.simple-scan;

  skype_call_recorder = callPackage ../applications/networking/instant-messengers/skype-call-recorder { };

  squishyball = callPackage ../applications/audio/squishyball {
    ncurses = ncurses5;
  };

  stupidterm = callPackage ../applications/misc/stupidterm {
    vte = gnome3.vte;
    gtk = gtk3;
  };

  sonic-pi = callPackage ../applications/audio/sonic-pi {
    ruby = ruby_2_3;
  };

  st = callPackage ../applications/misc/st {
    conf = config.st.conf or null;
    patches = config.st.patches or [];
    extraLibs = config.st.extraLibs or [];
  };

  xst = callPackage ../applications/misc/st/xst.nix { };

  stag = callPackage ../applications/misc/stag {
    curses = ncurses;
  };

  stella = callPackage ../misc/emulators/stella { };

  sweethome3d = recurseIntoAttrs (  (callPackage ../applications/misc/sweethome3d { })
                                 // (callPackage ../applications/misc/sweethome3d/editors.nix {
                                      sweethome3dApp = sweethome3d.application;
                                    })
                                 );

  bittorrentSync = bittorrentSync14;
  bittorrentSync14 = callPackage ../applications/networking/bittorrentsync/1.4.x.nix { };
  bittorrentSync20 = callPackage ../applications/networking/bittorrentsync/2.0.x.nix { };

  dropbox = callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox/cli.nix { };

  lightdm = libsForQt5.callPackage ../applications/display-managers/lightdm { };

  lightdm_qt = lightdm.override { withQt5 = true; };

  lightdm-enso-os-greeter = callPackage ../applications/display-managers/lightdm-enso-os-greeter {
    inherit (gnome3) libgee;
    inherit (xorg) libX11 libXdmcp libpthreadstubs;
  };

  lightdm_gtk_greeter = callPackage ../applications/display-managers/lightdm/gtk-greeter.nix {
    inherit (xfce) exo;
  };

  ly = callPackage ../applications/display-managers/ly { };

  slic3r = callPackage ../applications/misc/slic3r { };

  slic3r-prusa3d = callPackage ../applications/misc/slic3r/prusa3d.nix { };

  curaengine_stable = callPackage ../applications/misc/curaengine/stable.nix { };
  cura_stable = callPackage ../applications/misc/cura/stable.nix {
    curaengine = curaengine_stable;
  };

  curaengine = callPackage ../applications/misc/curaengine {
    inherit (python3.pkgs) libarcus;
  };
  cura = qt5.callPackage ../applications/misc/cura { };

  curaLulzbot = callPackage ../applications/misc/cura/lulzbot.nix { };

  curaByDagoma = callPackage ../applications/misc/curabydagoma { };

  peru = callPackage ../applications/version-management/peru {};

  sddm = libsForQt5.callPackage ../applications/display-managers/sddm { };

  skrooge = libsForQt5.callPackage ../applications/office/skrooge {};

  slim = callPackage ../applications/display-managers/slim {
    libpng = libpng12;
  };

  slimThemes = recurseIntoAttrs (callPackage ../applications/display-managers/slim/themes.nix {});

  snapper = callPackage ../tools/misc/snapper { };

  snd = callPackage ../applications/audio/snd { };

  skanlite = libsForQt5.callPackage ../applications/office/skanlite { };

  sonic-visualiser = libsForQt5.callPackage ../applications/audio/sonic-visualiser {
    inherit (pkgs.vamp) vampSDK;
  };

  soulseekqt = libsForQt5.callPackage ../applications/networking/p2p/soulseekqt { };

  sox = callPackage ../applications/misc/audio/sox {
    enableLame = config.sox.enableLame or false;
  };

  spek = callPackage ../applications/audio/spek {
    ffmpeg = ffmpeg_2;
  };

  spotify = callPackage ../applications/audio/spotify {
    libgcrypt = libgcrypt_1_5;
    libpng = libpng12;
    curl = curl.override {
      sslSupport = false; gnutlsSupport = true;
    };
  };

  libspotify = callPackage ../development/libraries/libspotify {
    apiKey = config.libspotify.apiKey or null;
  };

  src = callPackage ../applications/version-management/src {
    git = gitMinimal;
  };

  ssr = callPackage ../applications/audio/soundscape-renderer {};

  inherit (ocamlPackages) stog;

  stp = callPackage ../applications/science/logic/stp {};

  stumpwm = callPackage ../applications/window-managers/stumpwm {
    version = "latest";
  };

  stumpwm-git = stumpwm.override {
    version = "git";
    inherit sbcl lispPackages;
  };

  sublime = callPackage ../applications/editors/sublime/2 { };

  sublime3Packages = recurseIntoAttrs (callPackage ../applications/editors/sublime/3/packages.nix { });

  sublime3 = sublime3Packages.sublime3;

  sublime3-dev = sublime3Packages.sublime3-dev;

  inherit (callPackages ../applications/version-management/subversion {
      bdbSupport = true;
      httpServer = false;
      httpSupport = true;
      pythonBindings = false;
      perlBindings = false;
      javahlBindings = false;
      saslSupport = false;
      sasl = cyrus_sasl;
    })
    subversion18 subversion19 subversion_1_10 subversion_1_11;

  subversion = subversion_1_11;

  subversionClient = appendToName "client" (pkgs.subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  });

  surf = callPackage ../applications/networking/browsers/surf { gtk = gtk2; };

  swh_lv2 = callPackage ../applications/audio/swh-lv2 { };

  swift-im = libsForQt5.callPackage ../applications/networking/instant-messengers/swift-im {
    inherit (gnome2) GConf;
  };

  inherit (callPackages ../applications/networking/syncthing { })
    syncthing
    syncthing-cli
    syncthing-discovery
    syncthing-relay;

  syncthing-gtk = python2Packages.callPackage ../applications/networking/syncthing-gtk { };

  synergy = callPackage ../applications/misc/synergy {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa CoreServices ScreenSaver;
  };

  tabbed = callPackage ../applications/window-managers/tabbed {
    # if you prefer a custom config, write the config.h in tabbed.config.h
    # and enable
    # customConfig = builtins.readFile ./tabbed.config.h;
  };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages;
  };

  tailor = callPackage ../applications/version-management/tailor {};

  tangogps = callPackage ../applications/misc/tangogps {
    gconf = gnome2.GConf;
  };

  teamspeak_client = libsForQt5.callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };
  teamspeak_server = callPackage ../applications/networking/instant-messengers/teamspeak/server.nix { };

  tdesktopPackages = callPackage ../applications/networking/instant-messengers/telegram/tdesktop { };
  tdesktop = tdesktopPackages.stable;

  telepathy-gabble = callPackage ../applications/networking/instant-messengers/telepathy/gabble { };

  telepathy-haze = callPackage ../applications/networking/instant-messengers/telepathy/haze {};

  telepathy-logger = callPackage ../applications/networking/instant-messengers/telepathy/logger {};

  telepathy-mission-control = callPackage ../applications/networking/instant-messengers/telepathy/mission-control { };

  telepathy-salut = callPackage ../applications/networking/instant-messengers/telepathy/salut {};

  telepathy-idle = callPackage ../applications/networking/instant-messengers/telepathy/idle {};

  termdown = (newScope pythonPackages) ../applications/misc/termdown { };

  terminus = callPackage ../applications/misc/terminus { };

  lxterminal = callPackage ../applications/misc/lxterminal {
    vte = gnome3.vte;
  };

  termite-unwrapped = callPackage ../applications/misc/termite {
    vte = gnome3.vte-ng;
  };

  termite = callPackage ../applications/misc/termite/wrapper.nix { termite = termite-unwrapped; };

  tesseract = callPackage ../applications/graphics/tesseract { };
  tesseract_4 = lowPrio (callPackage ../applications/graphics/tesseract/4.x.nix { });

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  thunderbird = callPackage ../applications/networking/mailreaders/thunderbird {
    inherit (gnome2) libIDL;
    libpng = libpng_apng;
    enableGTK3 = true;
  };

  thunderbird-bin = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
    inherit (pkgs.gnome3) defaultIconTheme;
  };

  tig = gitAndTools.tig;

  tilda = callPackage ../applications/misc/tilda {
    vte = gnome3.vte;
    gtk = gtk3;
  };

  timbreid = callPackage ../applications/audio/pd-plugins/timbreid {
    fftw = fftwSinglePrec;
  };

  timescaledb = callPackage ../servers/sql/postgresql/timescaledb {};

  tla = callPackage ../applications/version-management/arch { };

  tlp = callPackage ../tools/misc/tlp {
    inherit (linuxPackages) x86_energy_perf_policy;
  };

  tnef = callPackage ../applications/misc/tnef { };

  todo-txt-cli = callPackage ../applications/office/todo.txt-cli { };

  toggldesktop = libsForQt5.callPackage ../applications/misc/toggldesktop { };

  tomahawk = callPackage ../applications/audio/tomahawk {
    taglib = taglib_1_9;
    enableXMPP      = config.tomahawk.enableXMPP      or true;
    enableKDE       = config.tomahawk.enableKDE       or false;
    enableTelepathy = config.tomahawk.enableTelepathy or false;
    quazip = quazip_qt4;
    boost = boost155;
  };

  torchPackages = recurseIntoAttrs ( callPackage ../applications/science/machine-learning/torch {
    lua = luajit ;
  } );

  torch-repl = lib.setName "torch-repl" torchPackages.trepl;

  torchat = callPackage ../applications/networking/instant-messengers/torchat {
    inherit (pythonPackages) wrapPython wxPython;
  };

  toot = callPackage ../applications/misc/toot { };

  transmission = callPackage ../applications/networking/p2p/transmission { };
  transmission-gtk = transmission.override { enableGTK3 = true; };

  tree = callPackage ../tools/system/tree {};

  treesheets = callPackage ../applications/office/treesheets { wxGTK = wxGTK31; };

  trojita = libsForQt5.callPackage ../applications/networking/mailreaders/trojita { };

  twister = callPackage ../applications/networking/p2p/twister {
    boost = boost160;
  };

  twmn = libsForQt5.callPackage ../applications/misc/twmn { };

  udocker = pythonPackages.callPackage ../tools/virtualization/udocker { };

  inherit (ocaml-ng.ocamlPackages_4_05) unison;

  uuagc = haskell.lib.justStaticExecutables haskellPackages.uuagc;

  uzbl = callPackage ../applications/networking/browsers/uzbl {
    webkit = webkitgtk24x-gtk2;
  };

  valentina = libsForQt5.callPackage ../applications/misc/valentina { };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  verbiste = callPackage ../applications/misc/verbiste {
    inherit (gnome2) libgnomeui;
  };

  vim = callPackage ../applications/editors/vim {
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  vimiv = callPackage ../applications/graphics/vimiv {
    inherit (gnome3) defaultIconTheme;
  };

  macvim = callPackage ../applications/editors/vim/macvim.nix { stdenv = clangStdenv; };

  vimHugeX = vim_configurable;

  vim_configurable = vimUtils.makeCustomizable (callPackage ../applications/editors/vim/configurable.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc cf-private;
    gtk2 = if stdenv.isDarwin then gtk2-x11 else gtk2;
    gtk3 = if stdenv.isDarwin then gtk3-x11 else gtk3;
  });

  qpdfview = libsForQt5.callPackage ../applications/misc/qpdfview {};

  qtile = callPackage ../applications/window-managers/qtile {
    inherit (xorg) libxcb;
  };

  qvim = lowPrio (callPackage ../applications/editors/vim/qvim.nix {
    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  wrapNeovim = callPackage ../applications/editors/neovim/wrapper.nix { };

  neovim-unwrapped = callPackage ../applications/editors/neovim {
    luaPackages = luajitPackages;
  };

  neovim = wrapNeovim neovim-unwrapped { };

  neovim-qt = libsForQt5.callPackage ../applications/editors/neovim/qt.nix { };

  neovim-pygui = pythonPackages.neovim_gui;

  neovim-remote = callPackage ../applications/editors/neovim/neovim-remote.nix { pythonPackages = python3Packages; };

  vis = callPackage ../applications/editors/vis {
    inherit (lua52Packages) lpeg;
  };

  virtmanager = callPackage ../applications/virtualization/virt-manager {
    vte = gnome3.vte;
    dconf = gnome3.dconf;
    system-libvirt = libvirt;
  };

  virtmanager-qt = libsForQt5.callPackage ../applications/virtualization/virt-manager/qt.nix {
    qtermwidget = lxqt.qtermwidget;
  };

  virtualbox = callPackage ../applications/virtualization/virtualbox {
    stdenv = stdenv_32bit;
    inherit (gnome2) libIDL;
    pulseSupport = config.pulseaudio or true;
  };

  virtualboxHardened = lowPrio (virtualbox.override {
    enableHardening = true;
  });

  virtualboxHeadless = lowPrio (virtualbox.override {
    enableHardening = true;
    headless = true;
  });

  virtualboxExtpack = callPackage ../applications/virtualization/virtualbox/extpack.nix { };

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

  vlc = libsForQt5.vlc;

  vlc_qt5 = vlc;

  vogl = libsForQt5.callPackage ../development/tools/vogl { };

  vscode = callPackage ../applications/editors/vscode { };

  vscode-with-extensions = callPackage ../applications/editors/vscode/with-extensions.nix {};

  vscode-utils = callPackage ../misc/vscode-extensions/vscode-utils.nix {};

  vscode-extensions = recurseIntoAttrs (callPackage ../misc/vscode-extensions {});

  vwm = callPackage ../applications/window-managers/vwm { };

  vym = qt5.callPackage ../applications/misc/vym { };

  w3m = callPackage ../applications/networking/browsers/w3m {
    graphicsSupport = !stdenv.isDarwin;
  };

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

  watson = callPackage ../applications/office/watson {
    pythonPackages = python3Packages;
  };

  weechat = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libobjc;
    inherit (darwin) libresolv;
    guile = guile_2_0;
  };

  weechatScripts = callPackage ../applications/networking/irc/weechat/scripts { };

  westonLite = weston.override {
    pango = null;
    freerdp = null;
    libunwind = null;
    vaapi = null;
    libva = null;
    libwebp = null;
    xwayland = null;
  };

  weston = callPackage ../applications/window-managers/weston {
    freerdp = freerdp_legacy;
  };

  whitebox-tools = callPackage ../applications/gis/whitebox-tools {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  windowmaker = callPackage ../applications/window-managers/windowmaker { };

  wings = callPackage ../applications/graphics/wings {
    esdl = esdl.override { erlang = erlangR18; };
    erlang = erlangR18;
  };

  write_stylus = libsForQt5.callPackage ../applications/graphics/write_stylus { };

  alsamixer.app = callPackage ../applications/window-managers/windowmaker/dockapps/alsamixer.app.nix { };

  wllvm = callPackage  ../development/tools/wllvm { };

  wmcalclock = callPackage ../applications/window-managers/windowmaker/dockapps/wmcalclock.nix { };

  wmsm.app = callPackage ../applications/window-managers/windowmaker/dockapps/wmsm.app.nix { };

  wmsystemtray = callPackage ../applications/window-managers/windowmaker/dockapps/wmsystemtray.nix { };

  wmii_hg = callPackage ../applications/window-managers/wmii-hg { };

  workrave = callPackage ../applications/misc/workrave {
    inherit (python27Packages) cheetah;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  worldengine-cli = python3Packages.worldengine;

  wrapFirefox = callPackage ../applications/networking/browsers/firefox/wrapper.nix { };

  retroArchCores =
    let
      cfg = config.retroarch or {};
      inherit (lib) optional;
    in with libretro;
      ([ ]
      ++ optional (cfg.enable4do or false) _4do
      ++ optional (cfg.enableBeetlePCEFast or false) beetle-pce-fast
      ++ optional (cfg.enableBeetlePSX or false) beetle-psx
      ++ optional (cfg.enableBeetleSaturn or false) beetle-saturn
      ++ optional (cfg.enableBsnesMercury or false) bsnes-mercury
      ++ optional (cfg.enableDesmume or false) desmume
      ++ optional (cfg.enableDolphin or false) dolphin
      ++ optional (cfg.enableFBA or false) fba
      ++ optional (cfg.enableFceumm or false) fceumm
      ++ optional (cfg.enableGambatte or false) gambatte
      ++ optional (cfg.enableGenesisPlusGX or false) genesis-plus-gx
      ++ optional (cfg.enableHiganSFC or false) higan-sfc
      ++ optional (cfg.enableMAME or false) mame
      ++ optional (cfg.enableMGBA or false) mgba
      ++ optional (cfg.enableMupen64Plus or false) mupen64plus
      ++ optional (cfg.enableNestopia or false) nestopia
      ++ optional (cfg.enableParallelN64 or false) parallel-n64
      ++ optional (cfg.enablePicodrive or false) picodrive
      ++ optional (cfg.enablePrboom or false) prboom
      ++ optional (cfg.enablePPSSPP or false) ppsspp
      ++ optional (cfg.enableQuickNES or false) quicknes
      ++ optional (cfg.enableReicast or false) reicast
      ++ optional (cfg.enableScummVM or false) scummvm
      ++ optional (cfg.enableSnes9x or false) snes9x
      ++ optional (cfg.enableSnes9xNext or false) snes9x-next
      ++ optional (cfg.enableStella or false) stella
      ++ optional (cfg.enableVbaNext or false) vba-next
      ++ optional (cfg.enableVbaM or false) vba-m

      # added on 2017-02-25 due #23163
      ++ optional (cfg.enableMednafenPCEFast or false)
          (throw "nix config option enableMednafenPCEFast has been renamed to enableBeetlePCEFast")
      ++ optional (cfg.enableMednafenPSX or false)
          (throw "nix config option enableMednafenPSX has been renamed to enableBeetlePSX")
      ++ optional (cfg.enableMednafenSaturn or false)
          (throw "nix config option enableMednafenSaturn has been renamed to enableBeetleSaturn")
      );

  wrapRetroArch = { retroarch }: callPackage ../misc/emulators/retroarch/wrapper.nix {
    inherit retroarch;
    cores = retroArchCores;
  };

  wrapKodi = { kodi }: callPackage ../applications/video/kodi/wrapper.nix {
    inherit kodi;
    plugins = let inherit (lib) optional optionals; in with kodiPlugins;
      ([]
      ++ optional (config.kodi.enableAdvancedLauncher or false) advanced-launcher
      ++ optional (config.kodi.enableAdvancedEmulatorLauncher or false)
        advanced-emulator-launcher
      ++ optionals (config.kodi.enableControllers or false)
        (with controllers;
          [ default dreamcast gba genesis mouse n64 nes ps snes ])
      ++ optional (config.kodi.enableExodus or false) exodus
      ++ optionals (config.kodi.enableHyperLauncher or false)
           (with hyper-launcher; [ plugin service pdfreader ])
      ++ optional (config.kodi.enableJoystick or false) joystick
      ++ optional (config.kodi.enableOSMCskin or false) osmc-skin
      ++ optional (config.kodi.enableSVTPlay or false) svtplay
      ++ optional (config.kodi.enableSteamController or false) steam-controller
      ++ optional (config.kodi.enableSteamLauncher or false) steam-launcher
      ++ optional (config.kodi.enablePVRHTS or false) pvr-hts
      ++ optional (config.kodi.enablePVRHDHomeRun or false) pvr-hdhomerun
      ++ optional (config.kodi.enablePVRIPTVSimple or false) pvr-iptvsimple
      );
  };

  wsjtx = qt5.callPackage ../applications/misc/wsjtx { };

  wxhexeditor = callPackage ../applications/editors/wxhexeditor {
    wxGTK = wxGTK31;
  };

  wxcam = callPackage ../applications/video/wxcam {
    inherit (gnome2) libglade;
    wxGTK = wxGTK28;
    gtk = gtk2;
  };

  x2goclient = libsForQt5.callPackage ../applications/networking/remote/x2goclient { };

  x32edit = callPackage ../applications/audio/midas/x32edit.nix {};

  xaos = callPackage ../applications/graphics/xaos {
    libpng = libpng12;
  };

  xastir = callPackage ../applications/misc/xastir {
    rastermagick = imagemagick;
    inherit (xorg) libXt;
  };

  xbindkeys = callPackage ../tools/X11/xbindkeys { };

  xbindkeys-config = callPackage ../tools/X11/xbindkeys-config {
    gtk = gtk2;
  };

  kodiPlain = callPackage ../applications/video/kodi { };

  kodiPlugins = recurseIntoAttrs (callPackage ../applications/video/kodi/plugins.nix {});

  kodi = wrapKodi {
    kodi = kodiPlain;
  };

  kodi-retroarch-advanced-launchers =
    callPackage ../misc/emulators/retroarch/kodi-advanced-launchers.nix {
      cores = retroArchCores;
  };
  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers;

  xca = libsForQt5.callPackage ../applications/misc/xca { };

  inherit (xorg) xcompmgr;

  inherit (callPackage ../applications/window-managers/compton {}) compton compton-git;

  xdg-desktop-portal = callPackage ../development/libraries/xdg-desktop-portal { };

  xdg_utils = callPackage ../tools/X11/xdg-utils {
    w3m = w3m-batch;
  };

  xenPackages = recurseIntoAttrs (callPackage ../applications/virtualization/xen/packages.nix {});

  xen = xenPackages.xen-vanilla;
  xen-slim = xenPackages.xen-slim;
  xen-light = xenPackages.xen-light;

  xen_4_8 = xenPackages.xen_4_8-vanilla;
  xen_4_8-slim = xenPackages.xen_4_8-slim;
  xen_4_8-light = xenPackages.xen_4_8-light;
  xen_4_10 = xenPackages.xen_4_10-vanilla;
  xen_4_10-slim = xenPackages.xen_4_10-slim;
  xen_4_10-light = xenPackages.xen_4_10-light;

  xfe = callPackage ../applications/misc/xfe {
    fox = fox_1_6;
  };

  xineUI = callPackage ../applications/video/xine-ui { };

  xmind = callPackage ../applications/misc/xmind { };

  xneur = callPackage ../applications/misc/xneur { };

  gxneur = callPackage ../applications/misc/gxneur  {
    inherit (gnome2) libglade GConf;
  };

  xiphos = callPackage ../applications/misc/xiphos {
    gconf = gnome2.GConf;
    inherit (gnome2) libglade scrollkeeper;
    gtkhtml = gnome2.gtkhtml4;
    python = python27;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome2) libgnomeprint libgnomeprintui libgnomecanvas;
  };

  xpdf = libsForQt5.callPackage ../applications/misc/xpdf { };

  xkb_switch = callPackage ../tools/X11/xkb-switch { };

  xmonad-with-packages = callPackage ../applications/window-managers/xmonad/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = self: [];
  };

  xmonad_log_applet = callPackage ../applications/window-managers/xmonad/log-applet {
    desktopSupport = "gnomeflashback";
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmonad_log_applet_mate = xmonad_log_applet.override {
    desktopSupport = "mate";
    inherit (xfce) libxfce4util xfce4-panel;
  };

  xmonad_log_applet_xfce = xmonad_log_applet.override {
    desktopSupport = "xfce4";
    inherit (xfce) libxfce4util xfce4-panel;
  };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra { };
  libfakeXinerama = callPackage ../tools/X11/xpra/libfakeXinerama.nix { };

  xscreensaver = callPackage ../misc/screensavers/xscreensaver {
    inherit (gnome2) libglade;
  };

  xsynth_dssi = callPackage ../applications/audio/xsynth-dssi { };

  xterm = callPackage ../applications/misc/xterm { };

  mlterm = callPackage ../applications/misc/mlterm {
    vte = gnome3.vte;
    libssh2 = null;
    openssl = null;
  };

  roxterm = callPackage ../applications/misc/roxterm {
    inherit (gnome3) gsettings-desktop-schemas vte;
  };

  xmp = callPackage ../applications/audio/xmp { };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gnome2) scrollkeeper libglade;
  };

  yabar = callPackage ../applications/window-managers/yabar { };

  yabar-unstable = callPackage ../applications/window-managers/yabar/unstable.nix { };

  yakuake = libsForQt5.callPackage ../applications/misc/yakuake {
    inherit (kdeApplications) konsole;
  };

  yed = callPackage ../applications/graphics/yed {};

  inherit (gnome3) yelp;

  yokadi = python3Packages.callPackage ../applications/misc/yokadi {};

  youtube-dl = with python3Packages; toPythonApplication youtube-dl;

  youtube-dl-light = with python3Packages; toPythonApplication youtube-dl-light;

  youtube-viewer = perlPackages.WWWYoutubeViewer;

  zanshin = libsForQt5.callPackage ../applications/office/zanshin {
    inherit (kdeApplications) akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap;
    inherit (kdeFrameworks) krunner kwallet;
    boost = boost160;
  };

  zathura = callPackage ../applications/misc/zathura {
    useMupdf = config.zathura.useMupdf or true;
  };

  zeroc_ice = callPackage ../development/libraries/zeroc-ice {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  zexy = callPackage ../applications/audio/pd-plugins/zexy  { };

  zgv = callPackage ../applications/graphics/zgv {
   # Enable the below line for terminal display. Note
   # that it requires sixel graphics compatible terminals like mlterm
   # or xterm -ti 340
   SDL = SDL_sixel;
  };

  zim = callPackage ../applications/office/zim { };

  zola = callPackage ../applications/misc/zola {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    inherit (darwin) cf-private;
  };

  zoom-us = libsForQt59.callPackage ../applications/networking/instant-messengers/zoom-us { };

  ### GAMES

  _2048-in-terminal = callPackage ../games/2048-in-terminal { };

  _20kly = callPackage ../games/20kly { };

  _90secondportraits = callPackage ../games/90secondportraits { love = love_0_10; };

  amoeba = callPackage ../games/amoeba { };
  amoeba-data = callPackage ../games/amoeba/data.nix { };

  andyetitmoves = if stdenv.isLinux then callPackage ../games/andyetitmoves {} else null;

  angband = callPackage ../games/angband { };

  anki = python3Packages.callPackage ../games/anki { };

  arena = callPackage ../games/arena {};

  arx-libertatis = callPackage ../games/arx-libertatis {
    stdenv = overrideCC stdenv gcc6;
  };

  asc = callPackage ../games/asc {
    lua = lua5_1;
    libsigcxx = libsigcxx12;
    physfs = physfs_2;
  };

  ballAndPaddle = callPackage ../games/ball-and-paddle {
    guile = guile_1_8;
  };

  beancount = with python3.pkgs; toPythonApplication beancount;

  bean-add = callPackage ../applications/office/beancount/bean-add.nix { };

  bench = haskell.lib.justStaticExecutables haskellPackages.bench;

  bitsnbots = callPackage ../games/bitsnbots {
    lua = lua5;
  };

  blackshades = callPackage ../games/blackshades { };

  cataclysm-dda = callPackage ../games/cataclysm-dda {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    ncurses = ncurses5;
  };

  cataclysm-dda-git = callPackage ../games/cataclysm-dda/git.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
  };

  chessx = libsForQt59.callPackage ../games/chessx { };

  chocolateDoom = callPackage ../games/chocolate-doom { };

  crispyDoom = callPackage ../games/crispy-doom { };

  cockatrice = libsForQt5.callPackage ../games/cockatrice {  };

  construoBase = lowPrio (callPackage ../games/construo {
    libGL = null;
    freeglut = null;
  });

  construo = construoBase.override {
    inherit  freeglut;
    libGL = libGLU_combined;
  };

  crack_attack = callPackage ../games/crack-attack { };

  crawlTiles = callPackage ../games/crawl {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  cutemaze = libsForQt5.callPackage ../games/cutemaze {};

  digikam = libsForQt5.callPackage ../applications/graphics/digikam {
    inherit (plasma5) oxygen;
    inherit (kdeApplications) kcalcore;
    opencv3 = opencv3WithoutCuda;
  };

  displaycal = (newScope pythonPackages) ../applications/graphics/displaycal {};

  duckmarines = callPackage ../games/duckmarines { love = love_0_9; };

  dwarf-fortress-packages = recurseIntoAttrs (callPackage ../games/dwarf-fortress { });

  dwarf-fortress = dwarf-fortress-packages.dwarf-fortress;

  dwarf-therapist = dwarf-fortress-packages.dwarf-therapist;

  dxx-rebirth = callPackage ../games/dxx-rebirth {
    physfs = physfs_2;
  };

  inherit (callPackages ../games/dxx-rebirth/assets.nix { })
    descent1-assets
    descent2-assets;

  inherit (callPackages ../games/dxx-rebirth/full.nix { })
    d1x-rebirth-full
    d2x-rebirth-full;

  EmptyEpsilon = callPackage ../games/empty-epsilon { };

  enyo-doom = libsForQt5.callPackage ../games/enyo-doom { };

  eternity = callPackage ../games/eternity-engine { };

  extremetuxracer = callPackage ../games/extremetuxracer {
    libpng = libpng12;
  };

  factorio = callPackage ../games/factorio { releaseType = "alpha"; };

  factorio-experimental = factorio.override { releaseType = "alpha"; experimental = true; };

  factorio-headless = factorio.override { releaseType = "headless"; };

  factorio-headless-experimental = factorio.override { releaseType = "headless"; experimental = true; };

  factorio-demo = factorio.override { releaseType = "demo"; };

  factorio-mods = callPackage ../games/factorio/mods.nix { };

  factorio-utils = callPackage ../games/factorio/utils.nix { };

  flightgear = libsForQt5.callPackage ../games/flightgear { openscenegraph = openscenegraph_3_4; };

  flock = callPackage ../development/tools/flock { };

  freeciv = callPackage ../games/freeciv { };

  freeciv_gtk = freeciv.override {
    gtkClient = true;
    sdlClient = false;
  };

  fsg = callPackage ../games/fsg {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  gambatte = callPackage ../games/gambatte { };

  garden-of-coloured-lights = callPackage ../games/garden-of-coloured-lights { allegro = allegro4; };

  gargoyle = callPackage ../games/gargoyle {
    inherit (darwin) cctools cf-private;
  };

  gcs = callPackage ../games/gcs { };

  gcompris = libsForQt59.callPackage ../games/gcompris { };

  gl117 = callPackage ../games/gl-117 {};

  globulation2 = callPackage ../games/globulation {
    boost = boost155;
  };

  gshogi = python3Packages.callPackage ../games/gshogi {};

  gtetrinet = callPackage ../games/gtetrinet {
    inherit (gnome2) GConf libgnome libgnomeui;
  };

  hawkthorne = callPackage ../games/hawkthorne { love = love_0_9; };

  hedgewars = callPackage ../games/hedgewars {
    inherit (haskellPackages) ghcWithPackages;
    ffmpeg = ffmpeg_2;
  };

  ingen = callPackage ../applications/audio/ingen {
    inherit (pythonPackages) rdflib;
  };

  instead = callPackage ../games/instead {
    lua = lua5;
  };

  lincity = callPackage ../games/lincity {};

  lincity_ng = callPackage ../games/lincity/ng.nix {
    # https://github.com/lincity-ng/lincity-ng/issues/25
    physfs = physfs_2;
  };

  liquidwar = callPackage ../games/liquidwar {
    guile = guile_2_0;
  };

  liquidwar5 = callPackage ../games/liquidwar/5.nix {
  };

  macopix = callPackage ../games/macopix {
    gtk = gtk2;
  };

  mars = callPackage ../games/mars { };

  minecraft = callPackage ../games/minecraft { };

  multimc = libsForQt5.callPackage ../games/multimc { };

  minetest = callPackage ../games/minetest {
    libpng = libpng12;
  };

  mnemosyne = callPackage ../games/mnemosyne {
    python = python3;
  };

  mudlet = libsForQt5.callPackage ../games/mudlet {
    inherit (lua51Packages) luafilesystem lrexlib luazip luasqlite3;
  };

  nethack = callPackage ../games/nethack { };

  nethack-qt = callPackage ../games/nethack { qtMode = true; };

  nethack-x11 = callPackage ../games/nethack { x11Mode = true; };

  opendungeons = callPackage ../games/opendungeons {
    ogre = ogre1_9;
  };

  openmw = callPackage ../games/openmw { };

  openmw-tes3mp = libsForQt5.callPackage ../games/openmw/tes3mp.nix { };

  openra = callPackage ../games/openra { lua = lua5_1; };

  openttd = callPackage ../games/openttd {
    zlib = zlibStatic;
  };

  pioneer = callPackage ../games/pioneer { };

  planetary_annihilation = callPackage ../games/planetaryannihilation { };

  pokerth = libsForQt5.callPackage ../games/pokerth { };

  pokerth-server = libsForQt5.callPackage ../games/pokerth { target = "server"; };

  prboom = callPackage ../games/prboom { };

  quake3wrapper = callPackage ../games/quake3/wrapper { };

  quake3demo = quake3wrapper {
    name = "quake3-demo-${lib.getVersion quake3demodata}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    paks = [ quake3pointrelease quake3demodata ];
  };

  quake3demodata = callPackage ../games/quake3/content/demo.nix { };

  quake3pointrelease = callPackage ../games/quake3/content/pointrelease.nix { };

  quakespasm = callPackage ../games/quakespasm { };
  vkquake = callPackage ../games/quakespasm/vulkan.nix { };

  ioquake3 = callPackage ../games/quake3/ioquake { };

  racer = callPackage ../games/racer { };

  residualvm = callPackage ../games/residualvm {
    openglSupport = libGLSupported;
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

  rimshot = callPackage ../games/rimshot { love = love_0_7; };

  rogue = callPackage ../games/rogue {
    ncurses = ncurses5;
  };

  saga = callPackage ../applications/gis/saga {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  saga_2_3_2 = callPackage ../applications/gis/saga/lts.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  scid = callPackage ../games/scid {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  scid-vs-pc = callPackage ../games/scid-vs-pc {
    tcl = tcl-8_6;
    tk = tk-8_6;
  };

  scummvm = callPackage ../games/scummvm { };

  inherit (callPackage ../games/scummvm/games.nix { })
    beneath-a-steel-sky
    drascula-the-vampire-strikes-back
    flight-of-the-amazon-queen
    lure-of-the-temptress;

  sgtpuzzles = callPackage (callPackage ../games/sgt-puzzles) { };

  sienna = callPackage ../games/sienna { love = love_0_10; };

  sil = callPackage ../games/sil { };

  simutrans = callPackage ../games/simutrans { };
  # get binaries without data built by Hydra
  simutrans_binaries = lowPrio simutrans.binaries;

  soi = callPackage ../games/soi {
    lua = lua5_1;
  };

  solarus = libsForQt5.callPackage ../games/solarus { };

  solarus-quest-editor = libsForQt5.callPackage ../development/tools/solarus-quest-editor { };

  # You still can override by passing more arguments.
  spring = callPackage ../games/spring {
    boost = boost155;
    cmake = cmake_2_8;
  };

  springLobby = callPackage ../games/spring/springlobby.nix { };

  steamPackages = callPackage ../games/steam { };

  steam = steamPackages.steam-chrootenv.override {
    # DEPRECATED
    withJava = config.steam.java or false;
    withPrimus = config.steam.primus or false;
  };

  steam-run = steam.run;
  steam-run-native = (steam.override {
    nativeOnly = true;
  }).run;

  steamcmd = steamPackages.steamcmd;

  linux-steam-integration = callPackage ../games/linux-steam-integration {
    gtk = pkgs.gtk3;
  };

  stepmania = callPackage ../games/stepmania {
    ffmpeg = ffmpeg_2;
  };

  stuntrally = callPackage ../games/stuntrally {
    ogre = ogre1_9;
    mygui = mygui.override {
      withOgre = true;
    };
  };

  superTux = callPackage ../games/supertux { };

  superTuxKart = callPackage ../games/super-tux-kart { };

  the-powder-toy = callPackage ../games/the-powder-toy {
    lua = lua5_1;
  };

  tbe = callPackage ../games/the-butterfly-effect { };

  tengine = callPackage ../servers/http/tengine {
    modules = with nginxModules; [ rtmp dav moreheaders modsecurity-nginx ];
  };

  tibia = pkgsi686Linux.callPackage ../games/tibia { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    libpng = libpng12;
    openscenegraph = openscenegraph_3_4;
  };

  trigger = callPackage ../games/trigger { };

  ultrastar-creator = libsForQt5.callPackage ../tools/misc/ultrastar-creator { };

  ultrastar-manager = libsForQt5.callPackage ../tools/misc/ultrastar-manager { };

  ultrastardx = callPackage ../games/ultrastardx {
    ffmpeg = ffmpeg_2;
  };

  uqm = callPackage ../games/uqm { };

  ue4 = callPackage ../games/ue4 { };

  ue4demos = recurseIntoAttrs (callPackage ../games/ue4demos { });

  ut2004Packages = callPackage ../games/ut2004 { };

  ut2004demo = self.ut2004Packages.ut2004 [ self.ut2004Packages.ut2004-demo ];

  vapor = callPackage ../games/vapor { love = love_0_8; };

  vapoursynth = callPackage ../development/libraries/vapoursynth {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  vdrift = callPackage ../games/vdrift { };

  # To ensure vdrift's code is built on hydra
  vdrift-bin = vdrift.bin;

  vessel = pkgsi686Linux.callPackage ../games/vessel { };

  voxelands = callPackage ../games/voxelands {
    libpng = libpng12;
  };

  warsow-engine = callPackage ../games/warsow/engine.nix { };

  warsow = callPackage ../games/warsow { };

  warzone2100 = libsForQt5.callPackage ../games/warzone2100 { };

  wesnoth = callPackage ../games/wesnoth {
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
  };

  wesnoth-dev = wesnoth;

  widelands = callPackage ../games/widelands {
    lua = lua5_2;
  };

  worldofgoo_demo = worldofgoo.override {
    demo = true;
  };

  worldofgoo = callPackage ../games/worldofgoo { };

  xboard =  callPackage ../games/xboard { };

  xconq = callPackage ../games/xconq {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  # TODO: the corresponding nix file is missing
  # xracer = callPackage ../games/xracer { };

  xpilot-ng = callPackage ../games/xpilot { };
  bloodspilot-server = callPackage ../games/xpilot/bloodspilot-server.nix {};
  bloodspilot-client = callPackage ../games/xpilot/bloodspilot-client.nix {};

  xsok = callPackage ../games/xsok { };

  inherit (callPackage ../games/quake2/yquake2 { })
    yquake2
    yquake2-ctf
    yquake2-ground-zero
    yquake2-the-reckoning
    yquake2-all-games;

  zandronum = callPackage ../games/zandronum { };

  zandronum-server = zandronum.override {
    serverOnly = true;
  };

  zdbsp = callPackage ../games/zdoom/zdbsp.nix { };

  zdoom = callPackage ../games/zdoom { };

  zoom = callPackage ../games/zoom { };

  zeroadPackages = callPackage ../games/0ad {
    wxGTK = wxGTK30;
  };

  zeroad = zeroadPackages.zeroad;

  ### DESKTOP ENVIRONMENTS

  deepin = recurseIntoAttrs (import ../desktops/deepin {
    inherit pkgs libsForQt5;
    inherit (lib) makeScope;
  });

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment {
    callPackage = newScope pkgs.enlightenment;
  });

  gnome2 = recurseIntoAttrs (callPackage ../desktops/gnome-2 {
    callPackage = pkgs.newScope pkgs.gnome2;
    self = pkgs.gnome2;
  } // {
    inherit (pkgs)
      # GTK Libs
      glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtkmm2 libcanberra-gtk2

      # Included for backwards compatibility
      libsoup libwnck gtk-doc gnome-doc-utils;

    gtk = self.gtk2;
    gtkmm = self.gtkmm2;
  });

  gnome3 = recurseIntoAttrs (callPackage ../desktops/gnome-3 { });

  gnomeExtensions = recurseIntoAttrs {
    appindicator = callPackage ../desktops/gnome-3/extensions/appindicator { };
    battery-status = callPackage ../desktops/gnome-3/extensions/battery-status { };
    caffeine = callPackage ../desktops/gnome-3/extensions/caffeine { };
    clipboard-indicator = callPackage ../desktops/gnome-3/extensions/clipboard-indicator { };
    dash-to-dock = callPackage ../desktops/gnome-3/extensions/dash-to-dock { };
    dash-to-panel = callPackage ../desktops/gnome-3/extensions/dash-to-panel { };
    icon-hider = callPackage ../desktops/gnome-3/extensions/icon-hider { };
    impatience = callPackage ../desktops/gnome-3/extensions/impatience.nix { };
    mediaplayer = callPackage ../desktops/gnome-3/extensions/mediaplayer { };
    nohotcorner = callPackage ../desktops/gnome-3/extensions/nohotcorner { };
    no-title-bar = callPackage ../desktops/gnome-3/extensions/no-title-bar { };
    remove-dropdown-arrows = callPackage ../desktops/gnome-3/extensions/remove-dropdown-arrows { };
    system-monitor = callPackage ../desktops/gnome-3/extensions/system-monitor { };
    taskwhisperer = callPackage ../desktops/gnome-3/extensions/taskwhisperer { };
    timepp = callPackage ../desktops/gnome-3/extensions/timepp { };
    topicons-plus = callPackage ../desktops/gnome-3/extensions/topicons-plus { };
  };

  kakasi = callPackage ../tools/text/kakasi { };

  lumina = libsForQt5.callPackage ../desktops/lumina { };

  lxqt = recurseIntoAttrs (import ../desktops/lxqt {
    inherit pkgs libsForQt5;
    inherit (lib) makeScope;
  });

  mate = recurseIntoAttrs (callPackage ../desktops/mate { });

  pantheon = recurseIntoAttrs rec {
    callPackage = newScope pkgs.pantheon;
    pantheon-terminal = callPackage ../desktops/pantheon/apps/pantheon-terminal { };
  };

  plasma-applet-volumewin7mixer = libsForQt5.callPackage ../applications/misc/plasma-applet-volumewin7mixer { };

  redshift = callPackage ../applications/misc/redshift {
    inherit (python3Packages) python pygobject3 pyxdg wrapPython;
    inherit (darwin.apple_sdk.frameworks) CoreLocation ApplicationServices Foundation Cocoa;
    geoclue = geoclue2;
  };

  redshift-plasma-applet = libsForQt5.callPackage ../applications/misc/redshift-plasma-applet { };

  latte-dock = libsForQt5.callPackage ../applications/misc/latte-dock { };

  adwaita-qt = libsForQt5.callPackage ../misc/themes/adwaita-qt { };

  orion = callPackage ../misc/themes/orion {};

  elementary-gtk-theme = callPackage ../misc/themes/elementary { };

  gtk_engines = callPackage ../misc/themes/gtk2/gtk-engines { };

  gnome-themes-extra = gnome3.gnome-themes-extra;

  numix-gtk-theme = callPackage ../misc/themes/numix { };

  numix-solarized-gtk-theme = callPackage ../misc/themes/numix-solarized { };

  numix-sx-gtk-theme = callPackage ../misc/themes/numix-sx { };

  theme-jade1 = callPackage ../misc/themes/jade1 { };

  theme-obsidian2 = callPackage ../misc/themes/obsidian2 { };

  theme-vertex = callPackage ../misc/themes/vertex { };

  rox-filer = callPackage ../desktops/rox/rox-filer {
    gtk = gtk2;
  };

  xfce = xfce4-12;
  xfceUnstable = xfce4-13;

  xfce4-12 = recurseIntoAttrs (callPackage ../desktops/xfce { });
  xfce4-13 = recurseIntoAttrs (callPackage ../desktops/xfce4-13 { });

  ### DESKTOP ENVIRONMENTS / PLASMA 5

  plasma5 =
    let
      mkPlasma5 = import ../desktops/plasma-5;
      attrs = {
        inherit libsForQt5 lib fetchurl;
        inherit (gnome3) gsettings-desktop-schemas;
        gconf = gnome2.GConf;
      };
    in
      recurseIntoAttrs (makeOverridable mkPlasma5 attrs);

  inherit (kdeFrameworks) kded kinit frameworkintegration;

  inherit (plasma5)
    bluedevil breeze-gtk breeze-qt5 breeze-grub breeze-plymouth
    kactivitymanagerd kde-cli-tools kde-gtk-config kdeplasma-addons kgamma5
    kinfocenter kmenuedit kscreen kscreenlocker ksshaskpass ksysguard
    kwallet-pam kwayland-integration kwin kwrited milou oxygen plasma-browser-integration
    plasma-desktop plasma-integration plasma-nm plasma-pa plasma-vault plasma-workspace
    plasma-workspace-wallpapers polkit-kde-agent powerdevil sddm-kcm
    systemsettings user-manager xdg-desktop-portal-kde;

  ### SCIENCE

  ### SCIENCE/CHEMISTY

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

  octopus = callPackage ../applications/science/chemistry/octopus { openblas=openblasCompat; };

  quantum-espresso = callPackage ../applications/science/chemistry/quantum-espresso { };

  quantum-espresso-mpi = callPackage ../applications/science/chemistry/quantum-espresso {
     mpi = openmpi;
  };

  siesta = callPackage ../applications/science/chemistry/siesta { };

  siesta-mpi = callPackage ../applications/science/chemistry/siesta {
     mpi = openmpi;
  };

  ### SCIENCE/GEOMETRY

  drgeo = callPackage ../applications/science/geometry/drgeo {
    inherit (gnome2) libglade;
    guile = guile_1_8;
  };

  tetgen = callPackage ../applications/science/geometry/tetgen { }; # AGPL3+
  tetgen_1_4 = callPackage ../applications/science/geometry/tetgen/1.4.nix { }; # MIT

  ### SCIENCE/BENCHMARK

  papi = callPackage ../development/libraries/science/benchmark/papi { };

  ### SCIENCE/BIOLOGY

  ants = callPackage ../applications/science/biology/ants { };

  archimedes = callPackage ../applications/science/electronics/archimedes {
    stdenv = overrideCC stdenv gcc49;
  };

  conglomerate = callPackage ../applications/science/biology/conglomerate {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  diamond = callPackage ../applications/science/biology/diamond { };

  ezminc = callPackage ../applications/science/biology/EZminc { };

  inormalize = callPackage ../applications/science/biology/inormalize {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  iv = callPackage ../applications/science/biology/iv {
    neuron-version = neuron.version;
  };

  n3 = callPackage ../applications/science/biology/N3 {
    inherit (perlPackages) perl GetoptTabular MNI-Perllib;
  };

  neuron = callPackage ../applications/science/biology/neuron {
    python = null;
  };

  neuron-mpi = appendToName "mpi" (neuron.override {
    mpi = pkgs.openmpi;
  });

  neuron-full = neuron-mpi.override { inherit python; };

  minc_tools = callPackage ../applications/science/biology/minc-tools {
    inherit (perlPackages) TextFormat;
  };

  minc_widgets = callPackage ../applications/science/biology/minc-widgets {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  mni_autoreg = callPackage ../applications/science/biology/mni_autoreg {
    inherit (perlPackages) GetoptTabular MNI-Perllib;
  };

  ncbi_tools = callPackage ../applications/science/biology/ncbi-tools { };

  plink = callPackage ../applications/science/biology/plink { };

  raxml = callPackage ../applications/science/biology/raxml { };

  raxml-mpi = appendToName "mpi" (raxml.override {
    mpi = true;
  });

  samtools = callPackage ../applications/science/biology/samtools { };
  samtools_0_1_19 = callPackage ../applications/science/biology/samtools/samtools_0_1_19.nix {
    stdenv = gccStdenv;
  };

  star = callPackage ../applications/science/biology/star { };

  bwa = callPackage ../applications/science/biology/bwa { };

  ### SCIENCE/MACHINE LEARNING

  sc2-headless = callPackage ../applications/science/machine-learning/sc2-headless {
    licenseAccepted = (config.sc2-headless.accept_license or false);
  };

  ### SCIENCE/MATH

  blas = callPackage ../development/libraries/science/math/blas { };

  clblas = callPackage ../development/libraries/science/math/clblas {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo OpenCL;
  };

  m4ri = callPackage ../development/libraries/science/math/m4ri { };

  openblas = callPackage ../development/libraries/science/math/openblas { };

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  scalapack = callPackage ../development/libraries/science/math/scalapack {
    mpi = openmpi;
  };

  fenics = callPackage ../development/libraries/science/math/fenics {
    inherit (python3Packages) numpy ply pytest python six sympy;
    pythonPackages = python3Packages;
    pythonBindings = true;
    docs = true;
  };

  lie = callPackage ../applications/science/math/LiE { };

  mathematica = callPackage ../applications/science/math/mathematica { };
  mathematica9 = callPackage ../applications/science/math/mathematica/9.nix { };
  mathematica10 = callPackage ../applications/science/math/mathematica/10.nix { };

  metis = callPackage ../development/libraries/science/math/metis {};

  parmetis = callPackage ../development/libraries/science/math/parmetis {
    mpi = openmpi;
  };

  scs = callPackage ../development/libraries/science/math/scs { };

  sage = callPackage ../applications/science/math/sage {
    nixpkgs = pkgs;
  };
  sageWithDoc = sage.override { withDoc = true; };

  suitesparse_4_2 = callPackage ../development/libraries/science/math/suitesparse/4.2.nix { };
  suitesparse_4_4 = callPackage ../development/libraries/science/math/suitesparse/4.4.nix {};
  suitesparse_5_3 = callPackage ../development/libraries/science/math/suitesparse {};
  suitesparse = suitesparse_5_3;

  ipopt = callPackage ../development/libraries/science/math/ipopt { openblas = openblasCompat; };

  ### SCIENCE/MOLECULAR-DYNAMICS

  dl-poly-classic-mpi = callPackage ../applications/science/molecular-dynamics/dl-poly-classic {
    mpi = openmpi;
  };

  lammps = callPackage ../applications/science/molecular-dynamics/lammps {
    fftw = fftw;
  };

  lammps-mpi = lowPrio (lammps.override {
    mpi = openmpi;
  });

  gromacs = callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    mpiEnabled = false;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  };

  gromacsMpi = lowPrio (gromacs.override {
    singlePrec = true;
    mpiEnabled = true;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  });

  gromacsDouble = lowPrio (gromacs.override {
    singlePrec = false;
    mpiEnabled = false;
    fftw = fftw;
    cmake = cmakeCurses;
  });

  gromacsDoubleMpi = lowPrio (gromacs.override {
    singlePrec = false;
    mpiEnabled = true;
    fftw = fftw;
    cmake = cmakeCurses;
  });

  ### SCIENCE/MEDICINE

  aliza = callPackage ../applications/science/medicine/aliza { };

  ### PHYSICS

  ### SCIENCE/PROGRAMMING

  dafny = dotnetPackages.Dafny;

  ### SCIENCE/LOGIC

  abc-verifier = callPackage ../applications/science/logic/abc {};

  boogie = dotnetPackages.Boogie;

  inherit (callPackage ./coq-packages.nix {
    inherit (ocaml-ng) ocamlPackages_4_05;
  }) mkCoqPackages
    coqPackages_8_5  coq_8_5
    coqPackages_8_6  coq_8_6
    coqPackages_8_7  coq_8_7
    coqPackages_8_8  coq_8_8
    coqPackages_8_9  coq_8_9
    coqPackages      coq
  ;

  cubicle = callPackage ../applications/science/logic/cubicle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (a: { dontDisableStatic = true; });
  };
  ekrhyper = callPackage ../applications/science/logic/ekrhyper {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
  };

  giac = callPackage ../applications/science/math/giac { };
  giac-with-xcas = giac.override { enableGUI = true; };

  glucose = callPackage ../applications/science/logic/glucose { };
  glucose-syrup = callPackage ../applications/science/logic/glucose/syrup.nix { };

  hol = callPackage ../applications/science/logic/hol { };

  inherit (ocamlPackages) hol_light;

  isabelle = callPackage ../applications/science/logic/isabelle {
    polyml = polyml56;
    java = if stdenv.isLinux then jre else jdk;
  };

  iprover = callPackage ../applications/science/logic/iprover {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
  };

  jonprl = callPackage ../applications/science/logic/jonprl {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  lean = callPackage ../applications/science/logic/lean {};
  lean3 = lean;
  elan = callPackage ../applications/science/logic/elan {};

  leo2 = callPackage ../applications/science/logic/leo2 {
     ocaml = ocaml-ng.ocamlPackages_4_01_0.ocaml;};

  minisat = callPackage ../applications/science/logic/minisat {};
  minisatUnstable = callPackage ../applications/science/logic/minisat/unstable.nix {};

  opensmt = callPackage ../applications/science/logic/opensmt { };

  ott = callPackage ../applications/science/logic/ott { };

  otter = callPackage ../applications/science/logic/otter {};

  libpoly = callPackage ../applications/science/logic/poly {};

  prooftree = callPackage  ../applications/science/logic/prooftree {};

  sapic = callPackage ../applications/science/logic/sapic {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  satallax = callPackage ../applications/science/logic/satallax {
    ocaml = ocaml-ng.ocamlPackages_4_01_0.ocaml;
  };

  spass = callPackage ../applications/science/logic/spass {
    stdenv = gccStdenv;
  };

  statverif = callPackage ../applications/science/logic/statverif {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  celf = callPackage ../applications/science/logic/celf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  twelf = callPackage ../applications/science/logic/twelf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  veriT = callPackage ../applications/science/logic/verit {};

  yices = callPackage ../applications/science/logic/yices {
    gmp-static = gmp.override { withStatic = true; };
  };

  z3 = callPackage ../applications/science/logic/z3 { python = python2; };

  tlaplus = callPackage ../applications/science/logic/tlaplus {};
  tlaps = callPackage ../applications/science/logic/tlaplus/tlaps.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };
  tlaplusToolbox = callPackage ../applications/science/logic/tlaplus/toolbox.nix {gtk = gtk2;};

  ### SCIENCE / ELECTRONICS

  # Since version 8 Eagle requires an Autodesk account and a subscription
  # in contrast to single payment for the charged editions.
  # This is the last version with the old model.
  eagle7 = callPackage ../applications/science/electronics/eagle/eagle7.nix { };

  eagle = libsForQt5.callPackage ../applications/science/electronics/eagle/eagle.nix { };

  caneda = libsForQt5.callPackage ../applications/science/electronics/caneda { };

  geda = callPackage ../applications/science/electronics/geda {
    guile = guile_2_0;
  };

  kicad = callPackage ../applications/science/electronics/kicad {
    wxGTK = wxGTK30;
    boost = boost160;
  };

  kicad-unstable = python.pkgs.callPackage ../applications/science/electronics/kicad/unstable.nix {
    wxGTK = wxGTK30;
    boost = boost160;
  };

  librepcb = libsForQt5.callPackage ../applications/science/electronics/librepcb { };

  ngspice = callPackage ../applications/science/electronics/ngspice { };

  pcb = callPackage ../applications/science/electronics/pcb { };

  ### SCIENCE / MATH

  caffe = callPackage ../applications/science/math/caffe rec {
    cudaSupport = config.caffe.cudaSupport or config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    # Used only for image loading.
    opencv3 = opencv3WithoutCuda;
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  caffe2 = callPackage ../development/libraries/science/math/caffe2 (rec {
    eigen = eigen3_3;
    inherit (python3Packages) python future six numpy pydot;
    protobuf = protobuf3_1;
    python-protobuf = python3Packages.protobuf.override { inherit protobuf; };
    # Used only for image loading.
    opencv3 = opencv3WithoutCuda;
  });

  cntk = callPackage ../applications/science/math/cntk rec {
    cudaSupport = pkgs.config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    inherit (linuxPackages) nvidia_x11;
    # Used only for image loading.
    opencv3 = opencv3WithoutCuda;
  };

  ecm = callPackage ../applications/science/math/ecm { };

  eukleides = callPackage ../applications/science/math/eukleides {
    texLive = texlive.combine { inherit (texlive) scheme-small; };
    texinfo = texinfo4;
  };

  form = callPackage ../applications/science/math/form { };

  gap = callPackage ../applications/science/math/gap { };

  gap-minimal = lowPrio (gap.override { keepAllPackages = false; });

  maxima = callPackage ../applications/science/math/maxima {
    ecl = null;
  };
  maxima-ecl = maxima.override {
    ecl = ecl_16_1_2;
    ecl-fasl = true;
    sbcl = null;
  };

  mxnet = callPackage ../applications/science/math/mxnet rec {
    cudaSupport = config.cudaSupport or false;
    cudnnSupport = cudaSupport;
    inherit (linuxPackages) nvidia_x11;
  };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { wxGTK = wxGTK30; };

  pari = callPackage ../applications/science/math/pari { tex = texlive.combined.scheme-basic; };
  gp2c = callPackage ../applications/science/math/pari/gp2c.nix { };

  calc = callPackage ../applications/science/math/calc { };

  pcalc = callPackage ../applications/science/math/pcalc { };

  bcal = callPackage ../applications/science/math/bcal { };

  pspp = callPackage ../applications/science/math/pspp {
    inherit (gnome3) gtksourceview;
  };

  singular = callPackage ../applications/science/math/singular { };

  scilab = callPackage ../applications/science/math/scilab {
    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  yad = callPackage ../tools/misc/yad { };

  speedcrunch = libsForQt5.callPackage ../applications/science/math/speedcrunch { };

  ### SCIENCE / MISC

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (pkgs.gnome2) gtkglext;
  };

  gplates = callPackage ../applications/science/misc/gplates {
    boost = boost160;
    cgal = cgal.override { boost = boost160; };
  };

  golly = callPackage ../applications/science/misc/golly { wxGTK = wxGTK30; };
  golly-beta = callPackage ../applications/science/misc/golly/beta.nix { wxGTK = wxGTK30; };

  ns-3 = callPackage ../development/libraries/science/networking/ns3 { };

  root = callPackage ../applications/science/misc/root {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  root5 = lowPrio (callPackage ../applications/science/misc/root/5.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  });

  stellarium = libsForQt5.callPackage ../applications/science/astronomy/stellarium { };

  tulip = callPackage ../applications/science/misc/tulip {
    cmake = cmake_2_8;
  };

  vite = callPackage ../applications/science/misc/vite { };

  ### SCIENCE / PHYSICS

  apfel = callPackage ../development/libraries/physics/apfel { };

  geant4 = libsForQt5.callPackage ../development/libraries/physics/geant4 { };

  mela = callPackage ../development/libraries/physics/mela { };

  rivet = callPackage ../development/libraries/physics/rivet {
    imagemagick = graphicsmagick-imagemagick-compat;
  };

  yoda = callPackage ../development/libraries/physics/yoda { };
  yoda-with-root = lowPrio (yoda.override {
    withRootSupport = true;
  });

  ### SCIENCE/ROBOTICS

  apmplanner2 = libsForQt5.callPackage ../applications/science/robotics/apmplanner2 { };

  ### MISC

  android-file-transfer = libsForQt5.callPackage ../tools/filesystems/android-file-transfer { };

  antimicro = libsForQt5.callPackage ../tools/misc/antimicro { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  brgenml1lpr = pkgsi686Linux.callPackage ../misc/cups/drivers/brgenml1lpr {};

  calaos_installer = libsForQt5.callPackage ../misc/calaos/installer {};

  click = callPackage ../applications/networking/cluster/click { };

  cups = callPackage ../misc/cups {
    libusb = libusb1;
  };

  cups-filters = callPackage ../misc/cups/filters.nix { };

  cups-pk-helper = callPackage ../misc/cups/cups-pk-helper.nix { };

  cups-kyocera = callPackage ../misc/cups/drivers/kyocera {};

  cups-kyodialog3 = callPackage ../misc/cups/drivers/kyodialog3 {};

  cups-dymo = callPackage ../misc/cups/drivers/dymo {};

  cups-toshiba-estudio = callPackage ../misc/cups/drivers/estudio {};

  cups-zj-58 =  callPackage ../misc/cups/drivers/zj-58 { };

  crashplan = callPackage ../applications/backup/crashplan { };
  crashplansb = callPackage ../applications/backup/crashplan/crashplan-small-business.nix { gconf = gnome2.GConf; };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cups-brother-hl1110 = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1110 { };

  cups-googlecloudprint = callPackage ../misc/cups/drivers/googlecloudprint { };

  # this driver ships with pre-compiled 32-bit binary libraries
  cnijfilter_2_80 = pkgsi686Linux.callPackage ../misc/cups/drivers/cnijfilter_2_80 { };

  cnijfilter_4_00 = callPackage ../misc/cups/drivers/cnijfilter_4_00 {
    libusb = libusb1;
  };

  cnijfilter2 = callPackage ../misc/cups/drivers/cnijfilter2 {
    libusb = libusb1;
  };

  desmume = callPackage ../misc/emulators/desmume { inherit (pkgs.gnome2) gtkglext libglade; };

  dblatex = callPackage ../tools/typesetting/tex/dblatex {
    enableAllFeatures = false;
  };

  dblatexFull = appendToName "full" (dblatex.override {
    enableAllFeatures = true;
  });

  dosbox = callPackage ../misc/emulators/dosbox { };
  dosbox-unstable = callPackage ../misc/emulators/dosbox/unstable.nix { };

  ekiga = newScope pkgs.gnome2 ../applications/networking/instant-messengers/ekiga { };

  emulationstation = callPackage ../misc/emulators/emulationstation {
    stdenv = overrideCC stdenv gcc5;
  };

  glee = callPackage ../tools/graphics/glee { };

  faust = self.faust2;

  faust1 = callPackage ../applications/audio/faust/faust1.nix { };

  faust2 = callPackage ../applications/audio/faust/faust2.nix {
    llvm = llvm_5;
  };

  faust2alqt = callPackage ../applications/audio/faust/faust2alqt.nix { };

  faust2alsa = callPackage ../applications/audio/faust/faust2alsa.nix { };

  faust2csound = callPackage ../applications/audio/faust/faust2csound.nix { };

  faust2firefox = callPackage ../applications/audio/faust/faust2firefox.nix { };

  faust2jack = callPackage ../applications/audio/faust/faust2jack.nix { };

  faust2jaqt = callPackage ../applications/audio/faust/faust2jaqt.nix { };

  faust2ladspa = callPackage ../applications/audio/faust/faust2ladspa.nix { };

  faust2lv2 = callPackage ../applications/audio/faust/faust2lv2.nix { };

  faustlive = callPackage ../applications/audio/faust/faustlive.nix { };

  gajim = python3.pkgs.callPackage ../applications/networking/instant-messengers/gajim {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-libav gst-plugins-ugly;
    inherit (gnome3) gspell;
  };

  gensgs = pkgsi686Linux.callPackage ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript rec {
    cupsSupport = config.ghostscript.cups or (!stdenv.isDarwin);
    x11Support = cupsSupport; # with CUPS, X11 only adds very little
  };

  ghostscriptX = appendToName "with-X" (ghostscript.override {
    cupsSupport = true;
    x11Support = true;
  });

  gnuk = callPackage ../misc/gnuk {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  helm = callPackage ../applications/audio/helm { };

  hplip = callPackage ../misc/drivers/hplip { };

  hplipWithPlugin = hplip.override { withPlugin = true; };

  hplip_3_16_11 = callPackage ../misc/drivers/hplip/3.16.11.nix { };

  hplipWithPlugin_3_16_11 = hplip_3_16_11.override { withPlugin = true; };

  hyperfine = callPackage ../tools/misc/hyperfine {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  # using the new configuration style proposal which is unstable
  jack1 = callPackage ../misc/jackaudio/jack1.nix { };

  jack2 = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
    inherit (darwin.apple_sdk.frameworks) AudioToolbox CoreAudio CoreFoundation;
  };
  libjack2 = jack2.override { prefix = "lib"; };
  jack2Full = jack2; # TODO: move to aliases.nix

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };
  lilypond-unstable = callPackage ../misc/lilypond/unstable.nix { };
  lilypond-with-fonts = callPackage ../misc/lilypond/with-fonts.nix {
    lilypond = lilypond-unstable;
  };

  openlilylib-fonts = callPackage ../misc/lilypond/fonts.nix { };

  mailcore2 = callPackage ../development/libraries/mailcore2 {
    icu = icu58;
  };

  # previously known as flat-plat
  mess = callPackage ../misc/emulators/mess {
    inherit (pkgs.gnome2) GConf;
  };

  morph = callPackage ../tools/package-management/morph { };

  mupen64plus = callPackage ../misc/emulators/mupen64plus { };

  muse = callPackage ../applications/audio/muse { };

  inherit (callPackages ../tools/package-management/nix {
      storeDir = config.nix.storeDir or "/nix/store";
      stateDir = config.nix.stateDir or "/nix/var";
      curl = curl_7_59;
      boehmgc = boehmgc.override { enableLargeConfig = true; };
      })
    nix
    nix1
    nixStable
    nixUnstable;

  nixops = callPackage ../tools/package-management/nixops { };

  nixopsUnstable = lowPrio (callPackage ../tools/package-management/nixops/unstable.nix { });

  nixops-dns = callPackage ../tools/package-management/nixops/nixops-dns.nix { };

  /* Evaluate a NixOS configuration using this evaluation of Nixpkgs.

     With this function you can write, for example, a package that
     depends on a custom virtual machine image.

     Parameter: A module, path or list of those that represent the
                configuration of the NixOS system to be constructed.

     Result:    An attribute set containing packages produced by this
                evaluation of NixOS, such as toplevel, kernel and
                initialRamdisk.
                The result can be extended in the modules by defining
                extra attributes in system.build.

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
  nixos = configuration:
    (import (self.path + "/nixos/lib/eval-config.nix") {
      inherit (pkgs.stdenv.hostPlatform) system;
      modules = [(
                  { lib, ... }: {
                    config.nixpkgs.pkgs = lib.mkDefault pkgs;
                  }
                )] ++ (
                  if builtins.isList configuration
                  then configuration
                  else [configuration]
                );
    }).config.system.build;


  /*
   * Run a NixOS VM network test using this evaluation of Nixpkgs.
   *
   * It is mostly equivalent to `import ./make-test.nix` from the
   * NixOS manual[1], except that your `pkgs` will be used instead of
   * letting NixOS invoke Nixpkgs again. If a test machine needs to
   * set NixOS options under `nixpkgs`, it must set only the
   * `nixpkgs.pkgs` option. For the details, see the Nixpkgs
   * `pkgs.nixos` documentation.
   *
   * Parameter:
   *   A NixOS VM test network, or path to it. Example:
   *
   *      { lib, ... }:
   *      { name = "my-test";
   *        nodes = {
   *          machine-1 = someNixOSConfiguration;
   *          machine-2 = ...;
   *        }
   *      }
   *
   * Result:
   *   A derivation that runs the VM test.
   *
   * [1]: For writing NixOS tests, see
   *      https://nixos.org/nixos/manual/index.html#sec-nixos-tests
   */
  nixosTest =
    let
      /* The nixos/lib/testing.nix module, preapplied with arguments that
       * make sense for this evaluation of Nixpkgs.
       */
      nixosTesting =
        (import ../../nixos/lib/testing.nix {
          inherit (pkgs.stdenv.hostPlatform) system;
          inherit pkgs;
          extraConfigurations = [(
            { lib, ... }: {
              config.nixpkgs.pkgs = lib.mkDefault pkgs;
            }
          )];
        });
    in
      test:
        let
          loadedTest = if builtins.typeOf test == "path"
                       then import test
                       else test;
          calledTest = if pkgs.lib.isFunction loadedTest
                       then callPackage loadedTest {}
                       else loadedTest;
        in
          nixosTesting.makeTest calledTest;

  nixui = callPackage ../tools/package-management/nixui { node_webkit = nwjs_0_12; };

  nix-delegate = haskell.lib.justStaticExecutables haskellPackages.nix-delegate;
  nix-deploy = haskell.lib.justStaticExecutables haskellPackages.nix-deploy;
  nix-diff = haskell.lib.justStaticExecutables haskellPackages.nix-diff;

  nix-info = callPackage ../tools/nix/info { };
  nix-info-tested = nix-info.override { doCheck = true; };

  nix-index = callPackage ../tools/package-management/nix-index {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-scripts;

  nix-template-rpm = callPackage ../build-support/templaterpm { inherit (pythonPackages) python toposort; };

  nix-repl = throw (
    "nix-repl has been removed because it's not maintained anymore, " +
    (lib.optionalString (! lib.versionAtLeast "2" (lib.versions.major builtins.nixVersion))
      "ugrade your Nix installation to a newer version and ") +
    "use `nix repl` instead. " +
    "Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );

  nixos-artwork = callPackage ../data/misc/nixos-artwork { };
  nixos-icons = callPackage ../data/misc/nixos-artwork/icons.nix { };
  nixos-grub2-theme = callPackage ../data/misc/nixos-artwork/grub2-theme.nix { };

  norwester-font = callPackage ../data/fonts/norwester  {};

  nut = callPackage ../applications/misc/nut { };

  disnix = callPackage ../tools/package-management/disnix { };

  dysnomia = callPackage ../tools/package-management/disnix/dysnomia {
    enableApacheWebApplication = config.disnix.enableApacheWebApplication or false;
    enableAxis2WebService = config.disnix.enableAxis2WebService or false;
    enableEjabberdDump = config.disnix.enableEjabberdDump or false;
    enableMySQLDatabase = config.disnix.enableMySQLDatabase or false;
    enablePostgreSQLDatabase = config.disnix.enablePostgreSQLDatabase or false;
    enableSubversionRepository = config.disnix.enableSubversionRepository or false;
    enableTomcatWebApplication = config.disnix.enableTomcatWebApplication or false;
  };

  lice = callPackage ../tools/misc/lice {};

  mysql-workbench = callPackage ../applications/misc/mysql-workbench (let mysql = mysql57; in {
    gdal = gdal.override {mysql = mysql // {lib = {dev = mysql;};};};
    mysql = mysql;
    pcre = pcre-cpp;
  });

  redis-desktop-manager = libsForQt5.callPackage ../applications/misc/redis-desktop-manager { };

  opkg = callPackage ../tools/package-management/opkg { };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = callPackage ../tools/typesetting/tex/pgf/1.x.nix { };

  pgf2 = callPackage ../tools/typesetting/tex/pgf/2.x.nix { };

  pgf3 = callPackage ../tools/typesetting/tex/pgf/3.x.nix { };

  plano-theme = callPackage ../misc/themes/plano { };

  ppsspp = libsForQt5.callPackage ../misc/emulators/ppsspp { };

  pt = callPackage ../applications/misc/pt { };

  protocol = python3Packages.callPackage ../applications/networking/protocol { };

  uae = callPackage ../misc/emulators/uae { };

  fsuae = callPackage ../misc/emulators/fs-uae { };

  retroarchBare = callPackage ../misc/emulators/retroarch {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
  };

  retroarch = wrapRetroArch { retroarch = retroarchBare; };

  libretro = recurseIntoAttrs (callPackage ../misc/emulators/retroarch/cores.nix {
    retroarch = retroarchBare;
  });

  rfc-bibtex = python3Packages.callPackage ../development/python-modules/rfc-bibtex { };

  rpl = callPackage ../tools/text/rpl {
    pythonPackages = python3Packages;
  };

  ricty = callPackage ../data/fonts/ricty { };

  sift = callPackage ../tools/text/sift { };

  shc = callPackage ../tools/security/shc { };

  canon-cups-ufr2 = callPackage ../misc/cups/drivers/canon { };

  mfcj470dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj470dwcupswrapper { };
  mfcj470dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj470dwlpr { };

  mfcj6510dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj6510dwcupswrapper { };
  mfcj6510dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj6510dwlpr { };

  mfcl2700dnlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcl2700dnlpr { };

  samsung-unified-linux-driver_1_00_37 = callPackage ../misc/cups/drivers/samsung/1.00.37.nix { };
  samsung-unified-linux-driver_4_00_39 = callPackage ../misc/cups/drivers/samsung/4.00.39 { };
  samsung-unified-linux-driver_4_01_17 = callPackage ../misc/cups/drivers/samsung/4.01.17.nix { };
  samsung-unified-linux-driver = self.samsung-unified-linux-driver_4_01_17;

  sane-backends = callPackage ../applications/graphics/sane/backends {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
  };

  sane-backends-git = callPackage ../applications/graphics/sane/backends/git.nix {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
  };

  mkSaneConfig = callPackage ../applications/graphics/sane/config.nix { };

  sane-frontends = callPackage ../applications/graphics/sane/frontends.nix { };

  sc-controller = pythonPackages.callPackage ../misc/drivers/sc-controller {
    inherit libusb1; # Shadow python.pkgs.libusb1.
  };

  sct = callPackage ../tools/X11/sct {};

  selinux-python = callPackage ../os-specific/linux/selinux-python {
    # needs python3 bindings
    libselinux = libselinux.override { python = python3; };
    libsemanage = libsemanage.override { python = python3; };
  };

  shades-of-gray-theme = callPackage ../misc/themes/shades-of-gray { };

  sierra-gtk-theme = callPackage ../misc/themes/sierra { };

  slock = callPackage ../misc/screensavers/slock {
    conf = config.slock.conf or null;
  };

  smokeping = callPackage ../tools/networking/smokeping {
    inherit fping rrdtool;
    inherit (perlPackages)
      FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet
      NetOpenSSH NetSNMP LWP IOTty perl NetDNS perlldap;
  };

  soundOfSorting = callPackage ../misc/sound-of-sorting { };

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  inherit (callPackage ../applications/networking/cluster/terraform {})
    terraform_0_8_5
    terraform_0_8
    terraform_0_9
    terraform_0_10
    terraform_0_10-full
    terraform_0_11
    terraform_0_11-full
    terraform_plugins_test
    ;

  terraform = terraform_0_11;
  terraform-full = terraform_0_11-full;

  terraform-providers = recurseIntoAttrs (
    callPackage ../applications/networking/cluster/terraform-providers {}
  );

  terragrunt = callPackage ../applications/networking/cluster/terragrunt {};

  terragrunt_0_11_1 = callPackage ../applications/networking/cluster/terragrunt/0.11.1.nix {
    terraform = terraform_0_8;
  };

  terragrunt_0_9_8 = callPackage ../applications/networking/cluster/terragrunt/0.9.8.nix {
    terraform = terraform_0_8_5;
  };

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  tetra-gtk-theme = callPackage ../misc/themes/tetra { };

  tewi-font = callPackage ../data/fonts/tewi  {};

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # TeX Live; see http://nixos.org/nixpkgs/manual/#sec-language-texlive
  texlive = recurseIntoAttrs
    (callPackage ../tools/typesetting/tex/texlive { });

  ib-tws = callPackage ../applications/office/ib/tws { jdk=oraclejdk8; };

  ib-controller = callPackage ../applications/office/ib/controller { jdk=oraclejdk8; };

  tup = callPackage ../development/tools/build-managers/tup { };

  tvbrowser-bin = callPackage ../applications/misc/tvbrowser/bin.nix { };

  ums = callPackage ../servers/ums { };

  unity3d = callPackage ../development/tools/unity3d {
    stdenv = stdenv_32bit;
    gcc_32bit = pkgsi686Linux.gcc;
    inherit (gnome2) GConf;
  };

  utf8proc = callPackage ../development/libraries/utf8proc { };

  unicode-paracode = callPackage ../tools/misc/unicode { };

  vault = callPackage ../tools/security/vault { };

  vaultenv = haskellPackages.vaultenv;

  vbam = callPackage ../misc/emulators/vbam {
    ffmpeg = ffmpeg_2;
  };

  vice = callPackage ../misc/emulators/vice {
    giflib = giflib_4_1;
  };

  vimUtils = callPackage ../misc/vim-plugins/vim-utils.nix { };

  vimPlugins = recurseIntoAttrs (callPackage ../misc/vim-plugins {
    llvmPackages = llvmPackages_39;
  });

  vimprobable2-unwrapped = callPackage ../applications/networking/browsers/vimprobable2 {
    webkit = webkitgtk24x-gtk2;
  };
  vimprobable2 = wrapFirefox vimprobable2-unwrapped { };

  vimb-unwrapped = callPackage ../applications/networking/browsers/vimb { };
  vimb = wrapFirefox vimb-unwrapped { };

  vips = callPackage ../tools/graphics/vips {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };
  vokoscreen = libsForQt5.callPackage ../applications/video/vokoscreen { };

  wikicurses = callPackage ../applications/misc/wikicurses {
    pythonPackages = python3Packages;
  };

  winePackagesFor = wineBuild: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit wineBuild;

    inherit (callPackage ./wine-packages.nix {})
      minimal base full stable unstable staging;
  });

  winePackages = recurseIntoAttrs (winePackagesFor (config.wine.build or "wine32"));
  wineWowPackages = recurseIntoAttrs (winePackagesFor "wineWow");

  wine = winePackages.full;

  wine-staging = lowPrio (winePackages.full.override {
    wineRelease = "staging";
  });

  winetricks = callPackage ../misc/emulators/wine/winetricks.nix {
    inherit (gnome3) zenity;
  };

  wxsqlite3 = callPackage ../development/libraries/wxsqlite3 {
    wxGTK = wxGTK30;
  };

  wxsqliteplus = callPackage ../development/libraries/wxsqliteplus {
    wxGTK = wxGTK30;
  };

  xhyve = callPackage ../applications/virtualization/xhyve {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin) libobjc;
  };

  xpad = callPackage ../applications/misc/xpad {
    inherit (gnome3) gtksourceview;
  };

  xsane = callPackage ../applications/graphics/sane/xsane.nix {
    libpng = libpng12;
    sane-backends = sane-backends.override { libpng = libpng12; };
  };

  xsw = callPackage ../applications/misc/xsw {
   # Enable the next line to use this in terminal.
   # Note that it requires sixel capable terminals such as mlterm
   # or xterm -ti 340
   SDL = SDL_sixel;
  };

  xwiimote = callPackage ../misc/drivers/xwiimote {
    bluez = pkgs.bluez5.override {
      enableWiimote = true;
    };
  };

  yabause = libsForQt5.callPackage ../misc/emulators/yabause {
    freeglut = null;
    openal = null;
  };

  yacreader = libsForQt5.callPackage ../applications/graphics/yacreader { };

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  zsnes = pkgsi686Linux.callPackage ../misc/emulators/zsnes { };

  openmsx = callPackage ../misc/emulators/openmsx {
    python = python27;
  };

  higan = callPackage ../misc/emulators/higan {
    inherit (gnome2) gtksourceview;
  };

  bullet = callPackage ../development/libraries/bullet {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  inherit (callPackages ../development/libraries/spdlog { })
    spdlog_0 spdlog_1;

  spdlog = spdlog_1;

  dart = callPackage ../development/interpreters/dart { };
  dart_stable = dart.override { version = "2.0.0"; };
  dart_old = dart.override { version = "1.24.3"; };
  dart_dev = dart.override { version = "2.0.0-dev.26.0"; };

  httrack = callPackage ../tools/backup/httrack { };

  httraqt = libsForQt5.callPackage ../tools/backup/httrack/qt.nix { };

  mg = callPackage ../applications/editors/mg { };

  discord = callPackage ../applications/networking/instant-messengers/discord { };

  golden-cheetah = libsForQt56.callPackage ../applications/misc/golden-cheetah {};

  tomb = callPackage ../os-specific/linux/tomb {};

  sequeler = callPackage ../applications/misc/sequeler {
    inherit (gnome3) gtksourceview libgda libgee;
  };

  zuki-themes = callPackage ../misc/themes/zuki { };

  tora = libsForQt5.callPackage ../development/tools/tora {};

  xulrunner = firefox-unwrapped;

  nitrokey-app = libsForQt5.callPackage ../tools/security/nitrokey-app { };
  nitrokey-udev-rules = callPackage ../tools/security/nitrokey-app/udev-rules.nix { };

  hy = callPackage ../development/interpreters/hy {};

  check-uptime = callPackage ../servers/monitoring/plugins/uptime.nix { };

  ghc-standalone-archive = callPackage ../os-specific/darwin/ghc-standalone-archive { inherit (darwin) cctools; };

  chrome-gnome-shell = callPackage  ../desktops/gnome-3/extensions/chrome-gnome-shell {};

  chrome-token-signing = libsForQt5.callPackage ../tools/security/chrome-token-signing {};

  duti = callPackage ../os-specific/darwin/duti {};

  dnstracer = callPackage ../tools/networking/dnstracer {
    inherit (darwin) libresolv;
  };

  ape = callPackage ../applications/misc/ape { };
  attemptoClex = callPackage ../applications/misc/ape/clex.nix { };
  apeClex = callPackage ../applications/misc/ape/apeclex.nix { };

  # Unix tools
  unixtools = recurseIntoAttrs (callPackages ./unix-tools.nix { });
  inherit (unixtools) hexdump ps logger eject umount
                      mount wall hostname more sysctl getconf
                      getent locale killall xxd watch;

  fts = if stdenv.hostPlatform.isMusl then netbsd.fts else null;

  inherit (recurseIntoAttrs (callPackages ../os-specific/bsd { }))
          netbsd;

  yrd = callPackage ../tools/networking/yrd { };

  doing = callPackage ../applications/misc/doing  { };

  alibuild = callPackage ../development/tools/build-managers/alibuild {
    python = python27;
  };

  qmk_firmware = callPackage ../development/misc/qmk_firmware {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrbinutils = pkgsCross.avr.buildPackages.binutils;
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  newlib = callPackage ../development/misc/newlib { };
  newlibCross = callPackage ../development/misc/newlib {
    stdenv = crossLibcStdenv;
  };
}
