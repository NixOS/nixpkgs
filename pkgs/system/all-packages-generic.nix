# This file evaluates to a function that, when supplied with a system
# identifier and a standard build environment, returns the set of all
# packages provided by the Nix Package Collection.

{system, stdenv}: rec {

  inherit stdenv;


  ### BUILD SUPPORT

  fetchurl = (import ../build-support/fetchurl) {
    inherit stdenv;
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

  par2cmdline = (import ../tools/networking/par2cmdline) {
    inherit fetchurl stdenv;
  };

  cksfv = (import ../tools/networking/cksfv) {
    inherit fetchurl stdenv;
  };

  graphviz = (import ../tools/graphics/graphviz) {
    inherit fetchurl stdenv libpng libjpeg expat;
    x11 = xfree86;
  };


  ### SHELLS

  bash = (import ../shells/bash) {
    inherit fetchurl stdenv;
  };


  ### DEVELOPMENT

  binutils = (import ../development/tools/misc/binutils) {
    inherit fetchurl stdenv;
  };

  gnum4 = (import ../development/tools/misc/gnum4) {
    inherit fetchurl stdenv;
  };

  autoconf = (import ../development/tools/misc/autoconf) {
    inherit fetchurl stdenv perl;
    m4 = gnum4;
  };

  autoconflibtool = (import ../development/tools/misc/autoconf/autoconf-libtool.nix) {
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

  autotools = {
    automake = autoconflibtool;
    autoconf = autoconflibtool;
    make     = gnumake;
    libtool  = autoconflibtool;
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

  gnumake = (import ../development/tools/build-managers/gnumake) {
    inherit fetchurl stdenv;
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
    inherit fetchurl stdenv binutils;
  };

  perl = (import ../development/interpreters/perl) {
    inherit fetchurl stdenv;
  };

  python = (import ../development/interpreters/python) {
    inherit fetchurl stdenv;
  };

  python = (import ../development/interpreters/python) {
    inherit fetchurl stdenv;
  };

  j2re = (import ../development/interpreters/j2re) {
    inherit fetchurl stdenv;
  };

  jikes = (import ../development/compilers/jikes) {
    inherit fetchurl stdenv;
  };

  j2sdk = (import ../development/compilers/j2sdk) {
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
  };

  aterm = (import ../development/libraries/aterm) {
    inherit fetchurl stdenv;
  };

  aterm_2_0_5 = (import ../development/libraries/aterm/aterm-2.0.5.nix) {
    inherit fetchurl stdenv;
  };

  sdf2 = (import ../development/tools/parsing/sdf2) {
    inherit fetchurl stdenv aterm getopt;
  };

  toolbuslib_0_5_1 = (import ../development/tools/parsing/toolbuslib/toolbuslib-0.5.1.nix) {
    inherit fetchurl stdenv;
    aterm = aterm_2_0_5;
  };

  ptsupport_1_0 = (import ../development/tools/parsing/pt-support/pt-support-1.0.nix) {
    inherit fetchurl stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
  };

  sdfsupport_2_0 = (import ../development/tools/parsing/sdf-support/sdf-support-2.0.nix) {
    inherit fetchurl stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
  };

  sglr_3_10_2 = (import ../development/tools/parsing/sglr/sglr-3.10.2.nix) {
    inherit fetchurl stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
  };

  asfsupport_1_2 = (import ../development/tools/parsing/asf-support/asf-support-1.2.nix) {
    inherit fetchurl stdenv;
    aterm = aterm_2_0_5;
    ptsupport = ptsupport_1_0;
  };

  ascsupport_1_8 = (import ../development/tools/parsing/asc-support/asc-support-1.8.nix) {
    inherit fetchurl stdenv;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
    asfsupport	= asfsupport_1_2;
  };

  pgen_2_0 = (import ../development/tools/parsing/pgen/pgen-2.0.nix) {
    inherit fetchurl stdenv getopt;
    aterm = aterm_2_0_5;
    toolbuslib = toolbuslib_0_5_1;
    ptsupport = ptsupport_1_0;
    asfsupport = asfsupport_1_2;
    ascsupport = ascsupport_1_8;
    sdfsupport = sdfsupport_2_0;
    sglr = sglr_3_10_2;
  };

  strategoxt = (import ../development/compilers/strategoxt) {
    inherit fetchurl stdenv aterm;
    sdf = sdf2;
  };

  strategoxtsvn = (import ../development/compilers/strategoxt/trunk.nix) {
    inherit fetchsvn stdenv autotools which aterm;
    sdf = sdf2;
  };

  strategoxt093 = (import ../development/compilers/strategoxt/strategoxt-0.9.3.nix) {
    inherit fetchurl stdenv aterm;
    sdf = sdf2;
  };

  tiger = (import ../development/compilers/tiger) {
    inherit fetchurl stdenv aterm strategoxt;
    sdf = sdf2;
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

  libxml2_265 = (import ../development/libraries/libxml2/libxml2-2.6.5.nix) {
    inherit fetchurl stdenv zlib;
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

  fontconfig = (import ../development/libraries/fontconfig) {
    inherit fetchurl stdenv freetype expat ed;
    x11 = xfree86;
  };

  xft = (import ../development/libraries/xft) {
    inherit fetchurl stdenv pkgconfig fontconfig;
    x11 = xfree86;
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
    inherit fetchurl stdenv pkgconfig glib xft;
    x11 = xfree86;
  };

  gtk = (import ../development/libraries/gtk+/gtk+) {
    inherit fetchurl stdenv pkgconfig glib atk pango perl
            libtiff libjpeg libpng;
    x11 = xfree86;
  };

  glib1 = (import ../development/libraries/gtk+-1/glib) {
    inherit fetchurl stdenv;
  };

  gtk1 = (import ../development/libraries/gtk+-1/gtk+) {
    inherit fetchurl stdenv;
    x11 = xfree86;
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
    inherit fetchurl stdenv libpng;
    pngSupport = true;
    x11 = xfree86;
    libpng = libpng;
  };

  perlBerkeleyDB = (import ../development/perl-modules/BerkeleyDB) {
    inherit fetchurl stdenv perl db4;
  };

  perlXMLParser = (import ../development/perl-modules/XML-Parser) {
    inherit fetchurl stdenv perl expat;
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
    inherit fetchurl stdenv freetype;
    alsaSupport = true;
    x11 = xfree86;
    alsa = alsaLib;
  };

  MPlayerPlugin = (import ../applications/video/mplayerplug-in) {
    inherit fetchurl stdenv;
    x11 = xfree86;
  };

  vlc = (import ../applications/video/vlc) {
    inherit fetchurl stdenv wxGTK libdvdcss libdvdplay
            mpeg2dec a52dec libmad;
    x11 = xfree86;
    alsa = alsaLib;
  };

  zapping = (import ../applications/video/zapping) {
    inherit fetchurl stdenv pkgconfig perl python libgnomeui libglade
            scrollkeeper esound gettext zvbi libjpeg libpng;
    x11 = xfree86;
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

}
