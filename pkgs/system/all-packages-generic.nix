# This file evaluates to a function that, when supplied with a system
# identifier and a standard build environment, returns the set of all
# packages provided by the Nix Package Collection.

{system, stdenv}: rec {

  # Hack: remember stdenv.
  stdenv_ = stdenv;


  ### BUILD SUPPORT

  fetchurl = (import ../build-support/fetchurl) {
    stdenv = stdenv;
  };

  fetchsvn = (import ../build-support/fetchsvn) {
    stdenv = stdenv;
    subversion = subversion;
  };


  ### TOOLS

  coreutils = (import ../tools/misc/coreutils) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  findutils = (import ../tools/misc/findutils) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  getopt = (import ../tools/misc/getopt) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  diffutils = (import ../tools/text/diffutils) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gnused = (import ../tools/text/gnused) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gnugrep = (import ../tools/text/gnugrep) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pcre = pcre;
  };

  gawk = (import ../tools/text/gawk) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  ed = (import ../tools/text/ed) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gnutar = (import ../tools/archivers/gnutar) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  zip = (import ../tools/archivers/zip) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  unzip = (import ../tools/archivers/unzip) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gzip = (import ../tools/compression/gzip) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  bzip2 = (import ../tools/compression/bzip2) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  which = (import ../tools/system/which) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  wget = (import ../tools/networking/wget) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  par2cmdline = (import ../tools/networking/par2cmdline) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  graphviz = (import ../tools/graphics/graphviz) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    x11 = xfree86;
    libpng = libpng;
    libjpeg = libjpeg;
    expat = expat;
  };


  ### SHELLS

  bash = (import ../shells/bash) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };


  ### DEVELOPMENT

  binutils = (import ../development/tools/misc/binutils) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gnum4 = (import ../development/tools/misc/gnum4) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  autoconf = (import ../development/tools/misc/autoconf) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    m4 = gnum4;
    perl = perl;
  };

  autoconflibtool = (import ../development/tools/misc/autoconf/autoconf-libtool.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    m4 = gnum4;
    perl = perl;
  };

  automake = (import ../development/tools/misc/automake) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
    autoconf = autoconf;
  };

  libtool = (import ../development/tools/misc/libtool) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    m4 = gnum4;
    perl = perl;
  };

  autotools = {
    automake = autoconflibtool;
    autoconf = autoconflibtool;
    make     = gnumake;
    libtool  = autoconflibtool;
  };

  pkgconfig = (import ../development/tools/misc/pkgconfig) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  swig = (import ../development/tools/misc/swig) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perlSupport = true;
    pythonSupport = true;
    perl = perl;
    python = python;
  };

  valgrind = (import ../development/tools/misc/valgrind) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gnumake = (import ../development/tools/build-managers/gnumake) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  bison = (import ../development/tools/parsing/bison) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    m4 = gnum4;
  };

  flex = (import ../development/tools/parsing/flex) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    yacc = bison;
  };

  gcc = (import ../development/compilers/gcc) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    binutils = binutils;
  };

  perl = (import ../development/interpreters/perl) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  python = (import ../development/interpreters/python) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  python = (import ../development/interpreters/python) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  j2re = (import ../development/interpreters/j2re) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  jikes = (import ../development/compilers/jikes) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  j2sdk = (import ../development/compilers/j2sdk) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  apacheant = (import ../development/tools/build-managers/apache-ant) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    j2sdk = j2sdk;
  };

  pcre = (import ../development/libraries/pcre) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  glibc = (import ../development/libraries/glibc) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    kernelHeaders = kernelHeaders;
  };

  aterm = (import ../development/libraries/aterm) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  aterm_2_0_5 = (import ../development/libraries/aterm/aterm-2.0.5.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  sdf2 = (import ../development/tools/parsing/sdf2) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm;
    getopt = getopt;
  };

  toolbuslib_0_5_1 = (import ../development/tools/parsing/toolbuslib/toolbuslib-0.5.1.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm_2_0_5;
  };

  ptsupport_1_0 = (import ../development/tools/parsing/pt-support/pt-support-1.0.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
  };

  sdfsupport_2_0 = (import ../development/tools/parsing/sdf-support/sdf-support-2.0.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
  };

  sglr_3_10_2 = (import ../development/tools/parsing/sglr/sglr-3.10.2.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
  };

  asfsupport_1_2 = (import ../development/tools/parsing/asf-support/asf-support-1.2.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm_2_0_5;
    ptsupport = ptsupport_1_0;
  };

  ascsupport_1_8 = (import ../development/tools/parsing/asc-support/asc-support-1.8.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
    asfsupport	= asfsupport_1_2;
  };

  pgen_2_0 = (import ../development/tools/parsing/pgen/pgen-2.0.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    getopt = getopt;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
    asfsupport = asfsupport_1_2;
    ascsupport = ascsupport_1_8;
    sdfsupport = sdfsupport_2_0;
    sglr = sglr_3_10_2;
  };

  strategoxt = (import ../development/compilers/strategoxt) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm;
    sdf = sdf2;
  };

  strategoxtsvn = (import ../development/compilers/strategoxt/trunk.nix) {
    fetchsvn = fetchsvn;
    stdenv = stdenv;
    autotools = autotools;
    which = which;
    aterm = aterm;
    sdf = sdf2;
  };

  strategoxt093 = (import ../development/compilers/strategoxt/strategoxt-0.9.3.nix) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm;
    sdf = sdf2;
  };

  tiger = (import ../development/compilers/tiger) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    aterm = aterm;
    sdf = sdf2;
    strategoxt = strategoxt;
  };

  expat = (import ../development/libraries/expat) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  libxml2 = (import ../development/libraries/libxml2) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    zlib = zlib;
  };

  libxslt = (import ../development/libraries/libxslt) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    libxml2 = libxml2;
  };

  gettext = (import ../development/libraries/gettext) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  db4 = (import ../development/libraries/db4) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  openssl = (import ../development/libraries/openssl) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
  };

  freetype = (import ../development/libraries/freetype) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  fontconfig = (import ../development/libraries/fontconfig) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    x11 = xfree86;
    freetype = freetype;
    expat = expat;
    ed = ed;
  };

  xft = (import ../development/libraries/xft) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    x11 = xfree86;
    fontconfig = fontconfig;
  };

  zlib = (import ../development/libraries/zlib) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  libjpeg = (import ../development/libraries/libjpeg) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  libtiff = (import ../development/libraries/libtiff) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    zlib = zlib;
    libjpeg = libjpeg;
  };

  libpng = (import ../development/libraries/libpng) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    zlib = zlib;
  };

  popt = (import ../development/libraries/popt) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    gettext = gettext; 
  };

  scrollkeeper = (import ../development/libraries/scrollkeeper) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
    libxml2 = libxml2;
    libxslt = libxslt;
    docbook_xml_dtd = docbook_xml_dtd;
    perlXMLParser = perlXMLParser;
  };

  glib = (import ../development/libraries/gtk+/glib) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gettext = gettext; 
    perl = perl;
  };

  atk = (import ../development/libraries/gtk+/atk) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    glib = glib; 
    perl = perl;
  };

  pango = (import ../development/libraries/gtk+/pango) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    x11 = xfree86;
    glib = glib;
    xft = xft;
  };

  gtk = (import ../development/libraries/gtk+/gtk+) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    x11 = xfree86;
    glib = glib;
    atk = atk;
    pango = pango;
    perl = perl;
    libtiff = libtiff;
    libjpeg = libjpeg;
    libpng = libpng;
  };

  glib1 = (import ../development/libraries/gtk+-1/glib) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  gtk1 = (import ../development/libraries/gtk+-1/gtk+) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    x11 = xfree86;
    glib = glib1;
  };

  gdkpixbuf = (import ../development/libraries/gtk+-1/gdk-pixbuf) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    gtk = gtk1;
    libtiff = libtiff;
    libjpeg = libjpeg;
    libpng = libpng;
  };

  audiofile = (import ../development/libraries/audiofile) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  esound = (import ../development/libraries/gnome/esound) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    audiofile = audiofile;
  };

  libIDL = (import ../development/libraries/gnome/libIDL) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    glib = glib;
    lex = flex;
    yacc = bison;
  };

  ORBit2 = (import ../development/libraries/gnome/ORBit2) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    glib = glib;
    libIDL = libIDL;
    popt = popt;
  };

  GConf = (import ../development/libraries/gnome/GConf) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
    glib = glib;
    gtk = gtk;
    libxml2 = libxml2;
    ORBit2 = ORBit2;
    popt = popt;
  };

  libbonobo = (import ../development/libraries/gnome/libbonobo) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
    ORBit2 = ORBit2;
    libxml2 = libxml2;
    popt = popt;
    yacc = bison;
    flex = flex;
  };

  gnomemimedata = (import ../development/libraries/gnome/gnome-mime-data) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
  };

  gnomevfs = (import ../development/libraries/gnome/gnome-vfs) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
    glib = glib;
    libxml2 = libxml2;
    GConf = GConf;
    libbonobo = libbonobo;
    gnomemimedata = gnomemimedata;
    popt = popt;
    bzip2 = bzip2; # !!! use stdenv.bzip2
  };

  libgnome = (import ../development/libraries/gnome/libgnome) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
    glib = glib;
    gnomevfs = gnomevfs;
    libbonobo = libbonobo;
    GConf = GConf;
    popt = popt;
    zlib = zlib;
  };

  libart_lgpl = (import ../development/libraries/gnome/libart_lgpl) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  libglade = (import ../development/libraries/gnome/libglade) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
    libxml2 = libxml2;
  };

  libgnomecanvas = (import ../development/libraries/gnome/libgnomecanvas) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
    libart = libart_lgpl;
    libglade = libglade;
  };

  libbonoboui = (import ../development/libraries/gnome/libbonoboui) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
    libxml2 = libxml2;
    libglade = libglade;
    libgnome = libgnome;
    libgnomecanvas = libgnomecanvas;
  };

  libgnomeui = (import ../development/libraries/gnome/libgnomeui) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    libgnome = libgnome;
    libgnomecanvas = libgnomecanvas;
    libbonoboui = libbonoboui;
    libglade = libglade;
  };

  wxGTK = (import ../development/libraries/wxGTK) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
  };

  gnet = (import ../development/libraries/gnet) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    glib = glib;
  };

  libdvdcss = (import ../development/libraries/libdvdcss) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  libdvdread = (import ../development/libraries/libdvdread) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    libdvdcss = libdvdcss;
  };

  libdvdplay = (import ../development/libraries/libdvdplay) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    libdvdread = libdvdread;
  };

  mpeg2dec = (import ../development/libraries/mpeg2dec) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  a52dec = (import ../development/libraries/a52dec) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  libmad = (import ../development/libraries/libmad) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  perlBerkeleyDB = (import ../development/perl-modules/BerkeleyDB) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
    db4 = db4;
  };

  perlXMLParser = (import ../development/perl-modules/XML-Parser) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
    expat = expat;
  };


  ### SERVERS

  apacheHttpd = (import ../servers/http/apache-httpd) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    sslSupport = true;
    db4Support = true;
    perl = perl;
    openssl = openssl;
    db4 = db4;
    expat = expat;
  };

  xfree86 = (import ../servers/x11/xfree86) {
    buildServer = false;
    buildClientLibs = true;
    fetchurl = fetchurl;
    stdenv = stdenv;
    flex = flex;
    bison = bison;
  };


  ### OS-SPECIFIC

  kernelHeaders = (import ../os-specific/linux/kernel-headers) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

  alsaLib = (import ../os-specific/linux/alsa/library) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };


  ### DATA

  docbook_xml_dtd = (import ../data/sgml+xml/schemas/xml-dtd/docbook) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    unzip = unzip;
  };

  docbook_xml_xslt = (import ../data/sgml+xml/stylesheets/xslt/docbook) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };


  ### APPLICATIONS

  subversion = (import ../applications/version-management/subversion) {
    localServer = true;
    httpServer = false;
    sslSupport = true;
    swigBindings = false;
    fetchurl = fetchurl;
    stdenv = stdenv;
    openssl = openssl;
    httpd = apacheHttpd;
    db4 = db4;
    expat = expat;
    swig = swig;
  };

  pan = (import ../applications/networking/newsreaders/pan) {
    spellChecking = false;
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
    gnet = gnet;
    libxml2 = libxml2;
    perl = perl;
    pcre = pcre;
  };

  sylpheed = (import ../applications/networking/mailreaders/sylpheed) {
    sslSupport = true;
    imageSupport = true;
    fetchurl = fetchurl;
    stdenv = stdenv;
    gtk = gtk1;
    openssl = openssl;
    gdkpixbuf = gdkpixbuf;
  };

  firebird = (import ../applications/networking/browsers/firebird) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
    perl = perl;
    zip = zip;
    libIDL = libIDL;
  };

  MPlayer = (import ../applications/video/MPlayer) {
    alsaSupport = true;
    fetchurl = fetchurl;
    stdenv = stdenv;
    x11 = xfree86;
    freetype = freetype;
    alsa = alsaLib;
  };

  MPlayerPlugin = (import ../applications/video/mplayerplug-in) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    x11 = xfree86;
  };

  vlc = (import ../applications/video/vlc) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    x11 = xfree86;
    wxGTK = wxGTK;
    libdvdcss = libdvdcss;
    libdvdplay = libdvdplay;
    mpeg2dec = mpeg2dec;
    a52dec = a52dec;
    libmad = libmad;
    alsa = alsaLib;
  };

  zapping = (import ../applications/video/zapping) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    perl = perl;
    python = python;
    x11 = xfree86;
    libgnomeui = libgnomeui;
    libglade = libglade;
    scrollkeeper = scrollkeeper;
    esound = esound;
    gettext = gettext;
  };

  gqview = (import ../applications/graphics/gqview) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    gtk = gtk;
    libpng = libpng;
  };

  hello = (import ../applications/misc/hello) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
  };

  nxml = (import ../applications/editors/emacs/modes/nxml) {
    fetchurl = fetchurl;
    stdenv = stdenv;
  };

}
