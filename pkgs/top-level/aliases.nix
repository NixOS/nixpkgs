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
  accounts-qt = libsForQt5.accounts-qt;  # added 2015-12-19
  adobeReader = adobe-reader;
  aircrackng = aircrack-ng; # added 2016-01-14
  ammonite-repl = ammonite; # added 2017-05-02
  arduino_core = arduino-core;  # added 2015-02-04
  asciidocFull = asciidoc-full;  # added 2014-06-22
  bar = lemonbar;  # added 2015-01-16
  bar-xft = lemonbar-xft;  # added 2015-01-16
  bashCompletion = bash-completion; # Added 2016-09-28
  bridge_utils = bridge-utils;  # added 2015-02-20
  btrfsProgs = btrfs-progs; # added 2016-01-03
  bundler_HEAD = bundler; # added 2015-11-15
  checkbashism = checkbashisms; # added 2016-08-16
  cifs_utils = cifs-utils; # added 2016-08
  clangAnalyzer = clang-analyzer;  # added 2015-02-20
  clawsMail = claws-mail; # added 2016-04-29
  conkerorWrapper = conkeror; # added 2015-01
  cool-old-term = cool-retro-term; # added 2015-01-31
  cupsBjnp = cups-bjnp; # added 2016-01-02
  cups_filters = cups-filters; # added 2016-08
  cv = progress; # added 2015-09-06
  debian_devscripts = debian-devscripts; # added 2016-03-23
  digikam5 = digikam; # added 2017-02-18
  dwarf_fortress = dwarf-fortress; # added 2016-01-23
  dwbWrapper = dwb; # added 2015-01
  enblendenfuse = enblend-enfuse; # 2015-09-30
  exfat-utils = exfat;                  # 2015-09-11
  firefox-esr-wrapper = firefox-esr;  # 2016-01
  firefox-wrapper = firefox;          # 2016-01
  firefoxWrapper = firefox;           # 2015-09
  foomatic_filters = foomatic-filters;  # 2016-08
  fuse_exfat = exfat;                   # 2015-09-11
  gettextWithExpat = gettext; # 2016-02-19
  git-hub = gitAndTools.git-hub; # added 2016-04-29
  googleAuthenticator = google-authenticator; # added 2016-10-16
  grantlee5 = libsForQt5.grantlee;  # added 2015-12-19
  gst_ffmpeg = gst-ffmpeg;  # added 2017-02
  gst_plugins_base = gst-plugins-base;  # added 2017-02
  gst_plugins_good = gst-plugins-good;  # added 2017-02
  gst_plugins_bad = gst-plugins-bad;  # added 2017-02
  gst_plugins_ugly = gst-plugins-ugly;  # added 2017-02
  gst_python = gst-python;  # added 2017-02
  gupnptools = gupnp-tools;  # added 2015-12-19
  gnustep-make = gnustep.make; # added 2016-7-6
  htmlTidy = html-tidy;  # added 2014-12-06
  iana_etc = iana-etc;  # added 2017-03-08
  idea = jetbrains; # added 2017-04-03
  inherit (haskell.compiler) jhc uhc;   # 2015-05-15
  inotifyTools = inotify-tools;
  joseki = apache-jena-fuseki; # added 2016-02-28
  jquery_ui = jquery-ui;  # added 2014-09-07
  kdiff3-qt5 = kdiff3; # added 2017-02-18
  keepassx2-http = keepassx-reboot; # added 2016-10-17
  keepassx-reboot = keepassx-community; # added 2017-02-01
  keybase-go = keybase;  # added 2016-08-24
  krename-qt5 = krename; # added 2017-02-18
  letsencrypt = certbot; # added 2016-05-16
  libdbusmenu_qt5 = libsForQt5.libdbusmenu;  # added 2015-12-19
  libcap_manpages = libcap.doc; # added 2016-04-29
  libcap_pam = if stdenv.isLinux then libcap.pam else null; # added 2016-04-29
  libcap_progs = libcap.out; # added 2016-04-29
  libjson_rpc_cpp = libjson-rpc-cpp; # added 2017-02-28
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
  midoriWrapper = midori; # added 2015-01
  mlt-qt5 = libsForQt5.mlt;  # added 2015-12-19
  module_init_tools = kmod; # added 2016-04-22
  mssys = ms-sys; # added 2015-12-13
  multipath_tools = multipath-tools;  # added 2016-01-21
  mupen64plus1_5 = mupen64plus; # added 2016-02-12
  mysqlWorkbench = mysql-workbench; # added 2017-01-19
  ncat = nmap;  # added 2016-01-26
  nmap_graphical = nmap-graphical;  # added 2017-01-19
  nfsUtils = nfs-utils;  # added 2014-12-06
  opencl-icd = ocl-icd; # added 2017-01-20
  owncloudclient = owncloud-client;  # added 2016-08
  pgp-tools = signing-party; # added 2017-03-26
  pidgin-with-plugins = pidgin; # added 2016-06
  pidginlatexSF = pidginlatex; # added 2014-11-02
  poppler_qt5 = libsForQt5.poppler;  # added 2015-12-19
  qca-qt5 = libsForQt5.qca-qt5;  # added 2015-12-19
  QmidiNet = qmidinet;  # added 2016-05-22
  qt_gstreamer = qt-gstreamer;  # added 2017-02
  qt_gstreamer1 = qt-gstreamer1;  # added 2017-02
  quake3game = ioquake3; # added 2016-01-14
  qwt6 = libsForQt5.qwt;  # added 2015-12-19
  rdiff_backup = rdiff-backup;  # added 2014-11-23
  rssglx = rss-glx; #added 2015-03-25
  rubygems = throw "deprecated 2016-03-02: rubygems is now bundled with ruby";
  rustUnstable = rustNightly; # added 2016-11-29
  rxvt_unicode_with-plugins = rxvt_unicode-with-plugins; # added 2015-04-02
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver; # added 2016-01-25
  saneBackends = sane-backends; # added 2016-01-02
  saneBackendsGit = sane-backends-git; # added 2016-01-02
  saneFrontends = sane-frontends; # added 2016-01-02
  scim = sc-im; # added 2016-01-22
  skrooge2 = skrooge; # added 2017-02-18
  skype = skypeforlinux; # added 2017-07-27
  spaceOrbit = space-orbit; # addewd 2016-05-23
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  sqliteInteractive = sqlite-interactive;  # added 2014-12-06
  sshfsFuse = sshfs-fuse; # added 2016-09
  surf-webkit2 = surf; # added 2017-04-02
  system_config_printer = system-config-printer;  # added 2016-01-03
  telepathy_qt5 = libsForQt5.telepathy;  # added 2015-12-19
  tftp_hpa = tftp-hpa; # added 2015-04-03
  ucsFonts = ucs-fonts; # added 2016-07-15
  usb_modeswitch = usb-modeswitch; # added 2016-05-10
  vimbWrapper = vimb; # added 2015-01
  vimprobable2Wrapper = vimprobable2; # added 2015-01
  virtviewer = virt-viewer; # added 2015-12-24
  vorbisTools = vorbis-tools; # added 2016-01-26
  x11 = xlibsWrapper; # added 2015-09
  xf86_video_nouveau = xorg.xf86videonouveau; # added 2015-09
  xlibs = xorg; # added 2015-09
  youtubeDL = youtube-dl;  # added 2014-10-26

  # added 2017-05-27
  wineMinimal = winePackages.minimal;
  wineFull = winePackages.full;
  wineStable = winePackages.stable;
  wineUnstable = winePackages.unstable;

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
