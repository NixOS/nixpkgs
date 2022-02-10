lib: self: super:

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute set
  # to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false
    then removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from all-packages.nix.
  checkInPkgs = n: alias:
    if builtins.hasAttr n super
    then throw "Alias ${n} is still in all-packages.nix"
    else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias:
      removeDistribute
        (removeRecurseForDerivations
          (checkInPkgs n alias)))
      aliases;
in

### Deprecated aliases - for backward compatibility
### Please maintain this list in ASCIIbetical ordering.
### Hint: the "sections" are delimited by ### <letter> ###

mapAliases ({
  # forceSystem should not be used directly in Nixpkgs.
  # Added 2018-07-16
  forceSystem = system: _:
    (import self.path { localSystem = { inherit system; }; });

  _0x0 = throw "0x0 upstream is abandoned and no longer exists: https://gitlab.com/somasis/scripts/";

  ### A ###

  accounts-qt = libsForQt5.accounts-qt; # Added 2015-12-19
  adobeReader = adobe-reader; # Added 2013-11-04
  adobe_flex_sdk = apache-flex-sdk; # Added 2018-06-01
  aesop = throw "aesop has been removed from nixpkgs, as it was unmaintained."; # Added 2021-08-05
  ag = silver-searcher; # Added 2018-04-25
  aircrackng = aircrack-ng; # Added 2016-01-14
  airtame = throw "airtame has been removed due to being unmaintained."; # Added 2022-01-19
  aleth = throw "aleth (previously packaged as cpp_ethereum) has been removed; abandoned upstream."; # Added 2020-11-30
  alienfx = throw "alienfx has been removed."; # Added 2019-12-08
  alsaLib = alsa-lib; # Added 2021-06-09
  alsaOss = alsa-oss; # Added 2021-06-10
  alsaPluginWrapper = alsa-plugins-wrapper; # Added 2021-06-10
  alsaPlugins = alsa-plugins; # Added 2021-06-10
  alsaTools = alsa-tools; # Added 2021-06-10
  alsaUtils = alsa-utils; # Added 2021-06-10
  amazon-glacier-cmd-interface = throw "amazon-glacier-cmd-interface has been removed due to it being unmaintained."; # Added 2020-10-30
  aminal = throw "aminal was renamed to darktile."; # Added 2021-09-28
  ammonite-repl = ammonite; # Added 2017-05-02
  amsn = throw "amsn has been removed due to being unmaintained."; # Added 2020-12-09
  angelfish = libsForQt5.plasmaMobileGear.angelfish; # Added 2021-10-06
  antimicro = throw "antimicro has been removed as it was broken, see antimicrox instead."; # Added 2020-08-06
  antimicroX = antimicrox; # Added 2021-10-31
  ardour_5 = throw "ardour_5 has been removed. see https://github.com/NixOS/nixpkgs/issues/139549"; # Added 2021-09-28
  arduino_core = arduino-core; # Added 2015-02-04
  arora = throw "arora has been removed."; # Added 2020-09-09
  asciidocFull = asciidoc-full; # Added 2014-06-22
  asn1c = throw "asn1c has been removed: deleted by upstream"; # Added 2022-01-07
  asterisk_15 = throw "asterisk_15: Asterisk 15 is end of life and has been removed."; # Added 2020-10-07
  at_spi2_atk = at-spi2-atk; # Added 2018-02-25
  at_spi2_core = at-spi2-core; # Added 2018-02-25
  aucdtect = throw "aucdtect: Upstream no longer provides download urls."; # Added 2020-12-26
  avldrums-lv2 = x42-avldrums; # Added 2020-03-29
  avxsynth = throw "avxsynth was removed because it was broken"; # Added 2021-05-18
  azureus = throw "azureus is now known as vuze and the version in nixpkgs was really outdated"; # Added 2021-08-02

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  bar-xft = lemonbar-xft; # Added 2015-01-16
  bashCompletion = bash-completion; # Added 2016-09-28
  bashInteractive_5 = bashInteractive; # Added 2021-08-20
  bash_5 = bash; # Added 2021-08-20
  bashburn = throw "bashburn has been removed: deleted by upstream"; # Added 2022-01-07
  batti = throw "batti has been removed from nixpkgs, as it was unmaintained"; # Added 2019-12-10
  bazaar = throw "bazaar has been deprecated by breezy."; # Added 2020-04-19
  bazaarTools = throw "bazaar has been deprecated by breezy."; # Added 2020-04-19
  bcat = throw "bcat has been removed because upstream is dead"; # Added 2021-08-22
  beegfs = throw "beegfs has been removed."; # Added 2019-11-24
  beret = throw "beret has been removed"; # Added 2021-11-16
  bin_replace_string = throw "bin_replace_string has been removed: deleted by upstream"; # Added 2022-01-07
  bitsnbots = throw "bitsnbots has been removed because it was broken and upstream missing"; # Added 2021-08-22
  blastem = throw "blastem has been removed from nixpkgs as it would still require python2."; # Added 2022-01-01
  bluezFull = bluez; # Added 2019-12-03
  bomi = throw "bomi has been removed from nixpkgs since it was broken and abandoned upstream"; # Added 2020-12-10
  bootchart = throw "bootchart has been removed from nixpkgs, as it is without a maintainer"; # Added 2019-12-10
  bpftool = bpftools; # Added 2021-05-03
  brackets = throw "brackets has been removed, it was unmaintained and had open vulnerabilities"; # Added 2021-01-24
  bridge_utils = bridge-utils; # Added 2015-02-20
  bro = zeek; # Added 2019-09-29
  btrfsProgs = btrfs-progs; # Added 2016-01-03

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = vaultwarden;
  bitwarden_rs-mysql = vaultwarden-mysql;
  bitwarden_rs-postgresql = vaultwarden-postgresql;
  bitwarden_rs-sqlite = vaultwarden-sqlite;
  bitwarden_rs-vault = vaultwarden-vault;

  blink = throw "blink has been removed from nixpkgs, it was unmaintained and required python2 at the time of removal."; # Added 2022-01-12
  bs1770gain = throw "bs1770gain has been removed from nixpkgs, as it had no maintainer or reverse dependencies."; # Added 2021-01-02
  bsod = throw "bsod has been removed: deleted by upstream"; # Added 2022-01-07
  btc1 = throw "btc1 has been removed, it was abandoned by upstream"; # Added 2020-11-03
  buildPerlPackage = perlPackages.buildPerlPackage; # Added 2018-10-12
  buildkite-agent3 = buildkite-agent; # Added 2018-09-26
  bundler_HEAD = bundler; # Added 2015-11-15
  bunny = throw "bunny has been removed: deleted by upstream"; # Added 2022-01-07
  bypass403 = throw "bypass403 has been removed: deleted by upstream"; # Added 2022-01-07

  ### C ###

  caddy1 = throw "caddy 1.x has been removed from nixpkgs, as it's unmaintained: https://github.com/caddyserver/caddy/blob/master/.github/SECURITY.md#supported-versions"; # Added 2020-10-02
  calibre-py2 = throw "calibre-py2 has been removed from nixpkgs, as calibre has upgraded to python 3. Please use calibre as replacement."; # Added 2021-01-13
  calibre-py3 = throw "calibre-py3 has been removed from nixpkgs, as calibre's default python version is now 3. Please use calibre as replacement."; # Added 2021-01-13
  cantarell_fonts = cantarell-fonts; # Added 2018-03-03
  cargo-tree = throw "cargo-tree has been removed, use the builtin `cargo tree` command instead."; # Added 2020-08-20
  casperjs = throw "casperjs has been removed, it was abandoned by upstream and broken.";
  catfish = xfce.catfish; # Added 2019-12-22
  ccnet = throw "ccnet has been removed because seafile does not depend on it anymore"; # Added 2021-03-25
  cde-gtk-theme = throw "cde-gtk-theme has been removed from nixpkgs as it shipped with python2 scripts that didn't work anymore."; # Added 2022-01-12
  cgmanager = throw "cgmanager was deprecated by lxc and therefore removed from nixpkgs."; # Added 2020-06-05
  checkbashism = checkbashisms; # Added 2016-08-16
  chronos = throw "chronos has been removed from nixpkgs, as it was unmaintained"; # Added 2020-08-15
  chunkwm = throw "chunkwm has been removed: abandoned by upstream"; # Added 2022-01-07
  cide = throw "cide was deprecated on 2019-09-11: abandoned by upstream";
  cifs_utils = cifs-utils; # Added 2016-08
  cinepaint = throw "cinepaint has been removed from nixpkgs, as it was unmaintained"; # Added 2019-12-10
  ckb = ckb-next; # Added 2018-10-21
  callPackage_i686 = pkgsi686Linux.callPackage;
  creddump = throw "creddump has been removed from nixpkgs as the upstream has abandoned the project."; # Added 2022-01-01

  # these are for convenience, not for backward compat and shouldn't expire
  clang5Stdenv = lowPrio llvmPackages_5.stdenv;
  clang6Stdenv = lowPrio llvmPackages_6.stdenv;
  clang7Stdenv = lowPrio llvmPackages_7.stdenv;
  clang8Stdenv = lowPrio llvmPackages_8.stdenv;
  clang9Stdenv = lowPrio llvmPackages_9.stdenv;
  clang10Stdenv = lowPrio llvmPackages_10.stdenv;
  clang11Stdenv = lowPrio llvmPackages_11.stdenv;
  clang12Stdenv = lowPrio llvmPackages_12.stdenv;

  clangAnalyzer = clang-analyzer; # Added 2015-02-20
  claws-mail-gtk2 = throw "claws-mail-gtk2 was removed to get rid of Python 2, please use claws-mail"; # Added 2021-12-05
  claws-mail-gtk3 = claws-mail; # Added 2021-07-10
  clawsMail = claws-mail; # Added 2016-04-29
  clutter_gtk = clutter-gtk; # Added 2018-02-25
  cmakeWithQt4Gui = throw "cmakeWithQt4Gui has been removed in favor of cmakeWithGui (Qt 5)"; # Added 2021-05
  codimd = hedgedoc; # Added 2020-11-29
  compton = picom; # Added 2019-12-02
  compton-git = compton; # Added 2019-05-20
  concurrencykit = libck; # Added 2021-03
  conntrack_tools = conntrack-tools; # Added 2018-05
  cool-old-term = cool-retro-term; # Added 2015-01-31
  coprthr = throw "coprthr has been removed."; # Added 2019-12-08
  coredumper = throw "coredumper has been removed: abandoned by upstream."; # Added 2019-11-16
  corsmisc = throw "corsmisc has been removed (upstream is gone)"; # Added 2022-01-24
  couchdb = throw "couchdb was removed from nixpkgs, use couchdb3 instead"; # Added 2021-03-03
  couchdb2 = throw "couchdb2 was removed from nixpkgs, use couchdb3 instead"; # Added 2021-03-03
  cpp-gsl = microsoft_gsl; # Added 2019-05-24
  cpp_ethereum = throw "cpp_ethereum has been removed; abandoned upstream."; # Added 2020-11-30
  cpuminer-multi = throw "cpuminer-multi has been removed: deleted by upstream"; # Added 2022-01-07
  crafty = throw "crafty has been removed: deleted by upstream"; # Added 2022-01-07
  cryptol = throw "cryptol was removed due to prolonged broken build"; # Added 2020-08-21

  # CUDA Toolkit

  cudatoolkit_6 = throw "cudatoolkit_6 has been removed in favor of newer versions"; # Added 2021-02-14
  cudatoolkit_65 = throw "cudatoolkit_65 has been removed in favor of newer versions"; # Added 2021-02-14
  cudatoolkit_7 = throw "cudatoolkit_7 has been removed in favor of newer versions"; # Added 2021-02-14
  cudatoolkit_7_5 = throw "cudatoolkit_7_5 has been removed in favor of newer versions"; # Added 2021-02-14
  cudatoolkit_8 = throw "cudatoolkit_8 has been removed in favor of newer versions"; # Added 2021-02-14
  cudatoolkit_9 = throw "cudatoolkit_9 has been removed in favor of newer versions"; # Added 2021-04-18
  cudatoolkit_9_0 = throw "cudatoolkit_9_0 has been removed in favor of newer versions"; # Added 2021-04-18
  cudatoolkit_9_1 = throw "cudatoolkit_9_1 has been removed in favor of newer versions"; # Added 2021-04-18
  cudatoolkit_9_2 = throw "cudatoolkit_9_2 has been removed in favor of newer versions"; # Added 2021-04-18
  cudnn6_cudatoolkit_8 = throw "cudnn6_cudatoolkit_8 has been removed in favor of newer versions"; # Added 2021-02-14
  cudnn_cudatoolkit_7 = throw "cudnn_cudatoolkit_7 has been removed in favor of newer versions"; # Added 2021-02-14
  cudnn_cudatoolkit_7_5 = throw "cudnn_cudatoolkit_7_5 has been removed in favor of newer versions"; # Added 2021-02-14
  cudnn_cudatoolkit_8 = throw "cudnn_cudatoolkit_8 has been removed in favor of newer versions"; # Added 2021-02-14
  cudnn_cudatoolkit_9 = throw "cudnn_cudatoolkit_9 has been removed in favor of newer versions"; # Added 2021-04-18
  cudnn_cudatoolkit_9_0 = throw "cudnn_cudatoolkit_9_0 has been removed in favor of newer versions"; # Added 2021-04-18
  cudnn_cudatoolkit_9_1 = throw "cudnn_cudatoolkit_9_1 has been removed in favor of newer versions"; # Added 2021-04-18
  cudnn_cudatoolkit_9_2 = throw "cudnn_cudatoolkit_9_2 has been removed in favor of newer versions"; # Added 2021-04-18

  cloud-print-connector = throw "Google Cloudprint is officially discontinued since Jan 2021, more info https://support.google.com/chrome/a/answer/9633006";
  cquery = throw "cquery has been removed because it is abandoned by upstream. Consider switching to clangd or ccls instead."; # Added 2020-06-15
  cups-googlecloudprint = throw "Google Cloudprint is officially discontinued since Jan 2021, more info https://support.google.com/chrome/a/answer/9633006";
  cupsBjnp = cups-bjnp; # Added 2016-01-02
  cups_filters = cups-filters; # Added 2016-08
  curaByDagoma = throw "curaByDagoma has been removed from nixpkgs, because it was unmaintained and dependent on python2 packages."; # Added 2022-01-12
  curaLulzbot = throw "curaLulzbot has been removed due to insufficient upstream support for a modern dependency chain"; # Added 2021-10-23
  cv = progress; # Added 2015-09-06
  cvs_fast_export = cvs-fast-export; # Added 2021-06-10

  ### D ###

  d1x_rebirth = dxx-rebirth; # Added 2018-04-25
  d2x_rebirth = dxx-rebirth; # Added 2018-04-25
  dart_dev = throw "Non-stable versions of Dart have been removed."; # Added 2020-01-15
  dart_old = throw "Non-stable versions of Dart have been removed."; # Added 2020-01-15
  dart_stable = dart; # Added 2020-01-15
  dat = nodePackages.dat;
  dbus_daemon = dbus.daemon; # Added 2018-04-25
  dbus_glib = dbus-glib; # Added 2018-02-25
  dbus_libs = dbus; # Added 2018-04-25
  dbus_tools = dbus.out; # Added 2018-04-25
  dbvisualizer = throw "dbvisualizer has been removed from nixpkgs, as it's unmaintained"; # Added 2020-09-20
  deadbeef-mpris2-plugin = deadbeefPlugins.mpris2; # Added 2018-02-23
  deadpixi-sam = deadpixi-sam-unstable;

  debian_devscripts = debian-devscripts; # added 2016-03-23
  debugedit-unstable = debugedit; # Added 2021-11-22
  deepin = throw "deepin was a work in progress and it has been canceled and removed https://github.com/NixOS/nixpkgs/issues/94870"; # added 2020-08-31
  deepspeech = throw "deepspeech was removed in favor of stt. https://github.com/NixOS/nixpkgs/issues/119496"; # added 2021-05-05
  deisctl = throw "deisctl was removed ; the service does not exist anymore"; # added 2022-02-06
  deis = throw "deis was removed ; the service does not exist anymore"; # added 2022-02-06
  deltachat-electron = deltachat-desktop; # added 2021-07-18
  diffuse = throw "diffuse has been removed from nixpkgs, as it's unmaintained"; # Added 2019-12-10

  deluge-1_x = throw ''
    Deluge 1.x (deluge-1_x) is no longer supported.
    Please use Deluge 2.x (deluge-2_x) instead, for example:

        services.deluge.package = pkgs.deluge-2_x;

    Note that it is NOT possible to switch back to Deluge 1.x after this change.
  ''; # Added 2021-08-18

  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  desktop_file_utils = desktop-file-utils; # Added 2018-02-25
  devicemapper = lvm2; # Added 2018-04-25
  digikam5 = digikam; # Added 2017-02-18
  displaycal = throw "displaycal has been removed from nixpkgs, as it hasn't migrated to python3."; # Added 2022-01-12
  dmtx = dmtx-utils; # Added 2018-04-25
  dnnl = oneDNN; # Added 2020-04-22
  docbook5_xsl = docbook_xsl_ns; # Added 2018-04-25
  docbookrx = throw "docbookrx has been removed since it was unmaintained"; # Added 2021-01-12
  docbook_xml_xslt = docbook_xsl; # Added 2018-04-25
  docker_compose = docker-compose; # Added 2018-11-10
  dolphinEmu = dolphin-emu; # Added 2021-11-10
  dolphinEmuMaster = dolphin-emu-beta; # Added 2021-11-10
  dotnet-netcore = dotnet-runtime; # Added 2021-10-07
  double_conversion = double-conversion; # Added 2017-11-22
  draftsight = throw "draftsight has been removed, no longer available as freeware"; # Added 2020-08-14
  dvb_apps = throw "dvb_apps has been removed."; # Added 2020-11-03
  dwarf_fortress = dwarf-fortress; # Added 2016-01-23
  dwm-git = throw "dwm-git has been removed from nixpkgs, as it had no updates for 2 years not serving it's purpose."; # Added 2021-02-07
  dylibbundler = macdylibbundler; # Added 2021-04-24

  ### E ###


  ec2_ami_tools = ec2-ami-tools; # Added 2021-10-08
  ec2_api_tools = ec2-api-tools; # Added 2021-10-08
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01
  elasticmq = throw "elasticmq has been removed in favour of elasticmq-server-bin"; # Added 2021-01-17
  elasticsearch7-oss = throw "elasticsearch7-oss has been removed, as the distribution is no longer provided by upstream. https://github.com/NixOS/nixpkgs/pull/114456"; # Added 2021-06-09

  # Electron
  electron_3 = throw "electron_3 has been removed in favor of newer versions"; # Added 2021-01-06
  electron_4 = throw "electron_4 has been removed in favor of newer versions"; # Added 2021-01-06
  electron_5 = throw "electron_5 has been removed in favor of newer versions"; # Added 2021-01-06
  electron_6 = throw "electron_6 has been removed in favor of newer versions"; # Added 2021-01-06

  electrum-dash = throw "electrum-dash has been removed from nixpkgs as the project is abandoned."; # Added 2022-01-01

  # Emacs
  emacs27Packages = emacs27.pkgs; # Added 2020-12-18
  emacs27WithPackages = emacs27.pkgs.withPackages; # Added 2020-12-18
  emacsPackages = emacs.pkgs; # Added 2020-12-18
  emacsPackagesGen = emacsPackagesFor; # Added 2018-08-18
  emacsPackagesNg = emacs.pkgs; # Added 2019-08-07
  emacsPackagesNgFor = emacsPackagesFor; # Added 2019-08-07
  emacsPackagesNgGen = emacsPackagesFor; # Added 2018-08-18
  emacsWithPackages = emacs.pkgs.withPackages; # Added 2020-12-18

  enblendenfuse = enblend-enfuse; # Added 2015-09-30
  encryptr = throw "encryptr was removed because it reached end of life"; # Added 2022-02-06
  envelope = throw "envelope has been removed from nixpkgs, as it was unmaintained."; # Added 2021-08-05
  epoxy = libepoxy; # Added 2021-11-11
  esniper = throw "esniper has been removed because upstream no longer maintains it (and it no longer works)"; # Added 2021-04-12
  etcdctl = etcd; # Added 2018-04-25
  euca2tools = throw "euca2ools has been removed because it is unmaintained upstream and still uses python2."; # Added 2022-01-01
  evilvte = throw "evilvte has been removed from nixpkgs for being unmaintained with security issues and dependant on an old version of vte which was removed."; # Added 2022-01-14
  evolution_data_server = evolution-data-server; # Added 2018-02-25
  exfat-utils = exfat; # Added 2015-09-11

  ### F ###

  facette = throw "facette has been removed."; # Added 2020-01-06
  fast-neural-doodle = throw "fast-neural-doodle has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  fastnlo = fastnlo_toolkit; # Added 2021-04-24
  fedora-coreos-config-transpiler = throw "fedora-coreos-config-transpiler has been renamed to 'butane'."; # Added 2021-04-13
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H.";
  ffadoFull = ffado; # Added 2018-05-01
  firefox-esr-68 = throw "Firefox 68 ESR was removed because it reached end of life with its final release 68.12esr on 2020-08-25.";
  firefox-esr-wrapper = firefox-esr; # Added 2016-01
  firefoxWrapper = firefox; # Added 2015-09
  firefox-wrapper = firefox; # Added 2016-01
  firestr = throw "firestr has been removed."; # Added 2019-12-08
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fish-foreign-env = throw "fish-foreign-env has been replaced with fishPlugins.foreign-env"; # Added 2020-12-29, modified 2021-01-10
  flameGraph = flamegraph; # Added 2018-04-25
  flashplayer-standalone-debugger = throw "flashplayer-standalone-debugger has been removed as Adobe Flash Player is now deprecated."; # Added 2021-02-07
  flashplayer-standalone = throw "flashplayer-standalone has been removed as Adobe Flash Player is now deprecated."; # Added 2021-02-07
  flashplayer = throw "flashplayer has been removed as Adobe Flash Player is now deprecated."; # Added 2021-02-07
  flashtool = throw "flashtool was removed from nixpkgs, because the download is down for copyright reasons and the site looks very fishy"; # Added 2021-06-31
  flink_1_5 = throw "flink_1_5 was removed, use flink instead"; # Added 2021-01-25
  flutter-beta = throw "Non-stable versions of Flutter have been removed. You can use flutterPackages.mkFlutter to generate a package for other Flutter versions."; # Added 2020-01-15
  flutter-dev = throw "Non-stable versions of Flutter have been removed. You can use flutterPackages.mkFlutter to generate a package for other Flutter versions."; # Added 2020-01-15
  flvtool2 = throw "flvtool2 has been removed."; # Added 2020-11-03
  fme = throw "fme was removed, because it is old and uses Glade, a discontinued library."; # Added 2022-01-26
  foldingathome = fahclient; # Added 2020-09-03
  font-awesome-ttf = font-awesome; # Added 2018-02-25

  fontconfig-ultimate = throw ''
    fontconfig-ultimate has been removed. The repository has been archived upstream and activity has ceased for several years.
    https://github.com/bohoomil/fontconfig-ultimate/issues/171.
  ''; # Added 2019-10-31

  fontconfig-penultimate = throw ''
    fontconfig-penultimate has been removed.
    It was a fork of the abandoned fontconfig-ultimate.
  ''; # Added 2020-07-21

  fontconfig_210 = throw ''
    fontconfig 2.10.x hasn't had a release in years, is vulnerable to CVE-2016-5384
    and has only been used for old fontconfig caches.
  '';

  foomatic_filters = foomatic-filters; # Added 2016-08
  fscryptctl-experimental = throw "The package fscryptctl-experimental has been removed. Please switch to fscryptctl."; # Added 2021-11-07
  fsharp41 = throw "fsharp41 has been removed, please use dotnet-sdk_5 or later";
  fslint = throw "fslint has been removed: end of life. Upstream recommends using czkawka (https://qarmin.github.io/czkawka/) instead"; # Added 2022-01-15
  fuse_exfat = exfat; # Added 2015-09-11
  fuseki = apache-jena-fuseki; # Added 2018-04-25
  fwupdate = throw "fwupdate was merged into fwupd"; # Added 2020-05-19

  ### G ###

  g4py = python3Packages.geant4; # Added 2020-06-06
  gaia = throw "gaia has been removed because it seems abandoned upstream and uses no longer supported dependencies"; # Added 2020-06-06
  gdal_1_11 = throw "gdal_1_11 was removed. Use gdal instead."; # Added 2021-04-03
  gdb-multitarget = gdb; # Added 2017-11-13
  gdk_pixbuf = gdk-pixbuf; # Added 2019-05-22
  getmail = throw "getmail has been removed from nixpkgs, migrate to getmail6."; # Added 2022-01-12
  gettextWithExpat = gettext; # Added 2016-02-19
  gfm = throw "gfm has been removed"; # Added 2021-01-15
  giblib = throw " giblib has been removed from nixpkgs because upstream is gone."; # Added 2022-01-23
  giflib_4_1 = throw "giflib_4_1 has been removed; use giflib instead"; # Added 2020-02-12
  git-bz = throw "giz-bz has been removed from nixpkgs as it is stuck on python2."; # Added 2022-01-01

  gitAndTools = self // {
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  }; # Added 2021-01-14

  gitin = throw "gitin has been remove because it was unmaintained and depended on an insecure version of libgit2"; # Added 2021-12-07
  gitinspector = throw "gitinspector has been removed because it doesn't work with python3."; # Added 2022-01-12
  gksu = throw "gksu has been removed"; # Added 2022-01-16
  glib_networking = glib-networking; # Added 2018-02-25
  gmailieer = lieer; # Added 2020-04-19
  gmic_krita_qt = gmic-qt-krita; # Added 2019-09-07
  gmvault = throw "gmvault has been removed because it is unmaintained, mostly broken, and insecure"; # Added 2021-03-08
  gnash = throw "gnash has been removed; broken and abandoned upstream."; # added 2022-02-06
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome-mpv = celluloid; # Added 2019-08-22
  gnome-sharp = throw "gnome-sharp has been removed from nixpkgs"; # Added 2022-01-15
  gnome-themes-standard = gnome-themes-extra; # Added 2018-03-14
  gnome_user_docs = gnome-user-docs; # Added 2019-11-20
  gnome15 = throw "gnome15 has been removed from nixpkgs, as it's unmaintained and depends on deprecated libraries."; # Added 2019-12-10
  gnome_doc_utils = gnome-doc-utils; # Added 2018-02-25
  gnome_themes_standard = gnome-themes-standard; # Added 2018-02-25
  gnunet_git = throw "gnunet_git was removed due to gnunet becoming stable"; # Added 2019-05-27

  gnuradio-with-packages = gnuradio3_7.override {
    extraPackages = lib.attrVals [
      "osmosdr" "ais" "gsm" "nacl" "rds" "limesdr"
    ] gnuradio3_7Packages;
  }; # Added 2020-10-16

  gmock = gtest; # moved from top-level 2021-03-14

  gnome3 = gnome; # Added 2021-05-07
  gnupg20 = throw "gnupg20 has been removed from nixpkgs as upstream dropped support on 2017-12-31";# Added 2020-07-12
  gnuradio3_7 = throw "gnuradio3_7 has been removed because it required Python 2"; # Added 2022-01-16
  gnuradio-ais = gnuradio3_7.pkgs.ais; # Added 2019-05-27, changed 2020-10-16
  gnuradio-gsm = gnuradio3_7.pkgs.gsm; # Added 2019-05-27, changed 2020-10-16
  gnuradio-limesdr = gnuradio3_7.pkgs.limesdr; # Added 2019-05-27, changed 2020-10-16
  gnuradio-nacl = gnuradio3_7.pkgs.nacl; # Added 2019-05-27, changed 2020-10-16
  gnuradio-osmosdr = gnuradio3_7.pkgs.osmosdr; # Added 2019-05-27, changed 2020-10-16
  gnuradio-rds = gnuradio3_7.pkgs.rds; # Added 2019-05-27, changed 2020-10-16
  gnustep-make = gnustep.make; # Added 2016-7-6
  gnuvd = throw "gnuvd was removed because the backend service is missing"; # Added 2020-01-14
  go_1_12 = throw "go_1_12 has been removed"; # Added 2020-04-26
  gobby5 = gobby; # Added 2021-02-01
  gobjectIntrospection = gobject-introspection; # Added 2018-12-02
  gogoclient = throw "gogoclient has been removed, because it was unmaintained"; # Added 2021-12-15
  goimports = gotools; # Added 2018-09-16
  gometalinter = throw "gometalinter was abandoned by upstream. Consider switching to golangci-lint instead"; # Added 2020-04-23
  googleAuthenticator = google-authenticator; # Added 2016-10-16
  googleearth = throw "the non-pro version of Google Earth was removed because it was discontinued and downloading it isn't possible anymore"; # Added 2022-01-22
  google-gflags = gflags; # Added 2019-07-25
  google-musicmanager = throw "google-musicmanager has been removed because Google Play Music was discontinued"; # Added 2021-03-07
  google-music-scripts = throw "google-music-scripts has been removed because Google Play Music was discontinued"; # Added 2021-03-07
  go-pup = pup; # Added 2017-12-19
  gpgstats = throw "gpgstats has been removed: upstream is gone"; # Added 2022-02-06

  graalvm11 = graalvm11-ce;
  graalvm8-ce = throw "graalvm8-ce has been removed by upstream."; # Added 2021-10-19
  graalvm8 = throw "graalvm8-ce has been removed by upstream."; # Added 2021-10-19
  gr-ais = gnuradio3_7.pkgs.ais; # Added 2019-05-27, changed 2020-10-16
  grantlee5 = libsForQt5.grantlee; # Added 2015-12-19
  gr-gsm = gnuradio3_7.pkgs.gsm; # Added 2019-05-27, changed 2020-10-16
  grib-api = throw "grib-api has been replaced by ecCodes => https://confluence.ecmwf.int/display/ECC/GRIB-API+migration"; # Added 2022-01-05
  gr-limesdr = gnuradio3_7.pkgs.limesdr; # Added 2019-05-27, changed 2020-10-16
  gr-nacl = gnuradio3_7.pkgs.nacl; # Added 2019-05-27, changed 2020-10-16
  gr-osmosdr = gnuradio3_7.pkgs.osmosdr; # Added 2019-05-27, changed 2020-10-16
  gr-rds = gnuradio3_7.pkgs.rds; # Added 2019-05-27, changed 2020-10-16
  gsettings_desktop_schemas = gsettings-desktop-schemas; # Added 2018-02-25
  gtk_doc = gtk-doc; # Added 2018-02-25
  gtklick = throw "gtklick has been removed from nixpkgs as the project is stuck on python2"; # Added 2022-01-01
  gtk-recordmydesktop = throw "gtk-recordmydesktop has been removed from nixpkgs, as it's unmaintained and uses deprecated libraries"; # Added 2019-12-10
  guileCairo = guile-cairo; # Added 2017-09-24
  guile-gnome = throw "guile-gnome has been removed"; # Added 2022-01-16
  guileGnome = throw "guile-gnome has been removed"; # Added 2022-01-16
  guile_lib = guile-lib; # Added 2017-09-24
  guileLint = guile-lint; # Added 2017-09-27
  guile_ncurses = guile-ncurses; # Added 2017-09-24
  gupnp_av = gupnp-av; # Added 2018-02-25
  gupnp_dlna = gupnp-dlna; # Added 2018-02-25
  gupnp_igd = gupnp-igd; # Added 2018-02-25
  gupnptools = gupnp-tools; # Added 2015-12-19
  gutenberg = zola; # Added 2018-11-17
  gwtdragdrop = throw "gwtdragdrop was removed: abandoned by upstream"; # Added 2022-02-06
  gwtwidgets = throw "gwtwidgets was removed: unmaintained"; # Added 2022-02-06

  ### H ###

  hal-flash = throw "hal-flash has been removed as Adobe Flash Player is now deprecated."; # Added 2021-02-07
  hawkthorne = throw "hawkthorne has been removed because it depended on a broken version of love"; # Added 2022-01-15
  heimdalFull = heimdal; # Added 2018-05-01
  heme = throw "heme has been removed: upstream is gone"; # added 2022-02-06
  hepmc = hepmc2; # Added 2019-08-05
  hexen = throw "hexen (SDL port) has been removed: abandoned by upstream."; # Added 2019-12-11
  hicolor_icon_theme = hicolor-icon-theme; # Added 2018-02-25
  holochain-go = throw "holochain-go was abandoned by upstream"; # Added 2022-01-01
  htmlTidy = html-tidy; # Added 2014-12-06
  ht-rust = xh; # Added 2021-02-13
  hydra-flakes = throw "hydra-flakes: Flakes support has been merged into Hydra's master. Please use `hydra-unstable` now."; # Added 2020-04-06

  ### I ###

  iana_etc = iana-etc; # Added 2017-03-08
  iasl = throw "iasl has been removed, use acpica-tools instead"; # Added 2021-08-08
  icedtea8_web = adoptopenjdk-icedtea-web; # Added 2019-08-21
  icedtea_web = adoptopenjdk-icedtea-web; # Added 2019-08-21
  idea = jetbrains; # Added 2017-04-03
  imagemagick7Big = imagemagickBig; # Added 2021-02-22
  imagemagick7 = imagemagick; # Added 2021-02-22
  imagemagick7_light = imagemagick_light; # Added 2021-02-22
  impressive = throw "impressive has been removed due to lack of released python 2 support and maintainership in nixpkgs"; # Added 2022-01-27
  i-score = throw "i-score has been removed: abandoned upstream."; # Added 2020-11-21
  inboxer = throw "inboxer has been removed as it is no longer maintained and no longer works as Google shut down the inbox service this package wrapped.";
  infiniband-diags = rdma-core; # Added 2019-08-09
  ino = throw "ino has been removed from nixpkgs, the project is stuck on python2 and upstream has archived the project."; # Added 2022-01-12
  inotifyTools = inotify-tools;
  inter-ui = inter; # Added 2021-03-27
  iops = throw "iops was removed: upstream is gone"; # Added 2022-02-06
  iproute = iproute2; # moved from top-level 2021-03-14
  ipsecTools = throw "ipsecTools has benn removed, because it was no longer maintained upstream"; # Added 2021-12-15

  ### J ###


  jack2Full = jack2; # moved from top-level 2021-03-14
  jamomacore = throw "jamomacore has been removed: abandoned upstream."; # Added 2020-11-21
  jbidwatcher = throw "jbidwatcher was discontinued in march 2021"; # Added 2021-03-15
  jbuilder = dune_1; # Added 2018-09-09
  jellyfin_10_5 = throw "Jellyfin 10.5 is no longer supported and contains a security vulnerability. Please upgrade to a newer version."; # Added 2021-04-26
  jikes = throw "jikes was deprecated on 2019-10-07: abandoned by upstream";
  joseki = apache-jena-fuseki; # Added 2016-02-28
  journalbeat7 = throw "journalbeat has been removed upstream. Use filebeat with the journald input instead.";

  # Julia
  julia_07 = throw "julia_07 has been deprecated in favor of the latest LTS version"; # Added 2020-09-15
  julia_1 = throw "julia_1 has been deprecated in favor of julia_10 as it was ambiguous"; # Added 2021-03-13
  julia_11 = throw "julia_11 has been deprecated in favor of the latest stable version"; # Added 2020-09-15
  julia_13 = throw "julia_13 has been deprecated in favor of the latest stable version"; # Added 2021-03-13
  julia_10-bin = throw "julia_10-bin has been deprecated in favor of the latest LTS version"; # Added 2021-12-02

  json_glib = json-glib; # Added 2018-02-25
  jvmci8 = throw "graalvm8 and its tools were deprecated in favor of graalvm8-ce"; # Added 2021-10-15

  ### K ###

  k3d = throw "k3d has been removed because it was broken and has seen no release since 2016"; # Added 2022-01-04
  k9copy = throw "k9copy has been removed from nixpkgs, as there is no upstream activity"; # Added 2020-11-06
  kafkacat = kcat; # Added 2021-10-07
  kbdKeymaps = throw "kbdKeymaps is not needed anymore since dvp and neo are now part of kbd"; # Added 2021-04-11
  kdeconnect = plasma5Packages.kdeconnect-kde; # Added 2020-10-28
  kdecoration-viewer = throw "kdecoration-viewer has been removed from nixpkgs, as there is no upstream activity"; # Added 2020-06-16
  kdiff3-qt5 = kdiff3; # Added 2017-02-18
  keepass-keefox = keepass-keepassrpc; # backwards compatibility alias, added 2018-02
  keepassx-community = keepassxc; # Added 2017-11
  keepassx-reboot = keepassx-community; # Added 2017-02-01
  keepassx2-http = keepassx-reboot; # Added 2016-10-17
  keepnote = throw "keepnote has been removed from nixpkgs, as it is stuck on python2."; # Added 2022-01-01
  kerberos = libkrb5; # moved from top-level 2021-03-14
  kexectools = kexec-tools; # Added 2021-09-03
  keybase-go = keybase; # Added 2016-08-24
  keymon = throw "keymon has been removed from nixpkgs, as it's abandoned and archived."; # Added 2019-12-10
  keysmith = libsForQt5.plasmaMobileGear.keysmith; # Added 2021-07-14
  kibana7-oss = throw "kibana7-oss has been removed, as the distribution is no longer provided by upstream. https://github.com/NixOS/nixpkgs/pull/114456"; # Added 2021-06-09
  kicad-with-packages3d = kicad; # Added 2019-11-25
  kindlegen = throw "kindlegen has been removed from nixpkgs, as it's abandoned and no longer available for download."; # Added 2021-03-09
  kinetic-cpp-client = throw "kinetic-cpp-client has been removed from nixpkgs, as it's abandoned."; # Added 2020-04-28
  kino = throw "kino has been removed because it was broken and abandoned"; # Added 2021-04-25
  knockknock = throw "knockknock has been removed from nixpkgs because the upstream project is abandoned."; # Added 2022-01-01
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  kramdown-rfc2629 = rubyPackages.kramdown-rfc2629; # Added 2021-03-23
  krename-qt5 = krename; # Added 2017-02-18
  krita-beta = krita; # moved from top-level 2021-12-23
  kvm = qemu_kvm; # Added 2018-04-25

  ### L ###

  lastfmsubmitd = throw "lastfmsubmitd was removed from nixpkgs as the project is abandoned"; # Added 2022-01-01
  latinmodern-math = lmmath;
  letsencrypt = certbot; # Added 2016-05-16
  libGL_driver = mesa.drivers; # Added 2019-05-28
  libaudit = audit; # Added 2018-04-25
  libcanberra_gtk2 = libcanberra-gtk2; # Added 2018-02-25
  libcanberra_gtk3 = libcanberra-gtk3; # Added 2018-02-25
  libcap_manpages = libcap.doc; # Added 2016-04-29
  libcap_pam = if stdenv.isLinux then libcap.pam else null; # Added 2016-04-29
  libcap_progs = libcap.out; # Added 2016-04-29
  libco-canonical = throw "libco-canonical: Canonical deleted the repo, libco-canonical is not used anymore."; # Added 2021-05-16
  libcroco = throw "libcroco has been removed as it's no longer used in any derivations."; # Added 2020-03-04
  libdbusmenu-glib = libdbusmenu; # Added 2018-05-01
  libdbusmenu_qt5 = libsForQt5.libdbusmenu; # Added 2015-12-19
  liberation_ttf_v1_from_source = liberation_ttf_v1; # Added 2018-12-12
  liberation_ttf_v2_from_source = liberation_ttf_v2; # Added 2018-12-12
  liberationsansnarrow = liberation-sans-narrow; # Added 2018-12-12
  libgksu = throw "libgksu has been removed"; # Added 2022-01-16
  libgnome_keyring = libgnome-keyring; # Added 2018-02-25
  libgnome_keyring3 = libgnome-keyring3; # Added 2018-02-25
  libgpgerror = libgpg-error; # Added 2021-09-04
  libgroove = throw "libgroove has been removed, because it depends on an outdated and insecure version of ffmpeg"; # Added 2022-01-21
  libgumbo = gumbo; # Added 2018-01-21
  libindicate = throw "libindacate has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # Added 2019-12-10
  libindicate-gtk2 = throw "libindacate-gtk3 has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # Added 2019-12-10
  libindicate-gtk3 = throw "libindacate-gtk2 has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # Added 2019-12-10
  libintlOrEmpty = lib.optional (!stdenv.isLinux || stdenv.hostPlatform.libc != "glibc") gettext; # Added 2018-03-14
  libjpeg_drop = libjpeg_original; # Added 2020-06-05
  libjson_rpc_cpp = libjson-rpc-cpp; # Added 2017-02-28
  libkml = throw "libkml has been removed from nixpkgs, as it's abandoned and no package needed it."; # Added 2021-11-09
  liblapackWithoutAtlas = lapack-reference; # Added 2018-11-05
  liblastfm = libsForQt5.liblastfm; # Added 2020-06-14
  liblrdf = lrdf; # Added 2018-04-25
  libmsgpack = msgpack; # Added 2018-08-17
  libosmpbf = throw "libosmpbf was removed because it is no longer required by osrm-backend";
  libqmatrixclient = throw "libqmatrixclient was renamed to libquotient"; # Added 2020-04-09
  libqrencode = qrencode; # Added 2019-01-01
  librdf = lrdf; # Added 2020-03-22
  librecad2 = librecad; # backwards compatibility alias, added 2015-10
  librsync_0_9 = throw "librsync_0_9 has been removed"; # Added 2021-07-24
  libseat = seatd; # Added 2021-06-24
  libsexy = throw "libsexy has been removed from nixpkgs, as it's abandoned and no package needed it."; # Added 2019-12-10
  libstdcxxHook = throw "libstdcxx hook has been removed because cc-wrapper is now directly aware of the c++ standard library intended to be used."; # Added 2020-06-22
  libsysfs = sysfsutils; # Added 2018-04-25
  libtidy = html-tidy; # Added 2014-12-21
  libtorrentRasterbar = libtorrent-rasterbar; # Added 2020-12-20
  libtorrentRasterbar-1_1_x = libtorrent-rasterbar-1_1_x; # Added 2020-12-20
  libtorrentRasterbar-1_2_x = libtorrent-rasterbar-1_2_x; # Added 2020-12-20
  libtorrentRasterbar-2_0_x = libtorrent-rasterbar-2_0_x; # Added 2020-12-20
  libtxc_dxtn = throw "libtxc_dxtn was removed 2020-03-16, now integrated in Mesa";
  libtxc_dxtn_s2tc = throw "libtxc_dxtn_s2tc was removed 2020-03-16, now integrated in Mesa";
  libudev = udev; # Added 2018-04-25
  libungif = giflib; # Added 2020-02-12
  libusb = libusb1; # Added 2020-04-28
  libva-full = libva; # Added 2018-03-26
  libva1-full = libva1; # Added 2018-03-26
  libwnck3 = libwnck;
  lilypond-unstable = lilypond; # Added 2021-03-11
  lilyterm = throw "lilyterm has been removed from nixpkgs, because it was relying on a vte version that depended on python2."; # Added 2022-01-14
  lilyterm-git = throw "lilyterm-git has been removed from nixpkgs, because it was relying on a vte version that depended on python2."; # Added 2022-01-14
  links = links2; # Added 2016-01-31
  linuxband = throw "linuxband has been removed from nixpkgs, as it's abandoned upstream."; # Added 2021-12-09

  # Linux kernels
  linux-rt_5_10 = linuxKernel.kernels.linux_rt_5_10;
  linux-rt_5_4 = linuxKernel.kernels.linux_rt_5_4;
  linuxPackages_4_14 = linuxKernel.packages.linux_4_14;
  linuxPackages_4_19 = linuxKernel.packages.linux_4_19;
  linuxPackages_4_4 = linuxKernel.packages.linux_4_4;
  linuxPackages_4_9 = linuxKernel.packages.linux_4_9;
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_5_16 = linuxKernel.packages.linux_5_16;
  linuxPackages_5_4 = linuxKernel.packages.linux_5_4;
  linuxPackages_hardkernel_4_14 = linuxKernel.packages.hardkernel_4_14;
  linuxPackages_rpi0 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi1 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi2 = linuxKernel.packages.linux_rpi2;
  linuxPackages_rpi3 = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi4 = linuxKernel.packages.linux_rpi4;
  linuxPackages_rt_5_10 = linuxKernel.packages.linux_rt_5_10;
  linuxPackages_rt_5_4 = linuxKernel.packages.linux_rt_5_4;
  linux_4_14 = linuxKernel.kernels.linux_4_14;
  linux_4_19 = linuxKernel.kernels.linux_4_19;
  linux_4_4 = linuxKernel.kernels.linux_4_4;
  linux_4_9 = linuxKernel.kernels.linux_4_9;
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_5_16 = linuxKernel.kernels.linux_5_16;
  linux_5_4 = linuxKernel.kernels.linux_5_4;
  linux_mptcp_95 = linuxKernel.kernels.linux_mptcp_95;
  linux_rpi0 = linuxKernel.kernels.linux_rpi1;
  linux_rpi1 = linuxKernel.kernels.linux_rpi1;
  linux_rpi2 = linuxKernel.kernels.linux_rpi2;
  linux_rpi3 = linuxKernel.kernels.linux_rpi3;
  linux_rpi4 = linuxKernel.kernels.linux_rpi4;

  # Added 2020-04-04
  linuxPackages_testing_hardened = throw "linuxPackages_testing_hardened has been removed, please use linuxPackages_latest_hardened";
  linux_testing_hardened = throw "linux_testing_hardened has been removed, please use linux_latest_hardened";

  # Added 2021-04-04
  linuxPackages_xen_dom0 = linuxPackages;
  linuxPackages_latest_xen_dom0 = linuxPackages_latest;
  linuxPackages_xen_dom0_hardened = linuxPackages_hardened;
  linuxPackages_latest_xen_dom0_hardened = linuxPackages_latest_hardened;

  # Added 2021-08-16
  linuxPackages_latest_hardened = throw ''
    The attribute `linuxPackages_hardened_latest' was dropped because the hardened patches
    frequently lag behind the upstream kernel. In some cases this meant that this attribute
    had to refer to an older kernel[1] because the latest hardened kernel was EOL and
    the latest supported kernel didn't have patches.

    If you want to use a hardened kernel, please check which kernel minors are supported
    and use a versioned attribute, e.g. `linuxPackages_5_10_hardened'.

    [1] for more context: https://github.com/NixOS/nixpkgs/pull/133587
  '';
  linux_latest_hardened = linuxPackages_latest_hardened;

  linux-steam-integration = throw "linux-steam-integration has been removed, as the upstream project has been abandoned"; # Added 2020-05-22

  loadcaffe = throw "loadcaffe has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  lobster-two = google-fonts; # Added 2021-07-22
  love_0_7 = throw "love_0_7 was removed because it is a very old version and no longer used by any package in nixpkgs"; # Added 2022-01-15
  love_0_8 = throw "love_0_8 was removed because it is a very old version and no longer used by any package in nixpkgs"; # Added 2022-01-15
  love_0_9 = throw "love_0_9 was removed because was broken for a long time and no longer used by any package in nixpkgs"; # Added 2022-01-15
  lprof = throw "lprof has been removed as it's unmaintained upstream and broken in nixpkgs since a while ago"; # Added 2021-02-15
  lttngTools = lttng-tools; # Added 2014-07-31
  lttngUst = lttng-ust; # Added 2014-07-31
  lua5_1_sockets = lua51Packages.luasocket; # Added 2017-05-02
  lua5_expat = luaPackages.luaexpat; # Added 2017-05-02
  lua5_sec = luaPackages.luasec; # Added 2017-05-02
  lumpy = throw "lumpy has been removed from nixpkgs, as it is stuck on python2."; # Added 2022-01-12
  lxappearance-gtk3 = throw "lxappearance-gtk3 has been removed. Use lxappearance instead, which now defaults to Gtk3"; # Added 2020-06-03
  lzma = xz; # moved from top-level 2021-03-14

  ### M ###

  m3d-linux = m33-linux; # Added 2016-08-13
  mail-notification = throw "mail-notification has been removed from nixpkgs, as it's unmaintained and has dependencies on old gnome libraries we want to remove"; # Added 2021-08-21
  mailpile = throw "mailpile was removed from nixpkgs, as it is stuck on python2."; # Added 2022-01-12
  man_db = man-db; # Added 2016-05
  manpages = man-pages; # Added 2015-12-06
  marathon = throw "marathon has been removed from nixpkgs, as it's unmaintained"; # Added 2020-08-15
  mariadb-client = hiPrio mariadb.client; #added 2019.07.28
  matcha = throw "matcha was renamed to matcha-gtk-theme"; # added 2020-05-09
  mathics = throw "mathics has been removed from nixpkgs, as it's unmaintained"; # Added 2020-08-15
  matrique = spectral; # Added 2020-01-27
  mbedtls_1_3 = throw "mbedtls_1_3 is end of life, see https://tls.mbed.org/kb/how-to/upgrade-2.0"; # Added 2019-12-08
  mcgrid = throw "mcgrid has been removed from nixpkgs, as it's not compatible with rivet 3"; # Added 2020-05-23
  mcomix = throw "mcomix has been removed from nixpkgs, as it's unmaintained; try mcomix3 a Python 3 fork"; # Added 2019-12-10, modified 2020-11-25
  mediatomb = throw "mediatomb is no longer maintained upstream, use gerbera instead"; # added 2022-01-04
  meme = meme-image-generator; # Added 2021-04-21
  memtest86 = memtest86plus; # Added 2019-05-08
  mercurial_4 = throw "mercurial_4 has been removed as it's unmaintained"; # Added 2021-10-18
  mesos = throw "mesos has been removed from nixpkgs, as it's unmaintained"; # Added 2020-08-15
  mess = mame; # Added 2019-10-30
  metamorphose2 = throw "metamorphose2 has been removed from nixpkgs, as it was stuck on python2."; # Added 2022-01-12
  mididings = throw "mididings has been removed from nixpkgs as it doesn't support recent python3 versions and its upstream stopped maintaining it."; # Added 2022-01-12
  midoriWrapper = midori; # Added 2015-01
  mime-types = mailcap; # Added 2022-01-21
  mimms = throw "mimms has been removed from nixpkgs as the upstream project is stuck on python2."; # Added 2022-01-01
  minergate-cli = throw "minergatecli has been removed from nixpkgs, because the package is unmaintained and the site has a bad reputation"; # Added 2021-08-13
  minergate = throw "minergate has been removed from nixpkgs, because the package is unmaintained and the site has a bad reputation"; # Added 2021-08-13
  minetime = throw "minetime has been removed from nixpkgs, because it was discontinued 2021-06-22"; # Added 2021-10-14
  mirage = throw "mirage has been removed from nixpkgs, as it's unmaintained"; # Added 2019-12-10
  mist = throw "mist has been removed as the upstream project has been abandoned, see https://github.com/ethereum/mist#mist-browser-deprecated"; # Added 2020-08-15
  mlt-qt5 = libsForQt5.mlt; # Added 2015-12-19
  mobile_broadband_provider_info = mobile-broadband-provider-info; # Added 2018-02-25
  moby = throw "moby has been removed, merged into linuxkit in 2018.  Use linuxkit instead.";
  module_init_tools = kmod; # Added 2016-04-22
  monero = monero-cli; # Added 2021-11-28
  monodevelop = throw "monodevelop has been removed from nixpgks"; # Added 2022-01-15
  mopidy-gmusic = throw "mopidy-gmusic has been removed because Google Play Music was discontinued"; # Added 2021-03-07
  mopidy-local-images = throw "mopidy-local-images has been removed as it's unmaintained. Its functionality has been merged into the mopidy-local extension."; # Added 2020-10-18
  mopidy-local-sqlite = throw "mopidy-local-sqlite has been removed as it's unmaintained. Its functionality has been merged into the mopidy-local extension."; # Added 2020-10-18

  morituri = whipper; # Added 2018-09-13
  mozart-binary = mozart2-binary; # Added 2019-09-23
  mozart = mozart2-binary; # Added 2019-09-23
  mpc_cli = mpc-cli; # moved from top-level 2022-01-24
  mpd_clientlib = libmpdclient; # Added 2021-02-11
  mpich2 = mpich; # Added 2018-08-06
  msf = metasploit; # Added 2018-04-25
  multimc = throw "multimc was removed from nixpkgs; use polymc instead (see https://github.com/NixOS/nixpkgs/pull/154051 for more information)"; # Added 2022-01-08
  mumble_git = pkgs.mumble; # Added 2019-08-01
  murmur_git = pkgs.murmur; # Added 2019-08-01
  mysql-client = hiPrio mariadb.client;
  mysql = mariadb; # moved from top-level 2021-03-14

  # NOTE: 2018-07-12: legacy alias:
  # grsecurity business is done: https://www.theregister.co.uk/2018/02/08/bruce_perens_grsecurity_anti_slapp/

  # floating point textures patents are expired,
  # so package reduced to alias
  mesa_drivers = mesa.drivers;
  mesa_noglu = mesa; # Added 2019-05-28

  mpv-with-scripts = self.wrapMpv self.mpv-unwrapped { }; # Added 2020-05-22
  mssys = ms-sys; # Added 2015-12-13
  multipath_tools = multipath-tools; # Added 2016-01-21
  mumsi = throw "mumsi has been removed from nixpkgs, as it's unmaintained and does not build anymore"; # Added 2021-11-18
  mupen64plus1_5 = mupen64plus; # Added 2016-02-12
  mx = throw "graalvm8 and its tools were deprecated in favor of graalvm8-ce"; # Added 2021-10-15
  mxisd = throw "mxisd has been removed from nixpkgs as it has reached end of life, see https://github.com/kamax-matrix/mxisd/blob/535e0a5b96ab63cb0ddef90f6f42c5866407df95/EOL.md#end-of-life-notice . ma1sd may be a suitable alternative."; # Added 2021-04-15
  mysqlWorkbench = mysql-workbench; # Added 2017-01-19

  ### N ###

  net_snmp = net-snmp; # Added 2019-12-21
  nagiosPluginsOfficial = monitoring-plugins;
  navit = throw "navit has been removed from nixpkgs, due to being unmaintained"; # Added 2021-06-07
  ncat = nmap; # Added 2016-01-26
  neap = throw "neap was removed from nixpkgs, as it relies on python2"; # Added 2022-01-12
  netcat-openbsd = libressl.nc; # Added 2018-04-25
  netease-cloud-music = throw "netease-cloud-music has been removed together with deepin"; # Added 2020-08-31
  networkmanager_fortisslvpn = networkmanager-fortisslvpn; # Added 2018-02-25
  networkmanager_iodine = networkmanager-iodine; # Added 2018-02-25
  networkmanager_l2tp = networkmanager-l2tp; # Added 2018-02-25
  networkmanager_openconnect = networkmanager-openconnect; # Added 2018-02-25
  networkmanager_openvpn = networkmanager-openvpn; # Added 2018-02-25
  networkmanager_vpnc = networkmanager-vpnc; # Added 2018-02-25
  neutral-style = throw "neural-style has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  nfsUtils = nfs-utils; # Added 2014-12-06
  nginxUnstable = nginxMainline; # Added 2018-04-25
  nilfs_utils = nilfs-utils; # Added 2018-04-25
  nix-direnv-flakes = nix-direnv;
  nix-review = nixpkgs-review; # Added 2019-12-22
  nixFlakes = nixVersions.stable; # Added 2021-05-21
  nixStable = nixVersions.stable; # Added 2022-01-24
  nixUnstable = nixVersions.unstable; # Added 2022-01-26
  nix_2_3 = nixVersions.nix_2_3;
  nix_2_4 = nixVersions.nix_2_4;
  nix_2_5 = nixVersions.nix_2_5;
  nix_2_6 = nixVersions.nix_2_6;
  nmap-unfree = nmap; # Added 2021-04-06
  nmap_graphical = nmap-graphical; # Added 2017-01-19
  nologin = shadow; # Added 2018-04-25
  nordic-polar = throw "nordic-polar was removed on 2021-05-27, now integrated in nordic"; # Added 2021-05-27
  noto-fonts-cjk = noto-fonts-cjk-sans; # Added 2021-12-16
  nottetris2 = throw "nottetris2 was removed because it is unmaintained by upstream and broken"; # Added 2022-01-15
  now-cli = throw "now-cli has been replaced with nodePackages.vercel"; # Added 2021-08-05
  nxproxy = nx-libs; # Added 2019-02-15
  nylas-mail-bin = throw "nylas-mail-bin was deprecated on 2019-09-11: abandoned by upstream";

  ### O ###

  oracleXE = throw "oracleXE has been removed, as it's heavily outdated and unmaintained."; # Added 2020-10-09
  OVMF-CSM = throw "OVMF-CSM has been removed in favor of OVMFFull"; # Added 2021-10-16
  OVMF-secureBoot = throw "OVMF-secureBoot has been removed in favor of OVMFFull"; # Added 2021-10-16
  oauth2_proxy = oauth2-proxy; # Added 2021-04-18
  oblogout = throw "oblogout has been removed from nixpkgs, as it's archived upstream."; # Added 2019-12-10
  octoprint-plugins = throw "octoprint-plugins are now part of the octoprint.python.pkgs package set."; # Added 2021-01-24
  ocz-ssd-guru = throw "ocz-ssd-guru has been removed due to there being no source available"; # Added 2021-07-12
  ofp = throw "ofp is not compatible with odp-dpdk";
  olifant = throw "olifant has been removed from nixpkgs, as it was unmaintained."; # Added 2021-08-05
  onnxruntime = throw "onnxruntime has been removed due to poor maintainability"; # Added 2020-12-04
  openbazaar = throw "openbazzar has been removed from nixpkgs as upstream has abandoned the project"; # Added 2022-01-06
  openbazaar-client = throw "openbazzar-client has been removed from nixpkgs as upstream has abandoned the project"; # Added 2022-01-06
  opencascade_oce = opencascade; # Added 2018-04-25
  opencl-icd = ocl-icd; # Added 2017-01-20
  openconnect_pa = throw "openconnect_pa fork has been discontinued, support for GlobalProtect is now available in openconnect"; # Added 2021-05-21
  openelec-dvb-firmware = libreelec-dvb-firmware; # Added 2021-05-10
  openexr_ctl = ctl; # Added 2018-04-25
  openisns = open-isns; # Added 2020-01-28
  openjpeg_1 = throw "openjpeg_1 has been removed, use openjpeg_2 instead"; # Added 2021-01-24
  openjpeg_2 = openjpeg; # Added 2021-01-25
  openmpt123 = libopenmpt; # Added 2021-09-05
  opensans-ttf = open-sans; # Added 2018-12-04
  openssh_with_kerberos = openssh; # Added 2018-01-28
  orchis = orchis-theme; # Added 2021-06-09
  osquery = throw "osquery has been removed."; # Added 2019-11-24
  osxfuse = macfuse-stubs; # Added 2021-03-20
  otter-browser = throw "otter-browser has been removed from nixpkgs, as it was unmaintained"; # Added 2020-02-02
  owncloudclient = owncloud-client; # Added 2016-08

  ### P ###

  PPSSPP = ppsspp; # Added 2017-10-01

  p11_kit = p11-kit; # Added 2018-02-25
  packet-cli = metal-cli; # Added 2021-10-25
  paperless = paperless-ng; # Added 2021-06-06
  parity = openethereum; # Added 2020-08-01
  parity-ui = throw "parity-ui was removed because it was broken and unmaintained by upstream"; # Added 2022-01-10
  parquet-cpp = arrow-cpp; # Added 2018-09-08
  pass-otp = pass.withExtensions (ext: [ext.pass-otp]); # Added 2018-05-04
  pdfmod = throw "pdfmod has been removed"; # Added 2022-01-15
  pdfread = throw "pdfread has been remove because it is unmaintained for years and the sources are no longer available"; # Added 2021-07-22
  pdf-redact-tools = throw "pdf-redact-tools has been removed from nixpkgs because the upstream has abandoned the project."; # Added 2022-01-01
  pdf2htmlEx = throw "pdf2htmlEx has been removed from nixpkgs, as it was unmaintained"; # Added 2020-11-03
  perlXMLParser = perlPackages.XMLParser; # Added 2018-10-12
  perlArchiveCpio = perlPackages.ArchiveCpio; # Added 2018-10-12
  pgp-tools = signing-party; # Added 2017-03-26
  pg_tmp = ephemeralpg; # Added 2018-01-16

  # Obsolete PHP version aliases
  php73 = throw "php73 has been dropped due to the lack of maintanence from upstream for future releases."; # Added 2021-06-03
  php73Packages = php73; # Added 2021-06-03
  php73Extensions = php73; # Added 2021-06-03

  php-embed = throw ''
    php*-embed has been dropped, you can build something similar
    with the following snippet:
    php74.override { embedSupport = true; apxs2Support = false; }
  ''; # Added 2020-04-01
  php73-embed = php-embed; # Added 2020-04-01
  php74-embed = php-embed; # Added 2020-04-01

  phpPackages-embed = throw ''
    php*Packages-embed has been dropped, you can build something
    similar with the following snippet:
    (php74.override { embedSupport = true; apxs2Support = false; }).packages
  ''; # Added 2020-04-01
  php73Packages-embed = phpPackages-embed;
  php74Packages-embed = phpPackages-embed;

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
  ''; # Added 2020-04-01
  php73-unit = php-unit; # Added 2020-04-01
  php74-unit = php-unit; # Added 2020-04-01

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
  ''; # Added 2020-04-01
  php73Packages-unit = phpPackages-unit;
  php74Packages-unit = phpPackages-unit;

  pidgin-with-plugins = pidgin; # Added 2016-06
  pidginlatex = pidgin-latex; # Added 2018-01-08
  pidginlatexSF = pidgin-latex; # Added 2014-11-02
  pidginmsnpecan = pidgin-msn-pecan; # Added 2018-01-08
  pidginosd = pidgin-osd; # Added 2018-01-08
  pidginotr = pidgin-otr; # Added 2018-01-08
  pidginsipe = pidgin-sipe; # Added 2018-01-08
  pidginwindowmerge = pidgin-window-merge; # Added 2018-01-08
  pifi = throw "pifi has been removed from nixpkgs, as it is no longer developed."; # Added 2022-01-19
  piwik = matomo; # Added 2018-01-16
  pkgconfig = pkg-config; # Added 2018-02-02, moved to aliases.nix 2021-01-18
  pkgconfigUpstream = pkg-configUpstream; # Added 2018-02-02
  planner = throw "planner has been removed from nixpkgs, as it is no longer developed and still uses python2/PyGTK."; # Added 2021-02-02
  pleroma-otp = pleroma; # Added 2021-07-10
  plexpy = tautulli; # plexpy got renamed to tautulli, added 2019-02-22
  pltScheme = racket; # just to be sure
  pmtools = acpica-tools; # Added 2018-11-01
  polarssl = mbedtls; # Added 2018-04-25
  polysh = throw "polysh has been removed from nixpkgs as the upstream has abandoned the project."; # Added 2022-01-01
  poppler_qt5 = libsForQt5.poppler; # Added 2015-12-19

  # postgresql
  postgresql96 = postgresql_9_6;
  postgresql_9_6 = throw "postgresql_9_6 has been removed from nixpkgs, as this version is no longer supported by upstream"; # Added 2021-12-03

  # postgresql plugins
  cstore_fdw = postgresqlPackages.cstore_fdw;
  pg_cron = postgresqlPackages.pg_cron;
  pg_hll = postgresqlPackages.pg_hll;
  pg_repack = postgresqlPackages.pg_repack;
  pg_similarity = postgresqlPackages.pg_similarity;
  pg_topn = postgresqlPackages.pg_topn;
  pgjwt = postgresqlPackages.pgjwt;
  pgroonga = postgresqlPackages.pgroonga;
  pgtap = postgresqlPackages.pgtap;
  plv8 = postgresqlPackages.plv8;
  postgis = postgresqlPackages.postgis;
  tilp2 = throw "tilp2 has been removed"; # Added 2022-01-15
  timekeeper = throw "timekeeper has been removed"; # Added 2022-01-16
  timescaledb = postgresqlPackages.timescaledb;
  tlauncher = throw "tlauncher has been removed because there questionable practices and legality concerns";
  tsearch_extras = postgresqlPackages.tsearch_extras;

  phonon = throw "phonon: Please use libsForQt5.phonon, as Qt4 support in this package has been removed."; # Added 2019-11-22
  phonon-backend-gstreamer = throw "phonon-backend-gstreamer: Please use libsForQt5.phonon-backend-gstreamer, as Qt4 support in this package has been removed."; # Added 2019-11-22
  phonon-backend-vlc = throw "phonon-backend-vlc: Please use libsForQt5.phonon-backend-vlc, as Qt4 support in this package has been removed."; # Added 2019-11-22
  pinentry_curses = pinentry-curses; # Added 2019-10-14
  pinentry_emacs = pinentry-emacs; # Added 2019-10-14
  pinentry_gnome = pinentry-gnome; # Added 2019-10-14
  pinentry_gtk2 = pinentry-gtk2; # Added 2019-10-14
  pinentry_qt = pinentry-qt; # Added 2019-10-14
  pinentry_qt5 = pinentry-qt; # Added 2020-02-11
  pmenu = throw "pmenu has been removed from nixpkgs, as its maintainer is no longer interested in the package."; # Added 2019-12-10
  privateer = throw "privateer was removed because it was broken"; # Added 2021-05-18
  processing3 = processing; # Added 2019-08-16
  procps-ng = procps; # Added 2018-06-08
  proglodyte-wasm = throw "proglodyte-wasm has been removed from nixpkgs, because it is unmaintained since 5 years with zero github stars"; # Added 2021-06-30
  proj_5 = throw "Proj-5 has been removed from nixpkgs, use proj instead."; # Added 2021-04-12
  prometheus-cups-exporter = throw "outdated and broken by design; removed by developer."; # Added 2021-03-16
  pulseaudioLight = pulseaudio; # Added 2018-04-25
  pulseeffects = throw "Use pulseeffects-legacy if you use PulseAudio and easyeffects if you use PipeWire."; # Added 2021-02-13
  pulseeffects-pw = easyeffects; # Added 2021-07-07
  pyIRCt = throw "pyIRCt has been removed from nixpkgs as it is unmaintained and python2-only";
  pyMAILt = throw "pyMAILt has been removed from nixpkgs as it is unmaintained and python2-only";
  pybind11 = throw "pybind11 was removed because pythonPackages.pybind11 for the appropriate version of Python should be used"; # Added 2021-05-14
  pybitmessage = throw "pybitmessage was removed from nixpkgs as it is stuck on python2."; # Added 2022-01-01
  pygmentex = texlive.bin.pygmentex; # Added 2019-12-15
  pyload = throw "pyload has been removed from nixpkgs, as it was unmaintained."; # Added 2021-03-21
  pynagsystemd = throw "pynagsystemd was removed as it was unmaintained and incompatible with recent systemd versions. Instead use its fork check_systemd."; # Added 2020-10-24
  pyo3-pack = maturin;
  pyrex = throw "pyrex has been removed from nixpkgs as the project is still stuck on python2."; # Added 2022-01-12
  pyrex095 = throw "pyrex has been removed from nixpkgs as the project is still stuck on python2."; # Added 2022-01-12
  pyrex096 = throw "pyrex has been removed from nixpkgs as the project is still stuck on python2."; # Added 2022-01-12
  pyrit = throw "pyrit has been removed from nixpkgs as the project is still stuck on python2."; # Added 2022-01-01
  python = python2; # Added 2022-01-11
  python-swiftclient = swiftclient; # Added 2021-09-09
  python2nix = throw "python2nix has been removed as it is outdated. Use e.g. nixpkgs-pytools instead."; # Added 2021-03-08
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11

  ### Q ###

  QmidiNet = qmidinet; # Added 2016-05-22
  qca-qt5 = libsForQt5.qca-qt5; # Added 2015-12-19
  qcsxcad = libsForQt5.qcsxcad; # Added 2020-11-05
  qmk_firmware = throw "qmk_firmware has been removed because it was broken"; # Added 2021-04-02
  qr-filetransfer = throw ''"qr-filetransfer" has been renamed to "qrcp"''; # Added 2020-12-02
  qt-3 = throw "qt-3 has been removed from nixpkgs, as it's unmaintained and insecure"; # Added 2021-02-15
  qt-recordmydesktop = throw "qt-recordmydesktop has been removed from nixpkgs, as it's abandoned and uses deprecated libraries"; # Added 2019-12-10
  qt5ct = libsForQt5.qt5ct; # Added 2021-12-27
  qtcurve = libsForQt5.qtcurve; # Added 2020-11-07
  qtkeychain = throw "the qtkeychain attribute (qt4 version) has been removes, use the qt5 version: libsForQt5.qtkeychain"; # Added 2021-08-04
  quagga = throw "quagga is no longer maintained upstream"; # Added 2021-04-22
  quake3game = ioquake3; # Added 2016-01-14
  quaternion-git = throw "quaternion-git has been removed in favor of the stable version 'quaternion'"; # Added 2020-04-09
  quilter = throw "quilter has been removed from nixpkgs, as it was unmaintained."; # Added 2021-08-03
  qvim = throw "qvim has been removed."; # Added 2020-08-31
  qweechat = throw "qweechat has been removed because it was broken"; # Added 2021-03-08
  qwt6 = libsForQt5.qwt; # Added 2015-12-19

  ### R ###

  radare2-cutter = cutter; # Added 2021-03-30
  raspberrypi-tools = throw "raspberrypi-tools has been removed in favor of identical 'libraspberrypi'"; # Added 2020-12-24
  rawdog = throw "rawdog has been removed from nixpkgs as it still requires python2."; # Added 2022-01-01
  rdf4store = throw "rdf4store has been removed from nixpkgs."; # Added 2019-12-21
  rdiff_backup = rdiff-backup; # Added 2014-11-23
  rdmd = dtools; # Added 2017-08-19
  readline80 = throw "readline-8.0 is no longer supported in nixpkgs, please use 'readline' for main supported version or 'readline81' for most recent version"; # Added 2021-04-22
  recordmydesktop = throw "recordmydesktop has been removed from nixpkgs, as it's unmaintained and uses deprecated libraries"; # Added 2019-12-10
  redkite = throw "redkite was archived by upstream"; # Added 2021-04-12
  redshift-wlr = throw "redshift-wlr has been replaced by gammastep"; # Added 2021-12-25
  renpy = throw "renpy has been removed from nixpkgs, it was unmaintained and the latest packaged version required python2."; # Added 2022-01-12
  residualvm = throw "residualvm was merged to scummvm code in 2018-06-15; consider using scummvm"; # Added 2021-11-27
  retroArchCores = throw "retroArchCores has been removed. Please use overrides instead, e.g.: `retroarch.override { cores = with libretro; [ ... ]; }`"; # Added 2021-11-19
  retroshare06 = retroshare;
  rfkill = throw "rfkill has been removed, as it's included in util-linux"; # Added 2020-08-23
  riak-cs = throw "riak-cs is not maintained anymore"; # Added 2020-10-14
  rimshot = throw "rimshot has been removed, because it is broken and no longer maintained upstream"; # Added 2022-01-15
  ring-daemon = jami-daemon; # Added 2021-10-26
  rkt = throw "rkt was archived by upstream"; # Added 2020-05-16
  rng_tools = rng-tools; # Added 2018-10-24
  robomongo = robo3t; #added 2017-09-28
  rocm-runtime-ext = throw "rocm-runtime-ext has been removed, since its functionality was added to rocm-runtime"; #added 2020-08-21
  rpiboot-unstable = rpiboot; # Added 2021-07-30
  rssglx = rss-glx; #added 2015-03-25
  rssh = throw "rssh has been removed from nixpkgs: no upstream releases since 2012, several known CVEs"; # Added 2020-08-25
  rtv = throw "rtv was archived by upstream. Consider using tuir, an actively maintained fork"; # Added 2021-08-08
  rubyMinimal = throw "rubyMinimal was removed due to being unused";
  rubygems = throw "rubygems was deprecated on 2016-03-02: rubygems is now bundled with ruby";
  runCommandNoCC = runCommand;
  runCommandNoCCLocal = runCommandLocal;
  runwayml = throw "runwayml is now a webapp"; # Added 2021-04-17
  rustracerd = throw "rustracerd has been removed because it is broken and unmaintained"; # Added 2021-10-19
  rxvt_unicode = rxvt-unicode-unwrapped; # Added 2020-02-02
  rxvt_unicode-with-plugins = rxvt-unicode; # Added 2020-02-02

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtlwifi_new-firmware = rtw88-firmware; # Added 2021-03-14

  ### S ###

  s2n = s2n-tls; # Added 2021-03-03
  s6Dns = s6-dns; # Added 2018-07-23
  s6LinuxUtils = s6-linux-utils; # Added 2018-07-23
  s6Networking = s6-networking; # Added 2018-07-23
  s6PortableUtils = s6-portable-utils; # Added 2018-07-23
  sagemath = sage; # Added 2018-10-27
  sam = deadpixi-sam; # Added 2018-04-25
  samsungUnifiedLinuxDriver = samsung-unified-linux-driver; # Added 2016-01-25
  sane-backends-git = sane-backends; # Added 2021-02-19
  saneBackends = sane-backends; # Added 2016-01-02
  saneBackendsGit = sane-backends; # Added 2016-01-02
  saneFrontends = sane-frontends; # Added 2016-01-02
  scaff = throw "scaff is deprecated - replaced by https://gitlab.com/jD91mZM2/inc (not in nixpkgs yet)"; # Added 2020-03-01
  scim = sc-im; # Added 2016-01-22
  scollector = bosun; # Added 2018-04-25
  scyther = throw "scyther has been removed since it currently only supports Python 2, see https://github.com/cascremers/scyther/issues/20"; # Added 2021-10-07
  sdlmame = mame; # Added 2019-10-30
  seeks = throw "seeks has been removed from nixpkgs, as it was unmaintained"; # Added 2020-06-21
  seg3d = throw "seg3d has been removed from nixpkgs (2019-11-10)";
  sepolgen = throw "sepolgen was merged into selinux-python"; # Added 2021-11-11
  shared_mime_info = shared-mime-info; # Added 2018-02-25
  shellinabox = throw "shellinabox has been removed from nixpkgs, as it was unmaintained upstream"; # Added 2021-12-15
  sickbeard = throw "sickbeard has been removed from nixpkgs, as it was unmaintained."; # Added 2022-01-01
  sickrage = throw "sickbeard has been removed from nixpkgs, as it was unmaintained."; # Added 2022-01-01
  sigurlx = throw "sigurlx has been removed (upstream is gone)"; # Added 2022-01-24
  skrooge2 = skrooge; # Added 2017-02-18
  sky = throw "sky has been removed from nixpkgs (2020-09-16)";
  skype = skypeforlinux; # Added 2017-07-27
  skype4pidgin = throw "skype4pidgin has been remove from nixpkgs, because it stopped working when classic Skype was retired."; # Added 2021-07-14
  skype_call_recorder = throw "skype_call_recorder has been removed from nixpkgs, because it stopped working when classic Skype was retired."; # Added 2020-10-31
  slack-dark = slack; # Added 2020-03-27
  slic3r-prusa3d = prusa-slicer; # Added 2019-05-21
  slim = throw "slim has been removed. Please use a different display-manager"; # Added 2019-11-11
  slimThemes = throw "slimThemes has been removed because slim has been also"; # Added 2019-11-11
  slurm-full = slurm; # Added 2018-05-1
  slurm-llnl = slurm; # renamed July 2017
  slurm-llnl-full = slurm-full; # renamed July 2017
  smbclient = samba; # Added 2018-04-25
  smugline = throw "smugline has been removed from nixpkgs, as it's unmaintained and depends on deprecated libraries."; # Added 2020-11-04
  solr_8 = solr; # Added 2021-01-30

  # Added 2020-02-10
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
  source-sans-pro = source-sans; # Added 2021-10-20
  source-serif-pro = source-serif; # Added 2021-10-20

  spaceOrbit = space-orbit; # added 2016-05-23
  spectral = neochat; # Added 2020-12-27
  speech_tools = speech-tools; # added 2018-04-25
  speedtest_cli = speedtest-cli;  # added 2015-02-17
  spice_gtk = spice-gtk; # added 2018-02-25
  spice_protocol = spice-protocol; # added 2018-02-25
  spidermonkey_1_8_5 = throw "spidermonkey_1_8_5 has been removed, because it is based on Firefox 4.0 from 2011."; # added 2021-05-03
  spidermonkey_38 = throw "spidermonkey_38 has been removed. Please use spidermonkey_78 instead."; # Added 2021-03-21
  spidermonkey_52 = throw "spidermonkey_52 has been removed. Please use spidermonkey_78 instead."; # Added 2019-10-16
  spidermonkey_60 = throw "spidermonkey_60 has been removed. Please use spidermonkey_78 instead."; # Added 2021-03-21
  spidermonkey_68 = throw "spidermonkey_68 has been removed. Please use spidermonkey_91 instead."; # added 2022-01-04
  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spidermonkey = spidermonkey_78; # Added 2020-10-09
  spring-boot = spring-boot-cli; # added 2020-04-24
  sqlite3_analyzer = sqlite-analyzer; # added 2018-05-22
  sqliteInteractive = sqlite-interactive; # Added 2014-12-06
  squid4 = squid;  # added 2019-08-22
  sshfsFuse = sshfs-fuse; # added 2016-09
  stanchion = throw "Stanchion was part of riak-cs which is not maintained anymore"; # added 2020-10-14
  stumpwm-git = throw "stumpwm-git has been broken for a long time and lispPackages.stumpwm follows Quicklisp that is close to git version"; # Added 2021-05-09
  subversion19 = throw "subversion19 has been removed as it has reached its end of life"; # Added 2021-03-31
  sundials_3 = throw "sundials_3 was removed in 2020-02. outdated and no longer needed";
  surf-webkit2 = surf; # Added 2017-04-02
  svgcleaner = throw "svgcleaner has been removed."; # Added 2021-11-17
  swec = throw "swec has been removed; broken and abandoned upstream."; # Added 2021-10-14
  swfdec = throw "swfdec has been removed as broken and unmaintained."; # Added 2020-08-23
  swtpm-tpm2 = swtpm; # Added 2021-02-26
  syncthing-cli = syncthing; # Added 2021-04-06
  synology-drive = throw "synology-drive has been superseded by synology-drive-client"; # Added 2021-11-26
  system_config_printer = system-config-printer; # Added 2016-01-03
  systemd-cryptsetup-generator = throw "systemd-cryptsetup-generator is now included in the systemd package"; # Added 2020-07-12
  systemd_with_lvm2 = throw "systemd_with_lvm2 is obsolete, enabled by default via the lvm module"; # Added 2020-07-12
  systool = sysfsutils; # Added 2018-04-25

  ### T ###

  tahoelafs = tahoe-lafs; # Added 2018-03-26
  tangogps = foxtrotgps; # Added 2020-01-26
  tdm = throw "tdm has been removed because nobody can figure out how to fix OpenAL integration. Use precompiled binary and `steam-run` instead.";
  telepathy-qt = throw "telepathy-qt no longer supports Qt 4. Please use libsForQt5.telepathy instead."; # Added 2020-07-02
  telepathy_farstream = telepathy-farstream; # Added 2018-02-25
  telepathy_gabble = telepathy-gabble; # Added 2018-02-25
  telepathy_glib = telepathy-glib; # Added 2018-02-25
  telepathy_haze = telepathy-haze; # Added 2018-02-25
  telepathy_idle = telepathy-idle; # Added 2018-02-25
  telepathy_logger = telepathy-logger; # Added 2018-02-25
  telepathy_mission_control = telepathy-mission-control; # Added 2018-02-25
  telepathy_qt = telepathy-qt; # Added 2018-02-25
  telepathy_qt5 = libsForQt5.telepathy; # Added 2015-12-19
  telepathy_salut = telepathy-salut; # Added 2018-02-25
  telnet = inetutils; # Added 2018-05-15
  terminus = throw "terminus has been removed, it was unmaintained in nixpkgs"; # Added 2021-08-21
  terraform-provider-ibm = terraform-providers.ibm; # Added 2018-09-28
  terraform-provider-libvirt = terraform-providers.libvirt; # Added 2018-09-28
  terraform-provider-lxd = terraform-providers.lxd; # Added 2020-03-16
  terraform_0_12 = throw "terraform_0_12 has been removed from nixpkgs on 2021/01";
  terraform_1_0 = throw "terraform_1_0 has been renamed to terraform_1"; # Added 2021-12-08
  terraform_1_0_0 = throw "terraform_1_0_0 has been renamed to terraform_1"; # Added 2021-06-15
  tesseract_4 = tesseract4; # Added 2018-12-19
  tex-gyre-bonum-math = tex-gyre-math.bonum; # Added 2018-04-03
  tex-gyre-pagella-math = tex-gyre-math.pagella; # Added 2018-04-03
  tex-gyre-schola-math = tex-gyre-math.schola; # Added 2018-04-03
  tex-gyre-termes-math = tex-gyre-math.termes; # Added 2018-04-03
  tftp_hpa = tftp-hpa; # Added 2015-04-03
  thunderbird-68 = throw "Thunderbird 68 reached end of life with its final release 68.12.0 on 2020-08-25.";
  thunderbird-bin-68 = thunderbird-68;
  timescale-prometheus = promscale; # Added 2020-09-29
  timetable = throw "timetable has been removed, as the upstream project has been abandoned"; # Added 2021-09-05
  togglesg-download = throw "togglesg-download was removed 2021-04-30 as it's unmaintained"; # Added 2021-04-30
  tomboy = throw "tomboy is not actively developed anymore and was removed."; # Added 2022-01-27
  tomcat7 = throw "tomcat7 has been removed from nixpkgs as it has reached end of life."; # Added 2021-06-16
  tomcat8 = throw "tomcat8 has been removed from nixpkgs as it has reached end of life."; # Added 2021-06-16
  tomcat85 = throw "tomcat85 has been removed from nixpkgs as it has reached end of life."; # Added 2020-03-11
  tor-arm = throw "tor-arm has been removed from nixpkgs as the upstream project has been abandoned."; # Added 2022-01-01
  torbrowser = tor-browser-bundle-bin; # Added 2017-04-05
  torch = throw "torch has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  torch-hdf5 = throw "torch-hdf5 has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  torch-repl = throw "torch-repl has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  torchPackages = throw "torchPackages has been removed, as the upstream project has been abandoned"; # Added 2020-03-28
  trang = jing-trang; # Added 2018-04-25
  transmission-remote-cli = "transmission-remote-cli has been removed, as the upstream project has been abandoned. Please use tremc instead"; # Added 2020-10-14
  transmission_gtk = transmission-gtk; # Added 2018-01-06
  transmission_remote_gtk = transmission-remote-gtk; # Added 2018-01-06
  transporter = throw "transporter has been removed. It was archived upstream, so it's considered abandoned.";
  trebleshot = throw "trebleshot has been removed. It was archived upstream, so it's considered abandoned.";
  trilium = throw "trilium has been removed. Please use trilium-desktop instead."; # Added 2020-04-29
  truecrypt = veracrypt; # Added 2018-10-24
  tshark = wireshark-cli; # Added 2018-04-25
  tuijam = throw "tuijam has been removed because Google Play Music was discontinued"; # Added 2021-03-07
  turbo-geth = throw "turbo-geth has been renamed to erigon"; # Added 2021-08-08
  typora = throw "Newer versions of typora use anti-user encryption and refuse to start. As such it has been removed."; # Added 2021-09-11

  ### U ###

  uberwriter = apostrophe; # Added 2020-04-23
  ubootBeagleboneBlack = ubootAmx335xEVM; # Added 2020-01-21
  ucsFonts = ucs-fonts; # Added 2016-07-15
  ufraw = throw "ufraw is unmaintained and has been removed from nixpkgs. Its successor, nufraw, doesn't seem to be stable enough. Consider using Darktable for now."; # Added 2020-01-11
  ultrastardx-beta = ultrastardx; # Added 2017-08-12
  unicorn-emu = unicorn; # Added 2020-10-29
  unifiStable = unifi6; # Added 2020-12-28
  untrunc = untrunc-anthwlock; # Added 2021-02-01
  urxvt_autocomplete_all_the_things = rxvt-unicode-plugins.autocomplete-all-the-things; # Added 2020-02-02
  urxvt_bidi = rxvt-unicode-plugins.bidi; # Added 2020-02-02
  urxvt_font_size = rxvt-unicode-plugins.font-size; # Added 2020-02-02
  urxvt_perl = rxvt-unicode-plugins.perl; # Added 2020-02-02
  urxvt_perls = rxvt-unicode-plugins.perls; # Added 2020-02-02
  urxvt_tabbedex = rxvt-unicode-plugins.tabbedex; # Added 2020-02-02
  urxvt_theme_switch = rxvt-unicode-plugins.theme-switch; # Added 2020-02-02
  urxvt_vtwheel = rxvt-unicode-plugins.vtwheel; # Added 2020-02-02
  usb_modeswitch = usb-modeswitch; # Added 2016-05-10
  usbguard-nox = usbguard; # Added 2019-09-04
  utillinux = util-linux; # Added 2020-11-24
  uzbl = throw "uzbl has been removed from nixpkgs, as it's unmaintained and uses insecure libraries";

  ### V ###

  v4l_utils = v4l-utils; # Added 2019-08-07
  v8_3_16_14 = throw "v8_3_16_14 was removed in 2019-11-01: no longer referenced by other packages";
  vamp = { vampSDK = vamp-plugin-sdk; }; # Added 2020-03-26
  vapor = throw "vapor was removed because it was unmaintained and upstream service no longer exists";
  varnish62 = throw "varnish62 was removed from nixpkgs, because it is unmaintained upstream. Please switch to a different release."; # Added 2021-07-26
  varnish63 = throw "varnish63 was removed from nixpkgs, because it is unmaintained upstream. Please switch to a different release."; # Added 2021-07-26
  varnish65 = throw "varnish65 was removed from nixpkgs, because it is unmaintained upstream. Please switch to a different release."; # Added 2021-09-15
  vdirsyncerStable  = vdirsyncer; # Added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  venus = throw "venus has been removed from nixpkgs, as it's unmaintained"; # Added 2021-02-05
  vimbWrapper = vimb; # Added 2015-01
  vimprobable2 = throw "vimprobable2 has been removed from nixpkgs. It relied on webkitgtk24x that has been removed."; # Added 2019-12-05
  vimprobable2-unwrapped = vimprobable2; # Added 2019-12-05
  virtinst = throw "virtinst has been removed, as it's included in virt-manager"; # Added 2021-07-21
  virtmanager = virt-manager; # Added 2019-10-29
  virtmanager-qt = virt-manager-qt; # Added 2019-10-29
  virtviewer = virt-viewer; # Added 2015-12-24
  vorbisTools = vorbis-tools; # Added 2016-01-26
  vtun = throw "vtune has been removed as it's unmaintained upstream."; # Added 2021-10-29

  ### W ###

  way-cooler = throw "way-cooler is abandoned by its author: https://way-cooler.org/blog/2020/01/09/way-cooler-post-mortem.html"; # Added 2020-01-13
  webkit = webkitgtk; # Added 2019-03-05
  webkitgtk24x-gtk2 = throw "webkitgtk24x-gtk2 has been removed because it's insecure. Please use webkitgtk."; # Added 2019-12-05
  webkitgtk24x-gtk3 = throw "webkitgtk24x-gtk3 has been removed because it's insecure. Please use webkitgtk."; # Added 2019-12-05
  weechat-matrix-bridge = weechatScripts.weechat-matrix-bridge; # Added 2018-09-06
  wicd = throw "wicd has been removed as it is abandoned."; # Added 2021-09-11
  wineFull = winePackages.full; # Added 2017-05-27
  wineMinimal = winePackages.minimal; # Added 2017-05-27
  wineStable = winePackages.stable; # Added 2017-05-27
  wineStaging = wine-staging; # Added 2018-01-08
  wineUnstable = winePackages.unstable; # Added 2017-05-27
  wineWayland = wine-wayland;
  winswitch = throw "winswitch has been removed from nixpkgs."; # Added 2019-12-10
  winusb = woeusb; # Added 2017-12-22
  wireguard = wireguard-tools; # Added 2018-05-19
  wireshark-gtk = throw "wireshark-gtk is not supported anymore. Use wireshark-qt or wireshark-cli instead."; # Added 2019-11-18
  wxmupen64plus = throw "wxmupen64plus was removed because the upstream disappeared."; # Added 2022-01-31

  ### X ###

  x11 = xlibsWrapper; # Added 2015-09
  xara = throw "xara has been removed from nixpkgs. Unmaintained since 2006"; # Added 2020-06-24
  xbmc = kodi; # Added 2018-04-25
  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers; # Added 2021-11-19
  xbmcPlain = kodiPlain; # Added 2018-04-25
  xbmcPlugins = kodiPackages; # Added 2018-04-25
  xdg_utils = xdg-utils; # Added 2021-02-01
  xfce4-12 = throw "xfce4-12 has been replaced by xfce4-14"; # Added 2020-03-14
  xfce4-14 = xfce;
  xfceUnstable = xfce4-14; # Added 2019-09-17
  xineLib = xine-lib; # Added 2021-04-27
  xineUI = xine-ui; # Added 2021-04-27
  xmonad_log_applet_gnome3 = xmonad_log_applet; # Added 2018-05-01
  xmpppy = throw "xmpppy has been removed from nixpkgs as it is unmaintained and python2-only";
  xp-pen-g430 = pentablet-driver; # Added 2020-05-03
  xf86_video_nouveau = xorg.xf86videonouveau; # Added 2015-09
  xf86_input_mtrack = throw ''
    xf86_input_mtrack has been removed from nixpkgs as it is broken and
    unmaintained. Working alternatives are libinput and synaptics.
  '';
  xf86_input_multitouch = throw "xf86_input_multitouch has been removed from nixpkgs."; # Added 2020-01-20
  xlibs = xorg; # Added 2015-09
  xpraGtk3 = xpra; # Added 2018-09-13
  xv = xxv; # Added 2020-02-22
  xvfb_run = xvfb-run; # Added 2021-05-07

  ### Y ###

  yacc = bison; # moved from top-level 2021-03-14
  yarssr = throw "yarssr has been removed as part of the python2 deprecation"; # Added 2022-01-15
  youtubeDL = youtube-dl; # Added 2014-10-26
  ytop = throw "ytop has been abandoned by upstream. Consider switching to bottom instead";
  yubikey-neo-manager = throw "yubikey-neo-manager has been removed because it was broken. Use yubikey-manager-qt instead."; # Added 2021-03-08
  yuzu = yuzu-mainline; # Added 2021-01-25

  ### Z ###

  zabbix30 = throw "Zabbix 3.0.x is end of life, see https://www.zabbix.com/documentation/5.0/manual/installation/upgrade/sources for a direct upgrade path to 5.0.x"; # Added 2021-04-07
  zdfmediathk = mediathekview; # Added 2019-01-19
  zimreader = throw "zimreader has been removed from nixpkgs as it has been replaced by kiwix-serve and stopped working with modern zimlib versions."; # Added 2021-03-28

  # TODO(ekleog): add ‘wasm’ alias to ‘ocamlPackages.wasm’ after 19.03
  # branch-off

  inherit (ocaml-ng) # Added 2016-09-14
    ocamlPackages_4_00_1 ocamlPackages_4_01_0 ocamlPackages_4_02
    ocamlPackages_4_03 ocamlPackages_latest;

  zabbix44 = throw ''
    Zabbix 4.4 is end of life. For details on upgrading to Zabbix 5.0 look at
    https://www.zabbix.com/documentation/current/manual/installation/upgrade_notes_500
  ''; # Added 2020-08-17

  # Added 2019-09-06
  zeroc_ice = pkgs.zeroc-ice;

  # Added 2020-06-22
  zeromq3 = throw "zeromq3 has been deprecated by zeromq4.";
  jzmq = throw "jzmq has been removed from nixpkgs, as it was unmaintained";

} // (with ocaml-ng; { # Added 2016-09-14
  ocaml_4_00_1 = ocamlPackages_4_00_1.ocaml;
  ocaml_4_01_0 = ocamlPackages_4_01_0.ocaml;
  ocaml_4_02   = ocamlPackages_4_02.ocaml;
  ocaml_4_03   = ocamlPackages_4_03.ocaml;
}) // {

  avian = throw ''
    The package doesn't compile anymore on NixOS and both development &
    maintenance is abandoned by upstream.
  ''; # Cleanup before 21.11, Added 2021-05-07
  ant-dracula-theme = throw "ant-dracula-theme is now dracula-theme, and theme name is Dracula instead of Ant-Dracula.";
  dina-font-pcf = dina-font; # Added 2020-02-09
  dnscrypt-proxy = throw "dnscrypt-proxy has been removed. Please use dnscrypt-proxy2."; # Added 2020-02-02
  gcc-snapshot = throw "gcc-snapshot: Marked as broken for >2 years, additionally this 'snapshot' pointed to a fairly old one from gcc7.";
  gnatsd = nats-server; # Added 2019-10-28

  obs-gstreamer = throw ''
    obs-gstreamer has been converted into a plugin for use with wrapOBS.
    Its new location is obs-studio-plugins.obs-gstreamer.
  ''; # Added 2021-06-01

  obs-move-transition = throw ''
    obs-move-transition has been converted into a plugin for use with wrapOBS.
    Its new location is obs-studio-plugins.obs-move-transition.
  ''; # Added 2021-06-01

  obs-multi-rtmp = throw ''
    obs-multi-rtmp has been converted into a plugin for use with wrapOBS.
    Its new location is obs-studio-plugins.obs-multi-rtmp.
  ''; # Added 2021-06-01

  obs-ndi = throw ''
    obs-ndi has been converted into a plugin for use with wrapOBS.
    Its new location is obs-studio-plugins.obs-ndi.
  ''; # Added 2021-06-01

  obs-v4l2sink = throw "obs-v4l2sink is integrated into upstream OBS since version 26.1"; # Added 2021-06-01

  obs-wlrobs = throw ''
    wlrobs has been converted into a plugin for use with wrapOBS.
    Its new location is obs-studio-plugins.wlrobs.
  ''; # Added 2021-06-01

  oraclejdk8psu = throw "The *psu versions of oraclejdk are no longer provided by upstream."; # Cleanup before 20.09
  oraclejre8psu = oraclejdk8psu; # Cleanup before 20.09
  oraclejdk8psu_distro = oraclejdk8psu; # Cleanup before 20.09
  posix_man_pages = man-pages-posix; # Added 2021-04-15
  riot-desktop = throw "riot-desktop is now element-desktop!"; # Cleanup before 21.05
  riot-web = throw "riot-web is now element-web"; # Cleanup before 21.05
  sqldeveloper_18 = throw "sqldeveloper_18 is not maintained anymore!"; # Added 2020-02-04
  todolist = throw "todolist is now ultralist."; # Added 2020-12-27
  tor-browser-bundle = throw "tor-browser-bundle was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead."; # Added 2020-01-10
  tor-browser-unwrapped = throw "tor-browser-unwrapped was removed because it was out of date and inadequately maintained. Please use tor-browser-bundle-bin instead."; # Added 2020-01-10
  tt-rss-plugin-tumblr-gdpr = throw "tt-rss-plugin-tumblr-gdpr was removed because tumblr does not require gdpr acceptance to fetch rss feeds anymore"; # Added 2012-06-12
  ttyrec = ovh-ttyrec; # Added 2021-01-02
  zplugin = zinit; # Added 2021-01-30

  inherit (stdenv.hostPlatform) system; # Added 2021-10-22

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_git = recurseIntoAttrs (callPackage ../development/compilers/llvm/git {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_git.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_git.libraries;
  });

  /* If these are in the scope of all-packages.nix, they cause collisions
  between mixed versions of qt. See:
  https://github.com/NixOS/nixpkgs/pull/101369 */

  inherit (plasma5Packages)
    akonadi akregator ark bluedevil bomber bovo breeze-grub breeze-gtk
    breeze-icons breeze-plymouth breeze-qt5 discover dolphin dragon elisa
    ffmpegthumbs filelight granatier gwenview k3b kactivitymanagerd kaddressbook
    kalzium kapman kapptemplate kate katomic kblackbox kblocks kbounce
    kcachegrind kcalc kcharselect kcolorchooser kde-cli-tools kde-gtk-config
    kdenlive kdeplasma-addons kdf kdialog kdiamond keditbookmarks kfind kfloppy
    kgamma5 kget kgpg khelpcenter kig kigo killbots kinfocenter kitinerary
    kleopatra klettres klines kmag kmail kmenuedit kmines kmix kmplot
    knavalbattle knetwalk knights kollision kolourpaint kompare konsole kontact
    korganizer kpkpass krdc kreversi krfb kscreen kscreenlocker kshisen ksquares
    ksshaskpass ksystemlog kteatime ktimer ktouch kturtle kwallet-pam
    kwalletmanager kwave kwayland-integration kwin kwrited marble milou minuet
    okular oxygen oxygen-icons5 picmi plasma-browser-integration plasma-desktop
    plasma-integration plasma-nano plasma-nm plasma-pa plasma-phone-components
    plasma-systemmonitor plasma-thunderbolt plasma-vault plasma-workspace
    plasma-workspace-wallpapers polkit-kde-agent powerdevil qqc2-breeze-style
    sddm-kcm spectacle systemsettings xdg-desktop-portal-kde yakuake
  ;

  inherit (plasma5Packages.thirdParty)
    krohnkite
    krunner-symbols
    kwin-dynamic-workspaces
    kwin-tiling
    plasma-applet-caffeine-plus
    plasma-applet-virtual-desktop-bar
  ;

  inherit (libsForQt5)
    sddm
  ;

})
