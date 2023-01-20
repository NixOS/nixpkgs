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

# A script to convert old aliases to throws and remove old
# throws can be found in './maintainers/scripts/remove-old-aliases.py'.

# Add 'preserve, reason: reason why' after the date if the alias should not be removed.
# Try to keep them to a minimum.
# valid examples of what to preserve:
#   distro aliases such as:
#     debian-package-name -> nixos-package-name

mapAliases ({
  # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.
  forceSystem = system: _:
    (import self.path { localSystem = { inherit system; }; });

  _0x0 = throw "0x0 upstream is abandoned and no longer exists: https://gitlab.com/somasis/scripts/"; # Added 2021-12-03

  ### A ###

  accounts-qt = throw "'accounts-qt' has been renamed to/replaced by 'libsForQt5.accounts-qt'"; # Converted to throw 2022-02-22
  adobeReader = throw "'adobeReader' has been renamed to/replaced by 'adobe-reader'"; # Converted to throw 2022-02-22
  adobe_flex_sdk = throw "'adobe_flex_sdk' has been renamed to/replaced by 'apache-flex-sdk'"; # Converted to throw 2022-02-22
  adoptopenjdk-hotspot-bin-17 = throw "AdoptOpenJDK is now Temurin. Use temurin-bin-17"; # added 2022-07-02
  adoptopenjdk-jre-hotspot-bin-17 = throw "AdoptOpenJDK is now Temurin and JRE is no longer provided. Use temurin-bin-17"; # added 2022-07-02
  aesop = throw "aesop has been removed from nixpkgs, as it was unmaintained"; # Added 2021-08-05
  ag = throw "'ag' has been renamed to/replaced by 'silver-searcher'"; # Converted to throw 2022-02-22
  aircrackng = throw "'aircrackng' has been renamed to/replaced by 'aircrack-ng'"; # Converted to throw 2022-02-22
  airtame = throw "airtame has been removed due to being unmaintained"; # Added 2022-01-19
  alarm-clock-applet = throw "'alarm-clock-applet' has been abandoned upstream and depends on deprecated GNOME2/GTK2"; # Added 2022-06-16
  alsaLib = throw "'alsaLib' has been renamed to/replaced by 'alsa-lib'"; # Converted to throw 2022-09-24
  alsaOss = throw "'alsaOss' has been renamed to/replaced by 'alsa-oss'"; # Converted to throw 2022-09-24
  alsaPluginWrapper = throw "'alsaPluginWrapper' has been renamed to/replaced by 'alsa-plugins-wrapper'"; # Converted to throw 2022-09-24
  alsaPlugins = throw "'alsaPlugins' has been renamed to/replaced by 'alsa-plugins'"; # Converted to throw 2022-09-24
  alsaTools = throw "'alsaTools' has been renamed to/replaced by 'alsa-tools'"; # Converted to throw 2022-09-24
  alsaUtils = throw "'alsaUtils' has been renamed to/replaced by 'alsa-utils'"; # Converted to throw 2022-09-24
  aminal = throw "aminal was renamed to darktile"; # Added 2021-09-28
  ammonite-repl = throw "'ammonite-repl' has been renamed to/replaced by 'ammonite'"; # Converted to throw 2022-02-22
  amuleDaemon = throw "amuleDaemon was renamed to amule-daemon"; # Added 2022-02-11
  amuleGui = throw "amuleGui was renamed to amule-gui"; # Added 2022-02-11
  angelfish = libsForQt5.plasmaMobileGear.angelfish; # Added 2021-10-06
  ansible_2_11 = throw "Ansible 2.11 goes end of life in 2022/11 and can't be supported throughout the 22.05 release cycle"; # Added 2022-03-30
  ansible_2_10 = throw "Ansible 2.10 went end of life in 2022/05 and has subsequently been dropped"; # Added 2022-03-30
  ansible_2_9 = throw "Ansible 2.9 went end of life in 2022/05 and has subsequently been dropped"; # Added 2022-03-30
  antimicroX = antimicrox; # Added 2021-10-31
  apple-music-electron = throw "'apple-music-electron' is end of life and has been removed, you can use 'cider' instead"; # Added 2022-10-02
  ardour_5 = throw "ardour_5 has been removed. see https://github.com/NixOS/nixpkgs/issues/139549"; # Added 2021-09-28
  arduino_core = throw "'arduino_core' has been renamed to/replaced by 'arduino-core'"; # Converted to throw 2022-02-22
  asciidocFull = throw "'asciidocFull' has been renamed to/replaced by 'asciidoc-full'"; # Converted to throw 2022-02-22
  asn1c = throw "asn1c has been removed: deleted by upstream"; # Added 2022-01-07
  asterisk_13 = throw "asterisk_13: Asterisk 13 is end of life and has been removed"; # Added 2022-04-06
  asterisk_17 = throw "asterisk_17: Asterisk 17 is end of life and has been removed"; # Added 2022-04-06
  at_spi2_atk = throw "'at_spi2_atk' has been renamed to/replaced by 'at-spi2-atk'"; # Converted to throw 2022-02-22
  at_spi2_core = throw "'at_spi2_core' has been renamed to/replaced by 'at-spi2-core'"; # Converted to throw 2022-02-22
  audacity-gtk2 = throw "'audacity-gtk2' has been removed to/replaced by 'audacity'"; # Added 2022-10-09
  audacity-gtk3 = throw "'audacity-gtk3' has been removed to/replaced by 'audacity'"; # Added 2022-10-09
  automoc4 = throw "automoc4 has been removed from nixpkgs"; # Added 2022-05-30
  avldrums-lv2 = throw "'avldrums-lv2' has been renamed to/replaced by 'x42-avldrums'"; # Converted to throw 2022-09-24
  awesome-4-0 = awesome; # Added 2022-05-05
  aws = throw "aws has been removed: abandoned by upstream. For the AWS CLI maintained by Amazon, see 'awscli' or 'awscli2'"; # Added 2022-09-21
  awless = throw "awless has been dropped due to the lack of maintenance from upstream since 2018"; # Added 2022-05-30
  aws-okta = throw "aws-okta is on indefinite hiatus. See https://github.com/segmentio/aws-okta/issues/278"; # Added 2022-04-05;
  axoloti = throw "axoloti has been removed: abandoned by upstream"; # Added 2022-05-13
  azure-vhd-utils = throw "azure-vhd-utils has been dropped due to the lack of maintenance from upstream since 2018"; # Added 2022-06-03

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  bar-xft = throw "'bar-xft' has been renamed to/replaced by 'lemonbar-xft'"; # Converted to throw 2022-02-22
  bashCompletion = throw "'bashCompletion' has been renamed to/replaced by 'bash-completion'"; # Converted to throw 2022-02-22
  bashInteractive_5 = throw "'bashInteractive_5' has been renamed to/replaced by 'bashInteractive'"; # Converted to throw 2022-09-24
  bash_5 = throw "'bash_5' has been renamed to/replaced by 'bash'"; # Converted to throw 2022-09-24
  bashburn = throw "bashburn has been removed: deleted by upstream"; # Added 2022-01-07
  bazel_0 = throw "bazel 0 is past end of life as it is not an lts version"; # Added 2022-05-09
  bazel_0_27 = throw "bazel 0.27 is past end of life as it is not an lts version"; # Added 2022-05-09
  bazel_0_29 = throw "bazel 0.29 is past end of life as it is not an lts version"; # Added 2022-05-09
  bazel_1 = throw "bazel 1 is past end of life as it is not an lts version"; # Added 2022-05-09
  beetsExternalPlugins = throw "beetsExternalPlugins has been deprecated, use beetsPackages.$pluginname"; # Added 2022-05-07
  beret = throw "beret has been removed"; # Added 2021-11-16
  bin_replace_string = throw "bin_replace_string has been removed: deleted by upstream"; # Added 2022-01-07
  bird2 = bird; # Added 2022-02-21
  bird6 = throw "bird6 was dropped. Use bird instead, which has support for both ipv4/ipv6"; # Added 2022-02-21
  bitbucket-cli = throw "bitbucket-cli has been removed: abandoned by upstream"; # Added 2022-03-21
  blastem = throw "blastem has been removed from nixpkgs as it would still require python2"; # Added 2022-01-01
  bluezFull = throw "'bluezFull' has been renamed to/replaced by 'bluez'"; # Converted to throw 2022-09-24
  botan = throw "botan has been removed because it did not support a supported openssl version"; # added 2021-12-15
  bpftool = throw "'bpftool' has been renamed to/replaced by 'bpftools'"; # Converted to throw 2022-09-24
  bridge_utils = throw "'bridge_utils' has been renamed to/replaced by 'bridge-utils'"; # Converted to throw 2022-02-22
  bro = throw "'bro' has been renamed to/replaced by 'zeek'"; # Converted to throw 2022-09-24
  btops = throw "btops has been dropped due to the lack of maintenance from upstream since 2017"; # Added 2022-06-02
  btrfsProgs = throw "'btrfsProgs' has been renamed to/replaced by 'btrfs-progs'"; # Converted to throw 2022-02-22
  bud = throw "bud has been removed: abandoned by upstream"; # Added 2022-03-14
  inherit (libsForQt5.mauiPackages) buho; # added 2022-05-17
  buttersink = throw "buttersink has been removed: abandoned by upstream"; # Added 2022-04-05

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = throw "'bitwarden_rs' has been renamed to/replaced by 'vaultwarden'"; # Converted to throw 2022-09-24
  bitwarden_rs-mysql = throw "'bitwarden_rs-mysql' has been renamed to/replaced by 'vaultwarden-mysql'"; # Converted to throw 2022-09-24
  bitwarden_rs-postgresql = throw "'bitwarden_rs-postgresql' has been renamed to/replaced by 'vaultwarden-postgresql'"; # Converted to throw 2022-09-24
  bitwarden_rs-sqlite = throw "'bitwarden_rs-sqlite' has been renamed to/replaced by 'vaultwarden-sqlite'"; # Converted to throw 2022-09-24
  bitwarden_rs-vault = throw "'bitwarden_rs-vault' has been renamed to/replaced by 'vaultwarden-vault'"; # Converted to throw 2022-09-24


  blink = throw "blink has been removed from nixpkgs, it was unmaintained and required python2 at the time of removal"; # Added 2022-01-12
  bsod = throw "bsod has been removed: deleted by upstream"; # Added 2022-01-07
  buildPerlPackage = throw "'buildPerlPackage' has been renamed to/replaced by 'perlPackages.buildPerlPackage'"; # Converted to throw 2022-02-22
  buildkite-agent3 = throw "'buildkite-agent3' has been renamed to/replaced by 'buildkite-agent'"; # Converted to throw 2022-02-22
  bundler_HEAD = throw "'bundler_HEAD' has been renamed to/replaced by 'bundler'"; # Converted to throw 2022-02-22
  bunny = throw "bunny has been removed: deleted by upstream"; # Added 2022-01-07
  bypass403 = throw "bypass403 has been removed: deleted by upstream"; # Added 2022-01-07

  ### C ###

  c14 = throw "c14 is deprecated and archived by upstream"; # Added 2022-04-10
  caffe2 = throw "caffe2 has been removed: subsumed under the PyTorch project"; # Added 2022-04-25
  callPackage_i686 = pkgsi686Linux.callPackage;
  cantarell_fonts = throw "'cantarell_fonts' has been renamed to/replaced by 'cantarell-fonts'"; # Converted to throw 2022-02-22
  catfish = throw "'catfish' has been renamed to/replaced by 'xfce.catfish'"; # Converted to throw 2022-09-24
  cde-gtk-theme = throw "cde-gtk-theme has been removed from nixpkgs as it shipped with python2 scripts that didn't work anymore"; # Added 2022-01-12
  checkbashism = throw "'checkbashism' has been renamed to/replaced by 'checkbashisms'"; # Converted to throw 2022-02-22
  chunkwm = throw "chunkwm has been removed: abandoned by upstream"; # Added 2022-01-07
  cifs_utils = throw "'cifs_utils' has been renamed to/replaced by 'cifs-utils'"; # Converted to throw 2022-02-22
  cipherscan = throw "cipherscan was removed from nixpkgs, as it was unmaintained"; # added 2021-12-11
  citra = citra-nightly; # added 2022-05-17
  ckb = throw "'ckb' has been renamed to/replaced by 'ckb-next'"; # Converted to throw 2022-02-22
  clickshare-csc1 = throw "'clickshare-csc1' has been removed as it requires qt4 which is being removed"; # Added 2022-06-16
  inherit (libsForQt5.mauiPackages) clip; # added 2022-05-17
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  creddump = throw "creddump has been removed from nixpkgs as the upstream has abandoned the project"; # Added 2022-01-01

  # these are for convenience, not for backward compat and shouldn't expire
  clang5Stdenv = lowPrio llvmPackages_5.stdenv;
  clang6Stdenv = lowPrio llvmPackages_6.stdenv;
  clang7Stdenv = lowPrio llvmPackages_7.stdenv;
  clang8Stdenv = lowPrio llvmPackages_8.stdenv;
  clang9Stdenv = lowPrio llvmPackages_9.stdenv;
  clang10Stdenv = lowPrio llvmPackages_10.stdenv;
  clang11Stdenv = lowPrio llvmPackages_11.stdenv;
  clang12Stdenv = lowPrio llvmPackages_12.stdenv;
  clang13Stdenv = lowPrio llvmPackages_13.stdenv;

  clangAnalyzer = throw "'clangAnalyzer' has been renamed to/replaced by 'clang-analyzer'"; # Converted to throw 2022-02-22
  claws-mail-gtk2 = throw "claws-mail-gtk2 was removed to get rid of Python 2, please use claws-mail"; # Added 2021-12-05
  claws-mail-gtk3 = throw "'claws-mail-gtk3' has been renamed to/replaced by 'claws-mail'"; # Converted to throw 2022-09-24
  clawsMail = throw "'clawsMail' has been renamed to/replaced by 'claws-mail'"; # Converted to throw 2022-02-22
  cldr-emoji-annotation = throw "'cldr-emoji-annotation' has been removed, as it was unmaintained; use 'cldr-annotations' instead"; # Added 2022-04-03
  clearsilver = throw "clearsilver has been removed: abandoned by upstream"; # Added 2022-03-15
  clementineUnfree = throw "clementineUnfree has been removed because Spotify stopped supporting libspotify"; # added 2022-05-29
  clutter_gtk = throw "'clutter_gtk' has been renamed to/replaced by 'clutter-gtk'"; # Converted to throw 2022-02-22
  codimd = throw "'codimd' has been renamed to/replaced by 'hedgedoc'"; # Converted to throw 2022-09-24
  inherit (libsForQt5.mauiPackages) communicator; # added 2022-05-17
  compton = throw "'compton' has been renamed to/replaced by 'picom'"; # Converted to throw 2022-09-24
  compton-git = throw "'compton-git' has been renamed to/replaced by 'compton'"; # Converted to throw 2022-02-22
  concurrencykit = throw "'concurrencykit' has been renamed to/replaced by 'libck'"; # Converted to throw 2022-09-24
  conntrack_tools = throw "'conntrack_tools' has been renamed to/replaced by 'conntrack-tools'"; # Converted to throw 2022-02-22
  container-linux-config-transpiler = throw "container-linux-config-transpiler is deprecated and archived by upstream"; # Added 2022-04-05
  cool-old-term = throw "'cool-old-term' has been renamed to/replaced by 'cool-retro-term'"; # Converted to throw 2022-02-22
  corsmisc = throw "corsmisc has been removed (upstream is gone)"; # Added 2022-01-24
  coreclr = throw "coreclr has been removed from nixpkgs, use dotnet-sdk instead"; # added 2022-06-12
  corgi = throw "corgi has been dropped due to the lack of maintanence from upstream since 2018"; # Added 2022-06-02
  cpp-gsl = throw "'cpp-gsl' has been renamed to/replaced by 'microsoft_gsl'"; # Converted to throw 2022-02-22
  cpuminer-multi = throw "cpuminer-multi has been removed: deleted by upstream"; # Added 2022-01-07
  crafty = throw "crafty has been removed: deleted by upstream"; # Added 2022-01-07
  cryptpad = throw "cryptpad has been removed, because it was unmaintained in nixpkgs"; # Added 2022-07-04
  ctl = throw "ctl has been removed: abandoned by upstream"; # Added 2022-05-13

  # CUDA Toolkit
  cudatoolkit_10 = throw "cudatoolkit_10 has been renamed to cudaPackages_10.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_10_0 = throw "cudatoolkit_10_0 has been renamed to cudaPackages_10_0.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_10_1 = throw "cudatoolkit_10_1 has been renamed to cudaPackages_10_1.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_10_2 = throw "cudatoolkit_10_2 has been renamed to cudaPackages_10_2.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_0 = throw "cudatoolkit_11_0 has been renamed to cudaPackages_11_0.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_1 = throw "cudatoolkit_11_1 has been renamed to cudaPackages_11_1.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_2 = throw "cudatoolkit_11_2 has been renamed to cudaPackages_11_2.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_3 = throw "cudatoolkit_11_3 has been renamed to cudaPackages_11_3.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_4 = throw "cudatoolkit_11_4 has been renamed to cudaPackages_11_4.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_5 = throw "cudatoolkit_11_5 has been renamed to cudaPackages_11_5.cudatoolkit"; # Added 2022-04-04
  cudatoolkit_11_6 = throw "cudatoolkit_11_6 has been renamed to cudaPackages_11_6.cudatoolkit"; # Added 2022-04-04

  cudnn = throw "cudnn is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_7_4_cudatoolkit_10_0 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_7_6_cudatoolkit_10_0 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_7_6_cudatoolkit_10_1 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_1_cudatoolkit_10_2 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_1_cudatoolkit_11_0 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_1_cudatoolkit_11_1 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_1_cudatoolkit_11_2 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_1_cudatoolkit_10 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_10_2 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11_0 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11_1 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11_2 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11_3 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11_4 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11_5 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_10 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cudnn_8_3_cudatoolkit_11 = throw "cudnn* is now part of cudaPackages*"; # Added 2022-04-04
  cura_stable = throw "cura_stable was removed because it was broken and used Python 2"; # added 2022-06-05
  curl_unix_socket = throw "curl_unix_socket has been dropped due to the lack of maintanence from upstream since 2015"; # Added 2022-06-02
  cutensor = throw "cutensor is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_10 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_10_1 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_10_2 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_11 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_11_0 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_11_1 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_11_2 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_11_3 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04
  cutensor_cudatoolkit_11_4 = throw "cutensor* is now part of cudaPackages*"; # Added 2022-04-04

  cloud-print-connector = throw "Google Cloudprint is officially discontinued since Jan 2021, more info https://support.google.com/chrome/a/answer/9633006"; # Added 2021-11-03
  cups-googlecloudprint = throw "Google Cloudprint is officially discontinued since Jan 2021, more info https://support.google.com/chrome/a/answer/9633006"; # Added 2021-11-03
  cupsBjnp = throw "'cupsBjnp' has been renamed to/replaced by 'cups-bjnp'"; # Converted to throw 2022-02-22
  cups_filters = throw "'cups_filters' has been renamed to/replaced by 'cups-filters'"; # Converted to throw 2022-02-22
  curlcpp = throw "curlcpp has been removed, no active maintainers and no usage within nixpkgs"; # Added 2022-05-10
  curaByDagoma = throw "curaByDagoma has been removed from nixpkgs, because it was unmaintained and dependent on python2 packages"; # Added 2022-01-12
  curaLulzbot = throw "curaLulzbot has been removed due to insufficient upstream support for a modern dependency chain"; # Added 2021-10-23
  cv = throw "'cv' has been renamed to/replaced by 'progress'"; # Converted to throw 2022-02-22
  cvs_fast_export = throw "'cvs_fast_export' has been renamed to/replaced by 'cvs-fast-export'"; # Converted to throw 2022-09-24

  ### D ###

  d1x_rebirth = throw "'d1x_rebirth' has been renamed to/replaced by 'dxx-rebirth'"; # Converted to throw 2022-02-22
  d2x_rebirth = throw "'d2x_rebirth' has been renamed to/replaced by 'dxx-rebirth'"; # Converted to throw 2022-02-22
  dart_stable = throw "'dart_stable' has been renamed to/replaced by 'dart'"; # Converted to throw 2022-09-24
  dat = nodePackages.dat;
  dashpay = throw "'dashpay' has been removed because it was unmaintained"; # Added 2022-05-12
  dbus_daemon = throw "'dbus_daemon' has been renamed to/replaced by 'dbus.daemon'"; # Converted to throw 2022-02-22
  dbus_glib = throw "'dbus_glib' has been renamed to/replaced by 'dbus-glib'"; # Converted to throw 2022-02-22
  dbus_libs = throw "'dbus_libs' has been renamed to/replaced by 'dbus'"; # Converted to throw 2022-02-22
  dbus_tools = throw "'dbus_tools' has been renamed to/replaced by 'dbus.out'"; # Converted to throw 2022-02-22
  dd-agent = throw "dd-agent has been removed in favor of the newer datadog-agent"; # Added 2022-04-26
  ddar = throw "ddar has been removed: abandoned by upstream"; # Added 2022-03-18
  deadbeef-mpris2-plugin = throw "'deadbeef-mpris2-plugin' has been renamed to/replaced by 'deadbeefPlugins.mpris2'"; # Converted to throw 2022-02-22
  deadpixi-sam = deadpixi-sam-unstable;

  debian_devscripts = throw "'debian_devscripts' has been renamed to/replaced by 'debian-devscripts'"; # Converted to throw 2022-02-22
  debugedit-unstable = debugedit; # Added 2021-11-22
  deisctl = throw "deisctl was removed ; the service does not exist anymore"; # added 2022-02-06
  deis = throw "deis was removed ; the service does not exist anymore"; # added 2022-02-06
  deltachat-electron = throw "'deltachat-electron' has been renamed to/replaced by 'deltachat-desktop'"; # Converted to throw 2022-09-24
  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  desktop_file_utils = throw "'desktop_file_utils' has been renamed to/replaced by 'desktop-file-utils'"; # Converted to throw 2022-02-22
  devicemapper = throw "'devicemapper' has been renamed to/replaced by 'lvm2'"; # Converted to throw 2022-02-22
  dfu-util-axoloti = throw "dfu-util-axoloti has been removed: abandoned by upstream"; # Added 2022-05-13
  dhall-text = throw "'dhall-text' has been deprecated in favor of the 'dhall text' command from 'dhall'"; # Added 2022-03-26
  digikam5 = throw "'digikam5' has been renamed to/replaced by 'digikam'"; # Converted to throw 2022-02-22
  dirmngr = throw "dirmngr has been removed: merged into gnupg"; # Added 2022-05-13
  disper = throw "disper has been removed: abandoned by upstream"; # Added 2022-03-18
  displaycal = throw "displaycal has been removed from nixpkgs, as it hasn't migrated to python3"; # Added 2022-01-12
  dmtx = throw "'dmtx' has been renamed to/replaced by 'dmtx-utils'"; # Converted to throw 2022-02-22
  dnnl = throw "'dnnl' has been renamed to/replaced by 'oneDNN'"; # Converted to throw 2022-09-24
  docbook5_xsl = throw "'docbook5_xsl' has been renamed to/replaced by 'docbook_xsl_ns'"; # Converted to throw 2022-02-22
  docbook_xml_xslt = throw "'docbook_xml_xslt' has been renamed to/replaced by 'docbook_xsl'"; # Converted to throw 2022-02-22
  doh-proxy = throw "doh-proxy has been removed because upstream abandoned it and its depedencies where removed."; # Added 2022-03-30
  docker_compose = throw "'docker_compose' has been renamed to/replaced by 'docker-compose'"; # Converted to throw 2022-02-22
  docker-compose_2 = throw "'docker-compose_2' has been renamed to 'docker-compose'"; # Added 2022-06-05
  docker-edge = throw "'docker-edge' has been removed, it was an alias for 'docker'"; # Added 2022-06-05
  dolphinEmu = dolphin-emu; # Added 2021-11-10
  dolphinEmuMaster = dolphin-emu-beta; # Added 2021-11-10
  dotnet-netcore = dotnet-runtime; # Added 2021-10-07
  double_conversion = throw "'double_conversion' has been renamed to/replaced by 'double-conversion'"; # Converted to throw 2022-02-22
  dragon-drop = throw "'dragon-drop' has been removed in favor of 'xdragon'"; # Added 2022-04-10;
  dust = throw "dust has been removed: abandoned by upstream"; # Added 2022-04-21
  dwarf_fortress = throw "'dwarf_fortress' has been renamed to/replaced by 'dwarf-fortress'"; # Converted to throw 2022-02-22
  dylibbundler = throw "'dylibbundler' has been renamed to/replaced by 'macdylibbundler'"; # Converted to throw 2022-09-24

  ### E ###

  eagle7 = throw "eagle7 has been removed because it did not support a supported openssl version"; # added 2021-12-15
  ec2_ami_tools = ec2-ami-tools; # Added 2021-10-08
  ec2_api_tools = ec2-api-tools; # Added 2021-10-08
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01

  # Electron
  electron_3 = throw "electron_3 has been removed in favor of newer versions"; # added 2022-01-06
  electron_4 = throw "electron_4 has been removed in favor of newer versions"; # added 2022-01-06
  electron_5 = throw "electron_5 has been removed in favor of newer versions"; # added 2022-01-06
  electron_6 = throw "electron_6 has been removed in favor of newer versions"; # added 2022-01-06
  electron_7 = throw "electron_7 has been removed in favor of newer versions"; # added 2022-02-08
  electron_8 = throw "electron_8 has been removed in favor of newer versions"; # added 2022-02-08

  electrum-dash = throw "electrum-dash has been removed from nixpkgs as the project is abandoned"; # Added 2022-01-01

  # Emacs
  emacs28NativeComp = emacs28; # Added 2022-06-08
  emacs28Packages = emacs28.pkgs; # Added 2021-10-04
  emacs28WithPackages = emacs28.pkgs.withPackages; # Added 2021-10-04
  emacsNativeComp = emacs28NativeComp; # Added 2022-06-08
  emacsPackagesGen = throw "'emacsPackagesGen' has been renamed to/replaced by 'emacsPackagesFor'"; # Converted to throw 2022-02-22
  emacsPackagesNg = throw "'emacsPackagesNg' has been renamed to/replaced by 'emacs.pkgs'"; # Converted to throw 2022-09-24
  emacsPackagesNgFor = throw "'emacsPackagesNgFor' has been renamed to/replaced by 'emacsPackagesFor'"; # Converted to throw 2022-09-24
  emacsPackagesNgGen = throw "'emacsPackagesNgGen' has been renamed to/replaced by 'emacsPackagesFor'"; # Converted to throw 2022-02-22
  emacsWithPackages = throw "'emacsWithPackages' has been renamed to/replaced by 'emacs.pkgs.withPackages'"; # Converted to throw 2022-09-24

  enblendenfuse = throw "'enblendenfuse' has been renamed to/replaced by 'enblend-enfuse'"; # Converted to throw 2022-02-22
  encryptr = throw "encryptr was removed because it reached end of life"; # Added 2022-02-06
  envdir = throw "envdir has been dropped due to the lack of maintenance from upstream since 2018"; # Added 2022-06-03
  envelope = throw "envelope has been removed from nixpkgs, as it was unmaintained"; # Added 2021-08-05
  enyo-doom = enyo-launcher; # Added 2022-09-09
  epoxy = libepoxy; # Added 2021-11-11
  epsxe = throw "epsxe has been removed from nixpkgs, as it was unmaintained."; # added 2021-12-15
  etcdctl = throw "'etcdctl' has been renamed to/replaced by 'etcd'"; # Converted to throw 2022-02-22
  eteroj.lv2 = throw "'eteroj.lv2' has been renamed to/replaced by 'open-music-kontrollers.eteroj'"; # Added 2022-03-09
  euca2tools = throw "euca2ools has been removed because it is unmaintained upstream and still uses python2"; # Added 2022-01-01
  evilvte = throw "evilvte has been removed from nixpkgs for being unmaintained with security issues and dependant on an old version of vte which was removed"; # Added 2022-01-14
  evolution_data_server = throw "'evolution_data_server' has been renamed to/replaced by 'evolution-data-server'"; # Converted to throw 2022-02-22
  exfat-utils = throw "'exfat-utils' has been renamed to/replaced by 'exfat'"; # Converted to throw 2022-02-22

  ### F ###

  fastnlo = throw "'fastnlo' has been renamed to/replaced by 'fastnlo_toolkit'"; # Converted to throw 2022-09-24
  fbreader = throw "fbreader has been removed, as the upstream project has been archived"; # Added 2022-05-26
  feedreader = throw "feedreader is no longer activily maintained since 2019. The developer is working on a spiritual successor called NewsFlash."; # Added 2022-05-03
  inherit (luaPackages) fennel; # Added 2022-09-24
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve
  ffadoFull = throw "'ffadoFull' has been renamed to/replaced by 'ffado'"; # Converted to throw 2022-02-22
  ffmpeg-sixel = throw "ffmpeg-sixel has been removed, because it was an outdated/unmaintained fork of ffmpeg"; # Added 2022-03-23";
  ffmpeg_3 = throw "ffmpeg_3 was removed from nixpkgs, because it was an outdated and insecure release"; # added 2022-01-17
  finger_bsd = bsd-finger; # Added 2022-03-14
  fingerd_bsd = bsd-fingerd; # Added 2022-03-14
  firefox-esr-wrapper = throw "'firefox-esr-wrapper' has been renamed to/replaced by 'firefox-esr'"; # Converted to throw 2022-02-22
  firefoxWrapper = throw "'firefoxWrapper' has been renamed to/replaced by 'firefox'"; # Converted to throw 2022-02-22
  firefox-wrapper = throw "'firefox-wrapper' has been renamed to/replaced by 'firefox'"; # Converted to throw 2022-02-22
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  flameGraph = throw "'flameGraph' has been renamed to/replaced by 'flamegraph'"; # Converted to throw 2022-02-22
  flashtool = throw "flashtool was removed from nixpkgs, because the download is down for copyright reasons and the site looks very fishy"; # Added 2021-06-31
  flatbuffers_1_12 = throw "FlatBuffers version 1.12 has been removed, because upstream no longer maintains it"; # Added 2022-05-12
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  fme = throw "fme was removed, because it is old and uses Glade, a discontinued library"; # Added 2022-01-26
  foldingathome = throw "'foldingathome' has been renamed to/replaced by 'fahclient'"; # Converted to throw 2022-09-24
  font-awesome-ttf = throw "'font-awesome-ttf' has been renamed to/replaced by 'font-awesome'"; # Converted to throw 2022-02-22
  foomatic_filters = throw "'foomatic_filters' has been renamed to/replaced by 'foomatic-filters'"; # Converted to throw 2022-02-22
  fscryptctl-experimental = throw "The package fscryptctl-experimental has been removed. Please switch to fscryptctl"; # Added 2021-11-07
  fslint = throw "fslint has been removed: end of life. Upstream recommends using czkawka (https://qarmin.github.io/czkawka/) instead"; # Added 2022-01-15
  fuse_exfat = throw "'fuse_exfat' has been renamed to/replaced by 'exfat'"; # Converted to throw 2022-02-22
  fuseki = throw "'fuseki' has been renamed to/replaced by 'apache-jena-fuseki'"; # Converted to throw 2022-02-22
  fuse2fs = if stdenv.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.

  ### G ###

  g4py = throw "'g4py' has been renamed to/replaced by 'python3Packages.geant4'"; # Converted to throw 2022-09-24
  gammy = throw "'gammy' is deprecated upstream and has been replaced by 'gummy'"; # Added 2022-09-03
  gawp = throw "gawp has been dropped due to the lack of maintanence from upstream since 2017"; # Added 2022-06-02
  gdb-multitarget = throw "'gdb-multitarget' has been renamed to/replaced by 'gdb'"; # Converted to throw 2022-02-22
  gdk_pixbuf = throw "'gdk_pixbuf' has been renamed to/replaced by 'gdk-pixbuf'"; # Converted to throw 2022-02-22
  getmail = throw "getmail has been removed from nixpkgs, migrate to getmail6"; # Added 2022-01-12
  gettextWithExpat = throw "'gettextWithExpat' has been renamed to/replaced by 'gettext'"; # Converted to throw 2022-02-22
  giblib = throw " giblib has been removed from nixpkgs because upstream is gone"; # Added 2022-01-23
  git-annex-remote-b2 = throw "git-annex-remote-b2 has been dropped due to the lack of maintanence from upstream since 2016"; # Added 2022-06-02
  git-bz = throw "giz-bz has been removed from nixpkgs as it is stuck on python2"; # Added 2022-01-01

  gitAndTools = self // {
    darcsToGit = throw "'gitAndTools.darcsToGit' has been renamed to 'darcs-to-git'"; # Converted to throw 2022-09-24
    gitAnnex = throw "'gitAndTools.gitAnnex' has been renamed to 'git-annex'"; # Converted to throw 2022-09-24
    gitBrunch = throw "'gitAndTools.gitBrunch' has been renamed to 'git-brunch'"; # Converted to throw 2022-09-24
    gitFastExport = throw "'gitAndTools.gitFastExport' has been renamed to 'git-fast-export'"; # Converted to throw 2022-09-24
    gitRemoteGcrypt = throw "'gitAndTools.gitRemoteGcrypt' has been renamed to 'git-remote-gcrypt'"; # Converted to throw 2022-09-24
    svn_all_fast_export = throw "'gitAndTools.svn_all_fast_export' has been renamed to 'svn-all-fast-export'"; # Converted to throw 2022-09-24
    topGit = throw "'gitAndTools.topGit' has been renamed to 'top-git'"; # Converted to throw 2022-09-24
  };

  gitin = throw "gitin has been remove because it was unmaintained and depended on an insecure version of libgit2"; # Added 2021-12-07
  gitinspector = throw "gitinspector has been removed because it doesn't work with python3"; # Added 2022-01-12
  gksu = throw "gksu has been removed"; # Added 2022-01-16
  glib_networking = throw "'glib_networking' has been renamed to/replaced by 'glib-networking'"; # Converted to throw 2022-02-22
  glimpse = throw "glimpse was removed, as the project was discontinued. You can use gimp instead."; # Added 2022-07-11
  gmailieer = throw "'gmailieer' has been renamed to/replaced by 'lieer'"; # Converted to throw 2022-09-24
  gmic_krita_qt = throw "'gmic_krita_qt' has been renamed to/replaced by 'gmic-qt-krita'"; # Converted to throw 2022-09-24
  gnash = throw "gnash has been removed; broken and abandoned upstream"; # added 2022-02-06
  gnome-breeze = throw "gnome-breeze has been removed, use libsForQt5.breeze-gtk instead"; # Added 2022-04-22
  gnome-firmware-updater = gnome-firmware; # added 2022-04-14
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome-mpv = throw "'gnome-mpv' has been renamed to/replaced by 'celluloid'"; # Converted to throw 2022-09-24
  gnome-sharp = throw "gnome-sharp has been removed from nixpkgs"; # Added 2022-01-15
  gnome-themes-standard = throw "'gnome-themes-standard' has been renamed to/replaced by 'gnome-themes-extra'"; # Converted to throw 2022-02-22
  gnome_user_docs = throw "'gnome_user_docs' has been renamed to/replaced by 'gnome-user-docs'"; # Converted to throw 2022-09-24
  gnome_doc_utils = throw "'gnome_doc_utils' has been renamed to/replaced by 'gnome-doc-utils'"; # Converted to throw 2022-02-22
  gnome_themes_standard = throw "'gnome_themes_standard' has been renamed to/replaced by 'gnome-themes-standard'"; # Converted to throw 2022-02-22
  gmock = throw "'gmock' has been renamed to/replaced by 'gtest'"; # Converted to throw 2022-09-24
  gnome3 = throw "'gnome3' has been renamed to/replaced by 'gnome'"; # Converted to throw 2022-09-24
  gnuradio3_7 = throw "gnuradio3_7 has been removed because it required Python 2"; # Added 2022-01-16
  gnuradio-ais = throw "'gnuradio-ais' has been renamed to/replaced by 'gnuradio3_7.pkgs.ais'"; # Converted to throw 2022-09-24
  gnuradio-gsm = throw "'gnuradio-gsm' has been renamed to/replaced by 'gnuradio3_7.pkgs.gsm'"; # Converted to throw 2022-09-24
  gnuradio-limesdr = throw "'gnuradio-limesdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.limesdr'"; # Converted to throw 2022-09-24
  gnuradio-nacl = throw "'gnuradio-nacl' has been renamed to/replaced by 'gnuradio3_7.pkgs.nacl'"; # Converted to throw 2022-09-24
  gnuradio-osmosdr = throw "'gnuradio-osmosdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.osmosdr'"; # Converted to throw 2022-09-24
  gnuradio-rds = throw "'gnuradio-rds' has been renamed to/replaced by 'gnuradio3_7.pkgs.rds'"; # Converted to throw 2022-09-24
  gnustep-make = throw "'gnustep-make' has been renamed to/replaced by 'gnustep.make'"; # Converted to throw 2022-02-22
  gobby5 = throw "'gobby5' has been renamed to/replaced by 'gobby'"; # Converted to throw 2022-09-24
  gobjectIntrospection = throw "'gobjectIntrospection' has been renamed to/replaced by 'gobject-introspection'"; # Converted to throw 2022-02-22
  gogoclient = throw "gogoclient has been removed, because it was unmaintained"; # Added 2021-12-15
  goklp = throw "goklp has been dropped due to the lack of maintanence from upstream since 2017"; # Added 2022-06-02
  golly-beta = throw "golly-beta has been removed: use golly instead"; # Added 2022-03-21
  goimports = throw "'goimports' has been renamed to/replaced by 'gotools'"; # Converted to throw 2022-02-22
  googleAuthenticator = throw "'googleAuthenticator' has been renamed to/replaced by 'google-authenticator'"; # Converted to throw 2022-02-22
  googleearth = throw "the non-pro version of Google Earth was removed because it was discontinued and downloading it isn't possible anymore"; # Added 2022-01-22
  google-gflags = throw "'google-gflags' has been renamed to/replaced by 'gflags'"; # Converted to throw 2022-09-24
  gosca = throw "gosca has been dropped due to the lack of maintanence from upstream since 2018"; # Added 2022-06-30
  google-play-music-desktop-player = throw "GPMDP shows a black screen, upstream homepage is dead, use 'ytmdesktop' instead"; # Added 2022-06-16
  go-langserver = throw "go-langserver has been replaced by gopls"; # Added 2022-06-30
  go-mk = throw "go-mk has been dropped due to the lack of maintanence from upstream since 2015"; # Added 2022-06-02
  go-pup = throw "'go-pup' has been renamed to/replaced by 'pup'"; # Converted to throw 2022-02-22
  go-repo-root = throw "go-repo-root has been dropped due to the lack of maintanence from upstream since 2014"; # Added 2022-06-02
  gpgstats = throw "gpgstats has been removed: upstream is gone"; # Added 2022-02-06
  gpshell = throw "gpshell has been removed, because it was unmaintained in nixpkgs"; # added 2021-12-17
  graalvm11 = graalvm11-ce; # Added 2021-10-15
  graalvm8-ce = throw "graalvm8-ce has been removed by upstream"; # Added 2021-10-19
  graalvm8 = throw "graalvm8-ce has been removed by upstream"; # Added 2021-10-19
  graalvm8-ee = throw "graalvm8-ee has been removed because it is unmaintained"; # Added 2022-04-15
  graalvm11-ee = throw "graalvm11-ee has been removed because it is unmaintained"; # Added 2022-04-15
  gradio = throw "gradio has been removed because it is unmaintained, use shortwave instead"; # Added 2022-06-03
  grafana-mimir = throw "'grafana-mimir' has been renamed to/replaced by 'mimir'"; # Added 2022-06-07
  gr-ais = throw "'gr-ais' has been renamed to/replaced by 'gnuradio3_7.pkgs.ais'"; # Converted to throw 2022-09-24
  grantlee5 = throw "'grantlee5' has been renamed to/replaced by 'libsForQt5.grantlee'"; # Converted to throw 2022-02-22
  gr-gsm = throw "'gr-gsm' has been renamed to/replaced by 'gnuradio3_7.pkgs.gsm'"; # Converted to throw 2022-09-24
  grib-api = throw "grib-api has been replaced by ecCodes => https://confluence.ecmwf.int/display/ECC/GRIB-API+migration"; # Added 2022-01-05
  gr-limesdr = throw "'gr-limesdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.limesdr'"; # Converted to throw 2022-09-24
  gr-nacl = throw "'gr-nacl' has been renamed to/replaced by 'gnuradio3_7.pkgs.nacl'"; # Converted to throw 2022-09-24
  gr-osmosdr = throw "'gr-osmosdr' has been renamed to/replaced by 'gnuradio3_7.pkgs.osmosdr'"; # Converted to throw 2022-09-24
  gr-rds = throw "'gr-rds' has been renamed to/replaced by 'gnuradio3_7.pkgs.rds'"; # Converted to throw 2022-09-24
  grv = throw "grv has been dropped due to the lack of maintanence from upstream since 2019"; # Added 2022-06-01
  gsettings_desktop_schemas = throw "'gsettings_desktop_schemas' has been renamed to/replaced by 'gsettings-desktop-schemas'"; # Converted to throw 2022-02-22
  gtk_doc = throw "'gtk_doc' has been renamed to/replaced by 'gtk-doc'"; # Converted to throw 2022-02-22
  gtklick = throw "gtklick has been removed from nixpkgs as the project is stuck on python2"; # Added 2022-01-01
  gtmess = throw "gtmess has been removed, because it was a MSN client."; # Added 2021-12-15
  guile-gnome = throw "guile-gnome has been removed"; # Added 2022-01-16
  guileCairo = throw "'guileCairo' has been renamed to/replaced by 'guile-cairo'"; # Converted to throw 2022-02-22
  guileGnome = throw "guile-gnome has been removed"; # Added 2022-01-16
  guileLint = throw "'guileLint' has been renamed to/replaced by 'guile-lint'"; # Converted to throw 2022-02-22
  guile_lib = throw "'guile_lib' has been renamed to/replaced by 'guile-lib'"; # Converted to throw 2022-02-22
  guile_ncurses = throw "'guile_ncurses' has been renamed to/replaced by 'guile-ncurses'"; # Converted to throw 2022-02-22
  gupnp_av = throw "'gupnp_av' has been renamed to/replaced by 'gupnp-av'"; # Converted to throw 2022-02-22
  gupnp_dlna = throw "'gupnp_dlna' has been renamed to/replaced by 'gupnp-dlna'"; # Converted to throw 2022-02-22
  gupnp_igd = throw "'gupnp_igd' has been renamed to/replaced by 'gupnp-igd'"; # Converted to throw 2022-02-22
  gupnptools = throw "'gupnptools' has been renamed to/replaced by 'gupnp-tools'"; # Converted to throw 2022-02-22
  gutenberg = throw "'gutenberg' has been renamed to/replaced by 'zola'"; # Converted to throw 2022-02-22
  gwtdragdrop = throw "gwtdragdrop was removed: abandoned by upstream"; # Added 2022-02-06
  gwtwidgets = throw "gwtwidgets was removed: unmaintained"; # Added 2022-02-06

  ### H ###

  hardlink = throw "hardlink was merged into util-linux since 2019-06-14."; # Added 2022-08-12
  inherit (harePackages) hare harec; # Added 2022-08-10
  hawkthorne = throw "hawkthorne has been removed because it depended on a broken version of love"; # Added 2022-01-15
  heapster = throw "Heapster is now retired. See https://github.com/kubernetes-retired/heapster/blob/master/docs/deprecation.md"; # Added 2022-04-05
  heimdalFull = throw "'heimdalFull' has been renamed to/replaced by 'heimdal'"; # Converted to throw 2022-02-22
  heme = throw "heme has been removed: upstream is gone"; # added 2022-02-06
  hepmc = throw "'hepmc' has been renamed to/replaced by 'hepmc2'"; # Converted to throw 2022-09-24
  hicolor_icon_theme = throw "'hicolor_icon_theme' has been renamed to/replaced by 'hicolor-icon-theme'"; # Converted to throw 2022-02-22
  holdingnuts = throw "holdingnuts was removed from nixpkgs, as the project is no longer developed"; # Added 2022-05-10
  holochain-go = throw "holochain-go was abandoned by upstream"; # Added 2022-01-01
  htmlTidy = throw "'htmlTidy' has been renamed to/replaced by 'html-tidy'"; # Converted to throw 2022-02-22
  ht-rust = throw "'ht-rust' has been renamed to/replaced by 'xh'"; # Converted to throw 2022-09-24
  hydra-unstable = hydra_unstable; # added 2022-05-10
  hyperspace-cli = throw "hyperspace-cli is out of date, and has been deprecated upstream in favour of using the individual repos instead"; # Added 2022-08-29

  ### I ###

  i3cat = throw "i3cat has been dropped due to the lack of maintanence from upstream since 2016"; # Added 2022-06-02
  iana_etc = throw "'iana_etc' has been renamed to/replaced by 'iana-etc'"; # Converted to throw 2022-02-22
  ical2org = throw "ical2org has been dropped due to the lack of maintanence from upstream since 2018"; # Added 2022-06-02
  icecat-bin = throw "icecat-bin has been removed, the binary builds are not maintained upstream"; # Added 2022-02-15
  icedtea8_web = throw "'icedtea8_web' has been renamed to/replaced by 'adoptopenjdk-icedtea-web'"; # Converted to throw 2022-09-24
  icedtea_web = throw "'icedtea_web' has been renamed to/replaced by 'adoptopenjdk-icedtea-web'"; # Converted to throw 2022-09-24
  icu59 = throw "icu59 has been removed, use a more recent version instead"; # Added 2022-05-14
  icu65 = throw "icu65 has been removed, use a more recent version instead"; # Added 2022-05-14
  idea = throw "'idea' has been renamed to/replaced by 'jetbrains'"; # Converted to throw 2022-02-22
  imapproxy = throw "imapproxy has been removed because it did not support a supported openssl version"; # added 2021-12-15
  imagemagick7Big = throw "'imagemagick7Big' has been renamed to/replaced by 'imagemagickBig'"; # Converted to throw 2022-09-24
  imagemagick7 = throw "'imagemagick7' has been renamed to/replaced by 'imagemagick'"; # Converted to throw 2022-09-24
  imagemagick7_light = throw "'imagemagick7_light' has been renamed to/replaced by 'imagemagick_light'"; # Converted to throw 2022-09-24
  impressive = throw "impressive has been removed due to lack of released python 2 support and maintainership in nixpkgs"; # Added 2022-01-27
  inboxer = throw "inboxer has been removed as it is no longer maintained and no longer works as Google shut down the inbox service this package wrapped";
  index-fm = libsForQt5.mauiPackages.index; # added 2022-05-17
  infiniband-diags = throw "'infiniband-diags' has been renamed to/replaced by 'rdma-core'"; # Converted to throw 2022-09-24
  ino = throw "ino has been removed from nixpkgs, the project is stuck on python2 and upstream has archived the project"; # Added 2022-01-12
  inotifyTools = throw "'inotifyTools' has been renamed to/replaced by 'inotify-tools'"; # Converted to throw 2022-09-24
  intecture-agent = throw "intecture-agent has been removed, because it was no longer maintained upstream"; # added 2021-12-15
  intecture-auth = throw "intecture-auth has been removed, because it was no longer maintained upstream"; # added 2021-12-15
  intecture-cli = throw "intecture-cli has been removed, because it was no longer maintained upstream"; # added 2021-12-15
  interfacer = throw "interfacer is deprecated and archived by upstream"; # Added 2022-04-05
  inter-ui = throw "'inter-ui' has been renamed to/replaced by 'inter'"; # Converted to throw 2022-09-24
  iops = throw "iops was removed: upstream is gone"; # Added 2022-02-06
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-migrator-all-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  iproute = throw "'iproute' has been renamed to/replaced by 'iproute2'"; # Converted to throw 2022-09-24
  iproute_mptcp = throw "'iproute_mptcp' has been moved to https://github.com/teto/mptcp-flake"; # Converted to throw 2022-10-04
  ipsecTools = throw "ipsecTools has benn removed, because it was no longer maintained upstream"; # Added 2021-12-15
  itch-setup = throw "itch-setup has benn removed, use itch instead"; # Added 2022-06-02

  ### J ###


  jack2Full = throw "'jack2Full' has been renamed to/replaced by 'jack2'"; # Converted to throw 2022-09-24
  jami-client-gnome = throw "jami-client-gnome has been removed: abandoned upstream"; # Added 2022-05-15
  jami-libclient = throw "jami-libclient has been removed: moved into jami-qt"; # Added 2022-07-29
  jbuilder = throw "'jbuilder' has been renamed to/replaced by 'dune_1'"; # Converted to throw 2022-02-22
  jd = throw "jd has been dropped due to the lack of maintenance from upstream since 2016"; # Added 2022-06-03
  joseki = throw "'joseki' has been renamed to/replaced by 'apache-jena-fuseki'"; # Converted to throw 2022-02-22
  journalbeat7 = throw "journalbeat has been removed upstream. Use filebeat with the journald input instead";

  # Julia
  julia_10-bin = throw "julia_10-bin has been deprecated in favor of the latest LTS version"; # Added 2021-12-02
  julia_17-bin = throw "julia_17-bin has been deprecated in favor of the latest stable version"; # Added 2022-09-04

  json_glib = throw "'json_glib' has been renamed to/replaced by 'json-glib'"; # Converted to throw 2022-02-22
  jvmci8 = throw "graalvm8 and its tools were deprecated in favor of graalvm8-ce"; # Added 2021-10-15

  ### K ###

  k3d = throw "k3d has been removed because it was broken and has seen no release since 2016"; # Added 2022-01-04
  kafkacat = kcat; # Added 2021-10-07
  kdeconnect = throw "'kdeconnect' has been renamed to/replaced by 'plasma5Packages.kdeconnect-kde'"; # Converted to throw 2022-09-24
  kdiff3-qt5 = throw "'kdiff3-qt5' has been renamed to/replaced by 'kdiff3'"; # Converted to throw 2022-02-22
  keepass-keefox = throw "'keepass-keefox' has been renamed to/replaced by 'keepass-keepassrpc'"; # Converted to throw 2022-02-22
  keepassx-community = throw "'keepassx-community' has been renamed to/replaced by 'keepassxc'"; # Converted to throw 2022-02-22
  keepassx-reboot = throw "'keepassx-reboot' has been renamed to/replaced by 'keepassx-community'"; # Converted to throw 2022-02-22
  keepassx2-http = throw "'keepassx2-http' has been renamed to/replaced by 'keepassx-reboot'"; # Converted to throw 2022-02-22
  keepnote = throw "keepnote has been removed from nixpkgs, as it is stuck on python2"; # Added 2022-01-01
  kerberos = throw "'kerberos' has been renamed to/replaced by 'libkrb5'"; # Converted to throw 2022-09-24
  kexectools = kexec-tools; # Added 2021-09-03
  kexpand = throw "kexpand awless has been dropped due to the lack of maintanence from upstream since 2017"; # Added 2022-06-01
  keybase-go = throw "'keybase-go' has been renamed to/replaced by 'keybase'"; # Converted to throw 2022-02-22
  keysmith = throw "'keysmith' has been renamed to/replaced by 'libsForQt5.plasmaMobileGear.keysmith'"; # Converted to throw 2022-09-24
  kgx = gnome-console; # Added 2022-02-19
  kicad-with-packages3d = throw "'kicad-with-packages3d' has been renamed to/replaced by 'kicad'"; # Converted to throw 2022-09-24
  knockknock = throw "knockknock has been removed from nixpkgs because the upstream project is abandoned"; # Added 2022-01-01
  kodestudio = throw "kodestudio has been removed from nixpkgs, as the nix package has been long unmaintained and out of date."; # Added 2022-06-07
  kodiGBM = throw "'kodiGBM' has been renamed to/replaced by 'kodi-gbm'"; # Converted to throw 2022-09-24
  kodiPlain = throw "'kodiPlain' has been renamed to/replaced by 'kodi'"; # Converted to throw 2022-09-24
  kodiPlainWayland = throw "'kodiPlainWayland' has been renamed to/replaced by 'kodi-wayland'"; # Converted to throw 2022-09-24
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  kramdown-rfc2629 = throw "'kramdown-rfc2629' has been renamed to/replaced by 'rubyPackages.kramdown-rfc2629'"; # Converted to throw 2022-09-24
  krename-qt5 = throw "'krename-qt5' has been renamed to/replaced by 'krename'"; # Converted to throw 2022-02-22
  krita-beta = krita; # moved from top-level 2021-12-23
  kube-aws = throw "kube-aws is deprecated and archived by upstream"; # Added 2022-04-05
  kubeless = throw "kubeless is deprecated and archived by upstream"; # Added 2022-04-05
  kubicorn = throw "kubicorn has been dropped due to the lack of maintenance from upstream since 2019"; # Added 2022-05-30
  kvm = throw "'kvm' has been renamed to/replaced by 'qemu_kvm'"; # Converted to throw 2022-02-22

  ### L ###

  lastfmsubmitd = throw "lastfmsubmitd was removed from nixpkgs as the project is abandoned"; # Added 2022-01-01
  latinmodern-math = throw "'latinmodern-math' has been renamed to/replaced by 'lmmath'"; # Converted to throw 2022-09-24
  letsencrypt = throw "'letsencrypt' has been renamed to/replaced by 'certbot'"; # Converted to throw 2022-02-22
  libGL_driver = throw "'libGL_driver' has been renamed to/replaced by 'mesa.drivers'"; # Converted to throw 2022-02-22
  libaudit = throw "'libaudit' has been renamed to/replaced by 'audit'"; # Converted to throw 2022-02-22
  libbencodetools = bencodetools; # Added 2022-07-30
  libbluedevil = throw "'libbluedevil' (Qt4) is unmaintained and unused since 'kde4.bluedevil's removal in 2017"; # Added 2022-06-14
  libcanberra_gtk2 = throw "'libcanberra_gtk2' has been renamed to/replaced by 'libcanberra-gtk2'"; # Converted to throw 2022-02-22
  libcanberra_gtk3 = throw "'libcanberra_gtk3' has been renamed to/replaced by 'libcanberra-gtk3'"; # Converted to throw 2022-02-22
  libcap_manpages = throw "'libcap_manpages' has been renamed to/replaced by 'libcap.doc'"; # Converted to throw 2022-02-22
  libcap_pam = throw "'libcap_pam has been renamed to/replaced by 'libcap.pam'"; # Converted to throw 2022-09-24
  libcap_progs = throw "'libcap_progs' has been renamed to/replaced by 'libcap.out'"; # Converted to throw 2022-02-22
  libdbusmenu-glib = throw "'libdbusmenu-glib' has been renamed to/replaced by 'libdbusmenu'"; # Converted to throw 2022-02-22
  libdbusmenu_qt = throw "'libdbusmenu_qt' (Qt4) is deprecated and unused, use 'libsForQt5.libdbusmenu'"; # Added 2022-06-14
  libdbusmenu_qt5 = throw "'libdbusmenu_qt5' has been renamed to/replaced by 'libsForQt5.libdbusmenu'"; # Converted to throw 2022-02-22
  libdigidoc = throw "'libdigidoc' is unused in nixpkgs, deprecated and archived by upstream, use 'libdigidocpp' instead"; # Added 2022-06-03
  liberation_ttf_v1_from_source = throw "'liberation_ttf_v1_from_source' has been renamed to/replaced by 'liberation_ttf_v1'"; # Converted to throw 2022-02-22
  liberation_ttf_v2_from_source = throw "'liberation_ttf_v2_from_source' has been renamed to/replaced by 'liberation_ttf_v2'"; # Converted to throw 2022-02-22
  liberationsansnarrow = throw "'liberationsansnarrow' has been renamed to/replaced by 'liberation-sans-narrow'"; # Converted to throw 2022-02-22
  libgksu = throw "libgksu has been removed"; # Added 2022-01-16
  libgme = game-music-emu; # Added 2022-07-20
  libgnome_keyring = throw "'libgnome_keyring' has been renamed to/replaced by 'libgnome-keyring'"; # Converted to throw 2022-02-22
  libgnome_keyring3 = throw "'libgnome_keyring3' has been renamed to/replaced by 'libgnome-keyring3'"; # Converted to throw 2022-02-22
  libgpgerror = libgpg-error; # Added 2021-09-04
  libgroove = throw "libgroove has been removed, because it depends on an outdated and insecure version of ffmpeg"; # Added 2022-01-21
  libgumbo = throw "'libgumbo' has been renamed to/replaced by 'gumbo'"; # Converted to throw 2022-02-22
  libintlOrEmpty = "'libintlOrEmpty' has been renamed to/replace by 'gettext'"; # Converted to throw 2022-09-24
  libixp_hg = libixp; # Added 2022-04-25
  libjpeg_drop = throw "'libjpeg_drop' has been renamed to/replaced by 'libjpeg_original'"; # Converted to throw 2022-09-24
  libjson_rpc_cpp = throw "'libjson_rpc_cpp' has been renamed to/replaced by 'libjson-rpc-cpp'"; # Converted to throw 2022-02-22
  libkml = throw "libkml has been removed from nixpkgs, as it's abandoned and no package needed it"; # Added 2021-11-09
  liblapackWithoutAtlas = throw "'liblapackWithoutAtlas' has been renamed to/replaced by 'lapack-reference'"; # Converted to throw 2022-02-22
  liblastfm = throw "'liblastfm' has been renamed to/replaced by 'libsForQt5.liblastfm'"; # Converted to throw 2022-09-24
  liblrdf = throw "'liblrdf' has been renamed to/replaced by 'lrdf'"; # Converted to throw 2022-02-22
  libmsgpack = throw "'libmsgpack' has been renamed to/replaced by 'msgpack'"; # Converted to throw 2022-02-22
  libnih = throw "'libnih' has been removed"; # Converted to throw 2022-05-17
  libosmpbf = throw "libosmpbf was removed because it is no longer required by osrm-backend";
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libqrencode = throw "'libqrencode' has been renamed to/replaced by 'qrencode'"; # Converted to throw 2022-02-22
  librdf = throw "'librdf' has been renamed to/replaced by 'lrdf'"; # Converted to throw 2022-09-24
  librecad2 = throw "'librecad2' has been renamed to/replaced by 'librecad'"; # Converted to throw 2022-02-22
  libressl_3_2 = throw "'libressl_3_2' has reached end-of-life "; # Added 2022-03-19
  librevisa = throw "librevisa has been removed because its website and source have disappeared upstream"; # Added 2022-09-23
  libseat = throw "'libseat' has been renamed to/replaced by 'seatd'"; # Converted to throw 2022-09-24
  libspotify = throw "libspotify has been removed because Spotify stopped supporting it"; # added 2022-05-29
  libsysfs = throw "'libsysfs' has been renamed to/replaced by 'sysfsutils'"; # Converted to throw 2022-02-22
  libtensorflow-bin = libtensorflow; # Added 2022-09-25
  libtidy = throw "'libtidy' has been renamed to/replaced by 'html-tidy'"; # Converted to throw 2022-02-22
  libtorrentRasterbar = throw "'libtorrentRasterbar' has been renamed to/replaced by 'libtorrent-rasterbar'"; # Converted to throw 2022-09-24
  libtorrentRasterbar-1_2_x = throw "'libtorrentRasterbar-1_2_x' has been renamed to/replaced by 'libtorrent-rasterbar-1_2_x'"; # Converted to throw 2022-09-24
  libtorrentRasterbar-2_0_x = throw "'libtorrentRasterbar-2_0_x' has been renamed to/replaced by 'libtorrent-rasterbar-2_0_x'"; # Converted to throw 2022-09-24
  libudev = throw "'libudev' has been renamed to/replaced by 'udev'"; # Converted to throw 2022-02-22
  libungif = throw "'libungif' has been renamed to/replaced by 'giflib'"; # Converted to throw 2022-09-24
  libusb = throw "'libusb' has been renamed to/replaced by 'libusb1'"; # Converted to throw 2022-09-24
  libusb1-axoloti = throw "libusb1-axoloti has been removed: axoloti has been removed"; # Added 2022-05-13
  libva-full = throw "'libva-full' has been renamed to/replaced by 'libva'"; # Converted to throw 2022-02-22
  libva1-full = throw "'libva1-full' has been renamed to/replaced by 'libva1'"; # Converted to throw 2022-02-22
  libwnck3 = throw "'libwnck3' has been renamed to/replaced by 'libwnck'"; # Converted to throw 2022-09-24
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  lighttable = throw "'lighttable' crashes (SIGSEGV) on startup, has not been updated in years and depends on deprecated GTK2"; # Added 2022-06-15
  lilyterm = throw "lilyterm has been removed from nixpkgs, because it was relying on a vte version that depended on python2"; # Added 2022-01-14
  lilyterm-git = throw "lilyterm-git has been removed from nixpkgs, because it was relying on a vte version that depended on python2"; # Added 2022-01-14
  links = throw "'links' has been renamed to/replaced by 'links2'"; # Converted to throw 2022-02-22
  linuxband = throw "linuxband has been removed from nixpkgs, as it's abandoned upstream"; # Added 2021-12-09

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
  linuxPackages_5_17 = linuxKernel.packages.linux_5_17;
  linuxPackages_5_18 = linuxKernel.packages.linux_5_18;
  linuxPackages_5_19 = linuxKernel.packages.linux_5_19;
  linuxPackages_5_4 = linuxKernel.packages.linux_5_4;
  linuxPackages_6_0 = linuxKernel.packages.linux_6_0;
  linuxPackages_hardkernel_4_14 = linuxKernel.packages.hardkernel_4_14;
  linuxPackages_rpi0 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi02w = linuxKernel.packages.linux_rpi3;
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
  linux_5_17 = linuxKernel.kernels.linux_5_17;
  linux_5_18 = linuxKernel.kernels.linux_5_18;
  linux_5_19 = linuxKernel.kernels.linux_5_19;
  linux_5_4 = linuxKernel.kernels.linux_5_4;
  linux_6_0 = linuxKernel.kernels.linux_6_0;
  linuxPackages_mptcp = throw "'linuxPackages_mptcp' has been moved to https://github.com/teto/mptcp-flake"; # Converted to throw 2022-10-04
  linux_mptcp = throw "'linux_mptcp' has been moved to https://github.com/teto/mptcp-flake"; # Converted to throw 2022-10-04
  linux_mptcp_95 = throw "'linux_mptcp_95' has been moved to https://github.com/teto/mptcp-flake"; # Converted to throw 2022-10-04
  linux_rpi0 = linuxKernel.kernels.linux_rpi1;
  linux_rpi02w = linuxKernel.kernels.linux_rpi3;
  linux_rpi1 = linuxKernel.kernels.linux_rpi1;
  linux_rpi2 = linuxKernel.kernels.linux_rpi2;
  linux_rpi3 = linuxKernel.kernels.linux_rpi3;
  linux_rpi4 = linuxKernel.kernels.linux_rpi4;

  linuxPackages_xen_dom0 = throw "'linuxPackages_xen_dom0' has been renamed to/replaced by 'linuxPackages'"; # Converted to throw 2022-09-24
  linuxPackages_latest_xen_dom0 = throw "'linuxPackages_latest_xen_dom0' has been renamed to/replaced by 'linuxPackages_latest'"; # Converted to throw 2022-09-24
  linuxPackages_xen_dom0_hardened = throw "'linuxPackages_xen_dom0_hardened' has been renamed to/replaced by 'linuxPackages_hardened'"; # Converted to throw 2022-09-24
  linuxPackages_latest_xen_dom0_hardened = throw "'linuxPackages_latest_xen_dom0_hardened' has been renamed to/replaced by 'linuxPackages_latest_hardened'"; # Converted to throw 2022-09-24

  lobster-two = throw "'lobster-two' has been renamed to/replaced by 'google-fonts'"; # Converted to throw 2022-09-24
  love_0_7 = throw "love_0_7 was removed because it is a very old version and no longer used by any package in nixpkgs"; # Added 2022-01-15
  love_0_8 = throw "love_0_8 was removed because it is a very old version and no longer used by any package in nixpkgs"; # Added 2022-01-15
  love_0_9 = throw "love_0_9 was removed because was broken for a long time and no longer used by any package in nixpkgs"; # Added 2022-01-15
  lttngTools = throw "'lttngTools' has been renamed to/replaced by 'lttng-tools'"; # Converted to throw 2022-02-22
  lttngUst = throw "'lttngUst' has been renamed to/replaced by 'lttng-ust'"; # Converted to throw 2022-02-22
  lua5_1_sockets = throw "'lua5_1_sockets' has been renamed to/replaced by 'lua51Packages.luasocket'"; # Converted to throw 2022-02-22
  lua5_expat = throw "'lua5_expat' has been renamed to/replaced by 'luaPackages.luaexpat'"; # Converted to throw 2022-02-22
  lua5_sec = throw "'lua5_sec' has been renamed to/replaced by 'luaPackages.luasec'"; # Converted to throw 2022-02-22
  lumo = throw "lumo has been removed: abandoned by upstream"; # Added 2022-04-25
  lumpy = throw "lumpy has been removed from nixpkgs, as it is stuck on python2"; # Added 2022-01-12
  lzma = throw "'lzma' has been renamed to/replaced by 'xz'"; # Converted to throw 2022-09-24

  ### M ###

  m3d-linux = throw "'m3d-linux' has been renamed to/replaced by 'm33-linux'"; # Converted to throw 2022-02-22
  mailpile = throw "mailpile was removed from nixpkgs, as it is stuck on python2"; # Added 2022-01-12
  man_db = throw "'man_db' has been renamed to/replaced by 'man-db'"; # Converted to throw 2022-02-22
  manul = throw "manul has been dropped due to the lack of maintenance from upstream since 2018"; # Added 2022-06-01
  manpages = throw "'manpages' has been renamed to/replaced by 'man-pages'"; # Converted to throw 2022-02-22
  mariadb-client = hiPrio mariadb.client; #added 2019.07.28
  marp = throw "marp has been removed from nixpkgs, as it's unmaintained and has security issues"; # Added 2022-06-04
  matrique = throw "'matrique' has been renamed to/replaced by 'spectral'"; # Converted to throw 2022-09-24
  maui-nota = libsForQt5.mauiPackages.nota; # added 2022-05-17
  mcomix3 = mcomix; # Added 2022-06-05
  mediatomb = throw "mediatomb is no longer maintained upstream, use gerbera instead"; # added 2022-01-04
  meme = throw "'meme' has been renamed to/replaced by 'meme-image-generator'"; # Converted to throw 2022-09-24
  memtest86 = throw "'memtest86' has been renamed to/replaced by 'memtest86plus'"; # Converted to throw 2022-02-22
  mercurial_4 = throw "mercurial_4 has been removed as it's unmaintained"; # Added 2021-10-18
  mess = throw "'mess' has been renamed to/replaced by 'mame'"; # Converted to throw 2022-09-24
  metal = throw "metal has been removed due to lack of maintainers"; # Added 2022-06-30
  mididings = throw "mididings has been removed from nixpkgs as it doesn't support recent python3 versions and its upstream stopped maintaining it"; # Added 2022-01-12
  midoriWrapper = throw "'midoriWrapper' has been renamed to/replaced by 'midori'"; # Converted to throw 2022-02-22
  mime-types = mailcap; # Added 2022-01-21
  mimms = throw "mimms has been removed from nixpkgs as the upstream project is stuck on python2"; # Added 2022-01-01
  minetestclient_4 = throw "minetestclient_4 has been removed from Nixpkgs; current version is available at minetest or minetestclient"; # added 2022-02-01
  minetestserver_4 = throw "minetestserver_4 has been removed from Nixpkgs; current version is available at minetestserver"; # added 2022-02-01
  minetime = throw "minetime has been removed from nixpkgs, because it was discontinued 2021-06-22"; # Added 2021-10-14
  mlt-qt5 = throw "'mlt-qt5' has been renamed to/replaced by 'libsForQt5.mlt'"; # Converted to throw 2022-02-22
  mobile_broadband_provider_info = throw "'mobile_broadband_provider_info' has been renamed to/replaced by 'mobile-broadband-provider-info'"; # Converted to throw 2022-02-22
  module_init_tools = throw "'module_init_tools' has been renamed to/replaced by 'kmod'"; # Converted to throw 2022-02-22
  monero = monero-cli; # Added 2021-11-28
  monodevelop = throw "monodevelop has been removed from nixpgks"; # Added 2022-01-15
  mopidy-spotify = throw "mopidy-spotify has been removed because Spotify stopped supporting libspotify"; # added 2022-05-29
  mopidy-spotify-tunigo = throw "mopidy-spotify-tunigo has been removed because Spotify stopped supporting libspotify"; # added 2022-05-29

  morituri = throw "'morituri' has been renamed to/replaced by 'whipper'"; # Converted to throw 2022-02-22
  moz-phab = mozphab; # Added 2022-08-09
  mozart-binary = throw "'mozart-binary' has been renamed to/replaced by 'mozart2-binary'"; # Converted to throw 2022-09-24
  mozart = throw "'mozart' has been renamed to/replaced by 'mozart2-binary'"; # Converted to throw 2022-09-24
  mpc_cli = mpc-cli; # moved from top-level 2022-01-24
  mpd_clientlib = throw "'mpd_clientlib' has been renamed to/replaced by 'libmpdclient'"; # Converted to throw 2022-09-24
  mpich2 = throw "'mpich2' has been renamed to/replaced by 'mpich'"; # Converted to throw 2022-02-22
  mqtt-bench = throw "mqtt-bench has been dropped due to the lack of maintenance from upstream since 2017"; # Added 2022-06-02
  msf = throw "'msf' has been renamed to/replaced by 'metasploit'"; # Converted to throw 2022-02-22
  multimc = throw "multimc was removed from nixpkgs; use polymc instead (see https://github.com/NixOS/nixpkgs/pull/154051 for more information)"; # Added 2022-01-08
  mumble_git = throw "'mumble_git' has been renamed to/replaced by 'pkgs.mumble'"; # Converted to throw 2022-09-24
  murmur_git = throw "'murmur_git' has been renamed to/replaced by 'pkgs.murmur'"; # Converted to throw 2022-09-24
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mysql-client = throw "'mysql-client' has been renamed to/replaced by 'mariadb.client'"; # Converted to throw 2022-09-24
  mysql = throw "'mysql' has been renamed to/replaced by 'mariadb'"; # Converted to throw 2022-09-24

  mesa_drivers = throw "'mesa_drivers' has been renamed to/replaced by 'mesa.drivers'"; # Converted to throw 2022-09-24
  mesa_noglu = throw "'mesa_noglu' has been renamed to/replaced by 'mesa'"; # Converted to throw 2022-02-22

  mpv-with-scripts = throw "'mpv-with-scripts' has been renamed to/replaced by 'self.wrapMpv'"; # Converted to throw 2022-09-24
  mssys = throw "'mssys' has been renamed to/replaced by 'ms-sys'"; # Converted to throw 2022-02-22
  multipath_tools = throw "'multipath_tools' has been renamed to/replaced by 'multipath-tools'"; # Converted to throw 2022-02-22
  mumsi = throw "mumsi has been removed from nixpkgs, as it's unmaintained and does not build anymore"; # Added 2021-11-18
  mupen64plus1_5 = throw "'mupen64plus1_5' has been renamed to/replaced by 'mupen64plus'"; # Converted to throw 2022-02-22
  mx = throw "graalvm8 and its tools were deprecated in favor of graalvm8-ce"; # Added 2021-10-15
  mysqlWorkbench = throw "'mysqlWorkbench' has been renamed to/replaced by 'mysql-workbench'"; # Converted to throw 2022-02-22
  myxer = throw "Myxer has been removed from nixpkgs, as it has been unmaintained since Jul 31, 2021"; # Added 2022-06-08

  ### N ###

  ncdu_2 = ncdu; # Added 2022-07-22
  nccl = throw "nccl has been renamed to cudaPackages.nccl"; # Added 2022-04-04
  nccl_cudatoolkit_10 = throw "nccl_cudatoolkit_10 has been renamed to cudaPackages_10.nccl"; # Added 2022-04-04
  nccl_cudatoolkit_11 = throw "nccl_cudatoolkit_11 has been renamed to cudaPackages_11.nccl"; # Added 2022-04-04

  net_snmp = throw "'net_snmp' has been renamed to/replaced by 'net-snmp'"; # Converted to throw 2022-09-24
  nagiosPluginsOfficial = throw "'nagiosPluginsOfficial' has been renamed to/replaced by 'monitoring-plugins'"; # Converted to throw 2022-09-24
  ncat = throw "'ncat' has been renamed to/replaced by 'nmap'"; # Converted to throw 2022-02-22
  neap = throw "neap was removed from nixpkgs, as it relies on python2"; # Added 2022-01-12
  neochat = libsForQt5.plasmaMobileGear.neochat; # added 2022-05-10
  nettools_mptcp = throw "'nettools_mptcp' has been moved to https://github.com/teto/mptcp-flake"; # Converted to throw 2022-10-04
  networkmanager_fortisslvpn = throw "'networkmanager_fortisslvpn' has been renamed to/replaced by 'networkmanager-fortisslvpn'"; # Converted to throw 2022-02-22
  networkmanager_iodine = throw "'networkmanager_iodine' has been renamed to/replaced by 'networkmanager-iodine'"; # Converted to throw 2022-02-22
  networkmanager_l2tp = throw "'networkmanager_l2tp' has been renamed to/replaced by 'networkmanager-l2tp'"; # Converted to throw 2022-02-22
  networkmanager_openconnect = throw "'networkmanager_openconnect' has been renamed to/replaced by 'networkmanager-openconnect'"; # Converted to throw 2022-02-22
  networkmanager_openvpn = throw "'networkmanager_openvpn' has been renamed to/replaced by 'networkmanager-openvpn'"; # Converted to throw 2022-02-22
  networkmanager_vpnc = throw "'networkmanager_vpnc' has been renamed to/replaced by 'networkmanager-vpnc'"; # Converted to throw 2022-02-22
  nfsUtils = throw "'nfsUtils' has been renamed to/replaced by 'nfs-utils'"; # Converted to throw 2022-02-22
  nginxUnstable = throw "'nginxUnstable' has been renamed to/replaced by 'nginxMainline'"; # Converted to throw 2022-02-22
  nilfs_utils = throw "'nilfs_utils' has been renamed to/replaced by 'nilfs-utils'"; # Converted to throw 2022-02-22
  nix-direnv-flakes = nix-direnv; # Added 2021-11-09
  nix-review = throw "'nix-review' has been renamed to/replaced by 'nixpkgs-review'"; # Converted to throw 2022-09-24
  nixFlakes = throw "'nixFlakes' has been renamed to/replaced by 'nixVersions.stable'"; # Converted to throw 2022-09-24
  nixStable = nixVersions.stable; # Added 2022-01-24
  nixUnstable = nixVersions.unstable; # Added 2022-01-26
  nix_2_3 = nixVersions.nix_2_3; # Added 2022-01-26
  nix_2_4 = nixVersions.nix_2_4; # Added 2022-01-26
  nix_2_5 = nixVersions.nix_2_5; # Added 2022-01-26
  nix_2_6 = nixVersions.nix_2_6; # Added 2022-01-26
  nixopsUnstable = nixops_unstable; # Added 2022-03-03
  nixosTest = testers.nixosTest; # Added 2022-05-05
  nixui = throw "nixui has been removed from nixpkgs, due to the project being unmaintained"; # Added 2022-05-23
  nmap-unfree = throw "'nmap-unfree' has been renamed to/replaced by 'nmap'"; # Converted to throw 2022-09-24
  nmap-graphical = throw "nmap graphical support has been removed due to its python2 dependency"; # Added 2022-04-26
  nmap_graphical = throw "nmap graphical support has been removed due to its python2 dependency"; # Modified 2022-04-26
  nodejs-10_x = throw "nodejs-10_x has been removed. Use a newer version instead."; # Added 2022-05-31
  nodejs-12_x = throw "nodejs-12_x has been removed. Use a newer version instead."; # Added 2022-07-04
  nologin = throw "'nologin' has been renamed to/replaced by 'shadow'"; # Converted to throw 2022-02-22
  nomad_1_1 = throw "nomad_1_1 has been removed because it's outdated. Use a a newer version instead"; # Added 2022-05-22
  noto-fonts-cjk = noto-fonts-cjk-sans; # Added 2021-12-16
  nottetris2 = throw "nottetris2 was removed because it is unmaintained by upstream and broken"; # Added 2022-01-15
  ntdb = throw "ntdb has been removed: abandoned by upstream"; # Added 2022-04-21
  nxproxy = throw "'nxproxy' has been renamed to/replaced by 'nx-libs'"; # Converted to throw 2022-02-22

  ### O ###

  oathToolkit = oath-toolkit; # Added 2022-04-04
  oci-image-tool = throw "oci-image-tool is no longer actively maintained, and has had major deficiencies for several years."; # Added 2022-05-14;
  OVMF-CSM = throw "OVMF-CSM has been removed in favor of OVMFFull"; # Added 2021-10-16
  OVMF-secureBoot = throw "OVMF-secureBoot has been removed in favor of OVMFFull"; # Added 2021-10-16
  oauth2_proxy = throw "'oauth2_proxy' has been renamed to/replaced by 'oauth2-proxy'"; # Converted to throw 2022-09-24
  ocropus = throw "ocropus has been removed: abandoned by upstream"; # Added 2022-04-24
  odpdown = throw "odpdown has been removed because it lacks python3 support"; # Added 2022-04-25
  openbazaar = throw "openbazzar has been removed from nixpkgs as upstream has abandoned the project"; # Added 2022-01-06
  openbazaar-client = throw "openbazzar-client has been removed from nixpkgs as upstream has abandoned the project"; # Added 2022-01-06
  opencascade_oce = throw "'opencascade_oce' has been renamed to/replaced by 'opencascade'"; # Converted to throw 2022-02-22
  opencl-icd = throw "'opencl-icd' has been renamed to/replaced by 'ocl-icd'"; # Converted to throw 2022-02-22
  openconnect_head = openconnect_unstable; # Added 2022-03-29
  openconnect_gnutls = openconnect; # Added 2022-03-29
  openelec-dvb-firmware = throw "'openelec-dvb-firmware' has been renamed to/replaced by 'libreelec-dvb-firmware'"; # Converted to throw 2022-09-24
  openexr_ctl = throw "'openexr_ctl' has been renamed to/replaced by 'ctl'"; # Converted to throw 2022-02-22
  openisns = throw "'openisns' has been renamed to/replaced by 'open-isns'"; # Converted to throw 2022-09-24
  openjpeg_2 = throw "'openjpeg_2' has been renamed to/replaced by 'openjpeg'"; # Converted to throw 2022-09-24
  openmpt123 = libopenmpt; # Added 2021-09-05
  opensans-ttf = throw "'opensans-ttf' has been renamed to/replaced by 'open-sans'"; # Converted to throw 2022-02-22
  openssh_with_kerberos = throw "'openssh_with_kerberos' has been renamed to/replaced by 'openssh'"; # Converted to throw 2022-02-22
  openssl_3_0 = openssl_3; # Added 2022-06-27
  orchis = throw "'orchis' has been renamed to/replaced by 'orchis-theme'"; # Converted to throw 2022-09-24
  osxfuse = throw "'osxfuse' has been renamed to/replaced by 'macfuse-stubs'"; # Converted to throw 2022-09-24
  owncloudclient = throw "'owncloudclient' has been renamed to/replaced by 'owncloud-client'"; # Converted to throw 2022-02-22

  ### P ###

  PPSSPP = throw "'PPSSPP' has been renamed to/replaced by 'ppsspp'"; # Converted to throw 2022-02-22

  p11_kit = throw "'p11_kit' has been renamed to/replaced by 'p11-kit'"; # Converted to throw 2022-02-22
  packet-cli = metal-cli; # Added 2021-10-25
  paperless = throw "'paperless' has been renamed to/replaced by 'paperless-ngx'"; # Converted to throw 2022-09-24
  paperless-ng = paperless-ngx; # Added 2022-04-11
  parity = throw "'parity' has been renamed to/replaced by 'openethereum'"; # Converted to throw 2022-09-24
  parity-ui = throw "parity-ui was removed because it was broken and unmaintained by upstream"; # Added 2022-01-10
  parlatype = throw "parlatype has been removed: unmaintained"; # Added 2022-04-24
  parquet-cpp = throw "'parquet-cpp' has been renamed to/replaced by 'arrow-cpp'"; # Converted to throw 2022-02-22
  patchmatrix = throw "'patchmatrix' has been renamed to/replaced by 'open-music-kontrollers.patchmatrix'"; # Added 2022-03-09
  pass-otp = throw "'pass-otp' has been renamed to/replaced by 'pass.withExtensions'"; # Converted to throw 2022-02-22
  pbis-open = throw "pbis-open has been removed, because it is no longer maintained upstream"; # added 2021-12-15
  pdf-redact-tools = throw "pdf-redact-tools has been removed from nixpkgs because the upstream has abandoned the project"; # Added 2022-01-01
  pdfmod = throw "pdfmod has been removed"; # Added 2022-01-15
  pdfstudio = throw "'pdfstudio' has been replaced with 'pdfstudio<year>', where '<year>' is the year from the PDF Studio version number, because each license is specific to a given year"; # Added 2022-09-04
  peach = asouldocs; # Added 2022-08-28
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  perlXMLParser = throw "'perlXMLParser' has been renamed to/replaced by 'perlPackages.XMLParser'"; # Converted to throw 2022-02-22
  perlArchiveCpio = throw "'perlArchiveCpio' has been renamed to/replaced by 'perlPackages.ArchiveCpio'"; # Converted to throw 2022-02-22
  pgadmin = pgadmin4; # Added 2022-01-14
  pgadmin3 = throw "pgadmin3 was removed for being unmaintained, use pgadmin4 instead."; # Added 2022-03-30
  pgp-tools = throw "'pgp-tools' has been renamed to/replaced by 'signing-party'"; # Converted to throw 2022-02-22
  pg_tmp = throw "'pg_tmp' has been renamed to/replaced by 'ephemeralpg'"; # Converted to throw 2022-02-22
  phantomjs = throw "phantomjs 1.9.8 has been dropped due to lack of maintenance and security issues"; # Added 2022-02-20
  phantomjs2 = throw "phantomjs2 has been dropped due to lack of maintenance"; # Added 2022-04-22
  philter = throw "philter has been removed: abandoned by upstream"; # Added 2022-04-26
  phraseapp-client = throw "phraseapp-client is archived by upstream. Use phrase-cli instead"; # Added 2022-05-15
  phwmon = throw "phwmon has been removed: abandoned by upstream"; # Added 2022-04-24

  # Obsolete PHP version aliases
  php74 = throw "php74 has been dropped due to the lack of maintanence from upstream for future releases"; # Added 2022-05-24
  php74Packages = php74; # Added 2022-05-24
  php74Extensions = php74; # Added 2022-05-24

  php73Packages = throw "'php73Packages' has been renamed to/replaced by 'php73'"; # Converted to throw 2022-09-24
  php73Extensions = throw "'php73Extensions' has been renamed to/replaced by 'php73'"; # Converted to throw 2022-09-24

  php73-embed = throw "'php73-embed' has been renamed to/replaced by 'php-embed'"; # Converted to throw 2022-09-24
  php74-embed = throw "'php74-embed' has been renamed to/replaced by 'php-embed'"; # Converted to throw 2022-09-24

  php73Packages-embed = throw "'php73Packages-embed' has been renamed to/replaced by 'phpPackages-embed'"; # Converted to throw 2022-09-24
  php74Packages-embed = throw "'php74Packages-embed' has been renamed to/replaced by 'phpPackages-embed'"; # Converted to throw 2022-09-24

  php73-unit = throw "'php73-unit' has been renamed to/replaced by 'php-unit'"; # Converted to throw 2022-09-24
  php74-unit = throw "'php74-unit' has been renamed to/replaced by 'php-unit'"; # Converted to throw 2022-09-24

  php73Packages-unit = throw "'php73Packages-unit' has been renamed to/replaced by 'phpPackages-unit'"; # Converted to throw 2022-09-24
  php74Packages-unit = throw "'php74Packages-unit' has been renamed to/replaced by 'phpPackages-unit'"; # Converted to throw 2022-09-24

  pidgin-with-plugins = throw "'pidgin-with-plugins' has been renamed to/replaced by 'pidgin'"; # Converted to throw 2022-02-22
  pidginlatex = throw "'pidginlatex' has been renamed to/replaced by 'pidgin-latex'"; # Converted to throw 2022-02-22
  pidginlatexSF = throw "'pidginlatexSF' has been renamed to/replaced by 'pidgin-latex'"; # Converted to throw 2022-02-22
  pidginmsnpecan = throw "'pidginmsnpecan' has been renamed to/replaced by 'pidgin-msn-pecan'"; # Converted to throw 2022-02-22
  pidginosd = throw "'pidginosd' has been renamed to/replaced by 'pidgin-osd'"; # Converted to throw 2022-02-22
  pidginotr = throw "'pidginotr' has been renamed to/replaced by 'pidgin-otr'"; # Converted to throw 2022-02-22
  pidginsipe = throw "'pidginsipe' has been renamed to/replaced by 'pidgin-sipe'"; # Converted to throw 2022-02-22
  pidginwindowmerge = throw "'pidginwindowmerge' has been renamed to/replaced by 'pidgin-window-merge'"; # Converted to throw 2022-02-22
  pifi = throw "pifi has been removed from nixpkgs, as it is no longer developed"; # Added 2022-01-19
  ping = throw "'ping' does not build with recent valac and has been removed. If you are just looking for the 'ping' command use either 'iputils' or 'inetutils'"; # Added 2022-04-18
  piwik = throw "'piwik' has been renamed to/replaced by 'matomo'"; # Converted to throw 2022-02-22
  pixie = throw "pixie has been removed: abandoned by upstream"; # Added 2022-04-21
  pkgconfig = throw "'pkgconfig' has been renamed to/replaced by 'pkg-config'"; # Converted to throw 2022-09-24
  pkgconfigUpstream = throw "'pkgconfigUpstream' has been renamed to/replaced by 'pkg-configUpstream'"; # Converted to throw 2022-02-22
  pleroma-otp = throw "'pleroma-otp' has been renamed to/replaced by 'pleroma'"; # Converted to throw 2022-09-24
  plexpy = throw "'plexpy' has been renamed to/replaced by 'tautulli'"; # Converted to throw 2022-02-22
  pltScheme = racket; # Added 20218-01-01
  pmtools = throw "'pmtools' has been renamed to/replaced by 'acpica-tools'"; # Converted to throw 2022-02-22
  pocketsphinx = throw "pocketsphinx has been removed: unmaintained"; # Added 2022-04-24
  polarssl = throw "'polarssl' has been renamed to/replaced by 'mbedtls'"; # Converted to throw 2022-02-22
  polysh = throw "polysh has been removed from nixpkgs as the upstream has abandoned the project"; # Added 2022-01-01
  pond = throw "pond has been dropped due to the lack of maintanence from upstream since 2016"; # Added 2022-06-02
  poppler_qt5 = throw "'poppler_qt5' has been renamed to/replaced by 'libsForQt5.poppler'"; # Converted to throw 2022-02-22
  powerdns = pdns; # Added 2022-03-28
  portaudio2014 = throw "'portaudio2014' has been removed"; # Added 2022-05-10

  # postgresql
  postgresql96 = throw "'postgresql96' has been renamed to/replaced by 'postgresql_9_6'"; # Converted to throw 2022-09-24
  postgresql_9_6 = throw "postgresql_9_6 has been removed from nixpkgs, as this version is no longer supported by upstream"; # Added 2021-12-03

  # postgresql plugins
  cstore_fdw = throw "'cstore_fdw' has been renamed to/replaced by 'postgresqlPackages.cstore_fdw'"; # Converted to throw 2022-09-24
  pg_cron = throw "'pg_cron' has been renamed to/replaced by 'postgresqlPackages.pg_cron'"; # Converted to throw 2022-09-24
  pg_hll = throw "'pg_hll' has been renamed to/replaced by 'postgresqlPackages.pg_hll'"; # Converted to throw 2022-09-24
  pg_repack = throw "'pg_repack' has been renamed to/replaced by 'postgresqlPackages.pg_repack'"; # Converted to throw 2022-09-24
  pg_similarity = throw "'pg_similarity' has been renamed to/replaced by 'postgresqlPackages.pg_similarity'"; # Converted to throw 2022-09-24
  pg_topn = throw "'pg_topn' has been renamed to/replaced by 'postgresqlPackages.pg_topn'"; # Converted to throw 2022-09-24
  pgjwt = throw "'pgjwt' has been renamed to/replaced by 'postgresqlPackages.pgjwt'"; # Converted to throw 2022-09-24
  pgroonga = throw "'pgroonga' has been renamed to/replaced by 'postgresqlPackages.pgroonga'"; # Converted to throw 2022-09-24
  pgtap = throw "'pgtap' has been renamed to/replaced by 'postgresqlPackages.pgtap'"; # Converted to throw 2022-09-24
  plv8 = throw "'plv8' has been renamed to/replaced by 'postgresqlPackages.plv8'"; # Converted to throw 2022-09-24
  postgis = throw "'postgis' has been renamed to/replaced by 'postgresqlPackages.postgis'"; # Converted to throw 2022-09-24
  tilp2 = throw "tilp2 has been removed"; # Added 2022-01-15
  timekeeper = throw "timekeeper has been removed"; # Added 2022-01-16
  timescaledb = throw "'timescaledb' has been renamed to/replaced by 'postgresqlPackages.timescaledb'"; # Converted to throw 2022-09-24
  tsearch_extras = throw "'tsearch_extras' has been renamed to/replaced by 'postgresqlPackages.tsearch_extras'"; # Converted to throw 2022-09-24

  pinentry_curses = throw "'pinentry_curses' has been renamed to/replaced by 'pinentry-curses'"; # Converted to throw 2022-09-24
  pinentry_emacs = throw "'pinentry_emacs' has been renamed to/replaced by 'pinentry-emacs'"; # Converted to throw 2022-09-24
  pinentry_gnome = throw "'pinentry_gnome' has been renamed to/replaced by 'pinentry-gnome'"; # Converted to throw 2022-09-24
  pinentry_gtk2 = throw "'pinentry_gtk2' has been renamed to/replaced by 'pinentry-gtk2'"; # Converted to throw 2022-09-24
  pinentry_qt = throw "'pinentry_qt' has been renamed to/replaced by 'pinentry-qt'"; # Converted to throw 2022-09-24
  pinentry_qt5 = throw "'pinentry_qt5' has been renamed to/replaced by 'pinentry-qt'"; # Converted to throw 2022-09-24
  prboom = throw "prboom was removed because it was abandoned by upstream, use prboom-plus instead"; # Added 2022-04-24
  processing3 = throw "'processing3' has been renamed to/replaced by 'processing'"; # Converted to throw 2022-09-24
  procps-ng = throw "'procps-ng' has been renamed to/replaced by 'procps'"; # Converted to throw 2022-02-22
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-mesos-exporter = throw "prometheus-mesos-exporter is deprecated and archived by upstream"; # Added 2022-04-05
  prometheus-unifi-exporter = throw "prometheus-unifi-exporter is deprecated and archived by upstream, use unifi-poller instead"; # Added 2022-06-03
  protobuf3_11 = throw "protobuf3_11 does not receive updates anymore and has been removed"; # Added 2022-09-28
  proxytunnel = throw "proxytunnel has been removed from nixpkgs, because it has not been update upstream since it was added to nixpkgs in 2008 and has therefore bitrotted."; # added 2021-12-15
  pulseaudio-hsphfpd = throw "pulseaudio-hsphfpd upstream has been abandoned"; # Added 2022-03-23
  pulseaudio-modules-bt = throw "pulseaudio-modules-bt has been abandoned, and is superseded by pulseaudio's native bt functionality"; # Added 2022-04-01
  pulseaudioLight = throw "'pulseaudioLight' has been renamed to/replaced by 'pulseaudio'"; # Converted to throw 2022-02-22
  pulseeffects-pw = throw "'pulseeffects-pw' has been renamed to/replaced by 'easyeffects'"; # Converted to throw 2022-09-24
  py-wmi-client = throw "py-wmi-client has been removed: abandoned by upstream"; # Added 2022-04-26
  pydb = throw "pydb has been removed: abandoned by upstream"; # Added 2022-04-22
  pybitmessage = throw "pybitmessage was removed from nixpkgs as it is stuck on python2"; # Added 2022-01-01
  pygmentex = throw "'pygmentex' has been renamed to/replaced by 'texlive.bin.pygmentex'"; # Converted to throw 2022-09-24
  pyo3-pack = throw "'pyo3-pack' has been renamed to/replaced by 'maturin'"; # Converted to throw 2022-09-24
  pyrex = throw "pyrex has been removed from nixpkgs as the project is still stuck on python2"; # Added 2022-01-12
  pyrex095 = throw "pyrex has been removed from nixpkgs as the project is still stuck on python2"; # Added 2022-01-12
  pyrex096 = throw "pyrex has been removed from nixpkgs as the project is still stuck on python2"; # Added 2022-01-12
  pyrit = throw "pyrit has been removed from nixpkgs as the project is still stuck on python2"; # Added 2022-01-01
  python = python2; # Added 2022-01-11
  python-swiftclient = swiftclient; # Added 2021-09-09
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11

  ### Q ###

  QmidiNet = throw "'QmidiNet' has been renamed to/replaced by 'qmidinet'"; # Converted to throw 2022-02-22
  qca-qt5 = throw "'qca-qt5' has been renamed to/replaced by 'libsForQt5.qca-qt5'"; # Converted to throw 2022-02-22
  qca2 = throw "qca2 has been removed, because it depended on qt4"; # Added 2022-05-26
  qcsxcad = throw "'qcsxcad' has been renamed to/replaced by 'libsForQt5.qcsxcad'"; # Converted to throw 2022-09-24
  qflipper = qFlipper; # Added 2022-02-11
  qshowdiff = throw "'qshowdiff' (Qt4) is unmaintained and not been updated since its addition in 2010"; # Added 2022-06-14
  qt5ct = libsForQt5.qt5ct; # Added 2021-12-27
  qtcurve = throw "'qtcurve' has been renamed to/replaced by 'libsForQt5.qtcurve'"; # Converted to throw 2022-09-24
  qtscriptgenerator = throw "'qtscriptgenerator' (Qt4) is unmaintained upstream and not used in nixpkgs"; # Added 2022-06-14
  quake3game = throw "'quake3game' has been renamed to/replaced by 'ioquake3'"; # Converted to throw 2022-02-22
  qwt6 = throw "'qwt6' has been renamed to/replaced by 'libsForQt5.qwt'"; # Converted to throw 2022-02-22

  ### R ###

  radare2-cutter = throw "'radare2-cutter' has been renamed to/replaced by 'cutter'"; # Converted to throw 2022-09-24
  railcar = throw "'railcar' has been removed, as the upstream project has been abandoned"; # Added 2022-06-27
  rawdog = throw "rawdog has been removed from nixpkgs as it still requires python2"; # Added 2022-01-01
  rdiff_backup = throw "'rdiff_backup' has been renamed to/replaced by 'rdiff-backup'"; # Converted to throw 2022-02-22
  rdmd = throw "'rdmd' has been renamed to/replaced by 'dtools'"; # Converted to throw 2022-02-22
  readline5 = throw "readline-5 is no longer supported in nixpkgs, please use 'readline' for main supported version"; # Added 2022-02-20
  readline62 = throw "readline-6.2 is no longer supported in nixpkgs, please use 'readline' for main supported version"; # Added 2022-02-20
  redshift-wlr = throw "redshift-wlr has been replaced by gammastep"; # Added 2021-12-25
  reicast = throw "reicast has been removed from nixpkgs as it is unmaintained, please use flycast instead"; # Added 2022-03-07

  # 3 resholve aliases below added 2022-04-08; drop after 2022-11-30?
  resholvePackage = throw "resholvePackage has been renamed to resholve.mkDerivation"; # Added 2022-04-08
  resholveScript = throw "resholveScript has been renamed to resholve.writeScript"; # Added 2022-04-08
  resholveScriptBin = throw "resholveScriptBin has been renamed to resholve.writeScriptBin"; # Added 2022-04-08

  residualvm = throw "residualvm was merged to scummvm code in 2018-06-15; consider using scummvm"; # Added 2021-11-27
  retroArchCores = throw "retroArchCores has been removed. Please use overrides instead, e.g.: `retroarch.override { cores = with libretro; [ ... ]; }`"; # Added 2021-11-19
  retroshare06 = throw "'retroshare06' has been renamed to/replaced by 'retroshare'"; # Converted to throw 2022-09-24
  riak = throw "riak has been removed due to lack of maintainer to update the package"; # Added 2022-06-22
  rimshot = throw "rimshot has been removed, because it is broken and no longer maintained upstream"; # Added 2022-01-15
  ring-daemon = jami-daemon; # Added 2021-10-26
  rls = throw "rls was discontinued upstream, use rust-analyzer instead"; # Added 2022-09-06
  rng_tools = throw "'rng_tools' has been renamed to/replaced by 'rng-tools'"; # Converted to throw 2022-02-22
  robomongo = throw "'robomongo' has been renamed to/replaced by 'robo3t'"; # Converted to throw 2022-02-22
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rpiboot-unstable = throw "'rpiboot-unstable' has been renamed to/replaced by 'rpiboot'"; # Converted to throw 2022-09-24
  rr-unstable = rr; # Added 2022-09-17
  rssglx = throw "'rssglx' has been renamed to/replaced by 'rss-glx'"; # Converted to throw 2022-02-22
  runCommandNoCC = throw "'runCommandNoCC' has been renamed to/replaced by 'runCommand'"; # Converted to throw 2022-09-24
  runCommandNoCCLocal = throw "'runCommandNoCCLocal' has been renamed to/replaced by 'runCommandLocal'"; # Converted to throw 2022-09-24
  rustracerd = throw "rustracerd has been removed because it is broken and unmaintained"; # Added 2021-10-19
  rxvt_unicode = throw "'rxvt_unicode' has been renamed to/replaced by 'rxvt-unicode-unwrapped'"; # Converted to throw 2022-09-24
  rxvt_unicode-with-plugins = throw "'rxvt_unicode-with-plugins' has been renamed to/replaced by 'rxvt-unicode'"; # Converted to throw 2022-09-24

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtlwifi_new-firmware = throw "'rtlwifi_new-firmware' has been renamed to/replaced by 'rtw88-firmware'"; # Converted to throw 2022-09-24

  ### S ###

  s2n = throw "'s2n' has been renamed to/replaced by 's2n-tls'"; # Converted to throw 2022-09-24
  s3gof3r = throw "s3gof3r has been dropped due to the lack of maintenance from upstream since 2017"; # Added 2022-06-04
  s6Dns = throw "'s6Dns' has been renamed to/replaced by 's6-dns'"; # Converted to throw 2022-02-22
  s6LinuxUtils = throw "'s6LinuxUtils' has been renamed to/replaced by 's6-linux-utils'"; # Converted to throw 2022-02-22
  s6Networking = throw "'s6Networking' has been renamed to/replaced by 's6-networking'"; # Converted to throw 2022-02-22
  s6PortableUtils = throw "'s6PortableUtils' has been renamed to/replaced by 's6-portable-utils'"; # Converted to throw 2022-02-22
  sagemath = throw "'sagemath' has been renamed to/replaced by 'sage'"; # Converted to throw 2022-02-22
  salut_a_toi = throw "salut_a_toi was removed because it was broken and used Python 2"; # added 2022-06-05
  sam = throw "'sam' has been renamed to/replaced by 'deadpixi-sam'"; # Converted to throw 2022-02-22
  samsungUnifiedLinuxDriver = throw "'samsungUnifiedLinuxDriver' has been renamed to/replaced by 'samsung-unified-linux-driver'"; # Converted to throw 2022-02-22
  sane-backends-git = throw "'sane-backends-git' has been renamed to/replaced by 'sane-backends'"; # Converted to throw 2022-09-24
  saneBackends = throw "'saneBackends' has been renamed to/replaced by 'sane-backends'"; # Converted to throw 2022-02-22
  saneBackendsGit = throw "'saneBackendsGit' has been renamed to/replaced by 'sane-backends'"; # Converted to throw 2022-02-22
  saneFrontends = throw "'saneFrontends' has been renamed to/replaced by 'sane-frontends'"; # Converted to throw 2022-02-22
  scallion = throw "scallion has been removed, because it is currently unmaintained upstream"; # Added 2021-12-15
  scim = throw "'scim' has been renamed to/replaced by 'sc-im'"; # Converted to throw 2022-02-22
  scollector = throw "'scollector' has been renamed to/replaced by 'bosun'"; # Converted to throw 2022-02-22
  scribusUnstable = throw "'scribusUnstable' has been renamed to 'scribus'"; # Added 2022-05-13
  scyther = throw "scyther has been removed since it currently only supports Python 2, see https://github.com/cascremers/scyther/issues/20"; # Added 2021-10-07
  sdlmame = throw "'sdlmame' has been renamed to/replaced by 'mame'"; # Converted to throw 2022-09-24
  sepolgen = throw "sepolgen was merged into selinux-python"; # Added 2021-11-11
  session-desktop-appimage = session-desktop; # Added 2022-08-22
  shared_mime_info = throw "'shared_mime_info' has been renamed to/replaced by 'shared-mime-info'"; # Converted to throw 2022-02-22
  inherit (libsForQt5.mauiPackages) shelf; # Added 2022-05-17
  shellinabox = throw "shellinabox has been removed from nixpkgs, as it was unmaintained upstream"; # Added 2021-12-15
  sickbeard = throw "sickbeard has been removed from nixpkgs, as it was unmaintained"; # Added 2022-01-01
  sickrage = throw "sickbeard has been removed from nixpkgs, as it was unmaintained"; # Added 2022-01-01
  sigurlx = throw "sigurlx has been removed (upstream is gone)"; # Added 2022-01-24
  skrooge2 = throw "'skrooge2' has been renamed to/replaced by 'skrooge'"; # Converted to throw 2022-02-22
  skype = throw "'skype' has been renamed to/replaced by 'skypeforlinux'"; # Converted to throw 2022-02-22
  slack-dark = throw "'slack-dark' has been renamed to/replaced by 'slack'"; # Converted to throw 2022-09-24
  slic3r-prusa3d = throw "'slic3r-prusa3d' has been renamed to/replaced by 'prusa-slicer'"; # Converted to throw 2022-02-22
  slurm-full = throw "'slurm-full' has been renamed to/replaced by 'slurm'"; # Converted to throw 2022-02-22
  slurm-llnl = throw "'slurm-llnl' has been renamed to/replaced by 'slurm'"; # Converted to throw 2022-09-24
  slurm-llnl-full = throw "'slurm-llnl-full' has been renamed to/replaced by 'slurm-full'"; # Converted to throw 2022-09-24
  smbclient = throw "'smbclient' has been renamed to/replaced by 'samba'"; # Converted to throw 2022-02-22
  snack = throw "snack has been removed: broken for 5+ years"; # Added 2022-04-21
  soldat-unstable = opensoldat; # Added 2022-07-02
  solr_8 = throw "'solr_8' has been renamed to/replaced by 'solr'"; # Converted to throw 2022-09-24

  sourceHanSansPackages = {
    japanese = throw "'sourceHanSansPackages.japanese' has been replaced by 'source-han-sans'"; # Converted to throw 2022-09-24
    korean = throw "'sourceHanSansPackages.korean' has been replaced by 'source-han-sans'"; # Converted to throw 2022-09-24
    simplified-chinese = throw "'sourceHanSansPackages.simplified-chinese' has been replaced by 'source-han-sans'"; # Converted to throw 2022-09-24
    traditional-chinese = throw "'sourceHanSansPackages.traditional-chinese' has been replaced by 'source-han-sans'"; # Converted to throw 2022-09-24
  };
  source-han-sans-japanese = throw "'source-han-sans-japanese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2022-09-24
  source-han-sans-korean = throw "'source-han-sans-korean' has been renamed to/replaced by 'source-han-sans;#'"; # Converted to throw 2022-09-24
  source-han-sans-simplified-chinese = throw "'source-han-sans-simplified-chinese' has been renamed to/replaced by 'source-han-sans;#'"; # Converted to throw 2022-09-24
  source-han-sans-traditional-chinese = throw "'source-han-sans-traditional-chinese' has been renamed to/replaced by 'source-han-sans;#'"; # Converted to throw 2022-09-24
  sourceHanSerifPackages = {
    japanese = throw "'sourceHanSerifPackages.japanese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2022-09-24
    korean = throw "'sourceHanSerifPackages.korean' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2022-09-24
    simplified-chinese = throw "'sourceHanSerifPackages.simplified-chinese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2022-09-24
    traditional-chinese = throw "'sourceHanSerifPackages.traditional-chinese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2022-09-24
  };
  source-han-serif-japanese = throw "'source-han-serif-japanese' has been renamed to/replaced by 'source-han-serif;#'"; # Converted to throw 2022-09-24
  source-han-serif-korean = throw "'source-han-serif-korean' has been renamed to/replaced by 'source-han-serif;#'"; # Converted to throw 2022-09-24
  source-han-serif-simplified-chinese = throw "'source-han-serif-simplified-chinese' has been renamed to/replaced by 'source-han-serif;#'"; # Converted to throw 2022-09-24
  source-han-serif-traditional-chinese = throw "'source-han-serif-traditional-chinese' has been renamed to/replaced by 'source-han-serif;#'"; # Converted to throw 2022-09-24

  sourcetrail = throw "sourcetrail has been removed: abandoned by upstream"; # Added 2022-08-14

  spaceOrbit = throw "'spaceOrbit' has been renamed to/replaced by 'space-orbit'"; # Converted to throw 2022-02-22
  spectral = throw "'spectral' has been renamed to/replaced by 'neochat'"; # Converted to throw 2022-09-24
  speech_tools = throw "'speech_tools' has been renamed to/replaced by 'speech-tools'"; # Converted to throw 2022-02-22
  speedometer = throw "speedometer has been removed: abandoned by upstream"; # Added 2022-04-24
  speedtest_cli = throw "'speedtest_cli' has been renamed to/replaced by 'speedtest-cli'"; # Converted to throw 2022-02-22
  sphinxbase = throw "sphinxbase has been removed: unmaintained"; # Added 2022-04-24
  spice_gtk = throw "'spice_gtk' has been renamed to/replaced by 'spice-gtk'"; # Converted to throw 2022-02-22
  spice_protocol = throw "'spice_protocol' has been renamed to/replaced by 'spice-protocol'"; # Converted to throw 2022-02-22
  spidermonkey_68 = throw "spidermonkey_68 has been removed. Please use spidermonkey_91 instead"; # added 2022-01-04
  spidermonkey = throw "'spidermonkey' has been renamed to/replaced by 'spidermonkey_78'"; # Converted to throw 2022-09-24
  split2flac = throw "split2flac has been removed. Consider using the shnsplit command from shntool package or help packaging unflac."; # added 2022-01-13
  spring-boot = throw "'spring-boot' has been renamed to/replaced by 'spring-boot-cli'"; # Converted to throw 2022-09-24
  sqlite3_analyzer = throw "'sqlite3_analyzer' has been renamed to/replaced by 'sqlite-analyzer'"; # Converted to throw 2022-02-22
  sqliteInteractive = throw "'sqliteInteractive' has been renamed to/replaced by 'sqlite-interactive'"; # Converted to throw 2022-02-22
  squid4 = throw "'squid4' has been renamed to/replaced by 'squid'"; # Converted to throw 2022-09-24
  srcml = throw "'srcml' has been removed: abandoned by upstream"; # Added 2022-07-21
  sshfsFuse = throw "'sshfsFuse' has been renamed to/replaced by 'sshfs-fuse'"; # Converted to throw 2022-02-22
  ssmtp = throw "'ssmtp' has been removed due to the software being unmaintained. 'msmtp' can be used as a replacement"; # Added 2022-04-17
  steam-run-native = steam-run; # Added 2022-02-21
  stride = throw "'stride' aka. Atlassian Stride is dead since 2019 (bought by Slack)"; # added 2022-06-15
  subversion_1_10 = throw "subversion_1_10 has been removed as it has reached its end of life"; # Added 2022-04-26
  sudolikeaboss = throw "sudolikeaboss is no longer maintained by upstream"; # Added 2022-04-16
  surf-webkit2 = throw "'surf-webkit2' has been renamed to/replaced by 'surf'"; # Converted to throw 2022-02-22
  swec = throw "swec has been removed; broken and abandoned upstream"; # Added 2021-10-14
  sweep-visualizer = throw "'sweep-visualizer' is abondoned upstream and depends on deprecated GNOME2/GTK2"; # Added 2022-06-15
  swtpm-tpm2 = throw "'swtpm-tpm2' has been renamed to/replaced by 'swtpm'"; # Converted to throw 2022-09-24
  syncthing-cli = throw "'syncthing-cli' has been renamed to/replaced by 'syncthing'"; # Converted to throw 2022-09-24
  synology-drive = throw "synology-drive has been superseded by synology-drive-client"; # Added 2021-11-26
  system_config_printer = throw "'system_config_printer' has been renamed to/replaced by 'system-config-printer'"; # Converted to throw 2022-02-22
  systool = throw "'systool' has been renamed to/replaced by 'sysfsutils'"; # Converted to throw 2022-02-22

  ### T ###

  tahoelafs = throw "'tahoelafs' has been renamed to/replaced by 'tahoe-lafs'"; # Converted to throw 2022-02-22
  tangogps = throw "'tangogps' has been renamed to/replaced by 'foxtrotgps'"; # Converted to throw 2022-09-24
  taplo-cli = taplo; # Added 2022-07-30
  taplo-lsp = taplo; # Added 2022-07-30
  teleconsole = throw "teleconsole is archived by upstream"; # Added 2022-04-05
  telepathy_farstream = throw "'telepathy_farstream' has been renamed to/replaced by 'telepathy-farstream'"; # Converted to throw 2022-02-22
  telepathy_gabble = throw "'telepathy_gabble' has been renamed to/replaced by 'telepathy-gabble'"; # Converted to throw 2022-02-22
  telepathy_glib = throw "'telepathy_glib' has been renamed to/replaced by 'telepathy-glib'"; # Converted to throw 2022-02-22
  telepathy_haze = throw "'telepathy_haze' has been renamed to/replaced by 'telepathy-haze'"; # Converted to throw 2022-02-22
  telepathy_idle = throw "'telepathy_idle' has been renamed to/replaced by 'telepathy-idle'"; # Converted to throw 2022-02-22
  telepathy_logger = throw "'telepathy_logger' has been renamed to/replaced by 'telepathy-logger'"; # Converted to throw 2022-02-22
  telepathy_mission_control = throw "'telepathy_mission_control' has been renamed to/replaced by 'telepathy-mission-control'"; # Converted to throw 2022-02-22
  telepathy_qt = throw "'telepathy_qt' has been renamed to/replaced by 'telepathy-qt'"; # Converted to throw 2022-02-22
  telepathy_qt5 = throw "'telepathy_qt5' has been renamed to/replaced by 'libsForQt5.telepathy'"; # Converted to throw 2022-02-22
  telnet = throw "'telnet' has been renamed to/replaced by 'inetutils'"; # Converted to throw 2022-02-22
  terraform-full = throw "terraform-full has been removed, it was an alias for 'terraform.full'"; # Added 2022-08-02
  terraform_0_13 = throw "terraform_0_13 has been removed from nixpkgs"; # Added 2022-06-26
  terraform_0_14 = throw "terraform_0_14 has been removed from nixpkgs"; # Added 2022-06-26
  terraform_0_15 = throw "terraform_0_15 has been removed from nixpkgs"; # Added 2022-06-26
  tesseract_4 = throw "'tesseract_4' has been renamed to/replaced by 'tesseract4'"; # Converted to throw 2022-02-22
  testVersion = testers.testVersion; # Added 2022-04-20
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  tex-gyre-bonum-math = throw "'tex-gyre-bonum-math' has been renamed to/replaced by 'tex-gyre-math.bonum'"; # Converted to throw 2022-02-22
  tex-gyre-pagella-math = throw "'tex-gyre-pagella-math' has been renamed to/replaced by 'tex-gyre-math.pagella'"; # Converted to throw 2022-02-22
  tex-gyre-schola-math = throw "'tex-gyre-schola-math' has been renamed to/replaced by 'tex-gyre-math.schola'"; # Converted to throw 2022-02-22
  tex-gyre-termes-math = throw "'tex-gyre-termes-math' has been renamed to/replaced by 'tex-gyre-math.termes'"; # Converted to throw 2022-02-22
  textadept11 = textadept; # Added 2022-06-07
  tftp_hpa = throw "'tftp_hpa' has been renamed to/replaced by 'tftp-hpa'"; # Converted to throw 2022-02-22
  timedoctor = throw "'timedoctor' has been removed from nixpkgs"; # Added 2022-10-09
  timescale-prometheus = throw "'timescale-prometheus' has been renamed to/replaced by 'promscale'"; # Converted to throw 2022-09-24
  timetable = throw "timetable has been removed, as the upstream project has been abandoned"; # Added 2021-09-05
  tkcvs = tkrev; # Added 2022-03-07
  tomboy = throw "tomboy is not actively developed anymore and was removed"; # Added 2022-01-27
  tor-arm = throw "tor-arm has been removed from nixpkgs as the upstream project has been abandoned"; # Added 2022-01-01
  torbrowser = throw "'torbrowser' has been renamed to/replaced by 'tor-browser-bundle-bin'"; # Converted to throw 2022-02-22
  trang = throw "'trang' has been renamed to/replaced by 'jing-trang'"; # Converted to throw 2022-02-22
  transfig = fig2dev; # Added 2022-02-15
  transmission_gtk = throw "'transmission_gtk' has been renamed to/replaced by 'transmission-gtk'"; # Converted to throw 2022-02-22
  transmission_remote_gtk = throw "'transmission_remote_gtk' has been renamed to/replaced by 'transmission-remote-gtk'"; # Converted to throw 2022-02-22
  truecrypt = throw "'truecrypt' has been renamed to/replaced by 'veracrypt'"; # Converted to throw 2022-02-22
  twister = throw "twister has been removed: abandoned by upstream and python2-only"; # Added 2022-04-26
  tychus = throw "tychus has been dropped due to the lack of maintenance from upstream since 2018"; # Added 2022-06-03
  typora = throw "Newer versions of typora use anti-user encryption and refuse to start. As such it has been removed"; # Added 2021-09-11

  ### U ###

  uade123 = uade; # Added 2022-07-30
  uberwriter = throw "'uberwriter' has been renamed to/replaced by 'apostrophe'"; # Converted to throw 2022-09-24
  ubootBeagleboneBlack = throw "'ubootBeagleboneBlack' has been renamed to/replaced by 'ubootAmx335xEVM'"; # Converted to throw 2022-09-24
  uchiwa = throw "uchiwa is deprecated and archived by upstream"; # Added 2022-05-02
  ucsFonts = throw "'ucsFonts' has been renamed to/replaced by 'ucs-fonts'"; # Converted to throw 2022-02-22
  ultrastardx-beta = throw "'ultrastardx-beta' has been renamed to/replaced by 'ultrastardx'"; # Converted to throw 2022-02-22
  unicorn-emu = throw "'unicorn-emu' has been renamed to/replaced by 'unicorn'"; # Converted to throw 2022-09-24
  unifiStable = throw "'unifiStable' has been renamed to/replaced by 'unifi6'"; # Converted to throw 2022-09-24
  unity3d = throw "'unity3d' is unmaintained, has seen no updates in years and depends on deprecated GTK2"; # Added 2022-06-16
  untrunc = throw "'untrunc' has been renamed to/replaced by 'untrunc-anthwlock'"; # Converted to throw 2022-09-24
  urxvt_autocomplete_all_the_things = throw "'urxvt_autocomplete_all_the_things' has been renamed to/replaced by 'rxvt-unicode-plugins.autocomplete-all-the-things'"; # Converted to throw 2022-09-24
  urxvt_bidi = throw "'urxvt_bidi' has been renamed to/replaced by 'rxvt-unicode-plugins.bidi'"; # Converted to throw 2022-09-24
  urxvt_font_size = throw "'urxvt_font_size' has been renamed to/replaced by 'rxvt-unicode-plugins.font-size'"; # Converted to throw 2022-09-24
  urxvt_perl = throw "'urxvt_perl' has been renamed to/replaced by 'rxvt-unicode-plugins.perl'"; # Converted to throw 2022-09-24
  urxvt_perls = throw "'urxvt_perls' has been renamed to/replaced by 'rxvt-unicode-plugins.perls'"; # Converted to throw 2022-09-24
  urxvt_tabbedex = throw "'urxvt_tabbedex' has been renamed to/replaced by 'rxvt-unicode-plugins.tabbedex'"; # Converted to throw 2022-09-24
  urxvt_theme_switch = throw "'urxvt_theme_switch' has been renamed to/replaced by 'rxvt-unicode-plugins.theme-switch'"; # Converted to throw 2022-09-24
  urxvt_vtwheel = throw "'urxvt_vtwheel' has been renamed to/replaced by 'rxvt-unicode-plugins.vtwheel'"; # Converted to throw 2022-09-24
  usb_modeswitch = throw "'usb_modeswitch' has been renamed to/replaced by 'usb-modeswitch'"; # Converted to throw 2022-02-22
  usbguard-nox = throw "'usbguard-nox' has been renamed to/replaced by 'usbguard'"; # Converted to throw 2022-09-24
  util-linuxCurses = util-linux; # Added 2022-04-12

  ### V ###

  v4l_utils = throw "'v4l_utils' has been renamed to/replaced by 'v4l-utils'"; # Converted to throw 2022-09-24
  vamp = {
    vampSDK = throw "'vamp.vampSDK' has been renamed to 'vamp-plugin-sdk'"; # Converted to throw 2022-09-24
  };
  vapor = throw "vapor was removed because it was unmaintained and upstream service no longer exists"; # Added 2022-01-15
  varnish70 = throw "varnish70 was removed from nixpkgs, because it was superseded upstream. Please switch to a different release"; # Added 2022-03-17
  vdirsyncerStable = throw "vdirsyncerStable has been replaced by vdirsyncer"; # Converted to throw 2022-09-24
  vgo2nix = throw "vgo2nix has been removed, because it was deprecated. Consider using gomod2nix instead"; # added 2022-08-24
  vimbWrapper = throw "'vimbWrapper' has been renamed to/replaced by 'vimb'"; # Converted to throw 2022-02-22
  virtuoso = throw "virtuoso has been removed, because it was unmaintained in nixpkgs"; # added 2021-12-15
  virtmanager = throw "'virtmanager' has been renamed to/replaced by 'virt-manager'"; # Converted to throw 2022-09-24
  virtmanager-qt = throw "'virtmanager-qt' has been renamed to/replaced by 'virt-manager-qt'"; # Converted to throw 2022-09-24
  virtviewer = throw "'virtviewer' has been renamed to/replaced by 'virt-viewer'"; # Converted to throw 2022-02-22
  vnc2flv = throw "vnc2flv has been removed: abandoned by upstream"; # Added 2022-03-21
  vorbisTools = throw "'vorbisTools' has been renamed to/replaced by 'vorbis-tools'"; # Converted to throw 2022-02-22
  vtun = throw "vtune has been removed as it's unmaintained upstream"; # Added 2021-10-29
  inherit (libsForQt5.mauiPackages) vvave; # added 2022-05-17

  ### W ###

  wavesurfer = throw "wavesurfer has been removed: depended on snack which has been removed"; # Added 2022-04-21
  webbrowser = throw "webbrowser was removed because it's unmaintained upstream and was marked as broken in nixpkgs for over a year"; # Added 2022-03-21
  webkit = throw "'webkit' has been renamed to/replaced by 'webkitgtk'"; # Converted to throw 2022-02-22
  weechat-matrix-bridge = throw "'weechat-matrix-bridge' has been renamed to/replaced by 'weechatScripts.weechat-matrix-bridge'"; # Converted to throw 2022-02-22
  weighttp = throw "weighttp has been removed: abandoned by upstream"; # Added 2022-04-20
  whirlpool-gui = throw "whirlpool-gui has been removed as it depended on an insecure version of Electron"; # added 2022-02-08
  wicd = throw "wicd has been removed as it is abandoned"; # Added 2021-09-11
  wineFull = throw "'wineFull' has been renamed to/replaced by 'winePackages.full'"; # Converted to throw 2022-02-22
  wineMinimal = throw "'wineMinimal' has been renamed to/replaced by 'winePackages.minimal'"; # Converted to throw 2022-02-22
  wineStable = throw "'wineStable' has been renamed to/replaced by 'winePackages.stable'"; # Converted to throw 2022-02-22
  wineStaging = throw "'wineStaging' has been renamed to/replaced by 'wine-staging'"; # Converted to throw 2022-02-22
  wineUnstable = throw "'wineUnstable' has been renamed to/replaced by 'winePackages.unstable'"; # Converted to throw 2022-02-22
  wineWayland = wine-wayland; # Added 2022-01-03
  winpdb = throw "winpdb has been removed: abandoned by upstream"; # Added 2022-04-22
  winusb = throw "'winusb' has been renamed to/replaced by 'woeusb'"; # Converted to throw 2022-02-22
  wireguard = throw "'wireguard' has been renamed to/replaced by 'wireguard-tools'"; # Converted to throw 2022-02-22
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name
  wmii_hg = wmii; # Added 2022-04-25
  ws = throw "ws has been dropped due to the lack of maintenance from upstream since 2018"; # Added 2022-06-03
  wxmupen64plus = throw "wxmupen64plus was removed because the upstream disappeared"; # Added 2022-01-31
  wxcam = throw "'wxcam' has seen no updates in ten years, crashes (SIGABRT) on startup and depends on deprecated wxGTK28/GNOME2/GTK2, use 'gnome.cheese'"; # Added 2022-06-15

  ### X ###

  x11 = throw "'x11' has been renamed to/replaced by 'xlibsWrapper'"; # Converted to throw 2022-02-22
  xbmc = throw "'xbmc' has been renamed to/replaced by 'kodi'"; # Converted to throw 2022-02-22
  xbmc-retroarch-advanced-launchers = kodi-retroarch-advanced-launchers; # Added 2021-11-19
  xbmcPlain = throw "'xbmcPlain' has been renamed to/replaced by 'kodiPlain'"; # Converted to throw 2022-02-22
  xbmcPlugins = throw "'xbmcPlugins' has been renamed to/replaced by 'kodiPackages'"; # Converted to throw 2022-02-22
  xdg_utils = throw "'xdg_utils' has been renamed to/replaced by 'xdg-utils'"; # Converted to throw 2022-09-24
  xfce4-14 = xfce;
  xfceUnstable = throw "'xfceUnstable' has been renamed to/replaced by 'xfce4-14'"; # Converted to throw 2022-09-24
  xineLib = throw "'xineLib' has been renamed to/replaced by 'xine-lib'"; # Converted to throw 2022-09-24
  xineUI = throw "'xineUI' has been renamed to/replaced by 'xine-ui'"; # Converted to throw 2022-09-24
  xmonad_log_applet_gnome3 = throw "'xmonad_log_applet_gnome3' has been renamed to/replaced by 'xmonad_log_applet'"; # Converted to throw 2022-02-22
  xmpp-client = throw "xmpp-client has been dropped due to the lack of maintanence from upstream since 2017"; # Added 2022-06-02
  xp-pen-g430 = throw "xp-pen-g430 has been renamed to xp-pen-g430-driver"; # Converted to throw 2022-06-23
  xpf = throw "xpf has been removed: abandoned by upstream"; # Added 2022-04-26
  xf86_video_nouveau = throw "'xf86_video_nouveau' has been renamed to/replaced by 'xorg.xf86videonouveau'"; # Converted to throw 2022-02-22
  xlibs = throw "'xlibs' has been renamed to/replaced by 'xorg'"; # Converted to throw 2022-02-22
  xow = throw (
    "Upstream has ended support for 'xow' and the package has been removed" +
    "from nixpkgs. Users are urged to switch to 'xone'."
  ); # Added 2022-08-02
  xpraGtk3 = throw "'xpraGtk3' has been renamed to/replaced by 'xpra'"; # Converted to throw 2022-02-22
  xv = throw "'xv' has been renamed to/replaced by 'xxv'"; # Converted to throw 2022-09-24
  xvfb_run = throw "'xvfb_run' has been renamed to/replaced by 'xvfb-run'"; # Converted to throw 2022-09-24

  ### Y ###

  yacc = throw "'yacc' has been renamed to/replaced by 'bison'"; # Converted to throw 2022-09-24
  yafaray-core = libyafaray; # Added 2022-09-23
  yarssr = throw "yarssr has been removed as part of the python2 deprecation"; # Added 2022-01-15
  youtubeDL = throw "'youtubeDL' has been renamed to/replaced by 'youtube-dl'"; # Converted to throw 2022-02-22
  yuzu-ea = yuzu-early-access; # Added 2022-08-18
  yuzu = throw "'yuzu' has been renamed to/replaced by 'yuzu-mainline'"; # Converted to throw 2022-09-24

  ### Z ###

  zdfmediathk = throw "'zdfmediathk' has been renamed to/replaced by 'mediathekview'"; # Converted to throw 2022-02-22
  zimwriterfs = throw "zimwriterfs is now part of zim-tools"; # Added 2022-06-10.

  ocamlPackages_4_00_1 = throw "'ocamlPackages_4_00_1' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_00_1'"; # Converted to throw 2022-02-22
  ocamlPackages_4_01_0 = throw "'ocamlPackages_4_01_0' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_01_0'"; # Converted to throw 2022-02-22
  ocamlPackages_4_02 = throw "'ocamlPackages_4_02' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_02'"; # Converted to throw 2022-02-22
  ocamlPackages_4_03 = throw "'ocamlPackages_4_03' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_03'"; # Converted to throw 2022-02-22
  ocamlPackages_latest = throw "'ocamlPackages_latest' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_latest'"; # Converted to throw 2022-02-22

  ocaml_4_00_1 = throw "'ocamlPackages_4_00_1.ocaml' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_00_1.ocaml'"; # Converted to throw 2022-02-22
  ocaml_4_01_0 = throw "'ocamlPackages_4_01_0.ocaml' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_01_0.ocaml'"; # Converted to throw 2022-02-22
  ocaml_4_02 = throw "'ocamlPackages_4_02.ocaml' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_02.ocaml'"; # Converted to throw 2022-02-22
  ocaml_4_03 = throw "'ocamlPackages_4_03.ocaml' has been renamed to/replaced by 'ocaml-ng.ocamlPackages_4_03.ocaml'"; # Converted to throw 2022-02-22

  ocamlformat_0_11_0 = throw "ocamlformat_0_11_0 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_12 = throw "ocamlformat_0_12 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_13_0 = throw "ocamlformat_0_13_0 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_14_0 = throw "ocamlformat_0_14_0 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_14_1 = throw "ocamlformat_0_14_1 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_14_2 = throw "ocamlformat_0_14_2 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_14_3 = throw "ocamlformat_0_14_3 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_15_0 = throw "ocamlformat_0_15_0 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_15_1 = throw "ocamlformat_0_15_1 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_16_0 = throw "ocamlformat_0_16_0 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_17_0 = throw "ocamlformat_0_17_0 has been removed in favor of newer versions"; # Added 2022-06-01
  ocamlformat_0_18_0 = throw "ocamlformat_0_18_0 has been removed in favor of newer versions"; # Added 2022-06-01

  zeroc_ice = throw "'zeroc_ice' has been renamed to 'zeroc-ice'"; # Converted to throw 2022-09-24

  dina-font-pcf = throw "'dina-font-pcf' has been renamed to/replaced by 'dina-font'"; # Converted to throw 2022-09-24
  gnatsd = throw "'gnatsd' has been renamed to/replaced by 'nats-server'"; # Converted to throw 2022-09-24

  posix_man_pages = throw "'posix_man_pages' has been renamed to/replaced by 'man-pages-posix'"; # Converted to throw 2022-09-24
  torchat = throw "torchat was removed because it was broken and requires Python 2"; # added 2022-06-05
  ttyrec = throw "'ttyrec' has been renamed to/replaced by 'ovh-ttyrec'"; # Converted to throw 2022-09-24
  zplugin = throw "'zplugin' has been renamed to/replaced by 'zinit'"; # Converted to throw 2022-09-24
  zyn-fusion = zynaddsubfx; # Added 2022-08-05

  inherit (stdenv.hostPlatform) system; # Added 2021-10-22

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_git = recurseIntoAttrs (callPackage ../development/compilers/llvm/git {
    inherit (stdenvAdapters) overrideCC;
    buildLlvmTools = buildPackages.llvmPackages_git.tools;
    targetLlvmLibraries = targetPackages.llvmPackages_git.libraries;
  });

  # Added 2022-01-28
  zeroc-ice-36 = throw "Unmaintained, doesn't build w/glibc-2.34";

  /* If these are in the scope of all-packages.nix, they cause collisions
  between mixed versions of qt. See:
  https://github.com/NixOS/nixpkgs/pull/101369 */

  inherit (plasma5Packages)
    akonadi akregator ark bluedevil bomber bovo breeze-grub breeze-gtk
    breeze-icons breeze-plymouth breeze-qt5 discover dolphin dragon elisa falkon
    ffmpegthumbs filelight granatier gwenview k3b kactivitymanagerd kaddressbook
    kalendar kalzium kapman kapptemplate kate katomic kblackbox kblocks kbounce
    kcachegrind kcalc kcharselect kcolorchooser kde-cli-tools kde-gtk-config
    kdenlive kdeplasma-addons kdevelop-pg-qt kdevelop-unwrapped kdev-php
    kdev-python kdevelop kdf kdialog kdiamond keditbookmarks kfind kfloppy
    kgamma5 kget kgpg khelpcenter kig kigo killbots kinfocenter kitinerary
    kleopatra klettres klines kmag kmail kmenuedit kmines kmix kmplot
    knavalbattle knetwalk knights kollision kolourpaint kompare konsole kontact
    konversation korganizer kpkpass krdc kreversi krfb kscreen kscreenlocker
    kshisen ksquares ksshaskpass ksystemlog kteatime ktimer ktorrent ktouch
    kturtle kwallet-pam kwalletmanager kwave kwayland-integration kwin kwrited
    marble milou minuet okular oxygen oxygen-icons5 picmi
    plasma-browser-integration plasma-desktop plasma-integration plasma-nano
    plasma-nm plasma-pa plasma-mobile plasma-systemmonitor plasma-thunderbolt
    plasma-vault plasma-workspace plasma-workspace-wallpapers polkit-kde-agent
    powerdevil qqc2-breeze-style sddm-kcm skanlite skanpage spectacle
    systemsettings xdg-desktop-portal-kde yakuake zanshin
  ;

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

})
