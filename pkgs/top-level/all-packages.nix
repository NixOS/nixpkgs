/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform.

   You want to get to know where to add a new package ?
   Have a look at nixpkgs/maintainers/docs/classification.txt */


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
      # { pkgsOrig, pkgs, ... } : { /* the config */ }
      if builtins.isFunction configExpr
        then configExpr { inherit pkgs pkgsOrig; }
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
  # `__overrides' is a magic attribute that causes the attributes in
  # its value to be added to the surrounding `rec'.  The
  # `packageOverrides' function is called with the *original*
  # (un-overriden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  __overrides = (getConfig ["packageOverrides"] (pkgs: {})) pkgsOrig;

  pkgsOrig = pkgsFun {}; # the un-overriden packages, passed to packageOverrides
  pkgsOverriden = pkgsFun __overrides; # the overriden, final packages
  pkgs = pkgsOverriden // helperFunctions;


  # The package compositions.  Yes, this isn't properly indented.
  pkgsFun = __overrides: with helperFunctions; rec {

  # Override system. This is useful to build i686 packages on x86_64-linux.
  forceSystem = system: (import ./all-packages.nix) {
    inherit system;
    inherit bootStdenv noSysDirs gccWithCC gccWithProfiling config;
  };

  # Used by wine, firefox with debugging version of Flash, ...
  pkgsi686Linux = forceSystem "i686-linux";

  inherit __overrides;


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

  inherit (lib) lowPrio appendToName makeOverridable;

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // {recurseForDerivations = true;};

  useFromStdenv = it : alternative : if ((bootStdenv != null ||
    crossSystem == null) && builtins.hasAttr it stdenv) then
    (builtins.getAttr it stdenv) else alternative;

  # Return the first available value in the order: pkg.val, val, or default.
  getPkgConfig = pkg : val : default : (getConfig [ pkg val ] (getConfig [ val ] default));

  # Check absence of non-used options
  checker = x: flag: opts: config:
    (if flag then let result=(
      (import ../build-support/checker)
      opts config); in
      (if (result=="") then x else
      abort ("Unknown option specified: " + result))
    else x);

  builderDefs = composedArgsAndFun (import ../build-support/builder-defs/builder-defs.nix) {
    inherit stringsWithDeps lib stdenv writeScript
      fetchurl fetchmtn fetchgit;
  };

  composedArgsAndFun = lib.composedArgsAndFun;

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

  debPackage = {
    debBuild = lib.sumTwoArgs(import ../build-support/deb-package) {
      inherit builderDefs;
    };
    inherit fetchurl stdenv;
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

  # `fetchurl' downloads a file from the network.  The `useFromStdenv'
  # is there to allow stdenv to determine fetchurl.  Used during the
  # stdenv-linux bootstrap phases to prevent lots of different curls
  # from being built.
  fetchurl = useFromStdenv "fetchurl"
    (import ../build-support/fetchurl {
      curl = curl;
      stdenv = stdenv;
    });

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

  nukeReferences = import ../build-support/nuke-references/default.nix {
    inherit stdenv;
  };

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

  acct = import ../tools/system/acct {
    inherit fetchurl stdenv;
  };

  aefs = import ../tools/filesystems/aefs {
    inherit fetchurl stdenv fuse;
  };

  aircrackng = import ../tools/networking/aircrack-ng {
    inherit fetchurl stdenv libpcap openssl zlib wirelesstools;
  };

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

  ec2apitools = import ../tools/virtualization/amazon-ec2-api-tools {
    inherit stdenv fetchurl unzip makeWrapper jre;
  };

  ec2amitools = import ../tools/virtualization/amazon-ec2-ami-tools {
    inherit stdenv fetchurl unzip makeWrapper ruby openssl;
  };

  amule = import ../tools/networking/p2p/amule {
    inherit fetchurl stdenv zlib perl cryptopp gettext libupnp makeWrapper
      wxGTK pkgconfig;
  };

  aria = builderDefsPackage (import ../tools/networking/aria) {
  };

  aria2 = import ../tools/networking/aria2 {
    inherit fetchurl stdenv openssl libxml2 zlib;
  };

  at = import ../tools/system/at {
    inherit fetchurl stdenv bison flex pam ssmtp;
  };

  autogen = import ../development/tools/misc/autogen {
    inherit fetchurl stdenv guile which;
  };

  autojump = import ../tools/misc/autojump {
    inherit fetchurl stdenv python;
  };

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

  axel = import ../tools/networking/axel {
    inherit fetchurl stdenv;
  };

  azureus = import ../tools/networking/p2p/azureus {
    inherit fetchurl stdenv jdk swt;
  };

  bc = import ../tools/misc/bc {
    inherit fetchurl stdenv flex readline;
  };

  bfr = import ../tools/misc/bfr {
    inherit fetchurl stdenv perl;
  };

  bootchart = import ../tools/system/bootchart {
    inherit fetchurl stdenv gnutar gzip coreutils utillinux gnugrep gnused psmisc nettools;
  };

  btrfsProgs = builderDefsPackage (import ../tools/filesystems/btrfsprogs) {
    inherit libuuid zlib acl;
  };

  catdoc = import ../tools/text/catdoc {
    inherit fetchurl stdenv;
  };

  eggdrop = import ../tools/networking/eggdrop {
    inherit fetchurl stdenv tcl;
  };

  mcrl = import ../tools/misc/mcrl {
    inherit fetchurl stdenv coreutils;
  };

  mcrl2 = import ../tools/misc/mcrl2 {
    inherit fetchurl stdenv mesa ;
    inherit (xorg) libX11;
    inherit wxGTK;
  };

  syslogng = import ../tools/misc/syslog-ng {
    inherit fetchurl stdenv eventlog pkgconfig glib;
  };

  asciidoc = import ../tools/typesetting/asciidoc {
    inherit fetchurl stdenv python;
  };

  autossh = import ../tools/networking/autossh {
    inherit stdenv fetchurl openssh;
  };

  bibtextools = import ../tools/typesetting/bibtex-tools {
    inherit fetchurl stdenv aterm tetex hevea;
    inherit (strategoPackages016) strategoxt sdf;
  };

  bittorrent = import ../tools/networking/p2p/bittorrent {
    inherit fetchurl stdenv makeWrapper python pycrypto twisted;
    wxPython = wxPython26;
    gui = true;
  };

  bittornado = import ../tools/networking/p2p/bit-tornado {
    inherit fetchurl stdenv python wxPython26;
  };

  bmrsa = builderDefsPackage (import ../tools/security/bmrsa/11.nix) {
    inherit unzip;
  };

  bogofilter = import ../tools/misc/bogofilter {
    inherit fetchurl stdenv flex;
    bdb = db4;
  };

  bsdiff = import ../tools/compression/bsdiff {
    inherit fetchurl stdenv;
  };

  bzip2 = useFromStdenv "bzip2"
    (import ../tools/compression/bzip2 {
      inherit fetchurl stdenv;
    });

  cabextract = import ../tools/archivers/cabextract {
    inherit fetchurl stdenv;
  };

  ccid = import ../tools/security/ccid {
    inherit fetchurl stdenv pcsclite libusb pkgconfig perl;
  };

  ccrypt = import ../tools/security/ccrypt {
    inherit fetchurl stdenv;
  };

  cdecl = import ../development/tools/cdecl {
    inherit fetchurl stdenv yacc flex readline ncurses;
  };

  cdrdao = import ../tools/cd-dvd/cdrdao {
    inherit fetchurl stdenv lame libvorbis libmad pkgconfig libao;
  };

  cdrkit = import ../tools/cd-dvd/cdrkit {
    inherit fetchurl stdenv cmake libcap zlib bzip2;
  };

  cfdg = builderDefsPackage ../tools/graphics/cfdg {
    inherit libpng bison flex;
  };

  checkinstall = import ../tools/package-management/checkinstall {
    inherit fetchurl stdenv gettext;
  };

  cheetahTemplate = builderDefsPackage (import ../tools/text/cheetah-template/2.0.1.nix) {
    inherit makeWrapper python;
  };

  chkrootkit = import ../tools/security/chkrootkit {
    inherit fetchurl stdenv;
  };

  cksfv = import ../tools/networking/cksfv {
    inherit fetchurl stdenv;
  };

  convertlit = import ../tools/text/convertlit {
    inherit fetchurl stdenv unzip libtommath;
  };

  unifdef = import ../development/tools/misc/unifdef {
    inherit fetchurl stdenv;
  };

  usb_modeswitch = import ../development/tools/misc/usb-modeswitch {
    inherit stdenv fetchurl libusb;
  };

  cloogppl = import ../development/libraries/cloog-ppl {
    inherit fetchurl stdenv ppl;
  };

  coreutils_real = makeOverridable (if stdenv ? isDietLibC
      then import ../tools/misc/coreutils-5
      else import ../tools/misc/coreutils)
    {
      inherit fetchurl stdenv acl perl gmp;

      # TODO: Add ACL support for cross-Linux.
      aclSupport = (crossSystem == null) && stdenv.isLinux;
    };

  coreutils = useFromStdenv "coreutils" coreutils_real;

  cpio = import ../tools/archivers/cpio {
    inherit fetchurl stdenv;
  };

  cromfs = import ../tools/archivers/cromfs {
    inherit fetchurl stdenv pkgconfig fuse perl;
  };

  cron = import ../tools/system/cron { # see also fcron
    inherit fetchurl stdenv;
  };

  curl = makeOverridable (import ../tools/networking/curl) {
    fetchurl = fetchurlBoot;
    inherit stdenv zlib openssl;
    zlibSupport = ! ((stdenv ? isDietLibC) || (stdenv ? isStatic));
    sslSupport = ! ((stdenv ? isDietLibC) || (stdenv ? isStatic));
  };

  curlftpfs = import ../tools/filesystems/curlftpfs {
    inherit fetchurl stdenv fuse curl pkgconfig zlib glib;
  };

  dadadodo = builderDefsPackage (import ../tools/text/dadadodo) {
  };

  dar = import ../tools/archivers/dar {
    inherit fetchurl stdenv zlib bzip2 openssl;
  };

  davfs2 = import ../tools/filesystems/davfs2 {
    inherit fetchurl stdenv zlib;
    neon = neon028;
  };

  dcraw = import ../tools/graphics/dcraw {
    inherit fetchurl stdenv gettext libjpeg lcms;
  };

  debootstrap = import ../tools/misc/debootstrap {
    inherit fetchurl stdenv lib dpkg gettext gawk wget perl;
  };

  ddclient = import ../tools/networking/ddclient {
    inherit fetchurl buildPerlPackage perl;
  };

  ddrescue = import ../tools/system/ddrescue {
    inherit fetchurl stdenv;
  };

  desktop_file_utils = import ../tools/misc/desktop-file-utils {
    inherit stdenv fetchurl pkgconfig glib;
  };

  dev86 = import ../development/compilers/dev86 {
    inherit fetchurl stdenv;
  };

  dnsmasq = import ../tools/networking/dnsmasq {
    # TODO i18n can be installed as well, implement it?
    inherit fetchurl stdenv;
  };

  dhcp = import ../tools/networking/dhcp {
    inherit fetchurl stdenv nettools iputils iproute makeWrapper;
  };

  dhcpcd = import ../tools/networking/dhcpcd {
    inherit fetchurl stdenv;
  };

  diffstat = import ../tools/text/diffstat {
    inherit fetchurl stdenv;
  };

  diffutils = useFromStdenv "diffutils"
    (import ../tools/text/diffutils {
      inherit fetchurl stdenv coreutils;
    });

  dirmngr = import ../tools/security/dirmngr {
    inherit stdenv fetchurl libgpgerror libgcrypt libassuan libksba openldap;
  };

  docbook2x = import ../tools/typesetting/docbook2x {
    inherit fetchurl stdenv texinfo perl
            gnused groff libxml2 libxslt makeWrapper;
    inherit (perlPackages) XMLSAX XMLParser XMLNamespaceSupport;
    libiconv = if stdenv.isDarwin then libiconv else null;
  };

  dosfstools = composedArgsAndFun (import ../tools/filesystems/dosfstools) {
    inherit builderDefs;
  };

  dropbear = makeOverridable (import ../tools/networking/dropbear) {
    inherit fetchurl stdenv;
    enableStatic = true;
    zlib = zlibStatic;
  };

  duplicity = import ../tools/backup/duplicity {
    inherit fetchurl stdenv librsync makeWrapper python;
    inherit (pythonPackages) boto;
    gnupg = gnupg1;
  };

  dvdplusrwtools = import ../tools/cd-dvd/dvd+rw-tools {
    inherit fetchurl stdenv cdrkit m4;
  };

  e2fsprogs = import ../tools/filesystems/e2fsprogs {
    inherit fetchurl stdenv pkgconfig libuuid;
  };

  ecryptfs = import ../tools/security/ecryptfs {
    inherit fetchurl stdenv fuse python perl keyutils pam nss nspr;
  };

  enblendenfuse = import ../tools/graphics/enblend-enfuse {
    inherit fetchurl stdenv libtiff libpng lcms libxmi boost;
  };

  enscript = import ../tools/text/enscript {
    inherit fetchurl stdenv gettext;
  };

  eprover = composedArgsAndFun (import ../tools/misc/eProver) {
    inherit fetchurl stdenv which;
    texLive = texLiveAggregationFun {
      paths = [
        texLive texLiveExtra
      ];
    };
  };

  ethtool = import ../tools/misc/ethtool {
    inherit fetchurl stdenv;
  };

  exif = import ../tools/graphics/exif {
    inherit fetchurl stdenv pkgconfig libexif popt;
  };

  exiftags = import ../tools/graphics/exiftags {
    inherit stdenv fetchurl;
  };

  expect = import ../tools/misc/expect {
    inherit fetchurl stdenv tcl tk autoconf;
    inherit (xorg) xproto libX11;
  };

  fcron = import ../tools/system/fcron { # see also cron
    inherit fetchurl stdenv perl;
  };

  fdisk = import ../tools/system/fdisk {
    inherit fetchurl stdenv parted libuuid gettext;
  };

  figlet = import ../tools/misc/figlet {
    inherit fetchurl stdenv;
  };

  file = import ../tools/misc/file {
    inherit fetchurl stdenv;
  };

  findutils = useFromStdenv "findutils"
    (if stdenv.isDarwin then findutils4227 else
      import ../tools/misc/findutils {
        inherit fetchurl stdenv coreutils;
      }
    );

  findutils4227 = import ../tools/misc/findutils/4.2.27.nix {
    inherit fetchurl stdenv coreutils;
  };

  findutilsWrapper = lowPrio (appendToName "wrapper" (import ../tools/misc/findutils-wrapper {
    inherit stdenv findutils;
  }));

  finger_bsd = import ../tools/networking/bsd-finger {
    inherit fetchurl stdenv;
  };

  fontforge = import ../tools/misc/fontforge {
    inherit fetchurl stdenv gettext freetype zlib
      libungif libpng libjpeg libtiff libxml2 lib;
  };

  fontforgeX = import ../tools/misc/fontforge {
    inherit fetchurl stdenv gettext freetype zlib
      libungif libpng libjpeg libtiff libxml2 lib;
    inherit (xlibs) libX11 xproto libXt;
  };

  dos2unix = import ../tools/text/dos2unix {
    inherit fetchurl stdenv;
  };

  unix2dos = import ../tools/text/unix2dos {
    inherit fetchurl stdenv;
  };

  gawk = useFromStdenv "gawk"
    (import ../tools/text/gawk {
      inherit fetchurl stdenv;
    });

  gdmap = composedArgsAndFun (import ../tools/system/gdmap/0.8.1.nix) {
    inherit stdenv fetchurl builderDefs pkgconfig libxml2 intltool
      gettext;
    inherit (gtkLibs) gtk;
  };

  genext2fs = import ../tools/filesystems/genext2fs {
    inherit fetchurl stdenv;
  };

  gengetopt = import ../development/tools/misc/gengetopt {
    inherit fetchurl stdenv;
  };

  getopt = import ../tools/misc/getopt {
    inherit fetchurl stdenv;
  };

  gftp = import ../tools/networking/gftp {
    inherit lib fetchurl stdenv;
    inherit readline ncurses gettext openssl pkgconfig;
    inherit (gtkLibs) glib gtk;
  };

  gifsicle = import ../tools/graphics/gifscile {
    inherit fetchurl stdenv;
    inherit (xlibs) xproto libXt libX11;
  };

  glusterfs = builderDefsPackage ../tools/filesystems/glusterfs {
    inherit fuse;
    bison = bison24;
    flex = flex2535;
  };

  glxinfo = import ../tools/graphics/glxinfo {
    inherit fetchurl stdenv x11 mesa;
  };

  gnokii = builderDefsPackage (import ../tools/misc/gnokii) {
    inherit intltool perl gettext libusb;
  };

  gnugrep = useFromStdenv "gnugrep"
    (import ../tools/text/gnugrep {
      inherit fetchurl stdenv pcre;
    });

  gnupatch = useFromStdenv "patch" (import ../tools/text/gnupatch {
    inherit fetchurl stdenv ed;
  });

  gnupg1orig = makeOverridable (import ../tools/security/gnupg1) {
    inherit fetchurl stdenv readline bzip2;
    ideaSupport = false;
  };

  gnupg1compat = import ../tools/security/gnupg1compat {
    inherit stdenv gnupg writeScript coreutils;
  };

  # use config.packageOverrides if you prefer original gnupg1
  gnupg1 = gnupg1compat;

  gnupg = makeOverridable (import ../tools/security/gnupg) {
    inherit fetchurl stdenv readline libgpgerror libgcrypt libassuan pth libksba zlib
      openldap bzip2 libusb curl coreutils;
  };

  gnuplot = makeOverridable (import ../tools/graphics/gnuplot) {
    inherit fetchurl stdenv zlib gd texinfo readline emacs wxGTK;
    inherit (xlibs) libX11 libXt libXaw libXpm;
    inherit (gtkLibs) pango;
    inherit cairo pkgconfig;
  };

  gnused = useFromStdenv "gnused"
    (import ../tools/text/gnused {
      inherit fetchurl stdenv;
    });

  gnused_4_2 = import ../tools/text/gnused/4.2.nix {
    inherit fetchurl stdenv;
  };

  gnutar = useFromStdenv "gnutar"
    (import ../tools/archivers/gnutar {
      inherit fetchurl stdenv;
    });

  gnuvd = import ../tools/misc/gnuvd {
    inherit fetchurl stdenv;
  };

  graphviz = import ../tools/graphics/graphviz {
    inherit fetchurl stdenv pkgconfig libpng libjpeg expat x11 yacc
      libtool fontconfig gd;
    inherit (xlibs) libXaw;
    inherit (gtkLibs) pango;
  };

  groff = import ../tools/text/groff {
    inherit fetchurl stdenv perl;
    ghostscript = null;
  };

  grub = import ../tools/misc/grub {
    inherit fetchurl autoconf automake;
    stdenv = stdenv_32bit;
    buggyBiosCDSupport = (getConfig ["grub" "buggyBiosCDSupport"] true);
  };

  grub2 = import ../tools/misc/grub/1.9x.nix {
    inherit stdenv fetchurl bison ncurses libusb freetype;
  };

  gssdp = import ../development/libraries/gssdp {
    inherit fetchurl stdenv pkgconfig libxml2 glib;
    inherit (gnome) libsoup;
  };

  gt5 = import ../tools/system/gt5 {
    inherit fetchurl stdenv;
  };

  gtkgnutella = import ../tools/networking/p2p/gtk-gnutella {
    inherit fetchurl stdenv pkgconfig libxml2;
    inherit (gtkLibs) glib gtk;
  };

  gupnp = import ../development/libraries/gupnp {
    inherit fetchurl stdenv pkgconfig libxml2 gssdp e2fsprogs glib;
    inherit (gnome) libsoup;
  };

  gupnptools = import ../tools/networking/gupnp-tools {
    inherit fetchurl stdenv gssdp gupnp pkgconfig libxml2 e2fsprogs;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libsoup libglade gnomeicontheme;
  };

  gvpe = builderDefsPackage ../tools/networking/gvpe {
    inherit openssl gmp nettools iproute;
  };

  gzip = useFromStdenv "gzip"
    (import ../tools/compression/gzip {
      inherit fetchurl stdenv;
    });

  pigz = import ../tools/compression/pigz {
    inherit fetchurl stdenv zlib;
  };

  halibut = import ../tools/typesetting/halibut {
    inherit fetchurl stdenv perl;
  };

  hddtemp = import ../tools/misc/hddtemp {
    inherit fetchurl stdenv;
  };

  hevea = import ../tools/typesetting/hevea {
    inherit fetchurl stdenv ocaml;
  };

  highlight = import ../tools/text/highlight {
    inherit fetchurl stdenv getopt;
  };

  host = import ../tools/networking/host {
    inherit fetchurl stdenv;
  };

  iasl = import ../development/compilers/iasl {
    inherit fetchurl stdenv bison flex;
  };

  idutils = import ../tools/misc/idutils {
    inherit fetchurl stdenv emacs;
  };

  iftop = import ../tools/networking/iftop {
    inherit fetchurl stdenv ncurses libpcap;
  };

  imapsync = import ../tools/networking/imapsync {
    inherit fetchurl stdenv perl openssl;
    inherit (perlPackages) MailIMAPClient;
  };

  inetutils = import ../tools/networking/inetutils {
    inherit fetchurl stdenv ncurses;
  };

  iodine = import ../tools/networking/iodine {
    inherit stdenv fetchurl zlib nettools;
  };

  iperf = import ../tools/networking/iperf {
    inherit fetchurl stdenv;
  };

  ipmitool = makeOverridable (import ../tools/system/ipmitool) {
    inherit fetchurl stdenv openssl;
    static = false;
  };

  jdiskreport = import ../tools/misc/jdiskreport {
    inherit fetchurl stdenv unzip jdk;
  };

  jfsrec = import ../tools/filesystems/jfsrec {
    inherit fetchurl stdenv boost;
  };

  jfsutils = import ../tools/filesystems/jfsutils {
    inherit fetchurl stdenv libuuid;
  };

  jhead = import ../tools/graphics/jhead {
    inherit stdenv fetchurl;
  };

  jing = import ../tools/text/xml/jing {
    inherit fetchurl stdenv unzip;
  };

  jing_tools = import ../tools/text/xml/jing/jing-script.nix {
    inherit fetchurl stdenv unzip jre;
  };

  jnettop = import ../tools/networking/jnettop {
    inherit fetchurl stdenv autoconf libpcap ncurses pkgconfig;
    inherit (gnome) glib;
  };

  jwhois = import ../tools/networking/jwhois {
    inherit fetchurl stdenv;
  };

  keychain = import ../tools/misc/keychain {
    inherit fetchurl stdenv;
  };

  kismet = import ../applications/networking/sniffers/kismet {
    inherit fetchurl stdenv libpcap ncurses expat pcre;
  };

  ktorrent = kde4.ktorrent;

  less = import ../tools/misc/less {
    inherit fetchurl stdenv ncurses;
  };

  most = import ../tools/misc/most {
    inherit fetchurl stdenv slang;
  };

  lftp = import ../tools/networking/lftp {
    inherit fetchurl stdenv readline;
  };

  libtorrent = import ../tools/networking/p2p/libtorrent {
    inherit fetchurl stdenv pkgconfig openssl libsigcxx;
  };

  logrotate = import ../tools/system/logrotate {
    inherit fetchurl stdenv gzip popt;
  };

  lout = import ../tools/typesetting/lout {
    inherit fetchurl stdenv ghostscript;
  };

  lrzip = import ../tools/compression/lrzip {
    inherit fetchurl stdenv zlib lzo bzip2 nasm;
  };

  lsh = import ../tools/networking/lsh {
    inherit stdenv fetchurl gperf guile gmp zlib liboop gnum4 pam
      readline nettools lsof procps;
  };

  lzma = xz;

  xz = import ../tools/compression/xz {
    inherit fetchurl stdenv lib;
  };

  lzop = import ../tools/compression/lzop {
    inherit fetchurl stdenv lzo;
  };

  mailutils = import ../tools/networking/mailutils {
    inherit fetchurl stdenv gettext gdbm libtool pam readline ncurses
      gnutls mysql guile texinfo gnum4;
  };

  man = import ../tools/misc/man {
    inherit fetchurl stdenv groff less;
  };

  man_db = import ../tools/misc/man-db {
    inherit fetchurl stdenv db4 groff;
  };

  memtest86 = import ../tools/misc/memtest86 {
    inherit fetchurl stdenv;
  };

  mc = import ../tools/misc/mc {
    inherit fetchurl stdenv lib pkgconfig ncurses shebangfix perl zip unzip slang
      gettext e2fsprogs gpm glib;
    inherit (xlibs) libX11 libXt;
  };

  mcabber = import ../applications/networking/instant-messengers/mcabber {
    inherit fetchurl stdenv openssl ncurses pkgconfig glib;
  };

  mcron = import ../tools/system/mcron {
    inherit fetchurl stdenv guile which ed;
  };

  mdbtools = import ../tools/misc/mdbtools {
    inherit fetchurl stdenv readline pkgconfig bison glib;
    flex = flex2535;
  };

  miniupnpd = import ../tools/networking/miniupnpd {
    inherit fetchurl stdenv iptables;
  };

  mjpegtools = import ../tools/video/mjpegtools {
    inherit fetchurl stdenv libjpeg;
    inherit (xlibs) libX11;
  };

  mkisofs = import ../tools/cd-dvd/mkisofs {
    inherit fetchurl stdenv gettext;
  };

  mktemp = import ../tools/security/mktemp {
    inherit fetchurl stdenv;
  };

  mldonkey = import ../applications/networking/p2p/mldonkey {
    inherit fetchurl stdenv ocaml zlib bzip2 ncurses file gd libpng;
  };

  monit = builderDefsPackage ../tools/system/monit {
    flex = flex2535;
    bison = bison24;
    inherit openssl;
  };

  mpage = import ../tools/text/mpage {
    inherit fetchurl stdenv;
  };

  msf = builderDefsPackage (import ../tools/security/metasploit/3.1.nix) {
    inherit ruby makeWrapper;
  };

  mssys = import ../tools/misc/mssys {
    inherit fetchurl stdenv gettext;
  };

  mtdutils = import ../tools/filesystems/mtdutils {
    inherit stdenv fetchgit libuuid lzo zlib acl;
  };

  multitran = recurseIntoAttrs (let
      inherit fetchurl stdenv help2man;
    in rec {
      multitrandata = import ../tools/text/multitran/data {
        inherit fetchurl stdenv;
      };

      libbtree = import ../tools/text/multitran/libbtree {
        inherit fetchurl stdenv;
      };

      libmtsupport = import ../tools/text/multitran/libmtsupport {
        inherit fetchurl stdenv;
      };

      libfacet = import ../tools/text/multitran/libfacet {
        inherit fetchurl stdenv libmtsupport;
      };

      libmtquery = import ../tools/text/multitran/libmtquery {
        inherit fetchurl stdenv libmtsupport libfacet libbtree multitrandata;
      };

      mtutils = import ../tools/text/multitran/mtutils {
        inherit fetchurl stdenv libmtsupport libfacet libbtree libmtquery help2man;
      };
    });

  muscleframework = import ../tools/security/muscleframework {
    inherit fetchurl stdenv libmusclecard pkgconfig pcsclite;
  };

  muscletool = import ../tools/security/muscletool {
    inherit fetchurl stdenv pkgconfig libmusclecard pcsclite;
  };

  mysql2pgsql = import ../tools/misc/mysql2pgsql {
    inherit fetchurl stdenv perl shebangfix;
  };

  namazu = import ../tools/text/namazu {
    inherit fetchurl stdenv perl;
  };

  nbd = import ../tools/networking/nbd {
    inherit fetchurl stdenv pkgconfig glib;
  };

  nc6 = composedArgsAndFun (import ../tools/networking/nc6/1.0.nix) {
    inherit builderDefs;
  };

  ncat = import ../tools/networking/ncat {
    inherit fetchurl stdenv openssl;
  };

  ncftp = import ../tools/networking/ncftp {
    inherit fetchurl stdenv ncurses coreutils;
  };

  ncompress = import ../tools/compression/ncompress {
    inherit fetchurl stdenv;
  };

  netcat = import ../tools/networking/netcat {
    inherit fetchurl stdenv;
  };

  netkittftp = import ../tools/networking/netkit/tftp {
    inherit fetchurl stdenv;
  };

  netpbm = import ../tools/graphics/netpbm {
    inherit stdenv fetchsvn libjpeg libpng zlib flex perl libxml2 makeWrapper;
  };

  netselect = import ../tools/networking/netselect {
    inherit fetchurl stdenv;
  };

  nmap = import ../tools/security/nmap {
    inherit fetchurl stdenv libpcap pkgconfig openssl
      python pygtk makeWrapper pygobject pycairo;
    inherit (pythonPackages) pysqlite;
    inherit (xlibs) libX11;
    inherit (gtkLibs) gtk;
  };

  ntfs3g = import ../tools/filesystems/ntfs-3g {
    inherit fetchurl stdenv utillinux;
  };

  ntfsprogs = import ../tools/filesystems/ntfsprogs {
    inherit fetchurl stdenv libuuid;
  };

  ntp = import ../tools/networking/ntp {
    inherit fetchurl stdenv libcap;
  };

  nssmdns = import ../tools/networking/nss-mdns {
    inherit fetchurl stdenv avahi;
  };

  nylon = import ../tools/networking/nylon {
    inherit fetchurl stdenv libevent;
  };

  obexd = import ../tools/bluetooth/obexd {
    inherit fetchurl stdenv pkgconfig dbus openobex bluez glib;
  };

  obexfs = import ../tools/bluetooth/obexfs {
    inherit fetchurl stdenv pkgconfig fuse obexftp;
  };

  obexftp = import ../tools/bluetooth/obexftp {
    inherit fetchurl stdenv pkgconfig openobex bluez;
  };

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

  opendbx = import ../development/libraries/opendbx {
    inherit fetchurl stdenv readline mysql postgresql sqlite;
  };

  opendkim = import ../development/libraries/opendkim {
    inherit fetchurl stdenv openssl libmilter;
  };

  openjade = import ../tools/text/sgml/openjade {
    inherit fetchurl opensp perl;
    stdenv = overrideGCC stdenv gcc33;
  };

  openobex = import ../tools/bluetooth/openobex {
    inherit fetchurl stdenv pkgconfig bluez libusb;
  };

  opensc_0_11_7 = import ../tools/security/opensc/0.11.7.nix {
    inherit fetchurl stdenv libtool readline zlib openssl libiconv pcsclite
      libassuan1 pkgconfig pinentry;
    inherit (xlibs) libXt;
  };

  opensc = opensc_0_11_7;

  opensc_dnie_wrapper = import ../tools/security/opensc-dnie-wrapper {
    inherit stdenv makeWrapper ed libopensc_dnie;
  };

  openssh = makeOverridable (import ../tools/networking/openssh) {
    inherit fetchurl stdenv zlib openssl pam perl libedit pkgconfig;
    hpnSupport = false;
    etcDir = "/etc/ssh";
  };

  opensp = import ../tools/text/sgml/opensp {
    inherit fetchurl xmlto docbook_xml_dtd_412 libxslt docbook_xsl;
    inherit stdenv;
  };

  openvpn = import ../tools/networking/openvpn {
    inherit fetchurl stdenv iproute lzo openssl nettools;
  };

  optipng = import ../tools/graphics/optipng {
    inherit fetchurl stdenv;
  };

  p7zip = import ../tools/archivers/p7zip {
    inherit fetchurl stdenv;
  };

  panomatic = import ../tools/graphics/panomatic {
    inherit fetchurl stdenv boost zlib;
  };

  par2cmdline = import ../tools/networking/par2cmdline {
    inherit fetchurl stdenv;
  };

  parallel = import ../tools/misc/parallel {
    inherit fetchurl stdenv perl;
  };

  patchutils = import ../tools/text/patchutils {
    inherit fetchurl stdenv;
  };

  parted = import ../tools/misc/parted {
    inherit fetchurl stdenv devicemapper libuuid gettext readline
      utillinuxng xz;
  };

  patch = gnupatch;

  pbzip2 = import ../tools/compression/pbzip2 {
    inherit fetchurl stdenv bzip2;
  };

  pciutils = import ../tools/system/pciutils {
    inherit fetchurl stdenv zlib;
  };

  pcsclite = import ../tools/security/pcsclite {
    inherit fetchurl stdenv hal pkgconfig dbus;
  };

  pdf2djvu = import ../tools/typesetting/pdf2djvu {
    inherit fetchurl stdenv pkgconfig djvulibre poppler fontconfig libjpeg;
  };

  pdfjam = import ../tools/typesetting/pdfjam {
    inherit fetchurl stdenv;
  };

  pdfread = import ../tools/graphics/pdfread {
    inherit stdenv fetchurl unzip python makeWrapper ghostscript pngnq pil
      djvulibre unrar optipng;
  };

  pg_top = import ../tools/misc/pg_top {
    inherit fetchurl stdenv ncurses postgresql;
  };

  pdsh = makeOverridable (import ../tools/networking/pdsh) {
    inherit fetchurl stdenv perl readline pam;
    rsh = true;			# enable internal rsh implementation
    ssh = openssh;
  };

  pfstools = import ../tools/graphics/pfstools {
    inherit fetchurl stdenv imagemagick libjpeg libtiff mesa freeglut bzip2 libpng expat;
    openexr = openexr_1_6_1;
    qt = qt3;
    inherit (xlibs) libX11;
  };

  pinentry = makeOverridable (import ../tools/misc/pinentry) {
    inherit fetchurl stdenv pkgconfig ncurses qt4;
    inherit (gnome) glib gtk;
  };

  pk2cmd = import ../tools/misc/pk2cmd {
    inherit fetchurl stdenv libusb makeWrapper;
  };

  plan9port = import ../tools/system/plan9port {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 xproto libXt xextproto;
  };

  ploticus = import ../tools/graphics/ploticus {
    inherit fetchurl stdenv zlib libpng;
    inherit (xlibs) libX11;
  };

  plotutils = import ../tools/graphics/plotutils {
    inherit fetchurl stdenv libpng;
  };

  pngnq = import ../tools/graphics/pngnq {
    inherit fetchurl stdenv libpng;
  };

  povray = import ../tools/graphics/povray {
    inherit fetchurl stdenv;
  };

  ppl = import ../development/libraries/ppl {
    inherit fetchurl stdenv gmpxx perl gnum4;
  };

  /* WARNING: this version is unsuitable for using with a setuid wrapper */
  ppp = builderDefsPackage (import ../tools/networking/ppp) {
  };

  proxychains = import ../tools/networking/proxychains {
    inherit fetchurl stdenv;
  };

  proxytunnel = import ../tools/misc/proxytunnel {
    inherit fetchurl stdenv openssl;
  };

  psmisc = import ../tools/misc/psmisc {
    inherit stdenv fetchurl ncurses;
  };

  pstoedit = import ../tools/graphics/pstoedit {
    inherit fetchurl stdenv lib pkgconfig ghostscript gd zlib plotutils;
  };

  pv = import ../tools/misc/pv {
    inherit fetchurl stdenv;
  };

  pwgen = import ../tools/security/pwgen {
    inherit stdenv fetchurl;
  };

  pydb = import ../tools/pydb {
    inherit fetchurl stdenv python emacs;
  };

  pystringtemplate = import ../development/python-modules/stringtemplate {
    inherit stdenv fetchurl python antlr;
  };

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

  openmpi = import ../development/libraries/openmpi {
    inherit fetchurl stdenv;
  };

  qdu = import ../tools/misc/qdu {
      inherit stdenv fetchurl qt3;
      inherit (xlibs) libX11 libXext;
  };

  qhull = import ../development/libraries/qhull {
    inherit stdenv fetchurl;
  };

  qshowdiff = import ../tools/text/qshowdiff {
    inherit fetchurl stdenv perl;
    qt = qt4;
  };

  rtmpdump = import ../tools/video/rtmpdump {
    inherit fetchurl stdenv zlib gnutls;
  };

  reiser4progs = import ../tools/filesystems/reiser4progs {
    inherit fetchurl stdenv libaal;
  };

  reiserfsprogs = import ../tools/filesystems/reiserfsprogs {
    inherit fetchurl stdenv;
  };

  relfs = composedArgsAndFun (import ../tools/filesystems/relfs) {
    inherit fetchcvs stdenv ocaml postgresql fuse pcre
      builderDefs pkgconfig libuuid;
    inherit (gnome) gnomevfs GConf;
  };

  remind = import ../tools/misc/remind {
    inherit fetchurl stdenv;
  };

  replace = import ../tools/text/replace {
    inherit fetchurl stdenv;
  };

  /*
  rdiff_backup = import ../tools/backup/rdiff-backup {
    inherit fetchurl stdenv librsync gnused;
    python=python;
  };
  */

  rsnapshot = import ../tools/backup/rsnapshot {
    inherit fetchurl stdenv perl openssh rsync;

    # For the `logger' command, we can use either `utillinux' or
    # GNU Inetutils.  The latter is more portable.
    logger = inetutils;
  };

  rlwrap = composedArgsAndFun (import ../tools/misc/rlwrap/0.28.nix) {
    inherit builderDefs readline;
  };

  rpPPPoE = builderDefsPackage (import ../tools/networking/rp-pppoe) {
    inherit ppp;
  };

  rpm = import ../tools/package-management/rpm {
    inherit fetchurl stdenv cpio zlib bzip2 xz file elfutils nspr nss popt;
    db4 = db45;
  };

  rrdtool = import ../tools/misc/rrdtool {
    inherit stdenv fetchurl gettext perl pkgconfig libxml2 cairo;
    inherit (gtkLibs) pango;
  };

  rtorrent = import ../tools/networking/p2p/rtorrent {
    inherit fetchurl stdenv libtorrent ncurses pkgconfig libsigcxx curl zlib openssl;
  };

  rubber = import ../tools/typesetting/rubber {
    inherit fetchurl stdenv python texinfo;
  };

  rxp = import ../tools/text/xml/rxp {
    inherit fetchurl stdenv;
  };

  rzip = import ../tools/compression/rzip {
    inherit fetchurl stdenv bzip2;
  };

  s3backer = import ../tools/filesystems/s3backer {
    inherit fetchurl stdenv pkgconfig fuse curl expat;
  };

  s3sync = import ../tools/networking/s3sync {
    inherit fetchurl stdenv ruby makeWrapper;
  };

  sablotron = import ../tools/text/xml/sablotron {
    inherit fetchurl stdenv expat;
  };

  screen = import ../tools/misc/screen {
    inherit fetchurl stdenv ncurses;
  };

  scrot = import ../tools/graphics/scrot {
    inherit fetchurl stdenv giblib x11;
  };

  seccure = import ../tools/security/seccure/0.4.nix {
    inherit fetchurl stdenv libgcrypt;
  };

  setserial = builderDefsPackage (import ../tools/system/setserial) {
    inherit groff;
  };

  sharutils = import ../tools/archivers/sharutils {
    inherit fetchurl stdenv gettext;
  };

  shebangfix = import ../tools/misc/shebangfix {
    inherit stdenv perl;
  };

  slimrat = import ../tools/networking/slimrat {
    inherit fetchurl stdenv perl makeWrapper;
    inherit (perlPackages) WWWMechanize LWP;
  };

  slsnif = import ../tools/misc/slsnif {
    inherit fetchurl stdenv;
  };

  smartmontools = import ../tools/system/smartmontools {
    inherit fetchurl stdenv;
  };

  smbfsFuse = composedArgsAndFun (import ../tools/filesystems/smbfs-fuse) {
    inherit builderDefs samba fuse;
  };

  socat = import ../tools/networking/socat {
    inherit fetchurl stdenv openssl;
  };

  sourceHighlight = import ../tools/text/source-highlight {
    inherit fetchurl stdenv boost;
  };

  socat2pre = builderDefsPackage ../tools/networking/socat/2.0.0-b3.nix {
    inherit fetchurl stdenv openssl;
  };

  squashfsTools = import ../tools/filesystems/squashfs {
    inherit fetchurl stdenv zlib;
  };

  sshfsFuse = import ../tools/filesystems/sshfs-fuse {
    inherit fetchurl stdenv pkgconfig fuse glib;
  };

  sudo = import ../tools/security/sudo {
    inherit fetchurl stdenv coreutils pam groff;
  };

  suidChroot = builderDefsPackage (import ../tools/system/suid-chroot) {
  };

  ssmtp = import ../tools/networking/ssmtp {
    inherit fetchurl stdenv openssl;
    tlsSupport = true;
  };

  ssss = composedArgsAndFun (import ../tools/security/ssss/0.5.nix) {
    inherit builderDefs gmp;
  };

  stun = import ../tools/networking/stun {
    inherit fetchurl stdenv lib;
  };

  stunnel = import ../tools/networking/stunnel {
    inherit fetchurl stdenv openssl;
  };

  su = import ../tools/misc/su {
    inherit fetchurl stdenv pam;
  };

  swec = import ../tools/networking/swec {
    inherit fetchurl stdenv makeWrapper perl;
    inherit (perlPackages) LWP URI HTMLParser HTTPServerSimple Parent;
  };

  svnfs = import ../tools/filesystems/svnfs {
    inherit fetchurl stdenv automake autoconf perl fuse subversion apr;
  };

  system_config_printer = import ../tools/misc/system-config-printer {
    inherit stdenv fetchurl perl perlXMLParser desktop_file_utils;
  };

  sitecopy = import ../tools/networking/sitecopy {
    inherit fetchurl stdenv openssl;
    neon = neon026;
  };

  privoxy = import ../tools/networking/privoxy {
    inherit fetchurl stdenv autoconf automake zlib pcre w3m;
  };

  tcpdump = import ../tools/networking/tcpdump {
    inherit fetchurl stdenv libpcap;
  };

  tcng = import ../tools/networking/tcng {
    inherit fetchurl stdenv iproute bison flex db4 perl;
    kernel = linux_2_6_28;
  };

  telnet = import ../tools/networking/telnet {
    inherit fetchurl stdenv ncurses;
  };

  texmacs = import ../applications/office/texmacs {
    inherit fetchurl stdenv texLive guile;
    inherit (xlibs) libX11 libXext;
  };

  tor = import ../tools/security/tor {
    inherit fetchurl stdenv libevent openssl zlib;
  };

  ttf2pt1 = import ../tools/misc/ttf2pt1 {
    inherit fetchurl stdenv perl freetype;
  };

  ucl = import ../development/libraries/ucl {
    inherit fetchurl stdenv;
  };

  ufraw = import ../applications/graphics/ufraw {
    inherit fetchurl stdenv pkgconfig gettext bzip2 zlib
      libjpeg libtiff cfitsio exiv2 lcms gtkimageview;
    inherit (gnome) gtk;
  };

  upx = import ../tools/compression/upx {
    inherit fetchurl stdenv ucl zlib;
  };

  vbetool = builderDefsPackage ../tools/system/vbetool {
    inherit pciutils libx86 zlib;
  };

  viking = import ../applications/misc/viking {
    inherit fetchurl stdenv pkgconfig intltool gettext expat curl
      gpsd bc file;
    inherit (gtkLibs) gtk;
  };

  vncrec = builderDefsPackage ../tools/video/vncrec {
    inherit (xlibs) imake libX11 xproto gccmakedep libXt
      libXmu libXaw libXext xextproto libSM libICE libXpm
      libXp;
  };

  vpnc = import ../tools/networking/vpnc {
    inherit fetchurl stdenv libgcrypt perl gawk
      nettools makeWrapper;
  };

  vtun = import ../tools/networking/vtun {
    inherit fetchurl stdenv lzo openssl zlib yacc flex;
  };

  testdisk = import ../tools/misc/testdisk {
    inherit fetchurl stdenv ncurses libjpeg e2fsprogs zlib openssl;
  };

  htmlTidy = import ../tools/text/html-tidy {
    inherit fetchcvs stdenv autoconf automake libtool;
  };

  tightvnc = import ../tools/admin/tightvnc {
    inherit fetchurl stdenv x11 zlib libjpeg perl;
    inherit (xlibs) imake gccmakedep libXmu libXaw libXpm libXp xauth;
    fontDirectories = [ xorg.fontadobe75dpi xorg.fontmiscmisc xorg.fontcursormisc
      xorg.fontbhlucidatypewriter75dpi ];
  };

  time = import ../tools/misc/time {
    inherit fetchurl stdenv;
  };

  tm = import ../tools/system/tm {
    inherit fetchurl stdenv;
  };

  trang = import ../tools/text/xml/trang {
    inherit fetchurl stdenv unzip jre;
  };

  tre = import ../development/libraries/tre {
    inherit fetchurl stdenv;
  };

  ts = import ../tools/system/ts {
    inherit fetchurl stdenv;
  };

  transfig = import ../tools/graphics/transfig {
    inherit fetchurl stdenv libpng libjpeg zlib;
    inherit (xlibs) imake;
  };

  truecrypt = import ../applications/misc/truecrypt {
    inherit fetchurl stdenv pkgconfig fuse devicemapper;
    inherit wxGTK;
    wxGUI = getConfig [ "truecrypt" "wxGUI" ] true;
  };

  ttmkfdir = import ../tools/misc/ttmkfdir {
    inherit stdenv fetchurl freetype fontconfig libunwind libtool bison;
    flex = flex2534;
  };

  unbound = import ../tools/networking/unbound {
    inherit fetchurl stdenv openssl;
  };

  units = import ../tools/misc/units {
    inherit fetchurl stdenv;
  };

  unrar = import ../tools/archivers/unrar {
    inherit fetchurl stdenv;
  };

  unshield = import ../tools/archivers/unshield {
    inherit fetchurl stdenv zlib;
  };

  unzip = unzip552;

  # TODO: remove in the next stdenv update.
  unzip552 = import ../tools/archivers/unzip/5.52.nix {
    inherit fetchurl stdenv;
  };

  unzip60 = import ../tools/archivers/unzip/6.0.nix {
    inherit fetchurl stdenv bzip2;
  };

  uptimed = import ../tools/system/uptimed {
    inherit fetchurl stdenv automake autoconf libtool;
  };

  w3cCSSValidator = import ../tools/misc/w3c-css-validator {
    inherit fetchurl stdenv apacheAnt jre sourceFromHead lib;
    tomcat = tomcat6;
  };

  wdfs = import ../tools/filesystems/wdfs {
    inherit stdenv fetchurl fuse pkgconfig glib;
    neon = neon026;
  };

  wdiff = import ../tools/text/wdiff {
    inherit fetchurl stdenv;
  };

  webalizer = import ../tools/networking/webalizer {
    inherit stdenv fetchurl zlib libpng gd db4 geoip;
  };

  webdruid = builderDefsPackage ../tools/admin/webdruid {
    inherit zlib libpng freetype gd which
      libxml2 geoip;
  };

  wget = import ../tools/networking/wget {
    inherit fetchurl stdenv gettext gnutls perl;
    inherit (perlPackages) LWP;
  };

  which = import ../tools/system/which {
    inherit fetchurl stdenv readline;
  };

  wicd = import ../tools/networking/wicd {
    inherit stdenv fetchurl python pygobject pycairo pyGtkGlade pythonDBus
            wpa_supplicant dhcp wirelesstools nettools iproute;
  };

  wv = import ../tools/misc/wv {
    inherit fetchurl stdenv libpng zlib imagemagick
      pkgconfig libgsf libxml2 bzip2 glib;
  };

  wv2 = import ../tools/misc/wv2 {
    inherit stdenv fetchurl pkgconfig libgsf libxml2 glib;
  };

  x11_ssh_askpass = import ../tools/networking/x11-ssh-askpass {
    inherit fetchurl stdenv x11;
    inherit (xorg) imake;
  };

  xclip = import ../tools/misc/xclip {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXmu;
  };

  xfsprogs = import ../tools/filesystems/xfsprogs {
    inherit fetchurl stdenv libtool gettext libuuid;
  };

  xmlroff = import ../tools/typesetting/xmlroff {
    inherit fetchurl stdenv pkgconfig libxml2 libxslt popt;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) libgnomeprint;
    inherit pangoxsl;
  };

  xmlto = import ../tools/typesetting/xmlto {
    inherit fetchurl stdenv flex libxml2 libxslt
      docbook_xml_dtd_42 docbook_xsl w3m bash getopt makeWrapper;
  };

  xmltv = import ../tools/misc/xmltv {
    inherit fetchurl perl perlPackages;
  };

  xmpppy = builderDefsPackage (import ../development/python-modules/xmpppy) {
    inherit python setuptools;
  };

  xpf = import ../tools/text/xml/xpf {
    inherit fetchurl stdenv python;
    libxml2 = libxml2Python;
  };

  xsel = import ../tools/misc/xsel {
    inherit fetchurl stdenv x11;
  };

  zdelta = import ../tools/compression/zdelta {
    inherit fetchurl stdenv;
  };

  zile = import ../applications/editors/zile {
    inherit fetchurl stdenv ncurses help2man;
  };

  zip = import ../tools/archivers/zip {
    inherit fetchurl stdenv;
  };


  ### SHELLS


  bash = lowPrio (useFromStdenv "bash" bashReal);

  bashReal = makeOverridable (import ../shells/bash) {
    inherit fetchurl stdenv bison;
  };

  bashInteractive = appendToName "interactive" (bashReal.override {
    inherit readline texinfo;
    interactive = true;
  });

  tcsh = import ../shells/tcsh {
    inherit fetchurl stdenv ncurses;
  };

  rush = import ../shells/rush {
    inherit fetchurl stdenv;
  };

  zsh = import ../shells/zsh {
    inherit fetchurl stdenv ncurses coreutils;
  };


  ### DEVELOPMENT / COMPILERS


  abc =
    abcPatchable [];

  abcPatchable = patches :
    import ../development/compilers/abc/default.nix {
      inherit stdenv fetchurl patches jre apacheAnt;
      javaCup = import ../development/libraries/java/cup {
        inherit stdenv fetchurl jdk;
      };
    };

  aspectj =
    import ../development/compilers/aspectj {
      inherit stdenv fetchurl jre;
    };

  bigloo = import ../development/compilers/bigloo {
    inherit fetchurl stdenv;
  };

  ccl = builderDefsPackage ../development/compilers/ccl {};

  dylan = import ../development/compilers/gwydion-dylan {
    inherit fetchurl stdenv perl boehmgc yacc flex readline;
    dylan =
      import ../development/compilers/gwydion-dylan/binary.nix {
        inherit fetchurl stdenv;
      };
  };

  ecl = builderDefsPackage ../development/compilers/ecl {
    inherit gmp mpfr;
  };

  adobeFlexSDK33 = import ../development/compilers/adobe-flex-sdk {
    inherit fetchurl stdenv unzip jre;
  };

  fpc = import ../development/compilers/fpc {
    inherit fetchurl stdenv gawk system;
  };

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

  gcc44 = useFromStdenv "gcc" gcc44_real;

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

  /*
  Broken; fails because of unability to find its own symbols during linking

  gcl = builderDefsPackage ../development/compilers/gcl {
    inherit mpfr m4 binutils fetchcvs emacs;
    inherit (xlibs) libX11 xproto inputproto libXi
      libXext xextproto libXt libXaw libXmu;
    stdenv = (overrideGCC stdenv gcc34) // {gcc = gcc33;};
  };
  */

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
  haskellPackages = haskellPackages_ghc6104;

  # Old versions of ghc that currently don't build because the binary
  # is broken.
  /*
  haskellPackages_ghc642 = import ./haskell-packages.nix {
    inherit pkgs;
    ghc = import ../development/compilers/ghc/6.4.2.nix {
      inherit fetchurl stdenv perl ncurses readline m4 gmp;
      ghc = ghc642Binary;
    };
  };

  haskellPackages_ghc661 = import ./haskell-packages.nix {
    inherit pkgs;
    ghc = import ../development/compilers/ghc/6.6.1.nix {
      inherit fetchurl stdenv readline perl58 gmp ncurses m4;
      ghc = ghc642Binary;
    };
  };

  haskellPackages_ghc682 = import ./haskell-packages.nix {
    inherit pkgs;
    ghc = import ../development/compilers/ghc/6.8.2.nix {
      inherit fetchurl stdenv perl gmp ncurses m4;
      readline = readline5;
      ghc = ghc642Binary;
    };
  };

  haskellPackages_ghc683 = recurseIntoAttrs (import ./haskell-packages.nix {
    inherit pkgs;
    ghc = import ../development/compilers/ghc/6.8.3.nix {
      inherit fetchurl stdenv readline perl gmp ncurses m4;
      ghc = ghc642Binary;
      haddock = import ../development/tools/documentation/haddock/boot.nix {
        inherit gmp;
        cabal = import ../development/libraries/haskell/cabal/cabal.nix {
          inherit stdenv fetchurl lib;
          ghc = ghc642Binary;
        };
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
    inherit pkgs;
    enableLibraryProfiling = getConfig [ "cabal" "libraryProfiling" ] profDefault;
    ghc = import ghcPath {
      inherit fetchurl stdenv perl ncurses gmp libedit;
      ghc = ghc6101Binary;
    };
  });

  haskellPackagesFun612 = ghcPath : profDefault : recurseIntoAttrs (import ./haskell-packages.nix {
    inherit pkgs;
    enableLibraryProfiling = getConfig [ "cabal" "libraryProfiling" ] profDefault;
    ghc = import ghcPath {
      inherit fetchurl stdenv perl ncurses gmp;
      ghc = ghc6101Binary;
    };
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

  # We will soon switch to either ghc-6.12.1 or ghc-6.12.2 as default.
  haskellPackages_ghc6121 = lowPrio
    (haskellPackagesFun612 ../development/compilers/ghc/6.12.1.nix false);

  haskellPackages_ghc6122 = lowPrio
    (haskellPackagesFun612 ../development/compilers/ghc/6.12.2.nix false);

  # Currently not pointing to the actual HEAD, therefore disabled
  /*
  haskellPackages_ghcHEAD = lowPrio (import ./haskell-packages.nix {
    inherit pkgs;
    ghc = import ../development/compilers/ghc/6.11.nix {
      inherit fetchurl stdenv perl ncurses gmp libedit;
      inherit (haskellPackages) happy alex; # hope these aren't required for the final version
      ghc = ghc6101Binary;
    };
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

  go = import ../development/compilers/go {
    inherit stdenv fetchhg glibc bison ed which bash makeWrapper;
  };

  gprolog = import ../development/compilers/gprolog {
    inherit fetchurl stdenv;
  };

  gwt = import ../development/compilers/gwt {
    inherit stdenv fetchurl jdk;
    inherit (gtkLibs) glib gtk pango atk;
    inherit (xlibs) libX11 libXt;
    libstdcpp5 = gcc33.gcc;
  };

  ikarus = import ../development/compilers/ikarus {
    inherit stdenv fetchurl gmp;
  };

  #TODO add packages http://cvs.haskell.org/Hugs/downloads/2006-09/packages/ and test
  # commented out because it's using the new configuration style proposal which is unstable
  hugs = import ../development/compilers/hugs {
    inherit lib fetchurl stdenv composableDerivation;
  };

  openjdkDarwin = import ../development/compilers/openjdk-darwin {
    inherit fetchurl stdenv;
  };

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

  jikes = import ../development/compilers/jikes {
    inherit fetchurl stdenv;
  };

  lazarus = builderDefsPackage (import ../development/compilers/fpc/lazarus.nix) {
    inherit fpc makeWrapper;
    inherit (gtkLibs) gtk glib pango atk;
    inherit (xlibs) libXi inputproto libX11 xproto libXext xextproto;
  };

  llvm = import ../development/compilers/llvm {
    inherit fetchurl stdenv gcc flex perl libtool;
  };

  llvmGCC = builderDefsPackage (import ../development/compilers/llvm/llvm-gcc.nix) {
    flex=flex2535;
    inherit llvm perl libtool bison;
  };

  mitscheme = import ../development/compilers/mit-scheme {
    inherit fetchurl stdenv gnum4;
  };

  mono = import ../development/compilers/mono {
    inherit fetchurl stdenv bison pkgconfig gettext perl glib;
  };

  monoDLLFixer = import ../build-support/mono-dll-fixer {
    inherit stdenv perl;
  };

  mozart = import ../development/compilers/mozart {
    inherit fetchurl stdenv flex bison perl gmp zlib tcl tk gdbm m4 x11 emacs;
  };

  neko = import ../development/compilers/neko {
    inherit sourceFromHead fetchurl stdenv lib pkgconfig composableDerivation
      boehmgc apacheHttpd mysql zlib sqlite pcre apr makeWrapper;
    inherit (gtkLibs) gtk;
  };

  nasm = import ../development/compilers/nasm {
    inherit fetchurl stdenv;
  };

  ocaml = ocaml_3_11_1;

  ocaml_3_08_0 = import ../development/compilers/ocaml/3.08.0.nix {
    inherit fetchurl stdenv fetchcvs x11 ncurses;
  };

  ocaml_3_09_1 = import ../development/compilers/ocaml/3.09.1.nix {
    inherit fetchurl stdenv x11 ncurses;
  };

  ocaml_3_10_0 = import ../development/compilers/ocaml/3.10.0.nix {
    inherit fetchurl stdenv x11 ncurses;
  };

  ocaml_3_11_1 = import ../development/compilers/ocaml/3.11.1.nix {
    inherit fetchurl stdenv x11 ncurses;
  };

  opencxx = import ../development/compilers/opencxx {
    inherit fetchurl stdenv libtool;
    gcc = gcc33;
  };

  qcmm = import ../development/compilers/qcmm {
    lua   = lua4;
    ocaml = ocaml_3_08_0;
    inherit fetchurl stdenv mk noweb groff;
  };

  roadsend = import ../development/compilers/roadsend {
    inherit fetchurl stdenv flex bison bigloo lib curl composableDerivation;
    # optional features
    # all features pcre, fcgi xml mysql, sqlite3, (not implemented: odbc gtk gtk2)
    flags = ["pcre" "xml" "mysql"];
    inherit mysql libxml2 fcgi;
  };

  sbcl = builderDefsPackage (import ../development/compilers/sbcl) {
    inherit makeWrapper clisp;
  };

  scala = import ../development/compilers/scala {
    inherit stdenv fetchurl;
  };

  stalin = import ../development/compilers/stalin {
    inherit stdenv fetchurl ncompress;
    inherit (xlibs) libX11;
  };

  strategoPackages = strategoPackages017;

  strategoPackages016 = import ../development/compilers/strategoxt/0.16.nix {
    inherit fetchurl pkgconfig aterm getopt;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strategoPackages017 = import ../development/compilers/strategoxt/0.17.nix {
    inherit fetchurl stdenv pkgconfig aterm getopt jdk ncurses;
    readline = readline5;
  };

  strategoPackages018 = import ../development/compilers/strategoxt/0.18.nix {
    inherit fetchurl stdenv pkgconfig aterm getopt jdk makeStaticBinaries ncurses;
    readline = readline5;
  };

  metaBuildEnv = import ../development/compilers/meta-environment/meta-build-env {
    inherit fetchurl stdenv;
  };

  swiProlog = import ../development/compilers/swi-prolog {
    inherit fetchurl stdenv gmp readline openssl libjpeg unixODBC zlib;
    inherit (xlibs) libXinerama libXft libXpm libSM libXt;
  };

  tinycc = import ../development/compilers/tinycc {
    inherit fetchurl stdenv perl texinfo;
  };

  visualcpp = (import ../development/compilers/visual-c++ {
    inherit fetchurl stdenv cabextract;
  });

  webdsl = import ../development/compilers/webdsl {
    inherit stdenv fetchurl pkgconfig strategoPackages;
  };

  win32hello = import ../development/compilers/visual-c++/test {
    inherit fetchurl stdenv visualcpp windowssdk;
  };

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
  yap = import ../development/compilers/yap {
    inherit fetchurl stdenv;
  };

  yasm = import ../development/compilers/yasm {
    inherit fetchurl stdenv;
  };

  ### DEVELOPMENT / INTERPRETERS

  acl2 = builderDefsPackage ../development/interpreters/acl2 {
    inherit sbcl;
  };

  clisp = import ../development/interpreters/clisp {
    inherit fetchurl stdenv libsigsegv gettext
      readline ncurses coreutils pcre zlib libffi libffcall;
    inherit (xlibs) libX11 libXau libXt xproto
      libXpm libXext xextproto;
  };

  # compatibility issues in 2.47 - at list 2.44.1 is known good
  # for sbcl bootstrap
  clisp_2_44_1 = import ../development/interpreters/clisp/2.44.1.nix {
    inherit fetchurl stdenv gettext
      readline ncurses coreutils pcre zlib libffi libffcall;
    inherit (xlibs) libX11 libXau libXt xproto
      libXpm libXext xextproto;
    libsigsegv = libsigsegv_25;
  };

  erlang = import ../development/interpreters/erlang {
    inherit fetchurl stdenv perl gnum4 ncurses openssl;
  };

  groovy = import ../development/interpreters/groovy {
    inherit stdenv fetchurl unzip;
  };

  guile = import ../development/interpreters/guile {
    inherit fetchurl stdenv readline libtool gmp gawk makeWrapper;
  };

  guile_1_9 = import ../development/interpreters/guile/1.9.nix {
    inherit fetchurl stdenv readline libtool gmp gawk makeWrapper
      libunistring pkgconfig boehmgc libffi;
  };

  io = builderDefsPackage (import ../development/interpreters/io) {
    inherit sqlite zlib gmp libffi cairo ncurses freetype mesa
      libpng libtiff libjpeg readline libsndfile libxml2
      freeglut e2fsprogs libsamplerate pcre libevent libedit;
  };

  kaffe =  import ../development/interpreters/kaffe {
    inherit fetchurl stdenv jikes alsaLib xlibs;
  };

  lua4 = import ../development/interpreters/lua-4 {
    inherit fetchurl stdenv;
  };

  lua5 = import ../development/interpreters/lua-5 {
    inherit fetchurl stdenv ncurses readline;
  };

  maude = import ../development/interpreters/maude {
    inherit fetchurl stdenv flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper;
  };

  octave = import ../development/interpreters/octave {
    inherit stdenv fetchurl gfortran readline ncurses perl flex qhull texinfo;
    inherit (xlibs) libX11;
    # Needed because later gm versions require an initialization the actual octave is not
    # doing.
    # http://www-old.cae.wisc.edu/pipermail/octave-maintainers/2010-February/015295.html
    graphicsmagick = graphicsmagick137;
  };

  # mercurial (hg) bleeding edge version
  octaveHG = import ../development/interpreters/octave/hg.nix {
    inherit fetchurl sourceFromHead readline ncurses perl flex atlas getConfig glibc qhull gfortran;
    inherit automake autoconf bison gperf lib python gnuplot texinfo texLive; # for dev Version
    inherit stdenv;
    inherit (xlibs) libX11;
    #stdenv = overrideGCC stdenv gcc40;
  };

  perl58 = import ../development/interpreters/perl-5.8 {
    inherit fetchurl stdenv;
    impureLibcPath = if stdenv.isLinux then null else "/usr";
  };

  perl510 = makeOverridable (import ../development/interpreters/perl-5.10) {
    inherit stdenv;
    fetchurl = fetchurlBoot;
  };

  perl = useFromStdenv "perl"
    (if system != "i686-cygwin" then perl510 else sysPerl);

  # FIXME: unixODBC needs patching on Darwin (see darwinports)
  phpOld = import ../development/interpreters/php {
    inherit stdenv fetchurl flex bison libxml2 apacheHttpd;
    unixODBC =
      if stdenv.isDarwin then null else unixODBC;
  };

  php = makeOverridable (import ../development/interpreters/php_configurable) {
    inherit
      stdenv fetchurl lib composableDerivation autoconf automake
      flex bison apacheHttpd mysql libxml2 # gettext
      zlib curl gd postgresql openssl pkgconfig sqlite getConfig;
  };

  phpXdebug = import ../development/interpreters/php-xdebug {
    inherit stdenv fetchurl php autoconf automake;
  };

  pltScheme = builderDefsPackage (import ../development/interpreters/plt-scheme) {
    inherit cairo fontconfig freetype libjpeg libpng openssl
      perl mesa zlib which;
    inherit (xorg) libX11 libXaw libXft libXrender libICE xproto
      renderproto pixman libSM libxcb libXext xextproto libXmu
      libXt;
  };

  polyml = import ../development/compilers/polyml {
    inherit stdenv fetchurl;
  };

  python = if getConfig ["python" "full"] false then pythonFull else pythonBase;
  python25 = if getConfig ["python" "full"] false then python25Full else python25Base;
  python26 = if getConfig ["python" "full"] false then python26Full else python26Base;
  pythonBase = python26Base;
  pythonFull = python26Full;

  python24 = import ../development/interpreters/python/2.4 {
    inherit fetchurl stdenv zlib bzip2;
  };

  python25Base = makeOverridable (import ../development/interpreters/python/2.5) {
    inherit fetchurl stdenv zlib bzip2 gdbm;
  };

  python25Full = lowPrio (python25Base.override {
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

  python26Base = makeOverridable (import ../development/interpreters/python/2.6) {
    inherit fetchurl stdenv zlib bzip2 gdbm;
    arch = if stdenv.isDarwin then darwinArchUtility else null;
    sw_vers = if stdenv.isDarwin then darwinSwVersUtility else null;
  };

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

  python31Base = lowPrio (makeOverridable (import ../development/interpreters/python/3.1) {
    inherit fetchurl stdenv zlib bzip2 gdbm;
    arch = if stdenv.isDarwin then darwinArchUtility else null;
    sw_vers = if stdenv.isDarwin then darwinSwVersUtility else null;
  });

  pyrex = pyrex095;

  pyrex095 = import ../development/interpreters/pyrex/0.9.5.nix {
    inherit fetchurl stdenv stringsWithDeps lib builderDefs python;
  };

  pyrex096 = import ../development/interpreters/pyrex/0.9.6.nix {
    inherit fetchurl stdenv stringsWithDeps lib builderDefs python;
  };

  Qi = composedArgsAndFun (import ../development/compilers/qi/9.1.nix) {
    inherit clisp stdenv fetchurl builderDefs unzip;
  };

  ruby18 = import ../development/interpreters/ruby {
    inherit fetchurl stdenv readline ncurses zlib openssl gdbm;
  };
  #ruby19 = import ../development/interpreters/ruby/ruby-19.nix { inherit ruby18 fetchurl; };
  ruby = ruby18;

  rubyLibs = recurseIntoAttrs (import ../development/interpreters/ruby/libs.nix {
    inherit pkgs stdenv;
  });

  rake = import ../development/ruby-modules/rake {
    inherit fetchurl stdenv ruby ;
  };

  rubySqlite3 = import ../development/ruby-modules/sqlite3 {
    inherit fetchurl stdenv ruby sqlite;
  };

  rLang = import ../development/interpreters/r-lang {
    inherit fetchurl stdenv readline perl gfortran libpng zlib;
    inherit (xorg) libX11 libXt;
    withBioconductor = getConfig ["rLang" "withBioconductor"] false;
  };

  rubygemsFun = ruby: builderDefsPackage (import ../development/interpreters/ruby/gems.nix) {
    inherit ruby makeWrapper;
  };
  rubygems = rubygemsFun ruby;

  rq = import ../applications/networking/cluster/rq {
    inherit fetchurl stdenv sqlite ruby ;
  };

  scsh = import ../development/interpreters/scsh {
    inherit stdenv fetchurl;
  };

  spidermonkey = import ../development/interpreters/spidermonkey {
    inherit fetchurl stdenv readline;
  };

  sysPerl = import ../development/interpreters/sys-perl {
    inherit stdenv;
  };

  tcl = import ../development/interpreters/tcl {
    inherit fetchurl stdenv;
  };

  xulrunnerWrapper = {application, launcher}:
    import ../development/interpreters/xulrunner/wrapper {
      inherit stdenv application launcher;
      xulrunner = xulrunner35;
    };


  ### DEVELOPMENT / MISC

  avrgcclibc = import ../development/misc/avr-gcc-with-avr-libc {
    inherit fetchurl stdenv writeTextFile gnumake coreutils gnutar bzip2
      gnugrep gnused gawk;
    gcc = gcc40;
  };

  avr8burnomat = import ../development/misc/avr8-burn-omat {
    inherit fetchurl stdenv unzip;
  };

  /*
  toolbus = import ../development/interpreters/toolbus {
    inherit stdenv fetchurl atermjava toolbuslib aterm yacc flex;
  };
  */

  sourceFromHead = import ../build-support/source-from-head-fun.nix {
    inherit getConfig;
  };

  ecj = makeOverridable (import ../development/eclipse/ecj) {
    inherit fetchurl stdenv unzip ant gcj;
  };

  ecjDarwin = ecj.override { gcj = openjdkDarwin; ant = antDarwin; };

  jdtsdk = import ../development/eclipse/jdt-sdk {
    inherit fetchurl stdenv unzip;
  };

  jruby116 = import ../development/interpreters/jruby {
    inherit fetchurl stdenv;
  };

  guileCairo = import ../development/guile-modules/guile-cairo {
    inherit fetchurl stdenv guile pkgconfig cairo guileLib;
  };

  guileGnome = import ../development/guile-modules/guile-gnome {
    inherit fetchurl stdenv guile guileLib gwrap pkgconfig guileCairo;
    gconf = gnome.GConf;
    inherit (gnome) glib gnomevfs gtk libglade libgnome libgnomecanvas
      libgnomeui pango;
  };

  guileLib = import ../development/guile-modules/guile-lib {
    inherit fetchurl stdenv guile texinfo;
  };

  windowssdk = (
    import ../development/misc/windows-sdk {
      inherit fetchurl stdenv cabextract;
    });


  ### DEVELOPMENT / TOOLS


  antlr = import ../development/tools/parsing/antlr/2.7.7.nix {
    inherit fetchurl stdenv jdk python;
  };

  antlr3 = import ../development/tools/parsing/antlr {
    inherit fetchurl stdenv jre;
  };

  antDarwin = apacheAnt.override rec { jdk = openjdkDarwin ; name = "ant-" + jdk.name ; } ;

  ant = apacheAnt;
  apacheAnt = makeOverridable (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv jdk;
    name = "ant-" + jdk.name;
  };

  apacheAnt14 = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv;
    jdk = j2sdk14x;
    name = "ant-" + j2sdk14x.name;
  };

  apacheAntGcj = import ../development/tools/build-managers/apache-ant/from-source.nix {
    inherit fetchurl stdenv;
    inherit junit; # must be either pre-built or built with GCJ *alone*
    gcj = gcj.gcc; # use the raw GCJ, which has ${gcj}/lib/jvm
  };

  autobuild = import ../development/tools/misc/autobuild {
    inherit fetchurl stdenv makeWrapper perl openssh rsync;
  };

  autoconf = import ../development/tools/misc/autoconf {
    inherit fetchurl stdenv perl m4;
  };

  autoconf213 = import ../development/tools/misc/autoconf/2.13.nix {
    inherit fetchurl stdenv perl m4 lzma;
  };

  automake = automake110x;

  automake17x = import ../development/tools/misc/automake/automake-1.7.x.nix {
    inherit fetchurl stdenv perl autoconf makeWrapper;
  };

  automake19x = import ../development/tools/misc/automake/automake-1.9.x.nix {
    inherit fetchurl stdenv perl autoconf makeWrapper;
  };

  automake110x = import ../development/tools/misc/automake/automake-1.10.x.nix {
    inherit fetchurl stdenv perl autoconf makeWrapper;
  };

  automake111x = import ../development/tools/misc/automake/automake-1.11.x.nix {
    inherit fetchurl stdenv perl autoconf makeWrapper;
  };

  avrdude = import ../development/tools/misc/avrdude {
    inherit lib fetchurl stdenv flex yacc composableDerivation texLive;
  };

  binutils = useFromStdenv "binutils"
    (import ../development/tools/misc/binutils {
      inherit fetchurl stdenv noSysDirs;
    });

  binutilsCross = forceBuildDrv (import ../development/tools/misc/binutils {
      inherit stdenv fetchurl;
      noSysDirs = true;
      cross = assert crossSystem != null; crossSystem;
  });

  bison = bison23;

  bison1875 = import ../development/tools/parsing/bison/bison-1.875.nix {
    inherit fetchurl stdenv m4;
  };

  bison23 = import ../development/tools/parsing/bison/bison-2.3.nix {
    inherit fetchurl stdenv m4;
  };

  bison24 = import ../development/tools/parsing/bison/bison-2.4.nix {
    inherit fetchurl stdenv m4;
  };

  buildbot = import ../development/tools/build-managers/buildbot {
    inherit fetchurl stdenv buildPythonPackage texinfo;
    inherit (pythonPackages) twisted;
  };

  byacc = import ../development/tools/parsing/byacc {
    inherit fetchurl stdenv;
  };

  camlp5_strict = import ../development/tools/ocaml/camlp5 {
    inherit stdenv fetchurl ocaml;
  };

  camlp5_transitional = import ../development/tools/ocaml/camlp5 {
    inherit stdenv fetchurl ocaml;
    transitional = true;
  };

  ccache = import ../development/tools/misc/ccache {
    inherit fetchurl stdenv;
  };

  ctags = import ../development/tools/misc/ctags {
    inherit fetchurl sourceFromHead stdenv automake autoconf;
  };

  ctagsWrapped = import ../development/tools/misc/ctags/wrapped.nix {
    inherit pkgs ctags writeScriptBin;
  };

  cmake = import ../development/tools/build-managers/cmake {
    inherit fetchurl stdenv replace ncurses;
  };

  coccinelle = import ../development/tools/misc/coccinelle {
    inherit fetchurl stdenv perl python ocaml ncurses makeWrapper;
  };

  cppi = import ../development/tools/misc/cppi {
    inherit fetchurl stdenv xz;
  };

  cproto = import ../development/tools/misc/cproto {
    inherit fetchurl stdenv flex bison;
  };

  cflow = import ../development/tools/misc/cflow {
    inherit fetchurl stdenv gettext emacs;
  };

  cscope = import ../development/tools/misc/cscope {
    inherit fetchurl stdenv ncurses pkgconfig emacs;
  };

  dejagnu = import ../development/tools/misc/dejagnu {
    inherit fetchurl stdenv expect makeWrapper;
  };

  ddd = import ../development/tools/misc/ddd {
    inherit fetchurl stdenv lesstif ncurses;
    inherit (xlibs) libX11 libXt;
  };

  distcc = makeOverridable (import ../development/tools/misc/distcc) {
    inherit fetchurl stdenv popt python avahi pkgconfig;
    inherit (gtkLibs) gtk;
    static = false;
  };

  docutils = builderDefsPackage (import ../development/tools/documentation/docutils) {
    inherit python pil makeWrapper;
  };

  doxygen = import ../development/tools/documentation/doxygen {
    inherit fetchurl stdenv graphviz perl flex bison gnumake;
    inherit (xlibs) libX11 libXext;
    qt = if getPkgConfig "doxygen" "qt4" true then qt4 else null;
  };

  eggdbus = import ../development/tools/misc/eggdbus {
    inherit stdenv fetchurl pkgconfig dbus dbus_glib glib;
  };

  elfutils = import ../development/tools/misc/elfutils {
    inherit fetchurl stdenv m4;
  };

  epm = import ../development/tools/misc/epm {
    inherit fetchurl stdenv rpm;
  };

  emma = import ../development/tools/analysis/emma {
    inherit fetchurl stdenv unzip;
  };

  findbugs = import ../development/tools/analysis/findbugs {
    inherit fetchurl stdenv;
  };

  pmd = import ../development/tools/analysis/pmd {
    inherit fetchurl stdenv unzip;
  };

  jdepend = import ../development/tools/analysis/jdepend {
    inherit fetchurl stdenv unzip;
  };

  checkstyle = import ../development/tools/analysis/checkstyle {
    inherit fetchurl stdenv unzip;
  };

  flex = flex254a;

  flex2535 = import ../development/tools/parsing/flex/flex-2.5.35.nix {
    inherit fetchurl stdenv yacc m4;
  };

  flex2534 = import ../development/tools/parsing/flex/flex-2.5.34.nix {
    inherit fetchurl stdenv yacc m4;
  };

  flex2533 = import ../development/tools/parsing/flex/flex-2.5.33.nix {
    inherit fetchurl stdenv yacc m4;
  };

  # Note: 2.5.4a is much older than 2.5.35 but happens first when sorting
  # alphabetically, hence the low priority.
  flex254a = lowPrio (import ../development/tools/parsing/flex/flex-2.5.4a.nix {
    inherit fetchurl stdenv yacc;
  });

  m4 = gnum4;

  global = import ../development/tools/misc/global {
    inherit fetchurl stdenv;
  };

  gnum4 = makeOverridable (import ../development/tools/misc/gnum4) {
    inherit fetchurl stdenv;
  };

  gnumake = useFromStdenv "gnumake"
    (import ../development/tools/build-managers/gnumake {
      inherit fetchurl stdenv;
    });

  gnumake380 = import ../development/tools/build-managers/gnumake-3.80 {
    inherit fetchurl stdenv;
  };

  gradle = import ../development/tools/build-managers/gradle {
    inherit stdenv fetchurl unzip;
  };

  gperf = import ../development/tools/misc/gperf {
    inherit fetchurl stdenv;
  };

  gtkdialog = import ../development/tools/misc/gtkdialog {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
  };

  guileLint = import ../development/tools/guile/guile-lint {
    inherit fetchurl stdenv guile;
  };

  gwrap = import ../development/tools/guile/g-wrap {
    inherit fetchurl stdenv guile libffi pkgconfig guileLib glib;
  };

  help2man = import ../development/tools/misc/help2man {
    inherit fetchurl stdenv perl gettext;
    inherit (perlPackages) LocaleGettext;
  };

  iconnamingutils = import ../development/tools/misc/icon-naming-utils {
    inherit fetchurl stdenv perl;
    inherit (perlPackages) XMLSimple;
  };

  indent = import ../development/tools/misc/indent {
    inherit fetchurl stdenv;
  };

  inotifyTools = import ../development/tools/misc/inotify-tools {
    inherit fetchurl stdenv lib;
  };

  ired = import ../development/tools/analysis/radare/ired.nix {
    inherit fetchurl stdenv;
  };

  jikespg = import ../development/tools/parsing/jikespg {
    inherit fetchurl stdenv;
  };

  lcov = import ../development/tools/analysis/lcov {
    inherit fetchurl stdenv perl;
  };

  libtool = libtool_2;

  libtool_1_5 = import ../development/tools/misc/libtool {
    inherit fetchurl stdenv perl m4;
  };

  libtool_2 = import ../development/tools/misc/libtool/libtool2.nix {
    inherit fetchurl stdenv lzma perl m4;
  };

  lsof = import ../development/tools/misc/lsof {
    inherit fetchurl stdenv;
  };

  ltrace = composedArgsAndFun (import ../development/tools/misc/ltrace/0.5-3deb.nix) {
    inherit fetchurl stdenv builderDefs stringsWithDeps lib elfutils;
  };

  mig = import ../os-specific/gnu/mig {
    inherit fetchgit stdenv autoconf automake flex bison machHeaders;
  };

  mk = import ../development/tools/build-managers/mk {
    inherit fetchurl stdenv;
  };

  noweb = import ../development/tools/literate-programming/noweb {
    inherit fetchurl stdenv;
  };

  omake = import ../development/tools/ocaml/omake {
    inherit stdenv fetchurl ocaml makeWrapper ncurses;
  };


  openocd = import ../development/tools/misc/openocd {
    inherit fetchurl stdenv libftdi;
  };

  oprofile = import ../development/tools/profiling/oprofile {
    inherit fetchurl stdenv binutils popt makeWrapper gawk which gnugrep;

    # Optional build inputs for the (useless) GUI.
    /*
    qt = qt3;
    inherit (xlibs) libX11 libXext;
    inherit libpng;
     */
  };

  patchelf = useFromStdenv "patchelf"
    (import ../development/tools/misc/patchelf {
      inherit fetchurl stdenv;
    });

  patchelf06 = import ../development/tools/misc/patchelf/0.6.nix {
    inherit fetchurl stdenv;
  };

  pmccabe = import ../development/tools/misc/pmccabe {
    inherit fetchurl stdenv;
  };

  /**
   * pkgconfig is optionally taken from the stdenv to allow bootstrapping
   * of glib and pkgconfig itself on MinGW.
   */
  pkgconfigReal = useFromStdenv "pkgconfig"
    (import ../development/tools/misc/pkgconfig {
      inherit fetchurl stdenv;
    });

  /* Make pkgconfig always return a buildDrv, never a proper hostDrv,
     because most usage of pkgconfig as buildInput (inheritance of
     pre-cross nixpkgs) means using it using as buildNativeInput
     cross_renaming: we should make all programs use pkgconfig as
     buildNativeInput after the renaming.
     */
  pkgconfig = forceBuildDrv pkgconfigReal;

  radare = import ../development/tools/analysis/radare {
    inherit stdenv fetchurl pkgconfig libusb readline gtkdialog python
      ruby libewf perl;
    inherit (gtkLibs) gtk;
    inherit (gnome) vte;
    lua = lua5;
    useX11 = getConfig ["radare" "useX11"] false;
    pythonBindings = getConfig ["radare" "pythonBindings"] false;
    rubyBindings = getConfig ["radare" "rubyBindings"] false;
    luaBindings = getConfig ["radare" "luaBindings"] false;
  };

  ragel = import ../development/tools/parsing/ragel {
    inherit composableDerivation fetchurl transfig texLive;
  };

  remake = import ../development/tools/build-managers/remake {
      inherit fetchurl stdenv;
    };

  # couldn't find the source yet
  seleniumRCBin = import ../development/tools/selenium/remote-control {
    inherit fetchurl stdenv unzip;
    jre = jdk;
  };

  scons = import ../development/tools/build-managers/scons {
    inherit fetchurl stdenv python makeWrapper;
  };

  simpleBuildTool = import ../development/tools/build-managers/simple-build-tool {
    inherit fetchurl stdenv;
  };

  sloccount = import ../development/tools/misc/sloccount {
    inherit fetchurl stdenv perl;
  };

  sparse = import ../development/tools/analysis/sparse {
    inherit fetchurl stdenv pkgconfig;
  };

  spin = import ../development/tools/analysis/spin {
    inherit fetchurl stdenv flex yacc tk;
  };

  splint = import ../development/tools/analysis/splint {
    inherit fetchurl stdenv flex;
  };

  strace = import ../development/tools/misc/strace {
    inherit fetchurl stdenv;
  };

  swig = import ../development/tools/misc/swig {
    inherit fetchurl stdenv boost;
  };

  swigWithJava = swig;

  swftools = import ../tools/video/swftools {
    inherit fetchurl stdenv x264 zlib libjpeg freetype giflib;
  };

  texinfo49 = import ../development/tools/misc/texinfo/4.9.nix {
    inherit fetchurl stdenv ncurses;
  };

  texinfo = makeOverridable (import ../development/tools/misc/texinfo) {
    inherit fetchurl stdenv ncurses lzma;
  };

  texi2html = import ../development/tools/misc/texi2html {
    inherit fetchurl stdenv perl;
  };

  uisp = import ../development/tools/misc/uisp {
    inherit fetchurl stdenv;
  };

  gdb = import ../development/tools/misc/gdb {
    inherit fetchurl stdenv ncurses gmp mpfr expat texinfo;
    readline = readline5;
  };

  gdbCross = import ../development/tools/misc/gdb {
    inherit fetchurl stdenv ncurses gmp mpfr expat texinfo;
    readline = readline5;
    target = crossSystem;
  };

  valgrind = import ../development/tools/analysis/valgrind {
    inherit fetchurl stdenv perl gdb autoconf automake;
  };

  xxdiff = builderDefsPackage (import ../development/tools/misc/xxdiff/3.2.nix) {
    flex = flex2535;
    qt = qt3;
    inherit pkgconfig makeWrapper bison python;
    inherit (xlibs) libXext libX11;
  };

  yacc = bison;

  yodl = import ../development/tools/misc/yodl {
    inherit stdenv fetchurl perl;
  };


  ### DEVELOPMENT / LIBRARIES


  a52dec = import ../development/libraries/a52dec {
    inherit fetchurl stdenv;
  };

  aalib = import ../development/libraries/aalib {
    inherit fetchurl stdenv ncurses;
  };

  acl = useFromStdenv "acl"
    (import ../development/libraries/acl {
      inherit stdenv fetchurl gettext attr libtool;
    });

  adns = import ../development/libraries/adns/1.4.nix {
    inherit stdenv fetchurl;
    static = getPkgConfig "adns" "static" (stdenv ? isStatic || stdenv ? isDietLibC);
  };

  agg = import ../development/libraries/agg {
    inherit fetchurl stdenv autoconf automake libtool pkgconfig
      freetype SDL;
    inherit (xlibs) libX11;
  };

  amrnb = import ../development/libraries/amrnb {
    inherit fetchurl stdenv unzip;
  };

  amrwb = import ../development/libraries/amrwb {
    inherit fetchurl stdenv unzip;
  };

  apr = makeOverridable (import ../development/libraries/apr) {
    inherit (pkgsOverriden) fetchurl stdenv;
  };

  aprutil = makeOverridable (import ../development/libraries/apr-util) {
    inherit (pkgsOverriden) fetchurl stdenv apr expat db4;
    bdbSupport = true;
  };

  aspell = import ../development/libraries/aspell {
    inherit fetchurl stdenv perl;
  };

  aspellDicts = recurseIntoAttrs (import ../development/libraries/aspell/dictionaries.nix {
    inherit fetchurl stdenv aspell which;
  });

  aterm = aterm25;

  aterm242fixes = lowPrio (import ../development/libraries/aterm/2.4.2-fixes.nix {
    inherit fetchurl stdenv;
  });

  aterm25 = makeOverridable (import ../development/libraries/aterm/2.5.nix) {
    inherit fetchurl stdenv;
  };

  aterm28 = lowPrio (import ../development/libraries/aterm/2.8.nix {
    inherit fetchurl stdenv;
  });

  attr = useFromStdenv "attr"
    (import ../development/libraries/attr {
      inherit stdenv fetchurl gettext libtool;
    });

  aubio = import ../development/libraries/aubio {
    inherit fetchurl stdenv pkgconfig fftw libsndfile libsamplerate python
      alsaLib jackaudio;
  };

  axis = import ../development/libraries/axis {
    inherit fetchurl stdenv;
  };

  babl = import ../development/libraries/babl {
    inherit fetchurl stdenv;
  };

  beecrypt = import ../development/libraries/beecrypt {
    inherit fetchurl stdenv m4;
  };

  boehmgc = import ../development/libraries/boehm-gc {
    inherit fetchurl stdenv;
  };

  boolstuff = import ../development/libraries/boolstuff {
    inherit fetchurl stdenv lib pkgconfig;
  };

  boost = makeOverridable (import ../development/libraries/boost) {
    inherit fetchurl stdenv icu expat zlib bzip2 python;
  };

  # A Boost build with all library variants enabled.  Very large (about 250 MB).
  boostFull = appendToName "full" (boost.override {
    enableDebug = true;
    enableSingleThreaded = true;
    enableStatic = true;
  });

  botan = builderDefsPackage (import ../development/libraries/botan) {
    inherit perl;
  };

  buddy = import ../development/libraries/buddy {
    inherit fetchurl stdenv bison;
  };

  cairo = makeOverridable (import ../development/libraries/cairo) {
    inherit fetchurl stdenv pkgconfig x11 fontconfig freetype zlib libpng;
    inherit (xlibs) pixman libxcb xcbutil;
  };

  cairomm = import ../development/libraries/cairomm {
    inherit fetchurl stdenv pkgconfig cairo x11 fontconfig freetype libsigcxx;
  };

  scmccid = import ../development/libraries/scmccid {
    inherit fetchurl stdenv libusb patchelf;
  };

  ccrtp = import ../development/libraries/ccrtp {
    inherit fetchurl stdenv lib pkgconfig openssl libgcrypt commoncpp2;
  };

  chipmunk = builderDefsPackage (import ../development/libraries/chipmunk) {
    inherit cmake freeglut mesa;
    inherit (xlibs) libX11 xproto inputproto libXi libXmu;
  };

  chmlib = import ../development/libraries/chmlib {
    inherit fetchurl stdenv;
  };

  cil = import ../development/libraries/cil {
    inherit stdenv fetchurl ocaml perl;
  };

  cilaterm = import ../development/libraries/cil-aterm {
    stdenv = overrideInStdenv stdenv [gnumake380];
    inherit fetchurl perl ocaml;
  };

  clanlib = import ../development/libraries/clanlib {
    inherit fetchurl stdenv zlib libpng libjpeg libvorbis libogg mesa;
    inherit (xlibs) libX11 xf86vidmodeproto libXmu libXxf86vm;
  };

  classads = import ../development/libraries/classads {
    inherit fetchurl stdenv;
  };

  classpath = import ../development/libraries/java/classpath {
    javac = gcj;
    jvm = gcj;
    inherit fetchurl stdenv pkgconfig antlr;
    inherit (gtkLibs) gtk;
    gconf = gnome.GConf;
  };

  clearsilver = import ../development/libraries/clearsilver {
    inherit fetchurl stdenv python;
  };

  clppcre = builderDefsPackage (import ../development/libraries/cl-ppcre) {
  };

  cluceneCore = (import ../development/libraries/clucene-core) {
    inherit fetchurl stdenv;
  };

  commoncpp2 = import ../development/libraries/commoncpp2 {
    inherit stdenv fetchurl;
  };

  consolekit = makeOverridable (import ../development/libraries/consolekit) {
    inherit stdenv fetchurl pkgconfig dbus_glib zlib pam polkit expat glib;
    inherit (xlibs) libX11;
  };

  coredumper = import ../development/libraries/coredumper {
    inherit fetchurl stdenv;
  };

  ctl = import ../development/libraries/ctl {
    inherit fetchurl stdenv ilmbase;
  };

  cppunit = import ../development/libraries/cppunit {
    inherit fetchurl stdenv;
  };

  cracklib = import ../development/libraries/cracklib {
    inherit fetchurl stdenv;
  };

  cryptopp = import ../development/libraries/crypto++ {
    inherit fetchurl stdenv unzip libtool;
  };

  cyrus_sasl = import ../development/libraries/cyrus-sasl {
    inherit stdenv fetchurl openssl db4 gettext;
  };

  db4 = db45;

  db44 = import ../development/libraries/db4/db4-4.4.nix {
    inherit fetchurl stdenv;
  };

  db45 = import ../development/libraries/db4/db4-4.5.nix {
    inherit fetchurl stdenv;
  };

  dbus = import ../development/libraries/dbus {
    inherit fetchurl stdenv pkgconfig expat;
    inherit (xlibs) libX11 libICE libSM;
    useX11 = true; # !!! `false' doesn't build
  };

  dbus_glib = makeOverridable (import ../development/libraries/dbus-glib) {
    inherit fetchurl stdenv pkgconfig gettext dbus expat glib;
    libiconv = if (stdenv.system == "i686-freebsd") then libiconv else null;
  };

  dbus_java = import ../development/libraries/java/dbus-java {
    inherit stdenv fetchurl gettext jdk libmatthew_java;
  };

  dclib = import ../development/libraries/dclib {
    inherit fetchurl stdenv libxml2 openssl bzip2;
  };

  directfb = import ../development/libraries/directfb {
    inherit fetchurl stdenv perl zlib libjpeg freetype
      SDL libpng giflib;
    inherit (xlibs) libX11 libXext xproto xextproto renderproto
      libXrender;
  };

  enchant = makeOverridable (import ../development/libraries/enchant) {
    inherit fetchurl stdenv aspell pkgconfig;
    inherit (gnome) glib;
  };

  enginepkcs11 = import ../development/libraries/enginepkcs11 {
    inherit fetchurl stdenv libp11 pkgconfig openssl;
  };

  exiv2 = import ../development/libraries/exiv2 {
    inherit fetchurl stdenv zlib;
  };

  expat = import ../development/libraries/expat {
    inherit fetchurl stdenv;
  };

  extremetuxracer = builderDefsPackage (import ../games/extremetuxracer) {
    inherit mesa tcl freeglut SDL SDL_mixer pkgconfig
      libpng gettext intltool;
    inherit (xlibs) libX11 xproto libXi inputproto
      libXmu libXext xextproto libXt libSM libICE;
  };

  eventlog = import ../development/libraries/eventlog {
    inherit fetchurl stdenv;
  };

  facile = import ../development/libraries/facile {
    inherit fetchurl stdenv;
    # Actually, we don't need this version but we need native-code compilation
    ocaml = ocaml_3_10_0;
  };

  faac = import ../development/libraries/faac {
    inherit fetchurl stdenv autoconf automake libtool;
  };

  faad2 = import ../development/libraries/faad2 {
    inherit fetchurl stdenv;
  };

  farsight2 = import ../development/libraries/farsight2 {
    inherit fetchurl stdenv libnice pkgconfig python;
    inherit (gnome) glib;
    inherit (gst_all) gstreamer gstPluginsBase;
  };

  fcgi = import ../development/libraries/fcgi {
      inherit fetchurl stdenv;
  };

  ffmpeg = import ../development/libraries/ffmpeg {
    inherit fetchurl stdenv faad2 libvorbis speex libtheora x264 pkgconfig xvidcore
      lame yasm;
  };

  fftw = import ../development/libraries/fftw {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
    singlePrecision = false;
  };

  fftwSinglePrec = import ../development/libraries/fftw {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
    singlePrecision = true;
  };

  fltk11 = (import ../development/libraries/fltk/fltk11.nix) {
    inherit composableDerivation x11 lib pkgconfig freeglut;
    inherit fetchurl stdenv mesa libpng libjpeg zlib ;
    inherit (xlibs) inputproto libXi libXinerama libXft;
    flags = [ "useNixLibs" "threads" "shared" "gl" ];
  };

  fltk20 = (import ../development/libraries/fltk) {
    inherit composableDerivation x11 lib pkgconfig freeglut;
    inherit fetchurl stdenv mesa libpng libjpeg zlib ;
    inherit (xlibs) inputproto libXi libXinerama libXft;
    flags = [ "useNixLibs" "threads" "shared" "gl" ];
  };

  fmod = import ../development/libraries/fmod {
    inherit stdenv fetchurl;
  };

  freeimage = import ../development/libraries/freeimage {
    inherit fetchurl stdenv unzip;
  };

  freetts = import ../development/libraries/freetts {
    inherit stdenv fetchurl apacheAnt unzip sharutils lib;
  };

  cfitsio = import ../development/libraries/cfitsio {
    inherit fetchurl stdenv;
  };

  fontconfig = import ../development/libraries/fontconfig {
    inherit fetchurl stdenv freetype expat;
  };

  makeFontsConf = let fontconfig_ = fontconfig; in {fontconfig ? fontconfig_, fontDirectories}:
    import ../development/libraries/fontconfig/make-fonts-conf.nix {
      inherit runCommand libxslt fontconfig fontDirectories;
    };

  freealut = import ../development/libraries/freealut {
    inherit fetchurl stdenv openal;
  };

  freeglut = import ../development/libraries/freeglut {
    inherit fetchurl stdenv x11 mesa;
  };

  freetype = makeOverridable (import ../development/libraries/freetype) {
    inherit fetchurl stdenv;
  };

  fribidi = import ../development/libraries/fribidi {
    inherit fetchurl stdenv;
  };

  fam = gamin;

  gamin = import ../development/libraries/gamin {
    inherit fetchurl stdenv python pkgconfig glib;
  };

  gav = import ../games/gav {
    inherit fetchurl SDL SDL_image SDL_mixer SDL_net;
    stdenv = overrideGCC stdenv gcc41;
  };

  gdbm = import ../development/libraries/gdbm {
    inherit fetchurl stdenv;
  };

  gdk_pixbuf = import ../development/libraries/gdk-pixbuf {
    inherit fetchurl stdenv libtiff libjpeg libpng;
    inherit (gtkLibs1x) gtk;
  };

  gegl = import ../development/libraries/gegl {
    inherit fetchurl stdenv libpng pkgconfig babl;
    openexr = openexr_1_6_1;
    #  avocodec avformat librsvg
    inherit cairo libjpeg librsvg;
    inherit (gtkLibs) pango glib gtk;
  };

  geoip = builderDefsPackage ../development/libraries/geoip {
    inherit zlib;
  };

  geoipjava = import ../development/libraries/java/geoipjava {
    inherit stdenv fetchurl jdk unzip;
  };

  geos = import ../development/libraries/geos {
    inherit fetchurl fetchsvn stdenv autoconf
      automake libtool swig which lib composableDerivation python ruby;
    use_svn = stdenv.system == "x86_64-linux";
  };

  gettext = import ../development/libraries/gettext {
    inherit fetchurl stdenv libiconv;
  };

  # XXX: Remove me when `stdenv-updates' is merged.
  gettext_0_18 = import ../development/libraries/gettext/0.18.nix {
    inherit fetchurl stdenv libiconv;
  };

  gd = import ../development/libraries/gd {
    inherit fetchurl stdenv zlib libpng freetype libjpeg fontconfig;
  };

  gdal = stdenv.mkDerivation {
    name = "gdal-1.7.1";
    src = fetchurl {
      url = ftp://ftp.remotesensing.org/gdal/gdal-1.7.1.tar.gz;
      md5 = "5a90be385613730cc12fcf3f59b89de6";
    };
  };

  giblib = import ../development/libraries/giblib {
    inherit fetchurl stdenv x11 imlib2;
  };

  glew = import ../development/libraries/glew {
    inherit fetchurl stdenv mesa x11 libtool;
    inherit (xlibs) libXmu libXi;
  };

  glefw = import ../development/libraries/glefw {
    inherit fetchurl stdenv lib mesa;
    inherit (xlibs) libX11 libXext xextproto;
  };

  glibc = useFromStdenv "glibc" glibc211;

  glibc25 = makeOverridable (import ../development/libraries/glibc-2.5) {
    inherit fetchurl stdenv;
    kernelHeaders = linuxHeaders;
    installLocales = false;
  };

  glibc27 = import ../development/libraries/glibc-2.7 {
    inherit fetchurl stdenv;
    kernelHeaders = linuxHeaders;
    #installLocales = false;
  };

  glibc29 = makeOverridable (import ../development/libraries/glibc-2.9) {
    inherit fetchurl stdenv;
    kernelHeaders = linuxHeaders;
    installLocales = getPkgConfig "glibc" "locales" false;
  };

  glibc29Cross = forceBuildDrv (makeOverridable (import ../development/libraries/glibc-2.9) {
    inherit stdenv fetchurl;
    gccCross = gccCrossStageStatic;
    kernelHeaders = linuxHeadersCross;
    installLocales = getPkgConfig "glibc" "locales" false;
  });

  glibc211 = makeOverridable (import ../development/libraries/glibc-2.11) {
    inherit fetchurl stdenv;
    kernelHeaders = linuxHeaders;
    installLocales = getPkgConfig "glibc" "locales" false;
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

  libdwg = import ../development/libraries/libdwg {
    inherit stdenv fetchurl;
  };

  eglibc = import ../development/libraries/eglibc {
    inherit fetchsvn stdenv;
    kernelHeaders = linuxHeaders;
    installLocales = getPkgConfig "glibc" "locales" false;
  };

  glibcLocales = makeOverridable (import ../development/libraries/glibc-2.11/locales.nix) {
    inherit fetchurl stdenv;
  };

  glibcInfo = import ../development/libraries/glibc-2.11/info.nix {
    inherit fetchurl stdenv texinfo perl;
  };

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

  glpk = import ../development/libraries/glpk {
    inherit fetchurl stdenv;
  };

  gmime = import ../development/libraries/gmime {
    inherit fetchurl stdenv pkgconfig zlib glib;
  };

  gmm = import ../development/libraries/gmm {
    inherit fetchurl stdenv;
  };

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

  gobjectIntrospection = makeOverridable (import ../development/libraries/gobject-introspection) {
    inherit fetchurl stdenv pkgconfig flex bison glib libffi python cairo;
  };

  goffice = import ../development/libraries/goffice {
    inherit fetchurl stdenv pkgconfig libgsf libxml2 cairo
      intltool gettext bzip2;
    inherit (gnome) glib gtk libglade libgnomeui pango;
    gconf = gnome.GConf;
    libart = gnome.libart_lgpl;
  };

  goocanvas = import ../development/libraries/goocanvas {
    inherit fetchurl stdenv pkgconfig cairo;
    inherit (gnome) gtk glib;
  };

  #GMP ex-satellite, so better keep it near gmp
  mpfr = import ../development/libraries/mpfr {
    inherit stdenv fetchurl gmp;
  };

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

  gnet = import ../development/libraries/gnet {
    inherit fetchurl stdenv pkgconfig glib;
  };

  gnutls = import ../development/libraries/gnutls {
    inherit fetchurl stdenv libgcrypt zlib lzo libtasn1 guile;
    guileBindings = getConfig ["gnutls" "guile"] true;
  };

  gpgme = import ../development/libraries/gpgme {
    inherit fetchurl stdenv libgpgerror pkgconfig pth gnupg glib libassuan;
  };

  gsasl = import ../development/libraries/gsasl {
    inherit stdenv fetchurl;
  };

  gsl = import ../development/libraries/gsl {
    inherit fetchurl stdenv;
  };

  gsoap = import ../development/libraries/gsoap {
    inherit fetchurl stdenv m4 bison flex openssl zlib;
  };

  gss = import ../development/libraries/gss {
    inherit stdenv fetchurl shishi;
  };

  gtkimageview = import ../development/libraries/gtkimageview {
    inherit fetchurl stdenv pkgconfig;
    inherit (gnome) gtk;
  };

  gtkLibs = recurseIntoAttrs gtkLibs218;

  glib = gtkLibs.glib;

  gtkLibs1x = rec {

    glib = import ../development/libraries/glib/1.2.x.nix {
      inherit fetchurl stdenv;
    };

    gtk = import ../development/libraries/gtk+/1.2.x.nix {
      inherit fetchurl stdenv x11 glib;
    };

  };

  gtkLibs216 = rec {

    glib = import ../development/libraries/glib/2.20.x.nix {
      inherit fetchurl stdenv pkgconfig gettext perl;
    };

    glibmm = import ../development/libraries/glibmm/2.18.x.nix {
      inherit fetchurl stdenv pkgconfig glib libsigcxx;
    };

    atk = import ../development/libraries/atk/1.24.x.nix {
      inherit fetchurl stdenv pkgconfig perl glib;
    };

    pango = import ../development/libraries/pango/1.24.x.nix {
      inherit fetchurl stdenv pkgconfig gettext x11 glib cairo libpng;
    };

    pangomm = import ../development/libraries/pangomm/2.14.x.nix {
      inherit fetchurl stdenv pkgconfig pango glibmm cairomm libpng;
    };

    gtk = import ../development/libraries/gtk+/2.16.x.nix {
      inherit fetchurl stdenv pkgconfig perl jasper x11 glib atk pango
        libtiff libjpeg libpng cairo xlibs;
    };

    gtkmm = import ../development/libraries/gtkmm/2.14.x.nix {
      inherit fetchurl stdenv pkgconfig gtk atk glibmm cairomm pangomm;
    };

  };

  gtkLibs218 = rec {

    glib = import ../development/libraries/glib/2.22.x.nix {
      inherit fetchurl stdenv pkgconfig gettext perl;
      libiconv = if (stdenv.system == "i686-freebsd") then libiconv else null;
    };

    glibmm = import ../development/libraries/glibmm/2.22.x.nix {
      inherit fetchurl stdenv pkgconfig glib libsigcxx;
    };

    atk = import ../development/libraries/atk/1.28.x.nix {
      inherit fetchurl stdenv pkgconfig perl glib;
    };

    pango = import ../development/libraries/pango/1.26.x.nix {
      inherit fetchurl stdenv pkgconfig gettext x11 glib cairo libpng;
    };

    pangomm = import ../development/libraries/pangomm/2.26.x.nix {
      inherit fetchurl stdenv pkgconfig pango glibmm cairomm libpng;
    };

    gtk = import ../development/libraries/gtk+/2.18.x.nix {
      inherit fetchurl stdenv pkgconfig perl jasper glib atk pango
        libtiff libjpeg libpng cairo xlibs cups;
    };

    gtkmm = import ../development/libraries/gtkmm/2.18.x.nix {
      inherit fetchurl stdenv pkgconfig gtk atk glibmm cairomm pangomm;
    };

  };

  gtkmozembedsharp = import ../development/libraries/gtkmozembed-sharp {
    inherit fetchurl stdenv mono pkgconfig monoDLLFixer;
    inherit (gnome) gtk;
    gtksharp = gtksharp2;
  };

  gtksharp1 = import ../development/libraries/gtk-sharp-1 {
    inherit fetchurl stdenv mono pkgconfig libxml2 monoDLLFixer;
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf;
  };

  gtksharp2 = import ../development/libraries/gtk-sharp-2 {
    inherit fetchurl stdenv mono pkgconfig libxml2 monoDLLFixer;
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml
              libgnomecanvas libgnomeui libgnomeprint
              libgnomeprintui GConf gnomepanel;
  };

  gtksourceviewsharp = import ../development/libraries/gtksourceview-sharp {
    inherit fetchurl stdenv mono pkgconfig monoDLLFixer;
    inherit (gnome) gtksourceview;
    gtksharp = gtksharp2;
  };

  gtkspell = import ../development/libraries/gtkspell {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit aspell;
  };

  # TODO : Add MIT Kerberos and let admin choose.
  kerberos = heimdal;

  heimdal = import ../development/libraries/kerberos/heimdal.nix {
    inherit fetchurl stdenv readline db4 openssl openldap cyrus_sasl;
  };

  hsqldb = import ../development/libraries/java/hsqldb {
    inherit stdenv fetchurl unzip;
  };

  hwloc = import ../development/libraries/hwloc {
    inherit fetchurl stdenv pkgconfig cairo expat ncurses;
  };

  hydraAntLogger = import ../development/libraries/java/hydra-ant-logger {
    inherit fetchsvn stdenv ant;
  };

  icu = import ../development/libraries/icu {
    inherit fetchurl stdenv;
  };

  id3lib = import ../development/libraries/id3lib {
    inherit fetchurl stdenv;
  };

  ilbc = import ../development/libraries/ilbc {
    inherit stdenv msilbc;
  };

  ilmbase = import ../development/libraries/ilmbase {
    inherit fetchurl stdenv;
  };

  imlib = import ../development/libraries/imlib {
    inherit fetchurl stdenv libjpeg libtiff libungif libpng;
    inherit (xlibs) libX11 libXext xextproto;
  };

  imlib2 = import ../development/libraries/imlib2 {
    inherit fetchurl stdenv x11 libjpeg libtiff libungif libpng bzip2;
  };

  indilib = import ../development/libraries/indilib {
    inherit fetchurl stdenv cfitsio libusb zlib;
  };

  iniparser = import ../development/libraries/iniparser {
    inherit fetchurl stdenv;
  };

  intltool = gnome.intltool;

  isocodes = import ../development/libraries/iso-codes {
    inherit stdenv fetchurl gettext python;
  };

  itk = import ../development/libraries/itk {
    inherit stdenv fetchurl cmake libuuid;
    inherit (xlibs) libX11;
  };

  jamp = builderDefsPackage ../games/jamp {
    inherit mesa SDL SDL_image SDL_mixer;
  };

  jasper = import ../development/libraries/jasper {
    inherit fetchurl stdenv unzip xlibs libjpeg;
  };

  jetty_gwt = import ../development/libraries/java/jetty-gwt {
    inherit stdenv fetchurl;
  };

  jetty_util = import ../development/libraries/java/jetty-util {
    inherit stdenv fetchurl;
  };

  krb5 = import ../development/libraries/kerberos/krb5.nix {
    inherit stdenv fetchurl perl ncurses yacc;
  };

  lablgtk = import ../development/libraries/lablgtk {
    inherit fetchurl stdenv ocaml pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnomecanvas;
  };

  lcms = import ../development/libraries/lcms {
    inherit fetchurl stdenv;
  };

  lensfun = import ../development/libraries/lensfun {
    inherit fetchurl stdenv libpng python zlib pkgconfig;
    inherit (gnome) glib;
  };

  lesstif = import ../development/libraries/lesstif {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp libXau;
  };

  lesstif93 = import ../development/libraries/lesstif-0.93 {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp libXau;
  };

  levmar = import ../development/libraries/levmar {
    inherit fetchurl stdenv;
  };

  lib3ds = import ../development/libraries/lib3ds {
    inherit fetchurl stdenv unzip;
  };

  libaal = import ../development/libraries/libaal {
    inherit fetchurl stdenv;
  };

  libao = import ../development/libraries/libao {
    inherit stdenv fetchurl pkgconfig pulseaudio;
    usePulseAudio = getConfig [ "pulseaudio" ] true;
  };

  libarchive = import ../development/libraries/libarchive {
    inherit fetchurl stdenv acl zlib bzip2 e2fsprogs xz sharutils libxml2
      openssl attr;
  };

  libassuan1 = import ../development/libraries/libassuan1 {
    inherit fetchurl stdenv pth;
  };

  libassuan = import ../development/libraries/libassuan {
    inherit fetchurl stdenv pth libgpgerror;
  };

  libavc1394 = import ../development/libraries/libavc1394 {
    inherit fetchurl stdenv pkgconfig libraw1394;
  };

  libcaca = import ../development/libraries/libcaca {
    inherit fetchurl stdenv ncurses;
  };

  libcanberra = import ../development/libraries/libcanberra {
    inherit fetchurl stdenv pkgconfig libtool alsaLib pulseaudio
      libvorbis libcap;
    inherit (gtkLibs) gtk gthread;
    gstreamer = gst_all.gstreamer;
  };

  libcdaudio = import ../development/libraries/libcdaudio {
    inherit fetchurl stdenv;
  };

  libcddb = import ../development/libraries/libcddb {
    inherit fetchurl stdenv;
  };

  libcdio = import ../development/libraries/libcdio {
    inherit fetchurl stdenv libcddb pkgconfig ncurses help2man;
  };

  libcm = import ../development/libraries/libcm {
    inherit fetchurl stdenv pkgconfig xlibs mesa glib;
  };

  libcue = import ../development/libraries/libcue {
    inherit stdenv fetchurl;
  };

  libcv = builderDefsPackage (import ../development/libraries/libcv) {
    inherit libtiff libjpeg libpng pkgconfig;
    inherit (gtkLibs) gtk glib;
  };

  libdaemon = import ../development/libraries/libdaemon {
    inherit fetchurl stdenv;
  };

  libdbi = composedArgsAndFun (import ../development/libraries/libdbi/0.8.2.nix) {
    inherit stdenv fetchurl builderDefs;
  };

  libdbiDriversBase = composedArgsAndFun (import ../development/libraries/libdbi-drivers/0.8.2-1.nix) {
    inherit stdenv fetchurl builderDefs libdbi;
  };

  libdbiDrivers = libdbiDriversBase.passthru.function {
    inherit sqlite mysql;
  };

  libdv = import ../development/libraries/libdv {
    inherit fetchurl stdenv lib composableDerivation;
  };

  libdrm = if stdenv.isDarwin then null else (import ../development/libraries/libdrm {
    inherit fetchurl stdenv pkgconfig;
    inherit (xorg) libpthreadstubs;
  });

  libdvdcss = import ../development/libraries/libdvdcss {
    inherit fetchurl stdenv;
  };

  libdvdnav = import ../development/libraries/libdvdnav {
    inherit fetchurl stdenv libdvdread;
  };

  libdvdread = import ../development/libraries/libdvdread {
    inherit fetchurl stdenv libdvdcss;
  };

  libedit = import ../development/libraries/libedit {
    inherit fetchurl stdenv ncurses;
  };

  libelf = import ../development/libraries/libelf {
    inherit fetchurl stdenv;
  };

  liblo = import ../development/libraries/liblo {
    inherit fetchurl stdenv;
  };

  libev = builderDefsPackage ../development/libraries/libev {
  };

  libevent = import ../development/libraries/libevent {
    inherit fetchurl stdenv;
  };

  libewf = import ../development/libraries/libewf {
    inherit fetchurl stdenv zlib openssl libuuid;
  };

  libexif = import ../development/libraries/libexif {
    inherit fetchurl stdenv gettext;
  };

  libextractor = import ../development/libraries/libextractor {
    inherit fetchurl stdenv libtool gettext zlib bzip2 flac libvorbis
     exiv2 ffmpeg libgsf glib rpm pkgconfig;
    inherit (gnome) gtk;
    libmpeg2 = mpeg2dec;
  };

  libffcall = builderDefsPackage (import ../development/libraries/libffcall) {
    inherit fetchcvs;
  };

  libffi = import ../development/libraries/libffi {
    inherit fetchurl stdenv;
  };

  libftdi = import ../development/libraries/libftdi {
    inherit fetchurl stdenv libusb;
  };

  libgcrypt = import ../development/libraries/libgcrypt {
    inherit fetchurl stdenv libgpgerror;
  };

  libgpgerror = import ../development/libraries/libgpg-error {
    inherit fetchurl stdenv;
  };

  libgphoto2 = import ../development/libraries/libgphoto2 {
    inherit fetchurl stdenv pkgconfig libusb libtool libexif libjpeg gettext;
  };

  libgpod = import ../development/libraries/libgpod {
    inherit fetchurl stdenv gettext perl perlXMLParser pkgconfig libxml2 glib;
  };

  libharu = import ../development/libraries/libharu {
    inherit fetchurl stdenv lib zlib libpng;
  };

  libical = import ../development/libraries/libical {
    inherit stdenv fetchurl perl;
  };

  libiodbc = makeOverridable (import ../development/libraries/libiodbc) {
    inherit stdenv fetchurl pkgconfig;
    inherit (gtkLibs) gtk;
    useGTK = getPkgConfig "libiodbc" "gtk" false;
  };

  liblqr1 = makeOverridable (import ../development/libraries/liblqr-1) {
    inherit stdenv fetchurl pkgconfig;
    inherit (gnome) glib;
  };

  libnice = import ../development/libraries/libnice {
    inherit stdenv fetchurl pkgconfig;
    inherit (gnome) glib;
  };

  libQGLViewer = import ../development/libraries/libqglviewer {
    inherit fetchurl stdenv;
    inherit qt4;
  };

  libsamplerate = import ../development/libraries/libsamplerate {
    inherit fetchurl stdenv pkgconfig lib;
  };

  libspectre = import ../development/libraries/libspectre {
    inherit fetchurl stdenv;
    ghostscript = ghostscriptX;
  };

  libgsf = import ../development/libraries/libgsf {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig libxml2
      intltool gettext bzip2 python;
    inherit (gnome) glib gnomevfs libbonobo;
  };

  libiconv = import ../development/libraries/libiconv {
    inherit fetchurl stdenv;
  };

  libid3tag = import ../development/libraries/libid3tag {
    inherit fetchurl stdenv zlib;
  };

  libidn = import ../development/libraries/libidn {
    inherit fetchurl stdenv;
  };

  libiec61883 = import ../development/libraries/libiec61883 {
    inherit fetchurl stdenv pkgconfig libraw1394;
  };

  libiptcdata = import ../development/libraries/libiptcdata {
    inherit fetchurl stdenv;
  };

  libjingle = import ../development/libraries/libjingle/0.3.11.nix {
    inherit fetchurl stdenv mediastreamer;
  };

  libjpeg = makeOverridable (import ../development/libraries/libjpeg) {
    inherit fetchurl stdenv;
  };

  libjpeg62 = makeOverridable (import ../development/libraries/libjpeg/62.nix) {
    inherit fetchurl stdenv;
    libtool = libtool_1_5;
  };

  libjpegStatic = lowPrio (appendToName "static" (libjpeg.override {
    stdenv = enableStaticLibraries stdenv;
  }));

  libksba = import ../development/libraries/libksba {
    inherit fetchurl stdenv libgpgerror;
  };

  libmad = import ../development/libraries/libmad {
    inherit fetchurl stdenv autoconf;
  };

  libmatthew_java = import ../development/libraries/java/libmatthew-java {
    inherit stdenv fetchurl jdk;
  };

  libmcs = import ../development/libraries/libmcs {
    inherit fetchurl stdenv pkgconfig libmowgli;
  };

  libmicrohttpd = import ../development/libraries/libmicrohttpd {
    inherit fetchurl stdenv curl;
  };

  libmikmod = import ../development/libraries/libmikmod {
    inherit stdenv fetchurl texinfo;
  };

  libmilter = import ../development/libraries/libmilter {
    inherit fetchurl stdenv m4;
  };

  libmowgli = import ../development/libraries/libmowgli {
    inherit fetchurl stdenv;
  };

  libmng = import ../development/libraries/libmng {
    inherit fetchurl stdenv lib zlib libpng libjpeg lcms automake autoconf libtool;
  };

  libmpcdec = import ../development/libraries/libmpcdec {
    inherit fetchurl stdenv;
  };

  libmsn = import ../development/libraries/libmsn {
    inherit stdenv fetchurl cmake openssl;
  };

  libmspack = import ../development/libraries/libmspack {
    inherit fetchurl stdenv;
  };

  libmusclecard = import ../development/libraries/libmusclecard {
    inherit fetchurl stdenv pkgconfig pcsclite;
  };

  libnih = import ../development/libraries/libnih {
    inherit fetchurl stdenv pkgconfig dbus expat;
  };

  libnova = import ../development/libraries/libnova {
    inherit fetchurl stdenv;
  };

  libofx = import ../development/libraries/libofx {
    inherit fetchurl stdenv opensp pkgconfig libxml2 curl;
  };

  libogg = import ../development/libraries/libogg {
    inherit fetchurl stdenv;
  };

  liboil = makeOverridable (import ../development/libraries/liboil) {
    inherit fetchurl stdenv pkgconfig glib;
  };

  liboop = import ../development/libraries/liboop {
    inherit fetchurl stdenv;
  };

  libotr = import ../development/libraries/libotr {
    inherit fetchurl stdenv libgcrypt;
  };

  libp11 = import ../development/libraries/libp11 {
    inherit fetchurl stdenv libtool openssl pkgconfig;
  };

  libpcap = import ../development/libraries/libpcap {
    inherit fetchurl stdenv flex bison;
  };

  libpng = import ../development/libraries/libpng {
    inherit fetchurl stdenv zlib;
  };

  libproxy = import ../development/libraries/libproxy {
    inherit stdenv fetchurl;
  };

  libpseudo = import ../development/libraries/libpseudo {
    inherit fetchurl stdenv pkgconfig ncurses glib;
  };

  librsync = import ../development/libraries/librsync {
    inherit stdenv fetchurl;
  };

  libsigcxx = import ../development/libraries/libsigcxx {
    inherit fetchurl stdenv pkgconfig;
  };

  libsigsegv = import ../development/libraries/libsigsegv {
    inherit fetchurl stdenv;
  };

  # To bootstrap SBCL, I need CLisp 2.44.1; it needs libsigsegv 2.5
  libsigsegv_25 =  import ../development/libraries/libsigsegv/2.5.nix {
    inherit fetchurl stdenv;
  };

  libsndfile = import ../development/libraries/libsndfile {
    inherit fetchurl stdenv;
  };

  libssh = import ../development/libraries/libssh {
    inherit stdenv fetchurl cmake zlib openssl;
  };

  libstartup_notification = import ../development/libraries/startup-notification {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libxcb xcbutil;
  };

  libtasn1 = import ../development/libraries/libtasn1 {
    inherit fetchurl stdenv;
  };

  libtheora = import ../development/libraries/libtheora {
    inherit fetchurl stdenv libogg libvorbis;
  };

  libtiff = import ../development/libraries/libtiff {
    inherit fetchurl stdenv zlib libjpeg;
  };

  libtommath = import ../development/libraries/libtommath {
    inherit fetchurl stdenv libtool;
  };

  libunistring = import ../development/libraries/libunistring {
    inherit fetchurl stdenv libiconv;
  };

  libupnp = import ../development/libraries/pupnp {
    inherit fetchurl stdenv;
  };

  giflib = import ../development/libraries/giflib {
    inherit fetchurl stdenv;
  };

  libungif = import ../development/libraries/giflib/libungif.nix {
    inherit fetchurl stdenv;
  };

  libusb = import ../development/libraries/libusb {
    inherit fetchurl stdenv;
  };

  libunwind = import ../development/libraries/libunwind {
    inherit fetchurl stdenv;
  };

  libv4l = import ../development/libraries/libv4l {
    inherit stdenv fetchurl;
  };

  libvirt = import ../development/libraries/libvirt {
    inherit stdenv fetchurl libxml2 gnutls devicemapper perl;
  };

  libvncserver = builderDefsPackage (import ../development/libraries/libvncserver) {
    inherit libtool libjpeg openssl zlib;
    inherit (xlibs) xproto libX11 damageproto libXdamage
      libXext xextproto fixesproto libXfixes xineramaproto
      libXinerama libXrandr randrproto libXtst;
  };

  libviper = import ../development/libraries/libviper {
    inherit fetchurl stdenv pkgconfig ncurses gpm glib;
  };

  libvpx = import ../development/libraries/libvpx {
    inherit fetchurl stdenv bash;
  };

  libvterm = import ../development/libraries/libvterm {
    inherit fetchurl stdenv pkgconfig ncurses glib;
  };

  libvorbis = import ../development/libraries/libvorbis {
    inherit fetchurl stdenv libogg;
  };

  libwmf = import ../development/libraries/libwmf {
    inherit fetchurl stdenv pkgconfig imagemagick
      zlib libpng freetype libjpeg libxml2 glib;
  };

  libwpd = import ../development/libraries/libwpd {
    inherit fetchurl stdenv pkgconfig libgsf libxml2 bzip2;
    inherit (gnome) glib;
  };

  libx86 = builderDefsPackage ../development/libraries/libx86 {};

  libxcrypt = import ../development/libraries/libxcrypt {
    inherit fetchurl stdenv;
  };

  libxdg_basedir = import ../development/libraries/libxdg-basedir {
    inherit fetchurl stdenv;
  };

  libxklavier = import ../development/libraries/libxklavier {
    inherit fetchurl stdenv xkeyboard_config pkgconfig libxml2 isocodes glib;
    inherit (xorg) libX11 libICE libXi libxkbfile;
  };

  libxmi = import ../development/libraries/libxmi {
    inherit fetchurl stdenv libtool;
  };

  libxml2 = makeOverridable (import ../development/libraries/libxml2) {
    inherit fetchurl stdenv zlib python;
    pythonSupport = false;
  };

  libxml2Python = libxml2.override {
    pythonSupport = true;
  };

  libxslt = makeOverridable (import ../development/libraries/libxslt) {
    inherit fetchurl stdenv libxml2;
  };

  libixp_for_wmii = lowPrio (import ../development/libraries/libixp_for_wmii {
    inherit fetchurl stdenv;
  });

  libyaml = import ../development/libraries/libyaml {
    inherit fetchurl stdenv;
  };

  libzip = import ../development/libraries/libzip {
    inherit fetchurl stdenv zlib;
  };

  libzrtpcpp = import ../development/libraries/libzrtpcpp {
    inherit fetchurl stdenv lib commoncpp2 openssl pkgconfig ccrtp;
  };

  lightning = import ../development/libraries/lightning {
    inherit fetchurl stdenv;
  };

  liquidwar = builderDefsPackage ../games/liquidwar {
    inherit (xlibs) xproto libX11 libXrender;
    inherit gmp guile mesa libjpeg libpng
      expat gettext perl
      SDL SDL_image SDL_mixer SDL_ttf
      curl sqlite
      libogg libvorbis
      ;
  };

  log4cxx = import ../development/libraries/log4cxx {
    inherit fetchurl stdenv automake autoconf libtool cppunit libxml2 boost;
    inherit apr aprutil db45 expat;
  };

  loudmouth = import ../development/libraries/loudmouth {
    inherit fetchurl stdenv libidn openssl pkgconfig zlib glib;
  };

  lzo = import ../development/libraries/lzo {
    inherit fetchurl stdenv;
  };

  # failed to build
  mediastreamer = composedArgsAndFun (import ../development/libraries/mediastreamer/2.2.0-cvs20080207.nix) {
    inherit fetchurl stdenv automake libtool autoconf alsaLib pkgconfig speex
      ortp ffmpeg;
  };

  mesaSupported =
    system == "i686-linux" ||
    system == "x86_64-linux" ||
    system == "x86_64-darwin" ||
    system == "i686-darwin";

  mesa = import ../development/libraries/mesa {
    inherit fetchurl stdenv pkgconfig expat x11 xlibs libdrm;
    lipo = if stdenv.isDarwin then darwinLipoUtility else null;
  };

  ming = import ../development/libraries/ming {
    inherit fetchurl stdenv flex bison freetype zlib libpng perl;
  };

  mlt = import ../development/libraries/mlt {
    inherit fetchurl stdenv pkgconfig SDL ffmpeg libdv libxml2 libsamplerate
      libvorbis sox;
    qt = qt4;
  };

  mpeg2dec = import ../development/libraries/mpeg2dec {
    inherit fetchurl stdenv;
  };

  msilbc = import ../development/libraries/msilbc {
    inherit fetchurl stdenv ilbc mediastreamer pkgconfig;
  };

  mpc = import ../development/libraries/mpc {
    inherit fetchurl stdenv gmp mpfr;
  };

  mpich2 = import ../development/libraries/mpich2 {
    inherit fetchurl stdenv python perl;
  };

  muparser = import ../development/libraries/muparser {
    inherit fetchurl stdenv;
  };

  ncurses = makeOverridable (composedArgsAndFun (import ../development/libraries/ncurses)) {
    inherit fetchurl stdenv;
    # The "! (stdenv ? cross)" is for the cross-built arm ncurses, which
    # don't build for me in unicode.
    unicode = (system != "i686-cygwin" && crossSystem == null);
  };

  neon = neon029;

  neon026 = import ../development/libraries/neon/0.26.nix {
    inherit fetchurl stdenv libxml2 zlib openssl pkgconfig;
    compressionSupport = true;
    sslSupport = true;
  };

  neon028 = import ../development/libraries/neon/0.28.nix {
    inherit fetchurl stdenv libxml2 zlib openssl pkgconfig;
    compressionSupport = true;
    sslSupport = true;
  };

  neon029 = import ../development/libraries/neon/0.29.nix {
    inherit fetchurl stdenv libxml2 zlib openssl pkgconfig;
    compressionSupport = true;
    sslSupport = true;
  };

  nethack = builderDefsPackage (import ../games/nethack) {
    inherit ncurses flex bison;
  };

  nettle = import ../development/libraries/nettle {
    inherit fetchurl stdenv gmp gnum4;
  };

  nspr = import ../development/libraries/nspr {
    inherit fetchurl stdenv;
  };

  nss = import ../development/libraries/nss {
    inherit fetchurl stdenv nspr perl zlib;
  };

  ode = builderDefsPackage (import ../development/libraries/ode) {
  };

  openal = import ../development/libraries/openal {
    inherit fetchurl stdenv cmake alsaLib;
  };

  # added because I hope that it has been easier to compile on x86 (for blender)
  openalSoft = import ../development/libraries/openalSoft {
    inherit fetchurl stdenv alsaLib libtool cmake;
  };

  openbabel = import ../development/libraries/openbabel {
    inherit fetchurl stdenv zlib libxml2;
  };

  opencascade = import ../development/libraries/opencascade {
    inherit fetchurl stdenv mesa tcl tk file;
    inherit (xlibs) libXmu;
  };

  openct = import ../development/libraries/openct {
    inherit fetchurl stdenv libtool pcsclite libusb pkgconfig;
  };

  opencv = import ../development/libraries/opencv {
      inherit fetchurl cmake libjpeg libpng libtiff jasper ffmpeg
          pkgconfig xineLib;
      inherit (gtkLibs) gtk glib;
      inherit (gst_all) gstreamer;
      stdenv = stdenv2;
  };

  # this ctl version is needed by openexr_viewers
  openexr_ctl = import ../development/libraries/openexr_ctl {
    inherit fetchurl stdenv ilmbase ctl;
    openexr = openexr_1_6_1;
  };

  openexr_1_6_1 = import ../development/libraries/openexr {
    inherit fetchurl stdenv ilmbase zlib pkgconfig lib;
    version = "1.6.1";
    # optional features:
    inherit ctl;
  };

  # This older version is needed by blender (it complains about missing half.h )
  openexr_1_4_0 = import ../development/libraries/openexr {
    inherit fetchurl stdenv ilmbase zlib pkgconfig lib;
    version = "1.4.0";
  };

  openexr = openexr_1_6_1;

  openldap = import ../development/libraries/openldap {
    inherit fetchurl stdenv openssl cyrus_sasl db4 groff;
  };

  openlierox = builderDefsPackage ../games/openlierox {
    inherit (xlibs) libX11 xproto;
    inherit gd SDL SDL_image SDL_mixer zlib libxml2
      pkgconfig;
  };

  libopensc_dnie = import ../development/libraries/libopensc-dnie {
    inherit fetchurl stdenv patchelf writeScript openssl openct
      libtool pcsclite zlib;
    inherit (gtkLibs) glib;
    opensc = opensc_0_11_7;
  };

  openssl = makeOverridable (import ../development/libraries/openssl) {
    fetchurl = fetchurlBoot;
    inherit stdenv perl;
  };

  openssl1 = makeOverridable (import ../development/libraries/openssl/1.x.nix) {
    fetchurl = fetchurlBoot;
    inherit stdenv perl;
  };

  ortp = import ../development/libraries/ortp {
    inherit fetchurl stdenv;
  };

  pangoxsl = import ../development/libraries/pangoxsl {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib pango;
  };

  pcre = makeOverridable (import ../development/libraries/pcre) {
    inherit fetchurl stdenv;
    unicodeSupport = getConfig ["pcre" "unicode"] false;
    cplusplusSupport = !stdenv ? isDietLibC;
  };

  physfs = import ../development/libraries/physfs {
    inherit fetchurl stdenv cmake;
  };

  plib = import ../development/libraries/plib {
    inherit fetchurl stdenv mesa freeglut SDL;
    inherit (xlibs) libXi libSM libXmu libXext libX11;
  };

  podofo = import ../development/libraries/podofo {
    inherit fetchurl stdenv cmake zlib freetype libjpeg libtiff
      fontconfig openssl;
  };

  polkit = import ../development/libraries/polkit {
    inherit stdenv fetchurl pkgconfig eggdbus expat pam intltool gettext glib
      gobjectIntrospection;
  };

  policykit = makeOverridable (import ../development/libraries/policykit) {
    inherit stdenv fetchurl pkgconfig dbus dbus_glib expat pam
      intltool gettext libxslt docbook_xsl glib;
  };

  poppler = makeOverridable (import ../development/libraries/poppler) {
    inherit fetchurl stdenv cairo freetype fontconfig zlib libjpeg pkgconfig;
    inherit (gtkLibs) glib gtk;
    qt4Support = false;
  };

  popplerQt4 = poppler.override {
    inherit qt4;
    qt4Support = true;
  };

  popt = import ../development/libraries/popt {
    inherit fetchurl stdenv;
  };

  proj = import ../development/libraries/proj.4 {
    inherit fetchurl stdenv;
  };

  postgis = import ../development/libraries/postgis {
    inherit stdenv fetchurl libxml2 postgresql geos proj perl flex
      composableDerivation;
  };

  pth = import ../development/libraries/pth {
    inherit fetchurl stdenv;
  };

  qt3 = makeOverridable (import ../development/libraries/qt-3) {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql mesa;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama libXcursor;
    openglSupport = mesaSupported;
    mysqlSupport = getConfig ["qt" "mysql"] false;
  };

  qt3mysql = qt3.override {
    mysqlSupport = true;
  };

  qt4 = qt46;

  qt45 = import ../development/libraries/qt-4.x/4.5 {
    inherit fetchurl stdenv lib zlib libjpeg libpng which mysql mesa openssl cups dbus
      fontconfig freetype pkgconfig libtiff;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor libXext
      inputproto fixesproto libXfixes;
    inherit (gnome) glib;
  };

  qt46 = makeOverridable (import ../development/libraries/qt-4.x/4.6) {
    inherit fetchurl stdenv lib zlib libjpeg libpng which mysql mesa openssl cups dbus
      fontconfig freetype pkgconfig libtiff perl coreutils sqlite alsaLib
      postgresql;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor libXext libXi
      inputproto fixesproto libXfixes;
    inherit (gnome) glib;
  };

  qt47 = makeOverridable (import ../development/libraries/qt-4.x/4.7) {
    inherit fetchurl stdenv lib zlib libjpeg libpng which mysql mesa openssl cups dbus
      fontconfig freetype pkgconfig libtiff perl coreutils sqlite alsaLib
      postgresql pulseaudio;
    inherit (gst_all) gstreamer gstPluginsBase;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor libXext libXi
      inputproto fixesproto libXfixes libXv;
    inherit (gnome) glib;
  };

  qtscriptgenerator = makeOverridable (import ../development/libraries/qtscriptgenerator) {
    inherit stdenv fetchurl;
    qt4 = qt46;
  };

  quesoglc = import ../development/libraries/quesoglc {
    inherit stdenv fetchurl mesa glew freetype fontconfig fribidi;
    inherit (xlibs) libX11;
  };

  readline = readline6;

  readline4 = import ../development/libraries/readline/readline4.nix {
    inherit fetchurl stdenv ncurses;
  };

  readline5 = import ../development/libraries/readline/readline5.nix {
    inherit fetchurl stdenv ncurses;
  };

  readline6 = import ../development/libraries/readline/readline6.nix {
    inherit fetchurl stdenv ncurses;
  };

  librdf_raptor = import ../development/libraries/librdf/raptor.nix {
    inherit fetchurl stdenv lib libxml2 curl;
  };

  librdf_rasqal = import ../development/libraries/librdf/rasqal.nix {
    inherit fetchurl stdenv lib pcre libxml2 gmp librdf_raptor;
  };

  librdf = import ../development/libraries/librdf {
    inherit fetchurl stdenv lib pkgconfig librdf_raptor ladspaH openssl zlib;
  };

  redland = makeOverridable (import ../development/libraries/redland/1.0.10.nix) {
    inherit fetchurl stdenv openssl libxml2 pkgconfig perl sqlite
      mysql libxslt curl pcre librdf_rasqal librdf_raptor;
    bdb = db4;
  };

  rhino = import ../development/libraries/java/rhino {
    inherit fetchurl stdenv unzip;
    ant = apacheAntGcj;
    javac = gcj;
    jvm = gcj;
  };

  rte = import ../development/libraries/rte {
    inherit fetchurl stdenv;
  };

  rubberband = import ../development/libraries/rubberband {
    inherit fetchurl stdenv lib pkgconfig libsamplerate libsndfile ladspaH;
    fftw = fftwSinglePrec;
    inherit (vamp) vampSDK;
  };

  schroedinger = import ../development/libraries/schroedinger {
    inherit fetchurl stdenv liboil pkgconfig;
  };

  SDL = makeOverridable (import ../development/libraries/SDL) {
    inherit fetchurl stdenv pkgconfig x11 mesa alsaLib pulseaudio;
    inherit (xlibs) libXrandr;
    openglSupport = mesaSupported;
    alsaSupport = true;
    pulseaudioSupport = false; # better go through ALSA
  };

  SDL_gfx = import ../development/libraries/SDL_gfx {
    inherit fetchurl stdenv SDL;
  };

  SDL_image = import ../development/libraries/SDL_image {
    inherit fetchurl stdenv SDL libjpeg libungif libtiff libpng;
    inherit (xlibs) libXpm;
  };

  SDL_mixer = import ../development/libraries/SDL_mixer {
    inherit fetchurl stdenv SDL libogg libvorbis;
  };

  SDL_net = import ../development/libraries/SDL_net {
    inherit fetchurl stdenv SDL;
  };

  SDL_ttf = import ../development/libraries/SDL_ttf {
    inherit fetchurl stdenv SDL freetype;
  };

  slang = import ../development/libraries/slang {
    inherit fetchurl stdenv ncurses pcre libpng zlib readline;
  };

  slibGuile = import ../development/libraries/slib {
    inherit fetchurl stdenv unzip texinfo;
    scheme = guile;
  };

  snack = import ../development/libraries/snack {
    inherit fetchurl stdenv tcl tk pkgconfig x11;
        # optional
    inherit alsaLib vorbisTools python;
  };

  speex = import ../development/libraries/speex {
    inherit fetchurl stdenv libogg;
  };

  sqlite = lowPrio (import ../development/libraries/sqlite {
    inherit fetchurl stdenv;
  });

  sqliteInteractive = lowPrio (appendToName "interactive" (import ../development/libraries/sqlite {
    inherit fetchurl stdenv readline ncurses;
  }));

  stlport =  import ../development/libraries/stlport {
    inherit fetchurl stdenv;
  };

  t1lib = import ../development/libraries/t1lib {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXaw libXpm;
  };

  taglib = import ../development/libraries/taglib {
    inherit fetchurl stdenv zlib;
  };

  taglib_extras = import ../development/libraries/taglib-extras {
    inherit stdenv fetchurl cmake taglib;
  };

  talloc = import ../development/libraries/talloc {
    inherit fetchurl stdenv;
  };

##  tapioca_qt = import ../development/libraries/tapioca-qt {
##    inherit stdenv fetchurl cmake qt4 telepathy_qt;
##  };

  tdb = import ../development/libraries/tdb {
    inherit fetchurl stdenv libxslt libxml2 docbook_xsl;
  };

  tecla = import ../development/libraries/tecla {
    inherit fetchurl stdenv;
  };

  telepathy_gabble = import ../development/libraries/telepathy-gabble {
    inherit fetchurl stdenv pkgconfig libxslt telepathy_glib loudmouth;
  };

  telepathy_glib = import ../development/libraries/telepathy-glib {
    inherit fetchurl stdenv dbus_glib pkgconfig libxslt python glib;
  };

  telepathy_qt = import ../development/libraries/telepathy-qt {
    inherit stdenv fetchurl cmake qt4;
  };

  tk = import ../development/libraries/tk {
    inherit fetchurl stdenv tcl x11;
  };

  unixODBC = import ../development/libraries/unixODBC {
    inherit fetchurl stdenv;
  };

  unixODBCDrivers = recurseIntoAttrs (import ../development/libraries/unixODBCDrivers {
    inherit fetchurl stdenv unixODBC glibc libtool openssl zlib;
    inherit postgresql mysql sqlite;
  });

  vamp = import ../development/libraries/audio/vamp {
    inherit fetchurl stdenv lib pkgconfig libsndfile;
  };

  vtk = import ../development/libraries/vtk {
    inherit stdenv fetchurl cmake mesa;
    inherit (xlibs) libX11 xproto libXt;
  };

  vxl = import ../development/libraries/vxl {
   inherit fetchurl stdenv cmake unzip libtiff expat zlib libpng libjpeg;
  };

  webkit = builderDefsPackage (import ../development/libraries/webkit) {
    inherit (gnome28) gtkdoc libsoup;
    inherit (gtkLibs) gtk atk pango glib;
    inherit freetype fontconfig gettext gperf curl
      libjpeg libtiff libpng libxml2 libxslt sqlite
      icu cairo perl intltool automake libtool
      pkgconfig autoconf bison libproxy enchant;
    inherit (gst_all) gstreamer gstPluginsBase gstFfmpeg
      gstPluginsGood;
    flex = flex2535;
    inherit (xlibs) libXt;
  };

  wvstreams = import ../development/libraries/wvstreams {
    inherit stdenv fetchurl qt4 dbus zlib openssl readline perl;
  };

  wxGTK = wxGTK28;

  wxGTK26 = import ../development/libraries/wxGTK-2.6 {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs216) gtk;
    inherit (xlibs) libXinerama libSM libXxf86vm xf86vidmodeproto;
  };

  wxGTK28 = makeOverridable (import ../development/libraries/wxGTK-2.8) {
    inherit fetchurl stdenv pkgconfig mesa;
    inherit (gtkLibs216) gtk;
    inherit (xlibs) libXinerama libSM libXxf86vm xf86vidmodeproto;
  };

  wtk = import ../development/libraries/wtk {
    inherit requireFile stdenv unzip xlibs;
  };

  x264 = import ../development/libraries/x264 {
    inherit fetchurl stdenv yasm;
  };

  xapian = makeOverridable (import ../development/libraries/xapian) {
    inherit fetchurl stdenv zlib;
  };

  xapianBindings = (import ../development/libraries/xapian/bindings/1.0.14.nix) {
    inherit fetchurl stdenv xapian composableDerivation pkgconfig;
    inherit ruby perl php tcl python; # TODO perl php Java, tcl, C#, python
  };

  Xaw3d = import ../development/libraries/Xaw3d {
    inherit fetchurl stdenv x11 bison;
    flex = flex2533;
    inherit (xlibs) imake gccmakedep libXmu libXpm libXp;
  };

  xineLib = import ../development/libraries/xine-lib {
    inherit fetchurl stdenv zlib libdvdcss alsaLib pkgconfig mesa aalib
      libvorbis libtheora speex xlibs perl ffmpeg;
  };

  xautolock = import ../misc/screensavers/xautolock {
    inherit fetchurl stdenv x11;
    inherit (xorg) imake;
    inherit (xlibs) libXScrnSaver scrnsaverproto;
  };

  xercesJava = import ../development/libraries/java/xerces {
    inherit fetchurl stdenv;
    ant   = apacheAntGcj;  # for bootstrap purposes
    javac = gcj;
    jvm   = gcj;
  };

  xlibsWrapper = import ../development/libraries/xlibs-wrapper {
    inherit stdenv;
    packages = [
      freetype fontconfig xlibs.xproto xlibs.libX11 xlibs.libXt
      xlibs.libXft xlibs.libXext xlibs.libSM xlibs.libICE
      xlibs.xextproto
    ];
  };

  xvidcore = import ../development/libraries/xvidcore {
    inherit fetchurl stdenv nasm;
  };

  zangband = builderDefsPackage (import ../games/zangband) {
    inherit ncurses flex bison autoconf automake m4 coreutils;
  };

  zlib = makeOverridable (import ../development/libraries/zlib) {
    fetchurl = fetchurlBoot;
    inherit stdenv;
  };

  zlibStatic = lowPrio (appendToName "static" (import ../development/libraries/zlib {
    inherit fetchurl stdenv;
    static = true;
  }));

  zvbi = import ../development/libraries/zvbi {
    inherit fetchurl stdenv libpng x11;
    pngSupport = true;
  };


  ### DEVELOPMENT / LIBRARIES / JAVA


  atermjava = import ../development/libraries/java/aterm {
    inherit fetchurl sharedobjects jjtraveler jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  commonsFileUpload = import ../development/libraries/java/jakarta-commons/file-upload {
    inherit stdenv fetchurl;
  };

  fastjar = import ../development/tools/java/fastjar {
    inherit fetchurl stdenv zlib;
  };

  httpunit = import ../development/libraries/java/httpunit {
    inherit stdenv fetchurl unzip;
  };

  gwtdragdrop = import ../development/libraries/java/gwt-dragdrop {
    inherit stdenv fetchurl;
  };

  gwtwidgets = import ../development/libraries/java/gwt-widgets {
    inherit stdenv fetchurl;
  };

  jakartabcel = import ../development/libraries/java/jakarta-bcel {
    regexp = jakartaregexp;
    inherit fetchurl stdenv;
  };

  jakartaregexp = import ../development/libraries/java/jakarta-regexp {
    inherit fetchurl stdenv;
  };

  javaCup = import ../development/libraries/java/cup {
    inherit stdenv fetchurl jdk;
  };

  javasvn = import ../development/libraries/java/javasvn {
    inherit stdenv fetchurl unzip;
  };

  jclasslib = import ../development/tools/java/jclasslib {
    inherit fetchurl stdenv xpf jre;
    ant = apacheAnt14;
  };

  jdom = import ../development/libraries/java/jdom {
    inherit stdenv fetchurl;
  };

  jflex = import ../development/libraries/java/jflex {
    inherit stdenv fetchurl;
  };

  jjtraveler = import ../development/libraries/java/jjtraveler {
    inherit fetchurl jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  junit = import ../development/libraries/java/junit {
    inherit stdenv fetchurl unzip;
  };

  lucene = import ../development/libraries/java/lucene {
    inherit stdenv fetchurl;
  };

  mockobjects = import ../development/libraries/java/mockobjects {
    inherit stdenv fetchurl;
  };

  saxon = import ../development/libraries/java/saxon {
    inherit fetchurl stdenv unzip;
  };

  saxonb = import ../development/libraries/java/saxon/default8.nix {
    inherit fetchurl stdenv unzip jre;
  };

  sharedobjects = import ../development/libraries/java/shared-objects {
    inherit fetchurl jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  smack = import ../development/libraries/java/smack {
    inherit stdenv fetchurl;
  };

  swt = import ../development/libraries/java/swt {
    inherit stdenv fetchurl unzip jdk pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXtst;
  };

  xalanj = xalanJava;
  xalanJava = import ../development/libraries/java/xalanj {
    inherit fetchurl stdenv;
    ant    = apacheAntGcj;  # for bootstrap purposes
    javac  = gcj;
    jvm    = gcj;
    xerces = xercesJava;
  };

  zziplib = import ../development/libraries/zziplib {
    inherit fetchurl stdenv perl python zip xmlto zlib;
  };


  ### DEVELOPMENT / PERL MODULES

  buildPerlPackage = import ../development/perl-modules/generic perl;

  perlPackages = recurseIntoAttrs (import ./perl-packages.nix {
    inherit pkgs;
  });

  perlXMLParser = perlPackages.XMLParser;

  ack = perlPackages.ack;

  perlcritic = perlPackages.PerlCritic;

  ### DEVELOPMENT / PYTHON MODULES

  buildPythonPackage =
    import ../development/python-modules/generic {
      inherit python setuptools makeWrapper lib;
    };

  buildPython26Package =
    import ../development/python-modules/generic {
      inherit makeWrapper lib;
      python = python26;
      setuptools = setuptools_python26;
    };

  pythonPackages = python26Packages;

  python25Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs python buildPythonPackage;
  });

  python26Packages = recurseIntoAttrs (import ./python-packages.nix {
    inherit pkgs;
    python = python26;
    buildPythonPackage = buildPython26Package;
  });

  foursuite = import ../development/python-modules/4suite {
    inherit fetchurl stdenv python;
  };

  bsddb3 = import ../development/python-modules/bsddb3 {
    inherit fetchurl stdenv python db4;
  };

  flup = builderDefsPackage ../development/python-modules/flup {
    inherit fetchurl stdenv;
    python = python25;
    setuptools = setuptools.passthru.function {python = python25;};
  };

  numeric = import ../development/python-modules/numeric {
    inherit fetchurl stdenv python;
  };

  pil = import ../development/python-modules/pil {
    inherit fetchurl stdenv python zlib libjpeg freetype;
  };

  psyco = import ../development/python-modules/psyco {
    inherit fetchurl stdenv python;
  };

  pycairo = import ../development/python-modules/pycairo {
    inherit fetchurl stdenv python pkgconfig cairo x11;
  };

  pycrypto = import ../development/python-modules/pycrypto {
    inherit fetchurl stdenv python gmp;
  };

  pycups = import ../development/python-modules/pycups {
    inherit stdenv fetchurl python cups;
  };

  pygame = import ../development/python-modules/pygame {
    inherit fetchurl stdenv python pkgconfig SDL SDL_image
      SDL_mixer SDL_ttf numeric;
  };

  pygobject = import ../development/python-modules/pygobject {
    inherit fetchurl stdenv python pkgconfig glib;
  };

  pygtk = import ../development/python-modules/pygtk {
    inherit fetchurl stdenv python pkgconfig pygobject pycairo;
    inherit (gtkLibs) glib gtk;
  };

  pyGtkGlade = import ../development/python-modules/pygtk {
    inherit fetchurl stdenv python pkgconfig pygobject pycairo;
    inherit (gtkLibs) glib gtk;
    inherit (gnome) libglade;
  };

  pyopenssl = builderDefsPackage (import ../development/python-modules/pyopenssl) {
    inherit python openssl;
  };

  rhpl = import ../development/python-modules/rhpl {
    inherit stdenv fetchurl rpm cpio python wirelesstools gettext;
  };

  sip = import ../development/python-modules/python-sip {
    inherit stdenv fetchurl python;
  };

  pyqt4 = import ../development/python-modules/pyqt {
    inherit stdenv fetchurl python qt4 sip;
  };

  pyx = import ../development/python-modules/pyx {
    inherit fetchurl stdenv python makeWrapper;
  };

  pyxml = import ../development/python-modules/pyxml {
    inherit fetchurl stdenv python makeWrapper;
  };

  setuptools = builderDefsPackage (import ../development/python-modules/setuptools) {
    inherit python makeWrapper;
  };

  setuptools_python26 = builderDefsPackage (import ../development/python-modules/setuptools) {
    inherit makeWrapper;
    python = python26;
  };

  wxPython = wxPython26;

  wxPython26 = import ../development/python-modules/wxPython/2.6.nix {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK26;
  };

  wxPython28 = import ../development/python-modules/wxPython/2.8.nix {
    inherit fetchurl stdenv pkgconfig python;
    inherit wxGTK;
  };

  twisted = pythonPackages.twisted;

  ZopeInterface = pythonPackages.zopeInterface;

  zope = import ../development/python-modules/zope {
    inherit fetchurl stdenv;
    python = python24;
  };

  ### SERVERS


  apacheHttpd = makeOverridable (import ../servers/http/apache-httpd) {
    inherit (pkgsOverriden) fetchurl stdenv perl openssl zlib apr aprutil pcre;
    sslSupport = true;
  };

  sabnzbd = import ../servers/sabnzbd {
    inherit fetchurl stdenv python cheetahTemplate makeWrapper par2cmdline unzip unrar;
  };

  bind = builderDefsPackage (import ../servers/dns/bind/9.5.0.nix) {
    inherit openssl libtool;
  };

  dico = import ../servers/dico {
    inherit fetchurl stdenv libtool gettext zlib readline guile python;
  };

  dict = makeOverridable (import ../servers/dict) {
    inherit fetchurl stdenv which bison flex;
  };

  dictdDBs = recurseIntoAttrs (import ../servers/dict/dictd-db.nix {
    inherit builderDefs;
  });

  dictDBCollector = import ../servers/dict/dictd-db-collector.nix {
    inherit stdenv lib dict;
  };

  dovecot = import ../servers/mail/dovecot {
    inherit fetchurl stdenv openssl pam;
  };
  dovecot_1_1_1 = import ../servers/mail/dovecot/1.1.1.nix {
    inherit fetchurl stdenv openssl pam;
  };

  ejabberd = import ../servers/xmpp/ejabberd {
    inherit fetchurl stdenv expat erlang zlib openssl pam lib;
  };

  couchdb = import ../servers/http/couchdb {
    inherit fetchurl stdenv erlang spidermonkey icu getopt
      curl;
  };

  felix = import ../servers/felix {
    inherit stdenv fetchurl;
  };

  felix_remoteshell = import ../servers/felix/remoteshell.nix {
    inherit stdenv fetchurl;
  };

  fingerd_bsd = import ../servers/fingerd/bsd-fingerd {
    inherit fetchurl stdenv;
  };

  ircdHybrid = import ../servers/irc/ircd-hybrid {
    inherit fetchurl stdenv openssl zlib;
  };

  jboss = import ../servers/http/jboss {
    inherit fetchurl stdenv unzip jdk lib;
  };

  jboss_mysql_jdbc = import ../servers/http/jboss/jdbc/mysql {
    inherit stdenv jboss mysql_jdbc;
  };

  jetty = import ../servers/http/jetty {
    inherit fetchurl stdenv unzip;
  };

  jetty61 = import ../servers/http/jetty/6.1 {
    inherit fetchurl stdenv unzip;
  };

  lighttpd = import ../servers/http/lighttpd {
    inherit fetchurl stdenv pcre libxml2 zlib attr bzip2;
  };

  mod_python = makeOverridable (import ../servers/http/apache-modules/mod_python) {
    inherit (pkgsOverriden) fetchurl stdenv apacheHttpd python;
  };

  mpd = import ../servers/mpd {
    inherit stdenv fetchurl pkgconfig glib alsaLib flac libvorbis libmad
            libid3tag libmikmod libcue;
  };

  myserver = import ../servers/http/myserver {
    inherit fetchurl stdenv libgcrypt libevent libidn gnutls libxml2
      zlib texinfo cppunit xz;
  };

  nginx = builderDefsPackage (import ../servers/http/nginx) {
    inherit openssl pcre zlib libxml2 libxslt;
  };

  postfix = import ../servers/mail/postfix {
    inherit fetchurl stdenv db4 openssl cyrus_sasl glibc;
  };

  pulseaudio = makeOverridable (import ../servers/pulseaudio) {
    inherit fetchurl stdenv pkgconfig gnum4 gdbm
      dbus hal avahi liboil libsamplerate libsndfile speex
      intltool gettext libtool libcap;
    inherit (xlibs) libX11 libICE libSM libXtst libXi;
    inherit (gtkLibs) gtk glib;
    inherit alsaLib;    # Needs ALSA >= 1.0.17.
    gconf = gnome.GConf;
  };

  tomcat_connectors = import ../servers/http/apache-modules/tomcat-connectors {
    inherit fetchurl stdenv apacheHttpd jdk;
  };

  portmap = makeOverridable (import ../servers/portmap) {
    inherit fetchurl stdenv lib tcpWrapper;
  };

  monetdb = import ../servers/sql/monetdb {
    inherit composableDerivation getConfig;
    inherit fetchurl stdenv pcre openssl readline libxml2 geos apacheAnt jdk5;
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

  mysql = mysql5;

  mysql_jdbc = import ../servers/sql/mysql/jdbc {
    inherit fetchurl stdenv ant;
  };

  nagios = import ../servers/monitoring/nagios {
    inherit fetchurl stdenv perl gd libpng zlib;
    gdSupport = true;
  };

  nagiosPluginsOfficial = import ../servers/monitoring/nagios/plugins/official {
    inherit fetchurl stdenv openssh;
  };

  openfire = composedArgsAndFun (import ../servers/xmpp/openfire) {
    inherit builderDefs jre;
  };

  postgresql = postgresql83;

  postgresql83 = import ../servers/sql/postgresql/8.3.x.nix {
    inherit fetchurl stdenv readline ncurses zlib;
  };

  postgresql84 = import ../servers/sql/postgresql/8.4.x.nix {
    inherit fetchurl stdenv readline ncurses zlib;
  };

  postgresql_jdbc = import ../servers/sql/postgresql/jdbc {
    inherit fetchurl stdenv ant;
  };

  pyIRCt = builderDefsPackage (import ../servers/xmpp/pyIRCt) {
    inherit xmpppy pythonIRClib python makeWrapper;
  };

  pyMAILt = builderDefsPackage (import ../servers/xmpp/pyMAILt) {
    inherit xmpppy python makeWrapper fetchcvs;
  };

  radius = import ../servers/radius {
    inherit fetchurl stdenv m4 groff readline;
  };

  samba = makeOverridable (import ../servers/samba) {
    inherit stdenv fetchurl readline openldap pam kerberos popt iniparser
      libunwind acl fam;
  };

  shishi = import ../servers/shishi {
    inherit fetchurl stdenv libtasn1 libgcrypt gnutls;
  };

  squids = recurseIntoAttrs( import ../servers/squid/squids.nix {
    inherit fetchurl stdenv perl lib composableDerivation;
  });
  squid = squids.squid3Beta; # has ipv6 support

  tomcat5 = import ../servers/http/tomcat {
    inherit fetchurl stdenv jdk;
  };

  tomcat6 = import ../servers/http/tomcat/6.0.nix {
    inherit fetchurl stdenv jdk;
  };

  tomcat_mysql_jdbc = import ../servers/http/tomcat/jdbc/mysql {
    inherit stdenv tomcat6 mysql_jdbc;
  };

  axis2 = import ../servers/http/tomcat/axis2 {
    inherit fetchurl stdenv jdk apacheAnt unzip;
  };

  virtuoso = makeOverridable (import ../servers/sql/virtuoso) {
    inherit stdenv fetchurl libxml2 openssl readline gawk;
  };

  vsftpd = import ../servers/ftp/vsftpd {
    inherit fetchurl openssl stdenv libcap pam;
  };

  xinetd = import ../servers/xinetd {
    inherit fetchurl stdenv;
  };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg/default.nix {
    inherit fetchurl fetchsvn stdenv pkgconfig freetype fontconfig
      libxslt expat libdrm libpng zlib perl mesa
      xkeyboard_config dbus hal libuuid openssl gperf m4
      automake autoconf libtool xmlto asciidoc;

    # !!! pythonBase is use instead of python because this cause an infinite
    # !!! recursion when the flag python.full is set to true.  Packages
    # !!! contained in the loop are python, tk, xlibs-wrapper, libX11,
    # !!! libxcd (and xcb-proto).
    python =  pythonBase;
  });

  xorgReplacements = composedArgsAndFun (import ../servers/x11/xorg/replacements.nix) {
    inherit fetchurl stdenv automake autoconf libtool xorg composedArgsAndFun;
  };

  xorgVideoUnichrome = import ../servers/x11/xorg/unichrome/default.nix {
    inherit stdenv fetchgit pkgconfig libdrm mesa automake autoconf libtool;
    inherit (xorg) fontsproto libpciaccess randrproto renderproto videoproto
      libX11 xextproto xf86driproto xorgserver xproto libXvMC glproto
      libXext utilmacros;
  };

  zabbix = recurseIntoAttrs (import ../servers/monitoring/zabbix {
    inherit fetchurl stdenv pkgconfig postgresql curl openssl zlib;
  });


  ### OS-SPECIFIC

  afuse = import ../os-specific/linux/afuse {
    inherit fetchurl stdenv lib pkgconfig fuse;
  };

  autofs5 = import ../os-specific/linux/autofs/autofs-v5.nix {
    inherit sourceFromHead fetchurl stdenv flex bison linuxHeaders;
  };

  _915resolution = import ../os-specific/linux/915resolution {
    inherit fetchurl stdenv;
  };

  nfsUtils = import ../os-specific/linux/nfs-utils {
    inherit fetchurl stdenv tcpWrapper utillinuxng libcap;
  };

  acpi = import ../os-specific/linux/acpi {
    inherit fetchurl stdenv;
  };

  acpid = import ../os-specific/linux/acpid {
    inherit fetchurl stdenv;
  };

  acpitool = import ../os-specific/linux/acpitool {
    inherit fetchurl stdenv;
  };

  alsaLib = import ../os-specific/linux/alsa-lib {
    inherit stdenv fetchurl;
  };

  alsaPlugins = import ../os-specific/linux/alsa-plugins {
    inherit fetchurl stdenv lib pkgconfig alsaLib pulseaudio jackaudio;
  };
  alsaPluginWrapper = import ../os-specific/linux/alsa-plugins/wrapper.nix {
    inherit stdenv alsaPlugins writeScriptBin;
  };

  alsaUtils = import ../os-specific/linux/alsa-utils {
    inherit stdenv fetchurl alsaLib gettext ncurses;
  };

  bluez = import ../os-specific/linux/bluez {
    inherit fetchurl stdenv pkgconfig dbus libusb alsaLib glib;
  };

  bridge_utils = import ../os-specific/linux/bridge_utils {
    inherit fetchurl stdenv autoconf automake;
  };

  conky = import ../os-specific/linux/conky {
    inherit stdenv fetchurl pkgconfig libxml2 curl wirelesstools openssl;
    inherit (gtkLibs) glib;
  };

  cpufrequtils = (
    import ../os-specific/linux/cpufrequtils {
    inherit fetchurl stdenv libtool gettext;
    glibc = stdenv.gcc.libc;
    linuxHeaders = stdenv.gcc.libc.kernelHeaders;
  });

  cryopid = import ../os-specific/linux/cryopid {
    inherit fetchurl stdenv zlibStatic;
  };

  cryptsetup = import ../os-specific/linux/cryptsetup {
    inherit stdenv fetchurl libuuid popt devicemapper udev;
  };

  cramfsswap = import ../os-specific/linux/cramfsswap {
    inherit fetchurl stdenv zlib;
  };

  darwinArchUtility = import ../os-specific/darwin/arch {
    inherit stdenv;
  };

  darwinSwVersUtility = import ../os-specific/darwin/sw_vers {
    inherit stdenv;
  };

  darwinLipoUtility = import ../os-specific/darwin/lipo {
    inherit stdenv;
  };

  devicemapper = lvm2;

  dmidecode = import ../os-specific/linux/dmidecode {
    inherit fetchurl stdenv;
  };

  dmtcp = import ../os-specific/linux/dmtcp {
    inherit fetchurl stdenv perl python;
  };

  dmtcp_devel = import ../os-specific/linux/dmtcp/devel.nix {
    inherit fetchsvn stdenv perl python;
  };

  dietlibc = import ../os-specific/linux/dietlibc {
    inherit fetchurl glibc;
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

  libuuid = if ! stdenv.isDarwin then utillinuxng else null;

  e3cfsprogs = import ../os-specific/linux/e3cfsprogs {
    inherit stdenv fetchurl gettext;
  };

  eject = import ../os-specific/linux/eject {
    inherit fetchurl stdenv gettext;
  };

  fbterm = builderDefsPackage (import ../os-specific/linux/fbterm) {
    inherit fontconfig gpm freetype pkgconfig ncurses;
  };

  fuse = import ../os-specific/linux/fuse {
    inherit fetchurl stdenv utillinux;
  };

  fxload = import ../os-specific/linux/fxload {
    inherit fetchurl stdenv;
  };

  gpm = import ../servers/gpm {
    inherit fetchurl stdenv ncurses bison;
    flex = flex2535;
  };

  hal = makeOverridable (import ../os-specific/linux/hal) {
    inherit fetchurl stdenv pkgconfig python pciutils usbutils expat
      libusb dbus dbus_glib libuuid perl perlXMLParser
      gettext zlib eject libsmbios udev gperf dmidecode utillinuxng
      consolekit policykit pmutils glib;
  };

  halevt = import ../os-specific/linux/hal/hal-evt.nix {
    inherit fetchurl stdenv lib libxml2 pkgconfig boolstuff hal dbus_glib;
  };

  hal_info = import ../os-specific/linux/hal/info.nix {
    inherit fetchurl stdenv pkgconfig;
  };

  hal_info_synaptics = import ../os-specific/linux/hal/synaptics.nix {
    inherit stdenv;
  };

  hdparm = import ../os-specific/linux/hdparm {
    inherit fetchurl stdenv;
  };

  hibernate = import ../os-specific/linux/hibernate {
    inherit fetchurl stdenv gawk;
  };

  htop = import ../os-specific/linux/htop {
    inherit fetchurl stdenv ncurses;
  };

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

  hurdHeaders = import ../os-specific/gnu/hurd {
    inherit fetchgit stdenv autoconf libtool texinfo mig machHeaders;
    automake = automake111x;
    headersOnly = true;
  };

  hurdLibpthreadCross = forceBuildDrv(import ../os-specific/gnu/libpthread {
    inherit fetchgit stdenv autoconf automake libtool
      machHeaders hurdHeaders glibcCross;
    hurd = hurdCrossIntermediate;
    gccCross = gccCrossStageStatic;
    cross = assert crossSystem != null; crossSystem;
  });

  hwdata = import ../os-specific/linux/hwdata {
    inherit fetchurl stdenv;
  };

  ifplugd = import ../os-specific/linux/ifplugd {
    inherit fetchurl stdenv pkgconfig libdaemon;
  };

  iproute = import ../os-specific/linux/iproute {
    inherit fetchurl stdenv flex bison db4;
  };

  iputils = (
    import ../os-specific/linux/iputils {
    inherit fetchurl stdenv;
    glibc = stdenv.gcc.libc;
    linuxHeaders = stdenv.gcc.libc.kernelHeaders;
  });

  iptables = import ../os-specific/linux/iptables {
    inherit fetchurl stdenv;
  };

  ipw2200fw = import ../os-specific/linux/firmware/ipw2200 {
    inherit fetchurl stdenv;
  };

  iwlwifi1000ucode = import ../os-specific/linux/firmware/iwlwifi-1000-ucode {
    inherit fetchurl stdenv;
  };

  iwlwifi3945ucode = import ../os-specific/linux/firmware/iwlwifi-3945-ucode {
    inherit fetchurl stdenv;
  };

  iwlwifi4965ucodeV1 = import ../os-specific/linux/firmware/iwlwifi-4965-ucode {
    inherit fetchurl stdenv;
  };

  iwlwifi4965ucodeV2 = import ../os-specific/linux/firmware/iwlwifi-4965-ucode/version-2.nix {
    inherit fetchurl stdenv;
  };

  iwlwifi5000ucode = import ../os-specific/linux/firmware/iwlwifi-5000-ucode {
    inherit fetchurl stdenv;
  };

  kbd = import ../os-specific/linux/kbd {
    inherit fetchurl stdenv bison flex autoconf automake;
  };

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

  linuxHeaders_2_6_18 = import ../os-specific/linux/kernel-headers/2.6.18.5.nix {
    inherit fetchurl stdenv unifdef;
  };

  linuxHeaders_2_6_28 = import ../os-specific/linux/kernel-headers/2.6.28.nix {
    inherit fetchurl stdenv perl;
  };

  linuxHeaders_2_6_32 = import ../os-specific/linux/kernel-headers/2.6.32.nix {
    inherit fetchurl stdenv perl;
  };

  kernelPatches = import ../os-specific/linux/kernel/patches.nix {
    inherit fetchurl;
  };

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

  /* Linux kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  linuxPackagesFor = kernel: rec {

    inherit kernel;

    ati_drivers_x11  = import ../os-specific/linux/ati-drivers {
      inherit stdenv fetchurl kernel xlibs which mesa xorg makeWrapper
        patchelf glibc;
      inherit (xorg) imake libXxf86vm xf86vidmodeproto;
    };

    aufs = import ../os-specific/linux/aufs {
      inherit fetchurl stdenv kernel;
    };

    # Currently it is broken
    # Build requires exporting some symbols from kernel
    # Go to package homepage to learn about the needed
    # patch. Feel free to take over the package.
    aufs2 = import ../os-specific/linux/aufs2 {
      inherit fetchgit stdenv kernel perl;
    };

    aufs2Utils = if lib.attrByPath ["features" "aufs"] false kernel then
      builderDefsPackage ../os-specific/linux/aufs2-utils {
        inherit kernel;
      }
    else null;

    blcr = import ../os-specific/linux/blcr/0.8.2.nix {
      inherit fetchurl stdenv kernel perl makeWrapper;
    };

    exmap = import ../os-specific/linux/exmap {
      inherit fetchurl stdenv kernel boost pcre pkgconfig;
      inherit (gtkLibs) gtkmm;
    };

    iwlwifi = import ../os-specific/linux/iwlwifi {
      inherit fetchurl stdenv kernel;
    };

    iwlwifi4965ucode =
      (if (builtins.compareVersions kernel.version "2.6.27" == 0)
          || (builtins.compareVersions kernel.version "2.6.27" == 1)
       then iwlwifi4965ucodeV2
       else iwlwifi4965ucodeV1);

    atheros = composedArgsAndFun (import ../os-specific/linux/atheros/0.9.4.nix) {
      inherit fetchurl stdenv builderDefs kernel lib;
    };

    nvidia_x11 = import ../os-specific/linux/nvidia-x11 {
      inherit stdenv fetchurl kernel xlibs gtkLibs zlib perl;
    };

    nvidia_x11_legacy = import ../os-specific/linux/nvidia-x11/legacy.nix {
      inherit stdenv fetchurl kernel xlibs gtkLibs zlib;
    };

    openafsClient = import ../servers/openafs-client {
      inherit stdenv fetchurl autoconf automake flex yacc;
      inherit kernel glibc ncurses perl krb5;
    };

    wis_go7007 = import ../os-specific/linux/wis-go7007 {
      inherit fetchurl stdenv kernel ncurses fxload;
    };

    kqemu = builderDefsPackage ../os-specific/linux/kqemu/1.4.0pre1.nix {
      inherit kernel perl;
    };

    splashutils =
      if kernel.features ? fbConDecor then pkgs.splashutils else null;

    ext3cowtools = import ../os-specific/linux/ext3cow-tools {
      inherit stdenv fetchurl;
      kernel_ext3cowpatched = kernel;
    };

    /* compiles but has to be integrated into the kernel somehow
      Let's have it uncommented and finish it..
    */
    ndiswrapper = import ../os-specific/linux/ndiswrapper {
      inherit fetchurl stdenv;
      inherit kernel perl;
    };

    ov511 = import ../os-specific/linux/ov511 {
      inherit fetchurl kernel;
      stdenv = overrideGCC stdenv gcc34;
    };

    # State Nix
    snix = import ../tools/package-management/snix {
      inherit fetchurl stdenv perl curl bzip2 openssl bison;
      inherit libtool automake autoconf docbook5 docbook5_xsl libxslt docbook_xml_dtd_43 w3m;

      aterm = aterm25;
      db4 = db45;

      flex = flex2533;

      inherit ext3cowtools e3cfsprogs rsync;
      ext3cow_kernel = kernel;
    };

    sysprof = import ../development/tools/profiling/sysprof {
      inherit fetchurl stdenv binutils pkgconfig kernel;
      inherit (gnome) gtk glib pango libglade;
    };

    systemtap = import ../development/tools/profiling/systemtap {
      inherit fetchurl stdenv elfutils latex2html xmlto pkgconfig boost
        texLive texLiveExtra ghostscript perl docbook_xml_dtd_412 libxml2
        docbook_xsl libxslt sqlite;
      linux = kernel;
      inherit (gnome) gtkmm libglademm;
    };

    virtualbox = import ../applications/virtualization/virtualbox {
      stdenv = stdenv_32bit;
      inherit fetchurl lib iasl dev86 libxslt libxml2 SDL hal
          libcap libpng zlib kernel python which alsaLib curl glib qt4;
      inherit (xlibs) xproto libX11 libXext libXcursor;
      inherit (gnome) libIDL;
    };

    virtualboxGuestAdditions = import ../applications/virtualization/virtualbox/guest-additions {
      inherit stdenv fetchurl lib patchelf cdrkit kernel;
      inherit (xlibs) libX11 libXt libXext libXmu libXcomposite libXfixes;
    };
  };

  # Build the kernel modules for the some of the kernels.
  linuxPackages_2_6_25 = recurseIntoAttrs (linuxPackagesFor linux_2_6_25);
  linuxPackages_2_6_27 = recurseIntoAttrs (linuxPackagesFor linux_2_6_27);
  linuxPackages_2_6_28 = recurseIntoAttrs (linuxPackagesFor linux_2_6_28);
  linuxPackages_2_6_29 = recurseIntoAttrs (linuxPackagesFor linux_2_6_29);
  linuxPackages_2_6_31 = recurseIntoAttrs (linuxPackagesFor linux_2_6_31);
  linuxPackages_2_6_32 = recurseIntoAttrs (linuxPackagesFor linux_2_6_32);
  linuxPackages_2_6_32_systemtap =
    recurseIntoAttrs (linuxPackagesFor linux_2_6_32_systemtap);
  linuxPackages_2_6_33 = recurseIntoAttrs (linuxPackagesFor linux_2_6_33);

  # The current default kernel / kernel modules.
  linux = linux_2_6_32;
  linuxPackages = linuxPackagesFor linux;

  customKernel = composedArgsAndFun (lib.sumTwoArgs (import ../os-specific/linux/kernel/generic.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools;
  });

  keyutils = import ../os-specific/linux/keyutils {
    inherit fetchurl stdenv;
  };

  libselinux = import ../os-specific/linux/libselinux {
    inherit fetchurl stdenv libsepol;
  };

  libraw1394 = import ../development/libraries/libraw1394 {
    inherit fetchurl stdenv;
  };

  libsexy = import ../development/libraries/libsexy {
    inherit stdenv fetchurl pkgconfig libxml2;
    inherit (gtkLibs) glib gtk pango;
  };

  librsvg = gnome.librsvg;

  libsepol = import ../os-specific/linux/libsepol {
    inherit fetchurl stdenv;
  };

  libsmbios = import ../os-specific/linux/libsmbios {
    inherit fetchurl stdenv pkgconfig libxml2 perl;
  };

  lm_sensors = import ../os-specific/linux/lm_sensors {
    inherit fetchurl stdenv bison flex perl;
  };

  klibc = makeOverridable (import ../os-specific/linux/klibc) {
    inherit fetchurl stdenv perl bison mktemp;
    linuxHeaders = glibc.kernelHeaders;
  };

  # Old version; needed in vmtools for insmod.  Should use
  # module_init_tools instead.
  klibc_15 = makeOverridable (import ../os-specific/linux/klibc/1.5.nix) {
    inherit fetchurl stdenv perl bison mktemp;
    linuxHeaders = glibc.kernelHeaders;
  };

  klibcShrunk = makeOverridable (import ../os-specific/linux/klibc/shrunk.nix) {
    inherit stdenv klibc;
  };

  kvm = kvm76;

  kvm76 = import ../os-specific/linux/kvm/76.nix {
    inherit fetchurl stdenv zlib e2fsprogs SDL alsaLib pkgconfig rsync;
    linuxHeaders = glibc.kernelHeaders;
  };

  kvm86 = import ../os-specific/linux/kvm/86.nix {
    inherit fetchurl stdenv zlib SDL alsaLib pkgconfig pciutils;
    linuxHeaders = glibc.kernelHeaders;
  };

  kvm88 = import ../os-specific/linux/kvm/88.nix {
    inherit fetchurl stdenv zlib SDL alsaLib pkgconfig pciutils;
    linuxHeaders = glibc.kernelHeaders;
  };

  libcap = import ../os-specific/linux/libcap {
    inherit fetchurl stdenv attr;
  };

  libnscd = import ../os-specific/linux/libnscd {
    inherit fetchurl stdenv;
  };

  libnotify = import ../development/libraries/libnotify {
    inherit stdenv fetchurl pkgconfig dbus dbus_glib;
    inherit (gtkLibs) gtk glib;
  };

  libvolume_id = import ../os-specific/linux/libvolume_id {
    inherit fetchurl stdenv;
  };

  lvm2 = import ../os-specific/linux/lvm2 {
    inherit fetchurl stdenv udev;
  };

  # In theory GNU Mach doesn't have to be cross-compiled.  However, since it
  # has to be built for i586 (it doesn't work on x86_64), one needs a cross
  # compiler for that host.
  mach = import ../os-specific/gnu/mach {
    inherit fetchgit stdenv autoconf texinfo mig;
    automake = automake111x;
  };

  machHeaders = import ../os-specific/gnu/mach {
    inherit fetchgit stdenv autoconf texinfo;
    automake = automake111x;
    headersOnly = true;
  };

  mdadm = import ../os-specific/linux/mdadm {
    inherit fetchurl stdenv groff;
  };

  mingetty = import ../os-specific/linux/mingetty {
    inherit fetchurl stdenv;
  };

  module_init_tools = import ../os-specific/linux/module-init-tools {
    inherit fetchurl stdenv;
  };

  mount_cifs = import ../os-specific/linux/mount-cifs {
    inherit fetchurl stdenv;
  };

  aggregateModules = modules:
    import ../os-specific/linux/module-init-tools/aggregator.nix {
      inherit stdenv module_init_tools modules buildEnv;
    };

  modutils = import ../os-specific/linux/modutils {
    inherit fetchurl bison flex;
    stdenv = overrideGCC stdenv gcc34;
  };

  nettools = import ../os-specific/linux/net-tools {
    inherit fetchurl stdenv;
  };

  neverball = import ../games/neverball {
    inherit stdenv fetchurl SDL mesa libpng libjpeg SDL_ttf libvorbis
      gettext physfs;
  };

  numactl = import ../os-specific/linux/numactl {
    inherit fetchurl stdenv;
  };

  gw6c = builderDefsPackage (import ../os-specific/linux/gw6c) {
    inherit fetchurl stdenv nettools openssl procps iproute;
  };

  nss_ldap = import ../os-specific/linux/nss_ldap {
    inherit fetchurl stdenv openldap;
  };

  pam = import ../os-specific/linux/pam {
    inherit stdenv fetchurl cracklib flex;
  };

  # pam_bioapi ( see http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader )

  pam_console = import ../os-specific/linux/pam_console {
    inherit stdenv fetchurl pam autoconf automake pkgconfig bison glib;
    libtool = libtool_1_5;
    flex = if stdenv.system == "i686-linux" then flex else flex2533;
  };

  pam_devperm = import ../os-specific/linux/pam_devperm {
    inherit stdenv fetchurl pam;
  };

  pam_ldap = import ../os-specific/linux/pam_ldap {
    inherit stdenv fetchurl pam openldap;
  };

  pam_login = import ../os-specific/linux/pam_login {
    inherit stdenv fetchurl pam;
  };

  pam_unix2 = import ../os-specific/linux/pam_unix2 {
    inherit stdenv fetchurl pam libxcrypt;
  };

  pam_usb = import ../os-specific/linux/pam_usb {
    inherit stdenv fetchurl makeWrapper useSetUID dbus libxml2 pam hal pkgconfig pmount python pythonDBus;
  };

  pcmciaUtils = composedArgsAndFun (import ../os-specific/linux/pcmciautils) {
    inherit stdenv fetchurl udev yacc flex;
    inherit sysfsutils module_init_tools;

    firmware = getConfig ["pcmciaUtils" "firmware"] [];
    config = getConfig ["pcmciaUtils" "config"] null;
    inherit lib;
  };

  pmount = import ../os-specific/linux/pmount {
    inherit fetchurl stdenv cryptsetup dbus dbus_glib hal intltool ntfs3g utillinuxng;
  };

  pmutils = import ../os-specific/linux/pm-utils {
    inherit fetchurl stdenv;
  };

  powertop = import ../os-specific/linux/powertop {
    inherit fetchurl stdenv ncurses gettext;
  };

  procps = import ../os-specific/linux/procps {
    inherit fetchurl stdenv ncurses;
  };

  pwdutils = import ../os-specific/linux/pwdutils {
    inherit fetchurl stdenv pam gnutls libnscd;
  };

  qemu_kvm = import ../os-specific/linux/qemu-kvm {
    inherit fetchurl stdenv zlib SDL alsaLib pkgconfig pciutils libuuid;
  };

  radeontools = import ../os-specific/linux/radeontools {
    inherit pciutils;
    inherit fetchurl stdenv;
  };

  rfkill = import ../os-specific/linux/rfkill {
    inherit fetchurl stdenv;
  };

  rt73fw = import ../os-specific/linux/firmware/rt73 {
    inherit fetchurl stdenv unzip;
  };

  sdparm = import ../os-specific/linux/sdparm {
    inherit fetchurl stdenv;
  };

  shadowutils = import ../os-specific/linux/shadow {
    inherit fetchurl stdenv;
  };

  splashutils = import ../os-specific/linux/splashutils/default.nix {
    inherit fetchurl stdenv klibc;
    zlib = zlibStatic;
    libjpeg = libjpegStatic;
  };

  statifier = builderDefsPackage (import ../os-specific/linux/statifier) {
  };

  sysfsutils = import ../os-specific/linux/sysfsutils {
    inherit fetchurl stdenv;
  };

  # Provided with sysfsutils.
  libsysfs = sysfsutils;
  systool = sysfsutils;

  sysklogd = import ../os-specific/linux/sysklogd {
    inherit fetchurl stdenv;
  };

  syslinux = import ../os-specific/linux/syslinux {
    inherit fetchurl stdenv nasm perl;
  };

  sysstat = import ../os-specific/linux/sysstat {
    inherit fetchurl stdenv gettext;
  };

  sysvinit = import ../os-specific/linux/sysvinit {
    inherit fetchurl stdenv;
  };

  sysvtools = import ../os-specific/linux/sysvinit {
    inherit fetchurl stdenv;
    withoutInitTools = true;
  };

  # FIXME: `tcp-wrapper' is actually not OS-specific.
  tcpWrapper = import ../os-specific/linux/tcp-wrapper {
    inherit fetchurl stdenv;
  };

  trackballs = import ../games/trackballs {
    inherit stdenv fetchurl SDL mesa SDL_ttf gettext zlib SDL_mixer SDL_image guile;
    debug = false;
  };

  tunctl = import ../os-specific/linux/tunctl {
    inherit stdenv fetchurl;
  };

  /*tuxracer = builderDefsPackage (import ../games/tuxracer) {
    inherit mesa tcl freeglut;
    inherit (xlibs) libX11 xproto;
  };*/

  ubootChooser = name : if (name == "upstream") then ubootUpstream
    else if (name == "sheevaplug") then ubootSheevaplug
    else throw "Unknown uboot";

  ubootUpstream  = makeOverridable (import ../misc/uboot) {
    inherit fetchurl stdenv unzip;
  };

  ubootSheevaplug = makeOverridable (import ../misc/uboot/sheevaplug.nix) {
    inherit fetchurl stdenv unzip;
  };

/*
  uclibc = import ../os-specific/linux/uclibc {
    inherit fetchurl stdenv linuxHeaders;
  };
*/

  uclibcCross = import ../os-specific/linux/uclibc {
    inherit fetchurl stdenv;
    linuxHeaders = linuxHeadersCross;
    gccCross = gccCrossStageStatic;
    cross = assert crossSystem != null; crossSystem;
  };

  udev = makeOverridable (import ../os-specific/linux/udev) {
    inherit fetchurl stdenv gperf pkgconfig acl libusb usbutils pciutils glib;
  };

  uml = import ../os-specific/linux/kernel/linux-2.6.29.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    userModeLinux = true;
  };

  umlutilities = import ../os-specific/linux/uml-utilities {
    inherit fetchurl linuxHeaders stdenv readline lib;
    tunctl = true; mconsole = true;
  };

  upstart = import ../os-specific/linux/upstart {
    inherit fetchurl stdenv pkgconfig dbus libnih;
  };

  upstartJobControl = import ../os-specific/linux/upstart/jobcontrol.nix {
    inherit stdenv;
  };

  usbutils = import ../os-specific/linux/usbutils {
    inherit fetchurl stdenv pkgconfig libusb;
  };

  utillinux = utillinuxng;

  utillinuxCurses = utillinuxngCurses;

  utillinuxng = makeOverridable (import ../os-specific/linux/util-linux-ng) {
    inherit fetchurl stdenv;
  };

  utillinuxngCurses = utillinuxng.override {
    inherit ncurses;
  };

  windows = rec {
    w32api = makeOverridable (import ../os-specific/windows/w32api) {
      inherit fetchurl stdenv;
      gccCross = gccCrossStageStatic;
      binutilsCross = binutilsCross;
    };

    w32api_headers = w32api.override {
      onlyHeaders = true;
    };

    mingw_runtime = makeOverridable (import ../os-specific/windows/mingwrt) {
      inherit fetchurl stdenv;
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

    wxMSW = makeOverridable (import ../os-specific/windows/wxMSW-2.8) {
      inherit fetchurl stdenv;
    };
  };

  wesnoth = import ../games/wesnoth {
    inherit fetchurl stdenv SDL SDL_image SDL_mixer SDL_net SDL_ttf
      gettext zlib boost freetype libpng pkgconfig;
    inherit (gtkLibs) pango;
  };

  wirelesstools = import ../os-specific/linux/wireless-tools {
    inherit fetchurl stdenv;
  };

  wpa_supplicant = makeOverridable (import ../os-specific/linux/wpa_supplicant) {
    inherit fetchurl stdenv openssl;
    inherit qt4;
    guiSupport = false;
  };
  # prebuild binaries:
  wpa_supplicant_gui = wpa_supplicant.override { guiSupport = true; };

  # deprecated, but contains icon ? Does no longer build
  /* didn't build Sun Apr 25 20:34:18 CEST 2010
  wpa_supplicant_gui_qt4_old = import ../os-specific/linux/wpa_supplicant/gui-qt4.nix {
    inherit fetchurl stdenv qt4 imagemagick inkscape;
  };
  */

  xf86_input_wacom = import ../os-specific/linux/xf86-input-wacom {
    inherit stdenv fetchurl ncurses pkgconfig file;
    inherit (xorg) libX11 libXi inputproto xproto xorgserver;
  };

  xmoto = builderDefsPackage (import ../games/xmoto) {
    inherit chipmunk sqlite curl zlib bzip2 libjpeg libpng
      freeglut mesa SDL SDL_mixer SDL_image SDL_net SDL_ttf
      lua5 ode;
  };

  xorg_sys_opengl = import ../os-specific/linux/opengl/xorg-sys {
    inherit stdenv xlibs expat libdrm;
  };

  zd1211fw = import ../os-specific/linux/firmware/zd1211 {
    inherit stdenv fetchurl;
  };

  ### DATA

  arkpandora_ttf = builderDefsPackage (import ../data/fonts/arkpandora) {
  };

  bakoma_ttf = import ../data/fonts/bakoma-ttf {
    inherit fetchurl stdenv;
  };

  cacert = import ../data/misc/cacert {
    inherit fetchurl stdenv;
  };

  corefonts = import ../data/fonts/corefonts {
    inherit fetchurl stdenv cabextract;
  };

  wrapFonts = paths : ((import ../data/fonts/fontWrap) {
    inherit fetchurl stdenv builderDefs paths ttmkfdir;
    inherit (xorg) mkfontdir mkfontscale;
  });

  clearlyU = composedArgsAndFun (import ../data/fonts/clearlyU/1.9.nix) {
    inherit builderDefs;
    inherit (xorg) mkfontdir mkfontscale;
  };

  dejavu_fonts = import ../data/fonts/dejavu-fonts {
    inherit fetchurl stdenv fontforge perl fontconfig;
    inherit (perlPackages) FontTTF;
  };

  docbook5 = import ../data/sgml+xml/schemas/docbook-5.0 {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_412 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.1.2.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_42 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.2.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_43 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.3.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_45 = import ../data/sgml+xml/schemas/xml-dtd/docbook/4.5.nix {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_ebnf_dtd = import ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = docbook_xsl;

  docbook_xsl = import ../data/sgml+xml/stylesheets/xslt/docbook-xsl {
    inherit fetchurl stdenv;
  };

  docbook5_xsl = docbook_xsl_ns;

  docbook_xsl_ns = import ../data/sgml+xml/stylesheets/xslt/docbook-xsl-ns {
    inherit fetchurl stdenv;
  };

  junicode = composedArgsAndFun (import ../data/fonts/junicode/0.6.15.nix) {
    inherit builderDefs fontforge unzip;
    inherit (xorg) mkfontdir mkfontscale;
  };

  freefont_ttf = import ../data/fonts/freefont-ttf {
    inherit fetchurl stdenv;
  };

  liberation_ttf = import ../data/fonts/redhat-liberation-fonts {
    inherit fetchurl stdenv;
  };

  libertine = builderDefsPackage (import ../data/fonts/libertine/2.7.nix) {
    inherit fontforge;
  };
  libertineBin = builderDefsPackage (import ../data/fonts/libertine/2.7.bin.nix) {
  };

  lmodern = import ../data/fonts/lmodern {
    inherit fetchurl stdenv;
  };

  manpages = import ../data/documentation/man-pages {
    inherit fetchurl stdenv;
  };

  miscfiles = import ../data/misc/miscfiles {
    inherit fetchurl stdenv;
  };

  mph_2b_damase = import ../data/fonts/mph-2b-damase {
    inherit fetchurl stdenv unzip;
  };

  pthreadmanpages = lowPrio (import ../data/documentation/pthread-man-pages {
    inherit fetchurl stdenv perl;
  });

  shared_mime_info = import ../data/misc/shared-mime-info {
    inherit fetchurl stdenv pkgconfig gettext
      intltool perl perlXMLParser libxml2 glib;
  };

  shared_desktop_ontologies = import ../data/misc/shared-desktop-ontologies {
    inherit stdenv fetchurl cmake;
  };

  stdmanpages = import ../data/documentation/std-man-pages {
    inherit fetchurl stdenv;
  };

  iana_etc = import ../data/misc/iana-etc {
    inherit fetchurl stdenv;
  };

  popplerData = import ../data/misc/poppler-data {
    inherit fetchurl stdenv;
  };

  r3rs = import ../data/documentation/rnrs/r3rs.nix {
    inherit fetchurl stdenv texinfo;
  };

  r4rs = import ../data/documentation/rnrs/r4rs.nix {
    inherit fetchurl stdenv texinfo;
  };

  r5rs = import ../data/documentation/rnrs/r5rs.nix {
    inherit fetchurl stdenv texinfo;
  };

  themes = name: import (../data/misc/themes + ("/" + name + ".nix")) {
    inherit fetchurl;
  };

  terminus_font = import ../data/fonts/terminus-font {
    inherit fetchurl stdenv perl;
    inherit (xorg) mkfontdir mkfontscale bdftopcf;
  };

  ttf_bitstream_vera = import ../data/fonts/ttf-bitstream-vera {
    inherit fetchurl stdenv;
  };

  ucsFonts = import ../data/fonts/ucs-fonts {
    inherit fetchurl stdenv wrapFonts;
  };

  unifont = import ../data/fonts/unifont {
    inherit debPackage perl;
    inherit (xorg) mkfontdir mkfontscale bdftopcf fontutil;
  };

  vistafonts = import ../data/fonts/vista-fonts {
    inherit fetchurl stdenv cabextract;
  };

  wqy_zenhei = composedArgsAndFun (import ../data/fonts/wqy_zenhei/0.4.23-1.nix) {
    inherit builderDefs;
  };

  xhtml1 = import ../data/sgml+xml/schemas/xml-dtd/xhtml1 {
    inherit fetchurl stdenv libxml2;
  };

  xkeyboard_config = import ../data/misc/xkeyboard-config {
    inherit fetchurl stdenv perl perlXMLParser gettext intltool;
    inherit (xlibs) xkbcomp;
  };


  ### APPLICATIONS


  aangifte2005 = import ../applications/taxes/aangifte-2005 {
    inherit (pkgsi686Linux) stdenv fetchurl;
    inherit (pkgsi686Linux.xlibs) libX11 libXext;
  };

  aangifte2006 = import ../applications/taxes/aangifte-2006 {
    inherit (pkgsi686Linux) stdenv fetchurl;
    inherit (pkgsi686Linux.xlibs) libX11 libXext;
  };

  aangifte2007 = import ../applications/taxes/aangifte-2007 {
    inherit (pkgsi686Linux) stdenv fetchurl;
    inherit (pkgsi686Linux.xlibs) libX11 libXext libSM;
  };

  aangifte2008 = import ../applications/taxes/aangifte-2008 {
    inherit (pkgsi686Linux) stdenv fetchurl;
    inherit (pkgsi686Linux.xlibs) libX11 libXext libSM;
  };

  aangifte2009 = import ../applications/taxes/aangifte-2009 {
    inherit (pkgsi686Linux) stdenv fetchurl makeWrapper xdg_utils;
    inherit (pkgsi686Linux.xlibs) libX11 libXext libSM;
  };

  abcde = import ../applications/audio/abcde {
    inherit fetchurl stdenv libcdio cddiscid wget bash vorbisTools
            makeWrapper;
  };

  abiword = import ../applications/office/abiword {
    inherit fetchurl stdenv pkgconfig fribidi libpng popt libgsf enchant wv librsvg bzip2;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade libgnomecanvas;
  };

  adobeReader = import ../applications/misc/adobe-reader {
    inherit fetchurl stdenv zlib libxml2 cups;
    inherit (xlibs) libX11;
    inherit (gtkLibs) glib pango atk gtk;
  };

  amsn = import ../applications/networking/instant-messengers/amsn {
    inherit fetchurl stdenv which tcl tk x11;
    libstdcpp = gcc33.gcc;
  };

  ardour = import ../applications/audio/ardour {
    inherit fetchurl stdenv lib pkgconfig scons boost redland librdf_raptor
      librdf_rasqal jackaudio flac libsamplerate alsaLib libxml2 libxslt
      libsndfile libsigcxx libusb cairomm librdf liblo fftw fftwSinglePrec
      aubio libmad;
    inherit (gtkLibs) glib pango gtk glibmm gtkmm;
    inherit (gnome) libgnomecanvas;
  };

  audacious = import ../applications/audio/audacious {
    inherit fetchurl stdenv gettext pkgconfig libmowgli libmcs
      dbus_glib libxml2 libmad xlibs alsaLib libogg libvorbis libcdio
      libcddb flac ffmpeg;
    inherit (gtkLibs) glib gtk;
  };

  audacity = import ../applications/audio/audacity {
    inherit fetchurl stdenv gettext pkgconfig zlib perl intltool libogg
      libvorbis libmad;
    inherit (gtkLibs) gtk glib;
    inherit wxGTK;
  };

  aumix = import ../applications/audio/aumix {
    inherit fetchurl stdenv ncurses pkgconfig gettext;
    inherit (gtkLibs) gtk;
    gtkGUI = false;
  };

  autopanosiftc = import ../applications/graphics/autopanosiftc {
    inherit fetchurl stdenv cmake libpng libtiff libjpeg panotools libxml2;
  };

  avidemux = import ../applications/video/avidemux {
    inherit fetchurl cmake pkgconfig libxml2 qt4 gettext SDL libxslt x264
      alsaLib lame faac faad2 libvorbis;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXv pixman libpthreadstubs libXau libXdmcp;
    stdenv = stdenv2;
  };

  awesome = import ../applications/window-managers/awesome {
    inherit fetchurl stdenv xz cmake gperf imagemagick pkgconfig imlib2 libxdg_basedir
      libstartup_notification libev asciidoc libxslt xmlto dbus docbook_xsl
      docbook_xml_dtd_45 coreutils;
    inherit (gtkLibs) glib pango;
    inherit (xorg) libxcb xcbutil;
    lua = lua5;
    cairo = cairo.override { xcbSupport = true; };
  };

  batik = import ../applications/graphics/batik {
    inherit fetchurl stdenv unzip;
  };

  bazaar = import ../applications/version-management/bazaar {
    inherit fetchurl stdenv makeWrapper;
    python = pythonFull;
  };

  bazaarTools = builderDefsPackage (import ../applications/version-management/bazaar/tools.nix) {
    inherit bazaar;
  };

  beast = import ../applications/audio/beast {
# stdenv = overrideGCC stdenv gcc34;
    inherit stdenv fetchurl zlib guile pkgconfig intltool libogg libvorbis python libxml2 bash perl gettext;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libgnomecanvas libart_lgpl;
    inherit automake autoconf;
  };

  bitlbee = import ../applications/networking/instant-messengers/bitlbee {
    inherit fetchurl stdenv gnutls pkgconfig glib;
  };

  bitlbeeOtr = import ../applications/networking/instant-messengers/bitlbee-otr {
    inherit fetchbzr stdenv gnutls pkgconfig libotr libgcrypt
      libxslt xmlto docbook_xsl docbook_xml_dtd_42 perl glib;
  };

  # commented out because it's using the new configuration style proposal which is unstable
  #biew = import ../applications/misc/biew {
  #  inherit lib stdenv fetchurl ncurses;
  #};

  # only to be able to compile blender - I couldn't compile the default openal software
  # Perhaps this can be removed - don't know which one openal{,soft} is better
  freealut_soft = import ../development/libraries/freealut {
    inherit fetchurl stdenv;
    openal = openalSoft;
  };

  blender = import ../applications/misc/blender/2.49.nix {
    inherit fetchurl cmake mesa gettext libjpeg libpng zlib openal SDL openexr
      libsamplerate libtiff ilmbase freetype;
    inherit (xlibs) libXi;
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

  bmp = import ../applications/audio/bmp {
    inherit fetchurl stdenv pkgconfig libogg libvorbis alsaLib id3lib;
    inherit (gnome) esound libglade;
    inherit (gtkLibs) glib gtk;
  };

  bmp_plugin_musepack = import ../applications/audio/bmp-plugins/musepack {
    inherit fetchurl stdenv pkgconfig bmp libmpcdec taglib;
  };

  bmp_plugin_wma = import ../applications/audio/bmp-plugins/wma {
    inherit fetchurl stdenv pkgconfig bmp;
  };

  bvi = import ../applications/editors/bvi {
    inherit fetchurl stdenv ncurses;
  };

  calibre = makeOverridable (import ../applications/misc/calibre) {
    inherit stdenv fetchurl libpng imagemagick pkgconfig libjpeg fontconfig podofo
      qt4 makeWrapper unrar pil chmlib popplerQt4 pyqt4 sip;
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

  cddiscid = import ../applications/audio/cd-discid {
    inherit fetchurl stdenv;
  };

  cdparanoia = cdparanoiaIII;

  cdparanoiaIII = import ../applications/audio/cdparanoia {
    inherit fetchurl stdenv;
  };

  cdrtools = import ../applications/misc/cdrtools {
    inherit fetchurl stdenv;
  };

  chatzilla =
    xulrunnerWrapper {
      launcher = "chatzilla";
      application = import ../applications/networking/irc/chatzilla {
        inherit fetchurl stdenv unzip;
      };
    };

  chrome = import ../applications/networking/browsers/chromium {
    inherit stdenv fetchurl ffmpeg cairo nspr nss fontconfig freetype alsaLib makeWrapper unzip expat zlib bzip2 libpng dbus dbus_glib;
    inherit (xlibs) libX11 libXext libXrender libXt libXScrnSaver;
    inherit (gtkLibs) gtk glib pango atk;
    inherit (gnome) GConf;
    patchelf = patchelf06;
    libjpeg = libjpeg62;
  };

  chromeWrapper = wrapFirefox chrome "chrome" "";

  cinelerra = import ../applications/video/cinelerra {
    inherit lib fetchurl sourceFromHead stdenv
      automake autoconf libtool
      a52dec alsaLib   lame libavc1394 libiec61883 libraw1394 libsndfile
      libvorbis libogg libjpeg libtiff freetype mjpegtools x264
      gettext faad2 faac libtheora libpng libdv perl nasm e2fsprogs
      pkgconfig;
      openexr = openexr_1_6_1;
    fftw = fftwSinglePrec;
    inherit (xorg) libXxf86vm libXv libXi libX11 xextproto;
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

  compizFusion = import ../applications/window-managers/compiz-fusion {
    version = getConfig ["compizFusion" "version"] "0.7.8";
    inherit compiz;
    inherit stringsWithDeps lib builderDefs;
    inherit fetchurl stdenv pkgconfig libpng mesa perl perlXMLParser libxslt libxml2;
    inherit (xorg) libXcomposite libXfixes libXdamage libXrandr
      libXinerama libICE libSM libXrender xextproto;
    inherit (gnome) startupnotification libwnck GConf;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnome libgnomeui metacity
      glib pango libglade libgtkhtml gtkhtml
      libgnomecanvas libgnomeprint
      libgnomeprintui gnomepanel gnomedesktop;
    gnomegtk = gnome.gtk;
    inherit librsvg fuse dbus dbus_glib git;
    inherit automake autoconf libtool intltool python pyrex gettext;
    inherit pygtk pycairo getopt libjpeg glxinfo;
    inherit (xorg) xvinfo xdpyinfo;
  };

  compizExtra = import ../applications/window-managers/compiz/extra.nix {
    inherit fetchurl stdenv pkgconfig compiz perl perlXMLParser dbus;
    inherit (gnome) GConf;
    inherit (gtkLibs) gtk;
  };

  cinepaint = import ../applications/graphics/cinepaint {
    inherit stdenv fetchcvs cmake pkgconfig freetype fontconfig lcms flex libtiff
      libjpeg libpng libexif zlib perl mesa perlXMLParser python pygtk gettext
      intltool babl gegl automake autoconf libtool;
    inherit (xlibs) makedepend libX11 xf86vidmodeproto xineramaproto libXmu
      libXext libXpm libXxf86vm;
    inherit (gtkLibs) gtk glib;
    openexr = openexr_1_6_1;
    fltk = fltk11;
  };

  codeville = builderDefsPackage (import ../applications/version-management/codeville/0.8.0.nix) {
    inherit makeWrapper;
    python = pythonFull;
  };

  comical = import ../applications/graphics/comical {
    inherit stdenv fetchurl utillinux zlib;
    wxGTK = wxGTK26;
  };

  conkeror = xulrunnerWrapper {
    launcher = "conkeror";
    application = import ../applications/networking/browsers/conkeror {
      inherit stdenv fetchurl unzip;
    };
  };

  cuneiform = builderDefsPackage (import ../tools/graphics/cuneiform) {
    inherit cmake patchelf;
    imagemagick=imagemagick;
  };

  cvs = import ../applications/version-management/cvs {
    inherit fetchurl stdenv nano;
  };

  cvsps = import ../applications/version-management/cvsps {
    inherit fetchurl stdenv cvs zlib;
  };

  cvs2svn = import ../applications/version-management/cvs2svn {
    inherit fetchurl stdenv python makeWrapper;
  };

  d4x = import ../applications/misc/d4x {
    inherit fetchurl stdenv pkgconfig openssl boost;
    inherit (gtkLibs) gtk glib;
  };

  darcs = haskellPackages_ghc6104.darcs;

  dia = import ../applications/graphics/dia {
    inherit stdenv fetchurl pkgconfig perl perlXMLParser
      libxml2 gettext python libxml2Python docbook5 docbook_xsl
      libxslt intltool;
    inherit (gtkLibs) gtk glib;
  };

  djvulibre = makeOverridable (import ../applications/misc/djvulibre) {
    inherit stdenv fetchurl lib libjpeg libtiff libungif qt3 zlib
      ghostscript libpng mesa x11;
    inherit (xlibs) libX11;
  };

  djview4 = import ../applications/graphics/djview {
    inherit fetchurl stdenv qt4 djvulibre;
  };

  dmenu = import ../applications/misc/dmenu {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXinerama;
  };

  dmtx = builderDefsPackage (import ../tools/graphics/dmtx) {
    inherit libpng libtiff libjpeg imagemagick librsvg
      pkgconfig bzip2 zlib libtool freetype fontconfig
      ghostscript jasper;
    inherit (xlibs) libX11;
  };

  dvdauthor = import ../applications/video/dvdauthor {
    inherit fetchurl stdenv freetype libpng fribidi libxml2 libdvdread imagemagick;
  };

  dwm = import ../applications/window-managers/dwm {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXinerama;
    patches = getConfig [ "dwm" "patches" ] [];
  };

  eaglemode = import ../applications/misc/eaglemode {
    inherit fetchurl stdenv perl xineLib libjpeg libpng libtiff;
    inherit (xlibs) libX11;
  };

  eclipse = makeOverridable (import ../applications/editors/eclipse) {
    inherit stdenv fetchurl patchelf makeDesktopItem makeWrapper freetype fontconfig jre zlib;
    # GTK 2.18 gives glitches such as mouse clicks on buttons not
    # working correctly.
    inherit (gtkLibs216) glib gtk;
    inherit (xlibs) libX11 libXext libXrender libXtst;
  };
  eclipseLatest = eclipse.override { version = "latest"; };

  ed = import ../applications/editors/ed {
    inherit fetchurl stdenv;
  };

  elinks = import ../applications/networking/browsers/elinks {
    inherit stdenv fetchurl python perl ncurses x11 zlib openssl spidermonkey
      guile bzip2 gpm;
  };

  elvis = import ../applications/editors/elvis {
    inherit fetchurl stdenv ncurses;
  };

  emacs = emacs23;

  emacs22 = import ../applications/editors/emacs-22 {
    inherit fetchurl stdenv ncurses pkgconfig x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    inherit (gtkLibs) gtk;
    xaw3dSupport = getPkgConfig "emacs" "xaw3dSupport" false;
    gtkGUI = getPkgConfig "emacs" "gtkSupport" true;
  };

  emacs23 = makeOverridable (import ../applications/editors/emacs-23) {
    inherit fetchurl stdenv ncurses pkgconfig x11 libpng libjpeg
      libungif libtiff texinfo dbus;
    inherit (xlibs) libXpm libXft;
    # use override to select the appropriate gui toolkit
    libXaw = if stdenv.isDarwin then xlibs.libXaw else null;
    Xaw3d = null;
    gtk = if stdenv.isDarwin then gtkLibs.gtk else null;
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

  emacsPackages = emacs: recurseIntoAttrs (rec {
    bbdb = import ../applications/editors/emacs-modes/bbdb {
      inherit fetchurl stdenv emacs texinfo ctags;
    };

    cedet = import ../applications/editors/emacs-modes/cedet {
      inherit fetchurl stdenv emacs;
    };

    cua = import ../applications/editors/emacs-modes/cua {
      inherit fetchurl stdenv;
    };

    ecb = import ../applications/editors/emacs-modes/ecb {
      inherit fetchurl stdenv emacs cedet jdee texinfo;
    };

    jabber = import ../applications/editors/emacs-modes/jabber {
      inherit stdenv fetchurl emacs;
    };

    emacsSessionManagement = import ../applications/editors/emacs-modes/session-management-for-emacs {
      inherit fetchurl stdenv emacs;
    };

    emacsw3m = import ../applications/editors/emacs-modes/emacs-w3m {
      inherit fetchcvs stdenv emacs w3m imagemagick texinfo autoconf;
    };

    emms = import ../applications/editors/emacs-modes/emms {
      inherit fetchurl stdenv emacs texinfo mpg321 vorbisTools taglib
        alsaUtils;
    };

    jdee = import ../applications/editors/emacs-modes/jdee {
      # Requires Emacs 23, for `avl-tree'.
      inherit fetchsvn stdenv cedet ant emacs;
    };

    stratego = import ../applications/editors/emacs-modes/stratego {
      inherit fetchsvn stdenv;
    };

    haskellMode = import ../applications/editors/emacs-modes/haskell {
      inherit fetchurl stdenv emacs;
    };

    hol_light_mode = import ../applications/editors/emacs-modes/hol_light {
      inherit fetchsvn stdenv;
    };

    magit = import ../applications/editors/emacs-modes/magit {
      inherit fetchurl stdenv emacs texinfo;
    };

    maudeMode = import ../applications/editors/emacs-modes/maude {
      inherit fetchurl stdenv emacs;
    };

    nxml = import ../applications/editors/emacs-modes/nxml {
      inherit fetchurl stdenv;
    };

    prologMode = import ../applications/editors/emacs-modes/prolog {
      inherit fetchurl stdenv;
    };

    proofgeneral = import ../applications/editors/emacs-modes/proofgeneral {
       inherit stdenv fetchurl emacs perl;
    };

    quack = import ../applications/editors/emacs-modes/quack {
      inherit fetchurl stdenv emacs;
    };

    remember = import ../applications/editors/emacs-modes/remember {
      inherit fetchurl stdenv texinfo emacs bbdb;
    };

    scalaMode = import ../applications/editors/emacs-modes/scala-mode {
      inherit fetchsvn stdenv emacs;
    };
  });

  emacs22Packages = emacsPackages emacs22;
  emacs23Packages = emacsPackages emacs23;

  epdfview = import ../applications/misc/epdfview {
    inherit stdenv fetchurl pkgconfig poppler;
    inherit (gtkLibs) gtk;
  };

  evince = makeOverridable (import ../applications/misc/evince) {
    inherit fetchurl stdenv perl perlXMLParser gettext intltool
      pkgconfig poppler libspectre djvulibre libxslt
      dbus dbus_glib shared_mime_info which makeWrapper;
    inherit (gnome) gnomedocutils gnomeicontheme libgnome
      libgnomeui libglade glib gtk scrollkeeper gnome_keyring;
  };

  exrdisplay = import ../applications/graphics/exrdisplay {
    inherit fetchurl stdenv pkgconfig mesa which openexr_ctl;
    fltk = fltk20;
    openexr = openexr_1_6_1;
  };

  fbpanel = composedArgsAndFun (import ../applications/window-managers/fbpanel/4.12.nix) {
    inherit fetchurl stdenv builderDefs pkgconfig libpng libjpeg libtiff librsvg;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11 libXmu libXpm;
  };

  fetchmail = import ../applications/misc/fetchmail {
    inherit stdenv fetchurl openssl;
  };

  fossil = import ../applications/version-management/fossil {
    inherit stdenv fetchurl zlib openssl;
  };

  grip = import ../applications/misc/grip {
    inherit fetchurl stdenv lib grip pkgconfig curl cdparanoia libid3tag;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libgnome libgnomeui vte;
  };

  wavesurfer = import ../applications/misc/audio/wavesurfer {
    inherit fetchurl stdenv tcl tk snack makeWrapper;
  };

  wireshark = import ../applications/networking/sniffers/wireshark {
    inherit fetchurl stdenv perl pkgconfig libpcap flex bison;
    inherit (gtkLibs) gtk;
  };

  wvdial = import ../os-specific/linux/wvdial {
    inherit stdenv fetchurl wvstreams pkgconfig;
  };

  fbida = builderDefsPackage ../applications/graphics/fbida {
    inherit libjpeg libexif giflib libtiff libpng
      imagemagick ghostscript which curl pkgconfig
      freetype fontconfig;
  };

  fdupes = import ../tools/misc/fdupes {
    inherit fetchurl stdenv;
  };

  feh = import ../applications/graphics/feh {
    inherit fetchurl stdenv x11 imlib2 libjpeg libpng giblib;
  };

  firefox = firefox35;

  firefoxWrapper = firefox35Wrapper;

  firefox35Pkgs = import ../applications/networking/browsers/firefox/3.5.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs file alsaLib
      nspr nss;
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
  };

  firefox35 = firefox35Pkgs.firefox;
  xulrunner35 = firefox35Pkgs.xulrunner;
  firefox35Wrapper = wrapFirefox firefox35 "firefox" "";

  firefox36Pkgs = import ../applications/networking/browsers/firefox/3.6.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs file alsaLib
      nspr nss libnotify;
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
  };

  firefox36Wrapper = lowPrio (wrapFirefox firefox36Pkgs.firefox "firefox" "");

  flac = import ../applications/audio/flac {
    inherit fetchurl stdenv libogg;
  };

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

  flite = import ../applications/misc/flite {
    inherit fetchurl stdenv;
  };

  freemind = import ../applications/misc/freemind {
    inherit fetchurl stdenv ant coreutils gnugrep;
    jdk = jdk;
    jre = jdk;
  };

  freepv = import ../applications/graphics/freepv {
    inherit fetchurl stdenv mesa freeglut libjpeg zlib cmake libxml2 libpng;
    inherit (xlibs) libX11 libXxf86vm;
  };

  xfontsel = import ../applications/misc/xfontsel {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXaw;
  };
  xlsfonts = import ../applications/misc/xlsfonts {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11;
  };

  fspot = import ../applications/graphics/f-spot {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig mono
            libexif libjpeg sqlite lcms libgphoto2 monoDLLFixer;
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  gimp = import ../applications/graphics/gimp {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      libtiff libjpeg libpng libexif zlib perl perlXMLParser
      python pygtk gettext xlibs intltool babl gegl;
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

  gnucash = import ../applications/office/gnucash {
    inherit fetchurl stdenv pkgconfig libxml2 goffice enchant
      gettext intltool perl guile slibGuile swig isocodes bzip2 makeWrapper;
    inherit (gnome) gtk glib libglade libgnomeui libgtkhtml gtkhtml
      libgnomeprint;
    gconf = gnome.GConf;
  };

  qcad = import ../applications/misc/qcad {
    inherit fetchurl stdenv qt3 libpng;
    inherit (xlibs) libXext libX11;
  };

  qjackctl = import ../applications/audio/qjackctl {
    inherit fetchurl stdenv alsaLib jackaudio;
    qt4 = qt4;
  };

  gkrellm = import ../applications/misc/gkrellm {
    inherit fetchurl stdenv gettext pkgconfig;
    inherit (gtkLibs) glib gtk;
    inherit (xlibs) libX11 libICE libSM;
  };

  gnash = import ../applications/video/gnash {
    inherit fetchurl stdenv SDL SDL_mixer libogg libxml2 libjpeg mesa libpng
            boost freetype agg dbus curl pkgconfig x11 libtool lib libungif
            gettext makeWrapper ming dejagnu python;
    inherit (gtkLibs) glib gtk;
    inherit (gst_all) gstreamer gstPluginsBase gstFfmpeg;
  };

  gnome_mplayer = import ../applications/video/gnome-mplayer {
    inherit fetchurl stdenv pkgconfig dbus dbus_glib;
    inherit (gtkLibs) glib gtk;
    inherit (gnome) GConf;
  };

  gnunet = import ../applications/networking/p2p/gnunet {
    inherit fetchurl stdenv libextractor libmicrohttpd libgcrypt
      gmp curl libtool guile adns sqlite gettext zlib pkgconfig
      libxml2 ncurses findutils makeWrapper;
    inherit (gnome) gtk libglade;
    gtkSupport = getConfig [ "gnunet" "gtkSupport" ] true;
  };

  gocr = composedArgsAndFun (import ../applications/graphics/gocr/0.44.nix) {
    inherit builderDefs fetchurl stdenv;
  };

  gphoto2 = import ../applications/misc/gphoto2 {
    inherit fetchurl stdenv pkgconfig libgphoto2 libexif popt gettext
      libjpeg readline libtool;
  };

  gphoto2fs = builderDefsPackage ../applications/misc/gphoto2/gphotofs.nix {
    inherit libgphoto2 fuse pkgconfig glib;
  };

  graphicsmagick = import ../applications/graphics/graphicsmagick {
    inherit stdenv fetchurl bzip2 freetype graphviz ghostscript
      libjpeg libpng libtiff libxml2 zlib libtool;
    inherit (xlibs) libX11;
  };

  graphicsmagick137 = import ../applications/graphics/graphicsmagick/1.3.7.nix {
    inherit stdenv fetchurl bzip2 freetype graphviz ghostscript
      libjpeg libpng libtiff libxml2 zlib libtool;
    inherit (xlibs) libX11;
  };

  gtkpod = import ../applications/audio/gtkpod {
    inherit stdenv fetchurl pkgconfig libgpod gettext perl perlXMLParser flex libid3tag libvorbis;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libglade;
  };

  qrdecode = builderDefsPackage (import ../tools/graphics/qrdecode) {
    inherit libpng libcv;
  };

  qrencode = builderDefsPackage (import ../tools/graphics/qrencode) {
    inherit libpng pkgconfig;
  };

  gecko_mediaplayer = import ../applications/networking/browsers/mozilla-plugins/gecko-mediaplayer {
    inherit fetchurl stdenv pkgconfig dbus dbus_glib x11 gnome_mplayer MPlayer glib;
    inherit (gnome) GConf;
    browser = firefox35;
  };

  geeqie = import ../applications/graphics/geeqie {
    inherit fetchurl stdenv pkgconfig libpng lcms exiv2
      intltool gettext;
    inherit (gtkLibs) gtk;
  };

  gqview = import ../applications/graphics/gqview {
    inherit fetchurl stdenv pkgconfig libpng;
    inherit (gtkLibs) gtk;
  };

  googleearth = import ../applications/misc/googleearth {
    inherit stdenv fetchurl glibc mesa freetype zlib glib;
    inherit (xlibs) libSM libICE libXi libXv libXrender libXrandr libXfixes
      libXcursor libXinerama libXext libX11;
  };

  gpsbabel = import ../applications/misc/gpsbabel {
    inherit fetchurl stdenv zlib expat;
  };

  gpscorrelate = import ../applications/misc/gpscorrelate {
    inherit fetchurl stdenv pkgconfig exiv2 libxml2
      libxslt docbook_xsl docbook_xml_dtd_42;
    inherit (gtkLibs) gtk;
  };

  gpsd = import ../servers/gpsd {
    inherit fetchurl stdenv pkgconfig dbus dbus_glib
      ncurses makeWrapper libxslt xmlto;
    inherit (xlibs) libX11 libXt libXpm libXaw libXext;

    # We need a Python with NCurses bindings.
    python = pythonFull;
  };

  gv = import ../applications/misc/gv {
    inherit fetchurl stdenv Xaw3d ghostscriptX;
  };

  hello = makeOverridable (import ../applications/misc/hello/ex-2) {
    inherit fetchurl stdenv;
  };

  homebank = import ../applications/office/homebank {
    inherit fetchurl stdenv pkgconfig libofx intltool;
    inherit (gtkLibs) gtk;
  };

  hugin = import ../applications/graphics/hugin {
    inherit fetchurl stdenv cmake panotools libtiff libpng boost pkgconfig
      exiv2 gettext ilmbase enblendenfuse autopanosiftc mesa freeglut
      glew;
    inherit wxGTK;
    inherit (xlibs) libXi libXmu;
    openexr = openexr_1_6_1;
  };

  i810switch = import ../applications/misc/i810 {
    inherit fetchurl stdenv pciutils;
  };

  icecat3 = lowPrio (import ../applications/networking/browsers/icecat-3 {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs alsaLib libnotify
      wirelesstools;
    inherit (gnome) libIDL libgnomeui gnomevfs gtk pango;
    inherit (pythonPackages) ply;
  });

  icecatXulrunner3 = lowPrio (import ../applications/networking/browsers/icecat-3 {
    application = "xulrunner";
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs alsaLib libnotify
      wirelesstools;
    inherit (gnome) libIDL libgnomeui gnomevfs gtk pango;
    inherit (pythonPackages) ply;
  });

  icecat3Xul =
    (symlinkJoin "icecat-with-xulrunner-${icecat3.version}"
       [ icecat3 icecatXulrunner3 ])
    // { inherit (icecat3) gtk isFirefox3Like meta; };

  icecatWrapper = wrapFirefox icecat3Xul "icecat" "";

  icewm = import ../applications/window-managers/icewm {
    inherit fetchurl stdenv gettext libjpeg libtiff libungif libpng imlib xlibs;
  };

  ikiwiki = makeOverridable (import ../applications/misc/ikiwiki) {
    inherit fetchurl stdenv perl gettext makeWrapper lib;
    inherit (perlPackages) TextMarkdown URI HTMLParser HTMLScrubber
      HTMLTemplate TimeDate CGISession DBFile CGIFormBuilder LocaleGettext
      RpcXML XMLSimple PerlMagick;
    git = if getPkgConfig "ikiwiki" "git" true then git else null;
    monotone = if getPkgConfig "ikiwiki" "monotone" false then monotone else null;
    extraUtils = [];
  };

  imagemagick = import ../applications/graphics/ImageMagick {
    inherit stdenv fetchurl bzip2 freetype graphviz ghostscript
      libjpeg libpng libtiff libxml2 zlib libtool jasper;
    inherit (xlibs) libX11;
  };

  imagemagickBig = import ../applications/graphics/ImageMagick {
    inherit stdenv fetchurl bzip2 freetype graphviz ghostscript
      libjpeg libpng libtiff libxml2 zlib tetex librsvg libtool
      jasper;
    inherit (xlibs) libX11;
  };

  # Impressive, formerly known as "KeyJNote".
  impressive = import ../applications/office/impressive {
    inherit fetchurl stdenv xpdf pil pygame makeWrapper lib python;

    # XXX These are the PyOpenGL dependencies, which we need here.
    inherit setuptools mesa freeglut;

    inherit (pythonPackages) pyopengl;
  };

  inkscape = import ../applications/graphics/inkscape {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig zlib popt
      libxml2 libxslt libpng boehmgc libsigcxx lcms boost gettext
      cairomm python pyxml makeWrapper intltool gsl;
    inherit (pythonPackages) lxml;
    inherit (gtkLibs) gtk glib glibmm gtkmm;
    inherit (xlibs) libXft;
  };

  ion3 = import ../applications/window-managers/ion-3 {
    inherit fetchurl stdenv x11 gettext groff;
    lua = lua5;
  };

  iptraf = import ../applications/networking/iptraf {
    inherit fetchurl stdenv ncurses;
  };

  irssi = import ../applications/networking/irc/irssi {
    inherit stdenv fetchurl pkgconfig ncurses openssl glib perl;
  };

  jackmeter = import ../applications/audio/jackmeter {
    inherit fetchurl stdenv lib jackaudio pkgconfig;
  };

  jedit = import ../applications/editors/jedit {
    inherit fetchurl stdenv ant;
  };

  jigdo = import ../applications/misc/jigdo {
    inherit fetchurl stdenv db45 libwpd bzip2;
    inherit (gtkLibs) gtk;
  };

  joe = import ../applications/editors/joe {
    inherit stdenv fetchurl;
  };

  jwm = import ../applications/window-managers/jwm {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXext libXinerama libXpm libXft;
  };

  kermit = import ../tools/misc/kermit {
    inherit fetchurl stdenv ncurses;
  };

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

  lame = import ../applications/audio/lame {
    inherit fetchurl stdenv nasm;
  };

  larswm = import ../applications/window-managers/larswm {
    inherit fetchurl stdenv;
    inherit (xlibs) imake libX11 libXext libXmu;
  };

  ladspaH = import ../applications/audio/ladspa-plugins/ladspah.nix {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
  };

  ladspaPlugins = import ../applications/audio/ladspa-plugins {
    inherit fetchurl stdenv builderDefs stringsWithDeps fftw ladspaH pkgconfig;
  };

  ldcpp = composedArgsAndFun (import ../applications/networking/p2p/ldcpp/1.0.3.nix) {
    inherit builderDefs scons pkgconfig bzip2 openssl;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade;
    inherit (xlibs) libX11;
  };

  links = import ../applications/networking/browsers/links {
    inherit fetchurl stdenv;
  };

  ledger = makeOverridable (import ../applications/office/ledger) {
    inherit stdenv fetchurl emacs gmp pcre;
  };

  links2 = (builderDefsPackage ../applications/networking/browsers/links2) {
    inherit fetchurl stdenv bzip2 zlib libjpeg libpng libtiff
      gpm openssl SDL SDL_image SDL_net pkgconfig;
    inherit (xlibs) libX11 libXau xproto libXt;
  };

  lynx = import ../applications/networking/browsers/lynx {
    inherit fetchurl stdenv ncurses openssl;
  };

  lyx = import ../applications/misc/lyx {
   inherit fetchurl stdenv texLive python makeWrapper;
   inherit (xlibs) libX11;
   qt = qt4;
  };

  meld = import ../applications/version-management/meld {
    inherit fetchurl stdenv python intltool makeWrapper;
    inherit (gnome) scrollkeeper;
    pygtk = pyGtkGlade;
  };

  mercurial = import ../applications/version-management/mercurial {
    inherit fetchurl stdenv makeWrapper getConfig tk;
    guiSupport = getConfig ["mercurial" "guiSupport"] false; # for hgk (gitk gui for hg)
    python = # allow cloning sources from https servers.
      if getConfig ["mercurial" "httpsSupport"] true
      then pythonFull
      else pythonBase;
  };

  meshlab = import ../applications/graphics/meshlab {
    inherit fetchurl stdenv bzip2 lib3ds levmar muparser unzip;
    qt = qt4;
  };

  midori = builderDefsPackage (import ../applications/networking/browsers/midori) {
    inherit imagemagick intltool python pkgconfig webkit libxml2
      which gettext makeWrapper file libidn sqlite docutils libnotify;
    inherit (gtkLibs) gtk glib;
    inherit (gnome28) gtksourceview libsoup;
  };

  minicom = import ../tools/misc/minicom {
    inherit fetchurl stdenv ncurses;
  };

  mmex = import ../applications/office/mmex {
    inherit fetchsvn stdenv wxGTK;
  };

  monodevelop = import ../applications/editors/monodevelop {
    inherit fetchurl stdenv file mono gtksourceviewsharp
            gtkmozembedsharp monodoc perl perlXMLParser pkgconfig;
    inherit (gnome) gnomevfs libbonobo libglade libgnome GConf glib gtk;
    mozilla = firefox;
    gtksharp = gtksharp2;
  };

  monodoc = import ../applications/editors/monodoc {
    inherit fetchurl stdenv mono pkgconfig;
    gtksharp = gtksharp1;
  };

  monotone = import ../applications/version-management/monotone {
    inherit stdenv fetchurl boost zlib botan libidn pcre
      sqlite lib perl;
    lua = lua5;
  };

  monotoneViz = builderDefsPackage (import ../applications/version-management/monotone-viz/mtn-head.nix) {
    inherit ocaml lablgtk graphviz pkgconfig autoconf automake libtool;
    inherit (gnome) gtk libgnomecanvas glib;
  };

  mozilla = import ../applications/networking/browsers/mozilla {
    inherit fetchurl pkgconfig stdenv perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  mozplugger = builderDefsPackage (import ../applications/networking/browsers/mozilla-plugins/mozplugger) {
    inherit firefox;
    inherit (xlibs) libX11 xproto;
  };

  mpc123 = import ../applications/audio/mpc123 {
    inherit stdenv fetchurl gettext libao libmpcdec;
  };

  mpg321 = import ../applications/audio/mpg321 {
    inherit stdenv fetchurl libao libmad libid3tag zlib;
  };

  MPlayer = import ../applications/video/MPlayer {
    inherit fetchurl stdenv freetype fontconfig x11 zlib libtheora libcaca libdvdnav
      cdparanoia mesa pkgconfig unzip amrnb amrwb jackaudio x264 xvidcore lame yasm;
    inherit (xlibs) libX11 libXv libXinerama libXrandr;
    alsaSupport = true;
    alsa = alsaLib;
    theoraSupport = true;
    cacaSupport = true;
    xineramaSupport = true;
    randrSupport = true;
    cddaSupport = true;
    amrSupport = getConfig [ "MPlayer" "amr" ] false;
    x264Support = true;
    xvidSupport = true;
  };

  MPlayerPlugin = browser:
    import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      inherit fetchurl stdenv pkgconfig gettext;
      inherit (xlibs) libXpm;
      # !!! should depend on MPlayer
    };

  mrxvt = import ../applications/misc/mrxvt {
    inherit lib fetchurl stdenv freetype pkgconfig which;
    inherit (xlibs) libXaw xproto libXt libX11 libSM libICE libXft
      libXi inputproto;
  };

  multisync = import ../applications/misc/multisync {
    inherit fetchurl stdenv autoconf automake libtool pkgconfig;
    inherit (gnome) gtk glib ORBit2 libbonobo libgnomeui GConf;
  };

  mutt = import ../applications/networking/mailreaders/mutt {
    inherit fetchurl stdenv ncurses which openssl gdbm perl cyrus_sasl;
  };

  msmtp = import ../applications/networking/msmtp {
    inherit fetchurl stdenv openssl;
  };

  mythtv = import ../applications/video/mythtv {
    inherit fetchurl stdenv which x11 xlibs lame zlib mesa freetype perl alsaLib;
    qt3 = qt3mysql;
  };

  nano = import ../applications/editors/nano {
    inherit fetchurl stdenv ncurses gettext;
  };

  nedit = import ../applications/editors/nedit {
      inherit fetchurl stdenv x11;
      inherit (xlibs) libXpm;
      motif = lesstif;
    };

  netsurfBrowser = netsurf.browser;
  netsurf = recurseIntoAttrs (import ../applications/networking/browsers/netsurf { inherit pkgs; });

  nvi = import ../applications/editors/nvi {
    inherit fetchurl stdenv ncurses;
  };

  openjump = import ../applications/misc/openjump {
    inherit stdenv fetchurl unzip;
  };

  openoffice = import ../applications/office/openoffice {
    inherit fetchurl pam python tcsh libxslt perl zlib libjpeg
      expat pkgconfig freetype fontconfig libwpd libxml2 db4 sablotron
      curl libsndfile flex zip unzip libmspack getopt file cairo
      which icu jdk ant cups openssl bison boost gperf cppunit;
    inherit (xlibs) libXaw libXext libX11 libXtst libXi libXinerama;
    inherit (gtkLibs) gtk;
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2;
    neon = neon026;
    stdenv = stdenv2;
  };

  go_oo = import ../applications/office/openoffice/go-oo.nix {
    inherit fetchurl pam python tcsh libxslt perl zlib libjpeg
      expat pkgconfig freetype fontconfig libwpd libxml2 db4 sablotron
      curl libsndfile flex zip unzip libmspack getopt file cairo
      which icu jdk ant cups openssl bison boost gperf cppunit bash;
    inherit (xlibs) libXaw libXext libX11 libXtst libXi libXinerama;
    inherit (gtkLibs) gtk;
    inherit (perlPackages) ArchiveZip CompressZlib;
    inherit (gnome) GConf ORBit2;
    neon = neon026;
    stdenv = stdenv2;

    inherit autoconf openldap postgresql;
  };

  opera = import ../applications/networking/browsers/opera {
    inherit fetchurl zlib glibc stdenv makeDesktopItem;
    inherit (xlibs) libX11 libSM libICE libXt libXext;
    qt = qt3;
  };

  pan = import ../applications/networking/newsreaders/pan {
    inherit fetchurl stdenv pkgconfig perl pcre gmime gettext;
    inherit (gtkLibs) gtk;
    spellChecking = false;
  };

  panotools = import ../applications/graphics/panotools {
    inherit stdenv fetchsvn libpng libjpeg libtiff automake libtool autoconf;
  };

  pavucontrol = import ../applications/audio/pavucontrol {
    inherit fetchurl stdenv pkgconfig pulseaudio libsigcxx
      libcanberra intltool gettext;
    inherit (gtkLibs) gtkmm;
    inherit (gnome) libglademm;
  };

  paraview = import ../applications/graphics/paraview {
    inherit fetchurl cmake qt4;
    stdenv = stdenv2;
  };

  partitionManager = import ../tools/misc/partition-manager {
    inherit fetchurl stdenv lib cmake pkgconfig gettext parted libuuid perl;
    kde = kde44;
    qt = qt4;
  };

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

  pidginlatex = composedArgsAndFun (import ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex) {
    inherit fetchurl stdenv pkgconfig ghostscript pidgin texLive;
    imagemagick = imagemagickBig;
    inherit (gtkLibs) glib gtk;
  };

  pidginlatexSF = builderDefsPackage
    (import ../applications/networking/instant-messengers/pidgin-plugins/pidgin-latex/pidgin-latex-sf.nix)
    {
      inherit pkgconfig pidgin texLive imagemagick which;
      inherit (gtkLibs) glib gtk;
    };

  pidginotr = import ../applications/networking/instant-messengers/pidgin-plugins/otr {
    inherit fetchurl stdenv libotr pidgin;
  };

  pidginsipe = import ../applications/networking/instant-messengers/pidgin-plugins/sipe {
    inherit fetchurl stdenv pidgin intltool libxml2;
  };

  pinfo = import ../applications/misc/pinfo {
    inherit fetchurl stdenv ncurses readline;
  };

  pqiv = import ../applications/graphics/pqiv {
    inherit fetchurl stdenv getopt which pkgconfig;
    inherit (gtkLibs) gtk;
  };

  # perhaps there are better apps for this task? It's how I had configured my preivous system.
  # And I don't want to rewrite all rules
  procmail = import ../applications/misc/procmail {
    inherit fetchurl stdenv autoconf;
  };

  pstree = import ../applications/misc/pstree {
    inherit stdenv fetchurl;
  };

  pythonmagick = import ../applications/graphics/PythonMagick {
    inherit fetchurl stdenv pkgconfig imagemagick boost python;
  };

  qemu = import ../applications/virtualization/qemu/0.12.3.nix {
    inherit stdenv fetchurl SDL zlib which;
  };

  qemuSVN = import ../applications/virtualization/qemu/svn-6642.nix {
    inherit fetchsvn SDL zlib which stdenv;
  };

  qemuImage = composedArgsAndFun (import ../applications/virtualization/qemu/linux-img/0.2.nix) {
    inherit builderDefs fetchurl stdenv;
  };

  qtpfsgui = import ../applications/graphics/qtpfsgui {
    inherit fetchurl stdenv exiv2 libtiff fftw qt4 ilmbase;
    openexr = openexr_1_6_1;
  };

  rapidsvn = import ../applications/version-management/rapidsvn {
    inherit fetchurl stdenv wxGTK subversion apr aprutil python;
  };

  ratpoison = import ../applications/window-managers/ratpoison {
    inherit fetchurl stdenv fontconfig readline pkgconfig autoconf automake;
    inherit (xlibs) libX11 inputproto libXt libXpm libXft
      libXtst xextproto libXi;
  };

  rawtherapee = import ../applications/graphics/rawtherapee {
    inherit fetchsvn stdenv pkgconfig cmake lcms libiptcdata;
    inherit (gtkLibs) gtk gtkmm;
    inherit (xlibs) libXau libXdmcp pixman libpthreadstubs;
  };

  rcs = import ../applications/version-management/rcs {
    inherit fetchurl stdenv;
  };

  rdesktop = import ../applications/networking/remote/rdesktop {
    inherit fetchurl stdenv openssl;
    inherit (xlibs) libX11;
  };

  RealPlayer =
    (import ../applications/video/RealPlayer {
      inherit fetchurl stdenv;
      inherit (gtkLibs) glib pango atk gtk;
      inherit (xlibs) libX11;
      libstdcpp5 = gcc33.gcc;
    });

  rekonq = makeOverridable (import ../applications/networking/browsers/rekonq) {
    inherit fetchurl fetchgit stdenv cmake perl;
    inherit (kde4) qt4 kdelibs automoc4 phonon;
  };

  rekonqScm = rekonq.override { v = "scm"; };

  rsync = import ../applications/networking/sync/rsync {
    inherit fetchurl stdenv acl perl;
    enableACLs = !stdenv.isDarwin;
  };

  rxvt = import ../applications/misc/rxvt {
    inherit lib fetchurl stdenv;
    inherit (xlibs) libXt libX11;
  };

  # = urxvt
  rxvt_unicode = makeOverridable (import ../applications/misc/rxvt_unicode) {
    inherit lib fetchurl stdenv perl ncurses;
    inherit (xlibs) libXt libX11 libXft;
    perlSupport = false;
  };

  sakura = import ../applications/misc/sakura {
    inherit stdenv fetchurl cmake pkgconfig gettext perl;
    inherit (gtkLibs) gtk;
    inherit (gnome) vte;
    inherit (xlibs) pixman;
  };

  sbagen = import ../applications/misc/sbagen {
    inherit fetchurl stdenv;
  };

  scribus = import ../applications/office/scribus {
    inherit fetchurl stdenv lib cmake pkgconfig freetype lcms libtiff libxml2
      cairo python cups fontconfig zlib libjpeg libpng;
    inherit (gnome) libart_lgpl;
    inherit (xlibs) libXau libXaw libXdmcp libXext libX11 libXtst libXi libXinerama libXrender;
    inherit (xorg) pixman libpthreadstubs;
    qt = qt3;
  };

  seg3d = import ../applications/graphics/seg3d {
    inherit fetchurl stdenv cmake itk mesa zlib libuuid;
    inherit (xlibs) libXft libXext libXi libXmu;
    wxGTK = wxGTK28.override {
      unicode = false;
    };
  };

  skype_linux = import ../applications/networking/skype {
    inherit fetchurl stdenv;
    inherit alsaLib freetype fontconfig zlib;
    qt = qt46;
    inherit (xlibs) libXext libX11 libXv libXScrnSaver libSM libICE
      libXi libXrender libXrandr;
    inherit (gtkLibs) glib;
  };

  slim = import ../applications/display-managers/slim {
    inherit fetchurl stdenv x11 libjpeg libpng freetype pam;
    inherit (xlibs) libXmu;
  };

  sndBase = builderDefsPackage (import ../applications/audio/snd) {
    inherit fetchurl stdenv stringsWithDeps lib fftw;
    inherit pkgconfig gmp gettext;
    inherit (xlibs) libXpm libX11;
    inherit (gtkLibs) gtk glib;
  };

  snd = sndBase.passthru.function {
    inherit guile mesa libtool jackaudio alsaLib;
  };

  sonicVisualizer = import ../applications/audio/sonic-visualizer {
    inherit fetchurl stdenv lib libsndfile libsamplerate bzip2 librdf
      rubberband jackaudio pulseaudio libmad
      libogg liblo alsaLib librdf_raptor librdf_rasqal redland fftw;
    inherit (vamp) vampSDK;
    qt = qt4;
  };

  sox = import ../applications/misc/audio/sox {
    inherit fetchurl stdenv lib composableDerivation;
    # optional features
    inherit alsaLib libao ffmpeg;
    inherit libsndfile libogg flac libmad lame libsamplerate;
    # Using the default nix ffmpeg I get this error when linking
    # .libs/libsox_la-ffmpeg.o: In function `audio_decode_frame':
    # /tmp/nix-7957-1/sox-14.0.0/src/ffmpeg.c:130: undefined reference to `avcodec_decode_audio2
    # That's why I'v added ffmpeg_svn
  };

  stumpwm = builderDefsPackage (import ../applications/window-managers/stumpwm) {
    inherit texinfo;
    clisp = clisp_2_44_1;
  };

  subversion = makeOverridable (import ../applications/version-management/subversion/default.nix) {
    inherit (pkgsOverriden) fetchurl stdenv apr aprutil expat swig zlib jdk python perl sqlite;
    neon = neon029;
    bdbSupport = getConfig ["subversion" "bdbSupport"] true;
    httpServer = getConfig ["subversion" "httpServer"] false;
    httpSupport = getConfig ["subversion" "httpSupport"] true;
    sslSupport = getConfig ["subversion" "sslSupport"] true;
    pythonBindings = getConfig ["subversion" "pythonBindings"] false;
    perlBindings = getConfig ["subversion" "perlBindings"] false;
    javahlBindings = supportsJDK && getConfig ["subversion" "javahlBindings"] false;
    compressionSupport = getConfig ["subversion" "compressionSupport"] true;
    httpd = pkgsOverriden.apacheHttpd;
  };

  svk = perlPackages.SVK;

  sylpheed = import ../applications/networking/mailreaders/sylpheed {
    inherit fetchurl stdenv pkgconfig openssl gpgme;
    inherit (gtkLibs) gtk;
    sslSupport = true;
    gpgSupport = true;
  };

  # linux only by now
  synergy = import ../applications/misc/synergy {
    inherit fetchurl sourceFromHead stdenv x11 automake autoconf;
    inherit (xlibs) xextproto libXtst inputproto libXi;
  };

  tahoelafs = import ../tools/networking/p2p/tahoe-lafs {
    inherit fetchurl lib unzip nettools buildPythonPackage;
    inherit (pythonPackages) twisted foolscap simplejson nevow zfec
      pycryptopp pysqlite darcsver setuptoolsTrial setuptoolsDarcs
      numpy;
  };

  tailor = builderDefsPackage (import ../applications/version-management/tailor) {
    inherit makeWrapper python;
  };

  tangogps = import ../applications/misc/tangogps {
    inherit fetchurl stdenv pkgconfig gettext curl libexif sqlite libxml2;
    inherit (gtkLibs) gtk;
    gconf = gnome.GConf;
  };

  /* does'nt work yet i686-linux only (32bit version)
  teamspeak_client = import ../applications/networking/instant-messengers/teamspeak/client.nix {
    inherit fetchurl stdenv;
    inherit glibc x11;
  };
  */

  taskJuggler = import ../applications/misc/taskjuggler {
    inherit stdenv fetchurl;
    inherit zlib libpng perl expat;
    qt = qt3;

    inherit (xlibs) libX11 libXext libSM libICE;

    # KDE support is not working yet.
    inherit (kde3) kdelibs kdebase;
    withKde = getPkgConfig "taskJuggler" "kde" false;
  };

  thinkingRock = import ../applications/misc/thinking-rock {
    inherit fetchurl stdenv;
  };

  thunderbird = thunderbird2;

  thunderbird2 = import ../applications/networking/mailreaders/thunderbird/2.x.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  thunderbird3 = lowPrio (import ../applications/networking/mailreaders/thunderbird/3.x.nix {
    inherit fetchurl stdenv pkgconfig perl python dbus_glib zip bzip2 alsaLib nspr;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
  });

  timidity = import ../tools/misc/timidity {
    inherit fetchurl stdenv lib alsaLib composableDerivation jackaudio ncurses;
  };

  tkcvs = import ../applications/version-management/tkcvs {
    inherit stdenv fetchurl tcl tk;
  };

  tla = import ../applications/version-management/arch {
    inherit fetchurl stdenv diffutils gnutar gnupatch which;
  };

  transmission = import ../applications/networking/p2p/transmission {
    inherit stdenv fetchurl pkgconfig openssl curl intltool;
    inherit (gtkLibs) gtk;
  };

  twinkle = import ../applications/networking/twinkle {
    inherit fetchurl stdenv lib pkgconfig commoncpp2 ccrtp openssl speex libjpeg perl
      libzrtpcpp libsndfile libxml2 file readline alsaLib;
    qt = qt3;
    boost = boostFull;
    inherit (xlibs) libX11 libXaw libICE libXext;
  };

  unison = import ../applications/networking/sync/unison {
    inherit fetchurl stdenv ocaml lablgtk makeWrapper;
    inherit (xorg) xset fontschumachermisc;
  };

  uucp = import ../tools/misc/uucp {
    inherit fetchurl stdenv;
  };

  uzbl = builderDefsPackage (import ../applications/networking/browsers/uzbl) {
    inherit pkgconfig webkit makeWrapper;
    inherit (gtkLibs) gtk glib;
    libsoup = gnome28.libsoup;
  };

  uzblExperimental = builderDefsPackage
        (import ../applications/networking/browsers/uzbl/experimental.nix) {
    inherit pkgconfig webkit makeWrapper;
    inherit (gtkLibs) gtk glib;
    libsoup = gnome28.libsoup;
  };

  valknut = import ../applications/networking/p2p/valknut {
    inherit fetchurl stdenv perl x11 libxml2 libjpeg libpng openssl dclib;
    qt = qt3;
  };

  viewMtn = builderDefsPackage (import ../applications/version-management/viewmtn/0.10.nix)
  {
    inherit monotone flup cheetahTemplate highlight ctags
      makeWrapper graphviz which python;
  };

  vim = makeOverridable (import ../applications/editors/vim) {
    inherit fetchurl stdenv ncurses lib;
  };

  vimHugeX = vim.override {
    inherit pkgconfig
      perl python tcl;
    inherit (xlibs) libX11 libXext libSM libXpm
      libXt libXaw libXau;
    inherit (gtkLibs) glib gtk;

    # Looks like python and perl can conflict
    flags = ["hugeFeatures" "gtkGUI" "x11Support"
      /*"perlSupport"*/ "pythonSupport" "tclSupport"];
  };

  vim_configurable = import ../applications/editors/vim/configurable.nix {
    inherit fetchurl stdenv ncurses pkgconfig composableDerivation lib;
    inherit (xlibs) libX11 libXext libSM libXpm
        libXt libXaw libXau libXmu;
    inherit (gtkLibs) glib gtk;
    features = "huge"; # one of  tiny, small, normal, big or huge
    # optional features by passing
    # python
    # TODO mzschemeinterp perlinterp
    inherit python perl tcl ruby /*x11*/;

    # optional features by flags
    flags = [ "X11" ]; # only flag "X11" by now
  };

  vlc = import ../applications/video/vlc {
    inherit fetchurl stdenv perl xlibs zlib a52dec libmad faad2
      ffmpeg libdvdnav pkgconfig hal fribidi qt4 freefont_ttf
      libvorbis libtheora speex;
    dbus = dbus.libs;
    alsa = alsaLib;
  };

  vnstat = import ../applications/networking/vnstat {
    inherit fetchurl stdenv ncurses;
  };

  vorbisTools = import ../applications/audio/vorbis-tools {
    inherit fetchurl stdenv libogg libvorbis libao pkgconfig curl glibc
      speex flac;
  };

  vwm = import ../applications/window-managers/vwm {
    inherit fetchurl stdenv ncurses pkgconfig libviper libpseudo gpm glib libvterm;
  };

  w3m = import ../applications/networking/browsers/w3m {
    inherit fetchurl stdenv ncurses openssl boehmgc gettext zlib imlib2 x11;
    graphicsSupport = false;
  };

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

  wordnet = import ../applications/misc/wordnet {
    inherit stdenv fetchurl tcl tk x11 makeWrapper;
  };

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

  x11vnc = composedArgsAndFun (import ../tools/X11/x11vnc/0.9.3.nix) {
    inherit builderDefs openssl zlib libjpeg ;
    inherit (xlibs) libXfixes fixesproto libXdamage damageproto
      libX11 xproto libXtst libXinerama xineramaproto libXrandr randrproto
      libXext xextproto inputproto recordproto libXi renderproto
      libXrender;
  };

  x2vnc = composedArgsAndFun (import ../tools/X11/x2vnc/1.7.2.nix) {
    inherit builderDefs;
    inherit (xlibs) libX11 xproto xextproto libXext libXrandr randrproto;
  };

  xaos = builderDefsPackage (import ../applications/graphics/xaos) {
    inherit (xlibs) libXt libX11 libXext xextproto xproto;
    inherit gsl aalib zlib libpng intltool gettext perl;
  };

  xara = import ../applications/graphics/xara {
    inherit fetchurl stdenv autoconf automake libtool gettext cvs
      pkgconfig libxml2 zip libpng libjpeg shebangfix perl freetype;
    inherit (gtkLibs) gtk;
    wxGTK = wxGTK26;
  };

  xawtv = import ../applications/video/xawtv {
    inherit fetchurl stdenv ncurses libjpeg perl;
    inherit (xlibs) libX11 libXt libXft xproto libFS fontsproto libXaw libXpm libXext libSM libICE xextproto;
  };

  xchat = import ../applications/networking/irc/xchat {
    inherit fetchurl stdenv pkgconfig tcl;
    inherit (gtkLibs) gtk;
  };

  xchm = import ../applications/misc/xchm {
    inherit fetchurl stdenv chmlib wxGTK;
  };

  xcompmgr = import ../applications/window-managers/xcompmgr {
    inherit stdenv fetchurl pkgconfig;
    inherit (xlibs) libXcomposite libXfixes libXdamage libXrender;
  };

  xdg_utils = import ../tools/X11/xdg-utils {
    inherit stdenv fetchurl;
  };

  /* Doesn't work yet

  xen = builderDefsPackage (import ../applications/virtualization/xen) {
    inherit python e2fsprogs gnutls pkgconfig libjpeg
      ncurses SDL libvncserver zlib;
    texLive = if (getConfig ["xen" "texLive"] false) then texLive else null;
    graphviz = if (getConfig ["xen" "graphviz"] false) then graphviz else null;
    ghostscript = if (getConfig ["xen" "ghostscript"] false) then ghostscript else null;
  }; */

  xfig = import ../applications/graphics/xfig {
    stdenv = overrideGCC stdenv gcc34;
    inherit fetchurl makeWrapper x11 Xaw3d libpng libjpeg;
    inherit (xlibs) imake libXpm libXmu libXi libXp;
  };

  xineUI = import ../applications/video/xine-ui {
    inherit fetchurl stdenv pkgconfig xlibs xineLib libpng readline ncurses curl;
  };

  xmms = import ../applications/audio/xmms {
    inherit fetchurl libogg libvorbis alsaLib;
    inherit (gnome) esound;
    inherit (gtkLibs1x) glib gtk;
    stdenv = overrideGCC stdenv gcc34; # due to problems with gcc 4.x
  };

  xneur = import ../applications/misc/xneur {
    inherit fetchurl stdenv pkgconfig pcre libxml2 aspell imlib2
      xosd libnotify cairo;
    GStreamer=gst_all.gstreamer;
    inherit (xlibs) libX11 libXpm libXt libXext libXi;
    inherit (gtkLibs) glib gtk pango atk;
  };

  xneur_0_8 = import ../applications/misc/xneur/0.8.nix {
    inherit fetchurl stdenv pkgconfig pcre libxml2 aspell imlib2 xosd glib;
    GStreamer = gst_all.gstreamer;
    inherit (xlibs) libX11 libXpm libXt libXext;
  };

  xournal = import ../applications/graphics/xournal {
    inherit stdenv fetchurl;
    inherit ghostscript fontconfig freetype zlib
      poppler popplerData autoconf automake
      libtool pkgconfig;
    inherit (xlibs) xproto libX11;
    inherit (gtkLibs) gtk atk pango glib;
    inherit (gnome) libgnomeprint libgnomeprintui
      libgnomecanvas;
  };

  xpdf = import ../applications/misc/xpdf {
    inherit fetchurl stdenv x11 freetype t1lib;
    motif = lesstif;
    base14Fonts = "${ghostscript}/share/ghostscript/fonts";
  };

  xpra = import ../tools/X11/xpra {
    inherit stdenv fetchurl pkgconfig python pygtk xlibs makeWrapper;
    inherit (gtkLibs) gtk;
    pyrex = pyrex095;
  };

  xscreensaver = makeOverridable (import ../applications/graphics/xscreensaver) {
    inherit stdenv fetchurl pkgconfig bc perl xlibs libjpeg mesa libxml2;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade;
  };

  xterm = import ../applications/misc/xterm {
    inherit fetchurl stdenv ncurses freetype pkgconfig;
    inherit (xlibs) libXaw xproto libXt libX11 libSM libICE libXext libXft luit;
  };

  xtrace = import ../tools/X11/xtrace {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11;
  };

  xlaunch = import ../tools/X11/xlaunch {
    inherit stdenv;
    inherit (xorg) xorgserver;
  };

  xmacro = import ../tools/X11/xmacro {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi libXtst xextproto inputproto;
  };

  xmove = import ../applications/misc/xmove {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi imake libXau;
    inherit (xorg) xauth;
  };

  xnee = builderDefsPackage (import ../tools/X11/xnee) {
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11 libXtst xextproto libXext
      inputproto libXi xproto recordproto;
    inherit pkgconfig;
  };

  xvidcap = import ../applications/video/xvidcap {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig gettext lame;
    inherit (gtkLibs) gtk;
    inherit (gnome) scrollkeeper libglade;
    inherit (xlibs) libXmu libXext libXfixes libXdamage libX11;
  };

  yate = import ../applications/misc/yate {
    inherit sox speex openssl automake autoconf pkgconfig;
    inherit fetchurl stdenv lib composableDerivation;
    qt = qt4;
  };

  # doesn't compile yet - in case someone else want's to continue ..
  qgis = (import ../applications/misc/qgis/1.0.1-2.nix) {
    inherit composableDerivation fetchsvn stdenv flex lib
            ncurses fetchurl perl cmake gdal geos proj x11
            gsl libpng zlib bison
            sqlite glibc fontconfig freetype /* use libc from stdenv ? - to lazy now - Marc */;
    inherit (xlibs) libSM libXcursor libXinerama libXrandr libXrender;
    inherit (xorg) libICE;
    qt = qt4;

    # optional features
    # grass = "not yet supported" # cmake -D WITH_GRASS=TRUE  and GRASS_PREFX=..
  };

  zapping = import ../applications/video/zapping {
    inherit fetchurl stdenv pkgconfig perl python
            gettext zvbi libjpeg libpng x11
            rte perlXMLParser;
    inherit (gnome) scrollkeeper libgnomeui libglade esound;
    inherit (xlibs) libXv libXmu libXext;
    teletextSupport = true;
    jpegSupport = true;
    pngSupport = true;
    recordingSupport = true;
  };


  ### GAMES

  ballAndPaddle = import ../games/ball-and-paddle {
    inherit fetchurl stdenv SDL SDL_image SDL_mixer SDL_ttf guile gettext;
  };

  bsdgames = import ../games/bsdgames {
    inherit fetchurl stdenv ncurses openssl flex bison miscfiles;
  };

  castleCombat = import ../games/castle-combat {
    inherit fetchurl stdenv python pygame twisted lib numeric makeWrapper;
  };

  construoBase = composedArgsAndFun (import ../games/construo/0.2.2.nix) {
    inherit stdenv fetchurl builderDefs
      zlib;
    inherit (xlibs) libX11 xproto;
  };

  construo = construoBase.passthru.function {
    inherit mesa freeglut;
  };

  eduke32 = import ../games/eduke32 {
    inherit stdenv fetchsvn SDL SDL_mixer unzip libvorbis mesa pkgconfig nasm makeDesktopItem;
    inherit (gtkLibs) gtk;
  };

  exult = import ../games/exult {
    inherit fetchurl SDL SDL_mixer zlib libpng unzip;
    stdenv = overrideGCC stdenv gcc42;
  };

  /*
  exultSnapshot = lowPrio (import ../games/exult/snapshot.nix {
    inherit fetchurl stdenv SDL SDL_mixer zlib libpng unzip
      autoconf automake libtool flex bison;
  });
  */

  freedink = import ../games/freedink {
    inherit stdenv fetchurl SDL SDL_mixer SDL_image SDL_ttf SDL_gfx
      pkgconfig fontconfig libzip zip zlib;
  };

  fsg = import ../games/fsg {
    inherit stdenv fetchurl pkgconfig mesa;
    inherit (gtkLibs) glib gtk;
    inherit (xlibs) libX11 xproto;
    wxGTK = wxGTK28.override {unicode = false;};
  };

  fsgAltBuild = import ../games/fsg/alt-builder.nix {
    inherit stdenv fetchurl mesa;
    wxGTK = wxGTK28.override {unicode = false;};
    inherit (xlibs) libX11 xproto;
    inherit stringsWithDeps builderDefs;
  };

  gemrb = import ../games/gemrb {
    inherit fetchurl stdenv SDL openal freealut zlib libpng python;
  };

  gnuchess = builderDefsPackage (import ../games/gnuchess) {
    flex = flex2535;
  };

  gnugo = import ../games/gnugo {
    inherit stdenv fetchurl;
  };

  gparted = import ../tools/misc/gparted {
    inherit fetchurl stdenv parted intltool gettext libuuid pkgconfig libxml2;
    inherit (gtkLibs) gtk glib gtkmm;
    inherit (gnome) gnomedocutils;
  };

  hexen = import ../games/hexen {
    inherit stdenv fetchurl SDL;
  };

  kobodeluxe = import ../games/kobodeluxe {
    inherit stdenv fetchurl SDL SDL_image;
  };

  lincity = builderDefsPackage (import ../games/lincity) {
    inherit (xlibs) libX11 libXext xextproto
      libICE libSM xproto;
    inherit libpng zlib;
  };

  micropolis = import ../games/micropolis {
    inherit lib fetchurl stdenv;
    inherit (xlibs) libX11 libXpm libXext xextproto;
    inherit byacc bash;
  };

  openttd = import ../games/openttd {
    inherit fetchurl stdenv SDL libpng;
    zlib = zlibStatic;
  };

  pioneers = import ../games/pioneers {
    inherit stdenv fetchurl pkgconfig intltool;
    inherit (gtkLibs) gtk /*glib gtkmm*/;
  };

  quake3demo = import ../games/quake3/wrapper {
    name = "quake3-demo-${quake3game.name}";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    inherit fetchurl stdenv mesa makeWrapper;
    game = quake3game;
    paks = [quake3demodata];
  };

  quake3demodata = import ../games/quake3/demo {
    inherit fetchurl stdenv;
  };

  quake3game = import ../games/quake3/game {
    inherit fetchurl stdenv x11 SDL mesa openal;
  };

  rogue = import ../games/rogue {
    inherit fetchurl stdenv ncurses;
  };

  scummvm = import ../games/scummvm {
    inherit fetchurl stdenv SDL zlib mpeg2dec;
  };

  scorched3d = import ../games/scorched3d {
    inherit stdenv fetchurl mesa openal autoconf automake libtool freealut freetype fftw SDL SDL_net zlib libpng libjpeg;
    wxGTK = wxGTK26;
  };

  sgtpuzzles = builderDefsPackage (import ../games/sgt-puzzles) {
    inherit (gtkLibs) gtk;
    inherit pkgconfig fetchsvn perl;
    inherit (xlibs) libX11;
  };

  six = import ../games/six {
    inherit stdenv fetchurl;
    inherit perl zlib qt3;
    inherit (kde3) arts kdelibs;
    inherit (xlibs) libX11 libXt libXext;
  };

  # You still can override by passing more arguments.
  spaceOrbit = composedArgsAndFun (import ../games/orbit/1.01.nix) {
    inherit fetchurl stdenv builderDefs mesa freeglut;
    inherit (gnome) esound;
    inherit (xlibs) libXt libX11 libXmu libXi libXext;
  };

  superTux = import ../games/super-tux {
    inherit fetchurl stdenv SDL SDL_image SDL_mixer curl gettext libogg libvorbis mesa openal;
  };

  superTuxKart = import ../games/super-tux-kart {
    inherit fetchurl stdenv plib SDL openal freealut mesa
      libvorbis libogg gettext;
  };

  teeworlds = import ../games/teeworlds {
    inherit fetchurl stdenv python alsaLib mesa SDL;
    inherit (xlibs) libX11;
  };

  tennix = import ../games/tennix {
    inherit stdenv fetchurl SDL SDL_mixer SDL_image SDL_ttf;
  };

  /*tpm = import ../games/thePenguinMachine {
    inherit stdenv fetchurl pil pygame SDL;
    python24 = python;
  };*/

  ultimatestunts = import ../games/ultimatestunts {
    inherit stdenv fetchurl SDL mesa SDL_image freealut;
  };

  urbanterror = import ../games/urbanterror {
    inherit fetchurl stdenv unzip SDL mesa openal curl;
  };

  ut2004demo = import ../games/ut2004demo {
    inherit fetchurl stdenv xlibs mesa;
  };

  warsow = import ../games/warsow {
    inherit stdenv fetchurl unzip pkgconfig zlib curl libvorbis SDL
            mesa openal;
    inherit (xlibs) libXxf86dga libXxf86vm libXinerama;
    libjpeg = libjpeg62;
  };

  warzone2100 = import ../games/warzone2100 {
    inherit stdenv fetchurl bison gettext pkgconfig SDL libpng libtheora
            openal popt physfs mesa quesoglc zip unzip which;
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

  zdoom = import ../games/zdoom {
    inherit cmake stdenv fetchsvn SDL nasm p7zip zlib flac fmod libjpeg;
  };

  zoom = import ../games/zoom {
    inherit fetchurl stdenv perl expat freetype;
    inherit (xlibs) xlibs;
  };

  keen4 = import ../games/keen4 {
    inherit fetchurl stdenv dosbox unzip;
  };


  ### DESKTOP ENVIRONMENTS


  enlightenment = import ../desktops/enlightenment {
    inherit stdenv fetchurl pkgconfig x11 xlibs dbus imlib2 freetype;
  };

  gnome28 = recurseIntoAttrs (import ../desktops/gnome-2.28 pkgs);

  gnome = gnome28;

  kde3 = recurseIntoAttrs {

    kdelibs = import ../desktops/kde-3/kdelibs {
      inherit
        fetchurl xlibs zlib perl openssl pcre pkgconfig
        libjpeg libpng libtiff libxml2 libxslt libtool
        expat freetype bzip2 cups attr acl;
      stdenv = overrideGCC stdenv gcc43;
      qt = qt3;
    };

    kdebase = import ../desktops/kde-3/kdebase {
      inherit
        fetchurl pkgconfig x11 xlibs zlib libpng libjpeg perl
        openssl bzip2 fontconfig pam hal dbus glib;
      stdenv = overrideGCC stdenv gcc43;
      inherit (kde3) kdelibs;
      qt = qt3;
    };

    arts = import ../development/libraries/arts {
      inherit fetchurl stdenv pkgconfig;
      inherit (xlibs) libX11 libXext;
      inherit zlib libjpeg libpng perl;
      qt = qt3;
      inherit (gnome) glib;
      inherit (kde3) kdelibs;
    };

    k3b = import ../applications/misc/k3b {
      inherit stdenv fetchurl x11 zlib libpng libjpeg perl qt3;
      inherit (kde3) kdelibs;
    };

    kbasket = import ../applications/misc/kbasket {
      inherit fetchurl x11 zlib libpng libjpeg
        perl qt3 gpgme libgpgerror;
      stdenv = overrideGCC stdenv gcc43;
      inherit (kde3) kdelibs;
    };

    kile = import ../applications/editors/kile {
      inherit stdenv fetchurl perl zlib libpng libjpeg freetype expat;
      inherit (xlibs) libX11 libXt libXext libXrender libXft;
      inherit (kde3) arts kdelibs;
      qt = qt3;
    };

    kphone = import ../applications/networking/kphone {
      inherit fetchurl lib autoconf automake libtool pkgconfig openssl libpng alsaLib;
      qt = qt3;
      inherit (xlibs) libX11 libXext libXt libICE libSM;
      stdenv = overrideGCC stdenv gcc42; # I'm to lazy to clean up header files
    };

    kuickshow = import ../applications/graphics/kuickshow {
      inherit fetchurl stdenv libpng libjpeg libtiff libungif imlib expat perl;
      inherit (xlibs) libX11 libXext libSM;
      inherit (kde3) arts kdelibs;
      qt = qt3;
    };

    kcachegrind = import ../development/tools/misc/kcachegrind {
      inherit fetchurl stdenv zlib perl expat libpng libjpeg;
      inherit (xlibs) libX11 libXext libSM;
      inherit (kde3) kdelibs;
      qt = qt3;
    };

  };

  kde4 = kde44;

  kde44 = makeOverridable (import ../desktops/kde-4.4) (pkgs // {
    openexr = openexr_1_6_1;
    stdenv = stdenv2;
  });

  xfce = xfce4;
  xfce4 = recurseIntoAttrs (import ../desktops/xfce-4 pkgs);

  ### SCIENCE

  xplanet = import ../applications/science/xplanet {
    inherit stdenv fetchurl lib pkgconfig freetype libpng libjpeg giflib libtiff;
    inherit (gtkLibs) pango;
  };

  ### SCIENCE/GEOMETRY

  drgeo = builderDefsPackage (import ../applications/science/geometry/drgeo) {
    inherit (gnome) libglade gtk;
    inherit libxml2 guile perl intltool libtool pkgconfig;
  };


  ### SCIENCE/BIOLOGY

  alliance = import ../applications/science/electronics/alliance {
    inherit fetchurl stdenv bison flex;
    inherit (xlibs) xproto libX11 libXt libXpm;
    motif = lesstif;
  };

  arb = import ../applications/science/biology/arb {
    inherit fetchurl readline libpng zlib x11 lesstif93 freeglut perl;
    inherit (xlibs) libXpm libXaw libX11 libXext libXt;
    inherit mesa glew libtiff lynx rxp sablotron jdk transfig gv gnuplot;
    lesstif = lesstif93;
    stdenv = overrideGCC stdenv gcc42;
  };

  biolib = import ../development/libraries/science/biology/biolib {
    inherit fetchurl stdenv readline perl cmake rLang zlib;
  };

  emboss = import ../applications/science/biology/emboss {
    inherit fetchurl stdenv readline perl libpng zlib;
    inherit (xorg) libX11 libXt;
  };

  mrbayes = import ../applications/science/biology/mrbayes {
    inherit fetchurl stdenv readline;
  };

  ncbiCTools = builderDefsPackage ../development/libraries/ncbi {
    inherit tcsh mesa lesstif;
    inherit (xlibs) libX11 libXaw xproto libXt libSM libICE
      libXmu libXext;
  };

  ncbi_tools = import ../applications/science/biology/ncbi-tools {
    inherit fetchurl stdenv cpio;
  };

  paml = import ../applications/science/biology/paml {
    inherit fetchurl stdenv;
  };

  /* slr = import ../applications/science/biology/slr {
    inherit fetchurl stdenv liblapack;
  }; */

  pal2nal = import ../applications/science/biology/pal2nal {
    inherit fetchurl stdenv perl paml;
  };


  ### SCIENCE/MATH

  atlas = import ../development/libraries/science/math/atlas {
    inherit fetchurl stdenv gfortran;
  };

  blas = import ../development/libraries/science/math/blas {
    inherit fetchurl stdenv gfortran;
  };

  content = builderDefsPackage ../applications/science/math/content {
    inherit mesa lesstif;
    inherit (xlibs) libX11 libXaw xproto libXt libSM libICE
      libXmu libXext libXcursor;
  };

  liblapack = import ../development/libraries/science/math/liblapack {
    inherit fetchurl stdenv gfortran blas;
  };


  ### SCIENCE/LOGIC

  coq = import ../applications/science/logic/coq {
    inherit stdenv fetchurl ocaml lablgtk ncurses;
    camlp5 = camlp5_transitional;
  };

  coq_beta = import ../applications/science/logic/coq/beta.nix {
    inherit stdenv fetchurl ocaml lablgtk ncurses;
    camlp5 = camlp5_transitional;
  };

  hol_light = import ../applications/science/logic/hol_light {
    inherit stdenv fetchurl ocaml_with_sources;
  };

  hol_light_binaries =
  import ../applications/science/logic/hol_light/binaries.nix {
    inherit stdenv ocaml_with_sources hol_light nettools openssh;
    dmtcp = dmtcp_devel;
  };

  # This is a special version of OCaml handcrafted especially for
  # hol_light it should be merged with the current expresion for ocaml
  # one day.
  ocaml_with_sources =
  import ../applications/science/logic/hol_light/ocaml-with-sources.nix {
    inherit stdenv fetchurl;
  };

  isabelle = import ../applications/science/logic/isabelle {
    inherit (pkgs) stdenv fetchurl nettools perl polyml emacs emacsPackages;
  };

  ssreflect = import ../applications/science/logic/ssreflect {
    inherit stdenv fetchurl ocaml coq;
    camlp5 = camlp5_transitional;
  };

  ### SCIENCE / ELECTRONICS

  ngspice = import ../applications/science/electronics/ngspice {
    inherit fetchurl stdenv readline;
  };

  gtkwave = import ../applications/science/electronics/gtkwave {
    inherit fetchurl stdenv gperf pkgconfig bzip2 xz;
    inherit (gtkLibs) gtk;
  };

  ### SCIENCE / MATH

  maxima = import ../applications/science/math/maxima {
    inherit fetchurl stdenv clisp;
  };

  wxmaxima = import ../applications/science/math/wxmaxima {
    inherit fetchurl stdenv maxima;
    inherit wxGTK;
  };

  scilab = (import ../applications/science/math/scilab) {
    inherit stdenv fetchurl lib gfortran;
    inherit (gtkLibs) gtk;
    inherit ncurses Xaw3d tcl tk ocaml x11;

    withXaw3d = false;
    withTk = true;
    withGtk = false;
    withOCaml = true;
    withX = true;
  };


  ### MISC

  atari800 = import ../misc/emulators/atari800 {
    inherit fetchurl stdenv unzip zlib SDL;
  };

  ataripp = import ../misc/emulators/atari++ {
    inherit fetchurl stdenv x11 SDL;
  };

  auctex = import ../misc/tex/auctex {
    inherit stdenv fetchurl emacs texLive;
  };

  busybox = makeOverridable (import ../misc/busybox) {
    inherit fetchurl stdenv;
    enableStatic = true;
  };

  cups = import ../misc/cups {
    inherit fetchurl stdenv pkgconfig zlib libjpeg libpng libtiff pam openssl dbus;
  };

  gutenprint = import ../misc/drivers/gutenprint {
    inherit fetchurl stdenv lib pkgconfig composableDerivation cups libtiff libpng
      openssl git gimp;
  };

  gutenprintBin = import ../misc/drivers/gutenprint/bin.nix {
    inherit fetchurl stdenv rpm cpio zlib;
  };

  cupsBjnp = import ../misc/cups/drivers/cups-bjnp {
    inherit fetchurl stdenv cups;
  };

  dblatex = import ../misc/tex/dblatex {
    inherit fetchurl stdenv python libxslt tetex;
  };

  dosbox = import ../misc/emulators/dosbox {
    inherit fetchurl stdenv SDL makeDesktopItem;
  };

  dpkg = import ../tools/package-management/dpkg {
    inherit fetchurl stdenv perl zlib bzip2;
  };

  electricsheep = import ../misc/screensavers/electricsheep {
    inherit fetchurl stdenv pkgconfig expat zlib libpng libjpeg xlibs;
  };

  foldingathome = import ../misc/foldingathome {
    inherit fetchurl stdenv;
  };

  freestyle = import ../misc/freestyle {
    inherit fetchurl freeglut qt4 libpng lib3ds libQGLViewer swig;
    inherit (xlibs) libXi;
    #stdenv = overrideGCC stdenv gcc41;
    inherit stdenv python;
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

  generator = import ../misc/emulators/generator {
    inherit fetchurl stdenv SDL nasm zlib bzip2 libjpeg;
    inherit (gtkLibs1x) gtk;
  };

  ghostscript = makeOverridable (import ../misc/ghostscript) {
    inherit fetchurl stdenv libjpeg libpng libtiff zlib x11 pkgconfig
      fontconfig cups openssl;
    x11Support = false;
    cupsSupport = getPkgConfig "ghostscript" "cups" true;
  };

  ghostscriptX = lowPrio (appendToName "with-X" (ghostscript.override {
    x11Support = true;
  }));

  gxemul = (import ../misc/gxemul) {
    inherit lib stdenv fetchurl composableDerivation;
    inherit (xlibs) libX11;
  };

  # using the new configuration style proposal which is unstable
  jackaudio = import ../misc/jackaudio {
    inherit composableDerivation
           ncurses lib stdenv fetchurl alsaLib pkgconfig;
    flags = [ "posix_shm" "timestamps" "alsa"];
  };

  keynav = import ../tools/X11/keynav {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 xextproto libXtst imake libXi libXext;
  };

  lazylist = import ../misc/tex/lazylist {
    inherit fetchurl stdenv tetex;
  };

  lilypond = import ../misc/lilypond {
    inherit fetchurl sourceFromHead stdenv lib automake autoconf
      ghostscript texinfo imagemagick texi2html guile python gettext
      perl bison pkgconfig texLive fontconfig freetype fontforge help2man;
    inherit (gtkLibs) pango;
    flex = flex2535;
  };

  martyr = import ../development/libraries/martyr {
    inherit stdenv fetchurl apacheAnt;
  };

  maven = import ../misc/maven/maven-1.0.nix {
    inherit stdenv fetchurl jdk;
  };

  maven2 = import ../misc/maven {
    inherit stdenv fetchurl jdk makeWrapper;
  };

  nix = nixUnstable;

  nixStable = makeOverridable (import ../tools/package-management/nix) {
    inherit fetchurl stdenv perl curl bzip2 openssl aterm;
    storeDir = getPkgConfig "nix" "storeDir" "/nix/store";
    stateDir = getPkgConfig "nix" "stateDir" "/nix/var";
  };

  nixUnstable = makeOverridable (import ../tools/package-management/nix/unstable.nix) {
    inherit fetchurl stdenv perl curl bzip2 openssl;
    storeDir = getPkgConfig "nix" "storeDir" "/nix/store";
    stateDir = getPkgConfig "nix" "stateDir" "/nix/var";
  };

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

  disnix = import ../tools/package-management/disnix {
    inherit stdenv fetchurl pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable;
  };

  disnix_activation_scripts = import ../tools/package-management/disnix/activation-scripts {
    inherit stdenv fetchurl;
  };

  DisnixService = import ../tools/package-management/disnix/DisnixService {
    inherit stdenv fetchurl apacheAnt jdk axis2 dbus_java;
  };

  latex2html = import ../misc/tex/latex2html/default.nix {
    inherit fetchurl stdenv perl ghostscript netpbm;
    tex = tetex;
  };

  pgadmin = import ../applications/misc/pgadmin {
    inherit fetchurl stdenv postgresql libxml2 libxslt openssl;
    inherit wxGTK;
  };

  pgf = pgf2;

  # Keep the old PGF since some documents don't render properly with
  # the new one.
  pgf1 = import ../misc/tex/pgf/1.x.nix {
    inherit fetchurl stdenv;
  };

  pgf2 = import ../misc/tex/pgf/2.x.nix {
    inherit fetchurl stdenv;
  };

  polytable = import ../misc/tex/polytable {
    inherit fetchurl stdenv tetex lazylist;
  };

  psi = (import ../applications/networking/instant-messengers/psi) {
    inherit stdenv fetchurl zlib aspell sox pkgconfig qt4;
    inherit (xlibs) xproto libX11 libSM libICE;
    qca2 = kde4.qca2;
  };

  putty = import ../applications/networking/remote/putty {
    inherit stdenv fetchsvn ncurses pkgconfig autoconf automake perl halibut;
    inherit (gtkLibs) gtk;
  };

  rssglx = import ../misc/screensavers/rss-glx {
    inherit fetchurl stdenv x11 mesa pkgconfig imagemagick libtiff bzip2;
  };

  xlockmore = import ../misc/screensavers/xlockmore {
    inherit fetchurl stdenv x11 freetype;
    pam = if getPkgConfig "xlockmore" "pam" true then pam else null;
  };

  saneBackends = import ../misc/sane-backends {
    inherit fetchurl stdenv libusb;
    gt68xxFirmware = getConfig ["sane" "gt68xxFirmware"] null;
  };

  saneFrontends = import ../misc/sane-front {
    inherit fetchurl stdenv pkgconfig libusb saneBackends;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11;
  };

  sourceAndTags = import ../misc/source-and-tags {
    inherit pkgs stdenv unzip lib ctags;
    hasktags = haskellPackages.myhasktags;
  };

  splix = import ../misc/cups/drivers/splix {
    inherit stdenv fetchurl cups zlib;
  };

  tetex = import ../misc/tex/tetex {
    inherit fetchurl stdenv flex bison zlib libpng ncurses ed;
  };

  tex4ht = import ../misc/tex/tex4ht {
    inherit fetchurl stdenv tetex;
  };

  texFunctions = import ../misc/tex/nix {
    inherit stdenv perl tetex graphviz ghostscript makeFontsConf imagemagick runCommand lib;
    inherit (haskellPackages) lhs2tex;
  };

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

  toolbuslib = import ../development/libraries/toolbuslib {
    inherit stdenv fetchurl aterm;
  };

  trac = import ../misc/trac {
    inherit stdenv fetchurl python clearsilver makeWrapper
      sqlite subversion;
    inherit (pythonPackages) pysqlite;
  };

  vice = import ../misc/emulators/vice {
    inherit stdenv fetchurl lib perl gettext libpng giflib libjpeg alsaLib readline mesa;
    inherit pkgconfig SDL makeDesktopItem autoconf automake;
    inherit (gtkLibs) gtk;
  };

  wine =
    # Wine cannot be built in 64-bit; use a 32-bit build instead.
    import ../misc/emulators/wine {
      inherit (pkgsi686Linux) fetchurl stdenv bison mesa ncurses
        libpng libjpeg alsaLib lcms xlibs freetype
        fontconfig fontforge libxml2 libxslt openssl;
      flex = pkgsi686Linux.flex2535;
    };

  x2x = import ../tools/X11/x2x {
    inherit stdenv fetchurl;
    inherit (xlibs) imake libX11 libXtst libXext;
  };

  xosd = import ../misc/xosd {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXext libXt xextproto xproto;
  };

  xsane = import ../misc/xsane {
    inherit fetchurl stdenv pkgconfig libusb
      saneBackends saneFrontends;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11;
  };

  yafc = import ../applications/networking/yafc {
    inherit fetchurl stdenv readline openssh;
  };

  myEnvFun = import ../misc/my-env {
    inherit substituteAll pkgs;
    inherit (stdenv) mkDerivation;
  };

  misc = import ../misc/misc.nix { inherit pkgs stdenv; };

}; in pkgs
