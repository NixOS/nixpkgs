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

  # More flags for the bootstrapping of stdenv.
, noSysDirs ? true
, gccWithCC ? true
, gccWithProfiling ? true

, # Allow a configuration attribute set to be passed in as an
  # argument.  Otherwise, it's read from $NIXPKGS_CONFIG or
  # ~/.nixpkgs/config.nix.
  config ? null

, crossSystem ? null
, platform ? (import ./platforms.nix).pc
}:


let config_ = config; in # rename the function argument

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

  # Return an attribute from the Nixpkgs configuration file, or
  # a default value if the attribute doesn't exist.
  getConfig = attrPath: default: lib.attrByPath attrPath default config;


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
  pkgs = applyGlobalOverrides (getConfig ["packageOverrides"] (pkgs: {}));


  # Return the complete set of packages, after applying the overrides
  # returned by the `overrider' function (see above).
  applyGlobalOverrides = overrider:
    let
      # Call the overrider function.  We don't want stdenv overrides
      # in the case of cross-building, or otherwise the basic
      # overrided packages will not be built with the crossStdenv
      # adapter.
      overrides = overrider pkgsOrig //
        (lib.optionalAttrs (pkgsOrig.stdenv ? overrides && crossSystem == null) pkgsOrig.stdenv.overrides);

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
  inherit __overrides;


  # We use `callPackage' to be able to omit function arguments that
  # can be obtained from `pkgs' or `pkgs.xorg' (i.e. `defaultScope').
  # Use `newScope' for sets of packages in `pkgs' (see e.g. `gtkLibs'
  # below).
  callPackage = newScope {};

  newScope = extra: lib.callPackageWith (defaultScope // extra);

  
  # Override system. This is useful to build i686 packages on x86_64-linux.
  forceSystem = system: (import ./all-packages.nix) {
    inherit system;
    inherit bootStdenv noSysDirs gccWithCC gccWithProfiling config;
  };

  
  # Used by wine, firefox with debugging version of Flash, ...
  pkgsi686Linux = forceSystem "i686-linux";

  callPackage_i686 = lib.callPackageWith (pkgsi686Linux // pkgsi686Linux.xorg);


  # For convenience, allow callers to get the path to Nixpkgs.
  path = ../..;


  ### Symbolic names.


  x11 = xlibsWrapper;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X libraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = xorg // {xlibs = xlibsWrapper;};


  ### Helper functions.


  inherit lib config getConfig stdenvAdapters;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // {recurseForDerivations = true;};

  # Return the first available value in the order: pkg.val, val, or default.
  getPkgConfig = pkg : val : default : (getConfig [ pkg val ] (getConfig [ val ] default));

  builderDefs = lib.composedArgsAndFun (import ../build-support/builder-defs/builder-defs.nix) {
    inherit stringsWithDeps lib stdenv writeScript
      fetchurl fetchmtn fetchgit;
  };

  builderDefsPackage = builderDefs.builderDefsPackage builderDefs;

  stringsWithDeps = lib.stringsWithDeps;


  ### STANDARD ENVIRONMENT


  allStdenvs = import ../stdenv {
    inherit system stdenvType;
    allPackages = args: import ./all-packages.nix ({ inherit config; } // args);
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenvCross = makeStdenvCross defaultStdenv crossSystem binutilsCross
    gccCrossStageFinal;

  stdenv =
    if bootStdenv != null then bootStdenv else
      let changer = getConfig ["replaceStdenv"] null;
      in if changer != null then
        changer {
          stdenv = stdenvCross;
          overrideSetup = overrideSetup;
        }
      else if crossSystem != null then
        stdenvCross
      else
        defaultStdenv;

  forceBuildDrv = drv : if (crossSystem == null) then drv else
    (drv // { hostDrv = drv.buildDrv; });

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit =
    if system == "x86_64-linux" then
      overrideGCC stdenv gcc43_multi
    else
      stdenv;


  ### BUILD SUPPORT

  attrSetToDir = arg : import ../build-support/upstream-updater/attrset-to-dir.nix {
    inherit writeTextFile stdenv lib;
    theAttrSet = arg;
  };

  buildEnvScript = ../build-support/buildenv/builder.pl;
  buildEnv = import ../build-support/buildenv {
    inherit stdenv perl;
  };

  dotnetenv = import ../build-support/dotnetenv {
    inherit stdenv;
    dotnetfx = dotnetfx35;
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
    inherit stdenv git;
  };

  fetchmtn = import ../build-support/fetchmtn {
    inherit monotone stdenv;
    cacheDB = getConfig ["fetchmtn" "cacheDB"] "";
    defaultDBMirrors = getConfig ["fetchmtn" "defaultDBMirrors"] [];
  };

  fetchsvn = import ../build-support/fetchsvn {
    inherit stdenv subversion openssh;
    sshSupport = true;
  };

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

  makeInitrd = {contents}: import ../build-support/kernel/make-initrd.nix {
    inherit stdenv perl cpio contents ubootChooser;
  };

  makeWrapper = makeSetupHook ../build-support/make-wrapper/make-wrapper.sh;

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

  ec2apitools = callPackage ../tools/virtualization/amazon-ec2-api-tools { };

  ec2amitools = callPackage ../tools/virtualization/amazon-ec2-ami-tools { };

  amule = callPackage ../tools/networking/p2p/amule { };

  aria = builderDefsPackage (import ../tools/networking/aria) {
  };

  aria2 = callPackage ../tools/networking/aria2 { };

  at = callPackage ../tools/system/at { };

  autogen = callPackage ../development/tools/misc/autogen { };

  autojump = callPackage ../tools/misc/autojump { };

  avahi =
    let qt4Support = getConfig [ "avahi" "qt4Support" ] false;
    in
      makeOverridable (import ../development/libraries/avahi) {
        inherit stdenv fetchurl pkgconfig libdaemon dbus perl perlXMLParser
          expat gettext intltool lib;
        inherit (gtkLibs) glib gtk;
        inherit qt4Support;
        qt4 = if qt4Support then qt4 else null;
      };

  axel = callPackage ../tools/networking/axel { };

  azureus = callPackage ../tools/networking/p2p/azureus { };

  bc = callPackage ../tools/misc/bc { };

  bfr = callPackage ../tools/misc/bfr { };

  bootchart = callPackage ../tools/system/bootchart { };

  btrfsProgs = builderDefsPackage (import ../tools/filesystems/btrfsprogs) {
    inherit libuuid zlib acl;
  };

  catdoc = callPackage ../tools/text/catdoc { };

  eggdrop = callPackage ../tools/networking/eggdrop { };

  mcrl = callPackage ../tools/misc/mcrl { };

  mcrl2 = callPackage ../tools/misc/mcrl2 { };

  syslogng = callPackage ../tools/misc/syslog-ng { };

  asciidoc = callPackage ../tools/typesetting/asciidoc { };

  autossh = callPackage ../tools/networking/autossh { };

  bibtextools = callPackage ../tools/typesetting/bibtex-tools {
    inherit (strategoPackages016) strategoxt sdf;
  };

  bittorrent = callPackage ../tools/networking/p2p/bittorrent {
    wxPython = wxPython26;
    gui = true;
  };

  bittornado = callPackage ../tools/networking/p2p/bit-tornado { };

  blueman = callPackage ../tools/bluetooth/blueman {
    inherit (pythonPackages) notify;
    inherit (gtkLibs) glib gtk;
  };

  bmrsa = builderDefsPackage (import ../tools/security/bmrsa/11.nix) {
    inherit unzip;
  };

  bogofilter = callPackage ../tools/misc/bogofilter {
    bdb = db4;
  };

  bsdiff = callPackage ../tools/compression/bsdiff { };

  bzip2 = callPackage ../tools/compression/bzip2 { };

  cabextract = callPackage ../tools/archivers/cabextract { };

  ccid = callPackage ../tools/security/ccid { };

  ccrypt = callPackage ../tools/security/ccrypt { };

  cdecl = callPackage ../development/tools/cdecl { };

  cdrdao = callPackage ../tools/cd-dvd/cdrdao { };

  cdrkit = callPackage ../tools/cd-dvd/cdrkit { };

  cfdg = builderDefsPackage ../tools/graphics/cfdg {
    inherit libpng bison flex;
  };

  checkinstall = callPackage ../tools/package-management/checkinstall { };

  cheetahTemplate = builderDefsPackage (import ../tools/text/cheetah-template/2.0.1.nix) {
    inherit makeWrapper python;
  };

  chkrootkit = callPackage ../tools/security/chkrootkit { };

  cksfv = callPackage ../tools/networking/cksfv { };

  convertlit = callPackage ../tools/text/convertlit { };

  unifdef = callPackage ../development/tools/misc/unifdef { };

  usb_modeswitch = callPackage ../development/tools/misc/usb-modeswitch { };

  cloogppl = callPackage ../development/libraries/cloog-ppl { };

  convmv = callPackage ../tools/misc/convmv { };

  coreutils = callPackage (if stdenv ? isDietLibC
      then ../tools/misc/coreutils-5
      else ../tools/misc/coreutils)
    {
      # TODO: Add ACL support for cross-Linux.
      aclSupport = crossSystem == null && stdenv.isLinux;
    };

  cpio = callPackage ../tools/archivers/cpio { };

  cromfs = callPackage ../tools/archivers/cromfs { };

  cron = callPackage ../tools/system/cron {  # see also fcron
  };

  curl = makeOverridable (import ../tools/networking/curl) rec {
    fetchurl = fetchurlBoot;
    inherit stdenv zlib openssl libssh2;
    zlibSupport = ! ((stdenv ? isDietLibC) || (stdenv ? isStatic));
    sslSupport = zlibSupport;
    scpSupport = zlibSupport && !stdenv.isSunOS && !stdenv.isCygwin;
  };

  curlftpfs = callPackage ../tools/filesystems/curlftpfs { };

  dadadodo = builderDefsPackage (import ../tools/text/dadadodo) {
  };

  dar = callPackage ../tools/archivers/dar { };

  davfs2 = callPackage ../tools/filesystems/davfs2 {
    neon = neon028;
  };

  dcraw = callPackage ../tools/graphics/dcraw { };

  debootstrap = callPackage ../tools/misc/debootstrap { };

  detox = callPackage ../tools/misc/detox { };

  ddclient = callPackage ../tools/networking/ddclient { };

  ddrescue = callPackage ../tools/system/ddrescue { };

  desktop_file_utils = callPackage ../tools/misc/desktop-file-utils { };

  dev86 = callPackage ../development/compilers/dev86 { };

  dnsmasq = callPackage ../tools/networking/dnsmasq {
    # TODO i18n can be installed as well, implement it?
  };

  dhcp = callPackage ../tools/networking/dhcp { };

  dhcpcd = callPackage ../tools/networking/dhcpcd { };

  diffstat = callPackage ../tools/text/diffstat { };

  diffutils = callPackage ../tools/text/diffutils { };

  dirmngr = callPackage ../tools/security/dirmngr { };

  docbook2x = callPackage ../tools/typesetting/docbook2x {
    inherit (perlPackages) XMLSAX XMLParser XMLNamespaceSupport;
    libiconv = if stdenv.isDarwin then libiconv else null;
  };

  dosfstools = callPackage ../tools/filesystems/dosfstools { };

  dotnetfx35 = callPackage ../development/libraries/dotnetfx35 { };

  dropbear = callPackage ../tools/networking/dropbear {
    enableStatic = true;
    zlib = zlibStatic;
  };

  duplicity = callPackage ../tools/backup/duplicity {
    inherit (pythonPackages) boto;
    gnupg = gnupg1;
  };

  dvdplusrwtools = callPackage ../tools/cd-dvd/dvd+rw-tools { };

  e2fsprogs = callPackage ../tools/filesystems/e2fsprogs { };

  ebook_tools = callPackage ../tools/text/ebook-tools { };

  ecryptfs = callPackage ../tools/security/ecryptfs { };

  enblendenfuse = callPackage ../tools/graphics/enblend-enfuse { };

  enscript = callPackage ../tools/text/enscript { };

  ethtool = callPackage ../tools/misc/ethtool { };

  exif = callPackage ../tools/graphics/exif { };

  exiftags = callPackage ../tools/graphics/exiftags { };

  expect = callPackage ../tools/misc/expect { };

  fcron = callPackage ../tools/system/fcron {  # see also cron
  };

  fdisk = callPackage ../tools/system/fdisk { };

  figlet = callPackage ../tools/misc/figlet { };

  file = callPackage ../tools/misc/file { };

  findutils =
    if stdenv.isDarwin
    then findutils4227
    else callPackage ../tools/misc/findutils { };

  findutils4227 = callPackage ../tools/misc/findutils/4.2.27.nix { };

  finger_bsd = callPackage ../tools/networking/bsd-finger { };

  fontforge = callPackage ../tools/misc/fontforge { };

  fontforgeX = callPackage ../tools/misc/fontforge {
    withX11 = true;
  };

  dos2unix = callPackage ../tools/text/dos2unix { };

  unix2dos = callPackage ../tools/text/unix2dos { };

  gawk = callPackage ../tools/text/gawk { };

  gdmap = callPackage ../tools/system/gdmap {
    inherit (gtkLibs216) gtk;
  };

  genext2fs = callPackage ../tools/filesystems/genext2fs { };

  gengetopt = callPackage ../development/tools/misc/gengetopt { };

  getopt = callPackage ../tools/misc/getopt { };

  gftp = callPackage ../tools/networking/gftp {
    inherit (gtkLibs) gtk;
  };

  gifsicle = callPackage ../tools/graphics/gifsicle { };

  glusterfs = builderDefsPackage ../tools/filesystems/glusterfs {
    inherit fuse;
    bison = bison24;
    flex = flex2535;
  };

  glxinfo = callPackage ../tools/graphics/glxinfo { };

  gnokii = builderDefsPackage (import ../tools/misc/gnokii) {
    inherit intltool perl gettext libusb pkgconfig;
    inherit (gtkLibs) glib;
  };

  gnugrep = callPackage ../tools/text/gnugrep { };

  gnupatch = callPackage ../tools/text/gnupatch { };

  gnupg1orig = callPackage ../tools/security/gnupg1 {
    ideaSupport = false;
  };

  gnupg1compat = callPackage ../tools/security/gnupg1compat { };

  # use config.packageOverrides if you prefer original gnupg1
  gnupg1 = gnupg1compat;

  gnupg = callPackage ../tools/security/gnupg { };

  gnuplot = callPackage ../tools/graphics/gnuplot {
    inherit (gtkLibs) pango;
    texLive = null;
    lua = null;
  };

  gnused = callPackage ../tools/text/gnused { };

  gnused_4_2 = callPackage ../tools/text/gnused/4.2.nix { };

  gnutar = callPackage ../tools/archivers/gnutar { };

  gnuvd = callPackage ../tools/misc/gnuvd { };

  graphviz = callPackage ../tools/graphics/graphviz {
    inherit (gtkLibs) pango;
  };

  /* Readded by Michael Raskin. There are programs in the wild
   * that do want 2.0 but not 2.22. Please give a day's notice for
   * objections before removal.
   */
  graphviz_2_0 = callPackage ../tools/graphics/graphviz/2.0.nix {
    inherit (gtkLibs) pango;  };

  groff = callPackage ../tools/text/groff {
    ghostscript = null;
  };

  grub = import ../tools/misc/grub {
    inherit fetchurl autoconf automake;
    stdenv = stdenv_32bit;
    buggyBiosCDSupport = (getConfig ["grub" "buggyBiosCDSupport"] true);
  };

  grub2 = callPackage ../tools/misc/grub/1.9x.nix { };

  gssdp = callPackage ../development/libraries/gssdp {
    inherit (gnome) libsoup;
  };

  gt5 = callPackage ../tools/system/gt5 { };

  gtkgnutella = callPackage ../tools/networking/p2p/gtk-gnutella {
    inherit (gtkLibs) glib gtk;
  };

  gupnp = callPackage ../development/libraries/gupnp {
    inherit (gnome) libsoup;
  };

  gupnptools = callPackage ../tools/networking/gupnp-tools {
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libsoup libglade gnomeicontheme;
  };

  gvpe = builderDefsPackage ../tools/networking/gvpe {
    inherit openssl gmp nettools iproute;
  };

  gzip = callPackage ../tools/compression/gzip { };

  pigz = callPackage ../tools/compression/pigz { };

  halibut = callPackage ../tools/typesetting/halibut { };

  hddtemp = callPackage ../tools/misc/hddtemp { };

  hdf5 = callPackage ../tools/misc/hdf5 { };

  hevea = callPackage ../tools/typesetting/hevea { };

  highlight = callPackage ../tools/text/highlight { };

  host = callPackage ../tools/networking/host { };

  httpfs2 = callPackage ../tools/filesystems/httpfs { };

  iasl = callPackage ../development/compilers/iasl { };

  idutils = callPackage ../tools/misc/idutils { };

  iftop = callPackage ../tools/networking/iftop { };

  imapsync = callPackage ../tools/networking/imapsync {
    inherit (perlPackages) MailIMAPClient;
  };

  inetutils = callPackage ../tools/networking/inetutils { };

  iodine = callPackage ../tools/networking/iodine { };

  iperf = callPackage ../tools/networking/iperf { };

  ipmitool = callPackage ../tools/system/ipmitool {
    static = false;
  };

  jdiskreport = callPackage ../tools/misc/jdiskreport { };

  jfsrec = callPackage ../tools/filesystems/jfsrec { };

  jfsutils = callPackage ../tools/filesystems/jfsutils { };

  jhead = callPackage ../tools/graphics/jhead { };

  jing = callPackage ../tools/text/xml/jing { };

  jing_tools = callPackage ../tools/text/xml/jing/jing-script.nix { };

  jnettop = callPackage ../tools/networking/jnettop {
    inherit (gnome) glib;
  };

  jwhois = callPackage ../tools/networking/jwhois { };

  keychain = callPackage ../tools/misc/keychain { };

  kismet = callPackage ../applications/networking/sniffers/kismet { };

  ktorrent = kde4.ktorrent;

  less = callPackage ../tools/misc/less { };

  most = callPackage ../tools/misc/most { };

  lftp = callPackage ../tools/networking/lftp { };

  libtorrent = callPackage ../tools/networking/p2p/libtorrent { };

  logrotate = callPackage ../tools/system/logrotate { };

  lout = callPackage ../tools/typesetting/lout { };

  lrzip = callPackage ../tools/compression/lrzip { };

  lsh = callPackage ../tools/networking/lsh { };

  lzma = xz;

  xz = callPackage ../tools/compression/xz { };

  lzop = callPackage ../tools/compression/lzop { };

  mailutils = callPackage ../tools/networking/mailutils { };

  man = callPackage ../tools/misc/man { };

  man_db = callPackage ../tools/misc/man-db { };

  memtest86 = callPackage ../tools/misc/memtest86 { };

  mc = callPackage ../tools/misc/mc { };

  mcabber = callPackage ../applications/networking/instant-messengers/mcabber { };

  mcron = callPackage ../tools/system/mcron { };

  mdbtools = callPackage ../tools/misc/mdbtools {
    flex = flex2535;
  };

  miniupnpd = callPackage ../tools/networking/miniupnpd { };

  mjpegtools = callPackage ../tools/video/mjpegtools { };

  mkisofs = callPackage ../tools/cd-dvd/mkisofs { };

  mktemp = callPackage ../tools/security/mktemp { };

  mldonkey = callPackage ../applications/networking/p2p/mldonkey { };

  monit = builderDefsPackage ../tools/system/monit {
    flex = flex2535;
    bison = bison24;
    inherit openssl;
  };

  mpage = callPackage ../tools/text/mpage { };

  msf = builderDefsPackage (import ../tools/security/metasploit/3.1.nix) {
    inherit ruby makeWrapper;
  };

  mssys = callPackage ../tools/misc/mssys { };

  mtdutils = callPackage ../tools/filesystems/mtdutils { };

  mtools = callPackage ../tools/filesystems/mtools { };

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

  nbd = callPackage ../tools/networking/nbd {
    glib = gtkLibs.glib.override {
      stdenv = makeStaticBinaries stdenv;
    };
  };

  nc6 = callPackage ../tools/networking/nc6 { };

  ncat = callPackage ../tools/networking/ncat { };

  ncftp = callPackage ../tools/networking/ncftp { };

  ncompress = callPackage ../tools/compression/ncompress { };

  netcat = callPackage ../tools/networking/netcat { };

  netkittftp = callPackage ../tools/networking/netkit/tftp { };

  netpbm = callPackage ../tools/graphics/netpbm { };

  netselect = callPackage ../tools/networking/netselect { };

  nilfs_utils = callPackage ../tools/filesystems/nilfs-utils {};

  nmap = callPackage ../tools/security/nmap {
    inherit (pythonPackages) pysqlite;
    inherit (gtkLibs) gtk;
  };

  ntfs3g = callPackage ../tools/filesystems/ntfs-3g { };

  ntfsprogs = callPackage ../tools/filesystems/ntfsprogs { };

  ntp = callPackage ../tools/networking/ntp { };

  nssmdns = callPackage ../tools/networking/nss-mdns { };

  nylon = callPackage ../tools/networking/nylon { };

  obex_data_server = callPackage ../tools/bluetooth/obex-data-server {
    inherit (gtkLibs) glib;
  };

  obexd = callPackage ../tools/bluetooth/obexd { };

  obexfs = callPackage ../tools/bluetooth/obexfs { };

  obexftp = callPackage ../tools/bluetooth/obexftp { };

  offlineimap = import ../tools/networking/offlineimap {
    inherit fetchurl;
    # I did not find any better way of reusing buildPythonPackage+setuptools
    # for a python with openssl support
    buildPythonPackage = assert pythonFull.opensslSupport;
      import ../development/python-modules/generic {
        inherit makeWrapper lib;
        python = pythonFull;
        setuptools = builderDefsPackage (import ../development/python-modules/setuptools) {
          inherit makeWrapper;
          python = pythonFull;
        };
      };
  };

  opendbx = callPackage ../development/libraries/opendbx { };

  opendkim = callPackage ../development/libraries/opendkim { };

  openjade = callPackage ../tools/text/sgml/openjade {
    stdenv = overrideGCC stdenv gcc33;
  };

  openobex = callPackage ../tools/bluetooth/openobex { };

  opensc_0_11_7 = callPackage ../tools/security/opensc/0.11.7.nix { };

  opensc = opensc_0_11_7;

  opensc_dnie_wrapper = callPackage ../tools/security/opensc-dnie-wrapper { };

  openssh = callPackage ../tools/networking/openssh {
    hpnSupport = false;
    etcDir = "/etc/ssh";
  };

  opensp = callPackage ../tools/text/sgml/opensp { };

  openvpn = callPackage ../tools/networking/openvpn { };

  optipng = callPackage ../tools/graphics/optipng { };

  p7zip = callPackage ../tools/archivers/p7zip { };

  pal = callPackage ../tools/misc/pal {
    inherit (gtkLibs) glib;
  };

  panomatic = callPackage ../tools/graphics/panomatic { };

  par2cmdline = callPackage ../tools/networking/par2cmdline { };

  parallel = callPackage ../tools/misc/parallel { };

  patchutils = callPackage ../tools/text/patchutils { };

  parted = callPackage ../tools/misc/parted { };

  patch = gnupatch;

  pbzip2 = callPackage ../tools/compression/pbzip2 { };

  pciutils = callPackage ../tools/system/pciutils { };

  pcsclite = callPackage ../tools/security/pcsclite { };

  pdf2djvu = callPackage ../tools/typesetting/pdf2djvu { };

  pdfjam = callPackage ../tools/typesetting/pdfjam { };

  pdfread = callPackage ../tools/graphics/pdfread { };

  pg_top = callPackage ../tools/misc/pg_top { };

  pdsh = callPackage ../tools/networking/pdsh {
    rsh = true;          # enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = callPackage ../tools/graphics/pfstools {
    qt = qt3;
  };

  pinentry = callPackage ../tools/misc/pinentry {
    inherit (gnome) glib gtk;
  };

  pius = callPackage ../tools/security/pius { };

  pk2cmd = callPackage ../tools/misc/pk2cmd { };

  plan9port = callPackage ../tools/system/plan9port { };

  ploticus = callPackage ../tools/graphics/ploticus { };

  plotutils = callPackage ../tools/graphics/plotutils { };

  pngnq = callPackage ../tools/graphics/pngnq { };

  povray = callPackage ../tools/graphics/povray { };

  ppl = callPackage ../development/libraries/ppl { };

  /* WARNING: this version is unsuitable for using with a setuid wrapper */
  ppp = builderDefsPackage (import ../tools/networking/ppp) {
  };

  proxychains = callPackage ../tools/networking/proxychains { };

  proxytunnel = callPackage ../tools/misc/proxytunnel { };

  psmisc = callPackage ../tools/misc/psmisc { };

  pstoedit = callPackage ../tools/graphics/pstoedit { };

  pv = callPackage ../tools/misc/pv { };

  pwgen = callPackage ../tools/security/pwgen { };

  pydb = callPackage ../tools/pydb { };

  pystringtemplate = callPackage ../development/python-modules/stringtemplate { };

  pythonDBus = builderDefsPackage (import ../development/python-modules/dbus) {
    inherit python pkgconfig dbus_glib;
    dbus = dbus.libs;
  };

  pythonIRClib = builderDefsPackage (import ../development/python-modules/irclib) {
    inherit python;
  };

  pythonSexy = builderDefsPackage (import ../development/python-modules/libsexy) {
    inherit python libsexy pkgconfig libxml2 pygtk;
    inherit (gtkLibs) pango gtk glib;
  };

  openmpi = callPackage ../development/libraries/openmpi { };

  qdu = callPackage ../tools/misc/qdu { };

  qhull = callPackage ../development/libraries/qhull { };

  qshowdiff = callPackage ../tools/text/qshowdiff {
    qt = qt4;
  };

  rtmpdump = callPackage ../tools/video/rtmpdump { };

  reiser4progs = callPackage ../tools/filesystems/reiser4progs { };

  reiserfsprogs = callPackage ../tools/filesystems/reiserfsprogs { };

  relfs = callPackage ../tools/filesystems/relfs {
    inherit (gnome) gnomevfs GConf;
  };

  remind = callPackage ../tools/misc/remind { };

  replace = callPackage ../tools/text/replace { };

  /*
  rdiff_backup = callPackage ../tools/backup/rdiff-backup {
    python=python;  };
  */

  rsnapshot = callPackage ../tools/backup/rsnapshot {

    # For the `logger' command, we can use either `utillinux' or
    # GNU Inetutils.  The latter is more portable.
    logger = inetutils;
  };

  rlwrap = callPackage ../tools/misc/rlwrap { };

  rpPPPoE = builderDefsPackage (import ../tools/networking/rp-pppoe) {
    inherit ppp;
  };

  rpm = callPackage ../tools/package-management/rpm {
    db4 = db45;
  };

  rrdtool = callPackage ../tools/misc/rrdtool {
    inherit (gtkLibs) pango;
  };

  rtorrent = callPackage ../tools/networking/p2p/rtorrent { };

  rubber = callPackage ../tools/typesetting/rubber { };

  rxp = callPackage ../tools/text/xml/rxp { };

  rzip = callPackage ../tools/compression/rzip { };

  s3backer = callPackage ../tools/filesystems/s3backer { };

  s3sync = callPackage ../tools/networking/s3sync { };

  sablotron = callPackage ../tools/text/xml/sablotron { };

  screen = callPackage ../tools/misc/screen { };

  scrot = callPackage ../tools/graphics/scrot { };

  seccure = callPackage ../tools/security/seccure/0.4.nix { };

  setserial = builderDefsPackage (import ../tools/system/setserial) {
    inherit groff;
  };

  sharutils = callPackage ../tools/archivers/sharutils { };

  shebangfix = callPackage ../tools/misc/shebangfix { };

  slimrat = callPackage ../tools/networking/slimrat {
    inherit (perlPackages) WWWMechanize LWP;
  };

  slsnif = callPackage ../tools/misc/slsnif { };

  smartmontools = callPackage ../tools/system/smartmontools { };

  fusesmb = callPackage ../tools/filesystems/fusesmb { };

  socat = callPackage ../tools/networking/socat { };

  sourceHighlight = callPackage ../tools/text/source-highlight { };

  socat2pre = builderDefsPackage ../tools/networking/socat/2.0.0-b3.nix {
    inherit fetchurl stdenv openssl;
  };

  squashfsTools = callPackage ../tools/filesystems/squashfs { };

  sshfsFuse = callPackage ../tools/filesystems/sshfs-fuse { };

  sudo = callPackage ../tools/security/sudo { };

  suidChroot = builderDefsPackage (import ../tools/system/suid-chroot) {
  };

  ssmtp = callPackage ../tools/networking/ssmtp {
    tlsSupport = true;
  };

  ssss = callPackage ../tools/security/ssss { };

  stun = callPackage ../tools/networking/stun { };

  stunnel = callPackage ../tools/networking/stunnel { };

  su = shadow;

  swec = callPackage ../tools/networking/swec {
    inherit (perlPackages) LWP URI HTMLParser HTTPServerSimple Parent;
  };

  svnfs = callPackage ../tools/filesystems/svnfs { };

  system_config_printer = callPackage ../tools/misc/system-config-printer { };

  sitecopy = callPackage ../tools/networking/sitecopy { };

  privoxy = callPackage ../tools/networking/privoxy {
    autoconf = autoconf213;
  };

  tcpdump = callPackage ../tools/networking/tcpdump { };

  tcng = callPackage ../tools/networking/tcng {
    kernel = linux_2_6_28;
  };

  telnet = callPackage ../tools/networking/telnet { };

  texmacs = callPackage ../applications/office/texmacs { };

  tor = callPackage ../tools/security/tor { };

  ttf2pt1 = callPackage ../tools/misc/ttf2pt1 { };

  ucl = callPackage ../development/libraries/ucl { };

  ufraw = callPackage ../applications/graphics/ufraw {
    inherit (gnome) gtk;
  };

  unetbootin = callPackage ../tools/cd-dvd/unetbootin { };

  upx = callPackage ../tools/compression/upx { };

  vbetool = builderDefsPackage ../tools/system/vbetool {
    inherit pciutils libx86 zlib;
  };

  viking = callPackage ../applications/misc/viking {
    inherit (gtkLibs) gtk;
  };

  vncrec = builderDefsPackage ../tools/video/vncrec {
    inherit (xlibs) imake libX11 xproto gccmakedep libXt
      libXmu libXaw libXext xextproto libSM libICE libXpm
      libXp;
  };

  vpnc = callPackage ../tools/networking/vpnc { };

  vtun = callPackage ../tools/networking/vtun { };

  testdisk = callPackage ../tools/misc/testdisk { };

  htmlTidy = callPackage ../tools/text/html-tidy { };

  tigervnc = callPackage ../tools/admin/tigervnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  tightvnc = callPackage ../tools/admin/tightvnc {
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = callPackage ../tools/misc/time { };

  tm = callPackage ../tools/system/tm { };

  trang = callPackage ../tools/text/xml/trang { };

  tre = callPackage ../development/libraries/tre { };

  ts = callPackage ../tools/system/ts { };

  transfig = callPackage ../tools/graphics/transfig { };

  truecrypt = callPackage ../applications/misc/truecrypt {
    wxGUI = getConfig [ "truecrypt" "wxGUI" ] true;
  };

  ttmkfdir = callPackage ../tools/misc/ttmkfdir {
    flex = flex2534;
  };

  unbound = callPackage ../tools/networking/unbound { };

  units = callPackage ../tools/misc/units { };

  unrar = callPackage ../tools/archivers/unrar { };

  unshield = callPackage ../tools/archivers/unshield { };

  unzip = unzip552;

  # TODO: remove in the next stdenv update.
  unzip552 = callPackage ../tools/archivers/unzip/5.52.nix { };

  unzip60 = callPackage ../tools/archivers/unzip/6.0.nix { };

  uptimed = callPackage ../tools/system/uptimed { };

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

  wv = callPackage ../tools/misc/wv { };

  wv2 = callPackage ../tools/misc/wv2 { };

  x11_ssh_askpass = callPackage ../tools/networking/x11-ssh-askpass { };

  xbursttools = import ../tools/misc/xburst-tools {
    inherit stdenv fetchgit autoconf automake libusb confuse;
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

  xfsprogs = callPackage ../tools/filesystems/xfsprogs { };

  xmlroff = callPackage ../tools/typesetting/xmlroff {
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) libgnomeprint;
  };

  xmlstarlet = callPackage ../tools/text/xml/xmlstarlet { };

  xmlto = callPackage ../tools/typesetting/xmlto { };

  xmltv = callPackage ../tools/misc/xmltv { };

  xmpppy = builderDefsPackage (import ../development/python-modules/xmpppy) {
    inherit python setuptools;
  };

  xpf = callPackage ../tools/text/xml/xpf {
    libxml2 = libxml2Python;
  };

  xsel = callPackage ../tools/misc/xsel { };

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

  clang = llvm.override {
    buildClang = true;
  };

  dylan = callPackage ../development/compilers/gwydion-dylan {
    dylan =
      import ../development/compilers/gwydion-dylan/binary.nix {
        inherit fetchurl stdenv;
  };
  };

  ecl = builderDefsPackage ../development/compilers/ecl {
    inherit gmp mpfr;
  };

  adobe_flex_sdk = callPackage ../development/compilers/adobe-flex-sdk { };

  fpc = callPackage ../development/compilers/fpc { };

  gambit = callPackage ../development/compilers/gambit { };

  gcc = gcc44;

  gcc295 = wrapGCC (import ../development/compilers/gcc-2.95 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc33 = wrapGCC (import ../development/compilers/gcc-3.3 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc34 = wrapGCC (import ../development/compilers/gcc-3.4 {
    inherit fetchurl stdenv noSysDirs;
  });

  # XXX: GCC 4.2 (and possibly others) misdetects `makeinfo' when
  # using Texinfo >= 4.10, just because it uses a stupid regexp that
  # expects a single digit after the dot.  As a workaround, we feed
  # GCC with Texinfo 4.9.  Stupid bug, hackish workaround.

  gcc40 = wrapGCC (makeOverridable (import ../development/compilers/gcc-4.0) {
    inherit fetchurl stdenv noSysDirs;
    texinfo = texinfo49;
    profiledCompiler = true;
  });

  gcc41 = wrapGCC (makeOverridable (import ../development/compilers/gcc-4.1) {
    inherit fetchurl stdenv noSysDirs;
    texinfo = texinfo49;
    profiledCompiler = false;
  });

  gcc42 = wrapGCC (makeOverridable (import ../development/compilers/gcc-4.2) {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = false;
  });

  gcc44 = gcc44_real;

  gcc43 = lowPrio (wrapGCC (makeOverridable (import ../development/compilers/gcc-4.3) {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs;
    profiledCompiler = true;
  }));

  gcc43_realCross = makeOverridable (import ../development/compilers/gcc-4.3) {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs;
    binutilsCross = binutilsCross;
    libcCross = libcCross;
    profiledCompiler = false;
    enableMultilib = true;
    crossStageStatic = false;
    cross = assert crossSystem != null; crossSystem;
  };

  gcc44_realCross = lib.addMetaAttrs { platforms = []; }
    (makeOverridable (import ../development/compilers/gcc-4.4) {
      inherit stdenv fetchurl texinfo gmp mpfr ppl cloogppl noSysDirs
          gettext which;
      binutilsCross = binutilsCross;
      libcCross = libcCross;
      profiledCompiler = false;
      enableMultilib = false;
      crossStageStatic = false;
      cross = assert crossSystem != null; crossSystem;
    });

  gcc45_realCross = lib.addMetaAttrs { platforms = []; }
    (makeOverridable (import ../development/compilers/gcc-4.5) {
      inherit fetchurl stdenv texinfo gmp mpfr mpc libelf zlib
        ppl cloogppl gettext which noSysDirs;
      binutilsCross = binutilsCross;
      libcCross = libcCross;
      profiledCompiler = false;
      enableMultilib = false;
      crossStageStatic = false;
      cross = assert crossSystem != null; crossSystem;
    });

  gcc_realCross = gcc45_realCross;

  gccCrossStageStatic = let
      isMingw = (stdenv.cross.libc == "msvcrt");
      libcCross1 = if isMingw then windows.mingw_headers1 else null;
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
        then hurdLibpthreadCross
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

  gcc44_real = lowPrio (wrapGCC (makeOverridable (import ../development/compilers/gcc-4.4) {
    inherit fetchurl stdenv texinfo gmp mpfr /* ppl cloogppl */
      gettext which noSysDirs;
    profiledCompiler = true;
  }));

  gcc45 = lowPrio (wrapGCC (makeOverridable (import ../development/compilers/gcc-4.5) {
    inherit fetchurl stdenv texinfo gmp mpfr mpc libelf zlib perl
      ppl cloogppl
      gettext which noSysDirs;
    profiledCompiler = true;
  }));

  gccApple =
    wrapGCC ( (if stdenv.system == "i686-darwin" then import ../development/compilers/gcc-apple else import ../development/compilers/gcc-apple64) {
      inherit fetchurl stdenv noSysDirs;
      profiledCompiler = true;
    }) ;

  gccupc40 = wrapGCCUPC (import ../development/compilers/gcc-upc-4.0 {
    inherit fetchurl stdenv bison autoconf gnum4 noSysDirs;
    texinfo = texinfo49;
  });

  gfortran = gfortran43;

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

  gfortran44 = wrapGCC (gcc44_real.gcc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  });

  gcj = gcj45;

  gcj44 = wrapGCC (gcc44_real.gcc.override {
    name = "gcj";
    langJava = true;
    langFortran = false;
    langCC = true;
    langC = false;
    profiledCompiler = false;
    inherit zip unzip zlib boehmgc gettext pkgconfig;
    inherit (gtkLibs) gtk;
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
    inherit (gtkLibs) gtk;
    inherit (gnome) libart_lgpl;
    inherit (xlibs) libX11 libXt libSM libICE libXtst libXi libXrender
      libXrandr xproto renderproto xextproto inputproto randrproto;
  });

  gnat = gnat44;

  gnat44 = wrapGCC (gcc44_real.gcc.override {
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

  gnatboot = wrapGCC (import ../development/compilers/gnatboot {
    inherit fetchurl stdenv;
  });

  ghdl = wrapGCC (import ../development/compilers/gcc-4.3 {
    inherit stdenv fetchurl texinfo gmp mpfr noSysDirs gnat;
    name = "ghdl";
    langVhdl = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
    enableMultilib = false;
  });

  # Not officially supported version for ghdl
  ghdl_gcc44 = lowPrio (wrapGCC (import ../development/compilers/gcc-4.4 {
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
      gmp texinfo;
    inherit (xlibs) libX11 xproto inputproto libXi
      libXext xextproto libXt libXaw libXmu;
    inherit stdenv;
    texLive = texLiveAggregationFun {
      paths = [
        texLive texLiveExtra
      ];
    };
  };

  # GHC

  # GHC binaries are around for bootstrapping purposes

  # If we'd want to reactivate the 6.6 and 6.8 series of ghc, we'd
  # need to reenable an old binary such as this.
  /*
  ghc642Binary = lowPrio (import ../development/compilers/ghc/6.4.2-binary.nix {
    inherit fetchurl stdenv ncurses gmp;
    readline = if stdenv.system == "i686-linux" then readline4 else readline5;
    perl = perl58;
  });
  */

  ghc6101Binary = lowPrio (import ../development/compilers/ghc/6.10.1-binary.nix {
    inherit fetchurl stdenv perl ncurses gmp libedit;
  });

  ghc6102Binary = lowPrio (import ../development/compilers/ghc/6.10.2-binary.nix {
    inherit fetchurl stdenv perl ncurses gmp libedit;
  });

  # For several compiler versions, we export a large set of Haskell-related
  # packages.

  # This should point to the current default version.
  haskellPackages = haskellPackages_ghc6123;

  # Old versions of ghc that currently don't build because the binary
  # is broken.
  /*
  haskellPackages_ghc642 = callPackage ./haskell-packages.nix {
    ghc = import ../development/compilers/ghc/6.4.2.nix {
      inherit fetchurl stdenv perl ncurses readline m4 gmp;
      ghc = ghc642Binary;  };
  };

  haskellPackages_ghc661 = callPackage ./haskell-packages.nix {
    ghc = import ../development/compilers/ghc/6.6.1.nix {
      inherit fetchurl stdenv readline perl58 gmp ncurses m4;
      ghc = ghc642Binary;
  };
  };

  haskellPackages_ghc682 = callPackage ./haskell-packages.nix {
    ghc = import ../development/compilers/ghc/6.8.2.nix {
      inherit fetchurl stdenv perl gmp ncurses m4;
      readline = readline5;
      ghc = ghc642Binary;
  };
  };

  haskellPackages_ghc683 = recurseIntoAttrs (import ./haskell-packages.nix {
    inherit pkgs;
    ghc = callPackage ../development/compilers/ghc/6.8.3.nix {
      ghc = ghc642Binary;
      haddock = import ../development/tools/documentation/haddock/boot.nix {
        inherit gmp;
        cabal = import ../development/libraries/haskell/cabal/cabal.nix {
          inherit stdenv fetchurl lib;
          ghc = ghc642Binary;    };
      };
    };
  });
  */

  # NOTE: After discussion, we decided to enable recurseIntoAttrs for all
  # currently available ghc versions. (Before, it used to be enabled only
  # for a selected few versions.) If someone complains about nix-env -qa
  # output being spammed by lots of Haskell packages, we can talk about
  # reducing the number or "enabled" versions again.

  # Helper functions to abstract away from repetitive instantiations.
  haskellPackagesFun610 = ghcPath : profDefault : recurseIntoAttrs (import ./haskell-packages.nix {
    inherit pkgs newScope;
    enableLibraryProfiling = getConfig [ "cabal" "libraryProfiling" ] profDefault;
    ghc = callPackage ghcPath {
      ghc = ghc6101Binary;    };
  });

  haskellPackagesFun612 = ghcPath : profDefault : recurseIntoAttrs (import ./haskell-packages.nix {
    inherit pkgs newScope;
    enableLibraryProfiling = getConfig [ "cabal" "libraryProfiling" ] profDefault;
    ghc = callPackage ghcPath {
      ghc = ghc6101Binary;    };
  });

  # Currently active GHC versions.
  haskellPackages_ghc6101 =
    haskellPackagesFun610 ../development/compilers/ghc/6.10.1.nix false;

  haskellPackages_ghc6102 =
    haskellPackagesFun610 ../development/compilers/ghc/6.10.2.nix false;

  haskellPackages_ghc6103 =
    haskellPackagesFun610 ../development/compilers/ghc/6.10.3.nix false;

  # Current default version.
  haskellPackages_ghc6104 =
    haskellPackagesFun610 ../development/compilers/ghc/6.10.4.nix false;

  haskellPackages_ghc6121 =
    haskellPackagesFun612 ../development/compilers/ghc/6.12.1.nix false;

  haskellPackages_ghc6122 =
    haskellPackagesFun612 ../development/compilers/ghc/6.12.2.nix false;

  haskellPackages_ghc6123 =
    haskellPackagesFun612 ../development/compilers/ghc/6.12.3.nix false;

  # Currently not pointing to the actual HEAD, therefore disabled
  /*
  haskellPackages_ghcHEAD = lowPrio (import ./haskell-packages.nix {
    inherit pkgs;
    ghc = callPackage ../development/compilers/ghc/6.11.nix {
      inherit (haskellPackages) happy alex; # hope these aren't required for the final version
      ghc = ghc6101Binary;    };
  });
  */

  haxeDist = import ../development/compilers/haxe {
    inherit fetchurl sourceFromHead stdenv lib ocaml zlib makeWrapper neko;
  };
  haxe = haxeDist.haxe;
  haxelib = haxeDist.haxelib;

  falcon = builderDefsPackage (import ../development/interpreters/falcon) {
    inherit cmake;
  };

  go = callPackage ../development/compilers/go { };

  gprolog = callPackage ../development/compilers/gprolog { };

  gwt = callPackage ../development/compilers/gwt {
    inherit (gtkLibs) glib gtk pango atk;
    libstdcpp5 = gcc33.gcc;
  };

  ikarus = callPackage ../development/compilers/ikarus { };

  #TODO add packages http://cvs.haskell.org/Hugs/downloads/2006-09/packages/ and test
  # commented out because it's using the new configuration style proposal which is unstable
  hugs = callPackage ../development/compilers/hugs { };

  path64 = callPackage ../development/compilers/path64 {
    stdenv = stdenv2;
  };

  openjdkDarwin = callPackage ../development/compilers/openjdk-darwin { };

  j2sdk14x = (
    assert system == "i686-linux";
    import ../development/compilers/jdk/default-1.4.nix {
      inherit fetchurl stdenv;
    });

  jdk5 = (
    assert system == "i686-linux" || system == "x86_64-linux";
    import ../development/compilers/jdk/default-5.nix {
      inherit fetchurl stdenv unzip;
    });

  jdk       = if stdenv.isDarwin then openjdkDarwin else jdkdistro true  false;
  jre       = jdkdistro false false;

  jdkPlugin = jdkdistro true true;
  jrePlugin = jdkdistro false true;

  supportsJDK =
    system == "i686-linux" ||
    system == "x86_64-linux" ||
    system == "i686-cygwin" ||
    system == "powerpc-linux";

  jdkdistro = installjdk: pluginSupport:
       (assert supportsJDK;
    (if pluginSupport then appendToName "plugin" else x: x) (import ../development/compilers/jdk {
      inherit fetchurl stdenv unzip installjdk xlibs pluginSupport makeWrapper cabextract;
    }));

  jikes = callPackage ../development/compilers/jikes { };

  lazarus = builderDefsPackage (import ../development/compilers/fpc/lazarus.nix) {
    inherit fpc makeWrapper;
    inherit (gtkLibs) gtk glib pango atk;
    inherit (xlibs) libXi inputproto libX11 xproto libXext xextproto;
  };

  llvm = callPackage ../development/compilers/llvm { };

  mitscheme = callPackage ../development/compilers/mit-scheme { };

  mlton = callPackage ../development/compilers/mlton { };

  mono = callPackage ../development/compilers/mono { };

  monoDLLFixer = callPackage ../build-support/mono-dll-fixer { };

  mozart = callPackage ../development/compilers/mozart { };

  neko = callPackage ../development/compilers/neko {
    inherit (gtkLibs) gtk;
  };

  nasm = callPackage ../development/compilers/nasm { };

  ocaml = ocaml_3_11_1;

  ocaml_3_08_0 = callPackage ../development/compilers/ocaml/3.08.0.nix { };

  ocaml_3_10_0 = callPackage ../development/compilers/ocaml/3.10.0.nix { };

  ocaml_3_11_1 = callPackage ../development/compilers/ocaml/3.11.1.nix { };

  opencxx = callPackage ../development/compilers/opencxx {
    gcc = gcc33;
  };

  qcmm = callPackage ../development/compilers/qcmm {
    lua   = lua4;
    ocaml = ocaml_3_08_0;
  };

  roadsend = callPackage ../development/compilers/roadsend { };

  sbcl = builderDefsPackage (import ../development/compilers/sbcl) {
    inherit makeWrapper clisp;
  };

  scala = callPackage ../development/compilers/scala { };

  stalin = callPackage ../development/compilers/stalin { };

  strategoPackages = strategoPackages017;

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

  tinycc = callPackage ../development/compilers/tinycc { };

  urweb = callPackage ../development/compilers/urweb { };

  vala = callPackage ../development/compilers/vala { };

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
    inherit stdenv binutils coreutils zlib;
  };

  wrapGCC = wrapGCCWith (import ../build-support/gcc-wrapper) glibc;

  # To be removed on stdenv-updates
  # By now this has at least the fix of setting the proper rpath when a file "libbla.so"
  # is passed directly to the linker.
  # This is of interest to programs built by cmake, because this is a common practice
  # in cmake builds.
  wrapGCC2 = wrapGCCWith (import ../build-support/gcc-wrapper/default2.nix) glibc;
  stdenv2 = if (gcc.nativeTools) then stdenv else (overrideGCC stdenv (wrapGCC2 gcc.gcc));

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

  clisp = callPackage ../development/interpreters/clisp { };

  # compatibility issues in 2.47 - at list 2.44.1 is known good
  # for sbcl bootstrap
  clisp_2_44_1 = callPackage ../development/interpreters/clisp/2.44.1.nix {
    libsigsegv = libsigsegv_25;  };

  erlang = callPackage ../development/interpreters/erlang { };

  erlangR13B = callPackage ../development/interpreters/erlang/R13B.nix { };

  groovy = callPackage ../development/interpreters/groovy { };

  guile = callPackage ../development/interpreters/guile { };

  guile_1_9 = callPackage ../development/interpreters/guile/1.9.nix { };

  io = builderDefsPackage (import ../development/interpreters/io) {
    inherit sqlite zlib gmp libffi cairo ncurses freetype mesa
      libpng libtiff libjpeg readline libsndfile libxml2
      freeglut e2fsprogs libsamplerate pcre libevent libedit;
  };

  kaffe = callPackage ../development/interpreters/kaffe { };

  lua4 = callPackage ../development/interpreters/lua-4 { };

  lua5 = callPackage ../development/interpreters/lua-5 { };

  maude = callPackage ../development/interpreters/maude { };

  octave = callPackage ../development/interpreters/octave {
    # Needed because later gm versions require an initialization the actual octave is not
    # doing.
    # http://www-old.cae.wisc.edu/pipermail/octave-maintainers/2010-February/015295.html
    graphicsmagick = graphicsmagick137;
  };

  # mercurial (hg) bleeding edge version
  octaveHG = callPackage ../development/interpreters/octave/hg.nix { };

  perl58 = callPackage ../development/interpreters/perl-5.8 {
    impureLibcPath = if stdenv.isLinux then null else "/usr";
  };

  perl510 = callPackage ../development/interpreters/perl-5.10 {
    fetchurl = fetchurlBoot;
  };

  perl = if system != "i686-cygwin" then perl510 else sysPerl;

  php = makeOverridable (import ../development/interpreters/php) {
    inherit
      stdenv fetchurl lib composableDerivation autoconf automake
      flex bison apacheHttpd mysql libxml2
      zlib curl gd postgresql openssl pkgconfig sqlite getConfig libiconv libjpeg libpng;
  };

  phpXdebug = callPackage ../development/interpreters/php-xdebug { };

  pltScheme = builderDefsPackage (import ../development/interpreters/plt-scheme) {
    inherit cairo fontconfig freetype libjpeg libpng openssl
      perl mesa zlib which;
    inherit (xorg) libX11 libXaw libXft libXrender libICE xproto
      renderproto pixman libSM libxcb libXext xextproto libXmu
      libXt;
  };

  polyml = callPackage ../development/compilers/polyml { };

  python = if getConfig ["python" "full"] false then pythonFull else pythonBase;
  python26 = if getConfig ["python" "full"] false then python26Full else python26Base;
  python27 = if getConfig ["python" "full"] false then python27Full else python27Base;
  pythonBase = python26Base;
  pythonFull = python26Full;

  pythonWrapper = callPackage ../development/interpreters/python/wrapper.nix { };

  python24 = lowPrio (callPackage ../development/interpreters/python/2.4 { });

  python26Base = lowPrio (makeOverridable (import ../development/interpreters/python/2.6) {
    inherit (pkgs) fetchurl stdenv zlib bzip2 gdbm;
    arch = if stdenv.isDarwin then darwinArchUtility else null;
    sw_vers = if stdenv.isDarwin then darwinSwVersUtility else null;
  });

  python26Full = lowPrio (python26Base.override {
    # FIXME: We lack ncurses support, needed, e.g., for `gpsd'.
    db4 = if getConfig ["python" "db4Support"] true then db4 else null;
    sqlite = if getConfig ["python" "sqliteSupport"] true then sqlite else null;
    readline = if getConfig ["python" "readlineSupport"] true then readline else null;
    openssl = if getConfig ["python" "opensslSupport"] true then openssl else null;
    tk = if getConfig ["python" "tkSupport"] true then tk else null;
    tcl = if getConfig ["python" "tkSupport"] true then tcl else null;
    libX11 = if getConfig ["python" "tkSupport"] true then xlibs.libX11 else null;
    xproto = if getConfig ["python" "tkSupport"] true then xlibs.xproto else null;
    ncurses = if getConfig ["python" "curses"] true then ncurses else null;
  });

  python27Base = lowPrio (makeOverridable (import ../development/interpreters/python/2.7) {
    inherit (pkgs) fetchurl stdenv zlib bzip2 gdbm;
    arch = if stdenv.isDarwin then darwinArchUtility else null;
    sw_vers = if stdenv.isDarwin then darwinSwVersUtility else null;
  });

  python27Full = lowPrio (python27Base.override {
    inherit (pkgs) db4 sqlite readline openssl tcl tk ncurses;
    inherit (pkgs.xlibs) libX11 xproto;
  });

  python31Base = lowPrio (makeOverridable (import ../development/interpreters/python/3.1) {
    inherit (pkgs) fetchurl stdenv zlib bzip2 gdbm;
    arch = if stdenv.isDarwin then darwinArchUtility else null;
    sw_vers = if stdenv.isDarwin then darwinSwVersUtility else null;
  });

  pyrex = pyrex095;

  pyrex095 = callPackage ../development/interpreters/pyrex/0.9.5.nix { };

  pyrex096 = callPackage ../development/interpreters/pyrex/0.9.6.nix { };

  qi = callPackage ../development/compilers/qi { };

  ruby18 = callPackage ../development/interpreters/ruby { };
  #ruby19 = import ../development/interpreters/ruby/ruby-19.nix { inherit ruby18 fetchurl; };
  ruby = ruby18;

  rubyLibs = recurseIntoAttrs (import ../development/interpreters/ruby/libs.nix {
    inherit pkgs stdenv;
  });

  rake = callPackage ../development/ruby-modules/rake { };

  rubySqlite3 = callPackage ../development/ruby-modules/sqlite3 { };

  rLang = callPackage ../development/interpreters/r-lang {
    withBioconductor = getConfig ["rLang" "withBioconductor"] false;
  };

  rubygemsFun = ruby: builderDefsPackage (import ../development/interpreters/ruby/gems.nix) {
    inherit ruby makeWrapper;
  };
  rubygems = rubygemsFun ruby;

  rq = callPackage ../applications/networking/cluster/rq { };

  scsh = callPackage ../development/interpreters/scsh { };

  spidermonkey = callPackage ../development/interpreters/spidermonkey { };
  spidermonkey_1_8_0rc1 = callPackage ../development/interpreters/spidermonkey/1.8.0-rc1.nix { };

  sysPerl = callPackage ../development/interpreters/sys-perl { };

  tcl = callPackage ../development/interpreters/tcl { };

  xulrunnerWrapper = {application, launcher}:
    import ../development/interpreters/xulrunner/wrapper {
      inherit stdenv application launcher;
      xulrunner = firefox36Pkgs.xulrunner;
    };


  ### DEVELOPMENT / MISC

  avrgcclibc = callPackage ../development/misc/avr-gcc-with-avr-libc {
    gcc = gcc40;
  };

  avr8burnomat = callPackage ../development/misc/avr8-burn-omat { };

  /*
  toolbus = callPackage ../development/interpreters/toolbus { };
  */

  sourceFromHead = import ../build-support/source-from-head-fun.nix {
    inherit getConfig;
  };

  ecj = callPackage ../development/eclipse/ecj { };

  ecjDarwin = ecj.override { gcj = openjdkDarwin; ant = antDarwin; };

  jdtsdk = callPackage ../development/eclipse/jdt-sdk { };

  jruby116 = callPackage ../development/interpreters/jruby { };

  guileCairo = callPackage ../development/guile-modules/guile-cairo { };

  guileGnome = callPackage ../development/guile-modules/guile-gnome {
    gconf = gnome.GConf;
    inherit (gnome) glib gnomevfs gtk libglade libgnome libgnomecanvas
      libgnomeui pango;
  };

  guile_lib = callPackage ../development/guile-modules/guile-lib { };

  windowssdk = (
    import ../development/misc/windows-sdk {
      inherit fetchurl stdenv cabextract;
    });


  ### DEVELOPMENT / TOOLS


  antlr = callPackage ../development/tools/parsing/antlr/2.7.7.nix { };

  antlr3 = callPackage ../development/tools/parsing/antlr { };

  antDarwin = apacheAnt.override rec { jdk = openjdkDarwin ; name = "ant-" + jdk.name ; } ;

  ant = apacheAnt;
  apacheAnt = callPackage ../development/tools/build-managers/apache-ant {
    name = "ant-" + jdk.name;  };

  apacheAnt14 = callPackage ../development/tools/build-managers/apache-ant {
    jdk = j2sdk14x;
    name = "ant-" + j2sdk14x.name;
  };

  apacheAntGcj = callPackage ../development/tools/build-managers/apache-ant/from-source.nix {  # must be either pre-built or built with GCJ *alone*
    gcj = gcj.gcc; # use the raw GCJ, which has ${gcj}/lib/jvm
  };

  autobuild = callPackage ../development/tools/misc/autobuild { };

  autoconf = callPackage ../development/tools/misc/autoconf { };

  autoconf213 = callPackage ../development/tools/misc/autoconf/2.13.nix { };

  automake = automake110x;

  automake17x = callPackage ../development/tools/misc/automake/automake-1.7.x.nix { };

  automake19x = callPackage ../development/tools/misc/automake/automake-1.9.x.nix { };

  automake110x = callPackage ../development/tools/misc/automake/automake-1.10.x.nix { };

  automake111x = callPackage ../development/tools/misc/automake/automake-1.11.x.nix { };

  avrdude = callPackage ../development/tools/misc/avrdude { };

  binutils = callPackage ../development/tools/misc/binutils {
    inherit noSysDirs;
  };

  binutilsCross = forceBuildDrv (import ../development/tools/misc/binutils {
      inherit stdenv fetchurl;
      noSysDirs = true;
      cross = assert crossSystem != null; crossSystem;
  });

  bison = bison23;

  bison1875 = callPackage ../development/tools/parsing/bison/bison-1.875.nix { };

  bison23 = callPackage ../development/tools/parsing/bison/bison-2.3.nix { };

  bison24 = callPackage ../development/tools/parsing/bison/bison-2.4.nix { };

  buildbot = callPackage ../development/tools/build-managers/buildbot {
    inherit (pythonPackages) twisted;
  };

  byacc = callPackage ../development/tools/parsing/byacc { };

  camlp5_strict = callPackage ../development/tools/ocaml/camlp5 { };

  camlp5_transitional = callPackage ../development/tools/ocaml/camlp5 {
    transitional = true;
  };

  ccache = callPackage ../development/tools/misc/ccache { };

  ctags = callPackage ../development/tools/misc/ctags { };

  ctagsWrapped = import ../development/tools/misc/ctags/wrapped.nix {
    inherit pkgs ctags writeScriptBin;
  };

  cmake = callPackage ../development/tools/build-managers/cmake { };

  coccinelle = callPackage ../development/tools/misc/coccinelle { };

  cppi = callPackage ../development/tools/misc/cppi { };

  cproto = callPackage ../development/tools/misc/cproto { };

  cflow = callPackage ../development/tools/misc/cflow { };

  cscope = callPackage ../development/tools/misc/cscope { };

  dejagnu = callPackage ../development/tools/misc/dejagnu { };

  ddd = callPackage ../development/tools/misc/ddd { };

  distcc = callPackage ../development/tools/misc/distcc {
    inherit (gtkLibs) gtk;
    static = false;
  };

  docutils = builderDefsPackage (import ../development/tools/documentation/docutils) {
    inherit python pil makeWrapper;
  };

  doxygen = callPackage ../development/tools/documentation/doxygen {
    qt = qt4;
  };

  eggdbus = callPackage ../development/tools/misc/eggdbus { };

  elfutils = callPackage ../development/tools/misc/elfutils { };

  epm = callPackage ../development/tools/misc/epm { };

  emma = callPackage ../development/tools/analysis/emma { };

  findbugs = callPackage ../development/tools/analysis/findbugs { };

  pmd = callPackage ../development/tools/analysis/pmd { };

  jdepend = callPackage ../development/tools/analysis/jdepend { };

  checkstyle = callPackage ../development/tools/analysis/checkstyle { };

  flex = flex254a;

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

  gnum4 = callPackage ../development/tools/misc/gnum4 { };

  gnumake = callPackage ../development/tools/build-managers/gnumake { };

  gnumake380 = callPackage ../development/tools/build-managers/gnumake-3.80 { };

  gradle = callPackage ../development/tools/build-managers/gradle { };

  gperf = callPackage ../development/tools/misc/gperf { };

  gtkdialog = callPackage ../development/tools/misc/gtkdialog {
    inherit (gtkLibs) gtk;
  };

  guileLint = callPackage ../development/tools/guile/guile-lint { };

  gwrap = callPackage ../development/tools/guile/g-wrap { };

  help2man = callPackage ../development/tools/misc/help2man {
    inherit (perlPackages) LocaleGettext;
  };

  iconnamingutils = callPackage ../development/tools/misc/icon-naming-utils {
    inherit (perlPackages) XMLSimple;
  };

  indent = callPackage ../development/tools/misc/indent { };

  inotifyTools = callPackage ../development/tools/misc/inotify-tools { };

  ired = callPackage ../development/tools/analysis/radare/ired.nix { };

  jikespg = callPackage ../development/tools/parsing/jikespg { };

  lcov = callPackage ../development/tools/analysis/lcov { };

  libtool = libtool_2;

  libtool_1_5 = callPackage ../development/tools/misc/libtool { };

  libtool_2 = callPackage ../development/tools/misc/libtool/libtool2.nix { };

  lsof = callPackage ../development/tools/misc/lsof { };

  ltrace = callPackage ../development/tools/misc/ltrace { };

  mig = callPackage ../os-specific/gnu/mig { };

  mk = callPackage ../development/tools/build-managers/mk { };

  noweb = callPackage ../development/tools/literate-programming/noweb { };

  omake = callPackage ../development/tools/ocaml/omake { };


  openocd = callPackage ../development/tools/misc/openocd { };

  oprofile = import ../development/tools/profiling/oprofile {
    inherit fetchurl stdenv binutils popt makeWrapper gawk which gnugrep;

    # Optional build inputs for the (useless) GUI.
    /*
    qt = qt3;
    inherit (xlibs) libX11 libXext;
    inherit libpng;
     */
  };

  patchelf = callPackage ../development/tools/misc/patchelf { };

  patchelf06 = callPackage ../development/tools/misc/patchelf/0.6.nix { };

  pmccabe = callPackage ../development/tools/misc/pmccabe { };

  /* Make pkgconfig always return a buildDrv, never a proper hostDrv,
     because most usage of pkgconfig as buildInput (inheritance of
     pre-cross nixpkgs) means using it using as buildNativeInput
     cross_renaming: we should make all programs use pkgconfig as
     buildNativeInput after the renaming.
     */
  pkgconfig = forceBuildDrv (callPackage ../development/tools/misc/pkgconfig { });

  radare = callPackage ../development/tools/analysis/radare {
    inherit (gtkLibs) gtk;
    inherit (gnome) vte;
    lua = lua5;
    useX11 = getConfig ["radare" "useX11"] false;
    pythonBindings = getConfig ["radare" "pythonBindings"] false;
    rubyBindings = getConfig ["radare" "rubyBindings"] false;
    luaBindings = getConfig ["radare" "luaBindings"] false;
  };

  ragel = callPackage ../development/tools/parsing/ragel { };

  remake = callPackage ../development/tools/build-managers/remake { };

  # couldn't find the source yet
  seleniumRCBin = callPackage ../development/tools/selenium/remote-control {
    jre = jdk;  };

  scons = callPackage ../development/tools/build-managers/scons { };

  simpleBuildTool = callPackage ../development/tools/build-managers/simple-build-tool { };

  sloccount = callPackage ../development/tools/misc/sloccount { };

  sparse = callPackage ../development/tools/analysis/sparse { };

  spin = callPackage ../development/tools/analysis/spin { };

  splint = callPackage ../development/tools/analysis/splint { };

  strace = callPackage ../development/tools/misc/strace { };

  swig = callPackage ../development/tools/misc/swig { };

  swigWithJava = swig;

  swftools = callPackage ../tools/video/swftools { };

  texinfo49 = callPackage ../development/tools/misc/texinfo/4.9.nix { };

  texinfo = callPackage ../development/tools/misc/texinfo { };

  texi2html = callPackage ../development/tools/misc/texi2html { };

  uisp = callPackage ../development/tools/misc/uisp { };

  gdb = callPackage ../development/tools/misc/gdb {
    readline = readline5;
  };

  gdbCross = callPackage ../development/tools/misc/gdb {
    readline = readline5;
    target = crossSystem;
  };

  valgrind = callPackage ../development/tools/analysis/valgrind { };

  xxdiff = builderDefsPackage (import ../development/tools/misc/xxdiff/3.2.nix) {
    flex = flex2535;
    qt = qt3;
    inherit pkgconfig makeWrapper bison python;
    inherit (xlibs) libXext libX11;
  };

  yacc = bison;

  yodl = callPackage ../development/tools/misc/yodl { };


  ### DEVELOPMENT / LIBRARIES


  a52dec = callPackage ../development/libraries/a52dec { };

  aalib = callPackage ../development/libraries/aalib { };

  acl = callPackage ../development/libraries/acl { };

  adns = import ../development/libraries/adns/1.4.nix {
    inherit stdenv fetchurl;
    static = getPkgConfig "adns" "static" (stdenv ? isStatic || stdenv ? isDietLibC);
  };

  agg = callPackage ../development/libraries/agg { };

  amrnb = callPackage ../development/libraries/amrnb { };

  amrwb = callPackage ../development/libraries/amrwb { };

  apr = callPackage ../development/libraries/apr { };

  aprutil = callPackage ../development/libraries/apr-util {
    bdbSupport = true;
  };

  aspell = callPackage ../development/libraries/aspell { };

  aspellDicts = recurseIntoAttrs (import ../development/libraries/aspell/dictionaries.nix {
    inherit fetchurl stdenv aspell which;
  });

  aterm = aterm25;

  aterm242fixes = lowPrio (import ../development/libraries/aterm/2.4.2-fixes.nix {
    inherit fetchurl stdenv;
  });

  aterm25 = callPackage ../development/libraries/aterm/2.5.nix { };

  aterm28 = lowPrio (callPackage ../development/libraries/aterm/2.8.nix { });

  attr = callPackage ../development/libraries/attr { };

  aubio = callPackage ../development/libraries/aubio { };

  axis = callPackage ../development/libraries/axis { };

  babl = callPackage ../development/libraries/babl { };

  beecrypt = callPackage ../development/libraries/beecrypt { };

  boehmgc = callPackage ../development/libraries/boehm-gc { };

  boolstuff = callPackage ../development/libraries/boolstuff { };

  boost = callPackage ../development/libraries/boost { };

  # A Boost build with all library variants enabled.  Very large (about 250 MB).
  boostFull = appendToName "full" (boost.override {
    enableDebug = true;
    enableSingleThreaded = true;
    enableStatic = true;
  });

  botan = builderDefsPackage (import ../development/libraries/botan) {
    inherit perl;
  };

  buddy = callPackage ../development/libraries/buddy { };

  cairo = callPackage ../development/libraries/cairo { };

  cairomm = callPackage ../development/libraries/cairomm { };

  scmccid = callPackage ../development/libraries/scmccid { };

  ccrtp = callPackage ../development/libraries/ccrtp { };

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

  clapack = callPackage ../development/libraries/clapack {
    stdenv = stdenv2;
  };

  classads = callPackage ../development/libraries/classads { };

  classpath = callPackage ../development/libraries/java/classpath {
    javac = gcj;
    jvm = gcj;
    inherit (gtkLibs) gtk;
    gconf = gnome.GConf;
  };

  clearsilver = callPackage ../development/libraries/clearsilver { };

  cln = callPackage ../development/libraries/cln { };

  clppcre = builderDefsPackage (import ../development/libraries/cl-ppcre) {
  };

  cluceneCore = callPackage ../development/libraries/clucene-core { };

  clutter = callPackage ../development/libraries/clutter {
    inherit (gnome) glib pango gtk;
  };

  clutter_gtk = callPackage ../development/libraries/clutter-gtk {
    inherit (gnome) gtk;
  };

  commoncpp2 = callPackage ../development/libraries/commoncpp2 { };

  confuse = callPackage ../development/libraries/confuse { };

  consolekit = callPackage ../development/libraries/consolekit { };

  coredumper = callPackage ../development/libraries/coredumper { };

  ctl = callPackage ../development/libraries/ctl { };

  cppunit = callPackage ../development/libraries/cppunit { };

  cracklib = callPackage ../development/libraries/cracklib { };

  cryptopp = callPackage ../development/libraries/crypto++ { };

  cyrus_sasl = callPackage ../development/libraries/cyrus-sasl { };

  db4 = db45;

  db44 = callPackage ../development/libraries/db4/db4-4.4.nix { };

  db45 = callPackage ../development/libraries/db4/db4-4.5.nix { };

  dbus = callPackage ../development/libraries/dbus {
    useX11 = true; # !!! `false' doesn't build
  };

  dbus_glib = makeOverridable (import ../development/libraries/dbus-glib) {
    inherit fetchurl stdenv pkgconfig gettext dbus expat glib;
    libiconv = if (stdenv.system == "i686-freebsd") then libiconv else null;
  };

  dbus_java = callPackage ../development/libraries/java/dbus-java { };

  dclib = callPackage ../development/libraries/dclib { };

  directfb = callPackage ../development/libraries/directfb { };

  dragonegg = callPackage ../development/compilers/llvm/dragonegg.nix {
    stdenv = overrideGCC stdenv gcc45;
  };

  enchant = callPackage ../development/libraries/enchant {
    inherit (gnome) glib;
  };

  enet = callPackage ../development/libraries/enet { };

  enginepkcs11 = callPackage ../development/libraries/enginepkcs11 { };

  esdl = callPackage ../development/libraries/esdl { };

  exiv2 = callPackage ../development/libraries/exiv2 { };

  expat = callPackage ../development/libraries/expat { };

  extremetuxracer = builderDefsPackage (import ../games/extremetuxracer) {
    inherit mesa tcl freeglut SDL SDL_mixer pkgconfig
      libpng gettext intltool;
    inherit (xlibs) libX11 xproto libXi inputproto
      libXmu libXext xextproto libXt libSM libICE;
  };

  eventlog = callPackage ../development/libraries/eventlog { };

  facile = callPackage ../development/libraries/facile {
    # Actually, we don't need this version but we need native-code compilation
    ocaml = ocaml_3_10_0;
  };

  faac = callPackage ../development/libraries/faac { };

  faad2 = callPackage ../development/libraries/faad2 { };

  farsight2 = callPackage ../development/libraries/farsight2 {
    inherit (gnome) glib;
    inherit (gst_all) gstreamer gstPluginsBase;
  };

  fcgi = callPackage ../development/libraries/fcgi { };

  ffmpeg = callPackage ../development/libraries/ffmpeg { };

  fftw = callPackage ../development/libraries/fftw {
    singlePrecision = false;
  };

  fftwSinglePrec = callPackage ../development/libraries/fftw {
    singlePrecision = true;
  };

  fltk11 = callPackage ../development/libraries/fltk/fltk11.nix { };

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

  fam = gamin;

  gamin = callPackage ../development/libraries/gamin { };

  gav = callPackage ../games/gav {
    stdenv = overrideGCC stdenv gcc41;
  };

  gdbm = callPackage ../development/libraries/gdbm { };

  gdk_pixbuf = callPackage ../development/libraries/gdk-pixbuf {
    inherit (gtkLibs1x) gtk;
  };

  gegl = callPackage ../development/libraries/gegl {
    #  avocodec avformat librsvg
    inherit (gtkLibs) pango glib gtk;
  };

  geoip = builderDefsPackage ../development/libraries/geoip {
    inherit zlib;
  };

  geoipjava = callPackage ../development/libraries/java/geoipjava { };

  geos = callPackage ../development/libraries/geos { };

  gettext = callPackage ../development/libraries/gettext { };

  # XXX: Remove me when `stdenv-updates' is merged.
  gettext_0_18 = callPackage ../development/libraries/gettext/0.18.nix { };

  gd = callPackage ../development/libraries/gd { };

  gdal = callPackage ../development/libraries/gdal { };

  giblib = callPackage ../development/libraries/giblib { };

  glew = callPackage ../development/libraries/glew { };

  glfw = callPackage ../development/libraries/glfw { };

  glibc = glibc211;

  glibc25 = callPackage ../development/libraries/glibc-2.5 {
    kernelHeaders = linuxHeaders;
    installLocales = false;
  };

  glibc27 = callPackage ../development/libraries/glibc-2.7 {
    kernelHeaders = linuxHeaders;
    #installLocales = false;
  };

  glibc29 = callPackage ../development/libraries/glibc-2.9 {
    kernelHeaders = linuxHeaders;
    installLocales = getPkgConfig "glibc" "locales" false;
  };

  glibc29Cross = forceBuildDrv (makeOverridable (import ../development/libraries/glibc-2.9) {
    inherit stdenv fetchurl;
    gccCross = gccCrossStageStatic;
    kernelHeaders = linuxHeadersCross;
    installLocales = getPkgConfig "glibc" "locales" false;
  });

  glibc211 = callPackage ../development/libraries/glibc-2.11 {
    kernelHeaders = linuxHeaders;
    installLocales = getPkgConfig "glibc" "locales" false;
    machHeaders = null;
    hurdHeaders = null;
    gccCross = null;
  };

  glibc211Cross = forceBuildDrv (makeOverridable (import ../development/libraries/glibc-2.11)
    (let crossGNU = (crossSystem != null && crossSystem.config == "i586-pc-gnu");
     in ({
       inherit stdenv fetchurl;
       gccCross = gccCrossStageStatic;
       kernelHeaders = if crossGNU then hurdHeaders else linuxHeadersCross;
       installLocales = getPkgConfig "glibc" "locales" false;
     }

     //

     (if crossGNU
      then { inherit machHeaders hurdHeaders mig fetchgit; }
      else { }))));

  glibcCross = glibc211Cross;

  # We can choose:
  libcCrossChooser = name : if (name == "glibc") then glibcCross
    else if (name == "uclibc") then uclibcCross
    else if (name == "msvcrt") then windows.mingw_headers3
    else throw "Unknown libc";

  libcCross = assert crossSystem != null; libcCrossChooser crossSystem.libc;

  libdbusmenu_qt = callPackage ../development/libraries/libdbusmenu-qt { };

  libdwg = callPackage ../development/libraries/libdwg { };

  eglibc = callPackage ../development/libraries/eglibc {
    kernelHeaders = linuxHeaders;
    installLocales = getPkgConfig "glibc" "locales" false;
  };

  glibcLocales = callPackage ../development/libraries/glibc-2.11/locales.nix { };

  glibcInfo = callPackage ../development/libraries/glibc-2.11/info.nix { };

  glibc_multi =
      runCommand "${glibc.name}-multi"
        { glibc64 = glibc;
          glibc32 = (import ./all-packages.nix {system = "i686-linux";}).glibc;
        }
        ''
          ensureDir $out
          ln -s $glibc64/* $out/

          rm $out/lib $out/lib64
          ensureDir $out/lib
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

  gmime_2_2 = callPackage ../development/libraries/gmime/2.2.x.nix { };

  gmm = callPackage ../development/libraries/gmm { };

  gmp =
    if stdenv.system == "i686-darwin" then
      # GMP 4.3.2 is broken on Darwin, so use 4.3.1.
      makeOverridable (import ../development/libraries/gmp/4.3.1.nix) {
        inherit stdenv fetchurl m4;
        cxx = false;
      }
    else
      makeOverridable (import ../development/libraries/gmp) {
        inherit stdenv fetchurl m4;
        cxx = false;
      };

  gmpxx = gmp.override { cxx = true; };

  gobjectIntrospection = callPackage ../development/libraries/gobject-introspection { };

  goffice = callPackage ../development/libraries/goffice {
    inherit (gnome) glib gtk libglade libgnomeui pango;
    gconf = gnome.GConf;
    libart = gnome.libart_lgpl;
  };

  goocanvas = callPackage ../development/libraries/goocanvas {
    inherit (gnome) gtk glib;
  };

  #GMP ex-satellite, so better keep it near gmp
  mpfr = callPackage ../development/libraries/mpfr { };

  gst_all = recurseIntoAttrs (import ../development/libraries/gstreamer {
    inherit lib stdenv fetchurl perl bison pkgconfig libxml2
      python alsaLib cdparanoia libogg libvorbis libtheora freetype liboil
      libjpeg zlib speex libpng libdv aalib cairo libcaca flac hal libiec61883
      dbus libavc1394 ladspaH taglib pulseaudio gdbm bzip2 which makeOverridable
      libcap libtasn1;
    flex = flex2535;
    inherit (xorg) libX11 libXv libXext;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) gnomevfs /* <- only passed for the no longer used older versions
             it is deprecated and didn't build on amd64 due to samba dependency */ gtkdoc
      libsoup;
  });

  gnet = callPackage ../development/libraries/gnet { };

  gnutls = callPackage ../development/libraries/gnutls {
    guileBindings = getConfig ["gnutls" "guile"] true;
  };

  gpgme = callPackage ../development/libraries/gpgme { };

  grantlee = callPackage ../development/libraries/grantlee { };

  gsasl = callPackage ../development/libraries/gsasl { };

  gsl = callPackage ../development/libraries/gsl { };

  gsoap = callPackage ../development/libraries/gsoap { };

  gss = callPackage ../development/libraries/gss { };

  gtkimageview = callPackage ../development/libraries/gtkimageview {
    inherit (gnome) gtk;
  };

  gtkLibs = gtkLibs220;

  glib = gtkLibs.glib;

  gtkLibs1x = recurseIntoAttrs (let callPackage = newScope pkgs.gtkLibs1x; in rec {

    glib = callPackage ../development/libraries/glib/1.2.x.nix { };

    gtk = callPackage ../development/libraries/gtk+/1.2.x.nix { };

  });

  gtkLibs216 = recurseIntoAttrs (let callPackage = newScope pkgs.gtkLibs216; in rec {

    glib = callPackage ../development/libraries/glib/2.20.x.nix { };

    glibmm = callPackage ../development/libraries/glibmm/2.18.x.nix { };

    atk = callPackage ../development/libraries/atk/1.24.x.nix { };

    pango = callPackage ../development/libraries/pango/1.24.x.nix { };

    pangomm = callPackage ../development/libraries/pangomm/2.14.x.nix { };

    gtk = callPackage ../development/libraries/gtk+/2.16.x.nix { };

    gtkmm = callPackage ../development/libraries/gtkmm/2.14.x.nix { };

  });

  gtkLibs218 = recurseIntoAttrs (let callPackage = newScope pkgs.gtkLibs218; in rec {

    glib = callPackage ../development/libraries/glib/2.22.x.nix {
      libiconv = if stdenv.system == "i686-freebsd" then libiconv else null;
    };

    glibmm = callPackage ../development/libraries/glibmm/2.22.x.nix { };

    atk = callPackage ../development/libraries/atk/1.28.x.nix { };

    pango = callPackage ../development/libraries/pango/1.26.x.nix { };

    pangomm = callPackage ../development/libraries/pangomm/2.26.x.nix { };

    gtk = callPackage ../development/libraries/gtk+/2.18.x.nix { };

    gtkmm = callPackage ../development/libraries/gtkmm/2.18.x.nix { };

  });

  gtkLibs220 = recurseIntoAttrs (let callPackage = newScope pkgs.gtkLibs220; in rec {

    glib = callPackage ../development/libraries/glib/2.24.x.nix {
      libiconv = if stdenv.system == "i686-freebsd" then libiconv else null;
    };

    glibmm = callPackage ../development/libraries/glibmm/2.22.x.nix { };

    atk = callPackage ../development/libraries/atk/1.30.x.nix { };

    pango = callPackage ../development/libraries/pango/1.28.x.nix { };

    pangomm = callPackage ../development/libraries/pangomm/2.26.x.nix { };

    gtk = callPackage ../development/libraries/gtk+/2.20.x.nix { };

    gtkmm = callPackage ../development/libraries/gtkmm/2.18.x.nix { };

  });

  gtkmozembedsharp = callPackage ../development/libraries/gtkmozembed-sharp {
    inherit (gnome) gtk;
    gtksharp = gtksharp2;
  };

  gtksharp1 = callPackage ../development/libraries/gtk-sharp-1 {
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtksharp2 = callPackage ../development/libraries/gtk-sharp-2 {
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf gnomepanel;
  };

  gtksourceviewsharp = callPackage ../development/libraries/gtksourceview-sharp {
    inherit (gnome) gtksourceview;
    gtksharp = gtksharp2;
  };

  gtkspell = callPackage ../development/libraries/gtkspell {
    inherit (gtkLibs) gtk;
  };

  # TODO : Add MIT Kerberos and let admin choose.
  kerberos = heimdal;

  heimdal = callPackage ../development/libraries/kerberos/heimdal.nix { };

  hsqldb = callPackage ../development/libraries/java/hsqldb { };

  hunspell = callPackage ../development/libraries/hunspell { };

  hwloc = callPackage ../development/libraries/hwloc { };

  hydraAntLogger = callPackage ../development/libraries/java/hydra-ant-logger { };

  icu = callPackage ../development/libraries/icu { };

  id3lib = callPackage ../development/libraries/id3lib { };

  ilbc = callPackage ../development/libraries/ilbc { };

  ilmbase = callPackage ../development/libraries/ilmbase { };

  imlib = callPackage ../development/libraries/imlib { };

  imlib2 = callPackage ../development/libraries/imlib2 { };

  indilib = callPackage ../development/libraries/indilib { };

  iniparser = callPackage ../development/libraries/iniparser { };

  intltool = gnome.intltool;

  isocodes = callPackage ../development/libraries/iso-codes { };

  itk = callPackage ../development/libraries/itk { };

  jamp = builderDefsPackage ../games/jamp {
    inherit mesa SDL SDL_image SDL_mixer;
  };

  jasper = callPackage ../development/libraries/jasper { };

  jbig2dec = callPackage ../development/libraries/jbig2dec { };

  jetty_gwt = callPackage ../development/libraries/java/jetty-gwt { };

  jetty_util = callPackage ../development/libraries/java/jetty-util { };

  judy = callPackage ../development/libraries/judy { };

  krb5 = callPackage ../development/libraries/kerberos/krb5.nix { };

  lablgtk = callPackage ../development/libraries/lablgtk {
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnomecanvas;
  };

  lcms = lcms1;

  lcms1 = callPackage ../development/libraries/lcms { };

  lcms2 = callPackage ../development/libraries/lcms2 { };

  lensfun = callPackage ../development/libraries/lensfun {
    inherit (gnome) glib;
  };

  lesstif = callPackage ../development/libraries/lesstif { };

  lesstif93 = callPackage ../development/libraries/lesstif-0.93 { };

  levmar = callPackage ../development/libraries/levmar { };

  lib3ds = callPackage ../development/libraries/lib3ds { };

  libaal = callPackage ../development/libraries/libaal { };

  libao = callPackage ../development/libraries/libao {
    usePulseAudio = getConfig [ "pulseaudio" ] true;
  };

  libarchive = callPackage ../development/libraries/libarchive { };

  libassuan1 = callPackage ../development/libraries/libassuan1 { };

  libassuan = callPackage ../development/libraries/libassuan { };

  libavc1394 = callPackage ../development/libraries/libavc1394 { };

  libcaca = callPackage ../development/libraries/libcaca { };

  libcanberra = callPackage ../development/libraries/libcanberra {
    inherit (gtkLibs) gtk;
    gstreamer = gst_all.gstreamer;
  };

  libcdaudio = callPackage ../development/libraries/libcdaudio { };

  libcddb = callPackage ../development/libraries/libcddb { };

  libcdio = callPackage ../development/libraries/libcdio { };

  libchamplain = callPackage ../development/libraries/libchamplain {
    inherit (gnome) gtk glib libsoup;
  };

  libcm = callPackage ../development/libraries/libcm { };

  libcue = callPackage ../development/libraries/libcue { };

  libcv = builderDefsPackage (import ../development/libraries/libcv) {
    inherit libtiff libjpeg libpng pkgconfig;
    inherit (gtkLibs) gtk glib;
  };

  libdaemon = callPackage ../development/libraries/libdaemon { };

  libdbi = callPackage ../development/libraries/libdbi { };

  libdbiDriversBase = callPackage ../development/libraries/libdbi-drivers {
    mysql = null;
    sqlite = null;
  };

  libdbiDrivers = libdbiDriversBase.override {
    inherit sqlite mysql;
  };

  libdv = callPackage ../development/libraries/libdv { };

  libdrm = if stdenv.isDarwin then null else (import ../development/libraries/libdrm {
    inherit fetchurl stdenv pkgconfig;
    inherit (xorg) libpthreadstubs;
  });

  libdvdcss = callPackage ../development/libraries/libdvdcss { };

  libdvdnav = callPackage ../development/libraries/libdvdnav { };

  libdvdread = callPackage ../development/libraries/libdvdread { };

  libedit = callPackage ../development/libraries/libedit { };

  libelf = callPackage ../development/libraries/libelf { };

  liblo = callPackage ../development/libraries/liblo { };

  libev = builderDefsPackage ../development/libraries/libev {
  };

  libevent = callPackage ../development/libraries/libevent { };

  libewf = callPackage ../development/libraries/libewf { };

  libexif = callPackage ../development/libraries/libexif { };

  libextractor = callPackage ../development/libraries/libextractor {
    inherit (gnome) gtk;
    libmpeg2 = mpeg2dec;
  };

  libffcall = builderDefsPackage (import ../development/libraries/libffcall) {
    inherit fetchcvs;
  };

  libffi = callPackage ../development/libraries/libffi { };

  libftdi = callPackage ../development/libraries/libftdi { };

  libgcrypt = callPackage ../development/libraries/libgcrypt { };

  libgpgerror = callPackage ../development/libraries/libgpg-error { };

  libgphoto2 = callPackage ../development/libraries/libgphoto2 { };

  libgpod = callPackage ../development/libraries/libgpod { };

  libharu = callPackage ../development/libraries/libharu { };

  libical = callPackage ../development/libraries/libical { };

  libiodbc = callPackage ../development/libraries/libiodbc {
    inherit (gtkLibs) gtk;
    useGTK = getPkgConfig "libiodbc" "gtk" false;
  };

  libktorrent = newScope pkgs.kde4 ../development/libraries/libktorrent { };

  liblqr1 = callPackage ../development/libraries/liblqr-1 {
    inherit (gnome) glib;
  };

  libmhash = callPackage ../development/libraries/libmhash {};

  libnice = callPackage ../development/libraries/libnice {
    inherit (gnome) glib;
  };

  libQGLViewer = callPackage ../development/libraries/libqglviewer { };

  libsamplerate = callPackage ../development/libraries/libsamplerate { };

  libspectre = callPackage ../development/libraries/libspectre {
    ghostscript = ghostscriptX;
  };

  libgsf = callPackage ../development/libraries/libgsf {
    inherit (gnome) glib gnomevfs libbonobo;
  };

  libiconv = callPackage ../development/libraries/libiconv { };

  libid3tag = callPackage ../development/libraries/libid3tag { };

  libidn = callPackage ../development/libraries/libidn { };

  libiec61883 = callPackage ../development/libraries/libiec61883 { };

  libinfinity = callPackage ../development/libraries/libinfinity {
    inherit (gtkLibs) gtk glib;
    inherit (gnome) gtkdoc;
  };

  libiptcdata = callPackage ../development/libraries/libiptcdata { };

  libjingle = callPackage ../development/libraries/libjingle/0.3.11.nix { };

  libjpeg = callPackage ../development/libraries/libjpeg { };

  libjpeg_turbo = callPackage ../development/libraries/libjpeg-turbo { };

  libjpeg62 = callPackage ../development/libraries/libjpeg/62.nix {
    libtool = libtool_1_5;
  };

  libksba = callPackage ../development/libraries/libksba { };

  libmad = callPackage ../development/libraries/libmad { };

  libmatchbox = callPackage ../development/libraries/libmatchbox {
    inherit (gtkLibs) pango;
  };

  libmatthew_java = callPackage ../development/libraries/java/libmatthew-java { };

  libmcs = callPackage ../development/libraries/libmcs { };

  libmicrohttpd = callPackage ../development/libraries/libmicrohttpd { };

  libmikmod = callPackage ../development/libraries/libmikmod { };

  libmilter = callPackage ../development/libraries/libmilter { };

  libmowgli = callPackage ../development/libraries/libmowgli { };

  libmng = callPackage ../development/libraries/libmng { };

  libmpcdec = callPackage ../development/libraries/libmpcdec { };

  libmsn = callPackage ../development/libraries/libmsn { };

  libmspack = callPackage ../development/libraries/libmspack { };

  libmusclecard = callPackage ../development/libraries/libmusclecard { };

  libnih = callPackage ../development/libraries/libnih { };

  libnova = callPackage ../development/libraries/libnova { };

  libofx = callPackage ../development/libraries/libofx { };

  libogg = callPackage ../development/libraries/libogg { };

  liboil = callPackage ../development/libraries/liboil { };

  liboop = callPackage ../development/libraries/liboop { };

  libosip = callPackage ../development/libraries/osip {};

  libotr = callPackage ../development/libraries/libotr { };

  libp11 = callPackage ../development/libraries/libp11 { };

  libpcap = callPackage ../development/libraries/libpcap { };

  libpng = callPackage ../development/libraries/libpng { };

  libproxy = callPackage ../development/libraries/libproxy { };

  libpseudo = callPackage ../development/libraries/libpseudo { };

  libqalculate = callPackage ../development/libraries/libqalculate { };

  librsync = callPackage ../development/libraries/librsync { };

  libsigcxx = callPackage ../development/libraries/libsigcxx { };

  libsigcxx12 = callPackage ../development/libraries/libsigcxx/1.2.nix { };

  libsigsegv = callPackage ../development/libraries/libsigsegv { };

  # To bootstrap SBCL, I need CLisp 2.44.1; it needs libsigsegv 2.5
  libsigsegv_25 = callPackage ../development/libraries/libsigsegv/2.5.nix { };

  libsndfile = callPackage ../development/libraries/libsndfile { };

  libssh = callPackage ../development/libraries/libssh { };

  libssh2 = callPackage ../development/libraries/libssh2 { };

  libstartup_notification = callPackage ../development/libraries/startup-notification { };

  libtasn1 = callPackage ../development/libraries/libtasn1 { };

  libtheora = callPackage ../development/libraries/libtheora { };

  libtiff = callPackage ../development/libraries/libtiff { };

  libtommath = callPackage ../development/libraries/libtommath { };

  libgeotiff = callPackage ../development/libraries/libgeotiff { };

  libunistring = callPackage ../development/libraries/libunistring { };

  libupnp = callPackage ../development/libraries/pupnp { };

  giflib = callPackage ../development/libraries/giflib { };

  libungif = callPackage ../development/libraries/giflib/libungif.nix { };

  libusb = callPackage ../development/libraries/libusb { };

  libunwind = callPackage ../development/libraries/libunwind { };

  libv4l = callPackage ../development/libraries/libv4l { };

  libvirt = callPackage ../development/libraries/libvirt { };

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

  libwmf = callPackage ../development/libraries/libwmf { };

  libwpd = callPackage ../development/libraries/libwpd {
    inherit (gnome) glib;
  };

  libx86 = builderDefsPackage ../development/libraries/libx86 {};

  libxcrypt = callPackage ../development/libraries/libxcrypt { };

  libxdg_basedir = callPackage ../development/libraries/libxdg-basedir { };

  libxklavier = callPackage ../development/libraries/libxklavier { };

  libxmi = callPackage ../development/libraries/libxmi { };

  libxml2 = callPackage ../development/libraries/libxml2 {
    pythonSupport = false;
  };

  libxml2Python = libxml2.override {
    pythonSupport = true;
  };

  libxmlxx = callPackage ../development/libraries/libxmlxx {
    inherit (gtkLibs) glibmm;
  };

  libxslt = callPackage ../development/libraries/libxslt { };

  libixp_for_wmii = lowPrio (import ../development/libraries/libixp_for_wmii {
    inherit fetchurl stdenv;
  });

  libyaml = callPackage ../development/libraries/libyaml { };

  libzip = callPackage ../development/libraries/libzip { };

  libzrtpcpp = callPackage ../development/libraries/libzrtpcpp { };

  lightning = callPackage ../development/libraries/lightning { };

  liquidwar = builderDefsPackage ../games/liquidwar {
    inherit (xlibs) xproto libX11 libXrender;
    inherit gmp guile mesa libjpeg libpng
      expat gettext perl
      SDL SDL_image SDL_mixer SDL_ttf
      curl sqlite
      libogg libvorbis
      ;
  };

  log4cxx = callPackage ../development/libraries/log4cxx { };

  loudmouth = callPackage ../development/libraries/loudmouth { };

  lzo = callPackage ../development/libraries/lzo { };

  # failed to build
  mediastreamer = callPackage ../development/libraries/mediastreamer { };

  mesaSupported =
    system == "i686-linux" ||
    system == "x86_64-linux" ||
    system == "x86_64-darwin" ||
    system == "i686-darwin";

  mesa = callPackage ../development/libraries/mesa {
    lipo = if stdenv.isDarwin then darwinLipoUtility else null;
  };

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

  mlt = callPackage ../development/libraries/mlt {
    qt = qt4;
  };

  mpeg2dec = callPackage ../development/libraries/mpeg2dec { };

  msilbc = callPackage ../development/libraries/msilbc { };

  mpc = callPackage ../development/libraries/mpc { };

  mpich2 = callPackage ../development/libraries/mpich2 { };

  muparser = callPackage ../development/libraries/muparser { };

  ncurses = makeOverridable (import ../development/libraries/ncurses) {
    inherit fetchurl stdenv;
    # The "! (stdenv ? cross)" is for the cross-built arm ncurses, which
    # don't build for me in unicode.
    unicode = (system != "i686-cygwin" && crossSystem == null);
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

  nspr = callPackage ../development/libraries/nspr { };

  nss = callPackage ../development/libraries/nss { };

  nssTools = callPackage ../development/libraries/nss {
    includeTools = true;
  };

  ode = builderDefsPackage (import ../development/libraries/ode) {
  };

  openal = callPackage ../development/libraries/openal { };

  # added because I hope that it has been easier to compile on x86 (for blender)
  openalSoft = callPackage ../development/libraries/openal-soft { };

  openbabel = callPackage ../development/libraries/openbabel { };

  opencascade = callPackage ../development/libraries/opencascade { };

  openct = callPackage ../development/libraries/openct { };

  opencv = callPackage ../development/libraries/opencv {
      inherit (gtkLibs) gtk glib;
      inherit (gst_all) gstreamer;
      stdenv = stdenv2;
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
    inherit (gtkLibs) glib;
    opensc = opensc_0_11_7;
  };

  opal = callPackage ../development/libraries/opal {};

  openjpeg = callPackage ../development/libraries/openjpeg { };

  openssl = callPackage ../development/libraries/openssl {
    fetchurl = fetchurlBoot;
  };

  ortp = callPackage ../development/libraries/ortp { };

  pangoxsl = callPackage ../development/libraries/pangoxsl {
    inherit (gtkLibs) glib pango;
  };

  pcre = callPackage ../development/libraries/pcre {
    unicodeSupport = getConfig ["pcre" "unicode"] false;
    cplusplusSupport = !stdenv ? isDietLibC;
  };

  pdf2xml = callPackage ../development/libraries/pdf2xml {} ;

  phonon_backend_vlc = newScope pkgs.kde4 ../development/libraries/phonon-backend-vlc { };

  physfs = callPackage ../development/libraries/physfs { };

  plib = callPackage ../development/libraries/plib { };

  podofo = callPackage ../development/libraries/podofo { };

  polkit = callPackage ../development/libraries/polkit { };

  policykit = callPackage ../development/libraries/policykit { };

  poppler = callPackage ../development/libraries/poppler {
    inherit (gtkLibs) glib gtk;
    qt4Support = false;
  };

  popplerQt4 = poppler.override {
    inherit qt4;
    qt4Support = true;
  };

  popt = callPackage ../development/libraries/popt { };

  portaudio = callPackage ../development/libraries/portaudio { };

  proj = callPackage ../development/libraries/proj { };

  postgis = callPackage ../development/libraries/postgis { };

  pth = callPackage ../development/libraries/pth { };

  ptlib = callPackage ../development/libraries/ptlib {};

  qjson = callPackage ../development/libraries/qjson { };

  qt3 = callPackage ../development/libraries/qt-3 {
    openglSupport = mesaSupported;
    mysqlSupport = getConfig ["qt" "mysql"] false;
  };

  qt3mysql = qt3.override {
    mysqlSupport = true;
  };

  qt4 = qt46;

  qt45 = callPackage ../development/libraries/qt-4.x/4.5 {
    inherit (gnome) glib;
  };

  qt46 = callPackage ../development/libraries/qt-4.x/4.6 {
    inherit (gnome) glib;
  };

  qt47 = callPackage ../development/libraries/qt-4.x/4.7 {
    inherit (pkgs.gst_all) gstreamer gstPluginsBase;
    inherit (pkgs.gnome) glib;
  };

  qtscriptgenerator = callPackage ../development/libraries/qtscriptgenerator { };

  quassel = newScope pkgs.kde4 ../applications/networking/irc/quassel { };

  quesoglc = callPackage ../development/libraries/quesoglc { };

  readline = readline6;

  readline4 = callPackage ../development/libraries/readline/readline4.nix { };

  readline5 = callPackage ../development/libraries/readline/readline5.nix { };

  readline6 = callPackage ../development/libraries/readline/readline6.nix { };

  librdf_raptor = callPackage ../development/libraries/librdf/raptor.nix { };

  librdf_rasqal = callPackage ../development/libraries/librdf/rasqal.nix { };

  librdf = callPackage ../development/libraries/librdf { };

  qrupdate = callPackage ../development/libraries/qrupdate { };

  redland = callPackage ../development/libraries/redland/1.0.10.nix {
    bdb = db4;
    postgresql = null;
  };

  rhino = callPackage ../development/libraries/java/rhino {
    ant = apacheAntGcj;
    javac = gcj;
    jvm = gcj;
  };

  rte = callPackage ../development/libraries/rte { };

  rubberband = callPackage ../development/libraries/rubberband {
    fftw = fftwSinglePrec;
    inherit (vamp) vampSDK;
  };

  schroedinger = callPackage ../development/libraries/schroedinger { };

  SDL = callPackage ../development/libraries/SDL {
    openglSupport = mesaSupported;
    alsaSupport = true;
    pulseaudioSupport = false; # better go through ALSA
  };

  SDL_gfx = callPackage ../development/libraries/SDL_gfx { };

  SDL_image = callPackage ../development/libraries/SDL_image { };

  SDL_mixer = callPackage ../development/libraries/SDL_mixer { };

  SDL_net = callPackage ../development/libraries/SDL_net { };

  SDL_sound = callPackage ../development/libraries/SDL_sound { };

  SDL_ttf = callPackage ../development/libraries/SDL_ttf { };

  slang = callPackage ../development/libraries/slang { };

  slibGuile = callPackage ../development/libraries/slib {
    scheme = guile;
  };

  snack = callPackage ../development/libraries/snack {
        # optional
  };

  speex = callPackage ../development/libraries/speex { };

  srtp = callPackage ../development/libraries/srtp {};

  sqlite = callPackage ../development/libraries/sqlite {
    readline = null;
    ncurses = null;
  };

  sqlite36 = callPackage ../development/libraries/sqlite/3.6.x.nix {
    readline = null;
    ncurses = null;
  };

  sqliteInteractive = appendToName "interactive" (sqlite.override {
    inherit readline ncurses;
  });

  stlport = callPackage ../development/libraries/stlport { };

  suitesparse = callPackage ../development/libraries/suitesparse { };

  t1lib = callPackage ../development/libraries/t1lib { };

  taglib = callPackage ../development/libraries/taglib { };

  taglib_extras = callPackage ../development/libraries/taglib-extras { };

  talloc = callPackage ../development/libraries/talloc { };

##  tapioca_qt = import ../development/libraries/tapioca-qt {
##    inherit stdenv fetchurl cmake qt4 telepathy_qt;
##  };

  tdb = callPackage ../development/libraries/tdb { };

  tecla = callPackage ../development/libraries/tecla { };

  telepathy_gabble = callPackage ../development/libraries/telepathy-gabble { };

  telepathy_glib = callPackage ../development/libraries/telepathy-glib { };

  telepathy_qt = callPackage ../development/libraries/telepathy-qt { };

  tk = callPackage ../development/libraries/tk { };

  unixODBC = callPackage ../development/libraries/unixODBC { };

  unixODBCDrivers = recurseIntoAttrs (import ../development/libraries/unixODBCDrivers {
    inherit fetchurl stdenv unixODBC glibc libtool openssl zlib;
    inherit postgresql mysql sqlite;
  });

  vamp = callPackage ../development/libraries/audio/vamp { };

  vigra = callPackage ../development/libraries/vigra { };

  vtk = callPackage ../development/libraries/vtk { };

  vxl = callPackage ../development/libraries/vxl { };

  webkit = ((builderDefsPackage ../development/libraries/webkit {
    inherit (gnome28) gtkdoc libsoup;
    inherit (gtkLibs) gtk atk pango glib;
    inherit freetype fontconfig gettext gperf curl
      libjpeg libtiff libpng libxml2 libxslt sqlite
      icu cairo perl intltool automake libtool
      pkgconfig autoconf bison libproxy enchant
      python ruby;
    inherit (gst_all) gstreamer gstPluginsBase gstFfmpeg
      gstPluginsGood;
    flex = flex2535;
    inherit (xlibs) libXt;
  }).deepOverride {libsoup = gnome28.libsoup_2_31;});

  wvstreams = callPackage ../development/libraries/wvstreams { };

  wxGTK = wxGTK28;

  wxGTK26 = callPackage ../development/libraries/wxGTK-2.6 {
    inherit (gtkLibs216) gtk;
  };

  wxGTK28 = callPackage ../development/libraries/wxGTK-2.8 {
    inherit (gtkLibs216) gtk;
  };

  wtk = callPackage ../development/libraries/wtk { };

  x264 = callPackage ../development/libraries/x264 { };

  xapian = callPackage ../development/libraries/xapian { };

  xapianBindings = callPackage ../development/libraries/xapian/bindings {  # TODO perl php Java, tcl, C#, python
  };

  Xaw3d = callPackage ../development/libraries/Xaw3d {
    flex = flex2533;
  };

  xineLib = callPackage ../development/libraries/xine-lib { };

  xautolock = callPackage ../misc/screensavers/xautolock { };

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

  xvidcore = callPackage ../development/libraries/xvidcore { };

  zangband = builderDefsPackage (import ../games/zangband) {
    inherit ncurses flex bison autoconf automake m4 coreutils;
  };

  zlib = callPackage ../development/libraries/zlib {
    fetchurl = fetchurlBoot;
  };

  zlibStatic = lowPrio (appendToName "static" (import ../development/libraries/zlib {
    inherit fetchurl stdenv;
    static = true;
  }));

  zvbi = callPackage ../development/libraries/zvbi {
    pngSupport = true;
  };


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

  jclasslib = callPackage ../development/tools/java/jclasslib {
    ant = apacheAnt14;
  };

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
    inherit (gtkLibs) gtk;
  };

  xalanj = xalanJava;
  xalanJava = callPackage ../development/libraries/java/xalanj {
    ant    = apacheAntGcj;  # for bootstrap purposes
    javac  = gcj;
    jvm    = gcj;
    xerces = xercesJava;  };

  zziplib = callPackage ../development/libraries/zziplib { };


  ### DEVELOPMENT / PERL MODULES

  buildPerlPackage = import ../development/perl-modules/generic perl;

  perlPackages = recurseIntoAttrs (import ./perl-packages.nix {
    inherit pkgs;
  });

  perlXMLParser = perlPackages.XMLParser;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;


  ### DEVELOPMENT / PYTHON MODULES

  buildPythonPackage = import ../development/python-modules/generic {
    inherit python setuptools makeWrapper lib;
  };

  buildPython26Package = import ../development/python-modules/generic {
    inherit makeWrapper lib;
    python = python26;
    setuptools = setuptools.override { python = python26; };
  };

  buildPython27Package = import ../development/python-modules/generic {
    inherit makeWrapper lib;
    python = python27;
    setuptools = setuptools.override { python = python27; doCheck = false; };
  };

  pythonPackages = python26Packages;

  python26Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    python = python26;
    buildPythonPackage = buildPython26Package;
  });

  python27Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    python = python27;
    buildPythonPackage = buildPython27Package;
  });

  foursuite = callPackage ../development/python-modules/4suite { };

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  flup = builderDefsPackage ../development/python-modules/flup {
    inherit fetchurl stdenv python setuptools;
  };

  numeric = callPackage ../development/python-modules/numeric { };

  pil = callPackage ../development/python-modules/pil { };

  psyco = callPackage ../development/python-modules/psyco { };

  pycairo = callPackage ../development/python-modules/pycairo { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycups = callPackage ../development/python-modules/pycups { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygobject = callPackage ../development/python-modules/pygobject { };

  pygtk = callPackage ../development/python-modules/pygtk {
    inherit (gtkLibs) glib gtk;
  };

  pyGtkGlade = callPackage ../development/python-modules/pygtk {
    inherit (gtkLibs) glib gtk;
    inherit (gnome) libglade;
  };

  pyopenssl = builderDefsPackage (import ../development/python-modules/pyopenssl) {
    inherit python openssl;
  };

  rhpl = callPackage ../development/python-modules/rhpl { };

  sip = callPackage ../development/python-modules/python-sip { };

  pyqt4 = callPackage ../development/python-modules/pyqt { };

  pyx = callPackage ../development/python-modules/pyx { };

  pyxml = callPackage ../development/python-modules/pyxml { };

  setuptools = builderDefsPackage (import ../development/python-modules/setuptools) {
    inherit python makeWrapper;
  };

  wxPython = wxPython26;

  wxPython26 = callPackage ../development/python-modules/wxPython/2.6.nix {
    wxGTK = wxGTK26;
  };

  wxPython28 = callPackage ../development/python-modules/wxPython/2.8.nix { };

  twisted = pythonPackages.twisted;

  ZopeInterface = pythonPackages.zopeInterface;

  zope = callPackage ../development/python-modules/zope {
    python = python24;
  };

  ### SERVERS

  rdf4store = callPackage ../servers/http/4store {
    inherit (gtkLibs) glib;
  };

  apacheHttpd = callPackage ../servers/http/apache-httpd {
    sslSupport = true;
  };

  sabnzbd = callPackage ../servers/sabnzbd { };

  bind = builderDefsPackage (import ../servers/dns/bind/9.5.0.nix) {
    inherit openssl libtool;
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
  dovecot_1_1_1 = callPackage ../servers/mail/dovecot/1.1.1.nix { };

  ejabberd = callPackage ../servers/xmpp/ejabberd {
    erlang = erlangR13B ;
  };

  couchdb = callPackage ../servers/http/couchdb { };

  felix = callPackage ../servers/felix { };

  felix_remoteshell = callPackage ../servers/felix/remoteshell.nix { };

  fingerd_bsd = callPackage ../servers/fingerd/bsd-fingerd { };

  firebird = callPackage ../servers/firebird { };

  ircdHybrid = callPackage ../servers/irc/ircd-hybrid { };

  jboss = callPackage ../servers/http/jboss { };

  jboss_mysql_jdbc = callPackage ../servers/http/jboss/jdbc/mysql { };

  jetty = callPackage ../servers/http/jetty { };

  jetty61 = callPackage ../servers/http/jetty/6.1 { };

  lighttpd = callPackage ../servers/http/lighttpd { };

  mod_python = callPackage ../servers/http/apache-modules/mod_python { };

  mpd = callPackage ../servers/mpd { };

  myserver = callPackage ../servers/http/myserver { };

  nginx = builderDefsPackage (import ../servers/http/nginx) {
    inherit openssl pcre zlib libxml2 libxslt;
  };

  postfix = callPackage ../servers/mail/postfix { };

  pulseaudio = callPackage ../servers/pulseaudio {
    inherit (gtkLibs) gtk glib;    # Needs ALSA >= 1.0.17.
    gconf = gnome.GConf;
  };

  tomcat_connectors = callPackage ../servers/http/apache-modules/tomcat-connectors { };

  portmap = callPackage ../servers/portmap { };

  monetdb = callPackage ../servers/sql/monetdb { };

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

  mysql = mysql5;

  mysql_jdbc = callPackage ../servers/sql/mysql/jdbc { };

  nagios = callPackage ../servers/monitoring/nagios {
    gdSupport = true;
  };

  nagiosPluginsOfficial = callPackage ../servers/monitoring/nagios/plugins/official { };

  openfire = callPackage ../servers/xmpp/openfire { };

  postgresql = postgresql83;

  postgresql83 = callPackage ../servers/sql/postgresql/8.3.x.nix { };

  postgresql84 = callPackage ../servers/sql/postgresql/8.4.x.nix { };

  postgresql_jdbc = callPackage ../servers/sql/postgresql/jdbc { };

  pyIRCt = builderDefsPackage (import ../servers/xmpp/pyIRCt) {
    inherit xmpppy pythonIRClib python makeWrapper;
  };

  pyMAILt = builderDefsPackage (import ../servers/xmpp/pyMAILt) {
    inherit xmpppy python makeWrapper fetchcvs;
  };

  radius = callPackage ../servers/radius { };

  redstore = callPackage ../servers/http/redstore { };

  samba = callPackage ../servers/samba { };

  shishi = callPackage ../servers/shishi { };

  squids = recurseIntoAttrs( import ../servers/squid/squids.nix {
    inherit fetchurl stdenv perl lib composableDerivation;
  });
  squid = squids.squid3Beta; # has ipv6 support

  tomcat5 = callPackage ../servers/http/tomcat { };

  tomcat6 = callPackage ../servers/http/tomcat/6.0.nix { };

  tomcat_mysql_jdbc = callPackage ../servers/http/tomcat/jdbc/mysql { };

  axis2 = callPackage ../servers/http/tomcat/axis2 { };

  virtuoso = callPackage ../servers/sql/virtuoso { };

  vsftpd = callPackage ../servers/ftp/vsftpd { };

  xinetd = callPackage ../servers/xinetd { };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg/default.nix {
    inherit fetchurl fetchsvn stdenv pkgconfig freetype fontconfig
      libxslt expat libdrm libpng zlib perl mesa
      xkeyboard_config dbus hal libuuid openssl gperf m4
      automake autoconf libtool xmlto asciidoc udev;

    # !!! pythonBase is used instead of python because this causes an
    # infinite recursion when the flag python.full is set to true.
    # Packages contained in the loop are python, tk, xlibs-wrapper,
    # libX11, libxcd (and xcb-proto).
    python = pythonBase;
  });

  xorgReplacements = callPackage ../servers/x11/xorg/replacements.nix { };

  xorgVideoUnichrome = callPackage ../servers/x11/xorg/unichrome/default.nix { };

  zabbix = recurseIntoAttrs (import ../servers/monitoring/zabbix {
    inherit fetchurl stdenv pkgconfig postgresql curl openssl zlib;
  });


  ### OS-SPECIFIC

  afuse = callPackage ../os-specific/linux/afuse { };

  autofs5 = callPackage ../os-specific/linux/autofs/autofs-v5.nix { };

  _915resolution = callPackage ../os-specific/linux/915resolution { };

  nfsUtils = callPackage ../os-specific/linux/nfs-utils { };

  acpi = callPackage ../os-specific/linux/acpi { };

  acpid = callPackage ../os-specific/linux/acpid { };

  acpitool = callPackage ../os-specific/linux/acpitool { };

  alsaLib = callPackage ../os-specific/linux/alsa-lib { };

  alsaPlugins = callPackage ../os-specific/linux/alsa-plugins { };
  alsaPluginWrapper = callPackage ../os-specific/linux/alsa-plugins/wrapper.nix { };

  alsaUtils = callPackage ../os-specific/linux/alsa-utils { };

  bluez = callPackage ../os-specific/linux/bluez { };

  bridge_utils = callPackage ../os-specific/linux/bridge_utils { };

  cifs_utils = callPackage ../os-specific/linux/cifs-utils { };

  conky = callPackage ../os-specific/linux/conky {
    inherit (gtkLibs) glib;
  };

  cpufrequtils = (
    import ../os-specific/linux/cpufrequtils {
    inherit fetchurl stdenv libtool gettext;
    glibc = stdenv.gcc.libc;
    linuxHeaders = stdenv.gcc.libc.kernelHeaders;
  });

  cryopid = callPackage ../os-specific/linux/cryopid { };

  cryptsetup = callPackage ../os-specific/linux/cryptsetup { };

  cramfsswap = callPackage ../os-specific/linux/cramfsswap { };

  darwinArchUtility = callPackage ../os-specific/darwin/arch { };

  darwinSwVersUtility = callPackage ../os-specific/darwin/sw_vers { };

  darwinLipoUtility = callPackage ../os-specific/darwin/lipo { };

  devicemapper = lvm2;

  dmidecode = callPackage ../os-specific/linux/dmidecode { };

  dmtcp = callPackage ../os-specific/linux/dmtcp { };

  dietlibc = callPackage ../os-specific/linux/dietlibc {
    # Dietlibc 0.30 doesn't compile on PPC with GCC 4.1, bus GCC 3.4 works.
    stdenv = if stdenv.system == "powerpc-linux" then overrideGCC stdenv gcc34 else stdenv;
  };

  directvnc = builderDefsPackage ../os-specific/linux/directvnc {
    inherit libjpeg pkgconfig zlib directfb;
    inherit (xlibs) xproto;
  };

  dmraid = builderDefsPackage ../os-specific/linux/dmraid {
    inherit devicemapper;
  };

  libuuid =
    if crossSystem != null && crossSystem.config == "i586-pc-gnu"
    then (utillinuxng // {
      hostDrv = lib.overrideDerivation utillinuxng.hostDrv (args: {
        # `libblkid' fails to build on GNU/Hurd.
        configureFlags = args.configureFlags
          + " --disable-libblkid --disable-mount --disable-fsck"
          + " --enable-static";
        doCheck = false;
        CPPFLAGS =                    # ugly hack for ugly software!
          lib.concatStringsSep " "
            (map (v: "-D${v}=4096")
                 [ "PATH_MAX" "MAXPATHLEN" "MAXHOSTNAMELEN" ]);
      });
    })
    else if stdenv.isLinux
    then utillinuxng
    else null;

  e3cfsprogs = callPackage ../os-specific/linux/e3cfsprogs { };

  eject = callPackage ../os-specific/linux/eject { };

  fbterm = builderDefsPackage (import ../os-specific/linux/fbterm) {
    inherit fontconfig gpm freetype pkgconfig ncurses;
  };

  fuse = callPackage ../os-specific/linux/fuse { };

  fxload = callPackage ../os-specific/linux/fxload { };

  gpm = callPackage ../servers/gpm {
    flex = flex2535;
  };

  hal = callPackage ../os-specific/linux/hal { };

  halevt = callPackage ../os-specific/linux/hal/hal-evt.nix { };

  hal_info = callPackage ../os-specific/linux/hal/info.nix { };

  hal_info_synaptics = callPackage ../os-specific/linux/hal/synaptics.nix { };

  hdparm = callPackage ../os-specific/linux/hdparm { };

  hibernate = callPackage ../os-specific/linux/hibernate { };

  htop = callPackage ../os-specific/linux/htop { };

  hurdCross = forceBuildDrv(import ../os-specific/gnu/hurd {
    inherit fetchgit stdenv autoconf libtool texinfo machHeaders
      mig glibcCross;
    automake = automake111x;
    headersOnly = false;
    cross = assert crossSystem != null; crossSystem;
    gccCross = gccCrossStageFinal;
  });

  hurdCrossIntermediate = forceBuildDrv(import ../os-specific/gnu/hurd {
    inherit fetchgit stdenv autoconf libtool texinfo machHeaders
      mig glibcCross;
    automake = automake111x;
    headersOnly = false;
    cross = assert crossSystem != null; crossSystem;

    # The "final" GCC needs glibc and the Hurd libraries (libpthread in
    # particular) so we first need an intermediate Hurd built with the
    # intermediate GCC.
    gccCross = gccCrossStageStatic;

    # This intermediate Hurd is only needed to build libpthread, which really
    # only needs libihash.
    buildTarget = "libihash";
    installTarget = "libihash-install";
  });

  hurdHeaders = callPackage ../os-specific/gnu/hurd {
    automake = automake111x;
    headersOnly = true;
    gccCross = null;
    glibcCross = null;
  };

  hurdLibpthreadCross = forceBuildDrv(import ../os-specific/gnu/libpthread {
    inherit fetchgit stdenv autoconf automake libtool
      machHeaders hurdHeaders glibcCross;
    hurd = hurdCrossIntermediate;
    gccCross = gccCrossStageStatic;
    cross = assert crossSystem != null; crossSystem;
  });

  hwdata = callPackage ../os-specific/linux/hwdata { };

  ifplugd = callPackage ../os-specific/linux/ifplugd { };

  iproute = callPackage ../os-specific/linux/iproute { };

  iputils = (
    import ../os-specific/linux/iputils {
    inherit fetchurl stdenv;
    glibc = stdenv.gcc.libc;
    linuxHeaders = stdenv.gcc.libc.kernelHeaders;
  });

  iptables = callPackage ../os-specific/linux/iptables { };

  ipw2200fw = callPackage ../os-specific/linux/firmware/ipw2200 { };

  iwlwifi1000ucode = callPackage ../os-specific/linux/firmware/iwlwifi-1000-ucode { };

  iwlwifi3945ucode = callPackage ../os-specific/linux/firmware/iwlwifi-3945-ucode { };

  iwlwifi4965ucodeV1 = callPackage ../os-specific/linux/firmware/iwlwifi-4965-ucode { };

  iwlwifi4965ucodeV2 = callPackage ../os-specific/linux/firmware/iwlwifi-4965-ucode/version-2.nix { };

  iwlwifi5000ucode = callPackage ../os-specific/linux/firmware/iwlwifi-5000-ucode { };

  kbd = callPackage ../os-specific/linux/kbd { };

  libcroup = callPackage ../os-specific/linux/libcg { };

  linuxHeaders = linuxHeaders_2_6_28;

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

  linuxHeaders_2_6_18 = callPackage ../os-specific/linux/kernel-headers/2.6.18.5.nix { };

  linuxHeaders_2_6_28 = callPackage ../os-specific/linux/kernel-headers/2.6.28.nix { };

  linuxHeaders_2_6_32 = callPackage ../os-specific/linux/kernel-headers/2.6.32.nix { };

  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  linux_2_6_25 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.25.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_25
        kernelPatches.sec_perm_2_6_24
      ];
  };

  linux_2_6_27 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.27.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_27
        kernelPatches.sec_perm_2_6_24
      ];
  };

  linux_2_6_28 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.28.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_28
        kernelPatches.sec_perm_2_6_24
        kernelPatches.ext4_softlockups_2_6_28
      ];
  };

  linux_2_6_29 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.29.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_29
        kernelPatches.sec_perm_2_6_24
      ];
  };

  linux_2_6_31 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.31.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools platform;
    kernelPatches = [];
  };

  linux_2_6_32 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.32.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_31
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs2_2_6_32
        kernelPatches.cifs_timeout
        kernelPatches.no_xsave
        kernelPatches.dell_rfkill
      ];
  };

  linux_2_6_32_systemtap = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.32.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    systemtap = true;
    dontStrip = true;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_31
        kernelPatches.sec_perm_2_6_24
        kernelPatches.tracehook_2_6_32
        kernelPatches.utrace_2_6_32
      ];
  };

  linux_2_6_32_zen4 = makeOverridable (import ../os-specific/linux/zen-kernel/2.6.32-zen4.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools runCommand xz;
  };

  linux_2_6_32_zen4_oldi686 = linux_2_6_32_zen4.override {
    features = {
      oldI686 = true;
    };
  };

  linux_2_6_32_zen4_bfs = linux_2_6_32_zen4.override {
    features = {
      ckSched = true;
    };
  };

  linux_2_6_33 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.33.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ kernelPatches.fbcondecor_2_6_33
        kernelPatches.sec_perm_2_6_24
      ];
  };

  linux_2_6_33_zen1 = makeOverridable (import ../os-specific/linux/zen-kernel/2.6.33-zen1.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools runCommand xz;
  };

  linux_2_6_33_zen1_oldi686 = linux_2_6_33_zen1.override {
    features = {
      oldI686 = true;
    };
  };

  linux_2_6_33_zen1_bfs = linux_2_6_33_zen1.override {
    features = {
      ckSched = true;
    };
  };

  linux_2_6_34 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.34.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ /*kernelPatches.fbcondecor_2_6_33*/
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs2_2_6_34
      ];
  };

  linux_2_6_35 = makeOverridable (import ../os-specific/linux/kernel/linux-2.6.35.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools ubootChooser;
    kernelPatches =
      [ #kernelPatches.fbcondecor_2_6_35
        kernelPatches.sec_perm_2_6_24
        kernelPatches.aufs2_2_6_35
      ];
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

  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: self: let callPackage = newScope self; in rec {

    inherit kernel;

    ati_drivers_x11 = callPackage ../os-specific/linux/ati-drivers { };

    aufs = callPackage ../os-specific/linux/aufs { };

    aufs2 = callPackage ../os-specific/linux/aufs2 { };

    aufs2_util = callPackage ../os-specific/linux/aufs2-util { };

    blcr = callPackage ../os-specific/linux/blcr {
      #libtool = libtool_1_5; # libtool 2 causes a fork bomb
    };

    exmap = callPackage ../os-specific/linux/exmap {
      inherit (gtkLibs) gtkmm;
    };

    iscsitarget = callPackage ../os-specific/linux/iscsitarget { };

    iwlwifi = callPackage ../os-specific/linux/iwlwifi { };

    iwlwifi4965ucode =
      (if (builtins.compareVersions kernel.version "2.6.27" == 0)
          || (builtins.compareVersions kernel.version "2.6.27" == 1)
       then iwlwifi4965ucodeV2
       else iwlwifi4965ucodeV1);

    atheros = callPackage ../os-specific/linux/atheros/0.9.4.nix { };

    nvidia_x11 = callPackage ../os-specific/linux/nvidia-x11 { };

    nvidia_x11_legacy96 = callPackage ../os-specific/linux/nvidia-x11/legacy96.nix { };
    nvidia_x11_legacy173 = callPackage ../os-specific/linux/nvidia-x11/legacy173.nix { };

    openafsClient = callPackage ../servers/openafs-client { };
    
    openiscsi = callPackage ../os-specific/linux/open-iscsi { };

    wis_go7007 = callPackage ../os-specific/linux/wis-go7007 { };

    kqemu = builderDefsPackage ../os-specific/linux/kqemu/1.4.0pre1.nix {
      inherit kernel perl;
    };

    splashutils =
      if kernel.features ? fbConDecor then pkgs.splashutils else null;

    ext3cowtools = callPackage ../os-specific/linux/ext3cow-tools {
      kernel_ext3cowpatched = kernel;
    };

    /* compiles but has to be integrated into the kernel somehow
      Let's have it uncommented and finish it..
    */
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    ov511 = callPackage ../os-specific/linux/ov511 {
      stdenv = overrideGCC stdenv gcc34;
    };

    # State Nix
    snix = callPackage ../tools/package-management/snix {

      aterm = aterm25;
      db4 = db45;

      flex = flex2533;
      ext3cow_kernel = kernel;    };

    sysprof = callPackage ../development/tools/profiling/sysprof {
      inherit (gnome) gtk glib pango libglade;
    };

    systemtap = callPackage ../development/tools/profiling/systemtap {
      linux = kernel;
      inherit (gnome) gtkmm libglademm;
    };

    virtualbox = callPackage ../applications/virtualization/virtualbox {
      stdenv = stdenv_32bit;
      inherit (gnome) libIDL;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions { };
  };

  # Build the kernel modules for the some of the kernels.
  linuxPackages_2_6_25 = recurseIntoAttrs (linuxPackagesFor linux_2_6_25 pkgs.linuxPackages_2_6_25);
  linuxPackages_2_6_27 = recurseIntoAttrs (linuxPackagesFor linux_2_6_27 pkgs.linuxPackages_2_6_27);
  linuxPackages_2_6_28 = recurseIntoAttrs (linuxPackagesFor linux_2_6_28 pkgs.linuxPackages_2_6_28);
  linuxPackages_2_6_29 = recurseIntoAttrs (linuxPackagesFor linux_2_6_29 pkgs.linuxPackages_2_6_29);
  linuxPackages_2_6_31 = recurseIntoAttrs (linuxPackagesFor linux_2_6_31 pkgs.linuxPackages_2_6_31);
  linuxPackages_2_6_32 = recurseIntoAttrs (linuxPackagesFor linux_2_6_32 pkgs.linuxPackages_2_6_32);
  linuxPackages_2_6_32_systemtap =
    recurseIntoAttrs (linuxPackagesFor linux_2_6_32_systemtap pkgs.linuxPackages_2_6_32_systemtap);
  linuxPackages_2_6_33 = recurseIntoAttrs (linuxPackagesFor linux_2_6_33 pkgs.linuxPackages_2_6_33);
  linuxPackages_2_6_34 = recurseIntoAttrs (linuxPackagesFor linux_2_6_34 pkgs.linuxPackages_2_6_34);
  linuxPackages_2_6_35 = recurseIntoAttrs (linuxPackagesFor linux_2_6_35 pkgs.linuxPackages_2_6_35);

  # The current default kernel / kernel modules.
  linux = linux_2_6_32;
  linuxPackages = linuxPackages_2_6_32;

  keyutils = callPackage ../os-specific/linux/keyutils { };

  libselinux = callPackage ../os-specific/linux/libselinux { };

  libraw1394 = callPackage ../development/libraries/libraw1394 { };

  libsexy = callPackage ../development/libraries/libsexy {
    inherit (gtkLibs) glib gtk pango;
  };

  librsvg = gnome.librsvg;

  libsepol = callPackage ../os-specific/linux/libsepol { };

  libsmbios = callPackage ../os-specific/linux/libsmbios { };

  lm_sensors = callPackage ../os-specific/linux/lm_sensors { };

  lsiutil = callPackage ../os-specific/linux/lsiutil { };

  klibc = callPackage ../os-specific/linux/klibc {
    linuxHeaders = glibc.kernelHeaders;
  };

  klibcShrunk = callPackage ../os-specific/linux/klibc/shrunk.nix { };

  kvm = qemu_kvm;

  libcap = callPackage ../os-specific/linux/libcap { };

  libnscd = callPackage ../os-specific/linux/libnscd { };

  libnotify = callPackage ../development/libraries/libnotify {
    inherit (gtkLibs) gtk glib;
  };

  libvolume_id = callPackage ../os-specific/linux/libvolume_id { };

  lvm2 = callPackage ../os-specific/linux/lvm2 { };

  # In theory GNU Mach doesn't have to be cross-compiled.  However, since it
  # has to be built for i586 (it doesn't work on x86_64), one needs a cross
  # compiler for that host.
  mach = callPackage ../os-specific/gnu/mach {
    automake = automake111x;  };

  machHeaders = callPackage ../os-specific/gnu/mach {
    automake = automake111x;
    headersOnly = true;
    mig = null;
  };

  mdadm = callPackage ../os-specific/linux/mdadm { };

  mingetty = callPackage ../os-specific/linux/mingetty { };

  module_init_tools = callPackage ../os-specific/linux/module-init-tools { };

  mountall = callPackage ../os-specific/linux/mountall {
    automake = automake111x;
  };

  aggregateModules = modules:
    import ../os-specific/linux/module-init-tools/aggregator.nix {
      inherit stdenv module_init_tools modules buildEnv;
    };

  modutils = callPackage ../os-specific/linux/modutils {
    stdenv = overrideGCC stdenv gcc34;
  };

  nettools = callPackage ../os-specific/linux/net-tools { };

  neverball = callPackage ../games/neverball { };

  numactl = callPackage ../os-specific/linux/numactl { };

  gw6c = builderDefsPackage (import ../os-specific/linux/gw6c) {
    inherit fetchurl stdenv nettools openssl procps iproute;
  };

  nss_ldap = callPackage ../os-specific/linux/nss_ldap { };

  pam = callPackage ../os-specific/linux/pam { };

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_ccreds = callPackage ../os-specific/linux/pam_ccreds {
    db = db4;
  };

  pam_console = callPackage ../os-specific/linux/pam_console {
    libtool = libtool_1_5;
    flex = if stdenv.system == "i686-linux" then flex else flex2533;
  };

  pam_devperm = callPackage ../os-specific/linux/pam_devperm { };

  pam_krb5 = callPackage ../os-specific/linux/pam_krb5 { };

  pam_ldap = callPackage ../os-specific/linux/pam_ldap { };

  pam_login = callPackage ../os-specific/linux/pam_login { };

  pam_unix2 = callPackage ../os-specific/linux/pam_unix2 { };

  pam_usb = callPackage ../os-specific/linux/pam_usb { };

  pcmciaUtils = callPackage ../os-specific/linux/pcmciautils {
    firmware = getConfig ["pcmciaUtils" "firmware"] [];
    config = getConfig ["pcmciaUtils" "config"] null;
  };

  pmount = callPackage ../os-specific/linux/pmount { };

  pmutils = callPackage ../os-specific/linux/pm-utils { };

  powertop = callPackage ../os-specific/linux/powertop { };

  procps = callPackage ../os-specific/linux/procps { };

  pwdutils = callPackage ../os-specific/linux/pwdutils { };

  qemu_kvm = callPackage ../os-specific/linux/qemu-kvm { };

  radeontools = callPackage ../os-specific/linux/radeontools { };

  rfkill = callPackage ../os-specific/linux/rfkill { };

  rt2870fw = callPackage ../os-specific/linux/firmware/rt2870 { };

  rt73fw = callPackage ../os-specific/linux/firmware/rt73 { };

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

  sysvinit = callPackage ../os-specific/linux/sysvinit { };

  sysvtools = callPackage ../os-specific/linux/sysvinit {
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcpWrapper = callPackage ../os-specific/linux/tcp-wrapper { };

  trackballs = callPackage ../games/trackballs {
    debug = false;
  };

  tunctl = callPackage ../os-specific/linux/tunctl { };

  /*tuxracer = builderDefsPackage (import ../games/tuxracer) {
    inherit mesa tcl freeglut;
    inherit (xlibs) libX11 xproto;
  };*/

  ubootChooser = name : if (name == "upstream") then ubootUpstream
    else if (name == "sheevaplug") then ubootSheevaplug
    else throw "Unknown uboot";

  ubootUpstream = callPackage ../misc/uboot { };

  ubootSheevaplug = callPackage ../misc/uboot/sheevaplug.nix { };

  uclibc = callPackage ../os-specific/linux/uclibc { };

  uclibcCross = import ../os-specific/linux/uclibc {
    inherit fetchurl stdenv;
    linuxHeaders = linuxHeadersCross;
    gccCross = gccCrossStageStatic;
    cross = assert crossSystem != null; crossSystem;
  };

  udev = callPackage ../os-specific/linux/udev { };

  uml = import ../os-specific/linux/kernel/linux-2.6.29.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    userModeLinux = true;
  };

  umlutilities = callPackage ../os-specific/linux/uml-utilities {
    tunctl = true; mconsole = true;
  };

  upstart = callPackage ../os-specific/linux/upstart { };

  usbutils = callPackage ../os-specific/linux/usbutils { };

  utillinux = utillinuxng;

  utillinuxCurses = utillinuxngCurses;

  utillinuxng = callPackage ../os-specific/linux/util-linux-ng {
    ncurses = null;
  };

  utillinuxngCurses = utillinuxng.override {
    inherit ncurses;
  };

  windows = rec {
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

    wxMSW = callPackage ../os-specific/windows/wxMSW-2.8 { };
  };

  wesnoth = callPackage ../games/wesnoth {
    inherit (gtkLibs) pango;
  };

  wirelesstools = callPackage ../os-specific/linux/wireless-tools { };

  wpa_supplicant = callPackage ../os-specific/linux/wpa_supplicant {
    guiSupport = false;
  };
  # prebuild binaries:
  wpa_supplicant_gui = wpa_supplicant.override { guiSupport = true; };

  # deprecated, but contains icon ? Does no longer build
  /* didn't build Sun Apr 25 20:34:18 CEST 2010
  wpa_supplicant_gui_qt4_old = callPackage ../os-specific/linux/wpa_supplicant/gui-qt4.nix { };
  */

  xf86_input_wacom = callPackage ../os-specific/linux/xf86-input-wacom { };

  xmoto = builderDefsPackage (import ../games/xmoto) {
    inherit chipmunk sqlite curl zlib bzip2 libjpeg libpng
      freeglut mesa SDL SDL_mixer SDL_image SDL_net SDL_ttf
      lua5 ode libxdg_basedir;
  };

  xorg_sys_opengl = callPackage ../os-specific/linux/opengl/xorg-sys { };

  zd1211fw = callPackage ../os-specific/linux/firmware/zd1211 { };

  ### DATA

  arkpandora_ttf = builderDefsPackage (import ../data/fonts/arkpandora) {
  };

  bakoma_ttf = callPackage ../data/fonts/bakoma-ttf { };

  cacert = callPackage ../data/misc/cacert { };

  corefonts = callPackage ../data/fonts/corefonts { };

  wrapFonts = paths : ((import ../data/fonts/fontWrap) {
    inherit fetchurl stdenv builderDefs paths ttmkfdir;
    inherit (xorg) mkfontdir mkfontscale;
  });

  clearlyU = callPackage ../data/fonts/clearlyU { };

  dejavu_fonts = callPackage ../data/fonts/dejavu-fonts {
    inherit (perlPackages) FontTTF;
  };

  docbook5 = callPackage ../data/sgml+xml/schemas/docbook-5.0 { };

  docbook_xml_dtd_412 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix { };

  docbook_xml_dtd_42 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix { };

  docbook_xml_dtd_43 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix { };

  docbook_xml_dtd_45 = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix { };

  docbook_xml_ebnf_dtd = callPackage ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf { };

  docbook_xml_xslt = docbook_xsl;

  docbook_xsl = callPackage ../data/sgml+xml/stylesheets/xslt/docbook-xsl { };

  docbook5_xsl = docbook_xsl_ns;

  docbook_xsl_ns = callPackage ../data/sgml+xml/stylesheets/xslt/docbook-xsl-ns { };

  freefont_ttf = callPackage ../data/fonts/freefont-ttf { };

  hicolor_icon_theme = callPackage ../data/misc/hicolor-icon-theme { };

  junicode = callPackage ../data/fonts/junicode { };

  liberation_ttf = callPackage ../data/fonts/redhat-liberation-fonts { };

  libertine = builderDefsPackage (import ../data/fonts/libertine/2.7.nix) {
    inherit fontforge;
  };
  libertineBin = builderDefsPackage (import ../data/fonts/libertine/2.7.bin.nix) {
  };

  lmodern = callPackage ../data/fonts/lmodern { };

  manpages = callPackage ../data/documentation/man-pages { };

  miscfiles = callPackage ../data/misc/miscfiles { };

  mph_2b_damase = callPackage ../data/fonts/mph-2b-damase { };

  pthreadmanpages = callPackage ../data/documentation/pthread-man-pages { };

  shared_mime_info = callPackage ../data/misc/shared-mime-info { };

  shared_desktop_ontologies = callPackage ../data/misc/shared-desktop-ontologies { };

  stdmanpages = callPackage ../data/documentation/std-man-pages { };

  iana_etc = callPackage ../data/misc/iana-etc { };

  popplerData = callPackage ../data/misc/poppler-data { };

  r3rs = callPackage ../data/documentation/rnrs/r3rs.nix { };

  r4rs = callPackage ../data/documentation/rnrs/r4rs.nix { };

  r5rs = callPackage ../data/documentation/rnrs/r5rs.nix { };

  themes = name: import (../data/misc/themes + ("/" + name + ".nix")) {
    inherit fetchurl;
  };

  terminus_font = callPackage ../data/fonts/terminus-font { };

  ttf_bitstream_vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  ucsFonts = callPackage ../data/fonts/ucs-fonts { };

  unifont = callPackage ../data/fonts/unifont { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  wqy_zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xhtml1 = callPackage ../data/sgml+xml/schemas/xml-dtd/xhtml1 { };

  xkeyboard_config = callPackage ../data/misc/xkeyboard-config { };


  ### APPLICATIONS


  aangifte2005 = callPackage_i686 ../applications/taxes/aangifte-2005 { };

  aangifte2006 = callPackage_i686 ../applications/taxes/aangifte-2006 { };

  aangifte2007 = callPackage_i686 ../applications/taxes/aangifte-2007 { };

  aangifte2008 = callPackage_i686 ../applications/taxes/aangifte-2008 { };

  aangifte2009 = callPackage_i686 ../applications/taxes/aangifte-2009 { };

  abcde = callPackage ../applications/audio/abcde { };

  abiword = callPackage ../applications/office/abiword {
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade libgnomecanvas;
  };

  adobeReader = callPackage_i686 ../applications/misc/adobe-reader {
    inherit (pkgsi686Linux.gtkLibs) glib pango atk gtk;
  };

  amsn = callPackage ../applications/networking/instant-messengers/amsn {
    libstdcpp = gcc33.gcc;
  };

  ardour = callPackage ../applications/audio/ardour {
    inherit (gtkLibs) glib pango gtk glibmm gtkmm;
    inherit (gnome) libgnomecanvas;
  };

  audacious = callPackage ../applications/audio/audacious {
    inherit (gtkLibs) glib gtk;
  };

  audacity = callPackage ../applications/audio/audacity {
    inherit (gtkLibs) gtk glib;
  };

  aumix = callPackage ../applications/audio/aumix {
    inherit (gtkLibs) gtk;
    gtkGUI = false;
  };

  autopanosiftc = callPackage ../applications/graphics/autopanosiftc { };

  avidemux = callPackage ../applications/video/avidemux {
    inherit (gtkLibs) gtk;
    stdenv = stdenv2;
  };

  awesome = callPackage ../applications/window-managers/awesome {
    inherit (gtkLibs) glib pango;
    lua = lua5;
    cairo = cairo.override { xcbSupport = true; };
  };

  bangarang = newScope pkgs.kde4 ../applications/video/bangarang { };

  batik = callPackage ../applications/graphics/batik { };

  bazaar = callPackage ../applications/version-management/bazaar {
    python = pythonFull;
  };

  bazaarTools = builderDefsPackage (import ../applications/version-management/bazaar/tools.nix) {
    inherit bazaar;
  };

  beast = callPackage ../applications/audio/beast {
    # stdenv = overrideGCC stdenv gcc34;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libgnomecanvas libart_lgpl;
  };

  bitlbee = callPackage ../applications/networking/instant-messengers/bitlbee { };

  bitlbeeOtr = callPackage ../applications/networking/instant-messengers/bitlbee-otr { };

  # commented out because it's using the new configuration style proposal which is unstable
  #biew = import ../applications/misc/biew {
  #  inherit lib stdenv fetchurl ncurses;
  #};

  # only to be able to compile blender - I couldn't compile the default openal software
  # Perhaps this can be removed - don't know which one openal{,soft} is better
  freealut_soft = callPackage ../development/libraries/freealut {
    openal = openalSoft;  };

  blender = callPackage ../applications/misc/blender/2.49.nix {
    python = python26Base;
    stdenv = stdenv2;
  };

  blender_2_50 = lowPrio (import ../applications/misc/blender {
    inherit fetchurl cmake mesa gettext libjpeg libpng zlib openal SDL openexr
      libsamplerate libtiff ilmbase;
    inherit (xlibs) libXi;
    python = python31Base;
    stdenv = stdenv2;
  });

  bmp = callPackage ../applications/audio/bmp {
    inherit (gnome) esound libglade;
    inherit (gtkLibs) glib gtk;
  };

  bmp_plugin_musepack = callPackage ../applications/audio/bmp-plugins/musepack { };

  bmp_plugin_wma = callPackage ../applications/audio/bmp-plugins/wma { };

  bvi = callPackage ../applications/editors/bvi { };

  calibre = callPackage ../applications/misc/calibre {
    python = python26Full;
    inherit (python26Packages) mechanize lxml dateutil cssutils beautifulsoap;
  };

  carrier = builderDefsPackage (import ../applications/networking/instant-messengers/carrier/2.5.0.nix) {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 openssl nss
      gtkspell aspell gettext ncurses avahi dbus dbus_glib python
      libtool automake autoconf;
    GStreamer = gst_all.gstreamer;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) startupnotification GConf ;
    inherit (xlibs) libXScrnSaver scrnsaverproto libX11 xproto kbproto;
  };
  funpidgin = carrier;

  cddiscid = callPackage ../applications/audio/cd-discid { };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = callPackage ../applications/audio/cdparanoia { };

  cdrtools = callPackage ../applications/misc/cdrtools { };

  chatzilla =
    xulrunnerWrapper {
      launcher = "chatzilla";
      application = callPackage ../applications/networking/irc/chatzilla { };
    };

  chrome = callPackage ../applications/networking/browsers/chromium {
    inherit (gtkLibs) gtk glib pango atk;
    inherit (gnome) GConf;
    patchelf = patchelf06;
    libjpeg = libjpeg62;
  };

  chromeWrapper = wrapFirefox chrome "chrome" "";

  cinelerra = callPackage ../applications/video/cinelerra {
    fftw = fftwSinglePrec;
    inherit (gnome) esound;
  };

  compizBase = (builderDefsPackage (import ../applications/window-managers/compiz/0.8.0.nix)) {
    inherit lib stringsWithDeps builderDefs;
    inherit fetchurl stdenv pkgconfig libpng mesa perl perlXMLParser libxslt gettext
      intltool binutils;
    inherit (xorg) libXcomposite libXfixes libXdamage libXrandr
      libXinerama libICE libSM libXrender xextproto compositeproto fixesproto
      damageproto randrproto xineramaproto renderproto kbproto xproto libX11
      libxcb;
    inherit (gnome) startupnotification libwnck GConf;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnome libgnomeui metacity
      glib pango libglade libgtkhtml gtkhtml
      libgnomecanvas libgnomeprint
      libgnomeprintui gnomepanel;
    gnomegtk = gnome.gtk;
    inherit librsvg fuse;
    inherit dbus dbus_glib;
  };

  compiz = compizBase.passthru.function (x : x // {
    extraConfigureFlags = getConfig ["compiz" "extraConfigureFlags"] [];
  });

  compizFusion = callPackage ../applications/window-managers/compiz-fusion {
    version = getConfig ["compizFusion" "version"] "0.7.8";
    inherit (gnome) startupnotification libwnck GConf;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnome libgnomeui metacity
      glib pango libglade libgtkhtml gtkhtml
      libgnomecanvas libgnomeprint
      libgnomeprintui gnomepanel gnomedesktop;
    inherit pyrex;
    gnomegtk = gnome.gtk;
  };

  compizExtra = callPackage ../applications/window-managers/compiz/extra.nix {
    inherit (gnome) GConf;
    inherit (gtkLibs) gtk;
  };

  cinepaint = callPackage ../applications/graphics/cinepaint {
    inherit (gtkLibs) gtk glib;
    fltk = fltk11;
  };

  codeville = builderDefsPackage (import ../applications/version-management/codeville/0.8.0.nix) {
    inherit makeWrapper;
    python = pythonFull;
  };

  comical = callPackage ../applications/graphics/comical {
    wxGTK = wxGTK26;
  };

  conkeror = xulrunnerWrapper {
    launcher = "conkeror";
    application = callPackage ../applications/networking/browsers/conkeror { };
  };

  cuneiform = builderDefsPackage (import ../tools/graphics/cuneiform) {
    inherit cmake patchelf;
    imagemagick=imagemagick;
  };

  cvs = callPackage ../applications/version-management/cvs { };

  cvsps = callPackage ../applications/version-management/cvsps { };

  cvs2svn = callPackage ../applications/version-management/cvs2svn { };

  d4x = callPackage ../applications/misc/d4x {
    inherit (gtkLibs) gtk glib;
  };

  darcs = haskellPackages.darcs;

  dia = callPackage ../applications/graphics/dia {
    inherit (gtkLibs) gtk glib;
  };

  djvulibre = callPackage ../applications/misc/djvulibre { };

  djview4 = callPackage ../applications/graphics/djview { };

  dmenu = callPackage ../applications/misc/dmenu { };

  dmtx = builderDefsPackage (import ../tools/graphics/dmtx) {
    inherit libpng libtiff libjpeg imagemagick librsvg
      pkgconfig bzip2 zlib libtool freetype fontconfig
      ghostscript jasper;
    inherit (xlibs) libX11;
  };

  dvdauthor = callPackage ../applications/video/dvdauthor { };

  dwm = callPackage ../applications/window-managers/dwm {
    patches = getConfig [ "dwm" "patches" ] [];
  };

  eaglemode = callPackage ../applications/misc/eaglemode { };

  eclipse = callPackage ../applications/editors/eclipse {
    # GTK 2.18 gives glitches such as mouse clicks on buttons not
    # working correctly.
    inherit (gtkLibs216) glib gtk;
  };
  eclipseLatest = eclipse.override { version = "latest"; };

  ed = callPackage ../applications/editors/ed { };

  elinks = callPackage ../applications/networking/browsers/elinks { };

  elvis = callPackage ../applications/editors/elvis { };

  emacs = emacs23;

  emacs22 = callPackage ../applications/editors/emacs-22 {
    inherit (gtkLibs) gtk;
    xaw3dSupport = getPkgConfig "emacs" "xaw3dSupport" false;
    gtkGUI = getPkgConfig "emacs" "gtkSupport" true;
  };

  emacs23 = callPackage ../applications/editors/emacs-23 {
    # use override to select the appropriate gui toolkit
    libXaw = if stdenv.isDarwin then xlibs.libXaw else null;
    Xaw3d = null;
    gtk = if stdenv.isDarwin then null else gtkLibs.gtk;
    # TODO: these packages don't build on Darwin.
    gconf = if stdenv.isDarwin then null else gnome.GConf;
    librsvg = if stdenv.isDarwin then null else librsvg;
  };

  emacsSnapshot = lowPrio (import ../applications/editors/emacs-snapshot {
    inherit fetchcvs stdenv ncurses pkgconfig x11 Xaw3d
      libpng libjpeg libungif libtiff texinfo dbus
      autoconf automake;
    inherit (xlibs) libXaw libXpm libXft;
    inherit (gtkLibs) gtk;
    xawSupport = getPkgConfig "emacs" "xawSupport" false;
    xaw3dSupport = getPkgConfig "emacs" "xaw3dSupport" false;
    gtkGUI = getPkgConfig "emacs" "gtkSupport" true;
    xftSupport = getPkgConfig "emacs" "xftSupport" true;
    dbusSupport = getPkgConfig "emacs" "dbusSupport" true;
  });

  emacsPackages = emacs: self: let callPackage = newScope self; in rec {
    inherit emacs;

    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    cua = callPackage ../applications/editors/emacs-modes/cua { };

    ecb = callPackage ../applications/editors/emacs-modes/ecb { };

    jabber = callPackage ../applications/editors/emacs-modes/jabber { };

    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };

    emms = callPackage ../applications/editors/emacs-modes/emms { };

    jdee = callPackage ../applications/editors/emacs-modes/jdee {
      # Requires Emacs 23, for `avl-tree'.
    };

    stratego = callPackage ../applications/editors/emacs-modes/stratego { };

    haskellMode = callPackage ../applications/editors/emacs-modes/haskell { };

    hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };

    htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };

    magit = callPackage ../applications/editors/emacs-modes/magit { };

    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };

    nxml = callPackage ../applications/editors/emacs-modes/nxml { };

    # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
    # we want it to have higher precedence.
    org = hiPrio (callPackage ../applications/editors/emacs-modes/org { });

    prologMode = callPackage ../applications/editors/emacs-modes/prolog { };

    proofgeneral = callPackage ../applications/editors/emacs-modes/proofgeneral { };

    quack = callPackage ../applications/editors/emacs-modes/quack { };

    remember = callPackage ../applications/editors/emacs-modes/remember { };

    rudel = callPackage ../applications/editors/emacs-modes/rudel { };

    scalaMode = callPackage ../applications/editors/emacs-modes/scala-mode { };
  };

  emacs22Packages = emacsPackages emacs22 pkgs.emacs22Packages;
  emacs23Packages = recurseIntoAttrs (emacsPackages emacs23 pkgs.emacs23Packages);

  epdfview = callPackage ../applications/misc/epdfview {
    inherit (gtkLibs) gtk;
  };

  espeak = callPackage ../applications/audio/espeak { };

  evince = callPackage ../applications/misc/evince {
    inherit (gnome) gnomedocutils gnomeicontheme libgnome
      libgnomeui libglade glib gtk scrollkeeper gnome_keyring;
  };

  evolution_data_server = (newScope (gnome // gtkLibs))
  ../servers/evolution-data-server {
  };

  exrdisplay = callPackage ../applications/graphics/exrdisplay {
    fltk = fltk20;
  };

  fbpanel = callPackage ../applications/window-managers/fbpanel {
    inherit (gtkLibs) gtk;
  };

  fetchmail = import ../applications/misc/fetchmail {
    inherit stdenv fetchurl openssl;
  };

  fossil = callPackage ../applications/version-management/fossil { };

  grass = import ../applications/misc/grass {
    inherit (xlibs) libXmu libXext libXp libX11 libXt libSM libICE libXpm
      libXaw libXrender;
    inherit getConfig composableDerivation stdenv fetchurl
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
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libgnome libgnomeui vte;
  };

  wavesurfer = callPackage ../applications/misc/audio/wavesurfer { };

  wireshark = callPackage ../applications/networking/sniffers/wireshark {
    inherit (gtkLibs) gtk;
  };

  wvdial = callPackage ../os-specific/linux/wvdial { };

  fbida = builderDefsPackage ../applications/graphics/fbida {
    inherit libjpeg libexif giflib libtiff libpng
      imagemagick ghostscript which curl pkgconfig
      freetype fontconfig;
  };

  fdupes = callPackage ../tools/misc/fdupes { };

  feh = callPackage ../applications/graphics/feh { };

  firefox = firefox36Pkgs.firefox;
  firefoxWrapper = firefox36Wrapper;

  firefox35Pkgs = callPackage ../applications/networking/browsers/firefox/3.5.nix {
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
  };

  firefox35Wrapper = wrapFirefox firefox35Pkgs.firefox "firefox" "";

  firefox36Pkgs = callPackage ../applications/networking/browsers/firefox/3.6.nix {
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
  };

  firefox36Wrapper = wrapFirefox firefox36Pkgs.firefox "firefox" "";

  flac = callPackage ../applications/audio/flac { };

  flashplayer = flashplayer10;

  flashplayer9 = (
    import ../applications/networking/browsers/mozilla-plugins/flashplayer-9 {
      inherit fetchurl stdenv zlib alsaLib nss nspr fontconfig freetype expat;
      inherit (xlibs) libX11 libXext libXrender libXt;
      inherit (gtkLibs) gtk glib pango atk;
    });

  flashplayer10 = (
    import ../applications/networking/browsers/mozilla-plugins/flashplayer-10 {
      inherit fetchurl stdenv zlib alsaLib curl nss nspr fontconfig freetype expat;
      inherit (xlibs) libX11 libXext libXrender libXt ;
      inherit (gtkLibs) gtk glib pango atk;
      debug = getConfig ["flashplayer" "debug"] false;
    });

  flite = callPackage ../applications/misc/flite { };

  freemind = callPackage ../applications/misc/freemind {
    jdk = jdk;
    jre = jdk;
  };

  freepv = callPackage ../applications/graphics/freepv { };

  xfontsel = callPackage ../applications/misc/xfontsel { };
  xlsfonts = callPackage ../applications/misc/xlsfonts { };

  fspot = callPackage ../applications/graphics/f-spot {
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  gimp = callPackage ../applications/graphics/gimp {
    inherit (gnome) gtk libart_lgpl;
  };

  gimpPlugins = recurseIntoAttrs (import ../applications/graphics/gimp/plugins {
    inherit pkgs gimp;
  });

  gitAndTools = recurseIntoAttrs (import ../applications/version-management/git-and-tools {
    inherit pkgs;
  });
  git = gitAndTools.git;
  gitFull = gitAndTools.gitFull;

  gnucash = callPackage ../applications/office/gnucash {
    inherit (gnome) gtk glib libglade libgnomeui libgtkhtml gtkhtml
      libgnomeprint;
    gconf = gnome.GConf;
  };

  qcad = callPackage ../applications/misc/qcad { };

  qjackctl = callPackage ../applications/audio/qjackctl {
    qt4 = qt4;
  };

  gkrellm = callPackage ../applications/misc/gkrellm {
    inherit (gtkLibs) glib gtk;
  };

  gnash = callPackage ../applications/video/gnash {
    inherit (gtkLibs) glib gtk;
    inherit (gnome) gtkglext;
    inherit (gst_all) gstreamer gstPluginsBase gstPluginsGood gstFfmpeg;
  };

  gnome_mplayer = callPackage ../applications/video/gnome-mplayer {
    inherit (gtkLibs) glib gtk;
    inherit (gnome) GConf;
  };

  gnunet = callPackage ../applications/networking/p2p/gnunet {
    inherit (gnome) gtk libglade;
    gtkSupport = getConfig [ "gnunet" "gtkSupport" ] true;
  };

  gocr = callPackage ../applications/graphics/gocr { };

  gphoto2 = callPackage ../applications/misc/gphoto2 { };

  gphoto2fs = builderDefsPackage ../applications/misc/gphoto2/gphotofs.nix {
    inherit libgphoto2 fuse pkgconfig glib;
  };

  graphicsmagick = callPackage ../applications/graphics/graphicsmagick { };

  graphicsmagick137 = callPackage ../applications/graphics/graphicsmagick/1.3.7.nix { };

  gtkpod = callPackage ../applications/audio/gtkpod {
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libglade;
  };

  qrdecode = builderDefsPackage (import ../tools/graphics/qrdecode) {
    inherit libpng libcv;
  };

  qrencode = builderDefsPackage (import ../tools/graphics/qrencode) {
    inherit libpng pkgconfig;
  };

  gecko_mediaplayer = callPackage ../applications/networking/browsers/mozilla-plugins/gecko-mediaplayer {
    inherit (gnome) GConf;
    browser = firefox;
  };

  geeqie = callPackage ../applications/graphics/geeqie {
    inherit (gtkLibs) gtk;
  };

  gqview = callPackage ../applications/graphics/gqview {
    inherit (gtkLibs) gtk;
  };

  googleearth = callPackage_i686 ../applications/misc/googleearth { };

  gosmore = builderDefsPackage ../applications/misc/gosmore {
    inherit fetchsvn curl pkgconfig libxml2;
    inherit (gtkLibs) gtk;
  };

  gpsbabel = callPackage ../applications/misc/gpsbabel { };

  gpscorrelate = callPackage ../applications/misc/gpscorrelate {
    inherit (gtkLibs) gtk;
  };

  gpsd = callPackage ../servers/gpsd {

    # We need a Python with NCurses bindings.
    python = pythonFull;
  };

  gv = callPackage ../applications/misc/gv { };

  hello = callPackage ../applications/misc/hello/ex-2 { };

  homebank = callPackage ../applications/office/homebank {
    inherit (gtkLibs) gtk;
  };

  htmldoc = callPackage ../applications/misc/htmldoc {
    fltk = fltk11;
  };

  hugin = callPackage ../applications/graphics/hugin {
    stdenv = stdenv2;
  };

  i810switch = callPackage ../os-specific/linux/i810switch { };

  icecat3 = lowPrio (import ../applications/networking/browsers/icecat-3 {
    inherit fetchurl stdenv xz pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs alsaLib libnotify
      wirelesstools;
    inherit (gnome) libIDL libgnomeui gnomevfs gtk pango;
    inherit (xlibs) pixman;
    inherit (pythonPackages) ply;
  });

  icecatXulrunner3 = lowPrio (import ../applications/networking/browsers/icecat-3 {
    application = "xulrunner";
    inherit fetchurl stdenv xz pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs alsaLib libnotify
      wirelesstools;
    inherit (gnome) libIDL libgnomeui gnomevfs gtk pango;
    inherit (xlibs) pixman;
    inherit (pythonPackages) ply;
  });

  icecat3Xul =
    (symlinkJoin "icecat-with-xulrunner-${icecat3.version}"
       [ icecat3 icecatXulrunner3 ])
    // { inherit (icecat3) gtk isFirefox3Like meta; };

  icecatWrapper = wrapFirefox icecat3Xul "icecat" "";

  icewm = callPackage ../applications/window-managers/icewm { };

  id3v2 = callPackage ../applications/audio/id3v2 { };

  ikiwiki = callPackage ../applications/misc/ikiwiki {
    inherit (perlPackages) TextMarkdown URI HTMLParser HTMLScrubber
      HTMLTemplate TimeDate CGISession DBFile CGIFormBuilder LocaleGettext
      RpcXML XMLSimple PerlMagick;
    gitSupport = getPkgConfig "ikiwiki" "git" false;
    monotoneSupport = getPkgConfig "ikiwiki" "monotone" false;
    extraUtils = [];
  };

  imagemagick = callPackage ../applications/graphics/ImageMagick {
    tetex = null;
    librsvg = null;
  };

  imagemagickBig = callPackage ../applications/graphics/ImageMagick { };

  # Impressive, formerly known as "KeyJNote".
  impressive = callPackage ../applications/office/impressive {

    # XXX These are the PyOpenGL dependencies, which we need here.

    inherit (pythonPackages) pyopengl;  };

  inkscape = callPackage ../applications/graphics/inkscape {
    inherit (pythonPackages) lxml;
    inherit (gtkLibs) gtk glib glibmm gtkmm;
  };

  ion3 = callPackage ../applications/window-managers/ion-3 {
    lua = lua5;
  };

  iptraf = callPackage ../applications/networking/iptraf { };

  irssi = callPackage ../applications/networking/irc/irssi { };

  jackmeter = callPackage ../applications/audio/jackmeter { };

  jedit = callPackage ../applications/editors/jedit { };

  jigdo = callPackage ../applications/misc/jigdo {
    inherit (gtkLibs) gtk;
  };

  joe = callPackage ../applications/editors/joe { };

  jwm = callPackage ../applications/window-managers/jwm { };

  kermit = callPackage ../tools/misc/kermit { };

  kino = import ../applications/video/kino {
    inherit fetchurl stdenv pkgconfig libxml2 perl perlXMLParser
      libdv libraw1394 libavc1394 libiec61883 x11 gettext cairo; /* libavformat */
    inherit libsamplerate ffmpeg;
    inherit (gnome) libglade gtk glib;
    inherit (xlibs) libXv libX11;
    inherit (gtkLibs) pango;
    # #  optional
    #  inherit ffmpeg2theora sox, vorbis-tools lame mjpegtools dvdauthor 'Q'dvdauthor growisofs mencoder;
  };

  konversation = newScope pkgs.kde4 ../applications/networking/irc/konversation { };

  lame = callPackage ../applications/audio/lame { };

  larswm = callPackage ../applications/window-managers/larswm { };

  ladspaH = callPackage ../applications/audio/ladspa-plugins/ladspah.nix { };

  ladspaPlugins = callPackage ../applications/audio/ladspa-plugins {
    fftw = fftwSinglePrec;
  };

  ldcpp = callPackage ../applications/networking/p2p/ldcpp {
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade;
  };

  links = callPackage ../applications/networking/browsers/links { };

  ledger = callPackage ../applications/office/ledger { };

  links2 = (builderDefsPackage ../applications/networking/browsers/links2) {
    inherit fetchurl stdenv bzip2 zlib libjpeg libpng libtiff
      gpm openssl SDL SDL_image SDL_net pkgconfig;
    inherit (xlibs) libX11 libXau xproto libXt;
  };

  lynx = callPackage ../applications/networking/browsers/lynx { };

  lyx = callPackage ../applications/misc/lyx {
   qt = qt4;
  };

  matchbox = callPackage ../applications/window-managers/matchbox { };

  meld = callPackage ../applications/version-management/meld {
    inherit (gnome) scrollkeeper;
    pygtk = pyGtkGlade;
  };

  mercurial = callPackage ../applications/version-management/mercurial {
    guiSupport = getConfig ["mercurial" "guiSupport"] false; # for hgk (gitk gui for hg)
    python = # allow cloning sources from https servers.
      if getConfig ["mercurial" "httpsSupport"] true
      then pythonFull
      else pythonBase;
  };

  merkaartor = callPackage ../applications/misc/merkaartor {
    qt = qt4;
  };

  meshlab = callPackage ../applications/graphics/meshlab {
    qt = qt4;
  };

  midori = builderDefsPackage (import ../applications/networking/browsers/midori) {
    inherit imagemagick intltool python pkgconfig webkit libxml2
      which gettext makeWrapper file libidn sqlite docutils libnotify
      vala dbus_glib;
    inherit (gtkLibs) gtk glib;
    inherit (gnome28) gtksourceview;
    inherit (webkit.passthru.args) libsoup;
    inherit (xlibs) kbproto xproto libXScrnSaver scrnsaverproto;
  };

  minicom = callPackage ../tools/misc/minicom { };

  mmex = callPackage ../applications/office/mmex { };

  monodevelop = callPackage ../applications/editors/monodevelop {
    inherit (gnome) gnomevfs libbonobo libglade libgnome GConf glib gtk;
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
    inherit ocaml lablgtk graphviz pkgconfig autoconf automake libtool;
    inherit (gnome) gtk libgnomecanvas glib;
  };

  mozilla = callPackage ../applications/networking/browsers/mozilla {
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
  };

  mozplugger = builderDefsPackage (import ../applications/networking/browsers/mozilla-plugins/mozplugger) {
    inherit firefox;
    inherit (xlibs) libX11 xproto;
  };

  mpc123 = callPackage ../applications/audio/mpc123 { };

  mpg321 = callPackage ../applications/audio/mpg321 { };

  MPlayer = callPackage ../applications/video/MPlayer { };

  MPlayerPlugin = browser:
    import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      inherit fetchurl stdenv pkgconfig gettext;
      inherit (xlibs) libXpm;
      # !!! should depend on MPlayer
    };

  mrxvt = callPackage ../applications/misc/mrxvt { };

  multisync = callPackage ../applications/misc/multisync {
    inherit (gnome) gtk glib ORBit2 libbonobo libgnomeui GConf;
  };

  mutt = callPackage ../applications/networking/mailreaders/mutt { };

  msmtp = callPackage ../applications/networking/msmtp { };

  mupdf = callPackage ../applications/misc/mupdf {
  };

  mythtv = callPackage ../applications/video/mythtv {
    qt3 = qt3mysql;
  };

  nano = callPackage ../applications/editors/nano { };

  navipowm = callPackage ../applications/misc/navipowm {
  };

  navit = callPackage ../applications/misc/navit {
    inherit (gtkLibs) gtk;
  };

  nedit = callPackage ../applications/editors/nedit {
      motif = lesstif;
  };

  netsurfBrowser = netsurf.browser;
  netsurf = recurseIntoAttrs (import ../applications/networking/browsers/netsurf { inherit pkgs; });

  nvi = callPackage ../applications/editors/nvi { };

  openjump = callPackage ../applications/misc/openjump { };

  openoffice = callPackage ../applications/office/openoffice {
    inherit (gtkLibs) gtk;
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2;
    neon = neon029;
    stdenv = stdenv2;
  };

  go_oo = callPackage ../applications/office/openoffice/go-oo.nix {
    inherit (gtkLibs) gtk;
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2;
    neon = neon029;
    stdenv = stdenv2;
  };

  opera = callPackage ../applications/networking/browsers/opera {
    qt = qt3;
  };

  pan = callPackage ../applications/networking/newsreaders/pan {
    inherit (gtkLibs) gtk;
    gmime = gmime_2_2;
    spellChecking = false;
  };

  panotools = callPackage ../applications/graphics/panotools { };

  pavucontrol = callPackage ../applications/audio/pavucontrol {
    inherit (gtkLibs) gtkmm;
    inherit (gnome) libglademm;
  };

  paraview = callPackage ../applications/graphics/paraview {
    stdenv = stdenv2;
  };

  partitionManager = newScope pkgs.kde4 ../tools/misc/partition-manager { };

  pdftk = callPackage ../tools/typesetting/pdftk { };

  pidgin = import ../applications/networking/instant-messengers/pidgin {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 nss nspr farsight2 python
      gtkspell aspell gettext ncurses avahi dbus dbus_glib lib intltool libidn;
    openssl = if (getConfig ["pidgin" "openssl"] true) then openssl else null;
    gnutls = if (getConfig ["pidgin" "gnutls"] false) then gnutls else null;
    GStreamer = gst_all.gstreamer;
    inherit (gtkLibs) gtk;
    inherit (gnome) startupnotification;
    inherit (xlibs) libXScrnSaver;
    inherit (gst_all) gstPluginsBase;
  };

  pidginlatex = callPackage ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex {
    imagemagick = imagemagickBig;
    inherit (gtkLibs) glib gtk;
  };

  pidginlatexSF = builderDefsPackage
    (import ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex/pidgin-latex-sf.nix)
    {
      inherit pkgconfig pidgin texLive imagemagick which;
      inherit (gtkLibs) glib gtk;
    };

  pidginmsnpecan = callPackage ../applications/networking/instant-messengers/pidgin-plugins/msn-pecan { };

  pidginotr = callPackage ../applications/networking/instant-messengers/pidgin-plugins/otr { };

  pidginsipe = callPackage ../applications/networking/instant-messengers/pidgin-plugins/sipe { };

  pinfo = callPackage ../applications/misc/pinfo { };

  pinta = callPackage ../applications/graphics/pinta {
    gtksharp = gtksharp2;
  };

  pqiv = callPackage ../applications/graphics/pqiv {
    inherit (gtkLibs) gtk;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = callPackage ../applications/misc/procmail { };

  pstree = callPackage ../applications/misc/pstree { };

  pythonmagick = callPackage ../applications/graphics/PythonMagick { };

  qemu = callPackage ../applications/virtualization/qemu/0.12.3.nix { };

  qemuSVN = callPackage ../applications/virtualization/qemu/svn-6642.nix { };

  qemuImage = callPackage ../applications/virtualization/qemu/linux-img { };

  qtpfsgui = callPackage ../applications/graphics/qtpfsgui { };

  rapidsvn = callPackage ../applications/version-management/rapidsvn { };

  ratpoison = callPackage ../applications/window-managers/ratpoison { };

  rawtherapee = callPackage ../applications/graphics/rawtherapee {
    inherit (gtkLibs) gtk gtkmm;
  };

  rcs = callPackage ../applications/version-management/rcs { };

  rdesktop = callPackage ../applications/networking/remote/rdesktop { };

  RealPlayer = callPackage ../applications/video/RealPlayer {
      inherit (gtkLibs) glib pango atk gtk;
      libstdcpp5 = gcc33.gcc;
  };

  rekonq = newScope pkgs.kde4 ../applications/networking/browsers/rekonq {
    inherit (gtkLibs) gtk;
  };

  rsibreak = newScope pkgs.kde4 ../applications/misc/rsibreak { };

  rsync = callPackage ../applications/networking/sync/rsync {
    enableACLs = !(stdenv.isDarwin || stdenv.isSunOS);
  };

  rxvt = callPackage ../applications/misc/rxvt { };

  # = urxvt
  rxvt_unicode = callPackage ../applications/misc/rxvt_unicode {
    perlSupport = false;  };

  sakura = callPackage ../applications/misc/sakura {
    inherit (gtkLibs) gtk;
    inherit (gnome) vte;
  };

  sbagen = callPackage ../applications/misc/sbagen { };

  scribus = callPackage ../applications/office/scribus {
    inherit (gnome) libart_lgpl;
    qt = qt3;
  };

  seeks = callPackage ../tools/networking/p2p/seeks { };

  seg3d = callPackage ../applications/graphics/seg3d {
    wxGTK = wxGTK28.override {
      unicode = false;
  };
  };

  semnotes = newScope pkgs.kde4 ../applications/misc/semnotes { };

  skype_linux = callPackage_i686 ../applications/networking/skype { };

  slim = callPackage ../applications/display-managers/slim { };

  sndBase = builderDefsPackage (import ../applications/audio/snd) {
    inherit fetchurl stdenv stringsWithDeps lib fftw;
    inherit pkgconfig gmp gettext;
    inherit (xlibs) libXpm libX11;
    inherit (gtkLibs) gtk glib;
  };

  snd = sndBase.passthru.function {
    inherit guile mesa libtool jackaudio alsaLib;
  };

  sonicVisualizer = callPackage ../applications/audio/sonic-visualizer {
    inherit (vamp) vampSDK;
    qt = qt4;
  };

  sox = callPackage ../applications/misc/audio/sox { };

  stumpwm = builderDefsPackage (import ../applications/window-managers/stumpwm) {
    inherit texinfo;
    clisp = clisp_2_44_1;
  };

  subversion = callPackage ../applications/version-management/subversion/default.nix {
    neon = neon029;
    bdbSupport = getConfig ["subversion" "bdbSupport"] true;
    httpServer = getConfig ["subversion" "httpServer"] false;
    httpSupport = getConfig ["subversion" "httpSupport"] true;
    sslSupport = getConfig ["subversion" "sslSupport"] true;
    pythonBindings = getConfig ["subversion" "pythonBindings"] false;
    perlBindings = getConfig ["subversion" "perlBindings"] false;
    javahlBindings = supportsJDK && getConfig ["subversion" "javahlBindings"] false;
    compressionSupport = getConfig ["subversion" "compressionSupport"] true;
    httpd = apacheHttpd;
  };

  svk = perlPackages.SVK;

  sylpheed = callPackage ../applications/networking/mailreaders/sylpheed {
    inherit (gtkLibs) gtk;
    sslSupport = true;
    gpgSupport = true;
  };

  # linux only by now
  synergy = callPackage ../applications/misc/synergy { };

  tahoelafs = callPackage ../tools/networking/p2p/tahoe-lafs {
    inherit (pythonPackages) twisted foolscap simplejson nevow zfec
      pycryptopp pysqlite darcsver setuptoolsTrial setuptoolsDarcs
      numpy pyasn1;
    mock = pythonPackages.mock060;
  };

  tailor = builderDefsPackage (import ../applications/version-management/tailor) {
    inherit makeWrapper python;
  };

  tangogps = callPackage ../applications/misc/tangogps {
    inherit (gtkLibs) gtk;
    gconf = gnome.GConf;
  };

  /* does'nt work yet i686-linux only (32bit version)
  teamspeak_client = callPackage ../applications/networking/instant-messengers/teamspeak/client.nix { };
  */

  taskJuggler = callPackage ../applications/misc/taskjuggler {
    qt = qt3;

    # KDE support is not working yet.
    inherit (kde3) kdelibs kdebase;
    withKde = getPkgConfig "taskJuggler" "kde" false;
  };

  thinkingRock = callPackage ../applications/misc/thinking-rock { };

  thunderbird = thunderbird3;

  thunderbird2 = callPackage ../applications/networking/mailreaders/thunderbird/2.x.nix {
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
  };

  thunderbird3 = callPackage ../applications/networking/mailreaders/thunderbird/3.x.nix {
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
  };

  timidity = callPackage ../tools/misc/timidity { };

  tkcvs = callPackage ../applications/version-management/tkcvs { };

  tla = callPackage ../applications/version-management/arch { };

  transmission = callPackage ../applications/networking/p2p/transmission {
    inherit (gtkLibs) gtk;
  };

  twinkle = callPackage ../applications/networking/twinkle {
    qt = qt3;
    boost = boostFull;
  };

  unison = callPackage ../applications/networking/sync/unison { };

  uucp = callPackage ../tools/misc/uucp { };

  uzbl = builderDefsPackage (import ../applications/networking/browsers/uzbl) {
    inherit pkgconfig webkit makeWrapper;
    inherit (gtkLibs) gtk glib;
    inherit (xlibs) libX11;
    libsoup = gnome28.libsoup_2_31;
  };

  valknut = callPackage ../applications/networking/p2p/valknut {
    qt = qt3;
  };

  veracity = callPackage ../applications/version-management/veracity {};

  viewMtn = builderDefsPackage (import ../applications/version-management/viewmtn/0.10.nix)
  {
    inherit
      monotone flup cheetahTemplate highlight ctags
      makeWrapper graphviz which python;
  };

  vim = callPackage ../applications/editors/vim { };

  vimHugeX = vim_configurable;

  vim_configurable = import ../applications/editors/vim/configurable.nix {
    inherit (pkgs) fetchurl stdenv ncurses pkgconfig gettext composableDerivation lib;
    inherit (pkgs.xlibs) libX11 libXext libSM libXpm
        libXt libXaw libXau libXmu libICE;
    inherit (pkgs.gtkLibs) glib gtk;
    features = "huge"; # one of  tiny, small, normal, big or huge
    # optional features by passing
    # python
    # TODO mzschemeinterp perlinterp
    inherit (pkgs) python perl tcl ruby /*x11*/;

    lua = pkgs.lua5;

    # optional features by flags
    flags = [ "X11" ]; # only flag "X11" by now
  };

  virtualgl = callPackage ../tools/X11/virtualgl { };

  vlc = callPackage ../applications/video/vlc {
    dbus = dbus.libs;
    alsa = alsaLib;
    lua = lua5;
  };

  vnstat = callPackage ../applications/networking/vnstat { };

  vorbisTools = callPackage ../applications/audio/vorbis-tools { };

  vwm = callPackage ../applications/window-managers/vwm { };

  w3m = callPackage ../applications/networking/browsers/w3m {
    graphicsSupport = false;
  };

  weechat = callPackage ../applications/networking/irc/weechat { };

  wings = callPackage ../applications/graphics/wings { };

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
    includeUnpack = getConfig ["stdenv" "includeUnpack"] false;
  };

  wordnet = callPackage ../applications/misc/wordnet { };

  wrapFirefox = browser: browserName: nameSuffix: import ../applications/networking/browsers/firefox/wrapper.nix {
    inherit stdenv nameSuffix makeWrapper makeDesktopItem browser browserName;
    plugins =
      let enableAdobeFlash = getConfig [ browserName "enableAdobeFlash" ] true;
      in
       ([]
        ++ lib.optional (!enableAdobeFlash) gnash
        ++ lib.optional enableAdobeFlash flashplayer
        # RealPlayer is disabled by default for legal reasons.
        ++ lib.optional (system != "i686-linux" && getConfig [browserName "enableRealPlayer"] false) RealPlayer
        ++ lib.optional (getConfig [browserName "enableMPlayer"] false) (MPlayerPlugin browser)
        ++ lib.optional (getConfig [browserName "enableGeckoMediaPlayer"] false) gecko_mediaplayer
        ++ lib.optional (supportsJDK && getConfig [browserName "jre"] false && jrePlugin ? mozillaPlugin) jrePlugin
       );
  };

  x11vnc = callPackage ../tools/X11/x11vnc { };

  x2vnc = callPackage ../tools/X11/x2vnc { };

  xaos = builderDefsPackage (import ../applications/graphics/xaos) {
    inherit (xlibs) libXt libX11 libXext xextproto xproto;
    inherit gsl aalib zlib libpng intltool gettext perl;
  };

  xara = callPackage ../applications/graphics/xara {
    inherit (gtkLibs) gtk;
    wxGTK = wxGTK26;
  };

  xawtv = callPackage ../applications/video/xawtv { };

  xchat = callPackage ../applications/networking/irc/xchat {
    inherit (gtkLibs) gtk;
  };

  xchm = callPackage ../applications/misc/xchm { };

  xcompmgr = callPackage ../applications/window-managers/xcompmgr { };

  xdg_utils = callPackage ../tools/X11/xdg-utils { };

  xen = callPackage ../applications/virtualization/xen { };

  xfig = callPackage ../applications/graphics/xfig {
    stdenv = overrideGCC stdenv gcc34;
  };

  xineUI = callPackage ../applications/video/xine-ui { };

  xmms = callPackage ../applications/audio/xmms {
    inherit (gnome) esound;
    inherit (gtkLibs1x) glib gtk;
    stdenv = overrideGCC stdenv gcc34; # due to problems with gcc 4.x
  };

  xneur = callPackage ../applications/misc/xneur {
    GStreamer=gst_all.gstreamer;
    inherit (gtkLibs) glib gtk pango atk;
  };

  xneur_0_8 = callPackage ../applications/misc/xneur/0.8.nix {
    GStreamer = gst_all.gstreamer;
  };

  xournal = callPackage ../applications/graphics/xournal {
    inherit (gtkLibs) gtk atk pango glib;
    inherit (gnome) libgnomeprint libgnomeprintui
      libgnomecanvas;
  };

  xpdf = callPackage ../applications/misc/xpdf {
    motif = lesstif;
    base14Fonts = "${ghostscript}/share/ghostscript/fonts";
  };

  libxpdf = callPackage ../applications/misc/xpdf/libxpdf.nix {
  };

  xpra = callPackage ../tools/X11/xpra {
    inherit (gtkLibs) gtk;
    pyrex = pyrex095;
  };

  xscreensaver = callPackage ../applications/graphics/xscreensaver {
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade;
  };

  xterm = callPackage ../applications/misc/xterm { };

  xtrace = callPackage ../tools/X11/xtrace { };

  xlaunch = callPackage ../tools/X11/xlaunch { };

  xmacro = callPackage ../tools/X11/xmacro { };

  xmove = callPackage ../applications/misc/xmove { };

  xnee = builderDefsPackage (import ../tools/X11/xnee) {
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11 libXtst xextproto libXext
      inputproto libXi xproto recordproto;
    inherit pkgconfig;
  };

  xvidcap = callPackage ../applications/video/xvidcap {
    inherit (gtkLibs) gtk;
    inherit (gnome) scrollkeeper libglade;
  };

  yate = callPackage ../applications/misc/yate {
    qt = qt4;
  };

  # doesn't compile yet - in case someone else want's to continue ..
  # use Trunk because qgisReleased segfaults no resize for now
  qgis = qgisTrunk;
  qgisReleased = (import ../applications/misc/qgis) {
    inherit composableDerivation fetchsvn stdenv flex lib
            ncurses fetchurl perl cmake gdal geos proj x11
            gsl libpng zlib bison
            sqlite glibc fontconfig freetype /* use libc from stdenv ? - to lazy now - Marc */
            python postgresql pyqt4;
    inherit (xlibs) libSM libXcursor libXinerama libXrandr libXrender;
    inherit (xorg) libICE;
    qt = qt4;

    # optional features
    # grass = "not yet supported" # cmake -D WITH_GRASS=TRUE  and GRASS_PREFX=..
  };

  qgisTrunk = callPackage ../applications/misc/qgis/trunk.nix {
    qgis = qgisReleased;
  };

  yakuake = newScope pkgs.kde4 ../applications/misc/yakuake { };

  zapping = callPackage ../applications/video/zapping {
    inherit (gnome) scrollkeeper libgnomeui libglade esound;
    teletextSupport = true;
    jpegSupport = true;
    pngSupport = true;
    recordingSupport = true;
  };

  zathura = callPackage ../applications/misc/zathura {
    inherit (gtkLibs) gtk;
  };

  ### GAMES

  asc = callPackage ../games/asc {
    lua = lua5;
    libsigcxx = libsigcxx12;
  };

  ballAndPaddle = callPackage ../games/ball-and-paddle { };

  blackshades = callPackage ../games/blackshades { };

  blackshadeselite = callPackage ../games/blackshadeselite { };

  bsdgames = callPackage ../games/bsdgames { };

  castle_combat = callPackage ../games/castle-combat { };

  construoBase = callPackage ../games/construo {
    mesa = null;
    freeglut = null;
  };

  construo = construoBase.override {
    inherit mesa freeglut;
  };

  eduke32 = callPackage ../games/eduke32 {
    inherit (gtkLibs) gtk;
  };

  egoboo = callPackage ../games/egoboo { };

  exult = callPackage ../games/exult {
    stdenv = overrideGCC stdenv gcc42;
  };

  /*
  exultSnapshot = lowPrio (import ../games/exult/snapshot.nix {
    inherit fetchurl stdenv SDL SDL_mixer zlib libpng unzip
      autoconf automake libtool flex bison;
  });
  */

  freedink = callPackage ../games/freedink { };

  fsg = callPackage ../games/fsg {
    inherit (gtkLibs) glib gtk;
    wxGTK = wxGTK28.override {unicode = false;
  };
  };

  gemrb = callPackage ../games/gemrb { };

  gltron = callPackage ../games/gltron { };

  gnuchess = builderDefsPackage (import ../games/gnuchess) {
    flex = flex2535;
  };

  gnugo = callPackage ../games/gnugo { };

  gparted = callPackage ../tools/misc/gparted {
    inherit (gtkLibs) gtk glib gtkmm;
    inherit (gnome) gnomedocutils;
  };

  hexen = callPackage ../games/hexen { };

  kobodeluxe = callPackage ../games/kobodeluxe { };

  lincity = builderDefsPackage (import ../games/lincity) {
    inherit (xlibs) libX11 libXext xextproto
      libICE libSM xproto;
    inherit libpng zlib;
  };

  micropolis = callPackage ../games/micropolis { };

  openttd = callPackage ../games/openttd {
    zlib = zlibStatic;
  };

  pioneers = import ../games/pioneers {
    inherit stdenv fetchurl pkgconfig intltool;
    inherit (gtkLibs) gtk /*glib gtkmm*/;
  };

  quake3demo = callPackage ../games/quake3/wrapper {
    name = "quake3-demo-${quake3game.name}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    game = quake3game;
    paks = [quake3demodata];
  };

  quake3demodata = callPackage ../games/quake3/demo { };

  quake3game = callPackage ../games/quake3/game { };

  rogue = callPackage ../games/rogue { };

  scummvm = callPackage ../games/scummvm { };

  scorched3d = callPackage ../games/scorched3d {
    wxGTK = wxGTK26;
  };

  sgtpuzzles = builderDefsPackage (import ../games/sgt-puzzles) {
    inherit (gtkLibs) gtk;
    inherit pkgconfig fetchsvn perl;
    inherit (xlibs) libX11;
  };

  six = callPackage ../games/six {
    inherit (kde3) arts kdelibs;
  };

  # You still can override by passing more arguments.
  spaceOrbit = callPackage ../games/orbit {
    inherit (gnome) esound;  };

  superTux = callPackage ../games/super-tux { };

  superTuxKart = callPackage ../games/super-tux-kart { };

  teeworlds = callPackage ../games/teeworlds { };

  tennix = callPackage ../games/tennix { };

  /*tpm = import ../games/thePenguinMachine {
    inherit stdenv fetchurl pil pygame SDL;
    python24 = python;
  };*/

  tremulous = callPackage ../games/tremulous { };

  torcs = callPackage ../games/torcs {
    # Torcs wants to make shared libraries linked with plib libraries (it provides static).
    # i686 is the only platform I know than can do that linking without plib built with -fPIC
    plib = plib.override { enablePIC = if stdenv.isi686 then false else true; };
  };

  ufoai = callPackage ../games/ufoai {
    inherit (gtkLibs) glib gtk;
    inherit (gnome) gtksourceview gtkglext;
  };

  ultimatestunts = callPackage ../games/ultimatestunts { };

  urbanterror = callPackage ../games/urbanterror { };

  ut2004demo = callPackage ../games/ut2004demo { };

  warsow = callPackage ../games/warsow {
    libjpeg = libjpeg62;
  };

  warzone2100 = callPackage ../games/warzone2100 {
    flex = flex2535;
  };

  xboard = builderDefsPackage (import ../games/xboard) {
    inherit (xlibs) libX11 xproto libXt libXaw libSM
      libICE libXmu libXext libXpm;
    inherit gnuchess texinfo;
  };

  xsokoban = builderDefsPackage (import ../games/xsokoban) {
    inherit (xlibs) libX11 xproto libXpm libXt;
  };

  zdoom = callPackage ../games/zdoom { };

  zoom = callPackage ../games/zoom { };

  keen4 = callPackage ../games/keen4 { };


  ### DESKTOP ENVIRONMENTS


  enlightenment = callPackage ../desktops/enlightenment { };

  gnome28 = recurseIntoAttrs (import ../desktops/gnome-2.28 pkgs);

  gnome = gnome28;

  kde3 = recurseIntoAttrs {

    kdelibs = callPackage ../desktops/kde-3/kdelibs {
      stdenv = overrideGCC stdenv gcc43;
      qt = qt3;
    };

    kdebase = callPackage ../desktops/kde-3/kdebase {
      stdenv = overrideGCC stdenv gcc43;
      inherit (kde3) kdelibs;
      qt = qt3;
    };

    arts = callPackage ../development/libraries/arts {
      qt = qt3;
      inherit (gnome) glib;
      inherit (kde3) kdelibs;
    };

    k3b = callPackage ../applications/misc/k3b {
      inherit (kde3) kdelibs;
    };

    kbasket = callPackage ../applications/misc/kbasket {
      stdenv = overrideGCC stdenv gcc43;
      inherit (kde3) kdelibs;
    };

    kile = callPackage ../applications/editors/kile {
      inherit (kde3) arts kdelibs;
      qt = qt3;
    };

    kphone = callPackage ../applications/networking/kphone {
      qt = qt3;
      stdenv = overrideGCC stdenv gcc42; # I'm to lazy to clean up header files
    };

    kuickshow = callPackage ../applications/graphics/kuickshow {
      inherit (kde3) arts kdelibs;
      qt = qt3;
    };

    kcachegrind = callPackage ../development/tools/misc/kcachegrind {
      inherit (kde3) kdelibs;
      qt = qt3;
    };

  };

  kde4 = kde44;

  kde44 = makeOverridable (import ../desktops/kde-4.4) (pkgs // {
    qt4 = pkgs.qt46;
    stdenv = pkgs.stdenv2;
  });

  kde45 = callPackage ../desktops/kde-4.5 {
    callPackage = newScope ({
      qjson  = pkgs.qjson.override { inherit (pkgs.kde45) qt4; };
      pyqt4 = pkgs.pyqt4.override { inherit (pkgs.kde45) qt4; };
      libdbusmenu_qt = pkgs.libdbusmenu_qt.override { inherit (pkgs.kde45) qt4; };
      libktorrent = pkgs.libktorrent.override {
        inherit (pkgs.kde45) qt4 kdelibs;
      };
      shared_desktop_ontologies = pkgs.shared_desktop_ontologies.override { v = "0.5"; };
      stdenv = pkgs.stdenv2;
    } // pkgs.kde45);
  };

  xfce = xfce4;

  xfce4 = recurseIntoAttrs
    (let callPackage = newScope pkgs.xfce4; in
     import ../desktops/xfce-4 { inherit callPackage pkgs; });


  ### SCIENCE

  xplanet = callPackage ../applications/science/xplanet {
    inherit (gtkLibs) pango;
  };


  ### SCIENCE/GEOMETRY

  drgeo = builderDefsPackage (import ../applications/science/geometry/drgeo) {
    inherit (gnome) libglade gtk;
    inherit libxml2 guile perl intltool libtool pkgconfig;
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

  /* slr = import ../applications/science/biology/slr {
    inherit fetchurl stdenv liblapack;
  }; */

  pal2nal = callPackage ../applications/science/biology/pal2nal { };


  ### SCIENCE/MATH

  atlas = callPackage ../development/libraries/science/math/atlas { };

  blas = callPackage ../development/libraries/science/math/blas { };

  content = builderDefsPackage ../applications/science/math/content {
    inherit mesa lesstif;
    inherit (xlibs) libX11 libXaw xproto libXt libSM libICE
      libXmu libXext libXcursor;
  };

  liblapack = callPackage ../development/libraries/science/math/liblapack { };


  ### SCIENCE/LOGIC

  coq = callPackage ../applications/science/logic/coq {
    camlp5 = camlp5_transitional;
  };

  coq_beta = callPackage ../applications/science/logic/coq/beta.nix {
    camlp5 = camlp5_transitional;
  };

  eprover = callPackage ../applications/science/logic/eProver {
    texLive = texLiveAggregationFun {
      paths = [
        texLive texLiveExtra
      ];
  };
  };

  hol = callPackage ../applications/science/logic/hol { };

  hol_light = callPackage ../applications/science/logic/hol_light { };

  hol_light_binaries = callPackage ../applications/science/logic/hol_light/binaries.nix { };

  isabelle = import ../applications/science/logic/isabelle {
    inherit (pkgs) stdenv fetchurl nettools perl polyml;
    inherit (pkgs.emacs23Packages) proofgeneral;
  };

  prover9 = callPackage ../applications/science/logic/prover9 { };

  ssreflect = callPackage ../applications/science/logic/ssreflect {
    camlp5 = camlp5_transitional;
  };

  ### SCIENCE / ELECTRONICS

  kicad = callPackage ../applications/science/electronics/kicad {
    stdenv = stdenv2;
  };

  ngspice = callPackage ../applications/science/electronics/ngspice { };

  gtkwave = callPackage ../applications/science/electronics/gtkwave {
    inherit (gtkLibs) gtk;
  };

  xoscope = callPackage ../applications/science/electronics/xoscope {
    inherit (gtkLibs) gtk;
  };


  ### SCIENCE / MATH

  maxima = callPackage ../applications/science/math/maxima { };

  wxmaxima = callPackage ../applications/science/math/wxmaxima { };

  scilab = callPackage ../applications/science/math/scilab {
    inherit (gtkLibs) gtk;

    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };

  yacas = callPackage ../applications/science/math/yacas { };

  ### SCIENCE / MISC

  golly = callPackage ../applications/science/misc/golly { };

  simgrid = callPackage ../applications/science/misc/simgrid {
    stdenv = stdenv2;
  };

  tulip = callPackage ../applications/science/misc/tulip {
    qt = qt4;
  };

  vite = callPackage ../applications/science/misc/vite {
    qt = qt4;
    stdenv = stdenv2;
  };

  ### MISC

  atari800 = callPackage ../misc/emulators/atari800 { };

  ataripp = callPackage ../misc/emulators/atari++ { };

  auctex = callPackage ../misc/tex/auctex { };

  busybox = callPackage ../misc/busybox {
    enableStatic = true;
  };

  cups = callPackage ../misc/cups { };

  gutenprint = callPackage ../misc/drivers/gutenprint { };

  gutenprintBin = callPackage ../misc/drivers/gutenprint/bin.nix { };

  cupsBjnp = callPackage ../misc/cups/drivers/cups-bjnp { };

  dblatex = callPackage ../misc/tex/dblatex { };

  dosbox = callPackage ../misc/emulators/dosbox { };

  dpkg = callPackage ../tools/package-management/dpkg { };

  ekiga = lib.callPackageWith (pkgs // pkgs.xorg // pkgs.gtkLibs // pkgs.gnome)
    ../applications/networking/ekiga {};

  electricsheep = callPackage ../misc/screensavers/electricsheep { };

  foldingathome = callPackage ../misc/foldingathome { };

  freestyle = callPackage ../misc/freestyle {
    #stdenv = overrideGCC stdenv gcc41;
  };

  gajim = builderDefsPackage (import ../applications/networking/instant-messengers/gajim) {
    inherit perl intltool pyGtkGlade gettext pkgconfig makeWrapper pygobject
      pyopenssl gtkspell libsexy pycrypto aspell pythonDBus pythonSexy
      docutils;
    dbus = dbus.libs;
    inherit (gnome) gtk libglade;
    inherit (xlibs) libXScrnSaver libXt xproto libXext xextproto libX11
      scrnsaverproto;
    python = pythonFull;
  };

  generator = callPackage ../misc/emulators/generator {
    inherit (gtkLibs1x) gtk;
  };

  gensgs = callPackage_i686 ../misc/emulators/gens-gs { };

  ghostscript = callPackage ../misc/ghostscript {
    x11Support = false;
    cupsSupport = getPkgConfig "ghostscript" "cups" true;
  };

  ghostscriptX = lowPrio (appendToName "with-X" (ghostscript.override {
    x11Support = true;
  }));

  gxemul = callPackage ../misc/gxemul { };

  hplip = callPackage ../misc/drivers/hplip {
    qtSupport = true;
  };

  # using the new configuration style proposal which is unstable
  jackaudio = callPackage ../misc/jackaudio { };

  keynav = callPackage ../tools/X11/keynav { };

  lazylist = callPackage ../misc/tex/lazylist { };

  lilypond = callPackage ../misc/lilypond {
    inherit (gtkLibs) pango;
    flex = flex2535;
  };

  martyr = callPackage ../development/libraries/martyr { };

  maven = callPackage ../misc/maven/maven-1.0.nix { };

  maven2 = callPackage ../misc/maven { };

  mess = callPackage ../misc/emulators/mess { };

  nix = nixStable;

  nixStable = callPackage ../tools/package-management/nix {
    storeDir = getPkgConfig "nix" "storeDir" "/nix/store";
    stateDir = getPkgConfig "nix" "stateDir" "/nix/var";
  };

  nixUnstable = nixStable;
  /*
  nixUnstable = callPackage ../tools/package-management/nix/unstable.nix {
    storeDir = getPkgConfig "nix" "storeDir" "/nix/store";
    stateDir = getPkgConfig "nix" "stateDir" "/nix/var";
  };
  */

  # The SQLite branch.
  nixSqlite = lowPrio (makeOverridable (import ../tools/package-management/nix/sqlite.nix) {
    inherit fetchurl stdenv perl curl bzip2 openssl sqlite;
    storeDir = getPkgConfig "nix" "storeDir" "/nix/store";
    stateDir = getPkgConfig "nix" "stateDir" "/nix/var";
  });

  nixCustomFun = src: preConfigure: enableScripts: configureFlags:
    import ../tools/package-management/nix/custom.nix {
      inherit fetchurl stdenv perl curl bzip2 openssl src preConfigure automake
        autoconf libtool configureFlags enableScripts lib bison libxml2;
      flex = flex2533;
      aterm = aterm25;
      db4 = db45;
      inherit docbook5_xsl libxslt docbook5 docbook_xml_dtd_43 w3m;
    };

  disnix = callPackage ../tools/package-management/disnix { };

  disnix_activation_scripts = callPackage ../tools/package-management/disnix/activation-scripts { };

  DisnixService = callPackage ../tools/package-management/disnix/DisnixService { };

  latex2html = callPackage ../misc/tex/latex2html/default.nix {
    tex = tetex;
  };

  pgadmin = callPackage ../applications/misc/pgadmin { };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = callPackage ../misc/tex/pgf/1.x.nix { };

  pgf2 = callPackage ../misc/tex/pgf/2.x.nix { };

  polytable = callPackage ../misc/tex/polytable { };

  psi = makeOverridable (callPackage ../applications/networking/instant-messengers/psi) {
    qca2 = kde45.qca2;
    qca2_ossl = kde45.qca2_ossl;
    qt4 = qt47;
  };

  putty = callPackage ../applications/networking/remote/putty {
    inherit (gtkLibs) gtk;
  };

  rssglx = callPackage ../misc/screensavers/rss-glx { };

  xlockmore = callPackage ../misc/screensavers/xlockmore {
    pam = if getPkgConfig "xlockmore" "pam" true then pam else null;
  };

  saneBackends = callPackage ../misc/sane-backends {
    gt68xxFirmware = getConfig ["sane" "gt68xxFirmware"] null;
  };

  saneFrontends = callPackage ../misc/sane-front {
    inherit (gtkLibs) gtk;
  };

  sourceAndTags = import ../misc/source-and-tags {
    inherit pkgs stdenv unzip lib ctags;
    hasktags = haskellPackages.myhasktags;
  };

  splix = callPackage ../misc/cups/drivers/splix { };

  tetex = callPackage ../misc/tex/tetex { };

  tex4ht = callPackage ../misc/tex/tex4ht { };

  texFunctions = import ../misc/tex/nix pkgs;

  texLive = builderDefsPackage (import ../misc/tex/texlive) {
    inherit builderDefs zlib bzip2 ncurses libpng ed
      gd t1lib freetype icu perl ruby expat curl
      libjpeg bison python fontconfig;
    inherit (xlibs) libXaw libX11 xproto libXt libXpm
      libXmu libXext xextproto libSM libICE;
    flex = flex2535;
    ghostscript = ghostscriptX;
  };

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
    (builderDefsPackage (import ../misc/tex/texlive/aggregate.nix));

  texLiveContext = builderDefsPackage (import ../misc/tex/texlive/context.nix) {
    inherit texLive;
  };

  texLiveExtra = builderDefsPackage (import ../misc/tex/texlive/extra.nix) {
    inherit texLive;
  };

  texLiveCMSuper = builderDefsPackage (import ../misc/tex/texlive/cm-super.nix) {
    inherit texLive;
  };

  texLiveLatexXColor = builderDefsPackage (import ../misc/tex/texlive/xcolor.nix) {
    inherit texLive;
  };

  texLivePGF = builderDefsPackage (import ../misc/tex/texlive/pgf.nix) {
    inherit texLiveLatexXColor texLive;
  };

  texLiveBeamer = builderDefsPackage (import ../misc/tex/texlive/beamer.nix) {
    inherit texLiveLatexXColor texLivePGF texLive;
  };

  trac = callPackage ../misc/trac {
    inherit (pythonPackages) pysqlite;
  };

  vice = callPackage ../misc/emulators/vice {
    inherit (gtkLibs) gtk;
  };

  # Wine cannot be built in 64-bit; use a 32-bit build instead.
  wine = callPackage_i686 ../misc/emulators/wine {
    flex = pkgsi686Linux.flex2535;
  };

  x2x = callPackage ../tools/X11/x2x { };

  xosd = callPackage ../misc/xosd { };

  xsane = callPackage ../misc/xsane {
    inherit (gtkLibs) gtk;
  };

  yafc = callPackage ../applications/networking/yafc { };

  myEnvFun = import ../misc/my-env {
    inherit substituteAll pkgs;
    inherit (stdenv) mkDerivation;
  };

  misc = import ../misc/misc.nix { inherit pkgs stdenv; };

}; in pkgs
