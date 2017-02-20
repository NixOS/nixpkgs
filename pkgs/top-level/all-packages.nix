/* The top-level package collection of nixpkgs.
 * It is sorted by categories corresponding to the folder names
 * in the /pkgs folder. Inside the categories packages are roughly
 * sorted by alphabet, but strict sorting has been long lost due
 * to merges. Please use the full-text search of your editor. ;)
 * Hint: ### starts category names.
 */
{ lib, nixpkgsFun, noSysDirs, config}:
self: pkgs:

with pkgs;

{

  # Allow callPackage to fill in the pkgs argument
  inherit pkgs;


  # Override system. This is useful to build i686 packages on x86_64-linux.
  forceSystem = system: kernel: nixpkgsFun {
    localSystem = {
      inherit system;
      platform = platform // { kernelArch = kernel; };
    };
  };

  # Used by wine, firefox with debugging version of Flash, ...
  pkgsi686Linux = forceSystem "i686-linux" "i386";

  callPackage_i686 = pkgsi686Linux.callPackage;

  forcedNativePackages = if hostPlatform == buildPlatform then pkgs else buildPackages;

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (
    if system == "x86_64-linux" then
      overrideCC stdenv gcc_multi
    else
      stdenv);

  stdenvNoCC = stdenv.override { cc = null; };

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Helper functions.
  inherit lib config;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;
  inherit (misc) versionedDerivation;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  stringsWithDeps = lib.stringsWithDeps;


  ### Nixpkgs maintainer tools

  nix-generate-from-cpan = callPackage ../../maintainers/scripts/nix-generate-from-cpan.nix { };

  nixpkgs-lint = callPackage ../../maintainers/scripts/nixpkgs-lint.nix { };

  common-updater-scripts = callPackage ../common-updater/scripts.nix { };

  ### BUILD SUPPORT

  autoreconfHook = makeSetupHook
    { substitutions = { inherit autoconf automake gettext libtool; }; }
    ../build-support/setup-hooks/autoreconf.sh;

  ensureNewerSourcesHook = { year }: makeSetupHook {}
    (writeScript "ensure-newer-sources-hook.sh" ''
      postUnpackHooks+=(_ensureNewerSources)
      _ensureNewerSources() {
        '${findutils}/bin/find' "$sourceRoot" \
          '!' -newermt '${year}-01-01' -exec touch -h -d '${year}-01-02' '{}' '+'
      }
    '');

  updateAutotoolsGnuConfigScriptsHook = makeSetupHook
    { substitutions = { gnu_config = gnu-config;}; }
    ../build-support/setup-hooks/update-autotools-gnu-config-scripts.sh;

  buildEnv = callPackage ../build-support/buildenv { }; # not actually a package

  buildFHSUserEnv = callPackage ../build-support/build-fhs-userenv { };

  buildMaven = callPackage ../build-support/build-maven.nix {};

  cmark = callPackage ../development/libraries/cmark { };

  dhallToNix = callPackage ../build-support/dhall-to-nix.nix {
    inherit (haskellPackages) dhall-nix;
  };

  dockerTools = callPackage ../build-support/docker { };

  docker_compose = pythonPackages.docker_compose;

  dotnetenv = callPackage ../build-support/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  dotnetbuildhelpers = callPackage ../build-support/dotnetbuildhelpers { };

  dispad = callPackage ../tools/X11/dispad { };

  vsenv = callPackage ../build-support/vsenv {
    vs = vs90wrapper;
  };

  fetchadc = callPackage ../build-support/fetchadc {
    adc_user = if config ? adc_user
      then config.adc_user
      else throw "You need an adc_user attribute in your config to download files from Apple Developer Connection";
    adc_pass = if config ? adc_pass
      then config.adc_pass
      else throw "You need an adc_pass attribute in your config to download files from Apple Developer Connection";
  };

  fetchbower = callPackage ../build-support/fetchbower {
    inherit (nodePackages) bower2nix;
  };

  fetchbzr = callPackage ../build-support/fetchbzr { };

  fetchcvs = callPackage ../build-support/fetchcvs { };

  fetchdarcs = callPackage ../build-support/fetchdarcs { };

  fetchfossil = callPackage ../build-support/fetchfossil { };

  fetchgit = callPackage ../build-support/fetchgit {
    git = gitMinimal;
  };

  fetchgitPrivate = callPackage ../build-support/fetchgit/private.nix { };

  fetchgitrevision = import ../build-support/fetchgitrevision runCommand git;

  fetchgitLocal = callPackage ../build-support/fetchgitlocal { };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

  fetchMavenArtifact = callPackage ../build-support/fetchmavenartifact { };

  packer = callPackage ../development/tools/packer { };

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
    inherit curl stdenv;
  };

  # fetchurlBoot is used for curl and its dependencies in order to
  # prevent a cyclic dependency (curl depends on curl.tar.bz2,
  # curl.tar.bz2 depends on fetchurl, fetchurl depends on curl).  It
  # uses the curl from the previous bootstrap phase (e.g. a statically
  # linked curl in the case of stdenv-linux).
  fetchurlBoot = stdenv.fetchurlBoot;

  fetchzip = callPackage ../build-support/fetchzip { };

  fetchFromGitHub = {
    owner, repo, rev, name ? "${repo}-${rev}-src",
    fetchSubmodules ? false,
    ... # For hash agility
  }@args:
  let
    baseUrl = "https://github.com/${owner}/${repo}";
    passthruAttrs = removeAttrs args [ "owner" "repo" "rev" "fetchSubmodules" ];
  in if fetchSubmodules then
    fetchgit ({
      inherit name rev fetchSubmodules;
      url = "${baseUrl}.git";
    } // passthruAttrs)
  else
    # We prefer fetchzip in cases we don't need submodules as the hash
    # is more stable in that case.
    fetchzip ({
      inherit name;
      url = "${baseUrl}/archive/${rev}.tar.gz";
      meta.homepage = "${baseUrl}/";
    } // passthruAttrs) // { inherit rev; };

  fetchFromBitbucket = {
    owner, repo, rev, name ? "${repo}-${rev}-src",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
    meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
    extraPostFetch = ''rm -f "$out"/.hg_archival.txt''; # impure file; see #12002
  } // removeAttrs args [ "owner" "repo" "rev" ]) // { inherit rev; };

  # cgit example, snapshot support is optional in cgit
  fetchFromSavannah = {
    repo, rev, name ? "${repo}-${rev}-src",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "http://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
    meta.homepage = "http://git.savannah.gnu.org/cgit/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; };

  # gitlab example
  fetchFromGitLab = {
    owner, repo, rev, name ? "${repo}-${rev}-src",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "https://gitlab.com/${owner}/${repo}/repository/archive.tar.gz?ref=${rev}";
    meta.homepage = "https://gitlab.com/${owner}/${repo}/";
  } // removeAttrs args [ "owner" "repo" "rev" ]) // { inherit rev; };

  # gitweb example, snapshot support is optional in gitweb
  fetchFromRepoOrCz = {
    repo, rev, name ? "${repo}-${rev}-src",
    ... # For hash agility
  }@args: fetchzip ({
    inherit name;
    url = "http://repo.or.cz/${repo}.git/snapshot/${rev}.tar.gz";
    meta.homepage = "http://repo.or.cz/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; };

  fetchNuGet = callPackage ../build-support/fetchnuget { };
  buildDotnetPackage = callPackage ../build-support/build-dotnet-package { };

  fetchgx = callPackage ../build-support/fetchgx { };

  resolveMirrorURLs = {url}: fetchurl {
    showURLs = true;
    inherit url;
  };

  libredirect = callPackage ../build-support/libredirect { };

  makeDesktopItem = callPackage ../build-support/make-desktopitem { };

  makeAutostartItem = callPackage ../build-support/make-startupitem { };

  makeInitrd = { contents, compressor ? "gzip -9n", prepend ? [ ] }:
    callPackage ../build-support/kernel/make-initrd.nix {
      inherit contents compressor prepend;
    };

  makeWrapper = makeSetupHook { } ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = { kernel, rootModules, allowMissing ? false }:
    callPackage ../build-support/kernel/modules-closure.nix {
      inherit kernel rootModules allowMissing;
    };

  nixBufferBuilders = import ../build-support/emacs/buffer.nix { inherit (pkgs) lib writeText; inherit (emacsPackagesNg) inherit-local; };

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  singularity-tools = callPackage ../build-support/singularity-tools { };

  srcOnly = args: callPackage ../build-support/src-only args;

  substituteAll = callPackage ../build-support/substitute/substitute-all.nix { };

  substituteAllFiles = callPackage ../build-support/substitute-files/substitute-all-files.nix { };

  replaceDependency = callPackage ../build-support/replace-dependency.nix { };

  nukeReferences = callPackage ../build-support/nuke-references/default.nix { };

  vmTools = callPackage ../build-support/vm/default.nix { };

  releaseTools = callPackage ../build-support/release/default.nix { };

  composableDerivation = callPackage ../../lib/composable-derivation.nix { };

  platforms = import ./platforms.nix;

  setJavaClassPath = makeSetupHook { } ../build-support/setup-hooks/set-java-classpath.sh;

  fixDarwinDylibNames = makeSetupHook { } ../build-support/setup-hooks/fix-darwin-dylib-names.sh;

  keepBuildTree = makeSetupHook { } ../build-support/setup-hooks/keep-build-tree.sh;

  enableGCOVInstrumentation = makeSetupHook { } ../build-support/setup-hooks/enable-coverage-instrumentation.sh;

  makeGCOVReport = makeSetupHook
    { deps = [ pkgs.lcov pkgs.enableGCOVInstrumentation ]; }
    ../build-support/setup-hooks/make-coverage-analysis-report.sh;

  # intended to be used like nix-build -E 'with <nixpkgs> {}; enableDebugging fooPackage'
  enableDebugging = pkg: pkg.override { stdenv = stdenvAdapters.keepDebugInfo pkg.stdenv; };

  findXMLCatalogs = makeSetupHook { } ../build-support/setup-hooks/find-xml-catalogs.sh;

  wrapGAppsHook = makeSetupHook {
    deps = [ makeWrapper ];
  } ../build-support/setup-hooks/wrap-gapps-hook.sh;

  separateDebugInfo = makeSetupHook { } ../build-support/setup-hooks/separate-debug-info.sh;

  useOldCXXAbi = makeSetupHook { } ../build-support/setup-hooks/use-old-cxx-abi.sh;

  iconConvTools = callPackage ../build-support/icon-conv-tools {};


  ### TOOLS

  _9pfs = callPackage ../tools/filesystems/9pfs { };

  a2ps = callPackage ../tools/text/a2ps { };

  abduco = callPackage ../tools/misc/abduco { };

  acbuild = callPackage ../applications/misc/acbuild { };

  acct = callPackage ../tools/system/acct { };

  acoustidFingerprinter = callPackage ../tools/audio/acoustid-fingerprinter {
    ffmpeg = ffmpeg_1;
  };

  actdiag = pythonPackages.actdiag;

  actkbd = callPackage ../tools/system/actkbd { };

  advancecomp = callPackage ../tools/compression/advancecomp {};

  aefs = callPackage ../tools/filesystems/aefs { };

  aegisub = callPackage ../applications/video/aegisub {
    wxGTK = wxGTK30;
    spellcheckSupport = config.aegisub.spellcheckSupport or true;
    automationSupport = config.aegisub.automationSupport or true;
    openalSupport     = config.aegisub.openalSupport or false;
    alsaSupport       = config.aegisub.alsaSupport or true;
    pulseaudioSupport = config.aegisub.pulseaudioSupport or true;
    portaudioSupport  = config.aegisub.portaudioSupport or false;
  };

  aespipe = callPackage ../tools/security/aespipe { };

  aescrypt = callPackage ../tools/misc/aescrypt { };

  afl = callPackage ../tools/security/afl { };

  afpfs-ng = callPackage ../tools/filesystems/afpfs-ng/default.nix { };

  agrep = callPackage ../tools/text/agrep { };

  aha = callPackage ../tools/text/aha { };

  ahcpd = callPackage ../tools/networking/ahcpd { };

  aiccu = callPackage ../tools/networking/aiccu { };

  aide = callPackage ../tools/security/aide { };

  aircrack-ng = callPackage ../tools/networking/aircrack-ng { };

  airfield = callPackage ../tools/networking/airfield { };

  aj-snapshot  = callPackage ../applications/audio/aj-snapshot { };

  albert = qt5.callPackage ../applications/misc/albert {};

  amazon-glacier-cmd-interface = callPackage ../tools/backup/amazon-glacier-cmd-interface { };

  ammonite-repl = callPackage ../development/tools/ammonite {};

  amtterm = callPackage ../tools/system/amtterm {};

  analog = callPackage ../tools/admin/analog {};

  ansifilter = callPackage ../tools/text/ansifilter {};

  apktool = callPackage ../development/tools/apktool {
    buildTools = androidenv.buildTools;
  };

  apt-cacher-ng = callPackage ../servers/http/apt-cacher-ng { };

  apt-offline = callPackage ../tools/misc/apt-offline { };

  aptly = callPackage ../tools/misc/aptly { };

  apulse = callPackage ../misc/apulse { };

  archivemount = callPackage ../tools/filesystems/archivemount { };

  arandr = callPackage ../tools/X11/arandr { };

  arangodb = callPackage ../servers/nosql/arangodb { };

  arcanist = callPackage ../development/tools/misc/arcanist {};

  arduino = arduino-core.override { withGui = true; };

  arduino-core = callPackage ../development/arduino/arduino-core {
    jdk = jdk;
    withGui = false;
  };

  apitrace = qt55.callPackage ../applications/graphics/apitrace {};

  argus = callPackage ../tools/networking/argus {};

  argus-clients = callPackage ../tools/networking/argus-clients {};

  argtable = callPackage ../tools/misc/argtable {};

  argyllcms = callPackage ../tools/graphics/argyllcms {};

  arp-scan = callPackage ../tools/misc/arp-scan { };

  artyFX = callPackage ../applications/audio/artyFX {};

  as31 = callPackage ../development/compilers/as31 {};

  ascii = callPackage ../tools/text/ascii { };

  asciinema = callPackage ../tools/misc/asciinema {};

  asymptote = callPackage ../tools/graphics/asymptote {
    texLive = texlive.combine { inherit (texlive) scheme-small epsf cm-super; };
    gsl = gsl_1;
  };

  atomicparsley = callPackage ../tools/video/atomicparsley { };

  attic = callPackage ../tools/backup/attic {
    python3Packages = python34Packages;
  };

  avfs = callPackage ../tools/filesystems/avfs { };

  awscli = pythonPackages.awscli; # Should be moved out of python-packages.nix

  awslogs = callPackage ../tools/admin/awslogs { };

  aws_shell = python2Packages.aws_shell; # Should be moved out of python-packages.nix

  azure-cli = nodePackages.azure-cli;

  azure-vhd-utils  = callPackage ../tools/misc/azure-vhd-utils { };

  awless = callPackage ../tools/virtualization/awless { };

  ec2_api_tools = callPackage ../tools/virtualization/ec2-api-tools { };

  ec2_ami_tools = callPackage ../tools/virtualization/ec2-ami-tools { };

  altermime = callPackage ../tools/networking/altermime {};

  amule = callPackage ../tools/networking/p2p/amule { };

  amuleDaemon = appendToName "daemon" (amule.override {
    monolithic = false;
    daemon = true;
  });

  amuleGui = appendToName "gui" (amule.override {
    monolithic = false;
    client = true;
  });

  androidenv = callPackage ../development/mobile/androidenv {
    pkgs_i686 = pkgsi686Linux;
  };

  adb-sync = callPackage ../development/mobile/adb-sync { };

  apg = callPackage ../tools/security/apg { };

  autorevision = callPackage ../tools/misc/autorevision { };

  bonnie = callPackage ../tools/filesystems/bonnie { };

  djmount = callPackage ../tools/filesystems/djmount { };

  dgsh = callPackage ../shells/dgsh { };

  elvish = callPackage ../shells/elvish { };

  encryptr = callPackage ../tools/security/encryptr {
    gconf = gnome2.GConf;
 };

  enpass = callPackage ../tools/security/enpass { };

  genymotion = callPackage ../development/mobile/genymotion { };

  grc = callPackage ../tools/misc/grc { };

  green-pdfviewer = callPackage ../applications/misc/green-pdfviewer {
   SDL = SDL_sixel;
  };

  gcsfuse = callPackage ../tools/filesystems/gcsfuse { };

  lastpass-cli = callPackage ../tools/security/lastpass-cli { };

  pass = callPackage ../tools/security/pass { };

  oracle-instantclient = callPackage ../development/libraries/oracle-instantclient { };

  kwm = callPackage ../os-specific/darwin/kwm { };

  khd = callPackage ../os-specific/darwin/khd {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  reattach-to-user-namespace = callPackage ../os-specific/darwin/reattach-to-user-namespace {};

  install_name_tool = callPackage ../os-specific/darwin/install_name_tool { };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  titaniumenv = callPackage ../development/mobile/titaniumenv {
    pkgs_i686 = pkgsi686Linux;
  };

  inherit (androidenv) androidsdk_4_4 androidndk;

  androidsdk = androidenv.androidsdk_7_0;

  androidsdk_extras = self.androidenv.androidsdk_7_0_extras;

  arc-theme = callPackage ../misc/themes/arc { };

  adapta-gtk-theme = callPackage ../misc/themes/adapta { };

  aria2 = callPackage ../tools/networking/aria2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  aria = aria2;

  aspcud = callPackage ../tools/misc/aspcud {
    boost = boost163;
  };

  at = callPackage ../tools/system/at { };

  atftp = callPackage ../tools/networking/atftp { };

  autogen = callPackage ../development/tools/misc/autogen { };

  autojump = callPackage ../tools/misc/autojump { };

  autorandr = callPackage ../tools/misc/autorandr {};

  avahi = callPackage ../development/libraries/avahi {
    qt4Support = config.avahi.qt4Support or false;
  };

  avro-cpp = callPackage ../development/libraries/avro-c++ { boost = boost160; };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  awstats = callPackage ../tools/system/awstats { };

  axel = callPackage ../tools/networking/axel {
    libssl = openssl;
  };

  azureus = callPackage ../tools/networking/p2p/azureus { };

  backblaze-b2 = callPackage ../development/tools/backblaze-b2 { };

  backup = callPackage ../tools/backup/backup { };

  base16 = callPackage ../misc/base16 { };

  basex = callPackage ../tools/text/xml/basex { };

  babeld = callPackage ../tools/networking/babeld { };

  badvpn = callPackage ../tools/networking/badvpn {};

  barcode = callPackage ../tools/graphics/barcode {};

  bashburn = callPackage ../tools/cd-dvd/bashburn { };

  bashmount = callPackage ../tools/filesystems/bashmount {};

  bc = callPackage ../tools/misc/bc { };

  bdf2psf = callPackage ../tools/misc/bdf2psf { };

  bcache-tools = callPackage ../tools/filesystems/bcache-tools { };

  bchunk = callPackage ../tools/cd-dvd/bchunk { };

  bfr = callPackage ../tools/misc/bfr { };

  bibtool = callPackage ../tools/misc/bibtool { };

  bibutils = callPackage ../tools/misc/bibutils { };

  bibtex2html = callPackage ../tools/misc/bibtex2html { };

  bindfs = callPackage ../tools/filesystems/bindfs { };

  bins = callPackage ../tools/graphics/bins { };

  bitbucket-cli = python2Packages.bitbucket-cli;

  blink = callPackage ../applications/networking/instant-messengers/blink { };

  blink1-tool = callPackage ../tools/misc/blink1-tool { };

  blitz = callPackage ../development/libraries/blitz { };

  blockdiag = pythonPackages.blockdiag;

  bluez-tools = callPackage ../tools/bluetooth/bluez-tools { };

  bmon = callPackage ../tools/misc/bmon { };

  bochs = callPackage ../applications/virtualization/bochs { };

  borgbackup = callPackage ../tools/backup/borg {
    python3Packages = python34Packages;
  };

  boomerang = callPackage ../development/tools/boomerang { };

  boost-build = callPackage ../development/tools/boost-build { };

  boot = callPackage ../development/tools/build-managers/boot { };

  bootchart = callPackage ../tools/system/bootchart { };

  boxfs = callPackage ../tools/filesystems/boxfs { };

  brasero-original = lowPrio (callPackage ../tools/cd-dvd/brasero { });

  brasero = callPackage ../tools/cd-dvd/brasero/wrapper.nix { };

  brltty = callPackage ../tools/misc/brltty {
    alsaSupport = (!stdenv.isDarwin);
    systemdSupport = stdenv.isLinux;
  };
  bro = callPackage ../applications/networking/ids/bro { };

  bruteforce-luks = callPackage ../tools/security/bruteforce-luks { };

  bsod = callPackage ../misc/emulators/bsod { };

  btrfs-progs = callPackage ../tools/filesystems/btrfs-progs { };
  btrfs-progs_4_4_1 = callPackage ../tools/filesystems/btrfs-progs/4.4.1.nix { };

  btrfs-dedupe = callPackage ../tools/filesystems/btrfs-dedupe/default.nix {};

  btrbk = callPackage ../tools/backup/btrbk { };

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

  burpsuite = callPackage ../tools/networking/burpsuite {};

  cabal2nix = haskell.lib.overrideCabal haskellPackages.cabal2nix (drv: {
    isLibrary = false;
    enableSharedExecutables = false;
    executableToolDepends = [ makeWrapper ];
    postInstall = ''
      exe=$out/libexec/${drv.pname}-${drv.version}/${drv.pname}
      install -D $out/bin/${drv.pname} $exe
      rm -rf $out/{bin,lib,share}
      makeWrapper $exe $out/bin/${drv.pname} --prefix PATH ":" "${nix-prefetch-scripts}/bin"
      mkdir -p $out/share/bash-completion/completions
      $exe --bash-completion-script $exe >$out/share/bash-completion/completions/${drv.pname}
    '';
  });

  caddy = callPackage ../servers/caddy { };

  capstone = callPackage ../development/libraries/capstone { };

  cataract          = callPackage ../applications/misc/cataract { };
  cataract-unstable = callPackage ../applications/misc/cataract/unstable.nix { };

  catch = callPackage ../development/libraries/catch { };

  catdoc = callPackage ../tools/text/catdoc { };

  catclock = callPackage ../applications/misc/catclock { };

  cdemu-daemon = callPackage ../misc/emulators/cdemu/daemon.nix { };

  cdemu-client = callPackage ../misc/emulators/cdemu/client.nix { };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    google-gflags = null; # only required for examples/tests
  };

  gcdemu = callPackage ../misc/emulators/cdemu/gui.nix { };

  image-analyzer = callPackage ../misc/emulators/cdemu/analyzer.nix { };

  ccnet = callPackage ../tools/networking/ccnet { };

  cfdyndns = callPackage ../applications/networking/dyndns/cfdyndns { };

  ckbcomp = callPackage ../tools/X11/ckbcomp { };

  clasp = callPackage ../tools/misc/clasp { };

  cli53 = callPackage ../tools/admin/cli53 { };

  cli-visualizer = callPackage ../applications/misc/cli-visualizer { };

  cloud-init = callPackage ../tools/virtualization/cloud-init { };

  clib = callPackage ../tools/package-management/clib { };

  colord-kde = qt5.callPackage ../tools/misc/colord-kde/0.5.nix {};

  consul = callPackage ../servers/consul { };

  consul-ui = callPackage ../servers/consul/ui.nix { };

  consul-alerts = callPackage ../servers/monitoring/consul-alerts { };

  consul-template = callPackage ../tools/system/consul-template { };

  copyright-update = callPackage ../tools/text/copyright-update { };

  corebird = callPackage ../applications/networking/corebird { };

  corosync = callPackage ../servers/corosync { };

  cowsay = callPackage ../tools/misc/cowsay { };

  cherrytree = callPackage ../applications/misc/cherrytree { };

  chntpw = callPackage ../tools/security/chntpw { };

  clipster = callPackage ../tools/misc/clipster { };

  coprthr = callPackage ../development/libraries/coprthr {
    flex = flex_2_5_35;
  };

  cpulimit = callPackage ../tools/misc/cpulimit { };

  codesearch = callPackage ../tools/text/codesearch { };

  contacts = callPackage ../tools/misc/contacts {
    inherit (darwin.apple_sdk.frameworks) Foundation AddressBook;
  };

  coturn = callPackage ../servers/coturn { };

  crunch = callPackage ../tools/security/crunch { };

  daemontools = callPackage ../tools/admin/daemontools { };

  dante = callPackage ../servers/dante { };

  datamash = callPackage ../tools/misc/datamash { };

  datefudge = callPackage ../tools/system/datefudge { };

  dateutils = callPackage ../tools/misc/dateutils { };

  ddate = callPackage ../tools/misc/ddate { };

  dehydrated = callPackage ../tools/admin/dehydrated { };

  deis = callPackage ../development/tools/deis {};

  deisctl = callPackage ../development/tools/deisctl {};

  devmem2 = callPackage ../os-specific/linux/devmem2 { };

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialog = callPackage ../development/tools/misc/dialog { };

  dibbler = callPackage ../tools/networking/dibbler { };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  dirb = callPackage ../tools/networking/dirb { };

  direnv = callPackage ../tools/misc/direnv { };

  discount = callPackage ../tools/text/discount { };

  diskscan = callPackage ../tools/misc/diskscan { };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  dislocker = callPackage ../tools/filesystems/dislocker { };

  ditaa = callPackage ../tools/graphics/ditaa { };

  dlx = callPackage ../misc/emulators/dlx { };

  dosage = pythonPackages.dosage;

  dpic = callPackage ../tools/graphics/dpic { };

  dragon-drop = callPackage ../tools/X11/dragon-drop {
    gtk = gtk3;
  };

  dtrx = callPackage ../tools/compression/dtrx { };

  duperemove = callPackage ../tools/filesystems/duperemove { };

  dynamic-colors = callPackage ../tools/misc/dynamic-colors { };

  ecasound = callPackage ../applications/audio/ecasound { };

  edac-utils = callPackage ../os-specific/linux/edac-utils { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  elementary-icon-theme = callPackage ../data/icons/elementary-icon-theme { };

  emby = callPackage ../servers/emby { };

  enca = callPackage ../tools/text/enca { };

  ent = callPackage ../tools/misc/ent { };

  envconsul = callPackage ../tools/system/envconsul { };

  f3 = callPackage ../tools/filesystems/f3 { };

  facter = callPackage ../tools/system/facter {
    boost = boost160;
    ruby = ruby_2_1;
  };

  fasd = callPackage ../tools/misc/fasd { };

  fastJson = callPackage ../development/libraries/fastjson { };

  filebench = callPackage ../tools/misc/filebench { };

  fsmon = callPackage ../tools/misc/fsmon { };

  fop = callPackage ../tools/typesetting/fop { };

  fondu = callPackage ../tools/misc/fondu { };

  fpp = callPackage ../tools/misc/fpp { };

  fsmark = callPackage ../tools/misc/fsmark { };

  fzf = callPackage ../tools/misc/fzf { };

  fzy = callPackage ../tools/misc/fzy { };

  gbsplay = callPackage ../applications/audio/gbsplay { };

  gdrivefs = python27Packages.gdrivefs;

  go-dependency-manager = callPackage ../development/tools/gdm { };

  gencfsm = callPackage ../tools/security/gencfsm { };

  genromfs = callPackage ../tools/filesystems/genromfs { };

  gist = callPackage ../tools/text/gist { };

  glide = callPackage ../development/tools/glide { };

  glock = callPackage ../development/tools/glock { };

  gmic = callPackage ../tools/graphics/gmic { };

  goa = callPackage ../development/tools/goa { };

  gorilla-bin = callPackage ../tools/security/gorilla-bin { };

  gringo = callPackage ../tools/misc/gringo { };

  gti = callPackage ../tools/misc/gti { };

  heatseeker = callPackage ../tools/misc/heatseeker { };

  hexio = callPackage ../development/tools/hexio { };

  interlock = callPackage ../servers/interlock {};

  kapacitor = callPackage ../servers/monitoring/kapacitor { };

  languagetool = callPackage ../tools/text/languagetool {  };

  long-shebang = callPackage ../misc/long-shebang {};

  mathics = pythonPackages.mathics;

  meson = callPackage ../development/tools/build-managers/meson { };

  mp3fs = callPackage ../tools/filesystems/mp3fs { };

  mpdcron = callPackage ../tools/audio/mpdcron { };

  mpdris2 = callPackage ../tools/audio/mpdris2 { };

  playerctl = callPackage ../tools/audio/playerctl { };

  syscall_limiter = callPackage ../os-specific/linux/syscall_limiter {};

  syslogng = callPackage ../tools/system/syslog-ng { };

  syslogng_incubator = callPackage ../tools/system/syslog-ng-incubator { };

  rsyslog = callPackage ../tools/system/rsyslog {
    hadoop = null; # Currently Broken
    czmq = czmq3;
  };

  rsyslog-light = callPackage ../tools/system/rsyslog {
    libkrb5 = null;
    systemd = null;
    jemalloc = null;
    libmysql = null;
    postgresql = null;
    libdbi = null;
    net_snmp = null;
    libuuid = null;
    curl = null;
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

  mcrypt = callPackage ../tools/misc/mcrypt { };

  mongodb-tools = callPackage ../tools/misc/mongodb-tools { };

  mstflint = callPackage ../tools/misc/mstflint { };

  mcelog = callPackage ../os-specific/linux/mcelog {
    utillinux = utillinuxMinimal;
  };

  apparix = callPackage ../tools/misc/apparix { };

  appdata-tools = callPackage ../tools/misc/appdata-tools { };

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

  asciidoctor = callPackage ../tools/typesetting/asciidoctor { };

  asunder = callPackage ../applications/audio/asunder { };

  autossh = callPackage ../tools/networking/autossh { };

  asynk = callPackage ../tools/networking/asynk { };

  bacula = callPackage ../tools/backup/bacula { };

  bareos = callPackage ../tools/backup/bareos { };

  bats = callPackage ../development/interpreters/bats { };

  beanstalkd = callPackage ../servers/beanstalkd { };

  beets = callPackage ../tools/audio/beets {
    pythonPackages = python2Packages;
  };

  bgs = callPackage ../tools/X11/bgs { };

  biber = callPackage ../tools/typesetting/biber {
    inherit (perlPackages)
      autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
      DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
      ExtUtilsLibBuilder FileSlurp IPCRun3 Log4Perl LWPProtocolHttps ListAllUtils
      ListMoreUtils ModuleBuild MozillaCA ReadonlyXS RegexpCommon TextBibTeX
      UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
      ClassAccessor TextRoman DataUniqid LinguaTranslit UnicodeNormalize;
  };

  blueman = callPackage ../tools/bluetooth/blueman {
    inherit (gnome3) dconf gsettings_desktop_schemas;
    withPulseAudio = config.pulseaudio or true;
  };

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

  bup = callPackage ../tools/backup/bup {
    par2Support = config.bup.par2Support or false;
  };

  burp_1_3 = callPackage ../tools/backup/burp/1.3.48.nix { };

  burp = callPackage ../tools/backup/burp { };

  buku = callPackage ../applications/misc/buku {
    pythonPackages = python3Packages;
  };

  byzanz = callPackage ../applications/video/byzanz {};

  ori = callPackage ../tools/backup/ori { };

  atool = callPackage ../tools/archivers/atool { };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  cabextract = callPackage ../tools/archivers/cabextract { };

  cadaver = callPackage ../tools/networking/cadaver { };

  davix = callPackage ../tools/networking/davix { };

  cantata = qt5.callPackage ../applications/audio/cantata {
    ffmpeg = ffmpeg_2;
  };

  can-utils = callPackage ../os-specific/linux/can-utils { };

  caudec = callPackage ../applications/audio/caudec { };

  ccid = callPackage ../tools/security/ccid { };

  ccrypt = callPackage ../tools/security/ccrypt { };

  ccze = callPackage ../tools/misc/ccze { };

  cdecl = callPackage ../development/tools/cdecl { };

  cdi2iso = callPackage ../tools/cd-dvd/cdi2iso { };

  cdrdao = callPackage ../tools/cd-dvd/cdrdao { };

  cdrkit = callPackage ../tools/cd-dvd/cdrkit { };

  mdf2iso = callPackage ../tools/cd-dvd/mdf2iso { };

  nrg2iso = callPackage ../tools/cd-dvd/nrg2iso { };

  libceph = ceph.lib;
  ceph = callPackage ../tools/filesystems/ceph { boost = boost159; };
  ceph-dev = ceph;
  #ceph-dev = lowPrio (callPackage ../tools/filesystems/ceph/dev.nix { });

  cfdg = callPackage ../tools/graphics/cfdg {
    ffmpeg = ffmpeg_2;
  };

  checkinstall = callPackage ../tools/package-management/checkinstall { };

  chkrootkit = callPackage ../tools/security/chkrootkit { };

  chrony = callPackage ../tools/networking/chrony { };

  chunkfs = callPackage ../tools/filesystems/chunkfs { };

  chunksync = callPackage ../tools/backup/chunksync { };

  cipherscan = callPackage ../tools/security/cipherscan {
    openssl = if stdenv.system == "x86_64-linux"
      then openssl-chacha
      else openssl;
  };

  cjdns = callPackage ../tools/networking/cjdns { };

  cksfv = callPackage ../tools/networking/cksfv { };

  clementine = callPackage ../applications/audio/clementine {
    boost = boost155;
    gst_plugins = [ gst_plugins_base gst_plugins_good gst_plugins_ugly gst_ffmpeg ];
  };

  clementineFree = clementine.free;

  ciopfs = callPackage ../tools/filesystems/ciopfs { };

  citrix_receiver = callPackage ../applications/networking/remote/citrix-receiver { };

  cmst = qt5.callPackage ../tools/networking/cmst { };

  colord = callPackage ../tools/misc/colord { };

  colord-gtk = callPackage ../tools/misc/colord-gtk { };

  colordiff = callPackage ../tools/text/colordiff { };

  concurrencykit = callPackage ../development/libraries/concurrencykit { };

  connect = callPackage ../tools/networking/connect { };

  conspy = callPackage ../os-specific/linux/conspy {};

  connman = callPackage ../tools/networking/connman { };

  connman-notify = callPackage ../tools/networking/connman-notify { };

  connmanui = callPackage ../tools/networking/connmanui { };

  connman_dmenu = callPackage ../tools/networking/connman_dmenu  { };

  convertlit = callPackage ../tools/text/convertlit { };

  collectd = callPackage ../tools/system/collectd {
    libmysql = mysql.lib;
    libsigrok = libsigrok-0-3-0; # not compatible with >= 0.4.0 yet
  };

  colormake = callPackage ../development/tools/build-managers/colormake { };

  cpuminer = callPackage ../tools/misc/cpuminer { };

  cpuminer-multi = callPackage ../tools/misc/cpuminer-multi { };

  cuetools = callPackage ../tools/cd-dvd/cuetools { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  "unionfs-fuse" = callPackage ../tools/filesystems/unionfs-fuse { };

  usb-modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };
  usb-modeswitch-data = callPackage ../development/tools/misc/usb-modeswitch/data.nix { };

  anthy = callPackage ../tools/inputmethods/anthy { };

  libpinyin = callPackage ../development/libraries/libpinyin { };

  m17n_db = callPackage ../tools/inputmethods/m17n-db { };

  m17n_lib = callPackage ../tools/inputmethods/m17n-lib { };

  ibus = callPackage ../tools/inputmethods/ibus {
    inherit (python3Packages) pygobject3;
    inherit (gnome3) dconf glib;
  };

  ibus-qt = callPackage ../tools/inputmethods/ibus/ibus-qt.nix { };

  ibus-engines = recurseIntoAttrs {

    anthy = callPackage ../tools/inputmethods/ibus-engines/ibus-anthy {
      inherit (python3Packages) pygobject3;
    };

    hangul = callPackage ../tools/inputmethods/ibus-engines/ibus-hangul {
      inherit (python3Packages) pygobject3;
    };

    libpinyin = callPackage ../tools/inputmethods/ibus-engines/ibus-libpinyin {
      inherit (python3Packages) pygobject3;
    };

    m17n = callPackage ../tools/inputmethods/ibus-engines/ibus-m17n {
      inherit (python3Packages) pygobject3;
    };

    mozc = callPackage ../tools/inputmethods/ibus-engines/ibus-mozc {
      inherit (pythonPackages) gyp;
      protobuf = protobuf.override { stdenv = clangStdenv; };
    };

    table = callPackage ../tools/inputmethods/ibus-engines/ibus-table {
      inherit (python3Packages) pygobject3;
      inherit (gnome3) dconf;
    };

    table-others = callPackage ../tools/inputmethods/ibus-engines/ibus-table-others {
      ibus-table = ibus-engines.table;
    };

    uniemoji = callPackage ../tools/inputmethods/ibus-engines/ibus-uniemoji { };
  };

  ibus-with-plugins = callPackage ../tools/inputmethods/ibus/wrapper.nix {
    inherit (gnome3) dconf;
    plugins = [ ];
  };

  brotli = callPackage ../tools/compression/brotli { };

  brotliUnstable = callPackage ../tools/compression/brotli/unstable.nix { };

  libbrotli = callPackage ../development/libraries/libbrotli { };

  biosdevname = callPackage ../tools/networking/biosdevname { };

  c14 = callPackage ../applications/networking/c14 { };

  checkbashisms = callPackage ../development/tools/misc/checkbashisms { };

  clamav = callPackage ../tools/security/clamav { };

  clex = callPackage ../tools/misc/clex { };

  cloc = callPackage ../tools/misc/cloc {
    inherit (perlPackages) perl AlgorithmDiff RegexpCommon;
  };

  cloog = callPackage ../development/libraries/cloog {
    isl = isl_0_14;
  };

  cloog_0_18_0 = callPackage ../development/libraries/cloog/0.18.0.nix {
    isl = isl_0_11;
  };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  cloud-utils = callPackage ../tools/misc/cloud-utils { };

  ckb = qt5.callPackage ../tools/misc/ckb { };

  compass = callPackage ../development/tools/compass { };

  convmv = callPackage ../tools/misc/convmv { };

  convoy = callPackage ../tools/filesystems/convoy { };

  cool-retro-term = qt55.callPackage ../applications/misc/cool-retro-term { };

  coreutils = callPackage ../tools/misc/coreutils {
    aclSupport = stdenv.isLinux;
    attrSupport = stdenv.isLinux;
  };

  coreutils-prefixed = coreutils.override { withPrefix = true; singleBinary = false; };

  corkscrew = callPackage ../tools/networking/corkscrew { };

  cowpatty = callPackage ../tools/security/cowpatty { };

  cpio = callPackage ../tools/archivers/cpio { };

  crackxls = callPackage ../tools/security/crackxls { };

  createrepo_c = callPackage ../tools/package-management/createrepo_c { };

  cromfs = callPackage ../tools/archivers/cromfs { };

  cron = callPackage ../tools/system/cron { };

  inherit (callPackages ../development/compilers/cudatoolkit { })
    cudatoolkit6
    cudatoolkit65
    cudatoolkit7
    cudatoolkit75
    cudatoolkit8;

  cudatoolkit = cudatoolkit8;

  cudnn = callPackage ../development/libraries/science/math/cudnn/default.nix {};

  cudnn5_cudatoolkit75 = callPackage ../development/libraries/science/math/cudnn/7.5-5.0 {
    cudatoolkit = cudatoolkit75;
  };

  cudnn5_cudatoolkit80 = callPackage ../development/libraries/science/math/cudnn/8.0-5.0 {
    cudatoolkit = cudatoolkit8;
  };

  cudnn51_cudatoolkit80 = callPackage ../development/libraries/science/math/cudnn/8.0-5.1 {
    cudatoolkit = cudatoolkit8;
  };

  curlFull = curl.override {
    idnSupport = true;
    ldapSupport = true;
    gssSupport = true;
  };

  curl = callPackage ../tools/networking/curl rec {
    fetchurl = fetchurlBoot;
    http2Support = !stdenv.isDarwin;
    zlibSupport = true;
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
  };

  curl_unix_socket = callPackage ../tools/networking/curl-unix-socket rec { };

  cunit = callPackage ../tools/misc/cunit { };
  bcunit = callPackage ../tools/misc/bcunit { };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  cutter = callPackage ../tools/networking/cutter { };

  cwebbin = callPackage ../development/tools/misc/cwebbin { };

  cvs_fast_export = callPackage ../applications/version-management/cvs-fast-export { };

  dadadodo = callPackage ../tools/text/dadadodo { };

  daemonize = callPackage ../tools/system/daemonize { };

  daq = callPackage ../applications/networking/ids/daq { };

  dar = callPackage ../tools/archivers/dar { };

  darkhttpd = callPackage ../servers/http/darkhttpd { };

  darkstat = callPackage ../tools/networking/darkstat { };

  davfs2 = callPackage ../tools/filesystems/davfs2 { };

  dbench = callPackage ../development/tools/misc/dbench { };

  dclxvi = callPackage ../development/libraries/dclxvi { };

  dcraw = callPackage ../tools/graphics/dcraw { };

  dcfldd = callPackage ../tools/system/dcfldd { };

  debianutils = callPackage ../tools/misc/debianutils { };

  debian-devscripts = callPackage ../tools/misc/debian-devscripts {
    inherit (perlPackages) CryptSSLeay LWP TimeDate DBFile FileDesktopEntry;
  };

  debootstrap = callPackage ../tools/misc/debootstrap { };

  detox = callPackage ../tools/misc/detox { };

  devilspie2 = callPackage ../applications/misc/devilspie2 {
    gtk = gtk3;
  };

  dex = callPackage ../tools/X11/dex { };

  ddccontrol = callPackage ../tools/misc/ddccontrol { };

  ddccontrol-db = callPackage ../data/misc/ddccontrol-db { };

  ddclient = callPackage ../tools/networking/ddclient { };

  dd_rescue = callPackage ../tools/system/dd_rescue { };

  ddrescue = callPackage ../tools/system/ddrescue { };

  deluge = python2Packages.deluge; # Package should be moved out of python-packages.nix

  desktop_file_utils = callPackage ../tools/misc/desktop-file-utils { };

  despotify = callPackage ../development/libraries/despotify { };

  dfc  = callPackage ../tools/system/dfc { };

  dev86 = callPackage ../development/compilers/dev86 { };

  dnscrypt-proxy = callPackage ../tools/networking/dnscrypt-proxy { };

  dnscrypt-wrapper = callPackage ../tools/networking/dnscrypt-wrapper { };

  dnsmasq = callPackage ../tools/networking/dnsmasq { };

  dnstop = callPackage ../tools/networking/dnstop { };

  dhcp = callPackage ../tools/networking/dhcp { };

  dhcpdump = callPackage ../tools/networking/dhcpdump { };

  dhcpcd = callPackage ../tools/networking/dhcpcd { };

  dhcping = callPackage ../tools/networking/dhcping { };

  di = callPackage ../tools/system/di { };

  diction = callPackage ../tools/text/diction { };

  diffoscope = callPackage ../tools/misc/diffoscope {
    jdk = jdk7;
    pythonPackages = python3Packages;
  };

  diffstat = callPackage ../tools/text/diffstat { };

  diffutils = callPackage ../tools/text/diffutils { };

  dir2opus = callPackage ../tools/audio/dir2opus {
    inherit (pythonPackages) mutagen python wrapPython;
  };

  wgetpaste = callPackage ../tools/text/wgetpaste { };

  dirmngr = callPackage ../tools/security/dirmngr { };

  disper = callPackage ../tools/misc/disper { };

  dmd_2_067_1 = callPackage ../development/compilers/dmd/2.067.1.nix { };
  dmd = callPackage ../development/compilers/dmd {
    bootstrapDmd = dmd_2_067_1;
  };

  dmg2img = callPackage ../tools/misc/dmg2img { };

  docbook2odf = callPackage ../tools/typesetting/docbook2odf {
    inherit (perlPackages) PerlMagick;
  };

  docbook2x = callPackage ../tools/typesetting/docbook2x {
    inherit (perlPackages) XMLSAX XMLParser XMLNamespaceSupport;
  };

  docbook2mdoc = callPackage ../tools/misc/docbook2mdoc { };

  dog = callPackage ../tools/system/dog { };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dolphinEmu = callPackage ../misc/emulators/dolphin-emu { };
  dolphinEmuMaster = callPackage ../misc/emulators/dolphin-emu/master.nix { };

  doomseeker = callPackage ../applications/misc/doomseeker { };

  slade = callPackage ../applications/misc/slade {
    wxGTK = wxGTK30;
  };

  drive = callPackage ../applications/networking/drive { };

  driftnet = callPackage ../tools/networking/driftnet {};

  drone = callPackage ../development/tools/continuous-integration/drone { };

  dropbear = callPackage ../tools/networking/dropbear { };

  dtach = callPackage ../tools/misc/dtach { };

  dtc = callPackage ../development/compilers/dtc { flex = flex_2_6_1; };

  dub = callPackage ../development/tools/build-managers/dub { };

  duc = callPackage ../tools/misc/duc { };

  duff = callPackage ../tools/filesystems/duff { };

  dumptorrent = callPackage ../tools/misc/dumptorrent { };

  duo-unix = callPackage ../tools/security/duo-unix { };

  duplicity = callPackage ../tools/backup/duplicity {
    gnupg = gnupg1;
  };

  duply = callPackage ../tools/backup/duply { };

  dvdisaster = callPackage ../tools/cd-dvd/dvdisaster { };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvgrab = callPackage ../tools/video/dvgrab { };

  dvtm = callPackage ../tools/misc/dvtm {
    # if you prefer a custom config, write the config.h in dvtm.config.h
    # and enable
    # customConfig = builtins.readFile ./dvtm.config.h;
  };

  e2tools = callPackage ../tools/filesystems/e2tools { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  easyrsa = callPackage ../tools/networking/easyrsa { };

  easyrsa2 = callPackage ../tools/networking/easyrsa/2.x.nix { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  ecryptfs-helper = callPackage ../tools/security/ecryptfs/helper.nix { };

  editres = callPackage ../tools/graphics/editres { };

  edit = callPackage ../applications/editors/edit { };

  edk2 = callPackage ../development/compilers/edk2 { };

  eid-mw = callPackage ../tools/security/eid-mw { };

  eid-viewer = callPackage ../tools/security/eid-viewer { };

  ### DEVELOPMENT / EMSCRIPTEN

  buildEmscriptenPackage = callPackage ../development/em-modules/generic { };

  emscripten = callPackage ../development/compilers/emscripten { };

  emscriptenfastcomp-unwrapped = callPackage ../development/compilers/emscripten-fastcomp { };
  emscriptenfastcomp-wrapped = wrapCCWith ccWrapperFun stdenv.cc.libc ''
    # hardening flags break WASM support
    cat > $out/nix-support/add-hardening.sh
  '' emscriptenfastcomp-unwrapped;
  emscriptenfastcomp = symlinkJoin {
    name = "emscriptenfastcomp";
    paths = [ emscriptenfastcomp-wrapped emscriptenfastcomp-unwrapped ];
    preferLocalBuild = false;
    allowSubstitutes = true;
    postBuild = ''
      # replace unwrapped clang-3.9 binary by wrapper
      ln -sf $out/bin/clang $out/bin/clang-[0-9]*
    '';
  };

  emscriptenPackages = recurseIntoAttrs (callPackage ./emscripten-packages.nix { });

  emscriptenStdenv = stdenv // { mkDerivation = buildEmscriptenPackage; };

  efibootmgr = callPackage ../tools/system/efibootmgr { };

  efivar = callPackage ../tools/system/efivar { };

  evemu = callPackage ../tools/system/evemu { };

  elasticsearch = callPackage ../servers/search/elasticsearch { };
  elasticsearch2 = callPackage ../servers/search/elasticsearch/2.x.nix { };

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ../servers/search/elasticsearch/plugins.nix { }
  );

  emem = callPackage ../applications/misc/emem { };

  emv = callPackage ../tools/misc/emv { };

  enblend-enfuse = callPackage ../tools/graphics/enblend-enfuse { };

  encfs = callPackage ../tools/filesystems/encfs {
    tinyxml2 = tinyxml-2;
  };

  enscript = callPackage ../tools/text/enscript { };

  entr = callPackage ../tools/misc/entr { };

  eot_utilities = callPackage ../tools/misc/eot-utilities { };

  eplot = callPackage ../tools/graphics/eplot { };

  ethtool = callPackage ../tools/misc/ethtool { };

  ettercap = callPackage ../applications/networking/sniffers/ettercap { };

  euca2ools = callPackage ../tools/virtualization/euca2ools { };

  eventstat = callPackage ../os-specific/linux/eventstat { };

  evtest = callPackage ../applications/misc/evtest { };

  exa = callPackage ../tools/misc/exa { };

  exempi = callPackage ../development/libraries/exempi { };

  execline = callPackage ../tools/misc/execline { };

  exif = callPackage ../tools/graphics/exif { };

  exiftags = callPackage ../tools/graphics/exiftags { };

  extundelete = callPackage ../tools/filesystems/extundelete { };

  expect = callPackage ../tools/misc/expect { };

  f2fs-tools = callPackage ../tools/filesystems/f2fs-tools { };

  Fabric = python2Packages.Fabric;

  fail2ban = callPackage ../tools/security/fail2ban { };

  fakeroot = callPackage ../tools/system/fakeroot { };

  fakeroute = callPackage ../tools/networking/fakeroute { };

  fakechroot = callPackage ../tools/system/fakechroot { };

  fast-neural-doodle = callPackage ../tools/graphics/fast-neural-doodle {
    inherit (python27Packages) numpy scipy h5py scikitlearn python
      pillow;
  };

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

    m17n = callPackage ../tools/inputmethods/fcitx-engines/fcitx-m17n { };

    mozc = callPackage ../tools/inputmethods/fcitx-engines/fcitx-mozc {
      inherit (pythonPackages) gyp;
      protobuf = protobuf.override { stdenv = clangStdenv; };
    };

    table-other = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-other { };

    cloudpinyin = callPackage ../tools/inputmethods/fcitx-engines/fcitx-cloudpinyin { };

    libpinyin = callPackage ../tools/inputmethods/fcitx-engines/fcitx-libpinyin { };
  };

  fcitx-configtool = callPackage ../tools/inputmethods/fcitx/fcitx-configtool.nix { };

  fcppt = callPackage ../development/libraries/fcppt/default.nix { };

  fcrackzip = callPackage ../tools/security/fcrackzip { };

  fcron = callPackage ../tools/system/fcron { };

  fdm = callPackage ../tools/networking/fdm {};

  ferm = callPackage ../tools/networking/ferm { };

  fgallery = callPackage ../tools/graphics/fgallery {
    inherit (perlPackages) ImageExifTool JSON;
  };

  flannel = callPackage ../tools/networking/flannel { };

  flashbench = callPackage ../os-specific/linux/flashbench { };

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file { };

  filegive = callPackage ../tools/networking/filegive { };

  fileschanged = callPackage ../tools/misc/fileschanged { };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  fio = callPackage ../tools/system/fio { };

  flamerobin = callPackage ../applications/misc/flamerobin { };

  flashtool = callPackage_i686 ../development/mobile/flashtool {
    platformTools = androidenv.platformTools;
  };

  flashrom = callPackage ../tools/misc/flashrom { };

  flpsed = callPackage ../applications/editors/flpsed { };

  fluentd = callPackage ../tools/misc/fluentd { };

  flvstreamer = callPackage ../tools/networking/flvstreamer { };

  libbsd = callPackage ../development/libraries/libbsd { };

  libbladeRF = callPackage ../development/libraries/libbladeRF { };

  lp_solve = callPackage ../applications/science/math/lp_solve { };

  lprof = callPackage ../tools/graphics/lprof { };

  fatresize = callPackage ../tools/filesystems/fatresize {};

  fdk_aac = callPackage ../development/libraries/fdk-aac { };

  flameGraph = callPackage ../development/tools/flamegraph { };

  flvtool2 = callPackage ../tools/video/flvtool2 { };

  fontforge = lowPrio (callPackage ../tools/misc/fontforge {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  });
  fontforge-gtk = callPackage ../tools/misc/fontforge {
    withGTK = true;
    gtk2 = gtk2-x11;
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  fontmatrix = callPackage ../applications/graphics/fontmatrix {};

  foremost = callPackage ../tools/system/foremost { };

  forktty = callPackage ../os-specific/linux/forktty {};

  fortune = callPackage ../tools/misc/fortune { };

  fox = callPackage ../development/libraries/fox/default.nix {
    libpng = libpng12;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix { };

  fping = callPackage ../tools/networking/fping {};

  fpm = callPackage ../tools/package-management/fpm { };

  fprot = callPackage ../tools/security/fprot { };

  fprintd = callPackage ../tools/security/fprintd { };

  fprint_demo = callPackage ../tools/security/fprint_demo { };

  franz = callPackage ../applications/networking/instant-messengers/franz { };

  freeipmi = callPackage ../tools/system/freeipmi {};

  freetalk = callPackage ../applications/networking/instant-messengers/freetalk { };

  freetds = callPackage ../development/libraries/freetds { };

  frescobaldi = callPackage ../misc/frescobaldi {};

  frostwire = callPackage ../applications/networking/p2p/frostwire { };

  ftgl = callPackage ../development/libraries/ftgl { };

  ftgl212 = callPackage ../development/libraries/ftgl/2.1.2.nix { };

  ftop = callPackage ../os-specific/linux/ftop { };

  fsfs = callPackage ../tools/filesystems/fsfs { };

  fswebcam = callPackage ../os-specific/linux/fswebcam { };

  fuseiso = callPackage ../tools/filesystems/fuseiso { };

  fuse-7z-ng = callPackage ../tools/filesystems/fuse-7z-ng { };

  exfat = callPackage ../tools/filesystems/exfat { };

  dos2unix = callPackage ../tools/text/dos2unix { };

  uni2ascii = callPackage ../tools/text/uni2ascii { };

  galculator = callPackage ../applications/misc/galculator {
    gtk = gtk3;
  };

  galen = callPackage ../development/tools/galen {};

  gandi-cli = callPackage ../tools/networking/gandi-cli { };

  garmin-plugin = callPackage ../applications/misc/garmin-plugin {};

  garmintools = callPackage ../development/libraries/garmintools {};

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

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

    gazebo7-headless = callPackage ../applications/science/robotics/gazebo { withHeadless = true; };

  };

  # at present, Gazebo 7.0.0 does not match Gazebo 6.5.1 for compatibility
  gazebo = gazeboSimulator.gazebo6;

  gazebo-headless = gazeboSimulator.gazebo6-headless;

  gbdfed = callPackage ../tools/misc/gbdfed {
    gtk = gtk2-x11;
  };

  gdmap = callPackage ../tools/system/gdmap { };

  genext2fs = callPackage ../tools/filesystems/genext2fs { };

  gengetopt = callPackage ../development/tools/misc/gengetopt { };

  genimage = callPackage ../tools/filesystems/genimage { };

  geteltorito = callPackage ../tools/misc/geteltorito { };

  getmail = callPackage ../tools/networking/getmail { };

  getopt = callPackage ../tools/misc/getopt { };

  gftp = callPackage ../tools/networking/gftp { };

  ggobi = callPackage ../tools/graphics/ggobi { };

  gibo = callPackage ../tools/misc/gibo { };

  gifsicle = callPackage ../tools/graphics/gifsicle { };

  git-crecord = callPackage ../applications/version-management/git-crecord { };

  git-lfs = callPackage ../applications/version-management/git-lfs { };

  git-up = callPackage ../applications/version-management/git-up { };

  gitfs = callPackage ../tools/filesystems/gitfs { };

  gitinspector = callPackage ../applications/version-management/gitinspector { };

  gitlab = callPackage ../applications/version-management/gitlab { };

  gitlab-runner = callPackage ../development/tools/continuous-integration/gitlab-runner { };

  gitlab-shell = callPackage ../applications/version-management/gitlab-shell { };

  gitlab-workhorse = callPackage ../applications/version-management/gitlab-workhorse { };

  gitstats = callPackage ../applications/version-management/gitstats { };

  gogs = callPackage ../applications/version-management/gogs { };

  git-latexdiff = callPackage ../tools/typesetting/git-latexdiff { };

  glusterfs = callPackage ../tools/filesystems/glusterfs { };

  glmark2 = callPackage ../tools/graphics/glmark2 { };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gmvault = callPackage ../tools/networking/gmvault { };

  gnaural = callPackage ../applications/audio/gnaural {
    stdenv = overrideCC stdenv gcc49;
  };

  gnome15 = callPackage ../applications/misc/gnome15 {
    inherit (gnome2) gnome_python gnome_python_desktop;
  };

  gnokii = callPackage ../tools/misc/gnokii { };

  gnuapl = callPackage ../development/interpreters/gnu-apl { };

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
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry;
  };
  gnupg21 = callPackage ../tools/security/gnupg/21.nix {
    pinentry = if stdenv.isDarwin then pinentry_mac else pinentry;
  };
  gnupg = gnupg21;

  gnuplot = callPackage ../tools/graphics/gnuplot { qt = qt4; };

  gnuplot_qt = gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };

  gnused = callPackage ../tools/text/gnused { };
  # This is an easy work-around for [:space:] problems.
  gnused_422 = callPackage ../tools/text/gnused/422.nix { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

  goaccess = callPackage ../tools/misc/goaccess { };

  gocryptfs = callPackage ../tools/filesystems/gocrypfs { };

  godot = callPackage ../development/tools/godot {};

  go-mtpfs = callPackage ../tools/filesystems/go-mtpfs { };

  go-pup = callPackage ../development/tools/pup { };

  go-sct = callPackage ../tools/X11/go-sct { };

  # rename to upower-notify?
  go-upower-notify = callPackage ../tools/misc/upower-notify { };

  google-authenticator = callPackage ../os-specific/linux/google-authenticator { };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk { };

  google-fonts = callPackage ../data/fonts/google-fonts { };

  gource = callPackage ../applications/version-management/gource { };

  gpart = callPackage ../tools/filesystems/gpart { };

  gparted = callPackage ../tools/misc/gparted { };

  gpodder = callPackage ../applications/audio/gpodder { };

  gptfdisk = callPackage ../tools/system/gptfdisk { };

  grafx2 = callPackage ../applications/graphics/grafx2 {};

  grails = callPackage ../development/web/grails { jdk = null; };

  graylog = callPackage ../tools/misc/graylog { };

  gprof2dot = callPackage ../development/tools/profiling/gprof2dot {
    # Using pypy provides significant performance improvements (~2x)
    pythonPackages = pypyPackages;
  };

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
  graphviz_2_32 = callPackage ../tools/graphics/graphviz/2.32.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  grin = callPackage ../tools/text/grin { };
  ripgrep = callPackage ../tools/text/ripgrep { };

  grive = callPackage ../tools/filesystems/grive {
    json_c = json-c-0-11; # won't configure with 0.12; others are vulnerable
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

  groonga = callPackage ../servers/search/groonga { };

  grub = callPackage_i686 ../tools/misc/grub {
    buggyBiosCDSupport = config.grub.buggyBiosCDSupport or true;
  };

  trustedGrub = callPackage_i686 ../tools/misc/grub/trusted.nix { };

  trustedGrub-for-HP = callPackage_i686 ../tools/misc/grub/trusted.nix { for_HP_laptop = true; };

  grub2 = grub2_full;

  grub2_full = callPackage ../tools/misc/grub/2.0x.nix { };

  grub2_efi = grub2_full.override {
    efiSupport = true;
  };

  grub2_light = grub2_full.override {
    zfsSupport = false;
  };

  grub4dos = callPackage ../tools/misc/grub4dos {
    stdenv = stdenv_32bit;
  };

  gx = callPackage ../tools/package-management/gx { };
  gx-go = callPackage ../tools/package-management/gx/go { };

  sbsigntool = callPackage ../tools/security/sbsigntool { };

  gsmartcontrol = callPackage ../tools/misc/gsmartcontrol {
    inherit (gnome2) libglademm;
  };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome2) libsoup;
  };

  gt5 = callPackage ../tools/system/gt5 { };

  gtest = callPackage ../development/libraries/gtest {};
  gmock = gtest;
  gbenchmark = callPackage ../development/libraries/gbenchmark {};

  gtkdatabox = callPackage ../development/libraries/gtkdatabox {};

  gtklick = callPackage ../applications/audio/gtklick {};

  gtdialog = callPackage ../development/libraries/gtdialog {};

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gtkvnc = callPackage ../tools/admin/gtk-vnc {};

  gtmess = callPackage ../applications/networking/instant-messengers/gtmess { };

  gup = callPackage ../development/tools/build-managers/gup {};

  gupnp = callPackage ../development/libraries/gupnp {
    inherit (gnome2) libsoup;
  };

  gupnp_av = callPackage ../development/libraries/gupnp-av {};

  gupnp_igd = callPackage ../development/libraries/gupnp-igd {};

  gupnp-tools = callPackage ../tools/networking/gupnp-tools {};

  gvpe = callPackage ../tools/networking/gvpe { };

  gvolicon = callPackage ../tools/audio/gvolicon {};

  gzip = callPackage ../tools/compression/gzip { };

  gzrt = callPackage ../tools/compression/gzrt { };

  partclone = callPackage ../tools/backup/partclone { };

  partimage = callPackage ../tools/backup/partimage { };

  pgf_graphics = callPackage ../tools/graphics/pgf { };

  pigz = callPackage ../tools/compression/pigz { };

  pixz = callPackage ../tools/compression/pixz { };

  pxattr = callPackage ../tools/archivers/pxattr { };

  pxz = callPackage ../tools/compression/pxz { };

  hans = callPackage ../tools/networking/hans { };

  h2 = callPackage ../servers/h2 { };

  haproxy = callPackage ../tools/networking/haproxy { };

  haveged = callPackage ../tools/security/haveged { };

  habitat = callPackage ../applications/networking/cluster/habitat { };
  habitat-sh = callPackage ../applications/networking/cluster/habitat/chroot-env.nix { };

  hardlink = callPackage ../tools/system/hardlink { };

  hashcat = callPackage ../tools/security/hashcat { };
  hashcat3 = callPackage ../tools/security/hashcat/hashcat3 { };

  hash-slinger = callPackage ../tools/security/hash-slinger { };

  hal-flash = callPackage ../os-specific/linux/hal-flash { };

  halibut = callPackage ../tools/typesetting/halibut { };

  hardinfo = callPackage ../tools/system/hardinfo { };

  hdapsd = callPackage ../os-specific/linux/hdapsd { };

  hddtemp = callPackage ../tools/misc/hddtemp { };

  hdf5 = callPackage ../tools/misc/hdf5 {
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

  hecate = callPackage ../applications/editors/hecate { };

  heaptrack = callPackage ../development/tools/profiling/heaptrack {};

  heimdall = callPackage ../tools/misc/heimdall { };

  hevea = callPackage ../tools/typesetting/hevea { };

  hhpc = callPackage ../tools/misc/hhpc { };

  hiera-eyaml = callPackage ../tools/system/hiera-eyaml { };

  hfsprogs = callPackage ../tools/filesystems/hfsprogs { };

  highlight = callPackage ../tools/text/highlight {
    lua = lua5;
  };

  homesick = callPackage ../tools/misc/homesick { };

  honcho = callPackage ../tools/system/honcho { };

  horst = callPackage ../tools/networking/horst { };

  host = bind.host;

  hping = callPackage ../tools/networking/hping { };

  htpdate = callPackage ../tools/networking/htpdate { };

  http-prompt = callPackage ../tools/networking/http-prompt { };

  httpie = callPackage ../tools/networking/httpie { };

  httping = callPackage ../tools/networking/httping {};

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  httpstat = callPackage ../tools/networking/httpstat { };

  httptunnel = callPackage ../tools/networking/httptunnel { };

  hubicfuse = callPackage ../tools/filesystems/hubicfuse { };

  hwinfo = callPackage ../tools/system/hwinfo { };

  i2c-tools = callPackage ../os-specific/linux/i2c-tools { };

  i2p = callPackage ../tools/networking/i2p {};

  i2pd = callPackage ../tools/networking/i2pd {};

  i-score = qt5.callPackage ../applications/audio/i-score { };

  iasl = callPackage ../development/compilers/iasl { };

  iannix = qt5.callPackage ../applications/audio/iannix { };

  icecast = callPackage ../servers/icecast { };

  darkice = callPackage ../tools/audio/darkice { };

  deco = callPackage ../applications/misc/deco { };

  icoutils = callPackage ../tools/graphics/icoutils { };

  idutils = callPackage ../tools/misc/idutils { };

  idle3tools = callPackage ../tools/system/idle3tools { };

  iftop = callPackage ../tools/networking/iftop { };

  ifuse = callPackage ../tools/filesystems/ifuse/default.nix { };

  ignition = recurseIntoAttrs {

    math = callPackage ../development/libraries/ignition-math { };

    math2 = ignition.math;

    transport0 = callPackage ../development/libraries/ignition-transport/0.9.0.nix { };

    transport1 = callPackage ../development/libraries/ignition-transport/1.0.1.nix { };

    transport = ignition.transport0;
  };


  # ihaskell = callPackage ../development/tools/haskell/ihaskell/wrapper.nix {
  #   inherit (haskellPackages) ihaskell ghcWithPackages;

  #   ipython = python3.buildEnv.override {
  #     extraLibs = with python3Packages; [ ipython ipykernel jupyter_client notebook ];
  #   };

  #   packages = config.ihaskell.packages or (self: []);
  # };

  imapproxy = callPackage ../tools/networking/imapproxy { };

  imapsync = callPackage ../tools/networking/imapsync { };

  imgur-screenshot = callPackage ../tools/graphics/imgur-screenshot { };

  imgurbash2 = callPackage ../tools/graphics/imgurbash2 { };

  inadyn = callPackage ../tools/networking/inadyn { };

  inetutils = callPackage ../tools/networking/inetutils { };

  inform7 = callPackage ../development/compilers/inform7 { };

  innoextract = callPackage ../tools/archivers/innoextract { };

  intecture-agent = callPackage ../tools/admin/intecture/agent.nix { };

  intecture-auth = callPackage ../tools/admin/intecture/auth.nix { };

  intecture-cli = callPackage ../tools/admin/intecture/cli.nix { };

  ioping = callPackage ../tools/system/ioping { };

  iops = callPackage ../tools/system/iops { };

  ior = callPackage ../tools/system/ior { };

  iodine = callPackage ../tools/networking/iodine { };

  ip2location = callPackage ../tools/networking/ip2location { };

  ipad_charge = callPackage ../tools/misc/ipad_charge { };

  iperf2 = callPackage ../tools/networking/iperf/2.nix { };
  iperf3 = callPackage ../tools/networking/iperf/3.nix { };
  iperf = iperf3;

  ipfs = callPackage ../applications/networking/ipfs { };

  ipmitool = callPackage ../tools/system/ipmitool {
    static = false;
  };

  ipmiutil = callPackage ../tools/system/ipmiutil {};

  ipmiview = callPackage ../applications/misc/ipmiview {};

  ipcalc = callPackage ../tools/networking/ipcalc {};

  ipv6calc = callPackage ../tools/networking/ipv6calc {};

  ipxe = callPackage ../tools/misc/ipxe { };

  ised = callPackage ../tools/misc/ised {};

  isl = isl_0_17;
  isl_0_11 = callPackage ../development/libraries/isl/0.11.1.nix { };
  isl_0_12 = callPackage ../development/libraries/isl/0.12.2.nix { };
  isl_0_14 = callPackage ../development/libraries/isl/0.14.1.nix { };
  isl_0_15 = callPackage ../development/libraries/isl/0.15.0.nix { };
  isl_0_17 = callPackage ../development/libraries/isl/0.17.1.nix { };

  ispike = callPackage ../development/libraries/science/robotics/ispike { };

  isync = callPackage ../tools/networking/isync { };
  isyncUnstable = callPackage ../tools/networking/isync/unstable.nix { };

  jaaa = callPackage ../applications/audio/jaaa { };

  jade = callPackage ../tools/text/sgml/jade { };

  jd-gui = callPackage_i686 ../tools/security/jd-gui { };

  jdiskreport = callPackage ../tools/misc/jdiskreport { };

  jekyll = callPackage ../applications/misc/jekyll { };

  jfsutils = callPackage ../tools/filesystems/jfsutils { };

  jhead = callPackage ../tools/graphics/jhead { };

  jid = callPackage ../development/tools/jid { };

  jing = self.jing-trang;
  jing-trang = callPackage ../tools/text/xml/jing-trang { };

  jmespath = callPackage ../development/tools/jmespath { };

  jmtpfs = callPackage ../tools/filesystems/jmtpfs { };

  jnettop = callPackage ../tools/networking/jnettop { };

  john = callPackage ../tools/security/john {
    gcc = gcc49; # doesn't build with gcc5
  };

  journalbeat = callPackage ../tools/system/journalbeat { };

  jp = callPackage ../development/tools/jp { };

  jp2a = callPackage ../applications/misc/jp2a { };

  jpegoptim = callPackage ../applications/graphics/jpegoptim { };

  jpegrescan = callPackage ../applications/graphics/jpegrescan { };

  jq = callPackage ../development/tools/jq { };

  jo = callPackage ../development/tools/jo { };

  jscoverage = callPackage ../development/tools/misc/jscoverage { };

  jsduck = callPackage ../development/tools/jsduck { };

  jwhois = callPackage ../tools/networking/jwhois { };

  k2pdfopt = callPackage ../applications/misc/k2pdfopt { };

  kargo = callPackage ../tools/misc/kargo { };

  kazam = callPackage ../applications/video/kazam { };

  kalibrate-rtl = callPackage ../tools/misc/kalibrate-rtl { };

  kalibrate-hackrf = callPackage ../tools/misc/kalibrate-hackrf { };

  kakoune = callPackage ../applications/editors/kakoune { };

  kbdd = callPackage ../applications/window-managers/kbdd { };

  kdbplus = callPackage_i686 ../applications/misc/kdbplus { };

  keepalived = callPackage ../tools/networking/keepalived { };

  kexectools = callPackage ../os-specific/linux/kexectools { };

  keybase = callPackage ../tools/security/keybase { };

  kbfs = callPackage ../tools/security/kbfs { };

  keybase-gui = callPackage ../tools/security/keybase-gui { };

  keychain = callPackage ../tools/misc/keychain { };

  keyfuzz = callPackage ../tools/inputmethods/keyfuzz { };

  kibana = callPackage ../development/tools/misc/kibana { };

  kismet = callPackage ../applications/networking/sniffers/kismet { };

  klick = callPackage ../applications/audio/klick { };

  knockknock = callPackage ../tools/security/knockknock { };

  kpcli = callPackage ../tools/security/kpcli { };

  krename-qt5 = qt5.callPackage ../applications/misc/krename/kde5.nix { };

  kronometer = qt5.callPackage ../tools/misc/kronometer { };

  kdiff3-qt5 = qt5.callPackage ../tools/text/kdiff3/kde5.nix { };

  peruse = qt5.callPackage ../tools/misc/peruse { };

  kst = qt5.callPackage ../tools/graphics/kst { gsl = gsl_1; };

  kytea = callPackage ../tools/text/kytea { };

  leocad = callPackage ../applications/graphics/leocad { };

  less = callPackage ../tools/misc/less { };

  lf = callPackage ../tools/misc/lf {};

  lhasa = callPackage ../tools/compression/lhasa {};

  libcpuid = callPackage ../tools/misc/libcpuid { };

  lesspipe = callPackage ../tools/misc/lesspipe { };

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix {
    ffmpeg = ffmpeg_2;
  };

  lksctp-tools = callPackage ../os-specific/linux/lksctp-tools { };

  lnav = callPackage ../tools/misc/lnav { };

  loc = callPackage ../development/misc/loc { };

  lockfileProgs = callPackage ../tools/misc/lockfile-progs { };

  logstash = callPackage ../tools/misc/logstash { };

  logstash-contrib = callPackage ../tools/misc/logstash/contrib.nix { };

  logstash-forwarder = callPackage ../tools/misc/logstash-forwarder { };

  lolcat = callPackage ../tools/misc/lolcat { };

  lsdvd = callPackage ../tools/cd-dvd/lsdvd {};

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    lua = lua5_2_compat;
  };

  ltwheelconf = callPackage ../applications/misc/ltwheelconf { };

  kippo = callPackage ../servers/kippo { };

  kzipmix = callPackage_i686 ../tools/compression/kzipmix { };

  makebootfat = callPackage ../tools/misc/makebootfat { };

  matrix-synapse = callPackage ../servers/matrix-synapse { };

  memtester = callPackage ../tools/system/memtester { };

  minidlna = callPackage ../tools/networking/minidlna { };

  minisign = callPackage ../tools/security/minisign { };

  mmv = callPackage ../tools/misc/mmv { };

  morituri = callPackage ../applications/audio/morituri { };

  most = callPackage ../tools/misc/most { };

  motion = callPackage ../applications/video/motion { };

  mkcast = callPackage ../applications/video/mkcast { };

  multitail = callPackage ../tools/misc/multitail { };

  mxt-app = callPackage ../misc/mxt-app { };

  netdata = callPackage ../tools/system/netdata { };

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

  netperf = callPackage ../applications/networking/netperf { };

  netsniff-ng = callPackage ../tools/networking/netsniff-ng { };

  nginx-config-formatter = callPackage ../tools/misc/nginx-config-formatter { };

  ninka = callPackage ../development/tools/misc/ninka { };

  nodejs = hiPrio nodejs-6_x;

  nodejs-slim = nodejs-slim-6_x;

  nodejs-4_x = callPackage ../development/web/nodejs/v4.nix {
    libtool = darwin.cctools;
  };

  nodejs-slim-4_x = callPackage ../development/web/nodejs/v4.nix {
    libtool = darwin.cctools;
    enableNpm = false;
  };

  nodejs-6_x = callPackage ../development/web/nodejs/v6.nix {
    libtool = darwin.cctools;
  };

  nodejs-slim-6_x = callPackage ../development/web/nodejs/v6.nix {
    libtool = darwin.cctools;
    enableNpm = false;
  };

  nodejs-7_x = callPackage ../development/web/nodejs/v7.nix {
    libtool = darwin.cctools;
  };

  nodejs-slim-7_x = callPackage ../development/web/nodejs/v7.nix {
    libtool = darwin.cctools;
    enableNpm = false;
  };

  nodePackages_6_x = callPackage ../development/node-packages/default-v6.nix {
    nodejs = pkgs.nodejs-6_x;
  };

  nodePackages_4_x = callPackage ../development/node-packages/default-v4.nix {
    nodejs = pkgs.nodejs-4_x;
  };

  nodePackages = nodePackages_6_x;

  # Can be used as a user shell
  nologin = shadow;

  npm2nix = nodePackages.npm2nix;

  kea = callPackage ../tools/networking/kea { };

  kindlegen = callPackage ../tools/typesetting/kindlegen { };

  ldapvi = callPackage ../tools/misc/ldapvi { };

  ldns = callPackage ../development/libraries/ldns {
    openssl = openssl_1_1_0;
  };

  leafpad = callPackage ../applications/editors/leafpad { };

  leatherman = callPackage ../development/libraries/leatherman {
    boost = boost160;
  };

  leela = callPackage ../tools/graphics/leela { };

  lftp = callPackage ../tools/networking/lftp { };

  libconfig = callPackage ../development/libraries/libconfig { };

  libcmis = callPackage ../development/libraries/libcmis { };

  libee = callPackage ../development/libraries/libee { };

  libestr = callPackage ../development/libraries/libestr { };

  libevdev = callPackage ../development/libraries/libevdev { };

  libevhtp = callPackage ../development/libraries/libevhtp { };

  libircclient = callPackage ../development/libraries/libircclient { };

  libite = callPackage ../development/libraries/libite { };

  liboauth = callPackage ../development/libraries/liboauth { };

  libsidplayfp = callPackage ../development/libraries/libsidplayfp { };

  libsrs2 = callPackage ../development/libraries/libsrs2 { };

  libtermkey = callPackage ../development/libraries/libtermkey { };

  libtelnet = callPackage ../development/libraries/libtelnet { };

  libtirpc = callPackage ../development/libraries/ti-rpc { };

  libshout = callPackage ../development/libraries/libshout { };

  libqb = callPackage ../development/libraries/libqb { };

  libqmi = callPackage ../development/libraries/libqmi { };

  libqrencode = callPackage ../development/libraries/libqrencode { };

  libmbim = callPackage ../development/libraries/libmbim { };

  libmongo-client = callPackage ../development/libraries/libmongo-client { };

  libmesode = callPackage ../development/libraries/libmesode { };

  libnabo = callPackage ../development/libraries/libnabo { };

  libpointmatcher = callPackage ../development/libraries/libpointmatcher { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  libmpack = callPackage ../development/libraries/libmpack { };

  libiberty = callPackage ../development/libraries/libiberty { };

  libiberty_static = callPackage ../development/libraries/libiberty { staticBuild = true; };

  libibverbs = callPackage ../development/libraries/libibverbs { };

  libxcomp = callPackage ../development/libraries/libxcomp { };

  libx86emu = callPackage ../development/libraries/libx86emu { };

  libzmf = callPackage ../development/libraries/libzmf {};

  librdmacm = callPackage ../development/libraries/librdmacm { };

  libreswan = callPackage ../tools/networking/libreswan { };

  libwebsockets = callPackage ../development/libraries/libwebsockets { };

  limesurvey = callPackage ../servers/limesurvey { };

  logcheck = callPackage ../tools/system/logcheck {
    inherit (perlPackages) mimeConstruct;
  };

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

  lxc = callPackage ../os-specific/linux/lxc { };
  lxcfs = callPackage ../os-specific/linux/lxcfs { };
  lxd = callPackage ../tools/admin/lxd { };

  lzfse = callPackage ../tools/compression/lzfse { };

  lzip = callPackage ../tools/compression/lzip { };

  lzma = xz;

  xz = callPackage ../tools/compression/xz { };

  lz4 = callPackage ../tools/compression/lz4 { };

  lzop = callPackage ../tools/compression/lzop { };

  macchanger = callPackage ../os-specific/linux/macchanger { };

  mailcheck = callPackage ../applications/networking/mailreaders/mailcheck { };

  maildrop = callPackage ../tools/networking/maildrop { };

  mailnag = callPackage ../applications/networking/mailreaders/mailnag { };

  mailsend = callPackage ../tools/networking/mailsend { };

  mailpile = callPackage ../applications/networking/mailreaders/mailpile { };

  mailutils = callPackage ../tools/networking/mailutils {
    sasl = gsasl;
  };

  email = callPackage ../tools/networking/email { };

  maim = callPackage ../tools/graphics/maim {};

  mairix = callPackage ../tools/text/mairix { };

  makemkv = callPackage ../applications/video/makemkv { };

  makerpm = callPackage ../development/tools/makerpm { };

  # See https://github.com/NixOS/nixpkgs/issues/15849. I'm switching on isLinux because
  # it looks like gnulib is broken on non-linux, so it seems likely that this would cause
  # trouble on bsd and/or cygwin as well.
  man = if stdenv.isLinux then man-db else man-old;

  man-old = callPackage ../tools/misc/man { };

  man-db = callPackage ../tools/misc/man-db { };

  mandoc = callPackage ../tools/misc/mandoc { };

  mawk = callPackage ../tools/text/mawk { };

  mbox = callPackage ../tools/security/mbox { };

  mbuffer = callPackage ../tools/misc/mbuffer { };

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

  memtest86plus = callPackage ../tools/misc/memtest86+ {
    stdenv = overrideCC stdenv gcc5;
  };

  meo = callPackage ../tools/security/meo {
    boost = boost155;
  };

  mc = callPackage ../tools/misc/mc { };

  mcabber = callPackage ../applications/networking/instant-messengers/mcabber { };

  mcron = callPackage ../tools/system/mcron {
    guile = guile_1_8;
  };

  mdbtools = callPackage ../tools/misc/mdbtools { };

  mdbtools_git = callPackage ../tools/misc/mdbtools/git.nix {
    inherit (gnome2) scrollkeeper;
  };

  mdk = callPackage ../development/tools/mdk { };

  mdp = callPackage ../applications/misc/mdp { };

  mednafen = callPackage ../misc/emulators/mednafen { };

  mednafen-server = callPackage ../misc/emulators/mednafen/server.nix { };

  mednaffe = callPackage ../misc/emulators/mednaffe/default.nix { };

  megacli = callPackage ../tools/misc/megacli { };

  megatools = callPackage ../tools/networking/megatools { };

  metamorphose2 = callPackage ../applications/misc/metamorphose2 { };

  mfcuk = callPackage ../tools/security/mfcuk { };

  mfoc = callPackage ../tools/security/mfoc { };

  mgba = qt5.callPackage ../misc/emulators/mgba { };

  mimeo = callPackage ../tools/misc/mimeo { };

  mimetic = callPackage ../development/libraries/mimetic { };

  minio-client = callPackage ../tools/networking/minio-client { };

  minissdpd = callPackage ../tools/networking/minissdpd { };

  miniupnpc = callPackage ../tools/networking/miniupnpc { };

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  miniball = callPackage ../development/libraries/miniball { };

  minixml = callPackage ../development/libraries/minixml { };

  mir-qualia = callPackage ../tools/text/mir-qualia {
    pythonPackages = python3Packages;
  };

  miredo = callPackage ../tools/networking/miredo { };

  mitmproxy = callPackage ../tools/networking/mitmproxy { };

  mjpegtoolsFull = callPackage ../tools/video/mjpegtools { };

  mjpegtools = self.mjpegtoolsFull.override {
    withMinimal = true;
  };

  mkcue = callPackage ../tools/cd-dvd/mkcue { };

  mkpasswd = hiPrio (callPackage ../tools/security/mkpasswd { });

  mkrand = callPackage ../tools/security/mkrand { };

  mktemp = callPackage ../tools/security/mktemp { };

  mktorrent = callPackage ../tools/misc/mktorrent { };

  modemmanager = callPackage ../tools/networking/modemmanager {};

  modsecurity_standalone = callPackage ../tools/security/modsecurity { };

  molly-guard = callPackage ../os-specific/linux/molly-guard { };

  monit = callPackage ../tools/system/monit { };

  moreutils = callPackage ../tools/misc/moreutils {
    inherit (perlPackages) IPCRun TimeDate TimeDuration;
    docbook-xsl = docbook_xsl;
  };

  mosh = callPackage ../tools/networking/mosh {
    inherit (perlPackages) IOTty;
  };

  motuclient = callPackage ../applications/science/misc/motu-client { };

  mpage = callPackage ../tools/text/mpage { };

  mprime = callPackage ../tools/misc/mprime { };

  mpw = callPackage ../tools/security/mpw { };

  mr = callPackage ../applications/version-management/mr { };

  mrtg = callPackage ../tools/misc/mrtg { };

  mscgen = callPackage ../tools/graphics/mscgen { };

  msf = callPackage ../tools/security/metasploit { };

  ms-sys = callPackage ../tools/misc/ms-sys { };

  mtdutils = callPackage ../tools/filesystems/mtdutils { };

  mtools = callPackage ../tools/filesystems/mtools { };

  mtr = callPackage ../tools/networking/mtr {};

  mtx = callPackage ../tools/backup/mtx {};

  mt-st = callPackage ../tools/backup/mt-st {};

  multitran = recurseIntoAttrs (let callPackage = newScope pkgs.multitran; in rec {
    multitrandata = callPackage ../tools/text/multitran/data { };

    libbtree = callPackage ../tools/text/multitran/libbtree { };

    libmtsupport = callPackage ../tools/text/multitran/libmtsupport { };

    libfacet = callPackage ../tools/text/multitran/libfacet { };

    libmtquery = callPackage ../tools/text/multitran/libmtquery { };

    mtutils = callPackage ../tools/text/multitran/mtutils { };
  });

  munge = callPackage ../tools/security/munge { };

  mysql2pgsql = callPackage ../tools/misc/mysql2pgsql { };

  mysqltuner = callPackage ../tools/misc/mysqltuner { };

  nabi = callPackage ../tools/inputmethods/nabi { };

  namazu = callPackage ../tools/text/namazu { };

  nasty = callPackage ../tools/security/nasty { };

  nbd = callPackage ../tools/networking/nbd { };

  ndjbdns = callPackage ../tools/networking/ndjbdns { };

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

  neural-style = callPackage ../tools/graphics/neural-style {};

  nco = callPackage ../development/libraries/nco { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  ndisc6 = callPackage ../tools/networking/ndisc6 { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = netcat-openbsd;

  netcat-gnu = callPackage ../tools/networking/netcat-gnu { };

  netcat-openbsd = callPackage ../tools/networking/netcat-openbsd { };

  nethogs = callPackage ../tools/networking/nethogs { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netrw = callPackage ../tools/networking/netrw { };

  netselect = callPackage ../tools/networking/netselect { };

  # stripped down, needed by steam
  networkmanager098 = callPackage ../tools/networking/network-manager/0.9.8 { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager_openvpn = callPackage ../tools/networking/network-manager/openvpn.nix { };

  networkmanager_pptp = callPackage ../tools/networking/network-manager/pptp.nix { };

  networkmanager_l2tp = callPackage ../tools/networking/network-manager/l2tp.nix { };

  networkmanager_vpnc = callPackage ../tools/networking/network-manager/vpnc.nix { };

  networkmanager_openconnect = callPackage ../tools/networking/network-manager/openconnect.nix { };

  networkmanager_strongswan = callPackage ../tools/networking/network-manager/strongswan.nix { };

  networkmanagerapplet = newScope gnome2 ../tools/networking/network-manager-applet { };

  newsbeuter = callPackage ../applications/networking/feedreaders/newsbeuter { };

  newsbeuter-dev = callPackage ../applications/networking/feedreaders/newsbeuter/dev.nix { };

  nextcloud = callPackage ../servers/nextcloud { };

  nextcloud-news-updater = callPackage ../servers/nextcloud/news-updater.nix { };

  ngrep = callPackage ../tools/networking/ngrep { };

  ngrok = callPackage ../tools/networking/ngrok { };

  noip = callPackage ../tools/networking/noip { };

  nomad = callPackage ../applications/networking/cluster/nomad { };

  milu = callPackage ../applications/misc/milu { };

  mpack = callPackage ../tools/networking/mpack { };

  pa_applet = callPackage ../tools/audio/pa-applet { };

  pasystray = callPackage ../tools/audio/pasystray { };

  pnmixer = callPackage ../tools/audio/pnmixer { };

  pwsafe = callPackage ../applications/misc/pwsafe {
    wxGTK = wxGTK30;
  };

  nifskope = callPackage ../tools/graphics/nifskope { };

  nilfs-utils = callPackage ../tools/filesystems/nilfs-utils {};
  nilfs_utils = nilfs-utils;

  nitrogen = callPackage ../tools/X11/nitrogen {};

  nixbot = callPackage ../tools/misc/nixbot {};

  nkf = callPackage ../tools/text/nkf {};

  nlopt = callPackage ../development/libraries/nlopt {};

  npapi_sdk = callPackage ../development/libraries/npapi-sdk {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap { };

  nmap-graphical = callPackage ../tools/security/nmap {
    graphicalSupport = true;
  };

  notify-osd = callPackage ../applications/misc/notify-osd { };

  nox = callPackage ../tools/package-management/nox {
    pythonPackages = python3Packages;
  };

  nq = callPackage ../tools/system/nq { };

  nsjail = callPackage ../tools/security/nsjail {};

  nss_pam_ldapd = callPackage ../tools/networking/nss-pam-ldapd {};

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntfy = pythonPackages.ntfy;

  ntopng = callPackage ../tools/networking/ntopng { };

  ntp = callPackage ../tools/networking/ntp {
    libcap = if stdenv.isLinux then libcap else null;
  };

  numdiff = callPackage ../tools/text/numdiff { };

  numlockx = callPackage ../tools/X11/numlockx { };

  nuttcp = callPackage ../tools/networking/nuttcp { };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nwdiag = pythonPackages.nwdiag;

  nylon = callPackage ../tools/networking/nylon { };

  nxproxy = callPackage ../tools/admin/nxproxy { };

  nzbget = callPackage ../tools/networking/nzbget { };

  oathToolkit = callPackage ../tools/security/oath-toolkit { };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  obexd = callPackage ../tools/bluetooth/obexd { };

  ocproxy = callPackage ../tools/networking/ocproxy { };

  openfortivpn = callPackage ../tools/networking/openfortivpn { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  objconv = callPackage ../development/tools/misc/objconv {};

  obnam = callPackage ../tools/backup/obnam { };

  odpdown = callPackage ../tools/typesetting/odpdown { };

  odt2txt = callPackage ../tools/text/odt2txt { };

  offlineimap = callPackage ../tools/networking/offlineimap { };

  oh-my-zsh = callPackage ../shells/oh-my-zsh { };

  opencc = callPackage ../tools/text/opencc { };

  opencl-info = callPackage ../tools/system/opencl-info { };

  opencryptoki = callPackage ../tools/security/opencryptoki { };

  opendbx = callPackage ../development/libraries/opendbx { };

  opendkim = callPackage ../development/libraries/opendkim { };

  opendylan = callPackage ../development/compilers/opendylan {
    opendylan-bootstrap = opendylan_bin;
  };

  opendylan_bin = callPackage ../development/compilers/opendylan/bin.nix { };

  openjade = callPackage ../tools/text/sgml/openjade { };

  openntpd = callPackage ../tools/networking/openntpd { };

  openntpd_nixos = openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  openobex = callPackage ../tools/bluetooth/openobex { };

  openopc = callPackage ../tools/misc/openopc { };

  openresolv = callPackage ../tools/networking/openresolv { };

  opensc = callPackage ../tools/security/opensc { };

  openssh =
    callPackage ../tools/networking/openssh {
      hpnSupport = false;
      withKerberos = stdenv.isDarwin;
      etcDir = "/etc/ssh";
      pam = if stdenv.isLinux then pam else null;
    };

  openssh_hpn = pkgs.appendToName "with-hpn" (openssh.override { hpnSupport = true; });

  openssh_with_kerberos = pkgs.appendToName "with-kerberos" (openssh.override { withKerberos = true; });

  opensp = callPackage ../tools/text/sgml/opensp { };

  spCompat = callPackage ../tools/text/sgml/opensp/compat.nix { };

  opentracker = callPackage ../applications/networking/p2p/opentracker { };

  opentsdb = callPackage ../tools/misc/opentsdb {};

  openvpn = callPackage ../tools/networking/openvpn { };

  openvpn_learnaddress = callPackage ../tools/networking/openvpn/openvpn_learnaddress.nix { };

  update-resolv-conf = callPackage ../tools/networking/openvpn/update-resolv-conf.nix { };

  open-pdf-presenter = callPackage ../applications/misc/open-pdf-presenter { };

  openvswitch = callPackage ../os-specific/linux/openvswitch { };

  optipng = callPackage ../tools/graphics/optipng {
    libpng = libpng12;
  };

  olsrd = callPackage ../tools/networking/olsrd { };

  os-prober = callPackage ../tools/misc/os-prober {};

  ossec = callPackage ../tools/security/ossec {};

  ostree = callPackage ../tools/misc/ostree { };

  otpw = callPackage ../os-specific/linux/otpw { };

  owncloud = owncloud70;

  inherit (callPackages ../servers/owncloud { })
    owncloud705
    owncloud70
    owncloud80
    owncloud81
    owncloud82
    owncloud90
    owncloud91;

  owncloud-client = callPackage ../applications/networking/owncloud-client { };

  p2pvc = callPackage ../applications/video/p2pvc {};

  p7zip = callPackage ../tools/archivers/p7zip { };

  packagekit = callPackage ../tools/package-management/packagekit {
    nix = nixUnstable;
  };

  pakcs = callPackage ../development/compilers/pakcs {};

  pal = callPackage ../tools/misc/pal { };

  pandoc = haskell.lib.overrideCabal haskellPackages.pandoc (drv: {
    configureFlags = drv.configureFlags or [] ++ ["-fembed_data_files"];
    buildTools = drv.buildTools or [] ++ [haskellPackages.hsb2hs];
    enableSharedExecutables = false;
    enableSharedLibraries = false;
    isLibrary = false;
    doHaddock = false;
    postFixup = "rm -rf $out/lib $out/nix-support $out/share";
  });

  panomatic = callPackage ../tools/graphics/panomatic { };

  pamtester = callPackage ../tools/security/pamtester { };

  paper-gtk-theme = callPackage ../misc/themes/paper { };

  paperwork = callPackage ../applications/office/paperwork { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  parcellite = callPackage ../tools/misc/parcellite { };

  patchutils = callPackage ../tools/text/patchutils { };

  parted = callPackage ../tools/misc/parted { hurd = null; };

  pell = callPackage ../applications/misc/pell { };

  pick = callPackage ../tools/misc/pick { };

  pitivi = callPackage ../applications/video/pitivi {
    gst = gst_all_1 //
      { gst-plugins-bad = gst_all_1.gst-plugins-bad.overrideDerivation
          (attrs: { nativeBuildInputs = attrs.nativeBuildInputs ++ [ gtk3 ];
                    # Fix this build error in ./tests/examples/waylandsink:
                    #   main.c:28:2: error: #error "Wayland is not supported in GTK+"
                    configureFlags = attrs.configureFlags or "" + "--enable-wayland=no";
                  });
      };
  };

  p0f = callPackage ../tools/security/p0f { };

  pngout = callPackage ../tools/graphics/pngout { };

  hurdPartedCross =
    if targetPlatform != buildPlatform && targetPlatform.config == "i586-pc-gnu"
    then (makeOverridable
            ({ hurd }:
              (parted.override {
                # Needs the Hurd's libstore.
                inherit hurd;

                # The Hurd wants a libparted.a.
                enableStatic = true;

                gettext = null;
                readline = null;
                devicemapper = null;
              }).crossDrv)
           { hurd = gnu.hurdCrossIntermediate; })
    else null;

  ipsecTools = callPackage ../os-specific/linux/ipsec-tools { flex = flex_2_5_35; };

  patch = gnupatch;

  patchage = callPackage ../applications/audio/patchage { };

  pcapfix = callPackage ../tools/networking/pcapfix { };

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite {
    inherit (darwin.apple_sdk.frameworks) IOKit;
  };

  pcsctools = callPackage ../tools/security/pcsctools {
    inherit (perlPackages) pcscperl Glib Gtk2 Pango Cairo;
  };

  pcsc-cyberjack = callPackage ../tools/security/pcsc-cyberjack { };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdf2htmlEX = callPackage ../tools/typesetting/pdf2htmlEX { };

  pdf2odt = callPackage ../tools/typesetting/pdf2odt { };

  pdf2svg = callPackage ../tools/graphics/pdf2svg { };

  pdfmod = callPackage ../applications/misc/pdfmod { };

  jbig2enc = callPackage ../tools/graphics/jbig2enc { };

  pdfread = callPackage ../tools/graphics/pdfread {
    inherit (pythonPackages) pillow;
  };

  briss = callPackage ../tools/graphics/briss { };

  brickd = callPackage ../servers/brickd {
    libusb = libusb1;
  };

  bully = callPackage ../tools/networking/bully { };

  pcapc = callPackage ../tools/networking/pcapc { };

  pdnsd = callPackage ../tools/networking/pdnsd { };

  peco = callPackage ../tools/text/peco { };

  pg_top = callPackage ../tools/misc/pg_top { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = callPackage ../tools/graphics/pfstools { };

  philter = callPackage ../tools/networking/philter { };

  pinentry = callPackage ../tools/security/pinentry {
    libcap = if stdenv.isDarwin then null else libcap;
    qt4 = null;
  };

  pinentry_ncurses = pinentry.override {
    gtk2 = null;
  };

  pinentry_qt4 = pinentry_ncurses.override {
    inherit qt4;
  };

  pinentry_qt5 = qt5.callPackage ../tools/security/pinentry/qt5.nix {
    libcap = if stdenv.isDarwin then null else libcap;
  };

  pinentry_mac = callPackage ../tools/security/pinentry-mac { };

  pingtcp = callPackage ../tools/networking/pingtcp { };

  pius = callPackage ../tools/security/pius { };

  pixiewps = callPackage ../tools/networking/pixiewps {};

  pk2cmd = callPackage ../tools/misc/pk2cmd { };

  plantuml = callPackage ../tools/misc/plantuml { };

  plan9port = callPackage ../tools/system/plan9port { };

  platformioPackages = callPackage ../development/arduino/platformio { };
  platformio = platformioPackages.platformio-chrootenv.override {};

  platinum-searcher = callPackage ../tools/text/platinum-searcher { };

  plex = callPackage ../servers/plex { enablePlexPass = config.plex.enablePlexPass or false; };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  plotutils = callPackage ../tools/graphics/plotutils { };

  plowshare = callPackage ../tools/misc/plowshare { };

  pngcheck = callPackage ../tools/graphics/pngcheck {
    zlib = zlibStatic;
  };

  pngcrush = callPackage ../tools/graphics/pngcrush { };

  pngnq = callPackage ../tools/graphics/pngnq { };

  pngtoico = callPackage ../tools/graphics/pngtoico {
    libpng = libpng12;
  };

  pngpp = callPackage ../development/libraries/png++ { };

  pngquant = callPackage ../tools/graphics/pngquant { };

  podiff = callPackage ../tools/text/podiff { };

  pod2mdoc = callPackage ../tools/misc/pod2mdoc { };

  poedit = callPackage ../tools/text/poedit { };

  polipo = callPackage ../servers/polipo { };

  polkit_gnome = callPackage ../tools/security/polkit-gnome { };

  polysh = callPackage ../tools/networking/polysh { };

  ponysay = callPackage ../tools/misc/ponysay { };

  popfile = callPackage ../tools/text/popfile { };

  postscript-lexmark = callPackage ../misc/drivers/postscript-lexmark { };

  povray = callPackage ../tools/graphics/povray {
    automake = automake113x; # fails with 14
  };

  ppl = callPackage ../development/libraries/ppl { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  pptpd = callPackage ../tools/networking/pptpd {};

  prey-bash-client = callPackage ../tools/security/prey { };

  profile-cleaner = callPackage ../tools/misc/profile-cleaner { };

  profile-sync-daemon = callPackage ../tools/misc/profile-sync-daemon { };

  projectm = callPackage ../applications/audio/projectm { };

  proot = callPackage ../tools/system/proot { };

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel { };

  pws = callPackage ../tools/misc/pws { };

  cntlm = callPackage ../tools/networking/cntlm { };

  pastebinit = callPackage ../tools/misc/pastebinit { };

  polygraph = callPackage ../tools/networking/polygraph { };

  progress = callPackage ../tools/misc/progress { };

  ps3netsrv = callPackage ../servers/ps3netsrv { };

  psi = callPackage ../applications/networking/instant-messengers/psi { };

  psmisc = callPackage ../os-specific/linux/psmisc { };

  pssh = callPackage ../tools/networking/pssh { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  psutils = callPackage ../tools/typesetting/psutils { };

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pwnat = callPackage ../tools/networking/pwnat { };

  pycangjie = pythonPackages.pycangjie;

  pydb = callPackage ../development/tools/pydb { };

  pygmentex = callPackage ../tools/typesetting/pygmentex { };

  pythonIRClib = pythonPackages.pythonIRClib;

  pythonSexy = pythonPackages.libsexy;

  pytrainer = callPackage ../applications/misc/pytrainer { };

  remarshal = callPackage ../development/tools/remarshal { };

  rtaudio = callPackage ../development/libraries/audio/rtaudio { };

  rtmidi = callPackage ../development/libraries/audio/rtmidi { };

  openmpi = callPackage ../development/libraries/openmpi { };

  openmodelica = callPackage ../applications/science/misc/openmodelica { };

  qarte = callPackage ../applications/video/qarte { };

  qnial = callPackage ../development/interpreters/qnial {};

  ocz-ssd-guru = callPackage ../tools/misc/ocz-ssd-guru { };

  qalculate-gtk = callPackage ../applications/science/math/qalculate-gtk { };

  qastools = qt5.callPackage ../tools/audio/qastools { };

  qesteidutil = qt5.callPackage ../tools/security/qesteidutil { } ;
  qdigidoc = qt5.callPackage ../tools/security/qdigidoc { } ;
  esteidfirefoxplugin = callPackage ../applications/networking/browsers/mozilla-plugins/esteidfirefoxplugin { };


  qgifer = callPackage ../applications/video/qgifer {
    giflib = giflib_4_1;
  };

  qhull = callPackage ../development/libraries/qhull { };

  qjoypad = callPackage ../tools/misc/qjoypad { };

  qpdf = callPackage ../development/libraries/qpdf { };

  qprint = callPackage ../tools/text/qprint { };

  qscintilla = callPackage ../development/libraries/qscintilla { };

  qshowdiff = callPackage ../tools/text/qshowdiff { };

  qtikz = callPackage ../applications/graphics/ktikz { };

  quicktun = callPackage ../tools/networking/quicktun { };

  quilt = callPackage ../development/tools/quilt { };

  radamsa = callPackage ../tools/security/radamsa { };

  radvd = callPackage ../tools/networking/radvd { };

  rambox = callPackage ../applications/networking/instant-messengers/rambox { };

  ranger = callPackage ../applications/misc/ranger { };

  rarcrack = callPackage ../tools/security/rarcrack { };

  ratools = callPackage ../tools/networking/ratools { };

  rawdog = callPackage ../applications/networking/feedreaders/rawdog { };

  rc = callPackage ../shells/rc { };

  read-edid = callPackage ../os-specific/linux/read-edid { };

  redir = callPackage ../tools/networking/redir { };

  redmine = callPackage ../applications/version-management/redmine { };

  redsocks = callPackage ../tools/networking/redsocks { };

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

  recutils = callPackage ../tools/misc/recutils { };

  recoll = callPackage ../applications/search/recoll { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome2) gnome_vfs GConf;
  };

  remarkjs = callPackage ../development/web/remarkjs { };

  alarm-clock-applet = callPackage ../tools/misc/alarm-clock-applet { };

  remind = callPackage ../tools/misc/remind { };

  remmina = callPackage ../applications/networking/remote/remmina {
    adwaita-icon-theme = gnome3.adwaita-icon-theme;
    gsettings_desktop_schemas = gnome3.gsettings_desktop_schemas;
  };

  renameutils = callPackage ../tools/misc/renameutils { };

  replace = callPackage ../tools/text/replace { };

  reckon = callPackage ../tools/text/reckon { };

  reposurgeon = callPackage ../applications/version-management/reposurgeon { };

  reptyr = callPackage ../os-specific/linux/reptyr {};

  rescuetime = callPackage ../applications/misc/rescuetime { };

  rewritefs = callPackage ../os-specific/linux/rewritefs { };

  rdiff-backup = callPackage ../tools/backup/rdiff-backup { };

  rdfind = callPackage ../tools/filesystems/rdfind { };

  rdmd = callPackage ../development/compilers/rdmd { };

  rhash = callPackage ../tools/security/rhash { };

  riemann_c_client = callPackage ../tools/misc/riemann-c-client { };
  riemann-tools = callPackage ../tools/misc/riemann-tools { };

  ripmime = callPackage ../tools/networking/ripmime {};

  rkflashtool = callPackage ../tools/misc/rkflashtool { };

  rkrlv2 = callPackage ../applications/audio/rkrlv2 {};

  rmlint = callPackage ../tools/misc/rmlint {
    inherit (pythonPackages) sphinx;
  };

  rng_tools = callPackage ../tools/security/rng-tools { };

  rq = callPackage ../development/tools/rq {
    v8 = v8_static;
  };

  rsnapshot = callPackage ../tools/backup/rsnapshot {
    # For the `logger' command, we can use either `utillinux' or
    # GNU Inetutils.  The latter is more portable.
    logger = if stdenv.isLinux then utillinux else inetutils;
  };

  rlwrap = callPackage ../tools/misc/rlwrap { };

  rockbox_utility = callPackage ../tools/misc/rockbox-utility { };

  rosegarden = callPackage ../applications/audio/rosegarden { };

  rowhammer-test = callPackage ../tools/system/rowhammer-test { };

  rpPPPoE = callPackage ../tools/networking/rp-pppoe { };

  rpm = callPackage ../tools/package-management/rpm { };

  rpm-ostree = callPackage ../tools/misc/rpm-ostree {
    gperf = gperf_3_0;
  };

  rpmextract = callPackage ../tools/archivers/rpmextract { };

  rrdtool = callPackage ../tools/misc/rrdtool { };

  rsstail = callPackage ../applications/networking/feedreaders/rsstail { };

  rtorrent = callPackage ../tools/networking/p2p/rtorrent { };

  rubber = callPackage ../tools/typesetting/rubber { };

  rubocop = callPackage ../development/tools/rubocop { };

  runningx = callPackage ../tools/X11/runningx { };

  runzip = callPackage ../tools/archivers/runzip { };

  rxp = callPackage ../tools/text/xml/rxp { };

  rzip = callPackage ../tools/compression/rzip { };

  s3backer = callPackage ../tools/filesystems/s3backer { };

  s3fs = callPackage ../tools/filesystems/s3fs { };

  s3cmd = callPackage ../tools/networking/s3cmd { };

  s3gof3r = callPackage ../tools/networking/s3gof3r { };

  s6Dns = callPackage ../tools/networking/s6-dns { };

  s6LinuxUtils = callPackage ../os-specific/linux/s6-linux-utils { };

  s6Networking = callPackage ../tools/networking/s6-networking { };

  s6PortableUtils = callPackage ../tools/misc/s6-portable-utils { };

  sablotron = callPackage ../tools/text/xml/sablotron { };

  safecopy = callPackage ../tools/system/safecopy { };

  safe-rm = callPackage ../tools/system/safe-rm { };

  salt = callPackage ../tools/admin/salt {};

  salut_a_toi = callPackage ../applications/networking/instant-messengers/salut-a-toi {};

  samplicator = callPackage ../tools/networking/samplicator { };

  scanbd = callPackage ../tools/graphics/scanbd { };

  screen = callPackage ../tools/misc/screen {
    inherit (darwin.apple_sdk.libs) utmp;
  };

  screen-message = callPackage ../tools/X11/screen-message { };

  screencloud = callPackage ../applications/graphics/screencloud {
    quazip = quazip_qt4;
  };

  quazip_qt4 = self.qt5.quazip.override { qt = qt4; qmakeHook = qmake4Hook; };

  scrot = callPackage ../tools/graphics/scrot { };

  scrypt = callPackage ../tools/security/scrypt { };

  sdcv = callPackage ../applications/misc/sdcv { };

  sdl-jstest = callPackage ../tools/misc/sdl-jstest { };

  sec = callPackage ../tools/admin/sec { };

  seccure = callPackage ../tools/security/seccure { };

  secp256k1 = callPackage ../tools/security/secp256k1 { };

  securefs = callPackage ../tools/filesystems/securefs { };

  setroot = callPackage  ../tools/X11/setroot { };

  setserial = callPackage ../tools/system/setserial { };

  seqdiag = pythonPackages.seqdiag;

  screenfetch = callPackage ../tools/misc/screenfetch { };

  sg3_utils = callPackage ../tools/system/sg3_utils { };

  shadowsocks-libev = callPackage ../tools/networking/shadowsocks-libev { };

  sharutils = callPackage ../tools/archivers/sharutils { };

  shotwell = callPackage ../applications/graphics/shotwell { };

  shout = callPackage ../applications/networking/irc/shout { };

  shellinabox = callPackage ../servers/shellinabox { };

  sic = callPackage ../applications/networking/irc/sic { };

  siege = callPackage ../tools/networking/siege {};

  sigil = qt55.callPackage ../applications/editors/sigil { };

  # aka., gpg-tools
  signing-party = callPackage ../tools/security/signing-party { };

  silc_client = callPackage ../applications/networking/instant-messengers/silc-client { };

  silc_server = callPackage ../servers/silc-server { };

  sile = callPackage ../tools/typesetting/sile {
  inherit (lua52Packages) lua luaexpat luazlib luafilesystem lpeg;
  };

  silver-searcher = callPackage ../tools/text/silver-searcher { };
  ag = self.silver-searcher;

  simplescreenrecorder = callPackage ../applications/video/simplescreenrecorder { };

  sipsak = callPackage ../tools/networking/sipsak { };

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  skippy-xd = callPackage ../tools/X11/skippy-xd {};

  sks = callPackage ../servers/sks { inherit (ocamlPackages) ocaml camlp4; };

  skydns = callPackage ../servers/skydns { };

  sipcalc = callPackage ../tools/networking/sipcalc { };

  sleuthkit = callPackage ../tools/system/sleuthkit {};

  slimrat = callPackage ../tools/networking/slimrat {
    inherit (perlPackages) WWWMechanize LWP;
  };

  slsnif = callPackage ../tools/misc/slsnif { };

  smartmontools = callPackage ../tools/system/smartmontools {
    inherit (darwin.apple_sdk.frameworks) IOKit ApplicationServices;
  };

  smbldaptools = callPackage ../tools/networking/smbldaptools {
    inherit (perlPackages) NetLDAP CryptSmbHash DigestSHA1;
  };

  smbnetfs = callPackage ../tools/filesystems/smbnetfs {};

  smugline = python3Packages.smugline;

  snabb = callPackage ../tools/networking/snabb { } ;

  sng = callPackage ../tools/graphics/sng {
    libpng = libpng12;
  };

  snort = callPackage ../applications/networking/ids/snort { };

  softhsm = callPackage ../tools/security/softhsm { };

  solr = callPackage ../servers/search/solr { };

  solvespace = callPackage ../applications/graphics/solvespace { };

  sonarr = callPackage ../servers/sonarr { };

  sonata = callPackage ../applications/audio/sonata { };

  souper = callPackage ../development/compilers/souper { };

  sparsehash = callPackage ../development/libraries/sparsehash { };

  spiped = callPackage ../tools/networking/spiped { };

  sqliteman = callPackage ../applications/misc/sqliteman { };

  stdman = callPackage ../data/documentation/stdman { };

  storebrowse = callPackage ../tools/system/storebrowse { };

  syntex = callPackage ../tools/graphics/syntex {};

  fusesmb = callPackage ../tools/filesystems/fusesmb { samba = samba3; };

  sl = callPackage ../tools/misc/sl { };

  socat = callPackage ../tools/networking/socat { };

  socat2pre = lowPrio (callPackage ../tools/networking/socat/2.x.nix { });

  solaar = callPackage ../applications/misc/solaar {};

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  spaceFM = callPackage ../applications/misc/spacefm { adwaita-icon-theme = gnome3.adwaita-icon-theme; };

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  sshfs-fuse = callPackage ../tools/filesystems/sshfs-fuse { };

  sshuttle = callPackage ../tools/security/sshuttle { };

  ssldump = callPackage ../tools/networking/ssldump { };

  sstp = callPackage ../tools/networking/sstp {};

  su-exec = callPackage ../tools/security/su-exec {};

  subsurface = qt5.callPackage ../applications/misc/subsurface { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = callPackage ../tools/system/suid-chroot { };

  sundtek = callPackage ../misc/drivers/sundtek { };

  sunxi-tools = callPackage ../development/tools/sunxi-tools { };

  super = callPackage ../tools/security/super { };

  supertux-editor = callPackage ../applications/editors/supertux-editor { };

  super-user-spark = haskellPackages.callPackage ../applications/misc/super_user_spark { };

  ssdeep = callPackage ../tools/security/ssdeep { };

  ssh-ident = callPackage ../tools/networking/ssh-ident { };

  sshpass = callPackage ../tools/networking/sshpass { };

  sslscan = callPackage ../tools/security/sslscan {
    openssl = openssl_1_0_2.override { enableSSL2 = true; };
  };

  sslmate = callPackage ../development/tools/sslmate { };

  ssmtp = callPackage ../tools/networking/ssmtp {
    tlsSupport = true;
  };

  ssss = callPackage ../tools/security/ssss { };

  stress = callPackage ../tools/system/stress { };

  stress-ng = callPackage ../tools/system/stress-ng { };

  stoken = callPackage ../tools/security/stoken {
    withGTK3 = config.stoken.withGTK3 or true;
  };

  storeBackup = callPackage ../tools/backup/store-backup { };

  stow = callPackage ../tools/misc/stow { };

  stun = callPackage ../tools/networking/stun { };

  stunnel = callPackage ../tools/networking/stunnel { };

  strongswan = callPackage ../tools/networking/strongswan { };

  strongswanTNC = callPackage ../tools/networking/strongswan { enableTNC=true; };

  su = shadow.su;

  subsonic = callPackage ../servers/misc/subsonic { };

  surfraw = callPackage ../tools/networking/surfraw { };

  swec = callPackage ../tools/networking/swec {
    inherit (perlPackages) LWP URI HTMLParser HTTPServerSimple Parent;
  };

  svnfs = callPackage ../tools/filesystems/svnfs { };

  svtplay-dl = callPackage ../tools/misc/svtplay-dl { };

  sysbench = callPackage ../development/tools/misc/sysbench {};

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    libxml2 = libxml2Python;
    pythonPackages = python3Packages;
   };

  sitecopy = callPackage ../tools/networking/sitecopy { };

  stricat = callPackage ../tools/security/stricat { };

  staruml = callPackage ../tools/misc/staruml { inherit (gnome2) GConf; libgcrypt = libgcrypt_1_5; };

  privoxy = callPackage ../tools/networking/privoxy {
    w3m = w3m-batch;
  };

  swaks = callPackage ../tools/networking/swaks { };

  swiften = callPackage ../development/libraries/swiften { };

  t = callPackage ../tools/misc/t { };

  t1utils = callPackage ../tools/misc/t1utils { };

  talkfilters = callPackage ../misc/talkfilters {};

  znapzend = callPackage ../tools/backup/znapzend { };

  tarsnap = callPackage ../tools/backup/tarsnap { };

  tcpcrypt = callPackage ../tools/security/tcpcrypt { };

  tboot = callPackage ../tools/security/tboot { };

  tcpdump = callPackage ../tools/networking/tcpdump { };

  tcpflow = callPackage ../tools/networking/tcpflow { };

  tcpkali = callPackage ../applications/networking/tcpkali { };

  teamviewer = callPackage ../applications/networking/remote/teamviewer {
    stdenv = stdenv_32bit;
  };

  telnet = callPackage ../tools/networking/telnet { };

  telegraf = callPackage ../servers/monitoring/telegraf { };

  texmacs = callPackage ../applications/editors/texmacs {
    tex = texlive.combined.scheme-small;
    extraFonts = true;
  };

  texmaker = callPackage ../applications/editors/texmaker { };

  texstudio = callPackage ../applications/editors/texstudio { };

  textadept = callPackage ../applications/editors/textadept { };

  thc-hydra = callPackage ../tools/security/thc-hydra { };

  thin-provisioning-tools = callPackage ../tools/misc/thin-provisioning-tools {  };

  tiled = qt5.callPackage ../applications/editors/tiled { };

  timemachine = callPackage ../applications/audio/timemachine { };

  timetrap = callPackage ../applications/office/timetrap { };

  tinc = callPackage ../tools/networking/tinc { };

  tie = callPackage ../development/tools/misc/tie { };

  tinc_pre = callPackage ../tools/networking/tinc/pre.nix { };

  tiny8086 = callPackage ../applications/virtualization/8086tiny { };

  tlsdate = callPackage ../tools/networking/tlsdate { };

  tldr = callPackage ../tools/misc/tldr { };

  tmate = callPackage ../tools/misc/tmate { };

  tmpwatch = callPackage ../tools/misc/tmpwatch  { };

  tmux = callPackage ../tools/misc/tmux { };

  tmux-cssh = callPackage ../tools/misc/tmux-cssh { };

  tmuxp = callPackage ../tools/misc/tmuxp { };

  tmuxinator = callPackage ../tools/misc/tmuxinator { };

  tmin = callPackage ../tools/security/tmin { };

  tmsu = callPackage ../tools/filesystems/tmsu { };

  toilet = callPackage ../tools/misc/toilet { };

  tokei = callPackage ../development/tools/misc/tokei { };

  tor = callPackage ../tools/security/tor { };

  tor-arm = callPackage ../tools/security/tor/tor-arm.nix { };

  torbrowser = callPackage ../tools/security/tor/torbrowser.nix {
    inherit (xorg) libXrender libX11 libXext libXt;
  };

  touchegg = callPackage ../tools/inputmethods/touchegg { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  toxvpn = callPackage ../tools/networking/toxvpn { };

  tpmmanager = callPackage ../applications/misc/tpmmanager { };

  tpm-quote-tools = callPackage ../tools/security/tpm-quote-tools { };

  tpm-tools = callPackage ../tools/security/tpm-tools { };

  tpm-luks = callPackage ../tools/security/tpm-luks { };

  trezord = callPackage ../servers/trezord { };

  tthsum = callPackage ../applications/misc/tthsum { };

  chaps = callPackage ../tools/security/chaps { };

  trace-cmd = callPackage ../os-specific/linux/trace-cmd { };

  traceroute = callPackage ../tools/networking/traceroute { };

  tracebox = callPackage ../tools/networking/tracebox { };

  tracefilegen = callPackage ../development/tools/analysis/garcosim/tracefilegen { };

  tracefilesim = callPackage ../development/tools/analysis/garcosim/tracefilesim { };

  translate-shell = callPackage ../applications/misc/translate-shell { };

  trash-cli = callPackage ../tools/misc/trash-cli { };

  trickle = callPackage ../tools/networking/trickle {};

  trousers = callPackage ../tools/security/trousers { };

  tryton = callPackage ../applications/office/tryton { };

  omapd = callPackage ../tools/security/omapd { };

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ttfautohint = callPackage ../tools/misc/ttfautohint { };

  tty-clock = callPackage ../tools/misc/tty-clock { };

  ttyrec = callPackage ../tools/misc/ttyrec { };

  ttylog = callPackage ../tools/misc/ttylog { };

  twitterBootstrap = callPackage ../development/web/twitter-bootstrap {};
  twitterBootstrap3 = callPackage ../development/web/twitter-bootstrap/v3.nix {};

  txt2man = callPackage ../tools/misc/txt2man { };

  txt2tags = callPackage ../tools/text/txt2tags { };

  txtw = callPackage ../tools/misc/txtw { };

  u9fs = callPackage ../servers/u9fs { };

  ucl = callPackage ../development/libraries/ucl { };

  ucspi-tcp = callPackage ../tools/networking/ucspi-tcp { };

  udftools = callPackage ../tools/filesystems/udftools {};

  udpt = callPackage ../servers/udpt { };

  udptunnel = callPackage ../tools/networking/udptunnel { };

  ufraw = callPackage ../applications/graphics/ufraw { };

  uget = callPackage ../tools/networking/uget { };

  uif2iso = callPackage ../tools/cd-dvd/uif2iso { };

  umlet = callPackage ../tools/misc/umlet { };

  unetbootin = callPackage ../tools/cd-dvd/unetbootin { };

  unfs3 = callPackage ../servers/unfs3 { };

  unoconv = callPackage ../tools/text/unoconv { };

  unrtf = callPackage ../tools/text/unrtf { };

  untex = callPackage ../tools/text/untex { };

  upx = callPackage ../tools/compression/upx { };

  uriparser = callPackage ../development/libraries/uriparser {};

  urlview = callPackage ../applications/misc/urlview {};

  usbmuxd = callPackage ../tools/misc/usbmuxd {};

  uwsgi = callPackage ../servers/uwsgi {
    plugins = [];
    withPAM = stdenv.isLinux;
    withSystemd = stdenv.isLinux;
  };

  vacuum = callPackage ../applications/networking/instant-messengers/vacuum {};

  volatility = callPackage ../tools/security/volatility { };

  vidalia = callPackage ../tools/security/vidalia { };

  vbetool = callPackage ../tools/system/vbetool { };

  vde2 = callPackage ../tools/networking/vde2 { };

  vboot_reference = callPackage ../tools/system/vboot_reference { };

  vcsh = callPackage ../applications/version-management/vcsh { };

  verilator = callPackage ../applications/science/electronics/verilator {};

  verilog = callPackage ../applications/science/electronics/verilog {};

  vfdecrypt = callPackage ../tools/misc/vfdecrypt { };

  vifm = callPackage ../applications/misc/vifm { };

  viking = callPackage ../applications/misc/viking {
    inherit (gnome2) scrollkeeper;
    inherit (gnome3) gexiv2;
  };

  vit = callPackage ../applications/misc/vit { };

  vnc2flv = callPackage ../tools/video/vnc2flv {};

  vncrec = callPackage ../tools/video/vncrec { };

  vobcopy = callPackage ../tools/cd-dvd/vobcopy { };

  vobsub2srt = callPackage ../tools/cd-dvd/vobsub2srt { };

  vorbisgain = callPackage ../tools/misc/vorbisgain { };

  vpnc = callPackage ../tools/networking/vpnc { };

  vp = callPackage ../applications/misc/vp {
    # Enable next line for console graphics. Note that
    # it requires `sixel` enabled terminals such as mlterm
    # or xterm -ti 340
    SDL = SDL_sixel;
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

  vtun = callPackage ../tools/networking/vtun { };

  wakatime = callPackage ../tools/misc/wakatime { };

  weather = callPackage ../applications/misc/weather { };

  wego = callPackage ../applications/misc/wego { };

  wal_e = callPackage ../tools/backup/wal-e { };

  watchman = callPackage ../development/tools/watchman { };

  wavefunctioncollapse = callPackage ../tools/graphics/wavefunctioncollapse {};

  wbox = callPackage ../tools/networking/wbox {};

  welkin = callPackage ../tools/graphics/welkin {};

  whois = callPackage ../tools/networking/whois { };

  wsmancli = callPackage ../tools/system/wsmancli {};

  wolfebin = callPackage ../tools/networking/wolfebin {
    python = python2;
  };

  xautoclick = callPackage ../applications/misc/xautoclick {};

  xl2tpd = callPackage ../tools/networking/xl2tpd { };

  xe = callPackage ../tools/system/xe { };

  testdisk = callPackage ../tools/misc/testdisk { };

  textql = callPackage ../development/tools/textql { };

  html2text = callPackage ../tools/text/html2text { };

  html-tidy = callPackage ../tools/text/html-tidy { };

  html-xml-utils = callPackage ../tools/text/xml/html-xml-utils { };

  rcm = callPackage ../tools/misc/rcm {};

  tftp-hpa = callPackage ../tools/networking/tftp-hpa {};

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
    fltk = fltk13;
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = callPackage ../tools/misc/time { };

  tkabber = callPackage ../applications/networking/instant-messengers/tkabber { };

  qfsm = callPackage ../applications/science/electronics/qfsm { };

  tkgate = callPackage ../applications/science/electronics/tkgate/1.x.nix { };

  tm = callPackage ../tools/system/tm { };

  tradcpp = callPackage ../development/tools/tradcpp { };

  trang = self.jing-trang;

  tre = callPackage ../development/libraries/tre { };

  ts = callPackage ../tools/system/ts { };

  transfig = callPackage ../tools/graphics/transfig {
    libpng = libpng12;
  };

  truecrypt = callPackage ../applications/misc/truecrypt {
    stdenv = overrideInStdenv stdenv [ useOldCXXAbi ];
    wxGUI = config.truecrypt.wxGUI or true;
  };

  ttmkfdir = callPackage ../tools/misc/ttmkfdir { };

  udunits = callPackage ../development/libraries/udunits { };

  uemacs = callPackage ../applications/editors/uemacs { };

  uftp = callPackage ../servers/uftp { };

  uhttpmock = callPackage ../development/libraries/uhttpmock { };

  uim = callPackage ../tools/inputmethods/uim {
    inherit (pkgs.kde4) kdelibs;
  };

  uhub = callPackage ../servers/uhub { };

  unclutter = callPackage ../tools/misc/unclutter { };

  unclutter-xfixes = callPackage ../tools/misc/unclutter-xfixes { };

  unbound = callPackage ../tools/networking/unbound { };

  units = callPackage ../tools/misc/units { };

  unittest-cpp = callPackage ../development/libraries/unittest-cpp { };

  unrar = callPackage ../tools/archivers/unrar { };

  xar = callPackage ../tools/compression/xar { };

  xarchive = callPackage ../tools/archivers/xarchive { };

  xarchiver = callPackage ../tools/archivers/xarchiver { };

  xbanish = callPackage ../tools/X11/xbanish { };

  xbrightness = callPackage ../tools/X11/xbrightness { };

  xfstests = callPackage ../tools/misc/xfstests { };

  xprintidle-ng = callPackage ../tools/X11/xprintidle-ng {};

  xsettingsd = callPackage ../tools/X11/xsettingsd { };

  xsensors = callPackage ../os-specific/linux/xsensors { };

  xcruiser = callPackage ../applications/misc/xcruiser { };

  xxkb = callPackage ../applications/misc/xxkb { };

  ugarit = callPackage ../tools/backup/ugarit { };

  ugarit-manifest-maker = callPackage ../tools/backup/ugarit-manifest-maker { };

  unar = callPackage ../tools/archivers/unar { stdenv = clangStdenv; };

  unarj = callPackage ../tools/archivers/unarj { };

  unshield = callPackage ../tools/archivers/unshield { };

  unzip = callPackage ../tools/archivers/unzip { };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  undmg = callPackage ../tools/archivers/undmg { };

  uptimed = callPackage ../tools/system/uptimed { };

  urjtag = callPackage ../tools/misc/urjtag {
    svfSupport = true;
    bsdlSupport = true;
    staplSupport = true;
    jedecSupport = true;
  };

  urlwatch = callPackage ../tools/networking/urlwatch { };

  valum = callPackage ../development/web/valum {
    inherit (gnome3) libgee;
  };

  varnish = callPackage ../servers/varnish { };

  venus = callPackage ../tools/misc/venus {
    python = python27;
  };

  vlan = callPackage ../tools/networking/vlan { };

  vmtouch = callPackage ../tools/misc/vmtouch { };

  volumeicon = callPackage ../tools/audio/volumeicon { };

  waf = callPackage ../development/tools/build-managers/waf { };

  wakelan = callPackage ../tools/networking/wakelan { };

  wavemon = callPackage ../tools/networking/wavemon { };

  wdfs = callPackage ../tools/filesystems/wdfs { };

  wdiff = callPackage ../tools/text/wdiff { };

  webalizer = callPackage ../tools/networking/webalizer { };

  weighttp = callPackage ../tools/networking/weighttp { };

  wget = callPackage ../tools/networking/wget {
    inherit (perlPackages) IOSocketSSL LWP;
    libpsl = null;
  };

  which = callPackage ../tools/system/which { };

  chase = callPackage ../tools/system/chase { };

  wicd = callPackage ../tools/networking/wicd { };

  wipe = callPackage ../tools/security/wipe { };

  wkhtmltopdf = callPackage ../tools/graphics/wkhtmltopdf {
    overrideDerivation = lib.overrideDerivation;
  };

  wml = callPackage ../development/web/wml { };

  wol = callPackage ../tools/networking/wol { };

  wring = nodePackages.wring;

  wrk = callPackage ../tools/networking/wrk { };

  wuzz = callPackage ../tools/networking/wuzz { };

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

  inherit (ocamlPackages) wyrd;

  x86info = callPackage ../os-specific/linux/x86info { };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = assert stdenv ? glibc; callPackage ../tools/misc/xburst-tools {
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross =
      let
        pkgsCross = nixpkgsFun {
          # Ben Nanonote system
          crossSystem = {
            config = "mipsel-unknown-linux";
            bigEndian = true;
            arch = "mips";
            float = "soft";
            withTLS = true;
            libc = "uclibc";
            platform = {
              name = "ben_nanonote";
              kernelMajor = "2.6";
              # It's not a bcm47xx processor, but for the headers this should work
              kernelHeadersBaseConfig = "bcm47xx_defconfig";
              kernelArch = "mips";
            };
            gcc = {
              arch = "mips32";
            };
          };
        };
      in
        pkgsCross.gccCrossStageStatic;
  };

  xclip = callPackage ../tools/misc/xclip { };

  xtitle = callPackage ../tools/misc/xtitle { };

  xdelta = callPackage ../tools/compression/xdelta { };
  xdeltaUnstable = callPackage ../tools/compression/xdelta/unstable.nix { };

  xdummy = callPackage ../tools/misc/xdummy { };

  xdxf2slob = callPackage ../tools/misc/xdxf2slob { };

  xe-guest-utilities = callPackage ../tools/virtualization/xe-guest-utilities { };

  xflux = callPackage ../tools/misc/xflux { };
  xflux-gui = callPackage ../tools/misc/xflux/gui.nix {
    gnome_python = gnome2.gnome_python;
  };

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { };
  libxfs = xfsprogs.dev; # outputs TODO

  xml2 = callPackage ../tools/text/xml/xml2 { };

  xmlroff = callPackage ../tools/typesetting/xmlroff { };

  xmlstarlet = callPackage ../tools/text/xml/xmlstarlet { };

  xmlto = callPackage ../tools/typesetting/xmlto {
    w3m = w3m-batch;
  };

  xmpppy = pythonPackages.xmpppy;

  xiccd = callPackage ../tools/misc/xiccd { };

  xorriso = callPackage ../tools/cd-dvd/xorriso { };

  xpf = callPackage ../tools/text/xml/xpf {
    libxml2 = libxml2Python;
  };

  xsel = callPackage ../tools/misc/xsel { };

  xtreemfs = callPackage ../tools/filesystems/xtreemfs {};

  xurls = callPackage ../tools/text/xurls {};

  xvfb_run = callPackage ../tools/misc/xvfb-run { inherit (texFunctions) fontsConf; };

  xvkbd = callPackage ../tools/X11/xvkbd {};

  xwinmosaic = callPackage ../tools/X11/xwinmosaic {};

  yaft = callPackage ../applications/misc/yaft { };

  yarn = callPackage ../development/tools/yarn  { };

  yank = callPackage ../tools/misc/yank { };

  yaml-merge = callPackage ../tools/text/yaml-merge { };

  yeshup = callPackage ../tools/system/yeshup { };

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix { };

  yle-dl = callPackage ../tools/misc/yle-dl {};

  zbackup = callPackage ../tools/backup/zbackup {};

  zbar = callPackage ../tools/graphics/zbar { };

  zdelta = callPackage ../tools/compression/zdelta { };

  zerotierone = callPackage ../tools/networking/zerotierone { };

  zerofree = callPackage ../tools/filesystems/zerofree { };

  zfstools = callPackage ../tools/filesystems/zfstools { };

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

  zsh-navigation-tools = callPackage ../tools/misc/zsh-navigation-tools { };

  zsh-syntax-highlighting = callPackage ../shells/zsh-syntax-highlighting { };

  zsh-autosuggestions = callPackage ../shells/zsh-autosuggestions { };

  zstd = callPackage ../tools/compression/zstd { };

  zsync = callPackage ../tools/compression/zsync { };

  zxing = callPackage ../tools/graphics/zxing {};


  ### SHELLS

  bash = lowPrio (callPackage ../shells/bash/4.4.nix {
    texinfo = null;
    interactive = stdenv.isCygwin; # patch for cygwin requires readline support
  });

  bashInteractive = appendToName "interactive" (callPackage ../shells/bash/4.4.nix {
    interactive = true;
  });

  bash-completion = callPackage ../shells/bash-completion { };

  dash = callPackage ../shells/dash { };

  es = callPackage ../shells/es { };

  fish = callPackage ../shells/fish { };

  fish-foreign-env = callPackage ../shells/fish-foreign-env { };

  mksh = callPackage ../shells/mksh { };

  oh = callPackage ../shells/oh { };

  pash = callPackage ../shells/pash { };

  tcsh = callPackage ../shells/tcsh { };

  rssh = callPackage ../shells/rssh { };

  rush = callPackage ../shells/rush { };

  xonsh = callPackage ../shells/xonsh { };

  zsh = callPackage ../shells/zsh { };

  nix-zsh-completions = callPackage ../shells/nix-zsh-completions { };

  zsh-completions = callPackage ../shells/zsh-completions { };

  zsh-prezto = callPackage ../shells/zsh-prezto { };

  grml-zsh-config = callPackage ../shells/grml-zsh-config { };


  ### DEVELOPMENT / COMPILERS

  abcl = callPackage ../development/compilers/abcl {};

  aldor = callPackage ../development/compilers/aldor { };

  aliceml = callPackage ../development/compilers/aliceml { };

  arachne-pnr = callPackage ../development/compilers/arachne-pnr { };

  asn1c = callPackage ../development/compilers/asn1c { };

  aspectj = callPackage ../development/compilers/aspectj { };

  ats = callPackage ../development/compilers/ats { };
  ats2 = callPackage ../development/compilers/ats2 { };

  avra = callPackage ../development/compilers/avra { };

  avian = callPackage ../development/compilers/avian {
    stdenv = overrideCC stdenv gcc49;
  };

  bigloo = callPackage ../development/compilers/bigloo {
    stdenv = overrideCC stdenv gcc49;
  };

  boo = callPackage ../development/compilers/boo {
    inherit (gnome2) gtksourceview;
  };

  colm = callPackage ../development/compilers/colm { };

  fetchegg = callPackage ../build-support/fetchegg { };

  eggDerivation = callPackage ../development/compilers/chicken/eggDerivation.nix { };

  chicken = callPackage ../development/compilers/chicken {
    bootstrap-chicken = chicken.override { bootstrap-chicken = null; };
  };

  egg2nix = callPackage ../development/tools/egg2nix {
    chickenEggs = callPackage ../development/tools/egg2nix/chicken-eggs.nix { };
  };

  ccl = callPackage ../development/compilers/ccl { };

  chez = callPackage ../development/compilers/chez { };

  clang = llvmPackages.clang;

  clang_39 = llvmPackages_39.clang;
  clang_38 = llvmPackages_38.clang;
  clang_37 = llvmPackages_37.clang;
  clang_35 = wrapCC llvmPackages_35.clang;
  clang_34 = wrapCC llvmPackages_34.clang;

  clang-tools = callPackage ../development/tools/clang-tools { };

  clang-analyzer = callPackage ../development/tools/analysis/clang-analyzer { };

  clangUnwrapped = llvm: pkg: callPackage pkg { inherit llvm; };

  clangSelf = clangWrapSelf llvmPackagesSelf.clang;

  clangWrapSelf = build: callPackage ../build-support/cc-wrapper {
    cc = build;
    isClang = true;
    stdenv = clangStdenv;
    libc = glibc;
    extraPackages = [ libcxx libcxxabi ];
    nativeTools = false;
    nativeLibc = false;
  };

  #Use this instead of stdenv to build with clang
  clangStdenv = if stdenv.isDarwin then stdenv else lowPrio llvmPackages.stdenv;
  libcxxStdenv = lowPrio llvmPackages.libcxxStdenv;

  clean = callPackage ../development/compilers/clean { };

  closurecompiler = callPackage ../development/compilers/closure { };

  cmdstan = callPackage ../development/compilers/cmdstan { };

  cmucl_binary = callPackage_i686 ../development/compilers/cmucl/binary.nix { };

  inherit (ocaml-ng.ocamlPackages_4_02) compcert;

  # Users installing via `nix-env` will likely be using the REPL,
  # which has a hard dependency on Z3, so make sure it is available.
  cryptol = haskellPackages.cryptol.overrideDerivation (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or []) ++ [ makeWrapper ];
    installPhase = (oldAttrs.installPhase or "") + ''
      wrapProgram $out/bin/cryptol \
        --prefix 'PATH' ':' "${lib.getBin z3}/bin"
    '';
  });

  crystal = callPackage ../development/compilers/crystal { };

  devpi-client = callPackage ../development/tools/devpi-client {};

  drumstick = callPackage ../development/libraries/drumstick { };

  ecl = callPackage ../development/compilers/ecl { };
  ecl_16_1_2 = callPackage ../development/compilers/ecl/16.1.2.nix { };

  eql = callPackage ../development/compilers/eql {};

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  adobe_flex_sdk = callPackage ../development/compilers/adobe-flex-sdk { };

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { };

  gcc = gcc5;
  gcc-unwrapped = gcc.cc;

  wrapCCMulti = cc:
    if system == "x86_64-linux" then lowPrio (
      let
        extraBuildCommands = ''
          echo "dontMoveLib64=1" >> $out/nix-support/setup-hook
        '';
      in wrapCCWith (callPackage ../build-support/cc-wrapper) glibc_multi extraBuildCommands (cc.cc.override {
        stdenv = overrideCC stdenv (wrapCCWith (callPackage ../build-support/cc-wrapper) glibc_multi "" cc.cc);
        profiledCompiler = false;
        enableMultilib = true;
      }))
    else throw "Multilib ${cc.name} not supported on ‘${system}’";

  gcc_multi = wrapCCMulti gcc;

  gcc_debug = lowPrio (wrapCC (gcc.cc.override {
    stripped = false;
  }));

  gccApple = throw "gccApple is no longer supported";

  gccCrossStageStatic = assert targetPlatform != buildPlatform; let
    libcCross1 =
      if stdenv.cross.libc == "msvcrt" then windows.mingw_w64_headers
      else if stdenv.cross.libc == "libSystem" then darwin.xcode
      else null;
    in wrapGCCCross {
      gcc = forcedNativePackages.gcc.cc.override {
        cross = targetPlatform;
        crossStageStatic = true;
        langCC = false;
        libcCross = libcCross1;
        enableShared = false;
        # Why is this needed?
        inherit (forcedNativePackages) binutilsCross;
      };
      libc = libcCross1;
      binutils = binutilsCross;
      cross = targetPlatform;
  };

  # Only needed for mingw builds
  gccCrossMingw2 = assert targetPlatform != buildPlatform; wrapGCCCross {
    gcc = gccCrossStageStatic.gcc;
    libc = windows.mingw_headers2;
    binutils = binutilsCross;
    cross = targetPlatform;
  };

  gccCrossStageFinal = assert targetPlatform != buildPlatform; wrapGCCCross {
    gcc = forcedNativePackages.gcc.cc.override {
      cross = targetPlatform;
      crossStageStatic = false;

      # XXX: We have troubles cross-compiling libstdc++ on MinGW (see
      # <http://hydra.nixos.org/build/4268232>), so don't even try.
      langCC = targetPlatform.config != "i686-pc-mingw32";
      # Why is this needed?
      inherit (forcedNativePackages) binutilsCross;
    };
    libc = libcCross;
    binutils = binutilsCross;
    cross = targetPlatform;
  };

  gcc45 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.5 {
    inherit noSysDirs;
    texinfo = texinfo4;

    ppl = null;
    cloogppl = null;

    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = !stdenv.isArm;

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if targetPlatform != buildPlatform then libcCross else null;
  }));

  gcc48 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isSunOS && !isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if targetPlatform != buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
    cloog = if !stdenv.isDarwin then cloog else null;
    texinfo = texinfo5; # doesn't validate since 6.1 -> 6.3 bump
  }));

  gcc49 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.9 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if targetPlatform != buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_11 else null;

    cloog = if !stdenv.isDarwin then cloog_0_18_0 else null;
  }));

  gcc5 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/5 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if targetPlatform != buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gcc6 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/6 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if targetPlatform != buildPlatform then libcCross else null;

    isl = if !stdenv.isDarwin then isl_0_14 else null;
  }));

  gfortran = if !stdenv.isDarwin then gfortran5
             else callPackage ../development/compilers/gcc/gfortran-darwin.nix {
    inherit (darwin) Libsystem;
  };

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

  gcj = gcj49;
  gcj49 = wrapCC (gcc49.cc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig perl;
    inherit (gnome2) libart_lgpl;
  });

  gnat = gnat45; # failed to make 4.6 or 4.8 build

  gnat45 = wrapCC (gcc45.cc.override {
    name = "gnat";
    langCC = false;
    langC = true;
    langAda = true;
    profiledCompiler = false;
    inherit gnatboot;
    # We can't use the ppl stuff, because we would have
    # libstdc++ problems.
    cloogppl = null;
    ppl = null;
  });

  gnatboot = wrapGCC-old (callPackage ../development/compilers/gnatboot {});

  gnu-smalltalk = callPackage ../development/compilers/gnu-smalltalk {
    emacsSupport = config.emacsSupport or false;
  };

  gccgo = gccgo49;

  gccgo49 = wrapCC (gcc49.cc.override {
    name = "gccgo49";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
    profiledCompiler = false;
  });

  ghdl_mcode = callPackage_i686 ../development/compilers/ghdl {
    flavour = "mcode";
  };

  ghdl_llvm = callPackage ../development/compilers/ghdl {
    flavour = "llvm";
  };

  gcl = callPackage ../development/compilers/gcl {
    gmp = gmp4;
  };

  gcl_2_6_13_pre = callPackage ../development/compilers/gcl/2.6.13-pre.nix { };

  gcc-arm-embedded-4_7 = callPackage_i686 ../development/compilers/gcc-arm-embedded {
    version = "4.7-2013q3-20130916";
    releaseType = "update";
    sha256 = "1bd9bi9q80xn2rpy0rn1vvj70rh15kb7dmah0qs4q2rv78fqj40d";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-4_8 = callPackage_i686 ../development/compilers/gcc-arm-embedded {
    version = "4.8-2014q1-20140314";
    releaseType = "update";
    sha256 = "ce92859550819d4a3d1a6e2672ea64882b30afa2c08cf67fa8e1d93788c2c577";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-4_9 = callPackage_i686 ../development/compilers/gcc-arm-embedded {
    version = "4.9-2015q1-20150306";
    releaseType = "update";
    sha256 = "c5e0025b065750bbd76b5357b4fc8606d88afbac9ff55b8a82927b4b96178154";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded-5 = pkgs.callPackage_i686 ../development/compilers/gcc-arm-embedded {
    dirName = "5.0";
    subdirName = "5-2016-q2-update";
    version = "5.4-2016q2-20160622";
    releaseType = "update";
    sha256 = "1r0rqbnw7rf94f5bsa3gi8bick4xb7qnp1dkvdjfbvqjvysvc44r";
    ncurses = pkgsi686Linux.ncurses5;
  };
  gcc-arm-embedded = gcc-arm-embedded-5;

  gforth = callPackage ../development/compilers/gforth {};

  gtk-server = callPackage ../development/interpreters/gtk-server {};

  # Haskell and GHC

  haskell = callPackage ./haskell-packages.nix { };

  haskellPackages = haskell.packages.ghc802.override {
    overrides = config.haskellPackageOverrides or (self: super: {});
  };

  inherit (haskellPackages) ghc;

  cabal-install = haskell.lib.disableSharedExecutables haskellPackages.cabal-install;

  stack = haskell.lib.overrideCabal haskellPackages.stack (drv: {
    enableSharedExecutables = false;
    isLibrary = false;
    doHaddock = false;
    postFixup = "rm -rf $out/lib $out/nix-support $out/share/doc";
  });

  all-cabal-hashes = callPackage ../data/misc/hackage/default.nix { };

  inherit (ocamlPackages) haxe;

  hxcpp = callPackage ../development/compilers/haxe/hxcpp.nix { };

  hhvm = callPackage ../development/compilers/hhvm {
    boost = boost160;
  };

  hop = callPackage ../development/compilers/hop { };

  falcon = callPackage ../development/interpreters/falcon { };

  fsharp = callPackage ../development/compilers/fsharp { };

  fstar = callPackage ../development/compilers/fstar {
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix {});

  glslang = callPackage ../development/compilers/glslang { };

  go_bootstrap = callPackage ../development/compilers/go/1.4.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  go_1_6 = callPackage ../development/compilers/go/1.6.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go_1_7 = callPackage ../development/compilers/go/1.7.nix ({
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  } // stdenv.lib.optionalAttrs stdenv.isDarwin {
    stdenv = stdenvAdapters.overrideCC pkgs.stdenv pkgs.clang_38;
  });

  go = go_1_7;

  go-repo-root = callPackage ../development/tools/go-repo-root { };

  gox = callPackage ../development/tools/gox { };

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  icedtea7_web = callPackage ../development/compilers/icedtea-web {
    jdk = jdk7;
  };

  icedtea8_web = callPackage ../development/compilers/icedtea-web {
    jdk = jdk8;
  };

  icedtea_web = icedtea8_web;

  idrisPackages = callPackage ../development/idris-modules {
    inherit (haskellPackages) idris;
  };

  ikarus = callPackage ../development/compilers/ikarus { };

  intercal = callPackage ../development/compilers/intercal {
    flex = flex_2_6_1; # Works with 2.5.35 too, but not 2.6.3
  };

  irony-server = callPackage ../development/tools/irony-server/default.nix {
    # The repository of irony to use -- must match the version of the employed emacs
    # package.  Wishing we could merge it into one irony package, to avoid this issue,
    # but its emacs-side expression is autogenerated, and we can't hook into it (other
    # than peek into its version).
    inherit (emacsPackagesNg.melpaStablePackages) irony;
  };

  hugs = callPackage ../development/interpreters/hugs { };

  openjdk7 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk-darwin { }
    else
      callPackage ../development/compilers/openjdk/7.nix {
        bootjdk = callPackage ../development/compilers/openjdk/bootstrap.nix { version = "7"; };
      };

  openjdk8 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk-darwin/8.nix { }
    else
      callPackage ../development/compilers/openjdk/8.nix {
        bootjdk = callPackage ../development/compilers/openjdk/bootstrap.nix { version = "8"; };
        inherit (gnome2) GConf gnome_vfs;
      };

  openjdk = if stdenv.isDarwin then openjdk7 else openjdk8;

  jdk7 = openjdk7 // { outputs = [ "out" ]; };
  jre7 = lib.setName "openjre-${lib.getVersion pkgs.openjdk7.jre}"
    (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
      (openjdk7.jre // { outputs = [ "jre" ]; }));

  jdk8 = openjdk8 // { outputs = [ "out" ]; };
  jre8 = lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}"
    (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
      (openjdk8.jre // { outputs = [ "jre" ]; }));
  jre8_headless =
    if stdenv.isDarwin then jre8 else
      lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}-headless"
        (lib.addMetaAttrs { outputsToInstall = [ "jre" ]; }
          ((openjdk8.override { minimal = true; }).jre // { outputs = [ "jre" ]; }));

  jdk = if stdenv.isDarwin then jdk7 else jdk8;
  jre = if stdenv.isDarwin then jre7 else jre8;
  jre_headless = if stdenv.isDarwin then jre7 else jre8_headless;

  openshot-qt = callPackage ../applications/video/openshot-qt { };

  oraclejdk = pkgs.jdkdistro true false;

  oraclejdk8 = pkgs.oraclejdk8distro true false;

  oraclejdk8psu = pkgs.oraclejdk8psu_distro true false;

  oraclejre = lowPrio (pkgs.jdkdistro false false);

  oraclejre8 = lowPrio (pkgs.oraclejdk8distro false false);

  oraclejre8psu = lowPrio (pkgs.oraclejdk8psu_distro false false);

  jrePlugin = jre8Plugin;

  jre8Plugin = lowPrio (pkgs.oraclejdk8distro false true);

  supportsJDK =
    system == "i686-linux" ||
    system == "x86_64-linux";

  jdkdistro = oraclejdk8distro;

  oraclejdk8distro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8cpu-linux.nix { inherit installjdk; });

  oraclejdk8psu_distro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8psu-linux.nix { inherit installjdk; });

  jikes = callPackage ../development/compilers/jikes { };

  julia = callPackage ../development/compilers/julia {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
    llvm = llvm_37;
  };

  julia_05 = callPackage ../development/compilers/julia/0.5.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
    llvm = llvm_38;
  };

  julia-git = lowPrio (callPackage ../development/compilers/julia/git.nix {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
    llvm = llvm_39;
  });

  kotlin = callPackage ../development/compilers/kotlin { };

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lessc = callPackage ../development/compilers/lessc { };

  liquibase = callPackage ../development/tools/database/liquibase { };

  lizardfs = callPackage ../tools/filesystems/lizardfs { };

  lldb = llvmPackages.lldb;

  llvm = llvmPackages.llvm;

  llvm_39 = llvmPackages_39.llvm;
  llvm_38 = llvmPackages_38.llvm;
  llvm_37 = llvmPackages_37.llvm;
  llvm_35 = llvmPackages_35.llvm;
  llvm_34 = llvmPackages_34.llvm;

  llvmPackages = recurseIntoAttrs
    (if stdenv.isDarwin then llvmPackages_37 else llvmPackages_39);

  llvmPackagesSelf = llvmPackages_34.override {
    stdenv = libcxxStdenv;
  };

  llvmPackages_34 = callPackage ../development/compilers/llvm/3.4 {
    isl = isl_0_12;
  };

  llvmPackages_35 = callPackage ../development/compilers/llvm/3.5 {
    isl = isl_0_14;
  };

  llvmPackages_37 = callPackage ../development/compilers/llvm/3.7 ({
    inherit (stdenvAdapters) overrideCC;
  } // stdenv.lib.optionalAttrs stdenv.isDarwin {
    cmake = cmake.override { isBootstrap = true; useSharedLibraries = false; };
    libxml2 = libxml2.override { pythonSupport = false; };
    python2 = callPackage ../development/interpreters/python/cpython/2.7/boot.nix { inherit (darwin) CF configd; };
  });

  llvmPackages_38 = callPackage ../development/compilers/llvm/3.8 {
    inherit (stdenvAdapters) overrideCC;
  };

  llvmPackages_39 = callPackage ../development/compilers/llvm/3.9 {
    inherit (stdenvAdapters) overrideCC;
  };

  manticore = callPackage ../development/compilers/manticore { };

  mentorToolchains = recurseIntoAttrs (
    callPackage_i686 ../development/compilers/mentor {}
  );

  mercury = callPackage ../development/compilers/mercury { };

  microscheme = callPackage ../development/compilers/microscheme { };

  mitscheme = callPackage ../development/compilers/mit-scheme {
   texLive = texlive.combine { inherit (texlive) scheme-small; };
   texinfo = texinfo5;
  };

  mkcl = callPackage ../development/compilers/mkcl {};

  mlton = callPackage ../development/compilers/mlton { };

  mono = mono40;

  mono40 = callPackage ../development/compilers/mono/4.0.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  mono44 = lowPrio (callPackage ../development/compilers/mono/4.4.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  mono46 = lowPrio (callPackage ../development/compilers/mono/4.6.nix {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  });

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  mozart-binary = callPackage ../development/compilers/mozart/binary.nix { };
  mozart = mozart-binary;

  nim = callPackage ../development/compilers/nim { };
  nrpl = callPackage ../development/tools/nrpl { };

  neko = callPackage ../development/compilers/neko { };

  nasm = callPackage ../development/compilers/nasm { };

  nvidia_cg_toolkit = callPackage ../development/compilers/nvidia-cg-toolkit { };

  obliv-c = callPackage ../development/compilers/obliv-c {};

  ocaml-ng = callPackage ./ocaml-packages.nix { };

  ocamlPackages = recurseIntoAttrs ocaml-ng.ocamlPackages;

  orc = callPackage ../development/compilers/orc { };

  metaocaml_3_09 = callPackage ../development/compilers/ocaml/metaocaml-3.09.nix { };

  ber_metaocaml_003 = callPackage ../development/compilers/ocaml/ber-metaocaml-003.nix { };

  ocaml_make = callPackage ../development/ocaml-modules/ocamlmake { };

  inherit (ocamlPackages) ocaml-top;

  opa = callPackage ../development/compilers/opa {
    nodejs = nodejs-4_x;
    ocamlPackages = ocamlPackages_4_02;
  };

  opam = callPackage ../development/tools/ocaml/opam { };

  picat = callPackage ../development/compilers/picat {
    stdenv = overrideCC stdenv gcc49;
  };

  ponyc = callPackage ../development/compilers/ponyc {
    llvm = llvm_39;
  };

  pony-stable = callPackage ../development/compilers/ponyc/pony-stable.nix { };

  rgbds = callPackage ../development/compilers/rgbds { };

  rtags = callPackage ../development/tools/rtags/default.nix {
    inherit (darwin) apple_sdk;
  };

  rust = rustStable;
  rustStable = callPackage ../development/compilers/rust {};
  rustBeta = lowPrio (recurseIntoAttrs (callPackage ../development/compilers/rust/beta.nix {}));
  rustNightly = lowPrio (recurseIntoAttrs (callPackage ../development/compilers/rust/nightly.nix {
    rustPlatform = recurseIntoAttrs (makeRustPlatform rustBeta);
  }));
  rustNightlyBin = lowPrio (callPackage ../development/compilers/rust/nightlyBin.nix {
     buildRustPackage = callPackage ../build-support/rust {
       rust = rustNightlyBin;
       rustRegistry = callPackage ./rust-packages.nix { };
     };
  });

  cargo = rust.cargo;
  rustc = rust.rustc;

  rustPlatform = recurseIntoAttrs (makeRustPlatform rust);

  makeRustPlatform = rust: lib.fix (self:
    let
      callPackage = newScope self;
    in {
      inherit rust;

      rustRegistry = callPackage ./rust-packages.nix { };

      buildRustPackage = callPackage ../build-support/rust {
        inherit rust;
      };
    });

  rainicorn = callPackage ../development/tools/rust/rainicorn { };
  rustfmt = callPackage ../development/tools/rust/rustfmt { };
  rustracer = callPackage ../development/tools/rust/racer { };
  rustracerd = callPackage ../development/tools/rust/racerd { };
  rust-bindgen = callPackage ../development/tools/rust/bindgen { };

  sbclBootstrap = callPackage ../development/compilers/sbcl/bootstrap.nix {};
  sbcl = callPackage ../development/compilers/sbcl {};
  # For Maxima
  sbcl_1_3_12 = callPackage ../development/compilers/sbcl/1.3.12.nix { };
  # For ACL2
  sbcl_1_2_0 = callPackage ../development/compilers/sbcl/1.2.0.nix {
    clisp = clisp;
  };

  scala_2_9 = callPackage ../development/compilers/scala/2.9.nix { };
  scala_2_10 = callPackage ../development/compilers/scala/2.10.nix { };
  scala_2_11 = callPackage ../development/compilers/scala/2.11.nix { };
  scala_2_12 = callPackage ../development/compilers/scala { jre = jre8; };
  scala = scala_2_12;

  scalafmt = callPackage ../development/tools/scalafmt { };

  sdcc = callPackage ../development/compilers/sdcc { boost = boost159; };

  serpent = callPackage ../development/compilers/serpent { };

  smlnjBootstrap = callPackage ../development/compilers/smlnj/bootstrap.nix { };
  smlnj = if stdenv.isDarwin
            then callPackage ../development/compilers/smlnj { }
            else callPackage_i686 ../development/compilers/smlnj { };

  solc = callPackage ../development/compilers/solc { };

  souffle = callPackage ../development/compilers/souffle { };

  sqldeveloper = callPackage ../development/tools/database/sqldeveloper { };

  squeak = callPackage ../development/compilers/squeak { };

  squirrel-sql = callPackage ../development/tools/database/squirrel-sql {
    drivers = [ mysql_jdbc postgresql_jdbc ];
  };

  stalin = callPackage ../development/compilers/stalin { };

  metaBuildEnv = callPackage ../development/compilers/meta-environment/meta-build-env { };

  swiProlog = callPackage ../development/compilers/swi-prolog { };

  tbb = callPackage ../development/libraries/tbb { };

  terra = callPackage ../development/compilers/terra {
    llvmPackages = llvmPackages_38;
    lua = lua5_1;
  };

  teyjus = callPackage ../development/compilers/teyjus {
    omake = omake_rc1;
  };

  thrust = callPackage ../development/tools/thrust {
    gconf = pkgs.gnome2.GConf;
  };

  tinycc = callPackage ../development/compilers/tinycc { };

  inherit (ocaml-ng.ocamlPackages_4_02) trv;

  bupc = callPackage ../development/compilers/bupc { };

  urweb = callPackage ../development/compilers/urweb { };

  inherit (callPackage ../development/compilers/vala { })
    vala_0_23
    vala_0_26
    vala_0_28
    vala_0_32
    vala_0_34
    vala;

  valadoc = callPackage ../development/tools/valadoc { };

  vs90wrapper = callPackage ../development/compilers/vs90wrapper { };

  wla-dx = callPackage ../development/compilers/wla-dx { };

  wrapCCWith = ccWrapper: libc: extraBuildCommands: baseCC: ccWrapper {
    nativeTools = stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    cc = baseCC;
    dyld = if stdenv.isDarwin then darwin.dyld else null;
    isGNU = baseCC.isGNU or false;
    isClang = baseCC.isClang or false;
    inherit libc extraBuildCommands;
  };

  ccWrapperFun = callPackage ../build-support/cc-wrapper;

  wrapCC = wrapCCWith ccWrapperFun stdenv.cc.libc "";
  # legacy version, used for gnat bootstrapping
  wrapGCC-old = baseGCC: callPackage ../build-support/gcc-wrapper-old {
    nativeTools = stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    gcc = baseGCC;
    libc = glibc;
  };

  wrapGCCCross =
    {gcc, libc, binutils, cross, shell ? "", name ? "gcc-cross-wrapper"}:

    forcedNativePackages.callPackage ../build-support/gcc-cross-wrapper {
      nativeTools = false;
      nativeLibc = false;
      noLibc = (libc == null);
      inherit gcc binutils libc shell name cross;
    };

  # prolog
  yap = callPackage ../development/compilers/yap { };

  yasm = callPackage ../development/compilers/yasm { };

  yosys = callPackage ../development/compilers/yosys { };

  zulu = callPackage ../development/compilers/zulu { };


  ### DEVELOPMENT / INTERPRETERS

  acl2 = callPackage ../development/interpreters/acl2 {
    sbcl = sbcl_1_2_0;
  };

  angelscript = callPackage ../development/interpreters/angelscript {};

  angelscript_2_22 = callPackage ../development/interpreters/angelscript/2.22.nix {};

  chibi = callPackage ../development/interpreters/chibi { };

  ceptre = callPackage ../development/interpreters/ceptre { };

  clisp = callPackage ../development/interpreters/clisp { };
  clisp-tip = callPackage ../development/interpreters/clisp/hg.nix { };

  # compatibility issues in 2.47 - at list 2.44.1 is known good
  # for sbcl bootstrap.
  # SBCL page recommends 2.33.2, though. Not sure when was it last tested
  clisp_2_44_1 = callPackage ../development/interpreters/clisp/2.44.1.nix {
    libsigsegv = libsigsegv_25;
  };

  clojure = callPackage ../development/interpreters/clojure { };

  clooj = callPackage ../development/interpreters/clojure/clooj.nix { };

  erlangR16 = callPackage ../development/interpreters/erlang/R16.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };
  erlangR16_odbc = callPackage ../development/interpreters/erlang/R16.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    odbcSupport = true;
  };
  erlang_basho_R16B02 = callPackage ../development/interpreters/erlang/R16B02-8-basho.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };
  erlang_basho_R16B02_odbc = callPackage ../development/interpreters/erlang/R16B02-8-basho.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    odbcSupport = true;
  };
  erlangR17 = callPackage ../development/interpreters/erlang/R17.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };
  erlangR17_odbc = callPackage ../development/interpreters/erlang/R17.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    odbcSupport = true;
  };
  erlangR17_javac = callPackage ../development/interpreters/erlang/R17.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    javacSupport = true;
  };
  erlangR17_odbc_javac = callPackage ../development/interpreters/erlang/R17.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    javacSupport = true; odbcSupport = true;
  };
  erlangR18 = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
  };
  erlangR18_odbc = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
    odbcSupport = true;
  };
  erlangR18_javac = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
    javacSupport = true;
  };
  erlangR18_odbc_javac = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
    javacSupport = true; odbcSupport = true;
  };
  erlangR19 = callPackage ../development/interpreters/erlang/R19.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
  };
  erlangR19_odbc = callPackage ../development/interpreters/erlang/R19.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
    odbcSupport = true;
  };
  erlangR19_javac = callPackage ../development/interpreters/erlang/R19.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
    javacSupport = true;
  };
  erlangR19_odbc_javac = callPackage ../development/interpreters/erlang/R19.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    wxGTK = wxGTK30;
    javacSupport = true; odbcSupport = true;
  };
  erlang = erlangR18;
  erlang_odbc = erlangR18_odbc;
  erlang_javac = erlangR18_javac;
  erlang_odbc_javac = erlangR18_odbc_javac;

  rebar = callPackage ../development/tools/build-managers/rebar { };
  rebar3-open = callPackage ../development/tools/build-managers/rebar3 { hermeticRebar3 = false; };
  rebar3 = callPackage ../development/tools/build-managers/rebar3 { hermeticRebar3 = true; };
  hexRegistrySnapshot = callPackage ../development/beam-modules/hex-registry-snapshot.nix { };
  fetchHex = callPackage ../development/beam-modules/fetch-hex.nix { };

  beamPackages = callPackage ../development/beam-modules { };
  hex2nix = beamPackages.callPackage ../development/tools/erlang/hex2nix { };
  cuter = callPackage ../development/tools/erlang/cuter { };

  relxExe = callPackage ../development/tools/erlang/relx-exe {};

  elixir = callPackage ../development/interpreters/elixir { debugInfo = true; };

  lfe = callPackage ../development/interpreters/lfe { };

  groovy = callPackage ../development/interpreters/groovy { };

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  guile_2_0 = callPackage ../development/interpreters/guile { };

  guile = guile_2_0;

  hadoop = callPackage ../applications/networking/cluster/hadoop { };

  io = callPackage ../development/interpreters/io { };

  j = callPackage ../development/interpreters/j {};

  jimtcl = callPackage ../development/interpreters/jimtcl {};

  jmeter = callPackage ../applications/networking/jmeter {};

  davmail = callPackage ../applications/networking/davmail {};

  kanif = callPackage ../applications/networking/cluster/kanif { };

  lxappearance = callPackage ../desktops/lxde/core/lxappearance {
    gtk2 = gtk2-x11;
  };

  lxmenu-data = callPackage ../desktops/lxde/core/lxmenu-data.nix { };

  kona = callPackage ../development/interpreters/kona {};

  lolcode = callPackage ../development/interpreters/lolcode { };

  love_0_7 = callPackage ../development/interpreters/love/0.7.nix { lua=lua5_1; };
  love_0_8 = callPackage ../development/interpreters/love/0.8.nix { lua=lua5_1; };
  love_0_9 = callPackage ../development/interpreters/love/0.9.nix { };
  love_0_10 = callPackage ../development/interpreters/love/0.10.nix { };
  love = love_0_10;

  ### LUA MODULES

  lua4 = callPackage ../development/interpreters/lua-4 { };
  lua5_0 = callPackage ../development/interpreters/lua-5/5.0.3.nix { };
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
  luajitPackages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = luajit; });

  luaPackages = lua52Packages;

  lua5_1_sockets = lua51Packages.luasocket;

  lua5_expat = callPackage ../development/interpreters/lua-5/expat.nix {};
  lua5_sec = callPackage ../development/interpreters/lua-5/sec.nix { };

  luajit = callPackage ../development/interpreters/luajit {};

  luarocks = luaPackages.luarocks;

  toluapp = callPackage ../development/tools/toluapp {
    lua = lua5_1; # doesn't work with any other :(
  };

  ### END OF LUA

  lush2 = callPackage ../development/interpreters/lush {};

  maude = callPackage ../development/interpreters/maude {
    bison = bison2;
    flex = flex_2_5_35;
  };

  mesos = callPackage ../applications/networking/cluster/mesos {
    sasl = cyrus_sasl;
    inherit (pythonPackages) python boto setuptools wrapPython;
    pythonProtobuf = pythonPackages.protobuf2_6;
    perf = linuxPackages.perf;
  };

  mesos-dns = callPackage ../servers/mesos-dns { };

  mujs = callPackage ../development/interpreters/mujs { };

  nix-exec = callPackage ../development/interpreters/nix-exec {
    nix = nixUnstable;

    git = gitMinimal;
  };

  octave = callPackage ../development/interpreters/octave {
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
  octaveFull = (lowPrio (callPackage ../development/interpreters/octave {
    qt = qt4;
    overridePlatforms = ["x86_64-linux" "x86_64-darwin"];
  }));

  ocropus = callPackage ../applications/misc/ocropus { };

  inherit (callPackages ../development/interpreters/perl {}) perl perl520 perl522;

  pachyderm = callPackage ../applications/networking/cluster/pachyderm { };

  php = php71;

  phpPackages = php70Packages;

  php56Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php56;
  });

  php70Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php70;
  });

  php71Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php71;
  });

  inherit (callPackages ../development/interpreters/php { })
    php56
    php70
    php71;

  php-embed = php71-embed;

  php71-embed = php71.override {
    config.php.embed = true;
    config.php.apxs2 = false;
  };


  picoc = callPackage ../development/interpreters/picoc {};

  picolisp = callPackage ../development/interpreters/picolisp {};

  pltScheme = racket; # just to be sure

  polyml = callPackage ../development/compilers/polyml { };

  pure = callPackage ../development/interpreters/pure {
    llvm = llvm_35;
  };
  purePackages = recurseIntoAttrs (callPackage ./pure-packages.nix {});

  # Python interpreters. All standard library modules are included except for tkinter, which is
  # available as `pythonPackages.tkinter` and can be used as any other Python package.
  python = python2;
  python2 = python27;
  python3 = python35;

  # Python interpreter that is build with all modules, including tkinter.
  # These are for compatibility and should not be used inside Nixpkgs.
  pythonFull = python.override{x11Support=true;};
  python2Full = python2.override{x11Support=true;};
  python27Full = python27.override{x11Support=true;};
  python3Full = python3.override{x11Support=true;};
  python33Full = python33.override{x11Support=true;};
  python34Full = python34.override{x11Support=true;};
  python35Full = python35.override{x11Support=true;};
  python36Full = python36.override{x11Support=true;};

  # pythonPackages further below, but assigned here because they need to be in sync
  pythonPackages = python2Packages;
  python2Packages = python27Packages;
  python3Packages = python35Packages;

  python27 = callPackage ../development/interpreters/python/cpython/2.7 {
    self = python27;
    inherit (darwin) CF configd;
  };
  python33 = callPackage ../development/interpreters/python/cpython/3.3 {
    self = python33;
    inherit (darwin) CF configd;
  };
  python34 = hiPrio (callPackage ../development/interpreters/python/cpython/3.4 {
    inherit (darwin) CF configd;
    self = python34;
  });
  python35 = hiPrio (callPackage ../development/interpreters/python/cpython/3.5 {
    inherit (darwin) CF configd;
    self = python35;
  });
  python36 = callPackage ../development/interpreters/python/cpython/3.6 {
    inherit (darwin) CF configd;
    self = python36;
  };

  pypy = pypy27;

  pypy27 = callPackage ../development/interpreters/python/pypy/2.7 {
    self = pypy27;
    python = python27.override{x11Support=true;};
    db = db.override { dbmSupport = true; };
  };

  python2nix = callPackage ../tools/package-management/python2nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/cpython/docs {});

  pypi2nix = callPackage ../development/tools/pypi2nix { python = python35; };

  svg2tikz = python27Packages.svg2tikz;

  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  racket = callPackage ../development/interpreters/racket { };

  rakudo = callPackage ../development/interpreters/rakudo {
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  rascal = callPackage ../development/interpreters/rascal { };

  regina = callPackage ../development/interpreters/regina { };

  renpy = callPackage ../development/interpreters/renpy {
    ffmpeg = ffmpeg_2;
  };

  pixie = callPackage ../development/interpreters/pixie { };
  dust = callPackage ../development/interpreters/pixie/dust.nix { };

  buildRubyGem = callPackage ../development/ruby-modules/gem { };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config { };
  bundix = callPackage ../development/ruby-modules/bundix { };
  bundler = callPackage ../development/ruby-modules/bundler { };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };

  inherit (callPackage ../development/interpreters/ruby {})
    ruby_2_0_0
    ruby_2_1_10
    ruby_2_2_5
    ruby_2_3_3
    ruby_2_4_0;

  # Ruby aliases
  ruby = ruby_2_3;
  ruby_2_0 = ruby_2_0_0;
  ruby_2_1 = ruby_2_1_10;
  ruby_2_2 = ruby_2_2_5;
  ruby_2_3 = ruby_2_3_3;
  ruby_2_4 = ruby_2_4_0;

  scsh = callPackage ../development/interpreters/scsh { };

  scheme48 = callPackage ../development/interpreters/scheme48 { };

  self = callPackage_i686 ../development/interpreters/self { };

  spark = spark_21;
  spark_16 = callPackage ../applications/networking/cluster/spark { version = "1.6.0"; };
  spark_21 = callPackage ../applications/networking/cluster/spark { version = "2.1.0"; };

  spidermonkey_1_8_5 = callPackage ../development/interpreters/spidermonkey/1.8.5.nix { };
  spidermonkey_17 = callPackage ../development/interpreters/spidermonkey/17.nix { };
  spidermonkey_24 = callPackage ../development/interpreters/spidermonkey/24.nix { };
  spidermonkey_31 = callPackage ../development/interpreters/spidermonkey/31.nix { };
  spidermonkey_38 = callPackage ../development/interpreters/spidermonkey/38.nix { };
  spidermonkey = spidermonkey_31;

  ssm-agent = callPackage ../applications/networking/cluster/ssm-agent { };

  supercollider = callPackage ../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  taktuk = callPackage ../applications/networking/cluster/taktuk { };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };

  wasm = callPackage ../development/interpreters/wasm { };


  ### DEVELOPMENT / MISC

  amdadlsdk = callPackage ../development/misc/amdadl-sdk { };

  amdappsdk26 = callPackage ../development/misc/amdapp-sdk {
    version = "2.6";
  };

  amdappsdk27 = callPackage ../development/misc/amdapp-sdk {
    version = "2.7";
  };

  amdappsdk28 = callPackage ../development/misc/amdapp-sdk {
    version = "2.8";
  };

  amdappsdk = amdappsdk28;

  amdappsdkFull = callPackage ../development/misc/amdapp-sdk {
    version = "2.8";
    samples = true;
  };

  avrgcclibc = callPackage ../development/misc/avr-gcc-with-avr-libc {};

  avr8burnomat = callPackage ../development/misc/avr8-burn-omat { };

  sourceFromHead = callPackage ../build-support/source-from-head-fun.nix {};

  ecj = callPackage ../development/eclipse/ecj { };

  jruby = callPackage ../development/interpreters/jruby { };

  jython = callPackage ../development/interpreters/jython {};

  guileCairo = callPackage ../development/guile-modules/guile-cairo { };

  guileGnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome2.GConf;
    inherit (gnome2) gnome_vfs libglade libgnome libgnomecanvas libgnomeui;
  };

  guile_lib = callPackage ../development/guile-modules/guile-lib { };

  guile_ncurses = callPackage ../development/guile-modules/guile-ncurses { };

  guile-opengl = callPackage ../development/guile-modules/guile-opengl { };

  guile-sdl = callPackage ../development/guile-modules/guile-sdl { };

  guile-sdl2 = callPackage ../development/guile-modules/guile-sdl2 { };

  guile-xcb = callPackage ../development/guile-modules/guile-xcb { };

  pharo-vms = callPackage_i686 ../development/pharo/vm { };
  pharo-vm  = pharo-vms.pharo-no-spur;
  pharo-vm5 = pharo-vms.pharo-spur;

  pharo-launcher = callPackage ../development/pharo/launcher { };

  srecord = callPackage ../development/tools/misc/srecord { };

  srelay = callPackage ../tools/networking/srelay { };

  xidel = callPackage ../tools/text/xidel { };


  ### DEVELOPMENT / TOOLS

  activator = callPackage ../development/tools/activator { };

  alloy = callPackage ../development/tools/alloy { };

  augeas = callPackage ../tools/system/augeas { };

  ansible  = python2Packages.ansible2;
  ansible2 = python2Packages.ansible2;

  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3_4 = callPackage ../development/tools/parsing/antlr/3.4.nix { };
  antlr3_5 = callPackage ../development/tools/parsing/antlr/3.5.nix { };
  antlr3 = antlr3_5;

  ant = apacheAnt;

  apacheAnt = callPackage ../development/tools/build-managers/apache-ant { };

  apacheKafka = apacheKafka_0_10;
  apacheKafka_0_8 = callPackage ../servers/apache-kafka { majorVersion = "0.8"; };
  apacheKafka_0_9 = callPackage ../servers/apache-kafka { majorVersion = "0.9"; };
  apacheKafka_0_10 = callPackage ../servers/apache-kafka { majorVersion = "0.10"; };

  asn2quickder = callPackage ../development/tools/asn2quickder {};

  astyle = callPackage ../development/tools/misc/astyle { };

  awf = callPackage ../development/tools/misc/awf { };

  electron = callPackage ../development/tools/electron { };

  autobuild = callPackage ../development/tools/misc/autobuild { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf-archive = callPackage ../development/tools/misc/autoconf-archive { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };
  autoconf264 = callPackage ../development/tools/misc/autoconf/2.64.nix { };

  autocutsel = callPackage ../tools/X11/autocutsel{ };

  automake = automake115x;

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake112x = callPackage ../development/tools/misc/automake/automake-1.12.x.nix { };

  automake113x = callPackage ../development/tools/misc/automake/automake-1.13.x.nix { };

  automake114x = callPackage ../development/tools/misc/automake/automake-1.14.x.nix { };

  automake115x = callPackage ../development/tools/misc/automake/automake-1.15.x.nix { };

  automoc4 = callPackage ../development/tools/misc/automoc4 { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  avarice = callPackage ../development/tools/misc/avarice {
    gcc = gcc49;
  };

  babeltrace = callPackage ../development/tools/misc/babeltrace { };

  bam = callPackage ../development/tools/build-managers/bam {};

  bazel = callPackage ../development/tools/build-managers/bazel { };

  bear = callPackage ../development/tools/build-managers/bear { };

  bin_replace_string = callPackage ../development/tools/misc/bin_replace_string { };

  binutils = if stdenv.isDarwin then darwin.binutils else binutils-raw;

  binutils-raw = callPackage ../development/tools/misc/binutils { inherit noSysDirs; };

  binutils_nogold = lowPrio (callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
    gold = false;
  });

  binutilsCross = assert targetPlatform != buildPlatform; lowPrio (
    if targetPlatform.libc == "libSystem" then darwin.cctools_cross
    else forcedNativePackages.binutils.override {
      noSysDirs = true;
      cross = targetPlatform;
    });

  bison2 = callPackage ../development/tools/parsing/bison/2.x.nix { };
  bison3 = callPackage ../development/tools/parsing/bison/3.x.nix { };
  bison = bison3;

  bloaty = callPackage ../development/tools/bloaty { };

  bossa = callPackage ../development/tools/misc/bossa {
    wxGTK = wxGTK30;
  };

  buildbot = callPackage ../development/tools/build-managers/buildbot {
    pythonPackages = python2Packages;
  };
  buildbot-worker = callPackage ../development/tools/build-managers/buildbot/worker.nix {
    pythonPackages = python2Packages;
  };
  buildbot-plugins = callPackage ../development/tools/build-managers/buildbot/plugins.nix {
    pythonPackages = python2Packages;
  };
  buildbot-ui = self.buildbot.override {
    plugins = with self.buildbot-plugins; [ www ];
  };
  buildbot-full = self.buildbot.override {
    plugins = with self.buildbot-plugins; [ www console-view waterfall-view ];
  };

  buildkite-agent = callPackage ../development/tools/continuous-integration/buildkite-agent { };

  byacc = callPackage ../development/tools/parsing/byacc { };

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
  ccacheWrapper = makeOverridable ({ extraConfig ? "" }:
     wrapCC (ccache.links extraConfig)) {};
  ccacheStdenv = lowPrio (overrideCC stdenv ccacheWrapper);

  cccc = callPackage ../development/tools/analysis/cccc { };

  cgdb = callPackage ../development/tools/misc/cgdb { };

  cheat = callPackage ../applications/misc/cheat { };

  chefdk = callPackage ../development/tools/chefdk {
    ruby = ruby_2_0;
  };

  matter-compiler = callPackage ../development/compilers/matter-compiler {};

  cfr = callPackage ../development/tools/java/cfr { };

  checkstyle = callPackage ../development/tools/analysis/checkstyle { };

  chromedriver = callPackage ../development/tools/selenium/chromedriver { gconf = gnome2.GConf; };

  chrpath = callPackage ../development/tools/misc/chrpath { };

  chruby = callPackage ../development/tools/misc/chruby { rubies = null; };

  cide = callPackage ../development/tools/continuous-integration/cide { };

  "cl-launch" = callPackage ../development/tools/misc/cl-launch {};

  coan = callPackage ../development/tools/analysis/coan { };

  complexity = callPackage ../development/tools/misc/complexity { };

  cookiecutter = pythonPackages.cookiecutter;

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = callPackage ../development/tools/misc/ctags/wrapped.nix {};

  ctodo = callPackage ../applications/misc/ctodo { };

  cmake_2_8 = callPackage ../development/tools/build-managers/cmake/2.8.nix {
    wantPS = stdenv.isDarwin;
    inherit (darwin) ps;
  };

  cmake = callPackage ../development/tools/build-managers/cmake {
    inherit (darwin) ps;
  };

  cmakeCurses = cmake.override { useNcurses = true; };

  cmakeWithGui = cmakeCurses.override { useQt4 = true; };

  # Does not actually depend on Qt 5
  extra-cmake-modules = qt5.ecmNoHooks;

  coccinelle = callPackage ../development/tools/misc/coccinelle {
    ocamlPackages = ocamlPackages_4_01_0;
   };

  cpptest = callPackage ../development/libraries/cpptest { };

  cppi = callPackage ../development/tools/misc/cppi { };

  cproto = callPackage ../development/tools/misc/cproto { };

  cflow = callPackage ../development/tools/misc/cflow { };

  cov-build = callPackage ../development/tools/analysis/cov-build {};

  cppcheck = callPackage ../development/tools/analysis/cppcheck { };

  creduce = callPackage ../development/tools/misc/creduce {
    inherit (perlPackages) perl
      ExporterLite FileWhich GetoptTabular RegexpCommon TermReadKey;
    inherit (llvmPackages_39) llvm clang-unwrapped;
    utillinux = if stdenv.isLinux then utillinuxMinimal else null;
  };

  cscope = callPackage ../development/tools/misc/cscope { };

  csslint = callPackage ../development/web/csslint { };

  libcxx = llvmPackages.libcxx;
  libcxxabi = llvmPackages.libcxxabi;

  libstdcxx5 = callPackage ../development/libraries/libstdc++5 { };

  libsigrok = callPackage ../development/tools/libsigrok { };
  # old version:
  libsigrok-0-3-0 = libsigrok.override {
    version = "0.3.0";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };

  libsigrokdecode = callPackage ../development/tools/libsigrokdecode { };

  dcadec = callPackage ../development/tools/dcadec { };

  dejagnu = callPackage ../development/tools/misc/dejagnu { };

  dfeet = callPackage ../development/tools/misc/d-feet { };

  dfu-programmer = callPackage ../development/tools/misc/dfu-programmer { };

  dfu-util = callPackage ../development/tools/misc/dfu-util { };

  ddd = callPackage ../development/tools/misc/ddd { };

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

  doclifter = callPackage ../development/tools/misc/doclifter { };

  docutils = pythonPackages.docutils;

  doctl = callPackage ../development/tools/doctl { };

  dot2tex = pythonPackages.dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt4 = null;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  doxygen_gui = lowPrio (doxygen.override { inherit qt4; });

  drake = callPackage ../development/tools/build-managers/drake { };

  drush = callPackage ../development/tools/misc/drush { };

  editorconfig-core-c = callPackage ../development/tools/misc/editorconfig-core-c { };

  eggdbus = callPackage ../development/tools/misc/eggdbus { };

  egypt = callPackage ../development/tools/analysis/egypt { };

  elfutils = callPackage ../development/tools/misc/elfutils { };

  emma = callPackage ../development/tools/analysis/emma { };

  epm = callPackage ../development/tools/misc/epm { };

  eweb = callPackage ../development/tools/literate-programming/eweb { };

  eztrace = callPackage ../development/tools/profiling/EZTrace { };

  findbugs = callPackage ../development/tools/analysis/findbugs { };

  foreman = callPackage ../tools/system/foreman { };

  flow = callPackage ../development/tools/analysis/flow {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    inherit (darwin) cf-private;
    ocaml = ocaml_4_02;
  };

  framac = callPackage ../development/tools/analysis/frama-c { };

  frame = callPackage ../development/libraries/frame { };

  fswatch = callPackage ../development/tools/misc/fswatch { };

  funnelweb = callPackage ../development/tools/literate-programming/funnelweb { };

  pmd = callPackage ../development/tools/analysis/pmd { };

  jdepend = callPackage ../development/tools/analysis/jdepend { };

  flex_2_5_35 = callPackage ../development/tools/parsing/flex/2.5.35.nix { };
  flex_2_6_1 = callPackage ../development/tools/parsing/flex/2.6.1.nix { };
  flex = callPackage ../development/tools/parsing/flex/default.nix { };

  flexcpp = callPackage ../development/tools/parsing/flexc++ { };

  m4 = gnum4;

  geis = callPackage ../development/libraries/geis {
    inherit (xorg) libX11 libXext libXi libXtst;
  };

  github-release = callPackage ../development/tools/github/github-release { };

  global = callPackage ../development/tools/misc/global { };

  gnome_doc_utils = callPackage ../development/tools/documentation/gnome-doc-utils {};

  gnum4 = callPackage ../development/tools/misc/gnum4 { };

  gnumake380 = callPackage ../development/tools/build-managers/gnumake/3.80 { };
  gnumake382 = callPackage ../development/tools/build-managers/gnumake/3.82 { };
  gnumake3 = gnumake382;
  gnumake40 = callPackage ../development/tools/build-managers/gnumake/4.0 { };
  gnumake41 = callPackage ../development/tools/build-managers/gnumake/4.1 { };
  gnumake42 = callPackage ../development/tools/build-managers/gnumake/4.2 { };
  gnumake = gnumake42;

  gnustep = recurseIntoAttrs (callPackage ../desktops/gnustep {});

  gob2 = callPackage ../development/tools/misc/gob2 { };

  gocd-agent = callPackage ../development/tools/continuous-integration/gocd-agent { };

  gocd-server = callPackage ../development/tools/continuous-integration/gocd-server { };

  gotty = callPackage ../servers/gotty { };

  gradleGen = callPackage ../development/tools/build-managers/gradle { };
  gradle = self.gradleGen.gradle_latest;
  gradle_2_14 = self.gradleGen.gradle_2_14;
  gradle_2_5 = self.gradleGen.gradle_2_5;

  gperf = callPackage ../development/tools/misc/gperf { };
  # 3.1 changed some parameters from int to size_t, leading to mismatches.
  gperf_3_0 = callPackage ../development/tools/misc/gperf/3.0.x.nix { };

  grail = callPackage ../development/libraries/grail { };

  gtk_doc = callPackage ../development/tools/documentation/gtk-doc { };

  gtkdialog = callPackage ../development/tools/misc/gtkdialog { };

  guileLint = callPackage ../development/tools/guile/guile-lint { };

  gwrap = callPackage ../development/tools/guile/g-wrap { };

  help2man = callPackage ../development/tools/misc/help2man {
    inherit (perlPackages) LocaleGettext;
  };

  heroku = callPackage ../development/tools/heroku { };

  htmlunit-driver = callPackage ../development/tools/selenium/htmlunit-driver { };

  hyenae = callPackage ../tools/networking/hyenae { };

  icestorm = callPackage ../development/tools/icestorm { };

  icmake = callPackage ../development/tools/build-managers/icmake { };

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils {
    inherit (perlPackages) XMLSimple;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_38;
  };

  indent = callPackage ../development/tools/misc/indent { };

  ino = callPackage ../development/arduino/ino { };

  inotify-tools = callPackage ../development/tools/misc/inotify-tools { };

  intel-gpu-tools = callPackage ../development/tools/misc/intel-gpu-tools {};

  iozone = callPackage ../development/tools/misc/iozone { };

  ired = callPackage ../development/tools/analysis/radare/ired.nix { };

  itstool = callPackage ../development/tools/misc/itstool { };

  jam = callPackage ../development/tools/build-managers/jam { };

  jamomacore = callPackage ../development/libraries/audio/jamomacore { };

  jikespg = callPackage ../development/tools/parsing/jikespg { };

  jenkins = callPackage ../development/tools/continuous-integration/jenkins { };

  jenkins-job-builder = pythonPackages.jenkins-job-builder;

  kconfig-frontends = callPackage ../development/tools/misc/kconfig-frontends {
    gperf = gperf_3_0;
  };

  kcov = callPackage ../development/tools/analysis/kcov { };

  kube-aws = callPackage ../development/tools/kube-aws { };

  lcov = callPackage ../development/tools/analysis/lcov { };

  leiningen = callPackage ../development/tools/build-managers/leiningen { };

  lemon = callPackage ../development/tools/parsing/lemon { };

  lenmus = callPackage ../applications/misc/lenmus { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  lsof = callPackage ../development/tools/misc/lsof { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  lttng-tools = callPackage ../development/tools/misc/lttng-tools { };

  lttng-ust = callPackage ../development/tools/misc/lttng-ust { };

  lttv = callPackage ../development/tools/misc/lttv { };

  maven = maven3;
  maven3 = callPackage ../development/tools/build-managers/apache-maven { };

  go-md2man = callPackage ../development/tools/misc/md2man {};

  minify = callPackage ../development/web/minify { };

  minizinc = callPackage ../development/tools/minizinc { };

  mk = callPackage ../development/tools/build-managers/mk { };

  msgpack-tools = callPackage ../development/tools/msgpack-tools { };

  msitools = callPackage ../development/tools/misc/msitools { };

  multi-ghc-travis = callPackage ../development/tools/haskell/multi-ghc-travis { };

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
    fontsConf = makeFontsConf {
      fontDirectories = [
        dejavu_fonts.minimal
      ];
    };
  };

  nant = callPackage ../development/tools/build-managers/nant { };

  ninja = callPackage ../development/tools/build-managers/ninja { };

  nixbang = callPackage ../development/tools/misc/nixbang {
      pythonPackages = python3Packages;
  };

  nexus = callPackage ../development/tools/repository-managers/nexus { };

  node_webkit = node_webkit_0_9;

  nwjs_0_12 = callPackage ../development/tools/node-webkit/nw12.nix {
    gconf = pkgs.gnome2.GConf;
  };

  node_webkit_0_11 = callPackage ../development/tools/node-webkit/nw11.nix {
    gconf = pkgs.gnome2.GConf;
  };

  node_webkit_0_9 = callPackage ../development/tools/node-webkit/nw9.nix {
    gconf = pkgs.gnome2.GConf;
  };

  noweb = callPackage ../development/tools/literate-programming/noweb { };
  nuweb = callPackage ../development/tools/literate-programming/nuweb { tex = texlive.combined.scheme-small; };

  omake = callPackage ../development/tools/ocaml/omake {
    inherit (ocamlPackages_4_02) ocaml;
  };

  inherit (ocamlPackages) omake_rc1;

  omniorb = callPackage ../development/tools/omniorb { };

  opengrok = callPackage ../development/tools/misc/opengrok { };

  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = callPackage ../development/tools/profiling/oprofile { };

  pahole = callPackage ../development/tools/misc/pahole {};

  parse-cli-bin = callPackage ../development/tools/parse-cli-bin { };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = lowPrio (callPackage ../development/tools/misc/patchelf/unstable.nix { });

  peg = callPackage ../development/tools/parsing/peg { };

  phantomjs = callPackage ../development/tools/phantomjs { };

  phantomjs2 = callPackage ../development/tools/phantomjs2 { };

  pmccabe = callPackage ../development/tools/misc/pmccabe { };

  /* Make pkgconfig always return a nativeDrv, never a proper crossDrv,
     because most usage of pkgconfig as buildInput (inheritance of
     pre-cross nixpkgs) means using it using as nativeBuildInput
     cross_renaming: we should make all programs use pkgconfig as
     nativeBuildInput after the renaming.
     */
  pkgconfig = forcedNativePackages.callPackage ../development/tools/misc/pkgconfig {
    fetchurl = fetchurlBoot;
  };
  pkgconfigUpstream = lowPrio (pkgconfig.override { vanilla = true; });

  postiats-utilities = callPackage ../development/tools/postiats-utilities {};

  prelink = callPackage ../development/tools/misc/prelink { };

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake = premake4;

  qtcreator = qt5.callPackage ../development/qtcreator { };

  r10k = callPackage ../tools/system/r10k { };

  radare = callPackage ../development/tools/analysis/radare {
    inherit (gnome2) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };
  radare2 = callPackage ../development/tools/analysis/radare2 {
    inherit (gnome2) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };

  ragel = ragelStable;

  inherit (callPackages ../development/tools/parsing/ragel {
      tex = texlive.combined.scheme-small;
    }) ragelStable ragelDev;

  hammer = callPackage ../development/tools/parsing/hammer { };

  redis-dump = callPackage ../development/tools/redis-dump {
    ruby = ruby_2_0;
  };

  redo = callPackage ../development/tools/build-managers/redo { };

  reno = callPackage ../development/tools/reno { };

  re2c = callPackage ../development/tools/parsing/re2c { };

  remake = callPackage ../development/tools/build-managers/remake { };

  rhc = callPackage ../development/tools/rhc { };

  rman = callPackage ../development/tools/misc/rman { };

  rolespec = callPackage ../development/tools/misc/rolespec { };

  rr = callPackage ../development/tools/analysis/rr { };

  saleae-logic = callPackage ../development/tools/misc/saleae-logic { };

  sauce-connect = callPackage ../development/tools/sauce-connect { };

  selenium-server-standalone = callPackage ../development/tools/selenium/server { };

  selendroid = callPackage ../development/tools/selenium/selendroid { };

  scons = callPackage ../development/tools/build-managers/scons { };

  sbt = callPackage ../development/tools/build-managers/sbt { };
  simpleBuildTool = sbt;

  shards = callPackage ../development/tools/build-managers/shards { };

  shellcheck = self.haskellPackages.ShellCheck;

  shncpd = callPackage ../tools/networking/shncpd { };

  sigrok-cli = callPackage ../development/tools/sigrok-cli { };

  simpleTpmPk11 = callPackage ../tools/security/simple-tpm-pk11 { };

  slimerjs = callPackage ../development/tools/slimerjs {};

  sloccount = callPackage ../development/tools/misc/sloccount { };

  sloc = nodePackages.sloc;

  smatch = callPackage ../development/tools/analysis/smatch {
    buildllvmsparse = false;
    buildc2xml = false;
  };

  smc = callPackage ../tools/misc/smc { };

  sparse = callPackage ../development/tools/analysis/sparse { };

  speedtest-cli = callPackage ../tools/networking/speedtest-cli { };

  spin = callPackage ../development/tools/analysis/spin { };

  spirv-tools = callPackage ../development/tools/spirv-tools { };

  splint = callPackage ../development/tools/analysis/splint {
    flex = flex_2_5_35;
  };

  sqlitebrowser = callPackage ../development/tools/database/sqlitebrowser { };

  sselp = callPackage ../tools/X11/sselp{ };

  stm32flash = callPackage ../development/tools/misc/stm32flash { };

  strace = callPackage ../development/tools/misc/strace { };

  swarm = callPackage ../development/tools/analysis/swarm { };

  swig1 = callPackage ../development/tools/misc/swig { };
  swig2 = callPackage ../development/tools/misc/swig/2.x.nix { };
  swig3 = callPackage ../development/tools/misc/swig/3.x.nix { };
  swig = swig3;
  swigWithJava = swig;

  swfmill = callPackage ../tools/video/swfmill { };

  swftools = callPackage ../tools/video/swftools { };

  tcptrack = callPackage ../development/tools/misc/tcptrack { };

  teensyduino = arduino-core.override { withGui = true; withTeensyduino = true; };

  teensy-loader-cli = callPackage ../development/tools/misc/teensy-loader-cli { };

  texinfo413 = callPackage ../development/tools/misc/texinfo/4.13a.nix { };
  texinfo4 = texinfo413;
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.2.nix { };
  texinfo6 = callPackage ../development/tools/misc/texinfo/6.3.nix { };
  texinfo = texinfo6;
  texinfoInteractive = appendToName "interactive" (
    texinfo.override { interactive = true; }
  );

  texi2html = callPackage ../development/tools/misc/texi2html { };

  texi2mdoc = callPackage ../tools/misc/texi2mdoc { };

  travis = callPackage ../development/tools/misc/travis { };

  tweak = callPackage ../applications/editors/tweak { };

  uhd = callPackage ../development/tools/misc/uhd { };

  uisp = callPackage ../development/tools/misc/uisp { };

  uncrustify = callPackage ../development/tools/misc/uncrustify { };

  universal-ctags = callPackage ../development/tools/misc/universal-ctags { };

  vagrant = callPackage ../development/tools/vagrant {
    ruby = ruby_2_2;
  };

  bashdb = callPackage ../development/tools/misc/bashdb { };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
    hurd = gnu.hurdCross;
    inherit (gnu) mig;
  };

  gdbGuile = lowPrio (gdb.override { inherit guile; });

  gdbCross = lowPrio (callPackage ../development/tools/misc/gdb {
    target = if targetPlatform != buildPlatform then targetPlatform else null;
  });

  gdb-multitarget = lowPrio (gdb.override { multitarget = true; });

  valgrind = callPackage ../development/tools/analysis/valgrind { };

  valkyrie = callPackage ../development/tools/analysis/valkyrie { };

  verasco = ocaml-ng.ocamlPackages_4_02.verasco.override {
    coq = coq_8_4;
  };

  visualvm = callPackage ../development/tools/java/visualvm { };

  vultr = callPackage ../development/tools/vultr { };

  xc3sprog = callPackage ../development/tools/misc/xc3sprog { };

  xcbuild  = callPackage ../development/tools/xcbuild/wrapper.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices CoreGraphics ImageIO;
    inherit (darwin) cctools bootstrap_cmds binutils;
    stdenv = clangStdenv;
  };

  xmlindent = callPackage ../development/web/xmlindent {};

  xpwn = callPackage ../development/mobile/xpwn {};

  xxdiff = callPackage ../development/tools/misc/xxdiff {
    bison = bison2;
  };

  yacc = bison;

  ycmd = callPackage ../development/tools/misc/ycmd {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    llvmPackages = llvmPackages_39;
    python = python2;
  };

  yodl = callPackage ../development/tools/misc/yodl { };

  winpdb = callPackage ../development/tools/winpdb { };

  grabserial = callPackage ../development/tools/grabserial { };

  mypy-lang = callPackage ../development/tools/mypy-lang { };


  ### DEVELOPMENT / LIBRARIES

  a52dec = callPackage ../development/libraries/a52dec { };

  aacskeys = callPackage ../development/libraries/aacskeys { };

  aalib = callPackage ../development/libraries/aalib { };

  accelio = callPackage ../development/libraries/accelio { stdenv = overrideCC stdenv gcc5; };

  accountsservice = callPackage ../development/libraries/accountsservice { };

  acl = callPackage ../development/libraries/acl { };

  activemq = callPackage ../development/libraries/apache-activemq { };

  adns = callPackage ../development/libraries/adns { };

  afflib = callPackage ../development/libraries/afflib { };

  alure = callPackage ../development/libraries/alure { };

  agg = callPackage ../development/libraries/agg { };

  allegro = callPackage ../development/libraries/allegro {};
  allegro5 = callPackage ../development/libraries/allegro/5.nix {};

  amrnb = callPackage ../development/libraries/amrnb { };

  amrwb = callPackage ../development/libraries/amrwb { };

  appstream = callPackage ../development/libraries/appstream { };

  appstream-glib = callPackage ../development/libraries/appstream-glib { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    bdbSupport = true;
    db = if stdenv.isFreeBSD then db4 else db;
    # XXX: only the db_185 interface was available through
    #      apr with db58 on freebsd (nov 2015), for unknown reasons
  };

  arb = callPackage ../development/libraries/arb {};
  arb-git = callPackage ../development/libraries/arb/git.nix {};

  armadillo = callPackage ../development/libraries/armadillo {};

  assimp = callPackage ../development/libraries/assimp { };

  asio = callPackage ../development/libraries/asio { };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (callPackages ../development/libraries/aspell/dictionaries.nix {});

  attica = callPackage ../development/libraries/attica { };

  attr = callPackage ../development/libraries/attr { };

  at_spi2_core = callPackage ../development/libraries/at-spi2-core { };

  at_spi2_atk = callPackage ../development/libraries/at-spi2-atk { };

  aqbanking = callPackage ../development/libraries/aqbanking { };

  aubio = callPackage ../development/libraries/aubio { };

  audiofile = callPackage ../development/libraries/audiofile {
    inherit (darwin.apple_sdk.frameworks) AudioUnit CoreServices;
  };

  aws-sdk-cpp = callPackage ../development/libraries/aws-sdk-cpp { };

  babl = callPackage ../development/libraries/babl { };

  bctoolbox = callPackage ../development/libraries/bctoolbox {
    mbedtls = mbedtls_1_3;
  };

  beecrypt = callPackage ../development/libraries/beecrypt { };

  beignet = callPackage ../development/libraries/beignet {
    inherit (llvmPackages) llvm clang-unwrapped;
  };

  belle-sip = callPackage ../development/libraries/belle-sip { };

  bobcat = callPackage ../development/libraries/bobcat { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost155 = callPackage ../development/libraries/boost/1.55.nix { };
  boost159 = callPackage ../development/libraries/boost/1.59.nix { };
  boost160 = callPackage ../development/libraries/boost/1.60.nix { };
  boost162 = callPackage ../development/libraries/boost/1.62.nix { };
  boost163 = callPackage ../development/libraries/boost/1.63.nix { };
  boost = boost162;

  boost_process = callPackage ../development/libraries/boost-process { };

  botan = callPackage ../development/libraries/botan { };
  botanUnstable = callPackage ../development/libraries/botan/unstable.nix { };

  box2d = callPackage ../development/libraries/box2d { };

  breakpad = callPackage ../development/libraries/breakpad { };

  buddy = callPackage ../development/libraries/buddy { };

  bwidget = callPackage ../development/libraries/bwidget { };

  c-ares = callPackage ../development/libraries/c-ares {
    fetchurl = fetchurlBoot;
  };

  capnproto = callPackage ../development/libraries/capnproto { };

  ccnx = callPackage ../development/libraries/ccnx { };

  ndn-cxx = callPackage ../development/libraries/ndn-cxx { };

  cddlib = callPackage ../development/libraries/cddlib {};

  cdk = callPackage ../development/libraries/cdk {};

  cimg = callPackage  ../development/libraries/cimg { };

  scmccid = callPackage ../development/libraries/scmccid { };

  ccrtp = callPackage ../development/libraries/ccrtp { };

  ccrtp_1_8 = callPackage ../development/libraries/ccrtp/1.8.nix { };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  cegui = callPackage ../development/libraries/cegui {};

  certbot = callPackage ../tools/admin/certbot { };

  cgal = callPackage ../development/libraries/CGAL {};

  cgui = callPackage ../development/libraries/cgui {};

  check = callPackage ../development/libraries/check {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  chipmunk = callPackage ../development/libraries/chipmunk {};

  chmlib = callPackage ../development/libraries/chmlib { };

  chromaprint = callPackage ../development/libraries/chromaprint { };

  cl = callPackage ../development/libraries/cl { };

  classads = callPackage ../development/libraries/classads { };

  classpath = callPackage ../development/libraries/java/classpath {
    javac = gcj;
    jvm = gcj;
    gconf = gnome2.GConf;
  };

  clearsilver = callPackage ../development/libraries/clearsilver { };

  cln = callPackage ../development/libraries/cln { };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix { };

  clucene_core_1 = callPackage ../development/libraries/clucene-core { };

  clucene_core = clucene_core_1;

  clutter = callPackage ../development/libraries/clutter { };

  clutter-gst = callPackage ../development/libraries/clutter-gst {
  };

  clutter_gtk = callPackage ../development/libraries/clutter-gtk { };

  cminpack = callPackage ../development/libraries/cminpack { };

  cmocka = callPackage ../development/libraries/cmocka { };

  cogl = callPackage ../development/libraries/cogl { };

  coin3d = callPackage ../development/libraries/coin3d { };

  CoinMP = callPackage ../development/libraries/CoinMP { };

  commoncpp2 = callPackage ../development/libraries/commoncpp2 { };

  confuse = callPackage ../development/libraries/confuse { };

  coredumper = callPackage ../development/libraries/coredumper { };

  ctl = callPackage ../development/libraries/ctl { };

  ctpp2 = callPackage ../development/libraries/ctpp2 { };

  ctpl = callPackage ../development/libraries/ctpl { };

  cppdb = callPackage ../development/libraries/cppdb { };

  cpp-hocon = callPackage ../development/libraries/cpp-hocon { };

  cpp-ipfs-api = callPackage ../development/libraries/cpp-ipfs-api { };

  cpp-netlib = callPackage ../development/libraries/cpp-netlib { };
  uri = callPackage ../development/libraries/uri { };

  cppcms = callPackage ../development/libraries/cppcms { };

  cppunit = callPackage ../development/libraries/cppunit { };

  cpputest = callPackage ../development/libraries/cpputest { };

  cracklib = callPackage ../development/libraries/cracklib { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  curlcpp = callPackage ../development/libraries/curlcpp { };

  cutee = callPackage ../development/libraries/cutee { };

  cxxtools = callPackage ../development/libraries/cxxtools { };

  cwiid = callPackage ../development/libraries/cwiid { };

  cxx-prettyprint = callPackage ../development/libraries/cxx-prettyprint { };

  cxxtest = callPackage ../development/libraries/cxxtest { };

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

  dbus = callPackage ../development/libraries/dbus { };
  dbus_cplusplus  = callPackage ../development/libraries/dbus-cplusplus { };
  dbus_glib       = callPackage ../development/libraries/dbus-glib { };
  dbus_java       = callPackage ../development/libraries/java/dbus-java { };

  dbus-sharp-1_0 = callPackage ../development/libraries/dbus-sharp/dbus-sharp-1.0.nix { };
  dbus-sharp-2_0 = callPackage ../development/libraries/dbus-sharp { };

  dbus-sharp-glib-1_0 = callPackage ../development/libraries/dbus-sharp-glib/dbus-sharp-glib-1.0.nix { };
  dbus-sharp-glib-2_0 = callPackage ../development/libraries/dbus-sharp-glib { };

  # FIXME: deprecate these.
  dbus_tools = dbus.out;
  dbus_libs = dbus;
  dbus_daemon = dbus.daemon;

  makeDBusConf = { suidHelper, serviceDirectories }:
    callPackage ../development/libraries/dbus/make-dbus-conf.nix {
      inherit suidHelper serviceDirectories;
    };

  dee = callPackage ../development/libraries/dee { };

  dhex = callPackage ../applications/editors/dhex { };

  double_conversion = callPackage ../development/libraries/double-conversion { };

  dclib = callPackage ../development/libraries/dclib { };

  dillo = callPackage ../applications/networking/browsers/dillo {
    fltk = fltk13;
  };

  dirac = callPackage ../development/libraries/dirac { };

  directfb = callPackage ../development/libraries/directfb { };

  dlib = callPackage ../development/libraries/dlib { };

  dotconf = callPackage ../development/libraries/dotconf { };

  dssi = callPackage ../development/libraries/dssi {};

  dxflib = callPackage ../development/libraries/dxflib {};

  eclib = callPackage ../development/libraries/eclib {};

  eigen = callPackage ../development/libraries/eigen {};
  eigen3_3 = callPackage ../development/libraries/eigen/3.3.nix {};

  eigen2 = callPackage ../development/libraries/eigen/2.0.nix {};

  vmmlib = callPackage ../development/libraries/vmmlib {};

  enchant = callPackage ../development/libraries/enchant { };

  enet = callPackage ../development/libraries/enet { };

  enginepkcs11 = callPackage ../development/libraries/enginepkcs11 { };

  epoxy = callPackage ../development/libraries/epoxy {};

  esdl = callPackage ../development/libraries/esdl { };

  exiv2 = callPackage ../development/libraries/exiv2 { };

  expat = callPackage ../development/libraries/expat { };

  eventlog = callPackage ../development/libraries/eventlog { };

  facile = callPackage ../development/libraries/facile { };

  faac = callPackage ../development/libraries/faac { };

  faad2 = callPackage ../development/libraries/faad2 { };

  factor-lang = callPackage ../development/compilers/factor-lang {
    inherit (pkgs.gnome2) gtkglext;
  };

  farbfeld = callPackage ../development/libraries/farbfeld { };

  farsight2 = callPackage ../development/libraries/farsight2 { };

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
      gst-libav;
    inherit (pythonPackages) gst-python;
  };

  fcgi = callPackage ../development/libraries/fcgi { };

  ffcast = callPackage ../tools/X11/ffcast { };

  fflas-ffpack = callPackage ../development/libraries/fflas-ffpack {};
  fflas-ffpack_1 = callPackage ../development/libraries/fflas-ffpack/1.nix {};

  ffmpeg_0_10 = callPackage ../development/libraries/ffmpeg/0.10.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_1_2 = callPackage ../development/libraries/ffmpeg/1.2.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_2_8 = callPackage ../development/libraries/ffmpeg/2.8.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_3_1 = callPackage ../development/libraries/ffmpeg/3.1.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };
  ffmpeg_3_2 = callPackage ../development/libraries/ffmpeg/3.2.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
  };
  # Aliases
  ffmpeg_0 = ffmpeg_0_10;
  ffmpeg_1 = ffmpeg_1_2;
  ffmpeg_2 = ffmpeg_2_8;
  ffmpeg_3 = ffmpeg_3_1;
  ffmpeg = ffmpeg_3;

  ffmpeg-full = callPackage ../development/libraries/ffmpeg-full {
    # The following need to be fixed on Darwin
    frei0r = if stdenv.isDarwin then null else frei0r;
    game-music-emu = if stdenv.isDarwin then null else game-music-emu;
    libjack2 = if stdenv.isDarwin then null else libjack2;
    libmodplug = if stdenv.isDarwin then null else libmodplug;
    libvpx = if stdenv.isDarwin then null else libvpx;
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

  ffmpeg-sixel = callPackage ../development/libraries/ffmpeg-sixel { };

  ffms = callPackage ../development/libraries/ffms {
    ffmpeg = ffmpeg_2;
  };

  fftw = callPackage ../development/libraries/fftw { };
  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwFloat = fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = fftw.override { precision = "long-double"; };

  filter-audio = callPackage ../development/libraries/filter-audio {};

  flann = callPackage ../development/libraries/flann { };

  flint = callPackage ../development/libraries/flint { };

  flite = callPackage ../development/libraries/flite { };

  fltk13 = callPackage ../development/libraries/fltk { };
  fltk = self.fltk13;

  fplll = callPackage ../development/libraries/fplll {};
  fplll_20160331 = callPackage ../development/libraries/fplll/20160331.nix {};

  freeimage = callPackage ../development/libraries/freeimage { };

  freetts = callPackage ../development/libraries/freetts { };

  cfitsio = callPackage ../development/libraries/cfitsio { };

  fontconfig_210 = callPackage ../development/libraries/fontconfig/2.10.nix { };

  fontconfig = callPackage ../development/libraries/fontconfig { };

  fontconfig-ultimate = callPackage ../development/libraries/fontconfig-ultimate {};

  folly = callPackage ../development/libraries/folly { };

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

  freenect = callPackage ../development/libraries/freenect { };

  freetype = callPackage ../development/libraries/freetype { };

  frei0r = callPackage ../development/libraries/frei0r { };

  fribidi = callPackage ../development/libraries/fribidi { };

  funambol = callPackage ../development/libraries/funambol { };

  fam = gamin;

  gamin = callPackage ../development/libraries/gamin { };

  ganv = callPackage ../development/libraries/ganv { };

  gcab = callPackage ../development/libraries/gcab { };

  gdome2 = callPackage ../development/libraries/gdome2 {
    inherit (gnome2) gtkdoc;
  };

  gdbm = callPackage ../development/libraries/gdbm { };

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_4 = callPackage ../development/libraries/gecode { };
  gecode = gecode_4;

  gephi = callPackage ../applications/science/misc/gephi { };

  gegl = callPackage ../development/libraries/gegl {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  gegl_0_3 = callPackage ../development/libraries/gegl/3.0.nix {
    gtk = self.gtk2;
  };

  geoclue = callPackage ../development/libraries/geoclue {};

  geoclue2 = callPackage ../development/libraries/geoclue/2.0.nix {};

  geoipWithDatabase = makeOverridable (callPackage ../development/libraries/geoip) {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  geoipjava = callPackage ../development/libraries/java/geoipjava { };

  geos = callPackage ../development/libraries/geos { };

  getdata = callPackage ../development/libraries/getdata { };

  gettext = callPackage ../development/libraries/gettext { };

  gf2x = callPackage ../development/libraries/gf2x {};

  gd = callPackage ../development/libraries/gd {
    libtiff = null;
    libXpm = null;
  };

  gdal = callPackage ../development/libraries/gdal { };

  gdal_1_11 = callPackage ../development/libraries/gdal/gdal-1_11.nix { };

  gdcm = callPackage ../development/libraries/gdcm { };

  ggz_base_libs = callPackage ../development/libraries/ggz_base_libs {};

  giblib = callPackage ../development/libraries/giblib { };

  gio-sharp = callPackage ../development/libraries/gio-sharp { };

  givaro = callPackage ../development/libraries/givaro {};
  givaro_3 = callPackage ../development/libraries/givaro/3.nix {};
  givaro_3_7 = callPackage ../development/libraries/givaro/3.7.nix {};

  icon-lang = callPackage ../development/interpreters/icon-lang { };

  libgit2 = callPackage ../development/libraries/git2 (
    stdenv.lib.optionalAttrs stdenv.isDarwin {
      inherit (darwin) libiconv;
    }
  );

  gle = callPackage ../development/libraries/gle { };

  glew = callPackage ../development/libraries/glew { };
  glew110 = callPackage ../development/libraries/glew/1.10.nix {
    inherit (darwin.apple_sdk.frameworks) AGL;
  };

  glfw = glfw3;
  glfw2 = callPackage ../development/libraries/glfw/2.x.nix { };
  glfw3 = callPackage ../development/libraries/glfw/3.x.nix { };

  glibc = callPackage ../development/libraries/glibc {
    installLocales = config.glibc.locales or false;
    gccCross = null;
  };

  glibc_memusage = callPackage ../development/libraries/glibc {
    installLocales = false;
    withGd = true;
  };

  glibcCross = forcedNativePackages.glibc.override {
    gccCross = gccCrossStageStatic;
    linuxHeaders = linuxHeadersCross;
  };

  # We can choose:
  libcCrossChooser = name: if name == "glibc" then glibcCross
    else if name == "uclibc" then uclibcCross
    else if name == "msvcrt" then windows.mingw_w64
    else if name == "libSystem" then darwin.xcode
    else throw "Unknown libc";

  libcCross = assert targetPlatform != buildPlatform; libcCrossChooser targetPlatform.libc;

  # Only supported on Linux
  glibcLocales = if stdenv.isLinux then callPackage ../development/libraries/glibc/locales.nix { } else null;

  glibcInfo = callPackage ../development/libraries/glibc/info.nix { };

  glibc_multi = callPackage ../development/libraries/glibc/multi.nix {
    glibc32 = pkgsi686Linux.glibc;
  };

  glm = callPackage ../development/libraries/glm { };
  glm_0954 = callPackage ../development/libraries/glm/0954.nix { };

  globalplatform = callPackage ../development/libraries/globalplatform { };
  gppcscconnectionplugin =
    callPackage ../development/libraries/globalplatform/gppcscconnectionplugin.nix { };

  glog = callPackage ../development/libraries/glog { };

  gloox = callPackage ../development/libraries/gloox { };

  glpk = callPackage ../development/libraries/glpk { };

  inherit (ocamlPackages) glsurf;

  glui = callPackage ../development/libraries/glui {};

  gmime = callPackage ../development/libraries/gmime { };

  gmm = callPackage ../development/libraries/gmm { };

  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { }; # required by older GHC versions
  gmp5 = callPackage ../development/libraries/gmp/5.1.x.nix { };
  gmp6 = callPackage ../development/libraries/gmp/6.x.nix { };
  gmp = gmp6;
  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr/default.nix { };

  mpfi = callPackage ../development/libraries/mpfi { };

  # A GMP fork
  mpir = callPackage ../development/libraries/mpir {};

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
    inherit (darwin) cctools;
    python = python2;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };

  google-gflags = callPackage ../development/libraries/google-gflags { };

  gperftools = callPackage ../development/libraries/gperftools { };

  grib-api = callPackage ../development/libraries/grib-api { };

  gst_all_1 = recurseIntoAttrs(callPackage ../development/libraries/gstreamer {
    callPackage = pkgs.newScope (pkgs // { libav = pkgs.ffmpeg; });
  });

  gst_all = {
    inherit (pkgs) gstreamer gnonlin gst_python qt_gstreamer;
    gstPluginsBase = pkgs.gst_plugins_base;
    gstPluginsBad = pkgs.gst_plugins_bad;
    gstPluginsGood = pkgs.gst_plugins_good;
    gstPluginsUgly = pkgs.gst_plugins_ugly;
    gstFfmpeg = pkgs.gst_ffmpeg;

    # aliases with the dashed naming, same as in gst_all_1
    gst-plugins-base = pkgs.gst_plugins_base;
    gst-plugins-bad = pkgs.gst_plugins_bad;
    gst-plugins-good = pkgs.gst_plugins_good;
    gst-plugins-ugly = pkgs.gst_plugins_ugly;
    gst-ffmpeg = pkgs.gst_ffmpeg;
    gst-python = pkgs.gst_python;
  };

  gstreamer = callPackage ../development/libraries/gstreamer/legacy/gstreamer {
    bison = bison2;
  };

  gst_plugins_base = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-base {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  gst_plugins_good = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-good {};

  gst_plugins_bad = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-bad {};

  gst_plugins_ugly = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-ugly {};

  gst_ffmpeg = callPackage ../development/libraries/gstreamer/legacy/gst-ffmpeg {
    ffmpeg = ffmpeg_0;
  };

  gst_python = callPackage ../development/libraries/gstreamer/legacy/gst-python {};

  gstreamermm = callPackage ../development/libraries/gstreamer/legacy/gstreamermm { };

  gnonlin = callPackage ../development/libraries/gstreamer/legacy/gnonlin {};

  gusb = callPackage ../development/libraries/gusb {
    inherit (gnome2) gtkdoc;
  };

  qt-mobility = callPackage ../development/libraries/qt-mobility {};

  qt_gstreamer = callPackage ../development/libraries/gstreamer/legacy/qt-gstreamer {};

  qt_gstreamer1 = callPackage ../development/libraries/gstreamer/qt-gstreamer { boost = boost155;};

  gnet = callPackage ../development/libraries/gnet { };

  gnu-config = callPackage ../development/libraries/gnu-config { };

  gnu-efi = callPackage ../development/libraries/gnu-efi { };

  gnutls = gnutls34;

  gnutls34 = callPackage ../development/libraries/gnutls/3.4.nix {
    guileBindings = config.gnutls.guile or false;
  };

  gnutls35 = callPackage ../development/libraries/gnutls/3.5.nix {
    guileBindings = config.gnutls.guile or false;
  };

  gpac = callPackage ../applications/video/gpac { };

  gpgme = callPackage ../development/libraries/gpgme {
    gnupg1 = gnupg1orig;
  };

  pgpdump = callPackage ../tools/security/pgpdump { };

  gpgstats = callPackage ../tools/security/gpgstats { };

  gpshell = callPackage ../development/tools/misc/gpshell { };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsl_1 = callPackage ../development/libraries/gsl/gsl-1_16.nix { };

  gsm = callPackage ../development/libraries/gsm {};

  gsoap = callPackage ../development/libraries/gsoap { };

  gss = callPackage ../development/libraries/gss { };

  gtkimageview = callPackage ../development/libraries/gtkimageview { };

  gtkmathview = callPackage ../development/libraries/gtkmathview { };

  glib = callPackage ../development/libraries/glib {
  };
  glib-tested = glib.override { # checked version separate to break cycles
    doCheck = true;
    libffi = libffi.override { doCheck = true; };
  };
  glibmm = callPackage ../development/libraries/glibmm { };

  glib_networking = callPackage ../development/libraries/glib-networking {};

  ace = callPackage ../development/libraries/ace { };

  atk = callPackage ../development/libraries/atk { };

  atkmm = callPackage ../development/libraries/atkmm { };

  pixman = callPackage ../development/libraries/pixman { };

  cairo = callPackage ../development/libraries/cairo {
    glSupport = config.cairo.gl or (stdenv.isLinux &&
      !stdenv.isArm && !stdenv.isMips);
  };


  cairomm = callPackage ../development/libraries/cairomm { };

  pango = callPackage ../development/libraries/pango { };
  pangomm = callPackage ../development/libraries/pangomm {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pangox_compat = callPackage ../development/libraries/pangox-compat { };

  gdata-sharp = callPackage ../development/libraries/gdata-sharp { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gnome-sharp = callPackage ../development/libraries/gnome-sharp {};

  granite = callPackage ../development/libraries/granite { };

  gtk2 = callPackage ../development/libraries/gtk+/2.x.nix {
    cupsSupport = config.gtk2.cups or stdenv.isLinux;
    gdktarget = if stdenv.isDarwin then "quartz" else "x11";
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gtk2-x11 = gtk2.override {
    gdktarget = "x11";
  };

  gtk3 = callPackage ../development/libraries/gtk+/3.x.nix { };

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

  gtk-sharp-beans = callPackage ../development/libraries/gtk-sharp-beans { };

  gtk-mac-integration = callPackage ../development/libraries/gtk-mac-integration {
    gtk = gtk2;
  };

  gtk-mac-bundler = callPackage ../development/tools/gtk-mac-bundler {};

  gtkspell2 = callPackage ../development/libraries/gtkspell { };

  gtkspell3 = callPackage ../development/libraries/gtkspell/3.nix { };

  gtkspellmm = callPackage ../development/libraries/gtkspellmm { };

  gts = callPackage ../development/libraries/gts { };

  gvfs = callPackage ../development/libraries/gvfs {
    gnome = self.gnome3;
  };

  gwenhywfar = callPackage ../development/libraries/aqbanking/gwenhywfar.nix { };

  hamlib = callPackage ../development/libraries/hamlib { };

  # TODO : Let admin choose.
  # We are using mit-krb5 because it is better maintained
  kerberos = libkrb5;

  heimdalFull = callPackage ../development/libraries/kerberos/heimdal.nix { };
  libheimdal = heimdalFull.override { type = "lib"; };

  harfbuzz = callPackage ../development/libraries/harfbuzz { };
  harfbuzz-icu = callPackage ../development/libraries/harfbuzz {
    withIcu = true;
    withGraphite2 = true;
  };

  hawknl = callPackage ../development/libraries/hawknl { };

  haxor-news = callPackage ../applications/misc/haxor-news { };

  herqq = callPackage ../development/libraries/herqq { };

  heyefi = haskellPackages.heyefi;

  hidapi = callPackage ../development/libraries/hidapi {
    libusb = libusb1;
  };

  hiredis = callPackage ../development/libraries/hiredis { };

  hivex = callPackage ../development/libraries/hivex {
    inherit (perlPackages) IOStringy;
  };

  hound = callPackage ../development/tools/misc/hound { };

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

  hydra = callPackage ../development/tools/misc/hydra { stdenv = overrideCC stdenv gcc6; };

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  hyena = callPackage ../development/libraries/hyena { };

  icu = callPackage ../development/libraries/icu { };

  id3lib = callPackage ../development/libraries/id3lib { };

  ilbc = callPackage ../development/libraries/ilbc { };

  ilixi = callPackage ../development/libraries/ilixi { };

  ilmbase = callPackage ../development/libraries/ilmbase { };

  imlib = callPackage ../development/libraries/imlib {
    libpng = libpng12;
  };

  imv = callPackage ../applications/graphics/imv/default.nix { };

  iml = callPackage ../development/libraries/iml { };

  imlib2 = callPackage ../development/libraries/imlib2 { };
  imlib2-nox = imlib2.override {
    x11Support = false;
  };

  imlibsetroot = callPackage ../applications/graphics/imlibsetroot { libXinerama = xorg.libXinerama; } ;

  ijs = callPackage ../development/libraries/ijs { };

  incrtcl = callPackage ../development/libraries/incrtcl { };

  indicator-application-gtk2 = callPackage ../development/libraries/indicator-application/gtk2.nix { };
  indicator-application-gtk3 = callPackage ../development/libraries/indicator-application/gtk3.nix { };

  indilib = callPackage ../development/libraries/indilib { };

  iniparser = callPackage ../development/libraries/iniparser { };

  intltool = callPackage ../development/tools/misc/intltool { };

  ios-cross-compile = callPackage ../development/compilers/ios-cross-compile/9.2.nix {};

  ip2location-c = callPackage ../development/libraries/ip2location-c { };

  irrlicht = callPackage ../development/libraries/irrlicht { };
  irrlicht3843 = callPackage ../development/libraries/irrlicht/irrlicht3843.nix { };

  isocodes = callPackage ../development/libraries/iso-codes { };

  ispc = callPackage ../development/compilers/ispc {
    llvmPackages = llvmPackages_39;
  };

  itk = callPackage ../development/libraries/itk { };

  jasper = callPackage ../development/libraries/jasper { };

  jama = callPackage ../development/libraries/jama { };

  jansson = callPackage ../development/libraries/jansson { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jbigkit = callPackage ../development/libraries/jbigkit { };

  jemalloc = callPackage ../development/libraries/jemalloc { };

  jshon = callPackage ../development/tools/parsing/jshon { };

  json_glib = callPackage ../development/libraries/json-glib { };

  json-c-0-11 = callPackage ../development/libraries/json-c/0.11.nix { }; # vulnerable
  json_c = callPackage ../development/libraries/json-c { };

  jsoncpp = callPackage ../development/libraries/jsoncpp { };

  jsonnet = callPackage ../development/compilers/jsonnet {
    emscripten = emscripten.override {python=python2;};
  };

  libjson = callPackage ../development/libraries/libjson { };

  libb64 = callPackage ../development/libraries/libb64 { };

  judy = callPackage ../development/libraries/judy { };

  keybinder = callPackage ../development/libraries/keybinder {
    automake = automake111x;
    lua = lua5_1;
  };

  keybinder3 = callPackage ../development/libraries/keybinder3 {
    automake = automake111x;
  };

  kinetic-cpp-client = callPackage ../development/libraries/kinetic-cpp-client { };

  krb5Full = callPackage ../development/libraries/kerberos/krb5.nix {
    inherit (darwin) bootstrap_cmds;
  };
  libkrb5 = krb5Full.override { type = "lib"; };

  lasso = callPackage ../development/libraries/lasso { };

  LASzip = callPackage ../development/libraries/LASzip { };

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  ldb = callPackage ../development/libraries/ldb {
    python = python2;
  };

  lensfun = callPackage ../development/libraries/lensfun {};

  lesstif = callPackage ../development/libraries/lesstif { };

  leveldb = callPackage ../development/libraries/leveldb { };

  lmdb = callPackage ../development/libraries/lmdb { };

  levmar = callPackage ../development/libraries/levmar { };

  leptonica = callPackage ../development/libraries/leptonica {
    libpng = libpng12;
  };

  lib3ds = callPackage ../development/libraries/lib3ds { };

  libaacs = callPackage ../development/libraries/libaacs { };

  libaal = callPackage ../development/libraries/libaal { };

  libaccounts-glib = callPackage ../development/libraries/libaccounts-glib { };

  libagar = callPackage ../development/libraries/libagar { };
  libagar_test = callPackage ../development/libraries/libagar/libagar_test.nix { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or true;
    inherit (darwin.apple_sdk.frameworks) CoreAudio CoreServices AudioUnit;
  };

  libabw = callPackage ../development/libraries/libabw { };

  libantlr3c = callPackage ../development/libraries/libantlr3c {};

  libappindicator-gtk2 = callPackage ../development/libraries/libappindicator { gtkVersion = "2"; };
  libappindicator-gtk3 = callPackage ../development/libraries/libappindicator { gtkVersion = "3"; };

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

  libbluedevil = callPackage ../development/libraries/libbluedevil { };

  libbdplus = callPackage ../development/libraries/libbdplus { };

  libbluray = callPackage ../development/libraries/libbluray { };

  libbs2b = callPackage ../development/libraries/audio/libbs2b { };

  libbson = callPackage ../development/libraries/libbson { };

  libburn = callPackage ../development/libraries/libburn { };

  libcaca = callPackage ../development/libraries/libcaca {
    inherit (xlibs) libX11 libXext;
  };

  libcanberra_gtk3 = callPackage ../development/libraries/libcanberra {
    gtk = pkgs.gtk3;
  };
  libcanberra_gtk2 = pkgs.libcanberra_gtk3.override { gtk = pkgs.gtk2; };

  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then pkgs.libcanberra_gtk2.override { gtk = null; }
    else pkgs.libcanberra_gtk2;

  libcec = callPackage ../development/libraries/libcec { };
  libcec_platform = callPackage ../development/libraries/libcec/platform.nix { };

  libcello = callPackage ../development/libraries/libcello {};

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio { };
  libcdio082 = callPackage ../development/libraries/libcdio/0.82.nix { };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome2) libsoup;
  };

  libchardet = callPackage ../development/libraries/libchardet { };

  libchewing = callPackage ../development/libraries/libchewing { };

  libchipcard = callPackage ../development/libraries/aqbanking/libchipcard.nix { };

  libcrafter = callPackage ../development/libraries/libcrafter { };

  libcrossguid = callPackage ../development/libraries/libcrossguid { };

  libuchardet = callPackage ../development/libraries/libuchardet { };

  libchop = callPackage ../development/libraries/libchop { };

  libclc = callPackage ../development/libraries/libclc { };

  libcli = callPackage ../development/libraries/libcli { };

  libclthreads = callPackage ../development/libraries/libclthreads  { };

  libclxclient = callPackage ../development/libraries/libclxclient  { };

  libcm = callPackage ../development/libraries/libcm { };

  libconfuse = callPackage ../development/libraries/libconfuse { };

  inherit (gnome3) libcroco;

  libcangjie = callPackage ../development/libraries/libcangjie { };

  libcollectdclient = callPackage ../development/libraries/libcollectdclient { };

  libcredis = callPackage ../development/libraries/libcredis { };

  libctemplate = callPackage ../development/libraries/libctemplate { };

  libctemplate_2_2 = callPackage ../development/libraries/libctemplate/2.2.nix { };

  libcouchbase = callPackage ../development/libraries/libcouchbase { };

  libcue = callPackage ../development/libraries/libcue { };

  libcutl = callPackage ../development/libraries/libcutl { };

  libdaemon = callPackage ../development/libraries/libdaemon { };

  libdap = callPackage ../development/libraries/libdap { };

  libdbi = callPackage ../development/libraries/libdbi { };

  libdbiDriversBase = callPackage ../development/libraries/libdbi-drivers {
    libmysql = null;
    sqlite = null;
  };

  libdbiDrivers = libdbiDriversBase.override {
    inherit sqlite libmysql;
  };

  libdbusmenu-glib = callPackage ../development/libraries/libdbusmenu { };
  libdbusmenu-gtk2 = callPackage ../development/libraries/libdbusmenu { gtkVersion = "2"; };
  libdbusmenu-gtk3 = callPackage ../development/libraries/libdbusmenu { gtkVersion = "3"; };

  libdbusmenu_qt = callPackage ../development/libraries/libdbusmenu-qt { };

  libdc1394 = callPackage ../development/libraries/libdc1394 {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  libdevil = callPackage ../development/libraries/libdevil {
    inherit (darwin.apple_sdk.frameworks) OpenGL;
  };

  libdevil-nox = libdevil.override {
    libX11 = null;
    mesa_noglu = null;
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

  libetpan = callPackage ../development/libraries/libetpan { };

  libfaketime = callPackage ../development/libraries/libfaketime { };

  libfakekey = callPackage ../development/libraries/libfakekey { };

  libfilezilla = callPackage ../development/libraries/libfilezilla { };

  libfm = callPackage ../development/libraries/libfm { };
  libfm-extra = callPackage ../development/libraries/libfm {
    extraOnly = true;
  };

  libfprint = callPackage ../development/libraries/libfprint { };

  libfpx = callPackage ../development/libraries/libfpx { };

  libgadu = callPackage ../development/libraries/libgadu { };

  libgap = callPackage ../development/libraries/libgap { };

  libgdata = gnome3.libgdata;

  libgee_0_6 = callPackage ../development/libraries/libgee/0.6.nix { };

  libgee_0_8 = callPackage ../development/libraries/libgee/0.8.nix { };

  libgig = callPackage ../development/libraries/libgig { };

  libgnome_keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome_keyring3 = gnome3.libgnome_keyring;

  libglvnd = callPackage ../development/libraries/libglvnd { };

  libgnurl = callPackage ../development/libraries/libgnurl { };

  libgringotts = callPackage ../development/libraries/libgringotts { };

  libgroove = callPackage ../development/libraries/libgroove { };

  libseccomp = callPackage ../development/libraries/libseccomp { };

  libsecret = callPackage ../development/libraries/libsecret { };

  libserialport = callPackage ../development/libraries/libserialport { };

  libsoundio = callPackage ../development/libraries/libsoundio { };

  libgtop = callPackage ../development/libraries/libgtop {};

  libLAS = callPackage ../development/libraries/libLAS { };

  liblaxjson = callPackage ../development/libraries/liblaxjson { };

  liblo = callPackage ../development/libraries/liblo { };

  liblrdf = librdf;

  liblscp = callPackage ../development/libraries/liblscp { };

  libe-book = callPackage ../development/libraries/libe-book {};

  libechonest = callPackage ../development/libraries/libechonest { };

  libev = callPackage ../development/libraries/libev {
    fetchurl = fetchurlBoot;
  };

  libevent = callPackage ../development/libraries/libevent { };

  libewf = callPackage ../development/libraries/libewf { };

  libexif = callPackage ../development/libraries/libexif { };

  libexosip = callPackage ../development/libraries/exosip {};

  libexosip_3 = callPackage ../development/libraries/exosip/3.x.nix {
    libosip = libosip_3;
  };

  libextractor = callPackage ../development/libraries/libextractor {
    libmpeg2 = mpeg2dec;
  };

  libexttextcat = callPackage ../development/libraries/libexttextcat {};

  libf2c = callPackage ../development/libraries/libf2c {};

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

  libgphoto2 = callPackage ../development/libraries/libgphoto2 { };

  libgpod = callPackage ../development/libraries/libgpod {
    inherit (pkgs.pythonPackages) mutagen;
    monoSupport = false;
  };

  libgsystem = callPackage ../development/libraries/libgsystem { };

  libgudev = callPackage ../development/libraries/libgudev { };

  libguestfs = callPackage ../development/libraries/libguestfs {
    inherit (perlPackages) libintlperl GetoptLong SysVirt;
  };

  libgumbo = callPackage ../development/libraries/libgumbo { };

  libhangul = callPackage ../development/libraries/libhangul { };

  libharu = callPackage ../development/libraries/libharu { };

  libhttpseverywhere = callPackage ../development/libraries/libhttpseverywhere { };

  libHX = callPackage ../development/libraries/libHX { };

  libibmad = callPackage ../development/libraries/libibmad { };

  libibumad = callPackage ../development/libraries/libibumad { };

  libical = callPackage ../development/libraries/libical { };

  libicns = callPackage ../development/libraries/libicns { };

  libimobiledevice = callPackage ../development/libraries/libimobiledevice { };

  libindicate-gtk2 = callPackage ../development/libraries/libindicate { gtkVersion = "2"; };
  libindicate-gtk3 = callPackage ../development/libraries/libindicate { gtkVersion = "3"; };

  libindicator-gtk2 = callPackage ../development/libraries/libindicator { gtkVersion = "2"; };
  libindicator-gtk3 = callPackage ../development/libraries/libindicator { gtkVersion = "3"; };

  libiodbc = callPackage ../development/libraries/libiodbc {
    useGTK = config.libiodbc.gtk or false;
  };

  libivykis = callPackage ../development/libraries/libivykis { };

  liblastfmSF = callPackage ../development/libraries/liblastfmSF { };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  liblqr1 = callPackage ../development/libraries/liblqr-1 { };

  liblockfile = callPackage ../development/libraries/liblockfile { };

  liblogging = callPackage ../development/libraries/liblogging { };

  liblognorm = callPackage ../development/libraries/liblognorm { };

  libltc = callPackage ../development/libraries/libltc { };

  libmaxminddb = callPackage ../development/libraries/libmaxminddb { };

  libmcrypt = callPackage ../development/libraries/libmcrypt {};

  libmediainfo = callPackage ../development/libraries/libmediainfo { };

  libmhash = callPackage ../development/libraries/libmhash {};

  libmodbus = callPackage ../development/libraries/libmodbus {};

  libmtp = callPackage ../development/libraries/libmtp { };

  libmsgpack = callPackage ../development/libraries/libmsgpack { };
  libmsgpack_1_4 = callPackage ../development/libraries/libmsgpack/1.4.nix { };

  libmysqlconnectorcpp = callPackage ../development/libraries/libmysqlconnectorcpp {
    mysql = mysql57;
  };

  libnatspec = callPackage ../development/libraries/libnatspec (
    stdenv.lib.optionalAttrs stdenv.isDarwin {
      inherit (darwin) libiconv;
    }
  );

  libndp = callPackage ../development/libraries/libndp { };

  libnfc = callPackage ../development/libraries/libnfc { };

  libnfsidmap = callPackage ../development/libraries/libnfsidmap { };

  libnice = callPackage ../development/libraries/libnice { };

  liboping = callPackage ../development/libraries/liboping { };

  libplist = callPackage ../development/libraries/libplist { };

  libqglviewer = callPackage ../development/libraries/libqglviewer { };

  libre = callPackage ../development/libraries/libre {};
  librem = callPackage ../development/libraries/librem {};

  librelp = callPackage ../development/libraries/librelp { };

  librepo = callPackage ../tools/package-management/librepo { };

  libresample = callPackage ../development/libraries/libresample {};

  librevenge = callPackage ../development/libraries/librevenge {};

  librevisa = callPackage ../development/libraries/librevisa { };

  libsamplerate = callPackage ../development/libraries/libsamplerate {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices Carbon CoreServices;
  };

  libsieve = callPackage ../development/libraries/libsieve { };

  libsixel = callPackage ../development/libraries/libsixel { };

  libsolv = callPackage ../development/libraries/libsolv { };

  libspectre = callPackage ../development/libraries/libspectre { };

  libgsf = callPackage ../development/libraries/libgsf { };

  # glibc provides libiconv so systems with glibc don't need to build libiconv
  # separately, but we also provide libiconvReal, which will always be a
  # standalone libiconv, just in case you want it
  libiconv = if stdenv ? cross then
    (if stdenv.cross.libc == "glibc" then libcCross
      else if stdenv.cross.libc == "libSystem" then darwin.libiconv
      else libiconvReal)
    else if stdenv.isGlibc then glibcIconv stdenv.cc.libc
    else if stdenv.isDarwin then darwin.libiconv
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
  libintlOrEmpty = stdenv.lib.optional (!stdenv.isLinux) gettext;

  libid3tag = callPackage ../development/libraries/libid3tag {
    gperf = gperf_3_0;
  };

  libidn = callPackage ../development/libraries/libidn { };

  libidn2 = callPackage ../development/libraries/libidn2 { };

  idnkit = callPackage ../development/libraries/idnkit { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libinfinity = callPackage ../development/libraries/libinfinity {
    inherit (gnome2) gtkdoc;
  };

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  libisofs = callPackage ../development/libraries/libisofs { };

  libisoburn = callPackage ../development/libraries/libisoburn { };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjpeg_original = callPackage ../development/libraries/libjpeg { };
  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };
  libjpeg_drop = callPackage ../development/libraries/libjpeg-drop { };
  libjpeg = if stdenv.isLinux then libjpeg_turbo else libjpeg_original; # some problems, both on FreeBSD and Darwin

  libjreen = callPackage ../development/libraries/libjreen { };

  libjson_rpc_cpp = callPackage ../development/libraries/libjson-rpc-cpp { };

  libjson_rpc_cpp_0_2_1 = callPackage ../development/libraries/libjson-rpc-cpp/0.2.1 { };

  libkate = callPackage ../development/libraries/libkate { };

  libksba = callPackage ../development/libraries/libksba { };

  libksi = callPackage ../development/libraries/libksi { };

  libmad = callPackage ../development/libraries/libmad { };

  libmatchbox = callPackage ../development/libraries/libmatchbox { };

  libmatheval = callPackage ../development/libraries/libmatheval { };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmatroska = callPackage ../development/libraries/libmatroska { };

  libmcs = callPackage ../development/libraries/libmcs { };

  libmd = callPackage ../development/libraries/libmd { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
  };

  libmilter = callPackage ../development/libraries/libmilter { };

  libminc = callPackage ../development/libraries/libminc { };

  libmkv = callPackage ../development/libraries/libmkv { };

  libmms = callPackage ../development/libraries/libmms { };

  libmowgli = callPackage ../development/libraries/libmowgli { };

  libmng = callPackage ../development/libraries/libmng { };

  libmnl = callPackage ../development/libraries/libmnl { };

  libmodplug = callPackage ../development/libraries/libmodplug {};

  libmpcdec = callPackage ../development/libraries/libmpcdec { };

  libmp3splt = callPackage ../development/libraries/libmp3splt { };

  libmrss = callPackage ../development/libraries/libmrss { };

  libmsn = callPackage ../development/libraries/libmsn { };

  libmspack = callPackage ../development/libraries/libmspack { };

  libmusicbrainz2 = callPackage ../development/libraries/libmusicbrainz/2.x.nix { };

  libmusicbrainz3 = callPackage ../development/libraries/libmusicbrainz { };

  libmusicbrainz5 = callPackage ../development/libraries/libmusicbrainz/5.x.nix { };

  libmusicbrainz = libmusicbrainz3;

  libmwaw = callPackage ../development/libraries/libmwaw { };

  libmx = callPackage ../development/libraries/libmx { };

  libnet = callPackage ../development/libraries/libnet { };

  libnetfilter_conntrack = callPackage ../development/libraries/libnetfilter_conntrack { };

  libnetfilter_cthelper = callPackage ../development/libraries/libnetfilter_cthelper { };

  libnetfilter_cttimeout = callPackage ../development/libraries/libnetfilter_cttimeout { };

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

  libopus = callPackage ../development/libraries/libopus { };

  libosinfo = callPackage ../development/libraries/libosinfo {
    inherit (gnome3) libsoup;
  };

  libosip = callPackage ../development/libraries/osip {};

  libosip_3 = callPackage ../development/libraries/osip/3.nix {};

  libosmocore = callPackage ../applications/misc/libosmocore { };

  libosmpbf = callPackage ../development/libraries/libosmpbf {};

  libotr = callPackage ../development/libraries/libotr { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpar2 = callPackage ../development/libraries/libpar2 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpipeline = callPackage ../development/libraries/libpipeline { };

  libpgf = callPackage ../development/libraries/libpgf { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = libpng.override { apngSupport = true; };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  libpaper = callPackage ../development/libraries/libpaper { };

  libpfm = callPackage ../development/libraries/libpfm { };

  libpqxx = callPackage ../development/libraries/libpqxx {
    gnused = gnused_422;
  };

  libproxy = callPackage ../development/libraries/libproxy {
    stdenv = if stdenv.isDarwin
      then overrideCC stdenv gcc
      else stdenv;
  };

  libpseudo = callPackage ../development/libraries/libpseudo { };

  libpsl = callPackage ../development/libraries/libpsl { };

  libpst = callPackage ../development/libraries/libpst { };

  libpwquality = callPackage ../development/libraries/libpwquality { };

  libqalculate = callPackage ../development/libraries/libqalculate { };

  librsvg = callPackage ../development/libraries/librsvg { };

  librsync = callPackage ../development/libraries/librsync { };

  librsync_0_9 = callPackage ../development/libraries/librsync/0.9.nix { };

  libs3 = callPackage ../development/libraries/libs3 { };

  libsearpc = callPackage ../development/libraries/libsearpc { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsigsegv = callPackage ../development/libraries/libsigsegv { };

  # To bootstrap SBCL, I need CLisp 2.44.1; it needs libsigsegv 2.5
  libsigsegv_25 = callPackage ../development/libraries/libsigsegv/2.5.nix { };

  libsndfile = callPackage ../development/libraries/libsndfile {
    inherit (darwin.apple_sdk.frameworks) Carbon AudioToolbox;
  };

  libsodium = callPackage ../development/libraries/libsodium { };

  libsoup = callPackage ../development/libraries/libsoup { };

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

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

  libtorrentRasterbar_1_0 = callPackage ../development/libraries/libtorrent-rasterbar/1.0.nix { };

  libtoxcore-old = callPackage ../development/libraries/libtoxcore/old-api.nix { };

  libtoxcore-new = callPackage ../development/libraries/libtoxcore/new-api.nix { };

  libtoxcore = callPackage ../development/libraries/libtoxcore { };

  libtap = callPackage ../development/libraries/libtap { };

  libtsm = callPackage ../development/libraries/libtsm {
    automake = automake114x;
  };

  libtunepimp = callPackage ../development/libraries/libtunepimp { };

  libtxc_dxtn = callPackage ../development/libraries/libtxc_dxtn { };

  libtxc_dxtn_s2tc = callPackage ../development/libraries/libtxc_dxtn_s2tc { };

  libgeotiff = callPackage ../development/libraries/libgeotiff { };

  libu2f-host = callPackage ../development/libraries/libu2f-host { };

  libu2f-server = callPackage ../development/libraries/libu2f-server { };

  libuecc = callPackage ../development/libraries/libuecc { };

  libui = callPackage ../development/libraries/libui { };

  libunity = callPackage ../development/libraries/libunity { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  giflib = giflib_5_1;
  giflib_4_1 = callPackage ../development/libraries/giflib/4.1.nix { };
  giflib_5_0 = callPackage ../development/libraries/giflib/5.0.nix { };
  giflib_5_1 = callPackage ../development/libraries/giflib/5.1.nix { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libunibreak = callPackage ../development/libraries/libunibreak { };

  libunique = callPackage ../development/libraries/libunique/default.nix { };
  libunique3 = callPackage ../development/libraries/libunique/3.x.nix { inherit (gnome2) gtkdoc; };

  liburcu = callPackage ../development/libraries/liburcu { };

  libusb = callPackage ../development/libraries/libusb {};

  libusb1 = callPackage ../development/libraries/libusb1 {
    inherit (darwin) libobjc IOKit;
  };

  libusbmuxd = callPackage ../development/libraries/libusbmuxd { };

  libutempter = callPackage ../development/libraries/libutempter { };

  libunwind = if stdenv.isDarwin
    then darwin.libunwind
    else callPackage ../development/libraries/libunwind { };

  libuv = callPackage ../development/libraries/libuv {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  };

  libv4l = lowPrio (v4l_utils.override {
    alsaLib = null;
    libX11 = null;
    qt4 = null;
    qt5 = null;
  });

  libva = callPackage ../development/libraries/libva { };
  libva-full = libva.override { minimal = false; };

  libvdpau = callPackage ../development/libraries/libvdpau { };

  libvdpau-va-gl = callPackage ../development/libraries/libvdpau-va-gl {
    libva = libva-full; # also wants libva-{x11}
  };

  libvirt = callPackage ../development/libraries/libvirt { };

  libvirt-glib = callPackage ../development/libraries/libvirt-glib { };

  libvisio = callPackage ../development/libraries/libvisio { };

  libvisual = callPackage ../development/libraries/libvisual { };

  libvncserver = callPackage ../development/libraries/libvncserver {};

  libviper = callPackage ../development/libraries/libviper { };

  libvpx = callPackage ../development/libraries/libvpx { };
  libvpx-git = callPackage ../development/libraries/libvpx/git.nix { };

  libvterm = callPackage ../development/libraries/libvterm { };

  libvorbis = callPackage ../development/libraries/libvorbis { };

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

  libxkbcommon = callPackage ../development/libraries/libxkbcommon { };

  libxklavier = callPackage ../development/libraries/libxklavier { };

  libxls = callPackage ../development/libraries/libxls { };

  libxmi = callPackage ../development/libraries/libxmi { };

  libxml2 = callPackage ../development/libraries/libxml2 {
  };
  libxml2Python = pkgs.buildEnv { # slightly hacky
    name = "libxml2+py-${self.libxml2.version}";
    paths = with libxml2; [ dev bin py ];
    inherit (libxml2) passthru;
    # the hook to find catalogs is hidden by buildEnv
    postBuild = ''
      mkdir "$out/nix-support"
      cp '${libxml2.dev}/nix-support/propagated-native-build-inputs' "$out/nix-support/"
    '';
  };

  libxmlxx = callPackage ../development/libraries/libxmlxx { };
  libxmlxx3 = callPackage ../development/libraries/libxmlxx/v3.nix { };

  libxmp = callPackage ../development/libraries/libxmp { };

  libxslt = callPackage ../development/libraries/libxslt { };

  libixp_hg = callPackage ../development/libraries/libixp-hg { };

  libyaml = callPackage ../development/libraries/libyaml { };

  libyamlcpp = callPackage ../development/libraries/libyaml-cpp { };

  libykneomgr = callPackage ../development/libraries/libykneomgr { };

  libyubikey = callPackage ../development/libraries/libyubikey { };

  libzen = callPackage ../development/libraries/libzen { };

  libzip = callPackage ../development/libraries/libzip { };

  libzdb = callPackage ../development/libraries/libzdb { };

  libwacom = callPackage ../development/libraries/libwacom { };

  lightning = callPackage ../development/libraries/lightning { };

  lightlocker = callPackage ../misc/screensavers/light-locker { };

  linenoise = callPackage ../development/libraries/linenoise { };

  lirc = callPackage ../development/libraries/lirc { };

  liquidfun = callPackage ../development/libraries/liquidfun { };

  live555 = callPackage ../development/libraries/live555 { };

  loadcaffe = callPackage ../development/libraries/loadcaffe {};

  log4cpp = callPackage ../development/libraries/log4cpp { };

  log4cxx = callPackage ../development/libraries/log4cxx { };

  log4cplus = callPackage ../development/libraries/log4cplus { };

  loudmouth = callPackage ../development/libraries/loudmouth { };

  luabind = callPackage ../development/libraries/luabind { lua = lua5_1; };

  luabind_luajit = callPackage ../development/libraries/luabind { lua = luajit; };

  lzo = callPackage ../development/libraries/lzo { };

  mapnik = callPackage ../development/libraries/mapnik { };

  matio = callPackage ../development/libraries/matio { };

  mbedtls = callPackage ../development/libraries/mbedtls { };
  mbedtls_1_3 = callPackage ../development/libraries/mbedtls/1.3.nix { };

  mdds_0_7_1 = callPackage ../development/libraries/mdds/0.7.1.nix { };
  mdds_0_12_1 = callPackage ../development/libraries/mdds/0.12.1.nix { };
  mdds = callPackage ../development/libraries/mdds { };

  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mediastreamer-openh264 = callPackage ../development/libraries/mediastreamer/msopenh264.nix { };

  menu-cache = callPackage ../development/libraries/menu-cache { };

  mergerfs = callPackage ../tools/filesystems/mergerfs { };

  mesaSupported = lib.elem system lib.platforms.mesaPlatforms;

  mesaDarwinOr = alternative: if stdenv.isDarwin
    then callPackage ../development/libraries/mesa-darwin {
      inherit (darwin.apple_sdk.frameworks) OpenGL;
      inherit (darwin.apple_sdk.libs) Xplugin;
      inherit (darwin) apple_sdk;
    }
    else alternative;
  mesa_noglu = mesaDarwinOr (callPackage ../development/libraries/mesa {
    # makes it slower, but during runtime we link against just mesa_drivers
    # through /run/opengl-driver*, which is overriden according to config.grsecurity
    grsecEnabled = true;
    llvmPackages = llvmPackages_39;
  });
  mesa_glu =  mesaDarwinOr (callPackage ../development/libraries/mesa-glu { });
  mesa_drivers = mesaDarwinOr (
    let mo = mesa_noglu.override {
      grsecEnabled = config.grsecurity or false;
    };
    in mo.drivers
  );

  mesa = mesaDarwinOr (buildEnv {
    name = "mesa-${mesa_noglu.version}";
    # FIXME: this causes mesa to have a runtime dependency on
    # mesa_noglu.dev.
    paths = [ mesa_noglu.dev mesa_noglu.out mesa_glu mesa_glu.dev ];
    meta = {
      platforms = lib.platforms.unix;
    };
  });

  meterbridge = callPackage ../applications/audio/meterbridge { };

  mhddfs = callPackage ../tools/filesystems/mhddfs { };

  microsoft_gsl = callPackage ../development/libraries/microsoft_gsl { };

  minizip = callPackage ../development/libraries/minizip { };

  miro = callPackage ../applications/video/miro {
    avahi = avahi.override {
      withLibdnssdCompat = true;
    };
    ffmpeg = ffmpeg_2;
  };

  mkvtoolnix = callPackage ../applications/video/mkvtoolnix { };

  mkvtoolnix-cli = mkvtoolnix.override {
    withGUI = false;
  };

  mlt = callPackage ../development/libraries/mlt {};

  mlt-qt4 = callPackage ../development/libraries/mlt/qt-4.nix {
    ffmpeg = ffmpeg_2;
    qt = qt4;
  };

  mono-addins = callPackage ../development/libraries/mono-addins { };

  mono-zeroconf = callPackage ../development/libraries/mono-zeroconf { };

  movit = callPackage ../development/libraries/movit { };

  mosquitto = callPackage ../servers/mqtt/mosquitto { };

  mps = callPackage ../development/libraries/mps { };

  libmpeg2 = callPackage ../development/libraries/libmpeg2 { };

  mpeg2dec = libmpeg2;

  msilbc = callPackage ../development/libraries/msilbc { };

  mp4v2 = callPackage ../development/libraries/mp4v2 { };

  libmpc = callPackage ../development/libraries/libmpc { };

  mpich2 = callPackage ../development/libraries/mpich2 { };

  mstpd = callPackage ../os-specific/linux/mstpd { };

  mtdev = callPackage ../development/libraries/mtdev { };

  mtpfs = callPackage ../tools/filesystems/mtpfs { };

  mu = callPackage ../tools/networking/mu {
    texinfo = texinfo4;
  };

  mueval = callPackage ../development/tools/haskell/mueval { };

  muparser = callPackage ../development/libraries/muparser { };

  mygpoclient = pythonPackages.mygpoclient;

  mygui = callPackage ../development/libraries/mygui {};

  mysocketw = callPackage ../development/libraries/mysocketw { };

  mythes = callPackage ../development/libraries/mythes { };

  nanoflann = callPackage ../development/libraries/nanoflann { };

  nanomsg = callPackage ../development/libraries/nanomsg { };

  notify-sharp = callPackage ../development/libraries/notify-sharp { };

  ncurses5 = callPackage ../development/libraries/ncurses { abiVersion = "5"; };
  ncurses6 = callPackage ../development/libraries/ncurses { abiVersion = "6"; };
  ncurses = if stdenv.isDarwin then ncurses5 else ncurses6;

  neardal = callPackage ../development/libraries/neardal { };

  neon = callPackage ../development/libraries/neon {
    compressionSupport = true;
    sslSupport = true;
  };

  neon_0_29 = callPackage ../development/libraries/neon/0.29.nix {
    compressionSupport = true;
    sslSupport = true;
  };

  nettle = callPackage ../development/libraries/nettle { };

  newt = callPackage ../development/libraries/newt { };

  nghttp2 = callPackage ../development/libraries/nghttp2 {
    fetchurl = fetchurlBoot;
  };
  libnghttp2 = nghttp2.lib;

  nix-plugins = callPackage ../development/libraries/nix-plugins {
    nix = pkgs.nixUnstable;
  };

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

  ntk = callPackage ../development/libraries/audio/ntk { };

  ntrack = callPackage ../development/libraries/ntrack { };

  nvidia-texture-tools = callPackage ../development/libraries/nvidia-texture-tools { };

  nvidia-video-sdk = callPackage ../development/libraries/nvidia-video-sdk { };

  ocl-icd = callPackage ../development/libraries/ocl-icd { };

  ode = callPackage ../development/libraries/ode { };

  ogre = callPackage ../development/libraries/ogre {};

  ogrepaged = callPackage ../development/libraries/ogrepaged { };

  olm = callPackage ../development/libraries/olm { };

  oniguruma = callPackage ../development/libraries/oniguruma { };

  openal = self.openalSoft;

  openalSoft = callPackage ../development/libraries/openal-soft {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit AudioToolbox;
  };

  openbabel = callPackage ../development/libraries/openbabel { };

  opencascade = callPackage ../development/libraries/opencascade {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

  opencascade_6_5 = callPackage ../development/libraries/opencascade/6.5.nix {
    automake = automake111x;
    ftgl = ftgl212;
  };

  opencascade_oce = callPackage ../development/libraries/opencascade/oce.nix { };

  opencl-headers = callPackage ../development/libraries/opencl-headers { };

  opencl-clhpp = callPackage ../development/libraries/opencl-clhpp { };

  opencollada = callPackage ../development/libraries/opencollada { };

  opencsg = callPackage ../development/libraries/opencsg { };

  openct = callPackage ../development/libraries/openct { };

  opencv = callPackage ../development/libraries/opencv {
    ffmpeg = ffmpeg_2;
  };

  opencv3 = callPackage ../development/libraries/opencv/3.x.nix { };

  # this ctl version is needed by openexr_viewers
  openexr_ctl = ctl;

  openexr = callPackage ../development/libraries/openexr { };

  openldap = callPackage ../development/libraries/openldap { };

  opencolorio = callPackage ../development/libraries/opencolorio { };

  ois = callPackage ../development/libraries/ois {};

  opal = callPackage ../development/libraries/opal {
    ffmpeg = ffmpeg_2;
  };

  openh264 = callPackage ../development/libraries/openh264 { };

  openjpeg_1 = callPackage ../development/libraries/openjpeg/1.x.nix { };
  openjpeg_2_1 = callPackage ../development/libraries/openjpeg/2.1.nix { };
  openjpeg = openjpeg_2_1;

  openscenegraph = callPackage ../development/libraries/openscenegraph { };

  openslp = callPackage ../development/libraries/openslp {};

  libressl = libressl_2_4;
  libressl_2_4 = callPackage ../development/libraries/libressl/2.4.nix {
    fetchurl = fetchurlBoot;
  };
  libressl_2_5 = callPackage ../development/libraries/libressl/2.5.nix {
    fetchurl = fetchurlBoot;
  };


  boringssl = callPackage ../development/libraries/boringssl { };

  wolfssl = callPackage ../development/libraries/wolfssl { };

  openssl = openssl_1_0_2;
  openssl-steam = openssl_1_0_2-steam;

  inherit (callPackages ../development/libraries/openssl {
      fetchurl = fetchurlBoot;
      cryptodevHeaders = linuxPackages.cryptodev.override {
        fetchurl = fetchurlBoot;
        onlyHeaders = true;
      };
    })
    openssl_1_0_2
    openssl_1_1_0
    openssl_1_0_2-steam;

  openssl-chacha = callPackage ../development/libraries/openssl/chacha.nix {
    cryptodevHeaders = linuxPackages.cryptodev.override {
      fetchurl = fetchurlBoot;
      onlyHeaders = true;
    };
  };

  opensubdiv = callPackage ../development/libraries/opensubdiv {
    cudatoolkit = cudatoolkit8;
  };

  openwsman = callPackage ../development/libraries/openwsman {};

  ortp = callPackage ../development/libraries/ortp { };

  osm-gps-map = callPackage ../development/libraries/osm-gps-map { };

  p11_kit = callPackage ../development/libraries/p11-kit { };

  paperkey = callPackage ../tools/security/paperkey { };

  pangoxsl = callPackage ../development/libraries/pangoxsl { };

  pcaudiolib = callPackage ../development/libraries/pcaudiolib {
    pulseaudioSupport = config.pulseaudio or true;
  };

  pcg_c = callPackage ../development/libraries/pcg-c { };

  pcl = callPackage ../development/libraries/pcl {
    vtk = vtkWithQt4;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) Cocoa AGL OpenGL;
  };

  pcre = callPackage ../development/libraries/pcre { };
  pcre16 = self.pcre.override { variant = "pcre16"; };
  # pcre32 seems unused
  pcre-cpp = self.pcre.override { variant = "cpp"; };

  pcre2 = callPackage ../development/libraries/pcre2 { };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  pg_repack = callPackage ../servers/sql/postgresql/pg_repack {};

  pg_similarity = callPackage ../servers/sql/postgresql/pg_similarity {};

  pgroonga = callPackage ../servers/sql/postgresql/pgroonga {};

  phonon = callPackage ../development/libraries/phonon {};

  phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix {};

  phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix {};

  physfs = callPackage ../development/libraries/physfs { };

  pipelight = callPackage ../tools/misc/pipelight {
    stdenv = stdenv_32bit;
    wineStaging = pkgsi686Linux.wineStaging;
  };

  pkcs11helper = callPackage ../development/libraries/pkcs11helper { };

  plib = callPackage ../development/libraries/plib { };

  pocketsphinx = callPackage ../development/libraries/pocketsphinx { };

  podofo = callPackage ../development/libraries/podofo { lua5 = lua5_1; };

  poker-eval = callPackage ../development/libraries/poker-eval { };

  polarssl = mbedtls;

  polkit = callPackage ../development/libraries/polkit { };

  polkit_qt4 = callPackage ../development/libraries/polkit-qt-1/qt-4.nix { };

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };

  poppler_gi = lowPrio (poppler.override {
    introspectionSupport = true;
  });

  poppler_min = poppler.override { # TODO: maybe reduce even more
    minimal = true;
    suffix = "min";
  };

  poppler_qt4 = poppler.override {
    qt4Support = true;
    suffix = "qt4";
  };

  poppler_utils = poppler.override { suffix = "utils"; utils = true; };

  popt = callPackage ../development/libraries/popt { };

  portaudio = callPackage ../development/libraries/portaudio {
    inherit (darwin.apple_sdk.frameworks) AudioToolbox AudioUnit CoreAudio CoreServices Carbon;
  };

  portmidi = callPackage ../development/libraries/portmidi {};

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  postgis = callPackage ../development/libraries/postgis { };

  protobuf = protobuf2_6;
  protobuf3_0 = lowPrio (callPackage ../development/libraries/protobuf/3.0.nix { });
  # 3.0.0-beta-2 is only introduced for tensorflow. remove this version when tensorflow is moved to 3.0.
  protobuf3_0_0b2 = lowPrio (callPackage ../development/libraries/protobuf/3.0.0-beta-2.nix { });
  protobuf3_1 = callPackage ../development/libraries/protobuf/3.1.nix { };
  protobuf2_6 = callPackage ../development/libraries/protobuf/2.6.nix { };
  protobuf2_5 = callPackage ../development/libraries/protobuf/2.5.nix { };

  protobufc = protobufc1_1;
  protobufc1_1 = callPackage ../development/libraries/protobufc/1.1.nix { };
  protobufc1_0 = callPackage ../development/libraries/protobufc/1.0.nix { };

  flatbuffers = callPackage ../development/libraries/flatbuffers { };

  pth = callPackage ../development/libraries/pth { };

  ptlib = callPackage ../development/libraries/ptlib {};

  pugixml = callPackage ../development/libraries/pugixml { };

  re2 = callPackage ../development/libraries/re2 { };

  qca2 = callPackage ../development/libraries/qca2 { qt = qt4; };
  qca2-qt5 = callPackage ../development/libraries/qca2 { qt = qt5.qtbase; };

  qimageblitz = callPackage ../development/libraries/qimageblitz {};

  qjson = callPackage ../development/libraries/qjson { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qt3 = callPackage ../development/libraries/qt-3 {
    openglSupport = mesaSupported;
    libpng = libpng12;
  };

  qt4 = pkgs.kde4.qt4;

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    mesa = mesa_noglu;
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

  qt55 =
    let imported = import ../development/libraries/qt-5/5.5 { inherit pkgs; };
        # Libraries that cannot be built with newer versions of Qt 5
        qt55Only = self: with self; {
          # Requires Qt Quick (deprecated in Qt 5.5, removed from Qt 5.6)
          qmltermwidget = callPackage ../development/libraries/qmltermwidget { };
        };
    in recurseIntoAttrs (imported.override (super: self: qt5LibsFun self // qt55Only self));

  qt56 =
    let imported = import ../development/libraries/qt-5/5.6 { inherit pkgs; };
    in recurseIntoAttrs (imported.override (super: qt5LibsFun));

  qt57 =
    let imported = import ../development/libraries/qt-5/5.7 { inherit pkgs; };
    in recurseIntoAttrs (imported.override (super: qt5LibsFun));

  qt5 = qt56;

  qt5ct = qt5.callPackage ../tools/misc/qt5ct { };

  qt5LibsFun = self: with self;
    let kdeFrameworks =
          import ../development/libraries/kde-frameworks { inherit pkgs; } self;
    in {

    inherit kdeFrameworks;

    accounts-qt = callPackage ../development/libraries/accounts-qt { };

    fcitx-qt5 = callPackage ../tools/inputmethods/fcitx/fcitx-qt5.nix { };

    grantlee = callPackage ../development/libraries/grantlee/5.x.nix { };

    kirigami_1 = callPackage ../development/libraries/kirigami { };

    kirigami_2 = callPackage ../development/libraries/kirigami/v2.nix {
      # kirigami v2 requires qt 5.7 and above
      inherit (qt57) qtbase qtquickcontrols2;
    };

    kirigami = kirigami_1;

    libcommuni = callPackage ../development/libraries/libcommuni { };

    libdbusmenu = callPackage ../development/libraries/libdbusmenu-qt/qt-5.5.nix { };

    libkeyfinder = callPackage ../development/libraries/libkeyfinder { };

    libktorrent = callPackage ../development/libraries/libktorrent/5.nix { };

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

    phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix {
      withQt5 = true;
    };

    polkit-qt = callPackage ../development/libraries/polkit-qt-1/qt-5.nix { };

    poppler = callPackage ../development/libraries/poppler {
      lcms = lcms2;
      qt5Support = true;
      suffix = "qt5";
    };

    qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

    qscintilla = callPackage ../development/libraries/qscintilla {
      withQt5 = true;
    };

    qtkeychain = callPackage ../development/libraries/qtkeychain {
      withQt5 = true;
    };

    qtstyleplugins = callPackage ../development/libraries/qtstyleplugins { };

    quazip = callPackage ../development/libraries/quazip {
      qt = qtbase;
    };

    qwt = callPackage ../development/libraries/qwt/6.nix { };

    telepathy = callPackage ../development/libraries/telepathy/qt { };

    vlc = lowPrio (callPackage ../applications/video/vlc {
      qt4 = null;
      withQt5 = true;
      ffmpeg = ffmpeg_2;
    });

    qtwebkit-plugins = callPackage ../development/libraries/qtwebkit-plugins { };

  } // kdeFrameworks;

  qtEnv = qt5.env;
  qt5Full = qt5.full;

  qtkeychain = callPackage ../development/libraries/qtkeychain { };

  qtscriptgenerator = callPackage ../development/libraries/qtscriptgenerator { };

  quesoglc = callPackage ../development/libraries/quesoglc { };

  quickder = callPackage ../development/libraries/quickder {};

  quicksynergy = callPackage ../applications/misc/quicksynergy { };

  qwt = callPackage ../development/libraries/qwt {};

  qwt6_qt4 = callPackage ../development/libraries/qwt/6_qt4.nix { };

  qxt = callPackage ../development/libraries/qxt {};

  rabbitmq-c = callPackage ../development/libraries/rabbitmq-c {};

  range-v3 = callPackage ../development/libraries/range-v3 {};

  rabbitmq-java-client = callPackage ../development/libraries/rabbitmq-java-client {};

  raul = callPackage ../development/libraries/audio/raul { };

  readline = readline6;
  readline6 = readline63;

  readline5 = callPackage ../development/libraries/readline/5.x.nix { };

  readline62 = callPackage ../development/libraries/readline/6.2.nix { };

  readline63 = callPackage ../development/libraries/readline/6.3.nix { };

  readline70 = callPackage ../development/libraries/readline/7.0.nix { };

  readosm = callPackage ../development/libraries/readosm { };

  lambdabot = callPackage ../development/tools/haskell/lambdabot {
    haskell-lib = haskell.lib;
  };

  leksah = callPackage ../development/tools/haskell/leksah {
    inherit (haskellPackages) ghcWithPackages;
  };

  librdf_raptor = callPackage ../development/libraries/librdf/raptor.nix { };

  librdf_raptor2 = callPackage ../development/libraries/librdf/raptor2.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf_redland = callPackage ../development/libraries/librdf/redland.nix { };

  librdf = callPackage ../development/libraries/librdf { };

  libsmf = callPackage ../development/libraries/audio/libsmf { };

  lilv = callPackage ../development/libraries/audio/lilv { };

  lv2 = callPackage ../development/libraries/audio/lv2 { };
  lv2Unstable = callPackage ../development/libraries/audio/lv2/unstable.nix { };

  lvtk = callPackage ../development/libraries/audio/lvtk { };

  qrupdate = callPackage ../development/libraries/qrupdate { };

  redland = pkgs.librdf_redland;

  resolv_wrapper = callPackage ../development/libraries/resolv_wrapper { };

  rhino = callPackage ../development/libraries/java/rhino {
    javac = gcj;
    jvm = gcj;
  };

  rlog = callPackage ../development/libraries/rlog { };

  rocksdb = callPackage ../development/libraries/rocksdb { };

  rote = callPackage ../development/libraries/rote { };

  ronn = callPackage ../development/tools/ronn { };

  rubberband = callPackage ../development/libraries/rubberband {
    inherit (vamp) vampSDK;
  };

  sad = callPackage ../applications/science/logic/sad { };

  sbc = callPackage ../development/libraries/sbc { };

  schroedinger = callPackage ../development/libraries/schroedinger { };

  SDL = callPackage ../development/libraries/SDL {
    openglSupport = mesaSupported;
    alsaSupport = stdenv.isLinux;
    x11Support = !stdenv.isCygwin;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa;
  };

  SDL_sixel = callPackage ../development/libraries/SDL_sixel { };

  SDL_gfx = callPackage ../development/libraries/SDL_gfx { };

  SDL_image = callPackage ../development/libraries/SDL_image { };

  SDL_mixer = callPackage ../development/libraries/SDL_mixer { };

  SDL_net = callPackage ../development/libraries/SDL_net { };

  SDL_sound = callPackage ../development/libraries/SDL_sound { };

  SDL_stretch= callPackage ../development/libraries/SDL_stretch { };

  SDL_ttf = callPackage ../development/libraries/SDL_ttf { };

  SDL2 = callPackage ../development/libraries/SDL2 {
    openglSupport = mesaSupported;
    alsaSupport = stdenv.isLinux;
    x11Support = !stdenv.isCygwin;
    udevSupport = stdenv.isLinux;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL;
  };

  SDL2_image = callPackage ../development/libraries/SDL2_image { };

  SDL2_mixer = callPackage ../development/libraries/SDL2_mixer { };

  SDL2_net = callPackage ../development/libraries/SDL2_net { };

  SDL2_gfx = callPackage ../development/libraries/SDL2_gfx { };

  SDL2_ttf = callPackage ../development/libraries/SDL2_ttf { };

  sblim-sfcc = callPackage ../development/libraries/sblim-sfcc {};

  serd = callPackage ../development/libraries/serd {};

  serf = callPackage ../development/libraries/serf {};

  sfsexp = callPackage ../development/libraries/sfsexp {};

  shhmsg = callPackage ../development/libraries/shhmsg { };

  shhopt = callPackage ../development/libraries/shhopt { };

  silgraphite = callPackage ../development/libraries/silgraphite {};
  graphite2 = callPackage ../development/libraries/silgraphite/graphite2.nix {};

  simavr = callPackage ../development/tools/simavr { };

  simgear = callPackage ../development/libraries/simgear { };

  simp_le = callPackage ../tools/admin/simp_le { };

  sfml = callPackage ../development/libraries/sfml { };

  skalibs = callPackage ../development/libraries/skalibs { };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
    texinfo = texinfo4; # otherwise erros: must be after `@defun' to use `@defunx'
  };

  smpeg = callPackage ../development/libraries/smpeg { };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

  snappy = callPackage ../development/libraries/snappy { };

  socket_wrapper = callPackage ../development/libraries/socket_wrapper { };

  sofia_sip = callPackage ../development/libraries/sofia-sip { };

  sonic = callPackage ../development/libraries/sonic { };

  soprano = callPackage ../development/libraries/soprano { };

  soqt = callPackage ../development/libraries/soqt { };

  sord = callPackage ../development/libraries/sord {};

  soundtouch = callPackage ../development/libraries/soundtouch {};

  spandsp = callPackage ../development/libraries/spandsp {};

  spatialite_tools = callPackage ../development/libraries/spatialite-tools { };

  speechd = callPackage ../development/libraries/speechd { };

  speech_tools = callPackage ../development/libraries/speech-tools {};

  speex = callPackage ../development/libraries/speex {
    fftw = fftwFloat;
  };

  speexdsp = callPackage ../development/libraries/speexdsp {
    fftw = fftwFloat;
  };

  sphinxbase = callPackage ../development/libraries/sphinxbase { };

  sphinxsearch = callPackage ../servers/search/sphinxsearch { };

  spice = callPackage ../development/libraries/spice {
    celt = celt_0_5_1;
    inherit (pythonPackages) pyparsing;
  };

  spice_gtk = callPackage ../development/libraries/spice-gtk { };

  spice_protocol = callPackage ../development/libraries/spice-protocol { };

  sratom = callPackage ../development/libraries/audio/sratom { };

  srm = callPackage ../tools/security/srm { };

  srtp = callPackage ../development/libraries/srtp {
    libpcap = if stdenv.isLinux then libpcap else null;
  };

  stxxl = callPackage ../development/libraries/stxxl { parallel = true; };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite { });

  sqlite3_analyzer = lowPrio (callPackage ../development/libraries/sqlite/sqlite3_analyzer.nix { });

  sqlite-amalgamation = callPackage ../development/libraries/sqlite-amalgamation { };

  sqlite-interactive = appendToName "interactive" (sqlite.override { interactive = true; }).bin;

  sqlcipher = lowPrio (callPackage ../development/libraries/sqlcipher {
    readline = null;
    ncurses = null;
  });

  stfl = callPackage ../development/libraries/stfl { };

  stlink = callPackage ../development/tools/misc/stlink { };

  steghide = callPackage ../tools/security/steghide {};

  stlport = callPackage ../development/libraries/stlport { };

  streamlink = callPackage ../applications/video/streamlink { pythonPackages = python3Packages; };

  strigi = callPackage ../development/libraries/strigi { clucene_core = clucene_core_2; };

  subtitleeditor = callPackage ../applications/video/subtitleeditor { };

  suil-qt4 = callPackage ../development/libraries/audio/suil {
    withQt4 = true;
    withQt5 = false;
  };

  suil-qt5 = callPackage ../development/libraries/audio/suil {
    withQt4 = false;
    withQt5 = true;
  };

  suil = suil-qt4;

  sutils = callPackage ../tools/misc/sutils { };

  svrcore = callPackage ../development/libraries/svrcore { };

  sword = callPackage ../development/libraries/sword { };

  biblesync = callPackage ../development/libraries/biblesync { };

  szip = callPackage ../development/libraries/szip { };

  t1lib = callPackage ../development/libraries/t1lib { };

  tachyon = callPackage ../development/libraries/tachyon {};

  taglib = callPackage ../development/libraries/taglib { };
  taglib_1_9 = callPackage ../development/libraries/taglib/1.9.nix { };

  taglib_extras = callPackage ../development/libraries/taglib-extras { };

  taglib-sharp = callPackage ../development/libraries/taglib-sharp { };

  talloc = callPackage ../development/libraries/talloc {
    python = python2;
  };

  tclap = callPackage ../development/libraries/tclap {};

  tclgpg = callPackage ../development/libraries/tclgpg { };

  tcllib = callPackage ../development/libraries/tcllib { };

  tcltls = callPackage ../development/libraries/tcltls { };

  tclx = callPackage ../development/libraries/tclx { };

  ntdb = callPackage ../development/libraries/ntdb {
    python = python2;
  };

  tdb = callPackage ../development/libraries/tdb {
    python = python2;
  };

  tecla = callPackage ../development/libraries/tecla { };

  telepathy_glib = callPackage ../development/libraries/telepathy/glib { };

  telepathy_farstream = callPackage ../development/libraries/telepathy/farstream {};

  telepathy_qt = callPackage ../development/libraries/telepathy/qt { qtbase = qt4; };

  tevent = callPackage ../development/libraries/tevent {
    python = python2;
  };

  tet = callPackage ../development/tools/misc/tet { };

  thrift = callPackage ../development/libraries/thrift {
    inherit (pythonPackages) twisted;
  };

  tidyp = callPackage ../development/libraries/tidyp { };

  tinyxml = tinyxml2;

  tinyxml2 = callPackage ../development/libraries/tinyxml/2.6.2.nix { };

  tinyxml-2 = callPackage ../development/libraries/tinyxml-2 { };

  tivodecode = callPackage ../applications/video/tivodecode { };

  tix = callPackage ../development/libraries/tix { };

  tk = tk-8_6;

  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tnt = callPackage ../development/libraries/tnt { };

  tntnet = callPackage ../development/libraries/tntnet { };

  tntdb = callPackage ../development/libraries/tntdb { };

  kyotocabinet = callPackage ../development/libraries/kyotocabinet { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };

  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  torch = callPackage ../development/libraries/torch {
    openblas = openblasCompat;
  };

  torch-hdf5 = callPackage ../development/libraries/torch-hdf5 {};

  tremor = callPackage ../development/libraries/tremor { };

  udns = callPackage ../development/libraries/udns { };

  uid_wrapper = callPackage ../development/libraries/uid_wrapper { };

  unibilium = callPackage ../development/libraries/unibilium { };

  unicap = callPackage ../development/libraries/unicap {};

  unicon-lang = callPackage ../development/interpreters/unicon-lang {};

  tsocks = callPackage ../development/libraries/tsocks { };

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (callPackages ../development/libraries/unixODBCDrivers {});

  urt = callPackage ../development/libraries/urt { };

  ustr = callPackage ../development/libraries/ustr { };

  usbredir = callPackage ../development/libraries/usbredir {
    libusb = libusb1;
  };

  uthash = callPackage ../development/libraries/uthash { };

  ucommon = ucommon_openssl;

  ucommon_openssl = callPackage ../development/libraries/ucommon {
    gnutls = null;
  };

  ucommon_gnutls = lowPrio (ucommon.override {
    openssl = null;
    zlib = null;
    gnutls = gnutls;
  });

  v8_3_14 = callPackage ../development/libraries/v8/3.14.nix {
    inherit (python2Packages) python gyp;
  };

  v8_3_16_14 = callPackage ../development/libraries/v8/3.16.14.nix {
    inherit (python2Packages) python gyp;
  };

  v8_3_24_10 = callPackage ../development/libraries/v8/3.24.10.nix {
    inherit (python2Packages) python gyp;
  };

  v8_3_30_33 = callPackage ../development/libraries/v8/3.30.33.nix {
    inherit (python2Packages) python gyp;
  };

  v8_4_5 = callPackage ../development/libraries/v8/4.5.nix {
    inherit (python2Packages) python gyp;
  };

  v8 = callPackage ../development/libraries/v8 {
    inherit (python2Packages) python gyp;
  };

  v8_static = lowPrio (self.v8.override { static = true; });

  vaapiIntel = callPackage ../development/libraries/vaapi-intel {
    libva = libva-full; # also wants libva-{x11,drm,wayland}
  };

  vaapiVdpau = callPackage ../development/libraries/vaapi-vdpau {
    libva = libva-full; # needs libva-{x11,glx}
  };

  vamp = callPackage ../development/libraries/audio/vamp { };

  vc = callPackage ../development/libraries/vc { };

  vc_0_7 = callPackage ../development/libraries/vc/0.7.nix { };

  vcdimager = callPackage ../development/libraries/vcdimager { };

  vcg = callPackage ../development/libraries/vcg { };

  vid-stab = callPackage ../development/libraries/vid-stab { };

  vigra = callPackage ../development/libraries/vigra { };

  vlock = callPackage ../misc/screensavers/vlock { };

  vmime = callPackage ../development/libraries/vmime { };

  vrpn = callPackage ../development/libraries/vrpn { };

  vsqlite = callPackage ../development/libraries/vsqlite { };

  vtk = callPackage ../development/libraries/vtk {
    inherit (darwin) cf-private libobjc;
    inherit (darwin.apple_sdk.libs) xpc;
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
                                          IOKit CFNetwork Security ApplicationServices
                                          CoreText IOSurface ImageIO OpenGL GLUT;
  };

  vulkan-loader = callPackage ../development/libraries/vulkan-loader { };

  vtkWithQt4 = vtk.override { qtLib = qt4; };

  vxl = callPackage ../development/libraries/vxl {
    libpng = libpng12;
  };

  wavpack = callPackage ../development/libraries/wavpack {
    inherit (darwin) libiconv;
  };

  wayland = callPackage ../development/libraries/wayland {
    graphviz = graphviz-nox;
  };

  wayland_1_9 = callPackage ../development/libraries/wayland/1.9.nix {
    graphviz = graphviz-nox;
  };

  wayland-protocols = callPackage ../development/libraries/wayland/protocols.nix { };

  webkit = webkitgtk;

  wcslib = callPackage ../development/libraries/wcslib { };

  webkitgtk = webkitgtk214x;

  webkitgtk24x = callPackage ../development/libraries/webkitgtk/2.4.nix {
    harfbuzz = harfbuzz-icu;
    gst-plugins-base = gst_all_1.gst-plugins-base;
    inherit (darwin) libobjc;
  };

  webkitgtk214x = callPackage ../development/libraries/webkitgtk/2.14.nix {
    harfbuzz = harfbuzz-icu;
    gst-plugins-base = gst_all_1.gst-plugins-base;
  };

  webkitgtk2 = webkitgtk24x.override {
    withGtk2 = true;
    enableIntrospection = false;
  };

  websocketpp = callPackage ../development/libraries/websocket++ { };

  webrtc-audio-processing = callPackage ../development/libraries/webrtc-audio-processing { };

  wildmidi = callPackage ../development/libraries/wildmidi { };

  wiredtiger = callPackage ../development/libraries/wiredtiger { };

  wt = callPackage ../development/libraries/wt { };

  wvstreams = callPackage ../development/libraries/wvstreams { };

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxGTK-2.8 {
    inherit (gnome2) GConf;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxGTK29 = callPackage ../development/libraries/wxGTK-2.9/default.nix {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QuickTime;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxGTK30 = callPackage ../development/libraries/wxGTK-3.0/default.nix {
    inherit (gnome2) GConf;
    inherit (darwin.stubs) setfile;
    inherit (darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxmac = callPackage ../development/libraries/wxmac {
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa Kernel;
    inherit (darwin.stubs) setfile rez derez;
  };

  wtk = callPackage ../development/libraries/wtk { };

  x264 = callPackage ../development/libraries/x264 { };

  x265 = callPackage ../development/libraries/x265 { };

  xapian = callPackage ../development/libraries/xapian { };

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

  xautolock = callPackage ../misc/screensavers/xautolock { };

  xercesc = callPackage ../development/libraries/xercesc {};

  xalanc = callPackage ../development/libraries/xalanc {};

  xgboost = callPackage ../development/libraries/xgboost { };

  xgeometry-select = callPackage ../tools/X11/xgeometry-select { };

  # Avoid using this. It isn't really a wrapper anymore, but we keep the name.
  xlibsWrapper = callPackage ../development/libraries/xlibs-wrapper {
    packages = [
      freetype fontconfig xorg.xproto xorg.libX11 xorg.libXt
      xorg.libXft xorg.libXext xorg.libSM xorg.libICE
      xorg.xextproto
    ];
  };

  xmlrpc_c = callPackage ../development/libraries/xmlrpc-c { };

  xmlsec = callPackage ../development/libraries/xmlsec { };

  xml-security-c = callPackage ../development/libraries/xml-security-c { };

  xlslib = callPackage ../development/libraries/xlslib { };

  xvidcore = callPackage ../development/libraries/xvidcore { };

  xylib = callPackage ../development/libraries/xylib { };

  yajl = callPackage ../development/libraries/yajl { };

  yubioath-desktop = callPackage ../applications/misc/yubioath-desktop { };

  yubico-piv-tool = callPackage ../tools/misc/yubico-piv-tool { };

  yubikey-neo-manager = callPackage ../tools/misc/yubikey-neo-manager { };

  yubikey-personalization = callPackage ../tools/misc/yubikey-personalization {
    libusb = libusb1;
  };

  yubikey-personalization-gui = callPackage ../tools/misc/yubikey-personalization-gui { };

  zeitgeist = callPackage ../development/libraries/zeitgeist { };

  zlib = callPackage ../development/libraries/zlib {
    fetchurl = fetchurlBoot;
  };

  libdynd = callPackage ../development/libraries/libdynd { };

  zlog = callPackage ../development/libraries/zlog { };

  zlibStatic = lowPrio (appendToName "static" (callPackage ../development/libraries/zlib {
    static = true;
  }));

  zeromq3 = callPackage ../development/libraries/zeromq/3.x.nix {};
  zeromq4 = callPackage ../development/libraries/zeromq/4.x.nix {};
  zeromq = zeromq4;

  cppzmq = callPackage ../development/libraries/cppzmq {};

  czmq3 = callPackage ../development/libraries/czmq/3.x.nix {};
  czmq4 = callPackage ../development/libraries/czmq/4.x.nix {};
  czmq = czmq4;

  czmqpp = callPackage ../development/libraries/czmqpp {
    czmq = czmq3;
  };

  zimlib = callPackage ../development/libraries/zimlib { };

  zita-convolver = callPackage ../development/libraries/audio/zita-convolver { };

  zita-alsa-pcmi = callPackage ../development/libraries/audio/zita-alsa-pcmi { };

  zita-resampler = callPackage ../development/libraries/audio/zita-resampler { };

  zziplib = callPackage ../development/libraries/zziplib { };

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

  javasvn = callPackage ../development/libraries/java/javasvn { };

  jclasslib = callPackage ../development/tools/java/jclasslib { };

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

  saxon = callPackage ../development/libraries/java/saxon { };

  saxonb = callPackage ../development/libraries/java/saxon/default8.nix { };

  smack = callPackage ../development/libraries/java/smack { };

  swt = callPackage ../development/libraries/java/swt {
    inherit (gnome2) libsoup;
  };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  jquery = callPackage ../development/libraries/javascript/jquery { };

  jquery-ui = callPackage ../development/libraries/javascript/jquery-ui { };

  yuicompressor = callPackage ../development/tools/yuicompressor { };

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  buildBowerComponents = callPackage ../development/bower-modules/generic { };

  ### DEVELOPMENT / GO MODULES

  buildGo16Package = callPackage ../development/go-modules/generic {
    go = go_1_6;
  };

  buildGo17Package = callPackage ../development/go-modules/generic {
    go = go_1_7;
  };

  buildGoPackage = buildGo17Package;

  go2nix = callPackage ../development/tools/go2nix { };

  leaps = callPackage ../development/tools/leaps { };

  ### DEVELOPMENT / LISP MODULES

  asdf = callPackage ../development/lisp-modules/asdf {
    texLive = null;
  };

  clwrapperFunction = callPackage ../development/lisp-modules/clwrapper;

  wrapLisp = lisp: clwrapperFunction { inherit lisp; };

  lispPackagesFor = clwrapper: callPackage ../development/lisp-modules/lisp-packages.nix {
    inherit clwrapper;
  };

  lispPackagesClisp = lispPackagesFor (wrapLisp clisp);
  lispPackagesSBCL = lispPackagesFor (wrapLisp sbcl);
  lispPackages = recurseIntoAttrs lispPackagesSBCL;


  ### DEVELOPMENT / PERL MODULES

  buildPerlPackage = callPackage ../development/perl-modules/generic perl;

  perlPackages = recurseIntoAttrs (callPackage ./perl-packages.nix {
    overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });

  perlXMLParser = perlPackages.XMLParser;

  ack = perlPackages.ack;

  perlArchiveCpio = perlPackages.ArchiveCpio;

  perlcritic = perlPackages.PerlCritic;

  sqitchPg = callPackage ../development/tools/misc/sqitch {
    name = "sqitch-pg";
    databaseModule = perlPackages.DBDPg;
    sqitchModule = perlPackages.AppSqitch;
  };

  ### DEVELOPMENT / PYTHON MODULES

  # Python package sets.

  python27Packages = lib.hiPrioSet (recurseIntoAttrs python27.pkgs);

  python33Packages = python33.pkgs;

  python34Packages = python34.pkgs;

  python35Packages = recurseIntoAttrs python35.pkgs;

  python36Packages = python36.pkgs;

  pypyPackages = pypy.pkgs;

  ### DEVELOPMENT / R MODULES

  R = callPackage ../applications/science/math/R {
    # TODO: split docs into a separate output
    texLive = texlive.combine {
      inherit (texlive) scheme-small inconsolata helvetic texinfo fancyvrb cm-super;
    };
    openblas = openblasCompat;
    withRecommendedPackages = false;
    inherit (darwin.apple_sdk.frameworks) Cocoa Foundation;
    inherit (darwin) cf-private libobjc;
  };

  rWrapper = callPackage ../development/r-modules/wrapper.nix {
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

  "389-ds-base" = callPackage ../servers/ldap/389 {
    kerberos = libkrb5;
  };

  rdf4store = callPackage ../servers/http/4store { };

  apacheHttpd = pkgs.apacheHttpd_2_4;
  apacheHttpd_2_4 = callPackage ../servers/http/apache-httpd/2.4.nix { };

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

  apacheHttpdPackages = apacheHttpdPackagesFor pkgs.apacheHttpd pkgs.apacheHttpdPackages;
  apacheHttpdPackages_2_4 = apacheHttpdPackagesFor pkgs.apacheHttpd_2_4 pkgs.apacheHttpdPackages_2_4;

  archiveopteryx = callPackage ../servers/mail/archiveopteryx/default.nix { };

  atlassian-confluence = callPackage ../servers/atlassian/confluence.nix { };
  atlassian-crowd = callPackage ../servers/atlassian/crowd.nix { };
  atlassian-jira = callPackage ../servers/atlassian/jira.nix { };

  cadvisor = callPackage ../servers/monitoring/cadvisor { };

  cassandra_1_2 = callPackage ../servers/nosql/cassandra/1.2.nix { };
  cassandra_2_0 = callPackage ../servers/nosql/cassandra/2.0.nix { };
  cassandra_2_1 = callPackage ../servers/nosql/cassandra/2.1.nix { };
  cassandra_3_0 = callPackage ../servers/nosql/cassandra/3.0.nix { };
  cassandra = cassandra_3_0;

  apache-jena = callPackage ../servers/nosql/apache-jena/binary.nix {
    java = jdk;
  };

  apache-jena-fuseki = callPackage ../servers/nosql/apache-jena/fuseki-binary.nix {
    java = jdk;
  };

  fuseki = apache-jena-fuseki;

  apcupsd = callPackage ../servers/apcupsd { };

  asterisk = asterisk-stable;

  inherit (callPackages ../servers/asterisk { })
    asterisk-stable asterisk-lts;

  sabnzbd = callPackage ../servers/sabnzbd { };

  bftpd = callPackage ../servers/ftp/bftpd {};

  bind = callPackage ../servers/dns/bind { };
  dnsutils = bind.dnsutils;

  bird = callPackage ../servers/bird { };
  bird6 = bird.override { enableIPv6 = true; };

  bosun = callPackage ../servers/monitoring/bosun { };
  scollector = bosun;

  charybdis = callPackage ../servers/irc/charybdis {};

  couchdb = callPackage ../servers/http/couchdb {
    spidermonkey = spidermonkey_1_8_5;
    python = python27;
    sphinx = python27Packages.sphinx;
    erlang = erlangR16;
  };

  couchpotato = callPackage ../servers/couchpotato {};

  dico = callPackage ../servers/dico { };

  dict = callPackage ../servers/dict {
      libmaa = callPackage ../servers/dict/libmaa.nix {};
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix {});

  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix {};

  diod = callPackage ../servers/diod { lua = lua5_1; };

  dnschain = callPackage ../servers/dnschain { };

  dovecot = callPackage ../servers/mail/dovecot { };
  dovecot_pigeonhole = callPackage ../servers/mail/dovecot/plugins/pigeonhole { };
  dovecot_antispam = callPackage ../servers/mail/dovecot/plugins/antispam { };

  dspam = callPackage ../servers/mail/dspam {
    inherit (perlPackages) NetSMTP;
  };

  etcd = callPackage ../servers/etcd { };

  ejabberd = callPackage ../servers/xmpp/ejabberd { };

  prosody = callPackage ../servers/xmpp/prosody {
    lua5 = lua5_1;
    inherit (lua51Packages) luasocket luasec luaexpat luafilesystem luabitop luaevent luazlib;
  };

  elasticmq = callPackage ../servers/elasticmq { };

  eventstore = callPackage ../servers/nosql/eventstore {
    v8 = v8_3_24_10;
  };

  etcdctl = etcd;

  exim = callPackage ../servers/mail/exim { };

  fcgiwrap = callPackage ../servers/fcgiwrap { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { icu = null; };
  firebirdSuper = callPackage ../servers/firebird { superServer = true; };

  fleet = callPackage ../servers/fleet { };

  foswiki = callPackage ../servers/foswiki { };

  frab = callPackage ../servers/web-apps/frab { };

  freepops = callPackage ../servers/mail/freepops { };

  freeradius = callPackage ../servers/freeradius { };

  freeswitch = callPackage ../servers/sip/freeswitch {
    openssl = openssl_1_0_2;
  };

  gatling = callPackage ../servers/http/gatling { };

  glabels = callPackage ../applications/graphics/glabels { };

  gofish = callPackage ../servers/gopher/gofish { };

  grafana = callPackage ../servers/monitoring/grafana { };

  groovebasin = callPackage ../applications/audio/groovebasin { nodejs = nodejs-4_x; };

  haka = callPackage ../tools/security/haka { };

  heapster = callPackage ../servers/monitoring/heapster { };

  hbase = callPackage ../servers/hbase {};

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  jetty = callPackage ../servers/http/jetty { };

  knot-dns = callPackage ../servers/dns/knot-dns { };
  knot-resolver = callPackage ../servers/dns/knot-resolver {
    # TODO: vimNox after it gets fixed on Darwin or something lighter
    hexdump = if stdenv.isLinux then utillinux.bin else vim/*xxd*/;
  };

  rdkafka = callPackage ../development/libraries/rdkafka { };

  leafnode = callPackage ../servers/news/leafnode { };

  lighttpd = callPackage ../servers/http/lighttpd { };

  mailman = callPackage ../servers/mail/mailman { };

  mattermost = callPackage ../servers/mattermost { };
  matterircd = callPackage ../servers/mattermost/matterircd.nix { };

  mediatomb = callPackage ../servers/mediatomb { };

  memcached = callPackage ../servers/memcached {};

  meteor = callPackage ../servers/meteor/default.nix { };

  mfi = callPackage ../servers/mfi { };

  minio = callPackage ../servers/minio { };

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

  mpdscribble = callPackage ../tools/misc/mpdscribble { };

  micro-httpd = callPackage ../servers/http/micro-httpd { };

  miniHttpd = callPackage ../servers/http/mini-httpd {};

  mlmmj = callPackage ../servers/mail/mlmmj { };

  myserver = callPackage ../servers/http/myserver { };

  neard = callPackage ../servers/neard { };

  nginx = callPackage ../servers/http/nginx/stable.nix {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxMainline = callPackage ../servers/http/nginx/mainline.nix {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.dav nginxModules.moreheaders ];
  };

  nginxUnstable = nginxMainline;

  nginxModules = callPackage ../servers/http/nginx/modules.nix { };

  ngircd = callPackage ../servers/irc/ngircd { };

  nix-binary-cache = callPackage ../servers/http/nix-binary-cache {};

  nix-tour = callPackage ../applications/misc/nix-tour {};

  nsd = callPackage ../servers/dns/nsd (config.nsd or {});

  nsq = callPackage ../servers/nsq { };

  oauth2_proxy = callPackage ../servers/oauth2_proxy { };

  openpts = callPackage ../servers/openpts { };

  openresty = callPackage ../servers/http/openresty { };

  opensmtpd = callPackage ../servers/mail/opensmtpd { };
  opensmtpd-extras = callPackage ../servers/mail/opensmtpd/extras.nix { };

  openxpki = callPackage ../servers/openxpki { };

  osrm-backend = callPackage ../servers/osrm-backend { };

  p910nd = callPackage ../servers/p910nd { };

  petidomo = callPackage ../servers/mail/petidomo { };

  popa3d = callPackage ../servers/mail/popa3d { };

  postfix = callPackage ../servers/mail/postfix { };

  postsrsd = callPackage ../servers/mail/postsrsd { };

  rmilter = callPackage ../servers/mail/rmilter { };

  rspamd = callPackage ../servers/mail/rspamd { };

  pfixtools = callPackage ../servers/mail/postfix/pfixtools.nix {
    gperf = gperf_3_0;
  };
  pflogsumm = callPackage ../servers/mail/postfix/pflogsumm.nix { };

  postgrey = callPackage ../servers/mail/postgrey { };

  pshs = callPackage ../servers/http/pshs { };

  libpulseaudio = callPackage ../servers/pulseaudio {
    libOnly = true;
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  # Name is changed to prevent use in packages;
  # please use libpulseaudio instead.
  pulseaudioLight = callPackage ../servers/pulseaudio {
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  pulseaudioFull = callPackage ../servers/pulseaudio {
    gconf = gnome3.gconf;
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    gconfSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
    inherit (darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
  };

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  pies = callPackage ../servers/pies { };

  rpcbind = callPackage ../servers/rpcbind { };

  mariadb = callPackage ../servers/sql/mariadb {
    inherit (darwin) cctools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };

  mongodb = callPackage ../servers/nosql/mongodb {
    sasl = cyrus_sasl;
    boost = boost160;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  mongodb248 = callPackage ../servers/nosql/mongodb/2.4.8.nix { };

  riak = callPackage ../servers/nosql/riak/2.1.1.nix { };

  riak-cs = callPackage ../servers/nosql/riak-cs/2.1.1.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    erlang = erlang_basho_R16B02;
  };

  stanchion = callPackage ../servers/nosql/riak-cs/stanchion.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    erlang = erlang_basho_R16B02;
  };

  influxdb = callPackage ../servers/nosql/influxdb { };

  mysql55 = callPackage ../servers/sql/mysql/5.5.x.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mysql57 = callPackage ../servers/sql/mysql/5.7.x.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
    boost = boost159;
  };

  mysql = mariadb;
  libmysql = mysql.client; # `libmysql` is a slight misnomer ATM

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  nagios = callPackage ../servers/monitoring/nagios { };

  munin = callPackage ../servers/monitoring/munin { };

  nagiosPluginsOfficial = callPackage ../servers/monitoring/nagios/plugins/official-2.x.nix { };

  neo4j = callPackage ../servers/nosql/neo4j { };

  net_snmp = callPackage ../servers/monitoring/net-snmp { };

  newrelic-sysmond = callPackage ../servers/monitoring/newrelic-sysmond { };

  riemann = callPackage ../servers/monitoring/riemann { };
  riemann-dash = callPackage ../servers/monitoring/riemann-dash { };

  oidentd = callPackage ../servers/identd/oidentd { };

  openfire = callPackage ../servers/xmpp/openfire { };

  oracleXE = callPackage ../servers/sql/oracle-xe { };

  softether_4_18 = callPackage ../servers/softether/4.18.nix { };
  softether = softether_4_18;

  qboot = callPackage ../applications/virtualization/qboot { stdenv = stdenv_32bit; };

  OVMF = callPackage ../applications/virtualization/OVMF { seabios=false; openssl=null; };
  OVMF-CSM = callPackage ../applications/virtualization/OVMF { openssl=null; };
  #WIP: OVMF-secureBoot = callPackage ../applications/virtualization/OVMF { seabios=false; secureBoot=true; };

  seabios = callPackage ../applications/virtualization/seabios { };

  cbfstool = callPackage ../applications/virtualization/cbfstool { };

  vmfs-tools = callPackage ../tools/filesystems/vmfs-tools { };

  pgpool92 = pgpool.override { postgresql = postgresql92; };
  pgpool93 = pgpool.override { postgresql = postgresql93; };
  pgpool94 = pgpool.override { postgresql = postgresql94; };

  pgpool = callPackage ../servers/sql/pgpool/default.nix {
    pam = if stdenv.isLinux then pam else null;
    libmemcached = null; # Detection is broken upstream
  };

  postgresql = postgresql95;

  inherit (callPackages ../servers/sql/postgresql { })
    postgresql91
    postgresql92
    postgresql93
    postgresql94
    postgresql95
    postgresql96;

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  prom2json = callPackage ../servers/monitoring/prometheus/prom2json.nix { };
  prometheus = callPackage ../servers/monitoring/prometheus { };
  prometheus-alertmanager = callPackage ../servers/monitoring/prometheus/alertmanager.nix { };
  prometheus-bind-exporter = callPackage ../servers/monitoring/prometheus/bind-exporter.nix { };
  prometheus-blackbox-exporter = callPackage ../servers/monitoring/prometheus/blackbox-exporter.nix { };
  prometheus-collectd-exporter = callPackage ../servers/monitoring/prometheus/collectd-exporter.nix { };
  prometheus-haproxy-exporter = callPackage ../servers/monitoring/prometheus/haproxy-exporter.nix { };
  prometheus-json-exporter = callPackage ../servers/monitoring/prometheus/json-exporter.nix { };
  prometheus-mesos-exporter = callPackage ../servers/monitoring/prometheus/mesos-exporter.nix { };
  prometheus-mysqld-exporter = callPackage ../servers/monitoring/prometheus/mysqld-exporter.nix { };
  prometheus-nginx-exporter = callPackage ../servers/monitoring/prometheus/nginx-exporter.nix { };
  prometheus-node-exporter = callPackage ../servers/monitoring/prometheus/node-exporter.nix { };
  prometheus-pushgateway = callPackage ../servers/monitoring/prometheus/pushgateway.nix { };
  prometheus-snmp-exporter = callPackage ../servers/monitoring/prometheus/snmp-exporter.nix { };
  prometheus-statsd-bridge = callPackage ../servers/monitoring/prometheus/statsd-bridge.nix { };
  prometheus-varnish-exporter = callPackage ../servers/monitoring/prometheus/varnish-exporter.nix { };

  psqlodbc = callPackage ../servers/sql/postgresql/psqlodbc { };

  pumpio = callPackage ../servers/web-apps/pump.io { };

  pure-ftpd = callPackage ../servers/ftp/pure-ftpd { };

  pyIRCt = callPackage ../servers/xmpp/pyIRCt {};

  pyMAILt = callPackage ../servers/xmpp/pyMAILt {};

  qpid-cpp = callPackage ../servers/amqp/qpid-cpp {
    boost = boost155;
  };

  quagga = callPackage ../servers/quagga { };

  rabbitmq_server = callPackage ../servers/amqp/rabbitmq-server {
    inherit (darwin.apple_sdk.frameworks) AppKit Carbon Cocoa;
  };

  radicale = callPackage ../servers/radicale { };

  rake = callPackage ../development/tools/build-managers/rake { };

  redis = callPackage ../servers/nosql/redis { };

  redstore = callPackage ../servers/http/redstore { };

  restund = callPackage ../servers/restund {};

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    libtool = darwin.cctools;
  };

  rippled = callPackage ../servers/rippled {
    boost = boost159;
  };

  #ripple-rest = callPackage ../servers/rippled/ripple-rest.nix { };

  s6 = callPackage ../tools/system/s6 { };

  s6-rc = callPackage ../tools/system/s6-rc { };

  spamassassin = callPackage ../servers/mail/spamassassin {
    inherit (perlPackages) HTMLParser NetDNS NetAddrIP DBFile
      HTTPDate MailDKIM LWP IOSocketSSL;
  };

  deadpixi-sam-unstable = callPackage ../applications/editors/deadpixi-sam { };
  deadpixi-sam = deadpixi-sam-unstable;
  sam = deadpixi-sam;

  samba3 = callPackage ../servers/samba/3.x.nix { };

  samba4 = callPackage ../servers/samba/4.x.nix {
    python = python2;
    # enableLDAP
  };

  samba = samba4;

  smbclient = samba;

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
    enableInfiniband = true;
    enableLDAP = true;
    enablePrinting = true;
    enableMDNS = true;
    enableDomainController = true;
    enableRegedit = true;
    enableCephFS = true;
    enableGlusterFS = true;
  });

  sambaFull = samba4Full;

  shairport-sync = callPackage ../servers/shairport-sync { };

  serfdom = callPackage ../servers/serf { };

  seyren = callPackage ../servers/monitoring/seyren { };

  ruby-zoom = callPackage ../tools/text/ruby-zoom { };

  sensu = callPackage ../servers/monitoring/sensu {
    ruby = ruby_2_1;
  };

  shishi = callPackage ../servers/shishi {
      pam = if stdenv.isLinux then pam else null;
      # see also openssl, which has/had this same trick
  };

  sipcmd = callPackage ../applications/networking/sipcmd { };

  sipwitch = callPackage ../servers/sip/sipwitch { };

  smcroute = callPackage ../servers/smcroute { };

  spawn_fcgi = callPackage ../servers/http/spawn-fcgi { };

  squid = callPackage ../servers/squid { };
  squid4 = callPackage ../servers/squid/4.nix { };

  sslh = callPackage ../servers/sslh { };

  thttpd = callPackage ../servers/http/thttpd { };

  storm = callPackage ../servers/computing/storm { };

  slurm-llnl = callPackage ../servers/computing/slurm { gtk2 = null; };

  slurm-llnl-full = appendToName "full" (callPackage ../servers/computing/slurm { });

  systemd-journal2gelf = callPackage ../tools/system/systemd-journal2gelf { };

  inherit (callPackages ../servers/http/tomcat { })
    tomcat7
    tomcat8
    tomcat85
    tomcatUnstable;

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  torque = callPackage ../servers/computing/torque { };

  tt-rss = callPackage ../servers/tt-rss { };

  selfoss = callPackage ../servers/web-apps/selfoss { };

  shaarli = callPackage ../servers/web-apps/shaarli { };

  shaarli-material = callPackage ../servers/web-apps/shaarli/material-theme.nix { };

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  unifi = callPackage ../servers/unifi { };

  virtuoso6 = callPackage ../servers/sql/virtuoso/6.x.nix { };

  virtuoso7 = callPackage ../servers/sql/virtuoso/7.x.nix { };

  virtuoso = virtuoso6;

  vsftpd = callPackage ../servers/ftp/vsftpd { };

  wallabag = callPackage ../servers/web-apps/wallabag { };

  winstone = callPackage ../servers/http/winstone { };

  xinetd = callPackage ../servers/xinetd { };

  zookeeper = callPackage ../servers/zookeeper { };

  zookeeper_mt = callPackage ../development/libraries/zookeeper_mt { };

  xqilla = callPackage ../development/tools/xqilla { };

  xquartz = callPackage ../servers/x11/xquartz { };
  quartz-wm = callPackage ../servers/x11/quartz-wm {
    stdenv = clangStdenv;
    inherit (darwin.apple_sdk.frameworks) AppKit;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

  xorg = recurseIntoAttrs (lib.callPackagesWith pkgs ../servers/x11/xorg/default.nix {
    inherit clangStdenv fetchurl fetchgit fetchpatch stdenv pkgconfig intltool freetype fontconfig
      libxslt expat libpng zlib perl mesa_drivers spice_protocol libunwind
      dbus libuuid openssl gperf m4 libevdev tradcpp libinput mcpp makeWrapper autoreconfHook
      autoconf automake libtool xmlto asciidoc flex bison mtdev pixman
      cairo epoxy;
    inherit (darwin) apple_sdk cf-private libobjc;
    bootstrap_cmds = if stdenv.isDarwin then darwin.bootstrap_cmds else null;
    mesa = mesa_noglu;
    python = python2; # Incompatible with Python 3x
    udev = if stdenv.isLinux then udev else null;
    libdrm = if stdenv.isLinux then libdrm else null;
    abiCompat = config.xorg.abiCompat or null; # `config` because we have no `xorg.override`
  } // { inherit xlibsWrapper; } );

  xwayland = callPackage ../servers/x11/xorg/xwayland.nix { };

  yaws = callPackage ../servers/http/yaws { erlang = erlangR17; };

  zabbix = recurseIntoAttrs (callPackages ../servers/monitoring/zabbix {});

  zabbix20 = callPackage ../servers/monitoring/zabbix/2.0.nix { };
  zabbix22 = callPackage ../servers/monitoring/zabbix/2.2.nix { };


  ### OS-SPECIFIC

  afuse = callPackage ../os-specific/linux/afuse { };

  autofs5 = callPackage ../os-specific/linux/autofs { };

  _915resolution = callPackage ../os-specific/linux/915resolution { };

  nfs-utils = callPackage ../os-specific/linux/nfs-utils { };

  acpi = callPackage ../os-specific/linux/acpi { };

  acpid = callPackage ../os-specific/linux/acpid { };

  acpitool = callPackage ../os-specific/linux/acpitool { };

  alfred = callPackage ../os-specific/linux/batman-adv/alfred.nix { };

  alienfx = callPackage ../os-specific/linux/alienfx { };

  alsa-firmware = callPackage ../os-specific/linux/alsa-firmware { };

  alsaLib = callPackage ../os-specific/linux/alsa-lib { };

  alsaPlugins = callPackage ../os-specific/linux/alsa-plugins { };

  alsaPluginWrapper = callPackage ../os-specific/linux/alsa-plugins/wrapper.nix { };

  alsaUtils = callPackage ../os-specific/linux/alsa-utils { };
  alsaOss = callPackage ../os-specific/linux/alsa-oss { };
  alsaTools = callPackage ../os-specific/linux/alsa-tools { };

  microcodeAmd = callPackage ../os-specific/linux/microcode/amd.nix { };

  microcodeIntel = callPackage ../os-specific/linux/microcode/intel.nix { };

  inherit (callPackages ../os-specific/linux/apparmor { pythonPackages = python27Packages; swig = swig2; })
    libapparmor apparmor-pam apparmor-parser apparmor-profiles apparmor-utils;

  atop = callPackage ../os-specific/linux/atop { };

  audit = callPackage ../os-specific/linux/audit { };
  libaudit = audit;

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43Firmware_6_30_163_46 = callPackage ../os-specific/linux/firmware/b43-firmware/6.30.163.46.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  blktrace = callPackage ../os-specific/linux/blktrace { };

  bluez5 = callPackage ../os-specific/linux/bluez/bluez5.nix { };

  bluez4 = callPackage ../os-specific/linux/bluez { };

  # Needed for LibreOffice
  bluez5_28 = lowPrio (callPackage ../os-specific/linux/bluez/bluez5_28.nix { });

  bluez = bluez5;

  inherit (python3Packages) bedup;

  bridge-utils = callPackage ../os-specific/linux/bridge-utils { };

  busybox = callPackage ../os-specific/linux/busybox { };

  cachefilesd = callPackage ../os-specific/linux/cachefilesd { };

  cgmanager = callPackage ../os-specific/linux/cgmanager { };

  checkpolicy = callPackage ../os-specific/linux/checkpolicy { };

  checksec = callPackage ../os-specific/linux/checksec { };

  cifs-utils = callPackage ../os-specific/linux/cifs-utils { };

  cockroachdb = callPackage ../servers/sql/cockroachdb {
    gcc = gcc6; # needs gcc 6.0 and above
  };

  conky = callPackage ../os-specific/linux/conky ({
    lua = lua5_1; # conky can use 5.2, but toluapp can not
  } // config.conky or {});

  conntrack_tools = callPackage ../os-specific/linux/conntrack-tools { };

  coredns = callPackage ../servers/dns/coredns { };

  cpufrequtils = callPackage ../os-specific/linux/cpufrequtils { };

  criu = callPackage ../os-specific/linux/criu { };

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  cramfsswap = callPackage ../os-specific/linux/cramfsswap { };

  crda = callPackage ../os-specific/linux/crda { };

  darwin = let
    cmdline = callPackage ../os-specific/darwin/command-line-tools {};
    apple-source-releases = callPackage ../os-specific/darwin/apple-source-releases { };
  in apple-source-releases // rec {
    cctools_cross = callPackage (forcedNativePackages.callPackage ../os-specific/darwin/cctools/port.nix {}).cross {
      cross = assert targetPlatform != buildPlatform; targetPlatform;
      inherit maloader;
      xctoolchain = xcode.toolchain;
    };

    cctools = (callPackage ../os-specific/darwin/cctools/port.nix {
      inherit libobjc;
      stdenv = if stdenv.isDarwin then stdenv else libcxxStdenv;
    }).native;

    cf-private = callPackage ../os-specific/darwin/cf-private {
      inherit (apple-source-releases) CF;
      inherit osx_private_sdk;
    };

    maloader = callPackage ../os-specific/darwin/maloader {
      inherit opencflite;
    };

    opencflite = callPackage ../os-specific/darwin/opencflite {};

    swift-corefoundation = callPackage ../os-specific/darwin/swift-corefoundation {};

    ios-cross = callPackage ../os-specific/darwin/ios-cross {
      inherit (darwin) binutils;
    };

    xcode = callPackage ../os-specific/darwin/xcode {};

    osx_sdk = callPackage ../os-specific/darwin/osx-sdk {};
    osx_private_sdk = callPackage ../os-specific/darwin/osx-private-sdk {};

    security_tool = (newScope (darwin.apple_sdk.frameworks // darwin)) ../os-specific/darwin/security-tool {
      Security-framework = darwin.apple_sdk.frameworks.Security;
    };

    binutils = callPackage ../os-specific/darwin/binutils { inherit cctools; };

    cmdline_sdk   = cmdline.sdk;
    cmdline_tools = cmdline.tools;

    apple_sdk = callPackage ../os-specific/darwin/apple-sdk {};

    libobjc = apple-source-releases.objc4;

    stubs = callPackages ../os-specific/darwin/stubs {};

    usr-include = callPackage ../os-specific/darwin/usr-include {};

    DarwinTools = callPackage ../os-specific/darwin/DarwinTools {};
  };

  devicemapper = lvm2;

  disk_indicator = callPackage ../os-specific/linux/disk-indicator { };

  dmidecode = callPackage ../os-specific/linux/dmidecode { };

  dmtcp = callPackage ../os-specific/linux/dmtcp { };

  directvnc = callPackage ../os-specific/linux/directvnc { };

  dmraid = callPackage ../os-specific/linux/dmraid {
    devicemapper = devicemapper.override {enable_dmeventd = true;};
  };

  drbd = callPackage ../os-specific/linux/drbd { };

  dstat = callPackage ../os-specific/linux/dstat { };

  libossp_uuid = callPackage ../development/libraries/libossp-uuid { };

  libuuid =
    if targetPlatform != buildPlatform && targetPlatform.config == "i586-pc-gnu"
    then (utillinuxMinimal // {
      crossDrv = lib.overrideDerivation utillinuxMinimal.crossDrv (args: {
        # `libblkid' fails to build on GNU/Hurd.
        configureFlags = args.configureFlags
          + " --disable-libblkid --disable-mount --disable-libmount"
          + " --disable-fsck --enable-static --disable-partx";
        doCheck = false;
        CPPFLAGS =                    # ugly hack for ugly software!
          lib.concatStringsSep " "
            (map (v: "-D${v}=4096")
                 [ "PATH_MAX" "MAXPATHLEN" "MAXHOSTNAMELEN" ]);
      });
    })
    else if stdenv.isLinux
    then utillinuxMinimal
    else null;

  light = callPackage ../os-specific/linux/light { };

  lightum = callPackage ../os-specific/linux/lightum { };

  ebtables = callPackage ../os-specific/linux/ebtables { };

  eject = utillinux;

  facetimehd-firmware = callPackage ../os-specific/linux/firmware/facetimehd-firmware { };

  fanctl = callPackage ../os-specific/linux/fanctl {
    iproute = iproute.override { enableFan = true; };
  };

  fatrace = callPackage ../os-specific/linux/fatrace { };

  ffadoFull = callPackage ../os-specific/linux/ffado {
    inherit (python2Packages) python pyqt4 dbus-python;
  };
  libffado = ffadoFull.override { prefix = "lib"; };

  fbterm = callPackage ../os-specific/linux/fbterm { };

  firejail = callPackage ../os-specific/linux/firejail {};

  fnotifystat = callPackage ../os-specific/linux/fnotifystat { };

  forkstat = callPackage ../os-specific/linux/forkstat { };

  freefall = callPackage ../os-specific/linux/freefall {
    inherit (linuxPackages) kernel;
  };

  fuse = callPackage ../os-specific/linux/fuse {
    utillinux = utillinuxMinimal;
  };

  fusionio-util = callPackage ../os-specific/linux/fusionio/util.nix { };

  fxload = callPackage ../os-specific/linux/fxload { };

  gfxtablet = callPackage ../os-specific/linux/gfxtablet {};

  gpm = callPackage ../servers/gpm {
    ncurses = null;  # Keep curses disabled for lack of value
  };

  gpm-ncurses = gpm.override { inherit ncurses; };

  gradm = callPackage ../os-specific/linux/gradm {
    flex = flex_2_5_35;
  };

  hd-idle = callPackage ../os-specific/linux/hd-idle { };

  hdparm = callPackage ../os-specific/linux/hdparm { };

  hibernate = callPackage ../os-specific/linux/hibernate { };

  hostapd = callPackage ../os-specific/linux/hostapd { };

  htop = callPackage ../tools/system/htop {
    inherit (darwin) IOKit;
  };

  # GNU/Hurd core packages.
  gnu = recurseIntoAttrs (callPackage ../os-specific/gnu {
    inherit platform;
  });

  hwdata = callPackage ../os-specific/linux/hwdata { };

  i7z = callPackage ../os-specific/linux/i7z { };

  ima-evm-utils = callPackage ../os-specific/linux/ima-evm-utils { };

  intel2200BGFirmware = callPackage ../os-specific/linux/firmware/intel2200BGFirmware { };

  intel-ocl = callPackage ../os-specific/linux/intel-ocl { };

  iomelt = callPackage ../os-specific/linux/iomelt { };

  iotop = callPackage ../os-specific/linux/iotop { };

  iproute = callPackage ../os-specific/linux/iproute { };

  iputils = callPackage ../os-specific/linux/iputils {
    sp = spCompat;
    inherit (perlPackages) SGMLSpm;
  };

  iptables = callPackage ../os-specific/linux/iptables {
    flex = flex_2_5_35;
  };

  ipset = callPackage ../os-specific/linux/ipset { };

  irqbalance = callPackage ../os-specific/linux/irqbalance { };

  iw = callPackage ../os-specific/linux/iw { };

  jfbview = callPackage ../os-specific/linux/jfbview { };
  jfbpdf = callPackage ../os-specific/linux/jfbview {
    imageSupport = false;
  };

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  jujuutils = callPackage ../os-specific/linux/jujuutils { };

  kbd = callPackage ../os-specific/linux/kbd { };

  kbdKeymaps = callPackage ../os-specific/linux/kbd/keymaps.nix { };

  kbdlight = callPackage ../os-specific/linux/kbdlight { };

  kmscon = callPackage ../os-specific/linux/kmscon { };

  kmscube = callPackage ../os-specific/linux/kmscube { };

  latencytop = callPackage ../os-specific/linux/latencytop { };

  ldm = callPackage ../os-specific/linux/ldm { };

  libaio = callPackage ../os-specific/linux/libaio { };

  libatasmart = callPackage ../os-specific/linux/libatasmart { };

  libcgroup = callPackage ../os-specific/linux/libcgroup { };

  libnl = callPackage ../os-specific/linux/libnl { };

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  openiscsi = callPackage ../os-specific/linux/open-iscsi { };

  openisns = callPackage ../os-specific/linux/open-isns { };

  powerstat = callPackage ../os-specific/linux/powerstat { };

  smemstat = callPackage ../os-specific/linux/smemstat { };

  tgt = callPackage ../tools/networking/tgt { };

  # -- Linux kernel expressions ------------------------------------------------

  lkl = callPackage ../applications/virtualization/lkl { };

  linuxHeaders = linuxHeaders_4_4;

  linuxHeaders24Cross = forcedNativePackages.callPackage ../os-specific/linux/kernel-headers/2.4.nix {
    cross = assert targetPlatform != buildPlatform; targetPlatform;
  };

  linuxHeaders26Cross = forcedNativePackages.callPackage ../os-specific/linux/kernel-headers/4.4.nix {
    cross = assert targetPlatform != buildPlatform; targetPlatform;
  };

  linuxHeaders_4_4 = callPackage ../os-specific/linux/kernel-headers/4.4.nix { };

  # We can choose:
  linuxHeadersCrossChooser = ver : if ver == "2.4" then linuxHeaders24Cross
    else if ver == "2.6" then linuxHeaders26Cross
    else throw "Unknown linux kernel version";

  linuxHeadersCross = assert targetPlatform != buildPlatform;
    linuxHeadersCrossChooser targetPlatform.platform.kernelMajor;

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  klibc = callPackage ../os-specific/linux/klibc { };

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  linux_mptcp = callPackage ../os-specific/linux/kernel/linux-mptcp.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.packet_fix_race_condition_CVE_2016_8655
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_rpi = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = with kernelPatches; [
      bridge_stp_helper
      packet_fix_race_condition_CVE_2016_8655
    ];
  };

  linux_3_10 = callPackage ../os-specific/linux/kernel/linux-3.10.nix {
    kernelPatches = with kernelPatches;
      [ bridge_stp_helper
        lguest_entry-linkage
        packet_fix_race_condition_CVE_2016_8655
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_12 = callPackage ../os-specific/linux/kernel/linux-3.12.nix {
    kernelPatches = with kernelPatches;
      [ bridge_stp_helper
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_1 = callPackage ../os-specific/linux/kernel/linux-4.1.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_4 = callPackage ../os-specific/linux/kernel/linux-4.4.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.4"
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_9 = callPackage ../os-specific/linux/kernel/linux-4.9.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        # !!! 4.7 patch doesn't apply, 4.9 patch not up yet, will keep checking
        # kernelPatches.cpu-cgroup-v2."4.7"
        kernelPatches.modinst_arg_list_too_long
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_10 = callPackage ../os-specific/linux/kernel/linux-4.10.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        # !!! 4.7 patch doesn't apply, 4.9 patch not up yet, will keep checking
        # kernelPatches.cpu-cgroup-v2."4.7"
        kernelPatches.modinst_arg_list_too_long
      ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_testing = callPackage ../os-specific/linux/kernel/linux-testing.nix {
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.modinst_arg_list_too_long
    ] ++ lib.optionals ((platform.kernelArch or null) == "mips") [
      kernelPatches.mips_fpureg_emu
      kernelPatches.mips_fpu_sigill
      kernelPatches.mips_ext3_n32
    ];
  };

  linux_chromiumos_3_14 = callPackage ../os-specific/linux/kernel/linux-chromiumos-3.14.nix {
    kernelPatches = [ kernelPatches.chromiumos_Kconfig_fix_entries_3_14
                      kernelPatches.chromiumos_mfd_fix_dependency
                      kernelPatches.chromiumos_no_link_restrictions
                      kernelPatches.genksyms_fix_segfault
                    ];
  };

  linux_chromiumos_3_18 = callPackage ../os-specific/linux/kernel/linux-chromiumos-3.18.nix {
    kernelPatches = [ kernelPatches.chromiumos_Kconfig_fix_entries_3_18
                      kernelPatches.chromiumos_no_link_restrictions
                      kernelPatches.genksyms_fix_segfault
                    ];
  };

  linux_chromiumos_latest = linux_chromiumos_3_18;

  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: lib.makeExtensible (self: with self; {
    callPackage = newScope self;

    inherit kernel;

    accelio = callPackage ../development/libraries/accelio { };

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    amdgpu-pro = callPackage ../os-specific/linux/amdgpu-pro { };

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bcc = callPackage ../os-specific/linux/bcc { };

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    blcr = callPackage ../os-specific/linux/blcr { };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    displaylink = callPackage ../os-specific/linux/displaylink { };

    dpdk = callPackage ../os-specific/linux/dpdk { };

    exfat-nofuse = callPackage ../os-specific/linux/exfat { };

    pktgen = callPackage ../os-specific/linux/pktgen { };

    odp-dpdk = callPackage ../os-specific/linux/odp-dpdk { };

    ofp = callPackage ../os-specific/linux/ofp { };

    e1000e = callPackage ../os-specific/linux/e1000e {};

    ixgbevf = callPackage ../os-specific/linux/ixgbevf {};

    ena = callPackage ../os-specific/linux/ena {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    frandom = callPackage ../os-specific/linux/frandom { };

    fusionio-vsl = callPackage ../os-specific/linux/fusionio/vsl.nix { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta/default.nix { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidiaPackages = callPackage ../os-specific/linux/nvidia-x11 { };

    nvidia_x11_legacy173 = nvidiaPackages.legacy_173;
    nvidia_x11_legacy304 = nvidiaPackages.legacy_304;
    nvidia_x11_legacy340 = nvidiaPackages.legacy_340;
    nvidia_x11_beta      = nvidiaPackages.beta;
    nvidia_x11           = nvidiaPackages.stable;

    rtl8723bs = callPackage ../os-specific/linux/rtl8723bs { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    rtlwifi_new = callPackage ../os-specific/linux/rtlwifi_new { };

    openafsClient = callPackage ../servers/openafs-client { };

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

    seturgent = callPackage ../os-specific/linux/seturgent { };

    inherit (callPackage ../os-specific/linux/spl {
      configFile = "kernel";
      inherit kernel;
    }) splStable splUnstable;

    spl = splStable;

    sysdig = callPackage ../os-specific/linux/sysdig {};

    systemtap = callPackage ../development/tools/profiling/systemtap { };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

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
  });

  # The current default kernel / kernel modules.
  linuxPackages = linuxPackages_4_9;
  linux = linuxPackages.kernel;

  # Update this when adding the newest kernel major version!
  linuxPackages_latest = linuxPackages_4_10;
  linux_latest = linuxPackages_latest.kernel;

  # Build the kernel modules for the some of the kernels.
  linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_rpi = linuxPackagesFor pkgs.linux_rpi;
  linuxPackages_3_10 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_10);
  linuxPackages_3_12 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_12);
  linuxPackages_4_1 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_1);
  linuxPackages_4_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_4);
  linuxPackages_4_9 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_9);
  linuxPackages_4_10 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_4_10);
  # Don't forget to update linuxPackages_latest!

  # Intentionally lacks recurseIntoAttrs, as -rc kernels will quite likely break out-of-tree modules and cause failed Hydra builds.
  linuxPackages_testing = linuxPackagesFor pkgs.linux_testing;

  linuxPackages_custom = { version, src, configfile }:
    recurseIntoAttrs (linuxPackagesFor (pkgs.linuxManualConfig {
      inherit version src configfile;
      allowImportFromDerivation = true;
    }));

  # Build a kernel for Xen dom0
  linuxPackages_latest_xen_dom0 = recurseIntoAttrs (linuxPackagesFor (pkgs.linux_latest.override { features.xen_dom0=true; }));

  # Grsecurity packages

  linux_grsec_nixos = callPackage ../build-support/grsecurity {
    inherit (lib) overrideDerivation;
    kernel = callPackage ../os-specific/linux/kernel/linux-grsecurity.nix {
      kernelPatches = with self.kernelPatches; [
        bridge_stp_helper
        modinst_arg_list_too_long
      ] ++ lib.optionals ((platform.kernelArch or null) == "mips")
        [ kernelPatches.mips_fpureg_emu
          kernelPatches.mips_fpu_sigill
          kernelPatches.mips_ext3_n32
        ];
    };
    grsecPatch = self.kernelPatches.grsecurity_testing;
    kernelPatches = [ self.kernelPatches.grsecurity_nixos_kmod ];
    extraConfig = callPackage ../os-specific/linux/kernel/grsecurity-nixos-config.nix { };
  };

  linuxPackages_grsec_nixos =
    recurseIntoAttrs (linuxPackagesFor linux_grsec_nixos);

  # An unsupported grsec xen guest kernel
  linux_grsec_server_xen = linux_grsec_nixos.override {
    extraConfig = ''
      GRKERNSEC_CONFIG_AUTO y
      GRKERNSEC_CONFIG_PRIORITY_SECURITY y
      GRKERNSEC_CONFIG_SERVER y
      GRKERNSEC_CONFIG_VIRT_GUEST y
      GRKERNSEC_CONFIG_VIRT_XEN y
    '';
  };

  # ChromiumOS kernels
  linuxPackages_chromiumos_3_14 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_chromiumos_3_14);
  linuxPackages_chromiumos_3_18 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_chromiumos_3_18);
  linuxPackages_chromiumos_latest = recurseIntoAttrs (linuxPackagesFor pkgs.linux_chromiumos_latest);

  # A function to build a manually-configured kernel
  linuxManualConfig = pkgs.buildLinux;
  buildLinux = makeOverridable (callPackage ../os-specific/linux/kernel/manual-config.nix {});

  keyutils = callPackage ../os-specific/linux/keyutils { };

  libselinux = callPackage ../os-specific/linux/libselinux { };

  libsemanage = callPackage ../os-specific/linux/libsemanage { };

  libraw = callPackage ../development/libraries/libraw { };

  libraw1394 = callPackage ../development/libraries/libraw1394 { };

  libsass = callPackage ../development/libraries/libsass { };

  libsexy = callPackage ../development/libraries/libsexy { };

  libsepol = callPackage ../os-specific/linux/libsepol { };

  libsmbios = callPackage ../os-specific/linux/libsmbios { };

  lm_sensors = callPackage ../os-specific/linux/lm-sensors { };

  lockdep = callPackage ../os-specific/linux/lockdep { };

  lsiutil = callPackage ../os-specific/linux/lsiutil { };

  kmod = callPackage ../os-specific/linux/kmod { };

  kmod-blacklist-ubuntu = callPackage ../os-specific/linux/kmod-blacklist-ubuntu { };

  kmod-debian-aliases = callPackage ../os-specific/linux/kmod-debian-aliases { };

  kvm = qemu_kvm;

  libcap = callPackage ../os-specific/linux/libcap { };

  libcap_ng = callPackage ../os-specific/linux/libcap-ng {
    swig = null; # Currently not using the python2/3 bindings
    python2 = null; # Currently not using the python2 bindings
    python3 = null; # Currently not using the python3 bindings
  };

  libnscd = callPackage ../os-specific/linux/libnscd { };

  libnotify = callPackage ../development/libraries/libnotify { };

  libvolume_id = callPackage ../os-specific/linux/libvolume_id { };

  lsscsi = callPackage ../os-specific/linux/lsscsi { };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  mbpfan = callPackage ../os-specific/linux/mbpfan { };

  mdadm = callPackage ../os-specific/linux/mdadm { };
  mdadm4 = callPackage ../os-specific/linux/mdadm/4.nix { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  miraclecast = callPackage ../os-specific/linux/miraclecast { };

  mkinitcpio-nfs-utils = callPackage ../os-specific/linux/mkinitcpio-nfs-utils { };

  mmc-utils = callPackage ../os-specific/linux/mmc-utils { };

  aggregateModules = modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit modules;
    };

  multipath-tools = callPackage ../os-specific/linux/multipath-tools { };

  musl = callPackage ../os-specific/linux/musl { };

  nettools = callPackage ../os-specific/linux/net-tools { };

  nftables = callPackage ../os-specific/linux/nftables { };

  numactl = callPackage ../os-specific/linux/numactl { };

  numad = callPackage ../os-specific/linux/numad { };

  nvme-cli = callPackage ../os-specific/linux/nvme-cli { };

  open-vm-tools = callPackage ../applications/virtualization/open-vm-tools {
    inherit (gnome2) gtk gtkmm;
  };
  open-vm-tools-headless = open-vm-tools.override { withX = false; };

  delve = callPackage ../development/tools/delve { };

  go-bindata = callPackage ../development/tools/go-bindata { };

  go-bindata-assetfs = callPackage ../development/tools/go-bindata-assetfs { };

  gocode = callPackage ../development/tools/gocode { };

  kgocode = callPackage ../applications/misc/kgocode {
    inherit (pkgs.kde4) kdelibs;
  };

  gotags = callPackage ../development/tools/gotags { };

  golint = callPackage ../development/tools/golint { };

  godep = callPackage ../development/tools/godep { };

  godef = callPackage ../development/tools/godef { };

  goimports = callPackage ../development/tools/goimports { };

  govers = callPackage ../development/tools/govers { };

  gotools = callPackage ../development/tools/gotools { };

  gogoclient = callPackage ../os-specific/linux/gogoclient { };

  nss_ldap = callPackage ../os-specific/linux/nss_ldap { };

  pagemon = callPackage ../os-specific/linux/pagemon { };

  pam = callPackage ../os-specific/linux/pam { };

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

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils {
    firmware = config.pcmciaUtils.firmware or [];
    config = config.pcmciaUtils.config or null;
  };

  perf-tools = callPackage ../os-specific/linux/perf-tools { };

  pipes = callPackage ../misc/screensavers/pipes { };

  pipework = callPackage ../os-specific/linux/pipework { };

  plymouth = callPackage ../os-specific/linux/plymouth { };

  pmount = callPackage ../os-specific/linux/pmount { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  pmtools = callPackage ../os-specific/linux/pmtools { };

  policycoreutils = callPackage ../os-specific/linux/policycoreutils { };

  powerdns = callPackage ../servers/dns/powerdns { };

  pdns-recursor = callPackage ../servers/dns/pdns-recursor { };

  powertop = callPackage ../os-specific/linux/powertop { };

  prayer = callPackage ../servers/prayer { };

  procps = procps-ng;

  procps-ng = callPackage ../os-specific/linux/procps-ng { };

  watch = callPackage ../os-specific/linux/procps/watch.nix { };

  qemu_kvm = lowPrio (qemu.override { x86Only = true; });
  qemu_test = lowPrio (qemu.override { x86Only = true; nixosTestRunner = true; });

  firmwareLinuxNonfree = callPackage ../os-specific/linux/firmware/firmware-linux-nonfree { };

  radeontools = callPackage ../os-specific/linux/radeontools { };

  radeontop = callPackage ../os-specific/linux/radeontop { };

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi {};

  regionset = callPackage ../os-specific/linux/regionset { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  rtkit = callPackage ../os-specific/linux/rtkit { };

  rt5677-firmware = callPackage ../os-specific/linux/firmware/rt5677 { };

  rtl8723bs-firmware = callPackage ../os-specific/linux/firmware/rtl8723bs-firmware { };

  rtlwifi_new-firmware = callPackage ../os-specific/linux/firmware/rtlwifi_new-firmware { };

  s3ql = callPackage ../tools/backup/s3ql { };

  sass = callPackage ../development/tools/sass { };

  sassc = callPackage ../development/tools/sassc { };

  scanmem = callPackage ../tools/misc/scanmem { };

  schedtool = callPackage ../os-specific/linux/schedtool { };

  sdparm = callPackage ../os-specific/linux/sdparm { };

  sepolgen = callPackage ../os-specific/linux/sepolgen { };

  setools = callPackage ../os-specific/linux/setools { };

  shadow = callPackage ../os-specific/linux/shadow { };

  sinit = callPackage ../os-specific/linux/sinit {
    rcinit = "/etc/rc.d/rc.init";
    rcshutdown = "/etc/rc.d/rc.shutdown";
  };

  skopeo = callPackage ../development/tools/skopeo { };

  smem = callPackage ../os-specific/linux/smem { };

  statifier = callPackage ../os-specific/linux/statifier { };

  inherit (callPackage ../os-specific/linux/spl {
    configFile = "user";
  }) splStable splUnstable;

  spl = splStable;

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # pkgs.sysdig is a client, for a driver look at linuxPackagesFor

  sysfsutils = callPackage ../os-specific/linux/sysfsutils { };

  sysprof = callPackage ../development/tools/profiling/sysprof {
    inherit (gnome2) libglade;
  };

  # Provided with sysfsutils.
  libsysfs = sysfsutils;
  systool = sysfsutils;

  sysklogd = callPackage ../os-specific/linux/sysklogd { };

  syslinux = callPackage ../os-specific/linux/syslinux { };

  sysstat = callPackage ../os-specific/linux/sysstat { };

  systemd = callPackage ../os-specific/linux/systemd {
    utillinux = utillinuxMinimal; # break the cyclic dependency
    gperf = gperf_3_0; # fix build until v233
  }
    // {
      udev.bin = systemd;     # ${systemd.udev.bin}/bin/udevadm
      udev.lib = libudev.out; # ${systemd.udev.lib}/lib/libudev.*
    };

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

  sysvtools = callPackage ../os-specific/linux/sysvinit {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcp_wrappers = callPackage ../os-specific/linux/tcp-wrappers { };

  tiptop = callPackage ../os-specific/linux/tiptop { };

  tpacpi-bat = callPackage ../os-specific/linux/tpacpi-bat { };

  trinity = callPackage ../os-specific/linux/trinity { };

  tunctl = callPackage ../os-specific/linux/tunctl { };

  # TODO(dezgeg): either refactor & use ubootTools directly, or remove completely
  ubootChooser = name: ubootTools;

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot {})
    buildUBoot
    ubootTools
    ubootBananaPi
    ubootBeagleboneBlack
    ubootJetsonTK1
    ubootPcduino3Nano
    ubootRaspberryPi
    ubootRaspberryPi2
    ubootRaspberryPi3_32bit
    ubootRaspberryPi3_64bit
    ubootWandboard
    ;

  # Non-upstream U-Boots:
  ubootSheevaplug = callPackage ../misc/uboot/sheevaplug.nix { };

  ubootNanonote = callPackage ../misc/uboot/nanonote.nix { };

  ubootGuruplug = callPackage ../misc/uboot/guruplug.nix { };

  uclibc = callPackage ../os-specific/linux/uclibc { };

  uclibcCross = lowPrio (callPackage ../os-specific/linux/uclibc {
    linuxHeaders = linuxHeadersCross;
    gccCross = gccCrossStageStatic;
    cross = assert targetPlatform != buildPlatform; targetPlatform;
  });

  udev = systemd;
  libudev = udev;

  eudev = callPackage ../os-specific/linux/eudev {};

  libudev0-shim = callPackage ../os-specific/linux/libudev0-shim/default.nix { };

  udisks1 = callPackage ../os-specific/linux/udisks/1-default.nix { };
  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks1;

  udisks_glue = callPackage ../os-specific/linux/udisks-glue { };

  untie = callPackage ../os-specific/linux/untie { };

  upower = callPackage ../os-specific/linux/upower { };

  upstart = callPackage ../os-specific/linux/upstart { };

  usbutils = callPackage ../os-specific/linux/usbutils { };

  usermount = callPackage ../os-specific/linux/usermount { };

  utillinux = callPackage ../os-specific/linux/util-linux { };
  utillinuxCurses = utillinux;

  utillinuxMinimal = appendToName "minimal" (utillinux.override {
    minimal = true;
    ncurses = null;
    perl = null;
    systemd = null;
  });

  v4l_utils = callPackage ../os-specific/linux/v4l-utils {
    qt5 = null;
  };

  vndr = callPackage ../development/tools/vndr { };

  windows = rec {
    cygwinSetup = callPackage ../os-specific/windows/cygwin-setup { };

    jom = callPackage ../os-specific/windows/jom { };

    w32api = callPackage ../os-specific/windows/w32api {
      gccCross = gccCrossStageStatic;
      binutilsCross = binutilsCross;
    };

    w32api_headers = w32api.override {
      onlyHeaders = true;
    };

    mingw_runtime = callPackage ../os-specific/windows/mingwrt {
      gccCross = gccCrossMingw2;
      binutilsCross = binutilsCross;
    };

    mingw_runtime_headers = mingw_runtime.override {
      onlyHeaders = true;
    };

    mingw_headers1 = buildEnv {
      name = "mingw-headers-1";
      paths = [ w32api_headers mingw_runtime_headers ];
    };

    mingw_headers2 = buildEnv {
      name = "mingw-headers-2";
      paths = [ w32api mingw_runtime_headers ];
    };

    mingw_headers3 = buildEnv {
      name = "mingw-headers-3";
      paths = [ w32api mingw_runtime ];
    };

    mingw_w64 = callPackage ../os-specific/windows/mingw-w64 {
      gccCross = gccCrossStageStatic;
      binutilsCross = binutilsCross;
    };

    mingw_w64_headers = callPackage ../os-specific/windows/mingw-w64 {
      onlyHeaders = true;
    };

    mingw_w64_pthreads = callPackage ../os-specific/windows/mingw-w64 {
      onlyPthreads = true;
    };

    pthreads = callPackage ../os-specific/windows/pthread-w32 {
      mingw_headers = mingw_headers3;
    };

    wxMSW = callPackage ../os-specific/windows/wxMSW-2.8 { };
  };

  wirelesstools = callPackage ../os-specific/linux/wireless-tools { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant { };

  wpa_supplicant_gui = callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  xf86_input_mtrack = callPackage ../os-specific/linux/xf86-input-mtrack { };

  xf86_input_multitouch =
    callPackage ../os-specific/linux/xf86-input-multitouch { };

  xf86_input_wacom = callPackage ../os-specific/linux/xf86-input-wacom { };

  xf86_video_nested = callPackage ../os-specific/linux/xf86-video-nested { };

  xorg_sys_opengl = callPackage ../os-specific/linux/opengl/xorg-sys { };

  zd1211fw = callPackage ../os-specific/linux/firmware/zd1211 { };

  inherit (callPackage ../os-specific/linux/zfs {
    configFile = "user";
  }) zfsStable zfsUnstable;

  zfs = zfsStable;

  ### DATA

  adapta-backgrounds = callPackage ../data/misc/adapta-backgrounds { };

  andagii = callPackage ../data/fonts/andagii { };

  android-udev-rules = callPackage ../os-specific/linux/android-udev-rules { };

  anonymousPro = callPackage ../data/fonts/anonymous-pro { };

  arc-icon-theme = callPackage ../data/icons/arc-icon-theme { };

  arkpandora_ttf = callPackage ../data/fonts/arkpandora { };

  aurulent-sans = callPackage ../data/fonts/aurulent-sans { };

  baekmuk-ttf = callPackage ../data/fonts/baekmuk-ttf { };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

  bgnet = callPackage ../data/documentation/bgnet { };

  cacert = callPackage ../data/misc/cacert { };

  caladea = callPackage ../data/fonts/caladea {};

  cantarell_fonts = callPackage ../data/fonts/cantarell-fonts { };

  carlito = callPackage ../data/fonts/carlito {};

  comfortaa = callPackage ../data/fonts/comfortaa {};

  comic-neue = callPackage ../data/fonts/comic-neue { };

  comic-relief = callPackage ../data/fonts/comic-relief {};

  coreclr = callPackage ../development/compilers/coreclr { };

  corefonts = callPackage ../data/fonts/corefonts { };

  culmus = callPackage ../data/fonts/culmus { };

  clearlyU = callPackage ../data/fonts/clearlyU { };

  cm_unicode = callPackage ../data/fonts/cm-unicode {};

  crimson = callPackage ../data/fonts/crimson {};

  dejavu_fonts = lowPrio (callPackage ../data/fonts/dejavu-fonts {
    inherit (perlPackages) FontTTF;
  });

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

  docbook_xml_xslt = docbook_xsl;

  docbook5_xsl = docbook_xsl_ns;

  cabin = callPackage ../data/fonts/cabin { };

  camingo-code = callPackage ../data/fonts/camingo-code { };

  dosis = callPackage ../data/fonts/dosis { };

  dosemu_fonts = callPackage ../data/fonts/dosemu-fonts { };

  eb-garamond = callPackage ../data/fonts/eb-garamond { };

  faba-icon-theme = callPackage ../data/icons/faba-icon-theme { };

  faba-mono-icons = callPackage ../data/icons/faba-mono-icons { };

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
    inherit (pythonPackages) scfbuild;
  };

  encode-sans = callPackage ../data/fonts/encode-sans { };

  fantasque-sans-mono = callPackage ../data/fonts/fantasque-sans-mono {};

  fira = callPackage ../data/fonts/fira { };

  fira-code = callPackage ../data/fonts/fira-code { };

  fira-mono = callPackage ../data/fonts/fira-mono { };

  font-awesome-ttf = callPackage ../data/fonts/font-awesome-ttf { };

  freefont_ttf = callPackage ../data/fonts/freefont-ttf { };

  font-droid = callPackage ../data/fonts/droid { };

  freepats = callPackage ../data/misc/freepats { };

  gentium = callPackage ../data/fonts/gentium {};

  gentium-book-basic = callPackage ../data/fonts/gentium-book-basic {};

  geolite-legacy = callPackage ../data/misc/geolite-legacy { };

  gohufont = callPackage ../data/fonts/gohufont { };

  gnome_user_docs = callPackage ../data/documentation/gnome-user-docs { };

  inherit (gnome3) gsettings_desktop_schemas;

  go-font = callPackage ../data/fonts/go-font { };

  gyre-fonts = callPackage ../data/fonts/gyre {};

  hack-font = callPackage ../data/fonts/hack { };

  helvetica-neue-lt-std = callPackage ../data/fonts/helvetica-neue-lt-std { };

  hicolor_icon_theme = callPackage ../data/icons/hicolor-icon-theme { };

  hanazono = callPackage ../data/fonts/hanazono { };

  inconsolata = callPackage ../data/fonts/inconsolata {};
  inconsolata-lgc = callPackage ../data/fonts/inconsolata/lgc.nix {};

  input-fonts = callPackage ../data/fonts/input-fonts { };

  iosevka = callPackage ../data/fonts/iosevka { };

  ipafont = callPackage ../data/fonts/ipafont {};
  ipaexfont = callPackage ../data/fonts/ipaexfont {};

  junicode = callPackage ../data/fonts/junicode { };

  kawkab-mono-font = callPackage ../data/fonts/kawkab-mono {};

  kochi-substitute = callPackage ../data/fonts/kochi-substitute {};

  kochi-substitute-naga10 = callPackage ../data/fonts/kochi-substitute-naga10 {};

  lato = callPackage ../data/fonts/lato {};

  league-of-moveable-type = callPackage ../data/fonts/league-of-moveable-type {};

  inherit (callPackages ../data/fonts/redhat-liberation-fonts { })
    liberation_ttf_v1_from_source
    liberation_ttf_v1_binary
    liberation_ttf_v2_from_source
    liberation_ttf_v2_binary;
  liberation_ttf = liberation_ttf_v2_binary;

  liberationsansnarrow = callPackage ../data/fonts/liberationsansnarrow { };
  liberationsansnarrow_binary = callPackage ../data/fonts/liberationsansnarrow/binary.nix { };

  liberastika = callPackage ../data/fonts/liberastika { };

  libertine = callPackage ../data/fonts/libertine { };

  libre-baskerville = callPackage ../data/fonts/libre-baskerville { };

  libre-bodoni = callPackage ../data/fonts/libre-bodoni { };

  libre-caslon = callPackage ../data/fonts/libre-caslon { };

  libre-franklin = callPackage ../data/fonts/libre-franklin { };

  lmmath = callPackage ../data/fonts/lmodern/lmmath.nix {};

  lmodern = callPackage ../data/fonts/lmodern { };

  lobster-two = callPackage ../data/fonts/lobster-two {};

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  maia-icon-theme = callPackage ../data/icons/maia-icon-theme { };

  marathi-cursive = callPackage ../data/fonts/marathi-cursive { };

  man-pages = callPackage ../data/documentation/man-pages { };

  meslo-lg = callPackage ../data/fonts/meslo-lg {};

  miscfiles = callPackage ../data/misc/miscfiles { };

  media-player-info = callPackage ../data/misc/media-player-info {};

  mobile_broadband_provider_info = callPackage ../data/misc/mobile-broadband-provider-info { };

  mononoki = callPackage ../data/fonts/mononoki { };

  moka-icon-theme = callPackage ../data/icons/moka-icon-theme { };

  montserrat = callPackage ../data/fonts/montserrat { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  mplus-outline-fonts = callPackage ../data/fonts/mplus-outline-fonts { };

  mro-unicode = callPackage ../data/fonts/mro-unicode { };

  mustache-spec = callPackage ../data/documentation/mustache-spec { };

  nafees = callPackage ../data/fonts/nafees { };

  inherit (callPackages ../data/fonts/noto-fonts {})
    noto-fonts noto-fonts-cjk noto-fonts-emoji;

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme { };

  numix-icon-theme-circle = callPackage ../data/icons/numix-icon-theme-circle { };

  numix-icon-theme-square = callPackage ../data/icons/numix-icon-theme-square { };

  oldstandard = callPackage ../data/fonts/oldstandard { };

  oldsindhi = callPackage ../data/fonts/oldsindhi { };

  open-dyslexic = callPackage ../data/fonts/open-dyslexic { };

  opensans-ttf = callPackage ../data/fonts/opensans-ttf { };

  orbitron = callPackage ../data/fonts/orbitron { };

  overpass = callPackage ../data/fonts/overpass { };

  oxygenfonts = callPackage ../data/fonts/oxygenfonts { };

  paper-icon-theme = callPackage ../data/icons/paper-icon-theme { };

  pecita = callPackage ../data/fonts/pecita {};

  paratype-pt-mono = callPackage ../data/fonts/paratype-pt/mono.nix {};
  paratype-pt-sans = callPackage ../data/fonts/paratype-pt/sans.nix {};
  paratype-pt-serif = callPackage ../data/fonts/paratype-pt/serif.nix {};

  poly = callPackage ../data/fonts/poly { };

  posix_man_pages = callPackage ../data/documentation/man-pages-posix { };

  powerline-fonts = callPackage ../data/fonts/powerline-fonts { };

  profont = callPackage ../data/fonts/profont { };

  proggyfonts = callPackage ../data/fonts/proggyfonts { };

  sampradaya = callPackage ../data/fonts/sampradaya { };

  shaderc = callPackage ../development/compilers/shaderc { };

  shared_mime_info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  signwriting = callPackage ../data/fonts/signwriting { };

  soundfont-fluid = callPackage ../data/soundfonts/fluid { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  stix-otf = callPackage ../data/fonts/stix-otf { };

  inherit (callPackages ../data/fonts/gdouros { })
    symbola aegyptus akkadian anatolian maya unidings musica analecta;

  iana_etc = callPackage ../data/misc/iana-etc { };

  poppler_data = callPackage ../data/misc/poppler-data { };

  quattrocento = callPackage ../data/fonts/quattrocento {};

  quattrocento-sans = callPackage ../data/fonts/quattrocento-sans {};

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  raleway = callPackage ../data/fonts/raleway { };

  roboto = callPackage ../data/fonts/roboto { };

  roboto-mono = callPackage ../data/fonts/roboto-mono { };

  roboto-slab = callPackage ../data/fonts/roboto-slab { };

  hasklig = callPackage ../data/fonts/hasklig {};

  siji = callPackage ../data/fonts/siji { };

  sound-theme-freedesktop = callPackage ../data/misc/sound-theme-freedesktop { };

  source-code-pro = callPackage ../data/fonts/source-code-pro {};

  source-sans-pro = callPackage ../data/fonts/source-sans-pro { };

  source-serif-pro = callPackage ../data/fonts/source-serif-pro { };

  sourceHanSansPackages = callPackage ../data/fonts/source-han-sans { };
  source-han-sans-japanese = sourceHanSansPackages.japanese;
  source-han-sans-korean = sourceHanSansPackages.korean;
  source-han-sans-simplified-chinese = sourceHanSansPackages.simplified-chinese;
  source-han-sans-traditional-chinese = sourceHanSansPackages.traditional-chinese;

  inherit (callPackages ../data/fonts/tai-languages { }) tai-ahom;

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme {
    gtk = self.gtk2;
  };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) {};

  theano = callPackage ../data/fonts/theano { };

  tempora_lgc = callPackage ../data/fonts/tempora-lgc { };

  terminus_font = callPackage ../data/fonts/terminus-font { };

  terminus_font_ttf = callPackage ../data/fonts/terminus-font-ttf { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  tzdata = callPackage ../data/misc/tzdata { };

  ubuntu_font_family = callPackage ../data/fonts/ubuntu-font-family { };

  ucs-fonts = callPackage ../data/fonts/ucs-fonts { };

  uni-vga = callPackage ../data/fonts/uni-vga { };

  unifont = callPackage ../data/fonts/unifont { };

  unifont_upper = callPackage ../data/fonts/unifont_upper { };

  unscii = callPackage ../data/fonts/unscii { };

  vanilla-dmz = callPackage ../data/icons/vanilla-dmz { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  wireless-regdb = callPackage ../data/misc/wireless-regdb { };

  wqy_microhei = callPackage ../data/fonts/wqy-microhei { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xhtml1 = callPackage ../data/sgml+xml/schemas/xml-dtd/xhtml1 { };

  xits-math = callPackage ../data/fonts/xits-math { };

  xkeyboard_config = xorg.xkeyboardconfig;

  xlsx2csv = pythonPackages.xlsx2csv;

  zeal = qt5.callPackage ../data/documentation/zeal { };


  ### APPLICATIONS

  a2jmidid = callPackage ../applications/audio/a2jmidid { };

  aacgain = callPackage ../applications/audio/aacgain { };

  aangifte2006 = callPackage_i686 ../applications/taxes/aangifte-2006 { };

  aangifte2007 = callPackage_i686 ../applications/taxes/aangifte-2007 { };

  aangifte2008 = callPackage_i686 ../applications/taxes/aangifte-2008 { };

  aangifte2009 = callPackage_i686 ../applications/taxes/aangifte-2009 { };

  aangifte2010 = callPackage_i686 ../applications/taxes/aangifte-2010 { };

  aangifte2011 = callPackage_i686 ../applications/taxes/aangifte-2011 { };

  aangifte2012 = callPackage_i686 ../applications/taxes/aangifte-2012 { };

  aangifte2013 = callPackage_i686 ../applications/taxes/aangifte-2013 { };

  aangifte2014 = callPackage_i686 ../applications/taxes/aangifte-2014 { };

  aangifte2013wa = callPackage_i686 ../applications/taxes/aangifte-2013-wa { };

  aangifte2014wa = callPackage_i686 ../applications/taxes/aangifte-2014-wa { };

  abcde = callPackage ../applications/audio/abcde {
    inherit (perlPackages) DigestSHA MusicBrainz MusicBrainzDiscID;
    inherit (pythonPackages) eyeD3;
    libcdio = libcdio082;
  };

  abiword = callPackage ../applications/office/abiword {
    inherit (gnome2) libglade libgnomecanvas;
    iconTheme = gnome3.defaultIconTheme;
  };

  abook = callPackage ../applications/misc/abook { };

  acd-cli = callPackage ../applications/networking/sync/acd_cli {
    inherit (python35Packages)
      buildPythonApplication appdirs colorama dateutil
      requests2 requests_toolbelt sqlalchemy fusepy;
  };

  adobe-reader = callPackage_i686 ../applications/misc/adobe-reader { };

  aeolus = callPackage ../applications/audio/aeolus { };

  aewan = callPackage ../applications/editors/aewan { };

  afterstep = callPackage ../applications/window-managers/afterstep {
    fltk = fltk13;
    gtk = gtk2;
    stdenv = overrideCC stdenv gcc49;
  };

  ahoviewer = callPackage ../applications/graphics/ahoviewer { };

  airwave = callPackage ../applications/audio/airwave/default.nix { };

  alchemy = callPackage ../applications/graphics/alchemy { };

  alock = callPackage ../misc/screensavers/alock { };

  inherit (python2Packages) alot;

  alpine = callPackage ../applications/networking/mailreaders/alpine {
    tcl = tcl-8_5;
  };

  AMB-plugins = callPackage ../applications/audio/AMB-plugins { };

  ams-lv2 = callPackage ../applications/audio/ams-lv2 { };

  amsn = callPackage ../applications/networking/instant-messengers/amsn { };

  android-studio = callPackage ../applications/editors/android-studio {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };

  antfs-cli = callPackage ../applications/misc/antfs-cli {};

  antimony = qt5.callPackage ../applications/graphics/antimony {};

  antiword = callPackage ../applications/office/antiword {};

  ao = callPackage ../applications/graphics/ao {};

  aqemu = qt5.callPackage ../applications/virtualization/aqemu { };

  ardour = callPackage ../applications/audio/ardour {
    inherit (gnome2) libgnomecanvas libgnomecanvasmm;
    inherit (vamp) vampSDK;
  };

  ario = callPackage ../applications/audio/ario { };

  arora = callPackage ../applications/networking/browsers/arora { };

  artha = callPackage ../applications/misc/artha { };

  atomEnv = callPackage ../applications/editors/atom/env.nix {
    gconf = gnome2.GConf;
  };

  atom = callPackage ../applications/editors/atom { };

  aseprite = callPackage ../applications/editors/aseprite {
    giflib = giflib_4_1;
  };

  astroid = callPackage ../applications/networking/mailreaders/astroid { };

  audacious = callPackage ../applications/audio/audacious { };
  audaciousQt5 = qt5.callPackage ../applications/audio/audacious/qt-5.nix { };

  audacity = callPackage ../applications/audio/audacity { };

  audio-recorder = callPackage ../applications/audio/audio-recorder { };

  milkytracker = callPackage ../applications/audio/milkytracker { };

  schismtracker = callPackage ../applications/audio/schismtracker { };

  altcoins = recurseIntoAttrs ( callPackage ../applications/altcoins {
    callPackage = newScope { boost = boost155; };
  } );
  bitcoin = altcoins.bitcoin;
  bitcoin-xt = altcoins.bitcoin-xt;

  libbitcoin = callPackage ../tools/misc/libbitcoin/libbitcoin.nix {
    secp256k1 = secp256k1.override { enableECDH = true; };
  };

  libbitcoin-client = callPackage ../tools/misc/libbitcoin/libbitcoin-client.nix { };

  libbitcoin-explorer = callPackage ../tools/misc/libbitcoin/libbitcoin-explorer.nix { };

  go-ethereum = self.altcoins.go-ethereum;
  ethabi = self.altcoins.ethabi;

  stellar-core = self.altcoins.stellar-core;

  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  avidemux_unwrapped = callPackage ../applications/video/avidemux {
    libva = libva-full; # also wants libva-x11
  };

  avidemux = callPackage ../applications/video/avidemux/wrapper.nix { };

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

  avrdudess = callPackage ../applications/misc/avrdudess { };

  avxsynth = callPackage ../applications/video/avxsynth {
    libjpeg = libjpeg_original; # error: 'JCOPYRIGHT_SHORT' was not declared in this scope
    ffmpeg = ffmpeg_2;
  };

  awesome-3-5 = callPackage ../applications/window-managers/awesome/3.5.nix {
    cairo = cairo.override { xcbSupport = true; };
    luaPackages = luaPackages.override { inherit lua; };
  };
  awesome-4-0 = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    luaPackages = luaPackages.override { inherit lua; };
  };
  awesome = awesome-4-0;

  awesomebump = qt5.callPackage ../applications/graphics/awesomebump { };

  inherit (gnome3) baobab;

  backintime-common = callPackage ../applications/networking/sync/backintime/common.nix { };

  backintime-qt4 = callPackage ../applications/networking/sync/backintime/qt4.nix { };

  backintime = backintime-qt4;

  bandwidth = callPackage ../tools/misc/bandwidth { };

  baresip = callPackage ../applications/networking/instant-messengers/baresip {
    ffmpeg = ffmpeg_1;
  };

  banshee = callPackage ../applications/audio/banshee {
    gconf = pkgs.gnome2.GConf;
    libgpod = pkgs.libgpod.override { monoSupport = true; };
  };

  batik = callPackage ../applications/graphics/batik { };

  batti = callPackage ../applications/misc/batti { };

  baudline = callPackage ../applications/audio/baudline {
    jack = jack1;
  };


  bazaar = callPackage ../applications/version-management/bazaar { };

  bazaarTools = callPackage ../applications/version-management/bazaar/tools.nix { };

  beast = callPackage ../applications/audio/beast {
    inherit (gnome2) libgnomecanvas libart_lgpl;
    guile = guile_1_8;
  };

  bibletime = callPackage ../applications/misc/bibletime { };

  bitkeeper = callPackage ../applications/version-management/bitkeeper {
    gperf = gperf_3_0;
  };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };
  bitlbee-plugins = callPackage ../applications/networking/instant-messengers/bitlbee/plugins.nix { };

  bitlbee-facebook = callPackage ../applications/networking/instant-messengers/bitlbee-facebook { };

  bitlbee-steam = callPackage ../applications/networking/instant-messengers/bitlbee-steam { };

  bitmeter = callPackage ../applications/audio/bitmeter { };

  bitwig-studio =  callPackage ../applications/audio/bitwig-studio {
    inherit (gnome2) zenity;
  };

  bleachbit = callPackage ../applications/misc/bleachbit { };

  blender = callPackage  ../applications/misc/blender {
    cudatoolkit = cudatoolkit8;
    python = python35;
  };

  bluefish = callPackage ../applications/editors/bluefish {
    gtk = gtk3;
  };

  bluejeans = callPackage ../applications/networking/browsers/mozilla-plugins/bluejeans { };

  bomi = qt5.callPackage ../applications/video/bomi {
    youtube-dl = pythonPackages.youtube-dl;
    pulseSupport = config.pulseaudio or true;
    ffmpeg = ffmpeg_2;
  };

  brackets = callPackage ../applications/editors/brackets { gconf = gnome3.gconf; };

  bristol = callPackage ../applications/audio/bristol { };

  bs1770gain = callPackage ../applications/audio/bs1770gain {
    ffmpeg = ffmpeg_2;
  };

  bspwm = callPackage ../applications/window-managers/bspwm { };

  bspwm-unstable = callPackage ../applications/window-managers/bspwm/unstable.nix { };

  bvi = callPackage ../applications/editors/bvi { };

  bviplus = callPackage ../applications/editors/bviplus { };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome2) libglade;
  };

  calcurse = callPackage ../applications/misc/calcurse { };

  calibre = qt5.callPackage ../applications/misc/calibre { };

  camlistore = callPackage ../applications/misc/camlistore { };

  canto-curses = callPackage ../applications/networking/feedreaders/canto-curses { };

  canto-daemon = callPackage ../applications/networking/feedreaders/canto-daemon { };

  carddav-util = callPackage ../tools/networking/carddav-util { };

  catfish = callPackage ../applications/search/catfish {
    pythonPackages = python2Packages;
  };

  cava = callPackage ../applications/audio/cava { };

  cb2bib = qt5.callPackage ../applications/office/cb2bib { };

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

  cdrtools = callPackage ../applications/misc/cdrtools { };

  centerim = callPackage ../applications/networking/instant-messengers/centerim { };

  cgit = callPackage ../applications/version-management/git-and-tools/cgit { };

  cgminer = callPackage ../applications/misc/cgminer {
    amdappsdk = amdappsdk28;
  };

  chatzilla = callPackage ../applications/networking/irc/chatzilla { };

  chirp = callPackage ../applications/misc/chirp {
    inherit (pythonPackages) pyserial pygtk;
  };

  chromium = callPackage ../applications/networking/browsers/chromium {
    channel = "stable";
    pulseSupport = config.pulseaudio or true;
    enablePepperFlash = config.chromium.enablePepperFlash or false;
    enableWideVine = config.chromium.enableWideVine or false;
    gnome = gnome2;
  };

  chronos = callPackage ../applications/networking/cluster/chronos { };

  chromiumBeta = lowPrio (chromium.override { channel = "beta"; });

  chromiumDev = lowPrio (chromium.override { channel = "dev"; });

  chuck = callPackage ../applications/audio/chuck { };

  cinelerra = callPackage ../applications/video/cinelerra { };

  claws-mail = callPackage ../applications/networking/mailreaders/claws-mail {
    inherit (gnome3) gsettings_desktop_schemas;
    enableNetworkManager = config.networking.networkmanager.enable or false;
  };

  clfswm = callPackage ../applications/window-managers/clfswm { };

  clipgrab = callPackage ../applications/video/clipgrab { };

  clipit = callPackage ../applications/misc/clipit { };

  cmatrix = callPackage ../applications/misc/cmatrix { };

  cmus = callPackage ../applications/audio/cmus {
    inherit (darwin.apple_sdk.frameworks) CoreAudio;
    libjack = libjack2;
    libcdio = libcdio082;
    ffmpeg = ffmpeg_2;

    pulseaudioSupport = config.pulseaudio or false;
  };

  cni = callPackage ../applications/networking/cluster/cni {};

  communi = qt5.callPackage ../applications/networking/irc/communi { };

  compiz = callPackage ../applications/window-managers/compiz {
    inherit (gnome2) GConf ORBit2 metacity;
  };

  confclerk = callPackage ../applications/misc/confclerk { };

  copyq = callPackage ../applications/misc/copyq { };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome2) libgnomeui GConf;
  };

  cortex = callPackage ../applications/misc/cortex { };

  csound = callPackage ../applications/audio/csound { };

  cinepaint = callPackage ../applications/graphics/cinepaint {
    fltk = fltk13;
    libpng = libpng12;
    cmake = cmake_2_8;
  };

  codeblocks = callPackage ../applications/editors/codeblocks { };
  codeblocksFull = callPackage ../applications/editors/codeblocks { contribPlugins = true; };

  comical = callPackage ../applications/graphics/comical { };

  conkeror-unwrapped = callPackage ../applications/networking/browsers/conkeror { };
  conkeror = wrapFirefox conkeror-unwrapped { };

  containerd = callPackage ../applications/virtualization/containerd { };

  convchain = callPackage ../tools/graphics/convchain {};

  cpp_ethereum = callPackage ../applications/misc/cpp-ethereum { };

  csdp = callPackage ../applications/science/math/csdp {
    liblapack = liblapackWithoutAtlas;
  };

  cuneiform = callPackage ../tools/graphics/cuneiform {};

  cutecom = callPackage ../tools/misc/cutecom { };

  cutegram =
    let callpkg = qt55.callPackage;
    in callpkg ../applications/networking/instant-messengers/telegram/cutegram rec {
      libqtelegram-aseman-edition = callpkg ../applications/networking/instant-messengers/telegram/libqtelegram-aseman-edition { };
      telegram-qml = callpkg ../applications/networking/instant-messengers/telegram/telegram-qml {
        inherit libqtelegram-aseman-edition;
      };
    };

  cvs = callPackage ../applications/version-management/cvs { };

  cvsps = callPackage ../applications/version-management/cvsps { };

  cvs2svn = callPackage ../applications/version-management/cvs2svn { };

  cwm = callPackage ../applications/window-managers/cwm { };

  cyclone = callPackage ../applications/audio/pd-plugins/cyclone  { };

  d4x = callPackage ../applications/misc/d4x { };

  darcs = haskell.lib.overrideCabal haskellPackages.darcs (drv: {
    configureFlags = (stdenv.lib.remove "-flibrary" drv.configureFlags or []) ++ ["-f-library"];
    enableSharedExecutables = false;
    enableSharedLibraries = false;
    isLibrary = false;
    doHaddock = false;
    postFixup = "rm -rf $out/lib $out/nix-support $out/share";
  });

  darktable = callPackage ../applications/graphics/darktable {
    inherit (gnome2) GConf libglade;
    pugixml = pugixml.override { shared = true; };
  };

  das_watchdog = callPackage ../tools/system/das_watchdog { };

  dbvisualizer = callPackage ../applications/misc/dbvisualizer {};

  dd-agent = callPackage ../tools/networking/dd-agent { inherit (pythonPackages) tornado; };

  deadbeef = callPackage ../applications/audio/deadbeef {
    pulseSupport = config.pulseaudio or true;
  };

  deadbeef-mpris2-plugin = callPackage ../applications/audio/deadbeef/plugins/mpris2.nix { };

  deadbeef-with-plugins = callPackage ../applications/audio/deadbeef/wrapper.nix {
    plugins = [];
  };

  dfasma = qt5.callPackage ../applications/audio/dfasma { };

  dfilemanager = qt5.callPackage ../applications/misc/dfilemanager { };

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome2) libart_lgpl libgnomeui;
  };

  diffuse = callPackage ../applications/version-management/diffuse { };

  direwolf = callPackage ../applications/misc/direwolf { };

  dirt = callPackage ../applications/audio/dirt {};

  distrho = callPackage ../applications/audio/distrho {};

  djvulibre = callPackage ../applications/misc/djvulibre { };

  djvu2pdf = callPackage ../tools/typesetting/djvu2pdf { };

  djview = callPackage ../applications/graphics/djview { };
  djview4 = pkgs.djview;

  dmenu = callPackage ../applications/misc/dmenu { };

  dmenu-wayland = callPackage ../applications/misc/dmenu/wayland.nix { };

  dmenu2 = callPackage ../applications/misc/dmenu2 { };

  dmtx = dmtx-utils;

  dmtx-utils = callPackage (callPackage ../tools/graphics/dmtx-utils) {
  };

  docker = callPackage ../applications/virtualization/docker { };
  docker-proxy = callPackage ../applications/virtualization/docker/proxy.nix { };

  docker-gc = callPackage ../applications/virtualization/docker/gc.nix { };

  docker-machine = callPackage ../applications/networking/cluster/docker-machine { };
  docker-machine-kvm = callPackage ../applications/networking/cluster/docker-machine/kvm.nix { };

  docker-distribution = callPackage ../applications/virtualization/docker-distribution { };

  doodle = callPackage ../applications/search/doodle { };

  droopy = callPackage ../applications/networking/droopy {
    inherit (python3Packages) wrapPython;
  };

  drumgizmo = callPackage ../applications/audio/drumgizmo { };

  dunst = callPackage ../applications/misc/dunst { };

  devede = callPackage ../applications/video/devede { };

  dvb_apps  = callPackage ../applications/video/dvb-apps { };

  dvdauthor = callPackage ../applications/video/dvdauthor { };

  dvdbackup = callPackage ../applications/video/dvdbackup { };

  dvd-slideshow = callPackage ../applications/video/dvd-slideshow { };

  dwb-unwrapped = callPackage ../applications/networking/browsers/dwb { dconf = gnome3.dconf; };
  dwb = wrapFirefox dwb-unwrapped { desktopName = "dwb"; };

  dwm = callPackage ../applications/window-managers/dwm {
    patches = config.dwm.patches or [];
  };

  evilwm = callPackage ../applications/window-managers/evilwm {
    patches = config.evilwm.patches or [];
  };

  dzen2 = callPackage ../applications/window-managers/dzen2 { };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse { });

  ecs-agent = callPackage ../applications/virtualization/ecs-agent { };

  ed = callPackage ../applications/editors/ed { };

  edbrowse = callPackage ../applications/editors/edbrowse { };

  ekho = callPackage ../applications/audio/ekho { };

  electrum = callPackage ../applications/misc/electrum { };

  electrum-dash = callPackage ../applications/misc/electrum-dash { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs25;
  emacsPackages = emacs25Packages;
  emacsPackagesNg = emacs25PackagesNg;
  emacsMelpa = emacs25PackagesNg; # for backward compatibility

  emacs25 = callPackage ../applications/editors/emacs {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin.apple_sdk.frameworks) AppKit CoreWLAN GSS Kerberos ImageIO;
  };

  emacs25-nox = lowPrio (appendToName "nox" (emacs25.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacs24Macport_24_5 = lowPrio (callPackage ../applications/editors/emacs/macport-24.5.nix {
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
  });
  emacs24Macport = self.emacs24Macport_24_5;

  emacs25Macport_25_1 = lowPrio (callPackage ../applications/editors/emacs/macport-25.1.nix {
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
  });
  emacs25Macport = self.emacs25Macport_25_1;

  emacsPackagesGen = emacs: self: let callPackage = newScope self; in rec {
    inherit emacs;

    autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };

    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };

    bbdb3 = callPackage ../applications/editors/emacs-modes/bbdb/3.nix {};

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    calfw = callPackage ../applications/editors/emacs-modes/calfw { };

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

  emacs25Packages = emacsPackagesGen emacs25 pkgs.emacs25Packages;

  emacsPackagesNgGen = emacs: import ./emacs-packages.nix {
    overrides = (config.emacsPackageOverrides or (p: {})) pkgs;

    inherit lib newScope stdenv;
    inherit fetchFromGitHub fetchgit fetchhg fetchurl;
    inherit emacs texinfo makeWrapper runCommand;
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
      inherit rtags libffi autoconf automake libpng zlib poppler pkgconfig w3m;
    };
  };

  emacs25PackagesNg = emacsPackagesNgGen emacs25;

  emacs25WithPackages = emacs25PackagesNg.emacsWithPackages;
  emacsWithPackages = emacsPackagesNg.emacsWithPackages;

  # inherit (gnome3) empathy;

  enhanced-ctorrent = callPackage ../applications/networking/enhanced-ctorrent { };

  epdfview = callPackage ../applications/misc/epdfview { };

  inherit (gnome3) epiphany;

  epic5 = callPackage ../applications/networking/irc/epic5 { };

  eq10q = callPackage ../applications/audio/eq10q { };

  errbot = callPackage ../applications/networking/errbot {
    pythonPackages = python3Packages;
  };

  espeak-classic = callPackage ../applications/audio/espeak { };

  espeak-ng = callPackage ../applications/audio/espeak-ng { };
  espeak = self.espeak-ng;

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  esniper = callPackage ../applications/networking/esniper { };

  eterm = callPackage ../applications/misc/eterm { };

  etherape = callPackage ../applications/networking/sniffers/etherape {
    inherit (gnome2) gnomedocutils libgnome libglade libgnomeui scrollkeeper;
  };

  evilvte = callPackage ../applications/misc/evilvte {
    configH = config.evilvte.config or "";
  };

  evopedia = callPackage ../applications/misc/evopedia { };

  exercism = callPackage ../applications/misc/exercism { };

  gpg-mdp = callPackage ../applications/misc/gpg-mdp { };

  keepassx = callPackage ../applications/misc/keepassx { };
  keepassx2 = callPackage ../applications/misc/keepassx/2.0.nix { };
  keepassx-community = qt5.callPackage ../applications/misc/keepassx/community.nix { };

  inherit (gnome3) evince;
  evolution_data_server = gnome3.evolution_data_server;

  keepass = callPackage ../applications/misc/keepass { };

  keepass-keefox = callPackage ../applications/misc/keepass-plugins/keefox { };

  keepass-keepasshttp = callPackage ../applications/misc/keepass-plugins/keepasshttp { };

  exrdisplay = callPackage ../applications/graphics/exrdisplay { };

  exrtools = callPackage ../applications/graphics/exrtools { };

  fbpanel = callPackage ../applications/window-managers/fbpanel { };

  fbreader = callPackage ../applications/misc/fbreader { };

  fehlstart = callPackage ../applications/misc/fehlstart { };

  fetchmail = callPackage ../applications/misc/fetchmail { };

  flacon = callPackage ../applications/audio/flacon { };

  flexget = callPackage ../applications/networking/flexget { };

  fldigi = callPackage ../applications/audio/fldigi { };

  fluidsynth = callPackage ../applications/audio/fluidsynth {
     inherit (darwin.apple_sdk.frameworks) CoreServices CoreAudio AudioUnit;
  };

  fmit = qt5.callPackage ../applications/audio/fmit { };

  fmsynth = callPackage ../applications/audio/fmsynth { };

  focuswriter = callPackage ../applications/editors/focuswriter { };

  font-manager = callPackage ../applications/misc/font-manager { };

  foo-yc20 = callPackage ../applications/audio/foo-yc20 { };

  fossil = callPackage ../applications/version-management/fossil { };

  freebayes = callPackage ../applications/science/biology/freebayes { };

  freewheeling = callPackage ../applications/audio/freewheeling { };

  fribid = callPackage ../applications/networking/browsers/mozilla-plugins/fribid { };

  fritzing = qt5.callPackage ../applications/science/electronics/fritzing { };

  fvwm = callPackage ../applications/window-managers/fvwm { };

  ganttproject-bin = callPackage ../applications/misc/ganttproject-bin { };

  geany = callPackage ../applications/editors/geany { };
  geany-with-vte = callPackage ../applications/editors/geany/with-vte.nix { };

  gksu = callPackage ../applications/misc/gksu { };

  gnuradio = callPackage ../applications/misc/gnuradio {
    inherit (python2Packages) cheetah lxml matplotlib numpy python pyopengl pyqt4 scipy wxPython pygtk;
    fftw = fftwFloat;
  };

  gnuradio-with-packages = callPackage ../applications/misc/gnuradio/wrapper.nix {
    inherit (python2Packages) python;
    extraPackages = [ gnuradio-nacl gnuradio-osmosdr gnuradio-gsm gnuradio-ais gnuradio-rds ];
  };

  gnuradio-nacl = callPackage ../applications/misc/gnuradio-nacl { };

  gnuradio-gsm = callPackage ../applications/misc/gnuradio-gsm { };

  gnuradio-ais = callPackage ../applications/misc/gnuradio-ais { };

  gnuradio-rds = callPackage ../applications/misc/gnuradio-rds { };

  gnuradio-osmosdr = callPackage ../applications/misc/gnuradio-osmosdr { };

  goldendict = qt55.callPackage ../applications/misc/goldendict { };

  inherit (ocamlPackages) google-drive-ocamlfuse;

  google-musicmanager = callPackage ../applications/audio/google-musicmanager { };

  gopher = callPackage ../applications/networking/gopher/gopher { };

  gpa = callPackage ../applications/misc/gpa { };

  gpicview = callPackage ../applications/graphics/gpicview {
    gtk2 = gtk2-x11;
  };

  gqrx = callPackage ../applications/misc/gqrx { };

  grass = callPackage ../applications/gis/grass { };

  grepm = callPackage ../applications/search/grepm { };

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

  puddletag = callPackage ../applications/audio/puddletag { };

  w_scan = callPackage ../applications/video/w_scan { };

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wavrsocvt = callPackage ../applications/misc/audio/wavrsocvt { };

  wireshark-cli = callPackage ../applications/networking/sniffers/wireshark {
    withQt = false;
    withGtk = false;
    inherit (darwin.apple_sdk.frameworks) ApplicationServices SystemConfiguration;
  };
  # The GTK UI is deprecated by upstream. You probably want the QT version.
  wireshark-gtk = wireshark-cli.override { withGtk = true; };
  wireshark-qt = wireshark-cli.override { withQt = true; };
  wireshark = wireshark-qt;

  wvdial = callPackage ../os-specific/linux/wvdial { };

  fbida = callPackage ../applications/graphics/fbida { };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  filezilla = callPackage ../applications/networking/ftp/filezilla { };

  inherit (callPackages ../applications/networking/browsers/firefox {
    inherit (gnome2) libIDL;
    libpng = libpng_apng;
    enableGTK3 = false;
    python = python2;
    gnused = gnused_422;
  }) firefox-unwrapped firefox-esr-unwrapped;

  firefox = wrapFirefox firefox-unwrapped { };
  firefox-esr = wrapFirefox firefox-esr-unwrapped { };

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
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

  firefox-beta-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
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

  firestr = qt5.callPackage ../applications/networking/p2p/firestr
    { boost = boost155;
    };

  flac = callPackage ../applications/audio/flac { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer {
      debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer/standalone.nix {
      debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone-debugger = flashplayer-standalone.override {
      debug = true;
  };

  fluxbox = callPackage ../applications/window-managers/fluxbox { };

  fme = callPackage ../applications/misc/fme {
    inherit (gnome2) libglademm;
  };

  fomp = callPackage ../applications/audio/fomp { };

  freecad = callPackage ../applications/graphics/freecad {
    boost = boost155;
    opencascade = opencascade_oce;
  };

  freemind = callPackage ../applications/misc/freemind { };

  freenet = callPackage ../applications/networking/p2p/freenet { };

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
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

  freicoin = callPackage ../applications/misc/freicoin {
    boost = boost155;
  };

  fte = callPackage ../applications/editors/fte { };

  game-music-emu = callPackage ../applications/audio/game-music-emu { };

  gcalcli = callPackage ../applications/misc/gcalcli { };

  gcolor2 = callPackage ../applications/graphics/gcolor2 { };

  get_iplayer = callPackage ../applications/misc/get_iplayer {};

  getxbook = callPackage ../applications/misc/getxbook {};

  gimp_2_8 = callPackage ../applications/graphics/gimp/2.8.nix {
    inherit (gnome2) libart_lgpl;
    webkit = null;
    lcms = lcms2;
    inherit (darwin.apple_sdk.frameworks) AppKit Cocoa;
  };

  gimp = gimp_2_8;

  gimp-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    gimp = gimp_2_8;
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimpPlugins = recurseIntoAttrs (callPackage ../applications/graphics/gimp/plugins {});

  girara = callPackage ../applications/misc/girara {
    gtk = gtk3;
  };

  girara-light = callPackage ../applications/misc/girara {
    gtk = gtk3;
    withBuildColors = false;
    ncurses = null;
  };

  gitAndTools = recurseIntoAttrs (callPackage ../applications/version-management/git-and-tools {});

  inherit (gitAndTools) git gitFull gitSVN git-cola svn2git git-radar transcrypt git-crypt;

  gitMinimal = git.override {
    withManual = false;
    pythonSupport = false;
  };

  gitRepo = callPackage ../applications/version-management/git-repo {
    python = python27;
  };

  git-review = callPackage ../applications/version-management/git-review {
    python = python27;
  };

  gitolite = callPackage ../applications/version-management/gitolite { };

  inherit (gnome3) gitg;

  giv = callPackage ../applications/graphics/giv { };

  gmrun = callPackage ../applications/misc/gmrun {};

  gnucash = callPackage ../applications/office/gnucash {
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
    webkit = webkitgtk2;
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

  idea = recurseIntoAttrs (callPackages ../applications/editors/idea { androidsdk = androidsdk_extras; });

  libquvi = callPackage ../applications/video/quvi/library.nix { };

  linssid = qt5.callPackage ../applications/networking/linssid { };

  manuskript = callPackage ../applications/editors/manuskript { };

  manul = callPackage ../development/tools/manul { };

  mi2ly = callPackage ../applications/audio/mi2ly {};

  praat = callPackage ../applications/audio/praat { };

  quvi = callPackage ../applications/video/quvi/tool.nix {
    lua5_sockets = lua5_1_sockets;
    lua5 = lua5_1;
  };

  quvi_scripts = callPackage ../applications/video/quvi/scripts.nix { };

  svox = callPackage ../applications/audio/svox { };

  gkrellm = callPackage ../applications/misc/gkrellm {
    inherit (darwin) IOKit;
  };

  gmu = callPackage ../applications/audio/gmu { };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer {
    inherit (gnome2) GConf;
  };

  gnumeric = callPackage ../applications/office/gnumeric { };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gnunet_svn = lowPrio (callPackage ../applications/networking/p2p/gnunet/svn.nix { });

  gocr = callPackage ../applications/graphics/gocr { };

  gobby5 = callPackage ../applications/editors/gobby {
    inherit (gnome2) gtksourceview;
  };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = callPackage ../applications/misc/gphoto2/gphotofs.nix { };

  gramps = callPackage ../applications/misc/gramps { };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };
  graphicsmagick_q16 = callPackage ../applications/graphics/graphicsmagick { quantumdepth = 16; };

  gtkpod = callPackage ../applications/audio/gtkpod {
    gnome = gnome3;
    inherit (gnome2) libglade;
  };

  jbidwatcher = callPackage ../applications/misc/jbidwatcher {
    java = if stdenv.isLinux then jre else jdk;
  };

  qrencode = callPackage ../tools/graphics/qrencode { };

  geeqie = callPackage ../applications/graphics/geeqie { };

  gigedit = callPackage ../applications/audio/gigedit { };

  gqview = callPackage ../applications/graphics/gqview { };

  gmpc = callPackage ../applications/audio/gmpc {};

  gnome-mpv = callPackage ../applications/video/gnome-mpv { };

  gollum = callPackage ../applications/misc/gollum { };

  google-chrome = callPackage ../applications/networking/browsers/google-chrome { gconf = gnome2.GConf; };

  google-chrome-beta = google-chrome.override { chromium = chromiumBeta; channel = "beta"; };

  google-chrome-dev = google-chrome.override { chromium = chromiumDev; channel = "dev"; };

  googleearth = callPackage_i686 ../applications/misc/googleearth { };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin {
    libpng = libpng12;
  };

  gosmore = callPackage ../applications/misc/gosmore { };

  gpsbabel = qt5.callPackage ../applications/misc/gpsbabel { };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate { };

  gpsd = callPackage ../servers/gpsd { };

  gpsprune = callPackage ../applications/misc/gpsprune { };

  gpxsee = qt5.callPackage ../applications/misc/gpxsee { };

  gtk2fontsel = callPackage ../applications/misc/gtk2fontsel {
    inherit (gnome2) gtk;
  };

  guake = callPackage ../applications/misc/guake {
    gconf = gnome2.GConf;
    vte = gnome2.vte.override { pythonSupport = true; };
  };

  guitone = callPackage ../applications/version-management/guitone {
    graphviz = graphviz_2_32;
  };

  gv = callPackage ../applications/misc/gv { };

  guvcview = callPackage ../os-specific/linux/guvcview {
    pulseaudioSupport = config.pulseaudio or true;
    ffmpeg = ffmpeg_2;
  };

  gxmessage = callPackage ../applications/misc/gxmessage { };

  hackrf = callPackage ../applications/misc/hackrf { };

  hakuneko = callPackage ../tools/misc/hakuneko { };

  hamster-time-tracker = callPackage ../applications/misc/hamster-time-tracker {
    inherit (gnome2) gnome_python;
  };

  hello = callPackage ../applications/misc/hello { };

  kubernetes-helm = callPackage ../applications/networking/cluster/helm { };

  helmholtz = callPackage ../applications/audio/pd-plugins/helmholtz { };

  heme = callPackage ../applications/editors/heme { };

  herbstluftwm = callPackage ../applications/window-managers/herbstluftwm { };

  hexchat = callPackage ../applications/networking/irc/hexchat { };

  hexcurse = callPackage ../applications/editors/hexcurse { };

  hexedit = callPackage ../applications/editors/hexedit { };

  hipchat = callPackage ../applications/networking/instant-messengers/hipchat { };

  homebank = callPackage ../applications/office/homebank {
    gtk = gtk3;
  };

  ht = callPackage ../applications/editors/ht { };

  htmldoc = callPackage ../applications/misc/htmldoc {
    fltk = fltk13;
  };

  hugin = callPackage ../applications/graphics/hugin { };

  hugo = callPackage ../applications/misc/hugo { };

  hydrogen = callPackage ../applications/audio/hydrogen { };

  hyper = callPackage ../applications/misc/hyper { inherit (gnome2) GConf; };
  hyperterm = self.hyper;

  jackline = callPackage ../applications/networking/instant-messengers/jackline {
    ocamlPackages = ocaml-ng.ocamlPackages_4_02;
  };

  slack = callPackage ../applications/networking/instant-messengers/slack { };

  singularity = callPackage ../applications/virtualization/singularity { };

  spectrwm = callPackage ../applications/window-managers/spectrwm { };

  wlc = callPackage ../development/libraries/wlc { };
  orbment = callPackage ../applications/window-managers/orbment { };
  sway = callPackage ../applications/window-managers/sway { };

  swc = callPackage ../development/libraries/swc { };
  wld = callPackage ../development/libraries/wld { };
  velox = callPackage ../applications/window-managers/velox { };

  i3 = callPackage ../applications/window-managers/i3 {
    xcb-util-cursor = if stdenv.isDarwin then xcb-util-cursor-HEAD else xcb-util-cursor;
  };

  i3-gaps = callPackage ../applications/window-managers/i3/gaps.nix { };

  i3blocks = callPackage ../applications/window-managers/i3/blocks.nix { };

  i3blocks-gaps = callPackage ../applications/window-managers/i3/blocks-gaps.nix { };

  i3cat = callPackage ../tools/misc/i3cat { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

  i3lock-color = callPackage ../applications/window-managers/i3/lock-color.nix { };

  i3lock-fancy = callPackage ../applications/window-managers/i3/lock-fancy.nix { };

  i3minator = callPackage ../tools/misc/i3minator { };

  i3pystatus = callPackage ../applications/window-managers/i3/pystatus.nix { };

  i3status = callPackage ../applications/window-managers/i3/status.nix { };

  i810switch = callPackage ../os-specific/linux/i810switch { };

  icewm = callPackage ../applications/window-managers/icewm {};

  id3v2 = callPackage ../applications/audio/id3v2 { };

  ifenslave = callPackage ../os-specific/linux/ifenslave { };

  ii = callPackage ../applications/networking/irc/ii { };

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
  };

  imagemagick = imagemagickBig.override {
    ghostscript = null;
  };

  imagemagickBig = callPackage ../applications/graphics/ImageMagick {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  };

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
  });

  imagemagick7 = lowPrio (imagemagick7Big.override {
    ghostscript = null;
  });

  imagemagick7Big = lowPrio (callPackage ../applications/graphics/ImageMagick/7.0.nix {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
  });

  # Impressive, formerly known as "KeyJNote".
  impressive = callPackage ../applications/office/impressive { };

  inferno = callPackage_i686 ../applications/inferno { };

  inginious = callPackage ../servers/inginious {};

  inkscape = callPackage ../applications/graphics/inkscape {
    lcms = lcms2;
  };

  inspectrum = callPackage ../applications/misc/inspectrum { };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5_1;
  };

  ipe = qt5.callPackage ../applications/graphics/ipe {
    ghostscript = ghostscriptX;
    texlive = texlive.combine { inherit (texlive) scheme-small; };
  };

  iptraf = callPackage ../applications/networking/iptraf { };

  iptraf-ng = callPackage ../applications/networking/iptraf-ng { };

  irssi = callPackage ../applications/networking/irc/irssi { };

  irssi_fish = callPackage ../applications/networking/irc/irssi/fish { };

  irssi_otr = callPackage ../applications/networking/irc/irssi/otr { };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  bip = callPackage ../applications/networking/irc/bip { };

  j4-dmenu-desktop = callPackage ../applications/misc/j4-dmenu-desktop/default.nix { };

  jabref = callPackage ../applications/office/jabref/default.nix { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jack_oscrolloscope = callPackage ../applications/audio/jack-oscrolloscope { };

  jack_rack = callPackage ../applications/audio/jack-rack { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jackmix = callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = jackmix.override { jack = jack1; };

  jalv = callPackage ../applications/audio/jalv { };

  jamin = callPackage ../applications/audio/jamin { };

  japa = callPackage ../applications/audio/japa { };

  jedit = callPackage ../applications/editors/jedit { };

  jigdo = callPackage ../applications/misc/jigdo { };

  jitsi = callPackage ../applications/networking/instant-messengers/jitsi { };

  joe = callPackage ../applications/editors/joe { };

  josm = callPackage ../applications/misc/josm { };

  jbrout = callPackage ../applications/graphics/jbrout { };

  jumanji = callPackage ../applications/networking/browsers/jumanji {
    webkitgtk = webkitgtk24x;
    gtk = gtk3;
  };

  jwm = callPackage ../applications/window-managers/jwm { };

  k3d = callPackage ../applications/graphics/k3d {
    inherit (pkgs.gnome2) gtkglext;
    boost = boost155;
  };

  k9copy = qt5.callPackage ../applications/video/k9copy {};

  kdeconnect = qt5.callPackage ../applications/misc/kdeconnect { };

  kdecoration-viewer = kde5.callPackage ../tools/misc/kdecoration-viewer {};

  kdevelop-pg-qt = kde5.callPackage ../applications/editors/kdevelop5/kdevelop-pg-qt.nix {};

  kdevelop = kde5.callPackage ../applications/editors/kdevelop5/kdevelop.nix {
    llvmPackages = llvmPackages_38;
  };

  kdevplatform = kde5.callPackage ../applications/editors/kdevelop5/kdevplatform.nix {};

  keepnote = callPackage ../applications/office/keepnote { };

  kermit = callPackage ../tools/misc/kermit { };

  keyfinder = qt5.callPackage ../applications/audio/keyfinder { };

  keyfinder-cli = qt5.callPackage ../applications/audio/keyfinder-cli { };

  keymon = callPackage ../applications/video/key-mon { };

  khal = callPackage ../applications/misc/khal { };

  khard = callPackage ../applications/misc/khard { };

  kid3 = callPackage ../applications/audio/kid3 {
    qt = qt4;
  };

  kile = kde5.callPackage ../applications/editors/kile/frameworks.nix { };

  kino = callPackage ../applications/video/kino {
    inherit (gnome2) libglade;
    ffmpeg = ffmpeg_2;
  };

  kiwix = callPackage ../applications/misc/kiwix {
    stdenv = overrideCC stdenv gcc49;
  };

  konversation = qt5.callPackage ../applications/networking/irc/konversation/1.6.nix { };

  krita = qt5.callPackage ../applications/graphics/krita {
    vc = vc_0_7;
    openjpeg = openjpeg_1;
  };

  ksuperkey = callPackage ../tools/X11/ksuperkey { };

  ktorrent = qt5.callPackage ../applications/networking/p2p/ktorrent/5.nix { };

  kubernetes = callPackage ../applications/networking/cluster/kubernetes {
    go = go_1_6;
  };

  lame = callPackage ../development/libraries/lame { };

  larswm = callPackage ../applications/window-managers/larswm { };

  lash = callPackage ../applications/audio/lash { };

  ladspaH = callPackage ../applications/audio/ladspa-sdk/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladspa-sdk = callPackage ../applications/audio/ladspa-sdk { };

  caps = callPackage ../applications/audio/caps { };

  lastwatch = callPackage ../applications/audio/lastwatch { };

  lastfmsubmitd = callPackage ../applications/audio/lastfmsubmitd { };

  lbdb = callPackage ../tools/misc/lbdb { };

  lbzip2 = callPackage ../tools/compression/lbzip2 { };

  lci = callPackage ../applications/science/logic/lci {};

  ldcpp = callPackage ../applications/networking/p2p/ldcpp {
    inherit (gnome2) libglade;
  };

  lemonbar = callPackage ../applications/window-managers/lemonbar { };

  lemonbar-xft = callPackage ../applications/window-managers/lemonbar/xft.nix { };

  leo-editor = callPackage ../applications/editors/leo-editor { };

  libowfat = callPackage ../development/libraries/libowfat { };

  librecad = callPackage ../applications/misc/librecad { };
  librecad2 = librecad;  # backwards compatibility alias, added 2015-10

  libreoffice = hiPrio libreoffice-still;

  libreoffice-fresh = lowPrio (callPackage ../applications/office/libreoffice {
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome2) GConf ORBit2 gnome_vfs;
    inherit (gnome3) gsettings_desktop_schemas defaultIconTheme;
    zip = zip.override { enableNLS = false; };
    bluez5 = bluez5_28;
    fontsConf = makeFontsConf {
      fontDirectories = [
        freefont_ttf xorg.fontmiscmisc
      ];
    };
    clucene_core = clucene_core_2;
    lcms = lcms2;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  });

  libreoffice-still = lowPrio (callPackage ../applications/office/libreoffice/still.nix {
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome2) GConf ORBit2 gnome_vfs;
    inherit (gnome3) gsettings_desktop_schemas defaultIconTheme;
    zip = zip.override { enableNLS = false; };
    #glm = glm_0954;
    bluez5 = bluez5_28;
    fontsConf = makeFontsConf {
      fontDirectories = [
        freefont_ttf xorg.fontmiscmisc
      ];
    };
    clucene_core = clucene_core_2;
    lcms = lcms2;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  });


  liferea = callPackage ../applications/networking/newsreaders/liferea {
    webkitgtk = webkitgtk24x;
  };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome2) libglade;
  };

  linuxband = callPackage ../applications/audio/linuxband { };

  ledger2 = callPackage ../applications/office/ledger/2.6.3.nix { };
  ledger3 = callPackage ../applications/office/ledger { };
  ledger = ledger3;
  ledger-web = callPackage ../applications/office/ledger-web { };

  lighthouse = callPackage ../applications/misc/lighthouse { };

  lighttable = callPackage ../applications/editors/lighttable {};

  links2 = callPackage ../applications/networking/browsers/links2 { };

  linphone = callPackage ../applications/networking/instant-messengers/linphone rec {
    polarssl = mbedtls_1_3;
  };

  linuxsampler = callPackage ../applications/audio/linuxsampler {
    bison = bison2;
  };

  llpp = ocaml-ng.ocamlPackages_4_04.callPackage ../applications/misc/llpp { };

  lmms = callPackage ../applications/audio/lmms { };

  loxodo = callPackage ../applications/misc/loxodo { };

  lrzsz = callPackage ../tools/misc/lrzsz { };

  luakit = callPackage ../applications/networking/browsers/luakit {
      inherit (lua51Packages) luafilesystem luasqlite3;
      lua5 = lua5_1;
      gtk = gtk3;
      webkit = webkitgtk2;
  };

  luminanceHDR = qt55.callPackage ../applications/graphics/luminance-hdr { };

  lxdvdrip = callPackage ../applications/video/lxdvdrip { };

  handbrake = callPackage ../applications/video/handbrake {
    ffmpeg = ffmpeg_2;
  };

  lilyterm = callPackage ../applications/misc/lilyterm {
    inherit (gnome2) vte;
    gtk = gtk2;
  };

  lumail = callPackage ../applications/networking/mailreaders/lumail { };

  lv2bm = callPackage ../applications/audio/lv2bm { };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = qt5.callPackage ../applications/misc/lyx { };

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

  marathon = callPackage ../applications/networking/cluster/marathon { };

  marp = callPackage ../applications/office/marp { };

  matchbox = callPackage ../applications/window-managers/matchbox { };

  mcpp = callPackage ../development/compilers/mcpp { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  mediainfo = callPackage ../applications/misc/mediainfo { };

  mediainfo-gui = callPackage ../applications/misc/mediainfo-gui { };

  mediathekview = callPackage ../applications/video/mediathekview { };

  meld = callPackage ../applications/version-management/meld { };

  mcomix = callPackage ../applications/graphics/mcomix { };

  mendeley = callPackage ../applications/office/mendeley { };

  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (darwin.apple_sdk.frameworks) ApplicationServices;
    inherit (darwin) cf-private;
    guiSupport = false; # use mercurialFull to get hgk GUI
  };

  mercurialFull = appendToName "full" (pkgs.mercurial.override { guiSupport = true; });

  merkaartor = callPackage ../applications/misc/merkaartor { };

  meshlab = callPackage ../applications/graphics/meshlab { };

  metersLv2 = callPackage ../applications/audio/meters_lv2 { };

  mhwaveedit = callPackage ../applications/audio/mhwaveedit {};

  mid2key = callPackage ../applications/audio/mid2key { };

  midori-unwrapped = callPackage ../applications/networking/browsers/midori { };
  midori = wrapFirefox midori-unwrapped { };

  mikmod = callPackage ../applications/audio/mikmod { };

  minicom = callPackage ../tools/misc/minicom { };

  minimodem = callPackage ../applications/audio/minimodem { };

  minidjvu = callPackage ../applications/graphics/minidjvu { };

  minikube = callPackage ../applications/networking/cluster/minikube { };

  minitube = callPackage ../applications/video/minitube { };

  mimms = callPackage ../applications/audio/mimms {};

  mirage = callPackage ../applications/graphics/mirage { };

  mixxx = callPackage ../applications/audio/mixxx {
    inherit (vamp) vampSDK;
  };

  mjpg-streamer = callPackage ../applications/video/mjpg-streamer { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey {
    ocaml = ocamlPackages_4_01_0.ocaml;
  };

  MMA = callPackage ../applications/audio/MMA { };

  mmex = callPackage ../applications/office/mmex {
    wxGTK30 = wxGTK30.override { withWebKit  = true ; };
  };

  moc = callPackage ../applications/audio/moc {
    ffmpeg = ffmpeg_2;
  };

  mod-distortion = callPackage ../applications/audio/mod-distortion { };

  monero = callPackage ../applications/misc/monero { };

  monkeysAudio = callPackage ../applications/audio/monkeys-audio { };

  monkeysphere = callPackage ../tools/security/monkeysphere { };

  monodevelop = callPackage ../applications/editors/monodevelop {};

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
  };

  inherit (ocaml-ng.ocamlPackages_4_01_0) monotoneViz;

  moonlight-embedded = callPackage ../applications/misc/moonlight-embedded { };

  mop = callPackage ../applications/misc/mop { };

  mopidy = callPackage ../applications/audio/mopidy { };

  mopidy-gmusic = callPackage ../applications/audio/mopidy-gmusic { };

  mopidy-spotify = callPackage ../applications/audio/mopidy-spotify { };

  mopidy-moped = callPackage ../applications/audio/mopidy-moped { };

  mopidy-mopify = callPackage ../applications/audio/mopidy-mopify { };

  mopidy-spotify-tunigo = callPackage ../applications/audio/mopidy-spotify-tunigo { };

  mopidy-youtube = callPackage ../applications/audio/mopidy-youtube { };

  mopidy-soundcloud = callPackage ../applications/audio/mopidy-soundcloud { };

  mopidy-musicbox-webclient = callPackage ../applications/audio/mopidy-musicbox-webclient { };

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

  mpc_cli = callPackage ../applications/audio/mpc { };

  clerk = callPackage ../applications/audio/clerk { };

  ncmpc = callPackage ../applications/audio/ncmpc { };

  ncmpcpp = callPackage ../applications/audio/ncmpcpp { };

  ympd = callPackage ../applications/audio/ympd { };

  nload = callPackage ../applications/networking/nload { };

  normalize = callPackage ../applications/audio/normalize { };

  mm = callPackage ../applications/networking/instant-messengers/mm { };

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
    lua = lua5_1;
    lua5_sockets = lua5_1_sockets;
    youtube-dl = pythonPackages.youtube-dl;
    bs2bSupport = config.mpv.bs2bSupport or true;
    youtubeSupport = config.mpv.youtubeSupport or true;
    cacaSupport = config.mpv.cacaSupport or true;
    vaapiSupport = config.mpv.vaapiSupport or false;
    libva = libva-full;
  };

  mpvScripts = {
    convert = callPackage ../applications/video/mpv/scripts/convert.nix {};
  };

  mrpeach = callPackage ../applications/audio/pd-plugins/mrpeach { };

  mrxvt = callPackage ../applications/misc/mrxvt { };

  mtpaint = callPackage ../applications/graphics/mtpaint { };

  multimarkdown = callPackage ../tools/typesetting/multimarkdown { };

  multimon-ng = callPackage ../applications/misc/multimon-ng { };

  multisync = callPackage ../applications/misc/multisync {
    inherit (gnome2) ORBit2 libbonobo libgnomeui GConf;
  };

  inherit (callPackages ../applications/networking/mumble {
      avahi = avahi.override {
        withLibdnssdCompat = true;
      };
      qt5 = qt55; # Mumble doesn't work with newer Qt versions.
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
    }) mumble mumble_git murmur murmur_git;

  mumble_overlay = callPackage ../applications/networking/mumble/overlay.nix {
    mumble_i686 = if system == "x86_64-linux"
      then pkgsi686Linux.mumble
      else null;
  };

  musescore = qt55.callPackage ../applications/audio/musescore { };

  mutt = callPackage ../applications/networking/mailreaders/mutt { };
  mutt-with-sidebar = callPackage ../applications/networking/mailreaders/mutt {
    withSidebar = true;
  };

  neomutt = callPackage ../applications/networking/mailreaders/neomutt { };

  natron = callPackage ../applications/video/natron { };

  notion = callPackage ../applications/window-managers/notion { };

  openshift = callPackage ../applications/networking/cluster/openshift { };

  oroborus = callPackage ../applications/window-managers/oroborus {};

  ostinato = callPackage ../applications/networking/ostinato { };

  panamax_api = callPackage ../applications/networking/cluster/panamax/api {
    ruby = ruby_2_1;
  };
  panamax_ui = callPackage ../applications/networking/cluster/panamax/ui {
    ruby = ruby_2_1;
  };

  pcmanfm = callPackage ../applications/misc/pcmanfm { };

  pcmanfm-qt = lxqt.pcmanfm-qt;

  pcmanx-gtk2 = callPackage ../applications/misc/pcmanx-gtk2 { };

  pig = callPackage ../applications/networking/cluster/pig { };

  pijul = callPackage ../applications/version-management/pijul { };

  planner = callPackage ../applications/office/planner { };

  playonlinux = callPackage ../applications/misc/playonlinux {
     stdenv = stdenv_32bit;
  };

  polybar = callPackage ../applications/misc/polybar { };

  scudcloud = callPackage ../applications/networking/instant-messengers/scudcloud { };

  shotcut = qt5.callPackage ../applications/video/shotcut { };

  smplayer = qt5.callPackage ../applications/video/smplayer { };

  smtube = qt55.callPackage ../applications/video/smtube {};

  sudolikeaboss = callPackage ../tools/security/sudolikeaboss { };

  sup = callPackage ../applications/networking/mailreaders/sup {
    ruby = ruby_2_3.override { cursesSupport = true; };
  };

  synapse = callPackage ../applications/misc/synapse {
    inherit (gnome3) libgee;
  };

  synfigstudio = callPackage ../applications/graphics/synfigstudio {
    fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
    inherit (gnome3) defaultIconTheme;
  };

  librep = callPackage ../development/libraries/librep { };

  rep-gtk = callPackage ../development/libraries/rep-gtk { };

  sawfish = callPackage ../applications/window-managers/sawfish { };

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

  maxlib = callPackage ../applications/audio/pd-plugins/maxlib { };

  pdfdiff = callPackage ../applications/misc/pdfdiff { };

  mupdf = callPackage ../applications/misc/mupdf { };

  diffpdf = callPackage ../applications/misc/diffpdf { };

  mlocate = callPackage ../tools/misc/mlocate { };

  mypaint = callPackage ../applications/graphics/mypaint { };

  mythtv = callPackage ../applications/video/mythtv { };

  nano = callPackage ../applications/editors/nano { };

  nanoblogger = callPackage ../applications/misc/nanoblogger { };

  navipowm = callPackage ../applications/misc/navipowm { };

  navit = callPackage ../applications/misc/navit { };

  netbeans = callPackage ../applications/editors/netbeans { };

  ncdu = callPackage ../tools/misc/ncdu { };

  ncdc = callPackage ../applications/networking/p2p/ncdc { };

  ne = callPackage ../applications/editors/ne { };

  nedit = callPackage ../applications/editors/nedit { };

  notepadqq = callPackage ../applications/editors/notepadqq {
    qtbase = qt55;
  };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch { };

  notmuch-mutt = callPackage ../applications/networking/mailreaders/notmuch/mutt.nix { };

  muchsync = callPackage ../applications/networking/mailreaders/notmuch/muchsync.nix { };

  notmuch-addrlookup = callPackage ../applications/networking/mailreaders/notmuch-addrlookup { };

  # Open Stack
  nova = callPackage ../applications/virtualization/openstack/nova.nix { };
  keystone = callPackage ../applications/virtualization/openstack/keystone.nix { };
  neutron = callPackage ../applications/virtualization/openstack/neutron.nix { };
  glance = callPackage ../applications/virtualization/openstack/glance.nix { };

  nova-filters =  callPackage ../applications/audio/nova-filters { };

  nspluginwrapper = callPackage ../applications/networking/browsers/mozilla-plugins/nspluginwrapper {};

  nvi = callPackage ../applications/editors/nvi { };

  nvpy = callPackage ../applications/editors/nvpy { };

  obconf = callPackage ../tools/X11/obconf {
    inherit (gnome2) libglade;
  };

  oblogout = callPackage ../tools/X11/oblogout { };

  obs-studio = qt5.callPackage ../applications/video/obs-studio {
    alsaSupport = stdenv.isLinux;
    pulseaudioSupport = config.pulseaudio or true;
  };

  octoprint = callPackage ../applications/misc/octoprint { };

  octoprint-plugins = callPackage ../applications/misc/octoprint/plugins.nix { };

  ocrad = callPackage ../applications/graphics/ocrad { };

  offrss = callPackage ../applications/networking/offrss { };

  ogmtools = callPackage ../applications/video/ogmtools { };

  omxplayer = callPackage ../applications/video/omxplayer { };

  oneteam = callPackage ../applications/networking/instant-messengers/oneteam { };

  openbox = callPackage ../applications/window-managers/openbox { };

  openbox-menu = callPackage ../applications/misc/openbox-menu { };

  openbrf = callPackage ../applications/misc/openbrf { };

  opencpn = callPackage ../applications/misc/opencpn { };

  openimageio = callPackage ../applications/graphics/openimageio { };

  openjump = callPackage ../applications/misc/openjump { };

  openscad = callPackage ../applications/graphics/openscad {};

  opera = callPackage ../applications/networking/browsers/opera {};

  osmctools = callPackage ../applications/misc/osmctools { };

  vivaldi = callPackage ../applications/networking/browsers/vivaldi {};

  openmpt123 = callPackage ../applications/audio/openmpt123 {};

  opusfile = callPackage ../applications/audio/opusfile { };

  opusTools = callPackage ../applications/audio/opus-tools { };

  orpie = callPackage ../applications/misc/orpie { gsl = gsl_1; };

  osmo = callPackage ../applications/office/osmo { };

  palemoon = callPackage ../applications/networking/browsers/palemoon { };

  pamix = callPackage ../applications/audio/pamix { };

  pamixer = callPackage ../applications/audio/pamixer { };

  pan = callPackage ../applications/networking/newsreaders/pan {
    spellChecking = false;
  };

  panotools = callPackage ../applications/graphics/panotools { };

  paprefs = callPackage ../applications/audio/paprefs {
    inherit (gnome2) libglademm gconfmm GConf;
  };

  pavucontrol = callPackage ../applications/audio/pavucontrol { };

  paraview = callPackage ../applications/graphics/paraview { };

  packet = callPackage ../development/tools/packet { };

  pbrt = callPackage ../applications/graphics/pbrt { };

  pcsxr = callPackage ../misc/emulators/pcsxr {
    ffmpeg = ffmpeg_2;
  };

  pcsx2 = callPackage_i686 ../misc/emulators/pcsx2 { };

  pekwm = callPackage ../applications/window-managers/pekwm { };

  pencil = callPackage ../applications/graphics/pencil {
  };

  perseus = callPackage ../applications/science/math/perseus {};

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome2) libgnomecanvas;
  };

  pdftk = callPackage ../tools/typesetting/pdftk { };
  pdfgrep  = callPackage ../tools/typesetting/pdfgrep { };

  pdfpc = callPackage ../applications/misc/pdfpc {
    inherit (gnome3) libgee;
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  pflask = callPackage ../os-specific/linux/pflask {};

  photoqt = qt5.callPackage ../applications/graphics/photoqt { };

  phototonic = qt5.callPackage ../applications/graphics/phototonic { };

  phrasendrescher = callPackage ../tools/security/phrasendrescher { };

  phwmon = callPackage ../applications/misc/phwmon { };

  pianobar = callPackage ../applications/audio/pianobar { };

  pianobooster = callPackage ../applications/audio/pianobooster { };

  picard = callPackage ../applications/audio/picard { };

  picocom = callPackage ../tools/misc/picocom { };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    openssl = if config.pidgin.openssl or true then openssl else null;
    gnutls = if config.pidgin.gnutls or false then gnutls else null;
    libgcrypt = if config.pidgin.gnutls or false then libgcrypt else null;
    startupnotification = libstartup_notification;
    plugins = [];
  };

  pidginlatex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    texLive = texlive.combined.scheme-basic;
  };

  pidginmsnpecan = callPackage ../applications/networking/instant-messengers/pidgin-plugins/msn-pecan { };

  pidgin-mra = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-mra { };

  pidgin-skypeweb = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-skypeweb { };

  pidgin-xmpp-receipts = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-xmpp-receipts { };

  pidginotr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidginosd = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-osd { };

  pidginsipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  pidginwindowmerge = callPackage ../applications/networking/instant-messengers/pidgin-plugins/window-merge { };

  purple-hangouts = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-hangouts { };

  purple-matrix = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-matrix { };

  purple-plugin-pack = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-plugin-pack { };

  purple-vk-plugin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-vk-plugin { };

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

  pinpoint = callPackage ../applications/office/pinpoint {
    inherit (gnome3) clutter clutter_gtk;
  };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtk-sharp-2_0;
  };

  plover = callPackage ../applications/misc/plover { };

  plugin-torture = callPackage ../applications/audio/plugin-torture { };

  pmenu = callPackage ../applications/misc/pmenu { };

  poezio = python3Packages.poezio;

  pommed = callPackage ../os-specific/linux/pommed {};

  pommed_light = callPackage ../os-specific/linux/pommed-light {};

  pond = callPackage ../applications/networking/instant-messengers/pond { };

  ponymix = callPackage ../applications/audio/ponymix { };

  potrace = callPackage ../applications/graphics/potrace {};

  posterazor = callPackage ../applications/misc/posterazor { };

  ppl-address-book = callPackage ../applications/office/ppl-address-book { };

  pqiv = callPackage ../applications/graphics/pqiv { };

  qiv = callPackage ../applications/graphics/qiv { };

  processing = callPackage ../applications/graphics/processing {
    jdk = jdk7;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = callPackage ../applications/misc/procmail { };

  profanity = callPackage ../applications/networking/instant-messengers/profanity {
    notifySupport   = config.profanity.notifySupport   or true;
    autoAwaySupport = config.profanity.autoAwaySupport or true;
  };

  psol = callPackage ../development/libraries/psol/default.nix { };

  pstree = callPackage ../applications/misc/pstree { };

  pulseview = callPackage ../applications/science/electronics/pulseview { };

  puredata = callPackage ../applications/audio/puredata { };
  puredata-with-plugins = plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  puremapping = callPackage ../applications/audio/pd-plugins/puremapping { };

  pybitmessage = callPackage ../applications/networking/instant-messengers/pybitmessage { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qbittorrent = qt5.callPackage ../applications/networking/p2p/qbittorrent {
    boost = boost;
    libtorrentRasterbar = libtorrentRasterbar_1_0;
  };

  eiskaltdcpp = callPackage ../applications/networking/p2p/eiskaltdcpp { lua5 = lua5_1; };

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa;
    inherit (darwin.stubs) rez setfile;
  };

  qgis = callPackage ../applications/gis/qgis {};

  qgroundcontrol = qt55.callPackage ../applications/science/robotics/qgroundcontrol { };

  qjackctl = qt5.callPackage ../applications/audio/qjackctl { };

  qmidinet = callPackage ../applications/audio/qmidinet { };

  qmidiroute = callPackage ../applications/audio/qmidiroute { };

  qmmp = qt5.callPackage ../applications/audio/qmmp { };

  qnotero = callPackage ../applications/office/qnotero { };

  qrcode = callPackage ../tools/graphics/qrcode {};

  qsampler = callPackage ../applications/audio/qsampler { };

  qscreenshot = callPackage ../applications/graphics/qscreenshot {
    qt = qt4;
  };

  qsyncthingtray = qt5.callPackage ../applications/misc/qsyncthingtray { };

  qsynth = callPackage ../applications/audio/qsynth { };

  qtbitcointrader = callPackage ../applications/misc/qtbitcointrader { };

  qtox = qt5.callPackage ../applications/networking/instant-messengers/qtox { };

  qtpass = qt5.callPackage ../applications/misc/qtpass { };

  qtpfsgui = callPackage ../applications/graphics/qtpfsgui { };

  qtractor = callPackage ../applications/audio/qtractor { };

  qtscrobbler = callPackage ../applications/audio/qtscrobbler { };

  quassel = qt5.callPackage ../applications/networking/irc/quassel/qt-5.nix {
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

  quassel-webserver = callPackage ../applications/networking/irc/quassel-webserver { };

  quirc = callPackage ../tools/graphics/quirc {};

  quiterss = qt5.callPackage ../applications/networking/newsreaders/quiterss {};

  quodlibet-without-gst-plugins = callPackage ../applications/audio/quodlibet { };

  quodlibet = callPackage ../applications/audio/quodlibet {
    withGstPlugins = true;
    gst_plugins_bad = null;
  };

  qutebrowser = qt5.callPackage ../applications/networking/browsers/qutebrowser {
    inherit (python3Packages) buildPythonApplication pyqt5 jinja2 pygments pyyaml pypeg2 cssutils;
    inherit (gst_all_1) gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav;
  };

  rabbitvcs = callPackage ../applications/version-management/rabbitvcs {};

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  inherit (callPackage ../applications/virtualization/rancher-compose {})
    rancher-compose
    rancher-compose_0_10;

  renoise = callPackage ../applications/audio/renoise {
    demo = false;
  };

  rapcad = qt55.callPackage ../applications/graphics/rapcad { boost = boost159; };

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratmen = callPackage ../tools/X11/ratmen {};

  ratox = callPackage ../applications/networking/instant-messengers/ratox {
    libtoxcore = libtoxcore-old;
  };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
    cmake = cmake_2_8; # problems after 3.4 -> 3.6.0
  };

  rawtherapee-git = lowPrio (callPackage ../applications/graphics/rawtherapee/dev.nix {
    fftw = fftwSinglePrec;
    cmake = cmake_2_8; # problems after 3.4 -> 3.6.0
  });

  rclone = callPackage ../applications/networking/sync/rclone { };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  rdup = callPackage ../tools/backup/rdup { };

  realpine = callPackage ../applications/networking/mailreaders/realpine {
    tcl = tcl-8_5;
  };

  recode = callPackage ../tools/text/recode { };

  remotebox = callPackage ../applications/virtualization/remotebox { };

  retroshare = callPackage ../applications/networking/p2p/retroshare { };

  retroshare06 = lowPrio (callPackage ../applications/networking/p2p/retroshare/0.6.nix { });

  ricochet = qt55.callPackage ../applications/networking/instant-messengers/ricochet { };

  ripser = callPackage ../applications/science/math/ripser { };

  rkt = callPackage ../applications/virtualization/rkt { };

  rofi = callPackage ../applications/misc/rofi { };

  rofi-pass = callPackage ../tools/security/pass/rofi-pass.nix { };

  rofi-menugen = callPackage ../applications/misc/rofi-menugen { };

  rstudio = callPackage ../applications/editors/rstudio { };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS || stdenv.isFreeBSD);
    enableCopyDevicesPatch = (config.rsync.enableCopyDevicesPatch or false);
  };
  rrsync = callPackage ../applications/networking/sync/rsync/rrsync.nix {};

  rtl-sdr = callPackage ../applications/misc/rtl-sdr { };

  rtv = callPackage ../applications/misc/rtv { };

  rubyripper = callPackage ../applications/audio/rubyripper {};

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
      urxvt_perl
      urxvt_perls
      urxvt_tabbedex
      urxvt_font_size
      urxvt_theme_switch
      urxvt_vtwheel
    ];
  };

  # urxvt plugins
  urxvt_perl = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perl { };
  urxvt_perls = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perls { };
  urxvt_tabbedex = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-tabbedex { };
  urxvt_font_size = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-font-size { };
  urxvt_theme_switch = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-theme-switch { };
  urxvt_vtwheel = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-vtwheel.nix { };

  uade123 = callPackage ../applications/audio/uade123 {};

  udevil = callPackage ../applications/misc/udevil {};

  udiskie = callPackage ../applications/misc/udiskie { };

  sakura = callPackage ../applications/misc/sakura {
    vte = gnome3.vte;
  };

  sbagen = callPackage ../applications/misc/sbagen { };

  scantailor = callPackage ../applications/graphics/scantailor {
    boost = boost155;
  };

  sc-im = callPackage ../applications/misc/sc-im { };

  scite = callPackage ../applications/editors/scite { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome2) libart_lgpl;
  };

  seafile-client = callPackage ../applications/networking/seafile-client { };

  seeks = callPackage ../tools/networking/p2p/seeks {
    protobuf = protobuf2_5;
  };

  seg3d = callPackage ../applications/graphics/seg3d {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  sent = callPackage ../applications/misc/sent { };

  seq24 = callPackage ../applications/audio/seq24 { };

  setbfree = callPackage ../applications/audio/setbfree { };

  shfmt = callPackage ../tools/text/shfmt { };

  shutter = callPackage ../applications/graphics/shutter { };

  simple-scan = callPackage ../applications/graphics/simple-scan { };

  siproxd = callPackage ../applications/networking/siproxd { };

  skype = callPackage_i686 ../applications/networking/instant-messengers/skype { };

  skype4pidgin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/skype4pidgin { };

  skype_call_recorder = callPackage ../applications/networking/instant-messengers/skype-call-recorder { };

  slmenu = callPackage ../applications/misc/slmenu {};

  slop = callPackage ../tools/misc/slop {};

  slrn = callPackage ../applications/networking/newsreaders/slrn { };

  sniproxy = callPackage ../applications/networking/sniproxy { };

  sooperlooper = callPackage ../applications/audio/sooperlooper { };

  sorcer = callPackage ../applications/audio/sorcer { };

  sound-juicer = callPackage ../applications/audio/sound-juicer { };

  spice-vdagent = callPackage ../applications/virtualization/spice-vdagent { };

  spideroak = callPackage ../applications/networking/spideroak { };

  squishyball = callPackage ../applications/audio/squishyball { };

  ssvnc = callPackage ../applications/networking/remote/ssvnc { };

  styx = callPackage ../applications/misc/styx { };

  styx-themes = callPackage ../applications/misc/styx/themes.nix { };

  tecoc = callPackage ../applications/editors/tecoc { };

  viber = callPackage ../applications/networking/instant-messengers/viber { };

  sonic-pi = callPackage ../applications/audio/sonic-pi {
    ruby = ruby_2_2;
  };

  st = callPackage ../applications/misc/st {
    conf = config.st.conf or null;
    patches = config.st.patches or null;
  };

  st-wayland = callPackage ../applications/misc/st/wayland.nix {
    conf = config.st.conf or null;
    patches = config.st.patches or null;
  };

  stag = callPackage ../applications/misc/stag {
    curses = ncurses;
  };

  stella = callPackage ../misc/emulators/stella { };

  statsd = callPackage ../tools/networking/statsd {
    nodejs = nodejs-4_x;
  };

  linuxstopmotion = callPackage ../applications/video/linuxstopmotion { };

  sweethome3d = recurseIntoAttrs (  (callPackage ../applications/misc/sweethome3d { })
                                 // (callPackage ../applications/misc/sweethome3d/editors.nix {
                                      sweethome3dApp = sweethome3d.application;
                                    })
                                 );

  swingsane = callPackage ../applications/graphics/swingsane { };

  sxiv = callPackage ../applications/graphics/sxiv { };

  bittorrentSync = bittorrentSync14;
  bittorrentSync14 = callPackage ../applications/networking/bittorrentsync/1.4.x.nix { };
  bittorrentSync20 = callPackage ../applications/networking/bittorrentsync/2.0.x.nix { };

  dropbox = qt5.callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox-cli { };

  insync = callPackage ../applications/networking/insync { };

  lightdm = qt5.callPackage ../applications/display-managers/lightdm {
    qt4 = null;
    withQt5 = false;
  };

  lightdm_qt = lightdm.override { withQt5 = true; };

  lightdm_gtk_greeter = callPackage ../applications/display-managers/lightdm-gtk-greeter { };

  slic3r = callPackage ../applications/misc/slic3r { };

  curaengine = callPackage ../applications/misc/curaengine { };

  cura = callPackage ../applications/misc/cura { };

  curaLulzbot = callPackage ../applications/misc/cura/lulzbot.nix { };

  peru = callPackage ../applications/version-management/peru {};

  printrun = callPackage ../applications/misc/printrun { };

  sddm = qt5.callPackage ../applications/display-managers/sddm {
    themes = [];  # extra themes, etc.
  };

  skrooge2 = qt5.callPackage ../applications/office/skrooge/2.nix {};

  slim = callPackage ../applications/display-managers/slim {
    libpng = libpng12;
  };

  smartgithg = callPackage ../applications/version-management/smartgithg { };

  slimThemes = recurseIntoAttrs (callPackage ../applications/display-managers/slim/themes.nix {});

  smartdeblur = callPackage ../applications/graphics/smartdeblur { };

  snapper = callPackage ../tools/misc/snapper {
    btrfs-progs = btrfs-progs_4_4_1;
  };

  snd = callPackage ../applications/audio/snd { };

  shntool = callPackage ../applications/audio/shntool { };

  sipp = callPackage ../development/tools/misc/sipp { };

  sonic-visualiser = qt5.callPackage ../applications/audio/sonic-visualiser {
    inherit (pkgs.vamp) vampSDK;
  };

  sox = callPackage ../applications/misc/audio/sox {
    enableLame = config.sox.enableLame or false;
  };

  soxr = callPackage ../applications/misc/audio/soxr { };

  spek = callPackage ../applications/audio/spek {
    ffmpeg = ffmpeg_2;
  };

  spotify = callPackage ../applications/audio/spotify {
    inherit (gnome2) GConf;
    libgcrypt = libgcrypt_1_5;
    libpng = libpng12;
  };

  libspotify = callPackage ../development/libraries/libspotify {
    apiKey = config.libspotify.apiKey or null;
  };

  squeezelite = callPackage ../applications/audio/squeezelite { };

  ltunify = callPackage ../tools/misc/ltunify { };

  src = callPackage ../applications/version-management/src/default.nix {
    git = gitMinimal;
  };

  ssr = callPackage ../applications/audio/soundscape-renderer {};

  ssrc = callPackage ../applications/audio/ssrc { };

  stalonetray = callPackage ../applications/window-managers/stalonetray {};

  stp = callPackage ../applications/science/logic/stp {};

  stumpwm = callPackage ../applications/window-managers/stumpwm {
    version = "latest";
  };

  stumpwm-git = stumpwm.override {
    version = "git";
  };

  sublime = callPackage ../applications/editors/sublime { };

  sublime3 = lowPrio (callPackage ../applications/editors/sublime3 { });

  inherit (callPackages ../applications/version-management/subversion/default.nix {
      bdbSupport = true;
      httpServer = false;
      httpSupport = true;
      pythonBindings = false;
      perlBindings = false;
      javahlBindings = false;
      saslSupport = false;
      sasl = cyrus_sasl;
    })
    subversion18 subversion19;

  subversion = pkgs.subversion19;

  subversionClient = appendToName "client" (pkgs.subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  });

  subunit = callPackage ../development/libraries/subunit { };

  surf = callPackage ../applications/networking/browsers/surf {
    webkit = webkitgtk2;
  };

  swh_lv2 = callPackage ../applications/audio/swh-lv2 { };

  sylpheed = callPackage ../applications/networking/mailreaders/sylpheed { };

  symlinks = callPackage ../tools/system/symlinks { };

  syncthing = callPackage ../applications/networking/syncthing { };

  syncthing012 = callPackage ../applications/networking/syncthing012 { };

  syncthing013 = callPackage ../applications/networking/syncthing013 { };

  syncthing-inotify = callPackage ../applications/networking/syncthing/inotify.nix { };

  # linux only by now
  synergy = callPackage ../applications/misc/synergy { };

  tabbed = callPackage ../applications/window-managers/tabbed {
    # if you prefer a custom config, write the config.h in tabbed.config.h
    # and enable
    # customConfig = builtins.readFile ./tabbed.config.h;
  };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages;
  };

  tagainijisho = callPackage ../applications/office/tagainijisho {};

  tahoelafs = callPackage ../tools/networking/p2p/tahoe-lafs {};

  tailor = callPackage ../applications/version-management/tailor {};

  tangogps = callPackage ../applications/misc/tangogps {
    gconf = gnome2.GConf;
  };

  teamspeak_client = qt55.callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };
  teamspeak_server = callPackage ../applications/networking/instant-messengers/teamspeak/server.nix { };

  taskjuggler-2 = callPackage ../applications/misc/taskjuggler/2.x { };

  taskjuggler = callPackage ../applications/misc/taskjuggler/3.x {
    ruby = ruby_2_0;
  };

  tasknc = callPackage ../applications/misc/tasknc { };

  taskwarrior = callPackage ../applications/misc/taskwarrior { };

  tasksh = callPackage ../applications/misc/tasksh { };

  taskserver = callPackage ../servers/misc/taskserver { };

  tdesktop = qt56.callPackage ../applications/networking/instant-messengers/telegram/tdesktop {
    inherit (pythonPackages) gyp;
  };

  telegram-cli = callPackage ../applications/networking/instant-messengers/telegram/telegram-cli { };

  telepathy_gabble = callPackage ../applications/networking/instant-messengers/telepathy/gabble { };

  telepathy_haze = callPackage ../applications/networking/instant-messengers/telepathy/haze {};

  telepathy_logger = callPackage ../applications/networking/instant-messengers/telepathy/logger {};

  telepathy_mission_control = callPackage ../applications/networking/instant-messengers/telepathy/mission-control { };

  telepathy_rakia = callPackage ../applications/networking/instant-messengers/telepathy/rakia { };

  telepathy_salut = callPackage ../applications/networking/instant-messengers/telepathy/salut {};

  telepathy_idle = callPackage ../applications/networking/instant-messengers/telepathy/idle {};

  terminal-notifier = callPackage ../applications/misc/terminal-notifier {};

  terminator = callPackage ../applications/misc/terminator {
    vte = gnome2.vte.override { pythonSupport = true; };
  };

  termite = callPackage ../applications/misc/termite {
    vte = gnome3.vte-ng;
  };

  tesseract = callPackage ../applications/graphics/tesseract { };

  tetraproc = callPackage ../applications/audio/tetraproc { };

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  thunderbird = callPackage ../applications/networking/mailreaders/thunderbird {
    inherit (gnome2) libIDL;
    libpng = libpng_apng;
  };

  thunderbird-bin = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    gconf = pkgs.gnome2.GConf;
    inherit (pkgs.gnome2) libgnome libgnomeui;
  };

  tig = gitAndTools.tig;

  tilda = callPackage ../applications/misc/tilda {
    vte = gnome3.vte;
    gtk = gtk3;
  };

  timbreid = callPackage ../applications/audio/pd-plugins/timbreid { };

  timewarrior = callPackage ../applications/misc/timewarrior { };

  timidity = callPackage ../tools/misc/timidity { };

  tint2 = callPackage ../applications/misc/tint2 { };

  tkcvs = callPackage ../applications/version-management/tkcvs { };

  tla = callPackage ../applications/version-management/arch { };

  tlp = callPackage ../tools/misc/tlp {
    inherit (linuxPackages) x86_energy_perf_policy;
  };

  tnef = callPackage ../applications/misc/tnef { };

  todo-txt-cli = callPackage ../applications/office/todo.txt-cli { };

  tomahawk = callPackage ../applications/audio/tomahawk {
    inherit (pkgs.kde4) kdelibs;
    taglib = taglib_1_9;
    enableXMPP      = config.tomahawk.enableXMPP      or true;
    enableKDE       = config.tomahawk.enableKDE       or false;
    enableTelepathy = config.tomahawk.enableTelepathy or false;
    quazip = quazip_qt4;
  };

  torchPackages = recurseIntoAttrs ( callPackage ../applications/science/machine-learning/torch {
    lua = luajit ;
  } );

  torch-repl = lib.setName "torch-repl" torchPackages.trepl;

  torchat = callPackage ../applications/networking/instant-messengers/torchat {
    inherit (pythonPackages) wrapPython wxPython;
  };

  tortoisehg = callPackage ../applications/version-management/tortoisehg { };

  toxic = callPackage ../applications/networking/instant-messengers/toxic { };

  transcode = callPackage ../applications/audio/transcode { };

  transcribe = callPackage ../applications/audio/transcribe { };

  transmission = callPackage ../applications/networking/p2p/transmission { };
  transmission_gtk = transmission.override { enableGTK3 = true; };

  transmission-remote-cli = callPackage ../applications/networking/p2p/transmission-remote-cli {};
  transmission_remote_gtk = callPackage ../applications/networking/p2p/transmission-remote-gtk {};

  transgui = callPackage ../applications/networking/p2p/transgui { };

  trayer = callPackage ../applications/window-managers/trayer { };

  tree = callPackage ../tools/system/tree {};

  trezor-bridge = callPackage ../applications/networking/browsers/mozilla-plugins/trezor { };

  tribler = callPackage ../applications/networking/p2p/tribler { };

  # We need QtWebkit which was deprecated in Qt 5.6 although it can still be build
  trojita = with qt55; callPackage ../applications/networking/mailreaders/trojita { };

  tsearch_extras = callPackage ../servers/sql/postgresql/tsearch_extras { };

  tudu = callPackage ../applications/office/tudu { };

  tuxguitar = callPackage ../applications/editors/music/tuxguitar { };

  twister = callPackage ../applications/networking/p2p/twister {
    boost = boost160;
  };

  twmn = qt5.callPackage ../applications/misc/twmn { };

  umurmur = callPackage ../applications/networking/umurmur { };

  unigine-valley = callPackage ../applications/graphics/unigine-valley { };

  inherit (ocamlPackages) unison;

  unpaper = callPackage ../tools/graphics/unpaper { };

  urh = callPackage ../applications/misc/urh { };

  uucp = callPackage ../tools/misc/uucp { };

  uvccapture = callPackage ../applications/video/uvccapture { };

  uwimap = callPackage ../tools/networking/uwimap { };

  uzbl = callPackage ../applications/networking/browsers/uzbl {
    webkit = webkitgtk2;
  };

  utox = callPackage ../applications/networking/instant-messengers/utox { };

  vanitygen = callPackage ../applications/misc/vanitygen { };

  vanubi = callPackage ../applications/editors/vanubi { };

  vbindiff = callPackage ../applications/editors/vbindiff { };

  vcprompt = callPackage ../applications/version-management/vcprompt { };

  vdirsyncer = callPackage ../tools/misc/vdirsyncer { };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  vim = callPackage ../applications/editors/vim {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  vimiv = callPackage ../applications/graphics/vimiv {
    inherit (gnome3) defaultIconTheme;
  };

  macvim = callPackage ../applications/editors/vim/macvim.nix { stdenv = clangStdenv; ruby = ruby_2_2; };

  vimHugeX = vim_configurable;

  vim_configurable = vimUtils.makeCustomizable (callPackage ../applications/editors/vim/configurable.nix {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc cf-private;

    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5_1;
    gui = config.vim.gui or "auto";

    # optional features by flags
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  vimNox = lowPrio (vim_configurable.override { source = "vim-nox"; });

  qpdfview = callPackage ../applications/misc/qpdfview {};

  qtile = callPackage ../applications/window-managers/qtile {
    inherit (xorg) libxcb;
  };

  qvim = lowPrio (callPackage ../applications/editors/vim/qvim.nix {
    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  vimpc = callPackage ../applications/audio/vimpc { };

  neovim = callPackage ../applications/editors/neovim { };

  neovim-qt = qt5.callPackage ../applications/editors/neovim/qt.nix { };

  neovim-pygui = pythonPackages.neovim_gui;

  neovim-remote = callPackage ../applications/editors/neovim/neovim-remote.nix { pythonPackages = python3Packages; };

  vis = callPackage ../applications/editors/vis {
    inherit (lua52Packages) lpeg;
  };

  virt-viewer = callPackage ../applications/virtualization/virt-viewer {
    spice_gtk = spice_gtk;
  };

  virt-top = callPackage ../applications/virtualization/virt-top {
    ocamlPackages = ocamlPackages_4_01_0;
  };

  virtmanager = callPackage ../applications/virtualization/virt-manager {
    vte = gnome3.vte;
    dconf = gnome3.dconf;
    spice_gtk = spice_gtk;
    system-libvirt = libvirt;
  };

  virtinst = callPackage ../applications/virtualization/virtinst {};

  virtualbox = callPackage ../applications/virtualization/virtualbox {
    stdenv = stdenv_32bit;
    inherit (gnome2) libIDL;
    enableExtensionPack = config.virtualbox.enableExtensionPack or false;
    pulseSupport = config.pulseaudio or true;
  };

  virtualboxHardened = lowPrio (virtualbox.override {
    enableHardening = true;
  });

  virtualboxHeadless = lowPrio (virtualbox.override {
    enableHardening = true;
    headless = true;
  });

  virtualglLib = callPackage ../tools/X11/virtualgl/lib.nix {
    fltk = fltk13;
  };

  virtualgl = callPackage ../tools/X11/virtualgl {
    virtualglLib_i686 = if system == "x86_64-linux"
      then pkgsi686Linux.virtualglLib
      else null;
  };

  primusLib = callPackage ../tools/X11/primus/lib.nix {
    nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
  };

  primus = callPackage ../tools/X11/primus {
    stdenv_i686 = pkgsi686Linux.stdenv;
    primusLib_i686 = if system == "x86_64-linux"
      then pkgsi686Linux.primusLib
      else null;
  };

  bumblebee = callPackage ../tools/X11/bumblebee {
    nvidia_x11 = linuxPackages.nvidia_x11;
    nvidia_x11_i686 = if system == "x86_64-linux"
      then pkgsi686Linux.linuxPackages.nvidia_x11.override { libsOnly = true; }
      else null;
    primusLib_i686 = if system == "x86_64-linux"
      then pkgsi686Linux.primusLib
      else null;
    libglvnd_i686 = if system == "x86_64-linux"
      then pkgsi686Linux.libglvnd
      else null;
  };

  vkeybd = callPackage ../applications/audio/vkeybd {};

  vlc = callPackage ../applications/video/vlc {
    ffmpeg = ffmpeg_2;
    libva = libva-full; # also wants libva-x11
  };

  vlc_npapi = callPackage ../applications/video/vlc/plugin.nix {
    gtk = gtk2;
  };

  vlc_qt5 = qt5.vlc;

  vmpk = callPackage ../applications/audio/vmpk { };

  vnstat = callPackage ../applications/networking/vnstat { };

  volnoti = callPackage ../applications/misc/volnoti { };

  vorbis-tools = callPackage ../applications/audio/vorbis-tools { };

  vscode = callPackage ../applications/editors/vscode { };

  vue = callPackage ../applications/misc/vue { };

  vwm = callPackage ../applications/window-managers/vwm { };

  vym = callPackage ../applications/misc/vym { };

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

  # Version for batch text processing, not a good browser
  w3m-batch = w3m.override {
    graphicsSupport = false;
    mouseSupport = false;
    x11Support = false;
    imlib2 = imlib2-nox;
  };

  weechat = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libobjc;
    inherit (darwin) libresolv;
  };

  westonLite = callPackage ../applications/window-managers/weston {
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

  windowlab = callPackage ../applications/window-managers/windowlab { };

  windowmaker = callPackage ../applications/window-managers/windowmaker { };

  wily = callPackage ../applications/editors/wily { };

  alsamixer.app = callPackage ../applications/window-managers/windowmaker/dockapps/alsamixer.app.nix { };

  wmcalclock = callPackage ../applications/window-managers/windowmaker/dockapps/wmcalclock.nix { };

  wmsm.app = callPackage ../applications/window-managers/windowmaker/dockapps/wmsm.app.nix { };

  wmsystemtray = callPackage ../applications/window-managers/windowmaker/dockapps/wmsystemtray.nix { };

  winswitch = callPackage ../tools/X11/winswitch { };

  wings = callPackage ../applications/graphics/wings { };

  wireguard = callPackage ../os-specific/linux/wireguard { };

  wmname = callPackage ../applications/misc/wmname { };

  wmctrl = callPackage ../tools/X11/wmctrl { };

  wmii_hg = callPackage ../applications/window-managers/wmii-hg { };

  wordnet = callPackage ../applications/misc/wordnet { };

  worker = callPackage ../applications/misc/worker { };

  workrave = callPackage ../applications/misc/workrave {
    inherit (gnome2) GConf gconfmm;
    inherit (python27Packages) cheetah;
  };

  wpsoffice = callPackage ../applications/office/wpsoffice {};

  wrapFirefox = callPackage ../applications/networking/browsers/firefox/wrapper.nix { };

  wp-cli = callPackage ../development/tools/wp-cli { };

  retroArchCores =
    let
      cfg = config.retroarch or {};
      inherit (lib) optional;
    in with libretro;
      ([ ]
      ++ optional (cfg.enable4do or false) _4do
      ++ optional (cfg.enableBsnesMercury or false) bsnes-mercury
      ++ optional (cfg.enableDesmume or false) desmume
      ++ optional (cfg.enableFBA or false) fba
      ++ optional (cfg.enableFceumm or false) fceumm
      ++ optional (cfg.enableGambatte or false) gambatte
      ++ optional (cfg.enableGenesisPlusGX or false) genesis-plus-gx
      ++ optional (cfg.enableMAME or false) mame
      ++ optional (cfg.enableMednafenPCEFast or false) mednafen-pce-fast
      ++ optional (cfg.enableMednafenPSX or false) mednafen-psx
      ++ optional (cfg.enableMednafenSaturn or false) mednafen-saturn
      ++ optional (cfg.enableMGBA or false) mgba
      ++ optional (cfg.enableMupen64Plus or false) mupen64plus
      ++ optional (cfg.enableNestopia or false) nestopia
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
      ++ optionals (config.kodi.enableControllers or false)
        (with controllers;
          [ default dreamcast gba genesis mouse n64 nes ps snes ])
      ++ optional (config.kodi.enableExodus or false) exodus
      ++ optionals (config.kodi.enableHyperLauncher or false)
           (with hyper-launcher; [ plugin service pdfreader ])
      ++ optional (config.kodi.enableSVTPlay or false) svtplay
      ++ optional (config.kodi.enableSteamLauncher or false) steam-launcher
      ++ optional (config.kodi.enablePVRHTS or false) pvr-hts
      );
  };

  wxhexeditor = callPackage ../applications/editors/wxhexeditor { };

  wxcam = callPackage ../applications/video/wxcam {
    inherit (gnome2) libglade;
    wxGTK = wxGTK28;
    gtk = gtk2;
  };

  x11vnc = callPackage ../tools/X11/x11vnc { };

  x2goclient = callPackage ../applications/networking/remote/x2goclient { };

  x2vnc = callPackage ../tools/X11/x2vnc { };

  x42-plugins = callPackage ../applications/audio/x42-plugins { };

  xaos = callPackage ../applications/graphics/xaos {
    libpng = libpng12;
  };

  xara = callPackage ../applications/graphics/xara { };

  xawtv = callPackage ../applications/video/xawtv { };

  xbindkeys = callPackage ../tools/X11/xbindkeys { };

  xbindkeys-config = callPackage ../tools/X11/xbindkeys-config/default.nix {
    gtk = gtk2;
  };

  kodiPlain = callPackage ../applications/video/kodi {
    libva = libva-full;
  };
  xbmcPlain = kodiPlain;

  kodiPlugins = recurseIntoAttrs (callPackage ../applications/video/kodi/plugins.nix {
    kodi = kodiPlain;
  });
  xbmcPlugins = kodiPlugins;

  kodi = wrapKodi {
    kodi = kodiPlain;
  };
  xbmc = kodi;

  kodi-retroarch-advanced-launchers =
    callPackage ../misc/emulators/retroarch/kodi-advanced-launchers.nix {
      cores = retroArchCores;
  };
  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers;

  xca = qt5.callPackage ../applications/misc/xca { };

  xcalib = callPackage ../tools/X11/xcalib { };

  xcape = callPackage ../tools/X11/xcape { };

  xchainkeys = callPackage ../tools/X11/xchainkeys { };

  xchm = callPackage ../applications/misc/xchm { };

  inherit (xorg) xcompmgr;

  compton = callPackage ../applications/window-managers/compton { };

  compton-git = callPackage ../applications/window-managers/compton/git.nix { };

  xdaliclock = callPackage ../tools/misc/xdaliclock {};

  xdg-user-dirs = callPackage ../tools/X11/xdg-user-dirs { };

  xdg_utils = callPackage ../tools/X11/xdg-utils {
    w3m = w3m-batch;
  };

  xdgmenumaker = callPackage ../applications/misc/xdgmenumaker { };

  xdotool = callPackage ../tools/X11/xdotool { };

  xen_4_5 = callPackage ../applications/virtualization/xen/4.5.nix { stdenv = overrideCC stdenv gcc49; };
  xen_xenServer = callPackage ../applications/virtualization/xen/4.5.nix { xenserverPatched = true; stdenv = overrideCC stdenv gcc49; };
  xen = xen_4_5;

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

  xneur_0_13 = callPackage ../applications/misc/xneur { };

  xneur_0_8 = callPackage ../applications/misc/xneur/0.8.nix { };

  xneur = xneur_0_13;

  gxneur = callPackage ../applications/misc/gxneur  {
    inherit (gnome2) libglade GConf;
  };

  xiphos = callPackage ../applications/misc/xiphos {
    gconf = gnome2.GConf;
    inherit (gnome2) gtkhtml libgtkhtml libglade scrollkeeper;
    python = python27;
    webkitgtk = webkitgtk2;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome2) libgnomeprint libgnomeprintui libgnomecanvas;
  };

  apvlv = callPackage ../applications/misc/apvlv { };

  xpdf = callPackage ../applications/misc/xpdf {
    base14Fonts = "${ghostscript}/share/ghostscript/fonts";
  };

  xkb_switch = callPackage ../tools/X11/xkb-switch { };

  xkblayout-state = callPackage ../applications/misc/xkblayout-state { };

  xmonad-with-packages = callPackage ../applications/window-managers/xmonad/wrapper.nix {
    inherit (haskellPackages) ghcWithPackages;
    packages = self: [];
  };

  xmonad_log_applet_gnome2 = callPackage ../applications/window-managers/xmonad-log-applet {
    desktopSupport = "gnome2";
    inherit (xfce) libxfce4util xfce4panel;
    gnome2_panel = gnome2.gnome_panel;
    GConf2 = gnome2.GConf;
  };

  xmonad_log_applet_gnome3 = callPackage ../applications/window-managers/xmonad-log-applet {
    desktopSupport = "gnome3";
    inherit (xfce) libxfce4util xfce4panel;
    gnome2_panel = gnome2.gnome_panel;
    GConf2 = gnome2.GConf;
  };

  xmonad_log_applet_xfce = callPackage ../applications/window-managers/xmonad-log-applet {
    desktopSupport = "xfce4";
    inherit (xfce) libxfce4util xfce4panel;
    gnome2_panel = gnome2.gnome_panel;
    GConf2 = gnome2.GConf;
  };

  xmpp-client = callPackage ../applications/networking/instant-messengers/xmpp-client { };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra { inherit (texFunctions) fontsConf; };
  libfakeXinerama = callPackage ../tools/X11/xpra/libfakeXinerama.nix { };
  #TODO: 'pil' is not available for python3, yet
  xpraGtk3 = callPackage ../tools/X11/xpra/gtk3.nix { inherit (texFunctions) fontsConf; inherit (python3Packages) buildPythonApplication python cython pygobject3 pycairo; };

  xrectsel = callPackage ../tools/X11/xrectsel { };

  xrestop = callPackage ../tools/X11/xrestop { };

  xsd = callPackage ../development/libraries/xsd { };

  xscreensaver = callPackage ../misc/screensavers/xscreensaver {
    inherit (gnome2) libglade;
  };

  xss-lock = callPackage ../misc/screensavers/xss-lock { };

  xsynth_dssi = callPackage ../applications/audio/xsynth-dssi { };

  xterm = callPackage ../applications/misc/xterm { };

  mlterm = callPackage ../applications/misc/mlterm {
    vte = gnome3.vte;
    libssh2 = null;
    openssl = null;
  };

  finalterm = callPackage ../applications/misc/finalterm { };

  roxterm = callPackage ../applications/misc/roxterm {
    inherit (pythonPackages) lockfile;
    inherit (gnome3) gsettings_desktop_schemas vte;
  };

  xtrace = callPackage ../tools/X11/xtrace { };

  xmacro = callPackage ../tools/X11/xmacro { };

  xmove = callPackage ../applications/misc/xmove { };

  xmp = callPackage ../applications/audio/xmp { };

  xnee = callPackage ../tools/X11/xnee { };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gnome2) scrollkeeper libglade;
  };

  xzgv = callPackage ../applications/graphics/xzgv { };

  yabar = callPackage ../applications/window-managers/yabar { };

  yakuake = kde5.callPackage ../applications/misc/yakuake/3.0.nix {};

  yarp = callPackage ../applications/science/robotics/yarp {};

  yate = callPackage ../applications/misc/yate { };

  yed = callPackage ../applications/graphics/yed {};

  inherit (gnome3) yelp;

  ykpers = callPackage ../applications/misc/ykpers {};

  yoshimi = callPackage ../applications/audio/yoshimi { };

  inherit (python3Packages) you-get;

  inherit (pythonPackages) youtube-dl;

  zam-plugins = callPackage ../applications/audio/zam-plugins { };

  zathura = callPackage ../applications/misc/zathura {
    useMupdf = config.zathura.useMupdf or true;
  };

  zed = callPackage ../applications/editors/zed { };

  zeroc_ice = callPackage ../development/libraries/zeroc-ice { };

  zexy = callPackage ../applications/audio/pd-plugins/zexy  { };

  zgrviewer = callPackage ../applications/graphics/zgrviewer {};

  zgv = callPackage ../applications/graphics/zgv {
   # Enable the below line for terminal display. Note
   # that it requires sixel graphics compatible terminals like mlterm
   # or xterm -ti 340
   SDL = SDL_sixel;
  };

  zim = callPackage ../applications/office/zim { };

  zotero = callPackage ../applications/office/zotero {
    firefox = firefox-esr-unwrapped;
  };

  zscroll = callPackage ../applications/misc/zscroll {};

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx { };

  ### GAMES

  "2048-in-terminal" = callPackage ../games/2048-in-terminal { };

  "90secondportraits" = callPackage ../games/90secondportraits { love = love_0_10; };

  adom = callPackage ../games/adom { };

  airstrike = callPackage ../games/airstrike { };

  alienarena = callPackage ../games/alienarena { };

  amoeba = callPackage ../games/amoeba { };
  amoeba-data = callPackage ../games/amoeba/data.nix { };

  andyetitmoves = if stdenv.isLinux then callPackage ../games/andyetitmoves {} else null;

  angband = callPackage ../games/angband { };

  anki = callPackage ../games/anki { };

  armagetronad = callPackage ../games/armagetronad { };

  arx-libertatis = callPackage ../games/arx-libertatis { };

  asc = callPackage ../games/asc {
    lua = lua5_1;
    libsigcxx = libsigcxx12;
  };

  astromenace = callPackage ../games/astromenace { };

  atanks = callPackage ../games/atanks {};

  ballAndPaddle = callPackage ../games/ball-and-paddle {
    guile = guile_1_8;
  };

  banner = callPackage ../games/banner {};

  bastet = callPackage ../games/bastet {};

  beancount = callPackage ../applications/office/beancount {
      pythonPackages = python3Packages;
  };

  bean-add = callPackage ../applications/office/beancount/bean-add.nix { };

  beret = callPackage ../games/beret { };

  bitsnbots = callPackage ../games/bitsnbots {
    lua = lua5;
  };

  blackshades = callPackage ../games/blackshades { };

  blackshadeselite = callPackage ../games/blackshadeselite { };

  blobby = callPackage ../games/blobby { };

  brogue = callPackage ../games/brogue { };

  bsdgames = callPackage ../games/bsdgames { };

  btanks = callPackage ../games/btanks { };

  bzflag = callPackage ../games/bzflag { };

  cataclysm-dda = callPackage ../games/cataclysm-dda { };

  chessdb = callPackage ../games/chessdb { };

  chessx = qt5.callPackage ../games/chessx { };

  chocolateDoom = callPackage ../games/chocolate-doom { };

  ckan = callPackage ../games/ckan { };

  cockatrice = qt5.callPackage ../games/cockatrice {  };

  commandergenius = callPackage ../games/commandergenius { };

  confd = callPackage ../tools/system/confd { };

  construoBase = lowPrio (callPackage ../games/construo {
    mesa = null;
    freeglut = null;
  });

  construo = construoBase.override {
    inherit mesa freeglut;
  };

  crack_attack = callPackage ../games/crack-attack { };

  crafty = callPackage ../games/crafty { };

  crawlTiles = crawl.override {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  crrcsim = callPackage ../games/crrcsim {};

  cuyo = callPackage ../games/cuyo { };

  dhewm3 = callPackage ../games/dhewm3 {};

  digikam5 = kde5.callPackage ../applications/graphics/digikam/5.nix {
    boost = boost160;
  };

  drumkv1 = callPackage ../applications/audio/drumkv1 { };

  duckmarines = callPackage ../games/duckmarines { love = love_0_9; };

  dwarf-fortress-packages = recurseIntoAttrs (callPackage ../games/dwarf-fortress { });

  dwarf-fortress = dwarf-fortress-packages.dwarf-fortress.override { };

  dwarf-therapist = dwarf-fortress-packages.dwarf-therapist;

  d1x_rebirth = callPackage ../games/d1x-rebirth { };

  d2x_rebirth = callPackage ../games/d2x-rebirth { };

  eboard = callPackage ../games/eboard { };

  eduke32 = callPackage ../games/eduke32 { };

  egoboo = callPackage ../games/egoboo { };

  endless-sky = callPackage ../games/endless-sky { };

  eternity = callPackage ../games/eternity-engine { };

  extremetuxracer = callPackage ../games/extremetuxracer {
    libpng = libpng12;
  };

  exult = callPackage ../games/exult { };

  factorio = callPackage ../games/factorio { releaseType = "alpha"; };

  factorio-headless = callPackage ../games/factorio { releaseType = "headless"; };

  factorio-mods = callPackage ../games/factorio/mods.nix { };

  factorio-utils = callPackage ../games/factorio/utils.nix { };

  fairymax = callPackage ../games/fairymax {};

  fava = callPackage ../applications/office/fava {};

  fish-fillets-ng = callPackage ../games/fish-fillets-ng {};

  flightgear = qt5.callPackage ../games/flightgear { };

  freecell-solver = callPackage ../games/freecell-solver { };

  freeciv = callPackage ../games/freeciv { };

  freeciv_gtk = callPackage ../games/freeciv {
    gtkClient = true;
    sdlClient = false;
  };

  freedink = callPackage ../games/freedink { };

  freeorion = callPackage ../games/freeorion {
    boost = boost160;
  };

  frotz = callPackage ../games/frotz { };

  fsg = callPackage ../games/fsg {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  gambatte = callPackage ../games/gambatte { };

  gav = callPackage ../games/gav { };

  gcs = callPackage ../games/gcs { };

  gemrb = callPackage ../games/gemrb { };

  ghostOne = callPackage ../servers/games/ghost-one { };

  gl117 = callPackage ../games/gl-117 {};

  glestae = callPackage ../games/glestae {};

  globulation2 = callPackage ../games/globulation {
    boost = boost155;
  };

  gltron = callPackage ../games/gltron { };

  gmad = callPackage ../games/gmad { };

  gnubg = callPackage ../games/gnubg { };

  gnuchess = callPackage ../games/gnuchess { };

  gnugo = callPackage ../games/gnugo { };

  gogui = callPackage ../games/gogui {};

  gtypist = callPackage ../games/gtypist { };

  gzdoom = callPackage ../games/gzdoom { };

  hawkthorne = callPackage ../games/hawkthorne { love = love_0_9; };

  hedgewars = callPackage ../games/hedgewars {
    inherit (haskellPackages) ghcWithPackages;
    ffmpeg = ffmpeg_2;
  };

  hexen = callPackage ../games/hexen { };

  holdingnuts = callPackage ../games/holdingnuts { };

  icbm3d = callPackage ../games/icbm3d { };

  ingen = callPackage ../applications/audio/ingen {
    inherit (pythonPackages) rdflib;
  };

  instead = callPackage ../games/instead {
    lua = lua5;
  };

  klavaro = callPackage ../games/klavaro {};

  kobodeluxe = callPackage ../games/kobodeluxe { };

  lgogdownloader = callPackage ../games/lgogdownloader { };

  liberal-crime-squad = callPackage ../games/liberal-crime-squad { };

  lincity = callPackage ../games/lincity {};

  lincity_ng = callPackage ../games/lincity/ng.nix {};

  liquidwar = callPackage ../games/liquidwar {
    guile = guile_1_8;
  };

  liquidwar5 = callPackage ../games/liquidwar/5.nix {
  };

  macopix = callPackage ../games/macopix {
    gtk = gtk2;
  };

  mars = callPackage ../games/mars { };

  megaglest = callPackage ../games/megaglest {};

  micropolis = callPackage ../games/micropolis { };

  minecraft = callPackage ../games/minecraft {
    useAlsa = config.minecraft.alsa or false;
  };

  minecraft-server = callPackage ../games/minecraft-server { };

  multimc = qt5.callPackage ../games/multimc { };

  minetest = callPackage ../games/minetest {
    libpng = libpng12;
  };

  mnemosyne = callPackage ../games/mnemosyne { };

  mrrescue = callPackage ../games/mrrescue { };

  mudlet = qt5.callPackage ../games/mudlet {
    inherit (lua51Packages) luafilesystem lrexlib luazip luasqlite3;
  };

  n2048 = callPackage ../games/n2048 {};

  naev = callPackage ../games/naev { };

  nethack = callPackage ../games/nethack { };

  neverball = callPackage ../games/neverball { };

  nexuiz = callPackage ../games/nexuiz { };

  njam = callPackage ../games/njam { };

  newtonwars = callPackage ../games/newtonwars { };

  odamex = callPackage ../games/odamex { };

  oilrush = callPackage ../games/oilrush { };

  onscripter-en = callPackage ../games/onscripter-en { };

  openarena = callPackage ../games/openarena { };

  opendungeons = callPackage ../games/opendungeons { };

  openlierox = callPackage ../games/openlierox { };

  openclonk = callPackage ../games/openclonk { };

  openmw = callPackage ../games/openmw { };

  openra = callPackage ../games/openra { lua = lua5_1; };

  openrw = callPackage ../games/openrw { };

  openspades = callPackage ../games/openspades {};

  openspades-git = lowPrio (callPackage ../games/openspades/git.nix {});

  openttd = callPackage ../games/openttd {
    zlib = zlibStatic;
  };

  opentyrian = callPackage ../games/opentyrian { };

  openxcom = callPackage ../games/openxcom { };

  orthorobot = callPackage ../games/orthorobot { love = love_0_7; };

  performous = callPackage ../games/performous { };

  pingus = callPackage ../games/pingus {};

  pioneer = callPackage ../games/pioneer { };

  pioneers = callPackage ../games/pioneers { };

  planetary_annihilation = callPackage ../games/planetaryannihilation { };

  pong3d = callPackage ../games/pong3d { };

  pokerth = callPackage ../games/pokerth { };

  pokerth-server = with callPackage ../games/pokerth { }; server;

  prboom = callPackage ../games/prboom { };

  privateer = callPackage ../games/privateer { };

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

  ioquake3 = callPackage ../games/quake3/ioquake { };

  quantumminigolf = callPackage ../games/quantumminigolf {};

  racer = callPackage ../games/racer { };

  residualvm = callPackage ../games/residualvm {
    openglSupport = mesaSupported;
  };

  rigsofrods = callPackage ../games/rigsofrods {
    angelscript = angelscript_2_22;
    mygui = mygui.override {
      withOgre = true;
    };
  };

  rili = callPackage ../games/rili { };

  rimshot = callPackage ../games/rimshot { love = love_0_7; };

  rogue = callPackage ../games/rogue { };

  saga = callPackage ../applications/gis/saga { };

  samplv1 = callPackage ../applications/audio/samplv1 { };

  sauerbraten = callPackage ../games/sauerbraten {};

  scid = callPackage ../games/scid { };

  scummvm = callPackage ../games/scummvm { };

  scorched3d = callPackage ../games/scorched3d { };

  scrolls = callPackage ../games/scrolls { };

  sdlmame = callPackage ../games/sdlmame { };

  sgtpuzzles = callPackage (callPackage ../games/sgt-puzzles) { };

  sienna = callPackage ../games/sienna { love = love_0_10; };

  simutrans = callPackage ../games/simutrans { };
  # get binaries without data built by Hydra
  simutrans_binaries = lowPrio simutrans.binaries;

  snake4 = callPackage ../games/snake4 { };

  soi = callPackage ../games/soi {
    lua = lua5_1;
  };

  solarus = callPackage ../games/solarus { };

  solarus-quest-editor = qt5.callPackage ../development/tools/solarus-quest-editor { };

  # You still can override by passing more arguments.
  space-orbit = callPackage ../games/space-orbit { };

  spring = callPackage ../games/spring {
    boost = boost155;
    cmake = cmake_2_8;
  };

  springLobby = callPackage ../games/spring/springlobby.nix { };

  stardust = callPackage ../games/stardust {};

  stockfish = callPackage ../games/stockfish { };

  steamPackages = callPackage ../games/steam { };

  steam = steamPackages.steam-chrootenv.override {
    # DEPRECATED
    withJava = config.steam.java or false;
    withPrimus = config.steam.primus or false;
  };

  steam-run = steam.run;

  stepmania = callPackage ../games/stepmania {
    ffmpeg = ffmpeg_2;
  };

  stuntrally = callPackage ../games/stuntrally {
    bullet = bullet283;
    mygui = mygui.override {
      withOgre = true;
    };
  };

  superTux = callPackage ../games/supertux { };

  superTuxKart = callPackage ../games/super-tux-kart { };

  synthv1 = callPackage ../applications/audio/synthv1 { };

  tcl2048 = callPackage ../games/tcl2048 { };

  the-powder-toy = callPackage ../games/the-powder-toy {
    lua = lua5_1;
  };

  tbe = callPackage ../games/the-butterfly-effect { };

  teetertorture = callPackage ../games/teetertorture { };

  teeworlds = callPackage ../games/teeworlds { };

  tennix = callPackage ../games/tennix { };

  terraria-server = callPackage ../games/terraria-server/default.nix { };

  tibia = callPackage_i686 ../games/tibia { };

  tintin = callPackage ../games/tintin { };

  tinyfugue = callPackage ../games/tinyfugue { };

  tome4 = callPackage ../games/tome4 { };

  trackballs = callPackage ../games/trackballs {
    debug = false;
    guile = guile_1_8;
  };

  tremulous = callPackage ../games/tremulous { };

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

  ultrastardx = callPackage ../games/ultrastardx {
    ffmpeg = ffmpeg_0;
    lua = lua5;
  };

  unnethack = callPackage ../games/unnethack { };

  unvanquished = callPackage ../games/unvanquished { };

  uqm = callPackage ../games/uqm { };

  urbanterror = callPackage ../games/urbanterror { };

  ue4 = callPackage ../games/ue4 { };

  ue4demos = recurseIntoAttrs (callPackage ../games/ue4demos { });

  ut2004Packages = callPackage ../games/ut2004 { };

  ut2004demo = self.ut2004Packages.ut2004 [ self.ut2004Packages.ut2004-demo ];

  vapor = callPackage ../games/vapor { love = love_0_8; };

  vapoursynth = callPackage ../development/libraries/vapoursynth { };

  vapoursynth-mvtools = callPackage ../development/libraries/vapoursynth-mvtools { };

  vassal = callPackage ../games/vassal { };

  vdrift = callPackage ../games/vdrift { };

  vectoroids = callPackage ../games/vectoroids { };

  vessel = callPackage_i686 ../games/vessel { };

  voxelands = callPackage ../games/voxelands {
    libpng = libpng12;
  };

  warmux = callPackage ../games/warmux { };

  warsow = callPackage ../games/warsow { };

  warzone2100 = qt5.callPackage ../games/warzone2100 { };

  wesnoth = callPackage ../games/wesnoth { };

  wesnoth-dev = callPackage ../games/wesnoth/dev.nix { };

  widelands = callPackage ../games/widelands {
    lua = lua5_2;
  };

  worldofgoo_demo = callPackage ../games/worldofgoo {
    demo = true;
  };

  worldofgoo = callPackage ../games/worldofgoo { };

  xboard =  callPackage ../games/xboard { };

  xbomb = callPackage ../games/xbomb { };

  xconq = callPackage ../games/xconq {
    tcl = tcl-8_5;
    tk = tk-8_5;
  };

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

  zandronum = callPackage ../games/zandronum {
    cmake = cmake_2_8;
  };

  zandronum-server = zandronum.override {
    serverOnly = true;
  };

  zandronum-bin = hiPrio (callPackage ../games/zandronum/bin.nix { });

  zangband = callPackage ../games/zangband { };

  zdbsp = callPackage ../games/zdoom/zdbsp.nix { };

  zdoom = callPackage ../games/zdoom { };

  zod = callPackage ../games/zod { };

  zoom = callPackage ../games/zoom { };

  keen4 = callPackage ../games/keen4 { };

  zeroadPackages = callPackage ../games/0ad { };

  zeroad = zeroadPackages.zeroad;

  ### DESKTOP ENVIRONMENTS

  clearlooks-phenix = callPackage ../misc/themes/gtk3/clearlooks-phenix { };

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment {
    callPackage = newScope pkgs.enlightenment;
  });

  gnome2 = recurseIntoAttrs (callPackage ../desktops/gnome-2 {
    callPackage = pkgs.newScope pkgs.gnome2;
    self = pkgs.gnome2;
  } // {
    inherit (pkgs)
      # GTK Libs
      glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtkmm2

      # Included for backwards compatibility
      libsoup libwnck gtk_doc gnome_doc_utils;

    gtk = self.gtk2;
    gtkmm = self.gtkmm2;
    libcanberra = self.libcanberra_gtk2;
  });

  gnome3_22 = recurseIntoAttrs (callPackage ../desktops/gnome-3/3.22 { });

  gnome3 = gnome3_22;

  hsetroot = callPackage ../tools/X11/hsetroot { };

  kakasi = callPackage ../tools/text/kakasi { };

  kde4 = recurseIntoAttrs pkgs.kde414;

  kde414 =
    kdePackagesFor
      {
        libusb = libusb1;
        python2Packages = python2Packages;
        inherit (python2Packages) python;
        libcanberra = libcanberra_kde;
        boost = boost155;
        kdelibs = kde5.kdelibs;
        subversionClient = pkgs.subversion18.override {
          bdbSupport = false;
          perlBindings = true;
          pythonBindings = true;
        };
        ruby = ruby_2_2; # see https://github.com/NixOS/nixpkgs/pull/12610#issuecomment-188666473
        ffmpeg = ffmpeg_2; # ffmpegthumb doesn't build otherwise
      }
      ../desktops/kde-4.14;


  kdePackagesFor = extra: dir:
    let
      # list of extra packages not included in KDE
      # the real work in this function is done below this list
      extraPackages = callPackage:
        rec {
          amarok = callPackage ../applications/audio/amarok {
            ffmpeg = ffmpeg_2;
          };

          bangarang = callPackage ../applications/video/bangarang { };

          basket = callPackage ../applications/office/basket { };

          bluedevil = callPackage ../tools/bluetooth/bluedevil { };

          calligra = callPackage ../applications/office/calligra {
            vc = vc_0_7;
          };

          choqok = callPackage ../applications/networking/instant-messengers/choqok { };

          colord-kde = callPackage ../tools/misc/colord-kde { };

          digikam = callPackage ../applications/graphics/digikam { };

          eventlist = callPackage ../applications/office/eventlist {};

          k3b-original = lowPrio (callPackage ../applications/misc/k3b { });

          k3b = callPackage ../applications/misc/k3b/wrapper.nix { };

          kadu = callPackage ../applications/networking/instant-messengers/kadu { };

          kbibtex = callPackage ../applications/office/kbibtex { };

          kde_gtk_config = callPackage ../tools/misc/kde-gtk-config { };

          kde_wacomtablet = callPackage ../applications/misc/kde-wacomtablet { };

          kdeconnect = callPackage ../applications/misc/kdeconnect/0.7.nix { };

          kdenlive = callPackage ../applications/video/kdenlive { mlt = mlt-qt4; };

          kdesvn = callPackage ../applications/version-management/kdesvn { };

          kdevelop = callPackage ../applications/editors/kdevelop { };

          kdevplatform = callPackage ../development/libraries/kdevplatform {
            boost = boost155;
          };

          kdiff3 = callPackage ../tools/text/kdiff3 { };

          kgraphviewer = callPackage ../applications/graphics/kgraphviewer { };

          kile = callPackage ../applications/editors/kile { };

          kmplayer = callPackage ../applications/video/kmplayer { };

          kmymoney = callPackage ../applications/office/kmymoney { };

          kipi_plugins = callPackage ../applications/graphics/kipi-plugins { };

          konversation = callPackage ../applications/networking/irc/konversation { };

          kvirc = callPackage ../applications/networking/irc/kvirc { };

          krename = callPackage ../applications/misc/krename/kde4.nix {
            taglib = taglib_1_9;
          };

          krusader = callPackage ../applications/misc/krusader { };

          ksshaskpass = callPackage ../tools/security/ksshaskpass {};

          ktorrent = callPackage ../applications/networking/p2p/ktorrent { };

          kuickshow = callPackage ../applications/graphics/kuickshow { };

          libalkimia = callPackage ../development/libraries/libalkimia { };

          libktorrent = callPackage ../development/libraries/libktorrent {
            boost = boost155;
          };

          libkvkontakte = callPackage ../development/libraries/libkvkontakte { };

          liblikeback = callPackage ../development/libraries/liblikeback { };

          libmm-qt = callPackage ../development/libraries/libmm-qt { };

          libnm-qt = callPackage ../development/libraries/libnm-qt { };

          massif-visualizer = callPackage ../development/tools/analysis/massif-visualizer { };

          partitionManager = callPackage ../tools/misc/partition-manager { };

          plasma-nm = callPackage ../tools/networking/plasma-nm { };

          polkit_kde_agent = callPackage ../tools/security/polkit-kde-agent { };

          qtcurve = callPackage ../misc/themes/qtcurve { };

          quassel = callPackage ../applications/networking/irc/quassel rec {
            monolithic = true;
            daemon = false;
            client = false;
            withKDE = stdenv.isLinux;
            qt = if withKDE then qt4 else qt5; # KDE supported quassel cannot build with qt5 yet (maybe in 0.12.0)
            dconf = gnome3.dconf;
          };

          quasselWithoutKDE = (quassel.override {
            monolithic = true;
            daemon = false;
            client = false;
            withKDE = false;
            #qt = qt5;
            tag = "-without-kde";
          });

          quasselDaemon = (quassel.override {
            monolithic = false;
            daemon = true;
            client = false;
            withKDE = false;
            #qt = qt5;
            tag = "-daemon";
          });

          quasselClient = (quassel.override {
            monolithic = false;
            daemon = false;
            client = true;
            tag = "-client";
          });

          quasselClientWithoutKDE = (quasselClient.override {
            monolithic = false;
            daemon = false;
            client = true;
            withKDE = false;
            #qt = qt5;
            tag = "-client-without-kde";
          });

          rekonq-unwrapped = callPackage ../applications/networking/browsers/rekonq { };
          rekonq = wrapFirefox rekonq-unwrapped { };

          kwebkitpart = callPackage ../applications/networking/browsers/kwebkitpart { };

          rsibreak = callPackage ../applications/misc/rsibreak { };

          semnotes = callPackage ../applications/misc/semnotes { };

          skrooge = callPackage ../applications/office/skrooge { };

          telepathy = callPackage ../applications/networking/instant-messengers/telepathy/kde {};

          yakuake = callPackage ../applications/misc/yakuake { };

          zanshin = callPackage ../applications/office/zanshin { };

          kwooty = callPackage ../applications/networking/newsreaders/kwooty { };
        };

      callPackageOrig = newScope extra;

      makePackages = extra:
        let
          callPackage = newScope (extra // self);
          kde4 = callPackageOrig dir { inherit callPackage callPackageOrig; };
          self =
            kde4
            // extraPackages callPackage
            // {
              inherit kde4;
              wrapper = callPackage ../build-support/kdewrapper {};
              recurseForRelease = true;
            };
        in self;

    in makeOverridable makePackages extra;

  lumina = callPackage ../desktops/lumina { };

  lxqt = recurseIntoAttrs (callPackage ../desktops/lxqt { });

  mate = recurseIntoAttrs (callPackage ../desktops/mate {
    callPackage = newScope pkgs.mate;
  });

  pantheon = recurseIntoAttrs rec {
    callPackage = newScope pkgs.pantheon;
    pantheon-terminal = callPackage ../desktops/pantheon/apps/pantheon-terminal { };
  };

  redshift = callPackage ../applications/misc/redshift {
    inherit (python3Packages) python pygobject3 pyxdg;
  };

  redshift-plasma-applet = callPackage ../applications/misc/redshift-plasma-applet { };

  orion = callPackage ../misc/themes/orion {};

  albatross = callPackage ../misc/themes/albatross { };

  oxygen-gtk2 = callPackage ../misc/themes/gtk2/oxygen-gtk { };

  oxygen-gtk3 = callPackage ../misc/themes/gtk3/oxygen-gtk3 { };

  oxygen_gtk = oxygen-gtk2; # backwards compatibility

  gtk_engines = callPackage ../misc/themes/gtk2/gtk-engines { };

  gtk-engine-murrine = callPackage ../misc/themes/gtk2/gtk-engine-murrine { };

  gnome_themes_standard = gnome3.gnome_themes_standard;

  numix-gtk-theme = callPackage ../misc/themes/numix { };

  kde5 =
    let
      plasma = import ../desktops/kde-5/plasma { inherit pkgs; };
      applications = import ../desktops/kde-5/applications { inherit pkgs; };
      merged = self:
        {
          plasma = plasma self;
          frameworks = qt5.kdeFrameworks;
          applications = applications self;
          kipi-plugins = self.callPackage ../applications/graphics/kipi-plugins/5.x.nix {};
        }
        // qt5.kdeFrameworks
        // plasma self
        // applications self;
    in
      recurseIntoAttrs (lib.makeScope qt5.newScope merged);

  theme-vertex = callPackage ../misc/themes/vertex { };

  rox-filer = callPackage ../desktops/rox/rox-filer {
    gtk = gtk2;
  };

  xfce = xfce4-12;
  xfce4-12 = recurseIntoAttrs (callPackage ../desktops/xfce { });

  xrandr-invert-colors = callPackage ../applications/misc/xrandr-invert-colors { };

  ### SCIENCE

  ### SCIENCE/GEOMETRY

  drgeo = callPackage ../applications/science/geometry/drgeo {
    inherit (gnome2) libglade;
    guile = guile_1_8;
  };

  tetgen = callPackage ../applications/science/geometry/tetgen { }; # AGPL3+
  tetgen_1_4 = callPackage ../applications/science/geometry/tetgen/1.4.nix { }; # MIT

  ### SCIENCE/BIOLOGY

  alliance = callPackage ../applications/science/electronics/alliance { };

  archimedes = callPackage ../applications/science/electronics/archimedes {
    stdenv = overrideCC stdenv gcc49;
  };

  bcftools = callPackage ../applications/science/biology/bcftools { };

  ecopcr = callPackage ../applications/science/biology/ecopcr { };

  emboss = callPackage ../applications/science/biology/emboss { };

  htslib = callPackage ../development/libraries/science/biology/htslib { };

  igv = callPackage ../applications/science/biology/igv { };

  neuron = callPackage ../applications/science/biology/neuron {
    python = null;
  };

  neuron-mpi = appendToName "mpi" (neuron.override {
    mpi = pkgs.openmpi;
  });

  mrbayes = callPackage ../applications/science/biology/mrbayes { };

  minc_tools = callPackage ../applications/science/biology/minc-tools { };

  ncbi_tools = callPackage ../applications/science/biology/ncbi-tools { };

  paml = callPackage ../applications/science/biology/paml { };

  plink = callPackage ../applications/science/biology/plink/default.nix { };

  plink-ng = callPackage ../applications/science/biology/plink-ng/default.nix { };

  samtools = callPackage ../applications/science/biology/samtools/default.nix { };

  bwa = callPackage ../applications/science/biology/bwa/default.nix { };

  ### SCIENCE/MATH

  arpack = callPackage ../development/libraries/science/math/arpack { };

  atlas = callPackage ../development/libraries/science/math/atlas {
    # The build process measures CPU capabilities and optimizes the
    # library to perform best on that particular machine. That is a
    # great feature, but it's of limited use with pre-built binaries
    # coming from a central build farm.
    tolerateCpuTimingInaccuracy = true;
    liblapack = liblapack_3_5_0WithoutAtlas;
    withLapack = false;
  };

  atlasWithLapack = atlas.override { withLapack = true; };

  blas = callPackage ../development/libraries/science/math/blas { };

  clblas-cuda = callPackage ../development/libraries/science/math/clblas/cuda {
    cudatoolkit = pkgs.cudatoolkit75;
    inherit (linuxPackages) nvidia_x11;
  };

  jags = callPackage ../applications/science/math/jags { };


  # We have essentially 4 permutations of liblapack: version 3.4.1 or 3.5.0,
  # and with or without atlas as a dependency. The default `liblapack` is 3.4.1
  # with atlas. Atlas, when built with liblapack as a dependency, uses 3.5.0
  # without atlas. Etc.
  liblapackWithAtlas = callPackage ../development/libraries/science/math/liblapack {};
  liblapackWithoutAtlas = liblapackWithAtlas.override { atlas = null; };
  liblapack_3_5_0WithAtlas = callPackage ../development/libraries/science/math/liblapack/3.5.0.nix {};
  liblapack_3_5_0WithoutAtlas = liblapack_3_5_0WithAtlas.override { atlas = null; };
  liblapack = liblapackWithAtlas;
  liblapack_3_5_0 = liblapack_3_5_0WithAtlas;

  liblbfgs = callPackage ../development/libraries/science/math/liblbfgs { };

  openblas = callPackage ../development/libraries/science/math/openblas { };

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  openlibm = callPackage ../development/libraries/science/math/openlibm {};

  openspecfun = callPackage ../development/libraries/science/math/openspecfun {};

  lie = callPackage ../applications/science/math/LiE { };

  magma = callPackage ../development/libraries/science/math/magma { };

  mathematica = callPackage ../applications/science/math/mathematica { };
  mathematica9 = callPackage ../applications/science/math/mathematica/9.nix { };
  mathematica10 = callPackage ../applications/science/math/mathematica/10.nix { };

  metis = callPackage ../development/libraries/science/math/metis {};

  nauty = callPackage ../applications/science/math/nauty {};

  sage = callPackage ../applications/science/math/sage { };

  suitesparse_4_2 = callPackage ../development/libraries/science/math/suitesparse/4.2.nix { };
  suitesparse_4_4 = callPackage ../development/libraries/science/math/suitesparse {};
  suitesparse = suitesparse_4_4;

  superlu = callPackage ../development/libraries/science/math/superlu {};

  symmetrica = callPackage ../applications/science/math/symmetrica {};

  ipopt = callPackage ../development/libraries/science/math/ipopt { openblas = openblasCompat; };

  gmsh = callPackage ../applications/science/math/gmsh { };

  ### SCIENCE/MOLECULAR-DYNAMICS

  lammps = callPackage ../applications/science/molecular-dynamics/lammps {
    fftw = fftw;
  };

  lammps-mpi = appendToName "mpi" (lammps.override {
    mpiSupport = true;
    mpi = openmpi;
  });

  gromacs = callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    mpiEnabled = false;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  };

  gromacsMpi = lowPrio (callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    mpiEnabled = true;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  });

  gromacsDouble = lowPrio (callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = false;
    mpiEnabled = false;
    fftw = fftw;
    cmake = cmakeCurses;
  });

  gromacsDoubleMpi = lowPrio (callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = false;
    mpiEnabled = true;
    fftw = fftw;
    cmake = cmakeCurses;
  });

  ### PHYSICS

  sacrifice = callPackage ../applications/science/physics/sacrifice {};

  sherpa = callPackage ../applications/science/physics/sherpa {};

  ### SCIENCE/PROGRAMMING

  dafny = dotnetPackages.Dafny;

  plm = callPackage ../applications/science/programming/plm { };

  ### SCIENCE/LOGIC

  abc-verifier = callPackage ../applications/science/logic/abc {};

  abella = callPackage ../applications/science/logic/abella {};

  alt-ergo = callPackage ../applications/science/logic/alt-ergo {
    ocamlPackages = ocamlPackages_4_02;
  };

  aspino = callPackage ../applications/science/logic/aspino {};

  boogie = dotnetPackages.Boogie;

  coq_8_3 = callPackage ../applications/science/logic/coq/8.3.nix {
    make = pkgs.gnumake3;
    inherit (ocamlPackages_3_12_1) ocaml findlib;
    camlp5 = ocamlPackages_3_12_1.camlp5_transitional;
    lablgtk = ocamlPackages_3_12_1.lablgtk_2_14;
  };
  coq_8_4 = callPackage ../applications/science/logic/coq/8.4.nix {
    inherit (ocamlPackages_4_01_0) ocaml findlib lablgtk;
    camlp5 = ocamlPackages_4_01_0.camlp5_transitional;
  };
  coq_8_5 = callPackage ../applications/science/logic/coq {
    version = "8.5pl3";
  };
  coq_8_6 = callPackage ../applications/science/logic/coq {};
  coq_HEAD = callPackage ../applications/science/logic/coq/HEAD.nix {
    inherit (ocamlPackages) ocaml findlib lablgtk;
    camlp5 = ocamlPackages.camlp5_transitional;
  };
  coq = coq_8_4;

  mkCoqPackages_8_4 = self: let callPackage = newScope self; in {
    inherit callPackage;
    coq = coq_8_4;
    coqPackages = coqPackages_8_4;

    contribs =
      let contribs =
        import ../development/coq-modules/contribs
        contribs
        callPackage { };
      in
        recurseIntoAttrs contribs;

    bedrock = callPackage ../development/coq-modules/bedrock {};
    coqExtLib = callPackage ../development/coq-modules/coq-ext-lib {};
    coqeal = callPackage ../development/coq-modules/coqeal {};
    coquelicot = callPackage ../development/coq-modules/coquelicot {};
    domains = callPackage ../development/coq-modules/domains {};
    fiat = callPackage ../development/coq-modules/fiat {};
    fiat_HEAD = callPackage ../development/coq-modules/fiat/HEAD.nix {};
    flocq = callPackage ../development/coq-modules/flocq {};
    heq = callPackage ../development/coq-modules/heq {};
    interval = callPackage ../development/coq-modules/interval {};
    mathcomp = callPackage ../development/coq-modules/mathcomp {};
    paco = callPackage ../development/coq-modules/paco {};
    QuickChick = callPackage ../development/coq-modules/QuickChick {};
    ssreflect = callPackage ../development/coq-modules/ssreflect {};
    tlc = callPackage ../development/coq-modules/tlc {};
    unimath = callPackage ../development/coq-modules/unimath {};
    ynot = callPackage ../development/coq-modules/ynot {};
  };

  mkCoqPackages_8_5 = self: let callPackage = newScope self; in rec {
    inherit callPackage;
    coq = coq_8_5;
    coqPackages = coqPackages_8_5;

    coq-ext-lib = callPackage ../development/coq-modules/coq-ext-lib {};
    coquelicot = callPackage ../development/coq-modules/coquelicot {};
    dpdgraph = callPackage ../development/coq-modules/dpdgraph {};
    flocq = callPackage ../development/coq-modules/flocq {};
    interval = callPackage ../development/coq-modules/interval {};
    mathcomp = callPackage ../development/coq-modules/mathcomp { };
    math-classes = callPackage ../development/coq-modules/math-classes { };
    ssreflect = callPackage ../development/coq-modules/ssreflect { };
    fiat_HEAD = callPackage ../development/coq-modules/fiat/HEAD.nix {};
  };

  mkCoqPackages_8_6 = self: let callPackage = newScope self; in rec {
    inherit callPackage;
    coq = coq_8_6;
    coqPackages = coqPackages_8_6;

    coq-ext-lib = callPackage ../development/coq-modules/coq-ext-lib {};
    coquelicot = callPackage ../development/coq-modules/coquelicot {};
    dpdgraph = callPackage ../development/coq-modules/dpdgraph {};
    flocq = callPackage ../development/coq-modules/flocq {};
    interval = callPackage ../development/coq-modules/interval {};
    mathcomp = callPackage ../development/coq-modules/mathcomp { };
    ssreflect = callPackage ../development/coq-modules/ssreflect { };
    fiat_HEAD = callPackage ../development/coq-modules/fiat/HEAD.nix {};
  };

  coqPackages_8_4 = mkCoqPackages_8_4 coqPackages_8_4;
  coqPackages_8_5 = mkCoqPackages_8_5 coqPackages_8_5;
  coqPackages_8_6 = mkCoqPackages_8_6 coqPackages_8_6;
  coqPackages = coqPackages_8_4;

  cryptoverif = callPackage ../applications/science/logic/cryptoverif { };

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (a: { dontDisableStatic = true; });
  };
  cvc4 = callPackage ../applications/science/logic/cvc4 {};

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {};

  eprover = callPackage ../applications/science/logic/eprover { };

  gappa = callPackage ../applications/science/logic/gappa { };

  gfan = callPackage ../applications/science/math/gfan {};

  ginac = callPackage ../applications/science/math/ginac { };

  glucose = callPackage ../applications/science/logic/glucose { };
  glucose-syrup = callPackage ../applications/science/logic/glucose/syrup.nix { };

  hol = callPackage ../applications/science/logic/hol { };

  inherit (ocamlPackages) hol_light;

  hologram = callPackage ../tools/security/hologram { };

  tini = callPackage ../applications/virtualization/tini {};

  isabelle = callPackage ../applications/science/logic/isabelle {
    java = if stdenv.isLinux then jre else jdk;
  };

  iprover = callPackage ../applications/science/logic/iprover {};

  jonprl = callPackage ../applications/science/logic/jonprl {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  lean = callPackage ../applications/science/logic/lean {};
  lean2 = callPackage ../applications/science/logic/lean2 {};
  lean3 = lean;

  leo2 = callPackage ../applications/science/logic/leo2 {
     ocaml = ocamlPackages_4_01_0.ocaml;};

  logisim = callPackage ../applications/science/logic/logisim {};

  ltl2ba = callPackage ../applications/science/logic/ltl2ba {};

  inherit (ocaml-ng.ocamlPackages_3_11_2) matita;

  matita_130312 = lowPrio ocamlPackages.matita_130312;

  metis-prover = callPackage ../applications/science/logic/metis-prover { };

  mcrl2 = callPackage ../applications/science/logic/mcrl2 { };

  minisat = callPackage ../applications/science/logic/minisat {};

  opensmt = callPackage ../applications/science/logic/opensmt { };

  inherit (ocamlPackages) ott;

  otter = callPackage ../applications/science/logic/otter {};

  picosat = callPackage ../applications/science/logic/picosat {};

  prooftree = (with ocamlPackages_4_01_0;
    callPackage  ../applications/science/logic/prooftree {
      camlp5 = camlp5_transitional;
    });

  prover9 = callPackage ../applications/science/logic/prover9 { };

  proverif = callPackage ../applications/science/logic/proverif { };

  satallax = callPackage ../applications/science/logic/satallax {
    ocaml = ocamlPackages_4_01_0.ocaml;
  };

  saw-tools = callPackage ../applications/science/logic/saw-tools {};

  spass = callPackage ../applications/science/logic/spass {};

  statverif = callPackage ../applications/science/logic/statverif { };

  tptp = callPackage ../applications/science/logic/tptp {};

  twelf = callPackage ../applications/science/logic/twelf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  verifast = callPackage ../applications/science/logic/verifast {};

  veriT = callPackage ../applications/science/logic/verit {};

  why3 = callPackage ../applications/science/logic/why3 {};

  yices = callPackage ../applications/science/logic/yices {
    gmp-static = gmp.override { withStatic = true; };
  };

  z3 = callPackage ../applications/science/logic/z3 {};
  z3_opt = callPackage ../applications/science/logic/z3_opt {};

  boolector   = boolector15;
  boolector15 = callPackage ../applications/science/logic/boolector {};
  boolector16 = lowPrio (callPackage ../applications/science/logic/boolector {
    useV16 = true;
  });

  ### SCIENCE / ELECTRONICS

  eagle = callPackage ../applications/science/electronics/eagle { };

  caneda = callPackage ../applications/science/electronics/caneda { };

  geda = callPackage ../applications/science/electronics/geda { };

  gerbv = callPackage ../applications/science/electronics/gerbv { };

  gtkwave = callPackage ../applications/science/electronics/gtkwave { };

  kicad = callPackage ../applications/science/electronics/kicad {
    wxGTK = wxGTK30;
    boost = boost160;
  };

  ngspice = callPackage ../applications/science/electronics/ngspice { };

  pcb = callPackage ../applications/science/electronics/pcb { };

  qucs = callPackage ../applications/science/electronics/qucs { };

  xoscope = callPackage ../applications/science/electronics/xoscope { };


  ### SCIENCE / MATH

  caffe = callPackage ../applications/science/math/caffe {
    cudaSupport = config.caffe.cudaSupport or config.cudaSupport or true;
  };

  ecm = callPackage ../applications/science/math/ecm { };

  eukleides = callPackage ../applications/science/math/eukleides {
    texLive = texlive.combine { inherit (texlive) scheme-small; };
    texinfo = texinfo4;
  };

  fricas = callPackage ../applications/science/math/fricas { };

  gap = callPackage ../applications/science/math/gap { };

  geogebra = callPackage ../applications/science/math/geogebra { };

  maxima = callPackage ../applications/science/math/maxima {
    sbcl = sbcl_1_3_12;
    ecl = null;
  };
  maxima-ecl = callPackage ../applications/science/math/maxima {
    ecl = ecl_16_1_2;
    sbcl = null;
  };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { wxGTK = wxGTK30; };

  pari = callPackage ../applications/science/math/pari { tex = texlive.combined.scheme-basic; };
  gp2c = callPackage ../applications/science/math/pari/gp2c.nix { };
  pari-unstable = callPackage ../applications/science/math/pari/unstable.nix {};

  ratpoints = callPackage ../applications/science/math/ratpoints {};

  calc = callPackage ../applications/science/math/calc { };

  pcalc = callPackage ../applications/science/math/pcalc { };

  pspp = callPackage ../applications/science/math/pssp {
    inherit (gnome2) libglade gtksourceview;
  };

  singular = callPackage ../applications/science/math/singular {};
  libsingular = callPackage ../applications/science/math/singular {
    asLibsingular = true;
  };

  scilab = callPackage ../applications/science/math/scilab {
    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  scilab-bin = callPackage ../applications/science/math/scilab-bin {};

  scotch = callPackage ../applications/science/math/scotch {
    flex = flex_2_5_35;
  };

  msieve = callPackage ../applications/science/math/msieve { };

  weka = callPackage ../applications/science/math/weka { };

  yad = callPackage ../tools/misc/yad { };

  yacas = callPackage ../applications/science/math/yacas { };

  speedcrunch = qt5.callPackage ../applications/science/math/speedcrunch { };

  ### SCIENCE / MISC

  boinc = callPackage ../applications/science/misc/boinc { };

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (pkgs.gnome2) gtkglext;
  };

  cytoscape = callPackage ../applications/science/misc/cytoscape { };

  fityk = callPackage ../applications/science/misc/fityk { };

  gplates = callPackage ../applications/science/misc/gplates { };

  gravit = callPackage ../applications/science/astronomy/gravit { };

  golly = callPackage ../applications/science/misc/golly { };

  megam = callPackage ../applications/science/misc/megam { };

  root = callPackage ../applications/science/misc/root {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };

  simgrid = callPackage ../applications/science/misc/simgrid { };

  spyder = pythonPackages.spyder;

  stellarium = qt5.callPackage ../applications/science/astronomy/stellarium { };

  tulip = callPackage ../applications/science/misc/tulip {
    cmake = cmake_2_8;
  };

  vite = callPackage ../applications/science/misc/vite { };

  xplanet = callPackage ../applications/science/astronomy/xplanet { };

  ### SCIENCE / PHYSICS

  fastjet = callPackage ../development/libraries/physics/fastjet { };

  fastnlo = callPackage ../development/libraries/physics/fastnlo { };

  geant4 = callPackage ../development/libraries/physics/geant4 {
    enableMultiThreading = true;
    enableG3toG4         = false;
    enableInventor       = false;
    enableGDML           = false;
    enableQT             = false;
    enableXM             = false;
    enableOpenGLX11      = true;
    enableRaytracerX11   = false;

    # Optional system packages, otherwise internal GEANT4 packages are used.
    clhep = null;
    zlib  = null;

    # For enableGDML.
    xercesc = null;

    # For enableQT.
    qt = null; # qt4SDK or qt5SDK

    # For enableXM.
    motif = null; # motif or lesstif
  };

  g4py = callPackage ../development/libraries/physics/geant4/g4py { };

  hepmc = callPackage ../development/libraries/physics/hepmc { };

  herwig = callPackage ../development/libraries/physics/herwig { };

  lhapdf = callPackage ../development/libraries/physics/lhapdf { };

  mcgrid = callPackage ../development/libraries/physics/mcgrid { };

  nlojet = callPackage ../development/libraries/physics/nlojet { };

  pythia = callPackage ../development/libraries/physics/pythia { };

  rivet = callPackage ../development/libraries/physics/rivet { };

  thepeg = callPackage ../development/libraries/physics/thepeg { };

  yoda = callPackage ../development/libraries/physics/yoda { };

  ### MISC

  antimicro = qt5.callPackage ../tools/misc/antimicro { };

  atari800 = callPackage ../misc/emulators/atari800 { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  auctex = callPackage ../tools/typesetting/tex/auctex { };

  areca = callPackage ../applications/backup/areca { };

  attract-mode = callPackage ../misc/emulators/attract-mode { };

  beep = callPackage ../misc/beep { };

  blackbird = callPackage ../misc/themes/blackbird { };

  bootil = callPackage ../development/libraries/bootil { };

  brgenml1lpr = callPackage_i686 ../misc/cups/drivers/brgenml1lpr {};

  brgenml1cupswrapper = callPackage ../misc/cups/drivers/brgenml1cupswrapper {};

  cups = callPackage ../misc/cups {
    libusb = libusb1;
  };

  cups-filters = callPackage ../misc/cups/filters.nix { };

  cups-pk-helper = callPackage ../misc/cups/cups-pk-helper.nix { };

  cups-kyocera = callPackage ../misc/cups/drivers/kyocera {};

  cups-dymo = callPackage ../misc/cups/drivers/dymo {};

  crashplan = callPackage ../applications/backup/crashplan { };

  e17gtk = callPackage ../misc/themes/e17gtk { };

  epson-escpr = callPackage ../misc/drivers/epson-escpr { };

  epson_201207w = callPackage ../misc/drivers/epson_201207w { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cups-bjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

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

  ekiga = newScope pkgs.gnome2 ../applications/networking/instant-messengers/ekiga { };

  emulationstation = callPackage ../misc/emulators/emulationstation { };

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  flam3 = callPackage ../tools/graphics/flam3 { };

  glee = callPackage ../tools/graphics/glee { };

  fakenes = callPackage ../misc/emulators/fakenes { };

  faust = self.faust2;

  faust1 = callPackage ../applications/audio/faust/faust1.nix { };

  faust2 = callPackage ../applications/audio/faust/faust2.nix {
    llvm = llvm_38;
  };

  faust2alqt = callPackage ../applications/audio/faust/faust2alqt.nix { };

  faust2alsa = callPackage ../applications/audio/faust/faust2alsa.nix { };

  faust2csound = callPackage ../applications/audio/faust/faust2csound.nix { };

  faust2firefox = callPackage ../applications/audio/faust/faust2firefox.nix { };

  faust2jack = callPackage ../applications/audio/faust/faust2jack.nix { };

  faust2jaqt = callPackage ../applications/audio/faust/faust2jaqt.nix { };

  faust2ladspa = callPackage ../applications/audio/faust/faust2ladspa.nix { };

  faust2lv2 = callPackage ../applications/audio/faust/faust2lv2.nix { };

  fceux = callPackage ../misc/emulators/fceux { };

  flat-plat = callPackage ../misc/themes/flat-plat { };

  foldingathome = callPackage ../misc/foldingathome { };

  foo2zjs = callPackage ../misc/drivers/foo2zjs {};

  foomatic-filters = callPackage ../misc/drivers/foomatic-filters {};

  freestyle = callPackage ../misc/freestyle { };

  gajim = callPackage ../applications/networking/instant-messengers/gajim { };

  gale = callPackage ../applications/networking/instant-messengers/gale { };

  gammu = callPackage ../applications/misc/gammu { };

  gensgs = callPackage_i686 ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript {
    x11Support = false;
    cupsSupport = config.ghostscript.cups or (!stdenv.isDarwin);
  };

  ghostscriptX = appendToName "with-X" (ghostscript.override {
    x11Support = true;
  });

  gnome-breeze = callPackage ../misc/themes/gnome-breeze { };

  gnuk = callPackage ../misc/gnuk {
    gcc-arm-embedded = gcc-arm-embedded-4_9;
  };
  gnuk-unstable = lowPrio (callPackage ../misc/gnuk/unstable.nix {
    gcc-arm-embedded = gcc-arm-embedded-4_9;
  });
  gnuk-git = lowPrio (callPackage ../misc/gnuk/git.nix {
    gcc-arm-embedded = gcc-arm-embedded-4_9;
  });

  greybird = callPackage ../misc/themes/greybird { };

  gxemul = callPackage ../misc/emulators/gxemul { };

  hatari = callPackage ../misc/emulators/hatari { };

  helm = callPackage ../applications/audio/helm { };

  hplip = callPackage ../misc/drivers/hplip { };

  hplipWithPlugin = hplip.override { withPlugin = true; };

  hplip_3_15_9 = callPackage ../misc/drivers/hplip/3.15.9.nix { };

  hplipWithPlugin_3_15_9 = hplip_3_15_9.override { withPlugin = true; };

  illum = callPackage ../tools/system/illum { };

  # using the new configuration style proposal which is unstable
  jack1 = callPackage ../misc/jackaudio/jack1.nix { };

  jack2Full = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
  };
  libjack2 = jack2Full.override { prefix = "lib"; };
  libjack2Unstable = callPackage ../misc/jackaudio/unstable.nix { };

  keynav = callPackage ../tools/X11/keynav { };

  kops = callPackage ../applications/networking/cluster/kops { };

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };

  mailcore2 = callPackage ../development/libraries/mailcore2 { };

  martyr = callPackage ../development/libraries/martyr { };

  mess = callPackage ../misc/emulators/mess {
    inherit (pkgs.gnome2) GConf;
  };

  moltengamepad = callPackage ../misc/drivers/moltengamepad { };

  mongoc = callPackage ../development/libraries/mongoc { };

  mupen64plus = callPackage ../misc/emulators/mupen64plus {
    stdenv = overrideCC stdenv gcc49;
  };

  inherit (callPackages ../tools/package-management/nix {
      storeDir = config.nix.storeDir or "/nix/store";
      stateDir = config.nix.stateDir or "/nix/var";
      })
    nix
    nixStable
    nixUnstable;

  nixops = callPackage ../tools/package-management/nixops { };

  nixopsUnstable = callPackage ../tools/package-management/nixops/unstable.nix { };

  nixui = callPackage ../tools/package-management/nixui { node_webkit = nwjs_0_12; };

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-scripts;

  nix-template-rpm = callPackage ../build-support/templaterpm { inherit (pythonPackages) python toposort; };

  nix-repl = callPackage ../tools/package-management/nix-repl { };

  nix-serve = callPackage ../tools/package-management/nix-serve { };

  nixos-artwork = callPackage ../data/misc/nixos-artwork { };

  nixos-container = callPackage ../tools/virtualization/nixos-container { };

  norwester-font = callPackage ../data/fonts/norwester  {};

  nut = callPackage ../applications/misc/nut { };

  solfege = callPackage ../misc/solfege { };

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

  disnixos = callPackage ../tools/package-management/disnix/disnixos { };

  DisnixWebService = callPackage ../tools/package-management/disnix/DisnixWebService { };

  lkproof = callPackage ../tools/typesetting/tex/lkproof { };

  m33-linux = callPackage ../misc/drivers/m33-linux { };

  mnemonicode = callPackage ../misc/mnemonicode { };

  mysql-workbench = newScope gnome2 ../applications/misc/mysql-workbench (let mysql = mysql57; in {
    automake = automake113x;
    gdal = gdal.override {mysql = mysql // {lib = {dev = mysql;};};};
    mysql = mysql;
    pcre = pcre-cpp;
  });

  redis-desktop-manager = qt55.callPackage ../applications/misc/redis-desktop-manager { };

  robomongo = qt5.callPackage ../applications/misc/robomongo { };

  rucksack = callPackage ../development/tools/rucksack { };

  sam-ba = callPackage ../tools/misc/sam-ba { };

  opkg = callPackage ../tools/package-management/opkg { };

  opkg-utils = callPackage ../tools/package-management/opkg-utils { };

  pgadmin = callPackage ../applications/misc/pgadmin { };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = callPackage ../tools/typesetting/tex/pgf/1.x.nix { };

  pgf2 = callPackage ../tools/typesetting/tex/pgf/2.x.nix { };

  pgf3 = callPackage ../tools/typesetting/tex/pgf/3.x.nix { };

  pgfplots = callPackage ../tools/typesetting/tex/pgfplots { };

  phabricator = callPackage ../misc/phabricator { };

  physlock = callPackage ../misc/screensavers/physlock { };

  pjsip = callPackage ../applications/networking/pjsip { };

  PPSSPP = callPackage ../misc/emulators/ppsspp { SDL = SDL2; };

  pt = callPackage ../applications/misc/pt { };

  pyload = callPackage ../applications/networking/pyload {};

  uae = callPackage ../misc/emulators/uae { };

  fsuae = callPackage ../misc/emulators/fs-uae { };

  putty = callPackage ../applications/networking/remote/putty { };

  redprl = callPackage ../applications/science/logic/redprl { };

  retroarchBare = callPackage ../misc/emulators/retroarch { };

  retroarch = wrapRetroArch { retroarch = retroarchBare; };

  libretro = recurseIntoAttrs (callPackage ../misc/emulators/retroarch/cores.nix {
    retroarch = retroarchBare;
  });

  retrofe = callPackage ../misc/emulators/retrofe { };

  rss-glx = callPackage ../misc/screensavers/rss-glx { };

  runit = callPackage ../tools/system/runit { };

  refind = callPackage ../tools/bootloaders/refind { };

  spectrojack = callPackage ../applications/audio/spectrojack { };

  sift = callPackage ../tools/text/sift { };

  xlockmore = callPackage ../misc/screensavers/xlockmore { };

  xtrlock-pam = callPackage ../misc/screensavers/xtrlock-pam { };

  sailsd = callPackage ../misc/sailsd { };

  shc = callPackage ../tools/security/shc { };

  canon-cups-ufr2 = callPackage ../misc/cups/drivers/canon { };

  mfcj470dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj470dwcupswrapper { };
  mfcj470dwlpr = callPackage_i686 ../misc/cups/drivers/mfcj470dwlpr { };

  mfcj6510dw-cupswrapper = callPackage ../misc/cups/drivers/mfcj6510dwcupswrapper { };
  mfcj6510dwlpr = callPackage_i686 ../misc/cups/drivers/mfcj6510dwlpr { };

  samsung-unified-linux-driver_1_00_37 = callPackage ../misc/cups/drivers/samsung { };
  samsung-unified-linux-driver_4_01_17 = callPackage ../misc/cups/drivers/samsung/4.01.17.nix { };
  samsung-unified-linux-driver = callPackage ../misc/cups/drivers/samsung/4.00.39 { };

  sane-backends = callPackage ../applications/graphics/sane/backends {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
  };

  sane-backends-git = callPackage ../applications/graphics/sane/backends/git.nix {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
  };

  brscan4 = callPackage ../applications/graphics/sane/backends/brscan4 { };

  mkSaneConfig = callPackage ../applications/graphics/sane/config.nix { };

  sane-frontends = callPackage ../applications/graphics/sane/frontends.nix { };

  sct = callPackage ../tools/X11/sct {};

  seafile-shared = callPackage ../misc/seafile-shared { };

  slock = callPackage ../misc/screensavers/slock { };

  smokeping = callPackage ../tools/networking/smokeping {
    inherit fping rrdtool;
    inherit (perlPackages)
      FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet
      NetOpenSSH NetSNMP LWP IOTty perl NetDNS NetLDAP;
  };

  snapraid = callPackage ../tools/filesystems/snapraid { };

  soundOfSorting = callPackage ../misc/sound-of-sorting { };

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  splix = callPackage ../misc/cups/drivers/splix { };

  streamripper = callPackage ../applications/audio/streamripper { };

  sqsh = callPackage ../development/tools/sqsh { };

  terraform = callPackage ../applications/networking/cluster/terraform {};

  terragrunt = callPackage ../applications/networking/cluster/terragrunt {};

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  tewi-font = callPackage ../data/fonts/tewi  {};

  tex4ht = callPackage ../tools/typesetting/tex/tex4ht { tetex = ""; };

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # TeX Live; see http://nixos.org/nixpkgs/manual/#sec-language-texlive
  texlive = recurseIntoAttrs
    (callPackage ../tools/typesetting/tex/texlive { });

  ib-tws = callPackage ../applications/office/ib/tws { jdk=oraclejdk8; };

  ib-controller = callPackage ../applications/office/ib/controller { jdk=oraclejdk8; };

  thermald = callPackage ../tools/system/thermald { };

  thinkfan = callPackage ../tools/system/thinkfan { };

  tup = callPackage ../development/tools/build-managers/tup { };

  tvheadend = callPackage ../servers/tvheadend { };

  ums = callPackage ../servers/ums { };

  unity3d = callPackage ../development/tools/unity3d {
    stdenv = stdenv_32bit;
    gcc_32bit = pkgsi686Linux.gcc;
    inherit (gnome2) GConf libgnomeui gnome_vfs;
  };

  urbit = callPackage ../misc/urbit { };

  utf8proc = callPackage ../development/libraries/utf8proc { };

  valauncher = callPackage ../applications/misc/valauncher { };

  vault = callPackage ../tools/security/vault { };

  vbam = callPackage ../misc/emulators/vbam {
    ffmpeg = ffmpeg_2;
  };

  vice = callPackage ../misc/emulators/vice {
    libX11 = xorg.libX11;
    giflib = giflib_4_1;
  };

  viewnior = callPackage ../applications/graphics/viewnior { };

  vimUtils = callPackage ../misc/vim-plugins/vim-utils.nix { };

  vimPlugins = recurseIntoAttrs (callPackage ../misc/vim-plugins {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
    llvmPackages = llvmPackages_39;
  });

  vimprobable2-unwrapped = callPackage ../applications/networking/browsers/vimprobable2 {
    webkit = webkitgtk2;
  };
  vimprobable2 = wrapFirefox vimprobable2-unwrapped { };

  inherit (kde4) rekonq;

  vimb-unwrapped = callPackage ../applications/networking/browsers/vimb {
    webkit = webkitgtk2;
  };
  vimb = wrapFirefox vimb-unwrapped { };

  vips = callPackage ../tools/graphics/vips { };
  nip2 = callPackage ../tools/graphics/nip2 { };

  vokoscreen = qt5.callPackage ../applications/video/vokoscreen { };

  wavegain = callPackage ../applications/audio/wavegain { };

  wcalc = callPackage ../applications/misc/wcalc { };

  webfs = callPackage ../servers/http/webfs { };

  wikicurses = callPackage ../applications/misc/wikicurses {
    pythonPackages = python3Packages;
  };

  wineMinimal = callPackage ../misc/emulators/wine {
    wineRelease = config.wine.release or "stable";
    wineBuild = config.wine.build or "wine32";
  };
  wine = lowPrio (self.wineMinimal.override {
    pngSupport = true;
    jpegSupport = true;
    tiffSupport = true;
    gettextSupport = true;
    fontconfigSupport = true;
    alsaSupport = true;
    openglSupport = true;
    tlsSupport = true;
    cupsSupport = true;
    colorManagementSupport = true;
    dbusSupport = true;
    mpg123Support = true;
    openalSupport = true;
    cairoSupport = true;
    cursesSupport = true;
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
    xineramaSupport = true;
    xmlSupport = true;
  });
  wineFull = lowPrio (self.wine.override {
    gtkSupport = true;
    gstreamerSupport = true;
    openclSupport = true;
    odbcSupport = true;
    netapiSupport = true;
    vaSupport = true;
    pcapSupport = true;
    v4lSupport = true;
    saneSupport = true;
    gsmSupport = true;
    gphoto2Support = true;
    ldapSupport = true;
    pulseaudioSupport = true;
  });
  wineStable = self.wine.override { wineRelease = "stable"; };
  wineUnstable = lowPrio (self.wine.override { wineRelease = "unstable"; });
  wineStaging = lowPrio (self.wine.override { wineRelease = "staging"; });

  winetricks = callPackage ../misc/emulators/wine/winetricks.nix {
    inherit (gnome2) zenity;
  };

  with-shell = callPackage ../applications/misc/with-shell { };

  wmutils-core = callPackage ../tools/X11/wmutils-core { };

  wmutils-opt = callPackage ../tools/X11/wmutils-opt { };

  wraith = callPackage ../applications/networking/irc/wraith { };

  wxmupen64plus = callPackage ../misc/emulators/wxmupen64plus { };

  wxsqlite3 = callPackage ../development/libraries/wxsqlite3 {
    wxGTK = wxGTK30;
  };

  wxsqliteplus = callPackage ../development/libraries/wxsqliteplus {
    wxGTK = wxGTK30;
  };

  x2x = callPackage ../tools/X11/x2x { };

  xboxdrv = callPackage ../misc/drivers/xboxdrv { };

  xcftools = callPackage ../tools/graphics/xcftools { };

  xhyve = callPackage ../applications/virtualization/xhyve { };

  xinput_calibrator = callPackage ../tools/X11/xinput_calibrator { };

  xmagnify = callPackage ../tools/X11/xmagnify { };

  xosd = callPackage ../misc/xosd { };

  xsane = callPackage ../applications/graphics/sane/xsane.nix {
    libpng = libpng12;
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

  yabause = callPackage ../misc/emulators/yabause {
    qt = qt4;
  };

  yadm = callPackage ../applications/version-management/yadm { };

  yamdi = callPackage ../tools/video/yamdi { };

  yandex-disk = callPackage ../tools/filesystems/yandex-disk { };

  yara = callPackage ../tools/security/yara { };

  zap = callPackage ../tools/networking/zap { };

  zdfmediathk = callPackage ../applications/video/zdfmediathk { };

  zopfli = callPackage ../tools/compression/zopfli { };

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  zsnes = callPackage_i686 ../misc/emulators/zsnes { };

  snes9x-gtk = callPackage ../misc/emulators/snes9x-gtk { };

  higan = callPackage ../misc/emulators/higan {
    inherit (gnome2) gtksourceview;
  };

  misc = callPackage ../misc/misc.nix { };

  bullet = callPackage ../development/libraries/bullet {};
  bullet283 = callPackage ../development/libraries/bullet/bullet283.nix {};

  spdlog = callPackage ../development/libraries/spdlog { };

  dart = callPackage ../development/interpreters/dart { };

  httrack = callPackage ../tools/backup/httrack { };

  mg = callPackage ../applications/editors/mg { };

  aucdtect = callPackage ../tools/audio/aucdtect { };

  togglesg-download = callPackage ../tools/misc/togglesg-download { };

  discord = callPackage ../applications/networking/instant-messengers/discord { };

  golden-cheetah = qt5.callPackage ../applications/misc/golden-cheetah {};

  linkchecker = callPackage ../tools/networking/linkchecker { };

  tomb = callPackage ../os-specific/linux/tomb {};

  tomboy = callPackage ../applications/misc/tomboy {};

  imatix_gsl = callPackage ../development/tools/imatix_gsl {};

  iterm2 = callPackage ../applications/misc/iterm2 {};

  sequelpro = callPackage ../applications/misc/sequelpro {};

  maphosts = callPackage ../tools/networking/maphosts {};

  zimg = callPackage ../development/libraries/zimg { };

  zk-shell = callPackage ../applications/misc/zk-shell { };

  zuki-themes = callPackage ../misc/themes/zuki { };

  zoom-us = qt55.callPackage ../applications/networking/instant-messengers/zoom-us {};

  tora = qt5.callPackage ../development/tools/tora {};

  xulrunner = firefox-unwrapped;

  nitrokey-app = callPackage ../tools/security/nitrokey-app { };

  fpm2 = callPackage ../tools/security/fpm2 { };

  simplenote = callPackage ../applications/misc/simplenote { };

  hy = callPackage ../development/interpreters/hy {};

  ghc-standalone-archive = callPackage ../os-specific/darwin/ghc-standalone-archive { inherit (darwin) cctools; };
}
