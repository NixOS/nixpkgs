lib: self: super:

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

  # Make sure that we are not shadowing something from
  # all-packages.nix.
  checkInPkgs = n: alias: if builtins.hasAttr n super
                          then throw "Alias ${n} is still in all-packages.nix"
                          else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias: removeDistribute
                             (removeRecurseForDerivations
                              (checkInPkgs n alias)))
                     aliases;
in

  ### Deprecated aliases - for backward compatibility

mapAliases ({
  PPSSPP = ppsspp; # added 2017-10-01
  QmidiNet = qmidinet;  # added 2016-05-22
  accounts-qt = libsForQt5.accounts-qt; # added 2015-12-19
  adobeReader = adobe-reader; # added 2013-11-04
  adobe_flex_sdk = apache-flex-sdk; # added 2018-06-01
  ag = silver-searcher; # added 2018-04-25
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
  buildPerlPackage = perlPackages.buildPerlPackage; # added 2018-10-12
  bundler_HEAD = bundler; # added 2015-11-15
  cantarell_fonts = cantarell-fonts; # added 2018-03-03
  checkbashism = checkbashisms; # added 2016-08-16
  cifs_utils = cifs-utils; # added 2016-08
  ckb = ckb-next; # added 2018-10-21
  clangAnalyzer = clang-analyzer;  # added 2015-02-20
  clawsMail = claws-mail; # added 2016-04-29
  clutter_gtk = clutter-gtk; # added 2018-02-25
  conkerorWrapper = conkeror; # added 2015-01
  conntrack_tools = conntrack-tools; # added 2018-05
  cool-old-term = cool-retro-term; # added 2015-01-31
  cupsBjnp = cups-bjnp; # added 2016-01-02
  cups_filters = cups-filters; # added 2016-08
  cv = progress; # added 2015-09-06
  d1x_rebirth = dxx-rebirth; # added 2018-04-25
  d2x_rebirth = dxx-rebirth; # added 2018-04-25
  dbus_daemon = dbus.daemon; # added 2018-04-25
  dbus_glib = dbus-glib; # added 2018-02-25
  dbus_libs = dbus; # added 2018-04-25
  dbus_tools = dbus.out; # added 2018-04-25
  deadbeef-mpris2-plugin = deadbeefPlugins.mpris2; # added 2018-02-23
  deadpixi-sam = deadpixi-sam-unstable;
  debian_devscripts = debian-devscripts; # added 2016-03-23
  desktop_file_utils = desktop-file-utils; # added 2018-02-25
  devicemapper = lvm2; # added 2018-04-25
  digikam5 = digikam; # added 2017-02-18
  dmtx = dmtx-utils; # added 2018-04-25
  docbook5_xsl = docbook_xsl_ns; # added 2018-04-25
  docbook_xml_xslt = docbook_xsl; # added 2018-04-25
  double_conversion = double-conversion; # 2017-11-22
  docker_compose = docker-compose; # 2018-11-10
  dwarf_fortress = dwarf-fortress; # added 2016-01-23
  emacsMelpa = emacs25PackagesNg; # for backward compatibility
  emacsPackagesGen = emacsPackagesFor; # added 2018-08-18
  emacsPackagesNgGen = emacsPackagesNgFor; # added 2018-08-18
  emby = throw "The Emby derivation has been removed, see jellyfin instead for a free software fork."; # added 2019-05-01
  enblendenfuse = enblend-enfuse; # 2015-09-30
  evolution_data_server = evolution-data-server; # added 2018-02-25
  etcdctl = etcd; # added 2018-04-25
  exfat-utils = exfat;                  # 2015-09-11
  ffadoFull = ffado; # added 2018-05-01
  firefox-esr-wrapper = firefox-esr;  # 2016-01
  firefox-wrapper = firefox;          # 2016-01
  firefoxWrapper = firefox;           # 2015-09
  flameGraph = flamegraph; # added 2018-04-25
  font-awesome-ttf = font-awesome; # 2018-02-25
  font-droid = throw "font-droid has been deprecated by noto-fonts"; # 2019-04-12
  foomatic_filters = foomatic-filters;  # 2016-08
  fuse_exfat = exfat;                   # 2015-09-11
  fuseki = apache-jena-fuseki; # added 2018-04-25
  gccApple = throw "gccApple is no longer supported"; # added 2018-04-25
  gdb-multitarget = gdb; # added 2017-11-13
  gettextWithExpat = gettext; # 2016-02-19
  git-hub = gitAndTools.git-hub; # added 2016-04-29
  glib_networking = glib-networking; # added 2018-02-25
  gnome-themes-standard = gnome-themes-extra; # added 2018-03-14
  gnome_doc_utils = gnome-doc-utils; # added 2018-02-25
  gnome_themes_standard = gnome-themes-standard; # added 2018-02-25
  gnustep-make = gnustep.make; # added 2016-7-6
  go-pup = pup; # added 2017-12-19
  gobjectIntrospection = gobject-introspection; # added 2018-12-02
  goimports = gotools; # added 2018-09-16
  googleAuthenticator = google-authenticator; # added 2016-10-16
  grantlee5 = libsForQt5.grantlee;  # added 2015-12-19
  gsettings_desktop_schemas = gsettings-desktop-schemas; # added 2018-02-25
  gst_plugins_bad = gst-plugins-bad;  # added 2017-02
  gst_plugins_base = gst-plugins-base;  # added 2017-02
  gst_plugins_good = gst-plugins-good;  # added 2017-02
  gst_plugins_ugly = gst-plugins-ugly;  # added 2017-02
  gst_python = gst-python;  # added 2017-02
  gtk_doc = gtk-doc; # added 2018-02-25
  guileCairo = guile-cairo; # added 2017-09-24
  guileGnome = guile-gnome; # added 2017-09-24
  guileLint = guile-lint; # added 2017-09-27
  guile_lib = guile-lib; # added 2017-09-24
  guile_ncurses = guile-ncurses; # added 2017-09-24
  gupnp_av = gupnp-av; # added 2018-02-25
  gupnp_dlna = gupnp-dlna; # added 2018-02-25
  gupnp_igd = gupnp-igd; # added 2018-02-25
  gupnptools = gupnp-tools;  # added 2015-12-19
  gutenberg = zola;  # added 2018-11-17
  heimdalFull = heimdal; # added 2018-05-01
  hicolor_icon_theme = hicolor-icon-theme; # added 2018-02-25
  htmlTidy = html-tidy;  # added 2014-12-06
  iana_etc = iana-etc;  # added 2017-03-08
  idea = jetbrains; # added 2017-04-03
  inotifyTools = inotify-tools;
  jbuilder = dune; # added 2018-09-09
  joseki = apache-jena-fuseki; # added 2016-02-28
  json_glib = json-glib; # added 2018-02-25
  kdiff3-qt5 = kdiff3; # added 2017-02-18
  keepass-keefox = keepass-keepassrpc; # backwards compatibility alias, added 2018-02
  keepassx-community = keepassxc; # added 2017-11
  keepassx-reboot = keepassx-community; # added 2017-02-01
  keepassx2-http = keepassx-reboot; # added 2016-10-17
  keybase-go = keybase;  # added 2016-08-24
  krename-qt5 = krename; # added 2017-02-18
  kvm = qemu_kvm; # added 2018-04-25
  letsencrypt = certbot; # added 2016-05-16
  libaudit = audit; # added 2018-04-25
  libcanberra_gtk2 = libcanberra-gtk2; # added 2018-02-25
  libcanberra_gtk3 = libcanberra-gtk3; # added 2018-02-25
  libcap_manpages = libcap.doc; # added 2016-04-29
  libcap_pam = if stdenv.isLinux then libcap.pam else null; # added 2016-04-29
  libcap_progs = libcap.out; # added 2016-04-29
  libdbusmenu_qt5 = libsForQt5.libdbusmenu;  # added 2015-12-19
  libdbusmenu-glib = libdbusmenu; # added 2018-05-01
  liberation_ttf_v1_from_source = liberation_ttf_v1; # added 2018-12-12
  liberation_ttf_v2_from_source = liberation_ttf_v2; # added 2018-12-12
  liberationsansnarrow = liberation-sans-narrow; # added 2018-12-12
  libgnome_keyring = libgnome-keyring; # added 2018-02-25
  libgnome_keyring3 = libgnome-keyring3; # added 2018-02-25
  libgumbo = gumbo; # added 2018-01-21
  libintlOrEmpty = stdenv.lib.optional (!stdenv.isLinux || stdenv.hostPlatform.libc != "glibc") gettext; # added 2018-03-14
  libjson_rpc_cpp = libjson-rpc-cpp; # added 2017-02-28
  liblapackWithoutAtlas = liblapack; # added 2018-11-05
  libmysql = mysql.connector-c; # added # 2017-12-28, this was a misnomer refering to libmysqlclient
  libqrencode = qrencode;  # added 2019-01-01
  librecad2 = librecad;  # backwards compatibility alias, added 2015-10
  libsysfs = sysfsutils; # added 2018-04-25
  libtidy = html-tidy;  # added 2014-12-21
  libudev = udev; # added 2018-04-25
  links = links2; # added 2016-01-31
  lttngTools = lttng-tools;  # added 2014-07-31
  lttngUst = lttng-ust;  # added 2014-07-31
  lua5_1_sockets = lua51Packages.luasocket; # added 2017-05-02
  lua5_expat = luaPackages.luaexpat; # added 2017-05-02
  lua5_sec = luaPackages.luasec; # added 2017-05-02
  m3d-linux = m33-linux; # added 2016-08-13
  man_db = man-db; # added 2016-05
  manpages = man-pages; # added 2015-12-06
  midoriWrapper = midori; # added 2015-01
  mlt-qt5 = libsForQt5.mlt;  # added 2015-12-19
  mobile_broadband_provider_info = mobile-broadband-provider-info; # added 2018-02-25
  module_init_tools = kmod; # added 2016-04-22
  mpich2 = mpich;  # added 2018-08-06
  msf = metasploit; # added 2018-04-25
  libmsgpack = msgpack; # added 2018-08-17
  mssys = ms-sys; # added 2015-12-13
  multipath_tools = multipath-tools;  # added 2016-01-21
  mupen64plus1_5 = mupen64plus; # added 2016-02-12
  mysqlWorkbench = mysql-workbench; # added 2017-01-19
  nagiosPluginsOfficial = monitoring-plugins;
  ncat = nmap;  # added 2016-01-26
  netcat-openbsd = libressl.nc; # added 2018-04-25
  networkmanager_fortisslvpn = networkmanager-fortisslvpn; # added 2018-02-25
  networkmanager_iodine = networkmanager-iodine; # added 2018-02-25
  networkmanager_l2tp = networkmanager-l2tp; # added 2018-02-25
  networkmanager_openconnect = networkmanager-openconnect; # added 2018-02-25
  networkmanager_openvpn = networkmanager-openvpn; # added 2018-02-25
  networkmanager_vpnc = networkmanager-vpnc; # added 2018-02-25
  nfsUtils = nfs-utils;  # added 2014-12-06
  nginxUnstable = nginxMainline; # added 2018-04-25
  nilfs_utils = nilfs-utils; # added 2018-04-25
  nmap_graphical = nmap-graphical;  # added 2017-01-19
  nologin = shadow; # added 2018-04-25
  nxproxy = nx-libs; # added 2019-02-15
  opencascade_oce = opencascade; # added 2018-04-25
  opencl-icd = ocl-icd; # added 2017-01-20
  openexr_ctl = ctl; # added 2018-04-25
  openjpeg_2_1 = openjpeg_2; # added 2018-10-25
  opensans-ttf = open-sans; # added 2018-12-04
  openssh_with_kerberos = openssh; # added 2018-01-28
  owncloudclient = owncloud-client;  # added 2016-08
  p11_kit = p11-kit; # added 2018-02-25
  parquet-cpp = arrow-cpp; # added 2018-09-08
  pass-otp = pass.withExtensions (ext: [ext.pass-otp]); # added 2018-05-04
  perlXMLParser = perlPackages.XMLParser; # added 2018-10-12
  perlArchiveCpio = perlPackages.ArchiveCpio; # added 2018-10-12
  pgp-tools = signing-party; # added 2017-03-26
  pg_tmp = ephemeralpg; # added 2018-01-16
  pidgin-with-plugins = pidgin; # added 2016-06
  pidginlatex = pidgin-latex; # added 2018-01-08
  pidginlatexSF = pidgin-latex; # added 2014-11-02
  pidginmsnpecan = pidgin-msn-pecan; # added 2018-01-08
  pidginosd = pidgin-osd; # added 2018-01-08
  pidginotr = pidgin-otr; # added 2018-01-08
  pidginsipe = pidgin-sipe; # added 2018-01-08
  pidginwindowmerge = pidgin-window-merge; # added 2018-01-08
  piwik = matomo; # added 2018-01-16
  pltScheme = racket; # just to be sure
  plexpy = tautulli; # plexpy got renamed to tautulli, added 2019-02-22
  pmtools = acpica-tools; # added 2018-11-01
  poppler_qt5 = libsForQt5.poppler;  # added 2015-12-19
  postgresql94 = postgresql_9_4;
  postgresql95 = postgresql_9_5;
  postgresql96 = postgresql_9_6;
  postgresql100 = throw "deprecated 2018-10-21: use postgresql_10 instead";
  # postgresql plugins
  pgjwt = postgresqlPackages.pgjwt;
  pg_repack = postgresqlPackages.pg_repack;
  pgroonga = postgresqlPackages.pgroonga;
  pg_similarity = postgresqlPackages.pg_similarity;
  pgtap = postgresqlPackages.pgtap;
  plv8 = postgresqlPackages.plv8;
  timescaledb = postgresqlPackages.timescaledb;
  tsearch_extras = postgresqlPackages.tsearch_extras;
  cstore_fdw = postgresqlPackages.cstore_fdw;
  pg_hll = postgresqlPackages.pg_hll;
  pg_cron = postgresqlPackages.pg_cron;
  pg_topn = postgresqlPackages.pg_topn;
  postgis = postgresqlPackages.postgis;
  # end
  ppl-address-book = throw "deprecated in 2019-05-02: abandoned by upstream.";
  procps-ng = procps; # added 2018-06-08
  pstree = psmisc; # added 2019-05-05
  pulseaudioLight = pulseaudio; # added 2018-04-25
  qca-qt5 = libsForQt5.qca-qt5;  # added 2015-12-19
  qt_gstreamer = qt-gstreamer;  # added 2017-02
  qt_gstreamer1 = qt-gstreamer1;  # added 2017-02
  quake3game = ioquake3; # added 2016-01-14
  qwt6 = libsForQt5.qwt;  # added 2015-12-19
  rdiff_backup = rdiff-backup;  # added 2014-11-23
  rdmd = dtools;  # added 2017-08-19
  rhc = throw "deprecated in 2019-04-09: abandoned by upstream.";
  rng_tools = rng-tools; # added 2018-10-24
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
  s6Dns = s6-dns; # added 2018-07-23
  s6Networking = s6-networking; # added 2018-07-23
  s6LinuxUtils = s6-linux-utils; # added 2018-07-23
  s6PortableUtils = s6-portable-utils; # added 2018-07-23
  sagemath = sage; # added 2018-10-27
  sam = deadpixi-sam; # added 2018-04-25
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver; # added 2016-01-25
  saneBackends = sane-backends; # added 2016-01-02
  saneBackendsGit = sane-backends-git; # added 2016-01-02
  saneFrontends = sane-frontends; # added 2016-01-02
  sapic = throw "deprecated 2019-1-19: sapic is bundled with 'tamarin-prover' now";
  scim = sc-im; # added 2016-01-22
  scollector = bosun; # added 2018-04-25
  shared_mime_info = shared-mime-info; # added 2018-02-25
  skrooge2 = skrooge; # added 2017-02-18
  skype = skypeforlinux; # added 2017-07-27
  slurm-llnl = slurm; # renamed July 2017
  slurm-llnl-full = slurm-full; # renamed July 2017
  slurm-full = slurm; # added 2018-05-1
  smbclient = samba; # added 2018-04-25
  spaceOrbit = space-orbit; # addewd 2016-05-23
  speech_tools = speech-tools; # added 2018-04-25
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  spice_gtk = spice-gtk; # added 2018-02-25
  spice_protocol = spice-protocol; # added 2018-02-25
  sqlite3_analyzer = sqlite-analyzer; # added 2018-05-22
  sqliteInteractive = sqlite-interactive;  # added 2014-12-06
  sshfsFuse = sshfs-fuse; # added 2016-09
  suil-qt5 = suil; # added 2018-05-01
  surf-webkit2 = surf; # added 2017-04-02
  system_config_printer = system-config-printer;  # added 2016-01-03
  systool = sysfsutils; # added 2018-04-25
  tahoelafs = tahoe-lafs; # added 2018-03-26
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
  telnet = inetutils; # added 2018-05-15
  terraform-provider-ibm = terraform-providers.ibm; # added 2018-09-28
  terraform-provider-libvirt = terraform-providers.libvirt; # added 2018-09-28
  terraform-provider-nixos = terraform-providers.nixos; # added 2018-09-28
  tesseract_4 = tesseract4; # added 2018-12-19
  tex-gyre-bonum-math = tex-gyre-math.bonum; # added 2018-04-03
  tex-gyre-pagella-math = tex-gyre-math.pagella; # added 2018-04-03
  tex-gyre-schola-math = tex-gyre-math.schola; # added 2018-04-03
  tex-gyre-termes-math = tex-gyre-math.termes; # added 2018-04-03
  tftp_hpa = tftp-hpa; # added 2015-04-03
  torbrowser = tor-browser-bundle-bin; # added 2017-04-05
  trang = jing-trang; # added 2018-04-25
  transmission_gtk = transmission-gtk; # added 2018-01-06
  transmission_remote_gtk = transmission-remote-gtk; # added 2018-01-06
  truecrypt = veracrypt; # added 2018-10-24
  tshark = wireshark-cli; # added 2018-04-25
  ucsFonts = ucs-fonts; # added 2016-07-15
  ultrastardx-beta = ultrastardx; # added 2017-08-12
  usb_modeswitch = usb-modeswitch; # added 2016-05-10
  vimbWrapper = vimb; # added 2015-01
  vimprobable2Wrapper = vimprobable2; # added 2015-01
  virtviewer = virt-viewer; # added 2015-12-24
  vorbisTools = vorbis-tools; # added 2016-01-26
  webkit = webkitgtk; # added 2019-03-05
  weechat-xmpp = weechatScripts.weechat-xmpp; # added 2018-09-06
  weechat-matrix-bridge = weechatScripts.weechat-matrix-bridge; # added 2018-09-06
  wineStaging = wine-staging; # added 2018-01-08
  winusb = woeusb; # added 2017-12-22
  wireguard = wireguard-tools; # added 2018-05-19
  morituri = whipper; # added 2018-09-13
  x11 = xlibsWrapper; # added 2015-09
  xbmc = kodi; # added 2018-04-25
  xbmcPlain = kodiPlain; # added 2018-04-25
  xbmcPlugins = kodiPlugins; # added 2018-04-25
  xmonad_log_applet_gnome3 = xmonad_log_applet; # added 2018-05-01
  xf86_video_nouveau = xorg.xf86videonouveau; # added 2015-09
  xlibs = xorg; # added 2015-09
  xpraGtk3 = xpra; # added 2018-09-13
  yarn2nix = throw "Use upstream https://github.com/moretea/yarn2nix"; # added 2019-04-12
  mkYarnPackage = yarn2nix; # added 2019-04-12
  youtubeDL = youtube-dl;  # added 2014-10-26
  zdfmediathk = mediathekview; # added 2019-01-19

  # TODO(ekleog): add ‘wasm’ alias to ‘ocamlPackages.wasm’ after 19.03
  # branch-off

  # added 2017-05-27
  wineMinimal = winePackages.minimal;
  wineFull = winePackages.full;
  wineStable = winePackages.stable;
  wineUnstable = winePackages.unstable;

  # added 2018-03-26
  libva-full = libva;
  libva1-full = libva1;

  # forceSystem should not be used directly in Nixpkgs.
  # added 2018-07-16
  forceSystem = system: _:
    (import self.path { localSystem = { inherit system; }; });
  callPackage_i686 = pkgsi686Linux.callPackage;

  inherit (ocaml-ng) # added 2016-09-14
    ocamlPackages_4_00_1 ocamlPackages_4_01_0 ocamlPackages_4_02
    ocamlPackages_4_03
    ocamlPackages_latest;

  gst_all = { # added 2018-04-25
    inherit (pkgs) gstreamer gnonlin gst-python qt-gstreamer;
    gstPluginsBase = pkgs.gst-plugins-base;
    gstPluginsBad = pkgs.gst-plugins-bad;
    gstPluginsGood = pkgs.gst-plugins-good;
    gstPluginsUgly = pkgs.gst-plugins-ugly;
    gst-plugins-base = pkgs.gst-plugins-base;
    gst-plugins-bad = pkgs.gst-plugins-bad;
    gst-plugins-good = pkgs.gst-plugins-good;
    gst-plugins-ugly = pkgs.gst-plugins-ugly;
  };
} // (with ocaml-ng; { # added 2016-09-14
  ocaml_4_00_1 = ocamlPackages_4_00_1.ocaml;
  ocaml_4_01_0 = ocamlPackages_4_01_0.ocaml;
  ocaml_4_02   = ocamlPackages_4_02.ocaml;
  ocaml_4_03   = ocamlPackages_4_03.ocaml;
}))
