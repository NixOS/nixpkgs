# This file evaluates to a function that, when supplied with a system
# identifier and a standard build environment, returns the set of all
# packages provided by the Nix Package Collection.

{ stdenv, bootCurl, noSysDirs ? true
, gccWithCC ? true
, gccWithProfiling ? true
}:

rec {

  inherit stdenv;


  ### Symbolic names.

  useOldXLibs = true;

  # `xlibs' is the set of X library components.  This used to be the
  # old modular X libraries project (called `xlibs') but now it's just
  # the set of packages in the modular X.org tree (which also includes
  # non-library components like the server, drivers, fonts, etc.).
  xlibs = if useOldXLibs then xlibsOld else xorg;

  # `xlibs.xlibs' is a wrapper packages that combines libX11 and a bunch
  # of other basic X client libraries.
  x11 = if useOldXLibs then xlibsOld.xlibs else xlibsWrapper;
  

  ### BUILD SUPPORT

  fetchurl = (import ../build-support/fetchurl) {
    inherit stdenv;
    curl = bootCurl;
  };

  fetchsvn = (import ../build-support/fetchsvn) {
    inherit stdenv subversion nix;
  };

  substituter = ../build-support/substitute/substitute.sh;

  makeWrapper = ../build-support/make-wrapper/make-wrapper.sh;


  ### TOOLS

  bc = (import ../tools/misc/bc) {
    inherit fetchurl stdenv flex;
  };

  coreutils = (import ../tools/misc/coreutils) {
    inherit fetchurl stdenv;
  };

  coreutilsDiet = (import ../tools/misc/coreutils-diet) {
    inherit fetchurl stdenv dietgcc perl;
  };

  findutils = (import ../tools/misc/findutils) {
    inherit fetchurl stdenv coreutils;
  };

  findutilsWrapper = (import ../tools/misc/findutils-wrapper) {
    inherit stdenv findutils;
  };

  getopt = (import ../tools/misc/getopt) {
    inherit fetchurl stdenv;
  };

  grub = (import ../tools/misc/grub) {
    inherit fetchurl stdenv;
  };

  grubWrapper = (import ../tools/misc/grub-wrapper) {
     inherit stdenv grub diffutils gnused gnugrep;
  };

  man = (import ../tools/misc/man) {
     inherit fetchurl stdenv db4 groff;
  };

  parted = (import ../tools/misc/parted) {
    inherit fetchurl stdenv e2fsprogs ncurses readline;
  };

  qtparted = (import ../tools/misc/qtparted) {
    inherit fetchurl stdenv e2fsprogs ncurses readline parted zlib qt3;
    inherit (xlibs) libX11 libXext;
  };

  jdiskreport = (import ../tools/misc/jdiskreport) {
    inherit fetchurl stdenv unzip jdk;
  };

  diffutils = (import ../tools/text/diffutils) {
    inherit fetchurl stdenv coreutils;
  };

  gnupatch = (import ../tools/text/gnupatch) {
    inherit fetchurl stdenv;
  };

  patch = if stdenv.system == "powerpc-darwin" then null else gnupatch;

  gnused = (import ../tools/text/gnused) {
    inherit fetchurl stdenv;
  };

  gnugrep = (import ../tools/text/gnugrep) {
    inherit fetchurl stdenv pcre;
  };

  gawk = (import ../tools/text/gawk) {
    inherit fetchurl stdenv;
  };

  groff = (import ../tools/text/groff) {
    inherit fetchurl stdenv;
  };

  enscript = (import ../tools/text/enscript) {
    inherit fetchurl stdenv;
  };

  ed = (import ../tools/text/ed) {
    inherit fetchurl stdenv;
  };

  xpf = (import ../tools/text/xml/xpf) {
    inherit fetchurl stdenv python;

    libxml2 = (import ../development/libraries/libxml2) {
      inherit fetchurl stdenv zlib python;
      pythonSupport = true;
    };
  };

  sablotron = (import ../tools/text/xml/sablotron) {
    inherit fetchurl stdenv expat;
  };

  jing = (import ../tools/text/xml/jing) {
    inherit fetchurl stdenv unzip;
  };

  jing_tools = (import ../tools/text/xml/jing/jing-script.nix) {
    inherit fetchurl stdenv unzip;
    jre = blackdown;
  };

  cpio = (import ../tools/archivers/cpio) {
    inherit fetchurl stdenv;
  };

  gnutar = (import ../tools/archivers/gnutar) {
    inherit fetchurl stdenv;
  };

  gnutarDiet = (import ../tools/archivers/gnutar-diet) {
    inherit fetchurl stdenv dietgcc;
  };

  zip = (import ../tools/archivers/zip) {
    inherit fetchurl stdenv;
  };

  unzip = import ../tools/archivers/unzip {
    inherit fetchurl stdenv;
  };

  gzip = (import ../tools/compression/gzip) {
    inherit fetchurl stdenv;
  };

  bzip2 = (import ../tools/compression/bzip2) {
    inherit fetchurl stdenv;
  };

  zdelta = (import ../tools/compression/zdelta) {
    inherit fetchurl stdenv;
  };

  bsdiff = (import ../tools/compression/bsdiff) {
    inherit fetchurl stdenv;
  };

  which = (import ../tools/system/which) {
    inherit fetchurl stdenv;
  };

  wget = (import ../tools/networking/wget) {
    inherit fetchurl stdenv;
  };

  curl = (import ../tools/networking/curl) {
    inherit fetchurl stdenv zlib;
  };

  curlDiet = (import ../tools/networking/curl-diet) {
    inherit fetchurl stdenv zlib dietgcc;
  };

  par2cmdline = (import ../tools/networking/par2cmdline) {
    inherit fetchurl stdenv;
  };

  cksfv = (import ../tools/networking/cksfv) {
    inherit fetchurl stdenv;
  };

  bittorrent = (import ../tools/networking/bittorrent) {
    inherit fetchurl stdenv python pygtk makeWrapper;
  };

  azureus = import ../tools/networking/azureus {
    inherit fetchurl stdenv jdk swt;
  };

  dhcp = (import ../tools/networking/dhcp) {
    inherit fetchurl stdenv groff nettools coreutils iputils gnused bash;
  };

  dhcpWrapper = (import ../tools/networking/dhcp-wrapper) {
    inherit stdenv dhcp;
  };


  graphviz = (import ../tools/graphics/graphviz) {
    inherit fetchurl stdenv libpng libjpeg expat x11 yacc libtool;
    inherit (xlibs) libXaw;
  };

  gnuplot = (import ../tools/graphics/gnuplot) {
    inherit fetchurl stdenv zlib libpng texinfo;
  };

  exif = (import ../tools/graphics/exif) {
    inherit fetchurl stdenv pkgconfig libexif popt;
  };

  hevea = (import ../tools/typesetting/hevea) {
    inherit fetchurl stdenv ocaml;
  };

  xmlroff = (import ../tools/typesetting/xmlroff) {
    inherit fetchurl stdenv pkgconfig libxml2 libxslt popt;
    inherit (gtkLibs) glib pango gtk;
    inherit (gnome) libgnomeprint;
    inherit pangoxsl;
  };

  less = (import ../tools/misc/less) {
    inherit fetchurl stdenv ncurses;
  };

  file = (import ../tools/misc/file) {
    inherit fetchurl stdenv;
  };

  screen = (import ../tools/misc/screen) {
    inherit fetchurl stdenv ncurses;
  };

  xsel = (import ../tools/misc/xsel) {
    inherit fetchurl stdenv x11;
  };

  xmltv = import ../tools/misc/xmltv {
    inherit fetchurl perl perlTermReadKey perlXMLTwig perlXMLWriter
      perlDateManip perlHTMLTree perlHTMLParser perlHTMLTagset
      perlURI perlLWP;
  };

  openssh = (import ../tools/networking/openssh) {
    inherit fetchurl stdenv zlib openssl;
  };

  mktemp = (import ../tools/security/mktemp) {
    inherit fetchurl stdenv;
  };

  nmap = (import ../tools/security/nmap) {
    inherit fetchurl stdenv;
  };

  gnupg = import ../tools/security/gnupg {
    inherit fetchurl stdenv;
    ideaSupport = false; # enable for IDEA crypto support
  };

  mjpegtools = (import ../tools/video/mjpegtools) {
    inherit fetchurl stdenv libjpeg;
    inherit (xlibs) libX11;
  };

  xauth = (import ../tools/X11/xauth) {
    inherit fetchurl stdenv pkgconfig;
    inherit (xlibs) libX11 libXau libXext libXmu;
  };

   
  ### SHELLS

  bash = (import ../shells/bash) {
    inherit fetchurl stdenv;
  };

  tcsh = (import ../shells/tcsh) {
    inherit fetchurl stdenv ncurses;
  };

  bashStatic = (import ../shells/bash-static) {
    inherit fetchurl stdenv;
  };


  ### DEVELOPMENT

  binutils = (import ../development/tools/misc/binutils) {
    inherit fetchurl stdenv noSysDirs;
  };

  binutilsMips = (import ../development/tools/misc/binutils-cross) {
    inherit fetchurl stdenv noSysDirs;
    cross = "mips-linux";
  };

  binutilsArm = (import ../development/tools/misc/binutils-cross) {
    inherit fetchurl stdenv noSysDirs;
    cross = "arm-linux";
  };

  patchelf = (import ../development/tools/misc/patchelf) {
    inherit fetchurl stdenv;
  };

  gnum4 = (import ../development/tools/misc/gnum4) {
    inherit fetchurl stdenv;
  };

  autoconf = (import ../development/tools/misc/autoconf) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  automake17x = (import ../development/tools/misc/automake/automake-1.7.x.nix) {
    inherit fetchurl stdenv perl autoconf;
  };

  automake19x = (import ../development/tools/misc/automake/automake-1.9.x.nix) {
    inherit fetchurl stdenv perl autoconf;
  };

  automake = automake19x;

  libtool = (import ../development/tools/misc/libtool) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  pkgconfig = (import ../development/tools/misc/pkgconfig) {
    inherit fetchurl stdenv;
  };

  pkgconfig017x = (import ../development/tools/misc/pkgconfig/pkgconfig-0.17.2.nix) {
    inherit fetchurl stdenv;
  };

  strace = (import ../development/tools/misc/strace) {
    inherit fetchurl stdenv;
  };

  swig = (import ../development/tools/misc/swig) {
    inherit fetchurl stdenv perl python;
    perlSupport = true;
    pythonSupport = true;
    javaSupport = false;
  };
  
  swigWithJava = (import ../development/tools/misc/swig) {
    inherit fetchurl stdenv;
    jdk = blackdown;
    perlSupport = false;
    pythonSupport = false;
    javaSupport = true;
  };

  valgrind = (import ../development/tools/misc/valgrind) {
    inherit fetchurl stdenv;
  };

  callgrind = (import ../development/tools/misc/callgrind) {
    inherit fetchurl stdenv which perl;
  };

  kcachegrind = (import ../development/tools/misc/kcachegrind) {
    inherit fetchurl stdenv kdelibs zlib perl expat libpng libjpeg;
    inherit (xlibs) libX11 libXext libSM;
    qt = qt3;
  };

  texinfo = (import ../development/tools/misc/texinfo) {
    inherit fetchurl stdenv ncurses;
  };

  gperf = (import ../development/tools/misc/gperf) {
    inherit fetchurl stdenv;
  };

  ctags = (import ../development/tools/misc/ctags) {
    inherit fetchurl stdenv;
  };

  lcov = (import ../development/tools/misc/lcov) {
    inherit fetchurl stdenv perl;
  };

  help2man = (import ../development/tools/misc/help2man) {
    inherit fetchurl stdenv perl gettext perlLocaleGettext;
  };

  octave = (import ../development/interpreters/octave) {
    inherit fetchurl stdenv readline ncurses g77 perl flex;
  };

  gnumake = (import ../development/tools/build-managers/gnumake) {
    inherit fetchurl stdenv;
  };

  bison = (import ../development/tools/parsing/bison) {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  yacc = bison;

  bisonnew = (import ../development/tools/parsing/bison/bison-new.nix) {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  flex = (import ../development/tools/parsing/flex) {
    inherit fetchurl stdenv yacc;
  };

  #flexWrapper = (import ../development/tools/parsing/flex-wrapper) {
  #  inherit stdenv flex ;
  #};

  flexnew = (import ../development/tools/parsing/flex/flex-new.nix) {
    inherit fetchurl stdenv yacc;
    m4 = gnum4;
  };

  gcc = (import ../development/compilers/gcc-3.4) {
    inherit fetchurl stdenv noSysDirs;
    langCC = gccWithCC;
    profiledCompiler = gccWithProfiling;
  };

  gccWrapped = stdenv.gcc;

  gcc_static = (import ../development/compilers/gcc-static-3.4) {
    inherit fetchurl stdenv;
  };

  dietgcc = (import ../build-support/gcc-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../os-specific/linux/dietlibc-wrapper) {
      inherit stdenv dietlibc;
      gcc = stdenv.gcc;
    };
    #inherit (stdenv.gcc) binutils glibc;
    inherit (stdenv.gcc) binutils;
    glibc = dietlibc;
    inherit stdenv;
  };

  gcc33 = (import ../build-support/gcc-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../development/compilers/gcc-3.3) {
      inherit fetchurl stdenv noSysDirs;
    };
    inherit (stdenv.gcc) binutils glibc;
    inherit stdenv;
  };

  gcc40mips = (import ../build-support/gcc-cross-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    cross = "mips-linux";
    gcc = (import ../development/compilers/gcc-4.0-cross) {
      inherit fetchurl stdenv noSysDirs;
      langF77 = false;
      langCC = false;
      binutilsCross = binutilsMips;
      kernelHeadersCross = kernelHeadersMips;
      cross = "mips-linux";
    };
    inherit (stdenv.gcc) glibc;
    binutils = binutilsMips;
    inherit stdenv;
  };

  gcc40arm = (import ../build-support/gcc-cross-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    cross = "arm-linux";
    gcc = (import ../development/compilers/gcc-4.0-cross) {
      inherit fetchurl stdenv noSysDirs;
      langF77 = false;
      langCC = false;
      binutilsCross = binutilsArm;
      kernelHeadersCross = kernelHeadersArm;
      cross = "arm-linux";
    };
    inherit (stdenv.gcc) glibc;
    binutils = binutilsArm;
    inherit stdenv;
  };

  gcc40 = (import ../build-support/gcc-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../development/compilers/gcc-4.0) {
      inherit fetchurl stdenv noSysDirs;
      profiledCompiler = true;
    };
    inherit (stdenv.gcc) binutils glibc;
    inherit stdenv;
  };

  gcc295 = (import ../build-support/gcc-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../development/compilers/gcc-2.95) {
      inherit fetchurl stdenv noSysDirs;
    };
    inherit (stdenv.gcc) binutils glibc;
    inherit stdenv;
  };

  g77 = (import ../build-support/gcc-wrapper) {
    name = "g77";
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../development/compilers/gcc-3.3) {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
    };
    inherit (stdenv.gcc) binutils glibc;
    inherit stdenv;
  };

/*
  gcj = (import ../build-support/gcc-wrapper/default2.nix) {
    name = "gcj";
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../development/compilers/gcc-4.0) {
      inherit fetchurl stdenv noSysDirs;
      langJava = true;
      langCC   = false;
      langC    = false;
      langF77  = false;
    };
    inherit (stdenv.gcc) binutils glibc;
    inherit stdenv;
  };
*/

  opencxx = (import ../development/compilers/opencxx) {
    inherit fetchurl stdenv libtool;
    gcc = gcc33;
  };

  jikes = (import ../development/compilers/jikes) {
    inherit fetchurl stdenv;
  };

  ecj = (import ../development/eclipse/ecj) {
    inherit fetchurl stdenv unzip jre;
    ant = apacheAntBlackdown14;
  };

  jdtsdk = (import ../development/eclipse/jdt-sdk) {
    inherit fetchurl stdenv unzip;
  };

  blackdown = (import ../development/compilers/blackdown) {
    inherit fetchurl stdenv;
  };

  jdk = 
    if stdenv.system == "powerpc-darwin" then 
      "/System/Library/Frameworks/JavaVM.framework/Versions/1.5.0/Home"
    else
      (import ../development/compilers/jdk) {
        inherit fetchurl stdenv unzip;
        inherit (xlibs) libX11 libXext;
      };

  j2sdk14x = (import ../development/compilers/jdk/default-1.4.nix) {
    inherit fetchurl stdenv;
  };

  ocaml = (import ../development/compilers/ocaml) {
    inherit fetchurl stdenv x11;
  };

  mono = (import ../development/compilers/mono) {
    inherit fetchurl stdenv bison pkgconfig;
    inherit (gtkLibs) glib;
  };

  monoDLLFixer = import ../build-support/mono-dll-fixer {
    inherit stdenv perl;
  };

  strategoxt = (import ../development/compilers/strategoxt) {
    inherit fetchurl stdenv pkgconfig sdf aterm;
  };

  strategoxtUtils = (import ../development/compilers/strategoxt/utils) {
    inherit fetchurl pkgconfig stdenv aterm sdf strategoxt;
  };

  bibtextools = (import ../tools/typesetting/bibtex-tools) {
    inherit fetchurl stdenv aterm tetex hevea sdf strategoxt;
  };

  transformers = (import ../development/compilers/transformers) {
    inherit fetchurl stdenv pkgconfig sdf;
    aterm = aterm23x;

    strategoxt = (import ../development/compilers/strategoxt/strategoxt-0.14.nix) {
      inherit fetchurl pkgconfig stdenv sdf;
      aterm = aterm23x;
    };

    stlport =  (import ../development/libraries/stlport) {
      inherit fetchurl stdenv;
    };
  };

  aterm23x = (import ../development/libraries/aterm/aterm-2.3.1.nix) {
    inherit fetchurl stdenv;
  };

  ghcboot = (import ../development/compilers/ghc/boot.nix) {
    inherit fetchurl stdenv perl ncurses;
    readline = readline4;
  };

  ghc = (import ../development/compilers/ghc) {
    inherit fetchurl stdenv perl ncurses readline;
    ghc = ghcboot;
    m4 = gnum4;
  };

  helium = (import ../development/compilers/helium) {
    inherit fetchurl stdenv ghc;
  };

  harp = (import ../development/compilers/harp) {
    inherit fetchurl stdenv unzip ghc happy;
  };

  nasm = (import ../development/compilers/nasm) {
    inherit fetchurl stdenv;
  };

  ### DEVELOPMENT / DEBUGGERS

  #ltrace = (import ../development/debuggers/ltrace) {
  #  inherit fetchurl stdenv;
  #};

  ### DEVELOPMENT / INTERPRETERS

  happy = (import ../development/tools/parsing/happy) {
    inherit fetchurl stdenv perl ghc;
  };

  realPerl = (import ../development/interpreters/perl) {
    inherit fetchurl stdenv;
  };

  sysPerl = (import ../development/interpreters/sys-perl) {
    inherit stdenv;
  };

  perl = if stdenv.system != "i686-linux" then sysPerl else realPerl;

  python = (import ../development/interpreters/python) {
    inherit fetchurl stdenv zlib;
  };

  ruby = (import ../development/interpreters/ruby) {
    inherit fetchurl stdenv;
  };

  tcl = (import ../development/interpreters/tcl) {
    inherit fetchurl stdenv;
  };

  dylan = (import ../development/compilers/gwydion-dylan) {
    inherit fetchurl stdenv perl boehmgc yacc flex readline;
    dylan =
      (import ../development/compilers/gwydion-dylan/binary.nix) {
        inherit fetchurl stdenv;
      };
  };

  clisp = (import ../development/interpreters/clisp) {
    inherit fetchurl stdenv libsigsegv gettext;
  };

  php = (import ../development/interpreters/php) {
    inherit stdenv fetchurl flex bison libxml2 apacheHttpd;
  };

  guile = (import ../development/interpreters/guile) {
    inherit fetchurl stdenv ncurses readline;
  };

  jre = (import ../development/interpreters/jre) {
    inherit fetchurl stdenv;
  };

  kaffe =  (import ../development/interpreters/kaffe) {
    inherit fetchurl stdenv jikes alsaLib xlibs;
  };

  apacheAnt14 = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv;
    jdk = j2sdk14x;
    name = "ant-jdk-1.4.2";
  };

  apacheAntBlackdown14 = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv;
    jdk = blackdown;
    name = "ant-blackdown-1.4.2";
  };

  apacheAnt = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv jdk;
    name = "ant-jdk-1.5.0";
  };

  dovecot = (import ../servers/mail/dovecot) {
    inherit fetchurl stdenv ;
  };
  
  vsftpd = (import ../servers/ftp/vsftpd) {
    inherit fetchurl stdenv openssl ;
  };
 
  tomcat5 = (import ../servers/http/tomcat) {
    inherit fetchurl stdenv ;
    jdk = blackdown;
  };

  beecrypt = (import ../development/libraries/beecrypt) {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  cil = (import ../development/libraries/cil) {
    inherit stdenv fetchurl ocaml perl;
  };

  pcre = (import ../development/libraries/pcre) {
    inherit fetchurl stdenv;
  };

  glibc = (import ../development/libraries/glibc) {
    inherit fetchurl stdenv kernelHeaders;
    installLocales = true;
  };

  aterm = (import ../development/libraries/aterm) {
    inherit fetchurl stdenv;
  };

  sdf = (import ../development/tools/parsing/sdf) {
    inherit fetchurl stdenv aterm getopt pkgconfig;
  };

  expat = (import ../development/libraries/expat) {
    inherit fetchurl stdenv;
  };

  libcdaudio = (import ../development/libraries/libcdaudio) {
    inherit fetchurl stdenv;
  };

  libogg = (import ../development/libraries/libogg) {
    inherit fetchurl stdenv;
  };

  libvorbis = (import ../development/libraries/libvorbis) {
    inherit fetchurl stdenv libogg;
  };

  speex = (import ../development/libraries/speex) {
    inherit fetchurl stdenv;
  };

  libtheora = (import ../development/libraries/libtheora) {
    inherit fetchurl stdenv libogg libvorbis;
  };

  libwpd = (import ../development/libraries/libwpd) {
    inherit fetchurl stdenv pkgconfig libgsf libxml2;
    inherit (gnome) glib;
  };

  libgsf = (import ../development/libraries/libgsf) {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig libxml2;
    inherit (gnome) glib;
  };

  libxml2 = (import ../development/libraries/libxml2) {
    inherit fetchurl stdenv zlib python;
#    pythonSupport = stdenv.system == "i686-linux";
    pythonSupport = false;
  };

  libxslt = (import ../development/libraries/libxslt) {
    inherit fetchurl stdenv libxml2;
  };

  gettext = (import ../development/libraries/gettext) {
    inherit fetchurl stdenv;
  };

  db4 = (import ../development/libraries/db4) {
    inherit fetchurl stdenv;
  };

  openssl = (import ../development/libraries/openssl) {
    inherit fetchurl stdenv perl;
  };

  libmspack = (import ../development/libraries/libmspack) {
    inherit fetchurl stdenv;
  };

  libsndfile = (import ../development/libraries/libsndfile) {
    inherit fetchurl stdenv;
  };

  neon = (import ../development/libraries/neon) {
    inherit fetchurl stdenv libxml2;
  };

  nss = (import ../development/libraries/nss) {
    inherit fetchurl stdenv perl zip;
  };

  freetype = (import ../development/libraries/freetype) {
    inherit fetchurl stdenv;
  };

  zlib = (import ../development/libraries/zlib) {
    inherit fetchurl stdenv;
  };

  libjpeg = (import ../development/libraries/libjpeg) {
    inherit fetchurl stdenv;
  };

  libtiff = (import ../development/libraries/libtiff) {
    inherit fetchurl stdenv zlib libjpeg;
  };

  libpng = (import ../development/libraries/libpng) {
    inherit fetchurl stdenv zlib;
  };

  aalib = (import ../development/libraries/aalib) {
    inherit fetchurl stdenv ncurses;
  };

  libcaca = (import ../development/libraries/libcaca) {
    inherit fetchurl stdenv ncurses;
  };

  libsigsegv = (import ../development/libraries/libsigsegv) {
    inherit fetchurl stdenv;
  };

  libexif = (import ../development/libraries/libexif) {
    inherit fetchurl stdenv;
  };

  sqlite = (import ../development/libraries/sqlite) {
    inherit fetchurl stdenv;
  };

  lcms = (import ../development/libraries/lcms) {
    inherit fetchurl stdenv;
  };

  libgphoto2 = (import ../development/libraries/libgphoto2) {
    inherit fetchurl stdenv;
  };

  popt = (import ../development/libraries/popt) {
    inherit fetchurl stdenv gettext;
  };

  slang = (import ../development/libraries/slang) {
    inherit fetchurl stdenv pcre libpng;
  };

  cairo = (import ../development/libraries/cairo) {
    inherit fetchurl stdenv pkgconfig x11 fontconfig freetype zlib libpng;
  };

  gtkLibs = gtkLibs28;

  gtkLibs28 = import ../development/libraries/gtk-libs-2.8 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng cairo;
    inherit (xlibs) libXinerama;
    xineramaSupport = true;
  };

  gtkLibs26 = import ../development/libraries/gtk-libs-2.6 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs24 = import ../development/libraries/gtk-libs-2.4 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };
  gtkLibs22 = import ../development/libraries/gtk-libs-2.2 {
    inherit fetchurl stdenv pkgconfig gettext perl x11
            libtiff libjpeg libpng;
  };

  gtkLibs1x = import ../development/libraries/gtk-libs-1.x {
    inherit fetchurl stdenv x11 libtiff libjpeg libpng;
  };

  gtkmm = import ../development/libraries/gtk-libs-2.6/gtkmm {
    inherit fetchurl stdenv pkgconfig libsigcxx;
    inherit (gtkLibs26) gtk atk;
    inherit glibmm;
  };

  glibmm = import ../development/libraries/gtk-libs-2.6/glibmm {
    inherit fetchurl stdenv pkgconfig libsigcxx;
    inherit (gtkLibs26) glib;
  };

  libsigcxx = import ../development/libraries/libsigcxx {
    inherit fetchurl stdenv pkgconfig;
  };

  pangoxsl = (import ../development/libraries/pangoxsl) {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib pango;
  };

  qt3 = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql;
    inherit (xlibs) libXft libXrender;
  };

  kdelibs = import ../development/libraries/kde/kdelibs {
    inherit fetchurl stdenv zlib perl openssl pcre  pkgconfig libjpeg libpng libtiff libxml2 libxslt libtool expat freetype;
    inherit (xlibs) libX11 libXt libXext;
    qt = qt3;
  };

  gtksharp1 = (import ../development/libraries/gtk-sharp-1) {
    inherit fetchurl stdenv mono pkgconfig libxml2 monoDLLFixer;
    inherit (gnome) gtk glib pango libglade libgtkhtml gtkhtml 
              libgnomecanvas libgnomeui libgnomeprint 
              libgnomeprintui GConf;
  };

  gtksharp2 = (import ../development/libraries/gtk-sharp-2) {
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

  gtkmozembedsharp = import ../development/libraries/gtkmozembed-sharp {
    inherit fetchurl stdenv mono pkgconfig monoDLLFixer;
    inherit (gnome) gtk;
    gtksharp = gtksharp2;
  };

  audiofile = (import ../development/libraries/audiofile) {
    inherit fetchurl stdenv;
  };

  gnome = import ../development/libraries/gnome {
    inherit fetchurl stdenv pkgconfig audiofile
            flex bison popt zlib libxml2 libxslt
            perl perlXMLParser docbook_xml_dtd_42 gettext x11
            libtiff libjpeg libpng gtkLibs;
    inherit (xlibs) libXmu;
  };

  wxGTK = wxGTK26;

  wxGTK26 = (import ../development/libraries/wxGTK-2.6) {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama;
  };

  wxGTK25 = (import ../development/libraries/wxGTK-2.5) {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXinerama;
  };

  wxGTK24 = (import ../development/libraries/wxGTK) {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs22) gtk;
  };

  gnet = (import ../development/libraries/gnet) {
    inherit fetchurl stdenv pkgconfig;
    inherit (gtkLibs) glib;
  };

  libdvdcss = (import ../development/libraries/libdvdcss) {
    inherit fetchurl stdenv;
  };

  libdvdread = (import ../development/libraries/libdvdread) {
    inherit fetchurl stdenv libdvdcss;
  };

  libdvdplay = (import ../development/libraries/libdvdplay) {
    inherit fetchurl stdenv libdvdread;
  };

  mpeg2dec = (import ../development/libraries/mpeg2dec) {
    inherit fetchurl stdenv;
  };

  a52dec = (import ../development/libraries/a52dec) {
    inherit fetchurl stdenv;
  };

  libmad = (import ../development/libraries/libmad) {
    inherit fetchurl stdenv;
  };

  zvbi = (import ../development/libraries/zvbi) {
    inherit fetchurl stdenv libpng x11;
    pngSupport = true;
  };

  rte = (import ../development/libraries/rte) {
    inherit fetchurl stdenv;
  };

  xineLib = (import ../development/libraries/xine-lib) {
    inherit fetchurl stdenv zlib x11 libdvdcss alsaLib;
    inherit (xlibs) libXv libXinerama;
  };

  ncurses = (import ../development/libraries/ncurses) {
    inherit fetchurl stdenv;
  };

  fontconfig = import ../development/libraries/fontconfig {
    inherit fetchurl stdenv freetype expat;
  };

  xlibsOld = (import ../development/libraries/xlibs) {
    inherit fetchurl stdenv pkgconfig freetype fontconfig;
  };

  xlibsWrapper = import ../development/libraries/xlibs-wrapper {
    inherit stdenv;
    packages = [
      freetype fontconfig xlibs.xproto xlibs.libX11 xlibs.libXt
      xlibs.libXft xlibs.libXext xlibs.libSM xlibs.libICE
      xlibs.xextproto
    ];
  };

  Xaw3d = import ../development/libraries/Xaw3d {
    inherit fetchurl stdenv x11 bison;
    flex = flexnew;
    # !!! makedepend is impure
    inherit (xlibs) xmkmf makedepend libXmu libXpm libXp;
  };

  libdrm = import ../development/libraries/libdrm {
    inherit fetchurl stdenv;
  };

  libpcap = (import ../development/libraries/libpcap) {
    inherit fetchurl stdenv flex bison;
  };

  mesa = (import ../development/libraries/mesa) {
    inherit fetchurl stdenv xlibs;
  };

  chmlib = (import ../development/libraries/chmlib) {
    inherit fetchurl stdenv libtool;
  };

  dclib = (import ../development/libraries/dclib) {
    inherit fetchurl stdenv libxml2 openssl;
  };

  cracklib = (import ../development/libraries/cracklib) {
    inherit fetchurl stdenv;
  };

  libgpgerror = (import ../development/libraries/libgpg-error) {
    inherit fetchurl stdenv;
  };

  gpgme = (import ../development/libraries/gpgme) {
    inherit fetchurl stdenv libgpgerror gnupg;
  };

  ### DEVELOPMENT / LIBRARIES / JAVA

  saxon = (import ../development/libraries/java/saxon) {
    inherit fetchurl stdenv unzip;
  };

  saxonb = (import ../development/libraries/java/saxon/default8.nix) {
    inherit fetchurl stdenv unzip;
  };

  sharedobjects = (import ../development/libraries/java/shared-objects) {
    inherit fetchurl stdenv jdk;
  };

  jjtraveler = (import ../development/libraries/java/jjtraveler) {
    inherit fetchurl stdenv jdk;
  };

  atermjava = (import ../development/libraries/java/aterm) {
    inherit fetchurl stdenv sharedobjects jjtraveler jdk;
  };

  jakartaregexp = (import ../development/libraries/java/jakarta-regexp) {
    inherit fetchurl stdenv;
  };

  jakartabcel = (import ../development/libraries/java/jakarta-bcel) {
    regexp = jakartaregexp;
    inherit fetchurl stdenv;
  };

  jclasslib = (import ../development/tools/java/jclasslib) {
    inherit fetchurl stdenv xpf jre;
    ant = apacheAnt14;
  };

  lucene = import ../development/libraries/java/lucene {
    inherit stdenv fetchurl;
  };

  jdom = import ../development/libraries/java/jdom {
    inherit stdenv fetchurl;
  };

  javaCup = import ../development/libraries/java/cup {
    inherit stdenv fetchurl jdk;
  };

  jflex = import ../development/libraries/java/jflex {
    inherit stdenv fetchurl;
  };

  junit = import ../development/libraries/java/junit {
    inherit stdenv fetchurl unzip;
  };

  javasvn = import ../development/libraries/java/javasvn {
    inherit stdenv fetchurl unzip;
  };

  httpunit = import ../development/libraries/java/httpunit {
    inherit stdenv fetchurl unzip;
  };

  mockobjects = import ../development/libraries/java/mockobjects {
    inherit stdenv fetchurl;
  };

  commonsFileUpload = import ../development/libraries/java/jakarta-commons/file-upload {
    inherit stdenv fetchurl;
  };

  swt = import ../development/libraries/java/swt {
    inherit stdenv fetchurl unzip jdk pkgconfig;
    inherit (gtkLibs) gtk;
    inherit (xlibs) libXtst;
  };

  ### DEVELOPMENT / PERL MODULES

  perlBerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit fetchurl perl db4;
  };

  perlXMLParser = import ../development/perl-modules/XML-Parser {
    inherit fetchurl perl expat;
  };

  perlArchiveZip = import ../development/perl-modules/Archive-Zip {
    inherit fetchurl perl;
  };

  perlCompressZlib = import ../development/perl-modules/Compress-Zlib {
    inherit fetchurl perl;
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

  perlXMLSAX = import ../development/perl-modules/generic perl {
    name = "XML-SAX-0.12";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-SAX-0.12.tar.gz;
      md5 = "bff58bd077a9693fc8cf32e2b95f571f";
    };
    propagatedBuildInputs = [perlXMLNamespaceSupport];
  };

  perlXMLNamespaceSupport = import ../development/perl-modules/generic perl {
    name = "XML-NamespaceSupport-1.08";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-NamespaceSupport-1.08.tar.gz;
      md5 = "81bd5ae772906d0579c10061ed735dc8";
    };
    buildInputs = [];
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

  perlXMLSimple = import ../development/perl-modules/generic perl {
    name = "XML-Simple-2.14";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/XML-Simple-2.14.tar.gz;
      md5 = "f321058271815de28d214c8efb9091f9";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlTermReadKey = import ../development/perl-modules/generic perl {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  perlDateManip = import ../development/perl-modules/generic perl {
    name = "DateManip-5.42a";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/DateManip-5.42a.tar.gz;
      md5 = "648386bbf46d021ae283811f75b07bdf";
    };
  };

  perlHTMLTree = import ../development/perl-modules/generic perl {
    name = "HTML-Tree-3.18";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/HTML-Tree-3.18.tar.gz;
      md5 = "6a9e4e565648c9772e7d8ec6d4392497";
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

  perlURI = import ../development/perl-modules/generic perl {
    name = "URI-1.35";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/URI-1.35.tar.gz;
      md5 = "1a933b1114c41a25587ee59ba8376f7c";
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

  perlLocaleGettext = import ../development/perl-modules/generic perl {
    name = "LocaleGettext-1.04";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/P/PV/PVANDRY/gettext-1.04.tar.gz;
      md5 = "578dd0c76f8673943be043435b0fbde4";
    };
  };

  wxPython = (import ../development/python-modules/wxPython-2.5) {
    inherit fetchurl stdenv pkgconfig wxGTK python;
  };

  wxPython24 = (import ../development/python-modules/wxPython) {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK24;
  };

  pygtk = (import ../development/python-modules/pygtk) {
    inherit fetchurl stdenv python pkgconfig;
    inherit (gtkLibs) glib gtk;
  };
  
  readline4 = (import ../development/libraries/readline/readline4.nix) {
    inherit fetchurl stdenv ncurses;
  };

  readline5 = (import ../development/libraries/readline/readline5.nix) {
    inherit fetchurl stdenv ncurses;
  };

  readline = readline5;

  SDL = (import ../development/libraries/SDL) {
    inherit fetchurl stdenv x11;
  };

  boehmgc = (import ../development/libraries/boehm-gc) {
    inherit fetchurl stdenv;
  };

  lesstif = (import ../development/libraries/lesstif) {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXp;
  };

  t1lib = (import ../development/libraries/t1lib) {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXaw;
  };

  
  ### SERVERS

  apacheHttpd = (import ../servers/http/apache-httpd) {
    inherit fetchurl stdenv perl openssl db4 expat;
    sslSupport = true;
    db4Support = true;
  };

  xorg = import ../servers/x11/xorg {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      expat libdrm libpng zlib perl mesa;
  };

  postgresql = (import ../servers/sql/postgresql) {
    inherit fetchurl stdenv readline ncurses zlib;
  };

  postgresql_jdbc = (import ../servers/sql/postgresql/jdbc) {
    inherit fetchurl stdenv;
    ant = apacheAntBlackdown14;
  };

  mysql = import ../servers/sql/mysql {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  jetty = (import ../servers/http/jetty) {
    inherit fetchurl stdenv unzip;
  };

  
  ### OS-SPECIFIC

  uclibcArm = (import ../development/uclibc) {
    inherit fetchurl stdenv;
    kernelHeadersCross = kernelHeadersArm;
    binutilsCross = binutilsArm;
    gccCross = gcc40arm;
    cross = "arm-linux";
  };

  uclibcMips = (import ../development/uclibc) {
    inherit fetchurl stdenv;
    kernelHeadersCross = kernelHeadersMips;
    binutilsCross = binutilsMips;
    gccCross = gcc40mips;
    cross = "mips-linux";
  };

  dietlibc = (import ../os-specific/linux/dietlibc) {
    inherit fetchurl stdenv;
  };

  #dietlibcArm = (import ../os-specific/linux/dietlibc-cross) {
  #  inherit fetchurl stdenv;
  #  gccCross = gcc40arm;
  #  binutilsCross = binutilsArm;
  #  arch = "arm";
  #};

  dietlibcWrapper = (import ../os-specific/linux/dietlibc-wrapper) {
    inherit stdenv dietlibc;
    gcc = stdenv.gcc;
  };

  eject = (import ../os-specific/linux/eject) {
    inherit fetchurl stdenv gettext;
  };

  initscripts = (import ../os-specific/linux/initscripts) {
    inherit fetchurl stdenv popt pkgconfig;
    inherit (gtkLibs) glib;
  };

  hwdata = (import ../os-specific/linux/hwdata) {
    inherit fetchurl stdenv;
  };

  kernelHeaders = (import ../os-specific/linux/kernel-headers) {
    inherit fetchurl stdenv;
  };

  kernelHeadersArm = (import ../os-specific/linux/kernel-headers-cross) {
    inherit fetchurl stdenv;
    cross = "arm-linux";
  };

  kernelHeadersMips = (import ../os-specific/linux/kernel-headers-cross) {
    inherit fetchurl stdenv;
    cross = "mips-linux";
  };

  kernel = (import ../os-specific/linux/kernel) {
    inherit fetchurl stdenv perl;
  };

  #klibc = (import ../os-specific/linux/klibc) {
  #  inherit fetchurl stdenv kernel perl bison flexWrapper;
  #};

  mingetty = (import ../os-specific/linux/mingetty) {
    inherit fetchurl stdenv;
  };

  mingettyWrapper = (import ../os-specific/linux/mingetty-wrapper) {
    inherit stdenv mingetty shadowutils;
  };

  pam = (import ../os-specific/linux/pam) {
    inherit stdenv fetchurl cracklib;
  };

  #nfsUtils = (import ../os-specific/linux/nfs-utils) {
  #  inherit fetchurl stdenv;
  #};

  alsaLib = (import ../os-specific/linux/alsa/library) {
    inherit fetchurl stdenv;
  };

  alsaUtils = (import ../os-specific/linux/alsa/utils) {
    inherit fetchurl stdenv alsaLib ncurses gettext;
  };

  utillinux = (import ../os-specific/linux/util-linux) {
    inherit fetchurl stdenv;
  };

  utillinuxStatic = (import ../os-specific/linux/util-linux-static) {
    inherit fetchurl stdenv;
  };

  sysklogd = (import ../os-specific/linux/sysklogd) {
    inherit fetchurl stdenv;
  };

  sysvinit = (import ../os-specific/linux/sysvinit) {
    inherit fetchurl stdenv;
  };

  e2fsprogs = (import ../os-specific/linux/e2fsprogs) {
    inherit fetchurl stdenv gettext;
  };

  e2fsprogsDiet = (import ../os-specific/linux/e2fsprogs-diet) {
    inherit fetchurl stdenv gettext dietgcc;
  };

  nettools = (import ../os-specific/linux/net-tools) {
    inherit fetchurl stdenv;
  };

  modutils = (import ../os-specific/linux/modutils) {
    inherit fetchurl stdenv bison flex;
  };

  module_init_tools = (import ../os-specific/linux/module-init-tools) {
    inherit fetchurl stdenv;
  };

  module_init_toolsStatic = (import ../os-specific/linux/module-init-tools-static) {
    inherit fetchurl stdenv;
  };

  shadowutils = (import ../os-specific/linux/shadow) {
    inherit fetchurl stdenv;
  };

  iputils = (import ../os-specific/linux/iputils) {
    inherit fetchurl stdenv kernelHeaders;
    glibc = stdenv.gcc.glibc;
  };

  procps = import ../os-specific/linux/procps {
    inherit fetchurl stdenv ncurses;
  };

  syslinux = import ../os-specific/linux/syslinux {
    inherit fetchurl stdenv nasm perl;
  };

  hotplug = import ../os-specific/linux/hotplug {
    inherit fetchurl stdenv;
  };

  udev = import ../os-specific/linux/udev {
    inherit fetchurl stdenv;
  };

  fuse = import ../os-specific/linux/fuse {
    inherit fetchurl stdenv;
  };

  
  ### DATA

  docbook_xml_dtd_42 = (import ../data/sgml+xml/schemas/xml-dtd/docbook-4.2) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_43 = (import ../data/sgml+xml/schemas/xml-dtd/docbook-4.3) {
    inherit fetchurl stdenv unzip;
  };

  docbook_ng = (import ../data/sgml+xml/schemas/docbook-ng) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_ebnf_dtd = (import ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = (import ../data/sgml+xml/stylesheets/xslt/docbook) {
    inherit fetchurl stdenv;
  };


  ### APPLICATIONS

  openoffice = (import ../applications/office/openoffice) {
    inherit fetchurl stdenv pam python tcsh libxslt
      perl perlArchiveZip perlCompressZlib zlib libjpeg
      expat pkgconfig freetype fontconfig libwpd libxml2
      db4 sablotron curl libsndfile flex zip unzip libmspack
      getopt file;
    inherit (xlibs) libXaw;
    inherit (gtkLibs) gtk;

    bison = (import ../development/tools/parsing/bison/bison-2.1.nix) {
      inherit fetchurl stdenv;
      m4 = gnum4;
    };

    neon = (import ../development/libraries/neon/neon-0.24.7.nix) {
      inherit fetchurl stdenv libxml2;
    };
  };

  rpm = (import ../applications/package-management/rpm) {
    inherit fetchurl stdenv python tcl readline file cpio beecrypt unzip neon gnupg libxml2 perl;
  };

  cvs = (import ../applications/version-management/cvs) {
    inherit fetchurl stdenv vim;
  };

  subversion11x = (import ../applications/version-management/subversion-1.1.x) {
    inherit fetchurl stdenv openssl db4 expat swig zlib;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    compressionSupport = true;
    httpd = apacheHttpd;
  };

  subversion = (import ../applications/version-management/subversion-1.2.x) {
    inherit fetchurl stdenv openssl db4 expat swig zlib;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    compressionSupport = true;
    httpd = apacheHttpd;
  };

  subversionWithJava = (import ../applications/version-management/subversion-1.2.x) {
    inherit fetchurl stdenv openssl db4 expat;
    swig = swigWithJava;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    httpd = apacheHttpd;
    javahlBindings = true;
    jdk = blackdown;
  };

  rcs = (import ../applications/version-management/rcs) {
    inherit fetchurl stdenv;
  };

  darcs = import ../applications/version-management/darcs {
    inherit fetchurl stdenv ghc zlib ncurses;
  };

  pan = (import ../applications/networking/newsreaders/pan) {
    inherit fetchurl stdenv pkgconfig gnet libxml2 perl pcre;
    inherit (gtkLibs) gtk;
    spellChecking = false;
  };

  sylpheed = (import ../applications/networking/mailreaders/sylpheed) {
    inherit fetchurl stdenv pkgconfig openssl gpgme;
    inherit (gtkLibs) glib gtk;
    sslSupport = true;
    gpgSupport = true;
  };

  valknut = (import ../applications/networking/p2p/valknut) {
    inherit fetchurl stdenv perl x11 libxml2 libjpeg libpng openssl dclib;
    qt = qt3;
  };

  mozilla = (import ../applications/networking/browsers/mozilla) {
    inherit fetchurl pkgconfig stdenv perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  firefox = (import ../applications/networking/browsers/firefox) {
    inherit fetchurl stdenv pkgconfig perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  wrapFirefox = firefox: (import ../applications/networking/browsers/firefox-wrapper) {
    inherit stdenv firefox;
    plugins = [
      MPlayerPlugin
      flashplayer
      blackdown
#      RealPlayer  # disabled by default for legal reasons
    ];
  };

  firefoxWrapper = wrapFirefox firefox;

  flashplayer = (import ../applications/networking/browsers/mozilla-plugins/flashplayer) {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXmu;
  };

  thunderbird = 
    (import ../build-support/make-symlinks) {
      inherit stdenv;
      dir =
        (import ../applications/networking/mailreaders/thunderbird) {
          inherit fetchurl stdenv pkgconfig perl zip;
          inherit (gtkLibs) gtk;
          inherit (gnome) libIDL;
        };
      files = ["bin/thunderbird" "lib/thunderbird-0.8/icons"];
    };

  lynx = (import ../applications/networking/browsers/lynx) {
    inherit fetchurl stdenv ncurses openssl;
  };

  links = (import ../applications/networking/browsers/links) {
    inherit fetchurl stdenv;
  };

  w3m = (import ../applications/networking/browsers/w3m) {
    inherit fetchurl stdenv ncurses openssl boehmgc gettext;
  };

  ethereal = (import ../applications/networking/sniffers/ethereal) {
    inherit fetchurl stdenv perl pkgconfig libpcap;
    inherit (gtkLibs) glib;
  };

  gaim = (import ../applications/networking/instant-messengers/gaim) {
    inherit fetchurl stdenv pkgconfig perl libxml2 openssl nss;
    inherit (gtkLibs) glib gtk;
  };

  xchat = (import ../applications/networking/irc/xchat) {
    inherit fetchurl stdenv pkgconfig tcl;
    inherit (gtkLibs) glib gtk;
  };

  rsync = (import ../applications/networking/sync/rsync) {
    inherit fetchurl stdenv;
  };

  cdparanoiaIII = (import ../applications/audio/cdparanoia) {
    inherit fetchurl stdenv;
  };
  
  flac = (import ../applications/audio/flac) {
    inherit fetchurl stdenv libogg;
  };

  lame = (import ../applications/audio/lame) {
    inherit fetchurl stdenv ;
  };

  xmms = (import ../applications/audio/xmms) {
    inherit fetchurl stdenv libogg libvorbis alsaLib;
    inherit (gnome) esound;
    inherit (gtkLibs1x) glib gtk;
  };

  MPlayer = (import ../applications/video/MPlayer) {
    inherit fetchurl stdenv freetype x11 zlib libtheora libcaca;
    inherit (xlibs) libXv libXinerama;
    alsaSupport = true;
    alsa = alsaLib;
    theoraSupport = true;
    cacaSupport = true;
    xineramaSupport = true;
  };

  MPlayerPlugin = (import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in) {
    inherit fetchurl stdenv pkgconfig firefox;
    inherit (xlibs) libXpm;
    # !!! should depend on MPlayer
  };

  vlc = (import ../applications/video/vlc) {
    inherit fetchurl stdenv libdvdcss wxGTK libdvdplay
            mpeg2dec a52dec libmad x11;
    inherit (xlibs) libXv;
    alsa = alsaLib;
  };

  xineUI = (import ../applications/video/xine-ui) {
    inherit fetchurl stdenv x11 xineLib libpng;
  };

  RealPlayer = import ../applications/video/RealPlayer {
    inherit fetchurl stdenv;
    inherit (gtkLibs) glib pango atk gtk;
    inherit (xlibs) libX11;
    libstdcpp5 = gcc33.gcc;
  };

  zapping = (import ../applications/video/zapping) {
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

  mythtv = (import ../applications/video/mythtv) {
    inherit fetchurl stdenv which qt3 x11 lame;
    inherit (xlibs) libXinerama libXv libXxf86vm;
  };

  gqview = (import ../applications/graphics/gqview) {
    inherit fetchurl stdenv pkgconfig libpng;
    inherit (gtkLibs) gtk;
  };

  batik = (import ../applications/graphics/batik) {
    inherit fetchurl stdenv unzip;
  };

  inkscape = (import ../applications/graphics/inkscape) {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig zlib
      popt libxml2 libxslt libpng boehmgc fontconfig gtkmm
      glibmm libsigcxx;
    inherit (gtkLibs) gtk glib;
    inherit (xlibs) libXft;
  };

  fspot = (import ../applications/graphics/f-spot) {
    inherit fetchurl stdenv perl perlXMLParser pkgconfig mono
            libexif libjpeg sqlite lcms libgphoto2 monoDLLFixer;
    inherit (gnome) libgnome libgnomeui;
    gtksharp = gtksharp1;
  };

  gimp = (import ../applications/graphics/gimp) {
    inherit fetchurl stdenv pkgconfig freetype fontconfig
      libtiff libjpeg libpng libexif zlib perl perlXMLParser;
    inherit (gnome) gtk libgtkhtml glib pango atk libart_lgpl;
  };

  cdrtools = (import ../applications/misc/cdrtools) {
    inherit fetchurl stdenv;
  };

  hello = (import ../applications/misc/hello/ex-1) {
    inherit fetchurl stdenv perl;
  };

  pinfo = (import ../applications/misc/pinfo) {
    inherit fetchurl stdenv ncurses;
  };

  xchm = (import ../applications/misc/xchm) {
    inherit fetchurl stdenv wxGTK chmlib;
  };

  xpdf = (import ../applications/misc/xpdf) {
    inherit fetchurl stdenv x11 freetype t1lib;
    motif = lesstif;
  };

  acroread = (import ../applications/misc/acrobat-reader) {
    inherit fetchurl stdenv zlib;
    inherit (xlibs) libXt libXp libXext libX11 libXinerama;
    inherit (gtkLibs) glib pango atk gtk;
    libstdcpp5 = gcc33.gcc;
    xineramaSupport = true;
    fastStart = true;
  };

  eclipse = (import ../applications/editors/eclipse) {
    inherit fetchurl stdenv makeWrapper jdk;
    inherit (gtkLibs) gtk glib;
    inherit (xlibs) libXtst;
    plugins = [spoofax];
  };

  spoofax = (import ../applications/editors/eclipse/plugins/spoofax) {
    inherit fetchurl stdenv;
  };

  monodevelop = (import ../applications/editors/monodevelop) {
    inherit fetchurl stdenv file mono gtksourceviewsharp
            gtkmozembedsharp monodoc perl perlXMLParser pkgconfig;
    inherit (gnome) gnomevfs libbonobo libglade libgnome GConf glib gtk;
    mozilla = firefox;
    gtksharp = gtksharp2;
  };

  monodoc = (import ../applications/editors/monodoc) {
    inherit fetchurl stdenv mono pkgconfig;
    gtksharp = gtksharp1;
  };

  emacs = (import ../applications/editors/emacs) {
    inherit fetchurl stdenv x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    xaw3dSupport = false;
  };

  emacs22 = (import ../applications/editors/emacs-22) {
    inherit fetchurl stdenv pkgconfig x11 Xaw3d;
    inherit (xlibs) libXaw libXpm;
    inherit (gtkLibs) gtk;
    xaw3dSupport = false;
    gtkGUI = true;
  };

  emacs22aa = (import ../applications/editors/emacs-22-aa) {
    inherit fetchurl stdenv pkgconfig x11 Xaw3d libpng;
    inherit (xlibs) libXaw libXpm libXft;
    inherit (gtkLibs) gtk;
    xaw3dSupport = false;
    gtkGUI = true;
    xftSupport = true;
  };

  nxml = (import ../applications/editors/emacs/modes/nxml) {
    inherit fetchurl stdenv;
  };

  cua = (import ../applications/editors/emacs/modes/cua) {
    inherit fetchurl stdenv;
  };

  haskellMode = (import ../applications/editors/emacs/modes/haskell) {
    inherit fetchurl stdenv;
  };

  nano = (import ../applications/editors/nano) {
    inherit fetchurl stdenv ncurses;
  };

  vim = (import ../applications/editors/vim) {
    inherit fetchurl stdenv ncurses;
  };

#  vimDiet = (import ../applications/editors/vim-diet) {
#    inherit fetchurl stdenv ncurses dietgcc;
#  };

  nedit = import ../applications/editors/nedit {
    inherit fetchurl stdenv x11;
    inherit (xlibs) libXpm;
    motif = lesstif;
  };


  ### GAMES

  zoom = (import ../games/zoom) {
    inherit fetchurl stdenv perl expat freetype;
    inherit (xlibs) xlibs;
  };

  quake3demo = (import ../games/quake3demo) {
    inherit fetchurl stdenv xlibs mesa;
  };

  ut2004demo = (import ../games/ut2004demo) {
    inherit fetchurl stdenv xlibs mesa;
  };


  ### MISC

  uml = (import ../misc/uml) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
    gcc = gcc33;
  };

  umlutilities = (import ../misc/uml-utilities) {
    inherit fetchurl stdenv;
  };

  /*
  atari800 = (import ../misc/emulators/atari800) {
    inherit fetchurl stdenv zlib SDL;
  };

  ataripp = (import ../misc/emulators/atari++) {
    inherit fetchurl stdenv x11 SDL;
  };
  */

  generator = (import ../misc/emulators/generator) {
    inherit fetchurl stdenv SDL nasm;
    inherit (gtkLibs1x) gtk;
  };

  dosbox = (import ../misc/emulators/dosbox) {
    inherit fetchurl stdenv SDL;
  };

  tetex = (import ../misc/tex/tetex) {
    inherit fetchurl stdenv flex bison zlib libpng ncurses ed;
  };

  ghostscript = (import ../misc/ghostscript) {
    inherit fetchurl stdenv libjpeg libpng zlib x11;
    x11Support = false;
  };

  #nixStatic = (import ../misc/nix-static) {
  # inherit fetchurl stdenv aterm perl;
  #  curl = bootCurl; /* !!! ugly */
  #  bdb = db4;
  #};

  nix = (import ../misc/nix) {
    inherit fetchurl stdenv aterm perl;
    curl = bootCurl; /* !!! ugly */
    bdb = db4;
  };

  cups = (import ../misc/cups) {
    inherit fetchurl stdenv;
  };

  saneBackends = (import ../misc/sane-backends) {
    inherit fetchurl stdenv;
  };

}
