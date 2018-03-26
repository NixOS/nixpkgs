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
  _2048-in-terminal = "2048-in-terminal"; # added 2017-01-16
  _2bwm = "2bwm"; # added 2017-01-16
  _389-ds-base = "389-ds-base"; # added 2017-01-16
  _90secondportraits = "90secondsportraits"; # added 2017-01-16
  accounts-qt = libsForQt5.accounts-qt; # added 2015-12-19
  adobeReader = adobe-reader; # added 2013-11-04
  aircrackng = aircrack-ng; # added 2016-01-14
  ammonite-repl = ammonite; # added 2017-05-02
  arduino_core = arduino-core;  # added 2015-02-04
  asciidocFull = asciidoc-full;  # added 2014-06-22
  at_spi2_atk = at-spi2-atk; # added 2018-02-25
  at_spi2_core = at-spi2-core; # added 2018-02-25
  bar-xft = lemonbar-xft;  # added 2015-01-16
  bashCompletion = bash-completion; # Added 2016-09-28
  bridge_utils = bridge-utils;  # added 2015-02-20
  btrfsProgs = btrfs-progs; # added 2016-01-03
  bundler_HEAD = bundler; # added 2015-11-15
  cantarell_fonts = cantarell-fonts; # added 2018-03-03
  checkbashism = checkbashisms; # added 2016-08-16
  cifs_utils = cifs-utils; # added 2016-08
  clangAnalyzer = clang-analyzer;  # added 2015-02-20
  clawsMail = claws-mail; # added 2016-04-29
  clutter_gtk = clutter-gtk; # added 2018-02-25
  conkerorWrapper = conkeror; # added 2015-01
  cool-old-term = cool-retro-term; # added 2015-01-31
  cupsBjnp = cups-bjnp; # added 2016-01-02
  cups_filters = cups-filters; # added 2016-08
  cv = progress; # added 2015-09-06
  dbus_glib = dbus-glib; # added 2018-02-25
  deadbeef-mpris2-plugin = deadbeefPlugins.mpris2; # added 2018-02-23
  debian_devscripts = debian-devscripts; # added 2016-03-23
  desktop_file_utils = desktop-file-utils; # added 2018-02-25
  digikam5 = digikam; # added 2017-02-18
  double_conversion = double-conversion; # 2017-11-22
  dwarf_fortress = dwarf-fortress; # added 2016-01-23
  dwbWrapper = dwb; # added 2015-01
  enblendenfuse = enblend-enfuse; # 2015-09-30
  evolution_data_server = evolution-data-server; # added 2018-02-25
  exfat-utils = exfat;                  # 2015-09-11
  firefox-esr-wrapper = firefox-esr;  # 2016-01
  firefox-wrapper = firefox;          # 2016-01
  firefoxWrapper = firefox;           # 2015-09
  font-awesome-ttf = font-awesome_4; # 2018-02-25
  foomatic_filters = foomatic-filters;  # 2016-08
  fuse_exfat = exfat;                   # 2015-09-11
  gettextWithExpat = gettext; # 2016-02-19
  gdb-multitarget = gdb; # added 2017-11-13
  git-hub = gitAndTools.git-hub; # added 2016-04-29
  glib_networking = glib-networking; # added 2018-02-25
  go-pup = pup; # added 2017-12-19
  googleAuthenticator = google-authenticator; # added 2016-10-16
  gnome_doc_utils = gnome-doc-utils; # added 2018-02-25
  gnome-themes-standard = gnome-themes-extra; # added 2018-03-14
  gnome_themes_standard = gnome-themes-standard; # added 2018-02-25
  grantlee5 = libsForQt5.grantlee;  # added 2015-12-19
  gsettings_desktop_schemas = gsettings-desktop-schemas; # added 2018-02-25
  gst_ffmpeg = gst-ffmpeg;  # added 2017-02
  gst_plugins_base = gst-plugins-base;  # added 2017-02
  gst_plugins_good = gst-plugins-good;  # added 2017-02
  gst_plugins_bad = gst-plugins-bad;  # added 2017-02
  gst_plugins_ugly = gst-plugins-ugly;  # added 2017-02
  gst_python = gst-python;  # added 2017-02
  gtk_doc = gtk-doc; # added 2018-02-25
  guileCairo = guile-cairo; # added 2017-09-24
  guileGnome = guile-gnome; # added 2017-09-24
  guile_lib = guile-lib; # added 2017-09-24
  guileLint = guile-lint; # added 2017-09-27
  guile_ncurses = guile-ncurses; # added 2017-09-24
  gupnp_av = gupnp-av; # added 2018-02-25
  gupnp_dlna = gupnp-dlna; # added 2018-02-25
  gupnp_igd = gupnp-igd; # added 2018-02-25
  gupnptools = gupnp-tools;  # added 2015-12-19
  gnustep-make = gnustep.make; # added 2016-7-6
  hicolor_icon_theme = hicolor-icon-theme; # added 2018-02-25
  htmlTidy = html-tidy;  # added 2014-12-06
  iana_etc = iana-etc;  # added 2017-03-08
  idea = jetbrains; # added 2017-04-03
  inotifyTools = inotify-tools;
  joseki = apache-jena-fuseki; # added 2016-02-28
  json_glib = json-glib; # added 2018-02-25
  kdiff3-qt5 = kdiff3; # added 2017-02-18
  keepassx2-http = keepassx-reboot; # added 2016-10-17
  keepassx-reboot = keepassx-community; # added 2017-02-01
  keepassx-community = keepassxc; # added 2017-11
  keybase-go = keybase;  # added 2016-08-24
  krename-qt5 = krename; # added 2017-02-18
  letsencrypt = certbot; # added 2016-05-16
  libdbusmenu_qt5 = libsForQt5.libdbusmenu;  # added 2015-12-19
  libcanberra_gtk2 = libcanberra-gtk2; # added 2018-02-25
  libcanberra_gtk3 = libcanberra-gtk3; # added 2018-02-25
  libcap_manpages = libcap.doc; # added 2016-04-29
  libcap_pam = if stdenv.isLinux then libcap.pam else null; # added 2016-04-29
  libcap_progs = libcap.out; # added 2016-04-29
  libgnome_keyring = libgnome-keyring; # added 2018-02-25
  libgnome_keyring3 = libgnome-keyring3; # added 2018-02-25
  libgumbo = gumbo; # added 2018-01-21
  libintlOrEmpty = stdenv.lib.optional (!stdenv.isLinux || hostPlatform.libc != "glibc") gettext; # added 2018-03-14
  libjson_rpc_cpp = libjson-rpc-cpp; # added 2017-02-28
  libmysql = mysql.connector-c; # added # 2017-12-28, this was a misnomer refering to libmysqlclient
  libtidy = html-tidy;  # added 2014-12-21
  links = links2; # added 2016-01-31
  lttngTools = lttng-tools;  # added 2014-07-31
  lttngUst = lttng-ust;  # added 2014-07-31
  lua5_sec = luaPackages.luasec; # added 2017-05-02
  lua5_1_sockets = lua51Packages.luasocket; # added 2017-05-02
  lua5_expat = luaPackages.luaexpat; # added 2017-05-02
  m3d-linux = m33-linux; # added 2016-08-13
  manpages = man-pages; # added 2015-12-06
  man_db = man-db; # added 2016-05
  piwik = matomo; # added 2018-01-16
  midoriWrapper = midori; # added 2015-01
  minc_tools = minc-tools; # 2017-12
  mlt-qt5 = libsForQt5.mlt;  # added 2015-12-19
  mobile_broadband_provider_info = mobile-broadband-provider-info; # added 2018-02-25
  module_init_tools = kmod; # added 2016-04-22
  mssys = ms-sys; # added 2015-12-13
  multipath_tools = multipath-tools;  # added 2016-01-21
  mupen64plus1_5 = mupen64plus; # added 2016-02-12
  mysqlWorkbench = mysql-workbench; # added 2017-01-19
  ncat = nmap;  # added 2016-01-26
  networkmanager_fortisslvpn = networkmanager-fortisslvpn; # added 2018-02-25
  networkmanager_iodine = networkmanager-iodine; # added 2018-02-25
  networkmanager_l2tp = networkmanager-l2tp; # added 2018-02-25
  networkmanager_openconnect = networkmanager-openconnect; # added 2018-02-25
  networkmanager_openvpn = networkmanager-openvpn; # added 2018-02-25
  networkmanager_vpnc = networkmanager-vpnc; # added 2018-02-25
  nmap_graphical = nmap-graphical;  # added 2017-01-19
  nfsUtils = nfs-utils;  # added 2014-12-06
  opencl-icd = ocl-icd; # added 2017-01-20
  openssh_with_kerberos = openssh; # added 2018-01-28
  owncloudclient = owncloud-client;  # added 2016-08
  p11_kit = p11-kit; # added 2018-02-25
  pgp-tools = signing-party; # added 2017-03-26
  pidgin-with-plugins = pidgin; # added 2016-06
  pidginlatexSF = pidgin-latex; # added 2014-11-02
  pidginlatex = pidgin-latex; # added 2018-01-08
  pidginmsnpecan = pidgin-msn-pecan; # added 2018-01-08
  pidginotr = pidgin-otr; # added 2018-01-08
  pidginosd = pidgin-osd; # added 2018-01-08
  pidginsipe = pidgin-sipe; # added 2018-01-08
  pidginwindowmerge = pidgin-window-merge; # added 2018-01-08
  postage = pgmanage; # added 2017-11-03
  poppler_qt5 = libsForQt5.poppler;  # added 2015-12-19
  PPSSPP = ppsspp; # added 2017-10-01
  prometheus-statsd-bridge = prometheus-statsd-exporter;  # added 2017-08-27
  qca-qt5 = libsForQt5.qca-qt5;  # added 2015-12-19
  QmidiNet = qmidinet;  # added 2016-05-22
  qt_gstreamer = qt-gstreamer;  # added 2017-02
  qt_gstreamer1 = qt-gstreamer1;  # added 2017-02
  quake3game = ioquake3; # added 2016-01-14
  qwt6 = libsForQt5.qwt;  # added 2015-12-19
  rdiff_backup = rdiff-backup;  # added 2014-11-23
  rdmd = dtools;  # added 2017-08-19
  robomongo = robo3t; #added 2017-09-28
  rssglx = rss-glx; #added 2015-03-25
  ruby_2_0_0 = throw "deprecated 2018-0213: use a newer version of ruby";
  ruby_2_1_0 = throw "deprecated 2018-0213: use a newer version of ruby";
  ruby_2_2_9 = throw "deprecated 2018-0213: use ruby_2_2 instead";
  ruby_2_3_6 = throw "deprecated 2018-0213: use ruby_2_3 instead";
  ruby_2_4_3 = throw "deprecated 2018-0213: use ruby_2_4 instead";
  ruby_2_5_0 = throw "deprecated 2018-0213: use ruby_2_5 instead";
  rubygems = throw "deprecated 2016-03-02: rubygems is now bundled with ruby";
  rxvt_unicode_with-plugins = rxvt_unicode-with-plugins; # added 2015-04-02
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver; # added 2016-01-25
  saneBackends = sane-backends; # added 2016-01-02
  saneBackendsGit = sane-backends-git; # added 2016-01-02
  saneFrontends = sane-frontends; # added 2016-01-02
  scim = sc-im; # added 2016-01-22
  shared_mime_info = shared-mime-info; # added 2018-02-25
  skrooge2 = skrooge; # added 2017-02-18
  skype = skypeforlinux; # added 2017-07-27
  spaceOrbit = space-orbit; # addewd 2016-05-23
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  spice_gtk = spice-gtk; # added 2018-02-25
  spice_protocol = spice-protocol; # added 2018-02-25
  sqliteInteractive = sqlite-interactive;  # added 2014-12-06
  sshfs = sshfs-fuse; # added 2017-08-14
  sshfsFuse = sshfs-fuse; # added 2016-09
  surf-webkit2 = surf; # added 2017-04-02
  system_config_printer = system-config-printer;  # added 2016-01-03
  telepathy_farstream = telepathy-farstream; # added 2018-02-25
  telepathy_gabble = telepathy-gabble; # added 2018-02-25
  telepathy_glib = telepathy-glib; # added 2018-02-25
  telepathy_haze = telepathy-haze; # added 2018-02-25
  telepathy_idle = telepathy-idle; # added 2018-02-25
  telepathy_logger = telepathy-logger; # added 2018-02-25
  telepathy_mission_control = telepathy-mission-control; # added 2018-02-25
  telepathy_qt = telepathy-qt; # added 2018-02-25
  telepathy_qt5 = libsForQt5.telepathy;  # added 2015-12-19
  telepathy_salut = telepathy-salut; # added 2018-02-25
  tftp_hpa = tftp-hpa; # added 2015-04-03
  transmission_gtk = transmission-gtk; # added 2018-01-06
  transmission_remote_gtk = transmission-remote-gtk; # added 2018-01-06
  ucsFonts = ucs-fonts; # added 2016-07-15
  ultrastardx-beta = ultrastardx; # added 2017-08-12
  usb_modeswitch = usb-modeswitch; # added 2016-05-10
  vimbWrapper = vimb; # added 2015-01
  vimprobable2Wrapper = vimprobable2; # added 2015-01
  virtviewer = virt-viewer; # added 2015-12-24
  vorbisTools = vorbis-tools; # added 2016-01-26
  winusb = woeusb; # added 2017-12-22
  x11 = xlibsWrapper; # added 2015-09
  xf86_video_nouveau = xorg.xf86videonouveau; # added 2015-09
  xlibs = xorg; # added 2015-09
  youtubeDL = youtube-dl;  # added 2014-10-26

  # added 2017-05-27
  wineMinimal = winePackages.minimal;
  wineFull = winePackages.full;
  wineStable = winePackages.stable;
  wineUnstable = winePackages.unstable;

  # added 2018-03-26
  libva-full = libva;
  libva1-full = libva1;

  inherit (ocaml-ng) # added 2016-09-14
    ocamlPackages_3_10_0 ocamlPackages_3_11_2 ocamlPackages_3_12_1
    ocamlPackages_4_00_1 ocamlPackages_4_01_0 ocamlPackages_4_02
    ocamlPackages_4_03
    ocamlPackages_latest;
} // (with ocaml-ng; { # added 2016-09-14
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
