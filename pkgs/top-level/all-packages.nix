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

  lib = import ../lib;

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
  platform = if platform_ != null then platform_
    else config.platform or (import ./platforms.nix).pc;


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


  x11 = xlibsWrapper;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X llibraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = xorg // {xlibs = xlibsWrapper;};


  ### Helper functions.


  inherit lib config stdenvAdapters;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  builderDefs = lib.composedArgsAndFun (import ../build-support/builder-defs/builder-defs.nix) {
    inherit stringsWithDeps lib stdenv writeScript
      fetchurl fetchmtn fetchgit;
  };

  builderDefsPackage = builderDefs.builderDefsPackage builderDefs;

  stringsWithDeps = lib.stringsWithDeps;


  ### STANDARD ENVIRONMENT


  allStdenvs = import ../stdenv {
    inherit system stdenvType platform;
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

  forceBuildDrv = drv : if (crossSystem == null) then drv else
    (drv // { hostDrv = drv.buildDrv; });

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit = lowPrio (
    if system == "x86_64-linux" then
      overrideGCC stdenv gcc43_multi
    else
      stdenv);


  ### BUILD SUPPORT

  attrSetToDir = arg : import ../build-support/upstream-updater/attrset-to-dir.nix {
    inherit writeTextFile stdenv lib;
    theAttrSet = arg;
  };

  autoreconfHook = makeSetupHook
    { substitutions = { inherit autoconf automake libtool; }; }
    ../build-support/setup-hooks/autoreconf.sh;

  buildEnv = import ../build-support/buildenv {
    inherit (pkgs) runCommand perl;
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

  makeInitrd = {contents}: import ../build-support/kernel/make-initrd.nix {
    inherit stdenv perl cpio contents ubootChooser;
  };

  makeWrapper = makeSetupHook { } ../build-support/setup-hooks/make-wrapper.sh;

  makeModulesClosure = {kernel, rootModules, allowMissing ? false}:
    import ../build-support/kernel/modules-closure.nix {
      inherit stdenv module_init_tools kernel nukeReferences
        rootModules allowMissing;
    };

  pathsFromGraph = ../build-support/kernel/paths-from-graph.pl;

  srcOnly = args: (import ../build-support/src-only) ({inherit stdenv; } // args);

  substituteAll = import ../build-support/substitute/substitute-all.nix {
    inherit stdenv;
  };

  nukeReferences = callPackage ../build-support/nuke-references/default.nix { };

  vmTools = import ../build-support/vm/default.nix {
    inherit pkgs;
  };

  releaseTools = import ../build-support/release/default.nix {
    inherit pkgs;
  };

  composableDerivation = (import ../lib/composable-derivation.nix) {
    inherit pkgs lib;
  };

  platforms = import ./platforms.nix;


  ### TOOLS

  acct = callPackage ../tools/system/acct { };

  aefs = callPackage ../tools/filesystems/aefs { };

  aircrackng = callPackage ../tools/networking/aircrack-ng { };

  analog = callPackage ../tools/admin/analog {};

  archivemount = callPackage ../tools/filesystems/archivemount { };

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
      paths = [
        texLive texLiveExtra
      ];
    };
  };

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

  androidenv = import ../development/androidenv {
    inherit pkgs;
    pkgs_i686 = pkgsi686Linux;
  };

  inherit (androidenv) androidsdk_4_1;

  aria = builderDefsPackage (import ../tools/networking/aria) { };

  aria2 = callPackage ../tools/networking/aria2 { };

  at = callPackage ../tools/system/at { };

  atftp = callPackage ../tools/networking/atftp {};

  autogen = callPackage ../development/tools/misc/autogen {
    guile = guile_1_8;
  };

  autojump = callPackage ../tools/misc/autojump { };

  avahi = callPackage ../development/libraries/avahi {
    qt4Support = config.avahi.qt4Support or false;
  };

  aws = callPackage ../tools/virtualization/aws { };

  aws_mturk_clt = callPackage ../tools/misc/aws-mturk-clt { };

  axel = callPackage ../tools/networking/axel { };

  azureus = callPackage ../tools/networking/p2p/azureus { };

  banner = callPackage ../games/banner {};

  barcode = callPackage ../tools/graphics/barcode {};

  bc = callPackage ../tools/misc/bc { };

  bchunk = callPackage ../tools/cd-dvd/bchunk { };

  bfr = callPackage ../tools/misc/bfr { };

  boomerang = callPackage ../development/tools/boomerang { };

  bootchart = callPackage ../tools/system/bootchart { };

  bsod = callPackage ../misc/emulators/bsod { };

  btrfsProgs = callPackage ../tools/filesystems/btrfsprogs { };

  catdoc = callPackage ../tools/text/catdoc { };

  dlx = callPackage ../misc/emulators/dlx { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  enca = callPackage ../tools/text/enca { };

  mcrl = callPackage ../tools/misc/mcrl { };

  mcrl2 = callPackage ../tools/misc/mcrl2 { };

  syslogng = callPackage ../tools/system/syslog-ng { };

  mcelog = callPackage ../os-specific/linux/mcelog { };

  asciidoc = callPackage ../tools/typesetting/asciidoc { };

  autossh = callPackage ../tools/networking/autossh { };

  bacula = callPackage ../tools/backup/bacula { };

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
    ffmpeg = ffmpeg_1_0;
  };

  checkinstall = callPackage ../tools/package-management/checkinstall { };

  cheetahTemplate = builderDefsPackage (import ../tools/text/cheetah-template/2.0.1.nix) {
    inherit makeWrapper python;
  };

  chkrootkit = callPackage ../tools/security/chkrootkit { };

  cksfv = callPackage ../tools/networking/cksfv { };

  ciopfs = callPackage ../tools/filesystems/ciopfs { };

  colordiff = callPackage ../tools/text/colordiff { };

  connect = callPackage ../tools/networking/connect { };

  convertlit = callPackage ../tools/text/convertlit { };

  cowsay = callPackage ../tools/misc/cowsay { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  "unionfs-fuse" = callPackage ../tools/filesystems/unionfs-fuse { };

  usb_modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };

  clamav = callPackage ../tools/security/clamav { };

  cloog = callPackage ../development/libraries/cloog { };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  convmv = callPackage ../tools/misc/convmv { };

  coreutils = callPackage ../tools/misc/coreutils {
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

  cunit = callPackage ../tools/misc/cunit { };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  dadadodo = builderDefsPackage (import ../tools/text/dadadodo) { };

  dar = callPackage ../tools/archivers/dar { };

  davfs2 = callPackage ../tools/filesystems/davfs2 {
    neon = neon029;
  };

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
    libiconv = if stdenv.isDarwin then libiconv else null;
  };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dotnetfx40 = callPackage ../development/libraries/dotnetfx40 { };

  dropbear = callPackage ../tools/networking/dropbear {
    enableStatic = true;
    zlib = zlibStatic;
  };

  dtach = callPackage ../tools/misc/dtach { };

  duplicity = callPackage ../tools/backup/duplicity {
    inherit (pythonPackages) boto;
    gnupg = gnupg1;
  };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  dvgrab = callPackage ../tools/video/dvgrab { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  edk2 = callPackage ../development/compilers/edk2 { };

  efibootmgr = callPackage ../tools/system/efibootmgr { };

  enblendenfuse = callPackage ../tools/graphics/enblend-enfuse {
    boost = boost149;
  };

  encfs = callPackage ../tools/filesystems/encfs { };

  enscript = callPackage ../tools/text/enscript { };

  ethtool = callPackage ../tools/misc/ethtool { };

  euca2ools = callPackage ../tools/virtualization/euca2ools { pythonPackages = python26Packages; };

  exif = callPackage ../tools/graphics/exif { };

  exiftags = callPackage ../tools/graphics/exiftags { };

  expect = callPackage ../tools/misc/expect { };

  fail2ban = callPackage ../tools/security/fail2ban { };

  fakeroot = callPackage ../tools/system/fakeroot { };

  fcron = callPackage ../tools/system/fcron { };

  fdisk = callPackage ../tools/system/fdisk { };

  fdm = callPackage ../tools/networking/fdm {};

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file { };
  file511 = callPackage ../tools/misc/file/511.nix { };

  fileschanged = callPackage ../tools/misc/fileschanged { };

  findutils = callPackage ../tools/misc/findutils { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  fio = callPackage ../tools/system/fio { };

  flvstreamer = callPackage ../tools/networking/flvstreamer { };

  libbsd = callPackage ../development/libraries/libbsd { };

  flvtool2 = callPackage ../tools/video/flvtool2 { };

  fontforge = lowPrio (callPackage ../tools/misc/fontforge { });

  fontforgeX = callPackage ../tools/misc/fontforge {
    withX11 = true;
  };

  fortune = callPackage ../tools/misc/fortune { };

  fox = callPackage ../development/libraries/fox/default.nix { };
  fox_1_6 = callPackage ../development/libraries/fox/fox-1.6.nix { };

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

  dos2unix = callPackage ../tools/text/dos2unix { };

  uni2ascii = callPackage ../tools/text/uni2ascii { };

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

  gnokii = builderDefsPackage (import ../tools/misc/gnokii) {
    inherit intltool perl gettext libusb pkgconfig bluez readline pcsclite
      libical gtk glib;
    inherit (xorg) libXpm;
  };

  gnugrep =
    # Use libiconv only on non-GNU platforms (we can't test with
    # `stdenv ? glibc' at this point.)
    let gnu = stdenv.isLinux; in
      callPackage ../tools/text/gnugrep {
        libiconv = if gnu then null else libiconv;
      };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1orig = callPackage ../tools/security/gnupg1 {
    ideaSupport = false;
  };

  gnupg1compat = callPackage ../tools/security/gnupg1compat { };

  # use config.packageOverrides if you prefer original gnupg1
  gnupg1 = gnupg1compat;

  gnupg = callPackage ../tools/security/gnupg { };

  gnupg2_1 = lowPrio (callPackage ../tools/security/gnupg/git.nix {
    libassuan = libassuan2_1;
  });

  gnuplot = callPackage ../tools/graphics/gnuplot {
    texLive = null;
    lua = null;
  };

  gnused = callPackage ../tools/text/gnused { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

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

  grub2 = callPackage ../tools/misc/grub/2.0x.nix { };

  grub2_efi = grub2.override { EFIsupport = true; };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome) libsoup;
  };

  gt5 = callPackage ../tools/system/gt5 { };

  gtkdatabox = callPackage ../development/libraries/gtkdatabox {};

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella { };

  gtkvnc = callPackage ../tools/admin/gtk-vnc {};

  gtmess = callPackage ../applications/networking/instant-messengers/gtmess { };

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

  pigz = callPackage ../tools/compression/pigz { };

  haproxy = callPackage ../tools/networking/haproxy { };

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

  jing_tools = callPackage ../tools/text/xml/jing/jing-script.nix { };

  jnettop = callPackage ../tools/networking/jnettop { };

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

  netperf = callPackage ../applications/networking/netperf { };

  ninka = callPackage ../development/tools/misc/ninka { };

  nodejs = callPackage ../development/web/nodejs {};

  nodePackages = recurseIntoAttrs (import ./node-packages.nix {
    inherit pkgs stdenv nodejs fetchurl;
    neededNatives = [python] ++ lib.optional (lib.elem system lib.platforms.linux) utillinux;
  });

  ldns = callPackage ../development/libraries/ldns { };

  lftp = callPackage ../tools/networking/lftp { };

  libconfig = callPackage ../development/libraries/libconfig { };

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

  lzma = xz;

  xz = callPackage ../tools/compression/xz { };

  lzop = callPackage ../tools/compression/lzop { };

  mu0 = callPackage ../tools/networking/mu0 { };

  mailutils = callPackage ../tools/networking/mailutils {
    guile = guile_1_8;
  };

  mairix = callPackage ../tools/text/mairix { };

  man = callPackage ../tools/misc/man { };

  man_db = callPackage ../tools/misc/man-db { };

  memtest86 = callPackage ../tools/misc/memtest86 { };

  memtest86plus = callPackage ../tools/misc/memtest86/plus.nix { };

  mc = callPackage ../tools/misc/mc { };

  mcabber = callPackage ../applications/networking/instant-messengers/mcabber { };

  mcron = callPackage ../tools/system/mcron {
    guile = guile_1_8;
  };

  mdbtools = callPackage ../tools/misc/mdbtools { };

  mdbtools_git = callPackage ../tools/misc/mdbtools/git.nix { };

  minecraft = callPackage ../games/minecraft { };

  miniupnpc = callPackage ../tools/networking/miniupnpc { };

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  minixml = callPackage ../development/libraries/minixml { };

  mjpegtools = callPackage ../tools/video/mjpegtools { };

  mkcue = callPackage ../tools/cd-dvd/mkcue { };

  mktemp = callPackage ../tools/security/mktemp { };

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

  muscleframework = callPackage ../tools/security/muscleframework { };

  muscletool = callPackage ../tools/security/muscletool { };

  mysql2pgsql = callPackage ../tools/misc/mysql2pgsql { };

  namazu = callPackage ../tools/text/namazu { };

  nbd = callPackage ../tools/networking/nbd { };

  netcdf = callPackage ../development/libraries/netcdf { };

  nc6 = callPackage ../tools/networking/nc6 { };

  ncat = callPackage ../tools/networking/ncat { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  ndisc6 = callPackage ../tools/networking/ndisc6 { };

  netboot = callPackage ../tools/networking/netboot {};

  netcat = callPackage ../tools/networking/netcat { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netrw = callPackage ../tools/networking/netrw { };

  netselect = callPackage ../tools/networking/netselect { };

  networkmanager = callPackage ../tools/networking/network-manager { };

  networkmanager_pptp = callPackage ../tools/networking/network-manager/pptp.nix { };

  networkmanager_pptp_gnome = networkmanager_pptp.override { withGnome = true; };

  networkmanagerapplet = newScope gnome ../tools/networking/network-manager-applet { };

  nilfs_utils = callPackage ../tools/filesystems/nilfs-utils {};

  nlopt = callPackage ../development/libraries/nlopt {};

  npth = callPackage ../development/libraries/npth {};

  nmap = callPackage ../tools/security/nmap {
    inherit (pythonPackages) pysqlite;
  };

  nss_myhostname = callPackage ../tools/networking/nss-myhostname {};

  nss_pam_ldapd = callPackage ../tools/networking/nss-pam-ldapd {};

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  # ntfsprogs are merged into ntfs-3g
  ntfsprogs = pkgs.ntfs3g;

  ntop = callPackage ../tools/networking/ntop { };

  ntp = callPackage ../tools/networking/ntp { };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nylon = callPackage ../tools/networking/nylon { };

  nzbget = callPackage ../tools/networking/nzbget { };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server { };

  obexd = callPackage ../tools/bluetooth/obexd { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  obnam = callPackage ../tools/backup/obnam { };

  odt2txt = callPackage ../tools/text/odt2txt { };

  offlineimap = callPackage ../tools/networking/offlineimap { };

  opendbx = callPackage ../development/libraries/opendbx { };

  opendkim = callPackage ../development/libraries/opendkim { };

  openjade = callPackage ../tools/text/sgml/openjade {
    stdenv = overrideGCC stdenv gcc33;
    opensp = opensp.override { stdenv = overrideGCC stdenv gcc33; };
  };

  openobex = callPackage ../tools/bluetooth/openobex { };

  openresolv = callPackage ../tools/networking/openresolv { };

  opensc_0_11_7 = callPackage ../tools/security/opensc/0.11.7.nix { };

  opensc = opensc_0_11_7;

  opensc_dnie_wrapper = callPackage ../tools/security/opensc-dnie-wrapper { };

  openssh = callPackage ../tools/networking/openssh {
    hpnSupport = false;
    etcDir = "/etc/ssh";
    pam = if stdenv.isLinux then pam else null;
  };

  opensp = callPackage ../tools/text/sgml/opensp { };

  spCompat = callPackage ../tools/text/sgml/opensp/compat.nix { };

  openvpn = callPackage ../tools/networking/openvpn { };

  optipng = callPackage ../tools/graphics/optipng { };

  ossec = callPackage ../tools/security/ossec {};

  p7zip = callPackage ../tools/archivers/p7zip { };

  pal = callPackage ../tools/misc/pal { };

  panomatic = callPackage ../tools/graphics/panomatic { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  patchutils = callPackage ../tools/text/patchutils { };

  parted = callPackage ../tools/misc/parted { hurd = null; };
  parted_2_3 = callPackage ../tools/misc/parted/2.3.nix { hurd = null; };

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
              }).hostDrv)
           { hurd = gnu.hurdCrossIntermediate; })
    else null;

  ipsecTools = callPackage ../os-specific/linux/ipsec-tools { };

  patch = gnupatch;

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite { };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdfjam = callPackage ../tools/typesetting/pdfjam { };

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

  polipo = callPackage ../servers/polipo { };

  polkit_gnome = callPackage ../tools/security/polkit-gnome { };

  povray = callPackage ../tools/graphics/povray { };

  ppl = callPackage ../development/libraries/ppl { };

  ppp = callPackage ../tools/networking/ppp { };

  pptp = callPackage ../tools/networking/pptp {};

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel { };

  cntlm = callPackage ../tools/networking/cntlm { };

  psmisc = callPackage ../os-specific/linux/psmisc { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pydb = callPackage ../development/tools/pydb { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pythonDBus = callPackage ../development/python-modules/dbus { };

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

  recutils = callPackage ../tools/misc/recutils { };

  refind = callPackage ../tools/misc/refind { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome) gnome_vfs GConf;
  };

  remind = callPackage ../tools/misc/remind { };

  remmina = callPackage ../applications/networking/remote/remmina {};

  replace = callPackage ../tools/text/replace { };

  reptyr = callPackage ../os-specific/linux/reptyr {};

  rdiff_backup = callPackage ../tools/backup/rdiff-backup { };

  ripmime = callPackage ../tools/networking/ripmime {};

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

  seccure = callPackage ../tools/security/seccure/0.4.nix { };

  setserial = builderDefsPackage (import ../tools/system/setserial) {
    inherit groff;
  };

  sg3_utils = callPackage ../tools/system/sg3_utils { };

  sharutils = callPackage ../tools/archivers/sharutils { };

  shebangfix = callPackage ../tools/misc/shebangfix { };

  siege = callPackage ../tools/networking/siege {};

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

  stardict = callPackage ../applications/misc/stardict/stardict.nix {
    inherit (gnome) libgnomeui scrollkeeper;
  };

  fusesmb = callPackage ../tools/filesystems/fusesmb { };

  socat = callPackage ../tools/networking/socat { };

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  socat2pre = lowPrio (builderDefsPackage ../tools/networking/socat/2.0.0-b3.nix {
    inherit fetchurl stdenv openssl;
  });

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  sshfsFuse = callPackage ../tools/filesystems/sshfs-fuse { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = builderDefsPackage (import ../tools/system/suid-chroot) { };

  super = callPackage ../tools/security/super { };

  ssmtp = callPackage ../tools/networking/ssmtp {
    tlsSupport = true;
  };

  ssss = callPackage ../tools/security/ssss { };

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

  tcpdump = callPackage ../tools/networking/tcpdump { };

  telnet = callPackage ../tools/networking/telnet { };

  texmacs = callPackage ../applications/editors/texmacs {
    tex = texLive; /* tetex is also an option */
    extraFonts = true;
    guile = guile_1_8;
  };

  tmux = callPackage ../tools/misc/tmux { };

  tor = callPackage ../tools/security/tor { };

  torsocks = callPackage ../tools/security/tor/torsocks.nix { };

  trickle = callPackage ../tools/networking/trickle {};

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ucl = callPackage ../development/libraries/ucl { };

  udftools = callPackage ../tools/filesystems/udftools {};

  ufraw = callPackage ../applications/graphics/ufraw { };

  unetbootin = callPackage ../tools/cd-dvd/unetbootin { };

  unfs3 = callPackage ../servers/unfs3 { };

  upx = callPackage ../tools/compression/upx { };

  usbmuxd = callPackage ../tools/misc/usbmuxd {};

  vacuum = callPackage ../applications/networking/instant-messengers/vacuum {};

  vidalia = callPackage ../tools/security/vidalia { };

  vbetool = builderDefsPackage ../tools/system/vbetool {
    inherit pciutils libx86 zlib;
  };

  vde2 = callPackage ../tools/networking/vde2 { };

  verilog = callPackage ../applications/science/electronics/verilog {};

  vfdecrypt = callPackage ../tools/misc/vfdecrypt { };

  vifm = callPackage ../applications/misc/vifm {};

  viking = callPackage ../applications/misc/viking {
    inherit (gnome) scrollkeeper;
  };

  vncrec = builderDefsPackage ../tools/video/vncrec {
    inherit (xlibs) imake libX11 xproto gccmakedep libXt
      libXmu libXaw libXext xextproto libSM libICE libXpm
      libXp;
  };

  vobcopy = callPackage ../tools/cd-dvd/vobcopy { };

  vorbisgain = callPackage ../tools/misc/vorbisgain { };

  vpnc = callPackage ../tools/networking/vpnc { };

  vtun = callPackage ../tools/networking/vtun { };

  wbox = callPackage ../tools/networking/wbox {};

  welkin = callPackage ../tools/graphics/welkin {};

  testdisk = callPackage ../tools/misc/testdisk { };

  htmlTidy = callPackage ../tools/text/html-tidy { };

  tftp_hpa = callPackage ../tools/networking/tftp-hpa {};

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
    xorgserver = xorg.xorgserver_1_13_0;
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

  unarj = callPackage ../tools/archivers/unarj { };

  unshield = callPackage ../tools/archivers/unshield { };

  unzip = callPackage ../tools/archivers/unzip { };

  unzipNLS = lowPrio (unzip.override { enableNLS = true; });

  uptimed = callPackage ../tools/system/uptimed { };

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

  wget = callPackage ../tools/networking/wget {
    inherit (perlPackages) LWP;
  };

  which = callPackage ../tools/system/which { };

  wicd = callPackage ../tools/networking/wicd { };

  wkhtmltopdf = callPackage ../tools/graphics/wkhtmltopdf { };

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

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

  zbar = callPackage ../tools/graphics/zbar {};

  zdelta = callPackage ../tools/compression/zdelta { };

  zile = callPackage ../applications/editors/zile { };

  zip = callPackage ../tools/archivers/zip { };

  zsync = callPackage ../tools/compression/zsync { };


  ### SHELLS


  bash = lowPrio (callPackage ../shells/bash {
    texinfo = null;
  });

  bashInteractive = appendToName "interactive" (callPackage ../shells/bash {
    interactive = true;
  });

  bashCompletion = callPackage ../shells/bash-completion { };

  dash = callPackage ../shells/dash { };

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

  aspectj = callPackage ../development/compilers/aspectj { };

  bigloo = callPackage ../development/compilers/bigloo { };

  ccl = builderDefsPackage ../development/compilers/ccl {};

  clangUnwrapped = callPackage ../development/compilers/llvm/clang.nix { };

  clang = wrapClang clangUnwrapped;

  #Use this instead of stdenv to build with clang
  clangStdenv = lowPrio (stdenvAdapters.overrideGCC stdenv clang);

  clean = callPackage ../development/compilers/clean { };

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

  gcc295 = wrapGCC (import ../development/compilers/gcc/2.95 {
    inherit fetchurl stdenv noSysDirs;
  });

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

  gcc40 = wrapGCC (makeOverridable (import ../development/compilers/gcc/4.0) {
    inherit fetchurl stdenv noSysDirs;
    texinfo = texinfo49;
    profiledCompiler = true;
  });

  gcc41 = wrapGCC (makeOverridable (import ../development/compilers/gcc/4.1) {
    inherit fetchurl noSysDirs gmp mpfr;
    stdenv = overrideGCC stdenv gcc42;
    texinfo = texinfo49;
    profiledCompiler = false;
  });

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

  gcc44_realCross = lib.addMetaAttrs { platforms = []; }
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

  gcc46 = gcc46_real;

  gcc47 = gcc47_real;

  gcc45_realCross = lib.addMetaAttrs { platforms = []; }
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

  gcc46_realCross = lib.addMetaAttrs { platforms = []; }
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

  gcc47_realCross = lib.addMetaAttrs { platforms = []; }
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
      gcc = forceBuildDrv (lib.addMetaAttrs { platforms = []; } (
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
    gcc = forceBuildDrv (gcc_realCross.override {
      libpthreadCross =
        # FIXME: Don't explicitly refer to `i586-pc-gnu'.
        if crossSystem != null && crossSystem.config == "i586-pc-gnu"
        then gnu.libpthreadCross
        else null;
     });
    libc = libcCross;
    binutils = binutilsCross;
    cross = assert crossSystem != null; crossSystem;
  };

  gcc43_multi = lowPrio (wrapGCCWith (import ../build-support/gcc-wrapper) glibc_multi (gcc43.gcc.override {
    stdenv = overrideGCC stdenv (wrapGCCWith (import ../build-support/gcc-wrapper) glibc_multi gcc);
    profiledCompiler = false;
    enableMultilib = true;
  }));

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
    profiledCompiler = if stdenv.isArm then false else true;

    # When building `gcc.hostDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    libpthreadCross =
      if crossSystem != null && crossSystem.config == "i586-pc-gnu"
      then gnu.libpthreadCross
      else null;
  }));

  # A non-stripped version of GCC.
  gcc45_debug = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.5 {
    stripped = false;

    inherit noSysDirs;

    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = if stdenv.system == "armv5tel-linux" then false else true;
  }));

  gcc46_real = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.6 {
    inherit noSysDirs;

    # bootstrapping a profiled compiler does not work in the sheevaplug:
    # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
    profiledCompiler = if stdenv.isArm then false else true;

    # When building `gcc.hostDrv' (a "Canadian cross", with host == target
    # and host != build), `cross' must be null but the cross-libc must still
    # be passed.
    cross = null;
    libcCross = if crossSystem != null then libcCross else null;
    libpthreadCross =
      if crossSystem != null && crossSystem.config == "i586-pc-gnu"
      then gnu.libpthreadCross
      else null;
  }));

  # A non-stripped version of GCC.
  gcc46_debug = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.6 {
    stripped = false;

    inherit noSysDirs;
    cross = null;
    libcCross = null;
    binutilsCross = null;
  }));

  gcc47_real = lowPrio (wrapGCC (callPackage ../development/compilers/gcc/4.7 {
    inherit noSysDirs;
    # I'm not sure if profiling with enableParallelBuilding helps a lot.
    # We can enable it back some day. This makes the *gcc* builds faster now.
    profiledCompiler = false;

    # When building `gcc.hostDrv' (a "Canadian cross", with host == target
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

  gccupc40 = wrapGCCUPC (import ../development/compilers/gcc-upc-4.0 {
    inherit fetchurl stdenv bison autoconf gnum4 noSysDirs;
    texinfo = texinfo49;
  });

  gfortran = gfortran46;

  gfortran40 = wrapGCC (gcc40.gcc.override {
    langFortran = true;
    langCC = false;
    inherit gmp mpfr;
  });

  gfortran41 = wrapGCC (gcc41.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    inherit gmp mpfr;
  });

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

  gcj44 = wrapGCC (gcc44.gcc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = true;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig;
    inherit gtk;
    inherit (gnome) libart_lgpl;
    inherit (xlibs) libX11 libXt libSM libICE libXtst libXi libXrender
      libXrandr xproto renderproto xextproto inputproto randrproto;
  });

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

  # Not officially supported version for ghdl
  ghdl_gcc44 = lowPrio (wrapGCC (import ../development/compilers/gcc/4.4 {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs gnat gettext which
      ppl cloogppl;
    name = "ghdl";
    langVhdl = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    enableMultilib = false;
  }));

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

  # Current default version: 7.4.2.
  haskellPackages = haskellPackages_ghc742;
  # Current Haskell Platform: 2012.4.0.0
  haskellPlatform = haskellPackages.haskellPlatform;

  haskellPackages_ghc6104             = recurseIntoAttrs (haskell.packages_ghc6104);
  haskellPackages_ghc6121             =                   haskell.packages_ghc6121;
  haskellPackages_ghc6122             =                   haskell.packages_ghc6122;
  haskellPackages_ghc6123             = recurseIntoAttrs (haskell.packages_ghc6123);
  haskellPackages_ghc701              =                   haskell.packages_ghc701;
  haskellPackages_ghc702              =                   haskell.packages_ghc702;
  haskellPackages_ghc703              =                   haskell.packages_ghc703;
  haskellPackages_ghc704              = recurseIntoAttrs (haskell.packages_ghc704);
  haskellPackages_ghc721              =                   haskell.packages_ghc721;
  haskellPackages_ghc722              =                   haskell.packages_ghc722;
  # For the default version, we build profiling versions of the libraries, too.
  # The following three lines achieve that: the first two make Hydra build explicit
  # profiling and non-profiling versions; the final respects the user-configured
  # default setting.
  haskellPackages_ghc741              = recurseIntoAttrs (haskell.packages_ghc741);
  haskellPackages_ghc742_no_profiling = recurseIntoAttrs (haskell.packages_ghc741.noProfiling);
  haskellPackages_ghc742_profiling    = recurseIntoAttrs (haskell.packages_ghc741.profiling);
  haskellPackages_ghc742              = recurseIntoAttrs (haskell.packages_ghc742.highPrio);
  haskellPackages_ghc761              = recurseIntoAttrs (haskell.packages_ghc761);
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

  go = callPackage ../development/compilers/go { };

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt = callPackage ../development/compilers/gwt {
    libstdcpp5 = gcc33.gcc;
  };
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

  jdk = if (stdenv.isDarwin || stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then pkgs.openjdk
    else pkgs.oraclejdk;
  jre = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
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
    pcre = pcre_8_30;
    liblapack = liblapack.override {shared = true;};
    fftw = fftw.override {pthreads = true;};
    fftwSinglePrec = fftwSinglePrec.override {pthreads = true;};
  };

  lazarus = builderDefsPackage (import ../development/compilers/fpc/lazarus.nix) {
    inherit makeWrapper gtk glib pango atk gdk_pixbuf;
    inherit (xlibs) libXi inputproto libX11 xproto libXext xextproto;
    fpc = fpc;
  };

  llvm = callPackage ../development/compilers/llvm { };

  mitscheme = callPackage ../development/compilers/mit-scheme { };

  mlton = callPackage ../development/compilers/mlton { };

  mono = callPackage ../development/compilers/mono { };

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

    cryptokit = callPackage ../development/ocaml-modules/cryptokit { };

    findlib = callPackage ../development/tools/ocaml/findlib { };

    gmetadom = callPackage ../development/ocaml-modules/gmetadom { };

    lablgtk = callPackage ../development/ocaml-modules/lablgtk {
      inherit (gnome) libgnomecanvas libglade gtksourceview;
    };

    lablgtkmathview = callPackage ../development/ocaml-modules/lablgtkmathview {
      gtkmathview = callPackage ../development/libraries/gtkmathview { };
    };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    mldonkey = callPackage ../applications/networking/p2p/mldonkey { };

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

  roadsend = callPackage ../development/compilers/roadsend { };

  # TODO: the corresponding nix file is missing
  # rust = pkgsi686Linux.callPackage ../development/compilers/rust {};

  sbcl = builderDefsPackage (import ../development/compilers/sbcl) {
    inherit makeWrapper clisp;
  };

  scala = callPackage ../development/compilers/scala { };

  stalin = callPackage ../development/compilers/stalin { };

  strategoPackages = strategoPackages018;

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

  vala = vala17;

  vala15 = callPackage ../development/compilers/vala/15.2.nix { };

  vala16 = callPackage ../development/compilers/vala/16.1.nix { };

  vala17 = callPackage ../development/compilers/vala/default.nix { };

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

    forceBuildDrv (import ../build-support/gcc-cross-wrapper {
      nativeTools = false;
      nativeLibc = false;
      noLibc = (libc == null);
      inherit stdenv gcc binutils libc shell name cross;
    });

  # FIXME: This is a specific hack for GCC-UPC.  Eventually, we may
  # want to merge `gcc-upc-wrapper' and `gcc-wrapper'.
  wrapGCCUPC = baseGCC: import ../build-support/gcc-upc-wrapper {
    nativeTools = stdenv ? gcc && stdenv.gcc.nativeTools;
    nativeLibc = stdenv ? gcc && stdenv.gcc.nativeLibc;
    gcc = baseGCC;
    libc = glibc;
    inherit stdenv binutils;
  };

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

  clojure_binary = callPackage ../development/interpreters/clojure/binary.nix { };

  clojure_wrapper = callPackage ../development/interpreters/clojure/wrapper.nix {
    #clojure = clojure_binary;
  };

  clooj_standalone_binary = callPackage ../development/interpreters/clojure/clooj.nix { };

  clooj_wrapper = callPackage ../development/interpreters/clojure/clooj-wrapper.nix {
    clooj = clooj_standalone_binary;
  };

  erlangR14B04 = callPackage ../development/interpreters/erlang/R14B04.nix { };
  erlangR15B02 = callPackage ../development/interpreters/erlang/R15B02.nix { };
  erlang = erlangR15B02;

  groovy = callPackage ../development/interpreters/groovy { };

  guile_1_8 = callPackage ../development/interpreters/guile/1.8.nix { };

  guile_2_0 = callPackage ../development/interpreters/guile { };

  guile = guile_2_0;

  hadoop = callPackage ../applications/networking/cluster/hadoop { };

  io = callPackage ../development/interpreters/io { };

  j = callPackage ../development/interpreters/j {};

  kaffe = callPackage ../development/interpreters/kaffe { };

  kona = callPackage ../development/interpreters/kona {};

  love = callPackage ../development/interpreters/love {};

  lua4 = callPackage ../development/interpreters/lua-4 { };
  lua5 = callPackage ../development/interpreters/lua-5 { };
  lua5_0 = callPackage ../development/interpreters/lua-5/5.0.3.nix { };
  lua5_1 = callPackage ../development/interpreters/lua-5/5.1.nix { };

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

  perl514 = callPackage ../development/interpreters/perl/5.14 {
    fetchurl = fetchurlBoot;
  };

  perl = if system != "i686-cygwin" then perl514 else sysPerl;

  php = callPackage ../development/interpreters/php/5.3.nix { };

  php_apc = callPackage ../development/libraries/php-apc { };

  php_xcache = callPackage ../development/libraries/php-xcache { };

  phpXdebug = callPackage ../development/interpreters/php-xdebug { };

  picolisp = callPackage ../development/interpreters/picolisp {};

  pltScheme = builderDefsPackage (import ../development/interpreters/plt-scheme) {
    inherit cairo fontconfig freetype libjpeg libpng openssl
      perl mesa zlib which;
    inherit (xorg) libX11 libXaw libXft libXrender libICE xproto
      renderproto pixman libSM libxcb libXext xextproto libXmu
      libXt;
  };

  polyml = callPackage ../development/compilers/polyml { };

  pure = callPackage ../development/interpreters/pure {};

  python = python27;
  python3 = python32;

  python26 = callPackage ../development/interpreters/python/2.6 { };

  python27 = callPackage ../development/interpreters/python/2.7 { };

  python32 = callPackage ../development/interpreters/python/3.2 { };

  pythonFull = python27Full;

  python26Full = callPackage ../development/interpreters/python/wrapper.nix {
    extraLibs = lib.attrValues python26.modules;
    python = python26;
  };

  python27Full = callPackage ../development/interpreters/python/wrapper.nix {
    extraLibs = lib.attrValues python27.modules;
    python = python27;
  };

  pythonhomeWrapper = callPackage ../development/interpreters/python/pythonhome-wrapper.nix { };

  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  qi = callPackage ../development/compilers/qi { };

  racket = callPackage ../development/interpreters/racket { };

  regina = callPackage ../development/interpreters/regina {};

  ruby18 = callPackage ../development/interpreters/ruby/ruby-18.nix { };
  ruby19 = callPackage ../development/interpreters/ruby/ruby-19.nix { };

  ruby = ruby19;

  rubyLibs = recurseIntoAttrs (callPackage ../development/interpreters/ruby/libs.nix { });

  rake = callPackage ../development/ruby-modules/rake { };

  rubySqlite3 = callPackage ../development/ruby-modules/sqlite3 { };

  rLang = callPackage ../development/interpreters/r-lang {
    withBioconductor = config.rLang.withBioconductor or false;
  };

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

  automake = automake112x;

  automake110x = callPackage ../development/tools/misc/automake/automake-1.10.x.nix { };

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix {
    doCheck = !stdenv.isArm && !stdenv.isCygwin && !stdenv.isMips
      # Some of the parallel tests seem to hang on `i386-pc-solaris2.11'.
      && stdenv.system != "i686-solaris"

      # One test fails to terminate on FreeBSD: <http://bugs.gnu.org/8788>.
      && !stdenv.isFreeBSD;
  };

  automake112x = callPackage ../development/tools/misc/automake/automake-1.12.x.nix {
    doCheck = !stdenv.isArm && !stdenv.isCygwin && !stdenv.isMips
      # Some of the parallel tests seem to hang on `i386-pc-solaris2.11'.
      && stdenv.system != "i686-solaris";
  };

  automoc4 = callPackage ../development/tools/misc/automoc4 { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  bam = callPackage ../development/tools/build-managers/bam {};

  binutils = callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
  };

  binutils_gold = lowPrio (callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
    gold = true;
  });

  binutilsCross = lowPrio (forceBuildDrv (import ../development/tools/misc/binutils {
    inherit stdenv fetchurl zlib;
    noSysDirs = true;
    cross = assert crossSystem != null; crossSystem;
  }));

  bison = bison25;

  bison1875 = callPackage ../development/tools/parsing/bison/bison-1.875.nix { };

  bison23 = callPackage ../development/tools/parsing/bison/bison-2.3.nix { };

  bison24 = callPackage ../development/tools/parsing/bison/bison-2.4.nix { };

  bison25 = callPackage ../development/tools/parsing/bison/bison-2.5.nix { };

  bison26 = callPackage ../development/tools/parsing/bison/bison-2.6.nix { };

  buildbot = callPackage ../development/tools/build-managers/buildbot {
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

  mk = callPackage ../development/tools/build-managers/mk { };

  neoload = callPackage ../development/tools/neoload {
    licenseAccepted = (config.neoload.accept_license or false);
  };

  noweb = callPackage ../development/tools/literate-programming/noweb { };

  omake = callPackage ../development/tools/ocaml/omake { };

  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = callPackage ../development/tools/profiling/oprofile { };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelfUnstable = callPackage ../development/tools/misc/patchelf/unstable.nix { };

  peg = callPackage ../development/tools/parsing/peg { };

  phantomjs = callPackage ../development/tools/phantomjs { };

  pmccabe = callPackage ../development/tools/misc/pmccabe { };

  /* Make pkgconfig always return a buildDrv, never a proper hostDrv,
     because most usage of pkgconfig as buildInput (inheritance of
     pre-cross nixpkgs) means using it using as buildNativeInput
     cross_renaming: we should make all programs use pkgconfig as
     buildNativeInput after the renaming.
     */
  pkgconfig = forceBuildDrv (callPackage ../development/tools/misc/pkgconfig { });
  pkgconfigUpstream = lowPrio (pkgconfig.override { vanilla = true; });

  premake = callPackage ../development/tools/misc/premake { };

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

  # couldn't find the source yet
  seleniumRCBin = callPackage ../development/tools/selenium/remote-control {
    jre = jdk;
  };

  scons = callPackage ../development/tools/build-managers/scons { };

  simpleBuildTool = callPackage ../development/tools/build-managers/simple-build-tool { };

  sloccount = callPackage ../development/tools/misc/sloccount { };

  smatch = callPackage ../development/tools/analysis/smatch {
    buildllvmsparse = false;
    buildc2xml = false;
  };

  sparse = callPackage ../development/tools/analysis/sparse { };

  spin = callPackage ../development/tools/analysis/spin { };

  splint = callPackage ../development/tools/analysis/splint { };

  strace = callPackage ../development/tools/misc/strace { };

  swig = callPackage ../development/tools/misc/swig { };

  swig2 = callPackage ../development/tools/misc/swig/2.x.nix { };

  swigWithJava = swig;

  swftools = callPackage ../tools/video/swftools { };

  texinfo49 = callPackage ../development/tools/misc/texinfo/4.9.nix { };

  texinfo = callPackage ../development/tools/misc/texinfo { };

  texi2html = callPackage ../development/tools/misc/texi2html { };

  uisp = callPackage ../development/tools/misc/uisp { };

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

  xxdiff = callPackage ../development/tools/misc/xxdiff { };

  yacc = bison;

  yodl = callPackage ../development/tools/misc/yodl { };


  ### DEVELOPMENT / LIBRARIES


  a52dec = callPackage ../development/libraries/a52dec { };

  aacskeys = callPackage ../development/libraries/aacskeys { };

  aalib = callPackage ../development/libraries/aalib { };

  acl = callPackage ../development/libraries/acl { };

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

  audiofile = callPackage ../development/libraries/audiofile { };

  axis = callPackage ../development/libraries/axis { };

  babl_0_0_22 = callPackage ../development/libraries/babl/0_0_22.nix { };

  babl = callPackage ../development/libraries/babl { };

  beecrypt = callPackage ../development/libraries/beecrypt { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost144 = callPackage ../development/libraries/boost/1.44.nix { };
  boost146 = callPackage ../development/libraries/boost/1.46.nix { };
  boost147 = callPackage ../development/libraries/boost/1.47.nix { };
  boost149 = callPackage ../development/libraries/boost/1.49.nix { };
  boost151 = callPackage ../development/libraries/boost/1.51.nix { };
  boost152 = callPackage ../development/libraries/boost/1.52.nix { };
  boost = boost152;

  boostHeaders149 = callPackage ../development/libraries/boost/1.49-headers.nix { };
  boostHeaders151 = callPackage ../development/libraries/boost/1.51-headers.nix { };
  boostHeaders152 = callPackage ../development/libraries/boost/1.52-headers.nix { };
  boostHeaders = boostHeaders152;

  botan = callPackage ../development/libraries/botan { };

  box2d = callPackage ../development/libraries/box2d { };
  box2d_2_0_1 = callPackage ../development/libraries/box2d/2.0.1.nix { };

  buddy = callPackage ../development/libraries/buddy { };

  bwidget = callPackage ../development/libraries/bwidget { };

  caelum = callPackage ../development/libraries/caelum { };

  cairomm = callPackage ../development/libraries/cairomm { };

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

  consolekit = callPackage ../development/libraries/consolekit { };

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

  dbus = pkgs.dbus_all.libs // { inherit (pkgs.dbus_all) libs; };

  dbus_daemon = pkgs.dbus_all.daemon;

  dbus_tools = pkgs.dbus_all.tools;

  dbus_libs = pkgs.dbus_all.libs;

  dbus_all = callPackage ../development/libraries/dbus {
    useX11 = true;
  };

  dbus_cplusplus = callPackage ../development/libraries/dbus-cplusplus { };

  dbus_glib = callPackage ../development/libraries/dbus-glib { };

  dbus_java = callPackage ../development/libraries/java/dbus-java { };

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
  };

  ffmpeg_0_6_90 = callPackage ../development/libraries/ffmpeg/0.6.90.nix {
    vpxSupport = !stdenv.isMips;
  };

  ffmpeg_1_0 = callPackage ../development/libraries/ffmpeg/1.0.nix {
    vpxSupport = !stdenv.isMips;
  };

  fftw = callPackage ../development/libraries/fftw {
    singlePrecision = false;
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

  freeglut = callPackage ../development/libraries/freeglut { };

  freetype = callPackage ../development/libraries/freetype { };

  fribidi = callPackage ../development/libraries/fribidi { };

  funambol = callPackage ../development/libraries/funambol { };

  fam = gamin;

  gamin = callPackage ../development/libraries/gamin { };

  gav = callPackage ../games/gav { };

  GConf3 = callPackage ../development/libraries/GConf/3.x.nix { };

  gdome2 = callPackage ../development/libraries/gdome2 {
    inherit (gnome) gtkdoc;
  };

  gdbm = callPackage ../development/libraries/gdbm { };

  gegl = callPackage ../development/libraries/gegl {
    #  avocodec avformat librsvg
  };

  gegl_0_0_22 = callPackage ../development/libraries/gegl/0_0_22.nix {
    #  avocodec avformat librsvg
  };
  geoclue = callPackage ../development/libraries/geoclue {};

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

  glew = callPackage ../development/libraries/glew { };

  glfw = callPackage ../development/libraries/glfw { };

  glibc = glibc213;

  glibcCross = glibc213Cross;

  glibc25 = callPackage ../development/libraries/glibc/2.5 {
    kernelHeaders = linuxHeaders_2_6_28;
    installLocales = false;
  };

  glibc27 = callPackage ../development/libraries/glibc/2.7 {
    kernelHeaders = linuxHeaders;
    #installLocales = false;
  };

  glibc29 = callPackage ../development/libraries/glibc/2.9 {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
  };

  glibc29Cross = forceBuildDrv (makeOverridable (import ../development/libraries/glibc/2.9) {
    inherit stdenv fetchurl;
    gccCross = gccCrossStageStatic;
    kernelHeaders = linuxHeadersCross;
    installLocales = config.glibc.locales or false;
  });

  glibc213 = (callPackage ../development/libraries/glibc/2.13 {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
    machHeaders = null;
    hurdHeaders = null;
    gccCross = null;
  }) // (if crossSystem != null then { hostDrv = glibc213Cross; } else {});

  glibc213Cross = forceBuildDrv (makeOverridable (import ../development/libraries/glibc/2.13)
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

  glibc214 = (callPackage ../development/libraries/glibc/2.14 {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
    machHeaders = null;
    hurdHeaders = null;
    gccCross = null;
  }) // (lib.optionalAttrs (crossSystem != null) { hostDrv = glibc214Cross; });

  glibc214Cross = forceBuildDrv (makeOverridable (import ../development/libraries/glibc/2.14)
    (let crossGNU = (crossSystem != null && crossSystem.config == "i586-pc-gnu");
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
  libcCrossChooser = name : if (name == "glibc") then glibcCross
    else if (name == "uclibc") then uclibcCross
    else if (name == "msvcrt" && stdenv.cross.config == "x86_64-w64-mingw32") then
      windows.mingw_w64
    else if (name == "msvcrt") then windows.mingw_headers3
    else throw "Unknown libc";

  libcCross = assert crossSystem != null; libcCrossChooser crossSystem.libc;

  eglibc = callPackage ../development/libraries/eglibc {
    kernelHeaders = linuxHeaders;
    installLocales = config.glibc.locales or false;
  };

  glibcLocales = callPackage ../development/libraries/glibc/2.13/locales.nix { };

  glibcInfo = callPackage ../development/libraries/glibc/2.13/info.nix { };

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

  gmime = callPackage ../development/libraries/gmime { };

  gmm = callPackage ../development/libraries/gmm { };

  gmp = gmp5;

  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });

  # The GHC bootstrap binaries link against libgmp.so.3, which is in GMP 4.x.
  gmp4 = callPackage ../development/libraries/gmp/4.3.2.nix { };

  gmp5 = callPackage ../development/libraries/gmp/5.0.5.nix { };

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection { };

  goffice = callPackage ../development/libraries/goffice {
    inherit (gnome) libglade libgnomeui;
    gconf = gnome.GConf;
    libart = gnome.libart_lgpl;
  };

  goffice_0_9 = callPackage ../development/libraries/goffice/0.9.nix {
    inherit (gnome) libglade libgnomeui;
    gconf = gnome.GConf;
    libart = gnome.libart_lgpl;
    gtk = gtk3;
  };

  goocanvas = callPackage ../development/libraries/goocanvas { };

  google_perftools = callPackage ../development/libraries/google-perftools { };

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr { };

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

  qt_gstreamer = callPackage ../development/libraries/gstreamer/qt-gstreamer {};

  gnet = callPackage ../development/libraries/gnet { };

  gnu_efi = callPackage ../development/libraries/gnu-efi {
    stdenv = overrideInStdenv stdenv [gnumake381];
  };

  gnutls = callPackage ../development/libraries/gnutls {
    guileBindings = config.gnutls.guile or true;
  };

  gnutls2 = callPackage ../development/libraries/gnutls/2.12.nix {
    guileBindings = config.gnutls.guile or true;
  };

  gnutls_without_guile = gnutls.override { guileBindings = false; };
  gnutls2_without_guile = gnutls2.override { guileBindings = false; };

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

  glib = callPackage ../development/libraries/glib/2.34.x.nix { };

  glibmm = callPackage ../development/libraries/glibmm/2.30.x.nix { };

  glib_networking = callPackage ../development/libraries/glib-networking {};

  atk = callPackage ../development/libraries/atk/2.6.x.nix { };

  atkmm = callPackage ../development/libraries/atkmm/2.22.x.nix { };

  cairo = callPackage ../development/libraries/cairo { };

  pango = callPackage ../development/libraries/pango/1.30.x.nix { };

  pangomm = callPackage ../development/libraries/pangomm/2.28.x.nix { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf/2.26.x.nix { };

  gtk2 = callPackage ../development/libraries/gtk+/2.24.x.nix { };

  gtk = pkgs.gtk2;

  gtkmm = callPackage ../development/libraries/gtkmm/2.24.x.nix { };
  gtkmm3 = callPackage ../development/libraries/gtkmm/3.2.x.nix { };

  gtk3 = lowPrio (callPackage ../development/libraries/gtk+/3.2.x.nix { });

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

  gwenhywfar = callPackage ../development/libraries/gwenhywfar { };

  # TODO : Add MIT Kerberos and let admin choose.
  kerberos = heimdal;

  harfbuzz = callPackage ../development/libraries/harfbuzz { };

  hawknl = callPackage ../development/libraries/hawknl { };

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix { };

  herqq = callPackage ../development/libraries/herqq { };

  hspell = callPackage ../development/libraries/hspell { };

  hspellDicts = callPackage ../development/libraries/hspell/dicts.nix { };

  hsqldb = callPackage ../development/libraries/java/hsqldb { };

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

  intltool = gnome.intltool;
  intltool_standalone = callPackage ../development/tools/misc/intltool {};

  irrlicht3843 = callPackage ../development/libraries/irrlicht { };

  isocodes = callPackage ../development/libraries/iso-codes { };

  itk = callPackage ../development/libraries/itk { };

  jamp = builderDefsPackage ../games/jamp {
    inherit mesa SDL SDL_image SDL_mixer;
  };

  jasper = callPackage ../development/libraries/jasper { };

  jama = callPackage ../development/libraries/jama { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jetty_gwt = callPackage ../development/libraries/java/jetty-gwt { };

  jetty_util = callPackage ../development/libraries/java/jetty-util { };

  json_glib = callPackage ../development/libraries/json-glib { };

  json_c = callPackage ../development/libraries/json-c { };

  libjson = callPackage ../development/libraries/libjson { };

  judy = callPackage ../development/libraries/judy { };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix { };

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  lensfun = callPackage ../development/libraries/lensfun { };

  lesstif = callPackage ../development/libraries/lesstif { };

  lesstif93 = callPackage ../development/libraries/lesstif-0.93 { };

  levmar = callPackage ../development/libraries/levmar { };

  leptonica = callPackage ../development/libraries/leptonica { };

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

  libav = callPackage ../development/libraries/libav { };

  libavc1394 = callPackage ../development/libraries/libavc1394 { };

  libbluedevil = callPackage ../development/libraries/libbluedevil { };

  libbluray = callPackage ../development/libraries/libbluray { };

  libcaca = callPackage ../development/libraries/libcaca { };

  libcanberra = callPackage ../development/libraries/libcanberra { };

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio { };

  libcdr = callPackage ../development/libraries/libcdr { };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome) libsoup;
  };

  libchamplain_0_6 = callPackage ../development/libraries/libchamplain/0.6.nix {};

  libchop = callPackage ../development/libraries/libchop { };

  libcm = callPackage ../development/libraries/libcm { };

  libcroco = callPackage ../development/libraries/libcroco {};

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

  libebml = callPackage ../development/libraries/libebml { };

  libedit = callPackage ../development/libraries/libedit { };

  libelf = callPackage ../development/libraries/libelf { };

  libgadu = callPackage ../development/libraries/libgadu { };

  libgdata = (newScope gnome) ../development/libraries/libgdata {};
  libgdata_0_6 = (newScope gnome) ../development/libraries/libgdata/0.6.nix {};

  libgig = callPackage ../development/libraries/libgig { };

  libgnome_keyring = callPackage ../development/libraries/libgnome-keyring { };
  libgnome_keyring3 = callPackage ../development/libraries/libgnome-keyring/3.x.nix { };

  libgtop = callPackage ../development/libraries/libgtop {};

  libgweather = callPackage ../development/libraries/libgweather {};

  liblo = callPackage ../development/libraries/liblo { };

  liblrdf = librdf;

  liblscp = callPackage ../development/libraries/liblscp { };

  libev = builderDefsPackage ../development/libraries/libev { };

  libevent14 = callPackage ../development/libraries/libevent/1.4.nix { };
  libevent = callPackage ../development/libraries/libevent { };

  libewf = callPackage ../development/libraries/libewf { };

  libexif = callPackage ../development/libraries/libexif { };

  libexosip = callPackage ../development/libraries/exosip {};

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

  libgdiplus = callPackage ../development/libraries/libgdiplus { };

  libgpgerror = callPackage ../development/libraries/libgpg-error { };

  libgphoto2 = callPackage ../development/libraries/libgphoto2 { };

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

  libsamplerate = callPackage ../development/libraries/libsamplerate { };

  libspectre = callPackage ../development/libraries/libspectre { };

  libgsf = callPackage ../development/libraries/libgsf {
    inherit (gnome) gnome_vfs libbonobo;
  };

  libiconv = callPackage ../development/libraries/libiconv { };

  libiconvOrEmpty = if (libiconvOrNull == null) then [] else [libiconv];

  libiconvOrNull =
    if ((gcc ? libc && (gcc.libc != null)) || stdenv.isGlibc)
    then null
    else libiconv;

  libiconvOrLibc = if (libiconvOrNull == null) then gcc.libc else libiconv;

  libid3tag = callPackage ../development/libraries/libid3tag { };

  libidn = callPackage ../development/libraries/libidn { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libinfinity = callPackage ../development/libraries/libinfinity {
    inherit (gnome) gtkdoc;
  };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjpeg = callPackage ../development/libraries/libjpeg { };

  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };

  libjpeg62 = callPackage ../development/libraries/libjpeg/62.nix {
    libtool = libtool_1_5;
  };

  libkate = callPackage ../development/libraries/libkate { };

  libksba = callPackage ../development/libraries/libksba { };

  libmad = callPackage ../development/libraries/libmad { };

  libmatchbox = callPackage ../development/libraries/libmatchbox { };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmatroska = callPackage ../development/libraries/libmatroska { };

  libmcs = callPackage ../development/libraries/libmcs { };

  libmemcached = callPackage ../development/libraries/libmemcached { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod { };

  libmilter = callPackage ../development/libraries/libmilter { };

  libmms = callPackage ../development/libraries/libmms { };

  libmowgli = callPackage ../development/libraries/libmowgli { };

  libmng = callPackage ../development/libraries/libmng { };

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

  libnetfilter_conntrack = callPackage ../development/libraries/libnetfilter_conntrack { };

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

  libotr = callPackage ../development/libraries/libotr { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpar2 = callPackage ../development/libraries/libpar2 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpng = callPackage ../development/libraries/libpng { };
  libpng_apng = callPackage ../development/libraries/libpng/libpng-apng.nix { };
  libpng12 = callPackage ../development/libraries/libpng/12.nix { };

  libproxy = callPackage ../development/libraries/libproxy { };

  libpseudo = callPackage ../development/libraries/libpseudo { };

  libqalculate = callPackage ../development/libraries/libqalculate { };

  librsvg = callPackage ../development/libraries/librsvg { };

  librsync = callPackage ../development/libraries/librsync { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsigsegv = callPackage ../development/libraries/libsigsegv { };

  # To bootstrap SBCL, I need CLisp 2.44.1; it needs libsigsegv 2.5
  libsigsegv_25 = callPackage ../development/libraries/libsigsegv/2.5.nix { };

  libsndfile = callPackage ../development/libraries/libsndfile { };

  libsoup = callPackage ../development/libraries/libsoup { };

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

  libtasn1 = callPackage ../development/libraries/libtasn1 { };

  libtheora = callPackage ../development/libraries/libtheora { };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtiger = callPackage ../development/libraries/libtiger { };

  libtommath = callPackage ../development/libraries/libtommath { };

  libtorrentRasterbar = callPackage ../development/libraries/libtorrent-rasterbar { };

  libtunepimp = callPackage ../development/libraries/libtunepimp { };

  libgeotiff = callPackage ../development/libraries/libgeotiff { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  giflib = callPackage ../development/libraries/giflib { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libusb = callPackage ../development/libraries/libusb { };

  libusb1 = callPackage ../development/libraries/libusb1 { };

  libunwind = callPackage ../development/libraries/libunwind { };

  libv4l = lowPrio (v4l_utils.override {
    withQt4 = false;
  });

  libva = callPackage ../development/libraries/libva { };

  libvdpau = callPackage ../development/libraries/libvdpau { inherit (xlibs) libX11; };

  libvirt = callPackage ../development/libraries/libvirt { };

  libvisio = callPackage ../development/libraries/libvisio { };

  libvncserver = builderDefsPackage (import ../development/libraries/libvncserver) {
    inherit libtool libjpeg openssl zlib;
    inherit (xlibs) xproto libX11 damageproto libXdamage
      libXext xextproto fixesproto libXfixes xineramaproto
      libXinerama libXrandr randrproto libXtst;
  };

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

  libxcrypt = callPackage ../development/libraries/libxcrypt { };

  libxdg_basedir = callPackage ../development/libraries/libxdg-basedir { };

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

  libzip = callPackage ../development/libraries/libzip { };

  libzrtpcpp = callPackage ../development/libraries/libzrtpcpp { };
  libzrtpcpp_1_6 = callPackage ../development/libraries/libzrtpcpp/1.6.nix {
    ccrtp = ccrtp_1_8;
  };

  lightning = callPackage ../development/libraries/lightning { };

  lirc = callPackage ../development/libraries/lirc { };

  liquidwar = builderDefsPackage ../games/liquidwar {
    inherit (xlibs) xproto libX11 libXrender;
    inherit gmp mesa libjpeg libpng
      expat gettext perl
      SDL SDL_image SDL_mixer SDL_ttf
      curl sqlite
      libogg libvorbis
      ;
   guile = guile_1_8;
  };

  log4cxx = callPackage ../development/libraries/log4cxx { };

  log4cplus = callPackage ../development/libraries/log4cplus { };

  loudmouth = callPackage ../development/libraries/loudmouth { };

  lzo = callPackage ../development/libraries/lzo { };

  mdds = callPackage ../development/libraries/mdds { };

  # failed to build
  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mesaSupported = lib.elem system lib.platforms.mesaPlatforms;

  mesa = callPackage ../development/libraries/mesa { };

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

  mkvtoolnix = callPackage ../applications/video/mkvtoolnix { };

  mlt = callPackage ../development/libraries/mlt { };

  libmpeg2 = callPackage ../development/libraries/libmpeg2 { };

  mpeg2dec = libmpeg2;

  msilbc = callPackage ../development/libraries/msilbc { };

  mp4v2 = callPackage ../development/libraries/mp4v2 { };

  mpc = callPackage ../development/libraries/mpc { };

  mpich2 = callPackage ../development/libraries/mpich2 { };

  mtdev = callPackage ../development/libraries/mtdev { };

  muparser = callPackage ../development/libraries/muparser { };

  mygui = callPackage ../development/libraries/mygui {};

  myguiSvn = callPackage ../development/libraries/mygui/svn.nix {};

  mysocketw = callPackage ../development/libraries/mysocketw { };

  mythes = callPackage ../development/libraries/mythes { };

  ncurses = makeOverridable (import ../development/libraries/ncurses) {
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

  neon = neon029;

  neon026 = callPackage ../development/libraries/neon/0.26.nix {
    compressionSupport = true;
    sslSupport = true;
  };

  neon028 = callPackage ../development/libraries/neon/0.28.nix {
    compressionSupport = true;
    sslSupport = true;
  };

  neon029 = callPackage ../development/libraries/neon/0.29.nix {
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

  opencascade = callPackage ../development/libraries/opencascade {
    automake = automake111x;
    ftgl = ftgl212;
  };

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

  openlierox = builderDefsPackage ../games/openlierox {
    inherit (xlibs) libX11 xproto;
    inherit gd SDL SDL_image SDL_mixer zlib libxml2
      pkgconfig;
  };

  libopensc_dnie = callPackage ../development/libraries/libopensc-dnie {
    opensc = opensc_0_11_7;
  };

  ois = callPackage ../development/libraries/ois {};

  opal = callPackage ../development/libraries/opal {};

  openjpeg = callPackage ../development/libraries/openjpeg { };

  openscenegraph = callPackage ../development/libraries/openscenegraph {};

  openssl = callPackage ../development/libraries/openssl {
    fetchurl = fetchurlBoot;
    cryptodevHeaders = linuxPackages.cryptodev.override {
      fetchurl = fetchurlBoot;
      onlyHeaders = true;
    };
  };

  ortp = callPackage ../development/libraries/ortp { };

  p11_kit = callPackage ../development/libraries/p11-kit { };

  pangoxsl = callPackage ../development/libraries/pangoxsl { };

  pcre = callPackage ../development/libraries/pcre {
    unicodeSupport = config.pcre.unicode or true;
  };

  pcre_8_30 = callPackage ../development/libraries/pcre/8.30.nix {
    unicodeSupport = config.pcre.unicode or true;
  };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  phonon = callPackage ../development/libraries/phonon { };

  phonon_backend_gstreamer = callPackage ../development/libraries/phonon-backend-gstreamer { };

  phonon_backend_vlc = callPackage ../development/libraries/phonon-backend-vlc { };

  physfs = callPackage ../development/libraries/physfs { };

  plib = callPackage ../development/libraries/plib { };

  pocketsphinx = callPackage ../development/libraries/pocketsphinx { };

  podofo = callPackage ../development/libraries/podofo { };

  polkit = callPackage ../development/libraries/polkit { };

  polkit_qt_1 = callPackage ../development/libraries/polkit-qt-1 { };

  policykit = callPackage ../development/libraries/policykit { };

  poppler = callPackage ../development/libraries/poppler {
    gtkSupport = true;
    qt4Support = false;
  };

  popplerQt4 = poppler.override {
    gtkSupport = false;
    qt4Support = true;
  };

  popt = callPackage ../development/libraries/popt { };

  portaudio = callPackage ../development/libraries/portaudio { };
  portaudioSVN = callPackage ../development/libraries/portaudio/svn-head.nix { };

  prison = callPackage ../development/libraries/prison { };

  proj = callPackage ../development/libraries/proj { };

  postgis = callPackage ../development/libraries/postgis { };

  protobuf = callPackage ../development/libraries/protobuf { };

  protobufc = callPackage ../development/libraries/protobufc { };

  pth = callPackage ../development/libraries/pth { };

  ptlib = callPackage ../development/libraries/ptlib {};

  qca2 = callPackage ../development/libraries/qca2 {};

  qca2_ossl = callPackage ../development/libraries/qca2/ossl.nix {};

  qimageblitz = callPackage ../development/libraries/qimageblitz {};

  qjson = callPackage ../development/libraries/qjson { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qt3 = callPackage ../development/libraries/qt-3 {
    openglSupport = mesaSupported;
  };

  qt4 = pkgs.kde4.qt4;

  qt47 = callPackage ../development/libraries/qt-4.x/4.7 { };

  qt48 = callPackage ../development/libraries/qt-4.x/4.8 {
    # GNOME dependencies are not used unless gtkStyle == true
    inherit (pkgs.gnome) libgnomeui GConf gnome_vfs;
  };

  qt4_for_qtcreator = qt48.override {
    developerBuild = true;
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
    alsaSupport = true;
    x11Support = true;
    pulseaudioSupport = false; # better go through ALSA
  };

  SDL_gfx = callPackage ../development/libraries/SDL_gfx { };

  SDL_image = callPackage ../development/libraries/SDL_image { };

  SDL_mixer = callPackage ../development/libraries/SDL_mixer { };

  SDL_net = callPackage ../development/libraries/SDL_net { };

  SDL_sound = callPackage ../development/libraries/SDL_sound { };

  SDL_ttf = callPackage ../development/libraries/SDL_ttf { };

  serd = callPackage ../development/libraries/serd {};

  silgraphite = callPackage ../development/libraries/silgraphite {};

  simgear = callPackage ../development/libraries/simgear {};

  sfml_git = callPackage ../development/libraries/sfml { };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile_1_8;
  };

  smpeg = callPackage ../development/libraries/smpeg { };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

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

  sqlite = lowPrio (callPackage ../development/libraries/sqlite {
    readline = null;
    ncurses = null;
  });

  sqlite36 = callPackage ../development/libraries/sqlite/3.6.x.nix {
    readline = null;
    ncurses = null;
  };

  sqliteInteractive = appendToName "interactive" (sqlite.override {
    inherit readline ncurses;
  });

  sqliteFull = lowPrio (callPackage ../development/libraries/sqlite/full.nix {
    inherit readline ncurses;
  });

  stlport = callPackage ../development/libraries/stlport { };

  strigi = callPackage ../development/libraries/strigi {};

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

  tk = callPackage ../development/libraries/tk { };

  tnt = callPackage ../development/libraries/tnt { };

  tokyocabinet = callPackage ../development/libraries/tokyo-cabinet { };
  tokyotyrant = callPackage ../development/libraries/tokyo-tyrant { };

  tremor = callPackage ../development/libraries/tremor { };

  unicap = callPackage ../development/libraries/unicap {};

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (import ../development/libraries/unixODBCDrivers {
    inherit fetchurl stdenv unixODBC glibc libtool openssl zlib;
    inherit postgresql mysql sqlite;
  });

  urt = callPackage ../development/libraries/urt { };

  ustr = callPackage ../development/libraries/ustr { };

  ucommon = callPackage ../development/libraries/ucommon { };

  vamp = callPackage ../development/libraries/audio/vamp { };

  vcdimager = callPackage ../development/libraries/vcdimager { };

  vigra = callPackage ../development/libraries/vigra {
    inherit (pkgs.pythonPackages) numpy;
  };

  vlock = callPackage ../misc/screensavers/vlock { };

  vmime = callPackage ../development/libraries/vmime { };

  vrpn = callPackage ../development/libraries/vrpn { };

  vtk = callPackage ../development/libraries/vtk { };

  vtkWithQt4 = vtk.override { useQt4 = true; };

  vxl = callPackage ../development/libraries/vxl {
    libpng = libpng12;
  };

  webkit =
    builderDefsPackage ../development/libraries/webkit {
      inherit (gnome) gtkdoc libsoup;
      inherit atk pango glib;
      gtk = gtk3;
      inherit freetype fontconfig gettext gperf curl
        libjpeg libtiff libxml2 libxslt sqlite
        icu cairo intltool automake libtool
        pkgconfig autoconf bison libproxy enchant
        python ruby which flex geoclue mesa;
      inherit gstreamer gst_plugins_base gst_ffmpeg
        gst_plugins_good;
      inherit (xlibs) libXt renderproto libXrender kbproto;
      libpng = libpng12;
      perl = perl510;
    };

  webkit_gtk2 =
    builderDefsPackage ../development/libraries/webkit/gtk2.nix {
      inherit (gnome) gtkdoc libsoup;
      inherit gtk atk pango glib;
      inherit freetype fontconfig gettext gperf curl
        libjpeg libtiff libxml2 libxslt sqlite
        icu cairo intltool automake libtool
        pkgconfig autoconf bison libproxy enchant
        python ruby which flex geoclue;
      inherit gstreamer gst_plugins_base gst_ffmpeg
        gst_plugins_good;
      inherit (xlibs) libXt renderproto libXrender;
      libpng = libpng12;
      perl = perl510;
    };

  webkitSVN =
    builderDefsPackage ../development/libraries/webkit/svn.nix {
      inherit (gnome) gtkdoc libsoup;
      inherit gtk atk pango glib;
      inherit freetype fontconfig gettext gperf curl
        libjpeg libtiff libxml2 libxslt sqlite
        icu cairo perl intltool automake libtool
        pkgconfig autoconf bison libproxy enchant
        python ruby which flex geoclue;
      inherit gstreamer gst_plugins_base gst_ffmpeg
        gst_plugins_good;
      inherit (xlibs) libXt renderproto libXrender;
      libpng = libpng12;
    };

  wvstreams = callPackage ../development/libraries/wvstreams { };

  wxGTK = wxGTK28;

  wxGTK28 = callPackage ../development/libraries/wxGTK-2.8 {
    inherit (gnome) GConf;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
  };

  wxGTK29 = callPackage ../development/libraries/wxGTK-2.9/default.nix {
    inherit (gnome) GConf;
    withMesa = lib.elem system lib.platforms.mesaPlatforms;
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

  zziplib = callPackage ../development/libraries/zziplib { };


  ### DEVELOPMENT / LIBRARIES / JAVASCRIPT

  jquery_ui = callPackage ../development/libraries/javascript/jquery-ui { };

  ### DEVELOPMENT / PERL MODULES

  buildPerlPackage = import ../development/perl-modules/generic perl;

  perlPackages = recurseIntoAttrs (import ./perl-packages.nix {
    inherit pkgs;
  });

  perl510Packages = import ./perl-packages.nix {
    pkgs = pkgs // {
      perl = perl510;
      buildPerlPackage = import ../development/perl-modules/generic perl510;
    };
  };

  perlXMLParser = perlPackages.XMLParser;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;


  ### DEVELOPMENT / PYTHON MODULES

  buildPythonPackage = pythonPackages.buildPythonPackage;

  pythonPackages = python27Packages;

  python26Packages = import ./python-packages.nix {
    inherit pkgs;
    python = python26;
  };

  python27Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    python = python27;
  });

  foursuite = callPackage ../development/python-modules/4suite { };

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  numeric = callPackage ../development/python-modules/numeric { };

  pil = python27Packages.pil;

  psyco = callPackage ../development/python-modules/psyco { };

  pycairo = callPackage ../development/python-modules/pycairo { };

  pycrypto = python27Packages.pycrypto;

  pycups = callPackage ../development/python-modules/pycups { };

  pyexiv2 = callPackage ../development/python-modules/pyexiv2 { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygobject = callPackage ../development/python-modules/pygobject { };

  pygtk = callPackage ../development/python-modules/pygtk { };

  pyGtkGlade = callPackage ../development/python-modules/pygtk {
    inherit (gnome) libglade;
  };

  pyopenssl = builderDefsPackage (import ../development/python-modules/pyopenssl) {
    inherit python openssl;
  };

  rhpl = callPackage ../development/python-modules/rhpl { };

  sip = callPackage ../development/python-modules/python-sip { };

  pyqt4 = callPackage ../development/python-modules/pyqt { };

  pysideApiextractor = callPackage ../development/python-modules/pyside/apiextractor.nix { };

  pysideGeneratorrunner = callPackage ../development/python-modules/pyside/generatorrunner.nix { };

  pyside = callPackage ../development/python-modules/pyside { };

  pysideTools = callPackage ../development/python-modules/pyside/tools.nix { };

  pysideShiboken = callPackage ../development/python-modules/pyside/shiboken.nix { };

  pyx = callPackage ../development/python-modules/pyx { };

  pyxml = callPackage ../development/python-modules/pyxml { };

  setuptools = pythonPackages.setuptools;

  wxPython = pythonPackages.wxPython;
  wxPython28 = pythonPackages.wxPython28;

  twisted = pythonPackages.twisted;

  ZopeInterface = pythonPackages.zopeInterface;


  ### SERVERS

  rdf4store = callPackage ../servers/http/4store { };

  apacheHttpd = pkgs.apacheHttpd_2_2;

  apacheHttpd_2_2 = callPackage ../servers/http/apache-httpd/2.2.nix {
    sslSupport = true;
  };

  apacheHttpd_2_4 = lowPrio (callPackage ../servers/http/apache-httpd/2.4.nix {
    sslSupport = true;
  });

  sabnzbd = callPackage ../servers/sabnzbd { };

  bind = callPackage ../servers/dns/bind {
    inherit openssl libtool perl;
  };

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

  dovecot = callPackage ../servers/mail/dovecot { };

  ejabberd = callPackage ../servers/xmpp/ejabberd { };

  elasticmq = callPackage ../servers/elasticmq { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { };

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

  mediatomb = callPackage ../servers/mediatomb {
    ffmpeg = ffmpeg_0_6_90;
  };

  memcached = callPackage ../servers/memcached {};

  mod_evasive = callPackage ../servers/http/apache-modules/mod_evasive { };

  mod_python = callPackage ../servers/http/apache-modules/mod_python { };

  mod_fastcgi = callPackage ../servers/http/apache-modules/mod_fastcgi { };

  mod_wsgi = callPackage ../servers/http/apache-modules/mod_wsgi { };

  mpd = callPackage ../servers/mpd { };
  mpd_clientlib = callPackage ../servers/mpd/clientlib.nix { };

  miniHttpd = callPackage ../servers/http/mini-httpd {};

  myserver = callPackage ../servers/http/myserver { };

  nginx = callPackage ../servers/http/nginx { };

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

  mongodb = callPackage ../servers/nosql/mongodb {
    useV8 = (config.mongodb.useV8 or false);
  };

  mysql4 = import ../servers/sql/mysql {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  mysql5 = import ../servers/sql/mysql5 {
    inherit fetchurl stdenv ncurses zlib perl openssl;
    ps = procps; /* !!! Linux only */
  };

  mysql51 = import ../servers/sql/mysql51 {
    inherit fetchurl ncurses zlib perl openssl stdenv;
    ps = procps; /* !!! Linux only */
  };

  mysql55 = callPackage ../servers/sql/mysql55 { };

  mysql = mysql51;

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  nagios = callPackage ../servers/monitoring/nagios {
    gdSupport = true;
  };

  nagiosPluginsOfficial = callPackage ../servers/monitoring/nagios/plugins/official { };

  net_snmp = callPackage ../servers/monitoring/net-snmp { };

  oidentd = callPackage ../servers/identd/oidentd { };

  openfire = callPackage ../servers/xmpp/openfire { };

  OVMF = callPackage ../applications/virtualization/OVMF { };

  postgresql = postgresql83;

  postgresql83 = callPackage ../servers/sql/postgresql/8.3.x.nix { };

  postgresql84 = callPackage ../servers/sql/postgresql/8.4.x.nix { };

  postgresql90 = callPackage ../servers/sql/postgresql/9.0.x.nix { };

  postgresql91 = callPackage ../servers/sql/postgresql/9.1.x.nix { };

  postgresql92 = callPackage ../servers/sql/postgresql/9.2.x.nix { };

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  psqlodbc = callPackage ../servers/sql/postgresql/psqlodbc {
    postgresql = postgresql91;
  };

  pyIRCt = builderDefsPackage (import ../servers/xmpp/pyIRCt) {
    inherit xmpppy pythonIRClib python makeWrapper;
  };

  pyMAILt = builderDefsPackage (import ../servers/xmpp/pyMAILt) {
    inherit xmpppy python makeWrapper fetchcvs;
  };

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

  tomcat5 = callPackage ../servers/http/tomcat/5.0.nix { };

  tomcat6 = callPackage ../servers/http/tomcat/6.0.nix { };

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  virtuoso = callPackage ../servers/sql/virtuoso { };

  vsftpd = callPackage ../servers/ftp/vsftpd { };

  xinetd = callPackage ../servers/xinetd { };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg/default.nix {
    inherit fetchurl fetchsvn stdenv pkgconfig freetype fontconfig
      libxslt expat libdrm libpng zlib perl mesa
      xkeyboard_config dbus libuuid openssl gperf m4
      autoconf libtool xmlto asciidoc udev flex bison python mtdev;
    automake = automake110x;
  });

  xorgReplacements = callPackage ../servers/x11/xorg/replacements.nix { };

  xorgVideoUnichrome = callPackage ../servers/x11/xorg/unichrome/default.nix { };

  zabbix = recurseIntoAttrs (import ../servers/monitoring/zabbix {
    inherit fetchurl stdenv pkgconfig postgresql curl openssl zlib;
  });

  zabbix20 = recurseIntoAttrs (import ../servers/monitoring/zabbix/2.0.nix {
    inherit fetchurl stdenv pkgconfig postgresql curl openssl zlib gettext;
  });


  ### OS-SPECIFIC

  afuse = callPackage ../os-specific/linux/afuse { };

  amdUcode = callPackage ../os-specific/linux/firmware/amd-ucode { };

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

  microcode2ucode = callPackage ../os-specific/linux/microcode/converter.nix { };

  microcodeIntel = callPackage ../os-specific/linux/microcode/intel.nix { };

  apparmor = callPackage ../os-specific/linux/apparmor {
    inherit (perlPackages) LocaleGettext TermReadKey RpcXML;
  };

  atop = callPackage ../os-specific/linux/atop { };

  b43Firmware_5_1_138 = callPackage ../os-specific/linux/firmware/b43-firmware/5.1.138.nix { };

  b43FirmwareCutter = callPackage ../os-specific/linux/firmware/b43-firmware-cutter { };

  bcm43xx = callPackage ../os-specific/linux/firmware/bcm43xx { };

  bluez = callPackage ../os-specific/linux/bluez { };

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

  dstat = callPackage ../os-specific/linux/dstat { };

  libuuid =
    if crossSystem != null && crossSystem.config == "i586-pc-gnu"
    then (utillinux // {
      hostDrv = lib.overrideDerivation utillinux.hostDrv (args: {
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

  eject = callPackage ../os-specific/linux/eject { };

  ffado = callPackage ../os-specific/linux/ffado { };

  fbterm = callPackage ../os-specific/linux/fbterm { };

  fuse = callPackage ../os-specific/linux/fuse { };

  fxload = callPackage ../os-specific/linux/fxload { };

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

  iputils = callPackage ../os-specific/linux/iputils { };

  iptables = callPackage ../os-specific/linux/iptables { };

  ipw2100fw = callPackage ../os-specific/linux/firmware/ipw2100 { };

  ipw2200fw = callPackage ../os-specific/linux/firmware/ipw2200 { };

  iw = callPackage ../os-specific/linux/iw { };

  iwlwifi1000ucode = callPackage ../os-specific/linux/firmware/iwlwifi-1000-ucode { };

  iwlwifi2030ucode = callPackage ../os-specific/linux/firmware/iwlwifi-2030-ucode { };

  iwlwifi3945ucode = callPackage ../os-specific/linux/firmware/iwlwifi-3945-ucode { };

  iwlwifi4965ucodeV1 = callPackage ../os-specific/linux/firmware/iwlwifi-4965-ucode { };

  iwlwifi4965ucodeV2 = callPackage ../os-specific/linux/firmware/iwlwifi-4965-ucode/version-2.nix { };

  iwlwifi5000ucode = callPackage ../os-specific/linux/firmware/iwlwifi-5000-ucode { };

  iwlwifi5150ucode = callPackage ../os-specific/linux/firmware/iwlwifi-5150-ucode { };

  iwlwifi6000ucode = callPackage ../os-specific/linux/firmware/iwlwifi-6000-ucode { };

  iwlwifi6000g2aucode = callPackage ../os-specific/linux/firmware/iwlwifi-6000g2a-ucode { };

  iwlwifi6000g2bucode = callPackage ../os-specific/linux/firmware/iwlwifi-6000g2b-ucode { };

  jujuutils = callPackage ../os-specific/linux/jujuutils {
    linuxHeaders = linuxHeaders33;
  };

  kbd = callPackage ../os-specific/linux/kbd { };

  latencytop = callPackage ../os-specific/linux/latencytop { };

  libaio = callPackage ../os-specific/linux/libaio { };

  libatasmart = callPackage ../os-specific/linux/libatasmart { };

  libcgroup = callPackage ../os-specific/linux/libcgroup { };

  libnl = callPackage ../os-specific/linux/libnl { };

  linuxConsoleTools = callPackage ../os-specific/linux/consoletools { };

  linuxHeaders = callPackage ../os-specific/linux/kernel-headers { };

  linuxHeaders33 = callPackage ../os-specific/linux/kernel-headers/3.3.5.nix { };

  linuxHeaders26Cross = forceBuildDrv (import ../os-specific/linux/kernel-headers/2.6.32.nix {
    inherit stdenv fetchurl perl;
    cross = assert crossSystem != null; crossSystem;
  });

  linuxHeaders24Cross = forceBuildDrv (import ../os-specific/linux/kernel-headers/2.4.nix {
    inherit stdenv fetchurl perl;
    cross = assert crossSystem != null; crossSystem;
  });

  # We can choose:
  linuxHeadersCrossChooser = ver : if (ver == "2.4") then linuxHeaders24Cross
    else if (ver == "2.6") then linuxHeaders26Cross
    else throw "Unknown linux kernel version";

  linuxHeadersCross = assert crossSystem != null;
    linuxHeadersCrossChooser crossSystem.platform.kernelMajor;

  linuxHeaders_2_6_28 = callPackage ../os-specific/linux/kernel-headers/2.6.28.nix { };

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  linux_2_6_15 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.15.nix) {
    inherit fetchurl perl mktemp module_init_tools;
    stdenv = overrideInStdenv stdenv [ gcc34 gnumake381 ];
    kernelPatches =
      [ kernelPatches.cifs_timeout_2_6_15
      ];
  };

  linux_2_6_32 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.32.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_31
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs2_2_6_32
        kernelPatches.cifs_timeout_2_6_29
        kernelPatches.no_xsave
        kernelPatches.dell_rfkill
      ];
  };

  linux_2_6_32_xen = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.32-xen.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_31
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs2_2_6_32
        kernelPatches.cifs_timeout_2_6_29
        kernelPatches.no_xsave
        kernelPatches.dell_rfkill
      ];
  };

  linux_2_6_35 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.35.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_35
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs2_2_6_35
        kernelPatches.cifs_timeout_2_6_35
      ] ++ lib.optional (platform.kernelArch == "arm")
        kernelPatches.sheevaplug_modules_2_6_35;
  };

  linux_2_6_35_oldI686 = linux_2_6_35.override {
    extraConfig = ''
      HIGHMEM64G? n
      XEN? n
    '';
    extraMeta = {
      platforms = ["i686-linux"];
      maintainers = [lib.maintainers.raskin];
    };
  };

  linux_3_0 = makeOverridable (import ../os-specific/linux/kernel/linux-3.0.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ #kernelPatches.fbcondecor_2_6_38
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_0
      ];
  };

  linux_3_1 = makeOverridable (import ../os-specific/linux/kernel/linux-3.1.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ #kernelPatches.fbcondecor_2_6_38
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_1
      ];
  };

  linux_3_2 = makeOverridable (import ../os-specific/linux/kernel/linux-3.2.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ #kernelPatches.fbcondecor_2_6_38
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_2
        kernelPatches.cifs_timeout_2_6_38
      ];
  };

  linux_3_2_xen = linux_3_2.override {
    extraConfig = ''
      XEN_DOM0 y
    '';
  };

  linux_3_3 = makeOverridable (import ../os-specific/linux/kernel/linux-3.3.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ #kernelPatches.fbcondecor_2_6_38
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_3
      ];
  };

  linux_3_4 = makeOverridable (import ../os-specific/linux/kernel/linux-3.4.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ #kernelPatches.fbcondecor_2_6_38
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_4
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
      ];
  };

  linux_3_5 = makeOverridable (import ../os-specific/linux/kernel/linux-3.5.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_5
        kernelPatches.perf3_5
        kernelPatches.cifs_timeout_3_5_7
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_6 = makeOverridable (import ../os-specific/linux/kernel/linux-3.6.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_6
      ] ++ lib.optionals (platform.kernelArch == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linux_3_7 = makeOverridable (import ../os-specific/linux/kernel/linux-3.7.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs3_7
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

  linuxPackagesFor = kernel: self: let callPackage = newScope self; in rec {

    inherit kernel;

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    aufs =
      if kernel.features ? aufs2 then
        callPackage ../os-specific/linux/aufs/2.nix { }
      else if kernel.features ? aufs3 then
        callPackage ../os-specific/linux/aufs/3.nix { }
      else null;

    aufs_util =
      if kernel.features ? aufs2 then
        callPackage ../os-specific/linux/aufs-util/2.nix { }
      else if kernel.features ? aufs3 then
        callPackage ../os-specific/linux/aufs-util/3.nix { }
      else null;

    blcr = callPackage ../os-specific/linux/blcr { };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    e1000e = callPackage ../os-specific/linux/e1000e {};

    exmap = callPackage ../os-specific/linux/exmap { };

    frandom = callPackage ../os-specific/linux/frandom { };

    iscsitarget = callPackage ../os-specific/linux/iscsitarget { };

    iwlwifi = callPackage ../os-specific/linux/iwlwifi { };

    iwlwifi4965ucode =
      (if (builtins.compareVersions kernel.version "2.6.27" == 0)
          || (builtins.compareVersions kernel.version "2.6.27" == 1)
       then iwlwifi4965ucodeV2
       else iwlwifi4965ucodeV1);

    atheros = callPackage ../os-specific/linux/atheros/0.9.4.nix { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta/default.nix { };

    kernelHeaders = callPackage ../os-specific/linux/kernel-headers { };

    nvidia_x11 = callPackage ../os-specific/linux/nvidia-x11 { };

    nvidia_x11_legacy96 = callPackage ../os-specific/linux/nvidia-x11/legacy96.nix { };
    nvidia_x11_legacy173 = callPackage ../os-specific/linux/nvidia-x11/legacy173.nix { };
    nvidia_x11_legacy304 = callPackage ../os-specific/linux/nvidia-x11/legacy304.nix { };

    openafsClient = callPackage ../servers/openafs-client { };

    openiscsi = callPackage ../os-specific/linux/open-iscsi { };

    wis_go7007 = callPackage ../os-specific/linux/wis-go7007 { };

    kqemu = callPackage ../os-specific/linux/kqemu { };

    klibc = callPackage ../os-specific/linux/klibc {
      linuxHeaders = glibc.kernelHeaders;
    };

    splashutils = let hasFbConDecor = if kernel ? features
      then kernel.features ? fbConDecor
      else kernel.config.isEnabled "FB_CON_DECOR";
    in if hasFbConDecor then pkgs.splashutils else null;

    /* compiles but has to be integrated into the kernel somehow
      Let's have it uncommented and finish it..
    */
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    ov511 = callPackage ../os-specific/linux/ov511 {
      stdenv = overrideGCC stdenv gcc34;
    };

    perf = callPackage ../os-specific/linux/kernel/perf.nix { };

    spl = callPackage ../os-specific/linux/spl/default.nix { };

    sysprof = callPackage ../development/tools/profiling/sysprof {
      inherit (gnome) libglade;
    };

    systemtap = callPackage ../development/tools/profiling/systemtap {
      linux = kernel;
      inherit (gnome) libglademm;
    };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    v86d = callPackage ../os-specific/linux/v86d { };

    virtualbox = callPackage ../applications/virtualization/virtualbox {
      stdenv = stdenv_32bit;
      inherit (gnome) libIDL;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions { };

    zfs = callPackage ../os-specific/linux/zfs/default.nix { };
  };

  # Build the kernel modules for the some of the kernels.
  linuxPackages_2_6_32 = recurseIntoAttrs (linuxPackagesFor linux_2_6_32 pkgs.linuxPackages_2_6_32);
  linuxPackages_2_6_32_xen = linuxPackagesFor linux_2_6_32_xen pkgs.linuxPackages_2_6_32_xen;
  linuxPackages_2_6_35 = recurseIntoAttrs (linuxPackagesFor linux_2_6_35 pkgs.linuxPackages_2_6_35);
  linuxPackages_3_0 = recurseIntoAttrs (linuxPackagesFor linux_3_0 pkgs.linuxPackages_3_0);
  linuxPackages_3_1 = recurseIntoAttrs (linuxPackagesFor linux_3_1 pkgs.linuxPackages_3_1);
  linuxPackages_3_2 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_2 pkgs.linuxPackages_3_2);
  linuxPackages_3_2_xen = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_2_xen pkgs.linuxPackages_3_2_xen);
  linuxPackages_3_3 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_3 pkgs.linuxPackages_3_3);
  linuxPackages_3_4 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_4 pkgs.linuxPackages_3_4);
  linuxPackages_3_5 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_5 pkgs.linuxPackages_3_5);
  linuxPackages_3_6 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_6 pkgs.linuxPackages_3_6);
  linuxPackages_3_7 = recurseIntoAttrs (linuxPackagesFor pkgs.linux_3_7 pkgs.linuxPackages_3_7);

  # The current default kernel / kernel modules.
  linux = linuxPackages.kernel;
  linuxPackages = linuxPackages_3_2;

  # A function to build a manually-configured kernel
  linuxManualConfig = import ../os-specific/linux/kernel/manual-config.nix {
    inherit (pkgs) stdenv runCommand nettools perl kmod writeTextFile;
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

  klibcShrunk = callPackage ../os-specific/linux/klibc/shrunk.nix { };

  kmod = callPackage ../os-specific/linux/kmod { };

  kvm = qemu_kvm;

  libcap = callPackage ../os-specific/linux/libcap { };

  libcap_progs = callPackage ../os-specific/linux/libcap/progs.nix { };

  libcap_pam = callPackage ../os-specific/linux/libcap/pam.nix { };

  libcap_manpages = callPackage ../os-specific/linux/libcap/man.nix { };

  libnscd = callPackage ../os-specific/linux/libnscd { };

  libnotify = callPackage ../development/libraries/libnotify { };

  libvolume_id = callPackage ../os-specific/linux/libvolume_id { };

  lsscsi = callPackage ../os-specific/linux/lsscsi { };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  mdadm = callPackage ../os-specific/linux/mdadm { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  module_init_tools = callPackage ../os-specific/linux/module-init-tools { };

  mountall = callPackage ../os-specific/linux/mountall { };

  aggregateModules = modules:
    import ../os-specific/linux/module-init-tools/aggregator.nix {
      inherit stdenv module_init_tools modules buildEnv;
    };

  modutils = callPackage ../os-specific/linux/modutils {
    stdenv = overrideGCC stdenv gcc34;
  };

  multipath_tools = callPackage ../os-specific/linux/multipath-tools { };

  nettools = callPackage ../os-specific/linux/net-tools { };

  neverball = callPackage ../games/neverball { };

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

  pam_unix2 = callPackage ../os-specific/linux/pam_unix2 { };

  pam_usb = callPackage ../os-specific/linux/pam_usb { };

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils {
    firmware = config.pcmciaUtils.firmware or [];
    config = config.pcmciaUtils.config or null;
  };

  pmount = callPackage ../os-specific/linux/pmount { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  pmtools = callPackage ../os-specific/linux/pmtools { };

  policycoreutils = callPackage ../os-specific/linux/policycoreutils { };

  powertop = callPackage ../os-specific/linux/powertop { };

  prayer = callPackage ../servers/prayer { };

  procps = callPackage ../os-specific/linux/procps { };

  pwdutils = callPackage ../os-specific/linux/pwdutils { };

  qemu_kvm = callPackage ../os-specific/linux/qemu-kvm { };

  firmwareLinuxNonfree = callPackage ../os-specific/linux/firmware/firmware-linux-nonfree { };

  radeontools = callPackage ../os-specific/linux/radeontools { };

  radeonR700 = callPackage ../os-specific/linux/firmware/radeon-r700 { };
  radeonR600 = callPackage ../os-specific/linux/firmware/radeon-r600 { };
  radeonJuniper = callPackage ../os-specific/linux/firmware/radeon-juniper { };

  regionset = callPackage ../os-specific/linux/regionset { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rfkill_udev = callPackage ../os-specific/linux/rfkill/udev.nix { };

  ralink_fw = callPackage ../os-specific/linux/firmware/ralink { };

  rt2860fw = callPackage ../os-specific/linux/firmware/rt2860 { };

  rt2870fw = callPackage ../os-specific/linux/firmware/rt2870 { };

  rtkit = callPackage ../os-specific/linux/rtkit { };

  rtl8192cfw = callPackage ../os-specific/linux/firmware/rtl8192c { };

  rtl8168e2fw = callPackage ../os-specific/linux/firmware/rtl8168e-2 { };

  sdparm = callPackage ../os-specific/linux/sdparm { };

  shadow = callPackage ../os-specific/linux/shadow { };

  splashutils = callPackage ../os-specific/linux/splashutils/default.nix { };

  statifier = builderDefsPackage (import ../os-specific/linux/statifier) { };

  sysfsutils = callPackage ../os-specific/linux/sysfsutils { };

  # Provided with sysfsutils.
  libsysfs = sysfsutils;
  systool = sysfsutils;

  sysklogd = callPackage ../os-specific/linux/sysklogd { };

  syslinux = callPackage ../os-specific/linux/syslinux { };

  sysstat = callPackage ../os-specific/linux/sysstat { };

  systemd = callPackage ../os-specific/linux/systemd { };

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

  ubootChooser = name : if (name == "upstream") then ubootUpstream
    else if (name == "sheevaplug") then ubootSheevaplug
    else if (name == "guruplug") then ubootGuruplug
    else if (name == "nanonote") then ubootNanonote
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
  udev173 = callPackage ../os-specific/linux/udev/173.nix { };
  udev = pkgs.udev173;

  udisks = callPackage ../os-specific/linux/udisks { };

  untie = callPackage ../os-specific/linux/untie { };

  upower = callPackage ../os-specific/linux/upower { };

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
      mingw_headers = mingw_headers2;
    };

    wxMSW = callPackage ../os-specific/windows/wxMSW-2.8 { };
  };

  wesnoth = callPackage ../games/wesnoth {
    lua = lua5;
    boost = boost147;
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

  gentium = callPackage ../data/fonts/gentium {};

  gnome_user_docs = callPackage ../data/documentation/gnome-user-docs { };

  gsettings_desktop_schemas = callPackage ../data/misc/gsettings-desktop-schemas {};

  hicolor_icon_theme = callPackage ../data/misc/hicolor-icon-theme { };

  inconsolata = callPackage ../data/fonts/inconsolata {};

  junicode = callPackage ../data/fonts/junicode { };

  liberation_ttf = callPackage ../data/fonts/redhat-liberation-fonts { };

  libertine = builderDefsPackage (import ../data/fonts/libertine) {
    inherit fontforge;
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

  abcde = callPackage ../applications/audio/abcde {
    inherit (perlPackages) DigestSHA MusicBrainz MusicBrainzDiscID;
  };

  abiword = callPackage ../applications/office/abiword {
    inherit (gnome) libglade libgnomecanvas;
  };

  adobeReader = callPackage_i686 ../applications/misc/adobe-reader { };

  aewan = callPackage ../applications/editors/aewan { };

  amsn = callPackage ../applications/networking/instant-messengers/amsn { };

  antiword = callPackage ../applications/office/antiword {};

  ardour = callPackage ../applications/audio/ardour {
    inherit (gnome) libgnomecanvas;
  };

  ardour3 =  lowPrio (callPackage ../applications/audio/ardour/ardour3.nix {
    inherit (gnome) libgnomecanvas libgnomecanvasmm;
    boost = boost149;
  });

  arora = callPackage ../applications/networking/browsers/arora { };

  audacious = callPackage ../applications/audio/audacious { };

  audacity = callPackage ../applications/audio/audacity { };

  aumix = callPackage ../applications/audio/aumix {
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  avidemux = callPackage ../applications/video/avidemux { };

  avogadro = callPackage ../applications/science/chemistry/avogadro {
    eigen = eigen2;
  };

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
  };

  blender = callPackage  ../applications/misc/blender {
    python = python32;
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

  chatzilla = callPackage ../applications/networking/irc/chatzilla {
    xulrunner = firefox36Pkgs.xulrunner;
  };

  chromium = lowPrio (callPackage ../applications/networking/browsers/chromium {
    channel = "stable";
    gconf = gnome.GConf;
    pulseSupport = config.pulseaudio or false;
  });

  chromiumBeta = chromium.override { channel = "beta"; };
  chromiumBetaWrapper = wrapChromium chromiumBeta;

  chromiumDev = chromium.override { channel = "dev"; };
  chromiumDevWrapper = wrapChromium chromiumDev;

  chromiumWrapper = wrapChromium chromium;

  cinelerra = callPackage ../applications/video/cinelerra { };

  cmus = callPackage ../applications/audio/cmus { };

  compiz = callPackage ../applications/window-managers/compiz {
    inherit (gnome) GConf ORBit2;
    intltool = intltool_standalone;
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

  cuneiform = builderDefsPackage (import ../tools/graphics/cuneiform) {
    inherit cmake patchelf;
    imagemagick=imagemagick;
  };

  cvs = callPackage ../applications/version-management/cvs { };

  cvsps = callPackage ../applications/version-management/cvsps { };

  cvs2svn = callPackage ../applications/version-management/cvs2svn { };

  d4x = callPackage ../applications/misc/d4x { };

  darcs = lib.setName "darcs-${haskellPackages.darcs.version}" haskellPackages.darcs;

  darktable = callPackage ../applications/graphics/darktable {
    inherit (gnome) GConf libglade;
  };

  dia = callPackage ../applications/graphics/dia {
    inherit (pkgs.gnome) libart_lgpl libgnomeui;
  };

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

  dvb_apps  = callPackage ../applications/video/dvb-apps { };

  dvdauthor = callPackage ../applications/video/dvdauthor { };

  dvswitch = callPackage ../applications/video/dvswitch { };

  dwm = callPackage ../applications/window-managers/dwm {
    patches = config.dwm.patches or [];
  };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  eclipses = recurseIntoAttrs (callPackage ../applications/editors/eclipse { });

  ed = callPackage ../applications/editors/ed { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs24;

  emacs22 = callPackage ../applications/editors/emacs-22 {
    stdenv =
      if stdenv.isDarwin

      /* On Darwin, use Apple-GCC, otherwise:
           configure: error: C preprocessor "cc -E -no-cpp-precomp" fails sanity check */
      then overrideGCC stdenv gccApple

      /* Using cpp 4.5, we get:

           make[1]: Entering directory `/tmp/nix-build-dhbj8qqmqxwp3iw6sjcgafsrwlwrix1f-emacs-22.3.drv-0/emacs-22.3/lib-src'
           Makefile:148: *** recipe commences before first target.  Stop.

         Apparently, this is because `lib-src/Makefile' is generated by
         processing `lib-src/Makefile.in' with cpp, and the escaping rules for
         literal backslashes have changed.  */
      else overrideGCC stdenv gcc44;

    xaw3dSupport = config.emacs.xaw3dSupport or false;
    gtkGUI = config.emacs.gtkSupport or true;
  };

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
    gtk = if stdenv.isDarwin then null else gtk;
    gconf = null;
    librsvg = null;
    alsaLib = null;
    imagemagick = null;
  };

  emacsPackages = emacs: self: let callPackage = newScope self; in rec {
    inherit emacs;

    autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };

    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    calfw = callPackage ../applications/editors/emacs-modes/calfw { };

    coffee = callPackage ../applications/editors/emacs-modes/coffee { };

    colorTheme = callPackage ../applications/editors/emacs-modes/color-theme { };

    cua = callPackage ../applications/editors/emacs-modes/cua { };

    ecb = callPackage ../applications/editors/emacs-modes/ecb { };

    jabber = callPackage ../applications/editors/emacs-modes/jabber { };

    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };

    emms = callPackage ../applications/editors/emacs-modes/emms { };

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

    hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };

    htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };

    logito = callPackage ../applications/editors/emacs-modes/logito { };

    loremIpsum = callPackage ../applications/editors/emacs-modes/lorem-ipsum { };

    magit = callPackage ../applications/editors/emacs-modes/magit { };

    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };

    notmuch = callPackage ../applications/networking/mailreaders/notmuch { };

    # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
    # we want it to have higher precedence.
    org = hiPrio (callPackage ../applications/editors/emacs-modes/org { });

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

  emacs22Packages = emacsPackages emacs22 pkgs.emacs22Packages;
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

  # FIXME: Evince and other GNOME/GTK+ apps (e.g., Viking) provide
  # `share/icons/hicolor/icon-theme.cache'.  Arbitrarily give this one a
  # higher priority.
  evince = hiPrio (callPackage ../applications/misc/evince {
    inherit (gnome) gnomedocutils gnomeicontheme libgnome
      libgnomeui libglade scrollkeeper;
  });

  evolution_data_server = newScope (gnome) ../servers/evolution-data-server { };

  exrdisplay = callPackage ../applications/graphics/exrdisplay {
    fltk = fltk20;
  };

  fbpanel = callPackage ../applications/window-managers/fbpanel { };

  fetchmail = import ../applications/misc/fetchmail {
    inherit stdenv fetchurl openssl;
  };

  fluidsynth = callPackage ../applications/audio/fluidsynth { };

  fossil = callPackage ../applications/version-management/fossil { };

  geany = callPackage ../applications/editors/geany { };

  goldendict = callPackage ../applications/misc/goldendict { };

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

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark { };

  wvdial = callPackage ../os-specific/linux/wvdial { };

  fbida = callPackage ../applications/graphics/fbida { };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  firefox = pkgs.firefoxPkgs.firefox;

  firefoxWrapper = wrapFirefox { browser = pkgs.firefox; };

  firefoxPkgs = pkgs.firefox17Pkgs;

  firefox36Pkgs = callPackage ../applications/networking/browsers/firefox/3.6.nix {
    inherit (gnome) libIDL;
  };

  firefox36Wrapper = wrapFirefox { browser = firefox36Pkgs.firefox; };

  firefox13Pkgs = callPackage ../applications/networking/browsers/firefox/13.0.nix {
    inherit (gnome) libIDL;
  };

  firefox13Wrapper = lowPrio (wrapFirefox { browser = firefox13Pkgs.firefox; });

  firefox17Pkgs = callPackage ../applications/networking/browsers/firefox/17.0.nix {
    inherit (gnome) libIDL;
    inherit (pythonPackages) pysqlite;
  };

  firefox17Wrapper = lowPrio (wrapFirefox { browser = firefox17Pkgs.firefox; });

  flac = callPackage ../applications/audio/flac { };

  flashplayer = callPackage ../applications/networking/browsers/mozilla-plugins/flashplayer-11 {
    debug = config.flashplayer.debug or false;
    # !!! Fix the dependency on two different builds of nss.
  };

  freecad = callPackage ../applications/graphics/freecad {
  };

  freemind = callPackage ../applications/misc/freemind {
    jdk = jdk;
    jre = jdk;
  };

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
  xlsfonts = callPackage ../applications/misc/xlsfonts { };

  freerdp = callPackage ../applications/networking/remote/freerdp { };

  freerdpUnstable = callPackage ../applications/networking/remote/freerdp/unstable.nix { };

  fspot = callPackage ../applications/graphics/f-spot {
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  get_iplayer = callPackage ../applications/misc/get_iplayer {};

  gimp_2_6 = callPackage ../applications/graphics/gimp {
    inherit (gnome) libart_lgpl;
  };

  gimp_2_8 = callPackage ../applications/graphics/gimp/2.8.nix {
    inherit (gnome) libart_lgpl;
  };

  gimp = gimp_2_6;

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
    inherit (gnome) libgnomeui libgtkhtml gtkhtml libbonoboui libgnomeprint;
    gconf = gnome.GConf;
    guile = guile_1_8;
    slibGuile = slibGuile.override { scheme = guile_1_8; };
  };

  libquvi = callPackage ../applications/video/quvi/library.nix { };

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
    goffice = goffice_0_9;
    inherit (gnome) libglade scrollkeeper;
  };

  gnunet08 = callPackage ../applications/networking/p2p/gnunet/0.8.nix {
    inherit (gnome) libglade;
    guile = guile_1_8;
    gtkSupport = config.gnunet.gtkSupport or true;
  };

  gnunet = callPackage ../applications/networking/p2p/gnunet { };

  gocr = callPackage ../applications/graphics/gocr { };

  gobby5 = callPackage ../applications/editors/gobby {
    inherit (gnome) gtksourceview;
  };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = builderDefsPackage ../applications/misc/gphoto2/gphotofs.nix {
    inherit libgphoto2 fuse pkgconfig glib;
  };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };

  graphicsmagick137 = callPackage ../applications/graphics/graphicsmagick/1.3.7.nix { };

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

  gmtk = callPackage ../applications/networking/browsers/mozilla-plugins/gmtk {
    inherit (gnome) GConf;
  };

  gnome_terminator = callPackage ../applications/misc/gnome_terminator {
    vte = gnome.vte.override { pythonSupport = true; };
  };

  googleearth = callPackage_i686 ../applications/misc/googleearth { };

  google_talk_plugin = callPackage ../applications/networking/browsers/mozilla-plugins/google-talk-plugin { };

  gosmore = builderDefsPackage ../applications/misc/gosmore {
    inherit fetchsvn curl pkgconfig libxml2 gtk;
  };

  gpsbabel = callPackage ../applications/misc/gpsbabel { };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate { };

  gpsd = callPackage ../servers/gpsd { };

  guitone = callPackage ../applications/version-management/guitone { };

  gv = callPackage ../applications/misc/gv { };

  hello = callPackage ../applications/misc/hello/ex-2 { };

  hexedit = callPackage ../applications/editors/hexedit { };

  homebank = callPackage ../applications/office/homebank { };

  htmldoc = callPackage ../applications/misc/htmldoc {
    fltk = fltk13;
  };

  hugin = callPackage ../applications/graphics/hugin { };

  hydrogen = callPackage ../applications/audio/hydrogen { };

  i3 = callPackage ../applications/window-managers/i3 { };

  i3lock = callPackage ../applications/window-managers/i3/lock.nix {
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
  };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5;
  };

  iptraf = callPackage ../applications/networking/iptraf { };

  irssi = callPackage ../applications/networking/irc/irssi { };

  bip = callPackage ../applications/networking/irc/bip { };

  jack_capture = callPackage ../applications/audio/jack-capture { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jedit = callPackage ../applications/editors/jedit { };

  jigdo = callPackage ../applications/misc/jigdo { };

  joe = callPackage ../applications/editors/joe { };

  jbrout = callPackage ../applications/graphics/jbrout {
    inherit (pythonPackages) lxml;
  };

  jwm = callPackage ../applications/window-managers/jwm { };

  k3d = callPackage ../applications/graphics/k3d {
    inherit (pkgs.gnome) gtkglext;
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

  lastwatch = callPackage ../applications/audio/lastwatch { };

  lci = callPackage ../applications/science/logic/lci {};

  ldcpp = callPackage ../applications/networking/p2p/ldcpp {
    inherit (gnome) libglade;
  };

  librecad = callPackage ../applications/misc/librecad { };

  librecad2 = callPackage ../applications/misc/librecad/2.0.nix { };

  libreoffice = callPackage ../applications/office/openoffice/libreoffice.nix {
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
  };

  lingot = callPackage ../applications/audio/lingot {
    inherit (gnome) libglade;
  };

  links = callPackage ../applications/networking/browsers/links { };

  ledger = callPackage ../applications/office/ledger/2.6.3.nix { };
  ledger3 = callPackage ../applications/office/ledger/3.0.nix {
    boost = boost149;
  };

  links2 = callPackage ../applications/networking/browsers/links2 { };

  linphone = callPackage ../applications/networking/instant-messengers/linphone {
    inherit (gnome) libglade;
  };

  linuxsampler = callPackage ../applications/audio/linuxsampler { };

  lmms = callPackage ../applications/audio/lmms { };

  lxdvdrip = callPackage ../applications/video/lxdvdrip { };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = callPackage ../applications/misc/lyx { };

  makeself = callPackage ../applications/misc/makeself { };

  matchbox = callPackage ../applications/window-managers/matchbox { };

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

  meshlab = callPackage ../applications/graphics/meshlab {
    qt = qt47;
  };

  mhwaveedit = callPackage ../applications/audio/mhwaveedit {};

  midori = builderDefsPackage (import ../applications/networking/browsers/midori) {
    inherit imagemagick intltool python pkgconfig webkit libxml2
      which gettext makeWrapper file libidn sqlite docutils libnotify
      vala dbus_glib;
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

  mmex = callPackage ../applications/office/mmex { };

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
  };

  monotoneViz = builderDefsPackage (import ../applications/version-management/monotone-viz/mtn-head.nix) {
    inherit ocaml graphviz pkgconfig autoconf automake libtool glib gtk;
    inherit (ocamlPackages) lablgtk;
    inherit (gnome) libgnomecanvas;
  };

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

  ncmpcpp = callPackage ../applications/audio/ncmpcpp { };

  MPlayer = callPackage ../applications/video/MPlayer {
    pulseSupport = config.pulseaudio or false;
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

  msmtp = callPackage ../applications/networking/msmtp { };

  mupdf = callPackage ../applications/misc/mupdf { };

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

  ocrad = callPackage ../applications/graphics/ocrad { };

  offrss = callPackage ../applications/networking/offrss { };

  ogmtools = callPackage ../applications/video/ogmtools { };

  oneteam = callPackage ../applications/networking/instant-messengers/oneteam {};

  openbox = callPackage ../applications/window-managers/openbox { };

  openjump = callPackage ../applications/misc/openjump { };

  openoffice = callPackage ../applications/office/openoffice {
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2;
    neon = neon029;
    libwpd = libwpd_08;
    zip = zip.override { enableNLS = false; };
  };

  openscad = callPackage ../applications/graphics/openscad {};

  opera = callPackage ../applications/networking/browsers/opera {
    inherit (pkgs.kde4) kdelibs;
  };

  opusTools = callPackage ../applications/audio/opus-tools { };

  pan = callPackage ../applications/networking/newsreaders/pan {
    spellChecking = false;
  };

  panotools = callPackage ../applications/graphics/panotools { };

  pavucontrol = callPackage ../applications/audio/pavucontrol {
    inherit (gnome) libglademm;
  };

  paraview = callPackage ../applications/graphics/paraview { };

  petrifoo = callPackage ../applications/audio/petrifoo {
    inherit (gnome) libgnomecanvas;
  };

  pdftk = callPackage ../tools/typesetting/pdftk { };

  pianobooster = callPackage ../applications/audio/pianobooster { };

  picard = callPackage ../applications/audio/picard { };

  picocom = callPackage ../tools/misc/picocom { };

  pidgin = callPackage ../applications/networking/instant-messengers/pidgin {
    openssl = if (config.pidgin.openssl or true) then openssl else null;
    gnutls = if (config.pidgin.gnutls or false) then gnutls else null;
    libgcrypt = if (config.pidgin.gnutls or false) then libgcrypt else null;
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

  pinfo = callPackage ../applications/misc/pinfo { };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtksharp2;
  };

  pommed = callPackage ../os-specific/linux/pommed {
    inherit (xorg) libXpm;
  };

  pqiv = callPackage ../applications/graphics/pqiv { };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = callPackage ../applications/misc/procmail { };

  pstree = callPackage ../applications/misc/pstree { };

  puredata = callPackage ../applications/audio/puredata { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qemu = callPackage ../applications/virtualization/qemu/0.15.nix { };

  qemu_1_0 = callPackage ../applications/virtualization/qemu/1.0.nix { };

  qemuImage = callPackage ../applications/virtualization/qemu/linux-img { };

  qsampler = callPackage ../applications/audio/qsampler { };

  qsynth = callPackage ../applications/audio/qsynth { };

  qtcreator = callPackage ../development/qtcreator { };

  qtpfsgui = callPackage ../applications/graphics/qtpfsgui { };

  qtractor = callPackage ../applications/audio/qtractor { };

  rakarrack = callPackage ../applications/audio/rakarrack {
    inherit (xorg) libXpm libXft;
    fltk = fltk13;
  };

  rapcad = callPackage ../applications/graphics/rapcad {};

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee { };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  RealPlayer = callPackage_i686 ../applications/video/RealPlayer {
    libstdcpp5 = gcc33.gcc;
  };

  recode = callPackage ../tools/text/recode { };

  retroshare = callPackage ../applications/networking/p2p/retroshare {
    qt = qt4;
  };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS);
    enableCopyDevicesPatch = (config.rsync.enableCopyDevicesPatch or false);
  };

  rxvt = callPackage ../applications/misc/rxvt { };

  # = urxvt
  rxvt_unicode = callPackage ../applications/misc/rxvt_unicode {
    perlSupport = false;
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

  siproxd = callPackage ../applications/networking/siproxd { };

  skype = callPackage_i686 ../applications/networking/instant-messengers/skype {
    usePulseAudio = config.pulseaudio or false; # disabled by default (the 100% cpu bug)
  };

  st = callPackage ../applications/misc/st { };

  dropbox = callPackage ../applications/networking/dropbox { };

  slim = callPackage ../applications/display-managers/slim { };

  sndBase = builderDefsPackage (import ../applications/audio/snd) {
    inherit fetchurl stdenv stringsWithDeps lib fftw;
    inherit pkgconfig gmp gettext;
    inherit (xlibs) libXpm libX11;
    inherit gtk glib;
  };

  snd = sndBase.passthru.function {
    inherit mesa libtool jackaudio alsaLib;
    guile = guile_1_8;
  };

  sonic_visualiser = callPackage ../applications/audio/sonic-visualiser {
    inherit (pkgs.vamp) vampSDK;
    inherit (pkgs.xlibs) libX11;
    fftw = pkgs.fftwSinglePrec;
  };

  sox = callPackage ../applications/misc/audio/sox { };

  spotify = callPackage ../applications/audio/spotify { };

  stalonetray = callPackage ../applications/window-managers/stalonetray {};

  stumpwm = builderDefsPackage (import ../applications/window-managers/stumpwm) {
    inherit texinfo;
    clisp = clisp_2_44_1;
  };

  sublime = callPackage ../applications/editors/sublime { };

  subversion = callPackage ../applications/version-management/subversion/default.nix {
    neon = pkgs.neon029;
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

  taskjuggler = callPackage ../applications/misc/taskjuggler {
    # KDE support is not working yet.
    inherit (kde3) kdelibs kdebase;
    withKde = config.taskJuggler.kde or false;
  };

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

  transmission = callPackage ../applications/networking/p2p/transmission { };

  transmission_remote_gtk = callPackage ../applications/networking/p2p/transmission-remote-gtk {};

  trayer = callPackage ../applications/window-managers/trayer { };

  tree = callPackage ../tools/system/tree { };

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

  vbindiff = callPackage ../applications/editors/vbindiff { };

  vdpauinfo = callPackage ../tools/X11/vdpauinfo { };

  veracity = callPackage ../applications/version-management/veracity {};

  viewMtn = builderDefsPackage (import ../applications/version-management/viewmtn/0.10.nix)
  {
    inherit monotone cheetahTemplate highlight ctags
      makeWrapper graphviz which python;
    flup = pythonPackages.flup;
  };

  vim = callPackage ../applications/editors/vim { };

  vimHugeX = vim_configurable;

  vim_configurable = import ../applications/editors/vim/configurable.nix {
    inherit (pkgs) fetchurl stdenv ncurses pkgconfig gettext composableDerivation lib config;
    inherit (pkgs.xlibs) libX11 libXext libSM libXpm libXt libXaw libXau libXmu libICE;
    inherit (pkgs) glib gtk;
    features = "huge"; # one of  tiny, small, normal, big or huge
    # optional features by passing
    # python
    # TODO mzschemeinterp perlinterp
    inherit (pkgs) python perl tcl ruby /*x11*/;
    lua = pkgs.lua5;
    # optional features by flags
    flags = [ "X11" ]; # only flag "X11" by now
  };

  virtviewer = callPackage ../applications/virtualization/virt-viewer {};
  virtmanager = callPackage ../applications/virtualization/virt-manager {
    inherit (gnome) gnome_python;
  };

  virtinst = callPackage ../applications/virtualization/virtinst {};

  virtualgl = callPackage ../tools/X11/virtualgl { };

  bumblebee = callPackage ../tools/X11/bumblebee { };

  vkeybd = callPackage ../applications/audio/vkeybd {
    inherit (xlibs) libX11;
  };

  vlc = callPackage ../applications/video/vlc {
    ffmpeg = ffmpeg_1_0;
  };

  vnstat = callPackage ../applications/networking/vnstat { };

  vorbisTools = callPackage ../applications/audio/vorbis-tools { };

  vue = callPackage ../applications/misc/vue {};

  vwm = callPackage ../applications/window-managers/vwm { };

  w3m = callPackage ../applications/networking/browsers/w3m {
    graphicsSupport = false;
  };

  weechat = callPackage ../applications/networking/irc/weechat { };

  wings = callPackage ../applications/graphics/wings { };

  wmname = callPackage ../applications/misc/wmname { };

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
    import ../applications/networking/browsers/firefox/wrapper.nix {
      inherit stdenv makeWrapper makeDesktopItem browser browserName desktopName nameSuffix icon;
      plugins =
        let
          cfg = stdenv.lib.attrByPath [ browserName ] {} config;
          enableAdobeFlash = cfg.enableAdobeFlash or true;
          enableGnash = cfg.enableGnash or false;
        in
         assert !(enableGnash && enableAdobeFlash);
         ([ ]
          ++ lib.optional enableGnash gnash
          ++ lib.optional enableAdobeFlash flashplayer
          # RealPlayer is disabled by default for legal reasons.
          ++ lib.optional (system != "i686-linux" && cfg.enableRealPlayer or false) RealPlayer
          ++ lib.optional (cfg.enableDjvu or false) (djview4)
          ++ lib.optional (cfg.enableMPlayer or false) (MPlayerPlugin browser)
          ++ lib.optional (cfg.enableGeckoMediaPlayer or false) gecko_mediaplayer
          ++ lib.optional (supportsJDK && cfg.jre or false && jrePlugin ? mozillaPlugin) jrePlugin
          ++ lib.optional (cfg.enableGoogleTalkPlugin or false) google_talk_plugin
         );
      libs =
        if config.browserName.enableQuakeLive or false
        then with xlibs; [ stdenv.gcc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib ]
        else [ ];
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

  xcalib = callPackage ../tools/X11/xcalib { };

  xchat = callPackage ../applications/networking/irc/xchat { };

  xchm = callPackage ../applications/misc/xchm { };

  xcompmgr = callPackage ../applications/window-managers/xcompmgr { };

  compton = callPackage ../applications/window-managers/compton { };

  xdaliclock = callPackage ../tools/misc/xdaliclock {};

  xdg_utils = callPackage ../tools/X11/xdg-utils { };

  xdotool = callPackage ../tools/X11/xdotool { };

  xen = callPackage ../applications/virtualization/xen { };

  xfe = callPackage ../applications/misc/xfe { };

  xfig = callPackage ../applications/graphics/xfig {
    stdenv = overrideGCC stdenv gcc34;
  };

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

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix { };

  xpra = callPackage ../tools/X11/xpra {
    inherit (pythonPackages) notify;
  };

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
      import ../applications/misc/zathura { inherit callPackage pkgs; });

  zathura = zathuraCollection.zathuraWrapper;

  girara = callPackage ../applications/misc/girara { };

  zgrviewer = callPackage ../applications/graphics/zgrviewer {};

  zynaddsubfx = callPackage ../applications/audio/zynaddsubfx { };

  ### GAMES

  alienarena = callPackage ../games/alienarena { };

  andyetitmoves = if stdenv.isLinux then callPackage ../games/andyetitmoves {} else null;

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

  blobby = callPackage ../games/blobby {};

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

  dwarf_fortress = callPackage_i686 ../games/dwarf-fortress { };

  eduke32 = callPackage ../games/eduke32 { };

  egoboo = callPackage ../games/egoboo { };

  exult = callPackage ../games/exult {
    stdenv = overrideGCC stdenv gcc42;
    libpng = libpng12;
  };

  flightgear = callPackage ../games/flightgear {};

  freeciv = callPackage ../games/freeciv { };

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

  gparted = callPackage ../tools/misc/gparted {
    parted = parted_2_3;
    inherit (gnome) gnomedocutils;
  };

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

  racer = callPackage ../games/racer { };

  rigsofrods = callPackage ../games/rigsofrods {
    mygui = myguiSvn;
  };

  rili = callPackage ../games/rili { };

  rogue = callPackage ../games/rogue { };

  sauerbraten = callPackage ../games/sauerbraten {};

  scid = callPackage ../games/scid { };

  scummvm = callPackage ../games/scummvm { };

  scorched3d = callPackage ../games/scorched3d { };

  sgtpuzzles = builderDefsPackage (import ../games/sgt-puzzles) {
    inherit pkgconfig fetchsvn perl gtk;
    inherit (xlibs) libX11;
  };

  simutrans = callPackage ../games/simutrans { };

  six = callPackage ../games/six {
    inherit (kde3) arts kdelibs;
  };

  soi = callPackage ../games/soi {};

  # You still can override by passing more arguments.
  spaceOrbit = callPackage ../games/orbit { };

  spring = callPackage ../games/spring { boost = boost149;};

  springLobby = callPackage ../games/spring/springlobby.nix { };

  stardust = callPackage ../games/stardust {};

  stuntrally = callPackage ../games/stuntrally { };

  superTux = callPackage ../games/super-tux { };

  superTuxKart = callPackage ../games/super-tux-kart {
    /* With GNU Make 3.82, the build process is stuck in the `data'
       directory, after displaying "Making all in tracks", and `pstree'
       indicates that `make' doesn't launch any new process.  */
    stdenv = overrideInStdenv stdenv [ gnumake381 ];
  };

  tbe = callPackage ../games/the-butterfly-effect {};

  teetertorture = callPackage ../games/teetertorture { };

  teeworlds = callPackage ../games/teeworlds { };

  tennix = callPackage ../games/tennix { };

  tpm = callPackage ../games/thePenguinMachine { };

  tremulous = callPackage ../games/tremulous { };

  speed_dreams = callPackage ../games/speed-dreams {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    plib = plib.override { enablePIC = if stdenv.isi686 then false else true; };
    libpng = libpng12;
  };

  torcs = callPackage ../games/torcs {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    plib = plib.override { enablePIC = if stdenv.isi686 then false else true; };
  };

  trigger = callPackage ../games/trigger { };

  ufoai = callPackage ../games/ufoai {
    inherit (gnome) gtksourceview gtkglext;
    libpng = libpng12;
  };

  ultimatestunts = callPackage ../games/ultimatestunts { };

  ultrastardx = callPackage ../games/ultrastardx {
    lua = lua5;
  };

  uqm = callPackage ../games/uqm { };

  urbanterror = callPackage ../games/urbanterror { };

  ut2004demo = callPackage ../games/ut2004demo { };

  vdrift = callPackage ../games/vdrift { };

  vectoroids = callPackage ../games/vectoroids { };

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

  # e17 = recurseIntoAttrs (
  #   let callPackage = newScope pkgs.e17; in
  #   import ../desktops/e17 { inherit callPackage pkgs; }
  # );

  gnome2 = callPackage ../desktops/gnome-2 {
    callPackage = pkgs.newScope pkgs.gnome2;
    self = pkgs.gnome2;
  }  // pkgs.gtkLibs // {
    # Backwards compatibility;
    inherit (pkgs) libsoup libwnck gtk_doc gnome_doc_utils;
  };

  gnome = recurseIntoAttrs gnome2;

  kde3 = recurseIntoAttrs {

    kdelibs = callPackage ../desktops/kde-3/kdelibs {
      stdenv = overrideGCC stdenv gcc43;
    };

    arts = callPackage ../development/libraries/arts {
      inherit (pkgs.kde3) kdelibs;
    };

  };

  kde4 = recurseIntoAttrs pkgs.kde47;

  kde47 = kdePackagesFor (pkgs.kde47 // {
      boost = boost149;
      eigen = eigen2;
    }) ../desktops/kde-4.7;

  kde48 = kdePackagesFor (pkgs.kde48 // {
      boost = boost149;
      eigen = eigen2;
    }) ../desktops/kde-4.8;

  kdePackagesFor = self: dir:
    let callPackageOrig = callPackage; in
    let
      callPackage = newScope self;
      kde4 = callPackageOrig dir {
        inherit callPackage callPackageOrig;
      };
    in kde4 // {
      inherit kde4;

      recurseForRelease = true;

      akunambol = callPackage ../applications/networking/sync/akunambol { };

      amarok = callPackage ../applications/audio/amarok { };

      bangarang = callPackage ../applications/video/bangarang { };

      basket = callPackage ../applications/office/basket { };

      bluedevil = callPackage ../tools/bluetooth/bluedevil { };

      calligra = callPackage ../applications/office/calligra { };

      digikam = callPackage ../applications/graphics/digikam {
        boost = boost147;
      };

      k3b = callPackage ../applications/misc/k3b { };

      kadu = callPackage ../applications/networking/instant-messengers/kadu { };

      kbibtex = callPackage ../applications/office/kbibtex { };

      kbluetooth = callPackage ../tools/bluetooth/kbluetooth { };

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

      koffice = callPackage ../applications/office/koffice {
        boost = boost147;
      };

      konq_plugins = callPackage ../applications/networking/browsers/konq-plugins { };

      konversation = callPackage ../applications/networking/irc/konversation { };

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
  };

  oxygen_gtk = callPackage ../misc/themes/gtk2/oxygen-gtk { };

  xfce = xfce48;

  xfce48 = recurseIntoAttrs
    (let callPackage = newScope pkgs.xfce48; in
     import ../desktops/xfce-4.8 { inherit callPackage pkgs; });


  ### SCIENCE

  celestia = callPackage ../applications/science/astronomy/celestia {
    lua = lua5_1;
    inherit (xlibs) libXmu;
    inherit (pkgs.gnome) gtkglext;
  };

  xplanet = callPackage ../applications/science/astronomy/xplanet { };

  gravit = callPackage ../applications/science/astronomy/gravit { };

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

  picosat = callPackage ../applications/science/logic/picosat {};

  prover9 = callPackage ../applications/science/logic/prover9 { };

  satallax = callPackage ../applications/science/logic/satallax {};

  spass = callPackage ../applications/science/logic/spass {};

  ssreflect = callPackage ../applications/science/logic/ssreflect {
    camlp5 = ocamlPackages.camlp5_transitional;
  };

  tptp = callPackage ../applications/science/logic/tptp {};

  ### SCIENCE / ELECTRONICS

  caneda = callPackage ../applications/science/electronics/caneda { };

  gtkwave = callPackage ../applications/science/electronics/gtkwave { };

  kicad = callPackage ../applications/science/electronics/kicad { };

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

  singular = callPackage ../applications/science/math/singular {};

  scilab = callPackage ../applications/science/math/scilab {
    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  msieve = callPackage ../applications/science/math/msieve { };

  yacas = callPackage ../applications/science/math/yacas { };

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

  cups = callPackage ../misc/cups { };

  cups_pdf_filter = callPackage ../misc/cups/pdf-filter.nix { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cupsBjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

  darcnes = callPackage ../misc/emulators/darcnes { };

  dbacl = callPackage ../tools/misc/dbacl { };

  dblatex = callPackage ../tools/typesetting/tex/dblatex { };

  dosbox = callPackage ../misc/emulators/dosbox { };

  dpkg = callPackage ../tools/package-management/dpkg { };

  ekiga = newScope pkgs.gnome ../applications/networking/instant-messengers/ekiga { };

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  fakenes = callPackage ../misc/emulators/fakenes { };

  foldingathome = callPackage ../misc/foldingathome { };

  foo2zjs = callPackage ../misc/drivers/foo2zjs {};

  foomatic_filters = callPackage ../misc/drivers/foomatic-filters {};

  freestyle = callPackage ../misc/freestyle {
    #stdenv = overrideGCC stdenv gcc41;
  };

  gajim = builderDefsPackage (import ../applications/networking/instant-messengers/gajim) {
    inherit perl intltool pyGtkGlade gettext pkgconfig makeWrapper pygobject
      pyopenssl gtkspell libsexy pycrypto aspell pythonDBus pythonSexy
      docutils gtk farstream gst_plugins_bad gstreamer gst_ffmpeg gst_python;
    dbus = dbus.libs;
    inherit (gnome) libglade;
    inherit (xlibs) libXScrnSaver libXt xproto libXext xextproto libX11
      scrnsaverproto;
    inherit (pythonPackages) pyasn1;
    python = pythonFull;
  };

  gensgs = callPackage_i686 ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript {
    x11Support = false;
    cupsSupport = config.ghostscript.cups or true;
    gnuFork = config.ghostscript.gnu or false;
  };

  ghostscriptX = appendToName "with-X" (ghostscript.override {
    x11Support = true;
  });

  gxemul = callPackage ../misc/gxemul { };

  hplip = callPackage ../misc/drivers/hplip { };

  # using the new configuration style proposal which is unstable
  jack1d = callPackage ../misc/jackaudio/jack1.nix { };

  jackaudio = callPackage ../misc/jackaudio { };

  keynav = callPackage ../tools/X11/keynav { };

  lazylist = callPackage ../tools/typesetting/tex/lazylist { };

  lilypond = callPackage ../misc/lilypond { };

  martyr = callPackage ../development/libraries/martyr { };

  maven = maven3;
  maven3 = callPackage ../misc/maven { jdk = openjdk; };

  mess = callPackage ../misc/emulators/mess {
    inherit (pkgs.gnome) GConf;
  };

  mupen64plus = callPackage ../misc/emulators/mupen64plus { };

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

  nut = callPackage ../applications/misc/nut { };

  nut_2_6_3 = callPackage ../applications/misc/nut/2.6.3.nix { };

  disnix = callPackage ../tools/package-management/disnix { };

  disnix_activation_scripts = callPackage ../tools/package-management/disnix/activation-scripts {
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
    hotplugSupport = config.sane.hotplugSupport or true;
  };

  saneBackendsGit = callPackage ../applications/graphics/sane/backends-git.nix {
    gt68xxFirmware = config.sane.gt68xxFirmware or null;
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
    inherit builderDefs zlib bzip2 ncurses libpng ed lesstif
      gd t1lib freetype icu perl expat curl xz pkgconfig zziplib
      libjpeg bison python fontconfig flex poppler silgraphite;
    inherit (xlibs) libXaw libX11 xproto libXt libXpm
      libXmu libXext xextproto libSM libICE;
    ghostscript = ghostscriptX;
    ruby = ruby18;
  };

  texLiveFull = lib.setName "texlive-full" (texLiveAggregationFun {
    paths = [ texLive texLiveExtra lmodern texLiveCMSuper texLiveLatexXColor
              texLivePGF texLiveBeamer texLiveModerncv tipa ];
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
  texLiveAggregationFun =
    (builderDefsPackage (import ../tools/typesetting/tex/texlive/aggregate.nix));

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

  vice = callPackage ../misc/emulators/vice { };

  vimprobable2 = callPackage ../applications/networking/browsers/vimprobable2 {
    inherit (gnome) libsoup;
    webkit = webkit_gtk2;
  };

  vimprobable2Wrapper = wrapFirefox
    { browser = vimprobable2; browserName = "vimprobable2"; desktopName = "Vimprobable2";
    };

  VisualBoyAdvance = callPackage ../misc/emulators/VisualBoyAdvance { };

  # Wine cannot be built in 64-bit; use a 32-bit build instead.
  wine = callPackage_i686 ../misc/emulators/wine { };

  wineWarcraft = callPackage_i686 ../misc/emulators/wine/wine-warcraft.nix { };

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

  zsnes = callPackage_i686 ../misc/emulators/zsnes {
    libpng = libpng12;
  };

  misc = import ../misc/misc.nix { inherit pkgs stdenv; };

  bullet = callPackage ../development/libraries/bullet {};

}; in pkgs
