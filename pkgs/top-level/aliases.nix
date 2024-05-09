lib: self: super:

### Deprecated aliases - for backward compatibility
### Please maintain this list in ASCIIbetical ordering.
### Hint: the "sections" are delimited by ### <letter> ###

# These aliases should not be used within nixpkgs, but exist to improve
# backward compatibility in projects outside of nixpkgs. See the
# documentation for the `allowAliases` option for more background.

# A script to convert old aliases to throws and remove old
# throws can be found in './maintainers/scripts/remove-old-aliases.py'.

# Add 'preserve, reason: reason why' after the date if the alias should not be removed.
# Try to keep them to a minimum.
# valid examples of what to preserve:
#   distro aliases such as:
#     debian-package-name -> nixos-package-name

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute set
  # to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false
    then removeAttrs alias [ "recurseForDerivations" ]
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
    lib.mapAttrs
      (n: alias:
        removeDistribute
          (removeRecurseForDerivations
            (checkInPkgs n alias)))
      aliases;
in

mapAliases ({
  # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.
  forceSystem = system: _:
    (import self.path { localSystem = { inherit system; }; });

  ### A ###

  AusweisApp2 = ausweisapp; # Added 2023-11-08
  a4term = a4; # Added 2023-10-06
  acorn = throw "acorn has been removed as the upstream project was archived"; # Added 2024-04-27
  adtool = throw "'adtool' has been removed, as it was broken and unmaintained";
  adom = throw "'adom' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  advcpmv = throw "'advcpmv' has been removed, as it is not being actively maintained and break recent coreutils."; # Added 2024-03-29
  aether = throw "aether has been removed from nixpkgs; upstream unmaintained, security issues"; # Added 2023-10-03
  afl = throw "afl has been removed as the upstream project was archived. Consider using 'aflplusplus'"; # Added 2024-04-21
  airfield = throw "airfield has been removed due to being unmaintained"; # Added 2023-05-19
  alertmanager-bot = throw "alertmanager-bot is broken and has been archived by upstream"; # Added 2023-07-28
  alsa-project = throw "alsa-project was removed and its sub-attributes were promoted to top-level."; # Added 2023-11-12
  alsaLib = alsa-lib; # Added 2021-06-09
  alsaOss = alsa-oss; # Added 2021-06-10
  alsaPluginWrapper = alsa-plugins-wrapper; # Added 2021-06-10
  alsaPlugins = alsa-plugins; # Added 2021-06-10
  alsaTools = alsa-tools; # Added 2021-06-10
  alsaUtils = alsa-utils; # Added 2021-06-10
  amtk = throw "amtk has been renamed to libgedit-amtk and is now maintained by Gedit Technology"; # Added 2023-12-31
  angelfish = libsForQt5.kdeGear.angelfish; # Added 2021-10-06
  ansible_2_12 = throw "Ansible 2.12 goes end of life in 2023/05 and can't be supported throughout the 23.05 release cycle"; # Added 2023-05-16
  ansible_2_13 = throw "Ansible 2.13 goes end of life in 2023/11"; # Added 2023-12-30
  ansible_2_14 = throw "Ansible 2.14 goes end of life in 2024/05 and can't be supported throughout the 24.05 release cycle"; # Added 2024-04-11
  apacheAnt_1_9 = throw "Ant 1.9 has been removed since it's not used in nixpkgs anymore"; # Added 2023-11-12
  antimicroX = antimicrox; # Added 2021-10-31
  appthreat-depscan = dep-scan; # Added 2024-04-10
  arcanPackages = throw "arcanPackages was removed and its sub-attributes were promoted to top-level"; # Added 2023-11-26
  archiveopteryx = throw "archiveopteryx depended on an unsupported version of OpenSSL and was unmaintained"; # Added 2024-01-03
  ardour_6 = throw "ardour_6 has been removed in favor of newer versions"; # Added 2023-10-13
  aria = aria2; # Added 2024-03-26
  aseprite-unfree = aseprite; # Added 2023-08-26
  asls = throw "asls has been removed: abandoned by upstream"; # Added 2023-03-16
  asterisk_16 = throw "asterisk_16: Asterisk 16 is end of life and has been removed"; # Added 2023-04-19
  asterisk_19 = throw "asterisk_19: Asterisk 19 is end of life and has been removed"; # Added 2023-04-19
  atom = throw "'atom' has been removed because discontinued and deprecated. Consider using 'pulsar', a maintained fork"; # Added 2023-10-01
  atom-beta = throw "'atom-beta' has been removed because discontinued and deprecated. Consider using 'pulsar', a maintained fork"; # Added 2023-10-01
  atomEnv = throw "'atomEnv' has been removed because 'atom' is discontinued and deprecated. Consider using 'pulsar', a maintained fork"; # Added 2023-10-01
  atomPackages = throw "'atomPackages' has been removed because 'atom' is discontinued and deprecated. Consider using 'pulsar', a maintained fork"; # Added 2023-10-01
  auditBlasHook = throw "'auditBlasHook' has been removed since it never worked"; # Added 2024-04-02
  authy = throw "'authy' has been removed since it reached end of life"; # Added 2024-04-19
  avldrums-lv2 = x42-avldrums; # Added 2020-03-29
  awesome-4-0 = awesome; # Added 2022-05-05

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  baget = throw "'baget' has been removed due to being unmaintained";
  ballAndPaddle = throw "'ballAndPaddle' has been removed because it was broken and abandoned upstream"; # Added 2023-10-16
  bashInteractive_5 = bashInteractive; # Added 2021-08-20
  bash_5 = bash; # Added 2021-08-20
  bazel_3 = throw "bazel 3 is past end of life as it is not an lts version"; # Added 2023-02-02
  bazel_4 = throw "'bazel_4' has been removed from nixpkgs as it has reached end of life"; # Added 2024-01-23
  bedup = throw "bedup was removed because it was broken and abandoned upstream"; # added 2023-02-04
  bee-unstable = throw "bee-unstable has been removed, use 'bee' instead"; # Added 2024-02-12
  bee-clef = throw "bee-clef has been removed as the upstream project was archived"; # Added 2024-02-12
  beignet = throw "beignet was removed as it was never ported from old llvmPackages_6 upstream"; # added 2024-01-08
  binance = throw "binance has been removed, because it depends on a very outdated and insecure version of electron"; # Added 2023-11-09
  bird2 = bird; # Added 2022-02-21
  bitwarden = bitwarden-desktop; # Added 2024-02-25
  bitwig-studio1 = throw "bitwig-studio1 has been removed, you can upgrade to 'bitwig-studio'"; # Added 2023-01-03
  bitwig-studio2 = throw "bitwig-studio2 has been removed, you can upgrade to 'bitwig-studio'"; # Added 2023-01-03
  blender-with-packages = args:
    lib.warn "blender-with-packages is deprecated in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"
      (blender.withPackages (_: args.packages)).overrideAttrs
      (lib.optionalAttrs (args ? name) { pname = "blender-" + args.name; }); # Added 2023-10-30
  blockbench-electron = blockbench; # Added 2024-03-16
  bluezFull = throw "'bluezFull' has been renamed to/replaced by 'bluez'"; # Converted to throw 2023-09-10
  bookletimposer = throw "bookletimposer has been removed from nixpkgs; upstream unmaintained and broke with pypdf3"; # Added 2024-01-01
  boost168 = throw "boost168 has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost169 = throw "boost169 has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost16x = throw "boost16x has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost170 = throw "boost170 has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost172 = throw "boost172 has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost173 = throw "boost173 has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost174 = throw "boost174 has been deprecated in favor of the latest version"; # Added 2023-06-08
  boost17x = throw "boost17x has been deprecated in favor of the latest version"; # Added 2023-07-13
  boost18x = throw "boost18x has been deprecated in favor of the latest version"; # Added 2023-07-13
  bpb = throw "bpb has been removed as it is unmaintained and not compatible with recent Rust versions"; # Added 2024-04-30
  bpftool = bpftools; # Added 2021-05-03
  bpytop = throw "bpytop has been deprecated by btop"; # Added 2023-02-16
  bro = throw "'bro' has been renamed to/replaced by 'zeek'"; # Converted to throw 2023-09-10
  inherit (libsForQt5.mauiPackages) buho; # added 2022-05-17
  bukut = throw "bukut has been removed since it has been archived by upstream"; # Added 2023-05-24
  # Shorter names; keep the longer name for back-compat. Added 2023-04-11
  buildFHSUserEnv = buildFHSEnv;
  buildFHSUserEnvChroot = buildFHSEnvChroot;
  buildFHSUserEnvBubblewrap = buildFHSEnvBubblewrap;

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = vaultwarden;
  bitwarden_rs-mysql = vaultwarden-mysql;
  bitwarden_rs-postgresql = vaultwarden-postgresql;
  bitwarden_rs-sqlite = vaultwarden-sqlite;
  bitwarden_rs-vault = vaultwarden-vault;



  ### C ###

  callPackage_i686 = pkgsi686Linux.callPackage;
  cadence = throw "cadence has been removed from nixpkgs, as it was archived upstream"; # Added 2023-10-28
  cask = emacs.pkgs.cask; # Added 2022-11-12
  canonicalize-jars-hook = stripJavaArchivesHook; # Added 2024-03-17
  cargo-deps = throw "cargo-deps has been removed as the repository is deleted"; # Added 2024-04-09
  cargo-embed = throw "cargo-embed is now part of the probe-rs package"; # Added 2023-07-03
  cargo-espflash = espflash;
  cargo-flash = throw "cargo-flash is now part of the probe-rs package"; # Added 2023-07-03
  cargo-graph = throw "cargo-graph has been removed as it is broken and archived upstream"; # Added 2024-03-16
  catfish = throw "'catfish' has been renamed to/replaced by 'xfce.catfish'"; # Converted to throw 2023-09-10
  cawbird = throw "cawbird has been abandoned upstream and is broken anyways due to Twitter closing its API";
  ccloud-cli = throw "ccloud-cli has been removed, please use confluent-cli instead"; # Added 2023-06-09
  certmgr-selfsigned = certmgr; # Added 2023-11-30
  chefdk = throw "chefdk has been removed due to being deprecated upstream by Chef Workstation"; # Added 2023-03-22
  chia = throw "chia has been removed. see https://github.com/NixOS/nixpkgs/pull/270254"; # Added 2023-11-30
  chia-dev-tools = throw "chia-dev-tools has been removed. see https://github.com/NixOS/nixpkgs/pull/270254"; # Added 2023-11-30
  chia-plotter = throw "chia-plotter has been removed. see https://github.com/NixOS/nixpkgs/pull/270254"; # Added 2023-11-30
  chkservice = throw "chkservice has been removed from nixpkgs, as it has been deleted upstream"; # Added 2024-01-08
  chocolateDoom = chocolate-doom; # Added 2023-05-01
  chrome-gnome-shell = gnome-browser-connector; # Added 2022-07-27
  chromiumBeta = throw "'chromiumBeta' has been removed due to the lack of maintenance in nixpkgs. Consider using 'chromium' instead."; # Added 2023-10-18
  chromiumDev = throw "'chromiumDev' has been removed due to the lack of maintenance in nixpkgs. Consider using 'chromium' instead."; # Added 2023-10-18
  citra = throw "citra has been removed from nixpkgs, as it has been taken down upstream"; # added 2024-03-04
  citra-nightly = throw "citra-nightly has been removed from nixpkgs, as it has been taken down upstream"; # added 2024-03-04
  citra-canary = throw "citra-canary has been removed from nixpkgs, as it has been taken down upstream"; # added 2024-03-04
  clang-ocl = throw "'clang-ocl' has been replaced with 'rocmPackages.clang-ocl'"; # Added 2023-10-08
  inherit (libsForQt5.mauiPackages) clip; # added 2022-05-17
  clpm = throw "'clpm' has been removed from nixpkgs"; # Added 2024-04-01
  clwrapperFunction = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  collada-dom = opencollada; # added 2024-02-21
  composable_kernel = throw "'composable_kernel' has been replaced with 'rocmPackages.composable_kernel'"; # Added 2023-10-08
  cope = throw "'cope' has been removed, as it is broken in nixpkgs since it was added, and fixing it is not trivial"; # Added 2024-04-12
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  crispyDoom = crispy-doom; # Added 2023-05-01
  cryptowatch-desktop = throw "Cryptowatch Desktop was sunset on September 30th 2023 and has been removed from nixpkgs"; # Added 2023-12-22
  clash = throw "'clash' has been removed, upstream gone. Consider using 'mihomo' instead."; # added 2023-11-10
  clasp = clingo; # added 2022-12-22
  claws-mail-gtk3 = claws-mail; # Added 2021-07-10
  clucene_core_1 = throw "'clucene_core_1' has been renamed to/replaced by 'clucene_core'"; # Added 2023-12-09
  cntk = throw "'cntk' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2023-10-09
  cockroachdb = throw "'cockroachdb' has been removed as it was outdated and unmaintained. Use 'cockroachdb-bin' instead"; # 2024-03-15
  codimd = hedgedoc; # Added 2020-11-29
  inherit (libsForQt5.mauiPackages) communicator; # added 2022-05-17
  compton = throw "'compton' has been renamed to/replaced by 'picom'"; # Converted to throw 2023-09-10
  concurrencykit = libck; # Added 2021-03
  connmanPackages = throw "'connmanPackages' was removed and their subpackages/attributes were promoted to top level."; # Added 2023-10-08
  convoy = throw "'convoy' has been removed from nixpkgs, as it was archived upstream"; # Added 2023-12-27
  crda = throw "'crda' has been removed from nixpkgs, as it is needed only for kernels before 4.16"; # Added 2024-02-06
  cups-kyodialog3 = cups-kyodialog; # Added 2022-11-12
  cvs_fast_export = cvs-fast-export; # Added 2021-06-10

  # these are for convenience, not for backward compat and shouldn't expire
  clang6Stdenv = throw "clang6Stdenv has been removed from nixpkgs"; # Added 2024-01-08
  clang7Stdenv = throw "clang7Stdenv has been removed from nixpkgs"; # Added 2023-11-19
  clang8Stdenv = throw "clang8Stdenv has been removed from nixpkgs"; # Added 2024-01-24
  clang9Stdenv = throw "clang9Stdenv has been removed from nixpkgs"; # Added 2024-04-08
  clang10Stdenv = throw "clang10Stdenv has been removed from nixpkgs"; # Added 2024-01-26
  clang11Stdenv = throw "clang11Stdenv has been removed from nixpkgs"; # Added 2023-01-24
  clang12Stdenv = lowPrio llvmPackages_12.stdenv;
  clang13Stdenv = lowPrio llvmPackages_13.stdenv;
  clang14Stdenv = lowPrio llvmPackages_14.stdenv;
  clang15Stdenv = lowPrio llvmPackages_15.stdenv;
  clang16Stdenv = lowPrio llvmPackages_16.stdenv;
  clang17Stdenv = lowPrio llvmPackages_17.stdenv;

  clang-tools_6 = throw "clang-tools_6 has been removed from nixpkgs"; # Added 2024-01-08
  clang-tools_7 = throw "clang-tools_7 has been removed from nixpkgs"; # Added 2023-11-19
  clang-tools_8  = throw "clang-tools_8 has been removed from nixpkgs"; # Added 2024-01-24
  clang-tools_9 = throw "clang-tools_9 has been removed from nixpkgs"; # Added 2024-04-08
  clang-tools_10 = throw "clang-tools_10 has been removed from nixpkgs"; # Added 2023-01-26
  clang-tools_11 = throw "clang-tools_11 has been removed from nixpkgs"; # Added 2023-01-24
  clang_6 = throw "clang_6 has been removed from nixpkgs"; # Added 2024-01-08
  clang_7 = throw "clang_7 has been removed from nixpkgs"; # Added 2023-11-19
  clang_8  = throw "clang_8 has been removed from nixpkgs"; # Added 2024-01-24
  clang_9 = throw "clang_9 has been removed from nixpkgs"; # Added 2024-04-08
  clang_10 = throw "clang_10 has been removed from nixpkgs"; # Added 2024-01-26
  clang_11 = throw "clang_11 has been removed from nixpkgs"; # Added 2023-01-24

  cq-editor = throw "cq-editor has been removed, as it use a dependency that was disabled since python 3.8 and was last updated in 2021"; # Added 2024-05-13
  ### D ###

  dagger = throw "'dagger' has been removed from nixpkgs, as the trademark policy of the upstream project is incompatible"; # Added 2023-10-16
  dart_stable = dart; # Added 2020-01-15
  dart-sass-embedded = throw "dart-sass-embedded has been removed from nixpkgs, as is now included in Dart Sass itself.";
  dat = nodePackages.dat;
  dbeaver = throw "'dbeaver' has been renamed to/replaced by 'dbeaver-bin'"; # Added 2024-05-16
  deadcode = throw "'deadcode' has been removed, as upstream is abandoned since 2019-04-27. Use the official deadcode from 'gotools' package."; # Added 2023-12-28
  deadpixi-sam = deadpixi-sam-unstable;

  debugedit-unstable = debugedit; # Added 2021-11-22
  deltachat-electron = deltachat-desktop; # added 2021-07-18

  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  dep = throw "'dep' has been removed, because it is deprecated and archived in favor of Go modules"; # Added 2023-12-26
  devserver = throw "'devserver' has been removed in favor of 'miniserve' or other alternatives"; # Added 2023-01-13
  dfeet = throw "'dfeet' has been removed because it is archived upstream. Please use 'd-spy' instead"; # Added 2024-03-07
  dgsh = throw "'dgsh' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  dhcp = throw "dhcp (ISC DHCP) has been removed from nixpkgs, because it reached its end of life"; # Added 2023-04-04
  dibbler = throw "dibbler was removed because it is not maintained anymore"; # Added 2024-05-14
  dnnl = oneDNN; # Added 2020-04-22
  docker-machine = throw "'docker-machine' has been removed, because the upstream project was archived"; # Added 2023-12-27
  docker-machine-kvm = throw "'docker-machine-kvm' has been removed, because 'docker-machine' was archived upstream and removed"; # Added 2023-12-27
  docker-machine-xhyve = throw "'docker-machine-xhyve' has been removed, because 'docker-machine' was archived upstream and removed"; # Added 2023-12-27
  docker-proxy = throw "`docker-proxy` has been merged to the main repo of Moby since Docker 22.06"; # Added 2024-03-14
  dogecoin = throw "'dogecoin' has been removed, as it was broken and unmaintained"; # Added 2024-03-11
  dogecoind = throw "'dogecoind' has been removed, as it was broken and unmaintained"; # Added 2024-03-11
  dolphin-emu-beta = dolphin-emu; # Added 2023-02-11
  dolphinEmu = dolphin-emu; # Added 2021-11-10
  dolphinEmuMaster = dolphin-emu-beta; # Added 2021-11-10
  dot-http = throw "'dot-http' has been removed: abandoned by upstream. Use hurl instead."; # Added 2023-01-16
  dotty = scala_3; # Added 2023-08-20
  dotnet-netcore = dotnet-runtime; # Added 2021-10-07
  dotnet-sdk_2 = dotnetCorePackages.sdk_2_1; # Added 2020-01-19
  dotnet-sdk_3 = dotnetCorePackages.sdk_3_1; # Added 2020-01-19
  dotnet-sdk_5 = dotnetCorePackages.sdk_5_0; # Added 2020-09-11
  drgeo = throw "'drgeo' has been removed as it is outdated and unmaintained"; # Added 2023-10-15
  drush = throw "drush as a standalone package has been removed because it's no longer supported as a standalone tool";
  dtv-scan-tables_linuxtv = dtv-scan-tables; # Added 2023-03-03
  dtv-scan-tables_tvheadend = dtv-scan-tables; # Added 2023-03-03
  du-dust = dust; # Added 2024-01-19
  dylibbundler = macdylibbundler; # Added 2021-04-24

  ### E ###

  EBTKS = ebtks; # Added 2024-01-21
  ec2_ami_tools = ec2-ami-tools; # Added 2021-10-08
  ec2_api_tools = ec2-api-tools; # Added 2021-10-08
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01

  elasticsearch7Plugins = elasticsearchPlugins;

  # Electron
  electron_9 = throw "electron_9 has been removed in favor of newer versions"; # added 2023-09-11
  electron_10 = throw "electron_10 has been removed in favor of newer versions"; # added 2024-03-20
  electron_10-bin = throw "electron_10-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_11 = throw "electron_11 has been removed in favor of newer versions"; # added 2024-03-20
  electron_11-bin = throw "electron_11-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_12 = throw "electron_12 has been removed in favor of newer versions"; # added 2024-03-20
  electron_12-bin = throw "electron_12-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_13 = throw "electron_13 has been removed in favor of newer versions"; # added 2024-03-20
  electron_13-bin = throw "electron_13-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_14 = throw "electron_14 has been removed in favor of newer versions"; # added 2024-03-20
  electron_14-bin = throw "electron_14-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_15 = throw "electron_15 has been removed in favor of newer versions"; # added 2024-03-20
  electron_15-bin = throw "electron_15-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_16 = throw "electron_16 has been removed in favor of newer versions"; # added 2024-03-20
  electron_16-bin = throw "electron_16-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_17 = throw "electron_17 has been removed in favor of newer versions"; # added 2024-03-20
  electron_17-bin = throw "electron_17-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_18 = throw "electron_18 has been removed in favor of newer versions"; # added 2024-03-20
  electron_18-bin = throw "electron_18-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_19 = throw "electron_19 has been removed in favor of newer versions"; # added 2024-03-20
  electron_19-bin = throw "electron_19-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_20 = throw "electron_20 has been removed in favor of newer versions"; # added 2024-03-20
  electron_20-bin = throw "electron_20-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_21 = throw "electron_21 has been removed in favor of newer versions"; # added 2024-03-20
  electron_21-bin = throw "electron_21-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_22 = throw "electron_22 has been removed in favor of newer versions"; # added 2024-03-20
  electron_22-bin = throw "electron_22-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_23 = throw "electron_23 has been removed in favor of newer versions"; # added 2024-03-20
  electron_23-bin = throw "electron_23-bin has been removed in favor of newer versions"; # added 2024-03-20
  electron_26 = throw "electron_26 has been removed in favor of newer versions"; # added 2024-03-20
  electron_26-bin = throw "electron_26-bin has been removed in favor of newer versions"; # added 2024-03-20

  elementary-planner = throw "elementary-planner has been renamed to planify"; # Added 2023-06-24

  elixir_ls = elixir-ls; # Added 2023-03-20

  # Emacs
  emacs28NativeComp = emacs28; # Added 2022-06-08
  emacs28Packages = emacs28.pkgs; # Added 2021-10-04
  emacs28WithPackages = emacs28.pkgs.withPackages; # Added 2021-10-04
  emacsMacport = emacs-macport; # Added 2023-08-10
  emacsNativeComp = emacs28NativeComp; # Added 2022-06-08
  emacsPackagesNg = throw "'emacsPackagesNg' has been renamed to/replaced by 'emacs.pkgs'"; # Converted to throw 2023-09-10
  emacsPackagesNgFor = throw "'emacsPackagesNgFor' has been renamed to/replaced by 'emacsPackagesFor'"; # Converted to throw 2023-09-10
  emacsWithPackages = emacs.pkgs.withPackages; # Added 2020-12-18

  empathy = throw "empathy was removed as it is unmaintained and no longer launches due to libsoup3 migration"; # Added 2023-01-20
  enchant1 = throw "enchant1 has been removed from nixpkgs, as it was unmaintained"; # Added 2023-01-18
  enyo-doom = enyo-launcher; # Added 2022-09-09
  epoxy = libepoxy; # Added 2021-11-11

  erlang_27-rc3 = throw "erlang_27-rc3 has been removed in favor of erlang_27"; # added 2024-05-20
  erlangR24 = throw "erlangR24 has been removed in favor of erlang_24"; # added 2024-05-24
  erlangR24_odbc = throw "erlangR24_odbc has been removed in favor of erlang_24_odbc"; # added 2024-05-24
  erlangR24_javac = throw "erlangR24_javac has been removed in favor of erlang_24_javac"; # added 2024-05-24
  erlangR24_odbc_javac = throw "erlangR24_odbc_javac has been removed in favor of erlang_24_odbc_javac"; # added 2024-05-24
  erlangR25 = throw "erlangR25 has been removed in favor of erlang_25"; # added 2024-05-24
  erlangR25_odbc = throw "erlangR25_odbc has been removed in favor of erlang_25_odbc"; # added 2024-05-24
  erlangR25_javac = throw "erlangR25_javac has been removed in favor of erlang_25_javac"; # added 2024-05-24
  erlangR25_odbc_javac = throw "erlangR25_odbc_javac has been removed in favor of erlang_25_odbc_javac"; # added 2024-05-24
  erlangR26 = throw "erlangR26 has been removed in favor of erlang_26"; # added 2024-05-24
  erlangR26_odbc = throw "erlangR26_odbc has been removed in favor of erlang_26_odbc"; # added 2024-05-24
  erlangR26_javac = throw "erlangR26_javac has been removed in favor of erlang_26_javac"; # added 2024-05-24
  erlangR26_odbc_javac = throw "erlangR26_odbc_javac has been removed in favor of erlang_26_odbc_javac"; # added 2024-05-24

  etcd_3_3 = throw "etcd_3_3 has been removed because upstream no longer maintains it"; # Added 2023-09-29
  etcher = throw "'etcher' has been removed because it depended on an insecure version of Electron"; # Added 2024-03-14
  eterm = throw "eterm was removed because it is still insecure: https://github.com/mej/Eterm/issues/7"; # Added 2023-09-10
  exa = throw "'exa' has been removed because it is unmaintained upstream. Consider using 'eza', a maintained fork"; # Added 2023-09-07
  exhibitor = throw "'exhibitor' has been removed because it is unmaintained upstream"; # Added 2023-06-20
  eww-wayland = lib.warn "eww now can build for X11 and wayland simultaneously, so `eww-wayland` is deprecated, use the normal `eww` package instead." eww;

  ### F ###

  fancypp = throw "'fancypp' was removed because it and its dependants are unmaintained"; # Added 2024-02-14
  faustStk = faustPhysicalModeling; # Added 2023-05-16
  fastnlo = fastnlo-toolkit; # Added 2021-04-24
  fastnlo_toolkit = fastnlo-toolkit; # Added 2024-01-03
  inherit (luaPackages) fennel; # Added 2022-09-24
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve
  findimagedupes = throw "findimagedupes has been removed because the perl bindings are no longer compatible"; # Added 2023-07-10
  finger_bsd = bsd-finger;
  fingerd_bsd = bsd-fingerd;
  firefox-wayland = firefox; # Added 2022-11-15
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  fitnesstrax = throw "fitnesstrax was removed from nixpkgs because it disappeared upstream and no longer compiles"; # added 2023-07-04
  flashrom-stable = flashprog;   # Added 2024-03-01
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  flintqs = throw "FlintQS has been removed due to lack of maintenance and security issues; use SageMath or FLINT instead"; # Added 2024-03-21
  flutter2 = throw "flutter2 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2023-07-03
  flutter37 = throw "flutter37 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2023-07-03
  foldingathome = fahclient; # Added 2020-09-03
  forgejo-actions-runner = forgejo-runner; # Added 2024-04-04

  foundationdb51 = throw "foundationdb51 is no longer maintained, use foundationdb71 instead"; # added 2023-06-06
  foundationdb52 = throw "foundationdb52 is no longer maintained, use foundationdb71 instead"; # added 2023-06-06
  foundationdb60 = throw "foundationdb60 is no longer maintained, use foundationdb71 instead"; # added 2023-06-06
  foundationdb61 = throw "foundationdb61 is no longer maintained, use foundationdb71 instead"; # added 2023-06-06
  foxitreader = throw "foxitreader has been removed because it had vulnerabilities and was unmaintained"; # added 2023-02-20
  fractal-next = fractal; # added 2023-11-25
  framework-system-tools = framework-tool; # added 2023-12-09
  fritzprofiles = throw "fritzprofiles was removed from nixpkgs, because it was removed as dependency of home-assistant for which it was pacakged."; # added 2024-01-05
  fuse2fs = if stdenv.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  futuresql = libsForQt5.futuresql; # added 2023-11-11
  fx_cast_bridge = fx-cast-bridge; # added 2023-07-26

  fcitx = throw "fcitx is deprecated, please use fcitx5 instead."; # Added 2023-03-13
  fcitx-engines = throw "fcitx-engines is deprecated, please use fcitx5 instead."; # Added 2023-03-13
  fcitx-configtool = throw "fcitx-configtool is deprecated, please use fcitx5 instead."; # Added 2023-03-13

  fcitx5-chinese-addons = libsForQt5.fcitx5-chinese-addons; # Added 2024-03-01
  fcitx5-configtool = libsForQt5.fcitx5-configtool; # Added 2024-03-01
  fcitx5-skk-qt = libsForQt5.fcitx5-skk-qt; # Added 2024-03-01
  fcitx5-unikey = libsForQt5.fcitx5-unikey; # Added 2024-03-01
  fcitx5-with-addons = libsForQt5.fcitx5-with-addons; # Added 2024-03-01

  ### G ###

  g4py = python3Packages.geant4; # Added 2020-06-06
  garage_0_7 = throw "garage 0.7.x has been removed as it is EOL. Please upgrade to 0.8 series."; # Added 2023-10-10
  garage_0_7_3 = throw "garage 0.7.x has been removed as it is EOL. Please upgrade to 0.8 series."; # Added 2023-10-10
  garmin-plugin = throw "garmin-plugin has been removed, as it is unmaintained upstream and no longer works with modern browsers."; # Added 2024-01-12
  garmindev = throw "'garmindev' has been removed as the dependent software 'qlandkartegt' has been removed"; # Added 2023-04-17
  gcc10StdenvCompat = if stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11" then gcc10Stdenv else stdenv; # Added 2024-03-21
  gcl_2_6_13_pre = throw "'gcl_2_6_13_pre' has been removed in favor of 'gcl'"; # Added 2024-01-11
  geekbench4 = throw "'geekbench4' has been renamed to 'geekbench_4'"; # Added 2023-03-10
  geekbench5 = throw "'geekbench5' has been renamed to 'geekbench_5'"; # Added 2023-03-10
  ghostwriter = libsForQt5.kdeGear.ghostwriter; # Added 2023-03-18
  go-dependency-manager = throw "'go-dependency-manager' is unmaintained and the go community now uses 'go.mod' mostly instead"; # Added 2023-10-04
  gotktrix = throw "'gotktrix' has been removed, as it was broken and unmaintained"; # Added 2023-12-06
  git-credential-1password = throw "'git-credential-1password' has been removed, as the upstream project is deleted."; # Added 2024-05-20
  git-subset = throw "'git-subset' has been removed in favor of 'git-filter-repo'"; # Added 2023-01-13

  gitAndTools = self // {
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  }; # Added 2021-01-14

  gitter = throw "gitter has been removed since the client has been abandoned by upstream with the backend migration to Matrix"; # Added 2023-09-18
  glide = throw "'glide' has been removed as it is unmaintained, please use Go modules instead"; # Added 2023-12-26
  glfw-wayland = glfw; # Added 2024-04-19
  gmailieer = lieer; # Added 2020-04-19
  gmic-qt-krita = throw "gmic-qt-krita was removed as it's no longer supported upstream."; # Converted to throw 2023-02-02
  gnatboot11 = gnat-bootstrap11;
  gnatboot12 = gnat-bootstrap12;
  gnatboot = gnat-bootstrap;
  gnatcoll-core     = gnatPackages.gnatcoll-core; # Added 2024-02-25
  gnatcoll-gmp      = gnatPackages.gnatcoll-gmp; # Added 2024-02-25
  gnatcoll-iconv    = gnatPackages.gnatcoll-iconv; # Added 2024-02-25
  gnatcoll-lzma     = gnatPackages.gnatcoll-lzma; # Added 2024-02-25
  gnatcoll-omp      = gnatPackages.gnatcoll-omp; # Added 2024-02-25
  gnatcoll-python3  = gnatPackages.gnatcoll-python3; # Added 2024-02-25
  gnatcoll-readline = gnatPackages.gnatcoll-readline; # Added 2024-02-25
  gnatcoll-syslog   = gnatPackages.gnatcoll-syslog; # Added 2024-02-25
  gnatcoll-zlib     = gnatPackages.gnatcoll-zlib; # Added 2024-02-25
  gnatcoll-postgres = gnatPackages.gnatcoll-postgres; # Added 2024-02-25
  gnatcoll-sql      = gnatPackages.gnatcoll-sql; # Added 2024-02-25
  gnatcoll-sqlite   = gnatPackages.gnatcoll-sqlite; # Added 2024-02-25
  gnatcoll-xref     = gnatPackages.gnatcoll-xref; # Added 2024-02-25
  gnatcoll-db2ada   = gnatPackages.gnatcoll-db2ada; # Added 2024-02-25
  gnatinspect = gnatPackages.gnatinspect; # Added 2024-02-25
  gnome-firmware-updater = gnome-firmware; # added 2022-04-14
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome-mpv = throw "'gnome-mpv' has been renamed to/replaced by 'celluloid'"; # Converted to throw 2023-09-10
  gnome-resources = resources; # added 2023-12-10
  gnome_user_docs = throw "'gnome_user_docs' has been renamed to/replaced by 'gnome-user-docs'"; # Converted to throw 2023-09-10

  gnuradio-with-packages = gnuradio3_7.override {
    extraPackages = lib.attrVals [
      "osmosdr"
      "ais"
      "gsm"
      "nacl"
      "rds"
      "limesdr"
    ]
      gnuradio3_7Packages;
  }; # Added 2020-10-16

  gmock = gtest; # moved from top-level 2021-03-14

  gnome3 = gnome; # Added 2021-05-07
  gnuradio3_7 = throw "gnuradio3_7 has been removed because it required Python 2"; # Added 2022-01-16
  gnuradio-ais = throw "'gnuradio-ais' has been renamed to/replaced by 'gnuradio3_7.pkgs.ais'"; # Converted to throw 2023-09-10
  gnuradio-gsm = throw "'gnuradio-gsm' has been renamed to/replaced by 'gnuradio3_7.pkgs.gsm'"; # Converted to throw 2023-09-10
  gnuradio-limesdr = throw "'gnuradio-limesdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.limesdr'"; # Converted to throw 2023-09-10
  gnuradio-nacl = throw "'gnuradio-nacl' has been renamed to/replaced by 'gnuradio3_7.pkgs.nacl'"; # Converted to throw 2023-09-10
  gnuradio-osmosdr = throw "'gnuradio-osmosdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.osmosdr'"; # Converted to throw 2023-09-10
  gnuradio-rds = throw "'gnuradio-rds' has been renamed to/replaced by 'gnuradio3_7.pkgs.rds'"; # Converted to throw 2023-09-10
  go2nix = throw "'go2nix' has been removed as it was archived upstream"; # Added 2023-12-27
  gobby5 = gobby; # Added 2021-02-01

  #godot
  godot = throw "godot has been renamed to godot3 to distinguish from version 4"; # Added 2023-07-16
  godot-export-templates = throw "godot-export-templates has been renamed to godot3-export-templates to distinguish from version 4"; # Added 2023-07-16
  godot-headless = throw "godot-headless has been renamed to godot3-headless to distinguish from version 4"; # Added 2023-07-16
  godot-server = throw "godot-server has been renamed to godot3-server to distinguish from version 4"; # Added 2023-07-16

  google-chrome-beta = throw "'google-chrome-beta' has been removed due to the lack of maintenance in nixpkgs. Consider using 'google-chrome' instead."; # Added 2023-10-18
  google-chrome-dev = throw "'google-chrome-dev' has been removed due to the lack of maintenance in nixpkgs. Consider using 'google-chrome' instead."; # Added 2023-10-18
  google-gflags = throw "'google-gflags' has been renamed to/replaced by 'gflags'"; # Converted to throw 2023-09-10
  go-thumbnailer = thud; # Added 2023-09-21
  gocode = throw "'gocode' has been removed as the upstream project was archived. 'gopls' is suggested as replacement"; # Added 2023-12-26
  govendor = throw "'govendor' has been removed as it is no longer maintained upstream, please use Go modules instead"; # Added 2023-12-26
  gometer = throw "gometer has been removed from nixpkgs because goLance stopped offering Linux support"; # Added 2023-02-10
  gprbuild-boot = gnatPackages.gprbuild-boot; # Added 2024-02-25;

  gpt4all-chat = throw "gpt4all-chat has been renamed to gpt4all"; # Added 2024-02-27

  graalvm11-ce = throw "graalvm11-ce has been removed because upstream dropped support to different JDK versions for each GraalVM release. Please use graalvm-ce instead"; # Added 2023-09-26
  graalvm17-ce = throw "graalvm17-ce has been removed because upstream dropped support to different JDK versions for each GraalVM release. Please use graalvm-ce instead"; # Added 2023-09-26
  graalvm19-ce = throw "graalvm19-ce has been removed because upstream dropped support to different JDK versions for each GraalVM release. Please use graalvm-ce instead"; # Added 2023-09-26
  grab-site = throw "grab-site has been removed because it's unmaintained and broken"; # Added 2023-11-12
  gradle_4 = throw "gradle_4 has been removed because it's no longer being updated"; # Added 2023-01-17
  gradle_5 = throw "gradle_5 has been removed because it's no longer being updated"; # Added 2023-01-17
  gr-ais = throw "'gr-ais' has been renamed to/replaced by 'gnuradio3_7.pkgs.ais'"; # Converted to throw 2023-09-10
  graylog = throw "graylog is now available in versions 3.3 up to 5.0. Please mind the upgrade path and choose the appropriate version. Direct upgrading from 3.3 to 4.3 or above is not supported"; # Added 2023-04-24
  graylog-3_3 = throw "graylog 3.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 3.x to latest series."; # Added 2023-10-09
  graylog-4_0 = throw "graylog 4.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 4.x to latest series."; # Added 2023-10-09
  graylog-4_3 = throw "graylog 4.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 4.x to latest series."; # Added 2023-10-09
  graylog-5_0 = throw "graylog 5.0.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.0.x to latest series."; # Added 2024-02-15
  gr-gsm = throw "'gr-gsm' has been renamed to/replaced by 'gnuradio3_7.pkgs.gsm'"; # Converted to throw 2023-09-10
  gringo = clingo; # added 2022-11-27
  gr-limesdr = throw "'gr-limesdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.limesdr'"; # Converted to throw 2023-09-10
  gr-nacl = throw "'gr-nacl' has been renamed to/replaced by 'gnuradio3_7.pkgs.nacl'"; # Converted to throw 2023-09-10
  gr-osmosdr = throw "'gr-osmosdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.osmosdr'"; # Converted to throw 2023-09-10
  gr-rds = throw "'gr-rds' has been renamed to/replaced by 'gnuradio3_7.pkgs.rds'"; # Converted to throw 2023-09-10
  grub2_full = grub2; # Added 2022-11-18
  grub = throw "grub1 was removed after not being maintained upstream for a decade. Please switch to another bootloader"; # Added 2023-04-11
  gtkcord4 = dissent; # Added 2024-03-10
  gtkpod = throw "'gtkpod' was removed due to one of its dependencies, 'anjuta' being unmaintained"; # Added 2024-01-16
  guile-disarchive = disarchive; # Added 2023-10-27
  guile-lint = throw "'guile-lint' has been removed, please use 'guild lint' instead"; # Added 2023-10-16

  ### H ###

  haxe_3_2 = throw "'haxe_3_2' has been removed because it is old and no longer used by any packages in nixpkgs"; # Added 2023-03-15
  haxe_3_4 = throw "'haxe_3_4' has been removed because it is old and no longer used by any packages in nixpkgs"; # Added 2023-03-15
  hepmc = throw "'hepmc' has been renamed to/replaced by 'hepmc2'"; # Converted to throw 2023-09-10
  hikari = throw "hikari has been removed from nixpkgs, it was unmaintained and required wlroots_0_15 at the time of removal"; # Added 2024-03-28
  hip = throw "'hip' has been removed in favor of 'rocmPackages.clr'"; # Added 2023-10-08
  hipcc = throw "'hipcc' has been replaced with 'rocmPackages.hipcc'"; # Added 2023-10-08
  hipchat = throw "'hipchat' has been discontinued since 2019; upstream recommends Slack."; # Added 2023-12-02
  hipify = throw "'hipify' has been replaced with 'rocmPackages.hipify'"; # Added 2023-10-08
  hipcub = throw "'hipcub' has been replaced with 'rocmPackages.hipcub'"; # Added 2023-10-08
  hipsparse = throw "'hipsparse' has been replaced with 'rocmPackages.hipsparse'"; # Added 2023-10-08
  hipfort = throw "'hipfort' has been replaced with 'rocmPackages.hipfort'"; # Added 2023-10-08
  hipfft = throw "'hipfft' has been replaced with 'rocmPackages.hipfft'"; # Added 2023-10-08
  hipsolver = throw "'hipsolver' has been replaced with 'rocmPackages.hipsolver'"; # Added 2023-10-08
  hipblas = throw "'hipblas' has been replaced with 'rocmPackages.hipblas'"; # Added 2023-10-08
  hip-amd = throw "'hip-amd' has been removed in favor of 'rocmPackages.clr'"; # Added 2023-10-08
  hip-common = throw "'hip-common' has been replaced with 'rocmPackages.hip-common'"; # Added 2023-10-08
  hip-nvidia = throw "'hip-nvidia' has been removed in favor of 'rocmPackages.clr'"; # Added 2023-10-08
  ht-rust = xh; # Added 2021-02-13
  hydra-unstable = hydra_unstable; # added 2022-05-10
  hyper-haskell = throw "'hyper-haskell' has been removed. reason: has been broken for a long time and depends on an insecure electron version"; # Added 2024-03-14
  hyper-haskell-server-with-packages = throw "'hyper-haskell-server-with-packages' has been removed. reason: has been broken for a long time"; # Added 2024-03-14

  ### I ###

  i3-gaps = i3; # Added 2023-01-03
  icedtea8_web = throw "'icedtea8_web' has been renamed to/replaced by 'adoptopenjdk-icedtea-web'"; # Converted to throw 2023-09-10
  icedtea_web = throw "'icedtea_web' has been renamed to/replaced by 'adoptopenjdk-icedtea-web'"; # Converted to throw 2023-09-10
  ignite = throw "'ignite' has been removed as the upstream project was archived, please use 'flintlock' instead"; # Added 2024-01-07
  imag = throw "'imag' has been removed, upstream gone"; # Added 2023-01-13
  imagemagick7Big = imagemagickBig; # Added 2021-02-22
  imagemagick7 = imagemagick; # Added 2021-02-22
  imagemagick7_light = imagemagick_light; # Added 2021-02-22
  imlib = throw "imlib has been dropped due to the lack of maintenance from upstream since 2004"; # Added 2023-01-04
  indiepass-desktop = throw "indiepass-desktop has been dropped because it does not work with recent Electron versions"; # Added 2024-03-14
  indigenous-desktop = throw "'indigenous-desktop' has been renamed to/replaced by 'indiepass-desktop'"; # Added 2023-11-08
  instead-launcher = throw "instead-launcher has been removed, because it depended on qt4"; # Added 2023-07-26
  insync-v3 = throw "insync-v3 has been merged into the insync package; use insync instead"; #Added 2023-05-13
  index-fm = libsForQt5.mauiPackages.index; # added 2022-05-17
  infiniband-diags = throw "'infiniband-diags' has been renamed to/replaced by 'rdma-core'"; # Converted to throw 2023-09-10
  inotifyTools = inotify-tools;
  inter-ui = inter; # Added 2021-03-27
  iouyap = throw "'iouyap' is deprecated and archived by upstream, use 'ubridge' instead"; # Added 2023-09-21
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-migrator-all-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  iproute = iproute2; # moved from top-level 2021-03-14

  ### J ###


  jack2Full = jack2; # moved from top-level 2021-03-14
  jami-client-qt = jami-client; # Added 2022-11-06
  jami-client = jami; # Added 2023-02-10
  jami-daemon = jami.daemon; # Added 2023-02-10
  jfbpdf = throw "'jfbpdf' has been removed, because it depends on an outdated and insecure version of mupdf"; # Added 2023-06-27
  jfbview = throw "'jfbview' has been removed, because it depends on an outdated and insecure version of mupdf"; # Added 2023-06-27
  jira-cli = throw "jira-cli was removed because it is no longer maintained"; # Added 2023-02-28
  join-desktop = throw "'join-desktop' has been removed because it is unmaintained upstream"; # Added 2023-10-04

  # Julia
  julia_18 = throw "'julia_18' has been removed from nixpkgs as it has reached end of life"; # Added 2024-01-11
  julia_18-bin = throw "'julia_18-bin' has been removed from nixpkgs as it has reached end of life"; # Added 2024-01-11

  jush = throw "jush has been removed from nixpkgs because it is unmaintained"; # Added 2024-05-28

  ### K ###

  k3s_1_24 = throw "'k3s_1_24' has been removed from nixpkgs as it has reached end of life"; # Added 2024-03-14
  k3s_1_25 = throw "'k3s_1_25' has been removed from nixpkgs as it has reached end of life"; # Added 2024-03-14
  k3s_1_26 = throw "'k3s_1_26' has been removed from nixpkgs as it has reached end of life"; # Added 2024-05-20
  # k3d was a 3d editing software k-3d - "k3d has been removed because it was broken and has seen no release since 2016" Added 2022-01-04
  # now kube3d/k3d will take it's place
  kube3d = k3d; # Added 2022-0705
  kafkacat = kcat; # Added 2021-10-07
  kak-lsp = kakoune-lsp; # Added 2024-04-01
  kdbplus = throw "'kdbplus' has been removed from nixpkgs"; # Added 2024-05-06
  kdeconnect = plasma5Packages.kdeconnect-kde; # Added 2020-10-28
  keepassx = throw "KeePassX is no longer actively developed. Please consider KeePassXC as a maintained alternative."; # Added 2023-02-17
  keepassx2 = throw "KeePassX is no longer actively developed. Please consider KeePassXC as a maintained alternative."; # Added 2023-02-17
  keepkey_agent = keepkey-agent; # added 2024-01-06
  kerberos = libkrb5; # moved from top-level 2021-03-14
  kexectools = kexec-tools; # Added 2021-09-03
  keysmith = libsForQt5.kdeGear.keysmith; # Added 2021-07-14
  kfctl = throw "kfctl is broken and has been archived by upstream"; # Added 2023-08-21
  kgx = gnome-console; # Added 2022-02-19
  kibana7 = throw "Kibana 7.x has been removed from nixpkgs as it depends on an end of life Node.js version and received no maintenance in time."; # Added 2023-30-10
  kibana = kibana7;
  kicad-with-packages3d = throw "'kicad-with-packages3d' has been renamed to/replaced by 'kicad'"; # Converted to throw 2023-09-10
  kio-admin = libsForQt5.kdeGear.kio-admin; # Added 2023-03-18
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  kramdown-rfc2629 = rubyPackages.kramdown-rfc2629; # Added 2021-03-23
  krb5Full = krb5;
  krita-beta = krita; # moved from top-level 2021-12-23
  kubei = kubeclarity; # Added 2023-05-20
  kuma-prometheus-sd = throw "kuma-prometheus-sd has been deprecated upstream"; # Added 2023-07-02

  ### L ###

  larynx = piper-tts; # Added 2023-05-09
  latinmodern-math = lmmath;
  ldgallery = throw "'ldgallery' has been removed from nixpkgs. Use the Flake provided by ldgallery instead"; # Added 2023-07-26
  ledger_agent = ledger-agent; # Added 2024-01-07
  lfs = dysk; # Added 2023-07-03
  llvmPackages_rocm = throw "'llvmPackages_rocm' has been replaced with 'rocmPackages.llvm'"; # Added 2023-10-08
  libayatana-indicator-gtk3 = libayatana-indicator; # Added 2022-10-18
  libayatana-appindicator-gtk3 = libayatana-appindicator; # Added 2022-10-18
  libbencodetools = bencodetools; # Added 2022-07-30
  libbpf_1 = libbpf; # Added 2022-12-06
  libbson = mongoc; # Added 2024-03-11
  libcap_pam = throw "'libcap_pam' has been replaced with 'libcap'"; # Converted to throw 2023-09-10
  libclc = llvmPackages_latest.libclc; # Added 2023-10-28
  libcxxabi = throw "'libcxxabi' was merged into 'libcxx'"; # Converted to throw 2024-03-08
  libdwarf_20210528 = throw "'libdwarf_20210528' has been removed because it is not used in nixpkgs, move to libdwarf"; # Added 2024-03-23
  libgme = game-music-emu; # Added 2022-07-20
  libgpgerror = libgpg-error; # Added 2021-09-04
  libheimdal = heimdal; # Added 2022-11-18
  libintlOrEmpty = throw "'libintlOrEmpty' has been replaced by gettext"; # Converted to throw 2023-09-10
  libixp_hg = libixp;
  libjpeg_drop = libjpeg_original; # Added 2020-06-05
  liblastfm = libsForQt5.liblastfm; # Added 2020-06-14
  libmongo-client = throw "'libmongo-client' has been removed, upstream gone"; # Added 2023-06-22
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libquotient = libsForQt5.libquotient; # Added 2023-11-11
  libraw_unstable = throw "'libraw_unstable' has been removed, please use libraw"; # Added 2023-01-30
  librdf = lrdf; # Added 2020-03-22
  libressl_3_5 = throw "'libressl_3_5' has reached end-of-life "; # Added 2023-05-07
  librtlsdr = rtl-sdr; # Added 2023-02-18
  librewolf-wayland = librewolf; # Added 2022-11-15
  libseat = seatd; # Added 2021-06-24
  libsigcxx12 = throw "'libsigcxx12' has been removed, please use newer versions"; # Added 2023-10-20
  libsForQt515 = libsForQt5; # Added 2022-11-24
  libtensorflow-bin = libtensorflow; # Added 2022-09-25
  libtorrentRasterbar = libtorrent-rasterbar; # Added 2020-12-20
  libtorrentRasterbar-1_2_x = libtorrent-rasterbar-1_2_x; # Added 2020-12-20
  libtorrentRasterbar-2_0_x = libtorrent-rasterbar-2_0_x; # Added 2020-12-20
  libungif = giflib; # Added 2020-02-12
  libusb = libusb1; # Added 2020-04-28
  libwnck3 = libwnck;
  libyamlcpp = yaml-cpp; # Added 2023-01-29
  libyamlcpp_0_3 = yaml-cpp_0_3; # Added 2023-01-29
  libxkbcommon_7 = throw "libxkbcommon_7 has been removed because it is impacted by security issues and not used in nixpkgs, move to 'libxkbcommon'"; # Added 2023-01-03
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  lightstep-tracer-cpp = throw "lightstep-tracer-cpp is deprecated since 2022-08-29; the upstream recommends migration to opentelemetry projects.";
  lispPackages_new = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  lispPackages = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  lispPackagesFor = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  llama = walk; # Added 2023-01-23

  # Linux kernels
  linux-rt_5_10 = linuxKernel.kernels.linux_rt_5_10;
  linux-rt_5_15 = linuxKernel.kernels.linux_rt_5_15;
  linux-rt_5_4 = linuxKernel.kernels.linux_rt_5_4;
  linux-rt_6_1 = linuxKernel.kernels.linux_rt_6_1;
  linuxPackages_4_14 = linuxKernel.packages.linux_4_14;
  linuxPackages_4_19 = linuxKernel.packages.linux_4_19;
  linuxPackages_4_9 = linuxKernel.packages.linux_4_9;
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_5_18 = linuxKernel.packages.linux_5_18;
  linuxPackages_5_19 = linuxKernel.packages.linux_5_19;
  linuxPackages_5_4 = linuxKernel.packages.linux_5_4;
  linuxPackages_6_0 = linuxKernel.packages.linux_6_0;
  linuxPackages_6_1 = linuxKernel.packages.linux_6_1;
  linuxPackages_6_2 = linuxKernel.packages.linux_6_2;
  linuxPackages_6_3 = linuxKernel.packages.linux_6_3;
  linuxPackages_6_4 = linuxKernel.packages.linux_6_4;
  linuxPackages_6_5 = linuxKernel.packages.linux_6_5;
  linuxPackages_6_6 = linuxKernel.packages.linux_6_6;
  linuxPackages_6_7 = linuxKernel.packages.linux_6_7;
  linuxPackages_6_8 = linuxKernel.packages.linux_6_8;
  linuxPackages_6_9 = linuxKernel.packages.linux_6_9;
  linuxPackages_rpi0 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi02w = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi1 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi2 = linuxKernel.packages.linux_rpi2;
  linuxPackages_rpi3 = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi4 = linuxKernel.packages.linux_rpi4;
  linuxPackages_rt_5_10 = linuxKernel.packages.linux_rt_5_10;
  linuxPackages_rt_5_15 = linuxKernel.packages.linux_rt_5_15;
  linuxPackages_rt_5_4 = linuxKernel.packages.linux_rt_5_4;
  linuxPackages_rt_6_1 = linuxKernel.packages.linux_rt_6_1;
  linux_4_14 = linuxKernel.kernels.linux_4_14;
  linux_4_19 = linuxKernel.kernels.linux_4_19;
  linux_4_9 = linuxKernel.kernels.linux_4_9;
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_5_18 = linuxKernel.kernels.linux_5_18;
  linux_5_19 = linuxKernel.kernels.linux_5_19;
  linux_5_4 = linuxKernel.kernels.linux_5_4;
  linux_6_0 = linuxKernel.kernels.linux_6_0;
  linux_6_1 = linuxKernel.kernels.linux_6_1;
  linux_6_2 = linuxKernel.kernels.linux_6_2;
  linux_6_3 = linuxKernel.kernels.linux_6_3;
  linux_6_4 = linuxKernel.kernels.linux_6_4;
  linux_6_5 = linuxKernel.kernels.linux_6_5;
  linux_6_6 = linuxKernel.kernels.linux_6_6;
  linux_6_7 = linuxKernel.kernels.linux_6_7;
  linux_6_8 = linuxKernel.kernels.linux_6_8;
  linux_6_9 = linuxKernel.kernels.linux_6_9;
  linux_rpi0 = linuxKernel.kernels.linux_rpi1;
  linux_rpi02w = linuxKernel.kernels.linux_rpi3;
  linux_rpi1 = linuxKernel.kernels.linux_rpi1;
  linux_rpi2 = linuxKernel.kernels.linux_rpi2;
  linux_rpi3 = linuxKernel.kernels.linux_rpi3;
  linux_rpi4 = linuxKernel.kernels.linux_rpi4;

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

  # Added 2023-11-18, modified 2024-01-09
  linuxPackages_testing_bcachefs = throw "'linuxPackages_testing_bcachefs' has been removed, please use 'linuxPackages_latest', any kernel version at least 6.7, or any other linux kernel with bcachefs support";
  linux_testing_bcachefs = throw "'linux_testing_bcachefs' has been removed, please use 'linux_latest', any kernel version at least 6.7, or any other linux kernel with bcachefs support";

  lld_6 = throw "lld_6 has been removed from nixpkgs"; # Added 2024-01-08
  lld_7 = throw "lld_7 has been removed from nixpkgs"; # Added 2023-11-19
  lld_8 = throw "lld_8 has been removed from nixpkgs"; # Added 2024-01-24
  lld_9 = throw "lld_9 has been removed from nixpkgs"; # Added 2024-04-08
  lld_10 = throw "lld_10 has been removed from nixpkgs"; # Added 2024-01-26
  lld_11 = throw "lld_11 has been removed from nixpkgs"; # Added 2024-01-24
  lldb_6 = throw "lldb_6 has been removed from nixpkgs"; # Added 2024-01-08
  lldb_7 = throw "lldb_7 has been removed from nixpkgs"; # Added 2023-11-19
  lldb_8 = throw "lldb_8 has been removed from nixpkgs"; # Added 2024-01-24
  lldb_9 = throw "lldb_9 has been removed from nixpkgs"; # Added 2024-04-08
  lldb_10 = throw "lldb_10 has been removed from nixpkgs"; # Added 2024-01-26
  lldb_11 = throw "lldb_11 has been removed from nixpkgs"; # Added 2024-01-24
  llvmPackages_6 = throw "llvmPackages_6 has been removed from nixpkgs"; # Added 2024-01-09
  llvmPackages_7 = throw "llvmPackages_7 has been removed from nixpkgs"; # Added 2023-11-19
  llvmPackages_8 = throw "llvmPackages_8 has been removed from nixpkgs"; # Added 2024-01-24
  llvmPackages_9 = throw "llvmPackages_9 has been removed from nixpkgs"; # Added 2024-04-08
  llvmPackages_10 = throw "llvmPackages_10 has been removed from nixpkgs"; # Added 2024-01-26
  llvmPackages_11 = throw "llvmPackages_11 has been removed from nixpkgs"; # Added 2024-01-24
  llvm_6 = throw "llvm_6 has been removed from nixpkgs"; # Added 2024-01-08
  llvm_7 = throw "llvm_7 has been removed from nixpkgs"; # Added 2023-11-19
  llvm_8 = throw "llvm_8 has been removed from nixpkgs"; # Added 2024-01-24
  llvm_9 = throw "llvm_9 has been removed from nixpkgs"; # Added 2024-04-08
  llvm_10 = throw "llvm_10 has been removed from nixpkgs"; # Added 2024-01-26
  llvm_11 = throw "llvm_11 has been removed from nixpkgs"; # Added 2024-01-24

  lobster-two = google-fonts; # Added 2021-07-22
  luxcorerender = throw "'luxcorerender' has been removed as it's unmaintained and broken in nixpkgs since a while ago"; # Added 2023-06-07
  lxd = lib.warn "lxd has been renamed to lxd-lts" lxd-lts; # Added 2024-04-01
  lxd-unwrapped = lib.warn "lxd-unwrapped has been renamed to lxd-unwrapped-lts" lxd-unwrapped-lts; # Added 2024-04-01
  lzma = xz; # moved from top-level 2021-03-14

  ### M ###

  MACS2 = macs2; # Added 2023-06-12
  mariadb_104 = throw "mariadb_104 has been removed from nixpkgs, please switch to another version like mariadb_106"; # Added 2023-09-11
  mariadb_1010 = throw "mariadb_1010 has been removed from nixpkgs, please switch to another version like mariadb_1011"; # Added 2023-11-14
  mariadb-client = hiPrio mariadb.client; #added 2019.07.28
  markdown-pp = throw "markdown-pp was removed from nixpkgs, because the upstream archived it on 2021-09-02"; # Added 2023-07-22
  markmind = throw "markmind has been removed from nixpkgs, because it depended on an old version of electron"; # Added 2023-09-12
  matrique = spectral; # Added 2020-01-27
  matrixcli = throw "'matrixcli' has been removed due to being unmaintained and broken functionality. Recommend 'matrix-commander' as an alternative"; # Added 2024-03-09
  matrix-recorder = throw "matrix-recorder has been removed due to being unmaintained"; # Added 2023-05-21
  maui-nota = libsForQt5.mauiPackages.nota; # added 2022-05-17
  mbox = throw "'mbox' has been removed, as it was broken and unmaintained"; # Added 2023-12-21
  mcomix3 = mcomix; # Added 2022-06-05
  meme = meme-image-generator; # Added 2021-04-21
  mess = throw "'mess' has been renamed to/replaced by 'mame'"; # Converted to throw 2023-09-10
  microsoft_gsl = microsoft-gsl; # Added 2023-05-26
  migraphx = throw "'migraphx' has been replaced with 'rocmPackages.migraphx'"; # Added 2023-10-08
  minishift = throw "'minishift' has been removed as it was discontinued upstream. Use 'crc' to setup a microshift cluster instead"; # Added 2023-12-30
  miopen = throw "'miopen' has been replaced with 'rocmPackages.miopen'"; # Added 2023-10-08
  miopengemm = throw "'miopengemm' has been replaced with 'rocmPackages_5.miopengemm'"; # Added 2023-10-08
  miopen-hip = throw "'miopen-hip' has been replaced with 'rocmPackages.miopen-hip'"; # Added 2023-10-08
  miopen-opencl = throw "'miopen-opencl' has been replaced with 'rocmPackages.miopen-opencl'"; # Added 2023-10-08
  mime-types = mailcap; # Added 2022-01-21
  minetestclient_5 = minetestclient; # Added 2023-12-11
  minetestserver_5 = minetestserver; # Added 2023-12-11
  minizip2 = pkgs.minizip-ng; # Added 2022-12-28
  mirage-im = throw "'mirage-im' has been removed, as it was broken and unmaintained"; # Added 2023-11-26
  mlton20210107 = throw "'mlton20210107' has been renamed to 'mlton20210117', correcting the version number"; # Added 2024-03-31
  mod_dnssd = apacheHttpdPackages.mod_dnssd; # Added 2014-11-07
  mod_fastcgi = apacheHttpdPackages.mod_fastcgi; # Added 2014-11-07
  mod_python = apacheHttpdPackages.mod_python; # Added 2014-11-07
  mod_wsgi = apacheHttpdPackages.mod_wsgi; # Added 2014-11-07
  mod_ca = apacheHttpdPackages.mod_ca; # Added 2019-12-24
  mod_crl = apacheHttpdPackages.mod_crl; # Added 2019-12-24
  mod_csr = apacheHttpdPackages.mod_csr; # Added 2019-12-24
  mod_ocsp = apacheHttpdPackages.mod_ocsp; # Added 2019-12-24
  mod_scep = apacheHttpdPackages.mod_scep; # Added 2019-12-24
  mod_spkac = apacheHttpdPackages.mod_spkac; # Added 2019-12-24
  mod_pkcs12 = apacheHttpdPackages.mod_pkcs12; # Added 2019-12-24
  mod_timestamp = apacheHttpdPackages.mod_timestamp; # Added 2019-12-24
  monero = monero-cli; # Added 2021-11-28
  moneyplex = throw "'moneyplex' has been removed, as it was broken and unmaintained"; # Added 2024-02-28
  mongodb-4_0 = throw "mongodb-4_0 has been removed, it's end of life since April 2022"; # Added 2023-01-05
  mongodb-4_2 = throw "mongodb-4_2 has been removed, it's end of life since April 2023"; # Added 2023-06-06
  mongodb-4_4 = throw "mongodb-4_4 has been removed, it's end of life since April 2024"; # Added 2024-04-11
  moonlander = throw "'moonlander' has been removed due to it being broken and unmaintained"; # Added 2023-11-26
  moz-phab = mozphab; # Added 2022-08-09
  mozart-binary = throw "'mozart-binary' has been renamed to/replaced by 'mozart2-binary'"; # Converted to throw 2023-09-10
  mozart = throw "'mozart' has been renamed to/replaced by 'mozart2-binary'"; # Converted to throw 2023-09-10
  mpc_cli = mpc-cli; # moved from top-level 2022-01-24
  mpd_clientlib = libmpdclient; # Added 2021-02-11
  mpdevil = plattenalbum; # Added 2024-05-22
  mpg321 = throw "'mpg321' has been removed due to it being unmaintained by upstream. Consider using mpg123 instead."; # Added 2024-05-10
  mumble_git = throw "'mumble_git' has been renamed to/replaced by 'pkgs.mumble'"; # Converted to throw 2023-09-10
  murmur_git = throw "'murmur_git' has been renamed to/replaced by 'pkgs.murmur'"; # Converted to throw 2023-09-10
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mysql-client = hiPrio mariadb.client;
  mysql = mariadb; # moved from top-level 2021-03-14

  # floating point textures patents are expired,
  # so package reduced to alias
  mesa_drivers = mesa.drivers;

  ### N ###

  ncdu_2 = ncdu; # Added 2022-07-22
  nestopia = throw "nestopia was forked; use nestopia-ue instead"; # Added 2024-01-24
  net_snmp = throw "'net_snmp' has been renamed to/replaced by 'net-snmp'"; # Converted to throw 2023-09-10
  netbox_3_3 = throw "netbox 3.3 series has been removed as it was EOL"; # Added 2023-09-02
  netbox_3_5 = throw "netbox 3.5 series has been removed as it was EOL"; # Added 2024-01-22
  netease-music-tui = throw "netease-music-tui has been removed due to unmaintained by upstream and broken functionality"; # Added 2024-03-03
  nextcloud26 = throw ''
    Nextcloud v26 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2024-04. Please upgrade to at least Nextcloud v27 by declaring

        services.nextcloud.package = pkgs.nextcloud27;

    in your NixOS config.

    WARNING: if you were on Nextcloud 25 you have to upgrade to Nextcloud 26
    first on 23.11 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2023-10-13
  nextcloud25Packages = throw "Nextcloud25 is EOL!"; # Added 2023-10-13
  nagiosPluginsOfficial = monitoring-plugins;
  neochat = libsForQt5.kdeGear.neochat; # added 2022-05-10
  neoload = throw "'neoload' has been removed as it is broken and unmaintained"; # Added 2024-03-02
  nitrokey-udev-rules = libnitrokey; # Added 2023-03-25
  nix-direnv-flakes = nix-direnv;
  nix-repl = throw (
    # Added 2018-08-26
    "nix-repl has been removed because it's not maintained anymore, " +
    "use `nix repl` instead. Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );
  nix-review = throw "'nix-review' has been renamed to/replaced by 'nixpkgs-review'"; # Converted to throw 2023-09-10
  nix-template-rpm = throw "'nix-template-rpm' has been removed as it is broken and unmaintained"; # Added 2023-11-20
  nixFlakes = nixVersions.stable; # Added 2021-05-21
  nixStable = nixVersions.stable; # Added 2022-01-24
  nixUnstable = nixVersions.unstable; # Added 2022-01-26
  nix_2_3 = nixVersions.nix_2_3;
  nix_2_4 = nixVersions.nix_2_4;
  nix_2_5 = nixVersions.nix_2_5;
  nix_2_6 = nixVersions.nix_2_6;
  nixfmt = lib.warn "nixfmt was renamed to nixfmt-classic. The nixfmt attribute may be used for the new RFC 166-style formatter in the future, which is currently available as nixfmt-rfc-style" nixfmt-classic; # Added 2024-03-31
  nixops = throw "'nixops' has been removed. Please use 'nixops_unstable_minimal' for the time being. E.g. nixops_unstable_minimal.withPlugins (ps: [ ps.nixops-gce ])"; # Added 2023-10-26
  nixopsUnstable = nixops_unstable; # Added 2022-03-03

  # When the nixops_unstable alias is removed, nixops_unstable_minimal can be renamed to nixops_unstable.
  nixops_unstable = throw "nixops_unstable has been replaced. Please use for example 'nixops_unstable_minimal.withPlugins (ps: [ ps.nixops-gce ps.nixops-encrypted-links ])' instead"; # Added 2024-02-28

  nixosTest = testers.nixosTest; # Added 2022-05-05
  nmap-unfree = nmap; # Added 2021-04-06
  nodejs_14 = throw "nodejs_14 has been removed as it is EOL."; # Added 2023-10-30
  nodejs-slim_14 = throw "nodejs-slim_14 has been removed as it is EOL."; # Added 2023-10-30
  nodejs-14_x = nodejs_14; # Added 2022-11-06
  nodejs-slim-14_x = nodejs-slim_14; # Added 2022-11-06
  nodejs_16 = throw "nodejs_16 has been removed as it is EOL."; # Added 2023-10-30
  nodejs-16_x = nodejs_16; # Added 2022-11-06
  nodejs-16_x-openssl_1_1 = throw "nodejs-16_x-openssl_1_1 has been removed."; # Added 2023-02-04
  nodejs-slim_16 = throw "nodejs-slim_16 has been removed as it is EOL."; # Added 2022-11-06
  nodejs-slim-16_x = nodejs-slim_16; # Added 2022-11-06
  nodejs-18_x = nodejs_18; # Added 2022-11-06
  nodejs-slim-18_x = nodejs-slim_18; # Added 2022-11-06
  nomad_1_2 = throw "nomad_1_2 has been removed because it's outdated. Use a a newer version instead"; # Added 2023-09-02
  nomad_1_3 = throw "nomad_1_3 has been removed because it's outdated. Use a a newer version instead"; # Added 2023-09-02
  noto-fonts-cjk = noto-fonts-cjk-sans; # Added 2021-12-16
  noto-fonts-emoji = noto-fonts-color-emoji; # Added 2023-09-09
  noto-fonts-extra = noto-fonts; # Added 2023-04-08
  NSPlist = nsplist; # Added 2024-01-05
  nvidia-thrust = throw "nvidia-thrust has been removed because the project was deprecated; use cudaPackages.cuda_cccl";
  nvtop = lib.warn "nvtop has been renamed to nvtopPackages.full" nvtopPackages.full; # Added 2024-02-25
  nvtop-amd = lib.warn "nvtop-amd has been renamed to nvtopPackages.amd" nvtopPackages.amd; # Added 2024-02-25
  nvtop-nvidia = lib.warn "nvtop-nvidia has been renamed to nvtopPackages.nvidia" nvtopPackages.nvidia; # Added 2024-02-25
  nvtop-intel = lib.warn "nvtop-intel has been renamed to nvtopPackages.intel" nvtopPackages.intel; # Added 2024-02-25
  nvtop-msm = lib.warn "nvtop-msm has been renamed to nvtopPackages.msm" nvtopPackages.msm; # Added 2024-02-25

  ### O ###

  o = orbiton; # Added 2023-04-09
  oathToolkit = oath-toolkit; # Added 2022-04-04
  oauth2_proxy = oauth2-proxy; # Added 2021-04-18
  obinskit = throw "'obinskit' has been removed from nixpkgs, because the package was unmaintained and depended on an insecure version of electron"; # Added 2024-03-20
  octant = throw "octant has been dropped due to being archived and vulnerable"; # Added 2023-09-29
  octant-desktop = throw "octant-desktop has been dropped due to being archived and vulnerable"; # Added 2023-09-29
  octorpki = throw "octorpki has been removed, upstream says to use rpki-client instead"; # Added 2024-03-19
  ogre1_9 = throw "ogre1_9 has been removed, use ogre instead"; # Added 2023-03-22
  ogre1_10 = throw "ogre1_10 has been removed, use ogre instead"; # Added 2023-07-20
  opa = throw "opa has been removed from nixpkgs as upstream has abandoned the project"; # Added 2023-03-21
  opam_1_2 = throw "'opam_1_2' has been renamed to/replaced by 'opam'"; # Added 2023-03-08
  openafs_1_8 = openafs; # Added 2022-08-22
  openapi-generator-cli-unstable = throw "openapi-generator-cli-unstable was removed as it was not being updated; consider openapi-generator-cli instead"; # Added 2024-01-02
  openbangla-keyboard = throw "openbangla-keyboard has been replaced by ibus-engines.openbangla-keyboard and fcitx5-openbangla-keyboard"; # added 2023-10-10
  opencascade = throw "'opencascade' has been removed as it is unmaintained; consider opencascade-occt instead'"; # Added 2023-09-18
  openconnect_head = openconnect_unstable; # Added 2022-03-29
  openconnect_gnutls = openconnect; # Added 2022-03-29
  openconnect_unstable = throw "openconnect_unstable was removed from nixpkgs as it was not being updated"; # Added 2023-06-01
  openelec-dvb-firmware = libreelec-dvb-firmware; # Added 2021-05-10
  openethereum = throw "openethereum development has ceased by upstream. Use alternate clients such as go-ethereum, erigon, or nethermind"; # Added 2024-05-13
  openimagedenoise_1_2_x = throw "'openimagedenoise_1_2_x' has been renamed to/replaced by 'openimagedenoise'"; # Added 2023-06-07
  openimageio2 = openimageio; # Added 2023-01-05
  openimageio_1 = throw "'openimageio_1' has been removed, please update to 'openimageio' 2"; # Added 2023-06-14
  openisns = open-isns; # Added 2020-01-28
  openjpeg_2 = openjpeg; # Added 2021-01-25
  openmpt123 = libopenmpt; # Added 2021-09-05
  openssl_3_0 = openssl_3; # Added 2022-06-27
  openvpn_24 = throw "openvpn_24 has been removed, because it went EOL. 2.5.x or newer is still available"; # Added 2023-01-23
  optparse-bash = throw "'optparse-bash' (GitHub: nk412/optparse) has been removed. Use 'argparse' instead"; # Added 2024-01-12
  orchis = orchis-theme; # Added 2021-06-09
  oni2 = throw "oni2 was removed, because it is unmaintained and was abandoned years ago."; #Added 2024-01-15
  onlyoffice-bin_7_2 = throw "onlyoffice-bin_7_2 has been renamed to onlyoffice-bin"; # Added 2024-02-05
  onlyoffice-bin_7_5 = throw "onlyoffice-bin_7_5 has been renamed to onlyoffice-bin_latest (and updated from 7.5.x)"; # Added 2024-02-05
  oroborus = throw "oroborus was removed, because it was abandoned years ago."; #Added 2023-09-10
  osxfuse = macfuse-stubs; # Added 2021-03-20
  oxen = throw "'oxen' has been removed, because it was broken, outdated and unmaintained"; # Added 2023-12-09

  ### P ###

  PageEdit = pageedit; # Added 2024-01-21
  packet-cli = metal-cli; # Added 2021-10-25
  packet = throw "packet has been removed as it is no longer working and unmaintained"; # Added 2024-03-29
  palemoon = throw "palemoon has been dropped due to python2 being EOL and marked insecure. Use 'palemoon-bin' instead"; # Added 2023-05-18
  pam_usb = throw "'pam_usb' has been removed: abandoned by upstream since 2015."; # Added 2023-10-30
  paper-note = throw "paper-note has been removed: abandoned by upstream"; # Added 2023-05-03
  paperless = paperless-ngx; # Added 2021-06-06
  paperless-ng = paperless-ngx; # Added 2022-04-11
  parity = throw "parity, renamed to openethereum, has been terminated by upstream"; # Added 2020-08-01
  partition-manager = libsForQt5.partitionmanager; # Added 2024-01-08
  pash = throw "'pash' has been removed: abandoned by upstream. Use 'powershell' instead"; # Added 2023-09-16
  patchelfStable = patchelf; # Added 2024-01-25
  pcsctools = pcsc-tools; # Added 2023-12-07
  pdf2xml = throw "'pdf2xml' was removed: abandoned for years."; # Added 2023-10-22
  peach = asouldocs; # Added 2022-08-28
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  percona-server_8_0 = percona-server_lts; # Added 2024-05-07
  percona-xtrabackup_8_0 = percona-xtrabackup_lts; # Added 2024-05-07
  perldevel = throw "'perldevel' has been dropped due to lack of updates in nixpkgs and lack of consistent support for devel versions by 'perl-cross' releases, use 'perl' instead";
  perldevelPackages = perldevel;
  petrinizer = throw "'petrinizer' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  pgadmin = pgadmin4;
  pharo-spur64 = pharo; # Added 2022-08-03
  phodav_2_0 = throw "'phodav_2_0' has been renamed to/replaced by 'phodav'"; # Added 2023-02-21
  photoflow = throw "photoflow was removed because it was broken and unmaintained by upstream"; # Added 2023-03-10
  picom-allusive = throw "picom-allusive was renamed to compfy and is being abandoned by upstream"; # Added 2024-02-13
  picom-jonaburg = throw "picom-jonaburg was removed because it is unmaintained by upstream"; # Added 2024-02-13
  picom-next = picom; # Added 2024-02-13

  # Obsolete PHP version aliases
  php80 = throw "php80 has been dropped due to the lack of maintenance from upstream for future releases"; # Added 2023-06-21
  php80Packages = php80; # Added 2023-06-21
  php80Extensions = php80; # Added 2023-06-21

  pipewire-media-session = throw "pipewire-media-session is no longer maintained and has been removed. Please use Wireplumber instead.";
  pkgconfig = throw "'pkgconfig' has been renamed to/replaced by 'pkg-config'"; # Converted to throw 2023-09-10
  pleroma-otp = pleroma; # Added 2021-07-10
  pltScheme = racket; # just to be sure
  pmdk = throw "'pmdk' is discontinued, no further support or maintenance is planned by upstream"; # Added 2023-02-06
  pomotroid = throw "pomotroid has been removed from nixpkgs, because it depended on an insecure version of electron"; # Added 2023-09-12
  powerdns = pdns; # Added 2022-03-28

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
  timescaledb = postgresqlPackages.timescaledb;
  tsearch_extras = postgresqlPackages.tsearch_extras;

  # pinentry was using multiple outputs, this emulates the old interface for i.e. home-manager
  # soon: throw "'pinentry' has been removed. Pick an appropriate variant like 'pinentry-curses' or 'pinentry-gnome3'";
  pinentry = pinentry-all // {
    curses = pinentry-curses;
    emacs = pinentry-emacs;
    gnome3 = pinentry-gnome3;
    gtk2 = pinentry-gtk2;
    qt = pinentry-qt;
    tty = pinentry-tty;
    flavors = [ "curses" "emacs" "gnome3" "gtk2" "qt" "tty" ];
  }; # added 2024-01-15
  pinentry_curses = throw "'pinentry_curses' has been renamed to/replaced by 'pinentry-curses'"; # Converted to throw 2023-09-10
  pinentry_emacs = throw "'pinentry_emacs' has been renamed to/replaced by 'pinentry-emacs'"; # Converted to throw 2023-09-10
  pinentry_gnome = throw "'pinentry_gnome' has been renamed to/replaced by 'pinentry-gnome'"; # Converted to throw 2023-09-10
  pinentry_gtk2 = throw "'pinentry_gtk2' has been renamed to/replaced by 'pinentry-gtk2'"; # Converted to throw 2023-09-10
  pinentry_qt = throw "'pinentry_qt' has been renamed to/replaced by 'pinentry-qt'"; # Converted to throw 2023-09-10
  pinentry_qt5 = pinentry-qt; # Added 2020-02-11

  PlistCpp = plistcpp; # Added 2024-01-05
  pocket-updater-utility = pupdate; # Added 2024-01-25
  poetry2nix = throw "poetry2nix is now maintained out-of-tree. Please use https://github.com/nix-community/poetry2nix/"; # Added 2023-10-26
  prayer = throw "prayer has been removed from nixpkgs"; # Added 2023-11-09
  prismlauncher-qt5 = throw "'prismlauncher-qt5' has been removed from nixpkgs. Please use 'prismlauncher'"; # Added 2024-04-20
  prismlauncher-qt5-unwrapped = throw "'prismlauncher-qt5-unwrapped' has been removed from nixpkgs. Please use 'prismlauncher-unwrapped'"; # Added 2024-04-20
  privacyidea = throw "privacyidea has been removed from nixpkgs"; # Added 2023-10-31
  probe-rs-cli = throw "probe-rs-cli is now part of the probe-rs package"; # Added 2023-07-03
  processing3 = throw "'processing3' has been renamed to/replaced by 'processing'"; # Converted to throw 2023-09-10
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-openvpn-exporter = throw "'prometheus-openvpn-exporter' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2023-12-23
  prometheus-speedtest-exporter = throw "prometheus-speedtest-exporter was removed as unmaintained"; # Added 2023-07-31
  protobuf3_17 = throw "protobuf3_17 does not receive updates anymore and has been removed"; # Added 2023-05-21
  protobuf3_19 = throw "protobuf3_19 does not receive updates anymore and has been removed"; # Added 2023-10-01
  protobuf3_24 = protobuf_24;
  protobuf3_23 = protobuf_23;
  protobuf3_21 = protobuf_21;
  protonup = protonup-ng; # Added 2022-11-06
  proxmark3-rrg = proxmark3; # Added 2023-07-25
  proxmark3-unstable = throw "removed in favor of rfidresearchgroup fork"; # Added 2023-07-25
  pyls-black = throw "pyls-black has been removed from nixpkgs. Use python-lsp-black instead."; # Added 2023-01-09
  pyls-mypy = throw "pyls-mypy has been removed from nixpkgs. Use pylsp-mypy instead."; # Added 2023-01-09
  pygmentex = throw "'pygmentex' has been renamed to/replaced by 'texlive.bin.pygmentex'"; # Converted to throw 2023-09-10
  pyo3-pack = maturin;
  pypi2nix = throw "pypi2nix has been removed due to being unmaintained";
  pypolicyd-spf = spf-engine; # Added 2022-10-09
  python = python2; # Added 2022-01-11
  python-language-server = throw "python-language-server has been removed as it is no longer maintained. Use e.g. python-lsp-server instead"; # Added 2023-01-07
  python-swiftclient = swiftclient; # Added 2021-09-09
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11

  ### Q ###

  qcsxcad = libsForQt5.qcsxcad; # Added 2020-11-05
  qtcreator-qt6 = throw "'qtcreator-qt6' has been renamed to/replaced by 'qtcreator', since qt5 version has been removed"; # Added 2023-07-25
  qflipper = qFlipper; # Added 2022-02-11
  qlandkartegt = throw "'qlandkartegt' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2023-04-17
  qscintilla = libsForQt5.qscintilla; # Added 2023-09-20
  qscintilla-qt6 = qt6Packages.qscintilla; # Added 2023-09-20
  qt515 = qt5; # Added 2022-11-24
  qt5ct = libsForQt5.qt5ct; # Added 2021-12-27
  qt6ct = qt6Packages.qt6ct; # Added 2023-03-07
  qtcurve = libsForQt5.qtcurve; # Added 2020-11-07
  qtile-unwrapped = python3.pkgs.qtile; # Added 2023-05-12
  quantum-espresso-mpi = quantum-espresso; # Added 2023-11-23
  quicklispPackages = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesABCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesCCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesClisp = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesECL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesFor = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesGCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  quicklispPackagesSBCL = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  qutebrowser-qt6 = throw "'qutebrowser-qt6' has been replaced by 'qutebrowser', since the the qt5 version has been removed"; # Added 2023-08-19
  quvi = throw "'quvi' has been removed, as it was broken and unmaintained"; # Added 2023-11-25

  ### R ###

  radare2-cutter = cutter; # Added 2021-03-30
  radicle-cli = throw "'radicle-cli' was removed in favor of 'radicle-node'"; # Added 2024-05-04
  radicle-upstream = throw "'radicle-upstream' was sunset, see <https://community.radworks.org/t/2962>"; # Added 2024-05-04
  railway-travel = diebahn; # Added 2024-04-01
  rambox-pro = rambox; # Added 2022-12-12
  rarian = throw "rarian has been removed as unused"; # Added 2023-07-05
  rccl = throw "'rccl' has been replaced with 'rocmPackages.rccl'"; # Added 2023-10-08
  rdc = throw "'rdc' has been replaced with 'rocmPackages.rdc'"; # Added 2023-10-08
  readline63 = throw "'readline63' has been replaced with 'readline'"; # Added 2024-02-10
  redocly-cli = redocly; # Added 2024-04-14
  redpanda = redpanda-client; # Added 2023-10-14
  restya-board = throw "'restya-board' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-01-22
  retdec-full = throw "'retdec-full' is no longer needed, please use 'retdec'"; # Added 2024-02-05
  retroshare06 = retroshare;
  ricochet = throw "ricochet has been deprecated in favor of ricochet-refresh"; # Added 2024-02-26
  rigsofrods = rigsofrods-bin; # Added 2023-03-22
  ring-daemon = jami-daemon; # Added 2021-10-26
  rnix-lsp = throw "'rnix-lsp' has been removed as it is unmaintained"; # Added 2024-03-09
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rocalution = throw "'rocalution' has been replaced with 'rocmPackages.rocalution'"; # Added 2023-10-08
  rocblas = throw "'rocblas' has been replaced with 'rocmPackages.rocblas'"; # Added 2023-10-08
  rocfft = throw "'rocfft' has been replaced with 'rocmPackages.rocfft'"; # Added 2023-10-08
  rocprim = throw "'rocprim' has been replaced with 'rocmPackages.rocprim'"; # Added 2023-10-08
  rocrand = throw "'rocrand' has been replaced with 'rocmPackages.rocrand'"; # Added 2023-10-08
  rocsparse = throw "'rocsparse' has been replaced with 'rocmPackages.rocsparse'"; # Added 2023-10-08
  rocthrust = throw "'rocthrust' has been replaced with 'rocmPackages.rocthrust'"; # Added 2023-10-08
  roctracer = throw "'roctracer' has been replaced with 'rocmPackages.roctracer'"; # Added 2023-10-08
  rocwmma = throw "'rocwmma' has been replaced with 'rocmPackages.rocwmma'"; # Added 2023-10-08
  rocclr = throw "'rocclr' has been removed in favor of 'rocmPackages.clr'"; # Added 2023-10-08
  rocdbgapi = throw "'rocdbgapi' has been replaced with 'rocmPackages.rocdbgapi'"; # Added 2023-10-08
  rocgdb = throw "'rocgdb' has been replaced with 'rocmPackages.rocgdb'"; # Added 2023-10-08
  rocprofiler = throw "'rocprofiler' has been replaced with 'rocmPackages.rocprofiler'"; # Added 2023-10-08
  rocsolver = throw "'rocsolver' has been replaced with 'rocmPackages.rocsolver'"; # Added 2023-10-08
  rocmClangStdenv = throw "'rocmClangStdenv' has been moved to 'rocmPackages' and is no longer public"; # Added 2023-10-08
  rocmUpdateScript = throw "'rocmUpdateScript' has been moved to 'rocmPackages' and is no longer public"; # Added 2023-10-08
  rocminfo = throw "'rocminfo' has been replaced with 'rocmPackages.rocminfo'"; # Added 2023-10-08
  rocmlir = throw "'rocmlir' has been replaced with 'rocmPackages.rocmlir'"; # Added 2023-10-08
  rocmlir-rock = throw "'rocmlir-rock' has been replaced with 'rocmPackages.rocmlir-rock'"; # Added 2023-10-08
  rocm-cmake = throw "'rocm-cmake' has been replaced with 'rocmPackages.rocm-cmake'"; # Added 2023-10-08
  rocm-comgr = throw "'rocm-comgr' has been replaced with 'rocmPackages.rocm-comgr'"; # Added 2023-10-08
  rocm-core = throw "'rocm-core' has been replaced with 'rocmPackages.rocm-core'"; # Added 2023-10-08
  rocm-device-libs = throw "'rccl' has been replaced with 'rocmPackages.rocm-device-libs'"; # Added 2023-10-08
  rocm-opencl-icd = rocmPackages.clr.icd; # Added 2023-10-08 Convert to throw after 23.11 is released
  rocm-opencl-runtime = rocmPackages.clr; # Added 2023-10-08 Convert to throw after 23.11 is released
  rocm-runtime = throw "'rocm-runtime' has been replaced with 'rocmPackages.rocm-runtime'"; # Added 2023-10-08
  rocm-smi = throw "'rocm-smi' has been replaced with 'rocmPackages.rocm-smi'"; # Added 2023-10-08
  rocm-thunk = throw "'rocm-thunk' has been replaced with 'rocmPackages.rocm-thunk'"; # Added 2023-10-08
  rocr-debug-agent = throw "'rocr-debug-agent' has been replaced with 'rocmPackages.rocr-debug-agent'"; # Added 2023-10-08
  rome = throw "rome is no longer maintained, consider using biome instead"; # Added 2023-09-12
  rpiboot-unstable = rpiboot; # Added 2021-07-30
  rr-unstable = rr; # Added 2022-09-17
  rtl8723bs-firmware = throw "rtl8723bs-firmware was added in mainline kernel version 4.12"; # Added 2023-07-03
  rtsp-simple-server = throw "rtsp-simple-server is rebranded as mediamtx, including default config path update"; # Added 2023-04-11
  rtx = mise; # Added 2024-01-05
  runCommandNoCC = runCommand;
  runCommandNoCCLocal = runCommandLocal;
  rustc-wasm32 = rustc; # Added 2023-12-01
  rxvt_unicode = rxvt-unicode-unwrapped; # Added 2020-02-02
  rxvt_unicode-with-plugins = rxvt-unicode; # Added 2020-02-02

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtlwifi_new-firmware = rtw88-firmware; # Added 2021-03-14
  rtw89-firmware = throw "rtw89-firmware has been removed because linux-firmware now contains it."; # Added 2023-02-19

  ### S ###

  s2n = s2n-tls; # Added 2021-03-03
  sane-backends-git = sane-backends; # Added 2021-02-19
  scantailor = scantailor-advanced; # Added 2022-05-26
  schildichat-web = throw ''
    schildichat has been removed as it is severely lacking behind the Element upstream and does not receive regular security fixes.
    Please participate in upstream discussion on getting out new releases:
    https://github.com/SchildiChat/schildichat-desktop/issues/212
    https://github.com/SchildiChat/schildichat-desktop/issues/215''; # Added 2023-12-05
  schildichat-desktop = schildichat-web;
  schildichat-desktop-wayland = schildichat-web;
  scitoken-cpp = scitokens-cpp; # Added 2024-02-12
  scylladb = throw "'scylladb' has been removed due to being unmaintained"; # Added 2024-03-17
  sdlmame = throw "'sdlmame' has been renamed to/replaced by 'mame'"; # Converted to throw 2023-09-10
  searx = throw "'searx' has been removed as it is unmaintained. Please switch to searxng"; # Added 2023-10-03
  semver-cpp = throw "'semver-cpp' was removed because no packages in nixpkgs use it anymore"; # Added 2024-02-14
  session-desktop-appimage = session-desktop;
  setupcfg2nix = throw "'setupcfg2nix' has been removed. Please switch to buildPythonPackage"; # Added 2023-12-12
  sequoia = sequoia-sq; # Added 2023-06-26
  sexp = sexpp; # Added 2023-07-03
  sget = throw "sget has been removed from nixpkgs, as it is not supported upstream anymore see https://github.com/sigstore/sget/issues/145"; # Added 2023-05-26
  sgtpuzzles = throw "'sgtpuzzles' has been renamed to 'sgt-puzzles'"; # Added 2023-10-06
  sgtpuzzles-mobile = throw "'sgtpuzzles-mobile' has been renamed to 'sgt-puzzles-mobile'"; # Added 2023-10-06
  inherit (libsForQt5.mauiPackages) shelf; # added 2022-05-17
  shhgit = throw "shhgit is broken and is no longer maintained. See https://github.com/eth0izzle/shhgit#-shhgit-is-no-longer-maintained-"; # Added 2023-08-08
  shipyard = jumppad; # Added 2023-06-06
  signumone-ks = throw "signumone-ks has been removed from nixpkgs because the developers stopped offering the binaries"; # Added 2023-08-17
  simplenote = throw "'simplenote' has been removed because it is no longer maintained and insecure"; # Added 2023-10-09
  slack-dark = slack; # Added 2020-03-27
  slmenu = throw "slmenu has been removed (upstream is gone)"; # Added 2023-04-06
  slurm-llnl = slurm; # renamed July 2017
  smesh = throw "'smesh' has been removed as it's unmaintained and depends on opencascade-oce, which is also unmaintained"; # Added 2023-09-18
  soldat-unstable = opensoldat; # Added 2022-07-02
  solr_8 = throw "'solr' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2023-03-16
  solr = throw "'solr' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2023-03-16
  soundOfSorting = sound-of-sorting; # Added 2023-07-07
  soundux = throw "'soundux' has been removed, as it is unmaintained."; # Added on 2024-02-14
  spark2 = throw "'spark2' is no longer supported nixpkgs, please use 'spark'"; # Added 2023-05-08
  spark_2_4 = throw "'spark_2_4' is no longer supported nixpkgs, please use 'spark'"; # Added 2023-05-08
  spark_3_1 = throw "'spark_3_1' is no longer supported nixpkgs, please use 'spark'"; # Added 2023-05-08
  spark_3_3 = throw "'spark_3_3' is no longer supported nixpkgs, please use 'spark'"; # Added 2024-03-23
  spark2014 = gnatprove; # Added 2024-02-25

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


  spacegun = throw "'spacegun' has been removed as unmaintained"; # Added 2023-05-20
  spectral = neochat; # Added 2020-12-27
  speedtest-exporter = throw "'speedtest-exporter' has been removed as unmaintained"; # Added 2023-07-31
  spice-gtk_libsoup2 = throw "'spice-gtk_libsoup2' has been renamed to/replaced by 'spice-gtk'"; # Added 2023-02-21
  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spidermonkey = spidermonkey_78; # Added 2020-10-09
  spotify-tui = throw "'spotify-tui' has been removed, as it was broken and unmaintained"; # Added 2024-03-12
  spotify-unwrapped = spotify; # added 2022-11-06
  spring-boot = spring-boot-cli; # added 2020-04-24
  squid4 = throw "'squid4' has been renamed to/replaced by 'squid'"; # Converted to throw 2023-09-10
  ssb = throw "'ssb' has been removed, as it was broken and unmaintained"; # Added 2023-12-21
  ssm-agent = amazon-ssm-agent; # Added 2023-10-17
  starboard-octant-plugin = throw "starboard-octant-plugin has been dropped due to needing octant which is archived"; # Added 2023-09-29
  steam-run-native = steam-run; # added 2022-02-21
  StormLib = stormlib; # Added 2024-01-21
  sumneko-lua-language-server = lua-language-server; # Added 2023-02-07
  supertux-editor = throw "'supertux-editor' has been removed, as it was broken and unmaintained"; # Added 2023-12-22
  swift-im = throw "swift-im has been removed as it is unmaintained and depends on deprecated Python 2 / Qt WebKit"; # Added 2023-01-06
  swtpm-tpm2 = swtpm; # Added 2021-02-26
  syncthing-cli = syncthing; # Added 2021-04-06
  syncthingtray-qt6 = syncthingtray; # Added 2024-03-06

  ### T ###

  tangogps = foxtrotgps; # Added 2020-01-26
  taplo-cli = taplo; # Added 2022-07-30
  taplo-lsp = taplo; # Added 2022-07-30
  taro = taproot-assets; # Added 2023-07-04
  tdesktop = telegram-desktop; # Added 2023-04-07
  telegram-cli = throw "telegram-cli was removed because it was broken and abandoned upstream"; # Added 2023-07-28
  teleport_11 = throw "teleport 11 has been removed as it is EOL. Please upgrade to Teleport 12 or later"; # Added 2023-11-27
  teleport_12 = throw "teleport 12 has been removed as it is EOL. Please upgrade to Teleport 13 or later"; # Added 2024-02-04
  teleport_13 = throw "teleport 13 has been removed as it is EOL. Please upgrade to Teleport 14 or later"; # Added 2024-05-26
  teleprompter = throw "teleprompter has been removed. reason: upstream dead and does not work with recent electron versions"; # Added 2024-03-14
  tensile = throw "'tensile' has been replaced with 'rocmPackages.tensile'"; # Added 2023-10-08
  tepl = libgedit-tepl; # Added 2024-04-29
  testVersion = testers.testVersion; # Added 2022-04-20
  tfplugindocs = terraform-plugin-docs; # Added 2023-11-01
  thrift-0_10 = throw "'thrift-0_10' has been removed because it is impacted by security issues and not used in nixpkgs, move to 'thrift'"; # Added 2024-03-17
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  timescale-prometheus = promscale; # Added 2020-09-29
  tinygltf = throw "TinyglTF has been embedded in draco due to lack of other users and compatibility breaks."; # Added 2023-06-25
  tixati = throw "'tixati' has been removed from nixpkgs as it is unfree and unmaintained"; # Added 2023-03-17
  tkcvs = tkrev; # Added 2022-03-07
  tokodon = plasma5Packages.tokodon;
  tokyo-night-gtk = tokyonight-gtk-theme; # Added 2024-01-28
  tootle = throw "'tootle' has been removed as it is not maintained upstream. Consider using 'tuba' instead"; # Added 2024-02-11
  tor-browser-bundle-bin = tor-browser; # Added 2023-09-23
  transfig = fig2dev; # Added 2022-02-15
  transifex-client = transifex-cli; # Added 2023-12-29
  trezor_agent = trezor-agent; # Added 2024-01-07
  trustedGrub = throw "trustedGrub has been removed, because it is not maintained upstream anymore"; # Added 2023-05-10
  trustedGrub-for-HP = throw "trustedGrub-for-HP has been removed, because it is not maintained upstream anymore"; # Added 2023-05-10
  tvbrowser-bin = tvbrowser; # Added 2023-03-02
  typst-fmt = typstfmt; # Added 2023-07-15

  ### U ###

  uade123 = uade; # Added 2022-07-30
  uberwriter = apostrophe; # Added 2020-04-23
  ubootBeagleboneBlack = ubootAmx335xEVM; # Added 2020-01-21
  ue4 = throw "ue4 has been removed, because the package was broken for years"; # Added 2023-11-22
  uhd3_5 = throw "uhd3_5 has been removed, because it was no longer needed"; # Added 2023-10-07
  uhhyou.lv2 = throw "'uhhyou.lv2' has been removed, upstream gone"; # Added 2023-06-21
  unicorn-emu = unicorn; # Added 2020-10-29
  uniffi-bindgen = throw "uniffi-bindgen has been removed since upstream no longer provides a standalone package for the CLI";
  unifi-poller = unpoller; # Added 2022-11-24
  unifi5 = throw "'unifi5' has been removed since its required MongoDB version is EOL."; # Added 2024-04-11
  unifi6 = throw "'unifi6' has been removed since its required MongoDB version is EOL."; # Added 2024-04-11
  unifiLTS = throw "'unifiLTS' has been removed since UniFi no longer has LTS and stable releases. Use `pkgs.unifi` instead."; # Added 2024-04-11
  unifiStable = throw "'unifiStable' has been removed since UniFi no longer has LTS and stable releases. Use `pkgs.unifi` instead."; # Converted to throw 2024-04-11
  untrunc = untrunc-anthwlock; # Added 2021-02-01
  urlview = throw "'urlview' has been dropped because it's unmaintained. Consider switching to an alternative such as `pkgs.extract_url` or `pkgs.urlscan`."; # Added 2023-12-14
  urxvt_autocomplete_all_the_things = rxvt-unicode-plugins.autocomplete-all-the-things; # Added 2020-02-02
  urxvt_bidi = rxvt-unicode-plugins.bidi; # Added 2020-02-02
  urxvt_font_size = rxvt-unicode-plugins.font-size; # Added 2020-02-02
  urxvt_perl = rxvt-unicode-plugins.perl; # Added 2020-02-02
  urxvt_perls = rxvt-unicode-plugins.perls; # Added 2020-02-02
  urxvt_tabbedex = rxvt-unicode-plugins.tabbedex; # Added 2020-02-02
  urxvt_theme_switch = rxvt-unicode-plugins.theme-switch; # Added 2020-02-02
  urxvt_vtwheel = rxvt-unicode-plugins.vtwheel; # Added 2020-02-02
  usbguard-nox = throw "'usbguard-nox' has been renamed to/replaced by 'usbguard'"; # Converted to throw 2023-09-10
  utahfs = throw "utahfs has been removed, as it is broken and lack of maintenance from upstream"; # Added 2023-09-29
  util-linuxCurses = util-linux; # Added 2022-04-12
  utillinux = util-linux; # Added 2020-11-24

  ### V ###

  v4l_utils = throw "'v4l_utils' has been renamed to/replaced by 'v4l-utils'"; # Converted to throw 2023-09-10
  vamp = { vampSDK = vamp-plugin-sdk; }; # Added 2020-03-26
  vaapiIntel = intel-vaapi-driver; # Added 2023-05-31
  vaultwarden-vault = vaultwarden.webvault; # Added 2022-12-13
  vdirsyncerStable = vdirsyncer; # Added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  ventoy-bin = ventoy; # Added 2023-04-12
  ventoy-bin-full = ventoy-full; # Added 2023-04-12
  ViennaRNA = viennarna; # Added 2023-08-23
  vikunja-api = throw "'vikunja-api' has been replaced by 'vikunja'"; # Added 2024-02-19
  vikunja-frontend = throw "'vikunja-frontend' has been replaced by 'vikunja'"; # Added 2024-02-19
  vimHugeX = vim-full; # Added 2022-12-04
  vim_configurable = vim-full; # Added 2022-12-04
  virtmanager = throw "'virtmanager' has been renamed to/replaced by 'virt-manager'"; # Converted to throw 2023-09-10
  virtmanager-qt = throw "'virtmanager-qt' has been renamed to/replaced by 'virt-manager-qt'"; # Converted to throw 2023-09-10
  vivaldi-widevine = throw "'vivaldi-widevine' has been renamed to/replaced by 'widevine-cdm'"; # Added 2023-02-25
  vkBasalt = vkbasalt; # Added 2022-11-22
  vkdt-wayland = vkdt; # Added 2024-04-19
  vsmtp = throw "'vsmtp' has been removed, upstream gone"; # Added 2023-12-18
  vte_290 = throw "'vte_290' has been renamed to/replaced by 'vte'"; # Added 2023-01-05
  varnish72 = throw "varnish 7.2 is EOL. Either use the LTS or upgrade."; # Added 2023-10-09
  varnish73 = throw "varnish 7.3 is EOL. Either use the LTS or upgrade."; # Added 2023-10-09
  varnish72Packages = throw "varnish 7.2 is EOL. Either use the LTS or upgrade."; # Added 2023-10-09
  varnish73Packages = throw "varnish 7.3 is EOL. Either use the LTS or upgrade."; # Added 2023-10-09
  inherit (libsForQt5.mauiPackages) vvave; # added 2022-05-17
  volatility = throw "'volatility' has been removed, as it was broken and unmaintained"; # Added 2023-12-10

  ### W ###
  waybar-hyprland = throw "waybar-hyprland has been removed: hyprland support is now built into waybar by default."; # Added 2023-08-21
  wayfireApplications-unwrapped = throw ''
    'wayfireApplications-unwrapped.wayfire' has been renamed to/replaced by 'wayfire'
    'wayfireApplications-unwrapped.wayfirePlugins' has been renamed to/replaced by 'wayfirePlugins'
    'wayfireApplications-unwrapped.wcm' has been renamed to/replaced by 'wayfirePlugins.wcm'
    'wayfireApplications-unwrapped.wlroots' has been removed
  ''; # Add 2023-07-29
  waypoint = throw "waypoint has been removed from nixpkgs as the upstream project was archived"; # Added 2024-04-24
  wcm = throw "'wcm' has been renamed to/replaced by 'wayfirePlugins.wcm'"; # Add 2023-07-29
  webkitgtk_5_0 = throw "'webkitgtk_5_0' has been superseded by 'webkitgtk_6_0'"; # Added 2023-02-25
  wineWayland = wine-wayland;
  win-qemu = throw "'win-qemu' has been replaced by 'virtio-win'"; # Added 2023-08-16
  win-virtio = virtio-win; # Added 2023-10-17
  win-signed-gplpv-drivers = throw "win-signed-gplpv-drivers has been removed from nixpkgs, as it's unmaintained: https://help.univention.com/t/installing-signed-gplpv-drivers/21828"; # Added 2023-08-17
  wlroots_0_14 = throw "'wlroots_0_14' has been removed in favor of newer versions"; # Added 2023-07-29
  wlroots_0_15 = throw "'wlroots_0_15' has been removed in favor of newer versions"; # Added 2024-03-28
  wordpress6_1 = throw "'wordpress6_1' has been removed in favor of the latest version"; # Added 2023-10-10
  wordpress6_2 = throw "'wordpress6_2' has been removed in favor of the latest version"; # Added 2023-10-10
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name
  wrapLisp_old = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  wmii_hg = wmii;
  wrapGAppsHook = wrapGAppsHook3; # Added 2024-03-26
  wxGTK30 = throw "wxGTK30 has been removed from nixpkgs as it has reached end of life"; # Added 2023-03-22
  wxGTK30-gtk2 = wxGTK30; # Added 2022-12-03
  wxGTK30-gtk3 = wxGTK30; # Added 2022-12-03
  wxmac = wxGTK30; # Added 2023-03-22

  ### X ###

  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers; # Added 2021-11-19
  xcbuild6Hook = throw "'xcbuild6Hook has been renamed to/replaced by 'xcbuildHook'"; # Added 2023-12-10
  xcodebuild6 = throw "'xcodebuild6' has been renamed to/replaced by 'xcodebuild'"; # Added 2023-12-10
  xdg_utils = xdg-utils; # Added 2021-02-01
  xineLib = xine-lib; # Added 2021-04-27
  xineUI = xine-ui; # Added 2021-04-27
  xmlada = gnatPackages.xmlada; # Added 2024-02-25
  xonsh-unwrapped = throw "'xonsh-unwrapped' was incorporated into xonsh code; call xonsh directly instead."; # Added 2024-01-20
  xtrt = throw "xtrt has been removed due to being abandoned"; # Added 2023-05-25
  xulrunner = firefox-unwrapped; # Added 2023-11-03
  xvfb_run = xvfb-run; # Added 2021-05-07

  ### Y ###

  yacc = bison; # moved from top-level 2021-03-14
  yafaray-core = libyafaray; # Added 2022-09-23
  yarn2nix-moretea-openssl_1_1 = throw "'yarn2nix-moretea-openssl_1_1' has been removed."; # Added 2023-02-04
  yi = throw "'yi' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  ytmdesktop = throw "ytmdesktop was removed because upstream vanished"; # added 2024-03-24
  yubikey-manager4 = throw "yubikey-manager4 has been removed, since it is no longer required by yubikey-manager-qt. Please update to yubikey-manager."; # Added 2024-01-14
  yuzu-ea = throw "yuzu-ea has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzu-early-access = throw "yuzu-early-access has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzu = throw "yuzu has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzu-mainline = throw "yuzu-mainline has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04
  yuzuPackages = throw "yuzuPackages has been removed from nixpkgs, as it has been taken down upstream"; # Added 2024-03-04

  ### Z ###

  zabbix40 = throw "'zabbix40' has been removed as it has reached end of life"; # Added 2024-01-07
  zfsStable = zfs; # Added 2024-02-26
  zfsUnstable = zfs_unstable; # Added 2024-02-26
  zinc = zincsearch; # Added 2023-05-28
  zkg = throw "'zkg' has been replaced by 'zeek'";
  zq = zed.overrideAttrs (old: { meta = old.meta // { mainProgram = "zq"; }; }); # Added 2023-02-06
  zz = throw "'zz' has been removed because it was archived in 2022 and had no maintainer"; # added 2024-05-10

  ### UNSORTED ###

  zeroc_ice = throw "'zeroc_ice' has been renamed to/replaced by 'zeroc-ice'"; # Converted to throw 2023-09-10

  dina-font-pcf = dina-font; # Added 2020-02-09
  dnscrypt-proxy2 = dnscrypt-proxy; # Added 2023-02-02
  gnatsd = throw "'gnatsd' has been renamed to/replaced by 'nats-server'"; # Converted to throw 2023-09-10

  posix_man_pages = man-pages-posix; # Added 2021-04-15
  ttyrec = ovh-ttyrec; # Added 2021-01-02
  zplugin = zinit; # Added 2021-01-30
  zyn-fusion = zynaddsubfx; # Added 2022-08-05

  inherit (stdenv.hostPlatform) system; # Added 2021-10-22
  inherit (stdenv) buildPlatform hostPlatform targetPlatform; # Added 2023-01-09

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_latest = llvmPackages_18;
  llvmPackages_git = recurseIntoAttrs (callPackage ../development/compilers/llvm/git {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_git.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_git.libraries or llvmPackages_git.libraries;
    targetLlvm = targetPackages.llvmPackages_git.llvm or llvmPackages_git.llvm;
  });

  /* If these are in the scope of all-packages.nix, they cause collisions
    between mixed versions of qt. See:
  https://github.com/NixOS/nixpkgs/pull/101369 */

  inherit (plasma5Packages)
    akonadi akregator arianna ark bluedevil bomber bovo breeze-grub breeze-gtk
    breeze-icons breeze-plymouth breeze-qt5 colord-kde discover dolphin dragon elisa falkon
    ffmpegthumbs filelight granatier gwenview k3b kactivitymanagerd kaddressbook
    kalzium kapman kapptemplate kate katomic kblackbox kblocks kbounce
    kcachegrind kcalc kcharselect kcolorchooser kde-cli-tools kde-gtk-config
    kdenlive kdeplasma-addons kdevelop-pg-qt kdevelop-unwrapped kdev-php
    kdev-python kdevelop kdf kdialog kdiamond keditbookmarks kfind
    kgamma5 kget kgpg khelpcenter kig kigo killbots kinfocenter kitinerary
    kleopatra klettres klines kmag kmail kmenuedit kmines kmix kmplot
    knavalbattle knetwalk knights kollision kolourpaint kompare konsole kontact
    konversation korganizer kpkpass krdc kreversi krfb kscreen kscreenlocker
    kshisen ksquares ksshaskpass ksystemlog kteatime ktimer ktorrent ktouch
    kturtle kwallet-pam kwalletmanager kwave kwayland-integration kwin kwrited
    marble merkuro milou minuet okular oxygen oxygen-icons5 picmi
    plasma-browser-integration plasma-desktop plasma-integration plasma-nano
    plasma-nm plasma-pa plasma-mobile plasma-systemmonitor plasma-thunderbolt
    plasma-vault plasma-workspace plasma-workspace-wallpapers polkit-kde-agent
    powerdevil qqc2-breeze-style sddm-kcm skanlite skanpage spectacle
    systemsettings xdg-desktop-portal-kde yakuake zanshin
    ;

  kalendar = merkuro; # Renamed in 23.08
  kfloppy = throw "kfloppy has been removed upstream in KDE Gear 23.08";

  inherit (plasma5Packages.thirdParty)
    krohnkite
    krunner-ssh
    krunner-symbols
    kwin-dynamic-workspaces
    kwin-tiling
    plasma-applet-caffeine-plus
    plasma-applet-virtual-desktop-bar
    ;

  inherit (libsForQt5)
    sddm
    ;

  inherit (pidginPackages)
    pidgin-indicator
    pidgin-latex
    pidgin-msn-pecan
    pidgin-mra
    pidgin-skypeweb
    pidgin-carbons
    pidgin-xmpp-receipts
    pidgin-otr
    pidgin-osd
    pidgin-sipe
    pidgin-window-merge
    purple-discord
    purple-googlechat
    purple-hangouts
    purple-lurch
    purple-matrix
    purple-mm-sms
    purple-plugin-pack
    purple-signald
    purple-slack
    purple-vk-plugin
    purple-xmpp-http-upload
    tdlib-purple
    pidgin-opensteamworks
    purple-facebook
    ;

})
