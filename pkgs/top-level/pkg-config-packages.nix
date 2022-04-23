/* A set of aliases to be used in generated expressions.

   In case of ambiguity, this will pick a sensible default.

   This was initially based on cabal2nix's mapping.

   It'd be nice to generate this mapping, based on a set of derivations.
   It can not be fully automated, so it should be a expression or tool
   that makes suggestions about which pkg-config module names can be added.
 */
pkgs: {
  inherit (pkgs)
    bzip2
    freealut
    libb2
    libsass
    taglib
    zlib
    ;
  alsa = pkgs.alsa-lib;
  alsa-topology = pkgs.alsa-lib;
  "appindicator-0.1" = pkgs.libappindicator-gtk2;
  "appindicator3-0.1" = pkgs.libappindicator-gtk3;
  cairo-gobject = pkgs.cairo;
  cairo-pdf = pkgs.cairo;
  cairo-ps = pkgs.cairo;
  cairo-svg = pkgs.cairo;

  "ncurses++" = pkgs.ncurses;
  "ncurses++w" = pkgs.ncurses;
  form = pkgs.ncurses;
  formw = pkgs.ncurses;
  menu = pkgs.ncurses;
  menuw = pkgs.ncurses;
  ncurses = pkgs.ncurses;
  ncursesw = pkgs.ncurses;
  panel = pkgs.ncurses;
  panelw = pkgs.ncurses;

  "dbusmenu-glib-0.4" = pkgs.libdbusmenu;
  "dbusmenu-gtk3-0.4" = pkgs.libdbusmenu-gtk3; # TODO: also needs gtk3. Use build propagation?
  fftw3 = pkgs.fftw;
  fftw3f = pkgs.fftwFloat;
  freetype2 = pkgs.freetype;
  "gdk-2.0" = pkgs.gtk2;
  "gdk-3.0" = pkgs.gtk3;
  "gdk-pixbuf-2.0" = pkgs.gdk-pixbuf;
  "gdk-x11-2.0" = pkgs.gtk2-x11;
  "gdk-x11-3.0" = pkgs.gtk3-x11;
  geos = pkgs.geos;
  "gio-2.0" = pkgs.glib;
  gl = pkgs.libGL;
  glew = pkgs.glew;
  glu = pkgs.libGLU;
  glut = pkgs.freeglut;
  gnome-keyring-1 = pkgs.libgnome-keyring;
  "gnome-vfs-2.0" = pkgs.gnome2.gnome_vfs;
  "gnome-vfs-module-2.0" = pkgs.gnome2.gnome_vfs;
  "gobject-2.0" = pkgs.glib;
  "gobject-introspection-1.0" = pkgs.gobject-introspection;
  "gstreamer-audio-1.0" = pkgs.gst_all_1.gst-plugins-base;
  "gstreamer-base-1.0" = pkgs.gst_all_1.gst-plugins-base;
  "gstreamer-controller-1.0" = pkgs.gst_all_1.gstreamer;
  "gstreamer-net-1.0" = pkgs.gst_all_1.gst-plugins-base;
  "gstreamer-video-1.0" = pkgs.gst_all_1.gst-plugins-base;
  "gthread-2.0" = pkgs.glib;
  "gtk+-2.0" = pkgs.gtk2;
  "gtk+-3.0" = pkgs.gtk3;
  "gtk+-x11-2.0" = pkgs.gtk2-x11;
  "gtksourceview-3.0" = pkgs.gtksourceview3;
  hidapi-libusb = pkgs.hidapi;
  icu-i18n = pkgs.icu;
  icu-uc = pkgs.icu;
  icu-io = pkgs.icu;
  libidn = pkgs.libidn;
  IL = pkgs.libdevil;
  ImageMagick = pkgs.imagemagick;
  imlib2 = pkgs.imlib2;
  jack = pkgs.libjack2;
  "javascriptcoregtk-4.0" = pkgs.webkitgtk;
  libjpeg = pkgs.libjpeg;
  libturbojpeg = pkgs.libjpeg;
  lapack = pkgs.liblapack;
  libavutil = pkgs.ffmpeg;
  libbrotlienc = pkgs.brotli;
  libbrotlidec = pkgs.brotli;
  libgsasl = pkgs.gsasl;
  libpcre = pkgs.pcre;
  libpcre2-8 = pkgs.pcre2;
  libpcre2-16 = pkgs.pcre2;
  libpcre2-32 = pkgs.pcre2;
  libpcre2-posix = pkgs.pcre2;
  libqrencode = pkgs.qrencode;
  libR = pkgs.R;
  libsecp256k1 = pkgs.secp256k1;
  "libsoup-gnome-2.4" = pkgs.libsoup;
  libsystemd = pkgs.systemd;
  libudev = pkgs.systemd;
  "libxml-2.0" = pkgs.libxml2;
  libzip = pkgs.libzip;
  libzmq = pkgs.zeromq;
  liblzma = pkgs.xz;
  m = null; # in stdenv
  libmagic = pkgs.file;
  MagickWand = pkgs.imagemagick;
  libmnl = pkgs.libmnl;

  ompi = pkgs.openmpi;
  ompi-c = pkgs.openmpi;
  ompi-cxx = pkgs.openmpi;
  ompi-fort = pkgs.openmpi;
  ompi-f77 = pkgs.openmpi;
  ompi-f90 = pkgs.openmpi;
  orte = pkgs.openmpi;

  netsnmp = pkgs.net_snmp;
  nix-cmd = pkgs.nix;
  nix-expr = pkgs.nix;
  nix-main = pkgs.nix;
  nix-store = pkgs.nix;
  libnotify = pkgs.libnotify;
  odbc = pkgs.unixODBC;
  openblas = pkgs.openblasCompat;
  pangocairo = pkgs.pango;
  libpcap = pkgs.libpcap;
  libpng = pkgs.libpng;
  poppler-glib = pkgs.poppler_gi;
  libpq = pkgs.postgresql;
  libpgtypes = pkgs.postgresql;
  libecpg = pkgs.postgresql;
  libecpg_compat = pkgs.postgresql;
  pthread = null; # in stdenv
  libpulse = pkgs.libpulseaudio;
  libpulse-simple = pkgs.libpulseaudio;
  libpulse-mainloop-glib = pkgs.libpulseaudio;
  python = pkgs.python3;

  Qt5Concurrent = pkgs.qt5.qtbase;
  Qt5Core = pkgs.qt5.qtbase;
  Qt5DBus = pkgs.qt5.qtbase;
  Qt5Gui = pkgs.qt5.qtbase;
  Qt5Network = pkgs.qt5.qtbase;
  Qt5OpenGL = pkgs.qt5.qtbase;
  Qt5OpenGLExtensions = pkgs.qt5.qtbase;
  Qt5PrintSupport = pkgs.qt5.qtbase;
  Qt5Sql = pkgs.qt5.qtbase;
  Qt5Test = pkgs.qt5.qtbase;
  Qt5Widgets = pkgs.qt5.qtbase;
  Qt5Xml = pkgs.qt5.qtbase;

  Qt5Qml = pkgs.qt5.qtdeclarative;
  Qt5QmlModels = pkgs.qt5.qtdeclarative;
  Qt5Quick = pkgs.qt5.qtdeclarative;
  Qt5QuickTest = pkgs.qt5.qtdeclarative;
  Qt5QuickWidgets = pkgs.qt5.qtdeclarative;

  librtlsdr = pkgs.rtl-sdr;
  "ruby-2.7" = pkgs.ruby_2_7;
  "ruby-3.0" = pkgs.ruby_3_0;
  "ruby-3.1" = pkgs.ruby_3_1;
  libsctp = pkgs.lksctp-tools; # This is linux-specific, we should create a common attribute if we add sctp support for other systems.
  sdl2 = pkgs.SDL2;
  sndfile = pkgs.libsndfile;
  SoapySDR = pkgs.soapysdr;
  libsodium = pkgs.libsodium;
  sqlite3 = pkgs.sqlite;
  libssh2 = pkgs.libssh2;
  openssl = pkgs.openssl;
  libssl = pkgs.openssl;
  libcrypto = pkgs.openssl;
  libstatgrab = pkgs.libstatgrab;
  taglib_c = pkgs.taglib;
  tdjson = pkgs.tdlib;
  tensorflow = pkgs.libtensorflow;
  uuid = pkgs.libossp_uuid;
  "vte-2.91" = pkgs.vte;
  wayland-client = pkgs.wayland;
  wayland-cursor = pkgs.wayland;
  egl = pkgs.libGL;
  wayland-server = pkgs.wayland;
  "webkit2gtk-4.0" = pkgs.webkitgtk;
  "webkit2gtk-web-extension-4.0" = pkgs.webkitgtk;
  x11 = pkgs.xorg.libX11;
  xau = pkgs.xorg.libXau;
  xcursor = pkgs.xorg.libXcursor;
  xerces-c = pkgs.xercesc;
  xext = pkgs.xorg.libXext;
  xft = pkgs.xorg.libXft;
  xi = pkgs.xorg.libXi;
  xinerama = pkgs.xorg.libXinerama;
  xkbcommon = pkgs.libxkbcommon;
  xpm = pkgs.xorg.libXpm;
  xrandr = pkgs.xorg.libXrandr;
  xrender = pkgs.xorg.libXrender;
  xscrnsaver = pkgs.xorg.libXScrnSaver;
  xtst = pkgs.xorg.libXtst;
  xxf86vm = pkgs.xorg.libXxf86vm;
  "yaml-0.1" = pkgs.libyaml;
}
