self:

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false then
      removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias: removeDistribute (removeRecurseForDerivations alias)) aliases;
in

  ### Deprecated aliases - for backward compatibility

mapAliases (rec {
  accounts-qt = libsForQt5.accounts-qt;
  adobeReader = adobe-reader;
  aircrackng = aircrack-ng;
  ammonite-repl = ammonite;
  arduino_core = arduino-core;
  asciidocFull = asciidoc-full;
  bar = lemonbar;
  bar-xft = lemonbar-xft;
  bashCompletion = bash-completion;
  bridge_utils = bridge-utils;
  btrfsProgs = btrfs-progs;
  bundler_HEAD = bundler;
  checkbashism = checkbashisms;
  cifs_utils = cifs-utils;
  clangAnalyzer = clang-analyzer;
  clawsMail = claws-mail;
  conkerorWrapper = conkeror;
  cool-old-term = cool-retro-term;
  cupsBjnp = cups-bjnp;
  cups_filters = cups-filters;
  cv = progress;
  debian_devscripts = debian-devscripts;
  digikam5 = digikam;
  double_conversion = double-conversion;
  dwarf_fortress = dwarf-fortress;
  dwbWrapper = dwb;
  enblendenfuse = enblend-enfuse;
  exfat-utils = exfat;
  firefox-esr-wrapper = firefox-esr;
  firefox-wrapper = firefox;
  firefoxWrapper = firefox;
  foomatic_filters = foomatic-filters;
  fuse_exfat = exfat;
  gettextWithExpat = gettext;
  gdb-multitarget = gdb;
  git-hub = gitAndTools.git-hub;
  go-pup = pup;
  googleAuthenticator = google-authenticator;
  grantlee5 = libsForQt5.grantlee;
  gst_ffmpeg = gst-ffmpeg;
  gst_plugins_base = gst-plugins-base;
  gst_plugins_good = gst-plugins-good;
  gst_plugins_bad = gst-plugins-bad;
  gst_plugins_ugly = gst-plugins-ugly;
  gst_python = gst-python;
  guileCairo = guile-cairo;
  guileGnome = guile-gnome;
  guile_lib = guile-lib;
  guileLint = guile-lint;
  guile_ncurses = guile-ncurses;
  gupnptools = gupnp-tools;
  gnustep-make = gnustep.make;
  htmlTidy = html-tidy;
  iana_etc = iana-etc;
  idea = jetbrains;
  inotifyTools = inotify-tools;
  joseki = apache-jena-fuseki;
  jquery_ui = jquery-ui;
  kdiff3-qt5 = kdiff3;
  keepassx2-http = keepassx-reboot;
  keepassx-reboot = keepassx-community;
  keepassx-community = keepassxc;
  keybase-go = keybase;
  krename-qt5 = krename;
  letsencrypt = certbot;
  libdbusmenu_qt5 = libsForQt5.libdbusmenu;
  libcap_manpages = libcap.doc;
  libcap_pam = if stdenv.isLinux then libcap.pam else null;
  libcap_progs = libcap.out;
  libgumbo = gumbo;
  libjson_rpc_cpp = libjson-rpc-cpp;
  libmysql = mysql.connector-c;
  libtidy = html-tidy;
  links = links2;
  lttngTools = lttng-tools;
  lttngUst = lttng-ust;
  lua5_sec = luaPackages.luasec;
  lua5_1_sockets = lua51Packages.luasocket;
  lua5_expat = luaPackages.luaexpat;
  m3d-linux = m33-linux;
  manpages = man-pages;
  man_db = man-db;
  midoriWrapper = midori;
  minc_tools = minc-tools;
  mlt-qt5 = libsForQt5.mlt;
  module_init_tools = kmod;
  mssys = ms-sys;
  multipath_tools = multipath-tools;
  mupen64plus1_5 = mupen64plus;
  mysqlWorkbench = mysql-workbench;
  ncat = nmap;
  nmap_graphical = nmap-graphical;
  nfsUtils = nfs-utils;
  opencl-icd = ocl-icd;
  owncloudclient = owncloud-client;
  pgp-tools = signing-party;
  pidgin-with-plugins = pidgin;
  pidginlatexSF = pidgin-latex;
  pidginlatex = pidgin-latex;
  pidginmsnpecan = pidgin-msn-pecan;
  pidginotr = pidgin-otr;
  pidginosd = pidgin-osd;
  pidginsipe = pidgin-sipe;
  pidginwindowmerge = pidgin-window-merge;
  postage = pgmanage;
  poppler_qt5 = libsForQt5.poppler;
  PPSSPP = ppsspp;
  prometheus-statsd-bridge = prometheus-statsd-exporter;
  qca-qt5 = libsForQt5.qca-qt5;
  QmidiNet = qmidinet;
  qt_gstreamer = qt-gstreamer;
  qt_gstreamer1 = qt-gstreamer1;
  quake3game = ioquake3;
  qwt6 = libsForQt5.qwt;
  rdiff_backup = rdiff-backup;
  rdmd = dtools;
  robomongo = robo3t;
  rssglx = rss-glx;
  rubygems = throw "deprecated 2016-03-02: rubygems is now bundled with ruby";
  rxvt_unicode_with-plugins = rxvt_unicode-with-plugins;
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver;
  saneBackends = sane-backends;
  saneBackendsGit = sane-backends-git;
  saneFrontends = sane-frontends;
  scim = sc-im;
  skrooge2 = skrooge;
  skype = skypeforlinux;
  spaceOrbit = space-orbit;
  speedtest_cli = speedtest-cli;
  sqliteInteractive = sqlite-interactive;
  sshfs = sshfs-fuse;
  sshfsFuse = sshfs-fuse;
  surf-webkit2 = surf;
  system_config_printer = system-config-printer;
  telepathy_qt5 = libsForQt5.telepathy;
  tftp_hpa = tftp-hpa;
  transmission_gtk = transmission-gtk;
  transmission_remote_gtk = transmission-remote-gtk;
  ucsFonts = ucs-fonts;
  ultrastardx-beta = ultrastardx;
  usb_modeswitch = usb-modeswitch;
  vimbWrapper = vimb;
  vimprobable2Wrapper = vimprobable2;
  virtviewer = virt-viewer;
  vorbisTools = vorbis-tools;
  winusb = woeusb;
  x11 = xlibsWrapper;
  xf86_video_nouveau = xorg.xf86videonouveau;
  xlibs = xorg;
  youtubeDL = youtube-dl;


  wineMinimal = winePackages.minimal;
  wineFull = winePackages.full;
  wineStable = winePackages.stable;
  wineUnstable = winePackages.unstable;

  inherit (ocaml-ng)
    ocamlPackages_3_10_0 ocamlPackages_3_11_2 ocamlPackages_3_12_1
    ocamlPackages_4_00_1 ocamlPackages_4_01_0 ocamlPackages_4_02
    ocamlPackages_4_03
    ocamlPackages_latest;
} // (with ocaml-ng; {
  ocaml_3_08_0 = ocamlPackages_3_08_0.ocaml;
  ocaml_3_10_0 = ocamlPackages_3_10_0.ocaml;
  ocaml_3_11_2 = ocamlPackages_3_11_2.ocaml;
  ocaml_3_12_1 = ocamlPackages_3_12_1.ocaml;
  ocaml_4_00_1 = ocamlPackages_4_00_1.ocaml;
  ocaml_4_01_0 = ocamlPackages_4_01_0.ocaml;
  ocaml_4_02   = ocamlPackages_4_02.ocaml;
  ocaml_4_03   = ocamlPackages_4_03.ocaml;
  ocaml        = ocamlPackages.ocaml;
}))
