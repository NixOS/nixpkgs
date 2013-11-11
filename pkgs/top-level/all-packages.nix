/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */


{ # The system (e.g., `i686-linux') for which to build the packages.
  system ? builtins.currentSystem

  # Usually, the system type uniquely determines the stdenv and thus
  # how to build the packages.  But on some platforms we have
  # different stdenvs, leading to different ways to build the
  # packages.  For instance, on Windows we support both Cygwin and
  # Mingw builds.  In both cases, `system' is `i686-cygwin'.  The
  # attribute `stdenvType' is used to select the specific kind of
  # stdenv to use, e.g., `i686-mingw'.
, stdenvType ? system

, # The standard environment to use.  Only used for bootstrapping.  If
  # null, the default standard environment is used.
  bootStdenv ? null

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for
  # files in standard system directories (/usr/include, etc.)
  noSysDirs ? (system != "x86_64-darwin"
               && system != "x86_64-freebsd" && system != "i686-freebsd"
               && system != "x86_64-kfreebsd-gnu")

  # More flags for the bootstrapping of stdenv.
, gccWithCC ? true
, gccWithProfiling ? true

, # Allow a configuration attribute set to be passed in as an
  # argument.  Otherwise, it's read from $NIXPKGS_CONFIG or
  # ~/.nixpkgs/config.nix.
  config ? null

, crossSystem ? null
, platform ? null
}:


let config_ = config; platform_ = platform; in # rename the function arguments

let

  lib = import ../../lib;

  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  # for NIXOS (nixos-rebuild): use nixpkgs.config option
  config =
    let
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      configExpr =
        if config_ != null then config_
        else if configFile != "" && pathExists configFile then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2 then import (toPath configFile2)
        else {};

    in
      # allow both:
      # { /* the config */ } and
      # { pkgs, ... } : { /* the config */ }
      if builtins.isFunction configExpr
        then configExpr { inherit pkgs; }
        else configExpr;

  # Allow setting the platform in the config file. Otherwise, let's use a reasonable default (pc)

  platformAuto = let
      platforms = (import ./platforms.nix);
    in
      if system == "armv6l-linux" then platforms.raspberrypi
      else if system == "armv5tel-linux" then platforms.sheevaplug
      else if system == "mips64el-linux" then platforms.fuloong2f_n32
      else platforms.pc;

  platform = if platform_ != null then platform_
    else config.platform or platformAuto;

  # Helper functions that are exported through `pkgs'.
  helperFunctions =
    stdenvAdapters //
    (import ../build-support/trivial-builders.nix { inherit (pkgs) stdenv; inherit (pkgs.xorg) lndir; });

  stdenvAdapters =
    import ../stdenv/adapters.nix { inherit (pkgs) dietlibc fetchurl runCommand; };


  # Allow packages to be overriden globally via the `packageOverrides'
  # configuration option, which must be a function that takes `pkgs'
  # as an argument and returns a set of new or overriden packages.
  # The `packageOverrides' function is called with the *original*
  # (un-overriden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  pkgs = applyGlobalOverrides (config.packageOverrides or (pkgs: {}));


  # Return the complete set of packages, after applying the overrides
  # returned by the `overrider' function (see above).  Warning: this
  # function is very expensive!
  applyGlobalOverrides = overrider:
    let
      # Call the overrider function.  We don't want stdenv overrides
      # in the case of cross-building, or otherwise the basic
      # overrided packages will not be built with the crossStdenv
      # adapter.
      overrides = overrider pkgsOrig //
        (lib.optionalAttrs (pkgsOrig.stdenv ? overrides && crossSystem == null) (pkgsOrig.stdenv.overrides pkgsOrig));

      # The un-overriden packages, passed to `overrider'.
      pkgsOrig = pkgsFun pkgs {};

      # The overriden, final packages.
      pkgs = pkgsFun pkgs overrides;
    in pkgs;


  # The package compositions.  Yes, this isn't properly indented.
  pkgsFun = pkgs: __overrides:
    with helperFunctions;
    let defaultScope = pkgs // pkgs.xorg; in
    helperFunctions // rec {

  # `__overrides' is a magic attribute that causes the attributes in
  # its value to be added to the surrounding `rec'.  We'll remove this
  # eventually.
  inherit __overrides pkgs;

  # Make some arguments passed to all-packages.nix available
  inherit system stdenvType platform;


  # We use `callPackage' to be able to omit function arguments that
  # can be obtained from `pkgs' or `pkgs.xorg' (i.e. `defaultScope').
  # Use `newScope' for sets of packages in `pkgs' (see e.g. `gnome'
  # below).
  callPackage = newScope {};

  newScope = extra: lib.callPackageWith (defaultScope // extra);


  # Override system. This is useful to build i686 packages on x86_64-linux.
  forceSystem = system: (import ./all-packages.nix) {
    inherit system;
    inherit bootStdenv noSysDirs gccWithCC gccWithProfiling config
      crossSystem platform;
  };


  # Used by wine, firefox with debugging version of Flash, ...
  pkgsi686Linux = forceSystem "i686-linux";

  callPackage_i686 = lib.callPackageWith (pkgsi686Linux // pkgsi686Linux.xorg);


  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Symbolic names.

  x11 = if stdenv.isDarwin then darwinX11AndOpenGL else xlibsWrapper;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X llibraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = xorg // {xlibs = xlibsWrapper;};


  ### Helper functions.

  inherit lib config stdenvAdapters;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;
  inherit (misc) versionedDerivation;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  builderDefs = lib.composedArgsAndFun (import ../build-support/builder-defs/builder-defs.nix) {
    inherit stringsWithDeps lib stdenv writeScript
      fetchurl fetchmtn fetchgit;
  };

  builderDefsPackage = builderDefs.builderDefsPackage builderDefs;

  stringsWithDeps = lib.stringsWithDeps;


  ### Nixpkgs maintainer tools

  nix-generate-from-cpan = callPackage ../../maintainers/scripts/nix-generate-from-cpan.nix { };

  nixpkgs-lint = callPackage ../../maintainers/scripts/nixpkgs-lint.nix { };


  ### STANDARD ENVIRONMENT


  allStdenvs = import ../stdenv {
    inherit system stdenvType platform config;
    allPackages = args: import ./all-packages.nix ({ inherit config system; } // args);
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenvCross = lowPrio (makeStdenvCross defaultStdenv crossSystem binutilsCross gccCrossStageFinal);

  stdenv =
    if bootStdenv != null then (bootStdenv // {inherit platform;}) else
      if crossSystem != null then
        stdenvCross
      else
        let
            changer = config.replaceStdenv or null;
        in if changer != null then
          changer {
            # We import again all-packages to avoid recursivities.
            pkgs = import ./all-packages.nix {
              # We remove packageOverrides to avoid recursivities
              config = removeAttrs config [ "replaceStdenv" ];
            };
          }
      else
        defaultStdenv;

  forceNativeDrv = drv : if crossSystem == null then drv else
    (drv // { crossDrv = drv.nativeDrv; });

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (
    if system == "x86_64-linux" then
      overrideGCC stdenv gcc46_multi
    else
      stdenv);


  ### BUILD SUPPORT

  attrSetToDir = arg: import ../build-support/upstream-updater/attrset-to-dir.nix {
    inherit writeTextFile stdenv lib;
    theAttrSet = arg;
  };

  autoreconfHook = makeSetupHook
    { substitutions = { inherit autoconf automake libtool; }; }
    ../build-support/setup-hooks/autoreconf.sh;

  buildEnv = import ../build-support/buildenv {
    inherit (pkgs) runCommand perl;
  };

  buildFHSChrootEnv = import ../build-support/build-fhs-chrootenv {
    inherit stdenv glibc glibcLocales gcc coreutils diffutils findutils;
    inherit gnused gnugrep gnutar gzip bzip2 bashInteractive xz shadow gawk;
    inherit less buildEnv;
  };

  dotnetenv = import ../build-support/dotnetenv {
    inherit stdenv;
    dotnetfx = dotnetfx40;
  };

  vsenv = callPackage ../build-support/vsenv {
    vs = vs90wrapper;
  };

  fetchbzr = import ../build-support/fetchbzr {
    inherit stdenv bazaar;
  };

  fetchcvs = import ../build-support/fetchcvs {
    inherit stdenv cvs;
  };

  fetchdarcs = import ../build-support/fetchdarcs {
    inherit stdenv darcs nix;
  };

  fetchgit = import ../build-support/fetchgit {
    inherit stdenv git cacert;
  };

  fetchgitrevision = import ../build-support/fetchgitrevision runCommand git;

  fetchmtn = callPackage ../build-support/fetchmtn (config.fetchmtn or {});

  fetchsvn = import ../build-support/fetchsvn {
    inherit stdenv subversion openssh;
    sshSupport = true;
  };

  fetchsvnrevision = import ../build-support/fetchsvnrevision runCommand subversion;

  fetchsvnssh = import ../build-support/fetchsvnssh {
    inherit stdenv subversion openssh expect;
    sshSupport = true;
  };

  fetchhg = import ../build-support/fetchhg {
    inherit stdenv mercurial nix;
  };

  # `fetchurl' downloads a file from the network.
  fetchurl = import ../build-support/fetchurl {
    inherit curl stdenv;
  };

  # A wrapper around fetchurl that generates miror://gnome URLs automatically
  fetchurl_gnome = callPackage ../build-support/fetchurl/gnome.nix { };

  # fetchurlBoot is used for curl and its dependencies in order to
  # prevent a cyclic dependency (curl depends on curl.tar.bz2,
  # curl.tar.bz2 depends on fetchurl, fetchurl depends on curl).  It
  # uses the curl from the previous bootstrap phase (e.g. a statically
  # linked curl in the case of stdenv-linux).
  fetchurlBoot = stdenv.fetchurlBoot;

  resolveMirrorURLs = {url}: fetchurl {
    showURLs = true;
    inherit url;
  };

  makeDesktopItem = import ../build-support/make-desktopitem {
    inherit stdenv;
  };

  makeAutostartItem = import ../build-support/make-startupitem {
    inherit stdenv;
    inherit lib;
  };

  makeInitrd = {contents, compressor ? "gzip -9"}:
    import ../build-support/kernel/make-initrd.nix {
      inherit stdenv perl cpio contents ubootChooser compressor;
    };

  makeWrapper = makeSetupHook { } ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = { kernel, rootModules, allowMissing ? false }:
    import ../build-support/kernel/modules-closure.nix {
      inherit stdenv kmod kernel nukeReferences rootModules allowMissing;
    };

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  srcOnly = args: (import ../build-support/src-only) ({inherit stdenv; } // args);

  substituteAll = import ../build-support/substitute/substitute-all.nix {
    inherit stdenv;
  };

  replaceDependency = import ../build-support/replace-dependency.nix {
    inherit runCommand nix lib;
  };

  nukeReferences = callPackage ../build-support/nuke-references/default.nix { };

  vmTools = import ../build-support/vm/default.nix {
    inherit pkgs;
  };

  releaseTools = import ../build-support/release/default.nix {
    inherit pkgs;
  };

  composableDerivation = (import ../../lib/composable-derivation.nix) {
    inherit pkgs lib;
  };

  platforms = import ./platforms.nix;


  ### TOOLS

  acct = callPackage ../tools/system/acct { };

  acoustidFingerprinter = callPackage
    ../tools/audio/acoustid-fingerprinter { };

  actdiag = pythonPackages.actdiag;

  aefs = callPackage ../tools/filesystems/aefs { };

  aespipe = callPackage ../tools/security/aespipe { };

  aescrypt = callPackage ../tools/misc/aescrypt { };

  ahcpd = callPackage ../tools/networking/ahcpd { };

  aircrackng = callPackage ../tools/networking/aircrack-ng { };

  analog = callPackage ../tools/admin/analog {};

  archivemount = callPackage ../tools/filesystems/archivemount { };

  arandr = callPackage ../tools/X11/arandr { };

  arduino_core = callPackage ../development/arduino/arduino-core {
    jdk = jdk;
    jre = jdk;
  };

  argyllcms = callPackage ../tools/graphics/argyllcms {};

  ascii = callPackage ../tools/text/ascii { };

  asymptote = builderDefsPackage ../tools/graphics/asymptote {
    inherit freeglut ghostscriptX imagemagick fftw boehmgc
      mesa ncurses readline gsl libsigsegv python zlib perl
      texinfo lzma;
    texLive = texLiveAggregationFun {
      paths = [ texLive texLiveExtra ];
    };
  };

  awscli = callPackage ../tools/admin/awscli { };

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

  androidenv = import ../development/mobile/androidenv {
    inherit pkgs;
    pkgs_i686 = pkgsi686Linux;
  };

  apg = callPackage ../tools/security/apg { };

  grc = callPackage ../tools/misc/grc { };

  otool = callPackage ../os-specific/darwin/otool { };

  pass = callPackage ../tools/security/pass { };

  setfile = callPackage ../os-specific/darwin/setfile { };

  install_name_tool = callPackage ../os-specific/darwin/install_name_tool { };

  xcodeenv = callPackage ../development/mobile/xcodeenv { };

  titaniumenv_2_1 = import ../development/mobile/titaniumenv {
    inherit pkgs;
    pkgs_i686 = pkgsi686Linux;
    version = "2.1";
  };

  titaniumenv_3_1 = import ../development/mobile/titaniumenv {
    inherit pkgs;
    pkgs_i686 = pkgsi686Linux;
  };

  titaniumenv = titaniumenv_3_1;

  inherit (androidenv) androidsdk_4_1;

  aria = builderDefsPackage (import ../tools/networking/aria) { };

  aria2 = callPackage ../tools/networking/aria2 { };

  at = callPackage ../tools/system/at { };

  atftp = callPackage ../tools/networking/atftp {};

  autogen = callPackage ../development/tools/misc/autogen { };

  autojump = callPackage ../tools/misc/autojump { };

  autorandr = callPackage ../tools/misc/autorandr {
    inherit (xorg) xrandr xdpyinfo;
  };

  avahi = callPackage ../development/libraries/avahi {
    qt4Support = config.avahi.qt4Support or false;
  };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  axel = callPackage ../tools/networking/axel { };

  azureus = callPackage ../tools/networking/p2p/azureus { };

  basex = callPackage ../tools/text/xml/basex { };

  babeld = callPackage ../tools/networking/babeld { };

  banner = callPackage ../games/banner {};

  barcode = callPackage ../tools/graphics/barcode {};

  bc = callPackage ../tools/misc/bc { };

  bchunk = callPackage ../tools/cd-dvd/bchunk { };

  bfr = callPackage ../tools/misc/bfr { };

  blockdiag = pythonPackages.blockdiag;

  bmon = callPackage ../tools/misc/bmon { };

  boomerang = callPackage ../development/tools/boomerang {
    stdenv = overrideGCC stdenv gcc47;
  };

  bootchart = callPackage ../tools/system/bootchart { };

  bro = callPackage ../applications/networking/ids/bro { };

  bsod = callPackage ../misc/emulators/bsod { };

  btrfsProgs = callPackage ../tools/filesystems/btrfsprogs { };

  bwm_ng = callPackage ../tools/networking/bwm-ng { };

  byobu = callPackage ../tools/misc/byobu { };

  catdoc = callPackage ../tools/text/catdoc { };

  ditaa = callPackage ../tools/graphics/ditaa { };

  dlx = callPackage ../misc/emulators/dlx { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  enca = callPackage ../tools/text/enca { };

  fop = callPackage ../tools/typesetting/fop { };

  mcrl = callPackage ../tools/misc/mcrl { };

  mcrl2 = callPackage ../tools/misc/mcrl2 { };

  syslogng = callPackage ../tools/system/syslog-ng { };
  rsyslog = callPackage ../tools/system/rsyslog { };

  mcrypt = callPackage ../tools/misc/mcrypt { };

  mcelog = callPackage ../os-specific/linux/mcelog { };

  asciidoc = callPackage ../tools/typesetting/asciidoc {
    inherit (pythonPackages) matplotlib numpy aafigure recursivePthLoader;
    enableStandardFeatures = false;
  };

  asciidocFull = appendToName "full" (asciidoc.override {
    inherit (pythonPackages) pygments;
    enableStandardFeatures = true;
  });

  autossh = callPackage ../tools/networking/autossh { };

  bacula = callPackage ../tools/backup/bacula { };

  bgs = callPackage ../tools/X11/bgs { };

  bibtextools = callPackage ../tools/typesetting/bibtex-tools {
    inherit (strategoPackages016) strategoxt sdf;
  };

  bittorrent = callPackage ../tools/networking/p2p/bittorrent {
    gui = true;
  };

  bittornado = callPackage ../tools/networking/p2p/bit-tornado { };

  blueman = callPackage ../tools/bluetooth/blueman {
    inherit (pythonPackages) notify;
  };

  bmrsa = builderDefsPackage (import ../tools/security/bmrsa/11.nix) {
    inherit unzip;
  };

  bogofilter = callPackage ../tools/misc/bogofilter {
    bdb = db4;
  };

  bsdiff = callPackage ../tools/compression/bsdiff { };

  btar = callPackage ../tools/backup/btar { };

  bup = callPackage ../tools/backup/bup {
    inherit (pythonPackages) pyxattr pylibacl setuptools fuse;
    inherit (haskellPackages) pandoc;
    par2Support = (config.bup.par2Support or false);
  };

  atool = callPackage ../tools/archivers/atool { };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  cabextract = callPackage ../tools/archivers/cabextract { };

  ccid = callPackage ../tools/security/ccid { };

  ccrypt = callPackage ../tools/security/ccrypt { };

  cdecl = callPackage ../development/tools/cdecl { };

  cdrdao = callPackage ../tools/cd-dvd/cdrdao { };

  cdrkit = callPackage ../tools/cd-dvd/cdrkit { };

  cfdg = builderDefsPackage ../tools/graphics/cfdg {
    inherit libpng bison flex;
    ffmpeg = ffmpeg_1;
  };

  checkinstall = callPackage ../tools/package-management/checkinstall { };

  cheetahTemplate = builderDefsPackage (import ../tools/text/cheetah-template/2.0.1.nix) {
    inherit makeWrapper python;
  };

  chkrootkit = callPackage ../tools/security/chkrootkit { };

  chrony = callPackage ../tools/networking/chrony { };

  cjdns = callPackage ../tools/networking/cjdns { };

  cksfv = callPackage ../tools/networking/cksfv { };

  ciopfs = callPackage ../tools/filesystems/ciopfs { };

  colord = callPackage ../tools/misc/colord { };

  colordiff = callPackage ../tools/text/colordiff { };

  connect = callPackage ../tools/networking/connect { };

  conspy = callPackage ../os-specific/linux/conspy {};

  convertlit = callPackage ../tools/text/convertlit { };

  collectd = callPackage ../tools/system/collectd { };

  colormake = callPackage ../development/tools/build-managers/colormake { };

  cowsay = callPackage ../tools/misc/cowsay { };

  cuetools = callPackage ../tools/cd-dvd/cuetools { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  "unionfs-fuse" = callPackage ../tools/filesystems/unionfs-fuse { };

  usb_modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };

  clamav = callPackage ../tools/security/clamav { };

  cloc = callPackage ../tools/misc/cloc {
    inherit (perlPackages) perl AlgorithmDiff RegexpCommon;
  };

  cloog = callPackage ../development/libraries/cloog { };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  convmv = callPackage ../tools/misc/convmv { };

  coreutils = callPackage ../tools/misc/coreutils
    {
      # TODO: Add ACL support for cross-Linux.
      aclSupport = crossSystem == null && stdenv.isLinux;
    };

  cpio = callPackage ../tools/archivers/cpio { };

  cromfs = callPackage ../tools/archivers/cromfs { };

  cron = callPackage ../tools/system/cron { };

  cudatoolkit = callPackage ../development/compilers/cudatoolkit {
    python = python26;
  };

  curl = callPackage ../tools/networking/curl rec {
    fetchurl = fetchurlBoot;
    zlibSupport = true;
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
  };

  curl3 = callPackage ../tools/networking/curl/7.15.nix rec {
    zlibSupport = true;
    sslSupport = zlibSupport;
  };

  cunit = callPackage ../tools/misc/cunit { };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  dadadodo = builderDefsPackage (import ../tools/text/dadadodo) { };

  daq = callPackage ../applications/networking/ids/daq { };

  dar = callPackage ../tools/archivers/dar { };

  davfs2 = callPackage ../tools/filesystems/davfs2 { };

  dbench = callPackage ../development/tools/misc/dbench { };

  dcraw = callPackage ../tools/graphics/dcraw { };

  debian_devscripts = callPackage ../tools/misc/debian-devscripts {
    inherit (perlPackages) CryptSSLeay LWP TimeDate DBFile FileDesktopEntry;
  };

  debootstrap = callPackage ../tools/misc/debootstrap { };

  detox = callPackage ../tools/misc/detox { };

  ddclient = callPackage ../tools/networking/ddclient { };

  dd_rescue = callPackage ../tools/system/dd_rescue { };

  ddrescue = callPackage ../tools/system/ddrescue { };

  deluge = pythonPackages.deluge;

  desktop_file_utils = callPackage ../tools/misc/desktop-file-utils { };

  despotify = callPackage ../development/libraries/despotify { };

  dev86 = callPackage ../development/compilers/dev86 {
    /* Using GNU Make 3.82 leads to this:
         make[4]: *** No rule to make target `__ldivmod.o)'
       So use 3.81.  */
    stdenv = overrideInStdenv stdenv [gnumake381];
  };

  dnsmasq = callPackage ../tools/networking/dnsmasq { };

  dnstop = callPackage ../tools/networking/dnstop { };

  dhcp = callPackage ../tools/networking/dhcp { };

  dhcpcd = callPackage ../tools/networking/dhcpcd { };

  diffstat = callPackage ../tools/text/diffstat { };

  diffutils = callPackage ../tools/text/diffutils { };

  wgetpaste = callPackage ../tools/text/wgetpaste { };

  dirmngr = callPackage ../tools/security/dirmngr { };

  disper = callPackage ../tools/misc/disper { };

  dmg2img = callPackage ../tools/misc/dmg2img { };

  docbook2x = callPackage ../tools/typesetting/docbook2x {
    inherit (perlPackages) XMLSAX XMLParser XMLNamespaceSupport;
    texinfo = texinfo5;
  };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dropbear = callPackage ../tools/networking/dropbear { };

  dtach = callPackage ../tools/misc/dtach { };

  duplicity = callPackage ../tools/backup/duplicity {
    inherit (pythonPackages) boto;
    gnupg = gnupg1;
  };

  duply = callPackage ../tools/backup/duply { };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvgrab = callPackage ../tools/video/dvgrab { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  easyrsa = callPackage ../tools/networking/easyrsa { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  editres = callPackage ../tools/graphics/editres {
    inherit (xlibs) libXt libXaw;
    inherit (xorg) utilmacros;
  };

  edk2 = callPackage ../development/compilers/edk2 { };

  efibootmgr = callPackage ../tools/system/efibootmgr { };

  elasticsearch = callPackage ../servers/search/elasticsearch { };

  enblendenfuse = callPackage ../tools/graphics/enblend-enfuse {
    boost = boost149;
  };

  encfs = callPackage ../tools/filesystems/encfs { };

  enscript = callPackage ../tools/text/enscript {
    # fix syntax errors
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  ethtool = callPackage ../tools/misc/ethtool { };

  ettercap = callPackage ../applications/networking/sniffers/ettercap { };

  euca2ools = callPackage ../tools/virtualization/euca2ools { pythonPackages = python26Packages; };

  evtest = callPackage ../applications/misc/evtest { };

  exif = callPackage ../tools/graphics/exif { };

  exiftags = callPackage ../tools/graphics/exiftags { };

  extundelete = callPackage ../tools/filesystems/extundelete { };

  expect = callPackage ../tools/misc/expect { };

  fabric = pythonPackages.fabric;

  fail2ban = callPackage ../tools/security/fail2ban { };

  fakeroot = callPackage ../tools/system/fakeroot { };

  fcitx = callPackage ../tools/inputmethods/fcitx { };

  fcron = callPackage ../tools/system/fcron { };

  fdm = callPackage ../tools/networking/fdm {};

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file { };

  filegive = callPackage ../tools/networking/filegive { };

  fileschanged = callPackage ../tools/misc/fileschanged { };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  fio = callPackage ../tools/system/fio { };

  flpsed = callPackage ../applications/editors/flpsed { };

  flvstreamer = callPackage ../tools/networking/flvstreamer { };

  libbsd = callPackage ../development/libraries/libbsd { };

  lprof = callPackage ../tools/graphics/lprof { };

  flvtool2 = callPackage ../tools/video/flvtool2 { };

  fontforge = lowPrio (callPackage ../tools/misc/fontforge { });

  fontforgeX = callPackage ../tools/misc/fontforge {
    withX11 = true;
  };

  forktty = callPackage ../os-specific/linux/forktty {};

  fortune = callPackage ../tools/misc/fortune { };

  fox = callPackage ../development/libraries/fox/default.nix {
    libpng = libpng12;
  };

  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix { };

  fping = callPackage ../tools/networking/fping {};

  fprot = callPackage ../tools/security/fprot { };

  freeipmi = callPackage ../tools/system/freeipmi {};

  freetalk = callPackage ../applications/networking/instant-messengers/freetalk {
    guile = guile_1_8;
  };

  freetds = callPackage ../development/libraries/freetds { };

  ftgl = callPackage ../development/libraries/ftgl { };

  ftgl212 = callPackage ../development/libraries/ftgl/2.1.2.nix { };

  fuppes = callPackage ../tools/networking/fuppes {
    ffmpeg = ffmpeg_0_6_90;
  };

  fsfs = callPackage ../tools/filesystems/fsfs { };

  fuse_zip = callPackage ../tools/filesystems/fuse-zip { };

  fuse_exfat = callPackage ../tools/filesystems/fuse-exfat { };

  dos2unix = callPackage ../tools/text/dos2unix { };

  uni2ascii = callPackage ../tools/text/uni2ascii { };

  g500-control = callPackage ../tools/misc/g500-control { };

  gawk = callPackage ../tools/text/gawk { };

  gdmap = callPackage ../tools/system/gdmap { };

  genext2fs = callPackage ../tools/filesystems/genext2fs { };

  gengetopt = callPackage ../development/tools/misc/gengetopt { };

  getmail = callPackage ../tools/networking/getmail { };

  getopt = callPackage ../tools/misc/getopt { };

  gftp = callPackage ../tools/networking/gftp { };

  gifsicle = callPackage ../tools/graphics/gifsicle { };

  glusterfs = callPackage ../tools/filesystems/glusterfs { };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gmvault = callPackage ../tools/networking/gmvault { };

  gnokii = builderDefsPackage (import ../tools/misc/gnokii) {
    inherit intltool perl gettext libusb pkgconfig bluez readline pcsclite
      libical gtk glib;
    inherit (xorg) libXpm;
  };

  gnufdisk = callPackage ../tools/system/fdisk {
    guile = guile_1_8;
  };

  gnugrep = callPackage ../tools/text/gnugrep {
    libiconv = libiconvOrNull;
  };

  gnulib = callPackage ../development/tools/gnulib { };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1orig = callPackage ../tools/security/gnupg1 { };

  gnupg1compat = callPackage ../tools/security/gnupg1compat { };

  # use config.packageOverrides if you prefer original gnupg1
  gnupg1 = gnupg1compat;

  gnupg = callPackage ../tools/security/gnupg { libusb = libusb1; };

  gnupg2_1 = lowPrio (callPackage ../tools/security/gnupg/git.nix {
    libassuan = libassuan2_1;
  });

  gnuplot = callPackage ../tools/graphics/gnuplot {
    texLive = null;
    lua = null;

    # use gccApple to compile on darwin, seems to resolve a malloc error
    stdenv = if stdenv.isDarwin
      then stdenvAdapters.overrideGCC stdenv gccApple
      else stdenv;
  };

  gnused = callPackage ../tools/text/gnused { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

  googleAuthenticator = callPackage ../os-specific/linux/google-authenticator { };

  gource = callPackage ../applications/version-management/gource {};

  gptfdisk = callPackage ../tools/system/gptfdisk { };

  graphviz = callPackage ../tools/graphics/graphviz { };

  /* Readded by Michael Raskin. There are programs in the wild
   * that do want 2.0 but not 2.22. Please give a day's notice for
   * objections before removal.
   */
  graphviz_2_0 = callPackage ../tools/graphics/graphviz/2.0.nix { };

  grive = callPackage ../tools/filesystems/grive { };

  groff = callPackage ../tools/text/groff {
    ghostscript = null;
  };

  grub = callPackage_i686 ../tools/misc/grub {
    buggyBiosCDSupport = config.grub.buggyBiosCDSupport or true;
  };

  grub2 = callPackage ../tools/misc/grub/2.0x.nix { libusb = libusb1; };

  grub2_efi = grub2.override { EFIsupport = true; };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome) libsoup;
  };

  gt5 = callPackage ../tools/system/gt5 { };

  gtkdatabox = callPackage ../development/libraries/gtkdatabox {};

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gtkvnc = callPackage ../tools/admin/gtk-vnc {};

  gtmess = callPackage ../applications/networking/instant-messengers/gtmess { };

  gummiboot = callPackage ../tools/misc/gummiboot { stdenv = overrideGCC stdenv gcc47; };

  gupnp = callPackage ../development/libraries/gupnp {
    inherit (gnome) libsoup;
  };

  gupnp_igd = callPackage ../development/libraries/gupnp-igd {};

  gupnptools = callPackage ../tools/networking/gupnp-tools {
    inherit (gnome) libsoup libglade gnomeicontheme;
  };

  gvpe = builderDefsPackage ../tools/networking/gvpe {
    inherit openssl gmp nettools iproute;
  };

  gzip = callPackage ../tools/compression/gzip { };

  gzrt = callPackage ../tools/compression/gzrt { };

  partclone = callPackage ../tools/backup/partclone { };

  partimage = callPackage ../tools/backup/partimage { };

  pigz = callPackage ../tools/compression/pigz { };

  haproxy = callPackage ../tools/networking/haproxy { };

  haveged = callPackage ../tools/security/haveged { };

  hardlink = callPackage ../tools/system/hardlink { };

  halibut = callPackage ../tools/typesetting/halibut { };

  hddtemp = callPackage ../tools/misc/hddtemp { };

  hdf5 = callPackage ../tools/misc/hdf5 { };

  heimdall = callPackage ../tools/misc/heimdall { };

  hevea = callPackage ../tools/typesetting/hevea { };

  highlight = callPackage ../tools/text/highlight {
    lua = lua5;
  };

  host = callPackage ../tools/networking/host { };

  hping = callPackage ../tools/networking/hping { };

  httpie = callPackage ../tools/networking/httpie { };

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  # FIXME: This Hydra snapshot is outdated and depends on the `nixPerl',
  # which no longer exists.
  #
  # hydra = callPackage ../development/tools/misc/hydra {
  #   nix = nixUnstable;
  # };

  iasl = callPackage ../development/compilers/iasl { };

  icecast = callPackage ../servers/icecast { };

  icoutils = callPackage ../tools/graphics/icoutils { };

  idutils = callPackage ../tools/misc/idutils { };

  idle3tools = callPackage ../tools/system/idle3tools { };

  iftop = callPackage ../tools/networking/iftop { };

  imapproxy = callPackage ../tools/networking/imapproxy { };

  imapsync = callPackage ../tools/networking/imapsync {
    inherit (perlPackages) MailIMAPClient;
  };

  inadyn = callPackage ../tools/networking/inadyn { };

  inetutils = callPackage ../tools/networking/inetutils { };

  ioping = callPackage ../tools/system/ioping {};

  iodine = callPackage ../tools/networking/iodine { };

  iperf = callPackage ../tools/networking/iperf { };

  ipmitool = callPackage ../tools/system/ipmitool {
    static = false;
  };

  ipmiutil = callPackage ../tools/system/ipmiutil {};

  ised = callPackage ../tools/misc/ised {};

  isl = callPackage ../development/libraries/isl { };

  isync = callPackage ../tools/networking/isync { };

  jdiskreport = callPackage ../tools/misc/jdiskreport { };

  jfsrec = callPackage ../tools/filesystems/jfsrec {
    boost = boost144;
  };

  jfsutils = callPackage ../tools/filesystems/jfsutils { };

  jhead = callPackage ../tools/graphics/jhead { };

  jing = callPackage ../tools/text/xml/jing { };

  jnettop = callPackage ../tools/networking/jnettop { };

  jq = callPackage ../development/tools/jq {};

  jscoverage = callPackage ../development/tools/misc/jscoverage { };

  jwhois = callPackage ../tools/networking/jwhois { };

  kexectools = callPackage ../os-specific/linux/kexectools { };

  keychain = callPackage ../tools/misc/keychain { };

  kismet = callPackage ../applications/networking/sniffers/kismet { };

  less = callPackage ../tools/misc/less { };

  lockfileProgs = callPackage ../tools/misc/lockfile-progs { };

  logstash = callPackage ../tools/misc/logstash { };

  klavaro = callPackage ../games/klavaro {};

  minidlna = callPackage ../tools/networking/minidlna { };

  mmv = callPackage ../tools/misc/mmv { };

  most = callPackage ../tools/misc/most { };

  multitail = callPackage ../tools/misc/multitail { };

  netperf = callPackage ../applications/networking/netperf { };

  ninka = callPackage ../development/tools/misc/ninka { };

  nodejs = callPackage ../development/web/nodejs {};

  nodePackages = recurseIntoAttrs (import ./node-packages.nix {
    inherit pkgs stdenv nodejs fetchurl;
    neededNatives = [python] ++ lib.optional (lib.elem system lib.platforms.linux) utillinux;
    self = pkgs.nodePackages;
  });

  ldns = callPackage ../development/libraries/ldns { };

  lftp = callPackage ../tools/networking/lftp { };

  libconfig = callPackage ../development/libraries/libconfig { };

  libee = callPackage ../development/libraries/libee { };

  libestr = callPackage ../development/libraries/libestr { };

  libtirpc = callPackage ../development/libraries/ti-rpc { };

  libshout = callPackage ../development/libraries/libshout { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  logcheck = callPackage ../tools/system/logcheck {
    inherit (perlPackages) mimeConstruct;
  };

  logrotate = callPackage ../tools/system/logrotate { };

  logstalgica = callPackage ../tools/graphics/logstalgica {};

  lout = callPackage ../tools/typesetting/lout { };

  lrzip = callPackage ../tools/compression/lrzip { };

  # lsh installs `bin/nettle-lfib-stream' and so does Nettle.  Give the
  # former a lower priority than Nettle.
  lsh = lowPrio (callPackage ../tools/networking/lsh { });

  lshw = callPackage ../tools/system/lshw { };

  lxc = callPackage ../os-specific/linux/lxc { };

  lzip = callPackage ../tools/compression/lzip { texinfo = texinfo5; };

  lzma = xz;

  xz = callPackage ../tools/compression/xz { };

  lzop = callPackage ../tools/compression/lzop { };

  maildrop = callPackage ../tools/networking/maildrop { };

  mailutils = callPackage ../tools/networking/mailutils {
    guile = guile_1_8;
  };

  mairix = callPackage ../tools/text/mairix { };

  makemkv = callPackage ../applications/video/makemkv { };

  man = callPackage ../tools/misc/man { };

  man_db = callPackage ../tools/misc/man-db { };

  memtest86 = callPackage ../tools/misc/memtest86 { };

  memtest86plus = callPackage ../tools/misc/memtest86+ { };

  meo = callPackage ../tools/security/meo { };

  mc = callPackage ../tools/misc/mc { };

  mcabber = callPackage ../applications/networking/instant-messengers/mcabber { };

  mcron = callPackage ../tools/system/mcron {
    guile = guile_1_8;
  };

  mdbtools = callPackage ../tools/misc/mdbtools { };

  mdbtools_git = callPackage ../tools/misc/mdbtools/git.nix { };

  megacli = callPackage ../tools/misc/megacli { };

  megatools = callPackage ../tools/networking/megatools { };

  minecraft = callPackage ../games/minecraft { };

  minetest = callPackage ../games/minetest {
    libpng = libpng12;
  };

  miniupnpc = callPackage ../tools/networking/miniupnpc { };

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  minixml = callPackage ../development/libraries/minixml { };

  mjpegtools = callPackage ../tools/video/mjpegtools { };

  mkcue = callPackage ../tools/cd-dvd/mkcue { };

  mkpasswd = callPackage ../tools/security/mkpasswd { };

  mktemp = callPackage ../tools/security/mktemp { };

  mktorrent = callPackage ../tools/misc/mktorrent { };

  modemmanager = callPackage ../tools/networking/modemmanager {};

  monit = builderDefsPackage ../tools/system/monit {
    inherit openssl flex bison;
  };

  mosh = callPackage ../tools/networking/mosh {
    boost = boostHeaders;
    inherit (perlPackages) IOTty;
  };

  mpage = callPackage ../tools/text/mpage { };

  mr = callPackage ../applications/version-management/mr { };

  mscgen = callPackage ../tools/graphics/mscgen { };

  msf = builderDefsPackage (import ../tools/security/metasploit/3.1.nix) {
    inherit ruby makeWrapper;
  };

  mssys = callPackage ../tools/misc/mssys { };

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

  muscleframework = callPackage ../tools/security/muscleframework { };

  muscletool = callPackage ../tools/security/muscletool { };

  mysql2pgsql = callPackage ../tools/misc/mysql2pgsql { };

  namazu = callPackage ../tools/text/namazu { };

  nbd = callPackage ../tools/networking/nbd { };

  netatalk = callPackage ../tools/filesystems/netatalk { };

  netcdf = callPackage ../development/libraries/netcdf { };

  nc6 = callPackage ../tools/networking/nc6 { };

  ncat = callPackage ../tools/networking/ncat { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  ndisc6 = callPackage ../tools/networking/ndisc6 { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = callPackage ../tools/networking/netcat { };

  netcat-openbsd = callPackage ../tools/networking/netcat-openbsd { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netrw = callPackage ../tools/networking/netrw { };

  netselect = callPackage ../tools/networking/netselect { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager_openvpn = callPackage ../tools/networking/network-manager/openvpn.nix { };

  networkmanager_pptp = callPackage ../tools/networking/network-manager/pptp.nix { };

  networkmanager_pptp_gnome = networkmanager_pptp.override { withGnome = true; };

  networkmanager_vpnc = callPackage ../tools/networking/network-manager/vpnc.nix { };

  networkmanager_openconnect = callPackage ../tools/networking/network-manager/openconnect.nix { gconf = gnome.GConf; };

  networkmanagerapplet = newScope gnome ../tools/networking/network-manager-applet { };

  newsbeuter = callPackage ../applications/networking/feedreaders/newsbeuter { };

  ngrok = callPackage ../tools/misc/ngrok { };

  mpack = callPackage ../tools/networking/mpack { };

  pa_applet = callPackage ../tools/audio/pa-applet { };

  nilfs_utils = callPackage ../tools/filesystems/nilfs-utils {};

  nlopt = callPackage ../development/libraries/nlopt {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap {
    inherit (pythonPackages) pysqlite;
  };

  nss_pam_ldapd = callPackage ../tools/networking/nss-pam-ldapd {};

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntop = callPackage ../tools/networking/ntop { };

  ntp = callPackage ../tools/networking/ntp { };

  numdiff = callPackage ../tools/text/numdiff { };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nwdiag = pythonPackages.nwdiag;

  nylon = callPackage ../tools/networking/nylon { };

  nzbget = callPackage ../tools/networking/nzbget { };

  oathToolkit = callPackage ../tools/security/oath-toolkit { };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  obexd = callPackage ../tools/bluetooth/obexd { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  obnam = callPackage ../tools/backup/obnam { };

  odt2txt = callPackage ../tools/text/odt2txt { };

  offlineimap = callPackage ../tools/networking/offlineimap {
    inherit (pythonPackages) sqlite3;
  };

  opendbx = callPackage ../development/libraries/opendbx { };

  opendkim = callPackage ../development/libraries/opendkim { };

  openjade = callPackage ../tools/text/sgml/openjade {
    perl = perl510;
  };

  openobex = callPackage ../tools/bluetooth/openobex { };

  openresolv = callPackage ../tools/networking/openresolv { };

  opensc_0_11_7 = callPackage ../tools/security/opensc/0.11.7.nix { };

  opensc = opensc_0_11_7;

  opensc_dnie_wrapper = callPackage ../tools/security/opensc-dnie-wrapper { };

  openssh =
    callPackage ../tools/networking/openssh {
      hpnSupport = false;
      withKerberos = false;
      etcDir = "/etc/ssh";
      pam = if stdenv.isLinux then pam else null;
    };
  openssh_with_kerberos = lowPrio (pkgs.appendToName "with-kerberos" (openssh.override { withKerberos = true; }));

  opensp = callPackage ../tools/text/sgml/opensp { };

  spCompat = callPackage ../tools/text/sgml/opensp/compat.nix { };

  openvpn = callPackage ../tools/networking/openvpn { };

  optipng = callPackage ../tools/graphics/optipng { };

  oslrd = callPackage ../tools/networking/oslrd { };

  ossec = callPackage ../tools/security/ossec {};

  otpw = callPackage ../os-specific/linux/otpw { };

  p7zip = callPackage ../tools/archivers/p7zip { };

  pal = callPackage ../tools/misc/pal { };

  panomatic = callPackage ../tools/graphics/panomatic { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  parcellite = callPackage ../tools/misc/parcellite { };

  patchutils = callPackage ../tools/text/patchutils { };

  parted = callPackage ../tools/misc/parted { hurd = null; };

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

  ipsecTools = callPackage ../os-specific/linux/ipsec-tools { };

  patch = gnupatch;

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite { };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdfjam = callPackage ../tools/typesetting/pdfjam { };

  jbig2enc = callPackage ../tools/graphics/jbig2enc { };

  pdfread = callPackage ../tools/graphics/pdfread { };

  briss = callPackage ../tools/graphics/briss { };

  pdnsd = callPackage ../tools/networking/pdnsd { };

  pg_top = callPackage ../tools/misc/pg_top { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = callPackage ../tools/graphics/pfstools { };

  philter = callPackage ../tools/networking/philter { };

  pinentry = callPackage ../tools/security/pinentry { };

  pius = callPackage ../tools/security/pius { };

  pk2cmd = callPackage ../tools/misc/pk2cmd { };

  plantuml = callPackage ../tools/misc/plantuml { };

  plan9port = callPackage ../tools/system/plan9port { };

  ploticus = callPackage ../tools/graphics/ploticus {
    libpng = libpng12;
  };

  plotutils = callPackage ../tools/graphics/plotutils { };

  plowshare = callPackage ../tools/misc/plowshare { };

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

  ponysay = callPackage ../tools/misc/ponysay { };

  povray = callPackage ../tools/graphics/povray { };

  ppl = callPackage ../development/libraries/ppl { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  prey-bash-client = callPackage ../tools/security/prey { };

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel { };

  cntlm = callPackage ../tools/networking/cntlm { };

  psmisc = callPackage ../os-specific/linux/psmisc { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pwnat = callPackage ../tools/networking/pwnat { };

  pydb = callPackage ../development/tools/pydb { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pythonDBus = dbus_python;

  pythonIRClib = builderDefsPackage (import ../development/python-modules/irclib) {
    inherit python;
  };

  pythonSexy = builderDefsPackage (import ../development/python-modules/libsexy) {
    inherit python libsexy pkgconfig libxml2 pygtk pango gtk glib;
  };

  openmpi = callPackage ../development/libraries/openmpi { };

  qhull = callPackage ../development/libraries/qhull { };

  qjoypad = callPackage ../tools/misc/qjoypad { };

  qshowdiff = callPackage ../tools/text/qshowdiff { };

  radvd = callPackage ../tools/networking/radvd { };

  privateer = callPackage ../games/privateer { };

  rtmpdump = callPackage ../tools/video/rtmpdump { };

  reaverwps = callPackage ../tools/networking/reaver-wps {};

  recutils = callPackage ../tools/misc/recutils { };

  recoll = callPackage ../applications/search/recoll { };

  refind = callPackage ../tools/misc/refind { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome) gnome_vfs GConf;
  };

  remind = callPackage ../tools/misc/remind { };

  remmina = callPackage ../applications/networking/remote/remmina {};

  renameutils = callPackage ../tools/misc/renameutils { };

  replace = callPackage ../tools/text/replace { };

  reptyr = callPackage ../os-specific/linux/reptyr {};

  rdiff_backup = callPackage ../tools/backup/rdiff-backup { };

  ripmime = callPackage ../tools/networking/ripmime {};

  rmlint = callPackage ../tools/misc/rmlint {};

  rng_tools = callPackage ../tools/security/rng-tools { };

  rsnapshot = callPackage ../tools/backup/rsnapshot {
    # For the `logger' command, we can use either `utillinux' or
    # GNU Inetutils.  The latter is more portable.
    logger = inetutils;
  };

  rlwrap = callPackage ../tools/misc/rlwrap { };

  rockbox_utility = callPackage ../tools/misc/rockbox-utility { };

  rpPPPoE = builderDefsPackage (import ../tools/networking/rp-pppoe) {
    inherit ppp;
  };

  rpm = callPackage ../tools/package-management/rpm {
    db4 = db45;
  };

  rrdtool = callPackage ../tools/misc/rrdtool { };

  rtorrent = callPackage ../tools/networking/p2p/rtorrent { };

  rubber = callPackage ../tools/typesetting/rubber { };

  rxp = callPackage ../tools/text/xml/rxp { };

  rzip = callPackage ../tools/compression/rzip { };

  s3backer = callPackage ../tools/filesystems/s3backer { };

  s3cmd = callPackage ../tools/networking/s3cmd { };

  s3sync = callPackage ../tools/networking/s3sync {
    ruby = ruby18;
  };

  sablotron = callPackage ../tools/text/xml/sablotron { };

  safecopy = callPackage ../tools/system/safecopy { };

  salut_a_toi = callPackage ../applications/networking/instant-messengers/salut-a-toi {};

  samplicator = callPackage ../tools/networking/samplicator { };

  screen = callPackage ../tools/misc/screen { };

  scrot = callPackage ../tools/graphics/scrot { };

  scrypt = callPackage ../tools/security/scrypt { };

  sdcv = callPackage ../applications/misc/sdcv { };

  seccure = callPackage ../tools/security/seccure { };

  setserial = builderDefsPackage (import ../tools/system/setserial) {
    inherit groff;
  };

  seqdiag = pythonPackages.seqdiag;

  sg3_utils = callPackage ../tools/system/sg3_utils { };

  sharutils = callPackage ../tools/archivers/sharutils { };

  shebangfix = callPackage ../tools/misc/shebangfix { };

  siege = callPackage ../tools/networking/siege {};

  silc_client = callPackage ../applications/networking/instant-messengers/silc-client { };

  silc_server = callPackage ../servers/silc-server { };

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

  snort = callPackage ../applications/networking/ids/snort { };

  snx = callPackage_i686 ../tools/networking/snx {
    inherit (pkgsi686Linux) pam gcc33;
    inherit (pkgsi686Linux.xlibs) libX11;
  };

  stardict = callPackage ../applications/misc/stardict/stardict.nix {
    inherit (gnome) libgnomeui scrollkeeper;
  };

  storebrowse = callPackage ../tools/system/storebrowse { };

  fusesmb = callPackage ../tools/filesystems/fusesmb { };

  sl = callPackage ../tools/misc/sl { };

  socat = callPackage ../tools/networking/socat { };

  socat2pre = lowPrio (callPackage ../tools/networking/socat/2.x.nix { });

  sourceHighlight = callPackage ../tools/text/source-highlight {
    # Boost 1.54 causes the "test_regexranges" test to fail
    boost = boost153;
  };

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  sshfsFuse = callPackage ../tools/filesystems/sshfs-fuse { };

  sshuttle = callPackage ../tools/security/sshuttle { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = builderDefsPackage (import ../tools/system/suid-chroot) { };

  super = callPackage ../tools/security/super { };

  ssmtp = callPackage ../tools/networking/ssmtp {
    tlsSupport = true;
  };

  ssss = callPackage ../tools/security/ssss { };

  storeBackup = callPackage ../tools/backup/store-backup { };

  stow = callPackage ../tools/misc/stow { };

  stun = callPackage ../tools/networking/stun { };

  stunnel = callPackage ../tools/networking/stunnel { };

  su = shadow;

  surfraw = callPackage ../tools/networking/surfraw { };

  swec = callPackage ../tools/networking/swec {
    inherit (perlPackages) LWP URI HTMLParser HTTPServerSimple Parent;
  };

  svnfs = callPackage ../tools/filesystems/svnfs { };

  sysbench = callPackage ../development/tools/misc/sysbench {};

  system_config_printer = callPackage ../tools/misc/system-config-printer {
    libxml2 = libxml2Python;
   };

  sitecopy = callPackage ../tools/networking/sitecopy { };

  privoxy = callPackage ../tools/networking/privoxy {
    autoconf = autoconf213;
  };

  tarsnap = callPackage ../tools/backup/tarsnap { };

  tcpcrypt = callPackage ../tools/security/tcpcrypt { };

  tcpdump = callPackage ../tools/networking/tcpdump { };

  teamviewer = callPackage_i686 ../applications/networking/remote/teamviewer { };

  # Work In Progress: it doesn't start unless running a daemon as root
  teamviewer8 = lowPrio (callPackage_i686 ../applications/networking/remote/teamviewer/8.nix { });

  telnet = callPackage ../tools/networking/telnet { };

  texmacs = callPackage ../applications/editors/texmacs {
    tex = texLive; /* tetex is also an option */
    extraFonts = true;
    guile = guile_1_8;
  };

  tiled-qt = callPackage ../applications/editors/tiled-qt { qt = qt4; };

  tinc = callPackage ../tools/networking/tinc { };

  tmux = callPackage ../tools/misc/tmux { };

  tor = callPackage ../tools/security/tor { };

  torbutton = callPackage ../tools/security/torbutton { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  trickle = callPackage ../tools/networking/trickle {};

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ttysnoop = callPackage ../os-specific/linux/ttysnoop {};

  twitterBootstrap = callPackage ../development/web/twitter-bootstrap {};

  txt2man = callPackage ../tools/misc/txt2man { };

  ucl = callPackage ../development/libraries/ucl { };

  udftools = callPackage ../tools/filesystems/udftools {};

  udptunnel = callPackage ../tools/networking/udptunnel { };

  ufraw = callPackage ../applications/graphics/ufraw { };

  unetbootin = callPackage ../tools/cd-dvd/unetbootin { };

  unfs3 = callPackage ../servers/unfs3 { };

  unoconv = callPackage ../tools/text/unoconv { };

  upx = callPackage ../tools/compression/upx { };

  urlview = callPackage ../applications/misc/urlview {};

  usbmuxd = callPackage ../tools/misc/usbmuxd {};

  vacuum = callPackage ../applications/networking/instant-messengers/vacuum {};

  vidalia = callPackage ../tools/security/vidalia { };

  vbetool = builderDefsPackage ../tools/system/vbetool {
    inherit pciutils libx86 zlib;
  };

  vde2 = callPackage ../tools/networking/vde2 { };

  vboot_reference = callPackage ../tools/system/vboot_reference { };

  verilog = callPackage ../applications/science/electronics/verilog {};

  vfdecrypt = callPackage ../tools/misc/vfdecrypt { };

  vifm = callPackage ../applications/misc/vifm { };

  viking = callPackage ../applications/misc/viking {
    inherit (gnome) scrollkeeper;
  };

  vnc2flv = callPackage ../tools/video/vnc2flv {};

  vncrec = builderDefsPackage ../tools/video/vncrec {
    inherit (xlibs) imake libX11 xproto gccmakedep libXt
      libXmu libXaw libXext xextproto libSM libICE libXpm
      libXp;
  };

  vobcopy = callPackage ../tools/cd-dvd/vobcopy { };

  vorbisgain = callPackage ../tools/misc/vorbisgain { };

  vpnc = callPackage ../tools/networking/vpnc { };

  openconnect = callPackage ../tools/networking/openconnect.nix { };

  vtun = callPackage ../tools/networking/vtun { };

  wbox = callPackage ../tools/networking/wbox {};

  welkin = callPackage ../tools/graphics/welkin {};

  testdisk = callPackage ../tools/misc/testdisk { };

  htmlTidy = callPackage ../tools/text/html-tidy { };

  html-xml-utils = callPackage ../tools/text/xml/html-xml-utils { };

  tftp_hpa = callPackage ../tools/networking/tftp-hpa {};

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
    inherit (xorg) xorgserver;
    fltk = fltk13;
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = callPackage ../tools/misc/time { };

  tkabber = callPackage ../applications/networking/instant-messengers/tkabber { };

  tkabber_plugins = callPackage ../applications/networking/instant-messengers/tkabber-plugins { };

  qfsm = callPackage ../applications/science/electronics/qfsm { };

  tkgate = callPackage ../applications/science/electronics/tkgate/1.x.nix {
    inherit (xlibs) libX11 imake xproto gccmakedep;
  };

  # The newer package is low-priority because it segfaults at startup.
  tkgate2 = lowPrio (callPackage ../applications/science/electronics/tkgate/2.x.nix {
    inherit (xlibs) libX11;
  });

  tm = callPackage ../tools/system/tm { };

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

  unclutter = callPackage ../tools/misc/unclutter { };

  unbound = callPackage ../tools/networking/unbound { };

  units = callPackage ../tools/misc/units { };

  unrar = callPackage ../tools/archivers/unrar { };

  xarchive = callPackage ../tools/archivers/xarchive { };

  unarj = callPackage ../tools/archivers/unarj { };

  unshield = callPackage ../tools/archivers/unshield { };

  unzip = callPackage ../tools/archivers/unzip { };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  uptimed = callPackage ../tools/system/uptimed { };

  varnish = callPackage ../servers/varnish { };

  varnish2 = callPackage ../servers/varnish/2.1.nix { };

  venus = callPackage ../tools/misc/venus {
    python = python27;
  };

  vlan = callPackage ../tools/networking/vlan { };

  wakelan = callPackage ../tools/networking/wakelan { };

  wavemon = callPackage ../tools/networking/wavemon { };

  w3cCSSValidator = callPackage ../tools/misc/w3c-css-validator {
    tomcat = tomcat6;
  };

  wdfs = callPackage ../tools/filesystems/wdfs { };

  wdiff = callPackage ../tools/text/wdiff { };

  webalizer = callPackage ../tools/networking/webalizer { };

  webdruid = builderDefsPackage ../tools/admin/webdruid {
    inherit zlib libpng freetype gd which
      libxml2 geoip;
  };

  weighttp = callPackage ../tools/networking/weighttp { };

  wget = callPackage ../tools/networking/wget {
    inherit (perlPackages) LWP;
  };

  which = callPackage ../tools/system/which { };

  wicd = callPackage ../tools/networking/wicd { };

  wkhtmltopdf = callPackage ../tools/graphics/wkhtmltopdf { };

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

  x86info = callPackage ../os-specific/linux/x86info { };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = assert stdenv ? glibc; import ../tools/misc/xburst-tools {
    inherit stdenv fetchgit autoconf automake confuse pkgconfig libusb libusb1;
    # It needs a cross compiler for mipsel to build the firmware it will
    # load into the Ben Nanonote
    gccCross =
      let
        pkgsCross = (import ./all-packages.nix) {
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

  xdelta = callPackage ../tools/compression/xdelta { };

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { };

  xmlroff = callPackage ../tools/typesetting/xmlroff {
    inherit (gnome) libgnomeprint;
  };

  xmlstarlet = callPackage ../tools/text/xml/xmlstarlet { };

  xmlto = callPackage ../tools/typesetting/xmlto { };

  xmltv = callPackage ../tools/misc/xmltv { };

  xmpppy = builderDefsPackage (import ../development/python-modules/xmpppy) {
    inherit python setuptools;
  };

  xorriso = callPackage ../tools/cd-dvd/xorriso { };

  xpf = callPackage ../tools/text/xml/xpf {
    libxml2 = libxml2Python;
  };

  xsel = callPackage ../tools/misc/xsel { };

  xtreemfs = callPackage ../tools/filesystems/xtreemfs {};

  xvfb_run = callPackage ../tools/misc/xvfb-run { inherit (texFunctions) fontsConf; };

  youtubeDL = callPackage ../tools/misc/youtube-dl { };

  zbar = callPackage ../tools/graphics/zbar {
    pygtk = lib.overrideDerivation pygtk (x: {
      gtk = gtk2;
    });
  };

  zdelta = callPackage ../tools/compression/zdelta { };

  zile = callPackage ../applications/editors/zile { };

  zip = callPackage ../tools/archivers/zip { };

  zpaq = callPackage ../tools/archivers/zpaq { };
  zpaqd = callPackage ../tools/archivers/zpaq/zpaqd.nix { };

  zsync = callPackage ../tools/compression/zsync { };


  ### SHELLS

  bash = lowPrio (callPackage ../shells/bash {
    texinfo = null;
  });

  bashInteractive = appendToName "interactive" (callPackage ../shells/bash {
    interactive = true;
    texinfo = texinfo5;
  });

  bashCompletion = callPackage ../shells/bash-completion { };

  dash = callPackage ../shells/dash { };

  fish = callPackage ../shells/fish { };

  tcsh = callPackage ../shells/tcsh { };

  rush = callPackage ../shells/rush { };

  zsh = callPackage ../shells/zsh { };


  ### DEVELOPMENT / COMPILERS

  abc =
    abcPatchable [];

  abcPatchable = patches :
    import ../development/compilers/abc/default.nix {
      inherit stdenv fetchurl patches jre apacheAnt;
      javaCup = callPackage ../development/libraries/java/cup { };
    };

  aldor = callPackage ../development/compilers/aldor { };

  aspectj = callPackage ../development/compilers/aspectj { };

  ats2 = callPackage ../development/compilers/ats2 { };

  avra = callPackage ../development/compilers/avra { };

  bigloo = callPackage ../development/compilers/bigloo { };

  chicken = callPackage ../development/compilers/chicken { };

  ccl = builderDefsPackage ../development/compilers/ccl {};

  clangUnwrapped = callPackage ../development/compilers/llvm/clang.nix {
    stdenv = if stdenv.isDarwin
      then stdenvAdapters.overrideGCC stdenv gccApple
      else stdenv;
  };

  clang = wrapClang clangUnwrapped;

  #Use this instead of stdenv to build with clang
  clangStdenv = lowPrio (stdenvAdapters.overrideGCC stdenv clang);

  clean = callPackage ../development/compilers/clean { };

  closurecompiler = callPackage ../development/compilers/closure { };

  cmucl_binary = callPackage ../development/compilers/cmucl/binary.nix { };

  cython = callPackage ../development/interpreters/cython { };

  dylan = callPackage ../development/compilers/gwydion-dylan {
    dylan = callPackage ../development/compilers/gwydion-dylan/binary.nix {  };
  };

  ecl = callPackage ../development/compilers/ecl { };

  eql = callPackage ../development/compilers/eql {};

  adobe_flex_sdk = callPackage ../development/compilers/adobe-flex-sdk { };

  fpc = callPackage ../development/compilers/fpc { };
  fpc_2_4_0 = callPackage ../development/compilers/fpc/2.4.0.nix { };

  gambit = callPackage ../development/compilers/gambit { };

  gcc = gcc46;

  gcc33 = wrapGCC (import ../development/compilers/gcc/3.3 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc34 = wrapGCC (import ../development/compilers/gcc/3.4 {
    inherit fetchurl stdenv noSysDirs;
  });

  # XXX: GCC 4.2 (and possibly others) misdetects `makeinfo' when
  # using Texinfo >= 4.10, just because it uses a stupid regexp that
  # expects a single digit after the dot.  As a workaround, we feed
  # GCC with Texinfo 4.9.  Stupid bug, hackish workaround.

  gcc42 = wrapGCC (makeOverridable (import ../development/compilers/gcc/4.2) {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = false;
  });

  gcc43 = lowPrio (wrapGCC (makeOverridable (import ../development/compilers/gcc/4.3) {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs;
    profiledCompiler = true;
  }));

  gcc43_realCross = makeOverridable (import ../development/compilers/gcc/4.3) {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs;
    binutilsCross = binutilsCross;
    libcCross = libcCross;
    profiledCompiler = false;
    enableMultilib = true;
    crossStageStatic = false;
    cross = assert crossSystem != null; crossSystem;
  };

  gcc44_realCross = lib.addMetaAttrs { hydraPlatforms = []; }
    (makeOverridable (import ../development/compilers/gcc/4.4) {
      inherit stdenv fetchurl texinfo gmp mpfr /* ppl cloogppl */ noSysDirs
          gettext which;
      binutilsCross = binutilsCross;
      libcCross = libcCross;
      profiledCompiler = false;
      enableMultilib = false;
      crossStageStatic = false;
      cross = assert crossSystem != null; crossSystem;
    });

  gcc45 = gcc45_real;

  wrapDeterministicGCCWith = gccWrapper: glibc: baseGCC: gccWrapper {
    nativeTools = stdenv ? gcc && stdenv.gcc.nativeTools;
    nativeLibc = stdenv ? gcc && stdenv.gcc.nativeLibc;
    nativePrefix = if stdenv ? gcc then stdenv.gcc.nativePrefix else "";
    gcc = baseGCC;
    libc = glibc;
    shell = bash;
    binutils = binutils_deterministic;
    inherit stdenv coreutils zlib;
  };

  wrapDeterministicGCC = wrapDeterministicGCCWith (import ../build-support/gcc-wrapper) glibc;

  gcc46_deterministic = lowPrio (wrapDeterministicGCC (callPackage ../development/compilers/gcc/4.6 {
    inherit noSysDirs;

    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = !stdenv.isArm;

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    libpthreadCross =
      if crossSystem != null && crossSystem.config == "i586-pc-gnu"
      then gnu.libpthreadCross
      else null;
  }));

  gcc46 = gcc46_real;

  gcc47 = gcc47_real;

  gcc45_realCross = lib.addMetaAttrs { hydraPlatforms = []; }
    (makeOverridable (import ../development/compilers/gcc/4.5) {
      inherit fetchurl stdenv texinfo gmp mpfr mpc libelf zlib
        ppl cloogppl gettext which noSysDirs;
      binutilsCross = binutilsCross;
      libcCross = libcCross;
      profiledCompiler = false;
      enableMultilib = false;
      crossStageStatic = false;
      cross = assert crossSystem != null; crossSystem;
    });

  gcc46_realCross = lib.addMetaAttrs { hydraPlatforms = []; }
    (makeOverridable (import ../development/compilers/gcc/4.6) {
      inherit fetchurl stdenv texinfo gmp mpfr mpc libelf zlib
        cloog ppl gettext which noSysDirs;
      binutilsCross = binutilsCross;
      libcCross = libcCross;
      profiledCompiler = false;
      enableMultilib = false;
      crossStageStatic = false;
      cross = assert crossSystem != null; crossSystem;
    });

  gcc47_realCross = lib.addMetaAttrs { hydraPlatforms = []; }
    (makeOverridable (import ../development/compilers/gcc/4.7) {
      inherit fetchurl stdenv texinfo gmp mpfr mpc libelf zlib
        cloog ppl gettext which noSysDirs;
      binutilsCross = binutilsCross;
      libcCross = libcCross;
      profiledCompiler = false;
      enableMultilib = false;
      crossStageStatic = false;
      cross = assert crossSystem != null; crossSystem;
    });

  gcc_realCross = gcc47_realCross;

  gccCrossStageStatic = let
      isMingw = (stdenv.cross.libc == "msvcrt");
      isMingw64 = isMingw && stdenv.cross.config == "x86_64-w64-mingw32";
      libcCross1 = if isMingw64 then windows.mingw_w64_headers else
                   if isMingw then windows.mingw_headers1 else null;
    in
      wrapGCCCross {
      gcc = forceNativeDrv (lib.addMetaAttrs { hydraPlatforms = []; } (
        gcc_realCross.override {
          crossStageStatic = true;
          langCC = false;
          libcCross = libcCross1;
          enableShared = false;
        }));
      libc = libcCross1;
      binutils = binutilsCross;
      cross = assert crossSystem != null; crossSystem;
  };

  # Only needed for mingw builds
  gccCrossMingw2 = wrapGCCCross {
    gcc = gccCrossStageStatic.gcc;
    libc = windows.mingw_headers2;
    binutils = binutilsCross;
    cross = assert crossSystem != null; crossSystem;
  };

  gccCrossStageFinal = wrapGCCCross {
    gcc = forceNativeDrv (gcc_realCross.override {
      libpthreadCross =
        # FIXME: Don't explicitly refer to `i586-pc-gnu'.
        if crossSystem != null && crossSystem.config == "i586-pc-gnu"
        then gnu.libpthreadCross
        else null;

      # XXX: We have troubles cross-compiling libstdc++ on MinGW (see
      # <http://hydra.nixos.org/build/4268232>), so don't even try.
      langCC = (crossSystem == null
                || crossSystem.config != "i686-pc-mingw32");
     });
    libc = libcCross;
    binutils = binutilsCross;
    cross = assert crossSystem != null; crossSystem;
  };

  gcc44 = lowPrio (wrapGCC (makeOverridable (import ../development/compilers/gcc/4.4) {
    inherit fetchurl stdenv texinfo gmp mpfr /* ppl cloogppl */
      gettext which noSysDirs;
    profiledCompiler = true;
  }));

  gcc45_real = lowPrio (wrapGCC (makeOverridable (import ../development/compilers/gcc/4.5) {
    inherit fetchurl stdenv texinfo gmp mpfr mpc libelf zlib perl
      ppl cloogppl
      gettext which noSysDirs;
    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = !stdenv.isArm;

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    libpthreadCross =
      if crossSystem != null && crossSystem.config == "i586-pc-gnu"
      then gnu.libpthreadCross
      else null;
  }));

  gcc46_real = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.6 {
    inherit noSysDirs;

    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = !stdenv.isArm;

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    libpthreadCross =
      if crossSystem != null && crossSystem.config == "i586-pc-gnu"
      then gnu.libpthreadCross
      else null;
    texinfo = texinfo413;
  }));

  # A non-stripped version of GCC.
  gcc46_debug = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.6 {
    stripped = false;

    inherit noSysDirs;
    cross = null;
    libcCross = null;
    binutilsCross = null;
  }));

  gcc46_multi =
    if system == "x86_64-linux" then lowPrio (
      wrapGCCWith (import ../build-support/gcc-wrapper) glibc_multi (gcc46.gcc.override {
        stdenv = overrideGCC stdenv (wrapGCCWith (import ../build-support/gcc-wrapper) glibc_multi gcc.gcc);
        profiledCompiler = false;
        enableMultilib = true;
      }))
    else throw "Multilib gcc not supported on ‘${system}’";

  gcc47_real = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.7 {
    inherit noSysDirs;
    # I'm not sure if profiling with enableParallelBuilding helps a lot.
    # We can enable it back some day. This makes the *gcc* builds faster now.
    profiledCompiler = false;

    # When building `gcc.crossDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    libpthreadCross =
      if crossSystem != null && crossSystem.config == "i586-pc-gnu"
      then gnu.libpthreadCross
      else null;
  }));

  gcc47_debug = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.7 {
    stripped = false;

    inherit noSysDirs;
    cross = null;
    libcCross = null;
    binutilsCross = null;
  }));

  gccApple =
    assert stdenv.isDarwin;
    wrapGCC (makeOverridable (import ../development/compilers/gcc/4.2-apple64) {
      inherit fetchurl noSysDirs;
      profiledCompiler = true;
      # Since it fails to build with GCC 4.6, build it with the "native"
      # Apple-GCC.
      stdenv = allStdenvs.stdenvNative;
    });

  gfortran = gfortran46;

  gfortran42 = wrapGCC (gcc42.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    inherit gmp mpfr;
  });

  gfortran43 = wrapGCC (gcc43.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran44 = wrapGCC (gcc44.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran45 = wrapGCC (gcc45_real.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gfortran46 = wrapGCC (gcc46_real.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gcj = gcj45;

  gcj45 = wrapGCC (gcc45.gcc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = true;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig perl;
    inherit gtk;
    inherit (gnome) libart_lgpl;
    inherit (xlibs) libX11 libXt libSM libICE libXtst libXi libXrender
      libXrandr xproto renderproto xextproto inputproto randrproto;
  });

  gcj46 = wrapGCC (gcc46.gcc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = true;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig perl;
    inherit gtk;
    inherit (gnome) libart_lgpl;
    inherit (xlibs) libX11 libXt libSM libICE libXtst libXi libXrender
      libXrandr xproto renderproto xextproto inputproto randrproto;
  });

  gnat = gnat45;

  gnat44 = wrapGCC (gcc44.gcc.override {
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

  gnat45 = wrapGCC (gcc45_real.gcc.override {
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

  gnat46 = wrapGCC (gcc46_real.gcc.override {
    name = "gnat";
    langCC = false;
    langC = true;
    langAda = true;
    profiledCompiler = false;
    gnatboot = gnat45;
    # We can't use the ppl stuff, because we would have
    # libstdc++ problems.
    ppl = null;
    cloog = null;
  });

  gnatboot = wrapGCC (import ../development/compilers/gnatboot {
    inherit fetchurl stdenv;
  });

  # gccgo46 does not work. I set 4.7 then.
  gccgo = gccgo47;

  gccgo47 = wrapGCC (gcc47_real.gcc.override {
    name = "gccgo";
    langCC = true; #required for go.
    langC = true;
    langGo = true;
  });

  ghdl = wrapGCC (import ../development/compilers/gcc/4.3 {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs gnat;
    name = "ghdl";
    langVhdl = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    enableMultilib = false;
  });

  gcl = builderDefsPackage ../development/compilers/gcl {
    inherit mpfr m4 binutils fetchcvs emacs zlib which
      texinfo;
    gmp = gmp4;
    inherit (xlibs) libX11 xproto inputproto libXi
      libXext xextproto libXt libXaw libXmu;
    inherit stdenv;
    texLive = texLiveAggregationFun {
      paths = [
        texLive texLiveExtra
      ];
    };
  };

  jhc = callPackage ../development/compilers/jhc {
    inherit (haskellPackages_ghc6123) ghc binary zlib utf8String readline fgl
    regexCompat HsSyck random;
  };

  # Haskell and GHC

  # Import Haskell infrastructure.

  haskell = callPackage ./haskell-defaults.nix { inherit pkgs; };

  # Available GHC versions.

  # For several compiler versions, we export a large set of Haskell-related
  # packages.

  # NOTE (recurseIntoAttrs): After discussion, we originally decided to
  # enable it for all GHC versions. However, this is getting too much,
  # particularly in connection with Hydra builds for all these packages.
  # So we enable it for selected versions only.

  # Current default version: 7.6.3.
  haskellPackages = haskellPackages_ghc763;
  # Current Haskell Platform: 2013.2.0.0
  haskellPlatform = haskellPackages.haskellPlatform;

  haskellPackages_ghc6104             =                   haskell.packages_ghc6104;
  haskellPackages_ghc6121             =                   haskell.packages_ghc6121;
  haskellPackages_ghc6122             =                   haskell.packages_ghc6122;
  haskellPackages_ghc6123             =                   haskell.packages_ghc6123;
  haskellPackages_ghc701              =                   haskell.packages_ghc701;
  haskellPackages_ghc702              =                   haskell.packages_ghc702;
  haskellPackages_ghc703              =                   haskell.packages_ghc703;
  haskellPackages_ghc704              =                   haskell.packages_ghc704;
  haskellPackages_ghc721              =                   haskell.packages_ghc721;
  haskellPackages_ghc722              =                   haskell.packages_ghc722;
  haskellPackages_ghc741              =                   haskell.packages_ghc741;
  haskellPackages_ghc742              =                   haskell.packages_ghc742;
  haskellPackages_ghc761              =                   haskell.packages_ghc761;
  haskellPackages_ghc762              =                   haskell.packages_ghc762;
  # For the default version, we build profiling versions of the libraries, too.
  # The following three lines achieve that: the first two make Hydra build explicit
  # profiling and non-profiling versions; the final respects the user-configured
  # default setting.
  haskellPackages_ghc763_no_profiling = recurseIntoAttrs (haskell.packages_ghc763.noProfiling);
  haskellPackages_ghc763_profiling    = recurseIntoAttrs (haskell.packages_ghc763.profiling);
  haskellPackages_ghc763              = recurseIntoAttrs (haskell.packages_ghc763.highPrio);
  # Reasonably current HEAD snapshot.
  haskellPackages_ghcHEAD             =                   haskell.packages_ghcHEAD;

  haxe = callPackage ../development/compilers/haxe { };

  hiphopvm = callPackage ../development/interpreters/hiphopvm {
    libevent = libevent14;
    boost = boost149;
  };

  falcon = builderDefsPackage (import ../development/interpreters/falcon) {
    inherit cmake;
  };

  fsharp = callPackage ../development/compilers/fsharp {};

  go_1_0 = callPackage ../development/compilers/go { };

  go_1_1 =
    if stdenv.isDarwin then
      callPackage ../development/compilers/go/1.1-darwin.nix { }
    else
      callPackage ../development/compilers/go/1.1.nix { };

  go = go_1_1;

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt240 = callPackage ../development/compilers/gwt/2.4.0.nix { };

  ikarus = callPackage ../development/compilers/ikarus { };

  hugs = callPackage ../development/compilers/hugs { };

  path64 = callPackage ../development/compilers/path64 { };

  openjdk =
    if stdenv.isDarwin then
      callPackage ../development/compilers/openjdk-darwin { }
    else
      let
        openjdkBootstrap = callPackage ../development/compilers/openjdk/bootstrap.nix {};
        openjdkStage1 = callPackage ../development/compilers/openjdk {
          jdk = openjdkBootstrap;
          ant = pkgs.ant.override { jdk = openjdkBootstrap; };
        };
      in callPackage ../development/compilers/openjdk {
        jdk = openjdkStage1;
        ant = pkgs.ant.override { jdk = openjdkStage1; };
      };

  openjre = pkgs.openjdk.override {
    jreOnly = true;
  };

  jdk = if stdenv.isDarwin || stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
    then pkgs.openjdk
    else pkgs.oraclejdk;
  jre = if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
    then pkgs.openjre
    else pkgs.oraclejre;

  oraclejdk = pkgs.jdkdistro true false;

  oraclejre = lowPrio (pkgs.jdkdistro false false);

  jrePlugin = lowPrio (pkgs.jdkdistro false true);

  supportsJDK =
    system == "i686-linux" ||
    system == "x86_64-linux";

  jdkdistro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "plugin" else x: x)
      (callPackage ../development/compilers/jdk/jdk6-linux.nix { });

  jikes = callPackage ../development/compilers/jikes { };

  julia = callPackage ../development/compilers/julia {
    liblapack = liblapack.override {shared = true;};
    mpfr = mpfr_3_1_2;
    fftw = fftw.override {pthreads = true;};
    fftwSinglePrec = fftwSinglePrec.override {pthreads = true;};
  };

  lazarus = builderDefsPackage (import ../development/compilers/fpc/lazarus.nix) {
    inherit makeWrapper gtk glib pango atk gdk_pixbuf;
    inherit (xlibs) libXi inputproto libX11 xproto libXext xextproto;
    fpc = fpc;
  };

  lessc = callPackage ../development/compilers/lessc { };

  llvm = callPackage ../development/compilers/llvm {
    stdenv = if stdenv.isDarwin
      then stdenvAdapters.overrideGCC stdenv gccApple
      else stdenv;
  };

  mentorToolchains = recurseIntoAttrs (
    callPackage_i686 ../development/compilers/mentor {}
  );

  mitscheme = callPackage ../development/compilers/mit-scheme { };

  mlton = callPackage ../development/compilers/mlton { };

  mono = callPackage ../development/compilers/mono {
    inherit (xlibs) libX11;
  };

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  mozart = callPackage ../development/compilers/mozart { };

  neko = callPackage ../development/compilers/neko { };

  nasm = callPackage ../development/compilers/nasm { };

  nvidia_cg_toolkit = callPackage ../development/compilers/nvidia-cg-toolkit { };

  ocaml = ocaml_3_12_1;

  ocaml_3_08_0 = callPackage ../development/compilers/ocaml/3.08.0.nix { };

  ocaml_3_10_0 = callPackage ../development/compilers/ocaml/3.10.0.nix { };

  ocaml_3_11_2 = callPackage ../development/compilers/ocaml/3.11.2.nix { };

  ocaml_3_12_1 = callPackage ../development/compilers/ocaml/3.12.1.nix { };

  ocaml_4_00_1 = callPackage ../development/compilers/ocaml/4.00.1.nix { };

  ocaml_4_01_0 = callPackage ../development/compilers/ocaml/4.01.0.nix { };

  orc = callPackage ../development/compilers/orc { };

  metaocaml_3_09 = callPackage ../development/compilers/ocaml/metaocaml-3.09.nix { };

  ber_metaocaml_003 = callPackage ../development/compilers/ocaml/ber-metaocaml-003.nix { };

  mkOcamlPackages = ocaml: self: let callPackage = newScope self; in rec {
    inherit ocaml;

    camlidl = callPackage ../development/tools/ocaml/camlidl { };

    camlp5_5_strict = callPackage ../development/tools/ocaml/camlp5/5.15.nix { };

    camlp5_5_transitional = callPackage ../development/tools/ocaml/camlp5/5.15.nix {
      transitional = true;
    };

    camlp5_6_strict = callPackage ../development/tools/ocaml/camlp5 { };

    camlp5_6_transitional = callPackage ../development/tools/ocaml/camlp5 {
      transitional = true;
    };

    camlp5_strict = camlp5_6_strict;

    camlp5_transitional = camlp5_6_transitional;

    camlzip = callPackage ../development/ocaml-modules/camlzip { };

    camomile_0_8_2 = callPackage ../development/ocaml-modules/camomile/0.8.2.nix { };
    camomile = callPackage ../development/ocaml-modules/camomile { };

    camlimages = callPackage ../development/ocaml-modules/camlimages {
      libpng = libpng12;
    };

    ocaml_cairo = callPackage ../development/ocaml-modules/ocaml-cairo { };

    cryptokit = callPackage ../development/ocaml-modules/cryptokit { };

    deriving = callPackage ../development/tools/ocaml/deriving { };

    findlib = callPackage ../development/tools/ocaml/findlib { };

    dypgen = callPackage ../development/ocaml-modules/dypgen { };

    patoline = callPackage ../tools/typesetting/patoline { };

    gmetadom = callPackage ../development/ocaml-modules/gmetadom { };

    lablgl = callPackage ../development/ocaml-modules/lablgl { };

    lablgtk = callPackage ../development/ocaml-modules/lablgtk {
      inherit (gnome) libgnomecanvas libglade gtksourceview;
    };

    lablgtkmathview = callPackage ../development/ocaml-modules/lablgtkmathview {
      gtkmathview = callPackage ../development/libraries/gtkmathview { };
    };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    mldonkey = callPackage ../applications/networking/p2p/mldonkey { };

    mlgmp =  callPackage ../development/ocaml-modules/mlgmp { };

    ocaml_batteries = callPackage ../development/ocaml-modules/batteries {
      camomile = camomile_0_8_2;
    };

    ocaml_cryptgps = callPackage ../development/ocaml-modules/cryptgps { };

    ocaml_expat = callPackage ../development/ocaml-modules/expat { };

    ocamlgraph = callPackage ../development/ocaml-modules/ocamlgraph { };

    ocaml_http = callPackage ../development/ocaml-modules/http { };

    ocaml_lwt = callPackage ../development/ocaml-modules/lwt { };

    ocaml_mysql = callPackage ../development/ocaml-modules/mysql { };

    ocamlnet = callPackage ../development/ocaml-modules/ocamlnet { };

    ocaml_pcre = callPackage ../development/ocaml-modules/pcre {
      inherit pcre;
    };

    ocaml_react = callPackage ../development/ocaml-modules/react { };

    ocaml_sqlite3 = callPackage ../development/ocaml-modules/sqlite3 { };

    ocaml_ssl = callPackage ../development/ocaml-modules/ssl { };

    ounit = callPackage ../development/ocaml-modules/ounit { };

    ulex = callPackage ../development/ocaml-modules/ulex { };

    ulex08 = callPackage ../development/ocaml-modules/ulex/0.8 {
      camlp5 = camlp5_transitional;
    };

    ocaml_typeconv = callPackage ../development/ocaml-modules/typeconv { };

    ocaml_sexplib = callPackage ../development/ocaml-modules/sexplib { };

    ocaml_extlib = callPackage ../development/ocaml-modules/extlib { };

    pycaml = callPackage ../development/ocaml-modules/pycaml { };

    opam = callPackage ../development/tools/ocaml/opam { };
  };

  ocamlPackages = recurseIntoAttrs ocamlPackages_3_12_1;
  ocamlPackages_3_10_0 = mkOcamlPackages ocaml_3_10_0 pkgs.ocamlPackages_3_10_0;
  ocamlPackages_3_11_2 = mkOcamlPackages ocaml_3_11_2 pkgs.ocamlPackages_3_11_2;
  ocamlPackages_3_12_1 = mkOcamlPackages ocaml_3_12_1 pkgs.ocamlPackages_3_12_1;
  ocamlPackages_4_00_1 = mkOcamlPackages ocaml_4_00_1 pkgs.ocamlPackages_4_00_1;

  ocaml_make = callPackage ../development/ocaml-modules/ocamlmake { };

  opa = let callPackage = newScope pkgs.ocamlPackages_3_12_1; in callPackage ../development/compilers/opa { };

  ocamlnat = let callPackage = newScope pkgs.ocamlPackages_3_12_1; in callPackage ../development/ocaml-modules/ocamlnat { };

  opencxx = callPackage ../development/compilers/opencxx {
    gcc = gcc33;
  };

  qcmm = callPackage ../development/compilers/qcmm {
    lua   = lua4;
    ocaml = ocaml_3_08_0;
  };

  deterministicStdenv = lowPrio (
    overrideInStdenv (
      stdenvAdapters.overrideGCC
        (stdenvAdapters.overrideSetup stdenv ../stdenv/generic/setup-repeatable.sh )
      gcc46_deterministic
    )
    [ binutils_deterministic ]
  );

  roadsend = callPackage ../development/compilers/roadsend { };

  # TODO: the corresponding nix file is missing
  # rust = pkgsi686Linux.callPackage ../development/compilers/rust {};

  sbcl = builderDefsPackage (import ../development/compilers/sbcl) {
    inherit makeWrapper clisp;
  };

  scala_2_9 = callPackage ../development/compilers/scala/2.9.nix { };
  scala_2_10 = callPackage ../development/compilers/scala { };
  scala = scala_2_10;

  sdcc = callPackage ../development/compilers/sdcc {
    boost = boost149; # sdcc 3.2.0 fails to build with boost 1.53
  };

  smlnj = callPackage_i686 ../development/compilers/smlnj { };

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

  tinycc = callPackage ../development/compilers/tinycc { };

  urweb = callPackage ../development/compilers/urweb { };

  vala = vala19;

  vala15 = callPackage ../development/compilers/vala/15.2.nix { };

  vala16 = callPackage ../development/compilers/vala/16.1.nix { };

  vala19 = callPackage ../development/compilers/vala/default.nix { };

  visualcpp = callPackage ../development/compilers/visual-c++ { };

  vs90wrapper = callPackage ../development/compilers/vs90wrapper { };

  webdsl = callPackage ../development/compilers/webdsl { };

  win32hello = callPackage ../development/compilers/visual-c++/test { };

  wrapGCCWith = gccWrapper: glibc: baseGCC: gccWrapper {
    nativeTools = stdenv ? gcc && stdenv.gcc.nativeTools;
    nativeLibc = stdenv ? gcc && stdenv.gcc.nativeLibc;
    nativePrefix = if stdenv ? gcc then stdenv.gcc.nativePrefix else "";
    gcc = baseGCC;
    libc = glibc;
    shell = bash;
    inherit stdenv binutils coreutils zlib;
  };

  wrapClangWith = clangWrapper: glibc: baseClang: clangWrapper {
    nativeTools = stdenv ? gcc && stdenv.gcc.nativeTools;
    nativeLibc = stdenv ? gcc && stdenv.gcc.nativeLibc;
    nativePrefix = if stdenv ? gcc then stdenv.gcc.nativePrefix else "";
    clang = baseClang;
    libc = glibc;
    shell = bash;
    binutils = stdenv.gcc.binutils;
    inherit stdenv coreutils zlib;
  };

  wrapClang = wrapClangWith (import ../build-support/clang-wrapper) glibc;

  wrapGCC = wrapGCCWith (import ../build-support/gcc-wrapper) glibc;

  wrapGCCCross =
    {gcc, libc, binutils, cross, shell ? "", name ? "gcc-cross-wrapper"}:

    forceNativeDrv (import ../build-support/gcc-cross-wrapper {
      nativeTools = false;
      nativeLibc = false;
      noLibc = (libc == null);
      inherit stdenv gcc binutils libc shell name cross;
    });

  # prolog
  yap = callPackage ../development/compilers/yap { };

  yasm = callPackage ../development/compilers/yasm { };


  ### DEVELOPMENT / INTERPRETERS

  acl2 = builderDefsPackage ../development/interpreters/acl2 {
    inherit sbcl;
  };

  angelscript = callPackage ../development/interpreters/angelscript {};

  clisp = callPackage ../development/interpreters/clisp { };

  # compatibility issues in 2.47 - at list 2.44.1 is known good
  # for sbcl bootstrap
  clisp_2_44_1 = callPackage ../development/interpreters/clisp/2.44.1.nix {
    libsigsegv = libsigsegv_25;
  };

  clojure = callPackage ../development/interpreters/clojure { };

  clojureUnstable = callPackage ../development/interpreters/clojure { version = "1.5.0-RC1"; };

  clojure_binary = callPackage ../development/interpreters/clojure/binary.nix { };

  clojure_wrapper = callPackage ../development/interpreters/clojure/wrapper.nix {
    #clojure = clojure_binary;
  };

  clooj_standalone_binary = callPackage ../development/interpreters/clojure/clooj.nix { };

  clooj_wrapper = callPackage ../development/interpreters/clojure/clooj-wrapper.nix {
    clooj = clooj_standalone_binary;
  };

  erlangR14B04 = callPackage ../development/interpreters/erlang/R14B04.nix { };
  erlangR15B03 = callPackage ../development/interpreters/erlang/R15B03.nix { };
  erlangR16B01 = callPackage ../development/interpreters/erlang/R16B01.nix { };
  erlang = erlangR16B01;

  rebar = callPackage ../development/tools/build-managers/rebar { };

  elixir = callPackage ../development/interpreters/elixir { };

  groovy = callPackage ../development/interpreters/groovy { };

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  guile_2_0 = callPackage ../development/interpreters/guile { };

  guile = guile_2_0;

  hadoop = callPackage ../applications/networking/cluster/hadoop { };

  io = callPackage ../development/interpreters/io { };

  j = callPackage ../development/interpreters/j {};

  jmeter = callPackage ../applications/networking/jmeter {};

  kaffe = callPackage ../development/interpreters/kaffe { };

  kona = callPackage ../development/interpreters/kona {};

  love = callPackage ../development/interpreters/love {};

  lua4 = callPackage ../development/interpreters/lua-4 { };
  lua5_0 = callPackage ../development/interpreters/lua-5/5.0.3.nix { };
  lua5_1 = callPackage ../development/interpreters/lua-5/5.1.nix { };
  lua5_2 = callPackage ../development/interpreters/lua-5/5.2.nix { };
  lua5 = lua5_1;

  luarocks = callPackage ../development/tools/misc/luarocks {
     lua = lua5;
  };

  lush2 = callPackage ../development/interpreters/lush {};

  maude = callPackage ../development/interpreters/maude { };

  octave = callPackage ../development/interpreters/octave {
    fltk = fltk13;
  };

  # mercurial (hg) bleeding edge version
  octaveHG = callPackage ../development/interpreters/octave/hg.nix { };

  perl58 = callPackage ../development/interpreters/perl/5.8 {
    impureLibcPath = if stdenv.isLinux then null else "/usr";
  };

  perl510 = callPackage ../development/interpreters/perl/5.10 { };

  perl514 = callPackage ../development/interpreters/perl/5.14 { };

  perl516 = callPackage ../development/interpreters/perl/5.16 {
    fetchurl = fetchurlBoot;
  };

  perl = if system != "i686-cygwin" then perl516 else sysPerl;

  php = php54;

  php53 = callPackage ../development/interpreters/php/5.3.nix { };

  php54 = callPackage ../development/interpreters/php/5.4.nix { };

  php_apc = callPackage ../development/libraries/php-apc { };

  php_xcache = callPackage ../development/libraries/php-xcache { };

  phpXdebug_5_3 = lowPrio (callPackage ../development/interpreters/php-xdebug {
    php = php53;
  });

  phpXdebug_5_4 = callPackage ../development/interpreters/php-xdebug { };

  phpXdebug = phpXdebug_5_4;

  picolisp = callPackage ../development/interpreters/picolisp {};

  pltScheme = racket; # just to be sure

  polyml = callPackage ../development/compilers/polyml { };

  pure = callPackage ../development/interpreters/pure {};

  python3 = hiPrio (callPackage ../development/interpreters/python/3.3 { });
  python33 = callPackage ../development/interpreters/python/3.3 { };
  python32 = callPackage ../development/interpreters/python/3.2 { };

  python = python27;
  python26 = callPackage ../development/interpreters/python/2.6 { };
  python27 = callPackage ../development/interpreters/python/2.7 {
    libX11 = xlibs.libX11;
  };

  pypy = callPackage ../development/interpreters/pypy/2.1 { };

  pythonFull = python27Full;
  python26Full = callPackage ../development/interpreters/python/wrapper.nix {
    extraLibs = [];
    postBuild = "";
    python = python26;
    inherit (python26Packages) recursivePthLoader;
  };
  python27Full = callPackage ../development/interpreters/python/wrapper.nix {
    extraLibs = [];
    postBuild = "";
    python = python27;
    inherit (python27Packages) recursivePthLoader;
  };

  pythonDocs = recurseIntoAttrs (import ../development/interpreters/python/docs {
    inherit stdenv fetchurl lib;
  });

  pythonLinkmeWrapper = callPackage ../development/interpreters/python/python-linkme-wrapper.nix { };

  pypi2nix = python27Packages.pypi2nix;

  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  qi = callPackage ../development/compilers/qi { };

  racket = callPackage ../development/interpreters/racket { };

  regina = callPackage ../development/interpreters/regina {};

  renpy = callPackage ../development/interpreters/renpy {
    ffmpeg = ffmpeg_1;
    wrapPython = pythonPackages.wrapPython;
  };

  ruby18 = callPackage ../development/interpreters/ruby/ruby-18.nix { };
  ruby19 = callPackage ../development/interpreters/ruby/ruby-19.nix { };
  ruby2 = lowPrio (callPackage ../development/interpreters/ruby/ruby-2.0.nix { });

  ruby = ruby19;

  rubyLibs = recurseIntoAttrs (callPackage ../development/interpreters/ruby/libs.nix { });

  rake = rubyLibs.rake;

  rubySqlite3 = callPackage ../development/ruby-modules/sqlite3 { };

  rubygemsFun = ruby: builderDefsPackage (import ../development/interpreters/ruby/rubygems.nix) {
    inherit ruby makeWrapper;
  };
  rubygems = hiPrio (rubygemsFun ruby);

  rq = callPackage ../applications/networking/cluster/rq { };

  scsh = callPackage ../development/interpreters/scsh { };

  spidermonkey = callPackage ../development/interpreters/spidermonkey { };
  spidermonkey_1_8_0rc1 = callPackage ../development/interpreters/spidermonkey/1.8.0-rc1.nix { };
  spidermonkey_185 = callPackage ../development/interpreters/spidermonkey/185-1.0.0.nix { };

  sysPerl = callPackage ../development/interpreters/perl/sys-perl { };

  tcl = callPackage ../development/interpreters/tcl { };

  xulrunnerWrapper = {application, launcher}:
    import ../development/interpreters/xulrunner/wrapper {
      inherit stdenv application launcher xulrunner;
    };

  xulrunner = pkgs.firefoxPkgs.xulrunner;


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

  sourceFromHead = import ../build-support/source-from-head-fun.nix {
    inherit config;
  };

  ecj = callPackage ../development/eclipse/ecj { };

  jdtsdk = callPackage ../development/eclipse/jdt-sdk { };

  jruby165 = callPackage ../development/interpreters/jruby { };

  guileCairo = callPackage ../development/guile-modules/guile-cairo { };

  guileGnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome.GConf;
    inherit (gnome) gnome_vfs libglade libgnome libgnomecanvas libgnomeui;
  };

  guile_lib = callPackage ../development/guile-modules/guile-lib { };

  guile_ncurses = callPackage ../development/guile-modules/guile-ncurses { };

  srecord = callPackage ../development/tools/misc/srecord { };

  windowssdk = (
    import ../development/misc/windows-sdk {
      inherit fetchurl stdenv cabextract;
    });


  ### DEVELOPMENT / TOOLS

  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3 = callPackage ../development/tools/parsing/antlr { };

  ant = apacheAnt;

  apacheAnt = callPackage ../development/tools/build-managers/apache-ant { };

  apacheAntOpenJDK = apacheAnt.override { jdk = openjdk; };
  apacheAntOracleJDK = ant.override { jdk = pkgs.oraclejdk; };

  apacheAntGcj = callPackage ../development/tools/build-managers/apache-ant/from-source.nix {
    # must be either pre-built or built with GCJ *alone*
    gcj = gcj.gcc; # use the raw GCJ, which has ${gcj}/lib/jvm
  };

  astyle = callPackage ../development/tools/misc/astyle { };

  autobuild = callPackage ../development/tools/misc/autobuild { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };

  autocutsel = callPackage ../tools/X11/autocutsel{ };

  automake = automake112x;

  automake110x = callPackage ../development/tools/misc/automake/automake-1.10.x.nix { };

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  automake112x = callPackage ../development/tools/misc/automake/automake-1.12.x.nix { };

  automake113x = callPackage ../development/tools/misc/automake/automake-1.13.x.nix { };

  automoc4 = callPackage ../development/tools/misc/automoc4 { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  avarice = callPackage ../development/tools/misc/avarice { };

  babeltrace = callPackage ../development/tools/misc/babeltrace { };

  bam = callPackage ../development/tools/build-managers/bam {};

  binutils = callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
  };

  binutils_deterministic = lowPrio (callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
    deterministic = true;
  });

  binutils_gold = lowPrio (callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
    gold = true;
  });

  binutilsCross = lowPrio (forceNativeDrv (import ../development/tools/misc/binutils {
    inherit stdenv fetchurl zlib;
    noSysDirs = true;
    cross = assert crossSystem != null; crossSystem;
  }));

  bison2 = callPackage ../development/tools/parsing/bison/2.x.nix { };
  bison3 = lowPrio (callPackage ../development/tools/parsing/bison/3.x.nix { });
  bison = bison2;

  buildbot = callPackage ../development/tools/build-managers/buildbot {
    inherit (pythonPackages) twisted jinja2 sqlalchemy sqlalchemy_migrate;
    dateutil = pythonPackages.dateutil_1_5;
  };

  buildbotSlave = callPackage ../development/tools/build-managers/buildbot-slave {
    inherit (pythonPackages) twisted;
  };

  byacc = callPackage ../development/tools/parsing/byacc { };

  casperjs = callPackage ../development/tools/casperjs { };

  cbrowser = callPackage ../development/tools/misc/cbrowser { };

  ccache = callPackage ../development/tools/misc/ccache { };

  # Wrapper that works as gcc or g++
  # It can be used by setting in nixpkgs config like this, for example:
  #    replaceStdenv = { pkgs }: pkgs.ccacheStdenv;
  # But if you build in chroot, you should have that path in chroot
  # If instantiated directly, it will use the HOME/.ccache as cache directory.
  # You can use an override in packageOverrides to set extraConfig:
  #    packageOverrides = pkgs: {
  #     ccacheWrapper = pkgs.ccacheWrapper.override {
  #       extraConfig = ''
  #         CCACHE_COMPRESS=1
  #         CCACHE_DIR=/bin/.ccache
  #       '';
  #     };
  #
  ccacheWrapper = makeOverridable ({ extraConfig ? "" }:
     wrapGCC (ccache.links extraConfig)) {};
  ccacheStdenv = lowPrio (overrideGCC stdenv ccacheWrapper);

  cgdb = callPackage ../development/tools/misc/cgdb { };

  chromedriver = callPackage ../development/tools/selenium/chromedriver { gconf = gnome.GConf; };

  "cl-launch" = callPackage ../development/tools/misc/cl-launch {};

  complexity = callPackage ../development/tools/misc/complexity { };

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = import ../development/tools/misc/ctags/wrapped.nix {
    inherit pkgs ctags writeScriptBin;
  };

  cmake = callPackage ../development/tools/build-managers/cmake { };

  cmake264 = callPackage ../development/tools/build-managers/cmake/264.nix { };

  cmakeCurses = cmake.override { useNcurses = true; };

  cmakeWithGui = cmakeCurses.override { useQt4 = true; };

  coccinelle = callPackage ../development/tools/misc/coccinelle { };

  framac = callPackage ../development/tools/misc/frama-c { };

  cppi = callPackage ../development/tools/misc/cppi { };

  cproto = callPackage ../development/tools/misc/cproto { };

  cflow = callPackage ../development/tools/misc/cflow { };

  cppcheck = callPackage ../development/tools/analysis/cppcheck { };

  cscope = callPackage ../development/tools/misc/cscope { };

  csslint = callPackage ../development/web/csslint { };

  libcxx = callPackage ../development/libraries/libc++ { stdenv = pkgs.clangStdenv; };

  dejagnu = callPackage ../development/tools/misc/dejagnu { };

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
     wrapGCC (distcc.links extraConfig)) {};
  distccStdenv = lowPrio (overrideGCC stdenv distccWrapper);

  distccMasquerade = callPackage ../development/tools/misc/distcc/masq.nix {
    gccRaw = gcc.gcc;
    binutils = binutils;
  };

  docutils = builderDefsPackage (import ../development/tools/documentation/docutils) {
    inherit python pil makeWrapper;
  };

  doxygen = lowPrio (doxygen_gui.override { qt4 = null; });

  /* XXX: The LaTeX output with Doxygen 1.8.0 makes LaTeX barf.
     See <https://bugzilla.gnome.org/show_bug.cgi?id=670973>.  */
  doxygen_1_7 = callPackage ../development/tools/documentation/doxygen/1.7.nix {
    qt4 = null;
  };

  doxygen_gui = callPackage ../development/tools/documentation/doxygen { };

  eggdbus = callPackage ../development/tools/misc/eggdbus { };

  elfutils = callPackage ../development/tools/misc/elfutils { };

  epm = callPackage ../development/tools/misc/epm { };

  emma = callPackage ../development/tools/analysis/emma { };

  findbugs = callPackage ../development/tools/analysis/findbugs { };

  pmd = callPackage ../development/tools/analysis/pmd { };

  jdepend = callPackage ../development/tools/analysis/jdepend { };

  checkstyle = callPackage ../development/tools/analysis/checkstyle { };

  flex = flex2535;

  flex2535 = callPackage ../development/tools/parsing/flex/flex-2.5.35.nix { };

  flex2534 = callPackage ../development/tools/parsing/flex/flex-2.5.34.nix { };

  flex2533 = callPackage ../development/tools/parsing/flex/flex-2.5.33.nix { };

  # Note: 2.5.4a is much older than 2.5.35 but happens first when sorting
  # alphabetically, hence the low priority.
  flex254a = lowPrio (import ../development/tools/parsing/flex/flex-2.5.4a.nix {
    inherit fetchurl stdenv yacc;
  });

  m4 = gnum4;

  global = callPackage ../development/tools/misc/global { };

  gnome_doc_utils = callPackage ../development/tools/documentation/gnome-doc-utils {};

  gnum4 = callPackage ../development/tools/misc/gnum4 { };

  gnumake = callPackage ../development/tools/build-managers/gnumake { };

  gnumake380 = callPackage ../development/tools/build-managers/gnumake-3.80 { };
  gnumake381 = callPackage ../development/tools/build-managers/gnumake/3.81.nix { };

  gob2 = callPackage ../development/tools/misc/gob2 { };

  gradle = callPackage ../development/tools/build-managers/gradle { };

  gperf = callPackage ../development/tools/misc/gperf { };

  gtk_doc = callPackage ../development/tools/documentation/gtk-doc { };

  gtkdialog = callPackage ../development/tools/misc/gtkdialog { };

  guileLint = callPackage ../development/tools/guile/guile-lint { };

  gwrap = callPackage ../development/tools/guile/g-wrap { };

  help2man = callPackage ../development/tools/misc/help2man {
    inherit (perlPackages) LocaleGettext;
  };

  hyenae = callPackage ../tools/networking/hyenae { };

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils {
    inherit (perlPackages) XMLSimple;
  };

  indent = callPackage ../development/tools/misc/indent { };

  ino = callPackage ../development/arduino/ino { };

  inotifyTools = callPackage ../development/tools/misc/inotify-tools { };

  intelgen4asm = callPackage ../development/misc/intelgen4asm { };

  ired = callPackage ../development/tools/analysis/radare/ired.nix { };

  itstool = callPackage ../development/tools/misc/itstool { };

  jam = callPackage ../development/tools/build-managers/jam { };

  jikespg = callPackage ../development/tools/parsing/jikespg { };

  lcov = callPackage ../development/tools/analysis/lcov { };

  leiningen = callPackage ../development/tools/build-managers/leiningen { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  lsof = callPackage ../development/tools/misc/lsof { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  lttngTools = callPackage ../development/tools/misc/lttng-tools { };

  lttngUst = callPackage ../development/tools/misc/lttng-ust { };

  lttv = callPackage ../development/tools/misc/lttv { };

  mk = callPackage ../development/tools/build-managers/mk { };

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
  };

  ninja = callPackage ../development/tools/build-managers/ninja { };

  noweb = callPackage ../development/tools/literate-programming/noweb { };

  omake = callPackage ../development/tools/ocaml/omake { };
  omake_rc1 = callPackage ../development/tools/ocaml/omake/0.9.8.6-rc1.nix { };

  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = callPackage ../development/tools/profiling/oprofile { };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = callPackage ../development/tools/misc/patchelf/unstable.nix { };

  peg = callPackage ../development/tools/parsing/peg { };

  phantomjs = callPackage ../development/tools/phantomjs { };

  pmccabe = callPackage ../development/tools/misc/pmccabe { };

  /* Make pkgconfig always return a nativeDrv, never a proper crossDrv,
     because most usage of pkgconfig as buildInput (inheritance of
     pre-cross nixpkgs) means using it using as nativeBuildInput
     cross_renaming: we should make all programs use pkgconfig as
     nativeBuildInput after the renaming.
     */
  pkgconfig = forceNativeDrv (callPackage ../development/tools/misc/pkgconfig { });
  pkgconfigUpstream = lowPrio (pkgconfig.override { vanilla = true; });

  premake3 = callPackage ../development/tools/misc/premake/3.nix { };

  premake4 = callPackage ../development/tools/misc/premake { };

  premake = premake4;

  pstack = callPackage ../development/tools/misc/gdb/pstack.nix { };

  radare = callPackage ../development/tools/analysis/radare {
    inherit (gnome) vte;
    lua = lua5;
    useX11 = config.radare.useX11 or false;
    pythonBindings = config.radare.pythonBindings or false;
    rubyBindings = config.radare.rubyBindings or false;
    luaBindings = config.radare.luaBindings or false;
  };

  ragel = callPackage ../development/tools/parsing/ragel { };

  re2c = callPackage ../development/tools/parsing/re2c { };

  remake = callPackage ../development/tools/build-managers/remake { };

  saleaeLogic = callPackage ../development/tools/misc/saleae-logic { };

  # couldn't find the source yet
  seleniumRCBin = callPackage ../development/tools/selenium/remote-control {
    jre = jdk;
  };

  scons = callPackage ../development/tools/build-managers/scons { };

  simpleBuildTool = callPackage ../development/tools/build-managers/simple-build-tool { };

  slimerjs = callPackage ../development/tools/slimerjs {};

  sloccount = callPackage ../development/tools/misc/sloccount { };

  smatch = callPackage ../development/tools/analysis/smatch {
    buildllvmsparse = false;
    buildc2xml = false;
  };

  sparse = callPackage ../development/tools/analysis/sparse { };

  speedtest_cli = callPackage ../tools/networking/speedtest-cli { };

  spin = callPackage ../development/tools/analysis/spin { };

  splint = callPackage ../development/tools/analysis/splint { };

  stm32flash = callPackage ../development/tools/misc/stm32flash { };

  strace = callPackage ../development/tools/misc/strace { };

  swig = callPackage ../development/tools/misc/swig { };

  swig2 = callPackage ../development/tools/misc/swig/2.x.nix { };

  swigWithJava = swig;

  swfmill = callPackage ../tools/video/swfmill { };

  swftools = callPackage ../tools/video/swftools { };

  tcptrack = callPackage ../development/tools/misc/tcptrack { };

  texinfo413 = callPackage ../development/tools/misc/texinfo/4.13a.nix { };
  texinfo49 = callPackage ../development/tools/misc/texinfo/4.9.nix { };
  texinfo5 = callPackage ../development/tools/misc/texinfo/5.1.nix { };
  texinfo = texinfo413;

  texi2html = callPackage ../development/tools/misc/texi2html { };

  uhd = callPackage ../development/tools/misc/uhd { };

  uisp = callPackage ../development/tools/misc/uisp { };

  uncrustify = callPackage ../development/tools/misc/uncrustify { };

  gdb = callPackage ../development/tools/misc/gdb {
    hurd = gnu.hurdCross;
    inherit (gnu) mig;
  };

  gdbCross = lowPrio (callPackage ../development/tools/misc/gdb {
    target = crossSystem;
  });

  valgrind = callPackage ../development/tools/analysis/valgrind {
    stdenv =
      # On Darwin, Valgrind 3.7.0 expects Apple's GCC (for
      # `__private_extern'.)
      if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  valkyrie = callPackage ../development/tools/analysis/valkyrie { };

  xc3sprog = callPackage ../development/tools/misc/xc3sprog { };

  xxdiff = callPackage ../development/tools/misc/xxdiff { };

  yacc = bison;

  yodl = callPackage ../development/tools/misc/yodl { };


  ### DEVELOPMENT / LIBRARIES

  a52dec = callPackage ../development/libraries/a52dec { };

  aacskeys = callPackage ../development/libraries/aacskeys { };

  aalib = callPackage ../development/libraries/aalib { };

  acl = callPackage ../development/libraries/acl { };

  activemq = callPackage ../development/libraries/apache-activemq { };

  adns = callPackage ../development/libraries/adns { };

  afflib = callPackage ../development/libraries/afflib {};

  agg = callPackage ../development/libraries/agg { };

  allegro = callPackage ../development/libraries/allegro {};
  allegro5 = callPackage ../development/libraries/allegro/5.nix {};

  amrnb = callPackage ../development/libraries/amrnb { };

  amrwb = callPackage ../development/libraries/amrwb { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    bdbSupport = true;
  };

  asio = callPackage ../development/libraries/asio { };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (import ../development/libraries/aspell/dictionaries.nix {
    inherit fetchurl stdenv aspell which;
  });

  aterm = aterm25;

  aterm25 = callPackage ../development/libraries/aterm/2.5.nix { };

  aterm28 = lowPrio (callPackage ../development/libraries/aterm/2.8.nix { });

  attica = callPackage ../development/libraries/attica { };

  attr = callPackage ../development/libraries/attr { };

  aqbanking = callPackage ../development/libraries/aqbanking { };

  aubio = callPackage ../development/libraries/aubio { };

  audiofile = callPackage ../development/libraries/audiofile {
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  axis = callPackage ../development/libraries/axis { };

  babl_0_0_22 = callPackage ../development/libraries/babl/0_0_22.nix { };

  babl = callPackage ../development/libraries/babl { };

  beecrypt = callPackage ../development/libraries/beecrypt { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost144 = callPackage ../development/libraries/boost/1.44.nix { };
  boost149 = callPackage ../development/libraries/boost/1.49.nix { };
  boost153 = callPackage ../development/libraries/boost/1.53.nix { };
  boost154 = callPackage ../development/libraries/boost/1.54.nix { };
  boost155 = callPackage ../development/libraries/boost/1.55.nix { };
  boost = boost155;

  boostHeaders = callPackage ../development/libraries/boost/header-only-wrapper.nix { };

  botan = callPackage ../development/libraries/botan { };

  box2d = callPackage ../development/libraries/box2d { };
  box2d_2_0_1 = callPackage ../development/libraries/box2d/2.0.1.nix { };

  buddy = callPackage ../development/libraries/buddy { };

  bwidget = callPackage ../development/libraries/bwidget { };

  c-ares = callPackage ../development/libraries/c-ares {
    fetchurl = fetchurlBoot;
  };

  caelum = callPackage ../development/libraries/caelum { };

  scmccid = callPackage ../development/libraries/scmccid { };

  ccrtp = callPackage ../development/libraries/ccrtp { };
  ccrtp_1_8 = callPackage ../development/libraries/ccrtp/1.8.nix { };

  celt = callPackage ../development/libraries/celt {};
  celt_0_7 = callPackage ../development/libraries/celt/0.7.nix {};
  celt_0_5_1 = callPackage ../development/libraries/celt/0.5.1.nix {};

  cgal = callPackage ../development/libraries/CGAL {};

  cgui = callPackage ../development/libraries/cgui {};

  check = callPackage ../development/libraries/check { };

  chipmunk = builderDefsPackage (import ../development/libraries/chipmunk) {
    inherit cmake freeglut mesa;
    inherit (xlibs) libX11 xproto inputproto libXi libXmu;
  };

  chmlib = callPackage ../development/libraries/chmlib { };

  chromaprint = callPackage ../development/libraries/chromaprint { };

  cil = callPackage ../development/libraries/cil { };

  cilaterm = callPackage ../development/libraries/cil-aterm {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  clanlib = callPackage ../development/libraries/clanlib { };

  classads = callPackage ../development/libraries/classads { };

  classpath = callPackage ../development/libraries/java/classpath {
    javac = gcj;
    jvm = gcj;
    gconf = gnome.GConf;
  };

  clearsilver = callPackage ../development/libraries/clearsilver { };

  cln = callPackage ../development/libraries/cln { };

  clppcre = builderDefsPackage (import ../development/libraries/cl-ppcre) { };

  clucene_core_2 = callPackage ../development/libraries/clucene-core/2.x.nix { };

  clucene_core = callPackage ../development/libraries/clucene-core { };

  cluceneCore = clucene_core; # !!! remove this

  clutter = callPackage ../development/libraries/clutter { };

  clutter_gtk = callPackage ../development/libraries/clutter-gtk { };
  clutter_gtk_0_10 = callPackage ../development/libraries/clutter-gtk/0.10.8.nix { };

  cminpack = callPackage ../development/libraries/cminpack { };

  cogl = callPackage ../development/libraries/cogl { };

  coin3d = callPackage ../development/libraries/coin3d { };

  commoncpp2 = callPackage ../development/libraries/commoncpp2 { };

  confuse = callPackage ../development/libraries/confuse { };

  coredumper = callPackage ../development/libraries/coredumper { };

  ctl = callPackage ../development/libraries/ctl { };

  cppunit = callPackage ../development/libraries/cppunit { };

  cppnetlib = callPackage ../development/libraries/cppnetlib {
    boost = boostHeaders;
  };

  cracklib = callPackage ../development/libraries/cracklib { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  cyrus_sasl = callPackage ../development/libraries/cyrus-sasl { };

  db4 = db45;

  db44 = callPackage ../development/libraries/db4/db4-4.4.nix { };

  db45 = callPackage ../development/libraries/db4/db4-4.5.nix { };

  db47 = callPackage ../development/libraries/db4/db4-4.7.nix { };

  db48 = callPackage ../development/libraries/db4/db4-4.8.nix { };

  dbus = callPackage ../development/libraries/dbus { };
  dbus_cplusplus  = callPackage ../development/libraries/dbus-cplusplus { };
  dbus_glib       = callPackage ../development/libraries/dbus-glib { };
  dbus_java       = callPackage ../development/libraries/java/dbus-java { };
  dbus_python     = callPackage ../development/python-modules/dbus { };
  # Should we deprecate these? Currently there are many references.
  dbus_tools = dbus.tools;
  dbus_libs = dbus.libs;
  dbus_daemon = dbus.daemon;

  dhex = callPackage ../applications/editors/dhex { };

  dclib = callPackage ../development/libraries/dclib { };

  directfb = callPackage ../development/libraries/directfb { };

  dotconf = callPackage ../development/libraries/dotconf { };

  dssi = callPackage ../development/libraries/dssi {};

  dragonegg = callPackage ../development/compilers/llvm/dragonegg.nix { };

  dxflib = callPackage ../development/libraries/dxflib {};

  eigen = callPackage ../development/libraries/eigen {};

  eigen2 = callPackage ../development/libraries/eigen/2.0.nix {};

  enchant = callPackage ../development/libraries/enchant { };

  enet = callPackage ../development/libraries/enet { };

  enginepkcs11 = callPackage ../development/libraries/enginepkcs11 { };

  esdl = callPackage ../development/libraries/esdl { };

  exiv2 = callPackage ../development/libraries/exiv2 { };

  expat = callPackage ../development/libraries/expat { };

  extremetuxracer = builderDefsPackage (import ../games/extremetuxracer) {
    inherit mesa tcl freeglut SDL SDL_mixer pkgconfig
      gettext intltool;
    inherit (xlibs) libX11 xproto libXi inputproto
      libXmu libXext xextproto libXt libSM libICE;
    libpng = libpng12;
  };

  eventlog = callPackage ../development/libraries/eventlog { };

  facile = callPackage ../development/libraries/facile { };

  faac = callPackage ../development/libraries/faac { };

  faad2 = callPackage ../development/libraries/faad2 { };

  farsight2 = callPackage ../development/libraries/farsight2 { };

  farstream = callPackage ../development/libraries/farstream { };

  fcgi = callPackage ../development/libraries/fcgi { };

  ffmpeg = callPackage ../development/libraries/ffmpeg {
    vpxSupport = !stdenv.isMips;

    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  ffmpeg_0_6_90 = callPackage ../development/libraries/ffmpeg/0.6.90.nix {
    vpxSupport = !stdenv.isMips;
  };

  ffmpeg_1 = callPackage ../development/libraries/ffmpeg/1.x.nix {
    vpxSupport = !stdenv.isMips;
    texinfo = texinfo5;
  };

  ffms = callPackage ../development/libraries/ffms { };

  fftw = callPackage ../development/libraries/fftw {
    singlePrecision = false;
  };

  fftwFloat = callPackage ../development/libraries/fftw {
    float = true;
  };

  fftwSinglePrec = callPackage ../development/libraries/fftw {
    singlePrecision = true;
  };

  flann = callPackage ../development/libraries/flann { };

  flite = callPackage ../development/libraries/flite { };

  fltk13 = callPackage ../development/libraries/fltk/fltk13.nix { };

  fltk20 = callPackage ../development/libraries/fltk { };

  fmod = callPackage ../development/libraries/fmod { };

  freeimage = callPackage ../development/libraries/freeimage { };

  freetts = callPackage ../development/libraries/freetts { };

  cfitsio = callPackage ../development/libraries/cfitsio { };

  fontconfig = callPackage ../development/libraries/fontconfig { };

  makeFontsConf = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    import ../development/libraries/fontconfig/make-fonts-conf.nix {
      inherit runCommand libxslt fontconfig fontDirectories;
    };

  freealut = callPackage ../development/libraries/freealut { };

  freeglut = if stdenv.isDarwin then darwinX11AndOpenGL else
    callPackage ../development/libraries/freeglut { };

  freetype = callPackage ../development/libraries/freetype { };

  fribidi = callPackage ../development/libraries/fribidi { };

  funambol = callPackage ../development/libraries/funambol { };

  fam = gamin;

  gamin = callPackage ../development/libraries/gamin { };

  gav = callPackage ../games/gav { };

  gsb = callPackage ../games/gsb { };

  gdome2 = callPackage ../development/libraries/gdome2 {
    inherit (gnome) gtkdoc;
  };

  gdbm = callPackage ../development/libraries/gdbm { };

  gegl = callPackage ../development/libraries/gegl {
    #  avocodec avformat librsvg
  };

  gegl_0_0_22 = callPackage ../development/libraries/gegl/0_0_22.nix {
    #  avocodec avformat librsvg
    libpng = libpng12;
  };

  geoclue = callPackage ../development/libraries/geoclue {};

  geoclue2 = callPackage ../development/libraries/geoclue/2.0.nix {
    libsoup = libsoup_2_40;
  };

  geoip = builderDefsPackage ../development/libraries/geoip {
    inherit zlib;
  };

  geoipjava = callPackage ../development/libraries/java/geoipjava { };

  geos = callPackage ../development/libraries/geos { };

  gettext = gettext_0_18;

  gettext_0_17 = callPackage ../development/libraries/gettext/0.17.nix { };
  gettext_0_18 = callPackage ../development/libraries/gettext { };

  gd = callPackage ../development/libraries/gd { };

  gdal = callPackage ../development/libraries/gdal { };

  ggz_base_libs = callPackage ../development/libraries/ggz_base_libs {};

  giblib = callPackage ../development/libraries/giblib { };

  libgit2 = callPackage ../development/libraries/git2 { };

  glew = callPackage ../development/libraries/glew { };

  glfw = callPackage ../development/libraries/glfw { };

  glibcCross = glibc217Cross;

  glibc213 = (callPackage ../development/libraries/glibc/2.13 {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
    machHeaders = null;
    hurdHeaders = null;
    gccCross = null;
  }) // (if crossSystem != null then { crossDrv = glibc213Cross; } else {});

  glibc213Cross = forceNativeDrv (makeOverridable (import ../development/libraries/glibc/2.13)
    (let crossGNU = crossSystem != null && crossSystem.config == "i586-pc-gnu";
     in {
       inherit stdenv fetchurl;
       gccCross = gccCrossStageStatic;
       kernelHeaders = if crossGNU then gnu.hurdHeaders else linuxHeadersCross;
       installLocales = config.glibc.locales or false;
     }
     // lib.optionalAttrs crossGNU {
        inherit (gnu) machHeaders hurdHeaders libpthreadHeaders mig;
        inherit fetchgit;
      }));

  glibc = callPackage ../development/libraries/glibc/2.17 {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
    machHeaders = null;
    hurdHeaders = null;
    gccCross = null;
  };

  glibc_memusage = callPackage ../development/libraries/glibc/2.17 {
    kernelHeaders = linuxHeaders;
    installLocales = false;
    withGd = true;
  };

  glibc217Cross = forceNativeDrv (makeOverridable (import ../development/libraries/glibc/2.17)
    (let crossGNU = crossSystem != null && crossSystem.config == "i586-pc-gnu";
     in {
       inherit stdenv fetchurl;
       gccCross = gccCrossStageStatic;
       kernelHeaders = if crossGNU then gnu.hurdHeaders else linuxHeadersCross;
       installLocales = config.glibc.locales or false;
     }
     // lib.optionalAttrs crossGNU {
        inherit (gnu) machHeaders hurdHeaders libpthreadHeaders mig;
        inherit fetchgit;
      }));


  # We can choose:
  libcCrossChooser = name : if name == "glibc" then glibcCross
    else if name == "uclibc" then uclibcCross
    else if name == "msvcrt" && stdenv.cross.config == "x86_64-w64-mingw32" then
      windows.mingw_w64
    else if name == "msvcrt" then windows.mingw_headers3
    else throw "Unknown libc";

  libcCross = assert crossSystem != null; libcCrossChooser crossSystem.libc;

  eglibc = callPackage ../development/libraries/eglibc {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
  };

  glibcLocales = callPackage ../development/libraries/glibc/2.17/locales.nix { };

  glibcInfo = callPackage ../development/libraries/glibc/2.17/info.nix { };

  glibc_multi =
    runCommand "${glibc.name}-multi"
      { glibc64 = glibc;
        glibc32 = (import ./all-packages.nix {system = "i686-linux";}).glibc;
      }
      ''
        mkdir -p $out
        ln -s $glibc64/* $out/

        rm $out/lib $out/lib64
        mkdir -p $out/lib
        ln -s $glibc64/lib/* $out/lib
        ln -s $glibc32/lib $out/lib/32
        ln -s lib $out/lib64

        rm $out/include
        cp -rs $glibc32/include $out
        chmod -R u+w $out/include
        cp -rsf $glibc64/include $out
      '' # */
      ;

  glpk = callPackage ../development/libraries/glpk { };

  glsurf = callPackage ../applications/science/math/glsurf {
    inherit (ocamlPackages) lablgl findlib camlimages ocaml_mysql mlgmp;
    libpng = libpng12;
  };

  gmime = callPackage ../development/libraries/gmime { };

  gmm = callPackage ../development/libraries/gmm { };

  gmp = gmp5;

  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  # The GHC bootstrap binaries link against libgmp.so.3, which is in GMP 4.x.
  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { };

  gmp5 = callPackage ../development/libraries/gmp/5.0.5.nix { };

  gmp51 = callPackage ../development/libraries/gmp/5.1.1.nix { };

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection { };

  goffice = callPackage ../development/libraries/goffice {
    inherit (gnome) libglade libgnomeui;
    gconf = gnome.GConf;
    libart = gnome.libart_lgpl;
  };

  goffice_0_10 = callPackage ../development/libraries/goffice/0.10.nix {
    inherit (gnome) libglade libgnomeui;
    gconf = gnome.GConf;
    libart = gnome.libart_lgpl;
    gtk = gtk3;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };

  gperftools = callPackage ../development/libraries/gperftools { };

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr { };
  mpfr_3_1_2 = callPackage ../development/libraries/mpfr/3.1.2.nix { };

  gst_all = {
    inherit (pkgs) gstreamer gnonlin gst_python qt_gstreamer;
    gstPluginsBase = pkgs.gst_plugins_base;
    gstPluginsBad = pkgs.gst_plugins_bad;
    gstPluginsGood = pkgs.gst_plugins_good;
    gstPluginsUgly = pkgs.gst_plugins_ugly;
    gstFfmpeg = pkgs.gst_ffmpeg;
  };

  gstreamer = callPackage ../development/libraries/gstreamer/gstreamer {};

  gst_plugins_base = callPackage ../development/libraries/gstreamer/gst-plugins-base {};

  gst_plugins_good = callPackage ../development/libraries/gstreamer/gst-plugins-good {};

  gst_plugins_bad = callPackage ../development/libraries/gstreamer/gst-plugins-bad {};

  gst_plugins_ugly = callPackage ../development/libraries/gstreamer/gst-plugins-ugly {};

  gst_ffmpeg = callPackage ../development/libraries/gstreamer/gst-ffmpeg {};

  gst_python = callPackage ../development/libraries/gstreamer/gst-python {};

  gnonlin = callPackage ../development/libraries/gstreamer/gnonlin {};

  gusb = callPackage ../development/libraries/gusb {
    inherit (gnome) gtkdoc;
  };

  qt_gstreamer = callPackage ../development/libraries/gstreamer/qt-gstreamer {};

  gnet = callPackage ../development/libraries/gnet { };

  gnu-efi = callPackage ../development/libraries/gnu-efi {
    stdenv = overrideGCC stdenv gcc47;
  };

  gnutls = callPackage ../development/libraries/gnutls {
    guileBindings = config.gnutls.guile or true;
  };

  gnutls2 = callPackage ../development/libraries/gnutls/2.12.nix {
    guileBindings = config.gnutls.guile or true;
  };

  gnutls32 = callPackage ../development/libraries/gnutls/3.2.nix {
    guileBindings = config.gnutls.guile or true;
  };

  gnutls_without_guile = lowPrio (gnutls.override { guileBindings = false; });
  gnutls2_without_guile = lowPrio (gnutls2.override { guileBindings = false; });

  gpac = callPackage ../applications/video/gpac { };

  gpgme = callPackage ../development/libraries/gpgme {
    gnupg1 = gnupg1orig;
  };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsm = callPackage ../development/libraries/gsm {};

  gsoap = callPackage ../development/libraries/gsoap { };

  gss = callPackage ../development/libraries/gss { };

  gtkimageview = callPackage ../development/libraries/gtkimageview { };

  gtkmathview = callPackage ../development/libraries/gtkmathview { };

  gtkLibs = {
    inherit (pkgs) glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtk
      gtkmm;
  };

  glib = callPackage ../development/libraries/glib {
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
    automake = automake113x;
  };
  glibmm = callPackage ../development/libraries/glibmm { };

  glib_networking = callPackage ../development/libraries/glib-networking {};

  atk = callPackage ../development/libraries/atk { };
  atkmm = callPackage ../development/libraries/atkmm { };

  pixman = callPackage ../development/libraries/pixman { };

  cairo = callPackage ../development/libraries/cairo {
    glSupport = config.cairo.gl or (stdenv.isLinux &&
      !stdenv.isArm && !stdenv.isMips);
  };
  cairo_1_12_2 = callPackage ../development/libraries/cairo/1.12.2.nix { };
  cairomm = callPackage ../development/libraries/cairomm { };

  pango = callPackage ../development/libraries/pango { };
  pangomm = callPackage ../development/libraries/pangomm/2.28.x.nix {
    cairo = cairo_1_12_2;
  };

  pangox_compat = callPackage ../development/libraries/pangox-compat { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf { };

  gtk2 = callPackage ../development/libraries/gtk+/2.x.nix {
    cupsSupport = config.gtk2.cups or stdenv.isLinux;
  };

  gtk3 = lowPrio (callPackage ../development/libraries/gtk+/3.x.nix {
    inherit (gnome3) at_spi2_atk;
  });

  gtk = pkgs.gtk2;

  gtkmm = callPackage ../development/libraries/gtkmm/2.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.x.nix { };

  gtkmozembedsharp = callPackage ../development/libraries/gtkmozembed-sharp {
    gtksharp = gtksharp2;
  };

  gtksharp1 = callPackage ../development/libraries/gtk-sharp-1 {
    inherit (gnome) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtksharp2 = callPackage ../development/libraries/gtk-sharp-2 {
    inherit (gnome) libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf gnomepanel;
  };

  gtksourceviewsharp = callPackage ../development/libraries/gtksourceview-sharp {
    inherit (gnome) gtksourceview;
    gtksharp = gtksharp2;
  };

  gtkspell = callPackage ../development/libraries/gtkspell { };

  gts = callPackage ../development/libraries/gts { };

  gvfs = callPackage ../development/libraries/gvfs { };

  gwenhywfar = callPackage ../development/libraries/gwenhywfar { };

  # TODO : Add MIT Kerberos and let admin choose.
  kerberos = heimdal;

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix { };

  harfbuzz = callPackage ../development/libraries/harfbuzz {
    icu = null;
    graphite2 = null;
  };

  hawknl = callPackage ../development/libraries/hawknl { };

  herqq = callPackage ../development/libraries/herqq { };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hsqldb = callPackage ../development/libraries/java/hsqldb { };

  http_parser = callPackage ../development/libraries/http_parser { inherit (pythonPackages) gyp; };

  hunspell = callPackage ../development/libraries/hunspell { };

  hwloc = callPackage ../development/libraries/hwloc {
    inherit (xlibs) libX11;
  };

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  icedtea = callPackage ../development/libraries/java/icedtea {
    ant = apacheAntGcj;
    xerces = xercesJava;
    xulrunner = icecatXulrunner3;
    inherit (xlibs) libX11 libXp libXtst libXinerama libXt
      libXrender xproto;
  };

  icu = callPackage ../development/libraries/icu { };

  id3lib = callPackage ../development/libraries/id3lib { };

  iksemel = callPackage ../development/libraries/iksemel { };

  ilbc = callPackage ../development/libraries/ilbc { };

  ilmbase = callPackage ../development/libraries/ilmbase { };

  imlib = callPackage ../development/libraries/imlib {
    libpng = libpng12;
  };

  imlib2 = callPackage ../development/libraries/imlib2 { };

  incrtcl = callPackage ../development/libraries/incrtcl { };

  indilib = callPackage ../development/libraries/indilib { };

  iniparser = callPackage ../development/libraries/iniparser { };

  inteltbb = callPackage ../development/libraries/intel-tbb { };

  intltool = callPackage ../development/tools/misc/intltool { };

  irrlicht3843 = callPackage ../development/libraries/irrlicht { };

  isocodes = callPackage ../development/libraries/iso-codes { };

  itk = callPackage ../development/libraries/itk { };

  jamp = builderDefsPackage ../games/jamp {
    inherit mesa SDL SDL_image SDL_mixer;
  };

  jasper = callPackage ../development/libraries/jasper { };

  jama = callPackage ../development/libraries/jama { };

  jansson = callPackage ../development/libraries/jansson { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jetty_gwt = callPackage ../development/libraries/java/jetty-gwt { };

  jetty_util = callPackage ../development/libraries/java/jetty-util { };

  json_glib = callPackage ../development/libraries/json-glib { };

  json_c = callPackage ../development/libraries/json-c { };

  jsoncpp = callPackage ../development/libraries/jsoncpp { };

  libjson = callPackage ../development/libraries/libjson { };

  judy = callPackage ../development/libraries/judy { };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix { };

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  lensfun = callPackage ../development/libraries/lensfun { };

  lesstif = callPackage ../development/libraries/lesstif { };

  lesstif93 = callPackage ../development/libraries/lesstif-0.93 { };

  leveldb = callPackage ../development/libraries/leveldb { };

  levmar = callPackage ../development/libraries/levmar { };

  leptonica = callPackage ../development/libraries/leptonica {
    libpng = libpng12;
  };

  lib3ds = callPackage ../development/libraries/lib3ds { };

  libaacs = callPackage ../development/libraries/libaacs { };

  libaal = callPackage ../development/libraries/libaal { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = config.pulseaudio or true;
  };

  libarchive = callPackage ../development/libraries/libarchive { };

  libass = callPackage ../development/libraries/libass { };

  libassuan1 = callPackage ../development/libraries/libassuan1 { };

  libassuan = callPackage ../development/libraries/libassuan { };

  libassuan2_1 = callPackage ../development/libraries/libassuan/git.nix { };

  libav = libav_9;
  libav_all = callPackage ../development/libraries/libav { };
  inherit (libav_all) libav_9 libav_0_8;

  libavc1394 = callPackage ../development/libraries/libavc1394 { };

  libbluedevil = callPackage ../development/libraries/libbluedevil { };

  libbluray = callPackage ../development/libraries/libbluray { };

  libbs2b = callPackage ../development/libraries/audio/libbs2b { };

  libcaca = callPackage ../development/libraries/libcaca { };

  libcanberra = callPackage ../development/libraries/libcanberra { };
  libcanberra_gtk3 = libcanberra.override { gtk = gtk3; };
  libcanberra_kde = if (config.kde_runtime.libcanberraWithoutGTK or true)
    then libcanberra.override { gtk = null; }
    else libcanberra;

  libcello = callPackage ../development/libraries/libcello {};

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio { };

  libcdr = callPackage ../development/libraries/libcdr { lcms = lcms2; };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome) libsoup;
  };

  libchamplain_0_6 = callPackage ../development/libraries/libchamplain/0.6.nix {};

  libchop = callPackage ../development/libraries/libchop { };

  libcm = callPackage ../development/libraries/libcm { };

  inherit (gnome3) libcroco;

  libctemplate = callPackage ../development/libraries/libctemplate { };

  libcue = callPackage ../development/libraries/libcue { };

  libdaemon = callPackage ../development/libraries/libdaemon { };

  libdbi = callPackage ../development/libraries/libdbi { };

  libdbiDriversBase = callPackage ../development/libraries/libdbi-drivers {
    mysql = null;
    sqlite = null;
  };

  libdbiDrivers = libdbiDriversBase.override {
    inherit sqlite mysql;
  };

  libdbusmenu_qt = callPackage ../development/libraries/libdbusmenu-qt { };

  libdc1394 = callPackage ../development/libraries/libdc1394 { };

  libdc1394avt = callPackage ../development/libraries/libdc1394avt { };

  libdevil = callPackage ../development/libraries/libdevil { };

  libdiscid = callPackage ../development/libraries/libdiscid { };

  libdivsufsort = callPackage ../development/libraries/libdivsufsort { };

  libdmtx = callPackage ../development/libraries/libdmtx { };

  libdnet = callPackage ../development/libraries/libdnet { };

  libdrm = callPackage ../development/libraries/libdrm {
    inherit fetchurl stdenv pkgconfig;
    inherit (xorg) libpthreadstubs;
  };

  libdv = callPackage ../development/libraries/libdv { };

  libdvbpsi = callPackage ../development/libraries/libdvbpsi { };

  libdwg = callPackage ../development/libraries/libdwg { };

  libdvdcss = callPackage ../development/libraries/libdvdcss { };

  libdvdnav = callPackage ../development/libraries/libdvdnav { };

  libdvdread = callPackage ../development/libraries/libdvdread { };

  libdwarf = callPackage ../development/libraries/libdwarf { };

  libeatmydata = callPackage ../development/libraries/libeatmydata { };

  libebml = callPackage ../development/libraries/libebml { };

  libedit = callPackage ../development/libraries/libedit { };

  libelf = callPackage ../development/libraries/libelf { };

  libgadu = callPackage ../development/libraries/libgadu { };

  libgdata = (newScope gnome) ../development/libraries/libgdata {};
  libgdata_0_6 = (newScope gnome) ../development/libraries/libgdata/0.6.nix {};

  libgig = callPackage ../development/libraries/libgig { };

  libgnome_keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome_keyring3 = gnome3.libgnome_keyring;

  libsecret = callPackage ../development/libraries/libsecret { };

  libgtop = callPackage ../development/libraries/libgtop {};

  liblo = callPackage ../development/libraries/liblo { };

  liblrdf = librdf;

  liblscp = callPackage ../development/libraries/liblscp { };

  libev = builderDefsPackage ../development/libraries/libev { };

  libevent14 = callPackage ../development/libraries/libevent/1.4.nix { };
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

  libffcall = builderDefsPackage (import ../development/libraries/libffcall) {
    inherit fetchcvs;
  };

  libffi = callPackage ../development/libraries/libffi { };

  libftdi = callPackage ../development/libraries/libftdi { };

  libgcrypt = callPackage ../development/libraries/libgcrypt { };

  libgcrypt_git = lowPrio (callPackage ../development/libraries/libgcrypt/git.nix { });

  libgdiplus = callPackage ../development/libraries/libgdiplus { };

  libgpgerror = callPackage ../development/libraries/libgpg-error { };

  libgphoto2 = callPackage ../development/libraries/libgphoto2 { };

  libgphoto2_4 = callPackage ../development/libraries/libgphoto2/2.4.nix { };

  libgpod = callPackage ../development/libraries/libgpod {
    inherit (pkgs.pythonPackages) mutagen;
  };

  libharu = callPackage ../development/libraries/libharu { };

  libical = callPackage ../development/libraries/libical { };

  libicns = callPackage ../development/libraries/libicns { };

  libimobiledevice = callPackage ../development/libraries/libimobiledevice { };

  libiodbc = callPackage ../development/libraries/libiodbc {
    useGTK = config.libiodbc.gtk or false;
  };

  liblastfmSF = callPackage ../development/libraries/liblastfmSF { };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  liblqr1 = callPackage ../development/libraries/liblqr-1 { };

  liblockfile = callPackage ../development/libraries/liblockfile { };

  libmcrypt = callPackage ../development/libraries/libmcrypt {};

  libmhash = callPackage ../development/libraries/libmhash {};

  libmtp = callPackage ../development/libraries/libmtp { };

  libnatspec = callPackage ../development/libraries/libnatspec { };

  libnfsidmap = callPackage ../development/libraries/libnfsidmap { };

  libnice = callPackage ../development/libraries/libnice { };

  libplist = callPackage ../development/libraries/libplist { };

  libQGLViewer = callPackage ../development/libraries/libqglviewer { };

  libre = callPackage ../development/libraries/libre {};
  librem = callPackage ../development/libraries/librem {};

  libsamplerate = callPackage ../development/libraries/libsamplerate {
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  libspectre = callPackage ../development/libraries/libspectre { };

  libgsf = callPackage ../development/libraries/libgsf { };

  libiconv = callPackage ../development/libraries/libiconv { };

  libiconvOrEmpty = if libiconvOrNull == null then [] else [libiconv];

  libiconvOrNull =
    if gcc.libc or null != null || stdenv.isGlibc
    then null
    else libiconv;

  libiconvOrLibc = if libiconvOrNull == null then gcc.libc else libiconv;

  # On non-GNU systems we need GNU Gettext for libintl.
  libintlOrEmpty = stdenv.lib.optional (!stdenv.isLinux) gettext;

  libid3tag = callPackage ../development/libraries/libid3tag { };

  libidn = callPackage ../development/libraries/libidn { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libinfinity = callPackage ../development/libraries/libinfinity {
    inherit (gnome) gtkdoc;
  };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjpeg_original = callPackage ../development/libraries/libjpeg { };
  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };
  libjpeg = if (stdenv.isLinux) then libjpeg_turbo else libjpeg_original; # some problems, both on FreeBSD and Darwin

  libjpeg62 = callPackage ../development/libraries/libjpeg/62.nix {
    libtool = libtool_1_5;
  };

  libjson_rpc_cpp = callPackage ../development/libraries/libjson-rpc-cpp { };

  libkate = callPackage ../development/libraries/libkate { };

  libksba = callPackage ../development/libraries/libksba { };

  libmad = callPackage ../development/libraries/libmad { };

  libmatchbox = callPackage ../development/libraries/libmatchbox { };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmatroska = callPackage ../development/libraries/libmatroska { };

  libmcs = callPackage ../development/libraries/libmcs { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod {
    # resolve the "stray '@' in program" errors
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  libmilter = callPackage ../development/libraries/libmilter { };

  libmms = callPackage ../development/libraries/libmms { };

  libmowgli = callPackage ../development/libraries/libmowgli { };

  libmng = callPackage ../development/libraries/libmng { lcms = lcms2; };

  libmnl = callPackage ../development/libraries/libmnl { };

  libmodplug = callPackage ../development/libraries/libmodplug {};

  libmpcdec = callPackage ../development/libraries/libmpcdec { };

  libmrss = callPackage ../development/libraries/libmrss { };

  libmsn = callPackage ../development/libraries/libmsn { };

  libmspack = callPackage ../development/libraries/libmspack { };

  libmusclecard = callPackage ../development/libraries/libmusclecard { };

  libmusicbrainz2 = callPackage ../development/libraries/libmusicbrainz/2.x.nix { };

  libmusicbrainz3 = callPackage ../development/libraries/libmusicbrainz { };

  libmusicbrainz = libmusicbrainz3;

  libnet = callPackage ../development/libraries/libnet { };

  libnetfilter_conntrack = callPackage ../development/libraries/libnetfilter_conntrack { };

  libnetfilter_queue = callPackage ../development/libraries/libnetfilter_queue { };

  libnfnetlink = callPackage ../development/libraries/libnfnetlink { };

  libnih = callPackage ../development/libraries/libnih { };

  libnova = callPackage ../development/libraries/libnova { };

  libnxml = callPackage ../development/libraries/libnxml { };

  libofa = callPackage ../development/libraries/libofa { };

  libofx = callPackage ../development/libraries/libofx { };

  libogg = callPackage ../development/libraries/libogg { };

  liboggz = callPackage ../development/libraries/liboggz { };

  liboil = callPackage ../development/libraries/liboil { };

  liboop = callPackage ../development/libraries/liboop { };

  libopus = callPackage ../development/libraries/libopus { };

  libosip = callPackage ../development/libraries/osip {};

  libosip_3 = callPackage ../development/libraries/osip/3.nix {};

  libotr = callPackage ../development/libraries/libotr { };

  libotr_3_2 = callPackage ../development/libraries/libotr/3.2.nix { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpar2 = callPackage ../development/libraries/libpar2 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = libpng.override { apngSupport = true; };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };
  libpng15 = callPackage ../development/libraries/libpng/15.nix { };

  libpaper = callPackage ../development/libraries/libpaper { };

  libproxy = callPackage ../development/libraries/libproxy { };

  libpseudo = callPackage ../development/libraries/libpseudo { };

  libqalculate = callPackage ../development/libraries/libqalculate { };

  librsvg = callPackage ../development/libraries/librsvg {
    gtk2 = null; gtk3 = null; # neither gtk version by default
  };

  librsync = callPackage ../development/libraries/librsync { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsigsegv = callPackage ../development/libraries/libsigsegv { };

  # To bootstrap SBCL, I need CLisp 2.44.1; it needs libsigsegv 2.5
  libsigsegv_25 = callPackage ../development/libraries/libsigsegv/2.5.nix { };

  libsndfile = callPackage ../development/libraries/libsndfile {
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  libsodium = callPackage ../development/libraries/libsodium { };

  libsoup = callPackage ../development/libraries/libsoup { };
  libsoup_2_40 = callPackage ../development/libraries/libsoup/2.40.nix { };

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

  libspatialindex = callPackage ../development/libraries/libspatialindex { };

  libspatialite = callPackage ../development/libraries/libspatialite { };

  libtasn1 = callPackage ../development/libraries/libtasn1 { };

  libtheora = callPackage ../development/libraries/libtheora { };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtiger = callPackage ../development/libraries/libtiger { };

  libtommath = callPackage ../development/libraries/libtommath { };

  libtorrentRasterbar = callPackage ../development/libraries/libtorrent-rasterbar {
    # fix "unrecognized option -arch" error
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  libtoxcore = callPackage ../development/libraries/libtoxcore { };

  libtunepimp = callPackage ../development/libraries/libtunepimp { };

  libtxc_dxtn = callPackage ../development/libraries/libtxc_dxtn { };

  libgeotiff = callPackage ../development/libraries/libgeotiff { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  giflib = callPackage ../development/libraries/giflib { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libunibreak = callPackage ../development/libraries/libunibreak { };

  libunique = callPackage ../development/libraries/libunique/default.nix { };

  liburcu = callPackage ../development/libraries/liburcu { };

  libusb = callPackage ../development/libraries/libusb {
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  libusb1 = callPackage ../development/libraries/libusb1 {
    stdenv = if stdenv.isDarwin # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=50909
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  libunwind = callPackage ../development/libraries/libunwind { };

  libv4l = lowPrio (v4l_utils.override {
    withQt4 = false;
  });

  libva = callPackage ../development/libraries/libva { };

  libvdpau = callPackage ../development/libraries/libvdpau { };

  libvirt = callPackage ../development/libraries/libvirt { };

  libvisio = callPackage ../development/libraries/libvisio { };

  libvisual = callPackage ../development/libraries/libvisual { };

  libvncserver = callPackage ../development/libraries/libvncserver {};

  libviper = callPackage ../development/libraries/libviper { };

  libvpx = callPackage ../development/libraries/libvpx { };

  libvterm = callPackage ../development/libraries/libvterm { };

  libvorbis = callPackage ../development/libraries/libvorbis { };

  libwebp = callPackage ../development/libraries/libwebp { };

  libwmf = callPackage ../development/libraries/libwmf { };

  libwnck = callPackage ../development/libraries/libwnck { };
  libwnck3 = callPackage ../development/libraries/libwnck/3.x.nix { };

  libwpd = callPackage ../development/libraries/libwpd { };

  libwpd_08 = callPackage ../development/libraries/libwpd/0.8.nix { };

  libwpg = callPackage ../development/libraries/libwpg { };

  libx86 = builderDefsPackage ../development/libraries/libx86 {};

  libxdg_basedir = callPackage ../development/libraries/libxdg-basedir { };

  libxkbcommon = callPackage ../development/libraries/libxkbcommon { };

  libxklavier = callPackage ../development/libraries/libxklavier { };

  libxmi = callPackage ../development/libraries/libxmi { };

  libxml2 = callPackage ../development/libraries/libxml2 {
    pythonSupport = false;
  };

  libxml2Python = lowPrio (libxml2.override {
    pythonSupport = true;
  });

  libxmlxx = callPackage ../development/libraries/libxmlxx { };

  libxslt = callPackage ../development/libraries/libxslt { };

  libixp_for_wmii = lowPrio (import ../development/libraries/libixp_for_wmii {
    inherit fetchurl stdenv;
  });

  libyaml = callPackage ../development/libraries/libyaml { };

  libyamlcpp = callPackage ../development/libraries/libyaml-cpp { };
  libyamlcpp03 = callPackage ../development/libraries/libyaml-cpp/0.3.x.nix { };

  libzip = callPackage ../development/libraries/libzip { };

  libzrtpcpp = callPackage ../development/libraries/libzrtpcpp { };
  libzrtpcpp_1_6 = callPackage ../development/libraries/libzrtpcpp/1.6.nix {
    ccrtp = ccrtp_1_8;
  };

  lightning = callPackage ../development/libraries/lightning { };

  lirc = callPackage ../development/libraries/lirc { };

  liquidwar = builderDefsPackage ../games/liquidwar {
    inherit (xlibs) xproto libX11 libXrender;
    inherit gmp mesa libjpeg
      expat gettext perl
      SDL SDL_image SDL_mixer SDL_ttf
      curl sqlite
      libogg libvorbis
      ;
    guile = guile_1_8;
    libpng = libpng15; # 0.0.13 needs libpng 1.2--1.5
  };

  log4cpp = callPackage ../development/libraries/log4cpp { };

  log4cxx = callPackage ../development/libraries/log4cxx { };

  log4cplus = callPackage ../development/libraries/log4cplus { };

  loudmouth = callPackage ../development/libraries/loudmouth { };

  lzo = callPackage ../development/libraries/lzo { };

  mdds = callPackage ../development/libraries/mdds { };

  # failed to build
  mediastreamer = callPackage ../development/libraries/mediastreamer {
    ffmpeg = ffmpeg_1;
  };

  mesaSupported = lib.elem system lib.platforms.mesaPlatforms;

  mesa_original = callPackage ../development/libraries/mesa { };
  mesa_noglu = if stdenv.isDarwin
    then darwinX11AndOpenGL // { driverLink = mesa_noglu; }
    else mesa_original;
  mesa_drivers = mesa_original.drivers;
  mesa_glu = callPackage ../development/libraries/mesa-glu { };
  mesa = if stdenv.isDarwin then darwinX11AndOpenGL
    else buildEnv {
      name = "mesa-${mesa_noglu.version}";
      paths = [ mesa_glu mesa_noglu ];
    };
  darwinX11AndOpenGL = callPackage ../os-specific/darwin/native-x11-and-opengl { };

  metaEnvironment = recurseIntoAttrs (let callPackage = newScope pkgs.metaEnvironment; in rec {
    sdfLibrary    = callPackage ../development/libraries/sdf-library { aterm = aterm28; };
    toolbuslib    = callPackage ../development/libraries/toolbuslib { aterm = aterm28; inherit (windows) w32api; };
    cLibrary      = callPackage ../development/libraries/c-library { aterm = aterm28; };
    errorSupport  = callPackage ../development/libraries/error-support { aterm = aterm28; };
    ptSupport     = callPackage ../development/libraries/pt-support { aterm = aterm28; };
    ptableSupport = callPackage ../development/libraries/ptable-support { aterm = aterm28; };
    configSupport = callPackage ../development/libraries/config-support { aterm = aterm28; };
    asfSupport    = callPackage ../development/libraries/asf-support { aterm = aterm28; };
    tideSupport   = callPackage ../development/libraries/tide-support { aterm = aterm28; };
    rstoreSupport = callPackage ../development/libraries/rstore-support { aterm = aterm28; };
    sdfSupport    = callPackage ../development/libraries/sdf-support { aterm = aterm28; };
    sglr          = callPackage ../development/libraries/sglr { aterm = aterm28; };
    ascSupport    = callPackage ../development/libraries/asc-support { aterm = aterm28; };
    pgen          = callPackage ../development/libraries/pgen { aterm = aterm28; };
  });

  ming = callPackage ../development/libraries/ming { };

  minmay = callPackage ../development/libraries/minmay { };

  miro = callPackage ../applications/video/miro {
    inherit (pythonPackages) pywebkitgtk pysqlite pycurl mutagen;
  };

  mkvtoolnix = callPackage ../applications/video/mkvtoolnix { };

  mlt = callPackage ../development/libraries/mlt {
    ffmpeg = ffmpeg_1;
  };

  libmpeg2 = callPackage ../development/libraries/libmpeg2 { };

  mpeg2dec = libmpeg2;

  msilbc = callPackage ../development/libraries/msilbc { };

  mp4v2 = callPackage ../development/libraries/mp4v2 { };

  mpc = callPackage ../development/libraries/mpc { };

  mpich2 = callPackage ../development/libraries/mpich2 { };

  mtdev = callPackage ../development/libraries/mtdev { };

  mu = callPackage ../tools/networking/mu { };

  muparser = callPackage ../development/libraries/muparser { };

  mygui = callPackage ../development/libraries/mygui {};

  myguiSvn = callPackage ../development/libraries/mygui/svn.nix {};

  mysocketw = callPackage ../development/libraries/mysocketw { };

  mythes = callPackage ../development/libraries/mythes { };

  ncurses_5_4 = makeOverridable (import ../development/libraries/ncurses/5_4.nix) {
    inherit fetchurl;
    unicode = system != "i686-cygwin";
    stdenv = if stdenv.isDarwin
      then allStdenvs.stdenvNative
      else stdenv;
  };
  ncurses_5_9 = makeOverridable (import ../development/libraries/ncurses) {
    inherit fetchurl;
    unicode = system != "i686-cygwin";
    stdenv =
      # On Darwin, NCurses uses `-no-cpp-precomp', which is specific to
      # Apple-GCC.  Since NCurses is part of stdenv, always use
      # `stdenvNative' to build it.
      if stdenv.isDarwin
      then allStdenvs.stdenvNative
      else stdenv;
  };
  ncurses = ncurses_5_9;

  neon = callPackage ../development/libraries/neon {
    compressionSupport = true;
    sslSupport = true;
  };

  nethack = builderDefsPackage (import ../games/nethack) {
    inherit ncurses flex bison;
  };

  nettle = callPackage ../development/libraries/nettle { };

  newt = callPackage ../development/libraries/newt { };

  nspr = callPackage ../development/libraries/nspr { };

  nss = lowPrio (callPackage ../development/libraries/nss { });

  nssTools = callPackage ../development/libraries/nss {
    includeTools = true;
  };

  ntrack = callPackage ../development/libraries/ntrack { };

  ode = builderDefsPackage (import ../development/libraries/ode) { };

  ogre = callPackage ../development/libraries/ogre {};

  ogrepaged = callPackage ../development/libraries/ogrepaged { };

  oniguruma = callPackage ../development/libraries/oniguruma { };

  openal = callPackage ../development/libraries/openal { };

  # added because I hope that it has been easier to compile on x86 (for blender)
  openalSoft = callPackage ../development/libraries/openal-soft { };

  openbabel = callPackage ../development/libraries/openbabel { };

  opencascade = callPackage ../development/libraries/opencascade { };

  opencascade_6_5 = callPackage ../development/libraries/opencascade/6.5.nix {
    automake = automake111x;
    ftgl = ftgl212;
  };

  opencascade_oce = callPackage ../development/libraries/opencascade/oce.nix { };

  opencsg = callPackage ../development/libraries/opencsg { };

  openct = callPackage ../development/libraries/openct { };

  opencv = callPackage ../development/libraries/opencv {
    ffmpeg = ffmpeg_0_6_90;
  };

  opencv_2_1 = callPackage ../development/libraries/opencv/2.1.nix {
    ffmpeg = ffmpeg_0_6_90;
    libpng = libpng12;
  };

  # this ctl version is needed by openexr_viewers
  openexr_ctl = callPackage ../development/libraries/openexr_ctl { };

  openexr = callPackage ../development/libraries/openexr { };

  openldap = callPackage ../development/libraries/openldap { };

  openlierox = callPackage ../games/openlierox { };

  libopensc_dnie = callPackage ../development/libraries/libopensc-dnie {
    opensc = opensc_0_11_7;
  };

  opencolorio = callPackage ../development/libraries/opencolorio { };

  ois = callPackage ../development/libraries/ois {};

  opal = callPackage ../development/libraries/opal {};

  openjpeg = callPackage ../development/libraries/openjpeg { lcms = lcms2; };

  openscenegraph = callPackage ../development/libraries/openscenegraph {};

  openssl = callPackage ../development/libraries/openssl {
    fetchurl = fetchurlBoot;
    cryptodevHeaders = linuxPackages.cryptodev.override {
      fetchurl = fetchurlBoot;
      onlyHeaders = true;
    };
  };

  ortp = callPackage ../development/libraries/ortp {
    srtp = srtp_linphone;
  };

  p11_kit = callPackage ../development/libraries/p11-kit { };

  pangoxsl = callPackage ../development/libraries/pangoxsl { };

  pcl = callPackage ../development/libraries/pcl {
    vtk = vtkWithQt4;
  };

  pcre = callPackage ../development/libraries/pcre {
    unicodeSupport = config.pcre.unicode or true;
  };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  pdf2htmlex = callPackage ../development/libraries/pdf2htmlex {} ;

  phonon = callPackage ../development/libraries/phonon { };

  phonon_backend_gstreamer = callPackage ../development/libraries/phonon-backend-gstreamer { };

  phonon_backend_vlc = callPackage ../development/libraries/phonon-backend-vlc { };

  physfs = callPackage ../development/libraries/physfs { };

  pkcs11helper = callPackage ../development/libraries/pkcs11helper { };

  plib = callPackage ../development/libraries/plib { };

  pocketsphinx = callPackage ../development/libraries/pocketsphinx { };

  podofo = callPackage ../development/libraries/podofo { };

  polkit = callPackage ../development/libraries/polkit {
    spidermonkey = spidermonkey_185;
  };

  polkit_qt_1 = callPackage ../development/libraries/polkit-qt-1 { };

  policykit = callPackage ../development/libraries/policykit { };

  poppler = callPackage ../development/libraries/poppler { lcms = lcms2; };
  popplerQt4 = poppler.poppler_qt4;

  poppler_0_18 = callPackage ../development/libraries/poppler/0.18.nix {
    lcms = lcms2;
    glibSupport = true;
    gtk3Support = false;
    qt4Support  = false;
  };

  popt = callPackage ../development/libraries/popt { };

  portaudio = callPackage ../development/libraries/portaudio {
    # resolves a variety of compile-time errors
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  portaudioSVN = callPackage ../development/libraries/portaudio/svn-head.nix { };

  portmidi = callPackage ../development/libraries/portmidi {};

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  postgis = callPackage ../development/libraries/postgis { };

  protobuf = callPackage ../development/libraries/protobuf { };

  protobufc = callPackage ../development/libraries/protobufc { };

  pth = callPackage ../development/libraries/pth { };

  ptlib = callPackage ../development/libraries/ptlib {};

  re2 = callPackage ../development/libraries/re2 { };

  qca2 = callPackage ../development/libraries/qca2 {};

  qca2_ossl = callPackage ../development/libraries/qca2/ossl.nix {};

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
    inherit (pkgs.gnome) libgnomeui GConf gnome_vfs;
    cups = if stdenv.isLinux then cups else null;

    # resolve unrecognised flag '-fconstant-cfstrings' errors
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  qt48Full = qt48.override {
    docs = true;
    demos = true;
    examples = true;
    developerBuild = true;
  };

  qt4SDK = qtcreator.override {
    sdkBuild = true;
    qtLib = qt48Full;
  };

  qt5 = callPackage ../development/libraries/qt-5 {
    mesa = mesa_noglu;
    cups = if stdenv.isLinux then cups else null;
    # GNOME dependencies are not used unless gtkStyle == true
    inherit (gnome) libgnomeui GConf gnome_vfs;
  };

  qt5Full = qt5.override {
    buildDocs = true;
    buildExamples = true;
    buildTests = true;
    developerBuild = true;
  };

  qt5SDK = qtcreator.override {
    sdkBuild = true;
    qtLib = qt5Full;
  };

  qtcreator = callPackage ../development/qtcreator {
    qtLib = qt48.override { developerBuild = true; };
  };

  qtscriptgenerator = callPackage ../development/libraries/qtscriptgenerator { };

  quesoglc = callPackage ../development/libraries/quesoglc { };

  qwt = callPackage ../development/libraries/qwt {};

  readline = readline6;

  readline4 = callPackage ../development/libraries/readline/readline4.nix { };

  readline5 = callPackage ../development/libraries/readline/readline5.nix { };

  readline6 = callPackage ../development/libraries/readline/readline6.nix {
    stdenv =
      # On Darwin, Readline uses `-arch_only', which is specific to
      # Apple-GCC.  So give it what it expects.
      if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  librdf_raptor = callPackage ../development/libraries/librdf/raptor.nix { };

  librdf_raptor2 = callPackage ../development/libraries/librdf/raptor2.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf_redland = callPackage ../development/libraries/librdf/redland.nix { };

  librdf = callPackage ../development/libraries/librdf { };

  lilv = callPackage ../development/libraries/audio/lilv { };

  lv2 = callPackage ../development/libraries/audio/lv2 { };

  qrupdate = callPackage ../development/libraries/qrupdate { };

  redland = pkgs.librdf_redland;

  rhino = callPackage ../development/libraries/java/rhino {
    ant = apacheAntGcj;
    javac = gcj;
    jvm = gcj;
  };

  rlog = callPackage ../development/libraries/rlog { };

  rubberband = callPackage ../development/libraries/rubberband {
    fftw = fftwSinglePrec;
    inherit (vamp) vampSDK;
  };

  sbc = callPackage ../development/libraries/sbc { };

  schroedinger = callPackage ../development/libraries/schroedinger { };

  SDL = callPackage ../development/libraries/SDL {
    openglSupport = mesaSupported;
    alsaSupport = (!stdenv.isDarwin);
    x11Support = true;
    pulseaudioSupport = stdenv.isDarwin; # better go through ALSA

    # resolve the unrecognized -fpascal-strings option error
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  SDL_gfx = callPackage ../development/libraries/SDL_gfx { };

  SDL_image = callPackage ../development/libraries/SDL_image {
    # provide an Objective-C compiler
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  SDL_mixer = callPackage ../development/libraries/SDL_mixer { };

  SDL_net = callPackage ../development/libraries/SDL_net { };

  SDL_sound = callPackage ../development/libraries/SDL_sound { };

  SDL_ttf = callPackage ../development/libraries/SDL_ttf { };

  SDL2 = callPackage ../development/libraries/SDL2 {
    openglSupport = mesaSupported;
    alsaSupport = true;
    x11Support = true;
    pulseaudioSupport = false; # better go through ALSA
  };

  SDL2_image = callPackage ../development/libraries/SDL2_image { };

  SDL2_mixer = callPackage ../development/libraries/SDL2_mixer { };

  SDL2_gfx = callPackage ../development/libraries/SDL2_gfx { };

  serd = callPackage ../development/libraries/serd {};

  silgraphite = callPackage ../development/libraries/silgraphite {};
  graphite2 = callPackage ../development/libraries/silgraphite/graphite2.nix {};

  simgear = callPackage ../development/libraries/simgear { };

  sfml_git = callPackage ../development/libraries/sfml { };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
  };

  smpeg = callPackage ../development/libraries/smpeg { };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

  snappy = callPackage ../development/libraries/snappy { };

  sodium = callPackage ../development/libraries/sodium {};

  sofia_sip = callPackage ../development/libraries/sofia-sip { };

  soprano = callPackage ../development/libraries/soprano { };

  soqt = callPackage ../development/libraries/soqt { };

  sord = callPackage ../development/libraries/sord {};

  spandsp = callPackage ../development/libraries/spandsp {};

  speechd = callPackage ../development/libraries/speechd { };

  speech_tools = callPackage ../development/libraries/speech-tools {};

  speex = callPackage ../development/libraries/speex { };

  sphinxbase = callPackage ../development/libraries/sphinxbase { };

  spice = callPackage ../development/libraries/spice {
    celt = celt_0_5_1;
    inherit (xlibs) libXrandr libXfixes libXext libXrender libXinerama;
    inherit (pythonPackages) pyparsing;
  };

  spice_protocol = callPackage ../development/libraries/spice-protocol { };

  sratom = callPackage ../development/libraries/audio/sratom { };

  srtp = callPackage ../development/libraries/srtp {};

  srtp_linphone = callPackage ../development/libraries/srtp/linphone.nix { };

  sqlite = lowPrio (callPackage ../development/libraries/sqlite {
    readline = null;
    ncurses = null;
  });

  sqliteInteractive = appendToName "interactive" (sqlite.override {
    inherit readline ncurses;
  });

  stfl = callPackage ../development/libraries/stfl {
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  stlink = callPackage ../development/tools/misc/stlink { };

  stlport = callPackage ../development/libraries/stlport { };

  strigi = callPackage ../development/libraries/strigi { clucene_core = clucene_core_2; };

  suil = callPackage ../development/libraries/audio/suil { };

  suitesparse = callPackage ../development/libraries/suitesparse { };

  sword = callPackage ../development/libraries/sword { };

  szip = callPackage ../development/libraries/szip { };

  t1lib = callPackage ../development/libraries/t1lib { };

  taglib = callPackage ../development/libraries/taglib { };

  taglib_extras = callPackage ../development/libraries/taglib-extras { };

  talloc = callPackage ../development/libraries/talloc { };

  tclap = callPackage ../development/libraries/tclap {};

  tclgpg = callPackage ../development/libraries/tclgpg { };

  tcllib = callPackage ../development/libraries/tcllib { };

  tcltls = callPackage ../development/libraries/tcltls { };

  tdb = callPackage ../development/libraries/tdb { };

  tecla = callPackage ../development/libraries/tecla { };

  telepathy_glib = callPackage ../development/libraries/telepathy/glib { };

  telepathy_farstream = callPackage ../development/libraries/telepathy/farstream {};

  telepathy_qt = callPackage ../development/libraries/telepathy/qt { };

  tinyxml = tinyxml2;

  tinyxml2 = callPackage ../development/libraries/tinyxml/2.6.2.nix { };

  tk = callPackage ../development/libraries/tk {
    libX11 = xlibs.libX11;
  };

  tnt = callPackage ../development/libraries/tnt { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };
  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  tremor = callPackage ../development/libraries/tremor { };

  unicap = callPackage ../development/libraries/unicap {};

  tsocks = callPackage ../development/libraries/tsocks { };

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (import ../development/libraries/unixODBCDrivers {
    inherit fetchurl stdenv unixODBC glibc libtool openssl zlib;
    inherit postgresql mysql sqlite;
  });

  urt = callPackage ../development/libraries/urt { };

  ustr = callPackage ../development/libraries/ustr { };

  ucommon = callPackage ../development/libraries/ucommon { };

  vaapiIntel = callPackage ../development/libraries/vaapi-intel { };

  vaapiVdpau = callPackage ../development/libraries/vaapi-vdpau { };

  vamp = callPackage ../development/libraries/audio/vamp { };

  vcdimager = callPackage ../development/libraries/vcdimager { };

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

  wayland = callPackage ../development/libraries/wayland { };

  webkit =
    builderDefsPackage ../development/libraries/webkit {
      inherit gtk2; # for plugins etc. even with gtk3, see Gentoo ebuild
      inherit gtk3 glib atk cairo pango fontconfig freetype;
      inherit (gnome) gtkdoc libsoup;
      inherit pkgconfig libtool intltool autoconf automake gperf bison flex
        libjpeg libpng libtiff libxml2 libxslt sqlite icu curl
        which libproxy geoclue enchant python ruby perl mesa xlibs;
      inherit gstreamer gst_plugins_base gst_ffmpeg gst_plugins_good;
    };

  webkit_gtk2 =
    builderDefsPackage ../development/libraries/webkit/gtk2.nix {
      inherit gtk2 glib atk cairo pango fontconfig freetype;
      inherit (gnome) gtkdoc libsoup;
      inherit pkgconfig libtool intltool autoconf automake gperf bison flex
        libjpeg libpng libtiff libxml2 libxslt sqlite icu curl
        which libproxy geoclue enchant python ruby perl mesa xlibs;
      inherit gstreamer gst_plugins_base gst_ffmpeg gst_plugins_good;
    };

  wildmidi = callPackage ../development/libraries/wildmidi { };

  wvstreams = callPackage ../development/libraries/wvstreams { };

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxGTK-2.8 {
    inherit (gnome) GConf;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxGTK29 = callPackage ../development/libraries/wxGTK-2.9/default.nix {
    inherit (gnome) GConf;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;

    # use for Objective-C++ compiler
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  wtk = callPackage ../development/libraries/wtk { };

  x264 = callPackage ../development/libraries/x264 { };

  xapian = callPackage ../development/libraries/xapian { };

  xapianBindings = callPackage ../development/libraries/xapian/bindings {  # TODO perl php Java, tcl, C#, python
  };

  xapian10 = callPackage ../development/libraries/xapian/1.0.x.nix { };

  xapianBindings10 = callPackage ../development/libraries/xapian/bindings/1.0.x.nix {  # TODO perl php Java, tcl, C#, python
  };

  Xaw3d = callPackage ../development/libraries/Xaw3d { };

  xbase = callPackage ../development/libraries/xbase { };

  xineLib = callPackage ../development/libraries/xine-lib { };

  xautolock = callPackage ../misc/screensavers/xautolock { };

  xercesc = callPackage ../development/libraries/xercesc {};

  xercesJava = callPackage ../development/libraries/java/xerces {
    ant   = apacheAntGcj;  # for bootstrap purposes
    javac = gcj;
    jvm   = gcj;
  };

  xlibsWrapper = callPackage ../development/libraries/xlibs-wrapper {
    packages = [
      freetype fontconfig xlibs.xproto xlibs.libX11 xlibs.libXt
      xlibs.libXft xlibs.libXext xlibs.libSM xlibs.libICE
      xlibs.xextproto
    ];
  };

  xmlrpc_c = callPackage ../development/libraries/xmlrpc-c { };

  xvidcore = callPackage ../development/libraries/xvidcore { };

  yajl = callPackage ../development/libraries/yajl { };

  zangband = builderDefsPackage (import ../games/zangband) {
    inherit ncurses flex bison autoconf automake m4 coreutils;
  };

  zlib = callPackage ../development/libraries/zlib {
    fetchurl = fetchurlBoot;
  };

  zlibStatic = lowPrio (appendToName "static" (callPackage ../development/libraries/zlib {
    static = true;
  }));

  zeromq2 = callPackage ../development/libraries/zeromq/2.x.nix {};
  zeromq3 = callPackage ../development/libraries/zeromq/3.x.nix {};


  ### DEVELOPMENT / LIBRARIES / JAVA

  atermjava = callPackage ../development/libraries/java/aterm {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  commonsFileUpload = callPackage ../development/libraries/java/jakarta-commons/file-upload { };

  fastjar = callPackage ../development/tools/java/fastjar { };

  httpunit = callPackage ../development/libraries/java/httpunit { };

  gwtdragdrop = callPackage ../development/libraries/java/gwt-dragdrop { };

  gwtwidgets = callPackage ../development/libraries/java/gwt-widgets { };

  jakartabcel = callPackage ../development/libraries/java/jakarta-bcel {
    regexp = jakartaregexp;
  };

  jakartaregexp = callPackage ../development/libraries/java/jakarta-regexp { };

  javaCup = callPackage ../development/libraries/java/cup { };

  javasvn = callPackage ../development/libraries/java/javasvn { };

  jclasslib = callPackage ../development/tools/java/jclasslib { };

  jdom = callPackage ../development/libraries/java/jdom { };

  jflex = callPackage ../development/libraries/java/jflex { };

  jjtraveler = callPackage ../development/libraries/java/jjtraveler {
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  junit = callPackage ../development/libraries/java/junit { };

  jzmq = callPackage ../development/libraries/java/jzmq { };

  lucene = callPackage ../development/libraries/java/lucene { };

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

  v8 = callPackage ../development/libraries/v8 { inherit (pythonPackages) gyp; };

  xalanj = xalanJava;
  xalanJava = callPackage ../development/libraries/java/xalanj {
    ant    = apacheAntGcj;  # for bootstrap purposes
    javac  = gcj;
    jvm    = gcj;
    xerces = xercesJava;  };

  xmlsec = callPackage ../development/libraries/xmlsec { };

  zziplib = callPackage ../development/libraries/zziplib { };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  jquery_ui = callPackage ../development/libraries/javascript/jquery-ui { };

  ### DEVELOPMENT / LISP MODULES

  asdf = callPackage ../development/lisp-modules/asdf {};
  clwrapperFunction = callPackage ../development/lisp-modules/clwrapper;
  wrapLisp = lisp: clwrapperFunction {lisp=lisp;};
  lispPackagesFor = clwrapper: callPackage ../development/lisp-modules/lisp-packages.nix{
    inherit clwrapper;
  };
  lispPackagesClisp = lispPackagesFor (wrapLisp clisp);
  lispPackagesSBCL = lispPackagesFor (wrapLisp sbcl);
  lispPackages = recurseIntoAttrs lispPackagesSBCL;

  ### DEVELOPMENT / PERL MODULES

  buildPerlPackage = import ../development/perl-modules/generic perl;

  perlPackages = recurseIntoAttrs (import ./perl-packages.nix {
    inherit pkgs;
    __overrides = (config.perlPackageOverrides or (p: {})) pkgs;
  });

  perl510Packages = import ./perl-packages.nix {
    pkgs = pkgs // {
      perl = perl510;
      buildPerlPackage = import ../development/perl-modules/generic perl510;
    };
    __overrides = (config.perl510PackageOverrides or (p: {})) pkgs;
  };

  perl514Packages = import ./perl-packages.nix {
    pkgs = pkgs // {
      perl = perl514;
      buildPerlPackage = import ../development/perl-modules/generic perl514;
    };
    __overrides = (config.perl514PackageOverrides or (p: {})) pkgs;
  };

  perlXMLParser = perlPackages.XMLParser;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;


  ### DEVELOPMENT / PYTHON MODULES

  # python function with default python interpreter
  buildPythonPackage = pythonPackages.buildPythonPackage;

  pythonPackages = python27Packages;

  # `nix-env -i python-nose` installs for 2.7, the default python.
  # Therefore we do not recurse into attributes here, in contrast to
  # python27Packages. `nix-env -iA python26Packages.nose` works
  # regardless.
  python26Packages = import ./python-packages.nix {
    inherit pkgs;
    inherit (lib) lowPrio;
    python = python26;
  };

  python3Packages = python33Packages;

  python33Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    inherit (lib) lowPrio;
    python = python33;
  });

  python32Packages = import ./python-packages.nix {
    inherit pkgs;
    inherit (lib) lowPrio;
    python = python32;
  };

  python27Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    inherit (lib) lowPrio;
    python = python27;
  });

  pypyPackages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    inherit (lib) lowPrio;
    python = pypy;
  });

  foursuite = callPackage ../development/python-modules/4suite { };

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  numeric = callPackage ../development/python-modules/numeric { };

  pil = pythonPackages.pil;

  psyco = callPackage ../development/python-modules/psyco { };

  pycairo = pythonPackages.pycairo;

  pycrypto = pythonPackages.pycrypto;

  pycups = callPackage ../development/python-modules/pycups { };

  pyexiv2 = callPackage ../development/python-modules/pyexiv2 { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygobject = pythonPackages.pygobject;

  pygobject3 = pythonPackages.pygobject3;

  pygtk = pythonPackages.pygtk;

  pyGtkGlade = pythonPackages.pyGtkGlade;

  pylint = callPackage ../development/python-modules/pylint { };

  pyopenssl = builderDefsPackage (import ../development/python-modules/pyopenssl) {
    inherit python openssl;
  };

  rhpl = callPackage ../development/python-modules/rhpl { };

  sip = callPackage ../development/python-modules/python-sip { };

  pyqt4 = callPackage ../development/python-modules/pyqt {
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  pysideApiextractor = callPackage ../development/python-modules/pyside/apiextractor.nix { };

  pysideGeneratorrunner = callPackage ../development/python-modules/pyside/generatorrunner.nix { };

  pyside = callPackage ../development/python-modules/pyside { };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix { };

  pyx = callPackage ../development/python-modules/pyx { };

  pyxml = callPackage ../development/python-modules/pyxml { };

  rbtools = callPackage ../development/python-modules/rbtools { };

  setuptools = pythonPackages.setuptools;

  wxPython = pythonPackages.wxPython;
  wxPython28 = pythonPackages.wxPython28;

  twisted = pythonPackages.twisted;

  ZopeInterface = pythonPackages.zope_interface;

  ### DEVELOPMENT / R MODULES

  buildRPackage = import ../development/r-modules/generic R;

  rPackages = recurseIntoAttrs (import ./r-packages.nix {
    inherit pkgs;
    __overrides = (config.rPackageOverrides or (p: {})) pkgs;
  });

  ### SERVERS

  rdf4store = callPackage ../servers/http/4store { };

  apacheHttpd = pkgs.apacheHttpd_2_2;

  apacheHttpd_2_2 = callPackage ../servers/http/apache-httpd/2.2.nix {
    sslSupport = true;
  };

  apacheHttpd_2_4 = lowPrio (callPackage ../servers/http/apache-httpd/2.4.nix {
    sslSupport = true;
  });

  apcupsd = callPackage ../servers/apcupsd { };

  sabnzbd = callPackage ../servers/sabnzbd { };

  bind = callPackage ../servers/dns/bind { };

  bird = callPackage ../servers/bird { };

  couchdb = callPackage ../servers/http/couchdb {
    spidermonkey = spidermonkey_185;
  };

  dico = callPackage ../servers/dico { };

  dict = callPackage ../servers/dict { };

  dictdDBs = recurseIntoAttrs (import ../servers/dict/dictd-db.nix {
    inherit builderDefs;
  });

  dictDBCollector = import ../servers/dict/dictd-db-collector.nix {
    inherit stdenv lib dict;
  };

  dictdWiktionary = callPackage ../servers/dict/dictd-wiktionary.nix {};

  dictdWordnet = callPackage ../servers/dict/dictd-wordnet.nix {};

  diod = callPackage ../servers/diod { };

  dovecot = dovecot21;

  dovecot21 = callPackage ../servers/mail/dovecot { };

  dovecot22 = callPackage ../servers/mail/dovecot/2.2.x.nix { };

  dovecot_pigeonhole = callPackage ../servers/mail/dovecot-pigeonhole { };

  ejabberd = callPackage ../servers/xmpp/ejabberd { };

  elasticmq = callPackage ../servers/elasticmq { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { icu = null; };
  firebirdSuper = callPackage ../servers/firebird { superServer = true; };

  freepops = callPackage ../servers/mail/freepops { };

  freeswitch = callPackage ../servers/sip/freeswitch { };

  ghostOne = callPackage ../servers/games/ghost-one {
    boost = boost144.override { taggedLayout = true; };
  };

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  jetty = callPackage ../servers/http/jetty { };

  jetty61 = callPackage ../servers/http/jetty/6.1 { };

  joseki = callPackage ../servers/http/joseki {};

  lighttpd = callPackage ../servers/http/lighttpd { };

  mailman = callPackage ../servers/mail/mailman { };

  mediatomb = callPackage ../servers/mediatomb {
    ffmpeg = ffmpeg_0_6_90;
  };

  memcached = callPackage ../servers/memcached {};

  mod_evasive = callPackage ../servers/http/apache-modules/mod_evasive { };

  mod_python = callPackage ../servers/http/apache-modules/mod_python { };

  mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

  mod_wsgi = callPackage ../servers/http/apache-modules/mod_wsgi { };

  mpd = callPackage ../servers/mpd {
    # resolve the "stray '@' in program" errors
    stdenv = if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  mpd_clientlib = callPackage ../servers/mpd/clientlib.nix { };

  miniHttpd = callPackage ../servers/http/mini-httpd {};

  myserver = callPackage ../servers/http/myserver { };

  nginx = callPackage ../servers/http/nginx { };

  opensmtpd = callPackage ../servers/mail/opensmtpd { };

  petidomo = callPackage ../servers/mail/petidomo { };

  popa3d = callPackage ../servers/mail/popa3d { };

  postfix = callPackage ../servers/mail/postfix { };

  pulseaudio = callPackage ../servers/pulseaudio {
    gconf = gnome.GConf;
    # The following are disabled in the default build, because if this
    # functionality is desired, they are only needed in the PulseAudio
    # server.
    bluez = null;
    avahi = null;
  };

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  pies = callPackage ../servers/pies { };

  portmap = callPackage ../servers/portmap { };

  rpcbind = callPackage ../servers/rpcbind { };

  #monetdb = callPackage ../servers/sql/monetdb { };

  mongodb = callPackage ../servers/nosql/mongodb { };

  riak = callPackage ../servers/nosql/riak/1.3.1.nix { };

  mysql51 = import ../servers/sql/mysql/5.1.x.nix {
    inherit fetchurl ncurses zlib perl openssl stdenv;
    ps = procps; /* !!! Linux only */
  };

  mysql55 = callPackage ../servers/sql/mysql/5.5.x.nix { };

  mysql = mysql51;

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  nagios = callPackage ../servers/monitoring/nagios {
    gdSupport = true;
  };

  munin = callPackage ../servers/monitoring/munin { };

  nagiosPluginsOfficial = callPackage ../servers/monitoring/nagios/plugins/official { };

  net_snmp = callPackage ../servers/monitoring/net-snmp { };

  oidentd = callPackage ../servers/identd/oidentd { };

  openfire = callPackage ../servers/xmpp/openfire { };

  oracleXE = callPackage ../servers/sql/oracle-xe { };

  OVMF = callPackage ../applications/virtualization/OVMF { };

  postgresql = postgresql92;

  postgresql83 = callPackage ../servers/sql/postgresql/8.3.x.nix { };

  postgresql84 = callPackage ../servers/sql/postgresql/8.4.x.nix { };

  postgresql90 = callPackage ../servers/sql/postgresql/9.0.x.nix { };

  postgresql91 = callPackage ../servers/sql/postgresql/9.1.x.nix { };

  postgresql92 = callPackage ../servers/sql/postgresql/9.2.x.nix { };

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  psqlodbc = callPackage ../servers/sql/postgresql/psqlodbc { };

  pyIRCt = builderDefsPackage (import ../servers/xmpp/pyIRCt) {
    inherit xmpppy pythonIRClib python makeWrapper;
  };

  pyMAILt = builderDefsPackage (import ../servers/xmpp/pyMAILt) {
    inherit xmpppy python makeWrapper fetchcvs;
  };

  qpid-cpp = callPackage ../servers/amqp/qpid-cpp { };

  rabbitmq_server = callPackage ../servers/amqp/rabbitmq-server { };

  radius = callPackage ../servers/radius { };

  redis = callPackage ../servers/nosql/redis {
    stdenv =
      if stdenv.isDarwin
      then overrideGCC stdenv gccApple
      else stdenv;
  };

  redstore = callPackage ../servers/http/redstore { };

  restund = callPackage ../servers/restund {};

  spamassassin = callPackage ../servers/mail/spamassassin {
    inherit (perlPackages) HTMLParser NetDNS NetAddrIP DBFile
      HTTPDate MailDKIM LWP IOSocketSSL;
  };

  samba = callPackage ../servers/samba { };

  # A lightweight Samba, useful for non-Linux-based OSes.
  samba_light = lowPrio (callPackage ../servers/samba {
    pam = null;
    fam = null;
    cups = null;
    acl = null;
    openldap = null;
    # libunwind 1.0.1 is not ported to GNU/Hurd.
    libunwind = null;
  });

  shishi = callPackage ../servers/shishi { };

  sipwitch = callPackage ../servers/sip/sipwitch { };

  squids = recurseIntoAttrs( import ../servers/squid/squids.nix {
    inherit fetchurl stdenv perl lib composableDerivation
      openldap pam db4 cyrus_sasl kerberos libcap expat libxml2 libtool
      openssl;
  });
  squid = squids.squid31; # has ipv6 support

  thttpd = callPackage ../servers/http/thttpd { };

  storm = callPackage ../servers/computing/storm { };

  tomcat5 = callPackage ../servers/http/tomcat/5.0.nix { };

  tomcat6 = callPackage ../servers/http/tomcat/6.0.nix { };

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  virtuoso6 = callPackage ../servers/sql/virtuoso/6.x.nix { };

  virtuoso7 = callPackage ../servers/sql/virtuoso/7.x.nix { };

  virtuoso = virtuoso6;

  vsftpd = callPackage ../servers/ftp/vsftpd { };

  xinetd = callPackage ../servers/xinetd { };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg/default.nix {
    inherit fetchurl fetchgit stdenv pkgconfig intltool freetype fontconfig
      libxslt expat libdrm libpng zlib perl mesa_drivers
      xkeyboard_config dbus libuuid openssl gperf m4
      autoconf libtool xmlto asciidoc udev flex bison python mtdev pixman;
    automake = automake110x;
    mesa = mesa_noglu;
  });

  xorgReplacements = callPackage ../servers/x11/xorg/replacements.nix { };

  xorgVideoUnichrome = callPackage ../servers/x11/xorg/unichrome/default.nix { };

  yaws = callPackage ../servers/http/yaws { };

  zabbix = recurseIntoAttrs (import ../servers/monitoring/zabbix {
    inherit fetchurl stdenv pkgconfig postgresql curl openssl zlib;
  });

  zabbix20 = callPackage ../servers/monitoring/zabbix/2.0.nix { };


  ### OS-SPECIFIC

  afuse = callPackage ../os-specific/linux/afuse { };

  amdUcode = callPackage ../os-specific/linux/microcode/amd.nix { };

  autofs5 = callPackage ../os-specific/linux/autofs/autofs-v5.nix { };

  _915resolution = callPackage ../os-specific/linux/915resolution { };

  nfsUtils = callPackage ../os-specific/linux/nfs-utils { };

  acpi = callPackage ../os-specific/linux/acpi { };

  acpid = callPackage ../os-specific/linux/acpid { };

  acpitool = callPackage ../os-specific/linux/acpitool { };

  alsaLib = callPackage ../os-specific/linux/alsa-lib { };

  alsaPlugins = callPackage ../os-specific/linux/alsa-plugins {
    jackaudio = null;
  };

  alsaPluginWrapper = callPackage ../os-specific/linux/alsa-plugins/wrapper.nix { };

  alsaUtils = callPackage ../os-specific/linux/alsa-utils { };
  alsaOss = callPackage ../os-specific/linux/alsa-oss { };

  microcode2ucode = callPackage ../os-specific/linux/microcode/converter.nix { };

  microcodeIntel = callPackage ../os-specific/linux/microcode/intel.nix { };

  apparmor = callPackage ../os-specific/linux/apparmor {
    inherit (perlPackages) LocaleGettext TermReadKey RpcXML;
  };

  atop = callPackage ../os-specific/linux/atop { };

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  batctl = callPackage ../os-specific/linux/batman-adv/batctl.nix { };

  bluez4 = callPackage ../os-specific/linux/bluez {
    pygobject = pygobject3;
  };

  bluez5 = lowPrio (callPackage ../os-specific/linux/bluez/bluez5.nix { });

  bluez = bluez4;

  beret = callPackage ../games/beret { };

  bridge_utils = callPackage ../os-specific/linux/bridge-utils { };

  busybox = callPackage ../os-specific/linux/busybox { };

  checkpolicy = callPackage ../os-specific/linux/checkpolicy { };

  cifs_utils = callPackage ../os-specific/linux/cifs-utils { };

  conky = callPackage ../os-specific/linux/conky { };

  cpufrequtils = callPackage ../os-specific/linux/cpufrequtils { };

  cryopid = callPackage ../os-specific/linux/cryopid { };

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  cramfsswap = callPackage ../os-specific/linux/cramfsswap { };

  devicemapper = lvm2;

  dmidecode = callPackage ../os-specific/linux/dmidecode { };

  dmtcp = callPackage ../os-specific/linux/dmtcp { };

  dietlibc = callPackage ../os-specific/linux/dietlibc { };

  directvnc = builderDefsPackage ../os-specific/linux/directvnc {
    inherit libjpeg pkgconfig zlib directfb;
    inherit (xlibs) xproto;
  };

  dmraid = callPackage ../os-specific/linux/dmraid { };

  drbd = callPackage ../os-specific/linux/drbd { };

  dstat = callPackage ../os-specific/linux/dstat {
    # pythonFull includes the "curses" standard library module, for pretty
    # dstat color output
    python = pythonFull;
  };

  libuuid =
    if crossSystem != null && crossSystem.config == "i586-pc-gnu"
    then (utillinux // {
      crossDrv = lib.overrideDerivation utillinux.crossDrv (args: {
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
    then utillinux
    else null;

  e3cfsprogs = callPackage ../os-specific/linux/e3cfsprogs { };

  ebtables = callPackage ../os-specific/linux/ebtables { };

  eject = utillinux;

  ffado = callPackage ../os-specific/linux/ffado { };

  fbterm = callPackage ../os-specific/linux/fbterm { };

  fuse = callPackage ../os-specific/linux/fuse { };

  fxload = callPackage ../os-specific/linux/fxload { };

  gfxtablet = callPackage ../os-specific/linux/gfxtablet {};

  gpm = callPackage ../servers/gpm { };

  hdparm = callPackage ../os-specific/linux/hdparm { };

  hibernate = callPackage ../os-specific/linux/hibernate { };

  hostapd = callPackage ../os-specific/linux/hostapd { };

  htop = callPackage ../os-specific/linux/htop { };

  # GNU/Hurd core packages.
  gnu = recurseIntoAttrs (callPackage ../os-specific/gnu {
    inherit platform crossSystem;
  });

  hwdata = callPackage ../os-specific/linux/hwdata { };

  i7z = callPackage ../os-specific/linux/i7z { };

  ifplugd = callPackage ../os-specific/linux/ifplugd { };

  iotop = callPackage ../os-specific/linux/iotop { };

  iproute = callPackage ../os-specific/linux/iproute { };

  iputils = callPackage ../os-specific/linux/iputils {
    sp = spCompat;
    inherit (perlPackages) SGMLSpm;
  };

  iptables = callPackage ../os-specific/linux/iptables { };

  iw = callPackage ../os-specific/linux/iw { };

  jujuutils = callPackage ../os-specific/linux/jujuutils { };

  kbd = callPackage ../os-specific/linux/kbd { };

  latencytop = callPackage ../os-specific/linux/latencytop { };

  ldm = callPackage ../os-specific/linux/ldm { };

  libaio = callPackage ../os-specific/linux/libaio { };

  libatasmart = callPackage ../os-specific/linux/libatasmart { };

  libcgroup = callPackage ../os-specific/linux/libcgroup { };

  libnl = callPackage ../os-specific/linux/libnl { };

  linuxHeaders = linuxHeaders37;

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  linuxHeaders26 = callPackage ../os-specific/linux/kernel-headers/2.6.32.nix { };

  linuxHeaders37 = callPackage ../os-specific/linux/kernel-headers/3.7.nix { };

  linuxHeaders26Cross = forceNativeDrv (import ../os-specific/linux/kernel-headers/2.6.32.nix {
    inherit stdenv fetchurl perl;
    cross = assert crossSystem != null; crossSystem;
  });

  linuxHeaders24Cross = forceNativeDrv (import ../os-specific/linux/kernel-headers/2.4.nix {
    inherit stdenv fetchurl perl;
    cross = assert crossSystem != null; crossSystem;
  });

  # We can choose:
  linuxHeadersCrossChooser = ver : if ver == "2.4" then linuxHeaders24Cross
    else if ver == "2.6" then linuxHeaders26Cross
    else throw "Unknown linux kernel version";

  linuxHeadersCross = assert crossSystem != null;
    linuxHeadersCrossChooser crossSystem.platform.kernelMajor;

  linuxHeaders_2_6_28 = callPackage ../os-specific/linux/kernel-headers/2.6.28.nix { };

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  linux_3_2 = makeOverridable (import ../os-specific/linux/kernel/linux-3.2.nix) {
    inherit fetchurl stdenv perl mktemp bc kmod ubootChooser;
    kernelPatches =
      [ kernelPatches.sec_perm_2_6_24
        # kernelPatches.aufs3_2
      ];
  };

  # Note: grsec is not enabled automatically, you need to specify which kernel
  # config options you need (e.g. by overriding extraConfig). See list of options here:
  # https://en.wikibooks.org/wiki/Grsecurity/Appendix/Grsecurity_and_PaX_Configuration_Options
  linux_3_2_grsecurity = lowPrio (lib.overrideDerivation (linux_3_2.override (args: {
    kernelPatches = args.kernelPatches ++ [ kernelPatches.grsecurity_2_9_1_3_2_52 ];
  })) (args: {
    # Install gcc plugins. These are needed for compiling dependant packages.
    postInstall = ''
      ${args.postInstall or ""}
      cp tools/gcc/*.so $out/lib/modules/$version/build/tools/gcc/
    '';
    # Apparently as of gcc 4.6, gcc-plugin headers (which are needed by PaX plugins)
    # include libgmp headers, so we need these extra tweaks
    buildInputs = args.buildInputs ++ [ gmp ];
    preConfigure = ''
      ${args.preConfigure or ""}
      sed -i 's|-I|-I${gmp}/include -I|' scripts/gcc-plugin.sh
      sed -i 's|HOST_EXTRACFLAGS +=|HOST_EXTRACFLAGS += -I${gmp}/include|' tools/gcc/Makefile
      sed -i 's|HOST_EXTRACXXFLAGS +=|HOST_EXTRACXXFLAGS += -I${gmp}/include|' tools/gcc/Makefile
    '';
  }));

  linux_3_2_apparmor = lowPrio (linux_3_2.override {
    kernelPatches = [ kernelPatches.apparmor_3_2 ];
    extraConfig = ''
      SECURITY_APPARMOR y
      DEFAULT_SECURITY_APPARMOR y
    '';
  });

  linux_3_2_xen = lowPrio (linux_3_2.override {
    extraConfig = ''
      XEN_DOM0 y
    '';
  });

  linux_3_4 = makeOverridable (import ../os-specific/linux/kernel/linux-3.4.nix) {
    inherit fetchurl stdenv perl mktemp bc kmod ubootChooser;
    kernelPatches =
      [ kernelPatches.sec_perm_2_6_24
        # kernelPatches.aufs3_4
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
      ];
  };

  linux_3_4_apparmor = lowPrio (linux_3_4.override {
    kernelPatches = [ kernelPatches.apparmor_3_4 ];
    extraConfig = ''
      SECURITY_APPARMOR y
      DEFAULT_SECURITY_APPARMOR y
    '';
  });

  linux_3_6_rpi = makeOverridable (import ../os-specific/linux/kernel/linux-rpi-3.6.nix) {
    inherit fetchurl stdenv perl mktemp bc kmod ubootChooser;
  };

  linux_3_10 = makeOverridable (import ../os-specific/linux/kernel/linux-3.10.nix) {
    inherit fetchurl stdenv perl mktemp bc kmod ubootChooser;
    kernelPatches =
      [
        kernelPatches.sec_perm_2_6_24
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_11 = makeOverridable (import ../os-specific/linux/kernel/linux-3.11.nix) {
    inherit fetchurl stdenv perl mktemp bc kmod ubootChooser;
    kernelPatches =
      [
        kernelPatches.sec_perm_2_6_24
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_12 = makeOverridable (import ../os-specific/linux/kernel/linux-3.12.nix) {
    inherit fetchurl stdenv perl mktemp bc kmod ubootChooser;
    kernelPatches =
      [
        kernelPatches.sec_perm_2_6_24
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };


  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: self: let callPackage = newScope self; in {
    inherit kernel;

    kernelDev = kernel.dev or kernel;

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    aufs =
      if self.kernel.features ? aufs2 then
        callPackage ../os-specific/linux/aufs/2.nix { }
      else if self.kernel.features ? aufs3 then
        callPackage ../os-specific/linux/aufs/3.nix { }
      else null;

    aufs_util =
      if self.kernel.features ? aufs2 then
        callPackage ../os-specific/linux/aufs-util/2.nix { }
      else if self.kernel.features ? aufs3 then
        callPackage ../os-specific/linux/aufs-util/3.nix { }
      else null;

    blcr = callPackage ../os-specific/linux/blcr { };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    e1000e = callPackage ../os-specific/linux/e1000e {};

    exmap = callPackage ../os-specific/linux/exmap { };

    frandom = callPackage ../os-specific/linux/frandom { };

    iscsitarget = callPackage ../os-specific/linux/iscsitarget { };

    iwlwifi = callPackage ../os-specific/linux/iwlwifi { };

    lttngModules = callPackage ../os-specific/linux/lttng-modules { };

    atheros = callPackage ../os-specific/linux/atheros/0.9.4.nix { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta/default.nix { };

    broadcom_sta6 = callPackage ../os-specific/linux/broadcom-sta-v6/default.nix { };

    nvidia_x11 = callPackage ../os-specific/linux/nvidia-x11 { };

    nvidia_x11_legacy96 = callPackage ../os-specific/linux/nvidia-x11/legacy96.nix { };
    nvidia_x11_legacy173 = callPackage ../os-specific/linux/nvidia-x11/legacy173.nix { };
    nvidia_x11_legacy304 = callPackage ../os-specific/linux/nvidia-x11/legacy304.nix { };

    openafsClient = callPackage ../servers/openafs-client { };

    openiscsi = callPackage ../os-specific/linux/open-iscsi { };

    wis_go7007 = callPackage ../os-specific/linux/wis-go7007 { };

    klibc = callPackage ../os-specific/linux/klibc {
      linuxHeaders = glibc.kernelHeaders;
    };

    /* compiles but has to be integrated into the kernel somehow
       Let's have it uncommented and finish it..
    */
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    netatop = callPackage ../os-specific/linux/netatop { };

    perf = callPackage ../os-specific/linux/kernel/perf.nix { };

    psmouse_alps = callPackage ../os-specific/linux/psmouse-alps { };

    spl = callPackage ../os-specific/linux/spl/default.nix { };

    sysprof = callPackage ../development/tools/profiling/sysprof {
      inherit (gnome) libglade;
    };

    systemtap = callPackage ../development/tools/profiling/systemtap {
      linux = self.kernelDev;
      inherit (gnome) libglademm;
    };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    v86d = callPackage ../os-specific/linux/v86d { };

    virtualbox = callPackage ../applications/virtualization/virtualbox {
      stdenv = stdenv_32bit;
      inherit (gnome) libIDL;
      enableExtensionPack = config.virtualbox.enableExtensionPack or false;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions { };

    zfs = callPackage ../os-specific/linux/zfs/default.nix { };
  };

  # Build the kernel modules for the some of the kernels.
  linuxPackages_3_2 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_2 linuxPackages_3_2);
  linuxPackages_3_2_apparmor = linuxPackagesFor pkgs.linux_3_2_apparmor linuxPackages_3_2_apparmor;
  linuxPackages_3_2_grsecurity = linuxPackagesFor pkgs.linux_3_2_grsecurity linuxPackages_3_2_grsecurity;
  linuxPackages_3_2_xen = linuxPackagesFor pkgs.linux_3_2_xen linuxPackages_3_2_xen;
  linuxPackages_3_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_4 linuxPackages_3_4);
  linuxPackages_3_4_apparmor = linuxPackagesFor pkgs.linux_3_4_apparmor linuxPackages_3_4_apparmor;
  linuxPackages_3_6_rpi = linuxPackagesFor pkgs.linux_3_6_rpi linuxPackages_3_6_rpi;
  linuxPackages_3_10 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_10 linuxPackages_3_10);
  linuxPackages_3_11 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_11 linuxPackages_3_11);
  linuxPackages_3_12 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_12 linuxPackages_3_12);
  # Update this when adding a new version!
  linuxPackages_latest = pkgs.linuxPackages_3_12;

  # The current default kernel / kernel modules.
  linux = linuxPackages.kernel;
  linuxPackages = linuxPackages_3_10;

  # A function to build a manually-configured kernel
  linuxManualConfig = import ../os-specific/linux/kernel/manual-config.nix {
    inherit (pkgs) stdenv runCommand nettools bc perl kmod writeTextFile;
  };

  keyutils = callPackage ../os-specific/linux/keyutils { };

  libselinux = callPackage ../os-specific/linux/libselinux { };

  libsemanage = callPackage ../os-specific/linux/libsemanage { };

  libraw1394 = callPackage ../development/libraries/libraw1394 { };

  libsexy = callPackage ../development/libraries/libsexy { };

  libsepol = callPackage ../os-specific/linux/libsepol { };

  libsmbios = callPackage ../os-specific/linux/libsmbios { };

  lm_sensors = callPackage ../os-specific/linux/lm-sensors { };

  lsiutil = callPackage ../os-specific/linux/lsiutil { };

  klibc = callPackage ../os-specific/linux/klibc {
    linuxHeaders = glibc.kernelHeaders;
  };

  klibcShrunk = lowPrio (callPackage ../os-specific/linux/klibc/shrunk.nix { });

  kmod = callPackage ../os-specific/linux/kmod { };

  kvm = qemu_kvm;

  libcap = callPackage ../os-specific/linux/libcap { };

  libcap_progs = callPackage ../os-specific/linux/libcap/progs.nix { };

  libcap_pam = callPackage ../os-specific/linux/libcap/pam.nix { };

  libcap_manpages = callPackage ../os-specific/linux/libcap/man.nix { };

  libcap_ng = callPackage ../os-specific/linux/libcap-ng { };

  libnscd = callPackage ../os-specific/linux/libnscd { };

  libnotify = callPackage ../development/libraries/libnotify { };

  libvolume_id = callPackage ../os-specific/linux/libvolume_id { };

  lsscsi = callPackage ../os-specific/linux/lsscsi { };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  mdadm = callPackage ../os-specific/linux/mdadm { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  module_init_tools = callPackage ../os-specific/linux/module-init-tools { };

  aggregateModules = modules:
    callPackage ../os-specific/linux/kmod/aggregator.nix {
      inherit modules;
    };

  multipath_tools = callPackage ../os-specific/linux/multipath-tools { };

  nettools = callPackage ../os-specific/linux/net-tools { };

  neverball = callPackage ../games/neverball {
    libpng = libpng15;
  };

  numactl = callPackage ../os-specific/linux/numactl { };

  gogoclient = callPackage ../os-specific/linux/gogoclient { };

  nss_ldap = callPackage ../os-specific/linux/nss_ldap { };

  pam = callPackage ../os-specific/linux/pam { };

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_ccreds = callPackage ../os-specific/linux/pam_ccreds {
    db = db4;
  };

  pam_console = callPackage ../os-specific/linux/pam_console {
    libtool = libtool_1_5;
  };

  pam_devperm = callPackage ../os-specific/linux/pam_devperm { };

  pam_krb5 = callPackage ../os-specific/linux/pam_krb5 { };

  pam_ldap = callPackage ../os-specific/linux/pam_ldap { };

  pam_login = callPackage ../os-specific/linux/pam_login { };

  pam_ssh_agent_auth = callPackage ../os-specific/linux/pam_ssh_agent_auth { };

  pam_usb = callPackage ../os-specific/linux/pam_usb { };

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils {
    firmware = config.pcmciaUtils.firmware or [];
    config = config.pcmciaUtils.config or null;
  };

  plymouth = callPackage ../os-specific/linux/plymouth { };

  pmount = callPackage ../os-specific/linux/pmount { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  pmtools = callPackage ../os-specific/linux/pmtools { };

  policycoreutils = callPackage ../os-specific/linux/policycoreutils { };

  powertop = callPackage ../os-specific/linux/powertop { };

  prayer = callPackage ../servers/prayer { };

  procps = callPackage ../os-specific/linux/procps { };

  "procps-ng" = callPackage ../os-specific/linux/procps-ng { };

  qemu_kvm = lowPrio (qemu.override { x86Only = true; });

  firmwareLinuxNonfree = callPackage ../os-specific/linux/firmware/firmware-linux-nonfree { };

  radeontools = callPackage ../os-specific/linux/radeontools { };

  raspberrypifw = callPackage ../os-specific/linux/firmware/raspberrypi {};

  regionset = callPackage ../os-specific/linux/regionset { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  rtkit = callPackage ../os-specific/linux/rtkit { };

  sdparm = callPackage ../os-specific/linux/sdparm { };

  sepolgen = callPackage ../os-specific/linux/sepolgen { };

  shadow = callPackage ../os-specific/linux/shadow { };

  statifier = builderDefsPackage (import ../os-specific/linux/statifier) { };

  sysfsutils = callPackage ../os-specific/linux/sysfsutils { };

  # Provided with sysfsutils.
  libsysfs = sysfsutils;
  systool = sysfsutils;

  sysklogd = callPackage ../os-specific/linux/sysklogd { };

  syslinux = callPackage ../os-specific/linux/syslinux { };

  sysstat = callPackage ../os-specific/linux/sysstat { };

  systemd = callPackage ../os-specific/linux/systemd { };

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

  trackballs = callPackage ../games/trackballs {
    debug = false;
    guile = guile_1_8;
  };

  tunctl = callPackage ../os-specific/linux/tunctl { };

  ubootChooser = name : if name == "upstream" then ubootUpstream
    else if name == "sheevaplug" then ubootSheevaplug
    else if name == "guruplug" then ubootGuruplug
    else if name == "nanonote" then ubootNanonote
    else throw "Unknown uboot";

  ubootUpstream = callPackage ../misc/uboot { };

  ubootSheevaplug = callPackage ../misc/uboot/sheevaplug.nix { };

  ubootNanonote = callPackage ../misc/uboot/nanonote.nix { };

  ubootGuruplug = callPackage ../misc/uboot/guruplug.nix { };

  uclibc = callPackage ../os-specific/linux/uclibc { };

  uclibcCross = lowPrio (callPackage ../os-specific/linux/uclibc {
    inherit fetchurl stdenv libiconv;
    linuxHeaders = linuxHeadersCross;
    gccCross = gccCrossStageStatic;
    cross = assert crossSystem != null; crossSystem;
  });

  udev145 = callPackage ../os-specific/linux/udev/145.nix { };
  udev = pkgs.systemd;

  udisks1 = callPackage ../os-specific/linux/udisks/1-default.nix { };
  udisks2 = callPackage ../os-specific/linux/udisks/2-default.nix { };
  udisks = udisks1;

  udisks_glue = callPackage ../os-specific/linux/udisks-glue { };

  untie = callPackage ../os-specific/linux/untie { };

  upower = callPackage ../os-specific/linux/upower {
    libusb1 = callPackage ../development/libraries/libusb1/1_0_9.nix {};
  };

  upstart = callPackage ../os-specific/linux/upstart { };

  usbutils = callPackage ../os-specific/linux/usbutils { };

  utillinux = lowPrio (callPackage ../os-specific/linux/util-linux {
    ncurses = null;
    perl = null;
  });

  utillinuxCurses = utillinux.override {
    inherit ncurses perl;
  };

  v4l_utils = callPackage ../os-specific/linux/v4l-utils {
    withQt4 = true;
  };

  windows = rec {
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

    pthreads = callPackage ../os-specific/windows/pthread-w32 {
      mingw_headers = mingw_headers3;
    };

    wxMSW = callPackage ../os-specific/windows/wxMSW-2.8 { };
  };

  wesnoth = callPackage ../games/wesnoth {
    lua = lua5;
  };

  wirelesstools = callPackage ../os-specific/linux/wireless-tools { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant { };

  wpa_supplicant_gui = callPackage ../os-specific/linux/wpa_supplicant/gui.nix { };

  xf86_input_mtrack = callPackage ../os-specific/linux/xf86-input-mtrack {
    inherit (xorg) utilmacros xproto inputproto xorgserver;
  };

  xf86_input_multitouch =
    callPackage ../os-specific/linux/xf86-input-multitouch { };

  xf86_input_wacom = callPackage ../os-specific/linux/xf86-input-wacom { };

  xf86_video_nested = callPackage ../os-specific/linux/xf86-video-nested {
    inherit (xorg) fontsproto renderproto utilmacros xorgserver;
  };

  xf86_video_nouveau = callPackage ../os-specific/linux/xf86-video-nouveau {
    inherit (xorg) xorgserver xproto fontsproto xf86driproto renderproto
      videoproto utilmacros;
  };

  xmoto = builderDefsPackage (import ../games/xmoto) {
    inherit chipmunk sqlite curl zlib bzip2 libjpeg libpng
      freeglut mesa SDL SDL_mixer SDL_image SDL_net SDL_ttf
      lua5 ode libxdg_basedir libxml2;
  };

  xorg_sys_opengl = callPackage ../os-specific/linux/opengl/xorg-sys { };

  zd1211fw = callPackage ../os-specific/linux/firmware/zd1211 { };


  ### DATA

  andagii = callPackage ../data/fonts/andagii {};

  anonymousPro = callPackage ../data/fonts/anonymous-pro {};

  arkpandora_ttf = builderDefsPackage (import ../data/fonts/arkpandora) { };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

  cacert = callPackage ../data/misc/cacert { };

  cantarell_fonts = callPackage ../data/fonts/cantarell-fonts { };

  corefonts = callPackage ../data/fonts/corefonts { };

  wrapFonts = paths : ((import ../data/fonts/fontWrap) {
    inherit fetchurl stdenv builderDefs paths;
    inherit (xorg) mkfontdir mkfontscale;
  });

  clearlyU = callPackage ../data/fonts/clearlyU { };

  cm_unicode = callPackage ../data/fonts/cm-unicode {};

  dejavu_fonts = callPackage ../data/fonts/dejavu-fonts {
    inherit (perlPackages) FontTTF;
  };

  docbook5 = callPackage ../data/sgml+xml/schemas/docbook-5.0 { };

  docbook_sgml_dtd_31 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/3.1.nix { };

  docbook_sgml_dtd_41 = callPackage ../data/sgml+xml/schemas/sgml-dtd/docbook/4.1.nix { };

  docbook_xml_dtd_412 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix { };

  docbook_xml_dtd_42 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix { };

  docbook_xml_dtd_43 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix { };

  docbook_xml_dtd_45 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix { };

  docbook_xml_ebnf_dtd = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf { };

  docbook_xml_xslt = docbook_xsl;

  docbook_xsl = callPackage ../data/sgml+xml/stylesheets/xslt/docbook-xsl { };

  docbook5_xsl = docbook_xsl_ns;

  docbook_xsl_ns = callPackage ../data/sgml+xml/stylesheets/xslt/docbook-xsl-ns { };

  dosemu_fonts = callPackage ../data/fonts/dosemu-fonts { };

  freefont_ttf = callPackage ../data/fonts/freefont-ttf { };

  freepats = callPackage ../data/misc/freepats { };

  gentium = callPackage ../data/fonts/gentium {};

  gnome_user_docs = callPackage ../data/documentation/gnome-user-docs { };

  inherit (gnome3) gsettings_desktop_schemas;

  hicolor_icon_theme = callPackage ../data/icons/hicolor-icon-theme { };

  inconsolata = callPackage ../data/fonts/inconsolata {};

  junicode = callPackage ../data/fonts/junicode { };

  liberation_ttf = callPackage ../data/fonts/redhat-liberation-fonts { };

  libertine = builderDefsPackage (import ../data/fonts/libertine) {
    inherit fetchurl fontforge lib;
  };

  lmmath = callPackage ../data/fonts/lmodern/lmmath.nix {};

  lmodern = callPackage ../data/fonts/lmodern { };

  manpages = callPackage ../data/documentation/man-pages { };

  miscfiles = callPackage ../data/misc/miscfiles { };

  mobile_broadband_provider_info = callPackage ../data/misc/mobile-broadband-provider-info { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  oldstandard = callPackage ../data/fonts/oldstandard { };

  posix_man_pages = callPackage ../data/documentation/man-pages-posix { };

  pthreadmanpages = callPackage ../data/documentation/pthread-man-pages { };

  shared_mime_info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  iana_etc = callPackage ../data/misc/iana-etc { };

  poppler_data = callPackage ../data/misc/poppler-data { };

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  tango-icon-theme = callPackage ../data/icons/tango-icon-theme { };

  themes = name: import (../data/misc/themes + ("/" + name + ".nix")) {
    inherit fetchurl;
  };

  theano = callPackage ../data/fonts/theano { };

  tempora_lgc = callPackage ../data/fonts/tempora-lgc { };

  terminus_font = callPackage ../data/fonts/terminus-font { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  tzdata = callPackage ../data/misc/tzdata { };

  ubuntu_font_family = callPackage ../data/fonts/ubuntu-font-family { };

  ucsFonts = callPackage ../data/fonts/ucs-fonts { };

  unifont = callPackage ../data/fonts/unifont { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xhtml1 = callPackage ../data/sgml+xml/schemas/xml-dtd/xhtml1 { };

  xkeyboard_config = callPackage ../data/misc/xkeyboard-config { };


  ### APPLICATIONS

  a2jmidid = callPackage ../applications/audio/a2jmidid { };

  aangifte2005 = callPackage_i686 ../applications/taxes/aangifte-2005 { };

  aangifte2006 = callPackage_i686 ../applications/taxes/aangifte-2006 { };

  aangifte2007 = callPackage_i686 ../applications/taxes/aangifte-2007 { };

  aangifte2008 = callPackage_i686 ../applications/taxes/aangifte-2008 { };

  aangifte2009 = callPackage_i686 ../applications/taxes/aangifte-2009 { };

  aangifte2010 = callPackage_i686 ../applications/taxes/aangifte-2010 { };

  aangifte2011 = callPackage_i686 ../applications/taxes/aangifte-2011 { };

  aangifte2012 = callPackage_i686 ../applications/taxes/aangifte-2012 { };

  abcde = callPackage ../applications/audio/abcde {
    inherit (perlPackages) DigestSHA MusicBrainz MusicBrainzDiscID;
  };

  abiword = callPackage ../applications/office/abiword {
    inherit (gnome) libglade libgnomecanvas;
  };

  abook = callPackage ../applications/misc/abook { };

  adobe-reader = callPackage_i686 ../applications/misc/adobe-reader { };

  aewan = callPackage ../applications/editors/aewan { };

  alchemy = callPackage ../applications/graphics/alchemy { };

  amsn = callPackage ../applications/networking/instant-messengers/amsn { };

  antiword = callPackage ../applications/office/antiword {};

  ardour = callPackage ../applications/audio/ardour {
    inherit (gnome) libgnomecanvas libgnomecanvasmm;
  };

  ardour3 =  lowPrio (callPackage ../applications/audio/ardour/ardour3.nix {
    inherit (gnome) libgnomecanvas libgnomecanvasmm;
    boost = boost149;
  });

  arora = callPackage ../applications/networking/browsers/arora { };

  aseprite = callPackage ../applications/editors/aseprite { };

  audacious = callPackage ../applications/audio/audacious { };

  audacity = callPackage ../applications/audio/audacity { };

  milkytracker = callPackage ../applications/audio/milkytracker { };

  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  avidemux = callPackage ../applications/video/avidemux { };

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

  avxsynth = callPackage ../applications/video/avxsynth { };

  awesome = callPackage ../applications/window-managers/awesome {
    lua = lua5;
    cairo = cairo.override { xcbSupport = true; };
  };

  baresip = callPackage ../applications/networking/instant-messengers/baresip {};

  batik = callPackage ../applications/graphics/batik { };

  bazaar = callPackage ../applications/version-management/bazaar { };

  bazaarTools = builderDefsPackage (import ../applications/version-management/bazaar/tools.nix) {
    inherit bazaar;
  };

  beast = callPackage ../applications/audio/beast {
    inherit (gnome) libgnomecanvas libart_lgpl;
    guile = guile_1_8;
  };

  bibletime = callPackage ../applications/misc/bibletime { };

  bitcoin = callPackage ../applications/misc/bitcoin {
    db4 = db48;
  };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee {
    # For some reason, TLS support is broken when using GnuTLS 3.0 (can't
    # connect to jabber.org, for instance.)
    gnutls = gnutls2;
    libotr = libotr_3_2;
  };

  blender = callPackage  ../applications/misc/blender {
    python = python3;
  };

  bristol = callPackage ../applications/audio/bristol { };

  bvi = callPackage ../applications/editors/bvi { };

  calf = callPackage ../applications/audio/calf {
      inherit (gnome) libglade;
  };

  calibre = callPackage ../applications/misc/calibre { };

  carrier = builderDefsPackage (import ../applications/networking/instant-messengers/carrier/2.5.0.nix) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 openssl nss
      gtkspell aspell gettext ncurses avahi dbus dbus_glib python
      libtool automake autoconf gstreamer;
    inherit gtk glib;
    inherit (gnome) startupnotification GConf ;
    inherit (xlibs) libXScrnSaver scrnsaverproto libX11 xproto kbproto;
  };
  funpidgin = carrier;

  cc1394 = callPackage ../applications/video/cc1394 { };

  cddiscid = callPackage ../applications/audio/cd-discid { };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = callPackage ../applications/audio/cdparanoia { };

  cdrtools = callPackage ../applications/misc/cdrtools { };

  centerim = callPackage ../applications/networking/instant-messengers/centerim { };

  cgit = callPackage ../applications/version-management/git-and-tools/cgit { };

  cgminer = callPackage ../applications/misc/cgminer {
    amdappsdk = amdappsdk28;
  };

  chatzilla = callPackage ../applications/networking/irc/chatzilla {
    xulrunner = firefox36Pkgs.xulrunner;
  };

  chromium = lowPrio (callPackage ../applications/networking/browsers/chromium {
    channel = "stable";
    gconf = gnome.GConf;
    pulseSupport = config.pulseaudio or true;
  });

  chromiumBeta = lowPrio (chromium.override { channel = "beta"; });
  chromiumBetaWrapper = lowPrio (wrapChromium chromiumBeta);

  chromiumDev = lowPrio (chromium.override { channel = "dev"; });
  chromiumDevWrapper = lowPrio (wrapChromium chromiumDev);

  chromiumWrapper = wrapChromium chromium;

  cinelerra = callPackage ../applications/video/cinelerra { };

  cmus = callPackage ../applications/audio/cmus { };

  compiz = callPackage ../applications/window-managers/compiz {
    inherit (gnome) GConf ORBit2 metacity;
    boost = boost149; # https://bugs.launchpad.net/compiz/+bug/1131864
  };

  coriander = callPackage ../applications/video/coriander {
    inherit (gnome) libgnomeui GConf;
  };

  csound = callPackage ../applications/audio/csound { };

  cinepaint = callPackage ../applications/graphics/cinepaint {
    fltk = fltk13;
    libpng = libpng12;
  };

  codeville = builderDefsPackage (import ../applications/version-management/codeville/0.8.0.nix) {
    inherit makeWrapper;
    python = pythonFull;
  };

  comical = callPackage ../applications/graphics/comical { };

  conkeror = callPackage ../applications/networking/browsers/conkeror { };
  conkerorWrapper = wrapFirefox {
    browser = conkeror;
    browserName = "conkeror";
    desktopName = "Conkeror";
  };

  cuneiform = builderDefsPackage (import ../tools/graphics/cuneiform) {
    inherit cmake patchelf;
    imagemagick = imagemagick;
  };

  cvs = callPackage ../applications/version-management/cvs { };

  cvsps = callPackage ../applications/version-management/cvsps { };

  cvs2svn = callPackage ../applications/version-management/cvs2svn { };

  d4x = callPackage ../applications/misc/d4x { };

  darcs = haskellPackages.darcs.override {
    # A variant of the Darcs derivation that containts only the executable and
    # thus has no dependencies on other Haskell packages.
    cabal = { mkDerivation = x: rec { final = haskellPackages.cabal.mkDerivation (self: (x final) // {
              isLibrary = false;
              configureFlags = "-f-library"; }); }.final;
            };
  };

  darktable = callPackage ../applications/graphics/darktable {
    inherit (gnome) GConf libglade;
  };

  "dd-agent" = callPackage ../tools/networking/dd-agent { };

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome) libart_lgpl libgnomeui;
  };

  diffuse = callPackage ../applications/version-management/diffuse { };

  distrho = callPackage ../applications/audio/distrho {};

  djvulibre = callPackage ../applications/misc/djvulibre { };

  djview = callPackage ../applications/graphics/djview { };
  djview4 = pkgs.djview;

  dmenu = callPackage ../applications/misc/dmenu {
    enableXft = config.dmenu.enableXft or false;
  };

  dmtx = builderDefsPackage (import ../tools/graphics/dmtx) {
    inherit libpng libtiff libjpeg imagemagick librsvg
      pkgconfig bzip2 zlib libtool freetype fontconfig
      ghostscript jasper xz;
    inherit (xlibs) libX11;
  };

  doodle = callPackage ../applications/search/doodle { };

  dunst = callPackage ../applications/misc/dunst { };

  dvb_apps  = callPackage ../applications/video/dvb-apps { };

  dvdauthor = callPackage ../applications/video/dvdauthor { };

  dvswitch = callPackage ../applications/video/dvswitch { };

  dwb = callPackage ../applications/networking/browsers/dwb { };

  dwm = callPackage ../applications/window-managers/dwm {
    patches = config.dwm.patches or [];
  };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse { });

  ed = callPackage ../applications/editors/ed { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs24;

  emacs23 = callPackage ../applications/editors/emacs-23 {
    stdenv =
      if stdenv.isDarwin
      /* On Darwin, use Apple-GCC, otherwise:
           configure: error: C preprocessor "cc -E -no-cpp-precomp" fails sanity check */
      then overrideGCC stdenv gccApple
      else stdenv;

    # use override to select the appropriate gui toolkit
    libXaw = if stdenv.isDarwin then xlibs.libXaw else null;
    Xaw3d = null;
    gtk = if stdenv.isDarwin then null else gtk;
    # TODO: these packages don't build on Darwin.
    gconf = null /* if stdenv.isDarwin then null else gnome.GConf */;
    librsvg = null /* if stdenv.isDarwin then null else librsvg */;
  };

  emacs24 = callPackage ../applications/editors/emacs-24 {
    # use override to enable additional features
    libXaw = if stdenv.isDarwin then xlibs.libXaw else null;
    Xaw3d = null;
    gconf = null;
    librsvg = null;
    alsaLib = null;
    imagemagick = null;
    texinfo = texinfo5;

    # use clangStdenv on darwin to deal with: unexec: 'my_edata is not in
    # section __data'
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  emacs24-nox = lowPrio (appendToName "nox" (emacs24.override {
    withX = false;
  }));

  emacsPackages = emacs: self: let callPackage = newScope self; in rec {
    inherit emacs;

    autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };

    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { texinfo = texinfo5; };

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    calfw = callPackage ../applications/editors/emacs-modes/calfw { };

    coffee = callPackage ../applications/editors/emacs-modes/coffee { };

    colorTheme = callPackage ../applications/editors/emacs-modes/color-theme { };

    cua = callPackage ../applications/editors/emacs-modes/cua { };

    # ecb = callPackage ../applications/editors/emacs-modes/ecb { };

    jabber = callPackage ../applications/editors/emacs-modes/jabber { };

    emacsClangCompleteAsync = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };

    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { texinfo = texinfo5; };

    emms = callPackage ../applications/editors/emacs-modes/emms { texinfo = texinfo5; };

    ess = callPackage ../applications/editors/emacs-modes/ess { };

    flymakeCursor = callPackage ../applications/editors/emacs-modes/flymake-cursor { };

    gh = callPackage ../applications/editors/emacs-modes/gh { };

    graphvizDot = callPackage ../applications/editors/emacs-modes/graphviz-dot { };

    gist = callPackage ../applications/editors/emacs-modes/gist { };

    jade = callPackage ../applications/editors/emacs-modes/jade { };

    jdee = callPackage ../applications/editors/emacs-modes/jdee {
      # Requires Emacs 23, for `avl-tree'.
    };

    js2 = callPackage ../applications/editors/emacs-modes/js2 { };

    stratego = callPackage ../applications/editors/emacs-modes/stratego { };

    haskellMode = callPackage ../applications/editors/emacs-modes/haskell { };

    ocamlMode = callPackage ../applications/editors/emacs-modes/ocaml { };

    tuaregMode = callPackage ../applications/editors/emacs-modes/tuareg { };

    hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };

    htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };

    logito = callPackage ../applications/editors/emacs-modes/logito { };

    loremIpsum = callPackage ../applications/editors/emacs-modes/lorem-ipsum { };

    magit = callPackage ../applications/editors/emacs-modes/magit { texinfo = texinfo5; };

    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };

    notmuch = lowPrio (callPackage ../applications/networking/mailreaders/notmuch { });

    # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
    # we want it to have higher precedence.
    org = hiPrio (callPackage ../applications/editors/emacs-modes/org { texinfo = texinfo5; });

    org2blog = callPackage ../applications/editors/emacs-modes/org2blog { };

    pcache = callPackage ../applications/editors/emacs-modes/pcache { };

    phpMode = callPackage ../applications/editors/emacs-modes/php { };

    prologMode = callPackage ../applications/editors/emacs-modes/prolog { };

    proofgeneral = callPackage ../applications/editors/emacs-modes/proofgeneral {
      texLive = pkgs.texLiveAggregationFun {
        paths = [ pkgs.texLive pkgs.texLiveCMSuper ];
      };
    };

    quack = callPackage ../applications/editors/emacs-modes/quack { };

    rectMark = callPackage ../applications/editors/emacs-modes/rect-mark { };

    remember = callPackage ../applications/editors/emacs-modes/remember { };

    rudel = callPackage ../applications/editors/emacs-modes/rudel { };

    scalaMode = callPackage ../applications/editors/emacs-modes/scala-mode { };

    sunriseCommander = callPackage ../applications/editors/emacs-modes/sunrise-commander { };

    xmlRpc = callPackage ../applications/editors/emacs-modes/xml-rpc { };
  };

  emacs23Packages = emacsPackages emacs23 pkgs.emacs23Packages;
  emacs24Packages = recurseIntoAttrs (emacsPackages emacs24 pkgs.emacs24Packages);

  epdfview = callPackage ../applications/misc/epdfview { };

  espeak = callPackage ../applications/audio/espeak { };

  espeakedit = callPackage ../applications/audio/espeak/edit.nix { };

  esniper = callPackage ../applications/networking/esniper { };

  etherape = callPackage ../applications/networking/sniffers/etherape {
    inherit (gnome) gnomedocutils libgnome libglade libgnomeui scrollkeeper;
  };

  evopedia = callPackage ../applications/misc/evopedia { };

  keepassx = callPackage ../applications/misc/keepassx { };

  inherit (gnome3) evince;
  keepass = callPackage ../applications/misc/keepass { };

  evolution_data_server = newScope (gnome) ../servers/evolution-data-server { };

  exrdisplay = callPackage ../applications/graphics/exrdisplay {
    fltk = fltk20;
  };

  fbpanel = callPackage ../applications/window-managers/fbpanel { };

  fbreader = callPackage ../applications/misc/fbreader { };

  fetchmail = import ../applications/misc/fetchmail {
    inherit stdenv fetchurl openssl;
  };

  fluidsynth = callPackage ../applications/audio/fluidsynth { };

  fossil = callPackage ../applications/version-management/fossil { };

  fribid = callPackage ../applications/networking/browsers/mozilla-plugins/fribid { };

  fvwm = callPackage ../applications/window-managers/fvwm { };

  geany = callPackage ../applications/editors/geany { };

  gnuradio = callPackage ../applications/misc/gnuradio {
    inherit (pythonPackages) lxml numpy scipy matplotlib pyopengl;
    fftw = fftwFloat;
  };

  goldendict = callPackage ../applications/misc/goldendict { };

  google-musicmanager = callPackage ../applications/audio/google-musicmanager { };

  gpicview = callPackage ../applications/graphics/gpicview { };

  grass = import ../applications/misc/grass {
    inherit (xlibs) libXmu libXext libXp libX11 libXt libSM libICE libXpm
      libXaw libXrender;
    inherit config composableDerivation stdenv fetchurl
      lib flex bison cairo fontconfig
      gdal zlib ncurses gdbm proj pkgconfig swig
      blas liblapack libjpeg libpng mysql unixODBC mesa postgresql python
      readline sqlite tcl tk libtiff freetype ffmpeg makeWrapper wxGTK;
    fftw = fftwSinglePrec;
    motif = lesstif;
    opendwg = libdwg;
    wxPython = wxPython28;
  };

  grip = callPackage ../applications/misc/grip {
    inherit (gnome) libgnome libgnomeui vte;
  };

  gtimelog = pythonPackages.gtimelog;

  guitarix = callPackage ../applications/audio/guitarix {
    fftw = fftwSinglePrec;
  };

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark { };

  wvdial = callPackage ../os-specific/linux/wvdial { };

  fbida = callPackage ../applications/graphics/fbida { };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  filezilla = callPackage ../applications/networking/ftp/filezilla { };

  firefox = pkgs.firefoxPkgs.firefox;

  firefox36Pkgs = callPackage ../applications/networking/browsers/firefox/3.6.nix {
    inherit (gnome) libIDL;
  };

  firefox36Wrapper = wrapFirefox { browser = firefox36Pkgs.firefox; };

  firefox13Pkgs = callPackage ../applications/networking/browsers/firefox/13.0.nix {
    inherit (gnome) libIDL;
  };

  firefox13Wrapper = lowPrio (wrapFirefox { browser = firefox13Pkgs.firefox; });

  firefoxPkgs = callPackage ../applications/networking/browsers/firefox {
    inherit (gnome) libIDL;
    inherit (pythonPackages) pysqlite;
    libpng = libpng.override { apngSupport = true; };
  };

  firefoxWrapper = wrapFirefox { browser = firefoxPkgs.firefox; };

  flac = callPackage ../applications/audio/flac { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer-11 {
    debug = config.flashplayer.debug or false;
    # !!! Fix the dependency on two different builds of nss.
  };

  freecad = callPackage ../applications/graphics/freecad {
    opencascade = opencascade_6_5;
  };

  freemind = callPackage ../applications/misc/freemind {
    jdk = jdk;
    jre = jdk;
  };

  freenet = callPackage ../applications/networking/p2p/freenet { };

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
  xlsfonts = callPackage ../applications/misc/xlsfonts { };

  freerdp = callPackage ../applications/networking/remote/freerdp { };

  freerdpUnstable = callPackage ../applications/networking/remote/freerdp/unstable.nix { };

  freicoin = callPackage ../applications/misc/freicoin {
    db4 = db48;
  };

  fspot = callPackage ../applications/graphics/f-spot {
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  get_iplayer = callPackage ../applications/misc/get_iplayer {};

  gimp_2_6 = callPackage ../applications/graphics/gimp {
    inherit (gnome) libart_lgpl;
    libpng = libpng12;
  };

  gimp_2_8 = callPackage ../applications/graphics/gimp/2.8.nix {
    inherit (gnome) libart_lgpl;
    webkit = null;
    lcms = lcms2;
  };

  gimp = gimp_2_8;

  gimpPlugins = recurseIntoAttrs (import ../applications/graphics/gimp/plugins {
    inherit pkgs gimp;
  });

  gitAndTools = recurseIntoAttrs (import ../applications/version-management/git-and-tools {
    inherit pkgs;
  });
  git = gitAndTools.git;
  gitFull = gitAndTools.gitFull;
  gitSVN = gitAndTools.gitSVN;

  giv = callPackage ../applications/graphics/giv {
    pcre = pcre.override { unicodeSupport = true; };
  };

  gmrun = callPackage ../applications/misc/gmrun {};

  gnucash = callPackage ../applications/office/gnucash {
    inherit (gnome2) libgnomeui libgtkhtml gtkhtml libbonoboui libgnomeprint libglade libart_lgpl;
    gconf = gnome2.GConf;
    guile = guile_1_8;
    slibGuile = slibGuile.override { scheme = guile_1_8; };
  };

  libquvi = callPackage ../applications/video/quvi/library.nix { };

  mi2ly = callPackage ../applications/audio/mi2ly {};

  praat = callPackage ../applications/audio/praat { };

  quvi = callPackage ../applications/video/quvi/tool.nix { };

  quvi_scripts = callPackage ../applications/video/quvi/scripts.nix { };

  qjackctl = callPackage ../applications/audio/qjackctl { };

  gkrellm = callPackage ../applications/misc/gkrellm { };

  gmu = callPackage ../applications/audio/gmu { };

  gnash = callPackage ../applications/video/gnash {
    xulrunner = firefoxPkgs.xulrunner;
    inherit (gnome) gtkglext;
  };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer {
    inherit (gnome) GConf;
  };

  gnumeric = callPackage ../applications/office/gnumeric {
    goffice = goffice_0_10;
    inherit (gnome) libglade scrollkeeper;
  };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gnunet_svn = lowPrio (callPackage ../applications/networking/p2p/gnunet/svn.nix {
    libgcrypt = libgcrypt_git;
  });

  gocr = callPackage ../applications/graphics/gocr { };

  gobby5 = callPackage ../applications/editors/gobby {
    inherit (gnome) gtksourceview;
  };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = builderDefsPackage ../applications/misc/gphoto2/gphotofs.nix {
    inherit libgphoto2 fuse pkgconfig glib libtool;
  };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };

  graphicsmagick137 = callPackage ../applications/graphics/graphicsmagick/1.3.7.nix {
    libpng = libpng12;
  };

  gtkpod = callPackage ../applications/audio/gtkpod {
    inherit (gnome) libglade;
  };

  jbidwatcher = callPackage ../applications/misc/jbidwatcher {
    java = if stdenv.isLinux then jre else jdk;
  };

  qrdecode = builderDefsPackage (import ../tools/graphics/qrdecode) {
    libpng = libpng12;
    opencv = opencv_2_1;
  };

  qrencode = callPackage ../tools/graphics/qrencode { };

  gecko_mediaplayer = callPackage ../applications/networking/browsers/mozilla-plugins/gecko-mediaplayer {
    inherit (gnome) GConf;
    browser = firefox;
  };

  geeqie = callPackage ../applications/graphics/geeqie { };

  gigedit = callPackage ../applications/audio/gigedit { };

  gqview = callPackage ../applications/graphics/gqview { };

  gmpc = callPackage ../applications/audio/gmpc { };

  gmtk = callPackage ../applications/networking/browsers/mozilla-plugins/gmtk {
    inherit (gnome) GConf;
  };

  gnome_terminator = callPackage ../applications/misc/gnome_terminator {
    vte = gnome.vte.override { pythonSupport = true; };
  };

  googleearth = callPackage_i686 ../applications/misc/googleearth { };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin {
    libpng = libpng12;
  };

  gosmore = builderDefsPackage ../applications/misc/gosmore {
    inherit fetchsvn curl pkgconfig libxml2 gtk;
  };

  gpsbabel = callPackage ../applications/misc/gpsbabel { };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate { };

  gpsd = callPackage ../servers/gpsd { };

  guitone = callPackage ../applications/version-management/guitone { };

  gv = callPackage ../applications/misc/gv { };

  hello = callPackage ../applications/misc/hello/ex-2 { };

  herbstluftwm = callPackage ../applications/window-managers/herbstluftwm { };

  hexedit = callPackage ../applications/editors/hexedit { };

  hipchat = callPackage_i686 ../applications/networking/instant-messengers/hipchat { };

  homebank = callPackage ../applications/office/homebank { };

  htmldoc = callPackage ../applications/misc/htmldoc {
    fltk = fltk13;
  };

  hugin = callPackage ../applications/graphics/hugin { };

  hydrogen = callPackage ../applications/audio/hydrogen { };

  i3 = callPackage ../applications/window-managers/i3 { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
    inherit (xorg) libxkbfile;
    cairo = cairo.override { xcbSupport = true; };
  };

  i3status = callPackage ../applications/window-managers/i3/status.nix { };

  i810switch = callPackage ../os-specific/linux/i810switch { };

  icecat3 = lowPrio (callPackage ../applications/networking/browsers/icecat-3 {
    inherit (gnome) libIDL libgnomeui gnome_vfs;
    inherit (xlibs) pixman;
    inherit (pythonPackages) ply;
  });

  icecatXulrunner3 = lowPrio (callPackage ../applications/networking/browsers/icecat-3 {
    application = "xulrunner";
    inherit (gnome) libIDL libgnomeui gnome_vfs;
    inherit (xlibs) pixman;
    inherit (pythonPackages) ply;
  });

  icecat3Xul =
    (symlinkJoin "icecat-with-xulrunner-${icecat3.version}"
       [ icecat3 icecatXulrunner3 ])
    // { inherit (icecat3) gtk isFirefox3Like meta; };

  icecat3Wrapper = wrapFirefox { browser = icecat3Xul; browserName = "icecat"; desktopName = "IceCat"; };

  icewm = callPackage ../applications/window-managers/icewm { };

  id3v2 = callPackage ../applications/audio/id3v2 { };

  ii = callPackage ../applications/networking/irc/ii { };

  ike = callPackage ../applications/ike { };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    inherit (perlPackages) TextMarkdown URI HTMLParser HTMLScrubber
      HTMLTemplate TimeDate CGISession DBFile CGIFormBuilder LocaleGettext
      RpcXML XMLSimple PerlMagick YAML YAMLLibYAML HTMLTree Filechdir
      AuthenPassphrase NetOpenIDConsumer LWPxParanoidAgent CryptSSLeay;
  };

  imagemagick = callPackage ../applications/graphics/ImageMagick {
    tetex = null;
    librsvg = null;
  };

  imagemagickBig = lowPrio (callPackage ../applications/graphics/ImageMagick { });

  # Impressive, formerly known as "KeyJNote".
  impressive = callPackage ../applications/office/impressive {
    # XXX These are the PyOpenGL dependencies, which we need here.
    inherit (pythonPackages) pyopengl;
  };

  inkscape = callPackage ../applications/graphics/inkscape {
    inherit (pythonPackages) lxml;
    lcms = lcms2;
  };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5;
  };

  ipe = callPackage ../applications/graphics/ipe { };

  iptraf = callPackage ../applications/networking/iptraf { };

  irssi = callPackage ../applications/networking/irc/irssi {
    # compile with gccApple on darwin to support the -no-cpp-precompile flag
    stdenv = if stdenv.isDarwin
      then stdenvAdapters.overrideGCC stdenv gccApple
      else stdenv;
  };

  irssi_fish = callPackage ../applications/networking/irc/irssi/fish { };

  irssi_otr = callPackage ../applications/networking/irc/irssi/otr { };

  bip = callPackage ../applications/networking/irc/bip { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jack_oscrolloscope = callPackage ../applications/audio/jack-oscrolloscope { };

  jack_rack = callPackage ../applications/audio/jack-rack { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jalv = callPackage ../applications/audio/jalv { };

  jedit = callPackage ../applications/editors/jedit { };

  jigdo = callPackage ../applications/misc/jigdo { };

  joe = callPackage ../applications/editors/joe { };

  jbrout = callPackage ../applications/graphics/jbrout {
    inherit (pythonPackages) lxml;
  };

  jwm = callPackage ../applications/window-managers/jwm { };

  k3d = callPackage ../applications/graphics/k3d {
    inherit (pkgs.gnome2) gtkglext;
  };

  keepnote = callPackage ../applications/office/keepnote {
    pygtk = pyGtkGlade;
  };

  kermit = callPackage ../tools/misc/kermit { };

  keymon = callPackage ../applications/video/key-mon { };

  kino = callPackage ../applications/video/kino {
    inherit (gnome) libglade;
  };

  lame = callPackage ../applications/audio/lame { };

  larswm = callPackage ../applications/window-managers/larswm { };

  lash = callPackage ../applications/audio/lash { };

  ladspaH = callPackage ../applications/audio/ladspa-plugins/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  caps = callPackage ../applications/audio/caps { };

  lastwatch = callPackage ../applications/audio/lastwatch { };

  lbdb = callPackage ../tools/misc/lbdb { };

  lci = callPackage ../applications/science/logic/lci {};

  ldcpp = callPackage ../applications/networking/p2p/ldcpp {
    inherit (gnome) libglade;
  };

  librecad = callPackage ../applications/misc/librecad { };

  librecad2 = callPackage ../applications/misc/librecad/2.0.nix { };

  libreoffice = callPackage ../applications/office/libreoffice {
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2 gnome_vfs;
    zip = zip.override { enableNLS = false; };
    boost = boost149;
    jdk = openjdk;
    fontsConf = makeFontsConf {
      fontDirectories = [
        freefont_ttf xorg.fontmiscmisc xorg.fontbhttf
      ];
    };
    poppler = poppler_0_18;
    clucene_core = clucene_core_2;
    lcms = lcms2;
  };

  liferea = callPackage ../applications/networking/newsreaders/liferea { };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome) libglade;
  };

  links = callPackage ../applications/networking/browsers/links { };

  ledger = callPackage ../applications/office/ledger/2.6.3.nix { };
  ledger3 = callPackage ../applications/office/ledger/3.0.nix { };

  links2 = callPackage ../applications/networking/browsers/links2 { };

  linphone = callPackage ../applications/networking/instant-messengers/linphone rec {
    inherit (gnome) libglade;
    libexosip = libexosip_3;
    libosip = libosip_3;
  };

  linuxsampler = callPackage ../applications/audio/linuxsampler { };

  lmms = callPackage ../applications/audio/lmms { };

  lxdvdrip = callPackage ../applications/video/lxdvdrip { };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = callPackage ../applications/misc/lyx { };

  makeself = callPackage ../applications/misc/makeself { };

  matchbox = callPackage ../applications/window-managers/matchbox { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  meld = callPackage ../applications/version-management/meld {
    inherit (gnome) scrollkeeper;
    pygtk = pyGtkGlade;
  };

  mcomix = callPackage ../applications/graphics/mcomix { };

  mercurial = callPackage ../applications/version-management/mercurial {
    inherit (pythonPackages) curses docutils;
    guiSupport = false; # use mercurialFull to get hgk GUI
  };

  mercurialFull = lowPrio (appendToName "full" (pkgs.mercurial.override { guiSupport = true; }));

  merkaartor = callPackage ../applications/misc/merkaartor { };

  meshlab = callPackage ../applications/graphics/meshlab { };

  mhwaveedit = callPackage ../applications/audio/mhwaveedit {};

  mid2key = callPackage ../applications/audio/mid2key { };

  midori = builderDefsPackage (import ../applications/networking/browsers/midori) {
    inherit imagemagick intltool python pkgconfig webkit libxml2
      which gettext makeWrapper file libidn sqlite docutils libnotify
      vala dbus_glib glib_networking;
    inherit gtk3 glib;
    inherit (gnome) gtksourceview;
    inherit (webkit.passthru.args) libsoup;
    inherit (xlibs) kbproto xproto libXScrnSaver scrnsaverproto;
  };

  midoriWrapper = wrapFirefox
    { browser = midori; browserName = "midori"; desktopName = "Midori";
      icon = "${midori}/share/icons/hicolor/22x22/apps/midori.png";
    };

  mikmod = callPackage ../applications/audio/mikmod { };

  minicom = callPackage ../tools/misc/minicom { };

  minidjvu = callPackage ../applications/graphics/minidjvu { };

  mirage = callPackage ../applications/graphics/mirage {};

  mixxx = callPackage ../applications/audio/mixxx {
    inherit (vamp) vampSDK;
  };

  mmex = callPackage ../applications/office/mmex { };

  monkeysAudio = callPackage ../applications/audio/monkeys-audio { };

  monodevelop = callPackage ../applications/editors/monodevelop {
    inherit (gnome) gnome_vfs libbonobo libglade libgnome GConf;
    mozilla = firefox;
    gtksharp = gtksharp2;
  };

  monodoc = callPackage ../applications/editors/monodoc {
    gtksharp = gtksharp1;
  };

  monotone = callPackage ../applications/version-management/monotone {
    lua = lua5;
    boost = boost149;
  };

  monotoneViz = builderDefsPackage (import ../applications/version-management/monotone-viz/mtn-head.nix) {
    inherit ocaml graphviz pkgconfig autoconf automake libtool glib gtk;
    inherit (ocamlPackages) lablgtk;
    inherit (gnome) libgnomecanvas;
  };

  mopidy = callPackage ../applications/audio/mopidy { };

  mozilla = callPackage ../applications/networking/browsers/mozilla {
    inherit (gnome) libIDL;
  };

  mozplugger = builderDefsPackage (import ../applications/networking/browsers/mozilla-plugins/mozplugger) {
    inherit firefox;
    inherit (xlibs) libX11 xproto;
  };

  easytag = callPackage ../applications/audio/easytag { };

  mp3info = callPackage ../applications/audio/mp3info { };

  mpc123 = callPackage ../applications/audio/mpc123 { };

  mpg123 = callPackage ../applications/audio/mpg123 { };

  mpg321 = callPackage ../applications/audio/mpg321 { };

  mpc_cli = callPackage ../applications/audio/mpc { };

  ncmpcpp = callPackage ../applications/audio/ncmpcpp { };

  normalize = callPackage ../applications/audio/normalize { };

  mplayer = callPackage ../applications/video/mplayer {
    pulseSupport = config.pulseaudio or false;
  };

  mplayer2 = callPackage ../applications/video/mplayer2 {
    ffmpeg = ffmpeg_1;
  };

  MPlayerPlugin = browser:
    import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      inherit fetchurl stdenv pkgconfig gettext;
      inherit (xlibs) libXpm;
      # !!! should depend on MPlayer
    };

  mrxvt = callPackage ../applications/misc/mrxvt { };

  multisync = callPackage ../applications/misc/multisync {
    inherit (gnome) ORBit2 libbonobo libgnomeui GConf;
  };

  mumble = callPackage ../applications/networking/mumble {
    avahi = avahi.override {
      withLibdnssdCompat = true;
    };
    jackSupport = config.mumble.jackSupport or false;
  };

  mutt = callPackage ../applications/networking/mailreaders/mutt { };

  ruby_gpgme = callPackage ../development/libraries/ruby_gpgme {
    ruby = ruby19;
    hoe = rubyLibs.hoe;
  };

  ruby_ncursesw_sup = callPackage ../development/libraries/ruby_ncursesw_sup { };

  smplayer = callPackage ../applications/video/smplayer { };

  sup = with rubyLibs; callPackage ../applications/networking/mailreaders/sup {
    ruby = ruby19.override {
      cursesSupport = true;
    };

    inherit gettext highline iconv locale lockfile mime_types rmail_sup text
      trollop unicode xapian_ruby which;

    chronic      = chronic_0_9_1;
    gpgme        = ruby_gpgme;
    ncursesw_sup = ruby_ncursesw_sup;
    rake         = rake_10_1_0;
  };

  msmtp = callPackage ../applications/networking/msmtp { };

  imapfilter = callPackage ../applications/networking/mailreaders/imapfilter.nix {
    lua = lua5;
 };

  mupdf = callPackage ../applications/misc/mupdf { };

  mypaint = callPackage ../applications/graphics/mypaint { };

  mythtv = callPackage ../applications/video/mythtv { };

  tvtime = callPackage ../applications/video/tvtime {
    kernel = linux;
  };

  nano = callPackage ../applications/editors/nano { };

  navipowm = callPackage ../applications/misc/navipowm { };

  navit = callPackage ../applications/misc/navit { };

  netbeans = callPackage ../applications/editors/netbeans { };

  ncdu = callPackage ../tools/misc/ncdu { };

  nedit = callPackage ../applications/editors/nedit {
    motif = lesstif;
  };

  netsurfBrowser = netsurf.browser;
  netsurf = recurseIntoAttrs (import ../applications/networking/browsers/netsurf { inherit pkgs; });

  notmuch = callPackage ../applications/networking/mailreaders/notmuch {
    # use emacsPackages.notmuch if you want emacs support
    emacs = null;
  };

  nova = callPackage ../applications/virtualization/nova { };

  novaclient = callPackage ../applications/virtualization/nova/client.nix { };

  nspluginwrapper = callPackage ../applications/networking/browsers/mozilla-plugins/nspluginwrapper {};

  nvi = callPackage ../applications/editors/nvi { };

  nvpy = callPackage ../applications/editors/nvpy { };

  ocrad = callPackage ../applications/graphics/ocrad { };

  offrss = callPackage ../applications/networking/offrss { };

  ogmtools = callPackage ../applications/video/ogmtools { };

  omxplayer = callPackage ../applications/video/omxplayer {
    stdenv = overrideGCC stdenv gcc47;
  };

  oneteam = callPackage ../applications/networking/instant-messengers/oneteam {};

  openbox = callPackage ../applications/window-managers/openbox { };

  openimageio = callPackage ../applications/graphics/openimageio { };

  openjump = callPackage ../applications/misc/openjump { };

  openscad = callPackage ../applications/graphics/openscad {};

  opera = callPackage ../applications/networking/browsers/opera {
    inherit (pkgs.kde4) kdelibs;
  };

  opusTools = callPackage ../applications/audio/opus-tools { };

  pan = callPackage ../applications/networking/newsreaders/pan {
    spellChecking = false;
  };

  panotools = callPackage ../applications/graphics/panotools { };

  pavucontrol = callPackage ../applications/audio/pavucontrol { };

  paraview = callPackage ../applications/graphics/paraview { };

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome) libgnomecanvas;
  };

  pdftk = callPackage ../tools/typesetting/pdftk { };

  pianobar = callPackage ../applications/audio/pianobar { };

  pianobooster = callPackage ../applications/audio/pianobooster { };

  picard = callPackage ../applications/audio/picard { };

  picocom = callPackage ../tools/misc/picocom { };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    openssl = if config.pidgin.openssl or true then openssl else null;
    gnutls = if config.pidgin.gnutls or false then gnutls else null;
    libgcrypt = if config.pidgin.gnutls or false then libgcrypt else null;
    inherit (gnome) startupnotification;
  };

  pidginlatex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    imagemagick = imagemagickBig;
  };

  pidginlatexSF = builderDefsPackage
    (import ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex/pidgin-latex-sf.nix)
    {
      inherit pkgconfig pidgin texLive imagemagick which glib gtk;
    };

  pidginmsnpecan = callPackage ../applications/networking/instant-messengers/pidgin-plugins/msn-pecan { };

  pidginotr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidginsipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  toxprpl = callPackage ../applications/networking/instant-messengers/pidgin-plugins/tox-prpl { };

  pinfo = callPackage ../applications/misc/pinfo { };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtksharp2;
  };

  pommed = callPackage ../os-specific/linux/pommed {
    inherit (xorg) libXpm;
  };

  pqiv = callPackage ../applications/graphics/pqiv { };

  qiv = callPackage ../applications/graphics/qiv { };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = callPackage ../applications/misc/procmail { };

  pstree = callPackage ../applications/misc/pstree { };

  puredata = callPackage ../applications/audio/puredata { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qbittorrent = callPackage ../applications/networking/p2p/qbittorrent { };

  qemu = callPackage ../applications/virtualization/qemu { };

  qemuImage = callPackage ../applications/virtualization/qemu/linux-img { };

  qmmp = callPackage ../applications/audio/qmmp { };

  qsampler = callPackage ../applications/audio/qsampler { };

  qsynth = callPackage ../applications/audio/qsynth { };

  qtpfsgui = callPackage ../applications/graphics/qtpfsgui { };

  qtractor = callPackage ../applications/audio/qtractor { };

  quodlibet = callPackage ../applications/audio/quodlibet {
    inherit (pythonPackages) mutagen;
  };

  quodlibet-with-gst-plugins = callPackage ../applications/audio/quodlibet {
    inherit (pythonPackages) mutagen;
    withGstPlugins = true;
    gst_plugins_bad = null;
  };

  rakarrack = callPackage ../applications/audio/rakarrack {
    inherit (xorg) libXpm libXft;
    fltk = fltk13;
  };

  rapcad = callPackage ../applications/graphics/rapcad {};

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    fftw = fftw.override {float = true;};
  };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  recode = callPackage ../tools/text/recode { };

  retroshare = callPackage ../applications/networking/p2p/retroshare {
    qt = qt4;
  };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS || stdenv.isFreeBSD);
    enableCopyDevicesPatch = (config.rsync.enableCopyDevicesPatch or false);
  };

  rubyripper = callPackage ../applications/audio/rubyripper {};

  rxvt = callPackage ../applications/misc/rxvt { };

  # = urxvt
  rxvt_unicode = callPackage ../applications/misc/rxvt_unicode {
    perlSupport = true;
    gdkPixbufSupport = true;
  };

  sakura = callPackage ../applications/misc/sakura {
    inherit (gnome) vte;
  };

  sbagen = callPackage ../applications/misc/sbagen { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome) libart_lgpl;
  };

  seeks = callPackage ../tools/networking/p2p/seeks {
    opencv = opencv_2_1;
  };

  seg3d = callPackage ../applications/graphics/seg3d {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  seq24 = callPackage ../applications/audio/seq24 { };

  sflphone = callPackage ../applications/networking/instant-messengers/sflphone {
    gtk = gtk3;
  };

  siproxd = callPackage ../applications/networking/siproxd { };

  skype = callPackage_i686 ../applications/networking/instant-messengers/skype {
    usePulseAudio = config.pulseaudio or true;
  };

  skype4pidgin = callPackage ../applications/networking/instant-messengers/pidgin-plugins/skype4pidgin { };

  skype_call_recorder = callPackage ../applications/networking/instant-messengers/skype-call-recorder { };

  ssvnc = callPackage ../applications/networking/remote/ssvnc { };

  st = callPackage ../applications/misc/st {
    conf = config.st.conf or null;
  };

  sxiv = callPackage ../applications/graphics/sxiv { };

  bittorrentSync = callPackage ../applications/networking/bittorrentsync { };

  dropbox = callPackage ../applications/networking/dropbox { };

  dropbox-cli = callPackage ../applications/networking/dropbox-cli { };

  lightdm = callPackage ../applications/display-managers/lightdm { };

  lightdm_gtk_greeter = callPackage ../applications/display-managers/lightdm-gtk-greeter { };

  # slic3r 0.9.10b says: "Running Slic3r under Perl >= 5.16 is not supported nor recommended"
  slic3r = callPackage ../applications/misc/slic3r {
    inherit (perl514Packages) EncodeLocale MathClipper ExtUtilsXSpp
            BoostGeometryUtils MathConvexHullMonotoneChain MathGeometryVoronoi
            MathPlanePath Moo IOStringy ClassXSAccessor Wx GrowlGNTP NetDBus;
    perl = perl514;
  };

  slim = callPackage ../applications/display-managers/slim {
    libpng = libpng12;
  };

  sndBase = lowPrio (builderDefsPackage (import ../applications/audio/snd) {
    inherit fetchurl stdenv stringsWithDeps lib fftw;
    inherit pkgconfig gmp gettext;
    inherit (xlibs) libXpm libX11;
    inherit gtk glib;
  });

  snd = sndBase.passthru.function {
    inherit mesa libtool jackaudio alsaLib;
    guile = guile_1_8;
  };

  shntool = callPackage ../applications/audio/shntool { };

  sonic_visualiser = callPackage ../applications/audio/sonic-visualiser {
    inherit (pkgs.vamp) vampSDK;
    inherit (pkgs.xlibs) libX11;
    fftw = pkgs.fftwSinglePrec;
  };

  sox = callPackage ../applications/misc/audio/sox { };

  soxr = callPackage ../applications/misc/audio/soxr { };

  spotify = callPackage ../applications/audio/spotify {
    inherit (gnome) GConf;
    libpng = libpng12;
  };

  libspotify = callPackage ../development/libraries/libspotify {
    apiKey = config.libspotify.apiKey or null;
  };

  stalonetray = callPackage ../applications/window-managers/stalonetray {};

  stumpwm = lispPackages.stumpwm;

  sublime = callPackage ../applications/editors/sublime { };

  subversion = callPackage ../applications/version-management/subversion/default.nix {
    bdbSupport = true;
    httpServer = false;
    httpSupport = true;
    sslSupport = true;
    pythonBindings = false;
    perlBindings = false;
    javahlBindings = false;
    saslSupport = false;
    compressionSupport = true;
    httpd = apacheHttpd;
    sasl = cyrus_sasl;
  };

  subversionClient = lowPrio (appendToName "client" (subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  }));

  surf = callPackage ../applications/misc/surf {
    libsoup = gnome.libsoup;
    webkit = webkit_gtk2;
  };

  svk = perlPackages.SVK;

  swh_lv2 = callPackage ../applications/audio/swh-lv2 { };

  sylpheed = callPackage ../applications/networking/mailreaders/sylpheed {
    sslSupport = true;
    gpgSupport = true;
  };

  # linux only by now
  synergy = callPackage ../applications/misc/synergy { };

  tabbed = callPackage ../applications/window-managers/tabbed { };

  tahoelafs = callPackage ../tools/networking/p2p/tahoe-lafs {
    inherit (pythonPackages) twisted foolscap simplejson nevow zfec
      pycryptopp pysqlite darcsver setuptoolsTrial setuptoolsDarcs
      numpy pyasn1 mock;
  };

  tailor = builderDefsPackage (import ../applications/version-management/tailor) {
    inherit makeWrapper python;
  };

  tangogps = callPackage ../applications/misc/tangogps {
    gconf = gnome.GConf;
  };

  teamspeak_client = callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };

  taskjuggler = callPackage ../applications/misc/taskjuggler { };

  taskwarrior = callPackage ../applications/misc/taskwarrior { };

  telepathy_gabble = callPackage ../applications/networking/instant-messengers/telepathy/gabble {
    inherit (pkgs.gnome) libsoup;
  };

  telepathy_haze = callPackage ../applications/networking/instant-messengers/telepathy/haze {};

  telepathy_logger = callPackage ../applications/networking/instant-messengers/telepathy/logger {};

  telepathy_mission_control = callPackage ../applications/networking/instant-messengers/telepathy/mission-control { };

  telepathy_rakia = callPackage ../applications/networking/instant-messengers/telepathy/rakia { };

  telepathy_salut = callPackage ../applications/networking/instant-messengers/telepathy/salut {};

  tesseract = callPackage ../applications/graphics/tesseract { };

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  thunderbird = callPackage ../applications/networking/mailreaders/thunderbird {
    inherit (gnome) libIDL;
  };

  tig = gitAndTools.tig;

  timidity = callPackage ../tools/misc/timidity { };

  tkcvs = callPackage ../applications/version-management/tkcvs { };

  tla = callPackage ../applications/version-management/arch { };

  torchat = callPackage ../applications/networking/instant-messengers/torchat {
    wrapPython = pythonPackages.wrapPython;
  };

  toxic = callPackage ../applications/networking/instant-messengers/toxic { };

  transmission = callPackage ../applications/networking/p2p/transmission { };
  transmission_gtk = transmission.override { enableGTK3 = true; };

  transmission_remote_gtk = callPackage ../applications/networking/p2p/transmission-remote-gtk {};

  trayer = callPackage ../applications/window-managers/trayer { };

  tree = callPackage ../tools/system/tree {
    # use gccApple to compile on darwin as the configure script adds a
    # -no-cpp-precomp flag, which is not compatible with the default gcc
    stdenv = if stdenv.isDarwin
      then stdenvAdapters.overrideGCC stdenv gccApple
      else stdenv;
  };

  tribler = callPackage ../applications/networking/p2p/tribler { };

  twinkle = callPackage ../applications/networking/instant-messengers/twinkle {
    ccrtp = ccrtp_1_8;
    libzrtpcpp = libzrtpcpp_1_6;
  };

  umurmur = callPackage ../applications/networking/umurmur { };

  unison = callPackage ../applications/networking/sync/unison {
    inherit (ocamlPackages) lablgtk;
    enableX11 = config.unison.enableX11 or true;
  };

  uucp = callPackage ../tools/misc/uucp { };

  uwimap = callPackage ../tools/networking/uwimap { };

  uzbl = builderDefsPackage (import ../applications/networking/browsers/uzbl) {
    inherit pkgconfig webkit makeWrapper glib_networking python3;
    inherit glib pango cairo gdk_pixbuf atk;
    inherit (xlibs) libX11 kbproto;
    inherit (gnome) libsoup;
    gtk = gtk3;
  };

  vanitygen = callPackage ../applications/misc/vanitygen { };

  vbindiff = callPackage ../applications/editors/vbindiff { };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  veracity = callPackage ../applications/version-management/veracity {};

  viewMtn = builderDefsPackage (import ../applications/version-management/viewmtn/0.10.nix)
  {
    inherit monotone cheetahTemplate highlight ctags
      makeWrapper graphviz which python;
    flup = pythonPackages.flup;
  };

  vim = callPackage ../applications/editors/vim {
    # for Objective-C compilation
    stdenv = if stdenv.isDarwin
      then clangStdenv
      else stdenv;
  };

  vimHugeX = vim_configurable;

  vim_configurable = callPackage ../applications/editors/vim/configurable.nix {
    inherit (pkgs) fetchurl stdenv ncurses pkgconfig gettext
      composableDerivation lib config glib gtk python perl tcl ruby;
    inherit (pkgs.xlibs) libX11 libXext libSM libXpm libXt libXaw libXau libXmu
      libICE;

    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    gui = config.vim.gui or "auto";

    # optional features by flags
    flags = [ "python" "X11" ]; # only flag "X11" by now

    # so that we can use gccApple if we're building on darwin
    inherit stdenvAdapters gccApple;
  };

  vimNox = lowPrio (vim_configurable.override { source = "vim-nox"; });

  qvim = lowPrio (callPackage ../applications/editors/vim/qvim.nix {
    inherit (pkgs) fetchgit stdenv ncurses pkgconfig gettext
      composableDerivation lib config python perl tcl ruby qt4;
    inherit (pkgs.xlibs) libX11 libXext libSM libXpm libXt libXaw libXau libXmu
      libICE;

    inherit (pkgs) stdenvAdapters gccApple;

    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5;
    flags = [ "python" "X11" ]; # only flag "X11" by now
  });

  virtviewer = callPackage ../applications/virtualization/virt-viewer {};
  virtmanager = callPackage ../applications/virtualization/virt-manager {
    inherit (gnome) gnome_python;
    vte = gnome.vte.override { pythonSupport = true; };
  };

  virtinst = callPackage ../applications/virtualization/virtinst {};

  virtualgl = callPackage ../tools/X11/virtualgl { };

  bumblebee = callPackage ../tools/X11/bumblebee { };

  vkeybd = callPackage ../applications/audio/vkeybd {
    inherit (xlibs) libX11;
  };

  vlc = callPackage ../applications/video/vlc {
    ffmpeg = ffmpeg_1;
  };

  vnstat = callPackage ../applications/networking/vnstat { };

  vorbisTools = callPackage ../applications/audio/vorbis-tools { };

  vue = callPackage ../applications/misc/vue {};

  vwm = callPackage ../applications/window-managers/vwm { };

  w3m = callPackage ../applications/networking/browsers/w3m {
    graphicsSupport = false;
  };

  weechat = callPackage ../applications/networking/irc/weechat {
    # weechat crashes on /exit when using gnutls 3.1.x. gnutls 3.2.x works.
    gnutls = gnutls32;
  };

  weston = callPackage ../applications/window-managers/weston {
    cairo = cairo.override {
      glSupport = true;
    };
  };

  windowmaker = callPackage ../applications/window-managers/windowmaker { };

  winswitch = callPackage ../tools/X11/winswitch { };

  wings = callPackage ../applications/graphics/wings {
    erlang = erlangR14B04;
    esdl = esdl.override { erlang = erlangR14B04; };
  };

  wmname = callPackage ../applications/misc/wmname { };

  wmctrl = callPackage ../tools/X11/wmctrl { };

  # I'm keen on wmiimenu only  >wmii-3.5 no longer has it...
  wmiimenu = import ../applications/window-managers/wmii31 {
    libixp = libixp_for_wmii;
    inherit fetchurl /* fetchhg */ stdenv gawk;
    inherit (xlibs) libX11;
  };

  wmiiSnap = import ../applications/window-managers/wmii {
    libixp = libixp_for_wmii;
    inherit fetchurl /* fetchhg */ stdenv gawk;
    inherit (xlibs) libX11 xextproto libXt libXext;
    includeUnpack = config.stdenv.includeUnpack or false;
  };

  wordnet = callPackage ../applications/misc/wordnet { };

  wrapChromium = browser: wrapFirefox {
    inherit browser;
    browserName = browser.packageName;
    desktopName = "Chromium";
    icon = "${browser}/share/icons/hicolor/48x48/apps/${browser.packageName}.png";
  };

  wrapFirefox =
    { browser, browserName ? "firefox", desktopName ? "Firefox", nameSuffix ? ""
    , icon ? "${browser}/lib/${browser.name}/icons/mozicon128.png" }:
    let
      cfg = stdenv.lib.attrByPath [ browserName ] {} config;
      enableAdobeFlash = cfg.enableAdobeFlash or true;
      enableGnash = cfg.enableGnash or false;
    in
    import ../applications/networking/browsers/firefox/wrapper.nix {
      inherit stdenv lib makeWrapper makeDesktopItem browser browserName desktopName nameSuffix icon;
      plugins =
         assert !(enableGnash && enableAdobeFlash);
         ([ ]
          ++ lib.optional enableGnash gnash
          ++ lib.optional enableAdobeFlash flashplayer
          ++ lib.optional (cfg.enableDjvu or false) (djview4)
          ++ lib.optional (cfg.enableMPlayer or false) (MPlayerPlugin browser)
          ++ lib.optional (cfg.enableGeckoMediaPlayer or false) gecko_mediaplayer
          ++ lib.optional (supportsJDK && cfg.jre or false && jrePlugin ? mozillaPlugin) jrePlugin
          ++ lib.optional (cfg.enableGoogleTalkPlugin or false) google_talk_plugin
          ++ lib.optional (cfg.enableFriBIDPlugin or false) fribid
         );
      libs =
        if cfg.enableQuakeLive or false
        then with xlibs; [ stdenv.gcc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib ]
        else [ ];
      gtk_modules = [ libcanberra ];
    };

  x11vnc = callPackage ../tools/X11/x11vnc { };

  x2vnc = callPackage ../tools/X11/x2vnc { };

  xaos = builderDefsPackage (import ../applications/graphics/xaos) {
    inherit (xlibs) libXt libX11 libXext xextproto xproto;
    inherit gsl aalib zlib intltool gettext perl;
    libpng = libpng12;
  };

  xara = callPackage ../applications/graphics/xara { };

  xawtv = callPackage ../applications/video/xawtv { };

  xbindkeys = callPackage ../tools/X11/xbindkeys { };

  xbmc = callPackage ../applications/video/xbmc { };

  xca = callPackage ../applications/misc/xca { };

  xcalib = callPackage ../tools/X11/xcalib { };

  xcape = callPackage ../tools/X11/xcape { };

  xchainkeys = callPackage ../tools/X11/xchainkeys { };

  xchat = callPackage ../applications/networking/irc/xchat { };

  xchm = callPackage ../applications/misc/xchm { };

  xcompmgr = callPackage ../applications/window-managers/xcompmgr { };

  compton = callPackage ../applications/window-managers/compton { };

  xdaliclock = callPackage ../tools/misc/xdaliclock {};

  xdg_utils = callPackage ../tools/X11/xdg-utils { };

  xdotool = callPackage ../tools/X11/xdotool { };

  xen = callPackage ../applications/virtualization/xen { };

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

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gnome) libgnomeprint libgnomeprintui libgnomecanvas;
  };

  xpdf = callPackage ../applications/misc/xpdf {
    motif = lesstif;
    base14Fonts = "${ghostscript}/share/ghostscript/fonts";
  };

  xkb_switch = callPackage ../tools/X11/xkb-switch { };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra { };

  xrestop = callPackage ../tools/X11/xrestop { };

  xscreensaver = callPackage ../misc/screensavers/xscreensaver {
    inherit (gnome) libglade;
  };

  xsynth_dssi = callPackage ../applications/audio/xsynth-dssi { };

  xterm = callPackage ../applications/misc/xterm { };

  xtrace = callPackage ../tools/X11/xtrace { };

  xlaunch = callPackage ../tools/X11/xlaunch { };

  xmacro = callPackage ../tools/X11/xmacro { };

  xmove = callPackage ../applications/misc/xmove { };

  xnee = callPackage ../tools/X11/xnee {
    # Work around "missing separator" error.
    stdenv = overrideInStdenv stdenv [ gnumake381 ];
  };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gnome) scrollkeeper libglade;
  };

  yate = callPackage ../applications/misc/yate { };

  qgis = callPackage ../applications/misc/qgis {};

  yoshimi = callPackage ../applications/audio/yoshimi {
    fltk = fltk13;
  };

  zathuraCollection = recurseIntoAttrs
    (let callPackage = newScope pkgs.zathuraCollection; in
      import ../applications/misc/zathura { inherit callPackage pkgs fetchurl; });

  zathura = zathuraCollection.zathuraWrapper;

  girara = callPackage ../applications/misc/girara { };

  zgrviewer = callPackage ../applications/graphics/zgrviewer {};

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx { };


  ### GAMES

  alienarena = callPackage ../games/alienarena { };

  andyetitmoves = if stdenv.isLinux then callPackage ../games/andyetitmoves {} else null;

  anki = callPackage ../games/anki { };

  asc = callPackage ../games/asc {
    lua = lua5;
    libsigcxx = libsigcxx12;
  };

  atanks = callPackage ../games/atanks {};

  ballAndPaddle = callPackage ../games/ball-and-paddle {
    guile = guile_1_8;
  };

  bitsnbots = callPackage ../games/bitsnbots {
    lua = lua5;
  };

  blackshades = callPackage ../games/blackshades { };

  blackshadeselite = callPackage ../games/blackshadeselite { };

  blobby = callPackage ../games/blobby {
    boost = boost149;
  };

  bsdgames = callPackage ../games/bsdgames { };

  btanks = callPackage ../games/btanks { };

  bzflag = callPackage ../games/bzflag { };

  castle_combat = callPackage ../games/castle-combat { };

  construoBase = lowPrio (callPackage ../games/construo {
    mesa = null;
    freeglut = null;
  });

  construo = construoBase.override {
    inherit mesa freeglut;
  };

  crack_attack = callPackage ../games/crack-attack { };

  crrcsim = callPackage ../games/crrcsim {};

  dhewm3 = callPackage ../games/dhewm3 {};

  drumkv1 = callPackage ../applications/audio/drumkv1 { };

  dwarf_fortress = callPackage_i686 ../games/dwarf-fortress {
    SDL_image = pkgsi686Linux.SDL_image.override {
      libpng = pkgsi686Linux.libpng12;
    };
  };

  dwarf_fortress_modable = appendToName "moddable" (dwarf_fortress.override {
    copyDataDirectory = true;
  });

  dwarf-therapist = callPackage ../games/dwarf-therapist { };

  d1x_rebirth = callPackage ../games/d1x-rebirth { };

  d2x_rebirth = callPackage ../games/d2x-rebirth { };

  eduke32 = callPackage ../games/eduke32 {
    stdenv = overrideGCC stdenv gcc47;
  };

  egoboo = callPackage ../games/egoboo { };

  exult = callPackage ../games/exult {
    stdenv = overrideGCC stdenv gcc42;
    libpng = libpng12;
  };

  flightgear = callPackage ../games/flightgear { };

  freeciv = callPackage ../games/freeciv { };

  freeciv_gtk = callPackage ../games/freeciv {
    gtkClient = true;
    sdlClient = false;
  };

  freedink = callPackage ../games/freedink { };

  fsg = callPackage ../games/fsg {
    wxGTK = wxGTK28.override { unicode = false; };
  };

  gemrb = callPackage ../games/gemrb { };

  gl117 = callPackage ../games/gl-117 {};

  glestae = callPackage ../games/glestae {};

  globulation2 = callPackage ../games/globulation {};

  gltron = callPackage ../games/gltron { };

  gnuchess = callPackage ../games/gnuchess { };

  gnugo = callPackage ../games/gnugo { };

  gparted = callPackage ../tools/misc/gparted { };

  gsmartcontrol = callPackage ../tools/misc/gsmartcontrol {
    inherit (gnome) libglademm;
  };

  gtypist = callPackage ../games/gtypist { };

  hexen = callPackage ../games/hexen { };

  icbm3d = callPackage ../games/icbm3d { };

  instead = callPackage ../games/instead {
    lua = lua5;
  };

  kobodeluxe = callPackage ../games/kobodeluxe { };

  lincity = builderDefsPackage (import ../games/lincity) {
    inherit (xlibs) libX11 libXext xextproto
      libICE libSM xproto;
    inherit libpng zlib;
  };

  lincity_ng = callPackage ../games/lincity/ng.nix {};

  mars = callPackage ../games/mars { };

  micropolis = callPackage ../games/micropolis { };

  naev = callPackage ../games/naev { };

  njam = callPackage ../games/njam { };

  oilrush = callPackage ../games/oilrush { };

  openttd = callPackage ../games/openttd {
    zlib = zlibStatic;
  };

  opentyrian = callPackage ../games/opentyrian { };

  pingus = callPackage ../games/pingus {};

  pioneers = callPackage ../games/pioneers { };

  pong3d = callPackage ../games/pong3d { };

  prboom = callPackage ../games/prboom { };

  quake3demo = callPackage ../games/quake3/wrapper {
    name = "quake3-demo-${quake3game.name}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    game = quake3game;
    paks = [quake3demodata];
  };

  quake3demodata = callPackage ../games/quake3/demo { };

  quake3game = callPackage ../games/quake3/game { };

  quantumminigolf = callPackage ../games/quantumminigolf {};

  racer = callPackage ../games/racer { };

  residualvm = callPackage ../games/residualvm {
    openglSupport = mesaSupported;
  };

  rigsofrods = callPackage ../games/rigsofrods {
    mygui = myguiSvn;
  };

  rili = callPackage ../games/rili { };

  rogue = callPackage ../games/rogue { };

  samplv1 = callPackage ../applications/audio/samplv1 { };

  sauerbraten = callPackage ../games/sauerbraten {};

  scid = callPackage ../games/scid { };

  scummvm = callPackage ../games/scummvm { };

  scorched3d = callPackage ../games/scorched3d { };

  sdlmame = callPackage ../games/sdlmame { };

  sgtpuzzles = builderDefsPackage (import ../games/sgt-puzzles) {
    inherit pkgconfig fetchsvn perl gtk;
    inherit (xlibs) libX11;
  };

  simutrans = callPackage ../games/simutrans { };

  soi = callPackage ../games/soi {};

  # You still can override by passing more arguments.
  spaceOrbit = callPackage ../games/orbit { };

  spring = callPackage ../games/spring { };

  springLobby = callPackage ../games/spring/springlobby.nix { };

  stardust = callPackage ../games/stardust {};

  steam = callPackage_i686 ../games/steam {};

  steamChrootEnv = callPackage_i686 ../games/steam/chrootenv.nix {
    zenity = gnome2.zenity;
  };

  stuntrally = callPackage ../games/stuntrally { };

  superTux = callPackage ../games/super-tux { };

  superTuxKart = callPackage ../games/super-tux-kart { };

  synthv1 = callPackage ../applications/audio/synthv1 { };

  tbe = callPackage ../games/the-butterfly-effect {};

  teetertorture = callPackage ../games/teetertorture { };

  teeworlds = callPackage ../games/teeworlds { };

  tennix = callPackage ../games/tennix { };

  tpm = callPackage ../games/thePenguinMachine { };

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

  ufoai = callPackage ../games/ufoai { };

  ultimatestunts = callPackage ../games/ultimatestunts { };

  ultrastardx = callPackage ../games/ultrastardx {
    lua = lua5;
  };

  unvanquished = callPackage ../games/unvanquished { };

  uqm = callPackage ../games/uqm { };

  urbanterror = callPackage ../games/urbanterror { };

  ut2004demo = callPackage ../games/ut2004demo { };

  vdrift = callPackage ../games/vdrift { };

  vectoroids = callPackage ../games/vectoroids { };

  vessel = callPackage_i686 ../games/vessel { };

  warmux = callPackage ../games/warmux { };

  warsow = callPackage ../games/warsow {
    libjpeg = libjpeg62;
  };

  warzone2100 = callPackage ../games/warzone2100 { };

  widelands = callPackage ../games/widelands {
    libpng = libpng12;
  };

  worldofgoo_demo = callPackage ../games/worldofgoo {
    demo = true;
  };

  worldofgoo = callPackage ../games/worldofgoo { };

  xboard =  callPackage ../games/xboard { };

  xconq = callPackage ../games/xconq {};

  # TODO: the corresponding nix file is missing
  # xracer = callPackage ../games/xracer { };

  xonotic = callPackage ../games/xonotic { };

  xsokoban = builderDefsPackage (import ../games/xsokoban) {
    inherit (xlibs) libX11 xproto libXpm libXt;
  };

  zdoom = callPackage ../games/zdoom { };

  zod = callPackage ../games/zod { };

  zoom = callPackage ../games/zoom { };

  keen4 = callPackage ../games/keen4 { };


  ### DESKTOP ENVIRONMENTS

  enlightenment = callPackage ../desktops/enlightenment { };

  e17 = recurseIntoAttrs (
    let callPackage = newScope pkgs.e17; in
    import ../desktops/e17 { inherit callPackage pkgs; }
  );

  gnome2 = callPackage ../desktops/gnome-2 {
    callPackage = pkgs.newScope pkgs.gnome2;
    self = pkgs.gnome2;
  }  // pkgs.gtkLibs // {
    # Backwards compatibility;
    inherit (pkgs) libsoup libwnck gtk_doc gnome_doc_utils;
  };

  gnome3 = recurseIntoAttrs (callPackage ../desktops/gnome-3 {
    callPackage = pkgs.newScope pkgs.gnome3;
    self = pkgs.gnome3;
  });

  gnome = recurseIntoAttrs gnome2;

  hsetroot = callPackage ../tools/X11/hsetroot { };

  kde4 = recurseIntoAttrs pkgs.kde410;

  kde410 = kdePackagesFor (pkgs.kde410 // {
      boost = boost149;
      eigen = eigen2;
      libotr = libotr_3_2;
      libusb = libusb1;
      ffmpeg = ffmpeg_1;
      libcanberra = libcanberra_kde;
    }) ../desktops/kde-4.10;

 kde411 = kdePackagesFor (pkgs.kde411 // {
      boost = boost149;
      eigen = eigen2;
      libotr = libotr_3_2;
      libusb = libusb1;
      ffmpeg = ffmpeg_1;
      libcanberra = libcanberra_kde;
    }) ../desktops/kde-4.11;

  kdePackagesFor = self: dir:
    let callPackageOrig = callPackage; in
    let
      callPackage = newScope self;
      kde4 = callPackageOrig dir {
        inherit callPackage callPackageOrig;
      };
    in kde4 // {
      inherit kde4;

      wrapper = callPackage ../build-support/kdewrapper {};

      recurseForRelease = true;

      akunambol = callPackage ../applications/networking/sync/akunambol { };

      amarok = callPackage ../applications/audio/amarok { };

      bangarang = callPackage ../applications/video/bangarang { };

      basket = callPackage ../applications/office/basket { };

      bluedevil = callPackage ../tools/bluetooth/bluedevil { };

      calligra = callPackage ../applications/office/calligra { };

      digikam = if builtins.compareVersions "4.9" kde4.release == 1 then
          callPackage ../applications/graphics/digikam/2.nix { }
        else
          callPackage ../applications/graphics/digikam { };

      eventlist = callPackage ../applications/office/eventlist {};

      k3b = callPackage ../applications/misc/k3b { };

      kadu = callPackage ../applications/networking/instant-messengers/kadu { };

      kbibtex = callPackage ../applications/office/kbibtex { };

      kde_wacomtablet = callPackage ../applications/misc/kde-wacomtablet { };

      kdenlive = callPackage ../applications/video/kdenlive { };

      kdesvn = callPackage ../applications/version-management/kdesvn { };

      kdevelop = callPackage ../applications/editors/kdevelop { };

      kdevplatform = callPackage ../development/libraries/kdevplatform { };

      kdiff3 = callPackage ../tools/text/kdiff3 { };

      kile = callPackage ../applications/editors/kile { };

      kmplayer = callPackage ../applications/video/kmplayer { };

      kmymoney = callPackage ../applications/office/kmymoney { };

      kipi_plugins = callPackage ../applications/graphics/kipi-plugins { };

      konversation = callPackage ../applications/networking/irc/konversation { };

      kvirc = callPackage ../applications/networking/irc/kvirc { };

      krename = callPackage ../applications/misc/krename { };

      krusader = callPackage ../applications/misc/krusader { };

      ksshaskpass = callPackage ../tools/security/ksshaskpass {};

      ktorrent = callPackage ../applications/networking/p2p/ktorrent { };

      kuickshow = callPackage ../applications/graphics/kuickshow { };

      libalkimia = callPackage ../development/libraries/libalkimia { };

      libktorrent = callPackage ../development/libraries/libktorrent { };

      libkvkontakte = callPackage ../development/libraries/libkvkontakte { };

      liblikeback = callPackage ../development/libraries/liblikeback { };

      networkmanagement = callPackage ../tools/networking/networkmanagement { };

      partitionManager = callPackage ../tools/misc/partition-manager { };

      polkit_kde_agent = callPackage ../tools/security/polkit-kde-agent { };

      psi = callPackage ../applications/networking/instant-messengers/psi { };

      quassel = callPackage ../applications/networking/irc/quassel { };

      quasselDaemon = appendToName "daemon" (self.quassel.override {
        monolithic = false;
        daemon = true;
      });

      quasselClient = appendToName "client" (self.quassel.override {
        monolithic = false;
        client = true;
      });

      rekonq = callPackage ../applications/networking/browsers/rekonq { };

      kwebkitpart = callPackage ../applications/networking/browsers/kwebkitpart { };

      rsibreak = callPackage ../applications/misc/rsibreak { };

      semnotes = callPackage ../applications/misc/semnotes { };

      skrooge = callPackage ../applications/office/skrooge { };

      telepathy = callPackage ../applications/networking/instant-messengers/telepathy/kde {};

      yakuake = callPackage ../applications/misc/yakuake { };

      zanshin = callPackage ../applications/office/zanshin { };

      kwooty = callPackage ../applications/networking/newsreaders/kwooty { };
    };

  redshift = callPackage ../applications/misc/redshift {
    inherit (xorg) libX11 libXrandr libxcb randrproto libXxf86vm
      xf86vidmodeproto;
    inherit (gnome) GConf;
    inherit (pythonPackages) pyxdg;
    geoclue = geoclue2;
  };

  oxygen_gtk = callPackage ../misc/themes/gtk2/oxygen-gtk { };

  gtk_engines = callPackage ../misc/themes/gtk2/gtk-engines { };

  gtk-engine-murrine = callPackage ../misc/themes/gtk2/gtk-engine-murrine { };

  gnome_themes_standard = callPackage ../misc/themes/gnome-themes-standard { };

  mate-icon-theme = callPackage ../misc/themes/mate-icon-theme { };

  mate-themes = callPackage ../misc/themes/mate-themes { };

  xfce = xfce4_10;
  xfce4_10 = recurseIntoAttrs (import ../desktops/xfce { inherit pkgs newScope; });


  ### SCIENCE

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (xlibs) libXmu;
    inherit (pkgs.gnome) gtkglext;
  };

  xplanet = callPackage ../applications/science/astronomy/xplanet { };

  gravit = callPackage ../applications/science/astronomy/gravit { };

  spyder = callPackage ../applications/science/spyder {
    inherit (pythonPackages) pyflakes rope sphinx numpy scipy matplotlib; # recommended
    inherit (pythonPackages) ipython pep8; # optional
    inherit pylint;
  };

  stellarium = callPackage ../applications/science/astronomy/stellarium { };


  ### SCIENCE/GEOMETRY

  drgeo = builderDefsPackage (import ../applications/science/geometry/drgeo) {
    inherit (gnome) libglade;
    inherit libxml2 perl intltool libtool pkgconfig gtk;
    guile = guile_1_8;
  };

  tetgen = callPackage ../applications/science/geometry/tetgen { };


  ### SCIENCE/BIOLOGY

  alliance = callPackage ../applications/science/electronics/alliance {
    motif = lesstif;
  };

  arb = callPackage ../applications/science/biology/arb {
    lesstif = lesstif93;
    stdenv = overrideGCC stdenv gcc42;
  };

  archimedes = callPackage ../applications/science/electronics/archimedes { };

  biolib = callPackage ../development/libraries/science/biology/biolib { };

  emboss = callPackage ../applications/science/biology/emboss { };

  mrbayes = callPackage ../applications/science/biology/mrbayes { };

  ncbiCTools = builderDefsPackage ../development/libraries/ncbi {
    inherit tcsh mesa lesstif;
    inherit (xlibs) libX11 libXaw xproto libXt libSM libICE
      libXmu libXext;
  };

  ncbi_tools = callPackage ../applications/science/biology/ncbi-tools { };

  paml = callPackage ../applications/science/biology/paml { };

  pal2nal = callPackage ../applications/science/biology/pal2nal { };

  plink = callPackage ../applications/science/biology/plink/default.nix { };


  ### SCIENCE/MATH

  atlas = callPackage ../development/libraries/science/math/atlas {
    # The build process measures CPU capabilities and optimizes the
    # library to perform best on that particular machine. That is a
    # great feature, but it's of limited use with pre-built binaries
    # coming from a central build farm.
    tolerateCpuTimingInaccuracy = true;
  };

  blas = callPackage ../development/libraries/science/math/blas { };

  content = builderDefsPackage ../applications/science/math/content {
    inherit mesa lesstif;
    inherit (xlibs) libX11 libXaw xproto libXt libSM libICE
      libXmu libXext libXcursor;
  };

  jags = callPackage ../applications/science/math/jags { };

  liblapack = callPackage ../development/libraries/science/math/liblapack { };

  openblas = callPackage ../development/libraries/science/math/openblas { };

  mathematica = callPackage ../applications/science/math/mathematica { };

  ### SCIENCE/MOLECULAR-DYNAMICS

  gromacs = callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = true;
    fftw = fftwSinglePrec;
    cmake = cmakeCurses;
  };

  gromacsDouble = lowPrio (callPackage ../applications/science/molecular-dynamics/gromacs {
    singlePrec = false;
    fftw = fftw;
    cmake = cmakeCurses;
  });


  ### SCIENCE/LOGIC

  coq = callPackage ../applications/science/logic/coq {
    inherit (ocamlPackages) findlib lablgtk;
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  coq_8_3 = callPackage ../applications/science/logic/coq/8.3.nix {
    inherit (ocamlPackages) findlib lablgtk;
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  cvc3 = callPackage ../applications/science/logic/cvc3 {};

  ekrhyper = callPackage ../applications/science/logic/ekrhyper {};

  eprover = callPackage ../applications/science/logic/eprover {
    texLive = texLiveAggregationFun {
      paths = [
        texLive texLiveExtra
      ];
    };
  };

  ginac = callPackage ../applications/science/math/ginac { };

  hol = callPackage ../applications/science/logic/hol { };

  hol_light = callPackage ../applications/science/logic/hol_light {
    inherit (ocamlPackages) findlib;
    camlp5 = ocamlPackages.camlp5_strict;
  };

  isabelle = import ../applications/science/logic/isabelle {
    inherit (pkgs) stdenv fetchurl nettools perl polyml;
    inherit (pkgs.emacs24Packages) proofgeneral;
  };

  iprover = callPackage ../applications/science/logic/iprover {};

  leo2 = callPackage ../applications/science/logic/leo2 {};

  logisim = callPackage ../applications/science/logic/logisim {};

  matita = callPackage ../applications/science/logic/matita {
    ocaml = ocaml_3_11_2;
    inherit (ocamlPackages_3_11_2) findlib lablgtk ocaml_expat gmetadom ocaml_http
            lablgtkmathview ocaml_mysql ocaml_sqlite3 ocamlnet camlzip ocaml_pcre;
    ulex08 = ocamlPackages_3_11_2.ulex08.override { camlp5 = ocamlPackages_3_11_2.camlp5_5_transitional; };
  };

  matita_130312 = lowPrio (callPackage ../applications/science/logic/matita/130312.nix {
    inherit (ocamlPackages) findlib lablgtk ocaml_expat gmetadom ocaml_http
            ocaml_mysql ocamlnet ulex08 camlzip ocaml_pcre;
  });

  minisat = callPackage ../applications/science/logic/minisat {};

  opensmt = callPackage ../applications/science/logic/opensmt { };

  otter = callPackage ../applications/science/logic/otter {};

  picosat = callPackage ../applications/science/logic/picosat {};

  prover9 = callPackage ../applications/science/logic/prover9 { };

  satallax = callPackage ../applications/science/logic/satallax {};

  spass = callPackage ../applications/science/logic/spass {};

  ssreflect = callPackage ../applications/science/logic/ssreflect {
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  tptp = callPackage ../applications/science/logic/tptp {};


  ### SCIENCE / ELECTRONICS

  eagle = callPackage_i686 ../applications/science/electronics/eagle { };

  caneda = callPackage ../applications/science/electronics/caneda { };

  gtkwave = callPackage ../applications/science/electronics/gtkwave { };

  kicad = callPackage ../applications/science/electronics/kicad {
    wxGTK = wxGTK29;
  };

  ngspice = callPackage ../applications/science/electronics/ngspice { };

  qucs = callPackage ../applications/science/electronics/qucs { };

  xoscope = callPackage ../applications/science/electronics/xoscope { };


  ### SCIENCE / MATH

  ecm = callPackage ../applications/science/math/ecm { };

  eukleides = callPackage ../applications/science/math/eukleides { };

  gap = callPackage ../applications/science/math/gap { };

  maxima = callPackage ../applications/science/math/maxima { };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { };

  pari = callPackage ../applications/science/math/pari {};

  pspp = callPackage ../applications/science/math/pssp {
    inherit (gnome) libglade gtksourceview;
  };

  R = callPackage ../applications/science/math/R {
    inherit (xlibs) libX11 libXt;
    texLive = texLiveAggregationFun { paths = [ texLive texLiveExtra ]; };
  };

  singular = callPackage ../applications/science/math/singular {};

  scilab = callPackage ../applications/science/math/scilab {
    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  msieve = callPackage ../applications/science/math/msieve { };

  weka = callPackage ../applications/science/math/weka { };

  yacas = callPackage ../applications/science/math/yacas { };

  speedcrunch = callPackage ../applications/science/math/speedcrunch {
    qt = qt4;
    cmake = cmakeCurses;
  };


  ### SCIENCE / MISC

  boinc = callPackage ../applications/science/misc/boinc { };

  golly = callPackage ../applications/science/misc/golly { };

  simgrid = callPackage ../applications/science/misc/simgrid { };

  tulip = callPackage ../applications/science/misc/tulip { };

  vite = callPackage ../applications/science/misc/vite { };


  ### MISC

  atari800 = callPackage ../misc/emulators/atari800 { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  auctex = callPackage ../tools/typesetting/tex/auctex { };

  cups = callPackage ../misc/cups { libusb = libusb1; };

  cups_pdf_filter = callPackage ../misc/cups/pdf-filter.nix { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cupsBjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

  darcnes = callPackage ../misc/emulators/darcnes { };

  dbacl = callPackage ../tools/misc/dbacl { };

  dblatex = callPackage ../tools/typesetting/tex/dblatex {
    enableAllFeatures = false;
  };

  dblatexFull = appendToName "full" (dblatex.override {
    enableAllFeatures = true;
  });

  dosbox = callPackage ../misc/emulators/dosbox { };

  dpkg = callPackage ../tools/package-management/dpkg { };

  ekiga = newScope pkgs.gnome ../applications/networking/instant-messengers/ekiga { };

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  fakenes = callPackage ../misc/emulators/fakenes { };

  foldingathome = callPackage ../misc/foldingathome { };

  foo2zjs = callPackage ../misc/drivers/foo2zjs {};

  foomatic_filters = callPackage ../misc/drivers/foomatic-filters {};

  freestyle = callPackage ../misc/freestyle { };

  gajim = callPackage ../applications/networking/instant-messengers/gajim { };

  gensgs = callPackage_i686 ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript {
    x11Support = false;
    cupsSupport = config.ghostscript.cups or true;
    gnuFork = config.ghostscript.gnu or false;
  };

  ghostscriptX = appendToName "with-X" (ghostscript.override {
    x11Support = true;
  });

  guix = callPackage ../tools/package-management/guix { };

  gxemul = callPackage ../misc/gxemul { };

  hatari = callPackage ../misc/emulators/hatari { };

  hplip = callPackage ../misc/drivers/hplip { };

  # using the new configuration style proposal which is unstable
  jack1d = callPackage ../misc/jackaudio/jack1.nix { };

  jackaudio = callPackage ../misc/jackaudio { };

  keynav = callPackage ../tools/X11/keynav { };

  lazylist = callPackage ../tools/typesetting/tex/lazylist { };

  lilypond = callPackage ../misc/lilypond { guile = guile_1_8; };

  martyr = callPackage ../development/libraries/martyr { };

  maven = maven3;
  maven3 = callPackage ../misc/maven { jdk = openjdk; };

  mess = callPackage ../misc/emulators/mess {
    inherit (pkgs.gnome) GConf;
  };

  mupen64plus = callPackage ../misc/emulators/mupen64plus { };

  mupen64plus1_5 = callPackage ../misc/emulators/mupen64plus/1.5.nix { };

  nix = nixStable;

  nixStable = callPackage ../tools/package-management/nix {
    storeDir = config.nix.storeDir or "/nix/store";
    stateDir = config.nix.stateDir or "/nix/var";
  };

  nixUnstable = nixStable;
  /*
  nixUnstable = callPackage ../tools/package-management/nix/unstable.nix {
    storeDir = config.nix.storeDir or "/nix/store";
    stateDir = config.nix.stateDir or "/nix/var";
  };
  */

  nixops = callPackage ../tools/package-management/nixops { };

  nix-repl = callPackage ../tools/package-management/nix-repl { };

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

  latex2html = callPackage ../tools/typesetting/tex/latex2html/default.nix {
    tex = tetex;
  };

  lkproof = callPackage ../tools/typesetting/tex/lkproof { };

  mysqlWorkbench = newScope gnome ../applications/misc/mysql-workbench {
    lua = lua5;
    inherit (pythonPackages) pexpect paramiko;
  };

  opkg = callPackage ../tools/package-management/opkg { };

  pgadmin = callPackage ../applications/misc/pgadmin { };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = callPackage ../tools/typesetting/tex/pgf/1.x.nix { };

  pgf2 = callPackage ../tools/typesetting/tex/pgf/2.x.nix { };

  pgfplots = callPackage ../tools/typesetting/tex/pgfplots { };

  pjsip = callPackage ../applications/networking/pjsip { };

  polytable = callPackage ../tools/typesetting/tex/polytable { };

  uae = callPackage ../misc/emulators/uae { };

  putty = callPackage ../applications/networking/remote/putty { };

  retroarch = callPackage ../misc/emulators/retroarch { };

  rssglx = callPackage ../misc/screensavers/rss-glx { };

  xlockmore = callPackage ../misc/screensavers/xlockmore { };

  samsungUnifiedLinuxDriver = import ../misc/cups/drivers/samsung {
    inherit fetchurl stdenv;
    inherit cups ghostscript glibc patchelf;
    gcc = import ../development/compilers/gcc/4.4 {
      inherit stdenv fetchurl texinfo gmp mpfr noSysDirs gettext which;
      profiledCompiler = true;
    };
  };

  saneBackends = callPackage ../applications/graphics/sane/backends.nix {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
    hotplugSupport = config.sane.hotplugSupport or true;
    libusb = libusb1;
  };

  saneBackendsGit = callPackage ../applications/graphics/sane/backends-git.nix {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
    snapscanFirmware = config.sane.snapscanFirmware or null;
    hotplugSupport = config.sane.hotplugSupport or true;
  };

  saneFrontends = callPackage ../applications/graphics/sane/frontends.nix { };

  slock = callPackage ../misc/screensavers/slock { };

  sourceAndTags = import ../misc/source-and-tags {
    inherit pkgs stdenv unzip lib ctags;
    hasktags = haskellPackages.myhasktags;
  };

  splix = callPackage ../misc/cups/drivers/splix { };

  tetex = callPackage ../tools/typesetting/tex/tetex { libpng = libpng12; };

  tex4ht = callPackage ../tools/typesetting/tex/tex4ht { };

  texFunctions = import ../tools/typesetting/tex/nix pkgs;

  texLive = builderDefsPackage (import ../tools/typesetting/tex/texlive) {
    inherit builderDefs zlib bzip2 ncurses libpng ed lesstif ruby
      gd t1lib freetype icu perl expat curl xz pkgconfig zziplib texinfo
      libjpeg bison python fontconfig flex poppler graphite2 makeWrapper;
    inherit (xlibs) libXaw libX11 xproto libXt libXpm
      libXmu libXext xextproto libSM libICE;
    ghostscript = ghostscriptX;
    harfbuzz = harfbuzz.override {
      inherit icu graphite2;
    };
  };

  texLiveFull = lib.setName "texlive-full" (texLiveAggregationFun {
    paths = [ texLive texLiveExtra lmodern texLiveCMSuper texLiveLatexXColor
              texLivePGF texLiveBeamer texLiveModerncv tipa tex4ht texinfo5
              texLiveModerntimeline ];
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
    builderDefsPackage (import ../tools/typesetting/tex/texlive/aggregate.nix)
      ({inherit poppler perl makeWrapper;} // params);

  texDisser = callPackage ../tools/typesetting/tex/disser {};

  texLiveContext = builderDefsPackage (import ../tools/typesetting/tex/texlive/context.nix) {
    inherit texLive;
  };

  texLiveExtra = builderDefsPackage (import ../tools/typesetting/tex/texlive/extra.nix) {
    inherit texLive xz;
  };

  texLiveCMSuper = builderDefsPackage (import ../tools/typesetting/tex/texlive/cm-super.nix) {
    inherit texLive;
  };

  texLiveLatexXColor = builderDefsPackage (import ../tools/typesetting/tex/texlive/xcolor.nix) {
    inherit texLive;
  };

  texLivePGF = builderDefsPackage (import ../tools/typesetting/tex/texlive/pgf.nix) {
    inherit texLiveLatexXColor texLive;
  };

  texLiveBeamer = builderDefsPackage (import ../tools/typesetting/tex/texlive/beamer.nix) {
    inherit texLiveLatexXColor texLivePGF texLive;
  };

  texLiveModerncv = builderDefsPackage (import ../tools/typesetting/tex/texlive/moderncv.nix) {
    inherit texLive unzip;
  };

  texLiveModerntimeline = builderDefsPackage (import ../tools/typesetting/tex/texlive/moderntimeline.nix) {
    inherit texLive unzip;
  };

  thinkfan = callPackage ../tools/system/thinkfan { };

  vice = callPackage ../misc/emulators/vice {
    libX11 = xlibs.libX11;
  };

  viewnior = callPackage ../applications/graphics/viewnior { };

  vimPlugins = callPackage ../misc/vim-plugins { };

  vimprobable2 = callPackage ../applications/networking/browsers/vimprobable2 {
    inherit (gnome) libsoup;
    webkit = webkit_gtk2;
  };

  vimprobable2Wrapper = wrapFirefox
    { browser = vimprobable2; browserName = "vimprobable2"; desktopName = "Vimprobable2";
    };

  VisualBoyAdvance = callPackage ../misc/emulators/VisualBoyAdvance { };

  # Wine cannot be built in 64-bit; use a 32-bit build instead.
  wineStable = callPackage_i686 ../misc/emulators/wine/stable.nix { };
  wineUnstable = lowPrio (callPackage_i686 ../misc/emulators/wine/unstable.nix { });
  wine = wineStable;

  # winetricks is a shell script with no binary components. Safe to just use the current platforms
  # build instead of the i686 specific build.
  winetricks = callPackage ../misc/emulators/wine/winetricks.nix {
    inherit (gnome2) zenity;
  };

  wxmupen64plus = callPackage ../misc/emulators/wxmupen64plus { };

  x2x = callPackage ../tools/X11/x2x { };

  xosd = callPackage ../misc/xosd { };

  xsane = callPackage ../applications/graphics/sane/xsane.nix {
    libpng = libpng12;
    saneBackends = saneBackends;
  };

  yafc = callPackage ../applications/networking/yafc { };

  myEnvFun = import ../misc/my-env {
    inherit substituteAll pkgs;
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
       LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${gcc.gcc}/lib
       export LD_LIBRARY_PATH
    '';
  };

  patoline = PatolineEnv ocamlPackages_4_00_1;

  znc = callPackage ../applications/networking/znc { };

  zncModules = recurseIntoAttrs (
    callPackage ../applications/networking/znc/modules.nix { }
  );

  zsnes = callPackage_i686 ../misc/emulators/zsnes {
    libpng = libpng12;
  };

  misc = import ../misc/misc.nix { inherit pkgs stdenv; };

  bullet = callPackage ../development/libraries/bullet {};

  dart = callPackage ../development/interpreters/dart { };

  httrack = callPackage ../tools/backup/httrack { };

  mg = callPackage ../applications/editors/mg { };


  # Attributes for backward compatibility.
  adobeReader = adobe-reader;


}; in pkgs
