pkgs: with pkgs;

      ### Deprecated aliases - for backward compatibility

rec {
  adobeReader = adobe-reader;
  arduino_core = arduino-core;  # added 2015-02-04
  asciidocFull = asciidoc-full;  # added 2014-06-22
  bridge_utils = bridge-utils;  # added 2015-02-20
  buildbotSlave = buildbot-slave;  # added 2014-12-09
  cheetahTemplate = pythonPackages.cheetah; # 2015-06-15
  clangAnalyzer = clang-analyzer;  # added 2015-02-20
  cool-old-term = cool-retro-term; # added 2015-01-31
  cv = progress; # added 2015-09-06
  enblendenfuse = enblend-enfuse;	# 2015-09-30
  exfat-utils = exfat;                  # 2015-09-11
  firefoxWrapper = firefox-wrapper;
  fuse_exfat = exfat;                   # 2015-09-11
  haskell-ng = haskell;                 # 2015-04-19
  haskellngPackages = haskellPackages;  # 2015-04-19
  htmlTidy = html-tidy;  # added 2014-12-06
  inherit (haskell.compiler) jhc uhc;   # 2015-05-15
  inotifyTools = inotify-tools;
  jquery_ui = jquery-ui;  # added 2014-09-07
  libtidy = html-tidy;  # added 2014-12-21
  lttngTools = lttng-tools;  # added 2014-07-31
  lttngUst = lttng-ust;  # added 2014-07-31
  nfsUtils = nfs-utils;  # added 2014-12-06
  quassel_qt5 = kf5Packages.quassel_qt5; # added 2015-09-30
  quasselClient_qt5 = kf5Packages.quasselClient_qt5; # added 2015-09-30
  quasselDaemon_qt5 = kf5Packages.quasselDaemon; # added 2015-09-30
  quassel_kf5 = kf5Packages.quassel; # added 2015-09-30
  quasselClient_kf5 = kf5Packages.quasselClient; # added 2015-09-30
  rdiff_backup = rdiff-backup;  # added 2014-11-23
  rssglx = rss-glx; #added 2015-03-25
  rxvt_unicode_with-plugins = rxvt_unicode-with-plugins; # added 2015-04-02
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  sqliteInteractive = sqlite-interactive;  # added 2014-12-06
  x11 = xlibsWrapper; # added 2015-09
  xf86_video_nouveau = xorg.xf86videonouveau; # added 2015-09
  xlibs = xorg; # added 2015-09
  youtube-dl = pythonPackages.youtube-dl; # added 2015-06-07
  youtubeDL = youtube-dl;  # added 2014-10-26
}
