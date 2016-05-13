self:

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = _n: alias: with lib;
    if alias.recurseForDerivations or false then
      removeAttrs alias ["recurseForDerivations"]
    else alias;

  doNotDisplayTwice = aliases:
    lib.mapAttrs removeRecurseForDerivations aliases;
in

  ### Deprecated aliases - for backward compatibility

doNotDisplayTwice rec {
  accounts-qt = qt5.accounts-qt;  # added 2015-12-19
  adobeReader = adobe-reader;
  aircrackng = aircrack-ng; # added 2016-01-14
  arduino_core = arduino-core;  # added 2015-02-04
  asciidocFull = asciidoc-full;  # added 2014-06-22
  bar = lemonbar;  # added 2015-01-16
  bar-xft = lemonbar-xft;  # added 2015-01-16
  bridge_utils = bridge-utils;  # added 2015-02-20
  btrfsProgs = btrfs-progs; # added 2016-01-03
  buildbotSlave = buildbot-slave;  # added 2014-12-09
  bundler_HEAD = bundler; # added 2015-11-15
  cheetahTemplate = pythonPackages.cheetah; # 2015-06-15
  clangAnalyzer = clang-analyzer;  # added 2015-02-20
  clawsMail = claws-mail; # added 2016-04-29
  conkerorWrapper = conkeror; # added 2015-01
  cool-old-term = cool-retro-term; # added 2015-01-31
  cupsBjnp = cups-bjnp; # added 2016-01-02
  cv = progress; # added 2015-09-06
  debian_devscripts = debian-devscripts; # added 2016-03-23
  dwarf_fortress = dwarf-fortress; # added 2016-01-23
  dwbWrapper = dwb; # added 2015-01
  enblendenfuse = enblend-enfuse; # 2015-09-30
  exfat-utils = exfat;                  # 2015-09-11
  firefox-esr-wrapper = firefox-esr;  # 2016-01
  firefox-wrapper = firefox;          # 2016-01
  firefoxWrapper = firefox;           # 2015-09
  fuse_exfat = exfat;                   # 2015-09-11
  fuse_zip = fuse-zip; # added 2016-04-27
  gettextWithExpat = gettext; # 2016-02-19
  git-hub = gitAndTools.git-hub; # added 2016-04-29
  grantlee5 = qt5.grantlee;  # added 2015-12-19
  gupnptools = gupnp-tools;  # added 2015-12-19
  htmlTidy = html-tidy;  # added 2014-12-06
  inherit (haskell.compiler) jhc uhc;   # 2015-05-15
  inotifyTools = inotify-tools;
  joseki = apache-jena-fuseki; # added 2016-02-28
  jquery_ui = jquery-ui;  # added 2014-09-07
  libdbusmenu_qt5 = qt5.libdbusmenu;  # added 2015-12-19
  libcap_manpages = libcap.doc; # added 2016-04-29
  libcap_pam = if stdenv.isLinux then libcap.pam else null; # added 2016-04-29
  libcap_progs = libcap.out; # added 2016-04-29
  libtidy = html-tidy;  # added 2014-12-21
  links = links2; # added 2016-01-31
  lttngTools = lttng-tools;  # added 2014-07-31
  lttngUst = lttng-ust;  # added 2014-07-31
  manpages = man-pages; # added 2015-12-06
  midoriWrapper = midori; # added 2015-01
  mlt-qt5 = qt5.mlt;  # added 2015-12-19
  module_init_tools = kmod; # added 2016-04-22
  mssys = ms-sys; # added 2015-12-13
  multipath_tools = multipath-tools;  # added 2016-01-21
  mupen64plus1_5 = mupen64plus; # added 2016-02-12
  ncat = nmap;  # added 2016-01-26
  nfsUtils = nfs-utils;  # added 2014-12-06
  pidginlatexSF = pidginlatex; # added 2014-11-02
  poppler_qt5 = qt5.poppler;  # added 2015-12-19
  qca-qt5 = qt5.qca-qt5;  # added 2015-12-19
  quake3game = ioquake3; # added 2016-01-14
  quassel_kf5 = kde5.quassel; # added 2015-09-30
  quassel_qt5 = kde5.quassel_qt5; # added 2015-09-30
  quasselClient_kf5 = kde5.quasselClient; # added 2015-09-30
  quasselClient_qt5 = kde5.quasselClient_qt5; # added 2015-09-30
  quasselDaemon_qt5 = kde5.quasselDaemon; # added 2015-09-30
  qwt6 = qt5.qwt;  # added 2015-12-19
  rdiff_backup = rdiff-backup;  # added 2014-11-23
  rekonqWrapper = rekonq; # added 2015-01
  rssglx = rss-glx; #added 2015-03-25
  rubygems = throw "deprecated 2016-03-02: rubygems is now bundled with ruby";
  rxvt_unicode_with-plugins = rxvt_unicode-with-plugins; # added 2015-04-02
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver; # added 2016-01-25
  saneBackends = sane-backends; # added 2016-01-02
  saneBackendsGit = sane-backends-git; # added 2016-01-02
  saneFrontends = sane-frontends; # added 2016-01-02
  scim = sc-im; # added 2016-01-22
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  sqliteInteractive = sqlite-interactive;  # added 2014-12-06
  system_config_printer = system-config-printer;  # added 2016-01-03
  telepathy_qt5 = qt5.telepathy;  # added 2015-12-19
  tftp_hpa = tftp-hpa; # added 2015-04-03
  usb_modeswitch = usb-modeswitch; # added 2016-05-10
  vimbWrapper = vimb; # added 2015-01
  vimprobable2Wrapper = vimprobable2; # added 2015-01
  virtviewer = virt-viewer; # added 2015-12-24
  vorbisTools = vorbis-tools; # added 2016-01-26
  x11 = xlibsWrapper; # added 2015-09
  xf86_video_nouveau = xorg.xf86videonouveau; # added 2015-09
  xlibs = xorg; # added 2015-09
  youtubeDL = youtube-dl;  # added 2014-10-26
}
