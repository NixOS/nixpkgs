# This file evaluates to a function that, when supplied with a system
# identifier and a standard build environment, returns the set of all
# packages provided by the Nix Package Collection.

{stdenv, bootCurl, noSysDirs ? true}:

rec {

  inherit stdenv;


  ### Symbolic names.

  x11 = xlibs; # !!! should be `x11ClientLibs' or some such


  ### BUILD SUPPORT

  fetchurl = (import ../build-support/fetchurl) {
    inherit stdenv;
    curl = bootCurl;
  };

  fetchsvn = (import ../build-support/fetchsvn) {
    inherit stdenv subversion;
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
    inherit fetchurl stdenv;
  };

  gnupatch = (import ../tools/text/gnupatch) {
    inherit fetchurl stdenv;
  };

  gnused = (import ../tools/text/gnused) {
    inherit fetchurl stdenv;
  };

  gnugrep = (import ../tools/text/gnugrep) {
    inherit fetchurl stdenv pcre;
  };

  gawk = (import ../tools/text/gawk) {
    inherit fetchurl stdenv;
  };

  ed = (import ../tools/text/ed) {
    inherit fetchurl stdenv;
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
    inherit fetchurl stdenv wxPython;
  };

  graphviz = (import ../tools/graphics/graphviz) {
    inherit fetchurl stdenv libpng libjpeg expat x11;
  };


  ### SHELLS

  bash = (import ../shells/bash) {
    inherit fetchurl stdenv;
  };


  ### DEVELOPMENT

  binutils = (import ../development/tools/misc/binutils) {
    inherit fetchurl stdenv noSysDirs;
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

  libtool = (import ../development/tools/misc/libtool) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  pkgconfig = (import ../development/tools/misc/pkgconfig) {
    inherit fetchurl stdenv;
  };

  swig = (import ../development/tools/misc/swig) {
    inherit fetchurl stdenv perl python;
    perlSupport = true;
    pythonSupport = true;
  };

  valgrind = (import ../development/tools/misc/valgrind) {
    inherit fetchurl stdenv;
  };

  texinfo = (import ../development/tools/misc/texinfo) {
    inherit fetchurl stdenv ncurses;
  };

  gperf = (import ../development/tools/misc/gperf) {
    inherit fetchurl stdenv;
  };

  octavefront = (import ../development/tools/misc/octavefront) {
    inherit fetchurl stdenv autoconf g77 texinfo flex gperf rna aterm;
    bison = bisonnew;
  };

  gnumake = (import ../development/tools/build-managers/gnumake) {
    inherit fetchurl stdenv;
    patch = gnupatch;
  };

  bison = (import ../development/tools/parsing/bison) {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  bisonnew = (import ../development/tools/parsing/bison/bison-new.nix) {
    inherit fetchurl stdenv;
    m4 = gnum4;
  };

  flex = (import ../development/tools/parsing/flex) {
    inherit fetchurl stdenv;
    yacc = bison;
  };

  flexnew = (import ../development/tools/parsing/flex/flex-new.nix) {
    inherit fetchurl stdenv;
    yacc = bison;
    m4 = gnum4;
  };

  gcc = (import ../development/compilers/gcc) {
    inherit fetchurl stdenv noSysDirs;
  };

  g77 = (import ../build-support/gcc-wrapper) {
    name = "g77";
    nativeTools = false;
    nativeGlibc = false;
    gcc = (import ../development/compilers/gcc) {
      inherit fetchurl stdenv noSysDirs;
      langF77 = true;
      langCC = false;
    };
    binutils = stdenv.gcc.binutils;
    glibc = stdenv.gcc.glibc;
    inherit stdenv;
  };

  jikes = (import ../development/compilers/jikes) {
    inherit fetchurl stdenv;
  };

  j2sdk = (import ../development/compilers/j2sdk) {
    inherit fetchurl stdenv;
  };

  strategoxt = (import ../development/compilers/strategoxt) {
    inherit fetchurl stdenv aterm;
    sdf = sdf2;
  };

  strategoxtsvn = (import ../development/compilers/strategoxt/trunk.nix) {
    inherit fetchsvn stdenv autoconf automake libtool which aterm;
    sdf = sdf2;
  };

  strategoxt093 = (import ../development/compilers/strategoxt/strategoxt-0.9.3.nix) {
    inherit fetchurl stdenv aterm;
    sdf = sdf2;
  };

  strategoxt094 = (import ../development/compilers/strategoxt/strategoxt-0.9.4.nix) {
    inherit fetchurl stdenv aterm;
    sdf = sdf2;
  };

  strategoxt095 = (import ../development/compilers/strategoxt/strategoxt-0.9.5.nix) {
    inherit fetchurl stdenv aterm;
    sdf = sdf2;
  };

  tiger = (import ../development/compilers/tiger) {
    inherit fetchurl stdenv aterm strategoxt;
    sdf = sdf2;
  };

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

  perl = (import ../development/interpreters/perl) {
    inherit fetchurl stdenv;
    patch = gnupatch;
  };

  python = (import ../development/interpreters/python) {
    inherit fetchurl stdenv zlib;
  };

  j2re = (import ../development/interpreters/j2re) {
    inherit fetchurl stdenv;
  };

  apacheant = (import ../development/tools/build-managers/apache-ant) {
    inherit fetchurl stdenv j2sdk;
  };

  pcre = (import ../development/libraries/pcre) {
    inherit fetchurl stdenv;
  };

  glibc = (import ../development/libraries/glibc) {
    inherit fetchurl stdenv kernelHeaders;
    patch = gnupatch;
  };

  aterm = (import ../development/libraries/aterm) {
    inherit fetchurl stdenv;
  };

  sdf2 = (import ../development/tools/parsing/sdf2) {
    inherit fetchurl stdenv aterm getopt;
  };

  toolbuslib_0_5_1 = (import ../development/tools/parsing/toolbuslib/toolbuslib-0.5.1.nix) {
    inherit fetchurl stdenv aterm;
  };

  ptsupport_1_0 = (import ../development/tools/parsing/pt-support/pt-support-1.0.nix) {
    inherit fetchurl stdenv aterm;
    toolbuslib = toolbuslib_0_5_1;
  };

  sdfsupport_2_0 = (import ../development/tools/parsing/sdf-support/sdf-support-2.0.nix) {
    inherit fetchurl stdenv aterm;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
  };

  sglr_3_10_2 = (import ../development/tools/parsing/sglr/sglr-3.10.2.nix) {
    inherit fetchurl stdenv aterm;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
  };

  asfsupport_1_2 = (import ../development/tools/parsing/asf-support/asf-support-1.2.nix) {
    inherit fetchurl stdenv aterm;
    ptsupport = ptsupport_1_0;
  };

  ascsupport_1_8 = (import ../development/tools/parsing/asc-support/asc-support-1.8.nix) {
    inherit fetchurl stdenv aterm;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
    asfsupport	= asfsupport_1_2;
  };

  pgen_2_0 = (import ../development/tools/parsing/pgen/pgen-2.0.nix) {
    inherit fetchurl stdenv getopt aterm;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
    asfsupport = asfsupport_1_2;
    ascsupport = ascsupport_1_8;
    sdfsupport = sdfsupport_2_0;
    sglr = sglr_3_10_2;
  };

  expat = (import ../development/libraries/expat) {
    inherit fetchurl stdenv;
  };

  libxml2 = (import ../development/libraries/libxml2) {
    inherit fetchurl stdenv zlib;
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

  popt = (import ../development/libraries/popt) {
    inherit fetchurl stdenv gettext;
  };

  scrollkeeper = (import ../development/libraries/scrollkeeper) {
    inherit fetchurl stdenv perl libxml2 libxslt
            docbook_xml_dtd perlXMLParser;
  };

  glib = (import ../development/libraries/gtk+/glib) {
    inherit fetchurl stdenv pkgconfig gettext perl;
  };

  atk = (import ../development/libraries/gtk+/atk) {
    inherit fetchurl stdenv pkgconfig glib perl;
  };

  pango = (import ../development/libraries/gtk+/pango) {
    inherit fetchurl stdenv pkgconfig glib x11;
  };

  gtk = (import ../development/libraries/gtk+/gtk+) {
    inherit fetchurl stdenv pkgconfig glib atk pango perl
            libtiff libjpeg libpng x11;
  };

  glib1 = (import ../development/libraries/gtk+-1/glib) {
    inherit fetchurl stdenv;
  };

  gtk1 = (import ../development/libraries/gtk+-1/gtk+) {
    inherit fetchurl stdenv x11;
    glib = glib1;
  };

  gdkpixbuf = (import ../development/libraries/gtk+-1/gdk-pixbuf) {
    inherit fetchurl stdenv libtiff libjpeg libpng;
    gtk = gtk1;
  };

  audiofile = (import ../development/libraries/audiofile) {
    inherit fetchurl stdenv;
  };

  esound = (import ../development/libraries/gnome/esound) {
    inherit fetchurl stdenv audiofile;
  };

  libIDL = (import ../development/libraries/gnome/libIDL) {
    inherit fetchurl stdenv pkgconfig glib;
    lex = flex;
    yacc = bison;
  };

  ORBit2 = (import ../development/libraries/gnome/ORBit2) {
    inherit fetchurl stdenv pkgconfig glib libIDL popt;
  };

  GConf = (import ../development/libraries/gnome/GConf) {
    inherit fetchurl stdenv pkgconfig perl glib gtk libxml2 ORBit2 popt;
  };

  libbonobo = (import ../development/libraries/gnome/libbonobo) {
    inherit fetchurl stdenv pkgconfig perl ORBit2 libxml2 popt flex;
    yacc = bison;
  };

  gnomemimedata = (import ../development/libraries/gnome/gnome-mime-data) {
    inherit fetchurl stdenv pkgconfig perl;
  };

  gnomevfs = (import ../development/libraries/gnome/gnome-vfs) {
    inherit fetchurl stdenv pkgconfig perl glib libxml2 GConf
            libbonobo gnomemimedata popt bzip2;
    # !!! use stdenv.bzip2
  };

  libgnome = (import ../development/libraries/gnome/libgnome) {
    inherit fetchurl stdenv pkgconfig perl glib gnomevfs
            libbonobo GConf popt zlib;
  };

  libart_lgpl = (import ../development/libraries/gnome/libart_lgpl) {
    inherit fetchurl stdenv;
  };

  libglade = (import ../development/libraries/gnome/libglade) {
    inherit fetchurl stdenv pkgconfig gtk libxml2;
  };

  libgnomecanvas = (import ../development/libraries/gnome/libgnomecanvas) {
    inherit fetchurl stdenv pkgconfig gtk libglade;
    libart = libart_lgpl;
  };

  libbonoboui = (import ../development/libraries/gnome/libbonoboui) {
    inherit fetchurl stdenv pkgconfig perl libxml2 libglade
            libgnome libgnomecanvas;
  };

  libgnomeui = (import ../development/libraries/gnome/libgnomeui) {
    inherit fetchurl stdenv pkgconfig libgnome libgnomecanvas
            libbonoboui libglade;
  };

  wxGTK = (import ../development/libraries/wxGTK) {
    inherit fetchurl stdenv;
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
  };

  gnet = (import ../development/libraries/gnet) {
    inherit fetchurl stdenv pkgconfig glib;
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

  ncurses = (import ../development/libraries/ncurses) {
    inherit fetchurl stdenv;
  };

  rna = (import ../development/libraries/rna) {
    inherit fetchurl stdenv zlib;
  };

  xproto = (import ../development/libraries/freedesktop/xproto) {
    inherit fetchurl stdenv;
  };

  xextensions = (import ../development/libraries/freedesktop/xextensions) {
    inherit fetchurl stdenv;
  };

  libXtrans = (import ../development/libraries/freedesktop/libXtrans) {
    inherit fetchurl stdenv;
  };

  libXau = (import ../development/libraries/freedesktop/libXau) {
    inherit fetchurl stdenv pkgconfig xproto;
  };

  libX11 = (import ../development/libraries/freedesktop/libX11) {
    inherit fetchurl stdenv pkgconfig xproto xextensions libXtrans libXau;
  };

  libXext = (import ../development/libraries/freedesktop/libXext) {
    inherit fetchurl stdenv pkgconfig xproto xextensions libX11;
  };

  libICE = (import ../development/libraries/freedesktop/libICE) {
    inherit fetchurl stdenv pkgconfig libX11;
  };

  libSM = (import ../development/libraries/freedesktop/libSM) {
    inherit fetchurl stdenv pkgconfig libX11 libICE;
  };

  libXt = (import ../development/libraries/freedesktop/libXt) {
    inherit fetchurl stdenv pkgconfig libX11 libSM;
    patch = gnupatch;
  };

  renderext = (import ../development/libraries/freedesktop/renderext) {
    inherit fetchurl stdenv;
  };

  libXrender = (import ../development/libraries/freedesktop/libXrender) {
    inherit fetchurl stdenv pkgconfig libX11 renderext;
  };

  fontconfig = (import ../development/libraries/freedesktop/fontconfig) {
    inherit fetchurl stdenv freetype expat;
  };

  libXft = (import ../development/libraries/freedesktop/libXft) {
    inherit fetchurl stdenv pkgconfig libX11 libXrender freetype fontconfig;
  };

  libXmu = (import ../development/libraries/freedesktop/libXmu) {
    inherit fetchurl stdenv pkgconfig xproto libX11 libXt;
  };

  libXaw = (import ../development/libraries/freedesktop/libXaw) {
    inherit fetchurl stdenv pkgconfig xproto libX11 libXt;
  };

  xlibs = (import ../development/libraries/freedesktop/xlibs) {
    inherit stdenv libX11 libXt freetype fontconfig libXft libXext;
  };

  perlBerkeleyDB = (import ../development/perl-modules/BerkeleyDB) {
    inherit fetchurl stdenv perl db4;
  };

  perlXMLParser = (import ../development/perl-modules/XML-Parser) {
    inherit fetchurl stdenv perl expat;
  };

  wxPython = (import ../development/python-modules/wxPython) {
    inherit fetchurl stdenv wxGTK python;
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


  ### OS-SPECIFIC

  kernelHeaders = (import ../os-specific/linux/kernel-headers) {
    inherit fetchurl stdenv;
  };

  alsaLib = (import ../os-specific/linux/alsa/library) {
    inherit fetchurl stdenv;
  };

  utillinux = (import ../os-specific/linux/util-linux) {
    inherit fetchurl stdenv;
    patch = gnupatch;
  };

  sysvinit = (import ../os-specific/linux/sysvinit) {
    inherit fetchurl stdenv;
    patch = gnupatch;
  };

  e2fsprogs = (import ../os-specific/linux/e2fsprogs) {
    inherit fetchurl stdenv gettext;
  };

  nettools = (import ../os-specific/linux/net-tools) {
    inherit fetchurl stdenv;
  };


  ### DATA

  docbook_xml_dtd = (import ../data/sgml+xml/schemas/xml-dtd/docbook) {
    inherit fetchurl stdenv unzip;
  };

  docbook_xml_xslt = (import ../data/sgml+xml/stylesheets/xslt/docbook) {
    inherit fetchurl stdenv;
  };


  ### APPLICATIONS

  subversion = (import ../applications/version-management/subversion) {
    inherit fetchurl stdenv openssl db4 expat swig;
    localServer = true;
    httpServer = false;
    sslSupport = true;
    swigBindings = false;
    httpd = apacheHttpd;
  };

  pan = (import ../applications/networking/newsreaders/pan) {
    inherit fetchurl stdenv pkgconfig gtk gnet libxml2 perl pcre;
    spellChecking = false;
  };

  sylpheed = (import ../applications/networking/mailreaders/sylpheed) {
    inherit fetchurl stdenv openssl gdkpixbuf;
    sslSupport = true;
    imageSupport = true;
    gtk = gtk1;
  };

  firefox = (import ../applications/networking/browsers/firefox) {
    inherit fetchurl stdenv pkgconfig gtk perl zip libIDL;
  };

  MPlayer = (import ../applications/video/MPlayer) {
    inherit fetchurl stdenv freetype x11;
    alsaSupport = true;
    alsa = alsaLib;
  };

  MPlayerPlugin = (import ../applications/video/mplayerplug-in) {
    inherit fetchurl stdenv x11;
  };

  vlc = (import ../applications/video/vlc) {
    inherit fetchurl stdenv wxGTK libdvdcss libdvdplay
            mpeg2dec a52dec libmad x11;
    alsa = alsaLib;
  };

  zapping = (import ../applications/video/zapping) {
    inherit fetchurl stdenv pkgconfig perl python libgnomeui libglade
            scrollkeeper esound gettext zvbi libjpeg libpng x11;
    teletextSupport = true;
    jpegSupport = true;
    pngSupport = true;
  };

  gqview = (import ../applications/graphics/gqview) {
    inherit fetchurl stdenv pkgconfig gtk libpng;
  };

  hello = (import ../applications/misc/hello) {
    inherit fetchurl stdenv perl;
  };

  nxml = (import ../applications/editors/emacs/modes/nxml) {
    inherit fetchurl stdenv;
  };


  ### MISC

  uml = (import ../misc/uml) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
    patch = gnupatch;
  };

  umlutilities = (import ../misc/uml-utilities) {
    inherit fetchurl stdenv;
  };

  nix = (import ../misc/nix) {
    inherit fetchurl stdenv aterm perl;
    bdb = db4;
  };

}
