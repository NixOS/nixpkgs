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
  alienfx = throw "alienfx has been removed."; # added 2019-12-08
  aleth = throw "aleth (previously packaged as cpp_ethereum) has been removed; abandoned upstream."; # added 2020-11-30
  amazon-glacier-cmd-interface = throw "amazon-glacier-cmd-interface has been removed due to it being unmaintained."; # added 2020-10-30
  ammonite-repl = ammonite; # added 2017-05-02
  amsn = throw "amsn has been removed due to being unmaintained."; # added 2020-12-09
  antimicro = throw "antimicro has been removed as it was broken, see antimicroX instead."; # added 2020-08-06
  apacheKafka_0_9 = throw "kafka 0.9 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_0_10 = throw "kafka 0.10 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_0_11 = throw "kafka 0.11 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_1_0 = throw "kafka 1.0 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_1_1 = throw "kafka 1.1 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_2_0 = throw "kafka 2.0 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_2_1 = throw "kafka 2.1 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_2_2 = throw "kafka 2.2 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  apacheKafka_2_3 = throw "kafka 2.3 is no longer supported. Please upgrade to a newer version."; # added 2020-12-21
  arduino_core = arduino-core;  # added 2015-02-04
  arora = throw "arora has been removed."; # added 2020-09-09
  asciidocFull = asciidoc-full;  # added 2014-06-22
  asterisk_15 = throw "asterisk_15: Asterisk 15 is end of life and has been removed."; # added 2020-10-07
  at_spi2_atk = at-spi2-atk; # added 2018-02-25
  at_spi2_core = at-spi2-core; # added 2018-02-25
  aucdtect = throw "aucdtect: Upstream no longer provides download urls."; # added 2020-12-26
  avldrums-lv2 = x42-avldrums; # added 2020-03-29
  bar-xft = lemonbar-xft;  # added 2015-01-16
  bashCompletion = bash-completion; # Added 2016-09-28
  batti = throw "batti has been removed from nixpkgs, as it was unmaintained"; # added 2019-12-10
  bazaar = throw "bazaar has been deprecated by breezy."; # added 2020-04-19
  bazaarTools = throw "bazaar has been deprecated by breezy."; # added 2020-04-19
  beegfs = throw "beegfs has been removed."; # added 2019-11-24
  bluezFull = bluez; # Added 2019-12-03
  brackets = throw "brackets has been removed, it was unmaintained and had open vulnerabilities"; # added 2021-01-24
  bridge_utils = bridge-utils;  # added 2015-02-20
  bro = zeek; # added 2019-09-29
  bootchart = throw "bootchart has been removed from nixpkgs, as it is without a maintainer"; # added 2019-12-10
  bomi = throw "bomi has been removed from nixpkgs since it was broken and abandoned upstream"; # added 2020-12-10
  btrfsProgs = btrfs-progs; # added 2016-01-03
  bittorrentSync = throw "bittorrentSync has been deprecated by resilio-sync."; # added 2019-06-03
  bittorrentSync14 = throw "bittorrentSync14 has been deprecated by resilio-sync."; # added 2019-06-03
  bittorrentSync20 = throw "bittorrentSync20 has been deprecated by resilio-sync."; # added 2019-06-03
  bs1770gain = throw "bs1770gain has been removed from nixpkgs, as it had no maintainer or reverse dependencies."; # added 2021-01-02
  btc1 = throw "btc1 has been removed, it was abandoned by upstream"; # added 2020-11-03
  buildPerlPackage = perlPackages.buildPerlPackage; # added 2018-10-12
  buildGo112Package = throw "buildGo112Package has been removed"; # added 2020-04-26
  buildGo112Module = throw "buildGo112Module has been removed"; # added 2020-04-26
  bundler_HEAD = bundler; # added 2015-11-15
  calibre-py2 = throw "calibre-py2 has been removed from nixpkgs, as calibre has upgraded to python 3. Please use calibre as replacement."; # added 2021-01-13
  calibre-py3 = throw "calibre-py3 has been removed from nixpkgs, as calibre's default python version is now 3. Please use calibre as replacement."; # added 2021-01-13
  caddy1 = throw "caddy 1.x has been removed from nixpkgs, as it's unmaintained: https://github.com/caddyserver/caddy/blob/master/.github/SECURITY.md#supported-versions"; # added 2020-10-02
  cantarell_fonts = cantarell-fonts; # added 2018-03-03
  cargo-tree = throw "cargo-tree has been removed, use the builtin `cargo tree` command instead."; # added 2020-08-20
  casperjs = throw "casperjs has been removed, it was abandoned by upstream and broken.";
  catfish = xfce.catfish; # added 2019-12-22
  ccnet = throw "ccnet has been removed because seafile does not depend on it anymore"; # added 2021-03-25
  cgmanager = throw "cgmanager was deprecated by lxc and therefore removed from nixpkgs."; # added 2020-06-05
  checkbashism = checkbashisms; # added 2016-08-16
  chronos = throw "chronos has been removed from nixpkgs, as it was unmaintained"; # added 2020-08-15
  cide = throw "cide was deprecated on 2019-09-11: abandoned by upstream";
  cinepaint = throw "cinepaint has been removed from nixpkgs, as it was unmaintained"; # added 2019-12-10
  cifs_utils = cifs-utils; # added 2016-08
  ckb = ckb-next; # added 2018-10-21

  # these are for convenience, not for backward compat and shouldn't expire
  clang5Stdenv = lowPrio llvmPackages_5.stdenv;
  clang6Stdenv = lowPrio llvmPackages_6.stdenv;
  clang7Stdenv = lowPrio llvmPackages_7.stdenv;
  clang8Stdenv = lowPrio llvmPackages_8.stdenv;
  clang9Stdenv = lowPrio llvmPackages_9.stdenv;
  clang10Stdenv = lowPrio llvmPackages_10.stdenv;
  clang11Stdenv = lowPrio llvmPackages_11.stdenv;

  clangAnalyzer = clang-analyzer;  # added 2015-02-20
  clawsMail = claws-mail; # added 2016-04-29
  clutter_gtk = clutter-gtk; # added 2018-02-25
  codimd = hedgedoc; # added 2020-11-29
  compton = picom; # added 2019-12-02
  compton-git = compton; # added 2019-05-20
  concurrencykit = libck; # added 2021-03
  conntrack_tools = conntrack-tools; # added 2018-05
  cool-old-term = cool-retro-term; # added 2015-01-31
  coprthr = throw "coprthr has been removed."; # added 2019-12-08
  corebird = throw "corebird was deprecated 2019-10-02: See https://www.patreon.com/posts/corebirds-future-18921328. Please use Cawbird as replacement.";
  coredumper = throw "coredumper has been removed: abandoned by upstream."; # added 2019-11-16
  cpp_ethereum = throw "cpp_ethereum has been removed; abandoned upstream."; # added 2020-11-30
  cryptol = throw "cryptol was removed due to prolonged broken build"; # added 2020-08-21
  cpp-gsl = microsoft_gsl; # added 2019-05-24
  cudatoolkit_6 = throw "cudatoolkit_6 has been removed in favor of newer versions"; # added 2021-02-14
  cudatoolkit_65 = throw "cudatoolkit_65 has been removed in favor of newer versions"; # added 2021-02-14
  cudatoolkit_7 = throw "cudatoolkit_7 has been removed in favor of newer versions"; # added 2021-02-14
  cudatoolkit_7_5 = throw "cudatoolkit_7_5 has been removed in favor of newer versions"; # added 2021-02-14
  cudatoolkit_8 = throw "cudatoolkit_8 has been removed in favor of newer versions"; # added 2021-02-14
  cudnn_cudatoolkit_7 = throw "cudnn_cudatoolkit_7 has been removed in favor of newer versions"; # added 2021-02-14
  cudnn_cudatoolkit_7_5 = throw "cudnn_cudatoolkit_7_5 has been removed in favor of newer versions"; # added 2021-02-14
  cudnn6_cudatoolkit_8 = throw "cudnn6_cudatoolkit_8 has been removed in favor of newer versions"; # added 2021-02-14
  cudnn_cudatoolkit_8 = throw "cudnn_cudatoolkit_8 has been removed in favor of newer versions"; # added 2021-02-14
  cupsBjnp = cups-bjnp; # added 2016-01-02
  cups_filters = cups-filters; # added 2016-08
  cups-googlecloudprint = throw "Google Cloudprint is officially discontinued since Jan 2021, more info https://support.google.com/chrome/a/answer/9633006";
  cquery = throw "cquery has been removed because it is abandoned by upstream. Consider switching to clangd or ccls instead."; # added 2020-06-15
  cv = progress; # added 2015-09-06
  d1x_rebirth = dxx-rebirth; # added 2018-04-25
  d2x_rebirth = dxx-rebirth; # added 2018-04-25
  dart_dev = throw "Non-stable versions of Dart have been removed."; # added 2020-01-15
  dart_old = throw "Non-stable versions of Dart have been removed."; # added 2020-01-15
  dart_stable = dart; # added 2020-01-15
  dat = nodePackages.dat;
  dbvisualizer = throw "dbvisualizer has been removed from nixpkgs, as it's unmaintained"; # added 2020-09-20
  dbus_daemon = dbus.daemon; # added 2018-04-25
  dbus_glib = dbus-glib; # added 2018-02-25
  dbus_libs = dbus; # added 2018-04-25
  diffuse = throw "diffuse has been removed from nixpkgs, as it's unmaintained"; # added 2019-12-10
  dbus_tools = dbus.out; # added 2018-04-25
  deadbeef-mpris2-plugin = deadbeefPlugins.mpris2; # added 2018-02-23
  deadpixi-sam = deadpixi-sam-unstable;
  debian_devscripts = debian-devscripts; # added 2016-03-23
  deepin = throw "deepin was a work in progress and it has been canceled and removed https://github.com/NixOS/nixpkgs/issues/94870"; # added 2020-08-31
  desktop_file_utils = desktop-file-utils; # added 2018-02-25
  devicemapper = lvm2; # added 2018-04-25
  digikam5 = digikam; # added 2017-02-18
  dmtx = dmtx-utils; # added 2018-04-25
  dnnl = oneDNN; # added 2020-04-22
  docbook5_xsl = docbook_xsl_ns; # added 2018-04-25
  docbook_xml_xslt = docbook_xsl; # added 2018-04-25
  double_conversion = double-conversion; # 2017-11-22
  docker_compose = docker-compose; # 2018-11-10
  draftsight = throw "draftsight has been removed, no longer available as freeware"; # added 2020-08-14
  dvb_apps = throw "dvb_apps has been removed."; # added 2020-11-03
  dwarf_fortress = dwarf-fortress; # added 2016-01-23
  dwm-git = throw "dwm-git has been removed from nixpkgs, as it had no updates for 2 years not serving it's purpose."; # added 2021-02-07
  elasticmq = throw "elasticmq has been removed in favour of elasticmq-server-bin"; # added 2021-01-17
  emacsPackagesGen = emacsPackagesFor; # added 2018-08-18
  emacsPackagesNgGen = emacsPackagesFor; # added 2018-08-18
  emacsPackagesNgFor = emacsPackagesFor; # added 2019-08-07
  emacsPackagesNg = emacs.pkgs; # added 2019-08-07
  emacs27Packages = emacs27.pkgs; # added 2020-12-18
  emacs27WithPackages = emacs27.pkgs.withPackages; # added 2020-12-18
  emacsWithPackages = emacs.pkgs.withPackages; # added 2020-12-18
  emacsPackages = emacs.pkgs; # added 2020-12-18
  emby = throw "The Emby derivation has been removed, see jellyfin instead for a free software fork."; # added 2019-05-01
  enblendenfuse = enblend-enfuse; # 2015-09-30
  esniper = throw "esniper has been removed because upstream no longer maintains it (and it no longer works)"; # added 2021-04-12
  evolution_data_server = evolution-data-server; # added 2018-02-25
  etcdctl = etcd; # added 2018-04-25
  exfat-utils = exfat;                  # 2015-09-11
  facette = throw "facette has been removed."; # added 2020-01-06
  fast-neural-doodle = throw "fast-neural-doodle has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H.";
  ffadoFull = ffado; # added 2018-05-01
  firefox-esr-68 = throw "Firefox 68 ESR reached end of life with its final release 68.12esr on 2020-08-25 and was therefore removed from nixpkgs";
  firefox-esr-wrapper = firefox-esr;  # 2016-01
  firefox-wrapper = firefox;          # 2016-01
  firefoxWrapper = firefox;           # 2015-09

  firestr = throw "firestr has been removed."; # added 2019-12-08
  fish-foreign-env = throw "fish-foreign-env has been replaced with fishPlugins.foreign-env"; # added 2020-12-29, modified 2021-01-10
  flameGraph = flamegraph; # added 2018-04-25
  flashplayer = throw "flashplayer has been removed as Adobe Flash Player is now deprecated."; # added 2021-02-07
  flashplayer-standalone = throw "flashplayer-standalone has been removed as Adobe Flash Player is now deprecated."; # added 2021-02-07
  flashplayer-standalone-debugger = throw "flashplayer-standalone-debugger has been removed as Adobe Flash Player is now deprecated."; # added 2021-02-07
  flink_1_5 = throw "flink_1_5 was removed, use flink instead"; # added 2021-01-25
  flutter-beta = throw "Non-stable versions of Flutter have been removed. You can use flutterPackages.mkFlutter to generate a package for other Flutter versions."; # added 2020-01-15
  flutter-dev = throw "Non-stable versions of Flutter have been removed. You can use flutterPackages.mkFlutter to generate a package for other Flutter versions."; # added 2020-01-15
  flvtool2 = throw "flvtool2 has been removed."; # added 2020-11-03
  foldingathome = fahclient; # added 2020-09-03
  font-awesome-ttf = font-awesome; # 2018-02-25
  # 2019-10-31
  fontconfig-ultimate = throw ''
    fontconfig-ultimate has been removed. The repository has been archived upstream and activity has ceased for several years.
    https://github.com/bohoomil/fontconfig-ultimate/issues/171.
  '';
  fontconfig-penultimate = throw ''
    fontconfig-penultimate has been removed.
    It was a fork of the abandoned fontconfig-ultimate.
  '';
  # 2020-07-21
  fontconfig_210 = throw ''
    fontconfig 2.10.x hasn't had a release in years, is vulnerable to CVE-2016-5384
    and has only been used for old fontconfig caches.
  '';
  font-droid = throw "font-droid has been deprecated by noto-fonts"; # 2019-04-12
  foomatic_filters = foomatic-filters;  # 2016-08
  fuse_exfat = exfat;                   # 2015-09-11
  fuseki = apache-jena-fuseki; # added 2018-04-25
  fusesmb = throw "fusesmb is abandoned by upstream"; # added 2019-10-15
  fwupdate = throw "fwupdate was merged into fwupd"; # added 2020-05-19
  g4py = python3Packages.geant4; # added 2020-06-06
  gccApple = throw "gccApple is no longer supported"; # added 2018-04-25
  gdal_1_11 = throw "gdal_1_11 was removed. Use gdal instead."; # added 2021-04-03
  gdb-multitarget = gdb; # added 2017-11-13
  gdk_pixbuf = gdk-pixbuf; # added 2019-05-22
  gettextWithExpat = gettext; # 2016-02-19
  gitAndTools = self // { # added 2021-01-14
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  };
  glib_networking = glib-networking; # added 2018-02-25
  gmailieer = lieer; # added 2020-04-19
  gmvault = throw "gmvault has been removed because it is unmaintained, mostly broken, and insecure"; # added 2021-03-08
  gnome-mpv = celluloid; # added 2019-08-22
  gnome15 = throw "gnome15 has been removed from nixpkgs, as it's unmaintained and depends on deprecated libraries."; # added 2019-12-10
  gmic_krita_qt = gmic-qt-krita; # added 2019-09-07
  gnome-themes-standard = gnome-themes-extra; # added 2018-03-14
  gnome_doc_utils = gnome-doc-utils; # added 2018-02-25
  gnome_themes_standard = gnome-themes-standard; # added 2018-02-25
  gnunet_git = throw "gnunet_git was removed due to gnunet becoming stable"; # added 2019-05-27
  # Added 2020-10-16
  gnuradio-with-packages = gnuradio3_7.override {
    extraPackages = lib.attrVals [
      "osmosdr" "ais" "gsm" "nacl" "rds" "limesdr"
    ] gnuradio3_7Packages;
  };
  gnuradio-nacl = gnuradio3_7.pkgs.nacl; # added 2019-05-27, changed 2020-10-16
  gnuradio-gsm = gnuradio3_7.pkgs.gsm; # added 2019-05-27, changed 2020-10-16
  gnuradio-ais = gnuradio3_7.pkgs.ais; # added 2019-05-27, changed 2020-10-16
  gnuradio-limesdr = gnuradio3_7.pkgs.limesdr; # added 2019-05-27, changed 2020-10-16
  gnuradio-rds = gnuradio3_7.pkgs.rds; # added 2019-05-27, changed 2020-10-16
  gnuradio-osmosdr = gnuradio3_7.pkgs.osmosdr; # added 2019-05-27, changed 2020-10-16
  gr-nacl = gnuradio3_7.pkgs.nacl; # added 2019-05-27, changed 2020-10-16
  gr-gsm = gnuradio3_7.pkgs.gsm; # added 2019-05-27, changed 2020-10-16
  gr-ais = gnuradio3_7.pkgs.ais; # added 2019-05-27, changed 2020-10-16
  gr-limesdr = gnuradio3_7.pkgs.limesdr; # added 2019-05-27, changed 2020-10-16
  gr-rds = gnuradio3_7.pkgs.rds; # added 2019-05-27, changed 2020-10-16
  gr-osmosdr = gnuradio3_7.pkgs.osmosdr; # added 2019-05-27, changed 2020-10-16
  gnustep-make = gnustep.make; # added 2016-7-6
  gnupg20 = throw "gnupg20 has been removed from nixpkgs as upstream dropped support on 2017-12-31";# added 2020-07-12
  gnuvd = throw "gnuvd was removed because the backend service is missing"; # added 2020-01-14
  gmock = gtest; # moved from top-level 2021-03-14
  go_1_12 = throw "go_1_12 has been removed"; # added 2020-04-26
  go-pup = pup; # added 2017-12-19
  gobby5 = gobby; # added 2021-02-01
  gobjectIntrospection = gobject-introspection; # added 2018-12-02
  goimports = gotools; # added 2018-09-16
  gometalinter = throw "gometalinter was abandoned by upstream. Consider switching to golangci-lint instead"; # added 2020-04-23
  google-gflags = gflags; # added 2019-07-25
  google-music-scripts = throw "google-music-scripts has been removed because Google Play Music was discontinued"; # added 2021-03-07
  google-musicmanager = throw "google-musicmanager has been removed because Google Play Music was discontinued"; # added 2021-03-07
  googleAuthenticator = google-authenticator; # added 2016-10-16
  grantlee5 = libsForQt5.grantlee;  # added 2015-12-19
  gsettings_desktop_schemas = gsettings-desktop-schemas; # added 2018-02-25
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
  hal-flash = throw "hal-flash has been removed as Adobe Flash Player is now deprecated."; # added 2021-02-07
  heimdalFull = heimdal; # added 2018-05-01
  hepmc = hepmc2; # added 2019-08-05
  hexen = throw "hexen (SDL port) has been removed: abandoned by upstream."; # added 2019-12-11
  hicolor_icon_theme = hicolor-icon-theme; # added 2018-02-25
  ht-rust = xh; # added 2021-02-13
  htmlTidy = html-tidy;  # added 2014-12-06
  iana_etc = iana-etc;  # added 2017-03-08
  icedtea8_web = adoptopenjdk-icedtea-web; # added 2019-08-21
  icedtea_web = adoptopenjdk-icedtea-web; # added 2019-08-21
  idea = jetbrains; # added 2017-04-03
  imagemagick7_light = imagemagick_light; # added 2021-02-22
  imagemagick7 = imagemagick; # added 2021-02-22
  imagemagick7Big = imagemagickBig; # added 2021-02-22
  inboxer = throw "inboxer has been removed as it is no longer maintained and no longer works as Google shut down the inbox service this package wrapped.";
  infiniband-diags = rdma-core; # added 2019-08-09
  inotifyTools = inotify-tools;
  inter-ui = inter; # added 2021-03-27
  iproute = iproute2; # moved from top-level 2021-03-14
  i-score = throw "i-score has been removed: abandoned upstream."; # added 2020-11-21
  jack2Full = jack2; # moved from top-level 2021-03-14
  jamomacore = throw "jamomacore has been removed: abandoned upstream."; # added 2020-11-21
  jbidwatcher = throw "jbidwatcher was discontinued in march 2021"; # added 2021-03-15
  jbuilder = dune_1; # added 2018-09-09
  jikes = throw "jikes was deprecated on 2019-10-07: abandoned by upstream";
  joseki = apache-jena-fuseki; # added 2016-02-28
  json_glib = json-glib; # added 2018-02-25
  kdecoration-viewer = throw "kdecoration-viewer has been removed from nixpkgs, as there is no upstream activity"; # 2020-06-16
  k9copy = throw "k9copy has been removed from nixpkgs, as there is no upstream activity"; # 2020-11-06
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  julia_07 = throw "julia_07 is deprecated in favor of julia_10 LTS"; # added 2020-09-15
  julia_11 = throw "julia_11 is deprecated in favor of latest Julia version"; # added 2020-09-15
  kdeconnect = plasma5Packages.kdeconnect-kde; # added 2020-10-28
  kdiff3-qt5 = kdiff3; # added 2017-02-18
  keepass-keefox = keepass-keepassrpc; # backwards compatibility alias, added 2018-02
  keepassx-community = keepassxc; # added 2017-11
  keepassx-reboot = keepassx-community; # added 2017-02-01
  keepassx2-http = keepassx-reboot; # added 2016-10-17
  keybase-go = keybase;  # added 2016-08-24
  kinetic-cpp-client = throw "kinetic-cpp-client has been removed from nixpkgs, as it's abandoned."; # 2020-04-28
  kicad-with-packages3d = kicad; # added 2019-11-25
  kindlegen = throw "kindlegen has been removed from nixpkgs, as it's abandoned and no longer available for download."; # 2021-03-09
  krename-qt5 = krename; # added 2017-02-18
  kerberos = libkrb5; # moved from top-level 2021-03-14
  keymon = throw "keymon has been removed from nixpkgs, as it's abandoned and archived."; # 2019-12-10
  kramdown-rfc2629 = rubyPackages.kramdown-rfc2629; # added 2021-03-23
  kvm = qemu_kvm; # added 2018-04-25
  latinmodern-math = lmmath;
  letsencrypt = certbot; # added 2016-05-16
  libaudit = audit; # added 2018-04-25
  libcanberra_gtk2 = libcanberra-gtk2; # added 2018-02-25
  libcanberra_gtk3 = libcanberra-gtk3; # added 2018-02-25
  libcap_manpages = libcap.doc; # added 2016-04-29
  libcap_pam = if stdenv.isLinux then libcap.pam else null; # added 2016-04-29
  libcroco = throw "libcroco has been removed as it's no longer used in any derivations."; # added 2020-03-04
  libindicate = throw "libindacate has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # added 2019-12-10
  libindicate-gtk3 = throw "libindacate-gtk2 has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # added 2019-12-10
  libindicate-gtk2 = throw "libindacate-gtk3 has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # added 2019-12-10
  libcap_progs = libcap.out; # added 2016-04-29
  libdbusmenu_qt5 = libsForQt5.libdbusmenu;  # added 2015-12-19
  libdbusmenu-glib = libdbusmenu; # added 2018-05-01
  liberation_ttf_v1_from_source = liberation_ttf_v1; # added 2018-12-12
  liberation_ttf_v2_from_source = liberation_ttf_v2; # added 2018-12-12
  liberationsansnarrow = liberation-sans-narrow; # added 2018-12-12
  libgnome_keyring = libgnome-keyring; # added 2018-02-25
  libgnome_keyring3 = libgnome-keyring3; # added 2018-02-25
  libgumbo = gumbo; # added 2018-01-21
  libGL_driver = mesa.drivers; # added 2019-05-28
  libintlOrEmpty = lib.optional (!stdenv.isLinux || stdenv.hostPlatform.libc != "glibc") gettext; # added 2018-03-14
  libjpeg_drop = libjpeg_original; # added 2020-06-05
  libjson_rpc_cpp = libjson-rpc-cpp; # added 2017-02-28
  liblapackWithoutAtlas = lapack-reference; # added 2018-11-05
  liblastfm = libsForQt5.liblastfm; # added 2020-06-14
  liblrdf = lrdf; # added 2018-04-25
  libosmpbf = throw "libosmpbf was removed because it is no longer required by osrm-backend";
  libqrencode = qrencode;  # added 2019-01-01
  librdf = lrdf; # added 2020-03-22
  librecad2 = librecad;  # backwards compatibility alias, added 2015-10
  libsysfs = sysfsutils; # added 2018-04-25
  libtidy = html-tidy;  # added 2014-12-21
  libtxc_dxtn = throw "libtxc_dxtn was removed 2020-03-16, now integrated in Mesa";
  libtxc_dxtn_s2tc = throw "libtxc_dxtn_s2tc was removed 2020-03-16, now integrated in Mesa";
  libudev = udev; # added 2018-04-25
  libusb = libusb1; # added 2020-04-28
  libsexy = throw "libsexy has been removed from nixpkgs, as it's abandoned and no package needed it."; # 2019-12-10
  libstdcxxHook = throw "libstdcxx hook has been removed because cc-wrapper is now directly aware of the c++ standard library intended to be used."; # 2020-06-22
  libqmatrixclient = throw "libqmatrixclient was renamed to libquotient"; # added 2020-04-09
  lilypond-unstable = lilypond; # added 2021-03-11
  links = links2; # added 2016-01-31
  linux_rpi0 = linux_rpi1;
  linuxPackages_rpi0 = linuxPackages_rpi1;

  # added 2020-04-04
  linuxPackages_testing_hardened = throw "linuxPackages_testing_hardened has been removed, please use linuxPackages_latest_hardened";
  linux_testing_hardened = throw "linux_testing_hardened has been removed, please use linux_latest_hardened";

  linux-steam-integration = throw "linux-steam-integration has been removed, as the upstream project has been abandoned"; # added 2020-05-22
  loadcaffe = throw "loadcaffe has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  lprof = throw "lprof has been removed as it's unmaintained upstream and broken in nixpkgs since a while ago"; # added 2021-02-15
  lttngTools = lttng-tools;  # added 2014-07-31
  lttngUst = lttng-ust;  # added 2014-07-31
  lua5_1_sockets = lua51Packages.luasocket; # added 2017-05-02
  lua5_expat = luaPackages.luaexpat; # added 2017-05-02
  lua5_sec = luaPackages.luasec; # added 2017-05-02
  lxappearance-gtk3 = throw "lxappearance-gtk3 has been removed. Use lxappearance instead, which now defaults to Gtk3";  # added 2020-06-03
  lzma = xz; # moved from top-level 2021-03-14
  m3d-linux = m33-linux; # added 2016-08-13
  man_db = man-db; # added 2016-05
  manpages = man-pages; # added 2015-12-06
  marathon = throw "marathon has been removed from nixpkgs, as it's unmaintained"; # added 2020-08-15
  mysql = mariadb; # moved from top-level 2021-03-14
  mariadb-client = hiPrio mariadb.client; #added 2019.07.28
  matcha = throw "matcha was renamed to matcha-gtk-theme"; # added 2020-05-09
  mathics = throw "mathics has been removed from nixpkgs, as it's unmaintained"; # added 2020-08-15
  matrique = spectral; # added 2020-01-27
  mbedtls_1_3 = throw "mbedtls_1_3 is end of life, see https://tls.mbed.org/kb/how-to/upgrade-2.0"; # added 2019-12-08
  mess = mame; # added 2019-10-30
  mcgrid = throw "mcgrid has been removed from nixpkgs, as it's not compatible with rivet 3"; # added 2020-05-23
  mcomix = throw "mcomix has been removed from nixpkgs, as it's unmaintained; try mcomix3 a Python 3 fork"; # added 2019-12-10, modified 2020-11-25
  mirage = throw "mirage has been femoved from nixpkgs, as it's unmaintained"; # added 2019-12-10
  mopidy-gmusic = throw "mopidy-gmusic has been removed because Google Play Music was discontinued"; # added 2021-03-07
  mopidy-local-images = throw "mopidy-local-images has been removed as it's unmaintained. It's functionality has been merged into the mopidy-local extension."; # added 2020-10-18
  mopidy-local-sqlite = throw "mopidy-local-sqlite has been removed as it's unmaintained. It's functionality has been merged into the mopidy-local extension."; # added 2020-10-18
  mysql-client = hiPrio mariadb.client;
  memtest86 = memtest86plus; # added 2019-05-08
  mesa_noglu = mesa; # added 2019-05-28
  # NOTE: 2018-07-12: legacy alias:
  # grsecurity business is done: https://www.theregister.co.uk/2018/02/08/bruce_perens_grsecurity_anti_slapp/
  # floating point textures patents are expired,
  # so package reduced to alias
  mesa_drivers = mesa.drivers;
  mesos = throw "mesos has been removed from nixpkgs, as it's unmaintained"; # added 2020-08-15
  midoriWrapper = midori; # added 2015-01
  mist = throw "mist has been removed as the upstream project has been abandoned, see https://github.com/ethereum/mist#mist-browser-deprecated"; # added 2020-08-15
  mlt-qt5 = libsForQt5.mlt;  # added 2015-12-19
  mobile_broadband_provider_info = mobile-broadband-provider-info; # added 2018-02-25
  moby = throw "moby has been removed, merged into linuxkit in 2018.  Use linuxkit instead.";
  module_init_tools = kmod; # added 2016-04-22
  mono-zeroconf = throw "mono-zeroconf was deprecated on 2019-09-20: abandoned by upstream.";
  mozart = mozart2-binary; # added 2019-09-23
  mozart-binary = mozart2-binary; # added 2019-09-23
  mpd_clientlib = libmpdclient; # added 2021-02-11
  mpich2 = mpich;  # added 2018-08-06
  msf = metasploit; # added 2018-04-25
  libmsgpack = msgpack; # added 2018-08-17
  mssys = ms-sys; # added 2015-12-13
  mpv-with-scripts = self.wrapMpv self.mpv-unwrapped { }; # added 2020-05-22
  multipath_tools = multipath-tools;  # added 2016-01-21
  mupen64plus1_5 = mupen64plus; # added 2016-02-12
  mysqlWorkbench = mysql-workbench; # added 2017-01-19
  nagiosPluginsOfficial = monitoring-plugins;
  ncat = nmap;  # added 2016-01-26
  netcat-openbsd = libressl.nc; # added 2018-04-25
  netease-cloud-music = throw "netease-cloud-music has been removed together with deepin"; # added 2020-08-31
  networkmanager_fortisslvpn = networkmanager-fortisslvpn; # added 2018-02-25
  networkmanager_iodine = networkmanager-iodine; # added 2018-02-25
  networkmanager_l2tp = networkmanager-l2tp; # added 2018-02-25
  networkmanager_openconnect = networkmanager-openconnect; # added 2018-02-25
  networkmanager_openvpn = networkmanager-openvpn; # added 2018-02-25
  networkmanager_vpnc = networkmanager-vpnc; # added 2018-02-25
  neutral-style = throw "neural-style has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  nfsUtils = nfs-utils;  # added 2014-12-06
  nginxUnstable = nginxMainline; # added 2018-04-25
  nilfs_utils = nilfs-utils; # added 2018-04-25
  nix-review = nixpkgs-review; # added 2019-12-22
  nmap_graphical = nmap-graphical;  # added 2017-01-19
  nologin = shadow; # added 2018-04-25
  nxproxy = nx-libs; # added 2019-02-15
  nylas-mail-bin = throw "nylas-mail-bin was deprecated on 2019-09-11: abandoned by upstream";
  opencascade_oce = opencascade; # added 2018-04-25
  oblogout = throw "oblogout has been removed from nixpkgs, as it's archived upstream."; # added 2019-12-10
  opencl-icd = ocl-icd; # added 2017-01-20
  openexr_ctl = ctl; # added 2018-04-25
  openisns = open-isns; # added 2020-01-28
  openjpeg_1 = throw "openjpeg_1 has been removed, use openjpeg_2 instead"; # added 2021-01-24
  openjpeg_2 = openjpeg; # added 2021-01-25
  opensans-ttf = open-sans; # added 2018-12-04
  openssh_with_kerberos = openssh; # added 2018-01-28
  onnxruntime = throw "onnxruntime has been removed due to poor maintainability"; # added 2020-12-04
  osquery = throw "osquery has been removed."; # added 2019-11-24
  osxfuse = macfuse-stubs; # added 2021-03-20
  otter-browser = throw "otter-browser has been removed from nixpkgs, as it was unmaintained"; # added 2020-02-02
  owncloudclient = owncloud-client;  # added 2016-08
  p11_kit = p11-kit; # added 2018-02-25
  parity = openethereum; # added 2020-08-01
  parquet-cpp = arrow-cpp; # added 2018-09-08
  pass-otp = pass.withExtensions (ext: [ext.pass-otp]); # added 2018-05-04
  pdf2htmlEx = throw "pdf2htmlEx has been removed from nixpkgs, as it was unmaintained"; # added 2020-11-03
  perlXMLParser = perlPackages.XMLParser; # added 2018-10-12
  perlArchiveCpio = perlPackages.ArchiveCpio; # added 2018-10-12
  pgp-tools = signing-party; # added 2017-03-26
  pg_tmp = ephemeralpg; # added 2018-01-16

  php-embed = throw ''
    php*-embed has been dropped, you can build something similar
    with the following snippet:
    php74.override { embedSupport = true; apxs2Support = false; }
  ''; # added 2020-04-01
  php73-embed = php-embed; # added 2020-04-01
  php74-embed = php-embed; # added 2020-04-01

  phpPackages-embed = throw ''
    php*Packages-embed has been dropped, you can build something
    similar with the following snippet:
    (php74.override { embedSupport = true; apxs2Support = false; }).packages
  ''; # added 2020-04-01
  php74Packages-embed = phpPackages-embed;
  php73Packages-embed = phpPackages-embed;

  php-unit = throw ''
    php*-unit has been dropped, you can build something similar with
    the following snippet:
    php74.override {
      embedSupport = true;
      apxs2Support = false;
      systemdSupport = false;
      phpdbgSupport = false;
      cgiSupport = false;
      fpmSupport = false;
    }
  ''; # added 2020-04-01
  php73-unit = php-unit; # added 2020-04-01
  php74-unit = php-unit; # added 2020-04-01

  phpPackages-unit = throw ''
    php*Packages-unit has been dropped, you can build something
     similar with this following snippet:
    (php74.override {
      embedSupport = true;
      apxs2Support = false;
      systemdSupport = false;
      phpdbgSupport = false;
      cgiSupport = false;
      fpmSupport = false;
    }).packages
  ''; # added 2020-04-01
  php74Packages-unit = phpPackages-unit;
  php73Packages-unit = phpPackages-unit;

  pidgin-with-plugins = pidgin; # added 2016-06
  pidginlatex = pidgin-latex; # added 2018-01-08
  pidginlatexSF = pidgin-latex; # added 2014-11-02
  pidginmsnpecan = pidgin-msn-pecan; # added 2018-01-08
  pidginosd = pidgin-osd; # added 2018-01-08
  pidginotr = pidgin-otr; # added 2018-01-08
  pidginsipe = pidgin-sipe; # added 2018-01-08
  pidginwindowmerge = pidgin-window-merge; # added 2018-01-08
  piwik = matomo; # added 2018-01-16
  pkgconfig = pkg-config; # added 2018-02-02, moved to aliases.nix 2021-01-18
  pkgconfigUpstream = pkg-configUpstream; # added 2018-02-02
  planner = throw "planner has been removed from nixpkgs, as it is no longer developed and still uses python2/PyGTK."; # added 2021-02-02
  pltScheme = racket; # just to be sure
  plexpy = tautulli; # plexpy got renamed to tautulli, added 2019-02-22
  pmtools = acpica-tools; # added 2018-11-01
  polarssl = mbedtls; # added 2018-04-25
  poppler_qt5 = libsForQt5.poppler;  # added 2015-12-19
  postgresql95 = postgresql_9_5;
  postgresql96 = postgresql_9_6;
  postgresql100 = throw "postgresql100 was deprecated on 2018-10-21: use postgresql_10 instead";
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
  pinentry_curses = pinentry-curses; # added 2019-10-14
  pinentry_emacs = pinentry-emacs; # added 2019-10-14
  pinentry_gtk2 = pinentry-gtk2; # added 2019-10-14
  pinentry_qt = pinentry-qt; # added 2019-10-14
  pinentry_gnome = pinentry-gnome; # added 2019-10-14
  pinentry_qt5 = pinentry-qt; # added 2020-02-11
  postgis = postgresqlPackages.postgis;
  # end
  ppl-address-book = throw "ppl-address-book deprecated on 2019-05-02: abandoned by upstream.";
  processing3 = processing; # added 2019-08-16
  procps-ng = procps; # added 2018-06-08
  proj_5 = throw "Proj-5 has been removed from nixpkgs, use proj instead."; # added 2021-04-12
  prometheus-cups-exporter = throw "outdated and broken by design; removed by developer."; # added 2021-03-16
  pygmentex = texlive.bin.pygmentex; # added 2019-12-15
  pyload = throw "pyload has been removed from nixpkgs, as it was unmaintained."; # added 2021-03-21
  pyo3-pack = maturin;
  pmenu = throw "pmenu has been removed from nixpkgs, as its maintainer is no longer interested in the package."; # added 2019-12-10
  pulseaudioLight = pulseaudio; # added 2018-04-25
  pulseeffects = throw "Use pulseeffects-legacy if you use PulseAudio and pulseeffects-pw if you use PipeWire."; # added 2021-02-13, move back once we default to PipeWire audio server.
  phonon-backend-gstreamer = throw "phonon-backend-gstreamer: Please use libsForQt5.phonon-backend-gstreamer, as Qt4 support in this package has been removed."; # added 2019-11-22
  phonon-backend-vlc = throw "phonon-backend-vlc: Please use libsForQt5.phonon-backend-vlc, as Qt4 support in this package has been removed."; # added 2019-11-22
  phonon = throw "phonon: Please use libsForQt5.phonon, as Qt4 support in this package has been removed."; # added 2019-11-22
  pynagsystemd = throw "pynagsystemd was removed as it was unmaintained and incompatible with recent systemd versions. Instead use its fork check_systemd."; # added 2020-10-24
  python2nix = throw "python2nix has been removed as it is outdated. Use e.g. nixpkgs-pytools instead."; # added 2021-03-08
  qca-qt5 = libsForQt5.qca-qt5;  # added 2015-12-19
  qcsxcad = libsForQt5.qcsxcad;  # added 2020-11-05
  qmk_firmware = throw "qmk_firmware has been removed because it was broken"; # added 2021-04-02
  qr-filetransfer = throw ''"qr-filetransfer" has been renamed to "qrcp"''; # added 2020-12-02
  quake3game = ioquake3; # added 2016-01-14
  qvim = throw "qvim has been removed."; # added 2020-08-31
  qweechat = throw "qweechat has been removed because it was broken"; # added 2021-03-08
  qwt6 = libsForQt5.qwt;  # added 2015-12-19
  qtcurve = libsForQt5.qtcurve;  # added 2020-11-07
  qtpfsgui = throw "qtpfsgui is now luminanceHDR"; # added 2019-06-26
  quaternion-git = throw "quaternion-git has been removed in favor of the stable version 'quaternion'"; # added 2020-04-09
  raspberrypi-tools = throw "raspberrypi-tools has been removed in favor of identical 'libraspberrypi'"; # added 2020-12-24
  rdf4store = throw "rdf4store has been removed from nixpkgs."; # added 2019-12-21
  rdiff_backup = rdiff-backup;  # added 2014-11-23
  rdmd = dtools;  # added 2017-08-19
  rhc = throw "rhc was deprecated on 2019-04-09: abandoned by upstream.";
  rng_tools = rng-tools; # added 2018-10-24
  robomongo = robo3t; #added 2017-09-28
  rocm-runtime-ext = throw "rocm-runtime-ext has been removed, since its functionality was added to rocm-runtime"; #added 2020-08-21
  rssglx = rss-glx; #added 2015-03-25
  rssh = throw "rssh has been removed from nixpkgs: no upstream releases since 2012, several known CVEs"; # added 2020-08-25
  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtlwifi_new-firmware = rtw88-firmware; # added 2021-03-14
  recordmydesktop = throw "recordmydesktop has been removed from nixpkgs, as it's unmaintained and uses deprecated libraries"; # added 2019-12-10
  retroshare06 = retroshare;
  gtk-recordmydesktop = throw "gtk-recordmydesktop has been removed from nixpkgs, as it's unmaintained and uses deprecated libraries"; # added 2019-12-10
  qt-recordmydesktop = throw "qt-recordmydesktop has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # added 2019-12-10
  qt-3 = throw "qt-3 has been removed from nixpkgs, as it's unmaintained and insecure"; # added 2021-02-15
  rfkill = throw "rfkill has been removed, as it's included in util-linux"; # added 2020-08-23
  riak-cs = throw "riak-cs is not maintained anymore"; # added 2020-10-14
  radare2-cutter = cutter; # added 2021-03-30
  redkite = throw "redkite was archived by upstream"; # added 2021-04-12
  rkt = throw "rkt was archived by upstream"; # added 2020-05-16
  ruby_2_0_0 = throw "ruby_2_0_0 was deprecated on 2018-02-13: use a newer version of ruby";
  ruby_2_1_0 = throw "ruby_2_1_0 was deprecated on 2018-02-13: use a newer version of ruby";
  ruby_2_2_9 = throw "ruby_2_2_9 was deprecated on 2018-02-13: use a newer version of ruby";
  ruby_2_3_6 = throw "ruby_2_3_6 was deprecated on 2018-02-13: use a newer version of ruby";
  ruby_2_3 = throw "ruby_2_3 was deprecated on 2019-09-06: use a newer version of ruby";
  ruby_2_4_3 = throw "ruby_2_4_3 was deprecated on 2018-02-13: use a newer version of ruby";
  ruby_2_4 = throw "ruby_2_4 was deprecated in 2019-12: use a newer version of ruby";
  ruby_2_5_0 = throw "ruby_2_5_0 was deprecated on 2018-02-13: use a newer version of ruby";
  rubyPackages_2_4 = throw "rubyPackages_2_4 was deprecated in 2019-12: use a newer version of rubyPackages instead";
  ruby_2_5 = throw "ruby_2_5 was deprecated in 2021-02: use a newer version of ruby";
  rubyPackages_2_5 = throw "rubyPackages_2_5 was deprecated in 2021-02: use a newer version of rubyPackages instead";
  rubygems = throw "rubygems was deprecated on 2016-03-02: rubygems is now bundled with ruby";
  rubyMinimal = throw "rubyMinimal was removed due to being unused";
  rxvt_unicode-with-plugins = rxvt-unicode; # added 2020-02-02
  rxvt_unicode = rxvt-unicode-unwrapped; # added 2020-02-02
  subversion19 = throw "subversion19 has been removed as it has reached its end of life"; # added 2021-03-31
  urxvt_autocomplete_all_the_things = rxvt-unicode-plugins.autocomplete-all-the-things; # added 2020-02-02
  urxvt_perl = rxvt-unicode-plugins.perl; # added 2020-02-02
  urxvt_perls = rxvt-unicode-plugins.perls; # added 2020-02-02
  urxvt_tabbedex = rxvt-unicode-plugins.tabbedex; # added 2020-02-02
  urxvt_font_size = rxvt-unicode-plugins.font-size; # added 2020-02-02
  urxvt_theme_switch = rxvt-unicode-plugins.theme-switch; # added 2020-02-02
  urxvt_vtwheel = rxvt-unicode-plugins.vtwheel; # added 2020-02-02
  urxvt_bidi = rxvt-unicode-plugins.bidi; # added 2020-02-02
  s2n = s2n-tls; # added 2021-03-03
  s6Dns = s6-dns; # added 2018-07-23
  s6Networking = s6-networking; # added 2018-07-23
  s6LinuxUtils = s6-linux-utils; # added 2018-07-23
  s6PortableUtils = s6-portable-utils; # added 2018-07-23
  sagemath = sage; # added 2018-10-27
  sam = deadpixi-sam; # added 2018-04-25
  samba3 = throw "Samba 3 is discontinued, please switch to samba4"; # added 2019-10-15
  samba3_light = throw "Samba 3 is discontinued, please switch to samba4"; # added 2019-10-15
  sambaMaster = throw "sambaMaster was removed in 2019-09-13: outdated and no longer needed";
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver; # added 2016-01-25
  saneBackends = sane-backends; # added 2016-01-02
  saneBackendsGit = sane-backends; # added 2016-01-02
  sane-backends-git = sane-backends; # added 2021-02-19
  saneFrontends = sane-frontends; # added 2016-01-02
  sapic = throw "sapic was deprecated on 2019-1-19: sapic is bundled with 'tamarin-prover' now";
  scaff = throw "scaff is deprecated - replaced by https://gitlab.com/jD91mZM2/inc (not in nixpkgs yet)"; # added 2020-03-01
  scim = sc-im; # added 2016-01-22
  scollector = bosun; # added 2018-04-25
  sdlmame = mame; # added 2019-10-30
  seeks = throw "seeks has been removed from nixpkgs, as it was unmaintained"; # added 2020-06-21
  seg3d = throw "seg3d has been removed from nixpkgs (2019-11-10)";
  shared_mime_info = shared-mime-info; # added 2018-02-25
  skrooge2 = skrooge; # added 2017-02-18
  sky = throw "sky has been removed from nixpkgs (2020-09-16)";
  skype = skypeforlinux; # added 2017-07-27
  skype_call_recorder = throw "skype_call_recorder has been removed from nixpkgs, because it stopped working when classic Skype was retired."; # added 2020-10-31
  skydive = throw "skydive has been removed from nixpkgs (2019-09-10)";
  slack-dark = slack; # added 2020-03-27
  slic3r-prusa3d = prusa-slicer; # added 2019-05-21
  slurm-llnl = slurm; # renamed July 2017
  slurm-llnl-full = slurm-full; # renamed July 2017
  slurm-full = slurm; # added 2018-05-1
  smbclient = samba; # added 2018-04-25
  smugline = throw "smugline has been removed from nixpkgs, as it's unmaintained and depends on deprecated libraries."; # added 2020-11-04
  slim = throw "slim has been removed. Please use a different display-manager"; # added 2019-11-11
  slimThemes = throw "slimThemes has been removed because slim has been also"; # added 2019-11-11
  solr_8 = solr; # added 2021-01-30
  spectral = neochat; # added 2020-12-27
  sundials_3 = throw "sundials_3 was removed in 2020-02. outdated and no longer needed";

  # added 2020-02-10
  sourceHanSansPackages = {
    japanese = source-han-sans;
    korean = source-han-sans;
    simplified-chinese = source-han-sans;
    traditional-chinese = source-han-sans;
  };
  source-han-sans-japanese = source-han-sans;
  source-han-sans-korean = source-han-sans;
  source-han-sans-simplified-chinese = source-han-sans;
  source-han-sans-traditional-chinese = source-han-sans;
  sourceHanSerifPackages = {
    japanese = source-han-serif;
    korean = source-han-serif;
    simplified-chinese = source-han-serif;
    traditional-chinese = source-han-serif;
  };
  source-han-serif-japanese = source-han-serif;
  source-han-serif-korean = source-han-serif;
  source-han-serif-simplified-chinese = source-han-serif;
  source-han-serif-traditional-chinese = source-han-serif;

  net_snmp = net-snmp; # added 2019-12-21
  oracleXE = throw "oracleXE has been removed, as it's heavily outdated and unmaintained."; # added 2020-10-09
  spaceOrbit = space-orbit; # added 2016-05-23
  speech_tools = speech-tools; # added 2018-04-25
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  spice_gtk = spice-gtk; # added 2018-02-25
  spice_protocol = spice-protocol; # added 2018-02-25
  spidermonkey_38 = throw "spidermonkey_38 has been removed. Please use spidermonkey_78 instead."; # added 2021-03-21
  spidermonkey_52 = throw "spidermonkey_52 has been removed. Please use spidermonkey_78 instead."; # added 2019-10-16
  spidermonkey_60 = throw "spidermonkey_60 has been removed. Please use spidermonkey_78 instead."; # added 2021-03-21
  spring-boot = spring-boot-cli; # added 2020-04-24
  sqlite3_analyzer = sqlite-analyzer; # added 2018-05-22
  sqliteInteractive = sqlite-interactive;  # added 2014-12-06
  squid4 = squid;  # added 2019-08-22
  sshfsFuse = sshfs-fuse; # added 2016-09
  stanchion = throw "Stanchion was part of riak-cs which is not maintained anymore"; # added 2020-10-14
  surf-webkit2 = surf; # added 2017-04-02
  sup = throw "sup was deprecated on 2019-09-10: abandoned by upstream";
  swfdec = throw "swfdec has been removed as broken and unmaintained."; # added 2020-08-23
  swtpm-tpm2 = swtpm; # added 2021-02-26
  syncthing-cli = syncthing; # added 2021-04-06
  system_config_printer = system-config-printer;  # added 2016-01-03
  systemd-cryptsetup-generator = throw "systemd-cryptsetup-generator is now included in the systemd package"; # added 2020-07-12
  systemd_with_lvm2 = throw "systemd_with_lvm2 is obsolete, enabled by default via the lvm module"; # added 2020-07-12
  systool = sysfsutils; # added 2018-04-25
  tahoelafs = tahoe-lafs; # added 2018-03-26
  tangogps = foxtrotgps; # added 2020-01-26
  tdm = throw "tdm has been removed because nobody can figure out how to fix OpenAL integration. Use precompiled binary and `steam-run` instead.";
  telepathy_farstream = telepathy-farstream; # added 2018-02-25
  telepathy_gabble = telepathy-gabble; # added 2018-02-25
  telepathy_glib = telepathy-glib; # added 2018-02-25
  telepathy_haze = telepathy-haze; # added 2018-02-25
  telepathy_idle = telepathy-idle; # added 2018-02-25
  telepathy_logger = telepathy-logger; # added 2018-02-25
  telepathy_mission_control = telepathy-mission-control; # added 2018-02-25
  telepathy-qt = throw "telepathy-qt no longer supports Qt 4. Please use libsForQt5.telepathy instead."; # added 2020-07-02
  telepathy_qt = telepathy-qt; # added 2018-02-25
  telepathy_qt5 = libsForQt5.telepathy;  # added 2015-12-19
  telepathy_salut = telepathy-salut; # added 2018-02-25
  telnet = inetutils; # added 2018-05-15
  terraform-provider-ibm = terraform-providers.ibm; # added 2018-09-28
  terraform-provider-libvirt = terraform-providers.libvirt; # added 2018-09-28
  terraform-provider-lxd = terraform-providers.lxd; # added 2020-03-16
  terraform-provider-nixos = terraform-providers.nixos; # added 2018-09-28
  tesseract_4 = tesseract4; # added 2018-12-19
  testdisk-photorec = throw "testdisk-photorec: This package was a duplicate, please use testdisk or testdisk-qt instead"; # added 2019-10-13
  tex-gyre-bonum-math = tex-gyre-math.bonum; # added 2018-04-03
  tex-gyre-pagella-math = tex-gyre-math.pagella; # added 2018-04-03
  tex-gyre-schola-math = tex-gyre-math.schola; # added 2018-04-03
  tex-gyre-termes-math = tex-gyre-math.termes; # added 2018-04-03
  tftp_hpa = tftp-hpa; # added 2015-04-03
  timescale-prometheus = promscale; # added 2020-09-29
  tomcat85 = tomcat8; # added 2020-03-11
  torbrowser = tor-browser-bundle-bin; # added 2017-04-05
  torch = throw "torch has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  torch-hdf5 = throw "torch-hdf5 has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  torch-repl = throw "torch-repl has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  torchPackages = throw "torchPackages has been removed, as the upstream project has been abandoned"; # added 2020-03-28
  trang = jing-trang; # added 2018-04-25
  transcribe = throw "transcribe has been removed after being marked a broken for over a year"; # added 2020-09-16
  transmission_gtk = transmission-gtk; # added 2018-01-06
  transmission_remote_gtk = transmission-remote-gtk; # added 2018-01-06
  transmission-remote-cli = "transmission-remote-cli has been removed, as the upstream project has been abandoned. Please use tremc instead"; # added 2020-10-14
  transporter = throw "transporter has been removed. It was archived upstream, so it's considered abandoned.";
  trilium = throw "trilium has been removed. Please use trilium-desktop instead."; # added 2020-04-29
  truecrypt = veracrypt; # added 2018-10-24
  tshark = wireshark-cli; # added 2018-04-25
  tuijam = throw "tuijam has been removed because Google Play Music was discontinued"; # added 2021-03-07
  uberwriter = apostrophe; # added 2020-04-23
  ubootBeagleboneBlack = ubootAmx335xEVM; # added 2020-01-21
  ucsFonts = ucs-fonts; # added 2016-07-15
  ufraw = throw "ufraw is unmaintained and has been removed from nixpkgs. Its successor, nufraw, doesn't seem to be stable enough. Consider using Darktable for now."; # 2020-01-11
  ultrastardx-beta = ultrastardx; # added 2017-08-12
  unicorn-emu = unicorn; # added 2020-10-29
  unifiStable = unifi6; # added 2020-12-28
  untrunc = untrunc-anthwlock; # added 2021-02-01
  usb_modeswitch = usb-modeswitch; # added 2016-05-10
  usbguard-nox = usbguard; # added 2019-09-04
  utillinux = util-linux; # added 2020-11-24
  uzbl = throw "uzbl has been removed from nixpkgs, as it's unmaintained and uses insecure libraries";
  v4l_utils = v4l-utils; # added 2019-08-07
  v8_3_16_14 = throw "v8_3_16_14 was removed in 2019-11-01: no longer referenced by other packages";
  valadoc = throw "valadoc was deprecated on 2019-10-10: valadoc was merged into vala 0.38";
  vamp = { vampSDK = vamp-plugin-sdk; }; # added 2020-03-26
  venus = throw "venus has been removed from nixpkgs, as it's unmaintained"; # added 2021-02-05
  vdirsyncerStable  = vdirsyncer; # added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  vimbWrapper = vimb; # added 2015-01
  vimprobable2 = throw "vimprobable2 has been removed from nixpkgs. It relied on webkitgtk24x that has been removed."; # added 2019-12-05
  vimprobable2-unwrapped = vimprobable2; # added 2019-12-05
  virtviewer = virt-viewer; # added 2015-12-24
  virtmanager = virt-manager; # added 2019-10-29
  virtmanager-qt = virt-manager-qt; # added 2019-10-29
  vorbisTools = vorbis-tools; # added 2016-01-26
  webkit = webkitgtk; # added 2019-03-05
  webkitgtk24x-gtk3 = throw "webkitgtk24x-gtk3 has been removed because it's insecure. Please use webkitgtk."; # added 2019-12-05
  webkitgtk24x-gtk2 = throw "webkitgtk24x-gtk2 has been removed because it's insecure. Please use webkitgtk."; # added 2019-12-05
  weechat-matrix-bridge = weechatScripts.weechat-matrix-bridge; # added 2018-09-06
  wineStaging = wine-staging; # added 2018-01-08
  winusb = woeusb; # added 2017-12-22
  winswitch = throw "winswitch has been removed from nixpkgs."; # added 2019-12-10
  wireguard = wireguard-tools; # added 2018-05-19
  morituri = whipper; # added 2018-09-13
  xp-pen-g430 = pentablet-driver; # added 2020-05-03
  xdg_utils = xdg-utils; # added 2021-02-01
  xfceUnstable = xfce4-14; # added 2019-09-17
  xfce4-14 = xfce;
  xfce4-12 = throw "xfce4-12 has been replaced by xfce4-14"; # added 2020-03-14
  x11 = xlibsWrapper; # added 2015-09
  xara = throw "xara has been removed from nixpkgs. Unmaintained since 2006"; # added 2020-06-24
  xbmc = kodi; # added 2018-04-25
  xbmcPlain = kodiPlain; # added 2018-04-25
  xbmcPlugins = kodiPackages; # added 2018-04-25
  kodiPlugins = kodiPackages; # added 2021-03-09;
  xmonad_log_applet_gnome3 = xmonad_log_applet; # added 2018-05-01
  xmpppy = throw "xmpppy has been removed from nixpkgs as it is unmaintained and python2-only";
  pyIRCt = throw "pyIRCt has been removed from nixpkgs as it is unmaintained and python2-only";
  pyMAILt = throw "pyMAILt has been removed from nixpkgs as it is unmaintained and python2-only";
  xf86_video_nouveau = xorg.xf86videonouveau; # added 2015-09
  xf86_input_mtrack = throw ("xf86_input_mtrack has been removed from nixpkgs as it hasn't been maintained"
    + "and is broken. Working alternatives are libinput and synaptics.");
  xf86_input_multitouch = throw "xf86_input_multitouch has been removed from nixpkgs."; # added 2020-01-20
  xlibs = xorg; # added 2015-09
  xpraGtk3 = xpra; # added 2018-09-13
  xv = xxv; # added 2020-02-22
  yacc = bison; # moved from top-level 2021-03-14
  youtubeDL = youtube-dl;  # added 2014-10-26
  ytop = throw "ytop has been abandoned by upstream. Consider switching to bottom instead";
  yubikey-neo-manager = throw "yubikey-neo-manager has been removed because it was broken. Use yubikey-manager-qt instead."; # added 2021-03-08
  yuzu = yuzu-mainline; # added 2021-01-25
  zabbix30 = throw "Zabbix 3.0.x is end of life, see https://www.zabbix.com/documentation/5.0/manual/installation/upgrade/sources for a direct upgrade path to 5.0.x"; # added 2021-04-07
  zimreader = throw "zimreader has been removed from nixpkgs as it has been replaced by kiwix-serve and stopped working with modern zimlib versions."; # added 2021-03-28
  zdfmediathk = mediathekview; # added 2019-01-19

  gnome_user_docs = gnome-user-docs; # added 2019-11-20
  # spidermonkey is not ABI upwards-ompatible, so only allow this for nix-shell
  spidermonkey = spidermonkey_78; # added 2020-10-09
  libtorrentRasterbar = libtorrent-rasterbar; # added 2020-12-20
  libtorrentRasterbar-2_0_x = libtorrent-rasterbar-2_0_x; # added 2020-12-20
  libtorrentRasterbar-1_2_x = libtorrent-rasterbar-1_2_x; # added 2020-12-20
  libtorrentRasterbar-1_1_x = libtorrent-rasterbar-1_1_x; # added 2020-12-20

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

  # added 2019-08-01
  mumble_git = pkgs.mumble;
  murmur_git = pkgs.murmur;

  # added 2020-08-17
  zabbix44 = throw "zabbix44: Zabbix 4.4 is end of life, see https://www.zabbix.com/documentation/current/manual/installation/upgrade_notes_500 for details on upgrading to Zabbix 5.0.";

  # added 2019-09-06
  zeroc_ice = pkgs.zeroc-ice;

  # added 2020-06-22
  zeromq3 = throw "zeromq3 has been deprecated by zeromq4.";
  jzmq = throw "jzmq has been removed from nixpkgs, as it was unmaintained";
} // (with ocaml-ng; { # added 2016-09-14
  ocaml_4_00_1 = ocamlPackages_4_00_1.ocaml;
  ocaml_4_01_0 = ocamlPackages_4_01_0.ocaml;
  ocaml_4_02   = ocamlPackages_4_02.ocaml;
  ocaml_4_03   = ocamlPackages_4_03.ocaml;
}) // {

  # added 2019-10-28
  gnatsd = nats-server;

  # added 2020-01-10
  tor-browser-bundle = throw "tor-browser-bundle was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";
  # added 2020-01-10
  tor-browser-unwrapped = throw "tor-browser-unwrapped was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead. See #77452.";

  # added 2020-02-09
  dina-font-pcf = dina-font;

  # added 2019-04-13
  # *-polly pointed to llvmPackages_latest
  llvm-polly = throw "llvm-polly: clang is now built with polly-plugin by default";
  clang-polly = throw "clang-polly: clang is now built with polly-plugin by default";

  /* Cleanup before 20.09 */
  oraclejdk8psu = throw ''
    oraclejdk8psu: The *psu versions of oraclejdk aren't provided by upstream anymore and were therefore removed!
  '';
  oraclejre8psu = oraclejdk8psu;
  oraclejdk8psu_distro = oraclejdk8psu;

  dnscrypt-proxy = throw "dnscrypt-proxy has been removed. Please use dnscrypt-proxy2."; # added 2020-02-02
  sqldeveloper_18 = throw "sqldeveloper_18 is not maintained anymore!"; # added 2020-02-04

  gcc-snapshot = throw "gcc-snapshot: Marked as broken for >2 years, additionally this 'snapshot' pointed to a fairly old one from gcc7.";

  todolist = throw "todolist is now ultralist."; # added 2020-12-27

  /* Cleanup before 21.05 */
  riot-desktop = throw "riot-desktop is now element-desktop!";
  riot-web = throw "riot-web is now element-web";

  ant-dracula-theme = throw "ant-dracula-theme is now dracula-theme, and theme name is Dracula instead of Ant-Dracula.";

  /* Added 2021-01-02 */
  ttyrec = ovh-ttyrec;

  zplugin = zinit; # Added 2021-01-30

  /* If these are in the scope of all-packages.nix, they cause collisions
  between mixed versions of qt. See:
  https://github.com/NixOS/nixpkgs/pull/101369 */

  inherit (plasma5Packages) breeze-icons oxygen-icons5;
  inherit (plasma5Packages)
    akonadi akregator ark
    bomber bovo
    dolphin dragon
    elisa
    ffmpegthumbs filelight
    granatier gwenview
    k3b
    kaddressbook kalzium kapptemplate kapman kate katomic
    kblackbox kblocks kbounce
    kcachegrind kcalc kcharselect kcolorchooser
    kdenlive kdf kdialog kdiamond
    keditbookmarks
    kfind kfloppy
    kget kgpg
    khelpcenter
    kig kigo killbots kitinerary
    kleopatra klettres klines
    kmag kmail kmines kmix kmplot
    knavalbattle knetwalk knights
    kollision kolourpaint kompare konsole kontact korganizer
    kpkpass
    krdc kreversi krfb
    kshisen ksquares ksystemlog
    kteatime ktimer ktouch kturtle
    kwalletmanager kwave
    marble minuet
    okular
    picmi
    spectacle
    yakuake
  ;
  inherit (plasma5Packages)
    bluedevil breeze-gtk breeze-qt5 breeze-grub breeze-plymouth
    discover
    kactivitymanagerd
    kde-cli-tools kde-gtk-config kdeplasma-addons
    kgamma5
    kinfocenter
    kmenuedit
    kscreen kscreenlocker ksshaskpass ksysguard
    kwallet-pam kwayland-integration kwin kwrited
    milou
    oxygen
    plasma-browser-integration
    plasma-desktop
    plasma-integration
    plasma-nm
    plasma-pa
    plasma-systemmonitor
    plasma-thunderbolt
    plasma-vault
    plasma-workspace plasma-workspace-wallpapers
    polkit-kde-agent powerdevil
    qqc2-breeze-style
    sddm-kcm systemsettings
    xdg-desktop-portal-kde
  ;
  inherit (plasma5Packages.thirdParty)
    plasma-applet-caffeine-plus
    plasma-applet-virtual-desktop-bar
    kwin-dynamic-workspaces
    kwin-tiling
    krohnkite
  ;
  inherit (libsForQt5)
    sddm
  ;

})
