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

  x11 = xlibs.xlibs; # !!! should be `x11ClientLibs' or some such


  ### BUILD SUPPORT

  fetchurl = (import ../build-support/fetchurl) {
    inherit stdenv;
    curl = bootCurl;
  };

  fetchsvn = (import ../build-support/fetchsvn) {
    inherit stdenv subversion nix;
  };


  ### TOOLS

  coreutils = (import ../tools/misc/coreutils) {
    inherit fetchurl stdenv;
  };

  findutils = (import ../tools/misc/findutils) {
    inherit fetchurl stdenv;
  };

  getopt = (import ../tools/misc/getopt) {
    inherit fetchurl stdenv;
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

  enscript = (import ../tools/text/enscript) {
    inherit fetchurl stdenv;
  };

  ed = (import ../tools/text/ed) {
    inherit fetchurl stdenv;
  };

  xpf = (import ../tools/text/xml/xpf) {
    inherit fetchurl stdenv python libxml2;
  };

  jing_tools = (import ../tools/text/xml/jing/jing-script.nix) {
    inherit fetchurl stdenv unzip;
    j2re = blackdown;
  };

  gnutar = (import ../tools/archivers/gnutar) {
    inherit fetchurl stdenv;
  };

  zip = (import ../tools/archivers/zip) {
    inherit fetchurl stdenv;
  };

  unzip = (import ../tools/archivers/unzip) {
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

  par2cmdline = (import ../tools/networking/par2cmdline) {
    inherit fetchurl stdenv;
  };

  cksfv = (import ../tools/networking/cksfv) {
    inherit fetchurl stdenv;
  };

  bittorrent = (import ../tools/networking/bittorrent) {
    inherit fetchurl stdenv;
    wxPython = wxPython24;
  };

  graphviz = (import ../tools/graphics/graphviz) {
    inherit fetchurl stdenv libpng libjpeg expat x11 yacc;
    inherit (xlibs) libXaw;
  };

  hevea = (import ../tools/typesetting/hevea) {
    inherit fetchurl stdenv ocaml;
  };

  less = (import ../tools/misc/less) {
    inherit fetchurl stdenv ncurses;
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

  
  ### SHELLS

  bash = (import ../shells/bash) {
    inherit fetchurl stdenv;
  };


  ### DEVELOPMENT

  binutils = (import ../development/tools/misc/binutils) {
    inherit fetchurl stdenv noSysDirs;
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

  automake = (import ../development/tools/misc/automake) {
    inherit fetchurl stdenv perl autoconf;
  };

  automake194 = (import ../development/tools/misc/automake/automake-1.9.4.nix) {
    inherit fetchurl stdenv perl autoconf;
  };

  libtool = (import ../development/tools/misc/libtool) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  pkgconfig = (import ../development/tools/misc/pkgconfig) {
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
    j2sdk = blackdown;
    perlSupport = false;
    pythonSupport = false;
    javaSupport = true;
  };

  valgrind = (import ../development/tools/misc/valgrind) {
    inherit fetchurl stdenv perl;
  };

  texinfo = (import ../development/tools/misc/texinfo) {
    inherit fetchurl stdenv ncurses;
  };

  gperf = (import ../development/tools/misc/gperf) {
    inherit fetchurl stdenv;
  };

  lcov = (import ../development/tools/misc/lcov) {
    inherit fetchurl stdenv perl;
  };

  octave = (import ../development/interpreters/octave) {
    inherit fetchurl stdenv readline ncurses g77 perl;
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

  flexnew = (import ../development/tools/parsing/flex/flex-new.nix) {
    inherit fetchurl stdenv yacc;
    m4 = gnum4;
  };

  gcc = (import ../development/compilers/gcc-3.4) {
    inherit fetchurl stdenv noSysDirs;
    langCC = gccWithCC;
    profiledCompiler = gccWithProfiling;
  };

  gccWrapped = (import ../build-support/gcc-wrapper) {
    nativeTools = false;
    nativeGlibc = false;
    gcc = stdenv.gcc;
    inherit (stdenv.gcc) binutils glibc;
    inherit stdenv;
  };

  gcc_static = (import ../development/compilers/gcc-static-3.4) {
    inherit fetchurl stdenv;
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

  jikes = (import ../development/compilers/jikes) {
    inherit fetchurl stdenv;
  };

  blackdown = (import ../development/compilers/blackdown) {
    inherit fetchurl stdenv;
  };

  j2sdk = (import ../development/compilers/j2sdk) {
    inherit fetchurl stdenv;
  };

  j2sdk15 = (import ../development/compilers/j2sdk/default-1.5.nix) {
    inherit fetchurl stdenv;
  };

  saxon = (import ../development/libraries/java/saxon) {
    inherit fetchurl stdenv unzip;
  };

  saxonb = (import ../development/libraries/java/saxon/default8.nix) {
    inherit fetchurl stdenv unzip;
  };

  sharedobjects = (import ../development/libraries/java/shared-objects) {
    j2sdk = j2sdk15;
    inherit fetchurl stdenv;
  };

  jjtraveler = (import ../development/libraries/java/jjtraveler) {
    j2sdk = j2sdk15;
    inherit fetchurl stdenv;
  };

  atermjava = (import ../development/libraries/java/aterm) {
    j2sdk = j2sdk15;
    inherit fetchurl stdenv sharedobjects jjtraveler;
  };

  jakartaregexp = (import ../development/libraries/java/jakarta-regexp) {
    inherit fetchurl stdenv;
  };

  jakartabcel = (import ../development/libraries/java/jakarta-bcel) {
    regexp = jakartaregexp;
    inherit fetchurl stdenv;
  };

  jclasslib = (import ../development/tools/java/jclasslib) {
    inherit fetchurl stdenv xpf;
    j2re = j2sdk15;
    ant = apacheAnt14;
  };

  ocaml = (import ../development/compilers/ocaml) {
    inherit fetchurl stdenv x11;
  };

  strategoxt = (import ../development/compilers/strategoxt) {
    inherit fetchurl stdenv aterm;
    sdf = sdf_23;
  };

  strategoxt_012 = (import ../development/compilers/strategoxt/strategoxt-0.12.nix) { 
    inherit fetchurl stdenv aterm;
    sdf = sdf_22;
  };

  bibtextools = (import ../tools/typesetting/bibtex-tools) {
    inherit fetchurl stdenv aterm strategoxt hevea;
    sdf = sdf_23;
  };

#  xdoc = (import ../development/tools/documentation/xdoc) {
#    inherit fetchurl stdenv aterm strategoxt subversion graphviz;
#    sdf = sdf_23;
#  };

  #tiger = (import ../development/compilers/tiger) {
  #  inherit fetchurl stdenv aterm strategoxt;
  #  sdf = sdf_22;
  #};

  ghcboot = (import ../development/compilers/ghc/boot.nix) {
    inherit fetchurl stdenv perl;
  };

  ghc = (import ../development/compilers/ghc) {
    inherit fetchurl stdenv perl;
    ghc = ghcboot;
    m4 = gnum4;
  };

  helium = (import ../development/compilers/helium) {
    inherit fetchurl stdenv ghc;
  };

  happy = (import ../development/tools/parsing/happy) {
    inherit fetchurl stdenv perl ghc;
  };

  harp = (import ../development/compilers/harp) {
    inherit fetchurl stdenv unzip ghc happy;
  };

  nasm = (import ../development/compilers/nasm) {
    inherit fetchurl stdenv;
  };

  realPerl = (import ../development/interpreters/perl) {
    inherit fetchurl stdenv;
  };

  sysPerl = (import ../development/interpreters/sys-perl) {
    inherit stdenv;
  };

  perl = if stdenv.system == "powerpc-darwin" then sysPerl else realPerl;

  python = (import ../development/interpreters/python) {
    inherit fetchurl stdenv zlib;
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

  j2re = (import ../development/interpreters/j2re) {
    inherit fetchurl stdenv;
  };

  kaffe =  (import ../development/interpreters/kaffe) {
    inherit fetchurl stdenv jikes alsaLib xlibs;
  };

  apacheAnt14 = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv j2sdk;
    name = "ant-j2sdk-1.4.2";
  };

  apacheAntBlackdown14 = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv;
    j2sdk = blackdown;
     name = "ant-blackdown-1.4.2";
  };

  apacheAnt15 = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv;
    name = "ant-j2sdk-1.5.0";
    j2sdk = j2sdk15;
  };

  tomcat5 = (import ../servers/http/tomcat) {
    inherit fetchurl stdenv ;
    j2sdk = blackdown;
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

  sdf_23 = {
    errorsupport = sdf2_bundle;
    toolbuslib   = sdf2_bundle;
    ptsupport    = sdf2_bundle;
    asfsupport   = sdf2_bundle;
    sdfsupport   = sdf2_bundle;
    sglr         = sdf2_bundle;
    ascsupport   = sdf2_bundle;
    pgen         = sdf2_bundle;
    asflibrary   = sdf2_bundle;
  };

  sdf_22 = (import ../development/tools/parsing/sdf2/bundle-2.2.nix) {
    inherit fetchurl stdenv getopt aterm;
  };

  sdf2_bundle = (import ../development/tools/parsing/sdf2-bundle) {
    inherit fetchurl stdenv aterm getopt;
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

  libxml2 = (import ../development/libraries/libxml2) {
    inherit fetchurl stdenv zlib python;
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

  libsigsegv = (import ../development/libraries/libsigsegv) {
    inherit fetchurl stdenv;
  };

  popt = (import ../development/libraries/popt) {
    inherit fetchurl stdenv gettext;
  };

  scrollkeeper = (import ../development/libraries/scrollkeeper) {
    inherit fetchurl stdenv perl libxml2 libxslt
            docbook_xml_dtd_42 perlXMLParser;
  };

  gtkLibs = import ../development/libraries/gtk-libs-2.4 {
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

  qt3 = import ../development/libraries/qt-3 {
    inherit fetchurl stdenv x11 zlib libjpeg libpng which mysql;
    inherit (xlibs) libXft libXrender;
  };

  audiofile = (import ../development/libraries/audiofile) {
    inherit fetchurl stdenv;
  };

  gnome = import ../development/libraries/gnome {
    inherit fetchurl stdenv pkgconfig audiofile
            flex bison popt perl zlib libxml2 bzip2
            perlXMLParser gtkLibs;
  };

  wxGTK = (import ../development/libraries/wxGTK-2.5) {
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
    libpng = libpng;
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

  xlibs = (import ../development/libraries/xlibs) {
    inherit fetchurl stdenv pkgconfig freetype expat;
  };

  mesa = (import ../development/libraries/mesa) {
    inherit fetchurl stdenv xlibs;
  };

  chmlib = (import ../development/libraries/chmlib) {
    inherit fetchurl stdenv libtool;
  };

  perlBerkeleyDB = (import ../development/perl-modules/BerkeleyDB) {
    inherit fetchurl stdenv perl db4;
  };

  perlXMLParser = (import ../development/perl-modules/XML-Parser) {
    inherit fetchurl stdenv perl expat;
  };

  perlXMLTwig = import ../development/perl-modules/generic perl {
    name = "XML-Twig-3.15";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/M/MI/MIROD/XML-Twig-3.15.tar.gz;
      md5 = "b26886b8bd19761fff37b23e4964b499";
    };
    propagatedBuildInputs = [perlXMLParser];
  };

  perlXMLWriter = import ../development/perl-modules/generic perl {
    name = "XML-Writer-0.520";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/J/JO/JOSEPHW/XML-Writer-0.520.tar.gz;
      md5 = "0a194acc70c906c0be32f4b2b7a9f689";
    };
  };

  perlTermReadKey = import ../development/perl-modules/generic perl {
    name = "TermReadKey-2.30";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.30.tar.gz;
      md5 = "f0ef2cea8acfbcc58d865c05b0c7e1ff";
    };
  };

  perlDateManip = import ../development/perl-modules/generic perl {
    name = "DateManip-5.42a";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/S/SB/SBECK/DateManip-5.42a.tar.gz;
      md5 = "648386bbf46d021ae283811f75b07bdf";
    };
  };

  perlHTMLTree = import ../development/perl-modules/generic perl {
    name = "HTML-Tree-3.18";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/S/SB/SBURKE/HTML-Tree-3.18.tar.gz;
      md5 = "6a9e4e565648c9772e7d8ec6d4392497";
    };
  };

  perlHTMLParser = import ../development/perl-modules/generic perl {
    name = "HTML-Parser-3.45";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/HTML-Parser-3.45.tar.gz;
      md5 = "c2ac1379ac5848dd32e24347cd679391";
    };
  };

  perlHTMLTagset = import ../development/perl-modules/generic perl {
    name = "HTML-Tagset-3.04";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/S/SB/SBURKE/HTML-Tagset-3.04.tar.gz;
      md5 = "b82e0f08c1ececefe98b891f30dd56a6";
    };
  };

  perlURI = import ../development/perl-modules/generic perl {
    name = "URI-1.35";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/URI-1.35.tar.gz;
      md5 = "1a933b1114c41a25587ee59ba8376f7c";
    };
  };

  perlLWP = import ../development/perl-modules/generic perl {
    name = "libwww-perl-5.803";
    src = fetchurl {
      url = http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/libwww-perl-5.803.tar.gz;
      md5 = "3345d5f15a4f42350847254141725c8f";
    };
    propagatedBuildInputs = [perlURI perlHTMLParser];
  };

  wxPython = (import ../development/python-modules/wxPython-2.5) {
    inherit fetchurl stdenv pkgconfig wxGTK python;
  };

  wxPython24 = (import ../development/python-modules/wxPython) {
    inherit fetchurl stdenv pkgconfig python;
    wxGTK = wxGTK24;
  };

  readline = (import ../development/libraries/readline) {
    inherit fetchurl stdenv ncurses;
  };

  SDL = (import ../development/libraries/SDL) {
    inherit fetchurl stdenv x11;
  };

  boehmgc = (import ../development/libraries/boehm-gc) {
    inherit fetchurl stdenv;
  };

  ### SERVERS

  apacheHttpd = (import ../servers/http/apache-httpd) {
    inherit fetchurl stdenv perl openssl db4 expat;
    sslSupport = true;
    db4Support = true;
  };

  xfree86 = (import ../servers/x11/xfree86) {
    inherit fetchurl stdenv flex bison;
    buildServer = false;
    buildClientLibs = true;
  };

  postgresql = (import ../servers/sql/postgresql) {
    inherit fetchurl stdenv readline ncurses zlib;
    jdbcSupport = true;
    ant = apacheAntBlackdown14;
  };

  mysql = import ../servers/sql/mysql {
    inherit fetchurl stdenv ncurses zlib perl;
    ps = procps; /* !!! Linux only */
  };

  jetty = (import ../servers/http/jetty) {
    inherit fetchurl stdenv;
  };

  
  ### OS-SPECIFIC

  kernelHeaders = (import ../os-specific/linux/kernel-headers) {
    inherit fetchurl stdenv;
  };

  alsaLib = (import ../os-specific/linux/alsa/library) {
    inherit fetchurl stdenv;
  };

  utillinux = (import ../os-specific/linux/util-linux) {
    inherit fetchurl stdenv;
  };

  sysvinit = (import ../os-specific/linux/sysvinit) {
    inherit fetchurl stdenv;
  };

  e2fsprogs = (import ../os-specific/linux/e2fsprogs) {
    inherit fetchurl stdenv gettext;
  };

  nettools = (import ../os-specific/linux/net-tools) {
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

  
  ### DATA

  docbook_xml_dtd_42 = (import ../data/sgml+xml/schemas/xml-dtd/docbook-4.2) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_dtd_43 = (import ../data/sgml+xml/schemas/xml-dtd/docbook-4.3) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_ebnf_dtd = (import ../data/sgml+xml/schemas/xml-dtd/docbook-ebnf) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = (import ../data/sgml+xml/stylesheets/xslt/docbook) {
    inherit fetchurl stdenv;
  };


  ### APPLICATIONS

  subversion = (import ../applications/version-management/subversion-1.0.x) {
    inherit fetchurl stdenv openssl db4 expat swig;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    httpd = apacheHttpd;
  };

  subversionWithJava = (import ../applications/version-management/subversion-1.1.x) {
    inherit fetchurl stdenv openssl db4 expat;
    swig = swigWithJava;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    httpd = apacheHttpd;
    javaSwigBindings = true;
    javahlBindings = true;
    j2sdk = blackdown;
  };

  rcs = (import ../applications/version-management/rcs) {
    inherit fetchurl stdenv;
  };

  pan = (import ../applications/networking/newsreaders/pan) {
    inherit fetchurl stdenv pkgconfig gnet libxml2 perl pcre;
    inherit (gtkLibs) gtk;
    spellChecking = false;
  };

  sylpheed = (import ../applications/networking/mailreaders/sylpheed) {
    inherit fetchurl stdenv openssl;
    inherit (gtkLibs1x) gtk gdkpixbuf;
    sslSupport = true;
    imageSupport = true;
  };

  firefox = (import ../applications/networking/browsers/firefox) {
    inherit fetchurl stdenv pkgconfig perl zip;
    inherit (gtkLibs) gtk;
    inherit (gnome) libIDL;
    inherit (xlibs) libXi;
  };

  firefoxWrapper = (import ../applications/networking/browsers/firefox-wrapper) {
    inherit stdenv firefox;
    plugins = [MPlayerPlugin flashplayer blackdown];
  };

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

  cdparanoiaIII = (import ../applications/audio/cdparanoia) {
    inherit fetchurl stdenv;
  };
  
  flac = (import ../applications/audio/flac) {
    inherit fetchurl stdenv libogg;
  };

  lame = (import ../applications/audio/lame) {
    inherit fetchurl stdenv ;
  };

  MPlayer = (import ../applications/video/MPlayer) {
    inherit fetchurl stdenv freetype x11 zlib;
    inherit (xlibs) libXv;
    alsaSupport = true;
    alsa = alsaLib;
  };

  MPlayerPlugin = (import ../applications/networking/browsers/mozilla-plugins/mplayerplug-in) {
    inherit fetchurl stdenv pkgconfig firefox;
    inherit (xlibs) libXpm;
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

  zapping = (import ../applications/video/zapping) {
    inherit fetchurl stdenv pkgconfig perl python 
            scrollkeeper gettext zvbi libjpeg libpng x11
            rte perlXMLParser;
    inherit (gnome) libgnomeui libglade esound;
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

  hello = (import ../applications/misc/hello/ex-1) {
    inherit fetchurl stdenv perl;
  };

  xchm = (import ../applications/misc/xchm) {
    inherit fetchurl stdenv wxGTK chmlib;
  };

  acroread = (import ../applications/misc/acrobat-reader) {
    inherit fetchurl stdenv patchelf;
    inherit (xlibs) libXt libXp libXext libX11;
  };

  eclipse = (import ../applications/editors/eclipse) {
    inherit fetchurl stdenv unzip;
  };

  emacs = (import ../applications/editors/emacs) {
    inherit fetchurl stdenv xlibs;
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

  generator = (import ../games/generator) {
    inherit fetchurl stdenv SDL nasm;
    inherit (gtkLibs1x) gtk;
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

  nix = (import ../misc/nix) {
    inherit fetchurl stdenv aterm perl;
    curl = bootCurl; /* !!! ugly */
    bdb = db4;
  };

}
