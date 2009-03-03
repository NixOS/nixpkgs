/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform.

   You want to get to know where to add a new package ?
   Have a look at nixpkgs/maintainers/docs/classification.txt */


{ # The system (e.g., `i686-linux') for which to build the packages.
  system ? __currentSystem

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

}:


let

  lib = import ../lib;

  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  config =
    let {
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      body =
        if configFile != "" && pathExists configFile
        then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2
        then import (toPath configFile2)
        else {};
    };

  # Return an attribute from the Nixpkgs configuration file, or
  # a default value if the attribute doesn't exist.
  getConfig = attrPath: default: lib.getAttr attrPath default config;


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
  pkgs = pkgsOverriden;


  # The package compositions.  Yes, this isn't properly indented.
  pkgsFun = __overrides: rec {


  inherit __overrides;


  # For convenience, allow callers to get the path to Nixpkgs.
  path = ./..;


  ### Symbolic names.


  x11 = xlibsWrapper;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X libraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = xorg // {xlibs = xlibsWrapper;};


  ### Helper functions.


  inherit lib config getConfig;

  addAttrsToDerivation = extraAttrs: stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // extraAttrs); };

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // {recurseForDerivations = true;};

  useFromStdenv = it : alternative : if (builtins.hasAttr it stdenv) then
    (builtins.getAttr it stdenv) else alternative;

  # Return the first available value in the order: pkg.val, val, or default.
  getPkgConfig = pkg : val : default : (getConfig [ pkg val ] (getConfig [ val ] default));

  # Return user-choosen version of given package. If you define package as
  #
  # pkgname_alts =
  # {
  #   v_0_1 = ();
  #   v_0_2 = ();
  #   default = v_0_1;
  #   recurseForDerivations = true;
  # };
  # pkgname = getVersion "name" pkgname_alts;
  #
  # user will be able to write in his configuration.nix something like
  # name = { version = "0.2"; }; and pkgname will be equal
  # to getAttr pkgname_alts "0.2". Using alts.default by default.
  getVersion = name: alts: builtins.getAttr
    (getConfig [ name "version" ] "default") alts;

  # The same, another syntax.
  # Warning: syntax for configuration.nix changed too
  useVersion = name: f: f {
    version = getConfig [ "environment" "versions" name ];
  };

  # Change the symbolic name of a package for presentation purposes
  # (i.e., so that nix-env users can tell them apart).
  setName = name: drv: drv // {inherit name;};

  updateName = updater: drv: drv // {name = updater (drv.name);};

  # !!! the suffix should really be appended *before* the version, at
  # least most of the time.
  appendToName = suffix: updateName (name: "${name}-${suffix}");

  # Decrease the priority of the package, i.e., other
  # versions/variants will be preferred.
  lowPrio = drv: drv // {
    meta = (if drv ? meta then drv.meta else {}) // {priority = "10";};
  };

  # Check absence of non-used options
  checker = x: flag: opts: config:
    (if flag then let result=(
      (import ../build-support/checker)
      opts config); in
      (if (result=="") then x else
      abort ("Unknown option specified: " + result))
    else x);

  builderDefs = composedArgsAndFun (import ./builder-defs.nix) {
    inherit stringsWithDeps lib stdenv writeScript fetchurl;
  };

  composedArgsAndFun = lib.composedArgsAndFun;

  builderDefsPackage = builderDefs.builderDefsPackage builderDefs;

  stringsWithDeps = import ../lib/strings-with-deps.nix {
    inherit stdenv lib;
  };

  # Call a specific version of a Nix expression, that is,
  # `selectVersion ./foo {version = "0.1.2"; args...}' evaluates to
  # `import ./foo/0.1.2.nix args'.
  selectVersion = dir: defVersion: args:
    let
      pVersion =
        if (args ? version && args.version != "") then
          args.version
        else
          getConfig [ (baseNameOf (toString dir)) "version" ] defVersion;
    in
      import (dir + "/${pVersion}.nix") (args // { version = pVersion; });

  makeOverridable = f: origArgs: f origArgs //
    { function = newArgsFun: makeOverridable f (origArgs // (newArgsFun origArgs));
    };


  ### STANDARD ENVIRONMENT


  allStdenvs = import ../stdenv {
    inherit system stdenvType;
    allPackages = import ./all-packages.nix;
  };

  defaultStdenv = allStdenvs.stdenv;

  stdenv =
    if bootStdenv != null then bootStdenv else
      let changer = getConfig ["replaceStdenv"] null;
      in if changer != null then
        changer {
          stdenv = defaultStdenv;
          overrideSetup = overrideSetup;
        }
      else defaultStdenv;

  # A stdenv capable of building 32-bit binaries.  On x86_64-linux,
  # it uses GCC compiled with multilib support; on i686-linux, it's
  # just the plain stdenv.
  stdenv_32bit =
    if system == "x86_64-linux" then
      overrideGCC stdenv gcc43multi
    else
      stdenv;

  inherit (import ../stdenv/adapters.nix {inherit (pkgs) dietlibc fetchurl runCommand;})
    overrideGCC overrideInStdenv overrideSetup
    useDietLibC useKlibc makeStaticBinaries;


  ### BUILD SUPPORT


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

  # only temporarely  / don't know yet wether it's save to switch
  # but I have trouble getting HAppS repos
  fetchdarcs2 = import ../build-support/fetchdarcs {
    inherit stdenv nix;
    darcs = darcs2;
  };

  fetchsvn = import ../build-support/fetchsvn {
    inherit stdenv subversion openssh;
    sshSupport = true;
  };

  fetchsvnssh = import ../build-support/fetchsvnssh {
    inherit stdenv subversion openssh expect;
    sshSupport = true;
  };

  # TODO do some testing
  fetchhg = import ../build-support/fetchhg {
    inherit stdenv mercurial nix;
  };

  # `fetchurl' downloads a file from the network.  The `useFromStdenv'
  # is there to allow stdenv to determine fetchurl.  Used during the
  # stdenv-linux bootstrap phases to prevent lots of different curls
  # from being built.
  fetchurl = useFromStdenv "fetchurl"
    (import ../build-support/fetchurl {
      inherit stdenv curl;
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

  makeInitrd = {contents}: import ../build-support/kernel/make-initrd.nix {
    inherit stdenv perl cpio contents;
  };

  makeSetupHook = script: runCommand "hook" {} ''
    ensureDir $out/nix-support
    cp ${script} $out/nix-support/setup-hook
  '';

  makeWrapper = makeSetupHook ../build-support/make-wrapper/make-wrapper.sh;

  makeModulesClosure = {kernel, rootModules, allowMissing ? false}:
    import ../build-support/kernel/modules-closure.nix {
      inherit stdenv module_init_tools kernel rootModules allowMissing;
    };

  # Run the shell command `buildCommand' to produce a store object
  # named `name'.  The attributes in `env' are added to the
  # environment prior to running the command.
  runCommand = name: env: buildCommand: stdenv.mkDerivation ({
    inherit name buildCommand;
  } // env);

  symlinkJoin = name: paths: runCommand name {inherit paths;} "mkdir -p $out; for i in $paths; do ${xorg.lndir}/bin/lndir $i $out; done";

  # Create a single file.
  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    }:
    runCommand name {inherit text executable; } ''
      n=$out${destination}
      mkdir -p "$(dirname "$n")"
      echo -n "$text" > "$n"
      (test -n "$executable" && chmod +x "$n") || true
    '';

  # Shorthands for `writeTextFile'.
  writeText = name: text: writeTextFile {inherit name text;};
  writeScript = name: text: writeTextFile {inherit name text; executable = true;};
  writeScriptBin = name: text: writeTextFile {inherit name text; executable = true; destination = "/bin/${name}";};

  # entries is a list of attribute sets like { name = "name" ; path = "/nix/store/..."; }
  linkFarm = name: entries: runCommand name {} ("mkdir -p $out; cd $out; \n" +
    (lib.concatMapStrings (x: "ln -s '${x.path}' '${x.name}';\n") entries));

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

  # Write the references (i.e. the runtime dependencies in the Nix store) of `path' to a file.
  writeReferencesToFile = path: runCommand "runtime-deps"
    {
      exportReferencesGraph = ["graph" path];
    }
    ''
      touch $out
      while read path; do
        echo $path >> $out
        read dummy
        read nrRefs
        for ((i = 0; i < nrRefs; i++)); do read ref; done
      done < graph
    '';


  ### TOOLS


  aefs = import ../tools/security/aefs {
    inherit fetchurl stdenv fuse;
  };

  aircrackng = import ../tools/networking/aircrack-ng {
    inherit fetchurl stdenv libpcap openssl zlib wirelesstools;
  };

  amule = import ../tools/networking/p2p/amule {
    inherit fetchurl stdenv zlib perl cryptopp gettext libupnp makeWrapper;
    wxGTK = wxGTK28;
  };

  aria = builderDefsPackage (import ../tools/networking/aria) {
  };

  at = import ../tools/system/at {
    inherit fetchurl stdenv bison flex pam ssmtp;
  };

  avahi =
    let qt4Support = getConfig [ "avahi" "qt4Support" ] false;
    in
      import ../development/libraries/avahi {
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
    inherit fetchurl stdenv flex;
  };

  bfr = import ../tools/misc/bfr {
    inherit fetchurl stdenv perl;
  };

  syslogng = import ../tools/misc/syslog-ng {
    inherit fetchurl stdenv eventlog pkgconfig;
    inherit (gtkLibs) glib;
  };

  asciidoc = import ../tools/typesetting/asciidoc {
    inherit fetchurl stdenv bash python;
  };

  bibtextools = import ../tools/typesetting/bibtex-tools {
    inherit fetchurl stdenv aterm tetex hevea sdf strategoxt;
  };

  bittorrent = import ../tools/networking/p2p/bittorrent {
    inherit fetchurl stdenv makeWrapper python pycrypto twisted;
    wxPython = wxPython26;
    gui = true;
  };

  bittornado = import ../tools/networking/p2p/bit-tornado {
    inherit fetchurl stdenv python wxPython26;
  };

  bmrsa = builderDefsPackage (selectVersion ../tools/security/bmrsa "11") {
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

  ccrypt = import ../tools/security/ccrypt {
    inherit fetchurl stdenv;
  };

  cdecl = import ../development/tools/cdecl {
    inherit fetchurl stdenv yacc flex readline;
  };

  cdrdao = import ../tools/cd-dvd/cdrdao {
    inherit fetchurl stdenv;
  };

  cdrkit = import ../tools/cd-dvd/cdrkit {
    inherit fetchurl stdenv cmake libcap zlib bzip2;
  };

  checkinstall = import ../tools/package-management/checkinstall {
    inherit fetchurl stdenv gettext;
  };

  cheetahTemplate = builderDefsPackage (selectVersion ../tools/text/cheetah-template "2.0.1") {
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

  coreutils = useFromStdenv "coreutils"
    (makeOverridable (if stdenv ? isDietLibC
      then import ../tools/misc/coreutils-5
      else import ../tools/misc/coreutils)
    {
      inherit fetchurl stdenv acl;
      aclSupport = stdenv.isLinux;
    });

  cpio = import ../tools/archivers/cpio {
    inherit fetchurl stdenv;
  };

  cromfs = import ../tools/archivers/cromfs {
    inherit fetchurl stdenv pkgconfig fuse perl;
  };

  cron = import ../tools/system/cron { # see also fcron
    inherit fetchurl stdenv;
  };

  curl = import ../tools/networking/curl {
    fetchurl = fetchurlBoot;
    inherit stdenv zlib openssl;
    zlibSupport = ! ((stdenv ? isDietLibC) || (stdenv ? isStatic));
    sslSupport = ! ((stdenv ? isDietLibC) || (stdenv ? isStatic));
  };

  curlftpfs = import ../tools/networking/curlftpfs {
    inherit fetchurl stdenv fuse curl pkgconfig zlib;
    inherit (gtkLibs) glib;
  };

  dar = import ../tools/archivers/dar {
    inherit fetchurl stdenv zlib bzip2 openssl;
  };

  ddrescue = builderDefsPackage (selectVersion ../tools/system/ddrescue "1.8") {};

  dev86 = import ../development/compilers/dev86 {
    inherit fetchurl stdenv;
  };

  dnsmasq = import ../tools/networking/dnsmasq {
    # TODO i18n can be installed as well, implement it?
    inherit fetchurl stdenv;
  };

  dhcp = import ../tools/networking/dhcp {
    inherit fetchurl stdenv groff nettools coreutils iputils gnused
            bash makeWrapper;
  };

  diffstat = import ../tools/text/diffstat {
    inherit fetchurl stdenv;
  };

  diffutils = useFromStdenv "diffutils"
    (import ../tools/text/diffutils {
      inherit fetchurl stdenv coreutils;
    });

  docbook2x = import ../tools/typesetting/docbook2x {
    inherit fetchurl stdenv texinfo perl
            perlXMLSAX perlXMLParser perlXMLNamespaceSupport
            gnused groff libxml2 libxslt makeWrapper;
  };

  dosfstools = composedArgsAndFun (import ../tools/misc/dosfstools) {
    inherit builderDefs;
  };

  dvdplusrwtools = import ../tools/cd-dvd/dvd+rw-tools {
    inherit fetchurl stdenv cdrkit m4;
  };

  eieio = import ../applications/editors/emacs-modes/eieio {
    inherit fetchurl stdenv emacs;
  };

  enscript = import ../tools/text/enscript {
    inherit fetchurl stdenv;
  };

  eprover = composedArgsAndFun (import ../tools/misc/eProver) {
    inherit fetchurl stdenv which;
    texLive = texLiveAggregationFun {
      paths = [
        texLive texLiveExtra
      ];
    };
  };

  exif = import ../tools/graphics/exif {
    inherit fetchurl stdenv pkgconfig libexif popt;
  };

  expect = import ../tools/misc/expect {
    inherit fetchurl stdenv tcl;
  };

  fcron = import ../tools/system/fcron { # see also cron
    inherit fetchurl stdenv perl;
  };

  file = import ../tools/misc/file {
    inherit fetchurl stdenv;
  };

  filelight = import ../tools/system/filelight {
    inherit fetchurl stdenv kdelibs x11 zlib perl libpng;
    qt = qt3;
  };

  findutils = useFromStdenv "findutils"
    (if system == "i686-darwin" then findutils4227 else
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

  gawk = useFromStdenv "gawk"
    (import ../tools/text/gawk {
      inherit fetchurl stdenv;
    });

  gdmap = composedArgsAndFun (selectVersion ../tools/system/gdmap "0.8.1") {
    inherit stdenv fetchurl builderDefs pkgconfig libxml2 intltool
      gettext;
    inherit (gtkLibs) gtk;
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

  glxinfo = assert mesaSupported; import ../tools/graphics/glxinfo {
    inherit fetchurl stdenv x11 mesa;
  };

  gnugrep = useFromStdenv "gnugrep"
    (import ../tools/text/gnugrep {
      inherit fetchurl stdenv pcre;
    });

  gnupatch = useFromStdenv "patch" (import ../tools/text/gnupatch {
    inherit fetchurl stdenv;
  });

  gnupg = import ../tools/security/gnupg {
    inherit fetchurl stdenv readline;
    ideaSupport = getPkgConfig "gnupg" "idea" false; # enable for IDEA crypto support
  };

  gnupg2 = import ../tools/security/gnupg2 {
    inherit fetchurl stdenv readline libgpgerror libgcrypt libassuan pth libksba zlib;
    openldap = if getPkgConfig "gnupg" "ldap" true then openldap else null;
    bzip2 = if getPkgConfig "gnupg" "bzip2" true then bzip2 else null;
    libusb = if getPkgConfig "gnupg" "usb" true then libusb else null;
    curl = if getPkgConfig "gnupg" "curl" true then curl else null;
  };

  gnuplot = import ../tools/graphics/gnuplot {
    inherit fetchurl stdenv zlib gd texinfo;
  };

  gnuplotX = import ../tools/graphics/gnuplot {
    inherit fetchurl stdenv zlib gd texinfo;
    inherit (xlibs) libX11 libXt libXaw libXpm;
    x11Support = true;
  };

  gnused = useFromStdenv "gnused"
    (import ../tools/text/gnused {
      inherit fetchurl stdenv;
    });

  gnutar = useFromStdenv "gnutar"
    (import ../tools/archivers/gnutar {
      inherit fetchurl stdenv;
    });

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
  };

  gssdp = import ../development/libraries/gssdp {
    inherit fetchurl stdenv pkgconfig libxml2;
    inherit (gtkLibs) glib;
    inherit (gnome) libsoup;
  };

  gtkgnutella = import ../tools/networking/p2p/gtk-gnutella {
    inherit fetchurl stdenv pkgconfig libxml2;
    inherit (gtkLibs) glib gtk;
  };

  gupnp = import ../development/libraries/gupnp {
    inherit fetchurl stdenv pkgconfig libxml2 gssdp e2fsprogs;
    inherit (gtkLibs) glib;
    inherit (gnome) libsoup;
  };

  gupnptools = import ../tools/networking/gupnp-tools {
    inherit fetchurl stdenv gssdp gupnp pkgconfig libxml2 e2fsprogs;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libsoup libglade gnomeicontheme;
  };

  gzip = useFromStdenv "gzip"
    (import ../tools/compression/gzip {
      inherit fetchurl stdenv;
    });

  hddtemp = import ../tools/misc/hddtemp {
    inherit fetchurl stdenv;
  };

  hevea = import ../tools/typesetting/hevea {
    inherit fetchurl stdenv ocaml;
  };

  highlight = builderDefsPackage (selectVersion ../tools/text/highlight "2.6.10") {
    inherit getopt;
  };

  host = import ../tools/networking/host {
    inherit fetchurl stdenv;
  };

  /*
  hyppocampusFun = lib.sumArgs ( selectVersion ../tools/misc/hyppocampus "0.3rc1") {
    inherit builderDefs stdenv fetchurl libdbi libdbiDrivers fuse
      pkgconfig perl gettext dbus dbus_glib pcre libscd bison;
    inherit (gtkLibs) glib;
    flex = flex2533;
  };
  */

  iasl = import ../development/compilers/iasl {
    inherit fetchurl stdenv bison flex;
  };

  idutils = import ../tools/misc/idutils {
    inherit fetchurl stdenv emacs;
  };

  inetutils = import ../tools/networking/inetutils {
    inherit fetchurl stdenv;
  };

  iodine = import ../tools/networking/iodine {
    inherit stdenv fetchurl zlib nettools;
  };

  jdiskreport = import ../tools/misc/jdiskreport {
    inherit fetchurl stdenv unzip jdk;
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
    inherit fetchurl stdenv libpcap ncurses expat;
  };

  ktorrent = import ../tools/networking/p2p/ktorrent {
    inherit fetchurl stdenv pkgconfig kdelibs
      xlibs zlib libpng libjpeg perl gmp;
  };

  less = import ../tools/misc/less {
    inherit fetchurl stdenv ncurses;
  };

  lftp = import ../tools/networking/lftp {
    inherit fetchurl stdenv readline;
  };

  lhs2tex = import ../tools/typesetting/lhs2tex {
    inherit fetchurl stdenv ghc tetex polytable;
  };

  libtorrent = import ../tools/networking/p2p/libtorrent {
    inherit fetchurl stdenv pkgconfig openssl libsigcxx;
  };

  lout = import ../tools/typesetting/lout {
    inherit fetchurl stdenv ghostscript;
  };

  lzma = import ../tools/compression/lzma {
    inherit fetchurl stdenv;
  };

  lsh = import ../tools/networking/lsh {
    inherit stdenv fetchurl gperf guile gmp zlib liboop gnum4 pam;
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
    inherit fetchurl stdenv pkgconfig ncurses shebangfix perl zip;
    inherit (gtkLibs) glib;
    inherit (xlibs) libX11;
  };

  mcabber = import ../applications/networking/instant-messengers/mcabber {
    inherit fetchurl stdenv openssl ncurses pkgconfig;
    inherit (gtkLibs) glib;
  };

  mdbtools = builderDefsPackage (selectVersion ../tools/misc/mdbtools "0.6-pre1") {
    inherit readline pkgconfig bison;
    inherit (gtkLibs) glib;
    flex = flex2535;
  };

  mjpegtools = import ../tools/video/mjpegtools {
    inherit fetchurl stdenv libjpeg;
    inherit (xlibs) libX11;
  };

  mktemp = import ../tools/security/mktemp {
    inherit fetchurl stdenv;
  };

  mldonkey = import ../applications/networking/p2p/mldonkey {
    inherit fetchurl stdenv ocaml zlib ncurses;
  };

  mpage = import ../tools/text/mpage {
    inherit fetchurl stdenv;
  };

  msf = builderDefsPackage (selectVersion ../tools/security/metasploit "3.1") {
    inherit ruby makeWrapper;
  };

  mssys = import ../tools/misc/mssys {
    inherit fetchurl stdenv gettext;
  };

  mysql2pgsql = import ../tools/misc/mysql2pgsql {
    inherit fetchurl stdenv perl shebangfix;
  };

  namazu = import ../tools/text/namazu {
    inherit fetchurl stdenv perl;
  };

  nc6 = composedArgsAndFun (selectVersion ../tools/networking/nc6 "1.0") {
    inherit builderDefs;
  };

  ncat = import ../tools/networking/ncat {
    inherit fetchurl stdenv openssl;
  };

  netcat = import ../tools/networking/netcat {
    inherit fetchurl stdenv;
  };

  netselect = import ../tools/networking/netselect {
    inherit fetchurl stdenv;
  };

  nmap = import ../tools/security/nmap {
    inherit fetchurl stdenv libpcap pkgconfig openssl
      python pygtk makeWrapper pygobject pycairo
      pysqlite;
    inherit (xlibs) libX11;
    inherit (gtkLibs) gtk;
  };

  ntp = import ../tools/networking/ntp {
    inherit fetchurl stdenv libcap;
  };

  nssmdns = import ../tools/networking/nss-mdns {
    inherit fetchurl stdenv avahi;
  };

  openssh = import ../tools/networking/openssh {
    inherit fetchurl stdenv zlib openssl pam perl;
    pamSupport = getPkgConfig "openssh" "pam" true;
  };

  p7zip = import ../tools/archivers/p7zip {
    inherit fetchurl stdenv;
  };

  par2cmdline = import ../tools/networking/par2cmdline {
    inherit fetchurl stdenv;
  };

  patchutils = import ../tools/text/patchutils {
    inherit fetchurl stdenv;
  };

  parted = import ../tools/misc/parted {
    inherit fetchurl stdenv e2fsprogs readline;
  };

  patch = gnupatch;

  pciutils = import ../tools/system/pciutils {
    inherit fetchurl stdenv zlib;
  };

  pdfjam = import ../tools/typesetting/pdfjam {
    inherit fetchurl stdenv;
  };

  pdsh = import ../tools/networking/pdsh {
    inherit fetchurl stdenv perl;
    readline = if getPkgConfig "pdsh" "readline" true then readline else null;
    ssh = if getPkgConfig "pdsh" "ssh" true then openssh else null;
    pam = if getPkgConfig "pdsh" "pam" true then pam else null;
  };

  pinentry = import ../tools/misc/pinentry {
    inherit fetchurl stdenv pkgconfig ncurses;
    inherit (gnome) glib gtk;
  };

  ploticus = import ../tools/graphics/ploticus {
    inherit fetchurl stdenv zlib libpng;
    inherit (xlibs) libX11;
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

  pwgen = import ../tools/security/pwgen {
    inherit stdenv fetchurl;
  };

  pystringtemplate = import ../tools/text/py-string-template {
    inherit stdenv fetchurl python;
    /* TODO: Some parts of this package depend on the ANTLR run-time library
     *       for Python. We have a package for ANTLR3, too, but that one is
     *       rather big and contains much more than we need. I guess this issue
     *       calls for some clever refactoring.
     */
  };

  qtparted = import ../tools/misc/qtparted {
    inherit fetchurl stdenv e2fsprogs ncurses readline parted zlib qt3;
    inherit (xlibs) libX11 libXext;
  };

  relfs = composedArgsAndFun (selectVersion ../tools/misc/relfs "cvs.2008.03.05") {
    inherit fetchcvs stdenv ocaml postgresql fuse pcre
      builderDefs e2fsprogs pkgconfig;
    inherit (gnome) gnomevfs GConf;
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

  rlwrap = composedArgsAndFun (selectVersion ../tools/misc/rlwrap "0.28") {
    inherit builderDefs readline;
  };

  rpPPPoE = builderDefsPackage (import ../tools/networking/rp-pppoe) {
    inherit ppp;
  };

  rpm = import ../tools/package-management/rpm {
    inherit fetchurl stdenv cpio zlib bzip2 file sqlite beecrypt neon elfutils;
  };

  rtorrent = import ../tools/networking/p2p/rtorrent {
    inherit fetchurl stdenv libtorrent ncurses pkgconfig libsigcxx curl zlib openssl;
  };

  rxp = import ../tools/text/xml/rxp {
    inherit fetchurl stdenv;
  };

  sablotron = import ../tools/text/xml/sablotron {
    inherit fetchurl stdenv expat;
  };

  screen = import ../tools/misc/screen {
    inherit fetchurl stdenv ncurses;
  };

  seccure = composedArgsAndFun (selectVersion ../tools/security/seccure "0.3") {
    inherit builderDefs libgcrypt;
  };

  # seccure will override it (it is root-only, but
  # more secure because of memory locking), but this
  # can be added to default system
  seccureUser = lowPrio (seccure.passthru.function {
    makeFlags = [" CFLAGS+=-DNOMEMLOCK "];
  });

  semantic = import ../applications/editors/emacs-modes/semantic {
    inherit fetchurl stdenv emacs eieio;
  };

  sharutils = selectVersion ../tools/archivers/sharutils "4.6.3" {
    inherit fetchurl stdenv;
  };

  shebangfix = import ../tools/misc/shebangfix {
    inherit stdenv perl;
  };

  slsnif = import ../tools/misc/slsnif {
    inherit fetchurl stdenv;
  };

  smartmontools = import ../tools/system/smartmontools {
    inherit fetchurl stdenv;
  };

  smbfsFuse = composedArgsAndFun (selectVersion ../tools/networking/smbfs-fuse "0.8.7") {
    inherit builderDefs samba fuse;
  };

  socat = builderDefsPackage (selectVersion ../tools/networking/socat "1.6.0.1") {
    inherit openssl;
  };

  sudo = import ../tools/security/sudo {
    inherit fetchurl stdenv coreutils pam;
  };

  superkaramba = import ../desktops/superkaramba {
    inherit stdenv fetchurl kdebase kdelibs zlib libjpeg
      perl qt3 python libpng freetype expat;
    inherit (xlibs) libX11 libXext libXt libXaw libXpm;
  };

  sshfsFuse = import ../tools/networking/sshfs-fuse {
    inherit fetchurl stdenv pkgconfig fuse;
    inherit (gtkLibs) glib;
  };

  ssmtp = import ../tools/networking/ssmtp {
    inherit fetchurl stdenv openssl;
    tlsSupport = true;
  };

  ssss = composedArgsAndFun (selectVersion ../tools/security/ssss "0.5") {
    inherit builderDefs gmp;
  };

  su = import ../tools/misc/su {
    inherit fetchurl stdenv pam;
  };

  tcpdump = import ../tools/networking/tcpdump {
    inherit fetchurl stdenv libpcap;
  };

  telnet = import ../tools/networking/telnet {
    inherit fetchurl stdenv ncurses;
  };

  vpnc = import ../tools/networking/vpnc {
    inherit fetchurl stdenv libgcrypt perl gawk
      nettools makeWrapper;
  };

  testdisk = import ../tools/misc/testdisk {
    inherit fetchurl stdenv ncurses libjpeg e2fsprogs zlib openssl;
  };

  tightvnc = import ../tools/admin/tightvnc {
    inherit fetchurl stdenv x11 zlib libjpeg perl;
    inherit (xlibs) imake gccmakedep libXmu libXaw libXpm libXp xauth;
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

  ts = import ../tools/system/ts {
    inherit fetchurl stdenv;
  };

  transfig = import ../tools/graphics/transfig {
    inherit fetchurl stdenv libpng libjpeg zlib;
    inherit (xlibs) imake;
  };

  truecrypt = import ../applications/misc/truecrypt {
    inherit fetchurl stdenv pkgconfig fuse devicemapper;
    wxGTK = wxGTK28;
  };

  ttmkfdir = import ../tools/misc/ttmkfdir {
    inherit debPackage freetype fontconfig libunwind libtool bison;
    flex = flex2534;
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

  unzip = import ../tools/archivers/unzip {
    inherit fetchurl stdenv;
  };

  wdfs = import ../tools/networking/wdfs {
    inherit stdenv fetchurl neon fuse pkgconfig;
    inherit (gtkLibs) glib;
  };

  wget = import ../tools/networking/wget {
    inherit fetchurl stdenv gettext;
  };

  which = import ../tools/system/which {
    inherit fetchurl stdenv readline;
  };

  wv = import ../tools/misc/wv {
    inherit fetchurl stdenv libpng zlib imagemagick
      pkgconfig libgsf libxml2 bzip2;
    inherit (gtkLibs) glib;
  };

  x11_ssh_askpass = import ../tools/networking/x11-ssh-askpass {
    inherit fetchurl stdenv x11;
    inherit (xorg) imake;
  };

  xclip = import ../tools/misc/xclip {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXmu;
  };

  xmlroff = import ../tools/typesetting/xmlroff {
    inherit fetchurl stdenv pkgconfig libxml2 libxslt popt;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) libgnomeprint;
    inherit pangoxsl;
  };

  xmlto = import ../tools/typesetting/xmlto {
    inherit fetchurl stdenv flex libxml2 libxslt
            docbook_xml_dtd_42 docbook_xsl w3m
            glibc bash getopt mktemp findutils makeWrapper;
  };

  xmltv = import ../tools/misc/xmltv {
    inherit fetchurl perl perlTermReadKey perlXMLTwig perlXMLWriter
      perlDateManip perlHTMLTree perlHTMLParser perlHTMLTagset
      perlURI perlLWP;
  };

  xpf = import ../tools/text/xml/xpf {
    inherit fetchurl stdenv python;

    libxml2 = import ../development/libraries/libxml2 {
      inherit fetchurl stdenv zlib python;
      pythonSupport = true;
    };
  };

  xsel = import ../tools/misc/xsel {
    inherit fetchurl stdenv x11;
  };

  zdelta = import ../tools/compression/zdelta {
    inherit fetchurl stdenv;
  };

  zip = import ../tools/archivers/zip {
    inherit fetchurl stdenv;
  };


  ### SHELLS


  bash = lowPrio (useFromStdenv "bash"
    (import ../shells/bash {
      inherit fetchurl stdenv readline;
    }));

  bashInteractive = appendToName "interactive" (import ../shells/bash {
    inherit fetchurl stdenv readline;
    interactive = true;
  });

  tcsh = import ../shells/tcsh {
    inherit fetchurl stdenv ncurses;
  };

  zsh = composedArgsAndFun (selectVersion ../shells/zsh "4.3.9") {
    inherit fetchurl stdenv ncurses coreutils;
    # for CVS:
    inherit (bleedingEdgeRepos) sourceByName;
    inherit autoconf yodl;
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

  dylan = import ../development/compilers/gwydion-dylan {
    inherit fetchurl stdenv perl boehmgc yacc flex readline;
    dylan =
      import ../development/compilers/gwydion-dylan/binary.nix {
        inherit fetchurl stdenv;
      };
  };

  # Essential Haskell Compiler -- nix expression is work in progress
  ehc = import ../development/compilers/ehc {
    inherit fetchsvn stdenv coreutils m4 libtool ghc uulib uuagc llvm;
  };

  fpc = import ../development/compilers/fpc {
    inherit fetchurl stdenv gawk system;
  };

  g77 = import ../build-support/gcc-wrapper {
    name = "g77";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-3.3 {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };

  g77_40 = import ../build-support/gcc-wrapper {
    name = "g77-4.0";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.0 {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
      inherit gmp mpfr;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };

  g77_41 = import ../build-support/gcc-wrapper {
    name = "g77-4.1";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.1 {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
      langC = false;
      inherit gmp mpfr;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };

  g77_42 = import ../build-support/gcc-wrapper {
    name = "g77-4.2";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.2/fortran.nix {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
      langC = false;
      inherit gmp mpfr;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };

  gfortran = import ../build-support/gcc-wrapper {
    name = "gfortran";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.2/fortran.nix {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
      langC = false;
      inherit gmp mpfr;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };

  gcc = gcc43;

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

  gcc40 = wrapGCC (import ../development/compilers/gcc-4.0 {
    inherit fetchurl stdenv noSysDirs;
    texinfo = texinfo49;
    profiledCompiler = true;
  });

  gcc41 = wrapGCC (import ../development/compilers/gcc-4.1 {
    inherit fetchurl stdenv noSysDirs;
    texinfo = texinfo49;
    profiledCompiler = false;
  });

  gcc42 = wrapGCC (import ../development/compilers/gcc-4.2 {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = false;
  });

  gcc43 = useFromStdenv "gcc" (wrapGCC (import ../development/compilers/gcc-4.3 {
    inherit fetchurl stdenv texinfo gmp mpfr noSysDirs;
    profiledCompiler = true;
  }));

  gcc43multi = lowPrio (wrapGCCWith (import ../build-support/gcc-wrapper) glibc_multi (import ../development/compilers/gcc-4.3 {
    stdenv = overrideGCC stdenv (wrapGCCWith (import ../build-support/gcc-wrapper) glibc_multi gcc42);
    inherit fetchurl texinfo gmp mpfr noSysDirs;
    profiledCompiler = false;
    enableMultilib = true;
  }));

  gccApple = wrapGCC (import ../development/compilers/gcc-apple {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = true;
  });

  gccupc40 = wrapGCCUPC (import ../development/compilers/gcc-upc-4.0 {
    inherit fetchurl stdenv bison autoconf gnum4 noSysDirs;
    texinfo = texinfo49;
  });

  # This new ghc stuff is under heavy development and will change !
  # ===============================================================

  # usage: see ghcPkgUtil.sh
  # depreceated -> use functions defined in builderDefs
  ghcPkgUtil = runCommand "ghcPkgUtil-internal"
     { ghcPkgUtil = ../development/libraries/haskell/generic/ghcPkgUtil.sh; }
     "mkdir -p $out/nix-support; cp $ghcPkgUtil \$out/nix-support/setup-hook;";

  ghcsAndLibs =
    assert builtins ? listToAttrs;
    recurseIntoAttrs (import ../development/compilers/ghcs {
      inherit ghcboot fetchurl stdenv recurseIntoAttrs perl gnum4 gmp readline lib;
      inherit ghcPkgUtil ctags autoconf automake getConfig;
      inherit (ghc68executables) hasktags;
      inherit (bleedingEdgeRepos) sourceByName;

      # needed for install darcs ghc version
      happy = ghc68executables.happy;
      alex = ghc68executables.alex;
    });

  # creates ghc-X-wl wich adds the passed libraries to the env var GHC_PACKAGE_PATH
  ghcWrapper = { ghcPackagedLibs ? false, ghc, libraries, name, suffix ? "ghc_wrapper_${ghc.name}" } :
        import ../development/compilers/ghc/ghc-wrapper {
    inherit ghcPackagedLibs ghc name suffix libraries ghcPkgUtil
      lib
      readline ncurses stdenv;
    inherit (sourceAndTags) sourceWithTagsDerivation annotatedWithSourceAndTagInfo sourceWithTagsFromDerivation;
    #inherit stdenv ghcPackagedLibs ghc name suffix libraries ghcPkgUtil
    #  annotatedDerivations lib sourceWithTagsDerivation annotatedWithSourceAndTagInfo;
    installSourceAndTags = getConfig ["haskell" "ghcWrapper" "installSourceAndTags"] false;
  };


  # args must contain src name buildInputs
  # classic expression style.. seems to work fine
  # used now
  #
  # args must contain: src name buildInputs propagatedBuildInputs
  # classic expression style.. seems to work fine
  # used now
  # srcDir contains source directory (containing the .cabal file)
  # TODO: set --bindir=/usr/local or such (executables are installed to
  # /usr/local/bin which is not added to path when building other packages
  # hsp needs trhsx from hsx
  # TODO add eval "$preBuild" phase
  ghcCabalDerivation = args : with args;
    let buildInputs =  (if (args ? buildInputs) then args.buildInputs else [])
                    ++ [ ghcPkgUtil ] ++ ( if args ? pass && args.pass ? buildInputs then args.pass.buildInputs else []);
        configure = if (args ? useLocalPkgDB)
                      then "nix_ghc_pkg_tool join localDb\n" +
                            "\$CABAL_SETUP configure --package-db=localDb \$profiling \$cabalFlags"
                      else "\$CABAL_SETUP configure --by-env=\$PACKAGE_DB \$profiling \$cabalFlags";
    in stdenv.mkDerivation ({
      srcDir = if (args ? srcDir) then args.srcDir else ".";
      inherit (args) name src propagatedBuildInputs;
      phases = "unpackPhase patchPhase buildPhase";
      profiling = if getConfig [ "ghc68" "profiling" ] false then "-p" else "";
      cabalFlags = map lib.escapeShellArg
                      (getConfig [ "cabal" "flags" ] []
                       ++ (if args ? cabalFlags then args.cabalFlags else []) );
      # TODO remove echo line
      buildPhase ="
          createEmptyPackageDatabaseAndSetupHook
          export GHC_PACKAGE_PATH

          cd \$srcDir
          ghc --make Setup.*hs -o setup
          CABAL_SETUP=./setup

          " + configure +"
          \$CABAL_SETUP build
          \$CABAL_SETUP copy --destdir=\$out
          \$CABAL_SETUP register --gen-script
          sed -e \"s=/usr/local/lib=\$out/usr/local/lib=g\" \\
              -e \"s#bin/ghc-pkg --package-conf.*#bin/ghc-pkg --package-conf=\$PACKAGE_DB register -#\" \\
              -i register.sh
          ./register.sh
          rm \${PACKAGE_DB}.old

         ensureDir \"\$out/nix-support\"

         echo \"\$propagatedBuildInputs\" > \"\$out/nix-support/propagated-build-inputs\"
      ";
  } // ( if args ? pass then (args.pass) else {} ) // { inherit buildInputs; } );


  ghcCabalExecutableFun = (import ../development/compilers/ghc/ghc-wrapper/ghc-cabal-executable-fun.nix){
    inherit ghc68extraLibs ghcsAndLibs stdenv lib;
    # extra packages from this top level file:
    inherit perl;
  };

  # this may change in the future
  ghc68extraLibs = (import ../misc/ghc68extraLibs ) {
    # lib like stuff
    inherit (sourceAndTags) addHasktagsTaggingInfo;
    inherit bleedingEdgeRepos fetchurl lib ghcCabalDerivation pkgconfig unzip zlib;
    # used (non haskell) libraries (ffi etc)
    inherit postgresql mysql sqlite gtkLibs gnome xlibs freetype getConfig libpng bzip2 pcre;

    executables = ghc68executables;
    wxGTK = wxGTK26;
  };


  # Executables compiled by this ghc68 - I'm too lazy to add them all as additional file in here
  ghc68executables = recurseIntoAttrs (import ../misc/ghc68executables {
    inherit ghcCabalExecutableFun fetchurl lib bleedingEdgeRepos autoconf zlib getConfig;
    inherit X11;
    inherit (xlibs) xmessage;
    inherit pkgs; # passing pkgs to add the possibility for the user to add his own executables. pkgs is passed.
  });

  # the wrappers basically does one thing: It defines GHC_PACKAGE_PATH before calling ghc{i,-pkg}
  # So you can have different wrappers with different library combinations
  # So installing ghc libraries isn't done by nix-env -i package but by adding
  # the lib to the libraries list below
  # Doesn't create that much useless symlinks (you seldomly want to read the
  # .hi and .o files, right?
  ghcLibraryWrapper68 =
    let ghc = ghcsAndLibs.ghc68.ghc; in
    ghcWrapper rec {
      ghcPackagedLibs = true;
      name = "ghc${ghc.version}_wrapper";
      suffix = "${ghc.version}wrapper";
      libraries =
        # core_libs  distributed with this ghc version
        (lib.flattenAttrs ghcsAndLibs.ghc68.core_libs)
        # (map ( a : __getAttr a ghcsAndLibs.ghc68.core_libs ) [ "cabal" "mtl" "base"  ]

        # some extra libs
           ++  (lib.flattenAttrs (ghc68extraLibs ghcsAndLibs.ghc68) );
        # ++ map ( a : __getAttr a (ghc68extraLibs ghcsAndLibs.ghc68 ) ) [ "mtl" "parsec" ... ]
      inherit ghc;
  };

  # ghc66boot = import ../development/compilers/ghc-6.6-boot {
  #  inherit fetchurl stdenv perl readline;
  #  m4 = gnum4;
  #};

  ghc = ghc683;

  ghc682 = import ../development/compilers/ghc-6.8/ghc-6.8.2.nix {
    inherit fetchurl stdenv readline perl gmp ncurses m4;
    ghc = ghcboot;
  };

  ghc683 = import ../development/compilers/ghc-6.8/ghc-6.8.3.nix {
    inherit fetchurl stdenv readline perl gmp ncurses m4;
    ghc = ghcboot;
    haddock = haddockboot;
  };

  ghc69snapshot = lowPrio (import ../development/compilers/ghc-6.8/head.nix {
    inherit fetchurl stdenv readline perl gmp ncurses m4 happy alex haskellEditline;
    ghc = ghc683;
  });

  ghc661 = import ../development/compilers/ghc-6.6.1 {
    inherit fetchurl stdenv readline perl58 gmp ncurses m4;
    ghc = ghcboot;
  };

  ghc66 = import ../development/compilers/ghc-6.6 {
    inherit fetchurl stdenv readline perl gmp ncurses m4;
    ghc = ghcboot;
  };

  ghc64 = import ../development/compilers/ghc {
    inherit fetchurl stdenv perl ncurses readline m4 gmp;
    gcc = stdenv.gcc;
    ghc = ghcboot;
  };

  ghcboot = lowPrio (appendToName "boot" (import ../development/compilers/ghc/boot.nix {
    inherit fetchurl stdenv ncurses gmp;
    readline = if stdenv.system == "i686-linux" then readline4 else readline;
    perl = perl58;
  }));

  ghcboot610 = lowPrio (appendToName "boot" (import ../development/compilers/ghc/boot610.nix {
    inherit fetchurl stdenv ncurses gmp editline makeWrapper;
    # readline = if stdenv.system == "i686-linux" then readline4 else readline;
    perl = perl58;
  }));
  /*
  ghcWrapper = assert uulib.ghc == ghc;
    import ../development/compilers/ghc-wrapper {
      inherit stdenv ghc;
      libraries = [];
    };
  */

  gwt = import ../development/compilers/gwt {
    inherit stdenv fetchurl;
    inherit (gtkLibs) glib gtk pango atk;
    inherit (xlibs) libX11 libXt;
    libstdcpp5 = gcc33.gcc;
  };

  helium = import ../development/compilers/helium {
    inherit fetchurl stdenv ghc;
  };

  ikarus = builderDefsPackage (selectVersion ../development/compilers/ikarus "0.0.3") {
    inherit gmp;
  };

  javafront = import ../development/compilers/java-front {
    inherit stdenv fetchurl pkgconfig;
    sdf = sdf24;
    aterm = aterm25;
    strategoxt = strategoxt017;
  };

  #TODO add packages http://cvs.haskell.org/Hugs/downloads/2006-09/packages/ and test
  # commented out because it's using the new configuration style proposal which is unstable
  hugs = import ../development/compilers/hugs {
    inherit lib fetchurl stdenv composableDerivation;
  };

  j2sdk14x =
    assert system == "i686-linux";
    import ../development/compilers/jdk/default-1.4.nix {
      inherit fetchurl stdenv;
    };

  jdk5 =
    assert system == "i686-linux" || system == "x86_64-linux";
    import ../development/compilers/jdk/default-5.nix {
      inherit fetchurl stdenv unzip;
    };

  jdk       = jdkdistro true  false;
  jre       = jdkdistro false false;

  jdkPlugin = jdkdistro true true;
  jrePlugin = jdkdistro false true;

  supportsJDK =
    system == "i686-linux" ||
    system == "x86_64-linux" ||
    system == "powerpc-linux";

  jdkdistro = installjdk: pluginSupport:
    assert supportsJDK;
    (if pluginSupport then appendToName "plugin" else x: x) (import ../development/compilers/jdk {
      inherit fetchurl stdenv unzip installjdk xlibs pluginSupport makeWrapper;
    });

  jikes = import ../development/compilers/jikes {
    inherit fetchurl stdenv;
  };

  lazarus = builderDefsPackage (import ../development/compilers/fpc/lazarus.nix) {
    inherit fpc makeWrapper;
    inherit (gtkLibs1x) gtk glib gdkpixbuf;
    inherit (xlibs) libXi inputproto libX11 xproto libXext xextproto;
  };

  llvm = import ../development/compilers/llvm {
    inherit fetchurl stdenv gcc flex perl libtool;
  };

  llvmGCC = builderDefsPackage (import ../development/compilers/llvm/llvm-gcc.nix) {
    flex=flex2535;
    inherit llvm perl libtool bison;
  };

  mono = import ../development/compilers/mono {
    inherit fetchurl stdenv bison pkgconfig;
    inherit (gtkLibs) glib;
  };

  monoDLLFixer = import ../build-support/mono-dll-fixer {
    inherit stdenv perl;
  };

  monotone = import ../applications/version-management/monotone {
    inherit stdenv fetchurl boost zlib;
  };

  monotoneViz = builderDefsPackage (selectVersion ../applications/version-management/monotone-viz "1.0.1") {
    inherit ocaml lablgtk graphviz pkgconfig;
    inherit (gnome) gtk libgnomecanvas glib;
  };

  viewMtn = builderDefsPackage (selectVersion ../applications/version-management/viewmtn "0.10")
  {
    inherit monotone flup cheetahTemplate highlight ctags
      makeWrapper graphviz which python;
  };

  nasm = import ../development/compilers/nasm {
    inherit fetchurl stdenv;
  };

  ocaml = getVersion  "ocaml" ocaml_alts;

  ocaml_alts = import ../development/compilers/ocaml {
    inherit fetchurl stdenv x11 ncurses;
  };

  /*
  gcj = import ../build-support/gcc-wrapper/default2.nix {
    name = "gcj";
    nativeTools = false;
    nativeLibc = false;
    gcc = import ../development/compilers/gcc-4.0 {
      inherit fetchurl stdenv noSysDirs;
      langJava = true;
      langCC   = false;
      langC    = false;
      langF77  = false;
    };
    inherit (stdenv.gcc) binutils libc;
    inherit stdenv;
  };
  */

  opencxx = import ../development/compilers/opencxx {
    inherit fetchurl stdenv libtool;
    gcc = gcc33;
  };

  qcmm = import ../development/compilers/qcmm {
    lua   = lua4;
    ocaml = builtins.getAttr "3.08.0" ocaml_alts;
    inherit fetchurl stdenv mk noweb groff;
  };

  roadsend = import ../development/compilers/roadsend {
    inherit fetchurl stdenv flex bison bigloo lib curl composableDerivation;
    # optional features
    # all features pcre, fcgi xml mysql, sqlite3, (not implemented: odbc gtk gtk2)
    flags = ["pcre" "xml" "mysql"];
    inherit mysql libxml2 fcgi;
  };

  scala = import ../development/compilers/scala {
    inherit stdenv fetchurl;
  };

  stalin = import ../development/compilers/stalin {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11;
  };

  strategoLibraries = import ../development/compilers/strategoxt/libraries/stratego-libraries-0.17pre.nix {
    inherit stdenv fetchurl pkgconfig aterm;
  };

  strategoxt = import ../development/compilers/strategoxt {
    inherit fetchurl pkgconfig sdf aterm;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strategoxt017 = import ../development/compilers/strategoxt/strategoxt-0.17.nix {
    inherit fetchurl pkgconfig;
    sdf = sdf24;
    aterm = aterm25;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strategoxtUtils = import ../development/compilers/strategoxt/utils {
    inherit fetchurl pkgconfig stdenv aterm sdf strategoxt;
  };

  swiProlog = composedArgsAndFun (selectVersion ../development/compilers/swi-prolog "5.6.51") {
    inherit fetchurl stdenv;
  };

  tinycc = import ../development/compilers/tinycc {
    inherit fetchurl stdenv perl texinfo;
  };

  transformers = import ../development/compilers/transformers {
    inherit fetchurl pkgconfig sdf stlport aterm;

    stdenv = overrideGCC (overrideInStdenv stdenv [gnumake380]) gcc34;

    strategoxt = import ../development/compilers/strategoxt/strategoxt-0.14.nix {
      inherit fetchurl pkgconfig sdf aterm;
      stdenv = overrideGCC (overrideInStdenv stdenv [gnumake380]) gcc34;
    };
  };

  visualcpp = import ../development/compilers/visual-c++ {
    inherit fetchurl stdenv cabextract;
  };

  webdsl = import ../development/compilers/webdsl {
    inherit stdenv fetchurl pkgconfig javafront;
    aterm = aterm25;
    sdf = sdf24;
    strategoxt = strategoxt017;
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
    inherit stdenv binutils;
  };

  wrapGCC = wrapGCCWith (import ../build-support/gcc-wrapper) glibc;

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


  ### DEVELOPMENT / INTERPRETERS


  clisp = import ../development/interpreters/clisp {
    inherit fetchurl stdenv libsigsegv gettext
      readline ncurses coreutils pcre zlib;
    inherit (xlibs) libX11 libXau libXt xproto
      libXpm libXext xextproto;
  };

  erlang = selectVersion ../development/interpreters/erlang "R12B-1" {
    inherit fetchurl stdenv perl gnum4 ncurses openssl;
  };

  guile = import ../development/interpreters/guile {
    inherit fetchurl stdenv readline libtool gmp gawk makeWrapper;
  };

  io = builderDefsPackage (import ../development/interpreters/io) {
    inherit sqlite zlib gmp libffi cairo ncurses freetype mesa
      libpng libtiff libjpeg readline libsndfile libxml2
      freeglut e2fsprogs libsamplerate pcre libevent editline;
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
    inherit fetchurl stdenv flex bison ncurses buddy tecla gmp libsigsegv makeWrapper;
  };

  octave = import ../development/interpreters/octave {
    inherit stdenv fetchurl readline ncurses perl flex;
    g77 = g77_42;
  };

  # mercurial (hg) bleeding edge version
  octaveHG = import ../development/interpreters/octave/hg.nix {
    inherit fetchurl readline ncurses perl flex atlas getConfig glibc;
    inherit automake autoconf bison gperf lib python gnuplot texinfo texLive; # for dev Version
    stdenv = overrideGCC stdenv gcc40;
    g77 = g77_42;
    inherit (bleedingEdgeRepos) sourceByName;
  };

  perl = if !stdenv.isLinux then sysPerl else realPerl;

  perl58 = if !stdenv.isLinux then sysPerl else
    import ../development/interpreters/perl-5.8 {
      inherit fetchurl stdenv;
    };

  # FIXME: unixODBC needs patching on Darwin (see darwinports)
  phpOld = import ../development/interpreters/php {
    inherit stdenv fetchurl flex bison libxml2 apacheHttpd;
    unixODBC =
      if stdenv.isDarwin then null else unixODBC;
  };

  php = import ../development/interpreters/php_configurable {
    inherit
      stdenv fetchurl lib composableDerivation autoconf automake
      flex bison apacheHttpd mysql libxml2 # gettext
      zlib curl gd postgresql openssl pkgconfig;
  };

  pltScheme = builderDefsPackage (import ../development/interpreters/plt-scheme) {
    inherit cairo fontconfig freetype libjpeg libpng openssl
      perl mesa zlib which;
    inherit (xorg) libX11 libXaw libXft libXrender libICE xproto
      renderproto pixman libSM libxcb libXext xextproto libXmu
      libXt;
  };

  python = if getConfig ["python" "full"] false then pythonFull else pythonBase;
  python25 = if getConfig ["python" "full"] false then python25Full else python25Base;
  pythonBase = python25Base;
  pythonFull = python25Full;

  python24 = import ../development/interpreters/python/2.4 {
    inherit fetchurl stdenv zlib bzip2;
  };

  python25Base = composedArgsAndFun (import ../development/interpreters/python/2.5) {
    inherit fetchurl stdenv zlib bzip2 gdbm;
  };

  python25Full = python25Base.passthru.function {
    db4 = if getConfig ["python" "db4Support"] true then db4 else null;
    sqlite = if getConfig ["python" "sqliteSupport"] true then sqlite else null;
    readline = if getConfig ["python" "readlineSupport"] true then readline else null;
    openssl = if getConfig ["python" "opensslSupport"] true then openssl else null;
    tk = if getConfig ["python" "tkSupport"] true then tk else null;
    tcl = if getConfig ["python" "tkSupport"] true then tcl else null;
    libX11 = if getConfig ["python" "tkSupport"] true then xlibs.libX11 else null;
    xproto = if getConfig ["python" "tkSupport"] true then xlibs.xproto else null;
  };

  # new python and lib proposal
  # - adding a python lib to buildinputs should be enough
  #   (handles .pth files by patching site.py
  #    while introducing NIX_PYTHON_SITES describing list of modules)
  # - adding pyCheck = "import foo" test scripts to ensure libraries can be imported
  # - providing pythonWrapper so that you can run python and import the selected libraries
  # feel free to comment on this (experimental)
  python25New = recurseIntoAttrs ((import ../development/interpreters/python-new/2.5) pkgs);
  pythonNew = python25New; # the default python

  pyrex = pyrex095;

  pyrex095 = import ../development/interpreters/pyrex/0.9.5.nix {
    inherit fetchurl stdenv stringsWithDeps lib builderDefs python;
  };

  pyrex096 = import ../development/interpreters/pyrex/0.9.6.nix {
    inherit fetchurl stdenv stringsWithDeps lib builderDefs python;
  };

  Qi = composedArgsAndFun (selectVersion ../development/compilers/qi "9.1") {
    inherit clisp stdenv fetchurl builderDefs unzip;
  };

  realPerl = import ../development/interpreters/perl-5.10 {
    fetchurl = fetchurlBoot;
    inherit stdenv;
  };

  ruby = import ../development/interpreters/ruby {
    inherit fetchurl stdenv readline ncurses zlib lib openssl;
  };

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

  rubygems = builderDefsPackage (import ../development/interpreters/ruby/gems.nix) {
    inherit ruby makeWrapper;
  };

  rq = import ../applications/networking/cluster/rq {
    inherit fetchurl stdenv sqlite ruby ;
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
      xulrunner = xulrunner3;
    };


  ### DEVELOPMENT / MISC


  /*
  toolbus = import ../development/interpreters/toolbus {
    inherit stdenv fetchurl atermjava toolbuslib aterm yacc flex;
  };
  */

  bleedingEdgeRepos = import ../development/misc/bleeding-edge-repos {
    inherit getConfig fetchdarcs2 fetchurl lib;
  };

  ecj = import ../development/eclipse/ecj {
    inherit fetchurl stdenv unzip jre ant;
  };

  jdtsdk = import ../development/eclipse/jdt-sdk {
    inherit fetchurl stdenv unzip;
  };

  guileLib = import ../development/guile-modules/guile-lib {
    inherit fetchurl stdenv guile texinfo;
  };

  windowssdk = import ../development/misc/windows-sdk {
    inherit fetchurl stdenv cabextract;
  };


  ### DEVELOPMENT / TOOLS


  alex = import ../development/tools/parsing/alex {
    inherit cabal perl;
  };

  antlr = import ../development/tools/parsing/antlr/antlr-2.7.6.nix {
    inherit fetchurl stdenv jre;
  };

  antlr3 = import ../development/tools/parsing/antlr {
    inherit fetchurl stdenv jre;
  };

  ant = apacheAnt;
  apacheAnt = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv jdk;
    name = "ant-" + jdk.name;
  };

  apacheAnt14 = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv;
    jdk = j2sdk14x;
    name = "ant-" + j2sdk14x.name;
  };

  autobuild = import ../development/tools/misc/autobuild {
    inherit fetchurl stdenv makeWrapper perl openssh rsync;
  };

  autoconf = import ../development/tools/misc/autoconf {
    inherit fetchurl stdenv perl m4 lzma;
  };

  autoconf213 = import ../development/tools/misc/autoconf/2.13.nix {
    inherit fetchurl stdenv perl m4 lzma;
  };

  automake = automake19x;

  automake17x = import ../development/tools/misc/automake/automake-1.7.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  automake19x = import ../development/tools/misc/automake/automake-1.9.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  automake110x = import ../development/tools/misc/automake/automake-1.10.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  avrdude = import ../development/tools/misc/avrdude {
    inherit lib fetchurl stdenv flex yacc composableDerivation texLive;
  };

  binutils = useFromStdenv "binutils"
    (import ../development/tools/misc/binutils {
      inherit fetchurl stdenv noSysDirs;
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
    inherit fetchurl stdenv python twisted makeWrapper;
  };

  byacc = import ../development/tools/parsing/byacc {
    inherit fetchurl stdenv;
  };

  ccache = import ../development/tools/misc/ccache {
    inherit fetchurl stdenv;
  };

  ctags = import ../development/tools/misc/ctags {
    inherit fetchurl stdenv;
  };

  cmake = import ../development/tools/build-managers/cmake {
    inherit fetchurl stdenv replace ncurses;
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

  doxygen = import ../development/tools/documentation/doxygen {
    inherit fetchurl stdenv graphviz perl flex bison gnumake;
    inherit (xlibs) libX11 libXext;
    qt = if getPkgConfig "doxygen" "qt3" true then qt3 else null;
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

  flex254a = import ../development/tools/parsing/flex/flex-2.5.4a.nix {
    inherit fetchurl stdenv yacc;
  };

  frown = import ../development/tools/parsing/frown {
    inherit fetchurl stdenv ghc;
  };

  m4 = gnum4;

  gnum4 = import ../development/tools/misc/gnum4 {
    inherit fetchurl stdenv;
  };

  gnumake = useFromStdenv "gnumake"
    (import ../development/tools/build-managers/gnumake {
      inherit fetchurl stdenv;
    });

  gnumake380 = import ../development/tools/build-managers/gnumake-3.80 {
    inherit fetchurl stdenv;
  };

  gperf = import ../development/tools/misc/gperf {
    inherit fetchurl stdenv;
  };

  # used to bootstrap ghc with
  haddockboot = lowPrio (appendToName "boot" (import ../development/tools/documentation/haddock/boot.nix {
    inherit gmp;
    cabal = cabalboot;
  }));

  # old version of haddock, still more stable than 2.0
  haddock09 = import ../development/tools/documentation/haddock/haddock-0.9.nix {
    inherit cabal;
  };

  # does not compile with ghc-6.8.3
  haddock210 = lowPrio (import ../development/tools/documentation/haddock/haddock-2.1.0.nix {
    cabal = cabal682;
  });

  hsc2hs = import ../development/tools/misc/hsc2hs {
    inherit bleedingEdgeRepos stdenv;
    ghc = ghcsAndLibs.ghc68.ghc;
    libs = with (ghc68extraLibs ghcsAndLibs.ghc68 // ghcsAndLibs.ghc68.core_libs); [ base directory process cabal_darcs ];
  };

  guileLint = import ../development/tools/guile/guile-lint {
    inherit fetchurl stdenv guile;
  };

  gwrap = import ../development/tools/guile/g-wrap {
    inherit fetchurl stdenv guile libffi pkgconfig guileLib;
    inherit (gtkLibs) glib;
  };

  /*
  happy = import ../development/tools/parsing/happy {
    inherit fetchurl stdenv perl ghc;
  };
  */

  happy = import ../development/tools/parsing/happy/happy-1.17.nix {
    inherit cabal perl;
  };

  help2man = import ../development/tools/misc/help2man {
    inherit fetchurl stdenv perl gettext perlLocaleGettext;
  };

  iconnamingutils = import ../development/tools/misc/icon-naming-utils {
    inherit fetchurl stdenv perl perlXMLSimple;
  };

  indent = composedArgsAndFun (selectVersion ../development/tools/misc/indent "2.2.9") {
    inherit fetchurl stdenv builderDefs;
  };

  jikespg = import ../development/tools/parsing/jikespg {
    inherit fetchurl stdenv;
  };

  kcachegrind = import ../development/tools/misc/kcachegrind {
    inherit fetchurl stdenv kdelibs zlib perl expat libpng libjpeg;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  lcov = import ../development/tools/analysis/lcov {
    inherit fetchurl stdenv perl;
  };

  libtool = import ../development/tools/misc/libtool {
    inherit fetchurl stdenv perl m4;
  };

  libtool2 = import ../development/tools/misc/libtool/libtool2.nix {
    inherit fetchurl stdenv lzma perl m4;
  };

  libtoolOld = lowPrio (import ../development/tools/misc/libtool/old.nix {
    inherit fetchurl stdenv perl m4;
  });

  lsof = import ../development/tools/misc/lsof {
    inherit fetchurl stdenv;
  };

  ltrace = composedArgsAndFun (selectVersion ../development/tools/misc/ltrace "0.5-3deb") {
    inherit fetchurl stdenv builderDefs stringsWithDeps lib elfutils;
  };

  mk = import ../development/tools/build-managers/mk {
    inherit fetchurl stdenv;
  };

  noweb = import ../development/tools/literate-programming/noweb {
    inherit fetchurl stdenv;
  };

  oprofile = import ../development/tools/profiling/oprofile {
    inherit fetchurl stdenv binutils popt;
    inherit makeWrapper gawk which gnugrep;
  };

  patchelf = useFromStdenv "patchelf"
    (import ../development/tools/misc/patchelf {
      inherit fetchurl stdenv;
    });

  pmccabe = import ../development/tools/misc/pmccabe {
    inherit fetchurl stdenv;
  };

  /**
   * pkgconfig is optionally taken from the stdenv to allow bootstrapping
   * of glib and pkgconfig itself on MinGW.
   */
  pkgconfig = useFromStdenv "pkgconfig"
    (import ../development/tools/misc/pkgconfig {
      inherit fetchurl stdenv;
    });

  ragel = import ../development/tools/parsing/ragel {
    inherit composableDerivation fetchurl transfig texLive;
  };

  # couldn't find the source yet
  selenium_rc_binary = import ../development/tools/selenium/remote-control {
    inherit fetchurl stdenv unzip;
  };

  scons = import ../development/tools/build-managers/scons {
    inherit fetchurl stdenv python makeWrapper;
  };

  sdf = import ../development/tools/parsing/sdf {
    inherit fetchurl aterm getopt pkgconfig;
    # Note: sdf2-bundle currently requires GNU make 3.80; remove
    # explicit dependency when this is fixed.
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  sdf24 = import ../development/tools/parsing/sdf/sdf2-bundle-2.4.nix {
    inherit fetchurl getopt pkgconfig;
    aterm = aterm25;
    # Note: sdf2-bundle currently requires GNU make 3.80; remove
    # explicit dependency when this is fixed.
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  sparse = import ../development/tools/analysis/sparse {
    inherit fetchurl stdenv pkgconfig;
  };

  splint = import ../development/tools/analysis/splint {
    inherit fetchurl stdenv flex;
  };

  strace = import ../development/tools/misc/strace {
    inherit fetchurl stdenv;
  };

  swig = import ../development/tools/misc/swig {
    inherit fetchurl stdenv perl python;
    perlSupport = true;
    pythonSupport = true;
    javaSupport = false;
  };

  swftools = import ../tools/video/swftools {
    inherit fetchurl stdenv x264 zlib libjpeg freetype giflib;
  };

  swigWithJava = lowPrio (appendToName "with-java" (import ../development/tools/misc/swig {
    inherit fetchurl stdenv jdk;
    perlSupport = false;
    pythonSupport = false;
    javaSupport = true;
  }));

  texinfo49 = import ../development/tools/misc/texinfo/4.9.nix {
    inherit fetchurl stdenv ncurses;
  };

  texinfo = import ../development/tools/misc/texinfo {
    inherit fetchurl stdenv ncurses lzma;
  };

  uisp = import ../development/tools/misc/uisp {
    inherit fetchurl stdenv;
  };

  uuagc = import ../development/tools/haskell/uuagc {
    inherit cabal uulib;
  };

  gdb = import ../development/tools/misc/gdb {
    inherit fetchurl stdenv ncurses readline gmp mpfr texinfo;
  };

  valgrind = import ../development/tools/analysis/valgrind {
    inherit fetchurl stdenv perl gdb;
  };

  xxdiff = builderDefsPackage (selectVersion ../development/tools/misc/xxdiff "3.2") {
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
      inherit stdenv fetchurl gettext attr;
      libtool = libtoolOld;
    });

  adns = selectVersion ../development/libraries/adns "1.4" {
    inherit stdenv fetchurl;
    static = getPkgConfig "adns" "static" (stdenv ? isStatic || stdenv ? isDietLibC);
  };

  agg = import ../development/libraries/agg {
    inherit fetchurl stdenv autoconf automake libtool pkgconfig
            freetype SDL;
  };

  apr = import ../development/libraries/apr {
    inherit fetchurl stdenv;
  };

  aprutil = import ../development/libraries/apr-util {
    inherit fetchurl stdenv apr expat db4;
    bdbSupport = true;
  };

  arts = import ../development/libraries/arts {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXext;
    inherit kdelibs zlib libjpeg libpng perl;
    qt = qt3;
    inherit (gnome) glib;
  };

  aspell = import ../development/libraries/aspell {
    inherit fetchurl stdenv perl;
  };

  aspellDicts = recurseIntoAttrs (import ../development/libraries/aspell/dictionaries.nix {
    inherit fetchurl stdenv aspell which;
  });

  aterm = aterm242fixes;

  aterm242fixes = import ../development/libraries/aterm/2.4.2-fixes.nix {
    inherit fetchurl stdenv;
  };

  aterm25 = lowPrio (import ../development/libraries/aterm/2.5.nix {
    inherit fetchurl stdenv;
  });

  aterm28 = lowPrio (import ../development/libraries/aterm/2.8.nix {
    inherit fetchurl stdenv;
  });

  attr = useFromStdenv "attr"
    (import ../development/libraries/attr {
      inherit stdenv fetchurl gettext;
      libtool = libtoolOld;
    });

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

  boostVersionChoice = version: selectVersion ../development/libraries/boost version {
    inherit fetchurl stdenv icu expat zlib bzip2 python;
  };
  boost = boostVersionChoice "1.38.0";

  buddy = import ../development/libraries/buddy {
    inherit fetchurl stdenv;
  };

  cairo = import ../development/libraries/cairo {
    inherit fetchurl stdenv pkgconfig x11 fontconfig freetype zlib libpng;
    inherit (xlibs) pixman libxcb xcbutil;
  };

  cairomm = import ../development/libraries/cairomm {
    inherit fetchurl stdenv pkgconfig cairo x11 fontconfig freetype libsigcxx;
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

  clearsilver = import ../development/libraries/clearsilver {
    inherit fetchurl stdenv python;
  };

  clppcre = builderDefsPackage (import ../development/libraries/cl-ppcre) {
  };

  cluceneCore = (import ../development/libraries/clucene-core) {
    inherit fetchurl stdenv;
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
    inherit fetchurl stdenv unzip;
  };

  cyrus_sasl = import ../development/libraries/cyrus-sasl {
    inherit fetchurl stdenv openssl db4 gettext;
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

  dbus_glib = import ../development/libraries/dbus-glib {
    inherit fetchurl stdenv pkgconfig gettext dbus expat;
    inherit (gtkLibs) glib;
  };

  dclib = import ../development/libraries/dclib {
    inherit fetchurl stdenv libxml2 openssl bzip2;
  };

  directfb = import ../development/libraries/directfb {
    inherit fetchurl stdenv perl;
  };

  editline = import ../development/libraries/editline {
    inherit fetchurl stdenv ncurses;
  };

  enchant = selectVersion ../development/libraries/enchant "1.3.0" {
    inherit fetchurl stdenv aspell pkgconfig;
    inherit (gnome) glib;
  };

  exiv2 = import ../development/libraries/exiv2 {
    inherit fetchurl stdenv zlib;
  };

  expat = import ../development/libraries/expat {
    inherit fetchurl stdenv;
  };

  eventlog = import ../development/libraries/eventlog {
    inherit fetchurl stdenv;
  };

  facile = import ../development/libraries/facile {
    inherit fetchurl stdenv;
    # Actually, we don't need this version but we need native-code compilation
    ocaml = builtins.getAttr "3.10.0" ocaml_alts;
  };

  faac = import ../development/libraries/faac {
    inherit fetchurl stdenv autoconf automake libtool;
  };

  faad2 = import ../development/libraries/faad2 {
    inherit fetchurl stdenv autoconf automake libtool;
  };

  fcgi = import ../development/libraries/fcgi {
      inherit fetchurl stdenv;
  };

  ffmpeg = import ../development/libraries/ffmpeg {
    inherit fetchurl stdenv;
  };

  ffmpeg_svn = import ../development/libraries/ffmpeg_svn_snapshot {
    inherit fetchurl stdenv;
  };

  fftw = import ../development/libraries/fftw {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
    singlePrecision = false;
  };
  fftwSinglePrec = import ../development/libraries/fftw {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
    singlePrecision = true;
  };

  fltk20 = (import ../development/libraries/fltk) {
    inherit composableDerivation x11 lib pkgconfig freeglut;
    inherit fetchurl stdenv mesa mesaHeaders libpng libjpeg zlib ;
    inherit (xlibs) inputproto libXi libXinerama libXft;
    flags = [ "useNixLibs" "threads" "shared" "gl" ];
  };

  freeimage = import ../development/libraries/freeimage {
    inherit fetchurl stdenv unzip;
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

  freeglut = assert mesaSupported; import ../development/libraries/freeglut {
    inherit fetchurl stdenv x11 mesa;
  };

  freetype = import ../development/libraries/freetype {
    inherit fetchurl stdenv;
  };

  fribidi = import ../development/libraries/fribidi {
    inherit fetchurl stdenv;
  };

  fam = gamin;

  gamin = import ../development/libraries/gamin {
    inherit fetchurl stdenv python pkgconfig;
    inherit (gtkLibs) glib;
  };

  gav = import ../games/gav {
    inherit fetchurl stdenv SDL SDL_image SDL_mixer SDL_net;
  };

  gdbm = import ../development/libraries/gdbm {
    inherit fetchurl stdenv;
  };

  gegl = import ../development/libraries/gegl {
    inherit fetchurl stdenv libpng pkgconfig babl;
    openexr = openexr_1_6_1;
    #  avocodec avformat librsvg
    inherit cairo libjpeg librsvg;
    inherit (gtkLibs) pango glib gtk;
  };

  geos = import ../development/libraries/geos {
    inherit fetchurl fetchsvn stdenv autoconf
      automake libtool swig which lib composableDerivation python ruby;
    use_svn = stdenv.system == "x86_64-linux";
  };

  gettext = composedArgsAndFun (selectVersion ../development/libraries/gettext "0.17") {
    inherit fetchurl stdenv;
  };

  gd = import ../development/libraries/gd {
    inherit fetchurl stdenv zlib libpng freetype libjpeg fontconfig;
  };

  gdal = stdenv.mkDerivation {
    name = "gdal-1.4.2";
    src = fetchurl {
      url = http://download.osgeo.org/gdal/gdal-1.4.2.tar.gz;
      sha256 = "1vl8ym9y7scm0yd4vghjfqims69b9h1gn9l4zvy2jyglh35p8vpf";
    };
  };

  glew = import ../development/libraries/glew {
    inherit fetchurl stdenv mesa x11 libtool;
    inherit (xlibs) libXmu libXi;
  };

  # don't know wether this newer version breaks anything..
  # not replacing the existing one.
  glib214 = import ../development/libraries/glib {
    inherit fetchurl stdenv pkgconfig gettext;
  };

  glibc = useFromStdenv "glibc" glibc29;

  glibc27 = import ../development/libraries/glibc-2.7 {
    inherit fetchurl stdenv kernelHeaders;
    #installLocales = false;
  };

  glibc29 = import ../development/libraries/glibc-2.9 {
    inherit fetchurl stdenv kernelHeaders;
    installLocales = getPkgConfig "glibc" "locales" true;
  };

  glibc_multi =
    assert system == "x86_64-linux";
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
      ''; # */

  gmime = import ../development/libraries/gmime {
    inherit fetchurl stdenv pkgconfig zlib;
    inherit (gtkLibs) glib;
  };

  gmm = import ../development/libraries/gmm {
    inherit fetchurl stdenv;
  };

  gmp = import ../development/libraries/gmp {
    inherit fetchurl stdenv m4;
    cxx = false;
  };

  goocanvas = import ../development/libraries/goocanvas {
    inherit fetchurl stdenv pkgconfig cairo;
    inherit (gnome) gtk glib;
  };

  #GMP ex-satellite, so better keep it near gmp
  mpfr = import ../development/libraries/mpfr {
    inherit fetchurl stdenv gmp;
  };

  gst_all = recurseIntoAttrs (import ../development/libraries/gstreamer {
    inherit lib selectVersion stdenv fetchurl perl bison pkgconfig libxml2
      python alsaLib cdparanoia libogg libvorbis libtheora freetype liboil
      libjpeg zlib speex libpng libdv aalib cairo libcaca flac hal libiec61883
      dbus libavc1394 ladspaH taglib bzip2 which;
    flex = flex2535;
    inherit (xorg) libX11 libXv libXext;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) gnomevfs /* <- only passed for the no longer used older versions
             it is depreceated and didn't build on amd64 due to samba dependenccy */ gtkdoc;
  });

  gnet = import ../development/libraries/gnet {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib;
  };

  gnutls = import ../development/libraries/gnutls {
    inherit fetchurl stdenv libgcrypt zlib lzo guile;
    guileBindings = getConfig ["gnutls" "guile"] false;
  };

  gpgme = import ../development/libraries/gpgme {
    inherit fetchurl stdenv libgpgerror pkgconfig pth gnupg gnupg2;
    inherit (gtkLibs) glib;
  };

  # gnu scientific library
  gsl = import ../development/libraries/gsl {
    inherit fetchurl stdenv;
  };

  gtkLibs = recurseIntoAttrs gtkLibs214;

  gtkLibs1x = import ../development/libraries/gtk-libs/1.x {
    inherit fetchurl stdenv x11 libtiff libjpeg libpng;
  };

  gtkLibs210 = import ../development/libraries/gtk-libs/2.10 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo libsigcxx cairomm;
    inherit (xlibs) libXinerama libXrandr;
    xineramaSupport = true;
  };

  gtkLibs212 = import ../development/libraries/gtk-libs/2.12 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo libsigcxx cairomm;
    inherit (xlibs) libXinerama libXrandr;
    xineramaSupport = true;
  };

  gtkLibs214 = import ../development/libraries/gtk-libs/2.14 {
    inherit fetchurl stdenv pkgconfig gettext perl x11 jasper
            libtiff libjpeg libpng cairo libsigcxx cairomm;
    inherit (xlibs) libXinerama libXrandr;
    xineramaSupport = true;
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

  jasper = import ../development/libraries/jasper {
    inherit fetchurl stdenv unzip libjpeg freeglut mesa;
    inherit (xlibs) xproto libX11 libICE libXmu libXi libXext libXt;
  };

  lablgtk = import ../development/libraries/lablgtk {
    inherit fetchurl stdenv ocaml pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnomecanvas;
  };

  lcms = import ../development/libraries/lcms {
    inherit fetchurl stdenv;
  };

  lesstif = import ../development/libraries/lesstif {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp libXau;
  };

  lesstif93 = import ../development/libraries/lesstif-0.93 {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp libXau;
  };

  lib3ds = import ../development/libraries/lib3ds {
    inherit fetchurl stdenv unzip;
  };

  libaal = import ../development/libraries/libaal {
    inherit fetchurl stdenv;
  };

  libao = import ../development/libraries/libao {
    inherit stdenv fetchurl pkgconfig;
  };

  libarchive = selectVersion ../development/libraries/libarchive "2.4.12" {
    inherit fetchurl stdenv zlib bzip2 e2fsprogs sharutils;
  };

  libassuan = import ../development/libraries/libassuan {
    inherit fetchurl stdenv pth;
  };

  libavc1394 = import ../development/libraries/libavc1394 {
    inherit fetchurl stdenv pkgconfig libraw1394;
  };

  libcaca = import ../development/libraries/libcaca {
    inherit fetchurl stdenv ncurses;
  };

  libcanberra = import ../development/libraries/libcanberra {
    inherit fetchurl stdenv pkgconfig libtool alsaLib pulseaudio libvorbis;
    inherit (gtkLibs214) gtk gthread;
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

  libcm = assert mesaSupported; import ../development/libraries/libcm {
    inherit fetchurl stdenv pkgconfig xlibs mesa;
    inherit (gtkLibs) glib;
  };

  libcv = builderDefsPackage (import ../development/libraries/libcv) {
    inherit libtiff libjpeg libpng pkgconfig;
    inherit (gtkLibs) gtk glib;
  };

  libdaemon = import ../development/libraries/libdaemon {
    inherit fetchurl stdenv;
  };

  libdbi = composedArgsAndFun (selectVersion ../development/libraries/libdbi "0.8.2") {
    inherit stdenv fetchurl builderDefs;
  };

  libdbiDriversBase = composedArgsAndFun
    (selectVersion ../development/libraries/libdbi-drivers "0.8.2-1")
    {
      inherit stdenv fetchurl builderDefs libdbi;
    };

  libdbiDrivers = libdbiDriversBase.passthru.function {
    inherit sqlite mysql;
  };

  libdv = import ../development/libraries/libdv {
    inherit fetchurl stdenv lib composableDerivation;
  };

  libdrm = import ../development/libraries/libdrm {
    inherit fetchurl stdenv;
  };

  libdvdcss = import ../development/libraries/libdvdcss {
    inherit fetchurl stdenv;
  };

  libdvdnav = import ../development/libraries/libdvdnav {
    inherit fetchurl stdenv;
  };

  libdvdread = import ../development/libraries/libdvdread {
    inherit fetchurl stdenv libdvdcss;
  };

  libevent = import ../development/libraries/libevent {
    inherit fetchurl stdenv;
  };

  libexif = import ../development/libraries/libexif {
    inherit fetchurl stdenv gettext;
  };

  libextractor = composedArgsAndFun (selectVersion ../development/libraries/libextractor "0.5.18")
  {
    inherit fetchurl stdenv builderDefs zlib;
  };

  libffi = import ../development/libraries/libffi {
    inherit fetchurl stdenv;
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
    inherit fetchurl stdenv perl perlXMLParser pkgconfig libxml2 gettext bzip2 python;
    inherit (gnome) glib gnomevfs libbonobo;
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

  libjingle = selectVersion ../development/libraries/libjingle "0.3.11" {
    inherit fetchurl stdenv mediastreamer;
  };

  libjpeg = import ../development/libraries/libjpeg {
    inherit fetchurl stdenv libtool;
  };

  libjpegStatic = lowPrio (appendToName "static" (import ../development/libraries/libjpeg-static {
    inherit fetchurl stdenv libtool;
    static = true;
  }));

  libksba = import ../development/libraries/libksba {
    inherit fetchurl stdenv libgpgerror;
  };

  libmad = import ../development/libraries/libmad {
    inherit fetchurl stdenv;
  };

  libmcs = import ../development/libraries/libmcs {
    inherit fetchurl stdenv pkgconfig libmowgli;
  };

  libmicrohttpd = import ../development/libraries/libmicrohttpd {
    inherit fetchurl stdenv curl;
  };

  libmowgli = import ../development/libraries/libmowgli {
    inherit fetchurl stdenv;
  };

  libmpcdec = import ../development/libraries/libmpcdec {
    inherit fetchurl stdenv;
  };

  libmspack = import ../development/libraries/libmspack {
    inherit fetchurl stdenv;
  };

  libnova = import ../development/libraries/libnova {
    inherit fetchurl stdenv;
  };

  libogg = import ../development/libraries/libogg {
    inherit fetchurl stdenv;
  };

  liboil = composedArgsAndFun
    (selectVersion ../development/libraries/liboil "0.3.15") {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib;
  };

  liboop = import ../development/libraries/liboop {
    inherit fetchurl stdenv;
  };

  libotr = import ../development/libraries/libotr {
    inherit fetchurl stdenv libgcrypt;
  };

  libpcap = import ../development/libraries/libpcap {
    inherit fetchurl stdenv flex bison;
  };

  libpng = import ../development/libraries/libpng {
    inherit fetchurl stdenv zlib;
  };

  /*libscdFun = lib.sumArgs (selectVersion ../development/libraries/libscd "0.4.2") {
    inherit stdenv fetchurl builderDefs libextractor perl pkgconfig;
  };

  libscd = libscdFun null;*/

  libsigcxx = import ../development/libraries/libsigcxx {
    inherit fetchurl stdenv pkgconfig;
  };

  libsigsegv = selectVersion ../development/libraries/libsigsegv "2.5" {
    inherit fetchurl stdenv;
  };

  libsndfile = import ../development/libraries/libsndfile {
    inherit fetchurl stdenv;
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

  libvncserver = builderDefsPackage (import ../development/libraries/libvncserver) {
    inherit libtool libjpeg openssl zlib;
    inherit (xlibs) xproto libX11 damageproto libXdamage
      libXext xextproto fixesproto libXfixes xineramaproto
      libXinerama libXrandr randrproto libXtst;
  };

  libvorbis = import ../development/libraries/libvorbis {
    inherit fetchurl stdenv libogg;
  };

  libwmf = import ../development/libraries/libwmf {
    inherit fetchurl stdenv pkgconfig imagemagick
      zlib libpng freetype libjpeg libxml2;
    inherit (gtkLibs) glib;
  };

  libwpd = import ../development/libraries/libwpd {
    inherit fetchurl stdenv pkgconfig libgsf libxml2 bzip2;
    inherit (gnome) glib;
  };

  libxcrypt = import ../development/libraries/libxcrypt {
    inherit fetchurl stdenv;
  };

  libxklavier = selectVersion ../development/libraries/libxklavier "3.4" {
    inherit fetchurl stdenv xkeyboard_config pkgconfig libxml2;
    inherit (xorg) libX11 libICE libxkbfile;
    inherit (gtkLibs) glib;
  };

  libxml2 = import ../development/libraries/libxml2 {
    inherit fetchurl stdenv zlib python;
    pythonSupport = false;
  };

  libxml2Python = lowPrio (appendToName "with-python" (import ../development/libraries/libxml2 {
    inherit fetchurl stdenv zlib python;
    pythonSupport = true;
  }));

  libxslt = import ../development/libraries/libxslt {
    inherit fetchurl stdenv libxml2;
  };

  libixp_for_wmii = lowPrio (import ../development/libraries/libixp_for_wmii {
    inherit fetchurl stdenv;
  });

  libzip = import ../development/libraries/libzip {
    inherit fetchurl stdenv zlib;
  };

  lightning = import ../development/libraries/lightning {
    inherit fetchurl stdenv;
  };

  log4cxx = import ../development/libraries/log4cxx {
    inherit fetchurl stdenv automake autoconf libtool cppunit libxml2 boost;
    inherit apr aprutil db45 expat;
  };

  loudmouth = import ../development/libraries/loudmouth {
    inherit fetchurl stdenv libidn gnutls pkgconfig;
    inherit (gtkLibs) glib;
  };

  lzo = import ../development/libraries/lzo {
    inherit fetchurl stdenv;
  };

  # failed to build
  mediastreamer = composedArgsAndFun (selectVersion
      ../development/libraries/mediastreamer "2.2.0-cvs20080207") {
    inherit fetchurl stdenv automake libtool autoconf alsaLib pkgconfig speex
      ortp;
    ffmpeg = ffmpeg_svn;
  };

  mesaSupported =
    system == "i686-linux" ||
    system == "x86_64-linux";

  mesa = assert mesaSupported; import ../development/libraries/mesa {
    inherit fetchurl stdenv pkgconfig expat x11 xlibs libdrm;
  };

  mesaHeaders = import ../development/libraries/mesa/headers.nix {
    inherit stdenv;
    mesaSrc = mesa.src;
  };

  ming = import ../development/libraries/ming {
    inherit fetchurl stdenv flex bison freetype zlib libpng perl;
  };

  mpeg2dec = import ../development/libraries/mpeg2dec {
    inherit fetchurl stdenv;
  };

  msilbc = selectVersion ../development/libraries/msilbc "2.0.0" {
    inherit fetchurl stdenv ilbc mediastreamer pkgconfig;
  };

  mpich2 = import ../development/libraries/mpich2 {
    inherit fetchurl stdenv python;
  };

  ncurses = composedArgsAndFun (import ../development/libraries/ncurses) {
    inherit fetchurl stdenv;
    unicode = (system != "i686-cygwin");
  };

  ncursesDiet = import ../development/libraries/ncurses-diet {
    inherit fetchurl;
    stdenv = useDietLibC stdenv;
  };

  neon = neon026;

  neon026 = import ../development/libraries/neon/0.26.nix {
    inherit fetchurl stdenv libxml2 zlib openssl;
    compressionSupport = true;
    sslSupport = true;
  };

  neon028 = import ../development/libraries/neon/0.28.nix {
    inherit fetchurl stdenv libxml2 zlib openssl;
    compressionSupport = true;
    sslSupport = true;
  };

  nss = import ../development/libraries/nss {
    inherit fetchurl stdenv perl zip;
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
    inherit fetchurl stdenv mesa qt4 tcl tk;
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

  openldap = import ../development/libraries/openldap {
    inherit fetchurl stdenv openssl cyrus_sasl db4 groff;
  };

  openssl = import ../development/libraries/openssl {
    fetchurl = fetchurlBoot;
    inherit stdenv perl;
  };

  ortp = selectVersion ../development/libraries/ortp "0.13.1" {
    inherit fetchurl stdenv;
  };

  pangoxsl = import ../development/libraries/pangoxsl {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib pango;
  };

  pcre = import ../development/libraries/pcre {
    inherit fetchurl stdenv;
    unicodeSupport = getConfig ["pcre" "unicode"] false;
    cplusplusSupport = !stdenv ? isDietLibC;
  };

  plib = import ../development/libraries/plib {
    inherit fetchurl stdenv mesa freeglut SDL;
    inherit (xlibs) libXi libSM libXmu libXext libX11;
  };

  poppler = import ../development/libraries/poppler {
    inherit fetchurl stdenv qt4 cairo freetype fontconfig zlib libjpeg
      pkgconfig;
    inherit (gtkLibs) glib gtk;
    qt4Support = getConfig [ "poppler" "qt4Support" ] false;
  };

  popt = import ../development/libraries/popt {
    inherit fetchurl stdenv gettext;
  };

  proj = import ../development/libraries/proj.4 {
    inherit fetchurl stdenv;
  };

  pth = import ../development/libraries/pth {
    inherit fetchurl stdenv;
  };

  pthread_stubs = import ../development/libraries/pthread-stubs {
    inherit fetchurl stdenv;
  };

  qt3gcc33 = import ../development/libraries/qt-3 {
    stdenv = overrideGCC stdenv gcc33;
    inherit fetchurl x11 zlib libjpeg libpng which mysql mesa;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor;
    openglSupport = false;
    mysqlSupport = false;
  };

  qt3 = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql mesa;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor;
    openglSupport = mesaSupported;
    mysqlSupport = getConfig ["qt" "mysql"] false;
  };

  qt3mysql = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql mesa;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto libXcursor;
    openglSupport = mesaSupported;
    mysqlSupport = true;
  };

  qt4 = import ../development/libraries/qt-4 {
    inherit fetchurl stdenv fetchsvn zlib libjpeg libpng which mysql mesa openssl cups dbus
    fontconfig freetype pkgconfig libtiff;
    inherit (xlibs) xextproto libXft libXrender libXrandr randrproto
    libXmu libXinerama xineramaproto libXcursor libICE libSM libX11 libXext
    inputproto fixesproto libXfixes;
    inherit (gnome) glib;
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

  # Also known as librdf, includes raptor and rasqal
  redland = import ../development/libraries/redland {
    inherit fetchurl stdenv openssl libxml2 pkgconfig perl postgresql sqlite
      mysql libxslt curl pcre;
    bdb = db4;
  };

  rte = import ../development/libraries/rte {
    inherit fetchurl stdenv;
  };

  schroedinger = import ../development/libraries/schroedinger {
    inherit fetchurl stdenv liboil pkgconfig;
  };

  SDL = import ../development/libraries/SDL {
    inherit fetchurl stdenv x11 mesa alsaLib;
    inherit (xlibs) libXrandr;
    openglSupport = mesaSupported;
    alsaSupport = true;
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
    inherit fetchurl stdenv pcre libpng;
  };

  snack = import ../development/libraries/snack {
    inherit fetchurl stdenv tcl tk pkgconfig x11;
        # optional
    inherit alsaLib vorbisTools python;
  };

  speex = import ../development/libraries/speex {
    inherit fetchurl stdenv libogg;
  };

  sqlite = import ../development/libraries/sqlite {
    inherit fetchurl stdenv readline;
  };

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

  tapioca_qt = import ../development/libraries/tapioca-qt {
    inherit fetchsvn stdenv cmake telepathy_qt;
    qt = qt4;
  };

  tecla = import ../development/libraries/tecla {
    inherit fetchurl stdenv;
  };

  telepathy_gabble = import ../development/libraries/telepathy-gabble {
    inherit fetchurl stdenv pkgconfig libxslt telepathy_glib loudmouth;
  };

  telepathy_glib = import ../development/libraries/telepathy-glib {
    inherit fetchurl stdenv dbus_glib pkgconfig libxslt python;
    inherit (gtkLibs) glib;
  };

  telepathy_qt = import ../development/libraries/telepathy-qt {
    inherit fetchsvn stdenv cmake;
    qt = qt4;
  };

  tk = composedArgsAndFun (selectVersion ../development/libraries/tk "8.4.18") {
    inherit fetchurl stdenv tcl x11;
  };

  unixODBC = import ../development/libraries/unixODBC {
    inherit fetchurl stdenv;
  };

  unixODBCDrivers = recurseIntoAttrs (import ../development/libraries/unixODBCDrivers {
    inherit fetchurl stdenv unixODBC glibc libtool openssl zlib;
    inherit postgresql mysql sqlite;
  });

  vtk = import ../development/libraries/vtk {
    inherit stdenv fetchurl cmake mesa;
    inherit (xlibs) libX11 xproto libXt;
  };

  vxl = import ../development/libraries/vxl {
   inherit fetchurl stdenv cmake unzip libtiff expat zlib libpng libjpeg;
  };

  webkit = builderDefsPackage (import ../development/libraries/webkit) {
    inherit (gtkLibs) gtk atk pango;
    inherit freetype fontconfig gettext gperf curl
      libjpeg libtiff libpng libxml2 libxslt sqlite
      icu cairo perl intltool automake libtool
      pkgconfig autoconf bison;
    flex = flex2535;
  };

  wxGTK = wxGTK26;

  wxGTK26 = import ../development/libraries/wxGTK-2.6 {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama libSM libXxf86vm xf86vidmodeproto;
  };

  wxGTK28fun = lib.sumArgs (import ../development/libraries/wxGTK-2.8);

  wxGTK28deps = wxGTK28fun {
    inherit fetchurl stdenv pkgconfig mesa;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama libSM libXxf86vm xf86vidmodeproto;
  };

  wxGTK28 = wxGTK28deps null;

  x264 = import ../development/libraries/x264 {
    inherit fetchurl stdenv;
  };

  Xaw3d = import ../development/libraries/Xaw3d {
    inherit fetchurl stdenv x11 bison;
    flex = flex2533;
    inherit (xlibs) imake gccmakedep libXmu libXpm libXp;
  };

  xineLib = import ../development/libraries/xine-lib {
    inherit fetchurl stdenv zlib x11 libdvdcss alsaLib pkgconfig mesa aalib SDL
      libvorbis libtheora speex;
    inherit (xlibs) libXv libXinerama;
  };

  xautolock = import ../misc/screensavers/xautolock {
    inherit fetchurl stdenv x11;
    inherit (xorg) imake;
    inherit (xlibs) libXScrnSaver scrnsaverproto;
  };

  xlibsWrapper = import ../development/libraries/xlibs-wrapper {
    inherit stdenv;
    packages = [
      freetype fontconfig xlibs.xproto xlibs.libX11 xlibs.libXt
      xlibs.libXft xlibs.libXext xlibs.libSM xlibs.libICE
      xlibs.xextproto
    ];
  };

  zlib = import ../development/libraries/zlib {
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

  xalanj = import ../development/libraries/java/xalanj {
    inherit stdenv fetchurl;
  };


  ### DEVELOPMENT / LIBRARIES / HASKELL

  benchpress = import ../development/libraries/haskell/benchpress {
    inherit cabal;
  };

  maybench = import ../development/libraries/haskell/maybench {
    inherit cabal benchpress;
  };

  binary = import ../development/libraries/haskell/binary {
    inherit cabal;
  };

  # cabal is a utility function to build cabal-based
  # Haskell packages
  cabal682 = import ../development/libraries/haskell/cabal/cabal.nix {
    inherit stdenv fetchurl;
    ghc = ghc682;
  };

  cabal683 = import ../development/libraries/haskell/cabal/cabal.nix {
    inherit stdenv fetchurl;
    ghc = ghc683;
  };

  cabalboot = import ../development/libraries/haskell/cabal/cabal.nix {
    inherit stdenv fetchurl;
    ghc = ghcboot;
  };

  cabal = cabal683;

  Crypto = import ../development/libraries/haskell/Crypto {
    inherit cabal;
  };

  gtk2hs = import ../development/libraries/haskell/gtk2hs {
    inherit pkgconfig stdenv fetchurl cairo ghc;
    inherit (gnome) gtk glib GConf libglade libgtkhtml gtkhtml;
  };

  haxr = import ../development/libraries/haskell/haxr {
    inherit cabal HaXml HTTP;
  };

  haxr_th = import ../development/libraries/haskell/haxr-th {
    inherit cabal haxr HaXml HTTP;
  };

  HaXml = import ../development/libraries/haskell/HaXml {
    inherit cabal;
  };

  haskellEditline = import ../development/libraries/haskell/editline {
    inherit cabal editline;
  };

  HDBC = import ../development/libraries/haskell/HDBC/HDBC-1.1.4.nix {
    inherit cabal;
  };

  HDBCPostgresql = import ../development/libraries/haskell/HDBC/HDBC-postgresql-1.1.4.0.nix {
    inherit cabal HDBC postgresql;
  };

  HDBCSqlite = import ../development/libraries/haskell/HDBC/HDBC-sqlite3-1.1.4.0.nix {
    inherit cabal HDBC sqlite;
  };

  HTTP = import ../development/libraries/haskell/HTTP {
    inherit cabal;
  };

  monadlab = import ../development/libraries/haskell/monadlab {
    inherit cabal;
  };

  pcreLight = import ../development/libraries/haskell/pcre-light {
    inherit cabal pcre;
  };

  uulib = import ../development/libraries/haskell/uulib {
    inherit cabal;
  };

  wxHaskell = import ../development/libraries/haskell/wxHaskell {
    inherit stdenv fetchurl unzip wxGTK ghc;
  };

  /*
  wxHaskell68 = lowPrio (appendToName "ghc68" (import ../development/libraries/haskell/wxHaskell {
    inherit stdenv fetchurl unzip wxGTK;
    ghc = ghc68;
  }));
  */

  X11 = import ../development/libraries/haskell/X11 {
    inherit cabal;
    inherit (xlibs) libX11 libXinerama libXext;
    xineramaSupport = true;
  };

  vty = import ../development/libraries/haskell/vty {
    inherit cabal;
  };

  zlibHaskell = import ../development/libraries/haskell/zlib {
    inherit cabal zlib;
  };


  ### DEVELOPMENT / PERL MODULES

  buildPerlPackage = import ../development/perl-modules/generic perl;

  perlAlgorithmAnnotate = buildPerlPackage {
    name = "Algorithm-Annotate-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz;
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [perlAlgorithmDiff];
  };

  perlAlgorithmDiff = buildPerlPackage rec {
    name = "Algorithm-Diff-1.1901";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TY/TYEMQ/${name}.zip";
      sha256 = "0qk60fi49mpyvnfpjd2dzcmya8x3g5zfgb2hrnl7a5krn045g6i2";
    };
    buildInputs = [unzip];
  };

  perlAppCLI = buildPerlPackage {
    name = "App-CLI-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/App-CLI-0.07.tar.gz;
      sha256 = "000866qsm7jck3ini69b02sgbjwp6s297lsds002r7xk2wb6fqcz";
    };
    propagatedBuildInputs = [perlLocaleMaketextSimple];
  };

  perlAppConfig = buildPerlPackage {
    name = "AppConfig-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/AppConfig-1.66.tar.gz;
      sha256 = "1p1vs9px20lrq9mdwpzp309a8r6rchibsdmxang4krk90pi2sh4b";
    };
  };

  perlArrayCompare = buildPerlPackage {
    name = "Array-Compare-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-1.16.tar.gz;
      sha256 = "1iwkn7d07a7vgl3jrv4f0glwapxcbdwwsy3aa6apgwam9119hl7q";
    };
  };

  perlArchiveZip = buildPerlPackage {
    name = "Archive-Zip-1.16";
    src = fetchurl {
      url = http://nixos.org/tarballs/Archive-Zip-1.16.tar.gz;
      md5 = "e28dff400d07b1659d659d8dde7071f1";
    };
  };

  perlBerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit buildPerlPackage fetchurl db4;
  };

  perlBitVector = buildPerlPackage {
    name = "Bit-Vector-6.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-6.4.tar.gz;
      sha256 = "146vr78r6w3cxrm0ji491ylaa1abqh7fs81qhg15g3gzzxfg33bp";
    };
    propagatedBuildInputs = [perlCarpClan];
  };

  perlBoolean = buildPerlPackage rec {
    name = "boolean-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "1xqhzy3m2r08my13alff9bzl8b6xgd68312834x0hf33yir3l1yn";
    };
  };

  perlCacheFastMmap = buildPerlPackage {
    name = "Cache-FastMmap-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBM/Cache-FastMmap-1.28.tar.gz;
      sha256 = "1m851bz5025wy24mzsi1i8hdyg8bm7lszx9rnn47llsv6hb9v0da";
    };
  };

  perlCaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCAPTCHA-0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "1fm0fvdy9b7z8k1cyah2qbj0gqlv01chxmqmashwj16198yr7vrc";
    };
    propagatedBuildInputs = [perlHTMLTiny perlLWP];
    buildInputs = [perlTestPod];
  };

  perlCarpAssert = buildPerlPackage rec {
    name = "Carp-Assert-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHWERN/${name}.tar.gz";
      sha256 = "1wzy4lswvwi45ybsm65zlq17rrqx84lsd7rajvd0jvd5af5lmlqd";
    };
  };

  perlCarpAssertMore = buildPerlPackage rec {
    name = "Carp-Assert-More-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1m9k6z0m10s03x2hnc9mh5d4r8lnczm9bqd54jmnw0wzm4m33lyr";
    };
    propagatedBuildInputs = [perlTestException perlCarpAssert];
  };

  perlCarpClan = buildPerlPackage {
    name = "Carp-Clan-6.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJORE/Carp-Clan-6.00.tar.gz;
      sha256 = "0lbin4i0vzagcwkywpd5x4gz3a4ira4yn5g5v1ip0pbpyqnjk15h";
    };
    propagatedBuildInputs = [perlTestException];
  };

  perlCatalystActionRenderView = buildPerlPackage {
    name = "Catalyst-Action-RenderView-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Catalyst-Action-RenderView-0.08.tar.gz;
      sha256 = "1qng995mzgpm1gwb315ynm3spajf0ypmh1ciivqks3r0aamq2ar0";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlHTTPRequestAsCGI perlDataVisitor];
  };

  perlCatalystComponentInstancePerContext = buildPerlPackage rec {
    name = "Catalyst-Component-InstancePerContext-0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "0wfj4vnn2cvk6jh62amwlg050p37fcwdgrn9amcz24z6w4qgjqvz";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlMoose];
  };

  perlCatalystControllerHTMLFormFu = buildPerlPackage rec {
    name = "Catalyst-Controller-HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "1vrd79d0nbqkana5q483fgsr41idlfgjhf7fpd3hc056z5nq8iyn";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystActionRenderView perlCatalystViewTT
      perlCatalystPluginConfigLoader perlConfigGeneral
      perlCatalystComponentInstancePerContext perlMoose
      perlRegexpAssemble perlTestWWWMechanize
      perlTestWWWMechanizeCatalyst perlHTMLFormFu
    ];
  };

  perlCatalystDevel = buildPerlPackage rec {
    name = "Catalyst-Devel-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "19ylkx55gaq9xxxcl4a55284in7hdrr2sb6lqz64daq3xp29n73h";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystActionRenderView
      perlCatalystPluginStaticSimple perlCatalystPluginConfigLoader
      perlPathClass perlTemplateToolkit perlClassAccessor
      perlConfigGeneral perlFileCopyRecursive perlParent
    ];
  };

  perlCatalystManual = buildPerlPackage rec {
    name = "Catalyst-Manual-5.7016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HK/HKCLARK/${name}.tar.gz";
      sha256 = "0axin80dca3xb0n7frn9w8lj43l7dykpwrf7jj44n1v1kyzw813f";
    };
    buildInputs = [perlTestPod perlTestPodCoverage];
  };

  perlCatalystModelDBICSchema = buildPerlPackage {
    name = "Catalyst-Model-DBIC-Schema-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOGDAN/Catalyst-Model-DBIC-Schema-0.21.tar.gz;
      sha256 = "12hi2sa5ggn2jqnhbb9i2wf602bf6c06xmcqmiki5lvh4z1pxg6x";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystDevel perlDBIxClass
      perlUNIVERSALrequire perlClassDataAccessor
      perlDBIxClassSchemaLoader
    ];
  };

  perlCatalystRuntime = buildPerlPackage rec{
    name = "Catalyst-Runtime-5.71000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "0j9kwp2ylah0qsvgv08lnv49dlykx94bivwngw3zwn3g9qfbq26c";
    };
    propagatedBuildInputs = [
      perlLWP perlClassAccessor perlClassDataInheritable perlClassInspector
      perlCGISimple perlDataDump perlFileModified perlHTTPBody perlHTTPRequestAsCGI
      perlPathClass perlTextSimpleTable perlTreeSimple perlTreeSimpleVisitorFactory
    ];
  };

  perlCatalystPluginAuthentication = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authentication-0.10010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1jjdmyccsq0k8ysl9ppm7rddf6w4l2yhwjr60c0x4lp5iafzmf4z";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlCatalystPluginSession];
  };

  perlCatalystPluginAuthenticationStoreDBIC = buildPerlPackage {
    name = "Catalyst-Plugin-Authentication-Store-DBIC-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Catalyst-Plugin-Authentication-Store-DBIC-0.11.tar.gz;
      sha256 = "008x5yh65bmfdz3q7gxia739aajb8nx4ly5kyl4khl2pa9fy2jn7";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginAuthentication
      perlSetObject perlDBIxClass perlCatalystModelDBICSchema
      perlCatalystPluginAuthorizationRoles perlCatalystPluginSessionStateCookie
    ];
  };

  perlCatalystPluginAuthenticationStoreDBIxClass = buildPerlPackage {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.107";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/J/JA/JAYK/Catalyst-Authentication-Store-DBIx-Class-0.107.tar.gz;
      sha256 = "1vlrl65wf2i65zm2svb1mvylcx5vdrvxr09y16az60kdwiqvam6n";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginAuthentication perlCatalystModelDBICSchema
    ];
  };

  perlCatalystPluginAuthorizationACL = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-ACL-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Catalyst-Plugin-Authorization-ACL-0.10.tar.gz;
      sha256 = "1y9pj0scpc4nd7m1xqy7yvjsffhfadzl0z5r4jjv2srndcv4xj1p";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlClassThrowable];
  };

  perlCatalystPluginAuthorizationRoles = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-Roles-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Catalyst-Plugin-Authorization-Roles-0.07.tar.gz;
      sha256 = "07b8zc7b06p0fprjj68fk7rgh781r9s3q8dx045sk03w0fnk3b4b";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginAuthentication
      perlTestException perlSetObject perlUNIVERSALisa
    ];
  };

  perlCatalystPluginConfigLoader = buildPerlPackage rec {
    name = "Catalyst-Plugin-ConfigLoader-0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRICAS/${name}.tar.gz";
      sha256 = "13ir2l0pvjn4myp7wfh2bxcdd4hp0b3ln28mz1kvlshhxl032lqn";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlDataVisitor perlConfigAny perlMROCompat];
  };

  perlCatalystPluginHTMLWidget = buildPerlPackage {
    name = "Catalyst-Plugin-HTML-Widget-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Catalyst-Plugin-HTML-Widget-1.1.tar.gz;
      sha256 = "1zzyfhmzlqvbwk2w930k3mqk8z1lzhrja9ynx9yfq5gmc8qqg95l";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlHTMLWidget];
  };

  perlCatalystPluginSession = buildPerlPackage rec{
    name = "Catalyst-Plugin-Session-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1p72hf68qi038gayhsxbbx3l3hg7b1njjii510alxqyw3a10y9sj";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTestMockObject perlObjectSignature
      perlTestDeep perlMROCompat
    ];
  };

  perlCatalystPluginSessionStateCookie = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-State-Cookie-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1630shg23cpk6v26fwf7xr53ml1s6l2mgirxw524nmciliczgldj";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlCatalystPluginSession perlTestMockObject
    ];
  };

  perlCatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KARMAN/${name}.tar.gz";
      sha256 = "0by8w1zbp2802f9n3sqp0cmm2q0pwnycf0jgzvvv75riicq1m9pn";
    };
    propagatedBuildInputs = [
      perlPathClass perlCatalystPluginSession perlCacheFastMmap
    ];
  };

  perlCatalystPluginStackTrace = buildPerlPackage {
    name = "Catalyst-Plugin-StackTrace-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/Catalyst-Plugin-StackTrace-0.09.tar.gz;
      sha256 = "1pywxjhvn5zmcpnxj9ba77pz1jxq4d037yd43y0ks9sc31p01ydh";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlDevelStackTrace];
  };

  perlCatalystPluginStaticSimple = buildPerlPackage {
    name = "Catalyst-Plugin-Static-Simple-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AG/AGRUNDMA/Catalyst-Plugin-Static-Simple-0.20.tar.gz;
      sha256 = "1qpicgfha81ykxzg4kjll2qw8b1rwzdgvj4s3q9s20zl86gmfr3p";
    };
    propagatedBuildInputs = [perlCatalystRuntime perlMIMETypes];
  };

  perlCatalystViewTT = buildPerlPackage {
    name = "Catalyst-View-TT-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Catalyst-View-TT-0.27.tar.gz;
      sha256 = "03xs31y9m5nrmfzpfmlzlg3ivys1gg8nwd6fvwbg72a3z36brghd";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTemplateToolkit perlClassAccessor
      perlPathClass perlTemplateTimer
    ];
  };

  perlCGISession = buildPerlPackage {
    name = "CGI-Session-3.95";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHERZODR/CGI-Session-3.95.tar.gz;
      md5 = "fe9e46496c7c711c54ca13209ded500b";
    };
  };

  perlCGISimple = buildPerlPackage {
    name = "CGI-Simple-1.106";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/CGI-Simple-1.106.tar.gz;
      sha256 = "0r0wc2260jnnch7dv7f6ailjf5w8hpqm2w146flfcchcryfxjlpg";
    };
  };

  perlClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.31.tar.gz;
      sha256 = "1a4v5qqdf9bipd6ba5n47mag0cmgwp97cid67i510aw96bcjrsiy";
    };
  };

  perlClassAccessorChained = buildPerlPackage {
    name = "Class-Accessor-Chained-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz;
      sha256 = "1lilrjy1s0q5hyr0888kf0ifxjyl2iyk4vxil4jsv0sgh39lkgx5";
    };
    propagatedBuildInputs = [perlClassAccessor];
  };

  perlClassAccessorGrouped = buildPerlPackage rec {
    name = "Class-Accessor-Grouped-0.08002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CL/CLACO/${name}.tar.gz";
      sha256 = "0y7dqf0k5zh8azkb181k1zbbcy14rhfd55yddhccbfp6v44yl7yr";
    };
    propagatedBuildInputs = [perlClassInspector perlMROCompat];
  };

  perlClassAutouse = buildPerlPackage {
    name = "Class-Autouse-1.99_02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-1.99_02.tar.gz;
      sha256 = "1jkhczx2flxrz154ps90fj9wcchkpmnp5sapwc0l92rpn7jpsf08";
    };
  };

  perlClassC3 = buildPerlPackage rec {
    name = "Class-C3-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "1xmd77ghxgn4yjd25z25df0isaz3k3b685q151x0f3537kl8cln3";
    };
  };

  perlClassC3Componentised = buildPerlPackage {
    name = "Class-C3-Componentised-1.0003";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AS/ASH/Class-C3-Componentised-1.0003.tar.gz;
      sha256 = "0lbhzz18lfp2xa8h5cmhfnqbqzhvpx4jkvga9gzwiv9ppbdpzqdp";
    };
    propagatedBuildInputs = [perlClassC3 perlClassInspector perlTestException];
  };

  perlClassDataAccessor = buildPerlPackage {
    name = "Class-Data-Accessor-0.04004";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLACO/Class-Data-Accessor-0.04004.tar.gz;
      sha256 = "0578m3rplk41059rkkjy1009xrmrdivjnv8yxadwwdk1vzidc8n1";
    };
  };

  perlClassDataInheritable = buildPerlPackage {
    name = "Class-Data-Inheritable-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz;
      sha256 = "0jpi38wy5xh6p1mg2cbyjjw76vgbccqp46685r27w8hmxb7gwrwr";
    };
  };

  perlClassFactoryUtil = buildPerlPackage rec {
    name = "Class-Factory-Util-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
  };

  perlClassInspector = buildPerlPackage {
    name = "Class-Inspector-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Inspector-1.23.tar.gz;
      sha256 = "0d15b5wls14gqcd6v2k4kbc0v0a1qfb794h49wfc4vwjk5gnpbw1";
    };
  };

  perlClassMOP = buildPerlPackage rec {
    name = "Class-MOP-0.76";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0hya7hyz80d65vf1llanasg0gszgjyc52842xxzgqhy4vvnwviyy";
    };
    propagatedBuildInputs = [
      perlMROCompat perlTaskWeaken perlTestException perlSubName perlSubIdentify
      perlDevelGlobalDestruction
    ];
  };

  perlClassSingleton = buildPerlPackage rec {
    name = "Class-Singleton-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/${name}.tar.gz";
      sha256 = "0l4iwwk91wm2mrrh4irrn6ham9k12iah1ry33k0lzq22r3kwdbyg";
    };
  };

  perlClassThrowable = buildPerlPackage {
    name = "Class-Throwable-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Class-Throwable-0.10.tar.gz;
      sha256 = "01hjrfb951c9j83ncg5drnam8vsfdgkjjv0kjshxhkl93sgnlvdl";
    };
  };

  perlClassUnload = buildPerlPackage {
    name = "Class-Unload-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Class-Unload-0.05.tar.gz;
      sha256 = "01b0j10nxbz37xnnzw3hgmpfgq09mc489kq2d8f5nswsrlk75001";
    };
    propagatedBuildInputs = [perlClassInspector];
  };

  perlCompressRawZlib = import ../development/perl-modules/Compress-Raw-Zlib {
    inherit fetchurl buildPerlPackage zlib;
  };

  perlCompressZlib = buildPerlPackage rec {
    name = "Compress-Zlib-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "1k1i539fszhxay8yllh687sw06i68g8ikw51pvy1c84p3kg6yk4v";
    };
    propagatedBuildInputs = [
      perlCompressRawZlib perlIOCompressBase perlIOCompressGzip
    ];
  };

  perlConfigAny = buildPerlPackage {
    name = "Config-Any-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Config-Any-0.14.tar.gz;
      sha256 = "1vlr4w2m88figac5pblg6ppzrm11x2pm7r05n48s84cp4mizhim1";
    };
  };

  perlConfigGeneral = buildPerlPackage {
    name = "Config-General-2.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TL/TLINDEN/Config-General-2.40.tar.gz;
      sha256 = "0wf6dpaanaiy0490dlgs3pi3xvvijs237x9izb00cnzggxcfmsnz";
    };
  };

  perlconstant = buildPerlPackage {
    name = "constant-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/constant-1.15.tar.gz;
      sha256 = "1ygz0hd1fd3q88r6dlw14kpyh06zjprksdci7qva6skxz3261636";
    };
  };

  perlCryptCBC = buildPerlPackage rec {
    name = "Crypt-CBC-2.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "0cvigpxvwn18kb5i40jlp5fgijbhncvlh23xdgs1cnhxa17yrgwx";
    };
  };

  perlCryptDES = buildPerlPackage rec {
    name = "Crypt-DES-2.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1w12k1b7868v3ql0yprswlz2qri6ja576k9wlda7b8zf2d0rxgmp";
    };
    buildInputs = [perlCryptCBC];
  };

  perlCryptPasswordMD5 = buildPerlPackage {
    name = "Crypt-PasswdMD5-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LU/LUISMUNOZ/Crypt-PasswdMD5-1.3.tar.gz;
      sha256 = "13j0v6ihgx80q8jhyas4k48b64gnzf202qajyn097vj8v48khk54";
    };
  };

  perlDataDump = buildPerlPackage {
    name = "Data-Dump-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.11.tar.gz;
      sha256 = "0h5y40b6drgsf87nhwhqx1dprq70f98ibm03l9al4ndq7mrx97dd";
    };
  };

  perlDataHierarchy = buildPerlPackage {
    name = "Data-Hierarchy-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz;
      sha256 = "1vfrkygdaq0k7006i83jwavg9wgszfcyzbl9b7fp37z2acmyda5k";
    };
    propagatedBuildInputs = [perlTestException];
  };

  perlDataOptList = buildPerlPackage rec {
    name = "Data-OptList-0.104";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1k1qvf3ik2rn9mg65ginv3lyy6dlg1z08yddcnzbnizs8vbqqaxd";
    };
    propagatedBuildInputs = [perlSubInstall perlParamsUtil];
  };

  perlDataPage = buildPerlPackage {
    name = "Data-Page-2.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Data-Page-2.01.tar.gz;
      sha256 = "0mvhlid9qx9yd94rgr4lfz9kvflimc1dzcah0x7q5disw39aqrzr";
    };
    propagatedBuildInputs = [perlTestException perlClassAccessorChained];
  };

  perlDataVisitor = buildPerlPackage {
    name = "Data-Visitor-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Data-Visitor-0.21.tar.gz;
      sha256 = "10cjh3rrqi4gwrmkpzilzmaqdrh71wr59035s6b4p2dzd117p931";
    };
    propagatedBuildInputs = [
      perlTestMockObject perlMouse perlTaskWeaken perlTieUseOk perlTieToObject
      perlNamespaceClean
    ];
  };

  perlDateCalc = buildPerlPackage {
    name = "Date-Calc-5.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-5.4.tar.gz;
      sha256 = "1q7d1sy9ka1akpbysgwj673i7wiwb48yjv6wx1v5dhxllyxlxqc8";
    };
    propagatedBuildInputs = [perlCarpClan perlBitVector];
  };

  perlDateManip = buildPerlPackage {
    name = "DateManip-5.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-5.54.tar.gz;
      sha256 = "0ap2jgqx7yvjsyph9zsvadsih41cj991j3jwgz5261sq7q74y7xn";
    };
  };

  perlDateTime = buildPerlPackage rec {
    name = "DateTime-0.4501";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1hqhc4xfjgcc1r488gjbi498ws3pxiayabl46607lq02qddcv57s";
    };
    propagatedBuildInputs = [perlDateTimeLocale perlDateTimeTimeZone];
  };

  perlDateTimeFormatBuilder = buildPerlPackage rec {
    name = "DateTime-Format-Builder-0.7901";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "08zl89gh5lkff8736fkdnrf6dgppsjbmymnysbc06s7igd4ig8zf";
    };
    propagatedBuildInputs = [
      perlDateTime perlParamsValidate perlTaskWeaken perlDateTimeFormatStrptime
      perlClassFactoryUtil
    ];
    buildInputs = [perlTestPod];
  };

  perlDateTimeFormatNatural = buildPerlPackage rec {
    name = "DateTime-Format-Natural-0.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHUBIGER/${name}.tar.gz";
      sha256 = "0hq33s5frfa8cpj2al7qi0sbmimm5sdlxf0h3b57fjm9x5arlkcn";
    };
    propagatedBuildInputs = [
      perlDateTime perlListMoreUtils perlParamsValidate perlDateCalc
      perlTestMockTime perlBoolean
    ];
  };

  perlDateTimeFormatStrptime = buildPerlPackage rec {
    name = "DateTime-Format-Strptime-1.0800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RICKM/${name}.tgz";
      sha256 = "10vsmwlhnc62krsh5fm2i0ya7bgjgjsm6nmj56f0bfifjh57ya1j";
    };
    propagatedBuildInputs = [
      perlDateTime perlDateTimeLocale perlDateTimeTimeZone perlParamsValidate
    ];
  };

  perlDateTimeLocale = buildPerlPackage rec {
    name = "DateTime-Locale-0.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1cvp9a4j6vy3xpbv6ipzcz1paw7gzal7lkrbm5ipiilji47d5gaw";
    };
    propagatedBuildInputs = [perlListMoreUtils perlParamsValidate];
  };

  perlDateTimeTimeZone = buildPerlPackage rec {
    name = "DateTime-TimeZone-0.84";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0jwbldr3x1cl2ibd9dcshdmpg6s5ddc4qiaxcxyqc82cq09ah2vs";
    };
    propagatedBuildInputs = [perlClassSingleton perlParamsValidate];
  };

  perlDBDSQLite = import ../development/perl-modules/DBD-SQLite {
    inherit fetchurl buildPerlPackage perlDBI sqlite;
  };

  perlDBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl perl db4;
  };

  perlDBI = buildPerlPackage {
    name = "DBI-1.607";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/DBI-1.607.tar.gz;
      sha256 = "053ysk2a4njhzq5p59v5s6jzyi0yqr8l6wkswbvy4fyil3ka343h";
    };
  };

  perlDBIxClass = buildPerlPackage rec {
    name = "DBIx-Class-0.08011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/${name}.tar.gz";
      sha256 = "0bdp2hqbxdn0xzjja0wcynwvq36z2vwz7yx5w34s82g59pmf5dbx";
    };
    propagatedBuildInputs = [
      perlTestNoWarnings perlTestException perlDBI perlScopeGuard
      perlPathClass perlClassInspector perlClassAccessorGrouped
      perlCarpClan perlTestWarn perlDataPage perlSQLAbstract
      perlSQLAbstractLimit perlClassC3 perlClassC3Componentised
      perlModuleFind perlDBDSQLite perlJSONAny perlSubName
    ];
    buildInputs = [perlTestPod perlTestPodCoverage];
    doCheck = false; /* it says "8 subtests UNEXPECTEDLY SUCCEEDED" */
  };

  perlDBIxClassHTMLWidget = buildPerlPackage rec {
    name = "DBIx-Class-HTMLWidget-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/${name}.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [perlDBIxClass perlHTMLWidget];
  };

  perlDBIxClassSchemaLoader = buildPerlPackage rec {
    name = "DBIx-Class-Schema-Loader-0.04005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "1adymxsh1q7y1d3x25mar1rz6nshag16h6bfzhwy0w50qd2vvx9l";
    };
    propagatedBuildInputs = [
      perlDBI perlDBDSQLite perlDataDump perlUNIVERSALrequire
      perlClassAccessor perlClassDataAccessor perlClassC3 perlCarpClan
      perlClassInspector perlDBIxClass perlLinguaENInflectNumber
      perlClassUnload
    ];
  };

  perlDevelGlobalDestruction = buildPerlPackage rec {
    name = "Devel-GlobalDestruction-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NU/NUFFIN/${name}.tar.gz";
      sha256 = "174m5dx2z89h4308gx6s6vmg93qzaq0bh9m91hp2vqbyialnarhw";
    };
    propagatedBuildInputs = [perlSubExporter perlScopeGuard];
  };

  perlDevelStackTrace = buildPerlPackage rec {
    name = "Devel-StackTrace-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "15zh9gzhw6gv7l6sklp02pfmiiv8kwmmjsyvirppsca6aagy4603";
    };
  };

  perlDevelSymdump = buildPerlPackage rec {
    name = "Devel-Symdump-2.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "0qzj68zw1yypk8jw77h0w5sdpdcrp4xcmgfghcfyddjr2aim60x5";
    };
    propagatedBuildInputs = [
      perlTestPod /* cyclic dependency: perlTestPodCoverage */
    ];
  };

  perlDigestHMAC = buildPerlPackage {
    name = "Digest-HMAC-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.01.tar.gz;
      sha256 = "042d6nknc5icxqsy5asrh8v2shmvg7b3vbj95jyk4sbqlqpacwz3";
    };
    propagatedBuildInputs = [perlDigestSHA1];
  };

  perlDigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.11.tar.gz;
      md5 = "2449bfe21d6589c96eebf94dae24df6b";
    };
  };

  perlEmailAddress = buildPerlPackage {
    name = "Email-Address-1.888";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.888.tar.gz;
      sha256 = "0c6b8djnmiy0niskrvywd6867xd1qmn241ffdwj957dkqdakq9yx";
    };
  };

  perlEmailSend = buildPerlPackage {
    name = "Email-Send-2.185";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Send-2.185.tar.gz;
      sha256 = "0pbgnnbmv6z3zzqaiq1sdcv5d26ijhw4p8k8kp6ac7arvldblamz";
    };
    propagatedBuildInputs = [perlEmailSimple perlEmailAddress perlModulePluggable perlReturnValue];
  };

  perlEmailSimple = buildPerlPackage {
    name = "Email-Simple-2.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Simple-2.003.tar.gz;
      sha256 = "0h8873pidhkqy7415s5sx8z614d0haxiknbjwrn65icrr2m0b8g6";
    };
  };

  perlEmailValid = buildPerlPackage {
    name = "Email-Valid-0.179";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Valid-0.179.tar.gz;
      sha256 = "13yfjll63cp1y4xqzdcr1mjhfncn48v6hckk5mvwi47w3ccj934a";
    };
    propagatedBuildInputs = [perlMailTools perlNetDNS];
    doCheck = false;
  };

  perlEncode = buildPerlPackage {
    name = "Encode-2.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-2.25.tar.gz;
      sha256 = "0prwmbg3xh1lqskianwrfrgasdfmz4kjm3qpdm27ay110jkk25ak";
    };
  };

  perlExtUtilsInstall = buildPerlPackage {
    name = "ExtUtils-Install-1.50";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YV/YVES/ExtUtils-Install-1.50.tar.gz;
      sha256 = "18fr056fwnnhvgc646crx2p9mybf69mh5rkcphc7bbvahw9i61jy";
    };
    propagatedBuildInputs = [perlExtUtilsMakeMaker];
  };

  perlExtUtilsMakeMaker = buildPerlPackage {
    name = "ExtUtils-MakeMaker-6.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/ExtUtils-MakeMaker-6.44.tar.gz;
      sha256 = "0zyypnlmmyp06qbfdpc14rp5rj63066mjammn6rlcqz2iil9mpcj";
    };
  };

  perlExtUtilsManifest = buildPerlPackage {
    name = "ExtUtils-Manifest-1.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKOBES/ExtUtils-Manifest-1.53.tar.gz;
      sha256 = "0xgfzivw0dfy29ydfjkg0c9mvlhjvlhc54s0yvbb4sxb2mdvrfkp";
    };
  };

  perlFilechdir = buildPerlPackage {
    name = "File-chdir-0.1002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/File-chdir-0.1002.tar.gz;
      sha256 = "1fc2l754bxsizli3injm4wqf8dn03iq16rmfn62l99nxpibl5k6p";
    };
  };

  perlFileCopyRecursive = buildPerlPackage {
    name = "File-Copy-Recursive-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.37.tar.gz;
      sha256 = "12j0s01zwm67g4bcgbs0k61jwz59q1lndrnxyywxsz3xd30ki8rr";
    };
  };

  perlFileModified = buildPerlPackage {
    name = "File-Modified-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/File-Modified-0.07.tar.gz;
      sha256 = "11zkg171fa5vdbyrbfcay134hhgyf4yaincjxwspwznrfmkpi49h";
    };
  };

  perlFileShareDir = buildPerlPackage rec {
    name = "File-ShareDir-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1afr1r1ys2ij8i4r0i85hfrgrbvcha8c7cgkhcrdya1f0lnpw59z";
    };
    propagatedBuildInputs = [perlClassInspector perlParamsUtil];
  };

  perlFileTemp = buildPerlPackage {
    name = "File-Temp-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJENNESS/File-Temp-0.20.tar.gz;
      sha256 = "0n7lr7mpdvwgznw469qdpdmac627a26wp615dkpzanc452skad4v";
    };
  };

  perlFreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.43.tar.gz;
      sha256 = "1qamc5aggp35xk590a4hy660f2rhc2l7j65hbyxdya9yvg7z437l";
    };
  };

  perlHTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "03lc4pvygp4wn9rsgdkbwk8zkh8x2z5vp8613c6q74imwrfmmfqy";
    };
    propagatedBuildInputs = [
      perlClassAccessorChained perlClassC3 perlConfigAny
      perlDateCalc perlListMoreUtils perlLWP perlEmailValid
      perlDataVisitor perlDateTime perlDateTimeFormatBuilder
      perlDateTimeFormatStrptime perlDateTimeFormatNatural
      perlReadonly perlYAMLSyck perlRegexpCopy
      perlHTMLTokeParserSimple perlTestNoWarnings perlRegexpCommon
      perlCaptchaReCAPTCHA perlHTMLScrubber perlFileShareDir
      perlTemplateToolkit perlCryptCBC perlCryptDES
    ];
  };

  perlHTMLParser = buildPerlPackage {
    name = "HTML-Parser-3.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Parser-3.56.tar.gz;
      sha256 = "0x1h42r54aq4yqpwi7mla4jzia9c5ysyqh8ir2nav833f9jm6g2h";
    };
    propagatedBuildInputs = [perlHTMLTagset];
  };

  perlHTMLScrubber = buildPerlPackage {
    name = "HTML-Scrubber-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/PODMASTER/HTML-Scrubber-0.08.tar.gz;
      sha256 = "0xb5zj67y2sjid9bs3yfm81rgi91fmn38wy1ryngssw6vd92ijh2";
    };
    propagatedBuildInputs = [perlHTMLParser];
  };

  perlHTMLTagset = buildPerlPackage {
    name = "HTML-Tagset-3.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/HTML-Tagset-3.10.tar.gz;
      sha256 = "05k292qy7jzjlmmybis8nncpnwwa4jfkm7q3gq6866ydxrzds9xh";
    };
  };

  perlHTMLTiny = buildPerlPackage rec {
    name = "HTML-Tiny-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "1nc9vr0z699jwv8jaxxpkfhspiv7glhdp500hqyzdm2jxfw8azrg";
    };
  };

  perlHTMLTokeParserSimple = buildPerlPackage rec {
    name = "HTML-TokeParser-Simple-3.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "0ii1ww17h7wps1lcj7bxrjbisa37f6cvlm0xxpgfq1s6iy06q05b";
    };
    propagatedBuildInputs = [perlHTMLParser perlSubOverride];
    buildInputs = [perlTestPod];
  };

  perlHTMLTree = buildPerlPackage {
    name = "HTML-Tree-3.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETEK/HTML-Tree-3.23.tar.gz;
      sha256 = "1pn80f4g1wixs030f40b80wrj12kwfinwycrx3f10drg4v7ml5zm";
    };
    propagatedBuildInputs = [perlHTMLParser];
  };

  perlHTMLWidget = buildPerlPackage {
    name = "HTML-Widget-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz;
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    propagatedBuildInputs = [
      perlTestNoWarnings perlClassAccessor perlClassAccessorChained
      perlClassDataAccessor perlModulePluggableFast perlHTMLTree
      perlHTMLScrubber perlEmailValid perlDateCalc
    ];
  };

  perlHTTPBody = buildPerlPackage rec {
    name = "HTTP-Body-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "0s0496sb9l8jfkdx86vahwgdaaxrqb0j6acyww6nk0ajh82qrzfv";
    };
    propagatedBuildInputs = [perlLWP perlYAML];
  };

  perlHTTPRequestAsCGI = buildPerlPackage {
    name = "HTTP-Request-AsCGI-0.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHANSEN/HTTP-Request-AsCGI-0.5.tar.gz;
      sha256 = "164159iiyk0waqayplchkisxg2ldamx8iifrccx32p344714qcrh";
    };
    propagatedBuildInputs = [perlClassAccessor perlLWP];
  };

  perlHTTPResponseEncoding = buildPerlPackage rec {
    name = "HTTP-Response-Encoding-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANKOGAI/${name}.tar.gz";
      sha256 = "04gdl633g0s2ckn7zixcma2krbpfcd46jngg155qpdx5sdwfkm16";
    };
    propagatedBuildInputs = [perlLWP];
  };

  perlHTTPServerSimple = buildPerlPackage rec {
    name = "HTTP-Server-Simple-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JE/JESSE/${name}.tar.gz";
      sha256 = "1m1lmpbg0zhiv2vyc3fyyqfsv3jhhb2mbdl5624fqb0va2pnla6n";
    };
    propagatedBuildInputs = [perlURI];
    doCheck = false;
  };

  perlI18NLangTags = buildPerlPackage {
    name = "I18N-LangTags-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/I18N-LangTags-0.35.tar.gz;
      sha256 = "0idwfi7k8l44d9akpdj6ygdz3q8zxr690m18s7w23ms9d55bh3jy";
    };
  };

  perlIOCompressBase = buildPerlPackage rec {
    name = "IO-Compress-Base-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "10njlwa50mhs5nqws5yidfmmb7hwmwc6x06gk2vnpyn82g3szgqd";
    };
  };

  perlIOCompressGzip = buildPerlPackage rec {
    name = "IO-Compress-Zlib-2.015";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
      sha256 = "0sbnx6xdryaajwpssrfgm5b2zasa4ri8pihqwsx3rm5kmkgzy9cx";
    };
    propagatedBuildInputs = [perlIOCompressBase perlCompressRawZlib];
  };

  perlIODigest = buildPerlPackage {
    name = "IO-Digest-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.10.tar.gz;
      sha256 = "1g6ilxqv2a7spf273v7k0721c6am7pwpjrin3h5zaqxfmd312nav";
    };
    propagatedBuildInputs = [perlPerlIOviadynamic];
  };

  perlIOPager = buildPerlPackage {
    name = "IO-Pager-0.06.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-0.06.tgz;
      sha256 = "0r3af4gyjpy0f7bhs7hy5s7900w0yhbckb2dl3a1x5wpv7hcbkjb";
    };
  };

  perlIPCRun = buildPerlPackage rec {
    name = "IPC-Run-0.82";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1v5yfavvhxscqkdl68xs7i7vcp9drl3y1iawppzwqcl1fprd58ip";
    };
    doCheck = false; /* attempts a network connection to localhost */
  };

  perlJSON = buildPerlPackage {
    name = "JSON-2.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-2.12.tar.gz;
      sha256 = "0qbxfwvfsx8s50h2dzpb0z7qi22k9ghygfzbfk8v08kkpmrkls47";
    };
    propagatedBuildInputs = [perlJSONXS];
  };

  perlJSONAny = buildPerlPackage {
    name = "JSON-Any-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/JSON-Any-1.17.tar.gz;
      sha256 = "07y6zb0vzb4c87k2lflxafb69zc4a29bxhzh6xdcpjhplf4vbifb";
    };
    propagatedBuildInputs = [perlJSON];
  };

  perlJSONXS = buildPerlPackage {
    name = "JSON-XS-2.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-2.23.tar.gz;
      sha256 = "0yd1j5d9b0ymfzfaxyi9zgca3vqwjb3dl8pg14m1qwsx3pidd5j7";
    };
  };

  perlLinguaENInflect = buildPerlPackage {
    name = "Lingua-EN-Inflect-1.89";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.89.tar.gz;
      sha256 = "1jvj67mvvfqxgxspmblay1c844vvhfwrviiarglkaw6phpg74rby";
    };
  };

  perlLinguaENInflectNumber = buildPerlPackage {
    name = "Lingua-EN-Inflect-Number-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMON/Lingua-EN-Inflect-Number-1.1.tar.gz;
      sha256 = "13hlr1srp9cd9mcc78snkng9il8iavvylfyh81iadvn2y7wikwfy";
    };
    propagatedBuildInputs = [perlLinguaENInflect];
  };

  perlListMoreUtils = buildPerlPackage {
    name = "List-MoreUtils-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPARSEVAL/List-MoreUtils-0.22.tar.gz;
      sha256 = "1dv21xclh6r1cyy19r34xv2w6pc1jb5pwj7b2739m78xhlk8p55l";
    };
  };

  perlLocaleGettext = buildPerlPackage {
    name = "LocaleGettext-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.05.tar.gz;
      sha256 = "15262a00vx714szpx8p2z52wxkz46xp7acl72znwjydyq4ypydi7";
    };
  };

  perlLocaleMaketext = buildPerlPackage {
    name = "Locale-Maketext-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Locale-Maketext-1.13.tar.gz;
      sha256 = "0qvrhcs1f28ix3v8hcd5xr4z9s7plz4g5a4q1cjp7bs0c3w2yl6z";
    };
    propagatedBuildInputs = [perlI18NLangTags];
  };

  perlLocaleMaketextLexicon = buildPerlPackage {
    name = "Locale-Maketext-Lexicon-0.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Lexicon-0.66.tar.gz;
      sha256 = "1cd2kbcrlyjcmlr7m8kf94mm1hlr7hpv1r80a596f4ljk81f2nvd";
    };
    propagatedBuildInputs = [perlLocaleMaketext];
  };

  perlLocaleMaketextSimple = buildPerlPackage {
    name = "Locale-Maketext-Simple-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Simple-0.18.tar.gz;
      sha256 = "14kx7vkxyfqndy90rzavrjp2346aidyc7x5dzzdj293qf8s4q6ig";
    };
  };

  perlLWP = buildPerlPackage rec {
    name = "libwww-perl-5.823";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1pz65p02dcy1yf4l1zhhwjmnh6fvf8q71nsmhjpc5lydsf35h1ql";
    };
    propagatedBuildInputs = [perlURI perlHTMLParser perlHTMLTagset];
  };

  perlMailTools = buildPerlPackage {
    name = "MailTools-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MailTools-2.04.tar.gz;
      sha256 = "0w91rcrz4v0pjdnnv2mvlbrm9ww32f7ajhr7xkjdhhr3455p7adx";
    };
    propagatedBuildInputs = [perlTimeDate perlTestPod];
  };

  perlMIMETypes = buildPerlPackage {
    name = "MIME-Types-1.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MIME-Types-1.24.tar.gz;
      sha256 = "1j89kjv9lipv6r3bq6dp0k9b8y1f8z9vrmhi7b8h7cs1yc8g7qz9";
    };
    propagatedBuildInputs = [perlTestPod];
  };

  perlModuleBuild = buildPerlPackage {
    name = "Module-Build-0.2808";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Module-Build-0.2808.tar.gz;
      sha256 = "1h8zpf4g2n8v47l9apmdqbdgcg039g70w75hpn84m37pmqkbnj8v";
    };
    propagatedBuildInputs = [perlExtUtilsInstall perlExtUtilsManifest perlTestHarness];
  };

  perlModuleFind = buildPerlPackage {
    name = "Module-Find-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.06.tar.gz;
      sha256 = "1394jk0rn2zmchpl11kim69xh5h5yzg96jdlf76fqrk3dcn0y2ip";
    };
  };

  perlMoose = buildPerlPackage rec {
    name = "Moose-0.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "0ncpa8v0yv7lkn108943sjll3gps5nkzn6a51ngvqq1rnsd34ar1";
    };
    propagatedBuildInputs = [
      perlTestMore perlTestException perlTaskWeaken perlListMoreUtils
      perlClassMOP perlSubExporter
    ];
  };

  perlMouse = buildPerlPackage {
    name = "Mouse-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SARTAK/Mouse-0.09.tar.gz;
      sha256 = "1akymbjim6w6i1q8h97izah26ndmcbnl1lwdsw9fa22hnhm0axg0";
    };
  };

  perlMROCompat = buildPerlPackage {
    name = "MRO-Compat-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BL/BLBLACK/MRO-Compat-0.09.tar.gz;
      sha256 = "16l37bxd5apax4kyvnadiplz8xmmx76y9pyq9iksqrv0d5rl5vl8";
    };
  };

  perlNamespaceClean = buildPerlPackage {
    name = "namespace-clean-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHAYLON/namespace-clean-0.08.tar.gz;
      sha256 = "1jwc15zz1j6indqgz64l09ayg0db4gfaasq74x0vyi1yx3d9x2yx";
    };
    propagatedBuildInputs = [perlScopeGuard];
  };

  perlNetDNS = buildPerlPackage {
    name = "Net-DNS-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OL/OLAF/Net-DNS-0.63.tar.gz;
      sha256 = "1pswrwhkav051xahm3k4cbyhi8kqpfmaz85lw44kwi2wc7mz4prk";
    };
    propagatedBuildInputs = [perlNetIP perlDigestHMAC];
    doCheck = false;
  };

  perlNetIP = buildPerlPackage {
    name = "Net-IP-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.25.tar.gz;
      sha256 = "1iv0ka6d8kp9iana6zn51sxbcmz2h3mbn6cd8pald36q5whf5mjc";
    };
  };

  perlObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.05.tar.gz;
      sha256 = "10k9j18jpb16brv0hs7592r7hx877290pafb8gnk6ydy7hcq9r2j";
    };
  };

  perlParamsUtil = buildPerlPackage rec {
    name = "Params-Util-0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1n36vhahbs2mfck5x6g8ab9280zji9zwc5092jiq78s791227cb6";
    };
  };

  perlParamsValidate = buildPerlPackage rec {
    name = "Params-Validate-0.91";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1j0hx3pbfdyggbhrawa9k0wdm6lln3zdkrhjrdg1hzzf6csrlc1v";
    };
  };

  perlParent = buildPerlPackage {
    name = "parent-0.221";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.221.tar.gz;
      sha256 = "17jhscpa5p5szh1173pd6wvh2m05an1l941zqq9jkw9bzgk12hm0";
    };
  };

  perlPathClass = buildPerlPackage {
    name = "Path-Class-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.16.tar.gz;
      sha256 = "0zisxkj58jm84fwcssmdq8g6n37s33v5h7j28m12sbkqib0h76gc";
    };
  };

  perlPerlIOeol = buildPerlPackage {
    name = "PerlIO-eol-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/PerlIO-eol-0.14.tar.gz;
      sha256 = "1rwj0r075jfvvd0fnzgdqldc7qdb94wwsi21rs2l6yhcv0380fs2";
    };
  };

  perlPerlIOviadynamic = buildPerlPackage {
    name = "PerlIO-via-dynamic-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-dynamic-0.12.tar.gz;
      sha256 = "140hay9q8q9sz1fa2s57ijp5l2448fkcg7indgn6k4vc7yshmqz2";
    };
  };

  perlPerlIOviasymlink = buildPerlPackage {
    name = "PerlIO-via-symlink-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz;
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };
  };

  perlModulePluggable = buildPerlPackage {
    name = "Module-Pluggable-3.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMONW/Module-Pluggable-3.5.tar.gz;
      sha256 = "08rywi79pqn2c8zr17fmd18lpj5hm8lxd1j4v2k002ni8vhl43nv";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
  };

  perlModulePluggableFast = buildPerlPackage {
    name = "Module-Pluggable-Fast-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Module-Pluggable-Fast-0.18.tar.gz;
      sha256 = "140c311x2darrc2p1drbkafv7qwhzdcff4ad300n6whsx4dfp6wr";
    };
    propagatedBuildInputs = [perlUNIVERSALrequire];
  };

  perlPodCoverage = buildPerlPackage rec {
    name = "Pod-Coverage-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "1krsz4zwmnmq3z29p5vmyr5fdzrn8v0sg6rf3qxk7xpxw4z5np84";
    };
    propagatedBuildInputs = [perlDevelSymdump];
  };

  perlPodEscapes = buildPerlPackage {
    name = "Pod-Escapes-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/Pod-Escapes-1.04.tar.gz;
      sha256 = "1wrg5dnsl785ygga7bp6qmakhjgh9n4g3jp2l85ab02r502cagig";
    };
  };

  perlPodSimple = buildPerlPackage {
    name = "Pod-Simple-3.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARANDAL/Pod-Simple-3.05.tar.gz;
      sha256 = "1j0kqcvr9ykcqlkr797j1npkbggykb3p4w5ri73s8mi163lzxkqb";
    };
    propagatedBuildInputs = [perlconstant perlPodEscapes];
  };

  perlReadonly = buildPerlPackage rec {
    name = "Readonly-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "1shkyxajh6l87nif47ygnfxjwvqf3d3kjpdvxaff4957vqanii2k";
    };
  };

  perlRegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.34";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "173dnzi3dag88afr4xf5v0hki15cfaffyjimjfmvzv6gbx6fp96f";
    };
  };

  perlRegexpCommon = buildPerlPackage rec {
    name = "Regexp-Common-2.122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABIGAIL/${name}.tar.gz";
      sha256 = "1mi411nfsx58nfsgjsbyck50x9d0yfvwqpw63iavajlpx1z38n8r";
    };
  };

  perlRegexpCopy = buildPerlPackage rec {
    name = "Regexp-Copy-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDUNCAN/${name}.tar.gz";
      sha256 = "09c8xb43p1s6ala6g4274az51mf33phyjkp66dpvgkgbi1xfnawp";
    };
  };

  perlReturnValue = buildPerlPackage {
    name = "Return-Value-1.302";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.302.tar.gz;
      sha256 = "0hf5rmfap49jh8dnggdpvapy5r4awgx5hdc3acc9ff0vfqav8azm";
    };
  };

  perlScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.03.tar.gz;
      sha256 = "07x966fkqxlwnngxs7a2jrhabh8gzhjfpqq56n9gkwy7f340sayb";
    };
  };

  perlSetObject = buildPerlPackage {
    name = "Set-Object-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMV/Set-Object-1.26.tar.gz;
      sha256 = "1hx3wrw8xkvaggacc8zyn86hfi3079ahmia1n8vsw7dglp1bbhmj";
    };
  };

  perlSQLAbstract = buildPerlPackage {
    name = "SQL-Abstract-1.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSTROUT/SQL-Abstract-1.24.tar.gz;
      sha256 = "0vnpnca9cahnk0zgzqkngcwyzjqnckar0jwp3vyhj9hcaylirnvg";
    };
  };

  perlSQLAbstractLimit = buildPerlPackage rec {
    name = "SQL-Abstract-Limit-0.141";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVEBAIRD/${name}.tar.gz";
      sha256 = "1qqh89kz065mkgyg5pjcgbf8qcpzfk8vf1lgkbwynknadmv87zqg";
    };
    propagatedBuildInputs = [
      perlSQLAbstract perlTestException perlDBI perlTestDeep
    ];
    buildInputs = [perlTestPod perlTestPodCoverage];
  };

  perlStringMkPasswd = buildPerlPackage {
    name = "String-MkPasswd-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.02.tar.gz;
      sha256 = "0si4xfgf8c2pfag1cqbr9jbyvg3hak6wkmny56kn2qwa4ljp9bk6";
    };
  };

  perlSubExporter = buildPerlPackage rec {
    name = "Sub-Exporter-0.982";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0xf8q05k5xs3bw6qy3pnnl5d670njxsxbw2dprl7n50hf488cbvj";
    };
    propagatedBuildInputs = [perlSubInstall perlDataOptList perlParamsUtil];
  };

  perlSubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "16g4dkmb4h5hh15jsq0kvsf3irrlrlqdv7qk6605wh5gjjwbcjxy";
    };
  };

  perlSubInstall = buildPerlPackage rec {
    name = "Sub-Install-0.925";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "1sccc4nwp9y24zkr42ww2gwg6zwax4madi9spsdym1pqna3nwnm6";
    };
  };

  perlSubName = buildPerlPackage {
    name = "Sub-Name-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XM/XMATH/Sub-Name-0.04.tar.gz;
      sha256 = "1nlin0ag2krpmiyapp3lzb6qw2yfqvqmx57iz5zwbhr4pyi46bhb";
    };
  };

  perlSubOverride = buildPerlPackage rec {
    name = "Sub-Override-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "13s5zi6qz02q50vv4bmwdmhn9gvg0988fydjlrrv500g6hnyzlkj";
    };
    propagatedBuildInputs = [perlSubUplevel perlTestException];
  };

  perlSubUplevel = buildPerlPackage {
    name = "Sub-Uplevel-0.2002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2002.tar.gz;
      sha256 = "19b2b9xsw7lvvkcmmnhhv8ybxdkbnrky9nnqgjridr108ww9m5rh";
    };
  };

  perlSVK = buildPerlPackage {
    name = "SVK-v2.0.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVK-v2.0.2.tar.gz;
      sha256 = "0c4m2q7cvzwh9kk1nc1vd8lkxx2kss5nd4k20dpkal4c7735jns0";
    };
    propagatedBuildInputs = [perlAlgorithmDiff perlAlgorithmAnnotate perlAppCLI perlClassDataInheritable perlDataHierarchy perlEncode perlFileTemp perlIODigest perlListMoreUtils perlPathClass perlPerlIOeol perlPerlIOviadynamic perlPerlIOviasymlink perlPodEscapes perlPodSimple perlSVNMirror perlTimeHiRes perlUNIVERSALrequire perlURI perlYAMLSyck perlClassAutouse perlIOPager perlLocaleMaketextLexicon perlFreezeThaw];
  };

  perlSVNMirror = buildPerlPackage {
    name = "SVN-Mirror-0.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Mirror-0.73.tar.gz;
      sha256 = "1scjaq7qjz6jlsk1c2l5q15yxf0sqbydvf22mb2xzy1bzaln0x2c";
    };
    propagatedBuildInputs = [perlClassAccessor perlFilechdir subversion perlURI perlTermReadKey perlTimeDate perlSVNSimple];
  };

  perlSVNSimple = buildPerlPackage {
    name = "SVN-Simple-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Simple-0.27.tar.gz;
      sha256 = "0p7p52ja6sf4j0w3b05i0bbqi5wiambckw2m5dsr63bbmlhv4a71";
    };
    propagatedBuildInputs = [subversion];
  };

  perlTaskCatalystTutorial = buildPerlPackage rec {
    name = "Task-Catalyst-Tutorial-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "0mqn64bspz1rq6m62yvy1gvmm0swz8xfhh8rg2p024v7g2qcyiy8";
    };
    propagatedBuildInputs = [
      perlCatalystManual perlCatalystRuntime perlCatalystDevel
      perlCatalystPluginSession perlCatalystPluginAuthentication
      perlCatalystPluginAuthenticationStoreDBIC
      perlCatalystPluginAuthenticationStoreDBIxClass
      perlCatalystPluginAuthorizationRoles
      perlCatalystPluginAuthorizationACL
      perlCatalystPluginHTMLWidget
      perlCatalystPluginSessionStoreFastMmap
      perlCatalystPluginStackTrace
      perlCatalystViewTT
      perlDBIxClass perlDBIxClassHTMLWidget
      perlCatalystControllerHTMLFormFu
    ];
    buildInputs = [perlTestPodCoverage];
  };

  perlTaskWeaken = buildPerlPackage {
    name = "Task-Weaken-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Task-Weaken-1.02.tar.gz;
      sha256 = "10f9kd1lwbscmmjwgbfwa4kkp723mb463lkbmh29rlhbsl7kb5wz";
    };
  };

  perlTemplateTimer = buildPerlPackage {
    name = "Template-Timer-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-0.04.tar.gz;
      sha256 = "0j0gmxbq1svp0rb4kprwj2fk2mhl07yah08bksfz0a0pfz6lsam4";
    };
    propagatedBuildInputs = [perlTemplateToolkit];
  };

  perlTemplateToolkit = buildPerlPackage {
    name = "Template-Toolkit-2.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-2.20.tar.gz;
      sha256 = "13wbh06a76k4ag14lhszmpwv4hb8hlj1d9glizhp8izazl3xf1zg";
    };
    propagatedBuildInputs = [perlAppConfig];
    patches = [
      # Needed to make TT works properly on templates in the Nix store.
      ../development/perl-modules/template-toolkit-nix-store.patch
    ];
  };

  perlTermReadKey = buildPerlPackage {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  perlTestDeep = buildPerlPackage {
    name = "Test-Deep-0.103";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Deep-0.103.tar.gz;
      sha256 = "0cdl08k5v0wc9w20va5qw98ynlbs9ifwndgsix8qhi7h15sj8a5j";
    };
    propagatedBuildInputs = [perlTestTester perlTestNoWarnings];
  };

  perlTestException = buildPerlPackage {
    name = "Test-Exception-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADIE/Test-Exception-0.27.tar.gz;
      sha256 = "1s921j7yv2szywd1ffi6yz3ngrbq97f9dh38bvvajqnm29g1xb9j";
    };
    propagatedBuildInputs = [perlTestHarness perlTestSimple perlSubUplevel];
  };

  perlTestHarness = buildPerlPackage {
    name = "Test-Harness-3.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/Test-Harness-3.10.tar.gz;
      sha256 = "1qd217yzppj1vbjhny06v8niqhz85pam996ry6bzi08z0jidr2wh";
    };
  };

  perlTestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "0ln3117nfxzq7yxmfk77nnr7116inbjq4bf5v2p0hqlj4damx03d";
    };
  };

  perlTestMockObject = buildPerlPackage {
    name = "Test-MockObject-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Test-MockObject-1.09.tar.gz;
      sha256 = "1cz385x0jrkj84nmfs6qyzwwvv8m9v8r2isagfj1zxvhdw49wdyy";
    };
    propagatedBuildInputs = [perlTestException perlUNIVERSALisa perlUNIVERSALcan];
  };

  perlTestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "1j2riyikzyfkxsgkfdqirs7xa8q5d06b9klpk7l9sgydwqdvxdv3";
    };
  };

  perlTestMore = perlTestSimple;

  perlTestNoWarnings = buildPerlPackage {
    name = "Test-NoWarnings-0.084";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-NoWarnings-0.084.tar.gz;
      sha256 = "19g47pa3brr9px3jnwziapvxcnghqqjjwxz1jfch4asawpdx2s8b";
    };
    propagatedBuildInputs = [perlTestTester];
  };

  perlTestPod = buildPerlPackage {
    name = "Test-Pod-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-Pod-1.26.tar.gz;
      sha256 = "025rviipiaa1rf0bp040jlwaxwvx48kdcjriaysvkjpyvilwvqd4";
    };
  };

  perlTestPodCoverage = buildPerlPackage rec {
    name = "Test-Pod-Coverage-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0y2md932zhbxdjwzskx0vmw2qy7jxkn87f9lb5h3f3vxxg1kcqz0";
    };
    propagatedBuildInputs = [perlPodCoverage];
  };

  perlTestSimple = buildPerlPackage {
    name = "Test-Simple-0.84";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Simple-0.84.tar.gz;
      sha256 = "030j47q3p46jfk60dsh2d5m7ip4nqz0fl4inqr8hx8b8q0f00r4l";
    };
    propagatedBuildInputs = [perlTestHarness];
  };

  perlTestTester = buildPerlPackage {
    name = "Test-Tester-0.107";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.107.tar.gz;
      sha256 = "0qgmsl6s6xm39211lywyzwrlz0gcmax7fb8zipybs9yxfmwcvyx2";
    };
  };

  perlTestWarn = buildPerlPackage {
    name = "Test-Warn-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Test-Warn-0.11.tar.gz;
      sha256 = "1y9g13bzvjsmg5v555zrl7w085jq40a47hfs4gc3k78s0bkwxbyi";
    };
    propagatedBuildInputs = [perlTestSimple perlTestException perlArrayCompare perlTreeDAGNode];
    buildInputs = [perlTestPod];
  };

  perlTestWWWMechanize = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-1.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "11knym5ppish78rk8r1hymvq1py43h7z8d6nk8p4ig3p246xx5qa";
    };
    propagatedBuildInputs = [
      perlCarpAssertMore perlURI perlTestLongString perlWWWMechanize
    ];
    doCheck = false;
  };

  perlTestWWWMechanizeCatalyst = buildPerlPackage rec {
    name = "Test-WWW-Mechanize-Catalyst-0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LB/LBROCARD/${name}.tar.gz";
      sha256 = "0hixz0hibv2z87kdqvrphzgww0xibgg56w7bh299dgw2739hy4yf";
    };
    propagatedBuildInputs = [
      perlCatalystRuntime perlTestWWWMechanize perlWWWMechanize
      perlCatalystPluginSessionStateCookie
    ];
    buildInputs = [perlTestPod];
    doCheck = false;
  };

  perlTextSimpleTable = buildPerlPackage {
    name = "Text-SimpleTable-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Text-SimpleTable-0.05.tar.gz;
      sha256 = "028pdfmr2gnaq8w3iar8kqvrpxcghnag8ls7h4227l9zbxd1k9p9";
    };
  };

  perlTieUseOk = buildPerlPackage {
    name = "Test-use-ok-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Test-use-ok-0.02.tar.gz;
      sha256 = "11inaxiavb35k8zwxwbfbp9wcffvfqas7k9idy822grn2sz5gyig";
    };
  };

  perlTieToObject = buildPerlPackage {
    name = "Tie-ToObject-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz;
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
    propagatedBuildInputs = [perlTieUseOk];
  };

  perlTimeDate = buildPerlPackage {
    name = "TimeDate-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/TimeDate-1.16.tar.gz;
      sha256 = "1cvcpaghn7dc14m9871sfw103g3m3a00m2mrl5iqb0mmh40yyhkr";
    };
  };

  perlTimeHiRes = buildPerlPackage {
    name = "Time-HiRes-1.9715";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHI/Time-HiRes-1.9715.tar.gz;
      sha256 = "0pgqrfkysy3mdcx5nd0x8c80lgqb7rkb3nrkii3vc576dcbpvw0i";
    };
  };

  perlTreeDAGNode = buildPerlPackage {
    name = "Tree-DAG_Node-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COGENT/Tree-DAG_Node-1.06.tar.gz;
      sha256 = "0anvwfh4vqj41ipq52p65sqlvw3rvm6cla5hbws13gyk9mvp09ah";
    };
  };

  perlTreeSimple = buildPerlPackage {
    name = "Tree-Simple-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-1.18.tar.gz;
      sha256 = "0bb2hc8q5rwvz8a9n6f49kzx992cxczmrvq82d71757v087dzg6g";
    };
    propagatedBuildInputs = [perlTestException];
  };

  perlTreeSimpleVisitorFactory = buildPerlPackage {
    name = "Tree-Simple-VisitorFactory-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-VisitorFactory-0.10.tar.gz;
      sha256 = "1ghcgnb3xvqjyh4h4aa37x98613aldnpj738z9b80p33bbfxq158";
    };
    propagatedBuildInputs = [perlTreeSimple];
    buildInputs = [perlTestException];
  };

  perlFontTTF = buildPerlPackage {
    name = "perl-Font-TTF-0.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHOSKEN/Font-TTF-0.43.tar.gz;
      sha256 = "0782mj5n5a2qbghvvr20x51llizly6q5smak98kzhgq9a7q3fg89";
    };
  };

  perlUNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.12.tar.gz;
      sha256 = "1abadbgcy11cmlmj9qf1v73ycic1qhysxv5xx81h8s4p81alialr";
    };
  };

  perlUNIVERSALisa = buildPerlPackage {
    name = "UNIVERSAL-isa-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-isa-1.00_00.tar.gz;
      sha256 = "04dj0z458k57l3phmq635bdmj3zzl2iy5dxp3yqaldc6g65wz0d0";
    };
  };

  perlUNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/UNIVERSAL-require-0.11.tar.gz;
      sha256 = "1rh7i3gva4m96m31g6yfhlqcabszhghbb3k3qwxbgx3mkf5s6x6i";
    };
  };

  perlURI = buildPerlPackage rec {
    name = "URI-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "0amwbss2gz00fkdfnfixf1afmqal1246xhmj27g5c0ny7ahcid0j";
    };
  };

  perlWWWMechanize = buildPerlPackage rec {
    name = "WWW-Mechanize-1.54";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "1yxvw5xfng5fj4422869p5dwvmrkmqph9gdm2nl12wngydk93lnh";
    };
    propagatedBuildInputs = [perlLWP perlHTTPResponseEncoding perlHTTPServerSimple];
    doCheck = false;
  };

  perlXMLDOM = buildPerlPackage {
    name = "XML-DOM-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-DOM-1.44.tar.gz;
      sha256 = "1r0ampc88ni3sjpzr583k86076qg399arfm9xirv3cw49k3k5bzn";
    };
    #buildInputs = [libxml2];
    propagatedBuildInputs = [perlXMLRegExp perlXMLParser perlLWP];
  };

  perlXMLLibXML = buildPerlPackage {
    name = "XML-LibXML-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PA/PAJAS/XML-LibXML-1.66.tar.gz;
      sha256 = "1a0bdiv3px6igxnbbjq10064iahm8f5i310p4y05w6zn5d51awyl";
    };
    buildInputs = [libxml2];
    propagatedBuildInputs = [perlXMLLibXMLCommon perlXMLSAX];
  };

  perlXMLLibXMLCommon = buildPerlPackage {
    name = "XML-LibXML-Common-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHISH/XML-LibXML-Common-0.13.tar.gz;
      md5 = "13b6d93f53375d15fd11922216249659";
    };
    buildInputs = [libxml2];
  };

  perlXMLNamespaceSupport = buildPerlPackage {
    name = "XML-NamespaceSupport-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/XML-NamespaceSupport-1.09.tar.gz;
      sha256 = "0ny2i4pf6j8ggfj1x02rm5zm9a37hfalgx9w9kxnk69xsixfwb51";
    };
    buildInputs = [];
  };

  perlXMLParser = buildPerlPackage {
    name = "XML-Parser-2.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz;
      sha256 = "0gyp5qfbflhkin1zv8l6wlkjwfjvsf45a3py4vc6ni82fj32kmcz";
    };
    makeMakerFlags = "EXPATLIBPATH=${expat}/lib EXPATINCPATH=${expat}/include";
  };

  perlXMLRegExp = buildPerlPackage {
    name = "XML-RegExp-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.03.tar.gz;
      sha256 = "1gkarylvdk3mddmchcwvzq09gpvx5z26nybp38dg7mjixm5bs226";
    };
  };

  perlXMLSAX = buildPerlPackage {
    name = "XML-SAX-0.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-0.96.tar.gz;
      sha256 = "024fbjgg6s87j0y3yik55plzf7d6qpn7slwd03glcb54mw9zdglv";
    };
    propagatedBuildInputs = [perlXMLNamespaceSupport];
  };

  perlXMLSimple = buildPerlPackage {
    name = "XML-Simple-2.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.18.tar.gz;
      sha256 = "09k8fvc9m5nd5rqq00rwm3m0wx7iwd6vx0vc947y58ydi30nfjd5";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLTwig = buildPerlPackage {
    name = "XML-Twig-3.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-Twig-3.32.tar.gz;
      sha256 = "07zdsfzw9dlrx6ril9clf1jfif09vpf27rz66laja7mvih9izd1v";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLWriter = buildPerlPackage {
    name = "XML-Writer-0.602";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOSEPHW/XML-Writer-0.602.tar.gz;
      sha256 = "0kdi022jcn9mwqsxy2fiwl2cjlid4x13r038jvi426fhjknl11nl";
    };
  };

  perlXSLoader = buildPerlPackage {
    name = "XSLoader-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.08.tar.gz;
      sha256 = "0mr4l3givrpyvz1kg0kap2ds8g0rza2cim9kbnjy8hi64igkixi5";
    };
  };

  perlYAML = buildPerlPackage rec {
    name = "YAML-0.68";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "0yg0pgsjkfczsblx03rxlw4ib92k0gwdyb1a258xb9wdg0w61h34";
    };
  };

  perlYAMLSyck = buildPerlPackage rec {
    name = "YAML-Syck-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AU/AUDREYT/${name}.tar.gz";
      sha256 = "15acwp2qdxfmhfqj4c1s57xyy48hcfc87lblww3lbvihqbysyzss";
    };
  };


  ### DEVELOPMENT / PYTHON MODULES


  foursuite = import ../development/python-modules/4suite {
    inherit fetchurl stdenv python;
  };

  bsddb3 = import ../development/python-modules/bsddb3 {
    inherit fetchurl stdenv python db4;
  };

  flup = builderDefsPackage (selectVersion ../development/python-modules/flup "r2311")
  (let python=python25; in
  {
    inherit python;
    setuptools = setuptools.passthru.function {inherit python;};
  });

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

  pygame = import ../development/python-modules/pygame {
    inherit fetchurl stdenv python pkgconfig SDL SDL_image
      SDL_mixer SDL_ttf numeric;
  };

  pygobject = import ../development/python-modules/pygobject {
    inherit fetchurl stdenv python pkgconfig;
    inherit (gtkLibs) glib;
  };

  pygtk = import ../development/python-modules/pygtk {
    inherit fetchurl stdenv python pkgconfig pygobject pycairo;
    inherit (gtkLibs) glib gtk;
  };

  pyopengl = import ../development/python-modules/pyopengl {
    inherit fetchurl stdenv setuptools mesa freeglut pil python;
  };

  pysqlite = import ../development/python-modules/pysqlite {
    inherit stdenv fetchurl python sqlite;
  };

  pythonSip = builderDefsPackage (selectVersion ../development/python-modules/python-sip "4.7.4") {
    inherit python;
  };

  pyqt = builderDefsPackage (selectVersion ../development/python-modules/pyqt "4.3.3") {
    inherit pkgconfig python pythonSip;
    inherit (xlibs) libX11 libXext;
    inherit (gtkLibs) glib;
    qt = qt4;
  };

  pyx = import ../development/python-modules/pyx {
    inherit fetchurl stdenv python makeWrapper;
  };

  pyxml = import ../development/python-modules/pyxml {
    inherit fetchurl stdenv python makeWrapper;
  };

  setuptools = builderDefsPackage (selectVersion ../development/python-modules/setuptools "0.6c8") {
    inherit python;
  };

  wxPython = wxPython26;

  wxPython26 = import ../development/python-modules/wxPython/2.6.nix {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK26;
  };

  wxPython28 = import ../development/python-modules/wxPython/2.8.nix {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK28;
  };

  twisted = import ../development/python-modules/twisted {
    inherit fetchurl stdenv python ZopeInterface makeWrapper;
  };

  ZopeInterface = import ../development/python-modules/ZopeInterface {
    inherit fetchurl stdenv python;
  };

  zope = import ../development/python-modules/zope {
    inherit fetchurl stdenv;
    python = python24;
  };

  ### SERVERS


  apacheHttpd = import ../servers/http/apache-httpd {
    inherit fetchurl stdenv perl openssl zlib apr aprutil pcre;
    sslSupport = true;
  };

  bind = builderDefsPackage (selectVersion ../servers/dns/bind "9.5.0") {
    inherit openssl libtool;
  };

  dict = composedArgsAndFun (selectVersion ../servers/dict "1.9.15") {
    inherit builderDefs which bison;
    flex=flex2534;
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
    inherit fetchurl stdenv expat erlang zlib openssl;
  };

  fingerd_bsd = import ../servers/fingerd/bsd-fingerd {
    inherit fetchurl stdenv;
  };

  ircdHybrid = import ../servers/irc/ircd-hybrid {
    inherit fetchurl stdenv openssl zlib;
  };

  jboss = import ../servers/http/jboss {
    inherit fetchurl stdenv jdk5 jdk;
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

  mod_python = import ../servers/http/apache-modules/mod_python {
    inherit fetchurl stdenv apacheHttpd python;
  };

  nginx = builderDefsPackage (import ../servers/http/nginx) {
    inherit openssl pcre zlib libxml2 libxslt;
  };

  postfix = import ../servers/mail/postfix {
    inherit fetchurl stdenv db4 openssl cyrus_sasl glibc;
  };

  pulseaudio = import ../servers/pulseaudio {
    inherit fetchurl stdenv pkgconfig gnum4 libtool gdbm
      dbus hal avahi liboil libsamplerate libsndfile speex
      intltool gettext;
    inherit (gtkLibs) glib;
    inherit (xlibs) libX11 libICE libSM;
    inherit (alsa) alsaLib;    # Needs ALSA >= 1.0.17.
    gconf = gnome.GConf;
  };

  tomcat_connectors = import ../servers/http/apache-modules/tomcat-connectors {
    inherit fetchurl stdenv apacheHttpd jdk;
  };

  # This function is typically called by the NixOS Upstart job to specify the
  # right UID/GID for `portmap'.
  makePortmap = { daemonUser ? false, daemonGID ? false, daemonUID ? false }:
    (import ../servers/portmap {
       inherit fetchurl stdenv lib tcpWrapper
               daemonUser daemonGID daemonUID;
     });

  portmap = (makePortmap);

  mysql4 = import ../servers/sql/mysql {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  mysql5 = import ../servers/sql/mysql5 {
    inherit fetchurl stdenv ncurses zlib perl openssl;
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

  openfire = composedArgsAndFun (selectVersion ../servers/xmpp/openfire "3.5.2") {
    inherit builderDefs jre;
  };

  postgresql = selectVersion ../servers/sql/postgresql "8.3.0" {
    inherit fetchurl stdenv readline ncurses zlib;
  };

  postgresql_jdbc = import ../servers/sql/postgresql/jdbc {
    inherit fetchurl stdenv ant;
  };

  samba = import ../servers/samba {
    inherit stdenv fetchurl readline openldap pam kerberos popt iniparser
  libunwind acl fam;
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

  vsftpd = import ../servers/ftp/vsftpd {
    inherit fetchurl openssl stdenv libcap pam;
  };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg/default.nix {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      libxslt expat libdrm libpng zlib perl mesa mesaHeaders
      xkeyboard_config dbus hal python e2fsprogs openssl gperf m4;
  });

  xorgReplacements = composedArgsAndFun (import ../servers/x11/xorg/replacements.nix) {
    inherit fetchurl stdenv automake autoconf libtool xorg composedArgsAndFun;
  };

  zabbixAgent = import ../servers/monitoring/zabbix {
    inherit fetchurl stdenv;
    enableServer = false;
  };

  zabbixServer = import ../servers/monitoring/zabbix {
    inherit fetchurl stdenv postgresql curl;
    enableServer = true;
  };


  ### OS-SPECIFIC

  # this creates a patch which can be applied to the kernel to integrate this module..
  kernel_module_acerhk = import ../os-specific/linux/kernel/acerhk {
    inherit fetchurl stdenv gnupatch;
    kernel = kernel_2_6_21;
    debug = true;
  };

  _915resolution = import ../os-specific/linux/915resolution {
    inherit fetchurl stdenv;
  };

  nfsUtils = import ../os-specific/linux/nfs-utils {
   inherit fetchurl stdenv tcpWrapper e2fsprogs;
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

  alsa = import ../os-specific/linux/alsa/1.0.19.nix {
    inherit fetchurl stdenv ncurses gettext;
  };

  alsaLib = alsa.alsaLib;
  alsaUtils = alsa.alsaUtils;

  blcr = builderDefsPackage (selectVersion ../os-specific/linux/blcr "0.6.5"){
    inherit perl;
  };

  blcrCurrent = kernel : (blcr.passthru.function {
    inherit kernel;
  });

  bridge_utils = import ../os-specific/linux/bridge_utils {
    inherit fetchurl stdenv autoconf automake;
  };

  cpufrequtils = import ../os-specific/linux/cpufrequtils {
    inherit fetchurl stdenv libtool gettext;
    glibc = stdenv.gcc.libc;
    kernelHeaders = stdenv.gcc.libc.kernelHeaders;
  };

  cryopid = import ../os-specific/linux/cryopid {
    inherit fetchurl stdenv zlibStatic;
  };

  cramfsswap = import ../os-specific/linux/cramfsswap {
    inherit fetchurl stdenv zlib;
  };

  devicemapper = import ../os-specific/linux/device-mapper {
    inherit fetchurl stdenv;
  };

  dmidecode = composedArgsAndFun (selectVersion ../os-specific/linux/dmidecode "2.9") {
    inherit fetchurl stdenv builderDefs;
  };

  dietlibc = import ../os-specific/linux/dietlibc {
    inherit fetchurl glibc;
    # Dietlibc 0.30 doesn't compile on PPC with GCC 4.1, bus GCC 3.4 works.
    stdenv = if stdenv.system == "powerpc-linux" then overrideGCC stdenv gcc34 else stdenv;
  };

  e2fsprogs = import ../os-specific/linux/e2fsprogs {
    inherit fetchurl stdenv;
  };

  e3cfsprogs = import ../os-specific/linux/e3cfsprogs {
    inherit stdenv fetchurl gettext;
  };

  eject = import ../os-specific/linux/eject {
    inherit fetchurl stdenv gettext;
  };

  fbterm = builderDefsPackage (import ../os-specific/linux/fbterm) {
    inherit fontconfig gpm freetype pkgconfig;
  };

  fuse = import ../os-specific/linux/fuse {
    inherit fetchurl stdenv utillinux;
  };

  fxload = import ../os-specific/linux/fxload {
    inherit fetchurl stdenv;
  };

  genext2fs = import ../os-specific/linux/genext2fs {
    inherit fetchurl stdenv;
  };

  gpm = builderDefsPackage (selectVersion ../servers/gpm "1.20.3pre6") {
    inherit lzma ncurses bison;
    flex = flex2535;
  };

  hal = import ../os-specific/linux/hal {
    inherit fetchurl stdenv pkgconfig python pciutils usbutils expat
      libusb dbus dbus_glib libvolume_id perl perlXMLParser
      gettext zlib eject libsmbios udev;
    inherit (gtkLibs) glib;
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

  hwdata = import ../os-specific/linux/hwdata {
    inherit fetchurl stdenv;
  };

  ifplugd = import ../os-specific/linux/ifplugd {
    inherit fetchurl stdenv pkgconfig libdaemon;
  };

  initscripts = import ../os-specific/linux/initscripts {
    inherit fetchurl stdenv popt pkgconfig;
    inherit (gtkLibs) glib;
  };

  iproute = import ../os-specific/linux/iproute {
    inherit fetchurl stdenv flex bison db4;
  };

  iputils = import ../os-specific/linux/iputils {
    inherit fetchurl stdenv;
    glibc = stdenv.gcc.libc;
    kernelHeaders = stdenv.gcc.libc.kernelHeaders;
  };

  iptables = import ../os-specific/linux/iptables {
    inherit fetchurl stdenv;
  };

  ipw2200fw = import ../os-specific/linux/firmware/ipw2200 {
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

  jfsrec = builderDefsPackage (selectVersion ../os-specific/linux/jfsrec "svn-7"){
    inherit boost;
  };

  jfsUtils = builderDefsPackage (selectVersion ../os-specific/linux/jfsutils "1.1.12") {
    inherit e2fsprogs;
  };

  kbd = import ../os-specific/linux/kbd {
    inherit fetchurl stdenv bison flex;
  };

  kernelHeaders = kernelHeaders_2_6_28;

  kernelHeaders_2_6_18 = import ../os-specific/linux/kernel-headers/2.6.18.5.nix {
    inherit fetchurl stdenv unifdef;
  };

  kernelHeaders_2_6_23 = import ../os-specific/linux/kernel-headers/2.6.23.16.nix {
    inherit fetchurl stdenv;
  };

  kernelHeaders_2_6_26 = import ../os-specific/linux/kernel-headers/2.6.26.2.nix {
    inherit fetchurl stdenv;
  };

  kernelHeaders_2_6_27 = import ../os-specific/linux/kernel-headers/2.6.27.8.nix {
    inherit fetchurl stdenv;
  };

  kernelHeaders_2_6_28 = import ../os-specific/linux/kernel-headers/2.6.28.nix {
    inherit fetchurl stdenv perl;
  };

  kernelHeadersArm = import ../os-specific/linux/kernel-headers-cross {
    inherit fetchurl stdenv;
    cross = "arm-linux";
  };

  kernelHeadersMips = import ../os-specific/linux/kernel-headers-cross {
    inherit fetchurl stdenv;
    cross = "mips-linux";
  };

  kernelHeadersSparc = import ../os-specific/linux/kernel-headers-cross {
    inherit fetchurl stdenv;
    cross = "sparc-linux";
  };

  /*
  systemKernel =
    if getConfig ["kernel" "version"] "2.6.21" == "2.6.22" then kernel_2_6_22 else
    if getConfig ["kernel" "version"] "2.6.21" == "2.6.23" then kernel_2_6_23 else
    kernel;
  */

  kernel_2_6_20 = import ../os-specific/linux/kernel/linux-2.6.20.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.20-paravirt-nvidia.patch;
      }
      { name = "skas-2.6.20-v9-pre9";
        patch = fetchurl {
          url = http://www.user-mode-linux.org/~blaisorblade/patches/skas3-2.6/skas-2.6.20-v9-pre9/skas-2.6.20-v9-pre9.patch.bz2;
          md5 = "02e619e5b3aaf0f9768f03ac42753e74";
        };
        extraConfig =
          "CONFIG_PROC_MM=y\n" +
          "# CONFIG_PROC_MM_DUMPABLE is not set\n";
      }
      { name = "fbsplash-0.9.2-r5-2.6.20-rc6";
        patch = fetchurl {
          url = http://dev.gentoo.org/~spock/projects/gensplash/archive/fbsplash-0.9.2-r5-2.6.20-rc6.patch;
          sha256 = "11v4f85f4jnh9sbhqcyn47krb7l1czgzjw3w8wgbq14jm0sp9294";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
  };

  kernel_2_6_21 = import ../os-specific/linux/kernel/linux-2.6.21.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      /* Commented out because only acer users have need for it..
         It takes quite a while to create the patch when unpacking the kernel sources only for that task
      { name = "acerhk";
        patch = kernel_module_acerhk + "/acerhk-patch.tar.bz2" ;
        extraConfig =
  "CONFIG_ACERHK=m\n";
      }
      */
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.20-paravirt-nvidia.patch;
      }
      { name = "skas-2.6.20-v9-pre9";
        patch = fetchurl {
          url = http://www.user-mode-linux.org/~blaisorblade/patches/skas3-2.6/skas-2.6.20-v9-pre9/skas-2.6.20-v9-pre9.patch.bz2;
          md5 = "02e619e5b3aaf0f9768f03ac42753e74";
        };
        extraConfig =
          "CONFIG_PROC_MM=y\n" +
          "# CONFIG_PROC_MM_DUMPABLE is not set\n";
      }
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl { # !!! missing!
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.21/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "00s8074fzsly2zpir885zqkvq267qyzg6vhsn7n1z2v1z78avxd8";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
  };

  kernel_2_6_22 = import ../os-specific/linux/kernel/linux-2.6.22.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl {
          url = http://nixos.org/tarballs/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "no_hz"] false) "CONFIG_NO_HZ=y" ++
      lib.optional (getConfig ["kernel" "timer_stats"] false) "CONFIG_TIMER_STATS=y" ++
      lib.optional (getConfig ["kernel" "usb_suspend"] false) "CONFIG_USB_SUSPEND=y" ++
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  kernel_2_6_23 = import ../os-specific/linux/kernel/linux-2.6.23.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      /*
      { # resume with resume=swap:/dev/xx
        name = "tux on ice"; # (swsusp2)
        patch = fetchurl {
          url = "http://www.tuxonice.net/downloads/all/tuxonice-3.0-rc5-for-2.6.23.14.patch.bz2";
          sha256 = "187190rxbn9x1c6bwv59mwy1zhff8nn5ad58cfiz23wa5wrk4mif";
        };
        extraConfig = "
          CONFIG_SUSPEND2=y
          CONFIG_SUSPEND2_FILE=y
          CONFIG_SUSPEND2_SWAP=y
          CONFIG_CRYPTO_LZF=y
        ";
      }
      */
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl {
          url = http://nixos.org/tarballs/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
        features = { fbSplash = true; };
      }
      /* !!! Not needed anymore for the NixOS LiveCD - we have AUFS. */
      { name = "unionfs-2.2.2";
        patch = fetchurl {
          url = http://download.filesystems.org/unionfs/unionfs-2.x/unionfs-2.2.2_for_2.6.23.13.diff.gz;
          sha256 = "104hahp6fjpxwprcl2njw5mimyh442ma3cp5r1ww0mzq3vwrcdyz";
        };
        extraConfig = ''
          CONFIG_UNION_FS=m
          CONFIG_UNION_FS_XATTR=y
        '';
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "timer_stats"] false) "CONFIG_TIMER_STATS=y" ++
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  kernel_2_6_25 = import ../os-specific/linux/kernel/linux-2.6.25.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "fbcondecor-0.9.4-2.6.25-rc6";
        patch = fetchurl {
          url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.4-2.6.25-rc6.patch;
          sha256 = "1wm94n7f0qyb8xvafip15r158z5pzw7zb7q8hrgddb092c6ibmq8";
        };
        extraConfig = "CONFIG_FB_CON_DECOR=y";
        features = { fbConDecor = true; };
      }
      { name = "sec_perm-2.6.24";
        patch = ../os-specific/linux/kernel/sec_perm-2.6.24.patch;
        features = { secPermPatch = true; };
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "timer_stats"] false) "CONFIG_TIMER_STATS=y" ++
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  kernel_2_6_26 = import ../os-specific/linux/kernel/linux-2.6.26.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "fbcondecor-0.9.4-2.6.25-rc6";
        patch = fetchurl {
          url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.4-2.6.25-rc6.patch;
          sha256 = "1wm94n7f0qyb8xvafip15r158z5pzw7zb7q8hrgddb092c6ibmq8";
        };
        extraConfig = "CONFIG_FB_CON_DECOR=y";
        features = { fbConDecor = true; };
      }
      { name = "sec_perm-2.6.24";
        patch = ../os-specific/linux/kernel/sec_perm-2.6.24.patch;
        features = { secPermPatch = true; };
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  kernel_2_6_27 = import ../os-specific/linux/kernel/linux-2.6.27.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "fbcondecor-0.9.4-2.6.27";
        patch = fetchurl {
          url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.4-2.6.27.patch;
          sha256 = "170l9l5fvbgjrr4klqcwbgjg4kwvrrhjpmgbfpqj0scq0s4q4vk6";
        };
        extraConfig = "CONFIG_FB_CON_DECOR=y";
        features = { fbConDecor = true; };
      }
      { name = "sec_perm-2.6.24";
        patch = ../os-specific/linux/kernel/sec_perm-2.6.24.patch;
        features = { secPermPatch = true; };
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  kernel_2_6_28 = import ../os-specific/linux/kernel/linux-2.6.28.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    kernelPatches = [
      { name = "fbcondecor-0.9.5-2.6.28";
        patch = fetchurl {
          url = http://dev.gentoo.org/~spock/projects/fbcondecor/archive/fbcondecor-0.9.5-2.6.28.patch;
          sha256 = "105q2dwrwi863r7nhlrvljim37aqv67mjc3lgg529jzqgny3fjds";
        };
        extraConfig = "CONFIG_FB_CON_DECOR=y";
        features = { fbConDecor = true; };
      }
      { name = "sec_perm-2.6.24";
        patch = ../os-specific/linux/kernel/sec_perm-2.6.24.patch;
        features = { secPermPatch = true; };
      }
    ];
    extraConfig =
      lib.optional (getConfig ["kernel" "no_irqbalance"] false) "# CONFIG_IRQBALANCE is not set" ++
      [(getConfig ["kernel" "addConfig"] "")];
  };

  /* Kernel modules are inherently tied to a specific kernel.  So
     rather than provide specific instances of those packages for a
     specific kernel, we have a function that builds those packages
     for a specific kernel.  This function can then be called for
     whatever kernel you're using. */

  kernelPackagesFor = kernel: rec {

    inherit kernel;

    aufs = import ../os-specific/linux/aufs {
      inherit fetchurl stdenv kernel;
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

    atheros = composedArgsAndFun (selectVersion ../os-specific/linux/atheros "0.9.4") {
      inherit fetchurl stdenv builderDefs kernel lib;
    };

    nvidiaDrivers = import ../os-specific/linux/nvidia {
      inherit stdenv fetchurl kernel xlibs gtkLibs zlib;
    };

    wis_go7007 = import ../os-specific/linux/wis-go7007 {
      inherit fetchurl stdenv kernel ncurses fxload;
    };

    kqemu = builderDefsPackage (selectVersion ../os-specific/linux/kqemu "1.3.0pre11") {
      inherit kernel;
    };

    splashutils =
      if kernel.features ? fbSplash then splashutils_13 else
      if kernel.features ? fbConDecor && system != "x86_64-linux" then splashutils_15 else
      null;

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

      aterm = aterm242fixes;
      db4 = db45;

      flex = flex2533;

      inherit ext3cowtools e3cfsprogs rsync;
      ext3cow_kernel = kernel;
    };

    sysprof = import ../development/tools/profiling/sysprof {
      inherit fetchurl stdenv binutils pkgconfig kernel;
      inherit (gnome) gtk glib pango libglade;
    };

    # Broken build, still. The install step fails, and I never tried to run that compiled.
    virtualbox = import ../applications/virtualization/virtualbox/2.1.2.nix {
      inherit stdenv fetchurl iasl dev86 libxslt libxml2 qt3 qt4 SDL hal
          libcap libpng zlib kernel;
      inherit (gtkLibs) glib;
      inherit (xlibs) xproto libX11 libXext libXcursor;
      inherit (gnome) libIDL;
    };
  };

  # Build the kernel modules for the some of the kernels.
  kernelPackages_2_6_23 = recurseIntoAttrs (kernelPackagesFor kernel_2_6_23);
  kernelPackages_2_6_25 = recurseIntoAttrs (kernelPackagesFor kernel_2_6_25);
  kernelPackages_2_6_26 = recurseIntoAttrs (kernelPackagesFor kernel_2_6_26);
  kernelPackages_2_6_27 = recurseIntoAttrs (kernelPackagesFor kernel_2_6_27);
  kernelPackages_2_6_28 = recurseIntoAttrs (kernelPackagesFor kernel_2_6_28);

  # The current default kernel / kernel modules.
  kernelPackages = kernelPackages_2_6_25;

  customKernel = composedArgsAndFun (lib.sumTwoArgs (import ../os-specific/linux/kernel/generic.nix) {
    inherit fetchurl stdenv perl mktemp module_init_tools;
  });

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
    inherit fetchurl stdenv libxml2;
  };

  lm_sensors = import ../os-specific/linux/lm_sensors {
    inherit fetchurl stdenv bison flex perl;
  };

  klibc = composedArgsAndFun (import ../os-specific/linux/klibc) {
    inherit fetchurl stdenv perl bison mktemp;
    kernelHeaders = glibc.kernelHeaders;
  };

  klibcShrunk = composedArgsAndFun (import ../os-specific/linux/klibc/shrunk.nix) {
    inherit stdenv klibc;
  };

  kvm = kvm76;

  kvm57 = import ../os-specific/linux/kvm/57.nix {
    inherit fetchurl zlib e2fsprogs SDL alsaLib;
    stdenv = overrideGCC stdenv gcc34;
    kernelHeaders = kernelHeaders_2_6_23;
  };

  kvm76 = import ../os-specific/linux/kvm/76.nix {
    inherit fetchurl stdenv zlib e2fsprogs SDL alsaLib pkgconfig rsync;
    kernelHeaders = kernelHeaders_2_6_26;
  };

  kvm82 = import ../os-specific/linux/kvm/82.nix {
    inherit fetchurl stdenv zlib e2fsprogs SDL alsaLib pkgconfig rsync;
    kernelHeaders = kernelHeaders_2_6_28;
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
    inherit fetchurl stdenv devicemapper;
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
      inherit stdenv module_init_tools modules;
    };

  modutils = import ../os-specific/linux/modutils {
    inherit fetchurl bison flex;
    stdenv = overrideGCC stdenv gcc34;
  };

  nettools = import ../os-specific/linux/net-tools {
    inherit fetchurl stdenv;
  };

  numactl = import ../os-specific/linux/numactl {
    inherit fetchurl stdenv;
  };

  gw6c = builderDefsPackage (selectVersion ../os-specific/linux/gw6c "5.1") {
    inherit fetchurl stdenv nettools openssl procps iproute;
  };

  nss_ldap = import ../os-specific/linux/nss_ldap {
    inherit fetchurl stdenv openldap;
  };

  pam = import ../os-specific/linux/pam {
    inherit stdenv fetchurl cracklib flex;
  };

  pam_console = import ../os-specific/linux/pam_console {
    inherit stdenv fetchurl pam autoconf automake libtool pkgconfig bison;
    flex = if stdenv.system == "i686-linux" then flex else flex2533;
    inherit (gtkLibs) glib;
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

  pcmciaUtils = composedArgsAndFun (import ../os-specific/linux/pcmciautils) {
    inherit stdenv fetchurl udev yacc flex;
    inherit sysfsutils module_init_tools;

    firmware = getConfig ["pcmciaUtils" "firmware"] [];
    config = getConfig ["pcmciaUtils" "config"] null;
    inherit lib;
  };

  powertop = import ../os-specific/linux/powertop {
    inherit fetchurl stdenv ncurses;
  };

  procps = import ../os-specific/linux/procps {
    inherit fetchurl stdenv ncurses;
  };

  pwdutils = import ../os-specific/linux/pwdutils {
    inherit fetchurl stdenv pam openssl libnscd;
  };

  reiserfsprogs = import ../os-specific/linux/reiserfsprogs {
    inherit fetchurl stdenv;
  };

  reiser4progs = import ../os-specific/linux/reiser4progs {
    inherit fetchurl stdenv libaal;
  };

  radeontools = import ../os-specific/linux/radeontools {
    inherit pciutils;
    inherit fetchurl stdenv;
  };

  sdparm = composedArgsAndFun (selectVersion ../os-specific/linux/sdparm "1.03") {
    inherit fetchurl stdenv builderDefs;
  };

  shadowutils = import ../os-specific/linux/shadow {
    inherit fetchurl stdenv;
  };

  splashutils_13 = import ../os-specific/linux/splashutils/1.3.nix {
    inherit fetchurl stdenv klibc;
    zlib = zlibStatic;
    libjpeg = libjpegStatic;
  };

  splashutils_15 = import ../os-specific/linux/splashutils/1.5.nix {
    inherit fetchurl stdenv klibc;
    zlib = zlibStatic;
    libjpeg = libjpegStatic;
  };

  squashfsTools = import ../os-specific/linux/squashfs {
    inherit fetchurl stdenv zlib;
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

  udev = import ../os-specific/linux/udev {
    inherit fetchurl stdenv;
  };

  uml = import ../os-specific/linux/kernel/linux-2.6.20.nix {
    inherit fetchurl stdenv perl mktemp module_init_tools;
    userModeLinux = true;
  };

  umlutilities = import ../os-specific/linux/uml-utilities {
    inherit fetchurl kernelHeaders stdenv readline lib;
    tunctl = true; mconsole = true;
  };

  upstart = import ../os-specific/linux/upstart {
    inherit fetchurl stdenv;
  };

  upstartJobControl = import ../os-specific/linux/upstart/jobcontrol.nix {
    inherit stdenv;
  };

  usbutils = import ../os-specific/linux/usbutils {
    inherit fetchurl stdenv libusb;
  };

  utillinux = composedArgsAndFun (import ../os-specific/linux/util-linux) {
    inherit fetchurl stdenv;
  };

  utillinuxCurses = import ../os-specific/linux/util-linux {
    inherit fetchurl stdenv ncurses;
  };

  utillinuxStatic = lowPrio (appendToName "static" (import ../os-specific/linux/util-linux {
    inherit fetchurl;
    stdenv = makeStaticBinaries stdenv;
  }));

  utillinuxng = composedArgsAndFun (import ../os-specific/linux/util-linux-ng) {
    inherit fetchurl stdenv e2fsprogs;
  };

  utillinuxngCurses = composedArgsAndFun (import ../os-specific/linux/util-linux-ng) {
    inherit fetchurl stdenv e2fsprogs ncurses;
  };

  wesnoth = import ../games/wesnoth {
    inherit fetchurl stdenv SDL SDL_image SDL_mixer SDL_net gettext zlib boost freetype;
  };

  wirelesstools = import ../os-specific/linux/wireless-tools {
    inherit fetchurl stdenv;
  };

  wpa_supplicant = import ../os-specific/linux/wpa_supplicant {
    inherit fetchurl stdenv openssl;
  };

  xfsProgs = builderDefsPackage (selectVersion ../os-specific/linux/xfsprogs "2.9.7-1"){
    inherit libtool gettext e2fsprogs;
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

  corefonts = import ../data/fonts/corefonts {
    inherit fetchurl stdenv cabextract;
  };

  wrapFonts = paths : ((import ../data/fonts/fontWrap) {
    inherit fetchurl stdenv builderDefs paths ttmkfdir;
    inherit (xorg) mkfontdir mkfontscale;
  });

  clearlyU = composedArgsAndFun (selectVersion ../data/fonts/clearlyU "1.9") {
    inherit builderDefs;
    inherit (xorg) mkfontdir mkfontscale;
  };

  dejavu_fonts = import ../data/fonts/dejavu-fonts {
    inherit fetchurl stdenv fontforge perl perlFontTTF
      fontconfig;
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

  docbook_xml_ebnf_dtd = import ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = docbook_xsl;

  docbook_xsl = import ../data/sgml+xml/stylesheets/xslt/docbook {
    inherit fetchurl stdenv;
  };

  docbook5_xsl = import ../data/sgml+xml/stylesheets/xslt/docbook5 {
    inherit fetchurl stdenv;
  };

  junicode = composedArgsAndFun (selectVersion ../data/fonts/junicode "0.6.15") {
    inherit builderDefs fontforge unzip;
    inherit (xorg) mkfontdir mkfontscale;
  };

  freefont_ttf = import ../data/fonts/freefont-ttf {
    inherit fetchurl stdenv;
  };

  liberation_ttf = import ../data/fonts/redhat-liberation-fonts {
    inherit fetchurl stdenv;
  };

  libertine = builderDefsPackage (selectVersion ../data/fonts/libertine "2.7") {
    inherit fontforge;
  };
  libertineBin = builderDefsPackage (selectVersion ../data/fonts/libertine "2.7.bin") {
  };

  lmodern = builderDefsPackage (selectVersion ../data/fonts/lmodern "1.010") {
  };

  manpages = import ../data/documentation/man-pages {
    inherit fetchurl stdenv;
  };

  mph_2b_damase = import ../data/fonts/mph-2b-damase {
    inherit fetchurl stdenv unzip;
  };

  shared_mime_info = selectVersion ../data/misc/shared-mime-info "0.23" {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig gettext libxml2;
    inherit (gtkLibs) glib;
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

  wqy_zenhei = composedArgsAndFun (selectVersion ../data/fonts/wqy_zenhei "0.4.23-1") {
    inherit builderDefs;
  };

  xkeyboard_config = import ../data/misc/xkeyboard-config {
    inherit fetchurl stdenv perl perlXMLParser gettext intltool;
    inherit (xlibs) xkbcomp;
  };


  ### APPLICATIONS


  aangifte2005 = import ../applications/taxes/aangifte-2005 {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 libXext;
  };

  aangifte2006 = import ../applications/taxes/aangifte-2006 {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 libXext;
  };

  aangifte2007 = import ../applications/taxes/aangifte-2007 {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 libXext libSM;
  };

  abcde = import ../applications/audio/abcde {
    inherit fetchurl stdenv libcdio cddiscid wget bash vorbisTools
            makeWrapper;
  };

  abiword = import ../applications/office/abiword {
    inherit fetchurl stdenv pkgconfig fribidi libpng popt libgsf enchant wv;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade libgnomeprint libgnomeprintui libgnomecanvas;
  };

  acroread = import ../applications/misc/acrobat-reader {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXt libXp libXext libX11 libXinerama;
    inherit (gtkLibs) glib pango atk gtk;
    libstdcpp5 = gcc33.gcc;
    xineramaSupport = true;
    fastStart = getConfig ["acroread" "fastStart"] true;
  };

  amsn = import ../applications/networking/instant-messengers/amsn {
    inherit fetchurl stdenv which tcl tk x11;
    libstdcpp = gcc33.gcc;
  };

  audacious = import ../applications/audio/audacious/player.nix {
    inherit fetchurl stdenv pkgconfig libmowgli libmcs gettext xlibs dbus_glib;
    inherit (gnome) libglade;
    inherit (gtkLibs) glib gtk;
  };

  audacious_plugins = import ../applications/audio/audacious/plugins.nix {
    inherit fetchurl stdenv pkgconfig audacious dbus_glib gettext
      libmad xlibs alsaLib taglib libmpcdec libogg libvorbis
      libcdio libcddb;
  };

  audacity = import ../applications/audio/audacity {
    inherit fetchurl stdenv libogg libvorbis libsndfile libmad
      pkgconfig gettext;
    inherit (gtkLibs) gtk glib;
    wxGTK = wxGTK28deps;
    inherit builderDefs stringsWithDeps;
  };

  aumix = import ../applications/audio/aumix {
    inherit fetchurl stdenv ncurses pkgconfig gettext;
    inherit (gtkLibs) gtk;
    gtkGUI = false;
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
    inherit (bleedingEdgeRepos) sourceByName;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) libgnomecanvas libart_lgpl;
    inherit automake autoconf;
  };

  bitlbee = import ../applications/networking/instant-messengers/bitlbee {
    inherit fetchurl stdenv gnutls pkgconfig;
    inherit (gtkLibs) glib;
  };

  bitlbeeOtr = import ../applications/networking/instant-messengers/bitlbee-otr {
    inherit fetchbzr stdenv gnutls pkgconfig libotr libgcrypt
      libxslt xmlto docbook_xsl docbook_xml_dtd_42 perl;
    inherit (gtkLibs) glib;
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

  blender = import ../applications/misc/blender {
    inherit stdenv cmake mesa gettext freetype SDL libtiff fetchurl glibc scons x11 lib
      libjpeg libpng zlib /* smpeg sdl */ python;
    inherit (xlibs) inputproto libXi;
    freealut = freealut_soft;
    openal = openalSoft;
    openexr = openexr_1_4_0;
  };

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

  carrier = builderDefsPackage (selectVersion ../applications/networking/instant-messengers/carrier "2.5.0") {
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

  cinelerra = import ../applications/video/cinelerra {
    inherit fetchurl stdenv
      automake autoconf libtool
      a52dec alsaLib   lame libavc1394 libiec61883 libraw1394 libsndfile
      libvorbis libogg libjpeg libtiff freetype mjpegtools x264
      gettext X11 faad2 faac libtheora libpng libdv perl nasm e2fsprogs
      pkgconfig;
      openexr = openexr_1_6_1;
    fftw = fftwSinglePrec;
    inherit (xorg) libXxf86vm libXv;
    inherit (bleedingEdgeRepos) sourceByName;
    inherit (gnome) esound;
  };

  compiz_050 = assert mesaSupported; import ../applications/window-managers/compiz/0.5.0.nix {
    inherit fetchurl stdenv pkgconfig libpng mesa;
    inherit (xorg) libXcomposite libXfixes libXdamage libXrandr
      libXinerama libICE libSM libXrender xextproto;
    inherit (gnome) startupnotification libwnck GConf;
    inherit (gtkLibs) gtk;
    inherit (gnome) libgnome libgnomeui metacity glib pango
      libglade libgtkhtml gtkhtml libgnomecanvas libgnomeprint
      libgnomeprintui gnomepanel;
    gnomegtk = gnome.gtk;
    inherit librsvg fuse;
  };

  compiz_062 = compiz.passthru.function {
    version = "0.6.2";
  };

  compizBase = composedArgsAndFun (assert mesaSupported; selectVersion ../applications/window-managers/compiz "0.7.8") {
    inherit lib builderDefs stringsWithDeps;
    inherit fetchurl stdenv pkgconfig libpng mesa perl perlXMLParser libxslt gettext;
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

  compiz = compizBase.passthru.function {
    extraConfigureFlags = getConfig ["compiz" "extraConfigureFlags"] [];
  };

  compizFusion = assert mesaSupported; import ../applications/window-managers/compiz-fusion {
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

  bbdb = import ../applications/editors/emacs-modes/bbdb {
    inherit fetchurl stdenv emacs texinfo ctags;
  };

  codeville = builderDefsPackage (selectVersion ../applications/version-management/codeville "0.8.0") {
    inherit makeWrapper;
    python = pythonFull;
  };

  comical = import ../applications/graphics/comical {
    inherit stdenv fetchurl utillinux zlib;
    inherit wxGTK;
  };

  cua = import ../applications/editors/emacs-modes/cua {
    inherit fetchurl stdenv;
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

  darcs = import ../applications/version-management/darcs {
    inherit fetchurl stdenv zlib ncurses curl getConfig;
    ghc = ghc661;
  };

  # some speed bottle necks are resolved in this version I think .. perhaps you like to try it?
  darcs2 = import ../applications/version-management/darcs/darcs-2.nix {
    inherit fetchurl stdenv zlib ncurses curl ghc perl;
  };

  dia = import ../applications/graphics/dia {
    inherit stdenv fetchurl pkgconfig perl perlXMLParser
      libxml2 gettext python libxml2Python docbook5 docbook_xsl
      libxslt;
    inherit (gtkLibs) gtk glib;
  };

  djvulibre = import ../applications/misc/djvulibre {
    inherit stdenv fetchurl libjpeg libtiff libungif zlib
      ghostscript libpng x11 mesa;
    qt = if (getConfig ["djvulibre" "qt3Frontend"] true) then qt3 else null;
    inherit (xlibs) libX11;
  };

  djview4 = import ../applications/graphics/djview {
    inherit fetchurl stdenv qt4 djvulibre;
  };

  dmenu = import ../applications/misc/dmenu {
    inherit lib fetchurl stdenv;
    inherit (xlibs) libX11 libXinerama;
  };

  dmtx = builderDefsPackage (import ../tools/graphics/dmtx) {
    inherit libpng libtiff;
  };

  dvdauthor = import ../applications/video/dvdauthor {
    inherit fetchurl stdenv freetype libpng fribidi libxml2 libdvdread imagemagick;
  };

  dwm = import ../applications/window-managers/dwm {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXinerama;
  };


  # put something like this into your ~/.nixpkgs/config.nix file
  #eclipse = {
  # plugins = {eclipse, version, plugins } : let p = plugins; in
  #   [  p.pdt # PHP developement
  #      p.viPlugin # vim keybindings (see license)
  #   ];
  #};
  eclipseNew = (selectVersion ../applications/editors/eclipse-new "3.3.1.1" {
    # outdated, but 3.3.1.1 does already compile on nix, feel free to work 3.4
    inherit fetchurl stdenv makeWrapper jdk unzip ant selectVersion buildEnv
    getConfig lib zip writeTextFile runCommand;
    inherit (gtkLibs) gtk glib;
    inherit (xlibs) libXtst;
  });

  eclipse = plugins:
    import ../applications/editors/eclipse {
      inherit fetchurl stdenv makeWrapper jdk;
      inherit (gtkLibs) gtk glib;
      inherit (xlibs) libXtst;
      inherit plugins;
    };

  eclipsesdk = eclipse [];

  eclipseSpoofax = lowPrio (appendToName "with-spoofax" (eclipse [spoofax]));

  ed = import ../applications/editors/ed {
    inherit fetchurl stdenv;
  };

  elinks = import ../applications/networking/browsers/elinks {
    inherit stdenv fetchurl python perl ncurses x11 zlib openssl spidermonkey
      guile bzip2;
  };

  emacs = emacs22;

  emacs21 = import ../applications/editors/emacs-21 {
    inherit fetchurl stdenv ncurses x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    xaw3dSupport = true;
  };

  emacs22 = import ../applications/editors/emacs-22 {
    inherit fetchurl stdenv ncurses pkgconfig x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    inherit (gtkLibs) gtk;
    xaw3dSupport = getPkgConfig "emacs" "xaw3dSupport" false;
    gtkGUI = getPkgConfig "emacs" "gtkSupport" true;
  };

  emacsUnicode = lowPrio (import ../applications/editors/emacs-unicode {
    inherit fetchurl stdenv ncurses pkgconfig x11 Xaw3d
      libpng libjpeg libungif libtiff texinfo;
    inherit (xlibs) libXaw libXpm libXft;
    inherit (gtkLibs) gtk;
    xawSupport = getPkgConfig "emacs" "xawSupport" false;
    xaw3dSupport = getPkgConfig "emacs" "xaw3dSupport" false;
    gtkGUI = getPkgConfig "emacs" "gtkSupport" true;
    xftSupport = getPkgConfig "emacs" "xftSupport" true;
  });

  emms = import ../applications/editors/emacs-modes/emms {
    inherit fetchurl stdenv emacs texinfo mpg321 vorbisTools taglib
      alsaUtils;
  };

  evince = import ../applications/misc/evince {
    inherit fetchurl stdenv perl perlXMLParser gettext intltool
      pkgconfig poppler libspectre djvulibre libxslt
      dbus dbus_glib shared_mime_info makeWrapper;
    inherit (gnome) gnomedocutils gnomeicontheme libgnome
      libgnomeui libglade glib gtk scrollkeeper;
  };

  exrdisplay = import ../applications/graphics/exrdisplay {
    inherit fetchurl stdenv pkgconfig mesa which openexr_ctl;
    fltk = fltk20;
    openexr = openexr_1_6_1;
  };

  fbpanel = composedArgsAndFun (selectVersion ../applications/window-managers/fbpanel "4.12") {
    inherit fetchurl stdenv builderDefs pkgconfig libpng libjpeg libtiff librsvg;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libX11 libXmu libXpm;
  };

  fetchmail = import ../applications/misc/fetchmail {
    inherit stdenv fetchurl openssl;
  };

  wavesurfer = import ../applications/misc/audio/wavesurfer {
    inherit fetchurl stdenv tcl tk snack makeWrapper;
  };

  wireshark = import ../applications/networking/sniffers/wireshark {
    inherit fetchurl stdenv perl pkgconfig libpcap flex bison;
    inherit (gtkLibs) gtk;
  };

  fdupes = import ../tools/misc/fdupes {
    inherit fetchurl stdenv;
  };

  feh = import ../applications/graphics/feh {
    inherit fetchurl stdenv x11 imlib2 libjpeg libpng;
  };

  firefox = firefox3;

  firefoxWrapper = firefox3Wrapper;

  firefox2 = lowPrio (import ../applications/networking/browsers/firefox-2 {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  });

  firefox2Wrapper = wrapFirefox firefox2 "firefox" "";

  firefox3 = lowPrio (import ../applications/networking/browsers/firefox-3 {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2;
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
    #enableOfficialBranding = true;
    xulrunner = xulrunner3;
  });

  xulrunner3 = lowPrio (import ../applications/networking/browsers/firefox-3/xulrunner.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs file;
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
    #enableOfficialBranding = true;
  });

  firefox3_1 = lowPrio (import ../applications/networking/browsers/firefox-3/3.1.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2;
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
    inherit (alsa) alsaLib;
    #enableOfficialBranding = true;
    xulrunner = xulrunner3_1;
    autoconf = autoconf213;
  });

  xulrunner3_1 = lowPrio (import ../applications/networking/browsers/firefox-3/xulrunner-3.1.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs file;
    inherit (gtkLibs) gtk pango;
    inherit (gnome) libIDL;
    inherit (alsa) alsaLib;
    autoconf = autoconf213;
    #enableOfficialBranding = true;
  });

  firefox3b1Bin = lowPrio (import ../applications/networking/browsers/firefox-3/binary.nix {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python curl coreutils freetype fontconfig;
    inherit (gtkLibs) gtk atk pango glib;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi libX11 libXrender libXft libXt;
  });

  firefox3Wrapper = wrapFirefox firefox3 "firefox" "";
  firefox3b1BinWrapper = lowPrio (wrapFirefox firefox3b1Bin "firefox" "");

  flac = import ../applications/audio/flac {
    inherit fetchurl stdenv libogg;
  };

  flashplayer = flashplayer10;

  flashplayer9 = import ../applications/networking/browsers/mozilla-plugins/flashplayer-9 {
    inherit fetchurl stdenv zlib alsaLib;
  };

  flashplayer10 = import ../applications/networking/browsers/mozilla-plugins/flashplayer-10 {
    inherit fetchurl stdenv zlib alsaLib curl;
  };

  flite = import ../applications/misc/flite {
    inherit fetchurl stdenv;
  };

  freemind = import ../applications/misc/freemind {
    inherit fetchurl stdenv ant coreutils gnugrep;
    jdk = jdk;
    jre = jdk;
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
    inherit (gnome) gtk libgtkhtml libart_lgpl;
  };

  gitAndTools = recurseIntoAttrs (import ../applications/version-management/git-and-tools {
    inherit pkgs;
  });
  git = gitAndTools.git;

  qjackctl = import ../applications/audio/qjackctl {
    inherit fetchurl stdenv alsaLib jackaudio;
    qt4 = qt4;
  };

  gkrellm = import ../applications/misc/gkrellm {
    inherit fetchurl stdenv gettext pkgconfig;
    inherit (gtkLibs) glib gtk;
    inherit (xlibs) libX11 libICE libSM;
  };

  gnash = assert mesaSupported; import ../applications/video/gnash {
    inherit fetchurl stdenv SDL SDL_mixer libogg libxml2 libjpeg mesa libpng
            boost freetype agg dbus curl pkgconfig x11 libtool lib libungif
            gettext makeWrapper ming dejagnu python;
    inherit (gtkLibs) glib gtk;
    inherit (gst_all) gstreamer gstPluginsBase gstFfmpeg;
  };

  gnunet = import ../applications/networking/p2p/gnunet {
    inherit fetchurl stdenv libextractor libmicrohttpd libgcrypt
      gmp curl libtool guile adns sqlite gettext zlib pkgconfig
      libxml2 ncurses findutils makeWrapper;
    inherit (gnome) gtk libglade;
    gtkSupport = getConfig [ "gnunet" "gtkSupport" ] true;
  };

  gocr = composedArgsAndFun (selectVersion ../applications/graphics/gocr "0.44") {
    inherit builderDefs fetchurl stdenv;
  };

  gphoto2 = import ../applications/misc/gphoto2 {
    inherit fetchurl stdenv pkgconfig libgphoto2 libexif popt gettext
      libjpeg readline libtool;
  };

  qrdecode = builderDefsPackage (import ../tools/graphics/qrdecode) {
    inherit libpng libcv;
  };

  qrencode = builderDefsPackage (import ../tools/graphics/qrencode) {
    inherit libpng pkgconfig;
  };

  gqview = import ../applications/graphics/gqview {
    inherit fetchurl stdenv pkgconfig libpng;
    inherit (gtkLibs) gtk;
  };

  gv = import ../applications/misc/gv {
    inherit fetchurl stdenv Xaw3d ghostscriptX;
  };

  haskellMode = import ../applications/editors/emacs-modes/haskell {
    inherit fetchurl stdenv emacs;
  };

  hello = import ../applications/misc/hello/ex-2 {
    inherit fetchurl stdenv;
  };

  i810switch = import ../applications/misc/i810 {
    inherit fetchurl stdenv pciutils;
  };

  icecat3 = lowPrio (import ../applications/networking/browsers/icecat-3 {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs;
    inherit (gnome) libIDL libgnomeui gnomevfs gtk pango;
  });

  icecatXulrunner3 = lowPrio (import ../applications/networking/browsers/icecat-3 {
    application = "xulrunner";
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo
      python dbus dbus_glib freetype fontconfig bzip2 xlibs;
    inherit (gnome) libIDL libgnomeui gnomevfs gtk pango;
  });

  icecat3Xul =
    (symlinkJoin "icecat-3-with-xulrunner" [ icecat3 icecatXulrunner3 ])
    // { inherit (icecat3) gtk isFirefox3Like meta; };

  icecatWrapper = wrapFirefox icecat3Xul "icecat" "";

  icewm = import ../applications/window-managers/icewm {
    inherit fetchurl stdenv gettext libjpeg libtiff libungif libpng imlib;
    inherit (xlibs) libX11 libXft libXext libXinerama libXrandr;
  };

  imagemagick = import ../applications/graphics/ImageMagick {
    inherit stdenv fetchurl bzip2 freetype graphviz ghostscript
      libjpeg libpng libtiff libxml2 zlib libtool;
    inherit (xlibs) libX11;
  };

  imagemagickBig = import ../applications/graphics/ImageMagick {
    inherit stdenv fetchurl bzip2 freetype graphviz ghostscript
      libjpeg libpng libtiff libxml2 zlib tetex librsvg libtool;
    inherit (xlibs) libX11;
  };

  inkscape = import ../applications/graphics/inkscape {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig zlib
      popt libxml2 libxslt libpng boehmgc fontconfig
      libsigcxx lcms boost gettext cairomm
      python pyxml makeWrapper;
    inherit (gtkLibs) gtk glib glibmm gtkmm;
    inherit (xlibs) libXft;
  };

  ion3 = import ../applications/window-managers/ion-3 {
    inherit fetchurl stdenv x11 gettext groff;
    lua = lua5;
  };

  irssi = import ../applications/networking/irc/irssi {
    inherit stdenv fetchurl pkgconfig ncurses openssl;
    inherit (gtkLibs) glib;
  };

  jedit = import ../applications/editors/jedit {
    inherit fetchurl stdenv ant;
  };

  joe = import ../applications/editors/joe {
    inherit stdenv fetchurl;
  };

  jwm = import ../applications/window-managers/jwm {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXext libXinerama libXpm libXft;
  };

  k3b = import ../applications/misc/k3b {
    inherit stdenv fetchurl kdelibs x11 zlib libpng libjpeg perl qt3;
  };

  keyjnote = import ../applications/office/keyjnote {
    inherit fetchurl stdenv xpdf pil pyopengl pygame makeWrapper lib python;

    # XXX These are the PyOpenGL dependencies, which we need here.
    inherit setuptools mesa freeglut;
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

  kile = import ../applications/editors/kile {
    inherit stdenv fetchurl perl arts kdelibs zlib libpng libjpeg freetype expat;
    inherit (xlibs) libX11 libXt libXext libXrender libXft;
    qt = qt3;
  };

  /*kiwixBuilderFun = lib.sumArgs (import ../applications/misc/kiwixbuilder) {
    inherit builderDefs;
    inherit (gnome) glib;
    zlib = zlibStatic;
  };

  kiwixBuilder = kiwixBuilderFun null;*/

  konversation = import ../applications/networking/irc/konversation {
    inherit fetchurl stdenv perl arts kdelibs zlib libpng libjpeg expat;
    inherit (xlibs) libX11 libXt libXext;
    qt = qt3;
  };

  kuickshow = import ../applications/graphics/kuickshow {
    inherit fetchurl stdenv kdelibs arts libpng libjpeg libtiff libungif imlib expat perl;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  lame = import ../applications/audio/lame {
    inherit fetchurl stdenv;
  };

  ladspaH = import ../applications/audio/ladspa-plugins/ladspah.nix {
    inherit fetchurl stdenv builderDefs stringsWithDeps;
  };

  ladspaPlugins = import ../applications/audio/ladspa-plugins {
    inherit fetchurl stdenv builderDefs stringsWithDeps fftw ladspaH pkgconfig;
  };

  ldcpp = composedArgsAndFun (selectVersion ../applications/networking/p2p/ldcpp "1.0.1") {
    inherit builderDefs scons pkgconfig bzip2 openssl;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade;
    inherit (xlibs) libX11;
  };

  links = import ../applications/networking/browsers/links {
    inherit fetchurl stdenv;
  };

  lynx = import ../applications/networking/browsers/lynx {
    inherit fetchurl stdenv ncurses openssl;
  };

  lyx = import ../applications/misc/lyx {
   inherit fetchurl stdenv texLive python;
   qt = qt4;
  };

  maudeMode = import ../applications/editors/emacs-modes/maude {
    inherit fetchurl stdenv emacs;
  };

  mercurial = import ../applications/version-management/mercurial {
    inherit fetchurl stdenv python makeWrapper getConfig tk;
    guiSupport = getConfig ["mercurial" "guiSupport"] false; # for hgk (gitk gui for hg)
  };

  midori = builderDefsPackage (import ../applications/networking/browsers/midori) {
    inherit imagemagick intltool python pkgconfig webkit libxml2
      which gettext makeWrapper file;
    inherit (gtkLibs) gtk glib;
    inherit (gnome) gtksourceview;
  };

  minicom = builderDefsPackage (selectVersion ../tools/misc/minicom "2.3") {
    inherit ncurses;
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

  mpg321 = import ../applications/audio/mpg321 {
    inherit stdenv fetchurl libao libmad libid3tag zlib;
  };

  MPlayer = lib.composedArgsAndFun (import ../applications/video/MPlayer) {
    inherit fetchurl stdenv freetype x11 zlib libtheora libcaca freefont_ttf libdvdnav
      cdparanoia;
    inherit (xlibs) libX11 libXv libXinerama libXrandr;
    alsaSupport = true;
    alsa = alsaLib;
    theoraSupport = true;
    cacaSupport = true;
    xineramaSupport = true;
    randrSupport = true;
    cddaSupport = true;
  };

  MPlayerPlugin = browser:
    import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
      inherit browser;
      inherit fetchurl stdenv pkgconfig gettext;
      inherit (xlibs) libXpm;
      # !!! should depend on MPlayer
    };

  mrxvt = import ../applications/misc/mrxvt {
    inherit lib fetchurl stdenv;
    inherit (xlibs) libXaw xproto libXt libX11 libSM libICE;
  };

  multisync = import ../applications/misc/multisync {
    inherit fetchurl stdenv autoconf automake libtool pkgconfig;
    inherit (gnome) gtk glib ORBit2 libbonobo libgnomeui GConf;
  };

  mutt = import ../applications/networking/mailreaders/mutt {
    inherit fetchurl stdenv ncurses which openssl gdbm;
  };

  msmtp = import ../applications/networking/msmtp {
    inherit fetchurl stdenv;
  };

  mythtv = import ../applications/video/mythtv {
    inherit fetchurl stdenv which x11 xlibs lame zlib mesa freetype perl alsaLib;
    qt3 = qt3mysql;
  };

  nano = import ../applications/editors/nano {
    inherit fetchurl stdenv ncurses gettext;
  };

  nanoDiet = lowPrio (appendToName "diet" (import ../applications/editors/nano {
    inherit fetchurl gettext;
    ncurses = ncursesDiet;
    stdenv = useDietLibC stdenv;
  }));

  nedit = import ../applications/editors/nedit {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXpm;
    motif = lesstif;
  };

  nxml = import ../applications/editors/emacs-modes/nxml {
    inherit fetchurl stdenv;
  };

  openoffice = import ../applications/office/openoffice {
    inherit fetchurl stdenv pam python tcsh libxslt
      perl perlArchiveZip perlCompressZlib zlib libjpeg
      expat pkgconfig freetype fontconfig libwpd libxml2
      db4 sablotron curl libsndfile flex zip unzip libmspack
      getopt file neon cairo which icu jdk ant hsqldb
      cups openssl bison;
    boost = boostVersionChoice "1.36.0";
    inherit (xlibs) libXaw libXext libX11 libXtst libXi libXinerama;
    inherit (gtkLibs) gtk;
  };

  opera = import ../applications/networking/browsers/opera {
    inherit fetchurl zlib glibc stdenv;
# stdenv = overrideGCC stdenv gcc40;
    inherit (xlibs) libX11 libSM libICE libXt libXext;
    qt = qt3gcc33;
    #33motif = lesstif;
    libstdcpp5 = gcc33.gcc;
  };

  pan = import ../applications/networking/newsreaders/pan {
    inherit fetchurl stdenv pkgconfig perl pcre gmime gettext;
    inherit (gtkLibs) gtk;
    spellChecking = false;
  };

  pidgin = import ../applications/networking/instant-messengers/pidgin {
    inherit fetchurl stdenv pkgconfig perl perlXMLParser libxml2 nss
      gtkspell aspell gettext ncurses avahi dbus dbus_glib lib intltool;
    openssl = if (getConfig ["pidgin" "openssl"] true) then openssl else null;
    gnutls = if (getConfig ["pidgin" "gnutls"] false) then gnutls else null;
    GStreamer = gst_all.gstreamer;
    inherit (gtkLibs) gtk;
    inherit (gnome) startupnotification;
    inherit (xlibs) libXScrnSaver;
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

  qemu = import ../applications/virtualization/qemu/0.9.1.nix {
    inherit fetchurl SDL zlib which;
    stdenv = overrideGCC stdenv gcc34;
  };

  qemuImage = composedArgsAndFun
    (selectVersion ../applications/virtualization/qemu/linux-img "0.2") {
    inherit builderDefs fetchurl stdenv;
  };

  quack = import ../applications/editors/emacs-modes/quack {
    inherit fetchurl stdenv emacs;
  };

  ratpoison = import ../applications/window-managers/ratpoison {
    inherit fetchurl stdenv fontconfig readline;
    inherit (xlibs) libX11 inputproto libXt libXpm libXft
      libXtst xextproto;
  };

  rcs = import ../applications/version-management/rcs {
    inherit fetchurl stdenv;
  };

  rdesktop = import ../applications/networking/remote/rdesktop {
    inherit fetchurl stdenv openssl;
    inherit (xlibs) libX11;
  };

  RealPlayer = import ../applications/video/RealPlayer {
    inherit fetchurl stdenv;
    inherit (gtkLibs) glib pango atk gtk;
    inherit (xlibs) libX11;
    libstdcpp5 = gcc33.gcc;
  };

  remember = import ../applications/editors/emacs-modes/remember {
    inherit fetchurl stdenv texinfo emacs bbdb;
  };

  rsync = import ../applications/networking/sync/rsync {
    inherit fetchurl stdenv acl;
  };

  rxvt = import ../applications/misc/rxvt {
    inherit lib fetchurl stdenv;
    inherit (xlibs) libXt libX11;
  };

  # = urxvt
  rxvt_unicode = import ../applications/misc/rxvt_unicode {
    inherit lib fetchurl stdenv perl;
    inherit (xlibs) libXt libX11 libXft;
  };

  sbagen = import ../applications/misc/sbagen {
    inherit fetchurl stdenv;
  };

  skype_linux = import ../applications/networking/skype {
    inherit fetchurl stdenv;
    inherit glibc alsaLib freetype fontconfig libsigcxx gcc;
    inherit (xlibs) libSM libICE libXi libXrender libXrandr libXfixes libXcursor
                    libXinerama libXext libX11 libXv libXScrnSaver;
  };

  slim = import ../applications/display-managers/slim {
    inherit fetchurl stdenv x11 libjpeg libpng freetype pam;
    inherit (xlibs) libXmu;
  };

  sndBase =  builderDefsPackage (import ../applications/audio/snd) {
    inherit fetchurl stdenv stringsWithDeps lib fftw;
    inherit pkgconfig gmp gettext;
    inherit (xlibs) libXpm libX11;
    inherit (gtkLibs) gtk glib;
  };

  snd = sndBase.passthru.function {
    inherit guile mesa libtool jackaudio alsaLib;
  };

  sox = import ../applications/misc/audio/sox {
    inherit fetchurl stdenv lib composableDerivation;
    # optional features
    inherit alsaLib libao;
    inherit libsndfile libogg flac libmad lame libsamplerate;
    # Using the default nix ffmpeg I get this error when linking
    # .libs/libsox_la-ffmpeg.o: In function `audio_decode_frame':
    # /tmp/nix-7957-1/sox-14.0.0/src/ffmpeg.c:130: undefined reference to `avcodec_decode_audio2
    # That's why I'v added ffmpeg_svn
    ffmpeg = ffmpeg_svn;
  };

  spoofax = import ../applications/editors/eclipse/plugins/spoofax {
    inherit fetchurl stdenv;
  };


  stumpwm = builderDefsPackage (import ../applications/window-managers/stumpwm) {
    inherit clisp texinfo;
  };

  subversion = subversion15;

  subversion14 = makeOverridable (import ../applications/version-management/subversion-1.4.x) {
    inherit fetchurl stdenv apr aprutil expat swig zlib jdk;
    neon = neon026;
    bdbSupport = getConfig ["subversion" "bdbSupport"] true;
    httpServer = getConfig ["subversion" "httpServer"] false;
    sslSupport = getConfig ["subversion" "sslSupport"] true;
    pythonBindings = getConfig ["subversion" "pythonBindings"] false;
    perlBindings = getConfig ["subversion" "perlBindings"] false;
    javahlBindings = getConfig ["subversion" "javahlBindings"] false;
    compressionSupport = getConfig ["subversion" "compressionSupport"] true;
    httpd = apacheHttpd;
  };

  subversion15 = makeOverridable (import ../applications/version-management/subversion-1.5.x) {
    inherit fetchurl stdenv apr aprutil expat swig zlib jdk;
    neon = neon028;
    bdbSupport = getConfig ["subversion" "bdbSupport"] true;
    httpServer = getConfig ["subversion" "httpServer"] false;
    httpSupport = getConfig ["subversion" "httpSupport"] true;
    sslSupport = getConfig ["subversion" "sslSupport"] true;
    pythonBindings = getConfig ["subversion" "pythonBindings"] false;
    perlBindings = getConfig ["subversion" "perlBindings"] false;
    javahlBindings = getConfig ["subversion" "javahlBindings"] false;
    compressionSupport = getConfig ["subversion" "compressionSupport"] true;
    httpd = apacheHttpd;
  };

  subversionStatic = lowPrio (appendToName "static" (import ../applications/version-management/subversion-1.5.x {
    inherit fetchurl stdenv apr aprutil expat swig jdk;
    neon = import ../development/libraries/neon/0.28.nix {
        inherit fetchurl stdenv libxml2 zlib openssl;
        compressionSupport = true;
        sslSupport = true;
        static = true;
        shared = false;
    };
    zlib = import ../development/libraries/zlib {
      inherit fetchurl stdenv;
      static = true;
    };
    bdbSupport = true;
    httpServer = false;
    httpSupport = true;
    sslSupport = true;
    pythonBindings = false;
    perlBindings = false;
    javahlBindings = false;
    compressionSupport = true;
    httpd = null;
    static = true;
  }));

  svk = perlSVK;

  sylpheed = import ../applications/networking/mailreaders/sylpheed {
    inherit fetchurl stdenv pkgconfig openssl gpgme;
    inherit (gtkLibs) gtk;
    sslSupport = true;
    gpgSupport = true;
  };

  # linux only by now
  synergy = import ../applications/misc/synergy {
    inherit bleedingEdgeRepos stdenv x11;
    inherit (xlibs) xextproto libXtst inputproto;
  };

  tailor = builderDefsPackage (selectVersion ../applications/version-management/tailor "0.9.35") {
    inherit makeWrapper python;
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
    inherit kdelibs kdebase;
    withKde = pkgs.getConfig ["taskJuggler" "kde"] false;
  };

  thinkingRock = import ../applications/misc/thinking-rock {
    inherit fetchurl stdenv;
  };

  thunderbird = import ../applications/networking/mailreaders/thunderbird-2.x {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  };

  timidity = import ../tools/misc/timidity {
    inherit fetchurl stdenv alsaLib;
  };

  tla = import ../applications/version-management/arch {
    inherit fetchurl stdenv diffutils gnutar gnupatch which;
  };

  unison = import ../applications/networking/sync/unison {
    inherit fetchurl stdenv ocaml lablgtk makeWrapper;
    inherit (xorg) xset fontschumachermisc;
  };

  uucp = builderDefsPackage (selectVersion ../tools/misc/uucp "1.07") {
  };

  valknut = import ../applications/networking/p2p/valknut {
    inherit fetchurl stdenv perl x11 libxml2 libjpeg libpng openssl dclib;
    qt = qt3;
  };

  vim = import ../applications/editors/vim {
    inherit fetchurl stdenv ncurses lib;
  };

  vimDiet = lowPrio (appendToName "diet" (import ../applications/editors/vim-diet {
    inherit fetchurl;
    ncurses = ncursesDiet;
    stdenv = useDietLibC stdenv;
  }));

  vimHugeX = import ../applications/editors/vim {
    inherit fetchurl stdenv lib ncurses pkgconfig
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

  /*virtualboxFun = lib.sumArgs (selectVersion ../applications/virtualization/virtualbox "1.5.2") {
    inherit stdenv fetchurl builderDefs bridge_utils umlutilities kernelHeaders
      wine jre libxslt SDL qt3 openssl zlib;
    inherit (xorg) libXcursor;
    inherit (gnome) libIDL;
  };

  virtualbox = virtualboxFun null;*/

  vlc = import ../applications/video/vlc {
    inherit fetchurl stdenv perl x11 wxGTK
            zlib mpeg2dec a52dec libmad
            libdvdread libdvdnav libdvdcss;
    inherit (xlibs) libXv;
    alsa = alsaLib;
    ffmpeg = ffmpeg_svn;
  };

  vorbisTools = import ../applications/audio/vorbis-tools {
    inherit fetchurl stdenv libogg libvorbis libao pkgconfig curl glibc
      speex flac;
  };

  w3m = import ../applications/networking/browsers/w3m {
    inherit fetchurl stdenv ncurses openssl boehmgc gettext zlib;
    graphicsSupport = false;
    inherit (gtkLibs1x) gdkpixbuf;
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

  wrapFirefox = browser: browserName: nameSuffix: import ../applications/networking/browsers/firefox-wrapper {
    inherit stdenv nameSuffix makeWrapper browser browserName;
    plugins =
      let enableAdobeFlash = getConfig [ browserName "enableAdobeFlash" ] true
            && system == "i686-linux";
      in
       ([]
        ++ lib.optional (!enableAdobeFlash) gnash
        ++ lib.optional (enableAdobeFlash)  flashplayer
        # RealPlayer is disabled by default for legal reasons.
        ++ lib.optional (system != "i686-linux" && getConfig [browserName "enableRealPlayer"] false) RealPlayer
        ++ lib.optional (getConfig [browserName "enableMPlayer"] true) (MPlayerPlugin browser)
        ++ lib.optional (supportsJDK && getConfig [browserName "jre"] false && jrePlugin ? mozillaPlugin) jrePlugin
       );
  };

  x11vnc =  composedArgsAndFun (selectVersion ../tools/X11/x11vnc "0.9.3") {
    inherit builderDefs openssl zlib libjpeg ;
    inherit (xlibs) libXfixes fixesproto libXdamage damageproto
      libX11 xproto libXtst libXinerama xineramaproto libXrandr randrproto
      libXext xextproto inputproto recordproto;
  };

  x2vnc =  composedArgsAndFun (selectVersion ../tools/X11/x2vnc "1.7.2") {
    inherit builderDefs;
    inherit (xlibs) libX11 xproto xextproto libXext libXrandr randrproto;
  };

  xaos = builderDefsPackage (import ../applications/graphics/xaos) {
    inherit (xlibs) libXt libX11 libXext xextproto xproto;
    inherit gsl aalib zlib libpng intltool gettext perl;
  };

  xara = import ../applications/graphics/xara {
    inherit fetchurl stdenv autoconf automake libtool gettext cvs wxGTK
      pkgconfig libxml2 zip libpng libjpeg shebangfix perl freetype;
    inherit (gtkLibs) gtk;
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
    inherit fetchurl stdenv wxGTK chmlib;
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
    inherit fetchurl stdenv pkgconfig x11 xineLib libpng readline ncurses curl;
    inherit (xorg) libXext libXv libXxf86vm libXtst inputproto;
  };

  xmms = import ../applications/audio/xmms {
    inherit fetchurl libogg libvorbis alsaLib;
    inherit (gnome) esound;
    inherit (gtkLibs1x) glib gtk;
    stdenv = overrideGCC stdenv gcc34; # due to problems with gcc 4.x
  };

  xmobar = import ../applications/misc/xmobar {
    inherit cabal X11;
  };

  xmonad = import ../applications/window-managers/xmonad {
    inherit cabal X11;
    inherit (xlibs) xmessage;
  };

  xmonadContrib = import ../applications/window-managers/xmonad/xmonad-contrib.nix {
    inherit cabal xmonad X11;
  };

  xneur = import ../applications/misc/xneur {
    inherit fetchurl stdenv pkgconfig pcre libxml2 aspell imlib2 xosd;
    GStreamer=gst_all.gstreamer;
    inherit (xlibs) libX11 libXpm libXt libXext;
    inherit (gtkLibs) glib;
  };

  xneur_0_8 = import ../applications/misc/xneur/0.8.nix {
    inherit fetchurl stdenv pkgconfig pcre libxml2 aspell imlib2 xosd;
    GStreamer=gst_all.gstreamer;
    inherit (xlibs) libX11 libXpm libXt libXext;
    inherit (gtkLibs) glib;
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

  xscreensaverBase =  composedArgsAndFun (import ../applications/graphics/xscreensaver) {
    inherit stdenv fetchurl builderDefs lib pkgconfig bc perl intltool;
    inherit (xlibs) libX11 libXmu;
  };

  xscreensaver = xscreensaverBase.passthru.function {
    flags = ["GL" "gdkpixbuf" "DPMS" "gui" "jpeg"];
    inherit mesa libxml2 libjpeg;
    inherit (gtkLibs) gtk;
    inherit (gnome) libglade;
  };

  xterm = import ../applications/misc/xterm {
    inherit fetchurl stdenv ncurses freetype pkgconfig;
    inherit (xlibs) libXaw xproto libXt libX11 libSM libICE libXext libXft luit;
  };

  xlaunch = import ../tools/X11/xlaunch {
    inherit stdenv;
    inherit (xorg) xorgserver;
  };

  xmacro = import ../tools/X11/xmacro {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi
  libXtst xextproto inputproto;
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
    inherit fetchurl stdenv perl perlXMLParser pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (gnome) scrollkeeper libglade;
    inherit (xlibs) libXmu libXext;
  };

  # doesn't compile yet - in case someone else want's to continue ..
  qgis =  composedArgsAndFun (selectVersion ../applications/misc/qgis "0.11.0") {
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

  castleCombat = import ../games/castle-combat {
    inherit fetchurl stdenv python pygame twisted lib numeric makeWrapper;
  };

  construoBase =  composedArgsAndFun (selectVersion ../games/construo "0.2.2") {
    inherit stdenv fetchurl builderDefs
      zlib;
    inherit (xlibs) libX11 xproto;
  };

  construo = construoBase.passthru.function {
    inherit mesa freeglut;
  };

  exult = import ../games/exult {
    inherit fetchurl stdenv SDL SDL_mixer zlib libpng unzip;
  };

  exultSnapshot = lowPrio (import ../games/exult/snapshot.nix {
    inherit fetchurl stdenv SDL SDL_mixer zlib libpng unzip
      autoconf automake libtool flex bison;
  });

  fsg = import ../games/fsg {
    inherit stdenv fetchurl pkgconfig mesa;
    inherit (gtkLibs) glib gtk;
    inherit (xlibs) libX11 xproto;
    wxGTK = wxGTK28deps {unicode = false;};
  };

  fsgAltBuild = import ../games/fsg/alt-builder.nix {
    inherit stdenv fetchurl mesa;
    wxGTK = wxGTK28deps {unicode = false;};
    inherit (xlibs) libX11 xproto;
    stringsWithDeps = import ../lib/strings-with-deps.nix {
      inherit stdenv lib;
    };
    inherit builderDefs;
  };

  gemrb = import ../games/gemrb {
    inherit fetchurl stdenv SDL openal freealut zlib libpng python;
  };

  gnuchess = builderDefsPackage (import ../games/gnuchess) {
    flex = flex2535;
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

  sgtpuzzles = builderDefsPackage (import ../games/sgt-puzzles) {
    inherit (gtkLibs) gtk glib;
    inherit pkgconfig;
    inherit (xlibs) libX11;
  };

  # You still can override by passing more arguments.
  spaceOrbit =  composedArgsAndFun (selectVersion ../games/orbit "1.01") {
    inherit fetchurl stdenv builderDefs mesa freeglut;
    inherit (gnome) esound;
    inherit (xlibs) libXt libX11 libXmu libXi libXext;
  };

  superTuxKart = import ../games/super-tux-kart {
    inherit fetchurl stdenv plib SDL openal freealut mesa
      libvorbis libogg gettext;
  };

  teeworlds = import ../games/teeworlds {
    inherit fetchurl stdenv python alsaLib mesa SDL;
    inherit (xlibs) libX11;
  };

  /*tpm = import ../games/thePenguinMachine {
    inherit stdenv fetchurl pil pygame SDL;
    python24 = python;
  };*/

  ut2004demo = import ../games/ut2004demo {
    inherit fetchurl stdenv xlibs mesa;
  };

  xboard = builderDefsPackage (import ../games/xboard) {
    inherit (xlibs) libX11 xproto libXt libXaw libSM
      libICE libXmu libXext;
    inherit gnuchess;
  };

  xsokoban = builderDefsPackage (import ../games/xsokoban) {
    inherit (xlibs) libX11 xproto libXpm libXt;
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

  gnome = recurseIntoAttrs (import ../desktops/gnome {
    inherit
      fetchurl stdenv pkgconfig
      flex bison popt zlib libxml2 libxslt
      perl perlXMLParser docbook_xml_dtd_42 docbook_xml_dtd_412
      gettext x11 libtiff libjpeg libpng gtkLibs xlibs bzip2
      libcm python dbus_glib ncurses which libxml2Python
      iconnamingutils openssl hal samba fam libgcrypt libtasn1
      xmlto  docbook2x  docbook_xsl intltool;
  });

  kdelibs = import ../desktops/kde/kdelibs {
    inherit
      fetchurl stdenv xlibs zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool
      expat freetype bzip2 cups attr acl;
    qt = qt3;
  };

  kde4 = recurseIntoAttrs (import ../desktops/kde-4 {
    inherit
      fetchurl fetchsvn zlib perl openssl pcre pkgconfig libjpeg libpng libtiff
      libxml2 libxslt libtool libusb expat freetype bzip2 cmake cluceneCore libgcrypt gnupg
      cppunit cyrus_sasl openldap enchant exiv2 samba nss log4cxx aspell
      shared_mime_info alsaLib libungif cups mesa boost gpgme gettext redland
      xineLib libgphoto2 djvulibre libogg flac lame libvorbis poppler readline
      saneBackends chmlib python libzip gmp sqlite libidn runCommand lib
      openbabel ocaml facile stdenv jasper fam indilib libnova
      libarchive dbus bison;
    cdparanoia = cdparanoiaIII;
    inherit (xlibs)
      inputproto kbproto scrnsaverproto xextproto xf86miscproto
      xf86vidmodeproto xineramaproto xproto libICE libX11 libXau libXcomposite
      libXcursor libXdamage libXdmcp libXext libXfixes libXft libXi libXpm
      libXrandr libXrender libXScrnSaver libXt libXtst libXv libXxf86misc
      libxkbfile libXinerama;
    inherit (gtkLibs) glib;
    qt = qt4;
    openexr = openexr_1_6_1 ;
  });

  kde42 = import ../desktops/kde-4.2 (pkgs // {
    openexr = openexr_1_6_1;
  });

  kdebase = import ../desktops/kde/kdebase {
    inherit
      fetchurl stdenv pkgconfig x11 xlibs zlib libpng libjpeg perl
      kdelibs openssl bzip2 fontconfig pam hal dbus;
    inherit (gtkLibs) glib;
    qt = qt3;
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
    inherit fetchurl stdenv readline libpng zlib x11 lesstif93 freeglut perl;
    inherit (xlibs) libXpm libXaw libX11 libXext libXt;
    inherit mesa glew libtiff lynx rxp sablotron jdk transfig gv gnuplot;
    lesstif = lesstif93;
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

  /* liblapack = import ../development/libraries/science/math/liblapack {
    inherit fetchurl stdenv gfortran;
  }; */

  ### SCIENCE/LOGIC

  coq = import ../applications/science/logic/coq {
    inherit fetchurl stdenv ocaml ncurses;
  };

  ### SCIENCE / ELECTRONICS

  ngspice = import ../applications/science/electronics/ngspice {
    inherit fetchurl stdenv readline;
  };

  ### SCIENCE / MATH

  maxima = import ../applications/science/math/maxima {
    inherit fetchurl stdenv clisp;
  };

  scilab = (import ../applications/science/math/scilab) {
    inherit stdenv fetchurl lib g77;
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

  busybox = import ../misc/busybox {
    inherit fetchurl stdenv;
  };

  cups = import ../misc/cups {
    inherit fetchurl stdenv zlib libjpeg libpng libtiff pam openssl;
  };

  dblatex = import ../misc/tex/dblatex {
    inherit fetchurl stdenv python libxslt tetex;
  };

  dosbox = import ../misc/emulators/dosbox {
    inherit fetchurl stdenv SDL;
  };

  dpkg = import ../tools/package-management/dpkg {
    inherit fetchurl stdenv perl zlib bzip2;
  };

  freestyle = import ../misc/freestyle {
    inherit fetchurl freeglut qt4 libpng lib3ds libQGLViewer swig;
    inherit (xlibs) libXi;
    #stdenv = overrideGCC stdenv gcc41;
    inherit stdenv python;
  };

  generator = import ../misc/emulators/generator {
    inherit fetchurl stdenv SDL nasm zlib bzip2 libjpeg;
    inherit (gtkLibs1x) gtk;
  };

  ghostscript = import ../misc/ghostscript {
    inherit fetchurl stdenv libjpeg libpng libtiff zlib x11 pkgconfig
      fontconfig cups openssl;
    x11Support = false;
    cupsSupport = true;
  };

  ghostscriptX = lowPrio (appendToName "with-X" (import ../misc/ghostscript {
    inherit fetchurl stdenv libjpeg libpng libtiff zlib x11 pkgconfig
      fontconfig cups openssl;
    x11Support = true;
    cupsSupport = true;
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
    inherit (xlibs) libX11 xextproto libXtst
    imake libXi libXext;
  };

  lazylist = import ../misc/tex/lazylist {
    inherit fetchurl stdenv tetex;
  };

  linuxwacom = import ../misc/linuxwacom {
    inherit fetchurl stdenv;
    inherit (xlibs) libX11 libXi;
  };

  martyr = import ../development/libraries/martyr {
    inherit stdenv fetchurl apacheAnt;
  };

  maven = import ../misc/maven/maven-1.0.nix {
    inherit stdenv fetchurl jdk;
  };

  # don't have time for the source build right now
  # maven2
  mvn_bin = import ../misc/maven/maven-2.nix {
    inherit fetchurl stdenv;
  };

  nix = import ../tools/package-management/nix {
    inherit fetchurl stdenv perl curl bzip2 openssl;
    aterm = aterm242fixes;
    db4 = db45;
  };

  # The bleeding edge.
  nixUnstable = import ../tools/package-management/nix/unstable.nix {
    inherit fetchurl stdenv perl curl bzip2 openssl;
    aterm = aterm242fixes;
    db4 = db45;
    supportOldDBs = getPkgConfig "nix" "OldDBSupport" true;
    storeDir = getPkgConfig "nix" "storeDir" "/nix/store";
    stateDir = getPkgConfig "nix" "stateDir" "/nix/var";
  };

  nixCustomFun = src: preConfigure: enableScripts: configureFlags:
    import ../tools/package-management/nix/custom.nix {
      inherit fetchurl stdenv perl curl bzip2 openssl src preConfigure automake
        autoconf libtool configureFlags enableScripts lib bison;
      flex = flex2533;
      aterm = aterm242fixes;
      db4 = db45;
      inherit docbook5_xsl libxslt docbook5 docbook_xml_dtd_43 w3m;
    };

  disnix = import ../tools/package-management/disnix {
    inherit stdenv fetchsvn openssl dbus autoconf automake pkgconfig dbus_glib;
  };

  DisnixService = import ../tools/package-management/disnix/DisnixService {
    inherit stdenv fetchsvn apacheAnt jdk axis2 shebangfix;
  };

  ntfs3g = import ../misc/ntfs-3g {
    inherit fetchurl stdenv utillinux;
  };

  ntfsprogs = import ../misc/ntfsprogs {
    inherit fetchurl stdenv;
  };

  pgadmin = import ../applications/misc/pgadmin {
    inherit fetchurl stdenv postgresql libxml2 libxslt openssl;
    wxGTK = wxGTK28;
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

  psi = builderDefsPackage
    (selectVersion ../applications/networking/instant-messengers/psi "0.12")
    {
      inherit builderDefs zlib aspell sox openssl;
      inherit (xlibs) xproto libX11 libSM libICE;
      qt = qt4;
    };

  putty = import ../applications/networking/remote/putty {
    inherit stdenv fetchurl ncurses;
    inherit (gtkLibs1x) gtk;
  };

  rssglx = import ../misc/screensavers/rss-glx {
    inherit fetchurl stdenv x11 mesa pkgconfig imagemagick libtiff bzip2;
  };

  xlockmore = import ../misc/screensavers/xlockmore {
    inherit fetchurl stdenv pam x11 freetype;
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
    inherit (ghc68executables) hasktags;
  };

  synaptics = import ../misc/synaptics {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXi libXext pixman xf86inputevdev;
    inherit (xorg) xorgserver;
  };

  tetex = import ../misc/tex/tetex {
    inherit fetchurl stdenv flex bison zlib libpng ncurses ed;
  };

  /*
  tetexX11 = import ../misc/tex/tetex {
    inherit fetchurl stdenv flex bison zlib libpng ncurses ed;
    inherit (xlibs) libX11 libXext libXmu libXaw libXt libXpm;
    inherit freetype t1lib;
    builderX11 = true;
  };
  */

  texFunctions = import ../misc/tex/nix {
    inherit stdenv perl tetex graphviz ghostscript makeFontsConf;
  };

  texLive = builderDefsPackage (import ../misc/tex/texlive) {
    inherit builderDefs zlib bzip2 ncurses libpng ed
      gd t1lib freetype icu perl ruby expat curl
      libjpeg bison;
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
      sqlite subversion pysqlite;
  };

  wine = import ../misc/emulators/wine {
    inherit fetchurl stdenv flex bison mesa ncurses
      libpng libjpeg alsaLib lcms xlibs freetype
      fontconfig fontforge libxml2 libxslt openssl;
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

}; in pkgs
