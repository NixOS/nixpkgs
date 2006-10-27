/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */
   

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


rec {


  ### Symbolic names.


  x11 = xlibsWrapper;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X libraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = xorg // {xlibs = xlibsWrapper;};


  ### Helper functions.


  # Override the compiler in stdenv for specific packages.
  overrideGCC = stdenv: gcc: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // { NIX_GCC = gcc; });
    };

  # Add some arbitrary packages to buildInputs for specific packages.
  # Used to override packages in stenv like Make.  Should not be used
  # for other dependencies.
  overrideInStdenv = stdenv: pkgs: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args //
        { buildInputs = (if args ? buildInputs then args.buildInputs else []) ++ pkgs; }
      );
    };

  addAttrsToDerivation = extraAttrs: stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // extraAttrs); };

  # Override the setup script of stdenv.  Useful for testing new
  # versions of the setup script without causing a rebuild of
  # everything.
  #
  # Example:
  #   randomPkg = import ../bla { ...
  #     stdenv = overrideSetup stdenv ../stdenv/generic/setup-latest.sh;
  #   };
  overrideSetup = stdenv: setup: stdenv.regenerate setup;

  # Return a modified stdenv that uses dietlibc to create small
  # statically linked binaries.
  useDietLibC = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        # libcompat.a contains some commonly used functions.
        NIX_LDFLAGS = "-lcompat";
        
        # These are added *after* the command-line flags, so we'll
        # always optimise for size.
        NIX_CFLAGS_COMPILE =
          (if args ? NIX_CFLAGS_COMPILE then args.NIX_CFLAGS_COMPILE else "")
          + " -Os -s -D_BSD_SOURCE=1";
        
        configureFlags =
          (if args ? configureFlags then args.configureFlags else "")
          + " --disable-shared"; # brrr...

        NIX_GCC = import ../build-support/gcc-wrapper {
          inherit stdenv;
          libc = dietlibc;
          inherit (gcc) gcc binutils name nativeTools nativePrefix;
          nativeLibc = false;
        };
      });
      isDietLibC = true;
    };

  # Return a modified stdenv that tries to build statically linked
  # binaries.
  makeStaticBinaries = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        configureFlags =
          (if args ? configureFlags then args.configureFlags else "")
          + " --disable-shared"; # brrr...
      });
    };

  # Applying this to an attribute set will cause nix-env to look
  # inside the set for derivations.
  recurseIntoAttrs = attrs: attrs // {recurseForDerivations = true;};

  useFromStdenv = hasIt: it: alternative: if hasIt then it else alternative;

  library = import ../lib;

  # Return an attribute from the Nixpkgs configuration file, or
  # a default value if the attribute doesn't exist.
  getConfig = attrPath: default: library.getAttr attrPath default config;

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


  ### STANDARD ENVIRONMENT


  defaultStdenv =
    (import ../stdenv {
      inherit system stdenvType;
      allPackages = import ./all-packages.nix;
    }).stdenv;

  stdenv = if bootStdenv == null then defaultStdenv else bootStdenv;


  ### BUILD SUPPORT


  fetchcvs = import ../build-support/fetchcvs {
    inherit stdenv cvs nix;
  };

  fetchdarcs = import ../build-support/fetchdarcs {
    inherit stdenv darcs nix;
  };

  fetchsvn = import ../build-support/fetchsvn {
    inherit stdenv subversion nix openssh;
    sshSupport = true;
  };

  # Allow the stdenv to determine fetchurl, to cater for strange
  # requirements.
  fetchurl = useFromStdenv (stdenv ? fetchurl) stdenv.fetchurl
    (import ../build-support/fetchurl {
      inherit stdenv curl;
    });

  makeWrapper = ../build-support/make-wrapper/make-wrapper.sh;

  substituter = ../build-support/substitute/substitute.sh;


  ### TOOLS


  azureus = import ../tools/networking/p2p/azureus {
    inherit fetchurl stdenv jdk swt;
  };

  bc = import ../tools/misc/bc {
    inherit fetchurl stdenv flex;
  };

  bibtextools = import ../tools/typesetting/bibtex-tools {
    inherit fetchurl stdenv aterm tetex hevea sdf strategoxt;
  };

  bittorrent = import ../tools/networking/p2p/bittorrent {
    inherit fetchurl stdenv python pygtk makeWrapper;
  };

  bsdiff = import ../tools/compression/bsdiff {
    inherit fetchurl stdenv;
  };

  bzip2 = useFromStdenv (stdenv ? bzip2) stdenv.bzip2
    (import ../tools/compression/bzip2 {
      inherit fetchurl stdenv;
    });

  cabextract = import ../tools/archivers/cabextract {
    inherit fetchurl stdenv;
  };

  cksfv = import ../tools/networking/cksfv {
    inherit fetchurl stdenv;
  };

  coreutils = useFromStdenv (stdenv ? coreutils) stdenv.coreutils
    ((if stdenv ? isDietLibC
      then import ../tools/misc/coreutils-5
      else import ../tools/misc/coreutils)
    {
      inherit fetchurl stdenv;
    });

  cpio = import ../tools/archivers/cpio {
    inherit fetchurl stdenv;
  };

  curl = if stdenv ? curl then stdenv.curl else (assert false; null);

  dhcp = import ../tools/networking/dhcp {
    inherit fetchurl stdenv groff nettools coreutils iputils gnused bash;
  };

  dhcpWrapper = import ../tools/networking/dhcp-wrapper {
    inherit stdenv dhcp;
  };

  diffutils = useFromStdenv (stdenv ? diffutils) stdenv.diffutils
    (import ../tools/text/diffutils {
      inherit fetchurl stdenv coreutils;
    });

  ed = import ../tools/text/ed {
    inherit fetchurl stdenv;
  };

  enscript = import ../tools/text/enscript {
    inherit fetchurl stdenv;
  };

  exif = import ../tools/graphics/exif {
    inherit fetchurl stdenv pkgconfig libexif popt;
  };

  file = import ../tools/misc/file {
    inherit fetchurl stdenv;
  };

  findutils = useFromStdenv (stdenv ? findutils) stdenv.findutils
    (import ../tools/misc/findutils {
      inherit fetchurl stdenv coreutils;
    });

  findutils4227 = import ../tools/misc/findutils/4.2.27.nix {
    inherit fetchurl stdenv coreutils;
  };

  findutilsWrapper = import ../tools/misc/findutils-wrapper {
    inherit stdenv findutils;
  };

  gawk = useFromStdenv (stdenv ? gawk) stdenv.gawk
    (import ../tools/text/gawk {
      inherit fetchurl stdenv;
    });

  getopt = import ../tools/misc/getopt {
    inherit fetchurl stdenv;
  };

  gnugrep = useFromStdenv (stdenv ? gnugrep) stdenv.gnugrep
    (import ../tools/text/gnugrep {
      inherit fetchurl stdenv pcre;
    });

  gnupatch = import ../tools/text/gnupatch {
    inherit fetchurl stdenv;
  };

  gnupg = import ../tools/security/gnupg {
    inherit fetchurl stdenv readline;
    ideaSupport = true; # enable for IDEA crypto support
  };

  gnuplot = import ../tools/graphics/gnuplot {
    inherit fetchurl stdenv zlib libpng texinfo;
  };

  gnused = useFromStdenv (stdenv ? gnused) stdenv.gnused
    (import ../tools/text/gnused {
      inherit fetchurl stdenv;
    });

  gnused412 = import ../tools/text/gnused/4.1.2.nix {
    inherit fetchurl stdenv;
  };

  gnutar = useFromStdenv (stdenv ? gnutar) stdenv.gnutar
    (import ../tools/archivers/gnutar {
      inherit fetchurl stdenv;
    });

  gnutar151 = import ../tools/archivers/gnutar/1.15.1.nix {
    inherit fetchurl stdenv;
  };

  graphviz = import ../tools/graphics/graphviz {
    inherit fetchurl stdenv libpng libjpeg expat x11 yacc libtool;
    inherit (xlibs) libXaw;
  };

  groff = import ../tools/text/groff {
    inherit fetchurl stdenv;
  };

  grub = import ../tools/misc/grub {
    inherit fetchurl stdenv;
  };

  grubWrapper = import ../tools/misc/grub-wrapper {
     inherit stdenv grub diffutils gnused gnugrep coreutils;
  };

  gtkgnutella = import ../tools/networking/p2p/gtk-gnutella {
    inherit fetchurl stdenv pkgconfig libxml2;
    inherit (gtkLibs) glib gtk;
  };

  gzip = useFromStdenv (stdenv ? gzip) stdenv.gzip
    (import ../tools/compression/gzip {
      inherit fetchurl stdenv;
    });

  hevea = import ../tools/typesetting/hevea {
    inherit fetchurl stdenv ocaml;
  };

  jdiskreport = import ../tools/misc/jdiskreport {
    inherit fetchurl stdenv unzip jdk;
  };

  jing = import ../tools/text/xml/jing {
    inherit fetchurl stdenv unzip;
  };

  jing_tools = import ../tools/text/xml/jing/jing-script.nix {
    inherit fetchurl stdenv unzip;
    jre = blackdown;
  };

  less = import ../tools/misc/less {
    inherit fetchurl stdenv ncurses;
  };

  lhs2tex = import ../tools/typesetting/lhs2tex {
    inherit fetchurl stdenv ghc tetex polytable;
  };

  man = import ../tools/misc/man {
     inherit fetchurl stdenv db4 groff;
  };

  mjpegtools = import ../tools/video/mjpegtools {
    inherit fetchurl stdenv libjpeg;
    inherit (xlibs) libX11;
  };

  mktemp = import ../tools/security/mktemp {
    inherit fetchurl stdenv;
  };

  netcat = import ../tools/networking/netcat {
    inherit fetchurl stdenv;
  };

  nmap = import ../tools/security/nmap {
    inherit fetchurl stdenv;
  };

  openssh = import ../tools/networking/openssh {
    inherit fetchurl stdenv zlib openssl;
    inherit (xlibs) xauth;
    xforwarding = true;
  };

  par2cmdline = import ../tools/networking/par2cmdline {
    inherit fetchurl;
    stdenv = overrideGCC stdenv gcc34;
  };

  parted = import ../tools/misc/parted {
    inherit fetchurl stdenv e2fsprogs ncurses readline;
  };

  patch = useFromStdenv (stdenv ? patch) stdenv.patch gnupatch;

  ploticus = import ../tools/graphics/ploticus {
    inherit fetchurl stdenv zlib libpng;
    inherit (xlibs) libX11;
  };

  qtparted = import ../tools/misc/qtparted {
    inherit fetchurl stdenv e2fsprogs ncurses readline parted zlib;
    inherit (xlibs) libX11 libXext;
    qt3 = qt3NoMySQL;
  };

  realCurl = import ../tools/networking/curl {
    inherit fetchurl stdenv zlib;
    zlibSupport = !stdenv ? isDietLibC;
  };

  sablotron = import ../tools/text/xml/sablotron {
    inherit fetchurl stdenv expat;
  };

  screen = import ../tools/misc/screen {
    inherit fetchurl stdenv ncurses;
  };

  tightvnc = import ../tools/admin/tightvnc {
    inherit fetchurl stdenv x11 zlib libjpeg;
    inherit (xlibs) imake gccmakedep libXmu libXaw libXpm libXp;
  };

  trang = import ../tools/text/xml/trang {
    inherit fetchurl stdenv unzip;
    jre = blackdown;
  };

  transfig = import ../tools/graphics/transfig {
    inherit fetchurl stdenv libpng libjpeg zlib;
    inherit (xlibs) imake;
  };

  unzip = import ../tools/archivers/unzip {
    inherit fetchurl stdenv;
  };

  wget = import ../tools/networking/wget {
    inherit fetchurl stdenv gettext;
  };

  which = import ../tools/system/which {
    inherit fetchurl stdenv;
  };

  xmlroff = import ../tools/typesetting/xmlroff {
    inherit fetchurl stdenv pkgconfig libxml2 libxslt popt;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) libgnomeprint;
    inherit pangoxsl;
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


  bash = useFromStdenv (stdenv ? bash) stdenv.bash
    (import ../shells/bash {
      inherit fetchurl stdenv;
      bison = bison23;
    });

  tcsh = import ../shells/tcsh {
    inherit fetchurl stdenv ncurses;
  };


  ### DEVELOPMENT / COMPILERS


  abc =
    abcPatchable [];

  abcPatchable = patches : 
    import ../development/compilers/abc/default.nix {
      inherit stdenv fetchurl patches jre apacheAnt;
      # apacheAnt = apacheAntBlackdown14;
      javaCup = import ../development/libraries/java/cup {
        inherit stdenv fetchurl;
        jdk = blackdown;
      };
    };

  aspectj =
    import ../development/compilers/aspectj {
      inherit stdenv fetchurl jre;
    };

  blackdown = import ../development/compilers/blackdown {
    inherit fetchurl stdenv;
  };

  dylan = import ../development/compilers/gwydion-dylan {
    inherit fetchurl stdenv perl boehmgc yacc flex readline;
    dylan =
      import ../development/compilers/gwydion-dylan/binary.nix {
        inherit fetchurl stdenv;
      };
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

  gcc = useFromStdenv (stdenv ? gcc) stdenv.gcc gcc41;

  gcc295 = wrapGCC (import ../development/compilers/gcc-2.95 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc33 = wrapGCC (import ../development/compilers/gcc-3.3 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc34 = wrapGCC (import ../development/compilers/gcc-3.4 {
    inherit fetchurl stdenv noSysDirs;
  });

  gcc40 = wrapGCC (import ../development/compilers/gcc-4.0 {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = true;
  });

  gcc40arm = import ../build-support/gcc-cross-wrapper {
    nativeTools = false;
    nativeLibc = false;
    cross = "arm-linux";
    gcc = import ../development/compilers/gcc-4.0-cross {
      inherit fetchurl stdenv noSysDirs;
      langF77 = false;
      langCC = false;
      binutilsCross = binutilsArm;
      kernelHeadersCross = kernelHeadersArm;
      cross = "arm-linux";
    };
    inherit (stdenv.gcc) libc;
    binutils = binutilsArm;
    inherit stdenv;
  };

  gcc40mips = import ../build-support/gcc-cross-wrapper {
    nativeTools = false;
    nativeLibc = false;
    cross = "mips-linux";
    gcc = gcc40mipsboot;
    #inherit (stdenv.gcc) libc;
    libc = uclibcMips;
    binutils = binutilsMips;
    inherit stdenv;
  };

  gcc40mipsboot = import ../development/compilers/gcc-4.0-cross {
    inherit fetchurl stdenv noSysDirs;
    langF77 = false;
    langCC = false;
    binutilsCross = binutilsMips;
    kernelHeadersCross = kernelHeadersMips;
    cross = "mips-linux";
  };

  gcc40sparc = import ../build-support/gcc-cross-wrapper {
    nativeTools = false;
    nativeLibc = false;
    cross = "sparc-linux";
    gcc = import ../development/compilers/gcc-4.0-cross {
      inherit fetchurl stdenv noSysDirs;
      langF77 = false;
      langCC = false;
      binutilsCross = binutilsSparc;
      kernelHeadersCross = kernelHeadersSparc;
      cross = "sparc-linux";
    };
    inherit (stdenv.gcc) libc;
    binutils = binutilsSparc;
    inherit stdenv;
  };

  gcc41 = wrapGCC (import ../development/compilers/gcc-4.1 {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = false;
  });

  gccApple = wrapGCC (import ../development/compilers/gcc-apple {
    inherit fetchurl stdenv noSysDirs;
    profiledCompiler = true;
  });

  ghc = import ../development/compilers/ghc {
    inherit fetchurl stdenv perl ncurses readline;
    gcc = stdenv.gcc;
    ghc = ghcboot;
    m4 = gnum4;
  };

  ghcboot = import ../development/compilers/ghc/boot.nix {
    inherit fetchurl stdenv perl ncurses;
    readline = readline4;
  };

  ghcWrapper = assert uulib.ghc == ghc;
    import ../development/compilers/ghc-wrapper {
      inherit stdenv ghc;
      libraries = [ uulib ];
    };

  helium = import ../development/compilers/helium {
    inherit fetchurl stdenv ghc;
  };

  j2sdk14x = import ../development/compilers/jdk/default-1.4.nix {
    inherit fetchurl stdenv;
  };

  jdk = 
    if stdenv.isDarwin then 
      "/System/Library/Frameworks/JavaVM.framework/Versions/1.5.0/Home"
    else
      import ../development/compilers/jdk {
        inherit fetchurl stdenv unzip;
        inherit (xlibs) libX11 libXext;
      };

  jikes = import ../development/compilers/jikes {
    inherit fetchurl stdenv;
  };

  mono = import ../development/compilers/mono {
    inherit fetchurl stdenv bison pkgconfig;
    inherit (gtkLibs) glib;
  };

  monoDLLFixer = import ../build-support/mono-dll-fixer {
    inherit stdenv perl;
  };

  nasm = import ../development/compilers/nasm {
    inherit fetchurl stdenv;
  };

  ocaml = import ../development/compilers/ocaml {
    inherit fetchurl stdenv x11;
  };

  ocaml3080 = import ../development/compilers/ocaml/ocaml-3.08.0.nix {
    inherit fetchurl x11;
    stdenv = overrideGCC stdenv gcc34;
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
    ocaml = ocaml3080;
    inherit fetchurl stdenv mk noweb groff;
  };

  strategoLibraries = import ../development/compilers/strategoxt/libraries/stratego-libraries-0.17pre.nix {
    inherit stdenv fetchurl pkgconfig aterm;
  };

  strategoxt = import ../development/compilers/strategoxt {
    inherit fetchurl pkgconfig sdf aterm;
    stdenv = overrideInStdenv stdenv [gnumake380];
  };

  strategoxtUtils = import ../development/compilers/strategoxt/utils {
    inherit fetchurl pkgconfig stdenv aterm sdf strategoxt;
  };

  transformers = import ../development/compilers/transformers {
    inherit fetchurl pkgconfig sdf;
    aterm = aterm23x;

    stdenv = overrideGCC (overrideInStdenv stdenv [gnumake380]) gcc34;
    
    strategoxt = import ../development/compilers/strategoxt/strategoxt-0.14.nix {
      inherit fetchurl pkgconfig sdf;
      aterm = aterm23x;
      stdenv = overrideGCC (overrideInStdenv stdenv [gnumake380]) gcc34;
    };

    stlport =  import ../development/libraries/stlport {
      inherit fetchurl stdenv;
    };
  };

  visualcpp = import ../development/compilers/visual-c++ {
    inherit fetchurl stdenv cabextract;
  };

  win32hello = import ../development/compilers/visual-c++/test {
    inherit fetchurl stdenv visualcpp windowssdk;
  };

  wrapGCC = baseGCC: import ../build-support/gcc-wrapper {
    nativeTools = false;
    nativeLibc = false;
    gcc = baseGCC;
    libc = glibc;
    inherit stdenv binutils;
  };


  ### DEVELOPMENT / INTERPRETERS


  clisp = import ../development/interpreters/clisp {
    inherit fetchurl stdenv libsigsegv gettext;
  };

  guile = import ../development/interpreters/guile {
    inherit fetchurl stdenv ncurses readline;
  };

  jre = import ../development/interpreters/jre {
    inherit fetchurl stdenv;
  };

  kaffe =  import ../development/interpreters/kaffe {
    inherit fetchurl stdenv jikes alsaLib xlibs;
  };

  lua4 = import ../development/interpreters/lua-4 {
    inherit fetchurl stdenv;
  };

  lua5 = import ../development/interpreters/lua-5 {
    inherit fetchurl stdenv;
  };

  octave = import ../development/interpreters/octave {
    inherit fetchurl stdenv readline ncurses g77 perl flex;
  };

  perl = if stdenv.system != "i686-linux" then sysPerl else realPerl;

  # FIXME: unixODBC needs patching on Darwin (see darwinports)
  php = import ../development/interpreters/php {
    inherit stdenv fetchurl flex bison libxml2 apacheHttpd;
    unixODBC =
      if stdenv.isDarwin then null else unixODBC;
  };

  python = import ../development/interpreters/python {
    inherit fetchurl stdenv zlib;
  };

  realPerl = import ../development/interpreters/perl {
    inherit fetchurl stdenv;
  };

  ruby = import ../development/interpreters/ruby {
    inherit fetchurl stdenv readline ncurses;
  };

  spidermonkey = import ../development/interpreters/spidermonkey {
    inherit fetchurl;
    # remove when the "internal compiler error" in gcc 4.1.x is fixed
    stdenv = overrideGCC stdenv gcc34;
  };

  sysPerl = import ../development/interpreters/sys-perl {
    inherit stdenv;
  };

  tcl = import ../development/interpreters/tcl {
    inherit fetchurl stdenv;
  };

  xulrunner = import ../development/interpreters/xulrunner {
    inherit fetchurl stdenv pkgconfig perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  xulrunnerWrapper = {application, launcher}:
    import ../development/interpreters/xulrunner/wrapper {
      inherit stdenv xulrunner application launcher;
    };


  ### DEVELOPMENT / MISC


  /*
  toolbus = import ../development/interpreters/toolbus {
    inherit stdenv fetchurl atermjava toolbuslib aterm yacc flex;
  };
  */

  ecj = import ../development/eclipse/ecj {
    inherit fetchurl stdenv unzip jre;
    ant = apacheAntBlackdown14;
  };

  jdtsdk = import ../development/eclipse/jdt-sdk {
    inherit fetchurl stdenv unzip;
  };

  manpages = import ../development/misc/man-pages {
     inherit fetchurl stdenv;
  };

  windowssdk = import ../development/misc/windows-sdk {
    inherit fetchurl stdenv cabextract;
  };


  ### DEVELOPMENT / TOOLS


  antlr = import ../development/tools/parsing/antlr/antlr-2.7.6.nix {
    inherit fetchurl stdenv jre;
  };

  antlr3 = import ../development/tools/parsing/antlr {
    inherit fetchurl stdenv jre;
  };

  apacheAnt = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv jdk;
    name = "ant-jdk-1.5.0";
  };

  apacheAnt14 = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv;
    jdk = j2sdk14x;
    name = "ant-jdk-1.4.2";
  };

  apacheAntBlackdown14 = import ../development/tools/build-managers/apache-ant {
    inherit fetchurl stdenv;
    jdk = blackdown;
    name = "ant-blackdown-1.4.2";
  };

  autoconf = autoconf259;

  autoconf259 = import ../development/tools/misc/autoconf {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  autoconf260 = import ../development/tools/misc/autoconf-2.60 {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  automake = automake19x;

  automake17x = import ../development/tools/misc/automake/automake-1.7.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  automake19x = import ../development/tools/misc/automake/automake-1.9.x.nix {
    inherit fetchurl stdenv perl autoconf;
  };

  binutils = useFromStdenv (stdenv ? binutils) stdenv.binutils
    (import ../development/tools/misc/binutils {
      inherit fetchurl stdenv noSysDirs;
    });

  binutilsArm = import ../development/tools/misc/binutils-cross {
    inherit fetchurl stdenv noSysDirs;
    cross = "arm-linux";
  };

  binutilsMips = import ../development/tools/misc/binutils-cross {
    inherit fetchurl stdenv noSysDirs;
    cross = "mips-linux";
  };

  binutilsSparc = import ../development/tools/misc/binutils-cross {
    inherit fetchurl stdenv noSysDirs;
    cross = "sparc-linux";
  };

  bison = bison1875;

  bison1875 = import ../development/tools/parsing/bison/bison-1.875.nix {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  bison23 = import ../development/tools/parsing/bison/bison-2.3.nix {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  ctags = import ../development/tools/misc/ctags {
    inherit fetchurl stdenv;
  };

  flex = flex254a;

  #flexWrapper = import ../development/tools/parsing/flex-wrapper {
  #  inherit stdenv flex ;
  #};

  flex2533 = import ../development/tools/parsing/flex/flex-2.5.33.nix {
    inherit fetchurl stdenv yacc;
    m4 = gnum4;
  };

  flex254a = import ../development/tools/parsing/flex/flex-2.5.4a.nix {
    inherit fetchurl stdenv yacc;
  };

  gnum4 = import ../development/tools/misc/gnum4 {
    inherit fetchurl stdenv;
  };

  gnumake = useFromStdenv (stdenv ? gnumake) stdenv.gnumake
    (import ../development/tools/build-managers/gnumake {
      inherit fetchurl stdenv;
    });

  gnumake380 = import ../development/tools/build-managers/gnumake-3.80 {
    inherit fetchurl stdenv;
  };

  gperf = import ../development/tools/misc/gperf {
    inherit fetchurl stdenv;
  };

  happy = import ../development/tools/parsing/happy {
    inherit fetchurl stdenv perl ghc;
  };

  help2man = import ../development/tools/misc/help2man {
    inherit fetchurl stdenv perl gettext perlLocaleGettext;
  };

  jikespg = import ../development/tools/parsing/jikespg {
    inherit fetchurl stdenv;
  };

  kcachegrind = import ../development/tools/misc/kcachegrind {
    inherit fetchurl stdenv kdelibs zlib perl expat libpng libjpeg;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  lcov = import ../development/tools/misc/lcov {
    inherit fetchurl stdenv perl;
  };

  libtool = import ../development/tools/misc/libtool {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  mk = import ../development/tools/build-managers/mk {
    inherit fetchurl stdenv;
  };

  noweb = import ../development/tools/literate-programming/noweb {
    inherit fetchurl stdenv;
  };

  patchelf = useFromStdenv (stdenv ? patchelf) stdenv.patchelf
    (import ../development/tools/misc/patchelf {
      inherit fetchurl stdenv;
    });

  patchelfNew = import ../development/tools/misc/patchelf/new.nix {
    inherit fetchurl stdenv;
  };

  /**
   * pkgconfig is optionally taken from the stdenv to allow bootstrapping
   * of glib and pkgconfig itself on MinGW.
   */
  pkgconfig = useFromStdenv (stdenv ? pkgconfig) stdenv.pkgconfig
    (import ../development/tools/misc/pkgconfig {
      inherit fetchurl stdenv;
    });

  pkgconfig017x = import ../development/tools/misc/pkgconfig/pkgconfig-0.17.2.nix {
    inherit fetchurl stdenv;
  };

  pkgconfig_latest = import ../development/tools/misc/pkgconfig/pkgconfig-0.21.nix {
    inherit fetchurl stdenv;
  };

  scons = import ../development/tools/build-managers/scons {
    inherit fetchurl stdenv python;
  };

  sdf = import ../development/tools/parsing/sdf {
    inherit fetchurl aterm getopt pkgconfig;
    # Note: sdf2-bundle currently requires GNU make 3.80; remove
    # explicit dependency when this is fixed.
    stdenv = overrideInStdenv stdenv [gnumake380];
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

  swigWithJava = import ../development/tools/misc/swig {
    inherit fetchurl stdenv;
    jdk = blackdown;
    perlSupport = false;
    pythonSupport = false;
    javaSupport = true;
  };

  texinfo = import ../development/tools/misc/texinfo {
    inherit fetchurl stdenv ncurses;
  };

  uuagc = import ../development/tools/haskell/uuagc {
    inherit fetchurl stdenv ghc uulib;
  };

  valgrind = import ../development/tools/misc/valgrind {
    inherit fetchurl stdenv;
  };

  yacc = bison;


  ### DEVELOPMENT / LIBRARIES


  a52dec = import ../development/libraries/a52dec {
    inherit fetchurl stdenv;
  };

  aalib = import ../development/libraries/aalib {
    inherit fetchurl stdenv ncurses;
  };

  apr = import ../development/libraries/apr {
    inherit fetchurl stdenv;
  };

  aprutil = import ../development/libraries/apr-util {
    inherit fetchurl stdenv apr expat db4;
    bdbSupport = true;
  };

  arts = import ../development/libraries/kde/arts {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXext;
    inherit kdelibs zlib libjpeg libpng perl;
    qt = qt3;
    inherit (gnome) glib;
  };

  aterm = import ../development/libraries/aterm {
    inherit fetchurl stdenv;
  };

  aterm23x = import ../development/libraries/aterm/aterm-2.3.1.nix {
    inherit fetchurl stdenv;
  };

  audiofile = import ../development/libraries/audiofile {
    inherit fetchurl stdenv;
  };

  axis = import ../development/libraries/axis {
    inherit fetchurl stdenv;
  };

  beecrypt = import ../development/libraries/beecrypt {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  boehmgc = import ../development/libraries/boehm-gc {
    inherit fetchurl stdenv;
  };

  cairo = import ../development/libraries/cairo {
    inherit fetchurl stdenv pkgconfig x11 fontconfig freetype zlib libpng;
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

  clearsilver = import ../development/libraries/clearsilver {
    inherit fetchurl stdenv python;
  };

  coredumper = import ../development/libraries/coredumper {
    inherit fetchurl stdenv;
  };

  cracklib = import ../development/libraries/cracklib {
    inherit fetchurl stdenv;
  };

  db4 = db44;

  db44 = import ../development/libraries/db4/db4-4.4.nix {
    inherit fetchurl stdenv;
  };

  db45 = import ../development/libraries/db4/db4-4.5.nix {
    inherit fetchurl stdenv;
  };

  dclib = import ../development/libraries/dclib {
    inherit fetchurl stdenv libxml2 openssl bzip2;
  };

  expat = import ../development/libraries/expat {
    inherit fetchurl stdenv;
  };

  ffmpeg = import ../development/libraries/ffmpeg {
    inherit fetchurl stdenv;
  };

  fontconfig = import ../development/libraries/fontconfig {
    inherit fetchurl stdenv freetype expat;
  };

  freetype = import ../development/libraries/freetype {
    inherit fetchurl stdenv;
  };

  fribidi = import ../development/libraries/fribidi {
    inherit fetchurl stdenv;
  };

  gettext = import ../development/libraries/gettext {
    inherit fetchurl stdenv;
  };

  glibc = useFromStdenv (stdenv ? glibc) stdenv.glibc
    (import ../development/libraries/glibc {
      inherit fetchurl stdenv kernelHeaders;
      installLocales = true;
    });

  glibmm = import ../development/libraries/gtk-libs-2.6/glibmm {
    inherit fetchurl stdenv pkgconfig libsigcxx;
    inherit (gtkLibs26) glib;
  };

  gmime = import ../development/libraries/gmime {
    inherit fetchurl stdenv pkgconfig zlib;
    inherit (gtkLibs) glib;
  };

  gnet = import ../development/libraries/gnet {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib;
  };

  gnome = recurseIntoAttrs (import ../development/libraries/gnome {
    inherit fetchurl stdenv pkgconfig audiofile
            flex bison popt zlib libxml2 libxslt
            perl perlXMLParser docbook_xml_dtd_42 gettext x11
            libtiff libjpeg libpng bzip2;
    gtkLibs = gtkLibs28;
    inherit (xlibs) libXmu;
  });

  gpgme = import ../development/libraries/gpgme {
    inherit fetchurl stdenv libgpgerror gnupg;
  };

  gtkLibs = recurseIntoAttrs gtkLibs28 /* !!! -> gtkLibs10 */;

  gtkLibs1x = import ../development/libraries/gtk-libs-1.x {
    inherit fetchurl stdenv x11 libtiff libjpeg libpng;
  };

  gtkLibs210 = import ../development/libraries/gtk-libs-2.10 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo;
    inherit (xlibs) libXinerama libXrandr;
    xineramaSupport = true;
  };

  gtkLibs22 = import ../development/libraries/gtk-libs-2.2 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs24 = import ../development/libraries/gtk-libs-2.4 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs26 = import ../development/libraries/gtk-libs-2.6 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs28 = import ../development/libraries/gtk-libs-2.8 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo;
    inherit (xlibs) libXinerama;
    xineramaSupport = true;
  };

  gtkmm = import ../development/libraries/gtk-libs-2.6/gtkmm {
    inherit fetchurl stdenv pkgconfig libsigcxx;
    inherit (gtkLibs26) gtk atk;
    inherit glibmm;
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

  id3lib = import ../development/libraries/id3lib {
    inherit fetchurl stdenv;
  };

  imlib = import ../development/libraries/gnome/imlib {
    inherit fetchurl stdenv libjpeg libtiff libungif libpng;
    inherit (xlibs) libX11 libXext xextproto;
  };

  kdelibs = import ../development/libraries/kde/kdelibs {
    inherit
      fetchurl stdenv zlib perl openssl pcre pkgconfig
      libjpeg libpng libtiff libxml2 libxslt libtool
      expat freetype bzip2;
    inherit (xlibs) libX11 libXt libXext;
    qt = qt3;
  };

  lcms = import ../development/libraries/lcms {
    inherit fetchurl stdenv;
  };

  lesstif = import ../development/libraries/lesstif {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp libXau;
  };

  libcaca = import ../development/libraries/libcaca {
    inherit fetchurl stdenv ncurses;
  };

  libcdaudio = import ../development/libraries/libcdaudio {
    inherit fetchurl stdenv;
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
    inherit fetchurl stdenv;
  };

  libgpgerror = import ../development/libraries/libgpg-error {
    inherit fetchurl stdenv;
  };

  libgphoto2 = import ../development/libraries/libgphoto2 {
    inherit fetchurl stdenv pkgconfig libusb;
  };

  libgsf = import ../development/libraries/libgsf {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig libxml2;
    inherit (gnome) glib;
  };

  libjpeg = import ../development/libraries/libjpeg {
    inherit fetchurl stdenv libtool;
  };

  libmad = import ../development/libraries/libmad {
    inherit fetchurl stdenv;
  };

  libmpcdec = import ../development/libraries/libmpcdec {
    inherit fetchurl stdenv;
  };

  libmspack = import ../development/libraries/libmspack {
    inherit fetchurl stdenv;
  };

  libogg = import ../development/libraries/libogg {
    inherit fetchurl stdenv;
  };

  libpcap = import ../development/libraries/libpcap {
    inherit fetchurl stdenv flex bison;
  };

  libpng = import ../development/libraries/libpng {
    inherit fetchurl stdenv zlib;
  };

  libsigcxx = import ../development/libraries/libsigcxx {
    inherit fetchurl stdenv pkgconfig;
  };

  libsigsegv = import ../development/libraries/libsigsegv {
    inherit fetchurl stdenv;
  };

  libsndfile = import ../development/libraries/libsndfile {
    inherit fetchurl stdenv;
  };

  libtheora = import ../development/libraries/libtheora {
    inherit fetchurl stdenv libogg libvorbis;
  };

  libtiff = import ../development/libraries/libtiff {
    inherit fetchurl stdenv zlib libjpeg;
  };

  libungif = import ../development/libraries/libungif {
    inherit fetchurl stdenv;
  };

  libusb = import ../development/libraries/libusb {
    inherit fetchurl stdenv;
  };

  libvorbis = import ../development/libraries/libvorbis {
    inherit fetchurl stdenv libogg;
  };

  libwpd = import ../development/libraries/libwpd {
    inherit fetchurl stdenv pkgconfig libgsf libxml2;
    inherit (gnome) glib;
  };

  libxml2 = import ../development/libraries/libxml2 {
    inherit fetchurl stdenv zlib python;
#    pythonSupport = stdenv.system == "i686-linux";
    pythonSupport = false;
  };

  libxslt = import ../development/libraries/libxslt {
    inherit fetchurl stdenv libxml2;
  };

  mesa = import ../development/libraries/mesa {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXmu libXi;
  };

  mpeg2dec = import ../development/libraries/mpeg2dec {
    inherit fetchurl stdenv;
  };

  mysqlConnectorODBC = import ../development/libraries/mysql-connector-odbc {
    inherit fetchurl stdenv mysql libtool zlib unixODBC;
  };

  ncurses = import ../development/libraries/ncurses {
    inherit fetchurl stdenv;
  };

  ncursesDiet = import ../development/libraries/ncurses-diet {
    inherit fetchurl;
    stdenv = useDietLibC stdenv;
  };

  neon = import ../development/libraries/neon {
    inherit fetchurl stdenv libxml2 zlib openssl;
    compressionSupport = true;
    sslSupport = true;
  };

  nss = import ../development/libraries/nss {
    inherit fetchurl stdenv perl zip;
  };

  openal = import ../development/libraries/openal {
    inherit fetchurl stdenv alsaLib autoconf automake libtool;
  };

  openssl = import ../development/libraries/openssl {
    inherit fetchurl stdenv perl;
  };

  pangoxsl = import ../development/libraries/pangoxsl {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib pango;
  };

  pcre = import ../development/libraries/pcre {
    inherit fetchurl stdenv;
  };

  popt = import ../development/libraries/popt {
    inherit fetchurl stdenv gettext;
  };

  popt110 = import ../development/libraries/popt/popt-1.10.6.nix {
    inherit fetchurl stdenv gettext libtool autoconf automake;
  };

  qt3 = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql mesa;
    inherit (xlibs) libXft libXrender libXrandr randrproto
      libXmu libXinerama xineramaproto;
    openglSupport = true;
  };

  qt3NoMySQL = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql;
    inherit (xlibs) libXft libXrender;
    mysqlSupport = false;
  };

  readline = readline5;

  readline4 = import ../development/libraries/readline/readline4.nix {
    inherit fetchurl stdenv ncurses;
  };

  readline5 = import ../development/libraries/readline/readline5.nix {
    inherit fetchurl stdenv ncurses;
  };

  rte = import ../development/libraries/rte {
    inherit fetchurl stdenv;
  };

  SDL = import ../development/libraries/SDL {
    inherit fetchurl stdenv x11 mesa alsaLib;
    inherit (xlibs) libXrandr;
    openglSupport = true;
    alsaSupport = true;
  };

  SDL_mixer = import ../development/libraries/SDL_mixer {
    inherit fetchurl stdenv SDL libogg libvorbis;
  };

  slang = import ../development/libraries/slang {
    inherit fetchurl stdenv pcre libpng;
  };

  speex = import ../development/libraries/speex {
    inherit fetchurl stdenv;
  };

  sqlite = import ../development/libraries/sqlite {
    inherit fetchurl stdenv;
  };

  t1lib = import ../development/libraries/t1lib {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXaw;
  };

  taglib = import ../development/libraries/taglib {
    inherit fetchurl stdenv zlib;
  };

  tk = import ../development/libraries/tk {
    inherit fetchurl stdenv tcl x11;
  };

  unixODBC = import ../development/libraries/unixODBC {
    inherit fetchurl stdenv;
  };

  wxGTK = wxGTK26;

  wxGTK24 = import ../development/libraries/wxGTK {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs22) gtk;
  };

  wxGTK25 = import ../development/libraries/wxGTK-2.5 {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama;
  };

  wxGTK26 = import ../development/libraries/wxGTK-2.6 {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama;
  };

  Xaw3d = import ../development/libraries/Xaw3d {
    inherit fetchurl stdenv x11 bison;
    flex = flex2533;
    inherit (xlibs) imake gccmakedep libXmu libXpm libXp;
  };

  xineLib = import ../development/libraries/xine-lib {
    inherit fetchurl stdenv zlib x11 libdvdcss alsaLib;
    inherit (xlibs) libXv libXinerama;
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
    inherit fetchurl stdenv;
  };

  zlibStatic = import ../development/libraries/zlib {
    inherit fetchurl stdenv;
    static = true;
  };

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
    inherit fetchurl stdenv unzip;
  };

  sharedobjects = import ../development/libraries/java/shared-objects {
    inherit fetchurl jdk;
    stdenv = overrideInStdenv stdenv [gnumake380];
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


  uulib = import ../development/libraries/haskell/uulib {
    inherit stdenv fetchurl ghc;
  };


  ### DEVELOPMENT / PERL MODULES


  perlArchiveZip = import ../development/perl-modules/Archive-Zip {
    inherit fetchurl perl;
  };

  perlBerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit fetchurl perl db4;
  };

  perlCGISession = import ../development/perl-modules/generic perl {
    name = "CGI-Session-3.95";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/CGI-Session-3.95.tar.gz;
      md5 = "fe9e46496c7c711c54ca13209ded500b";
    };
  };

  perlCompressZlib = import ../development/perl-modules/Compress-Zlib {
    inherit fetchurl perl;
  };

  perlDateManip = import ../development/perl-modules/generic perl {
    name = "DateManip-5.42a";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/DateManip-5.42a.tar.gz;
      md5 = "648386bbf46d021ae283811f75b07bdf";
    };
  };

  perlDigestSHA1 = import ../development/perl-modules/generic perl {
    name = "Digest-SHA1-2.11";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/Digest-SHA1-2.11.tar.gz;
      md5 = "2449bfe21d6589c96eebf94dae24df6b";
    };
  };

  perlHTMLParser = import ../development/perl-modules/generic perl {
    name = "HTML-Parser-3.45";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/HTML-Parser-3.45.tar.gz;
      md5 = "c2ac1379ac5848dd32e24347cd679391";
    };
  };

  perlHTMLTagset = import ../development/perl-modules/generic perl {
    name = "HTML-Tagset-3.04";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/HTML-Tagset-3.04.tar.gz;
      md5 = "b82e0f08c1ececefe98b891f30dd56a6";
    };
  };

  perlHTMLTree = import ../development/perl-modules/generic perl {
    name = "HTML-Tree-3.18";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/HTML-Tree-3.18.tar.gz;
      md5 = "6a9e4e565648c9772e7d8ec6d4392497";
    };
  };

  perlLocaleGettext = import ../development/perl-modules/generic perl {
    name = "LocaleGettext-1.04";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gettext-1.04.tar.gz;
      md5 = "578dd0c76f8673943be043435b0fbde4";
    };
  };

  perlLWP = import ../development/perl-modules/generic perl {
    name = "libwww-perl-5.803";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libwww-perl-5.803.tar.gz;
      md5 = "3345d5f15a4f42350847254141725c8f";
    };
    propagatedBuildInputs = [perlURI perlHTMLParser];
  };

  perlTermReadKey = import ../development/perl-modules/generic perl {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  perlURI = import ../development/perl-modules/generic perl {
    name = "URI-1.35";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/URI-1.35.tar.gz;
      md5 = "1a933b1114c41a25587ee59ba8376f7c";
    };
  };

  perlXMLLibXML = import ../development/perl-modules/generic perl {
    name = "XML-LibXML-1.58";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-LibXML-1.58.tar.gz;
      md5 = "4691fc436e5c0f22787f5b4a54fc56b0";
    };
    buildInputs = [libxml2];
    propagatedBuildInputs = [perlXMLLibXMLCommon perlXMLSAX];
  };

  perlXMLLibXMLCommon = import ../development/perl-modules/generic perl {
    name = "XML-LibXML-Common-0.13";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-LibXML-Common-0.13.tar.gz;
      md5 = "13b6d93f53375d15fd11922216249659";
    };
    buildInputs = [libxml2];
  };

  perlXMLNamespaceSupport = import ../development/perl-modules/generic perl {
    name = "XML-NamespaceSupport-1.08";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-NamespaceSupport-1.08.tar.gz;
      md5 = "81bd5ae772906d0579c10061ed735dc8";
    };
    buildInputs = [];
  };

  perlXMLParser = import ../development/perl-modules/XML-Parser {
    inherit fetchurl perl expat;
  };

  perlXMLSAX = import ../development/perl-modules/generic perl {
    name = "XML-SAX-0.12";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-SAX-0.12.tar.gz;
      md5 = "bff58bd077a9693fc8cf32e2b95f571f";
    };
    propagatedBuildInputs = [perlXMLNamespaceSupport];
  };

  perlXMLSimple = import ../development/perl-modules/generic perl {
    name = "XML-Simple-2.14";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-Simple-2.14.tar.gz;
      md5 = "f321058271815de28d214c8efb9091f9";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLTwig = import ../development/perl-modules/generic perl {
    name = "XML-Twig-3.15";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-Twig-3.15.tar.gz;
      md5 = "b26886b8bd19761fff37b23e4964b499";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLWriter = import ../development/perl-modules/generic perl {
    name = "XML-Writer-0.520";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-Writer-0.520.tar.gz;
      md5 = "0a194acc70c906c0be32f4b2b7a9f689";
    };
  };


  ### DEVELOPMENT / PYTHON MODULES


  pygtk = import ../development/python-modules/pygtk {
    inherit fetchurl stdenv python pkgconfig;
    inherit (gtkLibs) glib gtk;
  };

  wxPython = import ../development/python-modules/wxPython-2.5 {
    inherit fetchurl stdenv pkgconfig wxGTK python;
  };

  wxPython24 = import ../development/python-modules/wxPython {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK24;
  };


  ### SERVERS


  apacheHttpd = import ../servers/http/apache-httpd {
    inherit fetchurl stdenv perl openssl db4 expat zlib;
    sslSupport = true;
    db4Support = true;
  };

  dovecot = import ../servers/mail/dovecot {
    inherit fetchurl stdenv ;
  };

  jetty = import ../servers/http/jetty {
    inherit fetchurl stdenv unzip;
  };

  mod_python = import ../servers/http/apache-modules/mod_python {
    inherit fetchurl stdenv apacheHttpd python;
  };

  mysql = import ../servers/sql/mysql {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  mysql_jdbc = import ../servers/sql/mysql/jdbc {
    inherit fetchurl stdenv;
    ant = apacheAntBlackdown14;
  };

  postgresql = import ../servers/sql/postgresql {
    inherit fetchurl stdenv readline ncurses zlib;
  };

  postgresql_jdbc = import ../servers/sql/postgresql/jdbc {
    inherit fetchurl stdenv;
    ant = apacheAntBlackdown14;
  };

  tomcat5 = import ../servers/http/tomcat {
    inherit fetchurl stdenv ;
    jdk = blackdown;
  };

  vsftpd = import ../servers/ftp/vsftpd {
    inherit fetchurl stdenv openssl ;
  };

  xorg = recurseIntoAttrs (import ../servers/x11/xorg {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      expat libdrm libpng zlib perl mesa;
  });


  ### OS-SPECIFIC


  #nfsUtils = import ../os-specific/linux/nfs-utils {
  #  inherit fetchurl stdenv;
  #};

  alsaLib = import ../os-specific/linux/alsa/library {
    inherit fetchurl stdenv;
  };

  alsaUtils = import ../os-specific/linux/alsa/utils {
    inherit fetchurl stdenv alsaLib ncurses gettext;
  };

  #uclibcSparc = import ../development/uclibc {
  #  inherit fetchurl stdenv mktemp;
  #  kernelHeadersCross = kernelHeadersSparc;
  #  binutilsCross = binutilsSparc;
  #  gccCross = gcc40sparc;
  #  cross = "sparc-linux";
  #};

  dietlibc = import ../os-specific/linux/dietlibc {
    inherit fetchurl glibc;
    # Dietlibc 0.30 doesn't compile on PPC with GCC 4.1, bus GCC 3.4 works.
   stdenv = if stdenv.system == "powerpc-linux" then overrideGCC stdenv gcc34 else stdenv;
  };

  #dietlibcArm = import ../os-specific/linux/dietlibc-cross {
  #  inherit fetchurl stdenv;
  #  gccCross = gcc40arm;
  #  binutilsCross = binutilsArm;
  #  arch = "arm";
  #};

  e2fsprogs = import ../os-specific/linux/e2fsprogs {
    inherit fetchurl stdenv gettext;
  };

  e2fsprogsDiet = import ../os-specific/linux/e2fsprogs-diet {
    inherit fetchurl gettext;
    stdenv = useDietLibC stdenv;
  };

  eject = import ../os-specific/linux/eject {
    inherit fetchurl stdenv gettext;
  };

  fuse = import ../os-specific/linux/fuse {
    inherit fetchurl stdenv;
  };

  hotplug = import ../os-specific/linux/hotplug {
    inherit fetchurl stdenv bash gnused coreutils utillinux gnugrep module_init_tools;
  };

  hwdata = import ../os-specific/linux/hwdata {
    inherit fetchurl stdenv;
  };

  initscripts = import ../os-specific/linux/initscripts {
    inherit fetchurl stdenv popt pkgconfig;
    inherit (gtkLibs) glib;
  };

  iputils = import ../os-specific/linux/iputils {
    inherit fetchurl stdenv kernelHeaders;
    glibc = stdenv.gcc.libc;
  };

  kernel = import ../os-specific/linux/kernel {
    inherit fetchurl perl mktemp;
    stdenv = overrideGCC stdenv gcc34;
  };

  kernelHeaders = import ../os-specific/linux/kernel-headers {
    inherit fetchurl stdenv;
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

  kernelscripts = import ../os-specific/linux/kernelscripts {
    inherit stdenv module_init_tools kernel;
    modules = [ov511];
  };

  kernel_2_6_17 = import ../os-specific/linux/kernel/linux-2.6.17.nix {
    inherit fetchurl stdenv perl mktemp;
  };

  libselinux = import ../os-specific/linux/libselinux {
    inherit fetchurl stdenv libsepol;
  };

  libsepol = import ../os-specific/linux/libsepol {
    inherit fetchurl stdenv;
  };

  MAKEDEV = import ../os-specific/linux/MAKEDEV {
    inherit fetchurl stdenv;
  };

  MAKEDEVwrapper = import ../os-specific/linux/MAKEDEV-wrapper {
    inherit stdenv MAKEDEV;
  };

  #klibc = import ../os-specific/linux/klibc {
  #  inherit fetchurl stdenv kernel perl bison flexWrapper;
  #};

  mingetty = import ../os-specific/linux/mingetty {
    inherit fetchurl stdenv;
  };

  mingettyWrapper = import ../os-specific/linux/mingetty-wrapper {
    inherit stdenv mingetty shadowutils;
  };

  mkinitrd = import ../os-specific/linux/mkinitrd {
    inherit fetchurl stdenv;
    popt = popt110;
  };

  module_init_tools = import ../os-specific/linux/module-init-tools {
    inherit fetchurl stdenv;
  };

  module_init_toolsStatic = import ../os-specific/linux/module-init-tools-static {
    inherit fetchurl stdenv;
  };

  modutils = import ../os-specific/linux/modutils {
    inherit fetchurl stdenv bison flex;
  };

  nettools = import ../os-specific/linux/net-tools {
    inherit fetchurl stdenv;
  };

  ov511 = import ../os-specific/linux/ov511 {
    inherit fetchurl kernel;
    stdenv = overrideGCC stdenv gcc34;
  };

  pam = import ../os-specific/linux/pam {
    inherit stdenv fetchurl cracklib;
  };

  procps = import ../os-specific/linux/procps {
    inherit fetchurl stdenv ncurses;
  };

  shadowutils = import ../os-specific/linux/shadow {
    inherit fetchurl stdenv;
  };

  squashfsTools = import ../os-specific/linux/squashfs {
    inherit fetchurl stdenv zlib;
  };

  sysklogd = import ../os-specific/linux/sysklogd {
    inherit fetchurl stdenv;
  };

  syslinux = import ../os-specific/linux/syslinux {
    inherit fetchurl stdenv nasm perl;
  };

  sysvinit = import ../os-specific/linux/sysvinit {
    inherit fetchurl stdenv;
  };

  uclibcArm = import ../development/uclibc {
    inherit fetchurl stdenv mktemp;
    kernelHeadersCross = kernelHeadersArm;
    binutilsCross = binutilsArm;
    gccCross = gcc40arm;
    cross = "arm-linux";
  };

  uclibcMips = import ../development/uclibc {
    inherit fetchurl stdenv mktemp;
    kernelHeadersCross = kernelHeadersMips;
    binutilsCross = binutilsMips;
    gccCross = gcc40mipsboot;
    cross = "mips-linux";
  };

  udev = import ../os-specific/linux/udev {
    inherit fetchurl stdenv;
  };

  usbutils = import ../os-specific/linux/usbutils {
    inherit fetchurl stdenv libusb;
  };

  utillinux = import ../os-specific/linux/util-linux {
    inherit fetchurl stdenv;
  };

  utillinuxStatic = import ../os-specific/linux/util-linux-static {
    inherit fetchurl stdenv;
  };

  xorg_sys_opengl = import ../os-specific/linux/opengl/xorg-sys {
    inherit stdenv xlibs expat;
  };


  ### DATA


  docbook5 = import ../data/sgml+xml/schemas/docbook-5.0 {
    inherit fetchurl stdenv;
  };

  docbook_xml_dtd_42 = import ../data/sgml+xml/schemas/xml-dtd/docbook-4.2 {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_43 = import ../data/sgml+xml/schemas/xml-dtd/docbook-4.3 {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_ebnf_dtd = import ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = import ../data/sgml+xml/stylesheets/xslt/docbook {
    inherit fetchurl stdenv;
  };


  ### APPLICATIONS


  abiword = import ../applications/office/abiword {
    inherit fetchurl stdenv pkgconfig fribidi libpng popt;
    inherit (gtkLibs) glib gtk pango;
    inherit (gnome) libglade libgnomeprint libgnomeprintui libgnomecanvas;
  };

  acroread = import ../applications/misc/acrobat-reader {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXt libXp libXext libX11 libXinerama;
    inherit (gtkLibs) glib pango atk gtk;
    libstdcpp5 = gcc33.gcc;
    xineramaSupport = true;
    fastStart = true;
  };

  amsn = import ../applications/networking/instant-messengers/amsn {
    inherit fetchurl stdenv which tcl tk x11;
  };

  batik = import ../applications/graphics/batik {
    inherit fetchurl stdenv unzip;
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

  cua = import ../applications/editors/emacs/modes/cua {
    inherit fetchurl stdenv;
  };

  #rpm = import ../applications/package-management/rpm {
  #  inherit fetchurl stdenv python tcl readline file cpio beecrypt unzip neon gnupg libxml2 perl;
  #};

  cvs = import ../applications/version-management/cvs {
    inherit fetchurl stdenv vim;
  };

  darcs = import ../applications/version-management/darcs {
    inherit fetchurl stdenv ghc zlib ncurses curl;
  };

  eclipse = plugins :
    import ../applications/editors/eclipse {
      inherit fetchurl stdenv makeWrapper jdk;
      inherit (gtkLibs) gtk glib;
      inherit (xlibs) libXtst;
      inherit plugins;
    };

  eclipseSpoofax =
    eclipse [spoofax];

  emacs = import ../applications/editors/emacs {
    inherit fetchurl stdenv x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    xaw3dSupport = true;
  };

  emacs22 = import ../applications/editors/emacs-22 {
    inherit fetchurl stdenv pkgconfig x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    inherit (gtkLibs) gtk;
    xaw3dSupport = false;
    gtkGUI = true;
  };

  emacs22aa = import ../applications/editors/emacs-22-aa {
    inherit fetchurl stdenv pkgconfig x11 Xaw3d libpng;
    inherit (xlibs) libXaw libXpm libXft;
    inherit (gtkLibs) gtk;
    xaw3dSupport = false;
    gtkGUI = true;
    xftSupport = true;
  };

  ethereal = import ../applications/networking/sniffers/ethereal {
    inherit fetchurl stdenv perl pkgconfig libpcap;
    inherit (gtkLibs) glib;
  };

  firefox = import ../applications/networking/browsers/firefox {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  };

  firefoxWrapper = wrapFirefox firefox;

  flac = import ../applications/audio/flac {
    inherit fetchurl stdenv libogg;
  };

  flashplayer = import ../applications/networking/browsers/mozilla-plugins/flashplayer {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXmu;
  };

  fspot = import ../applications/graphics/f-spot {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig mono
            libexif libjpeg sqlite lcms libgphoto2 monoDLLFixer;
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  gaim = import ../applications/networking/instant-messengers/gaim {
    inherit fetchurl stdenv pkgconfig perl libxml2 openssl nss;
    inherit (gtkLibs) glib gtk;
  };

  gimp = import ../applications/graphics/gimp {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      libtiff libjpeg libpng libexif zlib perl perlXMLParser python pygtk gettext;
    inherit (gnome) gtk libgtkhtml glib pango atk libart_lgpl;
  };

  gnash = import ../applications/video/gnash {
    inherit fetchurl stdenv SDL SDL_mixer GStreamer
            libogg libxml2 libjpeg mesa libpng;
    inherit (xlibs) libX11 libXext libXi libXmu;
  };

  gphoto2 = import ../applications/misc/gphoto2 {
    inherit fetchurl stdenv pkgconfig libgphoto2 libexif popt;
  };

  gqview = import ../applications/graphics/gqview {
    inherit fetchurl stdenv pkgconfig libpng;
    inherit (gtkLibs) gtk;
  };

  GStreamer = import ../applications/audio/GStreamer {
    inherit fetchurl stdenv perl bison flex pkgconfig libxml2;
    inherit (gtkLibs) glib;
  };

  haskellMode = import ../applications/editors/emacs/modes/haskell {
    inherit fetchurl stdenv;
  };

  hello = import ../applications/misc/hello/ex-1 {
    inherit fetchurl stdenv perl;
  };

  inkscape = import ../applications/graphics/inkscape {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig zlib
      popt libxml2 libxslt libpng boehmgc fontconfig gtkmm
      glibmm libsigcxx;
    inherit (gtkLibs) gtk glib;
    inherit (xlibs) libXft;
  };

  kuickshow = import ../applications/graphics/kuickshow {
    inherit fetchurl stdenv kdelibs arts libpng libjpeg libtiff libungif imlib expat perl;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  lame = import ../applications/audio/lame {
    inherit fetchurl stdenv ;
  };

  links = import ../applications/networking/browsers/links {
    inherit fetchurl stdenv;
  };

  lynx = import ../applications/networking/browsers/lynx {
    inherit fetchurl stdenv ncurses openssl;
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

  MPlayer = import ../applications/video/MPlayer {
    inherit fetchurl stdenv freetype x11 zlib libtheora libcaca;
    inherit (xlibs) libXv libXinerama libXrandr;
    alsaSupport = true;
    alsa = alsaLib;
    theoraSupport = true;
    cacaSupport = true;
    xineramaSupport = true;
    randrSupport = true;
  };

  MPlayerPlugin = import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in {
    inherit fetchurl stdenv pkgconfig firefox;
    inherit (xlibs) libXpm;
    # !!! should depend on MPlayer
  };

  mythtv = import ../applications/video/mythtv {
    inherit fetchurl stdenv which qt3 x11 lame zlib mesa;
    inherit (xlibs) libX11 libXinerama libXv libXxf86vm libXrandr libXmu;
  };

  nano = import ../applications/editors/nano {
    inherit fetchurl stdenv ncurses gettext;
  };

  nanoDiet = import ../applications/editors/nano {
    inherit fetchurl gettext;
    ncurses = ncursesDiet;
    stdenv = useDietLibC stdenv;
  };

  nedit = import ../applications/editors/nedit {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXpm;
    motif = lesstif;
  };

  nxml = import ../applications/editors/emacs/modes/nxml {
    inherit fetchurl stdenv;
  };

  openoffice = import ../applications/office/openoffice {
    inherit fetchurl stdenv pam python tcsh libxslt
      perl perlArchiveZip perlCompressZlib zlib libjpeg
      expat pkgconfig freetype fontconfig libwpd libxml2
      db4 sablotron curl libsndfile flex zip unzip libmspack
      getopt file neon;
    inherit (xlibs) libXaw;
    inherit (gtkLibs) gtk;

    bison = bison23;
  };

  opera = import ../applications/networking/browsers/opera {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libX11 libSM libICE libXt libXext;
    qt = qt3;
    #motif = lesstif;
    libstdcpp5 = gcc33.gcc;
  };

  pan = import ../applications/networking/newsreaders/pan {
    inherit fetchurl stdenv pkgconfig gnet perl
            pcre gmime gettext;
    inherit (gtkLibs) gtk;
    spellChecking = false;
  };

  pinfo = import ../applications/misc/pinfo {
    inherit fetchurl stdenv ncurses;
  };

  rcs = import ../applications/version-management/rcs {
    inherit fetchurl stdenv;
  };

  RealPlayer = import ../applications/video/RealPlayer {
    inherit fetchurl stdenv;
    inherit (gtkLibs) glib pango atk gtk;
    inherit (xlibs) libX11;
    libstdcpp5 = gcc33.gcc;
  };

  rsync = import ../applications/networking/sync/rsync {
    inherit fetchurl stdenv;
  };

  spoofax = import ../applications/editors/eclipse/plugins/spoofax {
    inherit fetchurl stdenv;
  };

  subversion = subversion14;

  subversion13 = import ../applications/version-management/subversion-1.3.x {
    inherit fetchurl stdenv openssl db4 expat swig zlib;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    compressionSupport = true;
    httpd = apacheHttpd;
  };

  subversion14 = import ../applications/version-management/subversion-1.4.x {
    inherit fetchurl stdenv apr aprutil neon expat swig zlib;
    bdbSupport = true;
    httpServer = false;
    sslSupport = true;
    compressionSupport = true;
    httpd = apacheHttpd;
  };

  subversionWithJava = import ../applications/version-management/subversion-1.2.x {
    inherit fetchurl stdenv openssl db4 expat jdk;
    swig = swigWithJava;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    httpd = apacheHttpd;
    javahlBindings = true;
  };

  sylpheed = import ../applications/networking/mailreaders/sylpheed {
    inherit fetchurl stdenv pkgconfig openssl gpgme;
    inherit (gtkLibs) glib gtk;
    sslSupport = true;
    gpgSupport = true;
  };

  thunderbird = import ../applications/networking/mailreaders/thunderbird {
    inherit fetchurl stdenv pkgconfig perl zip libjpeg libpng zlib cairo;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
    #enableOfficialBranding = true;
  };

  valknut = import ../applications/networking/p2p/valknut {
    inherit fetchurl stdenv perl x11 libxml2 libjpeg libpng openssl dclib;
    qt = qt3;
  };

  vim = import ../applications/editors/vim {
    inherit fetchurl stdenv ncurses;
  };

  vimDiet = import ../applications/editors/vim-diet {
    inherit fetchurl;
    ncurses = ncursesDiet;
    stdenv = useDietLibC stdenv;
  };

  vlc = import ../applications/video/vlc {
    inherit fetchurl stdenv perl x11 wxGTK
            zlib mpeg2dec a52dec libmad ffmpeg
            libdvdread libdvdnav libdvdcss;
    inherit (xlibs) libXv;
    alsa = alsaLib;
  };

  w3m = import ../applications/networking/browsers/w3m {
    inherit fetchurl stdenv ncurses openssl boehmgc gettext zlib;
    graphicsSupport = false;
    inherit (gtkLibs1x) gdkpixbuf;
  };

  wrapFirefox = firefox: import ../applications/networking/browsers/firefox-wrapper {
    inherit stdenv firefox;
    plugins = [
      MPlayerPlugin
      flashplayer
    ]
    # RealPlayer is disabled by default for legal reasons.
    ++ (if getConfig ["firefox" "enableRealPlayer"] false then [RealPlayer] else [])
    ++ (if blackdown != null then [blackdown] else []);
  };

  xara = import ../applications/graphics/xara {
    inherit fetchurl stdenv autoconf automake libtool gettext cvs wxGTK
      pkgconfig libxml2 zip libpng libjpeg;
    inherit (gtkLibs) gtk;
  };

  xawtv = import ../applications/video/xawtv {
    inherit fetchurl stdenv ncurses libjpeg perl;
    inherit (xlibs) libX11 libXt libXft xproto libFS fontsproto libXaw libXpm libXext libSM libICE xextproto;
  };

  xchat = import ../applications/networking/irc/xchat {
    inherit fetchurl stdenv pkgconfig tcl;
    inherit (gtkLibs) glib gtk;
  };

  xchm = import ../applications/misc/xchm {
    inherit fetchurl stdenv wxGTK chmlib;
  };

  xineUI = import ../applications/video/xine-ui {
    inherit fetchurl stdenv x11 xineLib libpng;
  };

  xmms = import ../applications/audio/xmms {
    inherit fetchurl libogg libvorbis alsaLib;
    inherit (gnome) esound;
    inherit (gtkLibs1x) glib gtk;
    stdenv = overrideGCC stdenv gcc34; # due to problems with gcc 4.x
  };

  xpdf = import ../applications/misc/xpdf {
    inherit fetchurl stdenv x11 freetype t1lib;
    motif = lesstif;
  };

  xterm = import ../applications/misc/xterm {
    inherit fetchurl stdenv ncurses;
    inherit (xlibs) libXaw xproto libXt libX11 libSM libICE;
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


  exult = import ../games/exult {
    inherit fetchurl SDL SDL_mixer zlib libpng unzip;
    stdenv = overrideGCC stdenv gcc34;
  };

  quake3demo = import ../games/quake3/wrapper {
    name = "quake3-demo";
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    inherit fetchurl stdenv mesa;
    game = quake3game;
    paks = [quake3demodata];
  };

  quake3demodata = import ../games/quake3/demo {
    inherit fetchurl stdenv;
  };

  quake3game = import ../games/quake3/game {
    inherit fetchurl stdenv x11 SDL mesa openal;
  };

  scummvm = import ../games/scummvm {
    inherit fetchurl stdenv SDL;
  };

  ut2004demo = import ../games/ut2004demo {
    inherit fetchurl stdenv xlibs mesa;
  };

  zoom = import ../games/zoom {
    inherit fetchurl stdenv perl expat freetype;
    inherit (xlibs) xlibs;
  };


  ### MISC


  aangifte2005 = import ../evil/belastingdienst {
    inherit stdenv fetchurl;
    inherit (xlibs) libX11 libXext;
    patchelf = patchelfNew;
  };

  atari800 = import ../misc/emulators/atari800 {
    inherit fetchurl stdenv unzip zlib SDL;
  };

  ataripp = import ../misc/emulators/atari++ {
    inherit fetchurl stdenv x11 SDL;
  };

  busybox = import ../misc/busybox {
    inherit fetchurl stdenv;
  };

  cups = import ../misc/cups {
    inherit fetchurl stdenv;
  };

  dosbox = import ../misc/emulators/dosbox {
    inherit fetchurl stdenv SDL;
  };

  generator = import ../misc/emulators/generator {
    inherit fetchurl stdenv SDL nasm;
    inherit (gtkLibs1x) gtk;
  };

  ghostscript = import ../misc/ghostscript {
    inherit fetchurl stdenv libjpeg libpng zlib x11;
    x11Support = false;
  };

  joe = import ../applications/editors/joe {
    inherit stdenv fetchurl;
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

  nix = import ../misc/nix {
    inherit fetchurl stdenv aterm perl curl bzip2;
    db4 = db44;
  };

  nixStatic = import ../misc/nix-static {
    inherit fetchurl stdenv aterm perl curl autoconf automake libtool;
    bdb = db4;
  };

  nixUnstable = nix;

  polytable = import ../misc/tex/polytable {
    inherit fetchurl stdenv tetex lazylist;
  };

  rssglx = import ../misc/screensavers/rss-glx {
    inherit fetchurl stdenv x11 mesa;
  };

  saneBackends = import ../misc/sane-backends {
    inherit fetchurl stdenv;
  };

  tetex = import ../misc/tex/tetex {
    inherit fetchurl stdenv flex bison zlib libpng ncurses ed;
  };

  texFunctions = import ../misc/tex/nix {
    inherit stdenv perl tetex graphviz ghostscript;
  };

  toolbuslib = import ../development/libraries/toolbuslib {
    inherit stdenv fetchurl aterm;
  };

  trac = import ../misc/trac {
    inherit stdenv fetchurl python clearsilver makeWrapper sqlite;

    subversion = import ../applications/version-management/subversion-1.3.x {
      inherit fetchurl stdenv openssl db4 expat jdk swig zlib;
      localServer = true;
      httpServer = false;
      sslSupport = true;
      compressionSupport = true;
      httpd = apacheHttpd;
      pythonBindings = true; # Enable python bindings
    };

    pysqlite = import ../development/libraries/pysqlite {
      inherit stdenv fetchurl python substituter sqlite;
    };
  };

  uml = import ../misc/uml {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
    gcc = gcc33;
  };

  umlutilities = import ../misc/uml-utilities {
    inherit fetchurl stdenv;
  };

}
