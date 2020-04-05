/* The top-level package collection of nixpkgs.
 * It is sorted by categories corresponding to the folder names
 * in the /pkgs folder. Inside the categories packages are roughly
 * sorted by alphabet, but strict sorting has been long lost due
 * to merges. Please use the full-text search of your editor. ;)
 * Hint: ### starts category names.
 */
{ lib, noSysDirs, config, overlays }:
res: pkgs: super:

with pkgs;

let
  self =
    builtins.trace ''
        It seems that you are using a patched Nixpkgs that references the self
        variable in pkgs/top-level/all-packages.nix. This variable was incorrectly
        named, so its usage needs attention. Please use pkgs for packages or super
        for functions.
      ''
      res; # Do *NOT* use res in your fork. It will be removed.

  # TODO: turn self into an error

in
{

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (if stdenv.hostPlatform.is32bit then stdenv else multiStdenv);

  stdenvNoCC = stdenv.override { cc = null; extraAttrs.noCC = true; };

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

  stdenvNoLibs = mkStdenvNoLibs stdenv;

  gccStdenvNoLibs = mkStdenvNoLibs gccStdenv;
  clangStdenvNoLibs = mkStdenvNoLibs clangStdenv;

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Helper functions.
  inherit lib config overlays;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

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

  appimageTools = callPackage ../build-support/appimage { };

  ensureNewerSourcesHook = { year }: makeSetupHook {}
    (writeScript "ensure-newer-sources-hook.sh" ''
      postUnpackHooks+=(_ensureNewerSources)
      _ensureNewerSources() {
        '${findutils}/bin/find' "$sourceRoot" \
          '!' -newermt '${year}-01-01' -exec touch -h -d '${year}-01-02' '{}' '+'
      }
    '');

  addOpenGLRunpath = callPackage ../build-support/add-opengl-runpath { };

  ankisyncd = callPackage ../servers/ankisyncd { };

  avro-tools = callPackage ../development/tools/avro-tools { };

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

  castget = callPackage ../applications/networking/feedreaders/castget { };

  castxml = callPackage ../development/tools/castxml { };

  cereal = callPackage ../development/libraries/cereal { };

  clj-kondo = callPackage ../development/tools/clj-kondo { };

  cmark = callPackage ../development/libraries/cmark { };

  cm256cc = callPackage ../development/libraries/cm256cc {  };

  conftest = callPackage ../development/tools/conftest { };

  corgi = callPackage ../development/tools/corgi { };

  colorz = callPackage ../tools/misc/colorz { };

  dhallToNix = callPackage ../build-support/dhall-to-nix.nix {
    inherit dhall-nix;
  };

  deadcode = callPackage ../development/tools/deadcode { };

  hobbes = callPackage ../development/tools/hobbes { stdenv = gcc6Stdenv; }; # GCC 6 is latest currently supported. See https://git.io/JvK6M.

  proto-contrib = callPackage ../development/tools/proto-contrib {};

  protoc-gen-doc = callPackage ../development/tools/protoc-gen-doc {};

  demoit = callPackage ../servers/demoit { };

  deviceTree = callPackage ../os-specific/linux/device-tree {};

  enum4linux = callPackage ../tools/security/enum4linux {};

  device-tree_rpi = callPackage ../os-specific/linux/device-tree/raspberrypi.nix {};

  diffPlugins = (callPackage ../build-support/plugins.nix {}).diffPlugins;

  dieHook = makeSetupHook {} ../build-support/setup-hooks/die.sh;

  archiver = callPackage ../applications/misc/archiver { };

  digitalbitbox = libsForQt5.callPackage ../applications/misc/digitalbitbox { };

  grsync = callPackage ../applications/misc/grsync { };

  dockerTools = callPackage ../build-support/docker { };

  snapTools = callPackage ../build-support/snap { };

  nix-prefetch-docker = callPackage ../build-support/docker/nix-prefetch-docker.nix { };

  docker-compose = python3Packages.callPackage ../applications/virtualization/docker-compose {};

  docker-ls = callPackage ../tools/misc/docker-ls { };

  docker-slim = callPackage ../applications/virtualization/docker-slim { };

  docker-sync = callPackage ../tools/misc/docker-sync { };

  docui = callPackage ../tools/misc/docui { };

  dotfiles = callPackage ../applications/misc/dotfiles { };

  dotnetenv = callPackage ../build-support/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  dotnetbuildhelpers = callPackage ../build-support/dotnetbuildhelpers { };

  dotnetCorePackages = recurseIntoAttrs (callPackage ../development/compilers/dotnet {});

  dotnet-sdk = dotnetCorePackages.sdk_2_1;

  dotnet-sdk_2 = dotnetCorePackages.sdk_2_1;

  dotnet-sdk_3 = dotnetCorePackages.sdk_3_1;

  dotnet-netcore = dotnetCorePackages.netcore_2_1;

  dotnet-aspnetcore = dotnetCorePackages.aspnetcore_2_1;

  dumb-init = callPackage ../applications/virtualization/dumb-init {};

  umoci = callPackage ../applications/virtualization/umoci {};

  dispad = callPackage ../tools/X11/dispad { };

  dupeguru = callPackage ../applications/misc/dupeguru { };

  dump1090 = callPackage ../applications/radio/dump1090 { };

  ebook2cw = callPackage ../applications/radio/ebook2cw { };

  etBook = callPackage ../data/fonts/et-book { };

  fetchbower = callPackage ../build-support/fetchbower {
    inherit (nodePackages) bower2nix;
  };

  fetchbzr = callPackage ../build-support/fetchbzr { };

  fetchcvs = callPackage ../build-support/fetchcvs { };

  fetchdarcs = callPackage ../build-support/fetchdarcs { };

  fetchdocker = callPackage ../build-support/fetchdocker { };

  fetchDockerConfig = callPackage ../build-support/fetchdocker/fetchDockerConfig.nix { };

  fetchDockerLayer = callPackage ../build-support/fetchdocker/fetchDockerLayer.nix { };

  fetchfossil = callPackage ../build-support/fetchfossil { };

  fetchgit = callPackage ../build-support/fetchgit {
    git = buildPackages.gitMinimal;
    cacert = buildPackages.cacert;
  };

  fetchgitLocal = callPackage ../build-support/fetchgitlocal { };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

  fetchMavenArtifact = callPackage ../build-support/fetchmavenartifact { };

  prefer-remote-fetch = import ../build-support/prefer-remote-fetch;

  global-platform-pro = callPackage ../development/tools/global-platform-pro/default.nix { };

  graph-easy = callPackage ../tools/graphics/graph-easy { };

  packer = callPackage ../development/tools/packer { };

  packr = callPackage ../development/libraries/packr {
    # Version 2.6.0 fails to build with go 1.13 due to nested modules:
    #   go: directory v2/packr2 is outside main module
    buildGoModule = buildGo112Module;
  };

  pet = callPackage ../development/tools/pet { };

  run = callPackage ../development/tools/run { };

  mod = callPackage ../development/tools/mod { };

  broadlink-cli = callPackage ../tools/misc/broadlink-cli {};

  mht2htm = callPackage ../tools/misc/mht2htm { };

  fetchpatch = callPackage ../build-support/fetchpatch { };

  fetchs3 = callPackage ../build-support/fetchs3 { };

  fetchsvn = callPackage ../build-support/fetchsvn { };

  fetchsvnrevision = import ../build-support/fetchsvnrevision runCommand subversion;

  fetchsvnssh = callPackage ../build-support/fetchsvnssh { };

  fetchhg = callPackage ../build-support/fetchhg { };

  # `fetchurl' downloads a file from the network.
  fetchurl = if stdenv.buildPlatform != stdenv.hostPlatform
   then buildPackages.fetchurl # No need to do special overrides twice,
   else makeOverridable (import ../build-support/fetchurl) {
    inherit lib stdenvNoCC buildPackages;
    curl = buildPackages.curl.override (old: rec {
      # break dependency cycles
      fetchurl = stdenv.fetchurlBoot;
      zlib = buildPackages.zlib.override { fetchurl = stdenv.fetchurlBoot; };
      pkgconfig = buildPackages.pkgconfig.override { fetchurl = stdenv.fetchurlBoot; };
      perl = buildPackages.perl.override { fetchurl = stdenv.fetchurlBoot; };
      openssl = buildPackages.openssl.override {
        fetchurl = stdenv.fetchurlBoot;
        coreutils = buildPackages.coreutils.override {
          fetchurl = stdenv.fetchurlBoot;
          inherit perl;
          xz = buildPackages.xz.override { fetchurl = stdenv.fetchurlBoot; };
          gmp = null;
          aclSupport = false;
          attrSupport = false;
        };
        inherit perl;
        buildPackages = { inherit perl; };
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
        inherit pkgconfig perl openssl;
        keyutils = buildPackages.keyutils.override { fetchurl = stdenv.fetchurlBoot; };
      };
      nghttp2 = buildPackages.nghttp2.override {
        fetchurl = stdenv.fetchurlBoot;
        inherit zlib pkgconfig openssl;
        c-ares = buildPackages.c-ares.override { fetchurl = stdenv.fetchurlBoot; };
        libev = buildPackages.libev.override { fetchurl = stdenv.fetchurlBoot; };
      };
    });
  };

  fetchRepoProject = callPackage ../build-support/fetchrepoproject { };

  fetchipfs = import ../build-support/fetchipfs {
    inherit curl stdenv;
  };

  fetchzip = callPackage ../build-support/fetchzip { };

  fetchCrate = callPackage ../build-support/rust/fetchcrate.nix { };

  fetchFromGitHub = callPackage ../build-support/fetchgithub {};

  fetchFromBitbucket = callPackage ../build-support/fetchbitbucket {};

  fetchFromSavannah = callPackage ../build-support/fetchsavannah {};

  fetchFromGitLab = callPackage ../build-support/fetchgitlab {};

  fetchFromGitiles = callPackage ../build-support/fetchgitiles {};

  fetchFromRepoOrCz = callPackage ../build-support/fetchrepoorcz {};

  fetchNuGet = callPackage ../build-support/fetchnuget { };
  buildDotnetPackage = callPackage ../build-support/build-dotnet-package { };

  fetchgx = callPackage ../build-support/fetchgx { };

  resolveMirrorURLs = {url}: fetchurl {
    showURLs = true;
    inherit url;
  };

  installShellFiles = callPackage ../build-support/install-shell-files {};

  lazydocker = callPackage ../tools/misc/lazydocker { };

  ld-is-cc-hook = makeSetupHook { name = "ld-is-cc-hook"; }
    ../build-support/setup-hooks/ld-is-cc-hook.sh;

  libredirect = callPackage ../build-support/libredirect { };

  madonctl = callPackage ../applications/misc/madonctl { };

  makeDesktopItem = callPackage ../build-support/make-desktopitem { };

  makeAutostartItem = callPackage ../build-support/make-startupitem { };

  makeInitrd = callPackage ../build-support/kernel/make-initrd.nix; # Args intentionally left out

  makeWrapper = makeSetupHook { deps = [ dieHook ]; substitutions = { shell = pkgs.runtimeShell; }; }
                              ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = { kernel, firmware, rootModules, allowMissing ? false }:
    callPackage ../build-support/kernel/modules-closure.nix {
      inherit kernel firmware rootModules allowMissing;
    };

  mkShell = callPackage ../build-support/mkshell { };

  nixBufferBuilders = import ../build-support/emacs/buffer.nix { inherit (pkgs) lib writeText; inherit (emacsPackages) inherit-local; };

  nix-gitignore = callPackage ../build-support/nix-gitignore { };

  ociTools = callPackage ../build-support/oci-tools { };

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  pruneLibtoolFiles = makeSetupHook { name = "prune-libtool-files"; }
    ../build-support/setup-hooks/prune-libtool-files.sh;

  closureInfo = callPackage ../build-support/closure-info.nix { };

  setupSystemdUnits = callPackage ../build-support/setup-systemd-units.nix { };

  shortenPerlShebang = makeSetupHook
    { deps = [ dieHook ]; }
    ../build-support/setup-hooks/shorten-perl-shebang.sh;

  singularity-tools = callPackage ../build-support/singularity-tools { };

  srcOnly = args: callPackage ../build-support/src-only args;

  substituteAll = callPackage ../build-support/substitute/substitute-all.nix { };

  substituteAllFiles = callPackage ../build-support/substitute-files/substitute-all-files.nix { };

  replaceDependency = callPackage ../build-support/replace-dependency.nix { };

  nukeReferences = callPackage ../build-support/nuke-references { };

  referencesByPopularity = callPackage ../build-support/references-by-popularity { };

  removeReferencesTo = callPackage ../build-support/remove-references-to { };

  vmTools = callPackage ../build-support/vm { };

  releaseTools = callPackage ../build-support/release { };

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
    deps = lib.optional (!stdenv.isDarwin) dconf.lib ++ [ gtk3 librsvg makeWrapper ];
  } ../build-support/setup-hooks/wrap-gapps-hook.sh;

  separateDebugInfo = makeSetupHook { } ../build-support/setup-hooks/separate-debug-info.sh;

  setupDebugInfoDirs = makeSetupHook { } ../build-support/setup-hooks/setup-debug-info-dirs.sh;

  useOldCXXAbi = makeSetupHook { } ../build-support/setup-hooks/use-old-cxx-abi.sh;

  ical2org = callPackage ../tools/misc/ical2org {};

  iconConvTools = callPackage ../build-support/icon-conv-tools {};

  #package writers
  writers = callPackage ../build-support/writers {};

  ### TOOLS

  _0x0 = callPackage ../tools/misc/0x0 { };

  _3llo = callPackage ../tools/misc/3llo { };

  _1password = callPackage ../applications/misc/1password { };

  _6tunnel = callPackage ../tools/networking/6tunnel { };

  _9pfs = callPackage ../tools/filesystems/9pfs { };

  a2ps = callPackage ../tools/text/a2ps { };

  abcm2ps = callPackage ../tools/audio/abcm2ps { };

  abcmidi = callPackage ../tools/audio/abcmidi { };

  abduco = callPackage ../tools/misc/abduco { };

  acct = callPackage ../tools/system/acct { };

  accuraterip-checksum = callPackage ../tools/audio/accuraterip-checksum { };

  acme-sh = callPackage ../tools/admin/acme.sh { };

  acoustidFingerprinter = callPackage ../tools/audio/acoustid-fingerprinter {
    ffmpeg = ffmpeg_2;
  };

  alsaequal = callPackage ../tools/audio/alsaequal { };

  acpica-tools = callPackage ../tools/system/acpica-tools { };

  act = callPackage ../development/tools/misc/act {};

  actdiag = with python3.pkgs; toPythonApplication actdiag;

  actkbd = callPackage ../tools/system/actkbd { };

  adafruit-ampy = callPackage ../tools/misc/adafruit-ampy { };

  adlplug = callPackage ../applications/audio/adlplug { };

  opnplug = callPackage ../applications/audio/adlplug {
    adlplugChip = "-DADLplug_CHIP=OPN2";
    pname = "OPNplug";
  };

  adminer = callPackage ../servers/adminer { };

  advancecomp = callPackage ../tools/compression/advancecomp {};

  aefs = callPackage ../tools/filesystems/aefs { };

  aegisub = callPackage ../applications/video/aegisub ({
    wxGTK = wxGTK30;
  } // (config.aegisub or {}));

  aerc = callPackage ../applications/networking/mailreaders/aerc { };

  aerospike = callPackage ../servers/nosql/aerospike { };

  aespipe = callPackage ../tools/security/aespipe { };

  aescrypt = callPackage ../tools/misc/aescrypt { };

  acme-client = callPackage ../tools/networking/acme-client { inherit (darwin) apple_sdk; };

  amass = callPackage ../tools/networking/amass {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  afew = callPackage ../applications/networking/mailreaders/afew { };

  afio = callPackage ../tools/archivers/afio { };

  afl = callPackage ../tools/security/afl {
    stdenv = clangStdenv;
  };

  libdislocator = callPackage ../tools/security/afl/libdislocator.nix { };

  afpfs-ng = callPackage ../tools/filesystems/afpfs-ng { };

  agrep = callPackage ../tools/text/agrep { };

  aha = callPackage ../tools/text/aha { };

  ahcpd = callPackage ../tools/networking/ahcpd { };

  aide = callPackage ../tools/security/aide { };

  aircrack-ng = callPackage ../tools/networking/aircrack-ng { };

  airfield = callPackage ../tools/networking/airfield { };

  apache-airflow = with python3.pkgs; toPythonApplication apache-airflow;

  airsonic = callPackage ../servers/misc/airsonic { };

  airspy = callPackage ../applications/radio/airspy { };

  airtame = callPackage ../applications/misc/airtame { };

  aj-snapshot  = callPackage ../applications/audio/aj-snapshot { };

  albert = libsForQt5.callPackage ../applications/misc/albert {};

  alacritty = callPackage ../applications/misc/alacritty {
    inherit (xorg) libXcursor libXxf86vm libXi;
    inherit (darwin.apple_sdk.frameworks) AppKit CoreGraphics CoreServices CoreText Foundation OpenGL;
  };

  aldo = callPackage ../applications/radio/aldo { };

  almanah = callPackage ../applications/misc/almanah { };

  amazon-ecs-cli = callPackage ../tools/virtualization/amazon-ecs-cli { };

  amazon-glacier-cmd-interface = callPackage ../tools/backup/amazon-glacier-cmd-interface { };

  amber = callPackage ../tools/text/amber {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  inherit (callPackages ../development/tools/ammonite {})
    ammonite_2_12
    ammonite_2_13;
  ammonite = if scala == scala_2_12 then ammonite_2_12 else ammonite_2_13;

  amp = callPackage ../applications/editors/amp {};

  ams = callPackage ../applications/audio/ams {};

  amtterm = callPackage ../tools/system/amtterm {};

  analog = callPackage ../tools/admin/analog {};

  ansifilter = callPackage ../tools/text/ansifilter {};

  antora = callPackage ../development/tools/documentation/antora {};

  apfs-fuse = callPackage ../tools/filesystems/apfs-fuse { };

  apktool = callPackage ../development/tools/apktool {
    inherit (androidenv.androidPkgs_9_0) build-tools;
  };

  appimage-run = callPackage ../tools/package-management/appimage-run {};

  appimagekit = callPackage ../tools/package-management/appimagekit {};

  apt-cacher-ng = callPackage ../servers/http/apt-cacher-ng { };

  apt-offline = callPackage ../tools/misc/apt-offline { };

  aptly = callPackage ../tools/misc/aptly { };

  archivemount = callPackage ../tools/filesystems/archivemount { };

  arandr = callPackage ../tools/X11/arandr { };

  inherit (callPackages ../servers/nosql/arangodb {
    stdenv = gcc8Stdenv;
  }) arangodb_3_3 arangodb_3_4 arangodb_3_5;
  arangodb = arangodb_3_4;

  arcanist = callPackage ../development/tools/misc/arcanist {};

  arduino = arduino-core.override { withGui = true; };

  arduino-core = callPackage ../development/arduino/arduino-core { };

  arduino-mk = callPackage ../development/arduino/arduino-mk {};

  apitrace = libsForQt5.callPackage ../applications/graphics/apitrace {};

  arguments = callPackage ../development/libraries/arguments { };

  argus = callPackage ../tools/networking/argus {};

  argus-clients = callPackage ../tools/networking/argus-clients {};

  argtable = callPackage ../tools/misc/argtable {};

  argyllcms = callPackage ../tools/graphics/argyllcms {};

  arp-scan = callPackage ../tools/misc/arp-scan { };

  inherit (callPackages ../data/fonts/arphic {})
    arphic-ukai arphic-uming;

  artyFX = callPackage ../applications/audio/artyFX {};

  owl-lisp = callPackage ../development/compilers/owl-lisp {};

  ascii = callPackage ../tools/text/ascii { };

  asciinema = callPackage ../tools/misc/asciinema {};

  asciiquarium = callPackage ../applications/misc/asciiquarium {};

  asymptote = callPackage ../tools/graphics/asymptote {
    texLive = texlive.combine { inherit (texlive) scheme-small epsf cm-super texinfo; };
    gsl = gsl_1;
  };

  async = callPackage ../development/tools/async {};

  atheme = callPackage ../servers/irc/atheme { };

  atinout = callPackage ../tools/networking/atinout { };

  atomicparsley = callPackage ../tools/video/atomicparsley {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  autoflake = callPackage ../development/tools/analysis/autoflake { };

  autospotting = callPackage ../applications/misc/autospotting { };

  avfs = callPackage ../tools/filesystems/avfs { };

  aws-iam-authenticator = callPackage ../tools/security/aws-iam-authenticator {};

  awscli = callPackage ../tools/admin/awscli { };

  awsebcli = callPackage ../tools/virtualization/awsebcli {};

  awslogs = callPackage ../tools/admin/awslogs { };

  aws-env = callPackage ../tools/admin/aws-env { };

  aws-google-auth = python3Packages.callPackage ../tools/admin/aws-google-auth { };

  aws-okta = callPackage ../tools/security/aws-okta { };

  aws-rotate-key = callPackage ../tools/admin/aws-rotate-key { };

  aws_shell = callPackage ../tools/admin/aws_shell { };

  aws-sam-cli = callPackage ../development/tools/aws-sam-cli { python = python3; };

  aws-vault = callPackage ../tools/admin/aws-vault { };

  iamy = callPackage ../tools/admin/iamy { };

  azure-cli = callPackage ../tools/admin/azure-cli { python = python3; };

  azure-storage-azcopy = callPackage ../development/tools/azcopy { };

  azure-vhd-utils  = callPackage ../tools/misc/azure-vhd-utils { };

  awless = callPackage ../tools/virtualization/awless { };

  berglas = callPackage ../tools/admin/berglas/default.nix { };

  brakeman = callPackage ../development/tools/analysis/brakeman { };

  brewtarget = libsForQt5.callPackage ../applications/misc/brewtarget { } ;

  boxes = callPackage ../tools/text/boxes { };

  ec2_api_tools = callPackage ../tools/virtualization/ec2-api-tools { };

  ec2_ami_tools = callPackage ../tools/virtualization/ec2-ami-tools { };

  ec2-utils = callPackage ../tools/virtualization/ec2-utils { };

  altermime = callPackage ../tools/networking/altermime {};

  alttab = callPackage ../tools/X11/alttab { };

  amule = callPackage ../tools/networking/p2p/amule { };

  amuleDaemon = appendToName "daemon" (amule.override {
    monolithic = false;
    enableDaemon = true;
  });

  amuleGui = appendToName "gui" (amule.override {
    monolithic = false;
    client = true;
  });

  apg = callPackage ../tools/security/apg { };

  apt-dater = callPackage ../tools/package-management/apt-dater { };

  autorevision = callPackage ../tools/misc/autorevision { };

  automirror = callPackage ../tools/misc/automirror { };

  babashka = callPackage ../tools/misc/babashka { };

  bash-my-aws = callPackage ../tools/admin/bash-my-aws { };

  bcachefs-tools = callPackage ../tools/filesystems/bcachefs-tools { };

  bitwarden = callPackage ../tools/security/bitwarden { };

  inherit (nodePackages) bitwarden-cli;

  bitwarden_rs = callPackage ../tools/security/bitwarden_rs {
    inherit (darwin.apple_sdk.frameworks) Security CoreServices;
  };
  bitwarden_rs-sqlite = bitwarden_rs;
  bitwarden_rs-mysql = bitwarden_rs.override { dbBackend = "mysql"; };
  bitwarden_rs-postgresql = bitwarden_rs.override { dbBackend = "postgresql"; };

  bitwarden_rs-vault = callPackage ../tools/security/bitwarden_rs/vault.nix { };

  bmap-tools = callPackage ../tools/misc/bmap-tools { };

  bonnie = callPackage ../tools/filesystems/bonnie { };

  bonfire = callPackage ../tools/misc/bonfire { };

  boulder = callPackage ../tools/admin/boulder { };

  buildbot = with python3Packages; toPythonApplication buildbot;
  buildbot-ui = with python3Packages; toPythonApplication buildbot-ui;
  buildbot-full = with python3Packages; toPythonApplication buildbot-full;
  buildbot-worker = with python3Packages; toPythonApplication buildbot-worker;

  bunny = callPackage ../tools/package-management/bunny { };

  calls = callPackage ../applications/networking/calls { };

  certigo = callPackage ../tools/admin/certigo { };

  chezmoi = callPackage ../tools/misc/chezmoi { };

  chipsec = callPackage ../tools/security/chipsec {
    kernel = null;
    withDriver = false;
  };

  clair = callPackage ../tools/admin/clair { };

  cloud-sql-proxy = callPackage ../tools/misc/cloud-sql-proxy { };

  cloudflare-wrangler = callPackage ../development/tools/cloudflare-wrangler { };

  codeql = callPackage ../development/tools/analysis/codeql { };

  container-linux-config-transpiler = callPackage ../development/tools/container-linux-config-transpiler { };

  ccextractor = callPackage ../applications/video/ccextractor { };

  cconv = callPackage ../tools/text/cconv { };

  go-check = callPackage ../development/tools/check { };

  chkcrontab = callPackage ../tools/admin/chkcrontab { };

  claws = callPackage ../tools/misc/claws { };

  cloud-custodian = python3Packages.callPackage ../tools/networking/cloud-custodian  { };

  codespell = with python3Packages; toPythonApplication codespell;

  cozy = callPackage ../applications/audio/cozy-audiobooks { };

  ctrtool = callPackage ../tools/archivers/ctrtool { };

  crumbs = callPackage ../applications/misc/crumbs { };

  crc32c = callPackage ../development/libraries/crc32c { };

  cue = callPackage ../development/tools/cue { };

  deltachat-electron = callPackage
    ../applications/networking/instant-messengers/deltachat-electron { };

  deskew = callPackage ../applications/graphics/deskew { };

  detect-secrets = python3Packages.callPackage ../development/tools/detect-secrets { };

  diskus = callPackage ../tools/misc/diskus {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  djmount = callPackage ../tools/filesystems/djmount { };

  dgsh = callPackage ../shells/dgsh { };

  dkimpy = with python3Packages; toPythonApplication dkimpy;

  dpt-rp1-py = callPackage ../tools/misc/dpt-rp1-py { };

  ecdsautils = callPackage ../tools/security/ecdsautils { };

  sedutil = callPackage ../tools/security/sedutil { };

  elvish = callPackage ../shells/elvish { };

  emplace = callPackage ../tools/package-management/emplace { };

  encryptr = callPackage ../tools/security/encryptr {
    gconf = gnome2.GConf;
  };

  enchive = callPackage ../tools/security/enchive { };

  enpass = callPackage ../tools/security/enpass { };

  essentia-extractor = callPackage ../tools/audio/essentia-extractor { };

  esh = callPackage ../tools/text/esh { };

  ezstream = callPackage ../tools/audio/ezstream { };

  libfx2 = with python3Packages; toPythonApplication fx2;

  fxlinuxprintutil = callPackage ../tools/misc/fxlinuxprintutil { };

  genymotion = callPackage ../development/mobile/genymotion { };

  gaia = callPackage ../development/libraries/gaia { };

  gamecube-tools = callPackage ../development/tools/gamecube-tools { };

  gams = callPackage ../tools/misc/gams (config.gams or {});

  git-fire = callPackage ../tools/misc/git-fire { };

  git-repo-updater = python3Packages.callPackage ../development/tools/git-repo-updater { };

  git-revise = with python3Packages; toPythonApplication git-revise;

  git-town = callPackage ../tools/misc/git-town { };

  github-changelog-generator = callPackage ../development/tools/github-changelog-generator { };

  github-commenter = callPackage ../development/tools/github-commenter { };

  gitless = callPackage ../applications/version-management/gitless { python = python3; };

  gitter = callPackage  ../applications/networking/instant-messengers/gitter { };

  gjs = callPackage ../development/libraries/gjs { };

  glances = python3Packages.callPackage ../applications/system/glances { };

  glasgow = with python3Packages; toPythonApplication glasgow;

  gomatrix = callPackage ../applications/misc/gomatrix { };

  gucci = callPackage ../tools/text/gucci { };

  grc = callPackage ../tools/misc/grc { };

  green-pdfviewer = callPackage ../applications/misc/green-pdfviewer {
   SDL = SDL_sixel;
  };

  gremlin-console = callPackage ../applications/misc/gremlin-console { };

  gcsfuse = callPackage ../tools/filesystems/gcsfuse { };

  glyr = callPackage ../tools/audio/glyr { };

  hpe-ltfs = callPackage ../tools/backup/hpe-ltfs { };

  http2tcp = callPackage ../tools/networking/http2tcp { };

  httperf = callPackage ../tools/networking/httperf { };

  ili2c = callPackage ../tools/misc/ili2c { };

  imageworsener = callPackage ../tools/graphics/imageworsener { };

  imgpatchtools = callPackage ../development/mobile/imgpatchtools { };

  ipgrep = callPackage ../tools/networking/ipgrep { };

  lastpass-cli = callPackage ../tools/security/lastpass-cli { };

  lesspass-cli = callPackage ../tools/security/lesspass-cli { };

  pacparser = callPackage ../tools/networking/pacparser { };

  pass = callPackage ../tools/security/pass { };

  pass-wayland = callPackage ../tools/security/pass {
    waylandSupport = true;
  };

  passExtensions = recurseIntoAttrs pass.extensions;

  asc-key-to-qr-code-gif = callPackage ../tools/security/asc-key-to-qr-code-gif { };

  gopass = callPackage ../tools/security/gopass { };

  browserpass = callPackage ../tools/security/browserpass { };

  passff-host = callPackage ../tools/security/passff-host { };

  oracle-instantclient = callPackage ../development/libraries/oracle-instantclient { };

  goku = callPackage ../os-specific/darwin/goku { };

  kwakd = callPackage ../servers/kwakd { };

  chunkwm = callPackage ../os-specific/darwin/chunkwm {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa ScriptingBridge;
  };

  kwm = callPackage ../os-specific/darwin/kwm { };

  khd = callPackage ../os-specific/darwin/khd {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  kjv = callPackage ../applications/misc/kjv { };

  luigi = callPackage ../applications/networking/cluster/luigi { };

  m-cli = callPackage ../os-specific/darwin/m-cli { };

  pebble = callPackage ../tools/admin/pebble { };

  reattach-to-user-namespace = callPackage ../os-specific/darwin/reattach-to-user-namespace {};

  skhd = callPackage ../os-specific/darwin/skhd {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  qes = callPackage ../os-specific/darwin/qes {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  wiiload = callPackage ../development/tools/wiiload { };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  ssh-agents = callPackage ../tools/networking/ssh-agents { };

  ssh-import-id = python3Packages.callPackage ../tools/admin/ssh-import-id { };

  titaniumenv = callPackage ../development/mobile/titaniumenv { };

  abootimg = callPackage ../development/mobile/abootimg {};

  adbfs-rootless = callPackage ../development/mobile/adbfs-rootless {
    adb = androidenv.androidPkgs_9_0.platform-tools;
  };

  adb-sync = callPackage ../development/mobile/adb-sync {
    inherit (androidenv.androidPkgs_9_0) platform-tools;
  };

  anbox = callPackage ../os-specific/linux/anbox { };

  androidenv = callPackage ../development/mobile/androidenv {
    pkgs_i686 = pkgsi686Linux;
  };

  androidndkPkgs = androidndkPkgs_18b;
  androidndkPkgs_18b = (callPackage ../development/androidndk-pkgs {})."18b";

  androidsdk_9_0 = androidenv.androidPkgs_9_0.androidsdk;

  webos = recurseIntoAttrs {
    cmake-modules = callPackage ../development/mobile/webos/cmake-modules.nix { };

    novacom = callPackage ../development/mobile/webos/novacom.nix { };
    novacomd = callPackage ../development/mobile/webos/novacomd.nix { };
  };

  aria2 = callPackage ../tools/networking/aria2 {
    inherit (darwin.apple_sdk.frameworks) Security;
    inherit (pythonPackages) sphinx;
  };
  aria = aria2;

  asmfmt = callPackage ../development/tools/asmfmt { };

  aspcud = callPackage ../tools/misc/aspcud { };

  at = callPackage ../tools/system/at { };

  atftp = callPackage ../tools/networking/atftp { };

  autogen = callPackage ../development/tools/misc/autogen {
    guile = guile_2_0;
  };

  autojump = callPackage ../tools/misc/autojump { };

  automysqlbackup = callPackage ../tools/backup/automysqlbackup { };

  autorandr = callPackage ../tools/misc/autorandr {};

  avahi = callPackage ../development/libraries/avahi (config.avahi or {});

  avahi-compat = callPackage ../development/libraries/avahi ((config.avahi or {}) // {
    withLibdnssdCompat = true;
  });

  avro-c = callPackage ../development/libraries/avro-c { };

  avro-cpp = callPackage ../development/libraries/avro-c++ { boost = boost160; };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  awstats = callPackage ../tools/system/awstats { };

  awsweeper = callPackage ../tools/admin/awsweeper { };

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

  azureus = callPackage ../tools/networking/p2p/azureus { };

  b3sum = callPackage ../tools/security/b3sum {};

  backblaze-b2 = python.pkgs.callPackage ../development/tools/backblaze-b2 { };

  bandwhich = callPackage ../tools/networking/bandwhich {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bar = callPackage ../tools/system/bar {};

  base16-shell-preview = callPackage ../misc/base16-shell-preview { };

  base16-builder = callPackage ../misc/base16-builder { };

  basex = callPackage ../tools/text/xml/basex { };

  bashplotlib = callPackage ../tools/misc/bashplotlib { };

  babeld = callPackage ../tools/networking/babeld { };

  badvpn = callPackage ../tools/networking/badvpn {};

  barcode = callPackage ../tools/graphics/barcode {};

  bashburn = callPackage ../tools/cd-dvd/bashburn { };

  bashmount = callPackage ../tools/filesystems/bashmount {};

  bat = callPackage ../tools/misc/bat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bc = callPackage ../tools/misc/bc { };

  bdf2psf = callPackage ../tools/misc/bdf2psf { };

  bdf2sfd = callPackage ../tools/misc/bdf2sfd { };

  bcat = callPackage ../tools/text/bcat {};

  bcache-tools = callPackage ../tools/filesystems/bcache-tools { };

  bchunk = callPackage ../tools/cd-dvd/bchunk { };

  inherit (callPackages ../misc/logging/beats/6.x.nix { })
    filebeat6
    heartbeat6
    metricbeat6
    packetbeat6
    journalbeat6;

  inherit (callPackages ../misc/logging/beats/7.x.nix { })
    filebeat7
    heartbeat7
    metricbeat7
    packetbeat7
    journalbeat7;

  filebeat = filebeat6;
  heartbeat = heartbeat6;
  metricbeat = metricbeat6;
  packetbeat = packetbeat6;
  journalbeat = journalbeat6;

  bfr = callPackage ../tools/misc/bfr { };

  bibtool = callPackage ../tools/misc/bibtool { };

  bibutils = callPackage ../tools/misc/bibutils { };

  bibtex2html = callPackage ../tools/misc/bibtex2html { };

  bicon = callPackage ../applications/misc/bicon { };

  bindfs = callPackage ../tools/filesystems/bindfs { };

  birdtray = libsForQt5.callPackage ../applications/misc/birdtray { };

  bitbucket-cli = python2Packages.bitbucket-cli;

  blink = libsForQt5.callPackage ../applications/networking/instant-messengers/blink { };

  blockbook = callPackage ../servers/blockbook { };

  blockhash = callPackage ../tools/graphics/blockhash { };

  bluemix-cli = callPackage ../tools/admin/bluemix-cli { };

  blur-effect = callPackage ../tools/graphics/blur-effect { };

  charles = charles4;
  inherit (callPackage ../applications/networking/charles {})
    charles3
    charles4
  ;

  inherit (libsForQt5.callPackage ../development/libraries/libqmatrixclient { })
    libqmatrixclient_0_4
    libqmatrixclient_0_5
    libqmatrixclient;

  inherit (libsForQt5.callPackage ../applications/networking/instant-messengers/quaternion { })
    quaternion
    quaternion-git;

  tensor = libsForQt5.callPackage ../applications/networking/instant-messengers/tensor { };

  libtensorflow-bin = callPackage ../development/libraries/science/math/tensorflow/bin.nix {
    cudaSupport = pkgs.config.cudaSupport or false;
    inherit (linuxPackages) nvidia_x11;
    cudatoolkit = cudatoolkit_10_0;
    cudnn = cudnn_cudatoolkit_10_0;
  };

  libtensorflow =
    if python.pkgs.tensorflow ? libtensorflow
    then python.pkgs.tensorflow.libtensorflow
    else libtensorflow-bin;

  behdad-fonts = callPackage ../data/fonts/behdad-fonts { };

  bless = callPackage ../applications/editors/bless { };

  blink1-tool = callPackage ../tools/misc/blink1-tool { };

  bliss = callPackage ../applications/science/math/bliss { };

  blobfuse = callPackage ../tools/filesystems/blobfuse { };

  blockdiag = with python3Packages; toPythonApplication blockdiag;

  blsd = callPackage ../tools/misc/blsd { };

  bluez-alsa = callPackage ../tools/bluetooth/bluez-alsa { };

  bluez-tools = callPackage ../tools/bluetooth/bluez-tools { };

  bmon = callPackage ../tools/misc/bmon { };

  bmake = callPackage ../development/tools/build-managers/bmake { };

  bochs = callPackage ../applications/virtualization/bochs { };

  bubblewrap = callPackage ../tools/admin/bubblewrap { };

  borgbackup = callPackage ../tools/backup/borg { };

  boringtun = callPackage ../tools/networking/boringtun { };

  boomerang = libsForQt5.callPackage ../development/tools/boomerang { };

  boost-build = callPackage ../development/tools/boost-build { };

  boot = callPackage ../development/tools/build-managers/boot { };

  bowtie2 = callPackage ../applications/science/biology/bowtie2 { };

  boxfs = callPackage ../tools/filesystems/boxfs { };

  brasero-original = lowPrio (callPackage ../tools/cd-dvd/brasero { });

  brasero = callPackage ../tools/cd-dvd/brasero/wrapper.nix { };

  brigand = callPackage ../development/libraries/brigand { };

  brltty = callPackage ../tools/misc/brltty { };

  brook = callPackage ../tools/networking/brook { };

  broot = callPackage ../tools/misc/broot {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  bruteforce-luks = callPackage ../tools/security/bruteforce-luks { };

  brutespray = callPackage ../tools/security/brutespray { };

  breakpointHook = assert stdenv.isLinux;
    makeSetupHook { } ../build-support/setup-hooks/breakpoint-hook.sh;

  bsod = callPackage ../misc/emulators/bsod { };

  btrfs-progs = callPackage ../tools/filesystems/btrfs-progs { };

  btrbk = callPackage ../tools/backup/btrbk {
    asciidoc = asciidoc-full;
  };

  buildpack = callPackage ../development/tools/buildpack { };

  buildtorrent = callPackage ../tools/misc/buildtorrent { };

  bustle = haskellPackages.bustle;

  buttersink = callPackage ../tools/filesystems/buttersink { };

  bwm_ng = callPackage ../tools/networking/bwm-ng { };

  byobu = callPackage ../tools/misc/byobu {
    # Choices: [ tmux screen ];
    textual-window-manager = tmux;
  };

  bsh = fetchurl {
    url = http://www.beanshell.org/bsh-2.0b5.jar;
    sha256 = "0p2sxrpzd0vsk11zf3kb5h12yl1nq4yypb5mpjrm8ww0cfaijck2";
  };

  btfs = callPackage ../os-specific/linux/btfs { };

  buildah = callPackage ../development/tools/buildah { };

  buildkit = callPackage ../development/tools/buildkit { };

  bukubrow = callPackage ../tools/networking/bukubrow { };

  burpsuite = callPackage ../tools/networking/burpsuite {};

  bs-platform = callPackage ../development/compilers/bs-platform {};

  c3d = callPackage ../applications/graphics/c3d {
    stdenv = gcc8Stdenv;
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  cue2pops = callPackage ../tools/cd-dvd/cue2pops { };

  cabal2nix-unwrapped = haskell.lib.justStaticExecutables (haskell.lib.generateOptparseApplicativeCompletion "cabal2nix" haskellPackages.cabal2nix);

  cabal2nix = symlinkJoin {
    inherit (cabal2nix-unwrapped) name meta;
    nativeBuildInputs = [ makeWrapper ];
    paths = [ cabal2nix-unwrapped ];
    postBuild = ''
      wrapProgram $out/bin/cabal2nix \
        --prefix PATH ":" "${lib.makeBinPath [ nix nix-prefetch-scripts ]}"
    '';
  };

  stack2nix = with haskell.lib; overrideCabal (justStaticExecutables haskellPackages.stack2nix) (drv: {
    executableToolDepends = [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/stack2nix \
        --prefix PATH ":" "${git}/bin:${cabal-install}/bin"
    '';
  });

  caddy = callPackage ../servers/caddy { };
  caddy2 = callPackage ../servers/caddy/v2.nix { };
  traefik = callPackage ../servers/traefik { };

  calamares = libsForQt5.callPackage ../tools/misc/calamares {
    python = python3;
    boost = pkgs.boost.override { python = python3; };
  };

  candle = libsForQt5.callPackage ../applications/misc/candle { };

  capstone = callPackage ../development/libraries/capstone { };
  unicorn-emu = callPackage ../development/libraries/unicorn-emu { };

  casync = callPackage ../applications/networking/sync/casync {
    sphinx = python3Packages.sphinx;
  };

  cataract          = callPackage ../applications/misc/cataract { };
  cataract-unstable = callPackage ../applications/misc/cataract/unstable.nix { };

  catch = callPackage ../development/libraries/catch { };

  catch2 = callPackage ../development/libraries/catch2 { };

  catdoc = callPackage ../tools/text/catdoc { };

  catdocx = callPackage ../tools/text/catdocx { };

  catclock = callPackage ../applications/misc/catclock { };

  cardpeek = callPackage ../applications/misc/cardpeek { };

  cawbird = callPackage ../applications/networking/cawbird { };

  cde = callPackage ../tools/package-management/cde { };

  cdemu-daemon = callPackage ../misc/emulators/cdemu/daemon.nix { };

  cdemu-client = callPackage ../misc/emulators/cdemu/client.nix { };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    gflags = null; # only required for examples/tests
  };

  gcdemu = callPackage ../misc/emulators/cdemu/gui.nix { };

  image-analyzer = callPackage ../misc/emulators/cdemu/analyzer.nix { };

  cbor-diag = callPackage ../development/tools/cbor-diag { };

  ccnet = callPackage ../tools/networking/ccnet { };

  cassowary = callPackage ../tools/networking/cassowary { };

  croc = callPackage ../tools/networking/croc { };

  cddl = callPackage ../development/tools/cddl { };

  cedille = callPackage ../applications/science/logic/cedille
                          { inherit (haskellPackages) alex happy Agda ghcWithPackages;
                          };

  cfdyndns = callPackage ../applications/networking/dyndns/cfdyndns { };

  charliecloud = callPackage ../applications/virtualization/charliecloud { };

  chelf = callPackage ../tools/misc/chelf { };

  cht-sh = callPackage ../tools/misc/cht.sh { };

  ckbcomp = callPackage ../tools/X11/ckbcomp { };

  clac = callPackage ../tools/misc/clac {};

  clash = callPackage ../tools/networking/clash { };

  clasp = callPackage ../tools/misc/clasp { };

  clevis = callPackage ../tools/security/clevis {
    asciidoc = asciidoc-full;
  };

  cli53 = callPackage ../tools/admin/cli53 { };

  cli-visualizer = callPackage ../applications/misc/cli-visualizer { };

  clog-cli = callPackage ../development/tools/clog-cli { };

  cloud-init = callPackage ../tools/virtualization/cloud-init { };

  cloudflared = callPackage ../applications/networking/cloudflared { };

  cloudmonkey = callPackage ../tools/virtualization/cloudmonkey { };

  clib = callPackage ../tools/package-management/clib { };

  clingo = callPackage ../applications/science/logic/potassco/clingo.nix { };

  clingcon = callPackage ../applications/science/logic/potassco/clingcon.nix { };

  clprover = callPackage ../applications/science/logic/clprover/clprover.nix { };

  coloredlogs = with python3Packages; toPythonApplication coloredlogs;

  colord-kde = libsForQt5.callPackage ../tools/misc/colord-kde {};

  colpack = callPackage ../applications/science/math/colpack { };

  compactor = callPackage ../applications/networking/compactor { };

  consul = callPackage ../servers/consul {
    # Version 1.6.0 fails to build with go 1.13 due to broken dependency:
    #   go/src/github.com/hashicorp/consul/vendor/github.com/envoyproxy/go-control-plane/envoy/type/http_status.pb.go:11:2: code in directory /build/go/src/github.com/hashicorp/consul/vendor/github.com/envoyproxy/protoc-gen-validate/validate expects import "github.com/lyft/protoc-gen-validate/validate"
    buildGoPackage = buildGo112Package;
  };

  consul-alerts = callPackage ../servers/monitoring/consul-alerts { };

  consul-template = callPackage ../tools/system/consul-template { };

  copyright-update = callPackage ../tools/text/copyright-update { };

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

  corosync = callPackage ../servers/corosync { };

  cowsay = callPackage ../tools/misc/cowsay { };

  cherrytree = callPackage ../applications/misc/cherrytree { };

  chntpw = callPackage ../tools/security/chntpw { };

  clipman = callPackage ../tools/misc/clipman { };

  clipster = callPackage ../tools/misc/clipster { };

  contrast = callPackage ../applications/accessibility/contrast { };

  cplex = callPackage ../applications/science/math/cplex (config.cplex or {});

  cpulimit = callPackage ../tools/misc/cpulimit { };

  codesearch = callPackage ../tools/text/codesearch { };

  codec2 = callPackage ../development/libraries/codec2 { };

  contacts = callPackage ../tools/misc/contacts {
    inherit (darwin.apple_sdk.frameworks) Foundation AddressBook;
    xcbuildHook = xcbuild6Hook;
  };

  colorls = callPackage ../tools/system/colorls { };

  coloursum = callPackage ../tools/text/coloursum {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  compsize = callPackage ../os-specific/linux/compsize { };

  coturn = callPackage ../servers/coturn { };

  coursier = callPackage ../development/tools/coursier {};

  cppclean = callPackage ../development/tools/cppclean {};

  crex = callPackage ../tools/misc/crex { };

  cri-tools = callPackage ../tools/virtualization/cri-tools {};

  crip = callPackage ../applications/audio/crip { };

  crosvm = callPackage ../applications/virtualization/crosvm { };

  crunch = callPackage ../tools/security/crunch { };

  crudini = callPackage ../tools/misc/crudini { };

  csv2odf = callPackage ../applications/office/csv2odf { };

  csvkit = callPackage ../tools/text/csvkit { };

  csvs-to-sqlite = with python3Packages; toPythonApplication csvs-to-sqlite;

  cucumber = callPackage ../development/tools/cucumber {};

  dabtools = callPackage ../applications/radio/dabtools { };

  daemontools = callPackage ../tools/admin/daemontools { };

  dale = callPackage ../development/compilers/dale { };

  dante = callPackage ../servers/dante { };

  dasher = callPackage ../applications/accessibility/dasher { };

  datamash = callPackage ../tools/misc/datamash { };

  datasette = with python3Packages; toPythonApplication datasette;

  howard-hinnant-date = callPackage ../development/libraries/howard-hinnant-date { };

  datefudge = callPackage ../tools/system/datefudge { };

  dateutils = callPackage ../tools/misc/dateutils { };

  datovka = libsForQt5.callPackage ../applications/networking/datovka { };

  dconf = callPackage ../development/libraries/dconf { };

  ddar = callPackage ../tools/backup/ddar { };

  ddate = callPackage ../tools/misc/ddate { };

  dedup = callPackage ../tools/backup/dedup { };

  dehydrated = callPackage ../tools/admin/dehydrated { };

  deis = callPackage ../development/tools/deis {};

  deisctl = callPackage ../development/tools/deisctl {};

  deja-dup = callPackage ../applications/backup/deja-dup { };

  dejsonlz4 = callPackage ../tools/compression/dejsonlz4 { };

  desync = callPackage ../applications/networking/sync/desync { };

  devmem2 = callPackage ../os-specific/linux/devmem2 { };

  dbus-broker = callPackage ../os-specific/linux/dbus-broker { };

  ioport = callPackage ../os-specific/linux/ioport {};

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialog = callPackage ../development/tools/misc/dialog { };

  dibbler = callPackage ../tools/networking/dibbler { };

  diesel-cli = callPackage ../development/tools/diesel-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  dirb = callPackage ../tools/networking/dirb { };

  direnv = callPackage ../tools/misc/direnv { };

  h = callPackage ../tools/misc/h { };

  discount = callPackage ../tools/text/discount { };

  diskscan = callPackage ../tools/misc/diskscan { };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  dislocker = callPackage ../tools/filesystems/dislocker { };

  distgen = callPackage ../development/tools/distgen {};

  distrobuilder = callPackage ../tools/virtualization/distrobuilder { };

  ditaa = callPackage ../tools/graphics/ditaa { };

  dino = callPackage ../applications/networking/instant-messengers/dino { };

  dlx = callPackage ../misc/emulators/dlx { };

  doitlive = callPackage ../tools/misc/doitlive { };

  dokuwiki = callPackage ../servers/web-apps/dokuwiki { };

  dosage = callPackage ../applications/graphics/dosage { };

  dozenal = callPackage ../applications/misc/dozenal { };

  dpic = callPackage ../tools/graphics/dpic { };

  dragon-drop = callPackage ../tools/X11/dragon-drop {
    gtk = gtk3;
  };

  dsvpn = callPackage ../applications/networking/dsvpn { };

  dtools = callPackage ../development/tools/dtools { };

  dtrx = callPackage ../tools/compression/dtrx { };

  dua = callPackage ../tools/misc/dua { };

  inherit (ocamlPackages) dune dune_2;

  duperemove = callPackage ../tools/filesystems/duperemove { };

  dvc = callPackage ../applications/version-management/dvc { };

  dvc-with-remotes = callPackage ../applications/version-management/dvc {
    enableGoogle = true;
    enableAWS = true;
    enableAzure = true;
    enableSSH = true;
  };

  dylibbundler = callPackage ../tools/misc/dylibbundler { };

  dynamic-colors = callPackage ../tools/misc/dynamic-colors { };

  dyncall = callPackage ../development/libraries/dyncall { };

  earlyoom = callPackage ../os-specific/linux/earlyoom { };

  EBTKS = callPackage ../development/libraries/science/biology/EBTKS { };

  ecasound = callPackage ../applications/audio/ecasound { };

  edac-utils = callPackage ../os-specific/linux/edac-utils { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  eksctl = callPackage ../tools/admin/eksctl { };

  elementary-xfce-icon-theme = callPackage ../data/icons/elementary-xfce-icon-theme { };

  ell = callPackage ../os-specific/linux/ell { };

  elm-github-install = callPackage ../tools/package-management/elm-github-install { };

  elogind = callPackage ../applications/misc/elogind { };

  enca = callPackage ../tools/text/enca { };

  ent = callPackage ../tools/misc/ent { };

  envconsul = callPackage ../tools/system/envconsul { };

  envsubst = callPackage ../tools/misc/envsubst { };

  errcheck = callPackage ../development/tools/errcheck { };

  eschalot = callPackage ../tools/security/eschalot { };

  esphome = callPackage ../servers/home-assistant/esphome.nix { };

  esptool = callPackage ../tools/misc/esptool { };

  esptool-ck = callPackage ../tools/misc/esptool-ck { };

  ephemeralpg = callPackage ../development/tools/database/ephemeralpg {};

  et = callPackage ../applications/misc/et {};

  ejson = callPackage ../development/tools/ejson {};

  eternal-terminal = callPackage ../tools/networking/eternal-terminal {};

  f3 = callPackage ../tools/filesystems/f3 { };

  fac = callPackage ../development/tools/fac { };

  facedetect = callPackage ../tools/graphics/facedetect { };

  facter = callPackage ../tools/system/facter { };

  fasd = callPackage ../tools/misc/fasd { };

  fastJson = callPackage ../development/libraries/fastjson { };

  fast-cli = nodePackages.fast-cli;

  faudio = callPackage ../development/libraries/faudio { };

  fd = callPackage ../tools/misc/fd { };

  fdroidserver = python3Packages.callPackage ../development/tools/fdroidserver { };

  filebench = callPackage ../tools/misc/filebench { };

  fileshare = callPackage ../servers/fileshare {};

  fileshelter = callPackage ../servers/web-apps/fileshelter { };

  firecracker = callPackage ../applications/virtualization/firecracker { };

  firectl = callPackage ../applications/virtualization/firectl { };

  firestarter = callPackage ../applications/misc/firestarter { };

  fselect = callPackage ../tools/misc/fselect { };

  fsmon = callPackage ../tools/misc/fsmon { };

  fsql = callPackage ../tools/misc/fsql { };

  fop = callPackage ../tools/typesetting/fop { };

  fondu = callPackage ../tools/misc/fondu { };

  fpp = callPackage ../tools/misc/fpp { };

  fsmark = callPackage ../tools/misc/fsmark { };

  futhark = haskell.lib.justStaticExecutables haskellPackages.futhark;

  fwup = callPackage ../tools/misc/fwup { };

  fx_cast_bridge = callPackage ../tools/misc/fx_cast { };

  fzf = callPackage ../tools/misc/fzf { };

  fzf-zsh = callPackage ../shells/zsh/fzf-zsh { };

  fzy = callPackage ../tools/misc/fzy { };

  g2o = callPackage ../development/libraries/g2o { };

  gbsplay = callPackage ../applications/audio/gbsplay { };

  gdrivefs = python27Packages.gdrivefs;

  gdrive = callPackage ../applications/networking/gdrive { };

  go-2fa = callPackage ../tools/security/2fa {};

  go-dependency-manager = callPackage ../development/tools/gdm { };

  geckodriver = callPackage ../development/tools/geckodriver { };

  geekbench = callPackage ../tools/misc/geekbench { };

  gencfsm = callPackage ../tools/security/gencfsm { };

  genromfs = callPackage ../tools/filesystems/genromfs { };

  gh-ost = callPackage ../tools/misc/gh-ost { };

  ghidra-bin = callPackage ../tools/security/ghidra { };

  gif-for-cli = callPackage ../tools/misc/gif-for-cli { };

  gir-rs = callPackage ../development/tools/gir { };

  gist = callPackage ../tools/text/gist { };

  gixy = callPackage ../tools/admin/gixy { };

  gllvm = callPackage ../development/tools/gllvm { };

  glide = callPackage ../development/tools/glide { };

  globalarrays = callPackage ../development/libraries/globalarrays { };

  glock = callPackage ../development/tools/glock { };

  glslviewer = callPackage ../development/tools/glslviewer {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  gmic = callPackage ../tools/graphics/gmic { };

  gmic-qt = libsForQt5.callPackage ../tools/graphics/gmic-qt { };

  gmic-qt-krita = gmic-qt.override {
    variant = "krita";
  };

  goa = callPackage ../development/tools/goa { };

  gohai = callPackage ../tools/system/gohai { };

  gorilla-bin = callPackage ../tools/security/gorilla-bin { };

  gosu = callPackage ../tools/misc/gosu { };

  gotify-cli = callPackage ../tools/misc/gotify-cli { };

  gping = callPackage ../tools/networking/gping { };

  greg = callPackage ../applications/audio/greg {
    pythonPackages = python3Packages;
  };

  grim = callPackage ../tools/graphics/grim { };

  gringo = callPackage ../tools/misc/gringo { };

  grobi = callPackage ../tools/X11/grobi { };

  gscan2pdf = callPackage ../applications/graphics/gscan2pdf { };

  gsctl = callPackage ../applications/misc/gsctl { };

  gthree = callPackage ../development/libraries/gthree { };

  gti = callPackage ../tools/misc/gti { };

  hdate = callPackage ../applications/misc/hdate { };

  heatseeker = callPackage ../tools/misc/heatseeker { };

  hebcal = callPackage ../tools/misc/hebcal {};

  hexio = callPackage ../development/tools/hexio { };

  hexyl = callPackage ../tools/misc/hexyl { };

  hid-listen = callPackage ../tools/misc/hid-listen { };

  hocr-tools = with python3Packages; toPythonApplication hocr-tools;

  home-manager = callPackage ../tools/package-management/home-manager {};

  hostsblock = callPackage ../tools/misc/hostsblock { };

  hopper = qt5.callPackage ../development/tools/analysis/hopper {};

  hr = callPackage ../applications/misc/hr { };

  hyx = callPackage ../tools/text/hyx { };

  icdiff = callPackage ../tools/text/icdiff {};

  ifm = callPackage ../tools/graphics/ifm {};

  interlock = callPackage ../servers/interlock {};

  jellyfin = callPackage ../servers/jellyfin { ffmpeg = ffmpeg_4; };

  jellyfin-mpv-shim = python3Packages.callPackage ../applications/video/jellyfin-mpv-shim { };

  jotta-cli = callPackage ../applications/misc/jotta-cli { };

  jwt-cli = callPackage ../tools/security/jwt-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  kapacitor = callPackage ../servers/monitoring/kapacitor { };

  kisslicer = callPackage ../tools/misc/kisslicer { };

  klaus = with python3Packages; toPythonApplication klaus;

  kramdown-rfc2629 = callPackage ../tools/text/kramdown-rfc2629 { };

  lcdproc = callPackage ../servers/monitoring/lcdproc { };

  languagetool = callPackage ../tools/text/languagetool {  };

  lepton = callPackage ../tools/graphics/lepton { };

  lexicon = callPackage ../tools/admin/lexicon { };

  lief = callPackage ../development/libraries/lief {};

  libndtypes = callPackage ../development/libraries/libndtypes { };

  libxnd = callPackage ../development/libraries/libxnd { };

  link-grammar = callPackage ../tools/text/link-grammar { };

  linuxptp = callPackage ../os-specific/linux/linuxptp { };

  loadwatch = callPackage ../tools/system/loadwatch { };

  loccount = callPackage ../development/tools/misc/loccount { };

  long-shebang = callPackage ../misc/long-shebang {};

  numatop = callPackage ../os-specific/linux/numatop { };

  iio-sensor-proxy = callPackage ../os-specific/linux/iio-sensor-proxy { };

  ipvsadm = callPackage ../os-specific/linux/ipvsadm { };

  ir-standard-fonts = callPackage ../data/fonts/ir-standard-fonts { };

  lynis = callPackage ../tools/security/lynis { };

  mapproxy = callPackage ../applications/misc/mapproxy { };

  marlin-calc = callPackage ../tools/misc/marlin-calc {};

  mathics = with python2Packages; toPythonApplication mathics;

  masscan = callPackage ../tools/security/masscan {
    stdenv = gccStdenv;
  };

  massren = callPackage ../tools/misc/massren { };

  medusa = callPackage ../tools/security/medusa { };

  megasync = libsForQt5.callPackage ../applications/misc/megasync { };

  megacmd = callPackage ../applications/misc/megacmd { };

  meritous = callPackage ../games/meritous { };

  opendune = callPackage ../games/opendune { };

  merriweather = callPackage ../data/fonts/merriweather { };

  merriweather-sans = callPackage ../data/fonts/merriweather-sans { };

  meson = callPackage ../development/tools/build-managers/meson { };

  meson-tools = callPackage ../misc/meson-tools { };

  metabase = callPackage ../servers/metabase { };

  midicsv = callPackage ../tools/audio/midicsv { };

  mididings = callPackage ../tools/audio/mididings { };

  miniserve = callPackage ../tools/misc/miniserve { };

  mkspiffs = callPackage ../tools/filesystems/mkspiffs { };

  mkspiffs-presets = recurseIntoAttrs (callPackages ../tools/filesystems/mkspiffs/presets.nix { });

  mlarchive2maildir = callPackage ../applications/networking/mailreaders/mlarchive2maildir { };

  monetdb = callPackage ../servers/sql/monetdb { };

  mons = callPackage ../tools/misc/mons {};

  mousetweaks = callPackage ../applications/accessibility/mousetweaks {
    inherit (pkgs.xorg) libX11 libXtst libXfixes;
  };

  mp3blaster = callPackage ../applications/audio/mp3blaster { };

  mp3cat = callPackage ../tools/audio/mp3cat {};

  mp3fs = callPackage ../tools/filesystems/mp3fs { };

  mpdas = callPackage ../tools/audio/mpdas { };

  mpdcron = callPackage ../tools/audio/mpdcron { };

  mpdris2 = callPackage ../tools/audio/mpdris2 { };

  mpd-mpris = callPackage ../tools/audio/mpd-mpris { };

  mq-cli = callPackage ../tools/system/mq-cli { };

  nfdump = callPackage ../tools/networking/nfdump { };

  nfstrace = callPackage ../tools/networking/nfstrace { };

  nixpkgs-pytools = with python3.pkgs; toPythonApplication nixpkgs-pytools;

  noteshrink = callPackage ../tools/misc/noteshrink { };

  noti = callPackage ../tools/misc/noti {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  nrsc5 = callPackage ../applications/misc/nrsc5 { };

  nwipe = callPackage ../tools/security/nwipe { };

  nx-libs = callPackage ../tools/X11/nx-libs { };

  nyx = callPackage ../tools/networking/nyx { };

  ocrmypdf = callPackage ../tools/text/ocrmypdf { };

  onboard = callPackage ../applications/misc/onboard { };

  onnxruntime = callPackage ../development/libraries/onnxruntime { };

  xkbd = callPackage ../applications/misc/xkbd { };

  optar = callPackage ../tools/graphics/optar {};

  obinskit = callPackage ../applications/misc/obinskit {};

  pastel = callPackage ../applications/misc/pastel {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  patdiff = callPackage ../tools/misc/patdiff { };

  pbpst = callPackage ../applications/misc/pbpst { };

  pbzx = callPackage ../tools/compression/pbzx { };

  persepolis = python3Packages.callPackage ../tools/networking/persepolis { };

  pev = callPackage ../development/tools/analysis/pev { };

  phoronix-test-suite = callPackage ../tools/misc/phoronix-test-suite { };

  photon = callPackage ../tools/networking/photon { };

  playerctl = callPackage ../tools/audio/playerctl { };

  ps_mem = callPackage ../tools/system/ps_mem { };

  psstop = callPackage ../tools/system/psstop { };

  precice = callPackage ../development/libraries/precice { };

  pueue = callPackage ../applications/misc/pueue { };

  pixiecore = callPackage ../tools/networking/pixiecore {};

  pyCA = python3Packages.callPackage ../applications/video/pyca {};

  pyznap = python3Packages.callPackage ../tools/backup/pyznap {};

  procs = callPackage ../tools/admin/procs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  psrecord = python3Packages.callPackage ../tools/misc/psrecord {};

  scour = with python3Packages; toPythonApplication scour;

  s2png = callPackage ../tools/graphics/s2png { };

  shab = callPackage ../tools/text/shab { };

  shell-hist = callPackage ../tools/misc/shell-hist { };

  simg2img = callPackage ../tools/filesystems/simg2img { };

  snipes = callPackage ../games/snipes { };

  snippetpixie = callPackage ../tools/text/snippetpixie { };

  socklog = callPackage ../tools/system/socklog { };

  stagit = callPackage ../development/tools/stagit { };

  step-ca = callPackage ../tools/security/step-ca { };

  step-cli = callPackage ../tools/security/step-cli { };

  string-machine = callPackage ../applications/audio/string-machine { };

  bash-supergenpass = callPackage ../tools/security/bash-supergenpass { };

  sweep-visualizer = callPackage ../tools/misc/sweep-visualizer { };

  syscall_limiter = callPackage ../os-specific/linux/syscall_limiter {};

  syslogng = callPackage ../tools/system/syslog-ng { };

  syslogng_incubator = callPackage ../tools/system/syslog-ng-incubator { };

  inherit (callPackages ../servers/rainloop { })
    rainloop-community
    rainloop-standard;

  rav1e = callPackage ../tools/video/rav1e { };

  ring-daemon = callPackage ../applications/networking/instant-messengers/ring-daemon { };

  riot-desktop = callPackage ../applications/networking/instant-messengers/riot/riot-desktop.nix { };

  riot-web = callPackage ../applications/networking/instant-messengers/riot/riot-web.nix {
    conf = config.riot-web.conf or {};
  };

  ripasso-cursive = callPackage ../tools/security/ripasso/cursive.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Security;
  };

  roundcube = callPackage ../servers/roundcube { };

  roundcubePlugins = dontRecurseIntoAttrs (callPackage ../servers/roundcube/plugins { });

  routinator = callPackage ../servers/routinator { };

  rsbep = callPackage ../tools/backup/rsbep { };

  rsyslog = callPackage ../tools/system/rsyslog {
    hadoop = null; # Currently Broken
    libksi = null; # Currently Broken
  };

  rsyslog-light = rsyslog.override {
    libkrb5 = null;
    systemd = null;
    jemalloc = null;
    libmysqlclient = null;
    postgresql = null;
    libdbi = null;
    net-snmp = null;
    libuuid = null;
    gnutls = null;
    libgcrypt = null;
    liblognorm = null;
    openssl = null;
    librelp = null;
    libksi = null;
    liblogging = null;
    libnet = null;
    hadoop = null;
    rdkafka = null;
    libmongo-client = null;
    czmq = null;
    rabbitmq-c = null;
    hiredis = null;
    libmaxminddb = null;
  };

  xmousepasteblock = callPackage ../tools/X11/xmousepasteblock { };

  mar1d = callPackage ../games/mar1d { } ;

  mcrypt = callPackage ../tools/misc/mcrypt { };

  mongodb-compass = callPackage ../tools/misc/mongodb-compass { };

  mongodb-tools = callPackage ../tools/misc/mongodb-tools { };

  moosefs = callPackage ../tools/filesystems/moosefs { };

  mozlz4a = callPackage ../tools/compression/mozlz4a { };

  msr-tools = callPackage ../os-specific/linux/msr-tools { };

  mstflint = callPackage ../tools/misc/mstflint { };

  mcelog = callPackage ../os-specific/linux/mcelog {
    utillinux = utillinuxMinimal;
  };

  sqlint = callPackage ../development/tools/sqlint { };

  antibody = callPackage ../shells/zsh/antibody { };

  antigen = callPackage ../shells/zsh/antigen { };

  apparix = callPackage ../tools/misc/apparix { };

  appleseed = callPackage ../tools/graphics/appleseed { };

  arping = callPackage ../tools/networking/arping { };

  arpoison = callPackage ../tools/networking/arpoison { };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (python2Packages) matplotlib numpy aafigure recursivePthLoader;
    w3m = w3m-batch;
    enableStandardFeatures = false;
  };

  asciidoc-full = appendToName "full" (asciidoc.override {
    inherit (python2Packages) pygments;
    texlive = texlive.combine { inherit (texlive) scheme-minimal dvipng; };
    enableStandardFeatures = true;
  });

  asciidoc-full-with-plugins = appendToName "full-with-plugins" (asciidoc.override {
    inherit (python2Packages) pygments;
    texlive = texlive.combine { inherit (texlive) scheme-minimal dvipng; };
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  });

  asciidoctor = callPackage ../tools/typesetting/asciidoctor {
    # kindlegen is unfree, don't enable by default
    kindlegen = null;
    # epubcheck pulls in Java, which is problematic on some platforms
    epubcheck = null;
  };

  asciidoctorj = callPackage ../tools/typesetting/asciidoctorj { };

  asunder = callPackage ../applications/audio/asunder { };

  autossh = callPackage ../tools/networking/autossh { };

  assh = callPackage ../tools/networking/assh { };

  asynk = callPackage ../tools/networking/asynk { };

  b2sum = callPackage ../tools/security/b2sum {
    inherit (llvmPackages) openmp;
  };

  bacula = callPackage ../tools/backup/bacula { };

  bareos = callPackage ../tools/backup/bareos { };

  bats = callPackage ../development/interpreters/bats { };

  bbe = callPackage ../tools/misc/bbe { };

  bdsync = callPackage ../tools/backup/bdsync { };

  beanstalkd = callPackage ../servers/beanstalkd { };

  beets = callPackage ../tools/audio/beets {
    pythonPackages = python3Packages;
  };

  bento4 = callPackage ../tools/video/bento4 { };

  bepasty = callPackage ../tools/misc/bepasty { };

  bettercap = callPackage ../tools/security/bettercap { };

  bfg-repo-cleaner = gitAndTools.bfg-repo-cleaner;

  bfs = callPackage ../tools/system/bfs { };

  bgs = callPackage ../tools/X11/bgs { };

  bibclean = callPackage ../tools/typesetting/bibclean { };

  biber = callPackage ../tools/typesetting/biber { };

  biblatex-check = callPackage ../tools/typesetting/biblatex-check { };

  birdfont = callPackage ../tools/misc/birdfont { };
  xmlbird = callPackage ../tools/misc/birdfont/xmlbird.nix { };

  blastem = callPackage ../misc/emulators/blastem {
    inherit (python27Packages) pillow;
  };

  blueman = callPackage ../tools/bluetooth/blueman { };

  bmrsa = callPackage ../tools/security/bmrsa/11.nix { };

  bogofilter = callPackage ../tools/misc/bogofilter { };

  bsdbuild = callPackage ../development/tools/misc/bsdbuild { };

  bsdiff = callPackage ../tools/compression/bsdiff { };

  btar = callPackage ../tools/backup/btar {
    librsync = librsync_0_9;
  };

  bud = callPackage ../tools/networking/bud {
    inherit (pythonPackages) gyp;
  };

  bup = callPackage ../tools/backup/bup { };

  burp = callPackage ../tools/backup/burp { };

  buku = callPackage ../applications/misc/buku { };

  byzanz = callPackage ../applications/video/byzanz {};

  ori = callPackage ../tools/backup/ori { };

  anydesk = callPackage ../applications/networking/remote/anydesk { };

  atool = callPackage ../tools/archivers/atool { };

  bash_unit = callPackage ../tools/misc/bash_unit { };

  bsc = callPackage ../tools/compression/bsc {
    inherit (llvmPackages) openmp;
  };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  cabextract = callPackage ../tools/archivers/cabextract { };

  cadaver = callPackage ../tools/networking/cadaver {
    openssl = openssl_1_0_2;
  };

  davix = callPackage ../tools/networking/davix { };

  cantata = libsForQt5.callPackage ../applications/audio/cantata {
    inherit vlc;
  };

  can-utils = callPackage ../os-specific/linux/can-utils { };

  caudec = callPackage ../applications/audio/caudec { };

  ccd2iso = callPackage ../tools/cd-dvd/ccd2iso { };

  ccid = callPackage ../tools/security/ccid { };

  ccrypt = callPackage ../tools/security/ccrypt { };

  ccze = callPackage ../tools/misc/ccze { };

  cdecl = callPackage ../development/tools/cdecl { };

  cdi2iso = callPackage ../tools/cd-dvd/cdi2iso { };

  cdimgtools = callPackage ../tools/cd-dvd/cdimgtools { };

  cdrdao = callPackage ../tools/cd-dvd/cdrdao { };

  cdrkit = callPackage ../tools/cd-dvd/cdrkit { };

  cdrtools = callPackage ../tools/cd-dvd/cdrtools {
    inherit (darwin.apple_sdk.frameworks) Carbon IOKit;
  };

  cemu = qt5.callPackage ../applications/science/math/cemu { };

  isomd5sum = callPackage ../tools/cd-dvd/isomd5sum { };

  mdf2iso = callPackage ../tools/cd-dvd/mdf2iso { };

  nrg2iso = callPackage ../tools/cd-dvd/nrg2iso { };

  libceph = ceph.lib;
  inherit (callPackages ../tools/filesystems/ceph {
    boost = boost167.override { enablePython = true; python = python37; };
  })
    ceph
    ceph-client;
  ceph-dev = ceph;

  inherit (callPackages ../tools/security/certmgr { })
    certmgr certmgr-selfsigned;

  cfdg = callPackage ../tools/graphics/cfdg { };

  checkinstall = callPackage ../tools/package-management/checkinstall { };

  chit = callPackage ../development/tools/chit { };

  chkrootkit = callPackage ../tools/security/chkrootkit { };

  chrony = callPackage ../tools/networking/chrony { };

  chunkfs = callPackage ../tools/filesystems/chunkfs { };

  chunksync = callPackage ../tools/backup/chunksync { };

  cipherscan = callPackage ../tools/security/cipherscan {
    openssl = if stdenv.hostPlatform.system == "x86_64-linux"
      then openssl-chacha
      else openssl;
  };

  cjdns = callPackage ../tools/networking/cjdns { };

  cksfv = callPackage ../tools/networking/cksfv { };

  clementine = libsForQt5.callPackage ../applications/audio/clementine {
    gst_plugins =
      with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav ];
  };

  clementineUnfree = clementine.unfree;

  ciopfs = callPackage ../tools/filesystems/ciopfs { };

  circleci-cli = callPackage ../development/tools/misc/circleci-cli { };

  circus = callPackage ../tools/networking/circus { };

  citrix_workspace_unwrapped = callPackage ../applications/networking/remote/citrix-workspace { };
  citrix_workspace_unwrapped_19_12_0 = citrix_workspace_unwrapped.override { version = "19.12.0"; };
  citrix_workspace_unwrapped_19_10_0 = citrix_workspace_unwrapped.override { version = "19.10.0"; };
  citrix_workspace_unwrapped_19_8_0 = citrix_workspace_unwrapped.override { version = "19.8.0"; };
  citrix_workspace_unwrapped_19_6_0 = citrix_workspace_unwrapped.override { version = "19.6.0"; };
  citrix_workspace_unwrapped_19_3_0 = citrix_workspace_unwrapped.override { version = "19.3.0"; };

  citrix_workspace = callPackage ../applications/networking/remote/citrix-workspace/wrapper.nix {
    citrix_workspace = citrix_workspace_unwrapped;
  };
  citrix_workspace_19_12_0 = callPackage ../applications/networking/remote/citrix-workspace/wrapper.nix {
    citrix_workspace = citrix_workspace_unwrapped_19_12_0;
  };
  citrix_workspace_19_10_0 = callPackage ../applications/networking/remote/citrix-workspace/wrapper.nix {
    citrix_workspace = citrix_workspace_unwrapped_19_10_0;
  };
  citrix_workspace_19_8_0 = callPackage ../applications/networking/remote/citrix-workspace/wrapper.nix {
    citrix_workspace = citrix_workspace_unwrapped_19_8_0;
  };
  citrix_workspace_19_6_0 = callPackage ../applications/networking/remote/citrix-workspace/wrapper.nix {
    citrix_workspace = citrix_workspace_unwrapped_19_6_0;
  };
  citrix_workspace_19_3_0 = callPackage ../applications/networking/remote/citrix-workspace/wrapper.nix {
    citrix_workspace = citrix_workspace_unwrapped_19_3_0;
  };

  citra = libsForQt5.callPackage ../misc/emulators/citra { };

  cmst = libsForQt5.callPackage ../tools/networking/cmst { };

  cmt = callPackage ../applications/audio/cmt {};

  codimd = callPackage ../servers/web-apps/codimd {
    nodejs = nodejs-10_x;
  };

  colord = callPackage ../tools/misc/colord { };

  colord-gtk = callPackage ../tools/misc/colord-gtk { };

  colordiff = callPackage ../tools/text/colordiff { };

  concurrencykit = callPackage ../development/libraries/concurrencykit { };

  connect = callPackage ../tools/networking/connect { };

  conspy = callPackage ../os-specific/linux/conspy {};

  inherit (callPackage ../tools/networking/connman {})
    connman
    connmanFull
    connmanMinimal
  ;

  connman-gtk = callPackage ../tools/networking/connman/connman-gtk { };

  connman-ncurses = callPackage ../tools/networking/connman/connman-ncurses { };

  connman-notify = callPackage ../tools/networking/connman/connman-notify { };

  connmanui = callPackage ../tools/networking/connman/connmanui { };

  connman_dmenu = callPackage ../tools/networking/connman/connman_dmenu  { };

  convertlit = callPackage ../tools/text/convertlit { };

  collectd = callPackage ../tools/system/collectd {
    libsigrok = libsigrok-0-3-0; # not compatible with >= 0.4.0 yet
  };

  collectd-data = callPackage ../tools/system/collectd/data.nix { };

  colormake = callPackage ../development/tools/build-managers/colormake { };

  cpuminer = callPackage ../tools/misc/cpuminer { };

  cpuminer-multi = callPackage ../tools/misc/cpuminer-multi { };

  cryptpad = callPackage ../servers/web-apps/cryptpad { };

  ethash = callPackage ../development/libraries/ethash { };

  ethminer = callPackage ../tools/misc/ethminer { };

  cuetools = callPackage ../tools/cd-dvd/cuetools { };

  u3-tool = callPackage ../tools/filesystems/u3-tool { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  unionfs-fuse = callPackage ../tools/filesystems/unionfs-fuse { };

  usb-modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };
  usb-modeswitch-data = callPackage ../development/tools/misc/usb-modeswitch/data.nix { };

  anthy = callPackage ../tools/inputmethods/anthy { };

  evdevremapkeys = callPackage ../tools/inputmethods/evdevremapkeys { };

  gebaar-libinput = callPackage ../tools/inputmethods/gebaar-libinput { };

  libpinyin = callPackage ../development/libraries/libpinyin { };

  libskk = callPackage ../development/libraries/libskk {
    inherit (gnome3) gnome-common;
  };

  m17n_db = callPackage ../tools/inputmethods/m17n-db { };

  m17n_lib = callPackage ../tools/inputmethods/m17n-lib { };

  libotf = callPackage ../tools/inputmethods/m17n-lib/otf.nix {
    inherit (xorg) libXaw;
  };

  skktools = callPackage ../tools/inputmethods/skk/skktools { };
  skk-dicts = callPackage ../tools/inputmethods/skk/skk-dicts { };

  libkkc-data = callPackage ../data/misc/libkkc-data {
    inherit (pythonPackages) marisa;
  };

  libkkc = callPackage ../tools/inputmethods/libkkc { };

  ibus = callPackage ../tools/inputmethods/ibus { };

  ibus-qt = callPackage ../tools/inputmethods/ibus/ibus-qt.nix { };

  ibus-engines = recurseIntoAttrs {
    anthy = callPackage ../tools/inputmethods/ibus-engines/ibus-anthy { };

    hangul = callPackage ../tools/inputmethods/ibus-engines/ibus-hangul { };

    kkc = callPackage ../tools/inputmethods/ibus-engines/ibus-kkc { };

    libpinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-libpinyin { };

    m17n = callPackage ../tools/inputmethods/ibus-engines/ibus-m17n { };

    mozc = callPackage ../tools/inputmethods/ibus-engines/ibus-mozc {
      python = python2;
      inherit (python2Packages) gyp;
      protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
    };

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

  ibus-with-plugins = callPackage ../tools/inputmethods/ibus/wrapper.nix { };

  interception-tools = callPackage ../tools/inputmethods/interception-tools { };
  interception-tools-plugins = {
    caps2esc = callPackage ../tools/inputmethods/interception-tools/caps2esc.nix { };
  };

  age = callPackage ../tools/security/age { };

  brotli = callPackage ../tools/compression/brotli { };

  biosdevname = callPackage ../tools/networking/biosdevname { };

  c14 = callPackage ../applications/networking/c14 { };

  certstrap = callPackage ../tools/security/certstrap { };

  cfssl = callPackage ../tools/security/cfssl { };

  chafa = callPackage ../tools/misc/chafa { };

  checkbashisms = callPackage ../development/tools/misc/checkbashisms { };

  civetweb = callPackage ../development/libraries/civetweb { };

  ckb-next = libsForQt5.callPackage ../tools/misc/ckb-next { };

  clamav = callPackage ../tools/security/clamav { };

  clex = callPackage ../tools/misc/clex { };

  client-ip-echo = callPackage ../servers/misc/client-ip-echo { };

  cloc = callPackage ../tools/misc/cloc { };

  cloog = callPackage ../development/libraries/cloog {
    isl = isl_0_14;
  };

  cloog_0_18_0 = callPackage ../development/libraries/cloog/0.18.0.nix {
    isl = isl_0_11;
  };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  cloud-utils = callPackage ../tools/misc/cloud-utils { };

  cocoapods = callPackage ../development/mobile/cocoapods { };

  cocoapods-beta = lowPrio (callPackage ../development/mobile/cocoapods { beta = true; });

  codebraid = callPackage ../tools/misc/codebraid { };

  compass = callPackage ../development/tools/compass { };

  conda = callPackage ../tools/package-management/conda { };

  convmv = callPackage ../tools/misc/convmv { };

  convoy = callPackage ../tools/filesystems/convoy { };

  cpcfs = callPackage ../tools/filesystems/cpcfs { };

  cool-retro-term = libsForQt5.callPackage ../applications/misc/cool-retro-term { };

  coreutils = callPackage ../tools/misc/coreutils { };
  coreutils-full = coreutils.override { minimal = false; };
  coreutils-prefixed = coreutils.override { withPrefix = true; singleBinary = false; };

  corkscrew = callPackage ../tools/networking/corkscrew { };

  cowpatty = callPackage ../tools/security/cowpatty { };

  cpio = callPackage ../tools/archivers/cpio { };

  crackxls = callPackage ../tools/security/crackxls { };

  create-cycle-app = nodePackages.create-cycle-app;

  createrepo_c = callPackage ../tools/package-management/createrepo_c { };

  cromfs = callPackage ../tools/archivers/cromfs { };

  cron = callPackage ../tools/system/cron { };

  cudaPackages = recurseIntoAttrs (callPackage ../development/compilers/cudatoolkit {});
  inherit (cudaPackages)
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
    cudatoolkit_10_0
    cudatoolkit_10_1
    cudatoolkit_10_2;

  cudatoolkit = cudatoolkit_10;

  cudnnPackages = callPackages ../development/libraries/science/math/cudnn { };
  inherit (cudnnPackages)
    cudnn_cudatoolkit_7
    cudnn_cudatoolkit_7_5
    cudnn6_cudatoolkit_8
    cudnn_cudatoolkit_8
    cudnn_cudatoolkit_9
    cudnn_cudatoolkit_9_0
    cudnn_cudatoolkit_9_1
    cudnn_cudatoolkit_9_2
    cudnn_cudatoolkit_10
    cudnn_cudatoolkit_10_0
    cudnn_cudatoolkit_10_1
    cudnn_cudatoolkit_10_2;

  cudnn = cudnn_cudatoolkit_10;

  curlFull = curl.override {
    idnSupport = true;
    ldapSupport = true;
    gssSupport = true;
    brotliSupport = true;
  };

  curl = callPackage ../tools/networking/curl { };

  curl_unix_socket = callPackage ../tools/networking/curl-unix-socket { };

  curlie = callPackage ../tools/networking/curlie {
    # Version 1.2.0 fails to build with go 1.13 due to:
    #    verifying golang.org/x/crypto@v0.0.0-20180524125353-159ae71589f3: golang.org/x/crypto@v0.0.0-20180524125353-159ae71589f3: Get https://sum.golang.org/lookup/golang.org/x/crypto@v0.0.0-20180524125353-159ae71589f3: dial tcp: lookup sum.golang.org on [::1]:53: read udp [::1]:49088->[::1]:53: read: connection refused
    buildGoModule = buildGo112Module;
  };

  cunit = callPackage ../tools/misc/cunit { };
  bcunit = callPackage ../tools/misc/bcunit { };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  cutter = callPackage ../tools/networking/cutter { };

  cwebbin = callPackage ../development/tools/misc/cwebbin { };

  cvs_fast_export = callPackage ../applications/version-management/cvs-fast-export { };

  dadadodo = callPackage ../tools/text/dadadodo { };

  daemon = callPackage ../tools/system/daemon { };

  daemonize = callPackage ../tools/system/daemonize { };

  daq = callPackage ../applications/networking/ids/daq { };

  dar = callPackage ../tools/backup/dar { };

  darkhttpd = callPackage ../servers/http/darkhttpd { };

  darkstat = callPackage ../tools/networking/darkstat { };

  dav1d = callPackage ../development/libraries/dav1d { };

  davfs2 = callPackage ../tools/filesystems/davfs2 { };

  dbeaver = callPackage ../applications/misc/dbeaver {
    jdk = jdk11;
  };

  dbench = callPackage ../development/tools/misc/dbench { };

  dclxvi = callPackage ../development/libraries/dclxvi { };

  dcraw = callPackage ../tools/graphics/dcraw { };

  dcfldd = callPackage ../tools/system/dcfldd { };

  debianutils = callPackage ../tools/misc/debianutils { };

  debian-devscripts = callPackage ../tools/misc/debian-devscripts { };

  debootstrap = callPackage ../tools/misc/debootstrap { };

  deer = callPackage ../shells/zsh/zsh-deer { };

  detox = callPackage ../tools/misc/detox { };

  devilspie2 = callPackage ../applications/misc/devilspie2 {
    gtk = gtk3;
  };

  dex = callPackage ../tools/X11/dex { };

  ddccontrol = callPackage ../tools/misc/ddccontrol { };

  ddccontrol-db = callPackage ../data/misc/ddccontrol-db { };

  ddcutil = callPackage ../tools/misc/ddcutil { };

  ddclient = callPackage ../tools/networking/ddclient { };

  dd_rescue = callPackage ../tools/system/dd_rescue { };

  ddrescue = callPackage ../tools/system/ddrescue { };

  ddrescueview = callPackage ../tools/system/ddrescueview { };

  ddrutility = callPackage ../tools/system/ddrutility { };

  deluge = callPackage ../applications/networking/p2p/deluge {
    pythonPackages = python2Packages;
  };

  desktop-file-utils = callPackage ../tools/misc/desktop-file-utils { };

  dfc  = callPackage ../tools/system/dfc { };

  dev86 = callPackage ../development/compilers/dev86 { };

  diskrsync = callPackage ../tools/backup/diskrsync { };

  djbdns = callPackage ../tools/networking/djbdns { };

  dnscrypt-proxy2 = callPackage ../tools/networking/dnscrypt-proxy2 { };

  dnscrypt-wrapper = callPackage ../tools/networking/dnscrypt-wrapper { };

  dnscontrol = callPackage ../applications/networking/dnscontrol { };

  dnsenum = callPackage ../tools/security/dnsenum { };

  dnsmasq = callPackage ../tools/networking/dnsmasq { };

  dnsproxy = callPackage ../tools/networking/dnsproxy { };

  dnsperf = callPackage ../tools/networking/dnsperf { };

  dnsrecon = callPackage ../tools/security/dnsrecon { };

  dnstop = callPackage ../tools/networking/dnstop { };

  dhcp = callPackage ../tools/networking/dhcp { };

  dhcpdump = callPackage ../tools/networking/dhcpdump { };

  dhcpcd = callPackage ../tools/networking/dhcpcd { };

  dhcping = callPackage ../tools/networking/dhcping { };

  di = callPackage ../tools/system/di { };

  diction = callPackage ../tools/text/diction { };

  diffoscope = callPackage ../tools/misc/diffoscope {
    jdk = jdk8;
  };

  diffr = callPackage ../tools/text/diffr {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  diffstat = callPackage ../tools/text/diffstat { };

  diffutils = callPackage ../tools/text/diffutils { };

  dir2opus = callPackage ../tools/audio/dir2opus {
    inherit (pythonPackages) mutagen python wrapPython;
  };

  picotts = callPackage ../tools/audio/picotts { };

  wgetpaste = callPackage ../tools/text/wgetpaste { };

  dirmngr = callPackage ../tools/security/dirmngr { };

  dirvish  = callPackage ../tools/backup/dirvish { };

  disper = callPackage ../tools/misc/disper { };

  dleyna-connector-dbus = callPackage ../development/libraries/dleyna-connector-dbus { };

  dleyna-core = callPackage ../development/libraries/dleyna-core { };

  dleyna-renderer = callPackage ../development/libraries/dleyna-renderer { };

  dleyna-server = callPackage ../development/libraries/dleyna-server { };

  dmd = callPackage ../development/compilers/dmd { };

  dmg2img = callPackage ../tools/misc/dmg2img {
    openssl = openssl_1_0_2;
  };

  docbook2odf = callPackage ../tools/typesetting/docbook2odf { };

  doas = callPackage ../tools/security/doas { };

  docbook2x = callPackage ../tools/typesetting/docbook2x { };

  docbook2mdoc = callPackage ../tools/misc/docbook2mdoc { };

  docbookrx = callPackage ../tools/typesetting/docbookrx { };

  docear = callPackage ../applications/office/docear { };

  dockbarx = callPackage ../applications/misc/dockbarx { };

  dog = callPackage ../tools/system/dog { };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dolphinEmu = callPackage ../misc/emulators/dolphin-emu { };
  dolphinEmuMaster = qt5.callPackage ../misc/emulators/dolphin-emu/master.nix {
    inherit (darwin.apple_sdk.frameworks) CoreBluetooth ForceFeedback IOKit OpenGL;
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

  driftnet = callPackage ../tools/networking/driftnet {};

  drone = callPackage ../development/tools/continuous-integration/drone { };

  drone-cli = callPackage ../development/tools/continuous-integration/drone-cli { };

  dropbear = callPackage ../tools/networking/dropbear { };

  dsview = libsForQt5.callPackage ../applications/science/electronics/dsview { };

  dtach = callPackage ../tools/misc/dtach { };

  dtc = callPackage ../development/compilers/dtc { };

  dub = callPackage ../development/tools/build-managers/dub { };

  duc = callPackage ../tools/misc/duc { };

  duff = callPackage ../tools/filesystems/duff { };

  dumptorrent = callPackage ../tools/misc/dumptorrent { };

  duo-unix = callPackage ../tools/security/duo-unix { };

  duplicacy = callPackage ../tools/backup/duplicacy { };

  duplicati = callPackage ../tools/backup/duplicati { };

  duplicity = callPackage ../tools/backup/duplicity {
    pythonPackages = python3Packages;
  };

  duply = callPackage ../tools/backup/duply { };

  dvd-vr = callPackage ../tools/cd-dvd/dvd-vr { };

  dvdisaster = callPackage ../tools/cd-dvd/dvdisaster { };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvgrab = callPackage ../tools/video/dvgrab { };

  dvtm = callPackage ../tools/misc/dvtm {
    # if you prefer a custom config, write the config.h in dvtm.config.h
    # and enable
    # customConfig = builtins.readFile ./dvtm.config.h;
  };

  dvtm-unstable = callPackage ../tools/misc/dvtm/unstable.nix {};

  ecmtools = callPackage ../tools/cd-dvd/ecm-tools { };

  e2tools = callPackage ../tools/filesystems/e2tools { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  easyrsa = callPackage ../tools/networking/easyrsa { };

  easyrsa2 = callPackage ../tools/networking/easyrsa/2.x.nix { };

  easysnap = callPackage ../tools/backup/easysnap { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  ecryptfs-helper = callPackage ../tools/security/ecryptfs/helper.nix { };

  edid-decode = callPackage ../tools/misc/edid-decode { };

  edid-generator = callPackage ../tools/misc/edid-generator { };

  editres = callPackage ../tools/graphics/editres { };

  edit = callPackage ../applications/editors/edit { };

  edk2 = callPackage ../development/compilers/edk2 { };

  eff = callPackage ../development/interpreters/eff { };

  eflite = callPackage ../applications/audio/eflite {};

  eid-mw = callPackage ../tools/security/eid-mw { };

  epubcheck = callPackage ../tools/text/epubcheck { };

  luckybackup = libsForQt5.callPackage ../tools/backup/luckybackup {
    ssh = openssh;
  };

  kramdown-asciidoc = callPackage ../tools/typesetting/kramdown-asciidoc { };

  mcrcon = callPackage ../tools/networking/mcrcon {};

  rage = callPackage ../tools/security/rage {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rar2fs = callPackage ../tools/filesystems/rar2fs { };

  s-tar = callPackage ../tools/archivers/s-tar {};

  sonota = callPackage ../tools/misc/sonota { };

  sonobuoy = callPackage ../applications/networking/cluster/sonobuoy { };

  strawberry = libsForQt5.callPackage ../applications/audio/strawberry { };

  tealdeer = callPackage ../tools/misc/tealdeer {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  teamocil = callPackage ../tools/misc/teamocil { };

  tsm-client = callPackage ../tools/backup/tsm-client { jdk8 = null; };
  tsm-client-withGui = callPackage ../tools/backup/tsm-client { };

  trac = pythonPackages.callPackage ../tools/misc/trac { };

  tracker = callPackage ../development/libraries/tracker { };

  tracker-miners = callPackage ../development/libraries/tracker-miners { };

  tridactyl-native = callPackage ../tools/networking/tridactyl-native { };

  trompeloeil = callPackage ../development/libraries/trompeloeil { };

  uudeview = callPackage ../tools/misc/uudeview { };

  uutils-coreutils = callPackage ../tools/misc/uutils-coreutils {
    inherit (pythonPackages) sphinx;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  volctl = callPackage ../tools/audio/volctl { };

  vorta = python3Packages.callPackage ../applications/backup/vorta { };

  wallutils = callPackage ../tools/graphics/wallutils { };

  wev = callPackage ../tools/misc/wev { };

  wl-clipboard = callPackage ../tools/misc/wl-clipboard { };

  wob = callPackage ../tools/misc/wob { };

  xob = callPackage ../tools/X11/xob { };

  z-lua = callPackage ../tools/misc/z-lua { };

  zabbix-cli = callPackage ../tools/misc/zabbix-cli { };

  zabbixctl = callPackage ../tools/misc/zabbixctl { };

  zeek = callPackage ../applications/networking/ids/zeek { };

  zoxide = callPackage ../tools/misc/zoxide { };

  zzuf = callPackage ../tools/security/zzuf { };

  ### DEVELOPMENT / EMSCRIPTEN

  buildEmscriptenPackage = callPackage ../development/em-modules/generic { };

  carp = callPackage ../development/compilers/carp { };

  cholmod-extra = callPackage ../development/libraries/science/math/cholmod-extra { };

  emscriptenVersion = "1.39.1";

  emscripten = callPackage ../development/compilers/emscripten { };

  emscriptenfastcompPackages = dontRecurseIntoAttrs (callPackage ../development/compilers/emscripten/fastcomp { });

  emscriptenfastcomp = emscriptenfastcompPackages.emscriptenfastcomp;

  emscriptenPackages = recurseIntoAttrs (callPackage ./emscripten-packages.nix { });

  emscriptenStdenv = stdenv // { mkDerivation = buildEmscriptenPackage; };

  efibootmgr = callPackage ../tools/system/efibootmgr { };

  efivar = callPackage ../tools/system/efivar { };

  evemu = callPackage ../tools/system/evemu { };

  # The latest version used by elasticsearch, logstash, kibana and the the beats from elastic.
  # When updating make sure to update all plugins or they will break!
  elk6Version = "6.8.3";
  elk7Version = "7.5.1";

  elasticsearch6 = callPackage ../servers/search/elasticsearch/6.x.nix {
    utillinux = utillinuxMinimal;
  };
  elasticsearch6-oss = callPackage ../servers/search/elasticsearch/6.x.nix {
    enableUnfree = false;
    utillinux = utillinuxMinimal;
  };
  elasticsearch7 = callPackage ../servers/search/elasticsearch/7.x.nix {
    utillinux = utillinuxMinimal;
  };
  elasticsearch7-oss = callPackage ../servers/search/elasticsearch/7.x.nix {
    enableUnfree = false;
    utillinux = utillinuxMinimal;
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
    elasticsearch = elasticsearch7-oss;
  };

  elasticsearch-curator = callPackage ../tools/admin/elasticsearch-curator {
    python = python3;
  };

  embree2 = callPackage ../development/libraries/embree/2.x.nix { };

  emem = callPackage ../applications/misc/emem { };

  emv = callPackage ../tools/misc/emv { };

  enblend-enfuse = callPackage ../tools/graphics/enblend-enfuse { };

  endlessh = callPackage ../servers/endlessh { };

  cryfs = callPackage ../tools/filesystems/cryfs { };

  encfs = callPackage ../tools/filesystems/encfs {
    tinyxml2 = tinyxml-2;
  };

  enscript = callPackage ../tools/text/enscript { };

  ensemble-chorus = callPackage ../applications/audio/ensemble-chorus { stdenv = gcc8Stdenv; };

  entr = callPackage ../tools/misc/entr { };

  eot_utilities = callPackage ../tools/misc/eot-utilities { };

  eplot = callPackage ../tools/graphics/eplot { };

  epstool = callPackage ../tools/graphics/epstool { };

  epsxe = callPackage ../misc/emulators/epsxe { };

  escrotum = callPackage ../tools/graphics/escrotum {
    inherit (pythonPackages) buildPythonApplication pygtk numpy;
  };

  etcher = callPackage ../tools/misc/etcher { };

  ethtool = callPackage ../tools/misc/ethtool { };

  ettercap = callPackage ../applications/networking/sniffers/ettercap { };

  euca2ools = callPackage ../tools/virtualization/euca2ools { };

  eventstat = callPackage ../os-specific/linux/eventstat { };

  evtest = callPackage ../applications/misc/evtest { };

  evtest-qt = libsForQt5.callPackage ../applications/misc/evtest-qt { };

  eva = callPackage ../tools/misc/eva { };

  exa = callPackage ../tools/misc/exa { };

  exempi = callPackage ../development/libraries/exempi {
    stdenv = if stdenv.isi686 then gcc6Stdenv else stdenv;
  };

  execline = skawarePackages.execline;

  executor = with python3Packages; toPythonApplication executor;

  exif = callPackage ../tools/graphics/exif { };

  exiftags = callPackage ../tools/graphics/exiftags { };

  exiftool = perlPackages.ImageExifTool;

  ext4magic = callPackage ../tools/filesystems/ext4magic { };

  extract_url = callPackage ../applications/misc/extract_url { };

  extundelete = callPackage ../tools/filesystems/extundelete { };

  expect = callPackage ../tools/misc/expect { };

  f2fs-tools = callPackage ../tools/filesystems/f2fs-tools { };

  Fabric = python2Packages.Fabric;

  fail2ban = callPackage ../tools/security/fail2ban { };

  fakeroot = callPackage ../tools/system/fakeroot { };

  fakeroute = callPackage ../tools/networking/fakeroute { };

  fakechroot = callPackage ../tools/system/fakechroot { };

  fastpbkdf2 = callPackage ../development/libraries/fastpbkdf2 { };

  fanficfare = callPackage ../tools/text/fanficfare { };

  fastd = callPackage ../tools/networking/fastd { };

  fatsort = callPackage ../tools/filesystems/fatsort { };

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
      protobuf = pkgs.protobuf.overrideDerivation (oldAttrs: { stdenv = clangStdenv; });
    };

    table-extra = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-extra { };

    table-other = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-other { };

    cloudpinyin = callPackage ../tools/inputmethods/fcitx-engines/fcitx-cloudpinyin { };

    libpinyin = libsForQt5.callPackage ../tools/inputmethods/fcitx-engines/fcitx-libpinyin { };

    skk = callPackage ../tools/inputmethods/fcitx-engines/fcitx-skk { };
  };

  fcitx-configtool = callPackage ../tools/inputmethods/fcitx/fcitx-configtool.nix { };

  fcppt = callPackage ../development/libraries/fcppt { };

  fcrackzip = callPackage ../tools/security/fcrackzip { };

  fcron = callPackage ../tools/system/fcron { };

  fdm = callPackage ../tools/networking/fdm {};

  featherpad = callPackage ../applications/editors/featherpad {};

  feedreader = callPackage ../applications/networking/feedreaders/feedreader {};

  ferm = callPackage ../tools/networking/ferm { };

  ffsend = callPackage ../tools/misc/ffsend { };

  fgallery = callPackage ../tools/graphics/fgallery { };

  flannel = callPackage ../tools/networking/flannel { };

  flare = callPackage ../games/flare {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  flashbench = callPackage ../os-specific/linux/flashbench { };

  flatpak = callPackage ../development/libraries/flatpak { };

  flatpak-builder = callPackage ../development/tools/flatpak-builder { };

  fltrdr = callPackage ../tools/misc/fltrdr {
    icu = icu63;
  };

  fluent-bit = callPackage ../tools/misc/fluent-bit {
    stdenv = gccStdenv;
  };

  fluidasserts = with python37Packages; toPythonApplication fluidasserts;

  flux = callPackage ../development/compilers/flux { };

  fido2luks = callPackage ../tools/security/fido2luks {};

  fierce = callPackage ../tools/security/fierce { };

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file {
    inherit (windows) libgnurx;
  };

  filegive = callPackage ../tools/networking/filegive { };

  fileschanged = callPackage ../tools/misc/fileschanged { };

  filet = callPackage ../applications/misc/filet { };

  findomain = callPackage ../tools/networking/findomain {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  iprange = callPackage ../applications/networking/firehol/iprange.nix {};

  firehol = callPackage ../applications/networking/firehol {};

  fio = callPackage ../tools/system/fio { };

  firebird-emu = libsForQt5.callPackage ../misc/emulators/firebird-emu { };

  flamerobin = callPackage ../applications/misc/flamerobin { };

  flashtool = pkgsi686Linux.callPackage ../development/mobile/flashtool {
    inherit (androidenv.androidPkgs_9_0) platform-tools;
  };

  flashrom = callPackage ../tools/misc/flashrom { };

  flent = python3Packages.callPackage ../applications/networking/flent { };

  flpsed = callPackage ../applications/editors/flpsed { };

  fluentd = callPackage ../tools/misc/fluentd { };

  flvstreamer = callPackage ../tools/networking/flvstreamer { };

  hmetis = pkgsi686Linux.callPackage ../applications/science/math/hmetis { };

  libbsd = callPackage ../development/libraries/libbsd { };

  libbladeRF = callPackage ../development/libraries/libbladeRF { };

  lp_solve = callPackage ../applications/science/math/lp_solve { };

  lprof = callPackage ../tools/graphics/lprof { };

  fastlane = callPackage ../tools/admin/fastlane { };

  fatresize = callPackage ../tools/filesystems/fatresize {};

  fdk_aac = callPackage ../development/libraries/fdk-aac { };

  feedgnuplot = callPackage ../tools/graphics/feedgnuplot { };

  fbv = callPackage ../tools/graphics/fbv { };

  fbvnc = callPackage ../tools/admin/fbvnc {};

  fim = callPackage ../tools/graphics/fim { };

  flac123 = callPackage ../applications/audio/flac123 { };

  flamegraph = callPackage ../development/tools/flamegraph { };

  flvtool2 = callPackage ../tools/video/flvtool2 { };

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
    gtk2 = gtk2-x11;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  fontforge-fonttools = callPackage ../tools/misc/fontforge/fontforge-fonttools.nix {};

  fontmatrix = callPackage ../applications/graphics/fontmatrix {};

  foremost = callPackage ../tools/system/foremost { };

  forktty = callPackage ../os-specific/linux/forktty {};

  fortune = callPackage ../tools/misc/fortune { };

  fox = callPackage ../development/libraries/fox {
    libpng = libpng12;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fpart = callPackage ../tools/misc/fpart { };

  fping = callPackage ../tools/networking/fping {};

  fpm = callPackage ../tools/package-management/fpm { };

  fprot = callPackage ../tools/security/fprot { };

  fprintd = callPackage ../tools/security/fprintd { };
  fprintd-thinkpad = fprintd.override {
    thinkpad = true;
  };

  franz = callPackage ../applications/networking/instant-messengers/franz { };

  freedroidrpg = callPackage ../games/freedroidrpg { };

  freebind = callPackage ../tools/networking/freebind { };

  freeipmi = callPackage ../tools/system/freeipmi {};

  freetalk = callPackage ../applications/networking/instant-messengers/freetalk {
    guile = guile_2_0;
  };

  freetds = callPackage ../development/libraries/freetds { };

  frescobaldi = python3Packages.callPackage ../misc/frescobaldi {};

  frostwire = callPackage ../applications/networking/p2p/frostwire { };
  frostwire-bin = callPackage ../applications/networking/p2p/frostwire/frostwire-bin.nix { };

  ftgl = callPackage ../development/libraries/ftgl {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  ftop = callPackage ../os-specific/linux/ftop { };

  fsarchiver = callPackage ../tools/archivers/fsarchiver { };

  fsfs = callPackage ../tools/filesystems/fsfs { };

  fstl = qt5.callPackage ../applications/graphics/fstl { };

  fswebcam = callPackage ../os-specific/linux/fswebcam { };

  fuseiso = callPackage ../tools/filesystems/fuseiso { };

  fusuma = callPackage ../tools/inputmethods/fusuma {};

  fdbPackages = dontRecurseIntoAttrs (callPackage ../servers/foundationdb { });

  inherit (fdbPackages)
    foundationdb51
    foundationdb52
    foundationdb60
    foundationdb61
  ;

  foundationdb = foundationdb61;

  fuse-7z-ng = callPackage ../tools/filesystems/fuse-7z-ng { };

  fuse-overlayfs = callPackage ../tools/filesystems/fuse-overlayfs {};

  fusee-interfacee-tk = callPackage ../applications/misc/fusee-interfacee-tk { };

  fusee-launcher = callPackage ../development/tools/fusee-launcher { };

  fwknop = callPackage ../tools/security/fwknop { };

  exfat = callPackage ../tools/filesystems/exfat { };

  dos2unix = callPackage ../tools/text/dos2unix { };

  uni2ascii = callPackage ../tools/text/uni2ascii { };

  galculator = callPackage ../applications/misc/galculator {
    gtk = gtk3;
  };

  galen = callPackage ../development/tools/galen {};

  gallery-dl = callPackage ../applications/misc/gallery-dl { };

  gandi-cli = callPackage ../tools/networking/gandi-cli { };

  gandom-fonts = callPackage ../data/fonts/gandom-fonts { };

  garmin-plugin = callPackage ../applications/misc/garmin-plugin {};

  garmintools = callPackage ../development/libraries/garmintools {};

  gauge = callPackage ../development/tools/gauge { };

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

  gawk-with-extensions = callPackage ../tools/text/gawk/gawk-with-extensions.nix {
    extensions = gawkextlib.full;
  };
  gawkextlib = callPackage ../tools/text/gawk/gawkextlib.nix {};

  gawkInteractive = appendToName "interactive"
    (gawk.override { interactive = true; });

  gawp = callPackage ../tools/misc/gawp { };

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

  gdmap = callPackage ../tools/system/gdmap { };

  gelasio = callPackage ../data/fonts/gelasio { };

  gen-oath-safe = callPackage ../tools/security/gen-oath-safe { };

  genext2fs = callPackage ../tools/filesystems/genext2fs { };

  gengetopt = callPackage ../development/tools/misc/gengetopt { };

  genimage = callPackage ../tools/filesystems/genimage { };

  gerrit = callPackage ../applications/version-management/gerrit { };

  geteltorito = callPackage ../tools/misc/geteltorito { };

  getmail = callPackage ../tools/networking/getmail { };

  getopt = callPackage ../tools/misc/getopt { };

  gexiv2 = callPackage ../development/libraries/gexiv2 { };

  gftp = callPackage ../tools/networking/gftp { };

  gfbgraph = callPackage ../development/libraries/gfbgraph { };

  ggobi = callPackage ../tools/graphics/ggobi { };

  gibo = callPackage ../tools/misc/gibo { };

  gifsicle = callPackage ../tools/graphics/gifsicle { };

  gifski = callPackage ../tools/graphics/gifski { };

  git-backup = callPackage ../applications/version-management/git-backup {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-big-picture = callPackage ../applications/version-management/git-and-tools/git-big-picture { };

  git-crecord = callPackage ../applications/version-management/git-crecord { };

  git-lfs = lowPrio (callPackage ../applications/version-management/git-lfs {
    # Version 2.8.0 fails with go1.13
    #    go: github.com/alexbrainman/sspi@v0.0.0-20180125232955-4729b3d4d858: Get https://proxy.golang.org/github.com/alexbrainman/sspi/@v/v0.0.0-20180125232955-4729b3d4d858.mod: dial tcp: lookup proxy.golang.org on [::1]:53: read udp [::1]:32932->[::1]:53: read: connection refused
    buildGoPackage = buildGo112Package;
  });

  git-lfs1 = callPackage ../applications/version-management/git-lfs/1.nix { };

  git-ftp = callPackage ../development/tools/git-ftp { };

  git-series = callPackage ../development/tools/git-series { };

  git-sizer = callPackage ../applications/version-management/git-sizer { };

  git-up = callPackage ../applications/version-management/git-up {
    pythonPackages = python3Packages;
  };

  gitfs = callPackage ../tools/filesystems/gitfs { };

  gitinspector = callPackage ../applications/version-management/gitinspector { };

  gitkraken = callPackage ../applications/version-management/gitkraken { };

  gitlab = callPackage ../applications/version-management/gitlab { };
  gitlab-ee = callPackage ../applications/version-management/gitlab { gitlabEnterprise = true; };

  gitlab-runner = callPackage ../development/tools/continuous-integration/gitlab-runner { };

  gitlab-shell = callPackage ../applications/version-management/gitlab/gitlab-shell { };

  gitlab-workhorse = callPackage ../applications/version-management/gitlab/gitlab-workhorse { };

  gitaly = callPackage ../applications/version-management/gitlab/gitaly { };

  gitstats = callPackage ../applications/version-management/gitstats { };

  gogs = callPackage ../applications/version-management/gogs { };

  git-latexdiff = callPackage ../tools/typesetting/git-latexdiff { };

  gitea = callPackage ../applications/version-management/gitea { };

  gl2ps = callPackage ../development/libraries/gl2ps { };

  glusterfs = callPackage ../tools/filesystems/glusterfs { };

  glmark2 = callPackage ../tools/graphics/glmark2 { };

  glogg = libsForQt5.callPackage ../tools/text/glogg { };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gmrender-resurrect = callPackage ../tools/networking/gmrender-resurrect {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav;
  };

  gmvault = callPackage ../tools/networking/gmvault { };

  gnash = callPackage ../misc/gnash { };

  gnirehtet = callPackage ../tools/networking/gnirehtet { };

  gnome-builder = callPackage ../applications/editors/gnome-builder { };

  gnome-keysign = callPackage ../tools/security/gnome-keysign { };

  gnome-podcasts = callPackage ../applications/audio/gnome-podcasts { };

  gnome-photos = callPackage ../applications/graphics/gnome-photos {
    gegl = gegl_0_4;
  };

  gnokii = callPackage ../tools/misc/gnokii { };

  gnuapl = callPackage ../development/interpreters/gnu-apl { };

  gnu-cobol = callPackage ../development/compilers/gnu-cobol { };

  gnuclad = callPackage ../applications/graphics/gnuclad { };

  gnufdisk = callPackage ../tools/system/fdisk {
    guile = guile_1_8;
  };

  gnugrep = callPackage ../tools/text/gnugrep { };

  gnulib = callPackage ../development/tools/gnulib { };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1orig = callPackage ../tools/security/gnupg/1.nix { };
  gnupg1compat = callPackage ../tools/security/gnupg/1compat.nix { };
  gnupg1 = gnupg1compat;    # use config.packageOverrides if you prefer original gnupg1
  gnupg20 = callPackage ../tools/security/gnupg/20.nix {
    guiSupport = stdenv.isDarwin;
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry-gtk2;
  };
  gnupg22 = callPackage ../tools/security/gnupg/22.nix {
    guiSupport = stdenv.isDarwin;
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry-gtk2;
  };
  gnupg = gnupg22;

  gnupg-pkcs11-scd = callPackage ../tools/security/gnupg-pkcs11-scd { };

  gnuplot = libsForQt5.callPackage ../tools/graphics/gnuplot { };

  gnuplot_qt = gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };

  gnu-pw-mgr = callPackage ../tools/security/gnu-pw-mgr { };

  gnused = if !stdenv.hostPlatform.isWindows then
             callPackage ../tools/text/gnused { } # broken on Windows
           else
             gnused_422;
  # This is an easy work-around for [:space:] problems.
  gnused_422 = callPackage ../tools/text/gnused/422.nix { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

  goaccess = callPackage ../tools/misc/goaccess { };

  gocryptfs = callPackage ../tools/filesystems/gocryptfs { };

  godot = callPackage ../development/tools/godot {};

  goklp = callPackage ../tools/networking/goklp {};

  go-mtpfs = callPackage ../tools/filesystems/go-mtpfs { };

  go-sct = callPackage ../tools/X11/go-sct { };

  # rename to upower-notify?
  go-upower-notify = callPackage ../tools/misc/upower-notify { };

  google-app-engine-go-sdk = callPackage ../development/tools/google-app-engine-go-sdk { };

  google-authenticator = callPackage ../os-specific/linux/google-authenticator { };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk { };
  google-cloud-sdk-gce = google-cloud-sdk.override { with-gce = true; };

  google-fonts = callPackage ../data/fonts/google-fonts { };

  google-clasp = callPackage ../development/misc/google-clasp { };

  google-compute-engine = python2.pkgs.google-compute-engine;

  google-compute-engine-oslogin = callPackage ../tools/virtualization/google-compute-engine-oslogin { };

  google-music-scripts = callPackage ../tools/audio/google-music-scripts { };

  google-cloud-cpp = callPackage ../development/libraries/google-cloud-cpp { };

  gopro = callPackage ../tools/video/gopro { };

  gource = callPackage ../applications/version-management/gource { };

  govc = callPackage ../tools/virtualization/govc { };

  gpart = callPackage ../tools/filesystems/gpart { };

  gparted = callPackage ../tools/misc/gparted { };

  ldmtool = callPackage ../tools/misc/ldmtool { };

  gpodder = callPackage ../applications/audio/gpodder { };

  gpp = callPackage ../development/tools/gpp { };

  gpredict = callPackage ../applications/science/astronomy/gpredict { };

  gptfdisk = callPackage ../tools/system/gptfdisk { };

  grafx2 = callPackage ../applications/graphics/grafx2 {};

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
  graphviz_2_32 = (callPackage ../tools/graphics/graphviz/2.32.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  }).overrideAttrs(x: { configureFlags = x.configureFlags ++ ["--with-cgraph=no"];});

  grin = callPackage ../tools/text/grin { };

  ripgrep = callPackage ../tools/text/ripgrep {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ripgrep-all = callPackage ../tools/text/ripgrep-all {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  grive2 = callPackage ../tools/filesystems/grive2 { };

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

  gron = callPackage ../development/tools/gron { };

  groonga = callPackage ../servers/search/groonga { };

  grpcurl = callPackage ../tools/networking/grpcurl { };

  grpcui = callPackage ../tools/networking/grpcui {
    buildGoModule = buildGo112Module;
  };

  grub = pkgsi686Linux.callPackage ../tools/misc/grub ({
    stdenv = overrideCC stdenv buildPackages.pkgsi686Linux.gcc6;
  } // (config.grub or {}));

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

  gx = callPackage ../tools/package-management/gx { };
  gx-go = callPackage ../tools/package-management/gx/go { };

  efitools = callPackage ../tools/security/efitools { };

  sbsigntool = callPackage ../tools/security/sbsigntool { };

  gsmartcontrol = callPackage ../tools/misc/gsmartcontrol { };

  gsmlib = callPackage ../development/libraries/gsmlib { };

  gssdp = callPackage ../development/libraries/gssdp { };

  gt5 = callPackage ../tools/system/gt5 { };

  gtest = callPackage ../development/libraries/gtest { };
  gmock = gtest; # TODO: move to aliases.nix

  gbenchmark = callPackage ../development/libraries/gbenchmark {};

  gtkdatabox = callPackage ../development/libraries/gtkdatabox {};

  gtklick = callPackage ../applications/audio/gtklick {};

  gtdialog = callPackage ../development/libraries/gtdialog {};

  gtkd = callPackage ../development/libraries/gtkd { };

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gtkperf = callPackage ../development/tools/misc/gtkperf { };

  gtk-vnc = callPackage ../tools/admin/gtk-vnc {};

  gtmess = callPackage ../applications/networking/instant-messengers/gtmess {
    openssl = openssl_1_0_2;
  };

  gup = callPackage ../development/tools/build-managers/gup {};

  gupnp = callPackage ../development/libraries/gupnp { };

  gupnp-av = callPackage ../development/libraries/gupnp-av {};

  gupnp-dlna = callPackage ../development/libraries/gupnp-dlna {};

  gupnp-igd = callPackage ../development/libraries/gupnp-igd {};

  gupnp-tools = callPackage ../tools/networking/gupnp-tools {};

  gvpe = callPackage ../tools/networking/gvpe {
    openssl = openssl_1_0_2;
  };

  gvolicon = callPackage ../tools/audio/gvolicon {};

  gzip = callPackage ../tools/compression/gzip { };

  gzrt = callPackage ../tools/compression/gzrt { };

  httplab = callPackage ../tools/networking/httplab { };

  partclone = callPackage ../tools/backup/partclone { };

  partimage = callPackage ../tools/backup/partimage { };

  pgf_graphics = callPackage ../tools/graphics/pgf { };

  pgformatter = callPackage ../development/tools/pgformatter { };

  pgloader = callPackage ../development/tools/pgloader { };

  pigz = callPackage ../tools/compression/pigz { };

  pixz = callPackage ../tools/compression/pixz { };

  plplot = callPackage ../development/libraries/plplot { };

  pxattr = callPackage ../tools/archivers/pxattr { };

  pxz = callPackage ../tools/compression/pxz { };

  hans = callPackage ../tools/networking/hans { };

  h2 = callPackage ../servers/h2 { };

  h5utils = callPackage ../tools/misc/h5utils {
    libmatheval = null;
    hdf4 = null;
  };

  haproxy = callPackage ../tools/networking/haproxy {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  hackertyper = callPackage ../tools/misc/hackertyper { };

  haveged = callPackage ../tools/security/haveged { };

  habitat = callPackage ../applications/networking/cluster/habitat { };

  hardlink = callPackage ../tools/system/hardlink { };

  hashcash = callPackage ../tools/security/hashcash { };

  hashcat = callPackage ../tools/security/hashcat { };

  hashcat-utils = callPackage ../tools/security/hashcat-utils { };

  hash_extender = callPackage ../tools/security/hash_extender { };

  hash-slinger = callPackage ../tools/security/hash-slinger { };

  hasmail = callPackage ../applications/networking/mailreaders/hasmail { };

  hal-flash = callPackage ../os-specific/linux/hal-flash { };

  half = callPackage ../development/libraries/half { };

  halibut = callPackage ../tools/typesetting/halibut { };

  halide = callPackage ../development/compilers/halide { };

  ham = pkgs.perlPackages.ham;

  hardinfo = callPackage ../tools/system/hardinfo { };

  hcxtools = callPackage ../tools/security/hcxtools { };

  hdapsd = callPackage ../os-specific/linux/hdapsd { };

  hdaps-gl = callPackage ../tools/misc/hdaps-gl { };

  hddtemp = callPackage ../tools/misc/hddtemp { };

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

  hecate = callPackage ../applications/editors/hecate { };

  heaptrack = libsForQt5.callPackage ../development/tools/profiling/heaptrack {};

  heimdall = libsForQt5.callPackage ../tools/misc/heimdall { };

  heimdall-gui = heimdall.override { enableGUI = true; };

  helio-workstation = callPackage ../applications/audio/helio-workstation { };

  hevea = callPackage ../tools/typesetting/hevea { };

  hexd = callPackage ../tools/misc/hexd { };
  pixd = callPackage ../tools/misc/pixd { };

  hey = callPackage ../tools/networking/hey { };

  hhpc = callPackage ../tools/misc/hhpc { };

  hiera-eyaml = callPackage ../tools/system/hiera-eyaml { };

  hivemind = callPackage ../applications/misc/hivemind { };

  hfsprogs = callPackage ../tools/filesystems/hfsprogs { };

  highlight = callPackage ../tools/text/highlight ({
    lua = lua5;
  });

  holochain-go = callPackage ../servers/holochain-go { };

  homesick = callPackage ../tools/misc/homesick { };

  honcho = callPackage ../tools/system/honcho { };

  horst = callPackage ../tools/networking/horst { };

  host = bind.host;

  hotpatch = callPackage ../development/libraries/hotpatch { };

  hotspot = libsForQt5.callPackage ../development/tools/analysis/hotspot { };

  hping = callPackage ../tools/networking/hping { };

  html-proofer = callPackage ../tools/misc/html-proofer { };

  htpdate = callPackage ../tools/networking/htpdate { };

  http-prompt = callPackage ../tools/networking/http-prompt { };

  http-getter = callPackage ../applications/networking/flent/http-getter.nix { };

  httpie = callPackage ../tools/networking/httpie { };

  httping = callPackage ../tools/networking/httping {};

  httplz = callPackage ../tools/networking/httplz { };

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  httpstat = callPackage ../tools/networking/httpstat { };

  httptunnel = callPackage ../tools/networking/httptunnel { };

  hubicfuse = callPackage ../tools/filesystems/hubicfuse { };

  humanfriendly = with python3Packages; toPythonApplication humanfriendly;

  hwinfo = callPackage ../tools/system/hwinfo { };

  hybridreverb2 = callPackage ../applications/audio/hybridreverb2 {
    stdenv = gcc8Stdenv;
  };

  hylafaxplus = callPackage ../servers/hylafaxplus { };

  hyphen = callPackage ../development/libraries/hyphen { };

  i2c-tools = callPackage ../os-specific/linux/i2c-tools { };

  i2p = callPackage ../tools/networking/i2p {};

  i2pd = callPackage ../tools/networking/i2pd { };

  i-score = libsForQt5.callPackage ../applications/audio/i-score { };

  iasl = callPackage ../development/compilers/iasl { };

  iannix = libsForQt5.callPackage ../applications/audio/iannix { };

  ibm-sw-tpm2 = callPackage ../tools/security/ibm-sw-tpm2 { };

  ibniz = callPackage ../tools/graphics/ibniz { };

  icecast = callPackage ../servers/icecast { };

  icepeak = haskell.lib.justStaticExecutables haskellPackages.icepeak;

  iceshelf = callPackage ../tools/backup/iceshelf { };

  darkice = callPackage ../tools/audio/darkice { };

  deco = callPackage ../applications/misc/deco { };

  icoutils = callPackage ../tools/graphics/icoutils { };

  idutils = callPackage ../tools/misc/idutils { };

  idle3tools = callPackage ../tools/system/idle3tools { };

  iftop = callPackage ../tools/networking/iftop { };

  ifuse = callPackage ../tools/filesystems/ifuse { };
  ideviceinstaller = callPackage ../tools/misc/ideviceinstaller { };
  idevicerestore = callPackage ../tools/misc/idevicerestore { };

  inherit (callPackages ../tools/filesystems/irods rec {
            stdenv = llvmPackages.libcxxStdenv;
            libcxx = llvmPackages.libcxx;
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

  imapproxy = callPackage ../tools/networking/imapproxy {
    openssl = openssl_1_0_2;
  };

  imapsync = callPackage ../tools/networking/imapsync { };

  imgur-screenshot = callPackage ../tools/graphics/imgur-screenshot { };

  imgurbash2 = callPackage ../tools/graphics/imgurbash2 { };

  inadyn = callPackage ../tools/networking/inadyn { };

  inboxer = callPackage ../applications/networking/mailreaders/inboxer { };

  incron = callPackage ../tools/system/incron { };

  inetutils = callPackage ../tools/networking/inetutils { };

  inform7 = callPackage ../development/compilers/inform7 { };

  infamousPlugins = callPackage ../applications/audio/infamousPlugins { };

  innoextract = callPackage ../tools/archivers/innoextract { };

  input-utils = callPackage ../os-specific/linux/input-utils { };

  intecture-agent = callPackage ../tools/admin/intecture/agent.nix { };

  intecture-auth = callPackage ../tools/admin/intecture/auth.nix { };

  intecture-cli = callPackage ../tools/admin/intecture/cli.nix {
    openssl = openssl_1_0_2;
  };

  intel-media-sdk = callPackage ../development/libraries/intel-media-sdk { };

  invoice2data  = callPackage ../tools/text/invoice2data  { };

  inxi = callPackage ../tools/system/inxi { };

  iodine = callPackage ../tools/networking/iodine { };

  ioping = callPackage ../tools/system/ioping { };

  iops = callPackage ../tools/system/iops { };

  ior = callPackage ../tools/system/ior { };

  iouyap = callPackage ../tools/networking/iouyap { };

  ip2location = callPackage ../tools/networking/ip2location { };

  ip2unix = callPackage ../tools/networking/ip2unix { };

  ipad_charge = callPackage ../tools/misc/ipad_charge { };

  iperf2 = callPackage ../tools/networking/iperf/2.nix { };
  iperf3 = callPackage ../tools/networking/iperf/3.nix { };
  iperf = iperf3;

  ipfs = callPackage ../applications/networking/ipfs {
    # Version 0.4.22 fails to build with go 1.13 due to version validation:
    #    go: github.com/go-critic/go-critic@v0.0.0-20181204210945-ee9bf5809ead: invalid pseudo-version: does not match version-control timestamp (2019-02-10T22:04:43Z)
    # This is fixed in master, but release containing the fix does not exist yet.
    buildGoModule = buildGo112Module;
  };
  ipfs-migrator = callPackage ../applications/networking/ipfs-migrator { };
  ipfs-cluster = callPackage ../applications/networking/ipfs-cluster { };

  ipget = callPackage ../applications/networking/ipget { };

  ipmitool = callPackage ../tools/system/ipmitool {};

  ipmiutil = callPackage ../tools/system/ipmiutil {};

  ipmicfg = callPackage ../applications/misc/ipmicfg {};

  ipmiview = callPackage ../applications/misc/ipmiview {};

  ipcalc = callPackage ../tools/networking/ipcalc {};

  netmask = callPackage ../tools/networking/netmask {};

  netifd = callPackage ../tools/networking/netifd {};

  ipscan = callPackage ../tools/security/ipscan { };

  ipv6calc = callPackage ../tools/networking/ipv6calc {};

  ipxe = callPackage ../tools/misc/ipxe { };

  irker = callPackage ../servers/irker { };

  ised = callPackage ../tools/misc/ised {};

  isl = isl_0_20;
  isl_0_11 = callPackage ../development/libraries/isl/0.11.1.nix { };
  isl_0_14 = callPackage ../development/libraries/isl/0.14.1.nix { };
  isl_0_17 = callPackage ../development/libraries/isl/0.17.1.nix { };
  isl_0_20 = callPackage ../development/libraries/isl/0.20.0.nix { };

  ispike = callPackage ../development/libraries/science/robotics/ispike { };

  isync = callPackage ../tools/networking/isync { };

  ix = callPackage ../tools/misc/ix { };

  jaaa = callPackage ../applications/audio/jaaa { };

  jackett = callPackage ../servers/jackett { };

  jade = callPackage ../tools/text/sgml/jade { };

  jazzy = callPackage ../development/tools/jazzy { };

  jc = with python3Packages; toPythonApplication jc;

  jd = callPackage ../development/tools/jd { };

  jd-gui = callPackage ../tools/security/jd-gui { };

  jdiskreport = callPackage ../tools/misc/jdiskreport { };

  jekyll = callPackage ../applications/misc/jekyll { };

  jfsutils = callPackage ../tools/filesystems/jfsutils { };

  jhead = callPackage ../tools/graphics/jhead { };

  jid = callPackage ../development/tools/jid { };

  jing = res.jing-trang;
  jing-trang = callPackage ../tools/text/xml/jing-trang { };

  jira-cli = callPackage ../development/tools/jira_cli { };

  jirafeau = callPackage ../servers/web-apps/jirafeau { };

  jitterentropy = callPackage ../development/libraries/jitterentropy { };

  jl = haskellPackages.callPackage ../development/tools/jl { };

  jmespath = callPackage ../development/tools/jmespath { };

  jmtpfs = callPackage ../tools/filesystems/jmtpfs { };

  jnettop = callPackage ../tools/networking/jnettop { };

  junkie = callPackage ../tools/networking/junkie { };

  just = callPackage ../development/tools/just { };

  go-jira = callPackage ../applications/misc/go-jira { };

  john = callPackage ../tools/security/john { };

  joplin = nodePackages.joplin;

  joplin-desktop = callPackage ../applications/misc/joplin-desktop { };

  journaldriver = callPackage ../tools/misc/journaldriver { };

  jp = callPackage ../development/tools/jp { };

  jp2a = callPackage ../applications/misc/jp2a { };

  jpeg-archive = callPackage ../applications/graphics/jpeg-archive { };

  jpegexiforient = callPackage ../tools/graphics/jpegexiforient { };

  jpeginfo = callPackage ../applications/graphics/jpeginfo { };

  jpegoptim = callPackage ../applications/graphics/jpegoptim { };

  jpegrescan = callPackage ../applications/graphics/jpegrescan { };

  jpylyzer = with python3Packages; toPythonApplication jpylyzer;

  jq = callPackage ../development/tools/jq { };

  jo = callPackage ../development/tools/jo { };

  jrnl = callPackage ../applications/misc/jrnl { };

  jsawk = callPackage ../tools/text/jsawk { };

  jscoverage = callPackage ../development/tools/misc/jscoverage { };

  jsduck = callPackage ../development/tools/jsduck { };

  jtc = callPackage ../development/tools/jtc { };

  jumpapp = callPackage ../tools/X11/jumpapp {};

  jucipp = callPackage ../applications/editors/jucipp { };

  jupp = callPackage ../applications/editors/jupp { };

  jupyter = callPackage ../applications/editors/jupyter { };

  jupyter-kernel = callPackage ../applications/editors/jupyter/kernel.nix { };

  jwhois = callPackage ../tools/networking/jwhois { };

  k2pdfopt = callPackage ../applications/misc/k2pdfopt { };

  kargo = callPackage ../tools/misc/kargo { };

  kazam = callPackage ../applications/video/kazam { };

  kalibrate-rtl = callPackage ../applications/radio/kalibrate-rtl { };

  kalibrate-hackrf = callPackage ../applications/radio/kalibrate-hackrf { };

  wrapKakoune = callPackage ../applications/editors/kakoune/wrapper.nix { };
  kakounePlugins = callPackage ../applications/editors/kakoune/plugins { };
  kakoune-unwrapped = callPackage ../applications/editors/kakoune { };
  kakoune = wrapKakoune kakoune-unwrapped { };

  kak-lsp = callPackage ../tools/misc/kak-lsp { };

  kbdd = callPackage ../applications/window-managers/kbdd { };

  kdbplus = pkgsi686Linux.callPackage ../applications/misc/kdbplus { };

  keepalived = callPackage ../tools/networking/keepalived { };

  keeperrl = callPackage ../games/keeperrl { };

  kexectools = callPackage ../os-specific/linux/kexectools { };

  keepkey_agent = with python3Packages; toPythonApplication keepkey_agent;

  kexpand = callPackage ../development/tools/kexpand { };

  keybase = callPackage ../tools/security/keybase {
    # Reasoning for the inherited apple_sdk.frameworks:
    # 1. specific compiler errors about: AVFoundation, AudioToolbox, MediaToolbox
    # 2. the rest are added from here: https://github.com/keybase/client/blob/68bb8c893c5214040d86ea36f2f86fbb7fac8d39/go/chat/attachments/preview_darwin.go#L7
    #      #cgo LDFLAGS: -framework AVFoundation -framework CoreFoundation -framework ImageIO -framework CoreMedia  -framework Foundation -framework CoreGraphics -lobjc
    #    with the exception of CoreFoundation, due to the warning in https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-sdk/frameworks.nix#L25
    inherit (darwin.apple_sdk.frameworks) AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox;
  };

  kbfs = callPackage ../tools/security/keybase/kbfs.nix { };

  keybase-gui = callPackage ../tools/security/keybase/gui.nix { };

  keychain = callPackage ../tools/misc/keychain { };

  keyfuzz = callPackage ../tools/inputmethods/keyfuzz { };

  kibana6 = callPackage ../development/tools/misc/kibana/6.x.nix { };
  kibana6-oss = callPackage ../development/tools/misc/kibana/6.x.nix {
    enableUnfree = false;
  };
  kibana7 = callPackage ../development/tools/misc/kibana/7.x.nix { };
  kibana7-oss = callPackage ../development/tools/misc/kibana/7.x.nix {
    enableUnfree = false;
  };
  kibana = kibana6;
  kibana-oss = kibana6-oss;

  kismet = callPackage ../applications/networking/sniffers/kismet { };

  klick = callPackage ../applications/audio/klick { };

  klystrack = callPackage ../applications/audio/klystrack { };

  knockknock = callPackage ../tools/security/knockknock { };

  kore = callPackage ../development/web/kore { };

  krakenx = callPackage ../tools/system/krakenx { };

  partition-manager = libsForQt5.callPackage ../tools/misc/partition-manager { };

  kpcli = callPackage ../tools/security/kpcli { };

  krename = libsForQt5.callPackage ../applications/misc/krename { };

  krunner-pass = libsForQt5.callPackage ../tools/security/krunner-pass { };

  kronometer = libsForQt5.callPackage ../tools/misc/kronometer { };

  krop = callPackage ../applications/graphics/krop { };

  elisa = libsForQt5.callPackage ../applications/audio/elisa { };

  kdiff3 = libsForQt5.callPackage ../tools/text/kdiff3 { };

  kube-router = callPackage ../applications/networking/cluster/kube-router { };

  kwalletcli = libsForQt5.callPackage ../tools/security/kwalletcli { };

  peruse = libsForQt5.callPackage ../tools/misc/peruse { };

  kst = libsForQt5.callPackage ../tools/graphics/kst { gsl = gsl_1; };

  kytea = callPackage ../tools/text/kytea { };

  k6 = callPackage ../development/tools/k6 { };

  lalezar-fonts = callPackage ../data/fonts/lalezar-fonts { };

  ldc = callPackage ../development/compilers/ldc { };

  lbreakout2 = callPackage ../games/lbreakout2 { };

  lefthook = gitAndTools.lefthook;

  lego = callPackage ../tools/admin/lego { };

  leocad = callPackage ../applications/graphics/leocad { };

  less = callPackage ../tools/misc/less { };

  lf = callPackage ../tools/misc/lf {};

  lhasa = callPackage ../tools/compression/lhasa {};

  libcpuid = callPackage ../tools/misc/libcpuid { };

  libcsptr = callPackage ../development/libraries/libcsptr { };

  libscrypt = callPackage ../development/libraries/libscrypt { };

  libcloudproviders = callPackage ../development/libraries/libcloudproviders { };

  libcoap = callPackage ../applications/networking/libcoap {};

  libcroco = callPackage ../development/libraries/libcroco { };

  libcryptui = callPackage ../development/libraries/libcryptui { };

  libsmi = callPackage ../development/libraries/libsmi { };

  libgen-cli = callPackage ../tools/misc/libgen-cli { };

  licensor = callPackage ../tools/misc/licensor { };

  lesspipe = callPackage ../tools/misc/lesspipe { };

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix {
    ffmpeg = ffmpeg-full;
    ocamlPackages = ocaml-ng.ocamlPackages_4_07;
  };

  lksctp-tools = callPackage ../os-specific/linux/lksctp-tools { };

  lldpd = callPackage ../tools/networking/lldpd { };

  lnav = callPackage ../tools/misc/lnav { };

  loadlibrary = callPackage ../tools/misc/loadlibrary { };

  loc = callPackage ../development/misc/loc { };

  lockfileProgs = callPackage ../tools/misc/lockfile-progs { };

  logstash6 = callPackage ../tools/misc/logstash/6.x.nix { };
  logstash6-oss = callPackage ../tools/misc/logstash/6.x.nix {
    enableUnfree = false;
  };
  logstash7 = callPackage ../tools/misc/logstash/7.x.nix { };
  logstash7-oss = callPackage ../tools/misc/logstash/7.x.nix {
    enableUnfree = false;
  };
  logstash = logstash6;

  logstash-contrib = callPackage ../tools/misc/logstash/contrib.nix { };

  lolcat = callPackage ../tools/misc/lolcat { };

  lsd = callPackage ../tools/misc/lsd { };

  lsdvd = callPackage ../tools/cd-dvd/lsdvd {};

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    lua = lua5_2_compat;
  };

  ltwheelconf = callPackage ../applications/misc/ltwheelconf { };

  lvmsync = callPackage ../tools/backup/lvmsync { };

  kdbg = libsForQt5.callPackage ../development/tools/misc/kdbg { };

  kippo = callPackage ../servers/kippo { };

  kzipmix = pkgsi686Linux.callPackage ../tools/compression/kzipmix { };

  ma1sd = callPackage ../servers/ma1sd { };

  mailcatcher = callPackage ../development/web/mailcatcher { };

  makebootfat = callPackage ../tools/misc/makebootfat { };

  /* Python 3.8 is currently broken with matrix-synapse since `python38Packages.bleach` fails
    (https://github.com/NixOS/nixpkgs/issues/76093) */
  matrix-synapse = callPackage ../servers/matrix-synapse { /*python3 = python38;*/ };

  matrix-appservice-slack = callPackage ../servers/matrix-synapse/matrix-appservice-slack {};

  mautrix-telegram = recurseIntoAttrs (callPackage ../servers/mautrix-telegram { });

  mautrix-whatsapp = callPackage ../servers/mautrix-whatsapp { };

  mcfly = callPackage ../tools/misc/mcfly {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mdbook = callPackage ../tools/text/mdbook {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mdcat = callPackage ../tools/text/mdcat {
    inherit (darwin.apple_sdk.frameworks) Security;
    inherit (pythonPackages) ansi2html;
  };

  medfile = callPackage ../development/libraries/medfile { };

  memtester = callPackage ../tools/system/memtester { };

  mhonarc = perlPackages.MHonArc;

  minergate = callPackage ../applications/misc/minergate { };

  minergate-cli = callPackage ../applications/misc/minergate-cli { };

  minidlna = callPackage ../tools/networking/minidlna { };

  minisign = callPackage ../tools/security/minisign { };

  ministat = callPackage ../tools/misc/ministat { };

  mmv = callPackage ../tools/misc/mmv { };

  most = callPackage ../tools/misc/most { };

  motion = callPackage ../applications/video/motion { };

  mtail = callPackage ../servers/monitoring/mtail { };

  multitail = callPackage ../tools/misc/multitail { };

  mxt-app = callPackage ../misc/mxt-app { };

  mxisd = callPackage ../servers/mxisd { };

  nagstamon = callPackage ../tools/misc/nagstamon {
    pythonPackages = python3Packages;
  };

  nbench = callPackage ../tools/misc/nbench { };

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

    libnslog = callPackage ../applications/misc/netsurf/libnslog { };

    libcss = callPackage ../applications/misc/netsurf/libcss { };

    libhubbub = callPackage ../applications/misc/netsurf/libhubbub { };

    libdom = callPackage ../applications/misc/netsurf/libdom { };

    libnsbmp = callPackage ../applications/misc/netsurf/libnsbmp { };

    libnsgif = callPackage ../applications/misc/netsurf/libnsgif { };

    libnsfb = callPackage ../applications/misc/netsurf/libnsfb { };

    libnsutils = callPackage ../applications/misc/netsurf/libnsutils { };

    libsvgtiny = callPackage ../applications/misc/netsurf/libsvgtiny { };

    libnspsl = callPackage ../applications/misc/netsurf/libnspsl { };

    libutf8proc = callPackage ../applications/misc/netsurf/libutf8proc { };

    browser = callPackage ../applications/misc/netsurf/browser { };

  });

  netperf = callPackage ../applications/networking/netperf { };

  netsniff-ng = callPackage ../tools/networking/netsniff-ng { };

  next = callPackage ../applications/networking/browsers/next { };

  nfpm = callPackage ../tools/package-management/nfpm { };

  nginx-config-formatter = callPackage ../tools/misc/nginx-config-formatter { };

  ninka = callPackage ../development/tools/misc/ninka { };

  nixnote2 = libsForQt5.callPackage ../applications/misc/nixnote2 { };

  nodejs = hiPrio nodejs-10_x;

  nodejs-slim = nodejs-slim-10_x;


  nodejs-10_x = callPackage ../development/web/nodejs/v10.nix { };
  nodejs-slim-10_x = callPackage ../development/web/nodejs/v10.nix {
    enableNpm = false;
  };
  nodejs-12_x = callPackage ../development/web/nodejs/v12.nix { };
  nodejs-slim-12_x = callPackage ../development/web/nodejs/v12.nix {
    enableNpm = false;
  };
  nodejs-13_x = callPackage ../development/web/nodejs/v13.nix { };
  nodejs-slim-13_x = callPackage ../development/web/nodejs/v13.nix {
    enableNpm = false;
  };

  # Update this when adding the newest nodejs major version!
  nodejs_latest = nodejs-13_x;
  nodejs-slim_latest = nodejs-slim-13_x;

  nodePackages_13_x = dontRecurseIntoAttrs (callPackage ../development/node-packages/default-v13.nix {
    nodejs = pkgs.nodejs-13_x;
  });

  nodePackages_12_x = dontRecurseIntoAttrs (callPackage ../development/node-packages/default-v12.nix {
    nodejs = pkgs.nodejs-12_x;
  });

  nodePackages_10_x = dontRecurseIntoAttrs (callPackage ../development/node-packages/default-v10.nix {
    nodejs = pkgs.nodejs-10_x;
  });

  nodePackages = nodePackages_10_x;

  now-cli = callPackage ../development/web/now-cli {};

  file-rename = callPackage ../tools/filesystems/file-rename { };

  kea = callPackage ../tools/networking/kea { };

  ispell = callPackage ../tools/text/ispell {};

  jumanpp = callPackage ../tools/text/jumanpp {};

  jump = callPackage ../tools/system/jump {};

  kindlegen = callPackage ../tools/typesetting/kindlegen { };

  latex2html = callPackage ../tools/misc/latex2html { };

  latexrun = callPackage ../tools/typesetting/tex/latexrun { };

  lcdf-typetools = callPackage ../tools/misc/lcdf-typetools { };

  ldapvi = callPackage ../tools/misc/ldapvi { };

  ldns = callPackage ../development/libraries/ldns { };

  leafpad = callPackage ../applications/editors/leafpad { };

  leatherman = callPackage ../development/libraries/leatherman { };

  ledmon = callPackage ../tools/system/ledmon { };

  leela = callPackage ../tools/graphics/leela { };

  lftp = callPackage ../tools/networking/lftp { };

  libck = callPackage ../development/libraries/libck { };

  libconfig = callPackage ../development/libraries/libconfig { };

  libcmis = callPackage ../development/libraries/libcmis { };

  libee = callPackage ../development/libraries/libee { };

  libepc = callPackage ../development/libraries/libepc { };

  libestr = callPackage ../development/libraries/libestr { };

  libevdev = callPackage ../development/libraries/libevdev { };

  liberio = callPackage ../development/libraries/liberio { };

  libevdevplus = callPackage ../development/libraries/libevdevplus { };

  libfann = callPackage ../development/libraries/libfann { };

  libfsm = callPackage ../development/libraries/libfsm { };

  libgaminggear = callPackage ../development/libraries/libgaminggear { };

  libhandy = callPackage ../development/libraries/libhandy { };

  libgumath = callPackage ../development/libraries/libgumath { };

  libinsane = callPackage ../development/libraries/libinsane { };

  libipfix = callPackage ../development/libraries/libipfix { };

  libircclient = callPackage ../development/libraries/libircclient { };

  libisds = callPackage ../development/libraries/libisds { };

  libite = callPackage ../development/libraries/libite { };

  liblangtag = callPackage ../development/libraries/liblangtag {
    inherit (gnome3) gnome-common;
  };

  liblouis = callPackage ../development/libraries/liblouis { };

  liboauth = callPackage ../development/libraries/liboauth { };

  libr3 = callPackage ../development/libraries/libr3 { };

  libraspberrypi = callPackage ../development/libraries/libraspberrypi { };

  libsidplayfp = callPackage ../development/libraries/libsidplayfp { };

  libspf2 = callPackage ../development/libraries/libspf2 { };

  libsrs2 = callPackage ../development/libraries/libsrs2 { };

  libtermkey = callPackage ../development/libraries/libtermkey { };

  libtelnet = callPackage ../development/libraries/libtelnet { };

  libtirpc = callPackage ../development/libraries/ti-rpc { };

  libtins = callPackage ../development/libraries/libtins { };

  libshout = callPackage ../development/libraries/libshout { };

  libqb = callPackage ../development/libraries/libqb { };

  libqmi = callPackage ../development/libraries/libqmi { };

  libmbim = callPackage ../development/libraries/libmbim { };

  libmongo-client = callPackage ../development/libraries/libmongo-client { };

  libmesode = callPackage ../development/libraries/libmesode {};

  libnabo = callPackage ../development/libraries/libnabo { };

  libngspice = callPackage ../development/libraries/libngspice { };

  libpointmatcher = callPackage ../development/libraries/libpointmatcher { };

  libportal = callPackage ../development/libraries/libportal { };

  libmicrodns = callPackage ../development/libraries/libmicrodns { };

  libnids = callPackage ../tools/networking/libnids { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  libmpack = callPackage ../development/libraries/libmpack { };

  libiberty = callPackage ../development/libraries/libiberty { };

  libxc = callPackage ../development/libraries/libxc { };

  libxcomp = callPackage ../development/libraries/libxcomp { };

  libxl = callPackage ../development/libraries/libxl {};

  libx86emu = callPackage ../development/libraries/libx86emu { };

  libzmf = callPackage ../development/libraries/libzmf {};

  libreswan = callPackage ../tools/networking/libreswan { };

  librest = callPackage ../development/libraries/librest { };

  inherit (callPackages ../development/libraries/libwebsockets { })
    libwebsockets_3_1
    libwebsockets_3_2
    libwebsockets;

  lidarr = callPackage ../servers/lidarr { };

  limesuite = callPackage ../applications/radio/limesuite { };

  limesurvey = callPackage ../servers/limesurvey { };

  linuxquota = callPackage ../tools/misc/linuxquota { };

  localtime = callPackage ../tools/system/localtime { };

  logcheck = callPackage ../tools/system/logcheck { };

  logmein-hamachi = callPackage ../tools/networking/logmein-hamachi { };

  logkeys = callPackage ../tools/security/logkeys { };

  logrotate = callPackage ../tools/system/logrotate { };

  logstalgia = callPackage ../tools/graphics/logstalgia {};

  loki = callPackage ../development/libraries/loki { };

  longview = callPackage ../servers/monitoring/longview { };

  lout = callPackage ../tools/typesetting/lout { };

  lr = callPackage ../tools/system/lr { };

  lrzip = callPackage ../tools/compression/lrzip { };

  lsb-release = callPackage ../os-specific/linux/lsb-release { };

  # lsh installs `bin/nettle-lfib-stream' and so does Nettle.  Give the
  # former a lower priority than Nettle.
  lsh = lowPrio (callPackage ../tools/networking/lsh { });

  lshw = callPackage ../tools/system/lshw { };

  ltris = callPackage ../games/ltris { };

  lv = callPackage ../tools/text/lv { };

  lxc = callPackage ../os-specific/linux/lxc { };
  lxcfs = callPackage ../os-specific/linux/lxcfs { };
  lxd = callPackage ../tools/admin/lxd { };

  lzfse = callPackage ../tools/compression/lzfse { };

  lzham = callPackage ../tools/compression/lzham { };

  lzip = callPackage ../tools/compression/lzip { };

  luxcorerender = callPackage ../tools/graphics/luxcorerender { };

  xz = callPackage ../tools/compression/xz { };
  lzma = xz; # TODO: move to aliases.nix

  lz4 = callPackage ../tools/compression/lz4 { };

  lzbench = callPackage ../tools/compression/lzbench { };

  lzop = callPackage ../tools/compression/lzop { };

  macchanger = callPackage ../os-specific/linux/macchanger { };

  madlang = haskell.lib.justStaticExecutables haskellPackages.madlang;

  mailcheck = callPackage ../applications/networking/mailreaders/mailcheck { };

  maildrop = callPackage ../tools/networking/maildrop { };

  mailhog = callPackage ../servers/mail/mailhog {};

  mailnag = callPackage ../applications/networking/mailreaders/mailnag {
    pythonPackages = python2Packages;
  };

  mailsend = callPackage ../tools/networking/mailsend { };

  mailpile = callPackage ../applications/networking/mailreaders/mailpile { };

  mailutils = callPackage ../tools/networking/mailutils {
    guile = guile_2_0;  # compilation fails with guile 2.2
    sasl = gsasl;
  };

  email = callPackage ../tools/networking/email { };

  maim = callPackage ../tools/graphics/maim {};

  mairix = callPackage ../tools/text/mairix { };

  makemkv = libsForQt5.callPackage ../applications/video/makemkv { };

  makerpm = callPackage ../development/tools/makerpm { };

  makefile2graph = callPackage ../development/tools/analysis/makefile2graph { };

  man = man-db;

  man-db = callPackage ../tools/misc/man-db { };

  mandoc = callPackage ../tools/misc/mandoc { };

  marktext = callPackage ../applications/misc/marktext { };

  mawk = callPackage ../tools/text/mawk { };

  mb2md = callPackage ../tools/text/mb2md { };

  mbox = callPackage ../tools/security/mbox { };

  mbuffer = callPackage ../tools/misc/mbuffer { };

  mdsh = callPackage ../development/tools/documentation/mdsh { };

  mecab =
    let
      mecab-nodic = callPackage ../tools/text/mecab/nodic.nix { };
    in
    callPackage ../tools/text/mecab {
      mecab-ipadic = callPackage ../tools/text/mecab/ipadic.nix {
        inherit mecab-nodic;
      };
    };

  mediawiki = callPackage ../servers/web-apps/mediawiki { };

  memtier-benchmark = callPackage ../tools/networking/memtier-benchmark { };

  memtest86-efi = callPackage ../tools/misc/memtest86-efi { };

  memtest86plus = callPackage ../tools/misc/memtest86+ { };

  meo = callPackage ../tools/security/meo {
    boost = boost155;
  };

  mbutil = python3Packages.callPackage ../applications/misc/mbutil { };

  mc = callPackage ../tools/misc/mc { };

  mcabber = callPackage ../applications/networking/instant-messengers/mcabber { };

  mcron = callPackage ../tools/system/mcron {
    guile = guile_1_8;
  };

  mdbtools = callPackage ../tools/misc/mdbtools { };

  mdk = callPackage ../development/tools/mdk { };

  mdp = callPackage ../applications/misc/mdp { };

  mednafen = callPackage ../misc/emulators/mednafen { };

  mednafen-server = callPackage ../misc/emulators/mednafen/server.nix { };

  mednaffe = callPackage ../misc/emulators/mednaffe {
    gtk2 = null;
  };

  megacli = callPackage ../tools/misc/megacli { };

  megatools = callPackage ../tools/networking/megatools { };

  memo = callPackage ../applications/misc/memo { };

  mencal = callPackage ../applications/misc/mencal { } ;

  metamorphose2 = callPackage ../applications/misc/metamorphose2 { };

  metar = callPackage ../applications/misc/metar { };

  mfcuk = callPackage ../tools/security/mfcuk { };

  mfoc = callPackage ../tools/security/mfoc { };

  mgba = libsForQt5.callPackage ../misc/emulators/mgba { };

  midisheetmusic = callPackage ../applications/audio/midisheetmusic { };

  mikutter = callPackage ../applications/networking/instant-messengers/mikutter { };

  mimeo = callPackage ../tools/misc/mimeo { };

  mimetic = callPackage ../development/libraries/mimetic { };

  minetime = callPackage ../applications/office/minetime { };

  minio-client = callPackage ../tools/networking/minio-client { };

  minissdpd = callPackage ../tools/networking/minissdpd { };

  inherit (callPackage ../tools/networking/miniupnpc
            { inherit (darwin) cctools; })
    miniupnpc_1 miniupnpc_2;
  miniupnpc = miniupnpc_1;

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  miniball = callPackage ../development/libraries/miniball { };

  minijail = callPackage ../tools/system/minijail { };

  minijail-tools = python3.pkgs.callPackage ../tools/system/minijail/tools.nix { };

  minixml = callPackage ../development/libraries/minixml { };

  mir-qualia = callPackage ../tools/text/mir-qualia {
    pythonPackages = python3Packages;
  };

  miredo = callPackage ../tools/networking/miredo { };

  mirrorbits = callPackage ../servers/mirrorbits { };

  mitmproxy = callPackage ../tools/networking/mitmproxy { };

  mjpegtools = callPackage ../tools/video/mjpegtools { };

  mjpegtoolsFull = mjpegtools.override {
    withMinimal = false;
  };

  mkclean = callPackage ../applications/video/mkclean {};

  mkcue = callPackage ../tools/cd-dvd/mkcue { };

  mkp224o = callPackage ../tools/security/mkp224o { };

  mkpasswd = hiPrio (callPackage ../tools/security/mkpasswd { });

  mkrand = callPackage ../tools/security/mkrand { };

  mktemp = callPackage ../tools/security/mktemp { };

  mktorrent = callPackage ../tools/misc/mktorrent { };

  mmake = callPackage ../tools/misc/mmake { };

  modemmanager = callPackage ../tools/networking/modem-manager {};

  modem-manager-gui = callPackage ../applications/networking/modem-manager-gui {};

  modsecurity_standalone = callPackage ../tools/security/modsecurity { };

  molly-guard = callPackage ../os-specific/linux/molly-guard { };

  moneyplex = callPackage ../applications/office/moneyplex { };

  monit = callPackage ../tools/system/monit { };

  moreutils = callPackage ../tools/misc/moreutils {
    docbook-xsl = docbook_xsl;
  };

  mosh = callPackage ../tools/networking/mosh { };

  mpage = callPackage ../tools/text/mpage { };

  mprime = callPackage ../tools/misc/mprime { };

  mpw = callPackage ../tools/security/mpw { };

  mr = callPackage ../applications/version-management/mr { };

  mrsh = callPackage ../shells/mrsh { };

  mrtg = callPackage ../tools/misc/mrtg { };

  mscgen = callPackage ../tools/graphics/mscgen { };

  metasploit = callPackage ../tools/security/metasploit { };

  ms-sys = callPackage ../tools/misc/ms-sys { };

  mtdutils = callPackage ../tools/filesystems/mtdutils { };

  mtools = callPackage ../tools/filesystems/mtools { };

  mtr = callPackage ../tools/networking/mtr {};

  mtr-gui = callPackage ../tools/networking/mtr { withGtk = true; };

  mtx = callPackage ../tools/backup/mtx {};

  mt-st = callPackage ../tools/backup/mt-st {};

  multitime = callPackage ../tools/misc/multitime { };

  sta = callPackage ../tools/misc/sta {};

  multitran = recurseIntoAttrs (let callPackage = newScope pkgs.multitran; in {
    multitrandata = callPackage ../tools/text/multitran/data { };

    libbtree = callPackage ../tools/text/multitran/libbtree { };

    libmtsupport = callPackage ../tools/text/multitran/libmtsupport { };

    libfacet = callPackage ../tools/text/multitran/libfacet { };

    libmtquery = callPackage ../tools/text/multitran/libmtquery { };

    mtutils = callPackage ../tools/text/multitran/mtutils { };
  });

  munge = callPackage ../tools/security/munge { };

  munt = libsForQt5.callPackage ../applications/audio/munt { };

  mutagen = callPackage ../tools/misc/mutagen { };

  mycli = callPackage ../tools/admin/mycli { };

  mydumper = callPackage ../tools/backup/mydumper { };

  mysql2pgsql = callPackage ../tools/misc/mysql2pgsql { };

  mysqltuner = callPackage ../tools/misc/mysqltuner { };

  mytetra = libsForQt5.callPackage ../applications/office/mytetra { };

  nabi = callPackage ../tools/inputmethods/nabi { };

  nahid-fonts = callPackage ../data/fonts/nahid-fonts { };

  namazu = callPackage ../tools/text/namazu { };

  nasty = callPackage ../tools/security/nasty { };

  nat-traverse = callPackage ../tools/networking/nat-traverse { };

  navilu-font = callPackage ../data/fonts/navilu { stdenv = stdenvNoCC; };

  nawk = callPackage ../tools/text/nawk { };

  nbd = callPackage ../tools/networking/nbd { };
  xnbd = callPackage ../tools/networking/xnbd { };

  nccl = callPackage ../development/libraries/science/math/nccl { };
  nccl_cudatoolkit_9_0 = nccl.override { cudatoolkit = cudatoolkit_9_0; };
  nccl_cudatoolkit_9 = nccl.override { cudatoolkit = cudatoolkit_9; };
  nccl_cudatoolkit_10 = nccl.override { cudatoolkit = cudatoolkit_10; };

  ndjbdns = callPackage ../tools/networking/ndjbdns { };

  ndppd = callPackage ../applications/networking/ndppd { };

  nebula = callPackage ../tools/networking/nebula { };

  nemiver = callPackage ../development/tools/nemiver { };

  neo-cowsay = callPackage ../tools/misc/neo-cowsay { };

  neofetch = callPackage ../tools/misc/neofetch { };

  nerdfonts = callPackage ../data/fonts/nerdfonts { };

  nestopia = callPackage ../misc/emulators/nestopia { };

  netatalk = callPackage ../tools/filesystems/netatalk { };

  netcdf = callPackage ../development/libraries/netcdf { };

  netcdf-mpi = appendToName "mpi" (netcdf.override {
    hdf5 = hdf5-mpi;
  });

  netcdfcxx4 = callPackage ../development/libraries/netcdf-cxx4 { };

  netcdffortran = callPackage ../development/libraries/netcdf-fortran { };

  nco = callPackage ../development/libraries/nco { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  ndisc6 = callPackage ../tools/networking/ndisc6 { };

  neopg = callPackage ../tools/security/neopg { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = libressl.nc;

  netcat-gnu = callPackage ../tools/networking/netcat { };

  nethogs = callPackage ../tools/networking/nethogs { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netrw = callPackage ../tools/networking/netrw { };

  netselect = callPackage ../tools/networking/netselect { };

  nettee = callPackage ../tools/networking/nettee {
    inherit (skawarePackages) cleanPackaging;
  };

  # stripped down, needed by steam
  networkmanager098 = callPackage ../tools/networking/network-manager/0.9.8 { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager-iodine = callPackage ../tools/networking/network-manager/iodine { };

  networkmanager-openvpn = callPackage ../tools/networking/network-manager/openvpn { };

  networkmanager-l2tp = callPackage ../tools/networking/network-manager/l2tp { };

  networkmanager-vpnc = callPackage ../tools/networking/network-manager/vpnc { };

  networkmanager-openconnect = callPackage ../tools/networking/network-manager/openconnect { };

  networkmanager-fortisslvpn = callPackage ../tools/networking/network-manager/fortisslvpn { };

  networkmanager_strongswan = callPackage ../tools/networking/network-manager/strongswan { };

  networkmanagerapplet = callPackage ../tools/networking/network-manager/applet { };

  libnma = callPackage ../tools/networking/network-manager/libnma { };

  networkmanager_dmenu = callPackage ../tools/networking/network-manager/dmenu  { };

  nm-tray = libsForQt5.callPackage ../tools/networking/network-manager/tray.nix { };

  newsboat = callPackage ../applications/networking/feedreaders/newsboat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  grocy = callPackage ../servers/grocy { };

  inherit (callPackage ../servers/nextcloud {})
    nextcloud17 nextcloud18;

  nextcloud-client = libsForQt5.callPackage ../applications/networking/nextcloud-client { };

  nextcloud-news-updater = callPackage ../servers/nextcloud/news-updater.nix { };

  ndstool = callPackage ../tools/archivers/ndstool { };

  ngrep = callPackage ../tools/networking/ngrep { };

  ngrok = ngrok-2;

  ngrok-2 = callPackage ../tools/networking/ngrok-2 { };

  ngrok-1 = callPackage ../tools/networking/ngrok-1 { };

  noice = callPackage ../applications/misc/noice { };

  noip = callPackage ../tools/networking/noip { };

 nomad = callPackage ../applications/networking/cluster/nomad {
    buildGoPackage = buildGo112Package;
  };

  notable = callPackage ../applications/misc/notable { };

  miller = callPackage ../tools/text/miller { };

  milu = callPackage ../applications/misc/milu { };

  mkgmap = callPackage ../applications/misc/mkgmap { };

  mpack = callPackage ../tools/networking/mpack { };

  mtm = callPackage ../tools/misc/mtm { };

  pa_applet = callPackage ../tools/audio/pa-applet { };

  pandoc-imagine = python3Packages.callPackage ../tools/misc/pandoc-imagine { };

  pasystray = callPackage ../tools/audio/pasystray { };

  phash = callPackage ../development/libraries/phash { };

  pnmixer = callPackage ../tools/audio/pnmixer { };

  pro-office-calculator = libsForQt5.callPackage ../games/pro-office-calculator { };

  pulsemixer = callPackage ../tools/audio/pulsemixer { };

  pwsafe = callPackage ../applications/misc/pwsafe { };

  niff = callPackage ../tools/package-management/niff { };

  nifskope = libsForQt5.callPackage ../tools/graphics/nifskope { };

  nilfs-utils = callPackage ../tools/filesystems/nilfs-utils {};

  nitrogen = callPackage ../tools/X11/nitrogen {};

  nms = callPackage ../tools/misc/nms { };

  nomachine-client = callPackage ../tools/admin/nomachine-client { };

  notify-desktop = callPackage ../tools/misc/notify-desktop {};

  nkf = callPackage ../tools/text/nkf {};

  nlopt = callPackage ../development/libraries/nlopt { octave = null; };

  npapi_sdk = callPackage ../development/libraries/npapi-sdk {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap { };

  nmap-graphical = nmap.override {
    graphicalSupport = true;
  };

  nmapsi4 = libsForQt5.callPackage ../tools/security/nmap/qt.nix { };

  nnn = callPackage ../applications/misc/nnn { };


  noise-repellent = callPackage ../applications/audio/noise-repellent { };

  notary = callPackage ../tools/security/notary { };

  notify-osd = callPackage ../applications/misc/notify-osd { };

  notes-up = callPackage ../applications/office/notes-up { };

  notify-osd-customizable = callPackage ../applications/misc/notify-osd-customizable { };

  nox = callPackage ../tools/package-management/nox { };

  nq = callPackage ../tools/system/nq { };

  nsjail = callPackage ../tools/security/nsjail {};

  nss_pam_ldapd = callPackage ../tools/networking/nss-pam-ldapd {};

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntfy = callPackage ../tools/misc/ntfy {};

  ntopng = callPackage ../tools/networking/ntopng { };

  ntp = callPackage ../tools/networking/ntp {
    libcap = if stdenv.isLinux then libcap else null;
  };

  numdiff = callPackage ../tools/text/numdiff { };

  numlockx = callPackage ../tools/X11/numlockx { };

  nuttcp = callPackage ../tools/networking/nuttcp { };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nwdiag = with python3Packages; toPythonApplication nwdiag;

  nyancat = callPackage ../tools/misc/nyancat { };

  nylon = callPackage ../tools/networking/nylon { };

  nzbget = callPackage ../tools/networking/nzbget { };

  oathToolkit = callPackage ../tools/security/oath-toolkit { };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  obexd = callPackage ../tools/bluetooth/obexd { };

  obfs4 = callPackage ../tools/networking/obfs4 { };

  oci-image-tool = callPackage ../tools/misc/oci-image-tool { };

  ocproxy = callPackage ../tools/networking/ocproxy { };

  ocserv = callPackage ../tools/networking/ocserv { };

  opencorsairlink = callPackage ../tools/misc/opencorsairlink { };

  openfortivpn = callPackage ../tools/networking/openfortivpn { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  objconv = callPackage ../development/tools/misc/objconv {};

  odpdown = callPackage ../tools/typesetting/odpdown { };

  odpic = callPackage ../development/libraries/odpic { };

  odt2txt = callPackage ../tools/text/odt2txt { };

  odyssey = callPackage ../tools/misc/odyssey { };

  offlineimap = callPackage ../tools/networking/offlineimap { };

  ofono-phonesim = libsForQt5.callPackage ../development/tools/ofono-phonesim/default.nix { };

  ogdf = callPackage ../development/libraries/ogdf { };

  oh-my-zsh = callPackage ../shells/zsh/oh-my-zsh { };

  ola = callPackage ../applications/misc/ola { };

  olive-editor = libsForQt5.callPackage ../applications/video/olive-editor {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  omping = callPackage ../applications/networking/omping { };

  onefetch = callPackage ../tools/misc/onefetch {
    inherit (darwin) libresolv;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  onioncircuits = callPackage ../tools/security/onioncircuits { };

  openapi-generator-cli = callPackage ../tools/networking/openapi-generator-cli { };
  openapi-generator-cli-unstable = callPackage ../tools/networking/openapi-generator-cli/unstable.nix { };

  opencc = callPackage ../tools/text/opencc { };

  opencl-info = callPackage ../tools/system/opencl-info { };

  opencryptoki = callPackage ../tools/security/opencryptoki { };

  opendbx = callPackage ../development/libraries/opendbx { };

  opendht = callPackage ../development/libraries/opendht {};

  opendkim = callPackage ../development/libraries/opendkim { };

  opendylan = callPackage ../development/compilers/opendylan {
    opendylan-bootstrap = opendylan_bin;
  };

  opendylan_bin = callPackage ../development/compilers/opendylan/bin.nix { };

  open-ecard = callPackage ../tools/security/open-ecard { };

  openjade = callPackage ../tools/text/sgml/openjade { };

  openimagedenoise = callPackage ../development/libraries/openimagedenoise { };

  openmvg = callPackage ../applications/science/misc/openmvg { };

  openmvs = callPackage ../applications/science/misc/openmvs { };

  openntpd = callPackage ../tools/networking/openntpd { };

  openntpd_nixos = openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  openobex = callPackage ../tools/bluetooth/openobex { };

  openresolv = callPackage ../tools/networking/openresolv { };

  opensc = callPackage ../tools/security/opensc {
    inherit (darwin.apple_sdk.frameworks) Carbon PCSC;
  };

  opensm = callPackage ../tools/networking/opensm { };

  openssh =
    callPackage ../tools/networking/openssh {
      hpnSupport = false;
      etcDir = "/etc/ssh";
      pam = if stdenv.isLinux then pam else null;
    };

  openssh_hpn = pkgs.appendToName "with-hpn" (openssh.override {
    hpnSupport = true;
    # the hpn patchset does not yet support openssl>1.0.2
    # https://github.com/rapier1/openssh-portable/issues/14
    openssl = openssl_1_0_2;
  });

  openssh_gssapi = pkgs.appendToName "with-gssapi" (openssh.override {
    withGssapiPatches = true;
  });

  opensp = callPackage ../tools/text/sgml/opensp { };

  opentracker = callPackage ../applications/networking/p2p/opentracker { };

  opentsdb = callPackage ../tools/misc/opentsdb {};

  openvpn = callPackage ../tools/networking/openvpn {};

  openvpn_learnaddress = callPackage ../tools/networking/openvpn/openvpn_learnaddress.nix { };

  openvpn-auth-ldap = callPackage ../tools/networking/openvpn/openvpn-auth-ldap.nix {
    stdenv = clangStdenv;
  };

  out-of-tree = callPackage ../development/tools/out-of-tree { };

  oppai-ng = callPackage ../tools/misc/oppai-ng { };

  update-dotdee = with python3Packages; toPythonApplication update-dotdee;

  update-resolv-conf = callPackage ../tools/networking/openvpn/update-resolv-conf.nix { };

  update-systemd-resolved = callPackage ../tools/networking/openvpn/update-systemd-resolved.nix { };

  opae = callPackage ../development/libraries/opae { };

  opentracing-cpp = callPackage ../development/libraries/opentracing-cpp { };

  openvswitch = callPackage ../os-specific/linux/openvswitch { };

  openvswitch-lts = callPackage ../os-specific/linux/openvswitch/lts.nix { };

  optipng = callPackage ../tools/graphics/optipng {
    libpng = libpng12;
  };

  olsrd = callPackage ../tools/networking/olsrd { };

  opl3bankeditor = libsForQt5.callPackage ../tools/audio/opl3bankeditor { };

  opn2bankeditor = callPackage ../tools/audio/opl3bankeditor/opn2bankeditor.nix { };

  orangefs = callPackage ../tools/filesystems/orangefs { };

  os-prober = callPackage ../tools/misc/os-prober {};

  osl = callPackage ../development/compilers/osl { };

  ossec = callPackage ../tools/security/ossec {};

  osslsigncode = callPackage ../development/tools/osslsigncode {};

  ostree = callPackage ../tools/misc/ostree { };

  otfcc = callPackage ../tools/misc/otfcc { };

  otpw = callPackage ../os-specific/linux/otpw { };

  overcommit = callPackage ../development/tools/overcommit { };

  overmind = callPackage ../applications/misc/overmind { };

  owncloud-client = libsForQt5.callPackage ../applications/networking/owncloud-client { };

  oxidized = callPackage ../tools/admin/oxidized { };

  oxipng = callPackage ../tools/graphics/oxipng { };

  p2pvc = callPackage ../applications/video/p2pvc {};

  p7zip = callPackage ../tools/archivers/p7zip { };

  packagekit = callPackage ../tools/package-management/packagekit { };

  packagekit-qt = libsForQt5.callPackage ../tools/package-management/packagekit/qt.nix { };

  packetdrill = callPackage ../tools/networking/packetdrill { };

  pacman = callPackage ../tools/package-management/pacman { };

  padthv1 = libsForQt5.callPackage ../applications/audio/padthv1 { };

  pagmo2 = callPackage ../development/libraries/pagmo2 { };

  pakcs = callPackage ../development/compilers/pakcs { };

  pal = callPackage ../tools/misc/pal { };

  pandoc = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.pandoc) (drv: {
    configureFlags = drv.configureFlags or [] ++ ["-fembed_data_files"];
    buildDepends = drv.buildDepends or [] ++ [haskellPackages.file-embed];
  });

  pamtester = callPackage ../tools/security/pamtester { };

  paperless = callPackage ../applications/office/paperless { };

  paperwork = callPackage ../applications/office/paperwork { };

  papertrail = callPackage ../tools/text/papertrail { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  parastoo-fonts = callPackage ../data/fonts/parastoo-fonts { };

  parcellite = callPackage ../tools/misc/parcellite { };

  patchutils = callPackage ../tools/text/patchutils { };

  patchutils_0_3_3 = callPackage ../tools/text/patchutils/0.3.3.nix { };

  parted = callPackage ../tools/misc/parted { };

  passh = callPackage ../tools/networking/passh { };

  paulstretch = callPackage ../applications/audio/paulstretch { };

  pazi = callPackage ../tools/misc/pazi { };

  peep = callPackage ../tools/misc/peep { };

  pell = callPackage ../applications/misc/pell { };

  pepper = callPackage ../tools/admin/salt/pepper { };

  perceptualdiff = callPackage ../tools/graphics/perceptualdiff { };

  percona-xtrabackup = callPackage ../tools/backup/percona-xtrabackup {
    boost = boost159;
  };

  pick = callPackage ../tools/misc/pick { };

  pitivi = callPackage ../applications/video/pitivi { };

  pulumi-bin = callPackage ../tools/admin/pulumi { };

  p0f = callPackage ../tools/security/p0f { };

  pngout = callPackage ../tools/graphics/pngout { };

  ipsecTools = callPackage ../os-specific/linux/ipsec-tools {
    flex = flex_2_5_35;
    openssl = openssl_1_0_2;
  };

  patch = gnupatch;

  patchage = callPackage ../applications/audio/patchage { };

  patchwork-classic = callPackage ../applications/networking/ssb/patchwork-classic { };

  pcapfix = callPackage ../tools/networking/pcapfix { };

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcsctools = callPackage ../tools/security/pcsctools { };

  pcsc-cyberjack = callPackage ../tools/security/pcsc-cyberjack { };

  pcsc-scm-scl011 = callPackage ../tools/security/pcsc-scm-scl011 { };
  ifdnfc = callPackage ../tools/security/ifdnfc { };

  pdd = python3Packages.callPackage ../tools/misc/pdd { };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdf2htmlEX = callPackage ../tools/typesetting/pdf2htmlEX { };

  pdf2odt = callPackage ../tools/typesetting/pdf2odt { };

  pdf-redact-tools = callPackage ../tools/graphics/pdfredacttools { };

  pdfcrack = callPackage ../tools/security/pdfcrack { };

  pdfsandwich = callPackage ../tools/typesetting/pdfsandwich { };

  pdftag = callPackage ../tools/graphics/pdftag { };

  pdf2svg = callPackage ../tools/graphics/pdf2svg { };

  fmodex = callPackage ../games/zandronum/fmod.nix { };

  pdfmod = callPackage ../applications/misc/pdfmod { };

  pdf-quench = callPackage ../applications/misc/pdf-quench { };

  jbig2enc = callPackage ../tools/graphics/jbig2enc { };

  pdfarranger = callPackage ../applications/misc/pdfarranger { };

  pdfread = callPackage ../tools/graphics/pdfread {
    inherit (pythonPackages) pillow;
  };

  briss = callPackage ../tools/graphics/briss { };

  brickd = callPackage ../servers/brickd {
    libusb = libusb1;
  };

  bully = callPackage ../tools/networking/bully {
    openssl = openssl_1_0_2;
  };

  pcapc = callPackage ../tools/networking/pcapc { };

  pdnsd = callPackage ../tools/networking/pdnsd { };

  peco = callPackage ../tools/text/peco { };

  pg_checksums = callPackage ../development/tools/database/pg_checksums { };

  pg_flame = callPackage ../tools/misc/pg_flame { };

  pg_top = callPackage ../tools/misc/pg_top { };

  pgcenter = callPackage ../tools/misc/pgcenter { };

  pgmetrics = callPackage ../tools/misc/pgmetrics { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pfetch = callPackage ../tools/misc/pfetch { };

  pfstools = callPackage ../tools/graphics/pfstools { };

  philter = callPackage ../tools/networking/philter { };

  phodav = callPackage ../tools/networking/phodav { };

  pinentry = libsForQt5.callPackage ../tools/security/pinentry {
    libcap = if stdenv.isDarwin then null else libcap;
  };

  pinentry-curses = (stdenv.lib.getOutput "curses" pinentry);
  pinentry-emacs = (stdenv.lib.getOutput "emacs" pinentry);
  pinentry-gtk2 = (stdenv.lib.getOutput "gtk2" pinentry);
  pinentry-qt = (stdenv.lib.getOutput "qt" pinentry);
  pinentry-gnome = (stdenv.lib.getOutput "gnome3" pinentry);

  pinentry_mac = callPackage ../tools/security/pinentry/mac.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    xcbuildHook = xcbuild6Hook;
  };

  pingtcp = callPackage ../tools/networking/pingtcp { };

  pirate-get = callPackage ../tools/networking/pirate-get { };

  pipreqs = callPackage ../tools/misc/pipreqs { };

  pius = callPackage ../tools/security/pius { };

  pixiewps = callPackage ../tools/networking/pixiewps {};

  pk2cmd = callPackage ../tools/misc/pk2cmd { };

  plantuml = callPackage ../tools/misc/plantuml {
    # Graphviz 2.39 and 2.40 are discouraged by the PlantUML project, see
    # http://plantuml.com/faq (heading: "Which version of Graphviz should I use ?")
    graphviz = graphviz_2_32;
  };

  plan9port = callPackage ../tools/system/plan9port { };

  platformioPackages = dontRecurseIntoAttrs (callPackage ../development/arduino/platformio { });
  platformio = platformioPackages.platformio-chrootenv;

  platinum-searcher = callPackage ../tools/text/platinum-searcher { };

  playbar2 = libsForQt5.callPackage ../applications/audio/playbar2 { };

  plex = callPackage ../servers/plex { };
  plexRaw = callPackage ../servers/plex/raw.nix { };

  tab = callPackage ../tools/text/tab { };

  tautulli = callPackage ../servers/tautulli { python = python2; };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  plotinus = callPackage ../tools/misc/plotinus { };

  plotutils = callPackage ../tools/graphics/plotutils { };

  plowshare = callPackage ../tools/misc/plowshare { };

  pngcheck = callPackage ../tools/graphics/pngcheck {
    zlib = zlib.override {
      static = true;
    };
  };

  pngcrush = callPackage ../tools/graphics/pngcrush { };

  pngnq = callPackage ../tools/graphics/pngnq { };

  pngtoico = callPackage ../tools/graphics/pngtoico {
    libpng = libpng12;
  };

  pngpp = callPackage ../development/libraries/png++ { };

  pngquant = callPackage ../tools/graphics/pngquant { };

  podiff = callPackage ../tools/text/podiff { };

  podman = callPackage ../applications/virtualization/podman { };

  podman-compose = python3Packages.callPackage ../applications/virtualization/podman-compose {};

  pod2mdoc = callPackage ../tools/misc/pod2mdoc { };

  poedit = callPackage ../tools/text/poedit { };

  polipo = callPackage ../servers/polipo { };

  polkit_gnome = callPackage ../tools/security/polkit-gnome { };

  poly2tri-c = callPackage ../development/libraries/poly2tri-c { };

  polysh = callPackage ../tools/networking/polysh { };

  ponysay = callPackage ../tools/misc/ponysay { };

  popfile = callPackage ../tools/text/popfile { };

  poretools = callPackage ../applications/science/biology/poretools { };

  postscript-lexmark = callPackage ../misc/drivers/postscript-lexmark { };

  povray = callPackage ../tools/graphics/povray { };

  ppl = callPackage ../development/libraries/ppl { };

  pplatex = callPackage ../tools/typesetting/tex/pplatex { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  pptpd = callPackage ../tools/networking/pptpd {};

  pre-commit = gitAndTools.pre-commit;

  pretty-simple = callPackage ../development/tools/pretty-simple { };

  prettyping = callPackage ../tools/networking/prettyping { };

  prey-bash-client = callPackage ../tools/security/prey { };

  profile-cleaner = callPackage ../tools/misc/profile-cleaner { };

  profile-sync-daemon = callPackage ../tools/misc/profile-sync-daemon { };

  projectlibre = callPackage ../applications/misc/projectlibre { };

  projectm = callPackage ../applications/audio/projectm { };

  proot = callPackage ../tools/system/proot { };

  prototypejs = callPackage ../development/libraries/prototypejs { };

  inherit (callPackages ../tools/security/proxmark3 { gcc-arm-embedded = gcc-arm-embedded-8; })
    proxmark3 proxmark3-unstable;

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel {
    openssl = openssl_1_0_2;
  };

  pws = callPackage ../tools/misc/pws { };

  cntlm = callPackage ../tools/networking/cntlm { };

  pastebinit = callPackage ../tools/misc/pastebinit { };

  pmacct = callPackage ../tools/networking/pmacct { };

  polygraph = callPackage ../tools/networking/polygraph { };

  progress = callPackage ../tools/misc/progress { };

  ps3netsrv = callPackage ../servers/ps3netsrv { };

  pscircle = callPackage ../os-specific/linux/pscircle { };

  psmisc = callPackage ../os-specific/linux/psmisc { };

  pssh = callPackage ../tools/networking/pssh { };

  pspg = callPackage ../tools/misc/pspg { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  psutils = callPackage ../tools/typesetting/psutils { };

  psensor = callPackage ../tools/system/psensor {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  pubs = callPackage ../tools/misc/pubs {};

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pwgen-secure = callPackage ../tools/security/pwgen-secure { };

  pwnat = callPackage ../tools/networking/pwnat { };

  pwndbg = callPackage ../development/tools/misc/pwndbg { };

  pycangjie = pythonPackages.pycangjie;

  pydb = callPackage ../development/tools/pydb { };

  pydf = callPackage ../applications/misc/pydf { };

  pympress = callPackage ../applications/office/pympress { };

  pythonIRClib = pythonPackages.pythonIRClib;

  pyditz = callPackage ../applications/misc/pyditz {
    pythonPackages = python27Packages;
  };

  pytrainer = callPackage ../applications/misc/pytrainer { };

  pywal = with python3Packages; toPythonApplication pywal;

  remarshal = callPackage ../development/tools/remarshal { };

  rig = callPackage ../tools/misc/rig {
    stdenv = gccStdenv;
  };

  rocket = libsForQt5.callPackage ../tools/graphics/rocket { };

  rtaudio = callPackage ../development/libraries/audio/rtaudio { };

  rtmidi = callPackage ../development/libraries/audio/rtmidi { };

  openmpi = callPackage ../development/libraries/openmpi { };

  ucx = callPackage ../development/libraries/ucx {};

  openmodelica = callPackage ../applications/science/misc/openmodelica { };

  qarte = libsForQt5.callPackage ../applications/video/qarte { };

  qlcplus = libsForQt5.callPackage ../applications/misc/qlcplus { };

  qnial = callPackage ../development/interpreters/qnial { };

  ocz-ssd-guru = callPackage ../tools/misc/ocz-ssd-guru { };

  q-text-as-data = callPackage ../tools/misc/q-text-as-data { };

  qalculate-gtk = callPackage ../applications/science/math/qalculate-gtk { };

  qastools = libsForQt5.callPackage ../tools/audio/qastools { };

  qdigidoc = libsForQt5.callPackage ../tools/security/qdigidoc { } ;

  qgrep = callPackage ../tools/text/qgrep {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreFoundation;
  };

  qhull = callPackage ../development/libraries/qhull { };

  qjoypad = callPackage ../tools/misc/qjoypad { };

  qownnotes = libsForQt5.callPackage ../applications/office/qownnotes { };

  qpdf = callPackage ../development/libraries/qpdf { };

  qprint = callPackage ../tools/text/qprint { };

  qscintilla = callPackage ../development/libraries/qscintilla { };

  qshowdiff = callPackage ../tools/text/qshowdiff { };

  qr-filetransfer = callPackage ../tools/networking/qr-filetransfer { };

  qtikz = libsForQt5.callPackage ../applications/graphics/ktikz { };

  quickjs = callPackage ../development/interpreters/quickjs { };

  quickserve = callPackage ../tools/networking/quickserve { };

  quicktun = callPackage ../tools/networking/quicktun { };

  quilt = callPackage ../development/tools/quilt { };

  quota = if stdenv.isLinux then linuxquota else unixtools.quota;

  qview = libsForQt5.callPackage ../applications/graphics/qview {};

  wayback_machine_downloader = callPackage ../applications/networking/wayback_machine_downloader { };

  wiggle = callPackage ../development/tools/wiggle { };

  radamsa = callPackage ../tools/security/radamsa { };

  radarr = callPackage ../servers/radarr { };

  radeon-profile = libsForQt5.callPackage ../tools/misc/radeon-profile { };

  radsecproxy = callPackage ../tools/networking/radsecproxy { };

  radvd = callPackage ../tools/networking/radvd { };

  rainbowstream = pythonPackages.rainbowstream;

  rambox = callPackage ../applications/networking/instant-messengers/rambox { };

  rambox-pro = callPackage ../applications/networking/instant-messengers/rambox/pro.nix { };

  ranger = callPackage ../applications/misc/ranger { };

  rarcrack = callPackage ../tools/security/rarcrack { };

  rarian = callPackage ../development/libraries/rarian { };

  ratools = callPackage ../tools/networking/ratools { };

  rawdog = callPackage ../applications/networking/feedreaders/rawdog { };

  rc = callPackage ../shells/rc { };

  rdbtools = callPackage ../development/tools/rdbtools { python = python3; };

  rdma-core = callPackage ../os-specific/linux/rdma-core { };

  react-native-debugger = callPackage ../development/tools/react-native-debugger { };

  read-edid = callPackage ../os-specific/linux/read-edid { };

  redir = callPackage ../tools/networking/redir { };

  # failed to build websocket-driver gem with ruby 2.6, so sticking to 2.5 for now
  redmine = callPackage ../applications/version-management/redmine { ruby = pkgs.ruby_2_5; };

  redsocks = callPackage ../tools/networking/redsocks { };

  reredirect = callPackage ../tools/misc/reredirect { };

  retext = libsForQt5.callPackage ../applications/editors/retext { };

  richgo = callPackage ../development/tools/richgo {  };

  rst2html5 = callPackage ../tools/text/rst2html5 { };

  rt = callPackage ../servers/rt { };

  rtmpdump = callPackage ../tools/video/rtmpdump { };
  rtmpdump_gnutls = rtmpdump.override { gnutlsSupport = true; opensslSupport = false; };

  rtptools = callPackage ../tools/networking/rtptools { };

  reaverwps = callPackage ../tools/networking/reaver-wps {};

  reaverwps-t6x = callPackage ../tools/networking/reaver-wps-t6x {};

  rx = callPackage ../applications/graphics/rx { };

  qt-box-editor = libsForQt5.callPackage ../applications/misc/qt-box-editor { };

  recutils = callPackage ../tools/misc/recutils { };

  recoll = callPackage ../applications/search/recoll { };

  reflex = callPackage ../development/tools/reflex { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome2) gnome_vfs GConf;
  };

  remarkjs = callPackage ../development/web/remarkjs { };

  alarm-clock-applet = callPackage ../tools/misc/alarm-clock-applet { };

  remind = callPackage ../tools/misc/remind { };

  remmina = callPackage ../applications/networking/remote/remmina { };

  rename = callPackage ../tools/misc/rename { };

  renameutils = callPackage ../tools/misc/renameutils { };

  renderdoc = libsForQt5.callPackage ../applications/graphics/renderdoc { };

  replace = callPackage ../tools/text/replace { };

  reckon = callPackage ../tools/text/reckon { };

  recoverjpeg = callPackage ../tools/misc/recoverjpeg { };

  reftools = callPackage ../development/tools/reftools { };

  reposurgeon = callPackage ../applications/version-management/reposurgeon { };

  reptyr = callPackage ../os-specific/linux/reptyr {};

  rescuetime = libsForQt5.callPackage ../applications/misc/rescuetime { };

  reuse = callPackage ../tools/package-management/reuse { };

  rewritefs = callPackage ../os-specific/linux/rewritefs { };

  rdiff-backup = callPackage ../tools/backup/rdiff-backup { };

  rdfind = callPackage ../tools/filesystems/rdfind { };

  rhash = callPackage ../tools/security/rhash { };

  riemann_c_client = callPackage ../tools/misc/riemann-c-client { };
  riemann-tools = callPackage ../tools/misc/riemann-tools { };

  ripmime = callPackage ../tools/networking/ripmime {};

  rkflashtool = callPackage ../tools/misc/rkflashtool { };

  rkrlv2 = callPackage ../applications/audio/rkrlv2 {};

  rmlint = callPackage ../tools/misc/rmlint {
    inherit (pythonPackages) sphinx;
  };

  rng-tools = callPackage ../tools/security/rng-tools { };

  rnnoise = callPackage ../development/libraries/rnnoise { };

  rnv = callPackage ../tools/text/xml/rnv { };

  rosie = callPackage ../tools/text/rosie { };

  rounded-mgenplus = callPackage ../data/fonts/rounded-mgenplus { };

  roundup = callPackage ../tools/misc/roundup { };

  routino = callPackage ../tools/misc/routino { };

  rq = callPackage ../development/tools/rq {
    inherit (darwin) libiconv;
  };

  rsnapshot = callPackage ../tools/backup/rsnapshot { };

  rlwrap = callPackage ../tools/misc/rlwrap { };

  rmtrash = callPackage ../tools/misc/rmtrash { };

  rockbox_utility = libsForQt5.callPackage ../tools/misc/rockbox-utility { };

  rosegarden = libsForQt5.callPackage ../applications/audio/rosegarden { };

  rowhammer-test = callPackage ../tools/system/rowhammer-test { };

  rpPPPoE = callPackage ../tools/networking/rp-pppoe { };

  rpiboot-unstable = callPackage ../development/misc/rpiboot/unstable.nix { };

  rpm = callPackage ../tools/package-management/rpm { };

  rpm-ostree = callPackage ../tools/misc/rpm-ostree {
    gperf = gperf_3_0;
  };

  rpmextract = callPackage ../tools/archivers/rpmextract { };

  rrdtool = callPackage ../tools/misc/rrdtool { };

  rsibreak = libsForQt5.callPackage ../applications/misc/rsibreak { };

  rss2email = callPackage ../applications/networking/feedreaders/rss2email {
    pythonPackages = python3Packages;
  };

  rsstail = callPackage ../applications/networking/feedreaders/rsstail { };

  rtorrent = callPackage ../tools/networking/p2p/rtorrent { };

  rubber = callPackage ../tools/typesetting/rubber { };

  rubocop = callPackage ../development/tools/rubocop { };

  runelite = callPackage ../games/runelite {
    jre = openjdk11;
  };

  runningx = callPackage ../tools/X11/runningx { };

  rund = callPackage ../development/tools/rund { };

  runzip = callPackage ../tools/archivers/runzip { };

  ruplacer = callPackage ../tools/text/ruplacer {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rw = callPackage ../tools/misc/rw { };

  rxp = callPackage ../tools/text/xml/rxp { };

  rzip = callPackage ../tools/compression/rzip { };

  s-tui = callPackage ../tools/system/s-tui { };

  s3backer = callPackage ../tools/filesystems/s3backer { };

  s3bro = callPackage ../tools/admin/s3bro { };

  s3fs = callPackage ../tools/filesystems/s3fs { };

  s3cmd = callPackage ../tools/networking/s3cmd { };

  s4cmd = callPackage ../tools/networking/s4cmd { };

  s3gof3r = callPackage ../tools/networking/s3gof3r { };

  s6-dns = skawarePackages.s6-dns;

  s6-linux-utils = skawarePackages.s6-linux-utils;

  s6-networking = skawarePackages.s6-networking;

  s6-portable-utils = skawarePackages.s6-portable-utils;

  safecopy = callPackage ../tools/system/safecopy { };

  sacd = callPackage ../tools/cd-dvd/sacd { };

  safe = callPackage ../tools/security/safe { };

  safe-rm = callPackage ../tools/system/safe-rm { };

  safeeyes = callPackage ../applications/misc/safeeyes { };

  sahel-fonts = callPackage ../data/fonts/sahel-fonts { };

  saldl = callPackage ../tools/networking/saldl { };

  salt = callPackage ../tools/admin/salt {};

  salut_a_toi = callPackage ../applications/networking/instant-messengers/salut-a-toi {};

  samim-fonts = callPackage ../data/fonts/samim-fonts {};

  saml2aws = callPackage ../tools/security/saml2aws {};

  samplicator = callPackage ../tools/networking/samplicator { };

  sasquatch = callPackage ../tools/filesystems/sasquatch { };

  sasview = callPackage ../applications/science/misc/sasview {};

  scallion = callPackage ../tools/security/scallion { };

  scanbd = callPackage ../tools/graphics/scanbd { };

  scdoc = callPackage ../tools/typesetting/scdoc { };

  scream-receivers = callPackage ../misc/scream-receivers {
    pulseSupport = config.pulseaudio or false;
  };

  screen = callPackage ../tools/misc/screen {
    inherit (darwin.apple_sdk.libs) utmp;
  };

  scrcpy = callPackage ../misc/scrcpy {
    inherit (androidenv.androidPkgs_9_0) platform-tools;
  };

  screen-message = callPackage ../tools/X11/screen-message { };

  screencloud = callPackage ../applications/graphics/screencloud {
    quazip = quazip_qt4;
  };

  screenkey = python2Packages.callPackage ../applications/video/screenkey { };

  quazip_qt4 = libsForQt5.quazip.override {
    qtbase = qt4;
  };

  scfbuild = python3.pkgs.callPackage ../tools/misc/scfbuild { };

  scriptaculous = callPackage ../development/libraries/scriptaculous { };

  scrot = callPackage ../tools/graphics/scrot { };

  scrypt = callPackage ../tools/security/scrypt { };

  sd = callPackage ../tools/text/sd {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  sdate = callPackage ../tools/misc/sdate { };

  sdcv = callPackage ../applications/misc/sdcv { };

  sdl-jstest = callPackage ../tools/misc/sdl-jstest { };

  skim = callPackage ../tools/misc/skim { };

  sec = callPackage ../tools/admin/sec { };

  seccure = callPackage ../tools/security/seccure { };

  secp256k1 = callPackage ../tools/security/secp256k1 { };

  securefs = callPackage ../tools/filesystems/securefs { };

  seexpr = callPackage ../development/compilers/seexpr { };

  setroot = callPackage  ../tools/X11/setroot { };

  setserial = callPackage ../tools/system/setserial { };

  seqdiag = with python3Packages; toPythonApplication seqdiag;

  sequoia = callPackage ../tools/security/sequoia {
    pythonPackages = python3Packages;
  };

  sewer = callPackage ../tools/admin/sewer { };

  screenfetch = callPackage ../tools/misc/screenfetch { };

  sg3_utils = callPackage ../tools/system/sg3_utils { };

  sha1collisiondetection = callPackage ../tools/security/sha1collisiondetection { };

  shadowsocks-libev = callPackage ../tools/networking/shadowsocks-libev { };

  go-shadowsocks2 = callPackage ../tools/networking/go-shadowsocks2 { };

  shabnam-fonts = callPackage ../data/fonts/shabnam-fonts { };

  shadowsocks-rust = callPackage ../tools/networking/shadowsocks-rust {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  sharutils = callPackage ../tools/archivers/sharutils { };

  shelldap = callPackage ../tools/misc/shelldap { };

  schema2ldif = callPackage ../tools/text/schema2ldif { };

  shocco = callPackage ../tools/text/shocco { };

  shorewall = callPackage ../tools/networking/shorewall { };

  shotwell = callPackage ../applications/graphics/shotwell { };

  shout = nodePackages.shout;

  shellinabox = callPackage ../servers/shellinabox {
    openssl = openssl_1_0_2;
  };

  shrikhand = callPackage ../data/fonts/shrikhand { };

  shunit2 = callPackage ../tools/misc/shunit2 { };

  sic = callPackage ../applications/networking/irc/sic { };

  siege = callPackage ../tools/networking/siege {};

  sieve-connect = callPackage ../applications/networking/sieve-connect {};

  sigal = callPackage ../applications/misc/sigal { };

  sigil = libsForQt5.callPackage ../applications/editors/sigil { };

  signal-cli = callPackage ../applications/networking/instant-messengers/signal-cli { };

  signal-desktop = callPackage ../applications/networking/instant-messengers/signal-desktop { };

  slither-analyzer = with python3Packages; toPythonApplication slither-analyzer;

  signify = callPackage ../tools/security/signify { };

  # aka., pgp-tools
  signing-party = callPackage ../tools/security/signing-party { };

  silc_client = callPackage ../applications/networking/instant-messengers/silc-client { };

  silc_server = callPackage ../servers/silc-server { };

  sile = callPackage ../tools/typesetting/sile { };

  silver-searcher = callPackage ../tools/text/silver-searcher { };

  simpleproxy = callPackage ../tools/networking/simpleproxy { };

  simplescreenrecorder = libsForQt5.callPackage ../applications/video/simplescreenrecorder { };

  sipsak = callPackage ../tools/networking/sipsak { };

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  sit = callPackage ../applications/version-management/sit {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  sixpair = callPackage ../tools/misc/sixpair {};

  skippy-xd = callPackage ../tools/X11/skippy-xd {};

  sks = callPackage ../servers/sks { inherit (ocaml-ng.ocamlPackages_4_02) ocaml camlp4; };

  skydns = callPackage ../servers/skydns { };

  sipcalc = callPackage ../tools/networking/sipcalc { };

  skribilo = callPackage ../tools/typesetting/skribilo {
    tex = texlive.combined.scheme-small;
  };

  sleuthkit = callPackage ../tools/system/sleuthkit {};

  sleepyhead = callPackage ../applications/misc/sleepyhead {};

  slimrat = callPackage ../tools/networking/slimrat { };

  slirp4netns = callPackage ../tools/networking/slirp4netns/default.nix { };

  slsnif = callPackage ../tools/misc/slsnif { };

  slstatus = callPackage ../applications/misc/slstatus {
    conf = config.slstatus.conf or null;
  };

  smartdns = callPackage ../tools/networking/smartdns { };

  smartmontools = callPackage ../tools/system/smartmontools {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
  };

  smarty3 = callPackage ../development/libraries/smarty3 { };
  smarty3-i18n = callPackage ../development/libraries/smarty3-i18n { };

  smbnetfs = callPackage ../tools/filesystems/smbnetfs {};

  smenu = callPackage ../tools/misc/smenu { };

  smesh = callPackage ../development/libraries/smesh {};

  smu = callPackage ../tools/text/smu { };

  smugline = python3Packages.smugline;

  snabb = callPackage ../tools/networking/snabb { } ;

  snapcast = callPackage ../applications/audio/snapcast { };

  sng = callPackage ../tools/graphics/sng {
    libpng = libpng12;
  };

  snort = callPackage ../applications/networking/ids/snort { };

  soapui = callPackage ../applications/networking/soapui { };

  sshguard = callPackage ../tools/security/sshguard {};

  sshping = callPackage ../tools/networking/sshping {};

  suricata = callPackage ../applications/networking/ids/suricata {
    python = python3;
  };

  softhsm = callPackage ../tools/security/softhsm {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  solr = callPackage ../servers/search/solr { };
  solr_7 = solr;
  solr_8 = solr;

  solvespace = callPackage ../applications/graphics/solvespace { };

  sonarr = callPackage ../servers/sonarr { };

  sonata = callPackage ../applications/audio/sonata { };

  soundkonverter = kdeApplications.callPackage ../applications/audio/soundkonverter {};

  sozu = callPackage ../servers/sozu { };

  sparsehash = callPackage ../development/libraries/sparsehash { };

  spectre-meltdown-checker = callPackage ../tools/security/spectre-meltdown-checker { };

  spiped = callPackage ../tools/networking/spiped { };

  sqliteman = callPackage ../applications/misc/sqliteman { };

  stdman = callPackage ../data/documentation/stdman { };

  stenc = callPackage ../tools/backup/stenc { };

  stm32loader = with python3Packages; toPythonApplication stm32loader;

  storebrowse = callPackage ../tools/system/storebrowse { };

  stubby = callPackage ../tools/networking/stubby { };

  syntex = callPackage ../tools/graphics/syntex {};

  sl = callPackage ../tools/misc/sl { stdenv = gccStdenv; };

  socat = callPackage ../tools/networking/socat { };

  socat2pre = lowPrio (callPackage ../tools/networking/socat/2.x.nix { });

  solaar = callPackage ../applications/misc/solaar {};

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  spaceFM = callPackage ../applications/misc/spacefm { };

  speech-denoiser = callPackage ../applications/audio/speech-denoiser {};

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  squashfs-tools-ng = callPackage ../tools/filesystems/squashfs-tools-ng { };

  squashfuse = callPackage ../tools/filesystems/squashfuse { };

  srcml = callPackage ../applications/version-management/srcml { };

  srt-to-vtt-cl = callPackage ../tools/cd-dvd/srt-to-vtt-cl { };

  sourcehut = callPackage ../applications/version-management/sourcehut { };

  sshfs-fuse = callPackage ../tools/filesystems/sshfs-fuse { };
  sshfs = sshfs-fuse; # added 2017-08-14

  sshlatex = callPackage ../tools/typesetting/sshlatex { };

  sshuttle = callPackage ../tools/security/sshuttle { };

  ssldump = callPackage ../tools/networking/ssldump { };

  sslsplit = callPackage ../tools/networking/sslsplit { };

  sstp = callPackage ../tools/networking/sstp {};

  strip-nondeterminism = perlPackages.strip-nondeterminism;

  structure-synth = callPackage ../tools/graphics/structure-synth { };

  su-exec = callPackage ../tools/security/su-exec {};

  subberthehut = callPackage ../tools/misc/subberthehut { };

  subsurface = libsForQt5.callPackage ../applications/misc/subsurface { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = callPackage ../tools/system/suid-chroot { };

  sundtek = callPackage ../misc/drivers/sundtek { };

  sunxi-tools = callPackage ../development/tools/sunxi-tools { };

  sumorobot-manager = python3Packages.callPackage ../applications/science/robotics/sumorobot-manager { };

  super = callPackage ../tools/security/super { };

  supertux-editor = callPackage ../applications/editors/supertux-editor { };

  super-user-spark = haskellPackages.callPackage ../applications/misc/super_user_spark { };

  svgbob = callPackage ../tools/graphics/svgbob { };

  svgcleaner = callPackage ../tools/graphics/svgcleaner { };

  ssb-patchwork = callPackage ../applications/networking/ssb/patchwork { };

  ssdeep = callPackage ../tools/security/ssdeep { };

  ssh-ident = callPackage ../tools/networking/ssh-ident { };

  sshpass = callPackage ../tools/networking/sshpass { };

  sslscan = callPackage ../tools/security/sslscan {
    openssl = openssl_1_0_2.override { enableSSL2 = true; };
  };

  sslmate = callPackage ../development/tools/sslmate { };

  sshoogr = callPackage ../tools/networking/sshoogr { };

  ssmtp = callPackage ../tools/networking/ssmtp { };

  ssocr = callPackage ../applications/misc/ssocr { };

  ssss = callPackage ../tools/security/ssss { };

  stabber = callPackage ../misc/stabber { };

  stress = callPackage ../tools/system/stress { };

  stress-ng = callPackage ../tools/system/stress-ng { };

  stoken = callPackage ../tools/security/stoken (config.stoken or {});

  storeBackup = callPackage ../tools/backup/store-backup { };

  stow = callPackage ../tools/misc/stow { };

  stun = callPackage ../tools/networking/stun { };

  stunnel = callPackage ../tools/networking/stunnel { };

  stutter = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.stutter) (drv: {
    preCheck = "export PATH=dist/build/stutter:$PATH";
  });

  strongswan    = callPackage ../tools/networking/strongswan { };
  strongswanTNC = strongswan.override { enableTNC = true; };
  strongswanNM  = strongswan.override { enableNetworkManager = true; };

  stylish-haskell = haskell.lib.justStaticExecutables haskellPackages.stylish-haskell;

  su = shadow.su;

  subsonic = callPackage ../servers/misc/subsonic { };

  subfinder = callPackage ../tools/networking/subfinder { };

  surfraw = callPackage ../tools/networking/surfraw { };

  swagger-codegen = callPackage ../tools/networking/swagger-codegen { };

  swec = callPackage ../tools/networking/swec { };

  swfdec = callPackage ../tools/graphics/swfdec {};

  svnfs = callPackage ../tools/filesystems/svnfs { };

  svtplay-dl = callPackage ../tools/misc/svtplay-dl { };

  sycl-info = callPackage ../development/libraries/sycl-info { };

  symengine = callPackage ../development/libraries/symengine { };

  sysbench = callPackage ../development/tools/misc/sysbench {};

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    libxml2 = libxml2Python;
   };

  stricat = callPackage ../tools/security/stricat { };

  staruml = callPackage ../tools/misc/staruml { inherit (gnome2) GConf; libgcrypt = libgcrypt_1_5; };

  stone-phaser = callPackage ../applications/audio/stone-phaser { };

  systrayhelper = callPackage ../tools/misc/systrayhelper {};

  Sylk = callPackage ../applications/networking/Sylk {};

  privoxy = callPackage ../tools/networking/privoxy {
    w3m = w3m-batch;
  };

  swaks = callPackage ../tools/networking/swaks { };

  swiften = callPackage ../development/libraries/swiften { };

  t = callPackage ../tools/misc/t { };

  t1utils = callPackage ../tools/misc/t1utils { };

  talkfilters = callPackage ../misc/talkfilters {};

  znapzend = callPackage ../tools/backup/znapzend { };

  targetcli = callPackage ../os-specific/linux/targetcli { };

  tarsnap = callPackage ../tools/backup/tarsnap { };

  tarsnapper = callPackage ../tools/backup/tarsnapper { };

  tayga = callPackage ../tools/networking/tayga { };

  tcpcrypt = callPackage ../tools/security/tcpcrypt { };

  tcptraceroute = callPackage ../tools/networking/tcptraceroute { };

  tboot = callPackage ../tools/security/tboot { };

  tcpdump = callPackage ../tools/networking/tcpdump { };

  tcpflow = callPackage ../tools/networking/tcpflow { };

  tcpkali = callPackage ../applications/networking/tcpkali { };

  tcpreplay = callPackage ../tools/networking/tcpreplay { };

  tdns-cli = callPackage ../tools/networking/tdns-cli { };

  ted = callPackage ../tools/typesetting/ted { };

  teamviewer = libsForQt5.callPackage ../applications/networking/remote/teamviewer { };

  teleconsole = callPackage ../tools/misc/teleconsole { };

  telegraf = callPackage ../servers/monitoring/telegraf { };

  teleport = callPackage ../servers/teleport {};

  telepresence = callPackage ../tools/networking/telepresence {
    pythonPackages = python3Packages;
  };

  termplay = callPackage ../tools/misc/termplay { };

  tewisay = callPackage ../tools/misc/tewisay { };

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

  textadept = callPackage ../applications/editors/textadept { };

  texworks = libsForQt5.callPackage ../applications/editors/texworks { };

  thc-hydra = callPackage ../tools/security/thc-hydra { };

  theharvester = callPackage ../tools/security/theharvester { };

  inherit (nodePackages) thelounge;

  thefuck = python3Packages.callPackage ../tools/misc/thefuck { };

  thin-provisioning-tools = callPackage ../tools/misc/thin-provisioning-tools {  };

  thinkpad-scripts = python3.pkgs.callPackage ../tools/misc/thinkpad-scripts { };

  tiled = libsForQt5.callPackage ../applications/editors/tiled { };

  tiledb = callPackage ../development/libraries/tiledb { };

  timemachine = callPackage ../applications/audio/timemachine { };

  timelapse-deflicker = callPackage ../applications/graphics/timelapse-deflicker { };

  timetrap = callPackage ../applications/office/timetrap { };

  timetable = callPackage ../applications/office/timetable { };

  tzupdate = callPackage ../applications/misc/tzupdate { };

  tinc = callPackage ../tools/networking/tinc { };

  tie = callPackage ../development/tools/misc/tie { };

  tikzit = libsForQt5.callPackage ../tools/typesetting/tikzit { };

  tilix = callPackage ../applications/misc/tilix { };

  tinc_pre = callPackage ../tools/networking/tinc/pre.nix {};

  tiny8086 = callPackage ../applications/virtualization/8086tiny { };

  tinyemu = callPackage ../applications/virtualization/tinyemu { };

  tinyfecvpn = callPackage ../tools/networking/tinyfecvpn {};

  tinyprog = callPackage ../development/tools/misc/tinyprog { };

  tinyproxy = callPackage ../tools/networking/tinyproxy {};

  tio = callPackage ../tools/misc/tio { };

  tldr = callPackage ../tools/misc/tldr { };

  tldr-hs = haskellPackages.tldr;

  tlspool = callPackage ../tools/networking/tlspool { };

  tmate = callPackage ../tools/misc/tmate { };

  tmate-ssh-server = callPackage ../servers/tmate-ssh-server { };

  tmpwatch = callPackage ../tools/misc/tmpwatch  { };

  tmux = callPackage ../tools/misc/tmux { };

  tmux-cssh = callPackage ../tools/misc/tmux-cssh { };

  tmuxp = callPackage ../tools/misc/tmuxp { };

  tmuxinator = callPackage ../tools/misc/tmuxinator { };

  tmux-xpanes = callPackage ../tools/misc/tmux-xpanes { };

  tmuxPlugins = recurseIntoAttrs (callPackage ../misc/tmux-plugins { });

  tmsu = callPackage ../tools/filesystems/tmsu { };

  toilet = callPackage ../tools/misc/toilet { };

  tokei = callPackage ../development/tools/misc/tokei { };

  toml2nix = (callPackage ../tools/toml2nix { }).toml2nix { };

  topgrade = callPackage ../tools/misc/topgrade {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  tor = callPackage ../tools/security/tor {
    # remove this, when libevent's openssl is upgraded to 1_1_0 or newer.
    libevent = libevent.override {
      sslSupport = false;
    };
  };

  tor-arm = callPackage ../tools/security/tor/tor-arm.nix { };

  tor-browser-bundle-bin = callPackage ../applications/networking/browsers/tor-browser-bundle-bin { };

  touchegg = callPackage ../tools/inputmethods/touchegg { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  tox-node = callPackage ../tools/networking/tox-node { };

  toxvpn = callPackage ../tools/networking/toxvpn { };

  toybox = callPackage ../tools/misc/toybox { };

  tpmmanager = callPackage ../applications/misc/tpmmanager { };

  tpm-quote-tools = callPackage ../tools/security/tpm-quote-tools { };

  tpm-tools = callPackage ../tools/security/tpm-tools { };

  tpm-luks = callPackage ../tools/security/tpm-luks { };

  tpm2-abrmd = callPackage ../tools/security/tpm2-abrmd { };

  tpm2-pkcs11 = callPackage ../misc/tpm2-pkcs11 { };

  tpm2-tools = callPackage ../tools/security/tpm2-tools { };

  trezor-udev-rules = callPackage ../os-specific/linux/trezor-udev-rules {};

  trezord = callPackage ../servers/trezord { };

  trezor_agent = with python3Packages; toPythonApplication trezor_agent;

  tthsum = callPackage ../applications/misc/tthsum { };

  chaps = callPackage ../tools/security/chaps { };

  trace-cmd = callPackage ../os-specific/linux/trace-cmd { };

  kernelshark = libsForQt5.callPackage ../os-specific/linux/trace-cmd/kernelshark.nix { };

  traceroute = callPackage ../tools/networking/traceroute { };

  tracebox = callPackage ../tools/networking/tracebox { };

  tracefilegen = callPackage ../development/tools/analysis/garcosim/tracefilegen { };

  tracefilesim = callPackage ../development/tools/analysis/garcosim/tracefilesim { };

  transifex-client = python3.pkgs.callPackage ../tools/text/transifex-client { };

  translate-shell = callPackage ../applications/misc/translate-shell { };

  trash-cli = callPackage ../tools/misc/trash-cli { };

  trebleshot = libsForQt5.callPackage ../applications/networking/trebleshot { };

  trickle = callPackage ../tools/networking/trickle {};

  inherit (nodePackages) triton;

  triggerhappy = callPackage ../tools/inputmethods/triggerhappy {};

  inherit (callPackage ../applications/office/trilium {})
    trilium-desktop
    trilium-server
    ;
  trilium = trilium-desktop;

  trousers = callPackage ../tools/security/trousers { };

  trx = callPackage ../tools/audio/trx { };

  tryton = callPackage ../applications/office/tryton { };

  trytond = callPackage ../applications/office/trytond { };

  omapd = callPackage ../tools/security/omapd { };

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ttfautohint = libsForQt5.callPackage ../tools/misc/ttfautohint { };
  ttfautohint-nox = ttfautohint.override { enableGUI = false; };

  tty-clock = callPackage ../tools/misc/tty-clock { };

  ttyplot = callPackage ../tools/misc/ttyplot { };

  ttyrec = callPackage ../tools/misc/ttyrec { };

  ttygif = callPackage ../tools/misc/ttygif { };

  ttylog = callPackage ../tools/misc/ttylog { };

  ipbt = callPackage ../tools/misc/ipbt { };

  tuir = callPackage ../applications/misc/tuir { };

  turses = callPackage ../applications/networking/instant-messengers/turses { };

  oysttyer = callPackage ../applications/networking/instant-messengers/oysttyer { };

  twilight = callPackage ../tools/graphics/twilight {
    libX11 = xorg.libX11;
  };

  twitterBootstrap = callPackage ../development/web/twitter-bootstrap {};

  txr = callPackage ../tools/misc/txr { stdenv = clangStdenv; };

  txt2man = callPackage ../tools/misc/txt2man { };

  txt2tags = callPackage ../tools/text/txt2tags { };

  txtw = callPackage ../tools/misc/txtw { };

  u9fs = callPackage ../servers/u9fs { };

  ua = callPackage ../tools/networking/ua { };

  uberwriter = callPackage ../applications/editors/uberwriter {
    pythonPackages = python3Packages;
  };

  ubridge = callPackage ../tools/networking/ubridge { };

  ucl = callPackage ../development/libraries/ucl { };

  ucspi-tcp = callPackage ../tools/networking/ucspi-tcp { };

  udftools = callPackage ../tools/filesystems/udftools {};

  udpt = callPackage ../servers/udpt { };

  udptunnel = callPackage ../tools/networking/udptunnel { };

  ufraw = callPackage ../applications/graphics/ufraw {
    stdenv = gcc6Stdenv; # doesn't build with gcc7
  };

  uftrace = callPackage ../development/tools/uftrace { };

  uget = callPackage ../tools/networking/uget { };

  uget-integrator = callPackage ../tools/networking/uget-integrator { };

  uif2iso = callPackage ../tools/cd-dvd/uif2iso { };

  umlet = callPackage ../tools/misc/umlet { };

  unetbootin = callPackage ../tools/cd-dvd/unetbootin { };

  unfs3 = callPackage ../servers/unfs3 { };

  unoconv = callPackage ../tools/text/unoconv { };

  unrtf = callPackage ../tools/text/unrtf { };

  untex = callPackage ../tools/text/untex { };

  untrunc = callPackage ../tools/video/untrunc { };

  up = callPackage ../tools/misc/up { };

  upx = callPackage ../tools/compression/upx { };

  uq = callPackage ../misc/uq { };

  uqmi = callPackage ../tools/networking/uqmi { };

  uriparser = callPackage ../development/libraries/uriparser {};

  urlscan = callPackage ../applications/misc/urlscan { };

  urlview = callPackage ../applications/misc/urlview {};

  usbmuxd = callPackage ../tools/misc/usbmuxd {};

  usync = callPackage ../applications/misc/usync { };

  uwsgi = callPackage ../servers/uwsgi { };

  v2ray = callPackage ../tools/networking/v2ray { };

  vacuum = callPackage ../applications/networking/instant-messengers/vacuum {};

  vampire = callPackage ../applications/science/logic/vampire {};

  variety = callPackage ../applications/misc/variety {};

  vdmfec = callPackage ../applications/backup/vdmfec {};

  vk-messenger = callPackage ../applications/networking/instant-messengers/vk-messenger {};

  volatility = callPackage ../tools/security/volatility { };

  vbetool = callPackage ../tools/system/vbetool { };

  vde2 = callPackage ../tools/networking/vde2 { };

  vboot_reference = callPackage ../tools/system/vboot_reference {};

  vcftools = callPackage ../applications/science/biology/vcftools { };

  vcsh = callPackage ../applications/version-management/vcsh { };

  vcs_query = callPackage ../tools/misc/vcs_query { };

  vcstool = callPackage ../development/tools/vcstool { };

  verilator = callPackage ../applications/science/electronics/verilator {};

  verilog = callPackage ../applications/science/electronics/verilog {};

  video2midi = callPackage ../tools/audio/video2midi {
    pythonPackages = python3Packages;
  };

  vifm = callPackage ../applications/misc/vifm { };

  vifm-full = callPackage ../applications/misc/vifm {
    mediaSupport = true;
    inherit lib udisks2 python3;
  };

  viking = callPackage ../applications/misc/viking {
    inherit (gnome2) scrollkeeper;
  };

  vim-vint = callPackage ../development/tools/vim-vint { };

  vimer = callPackage ../tools/misc/vimer { };

  vimpager = callPackage ../tools/misc/vimpager { };
  vimpager-latest = callPackage ../tools/misc/vimpager/latest.nix { };

  vimwiki-markdown = python3Packages.callPackage ../tools/misc/vimwiki-markdown { };

  visidata = (newScope python3Packages) ../applications/misc/visidata {
  };

  vit = callPackage ../applications/misc/vit { };

  viu = callPackage ../tools/graphics/viu { };

  vnc2flv = callPackage ../tools/video/vnc2flv {};

  vncrec = callPackage ../tools/video/vncrec { };

  vo-amrwbenc = callPackage ../development/libraries/vo-amrwbenc { };

  vobcopy = callPackage ../tools/cd-dvd/vobcopy { };

  vobsub2srt = callPackage ../tools/cd-dvd/vobsub2srt { };

  void = callPackage ../tools/misc/void { };

  volume_key = callPackage ../development/libraries/volume-key { };

  vorbisgain = callPackage ../tools/misc/vorbisgain { };

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

  ding-libs = callPackage ../tools/misc/ding-libs { };

  sssd = callPackage ../os-specific/linux/sssd {
    inherit (perlPackages) Po4a;
    inherit (python27Packages) ldap;
  };

  vtun = callPackage ../tools/networking/vtun {
    openssl = openssl_1_0_2;
  };

  waifu2x-converter-cpp = callPackage ../tools/graphics/waifu2x-converter-cpp { };

  wakatime = pythonPackages.callPackage ../tools/misc/wakatime { };

  weather = callPackage ../applications/misc/weather { };

  wego = callPackage ../applications/misc/wego { };

  wal_e = callPackage ../tools/backup/wal-e { };

  watchexec = callPackage ../tools/misc/watchexec {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  watchman = callPackage ../development/tools/watchman {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  wavefunctioncollapse = callPackage ../tools/graphics/wavefunctioncollapse {};

  wbox = callPackage ../tools/networking/wbox {};

  webassemblyjs-cli = nodePackages."@webassemblyjs/cli";
  webassemblyjs-repl = nodePackages."@webassemblyjs/repl";
  wasm-strip = nodePackages."@webassemblyjs/wasm-strip";
  wasm-text-gen = nodePackages."@webassemblyjs/wasm-text-gen";
  wast-refmt = nodePackages."@webassemblyjs/wast-refmt";

  wasm-bindgen-cli = callPackage ../development/tools/wasm-bindgen-cli {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  welkin = callPackage ../tools/graphics/welkin {};

  wf-recorder = callPackage ../applications/video/wf-recorder { };

  whipper = callPackage ../applications/audio/whipper { };

  whois = callPackage ../tools/networking/whois { };

  wifite2 = callPackage ../tools/networking/wifite2 { };

  wimboot = callPackage ../tools/misc/wimboot { };

  wireguard-tools = callPackage ../tools/networking/wireguard-tools { };

  woff2 = callPackage ../development/web/woff2 { };

  woof = callPackage ../tools/misc/woof { };

  wootility = callPackage ../tools/misc/wootility { };

  wpscan = callPackage ../tools/security/wpscan { };

  wsmancli = callPackage ../tools/system/wsmancli {};

  wstunnel = haskell.lib.justStaticExecutables
    (haskellPackages.callPackage ../tools/networking/wstunnel {});

  wolfebin = callPackage ../tools/networking/wolfebin {
    python = python2;
  };

  xautoclick = callPackage ../applications/misc/xautoclick {};

  xl2tpd = callPackage ../tools/networking/xl2tpd { };

  xe = callPackage ../tools/system/xe { };

  testdisk = libsForQt5.callPackage ../tools/system/testdisk { };

  testdisk-qt = testdisk.override { enableQt = true; };

  textql = callPackage ../development/tools/textql { };

  html2text = callPackage ../tools/text/html2text { };

  html-tidy = callPackage ../tools/text/html-tidy { };

  html-xml-utils = callPackage ../tools/text/xml/html-xml-utils { };

  htmldoc = callPackage ../tools/typesetting/htmldoc {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration Foundation;
  };

  rcm = callPackage ../tools/misc/rcm {};

  td = callPackage ../tools/misc/td { };

  tegola = callPackage ../servers/tegola {};

  tftp-hpa = callPackage ../tools/networking/tftp-hpa {};

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc xorg.fontbhlucidatypewriter75dpi ];
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = callPackage ../tools/misc/time { };

  tweet-hs = haskell.lib.justStaticExecutables haskellPackages.tweet-hs;

  qfsm = callPackage ../applications/science/electronics/qfsm { };

  tkgate = callPackage ../applications/science/electronics/tkgate/1.x.nix { };

  tm = callPackage ../tools/system/tm { };

  tradcpp = callPackage ../development/tools/tradcpp { };

  tre = callPackage ../development/libraries/tre { };

  ts = callPackage ../tools/system/ts { };

  transfig = callPackage ../tools/graphics/transfig {
    libpng = libpng12;
  };

  ttmkfdir = callPackage ../tools/misc/ttmkfdir { };

  ttwatch = callPackage ../tools/misc/ttwatch { };

  udunits = callPackage ../development/libraries/udunits { };

  uemacs = callPackage ../applications/editors/uemacs { };

  uftp = callPackage ../servers/uftp {};

  uhttpmock = callPackage ../development/libraries/uhttpmock { };

  uim = callPackage ../tools/inputmethods/uim { };

  uhub = callPackage ../servers/uhub { };

  unclutter = callPackage ../tools/misc/unclutter { };

  unclutter-xfixes = callPackage ../tools/misc/unclutter-xfixes { };

  unbound = callPackage ../tools/networking/unbound { };

  units = callPackage ../tools/misc/units {
    enableCurrenciesUpdater = true;
    pythonPackages = python3Packages;
  };

  unittest-cpp = callPackage ../development/libraries/unittest-cpp { };

  unrar = callPackage ../tools/archivers/unrar { };

  xar = callPackage ../tools/compression/xar { };

  xarchive = callPackage ../tools/archivers/xarchive { };

  xarchiver = callPackage ../tools/archivers/xarchiver { };

  xbanish = callPackage ../tools/X11/xbanish { };

  xbill = callPackage ../games/xbill { };

  xbrightness = callPackage ../tools/X11/xbrightness { };

  xkbvalidate = callPackage ../tools/X11/xkbvalidate { };

  xfstests = callPackage ../tools/misc/xfstests { };

  xprintidle-ng = callPackage ../tools/X11/xprintidle-ng {};

  xscast = callPackage ../applications/video/xscast { };

  xsettingsd = callPackage ../tools/X11/xsettingsd { };

  xsensors = callPackage ../os-specific/linux/xsensors { };

  xcruiser = callPackage ../applications/misc/xcruiser { };

  xxkb = callPackage ../applications/misc/xxkb { };

  ugarit = callPackage ../tools/backup/ugarit {
    inherit (chickenPackages_4) eggDerivation fetchegg;
  };

  ugarit-manifest-maker = callPackage ../tools/backup/ugarit-manifest-maker {
    inherit (chickenPackages_4) eggDerivation fetchegg;
  };

  unar = callPackage ../tools/archivers/unar { stdenv = clangStdenv; };

  unarj = callPackage ../tools/archivers/unarj { };

  unp = callPackage ../tools/archivers/unp { };

  unshield = callPackage ../tools/archivers/unshield { };

  unzip = callPackage ../tools/archivers/unzip { };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  undmg = callPackage ../tools/archivers/undmg { };

  uptimed = callPackage ../tools/system/uptimed { };

  urjtag = callPackage ../tools/misc/urjtag { };

  urlwatch = callPackage ../tools/networking/urlwatch { };

  valum = callPackage ../development/web/valum { };

  inherit (callPackages ../servers/varnish { })
    varnish60 varnish62 varnish63;
  inherit (callPackages ../servers/varnish/packages.nix { })
    varnish60Packages
    varnish62Packages
    varnish63Packages;

  varnishPackages = varnish63Packages;
  varnish = varnishPackages.varnish;

  hitch = callPackage ../servers/hitch { };

  venus = callPackage ../tools/misc/venus {
    python = python27;
  };

  veracrypt = callPackage ../applications/misc/veracrypt {
    wxGTK = wxGTK30;
  };

  vlan = callPackage ../tools/networking/vlan { };

  vmtouch = callPackage ../tools/misc/vmtouch { };

  vncdo = callPackage ../tools/admin/vncdo { };

  volumeicon = callPackage ../tools/audio/volumeicon { };

  waf = callPackage ../development/tools/build-managers/waf { python = python3; };
  wafHook = callPackage ../development/tools/build-managers/wafHook { };

  wagyu = callPackage ../tools/misc/wagyu { };

  wakelan = callPackage ../tools/networking/wakelan { };

  wavemon = callPackage ../tools/networking/wavemon { };

  wdfs = callPackage ../tools/filesystems/wdfs { };

  wdiff = callPackage ../tools/text/wdiff { };

  wdisplays = callPackage ../tools/graphics/wdisplays { };

  webalizer = callPackage ../tools/networking/webalizer { };

  weighttp = callPackage ../tools/networking/weighttp { };

  wget = callPackage ../tools/networking/wget {
    libpsl = null;
  };

  which = callPackage ../tools/system/which { };

  woeusb = callPackage ../tools/misc/woeusb { };

  chase = callPackage ../tools/system/chase { };

  wicd = callPackage ../tools/networking/wicd { };

  wimlib = callPackage ../tools/archivers/wimlib { };

  wipe = callPackage ../tools/security/wipe { };

  wireguard-go = callPackage ../tools/networking/wireguard-go { };

  wkhtmltopdf = libsForQt5.callPackage ../tools/graphics/wkhtmltopdf { };

  wml = callPackage ../development/web/wml { };

  wmc-mpris = callPackage ../applications/misc/web-media-controller { };

  wol = callPackage ../tools/networking/wol { };

  wolf-shaper = callPackage ../applications/audio/wolf-shaper { };

  wpgtk = callPackage ../tools/X11/wpgtk { };

  wring = nodePackages.wring;

  wrk = callPackage ../tools/networking/wrk { };

  wrk2 = callPackage ../tools/networking/wrk2 { };

  wuzz = callPackage ../tools/networking/wuzz { };

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

  wyrd = callPackage ../tools/misc/wyrd {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  x86info = callPackage ../os-specific/linux/x86info { };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = callPackage ../tools/misc/xburst-tools {
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross = pkgsCross.ben-nanonote.buildPackages.gccCrossStageStatic;
  };

  clipnotify = callPackage ../tools/misc/clipnotify { };

  xclip = callPackage ../tools/misc/xclip { };

  xcur2png = callPackage ../tools/graphics/xcur2png { };

  xcwd = callPackage ../tools/X11/xcwd { };

  xtitle = callPackage ../tools/misc/xtitle { };

  xdelta = callPackage ../tools/compression/xdelta { };
  xdeltaUnstable = callPackage ../tools/compression/xdelta/unstable.nix { };

  xdummy = callPackage ../tools/misc/xdummy { };

  xdxf2slob = callPackage ../tools/misc/xdxf2slob { };

  xe-guest-utilities = callPackage ../tools/virtualization/xe-guest-utilities { };

  xflux = callPackage ../tools/misc/xflux { };
  xflux-gui = python3Packages.callPackage ../tools/misc/xflux/gui.nix { };

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { };
  libxfs = xfsprogs.dev;

  xmage = callPackage ../games/xmage { };

  xml2 = callPackage ../tools/text/xml/xml2 { };

  xmlformat = callPackage ../tools/text/xml/xmlformat { };

  xmlroff = callPackage ../tools/typesetting/xmlroff { };

  xmloscopy = callPackage ../tools/text/xml/xmloscopy { };

  xmlstarlet = callPackage ../tools/text/xml/xmlstarlet { };

  xmlto = callPackage ../tools/typesetting/xmlto {
    w3m = w3m-batch;
  };

  xmpppy = pythonPackages.xmpppy;

  xiccd = callPackage ../tools/misc/xiccd { };

  xidlehook = callPackage ../tools/X11/xidlehook {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  xorriso = callPackage ../tools/cd-dvd/xorriso { };

  xprite-editor = callPackage ../tools/misc/xprite-editor {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  xpf = callPackage ../tools/text/xml/xpf {
    libxml2 = libxml2Python;
  };

  xsecurelock = callPackage ../tools/X11/xsecurelock {
    xset = xorg.xset;
  };

  xsel = callPackage ../tools/misc/xsel { };

  xsv = callPackage ../tools/text/xsv {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  xtreemfs = callPackage ../tools/filesystems/xtreemfs {
    boost = boost165;
  };

  xurls = callPackage ../tools/text/xurls {};

  xxv = callPackage ../tools/misc/xxv {};

  xvfb_run = callPackage ../tools/misc/xvfb-run { inherit (texFunctions) fontsConf; };

  xvkbd = callPackage ../tools/X11/xvkbd {};

  xwinmosaic = callPackage ../tools/X11/xwinmosaic {};

  xwinwrap = callPackage ../tools/X11/xwinwrap {};

  yafaray-core = callPackage ../tools/graphics/yafaray-core { };

  yaft = callPackage ../applications/misc/yaft { };

  yarn = callPackage ../development/tools/yarn  { };

  yarn2nix-moretea = callPackage ../development/tools/yarn2nix-moretea/yarn2nix { };

  inherit (yarn2nix-moretea)
    yarn2nix
    mkYarnPackage
    fixup_yarn_lock;

  yasr = callPackage ../applications/audio/yasr { };

  yank = callPackage ../tools/misc/yank { };

  yaml-merge = callPackage ../tools/text/yaml-merge { };

  yeshup = callPackage ../tools/system/yeshup { };

  ytop = callPackage ../tools/system/ytop {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  yggdrasil = callPackage ../tools/networking/yggdrasil { };

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix { };

  yj = callPackage ../development/tools/yj { };

  yle-dl = callPackage ../tools/misc/yle-dl {};

  you-get = python3Packages.callPackage ../tools/misc/you-get { };

  zasm = callPackage ../development/compilers/zasm {};

  zbackup = callPackage ../tools/backup/zbackup {};

  zbar = libsForQt5.callPackage ../tools/graphics/zbar { };

  zdelta = callPackage ../tools/compression/zdelta { };

  zerotierone = callPackage ../tools/networking/zerotierone { };

  zerofree = callPackage ../tools/filesystems/zerofree { };

  zfsbackup = callPackage ../tools/backup/zfsbackup { };

  zfstools = callPackage ../tools/filesystems/zfstools { };

  zfsnap = callPackage ../tools/backup/zfsnap { };

  zile = callPackage ../applications/editors/zile { };

  zinnia = callPackage ../tools/inputmethods/zinnia { };
  tegaki-zinnia-japanese = callPackage ../tools/inputmethods/tegaki-zinnia-japanese { };

  zimreader = callPackage ../tools/text/zimreader { };

  zimwriterfs = callPackage ../tools/text/zimwriterfs { };

  par = callPackage ../tools/text/par { };

  zip = callPackage ../tools/archivers/zip { };

  zkfuse = callPackage ../tools/filesystems/zkfuse { };

  zpaq = callPackage ../tools/archivers/zpaq { };
  zpaqd = callPackage ../tools/archivers/zpaq/zpaqd.nix { };

  zsh-autoenv = callPackage ../tools/misc/zsh-autoenv { };

  zsh-bd = callPackage ../shells/zsh/zsh-bd { };

  zsh-git-prompt = callPackage ../shells/zsh/zsh-git-prompt { };

  zsh-history = callPackage ../shells/zsh/zsh-history { };

  zsh-history-substring-search = callPackage ../shells/zsh/zsh-history-substring-search { };

  zsh-navigation-tools = callPackage ../tools/misc/zsh-navigation-tools { };

  zsh-syntax-highlighting = callPackage ../shells/zsh/zsh-syntax-highlighting { };

  zsh-fast-syntax-highlighting = callPackage ../shells/zsh/zsh-fast-syntax-highlighting { };

  zsh-autosuggestions = callPackage ../shells/zsh/zsh-autosuggestions { };

  zsh-powerlevel10k = callPackage ../shells/zsh/zsh-powerlevel10k { };

  zsh-powerlevel9k = callPackage ../shells/zsh/zsh-powerlevel9k { };

  zsh-command-time = callPackage ../shells/zsh/zsh-command-time { };

  zsh-you-should-use = callPackage ../shells/zsh/zsh-you-should-use { };

  zssh = callPackage ../tools/networking/zssh { };

  zstd = callPackage ../tools/compression/zstd { };

  zsync = callPackage ../tools/compression/zsync { };

  zxing = callPackage ../tools/graphics/zxing {};

  zmap = callPackage ../tools/security/zmap { };


  ### SHELLS

  runtimeShell = "${runtimeShellPackage}${runtimeShellPackage.shellPath}";
  runtimeShellPackage = bash;

  any-nix-shell = callPackage ../shells/any-nix-shell { };

  bash = lowPrio (callPackage ../shells/bash/4.4.nix { });
  bash_5 = lowPrio (callPackage ../shells/bash/5.0.nix { });
  bashInteractive_5 = lowPrio (callPackage ../shells/bash/5.0.nix {
    interactive = true;
    withDocs = true;
  });

  # WARNING: this attribute is used by nix-shell so it shouldn't be removed/renamed
  bashInteractive = callPackage ../shells/bash/4.4.nix {
    interactive = true;
    withDocs = true;
  };

  bash-completion = callPackage ../shells/bash/bash-completion { };

  gradle-completion = callPackage ../shells/zsh/gradle-completion { };

  nix-bash-completions = callPackage ../shells/bash/nix-bash-completions { };

  dash = callPackage ../shells/dash { };

  dasht = callPackage ../tools/misc/dasht { };

  dashing = callPackage ../tools/misc/dashing { };

  es = callPackage ../shells/es { };

  fish = callPackage ../shells/fish { };

  fish-foreign-env = callPackage ../shells/fish/fish-foreign-env { };

  ion = callPackage ../shells/ion { };

  jush = callPackage ../shells/jush { };

  ksh = callPackage ../shells/ksh { };

  liquidprompt = callPackage ../shells/liquidprompt { };

  mksh = callPackage ../shells/mksh { };

  oh = callPackage ../shells/oh { };

  oil = callPackage ../shells/oil { };

  pash = callPackage ../shells/pash { };

  tcsh = callPackage ../shells/tcsh { };

  rssh = callPackage ../shells/rssh { };

  rush = callPackage ../shells/rush { };

  xonsh = callPackage ../shells/xonsh { };

  zsh = callPackage ../shells/zsh { };

  nix-zsh-completions = callPackage ../shells/zsh/nix-zsh-completions { };

  zsh-completions = callPackage ../shells/zsh/zsh-completions { };

  zsh-prezto = callPackage ../shells/zsh/zsh-prezto { };

  grml-zsh-config = callPackage ../shells/zsh/grml-zsh-config { };


  ### DEVELOPMENT / COMPILERS

  abcl = callPackage ../development/compilers/abcl {};

  adoptopenjdk-bin-13-packages-linux = import ../development/compilers/adoptopenjdk-bin/jdk13-linux.nix;
  adoptopenjdk-bin-13-packages-darwin = import ../development/compilers/adoptopenjdk-bin/jdk13-darwin.nix;

  adoptopenjdk-hotspot-bin-13 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-13-packages-linux.jdk-hotspot {}
    else callPackage adoptopenjdk-bin-13-packages-darwin.jdk-hotspot {};
  adoptopenjdk-jre-hotspot-bin-13 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-13-packages-linux.jre-hotspot {}
    else callPackage adoptopenjdk-bin-13-packages-darwin.jre-hotspot {};

  adoptopenjdk-openj9-bin-13 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-13-packages-linux.jdk-openj9 {}
    else callPackage adoptopenjdk-bin-13-packages-darwin.jdk-openj9 {};

  adoptopenjdk-jre-openj9-bin-13 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-13-packages-linux.jre-openj9 {}
    else callPackage adoptopenjdk-bin-13-packages-darwin.jre-openj9 {};

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

  adoptopenjdk-bin-8-packages-linux = import ../development/compilers/adoptopenjdk-bin/jdk8-linux.nix;
  adoptopenjdk-bin-8-packages-darwin = import ../development/compilers/adoptopenjdk-bin/jdk8-darwin.nix;

  adoptopenjdk-hotspot-bin-8 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-8-packages-linux.jdk-hotspot {}
    else callPackage adoptopenjdk-bin-8-packages-darwin.jdk-hotspot {};
  adoptopenjdk-jre-hotspot-bin-8 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-8-packages-linux.jre-hotspot {}
    else callPackage adoptopenjdk-bin-8-packages-darwin.jre-hotspot {};

  adoptopenjdk-openj9-bin-8 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-8-packages-linux.jdk-openj9 {}
    else callPackage adoptopenjdk-bin-8-packages-darwin.jdk-openj9 {};

  adoptopenjdk-jre-openj9-bin-8 = if stdenv.isLinux
    then callPackage adoptopenjdk-bin-8-packages-linux.jre-openj9 {}
    else callPackage adoptopenjdk-bin-8-packages-darwin.jre-openj9 {};

  adoptopenjdk-bin = adoptopenjdk-hotspot-bin-11;
  adoptopenjdk-jre-bin = adoptopenjdk-jre-hotspot-bin-11;

  adoptopenjdk-icedtea-web = callPackage ../development/compilers/adoptopenjdk-icedtea-web {
    jdk = jdk8;
  };

  aldor = callPackage ../development/compilers/aldor { };

  aliceml = callPackage ../development/compilers/aliceml { };

  arachne-pnr = callPackage ../development/compilers/arachne-pnr { };

  asn1c = callPackage ../development/compilers/asn1c { };

  aspectj = callPackage ../development/compilers/aspectj { };

  ats = callPackage ../development/compilers/ats { };
  ats2 = callPackage ../development/compilers/ats2 { };

  avra = callPackage ../development/compilers/avra { };

  avian = callPackage ../development/compilers/avian {
    inherit (darwin.apple_sdk.frameworks) CoreServices Foundation;
  };

  bigloo = callPackage ../development/compilers/bigloo { };

  binaryen = callPackage ../development/compilers/binaryen { };

  bluespec = callPackage ../development/compilers/bluespec { };

  colm = callPackage ../development/compilers/colm { };

  colmap = libsForQt5.callPackage ../applications/science/misc/colmap { };
  colmapWithCuda = colmap.override { cudaSupport = true; };

  chickenPackages_4 = callPackage ../development/compilers/chicken/4 { };
  chickenPackages_5 = callPackage ../development/compilers/chicken/5 { };
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

  chez-srfi = callPackage ../development/chez-modules/chez-srfi { };

  chez-mit = callPackage ../development/chez-modules/chez-mit { };

  chez-scmutils = callPackage ../development/chez-modules/chez-scmutils { };

  chez-matchable = callPackage ../development/chez-modules/chez-matchable { };

  clang = llvmPackages.clang;
  clang-manpages = llvmPackages.clang-manpages;

  clang-sierraHack = clang.override {
    name = "clang-wrapper-with-reexport-hack";
    bintools = darwin.binutils.override {
      useMacosReexportHack = true;
    };
  };
  llvm-polly = llvmPackages_latest.llvm-polly;
  clang-polly = llvmPackages_latest.clang.override { cc = llvmPackages_latest.clang-polly-unwrapped; };

  clang_10 = llvmPackages_10.clang;
  clang_9  = llvmPackages_9.clang;
  clang_8  = llvmPackages_8.clang;
  clang_7  = llvmPackages_7.clang;
  clang_6  = llvmPackages_6.clang;
  clang_5  = llvmPackages_5.clang;

  clang-tools = callPackage ../development/tools/clang-tools {
    llvmPackages = llvmPackages_latest;
  };

  clang-analyzer = callPackage ../development/tools/analysis/clang-analyzer { };

  #Use this instead of stdenv to build with clang
  clangStdenv = if stdenv.cc.isClang then stdenv else lowPrio llvmPackages.stdenv;
  clang-sierraHack-stdenv = overrideCC stdenv buildPackages.clang-sierraHack;
  libcxxStdenv = if stdenv.isDarwin then stdenv else lowPrio llvmPackages.libcxxStdenv;

  clasp-common-lisp = callPackage ../development/compilers/clasp {
    llvmPackages = llvmPackages_6;
    stdenv = llvmPackages_6.stdenv;
  };

  clean = callPackage ../development/compilers/clean { };

  closurecompiler = callPackage ../development/compilers/closure { };

  cmdstan = callPackage ../development/compilers/cmdstan { };

  cmucl_binary = pkgsi686Linux.callPackage ../development/compilers/cmucl/binary.nix { };

  compcert = callPackage ../development/compilers/compcert { };

  computecpp-unwrapped = callPackage ../development/compilers/computecpp {};
  computecpp = wrapCCWith rec {
    cc = computecpp-unwrapped;
    extraPackages = [
      libstdcxxHook
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
    '' + stdenv.lib.optionalString (stdenv.targetPlatform.isLinux && cc ? gcc && !(stdenv.targetPlatform.useLLVM or false)) ''
      echo "--gcc-toolchain=${cc.gcc}" >> $out/nix-support/cc-cflags
    '';
  };

  cryptol = haskell.lib.justStaticExecutables haskellPackages.cryptol;

  inherit (callPackages ../development/compilers/crystal {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
    inherit (llvmPackages_6) clang llvm;
  })
    crystal_0_27
    crystal_0_29
    crystal_0_30
    crystal_0_31
    crystal_0_32
    crystal
    crystal2nix;

  icr = callPackage ../development/tools/icr {
    openssl = openssl_1_0_2;
  };

  scry = callPackage ../development/tools/scry {};

  dbmate = callPackage ../development/tools/database/dbmate { };

  devpi-client = python3Packages.callPackage ../development/tools/devpi-client {};

  devpi-server = callPackage ../development/tools/devpi-server {};

  dotty = callPackage ../development/compilers/scala/dotty.nix { jre = jre8;};

  drumstick = callPackage ../development/libraries/drumstick { };

  ecl = callPackage ../development/compilers/ecl { };
  ecl_16_1_2 = callPackage ../development/compilers/ecl/16.1.2.nix { };

  eli = callPackage ../development/compilers/eli { };

  eql = callPackage ../development/compilers/eql {};

  elm2nix = haskell.lib.justStaticExecutables haskellPackages.elm2nix;

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  apache-flex-sdk = callPackage ../development/compilers/apache-flex-sdk { };

  fasm = pkgsi686Linux.callPackage ../development/compilers/fasm {
    inherit (stdenv) isx86_64;
  };
  fasm-bin = callPackage ../development/compilers/fasm/bin.nix { };

  flyctl = callPackage ../development/web/flyctl { };

  flutterPackages =
    recurseIntoAttrs (callPackage ../development/compilers/flutter { });
  flutter = flutterPackages.stable;

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { stdenv = gccStdenv; };
  gambit-unstable = callPackage ../development/compilers/gambit/unstable.nix { stdenv = gccStdenv; };
  gerbil = callPackage ../development/compilers/gerbil { stdenv = gccStdenv; };
  gerbil-unstable = callPackage ../development/compilers/gerbil/unstable.nix { stdenv = gccStdenv; };

  gccFun = callPackage (if stdenv.targetPlatform.isVc4 then ../development/compilers/gcc/6 else ../development/compilers/gcc/9);
  gcc = if stdenv.targetPlatform.isVc4 then gcc6 else gcc9;
  gcc-unwrapped = gcc.cc;

  gccStdenv = if stdenv.cc.isGNU then stdenv else stdenv.override {
    allowedRequisites = null;
    cc = gcc;
    # Remove libcxx/libcxxabi, and add clang for AS if on darwin (it uses
    # clang's internal assembler).
    extraBuildInputs = lib.optional stdenv.hostPlatform.isDarwin clang.cc;
  };

  gcc49Stdenv = overrideCC gccStdenv buildPackages.gcc49;
  gcc6Stdenv = overrideCC gccStdenv buildPackages.gcc6;
  gcc7Stdenv = overrideCC gccStdenv buildPackages.gcc7;
  gcc8Stdenv = overrideCC gccStdenv buildPackages.gcc8;
  gcc9Stdenv = overrideCC gccStdenv buildPackages.gcc9;

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

  gcc_debug = lowPrio (wrapCC (gcc.cc.override {
    stripped = false;
  }));

  libstdcxxHook = makeSetupHook
    { substitutions = { gcc = gcc-unwrapped; }; }
    ../development/compilers/gcc/libstdc++-hook.sh;

  crossLibcStdenv = overrideCC stdenv
    (if stdenv.hostPlatform.useLLVM or false
     then buildPackages.llvmPackages_8.lldClangNoLibc
     else buildPackages.gccCrossStageStatic);

  # The GCC used to build libc for the target platform. Normal gccs will be
  # built with, and use, that cross-compiled libc.
  gccCrossStageStatic = assert stdenv.targetPlatform != stdenv.hostPlatform; let
    libcCross1 =
      if stdenv.targetPlatform.libc == "msvcrt" then targetPackages.windows.mingw_w64_headers
      else if stdenv.targetPlatform.libc == "libSystem" then darwin.xcode
      else if stdenv.targetPlatform.libc == "nblibc" then netbsd.headers
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
      extraPackages = [];
  };

  gcc48 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isSunOS && !isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
    cloog = if !stdenv.isDarwin then cloog else null;
    texinfo = texinfo5; # doesn't validate since 6.1 -> 6.3 bump
  }));

  gcc49 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.9 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else null;

    isl = if !stdenv.isDarwin then isl_0_11 else null;

    cloog = if !stdenv.isDarwin then cloog_0_18_0 else null;
  }));

  gcc6 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/6 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gcc7 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/7 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc8 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gcc9 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/9 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    enableLTO = !stdenv.isi686;

    libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then libcCross else null;
    threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else null;

    isl = if !stdenv.isDarwin then isl_0_17 else null;
  }));

  gfortran = gfortran9;

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

  gnu-smalltalk = callPackage ../development/compilers/gnu-smalltalk { };

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

  gcc-arm-embedded-6 = callPackage ../development/compilers/gcc-arm-embedded/6 {};
  gcc-arm-embedded-7 = callPackage ../development/compilers/gcc-arm-embedded/7 {};
  gcc-arm-embedded-8 = callPackage ../development/compilers/gcc-arm-embedded/8 {};
  gcc-arm-embedded-9 = callPackage ../development/compilers/gcc-arm-embedded/9 {};
  gcc-arm-embedded = gcc-arm-embedded-9;

  gforth = callPackage ../development/compilers/gforth {};

  gleam = callPackage ../development/compilers/gleam {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gtk-server = callPackage ../development/interpreters/gtk-server {};

  # Haskell and GHC

  haskell = callPackage ./haskell-packages.nix { };

  # Please update doc/languages-frameworks/haskell.section.md, “Our
  # current default compiler is”, if you bump this:
  haskellPackages = dontRecurseIntoAttrs haskell.packages.ghc883;

  inherit (haskellPackages) ghc;

  cabal-install = haskell.lib.justStaticExecutables haskellPackages.cabal-install;

  stack = haskell.lib.justStaticExecutables haskellPackages.stack;
  hlint = haskell.lib.justStaticExecutables haskellPackages.hlint;

  # We use a version built with an older compiler because of https://github.com/pikajude/stylish-cabal/issues/12.
  stylish-cabal = haskell.lib.justStaticExecutables haskell.packages.ghc865.stylish-cabal;

  all-cabal-hashes = callPackage ../data/misc/hackage { };

  purescript = callPackage ../development/compilers/purescript/purescript { };

  psc-package = callPackage ../development/compilers/purescript/psc-package { };

  purescript-psa = nodePackages.purescript-psa;

  spago = callPackage ../development/tools/purescript/spago { };

  pulp = nodePackages.pulp;

  pscid = nodePackages.pscid;

  tacacsplus = callPackage ../servers/tacacsplus { };

  tamarin-prover =
    (haskellPackages.callPackage ../applications/science/logic/tamarin-prover {
      # NOTE: do not use the haskell packages 'graphviz' and 'maude'
      inherit maude which;
      graphviz = graphviz-nox;
    });

  inherit (callPackage ../development/compilers/haxe {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  }) haxe_3_2 haxe_3_4;
  haxe = haxe_3_4;
  haxePackages = recurseIntoAttrs (callPackage ./haxe-packages.nix { });
  inherit (haxePackages) hxcpp;

  hhvm = callPackage ../development/compilers/hhvm { };

  hop = callPackage ../development/compilers/hop { };

  falcon = callPackage ../development/interpreters/falcon { };

  fsharp = callPackage ../development/compilers/fsharp { };

  fsharp41 = callPackage ../development/compilers/fsharp41 { mono = mono6; };

  fstar = callPackage ../development/compilers/fstar {
    ocamlPackages = ocaml-ng.ocamlPackages_4_07;
  };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix {});

  glslang = callPackage ../development/compilers/glslang {
    spirv-tools = spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "5c019b5923c1f6bf00a3ac28114ec4a7b1faa0e2";
        sha256 = "17a0kiyb7zjsg7ws12diip84vds1ajl98ni9c2wria6ymcvbvsvz";
      };
    });
    spirv-headers = spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Headers";
        rev = "204cd131c42b90d129073719f2766293ce35c081";
        sha256 = "1gp0mlbfccqnalaix97jxsa5i337xyzyr55wgssapy56p0q04wv2";
      };
    });
  };

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

  go_1_12 = callPackage ../development/compilers/go/1.12.nix ({
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  } // lib.optionalAttrs stdenv.isAarch64 {
    stdenv = gcc8Stdenv;
    buildPackages = buildPackages // { stdenv = gcc8Stdenv; };
  });

  go_1_13 = callPackage ../development/compilers/go/1.13.nix ({
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  } // lib.optionalAttrs stdenv.isAarch64 {
    stdenv = gcc8Stdenv;
    buildPackages = buildPackages // { stdenv = gcc8Stdenv; };
  });

  go_1_14 = callPackage ../development/compilers/go/1.14.nix ({
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  } // lib.optionalAttrs stdenv.isAarch64 {
    stdenv = gcc8Stdenv;
    buildPackages = buildPackages // { stdenv = gcc8Stdenv; };
  });

  go = go_1_14;

  go-repo-root = callPackage ../development/tools/go-repo-root { };

  go-junit-report = callPackage ../development/tools/go-junit-report { };

  gogetdoc = callPackage ../development/tools/gogetdoc { };

  gometalinter = callPackage ../development/tools/gometalinter { };

  gox = callPackage ../development/tools/gox { };

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  idrisPackages = dontRecurseIntoAttrs (callPackage ../development/idris-modules {
    idris-no-deps = haskellPackages.idris;
  });

  idris = idrisPackages.with-packages [ idrisPackages.base ] ;

  intel-graphics-compiler = callPackage ../development/compilers/intel-graphics-compiler { };

  intercal = callPackage ../development/compilers/intercal { };

  irony-server = callPackage ../development/tools/irony-server {
    # The repository of irony to use -- must match the version of the employed emacs
    # package.  Wishing we could merge it into one irony package, to avoid this issue,
    # but its emacs-side expression is autogenerated, and we can't hook into it (other
    # than peek into its version).
    inherit (emacsPackages.melpaStablePackages) irony;
  };

  hugs = callPackage ../development/interpreters/hugs { };

  openjfx11 = callPackage ../development/compilers/openjdk/openjfx/11.nix { };

  openjfx13 = callPackage ../development/compilers/openjdk/openjfx/13.nix { };

  openjdk8-bootstrap =
    if adoptopenjdk-hotspot-bin-8.meta.available then
      adoptopenjdk-hotspot-bin-8
    else
      callPackage ../development/compilers/openjdk/bootstrap.nix { version = "8"; };

  /* legacy jdk for use as needed by older apps */
  openjdk8 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin/8.nix { }
    else
      callPackage ../development/compilers/openjdk/8.nix {
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk8_headless =
    if stdenv.isDarwin || stdenv.isAarch64 then
      openjdk8
    else
      openjdk8.override { headless = true; };

  openjdk11-bootstrap =
    if adoptopenjdk-hotspot-bin-11.meta.available then
      adoptopenjdk-hotspot-bin-11
    else
      callPackage ../development/compilers/openjdk/bootstrap.nix { version = "10"; };

  /* currently maintained LTS JDK */
  openjdk11 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin/11.nix { }
    else
      callPackage ../development/compilers/openjdk/11.nix {
        openjfx = openjfx11;
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk11_headless =
    if stdenv.isDarwin then
      openjdk11
    else
      openjdk11.override { headless = true; };

  openjdk13-bootstrap =
    if adoptopenjdk-hotspot-bin-13.meta.available then
      adoptopenjdk-hotspot-bin-13
    else
      /* adoptopenjdk not available for i686, so fall back to our old build of 12 for bootstrapping */
      callPackage ../development/compilers/openjdk/12.nix {
        openjfx = openjfx11; /* need this despite next line :-( */
        enableJavaFX = false;
        headless = true;
        inherit (gnome2) GConf gnome_vfs;
      };

  /* current JDK */
  openjdk13 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk/darwin { }
    else
      callPackage ../development/compilers/openjdk {
        openjfx = openjfx13;
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk13_headless =
    if stdenv.isDarwin then
      openjdk13
    else
      openjdk13.override { headless = true; };

  openjdk = openjdk8;
  openjdk_headless = openjdk8_headless;

  jdk8 = openjdk8;
  jre8 = openjdk8.jre;
  jre8_headless = openjdk8_headless.jre;

  jdk11 = openjdk11;
  jdk11_headless = openjdk11_headless;

  jdk13 = openjdk13;
  jdk13_headless = openjdk13_headless;

  jdk = jdk8;
  jre = jre8;
  jre_headless = jre8_headless;

  inherit (callPackages ../development/compilers/graalvm {
    gcc = if stdenv.targetPlatform.isDarwin then gcc8 else gcc;
    inherit (darwin.apple_sdk.frameworks)
      CoreFoundation Foundation JavaNativeFoundation
      JavaVM JavaRuntimeSupport Cocoa;
    inherit (darwin) libiconv libobjc libresolv;
  }) mx jvmci8 graalvm8;

  inherit (callPackages ../development/compilers/graalvm/enterprise-edition.nix { })
    graalvm8-ee
    graalvm11-ee;

  openshot-qt = libsForQt5.callPackage ../applications/video/openshot-qt { };

  openspin = callPackage ../development/compilers/openspin { };

  oraclejdk = pkgs.jdkdistro true false;

  oraclejdk8 = pkgs.oraclejdk8distro true false;

  oraclejre = lowPrio (pkgs.jdkdistro false false);

  oraclejre8 = lowPrio (pkgs.oraclejdk8distro false false);

  jrePlugin = jre8Plugin;

  jre8Plugin = lowPrio (pkgs.oraclejdk8distro false true);

  jdkdistro = oraclejdk8distro;

  oraclejdk8distro = installjdk: pluginSupport:
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8-linux.nix {
        inherit installjdk pluginSupport;
      });

  jasmin = callPackage ../development/compilers/jasmin { };

  java-service-wrapper = callPackage ../tools/system/java-service-wrapper { };

  javacard-devkit = pkgsi686Linux.callPackage ../development/compilers/javacard-devkit { };

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

  julia_11 = callPackage ../development/compilers/julia/1.1.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia_13 = callPackage ../development/compilers/julia/1.3.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia_1 = julia_10;
  julia = julia_1;

  jwasm =  callPackage ../development/compilers/jwasm { };

  kotlin = callPackage ../development/compilers/kotlin { };

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lessc = nodePackages.less;

  liquibase = callPackage ../development/tools/database/liquibase { };

  lizardfs = callPackage ../tools/filesystems/lizardfs { };

  lld = llvmPackages.lld;
  lld_5 = llvmPackages_5.lld;
  lld_6 = llvmPackages_6.lld;
  lld_7 = llvmPackages_7.lld;
  lld_8 = llvmPackages_8.lld;
  lld_9 = llvmPackages_9.lld;
  lld_10 = llvmPackages_10.lld;

  lldb = llvmPackages.lldb;
  lldb_5 = llvmPackages_5.lldb;
  lldb_6 = llvmPackages_6.lldb;
  lldb_7 = llvmPackages_7.lldb;
  lldb_8 = llvmPackages_8.lldb;
  lldb_9 = llvmPackages_9.lldb;
  lldb_10 = llvmPackages_10.lldb;

  llvm = llvmPackages.llvm;
  llvm-manpages = llvmPackages.llvm-manpages;

  llvm_10 = llvmPackages_10.llvm;
  llvm_9  = llvmPackages_9.llvm;
  llvm_8  = llvmPackages_8.llvm;
  llvm_7  = llvmPackages_7.llvm;
  llvm_6  = llvmPackages_6.llvm;
  llvm_5  = llvmPackages_5.llvm;

  llvmPackages = recurseIntoAttrs llvmPackages_7;

  llvmPackages_5 = callPackage ../development/compilers/llvm/5 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_5.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_5.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
    stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_6 = callPackage ../development/compilers/llvm/6 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_6.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_6.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
    # with gcc-7 on i686: undefined reference to `__divmoddi4'
    # Failing tests with gcc8.
    stdenv = overrideCC stdenv (if stdenv.hostPlatform.isi686 then gcc6 else gcc7);
  });

  llvmPackages_7 = callPackage ../development/compilers/llvm/7 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_7.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_7.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && buildPackages.stdenv.cc.isGNU) {
    stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_8 = callPackage ../development/compilers/llvm/8 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_8.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_8.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && buildPackages.stdenv.cc.isGNU) {
    stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_9 = callPackage ../development/compilers/llvm/9 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_9.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_9.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && buildPackages.stdenv.cc.isGNU) {
    stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
  });

  llvmPackages_10 = callPackage ../development/compilers/llvm/10 ({
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_10.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_10.libraries;
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && buildPackages.stdenv.cc.isGNU) {
    stdenv = gcc7Stdenv;
  });

  llvmPackages_latest = llvmPackages_9; # llvmPackages_10: when out of RC

  lorri = callPackage ../tools/misc/lorri {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  manticore = callPackage ../development/compilers/manticore { };

  mercury = callPackage ../development/compilers/mercury { };

  microscheme = callPackage ../development/compilers/microscheme { };

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

  mkcl = callPackage ../development/compilers/mkcl {};

  inherit (callPackage ../development/compilers/mlton {})
    mlton20130715
    mlton20180207Binary
    mlton20180207
    mltonHEAD;

  mlton = mlton20180207;

  mono = mono5;

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

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  msbuild = callPackage ../development/tools/build-managers/msbuild { mono = mono6; };

  mosml = callPackage ../development/compilers/mosml { };

  mozart2 = callPackage ../development/compilers/mozart { };

  mozart2-binary = callPackage ../development/compilers/mozart/binary.nix { };

  nim = callPackage ../development/compilers/nim { };
  nrpl = callPackage ../development/tools/nrpl { };

  neko = callPackage ../development/compilers/neko { };

  nextpnr = libsForQt5.callPackage ../development/compilers/nextpnr {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  acme = callPackage ../development/compilers/acme { };

  nasm = callPackage ../development/compilers/nasm { };

  nvidia_cg_toolkit = callPackage ../development/compilers/nvidia-cg-toolkit { };

  obliv-c = callPackage ../development/compilers/obliv-c {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  ocaml-ng = callPackage ./ocaml-packages.nix { };
  ocaml = ocamlPackages.ocaml;

  ocamlPackages = recurseIntoAttrs ocaml-ng.ocamlPackages;

  ocaml-crunch = ocamlPackages.crunch.bin;

  ocamlformat = callPackage ../development/tools/ocaml/ocamlformat { };

  orc = callPackage ../development/compilers/orc { };

  metaocaml_3_09 = callPackage ../development/compilers/ocaml/metaocaml-3.09.nix { };

  ber_metaocaml = callPackage ../development/compilers/ocaml/ber-metaocaml.nix { };

  ocaml_make = callPackage ../development/ocaml-modules/ocamlmake { };

  ocaml-top = callPackage ../development/tools/ocaml/ocaml-top { };

  ocsigen-i18n = callPackage ../development/tools/ocaml/ocsigen-i18n { };

  opa = callPackage ../development/compilers/opa {
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  opaline = callPackage ../development/tools/ocaml/opaline { };

  opam = callPackage ../development/tools/ocaml/opam { };
  opam_1_2 = callPackage ../development/tools/ocaml/opam/1.2.2.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  pforth = callPackage ../development/compilers/pforth {};

  picat = callPackage ../development/compilers/picat { };

  ponyc = callPackage ../development/compilers/ponyc {
    llvm = llvm_7;
  };

  pony-stable = callPackage ../development/compilers/ponyc/pony-stable.nix { };

  qbe = callPackage ../development/compilers/qbe { };

  rasm = callPackage ../development/compilers/rasm { };

  rgbds = callPackage ../development/compilers/rgbds { };

  rtags = callPackage ../development/tools/rtags {
    inherit (darwin) apple_sdk;
  };

  rust_1_41_0 = callPackage ../development/compilers/rust/1_41_0.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };
  rust = rust_1_41_0;

  rustPackages_1_41_0 = rust_1_41_0.packages.stable;
  rustPackages = rustPackages_1_41_0;

  inherit (rustPackages) cargo clippy rustc rustPlatform;
  inherit (rust) makeRustPlatform;

  buildRustCrate = callPackage ../build-support/rust/build-rust-crate { };
  buildRustCrateHelpers = callPackage ../build-support/rust/build-rust-crate/helpers.nix { };
  buildRustCrateTests = recurseIntoAttrs (callPackage ../build-support/rust/build-rust-crate/test { });
  cratesIO = callPackage ../build-support/rust/crates-io.nix { };

  cargo-web = callPackage ../development/tools/cargo-web {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  cargo-flamegraph = callPackage ../development/tools/cargo-flamegraph {
    inherit (darwin.apple_sdk.frameworks) Security;
    inherit (linuxPackages) perf;
  };

  carnix = (callPackage ../build-support/rust/carnix.nix { }).carnix { };

  defaultCrateOverrides = callPackage ../build-support/rust/default-crate-overrides.nix { };

  cargo-about = callPackage ../tools/package-management/cargo-about { };
  cargo-audit = callPackage ../tools/package-management/cargo-audit {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-deb = callPackage ../tools/package-management/cargo-deb {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-deps = callPackage ../tools/package-management/cargo-deps { };
  cargo-download = callPackage ../tools/package-management/cargo-download { };
  cargo-edit = callPackage ../tools/package-management/cargo-edit { };
  cargo-graph = callPackage ../tools/package-management/cargo-graph { };
  cargo-license = callPackage ../tools/package-management/cargo-license { };
  cargo-outdated = callPackage ../tools/package-management/cargo-outdated {};
  cargo-release = callPackage ../tools/package-management/cargo-release {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-tree = callPackage ../tools/package-management/cargo-tree { };
  cargo-update = callPackage ../tools/package-management/cargo-update { };

  cargo-asm = callPackage ../development/tools/rust/cargo-asm {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-bloat = callPackage ../development/tools/rust/cargo-bloat { };
  cargo-crev = callPackage ../development/tools/rust/cargo-crev {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-expand = callPackage ../development/tools/rust/cargo-expand { };
  cargo-fuzz = callPackage ../development/tools/rust/cargo-fuzz { };
  cargo-geiger = callPackage ../development/tools/rust/cargo-geiger {
    inherit (darwin) libiconv;
    inherit (darwin.apple_sdk.frameworks) Security CoreFoundation;
  };
  cargo-inspect = callPackage ../development/tools/rust/cargo-inspect {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-make = callPackage ../development/tools/rust/cargo-make {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-raze = callPackage ../development/tools/rust/cargo-raze {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  cargo-sweep = callPackage ../development/tools/rust/cargo-sweep { };
  cargo-udeps = callPackage ../development/tools/rust/cargo-udeps {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };
  cargo-watch = callPackage ../development/tools/rust/cargo-watch {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };
  cargo-xbuild = callPackage ../development/tools/rust/cargo-xbuild { };
  cargo-generate = callPackage ../development/tools/rust/cargo-generate {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  maturin = callPackage ../development/tools/rust/maturin { };
  inherit (rustPackages) rls;
  rustfmt = rustPackages.rustfmt;
  rustracer = callPackage ../development/tools/rust/racer {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  rustracerd = callPackage ../development/tools/rust/racerd {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  rust-bindgen = callPackage ../development/tools/rust/bindgen { };
  rust-cbindgen = callPackage ../development/tools/rust/cbindgen {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  rustup = callPackage ../development/tools/rust/rustup {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  sagittarius-scheme = callPackage ../development/compilers/sagittarius-scheme {};

  sbclBootstrap = callPackage ../development/compilers/sbcl/bootstrap.nix {};
  sbcl_2_0_2 = callPackage ../development/compilers/sbcl {};
  sbcl = callPackage ../development/compilers/sbcl/2.0.0.nix {};

  scala_2_10 = callPackage ../development/compilers/scala/2.10.nix { };
  scala_2_11 = callPackage ../development/compilers/scala/2.11.nix { };
  scala_2_12 = callPackage ../development/compilers/scala/2.12.nix { jre = jre8; };
  scala_2_13 = callPackage ../development/compilers/scala/2.13.nix { jre = jre8; };
  scala = scala_2_13;

  metals = callPackage ../development/tools/metals { };
  scalafix = callPackage ../development/tools/scalafix { };
  scalafmt = callPackage ../development/tools/scalafmt { };

  sdcc = callPackage ../development/compilers/sdcc {
    gputils = null;
  };

  serialdv = callPackage ../development/libraries/serialdv {  };

  serpent = callPackage ../development/compilers/serpent { };

  shmig = callPackage ../development/tools/database/shmig { };

  smlnjBootstrap = callPackage ../development/compilers/smlnj/bootstrap.nix { };
  smlnj = callPackage ../development/compilers/smlnj { };

  solc = callPackage ../development/compilers/solc { };

  souffle = callPackage ../development/compilers/souffle { };

  spirv-llvm-translator = callPackage ../development/compilers/spirv-llvm-translator { };

  sqldeveloper = callPackage ../development/tools/database/sqldeveloper {
    jdk = oraclejdk;
  };

  squeak = callPackage ../development/compilers/squeak { };

  squirrel-sql = callPackage ../development/tools/database/squirrel-sql {
    drivers = [ mssql_jdbc mysql_jdbc postgresql_jdbc ];
  };

  stalin = callPackage ../development/compilers/stalin { };

  metaBuildEnv = callPackage ../development/compilers/meta-environment/meta-build-env { };

  svd2rust = callPackage ../development/tools/rust/svd2rust { };

  swift = callPackage ../development/compilers/swift { };

  swiProlog = callPackage ../development/compilers/swi-prolog {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  swiPrologWithGui = swiProlog.override { withGui = true; };

  tbb = callPackage ../development/libraries/tbb { };

  terra = callPackage ../development/compilers/terra {
    llvmPackages = llvmPackages_6;
    lua = lua5_1;
  };

  teyjus = callPackage ../development/compilers/teyjus (
    with ocaml-ng.ocamlPackages_4_02; {
      inherit ocaml;
      omake = omake_rc1;
  });

  thrust = callPackage ../development/tools/thrust {
    gconf = pkgs.gnome2.GConf;
  };

  tinycc = callPackage ../development/compilers/tinycc { };

  tinygo = callPackage ../development/compilers/tinygo {
    inherit (llvmPackages_9) llvm clang-unwrapped lld;
    avrgcc = pkgsCross.avr.buildPackages.gcc;
  };

  tinyscheme = callPackage ../development/interpreters/tinyscheme {
    stdenv = gccStdenv;
  };

  bupc = callPackage ../development/compilers/bupc { };

  urn = callPackage ../development/compilers/urn { };

  urweb = callPackage ../development/compilers/urweb { };

  vlang = callPackage ../development/compilers/vlang { };

  vala-lint = callPackage ../development/tools/vala-lint { };

  inherit (callPackage ../development/compilers/vala { })
    vala_0_36
    vala_0_40
    vala_0_44
    vala_0_46
    vala;

  wcc = callPackage ../development/compilers/wcc { };

  wla-dx = callPackage ../development/compilers/wla-dx { };

  wrapCCWith =
    { cc
    , # This should be the only bintools runtime dep with this sort of logic. The
      # Others should instead delegate to the next stage's choice with
      # `targetPackages.stdenv.cc.bintools`. This one is different just to
      # provide the default choice, avoiding infinite recursion.
      bintools ? if stdenv.targetPlatform.isDarwin then darwin.binutils else binutils
    , libc ? bintools.libc
    , extraPackages ? stdenv.lib.optional (cc.isGNU or false && stdenv.targetPlatform.isMinGW) threadsCross
    , ...
    } @ extraArgs:
      callPackage ../build-support/cc-wrapper (let self = {
    nativeTools = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.targetPlatform == stdenv.hostPlatform && stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    noLibc = !self.nativeLibc && (self.libc == null);

    isGNU = cc.isGNU or false;
    isClang = cc.isClang or false;

    inherit cc bintools libc extraPackages;
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

  yaml-language-server = nodePackages.yaml-language-server;

  # prolog
  yap = callPackage ../development/compilers/yap { };

  yasm = callPackage ../development/compilers/yasm { };

  yosys = callPackage ../development/compilers/yosys { };

  z88dk = callPackage ../development/compilers/z88dk { };

  zulip = callPackage ../applications/networking/instant-messengers/zulip { };

  zulu8 = callPackage ../development/compilers/zulu/8.nix { };
  zulu = callPackage ../development/compilers/zulu { };

  ### DEVELOPMENT / INTERPRETERS

  acl2 = callPackage ../development/interpreters/acl2 { };

  angelscript = callPackage ../development/interpreters/angelscript {};

  angelscript_2_22 = callPackage ../development/interpreters/angelscript/2.22.nix {};

  chibi = callPackage ../development/interpreters/chibi { };

  ceptre = callPackage ../development/interpreters/ceptre { };

  clips = callPackage ../development/interpreters/clips { };

  clisp = callPackage ../development/interpreters/clisp { };
  clisp-tip = callPackage ../development/interpreters/clisp/hg.nix { };

  clojure = callPackage ../development/interpreters/clojure { };

  clojure-lsp = callPackage ../development/tools/misc/clojure-lsp { };

  clooj = callPackage ../development/interpreters/clojure/clooj.nix { };

  dhall = haskell.lib.justStaticExecutables haskellPackages.dhall;

  dhall-nix = haskell.lib.justStaticExecutables haskellPackages.dhall-nix;

  dhall-bash = haskell.lib.justStaticExecutables haskellPackages.dhall-bash;

  dhall-json = haskell.lib.justStaticExecutables haskellPackages.dhall-json;

  dhall-text = haskell.lib.justStaticExecutables haskellPackages.dhall-text;

  dhallPackages = callPackages ./dhall-packages.nix { };

  duktape = callPackage ../development/interpreters/duktape { };

  evcxr = callPackage ../development/interpreters/evcxr {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  beam = callPackage ./beam-packages.nix { };

  inherit (beam.interpreters)
    erlang erlangR18 erlangR19 erlangR20 erlangR21 erlangR22
    erlang_odbc erlang_javac erlang_odbc_javac erlang_nox erlang_basho_R16B02
    elixir elixir_1_10 elixir_1_9 elixir_1_8 elixir_1_7 elixir_1_6;

  inherit (beam.packages.erlang)
    rebar rebar3
    fetchHex beamPackages
    relxExe;

  inherit (beam.packages.erlangR19) cuter lfe_1_2;

  inherit (beam.packages.erlangR21) lfe lfe_1_3;

  groovy = callPackage ../development/interpreters/groovy { };

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

  janet = callPackage ../development/interpreters/janet {};

  jimtcl = callPackage ../development/interpreters/jimtcl {};

  jmeter = callPackage ../applications/networking/jmeter {};

  joker = callPackage ../development/interpreters/joker {};

  davmail = callPackage ../applications/networking/davmail {};

  kanif = callPackage ../applications/networking/cluster/kanif { };

  lumo = callPackage ../development/interpreters/clojurescript/lumo {
    nodejs = nodejs-13_x;
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

  lxtask = callPackage ../desktops/lxde/core/lxtask { };

  lxrandr = callPackage ../desktops/lxde/core/lxrandr { };

  kona = callPackage ../development/interpreters/kona {};

  lolcode = callPackage ../development/interpreters/lolcode { };

  love_0_7 = callPackage ../development/interpreters/love/0.7.nix { lua=lua5_1; };
  love_0_8 = callPackage ../development/interpreters/love/0.8.nix { lua=lua5_1; };
  love_0_9 = callPackage ../development/interpreters/love/0.9.nix { };
  love_0_10 = callPackage ../development/interpreters/love/0.10.nix { };
  love_11 = callPackage ../development/interpreters/love/11.1.nix { };
  love = love_0_10;

  wabt = callPackage ../development/tools/wabt { };

  ### LUA interpreters
  luaInterpreters = callPackage ./../development/interpreters/lua-5 {};
  inherit (luaInterpreters) lua5_1 lua5_2 lua5_2_compat lua5_3 lua5_3_compat luajit_2_1 luajit_2_0;

  lua5 = lua5_2_compat;
  lua = lua5;

  lua51Packages = recurseIntoAttrs lua5_1.pkgs;
  lua52Packages = recurseIntoAttrs lua5_2.pkgs;
  lua53Packages = recurseIntoAttrs lua5_3.pkgs;
  luajitPackages = recurseIntoAttrs luajit.pkgs;

  luaPackages = lua52Packages;

  luajit = luajit_2_1;

  luarocks = luaPackages.luarocks;
  luarocks-nix = luaPackages.luarocks-nix;

  toluapp = callPackage ../development/tools/toluapp {
    lua = lua5_1; # doesn't work with any other :(
  };

  ### END OF LUA

  lush2 = callPackage ../development/interpreters/lush {};

  maude = callPackage ../development/interpreters/maude {
    stdenv = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;
  };

  me_cleaner = pythonPackages.callPackage ../tools/misc/me_cleaner { };

  mesos = callPackage ../applications/networking/cluster/mesos {
    sasl = cyrus_sasl;
    inherit (pythonPackages) python boto setuptools wrapPython;
    pythonProtobuf = pythonPackages.protobuf.override { protobuf = protobuf3_6; };
    perf = linuxPackages.perf;
  };

  mesos-dns = callPackage ../servers/mesos-dns { };

  metamath = callPackage ../development/interpreters/metamath { };

  minder = callPackage ../applications/misc/minder { };

  mujs = callPackage ../development/interpreters/mujs { };

  nix-exec = callPackage ../development/interpreters/nix-exec {
    git = gitMinimal;
  };

  octave = callPackage ../development/interpreters/octave {
    python = python3;
    openblas = if stdenv.isDarwin then openblasCompat else openblas;
  };
  octave-jit = callPackage ../development/interpreters/octave {
    python = python3;
    openblas = if stdenv.isDarwin then openblasCompat else openblas;
    enableJIT = true;
  };
  octaveFull = (lowPrio (libsForQt512.callPackage ../development/interpreters/octave {
    python = python3;
    openblas = if stdenv.isDarwin then openblasCompat else openblas;
    enableQt = true;
    overridePlatforms = ["x86_64-linux" "x86_64-darwin"];
  }));

  ocropus = callPackage ../applications/misc/ocropus { };

  pachyderm = callPackage ../applications/networking/cluster/pachyderm { };

  php = php74;
  phpPackages = php74Packages;

  php72Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php72;
  });

  php73Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php73;
  });

  php74Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php74;
  });

  phpPackages-unit = php74Packages-unit;

  php72Packages-unit = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php72-unit;
  });

  php73Packages-unit = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php73-unit;
  });

  php74Packages-unit = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php74-unit;
  });

  inherit (callPackages ../development/interpreters/php {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  })
    php74
    php73
    php72;

  php-embed = php74-embed;

  php72-embed = php72.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  php73-embed = php73.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  php74-embed = php74.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };

  php-unit = php74-unit;

  php72-unit = php72.override {
    config.php.embed = true;
    config.php.apxs2 = false;
    config.php.systemd = false;
    config.php.phpdbg = false;
    config.php.cgi = false;
    config.php.fpm = false;
  };

  php73-unit = php73.override {
    config.php.embed = true;
    config.php.apxs2 = false;
    config.php.systemd = false;
    config.php.phpdbg = false;
    config.php.cgi = false;
    config.php.fpm = false;
  };

  php74-unit = php74.override {
    config.php.embed = true;
    config.php.apxs2 = false;
    config.php.systemd = false;
    config.php.phpdbg = false;
    config.php.cgi = false;
    config.php.fpm = false;
  };

  picoc = callPackage ../development/interpreters/picoc {};

  picolisp = callPackage ../development/interpreters/picolisp {};

  polyml = callPackage ../development/compilers/polyml { };
  polyml56 = callPackage ../development/compilers/polyml/5.6.nix { };
  polyml57 = callPackage ../development/compilers/polyml/5.7.nix { };

  pure = callPackage ../development/interpreters/pure {
    /*llvm = llvm_35;*/
  };
  purePackages = recurseIntoAttrs (callPackage ./pure-packages.nix {});

  # Python interpreters. All standard library modules are included except for tkinter, which is
  # available as `pythonPackages.tkinter` and can be used as any other Python package.
  # When switching these sets, please update docs at ../../doc/languages-frameworks/python.md
  python = python2;
  python2 = python27;
  python3 = python37;
  pypy = pypy2;
  pypy2 = pypy27;
  pypy3 = pypy36;

  # Python interpreter that is build with all modules, including tkinter.
  # These are for compatibility and should not be used inside Nixpkgs.
  pythonFull = python.override{x11Support=true;};
  python2Full = python2.override{x11Support=true;};
  python27Full = python27.override{x11Support=true;};
  python3Full = python3.override{x11Support=true;};
  python35Full = python35.override{x11Support=true;};
  python36Full = python36.override{x11Support=true;};
  python37Full = python37.override{x11Support=true;};
  python38Full = python38.override{x11Support=true;};
  python39Full = python39.override{x11Support=true;};

  # pythonPackages further below, but assigned here because they need to be in sync
  pythonPackages = python.pkgs;
  python2Packages = python2.pkgs;
  python3Packages = python3.pkgs;

  pythonInterpreters = callPackage ./../development/interpreters/python {};
  inherit (pythonInterpreters) python27 python35 python36 python37 python38 python39 python3Minimal pypy27 pypy36;

  # Python package sets.
  python27Packages = lib.hiPrioSet (recurseIntoAttrs python27.pkgs);
  python35Packages = python35.pkgs;
  python36Packages = python36.pkgs;
  python37Packages = recurseIntoAttrs python37.pkgs;
  python38Packages = recurseIntoAttrs python38.pkgs;
  python39Packages = python39.pkgs;
  pypyPackages = pypy.pkgs;
  pypy2Packages = pypy2.pkgs;
  pypy27Packages = pypy27.pkgs;
  pypy3Packages = pypy3.pkgs;

  pythonManylinuxPackages = callPackage ./../development/interpreters/python/manylinux { };

  update-python-libraries = callPackage ../development/interpreters/python/update-python-libraries { };

  # Should eventually be moved inside Python interpreters.
  python-setup-hook = callPackage ../development/interpreters/python/setup-hook.nix { };

  python2nix = callPackage ../tools/package-management/python2nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/cpython/docs {});

  pypi2nix = callPackage ../development/tools/pypi2nix {};

  setupcfg2nix = python3Packages.callPackage ../development/tools/setupcfg2nix {};

  # These pyside tools do not provide any Python modules and are meant to be here.
  # See ../development/python-modules/pyside/default.nix for details.
  pysideApiextractor = callPackage ../development/python-modules/pyside/apiextractor.nix { };
  pysideGeneratorrunner = callPackage ../development/python-modules/pyside/generatorrunner.nix { };

  svg2tikz = python27Packages.svg2tikz;

  pew = callPackage ../development/tools/pew {};

  poetry = callPackage ../development/tools/poetry {
    python = python3;
  };
  poetry2nix = callPackage ../development/tools/poetry2nix/poetry2nix {
    inherit pkgs lib;
  };

  pipenv = callPackage ../development/tools/pipenv {};

  pipewire = callPackage ../development/libraries/pipewire {};

  pyradio = callPackage ../applications/radio/pyradio {};

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

  rakudo = callPackage ../development/interpreters/rakudo {};
  moarvm = callPackage ../development/interpreters/rakudo/moarvm.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };
  nqp = callPackage  ../development/interpreters/rakudo/nqp.nix { };
  zef = callPackage ../development/interpreters/rakudo/zef.nix { };

  rascal = callPackage ../development/interpreters/rascal { };

  red = callPackage ../development/interpreters/red { };

  regextester = callPackage ../applications/misc/regextester { };

  regina = callPackage ../development/interpreters/regina { };

  inherit (ocamlPackages) reason;

  renpy = callPackage ../development/interpreters/renpy { };

  pixie = callPackage ../development/interpreters/pixie { };
  dust = callPackage ../development/interpreters/pixie/dust.nix { };

  buildRubyGem = callPackage ../development/ruby-modules/gem { };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config { };
  bundix = callPackage ../development/ruby-modules/bundix { };
  bundler = callPackage ../development/ruby-modules/bundler { };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };
  bundlerApp = callPackage ../development/ruby-modules/bundler-app { };
  bundlerUpdateScript = callPackage ../development/ruby-modules/bundler-update-script { };

  bundler-audit = callPackage ../tools/security/bundler-audit { };

  solargraph = callPackage ../development/ruby-modules/solargraph { };

  inherit (callPackage ../development/interpreters/ruby {
    inherit (darwin) libiconv libobjc libunwind;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  })
    ruby_2_5
    ruby_2_6
    ruby_2_7;

  rubyMinimal = ruby.override {
    # gem support is minimal overhead
    rubygemsSupport = true;
    useRailsExpress = false;
    zlibSupport = false;
    opensslSupport = false;
    gdbmSupport = false;
    cursesSupport = false;
    docSupport = false;
    yamlSupport = false;
    fiddleSupport = false;
  };

  ruby = ruby_2_6;
  rubyPackages = rubyPackages_2_6;

  rubyPackages_2_5 = recurseIntoAttrs ruby_2_5.gems;
  rubyPackages_2_6 = recurseIntoAttrs ruby_2_6.gems;
  rubyPackages_2_7 = recurseIntoAttrs ruby_2_7.gems;

  mruby = callPackage ../development/compilers/mruby { };

  scsh = callPackage ../development/interpreters/scsh { };

  scheme48 = callPackage ../development/interpreters/scheme48 { };

  self = pkgsi686Linux.callPackage ../development/interpreters/self { };

  spark = callPackage ../applications/networking/cluster/spark { };

  spidermonkey_1_8_5 = callPackage ../development/interpreters/spidermonkey/1.8.5.nix { };
  spidermonkey_38 = callPackage ../development/interpreters/spidermonkey/38.nix ({
    inherit (darwin) libobjc;
  } // (stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
      stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
  }));
  spidermonkey_60 = callPackage ../development/interpreters/spidermonkey/60.nix { };
  spidermonkey = spidermonkey_38;

  ssm-agent = callPackage ../applications/networking/cluster/ssm-agent { };

  supercollider = libsForQt5.callPackage ../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  taktuk = callPackage ../applications/networking/cluster/taktuk { };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };

  wasm = ocamlPackages.wasm;

  proglodyte-wasm = callPackage ../development/interpreters/proglodyte-wasm { };


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

  h3 = callPackage ../development/misc/h3 { };

  amtk = callPackage ../development/libraries/amtk { };

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

  jruby = callPackage ../development/interpreters/jruby { };

  jython = callPackage ../development/interpreters/jython {};

  gImageReader = callPackage ../applications/misc/gImageReader { };

  guile-cairo = callPackage ../development/guile-modules/guile-cairo { };

  guile-fibers = callPackage ../development/guile-modules/guile-fibers { };

  guile-gnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome2.GConf;
    guile = guile_2_0;
    inherit (gnome2) gnome_vfs libglade libgnome libgnomecanvas libgnomeui;
  };

  guile-lib = callPackage ../development/guile-modules/guile-lib { };

  guile-ncurses = callPackage ../development/guile-modules/guile-ncurses { };

  guile-opengl = callPackage ../development/guile-modules/guile-opengl { };

  guile-reader = callPackage ../development/guile-modules/guile-reader { };

  guile-sdl = callPackage ../development/guile-modules/guile-sdl { };

  guile-sdl2 = callPackage ../development/guile-modules/guile-sdl2 { };

  guile-xcb = callPackage ../development/guile-modules/guile-xcb {
    guile = guile_2_0;
  };

  inav = callPackage ../development/misc/stm32/inav {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  msp430GccSupport = callPackage ../development/misc/msp430/gcc-support.nix { };

  msp430Newlib      = callPackage ../development/misc/msp430/newlib.nix { };
  msp430NewlibCross = callPackage ../development/misc/msp430/newlib.nix {
    inherit (buildPackages.xorg) lndir;
    newlib = newlibCross;
  };

  mspdebug = callPackage ../development/misc/msp430/mspdebug.nix { };

  vc4-newlib = callPackage ../development/misc/vc4/newlib.nix {};
  resim = callPackage ../misc/emulators/resim {};

  rappel = callPackage ../development/misc/rappel/default.nix { };

  pharo-vms = callPackage ../development/pharo/vm { };
  pharo = pharo-vms.multi-vm-wrapper;
  pharo-cog32 = pharo-vms.cog32;
  pharo-spur32 = pharo-vms.spur32;
  pharo-spur64 = assert stdenv.is64bit; pharo-vms.spur64;
  pharo-launcher = callPackage ../development/pharo/launcher { };

  srandrd = callPackage ../tools/X11/srandrd { };

  srecord = callPackage ../development/tools/misc/srecord { };

  srelay = callPackage ../tools/networking/srelay { };

  xidel = callPackage ../tools/text/xidel { };


  ### DEVELOPMENT / TOOLS

  abi-compliance-checker = callPackage ../development/tools/misc/abi-compliance-checker { };

  abi-dumper = callPackage ../development/tools/misc/abi-dumper { };

  adtool = callPackage ../tools/admin/adtool { };

  inherit (callPackage ../development/tools/alloy { })
    alloy4
    alloy5
    alloy;

  ameba = callPackage ../development/tools/ameba { };

  augeas = callPackage ../tools/system/augeas { };

  inherit (callPackage ../tools/admin/ansible { })
    ansible
    ansible_2_6
    ansible_2_7
    ansible_2_8
    ansible_2_9;

  ansible-lint = with python3.pkgs; toPythonApplication ansible-lint;

  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3_4 = callPackage ../development/tools/parsing/antlr/3.4.nix { };
  antlr3_5 = callPackage ../development/tools/parsing/antlr/3.5.nix { };
  antlr3 = antlr3_5;

  antlr4_7 = callPackage ../development/tools/parsing/antlr/4.7.nix { };
  antlr4 = antlr4_7;

  apacheAnt = callPackage ../development/tools/build-managers/apache-ant { };
  apacheAnt_1_9 = callPackage ../development/tools/build-managers/apache-ant/1.9.nix { };
  ant = apacheAnt;

  apacheKafka = apacheKafka_2_4;
  apacheKafka_0_9 = callPackage ../servers/apache-kafka { majorVersion = "0.9"; };
  apacheKafka_0_10 = callPackage ../servers/apache-kafka { majorVersion = "0.10"; };
  apacheKafka_0_11 = callPackage ../servers/apache-kafka { majorVersion = "0.11"; };
  apacheKafka_1_0 = callPackage ../servers/apache-kafka { majorVersion = "1.0"; };
  apacheKafka_1_1 = callPackage ../servers/apache-kafka { majorVersion = "1.1"; };
  apacheKafka_2_0 = callPackage ../servers/apache-kafka { majorVersion = "2.0"; };
  apacheKafka_2_1 = callPackage ../servers/apache-kafka { majorVersion = "2.1"; };
  apacheKafka_2_2 = callPackage ../servers/apache-kafka { majorVersion = "2.2"; };
  apacheKafka_2_3 = callPackage ../servers/apache-kafka { majorVersion = "2.3"; };
  apacheKafka_2_4 = callPackage ../servers/apache-kafka { majorVersion = "2.4"; };

  kt = callPackage ../tools/misc/kt {};

  argbash = callPackage ../development/tools/misc/argbash {};

  arpa2cm = callPackage ../development/tools/build-managers/arpa2cm { };

  asn2quickder = python2Packages.callPackage ../development/tools/asn2quickder {};

  astyle = callPackage ../development/tools/misc/astyle { };

  awf = callPackage ../development/tools/misc/awf { };

  aws-adfs = with python3Packages; toPythonApplication aws-adfs;

  inherit (callPackages ../development/tools/electron { })
    electron_4 electron_5 electron_6 electron_7 electron_8;

  electron_3 = callPackage ../development/tools/electron/3.x.nix { };
  electron = electron_4;

  autobuild = callPackage ../development/tools/misc/autobuild { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf-archive = callPackage ../development/tools/misc/autoconf-archive { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };
  autoconf264 = callPackage ../development/tools/misc/autoconf/2.64.nix { };

  autocutsel = callPackage ../tools/X11/autocutsel{ };

  automake = automake116x;

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake115x = callPackage ../development/tools/misc/automake/automake-1.15.x.nix { };

  automake116x = callPackage ../development/tools/misc/automake/automake-1.16.x.nix { };

  automoc4 = callPackage ../development/tools/misc/automoc4 { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  babeltrace = callPackage ../development/tools/misc/babeltrace { };

  bam = callPackage ../development/tools/build-managers/bam {};

  bazel = callPackage ../development/tools/build-managers/bazel/bazel-latest {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk8;
    buildJdkName = "jdk8";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  bazel_0 = bazel_0_26;

  bazel_0_26 = callPackage ../development/tools/build-managers/bazel/bazel_0_26 {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk8;
    buildJdkName = "jdk8";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  bazel_0_29 = callPackage ../development/tools/build-managers/bazel/bazel_0_29 {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk8;
    buildJdkName = "jdk8";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  bazel_1 = callPackage ../development/tools/build-managers/bazel/bazel_1 {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation CoreServices Foundation;
    buildJdk = jdk8;
    buildJdkName = "jdk8";
    runJdk = jdk11_headless;
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  bazel-buildtools = callPackage ../development/tools/build-managers/bazel/buildtools { };
  buildifier = bazel-buildtools;
  buildozer = bazel-buildtools;
  unused_deps = bazel-buildtools;

  bazel-remote = callPackage ../development/tools/build-managers/bazel/bazel-remote { };

  bazel-watcher = callPackage ../development/tools/bazel-watcher {
    go = go_1_12;
  };

  bazelisk = callPackage ../development/tools/bazelisk { };

  buildBazelPackage = callPackage ../build-support/build-bazel-package { };

  bear = callPackage ../development/tools/build-managers/bear { };

  bin_replace_string = callPackage ../development/tools/misc/bin_replace_string { };

  bingrep = callPackage ../development/tools/analysis/bingrep { };

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

  bison = callPackage ../development/tools/parsing/bison { };
  yacc = bison; # TODO: move to aliases.nix

  blackmagic = callPackage ../development/tools/misc/blackmagic { };

  bloaty = callPackage ../development/tools/bloaty { };

  bloop = callPackage ../development/tools/build-managers/bloop { };

  bossa = callPackage ../development/tools/misc/bossa {
    wxGTK = wxGTK30;
  };

  buck = callPackage ../development/tools/build-managers/buck { };

  buildkite-agent = buildkite-agent3;
  buildkite-agent2 = throw "pkgs.buildkite-agent2 has been discontinued. Please use pkgs.buildkite-agent (v3.x)";
  buildkite-agent3 = callPackage ../development/tools/continuous-integration/buildkite-agent { };

  libbpf = callPackage ../os-specific/linux/libbpf { };

  bpftool = callPackage ../os-specific/linux/bpftool { };

  bpm-tools = callPackage ../tools/audio/bpm-tools { };

  byacc = callPackage ../development/tools/parsing/byacc { };

  cadre = callPackage ../development/tools/cadre { };

  cask = callPackage ../development/tools/cask { };

  casperjs = callPackage ../development/tools/casperjs {
    inherit (texFunctions) fontsConf;
  };

  cbrowser = callPackage ../development/tools/misc/cbrowser { };

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
  ccacheWrapper = makeOverridable ({ extraConfig ? "", cc ? stdenv.cc }:
    cc.override { cc = ccache.links {
      inherit extraConfig;
      unwrappedCC = cc.cc;
    }; }) {};
  ccacheStdenv = lowPrio (overrideCC stdenv buildPackages.ccacheWrapper);

  cccc = callPackage ../development/tools/analysis/cccc { };

  cgdb = callPackage ../development/tools/misc/cgdb { };

  cheat = callPackage ../applications/misc/cheat { };

  chefdk = callPackage ../development/tools/chefdk { };

  matter-compiler = callPackage ../development/compilers/matter-compiler {};

  cfr = callPackage ../development/tools/java/cfr { };

  checkstyle = callPackage ../development/tools/analysis/checkstyle { };

  chromedriver = callPackage ../development/tools/selenium/chromedriver { gconf = gnome2.GConf; };

  chromium-xorg-conf = callPackage ../os-specific/linux/chromium-xorg-conf { };

  chrpath = callPackage ../development/tools/misc/chrpath { };

  chruby = callPackage ../development/tools/misc/chruby { rubies = null; };

  cl-launch = callPackage ../development/tools/misc/cl-launch {};

  cloud-nuke = callPackage ../development/tools/cloud-nuke { };

  cloudfoundry-cli = callPackage ../development/tools/cloudfoundry-cli { };

  coan = callPackage ../development/tools/analysis/coan { };

  compile-daemon = callPackage ../development/tools/compile-daemon { };

  complexity = callPackage ../development/tools/misc/complexity { };

  conan = callPackage ../development/tools/build-managers/conan { };

  cookiecutter = with python3Packages; toPythonApplication cookiecutter;

  corundum = callPackage ../development/tools/corundum { };

  confluent-platform = callPackage ../servers/confluent-platform {};

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = callPackage ../development/tools/misc/ctags/wrapped.nix {};

  ctodo = callPackage ../applications/misc/ctodo { };

  ctmg = callPackage ../tools/security/ctmg { };

  cmake_2_8 = callPackage ../development/tools/build-managers/cmake/2.8.nix { };

  cmake = libsForQt5.callPackage ../development/tools/build-managers/cmake { };

  cmakeCurses = cmake.override { useNcurses = true; };

  cmakeWithGui = cmakeCurses.override { withQt5 = true; };
  cmakeWithQt4Gui = cmakeCurses.override { useQt4 = true; };

  cmake-format = python3Packages.callPackage ../development/tools/cmake-format { };

  # Does not actually depend on Qt 5
  inherit (kdeFrameworks) extra-cmake-modules kapidox kdoctools;

  coccinelle = callPackage ../development/tools/misc/coccinelle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  cpptest = callPackage ../development/libraries/cpptest { };

  cppi = callPackage ../development/tools/misc/cppi { };

  cproto = callPackage ../development/tools/misc/cproto { };

  cflow = callPackage ../development/tools/misc/cflow { };

  cov-build = callPackage ../development/tools/analysis/cov-build {};

  cppcheck = callPackage ../development/tools/analysis/cppcheck { };

  cpplint = callPackage ../development/tools/analysis/cpplint { };

  cquery = callPackage ../development/tools/misc/cquery {
    # 7 is the default, but only on Linux, so keep this for now
    llvmPackages = llvmPackages_7;
  };


  ccls = callPackage ../development/tools/misc/ccls {
    llvmPackages = llvmPackages_8;
    stdenv = llvmPackages_8.stdenv;
  };

  credstash = with python3Packages; toPythonApplication credstash;

  creduce = callPackage ../development/tools/misc/creduce {
    inherit (llvmPackages_7) llvm clang-unwrapped;
  };

  cscope = callPackage ../development/tools/misc/cscope { };

  csmith = callPackage ../development/tools/misc/csmith { };

  csslint = callPackage ../development/web/csslint { };

  libcxx = llvmPackages.libcxx;
  libcxxabi = llvmPackages.libcxxabi;

  librarian-puppet-go = callPackage ../development/tools/librarian-puppet-go { };

  libgcc = callPackage ../development/libraries/gcc/libgcc {
    stdenvNoLibs = gccStdenvNoLibs; # cannot be built with clang it seems
  };

  libstdcxx5 = callPackage ../development/libraries/gcc/libstdc++/5.nix { };

  libsigrok = callPackage ../development/tools/libsigrok { };
  # old version:
  libsigrok-0-3-0 = libsigrok.override {
    version = "0.3.0";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };

  libsigrokdecode = callPackage ../development/tools/libsigrokdecode { };

  # special forks used for dsview
  libsigrok4dsl = callPackage ../applications/science/electronics/dsview/libsigrok4dsl.nix { };
  libsigrokdecode4dsl = callPackage ../applications/science/electronics/dsview/libsigrokdecode4dsl.nix { };

  cli11 = callPackage ../development/tools/misc/cli11 { };

  dcadec = callPackage ../development/tools/dcadec { };

  dejagnu = callPackage ../development/tools/misc/dejagnu { };

  devd = callPackage ../development/tools/devd { };

  devtodo = callPackage ../development/tools/devtodo { };

  dfeet = callPackage ../development/tools/misc/d-feet { };

  dfu-programmer = callPackage ../development/tools/misc/dfu-programmer { };

  dfu-util = callPackage ../development/tools/misc/dfu-util { };

  ddd = callPackage ../development/tools/misc/ddd { };

  lattice-diamond = callPackage ../development/tools/lattice-diamond { };

  direvent = callPackage ../development/tools/misc/direvent { };

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

  dive = callPackage ../development/tools/dive { };

  doclifter = callPackage ../development/tools/misc/doclifter { };

  docutils = with python3Packages; toPythonApplication docutils;

  doctl = callPackage ../development/tools/doctl { };

  doit = callPackage ../development/tools/build-managers/doit { };

  dolt = callPackage ../servers/sql/dolt { };

  dot2tex = pythonPackages.dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt4 = null;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  doxygen_gui = lowPrio (doxygen.override { inherit qt4; });

  drake = callPackage ../development/tools/build-managers/drake { };

  drip = callPackage ../development/tools/drip { };

  drm_info = callPackage ../development/tools/drm_info { };

  drush = callPackage ../development/tools/misc/drush { };

  editorconfig-checker = callPackage ../development/tools/misc/editorconfig-checker { };

  editorconfig-core-c = callPackage ../development/tools/misc/editorconfig-core-c { };

  eggdbus = callPackage ../development/tools/misc/eggdbus { };

  egypt = callPackage ../development/tools/analysis/egypt { };

  elfinfo = callPackage ../development/tools/misc/elfinfo { };

  elfkickers = callPackage ../development/tools/misc/elfkickers { };

  elfutils = callPackage ../development/tools/misc/elfutils { };

  emma = callPackage ../development/tools/analysis/emma { };

  epm = callPackage ../development/tools/misc/epm { };

  eresi = callPackage ../development/tools/analysis/eresi { };

  evmdis = callPackage ../development/tools/analysis/evmdis { };

  eweb = callPackage ../development/tools/literate-programming/eweb { };

  eztrace = callPackage ../development/tools/profiling/EZTrace { };

  ezquake = callPackage ../games/ezquake { };

  findbugs = callPackage ../development/tools/analysis/findbugs { };

  findnewest = callPackage ../development/tools/misc/findnewest { };

  flootty = callPackage ../development/tools/flootty { };

  fffuu = haskell.lib.justStaticExecutables (haskellPackages.callPackage ../tools/misc/fffuu { });

  flow = callPackage ../development/tools/analysis/flow {
    ocamlPackages = ocaml-ng.ocamlPackages_4_07;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fly = callPackage ../development/tools/continuous-integration/fly { };

  foreman = callPackage ../tools/system/foreman { };
  goreman = callPackage ../tools/system/goreman { };

  framac = callPackage ../development/tools/analysis/frama-c { };

  frame = callPackage ../development/libraries/frame { };

  frp = callPackage ../tools/networking/frp { };

  fsatrace = callPackage ../development/tools/misc/fsatrace { };

  fswatch = callPackage ../development/tools/misc/fswatch {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  funnelweb = callPackage ../development/tools/literate-programming/funnelweb { };

  gede = libsForQt5.callPackage ../development/tools/misc/gede { };

  gdbgui = python3Packages.callPackage ../development/tools/misc/gdbgui { };

  pmd = callPackage ../development/tools/analysis/pmd { };

  pmdk = callPackage ../development/libraries/pmdk { };

  jdepend = callPackage ../development/tools/analysis/jdepend { };

  fedpkg = pythonPackages.callPackage ../development/tools/fedpkg { };

  flex_2_5_35 = callPackage ../development/tools/parsing/flex/2.5.35.nix { };
  flex = callPackage ../development/tools/parsing/flex { };

  flexibee = callPackage ../applications/office/flexibee { };

  flexcpp = callPackage ../development/tools/parsing/flexc++ { };

  geis = callPackage ../development/libraries/geis {
    inherit (xorg) libX11 libXext libXi libXtst;
  };

  github-release = callPackage ../development/tools/github/github-release { };

  global = callPackage ../development/tools/misc/global { };

  gnome-doc-utils = callPackage ../development/tools/documentation/gnome-doc-utils {};

  gnome-desktop-testing = callPackage ../development/tools/gnome-desktop-testing {};

  gnome-firmware-updater = callPackage ../applications/misc/gnome-firmware-updater {};

  gnome-hexgl = callPackage ../games/gnome-hexgl {};

  gnome-usage = callPackage ../applications/misc/gnome-usage {};

  gnome-latex = callPackage ../applications/editors/gnome-latex/default.nix { };

  gnome-multi-writer = callPackage ../applications/misc/gnome-multi-writer {};

  gnome-online-accounts = callPackage ../development/libraries/gnome-online-accounts { };

  gnome-video-effects = callPackage ../development/libraries/gnome-video-effects { };

  gnum4 = callPackage ../development/tools/misc/gnum4 { };
  m4 = gnum4;

  gnumake42 = callPackage ../development/tools/build-managers/gnumake/4.2 { };
  gnumake = gnumake42;

  gnustep = recurseIntoAttrs (callPackage ../desktops/gnustep {});

  gob2 = callPackage ../development/tools/misc/gob2 { };

  gocd-agent = callPackage ../development/tools/continuous-integration/gocd-agent { };

  gocd-server = callPackage ../development/tools/continuous-integration/gocd-server { };

  gotify-server = callPackage ../servers/gotify { };

  gotty = callPackage ../servers/gotty { };

  gputils = callPackage ../development/tools/misc/gputils { };

  gradleGen = callPackage ../development/tools/build-managers/gradle {
    java = jdk;
  };
  gradle = res.gradleGen.gradle_latest;
  gradle_4_10 = res.gradleGen.gradle_4_10;
  gradle_4 = gradle_4_10;
  gradle_5 = res.gradleGen.gradle_5_6;

  gperf = callPackage ../development/tools/misc/gperf { };
  # 3.1 changed some parameters from int to size_t, leading to mismatches.
  gperf_3_0 = callPackage ../development/tools/misc/gperf/3.0.x.nix { };

  grail = callPackage ../development/libraries/grail { };

  graphene-hardened-malloc = callPackage ../development/libraries/graphene-hardened-malloc { };

  graphene = callPackage ../development/libraries/graphene { };

  gtk-doc = callPackage ../development/tools/documentation/gtk-doc { };

  gtkdialog = callPackage ../development/tools/misc/gtkdialog { };

  gtranslator = callPackage ../tools/text/gtranslator { };

  guff = callPackage ../tools/graphics/guff { };

  guile-lint = callPackage ../development/tools/guile/guile-lint {
    guile = guile_1_8;
  };

  gwrap = callPackage ../development/tools/guile/g-wrap {
    guile = guile_2_0;
  };

  hadolint = haskell.lib.justStaticExecutables haskellPackages.hadolint;

  halfempty = callPackage ../development/tools/halfempty {};

  hcloud = callPackage ../development/tools/hcloud { };

  help2man = callPackage ../development/tools/misc/help2man { };

  heroku = callPackage ../development/tools/heroku {
    nodejs = nodejs-10_x;
  };

  ccloud-cli = callPackage ../development/tools/ccloud-cli { };

  htmlunit-driver = callPackage ../development/tools/selenium/htmlunit-driver { };

  hyenae = callPackage ../tools/networking/hyenae { };

  iaca_2_1 = callPackage ../development/tools/iaca/2.1.nix { };
  iaca_3_0 = callPackage ../development/tools/iaca/3.0.nix { };
  iaca = iaca_3_0;

  icestorm = callPackage ../development/tools/icestorm { };

  icmake = callPackage ../development/tools/build-managers/icmake { };

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils { };

  ikos = callPackage ../development/tools/analysis/ikos {
    inherit (llvmPackages_7) stdenv clang llvm;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_8;
  };

  indent = callPackage ../development/tools/misc/indent { };

  ino = callPackage ../development/arduino/ino { };

  inotify-tools = callPackage ../development/tools/misc/inotify-tools { };

  intel-gpu-tools = callPackage ../development/tools/misc/intel-gpu-tools { };

  insomnia = callPackage ../development/web/insomnia { };

  iozone = callPackage ../development/tools/misc/iozone { };

  itstool = callPackage ../development/tools/misc/itstool { };

  jam = callPackage ../development/tools/build-managers/jam { };

  jamomacore = callPackage ../development/libraries/audio/jamomacore { };

  jbake = callPackage ../development/tools/jbake { };

  jikespg = callPackage ../development/tools/parsing/jikespg { };

  jenkins = callPackage ../development/tools/continuous-integration/jenkins { };

  jenkins-job-builder = with python3Packages; toPythonApplication jenkins-job-builder;

  kafkacat = callPackage ../development/tools/kafkacat { };

  kati = callPackage ../development/tools/build-managers/kati { };

  kcc = libsForQt5.callPackage ../applications/graphics/kcc { };

  kconfig-frontends = callPackage ../development/tools/misc/kconfig-frontends {
    gperf = gperf_3_0;
  };

  kcgi = callPackage ../development/web/kcgi { };

  kcov = callPackage ../development/tools/analysis/kcov { };

  kind = callPackage ../development/tools/kind {  };

  khronos-ocl-icd-loader = callPackage ../development/libraries/khronos-ocl-icd-loader {  };

  kube-aws = callPackage ../development/tools/kube-aws { };

  kubectx = callPackage ../development/tools/kubectx { };

  kube-prompt = callPackage ../development/tools/kube-prompt { };

  kubeprompt = callPackage ../development/tools/kubeprompt { };

  kubicorn = callPackage ../development/tools/kubicorn {  };

  kubie = callPackage ../development/tools/kubie { };

  kustomize = callPackage ../development/tools/kustomize { };

  ktlint = callPackage ../development/tools/ktlint { };

  kythe = callPackage ../development/tools/kythe { };

  lazygit = callPackage ../development/tools/lazygit { };

  Literate = callPackage ../development/tools/literate-programming/Literate {};

  lcov = callPackage ../development/tools/analysis/lcov { };

  leiningen = callPackage ../development/tools/build-managers/leiningen { };

  lemon = callPackage ../development/tools/parsing/lemon { };

  lenmus = callPackage ../applications/misc/lenmus { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  libwhich = callPackage ../development/tools/misc/libwhich { };

  linuxkit = callPackage ../development/tools/misc/linuxkit { };

  lit = callPackage ../development/tools/misc/lit { };

  litecli = callPackage ../development/tools/database/litecli {};

  lsof = callPackage ../development/tools/misc/lsof { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  lttng-tools = callPackage ../development/tools/misc/lttng-tools { };

  lttng-ust = callPackage ../development/tools/misc/lttng-ust { };

  lttv = callPackage ../development/tools/misc/lttv { };

  massif-visualizer = libsForQt5.callPackage ../development/tools/analysis/massif-visualizer { };

  maven = maven3;
  maven3 = callPackage ../development/tools/build-managers/apache-maven { };

  mavproxy = python3Packages.callPackage ../applications/science/robotics/mavproxy { };

  go-md2man = callPackage ../development/tools/misc/md2man {};

  mage = callPackage ../development/tools/build-managers/mage { };

  mbed-cli = callPackage ../development/tools/mbed-cli { };

  mdl = callPackage ../development/tools/misc/mdl { };

  minify = callPackage ../development/web/minify { };

  minizinc = callPackage ../development/tools/minizinc { };
  minizincide = qt5.callPackage ../development/tools/minizinc/ide.nix { };

  mk = callPackage ../development/tools/build-managers/mk { };

  mkcert = callPackage ../development/tools/misc/mkcert { };

  mkdocs = callPackage ../development/tools/documentation/mkdocs { };

  modd = callPackage ../development/tools/modd { };

  msgpack-tools = callPackage ../development/tools/msgpack-tools { };

  msgpuck = callPackage ../development/libraries/msgpuck { };

  msitools = callPackage ../development/tools/misc/msitools { };

  haskell-ci = haskell.lib.justStaticExecutables haskellPackages.haskell-ci;

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
    fontsConf = makeFontsConf {
      fontDirectories = [
        dejavu_fonts.minimal
      ];
    };
  };

  nailgun = callPackage ../development/tools/nailgun { };

  ninja = callPackage ../development/tools/build-managers/ninja { };

  gn = callPackage ../development/tools/build-managers/gn { };

  nixbang = callPackage ../development/tools/misc/nixbang {
    pythonPackages = python3Packages;
  };

  nexus = callPackage ../development/tools/repository-managers/nexus { };

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

  # NOTE: Override and set icon-lang = null to use Awk instead of Icon.
  noweb = callPackage ../development/tools/literate-programming/noweb { };

  nuweb = callPackage ../development/tools/literate-programming/nuweb { tex = texlive.combined.scheme-medium; };

  nrfutil = callPackage ../development/tools/misc/nrfutil { };

  obelisk = callPackage ../development/tools/ocaml/obelisk { };

  obuild = callPackage ../development/tools/ocaml/obuild { };

  omake = callPackage ../development/tools/ocaml/omake { };

  omniorb = callPackage ../development/tools/omniorb { };

  opengrok = callPackage ../development/tools/misc/opengrok { };

  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = callPackage ../development/tools/profiling/oprofile {
    libiberty_static = libiberty.override { staticBuild = true; };
  };

  pahole = callPackage ../development/tools/misc/pahole {};

  panopticon = callPackage ../development/tools/analysis/panopticon {};

  pants = callPackage ../development/tools/build-managers/pants {};

  parinfer-rust = callPackage ../development/tools/parinfer-rust {};

  parse-cli-bin = callPackage ../development/tools/parse-cli-bin { };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = lowPrio (callPackage ../development/tools/misc/patchelf/unstable.nix { });

  pax-rs = callPackage ../development/tools/pax-rs { };

  peg = callPackage ../development/tools/parsing/peg { };

  pgcli = pkgs.python3Packages.pgcli;

  phantomjs = callPackage ../development/tools/phantomjs { };

  phantomjs2 = libsForQt5.callPackage ../development/tools/phantomjs2 { };

  pmccabe = callPackage ../development/tools/misc/pmccabe { };

  pkgconf = callPackage ../development/tools/misc/pkgconf {};

  pkg-config = callPackage ../development/tools/misc/pkg-config { };
  pkgconfig = pkg-config; # added 2018-02-02

  pkg-configUpstream = lowPrio (pkg-config.override { vanilla = true; });
  pkgconfigUpstream = pkg-configUpstream; # added 2018-02-02

  postiats-utilities = callPackage ../development/tools/postiats-utilities {};

  postman = callPackage ../development/web/postman {};

  pprof = callPackage ../development/tools/profiling/pprof { };

  pyprof2calltree = with python3Packages; toPythonApplication pyprof2calltree;

  prelink = callPackage ../development/tools/misc/prelink { };

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake5 = callPackage ../development/tools/misc/premake/5.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  premake = premake4;

  procodile = callPackage ../tools/system/procodile { };

  pry = callPackage ../development/tools/pry { };

  pup = callPackage ../development/tools/pup { };

  puppet-lint = callPackage ../development/tools/puppet/puppet-lint { };

  pyrseas = callPackage ../development/tools/database/pyrseas { };

  qtcreator = libsForQt5.callPackage ../development/tools/qtcreator { };

  r10k = callPackage ../tools/system/r10k { };

  inherit (callPackages ../development/tools/analysis/radare2 ({
    inherit (gnome2) vte;
    lua = lua5;
  } // (config.radare or {}))) radare2 r2-for-cutter;

  radare2-cutter = libsForQt5.callPackage ../development/tools/analysis/radare2/cutter.nix { };

  ragel = ragelStable;

  randoop = callPackage ../development/tools/analysis/randoop { };

  inherit (callPackages ../development/tools/parsing/ragel {
      tex = texlive.combined.scheme-small;
    }) ragelStable ragelDev;

  hammer = callPackage ../development/tools/parsing/hammer { };

  rdocker = callPackage ../development/tools/rdocker { };

  redis-dump = callPackage ../development/tools/redis-dump { };

  redo = callPackage ../development/tools/build-managers/redo { };

  redo-apenwarr = callPackage ../development/tools/build-managers/redo-apenwarr { };

  redo-sh = callPackage ../development/tools/build-managers/redo-sh { };

  reno = callPackage ../development/tools/reno { };

  re2c = callPackage ../development/tools/parsing/re2c { };

  remake = callPackage ../development/tools/build-managers/remake { };

  retdec = callPackage ../development/tools/analysis/retdec {
    stdenv = gcc8Stdenv;
  };
  retdec-full = retdec.override {
    withPEPatterns = true;
  };

  reviewdog = callPackage ../development/tools/misc/reviewdog { };

  rman = callPackage ../development/tools/misc/rman { };

  rnix-lsp = callPackage ../development/tools/rnix-lsp { };

  rolespec = callPackage ../development/tools/misc/rolespec { };

  rr = callPackage ../development/tools/analysis/rr { };

  samurai = callPackage ../development/tools/build-managers/samurai { };

  saleae-logic = callPackage ../development/tools/misc/saleae-logic { };

  sauce-connect = callPackage ../development/tools/sauce-connect { };

  scaff = callPackage ../development/tools/scaff { };

  selenium-server-standalone = callPackage ../development/tools/selenium/server { };

  selendroid = callPackage ../development/tools/selenium/selendroid { };

  semver-tool = callPackage ../development/tools/misc/semver-tool { };

  sconsPackages = dontRecurseIntoAttrs (callPackage ../development/tools/build-managers/scons { });
  scons = sconsPackages.scons_latest;

  mill = callPackage ../development/tools/build-managers/mill { };

  sbt = callPackage ../development/tools/build-managers/sbt { };
  sbt-with-scala-native = callPackage ../development/tools/build-managers/sbt/scala-native.nix { };
  simpleBuildTool = sbt;

  sbt-extras = callPackage ../development/tools/build-managers/sbt-extras { };

  scc = callPackage ../development/tools/misc/scc { };

  scss-lint = callPackage ../development/tools/scss-lint { };

  shadowenv = callPackage ../tools/misc/shadowenv {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  shake = haskell.lib.justStaticExecutables haskellPackages.shake;

  shallot = callPackage ../tools/misc/shallot { };

  shards = callPackage ../development/tools/build-managers/shards { };

  shellcheck = callPackage ../development/tools/shellcheck {};

  schemaspy = callPackage ../development/tools/database/schemaspy { };

  shncpd = callPackage ../tools/networking/shncpd { };

  sigrok-cli = callPackage ../development/tools/sigrok-cli { };

  silicon = callPackage ../tools/misc/silicon {
    inherit (darwin.apple_sdk.frameworks) AppKit CoreText Security;
  };

  simpleTpmPk11 = callPackage ../tools/security/simple-tpm-pk11 { };

  slimerjs = callPackage ../development/tools/slimerjs {};

  sloccount = callPackage ../development/tools/misc/sloccount { };

  sloc = nodePackages.sloc;

  smatch = callPackage ../development/tools/analysis/smatch {
    buildllvmsparse = false;
    buildc2xml = false;
  };

  smc = callPackage ../tools/misc/smc { };

  snakemake = callPackage ../applications/science/misc/snakemake { };

  snore = callPackage ../tools/misc/snore { };

  snzip = callPackage ../tools/archivers/snzip { };

  snowman = qt5.callPackage ../development/tools/analysis/snowman { };

  sparse = callPackage ../development/tools/analysis/sparse { };

  speedtest-cli = with python3Packages; toPythonApplication speedtest-cli;

  spin = callPackage ../development/tools/analysis/spin { };

  spirv-headers = callPackage ../development/libraries/spirv-headers { };
  spirv-tools = callPackage ../development/tools/spirv-tools { };

  splint = callPackage ../development/tools/analysis/splint {
    flex = flex_2_5_35;
  };

  spoofer = callPackage ../tools/networking/spoofer { };

  spoofer-gui = callPackage ../tools/networking/spoofer { withGUI = true; };

  spooles = callPackage ../development/libraries/science/math/spooles {};

  sqlcheck = callPackage ../development/tools/database/sqlcheck { };

  sqlitebrowser = libsForQt5.callPackage ../development/tools/database/sqlitebrowser { };

  sqlite-web = callPackage ../development/tools/database/sqlite-web { };

  sqlmap = with python3Packages; toPythonApplication sqlmap;

  sselp = callPackage ../tools/X11/sselp{ };

  stm32cubemx = callPackage ../development/tools/misc/stm32cubemx { };

  stm32flash = callPackage ../development/tools/misc/stm32flash { };

  strace = callPackage ../development/tools/misc/strace { };

  swarm = callPackage ../development/tools/analysis/swarm { };

  swiftformat = callPackage ../development/tools/swiftformat { };

  swig1 = callPackage ../development/tools/misc/swig { };
  swig2 = callPackage ../development/tools/misc/swig/2.x.nix { };
  swig3 = callPackage ../development/tools/misc/swig/3.x.nix { };
  swig4 = callPackage ../development/tools/misc/swig/4.nix { };
  swig = swig3;
  swigWithJava = swig;

  swfmill = callPackage ../tools/video/swfmill { };

  swftools = callPackage ../tools/video/swftools {
    stdenv = gccStdenv;
  };

  tcptrack = callPackage ../development/tools/misc/tcptrack { };

  teensyduino = arduino-core.override { withGui = true; withTeensyduino = true; };

  teensy-loader-cli = callPackage ../development/tools/misc/teensy-loader-cli { };

  terracognita = callPackage ../development/tools/misc/terracognita { };

  terraform-lsp = callPackage ../development/tools/misc/terraform-lsp { };

  texinfo413 = callPackage ../development/tools/misc/texinfo/4.13a.nix { };
  texinfo4 = texinfo413;
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.2.nix { };
  texinfo6 = callPackage ../development/tools/misc/texinfo/6.5.nix { };
  texinfo = texinfo6;
  texinfoInteractive = appendToName "interactive" (
    texinfo.override { interactive = true; }
  );

  texi2html = callPackage ../development/tools/misc/texi2html { };

  texi2mdoc = callPackage ../tools/misc/texi2mdoc { };

  texlab = callPackage ../development/tools/misc/texlab {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tflint = callPackage ../development/tools/analysis/tflint { };

  tfsec = callPackage ../development/tools/analysis/tfsec { };

  todoist = callPackage ../applications/misc/todoist { };

  todoist-electron = callPackage ../applications/misc/todoist-electron { };

  todolist = callPackage ../applications/misc/todolist { };

  travis = callPackage ../development/tools/misc/travis { };

  tree-sitter = callPackage ../development/tools/parsing/tree-sitter { };

  trellis = callPackage ../development/tools/trellis { };

  ttyd = callPackage ../servers/ttyd { };

  tweak = callPackage ../applications/editors/tweak { };

  tychus = callPackage ../development/tools/tychus {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  udis86 = callPackage  ../development/tools/udis86 { };

  uefi-firmware-parser = callPackage ../development/tools/analysis/uefi-firmware-parser { };

  uhd = callPackage ../applications/radio/uhd { };

  uisp = callPackage ../development/tools/misc/uisp { };

  uncrustify = callPackage ../development/tools/misc/uncrustify { };

  universal-ctags = callPackage ../development/tools/misc/universal-ctags { };

  vagrant = callPackage ../development/tools/vagrant {};

  bashdb = callPackage ../development/tools/misc/bashdb { };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
    readline = readline80;
  };

  jhiccup = callPackage ../development/tools/java/jhiccup { };

  valgrind = callPackage ../development/tools/analysis/valgrind {
    inherit (buildPackages.darwin) xnu bootstrap_cmds cctools;
  };
  valgrind-light = res.valgrind.override { gdb = null; };

  valkyrie = callPackage ../development/tools/analysis/valkyrie { };

  qcachegrind = libsForQt5.callPackage ../development/tools/analysis/qcachegrind {};

  visualvm = callPackage ../development/tools/java/visualvm { };

  vultr = callPackage ../development/tools/vultr { };

  vulnix = callPackage ../tools/security/vulnix { };

  vtable-dumper = callPackage ../development/tools/misc/vtable-dumper { };

  whatstyle = callPackage ../development/tools/misc/whatstyle {
    inherit (llvmPackages) clang-unwrapped;
  };

  watson-ruby = callPackage ../development/tools/misc/watson-ruby {};

  webdis = callPackage ../development/tools/database/webdis { };

  xc3sprog = callPackage ../development/tools/misc/xc3sprog { };

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

  xcpretty = callPackage ../development/tools/xcpretty { };

  xmlindent = callPackage ../development/web/xmlindent {};

  xpwn = callPackage ../development/mobile/xpwn {};

  xxdiff = libsForQt5.callPackage ../development/tools/misc/xxdiff { };

  xxdiff-tip = xxdiff;

  yaml2json = callPackage ../development/tools/yaml2json { };

  ycmd = callPackage ../development/tools/misc/ycmd {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    python = python3;
  };

  yodl = callPackage ../development/tools/misc/yodl { };

  yq = callPackage ../development/tools/yq {
    inherit (python3Packages) buildPythonApplication fetchPypi pyyaml xmltodict;
  };

  yq-go = callPackage ../development/tools/yq-go { };

  winpdb = callPackage ../development/tools/winpdb { };

  grabserial = callPackage ../development/tools/grabserial { };

  mypy = with python3Packages; toPythonApplication mypy;

  nsis = callPackage ../development/tools/nsis { };

  ### DEVELOPMENT / LIBRARIES

  a52dec = callPackage ../development/libraries/a52dec { };

  aalib = callPackage ../development/libraries/aalib { };

  abseil-cpp = callPackage ../development/libraries/abseil-cpp { };

  accountsservice = callPackage ../development/libraries/accountsservice { };

  acl = callPackage ../development/libraries/acl { };

  acsccid = callPackage ../tools/security/acsccid { };

  activemq = callPackage ../development/libraries/apache-activemq { };

  adns = callPackage ../development/libraries/adns { };

  afflib = callPackage ../development/libraries/afflib { };

  aften = callPackage ../development/libraries/aften { };

  alure = callPackage ../development/libraries/alure { };

  alure2 = callPackage ../development/libraries/alure2 { };

  agg = callPackage ../development/libraries/agg { };

  allegro = allegro4;
  allegro4 = callPackage ../development/libraries/allegro {};
  allegro5 = callPackage ../development/libraries/allegro/5.nix {};

  amrnb = callPackage ../development/libraries/amrnb { };

  amrwb = callPackage ../development/libraries/amrwb { };

  anttweakbar = callPackage ../development/libraries/AntTweakBar { };

  appstream = callPackage ../development/libraries/appstream { };

  appstream-glib = callPackage ../development/libraries/appstream-glib { };

  appstream-qt = libsForQt5.callPackage ../development/libraries/appstream/qt.nix { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    db = if stdenv.isFreeBSD then db4 else db;
    # XXX: only the db_185 interface was available through
    #      apr with db58 on freebsd (nov 2015), for unknown reasons
  };

  aravis = callPackage ../development/libraries/aravis {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad;
  };

  arb = callPackage ../development/libraries/arb {};

  argp-standalone = callPackage ../development/libraries/argp-standalone {};

  armadillo = callPackage ../development/libraries/armadillo {};

  arrayfire = callPackage ../development/libraries/arrayfire {};

  arrow-cpp = callPackage ../development/libraries/arrow-cpp ({
  } // stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
    stdenv = overrideCC stdenv buildPackages.gcc6; # hidden symbol `__divmoddi4'
  });

  assimp = callPackage ../development/libraries/assimp { };

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

  at-spi2-core = callPackage ../development/libraries/at-spi2-core { };

  at-spi2-atk = callPackage ../development/libraries/at-spi2-atk { };

  aqbanking = callPackage ../development/libraries/aqbanking { };

  aubio = callPackage ../development/libraries/aubio { };

  audiofile = callPackage ../development/libraries/audiofile {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreServices;
  };

  aws-c-common = callPackage ../development/libraries/aws-c-common { };

  aws-c-event-stream = callPackage ../development/libraries/aws-c-event-stream { };

  aws-checksums = callPackage ../development/libraries/aws-checksums { };

  aws-sdk-cpp = callPackage ../development/libraries/aws-sdk-cpp {
    inherit (darwin.apple_sdk.frameworks) CoreAudio AudioToolbox;
  };

  babl = callPackage ../development/libraries/babl { };

  backward-cpp = callPackage ../development/libraries/backward-cpp { };

  bamf = callPackage ../development/libraries/bamf { };

  bcg729 = callPackage ../development/libraries/bcg729 { };

  bctoolbox = callPackage ../development/libraries/bctoolbox { };

  beecrypt = callPackage ../development/libraries/beecrypt { };

  belcard = callPackage ../development/libraries/belcard { };

  belr = callPackage ../development/libraries/belr { };

  beignet = callPackage ../development/libraries/beignet {
    inherit (llvmPackages_6) llvm clang-unwrapped;
  };

  belle-sip = callPackage ../development/libraries/belle-sip {
    stdenv = gcc8Stdenv;
  };

  libbfd = callPackage ../development/libraries/libbfd { };

  libopcodes = callPackage ../development/libraries/libopcodes { };

  bicpl = callPackage ../development/libraries/science/biology/bicpl { };

  bicgl = callPackage ../development/libraries/science/biology/bicgl { };

  # TODO(@Ericson2314): Build bionic libc from source
  bionic = assert stdenv.hostPlatform.useAndroidPrebuilt;
    pkgs."androidndkPkgs_${stdenv.hostPlatform.ndkVer}".libraries;

  bobcat = callPackage ../development/libraries/bobcat { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };
  boehmgc_766 = callPackage ../development/libraries/boehm-gc/7.6.6.nix { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost155 = callPackage ../development/libraries/boost/1.55.nix { };
  boost159 = callPackage ../development/libraries/boost/1.59.nix { };
  boost15x = boost159;
  boost160 = callPackage ../development/libraries/boost/1.60.nix { };
  boost165 = callPackage ../development/libraries/boost/1.65.nix { };
  boost166 = callPackage ../development/libraries/boost/1.66.nix { };
  boost167 = callPackage ../development/libraries/boost/1.67.nix { };
  boost168 = callPackage ../development/libraries/boost/1.68.nix { };
  boost169 = callPackage ../development/libraries/boost/1.69.nix { };
  boost16x = boost169;
  boost170 = callPackage ../development/libraries/boost/1.70.nix { };
  boost171 = callPackage ../development/libraries/boost/1.71.nix { };
  boost17x = boost171;
  boost = boost16x;

  boost_process = callPackage ../development/libraries/boost-process { };

  botan = callPackage ../development/libraries/botan { openssl = openssl_1_0_2; };
  botan2 = callPackage ../development/libraries/botan/2.0.nix { };

  box2d = callPackage ../development/libraries/box2d { };

  boxfort = callPackage ../development/libraries/boxfort { };

  buddy = callPackage ../development/libraries/buddy { };

  bulletml = callPackage ../development/libraries/bulletml { };

  bwidget = callPackage ../development/libraries/bwidget { };

  bzrtp = callPackage ../development/libraries/bzrtp { };

  c-ares = callPackage ../development/libraries/c-ares { };

  c-blosc = callPackage ../development/libraries/c-blosc { };

  # justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
  cachix = haskell.lib.justStaticExecutables haskellPackages.cachix;

  niv = haskellPackages.niv.bin;

  ormolu = haskellPackages.ormolu.bin;

  capnproto = callPackage ../development/libraries/capnproto { };

  captive-browser = callPackage ../applications/networking/browsers/captive-browser { };

  ndn-cxx = callPackage ../development/libraries/ndn-cxx { };

  cddlib = callPackage ../development/libraries/cddlib {};

  cdk = callPackage ../development/libraries/cdk {};

  cdo = callPackage ../development/libraries/cdo { };

  cimg = callPackage  ../development/libraries/cimg { };

  scmccid = callPackage ../development/libraries/scmccid { };

  ccrtp = callPackage ../development/libraries/ccrtp { };

  cctz = callPackage ../development/libraries/cctz { };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  cegui = callPackage ../development/libraries/cegui {
    ogre = ogre1_10;
  };

  certbot = callPackage ../tools/admin/certbot { };

  caf = callPackage ../development/libraries/caf {};

  # CGAL 5 has API changes
  cgal_4 = callPackage ../development/libraries/CGAL/4.nix {};
  cgal_5 = callPackage ../development/libraries/CGAL {};
  cgal = cgal_4;

  cgui = callPackage ../development/libraries/cgui {};

  check = callPackage ../development/libraries/check {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  chipmunk = callPackage ../development/libraries/chipmunk {};

  chmlib = callPackage ../development/libraries/chmlib { };

  chromaprint = callPackage ../development/libraries/chromaprint { };

  cl = callPackage ../development/libraries/cl { };

  classads = callPackage ../development/libraries/classads { };

  clearsilver = callPackage ../development/libraries/clearsilver { };

  clfft = callPackage ../development/libraries/clfft { };

  clipp  = callPackage ../development/libraries/clipp { };

  clipper = callPackage ../development/libraries/clipper { };

  cln = callPackage ../development/libraries/cln { };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  clucene_core_1 = callPackage ../development/libraries/clucene-core {
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  clucene_core = clucene_core_1;

  clutter = callPackage ../development/libraries/clutter { };

  clutter-gst = callPackage ../development/libraries/clutter-gst {
  };

  clutter-gtk = callPackage ../development/libraries/clutter-gtk { };

  cminpack = callPackage ../development/libraries/cminpack { };

  cmocka = callPackage ../development/libraries/cmocka { };

  cmrt = callPackage ../development/libraries/cmrt { };

  cogl = callPackage ../development/libraries/cogl { };

  coin3d = callPackage ../development/libraries/coin3d { };

  soxt = callPackage ../development/libraries/soxt { };

  CoinMP = callPackage ../development/libraries/CoinMP { };

  cointop = callPackage ../applications/misc/cointop { };

  ctl = callPackage ../development/libraries/ctl { };

  ctpp2 = callPackage ../development/libraries/ctpp2 { };

  ctpl = callPackage ../development/libraries/ctpl { };

  cppdb = callPackage ../development/libraries/cppdb { };

  cpp-utilities = callPackage ../development/libraries/cpp-utilities { };

  cpp-hocon = callPackage ../development/libraries/cpp-hocon { };

  cpp-ipfs-api = callPackage ../development/libraries/cpp-ipfs-api { };

  cpp-netlib = callPackage ../development/libraries/cpp-netlib {};

  ubus = callPackage ../development/libraries/ubus { };

  uci = callPackage ../development/libraries/uci { };

  uri = callPackage ../development/libraries/uri { };

  cppcms = callPackage ../development/libraries/cppcms { };

  cppunit = callPackage ../development/libraries/cppunit { };

  cpputest = callPackage ../development/libraries/cpputest { };

  cracklib = callPackage ../development/libraries/cracklib { };

  cre2 = callPackage ../development/libraries/cre2 { };

  criterion = callPackage ../development/libraries/criterion { };

  croaring = callPackage ../development/libraries/croaring { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  cryptominisat = callPackage ../applications/science/logic/cryptominisat { };

  ctypes_sh = callPackage ../development/libraries/ctypes_sh { };

  curlcpp = callPackage ../development/libraries/curlcpp { };

  curlpp = callPackage ../development/libraries/curlpp { };

  cutee = callPackage ../development/libraries/cutee { };

  cutelyst = libsForQt5.callPackage ../development/libraries/cutelyst { };

  cxxtools = callPackage ../development/libraries/cxxtools { };

  cwiid = callPackage ../development/libraries/cwiid { };

  cxx-prettyprint = callPackage ../development/libraries/cxx-prettyprint { };

  cxxtest = callPackage ../development/libraries/cxxtest { };

  cypress = callPackage ../development/web/cypress { };

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

  dbxml = callPackage ../development/libraries/dbxml { };

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

  dhex = callPackage ../applications/editors/dhex { };

  dnnl = callPackage ../development/libraries/dnnl { };

  double-conversion = callPackage ../development/libraries/double-conversion { };

  dclib = callPackage ../development/libraries/dclib { };

  dillo = callPackage ../applications/networking/browsers/dillo {
    fltk = fltk13;
  };

  directfb = callPackage ../development/libraries/directfb { };

  discord-rpc = callPackage ../development/libraries/discord-rpc {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };

  dlib = callPackage ../development/libraries/dlib { };

  doctest = callPackage ../development/libraries/doctest { };

  docopt_cpp = callPackage ../development/libraries/docopt_cpp { };

  dotconf = callPackage ../development/libraries/dotconf { };

  # Multi-arch "drivers" which we want to build for i686.
  driversi686Linux = recurseIntoAttrs {
    inherit (pkgsi686Linux)
      mesa
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
      beignet
      glxinfo
      vdpauinfo;
  };

  dssi = callPackage ../development/libraries/dssi {};

  dxflib = callPackage ../development/libraries/dxflib {};

  easyloggingpp = callPackage ../development/libraries/easyloggingpp {};

  eccodes = callPackage ../development/libraries/eccodes {
    pythonPackages = python3Packages;
  };

  eclib = callPackage ../development/libraries/eclib {};

  editline = callPackage ../development/libraries/editline { };

  eigen = callPackage ../development/libraries/eigen {};

  eigen2 = callPackage ../development/libraries/eigen/2.0.nix {};

  vmmlib = callPackage ../development/libraries/vmmlib {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  };

  egl-wayland = callPackage ../development/libraries/egl-wayland {};

  elastix = callPackage ../development/libraries/science/biology/elastix { };

  enchant1 = callPackage ../development/libraries/enchant/1.x.nix { };

  enchant2 = callPackage ../development/libraries/enchant/2.x.nix { };
  enchant = enchant2;

  enet = callPackage ../development/libraries/enet { };

  epoxy = callPackage ../development/libraries/epoxy {};

  libesmtp = callPackage ../development/libraries/libesmtp { };

  exiv2 = callPackage ../development/libraries/exiv2 { };

  expat = callPackage ../development/libraries/expat { };

  eventlog = callPackage ../development/libraries/eventlog { };

  faac = callPackage ../development/libraries/faac { };

  faad2 = callPackage ../development/libraries/faad2 { };

  factor-lang = callPackage ../development/compilers/factor-lang {
    inherit (pkgs.gnome2) gtkglext;
  };

  far2l = callPackage ../applications/misc/far2l {
    stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
  };

  farbfeld = callPackage ../development/libraries/farbfeld { };

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
      gst-libav;
  };

  fcgi = callPackage ../development/libraries/fcgi { };

  ffcast = callPackage ../tools/X11/ffcast { };

  fflas-ffpack = callPackage ../development/libraries/fflas-ffpack {
    # We need to use blas instead of openblas on darwin,
    # see https://github.com/NixOS/nixpkgs/pull/45013.
    blas = if stdenv.isDarwin then blas else openblas;
  };

  forge = callPackage ../development/libraries/forge { };

  linbox = callPackage ../development/libraries/linbox {
    # We need to use blas instead of openblas on darwin, see
    # https://github.com/NixOS/nixpkgs/pull/45013 and
    # https://github.com/NixOS/nixpkgs/pull/45015.
    blas = if stdenv.isDarwin then blas else openblas;
  };

  ffmpeg_2_8 = callPackage ../development/libraries/ffmpeg/2.8.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_3_4 = callPackage ../development/libraries/ffmpeg/3.4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };
  ffmpeg_4 = callPackage ../development/libraries/ffmpeg/4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia VideoToolbox;
  };

  # Aliases
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
    libmfx = if stdenv.isDarwin then null else intel-media-sdk;
    libpulseaudio = if stdenv.isDarwin then null else libpulseaudio;
    samba = if stdenv.isDarwin then null else samba;
    vid-stab = if stdenv.isDarwin then null else vid-stab;
    x265 = if stdenv.isDarwin then null else x265;
    xavs = if stdenv.isDarwin then null else xavs;
    inherit (darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio AVFoundation MediaToolbox
      VideoDecodeAcceleration;
  };

  ffmpegthumbnailer = callPackage ../development/libraries/ffmpegthumbnailer { };

  ffmpeg-sixel = callPackage ../development/libraries/ffmpeg-sixel { };

  ffmpeg-normalize = python3Packages.callPackage ../applications/video/ffmpeg-normalize { };

  ffms = callPackage ../development/libraries/ffms { };

  fftw = callPackage ../development/libraries/fftw { };
  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwFloat = fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = fftw.override { precision = "long-double"; };

  filter-audio = callPackage ../development/libraries/filter-audio {};

  flann = callPackage ../development/libraries/flann { };

  flatcc = callPackage ../development/libraries/flatcc { };

  flint = callPackage ../development/libraries/flint { };

  flite = callPackage ../development/libraries/flite { };

  fltk13 = callPackage ../development/libraries/fltk {
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL GLUT;
  };
  fltk14 = callPackage ../development/libraries/fltk/1.4.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL GLUT;
  };
  fltk = res.fltk13;

  flyway = callPackage ../development/tools/flyway { };

  fmt = callPackage ../development/libraries/fmt/default.nix { };

  fplll = callPackage ../development/libraries/fplll {};
  fplll_20160331 = callPackage ../development/libraries/fplll/20160331.nix {};

  freeimage = callPackage ../development/libraries/freeimage { };

  freetts = callPackage ../development/libraries/freetts { };

  frog = res.languageMachines.frog;

  fstrcmp = callPackage ../development/libraries/fstrcmp { };

  fstrm = callPackage ../development/libraries/fstrm { };

  cfitsio = callPackage ../development/libraries/cfitsio { };

  fontconfig_210 = callPackage ../development/libraries/fontconfig/2.10.nix { };

  fontconfig = callPackage ../development/libraries/fontconfig { };

  fontconfig-penultimate = callPackage ../data/fonts/fontconfig-penultimate {};

  folly = callPackage ../development/libraries/folly { };

  folks = callPackage ../development/libraries/folks { };

  makeFontsConf = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-conf.nix {
      inherit fontconfig fontDirectories;
    };

  makeFontsCache = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    callPackage ../development/libraries/fontconfig/make-fonts-cache.nix {
      inherit fontconfig fontDirectories;
    };

  freealut = callPackage ../development/libraries/freealut { };

  freeglut = callPackage ../development/libraries/freeglut { };

  freenect = callPackage ../development/libraries/freenect {
    inherit (darwin.apple_sdk.frameworks) Cocoa GLUT;
  };

  freetype = callPackage ../development/libraries/freetype { };

  frei0r = callPackage ../development/libraries/frei0r { };

  fribidi = callPackage ../development/libraries/fribidi { };

  funambol = callPackage ../development/libraries/funambol { };

  gamin = callPackage ../development/libraries/gamin { };
  fam = gamin; # added 2018-04-25

  ganv = callPackage ../development/libraries/ganv { };

  gcab = callPackage ../development/libraries/gcab { };

  gcovr = with python3Packages; toPythonApplication gcovr;

  gcr = callPackage ../development/libraries/gcr { };

  gdl = callPackage ../development/libraries/gdl { };

  gdome2 = callPackage ../development/libraries/gdome2 { };

  gdbm = callPackage ../development/libraries/gdbm { };

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_6 = qt5.callPackage ../development/libraries/gecode { };
  gecode = gecode_6;

  gephi = callPackage ../applications/science/misc/gephi { };

  gegl = callPackage ../development/libraries/gegl {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  gegl_0_4 = callPackage ../development/libraries/gegl/4.0.nix {
    inherit (darwin.apple_sdk.frameworks) OpenCL;
  };

  gensio = callPackage ../development/libraries/gensio {};

  geoclue2 = callPackage ../development/libraries/geoclue {};

  geocode-glib = callPackage ../development/libraries/geocode-glib {};

  geoipWithDatabase = makeOverridable (callPackage ../development/libraries/geoip) {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  geoipjava = callPackage ../development/libraries/java/geoipjava { };

  geos = callPackage ../development/libraries/geos { };

  getdata = callPackage ../development/libraries/getdata { };

  getdns = callPackage ../development/libraries/getdns { };

  gettext = callPackage ../development/libraries/gettext { };

  gf2x = callPackage ../development/libraries/gf2x {};

  gd = callPackage ../development/libraries/gd {
    libtiff = null;
    libXpm = null;
  };

  gdal = callPackage ../development/libraries/gdal {
    pythonPackages = python3Packages;
  };

  gdal_1_11 = callPackage ../development/libraries/gdal/gdal-1_11.nix { };

  gdal_2 = callPackage ../development/libraries/gdal/2.4.0.nix { };

  gdcm = callPackage ../development/libraries/gdcm { };

  ggz_base_libs = callPackage ../development/libraries/ggz_base_libs {};

  giblib = callPackage ../development/libraries/giblib { };

  gio-sharp = callPackage ../development/libraries/gio-sharp { };

  givaro = callPackage ../development/libraries/givaro {};
  givaro_3 = callPackage ../development/libraries/givaro/3.nix {};
  givaro_3_7 = callPackage ../development/libraries/givaro/3.7.nix {};

  ghp-import = callPackage ../development/tools/ghp-import { };

  ghcid = haskellPackages.ghcid.bin;

  icon-lang = callPackage ../development/interpreters/icon-lang { };

  libgit2 = callPackage ../development/libraries/git2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  libgit2-glib = callPackage ../development/libraries/libgit2-glib { };

  glbinding = callPackage ../development/libraries/glbinding { };

  gle = callPackage ../development/libraries/gle { };

  glew = callPackage ../development/libraries/glew { };
  glew110 = callPackage ../development/libraries/glew/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  glfw = glfw3;
  glfw2 = callPackage ../development/libraries/glfw/2.x.nix { };
  glfw3 = callPackage ../development/libraries/glfw/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa Kernel;
  };

  glibc = callPackage ../development/libraries/glibc { };

  # Provided by libc on Operating Systems that use the Extensible Linker Format.
  elf-header =
    if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf"
    then null
    else elf-header-real;

  elf-header-real = callPackage ../development/libraries/elf-header { };

  glibc_memusage = callPackage ../development/libraries/glibc {
    withGd = true;
  };

  # Being redundant to avoid cycles on boot. TODO: find a better way
  glibcCross = callPackage ../development/libraries/glibc {
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
    else if name == "newlib" && stdenv.targetPlatform.isMsp430 then targetPackages.msp430NewlibCross or msp430NewlibCross
    else if name == "newlib" && stdenv.targetPlatform.isVc4 then targetPackages.vc4-newlib or vc4-newlib
    else if name == "newlib" then targetPackages.newlibCross or newlibCross
    else if name == "musl" then targetPackages.muslCross or muslCross
    else if name == "msvcrt" then targetPackages.windows.mingw_w64 or windows.mingw_w64
    else if stdenv.targetPlatform.useiOSPrebuilt then targetPackages.darwin.iosSdkPkgs.libraries or darwin.iosSdkPkgs.libraries
    else if name == "libSystem" then targetPackages.darwin.xcode
    else if name == "nblibc" then targetPackages.netbsdCross.libc
    else if name == "wasilibc" then targetPackages.wasilibc or wasilibc
    else if stdenv.targetPlatform.isGhcjs then null
    else throw "Unknown libc ${name}";

  libcCross = assert stdenv.targetPlatform != stdenv.buildPlatform; libcCrossChooser stdenv.targetPlatform.libc;

  threadsCross =
    if stdenv.targetPlatform.isMinGW && !(stdenv.targetPlatform.useLLVM or false)
    then targetPackages.windows.mcfgthreads or windows.mcfgthreads
    else null;

  wasilibc = callPackage ../development/libraries/wasilibc {
    stdenv = crossLibcStdenv;
  };

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

  gloox = callPackage ../development/libraries/gloox { };

  glpk = callPackage ../development/libraries/glpk { };

  glsurf = callPackage ../applications/science/math/glsurf {
    libpng = libpng12;
    giflib = giflib_4_1;
    ocamlPackages = ocaml-ng.ocamlPackages_4_01_0;
  };

  glui = callPackage ../development/libraries/glui {};

  gmime2 = callPackage ../development/libraries/gmime/2.nix { };
  gmime3 = callPackage ../development/libraries/gmime/3.nix { };
  gmime = gmime2;

  gmm = callPackage ../development/libraries/gmm { };

  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { }; # required by older GHC versions
  gmp5 = callPackage ../development/libraries/gmp/5.1.x.nix { };
  gmp6 = callPackage ../development/libraries/gmp/6.x.nix { };
  gmp = gmp6;
  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr { };

  mpfi = callPackage ../development/libraries/mpfi { };

  mpfshell = callPackage ../development/tools/mpfshell { };

  # A GMP fork
  mpir = callPackage ../development/libraries/mpir {};

  gns3Packages = dontRecurseIntoAttrs (callPackage ../applications/networking/gns3 { });
  gns3-gui = gns3Packages.guiStable;
  gns3-server = gns3Packages.serverStable;

  gobject-introspection = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
    inherit (darwin) cctools;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };
  goocanvas2 = callPackage ../development/libraries/goocanvas/2.x.nix { };
  goocanvasmm2 = callPackage ../development/libraries/goocanvasmm { };

  gflags = callPackage ../development/libraries/gflags { };

  gperftools = callPackage ../development/libraries/gperftools { };

  grab-site = callPackage ../tools/backup/grab-site { };

  grib-api = callPackage ../development/libraries/grib-api { };

  grilo = callPackage ../development/libraries/grilo { };

  grilo-plugins = callPackage ../development/libraries/grilo-plugins { };

  grpc = callPackage ../development/libraries/grpc { };

  gsettings-qt = libsForQt5.callPackage ../development/libraries/gsettings-qt { };

  gst_all_1 = recurseIntoAttrs(callPackage ../development/libraries/gstreamer {
    callPackage = newScope { libav = pkgs.ffmpeg_4; };
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  });

  gstreamer = callPackage ../development/libraries/gstreamer/legacy/gstreamer { };

  gst-plugins-base = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-base {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  gst-plugins-good = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-good {};

  gst-plugins-bad = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-bad {};

  gst-plugins-ugly = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-ugly {};

  gst-python = callPackage ../development/libraries/gstreamer/legacy/gst-python {};

  gstreamermm = callPackage ../development/libraries/gstreamer/legacy/gstreamermm { };

  gnonlin = callPackage ../development/libraries/gstreamer/legacy/gnonlin {};

  gusb = callPackage ../development/libraries/gusb { };

  qt-mobility = callPackage ../development/libraries/qt-mobility {};


  qtstyleplugin-kvantum-qt4 = callPackage ../development/libraries/qtstyleplugin-kvantum-qt4 { };

  gnet = callPackage ../development/libraries/gnet { };

  gnu-config = callPackage ../development/libraries/gnu-config { };

  gnu-efi = if stdenv.hostPlatform.isEfi
              then callPackage ../development/libraries/gnu-efi { }
            else null;

  gnutls = callPackage ../development/libraries/gnutls/default.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
    utillinux = utillinuxMinimal; # break the cyclic dependency
  };

  gnutls-kdh = callPackage ../development/libraries/gnutls-kdh/3.5.nix {
    gperf = gperf_3_0;
  };

  gpac = callPackage ../applications/video/gpac { };

  gpgme = callPackage ../development/libraries/gpgme { };

  pgpdump = callPackage ../tools/security/pgpdump { };

  pgpkeyserver-lite = callPackage ../servers/web-apps/pgpkeyserver-lite {};

  gpgstats = callPackage ../tools/security/gpgstats { };

  gpshell = callPackage ../development/tools/misc/gpshell { };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsl_1 = callPackage ../development/libraries/gsl/gsl-1_16.nix { };

  gsm = callPackage ../development/libraries/gsm {};

  gsoap = callPackage ../development/libraries/gsoap { };

  gsound = callPackage ../development/libraries/gsound { };

  gss = callPackage ../development/libraries/gss { };

  gtkimageview = callPackage ../development/libraries/gtkimageview { };

  gtkmathview = callPackage ../development/libraries/gtkmathview { };

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

  glib-networking = callPackage ../development/libraries/glib-networking {};

  glib-testing = callPackage ../development/libraries/glib-testing { };

  glirc = haskell.lib.justStaticExecutables haskellPackages.glirc;

  gom = callPackage ../development/libraries/gom { };

  ace = callPackage ../development/libraries/ace { };

  atk = callPackage ../development/libraries/atk { };

  atkmm = callPackage ../development/libraries/atkmm { };

  pixman = callPackage ../development/libraries/pixman { };

  cairo = callPackage ../development/libraries/cairo { };

  cairomm = callPackage ../development/libraries/cairomm { };

  pango = callPackage ../development/libraries/pango {
    harfbuzz = harfbuzz.override { withCoreText = stdenv.isDarwin; };
  };

  pangolin = callPackage ../development/libraries/pangolin {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  pangomm = callPackage ../development/libraries/pangomm {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  gdata-sharp = callPackage ../development/libraries/gdata-sharp { };

  gdk-pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gnome-sharp = callPackage ../development/libraries/gnome-sharp { };

  gnome-menus = callPackage ../development/libraries/gnome-menus { };

  elementary-cmake-modules = callPackage ../development/libraries/elementary-cmake-modules { };

  gtk2 = callPackage ../development/libraries/gtk/2.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gtk2-x11 = gtk2.override {
    cairo = cairo.override { x11Support = true; };
    pango = pango.override { cairo = cairo.override { x11Support = true; }; x11Support = true; };
    gdktarget = "x11";
  };

  gtk3 = callPackage ../development/libraries/gtk/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  # On darwin gtk uses cocoa by default instead of x11.
  gtk3-x11 = gtk3.override {
    cairo = cairo.override { x11Support = true; };
    pango = pango.override { cairo = cairo.override { x11Support = true; }; x11Support = true; };
    x11Support = true;
  };

  gtkmm2 = callPackage ../development/libraries/gtkmm/2.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.x.nix { };

  gtk_engines = callPackage ../development/libraries/gtk-engines { };

  gtk-engine-bluecurve = callPackage ../development/libraries/gtk-engine-bluecurve { };

  gtk-engine-murrine = callPackage ../development/libraries/gtk-engine-murrine { };

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

  gtk-sharp-beans = callPackage ../development/libraries/gtk-sharp-beans { };

  gtk-mac-integration = callPackage ../development/libraries/gtk-mac-integration {
    gtk = gtk3;
  };

  gtk-mac-integration-gtk2 = gtk-mac-integration.override {
    gtk = gtk2;
  };

  gtk-mac-integration-gtk3 = gtk-mac-integration;

  gtk-mac-bundler = callPackage ../development/tools/gtk-mac-bundler {};

  gtksourceview = gtksourceview3;

  gtksourceview3 = callPackage ../development/libraries/gtksourceview/3.x.nix { };

  gtksourceview4 = callPackage ../development/libraries/gtksourceview/4.x.nix { };

  gtksourceviewmm = callPackage ../development/libraries/gtksourceviewmm { };

  gtksourceviewmm4 = callPackage ../development/libraries/gtksourceviewmm/4.x.nix { };

  gtkspell2 = callPackage ../development/libraries/gtkspell { enchant = enchant1; };

  gtkspell3 = callPackage ../development/libraries/gtkspell/3.nix { };

  gtkspellmm = callPackage ../development/libraries/gtkspellmm { };

  gtk-layer-shell = callPackage ../development/libraries/gtk-layer-shell { };

  gts = callPackage ../development/libraries/gts { };

  gumbo = callPackage ../development/libraries/gumbo { };

  gvfs = callPackage ../development/libraries/gvfs { };

  gwenhywfar = callPackage ../development/libraries/aqbanking/gwenhywfar.nix { };

  hamlib = callPackage ../development/libraries/hamlib { };

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

  hawknl = callPackage ../development/libraries/hawknl { };

  haxor-news = callPackage ../applications/misc/haxor-news { };

  herqq = libsForQt5.callPackage ../development/libraries/herqq { };

  heyefi = haskellPackages.heyefi;

  hidapi = callPackage ../development/libraries/hidapi {
    libusb = libusb1;
  };

  hiredis = callPackage ../development/libraries/hiredis { };

  hiredis-vip = callPackage ../development/libraries/hiredis-vip { };

  hivex = callPackage ../development/libraries/hivex { };

  hound = callPackage ../development/tools/misc/hound { };

  hpx = callPackage ../development/libraries/hpx { };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hsqldb = callPackage ../development/libraries/java/hsqldb { };

  hstr = callPackage ../applications/misc/hstr { };

  htmlcxx = callPackage ../development/libraries/htmlcxx { };

  http-parser = callPackage ../development/libraries/http-parser { };

  hunspell = callPackage ../development/libraries/hunspell { };

  hunspellDicts = recurseIntoAttrs (callPackages ../development/libraries/hunspell/dictionaries.nix {});

  hunspellWithDicts = dicts: callPackage ../development/libraries/hunspell/wrapper.nix { inherit dicts; };

  hwloc = callPackage ../development/libraries/hwloc {};

  inherit (callPackage ../development/tools/misc/hydra { })
    hydra-migration hydra-unstable hydra-flakes;

  hydra-cli = callPackage ../development/tools/misc/hydra-cli { };

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  hyena = callPackage ../development/libraries/hyena { };

  hyperscan = callPackage ../development/libraries/hyperscan { };

  icu58 = callPackage (import ../development/libraries/icu/58.nix fetchurl) ({
    nativeBuildRoot = buildPackages.icu58.override { buildRootOnly = true; };
  } //
    (stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
      stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu59 = callPackage ../development/libraries/icu/59.nix ({
    nativeBuildRoot = buildPackages.icu59.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
      stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu60 = callPackage ../development/libraries/icu/60.nix ({
    nativeBuildRoot = buildPackages.icu60.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
      stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu63 = callPackage ../development/libraries/icu/63.nix ({
    nativeBuildRoot = buildPackages.icu63.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
      stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
    }));
  icu64 = callPackage ../development/libraries/icu/64.nix ({
    nativeBuildRoot = buildPackages.icu64.override { buildRootOnly = true; };
  } // (stdenv.lib.optionalAttrs (stdenv.hostPlatform.isi686 && stdenv.cc.isGNU) {
      stdenv = gcc6Stdenv; # with gcc-7: undefined reference to `__divmoddi4'
    }));

  icu = icu64;

  id3lib = callPackage ../development/libraries/id3lib { };

  ilbc = callPackage ../development/libraries/ilbc { };

  ilixi = callPackage ../development/libraries/ilixi { };

  ilmbase = callPackage ../development/libraries/ilmbase { };

  imlib = callPackage ../development/libraries/imlib {
    libpng = libpng12;
  };

  imv = callPackage ../applications/graphics/imv { };

  iml = callPackage ../development/libraries/iml { };

  imlib2 = callPackage ../development/libraries/imlib2 { };
  imlib2-nox = imlib2.override {
    x11Support = false;
  };

  imlibsetroot = callPackage ../applications/graphics/imlibsetroot { libXinerama = xorg.libXinerama; } ;

  ineffassign = callPackage ../development/tools/ineffassign { };

  ijs = callPackage ../development/libraries/ijs { };

  itktcl  = callPackage ../development/libraries/itktcl { };
  incrtcl = callPackage ../development/libraries/incrtcl { };

  indicator-application-gtk2 = callPackage ../development/libraries/indicator-application/gtk2.nix { };
  indicator-application-gtk3 = callPackage ../development/libraries/indicator-application/gtk3.nix { };

  indilib = callPackage ../development/libraries/indilib { };

  iniparser = callPackage ../development/libraries/iniparser { };

  intel-gmmlib = callPackage ../development/libraries/intel-gmmlib { };

  intel-media-driver = callPackage ../development/libraries/intel-media-driver { };

  intltool = callPackage ../development/tools/misc/intltool { };

  ios-cross-compile = callPackage ../development/compilers/ios-cross-compile/9.2.nix {};

  ip2location-c = callPackage ../development/libraries/ip2location-c { };

  irrlicht = if !stdenv.isDarwin then
    callPackage ../development/libraries/irrlicht { }
  else callPackage ../development/libraries/irrlicht/mac.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL IOKit;
  };

  isocodes = callPackage ../development/libraries/iso-codes { };

  ispc = callPackage ../development/compilers/ispc {
    llvmPackages = llvmPackages_6;
    stdenv = llvmPackages_6.stdenv;
  };

  isso = callPackage ../servers/isso { };

  itk4 = callPackage ../development/libraries/itk/4.x.nix { stdenv = gcc8Stdenv; };

  itk = callPackage ../development/libraries/itk {
    stdenv = gcc8Stdenv;
  };

  jasper = callPackage ../development/libraries/jasper { };

  jama = callPackage ../development/libraries/jama { };

  jansson = callPackage ../development/libraries/jansson { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jcal = callPackage ../development/libraries/jcal { };

  jbigkit = callPackage ../development/libraries/jbigkit { };

  jemalloc = callPackage ../development/libraries/jemalloc { };

  jemalloc450 = callPackage ../development/libraries/jemalloc/jemalloc450.nix { };

  jose = callPackage ../development/libraries/jose { };

  jshon = callPackage ../development/tools/parsing/jshon { };

  json2hcl = callPackage ../development/tools/json2hcl { };

  json-glib = callPackage ../development/libraries/json-glib { };

  json_c = callPackage ../development/libraries/json-c { };

  jsoncpp = callPackage ../development/libraries/jsoncpp { };

  jsonnet = callPackage ../development/compilers/jsonnet { };

  go-jsonnet = callPackage ../development/compilers/go-jsonnet { };

  jsonrpc-glib = callPackage ../development/libraries/jsonrpc-glib { };

  jxrlib = callPackage ../development/libraries/jxrlib { };

  libjson = callPackage ../development/libraries/libjson { };

  libb64 = callPackage ../development/libraries/libb64 { };

  judy = callPackage ../development/libraries/judy { };

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

  kf5gpgmepp = libsForQt5.callPackage ../development/libraries/kf5gpgmepp { };

  kinetic-cpp-client = callPackage ../development/libraries/kinetic-cpp-client {
    openssl = openssl_1_0_2;
  };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix {
    inherit (buildPackages.darwin) bootstrap_cmds;
  };
  krb5Full = krb5;
  libkrb5 = krb5.override { type = "lib"; };
  kerberos = libkrb5; # TODO: move to aliases.nix

  l-smash = callPackage ../development/libraries/l-smash {
    stdenv = gccStdenv;
  };

  languageMachines = recurseIntoAttrs (import ../development/libraries/languagemachines/packages.nix {
    inherit pkgs;
  });

  lasem = callPackage ../development/libraries/lasem { };

  lasso = callPackage ../development/libraries/lasso { };

  LASzip = callPackage ../development/libraries/LASzip { };

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  ldacbt = callPackage ../development/libraries/ldacbt { };

  ldb = callPackage ../development/libraries/ldb { };

  lensfun = callPackage ../development/libraries/lensfun {};

  lesstif = callPackage ../development/libraries/lesstif { };

  leveldb = callPackage ../development/libraries/leveldb { };

  lmdb = callPackage ../development/libraries/lmdb { };

  lmdbxx = callPackage ../development/libraries/lmdbxx { };

  levmar = callPackage ../development/libraries/levmar { };

  leptonica = callPackage ../development/libraries/leptonica { };

  lib3ds = callPackage ../development/libraries/lib3ds { };

  lib3mf = callPackage ../development/libraries/lib3mf { };

  libaacs = callPackage ../development/libraries/libaacs { };

  libaal = callPackage ../development/libraries/libaal { };

  libabigail = callPackage ../development/libraries/libabigail { };

  libaccounts-glib = callPackage ../development/libraries/libaccounts-glib { };

  libacr38u = callPackage ../tools/security/libacr38u { };

  libagar = callPackage ../development/libraries/libagar { };
  libagar_test = callPackage ../development/libraries/libagar/libagar_test.nix { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) CoreAudio CoreServices AudioUnit;
  };

  libaosd = callPackage ../development/libraries/libaosd { };

  libabw = callPackage ../development/libraries/libabw { };

  libamqpcpp = callPackage ../development/libraries/libamqpcpp { };

  libantlr3c = callPackage ../development/libraries/libantlr3c {};

  libaom = callPackage ../development/libraries/libaom { };

  libappindicator-gtk2 = libappindicator.override { gtkVersion = "2"; };
  libappindicator-gtk3 = libappindicator.override { gtkVersion = "3"; };
  libappindicator = callPackage ../development/libraries/libappindicator { };

  libarchive = callPackage ../development/libraries/libarchive { };

  libasr = callPackage ../development/libraries/libasr { };

  libass = callPackage ../development/libraries/libass { };

  libast = callPackage ../development/libraries/libast { };

  libassuan = callPackage ../development/libraries/libassuan { };

  libasyncns = callPackage ../development/libraries/libasyncns { };

  libatomic_ops = callPackage ../development/libraries/libatomic_ops {};

  libaudclient = callPackage ../development/libraries/libaudclient { };

  libav = libav_11; # branch 11 is API-compatible with branch 10
  libav_all = callPackage ../development/libraries/libav { };
  inherit (libav_all) libav_0_8 libav_11 libav_12;

  libavc1394 = callPackage ../development/libraries/libavc1394 { };

  libb2 = callPackage ../development/libraries/libb2 { };

  libbap = callPackage ../development/libraries/libbap {
    inherit (ocaml-ng.ocamlPackages_4_06) bap ocaml findlib ctypes;
  };

  libbass = (callPackage ../development/libraries/audio/libbass { }).bass;
  libbass_fx = (callPackage ../development/libraries/audio/libbass { }).bass_fx;

  libbluedevil = callPackage ../development/libraries/libbluedevil { };

  libbdplus = callPackage ../development/libraries/libbdplus { };

  libblockdev = callPackage ../development/libraries/libblockdev { };

  libblocksruntime = callPackage ../development/libraries/libblocksruntime { };

  libbluray = callPackage ../development/libraries/libbluray { };

  libbs2b = callPackage ../development/libraries/audio/libbs2b { };

  libbson = callPackage ../development/libraries/libbson { };

  libburn = callPackage ../development/libraries/libburn { };

  libbytesize = callPackage ../development/libraries/libbytesize { };

  libcaca = callPackage ../development/libraries/libcaca {
    inherit (xorg) libX11 libXext;
  };

  libcacard = callPackage ../development/libraries/libcacard { };

  libcanberra = callPackage ../development/libraries/libcanberra {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };
  libcanberra-gtk2 = pkgs.libcanberra.override {
    gtk = gtk2-x11;
  };
  libcanberra-gtk3 = pkgs.libcanberra.override {
    gtk = gtk3-x11;
  };

  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then pkgs.libcanberra
    else pkgs.libcanberra-gtk2;

  libcbor = callPackage ../development/libraries/libcbor { };

  libcec = callPackage ../development/libraries/libcec {
    libraspberrypi = null;
  };

  libcec_platform = callPackage ../development/libraries/libcec/platform.nix { };

  libcef = callPackage ../development/libraries/libcef { inherit (gnome2) GConf; };

  libcello = callPackage ../development/libraries/libcello {};

  libcerf = callPackage ../development/libraries/libcerf {};

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio {
    inherit (darwin.apple_sdk.frameworks) Carbon IOKit;
  };

  libcdio-paranoia = callPackage ../development/libraries/libcdio-paranoia {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration IOKit;
  };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain = callPackage ../development/libraries/libchamplain { };

  libchardet = callPackage ../development/libraries/libchardet { };

  libchewing = callPackage ../development/libraries/libchewing { };

  libchipcard = callPackage ../development/libraries/aqbanking/libchipcard.nix { };

  libcrafter = callPackage ../development/libraries/libcrafter { };

  libcrossguid = callPackage ../development/libraries/libcrossguid { };

  libuchardet = callPackage ../development/libraries/libuchardet { };

  libchop = callPackage ../development/libraries/libchop { };

  libcint = callPackage ../development/libraries/libcint { };

  libclc = callPackage ../development/libraries/libclc { };

  libcli = callPackage ../development/libraries/libcli { };

  libclthreads = callPackage ../development/libraries/libclthreads  { };

  libclxclient = callPackage ../development/libraries/libclxclient  { };

  libco-canonical = callPackage ../development/libraries/libco-canonical { };

  libconfuse = callPackage ../development/libraries/libconfuse { };

  libcangjie = callPackage ../development/libraries/libcangjie { };

  libcollectdclient = callPackage ../development/libraries/libcollectdclient { };

  libcredis = callPackage ../development/libraries/libcredis { };

  libctb = callPackage ../development/libraries/libctb { };

  libctemplate = callPackage ../development/libraries/libctemplate { };

  libcouchbase = callPackage ../development/libraries/libcouchbase { };

  libcue = callPackage ../development/libraries/libcue { };

  libcutl = callPackage ../development/libraries/libcutl { };

  libdaemon = callPackage ../development/libraries/libdaemon { };

  libdap = callPackage ../development/libraries/libdap { };

  libdazzle = callPackage ../development/libraries/libdazzle { };

  libdbi = callPackage ../development/libraries/libdbi { };

  libdbiDriversBase = libdbiDrivers.override {
    libmysqlclient = null;
    sqlite = null;
  };

  libdbiDrivers = callPackage ../development/libraries/libdbi-drivers { };

  libunity = callPackage ../development/libraries/libunity { };

  libdbusmenu = callPackage ../development/libraries/libdbusmenu { };
  libdbusmenu-gtk2 = libdbusmenu.override { gtkVersion = "2"; };
  libdbusmenu-gtk3 = libdbusmenu.override { gtkVersion = "3"; };

  libdbusmenu_qt = callPackage ../development/libraries/libdbusmenu-qt { };

  libdc1394 = callPackage ../development/libraries/libdc1394 {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  libde265 = callPackage ../development/libraries/libde265 {};

  libdeflate = callPackage ../development/libraries/libdeflate { };

  libdevil = callPackage ../development/libraries/libdevil {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  libdevil-nox = libdevil.override {
    libX11 = null;
    libGL = null;
  };

  libdigidoc = callPackage ../development/libraries/libdigidoc { };

  libdigidocpp = callPackage ../development/libraries/libdigidocpp { };

  libdiscid = callPackage ../development/libraries/libdiscid { };

  libdivecomputer = callPackage ../development/libraries/libdivecomputer { };

  libdivsufsort = callPackage ../development/libraries/libdivsufsort { };

  libdmtx = callPackage ../development/libraries/libdmtx { };

  libdnet = callPackage ../development/libraries/libdnet { };

  libdrm = callPackage ../development/libraries/libdrm { };

  libdv = callPackage ../development/libraries/libdv { };

  libdvbpsi = callPackage ../development/libraries/libdvbpsi { };

  libdwg = callPackage ../development/libraries/libdwg { };

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

  libeatmydata = callPackage ../development/libraries/libeatmydata { };

  libeb = callPackage ../development/libraries/libeb { };

  libebml = callPackage ../development/libraries/libebml { };

  libebur128 = callPackage ../development/libraries/libebur128 { };

  libedit = callPackage ../development/libraries/libedit { };

  libelf = if stdenv.isFreeBSD
  then callPackage ../development/libraries/libelf-freebsd { }
  else callPackage ../development/libraries/libelf { };

  libelfin = callPackage ../development/libraries/libelfin { };

  libetpan = callPackage ../development/libraries/libetpan { };

  libexecinfo = callPackage ../development/libraries/libexecinfo { };

  libfaketime = callPackage ../development/libraries/libfaketime { };

  libfakekey = callPackage ../development/libraries/libfakekey { };

  libfido2 = callPackage ../development/libraries/libfido2 {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libfilezilla = callPackage ../development/libraries/libfilezilla { };

  libfishsound = callPackage ../development/libraries/libfishsound { };

  libfm = callPackage ../development/libraries/libfm { };
  libfm-extra = libfm.override {
    extraOnly = true;
  };

  libfprint = callPackage ../development/libraries/libfprint { };
  libfprint-thinkpad = libfprint.override {
    thinkpad = true;
  };

  libfpx = callPackage ../development/libraries/libfpx { };

  libgadu = callPackage ../development/libraries/libgadu { };

  libgda = callPackage ../development/libraries/libgda { };

  libgdamm = callPackage ../development/libraries/libgdamm { };

  libgdata = callPackage ../development/libraries/libgdata { };

  libgee = callPackage ../development/libraries/libgee { };

  libgepub = callPackage ../development/libraries/libgepub { };

  libgig = callPackage ../development/libraries/libgig { };

  libgnome-keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome-keyring3 = gnome3.libgnome-keyring;

  libgnomekbd = callPackage ../development/libraries/libgnomekbd { };

  libglvnd = callPackage ../development/libraries/libglvnd { };

  libgnurl = callPackage ../development/libraries/libgnurl { };

  libgringotts = callPackage ../development/libraries/libgringotts { };

  libgroove = callPackage ../development/libraries/libgroove { };

  libgrss = callPackage ../development/libraries/libgrss { };

  libgweather = callPackage ../development/libraries/libgweather { };

  libgxps = callPackage ../development/libraries/libgxps { };

  libiio = callPackage ../development/libraries/libiio { };

  libinjection = callPackage ../development/libraries/libinjection { };

  libnats-c = callPackage ../development/libraries/libnats-c {
    openssl = openssl_1_0_2;
  };

  liburing = callPackage ../development/libraries/liburing { };

  librseq = callPackage ../development/libraries/librseq { };

  libseccomp = callPackage ../development/libraries/libseccomp { };

  libsecret = callPackage ../development/libraries/libsecret { };

  libserialport = callPackage ../development/libraries/libserialport { };

  libsignal-protocol-c = callPackage ../development/libraries/libsignal-protocol-c { };

  libsignon-glib = callPackage ../development/libraries/libsignon-glib { };

  libsoundio = callPackage ../development/libraries/libsoundio {
    inherit (darwin.apple_sdk.frameworks) AudioUnit;
  };

  libsystemtap = callPackage ../development/libraries/libsystemtap { };

  libgtop = callPackage ../development/libraries/libgtop {};

  libLAS = callPackage ../development/libraries/libLAS { };

  liblaxjson = callPackage ../development/libraries/liblaxjson { };

  liblo = callPackage ../development/libraries/liblo { };

  liblscp = callPackage ../development/libraries/liblscp { };

  libe-book = callPackage ../development/libraries/libe-book {};

  libechonest = callPackage ../development/libraries/libechonest { };

  libev = callPackage ../development/libraries/libev { };

  libevent = callPackage ../development/libraries/libevent { };

  libewf = callPackage ../development/libraries/libewf { };

  libexif = callPackage ../development/libraries/libexif { };

  libexosip = callPackage ../development/libraries/exosip {};

  libextractor = callPackage ../development/libraries/libextractor {
    libmpeg2 = mpeg2dec;
  };

  libexttextcat = callPackage ../development/libraries/libexttextcat {};

  libf2c = callPackage ../development/libraries/libf2c {};

  libfive = callPackage ../development/libraries/libfive { };

  libfixposix = callPackage ../development/libraries/libfixposix {};

  libffcall = callPackage ../development/libraries/libffcall { };

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

  libgksu = callPackage ../development/libraries/libgksu { };

  libgpgerror = callPackage ../development/libraries/libgpg-error { };

  # https://github.com/gpg/libgpg-error/blob/70058cd9f944d620764e57c838209afae8a58c78/README#L118-L140
  libgpgerror-gen-posix-lock-obj = libgpgerror.override {
    genPosixLockObjOnly = true;
  };

  libgphoto2 = callPackage ../development/libraries/libgphoto2 { };

  libgpiod = callPackage ../development/libraries/libgpiod { };

  libgpod = callPackage ../development/libraries/libgpod { };

  libgssglue = callPackage ../development/libraries/libgssglue { };

  libgudev = callPackage ../development/libraries/libgudev { };

  libguestfs-appliance = callPackage ../development/libraries/libguestfs/appliance.nix {};
  libguestfs = callPackage ../development/libraries/libguestfs { };
  libguestfs-with-appliance = libguestfs.override { appliance = libguestfs-appliance; };


  libhangul = callPackage ../development/libraries/libhangul { };

  libharu = callPackage ../development/libraries/libharu { };

  libhdhomerun = callPackage ../development/libraries/libhdhomerun { };

  libheif = callPackage ../development/libraries/libheif {};

  libhttpseverywhere = callPackage ../development/libraries/libhttpseverywhere { };

  libHX = callPackage ../development/libraries/libHX { };

  libibmad = callPackage ../development/libraries/libibmad { };

  libibumad = callPackage ../development/libraries/libibumad { };

  libical = callPackage ../development/libraries/libical { };

  libicns = callPackage ../development/libraries/libicns { };

  libieee1284 = callPackage ../development/libraries/libieee1284 { };

  libimobiledevice = callPackage ../development/libraries/libimobiledevice { };

  libindicator-gtk2 = libindicator.override { gtkVersion = "2"; };
  libindicator-gtk3 = libindicator.override { gtkVersion = "3"; };
  libindicator = callPackage ../development/libraries/libindicator { };

  libinotify-kqueue = callPackage ../development/libraries/libinotify-kqueue { };

  libiodbc = callPackage ../development/libraries/libiodbc {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  libirecovery = callPackage ../development/libraries/libirecovery { };

  libivykis = callPackage ../development/libraries/libivykis { };

  liblastfmSF = callPackage ../development/libraries/liblastfmSF { };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  liblcf = callPackage ../development/libraries/liblcf { };

  liblqr1 = callPackage ../development/libraries/liblqr-1 { };

  liblockfile = callPackage ../development/libraries/liblockfile { };

  liblogging = callPackage ../development/libraries/liblogging { };

  liblognorm = callPackage ../development/libraries/liblognorm { };

  libltc = callPackage ../development/libraries/libltc { };

  libmaxminddb = callPackage ../development/libraries/libmaxminddb { };

  libmcrypt = callPackage ../development/libraries/libmcrypt {};

  libmediaart = callPackage ../development/libraries/libmediaart { };

  libmediainfo = callPackage ../development/libraries/libmediainfo { };

  libmhash = callPackage ../development/libraries/libmhash {};

  libmodbus = callPackage ../development/libraries/libmodbus {};

  libmtp = callPackage ../development/libraries/libmtp { };

  libmypaint = callPackage ../development/libraries/libmypaint { };

  libmysofa = callPackage ../development/libraries/audio/libmysofa { };

  libmysqlconnectorcpp = callPackage ../development/libraries/libmysqlconnectorcpp { };

  libnatpmp = callPackage ../development/libraries/libnatpmp { };

  libnatspec = callPackage ../development/libraries/libnatspec { };

  libndp = callPackage ../development/libraries/libndp { };

  libnfc = callPackage ../development/libraries/libnfc { };

  libnfs = callPackage ../development/libraries/libnfs { };

  libnice = callPackage ../development/libraries/libnice { };

  libnsl = callPackage ../development/libraries/libnsl { };

  liboping = callPackage ../development/libraries/liboping { };

  libplist = callPackage ../development/libraries/libplist { };

  libre = callPackage ../development/libraries/libre {};
  librem = callPackage ../development/libraries/librem {};

  librelp = callPackage ../development/libraries/librelp { };

  librepo = callPackage ../tools/package-management/librepo {
    python = python3;
  };

  libresample = callPackage ../development/libraries/libresample {};

  librevenge = callPackage ../development/libraries/librevenge {};

  librevisa = callPackage ../development/libraries/librevisa { };

  librime = callPackage ../development/libraries/librime {};

  libsamplerate = callPackage ../development/libraries/libsamplerate {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon CoreServices;
  };

  libsieve = callPackage ../development/libraries/libsieve { };

  libsixel = callPackage ../development/libraries/libsixel { };

  libsolv = callPackage ../development/libraries/libsolv { };

  libspectre = callPackage ../development/libraries/libspectre { };

  libgsf = callPackage ../development/libraries/libgsf { };

  # GNU libc provides libiconv so systems with glibc don't need to build
  # libiconv separately. Additionally, Apple forked/repackaged libiconv so we
  # use that instead of the vanilla version on that OS.
  #
  # We also provide `libiconvReal`, which will always be a standalone libiconv,
  # just in case you want it regardless of platform.
  libiconv =
    if lib.elem stdenv.hostPlatform.libc ["glibc" "musl" "wasilibc"]
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

  libiconvReal = callPackage ../development/libraries/libiconv { };

  # On non-GNU systems we need GNU Gettext for libintl.
  libintl = if stdenv.hostPlatform.libc != "glibc" then gettext else null;

  libid3tag = callPackage ../development/libraries/libid3tag {
    gperf = gperf_3_0;
  };

  libidn = callPackage ../development/libraries/libidn { };

  libidn2 = callPackage ../development/libraries/libidn2 { };

  idnkit = callPackage ../development/libraries/idnkit { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libimagequant = callPackage ../development/libraries/libimagequant {};

  libinfinity = callPackage ../development/libraries/libinfinity { };

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  libinput-gestures = callPackage ../tools/inputmethods/libinput-gestures {};

  libinstpatch = callPackage ../development/libraries/audio/libinstpatch { };

  libisofs = callPackage ../development/libraries/libisofs { };

  libisoburn = callPackage ../development/libraries/libisoburn { };

  libipt = callPackage ../development/libraries/libipt { };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjpeg_original = callPackage ../development/libraries/libjpeg { };
  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };
  libjpeg_drop = callPackage ../development/libraries/libjpeg-drop { };
  libjpeg = libjpeg_turbo;

  libjreen = callPackage ../development/libraries/libjreen { };

  libjson-rpc-cpp = callPackage ../development/libraries/libjson-rpc-cpp { };

  libkate = callPackage ../development/libraries/libkate { };

  libkml = callPackage ../development/libraries/libkml { };

  libksba = callPackage ../development/libraries/libksba { };

  libksi = callPackage ../development/libraries/libksi { };

  liblinear = callPackage ../development/libraries/liblinear { };

  libmad = callPackage ../development/libraries/libmad { };

  malcontent = callPackage ../development/libraries/malcontent { };

  libmanette = callPackage ../development/libraries/libmanette { };

  libmatchbox = callPackage ../development/libraries/libmatchbox { };

  libmatheval = callPackage ../development/libraries/libmatheval {
    guile = guile_2_0;
  };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmatroska = callPackage ../development/libraries/libmatroska { };

  libmd = callPackage ../development/libraries/libmd { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  libmilter = callPackage ../development/libraries/libmilter { };

  libminc = callPackage ../development/libraries/libminc {
    hdf5 = hdf5_1_8;
  };

  libmirage = callPackage ../misc/emulators/cdemu/libmirage.nix { };

  libmkv = callPackage ../development/libraries/libmkv { };

  libmms = callPackage ../development/libraries/libmms { };

  libmowgli = callPackage ../development/libraries/libmowgli { };

  libmng = callPackage ../development/libraries/libmng { };

  libmnl = callPackage ../development/libraries/libmnl { };

  libmodplug = callPackage ../development/libraries/libmodplug {};

  libmodule = callPackage ../development/libraries/libmodule { };

  libmpcdec = callPackage ../development/libraries/libmpcdec { };

  libmp3splt = callPackage ../development/libraries/libmp3splt { };

  libmrss = callPackage ../development/libraries/libmrss { };

  libmspack = callPackage ../development/libraries/libmspack { };

  libmusicbrainz3 = callPackage ../development/libraries/libmusicbrainz { };

  libmusicbrainz5 = callPackage ../development/libraries/libmusicbrainz/5.x.nix { };

  libmusicbrainz = libmusicbrainz3;

  libmwaw = callPackage ../development/libraries/libmwaw { };

  libmx = callPackage ../development/libraries/libmx { };

  libndctl = callPackage ../development/libraries/libndctl { };

  libnet = callPackage ../development/libraries/libnet { };

  libnetfilter_acct = callPackage ../development/libraries/libnetfilter_acct { };

  libnetfilter_conntrack = callPackage ../development/libraries/libnetfilter_conntrack { };

  libnetfilter_cthelper = callPackage ../development/libraries/libnetfilter_cthelper { };

  libnetfilter_cttimeout = callPackage ../development/libraries/libnetfilter_cttimeout { };

  libnetfilter_log = callPackage ../development/libraries/libnetfilter_log { };

  libnetfilter_queue = callPackage ../development/libraries/libnetfilter_queue { };

  libnfnetlink = callPackage ../development/libraries/libnfnetlink { };

  libnftnl = callPackage ../development/libraries/libnftnl { };

  libnih = callPackage ../development/libraries/libnih { };

  libnova = callPackage ../development/libraries/libnova { };

  libnxml = callPackage ../development/libraries/libnxml { };

  libodfgen = callPackage ../development/libraries/libodfgen { };

  libofa = callPackage ../development/libraries/libofa { };

  libofx = callPackage ../development/libraries/libofx { };

  libogg = callPackage ../development/libraries/libogg { };

  liboggz = callPackage ../development/libraries/liboggz { };

  liboil = callPackage ../development/libraries/liboil { };

  libomxil-bellagio = callPackage ../development/libraries/libomxil-bellagio { };

  liboop = callPackage ../development/libraries/liboop { };

  libopenaptx = callPackage ../development/libraries/libopenaptx { };

  libopus = callPackage ../development/libraries/libopus { };

  libopusenc = callPackage ../development/libraries/libopusenc { };

  libosinfo = callPackage ../development/libraries/libosinfo {
    inherit (gnome3) libsoup;
  };

  libosip = callPackage ../development/libraries/osip {};

  libosmium = callPackage ../development/libraries/libosmium { };

  libosmocore = callPackage ../applications/misc/libosmocore { };

  libosmpbf = callPackage ../development/libraries/libosmpbf {};

  libotr = callPackage ../development/libraries/libotr { };

  libow = callPackage ../development/libraries/libow { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpar2 = callPackage ../development/libraries/libpar2 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpeas = callPackage ../development/libraries/libpeas { };

  libpipeline = callPackage ../development/libraries/libpipeline { };

  libpgf = callPackage ../development/libraries/libpgf { };

  libphonenumber = callPackage ../development/libraries/libphonenumber { };

  libplacebo = callPackage ../development/libraries/libplacebo { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = libpng.override { apngSupport = true; };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  libpaper = callPackage ../development/libraries/libpaper { };

  libpfm = callPackage ../development/libraries/libpfm { };

  libpqxx = callPackage ../development/libraries/libpqxx { };

  libproxy = callPackage ../development/libraries/libproxy {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration CoreFoundation JavaScriptCore;
  };

  libpseudo = callPackage ../development/libraries/libpseudo { };

  libpsl = callPackage ../development/libraries/libpsl { };

  libpst = callPackage ../development/libraries/libpst { };

  libpwquality = callPackage ../development/libraries/libpwquality { };

  libqalculate = callPackage ../development/libraries/libqalculate { };

  libroxml = callPackage ../development/libraries/libroxml { };

  librsvg = callPackage ../development/libraries/librsvg { };

  librsync = callPackage ../development/libraries/librsync { };

  librsync_0_9 = callPackage ../development/libraries/librsync/0.9.nix { };

  libs3 = callPackage ../development/libraries/libs3 { };

  libsearpc = callPackage ../development/libraries/libsearpc { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsigsegv = callPackage ../development/libraries/libsigsegv { };

  libslirp = callPackage ../development/libraries/libslirp { };

  libsndfile = callPackage ../development/libraries/libsndfile {
    inherit (darwin.apple_sdk.frameworks) Carbon AudioToolbox;
  };

  libsnark = callPackage ../development/libraries/libsnark { };

  libsodium = callPackage ../development/libraries/libsodium { };

  libsoup = callPackage ../development/libraries/libsoup { };

  libspectrum = callPackage ../development/libraries/libspectrum { };

  libspiro = callPackage ../development/libraries/libspiro {};

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

  libstemmer = callPackage ../development/libraries/libstemmer { };

  libstroke = callPackage ../development/libraries/libstroke { };

  libstrophe = callPackage ../development/libraries/libstrophe { };

  libspatialindex = callPackage ../development/libraries/libspatialindex { };

  libspatialite = callPackage ../development/libraries/libspatialite { };

  libstatgrab = callPackage ../development/libraries/libstatgrab {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libsvm = callPackage ../development/libraries/libsvm { };

  libtar = callPackage ../development/libraries/libtar { };

  libtasn1 = callPackage ../development/libraries/libtasn1 { };

  libtcod = callPackage ../development/libraries/libtcod { };

  libtheora = callPackage ../development/libraries/libtheora { };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtiger = callPackage ../development/libraries/libtiger { };

  libtommath = callPackage ../development/libraries/libtommath { };

  libtomcrypt = callPackage ../development/libraries/libtomcrypt { };

  libtorrentRasterbar = callPackage ../development/libraries/libtorrent-rasterbar { };

  # this is still the new version of the old API
  libtoxcore-new = callPackage ../development/libraries/libtoxcore/new-api.nix { };

  inherit (callPackages ../development/libraries/libtoxcore {})
    libtoxcore_0_1 libtoxcore_0_2;
  libtoxcore = libtoxcore_0_2;

  libtap = callPackage ../development/libraries/libtap { };

  libtgvoip = callPackage ../development/libraries/libtgvoip { };

  libtsm = callPackage ../development/libraries/libtsm { };

  libtxc_dxtn = callPackage ../development/libraries/libtxc_dxtn { };

  libtxc_dxtn_s2tc = callPackage ../development/libraries/libtxc_dxtn_s2tc { };

  libgeotiff = callPackage ../development/libraries/libgeotiff { };

  libu2f-host = callPackage ../development/libraries/libu2f-host { };

  libu2f-server = callPackage ../development/libraries/libu2f-server { };

  libubox = callPackage ../development/libraries/libubox { };

  libuecc = callPackage ../development/libraries/libuecc { };

  libui = callPackage ../development/libraries/libui {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  libuinputplus = callPackage ../development/libraries/libuinputplus { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  libwhereami = callPackage ../development/libraries/libwhereami { };

  giflib_4_1 = callPackage ../development/libraries/giflib/4.1.nix { };
  giflib     = callPackage ../development/libraries/giflib { };

  libunarr = callPackage ../development/libraries/libunarr { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libunibreak = callPackage ../development/libraries/libunibreak { };

  libuninameslist = callPackage ../development/libraries/libuninameslist { };

  libunique = callPackage ../development/libraries/libunique { };
  libunique3 = callPackage ../development/libraries/libunique/3.x.nix { };

  liburcu = callPackage ../development/libraries/liburcu { };

  libusb = callPackage ../development/libraries/libusb {};

  libusb1 = callPackage ../development/libraries/libusb1 {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  libusbmuxd = callPackage ../development/libraries/libusbmuxd { };

  libutempter = callPackage ../development/libraries/libutempter { };

  libunwind = if stdenv.isDarwin
    then darwin.libunwind
    else callPackage ../development/libraries/libunwind { };

  libuv = callPackage ../development/libraries/libuv {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  };

  libv4l = lowPrio (v4l-utils.override {
    withUtils = false;
  });

  libva = callPackage ../development/libraries/libva { };
  libva-minimal = libva.override { minimal = true; };
  libva-utils = callPackage ../development/libraries/libva-utils { };

  libva1 = callPackage ../development/libraries/libva/1.0.0.nix { };
  libva1-minimal = libva1.override { minimal = true; };

  libvdpau = callPackage ../development/libraries/libvdpau { };

  libmodulemd = callPackage ../development/libraries/libmodulemd { };
  libmodulemd_1 = callPackage ../development/libraries/libmodulemd/1.nix { };

  libvdpau-va-gl = callPackage ../development/libraries/libvdpau-va-gl { };

  libversion = callPackage ../development/libraries/libversion { };

  libvirt = callPackage ../development/libraries/libvirt { };
  libvirt_5_9_0 = callPackage ../development/libraries/libvirt/5.9.0.nix { };

  libvirt-glib = callPackage ../development/libraries/libvirt-glib { };

  libvisio = callPackage ../development/libraries/libvisio { };

  libvisual = callPackage ../development/libraries/libvisual { };

  libvmaf = callPackage ../development/libraries/libvmaf { };

  libvncserver = callPackage ../development/libraries/libvncserver {};

  libviper = callPackage ../development/libraries/libviper { };

  libvpx = callPackage ../development/libraries/libvpx { };

  libvterm = callPackage ../development/libraries/libvterm { };
  libvterm-neovim = callPackage ../development/libraries/libvterm-neovim { };

  libvorbis = callPackage ../development/libraries/libvorbis { };

  libwebcam = callPackage ../os-specific/linux/libwebcam { };

  libwebp = callPackage ../development/libraries/libwebp { };

  libwmf = callPackage ../development/libraries/libwmf { };

  libwnck = libwnck2;
  libwnck2 = callPackage ../development/libraries/libwnck { };
  libwnck3 = callPackage ../development/libraries/libwnck/3.x.nix { };

  libwpd = callPackage ../development/libraries/libwpd { };

  libwpd_08 = callPackage ../development/libraries/libwpd/0.8.nix { };

  libwps = callPackage ../development/libraries/libwps { };

  libwpg = callPackage ../development/libraries/libwpg { };

  libx86 = callPackage ../development/libraries/libx86 {};

  libxdg_basedir = callPackage ../development/libraries/libxdg-basedir { };

  libxkbcommon = libxkbcommon_8;
  libxkbcommon_8 = callPackage ../development/libraries/libxkbcommon { };
  libxkbcommon_7 = callPackage ../development/libraries/libxkbcommon/libxkbcommon_7.nix { };

  libxklavier = callPackage ../development/libraries/libxklavier { };

  libxls = callPackage ../development/libraries/libxls { };

  libxmi = callPackage ../development/libraries/libxmi { };

  libxml2 = callPackage ../development/libraries/libxml2 {
    python = python3;
  };

  libxml2Python = let
    libxml2 = python2Packages.libxml2;
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

  libxmlb = callPackage ../development/libraries/libxmlb { };

  libxmlxx = callPackage ../development/libraries/libxmlxx { };
  libxmlxx3 = callPackage ../development/libraries/libxmlxx/v3.nix { };

  libxmp = callPackage ../development/libraries/libxmp { };

  libxslt = callPackage ../development/libraries/libxslt {
    python = if stdenv.isDarwin then python2 else python3;
  };

  libixp_hg = callPackage ../development/libraries/libixp-hg { };

  libyaml = callPackage ../development/libraries/libyaml { };

  libyamlcpp = callPackage ../development/libraries/libyaml-cpp { };

  libyamlcpp_0_3 = pkgs.libyamlcpp.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = "https://github.com/jbeder/yaml-cpp/archive/release-0.3.0.tar.gz";
      sha256 = "12aszqw6svwlnb6nzhsbqhz3c7vnd5ahd0k6xlj05w8lm83hx3db";
      };
  });

  libykclient = callPackage ../development/libraries/libykclient { };

  libykneomgr = callPackage ../development/libraries/libykneomgr { };

  libytnef = callPackage ../development/libraries/libytnef { };

  libyubikey = callPackage ../development/libraries/libyubikey { };

  libzapojit = callPackage ../development/libraries/libzapojit { };

  libzen = callPackage ../development/libraries/libzen { };

  libzip = callPackage ../development/libraries/libzip { };

  libzdb = callPackage ../development/libraries/libzdb { };

  libwacom = callPackage ../development/libraries/libwacom { };

  lightning = callPackage ../development/libraries/lightning { };

  lightlocker = callPackage ../misc/screensavers/light-locker { };

  lightspark = callPackage ../misc/lightspark { };

  lightstep-tracer-cpp = callPackage ../development/libraries/lightstep-tracer-cpp { };

  linenoise = callPackage ../development/libraries/linenoise { };

  linenoise-ng = callPackage ../development/libraries/linenoise-ng { };

  lirc = callPackage ../development/libraries/lirc { };

  liquid-dsp = callPackage ../development/libraries/liquid-dsp { };

  liquidfun = callPackage ../development/libraries/liquidfun { };

  live555 = callPackage ../development/libraries/live555 { };

  log4cpp = callPackage ../development/libraries/log4cpp { };

  log4cxx = callPackage ../development/libraries/log4cxx { };

  log4cplus = callPackage ../development/libraries/log4cplus { };

  log4shib = callPackage ../development/libraries/log4shib { };

  loudmouth = callPackage ../development/libraries/loudmouth { };

  lrdf = callPackage ../development/libraries/lrdf { };

  luabind = callPackage ../development/libraries/luabind { lua = lua5_1; };

  luabind_luajit = luabind.override { lua = luajit; };

  luksmeta = callPackage ../development/libraries/luksmeta {
    asciidoc = asciidoc-full;
  };

  lyra = callPackage ../development/libraries/lyra { };

  lzo = callPackage ../development/libraries/lzo { };

  opencl-clang = callPackage ../development/libraries/opencl-clang { };

  mapnik = callPackage ../development/libraries/mapnik { };

  marisa = callPackage ../development/libraries/marisa {};

  matio = callPackage ../development/libraries/matio { };

  matterhorn = haskell.lib.justStaticExecutables haskellPackages.matterhorn;

  mbedtls = callPackage ../development/libraries/mbedtls { };

  mdds = callPackage ../development/libraries/mdds { };

  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mediastreamer-openh264 = callPackage ../development/libraries/mediastreamer/msopenh264.nix { };

  menu-cache = callPackage ../development/libraries/menu-cache { };

  mergerfs = callPackage ../tools/filesystems/mergerfs { };

  mergerfs-tools = callPackage ../tools/filesystems/mergerfs/tools.nix { };

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
    llvmPackages = llvmPackages_9;
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

  mesa_glu =  callPackage ../development/libraries/mesa-glu {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  ## End libGL/libGLU/Mesa stuff

  meterbridge = callPackage ../applications/audio/meterbridge { };

  mhddfs = callPackage ../tools/filesystems/mhddfs { };

  microsoft_gsl = callPackage ../development/libraries/microsoft_gsl { };

  micronucleus = callPackage ../development/tools/misc/micronucleus { };

  micropython = callPackage ../development/interpreters/micropython { };

  mimalloc = callPackage ../development/libraries/mimalloc { };

  minizip = callPackage ../development/libraries/minizip { };

  mkvtoolnix = libsForQt5.callPackage ../applications/video/mkvtoolnix { };

  mkvtoolnix-cli = callPackage ../applications/video/mkvtoolnix {
    withGUI = false;
  };

  mlt = callPackage ../development/libraries/mlt { ffmpeg = ffmpeg_4; };

  mono-addins = callPackage ../development/libraries/mono-addins { };

  movit = callPackage ../development/libraries/movit { };

  mosquitto = callPackage ../servers/mqtt/mosquitto { };

  mps = callPackage ../development/libraries/mps { };

  libmpeg2 = callPackage ../development/libraries/libmpeg2 { };

  mpeg2dec = libmpeg2;

  mqtt-bench = callPackage ../applications/misc/mqtt-bench {};

  msgpack = callPackage ../development/libraries/msgpack { };

  msilbc = callPackage ../development/libraries/msilbc { };

  mp4v2 = callPackage ../development/libraries/mp4v2 { };

  libmpc = callPackage ../development/libraries/libmpc { };

  mpich = callPackage ../development/libraries/mpich { };

  mstpd = callPackage ../os-specific/linux/mstpd { };

  mtdev = callPackage ../development/libraries/mtdev { };

  mtpfs = callPackage ../tools/filesystems/mtpfs { };

  mtxclient = callPackage ../development/libraries/mtxclient { };

  mu = callPackage ../tools/networking/mu {
    texinfo = texinfo4;
  };

  mueval = callPackage ../development/tools/haskell/mueval { };

  mumlib = callPackage ../development/libraries/mumlib { };

  muparser = callPackage ../development/libraries/muparser {
    inherit (darwin.stubs) setfile;
  };

  mutest = callPackage ../development/libraries/mutest { };

  mygpoclient = pythonPackages.mygpoclient;

  mygui = callPackage ../development/libraries/mygui {
    ogre = ogre1_9;
  };

  mysocketw = callPackage ../development/libraries/mysocketw {
    openssl = openssl_1_0_2;
  };

  mythes = callPackage ../development/libraries/mythes { };

  nanoflann = callPackage ../development/libraries/nanoflann { };

  nanomsg = callPackage ../development/libraries/nanomsg { };

  ndpi = callPackage ../development/libraries/ndpi { };

  nifticlib = callPackage ../development/libraries/science/biology/nifticlib { };

  notify-sharp = callPackage ../development/libraries/notify-sharp { };

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

  ndi = callPackage ../development/libraries/ndi { };

  neardal = callPackage ../development/libraries/neardal { };

  neatvnc = callPackage ../development/libraries/neatvnc { };

  neon = callPackage ../development/libraries/neon { };

  neon_0_29 = callPackage ../development/libraries/neon/0.29.nix {
    openssl = openssl_1_0_2;
  };

  nettle = callPackage ../development/libraries/nettle { };

  newt = callPackage ../development/libraries/newt { };

  nghttp2 = callPackage ../development/libraries/nghttp2 { };
  libnghttp2 = nghttp2.lib;

  nix-plugins = callPackage ../development/libraries/nix-plugins {};

  nika-fonts = callPackage ../data/fonts/nika-fonts { };

  nlohmann_json = callPackage ../development/libraries/nlohmann_json { };

  nntp-proxy = callPackage ../applications/networking/nntp-proxy { };

  non = callPackage ../applications/audio/non { };

  ntl = callPackage ../development/libraries/ntl { };

  nspr = callPackage ../development/libraries/nspr {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  nss = lowPrio (callPackage ../development/libraries/nss { });
  nssTools = nss.tools;

  nss_wrapper = callPackage ../development/libraries/nss_wrapper { };

  nsss = skawarePackages.nsss;

  ntbtls = callPackage ../development/libraries/ntbtls { };

  ntk = callPackage ../development/libraries/audio/ntk { };

  ntrack = callPackage ../development/libraries/ntrack { };

  nuspell = callPackage ../development/libraries/nuspell { };
  nuspellWithDicts = dicts: callPackage ../development/libraries/nuspell/wrapper.nix { inherit dicts; };

  nv-codec-headers = callPackage ../development/libraries/nv-codec-headers { };

  nvidia-docker = callPackage ../applications/virtualization/nvidia-docker { };

  nvidia-texture-tools = callPackage ../development/libraries/nvidia-texture-tools { };

  nvidia-video-sdk = callPackage ../development/libraries/nvidia-video-sdk { };

  nvidia-optical-flow-sdk = callPackage ../development/libraries/nvidia-optical-flow-sdk { };

  nvtop = callPackage ../tools/system/nvtop {
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };

  ocl-icd = callPackage ../development/libraries/ocl-icd { };

  ode = callPackage ../development/libraries/ode { };

  ogre = callPackage ../development/libraries/ogre {};
  ogre1_9 = callPackage ../development/libraries/ogre/1.9.x.nix {};
  ogre1_10 = callPackage ../development/libraries/ogre/1.10.x.nix {};

  ogrepaged = callPackage ../development/libraries/ogrepaged { };

  olm = callPackage ../development/libraries/olm { };

  one_gadget = callPackage ../development/tools/misc/one_gadget { };

  onedrive = callPackage ../applications/networking/sync/onedrive { };

  oneko = callPackage ../applications/misc/oneko { };

  oniguruma = callPackage ../development/libraries/oniguruma { };

  oobicpl = callPackage ../development/libraries/science/biology/oobicpl { };

  openalSoft = callPackage ../development/libraries/openal-soft {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };
  openal = openalSoft;

  openbabel = callPackage ../development/libraries/openbabel { };

  opencascade = callPackage ../development/libraries/opencascade { };
  opencascade-occt = callPackage ../development/libraries/opencascade-occt { };

  opencl-headers = callPackage ../development/libraries/opencl-headers { };

  opencl-clhpp = callPackage ../development/libraries/opencl-clhpp { };

  opencollada = callPackage ../development/libraries/opencollada { };

  opencore-amr = callPackage ../development/libraries/opencore-amr { };

  opencsg = callPackage ../development/libraries/opencsg {
    inherit (qt5) qmake;
    inherit (darwin.apple_sdk.frameworks) GLUT;
  };

  openct = callPackage ../development/libraries/openct { };

  opencv = callPackage ../development/libraries/opencv {
    inherit (darwin.apple_sdk.frameworks) Cocoa QTKit;
  };

  opencv3 = callPackage ../development/libraries/opencv/3.x.nix {
    inherit (darwin.apple_sdk.frameworks) AVFoundation Cocoa VideoDecodeAcceleration;
  };

  opencv3WithoutCuda = opencv3.override {
    enableCuda = false;
  };

  opencv4 = callPackage ../development/libraries/opencv/4.x.nix {
    inherit (darwin.apple_sdk.frameworks) AVFoundation Cocoa VideoDecodeAcceleration;
  };

  openexr = callPackage ../development/libraries/openexr { };

  openexrid-unstable = callPackage ../development/libraries/openexrid-unstable { };

  openldap = callPackage ../development/libraries/openldap { };

  opencolorio = callPackage ../development/libraries/opencolorio { };

  ois = callPackage ../development/libraries/ois {};

  openh264 = callPackage ../development/libraries/openh264 { };

  openjpeg_1 = callPackage ../development/libraries/openjpeg/1.x.nix { };
  openjpeg_2 = callPackage ../development/libraries/openjpeg/2.x.nix { };
  openjpeg = openjpeg_2;

  openpa = callPackage ../development/libraries/openpa { };

  opensaml-cpp = callPackage ../development/libraries/opensaml-cpp { };

  openscenegraph = callPackage ../development/libraries/openscenegraph { };

  openslp = callPackage ../development/libraries/openslp {};

  openvdb = callPackage ../development/libraries/openvdb {};

  inherit (callPackages ../development/libraries/libressl { })
    libressl_2_9
    libressl_3_0;

  libressl = libressl_3_0;

  boringssl = callPackage ../development/libraries/boringssl { };

  wolfssl = callPackage ../development/libraries/wolfssl { };

  openssl =
    if stdenv.hostPlatform.isMinGW # Work around broken cross build
    then openssl_1_0_2
    else openssl_1_1;

  inherit (callPackages ../development/libraries/openssl { })
    openssl_1_0_2
    openssl_1_1;

  openssl-chacha = callPackage ../development/libraries/openssl/chacha.nix { };

  opensubdiv = callPackage ../development/libraries/opensubdiv { };

  open-wbo = callPackage ../applications/science/logic/open-wbo {};

  openwsman = callPackage ../development/libraries/openwsman {};

  ortp = callPackage ../development/libraries/ortp { };

  openhmd = callPackage ../development/libraries/openhmd { };

  openrct2 = callPackage ../games/openrct2 { };

  orcania = callPackage ../development/libraries/orcania { };

  osm-gps-map = callPackage ../development/libraries/osm-gps-map { };

  osmid = callPackage ../applications/audio/osmid {};

  osinfo-db = callPackage ../data/misc/osinfo-db { };
  osinfo-db-tools = callPackage ../tools/misc/osinfo-db-tools { };

  p11-kit = callPackage ../development/libraries/p11-kit { };

  paperkey = callPackage ../tools/security/paperkey { };

  pangoxsl = callPackage ../development/libraries/pangoxsl { };

  pcaudiolib = callPackage ../development/libraries/pcaudiolib { };

  pcg_c = callPackage ../development/libraries/pcg-c { };

  pcl = libsForQt5.callPackage ../development/libraries/pcl {
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL OpenGL;
  };

  pcre = callPackage ../development/libraries/pcre { };
  pcre16 = res.pcre.override { variant = "pcre16"; };
  # pcre32 seems unused
  pcre-cpp = res.pcre.override { variant = "cpp"; };

  pcre2 = callPackage ../development/libraries/pcre2 { };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  inherit (callPackage ../development/libraries/physfs { })
    physfs_2
    physfs;

  pipelight = callPackage ../tools/misc/pipelight {
    stdenv = stdenv_32bit;
    wine-staging = pkgsi686Linux.wine-staging;
  };

  pkcs11helper = callPackage ../development/libraries/pkcs11helper { };

  pkgdiff = callPackage ../tools/misc/pkgdiff { };

  plib = callPackage ../development/libraries/plib { };

  pocketsphinx = callPackage ../development/libraries/pocketsphinx { };

  poco = callPackage ../development/libraries/poco { };

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

  portmidi = callPackage ../development/libraries/portmidi {};

  primesieve = callPackage ../development/libraries/science/math/primesieve { };

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  proj_5 = callPackage ../development/libraries/proj/5.2.nix { };

  proj-datumgrid = callPackage ../development/libraries/proj-datumgrid { };

  proselint = callPackage ../tools/text/proselint {
    inherit (python3Packages)
    buildPythonApplication click future six;
  };

  prospector = callPackage ../development/tools/prospector {
    python = python37;
  };

  protobuf = protobuf3_7;

  protobuf3_11 = callPackage ../development/libraries/protobuf/3.11.nix { };
  protobuf3_10 = callPackage ../development/libraries/protobuf/3.10.nix { };
  protobuf3_9 = callPackage ../development/libraries/protobuf/3.9.nix { };
  protobuf3_8 = callPackage ../development/libraries/protobuf/3.8.nix { };
  protobuf3_7 = callPackage ../development/libraries/protobuf/3.7.nix { };
  protobuf3_6 = callPackage ../development/libraries/protobuf/3.6.nix { };
  protobuf3_1 = callPackage ../development/libraries/protobuf/3.1.nix { };
  protobuf2_5 = callPackage ../development/libraries/protobuf/2.5.nix { };

  protobufc = callPackage ../development/libraries/protobufc/1.3.nix { };

  protolock = callPackage ../development/libraries/protolock { };

  protozero = callPackage ../development/libraries/protozero { };

  flatbuffers = callPackage ../development/libraries/flatbuffers { };

  gnupth = callPackage ../development/libraries/pth { };
  pth = if stdenv.hostPlatform.isMusl then npth else gnupth;

  pstreams = callPackage ../development/libraries/pstreams {};

  pugixml = callPackage ../development/libraries/pugixml { };

  pybind11 = pythonPackages.pybind11;

  python-qt = callPackage ../development/libraries/python-qt {
    python = python27;
    inherit (qt5) qmake qttools qtwebengine qtxmlpatterns;
  };

  pyotherside = libsForQt5.callPackage ../development/libraries/pyotherside {};

  re2 = callPackage ../development/libraries/re2 { };

  qbs = libsForQt5.callPackage ../development/tools/build-managers/qbs { };

  qca2 = callPackage ../development/libraries/qca2 { qt = qt4; };
  qca2-qt5 = qca2.override { qt = qt5.qtbase; };

  qimageblitz = callPackage ../development/libraries/qimageblitz {};

  qjson = callPackage ../development/libraries/qjson { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qolibri = libsForQt5.callPackage ../applications/misc/qolibri { };

  qt3 = callPackage ../development/libraries/qt-3 {
    libpng = libpng12;
  };

  qt4 = qt48;

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    inherit (pkgs.gnome2) libgnomeui GConf gnome_vfs;
    cups = if stdenv.isLinux then cups else null;

    # XXX: mariadb doesn't built on fbsd as of nov 2015
    libmysqlclient = if (!stdenv.isFreeBSD) then libmysqlclient else null;

    inherit (pkgs.darwin) libobjc;
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

  qt512 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.12) {
      inherit newScope;
      inherit stdenv fetchurl fetchpatch fetchFromGitHub makeSetupHook makeWrapper;
      inherit bison;
      inherit cups;
      inherit dconf;
      inherit harfbuzz;
      inherit libGL;
      inherit perl;
      inherit gtk3;
      inherit (gst_all_1) gstreamer gst-plugins-base;
      inherit llvmPackages_5;
    });

  libsForQt512 = recurseIntoAttrs (lib.makeScope qt512.newScope mkLibsForQt5);

  qt514 = recurseIntoAttrs (makeOverridable
    (import ../development/libraries/qt-5/5.14) {
      inherit newScope;
      inherit stdenv fetchurl fetchpatch fetchFromGitHub makeSetupHook makeWrapper;
      inherit bison;
      inherit cups;
      inherit dconf;
      inherit harfbuzz;
      inherit libGL;
      inherit perl;
      inherit gtk3;
      inherit (gst_all_1) gstreamer gst-plugins-base;
      inherit llvmPackages_5;
    });

  libsForQt514 = recurseIntoAttrs (lib.makeScope qt514.newScope mkLibsForQt5);

  # TODO bump to 5.12 on darwin once it's not broken
  qt5 = qt514;
  libsForQt5 = libsForQt514;

  qt5ct = libsForQt5.callPackage ../tools/misc/qt5ct { };

  mkLibsForQt5 = self: with self; {

    ### KDE FRAMEWORKS

    inherit (kdeFrameworks.override { libsForQt5 = self; })
      attica baloo bluez-qt kactivities kactivities-stats
      karchive kauth kbookmarks kcmutils kcalendarcore kcodecs kcompletion kconfig
      kconfigwidgets kcoreaddons kcrash kdbusaddons kdeclarative kdelibs4support
      kdesignerplugin kdnssd kemoticons kfilemetadata kglobalaccel kguiaddons
      khtml ki18n kiconthemes kidletime kimageformats kio kitemmodels kitemviews
      kjobwidgets kjs kjsembed kmediaplayer knewstuff knotifications
      knotifyconfig kpackage kparts kpeople kplotting kpty kross krunner
      kservice ktexteditor ktextwidgets kunitconversion kwallet kwayland
      kwidgetsaddons kwindowsystem kxmlgui kxmlrpcclient modemmanager-qt
      networkmanager-qt plasma-framework prison solid sonnet syntax-highlighting
      syndication threadweaver kirigami2 kholidays kpurpose kcontacts;

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

    libqglviewer = callPackage ../development/libraries/libqglviewer {
      inherit (darwin.apple_sdk.frameworks) AGL;
    };

    libqtav = callPackage ../development/libraries/libqtav { };

    kpmcore = callPackage ../development/libraries/kpmcore { };

    mlt = callPackage ../development/libraries/mlt/qt-5.nix {
      ffmpeg = ffmpeg_4;
    };

    openbr = callPackage ../development/libraries/openbr { };

    phonon = callPackage ../development/libraries/phonon { };

    phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix { };

    phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix { };

    polkit-qt = callPackage ../development/libraries/polkit-qt-1/qt-5.nix { };

    poppler = callPackage ../development/libraries/poppler {
      lcms = lcms2;
      qt5Support = true;
      suffix = "qt5";
    };

    qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

    qmltermwidget = callPackage ../development/libraries/qmltermwidget {
      inherit (darwin.apple_sdk.libs) utmp;
    };
    qmlbox2d = libsForQt5.callPackage ../development/libraries/qmlbox2d { };

    qscintilla = callPackage ../development/libraries/qscintilla {
      withQt5 = true;
    };

    qtutilities = callPackage ../development/libraries/qtutilities { };

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

  qtpbfimageplugin = libsForQt5.callPackage ../development/libraries/qtpbfimageplugin { };

  qtscriptgenerator = callPackage ../development/libraries/qtscriptgenerator { };

  quesoglc = callPackage ../development/libraries/quesoglc { };

  quickder = callPackage ../development/libraries/quickder {};

  quicksynergy = callPackage ../applications/misc/quicksynergy { };

  qwt = callPackage ../development/libraries/qwt {};

  qwt6_qt4 = callPackage ../development/libraries/qwt/6_qt4.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  qxt = callPackage ../development/libraries/qxt {};

  rabbitmq-c = callPackage ../development/libraries/rabbitmq-c {};

  raft-canonical = callPackage ../development/libraries/raft-canonical { };

  range-v3 = callPackage ../development/libraries/range-v3 {};

  rabbitmq-java-client = callPackage ../development/libraries/rabbitmq-java-client {};

  rapidcheck = callPackage ../development/libraries/rapidcheck {};

  rapidjson = callPackage ../development/libraries/rapidjson {};

  rapidxml = callPackage ../development/libraries/rapidxml {};

  raul = callPackage ../development/libraries/audio/raul { };

  readline = readline6;
  readline6 = readline63;

  readline5 = callPackage ../development/libraries/readline/5.x.nix { };

  readline62 = callPackage ../development/libraries/readline/6.2.nix { };

  readline63 = callPackage ../development/libraries/readline/6.3.nix { };

  readline70 = callPackage ../development/libraries/readline/7.0.nix { };

  readline80 = callPackage ../development/libraries/readline/8.0.nix { };

  readosm = callPackage ../development/libraries/readosm { };

  lambdabot = callPackage ../development/tools/haskell/lambdabot {
    haskellLib = haskell.lib;
  };

  lambda-mod-zsh-theme = callPackage ../shells/zsh/lambda-mod-zsh-theme { };

  leksah = throw ("To use leksah, refer to the instructions in " +
    "https://github.com/leksah/leksah.");

  libgme = callPackage ../development/libraries/audio/libgme { };

  librdf_raptor = callPackage ../development/libraries/librdf/raptor.nix { };

  librdf_raptor2 = callPackage ../development/libraries/librdf/raptor2.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf_redland = callPackage ../development/libraries/librdf/redland.nix { };
  redland = librdf_redland; # added 2018-04-25

  libsmf = callPackage ../development/libraries/audio/libsmf { };

  lilv = callPackage ../development/libraries/audio/lilv { };

  lv2 = callPackage ../development/libraries/audio/lv2 { };

  lvtk = callPackage ../development/libraries/audio/lvtk { };

  qradiolink = callPackage ../applications/radio/qradiolink { };

  qrupdate = callPackage ../development/libraries/qrupdate { };

  qgnomeplatform =  libsForQt5.callPackage ../development/libraries/qgnomeplatform { };

  randomx = callPackage ../development/libraries/randomx { };

  resolv_wrapper = callPackage ../development/libraries/resolv_wrapper { };

  rhino = callPackage ../development/libraries/java/rhino {
    javac = jdk;
    jvm = jre;
  };

  rlog = callPackage ../development/libraries/rlog { };

  rocksdb = callPackage ../development/libraries/rocksdb { };

  rocksdb_lite = rocksdb.override { enableLite = true; };

  rotate-backups = with python3Packages; toPythonApplication rotate-backups;

  rote = callPackage ../development/libraries/rote { };

  ronn = callPackage ../development/tools/ronn { };

  rshell = python3.pkgs.callPackage ../development/tools/rshell { };

  rttr = callPackage ../development/libraries/rttr { };

  rubberband = callPackage ../development/libraries/rubberband { };

  sad = callPackage ../applications/science/logic/sad { };

  safefile = callPackage ../development/libraries/safefile {};

  sbc = callPackage ../development/libraries/sbc { };

  schroedinger = callPackage ../development/libraries/schroedinger { };

  SDL = callPackage ../development/libraries/SDL ({
    inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa;
  } // lib.optionalAttrs stdenv.hostPlatform.isAndroid {
    # libGLU doesn’t work with Android’s SDL
    libGLU = null;
  });

  SDL_sixel = callPackage ../development/libraries/SDL_sixel { };

  SDL_gfx = callPackage ../development/libraries/SDL_gfx { };

  SDL_gpu = callPackage ../development/libraries/SDL_gpu { };

  SDL_image = callPackage ../development/libraries/SDL_image { };

  SDL_mixer = callPackage ../development/libraries/SDL_mixer { };

  SDL_net = callPackage ../development/libraries/SDL_net { };

  SDL_Pango = callPackage ../development/libraries/SDL_Pango {};

  SDL_sound = callPackage ../development/libraries/SDL_sound { };

  SDL_stretch= callPackage ../development/libraries/SDL_stretch { };

  SDL_ttf = callPackage ../development/libraries/SDL_ttf { };

  SDL2 = callPackage ../development/libraries/SDL2 {
    inherit (darwin.apple_sdk.frameworks) AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL;
  };

  SDL2_image = callPackage ../development/libraries/SDL2_image {
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  SDL2_mixer = callPackage ../development/libraries/SDL2_mixer {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };

  SDL2_net = callPackage ../development/libraries/SDL2_net { };

  SDL2_gfx = callPackage ../development/libraries/SDL2_gfx { };

  SDL2_ttf = callPackage ../development/libraries/SDL2_ttf { };

  sdnotify-wrapper = skawarePackages.sdnotify-wrapper;

  sblim-sfcc = callPackage ../development/libraries/sblim-sfcc {};

  selinux-sandbox = callPackage ../os-specific/linux/selinux-sandbox { };

  seasocks = callPackage ../development/libraries/seasocks { };

  serd = callPackage ../development/libraries/serd {};

  serf = callPackage ../development/libraries/serf {};

  sfsexp = callPackage ../development/libraries/sfsexp {};

  shhmsg = callPackage ../development/libraries/shhmsg { };

  shhopt = callPackage ../development/libraries/shhopt { };

  graphite2 = callPackage ../development/libraries/silgraphite/graphite2.nix {};

  simavr = callPackage ../development/tools/simavr {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrlibc = pkgsCross.avr.libcCross;
    inherit (darwin.apple_sdk.frameworks) GLUT;
  };

  simgear = callPackage ../development/libraries/simgear { };

  simp_le = callPackage ../tools/admin/simp_le { };

  simpleitk = callPackage ../development/libraries/simpleitk { lua = lua51Packages.lua; };

  sfml = callPackage ../development/libraries/sfml {
    inherit (darwin.apple_sdk.frameworks) IOKit Foundation AppKit OpenAL;
  };
  csfml = callPackage ../development/libraries/csfml { };

  shapelib = callPackage ../development/libraries/shapelib { };

  shibboleth-sp = callPackage ../development/libraries/shibboleth-sp { };

  skaffold = callPackage ../development/tools/skaffold { };

  skalibs = skawarePackages.skalibs;

  skawarePackages = recurseIntoAttrs rec {
    cleanPackaging = callPackage ../build-support/skaware/clean-packaging.nix { };
    buildPackage = callPackage ../build-support/skaware/build-skaware-package.nix {
      inherit cleanPackaging;
    };

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
    sdnotify-wrapper = callPackage ../os-specific/linux/sdnotify-wrapper { };
  };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
    texinfo = texinfo4; # otherwise erros: must be after `@defun' to use `@defunx'
  };

  smpeg = callPackage ../development/libraries/smpeg { };

  smpeg2 = callPackage ../development/libraries/smpeg2 { };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

  snappy = callPackage ../development/libraries/snappy { };

  soapyairspy = callPackage ../applications/radio/soapyairspy { };

  soapybladerf = callPackage ../applications/radio/soapybladerf { };

  soapyhackrf = callPackage ../applications/radio/soapyhackrf { };

  soapysdr = callPackage ../applications/radio/soapysdr { };

  soapyremote = callPackage ../applications/radio/soapyremote { };

  soapysdr-with-plugins = callPackage ../applications/radio/soapysdr {
    extraPackages = [
      limesuite
      soapyairspy
      soapybladerf
      soapyhackrf
      soapyremote
      soapyrtlsdr
      soapyuhd
    ];
  };

  soapyrtlsdr = callPackage ../applications/radio/soapyrtlsdr { };

  soapyuhd = callPackage ../applications/radio/soapyuhd { };

  socket_wrapper = callPackage ../development/libraries/socket_wrapper { };

  sofia_sip = callPackage ../development/libraries/sofia-sip { };

  soil = callPackage ../development/libraries/soil { };

  sonic = callPackage ../development/libraries/sonic { };

  soprano = callPackage ../development/libraries/soprano { };

  soqt = callPackage ../development/libraries/soqt { };

  sord = callPackage ../development/libraries/sord {};

  soundtouch = callPackage ../development/libraries/soundtouch {};

  spandsp = callPackage ../development/libraries/spandsp {};

  spaceship-prompt = callPackage ../shells/zsh/spaceship-prompt {};

  spatialite_tools = callPackage ../development/libraries/spatialite-tools { };

  spdk = callPackage ../development/libraries/spdk { };

  speechd = callPackage ../development/libraries/speechd { };

  speech-tools = callPackage ../development/libraries/speech-tools {};

  speex = callPackage ../development/libraries/speex {
    fftw = fftwFloat;
  };

  speexdsp = callPackage ../development/libraries/speexdsp {
    fftw = fftwFloat;
  };

  sphinxbase = callPackage ../development/libraries/sphinxbase { };

  sphinxsearch = callPackage ../servers/search/sphinxsearch { };

  spice = callPackage ../development/libraries/spice { };

  spice-gtk = callPackage ../development/libraries/spice-gtk { };

  spice-protocol = callPackage ../development/libraries/spice-protocol { };

  spice-up = callPackage ../applications/office/spice-up { };

  sratom = callPackage ../development/libraries/audio/sratom { };

  srm = callPackage ../tools/security/srm { };

  srt = callPackage ../development/libraries/srt { };

  srtp = callPackage ../development/libraries/srtp {
    libpcap = if stdenv.isLinux then libpcap else null;
  };

  stb = callPackage ../development/libraries/stb { };

  stxxl = callPackage ../development/libraries/stxxl { parallel = true; };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite { });

  sqlite-analyzer = lowPrio (callPackage ../development/libraries/sqlite/analyzer.nix { });

  sqlar = callPackage ../development/libraries/sqlite/sqlar.nix { };

  sqlite-interactive = appendToName "interactive" (sqlite.override { interactive = true; }).bin;

  sqlite-jdbc = callPackage ../servers/sql/sqlite/jdbc { };

  sqlite-replication = sqlite.overrideAttrs (oldAttrs: rec {
    name = "sqlite-${version}";
    version = "3.27.2+replication3";
    src = pkgs.fetchFromGitHub {
      owner = "CanonicalLtd";
      repo = "sqlite";
      rev = "version-${version}";
      sha256 = "1aw1naa5y25ial251f74h039pgcz92p4b3994jvfzqpjlz06qwvw";
    };
    nativeBuildInputs = [ pkgs.tcl ];
    configureFlags = oldAttrs.configureFlags ++ [
      "--enable-replication"
      "--disable-amalgamation"
      "--disable-tcl"
    ];
    preConfigure = ''
      echo "D 2019-03-09T15:45:46" > manifest
      echo -n "8250984a368079bb1838d48d99f8c1a6282e00bc" > manifest.uuid
    '';
  });

  dqlite = callPackage ../development/libraries/dqlite { };

  sqlcipher = lowPrio (callPackage ../development/libraries/sqlcipher {
    readline = null;
    ncurses = null;
  });

  standardnotes = callPackage ../applications/editors/standardnotes { };

  stfl = callPackage ../development/libraries/stfl { };

  stlink = callPackage ../development/tools/misc/stlink {
    # The Darwin build of stlink explicitly refers to static libusb.
    libusb1 = if stdenv.isDarwin then libusb1.override { withStatic = true; } else libusb1;
  };

  steghide = callPackage ../tools/security/steghide {};

  stlport = callPackage ../development/libraries/stlport { };

  streamlink = callPackage ../applications/video/streamlink { pythonPackages = python3Packages; };

  strigi = callPackage ../development/libraries/strigi { clucene_core = clucene_core_2; };

  subdl = callPackage ../applications/video/subdl { };

  subtitleeditor = callPackage ../applications/video/subtitleeditor { enchant = enchant1; };

  suil = callPackage ../development/libraries/audio/suil { };

  suil-qt5 = suil.override {
    withQt4 = false;
    withQt5 = true;
  };
  suil-qt4 = suil.override {
    withQt4 = true;
    withQt5 = false;
  };

  sundials = callPackage ../development/libraries/sundials {
    python = python3;
  };

  sundials_2 = callPackage ../development/libraries/sundials/2.x.nix {
    python = python3;
  };

  sutils = callPackage ../tools/misc/sutils { };

  svrcore = callPackage ../development/libraries/svrcore { };

  svxlink = libsForQt5.callPackage ../applications/radio/svxlink { };

  swiftclient = python3.pkgs.callPackage ../tools/admin/swiftclient { };

  sword = callPackage ../development/libraries/sword { };

  biblesync = callPackage ../development/libraries/biblesync { };

  szip = callPackage ../development/libraries/szip { };

  t1lib = callPackage ../development/libraries/t1lib { };

  tachyon = callPackage ../development/libraries/tachyon {
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  taglib = callPackage ../development/libraries/taglib { };

  taglib_extras = callPackage ../development/libraries/taglib-extras { };

  taglib-sharp = callPackage ../development/libraries/taglib-sharp { };

  talloc = callPackage ../development/libraries/talloc {
    python = buildPackages.python3;
  };

  tclap = callPackage ../development/libraries/tclap {};

  tcllib = callPackage ../development/libraries/tcllib { };

  tcltls = callPackage ../development/libraries/tcltls {
    openssl = openssl_1_0_2;
  };

  tclx = callPackage ../development/libraries/tclx { };

  ntdb = callPackage ../development/libraries/ntdb { };

  tdb = callPackage ../development/libraries/tdb {};

  tdlib = callPackage ../development/libraries/tdlib { };

  tecla = callPackage ../development/libraries/tecla { };

  tectonic = callPackage ../tools/typesetting/tectonic {
    harfbuzz = harfbuzzFull;
  };

  tepl = callPackage ../development/libraries/tepl { };

  telepathy-glib = callPackage ../development/libraries/telepathy/glib { };

  telepathy-farstream = callPackage ../development/libraries/telepathy/farstream {};

  telepathy-qt = callPackage ../development/libraries/telepathy/qt { qtbase = qt4; };

  termbox = callPackage ../development/libraries/termbox { };

  tevent = callPackage ../development/libraries/tevent { };

  tet = callPackage ../development/tools/misc/tet { };

  theft = callPackage ../development/libraries/theft { };

  thrift = callPackage ../development/libraries/thrift {
    inherit (pythonPackages) twisted;
  };

  thrift-0_10 = callPackage ../development/libraries/thrift/0.10.nix {
    inherit (pythonPackages) twisted;
  };

  tidyp = callPackage ../development/libraries/tidyp { };

  tinycdb = callPackage ../development/libraries/tinycdb { };

  tinyxml = tinyxml2;

  tinyxml2 = callPackage ../development/libraries/tinyxml/2.6.2.nix { };

  tinyxml-2 = callPackage ../development/libraries/tinyxml-2 { };

  tiscamera = callPackage ../os-specific/linux/tiscamera { };

  tivodecode = callPackage ../applications/video/tivodecode { };

  tix = callPackage ../development/libraries/tix { };

  tk = tk-8_6;

  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tl-expected = callPackage ../development/libraries/tl-expected { };

  tnt = callPackage ../development/libraries/tnt { };

  tntnet = callPackage ../development/libraries/tntnet { };

  tntdb = callPackage ../development/libraries/tntdb { };

  kyotocabinet = callPackage ../development/libraries/kyotocabinet { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };

  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  totem-pl-parser = callPackage ../development/libraries/totem-pl-parser { };

  tpm2-tss = callPackage ../development/libraries/tpm2-tss { };

  tremor = callPackage ../development/libraries/tremor { };

  twolame = callPackage ../development/libraries/twolame { };

  udns = callPackage ../development/libraries/udns { };

  uid_wrapper = callPackage ../development/libraries/uid_wrapper { };

  umockdev = callPackage ../development/libraries/umockdev { };

  unconvert = callPackage ../development/tools/unconvert { };

  unibilium = callPackage ../development/libraries/unibilium { };

  unicap = callPackage ../development/libraries/unicap {};

  unicon-lang = callPackage ../development/interpreters/unicon-lang {};

  tsocks = callPackage ../development/libraries/tsocks { };

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (callPackages ../development/libraries/unixODBCDrivers { });

  ustr = callPackage ../development/libraries/ustr { };

  usbredir = callPackage ../development/libraries/usbredir {
    libusb = libusb1;
  };

  uthash = callPackage ../development/libraries/uthash { };

  utmps = skawarePackages.utmps;

  ucommon = ucommon_openssl;

  ucommon_openssl = callPackage ../development/libraries/ucommon {
    gnutls = null;
    openssl = openssl_1_0_2;
  };

  ucommon_gnutls = lowPrio (ucommon.override {
    openssl = null;
    zlib = null;
    gnutls = gnutls;
  });

  v8_5_x = callPackage ../development/libraries/v8/5_x.nix ({
    inherit (python2Packages) python gyp;
    icu = icu58; # v8-5.4.232 fails against icu4c-59.1
  } // lib.optionalAttrs stdenv.isLinux {
    # doesn't build with gcc7
    stdenv = gcc6Stdenv;
  });

  v8_6_x = v8;
  v8 = callPackage ../development/libraries/v8 {
    inherit (python2Packages) python;
  } // lib.optionalAttrs stdenv.isLinux {
    # doesn't build with gcc7
    stdenv = gcc6Stdenv;
  };

  vaapiIntel = callPackage ../development/libraries/vaapi-intel { };

  vaapi-intel-hybrid = callPackage ../development/libraries/vaapi-intel-hybrid { };

  vaapiVdpau = callPackage ../development/libraries/vaapi-vdpau { };

  vale = callPackage ../tools/text/vale { };

  vamp-plugin-sdk = callPackage ../development/libraries/audio/vamp-plugin-sdk { };

  vc = callPackage ../development/libraries/vc { };

  vc_0_7 = callPackage ../development/libraries/vc/0.7.nix { };

  vcdimager = callPackage ../development/libraries/vcdimager { };

  vcg = callPackage ../development/libraries/vcg { };

  vid-stab = callPackage ../development/libraries/vid-stab { };

  vigra = callPackage ../development/libraries/vigra { };

  vlock = callPackage ../misc/screensavers/vlock { };

  vmime = callPackage ../development/libraries/vmime { };

  vrb = callPackage ../development/libraries/vrb { };

  vrpn = callPackage ../development/libraries/vrpn { };

  vsqlite = callPackage ../development/libraries/vsqlite { };

  vte = callPackage ../development/libraries/vte { };

  vte_290 = callPackage ../development/libraries/vte/2.90.nix { };

  vtk = callPackage ../development/libraries/vtk {
    stdenv = gcc8Stdenv;
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
                                          IOKit CFNetwork Security ApplicationServices
                                          CoreText IOSurface ImageIO OpenGL GLUT;
  };

  vulkan-headers = callPackage ../development/libraries/vulkan-headers { };
  vulkan-loader = callPackage ../development/libraries/vulkan-loader { };
  vulkan-tools = callPackage ../tools/graphics/vulkan-tools { };
  vulkan-validation-layers = callPackage ../development/tools/vulkan-validation-layers {
    glslang = (glslang.override {
      spirv-tools = spirv-tools.overrideAttrs (_: {
        src = fetchFromGitHub {
          owner = "KhronosGroup";
          repo = "SPIRV-Tools";
          rev = "323a81fc5e30e43a04e5e22af4cba98ca2a161e6";
          sha256 = "1kwyh95l02w3v1ra55c836wayzw8d0m14ab7wf0ynhhyp3k2p9hv";
        };
      });
      spirv-headers = spirv-tools.overrideAttrs (_: {
        src = fetchFromGitHub {
          owner = "KhronosGroup";
          repo = "SPIRV-Headers";
          rev = "204cd131c42b90d129073719f2766293ce35c081";
          sha256 = "1gp0mlbfccqnalaix97jxsa5i337xyzyr55wgssapy56p0q04wv2";
        };
      });
    }).overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "glslang";
        rev = "4fc7a33910fb8e40b970d160e1b38ab3f67fe0f3";
        sha256 = "1dghz8zl774dx2xpa4dv8xhxirbylgyn6kx18ib4qirna1njp0zg";
      };
    });
  };

  vtkWithQt4 = vtk.override { qtLib = qt4; };

  vxl = callPackage ../development/libraries/vxl {
    libpng = libpng12;
    stdenv = gcc6Stdenv; # upstream code incompatible with gcc7
  };

  wally-cli = callPackage ../development/tools/wally-cli { };

  wavpack = callPackage ../development/libraries/wavpack { };

  wayland = callPackage ../development/libraries/wayland { };

  wayland-protocols = callPackage ../development/libraries/wayland/protocols.nix { };

  waylandpp = callPackage ../development/libraries/waylandpp { };

  wcslib = callPackage ../development/libraries/wcslib { };

  webkitgtk = callPackage ../development/libraries/webkitgtk {
    harfbuzz = harfbuzzFull;
    inherit (gst_all_1) gst-plugins-base gst-plugins-bad;
    stdenv = clangStdenv; # TODO: https://github.com/NixOS/nixpkgs/issues/36947
  };

  websocketpp = callPackage ../development/libraries/websocket++ { };

  webrtc-audio-processing = callPackage ../development/libraries/webrtc-audio-processing { };

  wildmidi = callPackage ../development/libraries/wildmidi { };

  wiredtiger = callPackage ../development/libraries/wiredtiger { };

  wt = wt4;
  inherit (callPackages ../development/libraries/wt {})
    wt3
    wt4;

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxwidgets/2.8 {
    inherit (gnome2) GConf;
  };

  wxGTK29 = callPackage ../development/libraries/wxwidgets/2.9 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QuickTime;
  };

  wxGTK30 = callPackage ../development/libraries/wxwidgets/3.0 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit;
  };

  wxGTK31 = callPackage ../development/libraries/wxwidgets/3.1 {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit;
  };

  wxmac = callPackage ../development/libraries/wxwidgets/3.0/mac.nix {
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa Kernel;
    inherit (darwin.stubs) setfile rez derez;
  };

  wxSVG = callPackage ../development/libraries/wxSVG {
    wxGTK = wxGTK30;
  };

  wtk = callPackage ../development/libraries/wtk { };

  x264 = callPackage ../development/libraries/x264 { };

  x265 = callPackage ../development/libraries/x265 { };

  xandikos = callPackage ../servers/xandikos { };

  inherit (callPackages ../development/libraries/xapian { })
    xapian_1_4;
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

  xineLib = callPackage ../development/libraries/xine-lib { };

  xautolock = callPackage ../misc/screensavers/xautolock { };

  xercesc = callPackage ../development/libraries/xercesc {};

  xalanc = callPackage ../development/libraries/xalanc {};

  xgboost = callPackage ../development/libraries/xgboost { };

  xgeometry-select = callPackage ../tools/X11/xgeometry-select { };

  # Avoid using this. It isn't really a wrapper anymore, but we keep the name.
  xlibsWrapper = callPackage ../development/libraries/xlibs-wrapper {
    packages = [
      freetype fontconfig xorg.xorgproto xorg.libX11 xorg.libXt
      xorg.libXft xorg.libXext xorg.libSM xorg.libICE
    ];
  };

  xmlrpc_c = callPackage ../development/libraries/xmlrpc-c { };

  xmlsec = callPackage ../development/libraries/xmlsec { };

  xml-security-c = callPackage ../development/libraries/xml-security-c { };

  xml-tooling-c = callPackage ../development/libraries/xml-tooling-c { };

  xlslib = callPackage ../development/libraries/xlslib { };

  xvidcore = callPackage ../development/libraries/xvidcore { };

  xxHash = callPackage ../development/libraries/xxHash {};

  xylib = callPackage ../development/libraries/xylib { };

  yajl = callPackage ../development/libraries/yajl { };

  yder = callPackage ../development/libraries/yder { };

  ydotool = callPackage ../tools/wayland/ydotool { };

  yojimbo = callPackage ../development/libraries/yojimbo { };

  yubioath-desktop = libsForQt5.callPackage ../applications/misc/yubioath-desktop { };

  yubico-pam = callPackage ../development/libraries/yubico-pam { };

  yubico-piv-tool = callPackage ../tools/misc/yubico-piv-tool {
    inherit (darwin.apple_sdk.frameworks) PCSC;
  };

  yubikey-manager = callPackage ../tools/misc/yubikey-manager { };

  yubikey-manager-qt = libsForQt5.callPackage ../tools/misc/yubikey-manager-qt {
    pythonPackages = python3Packages;
  };

  yubikey-neo-manager = callPackage ../tools/misc/yubikey-neo-manager { };

  yubikey-personalization = callPackage ../tools/misc/yubikey-personalization {
    libusb = libusb1;
  };

  yubikey-personalization-gui = libsForQt5.callPackage ../tools/misc/yubikey-personalization-gui { };

  zchunk = callPackage ../development/libraries/zchunk { };

  zeitgeist = callPackage ../development/libraries/zeitgeist { };

  zlib = callPackage ../development/libraries/zlib { };

  libdynd = callPackage ../development/libraries/libdynd { };

  zlog = callPackage ../development/libraries/zlog { };

  zeromq3 = callPackage ../development/libraries/zeromq/3.x.nix {};
  zeromq4 = callPackage ../development/libraries/zeromq/4.x.nix {};
  zeromq = zeromq4;

  cppzmq = callPackage ../development/libraries/cppzmq {};

  czmq = callPackage ../development/libraries/czmq/default.nix {};

  zmqpp = callPackage ../development/libraries/zmqpp { };

  zig = callPackage ../development/compilers/zig {
    llvmPackages = llvmPackages_9;
  };

  zimlib = callPackage ../development/libraries/zimlib { };

  zita-convolver = callPackage ../development/libraries/audio/zita-convolver { };

  zita-alsa-pcmi = callPackage ../development/libraries/audio/zita-alsa-pcmi { };

  zita-resampler = callPackage ../development/libraries/audio/zita-resampler { };

  zz = callPackage ../development/compilers/zz { };

  zziplib = callPackage ../development/libraries/zziplib { };

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

  bitvector = callPackage ../development/libraries/agda/bitvector { };

  categories = callPackage ../development/libraries/agda/categories { };

  pretty = callPackage ../development/libraries/agda/pretty { };

  TotalParserCombinators = callPackage ../development/libraries/agda/TotalParserCombinators { };

  ### DEVELOPMENT / LIBRARIES / JAVA

  commonsBcel = callPackage ../development/libraries/java/commons/bcel { };

  commonsBsf = callPackage ../development/libraries/java/commons/bsf { };

  commonsCompress = callPackage ../development/libraries/java/commons/compress { };

  commonsFileUpload = callPackage ../development/libraries/java/commons/fileupload { };

  commonsLang = callPackage ../development/libraries/java/commons/lang { };

  commonsLogging = callPackage ../development/libraries/java/commons/logging { };

  commonsIo = callPackage ../development/libraries/java/commons/io { };

  commonsMath = callPackage ../development/libraries/java/commons/math { };

  fastjar = callPackage ../development/tools/java/fastjar { };

  httpunit = callPackage ../development/libraries/java/httpunit { };

  gwtdragdrop = callPackage ../development/libraries/java/gwt-dragdrop { };

  gwtwidgets = callPackage ../development/libraries/java/gwt-widgets { };

  javaCup = callPackage ../development/libraries/java/cup { };

  jdom = callPackage ../development/libraries/java/jdom { };

  jflex = callPackage ../development/libraries/java/jflex { };

  junit = callPackage ../development/libraries/java/junit { antBuild = releaseTools.antBuild; };

  junixsocket = callPackage ../development/libraries/java/junixsocket { };

  jzmq = callPackage ../development/libraries/java/jzmq { };

  lombok = callPackage ../development/libraries/java/lombok { };

  lucene = callPackage ../development/libraries/java/lucene { };

  lucenepp = callPackage ../development/libraries/lucene++ {
    boost = boost155;
  };

  mockobjects = callPackage ../development/libraries/java/mockobjects { };

  saxonb = saxonb_8_8;

  inherit (callPackages ../development/libraries/java/saxon { })
    saxon
    saxonb_8_8
    saxonb_9_1
    saxon-he;

  smack = callPackage ../development/libraries/java/smack { };

  swt = callPackage ../development/libraries/java/swt { };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  yuicompressor = callPackage ../development/tools/yuicompressor { };

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  buildBowerComponents = callPackage ../development/bower-modules/generic { };

  ### DEVELOPMENT / GO MODULES

  buildGo112Package = callPackage ../development/go-packages/generic {
    go = buildPackages.go_1_12;
  };
  buildGo113Package = callPackage ../development/go-packages/generic {
    go = buildPackages.go_1_13;
  };
  buildGo114Package = callPackage ../development/go-packages/generic {
    go = buildPackages.go_1_14;
  };

  buildGoPackage = buildGo114Package;

  buildGo112Module = callPackage ../development/go-modules/generic {
    go = buildPackages.go_1_12;
  };
  buildGo113Module = callPackage ../development/go-modules/generic {
    go = buildPackages.go_1_13;
  };
  buildGo114Module = callPackage ../development/go-modules/generic {
    go = buildPackages.go_1_14;
  };

  buildGoModule = buildGo114Module;

  go2nix = callPackage ../development/tools/go2nix { };

  leaps = callPackage ../development/tools/leaps { };

  vgo2nix = callPackage ../development/tools/vgo2nix { };

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
  quicklispPackagesClisp = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp clisp));
  quicklispPackagesSBCL = dontRecurseIntoAttrs (quicklispPackagesFor (wrapLisp sbcl));
  quicklispPackages = quicklispPackagesSBCL;
  quicklispPackages_asdf_3_1 = quicklispPackagesFor
    ((wrapLisp sbcl).override { asdf = asdf_3_1; });

  ### DEVELOPMENT / PERL MODULES

  perlInterpreters = callPackages ../development/interpreters/perl {};
  inherit (perlInterpreters) perl528 perl530 perldevel;

  perl528Packages = recurseIntoAttrs perl528.pkgs;
  perl530Packages = recurseIntoAttrs perl530.pkgs;
  perldevelPackages = perldevel.pkgs;

  perl = perl530;
  perlPackages = perl530Packages;

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

  rstudioWrapper = libsForQt5.callPackage ../development/r-modules/wrapper-rstudio.nix {
    recommendedPackages = with rPackages; [
      boot class cluster codetools foreign KernSmooth lattice MASS
      Matrix mgcv nlme nnet rpart spatial survival
    ];
    # Override this attribute to register additional libraries.
    packages = [];
  };

  rPackages = dontRecurseIntoAttrs (callPackage ../development/r-modules {
    overrides = (config.rPackageOverrides or (p: {})) pkgs;
  });

  ### SERVERS

  _389-ds-base = callPackage ../servers/ldap/389 {
    kerberos = libkrb5;
  };

  apacheHttpd_2_4 = callPackage ../servers/http/apache-httpd/2.4.nix { };
  apacheHttpd = pkgs.apacheHttpd_2_4;

  apacheHttpdPackagesFor = apacheHttpd: self: let callPackage = newScope self; in {
    inherit apacheHttpd;

    mod_auth_mellon = callPackage ../servers/http/apache-modules/mod_auth_mellon { };

    # Redwax collection
    mod_ca = callPackage ../servers/http/apache-modules/mod_ca { };
    mod_crl = callPackage ../servers/http/apache-modules/mod_crl { };
    mod_csr = callPackage ../servers/http/apache-modules/mod_csr { };
    mod_ocsp = callPackage ../servers/http/apache-modules/mod_ocsp{ };
    mod_scep = callPackage ../servers/http/apache-modules/mod_scep { };
    mod_pkcs12 = callPackage ../servers/http/apache-modules/mod_pkcs12 { };
    mod_spkac= callPackage ../servers/http/apache-modules/mod_spkac { };
    mod_timestamp = callPackage ../servers/http/apache-modules/mod_timestamp { };

    mod_dnssd = callPackage ../servers/http/apache-modules/mod_dnssd { };

    mod_evasive = callPackage ../servers/http/apache-modules/mod_evasive { };

    mod_perl = callPackage ../servers/http/apache-modules/mod_perl { };

    mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

    mod_python = callPackage ../servers/http/apache-modules/mod_python { };

    mod_tile = callPackage ../servers/http/apache-modules/mod_tile { };

    mod_wsgi  = self.mod_wsgi2;
    mod_wsgi2 = callPackage ../servers/http/apache-modules/mod_wsgi { python = python2; ncurses = null; };
    mod_wsgi3 = callPackage ../servers/http/apache-modules/mod_wsgi { python = python3; };

    php = pkgs.php.override { inherit apacheHttpd; };

    subversion = pkgs.subversion.override { httpServer = true; inherit apacheHttpd; };
  };

  apacheHttpdPackages_2_4 = dontRecurseIntoAttrs (apacheHttpdPackagesFor pkgs.apacheHttpd_2_4 pkgs.apacheHttpdPackages_2_4);
  apacheHttpdPackages = apacheHttpdPackages_2_4;

  appdaemon = callPackage ../servers/home-assistant/appdaemon.nix { };

  archiveopteryx = callPackage ../servers/mail/archiveopteryx { };

  atlassian-confluence = callPackage ../servers/atlassian/confluence.nix { };
  atlassian-crowd = callPackage ../servers/atlassian/crowd.nix { };
  atlassian-jira = callPackage ../servers/atlassian/jira.nix { };

  cadvisor = callPackage ../servers/monitoring/cadvisor { };

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

  apcupsd = callPackage ../servers/apcupsd { };

  inherit (callPackages ../servers/asterisk { })
    asterisk asterisk-stable asterisk-lts
    asterisk_13 asterisk_15 asterisk_16;

  sabnzbd = callPackage ../servers/sabnzbd { };

  bftpd = callPackage ../servers/ftp/bftpd {};

  bind = callPackage ../servers/dns/bind { };
  dnsutils = bind.dnsutils;

  inherit (callPackages ../servers/bird { })
    bird bird6 bird2;

  bosun = callPackage ../servers/monitoring/bosun { };

  cayley = callPackage ../servers/cayley { };

  charybdis = callPackage ../servers/irc/charybdis { };

  clamsmtp = callPackage ../servers/mail/clamsmtp { };

  clickhouse = callPackage ../servers/clickhouse {
    # clickhouse doesn't build on llvm8.
    inherit (llvmPackages_7) clang-unwrapped lld lldClang llvm;
  };

  couchdb = callPackage ../servers/http/couchdb {
    spidermonkey = spidermonkey_1_8_5;
    sphinx = python27Packages.sphinx;
    erlang = erlangR19;
  };

  couchdb2 = callPackage ../servers/http/couchdb/2.0.0.nix {
    spidermonkey = spidermonkey_1_8_5;
    erlang = erlangR21;
  };

  couchpotato = callPackage ../servers/couchpotato {};

  dex-oidc = callPackage ../servers/dex { };

  doh-proxy = callPackage ../servers/dns/doh-proxy {
    python3Packages = python36Packages;
  };

  dgraph = callPackage ../servers/dgraph { };

  dico = callPackage ../servers/dico { };

  dict = callPackage ../servers/dict {
    libmaa = callPackage ../servers/dict/libmaa.nix {};
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix {});

  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix {};

  diod = callPackage ../servers/diod { lua = lua5_1; };

  dkimproxy = callPackage ../servers/mail/dkimproxy { };

  do-agent = callPackage ../servers/monitoring/do-agent { };

  dodgy = with python3Packages; toPythonApplication dodgy;

  dovecot = callPackage ../servers/mail/dovecot { };
  dovecot_pigeonhole = callPackage ../servers/mail/dovecot/plugins/pigeonhole { };

  dspam = callPackage ../servers/mail/dspam { };

  etcd = callPackage ../servers/etcd { };

  ejabberd = callPackage ../servers/xmpp/ejabberd { };

  exhibitor = callPackage ../servers/exhibitor { };

  hyp = callPackage ../servers/http/hyp { };

  prosody = callPackage ../servers/xmpp/prosody {
    # _compat can probably be removed on next minor version after 0.10.0
    lua5 = lua5_2_compat;
    withExtraLibs = [ luaPackages.luadbi-sqlite3 ];
    inherit (lua52Packages) luasocket luasec luaexpat luafilesystem luabitop luaevent luadbi;
  };

  biboumi = callPackage ../servers/xmpp/biboumi { };

  elasticmq = callPackage ../servers/elasticmq { };

  elasticmq-server-bin = callPackage ../servers/elasticmq-server-bin { };

  eventstore = callPackage ../servers/nosql/eventstore {
    Nuget = dotnetPackages.Nuget;
  };

  exim = callPackage ../servers/mail/exim { };

  fcgiwrap = callPackage ../servers/fcgiwrap { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { icu = null; /*stdenv = gcc5Stdenv;*/ };
  firebirdSuper = firebird.override { icu = icu58; superServer = true; /*stdenv = gcc5Stdenv;*/ };

  frab = callPackage ../servers/web-apps/frab { };

  freepops = callPackage ../servers/mail/freepops { };

  freeradius = callPackage ../servers/freeradius { };

  freeswitch = callPackage ../servers/sip/freeswitch {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

  fusionInventory = callPackage ../servers/monitoring/fusion-inventory { };

  gatling = callPackage ../servers/http/gatling { };

  glabels = callPackage ../applications/graphics/glabels { };

  nats-server = callPackage ../servers/nats-server { };

  gofish = callPackage ../servers/gopher/gofish { };

  grafana = callPackage ../servers/monitoring/grafana { };

  grafana-loki = callPackage ../servers/monitoring/loki { };

  grafana_reporter = callPackage ../servers/monitoring/grafana-reporter { };

  gobetween = callPackage ../servers/gobetween {
    buildGoModule = buildGo112Module;
  };

  h2o = callPackage ../servers/http/h2o { };

  haka = callPackage ../tools/security/haka { };

  heapster = callPackage ../servers/monitoring/heapster { };

  hbase = callPackage ../servers/hbase {};

  headphones = callPackage ../servers/headphones {};

  hiawatha = callPackage ../servers/http/hiawatha {};

  home-assistant = callPackage ../servers/home-assistant { };

  home-assistant-cli = callPackage ../servers/home-assistant/cli.nix { };

  hydron = callPackage ../servers/hydron { };

  icingaweb2 = callPackage ../servers/icingaweb2 { };
  icingaweb2Modules = {
    theme-april = callPackage ../servers/icingaweb2/theme-april { };
    theme-lsd = callPackage ../servers/icingaweb2/theme-lsd { };
    theme-particles = callPackage ../servers/icingaweb2/theme-particles { };
    theme-snow = callPackage ../servers/icingaweb2/theme-snow { };
    theme-spring = callPackage ../servers/icingaweb2/theme-spring { };
  };

  imgproxy = callPackage ../servers/imgproxy { };

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  jetty = callPackage ../servers/http/jetty { };

  keycloak = callPackage ../servers/keycloak { };

  knot-dns = callPackage ../servers/dns/knot-dns { };
  knot-resolver = callPackage ../servers/dns/knot-resolver { };

  rdkafka = callPackage ../development/libraries/rdkafka { };

  leafnode = callPackage ../servers/news/leafnode { };

  lighttpd = callPackage ../servers/http/lighttpd { };

  livepeer = callPackage ../servers/livepeer { };

  lwan = callPackage ../servers/http/lwan { };

  labelImg = callPackage ../applications/science/machine-learning/labelimg { };

  mailman = callPackage ../servers/mail/mailman/wrapped.nix { };

  mailman-rss = callPackage ../development/python-modules/mailman-rss { };

  mailman-web = with (python3.override {
    packageOverrides = self: super: {
      django = self.django_1_11;
    };
  }).pkgs; toPythonApplication mailman-web;

  mattermost = callPackage ../servers/mattermost { };
  matterircd = callPackage ../servers/mattermost/matterircd.nix { };
  matterbridge = callPackage ../servers/matterbridge { };

  mattermost-desktop = callPackage ../applications/networking/instant-messengers/mattermost-desktop { };

  mediatomb = callPackage ../servers/mediatomb { };

  meguca = callPackage ../servers/meguca { };

  memcached = callPackage ../servers/memcached {};

  meteor = callPackage ../servers/meteor { };

  micronaut = callPackage ../development/tools/micronaut {};

  minio = callPackage ../servers/minio { };

  # Backwards compatibility.
  mod_dnssd = pkgs.apacheHttpdPackages.mod_dnssd;
  mod_fastcgi = pkgs.apacheHttpdPackages.mod_fastcgi;
  mod_python = pkgs.apacheHttpdPackages.mod_python;
  mod_wsgi = pkgs.apacheHttpdPackages.mod_wsgi;
  mod_ca = pkgs.apacheHttpdPackages.mod_ca;
  mod_crl = pkgs.apacheHttpdPackages.mod_crl;
  mod_csr = pkgs.apacheHttpdPackages.mod_csr;
  mod_ocsp = pkgs.apacheHttpdPackages.mod_ocsp;
  mod_scep = pkgs.apacheHttpdPackages.mod_scep;
  mod_spkac = pkgs.apacheHttpdPackages.mod_spkac;
  mod_pkcs12 = pkgs.apacheHttpdPackages.mod_pkcs12;
  mod_timestamp = pkgs.apacheHttpdPackages.mod_timestamp;

  inherit (callPackages ../servers/mpd { })
    mpd mpd-small mpdWithFeatures;

  mpd_clientlib = callPackage ../servers/mpd/clientlib.nix { };

  mpdscribble = callPackage ../tools/misc/mpdscribble { };

  mtprotoproxy = python3.pkgs.callPackage ../servers/mtprotoproxy { };

  micro-httpd = callPackage ../servers/http/micro-httpd { };

  miniHttpd = callPackage ../servers/http/mini-httpd {};

  mlflow-server = callPackage ../servers/mlflow-server { };

  mlmmj = callPackage ../servers/mail/mlmmj { };

  moodle = callPackage ../servers/web-apps/moodle { };

  morty = callPackage ../servers/web-apps/morty { };

  mullvad-vpn = callPackage ../applications/networking/mullvad-vpn { };

  mumsi = callPackage ../servers/mumsi { };

  myserver = callPackage ../servers/http/myserver { };

  nas = callPackage ../servers/nas { };

  nats-streaming-server = callPackage ../servers/nats-streaming-server { };

  neard = callPackage ../servers/neard { };

  unit = callPackage ../servers/http/unit {
    php72 = php72-unit;
    php73 = php73-unit;
  };

  nginx = nginxStable;

  nginxStable = callPackage ../servers/http/nginx/stable.nix {
    perl = null;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxMainline = callPackage ../servers/http/nginx/mainline.nix {
    perl = null;
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.dav nginxModules.moreheaders ];
  };

  nginxModules = callPackage ../servers/http/nginx/modules.nix { };

  # We should move to dynmaic modules and create a nginxFull package with all modules
  nginxShibboleth = nginxStable.override {
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders nginxModules.shibboleth ];
  };

  libmodsecurity = callPackage ../tools/security/libmodsecurity { };

  ngircd = callPackage ../servers/irc/ngircd { };

  nix-binary-cache = callPackage ../servers/http/nix-binary-cache {};

  nix-tour = callPackage ../applications/misc/nix-tour {};

  nsd = callPackage ../servers/dns/nsd (config.nsd or {});

  nsq = callPackage ../servers/nsq { };

  oauth2_proxy = callPackage ../servers/oauth2_proxy { };

  openafs = callPackage ../servers/openafs/1.6 { tsmbac = null; ncurses = null; };
  openafs_1_8 = callPackage ../servers/openafs/1.8 { tsmbac = null; ncurses = null; };

  openresty = callPackage ../servers/http/openresty { };

  opensmtpd = callPackage ../servers/mail/opensmtpd { };
  opensmtpd-extras = callPackage ../servers/mail/opensmtpd/extras.nix { };

  openxpki = callPackage ../servers/openxpki { };

  openxr-loader = callPackage ../development/libraries/openxr-loader { };

  osrm-backend = callPackage ../servers/osrm-backend { };

  p910nd = callPackage ../servers/p910nd { };

  petidomo = callPackage ../servers/mail/petidomo { };

  popa3d = callPackage ../servers/mail/popa3d { };

  postfix = callPackage ../servers/mail/postfix { };

  postsrsd = callPackage ../servers/mail/postsrsd { };

  rspamd = callPackage ../servers/mail/rspamd { };

  pfixtools = callPackage ../servers/mail/postfix/pfixtools.nix {
    gperf = gperf_3_0;
  };
  pflogsumm = callPackage ../servers/mail/postfix/pflogsumm.nix { };

  postgrey = callPackage ../servers/mail/postgrey { };

  pshs = callPackage ../servers/http/pshs { };

  sympa = callPackage ../servers/mail/sympa { };

  system-sendmail = lowPrio (callPackage ../servers/mail/system-sendmail { });

  # PulseAudio daemons

  pulseaudio = callPackage ../servers/pulseaudio {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  qpaeq = qt5.callPackage ../servers/pulseaudio/qpaeq.nix { };

  pulseaudioFull = pulseaudio.override {
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  # libpulse implementations
  libpulseaudio-vanilla = pulseaudio.override {
    libOnly = true;
  };

  apulse = callPackage ../misc/apulse { };

  libpressureaudio = callPackage ../misc/apulse/pressureaudio.nix {
    libpulseaudio = libpulseaudio-vanilla; # headers only
  };

  libcardiacarrest = callPackage ../misc/libcardiacarrest {
    libpulseaudio = libpulseaudio-vanilla; # meta only
  };

  libpulseaudio = libpulseaudio-vanilla;

  pulseeffects = callPackage ../applications/audio/pulseeffects { };

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  pies = callPackage ../servers/pies { };

  rpcbind = callPackage ../servers/rpcbind { };

  libmysqlclient = libmysqlclient_3_1;
  libmysqlclient_3_1 = mariadb-connector-c_3_1;
  mariadb-connector-c = mariadb-connector-c_3_1;
  mariadb-connector-c_3_1 = callPackage ../servers/sql/mariadb/connector-c/3_1.nix { };

  mariadb-galera = mariadb-galera_25;
  mariadb-galera_25 = callPackage ../servers/sql/mariadb/galera/25.nix {
    asio = asio_1_10;
  };

  mariadb = callPackage ../servers/sql/mariadb {
    # As per mariadb's cmake, "static jemalloc_pic.a can only be used up to jemalloc 4".
    # https://jira.mariadb.org/browse/MDEV-15034
    jemalloc = jemalloc450.override ({ disableInitExecTls = true; });
    inherit (darwin) cctools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };
  mysql = mariadb; # TODO: move to aliases.nix

  mongodb = hiPrio mongodb-3_4;

  mongodb-3_4 = callPackage ../servers/nosql/mongodb/v3_4.nix {
    sasl = cyrus_sasl;
    boost = boost160;
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  mongodb-3_6 = callPackage ../servers/nosql/mongodb/v3_6.nix {
    sasl = cyrus_sasl;
    boost = boost160;
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  mongodb-4_0 = callPackage ../servers/nosql/mongodb/v4_0.nix {
    sasl = cyrus_sasl;
    boost = boost169;
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  nginx-sso = callPackage ../servers/nginx-sso { };

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

  influxdb = callPackage ../servers/nosql/influxdb { };

  mysql57 = callPackage ../servers/sql/mysql/5.7.x.nix {
    inherit (darwin) cctools developer_cmds;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    boost = boost159;
  };

  mysql80 = callPackage ../servers/sql/mysql/8.0.x.nix {
    inherit (darwin) cctools developer_cmds;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    boost = boost169; # Configure checks for specific version.
  };

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  mssql_jdbc = callPackage ../servers/sql/mssql/jdbc { };

  miniflux = callPackage ../servers/miniflux { };

  nagios = callPackage ../servers/monitoring/nagios { };

  munin = callPackage ../servers/monitoring/munin { };

  monitoring-plugins = callPackage ../servers/monitoring/plugins { };

  inherit (callPackage ../servers/monitoring/plugins/labs_consol_de.nix { })
    check-mssql-health
    check-nwc-health
    check-ups-health;

  check-openvpn = callPackage ../servers/monitoring/plugins/openvpn.nix { };

  checkSSLCert = callPackage ../servers/monitoring/nagios/plugins/check_ssl_cert.nix { };

  pynagsystemd = callPackage ../servers/monitoring/nagios/plugins/pynagsystemd.nix { };

  neo4j = callPackage ../servers/nosql/neo4j { };

  check-esxi-hardware = callPackage ../servers/monitoring/plugins/esxi.nix {};

  net-snmp = callPackage ../servers/monitoring/net-snmp { };

  newrelic-sysmond = callPackage ../servers/monitoring/newrelic-sysmond { };

  nullidentdmod = callPackage ../servers/identd/nullidentdmod {};

  riemann = callPackage ../servers/monitoring/riemann { };
  riemann-dash = callPackage ../servers/monitoring/riemann-dash { };

  unpfs = callPackage ../servers/unpfs {};

  oidentd = callPackage ../servers/identd/oidentd { };

  openfire = callPackage ../servers/xmpp/openfire { };

  oracleXE = callPackage ../servers/sql/oracle-xe { };

  softether_4_25 = callPackage ../servers/softether/4.25.nix { openssl = openssl_1_0_2; };
  softether_4_29 = callPackage ../servers/softether/4.29.nix { };
  softether = softether_4_29;

  qboot = pkgsi686Linux.callPackage ../applications/virtualization/qboot { };

  OVMF = callPackage ../applications/virtualization/OVMF { };
  OVMF-CSM = OVMF.override { csmSupport = true; };
  OVMF-secureBoot = OVMF.override { secureBoot = true; };

  seabios = callPackage ../applications/virtualization/seabios { };

  vmfs-tools = callPackage ../tools/filesystems/vmfs-tools { };

  patroni = callPackage ../servers/sql/patroni { pythonPackages = python3Packages; };

  pgbouncer = callPackage ../servers/sql/pgbouncer { };

  pgpool = callPackage ../servers/sql/pgpool {
    pam = if stdenv.isLinux then pam else null;
    libmemcached = null; # Detection is broken upstream
  };

  tang = callPackage ../servers/tang {
    asciidoc = asciidoc-full;
  };

  timescaledb-parallel-copy = callPackage ../development/tools/database/timescaledb-parallel-copy { };

  timescaledb-tune = callPackage ../development/tools/database/timescaledb-tune { };

  inherit (import ../servers/sql/postgresql pkgs)
    postgresql_9_5
    postgresql_9_6
    postgresql_10
    postgresql_11
    postgresql_12
  ;
  postgresql = postgresql_11.override { this = postgresql; };
  postgresqlPackages = recurseIntoAttrs postgresql.pkgs;
  postgresql11Packages = pkgs.postgresqlPackages;

  postgresql_jdbc = callPackage ../development/java-modules/postgresql_jdbc { };

  prom2json = callPackage ../servers/monitoring/prometheus/prom2json.nix { };
  prometheus = callPackage ../servers/monitoring/prometheus { };
  prometheus-alertmanager = callPackage ../servers/monitoring/prometheus/alertmanager.nix { };
  prometheus-apcupsd-exporter = callPackage ../servers/monitoring/prometheus/apcupsd-exporter.nix { };
  prometheus-aws-s3-exporter = callPackage ../servers/monitoring/prometheus/aws-s3-exporter.nix { };
  prometheus-bind-exporter = callPackage ../servers/monitoring/prometheus/bind-exporter.nix { };
  prometheus-blackbox-exporter = callPackage ../servers/monitoring/prometheus/blackbox-exporter.nix { };
  prometheus-collectd-exporter = callPackage ../servers/monitoring/prometheus/collectd-exporter.nix { };
  prometheus-cups-exporter = callPackage ../servers/monitoring/prometheus/cups-exporter.nix { };
  prometheus-consul-exporter = callPackage ../servers/monitoring/prometheus/consul-exporter.nix { };
  prometheus-dnsmasq-exporter = callPackage ../servers/monitoring/prometheus/dnsmasq-exporter.nix { };
  prometheus-dovecot-exporter = callPackage ../servers/monitoring/prometheus/dovecot-exporter.nix { };
  prometheus-fritzbox-exporter = callPackage ../servers/monitoring/prometheus/fritzbox-exporter.nix { };
  prometheus-gitlab-ci-pipelines-exporter = callPackage ../servers/monitoring/prometheus/gitlab-ci-pipelines-exporter.nix { };
  prometheus-haproxy-exporter = callPackage ../servers/monitoring/prometheus/haproxy-exporter.nix { };
  prometheus-json-exporter = callPackage ../servers/monitoring/prometheus/json-exporter.nix { };
  prometheus-mail-exporter = callPackage ../servers/monitoring/prometheus/mail-exporter.nix { };
  prometheus-mesos-exporter = callPackage ../servers/monitoring/prometheus/mesos-exporter.nix { };
  prometheus-mikrotik-exporter = callPackage ../servers/monitoring/prometheus/mikrotik-exporter.nix { };
  prometheus-minio-exporter = callPackage ../servers/monitoring/prometheus/minio-exporter { };
  prometheus-mysqld-exporter = callPackage ../servers/monitoring/prometheus/mysqld-exporter.nix { };
  prometheus-nextcloud-exporter = callPackage ../servers/monitoring/prometheus/nextcloud-exporter.nix { };
  prometheus-nginx-exporter = callPackage ../servers/monitoring/prometheus/nginx-exporter.nix { };
  prometheus-nginxlog-exporter = callPackage ../servers/monitoring/prometheus/nginxlog-exporter.nix { };
  prometheus-node-exporter = callPackage ../servers/monitoring/prometheus/node-exporter.nix { };
  prometheus-openvpn-exporter = callPackage ../servers/monitoring/prometheus/openvpn-exporter.nix { };
  prometheus-postfix-exporter = callPackage ../servers/monitoring/prometheus/postfix-exporter.nix { };
  prometheus-postgres-exporter = callPackage ../servers/monitoring/prometheus/postgres-exporter.nix { };
  prometheus-process-exporter = callPackage ../servers/monitoring/prometheus/process-exporter.nix { };
  prometheus-pushgateway = callPackage ../servers/monitoring/prometheus/pushgateway.nix { };
  prometheus-rabbitmq-exporter = callPackage ../servers/monitoring/prometheus/rabbitmq-exporter.nix { };
  prometheus-snmp-exporter = callPackage ../servers/monitoring/prometheus/snmp-exporter.nix { };
  prometheus-tor-exporter = callPackage ../servers/monitoring/prometheus/tor-exporter.nix { };
  prometheus-statsd-exporter = callPackage ../servers/monitoring/prometheus/statsd-exporter.nix { };
  prometheus-surfboard-exporter = callPackage ../servers/monitoring/prometheus/surfboard-exporter.nix { };
  prometheus-unifi-exporter = callPackage ../servers/monitoring/prometheus/unifi-exporter { };
  prometheus-varnish-exporter = callPackage ../servers/monitoring/prometheus/varnish-exporter.nix {
    # Version 1.5.1 fails to build with go 1.13 due to test failure
    #  FAIL       github.com/jonnenauha/prometheus_varnish_exporter       0.041s
    buildGoModule = buildGo112Module;
  };
  prometheus-jmx-httpserver = callPackage ../servers/monitoring/prometheus/jmx-httpserver.nix {  };
  prometheus-wireguard-exporter = callPackage ../servers/monitoring/prometheus/wireguard-exporter.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  prometheus-xmpp-alerts = callPackage ../servers/monitoring/prometheus/xmpp-alerts.nix {
    pythonPackages = python3Packages;
  };

  prometheus-cpp = callPackage ../development/libraries/prometheus-cpp { };

  psqlodbc = callPackage ../development/libraries/psqlodbc { };

  public-inbox = perlPackages.callPackage ../servers/mail/public-inbox { };

  pure-ftpd = callPackage ../servers/ftp/pure-ftpd { };

  pyIRCt = callPackage ../servers/xmpp/pyIRCt {};

  pyMAILt = callPackage ../servers/xmpp/pyMAILt {};

  pypolicyd-spf = python3.pkgs.callPackage ../servers/mail/pypolicyd-spf { };

  qpid-cpp = callPackage ../servers/amqp/qpid-cpp {
    boost = boost155;
    inherit (pythonPackages) buildPythonPackage qpid-python;
  };

  qremotecontrol-server = callPackage ../servers/misc/qremotecontrol-server { };

  quagga = callPackage ../servers/quagga { };

  rabbitmq-server = callPackage ../servers/amqp/rabbitmq-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon Cocoa;
    elixir = elixir_1_8;
    erlang = erlang_nox;
  };

  radicale1 = callPackage ../servers/radicale/1.x.nix { };
  radicale2 = callPackage ../servers/radicale { };

  radicale = radicale2;

  rake = callPackage ../development/tools/build-managers/rake { };

  redis = callPackage ../servers/nosql/redis { };

  redstore = callPackage ../servers/http/redstore { };

  restic = callPackage ../tools/backup/restic { };

  restic-rest-server = callPackage ../tools/backup/restic/rest-server.nix { };

  restya-board = callPackage ../servers/web-apps/restya-board { };

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    libtool = darwin.cctools;
  };

  rippled = callPackage ../servers/rippled {
    boost = boost17x;
  };

  rippled-validator-keys-tool = callPackage ../servers/rippled/validator-keys-tool.nix {
    boost = boost167.override {
      enableStatic = true;
    };
  };

  roon-server = callPackage ../servers/roon-server { };

  s6 = skawarePackages.s6;

  s6-rc = skawarePackages.s6-rc;

  supervise = callPackage ../tools/system/supervise { };

  spamassassin = callPackage ../servers/mail/spamassassin { };

  deadpixi-sam-unstable = callPackage ../applications/editors/deadpixi-sam { };

  samba4 = callPackage ../servers/samba/4.x.nix {
    rpcgen = netbsd.rpcgen;
    python = python3;
  };

  samba = samba4;

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

  sampler = callPackage ../applications/misc/sampler { };

  shairplay = callPackage ../servers/shairplay { avahi = avahi-compat; };

  shairport-sync = callPackage ../servers/shairport-sync { };

  showoff = callPackage ../servers/http/showoff {};

  serfdom = callPackage ../servers/serf { };

  seyren = callPackage ../servers/monitoring/seyren { };

  ruby-zoom = callPackage ../tools/text/ruby-zoom { };

  sensu = callPackage ../servers/monitoring/sensu { };

  inherit (callPackages ../servers/monitoring/sensu-go { })
    sensu-go-agent
    sensu-go-backend
    sensu-go-cli;

  check-wmiplus = callPackage ../servers/monitoring/plugins/wmiplus { };

  uchiwa = callPackage ../servers/monitoring/uchiwa { };

  shishi = callPackage ../servers/shishi {
      pam = if stdenv.isLinux then pam else null;
      # see also openssl, which has/had this same trick
  };

  sickbeard = callPackage ../servers/sickbeard { };

  sickgear = callPackage ../servers/sickbeard/sickgear.nix { };

  sickrage = callPackage ../servers/sickbeard/sickrage.nix { };

  sipwitch = callPackage ../servers/sip/sipwitch { };

  slimserver = callPackage ../servers/slimserver { };

  smcroute = callPackage ../servers/smcroute { };

  spawn_fcgi = callPackage ../servers/http/spawn-fcgi { };

  spring-boot = callPackage ../development/tools/spring-boot { };

  squid = callPackage ../servers/squid { };

  sslh = callPackage ../servers/sslh { };

  thttpd = callPackage ../servers/http/thttpd { };

  storm = callPackage ../servers/computing/storm { };

  slurm = callPackage ../servers/computing/slurm { gtk2 = null; };

  slurm-spank-x11 = callPackage ../servers/computing/slurm-spank-x11 { };

  systemd-journal2gelf = callPackage ../tools/system/systemd-journal2gelf { };

  syncserver = callPackage ../servers/syncserver { };

  tailscale = callPackage ../servers/tailscale { };

  thanos = callPackage ../servers/monitoring/thanos { };

  inherit (callPackages ../servers/http/tomcat { })
    tomcat7
    tomcat8
    tomcat9;

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  torque = callPackage ../servers/computing/torque { };

  tt-rss = callPackage ../servers/tt-rss { };
  tt-rss-plugin-ff-instagram = callPackage ../servers/tt-rss/plugin-ff-instagram { };
  tt-rss-plugin-tumblr-gdpr = callPackage ../servers/tt-rss/plugin-tumblr-gdpr { };
  tt-rss-plugin-auth-ldap = callPackage ../servers/tt-rss/plugin-auth-ldap { };
  tt-rss-theme-feedly = callPackage ../servers/tt-rss/theme-feedly { };

  searx = callPackage ../servers/web-apps/searx { };

  selfoss = callPackage ../servers/web-apps/selfoss { };

  shaarli = callPackage ../servers/web-apps/shaarli { };

  shaarli-material = callPackage ../servers/web-apps/shaarli/material-theme.nix { };

  shiori = callPackage ../servers/web-apps/shiori { };

  inherit (callPackages ../servers/web-apps/matomo {})
    matomo
    matomo-beta;

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  inherit (callPackages ../servers/unifi { })
    unifiLTS
    unifiStable;
  unifi = unifiStable;

  victoriametrics = callPackage ../servers/nosql/victoriametrics { };

  virtlyst = libsForQt5.callPackage ../servers/web-apps/virtlyst { };

  virtuoso6 = callPackage ../servers/sql/virtuoso/6.x.nix {
    openssl = openssl_1_0_2;
  };

  virtuoso7 = callPackage ../servers/sql/virtuoso/7.x.nix {
    openssl = openssl_1_0_2;
  };

  virtuoso = virtuoso6;

  vsftpd = callPackage ../servers/ftp/vsftpd { };

  wallabag = callPackage ../servers/web-apps/wallabag { };

  webmetro = callPackage ../servers/webmetro { };

  webhook = callPackage ../servers/http/webhook { };

  winstone = throw "Winstone is not supported anymore. Alternatives are Jetty or Tomcat.";

  xinetd = callPackage ../servers/xinetd { };

  zookeeper = callPackage ../servers/zookeeper { };

  zookeeper_mt = callPackage ../development/libraries/zookeeper_mt { };

  xqilla = callPackage ../development/tools/xqilla { };

  xquartz = callPackage ../servers/x11/xquartz { };

  quartz-wm = callPackage ../servers/x11/quartz-wm {
    stdenv = clangStdenv;
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

  # Use `lib.callPackageWith __splicedPackages` rather than plain `callPackage`
  # so as not to have the newly bound xorg items already in scope,  which would
  # have created a cycle.
  xorg = recurseIntoAttrs ((lib.callPackageWith __splicedPackages ../servers/x11/xorg {
  }).overrideScope' (lib.callPackageWith __splicedPackages ../servers/x11/xorg/overrides.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa;
    inherit (darwin.apple_sdk.libs) Xplugin;
    inherit (buildPackages.darwin) bootstrap_cmds;
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

  zabbixFor = version: rec {
    agent = (callPackages ../servers/monitoring/zabbix/agent.nix {}).${version};
    proxy-mysql = (callPackages ../servers/monitoring/zabbix/proxy.nix { mysqlSupport = true; }).${version};
    proxy-pgsql = (callPackages ../servers/monitoring/zabbix/proxy.nix { postgresqlSupport = true; }).${version};
    proxy-sqlite = (callPackages ../servers/monitoring/zabbix/proxy.nix { sqliteSupport = true; }).${version};
    server-mysql = (callPackages ../servers/monitoring/zabbix/server.nix { mysqlSupport = true; }).${version};
    server-pgsql = (callPackages ../servers/monitoring/zabbix/server.nix { postgresqlSupport = true; }).${version};
    web = (callPackages ../servers/monitoring/zabbix/web.nix {}).${version};

    # backwards compatibility
    server = server-pgsql;
  };

  zabbix44 = recurseIntoAttrs (zabbixFor "v44");
  zabbix40 = dontRecurseIntoAttrs (zabbixFor "v40");
  zabbix30 = dontRecurseIntoAttrs (zabbixFor "v30");

  zabbix = zabbix44;

  zipkin = callPackage ../servers/monitoring/zipkin { };

  ### OS-SPECIFIC

  afuse = callPackage ../os-specific/linux/afuse { };

  autofs5 = callPackage ../os-specific/linux/autofs { };

  _915resolution = callPackage ../os-specific/linux/915resolution { };

  nfs-utils = callPackage ../os-specific/linux/nfs-utils { };

  acpi = callPackage ../os-specific/linux/acpi { };

  acpid = callPackage ../os-specific/linux/acpid { };

  acpitool = callPackage ../os-specific/linux/acpitool { };

  alfred = callPackage ../os-specific/linux/batman-adv/alfred.nix { };

  alertmanager-bot = callPackage ../servers/monitoring/alertmanager-bot { };

  alsa-firmware = callPackage ../os-specific/linux/alsa-firmware { };

  alsaLib = callPackage ../os-specific/linux/alsa-lib { };

  alsaPlugins = callPackage ../os-specific/linux/alsa-plugins { };

  alsaPluginWrapper = callPackage ../os-specific/linux/alsa-plugins/wrapper.nix { };

  alsaUtils = callPackage ../os-specific/linux/alsa-utils { };
  alsaOss = callPackage ../os-specific/linux/alsa-oss { };
  alsaTools = callPackage ../os-specific/linux/alsa-tools { };

  inherit (callPackage ../misc/arm-trusted-firmware {})
    buildArmTrustedFirmware
    armTrustedFirmwareTools
    armTrustedFirmwareAllwinner
    armTrustedFirmwareQemu
    armTrustedFirmwareRK3328
    armTrustedFirmwareRK3399
    armTrustedFirmwareS905
    ;

  microcodeAmd = callPackage ../os-specific/linux/microcode/amd.nix { };

  microcodeIntel = callPackage ../os-specific/linux/microcode/intel.nix { };

  iucode-tool = callPackage ../os-specific/linux/microcode/iucode-tool.nix { };

  inherit (callPackages ../os-specific/linux/apparmor { python = python3; })
    libapparmor apparmor-utils apparmor-bin-utils apparmor-parser apparmor-pam
    apparmor-profiles apparmor-kernel-patches;

  atop = callPackage ../os-specific/linux/atop { };

  audit = callPackage ../os-specific/linux/audit { };

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43Firmware_6_30_163_46 = callPackage ../os-specific/linux/firmware/b43-firmware/6.30.163.46.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  bt-fw-converter = callPackage ../os-specific/linux/firmware/bt-fw-converter { };

  brillo = callPackage ../os-specific/linux/brillo { };

  broadcom-bt-firmware = callPackage ../os-specific/linux/firmware/broadcom-bt-firmware { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  blktrace = callPackage ../os-specific/linux/blktrace { };

  bluez5 = callPackage ../os-specific/linux/bluez { };

  pulseaudio-modules-bt = callPackage ../applications/audio/pulseaudio-modules-bt {
    # pulseaudio-modules-bt is most likely to be used with pulseaudioFull
    pulseaudio = pulseaudioFull;
  };

  bluez = bluez5;

  inherit (python3Packages) bedup;

  bolt = callPackage ../os-specific/linux/bolt { };

  bridge-utils = callPackage ../os-specific/linux/bridge-utils { };

  busybox = callPackage ../os-specific/linux/busybox { };
  busybox-sandbox-shell = callPackage ../os-specific/linux/busybox/sandbox-shell.nix {
    # musl roadmap has RISC-V support projected for 1.1.20
    busybox = if !stdenv.hostPlatform.isRiscV && stdenv.hostPlatform.libc != "bionic"
              then pkgsStatic.busybox
              else busybox;
  };

  cachefilesd = callPackage ../os-specific/linux/cachefilesd { };

  cgmanager = callPackage ../os-specific/linux/cgmanager { };

  checkpolicy = callPackage ../os-specific/linux/checkpolicy { };

  checksec = callPackage ../os-specific/linux/checksec { };

  cifs-utils = callPackage ../os-specific/linux/cifs-utils { };

  cpustat = callPackage ../os-specific/linux/cpustat { };

  cockroachdb = callPackage ../servers/sql/cockroachdb {
    buildGoPackage = buildGo112Package;
  };

  conky = callPackage ../os-specific/linux/conky ({
    lua = lua5_3_compat;
    inherit (linuxPackages.nvidia_x11.settings) libXNVCtrl;
  } // config.conky or {});

  conntrack-tools = callPackage ../os-specific/linux/conntrack-tools { };

  coredns = callPackage ../servers/dns/coredns { };

  corerad = callPackage ../tools/networking/corerad { };

  cpufrequtils = callPackage ../os-specific/linux/cpufrequtils { };

  cpuset = callPackage ../os-specific/linux/cpuset { };

  criu = callPackage ../os-specific/linux/criu { };

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  cramfsswap = callPackage ../os-specific/linux/cramfsswap { };

  crda = callPackage ../os-specific/linux/crda { };

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

  dmidecode = callPackage ../os-specific/linux/dmidecode { };

  dmtcp = callPackage ../os-specific/linux/dmtcp { };

  directvnc = callPackage ../os-specific/linux/directvnc { };

  dmraid = callPackage ../os-specific/linux/dmraid {
    lvm2 = lvm2.override {enable_dmeventd = true;};
  };

  drbd = callPackage ../os-specific/linux/drbd { };

  dropwatch = callPackage ../os-specific/linux/dropwatch { };

  dstat = callPackage ../os-specific/linux/dstat { };

  # unstable until the first 1.x release
  fscrypt-experimental = callPackage ../os-specific/linux/fscrypt { };
  fscryptctl-experimental = callPackage ../os-specific/linux/fscryptctl { };

  fwupd = callPackage ../os-specific/linux/firmware/fwupd { };

  fwupdate = callPackage ../os-specific/linux/firmware/fwupdate { };

  fwts = callPackage ../os-specific/linux/fwts { };

  libossp_uuid = callPackage ../development/libraries/libossp-uuid { };

  libuuid = if stdenv.isLinux
    then utillinuxMinimal
    else null;

  light = callPackage ../os-specific/linux/light { };

  lightum = callPackage ../os-specific/linux/lightum { };

  ebtables = callPackage ../os-specific/linux/ebtables { };

  extrace = callPackage ../os-specific/linux/extrace { };

  facetimehd-firmware = callPackage ../os-specific/linux/firmware/facetimehd-firmware { };

  fatrace = callPackage ../os-specific/linux/fatrace { };

  ffado = libsForQt5.callPackage ../os-specific/linux/ffado {
    inherit (pkgs.linuxPackages) kernel;
  };
  libffado = ffado;

  fbterm = callPackage ../os-specific/linux/fbterm { };

  firejail = callPackage ../os-specific/linux/firejail {};

  fnotifystat = callPackage ../os-specific/linux/fnotifystat { };

  forkstat = callPackage ../os-specific/linux/forkstat { };

  freefall = callPackage ../os-specific/linux/freefall {
    inherit (linuxPackages) kernel;
  };

  fusePackages = dontRecurseIntoAttrs (callPackage ../os-specific/linux/fuse {
    utillinux = utillinuxMinimal;
  });
  fuse = lowPrio fusePackages.fuse_2;
  fuse3 = fusePackages.fuse_3;
  fuse-common = hiPrio fusePackages.fuse_3.common;

  fxload = callPackage ../os-specific/linux/fxload { };

  gfxtablet = callPackage ../os-specific/linux/gfxtablet {};

  gmailieer = callPackage ../applications/networking/gmailieer {};

  gpm = callPackage ../servers/gpm {
    ncurses = null;  # Keep curses disabled for lack of value
  };

  gpm-ncurses = gpm.override { inherit ncurses; };

  gpu-switch = callPackage ../os-specific/linux/gpu-switch { };

  gradm = callPackage ../os-specific/linux/gradm { };

  inherit (nodePackages) gtop;

  hd-idle = callPackage ../os-specific/linux/hd-idle { };

  hdparm = callPackage ../os-specific/linux/hdparm { };

  health-check = callPackage ../os-specific/linux/health-check { };

  hibernate = callPackage ../os-specific/linux/hibernate { };

  hostapd = callPackage ../os-specific/linux/hostapd { };

  htop = callPackage ../tools/system/htop {
    inherit (darwin) IOKit;
  };

  nmon = callPackage ../os-specific/linux/nmon { };

  hwdata = callPackage ../os-specific/linux/hwdata { };

  i7z = qt5.callPackage ../os-specific/linux/i7z { };

  pcm = callPackage ../os-specific/linux/pcm { };

  ima-evm-utils = callPackage ../os-specific/linux/ima-evm-utils {
    openssl = openssl_1_0_2;
  };

  intel2200BGFirmware = callPackage ../os-specific/linux/firmware/intel2200BGFirmware { };

  intel-compute-runtime = callPackage ../os-specific/linux/intel-compute-runtime { };

  intel-ocl = callPackage ../os-specific/linux/intel-ocl { };

  iomelt = callPackage ../os-specific/linux/iomelt { };

  iotop = callPackage ../os-specific/linux/iotop { };

  iproute = callPackage ../os-specific/linux/iproute { };

  iproute_mptcp = callPackage ../os-specific/linux/iproute/mptcp.nix { };

  iputils = hiPrio (callPackage ../os-specific/linux/iputils { });
  # hiPrio for collisions with inetutils (ping and tftpd.8.gz)

  iptables = iptables-legacy;
  iptables-legacy = callPackage ../os-specific/linux/iptables { };
  iptables-nftables-compat = callPackage ../os-specific/linux/iptables { nftablesCompat = true; };

  iptstate = callPackage ../os-specific/linux/iptstate { } ;

  ipset = callPackage ../os-specific/linux/ipset { };

  irqbalance = callPackage ../os-specific/linux/irqbalance { };

  iw = callPackage ../os-specific/linux/iw { };

  iwd = callPackage ../os-specific/linux/iwd { };

  jfbview = callPackage ../os-specific/linux/jfbview { };
  jfbpdf = jfbview.override {
    imageSupport = false;
  };

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  jujuutils = callPackage ../os-specific/linux/jujuutils { };

  kbd = callPackage ../os-specific/linux/kbd { };

  kbdKeymaps = callPackage ../os-specific/linux/kbd/keymaps.nix { };

  kbdlight = callPackage ../os-specific/linux/kbdlight { };

  kmscon = callPackage ../os-specific/linux/kmscon { };

  kmscube = callPackage ../os-specific/linux/kmscube { };

  kmsxx = callPackage ../development/libraries/kmsxx { };

  latencytop = callPackage ../os-specific/linux/latencytop { };

  ldm = callPackage ../os-specific/linux/ldm { };

  libaio = callPackage ../os-specific/linux/libaio { };

  libargon2 = callPackage ../development/libraries/libargon2 { };

  libatasmart = callPackage ../os-specific/linux/libatasmart { };

  libcgroup = callPackage ../os-specific/linux/libcgroup { };

  libnl = callPackage ../os-specific/linux/libnl { };

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  openelec-dvb-firmware = callPackage ../os-specific/linux/firmware/openelec-dvb-firmware { };

  openiscsi = callPackage ../os-specific/linux/open-iscsi { };

  openisns = callPackage ../os-specific/linux/open-isns { };

  osxfuse = callPackage ../os-specific/darwin/osxfuse { };

  osxsnarf = callPackage ../os-specific/darwin/osxsnarf { };

  power-calibrate = callPackage ../os-specific/linux/power-calibrate { };

  powerstat = callPackage ../os-specific/linux/powerstat { };

  smemstat = callPackage ../os-specific/linux/smemstat { };

  tgt = callPackage ../tools/networking/tgt { };

  # -- Linux kernel expressions ------------------------------------------------

  lkl = callPackage ../applications/virtualization/lkl { };

  inherit (callPackages ../os-specific/linux/kernel-headers { })
    linuxHeaders;

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  klibc = callPackage ../os-specific/linux/klibc { };

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  linux_mptcp = linux_mptcp_95;

  linux_mptcp_94 = callPackage ../os-specific/linux/kernel/linux-mptcp-94.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ]
      ++ lib.optionals ((stdenv.hostPlatform.platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_mptcp_95 = callPackage ../os-specific/linux/kernel/linux-mptcp-95.nix {
    kernelPatches = linux_4_19.kernelPatches;
  };

  linux_rpi1 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 1;
  };

  linux_rpi2 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 2;
  };

  linux_rpi3 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 3;
  };

  linux_rpi4 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
    rpiVersion = 4;
  };

  linux_4_4 = callPackage ../os-specific/linux/kernel/linux-4.4.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper_updated
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
        kernelPatches.request_key_helper_updated
        kernelPatches.cpu-cgroup-v2."4.9"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_4_14 = callPackage ../os-specific/linux/kernel/linux-4.14.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
        kernelPatches.export_kernel_fpu_functions."4.14"
      ];
  };

  linux_4_19 = callPackage ../os-specific/linux/kernel/linux-4.19.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.modinst_arg_list_too_long
        kernelPatches.export_kernel_fpu_functions."4.14"
      ];
  };

  linux_5_4 = callPackage ../os-specific/linux/kernel/linux-5.4.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.request_key_helper
      kernelPatches.export_kernel_fpu_functions."5.3"
    ];
  };

  linux_5_5 = callPackage ../os-specific/linux/kernel/linux-5.5.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.request_key_helper
      kernelPatches.export_kernel_fpu_functions."5.3"
    ];
  };

  linux_5_6 = callPackage ../os-specific/linux/kernel/linux-5.6.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.request_key_helper
      kernelPatches.export_kernel_fpu_functions."5.3"
    ];
  };

  linux_testing = callPackage ../os-specific/linux/kernel/linux-testing.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.request_key_helper
    ];
  };

  linux_testing_bcachefs = callPackage ../os-specific/linux/kernel/linux-testing-bcachefs.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linux_hardkernel_4_14 = callPackage ../os-specific/linux/kernel/linux-hardkernel-4.14.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.request_key_helper
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

    anbox = callPackage ../os-specific/linux/anbox/kmod.nix { };

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bcc = callPackage ../os-specific/linux/bcc {
      python = python3;
    };

    bpftrace = callPackage ../os-specific/linux/bpftrace { };

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    chipsec = callPackage ../tools/security/chipsec {
      inherit kernel;
      withDriver = true;
    };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    ddcci-driver = callPackage ../os-specific/linux/ddcci { };

    deepin-anything = callPackage ../os-specific/linux/deepin-anything { };

    digimend = callPackage ../os-specific/linux/digimend { };

    dpdk = callPackage ../os-specific/linux/dpdk { };

    exfat-nofuse = callPackage ../os-specific/linux/exfat { };

    evdi = callPackage ../os-specific/linux/evdi { };

    fwts-efi-runtime = callPackage ../os-specific/linux/fwts/module.nix { };

    hyperv-daemons = callPackage ../os-specific/linux/hyperv-daemons { };

    e1000e = if stdenv.lib.versionOlder kernel.version "4.10" then  callPackage ../os-specific/linux/e1000e {} else null;

    intel-speed-select = if stdenv.lib.versionAtLeast kernel.version "5.3" then callPackage ../os-specific/linux/intel-speed-select { } else null;

    ixgbevf = callPackage ../os-specific/linux/ixgbevf {};

    it87 = callPackage ../os-specific/linux/it87 {};

    asus-wmi-sensors = callPackage ../os-specific/linux/asus-wmi-sensors {};

    ena = callPackage ../os-specific/linux/ena {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta { };

    tbs = callPackage ../os-specific/linux/tbs { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidiaPackages = dontRecurseIntoAttrs (callPackage ../os-specific/linux/nvidia-x11 { });

    nvidia_x11_legacy304 = nvidiaPackages.legacy_304;
    nvidia_x11_legacy340 = nvidiaPackages.legacy_340;
    nvidia_x11_legacy390 = nvidiaPackages.legacy_390;
    nvidia_x11_beta      = nvidiaPackages.beta;
    nvidia_x11           = nvidiaPackages.stable;

    openrazer = callPackage ../os-specific/linux/openrazer/driver.nix { };

    ply = callPackage ../os-specific/linux/ply { };

    r8125 = callPackage ../os-specific/linux/r8125 { };

    r8168 = callPackage ../os-specific/linux/r8168 { };

    rtl8192eu = callPackage ../os-specific/linux/rtl8192eu { };

    rtl8723bs = callPackage ../os-specific/linux/rtl8723bs { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    rtl8814au = callPackage ../os-specific/linux/rtl8814au { };

    rtl8821au = callPackage ../os-specific/linux/rtl8821au { };

    rtl8821ce = callPackage ../os-specific/linux/rtl8821ce { };

    rtlwifi_new = callPackage ../os-specific/linux/rtlwifi_new { };

    openafs = callPackage ../servers/openafs/1.6/module.nix { };
    openafs_1_8 = callPackage ../servers/openafs/1.8/module.nix { };

    facetimehd = callPackage ../os-specific/linux/facetimehd { };

    tuxedo-keyboard = callPackage ../os-specific/linux/tuxedo-keyboard { };

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

    phc-intel = if stdenv.lib.versionAtLeast kernel.version "4.10" then callPackage ../os-specific/linux/phc-intel { } else null;

    # Disable for kernels 4.15 and above due to compatibility issues
    prl-tools = if stdenv.lib.versionOlder kernel.version "4.15" then callPackage ../os-specific/linux/prl-tools { } else null;

    sch_cake = callPackage ../os-specific/linux/sch_cake { };

    sysdig = callPackage ../os-specific/linux/sysdig {};

    systemtap = callPackage ../development/tools/profiling/systemtap { };

    tmon = callPackage ../os-specific/linux/tmon { };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    turbostat = callPackage ../os-specific/linux/turbostat { };

    usbip = callPackage ../os-specific/linux/usbip { };

    v86d = callPackage ../os-specific/linux/v86d { };

    vhba = callPackage ../misc/emulators/cdemu/vhba.nix { };

    virtualbox = callPackage ../os-specific/linux/virtualbox {
      virtualbox = pkgs.virtualboxHardened;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions {
      virtualbox = pkgs.virtualboxHardened;
    };

    wireguard = if lib.versionOlder kernel.version "5.6" then callPackage ../os-specific/linux/wireguard { } else null;

    x86_energy_perf_policy = callPackage ../os-specific/linux/x86_energy_perf_policy { };

    zenpower = callPackage ../os-specific/linux/zenpower { };

    inherit (callPackage ../os-specific/linux/zfs {
      configFile = "kernel";
      inherit kernel;
     }) zfsStable zfsUnstable;

     zfs = zfsStable;

     can-isotp = callPackage ../os-specific/linux/can-isotp { };
  });

  # The current default kernel / kernel modules.
  linuxPackages = linuxPackages_5_4;
  linux = linuxPackages.kernel;

  # Update this when adding the newest kernel major version!
  linuxPackages_latest = linuxPackages_5_6;
  linux_latest = linuxPackages_latest.kernel;

  # Build the kernel modules for the some of the kernels.
  linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_rpi1 = linuxPackagesFor pkgs.linux_rpi1;
  linuxPackages_rpi2 = linuxPackagesFor pkgs.linux_rpi2;
  linuxPackages_rpi3 = linuxPackagesFor pkgs.linux_rpi3;
  linuxPackages_rpi4 = linuxPackagesFor pkgs.linux_rpi4;
  linuxPackages_4_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_4);
  linuxPackages_4_9 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_9);
  linuxPackages_4_14 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_14);
  linuxPackages_4_19 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_19);
  linuxPackages_5_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_5_4);
  linuxPackages_5_5 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_5_5);
  linuxPackages_5_6 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_5_6);

  # When adding to this list:
  # - Update linuxPackages_latest to the latest version
  # - Update the rev in ../os-specific/linux/kernel/linux-libre.nix to the latest one.

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
    structuredExtraConfig = import ../os-specific/linux/kernel/hardened-config.nix {
      inherit stdenv;
      inherit (kernel) version;
    };
    kernelPatches = kernel.kernelPatches ++ [ kernelPatches.tag_hardened ];
    modDirVersionArg = kernel.modDirVersion + "-hardened";
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
  linuxConfig = {
    src,
    version ? (builtins.parseDrvName src.name).version,
    makeTarget ? "defconfig",
    name ? "kernel.config",
  }: stdenvNoCC.mkDerivation {
    inherit name src;
    depsBuildBuild = [ buildPackages.stdenv.cc ]
      ++ lib.optionals (lib.versionAtLeast version "4.16") [ buildPackages.bison buildPackages.flex ];
    buildPhase = ''
      set -x
      make \
        ARCH=${stdenv.hostPlatform.kernelArch} \
        HOSTCC=${buildPackages.stdenv.cc.targetPrefix}gcc \
        ${makeTarget}
    '';
    installPhase = ''
      cp .config $out
    '';
  };

  buildLinux = attrs: callPackage ../os-specific/linux/kernel/generic.nix attrs;

  cryptodev = linuxPackages_4_9.cryptodev;

  dpdk = callPackage ../os-specific/linux/dpdk {
    kernel = null; # dpdk modules are in linuxPackages.dpdk.kmod
  };

  keyutils = callPackage ../os-specific/linux/keyutils { };

  libselinux = callPackage ../os-specific/linux/libselinux {
    python = python37;
  };

  libsemanage = callPackage ../os-specific/linux/libsemanage {
    python = python3;
  };

  libraw = callPackage ../development/libraries/libraw { };

  libraw1394 = callPackage ../development/libraries/libraw1394 { };

  librealsense = callPackage ../development/libraries/librealsense { };

  libsass = callPackage ../development/libraries/libsass { };

  libsepol = callPackage ../os-specific/linux/libsepol { };

  libsmbios = callPackage ../os-specific/linux/libsmbios { };

  lm_sensors = callPackage ../os-specific/linux/lm-sensors { };

  lockdep = callPackage ../os-specific/linux/lockdep { };

  lsiutil = callPackage ../os-specific/linux/lsiutil { };

  kmod = callPackage ../os-specific/linux/kmod { };

  kmod-blacklist-ubuntu = callPackage ../os-specific/linux/kmod-blacklist-ubuntu { };

  kmod-debian-aliases = callPackage ../os-specific/linux/kmod-debian-aliases { };

  libcap = callPackage ../os-specific/linux/libcap { };

  libcap_ng = callPackage ../os-specific/linux/libcap-ng {
    swig = null; # Currently not using the python2/3 bindings
    python2 = null; # Currently not using the python2 bindings
    python3 = null; # Currently not using the python3 bindings
  };

  libnotify = callPackage ../development/libraries/libnotify { };

  libvolume_id = callPackage ../os-specific/linux/libvolume_id { };

  lsscsi = callPackage ../os-specific/linux/lsscsi { };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  mbpfan = callPackage ../os-specific/linux/mbpfan { };

  mdadm = mdadm4;
  mdadm4 = callPackage ../os-specific/linux/mdadm { };

  metastore = callPackage ../os-specific/linux/metastore { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  miraclecast = callPackage ../os-specific/linux/miraclecast { };

  mkinitcpio-nfs-utils = callPackage ../os-specific/linux/mkinitcpio-nfs-utils { };

  mmc-utils = callPackage ../os-specific/linux/mmc-utils { };

  aggregateModules = modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit (buildPackages) kmod;
      inherit modules;
    };

  multipart-parser-c = callPackage ../development/libraries/multipart-parser-c { };

  multipath-tools = callPackage ../os-specific/linux/multipath-tools { };

  musl = callPackage ../os-specific/linux/musl { };

  nushell = callPackage ../shells/nushell {
    inherit (darwin.apple_sdk.frameworks) AppKit Security;
  };

  nettools = if stdenv.isLinux then callPackage ../os-specific/linux/net-tools { }
             else unixtools.nettools;

  nettools_mptcp = callPackage ../os-specific/linux/net-tools/mptcp.nix { };

  nftables = callPackage ../os-specific/linux/nftables { };

  noah = callPackage ../os-specific/darwin/noah {
    inherit (darwin.apple_sdk.frameworks) Hypervisor;
  };

  numactl = callPackage ../os-specific/linux/numactl { };

  numad = callPackage ../os-specific/linux/numad { };

  nvme-cli = callPackage ../os-specific/linux/nvme-cli { };

  open-vm-tools = callPackage ../applications/virtualization/open-vm-tools { };
  open-vm-tools-headless = open-vm-tools.override { withX = false; };

  delve = callPackage ../development/tools/delve { };

  dep = callPackage ../development/tools/dep { };

  dep2nix = callPackage ../development/tools/dep2nix { };

  easyjson = callPackage ../development/tools/easyjson { };

  iferr = callPackage ../development/tools/iferr { };

  go-bindata = callPackage ../development/tools/go-bindata { };

  go-bindata-assetfs = callPackage ../development/tools/go-bindata-assetfs { };

  go-protobuf = callPackage ../development/tools/go-protobuf { };

  go-symbols = callPackage ../development/tools/go-symbols { };

  go-outline = callPackage ../development/tools/go-outline { };

  gocode = callPackage ../development/tools/gocode { };

  gocode-gomod = callPackage ../development/tools/gocode-gomod { };

  goconst = callPackage ../development/tools/goconst { };

  goconvey = callPackage ../development/tools/goconvey { };

  gofumpt = callPackage ../development/tools/gofumpt { };

  gotags = callPackage ../development/tools/gotags { };

  golint = callPackage ../development/tools/golint { };

  golangci-lint = callPackage ../development/tools/golangci-lint { };

  gocyclo = callPackage ../development/tools/gocyclo { };

  godef = callPackage ../development/tools/godef { };

  gopkgs = callPackage ../development/tools/gopkgs { };

  gosec = callPackage ../development/tools/gosec { };

  govers = callPackage ../development/tools/govers { };

  govendor = callPackage ../development/tools/govendor { };

  go-tools = callPackage ../development/tools/go-tools { };

  gotools = callPackage ../development/tools/gotools {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  gotop = callPackage ../tools/system/gotop { };

  gomodifytags = callPackage ../development/tools/gomodifytags { };

  go-langserver = callPackage ../development/tools/go-langserver { };

  gotests = callPackage ../development/tools/gotests { };

  gotestsum = callPackage ../development/tools/gotestsum {
    # Version 0.3.5 fails to build with go 1.13:
    #    build ./testjson/internal/badmain: cannot find module for path ./testjson/internal/badmain
    buildGoModule = buildGo112Module;
  };

  impl = callPackage ../development/tools/impl { };

  quicktemplate = callPackage ../development/tools/quicktemplate { };

  gogoclient = callPackage ../os-specific/linux/gogoclient {
    openssl = openssl_1_0_2;
  };

  linux-pam = callPackage ../os-specific/linux/pam { };

  nss_ldap = callPackage ../os-specific/linux/nss_ldap { };

  odp-dpdk = callPackage ../os-specific/linux/odp-dpdk { };

  odroid-xu3-bootloader = callPackage ../tools/misc/odroid-xu3-bootloader { };

  ofp = callPackage ../os-specific/linux/ofp { };

  ofono = callPackage ../tools/networking/ofono { };

  openpam = callPackage ../development/libraries/openpam { };

  openbsm = callPackage ../development/libraries/openbsm { };

  pagemon = callPackage ../os-specific/linux/pagemon { };

  pam = if stdenv.isLinux then linux-pam else openpam;

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_ccreds = callPackage ../os-specific/linux/pam_ccreds { };

  pam_krb5 = callPackage ../os-specific/linux/pam_krb5 { };

  pam_ldap = callPackage ../os-specific/linux/pam_ldap { };

  pam_mount = callPackage ../os-specific/linux/pam_mount { };

  pam_pgsql = callPackage ../os-specific/linux/pam_pgsql { };

  pam_ssh_agent_auth = callPackage ../os-specific/linux/pam_ssh_agent_auth { };

  pam_u2f = callPackage ../os-specific/linux/pam_u2f { };

  pam_usb = callPackage ../os-specific/linux/pam_usb { };

  paxctl = callPackage ../os-specific/linux/paxctl { };

  paxtest = callPackage ../os-specific/linux/paxtest { };

  pax-utils = callPackage ../os-specific/linux/pax-utils { };

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils { };

  pcstat = callPackage ../tools/system/pcstat { };

  perf-tools = callPackage ../os-specific/linux/perf-tools { };

  pipes = callPackage ../misc/screensavers/pipes { };

  pipework = callPackage ../os-specific/linux/pipework { };

  pktgen = callPackage ../os-specific/linux/pktgen { };

  plymouth = callPackage ../os-specific/linux/plymouth { };

  pmount = callPackage ../os-specific/linux/pmount { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  policycoreutils = callPackage ../os-specific/linux/policycoreutils { };

  semodule-utils = callPackage ../os-specific/linux/semodule-utils { };

  powerdns = callPackage ../servers/dns/powerdns { };

  dnsdist = callPackage ../servers/dns/dnsdist { };

  pdns-recursor = callPackage ../servers/dns/pdns-recursor { };

  powertop = callPackage ../os-specific/linux/powertop { };

  pps-tools = callPackage ../os-specific/linux/pps-tools { };

  prayer = callPackage ../servers/prayer { };

  procps = if stdenv.isLinux then callPackage ../os-specific/linux/procps-ng { }
           else unixtools.procps;

  procdump = callPackage ../os-specific/linux/procdump { };

  prototool = callPackage ../development/tools/prototool { };

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

  radeontools = callPackage ../os-specific/linux/radeontools { };

  radeontop = callPackage ../os-specific/linux/radeontop { };

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi {};
  raspberrypiWirelessFirmware = callPackage ../os-specific/linux/firmware/raspberrypi-wireless { };

  raspberrypi-tools = callPackage ../os-specific/linux/firmware/raspberrypi/tools.nix {};

  regionset = callPackage ../os-specific/linux/regionset { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  riscv-pk = callPackage ../misc/riscv-pk { };

  roccat-tools = callPackage ../os-specific/linux/roccat-tools { };

  rtkit = callPackage ../os-specific/linux/rtkit { };

  rt5677-firmware = callPackage ../os-specific/linux/firmware/rt5677 { };

  rtl8192su-firmware = callPackage ../os-specific/linux/firmware/rtl8192su-firmware { };

  rtl8723bs-firmware = callPackage ../os-specific/linux/firmware/rtl8723bs-firmware { };

  rtlwifi_new-firmware = callPackage ../os-specific/linux/firmware/rtlwifi_new-firmware { };

  s3ql = callPackage ../tools/backup/s3ql { };

  sass = callPackage ../development/tools/sass { };

  sassc = callPackage ../development/tools/sassc { };

  scanmem = callPackage ../tools/misc/scanmem { };

  schedtool = callPackage ../os-specific/linux/schedtool { };

  sdparm = callPackage ../os-specific/linux/sdparm { };

  sdrangel = libsForQt5.callPackage ../applications/radio/sdrangel {  };

  sepolgen = callPackage ../os-specific/linux/sepolgen { };

  setools = callPackage ../os-specific/linux/setools { };

  seturgent = callPackage ../os-specific/linux/seturgent { };

  shadow = callPackage ../os-specific/linux/shadow { };

  sinit = callPackage ../os-specific/linux/sinit {
    rcinit = "/etc/rc.d/rc.init";
    rcshutdown = "/etc/rc.d/rc.shutdown";
  };

  skopeo = callPackage ../development/tools/skopeo { };

  smem = callPackage ../os-specific/linux/smem { };

  smimesign = callPackage ../os-specific/darwin/smimesign { };

  speedometer = callPackage ../os-specific/linux/speedometer { };

  statik = callPackage ../development/tools/statik { };

  statifier = callPackage ../os-specific/linux/statifier { };

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # pkgs.sysdig is a client, for a driver look at linuxPackagesFor

  sysfsutils = callPackage ../os-specific/linux/sysfsutils { };

  sysprof = callPackage ../development/tools/profiling/sysprof { };

  sysklogd = callPackage ../os-specific/linux/sysklogd { };

  syslinux = callPackage ../os-specific/linux/syslinux { };

  sysstat = callPackage ../os-specific/linux/sysstat { };

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

  systemd-wait = callPackage ../os-specific/linux/systemd-wait { };

  sysvinit = callPackage ../os-specific/linux/sysvinit { };

  sysvtools = sysvinit.override {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcp_wrappers = callPackage ../os-specific/linux/tcp-wrappers { };

  tiptop = callPackage ../os-specific/linux/tiptop { };

  tpacpi-bat = callPackage ../os-specific/linux/tpacpi-bat { };

  trickster = callPackage ../servers/trickster/trickster.nix {};

  trinity = callPackage ../os-specific/linux/trinity { };

  tunctl = callPackage ../os-specific/linux/tunctl { };

  twa = callPackage ../tools/networking/twa { };

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot {})
    buildUBoot
    ubootTools
    ubootA20OlinuxinoLime
    ubootBananaPi
    ubootBananaPim3
    ubootBananaPim64
    ubootAmx335xEVM
    ubootClearfog
    ubootGuruplug
    ubootJetsonTK1
    ubootNovena
    ubootOdroidC2
    ubootOdroidXU3
    ubootOrangePiPc
    ubootOrangePiZeroPlus2H5
    ubootPcduino3Nano
    ubootPine64
    ubootPine64LTS
    ubootPinebook
    ubootQemuAarch64
    ubootQemuArm
    ubootRaspberryPi
    ubootRaspberryPi2
    ubootRaspberryPi3_32bit
    ubootRaspberryPi3_64bit
    ubootRaspberryPiZero
    ubootRock64
    ubootRockPro64
    ubootSheevaplug
    ubootSopine
    ubootUtilite
    ubootWandboard
    ;

  # Non-upstream U-Boots:
  ubootNanonote = callPackage ../misc/uboot/nanonote.nix { };

  uclibc = callPackage ../os-specific/linux/uclibc { };

  uclibcCross = callPackage ../os-specific/linux/uclibc {
    stdenv = crossLibcStdenv;
  };

  eudev = callPackage ../os-specific/linux/eudev { utillinux = utillinuxMinimal; };

  libudev0-shim = callPackage ../os-specific/linux/libudev0-shim { };

  udisks1 = callPackage ../os-specific/linux/udisks/1-default.nix { };
  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks2;

  udisks_glue = callPackage ../os-specific/linux/udisks-glue { };

  untie = callPackage ../os-specific/linux/untie { };

  upower = callPackage ../os-specific/linux/upower { };

  usbguard = callPackage ../os-specific/linux/usbguard {
    libgcrypt = null;
  };

  usbtop = callPackage ../os-specific/linux/usbtop { };

  usbutils = callPackage ../os-specific/linux/usbutils { };

  usermount = callPackage ../os-specific/linux/usermount { };

  utillinux = if stdenv.isLinux then callPackage ../os-specific/linux/util-linux { }
              else unixtools.utillinux;

  utillinuxCurses = utillinux;

  utillinuxMinimal = if stdenv.isLinux then appendToName "minimal" (utillinux.override {
    minimal = true;
    ncurses = null;
    perl = null;
    systemd = null;
  }) else utillinux;

  v4l-utils = qt5.callPackage ../os-specific/linux/v4l-utils { };

  vndr = callPackage ../development/tools/vndr { };

  windows = callPackages ../os-specific/windows {};

  wirelesstools = callPackage ../os-specific/linux/wireless-tools { };

  wooting-udev-rules = callPackage ../os-specific/linux/wooting-udev-rules { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant { };

  wpa_supplicant_gui = libsForQt5.callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  xf86_input_cmt = callPackage ../os-specific/linux/xf86-input-cmt { };

  xf86_input_wacom = callPackage ../os-specific/linux/xf86-input-wacom { };

  xf86_video_nested = callPackage ../os-specific/linux/xf86-video-nested { };

  xilinx-bootgen = callPackage ../tools/misc/xilinx-bootgen { };

  xorg_sys_opengl = callPackage ../os-specific/linux/opengl/xorg-sys { };

  zd1211fw = callPackage ../os-specific/linux/firmware/zd1211 { };

  zenmonitor = callPackage ../os-specific/linux/zenmonitor { };

  inherit (callPackage ../os-specific/linux/zfs {
    configFile = "user";
  }) zfsStable zfsUnstable;

  zfs = zfsStable;

  ### DATA

  adapta-backgrounds = callPackage ../data/misc/adapta-backgrounds { };

  adapta-gtk-theme = callPackage ../data/themes/adapta { };

  adapta-kde-theme = callPackage ../data/themes/adapta-kde { };

  adementary-theme = callPackage ../data/themes/adementary { };

  adwaita-qt = libsForQt5.callPackage ../data/themes/adwaita-qt { };

  agave = callPackage ../data/fonts/agave { };

  aileron = callPackage ../data/fonts/aileron { };

  albatross = callPackage ../data/themes/albatross { };

  amber-theme = callPackage ../data/themes/amber { };

  amiri = callPackage ../data/fonts/amiri { };

  andagii = callPackage ../data/fonts/andagii { };

  andika = callPackage ../data/fonts/andika { };

  android-udev-rules = callPackage ../os-specific/linux/android-udev-rules { };

  ankacoder = callPackage ../data/fonts/ankacoder { };
  ankacoder-condensed = callPackage ../data/fonts/ankacoder/condensed.nix { };

  anonymousPro = callPackage ../data/fonts/anonymous-pro { };

  ant-theme = callPackage ../data/themes/ant-theme/ant.nix { };

  ant-bloody-theme = callPackage ../data/themes/ant-theme/ant-bloody.nix { };

  ant-dracula-theme = callPackage ../data/themes/ant-theme/ant-dracula.nix { };

  ant-nebula-theme = callPackage ../data/themes/ant-theme/ant-nebula.nix { };

  arc-icon-theme = callPackage ../data/icons/arc-icon-theme { };

  arc-kde-theme = callPackage ../data/themes/arc-kde { };

  arc-theme = callPackage ../data/themes/arc { };

  arkpandora_ttf = callPackage ../data/fonts/arkpandora { };

  aurulent-sans = callPackage ../data/fonts/aurulent-sans { };

  b612  = callPackage ../data/fonts/b612 { };

  babelstone-han = callPackage ../data/fonts/babelstone-han { };

  baekmuk-ttf = callPackage ../data/fonts/baekmuk-ttf { };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

  bgnet = callPackage ../data/documentation/bgnet { };

  bibata-cursors = callPackage ../data/icons/bibata-cursors { };
  bibata-extra-cursors = callPackage ../data/icons/bibata-cursors/extra.nix { };
  bibata-cursors-translucent = callPackage ../data/icons/bibata-cursors/translucent.nix { };

  blackbird = callPackage ../data/themes/blackbird { };

  brise = callPackage ../data/misc/brise { };

  inherit (kdeFrameworks) breeze-icons;

  cacert = callPackage ../data/misc/cacert { };

  caladea = callPackage ../data/fonts/caladea {};

  canta-theme = callPackage ../data/themes/canta { };

  cantarell-fonts = callPackage ../data/fonts/cantarell-fonts { };

  capitaine-cursors = callPackage ../data/icons/capitaine-cursors { };

  carlito = callPackage ../data/fonts/carlito {};

  cascadia-code = callPackage ../data/fonts/cascadia-code { };

  charis-sil = callPackage ../data/fonts/charis-sil { };

  cherry = callPackage ../data/fonts/cherry { inherit (xorg) fonttosfnt mkfontdir; };

  cldr-emoji-annotation = callPackage ../data/misc/cldr-emoji-annotation { };

  clearlooks-phenix = callPackage ../data/themes/clearlooks-phenix { };

  cnstrokeorder = callPackage ../data/fonts/cnstrokeorder {};

  comfortaa = callPackage ../data/fonts/comfortaa {};

  comic-neue = callPackage ../data/fonts/comic-neue { };

  comic-relief = callPackage ../data/fonts/comic-relief {};

  coreclr = callPackage ../development/compilers/coreclr { };

  corefonts = callPackage ../data/fonts/corefonts { };

  cozette = callPackage ../data/fonts/cozette { };

  culmus = callPackage ../data/fonts/culmus { };

  clearlyU = callPackage ../data/fonts/clearlyU
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  cm_unicode = callPackage ../data/fonts/cm-unicode {};

  creep = callPackage ../data/fonts/creep
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  crimson = callPackage ../data/fonts/crimson {};

  dejavu_fonts = lowPrio (callPackage ../data/fonts/dejavu-fonts {});

  # solve collision for nix-env before https://github.com/NixOS/nix/pull/815
  dejavu_fontsEnv = buildEnv {
    name = dejavu_fonts.name;
    paths = [ dejavu_fonts.out ];
  };

  dina-font = callPackage ../data/fonts/dina
    { inherit (buildPackages.xorg) mkfontscale; };

  dns-root-data = callPackage ../data/misc/dns-root-data { };

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
    docbook-xsl-nons
    docbook-xsl-ns;

  # TODO: move this to aliases
  docbook_xsl = docbook-xsl-nons;
  docbook_xsl_ns = docbook-xsl-ns;

  documentation-highlighter = callPackage ../misc/documentation-highlighter { };

  documize-community = callPackage ../servers/documize-community { };

  doge = callPackage ../misc/doge { };

  doulos-sil = callPackage ../data/fonts/doulos-sil { };

  cabin = callPackage ../data/fonts/cabin { };

  camingo-code = callPackage ../data/fonts/camingo-code { };

  combinatorial_designs = callPackage ../data/misc/combinatorial_designs { };

  conway_polynomials = callPackage ../data/misc/conway_polynomials { };

  cooper-hewitt = callPackage ../data/fonts/cooper-hewitt { };

  d2coding = callPackage ../data/fonts/d2coding { };

  dosis = callPackage ../data/fonts/dosis { };

  dosemu_fonts = callPackage ../data/fonts/dosemu-fonts { };

  e17gtk = callPackage ../data/themes/e17gtk { };

  eb-garamond = callPackage ../data/fonts/eb-garamond { };

  elliptic_curves = callPackage ../data/misc/elliptic_curves { };

  equilux-theme = callPackage ../data/themes/equilux-theme { };

  eunomia = callPackage ../data/fonts/eunomia { };

  f5_6 = callPackage ../data/fonts/f5_6 { };

  faba-icon-theme = callPackage ../data/icons/faba-icon-theme { };

  faba-mono-icons = callPackage ../data/icons/faba-mono-icons { };

  ferrum = callPackage ../data/fonts/ferrum { };

  fixedsys-excelsior = callPackage ../data/fonts/fixedsys-excelsior { };

  graphs = callPackage ../data/misc/graphs { };

  emacs-all-the-icons-fonts = callPackage ../data/fonts/emacs-all-the-icons-fonts { };

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
  };

  encode-sans = callPackage ../data/fonts/encode-sans { };

  envypn-font = callPackage ../data/fonts/envypn-font
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  envdir = callPackage ../tools/misc/envdir-go { };

  fantasque-sans-mono = callPackage ../data/fonts/fantasque-sans-mono {};

  fira = callPackage ../data/fonts/fira { };

  fira-code = callPackage ../data/fonts/fira-code { };
  fira-code-symbols = callPackage ../data/fonts/fira-code/symbols.nix { };

  fira-mono = callPackage ../data/fonts/fira-mono { };

  flat-remix-icon-theme = callPackage ../data/icons/flat-remix-icon-theme { };

  font-awesome_4 = (callPackage ../data/fonts/font-awesome-5 { }).v4;
  font-awesome_5 = (callPackage ../data/fonts/font-awesome-5 { }).v5;
  font-awesome = font-awesome_5;

  freefont_ttf = callPackage ../data/fonts/freefont-ttf { };

  freepats = callPackage ../data/misc/freepats { };

  gentium = callPackage ../data/fonts/gentium {};

  gentium-book-basic = callPackage ../data/fonts/gentium-book-basic {};

  geolite-legacy = callPackage ../data/misc/geolite-legacy { };

  gohufont = callPackage ../data/fonts/gohufont
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  gnome-user-docs = callPackage ../data/documentation/gnome-user-docs { };

  gsettings-desktop-schemas = callPackage ../development/libraries/gsettings-desktop-schemas { };

  gnome-breeze = callPackage ../data/themes/gnome-breeze { };

  go-font = callPackage ../data/fonts/go-font { };

  greybird = callPackage ../data/themes/greybird { };

  gubbi-font = callPackage ../data/fonts/gubbi { };

  gyre-fonts = callPackage ../data/fonts/gyre {};

  hack-font = callPackage ../data/fonts/hack { };

  helvetica-neue-lt-std = callPackage ../data/fonts/helvetica-neue-lt-std { };

  hetzner-kube = callPackage ../applications/networking/cluster/hetzner-kube { };

  hicolor-icon-theme = callPackage ../data/icons/hicolor-icon-theme { };

  hanazono = callPackage ../data/fonts/hanazono { };

  hermit = callPackage ../data/fonts/hermit { };

  hyperscrypt-font = callPackage ../data/fonts/hyperscrypt { };

  ia-writer-duospace = callPackage ../data/fonts/ia-writer-duospace { };

  ibm-plex = callPackage ../data/fonts/ibm-plex { };

  iconpack-jade = callPackage ../data/icons/iconpack-jade { };

  iconpack-obsidian = callPackage ../data/icons/iconpack-obsidian { };

  inconsolata = callPackage ../data/fonts/inconsolata {};

  inconsolata-lgc = callPackage ../data/fonts/inconsolata/lgc.nix {};

  inconsolata-nerdfont = callPackage ../data/fonts/inconsolata-nerdfont {};

  input-fonts = callPackage ../data/fonts/input-fonts { };

  inriafonts = callPackage ../data/fonts/inriafonts { };


  iosevka = callPackage ../data/fonts/iosevka {
    nodejs = nodejs-10_x;
  };
  iosevka-bin = callPackage ../data/fonts/iosevka/bin.nix {};

  ipafont = callPackage ../data/fonts/ipafont {};
  ipaexfont = callPackage ../data/fonts/ipaexfont {};

  iwona = callPackage ../data/fonts/iwona { };

  jetbrains-mono = callPackage ../data/fonts/jetbrains-mono { };

  jost = callPackage ../data/fonts/jost { };

  joypixels = callPackage ../data/fonts/joypixels { };

  junicode = callPackage ../data/fonts/junicode { };

  kanji-stroke-order-font = callPackage ../data/fonts/kanji-stroke-order-font {};

  kawkab-mono-font = callPackage ../data/fonts/kawkab-mono {};

  kde2-decoration = libsForQt5.callPackage ../data/themes/kde2 { };

  kochi-substitute = callPackage ../data/fonts/kochi-substitute {};

  kochi-substitute-naga10 = callPackage ../data/fonts/kochi-substitute-naga10 {};

  lato = callPackage ../data/fonts/lato {};

  league-of-moveable-type = callPackage ../data/fonts/league-of-moveable-type {};

  ledger-udev-rules = callPackage ../os-specific/linux/ledger-udev-rules {};

  inherit (callPackages ../data/fonts/redhat-liberation-fonts { })
    liberation_ttf_v1
    liberation_ttf_v2
    ;
  liberation_ttf = liberation_ttf_v2;

  liberation-sans-narrow = callPackage ../data/fonts/liberation-sans-narrow { };

  libevdevc = callPackage ../os-specific/linux/libevdevc { };

  libgestures = callPackage ../os-specific/linux/libgestures { };

  liberastika = callPackage ../data/fonts/liberastika { };

  libertine = callPackage ../data/fonts/libertine { };

  libertinus = callPackage ../data/fonts/libertinus { };

  libratbag = callPackage ../os-specific/linux/libratbag { };

  libre-baskerville = callPackage ../data/fonts/libre-baskerville { };

  libre-bodoni = callPackage ../data/fonts/libre-bodoni { };

  libre-caslon = callPackage ../data/fonts/libre-caslon { };

  libre-franklin = callPackage ../data/fonts/libre-franklin { };

  lmmath = callPackage ../data/fonts/lmmath {};

  lmodern = callPackage ../data/fonts/lmodern { };

  lobster-two = callPackage ../data/fonts/lobster-two {};

  logitech-udev-rules = callPackage ../os-specific/linux/logitech-udev-rules {};

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  lounge-gtk-theme = callPackage ../data/themes/lounge { };

  luculent = callPackage ../data/fonts/luculent { };

  maia-icon-theme = callPackage ../data/icons/maia-icon-theme { };

  mailcap = callPackage ../data/misc/mailcap { };

  marathi-cursive = callPackage ../data/fonts/marathi-cursive { };

  man-pages = callPackage ../data/documentation/man-pages { };

  manrope = callPackage ../data/fonts/manrope { };

  matcha = callPackage ../data/themes/matcha { };

  materia-theme = callPackage ../data/themes/materia-theme { };

  material-design-icons = callPackage ../data/fonts/material-design-icons { };

  material-icons = callPackage ../data/fonts/material-icons { };

  meslo-lg = callPackage ../data/fonts/meslo-lg {};

  migmix = callPackage ../data/fonts/migmix {};

  migu = callPackage ../data/fonts/migu {};

  miscfiles = callPackage ../data/misc/miscfiles { };

  media-player-info = callPackage ../data/misc/media-player-info {};

  medio = callPackage ../data/fonts/medio { };

  mno16 = callPackage ../data/fonts/mno16 { };

  mnist = callPackage ../data/machine-learning/mnist { };

  mobile-broadband-provider-info = callPackage ../data/misc/mobile-broadband-provider-info { };

  mojave-gtk-theme = callPackage ../data/themes/mojave { };

  moka-icon-theme = callPackage ../data/icons/moka-icon-theme { };

  monoid = callPackage ../data/fonts/monoid { };

  mononoki = callPackage ../data/fonts/mononoki { };

  montserrat = callPackage ../data/fonts/montserrat { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  mplus-outline-fonts = callPackage ../data/fonts/mplus-outline-fonts { };

  mro-unicode = callPackage ../data/fonts/mro-unicode { };

  mustache-spec = callPackage ../data/documentation/mustache-spec { };

  mustache-go = callPackage ../development/tools/mustache-go { };

  myrica = callPackage ../data/fonts/myrica { };

  nafees = callPackage ../data/fonts/nafees { };

  nanum-gothic-coding = callPackage ../data/fonts/nanum-gothic-coding {  };

  national-park-typeface = callPackage ../data/fonts/national-park { };

  nordic = callPackage ../data/themes/nordic { };

  nordic-polar = callPackage ../data/themes/nordic-polar { };

  inherit (callPackages ../data/fonts/noto-fonts {})
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra;

  nullmailer = callPackage ../servers/mail/nullmailer {
    stdenv = gccStdenv;
  };

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme { };

  numix-icon-theme-circle = callPackage ../data/icons/numix-icon-theme-circle { };

  numix-icon-theme-square = callPackage ../data/icons/numix-icon-theme-square { };

  numix-cursor-theme = callPackage ../data/icons/numix-cursor-theme { };

  numix-gtk-theme = callPackage ../data/themes/numix { };

  numix-solarized-gtk-theme = callPackage ../data/themes/numix-solarized { };

  numix-sx-gtk-theme = callPackage ../data/themes/numix-sx { };

  office-code-pro = callPackage ../data/fonts/office-code-pro { };

  oldstandard = callPackage ../data/fonts/oldstandard { };

  oldsindhi = callPackage ../data/fonts/oldsindhi { };

  onestepback = callPackage ../data/themes/onestepback { };

  open-dyslexic = callPackage ../data/fonts/open-dyslexic { };

  open-sans = callPackage ../data/fonts/open-sans { };

  orbitron = callPackage ../data/fonts/orbitron { };

  orion = callPackage ../data/themes/orion {};

  overpass = callPackage ../data/fonts/overpass { };

  oxygenfonts = callPackage ../data/fonts/oxygenfonts { };

  inherit (kdeFrameworks) oxygen-icons5;

  paper-gtk-theme = callPackage ../data/themes/paper-gtk { };

  paper-icon-theme = callPackage ../data/icons/paper-icon-theme { };

  papirus-icon-theme = callPackage ../data/icons/papirus-icon-theme { };

  papirus-maia-icon-theme = callPackage ../data/icons/papirus-maia-icon-theme { };

  papis = with python3Packages; toPythonApplication papis;

  paps = callPackage ../tools/misc/paps { };

  pecita = callPackage ../data/fonts/pecita {};

  paratype-pt-mono = callPackage ../data/fonts/paratype-pt/mono.nix {};
  paratype-pt-sans = callPackage ../data/fonts/paratype-pt/sans.nix {};
  paratype-pt-serif = callPackage ../data/fonts/paratype-pt/serif.nix {};

  pari-galdata = callPackage ../data/misc/pari-galdata {};

  pari-seadata-small = callPackage ../data/misc/pari-seadata-small {};

  penna = callPackage ../data/fonts/penna { };

  plano-theme = callPackage ../data/themes/plano { };

  plata-theme = callPackage ../data/themes/plata {
    inherit (mate) marco;
  };

  poly = callPackage ../data/fonts/poly { };

  polytopes_db = callPackage ../data/misc/polytopes_db { };

  pop-gtk-theme = callPackage ../data/themes/pop-gtk { };

  posix_man_pages = callPackage ../data/documentation/man-pages-posix { };

  powerline-fonts = callPackage ../data/fonts/powerline-fonts { };

  powerline-go = callPackage ../tools/misc/powerline-go { };

  powerline-rs = callPackage ../tools/misc/powerline-rs {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  profont = callPackage ../data/fonts/profont
    { inherit (buildPackages.xorg) mkfontscale; };

  proggyfonts = callPackage ../data/fonts/proggyfonts { };

  public-sans  = callPackage ../data/fonts/public-sans { };

  publicsuffix-list = callPackage ../data/misc/publicsuffix-list { };

  qogir-icon-theme = callPackage ../data/icons/qogir-icon-theme { };

  qogir-theme = callPackage ../data/themes/qogir { };

  qtcurve = libsForQt5.callPackage ../data/themes/qtcurve {};

  redhat-official-fonts = callPackage ../data/fonts/redhat-official { };

  route159 = callPackage ../data/fonts/route159 { };

  sampradaya = callPackage ../data/fonts/sampradaya { };

  sarasa-gothic = callPackage ../data/fonts/sarasa-gothic { };

  scowl = callPackage ../data/misc/scowl { };

  seshat = callPackage ../data/fonts/seshat { };

  shaderc = callPackage ../development/compilers/shaderc { };

  shades-of-gray-theme = callPackage ../data/themes/shades-of-gray { };

  sweet = callPackage ../data/themes/sweet { };

  mime-types = callPackage ../data/misc/mime-types { };

  shared-mime-info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  scheherazade = callPackage ../data/fonts/scheherazade { };

  signwriting = callPackage ../data/fonts/signwriting { };

  sierra-gtk-theme = callPackage ../data/themes/sierra { };

  snowblind = callPackage ../data/themes/snowblind { };

  solarc-gtk-theme = callPackage ../data/themes/solarc { };

  soundfont-fluid = callPackage ../data/soundfonts/fluid { };

  spdx-license-list-data = callPackage ../data/misc/spdx-license-list-data { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  starship = callPackage ../tools/misc/starship {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  stig = callPackage ../applications/networking/p2p/stig { };

  stix-otf = callPackage ../data/fonts/stix-otf { };

  stix-two = callPackage ../data/fonts/stix-two { };

  inherit (callPackages ../data/fonts/gdouros { })
    aegan aegyptus akkadian assyrian eemusic maya symbola textfonts unidings;

  iana-etc = callPackage ../data/misc/iana-etc { };

  poppler_data = callPackage ../data/misc/poppler-data { };

  qgo = libsForQt5.callPackage ../games/qgo { };

  qmc2 = libsForQt5.callPackage ../misc/emulators/qmc2 { };

  quattrocento = callPackage ../data/fonts/quattrocento {};

  quattrocento-sans = callPackage ../data/fonts/quattrocento-sans {};

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  raleway = callPackage ../data/fonts/raleway { };

  recursive = callPackage ../data/fonts/recursive { };

  rhodium-libre = callPackage ../data/fonts/rhodium-libre { };

  rictydiminished-with-firacode = callPackage ../data/fonts/rictydiminished-with-firacode { };

  roboto = callPackage ../data/fonts/roboto { };

  roboto-mono = callPackage ../data/fonts/roboto-mono { };

  roboto-slab = callPackage ../data/fonts/roboto-slab { };

  hasklig = callPackage ../data/fonts/hasklig {};

  interfacer = callPackage ../development/tools/interfacer { };

  maligned = callPackage ../development/tools/maligned { };

  inter-ui = callPackage ../data/fonts/inter-ui { };
  inter = callPackage ../data/fonts/inter { };

  siji = callPackage ../data/fonts/siji
    { inherit (buildPackages.xorg) mkfontscale fonttosfnt; };

  sound-theme-freedesktop = callPackage ../data/misc/sound-theme-freedesktop { };

  source-code-pro = callPackage ../data/fonts/source-code-pro {};

  source-sans-pro = callPackage ../data/fonts/source-sans-pro { };

  source-serif-pro = callPackage ../data/fonts/source-serif-pro { };

  source-han-code-jp = callPackage ../data/fonts/source-han-code-jp { };

  sourceHanPackages = dontRecurseIntoAttrs (callPackage ../data/fonts/source-han { });
  source-han-sans = sourceHanPackages.sans;
  source-han-serif = sourceHanPackages.serif;
  source-han-mono = sourceHanPackages.mono;

  spleen = callPackage ../data/fonts/spleen { inherit (buildPackages.xorg) mkfontscale; };

  stilo-themes = callPackage ../data/themes/stilo { };

  sudo-font = callPackage ../data/fonts/sudo { };

  inherit (callPackages ../data/fonts/tai-languages { }) tai-ahom;

  tamsyn = callPackage ../data/fonts/tamsyn { inherit (buildPackages.xorg) mkfontscale; };

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme {
    gtk = res.gtk2;
  };

  theme-jade1 = callPackage ../data/themes/jade1 { };

  theme-obsidian2 = callPackage ../data/themes/obsidian2 { };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) {};

  theano = callPackage ../data/fonts/theano { };

  template-glib = callPackage ../development/libraries/template-glib { };

  tempora_lgc = callPackage ../data/fonts/tempora-lgc { };

  tenderness = callPackage ../data/fonts/tenderness { };

  terminus_font = callPackage ../data/fonts/terminus-font
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  terminus_font_ttf = callPackage ../data/fonts/terminus-font-ttf { };

  terminus-nerdfont = callPackage ../data/fonts/terminus-nerdfont { };

  termtekst = callPackage ../misc/emulators/termtekst { };

  tex-gyre = callPackages ../data/fonts/tex-gyre { };

  tex-gyre-math = callPackages ../data/fonts/tex-gyre-math { };

  theme-vertex = callPackage ../data/themes/vertex { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  ttf-envy-code-r = callPackage ../data/fonts/ttf-envy-code-r {};

  twemoji-color-font = callPackage ../data/fonts/twemoji-color-font {
    inherit (nodePackages) svgo;
  };

  twitter-color-emoji = callPackage ../data/fonts/twitter-color-emoji { };

  tzdata = callPackage ../data/misc/tzdata { };

  ubuntu_font_family = callPackage ../data/fonts/ubuntu-font-family { };

  ucs-fonts = callPackage ../data/fonts/ucs-fonts
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };


  ultimate-oldschool-pc-font-pack = callPackage ../data/fonts/ultimate-oldschool-pc-font-pack { };

  undefined-medium = callPackage ../data/fonts/undefined-medium { };

  uni-vga = callPackage ../data/fonts/uni-vga
     { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  unicode-character-database = callPackage ../data/misc/unicode-character-database { };

  unicode-emoji = callPackage ../data/misc/unicode-emoji { };

  unihan-database = callPackage ../data/misc/unihan-database { };

  unifont = callPackage ../data/fonts/unifont
     { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  unifont_upper = callPackage ../data/fonts/unifont_upper { };

  unscii = callPackage ../data/fonts/unscii { };

  uw-ttyp0 = callPackage ../data/fonts/uw-ttyp0 { inherit (xorg) fonttosfnt mkfontdir; };

  vanilla-dmz = callPackage ../data/icons/vanilla-dmz { };

  vdrsymbols = callPackage ../data/fonts/vdrsymbols { };

  vegur = callPackage ../data/fonts/vegur { };

  vegeta = callPackage ../tools/networking/vegeta { };

  victor-mono = callPackage ../data/fonts/victor-mono { };

  vimix-gtk-themes = callPackage ../data/themes/vimix {};

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  vistafonts-chs = callPackage ../data/fonts/vista-fonts-chs { };

  weather-icons = callPackage ../data/fonts/weather-icons { };

  wireless-regdb = callPackage ../data/misc/wireless-regdb { };

  work-sans  = callPackage ../data/fonts/work-sans { };

  wqy_microhei = callPackage ../data/fonts/wqy-microhei { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xhtml1 = callPackage ../data/sgml+xml/schemas/xml-dtd/xhtml1 { };

  xits-math = callPackage ../data/fonts/xits-math { };

  xkcd-font = callPackage ../data/fonts/xkcd-font { };

  xkeyboard_config = xorg.xkeyboardconfig;

  xlsx2csv = with python3Packages; toPythonApplication xlsx2csv;

  xorg-rgb = callPackage ../data/misc/xorg-rgb {};

  yanone-kaffeesatz = callPackage ../data/fonts/yanone-kaffeesatz {};

  yaru-theme = callPackage ../data/themes/yaru {};

  zafiro-icons = callPackage ../data/icons/zafiro-icons { };

  zeal = libsForQt5.callPackage ../data/documentation/zeal { };

  zilla-slab = callPackage ../data/fonts/zilla-slab { };

  zuki-themes = callPackage ../data/themes/zuki { };


  ### APPLICATIONS

  _2bwm = callPackage ../applications/window-managers/2bwm {
    patches = config."2bwm".patches or [];
  };

  a2jmidid = callPackage ../applications/audio/a2jmidid { };

  aacgain = callPackage ../applications/audio/aacgain { };

  abcde = callPackage ../applications/audio/abcde {
    inherit (python3Packages) eyeD3;
  };

  abiword = callPackage ../applications/office/abiword { };

  abook = callPackage ../applications/misc/abook { };

  acd-cli = callPackage ../applications/networking/sync/acd_cli {
    inherit (python3Packages)
      buildPythonApplication appdirs colorama dateutil
      requests requests_toolbelt sqlalchemy fusepy;
  };

  adobe-reader = pkgsi686Linux.callPackage ../applications/misc/adobe-reader { };

  masterpdfeditor = libsForQt5.callPackage ../applications/misc/masterpdfeditor { };

  aeolus = callPackage ../applications/audio/aeolus { };

  aewan = callPackage ../applications/editors/aewan { };

  afterstep = callPackage ../applications/window-managers/afterstep {
    fltk = fltk13;
    gtk = gtk2;
  };

  agedu = callPackage ../tools/misc/agedu { };

  agenda = callPackage ../applications/office/agenda { };

  ahoviewer = callPackage ../applications/graphics/ahoviewer { };

  airwave = callPackage ../applications/audio/airwave { };

  akira-unstable = callPackage ../applications/graphics/akira { };

  alembic = callPackage ../development/libraries/alembic {};

  alchemy = callPackage ../applications/graphics/alchemy { };

  alock = callPackage ../misc/screensavers/alock { };

  inherit (python3Packages) alot;

  alpine = callPackage ../applications/networking/mailreaders/alpine {
    tcl = tcl-8_5;
  };

  msgviewer = callPackage ../applications/networking/mailreaders/msgviewer { };

  amarok = libsForQt5.callPackage ../applications/audio/amarok { };
  amarok-kf5 = amarok; # for compatibility

  AMB-plugins = callPackage ../applications/audio/AMB-plugins { };

  ams-lv2 = callPackage ../applications/audio/ams-lv2 { };

  amsn = callPackage ../applications/networking/instant-messengers/amsn { };

  androidStudioPackages = recurseIntoAttrs
    (callPackage ../applications/editors/android-studio { });
  android-studio = androidStudioPackages.stable;

  animbar = callPackage ../applications/graphics/animbar { };

  antfs-cli = callPackage ../applications/misc/antfs-cli {};

  antimony = libsForQt5.callPackage ../applications/graphics/antimony {};

  antiword = callPackage ../applications/office/antiword {};

  ao = libfive;

  apache-directory-studio = callPackage ../applications/networking/apache-directory-studio {};

  apngasm = callPackage ../applications/graphics/apngasm {};
  apngasm_2 = callPackage ../applications/graphics/apngasm/2.nix {};

  appeditor = callPackage ../applications/misc/appeditor { };

  aqemu = libsForQt5.callPackage ../applications/virtualization/aqemu { };

  ardour = callPackage ../applications/audio/ardour {
    inherit (gnome2) libgnomecanvas libgnomecanvasmm;
  };

  arelle = with python3Packages; toPythonApplication arelle;

  argo = callPackage ../applications/networking/cluster/argo { };

  argocd = callPackage ../applications/networking/cluster/argocd { };

  ario = callPackage ../applications/audio/ario { };

  arion = callPackage ../applications/virtualization/arion { };

  arora = callPackage ../applications/networking/browsers/arora { };

  artha = callPackage ../applications/misc/artha { };

  atlassian-cli = callPackage ../applications/office/atlassian-cli { };

  atomEnv = callPackage ../applications/editors/atom/env.nix {
    gconf = gnome2.GConf;
  };

  atomPackages = dontRecurseIntoAttrs (callPackage ../applications/editors/atom { });

  inherit (atomPackages) atom atom-beta;

  aseprite = callPackage ../applications/editors/aseprite { };
  aseprite-unfree = aseprite.override { unfree = true; };

  astroid = callPackage ../applications/networking/mailreaders/astroid { };

  aucatctl = callPackage ../applications/audio/aucatctl { };

  audacious = callPackage ../applications/audio/audacious { };
  audaciousQt5 = libsForQt5.callPackage ../applications/audio/audacious/qt-5.nix { };

  audacity = callPackage ../applications/audio/audacity { };

  audio-recorder = callPackage ../applications/audio/audio-recorder { };

  autokey = callPackage ../applications/office/autokey { };

  autotrace = callPackage ../applications/graphics/autotrace {};

  avocode = callPackage ../applications/graphics/avocode {};

  azpainter = callPackage ../applications/graphics/azpainter { };

  cadence =  qt5.callPackage ../applications/audio/cadence { };

  cheesecutter = callPackage ../applications/audio/cheesecutter { };

  milkytracker = callPackage ../applications/audio/milkytracker { };

  schismtracker = callPackage ../applications/audio/schismtracker { };

  jnetmap = callPackage ../applications/networking/jnetmap {};

  libbitcoin = callPackage ../tools/misc/libbitcoin/libbitcoin.nix {
    secp256k1 = secp256k1.override { enableECDH = true; };
  };

  libbitcoin-protocol = callPackage ../tools/misc/libbitcoin/libbitcoin-protocol.nix { };
  libbitcoin-client   = callPackage ../tools/misc/libbitcoin/libbitcoin-client.nix { };
  libbitcoin-network  = callPackage ../tools/misc/libbitcoin/libbitcoin-network.nix { };
  libbitcoin-explorer = callPackage ../tools/misc/libbitcoin/libbitcoin-explorer.nix { };


  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  aesop = callPackage ../applications/office/aesop { };

  avidemux = libsForQt5.callPackage ../applications/video/avidemux { };

  avrdudess = callPackage ../applications/misc/avrdudess { };

  avxsynth = callPackage ../applications/video/avxsynth {
    libjpeg = libjpeg_original; # error: 'JCOPYRIGHT_SHORT' was not declared in this scope
  };

  awesome-4-0 = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    inherit (texFunctions) fontsConf;
  };
  awesome = awesome-4-0;

  awesomebump = libsForQt5.callPackage ../applications/graphics/awesomebump { };

  inherit (gnome3) baobab;

  backintime-common = callPackage ../applications/networking/sync/backintime/common.nix { };

  backintime-qt4 = callPackage ../applications/networking/sync/backintime/qt4.nix { };

  backintime = backintime-qt4;

  balsa = callPackage ../applications/networking/mailreaders/balsa { };

  bandwidth = callPackage ../tools/misc/bandwidth { };

  baresip = callPackage ../applications/networking/instant-messengers/baresip { };

  barrier = libsForQt5.callPackage ../applications/misc/barrier {};

  bashSnippets = callPackage ../applications/misc/bashSnippets { };

  batik = callPackage ../applications/graphics/batik { };

  baudline = callPackage ../applications/audio/baudline { };


  bazaar = callPackage ../applications/version-management/bazaar { };

  bazaarTools = callPackage ../applications/version-management/bazaar/tools.nix { };

  bb =  callPackage ../applications/misc/bb { };

  beast = callPackage ../applications/audio/beast {
    inherit (gnome2) libgnomecanvas libart_lgpl;
    guile = guile_1_8;
  };

  bevelbar = callPackage ../applications/window-managers/bevelbar { };

  bibletime = libsForQt5.callPackage ../applications/misc/bibletime { };

  bino3d = libsForQt5.callPackage ../applications/video/bino3d {
    ffmpeg = ffmpeg_4;
    glew = glew110;
  };

  bitkeeper = callPackage ../applications/version-management/bitkeeper {
    gperf = gperf_3_0;
  };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };
  bitlbee-plugins = callPackage ../applications/networking/instant-messengers/bitlbee/plugins.nix { };

  bitlbee-discord = callPackage ../applications/networking/instant-messengers/bitlbee-discord { };

  bitlbee-facebook = callPackage ../applications/networking/instant-messengers/bitlbee-facebook { };

  bitlbee-steam = callPackage ../applications/networking/instant-messengers/bitlbee-steam { };

  bitlbee-mastodon = callPackage ../applications/networking/instant-messengers/bitlbee-mastodon { };

  bitmeter = callPackage ../applications/audio/bitmeter { };

  bitscope = recurseIntoAttrs
    (callPackage ../applications/science/electronics/bitscope/packages.nix { });

  bitwig-studio1 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio1.nix {
    inherit (gnome3) zenity;
    libxkbcommon = libxkbcommon_7;
  };
  bitwig-studio2 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio2.nix {
    inherit (pkgs) bitwig-studio1;
  };
  bitwig-studio3 =  callPackage ../applications/audio/bitwig-studio/bitwig-studio3.nix {
    inherit (pkgs) bitwig-studio1;
  };
  bitwig-studio = bitwig-studio3;

  bgpdump = callPackage ../tools/networking/bgpdump { };

  bgpq3 = callPackage ../tools/networking/bgpq3 { };

  blackbox = callPackage ../applications/version-management/blackbox { };

  bleachbit = callPackage ../applications/misc/bleachbit { };

  blender = callPackage  ../applications/misc/blender {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics ForceFeedback OpenAL OpenGL;
  };

  bluefish = callPackage ../applications/editors/bluefish {
    gtk = gtk3;
  };

  bluejeans = callPackage ../applications/networking/browsers/mozilla-plugins/bluejeans { };

  bluejeans-gui = callPackage ../applications/networking/instant-messengers/bluejeans { };

  blugon = callPackage ../applications/misc/blugon { };

  bombono = callPackage ../applications/video/bombono {};

  bomi = libsForQt5.callPackage ../applications/video/bomi {
    ffmpeg = ffmpeg_2;
  };

  bonzomatic = callPackage ../applications/editors/bonzomatic { };

  brackets = callPackage ../applications/editors/brackets { gconf = gnome2.GConf; };

  brave = callPackage ../applications/networking/browsers/brave { };

  breezy = with python3Packages; toPythonApplication breezy;

  notmuch-bower = callPackage ../applications/networking/mailreaders/notmuch-bower { };

  brig = callPackage ../applications/networking/brig { };

  bristol = callPackage ../applications/audio/bristol { };

  bs1770gain = callPackage ../applications/audio/bs1770gain { };

  bsequencer = callPackage ../applications/audio/bsequencer { };

  bslizr = callPackage ../applications/audio/bslizr { };

  bshapr = callPackage ../applications/audio/bshapr { };

  bspwm = callPackage ../applications/window-managers/bspwm { };

  btops = callPackage ../applications/window-managers/btops { };

  bvi = callPackage ../applications/editors/bvi { };

  bviplus = callPackage ../applications/editors/bviplus { };

  cage = callPackage ../applications/window-managers/cage { };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome2) libglade;
  };

  calcurse = callPackage ../applications/misc/calcurse { };

  calculix = callPackage ../applications/science/math/calculix {};

  calibre = libsForQt5.callPackage ../applications/misc/calibre { };

  calligra = libsForQt5.callPackage ../applications/office/calligra {
    inherit (kdeApplications) akonadi-calendar akonadi-contacts;
    openjpeg = openjpeg_1;
    poppler = poppler_0_61;
  };

  perkeep = callPackage ../applications/misc/perkeep {
    # Revision c9f78d02adf9740f3b8d403a1418554293cc9f41 fails to build with go 1.13 due to a dependency:
    #   go: bazil.org/fuse@v0.0.0-20160811212531-371fbbdaa898: Get https://proxy.golang.org/bazil.org/fuse/@v/v0.0.0-20160811212531-371fbbdaa898.mod: dial tcp: lookup proxy.golang.org on [::1]:53: read udp [::1]:36526->[::1]:53: read: connection refused
    buildGoPackage = buildGo112Package;
  };

  canto-curses = callPackage ../applications/networking/feedreaders/canto-curses { };

  canto-daemon = callPackage ../applications/networking/feedreaders/canto-daemon { };

  carddav-util = callPackage ../tools/networking/carddav-util { };

  carla = qt5.callPackage ../applications/audio/carla { };

  catimg = callPackage ../tools/misc/catimg { };

  catt = python3Packages.callPackage ../applications/video/catt { };

  cava = callPackage ../applications/audio/cava { };

  cb2bib = libsForQt5.callPackage ../applications/office/cb2bib { };

  cbatticon = callPackage ../applications/misc/cbatticon { };

  cbc = callPackage ../applications/science/math/cbc { };

  cddiscid = callPackage ../applications/audio/cd-discid {
    inherit (darwin) IOKit;
  };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = callPackage ../applications/audio/cdparanoia {
    inherit (darwin) IOKit;
    inherit (darwin.apple_sdk.frameworks) Carbon;
  };

  centerim = callPackage ../applications/networking/instant-messengers/centerim { };

  cgit = callPackage ../applications/version-management/git-and-tools/cgit {
    inherit (python3Packages) python wrapPython pygments markdown;
  };

  cgminer = callPackage ../applications/misc/cgminer { };

  chirp = callPackage ../applications/radio/chirp { };

  browsh = callPackage ../applications/networking/browsers/browsh { };

  brotab = callPackage ../tools/misc/brotab {
    python = python3;
  };

  bookworm = callPackage ../applications/office/bookworm { };

  chromium = callPackage ../applications/networking/browsers/chromium (config.chromium or {});

  chronos = callPackage ../applications/networking/cluster/chronos { };

  chromiumBeta = lowPrio (chromium.override { channel = "beta"; });

  chromiumDev = lowPrio (chromium.override { channel = "dev"; });

  chuck = callPackage ../applications/audio/chuck {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel;
  };

  cinelerra = callPackage ../applications/video/cinelerra { };

  cipher = callPackage ../applications/misc/cipher { };

  claws-mail = callPackage ../applications/networking/mailreaders/claws-mail {
    inherit (xorg) libSM;
  };
  claws-mail-gtk3 = callPackage ../applications/networking/mailreaders/claws-mail/gtk3.nix {
    inherit (xorg) libSM;
  };

  clfswm = callPackage ../applications/window-managers/clfswm { };

  clickshare-csc1 = callPackage ../applications/video/clickshare-csc1 { };

  cligh = python3Packages.callPackage ../development/tools/github/cligh {};

  clight = callPackage ../applications/misc/clight { };

  clightd = callPackage ../applications/misc/clight/clightd.nix { };

  clipgrab = qt5.callPackage ../applications/video/clipgrab { };

  clipmenu = callPackage ../applications/misc/clipmenu { };

  clipit = callPackage ../applications/misc/clipit { };

  cloud-print-connector = callPackage ../servers/cloud-print-connector { };

  clp = callPackage ../applications/science/math/clp { };

  cmatrix = callPackage ../applications/misc/cmatrix { };

  cmus = callPackage ../applications/audio/cmus {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    libjack = libjack2;
    ffmpeg = ffmpeg_2;
  };

  cmusfm = callPackage ../applications/audio/cmusfm { };

  cni = callPackage ../applications/networking/cluster/cni {};
  cni-plugins = callPackage ../applications/networking/cluster/cni/plugins.nix {};

  cntr = callPackage ../applications/virtualization/cntr { };

  communi = libsForQt5.callPackage ../applications/networking/irc/communi { };

  confclerk = callPackage ../applications/misc/confclerk { };

  copyq = libsForQt5.callPackage ../applications/misc/copyq { };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome2) libgnomeui GConf;
  };

  csa = callPackage ../applications/audio/csa { };

  csound = callPackage ../applications/audio/csound {
    fluidsynth = fluidsynth_1;
  };

  csound-manual = callPackage ../applications/audio/csound/csound-manual {
    python = python27;
    pygments = python27Packages.pygments;
  };

  csound-qt = libsForQt5.callPackage ../applications/audio/csound/csound-qt {
    python = python27;
  };

  codeblocks = callPackage ../applications/editors/codeblocks { };
  codeblocksFull = codeblocks.override { contribPlugins = true; };

  comical = callPackage ../applications/graphics/comical { };

  containerd = callPackage ../applications/virtualization/containerd { };

  convchain = callPackage ../tools/graphics/convchain {};

  coursera-dl = callPackage ../applications/misc/coursera-dl {};

  coyim = callPackage ../applications/networking/instant-messengers/coyim {};

  cq-editor = libsForQt5.callPackage ../applications/graphics/cq-editor { };

  cpp_ethereum = callPackage ../applications/misc/cpp-ethereum { };

  crun = callPackage ../applications/virtualization/crun {};

  csdp = callPackage ../applications/science/math/csdp { };

  ctop = callPackage ../tools/system/ctop { };

  cubicsdr = callPackage ../applications/radio/cubicsdr { wxGTK = wxGTK31; };

  cum = callPackage ../applications/misc/cum { };

  cuneiform = callPackage ../tools/graphics/cuneiform {};

  curseradio = callPackage ../applications/audio/curseradio { };

  cutecom = libsForQt5.callPackage ../tools/misc/cutecom { };

  cvs = callPackage ../applications/version-management/cvs { };

  cvsps = callPackage ../applications/version-management/cvsps { };

  cvsq = callPackage ../applications/version-management/cvsq { };

  cvs2svn = callPackage ../applications/version-management/cvs2svn { };

  cwm = callPackage ../applications/window-managers/cwm { };

  cyclone = callPackage ../applications/audio/pd-plugins/cyclone  { };

  dablin = callPackage ../applications/radio/dablin { };

  darcs = haskell.lib.overrideCabal (haskell.lib.justStaticExecutables haskellPackages.darcs) (drv: {
    configureFlags = (stdenv.lib.remove "-flibrary" drv.configureFlags or []) ++ ["-f-library"];
  });

  darktable = callPackage ../applications/graphics/darktable {
    lua = lua5_3;
    pugixml = pugixml.override { shared = true; };
  };

  das_watchdog = callPackage ../tools/system/das_watchdog { };

  dbvisualizer = callPackage ../applications/misc/dbvisualizer {};

  dd-agent = callPackage ../tools/networking/dd-agent/5.nix { };
  datadog-agent = callPackage ../tools/networking/dd-agent/datadog-agent.nix {
    pythonPackages = datadog-integrations-core {};
  };
  datadog-process-agent = callPackage ../tools/networking/dd-agent/datadog-process-agent.nix { };
  datadog-integrations-core = extras: callPackage ../tools/networking/dd-agent/integrations-core.nix {
    python = python27;
    extraIntegrations = extras;
  };

  ddgr = callPackage ../applications/misc/ddgr { };

  deadbeef = callPackage ../applications/audio/deadbeef { };

  deadbeefPlugins = {
    headerbar-gtk3 = callPackage ../applications/audio/deadbeef/plugins/headerbar-gtk3.nix { };
    infobar = callPackage ../applications/audio/deadbeef/plugins/infobar.nix { };
    lyricbar = callPackage ../applications/audio/deadbeef/plugins/lyricbar.nix { };
    mpris2 = callPackage ../applications/audio/deadbeef/plugins/mpris2.nix { };
  };

  deadbeef-with-plugins = callPackage ../applications/audio/deadbeef/wrapper.nix {
    plugins = [];
  };

  dfasma = libsForQt5.callPackage ../applications/audio/dfasma { };

  dfilemanager = libsForQt5.callPackage ../applications/misc/dfilemanager { };

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome2) libart_lgpl libgnomeui;
  };

  direwolf = callPackage ../applications/misc/direwolf { };

  dirt = callPackage ../applications/audio/dirt {};

  distrho = callPackage ../applications/audio/distrho {};

  dit = callPackage ../applications/editors/dit { };

  djvulibre = callPackage ../applications/misc/djvulibre { };

  djvu2pdf = callPackage ../tools/typesetting/djvu2pdf { };

  djview = libsForQt5.callPackage ../applications/graphics/djview { };
  djview4 = pkgs.djview;

  dmenu = callPackage ../applications/misc/dmenu { };
  dmenu-wayland = callPackage ../applications/misc/dmenu/wayland.nix { };

  dmensamenu = callPackage ../applications/misc/dmensamenu {
    inherit (python3Packages) buildPythonApplication requests;
  };

  dmrconfig = callPackage ../applications/radio/dmrconfig { };

  dmtx-utils = callPackage (callPackage ../tools/graphics/dmtx-utils) {
  };

  inherit (callPackage ../applications/virtualization/docker {})
    docker_18_09
    docker_19_03;

  docker = docker_19_03;
  docker-edge = docker_19_03;

  docker-proxy = callPackage ../applications/virtualization/docker/proxy.nix { };

  docker-gc = callPackage ../applications/virtualization/docker/gc.nix { };

  docker-machine = callPackage ../applications/networking/cluster/docker-machine { };
  docker-machine-hyperkit = callPackage ../applications/networking/cluster/docker-machine/hyperkit.nix { };
  docker-machine-kvm = callPackage ../applications/networking/cluster/docker-machine/kvm.nix { };
  docker-machine-kvm2 = callPackage ../applications/networking/cluster/docker-machine/kvm2.nix { };
  docker-machine-xhyve = callPackage ../applications/networking/cluster/docker-machine/xhyve.nix {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
    inherit (darwin) cctools;
  };

  docker-distribution = callPackage ../applications/virtualization/docker/distribution.nix { };

  amazon-ecr-credential-helper = callPackage ../tools/admin/amazon-ecr-credential-helper { };

  docker-credential-gcr = callPackage ../tools/admin/docker-credential-gcr { };

  docker-credential-helpers = callPackage ../tools/admin/docker-credential-helpers { };

  doodle = callPackage ../applications/search/doodle { };

  dr14_tmeter = callPackage ../applications/audio/dr14_tmeter { };

  draftsight = callPackage ../applications/graphics/draftsight { };

  dragonfly-reverb = callPackage ../applications/audio/dragonfly-reverb { };

  drawing = callPackage ../applications/graphics/drawing { };

  drawio = callPackage ../applications/graphics/drawio {};

  drawpile = libsForQt5.callPackage ../applications/graphics/drawpile { };
  drawpile-server-headless = libsForQt5.callPackage ../applications/graphics/drawpile {
    buildClient = false;
    buildServerGui = false;
  };

  droopy = callPackage ../applications/networking/droopy {
    inherit (python3Packages) wrapPython;
  };

  drumgizmo = callPackage ../applications/audio/drumgizmo { };

  dunst = callPackage ../applications/misc/dunst { };

  du-dust = callPackage ../tools/misc/dust { };

  devede = callPackage ../applications/video/devede { };

  denemo = callPackage ../applications/audio/denemo { };

  dvb_apps  = callPackage ../applications/video/dvb-apps { };

  dvdauthor = callPackage ../applications/video/dvdauthor { };

  dvdbackup = callPackage ../applications/video/dvdbackup { };

  dvd-slideshow = callPackage ../applications/video/dvd-slideshow { };

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

  dynamips = callPackage ../applications/virtualization/dynamips { };

  evilwm = callPackage ../applications/window-managers/evilwm {
    patches = config.evilwm.patches or [];
  };

  dzen2 = callPackage ../applications/window-managers/dzen2 { };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  echoip = callPackage ../servers/echoip { };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse {
    jdk = jdk11;
  });

  ecs-agent = callPackage ../applications/virtualization/ecs-agent { };

  ed = callPackage ../applications/editors/ed { };

  edbrowse = callPackage ../applications/editors/edbrowse { };

  ekho = callPackage ../applications/audio/ekho { };

  electron-cash = libsForQt5.callPackage ../applications/misc/electron-cash { };

  electrum = libsForQt5.callPackage ../applications/misc/electrum { };

  electrum-dash = callPackage ../applications/misc/electrum/dash.nix { };

  electrum-ltc = callPackage ../applications/misc/electrum/ltc.nix { };

  elementary-planner = callPackage ../applications/office/elementary-planner { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs26;
  emacsPackages = emacs26Packages;
  emacs-nox = emacs26-nox;

  emacs26 = callPackage ../applications/editors/emacs {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
  };

  emacs26-nox = lowPrio (appendToName "nox" (emacs26.override {
    withX = false;
    withNS = false;
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
    inherit (darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
  };

  emacs25-nox = lowPrio (appendToName "nox" (emacs25.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacsMacport = callPackage ../applications/editors/emacs/macport.nix {
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
    stdenv = if stdenv.cc.isClang then llvmPackages_6.stdenv else stdenv;
  };

  emacsPackagesFor = emacs: import ./emacs-packages.nix {
    inherit lib newScope stdenv pkgs;
    inherit fetchFromGitHub fetchurl;
    inherit emacs texinfo makeWrapper runCommand writeText;
    inherit (xorg) lndir;

    trivialBuild = callPackage ../build-support/emacs/trivial.nix {
      inherit emacs;
    };

    melpaBuild = callPackage ../build-support/emacs/melpa.nix {
      inherit emacs;
    };

    external = {
      inherit (haskellPackages)
        ghc-mod structured-haskell-mode Agda hindent;
      inherit
        autoconf automake editorconfig-core-c git libffi libpng pkgconfig
        poppler rtags w3m zlib substituteAll rustPlatform cmake llvmPackages
        libtool zeromq openssl;
    };
  };

  emacs25Packages = dontRecurseIntoAttrs (emacsPackagesFor emacs25);
  emacs26Packages = dontRecurseIntoAttrs (emacsPackagesFor emacs26);

  emacs25WithPackages = emacs25Packages.emacsWithPackages;
  emacs26WithPackages = emacs26Packages.emacsWithPackages;
  emacsWithPackages = emacsPackages.emacsWithPackages;

  inherit (gnome3) empathy;

  enhanced-ctorrent = callPackage ../applications/networking/enhanced-ctorrent { };

  envelope = callPackage ../applications/office/envelope { };

  eolie = callPackage ../applications/networking/browsers/eolie { };

  epdfview = callPackage ../applications/misc/epdfview { };

  epeg = callPackage ../applications/graphics/epeg { };

  inherit (gnome3) epiphany;

  ephemeral = callPackage ../applications/networking/browsers/ephemeral { };

  epic5 = callPackage ../applications/networking/irc/epic5 { };

  epr = callPackage ../applications/misc/epr { };

  eq10q = callPackage ../applications/audio/eq10q { };

  errbot = callPackage ../applications/networking/errbot {
    python = python3;
  };

  espeak-classic = callPackage ../applications/audio/espeak { };

  espeak-ng = callPackage ../applications/audio/espeak-ng { };
  espeak = res.espeak-ng;

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  esniper = callPackage ../applications/networking/esniper { };

  eterm = callPackage ../applications/misc/eterm { };

  eteroj.lv2 = libsForQt5.callPackage ../applications/audio/eteroj.lv2 { };

  etesync-dav = callPackage ../applications/misc/etesync-dav {};

  etherape = callPackage ../applications/networking/sniffers/etherape { };

  evilvte = callPackage ../applications/misc/evilvte (config.evilvte or {});

  exercism = callPackage ../applications/misc/exercism { };

  go-motion = callPackage ../development/tools/go-motion { };

  gpg-mdp = callPackage ../applications/misc/gpg-mdp { };

  icesl = callPackage ../applications/misc/icesl { };

  keepassx = callPackage ../applications/misc/keepassx { };
  keepassx2 = callPackage ../applications/misc/keepassx/2.0.nix { };
  keepassxc = libsForQt5.callPackage ../applications/misc/keepassx/community.nix { };

  inherit (gnome3) evince;
  evolution-data-server = gnome3.evolution-data-server;

  keepass = callPackage ../applications/misc/keepass { };

  keepass-keeagent = callPackage ../applications/misc/keepass-plugins/keeagent { };

  keepass-keepasshttp = callPackage ../applications/misc/keepass-plugins/keepasshttp { };

  keepass-keepassrpc = callPackage ../applications/misc/keepass-plugins/keepassrpc { };

  keepass-otpkeyprov = callPackage ../applications/misc/keepass-plugins/otpkeyprov { };

  exrdisplay = callPackage ../applications/graphics/exrdisplay { };

  exrtools = callPackage ../applications/graphics/exrtools { };

  fasttext = callPackage ../applications/science/machine-learning/fasttext { };

  fbpanel = callPackage ../applications/window-managers/fbpanel { };

  fbreader = callPackage ../applications/misc/fbreader {
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  fdr = libsForQt5.callPackage ../applications/science/programming/fdr { };

  fehlstart = callPackage ../applications/misc/fehlstart { };

  fetchmail = callPackage ../applications/misc/fetchmail { };

  fff = callPackage ../applications/misc/fff { };

  fig2dev = callPackage ../applications/graphics/fig2dev { };

  FIL-plugins = callPackage ../applications/audio/FIL-plugins { };

  flacon = libsForQt5.callPackage ../applications/audio/flacon { };

  flexget = callPackage ../applications/networking/flexget { };

  fldigi = callPackage ../applications/radio/fldigi { };

  flink = callPackage ../applications/networking/cluster/flink { };
  flink_1_5 = flink.override { version = "1.5"; };

  fllog = callPackage ../applications/radio/fllog { };

  flmsg = callPackage ../applications/radio/flmsg { };

  flrig = callPackage ../applications/radio/flrig { };

  fluxus = callPackage ../applications/graphics/fluxus { };

  flwrap = callPackage ../applications/radio/flwrap { };

  fluidsynth = callPackage ../applications/audio/fluidsynth {
     inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio CoreMIDI CoreServices;
  };
  fluidsynth_1 = fluidsynth.override { version = "1"; };

  fmit = libsForQt5.callPackage ../applications/audio/fmit { };

  fmsynth = callPackage ../applications/audio/fmsynth { };

  focuswriter = libsForQt5.callPackage ../applications/editors/focuswriter { };

  fondo = callPackage ../applications/graphics/fondo { };

  font-manager = callPackage ../applications/misc/font-manager { };

  foo-yc20 = callPackage ../applications/audio/foo-yc20 { };

  fossil = callPackage ../applications/version-management/fossil { };

  freebayes = callPackage ../applications/science/biology/freebayes { };

  freewheeling = callPackage ../applications/audio/freewheeling { };

  fribid = callPackage ../applications/networking/browsers/mozilla-plugins/fribid {
    openssl = openssl_1_0_2;
  };

  fritzing = libsForQt5.callPackage ../applications/science/electronics/fritzing { };

  fsv = callPackage ../applications/misc/fsv { };

  ft2-clone = callPackage ../applications/audio/ft2-clone { };

  fvwm = callPackage ../applications/window-managers/fvwm { };

  ganttproject-bin = callPackage ../applications/misc/ganttproject-bin { };

  gauche = callPackage ../development/interpreters/gauche { };

  gcal = callPackage ../applications/misc/gcal { };

  geany = callPackage ../applications/editors/geany { };
  geany-with-vte = callPackage ../applications/editors/geany/with-vte.nix { };

  geoipupdate = callPackage ../applications/misc/geoipupdate/default.nix { };

  ghostwriter = libsForQt5.callPackage ../applications/editors/ghostwriter { };

  gitweb = callPackage ../applications/version-management/git-and-tools/gitweb { };

  gksu = callPackage ../applications/misc/gksu { };

  gnss-sdr = callPackage ../applications/radio/gnss-sdr { boost=boost166; };

  gnuradio = callPackage ../applications/radio/gnuradio {
    inherit (python2Packages) cheetah lxml Mako matplotlib numpy python pyopengl pyqt4 scipy wxPython pygtk;
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    fftw = fftwFloat;
    qwt = qwt6_qt4;
  };

  gnuradio-with-packages = callPackage ../applications/radio/gnuradio/wrapper.nix {
    inherit (python2Packages) python;
    extraPackages = [ gr-nacl gr-osmosdr gr-ais gr-rds ]
      ++ lib.optionals stdenv.isLinux [ gr-gsm gr-limesdr ];
  };

  grandorgue = callPackage ../applications/audio/grandorgue { };

  gr-nacl = callPackage ../applications/radio/gnuradio/nacl.nix { };

  gr-gsm = callPackage ../applications/radio/gnuradio/gsm.nix { };

  gr-ais = callPackage ../applications/radio/gnuradio/ais.nix { };

  gr-limesdr = callPackage ../applications/radio/gnuradio/limesdr.nix { };

  gr-rds = callPackage ../applications/radio/gnuradio/rds.nix { };

  gr-osmosdr = callPackage ../applications/radio/gnuradio/osmosdr.nix { };

  goldendict = libsForQt5.callPackage ../applications/misc/goldendict {
    inherit (darwin) libiconv;
  };

  gomuks = callPackage ../applications/networking/instant-messengers/gomuks { };

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

  goxel = callPackage ../applications/graphics/goxel { };

  gpa = callPackage ../applications/misc/gpa { };

  gpicview = callPackage ../applications/graphics/gpicview {
    gtk2 = gtk2-x11;
  };

  gpx = callPackage ../applications/misc/gpx { };

  gqrx = qt5.callPackage ../applications/radio/gqrx { };

  gpx-viewer = callPackage ../applications/misc/gpx-viewer { };

  grass = callPackage ../applications/gis/grass { };

  grepcidr = callPackage ../applications/search/grepcidr { };

  grepm = callPackage ../applications/search/grepm { };

  grip-search = callPackage ../tools/text/grip-search { };

  grip = callPackage ../applications/misc/grip {
    inherit (gnome2) libgnome libgnomeui vte;
  };

  gsimplecal = callPackage ../applications/misc/gsimplecal { };

  gthumb = callPackage ../applications/graphics/gthumb { };

  gtimelog = pythonPackages.gtimelog;

  inherit (gnome3) gucharmap;

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  gjay = callPackage ../applications/audio/gjay { };

  photivo = callPackage ../applications/graphics/photivo { };

  rhythmbox = callPackage ../applications/audio/rhythmbox { };

  gradio = callPackage ../applications/audio/gradio { };

  puddletag = callPackage ../applications/audio/puddletag { };

  w_scan = callPackage ../applications/video/w_scan { };

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wavrsocvt = callPackage ../applications/misc/audio/wavrsocvt { };

  welle-io = libsForQt5.callPackage ../applications/radio/welle-io { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices SystemConfiguration;
  };
  wireshark-qt = wireshark;

  # The GTK UI is deprecated by upstream. You probably want the QT version.
  wireshark-gtk = throw "wireshark-gtk is not supported anymore. Use wireshark-qt or wireshark-cli instead.";
  wireshark-cli = wireshark.override { withQt = false; };

  sngrep = callPackage ../applications/networking/sniffers/sngrep {};

  termshark = callPackage ../tools/networking/termshark { };

  fbida = callPackage ../applications/graphics/fbida { };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  filezilla = callPackage ../applications/networking/ftp/filezilla { };

  firefoxPackages = recurseIntoAttrs (callPackage ../applications/networking/browsers/firefox/packages.nix {
    callPackage = pkgs.newScope {
      inherit (gnome2) libIDL;
      libpng = libpng_apng;
      python = python2;
      gnused = gnused_422;
      inherit (darwin.apple_sdk.frameworks) CoreMedia ExceptionHandling
                                            Kerberos AVFoundation MediaToolbox
                                            CoreLocation Foundation AddressBook;
      inherit (darwin) libobjc;
    };
  });

  firefox-unwrapped = firefoxPackages.firefox;
  firefox-esr-68-unwrapped = firefoxPackages.firefox-esr-68;
  firefox = wrapFirefox firefox-unwrapped { };
  firefox-wayland = wrapFirefox firefox-unwrapped { gdkWayland = true; };
  firefox-esr-68 = wrapFirefox firefox-esr-68-unwrapped { };
  firefox-esr = firefox-esr-68;

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    channel = "release";
    generated = import ../applications/networking/browsers/firefox-bin/release_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
  };

  firefox-bin = wrapFirefox firefox-bin-unwrapped {
    browserName = "firefox";
    pname = "firefox-bin";
    desktopName = "Firefox";
  };

  firefox-beta-bin-unwrapped = firefox-bin-unwrapped.override {
    channel = "beta";
    generated = import ../applications/networking/browsers/firefox-bin/beta_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
  };

  firefox-beta-bin = res.wrapFirefox firefox-beta-bin-unwrapped {
    browserName = "firefox";
    pname = "firefox-beta-bin";
    desktopName = "Firefox Beta";
  };

  firefox-devedition-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    channel = "devedition";
    generated = import ../applications/networking/browsers/firefox-bin/devedition_sources.nix;
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
  };

  firefox-devedition-bin = res.wrapFirefox firefox-devedition-bin-unwrapped {
    browserName = "firefox";
    nameSuffix = "-devedition";
    pname = "firefox-devedition-bin";
    desktopName = "Firefox DevEdition";
  };

  flac = callPackage ../applications/audio/flac { };

  redoflacs = callPackage ../applications/audio/redoflacs { };

  flameshot = libsForQt5.callPackage ../tools/misc/flameshot { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer (config.flashplayer or {});

  flashplayer-standalone = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer/standalone.nix (config.flashplayer or {});

  flashplayer-standalone-debugger = flashplayer-standalone.override {
    debug = true;
  };

  fluxbox = callPackage ../applications/window-managers/fluxbox { };

  fme = callPackage ../applications/misc/fme {
    inherit (gnome2) libglademm;
  };

  fomp = callPackage ../applications/audio/fomp { };

  formatter = callPackage ../applications/misc/formatter { };

  foxtrotgps = callPackage ../applications/misc/foxtrotgps { };

  fractal = callPackage ../applications/networking/instant-messengers/fractal { };

  freecad = qt5.callPackage ../applications/graphics/freecad { mpi = openmpi; };

  freemind = callPackage ../applications/misc/freemind { };

  freenet = callPackage ../applications/networking/p2p/freenet { };

  freeoffice = callPackage ../applications/office/softmaker/freeoffice.nix {};

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
  inherit (xorg) xlsfonts;

  xrdp = callPackage ../applications/networking/remote/xrdp { };

  freerdp = callPackage ../applications/networking/remote/freerdp {
    inherit libpulseaudio;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  freerdpUnstable = freerdp;

  friture = libsForQt5.callPackage ../applications/audio/friture { };

  fte = callPackage ../applications/editors/fte { };

  game-music-emu = callPackage ../applications/audio/game-music-emu { };

  gavrasm = callPackage ../development/compilers/gavrasm { };

  gcalcli = callPackage ../applications/misc/gcalcli { };

  vcal = callPackage ../applications/misc/vcal { };

  gcolor2 = callPackage ../applications/graphics/gcolor2 { };

  gcolor3 = callPackage ../applications/graphics/gcolor3 { };

  get_iplayer = callPackage ../applications/misc/get_iplayer {};

  getxbook = callPackage ../applications/misc/getxbook { };

  gimp = callPackage ../applications/graphics/gimp {
    gegl = gegl_0_4;
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

  gitAndTools = recurseIntoAttrs (callPackage ../applications/version-management/git-and-tools {});

  inherit (gitAndTools) git gitFull gitSVN git-cola svn2git git-radar git-secret git-secrets transcrypt git-crypt ghq;

  gitMinimal = git.override {
    withManual = false;
    pythonSupport = false;
    withpcre2 = false;
  };

  gitRepo = callPackage ../applications/version-management/git-repo { };

  git-quick-stats = callPackage ../development/tools/git-quick-stats {};

  git-review = callPackage ../applications/version-management/git-review { };

  gitolite = callPackage ../applications/version-management/gitolite { };

  inherit (gnome3) gitg;

  gmrun = callPackage ../applications/misc/gmrun {};

  gnucash = callPackage ../applications/office/gnucash { };

  goffice = callPackage ../development/libraries/goffice { };

  jetbrains = (recurseIntoAttrs (callPackages ../applications/editors/jetbrains {
    jdk = jetbrains.jdk;
  }) // {
    jdk = callPackage ../development/compilers/jetbrains-jdk {  };
  });

  libquvi = callPackage ../applications/video/quvi/library.nix { };

  linssid = libsForQt5.callPackage ../applications/networking/linssid { };

  lollypop = callPackage ../applications/audio/lollypop { };

  m32edit = callPackage ../applications/audio/midas/m32edit.nix {};

  manim = python37Packages.callPackage ../applications/video/manim {
    opencv = python37Packages.opencv3;
  };

  manuskript = libsForQt5.callPackage ../applications/editors/manuskript { };

  manul = callPackage ../development/tools/manul { };

  mindforger = libsForQt5.callPackage ../applications/editors/mindforger { };

  mi2ly = callPackage ../applications/audio/mi2ly {};

  moe =  callPackage ../applications/editors/moe { };

  multibootusb = qt5.callPackage ../applications/misc/multibootusb {};

  praat = callPackage ../applications/audio/praat { };

  quvi = callPackage ../applications/video/quvi/tool.nix {
    lua5_sockets = lua51Packages.luasocket;
    lua5 = lua5_1;
  };

  quvi_scripts = callPackage ../applications/video/quvi/scripts.nix { };

  rhvoice = callPackage ../applications/audio/rhvoice { };

  svox = callPackage ../applications/audio/svox { };

  giada = callPackage ../applications/audio/giada {};

  gkrellm = callPackage ../applications/misc/gkrellm {
    inherit (darwin) IOKit;
  };

  glow = callPackage ../applications/editors/glow { };

  glowing-bear = callPackage ../applications/networking/irc/glowing-bear { };

  gmtk = callPackage ../development/libraries/gmtk { };

  gmu = callPackage ../applications/audio/gmu { };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer { };

  gnumeric = callPackage ../applications/office/gnumeric { };

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

  grisbi = callPackage ../applications/office/grisbi { gtk = gtk3; };

  gtkpod = callPackage ../applications/audio/gtkpod { };

  jbidwatcher = callPackage ../applications/misc/jbidwatcher {
    java = if stdenv.isLinux then jre else jdk;
  };

  qrencode = callPackage ../development/libraries/qrencode { };

  geeqie = callPackage ../applications/graphics/geeqie { };

  gigedit = callPackage ../applications/audio/gigedit { };

  gqview = callPackage ../applications/graphics/gqview { };

  gmpc = callPackage ../applications/audio/gmpc {};

  gmtp = callPackage ../applications/misc/gmtp {};

  gnomecast = callPackage ../applications/video/gnomecast { };

  celluloid = callPackage ../applications/video/celluloid { };

  gnome-recipes = callPackage ../applications/misc/gnome-recipes {
    inherit (gnome3) gnome-autoar;
  };

  gollum = callPackage ../applications/misc/gollum { };

  googleearth = callPackage ../applications/misc/googleearth { };

  google-chrome = callPackage ../applications/networking/browsers/google-chrome { gconf = gnome2.GConf; };

  google-chrome-beta = google-chrome.override { chromium = chromiumBeta; channel = "beta"; };

  google-chrome-dev = google-chrome.override { chromium = chromiumDev; channel = "dev"; };

  google-play-music-desktop-player = callPackage ../applications/audio/google-play-music-desktop-player {
    inherit (gnome2) GConf;
  };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin {
    libpng = libpng12;
  };

  gosmore = callPackage ../applications/misc/gosmore { };

  gpsbabel = libsForQt5.callPackage ../applications/misc/gpsbabel {
    inherit (darwin) IOKit;
  };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate { };

  gpsd = callPackage ../servers/gpsd { };

  gpsprune = callPackage ../applications/misc/gpsprune { };

  gpxlab = libsForQt5.callPackage ../applications/misc/gpxlab { };

  gpxsee = libsForQt5.callPackage ../applications/misc/gpxsee { };

  gspell = callPackage ../development/libraries/gspell { };

  gtk2fontsel = callPackage ../applications/misc/gtk2fontsel { };

  guake = callPackage ../applications/misc/guake { };

  guardian-agent = callPackage ../tools/networking/guardian-agent { };

  guitone = callPackage ../applications/version-management/guitone {
    graphviz = graphviz_2_32;
  };

  gv = callPackage ../applications/misc/gv { };

  gvisor = callPackage ../applications/virtualization/gvisor { };

  gvisor-containerd-shim = callPackage ../applications/virtualization/gvisor/containerd-shim.nix { };

  guvcview = callPackage ../os-specific/linux/guvcview { };

  gxmessage = callPackage ../applications/misc/gxmessage { };

  gxmatcheq-lv2 = callPackage ../applications/audio/gxmatcheq-lv2 { };

  gxplugins-lv2 = callPackage ../applications/audio/gxplugins-lv2 { };

  hackrf = callPackage ../applications/radio/hackrf { };

  hakuneko = callPackage ../tools/misc/hakuneko { };

  hashit = callPackage ../tools/misc/hashit { };

  heimer = libsForQt5.callPackage ../applications/misc/heimer { };

  hello = callPackage ../applications/misc/hello { };
  hello-unfree = callPackage ../applications/misc/hello-unfree { };

  helmholtz = callPackage ../applications/audio/pd-plugins/helmholtz { };

  heme = callPackage ../applications/editors/heme { };

  herbstluftwm = callPackage ../applications/window-managers/herbstluftwm { };

  hercules = callPackage ../applications/virtualization/hercules { };

  hexchat = callPackage ../applications/networking/irc/hexchat { };

  hexcurse = callPackage ../applications/editors/hexcurse { };

  hexdino = callPackage ../applications/editors/hexdino { };

  hexedit = callPackage ../applications/editors/hexedit { };

  hipchat = callPackage ../applications/networking/instant-messengers/hipchat { };

  hledger = haskell.lib.justStaticExecutables haskellPackages.hledger;
  hledger-iadd = haskell.lib.justStaticExecutables haskellPackages.hledger-iadd;
  hledger-interest = haskell.lib.justStaticExecutables haskellPackages.hledger-interest;
  hledger-ui = haskell.lib.justStaticExecutables haskellPackages.hledger-ui;
  hledger-web = haskell.lib.justStaticExecutables haskellPackages.hledger-web;

  homebank = callPackage ../applications/office/homebank {
    gtk = gtk3;
  };

  hovercraft = python3Packages.callPackage ../applications/misc/hovercraft { };

  howl = callPackage ../applications/editors/howl { };

  hpl = callPackage ../tools/misc/hpl { mpi = openmpi; };

  hpmyroom = libsForQt5.callPackage ../applications/networking/hpmyroom { };

  ht = callPackage ../applications/editors/ht { };

  hubstaff = callPackage ../applications/misc/hubstaff { };

  hue-cli = callPackage ../tools/networking/hue-cli { };

  inherit (nodePackages) hueadm;

  hugin = callPackage ../applications/graphics/hugin {
    wxGTK = wxGTK30;
  };

  hugo = callPackage ../applications/misc/hugo { };

  hydrogen = callPackage ../applications/audio/hydrogen { };

  hydroxide = callPackage ../applications/networking/hydroxide { };

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

  hyperledger-fabric = callPackage ../tools/misc/hyperledger-fabric { };

  jackline = callPackage ../applications/networking/instant-messengers/jackline { };

  leftwm = callPackage ../applications/window-managers/leftwm { };

  pinboard-notes-backup = haskell.lib.overrideCabal
    (haskell.lib.generateOptparseApplicativeCompletion "pnbackup"
      haskellPackages.pinboard-notes-backup)
    (drv: {
      postInstall = ''
        install -D man/pnbackup.1 $out/share/man/man1/pnbackup.1
      '' + (drv.postInstall or "");
    });

  slack = callPackage ../applications/networking/instant-messengers/slack { };

  slack-cli = callPackage ../tools/networking/slack-cli { };

  slack-term = callPackage ../applications/networking/instant-messengers/slack-term { };

  singularity = callPackage ../applications/virtualization/singularity { };

  spectmorph = callPackage ../applications/audio/spectmorph { };

  spectrwm = callPackage ../applications/window-managers/spectrwm { };

  spectral = qt5.callPackage ../applications/networking/instant-messengers/spectral { };

  spotifyd = callPackage ../applications/audio/spotifyd {
    withALSA = stdenv.isLinux;
    withPulseAudio = config.pulseaudio or stdenv.isLinux;
    withPortAudio = stdenv.isDarwin;
  };

  super-productivity = callPackage ../applications/networking/super-productivity { };

  wlr-randr = callPackage ../tools/misc/wlr-randr { };

  wlroots = callPackage ../development/libraries/wlroots { };

  sway-unwrapped = callPackage ../applications/window-managers/sway { };
  sway = callPackage ../applications/window-managers/sway/wrapper.nix { };
  swaybg = callPackage ../applications/window-managers/sway/bg.nix { };
  swayidle = callPackage ../applications/window-managers/sway/idle.nix { };
  swaylock = callPackage ../applications/window-managers/sway/lock.nix { };

  swaylock-fancy = callPackage ../applications/window-managers/sway/lock-fancy.nix { };

  waybar = callPackage ../applications/misc/waybar {
    pulseSupport = config.pulseaudio or false;
  };

  i3 = callPackage ../applications/window-managers/i3 {
    xcb-util-cursor = if stdenv.isDarwin then xcb-util-cursor-HEAD else xcb-util-cursor;
  };

  i3-gaps = callPackage ../applications/window-managers/i3/gaps.nix { };

  i3-easyfocus = callPackage ../applications/window-managers/i3/easyfocus.nix { };

  i3-layout-manager = callPackage ../applications/window-managers/i3/layout-manager.nix { };

  i3blocks = callPackage ../applications/window-managers/i3/blocks.nix { };

  i3blocks-gaps = callPackage ../applications/window-managers/i3/blocks-gaps.nix { };

  i3cat = callPackage ../tools/misc/i3cat { };

  i3ipc-glib = callPackage ../applications/window-managers/i3/i3ipc-glib.nix { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

  i3lock-color = callPackage ../applications/window-managers/i3/lock-color.nix { };

  i3lock-fancy = callPackage ../applications/window-managers/i3/lock-fancy.nix { };

  i3lock-pixeled = callPackage ../misc/screensavers/i3lock-pixeled { };

  betterlockscreen = callPackage ../misc/screensavers/betterlockscreen {
    inherit (xorg) xrdb;
  };

  i3minator = callPackage ../tools/misc/i3minator { };

  i3pystatus = callPackage ../applications/window-managers/i3/pystatus.nix { };

  i3status = callPackage ../applications/window-managers/i3/status.nix { };

  i3status-rust = callPackage ../applications/window-managers/i3/status-rust.nix { };

  i3-wk-switch = callPackage ../applications/window-managers/i3/wk-switch.nix { };

  wmfocus = callPackage ../applications/window-managers/i3/wmfocus.nix { };

  wmfs = callPackage ../applications/window-managers/wmfs/default.nix { };

  i810switch = callPackage ../os-specific/linux/i810switch { };

  icewm = callPackage ../applications/window-managers/icewm {};

  id3v2 = callPackage ../applications/audio/id3v2 { };

  ifenslave = callPackage ../os-specific/linux/ifenslave { };

  ii = callPackage ../applications/networking/irc/ii {
    stdenv = gccStdenv;
  };

  ike = callPackage ../applications/networking/ike { };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    inherit (perlPackages.override { pkgs = pkgs // { imagemagick = imagemagickBig;}; }) PerlMagick;
  };

  iksemel = callPackage ../development/libraries/iksemel { };

  imagej = callPackage ../applications/graphics/imagej { };

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
    djvulibre = null;
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
    djvulibre = null;
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

  img2pdf = callPackage ../applications/misc/img2pdf { };

  imgcat = callPackage ../applications/graphics/imgcat { };

  imgp = python3Packages.callPackage ../applications/graphics/imgp { };

  # Impressive, formerly known as "KeyJNote".
  impressive = callPackage ../applications/office/impressive { };

  inkscape = callPackage ../applications/graphics/inkscape {
    lcms = lcms2;
  };

  inspectrum = libsForQt5.callPackage ../applications/radio/inspectrum { };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5_1;
  };

  ipe = libsForQt5.callPackage ../applications/graphics/ipe {
    ghostscript = ghostscriptX;
    texlive = texlive.combine { inherit (texlive) scheme-small; };
    lua5 = lua5_3;
  };

  iptraf = callPackage ../applications/networking/iptraf { };

  iptraf-ng = callPackage ../applications/networking/iptraf-ng { };

  irccloud = callPackage ../applications/networking/irc/irccloud { };

  irssi = callPackage ../applications/networking/irc/irssi { };

  irssi_fish = callPackage ../applications/networking/irc/irssi/fish { };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  bip = callPackage ../applications/networking/irc/bip { };

  j4-dmenu-desktop = callPackage ../applications/misc/j4-dmenu-desktop { };

  jabref = callPackage ../applications/office/jabref { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jack_oscrolloscope = callPackage ../applications/audio/jack-oscrolloscope { };

  jack_rack = callPackage ../applications/audio/jack-rack { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jackmix = callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = jackmix.override { jack = jack1; };

  jalv = callPackage ../applications/audio/jalv { };

  jameica = callPackage ../applications/office/jameica {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  jamin = callPackage ../applications/audio/jamin { };

  japa = callPackage ../applications/audio/japa { };

  dupd = callPackage ../tools/misc/dupd { };

  jdupes = callPackage ../tools/misc/jdupes { };

  jedit = callPackage ../applications/editors/jedit { };

  jgmenu = callPackage ../applications/misc/jgmenu { };

  jigdo = callPackage ../applications/misc/jigdo { };

  jitsi = callPackage ../applications/networking/instant-messengers/jitsi { };

  joe = callPackage ../applications/editors/joe { };

  josm = callPackage ../applications/misc/josm { };

  jwm = callPackage ../applications/window-managers/jwm { };

  jwm-settings-manager = callPackage ../applications/window-managers/jwm/jwm-settings-manager.nix { };

  k3d = callPackage ../applications/graphics/k3d {
    inherit (pkgs.gnome2) gtkglext;
    stdenv = gcc6Stdenv;
    boost = boost155.override { enablePython = true; };
  };

  k9copy = libsForQt5.callPackage ../applications/video/k9copy {};

  kail = callPackage ../tools/networking/kail {  };

  kanboard = callPackage ../applications/misc/kanboard { };

  kanshi = callPackage ../tools/misc/kanshi { };

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
    kaddressbook kate kcachegrind kcalc kcharselect kcolorchooser kdenlive kdf kdialog
    keditbookmarks kfind kget kgpg khelpcenter kig kleopatra kmail kmix kmplot kolourpaint kompare konsole yakuake
    kpkpass kitinerary kontact korganizer krdc krfb ksystemlog ktouch kwalletmanager marble minuet okular spectacle;

  okteta = libsForQt5.callPackage ../applications/editors/okteta { };

  kdeconnect = libsForQt5.callPackage ../applications/misc/kdeconnect { };

  kdecoration-viewer = libsForQt5.callPackage ../tools/misc/kdecoration-viewer { };

  inherit (kdeFrameworks) kdesu;

  kdevelop-pg-qt = libsForQt5.callPackage ../applications/editors/kdevelop5/kdevelop-pg-qt.nix { };

  kdevelop-unwrapped = libsForQt5.callPackage ../applications/editors/kdevelop5/kdevelop.nix {
    llvmPackages = llvmPackages_7;
  };

  kdev-php = libsForQt5.callPackage ../applications/editors/kdevelop5/kdev-php.nix { };
  kdev-python = libsForQt5.callPackage ../applications/editors/kdevelop5/kdev-python.nix {
    python = python3;
  };

  kdevelop = libsForQt5.callPackage ../applications/editors/kdevelop5/wrapper.nix { };

  keepnote = callPackage ../applications/office/keepnote { };

  kega-fusion = pkgsi686Linux.callPackage ../misc/emulators/kega-fusion { };

  kepubify = callPackage ../tools/misc/kepubify { };

  kermit = callPackage ../tools/misc/kermit { };

  kexi = libsForQt5.callPackage ../applications/office/kexi { };

  khronos = callPackage ../applications/office/khronos { };

  keyfinder = libsForQt5.callPackage ../applications/audio/keyfinder { };

  keyfinder-cli = libsForQt5.callPackage ../applications/audio/keyfinder-cli { };

  kgraphviewer = libsForQt5.callPackage ../applications/graphics/kgraphviewer { };

  khal = callPackage ../applications/misc/khal { };

  khard = callPackage ../applications/misc/khard { };

  kid3 = libsForQt5.callPackage ../applications/audio/kid3 { };

  kile = libsForQt5.callPackage ../applications/editors/kile { };

  kino = callPackage ../applications/video/kino {
    inherit (gnome2) libglade;
    ffmpeg = ffmpeg_2;
  };

  kitty = callPackage ../applications/misc/kitty {
    harfbuzz = harfbuzz.override { withCoreText = stdenv.isDarwin; };
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation IOKit Kernel OpenGL;
  };

  kiwix = callPackage ../applications/misc/kiwix { };

  klayout = libsForQt5.callPackage ../applications/misc/klayout { };

  kmplayer = libsForQt5.callPackage ../applications/video/kmplayer { };

  kmymoney = libsForQt5.callPackage ../applications/office/kmymoney {
    inherit (kdeApplications) kidentitymanagement;
    inherit (kdeFrameworks) kdewebkit;
  };

  kodestudio = callPackage ../applications/editors/kodestudio { };

  konversation = libsForQt5.callPackage ../applications/networking/irc/konversation { };

  kotatogram-desktop = qt5.callPackage ../applications/networking/instant-messengers/telegram/kotatogram-desktop { };

  krita = libsForQt5.callPackage ../applications/graphics/krita {
    openjpeg = openjpeg_1;
  };

  krusader = libsForQt5.callPackage ../applications/misc/krusader { };

  ksuperkey = callPackage ../tools/X11/ksuperkey { };

  ktimetracker = libsForQt5.callPackage ../applications/office/ktimetracker { };

  ktorrent = libsForQt5.callPackage ../applications/networking/p2p/ktorrent { };

  kubecfg = callPackage ../applications/networking/cluster/kubecfg { };

  kubeval = callPackage ../applications/networking/cluster/kubeval { };

  kubeval-schema = callPackage ../applications/networking/cluster/kubeval/schema.nix { };

  kubernetes = callPackage ../applications/networking/cluster/kubernetes {
    go = buildPackages.go_1_13;
  };

  kubeseal = callPackage ../applications/networking/cluster/kubeseal { };

  kubectl = callPackage ../applications/networking/cluster/kubectl { };

  kubeless = callPackage ../applications/networking/cluster/kubeless { };

  k9s = callPackage ../applications/networking/cluster/k9s { };

  fluxctl = callPackage ../applications/networking/cluster/fluxctl { };

  linkerd = callPackage ../applications/networking/cluster/linkerd { };

  kubernetes-helm = callPackage ../applications/networking/cluster/helm { };

  kubetail = callPackage ../applications/networking/cluster/kubetail { } ;

  kupfer = callPackage ../applications/misc/kupfer {
    # using python36 as there appears to be a waf issue with python37
    # see https://github.com/NixOS/nixpkgs/issues/60498
    python3Packages = python36Packages;
  };

  kvirc = libsForQt5.callPackage ../applications/networking/irc/kvirc { };

  lame = callPackage ../development/libraries/lame { };

  larswm = callPackage ../applications/window-managers/larswm { };

  lash = callPackage ../applications/audio/lash { };

  ladspaH = callPackage ../applications/audio/ladspa-sdk/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladspa-sdk = callPackage ../applications/audio/ladspa-sdk { };

  caps = callPackage ../applications/audio/caps { };

  lastfmsubmitd = callPackage ../applications/audio/lastfmsubmitd { };

  lbdb = callPackage ../tools/misc/lbdb { abook = null; gnupg = null; goobook = null; khard = null; mu = null; };

  lbzip2 = callPackage ../tools/compression/lbzip2 { };

  lci = callPackage ../applications/science/logic/lci {};

  lemonbar = callPackage ../applications/window-managers/lemonbar { };

  lemonbar-xft = callPackage ../applications/window-managers/lemonbar/xft.nix { };

  legit = gitAndTools.legit;

  leo-editor = callPackage ../applications/editors/leo-editor { };

  libowfat = callPackage ../development/libraries/libowfat { };

  librecad = libsForQt5.callPackage ../applications/misc/librecad { };

  libreoffice = hiPrio libreoffice-still;
  libreoffice-unwrapped = libreoffice.libreoffice;

  libreoffice-args = {
    inherit (perlPackages) ArchiveZip IOCompress;
    inherit (gnome2) GConf ORBit2 gnome_vfs;
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

  libvmi = callPackage ../development/libraries/libvmi { };

  lifelines = callPackage ../applications/misc/lifelines { };

  liferea = callPackage ../applications/networking/newsreaders/liferea { };

  lightworks = callPackage ../applications/video/lightworks {
    portaudio = portaudio2014;
  };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome2) libglade;
  };

  linuxband = callPackage ../applications/audio/linuxband { };

  ledger = callPackage ../applications/office/ledger {
    # Boost >= 1.67 changed the name of boost python; ledger's cmake build needs
    # an update to find it:
    # https://www.boost.org/doc/libs/1_68_0/libs/python/doc/html/rn.html
    boost = boost15x;
  };

  ledger-autosync = callPackage  ../applications/office/ledger-autosync { };

  ledger-web = callPackage ../applications/office/ledger-web { };

  lighthouse = callPackage ../applications/misc/lighthouse { };

  lighttable = callPackage ../applications/editors/lighttable {};

  libdsk = callPackage ../misc/emulators/libdsk { };

  liblinphone = callPackage ../development/libraries/liblinphone { };

  links2 = callPackage ../applications/networking/browsers/links2 { };

  linphone = libsForQt5.callPackage ../applications/networking/instant-messengers/linphone { };

  linuxsampler = callPackage ../applications/audio/linuxsampler { };

  llpp = ocamlPackages.callPackage ../applications/misc/llpp { };

  lmms = libsForQt5.callPackage ../applications/audio/lmms {
    lame = null;
    libsoundio = null;
    portaudio = null;
  };

  loxodo = callPackage ../applications/misc/loxodo { };

  lsd2dsl = libsForQt5.callPackage ../applications/misc/lsd2dsl { };

  lrzsz = callPackage ../tools/misc/lrzsz { };

  lsp-plugins = callPackage ../applications/audio/lsp-plugins { };

  luminanceHDR = libsForQt5.callPackage ../applications/graphics/luminance-hdr { };

  lxdvdrip = callPackage ../applications/video/lxdvdrip { };

  handbrake = callPackage ../applications/video/handbrake {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox Foundation VideoToolbox;
    inherit (darwin) libobjc;
  };

  jftui = callPackage ../applications/video/jftui { };

  lilyterm = callPackage ../applications/misc/lilyterm {
    inherit (gnome2) vte;
    gtk = gtk2;
    flavour = "stable";
  };

  lilyterm-git = lilyterm.override {
    flavour = "git";
  };

  lime = callPackage ../development/libraries/lime { };

  luakit = callPackage ../applications/networking/browsers/luakit {
    inherit (luajitPackages) luafilesystem;
  };

  looking-glass-client = callPackage ../applications/virtualization/looking-glass-client { };

  ltc-tools = callPackage ../applications/audio/ltc-tools { };

  lumail = callPackage ../applications/networking/mailreaders/lumail {
    lua = lua5_1;
  };

  luppp = callPackage ../applications/audio/luppp { };

  lutris-unwrapped = python3.pkgs.callPackage ../applications/misc/lutris {
    inherit (gnome3) gnome-desktop libgnome-keyring;
    wine = wineWowPackages.staging;
  };
  lutris = callPackage ../applications/misc/lutris/chrootenv.nix { };
  lutris-free = lutris.override {
    steamSupport = false;
  };

  lv2bm = callPackage ../applications/audio/lv2bm { };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = libsForQt5.callPackage ../applications/misc/lyx { };

  mac = callPackage ../development/libraries/mac { };

  macdylibbundler = callPackage ../development/tools/misc/macdylibbundler { };

  magic-wormhole = with python3Packages; toPythonApplication magic-wormhole;

  mail-notification = callPackage ../desktops/gnome-2/desktop/mail-notification {};

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

  makeself = callPackage ../applications/misc/makeself { };

  mako = callPackage ../applications/misc/mako { };

  mandelbulber = libsForQt5.callPackage ../applications/graphics/mandelbulber { };

  mapmap = libsForQt5.callPackage ../applications/video/mapmap { };

  marathon = callPackage ../applications/networking/cluster/marathon { };
  marathonctl = callPackage ../tools/virtualization/marathonctl { } ;

  markdown-pp = callPackage ../tools/text/markdown-pp { };

  marp = callPackage ../applications/office/marp { };

  magnetico = callPackage ../applications/networking/p2p/magnetico {
    # Version 2019-08-14 fails to build with go 1.13 due to missing go.sum
    buildGoModule = buildGo112Module;
  };

  matchbox = callPackage ../applications/window-managers/matchbox { };

  matrixcli = callPackage ../applications/networking/instant-messengers/matrixcli {
    inherit (python3Packages) buildPythonApplication buildPythonPackage
      pygobject3 pytestrunner requests responses pytest python-olm
      canonicaljson;
  };

  matrix-dl = callPackage ../applications/networking/instant-messengers/matrix-dl { };

  matrix-recorder = callPackage ../applications/networking/instant-messengers/matrix-recorder {};

  mblaze = callPackage ../applications/networking/mailreaders/mblaze { };

  mcpp = callPackage ../development/compilers/mcpp { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  mediainfo = callPackage ../applications/misc/mediainfo { };

  mediainfo-gui = callPackage ../applications/misc/mediainfo-gui { };

  mediathekview = callPackage ../applications/video/mediathekview { jre = openjdk11; };

  meteo = callPackage ../applications/networking/weather/meteo { };

  meld = callPackage ../applications/version-management/meld { };

  meme = callPackage ../applications/graphics/meme { };

  mendeley = libsForQt5.callPackage ../applications/office/mendeley {
    gconf = pkgs.gnome2.GConf;
  };

  menumaker = callPackage ../applications/misc/menumaker { };

  mercurial_4 = callPackage ../applications/version-management/mercurial/4.9.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };
  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  mercurialFull = appendToName "full" (pkgs.mercurial.override { guiSupport = true; });

  merkaartor = libsForQt5.callPackage ../applications/misc/merkaartor { };

  meshlab = libsForQt5.callPackage ../applications/graphics/meshlab { };

  metersLv2 = callPackage ../applications/audio/meters_lv2 { };

  mhwaveedit = callPackage ../applications/audio/mhwaveedit {};

  michabo = libsForQt5.callPackage ../applications/misc/michabo { };

  mid2key = callPackage ../applications/audio/mid2key { };

  midori-unwrapped = callPackage ../applications/networking/browsers/midori { };
  midori = wrapFirefox midori-unwrapped { };

  mikmod = callPackage ../applications/audio/mikmod { };

  minicom = callPackage ../tools/misc/minicom { };

  minimodem = callPackage ../applications/radio/minimodem { };

  minidjvu = callPackage ../applications/graphics/minidjvu { };

  minikube = callPackage ../applications/networking/cluster/minikube {
    inherit (darwin.apple_sdk.frameworks) vmnet;
  };

  minishift = callPackage ../applications/networking/cluster/minishift { };

  minitube = libsForQt5.callPackage ../applications/video/minitube { };

  mimic = callPackage ../applications/audio/mimic { };

  mimms = callPackage ../applications/audio/mimms {};

  meh = callPackage ../applications/graphics/meh {};

  mixxx = libsForQt5.callPackage ../applications/audio/mixxx { };

  mjpg-streamer = callPackage ../applications/video/mjpg-streamer { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  MMA = callPackage ../applications/audio/MMA { };

  mmex = callPackage ../applications/office/mmex {
    wxGTK30 = wxGTK30.override {
      withWebKit = true;
      withGtk2 = false;
    };
  };

  mmsd = callPackage ../tools/networking/mmsd { };

  moc = callPackage ../applications/audio/moc { };

  mod-distortion = callPackage ../applications/audio/mod-distortion { };

  xmr-stak = callPackage ../applications/misc/xmr-stak {
    stdenvGcc6 = gcc6Stdenv;
  };

  xmrig = callPackage ../applications/misc/xmrig { };

  xmrig-proxy = callPackage ../applications/misc/xmrig/proxy.nix { };

  monkeysAudio = callPackage ../applications/audio/monkeys-audio { };

  monkeysphere = callPackage ../tools/security/monkeysphere { };

  monodevelop = callPackage ../applications/editors/monodevelop {};

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
  };

  monotoneViz = callPackage ../applications/version-management/monotone-viz {
    ocamlPackages = ocaml-ng.ocamlPackages_4_01_0;
  };

  monitor = callPackage ../applications/system/monitor { };

  moolticute = libsForQt5.callPackage ../applications/misc/moolticute { };

  moonlight-embedded = callPackage ../applications/misc/moonlight-embedded { };

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

  mopidy-mpd = callPackage ../applications/audio/mopidy/mpd.nix { };

  motif = callPackage ../development/libraries/motif { };

  mozplugger = callPackage ../applications/networking/browsers/mozilla-plugins/mozplugger {};

  mozjpeg = callPackage ../applications/graphics/mozjpeg { };

  easytag = callPackage ../applications/audio/easytag { };

  mp3gain = callPackage ../applications/audio/mp3gain { };

  mp3info = callPackage ../applications/audio/mp3info { };

  mp3splt = callPackage ../applications/audio/mp3splt { };

  mp3val = callPackage ../applications/audio/mp3val { };

  mpc123 = callPackage ../applications/audio/mpc123 { };

  mpg123 = callPackage ../applications/audio/mpg123 { };

  mpg321 = callPackage ../applications/audio/mpg321 { };

  mpc_cli = callPackage ../applications/audio/mpc {
    inherit (python3Packages) sphinx;
  };

  clerk = callPackage ../applications/audio/clerk { };

  nbstripout = callPackage ../applications/version-management/nbstripout { python = python3; };

  ncmpc = callPackage ../applications/audio/ncmpc { };

  ncmpcpp = callPackage ../applications/audio/ncmpcpp { };

  rofi-mpd = callPackage ../applications/audio/rofi-mpd { };

  rofi-calc = callPackage ../applications/science/math/rofi-calc { };

  ympd = callPackage ../applications/audio/ympd { };

  nload = callPackage ../applications/networking/nload { };

  normalize = callPackage ../applications/audio/normalize { };

  mm = callPackage ../applications/networking/instant-messengers/mm { };

  mm-common = callPackage ../development/libraries/mm-common { };

  mpc-qt = libsForQt5.callPackage ../applications/video/mpc-qt { };

  mps-youtube = callPackage ../applications/misc/mps-youtube { };

  mplayer = callPackage ../applications/video/mplayer ({
    libdvdnav = libdvdnav_4_2_1;
  } // (config.mplayer or {}));

  MPlayerPlugin = browser:
    callPackage ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      # !!! should depend on MPlayer
    };

  mpv = callPackage ../applications/video/mpv {
    inherit lua;
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa CoreAudio MediaPlayer;
  };

  mpv-with-scripts = callPackage ../applications/video/mpv/wrapper.nix { };

  mpvScripts = {
    convert = callPackage ../applications/video/mpv/scripts/convert.nix {};
    mpris = callPackage ../applications/video/mpv/scripts/mpris.nix {};
  };

  mrpeach = callPackage ../applications/audio/pd-plugins/mrpeach { };

  mrxvt = callPackage ../applications/misc/mrxvt { };

  mtpaint = callPackage ../applications/graphics/mtpaint { };

  mu-repo = python3Packages.callPackage ../applications/misc/mu-repo { };

  mucommander = callPackage ../applications/misc/mucommander { };

  multimarkdown = callPackage ../tools/typesetting/multimarkdown { };

  multimon-ng = callPackage ../applications/radio/multimon-ng { };

  murmur = (callPackages ../applications/networking/mumble {
      avahi = avahi-compat;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
    }).murmur;

  mumble = (callPackages ../applications/networking/mumble {
      avahi = avahi-compat;
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or stdenv.isLinux;
    }).mumble;

  mumble_overlay = callPackage ../applications/networking/mumble/overlay.nix {
    mumble_i686 = if stdenv.hostPlatform.system == "x86_64-linux"
      then pkgsi686Linux.mumble
      else null;
  };

  mup = callPackage ../applications/audio/mup { };

  # TODO: we should probably merge these 2
  musescore =
    if stdenv.isDarwin then
      callPackage ../applications/audio/musescore/darwin.nix { }
    else
      libsForQt5.callPackage ../applications/audio/musescore { };

  mmh = callPackage ../applications/networking/mailreaders/mmh { };
  mutt = callPackage ../applications/networking/mailreaders/mutt { };
  mutt-with-sidebar = mutt.override {
    withSidebar = true;
  };

  mwic = callPackage ../applications/misc/mwic {
    pythonPackages = python3Packages;
  };

  neap = callPackage ../applications/misc/neap { };

  neomutt = callPackage ../applications/networking/mailreaders/neomutt { };

  natron = callPackage ../applications/video/natron { };

  neocomp  = callPackage ../applications/window-managers/neocomp { };

  netease-cloud-music = callPackage ../applications/audio/netease-cloud-music {};

  nicotine-plus = callPackage ../applications/networking/soulseek/nicotine-plus {
    geoip = geoipWithDatabase;
  };

  notion = callPackage ../applications/window-managers/notion { };

  nootka = qt5.callPackage ../applications/audio/nootka { };
  nootka-unstable = qt5.callPackage ../applications/audio/nootka/unstable.nix { };

  open-policy-agent = callPackage ../development/tools/open-policy-agent { };

  openshift = callPackage ../applications/networking/cluster/openshift {
    buildGoPackage = buildGo112Package;
  };

  oroborus = callPackage ../applications/window-managers/oroborus {};

  osm2pgsql = callPackage ../tools/misc/osm2pgsql { };

  ostinato = callPackage ../applications/networking/ostinato { };

  p4v = libsForQt5.callPackage ../applications/version-management/p4v { };

  partio = callPackage ../development/libraries/partio {};

  pbis-open = callPackage ../tools/security/pbis { };

  pcmanfm = callPackage ../applications/misc/pcmanfm { };

  pcmanfm-qt = lxqt.pcmanfm-qt;

  pcmanx-gtk2 = callPackage ../applications/misc/pcmanx-gtk2 { };

  pig = callPackage ../applications/networking/cluster/pig { };

  pijul = callPackage ../applications/version-management/pijul {
    inherit (llvmPackages) clang libclang;
  };

  ping = callPackage ../applications/networking/ping { };

  piper = callPackage ../os-specific/linux/piper { };

  plank = callPackage ../applications/misc/plank { };

  planner = callPackage ../applications/office/planner { };

  playonlinux = callPackage ../applications/misc/playonlinux {
     stdenv = stdenv_32bit;
  };

  polybar = callPackage ../applications/misc/polybar { };

  polybarFull = callPackage ../applications/misc/polybar {
    alsaSupport = true;
    githubSupport = true;
    mpdSupport = true;
    pulseSupport  = true;
    iwSupport = false;
    nlSupport = true;
    i3Support = true;
    i3GapsSupport = false;
  };

  ptex = callPackage ../development/libraries/ptex {};

  qbec = callPackage ../applications/networking/cluster/qbec { };

  rssguard = libsForQt5.callPackage ../applications/networking/feedreaders/rssguard { };

  scudcloud = callPackage ../applications/networking/instant-messengers/scudcloud { };

  shotcut = libsForQt5.callPackage ../applications/video/shotcut {
    libmlt = mlt;
  };

  shogun = callPackage ../applications/science/machine-learning/shogun {
    stdenv = gcc8Stdenv;

    # Workaround for the glibc abi version mismatch.
    # Please note that opencv builds are by default disabled.
    opencv = opencv3.override {
      stdenv = gcc8Stdenv;
      openexr = openexr.override {
        stdenv = gcc8Stdenv;
      };
    };
  };

  sky = callPackage ../applications/networking/instant-messengers/sky {};

  smplayer = libsForQt5.callPackage ../applications/video/smplayer { };

  smtube = libsForQt5.callPackage ../applications/video/smtube {};

  softmaker-office = callPackage ../applications/office/softmaker/softmaker_office.nix {};

  spacegun = callPackage ../applications/networking/cluster/spacegun {};

  stride = callPackage ../applications/networking/instant-messengers/stride { };

  sudolikeaboss = callPackage ../tools/security/sudolikeaboss { };

  speedread = callPackage ../applications/misc/speedread { };

  station = callPackage ../applications/networking/station { };

  synapse = callPackage ../applications/misc/synapse { };

  synapse-bt = callPackage ../applications/networking/p2p/synapse-bt {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  synfigstudio = callPackage ../applications/graphics/synfigstudio {
    mlt-qt5 = libsForQt5.mlt;
  };

  typora = callPackage ../applications/editors/typora { };

  taxi = callPackage ../applications/networking/ftp/taxi { };

  librep = callPackage ../development/libraries/librep { };

  rep-gtk = callPackage ../development/libraries/rep-gtk { };

  sawfish = callPackage ../applications/window-managers/sawfish { };

  sidplayfp = callPackage ../applications/audio/sidplayfp { };

  sndpeek = callPackage ../applications/audio/sndpeek { };

  sxhkd = callPackage ../applications/window-managers/sxhkd { };

  mpop = callPackage ../applications/networking/mpop {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  msmtp = callPackage ../applications/networking/msmtp {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
 };

  maxlib = callPackage ../applications/audio/pd-plugins/maxlib { };

  maxscale = callPackage ../tools/networking/maxscale {
    stdenv = gcc6Stdenv;
  };

  pdfdiff = callPackage ../applications/misc/pdfdiff { };

  pdfsam-basic = callPackage ../applications/misc/pdfsam-basic { };

  mupdf = callPackage ../applications/misc/mupdf { };

  mystem = callPackage ../applications/misc/mystem { };

  diffpdf = libsForQt5.callPackage ../applications/misc/diffpdf { };

  diff-pdf = callPackage ../applications/misc/diff-pdf { wxGTK = wxGTK31; };

  mlocate = callPackage ../tools/misc/mlocate { };

  mypaint = callPackage ../applications/graphics/mypaint { };

  mypaint-brushes1 = callPackage ../development/libraries/mypaint-brushes/1.0.nix { };

  mypaint-brushes = callPackage ../development/libraries/mypaint-brushes { };

  mythtv = libsForQt5.callPackage ../applications/video/mythtv {
    libXNVCtrl = linuxPackages.nvidia_x11.settings.libXNVCtrl;
  };

  micro = callPackage ../applications/editors/micro { };

  mle = callPackage ../applications/editors/mle { };

  nano = callPackage ../applications/editors/nano { };

  nanoblogger = callPackage ../applications/misc/nanoblogger { };

  nanorc = callPackage ../applications/editors/nano/nanorc { };

  navipowm = callPackage ../applications/misc/navipowm { };

  navit = libsForQt5.callPackage ../applications/misc/navit { };

  netbeans = callPackage ../applications/editors/netbeans { };

  ncdu = callPackage ../tools/misc/ncdu { };

  ncdc = callPackage ../applications/networking/p2p/ncdc { };

  ncspot = callPackage ../applications/audio/ncspot {
    withALSA = stdenv.isLinux;
    withPulseAudio = config.pulseaudio or stdenv.isLinux;
    withPortAudio = stdenv.isDarwin;
  };

  ncview = callPackage ../tools/X11/ncview { } ;

  ne = callPackage ../applications/editors/ne { };

  nedit = callPackage ../applications/editors/nedit { };

  ngt = callPackage ../development/libraries/ngt { };

  nheko = libsForQt5.callPackage ../applications/networking/instant-messengers/nheko { };

  nomacs = libsForQt5.callPackage ../applications/graphics/nomacs { };

  notepadqq = libsForQt5.callPackage ../applications/editors/notepadqq { };

  notbit = callPackage ../applications/networking/mailreaders/notbit { };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    gmime = gmime3;
    pythonPackages = python3Packages;
  };

  notejot = callPackage ../applications/misc/notejot { };

  notmuch-mutt = callPackage ../applications/networking/mailreaders/notmuch/mutt.nix { };

  muchsync = callPackage ../applications/networking/mailreaders/notmuch/muchsync.nix { };

  notmuch-addrlookup = callPackage ../applications/networking/mailreaders/notmuch-addrlookup { };

  nova-filters =  callPackage ../applications/audio/nova-filters { };

  nspluginwrapper = callPackage ../applications/networking/browsers/mozilla-plugins/nspluginwrapper {};

  nvi = callPackage ../applications/editors/nvi { };

  nvpy = callPackage ../applications/editors/nvpy { };

  obconf = callPackage ../tools/X11/obconf {
    inherit (gnome2) libglade;
  };

  obs-linuxbrowser = callPackage ../applications/video/obs-studio/linuxbrowser.nix { };

  obs-studio = libsForQt5.callPackage ../applications/video/obs-studio { ffmpeg = ffmpeg_4; };

  obs-wlrobs = callPackage ../applications/video/obs-studio/wlrobs.nix { };

  obs-ndi = callPackage ../applications/video/obs-studio/obs-ndi.nix { };

  octoprint = callPackage ../applications/misc/octoprint { };

  octoprint-plugins = callPackage ../applications/misc/octoprint/plugins.nix { };

  ocrad = callPackage ../applications/graphics/ocrad { };

  offrss = callPackage ../applications/networking/offrss { };

  ogmtools = callPackage ../applications/video/ogmtools { };

  omegat = callPackage ../applications/misc/omegat.nix { };

  omxplayer = callPackage ../applications/video/omxplayer { };

  openbox = callPackage ../applications/window-managers/openbox { };

  openbox-menu = callPackage ../applications/misc/openbox-menu {
    stdenv = gccStdenv;
  };

  openbrf = libsForQt5.callPackage ../applications/misc/openbrf { };

  opencpn = callPackage ../applications/misc/opencpn { };

  openfx = callPackage ../development/libraries/openfx {};

  openimageio = callPackage ../applications/graphics/openimageio { };

  openimageio2 = callPackage ../applications/graphics/openimageio/2.x.nix { };

  openjump = callPackage ../applications/misc/openjump { };

  openorienteering-mapper = libsForQt5.callPackage ../applications/gis/openorienteering-mapper { };

  openscad = libsForQt5.callPackage ../applications/graphics/openscad {};

  opentimestamps-client = python3Packages.callPackage ../tools/misc/opentimestamps-client {};

  opentx = libsForQt5.callPackage ../applications/misc/opentx { };

  opera = callPackage ../applications/networking/browsers/opera {};

  orca = python3Packages.callPackage ../applications/misc/orca {
    inherit (pkgs) pkgconfig;
  };

  osm2xmap = callPackage ../applications/misc/osm2xmap {
    libyamlcpp = libyamlcpp_0_3;
  };

  osmctools = callPackage ../applications/misc/osmctools { };

  osmium-tool = callPackage ../applications/misc/osmium-tool { };

  owamp = callPackage ../applications/networking/owamp { };

  vivaldi = callPackage ../applications/networking/browsers/vivaldi {};

  vivaldi-ffmpeg-codecs = callPackage ../applications/networking/browsers/vivaldi/ffmpeg-codecs.nix {};

  vivaldi-widevine = callPackage ../applications/networking/browsers/vivaldi/widevine.nix { };

  openmpt123 = callPackage ../applications/audio/openmpt123 { };

  openrazer-daemon = with python3Packages; toPythonApplication openrazer-daemon;

  opusfile = callPackage ../applications/audio/opusfile { };

  opusTools = callPackage ../applications/audio/opus-tools { };

  orpie = callPackage ../applications/misc/orpie {
    gsl = gsl_1;
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  osmo = callPackage ../applications/office/osmo { };

  palemoon = callPackage ../applications/networking/browsers/palemoon {
    # https://www.palemoon.org/sourcecode.shtml
    stdenv = gcc7Stdenv;
  };

  pamix = callPackage ../applications/audio/pamix { };

  pamixer = callPackage ../applications/audio/pamixer { };

  ncpamixer = callPackage ../applications/audio/ncpamixer { };

  pan = callPackage ../applications/networking/newsreaders/pan { };

  panotools = callPackage ../applications/graphics/panotools { };

  paprefs = callPackage ../applications/audio/paprefs { };

  pantalaimon = python3Packages.callPackage ../applications/networking/instant-messengers/pantalaimon { };

  pavucontrol = callPackage ../applications/audio/pavucontrol { };

  paraview = libsForQt5.callPackage ../applications/graphics/paraview { };

  parlatype = callPackage ../applications/audio/parlatype { };

  packet = callPackage ../development/tools/packet { };

  pb_cli = callPackage ../tools/misc/pb_cli {};

  capture = callPackage ../tools/misc/capture {};

  pbrt = callPackage ../applications/graphics/pbrt { };

  pcsxr = callPackage ../misc/emulators/pcsxr {
    ffmpeg = ffmpeg_2;
  };

  pcsx2 = pkgsi686Linux.callPackage ../misc/emulators/pcsx2 {
    wxGTK = pkgsi686Linux.wxGTK30;
  };

  pekwm = callPackage ../applications/window-managers/pekwm { };

  pencil = callPackage ../applications/graphics/pencil {
  };

  perseus = callPackage ../applications/science/math/perseus {};

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome2) libgnomecanvas;
  };

  pdfcpu = callPackage ../applications/graphics/pdfcpu { };
  pdftk = callPackage ../tools/typesetting/pdftk { };
  pdftk-legacy = lowPrio (callPackage ../tools/typesetting/pdftk/legacy.nix { });
  pdfgrep  = callPackage ../tools/typesetting/pdfgrep { };

  pdfpc = callPackage ../applications/misc/pdfpc {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-libav;
  };

  peek = callPackage ../applications/video/peek { };

  pflask = callPackage ../os-specific/linux/pflask {};

  photoqt = libsForQt5.callPackage ../applications/graphics/photoqt { };

  photoflow = callPackage ../applications/graphics/photoflow { };

  phototonic = libsForQt5.callPackage ../applications/graphics/phototonic { };

  phrasendrescher = callPackage ../tools/security/phrasendrescher { };

  phraseapp-client = callPackage ../tools/misc/phraseapp-client { };

  phwmon = callPackage ../applications/misc/phwmon { };

  pianobar = callPackage ../applications/audio/pianobar { };

  pianobooster = qt5.callPackage ../applications/audio/pianobooster { };

  picard = callPackage ../applications/audio/picard { };

  picocom = callPackage ../tools/misc/picocom {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

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

  pidgin-mra = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-mra { };

  pidgin-skypeweb = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-skypeweb { };

  pidgin-carbons = callPackage ../applications/networking/instant-messengers/pidgin-plugins/carbons { };

  pidgin-xmpp-receipts = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-xmpp-receipts { };

  pidgin-otr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidgin-osd = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-osd { };

  pidgin-sipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  pidgin-window-merge = callPackage ../applications/networking/instant-messengers/pidgin-plugins/window-merge { };

  purple-discord = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-discord { };

  purple-hangouts = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-hangouts { };

  purple-lurch = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-lurch { };

  purple-matrix = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-matrix { };

  purple-plugin-pack = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-plugin-pack { };

  purple-slack = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-slack { };

  purple-vk-plugin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-vk-plugin { };

  purple-xmpp-http-upload = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-xmpp-http-upload { };

  telegram-purple = callPackage ../applications/networking/instant-messengers/pidgin-plugins/telegram-purple { };

  toxprpl = callPackage ../applications/networking/instant-messengers/pidgin-plugins/tox-prpl {
    libtoxcore = libtoxcore-new;
  };

  pidgin-opensteamworks = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-opensteamworks { };

  purple-facebook = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-facebook { };

  pithos = callPackage ../applications/audio/pithos {
    pythonPackages = python3Packages;
  };

  pinfo = callPackage ../applications/misc/pinfo { };

  pinpoint = callPackage ../applications/office/pinpoint { };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtk-sharp-2_0;
  };

  pistol = callPackage ../tools/misc/pistol { };

  plex-media-player = libsForQt512.callPackage ../applications/video/plex-media-player { };

  plex-mpv-shim = python3Packages.callPackage ../applications/video/plex-mpv-shim { };

  plover = recurseIntoAttrs (libsForQt5.callPackage ../applications/misc/plover { });

  plugin-torture = callPackage ../applications/audio/plugin-torture { };

  polar-bookshelf = callPackage ../applications/misc/polar-bookshelf { };

  poezio = python3Packages.poezio;

  pommed_light = callPackage ../os-specific/linux/pommed-light {};

  polymake = callPackage ../applications/science/math/polymake { };

  pond = callPackage ../applications/networking/instant-messengers/pond { };

  ponymix = callPackage ../applications/audio/ponymix { };

  potrace = callPackage ../applications/graphics/potrace {};

  posterazor = callPackage ../applications/misc/posterazor { };

  pqiv = callPackage ../applications/graphics/pqiv { };

  qiv = callPackage ../applications/graphics/qiv { };

  processing = callPackage ../applications/graphics/processing {
    jdk = oraclejdk8;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = callPackage ../applications/misc/procmail { };

  profanity = callPackage ../applications/networking/instant-messengers/profanity ({
    python = python3;
  } // (config.profanity or {}));

  properties-cpp = callPackage ../development/libraries/properties-cpp { };

  protonmail-bridge = libsForQt512.callPackage ../applications/networking/protonmail-bridge { };

  protonvpn-cli = callPackage ../applications/networking/protonvpn-cli { };

  protonvpn-cli-ng = callPackage ../applications/networking/protonvpn-cli-ng { };

  ps2client = callPackage ../applications/networking/ps2client { };

  psi = libsForQt5.callPackage ../applications/networking/instant-messengers/psi { };

  psi-plus = libsForQt5.callPackage ../applications/networking/instant-messengers/psi-plus { };

  psol = callPackage ../development/libraries/psol { };

  pstree = callPackage ../applications/misc/pstree { };

  pt2-clone = callPackage ../applications/audio/pt2-clone { };

  ptask = callPackage ../applications/misc/ptask { };

  pulseaudio-ctl = callPackage ../applications/audio/pulseaudio-ctl { };

  pulseaudio-dlna = callPackage ../applications/audio/pulseaudio-dlna { };

  pulseview = libsForQt5.callPackage ../applications/science/electronics/pulseview { };

  puredata = callPackage ../applications/audio/puredata { };
  puredata-with-plugins = plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  puremapping = callPackage ../applications/audio/pd-plugins/puremapping { };

  pybitmessage = callPackage ../applications/networking/instant-messengers/pybitmessage { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qbittorrent = libsForQt5.callPackage ../applications/networking/p2p/qbittorrent { };
  qbittorrent-nox = qbittorrent.override {
    guiSupport = false;
  };

  qcomicbook = libsForQt5.callPackage ../applications/graphics/qcomicbook { };

  eiskaltdcpp = callPackage ../applications/networking/p2p/eiskaltdcpp {
    lua5 = lua5_1;
    miniupnpc = miniupnpc_1;
  };

  qdirstat = libsForQt5.callPackage ../applications/misc/qdirstat {};

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor;
    inherit (darwin.stubs) rez setfile;
    python = python3;
  };

  qemu-utils = callPackage ../applications/virtualization/qemu/utils.nix {};

  qgis-unwrapped = libsForQt5.callPackage ../applications/gis/qgis/unwrapped.nix {
      withGrass = false;
  };

  qgis = callPackage ../applications/gis/qgis { };

  qgroundcontrol = libsForQt5.callPackage ../applications/science/robotics/qgroundcontrol { };

  qjackctl = libsForQt5.callPackage ../applications/audio/qjackctl { };

  qimgv = libsForQt5.callPackage ../applications/graphics/qimgv { };

  qlandkartegt = libsForQt5.callPackage ../applications/misc/qlandkartegt {};

  garmindev = callPackage ../applications/misc/qlandkartegt/garmindev.nix {};

  qmapshack = libsForQt5.callPackage ../applications/misc/qmapshack { };

  qmediathekview = libsForQt5.callPackage ../applications/video/qmediathekview {
    boost = boost17x;
  };

  qmetro = callPackage ../applications/misc/qmetro { };

  qmidiarp = callPackage ../applications/audio/qmidiarp {};

  qmidinet = libsForQt5.callPackage ../applications/audio/qmidinet { };

  qmidiroute = callPackage ../applications/audio/qmidiroute { };

  qmmp = libsForQt5.callPackage ../applications/audio/qmmp { };

  qnotero = libsForQt5.callPackage ../applications/office/qnotero { };

  qrcode = callPackage ../tools/graphics/qrcode {};

  qsampler = libsForQt5.callPackage ../applications/audio/qsampler { };

  qscreenshot = callPackage ../applications/graphics/qscreenshot {
    inherit (darwin.apple_sdk.frameworks) Carbon;
    qt = qt4;
  };

  qsstv = qt5.callPackage ../applications/radio/qsstv { };

  qsyncthingtray = libsForQt5.callPackage ../applications/misc/qsyncthingtray { };

  qstopmotion = libsForQt5.callPackage ../applications/video/qstopmotion { };

  qsynth = libsForQt5.callPackage ../applications/audio/qsynth { };

  qtbitcointrader = libsForQt5.callPackage ../applications/misc/qtbitcointrader { };

  qtchan = libsForQt5.callPackage ../applications/networking/browsers/qtchan { };

  qtox = libsForQt5.callPackage ../applications/networking/instant-messengers/qtox { };

  qtpass = libsForQt5.callPackage ../applications/misc/qtpass { };

  qtractor = libsForQt5.callPackage ../applications/audio/qtractor { };

  qtscrobbler = callPackage ../applications/audio/qtscrobbler { };

  quantomatic = callPackage ../applications/science/physics/quantomatic { };

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

  quirc = callPackage ../tools/graphics/quirc {};

  quilter = callPackage ../applications/editors/quilter { };

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
    inherit gtksourceview webkitgtk;
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

  rabbitvcs = callPackage ../applications/version-management/rabbitvcs {};

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  renoise = callPackage ../applications/audio/renoise {};

  radiotray-ng = callPackage ../applications/audio/radiotray-ng {
    wxGTK = wxGTK30;
  };

  railcar = callPackage ../applications/virtualization/railcar {};

  raiseorlaunch = callPackage ../applications/misc/raiseorlaunch {};

  rapcad = libsForQt5.callPackage ../applications/graphics/rapcad { boost = boost159; };

  rapid-photo-downloader = libsForQt5.callPackage ../applications/graphics/rapid-photo-downloader { };

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratmen = callPackage ../tools/X11/ratmen {};

  ratox = callPackage ../applications/networking/instant-messengers/ratox { };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
  };

  rclone = callPackage ../applications/networking/sync/rclone { };

  rclone-browser = libsForQt5.callPackage ../applications/networking/sync/rclone/browser.nix { };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  rdedup = callPackage ../tools/backup/rdedup {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  rdup = callPackage ../tools/backup/rdup { };

  reaper = callPackage ../applications/audio/reaper { };

  recode = callPackage ../tools/text/recode { };

  rednotebook = python3Packages.callPackage ../applications/editors/rednotebook { };

  remotebox = callPackage ../applications/virtualization/remotebox { };

  retroshare = libsForQt5.callPackage ../applications/networking/p2p/retroshare { };
  retroshare06 = retroshare;

  ricochet = libsForQt5.callPackage ../applications/networking/instant-messengers/ricochet { };

  ries = callPackage ../applications/science/math/ries { };

  ripcord = qt5.callPackage ../applications/networking/instant-messengers/ripcord { };

  ripser = callPackage ../applications/science/math/ripser { };

  rkt = callPackage ../applications/virtualization/rkt { };

  rkdeveloptool = callPackage ../misc/rkdeveloptool { };

  rofi-unwrapped = callPackage ../applications/misc/rofi { };
  rofi = callPackage ../applications/misc/rofi/wrapper.nix { };

  rofi-pass = callPackage ../tools/security/pass/rofi-pass.nix { };

  rofi-menugen = callPackage ../applications/misc/rofi-menugen { };

  rofi-systemd = callPackage ../tools/system/rofi-systemd { };

  rootlesskit = callPackage ../tools/virtualization/rootlesskit {};

  rpcs3 = libsForQt5.callPackage ../misc/emulators/rpcs3 { };

  rsclock = callPackage ../applications/misc/rsclock { };

  rstudio = libsForQt5.callPackage ../applications/editors/rstudio {
    boost = boost166;
    llvmPackages = llvmPackages_7;
  };

  rsync = callPackage ../applications/networking/sync/rsync (config.rsync or {});
  rrsync = callPackage ../applications/networking/sync/rsync/rrsync.nix {};

  rtl_433 = callPackage ../applications/radio/rtl_433 { };

  rtl-sdr = callPackage ../applications/radio/rtl-sdr { };

  rtv = callPackage ../applications/misc/rtv { };

  rubyripper = callPackage ../applications/audio/rubyripper {};

  runc = callPackage ../applications/virtualization/runc {};

  rxvt = callPackage ../applications/misc/rxvt { };

  rxvt-unicode = callPackage ../applications/misc/rxvt-unicode/wrapper.nix { };

  rxvt-unicode-unwrapped = callPackage ../applications/misc/rxvt-unicode { };

  rxvt-unicode-plugins = import ../applications/misc/rxvt-unicode-plugins { inherit callPackage; };

  uade123 = callPackage ../applications/audio/uade123 {};

  udevil = callPackage ../applications/misc/udevil {};

  udiskie = callPackage ../applications/misc/udiskie { };

  sakura = callPackage ../applications/misc/sakura { };

  sayonara = libsForQt5.callPackage ../applications/audio/sayonara { };

  sbagen = callPackage ../applications/misc/sbagen { };

  scantailor = callPackage ../applications/graphics/scantailor { };

  scantailor-advanced = qt5.callPackage ../applications/graphics/scantailor/advanced.nix { };

  sc-im = callPackage ../applications/misc/sc-im { };

  scite = callPackage ../applications/editors/scite { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome2) libart_lgpl;
  };

  scribusUnstable = libsForQt5.callPackage ../applications/office/scribus/unstable.nix { };

  seafile-client = libsForQt5.callPackage ../applications/networking/seafile-client { };

  seeks = callPackage ../tools/networking/p2p/seeks {
    protobuf = protobuf3_1;
  };

  sent = callPackage ../applications/misc/sent { };

  seq24 = callPackage ../applications/audio/seq24 { };

  setbfree = callPackage ../applications/audio/setbfree { };

  sfizz = callPackage ../applications/audio/sfizz { };

  sfxr = callPackage ../applications/audio/sfxr { };

  sfxr-qt = libsForQt5.callPackage ../applications/audio/sfxr-qt { };

  shadowfox = callPackage ../tools/networking/shadowfox { };

  shfmt = callPackage ../tools/text/shfmt { };

  shotgun = callPackage ../tools/graphics/shotgun {};

  shutter = callPackage ../applications/graphics/shutter { };

  simple-scan = gnome3.simple-scan;

  siproxd = callPackage ../applications/networking/siproxd { };

  skypeforlinux = callPackage ../applications/networking/instant-messengers/skypeforlinux { };

  skype4pidgin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/skype4pidgin { };

  skype_call_recorder = callPackage ../applications/networking/instant-messengers/skype-call-recorder { };

  SkypeExport = callPackage ../applications/networking/instant-messengers/SkypeExport { };

  slmenu = callPackage ../applications/misc/slmenu {};

  slop = callPackage ../tools/misc/slop {};

  slrn = callPackage ../applications/networking/newsreaders/slrn { };

  slurp = callPackage ../tools/misc/slurp { };

  sniproxy = callPackage ../applications/networking/sniproxy { };

  sooperlooper = callPackage ../applications/audio/sooperlooper { };

  sops = callPackage ../tools/security/sops { };

  sorcer = callPackage ../applications/audio/sorcer { };

  sound-juicer = callPackage ../applications/audio/sound-juicer { };

  soundtracker = callPackage ../applications/audio/soundtracker { };

  spice-vdagent = callPackage ../applications/virtualization/spice-vdagent { };

  spike = callPackage ../applications/virtualization/spike { };

  tensorman = callPackage ../tools/misc/tensorman { };

  spideroak = callPackage ../applications/networking/spideroak { };

  split2flac = callPackage ../applications/audio/split2flac { };

  spotify-tui = callPackage ../applications/audio/spotify-tui {
    inherit (darwin.apple_sdk.frameworks) AppKit Security;
  };

  squishyball = callPackage ../applications/audio/squishyball {
    ncurses = ncurses5;
  };

  stupidterm = callPackage ../applications/misc/stupidterm {
    gtk = gtk3;
  };

  styx = callPackage ../applications/misc/styx { };

  tecoc = callPackage ../applications/editors/tecoc { };

  viber = callPackage ../applications/networking/instant-messengers/viber { };

  wavebox = callPackage ../applications/networking/instant-messengers/wavebox { };

  sonic-pi = libsForQt5.callPackage ../applications/audio/sonic-pi { };

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

  linuxstopmotion = callPackage ../applications/video/linuxstopmotion { };

  sweethome3d = recurseIntoAttrs (  (callPackage ../applications/misc/sweethome3d { })
                                 // (callPackage ../applications/misc/sweethome3d/editors.nix {
                                      sweethome3dApp = sweethome3d.application;
                                    })
                                 );

  swingsane = callPackage ../applications/graphics/swingsane { };

  sxiv = callPackage ../applications/graphics/sxiv { };

  resilio-sync = callPackage ../applications/networking/resilio-sync { };

  dropbox = callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox/cli.nix { };

  maestral = callPackage ../applications/networking/maestral { };

  maestral-gui = libsForQt5.callPackage ../applications/networking/maestral { withGui = true; };

  insync = callPackage ../applications/networking/insync { };

  libstrangle = callPackage ../tools/X11/libstrangle {
    stdenv = stdenv_32bit;
  };

  lightdm = libsForQt5.callPackage ../applications/display-managers/lightdm { };

  lightdm_qt = lightdm.override { withQt5 = true; };

  lightdm-enso-os-greeter = callPackage ../applications/display-managers/lightdm-enso-os-greeter {
    inherit (xorg) libX11 libXdmcp libpthreadstubs;
  };

  lightdm_gtk_greeter = callPackage ../applications/display-managers/lightdm/gtk-greeter.nix {
    inherit (xfce) exo;
  };

  lightdm-mini-greeter = callPackage ../applications/display-managers/lightdm-mini-greeter { };

  lightdm-tiny-greeter = callPackage ../applications/display-managers/lightdm-tiny-greeter {
    conf = config.lightdm-tiny-greeter.conf or "";
  };

  ly = callPackage ../applications/display-managers/ly { };

  slic3r = callPackage ../applications/misc/slic3r { };

  curaengine_stable = callPackage ../applications/misc/curaengine/stable.nix { };
  cura_stable = callPackage ../applications/misc/cura/stable.nix {
    curaengine = curaengine_stable;
  };

  curaengine = callPackage ../applications/misc/curaengine { inherit (python3.pkgs) libarcus; };

  cura = qt5.callPackage ../applications/misc/cura { };

  curaPlugins = callPackage ../applications/misc/cura/plugins.nix { };

  curaLulzbot = qt5.callPackage ../applications/misc/cura/lulzbot/default.nix { };

  curaByDagoma = callPackage ../applications/misc/curabydagoma { };

  peru = callPackage ../applications/version-management/peru {};

  petrinizer = haskellPackages.callPackage ../applications/science/logic/petrinizer {};

  pmidi = callPackage ../applications/audio/pmidi { };

  printrun = callPackage ../applications/misc/printrun { };

  prusa-slicer = callPackage ../applications/misc/prusa-slicer { };

  sddm = libsForQt5.callPackage ../applications/display-managers/sddm { };

  skrooge = libsForQt5.callPackage ../applications/office/skrooge {};

  smartgithg = callPackage ../applications/version-management/smartgithg {
    jre = openjdk11;
  };

  smartdeblur = callPackage ../applications/graphics/smartdeblur { };

  snapper = callPackage ../tools/misc/snapper { };

  snd = callPackage ../applications/audio/snd { };

  shntool = callPackage ../applications/audio/shntool { };

  sipp = callPackage ../development/tools/misc/sipp { };

  skanlite = libsForQt5.callPackage ../applications/office/skanlite { };

  soci = callPackage ../development/libraries/soci { };

  sonic-lineup = libsForQt5.callPackage ../applications/audio/sonic-lineup { };

  sonic-visualiser = libsForQt5.callPackage ../applications/audio/sonic-visualiser { };

  soulseekqt = libsForQt5.callPackage ../applications/networking/p2p/soulseekqt { };

  sox = callPackage ../applications/misc/audio/sox {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  soxr = callPackage ../applications/misc/audio/soxr { };

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

  libspotify = callPackage ../development/libraries/libspotify (config.libspotify or {});

  sourcetrail = callPackage ../development/tools/sourcetrail { };

  spotifywm = callPackage ../applications/audio/spotifywm { };

  squeezelite = callPackage ../applications/audio/squeezelite { };

  ltunify = callPackage ../tools/misc/ltunify { };

  src = callPackage ../applications/version-management/src {
    git = gitMinimal;
  };

  ssr = callPackage ../applications/audio/soundscape-renderer {};

  ssrc = callPackage ../applications/audio/ssrc { };

  stalonetray = callPackage ../applications/window-managers/stalonetray {};

  inherit (ocaml-ng.ocamlPackages_4_07) stog;

  stp = callPackage ../applications/science/logic/stp { };

  stretchly = callPackage ../applications/misc/stretchly {
    # Error on launch w/electron_8
    electron = electron_7;
  };

  stumpish = callPackage ../applications/window-managers/stumpish {};

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

  inherit (callPackage ../applications/version-management/sublime-merge {})
    sublime-merge
    sublime-merge-dev;

  inherit (callPackages ../applications/version-management/subversion { sasl = cyrus_sasl; })
    subversion19 subversion_1_10 subversion;

  subversionClient = appendToName "client" (pkgs.subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  });

  subunit = callPackage ../development/libraries/subunit { };

  surf = callPackage ../applications/networking/browsers/surf { gtk = gtk2; };

  surf-display = callPackage ../desktops/surf-display { };

  sunvox = callPackage ../applications/audio/sunvox { };

  swh_lv2 = callPackage ../applications/audio/swh-lv2 { };

  swift-im = libsForQt5.callPackage ../applications/networking/instant-messengers/swift-im {
    inherit (gnome2) GConf;
    boost = boost168;
  };

  sylpheed = callPackage ../applications/networking/mailreaders/sylpheed { };

  symlinks = callPackage ../tools/system/symlinks { };

  syncplay = python3.pkgs.callPackage ../applications/networking/syncplay { };

  inherit (callPackages ../applications/networking/syncthing { })
    syncthing
    syncthing-cli
    syncthing-discovery
    syncthing-relay;

  syncthing-gtk = python2Packages.callPackage ../applications/networking/syncthing-gtk { };

  syncthing-tray = callPackage ../applications/misc/syncthing-tray { };

  syncthingtray = libsForQt5.callPackage ../applications/misc/syncthingtray { };
  syncthingtray-minimal = libsForQt5.callPackage ../applications/misc/syncthingtray {
    webviewSupport = false;
    jsSupport = false;
    kioPluginSupport = false;
    plasmoidSupport = false;
    systemdSupport = true;
  };

  synergy = libsForQt5.callPackage ../applications/misc/synergy {
    stdenv = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon Cocoa CoreServices ScreenSaver;
  };

  synergyWithoutGUI = synergy.override { withGUI = false; };

  tabbed = callPackage ../applications/window-managers/tabbed {
    # if you prefer a custom config, write the config.h in tabbed.config.h
    # and enable
    # customConfig = builtins.readFile ./tabbed.config.h;
  };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages;
  };

  tagainijisho = callPackage ../applications/office/tagainijisho {};

  tahoe-lafs = callPackage ../tools/networking/p2p/tahoe-lafs {};

  tailor = callPackage ../applications/version-management/tailor {};

  taizen = callPackage ../applications/misc/taizen {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tambura = callPackage ../applications/audio/tambura { };

  teams = callPackage ../applications/networking/instant-messengers/teams { };

  teamspeak_client = libsForQt512.callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };
  teamspeak_server = callPackage ../applications/networking/instant-messengers/teamspeak/server.nix { };

  taskell = callPackage ../applications/misc/taskell { };

  taskjuggler = callPackage ../applications/misc/taskjuggler { };

  tabula = callPackage ../applications/misc/tabula { };

  tasknc = callPackage ../applications/misc/tasknc { };

  taskwarrior = callPackage ../applications/misc/taskwarrior { };

  tasksh = callPackage ../applications/misc/tasksh { };

  taskserver = callPackage ../servers/misc/taskserver { };

  taskopen = callPackage ../applications/misc/taskopen { };

  tdesktop = qt5.callPackage ../applications/networking/instant-messengers/telegram/tdesktop { };

  telepathy-gabble = callPackage ../applications/networking/instant-messengers/telepathy/gabble { };

  telepathy-haze = callPackage ../applications/networking/instant-messengers/telepathy/haze {};

  telepathy-logger = callPackage ../applications/networking/instant-messengers/telepathy/logger {};

  telepathy-mission-control = callPackage ../applications/networking/instant-messengers/telepathy/mission-control { };

  telepathy-salut = callPackage ../applications/networking/instant-messengers/telepathy/salut {};

  telepathy-idle = callPackage ../applications/networking/instant-messengers/telepathy/idle {};

  teleprompter = callPackage ../applications/misc/teleprompter {};

  tendermint = callPackage ../tools/networking/tendermint {
    buildGoModule = buildGo112Module;
  };

  termdown = (newScope pythonPackages) ../applications/misc/termdown { };

  terminal-notifier = callPackage ../applications/misc/terminal-notifier {};

  terminator = callPackage ../applications/misc/terminator { };

  terminus = callPackage ../applications/misc/terminus { };

  lxterminal = callPackage ../applications/misc/lxterminal { };

  aminal = callPackage ../applications/misc/aminal {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa Kernel;
  };

  termite-unwrapped = callPackage ../applications/misc/termite { };

  termite = callPackage ../applications/misc/termite/wrapper.nix { termite = termite-unwrapped; };

  termtosvg = callPackage ../tools/misc/termtosvg { };

  inherit (callPackage ../applications/graphics/tesseract {})
    tesseract3
    tesseract4;
  tesseract = tesseract3;

  tetraproc = callPackage ../applications/audio/tetraproc { };

  tev = callPackage ../applications/graphics/tev { };

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  thonny = callPackage ../applications/editors/thonny { };

  thunderbird = callPackage ../applications/networking/mailreaders/thunderbird {
    inherit (gnome2) libIDL;
    libpng = libpng_apng;
    gtk3Support = true;
  };

  thunderbolt = callPackage ../os-specific/linux/thunderbolt {};

  thunderbird-bin = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
  };

  ticpp = callPackage ../development/libraries/ticpp { };

  tig = gitAndTools.tig;

  tilda = callPackage ../applications/misc/tilda {
    gtk = gtk3;
  };

  timbreid = callPackage ../applications/audio/pd-plugins/timbreid {
    fftw = fftwSinglePrec;
  };

  timewarrior = callPackage ../applications/misc/timewarrior { };

  timidity = callPackage ../tools/misc/timidity { };

  tint2 = callPackage ../applications/misc/tint2 { };

  tiny = callPackage ../applications/networking/irc/tiny { };

  tipp10 = qt5.callPackage ../applications/misc/tipp10 { };

  tixati = callPackage ../applications/networking/p2p/tixati { };

  tkcvs = callPackage ../applications/version-management/tkcvs { };

  tla = callPackage ../applications/version-management/arch { };

  tlf = callPackage ../applications/radio/tlf { };

  tlp = callPackage ../tools/misc/tlp {
    inherit (linuxPackages) x86_energy_perf_policy;
  };

  tippecanoe = callPackage ../applications/misc/tippecanoe { };

  tmatrix = callPackage ../applications/misc/tmatrix { };

  tnef = callPackage ../applications/misc/tnef { };

  todiff = callPackage ../applications/misc/todiff { };

  todo-txt-cli = callPackage ../applications/office/todo.txt-cli { };

  todoman = callPackage ../applications/office/todoman { };

  toggldesktop = libsForQt5.callPackage ../applications/misc/toggldesktop { };

  topydo = callPackage ../applications/misc/topydo {};

  torchat = callPackage ../applications/networking/instant-messengers/torchat {
    inherit (pythonPackages) wrapPython wxPython;
  };

  torrential = callPackage ../applications/networking/p2p/torrential { };

  tortoisehg = callPackage ../applications/version-management/tortoisehg { };

  tony = libsForQt5.callPackage ../applications/audio/tony { };

  toot = callPackage ../applications/misc/toot { };

  tootle = callPackage ../applications/misc/tootle { };

  toxic = callPackage ../applications/networking/instant-messengers/toxic { };

  toxiproxy = callPackage ../development/tools/toxiproxy { };

  tqsl = callPackage ../applications/radio/tqsl { };
  trustedqsl = tqsl; # Alias added 2019-02-10

  transcode = callPackage ../applications/audio/transcode { };

  transcribe = callPackage ../applications/audio/transcribe { };

  transmission = callPackage ../applications/networking/p2p/transmission { };
  transmission-gtk = transmission.override { enableGTK3 = true; };

  transmission-remote-cli = callPackage ../applications/networking/p2p/transmission-remote-cli {};
  transmission-remote-gtk = callPackage ../applications/networking/p2p/transmission-remote-gtk {};

  transgui = callPackage ../applications/networking/p2p/transgui { };

  traverso = libsForQt5.callPackage ../applications/audio/traverso { };

  trayer = callPackage ../applications/window-managers/trayer { };

  tree-from-tags = callPackage ../applications/audio/tree-from-tags { };

  tdrop = callPackage ../applications/misc/tdrop { };

  tre-command = callPackage ../tools/system/tre-command {};

  tree = callPackage ../tools/system/tree {};

  treesheets = callPackage ../applications/office/treesheets { wxGTK = wxGTK31; };

  tribler = callPackage ../applications/networking/p2p/tribler { };

  trojita = libsForQt5.callPackage ../applications/networking/mailreaders/trojita {
    inherit (kdeApplications) akonadi-contacts;
  };

  tudu = callPackage ../applications/office/tudu { };

  tuxguitar = callPackage ../applications/editors/music/tuxguitar { };

  twister = callPackage ../applications/networking/p2p/twister { };

  twmn = libsForQt5.callPackage ../applications/misc/twmn { };

  testssl = callPackage ../applications/networking/testssl { };

  ulauncher = callPackage ../applications/misc/ulauncher { };

  twinkle = qt5.callPackage ../applications/networking/instant-messengers/twinkle { };

  ueberzug = with python3Packages; toPythonApplication ueberzug;

  umurmur = callPackage ../applications/networking/umurmur { };

  udocker = pythonPackages.callPackage ../tools/virtualization/udocker { };

  uefitoolPackages = recurseIntoAttrs (callPackage ../tools/system/uefitool/variants.nix {});
  uefitool = uefitoolPackages.new-engine;

  unigine-valley = callPackage ../applications/graphics/unigine-valley { };

  unison = callPackage ../applications/networking/sync/unison {
    enableX11 = config.unison.enableX11 or true;
  };

  unpaper = callPackage ../tools/graphics/unpaper { };

  unison-ucm = callPackage ../development/compilers/unison { };

  urh = callPackage ../applications/radio/urh { };

  uuagc = haskell.lib.justStaticExecutables haskellPackages.uuagc;

  uucp = callPackage ../tools/misc/uucp { };

  uvccapture = callPackage ../applications/video/uvccapture { };

  uwimap = callPackage ../tools/networking/uwimap { };

  utox = callPackage ../applications/networking/instant-messengers/utox { };

  valentina = libsForQt5.callPackage ../applications/misc/valentina { };

  vbindiff = callPackage ../applications/editors/vbindiff { };

  vcprompt = callPackage ../applications/version-management/vcprompt { };

  vcv-rack = callPackage ../applications/audio/vcv-rack { };

  vdirsyncer = callPackage ../tools/misc/vdirsyncer {
    inherit (darwin.apple_sdk.frameworks) CoreServices Security;
  };

  vdirsyncerStable = callPackage ../tools/misc/vdirsyncer/stable.nix { };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  verbiste = callPackage ../applications/misc/verbiste {
    inherit (gnome2) libgnomeui;
  };

  vim = callPackage ../applications/editors/vim {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  vimiv = callPackage ../applications/graphics/vimiv { };

  macvim = callPackage ../applications/editors/vim/macvim.nix { stdenv = clangStdenv; };

  vimHugeX = vim_configurable;

  vim_configurable = vimUtils.makeCustomizable (callPackage ../applications/editors/vim/configurable.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc;
    gtk2 = if stdenv.isDarwin then gtk2-x11 else gtk2;
    gtk3 = if stdenv.isDarwin then gtk3-x11 else gtk3;
  });

  vimacs = callPackage ../applications/editors/vim/vimacs.nix { };

  qpdfview = libsForQt5.callPackage ../applications/misc/qpdfview {};

  qtile = callPackage ../applications/window-managers/qtile {
    inherit (xorg) libxcb;
  };

  qvim = lowPrio (callPackage ../applications/editors/vim/qvim.nix {
    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  vimpc = callPackage ../applications/audio/vimpc { };

  wrapNeovim = callPackage ../applications/editors/neovim/wrapper.nix { };

  neovim-unwrapped = callPackage ../applications/editors/neovim {
    lua =
      # neovim doesn't work with luajit on aarch64: https://github.com/neovim/neovim/issues/7879
      if stdenv.isAarch64 then lua5_1 else
      luajit;
  };

  neovim = wrapNeovim neovim-unwrapped { };

  neovim-qt = libsForQt5.callPackage ../applications/editors/neovim/qt.nix { };

  gnvim-unwrapped = callPackage ../applications/editors/neovim/gnvim {
    gtk = pkgs.gtk3;
  };

  gnvim = callPackage ../applications/editors/neovim/gnvim/wrapper.nix { };

  neovim-remote = callPackage ../applications/editors/neovim/neovim-remote.nix { pythonPackages = python3Packages; };

  vis = callPackage ../applications/editors/vis {
    inherit (lua52Packages) lpeg;
  };

  virt-viewer = callPackage ../applications/virtualization/virt-viewer { };

  virt-top = callPackage ../applications/virtualization/virt-top { };

  virt-what = callPackage ../applications/virtualization/virt-what { };

  virt-manager = callPackage ../applications/virtualization/virt-manager {
    system-libvirt = libvirt;
  };

  virt-manager-qt = libsForQt5.callPackage ../applications/virtualization/virt-manager/qt.nix {
    qtermwidget = lxqt.qtermwidget;
  };

  virtinst = callPackage ../applications/virtualization/virtinst {};

  virtscreen = callPackage ../tools/admin/virtscreen {};

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

  vpcs = callPackage ../applications/virtualization/vpcs { };

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

  uvcdynctrl = callPackage ../os-specific/linux/uvcdynctrl { };

  vkeybd = callPackage ../applications/audio/vkeybd {};

  vlc = libsForQt5.vlc;

  vlc_qt5 = vlc;

  vmpk = callPackage ../applications/audio/vmpk { };

  vnstat = callPackage ../applications/networking/vnstat { };

  vocal = callPackage ../applications/audio/vocal { };

  vogl = libsForQt5.callPackage ../development/tools/vogl { };

  volnoti = callPackage ../applications/misc/volnoti { };

  vorbis-tools = callPackage ../applications/audio/vorbis-tools { };

  vscode = callPackage ../applications/editors/vscode/vscode.nix { };

  vscode-with-extensions = callPackage ../applications/editors/vscode/with-extensions.nix {};

  vscode-utils = callPackage ../misc/vscode-extensions/vscode-utils.nix {};

  vscode-extensions = recurseIntoAttrs (callPackage ../misc/vscode-extensions {});

  vscodium = callPackage ../applications/editors/vscode/vscodium.nix { };

  vue = callPackage ../applications/misc/vue { };

  vuze = callPackage ../applications/networking/p2p/vuze { };

  vwm = callPackage ../applications/window-managers/vwm { };

  vym = qt5.callPackage ../applications/misc/vym { };

  waon = callPackage ../applications/audio/waon { };

  w3m = callPackage ../applications/networking/browsers/w3m { };

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

  way-cooler = throw ("way-cooler is abandoned by its author: " +
    "https://way-cooler.org/blog/2020/01/09/way-cooler-post-mortem.html");

  waypipe = callPackage ../applications/networking/remote/waypipe { };

  wayv = callPackage ../tools/X11/wayv {};

  wayvnc = callPackage ../applications/networking/remote/wayvnc { };

  webmacs = libsForQt5.callPackage ../applications/networking/browsers/webmacs {};

  webtorrent_desktop = callPackage ../applications/video/webtorrent_desktop {};

  wrapWeechat = callPackage ../applications/networking/irc/weechat/wrapper.nix { };

  weechat-unwrapped = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libobjc;
    inherit (darwin) libresolv;
    guile = guile_2_0;
  };

  weechat = wrapWeechat weechat-unwrapped { };

  weechatScripts = dontRecurseIntoAttrs (callPackage ../applications/networking/irc/weechat/scripts { });

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

  weston = callPackage ../applications/window-managers/weston { };

  whitebox-tools = callPackage ../applications/gis/whitebox-tools {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  windowlab = callPackage ../applications/window-managers/windowlab { };

  windowmaker = callPackage ../applications/window-managers/windowmaker { };

  wily = callPackage ../applications/editors/wily { };

  wings = callPackage ../applications/graphics/wings {
    erlang = erlangR21;
  };

  write_stylus = libsForQt5.callPackage ../applications/graphics/write_stylus { };

  alsamixer.app = callPackage ../applications/window-managers/windowmaker/dockapps/alsamixer.app.nix { };

  wllvm = callPackage  ../development/tools/wllvm { };

  wmcalclock = callPackage ../applications/window-managers/windowmaker/dockapps/wmcalclock.nix { };

  wmsm.app = callPackage ../applications/window-managers/windowmaker/dockapps/wmsm.app.nix { };

  wmsystemtray = callPackage ../applications/window-managers/windowmaker/dockapps/wmsystemtray.nix { };

  wmname = callPackage ../applications/misc/wmname { };

  wmctrl = callPackage ../tools/X11/wmctrl { };

  wmii_hg = callPackage ../applications/window-managers/wmii-hg { };

  wofi = callPackage ../applications/misc/wofi { };

  wordnet = callPackage ../applications/misc/wordnet { };

  wordgrinder = callPackage ../applications/office/wordgrinder { };

  worker = callPackage ../applications/misc/worker { };

  workrave = callPackage ../applications/misc/workrave {
    inherit (python27Packages) cheetah;
    inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };

  worldengine-cli = python3Packages.worldengine;

  wpsoffice = callPackage ../applications/office/wpsoffice {};

  wrapFirefox = callPackage ../applications/networking/browsers/firefox/wrapper.nix { };

  wp-cli = callPackage ../development/tools/wp-cli { };

  retroArchCores =
    let
      cfg = config.retroarch or {};
      inherit (lib) optional;
    in with libretro;
      ([ ]
      ++ optional (cfg.enableAtari800 or false) atari800
      ++ optional (cfg.enableBeetleGBA or false) beetle-gba
      ++ optional (cfg.enableBeetleLynx or false) beetle-lynx
      ++ optional (cfg.enableBeetleNGP or false) beetle-ngp
      ++ optional (cfg.enableBeetlePCEFast or false) beetle-pce-fast
      ++ optional (cfg.enableBeetlePCFX or false) beetle-pcfx
      ++ optional (cfg.enableBeetlePSX or false) beetle-psx
      ++ optional (cfg.enableBeetlePSXHW or false) beetle-psx-hw
      ++ optional (cfg.enableBeetleSaturn or false) beetle-saturn
      ++ optional (cfg.enableBeetleSaturnHW or false) beetle-saturn-hw
      ++ optional (cfg.enableBeetleSNES or false) beetle-snes
      ++ optional (cfg.enableBeetleSuperGrafx or false) beetle-supergrafx
      ++ optional (cfg.enableBeetleWswan or false) beetle-wswan
      ++ optional (cfg.enableBeetleVB or false) beetle-vb
      ++ optional (cfg.enableBlueMSX or false) bluemsx
      ++ optional (cfg.enableBsnesMercury or false) bsnes-mercury
      ++ optional (cfg.enableCitra or false) citra
      ++ optional (cfg.enableDesmume or false) desmume
      ++ optional (cfg.enableDesmume2015 or false) desmume2015
      ++ optional (cfg.enableDolphin or false) dolphin
      ++ optional (cfg.enableDOSBox or false) dosbox
      ++ optional (cfg.enableEightyOne or false) eightyone
      ++ optional (cfg.enableFBAlpha2012 or false) fbalpha2012
      ++ optional (cfg.enableFBNeo or false) fbneo
      ++ optional (cfg.enableFceumm or false) fceumm
      ++ optional (cfg.enableFlycast or false) flycast
      ++ optional (cfg.enableFMSX or false) fmsx
      ++ optional (cfg.enableFreeIntv or false) freeintv
      ++ optional (cfg.enableGambatte or false) gambatte
      ++ optional (cfg.enableGenesisPlusGX or false) genesis-plus-gx
      ++ optional (cfg.enableGpsp or false) gpsp
      ++ optional (cfg.enableGW or false) gw
      ++ optional (cfg.enableHandy or false) handy
      ++ optional (cfg.enableHatari or false) hatari
      ++ optional (cfg.enableMAME or false) mame
      ++ optional (cfg.enableMAME2000 or false) mame2000
      ++ optional (cfg.enableMAME2003 or false) mame2003
      ++ optional (cfg.enableMAME2003Plus or false) mame2003-plus
      ++ optional (cfg.enableMAME2010 or false) mame2010
      ++ optional (cfg.enableMAME2015 or false) mame2015
      ++ optional (cfg.enableMAME2016 or false) mame2016
      ++ optional (cfg.enableMesen or false) mesen
      ++ optional (cfg.enableMeteor or false) meteor
      ++ optional (cfg.enableMGBA or false) mgba
      ++ optional (cfg.enableMupen64Plus or false) mupen64plus
      ++ optional (cfg.enableNeoCD or false) neocd
      ++ optional (cfg.enableNestopia or false) nestopia
      ++ optional (cfg.enableO2EM or false) o2em
      ++ optional (cfg.enableOpera or false) opera
      ++ optional (cfg.enableParallelN64 or false) parallel-n64
      ++ optional (cfg.enablePCSXRearmed or false) pcsx_rearmed
      ++ optional (cfg.enablePicodrive or false) picodrive
      ++ optional (cfg.enablePlay or false) play
      ++ optional (cfg.enablePPSSPP or false) ppsspp
      ++ optional (cfg.enablePrboom or false) prboom
      ++ optional (cfg.enableProSystem or false) prosystem
      ++ optional (cfg.enableQuickNES or false) quicknes
      ++ optional (cfg.enableSameBoy or false) sameboy
      ++ optional (cfg.enableScummVM or false) scummvm
      ++ optional (cfg.enableSMSPlusGX or false) smsplus-gx
      ++ optional (cfg.enableSnes9x or false) snes9x
      ++ optional (cfg.enableSnes9x2002 or false) snes9x2002
      ++ optional (cfg.enableSnes9x2005 or false) snes9x2005
      ++ optional (cfg.enableSnes9x2010 or false) snes9x2010
      ++ optional (cfg.enableStella or false) stella
      ++ optional (cfg.enableStella2014 or false) stella2014
      ++ optional (cfg.enableTGBDual or false) tgbdual
      ++ optional (cfg.enableTIC80 or false) tic80
      ++ optional (cfg.enableVbaNext or false) vba-next
      ++ optional (cfg.enableVbaM or false) vba-m
      ++ optional (cfg.enableVecx or false) vecx
      ++ optional (cfg.enableVirtualJaguar or false) virtualjaguar
      ++ optional (cfg.enableYabause or false) yabause
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
      ++ optional (config.kodi.enableInputStreamAdaptive or false) inputstream-adaptive
      ++ optional (config.kodi.enableVFSSFTP or false) vfs-sftp
      ++ optional (config.kodi.enableVFSLibarchive or false) vfs-libarchive
      );
  };

  wsjtx = qt5.callPackage ../applications/radio/wsjtx { };

  wxhexeditor = callPackage ../applications/editors/wxhexeditor {
    wxGTK = wxGTK31;
  };

  wxcam = callPackage ../applications/video/wxcam {
    inherit (gnome2) libglade;
    wxGTK = wxGTK28;
    gtk = gtk2;
  };

  x11basic = callPackage ../development/compilers/x11basic { };

  x11vnc = callPackage ../tools/X11/x11vnc { };

  x11spice = callPackage ../tools/X11/x11spice { };

  x2goclient = libsForQt5.callPackage ../applications/networking/remote/x2goclient { };

  x2goserver = callPackage ../applications/networking/remote/x2goserver { };

  x2vnc = callPackage ../tools/X11/x2vnc { };

  x32edit = callPackage ../applications/audio/midas/x32edit.nix {};

  x42-avldrums = callPackage ../applications/audio/x42-avldrums { };

  x42-gmsynth = callPackage ../applications/audio/x42-gmsynth { };

  x42-plugins = callPackage ../applications/audio/x42-plugins { };

  xannotate = callPackage ../tools/X11/xannotate {};

  xaos = callPackage ../applications/graphics/xaos {
    libpng = libpng12;
  };

  xara = callPackage ../applications/graphics/xara { };

  xastir = callPackage ../applications/misc/xastir {
    rastermagick = imagemagick;
    inherit (xorg) libXt;
  };

  xautomation = callPackage ../tools/X11/xautomation { };

  xawtv = callPackage ../applications/video/xawtv { };

  xbindkeys = callPackage ../tools/X11/xbindkeys { };

  xbindkeys-config = callPackage ../tools/X11/xbindkeys-config {
    gtk = gtk2;
  };

  kodiPlain = callPackage ../applications/video/kodi { };

  kodiPlainWayland = callPackage ../applications/video/kodi { useWayland = true; };

  kodiGBM = callPackage ../applications/video/kodi { useGbm = true; };

  kodiPlugins = recurseIntoAttrs (callPackage ../applications/video/kodi/plugins.nix {});

  kodi = wrapKodi {
    kodi = kodiPlain;
  };

  kodi-wayland = wrapKodi {
    kodi = kodiPlainWayland;
  };

  kodi-gbm = wrapKodi {
    kodi = kodiGBM;
  };

  kodi-cli = callPackage ../tools/misc/kodi-cli { };

  kodi-retroarch-advanced-launchers =
    callPackage ../misc/emulators/retroarch/kodi-advanced-launchers.nix {
      cores = retroArchCores;
  };
  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers;

  xca = libsForQt5.callPackage ../applications/misc/xca { };

  xcalib = callPackage ../tools/X11/xcalib { };

  xcape = callPackage ../tools/X11/xcape { };

  xchainkeys = callPackage ../tools/X11/xchainkeys { };

  xchm = callPackage ../applications/misc/xchm { };

  inherit (xorg) xcompmgr;

  picom = callPackage ../applications/window-managers/picom {};

  xdaliclock = callPackage ../tools/misc/xdaliclock {};

  xdg-dbus-proxy = callPackage ../development/libraries/xdg-dbus-proxy { };

  xdg-desktop-portal = callPackage ../development/libraries/xdg-desktop-portal { };

  xdg-desktop-portal-gtk = callPackage ../development/libraries/xdg-desktop-portal-gtk { };

  xdg-user-dirs = callPackage ../tools/X11/xdg-user-dirs { };

  xdg_utils = callPackage ../tools/X11/xdg-utils {
    w3m = w3m-batch;
  };

  xdgmenumaker = callPackage ../applications/misc/xdgmenumaker { };

  xdotool = callPackage ../tools/X11/xdotool { };

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

  xkbset = callPackage ../tools/X11/xkbset { };

  xkbmon = callPackage ../applications/misc/xkbmon { };

  win-spice = callPackage ../applications/virtualization/driver/win-spice { };
  win-virtio = callPackage ../applications/virtualization/driver/win-virtio { };
  win-qemu = callPackage ../applications/virtualization/driver/win-qemu { };
  win-pvdrivers = callPackage ../applications/virtualization/driver/win-pvdrivers { };
  win-signed-gplpv-drivers = callPackage ../applications/virtualization/driver/win-signed-gplpv-drivers { };

  xfe = callPackage ../applications/misc/xfe {
    fox = fox_1_6;
  };

  xfig = callPackage ../applications/graphics/xfig { };

  xfractint = callPackage ../applications/graphics/xfractint {};

  xineUI = callPackage ../applications/video/xine-ui { };

  xmind = callPackage ../applications/misc/xmind { };

  xneur = callPackage ../applications/misc/xneur {
    enchant = enchant1;
  };

  gxneur = callPackage ../applications/misc/gxneur  {
    inherit (gnome2) libglade GConf;
  };

  xiphos = callPackage ../applications/misc/xiphos {
    gconf = gnome2.GConf;
    inherit (gnome2) libglade scrollkeeper;
    gtkhtml = gnome2.gtkhtml4;
    python = python27;
    enchant = enchant1;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome2) libgnomeprint libgnomeprintui libgnomecanvas;
  };

  xournalpp = callPackage ../applications/graphics/xournalpp {
    lua = lua5_3;
  };

  apvlv = callPackage ../applications/misc/apvlv { };

  xpdf = libsForQt5.callPackage ../applications/misc/xpdf { };

  xpointerbarrier = callPackage ../tools/X11/xpointerbarrier {};

  xkb-switch = callPackage ../tools/X11/xkb-switch { };

  xkblayout-state = callPackage ../applications/misc/xkblayout-state { };

  xmobar = haskellPackages.xmobar;

  xmonad-log = callPackage ../tools/misc/xmonad-log { };

  xmonad-with-packages = callPackage ../applications/window-managers/xmonad/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = self: [ haskellPackages.xmonad-contrib ];
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

  xmpp-client = callPackage ../applications/networking/instant-messengers/xmpp-client { };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra { };
  libfakeXinerama = callPackage ../tools/X11/xpra/libfakeXinerama.nix { };

  xrectsel = callPackage ../tools/X11/xrectsel { };

  xrestop = callPackage ../tools/X11/xrestop { };

  xsd = callPackage ../development/libraries/xsd { };

  xscope = callPackage ../applications/misc/xscope { };

  xscreensaver = callPackage ../misc/screensavers/xscreensaver {
    inherit (gnome2) libglade;
  };

  xsuspender = callPackage ../applications/misc/xsuspender {  };

  xss-lock = callPackage ../misc/screensavers/xss-lock { };

  xloadimage = callPackage ../tools/X11/xloadimage { };

  xssproxy = callPackage ../misc/screensavers/xssproxy { };

  xsynth_dssi = callPackage ../applications/audio/xsynth-dssi { };

  xterm = callPackage ../applications/misc/xterm { };

  mlterm = callPackage ../applications/misc/mlterm {
    libssh2 = null;
    openssl = null;
  };

  roxterm = callPackage ../applications/misc/roxterm { };

  termonad-with-packages = callPackage ../applications/misc/termonad {
    inherit (haskellPackages) ghcWithPackages;
  };

  xtrace = callPackage ../tools/X11/xtrace { };

  xtruss = callPackage ../tools/X11/xtruss { };

  xmacro = callPackage ../tools/X11/xmacro { };

  xmlcopyeditor = callPackage ../applications/editors/xmlcopyeditor { };

  xmp = callPackage ../applications/audio/xmp { };

  xnee = callPackage ../tools/X11/xnee { };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gnome2) scrollkeeper libglade;
  };

  xygrib = libsForQt5.callPackage ../applications/misc/xygrib/default.nix {};

  xzgv = callPackage ../applications/graphics/xzgv { };

  yabar = callPackage ../applications/window-managers/yabar { };

  yabar-unstable = callPackage ../applications/window-managers/yabar/unstable.nix { };

  yarp = callPackage ../applications/science/robotics/yarp {};

  yarssr = callPackage ../applications/misc/yarssr { };

  yate = callPackage ../applications/misc/yate { };

  ydiff = callPackage ../development/tools/ydiff { };

  yed = callPackage ../applications/graphics/yed {};

  yeetgif = callPackage ../applications/graphics/yeetgif { };

  inherit (gnome3) yelp;

  yelp-tools = callPackage ../development/misc/yelp-tools { };

  yokadi = python3Packages.callPackage ../applications/misc/yokadi {};

  yoshimi = callPackage ../applications/audio/yoshimi { };

  youtube-dl = with python3Packages; toPythonApplication youtube-dl;

  youtube-dl-light = with python3Packages; toPythonApplication youtube-dl-light;

  youtube-viewer = perlPackages.WWWYoutubeViewer;

  ytcc = callPackage ../tools/networking/ytcc { };

  zam-plugins = callPackage ../applications/audio/zam-plugins { };

  zanshin = libsForQt5.callPackage ../applications/office/zanshin {
    inherit (kdeApplications) akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap;
    inherit (kdeFrameworks) krunner kwallet kcalendarcore;
    boost = boost160;
  };

  zathura = callPackage ../applications/misc/zathura { };

  zeroc-ice = callPackage ../development/libraries/zeroc-ice {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  zeroc-ice-cpp11 = zeroc-ice.override { cpp11 = true; };

  zeroc-ice-36 = callPackage ../development/libraries/zeroc-ice/3.6.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  zeronet = callPackage ../applications/networking/p2p/zeronet { };

  zexy = callPackage ../applications/audio/pd-plugins/zexy  { };

  zgrviewer = callPackage ../applications/graphics/zgrviewer {};

  zgv = callPackage ../applications/graphics/zgv {
   # Enable the below line for terminal display. Note
   # that it requires sixel graphics compatible terminals like mlterm
   # or xterm -ti 340
   SDL = SDL_sixel;
  };

  zim = callPackage ../applications/office/zim { };

  zita-ajbridge = callPackage ../applications/audio/zita-ajbridge { };

  zita-at1 = callPackage ../applications/audio/zita-at1 { };

  zita-njbridge = callPackage ../applications/audio/zita-njbridge { };

  zola = callPackage ../applications/misc/zola {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  zoom-us = libsForQt5.callPackage ../applications/networking/instant-messengers/zoom-us { };

  zotero = callPackage ../applications/office/zotero { };

  zscroll = callPackage ../applications/misc/zscroll {};

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx { };

  ### BLOCKCHAINS / CRYPTOCURRENCIES / WALLETS

  aeon = callPackage ../applications/blockchains/aeon { };

  bitcoin  = libsForQt5.callPackage ../applications/blockchains/bitcoin.nix { miniupnpc = miniupnpc_2; withGui = true; };
  bitcoind = callPackage ../applications/blockchains/bitcoin.nix { miniupnpc = miniupnpc_2; withGui = false; };
  clightning = callPackage ../applications/blockchains/clightning.nix { };

  bitcoin-abc  = libsForQt5.callPackage ../applications/blockchains/bitcoin-abc.nix { boost = boost165; withGui = true; };
  bitcoind-abc = callPackage ../applications/blockchains/bitcoin-abc.nix {
    boost = boost165;
    mkDerivation = stdenv.mkDerivation;
    withGui = false;
  };

  bitcoin-unlimited  = libsForQt5.callPackage ../applications/blockchains/bitcoin-unlimited.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    withGui = true;
  };
  bitcoind-unlimited = callPackage ../applications/blockchains/bitcoin-unlimited.nix {
    inherit (darwin.apple_sdk.frameworks) Foundation ApplicationServices AppKit;
    withGui = false;
  };

  bitcoin-classic  = libsForQt5.callPackage ../applications/blockchains/bitcoin-classic.nix { boost = boost165; withGui = true; };
  bitcoind-classic = callPackage ../applications/blockchains/bitcoin-classic.nix { boost = boost165; withGui = false; };

  bitcoin-gold = libsForQt5.callPackage ../applications/blockchains/bitcoin-gold.nix { boost = boost165; withGui = true; };
  bitcoind-gold = callPackage ../applications/blockchains/bitcoin-gold.nix { boost = boost165; withGui = false; };

  btc1 = callPackage ../applications/blockchains/btc1.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit;
    boost = boost165;
  };
  btc1d = btc1.override { withGui = false; };

  cryptop = python3.pkgs.callPackage ../applications/blockchains/cryptop { };

  dashpay = callPackage ../applications/blockchains/dashpay.nix { };

  dcrd = callPackage ../applications/blockchains/dcrd.nix { };
  dcrwallet = callPackage ../applications/blockchains/dcrwallet.nix { };

  dero = callPackage ../applications/blockchains/dero.nix { boost = boost165; };

  digibyte = libsForQt5.callPackage ../applications/blockchains/digibyte.nix { withGui = true; };
  digibyted = callPackage ../applications/blockchains/digibyte.nix { withGui = false; };

  dogecoin  = callPackage ../applications/blockchains/dogecoin.nix { boost = boost165; withGui = true; };
  dogecoind = callPackage ../applications/blockchains/dogecoin.nix { boost = boost165; withGui = false; };

  exodus = callPackage ../applications/blockchains/exodus { };

  freicoin = callPackage ../applications/blockchains/freicoin.nix { boost = boost155; };
  go-ethereum = callPackage ../applications/blockchains/go-ethereum.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  ledger_agent = with python3Packages; toPythonApplication ledger_agent;

  ledger-live-desktop = callPackage ../applications/blockchains/ledger-live-desktop { };

  litecoin  = libsForQt5.callPackage ../applications/blockchains/litecoin.nix {
    inherit (darwin.apple_sdk.frameworks) AppKit;
  };
  litecoind = litecoin.override { withGui = false; };

  lnd = callPackage ../applications/blockchains/lnd.nix {
    buildGoModule = buildGo112Module;
  };

  monero = callPackage ../applications/blockchains/monero {
    inherit (darwin.apple_sdk.frameworks) CoreData IOKit PCSC;
    pythonProtobuf = python3Packages.protobuf.override { protobuf = protobuf3_10; };
  };

  monero-gui = libsForQt5.callPackage ../applications/blockchains/monero-gui {
    boost = boost16x;
    protobuf = protobuf3_10;
  };

  masari = callPackage ../applications/blockchains/masari.nix { boost = boost165; };

  mist = callPackage ../applications/blockchains/mist.nix { };

  nano-wallet = libsForQt5.callPackage ../applications/blockchains/nano-wallet { };

  namecoin  = callPackage ../applications/blockchains/namecoin.nix  { withGui = true; };
  namecoind = callPackage ../applications/blockchains/namecoin.nix { withGui = false; };

  pivx = libsForQt5.callPackage ../applications/blockchains/pivx.nix { withGui = true; };
  pivxd = callPackage ../applications/blockchains/pivx.nix { withGui = false; };

  ethabi = callPackage ../applications/blockchains/ethabi.nix { };

  stellar-core = callPackage ../applications/blockchains/stellar-core.nix { };

  sumokoin = callPackage ../applications/blockchains/sumokoin.nix { boost = boost165; };

  tessera = callPackage ../applications/blockchains/tessera.nix { };

  vertcoin  = libsForQt5.callPackage ../applications/blockchains/vertcoin.nix { boost = boost165; withGui = true; };
  vertcoind = callPackage ../applications/blockchains/vertcoin.nix { boost = boost165; withGui = false; };

  wasabiwallet = callPackage ../applications/blockchains/wasabiwallet { };

  wownero = callPackage ../applications/blockchains/wownero.nix {};

  zcash = callPackage ../applications/blockchains/zcash { };

  parity = callPackage ../applications/blockchains/parity { };

  parity-ui = callPackage ../applications/blockchains/parity-ui { };

  polkadot = callPackage ../applications/blockchains/polkadot { };

  particl-core = callPackage ../applications/blockchains/particl/particl-core.nix { miniupnpc = miniupnpc_2; };

  quorum = callPackage ../applications/blockchains/quorum.nix { };

  ### GAMES

  _2048-in-terminal = callPackage ../games/2048-in-terminal { };

  _20kly = callPackage ../games/20kly { };

  _90secondportraits = callPackage ../games/90secondportraits { love = love_0_10; };

  abbaye-des-morts = callPackage ../games/abbaye-des-morts { };

  adom = callPackage ../games/adom { };

  airstrike = callPackage ../games/airstrike { };

  alephone = callPackage ../games/alephone { ffmpeg = ffmpeg_2; };
  alephone-durandal = callPackage ../games/alephone/durandal { };
  alephone-eternal = callPackage ../games/alephone/eternal { };
  alephone-evil = callPackage ../games/alephone/evil { };
  alephone-infinity = callPackage ../games/alephone/infinity { };
  alephone-marathon = callPackage ../games/alephone/marathon { };
  alephone-pheonix = callPackage ../games/alephone/pheonix { };
  alephone-red = callPackage ../games/alephone/red { };
  alephone-rubicon-x = callPackage ../games/alephone/rubicon-x { };
  alephone-pathways-into-darkness =
    callPackage ../games/alephone/pathways-into-darkness { };

  alienarena = callPackage ../games/alienarena { };

  amoeba = callPackage ../games/amoeba { };
  amoeba-data = callPackage ../games/amoeba/data.nix { };

  andyetitmoves = callPackage ../games/andyetitmoves {};

  angband = callPackage ../games/angband { };

  anki = python3Packages.callPackage ../games/anki {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  armagetronad = callPackage ../games/armagetronad { };

  arena = callPackage ../games/arena {};

  arx-libertatis = libsForQt5.callPackage ../games/arx-libertatis {
    stdenv = gcc6Stdenv;
  };

  asc = callPackage ../games/asc {
    lua = lua5_1;
    libsigcxx = libsigcxx12;
    physfs = physfs_2;
  };

  assaultcube = callPackage ../games/assaultcube { };

  astromenace = callPackage ../games/astromenace { };

  atanks = callPackage ../games/atanks {};

  azimuth = callPackage ../games/azimuth {};

  ballAndPaddle = callPackage ../games/ball-and-paddle {
    guile = guile_1_8;
  };

  banner = callPackage ../games/banner {};

  bastet = callPackage ../games/bastet {};

  beancount = with python3.pkgs; toPythonApplication beancount;

  bean-add = callPackage ../applications/office/beancount/bean-add.nix { };

  bench = haskell.lib.justStaticExecutables haskellPackages.bench;

  beret = callPackage ../games/beret { };

  bitsnbots = callPackage ../games/bitsnbots {
    lua = lua5;
  };

  blackshades = callPackage ../games/blackshades { };

  blobby = callPackage ../games/blobby { };

  boohu = callPackage ../games/boohu { };

  braincurses = callPackage ../games/braincurses { };

  brogue = callPackage ../games/brogue { };

  bsdgames = callPackage ../games/bsdgames { };

  btanks = callPackage ../games/btanks { };

  bzflag = callPackage ../games/bzflag {
    inherit (darwin.apple_sdk.frameworks) Carbon CoreServices;
  };

  cataclysm-dda = callPackage ../games/cataclysm-dda {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
  };

  cataclysm-dda-git = callPackage ../games/cataclysm-dda/git.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa;
  };

  chessdb = callPackage ../games/chessdb { };

  chessx = libsForQt5.callPackage ../games/chessx { };

  chiaki = libsForQt5.callPackage ../games/chiaki { };

  chocolateDoom = callPackage ../games/chocolate-doom { };

  crispyDoom = callPackage ../games/crispy-doom { };

  cri-o = callPackage ../applications/virtualization/cri-o {
    buildGoPackage = buildGo112Package;
  };

  ckan = callPackage ../games/ckan { };

  cockatrice = libsForQt5.callPackage ../games/cockatrice {  };

  commandergenius = callPackage ../games/commandergenius { };

  confd = callPackage ../tools/system/confd { };

  conmon = callPackage ../applications/virtualization/conmon { };

  construoBase = lowPrio (callPackage ../games/construo {
    libGL = null;
    libGLU = null;
    freeglut = null;
  });

  construo = construoBase.override {
    inherit libGL libGLU freeglut;
  };

  crack_attack = callPackage ../games/crack-attack { };

  crafty = callPackage ../games/crafty { };

  crawlTiles = callPackage ../games/crawl {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  crrcsim = callPackage ../games/crrcsim {};

  curseofwar = callPackage ../games/curseofwar { SDL = null; };
  curseofwar-sdl = callPackage ../games/curseofwar { ncurses = null; };

  cutemaze = libsForQt5.callPackage ../games/cutemaze {};

  cuyo = callPackage ../games/cuyo { };

  devilutionx = callPackage ../games/devilutionx {};

  dhewm3 = callPackage ../games/dhewm3 {};

  digikam = libsForQt5.callPackage ../applications/graphics/digikam {
    inherit (plasma5) oxygen;
    inherit (kdeApplications) akonadi-contacts;
    inherit (kdeFrameworks) kcalendarcore;
    ffmpeg = ffmpeg_4;
    opencv3 = opencv3WithoutCuda;
  };

  displaycal = callPackage ../applications/graphics/displaycal {};

  drumkv1 = libsForQt5.callPackage ../applications/audio/drumkv1 { };

  duckmarines = callPackage ../games/duckmarines { love = love_0_10; };

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

  easyrpg-player = callPackage ../games/easyrpg-player { };

  eboard = callPackage ../games/eboard { };

  eduke32 = callPackage ../games/eduke32 { };

  egoboo = callPackage ../games/egoboo { };

  eidolon = callPackage ../games/eidolon { };

  EmptyEpsilon = callPackage ../games/empty-epsilon { };

  endgame-singularity = callPackage ../games/endgame-singularity { };

  endless-sky = callPackage ../games/endless-sky { };

  enyo-doom = libsForQt5.callPackage ../games/enyo-doom { };

  eternity = callPackage ../games/eternity-engine { };

  eureka-editor = callPackage ../applications/misc/eureka-editor { };

  extremetuxracer = callPackage ../games/extremetuxracer {
    libpng = libpng12;
  };

  exult = callPackage ../games/exult { };

  fltrator = callPackage ../games/fltrator { };

  factorio = callPackage ../games/factorio { releaseType = "alpha"; };

  factorio-experimental = factorio.override { releaseType = "alpha"; experimental = true; };

  factorio-headless = factorio.override { releaseType = "headless"; };

  factorio-headless-experimental = factorio.override { releaseType = "headless"; experimental = true; };

  factorio-demo = factorio.override { releaseType = "demo"; };

  factorio-mods = callPackage ../games/factorio/mods.nix { };

  factorio-utils = callPackage ../games/factorio/utils.nix { };

  fairymax = callPackage ../games/fairymax {};

  fava = callPackage ../applications/office/fava {};

  fish-fillets-ng = callPackage ../games/fish-fillets-ng {};

  flightgear = libsForQt5.callPackage ../games/flightgear { };

  flock = callPackage ../development/tools/flock { };

  freecell-solver = callPackage ../games/freecell-solver { };

  freeciv = callPackage ../games/freeciv { };

  freeciv_gtk = freeciv.override {
    gtkClient = true;
    sdlClient = false;
  };

  freeciv_qt = freeciv.override {
    qtClient = true;
    sdlClient = false;
  };

  freedink = callPackage ../games/freedink { };

  freeorion = callPackage ../games/freeorion { };

  freesweep = callPackage ../games/freesweep { };

  frotz = callPackage ../games/frotz { };

  frogatto = callPackage ../games/frogatto { };

  frozen-bubble = callPackage ../games/frozen-bubble { };

  fsg = callPackage ../games/fsg {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  galaxis = callPackage ../games/galaxis { };

  gambatte = callPackage ../games/gambatte { };

  garden-of-coloured-lights = callPackage ../games/garden-of-coloured-lights { allegro = allegro4; };

  gargoyle = callPackage ../games/gargoyle {
    inherit (darwin) cctools;
  };

  gav = callPackage ../games/gav { };

  gcs = callPackage ../games/gcs { };

  gcompris = libsForQt5.callPackage ../games/gcompris { };

  gemrb = callPackage ../games/gemrb { };

  gl117 = callPackage ../games/gl-117 {};

  globulation2 = callPackage ../games/globulation {
    boost = boost155;
  };

  gltron = callPackage ../games/gltron { };

  gmad = callPackage ../games/gmad { };

  gnubg = callPackage ../games/gnubg { };

  gnuchess = callPackage ../games/gnuchess { };

  gnugo = callPackage ../games/gnugo { };

  gnujump = callPackage ../games/gnujump { };

  gnushogi = callPackage ../games/gnushogi { };

  gogui = callPackage ../games/gogui {};

  gscrabble = python3Packages.callPackage ../games/gscrabble {};

  gshogi = python3Packages.callPackage ../games/gshogi {};

  qtads = qt5.callPackage ../games/qtads { };

  gtetrinet = callPackage ../games/gtetrinet {
    inherit (gnome2) GConf libgnome libgnomeui;
  };

  gtypist = callPackage ../games/gtypist { };

  gweled = callPackage ../games/gweled {};

  gzdoom = callPackage ../games/gzdoom { };

  harmonist = callPackage ../games/harmonist { };

  hawkthorne = callPackage ../games/hawkthorne { love = love_0_9; };

  hedgewars = libsForQt5.callPackage ../games/hedgewars {
    inherit (haskellPackages) ghcWithPackages;
  };

  holdingnuts = callPackage ../games/holdingnuts { };

  hyperrogue = callPackage ../games/hyperrogue { };

  icbm3d = callPackage ../games/icbm3d { };

  ingen = callPackage ../applications/audio/ingen {
    inherit (pythonPackages) rdflib;
  };

  ideogram = callPackage ../applications/graphics/ideogram { };

  instead = callPackage ../games/instead { };

  instead-launcher = callPackage ../games/instead-launcher { };

  ivan = callPackage ../games/ivan { };

  ja2-stracciatella = callPackage ../games/ja2-stracciatella { };

  katago = callPackage ../games/katago { };

  katagoWithCuda = katago.override {
    cudaSupport = true;
    cudnn = cudnn_cudatoolkit_10_1;
    cudatoolkit = cudatoolkit_10_1;
  };

  klavaro = callPackage ../games/klavaro {};

  kobodeluxe = callPackage ../games/kobodeluxe { };

  leela-zero = libsForQt5.callPackage ../games/leela-zero { };

  lgogdownloader = callPackage ../games/lgogdownloader { };

  liberal-crime-squad = callPackage ../games/liberal-crime-squad { };

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

  lugaru = callPackage ../games/lugaru {};

  macopix = callPackage ../games/macopix {
    gtk = gtk2;
  };

  mars = callPackage ../games/mars { };

  megaglest = callPackage ../games/megaglest {};

  mindustry = callPackage ../games/mindustry { };

  mindustry-server = callPackage ../games/mindustry {
    enableClient = false;
    enableServer = true;
  };

  minecraft = callPackage ../games/minecraft { };

  minecraft-server = callPackage ../games/minecraft-server { };

  moon-buggy = callPackage ../games/moon-buggy {};

  multimc = libsForQt5.callPackage ../games/multimc { };

  inherit (callPackages ../games/minetest {
    inherit (darwin) libiconv;
    inherit (darwin.apple_sdk.frameworks) OpenGL OpenAL Carbon Cocoa;
  })
    minetestclient_4 minetestserver_4
    minetestclient_5 minetestserver_5;

  minetest = minetestclient_5;

  mnemosyne = callPackage ../games/mnemosyne {
    python = python3;
  };

  mrrescue = callPackage ../games/mrrescue { };

  mudlet = libsForQt5.callPackage ../games/mudlet {
    lua = lua5_1;
  };

  n2048 = callPackage ../games/n2048 {};

  naev = callPackage ../games/naev { };

  nethack = callPackage ../games/nethack { };

  nethack-qt = callPackage ../games/nethack {
    qtMode = true;
    stdenv = gccStdenv;
  };

  nethack-x11 = callPackage ../games/nethack { x11Mode = true; };

  neverball = callPackage ../games/neverball { };

  nexuiz = callPackage ../games/nexuiz { };

  njam = callPackage ../games/njam { };

  newtonwars = callPackage ../games/newtonwars { };

  nudoku = callPackage ../games/nudoku { };

  nxengine-evo = callPackage ../games/nxengine-evo { };

  odamex = callPackage ../games/odamex { };

  oilrush = callPackage ../games/oilrush { };

  onscripter-en = callPackage ../games/onscripter-en { };

  openarena = callPackage ../games/openarena { };

  opendungeons = callPackage ../games/opendungeons {
    ogre = ogre1_9;
  };

  openlierox = callPackage ../games/openlierox { };

  openclonk = callPackage ../games/openclonk { };

  openjk = callPackage ../games/openjk {
    # segfaults when built with gcc9
    stdenv = gcc8Stdenv;
  };

  openmw = libsForQt5.callPackage ../games/openmw { };

  openmw-tes3mp = libsForQt5.callPackage ../games/openmw/tes3mp.nix {
    openmw = openmw.override {
      stdenv = gcc8Stdenv;
      openscenegraph = openscenegraph.override { stdenv = gcc8Stdenv; };
      mygui = mygui.override { stdenv = gcc8Stdenv; };
    };
  };

  openraPackages = import ../games/openra pkgs;

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

  opentyrian = callPackage ../games/opentyrian { };

  openxcom = callPackage ../games/openxcom { };

  openxray = callPackage ../games/openxray { };

  orthorobot = callPackage ../games/orthorobot { };

  pacvim = callPackage ../games/pacvim { };

  pentobi = libsForQt5.callPackage ../games/pentobi { };

  performous = callPackage ../games/performous {
    boost = boost166;
  };

  pingus = callPackage ../games/pingus {};

  pioneer = callPackage ../games/pioneer { };

  pioneers = callPackage ../games/pioneers { };

  planetary_annihilation = callPackage ../games/planetaryannihilation { };

  pong3d = callPackage ../games/pong3d { };

  pokerth = libsForQt5.callPackage ../games/pokerth { };

  pokerth-server = libsForQt5.callPackage ../games/pokerth { target = "server"; };

  prboom = callPackage ../games/prboom { };

  privateer = callPackage ../games/privateer { };

  pysolfc = python3Packages.callPackage ../games/pysolfc { };

  qweechat = callPackage ../applications/networking/irc/qweechat { };

  qqwing = callPackage ../games/qqwing { };

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
  quake3e = callPackage ../games/quake3/quake3e { };

  quantumminigolf = callPackage ../games/quantumminigolf {};

  racer = callPackage ../games/racer { };

  redeclipse = callPackage ../games/redeclipse { };

  residualvm = callPackage ../games/residualvm { };

  rftg = callPackage ../games/rftg { };

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

  riko4 = callPackage ../games/riko4 { };

  rili = callPackage ../games/rili { };

  rimshot = callPackage ../games/rimshot { love = love_0_7; };

  rogue = callPackage ../games/rogue {
    ncurses = ncurses5;
  };

  robotfindskitten = callPackage ../games/robotfindskitten { };

  rocksndiamonds = callPackage ../games/rocksndiamonds { };

  rrootage = callPackage ../games/rrootage { };

  saga = callPackage ../applications/gis/saga {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  samplv1 = callPackage ../applications/audio/samplv1 { };

  sauerbraten = callPackage ../games/sauerbraten {};

  scaleway-cli = callPackage ../tools/admin/scaleway-cli {
    buildGoPackage = buildGo112Package;
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

  scorched3d = callPackage ../games/scorched3d { };

  scrolls = callPackage ../games/scrolls { };

  service-wrapper = callPackage ../os-specific/linux/service-wrapper { };

  sgtpuzzles = callPackage (callPackage ../games/sgt-puzzles) { };

  shattered-pixel-dungeon = callPackage ../games/shattered-pixel-dungeon { };

  sienna = callPackage ../games/sienna { love = love_0_10; };

  sil = callPackage ../games/sil { };

  simutrans = callPackage ../games/simutrans { };
  # get binaries without data built by Hydra
  simutrans_binaries = lowPrio simutrans.binaries;

  snake4 = callPackage ../games/snake4 { };

  soi = callPackage ../games/soi {
    lua = lua5_1;
  };

  solarus = libsForQt5.callPackage ../games/solarus { };

  solarus-quest-editor = libsForQt5.callPackage ../development/tools/solarus-quest-editor { };

  # You still can override by passing more arguments.
  space-orbit = callPackage ../games/space-orbit { };

  spring = callPackage ../games/spring {
    boost = boost155;
  };

  springLobby = callPackage ../games/spring/springlobby.nix { };

  ssl-cert-check = callPackage ../tools/admin/ssl-cert-check { };

  stardust = callPackage ../games/stardust {};

  stockfish = callPackage ../games/stockfish { };

  steamPackages = dontRecurseIntoAttrs (callPackage ../games/steam { });

  steam = steamPackages.steam-chrootenv;

  steam-run = steam.run;
  steam-run-native = (steam.override {
    nativeOnly = true;
  }).run;

  steamcmd = steamPackages.steamcmd;

  linux-steam-integration = callPackage ../games/linux-steam-integration {
    gtk = pkgs.gtk3;
  };

  protontricks = callPackage ../tools/package-management/protontricks {
    inherit (python3Packages) buildPythonApplication pytest setuptools_scm vdf;
    inherit (gnome3) zenity;
    wine = wineWowPackages.minimal;
    winetricks = winetricks.override {
      wine = wineWowPackages.minimal;
    };
  };

  stepmania = callPackage ../games/stepmania {
    ffmpeg = ffmpeg_2;
  };

  streamlit = python3Packages.callPackage ../applications/science/machine-learning/streamlit { };

  stuntrally = callPackage ../games/stuntrally {
    ogre = ogre1_9;
    mygui = mygui.override {
      withOgre = true;
    };
  };

  superTux = callPackage ../games/supertux { };

  superTuxKart = callPackage ../games/super-tux-kart { };

  synthv1 = libsForQt5.callPackage ../applications/audio/synthv1 { };

  system-syzygy = callPackage ../games/system-syzygy { };

  t4kcommon = callPackage ../games/t4kcommon { };

  tcl2048 = callPackage ../games/tcl2048 { };

  the-powder-toy = callPackage ../games/the-powder-toy {
    lua = lua5_1;
  };

  tbe = callPackage ../games/the-butterfly-effect { };

  teetertorture = callPackage ../games/teetertorture { };

  teeworlds = callPackage ../games/teeworlds { };

  tengine = callPackage ../servers/http/tengine {
    modules = with nginxModules; [ rtmp dav moreheaders modsecurity-nginx ];
  };

  tennix = callPackage ../games/tennix { };

  terraria-server = callPackage ../games/terraria-server { };

  tibia = pkgsi686Linux.callPackage ../games/tibia { };

  tintin = callPackage ../games/tintin { };

  tinyfugue = callPackage ../games/tinyfugue { };

  tome2 = callPackage ../games/tome2 { };

  tome4 = callPackage ../games/tome4 { };

  toppler = callPackage ../games/toppler { };

  trackballs = callPackage ../games/trackballs { };

  tremulous = callPackage ../games/tremulous { };

  tuxpaint = callPackage ../games/tuxpaint { };

  tuxtype = callPackage ../games/tuxtype { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    libpng = libpng12;
  };

  torcs = callPackage ../games/torcs { };

  trigger = callPackage ../games/trigger { };

  typespeed = callPackage ../games/typespeed { };

  ufoai = callPackage ../games/ufoai { };

  ultimatestunts = callPackage ../games/ultimatestunts { };

  ultrastar-creator = libsForQt5.callPackage ../tools/misc/ultrastar-creator { };

  ultrastar-manager = libsForQt5.callPackage ../tools/misc/ultrastar-manager { };

  ultrastardx = callPackage ../games/ultrastardx {
    ffmpeg = ffmpeg_2;
  };

  unnethack = callPackage ../games/unnethack { };

  uqm = callPackage ../games/uqm { };

  urbanterror = callPackage ../games/urbanterror { };

  ue4 = callPackage ../games/ue4 { };

  ue4demos = recurseIntoAttrs (callPackage ../games/ue4demos { });

  ut2004Packages = dontRecurseIntoAttrs (callPackage ../games/ut2004 { });

  ut2004demo = res.ut2004Packages.ut2004 [ res.ut2004Packages.ut2004-demo ];

  vapor = callPackage ../games/vapor { love = love_0_8; };

  vapoursynth = callPackage ../development/libraries/vapoursynth {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  vapoursynth-editor = libsForQt5.callPackage ../development/libraries/vapoursynth/editor.nix { };

  vapoursynth-mvtools = callPackage ../development/libraries/vapoursynth-mvtools { };

  vassal = callPackage ../games/vassal { };

  vdrift = callPackage ../games/vdrift { };

  # To ensure vdrift's code is built on hydra
  vdrift-bin = vdrift.bin;

  vectoroids = callPackage ../games/vectoroids { };

  vessel = pkgsi686Linux.callPackage ../games/vessel { };

  vitetris = callPackage ../games/vitetris { };

  vms-empire = callPackage ../games/vms-empire { };

  voxelands = callPackage ../games/voxelands {
    libpng = libpng12;
  };

  warmux = callPackage ../games/warmux { };

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

  xbomb = callPackage ../games/xbomb { };

  xconq = callPackage ../games/xconq {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  xjump = callPackage ../games/xjump { };
  # TODO: the corresponding nix file is missing
  # xracer = callPackage ../games/xracer { };

  xmoto = callPackage ../games/xmoto { };

  xonotic = callPackage ../games/xonotic { };

  xpilot-ng = callPackage ../games/xpilot { };
  bloodspilot-server = callPackage ../games/xpilot/bloodspilot-server.nix {};
  bloodspilot-client = callPackage ../games/xpilot/bloodspilot-client.nix {};

  xskat = callPackage ../games/xskat { };

  xsnow = callPackage ../games/xsnow { };

  xsok = callPackage ../games/xsok { };

  xsokoban = callPackage ../games/xsokoban { };

  xtris = callPackage ../games/xtris { };

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

  zangband = callPackage ../games/zangband { };

  zaz = callPackage ../games/zaz { };

  zdbsp = callPackage ../games/zdoom/zdbsp.nix { };

  zdoom = callPackage ../games/zdoom { };

  zod = callPackage ../games/zod { };

  zoom = callPackage ../games/zoom { };

  keen4 = callPackage ../games/keen4 { };

  zeroadPackages = dontRecurseIntoAttrs (callPackage ../games/0ad {
    wxGTK = wxGTK30;
  });

  zeroad = zeroadPackages.zeroad;

  ### DESKTOP ENVIRONMENTS

  cdesktopenv = callPackage ../desktops/cdesktopenv { };

  cinnamon = recurseIntoAttrs (callPackage ../desktops/cinnamon { });

  deepin = recurseIntoAttrs (import ../desktops/deepin {
    inherit pkgs libsForQt5;
    inherit (lib) makeScope;
  });

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment {
    callPackage = newScope pkgs.enlightenment;
  });

  gnome2 = recurseIntoAttrs (callPackage ../desktops/gnome-2 { });

  gnome3 = recurseIntoAttrs (callPackage ../desktops/gnome-3 { });

  gnomeExtensions = recurseIntoAttrs {
    appindicator = callPackage ../desktops/gnome-3/extensions/appindicator { };
    arc-menu = callPackage ../desktops/gnome-3/extensions/arc-menu { };
    battery-status = callPackage ../desktops/gnome-3/extensions/battery-status { };
    caffeine = callPackage ../desktops/gnome-3/extensions/caffeine { };
    clipboard-indicator = callPackage ../desktops/gnome-3/extensions/clipboard-indicator { };
    dash-to-dock = callPackage ../desktops/gnome-3/extensions/dash-to-dock { };
    dash-to-panel = callPackage ../desktops/gnome-3/extensions/dash-to-panel { };
    draw-on-your-screen = callPackage ../desktops/gnome-3/extensions/draw-on-your-screen { };
    drop-down-terminal = callPackage ../desktops/gnome-3/extensions/drop-down-terminal { };
    gsconnect = callPackage ../desktops/gnome-3/extensions/gsconnect { };
    icon-hider = callPackage ../desktops/gnome-3/extensions/icon-hider { };
    impatience = callPackage ../desktops/gnome-3/extensions/impatience { };
    mpris-indicator-button = callPackage ../desktops/gnome-3/extensions/mpris-indicator-button { };
    night-theme-switcher = callPackage ../desktops/gnome-3/extensions/night-theme-switcher { };
    no-title-bar = callPackage ../desktops/gnome-3/extensions/no-title-bar { };
    paperwm = callPackage ../desktops/gnome-3/extensions/paperwm { };
    pidgin-im-integration = callPackage ../desktops/gnome-3/extensions/pidgin-im-integration { };
    remove-dropdown-arrows = callPackage ../desktops/gnome-3/extensions/remove-dropdown-arrows { };
    sound-output-device-chooser = callPackage ../desktops/gnome-3/extensions/sound-output-device-chooser { };
    system-monitor = callPackage ../desktops/gnome-3/extensions/system-monitor { };
    taskwhisperer = callPackage ../desktops/gnome-3/extensions/taskwhisperer { };
    tilingnome = callPackage ../desktops/gnome-3/extensions/tilingnome { };
    timepp = callPackage ../desktops/gnome-3/extensions/timepp { };
    topicons-plus = callPackage ../desktops/gnome-3/extensions/topicons-plus { };
    window-corner-preview = callPackage ../desktops/gnome-3/extensions/window-corner-preview { };
    workspace-matrix = callPackage ../desktops/gnome-3/extensions/workspace-matrix { };

    nohotcorner = throw "gnomeExtensions.nohotcorner removed since 2019-10-09: Since 3.34, it is a part of GNOME Shell configurable through GNOME Tweaks.";
    mediaplayer = throw "gnomeExtensions.mediaplayer deprecated since 2019-09-23: retired upstream https://github.com/JasonLG1979/gnome-shell-extensions-mediaplayer/blob/master/README.md";
  };

  gnome-tour = callPackage ../desktops/gnome-3/core/gnome-tour { };

  hsetroot = callPackage ../tools/X11/hsetroot { };

  imwheel = callPackage ../tools/X11/imwheel { };

  kakasi = callPackage ../tools/text/kakasi { };

  lumina = recurseIntoAttrs (callPackage ../desktops/lumina { });

  lxqt = recurseIntoAttrs (import ../desktops/lxqt {
    inherit pkgs libsForQt5;
    inherit (lib) makeScope;
  });

  mate = recurseIntoAttrs (callPackage ../desktops/mate { });

  pantheon = recurseIntoAttrs (callPackage ../desktops/pantheon { });

  maxx = callPackage ../desktops/maxx { };

  plasma-applet-volumewin7mixer = libsForQt5.callPackage ../applications/misc/plasma-applet-volumewin7mixer { };

  inherit (callPackages ../applications/misc/redshift {
    inherit (python3Packages) python pygobject3 pyxdg wrapPython;
    inherit (darwin.apple_sdk.frameworks) CoreLocation ApplicationServices Foundation Cocoa;
    geoclue = geoclue2;
  }) redshift redshift-wlr;

  redshift-plasma-applet = libsForQt5.callPackage ../applications/misc/redshift-plasma-applet { };

  latte-dock = libsForQt5.callPackage ../applications/misc/latte-dock { };

  gnome-themes-extra = gnome3.gnome-themes-extra;

  rox-filer = callPackage ../desktops/rox/rox-filer {
    gtk = gtk2;
  };

  xfce = recurseIntoAttrs (callPackage ../desktops/xfce { });

  xrandr-invert-colors = callPackage ../applications/misc/xrandr-invert-colors { };

  ### DESKTOP ENVIRONMENTS / PLASMA 5

  plasma5 =
    let
      mkPlasma5 = import ../desktops/plasma-5;
      attrs = {
        inherit libsForQt5 lib fetchurl;
        gconf = gnome2.GConf;
        inherit gsettings-desktop-schemas;
      };
    in
      recurseIntoAttrs (makeOverridable mkPlasma5 attrs);

  inherit (kdeFrameworks) kded kinit frameworkintegration;

  inherit (plasma5)
    bluedevil breeze-gtk breeze-qt5 breeze-grub breeze-plymouth discover
    kactivitymanagerd kde-cli-tools kde-gtk-config kdeplasma-addons kgamma5
    kinfocenter kmenuedit kscreen kscreenlocker ksshaskpass ksysguard
    kwallet-pam kwayland-integration kwin kwrited milou oxygen plasma-browser-integration
    plasma-desktop plasma-integration plasma-nm plasma-pa plasma-vault plasma-workspace
    plasma-workspace-wallpapers polkit-kde-agent powerdevil sddm-kcm
    systemsettings user-manager xdg-desktop-portal-kde;

  kwin-tiling = libsForQt5.callPackage ../desktops/plasma-5/kwin/scripts/tiling.nix { };

  krohnkite = libsForQt5.callPackage ../desktops/plasma-5/kwin/scripts/krohnkite.nix { };

  ### SCIENCE

  ### SCIENCE/CHEMISTY

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

  gwyddion = callPackage ../applications/science/chemistry/gwyddion {};

  jmol = callPackage ../applications/science/chemistry/jmol { };

  marvin = callPackage ../applications/science/chemistry/marvin { };

  molden = callPackage ../applications/science/chemistry/molden { };

  octopus = callPackage ../applications/science/chemistry/octopus { openblas=openblasCompat; };

  openmolcas = callPackage ../applications/science/chemistry/openmolcas { };

  pymol = callPackage ../applications/science/chemistry/pymol { };

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

  alliance = callPackage ../applications/science/electronics/alliance { };

  ants = callPackage ../applications/science/biology/ants {
    stdenv = gcc8Stdenv;
  };

  aragorn = callPackage ../applications/science/biology/aragorn { };

  archimedes = callPackage ../applications/science/electronics/archimedes {
    stdenv = gcc6Stdenv;
  };

  bayescan = callPackage ../applications/science/biology/bayescan { };

  bedtools = callPackage ../applications/science/biology/bedtools { };

  bcftools = callPackage ../applications/science/biology/bcftools { };

  bftools = callPackage ../applications/science/biology/bftools { };

  blast = callPackage ../applications/science/biology/blast {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  cd-hit = callPackage ../applications/science/biology/cd-hit { };

  cmtk = callPackage ../applications/science/biology/cmtk { };

  clustal-omega = callPackage ../applications/science/biology/clustal-omega { };

  conglomerate = callPackage ../applications/science/biology/conglomerate { };

  dcm2niix = callPackage ../applications/science/biology/dcm2niix { };

  deeptools = callPackage ../applications/science/biology/deeptools { python = python3; };

  delly = callPackage ../applications/science/biology/delly { };

  diamond = callPackage ../applications/science/biology/diamond { };

  ecopcr = callPackage ../applications/science/biology/ecopcr { };

  eggnog-mapper = callPackage ../applications/science/biology/eggnog-mapper { };

  emboss = callPackage ../applications/science/biology/emboss { };

  est-sfs = callPackage ../applications/science/biology/est-sfs { };

  ezminc = callPackage ../applications/science/biology/EZminc { };

  exonerate = callPackage ../applications/science/biology/exonerate { };

  hisat2 = callPackage ../applications/science/biology/hisat2 { };

  htslib = callPackage ../development/libraries/science/biology/htslib { };

  igv = callPackage ../applications/science/biology/igv { };

  inormalize = callPackage ../applications/science/biology/inormalize { };

  itsx = callPackage ../applications/science/biology/itsx { };

  iv = callPackage ../applications/science/biology/iv {
    neuron-version = neuron.version;
  };

  kallisto = callPackage ../applications/science/biology/kallisto { };

  kssd = callPackage ../applications/science/biology/kssd { };

  last = callPackage ../applications/science/biology/last { };

  macse = callPackage ../applications/science/biology/macse { };

  migrate = callPackage ../applications/science/biology/migrate { };

  minia = callPackage ../applications/science/biology/minia {
    boost = boost159;
  };

  mirtk = callPackage ../development/libraries/science/biology/mirtk { };

  muscle = callPackage ../applications/science/biology/muscle { };

  n3 = callPackage ../applications/science/biology/N3 { };

  neuron = callPackage ../applications/science/biology/neuron {
    python = null;
  };

  neuron-mpi = appendToName "mpi" (neuron.override {
    mpi = pkgs.openmpi;
  });

  neuron-full = neuron-mpi.override { inherit python; };

  mrbayes = callPackage ../applications/science/biology/mrbayes { };

  mrtrix = callPackage ../applications/science/biology/mrtrix { python = python3; };

  megahit = callPackage ../applications/science/biology/megahit { };

  messer-slim = callPackage ../applications/science/biology/messer-slim { };

  minc_tools = callPackage ../applications/science/biology/minc-tools {
    inherit (perlPackages) perl TextFormat;
  };

  minc_widgets = callPackage ../applications/science/biology/minc-widgets { };

  mni_autoreg = callPackage ../applications/science/biology/mni_autoreg { };

  minimap2 = callPackage ../applications/science/biology/minimap2 { };

  mosdepth = callPackage ../applications/science/biology/mosdepth { };

  ncbi_tools = callPackage ../applications/science/biology/ncbi-tools { };

  niftyreg = callPackage ../applications/science/biology/niftyreg { };

  niftyseg = callPackage ../applications/science/biology/niftyseg { };

  manta = callPackage ../applications/science/biology/manta { };

  octopus-caller = callPackage ../applications/science/biology/octopus { };

  paml = callPackage ../applications/science/biology/paml { };

  picard-tools = callPackage ../applications/science/biology/picard-tools { };

  platypus = callPackage ../applications/science/biology/platypus { };

  plink = callPackage ../applications/science/biology/plink { };

  plink-ng = callPackage ../applications/science/biology/plink-ng { };

  prodigal = callPackage ../applications/science/biology/prodigal { };

  raxml = callPackage ../applications/science/biology/raxml { };

  raxml-mpi = appendToName "mpi" (raxml.override {
    mpi = true;
  });

  samtools = callPackage ../applications/science/biology/samtools { };
  samtools_0_1_19 = callPackage ../applications/science/biology/samtools/samtools_0_1_19.nix {
    stdenv = gccStdenv;
  };

  snpeff = callPackage ../applications/science/biology/snpeff { };

  somatic-sniper = callPackage ../applications/science/biology/somatic-sniper { };

  sortmerna = callPackage ../applications/science/biology/sortmerna { };

  stacks = callPackage ../applications/science/biology/stacks { };

  star = callPackage ../applications/science/biology/star { };

  strelka = callPackage ../applications/science/biology/strelka { };

  inherit (callPackages ../applications/science/biology/sumatools {})
      sumalibs
      sumaclust
      sumatra;

  seaview = callPackage ../applications/science/biology/seaview { };

  SPAdes = callPackage ../applications/science/biology/spades { };

  svaba = callPackage ../applications/science/biology/svaba { };

  tebreak = callPackage ../applications/science/biology/tebreak { };

  trimal = callPackage ../applications/science/biology/trimal { };

  truvari = callPackage ../applications/science/biology/truvari { };

  varscan = callPackage ../applications/science/biology/varscan { };

  hmmer = callPackage ../applications/science/biology/hmmer { };

  bwa = callPackage ../applications/science/biology/bwa { };

  ### SCIENCE/MACHINE LEARNING

  sc2-headless = callPackage ../applications/science/machine-learning/sc2-headless { };

  ### SCIENCE/MATH

  almonds = callPackage ../applications/science/math/almonds { };

  arpack = callPackage ../development/libraries/science/math/arpack { };

  blas = callPackage ../development/libraries/science/math/blas { };

  brial = callPackage ../development/libraries/science/math/brial { };

  clblas = callPackage ../development/libraries/science/math/clblas {
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo OpenCL;
  };

  cliquer = callPackage ../development/libraries/science/math/cliquer { };

  ecos = callPackage ../development/libraries/science/math/ecos { };

  flintqs = callPackage ../development/libraries/science/math/flintqs { };

  getdp = callPackage ../applications/science/math/getdp { };

  gurobi = callPackage ../applications/science/math/gurobi { };

  jags = callPackage ../applications/science/math/jags { };

  libbraiding = callPackage ../development/libraries/science/math/libbraiding { };

  libhomfly = callPackage ../development/libraries/science/math/libhomfly { };

  liblapack = callPackage ../development/libraries/science/math/liblapack {};

  liblbfgs = callPackage ../development/libraries/science/math/liblbfgs { };

  lrs = callPackage ../development/libraries/science/math/lrs { };

  m4ri = callPackage ../development/libraries/science/math/m4ri { };

  m4rie = callPackage ../development/libraries/science/math/m4rie { };

  mkl = callPackage ../development/libraries/science/math/mkl { };

  nasc = callPackage ../applications/science/math/nasc { };

  nota = haskellPackages.callPackage ../applications/science/math/nota { };

  openblas = callPackage ../development/libraries/science/math/openblas { };

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  openlibm = callPackage ../development/libraries/science/math/openlibm {};

  openspecfun = callPackage ../development/libraries/science/math/openspecfun {};

  planarity = callPackage ../development/libraries/science/math/planarity { };

  scalapack = callPackage ../development/libraries/science/math/scalapack {
    mpi = openmpi;
  };

  rankwidth = callPackage ../development/libraries/science/math/rankwidth { };

  lcalc = callPackage ../development/libraries/science/math/lcalc { };

  lrcalc = callPackage ../applications/science/math/lrcalc { };

  lie = callPackage ../applications/science/math/LiE { };

  magma = callPackage ../development/libraries/science/math/magma { };
  clmagma = callPackage ../development/libraries/science/math/clmagma { };

  mathematica = callPackage ../applications/science/math/mathematica { };
  mathematica9 = callPackage ../applications/science/math/mathematica/9.nix { };
  mathematica10 = callPackage ../applications/science/math/mathematica/10.nix { };
  mathematica11 = callPackage ../applications/science/math/mathematica/11.nix { };

  metis = callPackage ../development/libraries/science/math/metis {};

  nauty = callPackage ../applications/science/math/nauty {};

  osi = callPackage ../development/libraries/science/math/osi { };

  or-tools = callPackage ../development/libraries/science/math/or-tools { };

  rubiks = callPackage ../development/libraries/science/math/rubiks { };

  petsc = callPackage ../development/libraries/science/math/petsc { };

  parmetis = callPackage ../development/libraries/science/math/parmetis {
    mpi = openmpi;
  };

  QuadProgpp = callPackage ../development/libraries/science/math/QuadProgpp { };

  scs = callPackage ../development/libraries/science/math/scs { };

  sage = callPackage ../applications/science/math/sage { };
  sageWithDoc = sage.override { withDoc = true; };

  suitesparse_4_2 = callPackage ../development/libraries/science/math/suitesparse/4.2.nix { };
  suitesparse_4_4 = callPackage ../development/libraries/science/math/suitesparse/4.4.nix {};
  suitesparse_5_3 = callPackage ../development/libraries/science/math/suitesparse {};
  suitesparse = suitesparse_5_3;

  suitesparse-graphblas = callPackage ../development/libraries/science/math/suitesparse-graphblas {};

  superlu = callPackage ../development/libraries/science/math/superlu {};

  symmetrica = callPackage ../applications/science/math/symmetrica {};

  sympow = callPackage ../development/libraries/science/math/sympow { };

  ipopt = callPackage ../development/libraries/science/math/ipopt { openblas = openblasCompat; };

  gmsh = callPackage ../applications/science/math/gmsh { };

  zn_poly = callPackage ../development/libraries/science/math/zn_poly { };

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

  dcmtk = callPackage ../applications/science/medicine/dcmtk { };

  ### PHYSICS

  sacrifice = callPackage ../applications/science/physics/sacrifice {};

  sherpa = callPackage ../applications/science/physics/sherpa {};

  xfitter = callPackage ../applications/science/physics/xfitter {};

  ### SCIENCE/PROGRAMMING

  dafny = dotnetPackages.Dafny;

  groove = callPackage ../applications/science/programming/groove { };

  plm = callPackage ../applications/science/programming/plm { };

  scyther = callPackage ../applications/science/programming/scyther { };

  ### SCIENCE/LOGIC

  abc-verifier = callPackage ../applications/science/logic/abc {};

  abella = callPackage ../applications/science/logic/abella {
    ocamlPackages = ocaml-ng.ocamlPackages_4_07;
  };

  acgtk = callPackage ../applications/science/logic/acgtk {};

  alt-ergo = callPackage ../applications/science/logic/alt-ergo {};

  aspino = callPackage ../applications/science/logic/aspino {};

  beluga = callPackage ../applications/science/logic/beluga {
    ocamlPackages = ocaml-ng.ocamlPackages_4_07;
  };

  boogie = dotnetPackages.Boogie;

  inherit (callPackage ./coq-packages.nix {
    inherit (ocaml-ng) ocamlPackages_4_05;
  }) mkCoqPackages
    coqPackages_8_5  coq_8_5
    coqPackages_8_6  coq_8_6
    coqPackages_8_7  coq_8_7
    coqPackages_8_8  coq_8_8
    coqPackages_8_9  coq_8_9
    coqPackages_8_10 coq_8_10
    coqPackages_8_11 coq_8_11
    coqPackages      coq
  ;

  coq2html = callPackage ../applications/science/logic/coq2html { };

  cryptoverif = callPackage ../applications/science/logic/cryptoverif { };

  caprice32 = callPackage ../misc/emulators/caprice32 { };

  cubicle = callPackage ../applications/science/logic/cubicle {
    ocamlPackages = ocaml-ng.ocamlPackages_4_05;
  };

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (a: { dontDisableStatic = true; });
  };
  cvc4 = callPackage ../applications/science/logic/cvc4 {};

  drat-trim = callPackage ../applications/science/logic/drat-trim {};

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {
    inherit (ocaml-ng.ocamlPackages_4_02) ocaml;
  };

  eprover = callPackage ../applications/science/logic/eprover { };

  gappa = callPackage ../applications/science/logic/gappa { };

  gfan = callPackage ../applications/science/math/gfan {};

  giac = callPackage ../applications/science/math/giac { };
  giac-with-xcas = giac.override { enableGUI = true; };

  ginac = callPackage ../applications/science/math/ginac { };

  glom = callPackage ../applications/misc/glom { };

  glucose = callPackage ../applications/science/logic/glucose { };
  glucose-syrup = callPackage ../applications/science/logic/glucose/syrup.nix { };

  hol = callPackage ../applications/science/logic/hol { };

  inherit (ocamlPackages) hol_light;

  hologram = callPackage ../tools/security/hologram { };

  tini = callPackage ../applications/virtualization/tini {};

  ifstat-legacy = callPackage ../tools/networking/ifstat-legacy { };

  isabelle = callPackage ../applications/science/logic/isabelle {
    polyml = stdenv.lib.overrideDerivation polyml57 (attrs: {
      configureFlags = [ "--enable-intinf-as-int" "--with-gmp" "--disable-shared" ];
    });

    java = if stdenv.isLinux then jre else jdk;
  };

  iprover = callPackage ../applications/science/logic/iprover { };

  jonprl = callPackage ../applications/science/logic/jonprl {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  lean = callPackage ../applications/science/logic/lean {};
  lean2 = callPackage ../applications/science/logic/lean2 {};
  lean3 = lean;
  elan = callPackage ../applications/science/logic/elan {};

  leo2 = callPackage ../applications/science/logic/leo2 {
     ocaml = ocaml-ng.ocamlPackages_4_01_0.ocaml;};

  leo3-bin = callPackage ../applications/science/logic/leo3/binary.nix {};

  logisim = callPackage ../applications/science/logic/logisim {};

  ltl2ba = callPackage ../applications/science/logic/ltl2ba {};

  metis-prover = callPackage ../applications/science/logic/metis-prover { };

  mcrl2 = callPackage ../applications/science/logic/mcrl2 { };

  minisat = callPackage ../applications/science/logic/minisat {};

  monosat = callPackage ../applications/science/logic/monosat {};

  opensmt = callPackage ../applications/science/logic/opensmt { };

  ott = callPackage ../applications/science/logic/ott { };

  otter = callPackage ../applications/science/logic/otter {};

  picosat = callPackage ../applications/science/logic/picosat {};

  libpoly = callPackage ../applications/science/logic/poly {};

  prooftree = callPackage  ../applications/science/logic/prooftree {};

  prover9 = callPackage ../applications/science/logic/prover9 { };

  proverif = callPackage ../applications/science/logic/proverif { };

  satallax = callPackage ../applications/science/logic/satallax {
    ocaml = ocaml-ng.ocamlPackages_4_01_0.ocaml;
  };

  saw-tools = callPackage ../applications/science/logic/saw-tools {};

  spass = callPackage ../applications/science/logic/spass {
    stdenv = gccStdenv;
  };

  statverif = callPackage ../applications/science/logic/statverif {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };

  tptp = callPackage ../applications/science/logic/tptp {};

  celf = callPackage ../applications/science/logic/celf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  fast-downward = callPackage ../applications/science/logic/fast-downward { };

  twelf = callPackage ../applications/science/logic/twelf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  verifast = callPackage ../applications/science/logic/verifast {};

  veriT = callPackage ../applications/science/logic/verit {};

  why3 = callPackage ../applications/science/logic/why3 { };

  workcraft = callPackage ../applications/science/logic/workcraft {};

  yices = callPackage ../applications/science/logic/yices {
    gmp-static = gmp.override { withStatic = true; };
  };

  z3 = callPackage ../applications/science/logic/z3 { python = python2; };
  z3-tptp = callPackage ../applications/science/logic/z3/tptp.nix {};

  tlaplus = callPackage ../applications/science/logic/tlaplus {};
  tlaps = callPackage ../applications/science/logic/tlaplus/tlaps.nix {
    inherit (ocaml-ng.ocamlPackages_4_05) ocaml;
  };
  tlaplusToolbox = callPackage ../applications/science/logic/tlaplus/toolbox.nix {gtk = gtk2;};

  aiger = callPackage ../applications/science/logic/aiger {};

  avy = callPackage ../applications/science/logic/avy {};

  btor2tools = callPackage ../applications/science/logic/btor2tools {};

  boolector = callPackage ../applications/science/logic/boolector {};

  symbiyosys = callPackage ../applications/science/logic/symbiyosys {};

  mcy = callPackage ../applications/science/logic/mcy {};

  lingeling = callPackage ../applications/science/logic/lingeling {};

  ### SCIENCE / ELECTRONICS

  adms = callPackage ../applications/science/electronics/adms { };

  # Since version 8 Eagle requires an Autodesk account and a subscription
  # in contrast to single payment for the charged editions.
  # This is the last version with the old model.
  eagle7 = callPackage ../applications/science/electronics/eagle/eagle7.nix {
    openssl = openssl_1_0_2;
  };

  eagle = libsForQt5.callPackage ../applications/science/electronics/eagle/eagle.nix { };

  caneda = libsForQt5.callPackage ../applications/science/electronics/caneda { };

  geda = callPackage ../applications/science/electronics/geda {
    guile = guile_2_0;
  };

  gerbv = callPackage ../applications/science/electronics/gerbv { };

  gtkwave = callPackage ../applications/science/electronics/gtkwave { };

  fped = callPackage ../applications/science/electronics/fped { };

  kicad = callPackage ../applications/science/electronics/kicad { };
  kicad-small = kicad.override { pname = "kicad-small"; with3d = false; };
  kicad-unstable = kicad.override { pname = "kicad-unstable"; debug = true; };

  librepcb = libsForQt5.callPackage ../applications/science/electronics/librepcb { };

  ngspice = callPackage ../applications/science/electronics/ngspice { };

  pcb = callPackage ../applications/science/electronics/pcb { };

  qucs = callPackage ../applications/science/electronics/qucs { };

  xcircuit = callPackage ../applications/science/electronics/xcircuit { };

  xoscope = callPackage ../applications/science/electronics/xoscope { };


  ### SCIENCE / MATH

  caffe = callPackage ../applications/science/math/caffe ({
    opencv3 = opencv3WithoutCuda; # Used only for image loading.
    inherit (darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
  } // (config.caffe or {}));

  caffe2 = callPackage ../development/libraries/science/math/caffe2 (rec {
    inherit (python36Packages) python future six numpy pydot;
    protobuf = protobuf3_1;
    python-protobuf = python36Packages.protobuf.override { inherit protobuf; };
    opencv3 = opencv3WithoutCuda; # Used only for image loading.
  });

  caffeine-ng = callPackage ../tools/X11/caffeine-ng {};

  cntk = callPackage ../applications/science/math/cntk {
    stdenv = gcc7Stdenv;
    inherit (linuxPackages) nvidia_x11;
    opencv3 = opencv3WithoutCuda; # Used only for image loading.
    cudaSupport = pkgs.config.cudaSupport or false;
  };

  ecm = callPackage ../applications/science/math/ecm { };

  eukleides = callPackage ../applications/science/math/eukleides {
    texLive = texlive.combine { inherit (texlive) scheme-small; };
    texinfo = texinfo4;
  };

  form = callPackage ../applications/science/math/form { };

  fricas = callPackage ../applications/science/math/fricas { };

  gap = callPackage ../applications/science/math/gap { };

  gap-minimal = lowPrio (gap.override { packageSet = "minimal"; });

  gap-full = lowPrio (gap.override { packageSet = "full"; });

  geogebra = callPackage ../applications/science/math/geogebra { };

  maxima = callPackage ../applications/science/math/maxima {
    ecl = null;
  };
  maxima-ecl = maxima.override {
    ecl = ecl_16_1_2;
    ecl-fasl = true;
    sbcl = null;
  };

  mxnet = callPackage ../applications/science/math/mxnet {
    inherit (linuxPackages) nvidia_x11;
  };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { wxGTK = wxGTK30; };

  pari = callPackage ../applications/science/math/pari { tex = texlive.combined.scheme-basic; };
  gp2c = callPackage ../applications/science/math/pari/gp2c.nix { };

  palp = callPackage ../applications/science/math/palp { };

  ratpoints = callPackage ../applications/science/math/ratpoints {};

  calc = callPackage ../applications/science/math/calc { };

  pcalc = callPackage ../applications/science/math/pcalc { };

  bcal = callPackage ../applications/science/math/bcal { };

  pspp = callPackage ../applications/science/math/pspp { };

  ssw = callPackage ../applications/misc/ssw { };

  pynac = callPackage ../applications/science/math/pynac { };

  singular = callPackage ../applications/science/math/singular { };

  scilab = callPackage ../applications/science/math/scilab { };

  scilab-bin = callPackage ../applications/science/math/scilab-bin {};

  scotch = callPackage ../applications/science/math/scotch { };

  mininet = callPackage ../tools/virtualization/mininet { };

  msieve = callPackage ../applications/science/math/msieve { };

  weka = callPackage ../applications/science/math/weka { };

  yad = callPackage ../tools/misc/yad { };

  yacas = callPackage ../applications/science/math/yacas { };

  speedcrunch = libsForQt5.callPackage ../applications/science/math/speedcrunch { };

  ### SCIENCE / MISC

  boinc = callPackage ../applications/science/misc/boinc { };

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (pkgs.gnome2) gtkglext;
  };

  cytoscape = callPackage ../applications/science/misc/cytoscape { };

  fityk = callPackage ../applications/science/misc/fityk { };

  galario = callPackage ../development/libraries/galario { };

  gildas = callPackage ../applications/science/astronomy/gildas { };

  gplates = callPackage ../applications/science/misc/gplates {
    boost = boost160;
    cgal = cgal.override { boost = boost160; };
  };

  gravit = callPackage ../applications/science/astronomy/gravit { };

  golly = callPackage ../applications/science/misc/golly { wxGTK = wxGTK30; };
  golly-beta = callPackage ../applications/science/misc/golly/beta.nix { wxGTK = wxGTK30; };

  megam = callPackage ../applications/science/misc/megam {
    inherit (ocaml-ng.ocamlPackages_4_07) ocaml;
  };

  netlogo = callPackage ../applications/science/misc/netlogo { };

  ns-3 = callPackage ../development/libraries/science/networking/ns-3 { python = python3; };

  root = callPackage ../applications/science/misc/root {
    python = python3;
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  root5 = lowPrio (callPackage ../applications/science/misc/root/5.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
    stdenv = if stdenv.cc.isClang then llvmPackages_5.stdenv else gcc8Stdenv;
  });

  rink = callPackage ../applications/science/misc/rink { };

  simgrid = callPackage ../applications/science/misc/simgrid { };

  spyder = with python3.pkgs; toPythonApplication spyder;

  openspace = callPackage ../applications/science/astronomy/openspace { };

  stellarium = libsForQt5.callPackage ../applications/science/astronomy/stellarium { };

  astrolabe-generator = callPackage ../applications/science/astronomy/astrolabe-generator { };

  tulip = callPackage ../applications/science/misc/tulip {
    cmake = cmake_2_8;
  };

  vite = callPackage ../applications/science/misc/vite { };

  xearth = callPackage ../applications/science/astronomy/xearth { };
  xplanet = callPackage ../applications/science/astronomy/xplanet { };

  ### SCIENCE / PHYSICS

  apfelgrid = callPackage ../development/libraries/physics/apfelgrid { };

  apfel = callPackage ../development/libraries/physics/apfel { };

  applgrid = callPackage ../development/libraries/physics/applgrid { };

  hoppet = callPackage ../development/libraries/physics/hoppet { };

  fastjet = callPackage ../development/libraries/physics/fastjet { };

  fastjet-contrib = callPackage ../development/libraries/physics/fastjet-contrib { };

  fastnlo = callPackage ../development/libraries/physics/fastnlo { };

  geant4 = libsForQt5.callPackage ../development/libraries/physics/geant4 { };

  cernlib = callPackage ../development/libraries/physics/cernlib { };

  g4py = callPackage ../development/libraries/physics/geant4/g4py { };

  hepmc2 = callPackage ../development/libraries/physics/hepmc2 { };

  hepmc3 = callPackage ../development/libraries/physics/hepmc3 {
    python = null;
  };

  herwig = callPackage ../development/libraries/physics/herwig { };

  lhapdf = callPackage ../development/libraries/physics/lhapdf { };

  mcgrid = callPackage ../development/libraries/physics/mcgrid { };

  mela = callPackage ../development/libraries/physics/mela { };

  nlojet = callPackage ../development/libraries/physics/nlojet { };

  pythia = callPackage ../development/libraries/physics/pythia { };

  rivet = callPackage ../development/libraries/physics/rivet {
    imagemagick = graphicsmagick-imagemagick-compat;
  };

  thepeg = callPackage ../development/libraries/physics/thepeg { };

  yoda = callPackage ../development/libraries/physics/yoda {
    python = python2;
  };
  yoda-with-root = lowPrio (yoda.override {
    withRootSupport = true;
  });

  qcdnum = callPackage ../development/libraries/physics/qcdnum { };

  ### SCIENCE/ROBOTICS

  apmplanner2 = libsForQt5.callPackage ../applications/science/robotics/apmplanner2 { };

  betaflight-configurator = callPackage ../applications/science/robotics/betaflight-configurator { };

  ### MISC

  acpilight = callPackage ../misc/acpilight { };

  android-file-transfer = libsForQt5.callPackage ../tools/filesystems/android-file-transfer { };

  antimicro = libsForQt5.callPackage ../tools/misc/antimicro { };

  atari800 = callPackage ../misc/emulators/atari800 { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  atlantis = callPackage ../applications/networking/cluster/atlantis { };

  auctex = callPackage ../tools/typesetting/tex/auctex { };

  areca = callPackage ../applications/backup/areca { };

  attract-mode = callPackage ../misc/emulators/attract-mode { };

  beep = callPackage ../misc/beep { };

  bees = callPackage ../tools/filesystems/bees { };

  bootil = callPackage ../development/libraries/bootil { };

  brgenml1lpr = pkgsi686Linux.callPackage ../misc/cups/drivers/brgenml1lpr {};

  brgenml1cupswrapper = callPackage ../misc/cups/drivers/brgenml1cupswrapper {};

  brightnessctl = callPackage ../misc/brightnessctl { };

  calaos_installer = libsForQt5.callPackage ../misc/calaos/installer {};

  ccemux = callPackage ../misc/emulators/ccemux { };

  click = callPackage ../applications/networking/cluster/click { };

  clinfo = callPackage ../tools/system/clinfo { };

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

  colort = callPackage ../applications/misc/colort { };

  terminal-parrot = callPackage ../applications/misc/terminal-parrot { };

  epson-alc1100 = callPackage ../misc/drivers/epson-alc1100 { };

  epson-escpr = callPackage ../misc/drivers/epson-escpr { };
  epson-escpr2 = callPackage ../misc/drivers/epson-escpr2 { };

  epson_201207w = callPackage ../misc/drivers/epson_201207w { };

  epson-201106w = callPackage ../misc/drivers/epson-201106w { };

  epson-workforce-635-nx625-series = callPackage ../misc/drivers/epson-workforce-635-nx625-series { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cups-bjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

  cups-brother-hl1110 = pkgsi686Linux.callPackage ../misc/cups/drivers/hl1110 { };

  cups-brother-hl3140cw = pkgsi686Linux.callPackage ../misc/cups/drivers/hl3140cw { };

  cups-brother-hll2340dw = pkgsi686Linux.callPackage  ../misc/cups/drivers/hll2340dw { };

  cups-googlecloudprint = callPackage ../misc/cups/drivers/googlecloudprint { };

  # this driver ships with pre-compiled 32-bit binary libraries
  cnijfilter_2_80 = pkgsi686Linux.callPackage ../misc/cups/drivers/cnijfilter_2_80 { };

  cnijfilter_4_00 = callPackage ../misc/cups/drivers/cnijfilter_4_00 {
    libusb = libusb1;
  };

  cnijfilter2 = callPackage ../misc/cups/drivers/cnijfilter2 {
    libusb = libusb1;
  };

  darcnes = callPackage ../misc/emulators/darcnes { };

  darling-dmg = callPackage ../tools/filesystems/darling-dmg { };

  desmume = callPackage ../misc/emulators/desmume { inherit (pkgs.gnome2) gtkglext libglade; };

  dbacl = callPackage ../tools/misc/dbacl { };

  dblatex = callPackage ../tools/typesetting/tex/dblatex {
    enableAllFeatures = false;
  };

  dblatexFull = appendToName "full" (dblatex.override {
    enableAllFeatures = true;
  });

  dbus-map = callPackage ../tools/misc/dbus-map { };

  dell-530cdn = callPackage ../misc/drivers/dell-530cdn {};

  dosbox = callPackage ../misc/emulators/dosbox { };

  dpkg = callPackage ../tools/package-management/dpkg { };

  dumb = callPackage ../misc/dumb { };

  ecdsatool = callPackage ../tools/security/ecdsatool { };

  emulationstation = callPackage ../misc/emulators/emulationstation { };

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  flam3 = callPackage ../tools/graphics/flam3 { };

  glee = callPackage ../tools/graphics/glee { };

  fakenes = callPackage ../misc/emulators/fakenes { };

  faust = res.faust2;

  faust1 = callPackage ../applications/audio/faust/faust1.nix { };

  faust2 = callPackage ../applications/audio/faust/faust2.nix {
    llvm = llvm_9;
  };

  faust2alqt = callPackage ../applications/audio/faust/faust2alqt.nix { };

  faust2alsa = callPackage ../applications/audio/faust/faust2alsa.nix { };

  faust2csound = callPackage ../applications/audio/faust/faust2csound.nix { };

  faust2firefox = callPackage ../applications/audio/faust/faust2firefox.nix { };

  faust2jack = callPackage ../applications/audio/faust/faust2jack.nix { };

  faust2jackrust = callPackage ../applications/audio/faust/faust2jackrust.nix { };

  faust2jaqt = callPackage ../applications/audio/faust/faust2jaqt.nix { };

  faust2ladspa = callPackage ../applications/audio/faust/faust2ladspa.nix { };

  faust2lv2 = callPackage ../applications/audio/faust/faust2lv2.nix { };

  faustlive = callPackage ../applications/audio/faust/faustlive.nix { };

  fceux = callPackage ../misc/emulators/fceux { };

  flockit = callPackage ../tools/backup/flockit { };

  fahclient = callPackage ../applications/science/misc/foldingathome/client.nix {};
  fahcontrol = callPackage ../applications/science/misc/foldingathome/control.nix {};
  fahviewer = callPackage ../applications/science/misc/foldingathome/viewer.nix {};

  foo2zjs = callPackage ../misc/drivers/foo2zjs {};

  foomatic-filters = callPackage ../misc/drivers/foomatic-filters {};

  fuse-emulator = callPackage ../misc/emulators/fuse-emulator {};

  gajim = callPackage ../applications/networking/instant-messengers/gajim {
    inherit (gst_all_1) gstreamer gst-plugins-base gst-libav gst-plugins-ugly;
  };

  gammu = callPackage ../applications/misc/gammu { };

  gensgs = pkgsi686Linux.callPackage ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript { };

  ghostscriptX = appendToName "with-X" (ghostscript.override {
    cupsSupport = true;
    x11Support = true;
  });

  glava = callPackage ../applications/misc/glava {};

  gnuk = callPackage ../misc/gnuk {
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    binutils-arm-embedded = pkgsCross.arm-embedded.buildPackages.binutils;
  };

  gobuster = callPackage ../tools/security/gobuster { };

  guetzli = callPackage ../applications/graphics/guetzli { };

  gummi = callPackage ../applications/misc/gummi { };

  gxemul = callPackage ../misc/emulators/gxemul { };

  hatari = callPackage ../misc/emulators/hatari { };

  helm = callPackage ../applications/audio/helm {
    stdenv = gcc8Stdenv;
  };

  helmfile = callPackage ../applications/networking/cluster/helmfile { };

  heptio-ark = callPackage ../applications/networking/cluster/heptio-ark { };

  hplip = callPackage ../misc/drivers/hplip { };

  hplipWithPlugin = hplip.override { withPlugin = true; };

  hplip_3_16_11 = callPackage ../misc/drivers/hplip/3.16.11.nix { };

  hplipWithPlugin_3_16_11 = hplip_3_16_11.override { withPlugin = true; };

  hplip_3_18_5 = callPackage ../misc/drivers/hplip/3.18.5.nix { };

  hplipWithPlugin_3_18_5 = hplip_3_18_5.override { withPlugin = true; };

  hyperfine = callPackage ../tools/misc/hyperfine {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  websocat = callPackage ../tools/misc/websocat {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  vector = callPackage ../tools/misc/vector {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  epkowa = callPackage ../misc/drivers/epkowa { };

  utsushi = callPackage ../misc/drivers/utsushi { };

  idsk = callPackage ../tools/filesystems/idsk { };

  igraph = callPackage ../development/libraries/igraph { };

  igprof = callPackage ../development/tools/misc/igprof { };

  illum = callPackage ../tools/system/illum { };

  image_optim = callPackage ../applications/graphics/image_optim { inherit (nodePackages) svgo; };

  # using the new configuration style proposal which is unstable
  jack1 = callPackage ../misc/jackaudio/jack1.nix { };

  jack2 = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreAudio Accelerate;
    inherit (darwin) libobjc;
  };
  libjack2 = jack2.override { prefix = "lib"; };
  jack2Full = jack2; # TODO: move to aliases.nix

  keynav = callPackage ../tools/X11/keynav { };

  kompose = callPackage ../applications/networking/cluster/kompose { };

  kontemplate = callPackage ../applications/networking/cluster/kontemplate { };

  inherit (callPackage ../applications/networking/cluster/kops {})
    mkKops
    kops_1_12
    kops_1_13
    kops_1_14
    kops_1_15
    kops_1_16
    ;
  kops = kops_1_16;

  lguf-brightness = callPackage ../misc/lguf-brightness { };

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };

  lilypond-unstable = callPackage ../misc/lilypond/unstable.nix { };

  lilypond-with-fonts = callPackage ../misc/lilypond/with-fonts.nix { };

  openlilylib-fonts = callPackage ../misc/lilypond/fonts.nix { };

  loop = callPackage ../tools/misc/loop { };

  mailcore2 = callPackage ../development/libraries/mailcore2 {
    icu = icu58;
  };

  mame = libsForQt5.callPackage ../misc/emulators/mame {
    inherit (darwin.apple_sdk.frameworks) CoreAudioKit ForceFeedback;
  };

  martyr = callPackage ../development/libraries/martyr { };

  moltengamepad = callPackage ../misc/drivers/moltengamepad { };

  openzwave = callPackage ../development/libraries/openzwave { };

  mongoc = callPackage ../development/libraries/mongoc { };

  mongoose = callPackage ../development/libraries/science/math/mongoose {};

  morph = callPackage ../tools/package-management/morph { };

  mupen64plus = callPackage ../misc/emulators/mupen64plus { };

  muse = libsForQt5.callPackage ../applications/audio/muse { };

  musly = callPackage ../applications/audio/musly { };

  mynewt-newt = callPackage ../tools/package-management/mynewt-newt { };

  inherit (callPackage ../tools/package-management/nix {
      storeDir = config.nix.storeDir or "/nix/store";
      stateDir = config.nix.stateDir or "/nix/var";
      boehmgc = boehmgc.override { enableLargeConfig = true; };
      })
    nix
    nix1
    nixStable
    nixUnstable
    nixFlakes;

  nixops = callPackage ../tools/package-management/nixops { };

  nixops_1_6_1 = callPackage ../tools/package-management/nixops/nixops-v1_6_1.nix {};

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
        c = import (pkgs.path + "/nixos/lib/eval-config.nix") {
              inherit (pkgs.stdenv.hostPlatform) system;
              modules =
                [(
                  { lib, ... }: {
                    config.nixpkgs.pkgs = lib.mkDefault pkgs;
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
   * Run a NixOS VM network test using this evaluation of Nixpkgs.
   *
   * It is mostly equivalent to `import ./make-test-python.nix` from the
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
      /* The nixos/lib/testing-python.nix module, preapplied with arguments that
       * make sense for this evaluation of Nixpkgs.
       */
      nixosTesting =
        (import ../../nixos/lib/testing-python.nix {
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

  nixosOptionsDoc = attrs:
    (import ../../nixos/lib/make-options-doc/default.nix)
    ({ inherit pkgs lib; } // attrs);

  nixui = callPackage ../tools/package-management/nixui { node_webkit = nwjs_0_12; };

  nixdoc = callPackage ../tools/nix/nixdoc {};

  nix-bundle = callPackage ../tools/package-management/nix-bundle { };

  nix-delegate = haskell.lib.justStaticExecutables haskellPackages.nix-delegate;
  nix-deploy = haskell.lib.justStaticExecutables haskellPackages.nix-deploy;
  nix-diff = haskell.lib.justStaticExecutables haskellPackages.nix-diff;

  nix-du = callPackage ../tools/package-management/nix-du { };

  nix-info = callPackage ../tools/nix/info { };
  nix-info-tested = nix-info.override { doCheck = true; };

  nix-index = callPackage ../tools/package-management/nix-index {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  nix-linter = haskellPackages.callPackage ../development/tools/analysis/nix-linter { };

  nix-pin = callPackage ../tools/package-management/nix-pin { };

  nix-prefetch = callPackage ../tools/package-management/nix-prefetch { };

  nix-prefetch-github = with python3Packages;
    toPythonApplication nix-prefetch-github;

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-scripts;

  nix-query-tree-viewer = callPackage ../tools/nix/nix-query-tree-viewer { };

  nix-update-source = callPackage ../tools/package-management/nix-update-source {};

  nix-script = callPackage ../tools/nix/nix-script {};

  nix-template-rpm = callPackage ../build-support/templaterpm { inherit (pythonPackages) python toposort; };

  nix-top = callPackage ../tools/package-management/nix-top { };

  nix-universal-prefetch = callPackage ../tools/package-management/nix-universal-prefetch { };

  nix-repl = throw (
    "nix-repl has been removed because it's not maintained anymore, " +
    (lib.optionalString (! lib.versionAtLeast "2" (lib.versions.major builtins.nixVersion))
      "ugrade your Nix installation to a newer version and ") +
    "use `nix repl` instead. " +
    "Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );

  nixpkgs-review = callPackage ../tools/package-management/nixpkgs-review { };

  nix-serve = callPackage ../tools/package-management/nix-serve { };

  nixfmt = haskell.lib.justStaticExecutables haskellPackages.nixfmt;

  nixpkgs-fmt = callPackage ../tools/nix/nixpkgs-fmt { };

  nixos-artwork = callPackage ../data/misc/nixos-artwork { };
  nixos-icons = callPackage ../data/misc/nixos-artwork/icons.nix { };
  nixos-grub2-theme = callPackage ../data/misc/nixos-artwork/grub2-theme.nix { };

  nixos-container = callPackage ../tools/virtualization/nixos-container { };

  nixos-generators = callPackage ../tools/nix/nixos-generators { };

  norwester-font = callPackage ../data/fonts/norwester  {};

  nut = callPackage ../applications/misc/nut { };

  solfege = callPackage ../misc/solfege { };

  disnix = callPackage ../tools/package-management/disnix { };

  dysnomia = callPackage ../tools/package-management/disnix/dysnomia (config.disnix or {});

  disnixos = callPackage ../tools/package-management/disnix/disnixos { };

  DisnixWebService = callPackage ../tools/package-management/disnix/DisnixWebService { };

  lkproof = callPackage ../tools/typesetting/tex/lkproof { };

  lice = callPackage ../tools/misc/lice {};

  m33-linux = callPackage ../misc/drivers/m33-linux { };

  mnemonicode = callPackage ../misc/mnemonicode { };

  mysql-workbench = callPackage ../applications/misc/mysql-workbench (let mysql = mysql57; in {
    gdal = gdal.override {libmysqlclient = mysql // {lib = {dev = mysql;};};};
    mysql = mysql;
    pcre = pcre-cpp;
  });

  r128gain = callPackage ../applications/audio/r128gain { };

  redis-desktop-manager = libsForQt5.callPackage ../applications/misc/redis-desktop-manager { };

  robin-map = callPackage ../development/libraries/robin-map { };

  robo3t = callPackage ../applications/misc/robo3t { };

  rucksack = callPackage ../development/tools/rucksack { };

  sam-ba = callPackage ../tools/misc/sam-ba { };

  sndio = callPackage ../misc/sndio { };

  oclgrind = callPackage ../development/tools/analysis/oclgrind { };

  opkg = callPackage ../tools/package-management/opkg { };

  opkg-utils = callPackage ../tools/package-management/opkg-utils { };

  pgmanage = callPackage ../applications/misc/pgmanage { };

  pgadmin = callPackage ../applications/misc/pgadmin {
    openssl = openssl_1_0_2;
  };

  pgmodeler = libsForQt5.callPackage ../applications/misc/pgmodeler { };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = callPackage ../tools/typesetting/tex/pgf/1.x.nix { };

  pgf2 = callPackage ../tools/typesetting/tex/pgf/2.x.nix { };

  pgf3 = callPackage ../tools/typesetting/tex/pgf/3.x.nix { };

  pgfplots = callPackage ../tools/typesetting/tex/pgfplots { };

  physlock = callPackage ../misc/screensavers/physlock { };

  pjsip = callPackage ../applications/networking/pjsip { };

  pounce = callPackage ../servers/pounce { };

  ppsspp = libsForQt5.callPackage ../misc/emulators/ppsspp { };

  pt = callPackage ../applications/misc/pt { };

  protocol = python3Packages.callPackage ../applications/networking/protocol { };

  pykms = callPackage ../tools/networking/pykms { };

  pyload = callPackage ../applications/networking/pyload {};

  uae = callPackage ../misc/emulators/uae { };

  fsuae = callPackage ../misc/emulators/fs-uae { };

  putty = callPackage ../applications/networking/remote/putty {
    gtk2 = gtk2-x11;
  };

  qMasterPassword = libsForQt5.callPackage ../applications/misc/qMasterPassword { };

  py-wmi-client = callPackage ../tools/networking/py-wmi-client { };

  redprl = callPackage ../applications/science/logic/redprl { };

  renderizer = pkgs.callPackage ../development/tools/renderizer {};

  retroarchBare = callPackage ../misc/emulators/retroarch {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) AppKit Foundation;
  };

  retroarch = wrapRetroArch { retroarch = retroarchBare; };

  libretro = recurseIntoAttrs (callPackage ../misc/emulators/retroarch/cores.nix {
    retroarch = retroarchBare;
  });

  retrofe = callPackage ../misc/emulators/retrofe { };

  rfc-bibtex = python3Packages.callPackage ../development/python-modules/rfc-bibtex { };

  pick-colour-picker = python3Packages.callPackage ../applications/graphics/pick-colour-picker {
    inherit (pkgs) glib gtk3 gobject-introspection wrapGAppsHook;
  };

  rpl = callPackage ../tools/text/rpl {
    pythonPackages = python3Packages;
  };

  ricty = callPackage ../data/fonts/ricty { };

  rmount = callPackage ../tools/filesystems/rmount {};

  romdirfs = callPackage ../tools/filesystems/romdirfs {};

  rss-glx = callPackage ../misc/screensavers/rss-glx { };

  run-scaled = callPackage ../tools/X11/run-scaled { };

  runit = callPackage ../tools/system/runit { };

  refind = callPackage ../tools/bootloaders/refind { };

  spectrojack = callPackage ../applications/audio/spectrojack { };

  sift = callPackage ../tools/text/sift { };

  xlockmore = callPackage ../misc/screensavers/xlockmore { };

  xtrlock-pam = callPackage ../misc/screensavers/xtrlock-pam { };

  sailsd = callPackage ../misc/sailsd { };

  shc = callPackage ../tools/security/shc { };

  canon-cups-ufr2 = callPackage ../misc/cups/drivers/canon { };

  hll2390dw-cups = callPackage ../misc/cups/drivers/hll2390dw-cups { };

  mfcj470dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj470dwcupswrapper { };
  mfcj470dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj470dwlpr { };

  mfcj6510dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj6510dwcupswrapper { };
  mfcj6510dwlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcj6510dwlpr { };

  mfcl2700dncupswrapper = callPackage ../misc/cups/drivers/mfcl2700dncupswrapper { };
  mfcl2700dnlpr = pkgsi686Linux.callPackage ../misc/cups/drivers/mfcl2700dnlpr { };

  mfcl2720dwcupswrapper = callPackage ../misc/cups/drivers/mfcl2720dwcupswrapper { };
  mfcl2720dwlpr = callPackage ../misc/cups/drivers/mfcl2720dwlpr { };

  mfcl2740dwcupswrapper = callPackage ../misc/cups/drivers/mfcl2740dwcupswrapper { };
  mfcl2740dwlpr = callPackage ../misc/cups/drivers/mfcl2740dwlpr { };

  # This driver is only available as a 32 bit proprietary binary driver
  mfcl3770cdwlpr = (callPackage ../misc/cups/drivers/brother/mfcl3770cdw/default.nix { }).driver;
  mfcl3770cdwcupswrapper = (callPackage ../misc/cups/drivers/brother/mfcl3770cdw/default.nix { }).cupswrapper;

  mfcl8690cdwcupswrapper = callPackage ../misc/cups/drivers/mfcl8690cdwcupswrapper { };
  mfcl8690cdwlpr = callPackage ../misc/cups/drivers/mfcl8690cdwlpr { };

  samsung-unified-linux-driver_1_00_36 = callPackage ../misc/cups/drivers/samsung/1.00.36/default.nix { };
  samsung-unified-linux-driver_1_00_37 = callPackage ../misc/cups/drivers/samsung/1.00.37.nix { };
  samsung-unified-linux-driver_4_00_39 = callPackage ../misc/cups/drivers/samsung/4.00.39 { };
  samsung-unified-linux-driver_4_01_17 = callPackage ../misc/cups/drivers/samsung/4.01.17.nix { };
  samsung-unified-linux-driver = res.samsung-unified-linux-driver_4_01_17;

  sane-backends = callPackage ../applications/graphics/sane/backends (config.sane or {});

  sane-backends-git = callPackage ../applications/graphics/sane/backends/git.nix (config.sane or {});

  brlaser = callPackage ../misc/cups/drivers/brlaser { };

  fxlinuxprint = callPackage ../misc/cups/drivers/fxlinuxprint { };

  brscan4 = callPackage ../applications/graphics/sane/backends/brscan4 { };

  dsseries = callPackage ../applications/graphics/sane/backends/dsseries { };

  mkSaneConfig = callPackage ../applications/graphics/sane/config.nix { };

  sane-frontends = callPackage ../applications/graphics/sane/frontends.nix { };

  sanoid = callPackage ../tools/backup/sanoid { };

  satysfi = callPackage ../tools/typesetting/satysfi { };

  sc-controller = pythonPackages.callPackage ../misc/drivers/sc-controller {
    inherit libusb1; # Shadow python.pkgs.libusb1.
  };

  sct = callPackage ../tools/X11/sct {};

  scylladb = callPackage ../servers/scylladb {
    thrift = thrift-0_10;
  };

  seafile-shared = callPackage ../misc/seafile-shared { };

  ser2net = callPackage ../servers/ser2net {};

  serviio = callPackage ../servers/serviio {};
  selinux-python = callPackage ../os-specific/linux/selinux-python { };

  slock = callPackage ../misc/screensavers/slock {
    conf = config.slock.conf or null;
  };

  smokeping = callPackage ../tools/networking/smokeping { };

  snapraid = callPackage ../tools/filesystems/snapraid { };

  snscrape = with python3Packages; toPythonApplication snscrape;

  soundOfSorting = callPackage ../misc/sound-of-sorting { };

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  splix = callPackage ../misc/cups/drivers/splix { };

  steamcontroller = callPackage ../misc/drivers/steamcontroller { };

  stern = callPackage ../applications/networking/cluster/stern { };

  streamripper = callPackage ../applications/audio/streamripper { };

  sqsh = callPackage ../development/tools/sqsh { };

  jx = callPackage ../applications/networking/cluster/jx {};

  prow = callPackage ../applications/networking/cluster/prow {
    # Version 2019-08-14 fails to build with go 1.13 due to dependencies:
    #   go: golang.org/x/lint@v0.0.0-20190301231843-5614ed5bae6f used for two different module paths (github.com/golang/lint and golang.org/x/lint)
    buildGoModule = buildGo112Module;
  };

  inherit (callPackage ../applications/networking/cluster/terraform {
    # terraform 0.12 crashes with go1.14 on darwin https://github.com/hashicorp/terraform/issues/24287
    buildGoPackage = if stdenv.isDarwin then buildGo113Package else buildGoPackage;
  })
    terraform_0_11
    terraform_0_11-full
    terraform_0_12
    terraform_plugins_test
    ;

  terraform = terraform_0_12;
  # deprecated
  terraform-full = terraform.full;

  terraform-providers = recurseIntoAttrs (
    callPackage ../applications/networking/cluster/terraform-providers {}
  );

  terraform-docs = callPackage ../applications/networking/cluster/terraform-docs {};

  terraform-inventory = callPackage ../applications/networking/cluster/terraform-inventory {};

  terraform-landscape = callPackage ../applications/networking/cluster/terraform-landscape {};

  terragrunt = callPackage ../applications/networking/cluster/terragrunt {};

  tilt = callPackage ../applications/networking/cluster/tilt {};

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  tewi-font = callPackage ../data/fonts/tewi
    { inherit (buildPackages.xorg) fonttosfnt mkfontscale; };

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # TeX Live; see http://nixos.org/nixpkgs/manual/#sec-language-texlive
  texlive = recurseIntoAttrs
    (callPackage ../tools/typesetting/tex/texlive { });

  ib-tws = callPackage ../applications/office/ib/tws { jdk=oraclejdk8; };

  ib-controller = callPackage ../applications/office/ib/controller { jdk=oraclejdk8; };

  vnote = libsForQt5.callPackage ../applications/office/vnote { };

  ssh-audit = callPackage ../tools/security/ssh-audit { };

  thermald = callPackage ../tools/system/thermald { };

  throttled = callPackage ../tools/system/throttled { };

  thinkfan = callPackage ../tools/system/thinkfan { };

  tup = callPackage ../development/tools/build-managers/tup { };

  tusk = callPackage ../applications/office/tusk { };

  trufflehog = callPackage ../tools/security/trufflehog { };

  tvbrowser-bin = callPackage ../applications/misc/tvbrowser/bin.nix { };

  tvheadend = callPackage ../servers/tvheadend { };

  ums = callPackage ../servers/ums { };

  unity3d = callPackage ../development/tools/unity3d {
    stdenv = stdenv_32bit;
    gcc_32bit = pkgsi686Linux.gcc;
    inherit (gnome2) GConf;
  };

  unityhub = callPackage ../development/tools/unityhub { };

  urbit = callPackage ../misc/urbit { };

  utf8proc = callPackage ../development/libraries/utf8proc { };

  unicode-paracode = callPackage ../tools/misc/unicode { };

  unixcw = callPackage ../applications/radio/unixcw { };

  vault = callPackage ../tools/security/vault { };

  vault-bin = callPackage ../tools/security/vault/vault-bin.nix { };

  vaultenv = haskellPackages.vaultenv;

  vazir-fonts = callPackage ../data/fonts/vazir-fonts { };

  vbam = callPackage ../misc/emulators/vbam {
    ffmpeg = ffmpeg_4;
  };

  vice = callPackage ../misc/emulators/vice {
    giflib = giflib_4_1;
  };

  viewnior = callPackage ../applications/graphics/viewnior { };

  vimUtils = callPackage ../misc/vim-plugins/vim-utils.nix { };

  vimPlugins = recurseIntoAttrs (callPackage ../misc/vim-plugins {
    llvmPackages = llvmPackages_6;
  });

  vimb-unwrapped = callPackage ../applications/networking/browsers/vimb { };
  vimb = wrapFirefox vimb-unwrapped { };

  vips = callPackage ../tools/graphics/vips {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };
  nip2 = callPackage ../tools/graphics/nip2 { };

  virglrenderer = callPackage ../development/libraries/virglrenderer { };

  vivid = callPackage ../tools/misc/vivid { };

  vokoscreen = libsForQt5.callPackage ../applications/video/vokoscreen { };

  vttest = callPackage ../tools/misc/vttest { };

  wacomtablet = libsForQt5.callPackage ../tools/misc/wacomtablet { };

  wasmer = callPackage ../development/interpreters/wasmer { };

  wasm-pack = callPackage ../development/tools/wasm-pack {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  wavegain = callPackage ../applications/audio/wavegain { };

  wcalc = callPackage ../applications/misc/wcalc { };

  webfs = callPackage ../servers/http/webfs { };

  websocketd = callPackage ../applications/networking/websocketd { };

  wikicurses = callPackage ../applications/misc/wikicurses {
    pythonPackages = python3Packages;
  };

  winePackagesFor = wineBuild: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit wineBuild;

    inherit (callPackage ./wine-packages.nix {})
      minimal base full stable unstable staging fonts;
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

  wishbone-tool = callPackage ../development/tools/misc/wishbone-tool { };

  with-shell = callPackage ../applications/misc/with-shell { };

  wmutils-core = callPackage ../tools/X11/wmutils-core { };

  wmutils-opt = callPackage ../tools/X11/wmutils-opt { };

  wordpress = callPackage ../servers/web-apps/wordpress { };

  wraith = callPackage ../applications/networking/irc/wraith {
    openssl = openssl_1_0_2;
  };

  wxmupen64plus = callPackage ../misc/emulators/wxmupen64plus { };

  wxsqlite3 = callPackage ../development/libraries/wxsqlite3 {
    wxGTK = wxGTK30;
  };

  wxsqliteplus = callPackage ../development/libraries/wxsqliteplus {
    wxGTK = wxGTK30;
  };

  x11idle = callPackage ../tools/misc/x11idle {};

  x11docker = callPackage ../applications/virtualization/x11docker { };

  x2x = callPackage ../tools/X11/x2x { };

  xboxdrv = callPackage ../misc/drivers/xboxdrv { };

  xow = callPackage ../misc/drivers/xow { };

  xbps = callPackage ../tools/package-management/xbps { };

  xcftools = callPackage ../tools/graphics/xcftools { };

  xhyve = callPackage ../applications/virtualization/xhyve {
    inherit (darwin.apple_sdk.frameworks) Hypervisor vmnet;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin) libobjc;
  };

  xinput_calibrator = callPackage ../tools/X11/xinput_calibrator { };

  xlayoutdisplay = callPackage ../tools/X11/xlayoutdisplay { };

  xlog = callPackage ../applications/radio/xlog { };

  xmagnify = callPackage ../tools/X11/xmagnify { };

  xosd = callPackage ../misc/xosd { };

  xosview2 = callPackage ../tools/X11/xosview2 { };

  xpad = callPackage ../applications/misc/xpad { };

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

  xteddy = callPackage ../applications/misc/xteddy { };

  xwiimote = callPackage ../misc/drivers/xwiimote { };

  xzoom = callPackage ../tools/X11/xzoom {};

  yabause = libsForQt5.callPackage ../misc/emulators/yabause {
    freeglut = null;
    openal = null;
  };

  yacreader = libsForQt5.callPackage ../applications/graphics/yacreader { };

  yadm = callPackage ../applications/version-management/yadm { };

  yamdi = callPackage ../tools/video/yamdi { };

  yandex-disk = callPackage ../tools/filesystems/yandex-disk { };

  yara = callPackage ../tools/security/yara { };

  yaxg = callPackage ../tools/graphics/yaxg {};

  zap = callPackage ../tools/networking/zap { };

  zopfli = callPackage ../tools/compression/zopfli { };

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  zoneminder = callPackage ../servers/zoneminder { };

  zsnes = pkgsi686Linux.callPackage ../misc/emulators/zsnes { };

  xcpc = callPackage ../misc/emulators/xcpc { };

  zxcvbn-c = callPackage ../development/libraries/zxcvbn-c { };

  snes9x-gtk = callPackage ../misc/emulators/snes9x-gtk { };

  openmsx = callPackage ../misc/emulators/openmsx {
    python = python27;
  };

  higan = callPackage ../misc/emulators/higan {
    inherit (gnome2) gtksourceview;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa OpenGL OpenAL;
  };

  bullet = callPackage ../development/libraries/bullet {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  bullet-roboschool = callPackage ../development/libraries/bullet/roboschool-fork.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa OpenGL;
  };

  inherit (callPackages ../development/libraries/spdlog { })
    spdlog_0 spdlog_1;

  spdlog = spdlog_1;

  dart = callPackage ../development/interpreters/dart { };
  dart_old = dart.override    { version = "1.24.3"; };
  dart_stable = dart.override { version = "2.7.1"; };
  dart_dev = dart.override    { version = "2.8.0-dev.10.0"; };

  httrack = callPackage ../tools/backup/httrack { };

  httraqt = libsForQt5.callPackage ../tools/backup/httrack/qt.nix { };

  mg = callPackage ../applications/editors/mg { };

  mpvc = callPackage ../applications/misc/mpvc { };

  aucdtect = callPackage ../tools/audio/aucdtect { };

  togglesg-download = callPackage ../tools/misc/togglesg-download { };

  discord = import ../applications/networking/instant-messengers/discord {
    branch = "stable";
    inherit pkgs;
  };

  discord-ptb = import ../applications/networking/instant-messengers/discord {
    branch = "ptb";
    inherit pkgs;
  };

  discord-canary = import ../applications/networking/instant-messengers/discord {
    branch = "canary";
    inherit pkgs;
  };

  golden-cheetah = libsForQt5.callPackage ../applications/misc/golden-cheetah {};

  linkchecker = callPackage ../tools/networking/linkchecker { };

  tomb = callPackage ../os-specific/linux/tomb {};

  tomboy = callPackage ../applications/misc/tomboy { };

  imatix_gsl = callPackage ../development/tools/imatix_gsl {};

  iterm2 = callPackage ../applications/misc/iterm2 {};

  sccache = callPackage ../development/tools/misc/sccache { };

  sequeler = callPackage ../applications/misc/sequeler { };

  sequelpro = callPackage ../applications/misc/sequelpro {};

  sidequest = callPackage ../applications/misc/sidequest {};

  maphosts = callPackage ../tools/networking/maphosts {};

  zimg = callPackage ../development/libraries/zimg { };

  wtf = callPackage ../applications/misc/wtf { };

  zk-shell = callPackage ../applications/misc/zk-shell { };

  tora = libsForQt5.callPackage ../development/tools/tora {};

  xulrunner = firefox-unwrapped;

  xrq = callPackage ../applications/misc/xrq { };

  nitrokey-app = libsForQt5.callPackage ../tools/security/nitrokey-app { };
  nitrokey-udev-rules = callPackage ../tools/security/nitrokey-app/udev-rules.nix { };

  fpm2 = callPackage ../tools/security/fpm2 { };

  simplenote = callPackage ../applications/misc/simplenote { };

  hy = callPackage ../development/interpreters/hy {};

  wmic-bin = callPackage ../servers/monitoring/plugins/wmic-bin.nix { };

  check-uptime = callPackage ../servers/monitoring/plugins/uptime.nix { };

  ghc-standalone-archive = callPackage ../os-specific/darwin/ghc-standalone-archive { inherit (darwin) cctools; };

  vdr = callPackage ../applications/video/vdr { };
  vdrPlugins = recurseIntoAttrs (callPackages ../applications/video/vdr/plugins.nix { });
  wrapVdr = callPackage ../applications/video/vdr/wrapper.nix {};

  chrome-export = callPackage ../tools/misc/chrome-export {};

  chrome-gnome-shell = callPackage  ../desktops/gnome-3/extensions/chrome-gnome-shell {};

  chrome-token-signing = libsForQt5.callPackage ../tools/security/chrome-token-signing {};

  NSPlist = callPackage ../development/libraries/NSPlist {};

  PlistCpp = callPackage ../development/libraries/PlistCpp {};

  xib2nib = callPackage ../development/tools/xib2nib {};

  linode-cli = callPackage ../tools/virtualization/linode-cli { };

  hss = callPackage ../tools/networking/hss {};

  undaemonize = callPackage ../tools/system/undaemonize {};

  houdini = callPackage ../applications/misc/houdini {};

  xtermcontrol = callPackage ../applications/misc/xtermcontrol {};

  openfst = callPackage ../development/libraries/openfst {};

  duti = callPackage ../os-specific/darwin/duti {};

  dnstracer = callPackage ../tools/networking/dnstracer {
    inherit (darwin) libresolv;
  };

  dsniff = callPackage ../tools/networking/dsniff {};

  wal-g = callPackage ../tools/backup/wal-g {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  tlwg = callPackage ../data/fonts/tlwg { };

  tt2020 = callPackage ../data/fonts/tt2020 { };

  simplehttp2server = callPackage ../servers/simplehttp2server { };

  diceware = callPackage ../tools/security/diceware { };

  xml2rfc = with python3Packages; toPythonApplication xml2rfc;

  mmark = callPackage ../tools/typesetting/mmark { };

  wire-desktop = callPackage ../applications/networking/instant-messengers/wire-desktop { };

  teseq = callPackage ../applications/misc/teseq {  };

  ape = callPackage ../applications/misc/ape { };
  attemptoClex = callPackage ../applications/misc/ape/clex.nix { };
  apeClex = callPackage ../applications/misc/ape/apeclex.nix { };

  # Unix tools
  unixtools = recurseIntoAttrs (callPackages ./unix-tools.nix { });
  inherit (unixtools) hexdump ps logger eject umount
                      mount wall hostname more sysctl getconf
                      getent locale killall xxd watch;

  fts = if stdenv.hostPlatform.isMusl then netbsd.fts else null;

  netbsd = callPackages ../os-specific/bsd/netbsd {};
  netbsdCross = callPackages ../os-specific/bsd/netbsd {
    stdenv = crossLibcStdenv;
  };

  yrd = callPackage ../tools/networking/yrd { };

  powershell = callPackage ../shells/powershell { };

  doing = callPackage ../applications/misc/doing  { };

  undervolt = callPackage ../os-specific/linux/undervolt { };

  alibuild = callPackage ../development/tools/build-managers/alibuild {
    python = python27;
  };

  tsung = callPackage ../applications/networking/tsung {};

  bcompare = libsForQt5.callPackage ../applications/version-management/bcompare {};

  qmk_firmware = callPackage ../development/misc/qmk_firmware {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrbinutils = pkgsCross.avr.buildPackages.binutils;
    gcc-arm-embedded = pkgsCross.arm-embedded.buildPackages.gcc;
    gcc-armhf-embedded = pkgsCross.armhf-embedded.buildPackages.gcc;
  };

  tdm = callPackage ../games/tdm { };

  newlib = callPackage ../development/misc/newlib { };
  newlibCross = callPackage ../development/misc/newlib {
    stdenv = crossLibcStdenv;
    };

  omnisharp-roslyn = callPackage ../development/tools/omnisharp-roslyn { };

  wasmtime = callPackage ../development/interpreters/wasmtime {};

  wfuzz = with python3Packages; toPythonApplication wfuzz;

  bemenu = callPackage ../applications/misc/bemenu { };

  dapper = callPackage ../development/tools/dapper { };

  kube3d =  callPackage ../applications/networking/cluster/kube3d {};

  zfs-replicate = python3Packages.callPackage ../tools/backup/zfs-replicate { };

  runwayml = callPackage ../applications/graphics/runwayml {};

  uhubctl = callPackage ../tools/misc/uhubctl {};

  kodelife = callPackage ../applications/graphics/kodelife {};

  _3proxy = callPackage ../applications/networking/3proxy {};

  pigeon = callPackage ../development/tools/pigeon {};

  verifpal = callPackage ../tools/security/verifpal {};

  nix-store-gcs-proxy = callPackage ../tools/nix/nix-store-gcs-proxy {};

  wifi-password = callPackage ../os-specific/darwin/wifi-password {};

  qubes-core-vchan-xen = callPackage ../applications/qubes/qubes-core-vchan-xen {};

  coz = callPackage ../development/tools/analysis/coz {};

  keycard-cli = callPackage ../tools/security/keycard-cli {};

  sieveshell = with python3.pkgs; toPythonApplication managesieve;

  gortr = callPackage ../servers/gortr {};

  sentencepiece = callPackage ../development/libraries/sentencepiece {};

  kcli = callPackage ../development/tools/kcli {};

  unstick = callPackage ../os-specific/linux/unstick {};

  quartus-prime-lite = callPackage ../applications/editors/quartus-prime {};

  go-license-detector = callPackage ../development/tools/misc/go-license-detector { };

  hashdeep = callPackage ../tools/security/hashdeep { };

  pdf-parser = callPackage ../tools/misc/pdf-parser {};

  fluxboxlauncher = callPackage ../applications/misc/fluxboxlauncher {};

  btcdeb = callPackage ../applications/blockchains/btcdeb {};

}
