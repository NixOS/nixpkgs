{ system, bootStdenv, noSysDirs, gccWithCC, gccWithProfiling
, config, crossSystem, platform, lib
, pkgsWithOverrides
, ... }:
self: pkgs:

with pkgs;

let
  defaultScope = pkgs // pkgs.xorg;
in

{

  # Make some arguments passed to all-packages.nix available
  inherit system platform;

  # Allow callPackage to fill in the pkgs argument
  inherit pkgs;


  # We use `callPackage' to be able to omit function arguments that
  # can be obtained from `pkgs' or `pkgs.xorg' (i.e. `defaultScope').
  # Use `newScope' for sets of packages in `pkgs' (see e.g. `gnome'
  # below).
  callPackage = newScope {};

  callPackages = lib.callPackagesWith defaultScope;

  newScope = extra: lib.callPackageWith (defaultScope // extra);

  # Easily override this package set.
  # Warning: this function is very expensive and must not be used
  # from within the nixpkgs repository.
  #
  # Example:
  #  pkgs.overridePackages (self: super: {
  #    foo = super.foo.override { ... };
  #  }
  #
  # The result is `pkgs' where all the derivations depending on `foo'
  # will use the new version.
  overridePackages = f: pkgsWithOverrides f;

  # Override system. This is useful to build i686 packages on x86_64-linux.
  forceSystem = system: kernel: (import ./../..) {
    inherit system;
    platform = platform // { kernelArch = kernel; };
    inherit bootStdenv noSysDirs gccWithCC gccWithProfiling config
      crossSystem;
  };

  # Used by wine, firefox with debugging version of Flash, ...
  pkgsi686Linux = forceSystem "i686-linux" "i386";

  callPackage_i686 = lib.callPackageWith (pkgsi686Linux // pkgsi686Linux.xorg);

  forceNativeDrv = drv : if crossSystem == null then drv else
    (drv // { crossDrv = drv.nativeDrv; });

  stdenvCross = lowPrio (makeStdenvCross defaultStdenv crossSystem binutilsCross gccCrossStageFinal);

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (
    if system == "x86_64-linux" then
      overrideCC stdenv gcc_multi
    else
      stdenv);

  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Helper functions.
  inherit lib config;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;
  inherit (misc) versionedDerivation;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  builderDefs = lib.composedArgsAndFun (callPackage ../build-support/builder-defs/builder-defs.nix) {};

  builderDefsPackage = builderDefs.builderDefsPackage builderDefs;

  stringsWithDeps = lib.stringsWithDeps;


  ### Nixpkgs maintainer tools

  nix-generate-from-cpan = callPackage ../../maintainers/scripts/nix-generate-from-cpan.nix { };

  nixpkgs-lint = callPackage ../../maintainers/scripts/nixpkgs-lint.nix { };


  ### BUILD SUPPORT

  attrSetToDir = arg: callPackage ../build-support/upstream-updater/attrset-to-dir.nix {
    theAttrSet = arg;
  };

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

  buildEnv = callPackage ../build-support/buildenv { }; # not actually a package

  buildFHSEnv = callPackage ../build-support/build-fhs-chrootenv/env.nix {
    nixpkgs      = pkgs;
    nixpkgs_i686 = pkgsi686Linux;
  };

  chrootFHSEnv = callPackage ../build-support/build-fhs-chrootenv { };
  userFHSEnv = callPackage ../build-support/build-fhs-userenv {
   ruby = ruby_2_1;
  };

  buildFHSChrootEnv = args: chrootFHSEnv {
    env = buildFHSEnv (removeAttrs args [ "extraInstallCommands" ]);
    extraInstallCommands = args.extraInstallCommands or "";
  };

  buildFHSUserEnv = args: userFHSEnv {
    env = buildFHSEnv (removeAttrs args [ "runScript" "extraBindMounts" "extraInstallCommands" "meta" "passthru" ]);
    runScript = args.runScript or "bash";
    extraBindMounts = args.extraBindMounts or [];
    extraInstallCommands = args.extraInstallCommands or "";
    meta = args.meta or {};
    passthru = args.passthru or {};
  };

  buildMaven = callPackage ../build-support/build-maven.nix {};

  cmark = callPackage ../development/libraries/cmark { };

  dockerTools = callPackage ../build-support/docker { };

  dotnetenv = callPackage ../build-support/dotnetenv {
    dotnetfx = dotnetfx40;
  };

  dotnetbuildhelpers = callPackage ../build-support/dotnetbuildhelpers { };

  dispad = callPackage ../tools/X11/dispad { };

  scatterOutputHook = makeSetupHook {} ../build-support/setup-hooks/scatter_output.sh;

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

  fetchgit = callPackage ../build-support/fetchgit {
    git = gitMinimal;
  };

  fetchgitPrivate = callPackage ../build-support/fetchgit/private.nix { };

  fetchgitrevision = import ../build-support/fetchgitrevision runCommand git;

  fetchgitLocal = callPackage ../build-support/fetchgitlocal { };

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

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

  fetchFromGitHub = { owner, repo, rev, sha256, name ? "${repo}-${rev}-src" }: fetchzip {
    inherit name sha256;
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    meta.homepage = "https://github.com/${owner}/${repo}/";
  } // { inherit rev; };

  fetchFromBitbucket = { owner, repo, rev, sha256, name ? "${repo}-${rev}-src" }: fetchzip {
    inherit name sha256;
    url = "https://bitbucket.org/${owner}/${repo}/get/${rev}.tar.gz";
    meta.homepage = "https://bitbucket.org/${owner}/${repo}/";
    extraPostFetch = ''rm -f "$out"/.hg_archival.txt''; # impure file; see #12002
  };

  # cgit example, snapshot support is optional in cgit
  fetchFromSavannah = { repo, rev, sha256, name ? "${repo}-${rev}-src" }: fetchzip {
    inherit name sha256;
    url = "http://git.savannah.gnu.org/cgit/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
    meta.homepage = "http://git.savannah.gnu.org/cgit/${repo}.git/";
  };

  # gitlab example
  fetchFromGitLab = { owner, repo, rev, sha256, name ? "${repo}-${rev}-src" }: fetchzip {
    inherit name sha256;
    url = "https://gitlab.com/${owner}/${repo}/repository/archive.tar.gz?ref=${rev}";
    meta.homepage = "https://gitlab.com/${owner}/${repo}/";
  };

  # gitweb example, snapshot support is optional in gitweb
  fetchFromRepoOrCz = { repo, rev, sha256, name ? "${repo}-${rev}-src" }: fetchzip {
    inherit name sha256;
    url = "http://repo.or.cz/${repo}.git/snapshot/${rev}.tar.gz";
    meta.homepage = "http://repo.or.cz/${repo}.git/";
  };

  fetchNuGet = callPackage ../build-support/fetchnuget { };
  buildDotnetPackage = callPackage ../build-support/build-dotnet-package { };

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

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

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

  aha = callPackage ../tools/text/aha { };

  ahcpd = callPackage ../tools/networking/ahcpd { };

  aiccu = callPackage ../tools/networking/aiccu { };

  aide = callPackage ../tools/security/aide { };

  aircrack-ng = callPackage ../tools/networking/aircrack-ng { };

  airfield = callPackage ../tools/networking/airfield { };

  aj-snapshot  = callPackage ../applications/audio/aj-snapshot { };

  albert = qt5.callPackage ../applications/misc/albert {};

  amtterm = callPackage ../tools/system/amtterm {};

  analog = callPackage ../tools/admin/analog {};

  ansifilter = callPackage ../tools/text/ansifilter {};

  apktool = callPackage ../development/tools/apktool {
    buildTools = androidenv.buildTools;
  };

  apt-cacher-ng = callPackage ../servers/http/apt-cacher-ng { };

  apt-offline = callPackage ../tools/misc/apt-offline { };

  apulse = callPackage ../misc/apulse { };

  archivemount = callPackage ../tools/filesystems/archivemount { };

  arandr = callPackage ../tools/X11/arandr { };

  arangodb = callPackage ../servers/nosql/arangodb {
    inherit (pythonPackages) gyp;
  };

  arcanist = callPackage ../development/tools/misc/arcanist {};

  arduino = self.arduino-core.override { withGui = true; };

  arduino-core = callPackage ../development/arduino/arduino-core {
    jdk = jdk;
    jre = jdk;
    withGui = false;
  };

  apitrace = qt5.callPackage ../applications/graphics/apitrace {};

  argyllcms = callPackage ../tools/graphics/argyllcms {};

  arp-scan = callPackage ../tools/misc/arp-scan { };

  artyFX = callPackage ../applications/audio/artyFX {};

  as31 = callPackage ../development/compilers/as31 {};

  ascii = callPackage ../tools/text/ascii { };

  asciinema = goPackages.asciinema.bin // { outputs = [ "bin" ]; };

  asymptote = callPackage ../tools/graphics/asymptote {
    texLive = texlive.combine { inherit (texlive) scheme-small epsf cm-super; };
    gsl = gsl_1;
  };

  atomicparsley = callPackage ../tools/video/atomicparsley { };

  attic = callPackage ../tools/backup/attic { };

  avfs = callPackage ../tools/filesystems/avfs { };

  awscli = pythonPackages.awscli;

  aws_shell = pythonPackages.aws_shell;

  azure-cli = callPackage ../tools/virtualization/azure-cli { };

  ec2_api_tools = callPackage ../tools/virtualization/ec2-api-tools { };

  ec2_ami_tools = callPackage ../tools/virtualization/ec2-ami-tools { };

  altermime = callPackage ../tools/networking/altermime {};

  amule = callPackage ../tools/networking/p2p/amule { };

  amuleDaemon = appendToName "daemon" (self.amule.override {
    monolithic = false;
    daemon = true;
  });

  amuleGui = appendToName "gui" (self.amule.override {
    monolithic = false;
    client = true;
  });

  androidenv = callPackage ../development/mobile/androidenv {
    pkgs_i686 = pkgsi686Linux;
  };

  apg = callPackage ../tools/security/apg { };

  bonnie = callPackage ../tools/filesystems/bonnie { };

  djmount = callPackage ../tools/filesystems/djmount { };

  grc = callPackage ../tools/misc/grc { };

  lastpass-cli = callPackage ../tools/security/lastpass-cli { };

  pass = callPackage ../tools/security/pass { };

  oracle-instantclient = callPackage ../development/libraries/oracle-instantclient { };

  reattach-to-user-namespace = callPackage ../os-specific/darwin/reattach-to-user-namespace {};

  install_name_tool = callPackage ../os-specific/darwin/install_name_tool { };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  titaniumenv = callPackage ../development/mobile/titaniumenv {
    pkgs_i686 = pkgsi686Linux;
  };

  inherit (self.androidenv) androidsdk_4_4 androidndk;

  androidsdk = self.androidenv.androidsdk_6_0;

  arc-gtk-theme = callPackage ../misc/themes/arc { };

  aria2 = callPackage ../tools/networking/aria2 {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  aria = self.aria2;

  at = callPackage ../tools/system/at { };

  atftp = callPackage ../tools/networking/atftp {
    gcc = gcc49;
  };

  autogen = callPackage ../development/tools/misc/autogen { };

  autojump = callPackage ../tools/misc/autojump { };

  autorandr = callPackage ../tools/misc/autorandr {};

  avahi = callPackage ../development/libraries/avahi {
    qt4Support = config.avahi.qt4Support or false;
  };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  awstats = callPackage ../tools/system/awstats { };

  axel = callPackage ../tools/networking/axel { };

  azureus = callPackage ../tools/networking/p2p/azureus { };

  backblaze-b2 = callPackage ../development/tools/backblaze-b2 { };

  backup = callPackage ../tools/backup/backup { };

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

  bindfs = callPackage ../tools/filesystems/bindfs { };

  binwalk = callPackage ../tools/misc/binwalk {
    python = pythonFull;
    wrapPython = pythonPackages.wrapPython;
    curses = pythonPackages.curses;
  };

  binwalk-full = callPackage ../tools/misc/binwalk {
    python = pythonFull;
    wrapPython = pythonPackages.wrapPython;
    curses = pythonPackages.curses;
    visualizationSupport = true;
    pyqtgraph = pythonPackages.pyqtgraph;
  };

  bitbucket-cli = pythonPackages.bitbucket-cli;

  blink = callPackage ../applications/networking/instant-messengers/blink {
    gnutls = gnutls33;
  };

  blitz = callPackage ../development/libraries/blitz { };

  blockdiag = pythonPackages.blockdiag;

  bluez-tools = callPackage ../tools/bluetooth/bluez-tools { };

  bmon = callPackage ../tools/misc/bmon { };

  bochs = callPackage ../applications/virtualization/bochs { };

  borgbackup = callPackage ../tools/backup/borg { };

  boomerang = callPackage ../development/tools/boomerang { };

  boost-build = callPackage ../development/tools/boost-build { };

  boot = callPackage ../development/tools/build-managers/boot { };

  bootchart = callPackage ../tools/system/bootchart { };

  boxfs = callPackage ../tools/filesystems/boxfs { };

  brasero = callPackage ../tools/cd-dvd/brasero { };

  brltty = callPackage ../tools/misc/brltty {
    alsaSupport = (!stdenv.isDarwin);
  };
  bro = callPackage ../applications/networking/ids/bro { };

  bruteforce-luks = callPackage ../tools/security/bruteforce-luks { };

  bsod = callPackage ../misc/emulators/bsod { };

  btrfs-progs = callPackage ../tools/filesystems/btrfs-progs { };
  btrfs-progs_4_4_1 = callPackage ../tools/filesystems/btrfs-progs/4.4.1.nix { };

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

  cabal2nix = self.haskellPackages.cabal2nix;

  caddy = goPackages.caddy.bin // { outputs = [ "bin" ]; };

  capstone = callPackage ../development/libraries/capstone { };

  catch = callPackage ../development/libraries/catch { };

  catdoc = callPackage ../tools/text/catdoc { };

  cdemu-daemon = callPackage ../misc/emulators/cdemu/daemon.nix { };

  cdemu-client = callPackage ../misc/emulators/cdemu/client.nix { };

  ceres-solver = callPackage ../development/libraries/ceres-solver {
    google-gflags = null; # only required for examples/tests
  };

  gcdemu = callPackage ../misc/emulators/cdemu/gui.nix { };

  certificate-transparency = callPackage ../servers/certificate-transparency { };

  image-analyzer = callPackage ../misc/emulators/cdemu/analyzer.nix { };

  ccnet = callPackage ../tools/networking/ccnet { };

  cfdyndns = callPackage ../applications/networking/dyndns/cfdyndns { };

  ckbcomp = callPackage ../tools/X11/ckbcomp { };

  cli53 = callPackage ../tools/admin/cli53 { };

  cli-visualizer = callPackage ../applications/misc/cli-visualizer { };

  cloud-init = callPackage ../tools/virtualization/cloud-init { };

  clib = callPackage ../tools/package-management/clib { };

  consul = goPackages.consul.bin // { outputs = [ "bin" ]; };

  consul-ui = callPackage ../servers/consul/ui.nix { };

  consul-alerts = goPackages.consul-alerts.bin // { outputs = [ "bin" ]; };

  consul-template = goPackages.consul-template.bin // { outputs = [ "bin" ]; };

  corosync = callPackage ../servers/corosync { };

  cherrytree = callPackage ../applications/misc/cherrytree { };

  chntpw = callPackage ../tools/security/chntpw { };

  coprthr = callPackage ../development/libraries/coprthr {
    flex = flex_2_5_35;
  };

  cpulimit = callPackage ../tools/misc/cpulimit { };

  contacts = callPackage ../tools/misc/contacts { };

  datamash = callPackage ../tools/misc/datamash { };

  ddate = callPackage ../tools/misc/ddate { };

  deis = goPackages.deis.bin // { outputs = [ "bin" ]; };

  dfilemanager = self.kde5.dfilemanager;

  diagrams-builder = callPackage ../tools/graphics/diagrams-builder {
    inherit (haskellPackages) ghcWithPackages diagrams-builder;
  };

  dialog = callPackage ../development/tools/misc/dialog { };

  ding = callPackage ../applications/misc/ding {
    aspellDicts_de = aspellDicts.de;
    aspellDicts_en = aspellDicts.en;
  };

  direnv = callPackage ../tools/misc/direnv { };

  discount = callPackage ../tools/text/discount { };

  disorderfs = callPackage ../tools/filesystems/disorderfs {
    asciidoc = asciidoc-full;
  };

  ditaa = callPackage ../tools/graphics/ditaa { };

  dlx = callPackage ../misc/emulators/dlx { };

  dosage = pythonPackages.dosage;

  dpic = callPackage ../tools/graphics/dpic { };

  dragon-drop = callPackage ../tools/X11/dragon-drop {
    gtk = gtk3;
  };

  dtrx = callPackage ../tools/compression/dtrx { };

  duperemove = callPackage ../tools/filesystems/duperemove {
    linuxHeaders = linuxHeaders_3_18;
  };

  dynamic-colors = callPackage ../tools/misc/dynamic-colors { };

  edac-utils = callPackage ../os-specific/linux/edac-utils { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  elementary-icon-theme = callPackage ../data/icons/elementary-icon-theme { };

  enca = callPackage ../tools/text/enca { };

  ent = callPackage ../tools/misc/ent { };

  facter = callPackage ../tools/system/facter {};

  fasd = callPackage ../tools/misc/fasd { };

  fastJson = callPackage ../development/libraries/fastjson { };

  fop = callPackage ../tools/typesetting/fop { };

  fzf = goPackages.fzf.bin // { outputs = [ "bin" ]; };

  gencfsm = callPackage ../tools/security/gencfsm { };

  genromfs = callPackage ../tools/filesystems/genromfs { };

  gist = callPackage ../tools/text/gist { };

  gmic = callPackage ../tools/graphics/gmic { };

  gti = callPackage ../tools/misc/gti { };

  heatseeker = callPackage ../tools/misc/heatseeker { };

  interlock = goPackages.interlock.bin // { outputs = [ "bin" ]; };

  mathics = pythonPackages.mathics;

  mcrl = callPackage ../tools/misc/mcrl { };

  mcrl2 = callPackage ../tools/misc/mcrl2 { };

  meson = callPackage ../development/tools/build-managers/meson { };

  mp3fs = callPackage ../tools/filesystems/mp3fs { };

  mpdcron = callPackage ../tools/audio/mpdcron { };

  mpdris2 = callPackage ../tools/audio/mpdris2 {
    python = pythonFull;
    wrapPython = pythonPackages.wrapPython;
    mpd = pythonPackages.mpd;
    pygtk = pythonPackages.pygtk;
    dbus = pythonPackages.dbus;
    pynotify = pythonPackages.notify;
  };

  playerctl = callPackage ../tools/audio/playerctl { };

  syscall_limiter = callPackage ../os-specific/linux/syscall_limiter {};

  syslogng = callPackage ../tools/system/syslog-ng { };

  syslogng_incubator = callPackage ../tools/system/syslog-ng-incubator { };

  rsyslog = callPackage ../tools/system/rsyslog {
    hadoop = null; # Currently Broken
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

  mongodb-tools = goPackages.mongo-tools.bin // { outputs = [ "bin" ]; };

  mstflint = callPackage ../tools/misc/mstflint { };

  mcelog = callPackage ../os-specific/linux/mcelog { };

  apparix = callPackage ../tools/misc/apparix { };

  appdata-tools = callPackage ../tools/misc/appdata-tools { };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (pythonPackages) matplotlib numpy aafigure recursivePthLoader;
    w3m = w3m-batch;
    enableStandardFeatures = false;
  };

  asciidoc-full = appendToName "full" (self.asciidoc.override {
    inherit (pythonPackages) pygments;
    enableStandardFeatures = true;
  });

  asciidoc-full-with-plugins = appendToName "full-with-plugins" (self.asciidoc.override {
    inherit (pythonPackages) pygments;
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  });

  autossh = callPackage ../tools/networking/autossh { };

  asynk = callPackage ../tools/networking/asynk { };

  bacula = callPackage ../tools/backup/bacula { };

  bareos = callPackage ../tools/backup/bareos { };

  bats = callPackage ../development/interpreters/bats { };

  beanstalkd = callPackage ../servers/beanstalkd { };

  beets = callPackage ../tools/audio/beets { };

  bgs = callPackage ../tools/X11/bgs { };

  biber = callPackage ../tools/typesetting/biber {
    inherit (perlPackages)
      autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
      DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
      ExtUtilsLibBuilder FileSlurp IPCRun3 Log4Perl LWPProtocolHttps ListAllUtils
      ListMoreUtils ModuleBuild MozillaCA ReadonlyXS RegexpCommon TextBibTeX
      UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter;
  };

  bibtextools = callPackage ../tools/typesetting/bibtex-tools {
    inherit (strategoPackages016) strategoxt sdf;
  };

  bittornado = callPackage ../tools/networking/p2p/bit-tornado { };

  blueman = callPackage ../tools/bluetooth/blueman {
    inherit (gnome3) dconf gsettings_desktop_schemas;
    withPulseAudio = config.pulseaudio or true;
  };

  bmrsa = callPackage ../tools/security/bmrsa/11.nix { };

  bogofilter = callPackage ../tools/misc/bogofilter { };

  bsdiff = callPackage ../tools/compression/bsdiff { };

  btar = callPackage ../tools/backup/btar {
    librsync = librsync_0_9;
  };

  bud = callPackage ../tools/networking/bud {
    inherit (pythonPackages) gyp;
  };

  bup = callPackage ../tools/backup/bup {
    inherit (pythonPackages) pyxattr pylibacl setuptools fuse;
    par2Support = (config.bup.par2Support or false);
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

  cantata = qt5.callPackage ../applications/audio/cantata { };

  can-utils = callPackage ../os-specific/linux/can-utils { };

  caudec = callPackage ../applications/audio/caudec { };

  ccid = callPackage ../tools/security/ccid { };

  ccrypt = callPackage ../tools/security/ccrypt { };

  ccze = callPackage ../tools/misc/ccze { };

  cdecl = callPackage ../development/tools/cdecl { };

  cdrdao = callPackage ../tools/cd-dvd/cdrdao { };

  cdrkit = callPackage ../tools/cd-dvd/cdrkit { };

  libceph = self.ceph.lib;
  ceph = callPackage ../tools/filesystems/ceph { boost = boost159; };
  ceph-dev = self.ceph;
  #ceph-dev = lowPrio (callPackage ../tools/filesystems/ceph/dev.nix { });

  cfdg = callPackage ../tools/graphics/cfdg { };

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

  clementineFree = self.clementine.free;

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

  connmanui = callPackage ../tools/networking/connmanui { };

  connman_dmenu = callPackage ../tools/networking/connman_dmenu  { };

  convertlit = callPackage ../tools/text/convertlit { };

  collectd = callPackage ../tools/system/collectd {
    rabbitmq-c = rabbitmq-c_0_4;
    libmysql = mysql.lib;
  };

  colormake = callPackage ../development/tools/build-managers/colormake { };

  cowsay = callPackage ../tools/misc/cowsay { };

  cpuminer = callPackage ../tools/misc/cpuminer { };

  cpuminer-multi = callPackage ../tools/misc/cpuminer-multi { };

  cuetools = callPackage ../tools/cd-dvd/cuetools { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  "unionfs-fuse" = callPackage ../tools/filesystems/unionfs-fuse { };

  usb_modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };

  anthy = callPackage ../tools/inputmethods/anthy { };

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

  };

  ibus-with-plugins = callPackage ../tools/inputmethods/ibus/wrapper.nix {
    inherit (gnome3) dconf;
    plugins = [ ];
  };

  brotli = callPackage ../tools/compression/brotli { };

  brotliUnstable = callPackage ../tools/compression/brotli/unstable.nix { };

  libbrotli = callPackage ../development/libraries/libbrotli { };

  biosdevname = callPackage ../tools/networking/biosdevname { };

  checkbashism = callPackage ../development/tools/misc/checkbashisms { };

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

  compass = callPackage ../development/tools/compass { };

  convmv = callPackage ../tools/misc/convmv { };

  cool-retro-term = qt5.callPackage ../applications/misc/cool-retro-term { };

  coreutils = callPackage ../tools/misc/coreutils {
    aclSupport = stdenv.isLinux;
  };

  coreutils-prefixed = coreutils.override { withPrefix = true; };

  corkscrew = callPackage ../tools/networking/corkscrew { };

  cpio = callPackage ../tools/archivers/cpio { };

  crackxls = callPackage ../tools/security/crackxls { };

  cromfs = callPackage ../tools/archivers/cromfs { };

  cron = callPackage ../tools/system/cron { };

  inherit (callPackages ../development/compilers/cudatoolkit { })
    cudatoolkit5
    cudatoolkit6
    cudatoolkit65
    cudatoolkit7
    cudatoolkit75;

  cudatoolkit = self.cudatoolkit7;

  curlFull = self.curl.override {
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

  curl3 = callPackage ../tools/networking/curl/7.15.nix rec {
    zlibSupport = true;
    sslSupport = zlibSupport;
  };

  curl_unix_socket = callPackage ../tools/networking/curl-unix-socket rec { };

  cunit = callPackage ../tools/misc/cunit { };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  cutter = callPackage ../tools/networking/cutter { };

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

  deluge = pythonPackages.deluge;

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
    rpm = rpm.override { python = python3; };
  };

  diffstat = callPackage ../tools/text/diffstat { };

  diffutils = callPackage ../tools/text/diffutils { };

  dir2opus = callPackage ../tools/audio/dir2opus {
    inherit (pythonPackages) mutagen python wrapPython;
  };

  wgetpaste = callPackage ../tools/text/wgetpaste { };

  dirmngr = callPackage ../tools/security/dirmngr { };

  disper = callPackage ../tools/misc/disper { };

  dmd = callPackage ../development/compilers/dmd { };

  dmg2img = callPackage ../tools/misc/dmg2img { };

  docbook2odf = callPackage ../tools/typesetting/docbook2odf {
    inherit (perlPackages) PerlMagick;
  };

  docbook2x = callPackage ../tools/typesetting/docbook2x {
    inherit (perlPackages) XMLSAX XMLParser XMLNamespaceSupport;
  };

  dog = callPackage ../tools/system/dog { };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dolphinEmu = callPackage ../misc/emulators/dolphin-emu { };
  dolphinEmuMaster = callPackage ../misc/emulators/dolphin-emu/master.nix { };

  doomseeker = callPackage ../applications/misc/doomseeker { };

  drive = self.go14Packages.drive.bin // { outputs = [ "bin" ]; };

  driftnet = callPackage ../tools/networking/driftnet {};

  dropbear = callPackage ../tools/networking/dropbear { };

  dtach = callPackage ../tools/misc/dtach { };

  dtc = callPackage ../development/compilers/dtc { };

  dub = callPackage ../development/tools/build-managers/dub { };

  duc = callPackage ../tools/misc/duc { };

  duff = callPackage ../tools/filesystems/duff { };

  dumptorrent = callPackage ../tools/misc/dumptorrent { };

  duo-unix = callPackage ../tools/security/duo-unix { };

  duplicity = callPackage ../tools/backup/duplicity {
    inherit (pythonPackages) boto lockfile paramiko ecdsa pycrypto;
    gnupg = gnupg1;
  };

  duply = callPackage ../tools/backup/duply { };

  dvdisaster = callPackage ../tools/cd-dvd/dvdisaster { };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvgrab = callPackage ../tools/video/dvgrab { };

  dvtm = callPackage ../tools/misc/dvtm { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  easyrsa = callPackage ../tools/networking/easyrsa { };

  easyrsa2 = callPackage ../tools/networking/easyrsa/2.x.nix { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  editres = callPackage ../tools/graphics/editres { };

  edk2 = callPackage ../development/compilers/edk2 { };

  eid-mw = callPackage ../tools/security/eid-mw { };

  eid-viewer = callPackage ../tools/security/eid-viewer { };

  emscripten = callPackage ../development/compilers/emscripten { };

  emscriptenfastcomp = callPackage ../development/compilers/emscripten-fastcomp { };

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

  encfs = callPackage ../tools/filesystems/encfs { };

  enscript = callPackage ../tools/text/enscript { };

  entr = callPackage ../tools/misc/entr { };

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

  Fabric = pythonPackages.Fabric;

  fail2ban = callPackage ../tools/security/fail2ban { };

  fakeroot = callPackage ../tools/system/fakeroot { };

  fakechroot = callPackage ../tools/system/fakechroot { };

  fatsort = callPackage ../tools/filesystems/fatsort { };

  fcitx = callPackage ../tools/inputmethods/fcitx { };

  fcitx-engines = recurseIntoAttrs {

    anthy = callPackage ../tools/inputmethods/fcitx-engines/fcitx-anthy { };

    chewing = callPackage ../tools/inputmethods/fcitx-engines/fcitx-chewing { };

    hangul = callPackage ../tools/inputmethods/fcitx-engines/fcitx-hangul { };

    m17n = callPackage ../tools/inputmethods/fcitx-engines/fcitx-m17n { };

    mozc = callPackage ../tools/inputmethods/fcitx-engines/fcitx-mozc {
      inherit (pythonPackages) gyp;
      protobuf = protobuf.override { stdenv = clangStdenv; };
    };

    table-other = callPackage ../tools/inputmethods/fcitx-engines/fcitx-table-other { };

  };

  fcitx-configtool = callPackage ../tools/inputmethods/fcitx/fcitx-configtool.nix { };

  fcitx-with-plugins = callPackage ../tools/inputmethods/fcitx/wrapper.nix {
    plugins = [ ];
  };

  fcppt = callPackage ../development/libraries/fcppt/default.nix { };

  fcron = callPackage ../tools/system/fcron { };

  fdm = callPackage ../tools/networking/fdm {};

  fgallery = callPackage ../tools/graphics/fgallery {
    inherit (perlPackages) ImageExifTool JSON;
  };

  flannel = goPackages.flannel.bin // { outputs = [ "bin" ]; };

  flashbench = callPackage ../os-specific/linux/flashbench { };

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file { };

  filegive = callPackage ../tools/networking/filegive { };

  fileschanged = callPackage ../tools/misc/fileschanged { };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  fio = callPackage ../tools/system/fio { };

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

  fontforge = lowPrio (callPackage ../tools/misc/fontforge { });
  fontforge-gtk = callPackage ../tools/misc/fontforge {
    withGTK = true;
  };

  fontmatrix = callPackage ../applications/graphics/fontmatrix {};

  foremost = callPackage ../tools/system/foremost { };

  forktty = callPackage ../os-specific/linux/forktty {};

  fortune = callPackage ../tools/misc/fortune { };

  fox = callPackage ../development/libraries/fox/default.nix {
    libpng = libpng12;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix { };

  fping = callPackage ../tools/networking/fping {};

  fpm = callPackage ../tools/package-management/fpm { };

  fprot = callPackage ../tools/security/fprot { };

  fprintd = callPackage ../tools/security/fprintd { };

  fprint_demo = callPackage ../tools/security/fprint_demo { };

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

  fuse_zip = callPackage ../tools/filesystems/fuse-zip { };

  exfat = callPackage ../tools/filesystems/exfat { };

  dos2unix = callPackage ../tools/text/dos2unix { };

  uni2ascii = callPackage ../tools/text/uni2ascii { };

  g500-control = callPackage ../tools/misc/g500-control { };

  galculator = callPackage ../applications/misc/galculator {
    gtk = gtk3;
  };

  galen = callPackage ../development/tools/galen {};

  garmin-plugin = callPackage ../applications/misc/garmin-plugin {};

  garmintools = callPackage ../development/libraries/garmintools {};

  gawk = callPackage ../tools/text/gawk {
    inherit (darwin) locale;
  };

  gawkInteractive = appendToName "interactive"
    (gawk.override { readlineSupport = true; });

  gawp = goPackages.gawp.bin // { outputs = [ "bin" ]; };

  gazeboSimulator = recurseIntoAttrs {
    sdformat = gazeboSimulator.sdformat4;

    sdformat3 = callPackage ../development/libraries/sdformat/3.nix { };

    sdformat4 = callPackage ../development/libraries/sdformat { };

    gazebo6 = callPackage ../applications/science/robotics/gazebo/6.nix { };

    gazebo6-headless = callPackage ../applications/science/robotics/gazebo/6.nix { withHeadless = true;  };

    gazebo7 = callPackage ../applications/science/robotics/gazebo { };

    gazebo7-headless = callPackage ../applications/science/robotics/gazebo { withHeadless = true; };

  };

  # at present, Gazebo 7.0.0 does not match Gazebo 6.5.1 for compatibility
  gazebo = gazeboSimulator.gazebo6;

  gazebo-headless = gazeboSimulator.gazebo6-headless;

  gbdfed = callPackage ../tools/misc/gbdfed {
    gtk = gtk2;
  };

  gdmap = callPackage ../tools/system/gdmap { };

  genext2fs = callPackage ../tools/filesystems/genext2fs { };

  gengetopt = callPackage ../development/tools/misc/gengetopt { };

  getmail = callPackage ../tools/networking/getmail { };

  getopt = callPackage ../tools/misc/getopt { };

  gftp = callPackage ../tools/networking/gftp { };

  ggobi = callPackage ../tools/graphics/ggobi { };

  gibo = callPackage ../tools/misc/gibo { };

  gifsicle = callPackage ../tools/graphics/gifsicle { };

  git-hub = callPackage ../applications/version-management/git-and-tools/git-hub { };

  git-lfs = goPackages.git-lfs.bin // { outputs = [ "bin" ]; };

  gitfs = callPackage ../tools/filesystems/gitfs { };

  gitinspector = callPackage ../applications/version-management/gitinspector { };

  gitlab = callPackage ../applications/version-management/gitlab {
    ruby = ruby_2_2;
  };

  gitlab-shell = callPackage ../applications/version-management/gitlab-shell {
    ruby = ruby_2_2;
  };

  gitlab-workhorse = callPackage ../applications/version-management/gitlab-workhorse { };

  gitstats = callPackage ../applications/version-management/gitstats { };

  git-latexdiff = callPackage ../tools/typesetting/git-latexdiff { };

  glusterfs = callPackage ../tools/filesystems/glusterfs { };

  glmark2 = callPackage ../tools/graphics/glmark2 { };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gmvault = callPackage ../tools/networking/gmvault { };

  gnaural = callPackage ../applications/audio/gnaural {
    stdenv = overrideCC stdenv gcc49;
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
  gnupg1 = self.gnupg1compat;    # use config.packageOverrides if you prefer original gnupg1
  gnupg20 = callPackage ../tools/security/gnupg/20.nix { };
  gnupg21 = callPackage ../tools/security/gnupg/21.nix { };
  gnupg = self.gnupg21;

  gnuplot = callPackage ../tools/graphics/gnuplot { qt = qt4; };

  gnuplot_qt = self.gnuplot.override { withQt = true; };

  # must have AquaTerm installed separately
  gnuplot_aquaterm = self.gnuplot.override { aquaterm = true; };

  gnused = callPackage ../tools/text/gnused { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

  goaccess = callPackage ../tools/misc/goaccess { };

  go-mtpfs = goPackages.mtpfs.bin // { outputs = [ "bin" ]; };

  go-pup = goPackages.pup.bin // { outputs = [ "bin" ]; };

  go-sct = goPackages.go-sct.bin // { outputs = [ "bin" ]; };

  go-upower-notify = goPackages.upower-notify.bin // { outputs = [ "bin" ]; };

  googleAuthenticator = callPackage ../os-specific/linux/google-authenticator { };

  google-cloud-sdk = callPackage ../tools/admin/google-cloud-sdk { };

  google-fonts = callPackage ../data/fonts/google-fonts { };

  gource = callPackage ../applications/version-management/gource { };

  gpart = callPackage ../tools/filesystems/gpart { };

  gparted = callPackage ../tools/misc/gparted { };

  gpodder = callPackage ../applications/audio/gpodder { };

  gptfdisk = callPackage ../tools/system/gptfdisk { };

  grafana-old = callPackage ../development/tools/misc/grafana { };

  grafx2 = callPackage ../applications/graphics/grafx2 {};

  grails = callPackage ../development/web/grails { jdk = null; };

  gprof2dot = callPackage ../development/tools/profiling/gprof2dot {
    # Using pypy provides significant performance improvements (~2x)
    pythonPackages = pypyPackages;
  };

  graphviz = callPackage ../tools/graphics/graphviz { };

  graphviz-nox = callPackage ../tools/graphics/graphviz {
    xorg = null;
    libdevil = libdevil-nox;
  };

  /* Readded by Michael Raskin. There are programs in the wild
   * that do want 2.0 but not 2.22. Please give a day's notice for
   * objections before removal. The feature is integer coordinates
   */
  graphviz_2_0 = callPackage ../tools/graphics/graphviz/2.0.nix { };

  /* Readded by Michael Raskin. There are programs in the wild
   * that do want 2.32 but not 2.0 or 2.36. Please give a day's notice for
   * objections before removal. The feature is libgraph.
   */
  graphviz_2_32 = callPackage ../tools/graphics/graphviz/2.32.nix { };

  grin = callPackage ../tools/text/grin { };

  grive = callPackage ../tools/filesystems/grive {
    json_c = json-c-0-11; # won't configure with 0.12; others are vulnerable
  };

  grive2 = callPackage ../tools/filesystems/grive2 { };

  groff = callPackage ../tools/text/groff {
    ghostscript = null;
  };

  grub = callPackage_i686 ../tools/misc/grub {
    buggyBiosCDSupport = config.grub.buggyBiosCDSupport or true;
  };

  trustedGrub = callPackage_i686 ../tools/misc/grub/trusted.nix { };

  trustedGrub-for-HP = callPackage_i686 ../tools/misc/grub/trusted.nix { for_HP_laptop = true; };

  grub2 = self.grub2_full;

  grub2_full = callPackage ../tools/misc/grub/2.0x.nix { };

  grub2_efi = self.grub2_full.override {
    efiSupport = true;
  };

  grub2_light = self.grub2_full.override {
    zfsSupport = false;
  };

  grub4dos = callPackage ../tools/misc/grub4dos {
    stdenv = stdenv_32bit;
  };

  sbsigntool = callPackage ../tools/security/sbsigntool { };

  gsmartcontrol = callPackage ../tools/misc/gsmartcontrol {
    inherit (gnome) libglademm;
  };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome) libsoup;
  };

  gt5 = callPackage ../tools/system/gt5 { };

  gtest = callPackage ../development/libraries/gtest {};
  gmock = callPackage ../development/libraries/gmock {};

  gtkdatabox = callPackage ../development/libraries/gtkdatabox {};

  gtklick = callPackage ../applications/audio/gtklick {};

  gtdialog = callPackage ../development/libraries/gtdialog {};

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gtkvnc = callPackage ../tools/admin/gtk-vnc {};

  gtmess = callPackage ../applications/networking/instant-messengers/gtmess { };

  gummiboot = callPackage ../tools/misc/gummiboot { };

  gup = callPackage ../development/tools/build-managers/gup {};

  gupnp = callPackage ../development/libraries/gupnp {
    inherit (gnome) libsoup;
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

  pxz = callPackage ../tools/compression/pxz { };

  hans = callPackage ../tools/networking/hans { };

  haproxy = callPackage ../tools/networking/haproxy { };

  haveged = callPackage ../tools/security/haveged { };

  hardlink = callPackage ../tools/system/hardlink { };

  hashcat = callPackage ../tools/security/hashcat { };

  hal-flash = callPackage ../os-specific/linux/hal-flash { };

  halibut = callPackage ../tools/typesetting/halibut { };

  hdapsd = callPackage ../os-specific/linux/hdapsd { };

  hddtemp = callPackage ../tools/misc/hddtemp { };

  hdf5 = callPackage ../tools/misc/hdf5 {
    gfortran = null;
    szip = null;
    mpi = null;
  };

  hdf5-mpi = appendToName "mpi" (self.hdf5.override {
    szip = null;
    mpi = pkgs.openmpi;
  });

  hdf5-cpp = appendToName "cpp" (self.hdf5.override {
    cpp = true;
  });

  hdf5-fortran = appendToName "fortran" (self.hdf5.override {
    inherit gfortran;
  });

  heimdall = callPackage ../tools/misc/heimdall { };

  hevea = callPackage ../tools/typesetting/hevea { };

  hfsprogs = callPackage ../tools/filesystems/hfsprogs { };

  highlight = callPackage ../tools/text/highlight {
    lua = lua5;
  };

  homesick = callPackage ../tools/misc/homesick { };

  honcho = callPackage ../tools/system/honcho { };

  horst = callPackage ../tools/networking/horst { };

  host = callPackage ../tools/networking/host { };

  hping = callPackage ../tools/networking/hping { };

  httpie = callPackage ../tools/networking/httpie { };

  httping = callPackage ../tools/networking/httping {};

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  httptunnel = callPackage ../tools/networking/httptunnel { };

  hubicfuse = callPackage ../tools/filesystems/hubicfuse { };

  hwinfo = callPackage ../tools/system/hwinfo { };

  i2c-tools = callPackage ../os-specific/linux/i2c-tools { };

  i2p = callPackage ../tools/networking/i2p {};

  i2pd = callPackage ../tools/networking/i2pd {};

  iasl = callPackage ../development/compilers/iasl { };

  iannix = callPackage ../applications/audio/iannix { };

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


  ihaskell = callPackage ../development/tools/haskell/ihaskell/wrapper.nix {
    inherit (haskellPackages) ihaskell ghcWithPackages;

    ipython = pythonFull.buildEnv.override {
      extraLibs = with pythonPackages; [ ipython ipykernel jupyter_client notebook ];
    };

    packages = config.ihaskell.packages or (self: []);
  };

  imapproxy = callPackage ../tools/networking/imapproxy { };

  imapsync = callPackage ../tools/networking/imapsync { };

  imgur-screenshot = callPackage ../tools/graphics/imgur-screenshot { };

  imgurbash2 = callPackage ../tools/graphics/imgurbash2 { };

  inadyn = callPackage ../tools/networking/inadyn { };

  inetutils = callPackage ../tools/networking/inetutils { };

  innoextract = callPackage ../tools/archivers/innoextract { };

  ioping = callPackage ../tools/system/ioping { };

  iops = callPackage ../tools/system/iops { };

  iodine = callPackage ../tools/networking/iodine { };

  ip2location = callPackage ../tools/networking/ip2location { };

  ipad_charge = callPackage ../tools/misc/ipad_charge { };

  iperf2 = callPackage ../tools/networking/iperf/2.nix { };
  iperf3 = callPackage ../tools/networking/iperf/3.nix { };
  iperf = self.iperf3;

  ipfs = self.goPackages.ipfs.bin // { outputs = [ "bin" ]; };

  ipmitool = callPackage ../tools/system/ipmitool {
    static = false;
  };

  ipmiutil = callPackage ../tools/system/ipmiutil {};

  ipmiview = callPackage ../applications/misc/ipmiview {};

  ipcalc = callPackage ../tools/networking/ipcalc {};

  ipv6calc = callPackage ../tools/networking/ipv6calc {};

  ipxe = callPackage ../tools/misc/ipxe { };

  ised = callPackage ../tools/misc/ised {};

  isl = self.isl_0_15;
  isl_0_11 = callPackage ../development/libraries/isl/0.11.1.nix { };
  isl_0_12 = callPackage ../development/libraries/isl/0.12.2.nix { };
  isl_0_14 = callPackage ../development/libraries/isl/0.14.1.nix { };
  isl_0_15 = callPackage ../development/libraries/isl/0.15.0.nix { };

  isync = callPackage ../tools/networking/isync { };
  isyncUnstable = callPackage ../tools/networking/isync/unstable.nix { };

  jaaa = callPackage ../applications/audio/jaaa { };

  jd-gui = callPackage_i686 ../tools/security/jd-gui { };

  jdiskreport = callPackage ../tools/misc/jdiskreport { };

  jekyll = callPackage ../applications/misc/jekyll { };

  jfsutils = callPackage ../tools/filesystems/jfsutils { };

  jhead = callPackage ../tools/graphics/jhead { };

  jing = callPackage ../tools/text/xml/jing { };

  jmtpfs = callPackage ../tools/filesystems/jmtpfs { };

  jnettop = callPackage ../tools/networking/jnettop { };

  john = callPackage ../tools/security/john { };

  jp2a = callPackage ../applications/misc/jp2a { };

  jpegoptim = callPackage ../applications/graphics/jpegoptim { };

  jq = callPackage ../development/tools/jq { };

  jo = callPackage ../development/tools/jo { };

  jscoverage = callPackage ../development/tools/misc/jscoverage { };

  jwhois = callPackage ../tools/networking/jwhois { };

  k2pdfopt = callPackage ../applications/misc/k2pdfopt { };

  kazam = callPackage ../applications/video/kazam { };

  kalibrate-rtl = callPackage ../tools/misc/kalibrate-rtl { };

  kbdd = callPackage ../applications/window-managers/kbdd { };

  kdbplus = callPackage_i686 ../applications/misc/kdbplus { };

  keepalived = callPackage ../tools/networking/keepalived { };

  kexectools = callPackage ../os-specific/linux/kexectools { };

  keybase = callPackage ../applications/misc/keybase { };

  keychain = callPackage ../tools/misc/keychain { };

  keyfuzz = callPackage ../tools/inputmethods/keyfuzz { };

  kibana = callPackage ../development/tools/misc/kibana { };

  kismet = callPackage ../applications/networking/sniffers/kismet { };

  klick = callPackage ../applications/audio/klick { };

  knockknock = callPackage ../tools/security/knockknock { };

  kpcli = callPackage ../tools/security/kpcli { };

  kst = qt5.callPackage ../tools/graphics/kst { gsl = gsl_1; };

  leocad = callPackage ../applications/graphics/leocad { };

  less = callPackage ../tools/misc/less { };

  liquidsoap = callPackage ../tools/audio/liquidsoap/full.nix { };

  lnav = callPackage ../tools/misc/lnav { };

  lockfileProgs = callPackage ../tools/misc/lockfile-progs { };

  logstash = callPackage ../tools/misc/logstash { };

  logstash-contrib = callPackage ../tools/misc/logstash/contrib.nix { };

  logstash-forwarder = callPackage ../tools/misc/logstash-forwarder { };

  lolcat = callPackage ../tools/misc/lolcat { };

  lsdvd = callPackage ../tools/cd-dvd/lsdvd {};

  lsyncd = callPackage ../applications/networking/sync/lsyncd {
    lua = lua5_2_compat;
  };

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

  mkcast = callPackage ../applications/video/mkcast { };

  multitail = callPackage ../tools/misc/multitail { };

  mxt-app = callPackage ../misc/mxt-app { };

  netperf = callPackage ../applications/networking/netperf { };

  netsniff-ng = callPackage ../tools/networking/netsniff-ng { };

  ninka = callPackage ../development/tools/misc/ninka { };

  nodejs-5_x = callPackage ../development/web/nodejs/v5.nix {
    libtool = darwin.cctools;
  };

  nodejs-4_x = callPackage ../development/web/nodejs/v4.nix {
    libtool = darwin.cctools;
  };

  nodejs-0_10 = callPackage ../development/web/nodejs/v0_10.nix {
    libtool = darwin.cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices Carbon Foundation;
  };

  nodejs = if stdenv.system == "armv5tel-linux" then
    nodejs-0_10
  else
    nodejs-4_x;

  nodePackages_5_x = callPackage ./node-packages.nix { self = nodePackages_5_x; nodejs = nodejs-5_x; };

  nodePackages_4_x = callPackage ./node-packages.nix { self = nodePackages_4_x; nodejs = nodejs-4_x; };

  nodePackages_0_10 = callPackage ./node-packages.nix { self = nodePackages_0_10; nodejs = nodejs-0_10; };

  nodePackages = if stdenv.system == "armv5tel-linux" then
    nodePackages_0_10
  else
    nodePackages_4_x;

  npm2nix = nodePackages.npm2nix;

  ldapvi = callPackage ../tools/misc/ldapvi { };

  ldns = callPackage ../development/libraries/ldns { };

  leafpad = callPackage ../applications/editors/leafpad { };

  leela = callPackage ../tools/graphics/leela { };

  lftp = callPackage ../tools/networking/lftp { };

  libconfig = callPackage ../development/libraries/libconfig { };

  libcmis = callPackage ../development/libraries/libcmis { };

  libee = callPackage ../development/libraries/libee { };

  libestr = callPackage ../development/libraries/libestr { };

  libevdev = callPackage ../development/libraries/libevdev { };

  libevhtp = callPackage ../development/libraries/libevhtp { };

  liboauth = callPackage ../development/libraries/liboauth { };

  libsrs2 = callPackage ../development/libraries/libsrs2 { };

  libtermkey = callPackage ../development/libraries/libtermkey { };

  libtirpc = callPackage ../development/libraries/ti-rpc { };

  libshout = callPackage ../development/libraries/libshout { };

  libqb = callPackage ../development/libraries/libqb { };

  libqmi = callPackage ../development/libraries/libqmi { };

  libmbim = callPackage ../development/libraries/libmbim { };

  libmongo-client = callPackage ../development/libraries/libmongo-client { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  libiberty = callPackage ../development/libraries/libiberty { };

  libiberty_static = callPackage ../development/libraries/libiberty { staticBuild = true; };

  libibverbs = callPackage ../development/libraries/libibverbs { };

  libxcomp = callPackage ../development/libraries/libxcomp { };

  libx86emu = callPackage ../development/libraries/libx86emu { };

  librdmacm = callPackage ../development/libraries/librdmacm { };

  libreswan = callPackage ../tools/networking/libreswan { };

  libwebsockets = callPackage ../development/libraries/libwebsockets { };

  limesurvey = callPackage ../servers/limesurvey { };

  logcheck = callPackage ../tools/system/logcheck {
    inherit (perlPackages) mimeConstruct;
  };

  logkeys = callPackage ../tools/security/logkeys { };

  logrotate = callPackage ../tools/system/logrotate { };

  logstalgia = callPackage ../tools/graphics/logstalgia {};

  longview = callPackage ../servers/monitoring/longview { };

  lout = callPackage ../tools/typesetting/lout { };

  lr = callPackage ../tools/system/lr { };

  lrzip = callPackage ../tools/compression/lrzip { };

  # lsh installs `bin/nettle-lfib-stream' and so does Nettle.  Give the
  # former a lower priority than Nettle.
  lsh = lowPrio (callPackage ../tools/networking/lsh { });

  lshw = callPackage ../tools/system/lshw { };

  lxc = callPackage ../os-specific/linux/lxc { };
  lxd = goPackages.lxd.bin // { outputs = [ "bin" ]; };

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
    guile = guile_1_8;
  };

  email = callPackage ../tools/networking/email { };

  maim = callPackage ../tools/graphics/maim {};

  mairix = callPackage ../tools/text/mairix { };

  makemkv = callPackage ../applications/video/makemkv { };

  man = callPackage ../tools/misc/man { };

  man_db = callPackage ../tools/misc/man-db { };

  mawk = callPackage ../tools/text/mawk { };

  mbox = callPackage ../tools/security/mbox { };

  mbuffer = callPackage ../tools/misc/mbuffer { };

  memtest86 = callPackage ../tools/misc/memtest86 { };

  memtest86plus = callPackage ../tools/misc/memtest86+ { };

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
    inherit (gnome) scrollkeeper;
  };

  mdk = callPackage ../development/tools/mdk { };

  mdp = callPackage ../applications/misc/mdp { };

  mednafen = callPackage ../misc/emulators/mednafen { };

  mednafen-server = callPackage ../misc/emulators/mednafen/server.nix { };

  mednaffe = callPackage ../misc/emulators/mednaffe/default.nix { };

  megacli = callPackage ../tools/misc/megacli { };

  megatools = callPackage ../tools/networking/megatools { };

  mfcuk = callPackage ../tools/security/mfcuk { };

  mfoc = callPackage ../tools/security/mfoc { };

  mgba = qt5.callPackage ../misc/emulators/mgba { };

  mimeo = callPackage ../tools/misc/mimeo { };

  minissdpd = callPackage ../tools/networking/minissdpd { };

  miniupnpc = callPackage ../tools/networking/miniupnpc { };

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  miniball = callPackage ../development/libraries/miniball { };

  minixml = callPackage ../development/libraries/minixml { };

  mjpegtools = callPackage ../tools/video/mjpegtools { };

  mkcue = callPackage ../tools/cd-dvd/mkcue { };

  mkpasswd = callPackage ../tools/security/mkpasswd { };

  mkrand = callPackage ../tools/security/mkrand { };

  mktemp = callPackage ../tools/security/mktemp { };

  mktorrent = callPackage ../tools/misc/mktorrent { };

  modemmanager = callPackage ../tools/networking/modemmanager {};

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

  nabi = callPackage ../tools/inputmethods/nabi { };

  namazu = callPackage ../tools/text/namazu { };

  nasty = callPackage ../tools/security/nasty { };

  nbd = callPackage ../tools/networking/nbd { };

  ndjbdns = callPackage ../tools/networking/ndjbdns { };

  nestopia = callPackage ../misc/emulators/nestopia { };

  netatalk = callPackage ../tools/filesystems/netatalk { };

  netcdf = callPackage ../development/libraries/netcdf { };

  netcdfcxx4 = callPackage ../development/libraries/netcdf-cxx4 { };

  netcdffortran = callPackage ../development/libraries/netcdf-fortran { };

  nco = callPackage ../development/libraries/nco { };

  nc6 = callPackage ../tools/networking/nc6 { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  ndisc6 = callPackage ../tools/networking/ndisc6 { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = callPackage ../tools/networking/netcat { };

  netcat-openbsd = callPackage ../tools/networking/netcat-openbsd { };

  nethogs = callPackage ../tools/networking/nethogs { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netrw = callPackage ../tools/networking/netrw { };

  netselect = callPackage ../tools/networking/netselect { };

  # stripped down, needed by steam
  networkmanager098 = callPackage ../tools/networking/network-manager/0.9.8.nix { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager_openvpn = callPackage ../tools/networking/network-manager/openvpn.nix { };

  networkmanager_pptp = callPackage ../tools/networking/network-manager/pptp.nix { };

  networkmanager_l2tp = callPackage ../tools/networking/network-manager/l2tp.nix { };

  networkmanager_vpnc = callPackage ../tools/networking/network-manager/vpnc.nix { };

  networkmanager_openconnect = callPackage ../tools/networking/network-manager/openconnect.nix { };

  networkmanagerapplet = newScope gnome ../tools/networking/network-manager-applet { };

  newsbeuter = callPackage ../applications/networking/feedreaders/newsbeuter { };

  newsbeuter-dev = callPackage ../applications/networking/feedreaders/newsbeuter/dev.nix { };

  ngrep = callPackage ../tools/networking/ngrep { };

  ngrok = goPackages.ngrok.bin // { outputs = [ "bin" ]; };

  noip = callPackage ../tools/networking/noip { };

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

  nkf = callPackage ../tools/text/nkf {};

  nlopt = callPackage ../development/libraries/nlopt {};

  npapi_sdk = callPackage ../development/libraries/npapi-sdk {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap { };

  nmap_graphical = callPackage ../tools/security/nmap {
    inherit (pythonPackages) pysqlite;
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

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nwdiag = pythonPackages.nwdiag;

  nylon = callPackage ../tools/networking/nylon { };

  nxproxy = callPackage ../tools/admin/nxproxy { };

  nzbget = callPackage ../tools/networking/nzbget { };

  oathToolkit = callPackage ../tools/security/oath-toolkit { };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  obexd = callPackage ../tools/bluetooth/obexd { };

  openfortivpn = callPackage ../tools/networking/openfortivpn { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  objconv = callPackage ../development/tools/misc/objconv {};

  obnam = callPackage ../tools/backup/obnam { };

  odpdown = callPackage ../tools/typesetting/odpdown {
    inherit (pythonPackages) lpod lxml mistune pillow pygments;
  };

  odt2txt = callPackage ../tools/text/odt2txt { };

  offlineimap = callPackage ../tools/networking/offlineimap {
    inherit (pythonPackages) sqlite3;
  };

  oh-my-zsh = callPackage ../shells/oh-my-zsh { };

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

  openopc = callPackage ../tools/misc/openopc {
    pythonFull = python27.buildEnv.override {
      extraLibs = [ python27Packages.pyro3 ];
    };
  };

  openresolv = callPackage ../tools/networking/openresolv { };

  opensc = callPackage ../tools/security/opensc { };

  openssh =
    callPackage ../tools/networking/openssh {
      hpnSupport = false;
      withKerberos = false;
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

  oslrd = callPackage ../tools/networking/oslrd { };

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
    owncloud90;

  owncloudclient = callPackage ../applications/networking/owncloud-client { };

  p2pvc = callPackage ../applications/video/p2pvc {};

  p7zip = callPackage ../tools/archivers/p7zip { };

  packagekit = callPackage ../tools/package-management/packagekit { };

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

  paper-gtk-theme = callPackage ../misc/themes/gtk3/paper-gtk-theme { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  parcellite = callPackage ../tools/misc/parcellite { };

  patchutils = callPackage ../tools/text/patchutils { };

  parted = callPackage ../tools/misc/parted { hurd = null; };

  pell = callPackage ../applications/misc/pell { };

  pitivi = callPackage ../applications/video/pitivi {
    gst = gst_all_1 //
      { gst-plugins-bad = gst_all_1.gst-plugins-bad.overrideDerivation
          (attrs: { nativeBuildInputs = attrs.nativeBuildInputs ++ [ gtk3 ]; });
      };
  };

  p0f = callPackage ../tools/security/p0f { };

  pngout = callPackage ../tools/graphics/pngout { };

  hurdPartedCross =
    if crossSystem != null && crossSystem.config == "i586-pc-gnu"
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

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite { };

  pcsctools = callPackage ../tools/security/pcsctools {
    inherit (perlPackages) pcscperl Glib Gtk2 Pango;
  };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdf2svg = callPackage ../tools/graphics/pdf2svg { };

  pdfjam = callPackage ../tools/typesetting/pdfjam { };

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

  pk2cmd = callPackage ../tools/misc/pk2cmd { };

  plantuml = callPackage ../tools/misc/plantuml { };

  plan9port = callPackage ../tools/system/plan9port { };

  platformioPackages = callPackage ../development/arduino/platformio { };
  platformio = platformioPackages.platformio-chrootenv.override {};

  plex = callPackage ../servers/plex { enablePlexPass = config.plex.enablePlexPass or false; };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  plotutils = callPackage ../tools/graphics/plotutils { };

  plowshare = callPackage ../tools/misc/plowshare { };

  pngcheck = callPackage ../tools/graphics/pngcheck { };

  pngcrush = callPackage ../tools/graphics/pngcrush { };

  pngnq = callPackage ../tools/graphics/pngnq { };

  pngtoico = callPackage ../tools/graphics/pngtoico {
    libpng = libpng12;
  };

  pngquant = callPackage ../tools/graphics/pngquant { };

  podiff = callPackage ../tools/text/podiff { };

  poedit = callPackage ../tools/text/poedit { };

  polipo = callPackage ../servers/polipo { };

  polkit_gnome = callPackage ../tools/security/polkit-gnome { };

  popcorntime = callPackage ../applications/video/popcorntime { nwjs = nwjs_0_12; };

  ponysay = callPackage ../tools/misc/ponysay { };

  popfile = callPackage ../tools/text/popfile { };

  povray = callPackage ../tools/graphics/povray {
    automake = automake113x; # fails with 14
  };

  ppl = callPackage ../development/libraries/ppl { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  prey-bash-client = callPackage ../tools/security/prey { };

  profile-cleaner = callPackage ../tools/misc/profile-cleaner { };

  profile-sync-daemon = callPackage ../tools/misc/profile-sync-daemon { };

  projectm = callPackage ../applications/audio/projectm { };

  proot = callPackage ../tools/system/proot { };

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel { };

  cntlm = callPackage ../tools/networking/cntlm { };

  pastebinit = callPackage ../tools/misc/pastebinit { };

  polygraph = callPackage ../tools/networking/polygraph { };

  progress = callPackage ../tools/misc/progress { };

  psmisc = callPackage ../os-specific/linux/psmisc { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pwnat = callPackage ../tools/networking/pwnat { };

  pyatspi = callPackage ../development/python-modules/pyatspi { };

  pycangjie = pythonPackages.pycangjie;

  pydb = callPackage ../development/tools/pydb { };

  pygmentex = callPackage ../tools/typesetting/pygmentex { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pythonDBus = self.dbus_python;

  pythonIRClib = pythonPackages.pythonIRClib;

  pythonSexy = callPackage ../development/python-modules/libsexy { };

  pytrainer = callPackage ../applications/misc/pytrainer { };

  remarshal = (callPackage ../development/tools/remarshal { }).bin // { outputs = [ "bin" ]; };

  openmpi = callPackage ../development/libraries/openmpi { };

  openmodelica = callPackage ../applications/science/misc/openmodelica { };

  qarte = callPackage ../applications/video/qarte {
    sip = pythonPackages.sip_4_16;
  };

  ocz-ssd-guru = callPackage ../tools/misc/ocz-ssd-guru { };

  qalculate-gtk = callPackage ../applications/science/math/qalculate-gtk { };

  qastools = callPackage ../tools/audio/qastools {
    qt = qt4;
  };

  qgifer = callPackage ../applications/video/qgifer {
    giflib = giflib_4_1;
    qt = qt4;
  };

  qhull = callPackage ../development/libraries/qhull { };

  qjoypad = callPackage ../tools/misc/qjoypad { };

  qpdf = callPackage ../development/libraries/qpdf { };

  qprint = callPackage ../tools/text/qprint { };

  qscintilla = callPackage ../development/libraries/qscintilla {
    qt = qt4;
  };

  qshowdiff = callPackage ../tools/text/qshowdiff { };

  quicktun = callPackage ../tools/networking/quicktun { };

  quilt = callPackage ../development/tools/quilt { };

  radamsa = callPackage ../tools/security/radamsa { };

  radvd = callPackage ../tools/networking/radvd { };

  ranger = callPackage ../applications/misc/ranger { };

  rarcrack = callPackage ../tools/security/rarcrack { };

  ratools = callPackage ../tools/networking/ratools { };

  rawdog = callPackage ../applications/networking/feedreaders/rawdog { };

  read-edid = callPackage ../os-specific/linux/read-edid { };

  redir = callPackage ../tools/networking/redir { };

  redmine = callPackage ../applications/version-management/redmine { };

  rt = callPackage ../servers/rt { };

  rtmpdump = callPackage ../tools/video/rtmpdump { };
  rtmpdump_gnutls = rtmpdump.override { gnutlsSupport = true; opensslSupport = false; };

  reaverwps = callPackage ../tools/networking/reaver-wps {};

  recordmydesktop = callPackage ../applications/video/recordmydesktop { };

  recutils = callPackage ../tools/misc/recutils { };

  recoll = callPackage ../applications/search/recoll { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome) gnome_vfs GConf;
  };

  remarkjs = callPackage ../development/web/remarkjs { };

  remind = callPackage ../tools/misc/remind { };

  remmina = callPackage ../applications/networking/remote/remmina {};

  renameutils = callPackage ../tools/misc/renameutils { };

  replace = callPackage ../tools/text/replace { };

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

  rpmextract = callPackage ../tools/archivers/rpmextract { };

  rrdtool = callPackage ../tools/misc/rrdtool { };

  rsstail = callPackage ../applications/networking/feedreaders/rsstail { };

  rtorrent = callPackage ../tools/networking/p2p/rtorrent { };

  rubber = callPackage ../tools/typesetting/rubber { };

  runzip = callPackage ../tools/archivers/runzip { };

  rxp = callPackage ../tools/text/xml/rxp { };

  rzip = callPackage ../tools/compression/rzip { };

  s3backer = callPackage ../tools/filesystems/s3backer { };

  s3fs = callPackage ../tools/filesystems/s3fs { };

  s3cmd = callPackage ../tools/networking/s3cmd { };

  s3gof3r = goPackages.s3gof3r.bin // { outputs = [ "bin" ]; };

  s6Dns = callPackage ../tools/networking/s6-dns { };

  s6LinuxUtils = callPackage ../os-specific/linux/s6-linux-utils { };

  s6Networking = callPackage ../tools/networking/s6-networking { };

  s6PortableUtils = callPackage ../tools/misc/s6-portable-utils { };

  sablotron = callPackage ../tools/text/xml/sablotron { };

  safecopy = callPackage ../tools/system/safecopy { };

  safe-rm = callPackage ../tools/system/safe-rm { };

  salut_a_toi = callPackage ../applications/networking/instant-messengers/salut-a-toi {};

  samplicator = callPackage ../tools/networking/samplicator { };

  scanbd = callPackage ../tools/graphics/scanbd { };

  screen = callPackage ../tools/misc/screen {
    inherit (darwin.apple_sdk.libs) utmp;
  };

  screen-message = callPackage ../tools/X11/screen-message { };

  screencloud = callPackage ../applications/graphics/screencloud {
    quazip = qt5.quazip.override { qt = qt4; };
  };

  scrot = callPackage ../tools/graphics/scrot { };

  scrypt = callPackage ../tools/security/scrypt { };

  sdcv = callPackage ../applications/misc/sdcv { };

  sdl-jstest = callPackage ../tools/misc/sdl-jstest { };

  sec = callPackage ../tools/admin/sec { };

  seccure = callPackage ../tools/security/seccure { };

  setroot = callPackage  ../tools/X11/setroot { };

  setserial = callPackage ../tools/system/setserial { };

  seqdiag = pythonPackages.seqdiag;

  screenfetch = callPackage ../tools/misc/screenfetch { };

  sg3_utils = callPackage ../tools/system/sg3_utils { };

  shadowsocks-libev = callPackage ../tools/networking/shadowsocks-libev { };

  sharutils = callPackage ../tools/archivers/sharutils { };

  shotwell = callPackage ../applications/graphics/shotwell {
    vala = vala_0_28;
  };

  shout = callPackage ../applications/networking/irc/shout { };

  shellinabox = callPackage ../servers/shellinabox { };

  sic = callPackage ../applications/networking/irc/sic { };

  siege = callPackage ../tools/networking/siege {};

  sigil = qt5.callPackage ../applications/editors/sigil { };

  # aka., gpg-tools
  signing-party = callPackage ../tools/security/signing-party { };

  silc_client = callPackage ../applications/networking/instant-messengers/silc-client { };

  silc_server = callPackage ../servers/silc-server { };

  silver-searcher = callPackage ../tools/text/silver-searcher { };

  simplescreenrecorder = callPackage ../applications/video/simplescreenrecorder { };

  sipsak = callPackage ../tools/networking/sipsak { };

  skippy-xd = callPackage ../tools/X11/skippy-xd {};

  skydns = goPackages.skydns.bin // { outputs = [ "bin" ]; };

  sipcalc = callPackage ../tools/networking/sipcalc { };

  sleuthkit = callPackage ../tools/system/sleuthkit {};

  slimrat = callPackage ../tools/networking/slimrat {
    inherit (perlPackages) WWWMechanize LWP;
  };

  slsnif = callPackage ../tools/misc/slsnif { };

  smartmontools = callPackage ../tools/system/smartmontools { };

  smbldaptools = callPackage ../tools/networking/smbldaptools {
    inherit (perlPackages) NetLDAP CryptSmbHash DigestSHA1;
  };

  smbnetfs = callPackage ../tools/filesystems/smbnetfs {};

  snabb = callPackage ../tools/networking/snabb { } ;

  sng = callPackage ../tools/graphics/sng {
    libpng = libpng12;
  };

  snort = callPackage ../applications/networking/ids/snort { };

  solr = callPackage ../servers/search/solr { };

  solvespace = callPackage ../applications/graphics/solvespace { };

  sonata = callPackage ../applications/audio/sonata {
    inherit (python3Packages) buildPythonApplication python isPy3k dbus pygobject3 mpd2;
  };

  sparsehash = callPackage ../development/libraries/sparsehash { };

  spiped = callPackage ../tools/networking/spiped { };

  sqliteman = callPackage ../applications/misc/sqliteman { };

  stdman = callPackage ../data/documentation/stdman { };

  storebrowse = callPackage ../tools/system/storebrowse { };

  fusesmb = callPackage ../tools/filesystems/fusesmb { samba = samba3; };

  sl = callPackage ../tools/misc/sl { };

  socat = callPackage ../tools/networking/socat { };

  socat2pre = lowPrio (callPackage ../tools/networking/socat/2.x.nix { });

  solaar = callPackage ../applications/misc/solaar {};

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  spaceFM = callPackage ../applications/misc/spacefm { adwaita-icon-theme = gnome3.adwaita-icon-theme; };

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  sshfsFuse = callPackage ../tools/filesystems/sshfs-fuse { };

  sshuttle = callPackage ../tools/security/sshuttle { };

  sstp = callPackage ../tools/networking/sstp {};

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = callPackage ../tools/system/suid-chroot { };

  sundtek = callPackage ../misc/drivers/sundtek { };

  sunxi-tools = callPackage ../development/tools/sunxi-tools { };

  super = callPackage ../tools/security/super { };

  supertux-editor = callPackage ../applications/editors/supertux-editor { };

  super-user-spark = haskellPackages.callPackage ../applications/misc/super_user_spark { };

  ssdeep = callPackage ../tools/security/ssdeep { };

  sshpass = callPackage ../tools/networking/sshpass { };

  sslscan = callPackage ../tools/security/sslscan { };

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

  svtplay-dl = callPackage ../tools/misc/svtplay-dl {
    inherit (pythonPackages) nose mock requests2;
  };

  sysbench = callPackage ../development/tools/misc/sysbench {};

  system-config-printer = callPackage ../tools/misc/system-config-printer {
    libxml2 = libxml2Python;
   };

  sitecopy = callPackage ../tools/networking/sitecopy { };

  stricat = callPackage ../tools/security/stricat { };

  staruml = callPackage ../tools/misc/staruml { inherit (gnome) GConf; libgcrypt = libgcrypt_1_5; };

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

  teamviewer = callPackage ../applications/networking/remote/teamviewer {
    stdenv = stdenv_32bit;
  };

  telnet = callPackage ../tools/networking/telnet { };

  texmacs = callPackage ../applications/editors/texmacs {
    tex = texlive.combined.scheme-small;
    extraFonts = true;
  };

  texmaker = callPackage ../applications/editors/texmaker { };

  texstudio = callPackage ../applications/editors/texstudio { };

  textadept = callPackage ../applications/editors/textadept { };

  thc-hydra = callPackage ../tools/security/thc-hydra { };

  tiled = qt5.callPackage ../applications/editors/tiled { };

  timemachine = callPackage ../applications/audio/timemachine { };

  tinc = callPackage ../tools/networking/tinc { };

  tinc_pre = callPackage ../tools/networking/tinc/pre.nix { };

  tiny8086 = callPackage ../applications/virtualization/8086tiny { };

  tlsdate = callPackage ../tools/networking/tlsdate { };

  tldr = callPackage ../tools/misc/tldr { };

  tmate = callPackage ../tools/misc/tmate { };

  tmpwatch = callPackage ../tools/misc/tmpwatch  { };

  tmux = callPackage ../tools/misc/tmux { };

  tmux-cssh = callPackage ../tools/misc/tmux-cssh { };

  tmuxinator = callPackage ../tools/misc/tmuxinator { };

  tmin = callPackage ../tools/security/tmin { };

  tmsu = callPackage ../tools/filesystems/tmsu { };

  toilet = callPackage ../tools/misc/toilet { };

  tor = callPackage ../tools/security/tor { };

  tor-arm = callPackage ../tools/security/tor/tor-arm.nix { };

  torbutton = callPackage ../tools/security/torbutton { };

  torbrowser = callPackage ../tools/security/tor/torbrowser.nix { };

  touchegg = callPackage ../tools/inputmethods/touchegg { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  tpmmanager = callPackage ../applications/misc/tpmmanager { };

  tpm-quote-tools = callPackage ../tools/security/tpm-quote-tools { };

  tpm-tools = callPackage ../tools/security/tpm-tools { };

  tpm-luks = callPackage ../tools/security/tpm-luks { };

  tthsum = callPackage ../applications/misc/tthsum { };

  chaps = callPackage ../tools/security/chaps { };

  trace-cmd = callPackage ../os-specific/linux/trace-cmd { };

  traceroute = callPackage ../tools/networking/traceroute { };

  tracebox = callPackage ../tools/networking/tracebox { };

  trash-cli = callPackage ../tools/misc/trash-cli { };

  trickle = callPackage ../tools/networking/trickle {};

  trousers = callPackage ../tools/security/trousers { };

  omapd = callPackage ../tools/security/omapd { };

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ttfautohint = callPackage ../tools/misc/ttfautohint { };

  tty-clock = callPackage ../tools/misc/tty-clock { };

  ttyrec = callPackage ../tools/misc/ttyrec { };

  ttysnoop = callPackage ../os-specific/linux/ttysnoop {};

  ttylog = callPackage ../tools/misc/ttylog { };

  twitterBootstrap = callPackage ../development/web/twitter-bootstrap {};

  txt2man = callPackage ../tools/misc/txt2man { };

  txt2tags = callPackage ../tools/text/txt2tags { };

  txtw = callPackage ../tools/misc/txtw { };

  u9fs = callPackage ../servers/u9fs { };

  ucl = callPackage ../development/libraries/ucl { };

  ucspi-tcp = callPackage ../tools/networking/ucspi-tcp { };

  udftools = callPackage ../tools/filesystems/udftools {};

  udptunnel = callPackage ../tools/networking/udptunnel { };

  ufraw = callPackage ../applications/graphics/ufraw { };

  uget = callPackage ../tools/networking/uget { };

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
    inherit (gnome) scrollkeeper;
    inherit (gnome3) gexiv2;
  };

  vit = callPackage ../applications/misc/vit { };

  vnc2flv = callPackage ../tools/video/vnc2flv {};

  vncrec = callPackage ../tools/video/vncrec { };

  vobcopy = callPackage ../tools/cd-dvd/vobcopy { };

  vobsub2srt = callPackage ../tools/cd-dvd/vobsub2srt { };

  vorbisgain = callPackage ../tools/misc/vorbisgain { };

  vpnc = callPackage ../tools/networking/vpnc { };

  openconnect = openconnect_openssl;

  openconnect_openssl = callPackage ../tools/networking/openconnect.nix {
    gnutls = null;
  };

  openconnect_gnutls = lowPrio (openconnect.override {
    openssl = null;
    gnutls = gnutls;
  });

  vtun = callPackage ../tools/networking/vtun { };

  weather = callPackage ../applications/misc/weather { };

  wego = goPackages.wego.bin // { outputs = [ "bin" ]; };

  wal_e = callPackage ../tools/backup/wal-e { };

  watchman = callPackage ../development/tools/watchman { };

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

  trang = callPackage ../tools/text/xml/trang { };

  tre = callPackage ../development/libraries/tre { };

  ts = callPackage ../tools/system/ts { };

  transfig = callPackage ../tools/graphics/transfig {
    libpng = libpng12;
  };

  truecrypt = callPackage ../applications/misc/truecrypt {
    wxGUI = config.truecrypt.wxGUI or true;
  };

  ttmkfdir = callPackage ../tools/misc/ttmkfdir { };

  udunits = callPackage ../development/libraries/udunits { };

  uim = callPackage ../tools/inputmethods/uim {
    inherit (pkgs.kde4) kdelibs;
  };

  uhub = callPackage ../servers/uhub { };

  unclutter = callPackage ../tools/misc/unclutter { };

  unbound = callPackage ../tools/networking/unbound { };

  units = callPackage ../tools/misc/units { };

  unrar = callPackage ../tools/archivers/unrar { };

  xar = callPackage ../tools/compression/xar { };

  xarchive = callPackage ../tools/archivers/xarchive { };

  xarchiver = callPackage ../tools/archivers/xarchiver { };

  xbrightness = callPackage ../tools/X11/xbrightness { };

  xfstests = callPackage ../tools/misc/xfstests { };

  xprintidle-ng = callPackage ../tools/X11/xprintidle-ng {};

  xsettingsd = callPackage ../tools/X11/xsettingsd { };

  xsensors = callPackage ../os-specific/linux/xsensors { };

  xcruiser = callPackage ../applications/misc/xcruiser { };

  xxkb = callPackage ../applications/misc/xxkb { };

  ugarit = callPackage ../tools/backup/ugarit { };

  ugarit-manifest-maker = callPackage ../tools/backup/ugarit-manifest-maker { };

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
    vala = vala_0_28;
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
    inherit (perlPackages) LWP;
    libpsl = null;
  };

  which = callPackage ../tools/system/which { };

  wicd = callPackage ../tools/networking/wicd { };

  wipe = callPackage ../tools/security/wipe { };

  wkhtmltopdf = callPackage ../tools/graphics/wkhtmltopdf {
    overrideDerivation = lib.overrideDerivation;
  };

  wml = callPackage ../development/web/wml { };

  wring = callPackage ../tools/text/wring { };

  wrk = callPackage ../tools/networking/wrk { };

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

  wyrd = callPackage ../tools/misc/wyrd {
    inherit (ocamlPackages) camlp4;
  };

  x86info = callPackage ../os-specific/linux/x86info { };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = assert stdenv ? glibc; callPackage ../tools/misc/xburst-tools {
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross =
      let
        pkgsCross = (import ./../..) {
          inherit system;
          inherit bootStdenv noSysDirs gccWithCC gccWithProfiling config;
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

  xe-guest-utilities = callPackage ../tools/virtualization/xe-guest-utilities { };

  xflux = callPackage ../tools/misc/xflux { };

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { };
  libxfs = self.xfsprogs.lib;

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

  yank = callPackage ../tools/misc/yank { };

  yaml-merge = callPackage ../tools/text/yaml-merge { };

  yeshup = callPackage ../tools/system/yeshup { };

  # To expose more packages for Yi, override the extraPackages arg.
  yi = callPackage ../applications/editors/yi/wrapper.nix { };

  yle-dl = callPackage ../tools/misc/yle-dl {};

  zbackup = callPackage ../tools/backup/zbackup {};

  zbar = callPackage ../tools/graphics/zbar {
    pygtk = lib.overrideDerivation pygtk (x: {
      gtk = gtk2;
    });
  };

  zdelta = callPackage ../tools/compression/zdelta { };

  zerotierone = callPackage ../tools/networking/zerotierone { };

  zerofree = callPackage ../tools/filesystems/zerofree { };

  zfstools = callPackage ../tools/filesystems/zfstools { };

  zile = callPackage ../applications/editors/zile { };

  zinnia = callPackage ../tools/inputmethods/zinnia { };
  tegaki-zinnia-japanese = callPackage ../tools/inputmethods/tegaki-zinnia-japanese { };

  zimreader = callPackage ../tools/text/zimreader { };

  zimwriterfs = callPackage ../tools/text/zimwriterfs { };

  zip = callPackage ../tools/archivers/zip { };

  zkfuse = callPackage ../tools/filesystems/zkfuse { };

  zpaq = callPackage ../tools/archivers/zpaq { };
  zpaqd = callPackage ../tools/archivers/zpaq/zpaqd.nix { };

  zsh-navigation-tools = callPackage ../tools/misc/zsh-navigation-tools { };

  zstd = callPackage ../tools/compression/zstd { };

  zsync = callPackage ../tools/compression/zsync { };

  zxing = callPackage ../tools/graphics/zxing {};


  ### SHELLS

  bash = lowPrio (callPackage ../shells/bash {
    texinfo = null;
    interactive = stdenv.isCygwin; # patch for cygwin requires readline support
  });

  bashInteractive = appendToName "interactive" (callPackage ../shells/bash {
    interactive = true;
  });

  bashCompletion = callPackage ../shells/bash-completion { };

  dash = callPackage ../shells/dash { };

  es = callPackage ../shells/es { };

  fish = callPackage ../shells/fish {
    python = python27Full;
  };

  fish-foreign-env = callPackage ../shells/fish-foreign-env { };

  mksh = callPackage ../shells/mksh { };

  oh = goPackages.oh.bin // { outputs = [ "bin" ]; };

  pash = callPackage ../shells/pash { };

  tcsh = callPackage ../shells/tcsh { };

  rush = callPackage ../shells/rush { };

  xonsh = callPackage ../shells/xonsh { };

  zsh = callPackage ../shells/zsh { };

  nix-zsh-completions = callPackage ../shells/nix-zsh-completions { };

  grml-zsh-config = callPackage ../shells/grml-zsh-config { };


  ### DEVELOPMENT / COMPILERS

  abc = callPackage ../development/compilers/abc/default.nix { };

  aldor = callPackage ../development/compilers/aldor { };

  aliceml = callPackage ../development/compilers/aliceml { };

  arachne-pnr = callPackage ../development/compilers/arachne-pnr { };

  aspectj = callPackage ../development/compilers/aspectj { };

  ats = callPackage ../development/compilers/ats { };
  ats2 = callPackage ../development/compilers/ats2 { };

  avra = callPackage ../development/compilers/avra { };

  bigloo = callPackage ../development/compilers/bigloo {
    stdenv = overrideCC stdenv gcc49;
  };

  boo = callPackage ../development/compilers/boo {
    inherit (gnome) gtksourceview;
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

  clang = llvmPackages.clang;

  clang_38 = llvmPackages_38.clang;
  clang_37 = llvmPackages_37.clang;
  clang_36 = llvmPackages_36.clang;
  clang_35 = wrapCC llvmPackages_35.clang;
  clang_34 = wrapCC llvmPackages_34.clang;

  clang-analyzer = callPackage ../development/tools/analysis/clang-analyzer {
    clang = clang_34;
    llvmPackages = llvmPackages_34;
  };

  clangUnwrapped = llvm: pkg: callPackage pkg { inherit llvm; };

  clangSelf = self.clangWrapSelf llvmPackagesSelf.clang;

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
  libcxxStdenv = stdenvAdapters.overrideCC stdenv (clangWrapSelf llvmPackages.clang-unwrapped);

  clean = callPackage ../development/compilers/clean { };

  closurecompiler = callPackage ../development/compilers/closure { };

  cmdstan = callPackage ../development/compilers/cmdstan { };

  cmucl_binary = callPackage_i686 ../development/compilers/cmucl/binary.nix { };

  compcert = callPackage ../development/compilers/compcert ((
    if system == "x86_64-linux"
    then { tools = pkgsi686Linux.stdenv.cc; }
    else {}
  ) // {
    ocamlPackages = ocamlPackages_4_02;
  });

  cryptol = self.haskellPackages.cryptol;

  cython = pythonPackages.cython;
  cython3 = python3Packages.cython;

  devpi-client = callPackage ../development/tools/devpi-client {};

  ecl = callPackage ../development/compilers/ecl { };

  eql = callPackage ../development/compilers/eql {};

  elmPackages = recurseIntoAttrs (callPackage ../development/compilers/elm { });

  adobe_flex_sdk = callPackage ../development/compilers/adobe-flex-sdk { };

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { };

  gcc = gcc5;

  gcc_multi =
    if system == "x86_64-linux" then lowPrio (
      let
        extraBuildCommands = ''
          echo "dontMoveLib64=1" >> $out/nix-support/setup-hook
        '';
      in wrapCCWith (callPackage ../build-support/cc-wrapper) glibc_multi extraBuildCommands (gcc.cc.override {
        stdenv = overrideCC stdenv (wrapCCWith (callPackage ../build-support/cc-wrapper) glibc_multi "" gcc.cc);
        profiledCompiler = false;
        enableMultilib = true;
      }))
    else throw "Multilib gcc not supported on ‘${system}’";

  gcc_debug = lowPrio (wrapCC (gcc.cc.override {
    stripped = false;
  }));

  gccApple = throw "gccApple is no longer supported";

  gccCrossStageStatic = let
    libcCross1 =
      if stdenv.cross.libc == "msvcrt" then windows.mingw_w64_headers
      else if stdenv.cross.libc == "libSystem" then darwin.xcode
      else null;
    in wrapGCCCross {
      gcc = forceNativeDrv (gcc.cc.override {
        cross = crossSystem;
        crossStageStatic = true;
        langCC = false;
        libcCross = libcCross1;
        enableShared = false;
      });
      libc = libcCross1;
      binutils = binutilsCross;
      cross = crossSystem;
  };

  # Only needed for mingw builds
  gccCrossMingw2 = wrapGCCCross {
    gcc = gccCrossStageStatic.gcc;
    libc = windows.mingw_headers2;
    binutils = binutilsCross;
    cross = assert crossSystem != null; crossSystem;
  };

  gccCrossStageFinal = wrapGCCCross {
    gcc = forceNativeDrv (gcc.cc.override {
      cross = crossSystem;
      crossStageStatic = false;

      # XXX: We have troubles cross-compiling libstdc++ on MinGW (see
      # <http://hydra.nixos.org/build/4268232>), so don't even try.
      langCC = crossSystem.config != "i686-pc-mingw32";
    });
    libc = libcCross;
    binutils = binutilsCross;
    cross = crossSystem;
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
    libcCross = if crossSystem != null then libcCross else null;
  }));

  gcc46 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.6 {
    inherit noSysDirs;

    ppl = null;
    cloog = null;

    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = false;

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    texinfo = texinfo413;
  }));

  gcc48 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.8 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isSunOS && !isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;

    isl = isl_0_14;
  }));

  gcc49 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/4.9 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;

    isl = isl_0_11;

    cloog = cloog_0_18_0;
  }));

  gcc5 = lowPrio (wrapCC (callPackage ../development/compilers/gcc/5 {
    inherit noSysDirs;

    # PGO seems to speed up compilation by gcc by ~10%, see #445 discussion
    profiledCompiler = with stdenv; (!isDarwin && (isi686 || isx86_64));

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;

    isl = isl_0_14;
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

  gcj = gcj49;
  gcj49 = wrapCC (gcc49.cc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig perl;
    inherit gtk;
    inherit (gnome) libart_lgpl;
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

  gccgo48 = wrapCC (gcc48.cc.override {
    name = "gccgo";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
  });

  gccgo49 = wrapCC (gcc49.cc.override {
    name = "gccgo49";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
    profiledCompiler = false;
  });

  ghdl_mcode = callPackage ../development/compilers/ghdl { };

  gcl = callPackage ../development/compilers/gcl {
    gmp = gmp4;
  };

  gcc-arm-embedded-4_7 = callPackage_i686 ../development/compilers/gcc-arm-embedded {
    version = "4.7-2013q3-20130916";
    releaseType = "update";
    sha256 = "1bd9bi9q80xn2rpy0rn1vvj70rh15kb7dmah0qs4q2rv78fqj40d";
  };
  gcc-arm-embedded-4_8 = callPackage_i686 ../development/compilers/gcc-arm-embedded {
    version = "4.8-2014q1-20140314";
    releaseType = "update";
    sha256 = "ce92859550819d4a3d1a6e2672ea64882b30afa2c08cf67fa8e1d93788c2c577";
  };
  gcc-arm-embedded-4_9 = callPackage_i686 ../development/compilers/gcc-arm-embedded {
    version = "4.9-2015q1-20150306";
    releaseType = "update";
    sha256 = "c5e0025b065750bbd76b5357b4fc8606d88afbac9ff55b8a82927b4b96178154";
  };
  gcc-arm-embedded = self.gcc-arm-embedded-4_9;

  gforth = callPackage ../development/compilers/gforth {};

  gtk-server = callPackage ../development/interpreters/gtk-server {};

  # Haskell and GHC

  haskell = callPackage ./haskell-packages.nix { };

  haskellPackages = haskell.packages.ghc7103.override {
    overrides = config.haskellPackageOverrides or (self: super: {});
  };
  inherit (self.haskellPackages) ghc cabal-install stack;

  haxe = callPackage ../development/compilers/haxe {
    inherit (ocamlPackages) camlp4;
  };
  hxcpp = callPackage ../development/compilers/haxe/hxcpp.nix { };

  hhvm = callPackage ../development/compilers/hhvm { };
  hiphopvm = self.hhvm; /* Compatibility alias */

  hop = callPackage ../development/compilers/hop { };

  falcon = callPackage ../development/interpreters/falcon { };

  fsharp = callPackage ../development/compilers/fsharp {};

  fstar = callPackage ../development/compilers/fstar {
    ocamlPackages = ocamlPackages_4_02;
  };

  dotnetPackages = recurseIntoAttrs (callPackage ./dotnet-packages.nix {});

  go_1_4 = callPackage ../development/compilers/go/1.4.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  go_1_5 = callPackage ../development/compilers/go/1.5.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go_1_6 = callPackage ../development/compilers/go/1.6.nix {
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  };

  go = self.go_1_5;

  go-repo-root = goPackages.go-repo-root.bin // { outputs = [ "bin" ]; };

  gox = goPackages.gox.bin // { outputs = [ "bin" ]; };

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  icedtea7_web = callPackage ../development/compilers/icedtea-web {
    jdk = jdk7;
    xulrunner = firefox-unwrapped;
  };

  icedtea8_web = callPackage ../development/compilers/icedtea-web {
    jdk = jdk8;
    xulrunner = firefox-unwrapped;
  };

  icedtea_web = self.icedtea8_web;

  idrisPackages = callPackage ../development/idris-modules {
    inherit (haskellPackages) idris;
  };

  ikarus = callPackage ../development/compilers/ikarus { };

  intercal = callPackage ../development/compilers/intercal { };

  hugs = callPackage ../development/interpreters/hugs { };

  path64 = callPackage ../development/compilers/path64 { };

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
      };

  openjdk = if stdenv.isDarwin then self.openjdk7 else self.openjdk8;

  jdk7 = self.openjdk7 // { outputs = [ "out" ]; };
  jre7 = lib.setName "openjre-${lib.getVersion pkgs.openjdk7.jre}" (self.openjdk7.jre // { outputs = [ "jre" ]; });

  jdk8 = self.openjdk8 // { outputs = [ "out" ]; };
  jre8 = lib.setName "openjre-${lib.getVersion pkgs.openjdk8.jre}" (self.openjdk8.jre // { outputs = [ "jre" ]; });

  jdk = if stdenv.isDarwin then self.jdk7 else self.jdk8;
  jre = if stdenv.isDarwin then self.jre7 else self.jre8;

  oraclejdk = self.jdkdistro true false;

  oraclejdk7 = self.oraclejdk7distro true false;

  oraclejdk7psu = self.oraclejdk7psu_distro true false;

  oraclejdk8 = self.oraclejdk8distro true false;

  oraclejdk8psu = self.oraclejdk8psu_distro true false;

  oraclejre = lowPrio (self.jdkdistro false false);

  oraclejre7 = lowPrio (self.oraclejdk7distro false false);

  oraclejre7psu = lowPrio (self.oraclejdk7psu_distro false false);

  oraclejre8 = lowPrio (self.oraclejdk8distro false false);

  oraclejre8psu = lowPrio (self.oraclejdk8psu_distro false false);

  jrePlugin = self.jre8Plugin;

  jre6Plugin = lowPrio (self.jdkdistro false true);

  jre7Plugin = lowPrio (self.oraclejdk7distro false true);

  jre8Plugin = lowPrio (self.oraclejdk8distro false true);

  supportsJDK =
    system == "i686-linux" ||
    system == "x86_64-linux";

  jdkdistro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk6-linux.nix { });

  oraclejdk7distro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk7-linux.nix { inherit installjdk; });

  oraclejdk7psu_distro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk7psu-linux.nix { inherit installjdk; });

  oraclejdk8distro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8-linux.nix { inherit installjdk; });

  oraclejdk8psu_distro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "with-plugin" else x: x)
      (callPackage ../development/compilers/oraclejdk/jdk8psu-linux.nix { inherit installjdk; });

  jikes = callPackage ../development/compilers/jikes { };

  julia = callPackage ../development/compilers/julia {
    gmp = gmp6;
    openblas = openblasCompat;
    inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  };

  julia-git = lowPrio (callPackage ../development/compilers/julia/git.nix {
    gmp = gmp6;
    llvm = llvm_37;
    openblas = openblasCompat;
  });

  kotlin = callPackage ../development/compilers/kotlin { };

  lazarus = callPackage ../development/compilers/fpc/lazarus.nix {
    fpc = fpc;
  };

  lessc = callPackage ../development/compilers/lessc { };

  liquibase = callPackage ../development/tools/database/liquibase { };

  llvm = self.llvmPackages.llvm;

  llvm_38 = self.llvmPackages_38.llvm;
  llvm_37 = self.llvmPackages_37.llvm;
  llvm_36 = self.llvmPackages_36.llvm;
  llvm_35 = self.llvmPackages_35.llvm;
  llvm_34 = self.llvmPackages_34.llvm;

  llvmPackages = recurseIntoAttrs self.llvmPackages_37;

  llvmPackagesSelf = self.llvmPackages_34.override {
    stdenv = libcxxStdenv;
  };

  llvmPackages_34 = callPackage ../development/compilers/llvm/3.4 {
    isl = isl_0_12;
  };

  llvmPackages_35 = callPackage ../development/compilers/llvm/3.5 {
    isl = isl_0_14;
  };

  llvmPackages_36 = callPackage ../development/compilers/llvm/3.6 {
    inherit (stdenvAdapters) overrideCC;
  };

  llvmPackages_37 = callPackage ../development/compilers/llvm/3.7 {
    inherit (stdenvAdapters) overrideCC;
  };

  llvmPackages_38 = callPackage ../development/compilers/llvm/3.8 {
    inherit (stdenvAdapters) overrideCC;
  };

  manticore = callPackage ../development/compilers/manticore { };

  mentorToolchains = recurseIntoAttrs (
    callPackage_i686 ../development/compilers/mentor {}
  );

  mercury = callPackage ../development/compilers/mercury { };

  microscheme = callPackage ../development/compilers/microscheme { };

  mitscheme = callPackage ../development/compilers/mit-scheme { };

  mkcl = callPackage ../development/compilers/mkcl {};

  mlton = callPackage ../development/compilers/mlton { };

  mono = callPackage ../development/compilers/mono {
    inherit (darwin) libobjc;
    inherit (darwin.apple_sdk.frameworks) Foundation;
  };

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  mozart-binary = callPackage ../development/compilers/mozart/binary.nix { };
  mozart = mozart-binary;

  nim = callPackage ../development/compilers/nim { };
  nimble = callPackage ../development/tools/nimble { };

  neko = callPackage ../development/compilers/neko { };

  nasm = callPackage ../development/compilers/nasm { };

  nvidia_cg_toolkit = callPackage ../development/compilers/nvidia-cg-toolkit { };

  ocaml = ocamlPackages.ocaml;

  ocaml_3_08_0 = callPackage ../development/compilers/ocaml/3.08.0.nix { };

  ocaml_3_10_0 = callPackage ../development/compilers/ocaml/3.10.0.nix { };

  ocaml_3_11_2 = callPackage ../development/compilers/ocaml/3.11.2.nix { };

  ocaml_3_12_1 = callPackage ../development/compilers/ocaml/3.12.1.nix { };

  ocaml_4_00_1 = callPackage ../development/compilers/ocaml/4.00.1.nix { };

  ocaml_4_01_0 = callPackage ../development/compilers/ocaml/4.01.0.nix { };

  ocaml_4_02 = callPackage ../development/compilers/ocaml/4.02.nix { };

  orc = callPackage ../development/compilers/orc { };

  metaocaml_3_09 = callPackage ../development/compilers/ocaml/metaocaml-3.09.nix { };

  ber_metaocaml_003 = callPackage ../development/compilers/ocaml/ber-metaocaml-003.nix { };

  mkOcamlPackages = ocaml: self:
    let
      callPackage = newScope self;
      ocaml_version = (builtins.parseDrvName ocaml.name).version;
    in rec {
    inherit ocaml;
    buildOcaml = callPackage ../build-support/ocaml { };

    acgtk = callPackage ../applications/science/logic/acgtk { };

    alcotest = callPackage ../development/ocaml-modules/alcotest {};

    ansiterminal = callPackage ../development/ocaml-modules/ansiterminal { };

    asn1-combinators = callPackage ../development/ocaml-modules/asn1-combinators { };

    async_extra = callPackage ../development/ocaml-modules/async_extra { };

    async_find = callPackage ../development/ocaml-modules/async_find { };

    async_kernel = callPackage ../development/ocaml-modules/async_kernel { };

    async_shell = callPackage ../development/ocaml-modules/async_shell { };

    async_ssl = callPackage ../development/ocaml-modules/async_ssl { };

    async_unix = callPackage ../development/ocaml-modules/async_unix { };

    async =
      if lib.versionOlder "4.02" ocaml_version
      then callPackage ../development/ocaml-modules/async { }
      else null;

    atd = callPackage ../development/ocaml-modules/atd { };

    atdgen = callPackage ../development/ocaml-modules/atdgen { };

    base64 = callPackage ../development/ocaml-modules/base64 { };

    bolt = callPackage ../development/ocaml-modules/bolt { };

    bitstring_2_0_4 = callPackage ../development/ocaml-modules/bitstring/2.0.4.nix { };
    bitstring_git   = callPackage ../development/ocaml-modules/bitstring { };

    bitstring =
      if lib.versionOlder "4.02" ocaml_version
      then bitstring_git
      else bitstring_2_0_4;

    camlidl = callPackage ../development/tools/ocaml/camlidl { };

    camlp4 =
      if lib.versionOlder "4.02" ocaml_version
      then callPackage ../development/tools/ocaml/camlp4 { }
      else null;

    camlp5_old_strict =
      if lib.versionOlder "4.00" ocaml_version
      then camlp5_6_strict
      else callPackage ../development/tools/ocaml/camlp5/5.15.nix { };

    camlp5_old_transitional =
      if lib.versionOlder "4.00" ocaml_version
      then camlp5_6_transitional
      else callPackage ../development/tools/ocaml/camlp5/5.15.nix {
        transitional = true;
      };

    camlp5_6_strict = callPackage ../development/tools/ocaml/camlp5 { };

    camlp5_6_transitional = callPackage ../development/tools/ocaml/camlp5 {
      transitional = true;
    };

    camlp5_strict = camlp5_6_strict;

    camlp5_transitional = camlp5_6_transitional;

    camlpdf = callPackage ../development/ocaml-modules/camlpdf { };

    calendar = callPackage ../development/ocaml-modules/calendar { };

    camlzip = callPackage ../development/ocaml-modules/camlzip { };

    camomile_0_8_2 = callPackage ../development/ocaml-modules/camomile/0.8.2.nix { };
    camomile = callPackage ../development/ocaml-modules/camomile { };

    camlimages_4_0 = callPackage ../development/ocaml-modules/camlimages/4.0.nix {
      libpng = libpng12;
      giflib = giflib_4_1;
    };
    camlimages_4_1 = callPackage ../development/ocaml-modules/camlimages/4.1.nix {
      giflib = giflib_4_1;
    };
    camlimages = camlimages_4_1;

    conduit = callPackage ../development/ocaml-modules/conduit {
       lwt = ocaml_lwt;
    };

    biniou = callPackage ../development/ocaml-modules/biniou { };

    bin_prot = callPackage ../development/ocaml-modules/bin_prot { };

    ocaml_cairo = callPackage ../development/ocaml-modules/ocaml-cairo { };

    ocaml_cairo2 = callPackage ../development/ocaml-modules/ocaml-cairo2 { };

    cil = callPackage ../development/ocaml-modules/cil { };

    cmdliner = callPackage ../development/ocaml-modules/cmdliner { };

    cohttp = callPackage ../development/ocaml-modules/cohttp {
      lwt = ocaml_lwt;
    };

    config-file = callPackage ../development/ocaml-modules/config-file { };

    containers = callPackage ../development/ocaml-modules/containers { };

    cpdf = callPackage ../development/ocaml-modules/cpdf { };

    cppo = callPackage ../development/tools/ocaml/cppo { };

    cryptokit = callPackage ../development/ocaml-modules/cryptokit { };

    cstruct = callPackage ../development/ocaml-modules/cstruct {
      lwt = ocaml_lwt;
    };

    csv = callPackage ../development/ocaml-modules/csv { };

    custom_printf = callPackage ../development/ocaml-modules/custom_printf { };

    ctypes = callPackage ../development/ocaml-modules/ctypes { };

    dolog = callPackage ../development/ocaml-modules/dolog { };

    easy-format = callPackage ../development/ocaml-modules/easy-format { };

    eff = callPackage ../development/interpreters/eff { };

    eliom = callPackage ../development/ocaml-modules/eliom { };

    enumerate = callPackage ../development/ocaml-modules/enumerate { };

    erm_xml = callPackage ../development/ocaml-modules/erm_xml { };

    erm_xmpp = callPackage ../development/ocaml-modules/erm_xmpp { };

    ezjsonm = callPackage ../development/ocaml-modules/ezjsonm {
      lwt = ocaml_lwt;
    };

    faillib = callPackage ../development/ocaml-modules/faillib { };

    fieldslib = callPackage ../development/ocaml-modules/fieldslib { };

    fileutils = callPackage ../development/ocaml-modules/fileutils { };

    findlib = callPackage ../development/tools/ocaml/findlib { };

    fix = callPackage ../development/ocaml-modules/fix { };

    fontconfig = callPackage ../development/ocaml-modules/fontconfig {
      inherit (pkgs) fontconfig;
    };

    functory = callPackage ../development/ocaml-modules/functory { };

    gen = callPackage ../development/ocaml-modules/gen { };

    herelib = callPackage ../development/ocaml-modules/herelib { };

    io-page = callPackage ../development/ocaml-modules/io-page { };

    ipaddr = callPackage ../development/ocaml-modules/ipaddr { };

    iso8601 = callPackage ../development/ocaml-modules/iso8601 { };

    javalib = callPackage ../development/ocaml-modules/javalib {
      extlib = ocaml_extlib_maximal;
    };

    dypgen = callPackage ../development/ocaml-modules/dypgen { };

    patoline = callPackage ../tools/typesetting/patoline { };

    gapi_ocaml = callPackage ../development/ocaml-modules/gapi-ocaml { };

    gg = callPackage ../development/ocaml-modules/gg { };

    gmetadom = callPackage ../development/ocaml-modules/gmetadom { };

    gtktop = callPackage ../development/ocaml-modules/gtktop { };

    hex = callPackage ../development/ocaml-modules/hex { };

    jingoo = callPackage ../development/ocaml-modules/jingoo {
      batteries = ocaml_batteries;
      pcre = ocaml_pcre;
    };

    js_of_ocaml = callPackage ../development/tools/ocaml/js_of_ocaml { };

    jsonm = callPackage ../development/ocaml-modules/jsonm { };

    lablgl = callPackage ../development/ocaml-modules/lablgl { };

    lablgtk_2_14 = callPackage ../development/ocaml-modules/lablgtk/2.14.0.nix {
      inherit (gnome) libgnomecanvas libglade gtksourceview;
    };
    lablgtk = callPackage ../development/ocaml-modules/lablgtk {
      inherit (gnome) libgnomecanvas libglade gtksourceview;
    };

    lablgtk-extras =
      if lib.versionOlder "4.02" ocaml_version
      then callPackage ../development/ocaml-modules/lablgtk-extras { }
      else callPackage ../development/ocaml-modules/lablgtk-extras/1.4.nix { };

    lablgtkmathview = callPackage ../development/ocaml-modules/lablgtkmathview {
      gtkmathview = callPackage ../development/libraries/gtkmathview { };
    };

    lambdaTerm-1_6 = callPackage ../development/ocaml-modules/lambda-term/1.6.nix { };
    lambdaTerm =
      if lib.versionOlder "4.01" ocaml_version
      then callPackage ../development/ocaml-modules/lambda-term { }
      else lambdaTerm-1_6;

    llvm = callPackage ../development/ocaml-modules/llvm {
      llvm = pkgs.llvm_37;
    };

    macaque = callPackage ../development/ocaml-modules/macaque { };

    magic-mime = callPackage ../development/ocaml-modules/magic-mime { };

    magick = callPackage ../development/ocaml-modules/magick { };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    merlin = callPackage ../development/tools/ocaml/merlin { };

    mezzo = callPackage ../development/compilers/mezzo { };

    mlgmp =  callPackage ../development/ocaml-modules/mlgmp { };

    nocrypto =  callPackage ../development/ocaml-modules/nocrypto { };

    ocaml_batteries = callPackage ../development/ocaml-modules/batteries { };

    comparelib = callPackage ../development/ocaml-modules/comparelib { };

    core_extended = callPackage ../development/ocaml-modules/core_extended { };

    core_kernel = callPackage ../development/ocaml-modules/core_kernel { };

    core = callPackage ../development/ocaml-modules/core { };

    ocaml_cryptgps = callPackage ../development/ocaml-modules/cryptgps { };

    ocaml_data_notation = callPackage ../development/ocaml-modules/odn { };

    ocaml_expat = callPackage ../development/ocaml-modules/expat { };

    ocamlfuse = callPackage ../development/ocaml-modules/ocamlfuse { };

    ocamlgraph = callPackage ../development/ocaml-modules/ocamlgraph { };

    ocaml_http = callPackage ../development/ocaml-modules/http { };

    ocamlify = callPackage ../development/tools/ocaml/ocamlify { };

    ocaml_lwt = callPackage ../development/ocaml-modules/lwt { };

    ocamlmod = callPackage ../development/tools/ocaml/ocamlmod { };

    ocaml_mysql = callPackage ../development/ocaml-modules/mysql { };

    ocamlnet = callPackage ../development/ocaml-modules/ocamlnet { };

    ocaml_oasis = callPackage ../development/tools/ocaml/oasis { };

    ocaml_optcomp = callPackage ../development/ocaml-modules/optcomp { };

    ocaml_pcre = callPackage ../development/ocaml-modules/pcre {};

    pgocaml = callPackage ../development/ocaml-modules/pgocaml {};

    ocaml_react = callPackage ../development/ocaml-modules/react { };
    reactivedata = callPackage ../development/ocaml-modules/reactivedata {};

    ocamlscript = callPackage ../development/tools/ocaml/ocamlscript { };

    ocamlsdl= callPackage ../development/ocaml-modules/ocamlsdl { };

    ocaml_sqlite3 = callPackage ../development/ocaml-modules/sqlite3 { };

    ocaml_ssl = callPackage ../development/ocaml-modules/ssl { };

    ocaml_text = callPackage ../development/ocaml-modules/ocaml-text { };

    ocpBuild = callPackage ../development/tools/ocaml/ocp-build { };

    ocpIndent = callPackage ../development/tools/ocaml/ocp-indent { };

    ocp-index = callPackage ../development/tools/ocaml/ocp-index { };

    ocplib-endian = callPackage ../development/ocaml-modules/ocplib-endian { };

    ocsigen_server = callPackage ../development/ocaml-modules/ocsigen-server { };

    ojquery = callPackage ../development/ocaml-modules/ojquery { };

    otfm = callPackage ../development/ocaml-modules/otfm { };

    ounit = callPackage ../development/ocaml-modules/ounit { };

    piqi = callPackage ../development/ocaml-modules/piqi { };
    piqi-ocaml = callPackage ../development/ocaml-modules/piqi-ocaml { };

    re2 = callPackage ../development/ocaml-modules/re2 { };

    result = callPackage ../development/ocaml-modules/ocaml-result { };

    sequence = callPackage ../development/ocaml-modules/sequence { };

    tuntap = callPackage ../development/ocaml-modules/tuntap { };

    tyxml = callPackage ../development/ocaml-modules/tyxml { };

    ulex = callPackage ../development/ocaml-modules/ulex { };

    ulex08 = callPackage ../development/ocaml-modules/ulex/0.8 {
      camlp5 = camlp5_transitional;
    };

    textutils = callPackage ../development/ocaml-modules/textutils { };

    type_conv_108_08_00 = callPackage ../development/ocaml-modules/type_conv/108.08.00.nix { };
    type_conv_109_60_01 = callPackage ../development/ocaml-modules/type_conv/109.60.01.nix { };
    type_conv_112_01_01 = callPackage ../development/ocaml-modules/type_conv/112.01.01.nix { };
    type_conv =
      if lib.versionOlder "4.02" ocaml_version
      then type_conv_112_01_01
      else if lib.versionOlder "4.00" ocaml_version
      then type_conv_109_60_01
      else if lib.versionOlder "3.12" ocaml_version
      then type_conv_108_08_00
      else null;

    sexplib_108_08_00 = callPackage ../development/ocaml-modules/sexplib/108.08.00.nix { };
    sexplib_111_25_00 = callPackage ../development/ocaml-modules/sexplib/111.25.00.nix { };
    sexplib_112_24_01 = callPackage ../development/ocaml-modules/sexplib/112.24.01.nix { };

    sexplib =
      if lib.versionOlder "4.02" ocaml_version
      then sexplib_112_24_01
      else if lib.versionOlder "4.00" ocaml_version
      then sexplib_111_25_00
      else if lib.versionOlder "3.12" ocaml_version
      then sexplib_108_08_00
      else null;

    ocaml_extlib = callPackage ../development/ocaml-modules/extlib { };
    ocaml_extlib_maximal = callPackage ../development/ocaml-modules/extlib {
      minimal = false;
    };

    ocurl = callPackage ../development/ocaml-modules/ocurl { };

    pa_ounit = callPackage ../development/ocaml-modules/pa_ounit { };

    pa_bench = callPackage ../development/ocaml-modules/pa_bench { };

    pa_test = callPackage ../development/ocaml-modules/pa_test { };

    pipebang = callPackage ../development/ocaml-modules/pipebang { };

    pprint = callPackage ../development/ocaml-modules/pprint { };

    ppx_tools =
      if lib.versionAtLeast ocaml_version "4.02"
      then callPackage ../development/ocaml-modules/ppx_tools {}
      else null;

    pycaml = callPackage ../development/ocaml-modules/pycaml { };

    qcheck = callPackage ../development/ocaml-modules/qcheck {
      oasis = ocaml_oasis;
    };

    qtest = callPackage ../development/ocaml-modules/qtest {
      oasis = ocaml_oasis;
    };

    re = callPackage ../development/ocaml-modules/re { };

    safepass = callPackage ../development/ocaml-modules/safepass { };

    sqlite3EZ = callPackage ../development/ocaml-modules/sqlite3EZ { };

    stringext = callPackage ../development/ocaml-modules/stringext { };

    tsdl = callPackage ../development/ocaml-modules/tsdl { };

    twt = callPackage ../development/ocaml-modules/twt { };

    typerep = callPackage ../development/ocaml-modules/typerep { };

    utop = callPackage ../development/tools/ocaml/utop { };

    uuidm = callPackage ../development/ocaml-modules/uuidm { };

    sawja = callPackage ../development/ocaml-modules/sawja { };

    uucd = callPackage ../development/ocaml-modules/uucd { };
    uucp = callPackage ../development/ocaml-modules/uucp { };
    uunf = callPackage ../development/ocaml-modules/uunf { };

    uri = callPackage ../development/ocaml-modules/uri { };

    uuseg = callPackage ../development/ocaml-modules/uuseg { };
    uutf = callPackage ../development/ocaml-modules/uutf { };

    variantslib = callPackage ../development/ocaml-modules/variantslib { };

    vg = callPackage ../development/ocaml-modules/vg { };

    x509 = callPackage ../development/ocaml-modules/x509 { };

    xmlm = callPackage ../development/ocaml-modules/xmlm { };

    xml-light = callPackage ../development/ocaml-modules/xml-light { };

    yojson = callPackage ../development/ocaml-modules/yojson { };

    zarith = callPackage ../development/ocaml-modules/zarith { };

    zed = callPackage ../development/ocaml-modules/zed { };

    ocsigen_deriving = callPackage ../development/ocaml-modules/ocsigen-deriving {
      oasis = ocaml_oasis;
    };

  };

  ocamlPackages = recurseIntoAttrs ocamlPackages_4_01_0;
  ocamlPackages_3_10_0 = (mkOcamlPackages ocaml_3_10_0 pkgs.ocamlPackages_3_10_0)
  // { lablgtk = ocamlPackages_3_10_0.lablgtk_2_14; };
  ocamlPackages_3_11_2 = (mkOcamlPackages ocaml_3_11_2 pkgs.ocamlPackages_3_11_2)
  // { lablgtk = ocamlPackages_3_11_2.lablgtk_2_14; };
  ocamlPackages_3_12_1 = (mkOcamlPackages ocaml_3_12_1 pkgs.ocamlPackages_3_12_1)
  // { camlimages = ocamlPackages_3_12_1.camlimages_4_0; };
  ocamlPackages_4_00_1 = mkOcamlPackages ocaml_4_00_1 pkgs.ocamlPackages_4_00_1;
  ocamlPackages_4_01_0 = mkOcamlPackages ocaml_4_01_0 pkgs.ocamlPackages_4_01_0;
  ocamlPackages_4_02 = mkOcamlPackages ocaml_4_02 pkgs.ocamlPackages_4_02;
  ocamlPackages_latest = ocamlPackages_4_02;

  ocaml_make = callPackage ../development/ocaml-modules/ocamlmake { };

  ocaml-top = callPackage ../development/tools/ocaml/ocaml-top { };

  opa = callPackage ../development/compilers/opa {
    nodejs = nodejs-0_10;
  };

  opam_1_0_0 = callPackage ../development/tools/ocaml/opam/1.0.0.nix { };
  opam_1_1 = callPackage ../development/tools/ocaml/opam/1.1.nix {
    inherit (ocamlPackages_4_01_0) ocaml;
  };
  opam = callPackage ../development/tools/ocaml/opam { };

  ocamlnat = newScope pkgs.ocamlPackages_3_12_1 ../development/ocaml-modules/ocamlnat { };

  ponyc = callPackage ../development/compilers/ponyc {
    llvm = llvm_36;
  };

  qcmm = callPackage ../development/compilers/qcmm {
    lua   = lua4;
    ocaml = ocaml_3_08_0;
  };

  rgbds = callPackage ../development/compilers/rgbds { };

  rtags = callPackage ../development/tools/rtags/default.nix {};

  rustcMaster = callPackage ../development/compilers/rustc/head.nix {};
  rustc = callPackage ../development/compilers/rustc {};

  rustPlatform = rustStable;

  rustStable = recurseIntoAttrs (makeRustPlatform cargo rustStable);
  rustUnstable = recurseIntoAttrs (makeRustPlatform cargoUnstable rustUnstable);

  # rust platform to build cargo itself (with cargoSnapshot)
  rustCargoPlatform = makeRustPlatform (cargoSnapshot rustc) rustCargoPlatform;
  rustUnstableCargoPlatform = makeRustPlatform (cargoSnapshot rustcMaster) rustUnstableCargoPlatform;

  makeRustPlatform = cargo: self:
    let
      callPackage = newScope self;
    in {
      inherit cargo;

      rustc = cargo.rustc;

      rustRegistry = callPackage ./rust-packages.nix { };

      buildRustPackage = callPackage ../build-support/rust {
        inherit cargo;
      };
    };

  rustfmt = callPackage ../development/tools/rust/rustfmt { };

  sbclBootstrap = callPackage ../development/compilers/sbcl/bootstrap.nix {};
  sbcl = callPackage ../development/compilers/sbcl {};
  # For StumpWM
  sbcl_1_2_5 = callPackage ../development/compilers/sbcl/1.2.5.nix {
    clisp = clisp;
  };
  # For ACL2
  sbcl_1_2_0 = callPackage ../development/compilers/sbcl/1.2.0.nix {
    clisp = clisp;
  };

  scala_2_9 = callPackage ../development/compilers/scala/2.9.nix { };
  scala_2_10 = callPackage ../development/compilers/scala/2.10.nix { };
  scala_2_11 = callPackage ../development/compilers/scala { };
  scala = scala_2_11;

  sdcc = callPackage ../development/compilers/sdcc { boost = boost159; };

  smlnjBootstrap = callPackage ../development/compilers/smlnj/bootstrap.nix { };
  smlnj = if stdenv.isDarwin
            then callPackage ../development/compilers/smlnj { }
            else callPackage_i686 ../development/compilers/smlnj { };

  sqldeveloper = callPackage ../development/tools/database/sqldeveloper { };

  squeak = callPackage ../development/compilers/squeak { };

  stalin = callPackage ../development/compilers/stalin { };

  strategoPackages = recurseIntoAttrs strategoPackages018;

  strategoPackages016 = callPackage ../development/compilers/strategoxt/0.16.nix {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strategoPackages017 = callPackage ../development/compilers/strategoxt/0.17.nix {
    readline = readline5;
  };

  strategoPackages018 = callPackage ../development/compilers/strategoxt/0.18.nix {
    readline = readline5;
  };

  metaBuildEnv = callPackage ../development/compilers/meta-environment/meta-build-env { };

  swiProlog = callPackage ../development/compilers/swi-prolog { };

  tbb = callPackage ../development/libraries/tbb { };

  terra = callPackage ../development/compilers/terra {
    llvm = llvmPackages_35.llvm.override { enableSharedLibraries = false; };
    clang = clang_35;
    lua = lua5_1;
  };

  teyjus = callPackage ../development/compilers/teyjus {
    omake = omake_rc1;
  };

  thrust = callPackage ../development/tools/thrust {
    gconf = pkgs.gnome.GConf;
  };

  tinycc = callPackage ../development/compilers/tinycc { };

  trv = callPackage ../development/tools/misc/trv {
   inherit (ocamlPackages_4_02) findlib camlp4 core async async_unix
     async_extra sexplib async_shell core_extended async_find cohttp uri;
    ocaml = ocaml_4_02;
  };

  urweb = callPackage ../development/compilers/urweb { };

  vala = callPackage ../development/compilers/vala/default.nix { };

  vala_0_26 = callPackage ../development/compilers/vala/0.26.nix { };

  vala_0_28 = callPackage ../development/compilers/vala/0.28.nix { };

  visualcpp = callPackage ../development/compilers/visual-c++ { };

  vs90wrapper = callPackage ../development/compilers/vs90wrapper { };

  webdsl = callPackage ../development/compilers/webdsl { };

  win32hello = callPackage ../development/compilers/visual-c++/test { };

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

  wrapCC = wrapCCWith (callPackage ../build-support/cc-wrapper) stdenv.cc.libc "";
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

    forceNativeDrv (callPackage ../build-support/gcc-cross-wrapper {
      nativeTools = false;
      nativeLibc = false;
      noLibc = (libc == null);
      inherit gcc binutils libc shell name cross;
    });

  # prolog
  yap = callPackage ../development/compilers/yap { };

  yasm = callPackage ../development/compilers/yasm { };

  yosys = callPackage ../development/compilers/yosys { };


  ### DEVELOPMENT / INTERPRETERS

  acl2 = callPackage ../development/interpreters/acl2 {
    sbcl = sbcl_1_2_0;
  };

  angelscript = callPackage ../development/interpreters/angelscript {};

  chibi = callPackage ../development/interpreters/chibi { };

  ceptre = callPackage ../development/interpreters/ceptre { };

  clisp = callPackage ../development/interpreters/clisp { };

  # compatibility issues in 2.47 - at list 2.44.1 is known good
  # for sbcl bootstrap.
  # SBCL page recommends 2.33.2, though. Not sure when was it last tested
  clisp_2_44_1 = callPackage ../development/interpreters/clisp/2.44.1.nix {
    libsigsegv = libsigsegv_25;
  };

  clojure = callPackage ../development/interpreters/clojure { };

  clooj = callPackage ../development/interpreters/clojure/clooj.nix { };

  erlangR16 = callPackage ../development/interpreters/erlang/R16.nix { };
  erlangR16_odbc = callPackage ../development/interpreters/erlang/R16.nix { odbcSupport = true; };
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
  };
  erlangR18_odbc = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    odbcSupport = true;
  };
  erlangR18_javac = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    javacSupport = true;
  };
  erlangR18_odbc_javac = callPackage ../development/interpreters/erlang/R18.nix {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    javacSupport = true; odbcSupport = true;
  };
  erlang = self.erlangR18;
  erlang_odbc = self.erlangR18_odbc;
  erlang_javac = self.erlangR18_javac;
  erlang_odbc_javac = self.erlangR18_odbc_javac;

  rebar = callPackage ../development/tools/build-managers/rebar { };
  rebar3-open = callPackage ../development/tools/build-managers/rebar3 { hermeticRebar3 = false; };
  rebar3 = callPackage ../development/tools/build-managers/rebar3 { hermeticRebar3 = true; };
  rebar3-nix-bootstrap = callPackage ../development/tools/erlang/rebar3-nix-bootstrap { };
  fetchHex = callPackage ../development/tools/build-managers/rebar3/fetch-hex.nix { };

  erlangPackages = callPackage ../development/erlang-modules { };
  cuter = erlangPackages.callPackage ../development/tools/erlang/cuter { };
  hex2nix = erlangPackages.callPackage ../development/tools/erlang/hex2nix { };

  elixir = callPackage ../development/interpreters/elixir { };

  groovy = callPackage ../development/interpreters/groovy { };

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  guile_2_0 = callPackage ../development/interpreters/guile { };

  guile = self.guile_2_0;

  hadoop = callPackage ../applications/networking/cluster/hadoop { };

  io = callPackage ../development/interpreters/io { };

  j = callPackage ../development/interpreters/j {};

  jimtcl = callPackage ../development/interpreters/jimtcl {};

  jmeter = callPackage ../applications/networking/jmeter {};

  davmail = callPackage ../applications/networking/davmail {};

  kanif = callPackage ../applications/networking/cluster/kanif { };

  lxappearance = callPackage ../applications/misc/lxappearance {};

  lxmenu-data = callPackage ../desktops/lxde/core/lxmenu-data.nix { };

  kona = callPackage ../development/interpreters/kona {};

  lolcode = callPackage ../development/interpreters/lolcode { };

  love_0_7 = callPackage ../development/interpreters/love/0.7.nix { lua=lua5_1; };
  love_0_8 = callPackage ../development/interpreters/love/0.8.nix { lua=lua5_1; };
  love_0_9 = callPackage ../development/interpreters/love/0.9.nix { };
  love_0_10 = callPackage ../development/interpreters/love/0.10.nix { };
  love = self.love_0_10;

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
  lua5 = self.lua5_2_compat;
  lua = self.lua5;

  lua51Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_1; });
  lua52Packages = recurseIntoAttrs (callPackage ./lua-packages.nix { lua = lua5_2; });

  luaPackages = self.lua52Packages;

  lua5_1_sockets = self.lua51Packages.luasocket;

  lua5_expat = callPackage ../development/interpreters/lua-5/expat.nix {};
  lua5_sec = callPackage ../development/interpreters/lua-5/sec.nix { };

  luajit = callPackage ../development/interpreters/luajit {};

  luarocks = self.luaPackages.luarocks;

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
    pythonProtobuf = pythonPackages.protobuf2_5;
    perf = linuxPackages.perf;
  };

  mesos-dns = goPackages.mesos-dns.bin // { outputs = [ "bin" ]; };

  mujs = callPackage ../development/interpreters/mujs { };

  nix-exec = callPackage ../development/interpreters/nix-exec {
    nix = nixUnstable;

    git = gitMinimal;
  };

  octave = callPackage ../development/interpreters/octave {
    fltk = fltk13.override { cfg.xftSupport = true; };
    qt = null;
    ghostscript = null;
    llvm = null;
    hdf5 = null;
    glpk = null;
    suitesparse = null;
    jdk = null;
    openblas = openblasCompat;
  };
  octaveFull = (lowPrio (callPackage ../development/interpreters/octave {
    fltk = fltk13.override { cfg.xftSupport = true; };
    qt = qt4;
  }));

  # mercurial (hg) bleeding edge version
  octaveHG = callPackage ../development/interpreters/octave/hg.nix { };

  ocropus = callPackage ../applications/misc/ocropus { };

  inherit (callPackages ../development/interpreters/perl {}) perl perl520 perl522;

  php = php56;

  phpPackages = php56Packages;

  php55Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php55;
  });

  php56Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php56;
  });

  php70Packages = recurseIntoAttrs (callPackage ./php-packages.nix {
    php = php70;
  });

  inherit (callPackages ../development/interpreters/php { })
    php55
    php56
    php70;

  picoc = callPackage ../development/interpreters/picoc {};

  picolisp = callPackage ../development/interpreters/picolisp {};

  pltScheme = racket; # just to be sure

  polyml = callPackage ../development/compilers/polyml { };

  pure = callPackage ../development/interpreters/pure {
    llvm = llvm_35;
  };
  purePackages = recurseIntoAttrs (callPackage ./pure-packages.nix {});

  python = python2;
  python2 = python27;
  python3 = python34;

  # pythonPackages further below, but assigned here because they need to be in sync
  pythonPackages = python2Packages;
  python2Packages = python27Packages;
  python3Packages = python34Packages;

  python26 = callPackage ../development/interpreters/python/2.6 {
    db = db47;
    self = python26;
  };
  python27 = callPackage ../development/interpreters/python/2.7 {
    self = python27;
    inherit (darwin) CF configd;
  };
  python32 = callPackage ../development/interpreters/python/3.2 {
    self = python32;
  };
  python33 = callPackage ../development/interpreters/python/3.3 {
    self = python33;
  };
  python34 = hiPrio (callPackage ../development/interpreters/python/3.4 {
    inherit (darwin) CF configd;
    self = python34;
  });
  python35 = hiPrio (callPackage ../development/interpreters/python/3.5 {
    inherit (darwin) CF configd;
    self = python35;
  });
  pypy = callPackage ../development/interpreters/pypy {
    self = pypy;
  };

  pythonFull = python2Full;
  python2Full = python27Full;
  python26Full = python26.override {
    includeModules = true;
    self = python26Full;
  };
  python27Full = python27.override {
    includeModules = true;
    self = python27Full;
  };

  python2nix = callPackage ../tools/package-management/python2nix { };

  pythonDocs = recurseIntoAttrs (callPackage ../development/interpreters/python/docs {});

  pypi2nix = python27Packages.pypi2nix;

  svg2tikz = python27Packages.svg2tikz;

  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  racket = callPackage ../development/interpreters/racket { };

  rakudo = callPackage ../development/interpreters/rakudo { };

  rascal = callPackage ../development/interpreters/rascal { };

  regina = callPackage ../development/interpreters/regina { };

  renpy = callPackage ../development/interpreters/renpy {
    wrapPython = pythonPackages.wrapPython;
  };

  pixie = callPackage ../development/interpreters/pixie { };
  dust = callPackage ../development/interpreters/pixie/dust.nix { };

  buildRubyGem = callPackage ../development/ruby-modules/gem { };
  defaultGemConfig = callPackage ../development/ruby-modules/gem-config { };
  bundix = callPackage ../development/ruby-modules/bundix { };
  bundler = callPackage ../development/ruby-modules/bundler { };
  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };

  inherit (callPackage ../development/interpreters/ruby {})
    ruby_1_9_3
    ruby_2_0_0
    ruby_2_1_7
    ruby_2_2_3
    ruby_2_3_0;

  # Ruby aliases
  ruby = ruby_2_3;
  ruby_1_9 = ruby_1_9_3;
  ruby_2_0 = ruby_2_0_0;
  ruby_2_1 = ruby_2_1_7;
  ruby_2_2 = ruby_2_2_3;
  ruby_2_3 = ruby_2_3_0;

  scsh = callPackage ../development/interpreters/scsh { };

  scheme48 = callPackage ../development/interpreters/scheme48 { };

  self = callPackage_i686 ../development/interpreters/self { };

  spark = callPackage ../applications/networking/cluster/spark { };

  spidermonkey = callPackage ../development/interpreters/spidermonkey { };
  spidermonkey_1_8_0rc1 = callPackage ../development/interpreters/spidermonkey/1.8.0-rc1.nix { };
  spidermonkey_185 = callPackage ../development/interpreters/spidermonkey/185-1.0.0.nix { };
  spidermonkey_17 = callPackage ../development/interpreters/spidermonkey/17.0.nix { };
  spidermonkey_24 = callPackage ../development/interpreters/spidermonkey/24.2.nix { };
  spidermonkey_31 = callPackage ../development/interpreters/spidermonkey/31.5.nix { };

  supercollider = callPackage ../development/interpreters/supercollider {
    gcc = gcc48; # doesn't build with gcc49
    qt = qt4;
    fftw = fftwSinglePrec;
  };

  supercollider_scel = supercollider.override { useSCEL = true; };

  taktuk = callPackage ../applications/networking/cluster/taktuk { };

  tcl = tcl-8_6;
  tcl-8_5 = callPackage ../development/interpreters/tcl/8.5.nix { };
  tcl-8_6 = callPackage ../development/interpreters/tcl/8.6.nix { };

  xulrunner = callPackage ../development/interpreters/xulrunner {
    inherit (gnome) libIDL;
    inherit (pythonPackages) pysqlite;
  };


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

  amdappsdk = self.amdappsdk28;

  amdappsdkFull = callPackage ../development/misc/amdapp-sdk {
    version = "2.8";
    samples = true;
  };

  avrgcclibc = callPackage ../development/misc/avr-gcc-with-avr-libc {};

  avr8burnomat = callPackage ../development/misc/avr8-burn-omat { };

  sourceFromHead = callPackage ../build-support/source-from-head-fun.nix {};

  ecj = callPackage ../development/eclipse/ecj { };

  jdtsdk = callPackage ../development/eclipse/jdt-sdk { };

  jruby = callPackage ../development/interpreters/jruby { };

  jython = callPackage ../development/interpreters/jython {};

  guileCairo = callPackage ../development/guile-modules/guile-cairo { };

  guileGnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome.GConf;
    inherit (gnome) gnome_vfs libglade libgnome libgnomecanvas libgnomeui;
  };

  guile_lib = callPackage ../development/guile-modules/guile-lib { };

  guile_ncurses = callPackage ../development/guile-modules/guile-ncurses { };

  guile-opengl = callPackage ../development/guile-modules/guile-opengl { };

  guile-sdl = callPackage ../development/guile-modules/guile-sdl { };

  guile-xcb = callPackage ../development/guile-modules/guile-xcb { };

  pharo-vms = callPackage_i686 ../development/pharo/vm { };
  pharo-vm  = pharo-vms.pharo-no-spur;
  pharo-vm5 = pharo-vms.pharo-spur;

  pharo-launcher = callPackage ../development/pharo/launcher { };

  srecord = callPackage ../development/tools/misc/srecord { };

  windowssdk = (
    callPackage ../development/misc/windows-sdk {});

  xidel = callPackage ../tools/text/xidel { };

  ### DEVELOPMENT / TOOLS

  activator = callPackage ../development/tools/activator { };

  alloy = callPackage ../development/tools/alloy { };

  augeas = callPackage ../tools/system/augeas { };

  ansible = pythonPackages.ansible;

  ansible2 = pythonPackages.ansible2;

  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3 = callPackage ../development/tools/parsing/antlr { };

  ant = self.apacheAnt;

  apacheAnt = callPackage ../development/tools/build-managers/apache-ant { };

  apacheKafka = callPackage ../servers/apache-kafka { };

  astyle = callPackage ../development/tools/misc/astyle { };

  electron = callPackage ../development/tools/electron {
    gconf = pkgs.gnome.GConf;
  };


  autobuild = callPackage ../development/tools/misc/autobuild { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf-archive = callPackage ../development/tools/misc/autoconf-archive { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };

  autocutsel = callPackage ../tools/X11/autocutsel{ };

  automake = self.automake115x;

  automake110x = callPackage ../development/tools/misc/automake/automake-1.10.x.nix { };

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

  bazel = callPackage ../development/tools/build-managers/bazel { jdk = openjdk8; };

  bin_replace_string = callPackage ../development/tools/misc/bin_replace_string { };

  binutils = if stdenv.isDarwin then self.darwin.binutils else self.binutils-raw;

  binutils-raw = callPackage ../development/tools/misc/binutils { inherit noSysDirs; };

  binutils_nogold = lowPrio (callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
    gold = false;
  });

  binutilsCross = assert crossSystem != null; lowPrio (forceNativeDrv (
    if crossSystem.libc == "libSystem" then darwin.cctools_cross
    else binutils.override {
      noSysDirs = true;
      cross = crossSystem;
    }));

  bison2 = callPackage ../development/tools/parsing/bison/2.x.nix { };
  bison3 = callPackage ../development/tools/parsing/bison/3.x.nix { };
  bison = self.bison3;

  bossa = callPackage ../development/tools/misc/bossa {
    wxGTK = wxGTK30;
  };

  buildbot = callPackage ../development/tools/build-managers/buildbot {
    inherit (pythonPackages) twisted jinja2 sqlalchemy_migrate_0_7;
    dateutil = pythonPackages.dateutil_1_5;
  };

  buildbot-slave = callPackage ../development/tools/build-managers/buildbot-slave {
    inherit (pythonPackages) twisted;
  };

  byacc = callPackage ../development/tools/parsing/byacc { };

  cargo = callPackage ../development/tools/build-managers/cargo {
    # cargo needs to be built with rustCargoPlatform, which uses cargoSnapshot
    rustPlatform = rustCargoPlatform;
  };

  cargoUnstable = callPackage ../development/tools/build-managers/cargo/head.nix {
    rustPlatform = rustUnstableCargoPlatform;
  };

  cargoSnapshot = rustc:
    callPackage ../development/tools/build-managers/cargo/snapshot.nix {
      inherit rustc;
    };

  casperjs = callPackage ../development/tools/casperjs { };

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

  chefdk = callPackage ../development/tools/chefdk {
    ruby = ruby_2_0;
  };

  matter-compiler = callPackage ../development/compilers/matter-compiler {};

  cfr = callPackage ../development/tools/java/cfr { };

  checkstyle = callPackage ../development/tools/analysis/checkstyle { };

  chromedriver = callPackage ../development/tools/selenium/chromedriver { gconf = gnome.GConf; };

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

  cmake-2_8 = callPackage ../development/tools/build-managers/cmake/2.8.nix {
    wantPS = stdenv.isDarwin;
    inherit (darwin) ps;
  };

  cmake = callPackage ../development/tools/build-managers/cmake {
    wantPS = stdenv.isDarwin;
    inherit (darwin) ps;
  };

  cmakeCurses = self.cmake.override { useNcurses = true; };

  cmakeWithGui = self.cmakeCurses.override { useQt4 = true; };

  coccinelle = callPackage ../development/tools/misc/coccinelle { };

  cpptest = callPackage ../development/libraries/cpptest { };

  cppi = callPackage ../development/tools/misc/cppi { };

  cproto = callPackage ../development/tools/misc/cproto { };

  cflow = callPackage ../development/tools/misc/cflow { };

  cov-build = callPackage ../development/tools/analysis/cov-build {};

  cppcheck = callPackage ../development/tools/analysis/cppcheck { };

  cscope = callPackage ../development/tools/misc/cscope { };

  csslint = callPackage ../development/web/csslint { };

  libcxx = llvmPackages.libcxx;
  libcxxabi = llvmPackages.libcxxabi;

  libsigrok = callPackage ../development/tools/libsigrok { };

  libsigrokdecode = callPackage ../development/tools/libsigrokdecode { };

  dcadec = callPackage ../development/tools/dcadec { };

  dejagnu = callPackage ../development/tools/misc/dejagnu { };

  dfeet = callPackage ../development/tools/misc/d-feet {
    inherit (pythonPackages) pep8;
  };

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

  dot2tex = pythonPackages.dot2tex;

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt4 = null;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  doxygen_gui = lowPrio (self.doxygen.override { inherit qt4; });

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
  };

  framac = callPackage ../development/tools/analysis/frama-c { };

  frame = callPackage ../development/libraries/frame { };

  fswatch = callPackage ../development/tools/misc/fswatch { };

  funnelweb = callPackage ../development/tools/literate-programming/funnelweb { };

  pmd = callPackage ../development/tools/analysis/pmd { };

  jdepend = callPackage ../development/tools/analysis/jdepend { };

  flex_2_5_35 = callPackage ../development/tools/parsing/flex/2.5.35.nix { };
  flex = callPackage ../development/tools/parsing/flex/default.nix { };

  flexcpp = callPackage ../development/tools/parsing/flexc++ { };

  m4 = gnum4;

  geis = callPackage ../development/libraries/geis { };

  global = callPackage ../development/tools/misc/global { };

  gnome_doc_utils = callPackage ../development/tools/documentation/gnome-doc-utils {};

  gnum4 = callPackage ../development/tools/misc/gnum4 { };

  gnumake380 = callPackage ../development/tools/build-managers/gnumake/3.80 { };
  gnumake381 = callPackage ../development/tools/build-managers/gnumake/3.81 { };
  gnumake382 = callPackage ../development/tools/build-managers/gnumake/3.82 { };
  gnumake3 = self.gnumake382;
  gnumake40 = callPackage ../development/tools/build-managers/gnumake/4.0 { };
  gnumake41 = callPackage ../development/tools/build-managers/gnumake/4.1 { };
  gnumake = self.gnumake41;

  gob2 = callPackage ../development/tools/misc/gob2 { };

  gotty = goPackages.gotty.bin // { outputs = [ "bin" ]; };

  gradleGen = callPackage ../development/tools/build-managers/gradle { };
  gradle = self.gradleGen.gradleLatest;
  gradle25 = self.gradleGen.gradle25;

  gperf = callPackage ../development/tools/misc/gperf { };

  grail = callPackage ../development/libraries/grail { };

  gtk_doc = callPackage ../development/tools/documentation/gtk-doc { };

  gtkdialog = callPackage ../development/tools/misc/gtkdialog { };

  guileLint = callPackage ../development/tools/guile/guile-lint { };

  gwrap = callPackage ../development/tools/guile/g-wrap { };

  help2man = callPackage ../development/tools/misc/help2man {
    inherit (perlPackages) LocaleGettext;
  };

  heroku = callPackage ../development/tools/heroku { };

  hyenae = callPackage ../tools/networking/hyenae { };

  icestorm = callPackage ../development/tools/icestorm { };

  icmake = callPackage ../development/tools/build-managers/icmake { };

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils {
    inherit (perlPackages) XMLSimple;
  };

  include-what-you-use = callPackage ../development/tools/analysis/include-what-you-use {
    llvmPackages = llvmPackages_37;
  };

  indent = callPackage ../development/tools/misc/indent { };

  ino = callPackage ../development/arduino/ino { };

  inotify-tools = callPackage ../development/tools/misc/inotify-tools { };

  intel-gpu-tools = callPackage ../development/tools/misc/intel-gpu-tools {};

  iozone = callPackage ../development/tools/misc/iozone { };

  ired = callPackage ../development/tools/analysis/radare/ired.nix { };

  itstool = callPackage ../development/tools/misc/itstool { };

  jam = callPackage ../development/tools/build-managers/jam { };

  jikespg = callPackage ../development/tools/parsing/jikespg { };

  jenkins = callPackage ../development/tools/continuous-integration/jenkins { };

  jenkins-job-builder = pythonPackages.jenkins-job-builder;

  kcov = callPackage ../development/tools/analysis/kcov { };

  lcov = callPackage ../development/tools/analysis/lcov { };

  leiningen = callPackage ../development/tools/build-managers/leiningen { };

  lemon = callPackage ../development/tools/parsing/lemon { };


  libtool = self.libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  lsof = callPackage ../development/tools/misc/lsof { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  lttng-tools = callPackage ../development/tools/misc/lttng-tools { };

  lttng-ust = callPackage ../development/tools/misc/lttng-ust { };

  lttv = callPackage ../development/tools/misc/lttv { };

  maven = maven3;
  maven3 = callPackage ../development/tools/build-managers/apache-maven { };

  mk = callPackage ../development/tools/build-managers/mk { };

  msitools = callPackage ../development/tools/misc/msitools { };

  multi-ghc-travis = callPackage ../development/tools/haskell/multi-ghc-travis { };

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
    fontsConf = makeFontsConf {
      fontDirectories = [
        xorg.fontbhttf
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
    gconf = pkgs.gnome.GConf;
  };

  node_webkit_0_11 = callPackage ../development/tools/node-webkit/nw11.nix {
    gconf = pkgs.gnome.GConf;
  };

  node_webkit_0_9 = callPackage ../development/tools/node-webkit/nw9.nix {
    gconf = pkgs.gnome.GConf;
  };

  noweb = callPackage ../development/tools/literate-programming/noweb { };
  nuweb = callPackage ../development/tools/literate-programming/nuweb { tex = texlive.combined.scheme-small; };

  omake = callPackage ../development/tools/ocaml/omake { };
  omake_rc1 = callPackage ../development/tools/ocaml/omake/0.9.8.6-rc1.nix { };

  omniorb = callPackage ../development/tools/omniorb { };

  opengrok = callPackage ../development/tools/misc/opengrok { };

  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = callPackage ../development/tools/profiling/oprofile { };

  parse-cli-bin = callPackage ../development/tools/parse-cli-bin { };

  patchelf = callPackage ../development/tools/misc/patchelf { };

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
  pkgconfig = forceNativeDrv (callPackage ../development/tools/misc/pkgconfig {
    fetchurl = fetchurlBoot;
  });
  pkgconfigUpstream = lowPrio (pkgconfig.override { vanilla = true; });

  prelink = callPackage ../development/tools/misc/prelink { };

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake = premake4;

  racerRust = callPackage ../development/tools/rust/racer { };

  radare = callPackage ../development/tools/analysis/radare {
    inherit (gnome) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };
  radare2 = callPackage ../development/tools/analysis/radare2 {
    inherit (gnome) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };


  ragel = callPackage ../development/tools/parsing/ragel {
    tex = texlive.combined.scheme-small;
  };

  hammer = callPackage ../development/tools/parsing/hammer { };

  re2c = callPackage ../development/tools/parsing/re2c { };

  remake = callPackage ../development/tools/build-managers/remake { };

  rhc = callPackage ../development/tools/rhc { };

  rman = callPackage ../development/tools/misc/rman { };

  rolespec = callPackage ../development/tools/misc/rolespec { };

  rr = callPackage ../development/tools/analysis/rr {
    stdenv = stdenv_32bit;
  };

  saleae-logic = callPackage ../development/tools/misc/saleae-logic { };

  sauce-connect = callPackage ../development/tools/sauce-connect { };

  # couldn't find the source yet
  seleniumRCBin = callPackage ../development/tools/selenium/remote-control {
    jre = jdk;
  };

  selenium-server-standalone = callPackage ../development/tools/selenium/server { };

  selendroid = callPackage ../development/tools/selenium/selendroid { };

  scons = callPackage ../development/tools/build-managers/scons { };

  sbt = callPackage ../development/tools/build-managers/sbt { };
  simpleBuildTool = sbt;

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

  teensy-loader-cli = callPackage ../development/tools/misc/teensy-loader-cli { };

  texinfo413 = callPackage ../development/tools/misc/texinfo/4.13a.nix { };
  texinfo4 = texinfo413;
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.2.nix { };
  texinfo6 = callPackage ../development/tools/misc/texinfo/6.0.nix { };
  texinfo = texinfo6;
  texinfoInteractive = appendToName "interactive" (
    texinfo.override { interactive = true; }
  );

  texi2html = callPackage ../development/tools/misc/texi2html { };

  travis = callPackage ../development/tools/misc/travis { };

  tweak = callPackage ../applications/editors/tweak { };

  uhd = callPackage ../development/tools/misc/uhd { };

  uisp = callPackage ../development/tools/misc/uisp { };

  uncrustify = callPackage ../development/tools/misc/uncrustify { };

  vagrant = callPackage ../development/tools/vagrant {
    ruby = ruby_2_2;
  };

  gdb = callPackage ../development/tools/misc/gdb {
    guile = null;
    hurd = gnu.hurdCross;
    inherit (gnu) mig;
  };

  gdbGuile = lowPrio (self.gdb.override { inherit guile; });

  gdbCross = lowPrio (callPackage ../development/tools/misc/gdb {
    target = crossSystem;
  });

  valgrind = callPackage ../development/tools/analysis/valgrind { };

  valkyrie = callPackage ../development/tools/analysis/valkyrie { };

  verasco = callPackage ../development/tools/analysis/verasco ((
    if system == "x86_64-linux"
    then { tools = pkgsi686Linux.stdenv.cc; }
    else {}
  ) // {
    ocamlPackages = ocamlPackages_4_02;
  });

  xc3sprog = callPackage ../development/tools/misc/xc3sprog { };

  xmlindent = callPackage ../development/web/xmlindent {};

  xpwn = callPackage ../development/mobile/xpwn {};

  xxdiff = callPackage ../development/tools/misc/xxdiff {
    bison = bison2;
  };

  yacc = bison;

  ycmd = callPackage ../development/tools/misc/ycmd { };

  yodl = callPackage ../development/tools/misc/yodl { };

  winpdb = callPackage ../development/tools/winpdb { };

  grabserial = callPackage ../development/tools/grabserial { };


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

  agg = callPackage ../development/libraries/agg { };

  allegro = callPackage ../development/libraries/allegro {};
  allegro5 = callPackage ../development/libraries/allegro/5.nix {};
  allegro5unstable = callPackage
    ../development/libraries/allegro/5-unstable.nix {};

  amrnb = callPackage ../development/libraries/amrnb { };

  amrwb = callPackage ../development/libraries/amrwb { };

  appstream = callPackage ../development/libraries/appstream { };

  appstream-glib = callPackage ../development/libraries/appstream-glib { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    bdbSupport = true;
    db = if stdenv.isFreeBSD then db47 else db;
    # XXX: only the db_185 interface was available through
    #      apr with db58 on freebsd (nov 2015), for unknown reasons
  };

  assimp = callPackage ../development/libraries/assimp { };

  asio = callPackage ../development/libraries/asio { };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (callPackages ../development/libraries/aspell/dictionaries.nix {});

  aterm = self.aterm25;

  aterm25 = callPackage ../development/libraries/aterm/2.5.nix { };

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

  beecrypt = callPackage ../development/libraries/beecrypt { };

  belle-sip = callPackage ../development/libraries/belle-sip { };

  bobcat = callPackage ../development/libraries/bobcat { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost155 = callPackage ../development/libraries/boost/1.55.nix { };
  boost159 = callPackage ../development/libraries/boost/1.59.nix { };
  boost160 = callPackage ../development/libraries/boost/1.60.nix { };
  boost = self.boost160;

  boost_process = callPackage ../development/libraries/boost-process { };

  botan = callPackage ../development/libraries/botan { };
  botanUnstable = callPackage ../development/libraries/botan/unstable.nix { };

  box2d = callPackage ../development/libraries/box2d { };
  box2d_2_0_1 = callPackage ../development/libraries/box2d/2.0.1.nix { };

  breakpad = callPackage ../development/libraries/breakpad { };

  buddy = callPackage ../development/libraries/buddy { };

  bwidget = callPackage ../development/libraries/bwidget { };

  c-ares = callPackage ../development/libraries/c-ares {
    fetchurl = fetchurlBoot;
  };

  capnproto = callPackage ../development/libraries/capnproto { };

  ccnx = callPackage ../development/libraries/ccnx { };

  ndn-cxx = callPackage ../development/libraries/ndn-cxx { };

  cdk = callPackage ../development/libraries/cdk {};

  cimg = callPackage  ../development/libraries/cimg { };

  scmccid = callPackage ../development/libraries/scmccid { };

  ccrtp = callPackage ../development/libraries/ccrtp { };

  ccrtp_1_8 = callPackage ../development/libraries/ccrtp/1.8.nix { };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  cgal = callPackage ../development/libraries/CGAL {};

  cgui = callPackage ../development/libraries/cgui {};

  check = callPackage ../development/libraries/check {
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  chipmunk = callPackage ../development/libraries/chipmunk {};

  chmlib = callPackage ../development/libraries/chmlib { };

  chromaprint = callPackage ../development/libraries/chromaprint { };

  cilaterm = callPackage ../development/libraries/cil-aterm {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  cl = callPackage ../development/libraries/cl { };

  clanlib = callPackage ../development/libraries/clanlib { };

  classads = callPackage ../development/libraries/classads { };

  classpath = callPackage ../development/libraries/java/classpath {
    javac = gcj;
    jvm = gcj;
    gconf = gnome.GConf;
  };

  clearsilver = callPackage ../development/libraries/clearsilver { };

  cln = callPackage ../development/libraries/cln { };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix { };

  clucene_core_1 = callPackage ../development/libraries/clucene-core { };

  clucene_core = self.clucene_core_1;

  clutter = callPackage ../development/libraries/clutter { };

  clutter_1_22 = callPackage ../development/libraries/clutter/1.22.nix {
    cogl = cogl_1_20;
  };

  clutter_1_24 = callPackage ../development/libraries/clutter/1.24.nix {
    cogl = cogl_1_22;
  };

  clutter-gst = callPackage ../development/libraries/clutter-gst { };

  clutter-gst_3_0 = callPackage ../development/libraries/clutter-gst/3.0.nix {
    clutter = clutter_1_22;
  };

  clutter_gtk = callPackage ../development/libraries/clutter-gtk { };
  clutter_gtk_0_10 = callPackage ../development/libraries/clutter-gtk/0.10.8.nix { };
  clutter_gtk_1_6 = callPackage ../development/libraries/clutter-gtk/1.6.nix {
    clutter = clutter_1_22;
  };

  cminpack = callPackage ../development/libraries/cminpack { };

  cmocka = callPackage ../development/libraries/cmocka { };

  cogl = callPackage ../development/libraries/cogl { };

  cogl_1_20 = callPackage ../development/libraries/cogl/1.20.nix { };

  cogl_1_22 = callPackage ../development/libraries/cogl/1.22.nix { };

  coin3d = callPackage ../development/libraries/coin3d { };

  CoinMP = callPackage ../development/libraries/CoinMP { };

  commoncpp2 = callPackage ../development/libraries/commoncpp2 { };

  confuse = callPackage ../development/libraries/confuse { };

  coredumper = callPackage ../development/libraries/coredumper { };

  ctl = callPackage ../development/libraries/ctl { };

  ctpp2 = callPackage ../development/libraries/ctpp2 { };

  ctpl = callPackage ../development/libraries/ctpl { };

  cpp-netlib = callPackage ../development/libraries/cpp-netlib { };

  cppunit = callPackage ../development/libraries/cppunit { };

  cracklib = callPackage ../development/libraries/cracklib { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  cwiid = callPackage ../development/libraries/cwiid { };

  cyrus_sasl = callPackage ../development/libraries/cyrus-sasl {
    kerberos = if stdenv.isFreeBSD then libheimdal else kerberos;
  };

  # Make bdb5 the default as it is the last release under the custom
  # bsd-like license
  db = self.db5;
  db4 = self.db48;
  db44 = callPackage ../development/libraries/db/db-4.4.nix { };
  db45 = callPackage ../development/libraries/db/db-4.5.nix { };
  db47 = callPackage ../development/libraries/db/db-4.7.nix { };
  db48 = callPackage ../development/libraries/db/db-4.8.nix { };
  db5 = self.db53;
  db53 = callPackage ../development/libraries/db/db-5.3.nix { };
  db6 = self.db60;
  db60 = callPackage ../development/libraries/db/db-6.0.nix { };

  dbus = callPackage ../development/libraries/dbus { };
  dbus_cplusplus  = callPackage ../development/libraries/dbus-cplusplus { };
  dbus_glib       = callPackage ../development/libraries/dbus-glib { };
  dbus_java       = callPackage ../development/libraries/java/dbus-java { };
  dbus_python     = self.pythonPackages.dbus;

  dbus-sharp-1_0 = callPackage ../development/libraries/dbus-sharp/dbus-sharp-1.0.nix { };
  dbus-sharp-2_0 = callPackage ../development/libraries/dbus-sharp { };

  dbus-sharp-glib-1_0 = callPackage ../development/libraries/dbus-sharp-glib/dbus-sharp-glib-1.0.nix { };
  dbus-sharp-glib-2_0 = callPackage ../development/libraries/dbus-sharp-glib { };

  # Should we deprecate these? Currently there are many references.
  dbus_tools = self.dbus.tools;
  dbus_libs = self.dbus.libs;
  dbus_daemon = self.dbus.daemon;

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

  eigen = callPackage ../development/libraries/eigen {};

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

  farbfeld = callPackage ../development/libraries/farbfeld { };

  farsight2 = callPackage ../development/libraries/farsight2 { };

  farstream = callPackage ../development/libraries/farstream {
    inherit (gst_all_1)
      gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad
      gst-libav;
    inherit (pythonPackages) gst-python;
  };

  fcgi = callPackage ../development/libraries/fcgi { };

  ffmpeg_0_10 = callPackage ../development/libraries/ffmpeg/0.10.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_1_2 = callPackage ../development/libraries/ffmpeg/1.2.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  ffmpeg_2_8 = callPackage ../development/libraries/ffmpeg/2.8.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  };
  # Aliases
  ffmpeg_0 = self.ffmpeg_0_10;
  ffmpeg_1 = self.ffmpeg_1_2;
  ffmpeg_2 = self.ffmpeg_2_8;
  ffmpeg = self.ffmpeg_2;

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
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreServices;
  };

  ffmpegthumbnailer = callPackage ../development/libraries/ffmpegthumbnailer { };

  ffms = callPackage ../development/libraries/ffms { };

  fftw = callPackage ../development/libraries/fftw { };
  fftwSinglePrec = self.fftw.override { precision = "single"; };
  fftwFloat = self.fftwSinglePrec; # the configure option is just an alias
  fftwLongDouble = self.fftw.override { precision = "long-double"; };

  filter-audio = callPackage ../development/libraries/filter-audio {};

  flann = callPackage ../development/libraries/flann { };

  flite = callPackage ../development/libraries/flite { };

  fltk13 = callPackage ../development/libraries/fltk/fltk13.nix { };

  fltk20 = callPackage ../development/libraries/fltk { };

  fmod = callPackage ../development/libraries/fmod { };

  fmod42416 = callPackage ../development/libraries/fmod/4.24.16.nix { };

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

  fam = self.gamin;

  gamin = callPackage ../development/libraries/gamin { };

  ganv = callPackage ../development/libraries/ganv { };

  gcab = callPackage ../development/libraries/gcab { };

  gdome2 = callPackage ../development/libraries/gdome2 {
    inherit (gnome) gtkdoc;
  };

  gdbm = callPackage ../development/libraries/gdbm { };

  gecode_3 = callPackage ../development/libraries/gecode/3.nix { };
  gecode_4 = callPackage ../development/libraries/gecode { };
  gecode = self.gecode_4;

  gegl = callPackage ../development/libraries/gegl { };

  gegl_0_3 = callPackage ../development/libraries/gegl/3.0.nix { };

  geoclue = callPackage ../development/libraries/geoclue {};

  geoclue2 = callPackage ../development/libraries/geoclue/2.0.nix {};

  geoipWithDatabase = self.geoip.override {
    drvName = "geoip-tools";
    geoipDatabase = geolite-legacy;
  };

  geoip = callPackage ../development/libraries/geoip { };

  geoipjava = callPackage ../development/libraries/java/geoipjava { };

  geos = callPackage ../development/libraries/geos { };

  getdata = callPackage ../development/libraries/getdata { };

  gettext = callPackage ../development/libraries/gettext { };

  gd = callPackage ../development/libraries/gd { };

  gdal = callPackage ../development/libraries/gdal { };

  gdal_1_11 = callPackage ../development/libraries/gdal/gdal-1_11.nix { };

  gdcm = callPackage ../development/libraries/gdcm { };

  ggz_base_libs = callPackage ../development/libraries/ggz_base_libs {};

  giblib = callPackage ../development/libraries/giblib { };

  gio-sharp = callPackage ../development/libraries/gio-sharp { };

  libgit2 = callPackage ../development/libraries/git2 (
    stdenv.lib.optionalAttrs stdenv.isDarwin {
      inherit (darwin) libiconv;
    }
  );

  libgit2_0_21 = callPackage ../development/libraries/git2/0.21.nix { };

  glew = callPackage ../development/libraries/glew { };
  glew110 = callPackage ../development/libraries/glew/1.10.nix { };

  glfw = self.glfw3;
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

  glibcCross = forceNativeDrv (glibc.override {
    gccCross = gccCrossStageStatic;
    linuxHeaders = linuxHeadersCross;
  });

  # We can choose:
  libcCrossChooser = name: if name == "glibc" then glibcCross
    else if name == "uclibc" then uclibcCross
    else if name == "msvcrt" then windows.mingw_w64
    else if name == "libSystem" then darwin.xcode
    else throw "Unknown libc";

  libcCross = assert crossSystem != null; libcCrossChooser crossSystem.libc;

  # Only supported on Linux
  glibcLocales = if stdenv.isLinux then callPackage ../development/libraries/glibc/locales.nix { } else null;

  glibcInfo = callPackage ../development/libraries/glibc/info.nix { };

  glibc_multi = callPackage ../development/libraries/glibc/multi.nix {
    glibc32 = pkgsi686Linux.glibc;
  };

  glm = callPackage ../development/libraries/glm { };
  glm_0954 = callPackage ../development/libraries/glm/0954.nix { };

  glog = callPackage ../development/libraries/glog { };

  gloox = callPackage ../development/libraries/gloox { };

  glpk = callPackage ../development/libraries/glpk { };

  glsurf = callPackage ../applications/science/math/glsurf {
    inherit (ocamlPackages) lablgl findlib ocaml_mysql mlgmp;
    libpng = libpng12;
    giflib = giflib_4_1;
    camlimages = ocamlPackages.camlimages_4_0;
  };

  gmime = callPackage ../development/libraries/gmime { };

  gmm = callPackage ../development/libraries/gmm { };

  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { }; # required by older GHC versions
  gmp5 = callPackage ../development/libraries/gmp/5.1.x.nix { };
  gmp6 = callPackage ../development/libraries/gmp/6.x.nix { };
  gmp = self.gmp5;
  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr/default.nix { };

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection {
    nixStoreDir = config.nix.storeDir or builtins.storeDir;
    inherit (darwin) cctools;
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

  gst_plugins_base = callPackage ../development/libraries/gstreamer/legacy/gst-plugins-base {};

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
    inherit (gnome) gtkdoc;
  };

  qt-mobility = callPackage ../development/libraries/qt-mobility {};

  qt_gstreamer = callPackage ../development/libraries/gstreamer/legacy/qt-gstreamer {};

  qt_gstreamer1 = callPackage ../development/libraries/gstreamer/qt-gstreamer { boost = boost155;};

  gnet = callPackage ../development/libraries/gnet { };

  gnu-efi = callPackage ../development/libraries/gnu-efi { };

  gnutls = self.gnutls34;

  gnutls33 = callPackage ../development/libraries/gnutls/3.3.nix {
    guileBindings = config.gnutls.guile or false;
  };

  gnutls34 = callPackage ../development/libraries/gnutls/3.4.nix {
    guileBindings = config.gnutls.guile or false;
  };

  gpac = callPackage ../applications/video/gpac { };

  gpgme = callPackage ../development/libraries/gpgme {
    gnupg1 = gnupg1orig;
  };

  gpgstats = callPackage ../tools/security/gpgstats { };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsl_1 = callPackage ../development/libraries/gsl/gsl-1_16.nix { };

  gsm = callPackage ../development/libraries/gsm {};

  gsoap = callPackage ../development/libraries/gsoap { };

  gss = callPackage ../development/libraries/gss { };

  gtkimageview = callPackage ../development/libraries/gtkimageview { };

  gtkmathview = callPackage ../development/libraries/gtkmathview { };

  gtkLibs = {
    inherit (pkgs) glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtk
      gtkmm;
  };

  glib = callPackage ../development/libraries/glib { };
  glib-tested = self.glib.override { # checked version separate to break cycles
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
  pangomm = callPackage ../development/libraries/pangomm { };

  pangox_compat = callPackage ../development/libraries/pangox-compat { };

  gdata-sharp = callPackage ../development/libraries/gdata-sharp { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gnome-sharp = callPackage ../development/libraries/gnome-sharp {};

  granite = callPackage ../development/libraries/granite { };

  gtk2 = callPackage ../development/libraries/gtk+/2.x.nix {
    cupsSupport = config.gtk2.cups or stdenv.isLinux;
  };

  gtk3 = callPackage ../development/libraries/gtk+/3.x.nix { };

  gtk = self.gtk2;

  gtkmm = callPackage ../development/libraries/gtkmm/2.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.x.nix { };

  gtkmozembedsharp = callPackage ../development/libraries/gtkmozembed-sharp {
    gtksharp = gtk-sharp;
  };

  gtk-sharp-2_0 = callPackage ../development/libraries/gtk-sharp/2.0.nix {
    inherit (gnome) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf gnomepanel;
  };

  gtk-sharp-3_0 = callPackage ../development/libraries/gtk-sharp/3.0.nix {
    inherit (gnome) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf gnomepanel;
  };

  gtk-sharp = self.gtk-sharp-2_0;

  gtk-sharp-beans = callPackage ../development/libraries/gtk-sharp-beans { };

  gtkspell = callPackage ../development/libraries/gtkspell { };

  gtkspell3 = callPackage ../development/libraries/gtkspell/3.nix { };

  gtkspellmm = callPackage ../development/libraries/gtkspellmm { };

  gts = callPackage ../development/libraries/gts { };

  gvfs = callPackage ../development/libraries/gvfs { gconf = gnome.GConf; };

  gwenhywfar = callPackage ../development/libraries/gwenhywfar { gnutls = gnutls33; };

  hamlib = callPackage ../development/libraries/hamlib { };

  # TODO : Let admin choose.
  # We are using mit-krb5 because it is better maintained
  kerberos = self.libkrb5;

  heimdalFull = callPackage ../development/libraries/kerberos/heimdal.nix { };
  libheimdal = self.heimdalFull.override { type = "lib"; };

  harfbuzz = callPackage ../development/libraries/harfbuzz { };
  harfbuzz-icu = callPackage ../development/libraries/harfbuzz {
    withIcu = true;
    withGraphite2 = true;
  };

  hawknl = callPackage ../development/libraries/hawknl { };

  herqq = callPackage ../development/libraries/herqq { };

  heyefi = self.haskellPackages.heyefi;

  hidapi = callPackage ../development/libraries/hidapi {
    libusb = libusb1;
  };

  hiredis = callPackage ../development/libraries/hiredis { };

  hivex = callPackage ../development/libraries/hivex {
    inherit (perlPackages) IOStringy;
  };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hsqldb = callPackage ../development/libraries/java/hsqldb { };

  hstr = callPackage ../applications/misc/hstr { };

  htmlcxx = callPackage ../development/libraries/htmlcxx { };

  http-parser = callPackage ../development/libraries/http-parser { inherit (pythonPackages) gyp; };

  hunspell = callPackage ../development/libraries/hunspell { };

  hunspellDicts = recurseIntoAttrs (callPackages ../development/libraries/hunspell/dictionaries.nix {});

  hunspellWithDicts = dicts: callPackage ../development/libraries/hunspell/wrapper.nix { inherit dicts; };

  hwloc = callPackage ../development/libraries/hwloc {};

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  hyena = callPackage ../development/libraries/hyena { };

  icu = callPackage ../development/libraries/icu { };

  id3lib = callPackage ../development/libraries/id3lib { };

  iksemel = callPackage ../development/libraries/iksemel { };

  ilbc = callPackage ../development/libraries/ilbc { };

  ilixi = callPackage ../development/libraries/ilixi { };

  ilmbase = callPackage ../development/libraries/ilmbase { };

  imlib = callPackage ../development/libraries/imlib {
    libpng = libpng12;
  };

  imv = callPackage ../applications/graphics/imv/default.nix { };

  imlib2 = callPackage ../development/libraries/imlib2 { };

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
    llvmPackages = llvmPackages_37;
  };

  itk = callPackage ../development/libraries/itk { };

  jasper = callPackage ../development/libraries/jasper { };

  jama = callPackage ../development/libraries/jama { };

  jansson = callPackage ../development/libraries/jansson { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jbigkit = callPackage ../development/libraries/jbigkit { };

  jemalloc = callPackage ../development/libraries/jemalloc { };

  jetty_gwt = callPackage ../development/libraries/java/jetty-gwt { };

  jetty_util = callPackage ../development/libraries/java/jetty-util { };

  jshon = callPackage ../development/tools/parsing/jshon { };

  json_glib = callPackage ../development/libraries/json-glib { };

  json-c-0-11 = callPackage ../development/libraries/json-c/0.11.nix { }; # vulnerable
  json_c = callPackage ../development/libraries/json-c { };

  jsoncpp = callPackage ../development/libraries/jsoncpp { };

  jsonnet = callPackage ../development/compilers/jsonnet { };

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
  libkrb5 = self.krb5Full.override { type = "lib"; };

  LASzip = callPackage ../development/libraries/LASzip { };

  lcms = self.lcms1;

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

  letsencrypt = callPackage ../tools/admin/letsencrypt { };

  lib3ds = callPackage ../development/libraries/lib3ds { };

  libaacs = callPackage ../development/libraries/libaacs { };

  libaal = callPackage ../development/libraries/libaal { };

  libaccounts-glib = callPackage ../development/libraries/libaccounts-glib { };

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

  libav = self.libav_11; # branch 11 is API-compatible with branch 10
  inherit (callPackages ../development/libraries/libav { }) libav_0_8 libav_11;

  libavc1394 = callPackage ../development/libraries/libavc1394 { };

  libb2 = callPackage ../development/libraries/libb2 { };

  libbluedevil = callPackage ../development/libraries/libbluedevil { };

  libbdplus = callPackage ../development/libraries/libbdplus { };

  libbluray = callPackage ../development/libraries/libbluray { };

  libbs2b = callPackage ../development/libraries/audio/libbs2b { };

  libbson = callPackage ../development/libraries/libbson { };

  libcaca = callPackage ../development/libraries/libcaca { };

  libcanberra = callPackage ../development/libraries/libcanberra { };
  libcanberra_gtk3 = self.libcanberra.override { gtk = gtk3; };
  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then self.libcanberra.override { gtk = null; }
    else self.libcanberra;

  libcec = callPackage ../development/libraries/libcec { };
  libcec_platform = callPackage ../development/libraries/libcec/platform.nix { };

  libcello = callPackage ../development/libraries/libcello {};

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio { };
  libcdio082 = callPackage ../development/libraries/libcdio/0.82.nix { };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome) libsoup;
  };

  libchardet = callPackage ../development/libraries/libchardet { };

  libchewing = callPackage ../development/libraries/libchewing { };

  libcrafter = callPackage ../development/libraries/libcrafter { };

  libcrossguid = callPackage ../development/libraries/libcrossguid { };

  libuchardet = callPackage ../development/libraries/libuchardet { };

  libchop = callPackage ../development/libraries/libchop { };

  libclc = callPackage ../development/libraries/libclc { };

  libcli = callPackage ../development/libraries/libcli { };

  libclthreads = callPackage ../development/libraries/libclthreads  { };

  libclxclient = callPackage ../development/libraries/libclxclient  { };

  libcm = callPackage ../development/libraries/libcm { };

  libcommuni = callPackage ../development/libraries/libcommuni { };

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

  libdbiDrivers = self.libdbiDriversBase.override {
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

  libdevil-nox = self.libdevil.override {
    libX11 = null;
    mesa = null;
  };

  libdiscid = callPackage ../development/libraries/libdiscid { };

  libdivsufsort = callPackage ../development/libraries/libdivsufsort { };

  libdmtx = callPackage ../development/libraries/libdmtx { };

  libdnet = callPackage ../development/libraries/libdnet { };

  libdrm = callPackage ../development/libraries/libdrm { };

  libdv = callPackage ../development/libraries/libdv { };

  libdvbpsi = callPackage ../development/libraries/libdvbpsi { };

  libdwg = callPackage ../development/libraries/libdwg { };

  libdvdcss = callPackage ../development/libraries/libdvdcss { };

  libdvdnav = callPackage ../development/libraries/libdvdnav { };
  libdvdnav_4_2_1 = callPackage ../development/libraries/libdvdnav/4.2.1.nix {
    libdvdread = libdvdread_4_9_9;
  };

  libdvdread = callPackage ../development/libraries/libdvdread { };
  libdvdread_4_9_9 = callPackage ../development/libraries/libdvdread/4.9.9.nix { };

  libdwarf = callPackage ../development/libraries/libdwarf { };

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

  libgdata = gnome3.libgdata;

  libgee_0_6 = callPackage ../development/libraries/libgee/0.6.nix { };

  libgig = callPackage ../development/libraries/libgig { };

  libgnome_keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome_keyring3 = gnome3.libgnome_keyring;

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

  liblrdf = self.librdf;

  liblscp = callPackage ../development/libraries/liblscp { };

  libe-book = callPackage ../development/libraries/libe-book {};

  libechonest = callPackage ../development/libraries/libechonest { };

  libev = callPackage ../development/libraries/libev { };

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

  libfreefare = callPackage ../development/libraries/libfreefare { };

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

  libhangul = callPackage ../development/libraries/libhangul { };

  libharu = callPackage ../development/libraries/libharu { };

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

  libmcrypt = callPackage ../development/libraries/libmcrypt {};

  libmediainfo = callPackage ../development/libraries/libmediainfo { };

  libmhash = callPackage ../development/libraries/libmhash {};

  libmodbus = callPackage ../development/libraries/libmodbus {};

  libmtp = callPackage ../development/libraries/libmtp { };

  libmsgpack = callPackage ../development/libraries/libmsgpack { };
  libmsgpack_0_5 = callPackage ../development/libraries/libmsgpack/0.5.nix { };

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

  libresample = callPackage ../development/libraries/libresample {};

  librevenge = callPackage ../development/libraries/librevenge {};

  librevisa = callPackage ../development/libraries/librevisa { };

  libsamplerate = callPackage ../development/libraries/libsamplerate { };

  libsieve = callPackage ../development/libraries/libsieve { };

  libspectre = callPackage ../development/libraries/libspectre { };

  libgsf = callPackage ../development/libraries/libgsf { };

  # glibc provides libiconv so systems with glibc don't need to build libiconv
  # separately, but we also provide libiconvReal, which will always be a
  # standalone libiconv, just in case you want it
  libiconv = if crossSystem != null then
    (if crossSystem.libc == "glibc" then libcCross
      else if crossSystem.libc == "libSystem" then darwin.libiconv
      else libiconvReal)
    else if stdenv.isGlibc then stdenv.cc.libc
    else if stdenv.isDarwin then darwin.libiconv
    else libiconvReal;

  libiconvReal = callPackage ../development/libraries/libiconv {
    fetchurl = fetchurlBoot;
  };

  # On non-GNU systems we need GNU Gettext for libintl.
  libintlOrEmpty = stdenv.lib.optional (!stdenv.isLinux) gettext;

  libid3tag = callPackage ../development/libraries/libid3tag { };

  libidn = callPackage ../development/libraries/libidn { };

  idnkit = callPackage ../development/libraries/idnkit { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libinfinity = callPackage ../development/libraries/libinfinity {
    inherit (gnome) gtkdoc;
  };

  libinput = callPackage ../development/libraries/libinput {
    graphviz = graphviz-nox;
  };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjpeg_original = callPackage ../development/libraries/libjpeg { };
  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };
  libjpeg = if stdenv.isLinux then self.libjpeg_turbo else self.libjpeg_original; # some problems, both on FreeBSD and Darwin

  libjpeg62 = callPackage ../development/libraries/libjpeg/62.nix {
    libtool = libtool_1_5;
  };

  libjreen = callPackage ../development/libraries/libjreen { };

  libjson_rpc_cpp = callPackage ../development/libraries/libjson-rpc-cpp { };

  libkate = callPackage ../development/libraries/libkate { };

  libksba = callPackage ../development/libraries/libksba { };

  libksi = callPackage ../development/libraries/libksi { };

  libmad = callPackage ../development/libraries/libmad { };

  libmatchbox = callPackage ../development/libraries/libmatchbox { };

  libmatheval = callPackage ../development/libraries/libmatheval { };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmatroska = callPackage ../development/libraries/libmatroska { };

  libmcs = callPackage ../development/libraries/libmcs { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod { };

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

  libmusicbrainz = self.libmusicbrainz3;

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

  libosmpbf = callPackage ../development/libraries/libosmpbf {};

  libotr = callPackage ../development/libraries/libotr { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpar2 = callPackage ../development/libraries/libpar2 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpipeline = callPackage ../development/libraries/libpipeline { };

  libpgf = callPackage ../development/libraries/libpgf { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = self.libpng.override { apngSupport = true; };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  libpaper = callPackage ../development/libraries/libpaper { };

  libpfm = callPackage ../development/libraries/libpfm { };

  libpqxx = callPackage ../development/libraries/libpqxx { };

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
    inherit (darwin.apple_sdk.frameworks) Carbon;
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

  libstatgrab = callPackage ../development/libraries/libstatgrab { };

  libsvm = callPackage ../development/libraries/libsvm { };

  libtar = callPackage ../development/libraries/libtar { };

  libtasn1 = callPackage ../development/libraries/libtasn1 { };

  libtheora = callPackage ../development/libraries/libtheora { };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtiger = callPackage ../development/libraries/libtiger { };

  libtommath = callPackage ../development/libraries/libtommath { };

  libtomcrypt = callPackage ../development/libraries/libtomcrypt { };

  libtorrentRasterbar = callPackage ../development/libraries/libtorrent-rasterbar { };

  libtorrentRasterbar_0_16 = callPackage ../development/libraries/libtorrent-rasterbar/0.16.nix {
    # fix "unrecognized option -arch" error
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  libtoxcore = callPackage ../development/libraries/libtoxcore/old-api { };

  libtoxcore-dev = callPackage ../development/libraries/libtoxcore/new-api { };

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

  libunity = callPackage ../development/libraries/libunity { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  giflib = self.giflib_5_1;
  giflib_4_1 = callPackage ../development/libraries/giflib/4.1.nix { };
  giflib_5_0 = callPackage ../development/libraries/giflib/5.0.nix { };
  giflib_5_1 = callPackage ../development/libraries/giflib/5.1.nix { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libunibreak = callPackage ../development/libraries/libunibreak { };

  libunique = callPackage ../development/libraries/libunique/default.nix { };
  libunique3 = callPackage ../development/libraries/libunique/3.x.nix { inherit (gnome) gtkdoc; };

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

  libuvVersions = recurseIntoAttrs (callPackage ../development/libraries/libuv {
    automake = automake113x; # fails with 14
    inherit (darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  });

  libuv = self.libuvVersions.v1_7_5;

  libv4l = lowPrio (self.v4l_utils.override {
    alsaLib = null;
    libX11 = null;
    qt4 = null;
    qt5 = null;
  });

  libva = callPackage ../development/libraries/libva { };

  libvdpau = callPackage ../development/libraries/libvdpau { };

  libvdpau-va-gl = callPackage ../development/libraries/libvdpau-va-gl { };

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

  libwnck = self.libwnck2;
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
    pythonSupport = false;
  };

  libxml2Python = lowPrio (self.libxml2.override {
    pythonSupport = true;
  });

  libxmlxx = callPackage ../development/libraries/libxmlxx { };

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

  libzrtpcpp = callPackage ../development/libraries/libzrtpcpp { };

  libwacom = callPackage ../development/libraries/libwacom { };

  lightning = callPackage ../development/libraries/lightning { };

  lightlocker = callPackage ../misc/screensavers/light-locker { };

  lirc = callPackage ../development/libraries/lirc { };

  liquidfun = callPackage ../development/libraries/liquidfun { };

  live555 = callPackage ../development/libraries/live555 { };

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

  mdds_0_7_1 = callPackage ../development/libraries/mdds/0.7.1.nix { };
  mdds = callPackage ../development/libraries/mdds { };

  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mediastreamer-openh264 = callPackage ../development/libraries/mediastreamer/msopenh264.nix { };

  menu-cache = callPackage ../development/libraries/menu-cache { };

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
  });
  mesa_glu =  mesaDarwinOr (callPackage ../development/libraries/mesa-glu { });
  mesa_drivers = mesaDarwinOr (
    let mo = mesa_noglu.override {
      grsecEnabled = config.grsecurity or false;
      llvmPackages = llvmPackages_36; # various problems with 3.7; see #11367, #11467
    };
    in mo.drivers
  );
  mesa = mesaDarwinOr (buildEnv {
    name = "mesa-${mesa_noglu.version}";
    paths = [ mesa_noglu mesa_glu ];
  });

  meterbridge = callPackage ../applications/audio/meterbridge { };

  mhddfs = callPackage ../tools/filesystems/mhddfs { };

  ming = callPackage ../development/libraries/ming { };

  minizip = callPackage ../development/libraries/minizip { };

  minmay = callPackage ../development/libraries/minmay { };

  miro = callPackage ../applications/video/miro {
    inherit (pythonPackages) pywebkitgtk pycurl mutagen;
    avahi = avahi.override {
      withLibdnssdCompat = true;
    };
  };

  mkvtoolnix = callPackage ../applications/video/mkvtoolnix { };

  mkvtoolnix-cli = mkvtoolnix.override {
    withGUI = false;
  };

  mlt-qt4 = callPackage ../development/libraries/mlt {
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

  nanomsg = callPackage ../development/libraries/nanomsg { };

  notify-sharp = callPackage ../development/libraries/notify-sharp { };

  ncurses = callPackage ../development/libraries/ncurses { };

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

  nghttp2 = callPackage ../development/libraries/nghttp2 { };
  libnghttp2 = self.nghttp2.override {
    prefix = "lib";
    fetchurl = fetchurlBoot;
  };

  nix-plugins = callPackage ../development/libraries/nix-plugins {
    nix = pkgs.nixUnstable;
  };

  nntp-proxy = callPackage ../applications/networking/nntp-proxy { };

  non = callPackage ../applications/audio/non { };

  nspr = callPackage ../development/libraries/nspr { };

  nss = lowPrio (callPackage ../development/libraries/nss { });

  nss_wrapper = callPackage ../development/libraries/nss_wrapper { };

  nssTools = callPackage ../development/libraries/nss {
    includeTools = true;
  };

  ntk = callPackage ../development/libraries/audio/ntk { };

  ntrack = callPackage ../development/libraries/ntrack { };

  nvidia-texture-tools = callPackage ../development/libraries/nvidia-texture-tools { };

  ocl-icd = callPackage ../development/libraries/ocl-icd { };

  ode = callPackage ../development/libraries/ode { };

  ogre = callPackage ../development/libraries/ogre {};

  ogrepaged = callPackage ../development/libraries/ogrepaged { };

  oniguruma = callPackage ../development/libraries/oniguruma { };

  openal = openalSoft;
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

  opencollada = callPackage ../development/libraries/opencollada { };

  opencsg = callPackage ../development/libraries/opencsg { };

  openct = callPackage ../development/libraries/openct { };

  opencv = callPackage ../development/libraries/opencv { };

  opencv3 = callPackage ../development/libraries/opencv/3.x.nix { };

  # this ctl version is needed by openexr_viewers
  openexr_ctl = ctl;

  openexr = callPackage ../development/libraries/openexr { };

  openldap = callPackage ../development/libraries/openldap { };

  opencolorio = callPackage ../development/libraries/opencolorio { };

  ois = callPackage ../development/libraries/ois {};

  opal = callPackage ../development/libraries/opal {};

  openh264 = callPackage ../development/libraries/openh264 { };

  openjpeg_1 = callPackage ../development/libraries/openjpeg/1.x.nix { };
  openjpeg_2_0 = callPackage ../development/libraries/openjpeg/2.0.nix { };
  openjpeg_2_1 = callPackage ../development/libraries/openjpeg/2.1.nix { };
  openjpeg = openjpeg_2_1;

  openscenegraph = callPackage ../development/libraries/openscenegraph {
    giflib = giflib_4_1;
    ffmpeg = ffmpeg_0;
  };

  openslp = callPackage ../development/libraries/openslp {};

  libressl = self.libressl_2_3;
  libressl_2_2 = callPackage ../development/libraries/libressl/2.2.nix {
    fetchurl = fetchurlBoot;
  };
  libressl_2_3 = callPackage ../development/libraries/libressl/2.3.nix {
    fetchurl = fetchurlBoot;
  };

  boringssl = callPackage ../development/libraries/boringssl { };

  wolfssl = callPackage ../development/libraries/wolfssl { };

  openssl = openssl_1_0_2;

  inherit (callPackages ../development/libraries/openssl {
      fetchurl = fetchurlBoot;
      cryptodevHeaders = linuxPackages.cryptodev.override {
        fetchurl = fetchurlBoot;
        onlyHeaders = true;
      };
    })
    openssl_1_0_1
    openssl_1_0_2;

  openssl-chacha = callPackage ../development/libraries/openssl/chacha.nix {
    cryptodevHeaders = linuxPackages.cryptodev.override {
      fetchurl = fetchurlBoot;
      onlyHeaders = true;
    };
  };

  opensubdiv = callPackage ../development/libraries/opensubdiv {
    cudatoolkit = cudatoolkit75;
  };

  openwsman = callPackage ../development/libraries/openwsman {};

  ortp = callPackage ../development/libraries/ortp { };

  p11_kit = callPackage ../development/libraries/p11-kit { };

  paperkey = callPackage ../tools/security/paperkey { };

  pangoxsl = callPackage ../development/libraries/pangoxsl { };

  pcg_c = callPackage ../development/libraries/pcg-c { };

  pcl = callPackage ../development/libraries/pcl {
    vtk = vtkWithQt4;
  };

  pcre = callPackage ../development/libraries/pcre {
    unicodeSupport = config.pcre.unicode or true;
  };
  pcre16 = pcre.override {
    cplusplusSupport = false;
    withCharSize = 16;
  };
  pcre32 = pcre.override {
    cplusplusSupport = false;
    withCharSize = 32;
  };

  pcre2 = callPackage ../development/libraries/pcre2 { };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  phonon = callPackage ../development/libraries/phonon/qt4 {};

  phonon_backend_gstreamer = callPackage ../development/libraries/phonon-backend-gstreamer/qt4 {};

  phonon_backend_vlc = callPackage ../development/libraries/phonon-backend-vlc/qt4 {};

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

  polkit = callPackage ../development/libraries/polkit {
    spidermonkey = spidermonkey_17;
  };

  polkit_qt4 = callPackage ../development/libraries/polkit-qt-1 { };

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };

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

  portaudio = callPackage ../development/libraries/portaudio { };

  portaudioSVN = callPackage ../development/libraries/portaudio/svn-head.nix { };

  portmidi = callPackage ../development/libraries/portmidi {};

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  postgis = callPackage ../development/libraries/postgis { };

  protobuf = protobuf2_6;
  protobuf3_0 = lowPrio (callPackage ../development/libraries/protobuf/3.0.nix { });
  protobuf2_6 = callPackage ../development/libraries/protobuf/2.6.nix { };
  protobuf2_5 = callPackage ../development/libraries/protobuf/2.5.nix { };

  protobufc = protobufc1_1;
  protobufc1_1 = callPackage ../development/libraries/protobufc/1.1.nix { };
  protobufc1_0 = callPackage ../development/libraries/protobufc/1.0.nix { };

  pth = callPackage ../development/libraries/pth { };

  ptlib = callPackage ../development/libraries/ptlib {};

  pugixml = callPackage ../development/libraries/pugixml { };

  re2 = callPackage ../development/libraries/re2 { };

  qca2 = callPackage ../development/libraries/qca2 { qt = qt4; };

  qimageblitz = callPackage ../development/libraries/qimageblitz {};

  qjson = callPackage ../development/libraries/qjson { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qt3 = callPackage ../development/libraries/qt-3 {
    openglSupport = mesaSupported;
    libpng = libpng12;
  };

  qt4 = self.kde4.qt4;

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    mesa = mesa_noglu;
    inherit (pkgs.gnome) libgnomeui GConf gnome_vfs;
    cups = if stdenv.isLinux then cups else null;

    # XXX: mariadb doesn't built on fbsd as of nov 2015
    mysql = if (!stdenv.isFreeBSD) then mysql else null;
  };

  qt48Full = appendToName "full" (qt48.override {
    docs = true;
    demos = true;
    examples = true;
    developerBuild = true;
  });

  qt54 =
    let imported = import ../development/libraries/qt-5/5.4 { inherit pkgs; };
    in recurseIntoAttrs (imported.override (super: qt5LibsFun));

  qt55 =
    let imported = import ../development/libraries/qt-5/5.5 { inherit pkgs; };
    in recurseIntoAttrs (imported.override (super: qt5LibsFun));

  qt5 = self.qt54;

  qt5LibsFun = self: with self; {

    accounts-qt = callPackage ../development/libraries/accounts-qt { };

    grantlee = callPackage ../development/libraries/grantlee/5.x.nix { };

    libdbusmenu = callPackage ../development/libraries/libdbusmenu-qt/qt-5.5.nix { };

    libkeyfinder = callPackage ../development/libraries/libkeyfinder { };

    mlt = callPackage ../development/libraries/mlt/qt-5.nix {};

    openbr = callPackage ../development/libraries/openbr { };

    phonon = callPackage ../development/libraries/phonon/qt5 { };

    phonon-backend-gstreamer = callPackage ../development/libraries/phonon-backend-gstreamer/qt5 { };

    phonon-backend-vlc = callPackage ../development/libraries/phonon-backend-vlc/qt5 { };

    polkit-qt = callPackage ../development/libraries/polkit-qt-1 {
      withQt5 = true;
    };

    poppler = callPackage ../development/libraries/poppler {
      lcms = lcms2;
      qt5Support = true;
      suffix = "qt5";
    };

    qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

    qmltermwidget = callPackage ../development/libraries/qmltermwidget { };

    qtcreator = callPackage ../development/qtcreator {
      withDocumentation = true;
    };

    quazip = callPackage ../development/libraries/quazip {
      qt = qtbase;
    };

    qwt = callPackage ../development/libraries/qwt/6.nix { };

    signon = callPackage ../development/libraries/signon { };

    telepathy = callPackage ../development/libraries/telepathy/qt { };

    vlc = lowPrio (callPackage ../applications/video/vlc {
      qt4 = null;
      withQt5 = true;
    });

  };

  qtEnv = qt5.env;
  qt5Full = qt5.full;

  qtkeychain = callPackage ../development/libraries/qtkeychain { };

  qtscriptgenerator = callPackage ../development/libraries/qtscriptgenerator { };

  quesoglc = callPackage ../development/libraries/quesoglc { };

  quicksynergy = callPackage ../applications/misc/quicksynergy { };

  qwt = callPackage ../development/libraries/qwt {};

  qxt = callPackage ../development/libraries/qxt {};

  rabbitmq-c = callPackage ../development/libraries/rabbitmq-c {};

  rabbitmq-c_0_4 = callPackage ../development/libraries/rabbitmq-c/0.4.nix {};

  rabbitmq-java-client = callPackage ../development/libraries/rabbitmq-java-client {};

  raul = callPackage ../development/libraries/audio/raul { };

  readline = readline6;
  readline6 = readline63;

  readline5 = callPackage ../development/libraries/readline/5.x.nix { };

  readline62 = callPackage ../development/libraries/readline/6.2.nix { };

  readline63 = callPackage ../development/libraries/readline/6.3.nix { };

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
  lilv-svn = callPackage ../development/libraries/audio/lilv/lilv-svn.nix { };

  lv2 = callPackage ../development/libraries/audio/lv2 { };

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
    pulseaudioSupport = if (config ? pulseaudio)
                        then config.pulseaudio
                        else stdenv.isLinux;
    inherit (darwin.apple_sdk.frameworks) OpenGL CoreAudio CoreServices AudioUnit Kernel Cocoa;
  };

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
    pulseaudioSupport = config.pulseaudio or false; # better go through ALSA
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

  soprano = callPackage ../development/libraries/soprano { };

  soqt = callPackage ../development/libraries/soqt { };

  sord = callPackage ../development/libraries/sord {};
  sord-svn = callPackage ../development/libraries/sord/sord-svn.nix {};

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

  sqlite-interactive = appendToName "interactive" (sqlite.override { interactive = true; });

  sqlcipher = lowPrio (callPackage ../development/libraries/sqlcipher {
    readline = null;
    ncurses = null;
  });

  stfl = callPackage ../development/libraries/stfl { };

  stlink = callPackage ../development/tools/misc/stlink { };

  steghide = callPackage ../tools/security/steghide {};

  stlport = callPackage ../development/libraries/stlport { };

  strigi = callPackage ../development/libraries/strigi { clucene_core = clucene_core_2; };

  subtitleeditor = callPackage ../applications/video/subtitleeditor { };

  suil = callPackage ../development/libraries/audio/suil { };

  sutils = callPackage ../tools/misc/sutils { };

  svrcore = callPackage ../development/libraries/svrcore { };

  sword = callPackage ../development/libraries/sword { };

  biblesync = callPackage ../development/libraries/biblesync { };

  szip = callPackage ../development/libraries/szip { };

  t1lib = callPackage ../development/libraries/t1lib { };

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

  tk = tk-8_6;

  tk-8_6 = callPackage ../development/libraries/tk/8.6.nix { };
  tk-8_5 = callPackage ../development/libraries/tk/8.5.nix { tcl = tcl-8_5; };

  tnt = callPackage ../development/libraries/tnt { };

  kyotocabinet = callPackage ../development/libraries/kyotocabinet { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };

  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  tremor = callPackage ../development/libraries/tremor { };

  uid_wrapper = callPackage ../development/libraries/uid_wrapper { };

  unibilium = callPackage ../development/libraries/unibilium { };

  unicap = callPackage ../development/libraries/unicap {};

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
    inherit (pythonPackages) gyp;
  };

  v8_3_16_14 = callPackage ../development/libraries/v8/3.16.14.nix {
    inherit (pythonPackages) gyp;
    # The build succeeds using gcc5 but it fails to build pkgs.consul-ui
    stdenv = overrideCC stdenv gcc48;
  };

  v8_3_24_10 = callPackage ../development/libraries/v8/3.24.10.nix {
    inherit (pythonPackages) gyp;
  };

  v8_4_5 = callPackage ../development/libraries/v8/4.5.nix {
    inherit (pythonPackages) gyp;
  };

  v8 = callPackage ../development/libraries/v8 {
    inherit (pythonPackages) gyp;
  };

  vaapiIntel = callPackage ../development/libraries/vaapi-intel { };

  vaapiVdpau = callPackage ../development/libraries/vaapi-vdpau { };

  vamp = callPackage ../development/libraries/audio/vamp { };

  vc = callPackage ../development/libraries/vc { };

  vc_0_7 = callPackage ../development/libraries/vc/0.7.nix { };

  vcdimager = callPackage ../development/libraries/vcdimager { };

  vcg = callPackage ../development/libraries/vcg { };

  vid-stab = callPackage ../development/libraries/vid-stab { };

  vigra = callPackage ../development/libraries/vigra {
    inherit (pkgs.pythonPackages) numpy;
  };

  vlock = callPackage ../misc/screensavers/vlock { };

  vmime = callPackage ../development/libraries/vmime { };

  vrpn = callPackage ../development/libraries/vrpn { };

  vtk = callPackage ../development/libraries/vtk { };

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

  wayland-protocols = callPackage ../development/libraries/wayland/protocols.nix { };

  webkit = webkitgtk;

  wcslib = callPackage ../development/libraries/wcslib { };

  webkitgtk = callPackage ../development/libraries/webkitgtk {
    harfbuzz = harfbuzz-icu;
    gst-plugins-base = gst_all_1.gst-plugins-base;
  };

  webkitgtk24x = callPackage ../development/libraries/webkitgtk/2.4.nix {
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

  wvstreams = callPackage ../development/libraries/wvstreams { };

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxGTK-2.8 {
    inherit (gnome) GConf;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxGTK29 = callPackage ../development/libraries/wxGTK-2.9/default.nix {
    inherit (gnome) GConf;
    inherit (darwin.stubs) setfile;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxGTK30 = callPackage ../development/libraries/wxGTK-3.0/default.nix {
    inherit (gnome) GConf;
    inherit (darwin.stubs) setfile;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxmac = callPackage ../development/libraries/wxmac {
    inherit (darwin.apple_sdk.frameworks) AGL Cocoa Kernel QuickTime;
    inherit (darwin.stubs) setfile rez derez;
  };

  wtk = callPackage ../development/libraries/wtk { };

  x264 = callPackage ../development/libraries/x264 { };

  x265 = callPackage ../development/libraries/x265 { };

  xapian = callPackage ../development/libraries/xapian { };

  xapianBindings = callPackage ../development/libraries/xapian/bindings {  # TODO perl php Java, tcl, C#, python
    php = php56;
  };

  xapian-omega = callPackage ../tools/misc/xapian-omega {};

  xavs = callPackage ../development/libraries/xavs { };

  Xaw3d = callPackage ../development/libraries/Xaw3d { };

  xbase = callPackage ../development/libraries/xbase { };

  xcb-util-cursor = xorg.xcbutilcursor;
  xcb-util-cursor-HEAD = callPackage ../development/libraries/xcb-util-cursor/HEAD.nix { };

  xdo = callPackage ../tools/misc/xdo { };

  xineLib = callPackage ../development/libraries/xine-lib { };

  xautolock = callPackage ../misc/screensavers/xautolock { };

  xercesc = callPackage ../development/libraries/xercesc {};

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

  xlslib = callPackage ../development/libraries/xlslib { };

  xvidcore = callPackage ../development/libraries/xvidcore { };

  xylib = callPackage ../development/libraries/xylib { };

  yajl = callPackage ../development/libraries/yajl { };

  yubico-piv-tool = callPackage ../tools/misc/yubico-piv-tool { };

  yubikey-personalization = callPackage ../tools/misc/yubikey-personalization {
    libusb = libusb1;
  };

  yubikey-personalization-gui = callPackage ../tools/misc/yubikey-personalization-gui {
    qt = qt4;
  };

  zeitgeist = callPackage ../development/libraries/zeitgeist { };

  zlib = callPackage ../development/libraries/zlib {
    fetchurl = fetchurlBoot;
  };

  zlog = callPackage ../development/libraries/zlog { };

  zlibStatic = lowPrio (appendToName "static" (callPackage ../development/libraries/zlib {
    static = true;
  }));

  zeromq2 = callPackage ../development/libraries/zeromq/2.x.nix {};
  zeromq3 = callPackage ../development/libraries/zeromq/3.x.nix {};
  zeromq4 = callPackage ../development/libraries/zeromq/4.x.nix {};
  zeromq = zeromq4;

  cppzmq = callPackage ../development/libraries/cppzmq {};

  czmq = callPackage ../development/libraries/czmq { };

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

  atermjava = callPackage ../development/libraries/java/aterm {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

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

  jjtraveler = callPackage ../development/libraries/java/jjtraveler {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

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

  sharedobjects = callPackage ../development/libraries/java/shared-objects {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  smack = callPackage ../development/libraries/java/smack { };

  swt = callPackage ../development/libraries/java/swt {
    inherit (gnome) libsoup;
  };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  jquery = callPackage ../development/libraries/javascript/jquery { };

  jquery-ui = callPackage ../development/libraries/javascript/jquery-ui { };

  yuicompressor = callPackage ../development/tools/yuicompressor { };

  ### DEVELOPMENT / BOWER MODULES (JAVASCRIPT)

  buildBowerComponents = callPackage ../development/bower-modules/generic { };

  ### DEVELOPMENT / GO MODULES

  go14Packages = callPackage ./go-packages.nix {
    go = go_1_4;
    buildGoPackage = callPackage ../development/go-modules/generic {
      go = go_1_4;
      govers = go14Packages.govers.bin;
    };
    overrides = (config.goPackageOverrides or (p: {})) pkgs;
  };

  go15Packages = callPackage ./go-packages.nix {
    go = go_1_5;
    buildGoPackage = callPackage ../development/go-modules/generic {
      go = go_1_5;
      govers = go15Packages.govers.bin;
    };
    overrides = (config.goPackageOverrides or (p: {})) pkgs;
  };

  go16Packages = callPackage ./go-packages.nix {
    go = go_1_6;
    buildGoPackage = callPackage ../development/go-modules/generic {
      go = go_1_6;
      govers = go16Packages.govers.bin;
    };
    overrides = (config.goPackageOverrides or (p: {})) pkgs;
  };

  goPackages = go15Packages;

  go2nix = goPackages.go2nix.bin // { outputs = [ "bin" ]; };

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

  # python function with default python interpreter
  buildPythonPackage = pythonPackages.buildPythonPackage;
  buildPythonApplication = pythonPackages.buildPythonApplication;

  # `nix-env -i python-nose` installs for 2.7, the default python.
  # Therefore we do not recurse into attributes here, in contrast to
  # python27Packages. `nix-env -iA python26Packages.nose` works
  # regardless.
  python26Packages = callPackage ./python-packages.nix {
    python = python26;
    self = python26Packages;
  };

  python27Packages = lib.hiPrioSet (recurseIntoAttrs (callPackage ./python-packages.nix {
    python = python27;
    self = python27Packages;
  }));

  python32Packages = callPackage ./python-packages.nix {
    python = python32;
    self = python32Packages;
  };

  python33Packages = callPackage ./python-packages.nix {
    python = python33;
    self = python33Packages;
  };

  python34Packages = callPackage ./python-packages.nix {
    python = python34;
    self = python34Packages;
  };

  python35Packages = recurseIntoAttrs (callPackage ./python-packages.nix {
    python = python35;
    self = python35Packages;
  });

  pypyPackages = callPackage ./python-packages.nix {
    python = pypy;
    self = pypyPackages;
  };

  bsddb3 = pythonPackages.bsddb3;

  ecdsa = pythonPackages.ecdsa;

  pycairo = pythonPackages.pycairo;

  pycapnp = pythonPackages.pycapnp;

  pycrypto = pythonPackages.pycrypto;

  pycups = pythonPackages.pycups;

  pyexiv2 = callPackage ../development/python-modules/pyexiv2 { };

  pygame = pythonPackages.pygame;

  pygobject = pythonPackages.pygobject;

  pygobject3 = pythonPackages.pygobject3;

  pygtk = pythonPackages.pygtk;

  pygtksourceview = pythonPackages.pygtksourceview;

  pyGtkGlade = pythonPackages.pyGtkGlade;

  pylint = pythonPackages.pylint;

  pyopenssl = pythonPackages.pyopenssl;

  rhpl = callPackage ../development/python-modules/rhpl { };

  pyqt4 = pythonPackages.pyqt4;

  pysideApiextractor = pythonPackages.pysideApiextractor;

  pysideGeneratorrunner = pythonPackages.pysideGeneratorrunner;

  pyside = pythonPackages.pyside;

  pysideTools = pythonPackages.pysideTools;

  pysideShiboken = pythonPackages.pysideShiboken;

  pyxml = pythonPackages.pyxml;

  rbtools = pythonPackages.rbtools;

  setuptools = pythonPackages.setuptools;

  slowaes = pythonPackages.slowaes;

  twisted = pythonPackages.twisted;

  wxPython = pythonPackages.wxPython;
  wxPython28 = pythonPackages.wxPython28;

  yolk = callPackage ../development/python-modules/yolk {};

  ZopeInterface = pythonPackages.zope_interface;

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

  apacheHttpd = self.apacheHttpd_2_4;

  apacheHttpd_2_2 = callPackage ../servers/http/apache-httpd/2.2.nix {
    sslSupport = true;
  };

  apacheHttpd_2_4 = lowPrio (callPackage ../servers/http/apache-httpd/2.4.nix {
    # 1.0.2+ for ALPN support
    openssl = openssl_1_0_2;
  });

  apacheHttpdPackagesFor = apacheHttpd: self: let callPackage = newScope self; in {
    inherit apacheHttpd;

    mod_dnssd = callPackage ../servers/http/apache-modules/mod_dnssd { };

    mod_evasive = callPackage ../servers/http/apache-modules/mod_evasive { };

    mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

    mod_python = callPackage ../servers/http/apache-modules/mod_python { };

    mod_wsgi = callPackage ../servers/http/apache-modules/mod_wsgi { };

    php = pkgs.php.override { inherit apacheHttpd; };

    subversion = pkgs.subversion.override { httpServer = true; inherit apacheHttpd; };
  };

  apacheHttpdPackages = apacheHttpdPackagesFor pkgs.apacheHttpd pkgs.apacheHttpdPackages;
  apacheHttpdPackages_2_2 = apacheHttpdPackagesFor pkgs.apacheHttpd_2_2 pkgs.apacheHttpdPackages_2_2;
  apacheHttpdPackages_2_4 = apacheHttpdPackagesFor pkgs.apacheHttpd_2_4 pkgs.apacheHttpdPackages_2_4;

  archiveopteryx = callPackage ../servers/mail/archiveopteryx/default.nix { };

  cadvisor = callPackage ../servers/monitoring/cadvisor { };

  cassandra_1_2 = callPackage ../servers/nosql/cassandra/1.2.nix { };
  cassandra_2_0 = callPackage ../servers/nosql/cassandra/2.0.nix { };
  cassandra_2_1 = callPackage ../servers/nosql/cassandra/2.1.nix { };
  cassandra = self.cassandra_2_1;

  apache-jena = callPackage ../servers/nosql/apache-jena/binary.nix {
    java = jdk;
  };

  apache-jena-fuseki = callPackage ../servers/nosql/apache-jena/fuseki-binary.nix {
    java = jdk;
  };

  fuseki = self.apache-jena-fuseki;

  apcupsd = callPackage ../servers/apcupsd { };

  asterisk = callPackage ../servers/asterisk { };

  sabnzbd = callPackage ../servers/sabnzbd { };

  bind = callPackage ../servers/dns/bind { };

  bird = callPackage ../servers/bird { };

  bosun = (callPackage ../servers/monitoring/bosun { }).bin // { outputs = [ "bin" ]; };
  scollector = bosun;

  charybdis = callPackage ../servers/irc/charybdis {};

  couchdb = callPackage ../servers/http/couchdb {
    spidermonkey = spidermonkey_185;
    python = python27;
    sphinx = python27Packages.sphinx;
    erlang = erlangR16;
  };

  dico = callPackage ../servers/dico { };

  dict = callPackage ../servers/dict {
      libmaa = callPackage ../servers/dict/libmaa.nix {};
  };

  dictdDBs = recurseIntoAttrs (callPackages ../servers/dict/dictd-db.nix {});

  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix {};

  dictdWiktionary = callPackage ../servers/dict/dictd-wiktionary.nix {};

  dictdWordnet = callPackage ../servers/dict/dictd-wordnet.nix {};

  diod = callPackage ../servers/diod { lua = lua5_1; };

  dnschain = callPackage ../servers/dnschain { };

  dovecot = callPackage ../servers/mail/dovecot { };
  dovecot_pigeonhole = callPackage ../servers/mail/dovecot/plugins/pigeonhole { };
  dovecot_antispam = callPackage ../servers/mail/dovecot/plugins/antispam { };

  dspam = callPackage ../servers/mail/dspam {
    inherit (perlPackages) NetSMTP;
  };

  etcd = goPackages.etcd.bin // { outputs = [ "bin" ]; };

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

  freepops = callPackage ../servers/mail/freepops { };

  freeradius = callPackage ../servers/freeradius { };

  freeswitch = callPackage ../servers/sip/freeswitch { };

  gatling = callPackage ../servers/http/gatling { };

  glabels = callPackage ../applications/graphics/glabels { };

  grafana = (callPackage ../servers/monitoring/grafana { }).bin // { outputs = ["bin"]; };

  groovebasin = callPackage ../applications/audio/groovebasin { };

  haka = callPackage ../tools/security/haka { };

  heapster = (callPackage ../servers/monitoring/heapster { }).bin // { outputs = ["bin"]; };

  hbase = callPackage ../servers/hbase {};

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  jetty = callPackage ../servers/http/jetty { };

  jetty61 = callPackage ../servers/http/jetty/6.1 { };

  jetty92 = callPackage ../servers/http/jetty/9.2.nix { };

  rdkafka = callPackage ../development/libraries/rdkafka { };

  leafnode = callPackage ../servers/news/leafnode { };

  lighttpd = callPackage ../servers/http/lighttpd { };

  mailman = callPackage ../servers/mail/mailman { };

  mediatomb = callPackage ../servers/mediatomb {
    spidermonkey = spidermonkey_185;
  };

  memcached = callPackage ../servers/memcached {};

  meteor = callPackage ../servers/meteor/default.nix { };

  mfi = callPackage ../servers/mfi { };

  # Backwards compatibility.
  mod_dnssd = pkgs.apacheHttpdPackages.mod_dnssd;
  mod_evasive = pkgs.apacheHttpdPackages.mod_evasive;
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

  nginx = callPackage ../servers/http/nginx {
    # We don't use `with` statement here on purpose!
    # See https://github.com/NixOS/nixpkgs/pull/10474/files#r42369334
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxUnstable = callPackage ../servers/http/nginx/unstable.nix {
    modules = [ nginxModules.rtmp nginxModules.dav nginxModules.moreheaders ];
  };

  nginxModules = callPackage ../servers/http/nginx/modules.nix { };

  ngircd = callPackage ../servers/irc/ngircd { };

  nix-binary-cache = callPackage ../servers/http/nix-binary-cache {};

  nsd = callPackage ../servers/dns/nsd (config.nsd or {});

  nsq = goPackages.nsq.bin // { outputs = [ "bin" ]; };

  oauth2_proxy = goPackages.oauth2_proxy.bin // { outputs = [ "bin" ]; };

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

  pfixtools = callPackage ../servers/mail/postfix/pfixtools.nix { };

  pshs = callPackage ../servers/http/pshs { };

  libpulseaudio = callPackage ../servers/pulseaudio { libOnly = true; };

  # Name is changed to prevent use in packages;
  # please use libpulseaudio instead.
  pulseaudioLight = callPackage ../servers/pulseaudio { };

  pulseaudioFull = callPackage ../servers/pulseaudio {
    gconf = gnome3.gconf;
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    gconfSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  pies = callPackage ../servers/pies { };

  portmap = callPackage ../servers/portmap { };

  rpcbind = callPackage ../servers/rpcbind { };

  #monetdb = callPackage ../servers/sql/monetdb { };

  mariadb = callPackage ../servers/sql/mariadb {
    inherit (darwin) cctools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
    boost = boost159;
  };

  mongodb = callPackage ../servers/nosql/mongodb {
    sasl = cyrus_sasl;
  };

  mongodb248 = callPackage ../servers/nosql/mongodb/2.4.8.nix { };

  riak = callPackage ../servers/nosql/riak/2.1.1.nix { };

  influxdb = (callPackage ../servers/nosql/influxdb { }).bin // { outputs = [ "bin" ]; };

  hyperdex = callPackage ../servers/nosql/hyperdex { };

  mysql51 = callPackage ../servers/sql/mysql/5.1.x.nix {
    ps = procps; /* !!! Linux only */
  };

  mysql55 = callPackage ../servers/sql/mysql/5.5.x.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks) CoreServices;
  };

  mysql = mariadb;
  libmysql = mysql.lib;

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
    postgresql95;

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  prom2json = goPackages.prometheus.prom2json.bin // { outputs = [ "bin" ]; };
  prometheus = goPackages.prometheus.prometheus.bin // { outputs = [ "bin" ]; };
  prometheus-alertmanager = goPackages.prometheus.alertmanager.bin // { outputs = [ "bin" ]; };
  prometheus-cli = goPackages.prometheus.cli.bin // { outputs = [ "bin" ]; };
  prometheus-collectd-exporter = goPackages.prometheus.collectd-exporter.bin // { outputs = [ "bin" ]; };
  prometheus-haproxy-exporter = goPackages.prometheus.haproxy-exporter.bin // { outputs = [ "bin" ]; };
  prometheus-mesos-exporter = goPackages.prometheus.mesos-exporter.bin // { outputs = [ "bin" ]; };
  prometheus-mysqld-exporter = goPackages.prometheus.mysqld-exporter.bin // { outputs = [ "bin" ]; };
  prometheus-nginx-exporter = goPackages.prometheus.nginx-exporter.bin // { outputs = [ "bin" ]; };
  prometheus-node-exporter = goPackages.prometheus.node-exporter.bin // { outputs = [ "bin" ]; };
  prometheus-pushgateway = goPackages.prometheus.pushgateway.bin // { outputs = [ "bin" ]; };
  prometheus-statsd-bridge = goPackages.prometheus.statsd-bridge.bin // { outputs = [ "bin" ]; };

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

  redis = callPackage ../servers/nosql/redis { };

  redstore = callPackage ../servers/http/redstore { };

  restund = callPackage ../servers/restund {};

  rethinkdb = callPackage ../servers/nosql/rethinkdb {
    libtool = darwin.cctools;
  };

  rippled = callPackage ../servers/rippled {
    boost = boost159;
  };

  ripple-rest = callPackage ../servers/rippled/ripple-rest.nix { };

  s6 = callPackage ../tools/system/s6 { };

  s6-rc = callPackage ../tools/system/s6-rc { };

  spamassassin = callPackage ../servers/mail/spamassassin {
    inherit (perlPackages) HTMLParser NetDNS NetAddrIP DBFile
      HTTPDate MailDKIM LWP IOSocketSSL;
  };

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

  serfdom = goPackages.serf.bin // { outputs = [ "bin" ]; };

  seyren = callPackage ../servers/monitoring/seyren { };

  sensu = callPackage ../servers/monitoring/sensu {
    ruby = ruby_2_1;
  };

  shishi = callPackage ../servers/shishi {
      pam = if stdenv.isLinux then pam else null;
      # see also openssl, which has/had this same trick
  };

  sipcmd = callPackage ../applications/networking/sipcmd { };

  sipwitch = callPackage ../servers/sip/sipwitch { };

  spawn_fcgi = callPackage ../servers/http/spawn-fcgi { };

  squid = callPackage ../servers/squid { };

  sslh = callPackage ../servers/sslh { };

  thttpd = callPackage ../servers/http/thttpd { };

  storm = callPackage ../servers/computing/storm { };

  slurm-llnl = callPackage ../servers/computing/slurm { gtk = null; };

  slurm-llnl-full = appendToName "full" (callPackage ../servers/computing/slurm { });

  tomcat5 = callPackage ../servers/http/tomcat/5.0.nix { };

  tomcat6 = callPackage ../servers/http/tomcat/6.0.nix { };

  tomcat7 = callPackage ../servers/http/tomcat/7.0.nix { };

  tomcat8 = callPackage ../servers/http/tomcat/8.0.nix { };

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  torque = callPackage ../servers/computing/torque { };

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  unifi = callPackage ../servers/unifi { };

  virtuoso6 = callPackage ../servers/sql/virtuoso/6.x.nix { };

  virtuoso7 = callPackage ../servers/sql/virtuoso/7.x.nix { };

  virtuoso = virtuoso6;

  vsftpd = callPackage ../servers/ftp/vsftpd { };

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
      autoconf automake libtool xmlto asciidoc flex bison python mtdev pixman;
    inherit (darwin) apple_sdk cf-private libobjc;
    bootstrap_cmds = if stdenv.isDarwin then darwin.bootstrap_cmds else null;
    mesa = mesa_noglu;
    udev = if stdenv.isLinux then udev else null;
    libdrm = if stdenv.isLinux then libdrm else null;
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

  inherit (callPackages ../os-specific/linux/apparmor { swig = swig2; })
    libapparmor apparmor-pam apparmor-parser apparmor-profiles apparmor-utils;

  atop = callPackage ../os-specific/linux/atop { };

  audit = callPackage ../os-specific/linux/audit { };
  libaudit = self.audit;

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43Firmware_6_30_163_46 = callPackage ../os-specific/linux/firmware/b43-firmware/6.30.163.46.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  bluez4 = lowPrio (callPackage ../os-specific/linux/bluez {
    pygobject = pygobject3;
  });

  bluez5 = callPackage ../os-specific/linux/bluez/bluez5.nix { };

  # Needed for LibreOffice
  bluez5_28 = lowPrio (callPackage ../os-specific/linux/bluez/bluez5_28.nix { });

  bluez = self.bluez5;

  inherit (pythonPackages) bedup;

  bridge-utils = callPackage ../os-specific/linux/bridge-utils { };

  busybox = callPackage ../os-specific/linux/busybox { };

  cgmanager = callPackage ../os-specific/linux/cgmanager { };

  checkpolicy = callPackage ../os-specific/linux/checkpolicy { };

  checksec = callPackage ../os-specific/linux/checksec { };

  cifs_utils = callPackage ../os-specific/linux/cifs-utils { };

  conky = callPackage ../os-specific/linux/conky ({
    lua = lua5_1; # conky can use 5.2, but toluapp can not
  } // config.conky or {});

  conntrack_tools = callPackage ../os-specific/linux/conntrack-tools { };

  cpufrequtils = callPackage ../os-specific/linux/cpufrequtils { };

  cryopid = callPackage ../os-specific/linux/cryopid { };

  criu = callPackage ../os-specific/linux/criu { };

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  cramfsswap = callPackage ../os-specific/linux/cramfsswap { };

  crda = callPackage ../os-specific/linux/crda { };

  darwin = let
    cmdline = callPackage ../os-specific/darwin/command-line-tools {};
    apple-source-releases = callPackage ../os-specific/darwin/apple-source-releases { };
  in apple-source-releases // rec {
    cctools_cross = callPackage (forceNativeDrv (callPackage ../os-specific/darwin/cctools/port.nix {}).cross) {
      cross = assert crossSystem != null; crossSystem;
      inherit maloader;
      xctoolchain = xcode.toolchain;
    };

    cctools = (callPackage ../os-specific/darwin/cctools/port.nix { inherit libobjc; }).native;

    cf-private = callPackage ../os-specific/darwin/cf-private {
      inherit (apple-source-releases) CF;
      inherit osx_private_sdk;
    };

    maloader = callPackage ../os-specific/darwin/maloader {
      inherit opencflite;
    };

    opencflite = callPackage ../os-specific/darwin/opencflite {};

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
  };

  gnustep-make = callPackage ../development/tools/build-managers/gnustep/make {};
  gnustep-xcode = callPackage ../development/tools/build-managers/gnustep/xcode {
    inherit (darwin.apple_sdk.frameworks) Foundation;
    inherit (darwin) libobjc;
  };

  devicemapper = self.lvm2;

  disk_indicator = callPackage ../os-specific/linux/disk-indicator { };

  dmidecode = callPackage ../os-specific/linux/dmidecode { };

  dmtcp = callPackage ../os-specific/linux/dmtcp { };

  dietlibc = callPackage ../os-specific/linux/dietlibc { };

  directvnc = callPackage ../os-specific/linux/directvnc { };

  dmraid = callPackage ../os-specific/linux/dmraid {
    devicemapper = devicemapper.override {enable_dmeventd = true;};
  };

  drbd = callPackage ../os-specific/linux/drbd { };

  dstat = callPackage ../os-specific/linux/dstat {
    # pythonFull includes the "curses" standard library module, for pretty
    # dstat color output
    python = pythonFull;
  };

  libossp_uuid = callPackage ../development/libraries/libossp-uuid { };

  libuuid =
    if crossSystem != null && crossSystem.config == "i586-pc-gnu"
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

  e3cfsprogs = callPackage ../os-specific/linux/e3cfsprogs { };

  ebtables = callPackage ../os-specific/linux/ebtables { };

  eject = self.utillinux;

  facetimehd-firmware = callPackage ../os-specific/linux/firmware/facetimehd-firmware { };

  fanctl = callPackage ../os-specific/linux/fanctl {
    iproute = iproute.override { enableFan = true; };
  };

  fatrace = callPackage ../os-specific/linux/fatrace { };

  ffadoFull = callPackage ../os-specific/linux/ffado { };
  libffado = self.ffadoFull.override { prefix = "lib"; };

  fbterm = callPackage ../os-specific/linux/fbterm { };

  firejail = callPackage ../os-specific/linux/firejail {};

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

  gpm-ncurses = self.gpm.override { inherit ncurses; };

  gradm = callPackage ../os-specific/linux/gradm {
    flex = flex_2_5_35;
  };

  hdparm = callPackage ../os-specific/linux/hdparm { };

  hibernate = callPackage ../os-specific/linux/hibernate { };

  hostapd = callPackage ../os-specific/linux/hostapd { };

  htop = callPackage ../tools/system/htop {
    inherit (darwin) IOKit;
  };

  # GNU/Hurd core packages.
  gnu = recurseIntoAttrs (callPackage ../os-specific/gnu {
    inherit platform crossSystem;
  });

  hwdata = callPackage ../os-specific/linux/hwdata { };

  i7z = callPackage ../os-specific/linux/i7z { };

  ima-evm-utils = callPackage ../os-specific/linux/ima-evm-utils { };

  intel2200BGFirmware = callPackage ../os-specific/linux/firmware/intel2200BGFirmware { };

  iomelt = callPackage ../os-specific/linux/iomelt { };

  iotop = callPackage ../os-specific/linux/iotop { };

  iproute = callPackage ../os-specific/linux/iproute { };

  iputils = callPackage ../os-specific/linux/iputils {
    sp = spCompat;
    inherit (perlPackages) SGMLSpm;
  };

  iptables = callPackage ../os-specific/linux/iptables { };

  ipset = callPackage ../os-specific/linux/ipset { };

  irqbalance = callPackage ../os-specific/linux/irqbalance { };

  iw = callPackage ../os-specific/linux/iw { };

  jfbview = callPackage ../os-specific/linux/jfbview { };

  jool-cli = callPackage ../os-specific/linux/jool/cli.nix { };

  jujuutils = callPackage ../os-specific/linux/jujuutils { };

  kbd = callPackage ../os-specific/linux/kbd { };

  kbdlight = callPackage ../os-specific/linux/kbdlight { };

  kmscon = callPackage ../os-specific/linux/kmscon { };

  latencytop = callPackage ../os-specific/linux/latencytop { };

  ldm = callPackage ../os-specific/linux/ldm { };

  libaio = callPackage ../os-specific/linux/libaio { };

  libatasmart = callPackage ../os-specific/linux/libatasmart { };

  libcgroup = callPackage ../os-specific/linux/libcgroup { };

  libnl = callPackage ../os-specific/linux/libnl { };

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  openiscsi = callPackage ../os-specific/linux/open-iscsi { };

  tgt = callPackage ../tools/networking/tgt { };

  # -- Linux kernel expressions ------------------------------------------------

  linuxHeaders = self.linuxHeaders_3_18;

  linuxHeaders24Cross = forceNativeDrv (callPackage ../os-specific/linux/kernel-headers/2.4.nix {
    cross = assert crossSystem != null; crossSystem;
  });

  linuxHeaders26Cross = forceNativeDrv (callPackage ../os-specific/linux/kernel-headers/3.18.nix {
    cross = assert crossSystem != null; crossSystem;
  });

  linuxHeaders_3_18 = callPackage ../os-specific/linux/kernel-headers/3.18.nix { };

  # We can choose:
  linuxHeadersCrossChooser = ver : if ver == "2.4" then self.linuxHeaders24Cross
    else if ver == "2.6" then self.linuxHeaders26Cross
    else throw "Unknown linux kernel version";

  linuxHeadersCross = assert crossSystem != null;
    self.linuxHeadersCrossChooser crossSystem.platform.kernelMajor;

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  linux_mptcp = callPackage ../os-specific/linux/kernel/linux-mptcp.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_rpi = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ];
  };

  linux_3_10 = callPackage ../os-specific/linux/kernel/linux-3.10.nix {
    kernelPatches = with kernelPatches; [ bridge_stp_helper link_lguest link_apm ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_12 = callPackage ../os-specific/linux/kernel/linux-3.12.nix {
    kernelPatches = with kernelPatches; [ bridge_stp_helper crc_regression link_lguest ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_14 = callPackage ../os-specific/linux/kernel/linux-3.14.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_18 = callPackage ../os-specific/linux/kernel/linux-3.18.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_1 = callPackage ../os-specific/linux/kernel/linux-4.1.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_3 = callPackage ../os-specific/linux/kernel/linux-4.3.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_4 = callPackage ../os-specific/linux/kernel/linux-4.4.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_4_5 = callPackage ../os-specific/linux/kernel/linux-4.5.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_testing = callPackage ../os-specific/linux/kernel/linux-testing.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
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

  linux_chromiumos_latest = self.linux_chromiumos_3_18;

  /* grsec configuration

     We build several flavors of 'default' grsec kernels. These are
     built by default with Hydra. If the user selects a matching
     'default' flavor, then the pre-canned package set can be
     chosen. Typically, users will make very basic choices like
     'security' + 'server' or 'performance' + 'desktop' with
     virtualisation support. These will then be picked.

     Note: Xen guest kernels are included for e.g. NixOps deployments
     to EC2, where Xen is the Hypervisor.
  */

  # Base kernels to apply the grsecurity patch onto

  grsecurity_base_linux_3_14 = callPackage ../os-specific/linux/kernel/linux-grsecurity-3.14.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  grsecurity_base_linux_4_1 = callPackage ../os-specific/linux/kernel/linux-grsecurity-4.1.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  grsecurity_base_linux_4_4 = callPackage ../os-specific/linux/kernel/linux-grsecurity-4.4.nix {
    kernelPatches = [ kernelPatches.bridge_stp_helper ]
      ++ lib.optionals ((platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  grFlavors = import ../build-support/grsecurity/flavors.nix;

  mkGrsecurity = patch: opts:
    (callPackage ../build-support/grsecurity {
      grsecOptions = { kernelPatch = patch; } // opts;
    });

  grKernel  = patch: opts: (self.mkGrsecurity patch opts).grsecKernel;
  grPackage = patch: opts: recurseIntoAttrs (self.mkGrsecurity patch opts).grsecPackage;

  # grsecurity kernels (see also linuxPackages_grsec_*)

  linux_grsec_desktop_3_14    = self.grKernel kernelPatches.grsecurity_3_14 self.grFlavors.desktop;
  linux_grsec_server_3_14     = self.grKernel kernelPatches.grsecurity_3_14 self.grFlavors.server;
  linux_grsec_server_xen_3_14 = self.grKernel kernelPatches.grsecurity_3_14 self.grFlavors.server_xen;

  linux_grsec_desktop_4_1    = self.grKernel kernelPatches.grsecurity_4_1 self.grFlavors.desktop;
  linux_grsec_server_4_1     = self.grKernel kernelPatches.grsecurity_4_1 self.grFlavors.server;
  linux_grsec_server_xen_4_1 = self.grKernel kernelPatches.grsecurity_4_1 self.grFlavors.server_xen;

  linux_grsec_desktop_4_4    = self.grKernel kernelPatches.grsecurity_4_4 self.grFlavors.desktop;
  linux_grsec_server_4_4     = self.grKernel kernelPatches.grsecurity_4_4 self.grFlavors.server;
  linux_grsec_server_xen_4_4 = self.grKernel kernelPatches.grsecurity_4_4 self.grFlavors.server_xen;

  linux_grsec_desktop_latest    = self.grKernel kernelPatches.grsecurity_latest self.grFlavors.desktop;
  linux_grsec_server_latest     = self.grKernel kernelPatches.grsecurity_latest self.grFlavors.server;
  linux_grsec_server_xen_latest = self.grKernel kernelPatches.grsecurity_latest self.grFlavors.server_xen;

  # grsecurity: old names

  linux_grsec_testing_desktop    = self.linux_grsec_desktop_latest;
  linux_grsec_testing_server     = self.linux_grsec_server_latest;
  linux_grsec_testing_server_xen = self.linux_grsec_server_xen_latest;

  linux_grsec_stable_desktop    = self.linux_grsec_desktop_3_14;
  linux_grsec_stable_server     = self.linux_grsec_server_3_14;
  linux_grsec_stable_server_xen = self.linux_grsec_server_xen_3_14;

  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: self: let callPackage = newScope self; in rec {
    inherit kernel;

    accelio = callPackage ../development/libraries/accelio { };

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    blcr = callPackage ../os-specific/linux/blcr { };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    e1000e = callPackage ../os-specific/linux/e1000e {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    frandom = callPackage ../os-specific/linux/frandom { };

    fusionio-vsl = callPackage ../os-specific/linux/fusionio/vsl.nix { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta/default.nix { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidia_x11_legacy173 = callPackage ../os-specific/linux/nvidia-x11/legacy173.nix { };
    nvidia_x11_legacy304 = callPackage ../os-specific/linux/nvidia-x11/legacy304.nix { };
    nvidia_x11_legacy340 = callPackage ../os-specific/linux/nvidia-x11/legacy340.nix { };
    nvidia_x11_beta      = nvidia_x11; # latest beta is lower version ATM
                          # callPackage ../os-specific/linux/nvidia-x11/beta.nix { };
    nvidia_x11           = callPackage ../os-specific/linux/nvidia-x11 { };

    rtl8723bs = callPackage ../os-specific/linux/rtl8723bs { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    openafsClient = callPackage ../servers/openafs-client { };

    facetimehd = callPackage ../os-specific/linux/facetimehd { };

    kernelHeaders = callPackage ../os-specific/linux/kernel-headers { };

    klibc = callPackage ../os-specific/linux/klibc { };

    klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

    jool = callPackage ../os-specific/linux/jool { };

    mba6x_bl = callPackage ../os-specific/linux/mba6x_bl { };

    mxu11x0 = callPackage ../os-specific/linux/mxu11x0 { };

    /* compiles but has to be integrated into the kernel somehow
       Let's have it uncommented and finish it..
    */
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    netatop = callPackage ../os-specific/linux/netatop { };

    perf = callPackage ../os-specific/linux/kernel/perf.nix { };

    phc-intel = callPackage ../os-specific/linux/phc-intel { };

    prl-tools = callPackage ../os-specific/linux/prl-tools { };

    psmouse_alps = callPackage ../os-specific/linux/psmouse-alps { };

    seturgent = callPackage ../os-specific/linux/seturgent { };

    spl = callPackage ../os-specific/linux/spl {
      configFile = "kernel";
      inherit kernel;
    };

    sysdig = callPackage ../os-specific/linux/sysdig {};

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    v86d = callPackage ../os-specific/linux/v86d { };

    vhba = callPackage ../misc/emulators/cdemu/vhba.nix { };

    virtualbox = callPackage ../applications/virtualization/virtualbox {
      stdenv = stdenv_32bit;
      inherit (gnome) libIDL;
      enableExtensionPack = config.virtualbox.enableExtensionPack or false;
      pulseSupport = config.pulseaudio or false;
    };

    virtualboxHardened = lowPrio (virtualbox.override {
      enableHardening = true;
    });

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions { };

    x86_energy_perf_policy = callPackage ../os-specific/linux/x86_energy_perf_policy { };

    zfs = callPackage ../os-specific/linux/zfs {
      configFile = "kernel";
      inherit kernel spl;
    };
  };

  # The current default kernel / kernel modules.
  linuxPackages = self.linuxPackages_4_4;
  linux = self.linuxPackages.kernel;

  # Update this when adding the newest kernel major version!
  linuxPackages_latest = self.linuxPackages_4_5;
  linux_latest = self.linuxPackages_latest.kernel;

  # Build the kernel modules for the some of the kernels.
  linuxPackages_mptcp = self.linuxPackagesFor self.linux_mptcp linuxPackages_mptcp;
  linuxPackages_rpi = self.linuxPackagesFor self.linux_rpi linuxPackages_rpi;
  linuxPackages_3_10 = recurseIntoAttrs (self.linuxPackagesFor self.linux_3_10 linuxPackages_3_10);
  linuxPackages_3_10_tuxonice = self.linuxPackagesFor self.linux_3_10_tuxonice linuxPackages_3_10_tuxonice;
  linuxPackages_3_12 = recurseIntoAttrs (self.linuxPackagesFor self.linux_3_12 linuxPackages_3_12);
  linuxPackages_3_14 = recurseIntoAttrs (self.linuxPackagesFor self.linux_3_14 linuxPackages_3_14);
  linuxPackages_3_18 = recurseIntoAttrs (self.linuxPackagesFor self.linux_3_18 linuxPackages_3_18);
  linuxPackages_4_1 = recurseIntoAttrs (self.linuxPackagesFor self.linux_4_1 linuxPackages_4_1);
  linuxPackages_4_3 = recurseIntoAttrs (self.linuxPackagesFor self.linux_4_3 linuxPackages_4_3);
  linuxPackages_4_4 = recurseIntoAttrs (self.linuxPackagesFor self.linux_4_4 linuxPackages_4_4);
  linuxPackages_4_5 = recurseIntoAttrs (self.linuxPackagesFor self.linux_4_5 linuxPackages_4_5);
  linuxPackages_testing = recurseIntoAttrs (self.linuxPackagesFor self.linux_testing linuxPackages_testing);
  linuxPackages_custom = {version, src, configfile}:
                           let linuxPackages_self = (self.linuxPackagesFor (self.linuxManualConfig {inherit version src configfile;
                                                                                                    allowImportFromDerivation=true;})
                                                     linuxPackages_self);
                           in recurseIntoAttrs linuxPackages_self;

  # Build a kernel for Xen dom0
  linuxPackages_latest_xen_dom0 = recurseIntoAttrs (self.linuxPackagesFor (self.linux_latest.override { features.xen_dom0=true; }) linuxPackages_latest);

  # grsecurity packages

  linuxPackages_grsec_desktop_3_14    = self.grPackage kernelPatches.grsecurity_3_14 self.grFlavors.desktop;
  linuxPackages_grsec_server_3_14     = self.grPackage kernelPatches.grsecurity_3_14 self.grFlavors.server;
  linuxPackages_grsec_server_xen_3_14 = self.grPackage kernelPatches.grsecurity_3_14 self.grFlavors.server_xen;

  linuxPackages_grsec_desktop_4_1    = self.grPackage kernelPatches.grsecurity_4_1 self.grFlavors.desktop;
  linuxPackages_grsec_server_4_1     = self.grPackage kernelPatches.grsecurity_4_1 self.grFlavors.server;
  linuxPackages_grsec_server_xen_4_1 = self.grPackage kernelPatches.grsecurity_4_1 self.grFlavors.server_xen;

  linuxPackages_grsec_desktop_4_4    = self.grPackage kernelPatches.grsecurity_4_4 self.grFlavors.desktop;
  linuxPackages_grsec_server_4_4     = self.grPackage kernelPatches.grsecurity_4_4 self.grFlavors.server;
  linuxPackages_grsec_server_xen_4_4 = self.grPackage kernelPatches.grsecurity_4_4 self.grFlavors.server_xen;

  linuxPackages_grsec_desktop_latest    = self.grPackage kernelPatches.grsecurity_latest self.grFlavors.desktop;
  linuxPackages_grsec_server_latest     = self.grPackage kernelPatches.grsecurity_latest self.grFlavors.server;
  linuxPackages_grsec_server_xen_latest = self.grPackage kernelPatches.grsecurity_latest self.grFlavors.server_xen;

  # grsecurity: old names

  linuxPackages_grsec_testing_desktop    = self.linuxPackages_grsec_desktop_latest;
  linuxPackages_grsec_testing_server     = self.linuxPackages_grsec_server_latest;
  linuxPackages_grsec_testing_server_xen = self.linuxPackages_grsec_server_xen_latest;

  linuxPackages_grsec_stable_desktop    = self.linuxPackages_grsec_desktop_3_14;
  linuxPackages_grsec_stable_server     = self.linuxPackages_grsec_server_3_14;
  linuxPackages_grsec_stable_server_xen = self.linuxPackages_grsec_server_xen_3_14;

  # ChromiumOS kernels
  linuxPackages_chromiumos_3_14 = recurseIntoAttrs (self.linuxPackagesFor self.linux_chromiumos_3_14 linuxPackages_chromiumos_3_14);
  linuxPackages_chromiumos_3_18 = recurseIntoAttrs (self.linuxPackagesFor self.linux_chromiumos_3_18 linuxPackages_chromiumos_3_18);
  linuxPackages_chromiumos_latest = recurseIntoAttrs (self.linuxPackagesFor self.linux_chromiumos_latest linuxPackages_chromiumos_latest);

  # A function to build a manually-configured kernel
  linuxManualConfig = pkgs.buildLinux;
  buildLinux = callPackage ../os-specific/linux/kernel/manual-config.nix {};

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

  libcap_progs = callPackage ../os-specific/linux/libcap/progs.nix { };

  libcap_pam = callPackage ../os-specific/linux/libcap/pam.nix { };

  libcap_manpages = callPackage ../os-specific/linux/libcap/man.nix { };

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

  thin_provisioning_tools = callPackage ../os-specific/linux/thin-provisioning-tools { };

  mbpfan = callPackage ../os-specific/linux/mbpfan { };

  mdadm = callPackage ../os-specific/linux/mdadm { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  miraclecast = callPackage ../os-specific/linux/miraclecast {
    systemd = systemd.override { enableKDbus = true; };
  };

  mkinitcpio-nfs-utils = callPackage ../os-specific/linux/mkinitcpio-nfs-utils { };

  mmc-utils = callPackage ../os-specific/linux/mmc-utils { };

  module_init_tools = callPackage ../os-specific/linux/module-init-tools { };

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

  open-vm-tools = callPackage ../applications/virtualization/open-vm-tools {
    inherit (gnome) gtk gtkmm;
  };

  gocode = goPackages.gocode.bin // { outputs = [ "bin" ]; };

  kgocode = callPackage ../applications/misc/kgocode {
    inherit (pkgs.kde4) kdelibs;
  };

  gotags = goPackages.gotags.bin // { outputs = [ "bin" ]; };

  golint = goPackages.lint.bin // { outputs = [ "bin" ]; };

  godep = callPackage ../development/tools/godep { };

  goimports = goPackages.tools.bin // { outputs = [ "bin" ]; };

  gogoclient = callPackage ../os-specific/linux/gogoclient { };

  nss_ldap = callPackage ../os-specific/linux/nss_ldap { };

  pagemon = callPackage ../os-specific/linux/pagemon { };

  pam = callPackage ../os-specific/linux/pam { };

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_ccreds = callPackage ../os-specific/linux/pam_ccreds { };

  pam_devperm = callPackage ../os-specific/linux/pam_devperm { };

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

  powertop = callPackage ../os-specific/linux/powertop { };

  prayer = callPackage ../servers/prayer { };

  procps = procps-ng;

  procps-old = lowPrio (callPackage ../os-specific/linux/procps { });

  procps-ng = callPackage ../os-specific/linux/procps-ng { };

  watch = callPackage ../os-specific/linux/procps/watch.nix { };

  qemu_kvm = lowPrio (qemu.override { x86Only = true; });

  firmwareLinuxNonfree = callPackage ../os-specific/linux/firmware/firmware-linux-nonfree { };

  radeontools = callPackage ../os-specific/linux/radeontools { };

  radeontop = callPackage ../os-specific/linux/radeontop { };

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi {};

  regionset = callPackage ../os-specific/linux/regionset { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  rtkit = callPackage ../os-specific/linux/rtkit { };

  rt5677-firmware = callPackage ../os-specific/linux/firmware/rt5677 { };

  s3ql = callPackage ../tools/backup/s3ql { };

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

  smem = callPackage ../os-specific/linux/smem { };

  statifier = callPackage ../os-specific/linux/statifier { };

  spl = callPackage ../os-specific/linux/spl {
    configFile = "user";
  };

  sysdig = callPackage ../os-specific/linux/sysdig {
    kernel = null;
  }; # pkgs.sysdig is a client, for a driver look at linuxPackagesFor

  sysfsutils = callPackage ../os-specific/linux/sysfsutils { };

  sysprof = callPackage ../development/tools/profiling/sysprof {
    inherit (gnome) libglade;
  };

  # Provided with sysfsutils.
  libsysfs = self.sysfsutils;
  systool = self.sysfsutils;

  sysklogd = callPackage ../os-specific/linux/sysklogd { };

  syslinux = callPackage ../os-specific/linux/syslinux { };

  sysstat = callPackage ../os-specific/linux/sysstat { };

  systemd = callPackage ../os-specific/linux/systemd {
    linuxHeaders = linuxHeaders_3_18;
  };

  # In nixos, you can set systemd.package = pkgs.systemd_with_lvm2 to get
  # LVM2 working in systemd.
  systemd_with_lvm2 = pkgs.lib.overrideDerivation pkgs.systemd (p: {
      name = p.name + "-with-lvm2";
      postInstall = p.postInstall + ''
        cp "${pkgs.lvm2}/lib/systemd/system-generators/"* $out/lib/systemd/system-generators
      '';
  });

  sysvinit = callPackage ../os-specific/linux/sysvinit { };

  sysvtools = callPackage ../os-specific/linux/sysvinit {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcp_wrappers = callPackage ../os-specific/linux/tcp-wrappers { };

  trinity = callPackage ../os-specific/linux/trinity { };

  tunctl = callPackage ../os-specific/linux/tunctl { };

  # TODO(dezgeg): either refactor & use ubootTools directly, or remove completely
  ubootChooser = name: ubootTools;

  # Upstream U-Boots:
  inherit (callPackage ../misc/uboot {})
    buildUBoot
    ubootTools
    ubootBananaPi
    ubootJetsonTK1
    ubootPcduino3Nano
    ubootRaspberryPi
    ubootVersatileExpressCA9
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
    cross = assert crossSystem != null; crossSystem;
  });

  udev = pkgs.systemd;
  eudev = callPackage ../os-specific/linux/eudev {};

  # libudev.so.0
  udev182 = callPackage ../os-specific/linux/udev/182.nix { };

  udisks1 = callPackage ../os-specific/linux/udisks/1-default.nix { };
  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks1;

  udisks_glue = callPackage ../os-specific/linux/udisks-glue { };

  uksmtools = callPackage ../os-specific/linux/uksmtools { };

  untie = callPackage ../os-specific/linux/untie { };

  upower = callPackage ../os-specific/linux/upower { };

  upstart = callPackage ../os-specific/linux/upstart { };

  usbutils = callPackage ../os-specific/linux/usbutils { };

  usermount = callPackage ../os-specific/linux/usermount { };

  utillinux = callPackage ../os-specific/linux/util-linux { };
  utillinuxCurses = utillinux;

  utillinuxMinimal = appendToName "minimal" (utillinux.override {
    ncurses = null;
    perl = null;
    systemd = null;
  });

  v4l_utils = callPackage ../os-specific/linux/v4l-utils {
    qt5 = null;
  };

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

  zfs = callPackage ../os-specific/linux/zfs {
    configFile = "user";
  };

  ### DATA

  andagii = callPackage ../data/fonts/andagii { };

  android-udev-rules = callPackage ../os-specific/linux/android-udev-rules { };

  anonymousPro = callPackage ../data/fonts/anonymous-pro { };

  arkpandora_ttf = callPackage ../data/fonts/arkpandora { };

  aurulent-sans = callPackage ../data/fonts/aurulent-sans { };

  baekmuk-ttf = callPackage ../data/fonts/baekmuk-ttf { };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

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

  wrapFonts = paths : (callPackage ../data/fonts/fontWrap { inherit paths; });

  clearlyU = callPackage ../data/fonts/clearlyU { };

  cm_unicode = callPackage ../data/fonts/cm-unicode {};

  crimson = callPackage ../data/fonts/crimson {};

  dejavu_fonts = callPackage ../data/fonts/dejavu-fonts {
    inherit (perlPackages) FontTTF;
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

  docbook_xml_xslt = self.docbook_xsl;

  docbook5_xsl = self.docbook_xsl_ns;

  dosemu_fonts = callPackage ../data/fonts/dosemu-fonts { };

  eb-garamond = callPackage ../data/fonts/eb-garamond { };

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

  gyre-fonts = callPackage ../data/fonts/gyre {};

  hack-font = callPackage ../data/fonts/hack { };

  hicolor_icon_theme = callPackage ../data/icons/hicolor-icon-theme { };

  hanazono = callPackage ../data/fonts/hanazono { };

  inconsolata = callPackage ../data/fonts/inconsolata {};
  inconsolata-lgc = callPackage ../data/fonts/inconsolata/lgc.nix {};

  iosevka = callPackage ../data/fonts/iosevka { };

  ipafont = callPackage ../data/fonts/ipafont {};
  ipaexfont = callPackage ../data/fonts/ipaexfont {};

  junicode = callPackage ../data/fonts/junicode { };

  kawkab-mono-font = callPackage ../data/fonts/kawkab-mono {};

  kochi-substitute = callPackage ../data/fonts/kochi-substitute {};

  kochi-substitute-naga10 = callPackage ../data/fonts/kochi-substitute-naga10 {};

  league-of-moveable-type = callPackage ../data/fonts/league-of-moveable-type {};

  liberation_ttf_from_source = callPackage ../data/fonts/redhat-liberation-fonts { };
  liberation_ttf_binary = callPackage ../data/fonts/redhat-liberation-fonts/binary.nix { };
  liberation_ttf = self.liberation_ttf_binary;

  libertine = callPackage ../data/fonts/libertine { };

  lmmath = callPackage ../data/fonts/lmodern/lmmath.nix {};

  lmodern = callPackage ../data/fonts/lmodern { };

  lobster-two = callPackage ../data/fonts/lobster-two {};

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  marathi-cursive = callPackage ../data/fonts/marathi-cursive { };

  man-pages = callPackage ../data/documentation/man-pages { };

  meslo-lg = callPackage ../data/fonts/meslo-lg {};

  miscfiles = callPackage ../data/misc/miscfiles { };

  media-player-info = callPackage ../data/misc/media-player-info {};

  mobile_broadband_provider_info = callPackage ../data/misc/mobile-broadband-provider-info { };

  montserrat = callPackage ../data/fonts/montserrat { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  mplus-outline-fonts = callPackage ../data/fonts/mplus-outline-fonts { };

  mro-unicode = callPackage ../data/fonts/mro-unicode { };

  nafees = callPackage ../data/fonts/nafees { };

  inherit (callPackages ../data/fonts/noto-fonts {})
    noto-fonts noto-fonts-cjk noto-fonts-emoji;

  numix-icon-theme = callPackage ../data/icons/numix-icon-theme { };

  numix-icon-theme-circle = callPackage ../data/icons/numix-icon-theme-circle { };

  oldstandard = callPackage ../data/fonts/oldstandard { };

  oldsindhi = callPackage ../data/fonts/oldsindhi { };

  open-dyslexic = callPackage ../data/fonts/open-dyslexic { };

  opensans-ttf = callPackage ../data/fonts/opensans-ttf { };

  pecita = callPackage ../data/fonts/pecita {};

  paratype-pt-mono = callPackage ../data/fonts/paratype-pt/mono.nix {};
  paratype-pt-sans = callPackage ../data/fonts/paratype-pt/sans.nix {};
  paratype-pt-serif = callPackage ../data/fonts/paratype-pt/serif.nix {};

  poly = callPackage ../data/fonts/poly { };

  posix_man_pages = callPackage ../data/documentation/man-pages-posix { };

  powerline-fonts = callPackage ../data/fonts/powerline-fonts { };

  proggyfonts = callPackage ../data/fonts/proggyfonts { };

  sampradaya = callPackage ../data/fonts/sampradaya { };

  shared_mime_info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  signwriting = callPackage ../data/fonts/signwriting { };

  soundfont-fluid = callPackage ../data/soundfonts/fluid { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  stix-otf = callPackage ../data/fonts/stix-otf { };

  inherit (callPackages ../data/fonts/gdouros { })
    aegean textfonts symbola aegyptus akkadian anatolian maya unidings musica analecta;

  iana_etc = callPackage ../data/misc/iana-etc { };

  poppler_data = callPackage ../data/misc/poppler-data { };

  quattrocento = callPackage ../data/fonts/quattrocento {};

  quattrocento-sans = callPackage ../data/fonts/quattrocento-sans {};

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  hasklig = callPackage ../data/fonts/hasklig {};

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

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme { };

  themes = name: callPackage (../data/misc/themes + ("/" + name + ".nix")) {};

  theano = callPackage ../data/fonts/theano { };

  tempora_lgc = callPackage ../data/fonts/tempora-lgc { };

  terminus_font = callPackage ../data/fonts/terminus-font { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  tzdata = callPackage ../data/misc/tzdata { };

  ubuntu_font_family = callPackage ../data/fonts/ubuntu-font-family { };

  ucsFonts = callPackage ../data/fonts/ucs-fonts { };

  uni-vga = callPackage ../data/fonts/uni-vga { };

  unifont = callPackage ../data/fonts/unifont { };

  unifont_upper = callPackage ../data/fonts/unifont_upper { };

  vanilla-dmz = callPackage ../data/icons/vanilla-dmz { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  wireless-regdb = callPackage ../data/misc/wireless-regdb { };

  wqy_microhei = callPackage ../data/fonts/wqy-microhei { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xhtml1 = callPackage ../data/sgml+xml/schemas/xml-dtd/xhtml1 { };

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
    inherit (gnome) libglade libgnomecanvas;
    iconTheme = gnome3.defaultIconTheme;
  };

  abook = callPackage ../applications/misc/abook { };

  adobe-reader = callPackage_i686 ../applications/misc/adobe-reader { };

  aeolus = callPackage ../applications/audio/aeolus { };

  aewan = callPackage ../applications/editors/aewan { };

  afterstep = callPackage ../applications/window-managers/afterstep {
    fltk = fltk13;
    gtk = gtk2;
    stdenv = overrideCC stdenv gcc49;
  };

  ahoviewer = callPackage ../applications/graphics/ahoviewer { };

  alchemy = callPackage ../applications/graphics/alchemy { };

  alock = callPackage ../misc/screensavers/alock { };

  inherit (python2Packages) alot;

  alpine = callPackage ../applications/networking/mailreaders/alpine {
    tcl = tcl-8_5;
  };
  realpine = callPackage ../applications/networking/mailreaders/realpine {
    tcl = tcl-8_5;
  };

  AMB-plugins = callPackage ../applications/audio/AMB-plugins { };

  ams-lv2 = callPackage ../applications/audio/ams-lv2 { };

  amsn = callPackage ../applications/networking/instant-messengers/amsn { };

  antimony = qt5.callPackage ../applications/graphics/antimony {};

  antiword = callPackage ../applications/office/antiword {};

  ardour = self.ardour4;

  ardour3 =  callPackage ../applications/audio/ardour/ardour3.nix {
    inherit (gnome) libgnomecanvas libgnomecanvasmm;
    inherit (vamp) vampSDK;
  };

  ardour4 =  callPackage ../applications/audio/ardour {
    inherit (gnome) libgnomecanvas libgnomecanvasmm;
    inherit (vamp) vampSDK;
  };

  ario = callPackage ../applications/audio/ario { };

  arora = callPackage ../applications/networking/browsers/arora { };

  artha = callPackage ../applications/misc/artha { };

  atom = callPackage ../applications/editors/atom {
    gconf = gnome.GConf;
  };

  aseprite = callPackage ../applications/editors/aseprite {
    giflib = giflib_4_1;
  };

  audacious = callPackage ../applications/audio/audacious { };

  audacity = callPackage ../applications/audio/audacity { };

  audio-recorder = callPackage ../applications/audio/audio-recorder { };

  milkytracker = callPackage ../applications/audio/milkytracker { };

  schismtracker = callPackage ../applications/audio/schismtracker { };

  altcoins = recurseIntoAttrs ( callPackage ../applications/altcoins {
    callPackage = newScope { boost = boost155; };
  } );
  bitcoin = self.altcoins.bitcoin;
  bitcoin-xt = self.altcoins.bitcoin-xt;

  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  avidemux_unwrapped = callPackage ../applications/video/avidemux { };

  avidemux = callPackage ../applications/video/avidemux/wrapper.nix {
    avidemux = avidemux_unwrapped;
  };

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

  avrdudess = callPackage ../applications/misc/avrdudess { };

  avxsynth = callPackage ../applications/video/avxsynth {
    libjpeg = libjpeg_original; # error: 'JCOPYRIGHT_SHORT' was not declared in this scope
  };

  awesome-3-4 = callPackage ../applications/window-managers/awesome/3.4.nix {
    cairo = cairo.override { xcbSupport = true; };
    lua = lua5_1;
  };
  awesome-3-5 = callPackage ../applications/window-managers/awesome {
    cairo = cairo.override { xcbSupport = true; };
    luaPackages = luaPackages.override { inherit lua; };
  };
  awesome = self.awesome-3-5;

  awesomebump = qt5.callPackage ../applications/graphics/awesomebump { };

  inherit (gnome3) baobab;

  backintime-common = callPackage ../applications/networking/sync/backintime/common.nix { };

  backintime-qt4 = callPackage ../applications/networking/sync/backintime/qt4.nix { };

  backintime = self.backintime-qt4;

  bandwidth = callPackage ../tools/misc/bandwidth { };

  baresip = callPackage ../applications/networking/instant-messengers/baresip {
    ffmpeg = ffmpeg_1;
  };

  banshee = callPackage ../applications/audio/banshee {
    gconf = pkgs.gnome.GConf;
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
    inherit (gnome) libgnomecanvas libart_lgpl;
    guile = guile_1_8;
  };

  bibletime = callPackage ../applications/misc/bibletime { };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };
  bitlbee-plugins = callPackage ../applications/networking/instant-messengers/bitlbee/plugins.nix { };

  bitlbee-facebook = callPackage ../applications/networking/instant-messengers/bitlbee-facebook { };

  bitlbee-steam = callPackage ../applications/networking/instant-messengers/bitlbee-steam { };

  bitmeter = callPackage ../applications/audio/bitmeter { };

  bleachbit = callPackage ../applications/misc/bleachbit { };

  blender = callPackage  ../applications/misc/blender {
    cudatoolkit = cudatoolkit75;
    python = python35;
  };

  bluefish = callPackage ../applications/editors/bluefish {
    gtk = gtk3;
  };

  bluejeans = callPackage ../applications/networking/browsers/mozilla-plugins/bluejeans { };

  bomi = qt5.callPackage ../applications/video/bomi {
    youtube-dl = pythonPackages.youtube-dl;
    pulseSupport = config.pulseaudio or true;
  };

  brackets = callPackage ../applications/editors/brackets { gconf = gnome3.gconf; };

  bristol = callPackage ../applications/audio/bristol { };

  bs1770gain = callPackage ../applications/audio/bs1770gain { };

  bspwm = callPackage ../applications/window-managers/bspwm { };

  bvi = callPackage ../applications/editors/bvi { };

  bviplus = callPackage ../applications/editors/bviplus { };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome) libglade;
  };

  calcurse = callPackage ../applications/misc/calcurse { };

  calibre = qt55.callPackage ../applications/misc/calibre {
    inherit (pythonPackages) pyqt5 sip_4_16;
  };

  camlistore = callPackage ../applications/misc/camlistore { };

  canto-curses = callPackage ../applications/networking/feedreaders/canto-curses { };

  canto-daemon = callPackage ../applications/networking/feedreaders/canto-daemon { };

  carddav-util = callPackage ../tools/networking/carddav-util { };

  catfish = callPackage ../applications/search/catfish {
    pythonPackages = python3Packages;
  };

  cava = callPackage ../applications/audio/cava { };

  cb2bib = callPackage ../applications/office/cb2bib {
    inherit (xorg) libX11;
  };

  cbatticon = callPackage ../applications/misc/cbatticon { };

  cbc = callPackage ../applications/science/math/cbc { };

  cddiscid = callPackage ../applications/audio/cd-discid { };

  cdparanoia = self.cdparanoiaIII;

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

  CharacterCompressor = callPackage ../applications/audio/CharacterCompressor { };

  chatzilla = callPackage ../applications/networking/irc/chatzilla { };

  chirp = callPackage ../applications/misc/chirp {
    inherit (pythonPackages) pyserial pygtk;
  };

  chromium = callPackage ../applications/networking/browsers/chromium {
    channel = "stable";
    pulseSupport = config.pulseaudio or true;
    enablePepperFlash = config.chromium.enablePepperFlash or false;
    enableWideVine = config.chromium.enableWideVine or false;
    hiDPISupport = config.chromium.hiDPISupport or false;
  };

  chronos = callPackage ../applications/networking/cluster/chronos { };

  chromiumBeta = lowPrio (self.chromium.override { channel = "beta"; });

  chromiumDev = lowPrio (self.chromium.override { channel = "dev"; });

  chuck = callPackage ../applications/audio/chuck { };

  cinelerra = callPackage ../applications/video/cinelerra { };

  clawsMail = callPackage ../applications/networking/mailreaders/claws-mail {
    inherit (gnome3) gsettings_desktop_schemas;
    enableNetworkManager = config.networking.networkmanager.enable or false;
  };

  clfswm = callPackage ../applications/window-managers/clfswm { };

  clipgrab = callPackage ../applications/video/clipgrab { };

  clipit = callPackage ../applications/misc/clipit { };

  cmatrix = callPackage ../applications/misc/cmatrix { };

  cmus = callPackage ../applications/audio/cmus {
    libjack = libjack2;
    libcdio = libcdio082;

    pulseaudioSupport = config.pulseaudio or false;
  };

  communi = qt5.callPackage ../applications/networking/irc/communi { };

  CompBus = callPackage ../applications/audio/CompBus { };

  compiz = callPackage ../applications/window-managers/compiz {
    inherit (gnome) GConf ORBit2 metacity;
  };

  constant-detune-chorus = callPackage ../applications/audio/constant-detune-chorus { };

  copyq = callPackage ../applications/misc/copyq { };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome) libgnomeui GConf;
  };

  cortex = callPackage ../applications/misc/cortex { };

  csound = callPackage ../applications/audio/csound { };

  cinepaint = callPackage ../applications/graphics/cinepaint {
    fltk = fltk13;
    libpng = libpng12;
    cmake = cmake-2_8;
  };

  codeblocks = callPackage ../applications/editors/codeblocks { };
  codeblocksFull = callPackage ../applications/editors/codeblocks { contribPlugins = true; };

  comical = callPackage ../applications/graphics/comical { };

  conkeror-unwrapped = callPackage ../applications/networking/browsers/conkeror { };
  conkeror = self.wrapFirefox conkeror-unwrapped { };

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

  darcs = haskell.lib.overrideCabal self.haskellPackages.darcs (drv: {
    configureFlags = (stdenv.lib.remove "-flibrary" drv.configureFlags or []) ++ ["-f-library"];
    enableSharedExecutables = false;
    enableSharedLibraries = false;
    isLibrary = false;
    doHaddock = false;
    postFixup = "rm -rf $out/lib $out/nix-support $out/share";
  });

  darktable = callPackage ../applications/graphics/darktable {
    inherit (gnome) GConf libglade;
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

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome) libart_lgpl libgnomeui;
  };

  diffuse = callPackage ../applications/version-management/diffuse { };

  direwolf = callPackage ../applications/misc/direwolf { };

  dirt = callPackage ../applications/audio/dirt {};

  distrho = callPackage ../applications/audio/distrho {};

  djvulibre = callPackage ../applications/misc/djvulibre { };

  djvu2pdf = callPackage ../tools/typesetting/djvu2pdf { };

  djview = callPackage ../applications/graphics/djview { };
  djview4 = self.djview;

  dmenu = callPackage ../applications/misc/dmenu { };

  dmenu-wayland = callPackage ../applications/misc/dmenu/wayland.nix { };

  dmenu2 = callPackage ../applications/misc/dmenu2 { };

  dmtx = self.dmtx-utils;

  dmtx-utils = callPackage ../tools/graphics/dmtx-utils { };

  docker = callPackage ../applications/virtualization/docker {
    btrfs-progs = btrfs-progs_4_4_1;
    go = go_1_4;
  };

  docker-gc = callPackage ../applications/virtualization/docker/gc.nix { };

  doodle = callPackage ../applications/search/doodle { };

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

  dzen2 = callPackage ../applications/window-managers/dzen2 { };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse { });

  ed = callPackage ../applications/editors/ed { };

  edbrowse = callPackage ../applications/editors/edbrowse { };

  ekho = callPackage ../applications/audio/ekho { };

  electrum = callPackage ../applications/misc/electrum { };

  electrum-dash = callPackage ../applications/misc/electrum-dash { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = self.emacs24;
  emacsPackages = self.emacs24Packages;
  emacsPackagesNg = self.emacs24PackagesNg;
  emacsMelpa = self.emacs24PackagesNg; # for backward compatibility

  emacs24 = callPackage ../applications/editors/emacs-24 {
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

  emacs24-nox = lowPrio (appendToName "nox" (self.emacs24.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }));

  emacs24Macport_24_5 = lowPrio (callPackage ../applications/editors/emacs-24/macport-24.5.nix {
    inherit (darwin.apple_sdk.frameworks)
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      ImageCaptureCore GSS ImageIO;
  });
  emacs24Macport = self.emacs24Macport_24_5;

  emacs25pre = lowPrio (callPackage ../applications/editors/emacs-25 {
    # use override to enable additional features
    libXaw = xorg.libXaw;
    Xaw3d = null;
    gconf = null;
    alsaLib = null;
    imagemagick = null;
    acl = null;
    gpm = null;
    inherit (darwin.apple_sdk.frameworks) AppKit CoreWLAN GSS Kerberos ImageIO;
  });

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

    dash = callPackage ../applications/editors/emacs-modes/dash { };

    # ecb = callPackage ../applications/editors/emacs-modes/ecb { };

    emacsClangCompleteAsync = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };

    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };

    emms = callPackage ../applications/editors/emacs-modes/emms { };

    ensime = callPackage ../applications/editors/emacs-modes/ensime { };

    erlangMode = callPackage ../applications/editors/emacs-modes/erlang { };

    ess = callPackage ../applications/editors/emacs-modes/ess { };

    flycheck = callPackage ../applications/editors/emacs-modes/flycheck { };

    flymakeCursor = callPackage ../applications/editors/emacs-modes/flymake-cursor { };

    gh = callPackage ../applications/editors/emacs-modes/gh { };

    graphvizDot = callPackage ../applications/editors/emacs-modes/graphviz-dot { };

    gist = callPackage ../applications/editors/emacs-modes/gist { };

    gitModes = callPackage ../applications/editors/emacs-modes/git-modes { };

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

    magit = callPackage ../applications/editors/emacs-modes/magit { };

    markdownMode = callPackage ../applications/editors/emacs-modes/markdown-mode { };

    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };

    metaweblog = callPackage ../applications/editors/emacs-modes/metaweblog { };

    monky = callPackage ../applications/editors/emacs-modes/monky { };

    notmuch = lowPrio (pkgs.notmuch.override { inherit emacs; });

    notmuch-addrlookup = callPackage ../applications/networking/mailreaders/notmuch-addrlookup { };

    ocamlMode = callPackage ../applications/editors/emacs-modes/ocaml { };

    offlineimap = callPackage ../applications/editors/emacs-modes/offlineimap {};

    # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
    # we want it to have higher precedence.
    org = hiPrio (callPackage ../applications/editors/emacs-modes/org { });

    org2blog = callPackage ../applications/editors/emacs-modes/org2blog { };

    pcache = callPackage ../applications/editors/emacs-modes/pcache { };

    phpMode = callPackage ../applications/editors/emacs-modes/php { };

    prologMode = callPackage ../applications/editors/emacs-modes/prolog { };

    proofgeneral_4_2 = callPackage ../applications/editors/emacs-modes/proofgeneral/4.2.nix {
      texinfo = texinfo4 ;
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };
    proofgeneral_4_3_pre = callPackage ../applications/editors/emacs-modes/proofgeneral/4.3pre.nix {
      texinfo = texinfo4 ;
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };
    proofgeneral_HEAD = callPackage ../applications/editors/emacs-modes/proofgeneral/HEAD.nix {
      texinfo = texinfo4 ;
      texLive = texlive.combine { inherit (texlive) scheme-basic cm-super ec; };
    };
    proofgeneral = self.proofgeneral_4_2;

    quack = callPackage ../applications/editors/emacs-modes/quack { };

    rainbowDelimiters = callPackage ../applications/editors/emacs-modes/rainbow-delimiters { };

    rectMark = callPackage ../applications/editors/emacs-modes/rect-mark { };

    remember = callPackage ../applications/editors/emacs-modes/remember { };

    rudel = callPackage ../applications/editors/emacs-modes/rudel { };

    s = callPackage ../applications/editors/emacs-modes/s { };

    sbtMode = callPackage ../applications/editors/emacs-modes/sbt-mode { };

    scalaMode1 = callPackage ../applications/editors/emacs-modes/scala-mode/v1.nix { };
    scalaMode2 = callPackage ../applications/editors/emacs-modes/scala-mode/v2.nix { };

    stratego = callPackage ../applications/editors/emacs-modes/stratego { };

    structuredHaskellMode = haskellPackages.structured-haskell-mode;

    sunriseCommander = callPackage ../applications/editors/emacs-modes/sunrise-commander { };

    tuaregMode = callPackage ../applications/editors/emacs-modes/tuareg { };

    writeGood = callPackage ../applications/editors/emacs-modes/writegood { };

    xmlRpc = callPackage ../applications/editors/emacs-modes/xml-rpc { };

    cask = callPackage ../applications/editors/emacs-modes/cask { };
  };

  emacs24Packages = emacsPackagesGen emacs24 pkgs.emacs24Packages;

  emacsPackagesNgGen = emacs: import ./emacs-packages.nix {
    overrides = (config.emacsPackageOverrides or (p: {})) pkgs;

    inherit lib newScope stdenv;
    inherit fetchFromGitHub fetchgit fetchhg fetchurl;
    inherit emacs texinfo makeWrapper;
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
      inherit rtags libffi autoconf automake libpng zlib poppler pkgconfig;
    };
  };

  emacs24PackagesNg = emacsPackagesNgGen emacs24;

  emacs24WithPackages = emacs24PackagesNg.emacsWithPackages;
  emacsWithPackages = emacsPackagesNg.emacsWithPackages;

  inherit (gnome3) empathy;

  enhanced-ctorrent = callPackage ../applications/networking/enhanced-ctorrent { };

  epdfview = callPackage ../applications/misc/epdfview { };

  inherit (gnome3) epiphany;

  eq10q = callPackage ../applications/audio/eq10q { };

  espeak = callPackage ../applications/audio/espeak { };

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  esniper = callPackage ../applications/networking/esniper { };

  eterm = callPackage ../applications/misc/eterm { };

  etherape = callPackage ../applications/networking/sniffers/etherape {
    inherit (gnome) gnomedocutils libgnome libglade libgnomeui scrollkeeper;
  };

  evilvte = callPackage ../applications/misc/evilvte {
    configH = config.evilvte.config or "";
  };

  evopedia = callPackage ../applications/misc/evopedia { };

  keepassx = callPackage ../applications/misc/keepassx { };
  keepassx2 = callPackage ../applications/misc/keepassx/2.0.nix { };

  inherit (gnome3) evince;
  evolution_data_server = gnome3.evolution_data_server;

  keepass = callPackage ../applications/misc/keepass { };

  keepass-keefox = callPackage ../applications/misc/keepass-plugins/keefox { };

  exrdisplay = callPackage ../applications/graphics/exrdisplay {
    fltk = fltk20;
  };

  fbpanel = callPackage ../applications/window-managers/fbpanel { };

  fbreader = callPackage ../applications/misc/fbreader { };

  fetchmail = callPackage ../applications/misc/fetchmail { };

  fldigi = callPackage ../applications/audio/fldigi { };

  fluidsynth = callPackage ../applications/audio/fluidsynth {
     inherit (darwin.apple_sdk.frameworks) CoreServices CoreAudio AudioUnit;
  };

  fmit = qt5.callPackage ../applications/audio/fmit { };

  focuswriter = callPackage ../applications/editors/focuswriter { };

  font-manager = callPackage ../applications/misc/font-manager {
    vala = vala_0_28;
  };

  foo-yc20 = callPackage ../applications/audio/foo-yc20 { };

  fossil = callPackage ../applications/version-management/fossil { };

  freewheeling = callPackage ../applications/audio/freewheeling { };

  fribid = callPackage ../applications/networking/browsers/mozilla-plugins/fribid { };

  fritzing = qt5.callPackage ../applications/science/electronics/fritzing { };

  fvwm = callPackage ../applications/window-managers/fvwm { };

  geany = callPackage ../applications/editors/geany { };
  geany-with-vte = callPackage ../applications/editors/geany/with-vte.nix { };

  gksu = callPackage ../applications/misc/gksu { };

  gnuradio = callPackage ../applications/misc/gnuradio {
    inherit (pythonPackages) lxml numpy scipy matplotlib pyopengl;
    fftw = fftwFloat;
  };

  gnuradio-with-packages = callPackage ../applications/misc/gnuradio/wrapper.nix {
    extraPackages = [ gnuradio-nacl gnuradio-osmosdr ];
  };

  gnuradio-nacl = callPackage ../applications/misc/gnuradio-nacl { };

  gnuradio-osmosdr = callPackage ../applications/misc/gnuradio-osmosdr { };

  goldendict = callPackage ../applications/misc/goldendict { };

  google-drive-ocamlfuse = callPackage ../applications/networking/google-drive-ocamlfuse { };

  google-musicmanager = callPackage ../applications/audio/google-musicmanager { };

  gpa = callPackage ../applications/misc/gpa { };

  gpicview = callPackage ../applications/graphics/gpicview { };

  gqrx = callPackage ../applications/misc/gqrx { };

  grass = callPackage ../applications/gis/grass { };

  grepm = callPackage ../applications/search/grepm { };

  grip = callPackage ../applications/misc/grip {
    inherit (gnome) libgnome libgnomeui vte;
  };

  gsimplecal = callPackage ../applications/misc/gsimplecal { };

  gtimelog = pythonPackages.gtimelog;

  inherit (gnome3) gucharmap;

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  gjay = callPackage ../applications/audio/gjay { };

  photivo = callPackage ../applications/graphics/photivo { };

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wireshark-cli = callPackage ../applications/networking/sniffers/wireshark {
    withQt = false;
    withGtk = false;
  };
  wireshark-gtk = wireshark-cli.override { withGtk = true; };
  wireshark-qt = wireshark-cli.override { withQt = true; };
  wireshark = wireshark-gtk;

  wvdial = callPackage ../os-specific/linux/wvdial { };

  fbida = callPackage ../applications/graphics/fbida { };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  filezilla = callPackage ../applications/networking/ftp/filezilla { };

  inherit (callPackages ../applications/networking/browsers/firefox {
    inherit (gnome) libIDL;
    inherit (pythonPackages) pysqlite;
    libpng = libpng_apng;
    enableGTK3 = false;
  }) firefox-unwrapped firefox-esr-unwrapped;

  firefox = self.wrapFirefox firefox-unwrapped { };
  firefox-esr = self.wrapFirefox firefox-esr-unwrapped { };

  firefox-bin-unwrapped = callPackage ../applications/networking/browsers/firefox-bin {
    gconf = pkgs.gnome.GConf;
    inherit (pkgs.gnome) libgnome libgnomeui;
  };

  firefox-bin = self.wrapFirefox firefox-bin-unwrapped {
    browserName = "firefox";
    name = "firefox-bin-" +
      (builtins.parseDrvName firefox-bin-unwrapped.name).version;
    desktopName = "Firefox";
  };

  firestr = qt5.callPackage ../applications/networking/p2p/firestr
    { boost = boost155;
    };

  flac = callPackage ../applications/audio/flac { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer-11 {
    debug = config.flashplayer.debug or false;
  };

  flashplayer-standalone = self.pkgsi686Linux.flashplayer.sa;

  flashplayer-standalone-debugger = (self.pkgsi686Linux.flashplayer.override { debug = true; }).sa;

  fluxbox = callPackage ../applications/window-managers/fluxbox { };

  fme = callPackage ../applications/misc/fme {
    inherit (gnome) libglademm;
  };

  fomp = callPackage ../applications/audio/fomp { };

  freecad = callPackage ../applications/graphics/freecad {
    boost = boost155;
    opencascade = opencascade_oce;
    inherit (pythonPackages) matplotlib pycollada;
  };

  freemind = callPackage ../applications/misc/freemind { };

  freenet = callPackage ../applications/networking/p2p/freenet { };

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
  inherit (xorg) xlsfonts;

  freerdp = callPackage ../applications/networking/remote/freerdp {
    ffmpeg = ffmpeg_1;
  };

  freerdpUnstable = callPackage ../applications/networking/remote/freerdp/unstable.nix {
    cmake = cmake-2_8;
  };

  freicoin = callPackage ../applications/misc/freicoin {
    boost = boost155;
  };

  game-music-emu = callPackage ../applications/audio/game-music-emu { };

  gcolor2 = callPackage ../applications/graphics/gcolor2 { };

  get_iplayer = callPackage ../applications/misc/get_iplayer {};

  gimp_2_8 = callPackage ../applications/graphics/gimp/2.8.nix {
    inherit (gnome) libart_lgpl;
    webkit = null;
    lcms = lcms2;
    wrapPython = pythonPackages.wrapPython;
  };

  gimp = self.gimp_2_8;

  gimp-with-plugins = callPackage ../applications/graphics/gimp/wrapper.nix {
    gimp = gimp_2_8;
    plugins = null; # All packaged plugins enabled, if not explicit plugin list supplied
  };

  gimpPlugins = recurseIntoAttrs (callPackage ../applications/graphics/gimp/plugins {});

  gitAndTools = recurseIntoAttrs (callPackage ../applications/version-management/git-and-tools {});

  inherit (self.gitAndTools) git gitFull gitSVN git-cola svn2git git-radar transcrypt git-crypt;

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

  giv = callPackage ../applications/graphics/giv {
    pcre = pcre.override { unicodeSupport = true; };
  };

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

  idea = recurseIntoAttrs (callPackages ../applications/editors/idea { androidsdk = androidsdk_4_4; });

  libquvi = callPackage ../applications/video/quvi/library.nix { };

  linssid = qt5.callPackage ../applications/networking/linssid { };

  mi2ly = callPackage ../applications/audio/mi2ly {};

  praat = callPackage ../applications/audio/praat { };

  quvi = callPackage ../applications/video/quvi/tool.nix {
    lua5_sockets = lua5_1_sockets;
    lua5 = lua5_1;
  };

  quvi_scripts = callPackage ../applications/video/quvi/scripts.nix { };

  gkrellm = callPackage ../applications/misc/gkrellm { };

  gmu = callPackage ../applications/audio/gmu { };

  gnash = callPackage ../applications/video/gnash {
    inherit (gnome) gtkglext;
  };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer {
    inherit (gnome) GConf;
  };

  gnumeric = callPackage ../applications/office/gnumeric { };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gnunet_svn = lowPrio (callPackage ../applications/networking/p2p/gnunet/svn.nix { });

  gocr = callPackage ../applications/graphics/gocr { };

  gobby5 = callPackage ../applications/editors/gobby {
    inherit (gnome) gtksourceview;
  };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = callPackage ../applications/misc/gphoto2/gphotofs.nix { };

  gramps = callPackage ../applications/misc/gramps { };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };
  graphicsmagick_q16 = callPackage ../applications/graphics/graphicsmagick { quantumdepth = 16; };

  graphicsmagick137 = callPackage ../applications/graphics/graphicsmagick/1.3.7.nix {
    libpng = libpng12;
  };

  gtkpod = callPackage ../applications/audio/gtkpod {
    gnome = gnome3;
    inherit (gnome) libglade;
  };

  jbidwatcher = callPackage ../applications/misc/jbidwatcher {
    java = if stdenv.isLinux then jre else jdk;
  };

  qrencode = callPackage ../tools/graphics/qrencode { };

  gecko_mediaplayer = callPackage ../applications/networking/browsers/mozilla-plugins/gecko-mediaplayer {
    inherit (gnome) GConf;
    browser = firefox-unwrapped;
  };

  geeqie = callPackage ../applications/graphics/geeqie { };

  gigedit = callPackage ../applications/audio/gigedit { };

  gqview = callPackage ../applications/graphics/gqview { };

  gmpc = callPackage ../applications/audio/gmpc {};

  gmtk = callPackage ../applications/networking/browsers/mozilla-plugins/gmtk {
    inherit (gnome) GConf;
  };

  gollum = callPackage ../applications/misc/gollum { };

  google-chrome = callPackage ../applications/networking/browsers/google-chrome { gconf = gnome.GConf; };

  google-chrome-beta = self.google-chrome.override { channel = "beta"; };

  google-chrome-dev = self.google-chrome.override { channel = "dev"; };

  googleearth = callPackage_i686 ../applications/misc/googleearth { };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin {
    libpng = libpng12;
  };

  gosmore = callPackage ../applications/misc/gosmore { };

  gpsbabel = qt5.callPackage ../applications/misc/gpsbabel { };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate { };

  gpsd = callPackage ../servers/gpsd { };

  gpsprune = callPackage ../applications/misc/gpsprune { };

  gtk2fontsel = callPackage ../applications/misc/gtk2fontsel {
    inherit (gnome2) gtk;
  };

  guake = callPackage ../applications/misc/guake {
    gconf = gnome.GConf;
    vte = gnome.vte.override { pythonSupport = true; };
  };

  guitone = callPackage ../applications/version-management/guitone {
    graphviz = graphviz_2_32;
  };

  gv = callPackage ../applications/misc/gv { };

  guvcview = callPackage ../os-specific/linux/guvcview {
    pulseaudioSupport = config.pulseaudio or true;
  };

  gxmessage = callPackage ../applications/misc/gxmessage { };

  hackrf = callPackage ../applications/misc/hackrf { };

  hamster-time-tracker = callPackage ../applications/misc/hamster-time-tracker {
    inherit (pythonPackages) pyxdg pygtk dbus sqlite3;
    inherit (gnome) gnome_python;
  };

  hello = callPackage ../applications/misc/hello { };

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

  hugin = callPackage ../applications/graphics/hugin {
    boost = boost155;
  };

  hydrogen = callPackage ../applications/audio/hydrogen { };

  slack = callPackage ../applications/networking/instant-messengers/slack { };

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

  i3blocks = callPackage ../applications/window-managers/i3/blocks.nix { };

  i3cat = goPackages.i3cat.bin // { outputs = [ "bin" ]; };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    cairo = cairo.override { xcbSupport = true; };
  };

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

  imagemagick_light = self.imagemagick.override {
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
  };

  imagemagick = self.imagemagickBig.override {
    ghostscript = null;
  };

  imagemagickBig = callPackage ../applications/graphics/ImageMagick { };

  # Impressive, formerly known as "KeyJNote".
  impressive = callPackage ../applications/office/impressive {
    # XXX These are the PyOpenGL dependencies, which we need here.
    inherit (pythonPackages) pyopengl;
    inherit (pythonPackages) pillow;
  };

  inferno = callPackage_i686 ../applications/inferno { };

  inkscape = callPackage ../applications/graphics/inkscape {
    inherit (pythonPackages) python pyxml lxml numpy;
    lcms = lcms2;
  };

  inspectrum = callPackage ../applications/misc/inspectrum { };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5;
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

  jabref = callPackage ../applications/office/jabref/default.nix { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jack_oscrolloscope = callPackage ../applications/audio/jack-oscrolloscope { };

  jack_rack = callPackage ../applications/audio/jack-rack { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jackmix = callPackage ../applications/audio/jackmix { };
  jackmix_jack1 = self.jackmix.override { jack = jack1; };

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

  keepnote = callPackage ../applications/office/keepnote {
    pygtk = pyGtkGlade;
  };

  kermit = callPackage ../tools/misc/kermit { };

  keyfinder = qt55.callPackage ../applications/audio/keyfinder { };

  keyfinder-cli = qt5.callPackage ../applications/audio/keyfinder-cli { };

  keymon = callPackage ../applications/video/key-mon { };

  khal = callPackage ../applications/misc/khal { };

  khard = callPackage ../applications/misc/khard { };

  kid3 = callPackage ../applications/audio/kid3 {
    qt = qt4;
  };

  kino = callPackage ../applications/video/kino {
    inherit (gnome) libglade;
  };

  kiwix = callPackage ../applications/misc/kiwix { };

  koji = callPackage ../tools/package-management/koji { };

  ksuperkey = callPackage ../tools/X11/ksuperkey { };

  kubernetes = callPackage ../applications/networking/cluster/kubernetes {
    go = go_1_4;
  };

  lame = callPackage ../development/libraries/lame { };

  larswm = callPackage ../applications/window-managers/larswm { };

  lash = callPackage ../applications/audio/lash { };

  ladspaH = callPackage ../applications/audio/ladspa-sdk/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ladspaPlugins-git = callPackage ../applications/audio/ladspa-plugins/git.nix {
    fftw = fftwSinglePrec;
  };

  ladspa-sdk = callPackage ../applications/audio/ladspa-sdk { };

  caps = callPackage ../applications/audio/caps { };

  LazyLimiter = callPackage ../applications/audio/LazyLimiter { };

  lastwatch = callPackage ../applications/audio/lastwatch { };

  lastfmsubmitd = callPackage ../applications/audio/lastfmsubmitd { };

  lbdb = callPackage ../tools/misc/lbdb { };

  lbzip2 = callPackage ../tools/compression/lbzip2 { };

  lci = callPackage ../applications/science/logic/lci {};

  ldcpp = callPackage ../applications/networking/p2p/ldcpp {
    inherit (gnome) libglade;
  };

  lemonbar = callPackage ../applications/window-managers/lemonbar { };

  lemonbar-xft = callPackage ../applications/window-managers/lemonbar/xft.nix { };

  leo-editor = callPackage ../applications/editors/leo-editor { };

  libowfat = callPackage ../development/libraries/libowfat { };

  librecad = callPackage ../applications/misc/librecad { };
  librecad2 = self.librecad;  # backwards compatibility alias, added 2015-10

  libreoffice = callPackage ../applications/office/libreoffice {
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2 gnome_vfs;
    inherit (gnome3) gsettings_desktop_schemas defaultIconTheme;
    zip = zip.override { enableNLS = false; };
    #glm = glm_0954;
    bluez5 = bluez5_28;
    fontsConf = makeFontsConf {
      fontDirectories = [
        freefont_ttf xorg.fontmiscmisc xorg.fontbhttf
      ];
    };
    clucene_core = clucene_core_2;
    lcms = lcms2;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  };

  liferea = callPackage ../applications/networking/newsreaders/liferea {
    webkitgtk = webkitgtk24x;
  };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome) libglade;
  };

  ledger2 = callPackage ../applications/office/ledger/2.6.3.nix { };
  ledger3 = callPackage ../applications/office/ledger {
    boost = boost155;
  };
  ledger = self.ledger3;

  lighttable = callPackage ../applications/editors/lighttable {};

  links2 = callPackage ../applications/networking/browsers/links2 { };

  linphone = callPackage ../applications/networking/instant-messengers/linphone rec { };

  linuxsampler = callPackage ../applications/audio/linuxsampler {
    bison = bison2;
  };

  llpp = callPackage ../applications/misc/llpp {
    inherit (ocamlPackages_4_02) lablgl findlib;
    ocaml = ocaml_4_02;
  };

  lmms = callPackage ../applications/audio/lmms { };

  loxodo = callPackage ../applications/misc/loxodo { };

  lrzsz = callPackage ../tools/misc/lrzsz { };

  luakit = callPackage ../applications/networking/browsers/luakit {
      inherit (lua51Packages) luafilesystem luasqlite3;
      lua5 = lua5_1;
      gtk = gtk3;
      webkit = webkitgtk2;
  };

  luminanceHDR = qt5.callPackage ../applications/graphics/luminance-hdr { };

  lxdvdrip = callPackage ../applications/video/lxdvdrip { };

  handbrake = callPackage ../applications/video/handbrake {
    webkitgtk = webkitgtk24x;
  };

  lilyterm = callPackage ../applications/misc/lilyterm {
    inherit (gnome) vte;
    gtk = gtk2;
  };

  lv2bm = callPackage ../applications/audio/lv2bm { };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = callPackage ../applications/misc/lyx { };

  makeself = callPackage ../applications/misc/makeself { };

  marathon = callPackage ../applications/networking/cluster/marathon { };

  matchbox = callPackage ../applications/window-managers/matchbox { };

  MBdistortion = callPackage ../applications/audio/MBdistortion { };

  mcpp = callPackage ../development/compilers/mcpp { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  mediainfo = callPackage ../applications/misc/mediainfo { };

  mediainfo-gui = callPackage ../applications/misc/mediainfo-gui { };

  mediathekview = callPackage ../applications/video/mediathekview { };

  meld = callPackage ../applications/version-management/meld { };

  mcomix = callPackage ../applications/graphics/mcomix { };

  mendeley = callPackage ../applications/office/mendeley { };

  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (pythonPackages) curses docutils hg-git dulwich;
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

  midori-unwrapped = callPackage ../applications/networking/browsers/midori {
    webkitgtk = webkitgtk24x;
  };
  midori = wrapFirefox midori-unwrapped { };

  mikmod = callPackage ../applications/audio/mikmod { };

  minicom = callPackage ../tools/misc/minicom { };

  minimodem = callPackage ../applications/audio/minimodem { };

  minidjvu = callPackage ../applications/graphics/minidjvu { };

  minitube = callPackage ../applications/video/minitube { };

  mimms = callPackage ../applications/audio/mimms {};

  mirage = callPackage ../applications/graphics/mirage {
    inherit (pythonPackages) pygtk;
    inherit (pythonPackages) pillow;
  };

  mixxx = callPackage ../applications/audio/mixxx {
    inherit (vamp) vampSDK;
  };

  mjpg-streamer = callPackage ../applications/video/mjpg-streamer { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey { };

  mmex = callPackage ../applications/office/mmex { };

  moc = callPackage ../applications/audio/moc { };

  mod-distortion = callPackage ../applications/audio/mod-distortion { };

  monero = callPackage ../applications/misc/monero { };

  monkeysAudio = callPackage ../applications/audio/monkeys-audio { };

  monkeysphere = callPackage ../tools/security/monkeysphere { };

  monodevelop = callPackage ../applications/editors/monodevelop {};

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
  };

  monotoneViz = callPackage ../applications/version-management/monotone-viz {
    inherit (ocamlPackages_4_01_0) lablgtk ocaml camlp4;
    inherit (gnome) libgnomecanvas glib;
  };

  mopidy = callPackage ../applications/audio/mopidy { };

  mopidy-gmusic = callPackage ../applications/audio/mopidy-gmusic { };

  mopidy-spotify = callPackage ../applications/audio/mopidy-spotify { };

  mopidy-moped = callPackage ../applications/audio/mopidy-moped { };

  mopidy-mopify = callPackage ../applications/audio/mopidy-mopify { };

  mopidy-spotify-tunigo = callPackage ../applications/audio/mopidy-spotify-tunigo { };

  mopidy-youtube = callPackage ../applications/audio/mopidy-youtube { };

  mopidy-soundcloud = callPackage ../applications/audio/mopidy-soundcloud { };

  mopidy-musicbox-webclient = callPackage ../applications/audio/mopidy-musicbox-webclient { };

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

  ncmpc = callPackage ../applications/audio/ncmpc { };

  ncmpcpp = callPackage ../applications/audio/ncmpcpp { };

  nload = callPackage ../applications/networking/nload { };

  normalize = callPackage ../applications/audio/normalize { };

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
  };

  mrpeach = callPackage ../applications/audio/pd-plugins/mrpeach { };

  mrxvt = callPackage ../applications/misc/mrxvt { };

  multimarkdown = callPackage ../tools/typesetting/multimarkdown { };

  multimon-ng = callPackage ../applications/misc/multimon-ng { };

  multisync = callPackage ../applications/misc/multisync {
    inherit (gnome) ORBit2 libbonobo libgnomeui GConf;
  };

  inherit (callPackages ../applications/networking/mumble {
      avahi = avahi.override {
        withLibdnssdCompat = true;
      };
      qt5 = qt55; # Mumble is not compatible with qt55 yet
      jackSupport = config.mumble.jackSupport or false;
      speechdSupport = config.mumble.speechdSupport or false;
      pulseSupport = config.pulseaudio or false;
      iceSupport = config.murmur.iceSupport or true;
    }) mumble mumble_git murmur murmur_git;

  musescore = qt5.callPackage ../applications/audio/musescore { };

  mutt = callPackage ../applications/networking/mailreaders/mutt { };
  mutt-with-sidebar = callPackage ../applications/networking/mailreaders/mutt {
    withSidebar = true;
  };

  mutt-kz = callPackage ../applications/networking/mailreaders/mutt-kz { };

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

  pcmanx-gtk2 = callPackage ../applications/misc/pcmanx-gtk2 { };

  pig = callPackage ../applications/networking/cluster/pig { };

  pijul = callPackage ../applications/version-management/pijul { };

  playonlinux = callPackage ../applications/misc/playonlinux {
     stdenv = stdenv_32bit;
  };

  shotcut = qt5.callPackage ../applications/video/shotcut { };

  smplayer = qt5.callPackage ../applications/video/smplayer { };

  smtube = qt5.callPackage ../applications/video/smtube {};

  sup = callPackage ../applications/networking/mailreaders/sup {
    ruby = ruby_2_3.override { cursesSupport = true; };
  };

  synapse = callPackage ../applications/misc/synapse {
    inherit (gnome3) libgee;
  };

  synfigstudio = callPackage ../applications/graphics/synfigstudio {
    fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
  };

  librep = callPackage ../development/libraries/librep { };

  rep-gtk = callPackage ../development/libraries/rep-gtk { };

  sawfish = callPackage ../applications/window-managers/sawfish { };

  sxhkd = callPackage ../applications/window-managers/sxhkd { };

  msmtp = callPackage ../applications/networking/msmtp {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
 };

  maxlib = callPackage ../applications/audio/pd-plugins/maxlib { };

  pdfdiff = callPackage ../applications/misc/pdfdiff { };

  mupdf = callPackage ../applications/misc/mupdf {
    openjpeg = openjpeg_2_0;
  };

  diffpdf = callPackage ../applications/misc/diffpdf { };

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

  nedit = callPackage ../applications/editors/nedit {
    motif = lesstif;
  };

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    # No need to build Emacs - notmuch.el works just fine without
    # byte-compilation. Use emacs24Packages.notmuch if you want to
    # byte-compiled files
    emacs = null;
    sphinx = pythonPackages.sphinx;
  };

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
    inherit (gnome) libglade;
  };

  obs-studio = qt5.callPackage ../applications/video/obs-studio {
    pulseaudioSupport = config.pulseaudio or true;
  };

  octoprint = callPackage ../applications/misc/octoprint { };

  octoprint-plugins = callPackage ../applications/misc/octoprint/plugins.nix { };

  ocrad = callPackage ../applications/graphics/ocrad { };

  offrss = callPackage ../applications/networking/offrss { };

  ogmtools = callPackage ../applications/video/ogmtools { };

  omxplayer = callPackage ../applications/video/omxplayer { };

  oneteam = callPackage ../applications/networking/instant-messengers/oneteam {};

  openbox = callPackage ../applications/window-managers/openbox { };

  openbox-menu = callPackage ../applications/misc/openbox-menu { };

  openbrf = callPackage ../applications/misc/openbrf { };

  opencpn = callPackage ../applications/misc/opencpn { };

  openimageio = callPackage ../applications/graphics/openimageio { };

  openjump = callPackage ../applications/misc/openjump { };

  openscad = callPackage ../applications/graphics/openscad {};

  opera = callPackage ../applications/networking/browsers/opera {
    inherit (pkgs.kde4) kdelibs;
  };

  vivaldi = callPackage ../applications/networking/browsers/vivaldi {};

  opusfile = callPackage ../applications/audio/opusfile { };

  opusTools = callPackage ../applications/audio/opus-tools { };

  orpie = callPackage ../applications/misc/orpie { gsl = gsl_1; };

  osmo = callPackage ../applications/office/osmo { };

  pamixer = callPackage ../applications/audio/pamixer { };

  pan = callPackage ../applications/networking/newsreaders/pan {
    spellChecking = false;
  };

  panotools = callPackage ../applications/graphics/panotools { };

  paprefs = callPackage ../applications/audio/paprefs {
    inherit (gnome) libglademm gconfmm GConf;
  };

  pavucontrol = callPackage ../applications/audio/pavucontrol { };

  paraview = callPackage ../applications/graphics/paraview { };

  pcsx2 = callPackage_i686 ../misc/emulators/pcsx2 { };

  pencil = callPackage ../applications/graphics/pencil { };

  perseus = callPackage ../applications/science/math/perseus {};

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome) libgnomecanvas;
  };

  pdftk = callPackage ../tools/typesetting/pdftk { };
  pdfgrep  = callPackage ../tools/typesetting/pdfgrep { };

  pdfpc = callPackage ../applications/misc/pdfpc {
    vala = vala_0_26;
    inherit (gnome3) libgee;
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  pflask = callPackage ../os-specific/linux/pflask {};

  photoqt = qt5.callPackage ../applications/graphics/photoqt { };

  phototonic = qt5.callPackage ../applications/graphics/phototonic { };

  pianobar = callPackage ../applications/audio/pianobar { };

  pianobooster = callPackage ../applications/audio/pianobooster { };

  picard = callPackage ../applications/audio/picard {
    python-libdiscid = pythonPackages.discid;
    mutagen = pythonPackages.mutagen;
  };

  picocom = callPackage ../tools/misc/picocom { };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    openssl = if config.pidgin.openssl or true then openssl else null;
    gnutls = if config.pidgin.gnutls or false then gnutls else null;
    libgcrypt = if config.pidgin.gnutls or false then libgcrypt else null;
    startupnotification = libstartup_notification;
  };

  pidgin-with-plugins = callPackage ../applications/networking/instant-messengers/pidgin/wrapper.nix {
    plugins = [];
  };

  pidginlatex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    texLive = texlive.combined.scheme-basic;
  };

  pidginmsnpecan = callPackage ../applications/networking/instant-messengers/pidgin-plugins/msn-pecan { };

  pidgin-mra = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-mra { };

  pidgin-skypeweb = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-skypeweb { };

  pidginotr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidginsipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  pidginwindowmerge = callPackage ../applications/networking/instant-messengers/pidgin-plugins/window-merge { };

  purple-plugin-pack = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-plugin-pack { };

  purple-vk-plugin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/purple-vk-plugin { };

  telegram-purple = callPackage ../applications/networking/instant-messengers/pidgin-plugins/telegram-purple { };

  toxprpl = callPackage ../applications/networking/instant-messengers/pidgin-plugins/tox-prpl { };

  pidgin-opensteamworks = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-opensteamworks { };

  pithos = callPackage ../applications/audio/pithos {
    pythonPackages = python34Packages;
  };

  pinfo = callPackage ../applications/misc/pinfo { };

  pinpoint = callPackage ../applications/office/pinpoint {
    clutter = clutter_1_24;
    clutter_gtk = clutter_gtk_1_6;
  };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtk-sharp;
  };

  plugin-torture = callPackage ../applications/audio/plugin-torture { };

  poezio = python3Packages.poezio;

  pommed = callPackage ../os-specific/linux/pommed {};

  pond = goPackages.pond.bin // { outputs = [ "bin" ]; };

  ponymix = callPackage ../applications/audio/ponymix { };

  potrace = callPackage ../applications/graphics/potrace {};

  posterazor = callPackage ../applications/misc/posterazor { };

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

  pstree = callPackage ../applications/misc/pstree { };

  pulseview = callPackage ../applications/science/electronics/pulseview { };

  puredata = callPackage ../applications/audio/puredata { };
  puredata-with-plugins = plugins: callPackage ../applications/audio/puredata/wrapper.nix { inherit plugins; };

  puremapping = callPackage ../applications/audio/pd-plugins/puremapping { };

  pybitmessage = callPackage ../applications/networking/instant-messengers/pybitmessage { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qbittorrent = callPackage ../applications/networking/p2p/qbittorrent {
    boost = boost;
    libtorrentRasterbar = libtorrentRasterbar;
  };

  eiskaltdcpp = callPackage ../applications/networking/p2p/eiskaltdcpp { lua5 = lua5_1; };

  qemu = callPackage ../applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa;
    inherit (darwin.stubs) rez setfile;
  };

  qjackctl = callPackage ../applications/audio/qjackctl { };

  QmidiNet = callPackage ../applications/audio/QmidiNet { };

  qmidiroute = callPackage ../applications/audio/qmidiroute { };

  qmmp = callPackage ../applications/audio/qmmp { };

  qnotero = callPackage ../applications/office/qnotero { };

  qrcode = callPackage ../tools/graphics/qrcode {};

  qsampler = callPackage ../applications/audio/qsampler { };

  qsynth = callPackage ../applications/audio/qsynth { };

  qtox = qt5.callPackage ../applications/networking/instant-messengers/qtox { };

  qtpass = qt5.callPackage ../applications/misc/qtpass { };

  qtpfsgui = callPackage ../applications/graphics/qtpfsgui { };

  qtractor = callPackage ../applications/audio/qtractor { };

  qtscrobbler = callPackage ../applications/audio/qtscrobbler { };

  quirc = callPackage ../tools/graphics/quirc {};

  quodlibet = callPackage ../applications/audio/quodlibet {
    inherit (pythonPackages) mutagen;
  };

  quodlibet-with-gst-plugins = callPackage ../applications/audio/quodlibet {
    inherit (pythonPackages) mutagen;
    withGstPlugins = true;
    gst_plugins_bad = null;
  };

  qutebrowser = qt55.callPackage ../applications/networking/browsers/qutebrowser {
    inherit (python34Packages) buildPythonApplication python pyqt5 jinja2 pygments pyyaml pypeg2;
    inherit (gst_all_1) gst-plugins-base gst-plugins-good gst-plugins-bad gst-libav;
  };

  rabbitvcs = callPackage ../applications/version-management/rabbitvcs {};

  rakarrack = callPackage ../applications/audio/rakarrack {
    fltk = fltk13;
  };

  renoise = callPackage ../applications/audio/renoise {
    demo = false;
  };

  rapcad = qt5.callPackage ../applications/graphics/rapcad { boost = boost159; };

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratmen = callPackage ../tools/X11/ratmen {};

  ratox = callPackage ../applications/networking/instant-messengers/ratox { };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftwSinglePrec;
  };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  recode = callPackage ../tools/text/recode { };

  remotebox = callPackage ../applications/virtualization/remotebox { };

  retroshare = callPackage ../applications/networking/p2p/retroshare {
    qt = qt4;
  };

  retroshare06 = lowPrio (callPackage ../applications/networking/p2p/retroshare/0.6.nix {
    qt = qt4;
  });

  RhythmDelay = callPackage ../applications/audio/RhythmDelay { };

  ricochet = qt5.callPackage ../applications/networking/instant-messengers/ricochet { };

  rkt = callPackage ../applications/virtualization/rkt { };

  rofi = callPackage ../applications/misc/rofi { };

  rofi-pass = callPackage ../tools/security/pass/rofi-pass.nix { };

  rstudio = callPackage ../applications/editors/rstudio { };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS || stdenv.isFreeBSD);
    enableCopyDevicesPatch = (config.rsync.enableCopyDevicesPatch or false);
  };
  rrsync = callPackage ../applications/networking/sync/rsync/rrsync.nix {};

  rtl-sdr = callPackage ../applications/misc/rtl-sdr { };

  rtv = callPackage ../applications/misc/rtv { };

  rubyripper = callPackage ../applications/audio/rubyripper {};

  rxvt = callPackage ../applications/misc/rxvt { };

  # = urxvt
  rxvt_unicode = callPackage ../applications/misc/rxvt_unicode {
    perlSupport = true;
    gdkPixbufSupport = true;
    unicode3Support = true;
  };

  udevil = callPackage ../applications/misc/udevil {};

  # urxvt plugins
  urxvt_perl = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perl { };
  urxvt_perls = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-perls { };
  urxvt_tabbedex = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-tabbedex { };
  urxvt_font_size = callPackage ../applications/misc/rxvt_unicode-plugins/urxvt-font-size { };

  rxvt_unicode-with-plugins = callPackage ../applications/misc/rxvt_unicode/wrapper.nix {
    plugins = [ urxvt_perl urxvt_perls urxvt_tabbedex urxvt_font_size ];
  };

  sakura = callPackage ../applications/misc/sakura {
    vte = gnome3.vte_290;
  };

  sbagen = callPackage ../applications/misc/sbagen { };

  scantailor = callPackage ../applications/graphics/scantailor {
    boost = boost155;
  };

  sc-im = callPackage ../applications/misc/sc-im { };

  scite = callPackage ../applications/editors/scite { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome) libart_lgpl;
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

  sflphone = callPackage ../applications/networking/instant-messengers/sflphone {
    gtk = gtk3;
  };

  simple-scan = callPackage ../applications/graphics/simple-scan { };

  siproxd = callPackage ../applications/networking/siproxd { };

  skype = callPackage_i686 ../applications/networking/instant-messengers/skype {
    qt4 = pkgsi686Linux.qt4.override {
      stdenv = pkgsi686Linux.clangStdenv;
    };
  };

  skype4pidgin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/skype4pidgin { };

  skype_call_recorder = callPackage ../applications/networking/instant-messengers/skype-call-recorder { };

  slmenu = callPackage ../applications/misc/slmenu {};

  slop = callPackage ../tools/misc/slop {};

  slrn = callPackage ../applications/networking/newsreaders/slrn { };

  sooperlooper = callPackage ../applications/audio/sooperlooper { };

  sorcer = callPackage ../applications/audio/sorcer { };

  sound-juicer = callPackage ../applications/audio/sound-juicer { };

  spice-vdagent = callPackage ../applications/virtualization/spice-vdagent { };

  spideroak = callPackage ../applications/networking/spideroak { };

  ssvnc = callPackage ../applications/networking/remote/ssvnc { };

  viber = callPackage ../applications/networking/instant-messengers/viber { };

  sonic-pi = callPackage ../applications/audio/sonic-pi {
    ruby = ruby_2_2;
  };

  st = callPackage ../applications/misc/st {
    conf = config.st.conf or null;
  };

  st-wayland = callPackage ../applications/misc/st/wayland.nix {
    conf = config.st.conf or null;
  };

  stag = callPackage ../applications/misc/stag {
    curses = ncurses;
  };

  stella = callPackage ../misc/emulators/stella { };

  statsd = callPackage ../tools/networking/statsd {
    nodejs = nodejs-0_10;
  };

  linuxstopmotion = callPackage ../applications/video/linuxstopmotion { };

  sweethome3d = recurseIntoAttrs (  (callPackage ../applications/misc/sweethome3d { })
                                 // (callPackage ../applications/misc/sweethome3d/editors.nix {
                                      sweethome3dApp = sweethome3d.application;
                                    })
                                 );

  swingsane = callPackage ../applications/graphics/swingsane { };

  sxiv = callPackage ../applications/graphics/sxiv { };

  bittorrentSync = self.bittorrentSync14;
  bittorrentSync14 = callPackage ../applications/networking/bittorrentsync/1.4.x.nix { };
  bittorrentSync20 = callPackage ../applications/networking/bittorrentsync/2.0.x.nix { };

  copy-com = callPackage ../applications/networking/copy-com { };

  dropbox = qt55.callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox-cli { };

  lightdm = qt5.callPackage ../applications/display-managers/lightdm {
    qt4 = null;
    withQt5 = false;
  };

  lightdm_qt = self.lightdm.override { withQt5 = true; };

  lightdm_gtk_greeter = callPackage ../applications/display-managers/lightdm-gtk-greeter { };

  slic3r = callPackage ../applications/misc/slic3r { };

  curaengine = callPackage ../applications/misc/curaengine { };

  cura = callPackage ../applications/misc/cura { };

  curaLulzbot = callPackage ../applications/misc/cura/lulzbot.nix { };

  peru = callPackage ../applications/version-management/peru {};

  printrun = callPackage ../applications/misc/printrun { };

  sddm = kde5.sddm;

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

  sox = callPackage ../applications/misc/audio/sox { };

  soxr = callPackage ../applications/misc/audio/soxr { };

  spek = callPackage ../applications/audio/spek { };

  spotify = callPackage ../applications/audio/spotify {
    inherit (gnome) GConf;
    libgcrypt = libgcrypt_1_5;
    libpng = libpng12;
  };

  libspotify = callPackage ../development/libraries/libspotify {
    apiKey = config.libspotify.apiKey or null;
  };

  ltunify = callPackage ../tools/misc/ltunify { };

  src = callPackage ../applications/version-management/src/default.nix {
    git = gitMinimal;
  };

  stalonetray = callPackage ../applications/window-managers/stalonetray {};

  stp = callPackage ../applications/science/logic/stp {};

  stumpwm = callPackage ../applications/window-managers/stumpwm {
    sbcl = sbcl_1_2_5;
    lispPackages = lispPackagesFor (wrapLisp sbcl_1_2_5);
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

  syncthing = go15Packages.syncthing.bin // { outputs = [ "bin" ]; };
  syncthing011 = go15Packages.syncthing011.bin // { outputs = [ "bin" ]; };

  # linux only by now
  synergy = callPackage ../applications/misc/synergy { };

  tabbed = callPackage ../applications/window-managers/tabbed {
    enableXft = true;
  };

  taffybar = callPackage ../applications/window-managers/taffybar {
    inherit (haskellPackages) ghcWithPackages;
  };

  tagainijisho = callPackage ../applications/office/tagainijisho {};

  tahoelafs = callPackage ../tools/networking/p2p/tahoe-lafs {};

  tailor = callPackage ../applications/version-management/tailor {};

  tangogps = callPackage ../applications/misc/tangogps {
    gconf = gnome.GConf;
  };

  teamspeak_client = qt55.callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };
  teamspeak_server = callPackage ../applications/networking/instant-messengers/teamspeak/server.nix { };

  taskjuggler = callPackage ../applications/misc/taskjuggler { };

  tasknc = callPackage ../applications/misc/tasknc { };

  taskwarrior = callPackage ../applications/misc/taskwarrior { };

  tasksh = callPackage ../applications/misc/tasksh { };

  taskserver = callPackage ../servers/misc/taskserver { };

  tdesktop = qt55.callPackage ../applications/networking/instant-messengers/telegram/tdesktop { };

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
    vte = gnome.vte.override { pythonSupport = true; };
    inherit (pythonPackages) notify;
  };

  termite = callPackage ../applications/misc/termite {
    vte = gnome3.vte-select-text;
  };

  tesseract = callPackage ../applications/graphics/tesseract { };

  tetraproc = callPackage ../applications/audio/tetraproc { };

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  thunderbird = callPackage ../applications/networking/mailreaders/thunderbird {
    inherit (gnome) libIDL;
    inherit (pythonPackages) pysqlite;
    libpng = libpng_apng;
  };

  thunderbird-bin = callPackage ../applications/networking/mailreaders/thunderbird-bin {
    gconf = pkgs.gnome.GConf;
    inherit (pkgs.gnome) libgnome libgnomeui;
  };

  tig = gitAndTools.tig;

  tilda = callPackage ../applications/misc/tilda {
    vte = gnome3.vte_290;
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

  todo-txt-cli = callPackage ../applications/office/todo.txt-cli { };

  tomahawk = callPackage ../applications/audio/tomahawk {
    inherit (pkgs.kde4) kdelibs;
    taglib = taglib_1_9;
    enableXMPP      = config.tomahawk.enableXMPP      or true;
    enableKDE       = config.tomahawk.enableKDE       or false;
    enableTelepathy = config.tomahawk.enableTelepathy or false;
    quazip = qt5.quazip.override { qt = qt4; };
  };

  torchPackages = recurseIntoAttrs ( callPackage ../applications/science/machine-learning/torch {
    lua = luajit ;
  } );

  torch-repl = lib.setName "torch-repl" torchPackages.trepl;

  torchat = callPackage ../applications/networking/instant-messengers/torchat {
    wrapPython = pythonPackages.wrapPython;
  };

  tortoisehg = callPackage ../applications/version-management/tortoisehg { };

  toxic = callPackage ../applications/networking/instant-messengers/toxic { };

  transcode = callPackage ../applications/audio/transcode { };

  transmission = callPackage ../applications/networking/p2p/transmission { };
  transmission_gtk = transmission.override { enableGTK3 = true; };

  transmission_remote_gtk = callPackage ../applications/networking/p2p/transmission-remote-gtk {};

  trayer = callPackage ../applications/window-managers/trayer { };

  tree = callPackage ../tools/system/tree {};

  trezor-bridge = callPackage ../applications/networking/browsers/mozilla-plugins/trezor { };

  tribler = callPackage ../applications/networking/p2p/tribler { };

  github-release = callPackage ../development/tools/github/github-release { };

  tudu = callPackage ../applications/office/tudu { };

  tuxguitar = callPackage ../applications/editors/music/tuxguitar { };

  twister = callPackage ../applications/networking/p2p/twister { };

  twmn = qt5.callPackage ../applications/misc/twmn { };

  twinkle = callPackage ../applications/networking/instant-messengers/twinkle { };

  umurmur = callPackage ../applications/networking/umurmur { };

  unison = callPackage ../applications/networking/sync/unison {
    inherit (ocamlPackages) lablgtk;
    enableX11 = config.unison.enableX11 or true;
  };

  unpaper = callPackage ../tools/graphics/unpaper { };

  uucp = callPackage ../tools/misc/uucp { };

  uvccapture = callPackage ../applications/video/uvccapture { };

  uwimap = callPackage ../tools/networking/uwimap { };

  uzbl = callPackage ../applications/networking/browsers/uzbl {
    webkit = webkitgtk2;
  };

  utox = callPackage ../applications/networking/instant-messengers/utox { };

  vanitygen = callPackage ../applications/misc/vanitygen { };

  vanubi = callPackage ../applications/editors/vanubi {
    vala = vala_0_26;
  };

  vbindiff = callPackage ../applications/editors/vbindiff { };

  vcprompt = callPackage ../applications/version-management/vcprompt { };

  vdirsyncer = callPackage ../tools/misc/vdirsyncer { pythonPackages = python3Packages; };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  vim = callPackage ../applications/editors/vim {
    inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
  };

  macvim = callPackage ../applications/editors/vim/macvim.nix { stdenv = clangStdenv; };

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

  qtile = callPackage ../applications/window-managers/qtile { };

  qvim = lowPrio (callPackage ../applications/editors/vim/qvim.nix {
    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  vimpc = callPackage ../applications/audio/vimpc { };

  neovim = callPackage ../applications/editors/neovim {
    inherit (lua52Packages) lpeg luaMessagePack luabitop;
  };

  neovim-qt = callPackage ../applications/editors/neovim/qt.nix {
    qt5 = qt55;
  };

  neovim-pygui = pythonPackages.neovim_gui;

  virt-viewer = callPackage ../applications/virtualization/virt-viewer {
    gtkvnc = gtkvnc.override { enableGTK3 = true; };
    spice_gtk = spice_gtk.override { enableGTK3 = true; };
  };
  virtmanager = callPackage ../applications/virtualization/virt-manager {
    inherit (gnome) gnome_python;
    vte = gnome3.vte;
    dconf = gnome3.dconf;
    gtkvnc = gtkvnc.override { enableGTK3 = true; };
    spice_gtk = spice_gtk.override { enableGTK3 = true; };
    system-libvirt = libvirt;
  };

  virtinst = callPackage ../applications/virtualization/virtinst {};

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
  };

  vkeybd = callPackage ../applications/audio/vkeybd {};

  vlc = callPackage ../applications/video/vlc {
    ffmpeg = ffmpeg_2;
  };

  vlc_qt5 = qt5.vlc;

  vmpk = callPackage ../applications/audio/vmpk { };

  vnstat = callPackage ../applications/networking/vnstat { };

  VoiceOfFaust = callPackage ../applications/audio/VoiceOfFaust { };

  vorbis-tools = callPackage ../applications/audio/vorbis-tools { };

  vscode = callPackage ../applications/editors/vscode {
    gconf = pkgs.gnome.GConf;
  };

  vue = callPackage ../applications/misc/vue { };

  vwm = callPackage ../applications/window-managers/vwm { };

  vym = callPackage ../applications/misc/vym { };

  w3m = callPackage ../applications/networking/browsers/w3m { };

  # Should always be the version with the most features
  w3m-full = w3m;

  # Version without X11
  w3m-nox = w3m.override {
    x11Support = false;
  };

  # Version for batch text processing, not a good browser
  w3m-batch = w3m.override {
    graphicsSupport = false;
    x11Support = false;
    mouseSupport = false;
  };

  weechat = callPackage ../applications/networking/irc/weechat {
    inherit (darwin) libobjc;
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
    freerdp = freerdpUnstable;
  };

  windowlab = callPackage ../applications/window-managers/windowlab { };

  windowmaker = callPackage ../applications/window-managers/windowmaker { };

  alsamixer.app = callPackage ../applications/window-managers/windowmaker/dockapps/alsamixer.app.nix { };

  wmcalclock = callPackage ../applications/window-managers/windowmaker/dockapps/wmcalclock.nix { };

  wmsm.app = callPackage ../applications/window-managers/windowmaker/dockapps/wmsm.app.nix { };

  wmsystemtray = callPackage ../applications/window-managers/windowmaker/dockapps/wmsystemtray.nix { };

  winswitch = callPackage ../tools/X11/winswitch { };

  wings = callPackage ../applications/graphics/wings { };

  wmname = callPackage ../applications/misc/wmname { };

  wmctrl = callPackage ../tools/X11/wmctrl { };

  wmii_hg = callPackage ../applications/window-managers/wmii-hg { };

  wordnet = callPackage ../applications/misc/wordnet { };

  workrave = callPackage ../applications/misc/workrave {
    inherit (gnome) GConf gconfmm;
    inherit (python27Packages) cheetah;
  };

  wpsoffice = callPackage ../applications/office/wpsoffice {};

  wrapFirefox = callPackage ../applications/networking/browsers/firefox/wrapper.nix { };

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
      ++ optional (cfg.enableMupen64Plus or false) mupen64plus
      ++ optional (cfg.enableNestopia or false) nestopia
      ++ optional (cfg.enablePicodrive or false) picodrive
      ++ optional (cfg.enablePrboom or false) prboom
      ++ optional (cfg.enablePPSSPP or false) ppsspp
      ++ optional (cfg.enableQuickNES or false) quicknes
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
      ++ optional (config.kodi.enableGenesis or false) genesis
      ++ optionals (config.kodi.enableHyperLauncher or false)
           (with hyper-launcher; [ plugin service pdfreader ])
      ++ optionals (config.kodi.enableSALTS or false) [salts urlresolver t0mm0-common]
      ++ optional (config.kodi.enableSVTPlay or false) svtplay
      ++ optional (config.kodi.enableSteamLauncher or false) steam-launcher
      ++ optional (config.kodi.enablePVRHTS or false) pvr-hts
      );
  };

  wxhexeditor = callPackage ../applications/editors/wxhexeditor { };

  wxcam = callPackage ../applications/video/wxcam {
    inherit (gnome) libglade;
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

  kodiPlain = callPackage ../applications/video/kodi { };
  xbmcPlain = self.kodiPlain;

  kodiPlugins = recurseIntoAttrs (callPackage ../applications/video/kodi/plugins.nix {
    kodi = kodiPlain;
  });
  xbmcPlugins = self.kodiPlugins;

  kodi = self.wrapKodi {
    kodi = kodiPlain;
  };
  xbmc = self.kodi;

  kodi-retroarch-advanced-launchers =
    callPackage ../misc/emulators/retroarch/kodi-advanced-launchers.nix {
      cores = retroArchCores;
  };
  xbmc-retroarch-advanced-launchers = self.kodi-retroarch-advanced-launchers;

  xca = callPackage ../applications/misc/xca { };

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

  xdotool = callPackage ../tools/X11/xdotool { };

  xen_4_5_0 = callPackage ../applications/virtualization/xen/4.5.0.nix { stdenv = overrideCC stdenv gcc49; };
  xen_4_5_2 = callPackage ../applications/virtualization/xen/4.5.2.nix { stdenv = overrideCC stdenv gcc49; };
  xen_xenServer = callPackage ../applications/virtualization/xen/4.5.0.nix { xenserverPatched = true; stdenv = overrideCC stdenv gcc49; };
  xen = xen_4_5_2;

  win-spice = callPackage ../applications/virtualization/driver/win-spice { };
  win-virtio = callPackage ../applications/virtualization/driver/win-virtio { };
  win-qemu = callPackage ../applications/virtualization/driver/win-qemu { };
  win-pvdrivers = callPackage ../applications/virtualization/driver/win-pvdrivers { };
  win-signed-gplpv-drivers = callPackage ../applications/virtualization/driver/win-signed-gplpv-drivers { };

  xfe = callPackage ../applications/misc/xfe {
    fox = fox_1_6;
  };

  xfig = callPackage ../applications/graphics/xfig { };

  xineUI = callPackage ../applications/video/xine-ui { };

  xneur_0_13 = callPackage ../applications/misc/xneur { };

  xneur_0_8 = callPackage ../applications/misc/xneur/0.8.nix { };

  xneur = xneur_0_13;

  gxneur = callPackage ../applications/misc/gxneur  {
    inherit (gnome) libglade GConf;
  };

  xiphos = callPackage ../applications/misc/xiphos {
    gconf = gnome2.GConf;
    inherit (gnome2) gtkhtml libgtkhtml libglade scrollkeeper;
    python = python27;
    webkitgtk = webkitgtk2;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome) libgnomeprint libgnomeprintui libgnomecanvas;
  };

  apvlv = callPackage ../applications/misc/apvlv { };

  xpdf = callPackage ../applications/misc/xpdf {
    motif = lesstif;
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

  xmpp-client = go15Packages.xmpp-client.bin // { outputs = [ "bin" ]; };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra { inherit (texFunctions) fontsConf; };
  libfakeXinerama = callPackage ../tools/X11/xpra/libfakeXinerama.nix { };
  #TODO: 'pil' is not available for python3, yet
  xpraGtk3 = callPackage ../tools/X11/xpra/gtk3.nix { inherit (texFunctions) fontsConf; inherit (python3Packages) buildPythonApplication python cython pygobject3 pycairo; };

  xrestop = callPackage ../tools/X11/xrestop { };

  xscreensaver = callPackage ../misc/screensavers/xscreensaver {
    inherit (gnome) libglade;
  };

  xss-lock = callPackage ../misc/screensavers/xss-lock { };

  xsynth_dssi = callPackage ../applications/audio/xsynth-dssi { };

  xterm = callPackage ../applications/misc/xterm { };

  finalterm = callPackage ../applications/misc/finalterm { };

  roxterm = callPackage ../applications/misc/roxterm {
    inherit (pythonPackages) lockfile;
    inherit (gnome3) gsettings_desktop_schemas;
    vte = gnome3.vte_290;
  };

  xtrace = callPackage ../tools/X11/xtrace { };

  xlaunch = callPackage ../tools/X11/xlaunch { };

  xmacro = callPackage ../tools/X11/xmacro { };

  xmove = callPackage ../applications/misc/xmove { };

  xmp = callPackage ../applications/audio/xmp { };

  xnee = callPackage ../tools/X11/xnee { };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gnome) scrollkeeper libglade;
  };

  xzgv = callPackage ../applications/graphics/xzgv { };

  yate = callPackage ../applications/misc/yate { };

  inherit (gnome3) yelp;

  inherit (pythonPackages) youtube-dl;

  qgis = callPackage ../applications/gis/qgis {};

  qgroundcontrol = qt55.callPackage ../applications/science/robotics/qgroundcontrol { };

  qtbitcointrader = callPackage ../applications/misc/qtbitcointrader {
    qt = qt4;
  };

  pahole = callPackage ../development/tools/misc/pahole {};

  yarp = callPackage ../applications/science/misc/yarp {};

  yed = callPackage ../applications/graphics/yed {};

  ykpers = callPackage ../applications/misc/ykpers {};

  yoshimi = callPackage ../applications/audio/yoshimi {
    fltk = fltk13.override { cfg.xftSupport = true; };
  };

  zam-plugins = callPackage ../applications/audio/zam-plugins { };

  zathuraCollection = recurseIntoAttrs
    (callPackage ../applications/misc/zathura {
        callPackage = newScope pkgs.zathuraCollection;
        useMupdf = config.zathura.useMupdf or true;
      });

  zathura = zathuraCollection.zathuraWrapper;

  zed = callPackage ../applications/editors/zed { };

  zeroc_ice = callPackage ../development/libraries/zeroc-ice { };

  zexy = callPackage ../applications/audio/pd-plugins/zexy  { };

  girara = callPackage ../applications/misc/girara {
    gtk = gtk3;
  };

  girara-light = callPackage ../applications/misc/girara {
    gtk = gtk3;
    withBuildColors = false;
    ncurses = null;
  };

  zgrviewer = callPackage ../applications/graphics/zgrviewer {};

  zim = callPackage ../applications/office/zim {
    pygtk = pyGtkGlade;
  };

  zotero = callPackage ../applications/office/zotero {
    firefox = firefox-unwrapped;
  };

  zscroll = callPackage ../applications/misc/zscroll {};

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx { };

  ### GAMES

  "2048-in-terminal" = callPackage ../games/2048-in-terminal { };

  "90secondportraits" = callPackage ../games/90secondportraits { love = love_0_10; };

  adom = callPackage ../games/adom { };

  airstrike = callPackage ../games/airstrike { };

  alienarena = callPackage ../games/alienarena { };

  andyetitmoves = if stdenv.isLinux then callPackage ../games/andyetitmoves {} else null;

  anki = callPackage ../games/anki {
    inherit (pythonPackages) wrapPython pysqlite sqlalchemy pyaudio beautifulsoup httplib2 matplotlib;
  };

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

  beret = callPackage ../games/beret { };

  bitsnbots = callPackage ../games/bitsnbots {
    lua = lua5;
  };

  blackshades = callPackage ../games/blackshades { };

  blackshadeselite = callPackage ../games/blackshadeselite { };

  blobby = callPackage ../games/blobby { };

  bsdgames = callPackage ../games/bsdgames { };

  btanks = callPackage ../games/btanks { };

  bzflag = callPackage ../games/bzflag { };

  cataclysm-dda = callPackage ../games/cataclysm-dda { };

  chessdb = callPackage ../games/chessdb { };

  chessx = qt5.callPackage ../games/chessx { };

  chocolateDoom = callPackage ../games/chocolate-doom { };

  cockatrice = qt5.callPackage ../games/cockatrice {  };

  confd = goPackages.confd.bin // { outputs = [ "bin" ]; };

  construoBase = lowPrio (callPackage ../games/construo {
    mesa = null;
    freeglut = null;
  });

  construo = self.construoBase.override {
    inherit mesa freeglut;
  };

  crack_attack = callPackage ../games/crack-attack { };

  crafty = callPackage ../games/crafty { };
  craftyFull = appendToName "full" (self.crafty.override { fullVariant = true; });

  crawlTiles = self.crawl.override {
    tileMode = true;
  };

  crawl = callPackage ../games/crawl { };

  crrcsim = callPackage ../games/crrcsim {};

  cuyo = callPackage ../games/cuyo { };

  dhewm3 = callPackage ../games/dhewm3 {};

  drumkv1 = callPackage ../applications/audio/drumkv1 { };

  duckmarines = callPackage ../games/duckmarines { love = love_0_9; };

  dwarf-fortress-packages = recurseIntoAttrs (callPackage ../games/dwarf-fortress { });
  inherit (self.dwarf-fortress-packages)
    dwarf-fortress dwarf-therapist;

  d1x_rebirth = callPackage ../games/d1x-rebirth { };

  d2x_rebirth = callPackage ../games/d2x-rebirth { };

  eboard = callPackage ../games/eboard { };

  eduke32 = callPackage ../games/eduke32 { };

  egoboo = callPackage ../games/egoboo { };

  eternity = callPackage ../games/eternity-engine { };

  extremetuxracer = callPackage ../games/extremetuxracer {
    libpng = libpng12;
  };

  exult = callPackage ../games/exult { };

  factorio = callPackage ../games/factorio {};

  fairymax = callPackage ../games/fairymax {};

  fish-fillets-ng = callPackage ../games/fish-fillets-ng {};

  flightgear = qt5.callPackage ../games/flightgear {
    fltk13 = fltk13.override { cfg.xftSupport = true; };
  };

  freecell-solver = callPackage ../games/freecell-solver { };

  freeciv = callPackage ../games/freeciv { };

  freeciv_gtk = callPackage ../games/freeciv {
    gtkClient = true;
    sdlClient = false;
  };

  freedink = callPackage ../games/freedink { };

  fsg = callPackage ../games/fsg {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  gav = callPackage ../games/gav { };

  gemrb = callPackage ../games/gemrb { };

  ghostOne = callPackage ../servers/games/ghost-one { };

  gl117 = callPackage ../games/gl-117 {};

  glestae = callPackage ../games/glestae {};

  globulation2 = callPackage ../games/globulation {
    boost = boost155;
  };

  gltron = callPackage ../games/gltron { };

  gnubg = callPackage ../games/gnubg { };

  gnuchess = callPackage ../games/gnuchess { };

  gnugo = callPackage ../games/gnugo { };

  gsb = callPackage ../games/gsb { };

  gtypist = callPackage ../games/gtypist { };

  gzdoom = callPackage ../games/gzdoom { };

  hawkthorne = callPackage ../games/hawkthorne { love = love_0_9; };

  hedgewars = callPackage ../games/hedgewars {
    inherit (haskellPackages) ghcWithPackages;
  };

  hexen = callPackage ../games/hexen { };

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

  multimc = callPackage ../games/multimc { };

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

  openlierox = callPackage ../games/openlierox { };

  openmw = callPackage ../games/openmw { };

  openra = callPackage ../games/openra { lua = lua5_1; };

  openspades = callPackage ../games/openspades {};

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

  prboom = callPackage ../games/prboom { };

  privateer = callPackage ../games/privateer { };

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

  # You still can override by passing more arguments.
  spaceOrbit = callPackage ../games/orbit { };

  spring = callPackage ../games/spring {
    boost = boost155;
    cmake = cmake-2_8;
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

  stepmania = callPackage ../games/stepmania { };

  stuntrally = callPackage ../games/stuntrally { };

  superTux = callPackage ../games/super-tux { };

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

  tome4 = callPackage ../games/tome4 { };

  trackballs = callPackage ../games/trackballs {
    debug = false;
    guile = guile_1_8;
  };

  tremulous = callPackage ../games/tremulous { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    plib = plib.override { enablePIC = !stdenv.isi686; };
    libpng = libpng12;
  };

  torcs = callPackage ../games/torcs {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    plib = plib.override { enablePIC = !stdenv.isi686; };
  };

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

  ut2004demo = callPackage ../games/ut2004demo { };

  vapor = callPackage ../games/vapor { love = love_0_8; };

  vassal = callPackage ../games/vassal { };

  vdrift = callPackage ../games/vdrift { };

  vectoroids = callPackage ../games/vectoroids { };

  vessel = callPackage_i686 ../games/vessel { };

  voxelands = callPackage ../games/voxelands {
    libpng = libpng12;
  };

  warmux = callPackage ../games/warmux { };

  warsow = callPackage ../games/warsow {
    libjpeg = libjpeg62;
  };

  warzone2100 = callPackage ../games/warzone2100 { };

  wesnoth = callPackage ../games/wesnoth {
    lua = lua5;
  };

  widelands = callPackage ../games/widelands {
    lua = lua5_1;
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

  xsokoban = callPackage ../games/xsokoban { };

  zandronum = callPackage ../games/zandronum {
    fmod = fmod42416;
    cmake = cmake-2_8;
  };

  zandronum-server = zandronum.override {
    serverOnly = true;
  };

  zandronum-bin = hiPrio (callPackage ../games/zandronum/bin.nix { });

  zangband = callPackage ../games/zangband { };

  zdoom = callPackage ../games/zdoom { };

  zod = callPackage ../games/zod { };

  zoom = callPackage ../games/zoom { };

  keen4 = callPackage ../games/keen4 { };

  zeroad = callPackage ../games/0ad { };

  ### DESKTOP ENVIRONMENTS

  clearlooks-phenix = callPackage ../misc/themes/gtk3/clearlooks-phenix { };

  enlightenment = recurseIntoAttrs (callPackage ../desktops/enlightenment {
    callPackage = newScope pkgs.enlightenment;
  });

  gnome2 = callPackage ../desktops/gnome-2 {
    callPackage = pkgs.newScope pkgs.gnome2;
    self = pkgs.gnome2;
  }  // pkgs.gtkLibs // {
    # Backwards compatibility;
    inherit (pkgs) libsoup libwnck gtk_doc gnome_doc_utils;
  };

  gnome3_18 = recurseIntoAttrs (callPackage ../desktops/gnome-3/3.18 { });

  gnome3 = self.gnome3_18;

  gnome = recurseIntoAttrs self.gnome2;

  hsetroot = callPackage ../tools/X11/hsetroot { };

  kakasi = callPackage ../tools/text/kakasi { };

  kde4 = recurseIntoAttrs self.kde414;

  kde414 =
    kdePackagesFor
      {
        libusb = libusb1;
        libcanberra = libcanberra_kde;
        boost = boost155;
        kdelibs = kde5.kdelibs;
        subversionClient = pkgs.subversion18.override {
          bdbSupport = false;
          perlBindings = true;
          pythonBindings = true;
        };
        ruby = ruby_2_2; # see https://github.com/NixOS/nixpkgs/pull/12610#issuecomment-188666473
      }
      ../desktops/kde-4.14;


  kdePackagesFor = extra: dir:
    let
      # list of extra packages not included in KDE
      # the real work in this function is done below this list
      extraPackages = callPackage:
        rec {
          amarok = callPackage ../applications/audio/amarok { };

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

          k3b = callPackage ../applications/misc/k3b {
            cdrtools = cdrkit;
          };

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

          krename = callPackage ../applications/misc/krename {
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

          psi = callPackage ../applications/networking/instant-messengers/psi { };

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

  pantheon = recurseIntoAttrs rec {
    callPackage = newScope pkgs.pantheon;
    pantheon-terminal = callPackage ../desktops/pantheon/apps/pantheon-terminal { };
  };

  redshift = callPackage ../applications/misc/redshift {
    inherit (python3Packages) python pygobject3 pyxdg;
  };

  orion = callPackage ../misc/themes/orion {};

  albatross = callPackage ../misc/themes/albatross { };

  oxygen-gtk2 = callPackage ../misc/themes/gtk2/oxygen-gtk { };

  oxygen-gtk3 = callPackage ../misc/themes/gtk3/oxygen-gtk3 { };

  oxygen_gtk = oxygen-gtk2; # backwards compatibility

  gtk_engines = callPackage ../misc/themes/gtk2/gtk-engines { };

  gtk-engine-murrine = callPackage ../misc/themes/gtk2/gtk-engine-murrine { };

  gnome_themes_standard = gnome3.gnome_themes_standard;

  mate-icon-theme = callPackage ../misc/themes/mate-icon-theme { };

  mate-themes = callPackage ../misc/themes/mate-themes { };

  numix-gtk-theme = callPackage ../misc/themes/gtk3/numix-gtk-theme { };

  kde5PackagesFun = self: with self; {

    calamares = callPackage ../tools/misc/calamares rec {
      python = python3;
      boost = pkgs.boost.override { python=python3; };
      libyamlcpp = callPackage ../development/libraries/libyaml-cpp { makePIC=true; boost=boost; };
    };

    colord-kde = callPackage ../tools/misc/colord-kde/0.5.nix {};

    dfilemanager = callPackage ../applications/misc/dfilemanager { };

    fcitx-qt5 = callPackage ../tools/inputmethods/fcitx/fcitx-qt5.nix { };

    k9copy = callPackage ../applications/video/k9copy {};

    kdeconnect = callPackage ../applications/misc/kdeconnect { };

    kile = callPackage ../applications/editors/kile/frameworks.nix { };

    konversation = callPackage ../applications/networking/irc/konversation/1.6.nix {
    };

    quassel = callPackage ../applications/networking/irc/quassel/qt-5.nix {
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

    quassel_qt5 = quassel.override {
      withKDE = false;
      tag = "-qt5";
    };

    quasselClient_qt5 = quasselClient.override {
      withKDE = false;
      tag = "-client-qt5";
    };

    quasselDaemon = quassel.override {
      monolithic = false;
      daemon = true;
      tag = "-daemon-qt5";
      withKDE = false;
    };

    sddm = callPackage ../applications/display-managers/sddm {
      themes = [];  # extra themes, etc.
    };

    yakuake = callPackage ../applications/misc/yakuake/3.0.nix {};

  };

  kde5 =
    let
      frameworks = import ../desktops/kde-5/frameworks-5.19 { inherit pkgs; };
      plasma = import ../desktops/kde-5/plasma-5.5 { inherit pkgs; };
      applications = import ../desktops/kde-5/applications-15.12 { inherit pkgs; };
      merged = self:
        { plasma = plasma self;
          frameworks = frameworks self;
          applications = applications self; }
        // frameworks self
        // plasma self
        // applications self
        // kde5PackagesFun self;
    in
      recurseIntoAttrs (lib.makeScope qt55.newScope merged);

  kde5_latest =
    let
      frameworks = import ../desktops/kde-5/frameworks-5.19 { inherit pkgs; };
      plasma = import ../desktops/kde-5/plasma-5.5 { inherit pkgs; };
      applications = import ../desktops/kde-5/applications-15.12 { inherit pkgs; };
      merged = self:
        { plasma = plasma self;
          frameworks = frameworks self;
          applications = applications self; }
        // frameworks self
        // plasma self
        // applications self
        // kde5PackagesFun self;
    in
      recurseIntoAttrs (lib.makeScope qt55.newScope merged);

  theme-vertex = callPackage ../misc/themes/vertex { };

  xfce = xfce4-12;
  xfce4-12 = recurseIntoAttrs (callPackage ../desktops/xfce { });

  xrandr-invert-colors = callPackage ../applications/misc/xrandr-invert-colors { };

  ### SCIENCE

  ### SCIENCE/GEOMETRY

  drgeo = callPackage ../applications/science/geometry/drgeo {
    inherit (gnome) libglade;
    guile = guile_1_8;
  };

  tetgen = callPackage ../applications/science/geometry/tetgen { }; # AGPL3+
  tetgen_1_4 = callPackage ../applications/science/geometry/tetgen/1.4.nix { }; # MIT

  ### SCIENCE/BIOLOGY

  alliance = callPackage ../applications/science/electronics/alliance {
    motif = lesstif;
  };

  archimedes = callPackage ../applications/science/electronics/archimedes {
    stdenv = overrideCC stdenv gcc49;
  };

  emboss = callPackage ../applications/science/biology/emboss { };

  neuron = callPackage ../applications/science/biology/neuron { };

  neuron-mpi = appendToName "mpi" (neuron.override {
    mpi = pkgs.openmpi;
  });

  mrbayes = callPackage ../applications/science/biology/mrbayes { };

  minc_tools = callPackage ../applications/science/biology/minc-tools { };

  ncbi_tools = callPackage ../applications/science/biology/ncbi-tools { };

  paml = callPackage ../applications/science/biology/paml { };

  pal2nal = callPackage ../applications/science/biology/pal2nal { };

  plink = callPackage ../applications/science/biology/plink/default.nix { };


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

  atlasWithLapack = self.atlas.override { withLapack = true; };

  blas = callPackage ../development/libraries/science/math/blas { };

  jags = callPackage ../applications/science/math/jags { };


  # We have essentially 4 permutations of liblapack: version 3.4.1 or 3.5.0,
  # and with or without atlas as a dependency. The default `liblapack` is 3.4.1
  # with atlas. Atlas, when built with liblapack as a dependency, uses 3.5.0
  # without atlas. Etc.
  liblapackWithAtlas = callPackage ../development/libraries/science/math/liblapack {};
  liblapackWithoutAtlas = self.liblapackWithAtlas.override { atlas = null; };
  liblapack_3_5_0WithAtlas = callPackage ../development/libraries/science/math/liblapack/3.5.0.nix {};
  liblapack_3_5_0WithoutAtlas = self.liblapack_3_5_0WithAtlas.override { atlas = null; };
  liblapack = self.liblapackWithAtlas;
  liblapack_3_5_0 = self.liblapack_3_5_0WithAtlas;

  liblbfgs = callPackage ../development/libraries/science/math/liblbfgs { };

  openblas = callPackage ../development/libraries/science/math/openblas { };

  # A version of OpenBLAS using 32-bit integers on all platforms for compatibility with
  # standard BLAS and LAPACK.
  openblasCompat = openblas.override { blas64 = false; };

  openlibm = callPackage ../development/libraries/science/math/openlibm {};

  openspecfun = callPackage ../development/libraries/science/math/openspecfun {};

  mathematica = callPackage ../applications/science/math/mathematica { };
  mathematica9 = callPackage ../applications/science/math/mathematica/9.nix { };

  metis = callPackage ../development/libraries/science/math/metis {};

  sage = callPackage ../applications/science/math/sage { };

  suitesparse_4_2 = callPackage ../development/libraries/science/math/suitesparse/4.2.nix { };
  suitesparse_4_4 = callPackage ../development/libraries/science/math/suitesparse {};
  suitesparse = suitesparse_4_4;

  ipopt = callPackage ../development/libraries/science/math/ipopt { openblas = openblasCompat; };

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

  ### SCIENCE/PROGRAMMING

  plm = callPackage ../applications/science/programming/plm { };

  ### SCIENCE/LOGIC

  abc-verifier = callPackage ../applications/science/logic/abc {};

  abella = callPackage ../applications/science/logic/abella {};

  alt-ergo = callPackage ../applications/science/logic/alt-ergo {};

  coq = callPackage ../applications/science/logic/coq {
    inherit (ocamlPackages_4_01_0) ocaml findlib lablgtk;
    camlp5 = ocamlPackages_4_01_0.camlp5_transitional;
  };

  coq_HEAD = callPackage ../applications/science/logic/coq/HEAD.nix {
    inherit (ocamlPackages) findlib lablgtk;
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  coq_8_5 = callPackage ../applications/science/logic/coq/8.5.nix {
    inherit (ocamlPackages) findlib lablgtk;
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  coq_8_3 = callPackage ../applications/science/logic/coq/8.3.nix {
    make = gnumake3;
    inherit (ocamlPackages_3_12_1) ocaml findlib;
    camlp5 = ocamlPackages_3_12_1.camlp5_transitional;
    lablgtk = ocamlPackages_3_12_1.lablgtk_2_14;
  };

  mkCoqPackages_8_4 = self: let callPackage = newScope self; in {

    inherit callPackage;

    bedrock = callPackage ../development/coq-modules/bedrock {};

    contribs =
      let contribs =
        import ../development/coq-modules/contribs
        contribs
        callPackage { };
      in
        recurseIntoAttrs contribs;

    coqExtLib = callPackage ../development/coq-modules/coq-ext-lib {};

    coqeal = callPackage ../development/coq-modules/coqeal {};

    coquelicot = callPackage ../development/coq-modules/coquelicot {};

    domains = callPackage ../development/coq-modules/domains {};

    fiat = callPackage ../development/coq-modules/fiat {};

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

    coq-ext-lib = callPackage ../development/coq-modules/coq-ext-lib {};

    coquelicot = callPackage ../development/coq-modules/coquelicot {};

    flocq = callPackage ../development/coq-modules/flocq {};

    interval = callPackage ../development/coq-modules/interval {};

    mathcomp = callPackage ../development/coq-modules/mathcomp { };

    ssreflect = callPackage ../development/coq-modules/ssreflect { };

  };

  coqPackages = mkCoqPackages_8_4 coqPackages;
  coqPackages_8_5 = mkCoqPackages_8_5 coqPackages_8_5;

  cvc3 = callPackage ../applications/science/logic/cvc3 {
    gmp = lib.overrideDerivation gmp (a: { dontDisableStatic = true; });
  };
  cvc4 = callPackage ../applications/science/logic/cvc4 {};

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {};

  eprover = callPackage ../applications/science/logic/eprover { };

  gappa = callPackage ../applications/science/logic/gappa { };

  ginac = callPackage ../applications/science/math/ginac { };

  hol = callPackage ../applications/science/logic/hol { };

  hol_light = callPackage ../applications/science/logic/hol_light {
    camlp5 = ocamlPackages.camlp5_strict;
  };

  hologram = goPackages.hologram.bin // { outputs = [ "bin" ]; };

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

  leo2 = callPackage ../applications/science/logic/leo2 {};

  logisim = callPackage ../applications/science/logic/logisim {};

  ltl2ba = callPackage ../applications/science/logic/ltl2ba {};

  matita = callPackage ../applications/science/logic/matita {
    ocaml = ocaml_3_11_2;
    inherit (ocamlPackages_3_11_2) findlib lablgtk ocaml_expat gmetadom ocaml_http
            lablgtkmathview ocaml_mysql ocaml_sqlite3 ocamlnet camlzip ocaml_pcre;
    ulex08 = ocamlPackages_3_11_2.ulex08.override { camlp5 = ocamlPackages_3_11_2.camlp5_old_transitional; };
  };

  matita_130312 = lowPrio (callPackage ../applications/science/logic/matita/130312.nix {
    inherit (ocamlPackages) findlib lablgtk ocaml_expat gmetadom ocaml_http
            ocaml_mysql ocamlnet ulex08 camlzip ocaml_pcre;
  });

  metis-prover = callPackage ../applications/science/logic/metis-prover { };

  minisat = callPackage ../applications/science/logic/minisat {};

  opensmt = callPackage ../applications/science/logic/opensmt { };

  ott = callPackage ../applications/science/logic/ott {
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  otter = callPackage ../applications/science/logic/otter {};

  picosat = callPackage ../applications/science/logic/picosat {};

  prooftree = callPackage ../applications/science/logic/prooftree {
    inherit (ocamlPackages_4_01_0) ocaml findlib lablgtk;
    camlp5 = ocamlPackages_4_01_0.camlp5_transitional;
  };

  prover9 = callPackage ../applications/science/logic/prover9 { };

  satallax = callPackage ../applications/science/logic/satallax {};

  saw-tools = callPackage ../applications/science/logic/saw-tools {};

  spass = callPackage ../applications/science/logic/spass {};

  tptp = callPackage ../applications/science/logic/tptp {};

  twelf = callPackage ../applications/science/logic/twelf {
    smlnj = if stdenv.isDarwin
      then smlnjBootstrap
      else smlnj;
  };

  verifast = callPackage ../applications/science/logic/verifast {};

  veriT = callPackage ../applications/science/logic/verit {};

  why3 = callPackage ../applications/science/logic/why3 {};

  yices = callPackage ../applications/science/logic/yices {};

  z3 = callPackage ../applications/science/logic/z3 {};
  z3_opt = callPackage ../applications/science/logic/z3_opt {};

  boolector   = self.boolector15;
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

  maxima = callPackage ../applications/science/math/maxima { };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { wxGTK = wxGTK30; };

  pari = callPackage ../applications/science/math/pari {};

  calc = callPackage ../applications/science/math/calc { };

  pcalc = callPackage ../applications/science/math/pcalc { };

  pspp = callPackage ../applications/science/math/pssp {
    inherit (gnome) libglade gtksourceview;
  };

  singular = callPackage ../applications/science/math/singular {};

  scilab = callPackage ../applications/science/math/scilab {
    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  scotch = callPackage ../applications/science/math/scotch { };

  msieve = callPackage ../applications/science/math/msieve { };

  weka = callPackage ../applications/science/math/weka { };

  yad = callPackage ../tools/misc/yad { };

  yacas = callPackage ../applications/science/math/yacas { };

  speedcrunch = callPackage ../applications/science/math/speedcrunch {
    qt = qt4;
    cmake = cmakeCurses;
  };


  ### SCIENCE / MISC

  boinc = callPackage ../applications/science/misc/boinc { };

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (pkgs.gnome) gtkglext;
  };

  fityk = callPackage ../applications/science/misc/fityk { };

  gravit = callPackage ../applications/science/astronomy/gravit { };

  golly = callPackage ../applications/science/misc/golly { };

  megam = callPackage ../applications/science/misc/megam { };

  root = callPackage ../applications/science/misc/root { };

  simgrid = callPackage ../applications/science/misc/simgrid { };

  spyder = pythonPackages.spyder;

  stellarium = qt5.callPackage ../applications/science/astronomy/stellarium { };

  tulip = callPackage ../applications/science/misc/tulip {
    cmake = cmake-2_8;
  };

  vite = callPackage ../applications/science/misc/vite { };

  xplanet = callPackage ../applications/science/astronomy/xplanet { };

  ### SCIENCE / PHYSICS

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

  ### MISC

  antimicro = qt5.callPackage ../tools/misc/antimicro { };

  atari800 = callPackage ../misc/emulators/atari800 { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  auctex = callPackage ../tools/typesetting/tex/auctex { };

  beep = callPackage ../misc/beep { };

  brgenml1lpr = callPackage ../misc/cups/drivers/brgenml1lpr {};

  brgenml1cupswrapper = callPackage ../misc/cups/drivers/brgenml1cupswrapper {};

  cups = callPackage ../misc/cups {
    libusb = libusb1;
  };

  cups_filters = callPackage ../misc/cups/filters.nix { };

  cups-pk-helper = callPackage ../misc/cups/cups-pk-helper.nix { };

  crashplan = callPackage ../applications/backup/crashplan { };

  epson-escpr = callPackage ../misc/drivers/epson-escpr { };

  epson_201207w = callPackage ../misc/drivers/epson_201207w { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cups-bjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

  darcnes = callPackage ../misc/emulators/darcnes { };

  darling-dmg = callPackage ../tools/filesystems/darling-dmg { };

  desmume = callPackage ../misc/emulators/desmume { inherit (pkgs.gnome) gtkglext libglade; };

  dbacl = callPackage ../tools/misc/dbacl { };

  dblatex = callPackage ../tools/typesetting/tex/dblatex {
    enableAllFeatures = false;
  };

  dblatexFull = appendToName "full" (self.dblatex.override {
    enableAllFeatures = true;
  });

  dosbox = callPackage ../misc/emulators/dosbox { };

  dpkg = callPackage ../tools/package-management/dpkg { };

  ekiga = newScope pkgs.gnome ../applications/networking/instant-messengers/ekiga { };

  emulationstation = callPackage ../misc/emulators/emulationstation { };

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  fakenes = callPackage ../misc/emulators/fakenes { };

  faust = self.faust2;

  faust1 = callPackage ../applications/audio/faust/faust1.nix { };

  faust2 = callPackage ../applications/audio/faust/faust2.nix {
    llvm = llvm_37;
  };

  faust2alqt = callPackage ../applications/audio/faust/faust2alqt.nix { };

  faust2alsa = callPackage ../applications/audio/faust/faust2alsa.nix { };

  faust2csound = callPackage ../applications/audio/faust/faust2csound.nix { };

  faust2firefox = callPackage ../applications/audio/faust/faust2firefox.nix { };

  faust2jack = callPackage ../applications/audio/faust/faust2jack.nix { };

  faust2jaqt = callPackage ../applications/audio/faust/faust2jaqt.nix { };

  faust2lv2 = callPackage ../applications/audio/faust/faust2lv2.nix { };

  fceux = callPackage ../misc/emulators/fceux { };

  foldingathome = callPackage ../misc/foldingathome { };

  foo2zjs = callPackage ../misc/drivers/foo2zjs {};

  foomatic_filters = callPackage ../misc/drivers/foomatic-filters {};

  freestyle = callPackage ../misc/freestyle { };

  gajim = callPackage ../applications/networking/instant-messengers/gajim { };

  gale = callPackage ../applications/networking/instant-messengers/gale { };

  gammu = callPackage ../applications/misc/gammu { };

  gensgs = callPackage_i686 ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript {
    x11Support = false;
    cupsSupport = config.ghostscript.cups or (!stdenv.isDarwin);
  };

  ghostscriptX = appendToName "with-X" (self.ghostscript.override {
    x11Support = true;
  });

  gnuk = callPackage ../misc/gnuk { };
  gnuk-unstable = callPackage ../misc/gnuk/unstable.nix { };
  gnuk-git = callPackage ../misc/gnuk/git.nix { };

  gxemul = callPackage ../misc/emulators/gxemul { };

  hatari = callPackage ../misc/emulators/hatari { };

  helm = callPackage ../applications/audio/helm { };

  hplip = callPackage ../misc/drivers/hplip { };

  hplipWithPlugin = self.hplip.override { withPlugin = true; };

  hplip_3_15_9 = callPackage ../misc/drivers/hplip/3.15.9.nix { };

  hplipWithPlugin_3_15_9 = self.hplip_3_15_9.override { withPlugin = true; };

  # using the new configuration style proposal which is unstable
  jack1 = callPackage ../misc/jackaudio/jack1.nix { };

  jack2Full = callPackage ../misc/jackaudio {
    libopus = libopus.override { withCustomModes = true; };
  };
  libjack2 = self.jack2Full.override { prefix = "lib"; };
  libjack2-git = callPackage ../misc/jackaudio/git.nix { };

  keynav = callPackage ../tools/X11/keynav { };

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };

  mailcore2 = callPackage ../development/libraries/mailcore2 { };

  martyr = callPackage ../development/libraries/martyr { };

  mess = callPackage ../misc/emulators/mess {
    inherit (pkgs.gnome) GConf;
  };

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

  nixopsUnstable = nixops;# callPackage ../tools/package-management/nixops/unstable.nix { };

  nixui = callPackage ../tools/package-management/nixui { node_webkit = nwjs_0_12; };

  inherit (callPackages ../tools/package-management/nix-prefetch-scripts { })
    nix-prefetch-bzr
    nix-prefetch-cvs
    nix-prefetch-git
    nix-prefetch-hg
    nix-prefetch-svn
    nix-prefetch-zip
    nix-prefetch-scripts;

  nix-template-rpm = callPackage ../build-support/templaterpm { inherit (pythonPackages) python toposort; };

  nix-repl = callPackage ../tools/package-management/nix-repl { };

  nix-serve = callPackage ../tools/package-management/nix-serve { };

  nixos-artwork = callPackage ../data/misc/nixos-artwork { };

  nut = callPackage ../applications/misc/nut { };

  solfege = callPackage ../misc/solfege {
      pysqlite = pkgs.pythonPackages.sqlite3;
  };

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

  m3d-linux = callPackage ../misc/drivers/m3d-linux { };

  mysqlWorkbench = newScope gnome ../applications/misc/mysql-workbench {
    lua = lua5_1;
    libctemplate = libctemplate_2_2;
    inherit (pythonPackages) pexpect paramiko;
  };

  robomongo = qt5.callPackage ../applications/misc/robomongo { };

  rucksack = callPackage ../development/tools/rucksack { };

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

  uae = callPackage ../misc/emulators/uae { };

  fsuae = callPackage ../misc/emulators/fs-uae { };

  putty = callPackage ../applications/networking/remote/putty { };

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

  xlockmore = callPackage ../misc/screensavers/xlockmore { };

  xtrlock-pam = callPackage ../misc/screensavers/xtrlock-pam { };

  sails = callPackage ../misc/sails { };

  canon-cups-ufr2 = callPackage ../misc/cups/drivers/canon { };

  mfcj470dw = callPackage_i686 ../misc/cups/drivers/mfcj470dw { };

  samsung-unified-linux-driver_1_00_37 = callPackage ../misc/cups/drivers/samsung { };
  samsung-unified-linux-driver = callPackage ../misc/cups/drivers/samsung/4.00.39 { };

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

  sct = callPackage ../tools/X11/sct {};

  seafile-shared = callPackage ../misc/seafile-shared { };

  slock = callPackage ../misc/screensavers/slock { };

  snapraid = callPackage ../tools/filesystems/snapraid { };

  soundOfSorting = callPackage ../misc/sound-of-sorting { };

  sourceAndTags = callPackage ../misc/source-and-tags {
    hasktags = haskellPackages.hasktags;
  };

  splix = callPackage ../misc/cups/drivers/splix { };

  streamripper = callPackage ../applications/audio/streamripper { };

  sqsh = callPackage ../development/tools/sqsh { };

  terraform = go16Packages.terraform.bin // { outputs = [ "bin" ]; };

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  tewi-font = callPackage ../data/fonts/tewi  {};

  tex4ht = callPackage ../tools/typesetting/tex/tex4ht { };

  texFunctions = callPackage ../tools/typesetting/tex/nix pkgs;

  # All the new TeX Live is inside. See description in default.nix.
  texlive = recurseIntoAttrs
    (callPackage ../tools/typesetting/tex/texlive-new { });

  texLive = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive) {
    ghostscript = ghostscriptX;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  };

  texLiveFull = lib.setName "texlive-full" (texLiveAggregationFun {
    paths = [ texLive texLiveExtra lmodern texLiveCMSuper texLiveLatexXColor
              texLivePGF texLiveBeamer texLiveModerncv tipa tex4ht texinfo
              texLiveModerntimeline texLiveContext ];
  });

  /* Look in configurations/misc/raskin.nix for usage example (around revisions
  where TeXLive was added)

  (texLiveAggregationFun {
    paths = [texLive texLiveExtra texLiveCMSuper
      texLiveBeamer
    ];
  })

  You need to use texLiveAggregationFun to regenerate, say, ls-R (TeX-related file list)
  Just installing a few packages doesn't work.
  */
  texLiveAggregationFun = params:
    builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/aggregate.nix) params;

  texLiveContext = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/context.nix) {};

  texLiveExtra = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/extra.nix) {};

  texLiveCMSuper = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/cm-super.nix) {};

  texLiveLatexXColor = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/xcolor.nix) {};

  texLivePGF = pgf3;

  texLiveBeamer = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/beamer.nix) {};

  texLiveModerncv = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/moderncv.nix) {};

  texLiveModerntimeline = builderDefsPackage (callPackage ../tools/typesetting/tex/texlive/moderntimeline.nix) {};

  ib-tws = callPackage ../applications/office/ib/tws { jdk=oraclejdk8; };

  ib-controller = callPackage ../applications/office/ib/controller { jdk=oraclejdk8; };

  thermald = callPackage ../tools/system/thermald { };

  thinkfan = callPackage ../tools/system/thinkfan { };

  tup = callPackage ../development/tools/build-managers/tup { };

  tvheadend = callPackage ../servers/tvheadend { };

  ums = callPackage ../servers/ums { };

  urbit = callPackage ../misc/urbit { };

  utf8proc = callPackage ../development/libraries/utf8proc { };

  vault = goPackages.vault.bin // { outputs = [ "bin" ]; };

  vbam = callPackage ../misc/emulators/vbam {};

  vice = callPackage ../misc/emulators/vice {
    libX11 = xorg.libX11;
    giflib = giflib_4_1;
  };

  viewnior = callPackage ../applications/graphics/viewnior { };

  vimUtils = callPackage ../misc/vim-plugins/vim-utils.nix { };

  vimPlugins = recurseIntoAttrs (callPackage ../misc/vim-plugins {
    inherit (darwin.apple_sdk.frameworks) Cocoa;
  });

  vimprobable2-unwrapped = callPackage ../applications/networking/browsers/vimprobable2 {
    webkit = webkitgtk2;
  };
  vimprobable2 = wrapFirefox vimprobable2-unwrapped { };

  inherit (self.kde4) rekonq;

  vimb-unwrapped = callPackage ../applications/networking/browsers/vimb {
    webkit = webkitgtk2;
  };
  vimb = wrapFirefox vimb-unwrapped { };

  vips = callPackage ../tools/graphics/vips { };
  nip2 = callPackage ../tools/graphics/nip2 { };

  wavegain = callPackage ../applications/audio/wavegain { };

  wcalc = callPackage ../applications/misc/wcalc { };

  webfs = callPackage ../servers/http/webfs { };

  wine = callPackage ../misc/emulators/wine {
    wineRelease = config.wine.release or "stable";
    wineBuild = config.wine.build or "wine32";
    pulseaudioSupport = config.pulseaudio or stdenv.isLinux;
  };
  wineStable = wine.override { wineRelease = "stable"; };
  wineUnstable = lowPrio (wine.override { wineRelease = "unstable"; });
  wineStaging = lowPrio (wine.override { wineRelease = "staging"; });

  winetricks = callPackage ../misc/emulators/wine/winetricks.nix {
    inherit (gnome2) zenity;
  };

  wmutils-core = callPackage ../tools/X11/wmutils-core { };

  wraith = callPackage ../applications/networking/irc/wraith { };

  wxmupen64plus = callPackage ../misc/emulators/wxmupen64plus { };

  x2x = callPackage ../tools/X11/x2x { };

  xboxdrv = callPackage ../misc/drivers/xboxdrv { };

  xcftools = callPackage ../tools/graphics/xcftools { };

  xhyve = callPackage ../applications/virtualization/xhyve { };

  xinput_calibrator = callPackage ../tools/X11/xinput_calibrator {};

  xosd = callPackage ../misc/xosd { };

  xsane = callPackage ../applications/graphics/sane/xsane.nix {
    libpng = libpng12;
  };

  xwiimote = callPackage ../misc/drivers/xwiimote {
    bluez = pkgs.bluez5.override {
      enableWiimote = true;
    };
  };

  yabause = callPackage ../misc/emulators/yabause {
    qt = qt4;
  };

  yafc = callPackage ../applications/networking/yafc { };

  yamdi = callPackage ../tools/video/yamdi { };

  yandex-disk = callPackage ../tools/filesystems/yandex-disk { };

  yara = callPackage ../tools/security/yara { };

  zap = callPackage ../tools/networking/zap { };

  zdfmediathk = callPackage ../applications/video/zdfmediathk { };

  zopfli = callPackage ../tools/compression/zopfli { };

  myEnvFun = callPackage ../misc/my-env {
    inherit (stdenv) mkDerivation;
  };

  # patoline requires a rather large ocaml compilation environment.
  # this is why it is build as an environment and not just a normal package.
  # remark : the emacs mode is also installed, but you have to adjust your load-path.
  PatolineEnv = pack: myEnvFun {
      name = "patoline";
      buildInputs = [ stdenv ncurses mesa freeglut libzip gcc
                                   pack.ocaml pack.findlib pack.camomile
                                   pack.dypgen pack.ocaml_sqlite3 pack.camlzip
                                   pack.lablgtk pack.camlimages pack.ocaml_cairo
                                   pack.lablgl pack.ocamlnet pack.cryptokit
                                   pack.ocaml_pcre pack.patoline
                                   ];
    # this is to circumvent the bug with libgcc_s.so.1 which is
    # not found when using thread
    extraCmds = ''
       LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${gcc.cc}/lib
       export LD_LIBRARY_PATH
    '';
  };

  patoline = PatolineEnv ocamlPackages_4_00_1;

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  zsnes = callPackage_i686 ../misc/emulators/zsnes { };

  snes9x-gtk = callPackage ../misc/emulators/snes9x-gtk { };

  higan = callPackage ../misc/emulators/higan {
    inherit (gnome) gtksourceview;
    profile = config.higan.profile or "balanced";
  };

  misc = callPackage ../misc/misc.nix { };

  bullet = callPackage ../development/libraries/bullet {};

  dart = callPackage ../development/interpreters/dart { };

  httrack = callPackage ../tools/backup/httrack { };

  mg = callPackage ../applications/editors/mg { };

  togglesg-download = callPackage ../tools/misc/togglesg-download { };

  discord = callPackage ../applications/networking/instant-messengers/discord { };
}
