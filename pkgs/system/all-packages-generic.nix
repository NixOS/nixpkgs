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

  wget = (import ../tools/networking/wget) {
    fetchurl = fetchurl;
    stdenv = stdenv;
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

  automake = (import ../development/tools/misc/automake) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    perl = perl;
    autoconf = autoconf;
  };

  pkgconfig = (import ../development/tools/misc/pkgconfig) {
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

  gnet = (import ../development/libraries/gnet) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    glib = glib;
  };

  libIDL = (import ../development/libraries/libIDL) {
    fetchurl = fetchurl;
    stdenv = stdenv;
    pkgconfig = pkgconfig;
    glib = glib;
    lex = flex;
    yacc = bison;
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

}
