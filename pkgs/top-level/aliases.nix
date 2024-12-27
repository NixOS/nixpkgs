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
  removeRecurseForDerivations = alias:
    if alias.recurseForDerivations or false
    then lib.removeAttrs alias [ "recurseForDerivations" ]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias:
    if lib.isDerivation alias then
      lib.dontDistribute alias
    else alias;

  transmission3Warning = { prefix ? "", suffix ? "" }: let
    p = "${prefix}transmission${suffix}";
    p3 = "${prefix}transmission_3${suffix}";
    p4 = "${prefix}transmission_4${suffix}";
  in "${p} has been renamed to ${p3} since ${p4} is also available. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)";

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

mapAliases {
  # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.
  forceSystem = system: _:
    (import self.path { localSystem = { inherit system; }; });

  ### _ ###
  _1password = lib.warnOnInstantiate "_1password has been renamed to _1password-cli to better follow upstream name usage" _1password-cli; # Added 2024-10-24
  "7z2hashcat" = throw "'7z2hashcat' has been renamed to '_7z2hashcat' as the former isn't a valid variable name."; # Added 2024-11-27

  ### A ###

  AusweisApp2 = ausweisapp; # Added 2023-11-08
  a4term = a4; # Added 2023-10-06
  acorn = throw "acorn has been removed as the upstream project was archived"; # Added 2024-04-27
  acousticbrainz-client = throw "acousticbrainz-client has been removed since the AcousticBrainz project has been shut down"; # Added 2024-06-04
  adtool = throw "'adtool' has been removed, as it was broken and unmaintained";
  adom = throw "'adom' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  adoptopenjdk-bin = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin`"; # Added 2024-05-09
  adoptopenjdk-bin-17-packages-darwin = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-bin-17-packages-linux = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-11`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `temurin-bin-17`."; # Added 2024-05-09
  adoptopenjdk-hotspot-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-bin-8`."; # Added 2024-05-09
  adoptopenjdk-jre-bin = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-jre-bin`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-jre-bin-11`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `temurin-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `temurin-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-hotspot-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `temurin-jre-bin-8`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-jre-bin-11`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `semeru-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `semeru-jre-bin-17`."; # Added 2024-05-09
  adoptopenjdk-jre-openj9-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-jre-bin-8`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-11 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-bin-11`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-15 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 15 is also EOL. Consider using `semeru-bin-17`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-16 = throw "adoptopenjdk has been removed as the upstream project is deprecated. JDK 16 is also EOL. Consider using `semeru-bin-17`."; # Added 2024-05-09
  adoptopenjdk-openj9-bin-8 = throw "adoptopenjdk has been removed as the upstream project is deprecated. Consider using `semeru-bin-8`."; # Added 2024-05-09
  addOpenGLRunpath = throw "addOpenGLRunpath has been removed. Use addDriverRunpath instead."; # Converted to throw 2024-11-17
  aeon = throw "aeon has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-07-15
  afl = throw "afl has been removed as the upstream project was archived. Consider using 'aflplusplus'"; # Added 2024-04-21
  agda-pkg = throw "agda-pkg has been removed due to being unmaintained"; # Added 2024-09-10"
  alsaLib = throw "'alsaLib' has been renamed to/replaced by 'alsa-lib'"; # Converted to throw 2024-10-17
  alsaOss = throw "'alsaOss' has been renamed to/replaced by 'alsa-oss'"; # Converted to throw 2024-10-17
  alsaPluginWrapper = throw "'alsaPluginWrapper' has been renamed to/replaced by 'alsa-plugins-wrapper'"; # Converted to throw 2024-10-17
  alsaPlugins = throw "'alsaPlugins' has been renamed to/replaced by 'alsa-plugins'"; # Converted to throw 2024-10-17
  alsaTools = throw "'alsaTools' has been renamed to/replaced by 'alsa-tools'"; # Converted to throw 2024-10-17
  alsaUtils = throw "'alsaUtils' has been renamed to/replaced by 'alsa-utils'"; # Converted to throw 2024-10-17
  angelfish = throw "'angelfish' has been renamed to/replaced by 'libsForQt5.kdeGear.angelfish'"; # Converted to throw 2024-10-17
  ansible_2_14 = throw "Ansible 2.14 goes end of life in 2024/05 and can't be supported throughout the 24.05 release cycle"; # Added 2024-04-11
  ansible_2_15 = throw "Ansible 2.15 goes end of life in 2024/11 and can't be supported throughout the 24.11 release cycle"; # Added 2024-11-08
  antennas = throw "antennas has been removed as it only works with tvheadend, which nobody was willing to maintain and was stuck on an unmaintained version that required FFmpeg 4; please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version"; # Added 2024-08-21
  androidndkPkgs_23b = lib.warnOnInstantiate "The package set `androidndkPkgs_23b` has been renamed to `androidndkPkgs_23`." androidndkPkgs_23; # Added 2024-07-21
  ankisyncd = throw "ankisyncd is dead, use anki-sync-server instead"; # Added 2024-08-10
  ao = libfive; # Added 2024-10-11
  apacheKafka_3_5 = throw "apacheKafka_2_8 through _3_5 have been removed from nixpkgs as outdated"; # Added 2024-06-13
  antimicroX = throw "'antimicroX' has been renamed to/replaced by 'antimicrox'"; # Converted to throw 2024-10-17
  apacheAnt = ant; # Added 2024-11-28
  apple-sdk_10_12 = throw "apple-sdk_10_12 was removed as Nixpkgs no longer supports macOS 10.12; see the 25.05 release notes"; # Added 2024-10-27
  apple-sdk_10_13 = throw "apple-sdk_10_13 was removed as Nixpkgs no longer supports macOS 10.13; see the 25.05 release notes"; # Added 2024-10-27
  apple-sdk_10_14 = throw "apple-sdk_10_14 was removed as Nixpkgs no longer supprots macOS 10.14; see the 25.05 release notes"; # Added 2024-10-27
  apple-sdk_10_15 = throw "apple-sdk_10_15 was removed as Nixpkgs no longer supports macOS 10.15; see the 25.05 release notes"; # Added 2024-10-27
  appthreat-depscan = dep-scan; # Added 2024-04-10
  arcanist = throw "arcanist was removed as phabricator is not supported and does not accept fixes"; # Added 2024-06-07
  aria = aria2; # Added 2024-03-26
  armcord = throw "ArmCord was renamed to legcord by the upstream developers. Action is required to migrate configurations between the two applications. Please see this PR for more details: https://github.com/NixOS/nixpkgs/pull/347971"; # Added 2024-10-11
  aseprite-unfree = aseprite; # Added 2023-08-26
  atlassian-bamboo = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  atlassian-confluence = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  atlassian-crowd = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  atlassian-jira = throw "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"; # Added 2024-11-02
  audaciousQt5 = throw "'audaciousQt5' has been removed, since audacious is built with Qt 6 now"; # Added 2024-07-06
  auditBlasHook = throw "'auditBlasHook' has been removed since it never worked"; # Added 2024-04-02
  aumix = throw "'aumix' has been removed due to lack of maintenance upstream. Consider using 'pamixer' for CLI or 'pavucontrol' for GUI"; # Added 2024-09-14
  authy = throw "'authy' has been removed since it reached end of life"; # Added 2024-04-19
  avldrums-lv2 = throw "'avldrums-lv2' has been renamed to/replaced by 'x42-avldrums'"; # Converted to throw 2024-10-17
  avrlibcCross = avrlibc; # Added 2024-09-06
  awesome-4-0 = awesome; # Added 2022-05-05
  aws-env = throw "aws-env has been removed as the upstream project was unmaintained"; # Added 2024-06-11
  aws-google-auth = throw "aws-google-auth has been removed as the upstream project was unmaintained"; # Added 2024-07-31

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  baget = throw "'baget' has been removed due to being unmaintained";
  bashInteractive_5 = throw "'bashInteractive_5' has been renamed to/replaced by 'bashInteractive'"; # Converted to throw 2024-10-17
  bash_5 = throw "'bash_5' has been renamed to/replaced by 'bash'"; # Converted to throw 2024-10-17
  BeatSaberModManager = beatsabermodmanager; # Added 2024-06-12
  betterbird = throw "betterbird has been removed as there were insufficient maintainer resources to keep up with security updates"; # Added 2024-10-25
  betterbird-unwrapped = throw "betterbird has been removed as there were insufficient maintainer resources to keep up with security updates"; # Added 2024-10-25
  bibata-extra-cursors = throw "bibata-cursors has been removed as it was broken"; # Added 2024-07-15
  bitcoin-unlimited = throw "bitcoin-unlimited has been removed as it was broken and unmaintained"; # Added 2024-07-15
  bitcoind-unlimited = throw "bitcoind-unlimited has been removed as it was broken and unmaintained"; # Added 2024-07-15
  bird2 = bird; # Added 2022-02-21
  bisq-desktop = throw "bisq-desktop has been removed because OpenJFX 11 was removed"; # Added 2024-11-17
  bitwarden = bitwarden-desktop; # Added 2024-02-25
  blender-with-packages = args:
    lib.warnOnInstantiate "blender-with-packages is deprecated in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"
      (blender.withPackages (_: args.packages)).overrideAttrs
      (lib.optionalAttrs (args ? name) { pname = "blender-" + args.name; }); # Added 2023-10-30
  bless = throw "'bless' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'imhex' or 'ghex' instead"; # Added 2024-09-15
  blockbench-electron = blockbench; # Added 2024-03-16
  bloom = throw "'bloom' has been removed because it was unmaintained upstream."; # Added 2024-11-02
  bmap-tools = bmaptool; # Added 2024-08-05
  boost175 = throw "Boost 1.75 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2024-11-24
  boost184 = throw "Boost 1.84 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2024-11-24
  boost185 = throw "Boost 1.85 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2024-11-24
  boost_process = throw "boost_process has been removed as it is included in regular boost"; # Added 2024-05-01
  bpb = throw "bpb has been removed as it is unmaintained and not compatible with recent Rust versions"; # Added 2024-04-30
  bpftool = throw "'bpftool' has been renamed to/replaced by 'bpftools'"; # Converted to throw 2024-10-17
  brasero-original = lib.warnOnInstantiate "Use 'brasero-unwrapped' instead of 'brasero-original'" brasero-unwrapped; # Added 2024-09-29
  bs-platform = throw "'bs-platform' was removed as it was broken, development ended and 'melange' has superseded it"; # Added 2024-07-29
  buf-language-server = throw "'buf-language-server' was removed as its development has moved to the 'buf' package"; # Added 2024-11-15

  budgie = throw "The `budgie` scope has been removed and all packages moved to the top-level"; # Added 2024-07-14
  budgiePlugins = throw "The `budgiePlugins` scope has been removed and all packages moved to the top-level"; # Added 2024-07-14
  buildGoPackage = throw "`buildGoPackage` has been deprecated and removed, see the Go section in the nixpkgs manual for details"; # Added 2024-11-18

  inherit (libsForQt5.mauiPackages) buho; # added 2022-05-17
  butler = throw "butler was removed because it was broken and abandoned upstream"; # added 2024-06-18
  bwidget = tclPackages.bwidget; # Added 2024-10-02
  # Shorter names; keep the longer name for back-compat. Added 2023-04-11. Warning added on 2024-12-16
  buildFHSUserEnv = lib.warnOnInstantiate "'buildFHSUserEnv' as been renamed to 'buildFHSEnv' and will be removed in 25.11" buildFHSEnv;
  buildFHSUserEnvChroot = lib.warnOnInstantiate "'buildFHSUserEnvChroot' has been renamed to 'buildFHSEnvChroot' and will be removed in 25.11" buildFHSEnvChroot;
  buildFHSUserEnvBubblewrap = lib.warnOnInstantiate "'buildFHSUserEnvBubblewrap' has been renamed to 'buildFHSEnvBubblewrap' and will be removed in 25.11" buildFHSEnvBubblewrap;

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = vaultwarden;
  bitwarden_rs-mysql = vaultwarden-mysql;
  bitwarden_rs-postgresql = vaultwarden-postgresql;
  bitwarden_rs-sqlite = vaultwarden-sqlite;
  bitwarden_rs-vault = vaultwarden-vault;



  ### C ###

  caffeWithCuda = throw "caffeWithCuda has been removed, as it was broken and required CUDA 10"; # Added 2024-11-20
  calculix = calculix-ccx; # Added 2024-12-18
  calligra = kdePackages.calligra; # Added 2024-09-27
  callPackage_i686 = pkgsi686Linux.callPackage;
  cask = emacs.pkgs.cask; # Added 2022-11-12
  canonicalize-jars-hook = stripJavaArchivesHook; # Added 2024-03-17
  cargo-deps = throw "cargo-deps has been removed as the repository is deleted"; # Added 2024-04-09
  cargo-espflash = espflash;
  cawbird = throw "cawbird has been abandoned upstream and is broken anyways due to Twitter closing its API";
  certmgr-selfsigned = certmgr; # Added 2023-11-30
  challenger = taler-challenger; # Added 2024-09-04
  check_smartmon = nagiosPlugins.check_smartmon; # Added 2024-05-03
  check_systemd = nagiosPlugins.check_systemd; # Added 2024-05-03
  check_zfs = nagiosPlugins.check_zfs; # Added 2024-05-03
  check-esxi-hardware = nagiosPlugins.check_esxi_hardware; # Added 2024-05-03
  check-mssql-health = nagiosPlugins.check_mssql_health; # Added 2024-05-03
  check-nwc-health = nagiosPlugins.check_nwc_health; # Added 2024-05-03
  check-openvpn = nagiosPlugins.check_openvpn; # Added 2024-05-03
  check-ups-health = nagiosPlugins.check_ups_health; # Added 2024-05-03
  check-uptime = nagiosPlugins.check_uptime; # Added 2024-05-03
  check-wmiplus = nagiosPlugins.check_wmi_plus; # Added 2024-05-03
  checkSSLCert = nagiosPlugins.check_ssl_cert; # Added 2024-05-03
  chiaki4deck = chiaki-ng; # Added 2024-08-04
  chocolateDoom = chocolate-doom; # Added 2023-05-01
  ChowCentaur = chow-centaur; # Added 2024-06-12
  ChowPhaser = chow-phaser; # Added 2024-06-12
  ChowKick = chow-kick; # Added 2024-06-12
  CHOWTapeModel = chow-tape-model; # Added 2024-06-12
  chrome-gnome-shell = gnome-browser-connector; # Added 2022-07-27
  cinnamon = throw "The cinnamon scope has been removed and all packages have been moved to the top-level"; # Added 2024-11-25
  cloog = throw "cloog has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  cloog_0_18_0 = throw "cloog_0_18_0 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  cloogppl = throw "cloogppl has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  clang-sierraHack = throw "clang-sierraHack has been removed because it solves a problem that no longer seems to exist. Hey, what were you even doing with that thing anyway?"; # Added 2024-10-05
  clang-sierraHack-stdenv = clang-sierraHack; # Added 2024-10-05
  inherit (libsForQt5.mauiPackages) clip; # added 2022-05-17
  clwrapperFunction = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  CoinMP = coinmp; # Added 2024-06-12
  collada-dom = opencollada; # added 2024-02-21
  colorpicker = throw "'colorpicker' has been removed due to lack of maintenance upstream. Consider using 'xcolor', 'gcolor3', 'eyedropper' or 'gpick' instead"; # Added 2024-10-19
  coriander = throw "'coriander' has been removed because it depends on GNOME 2 libraries"; # Added 2024-06-27
  corretto19 = throw "Corretto 19 was removed as it has reached its end of life"; # Added 2024-08-01
  cosmic-tasks = tasks; # Added 2024-07-04
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  crispyDoom = crispy-doom; # Added 2023-05-01
  crossLibcStdenv = stdenvNoLibc; # Added 2024-09-06
  clash-geoip = throw "'clash-geoip' has been removed. Consider using 'dbip-country-lite' instead."; # added 2024-10-19
  clash-verge = throw "'clash-verge' has been removed, as it was broken and unmaintained. Consider using 'clash-verge-rev' or 'clash-nyanpasu' instead"; # Added 2024-09-17
  clasp = clingo; # added 2022-12-22
  claws-mail-gtk3 = throw "'claws-mail-gtk3' has been renamed to/replaced by 'claws-mail'"; # Converted to throw 2024-10-17
  cockroachdb-bin = cockroachdb; # 2024-03-15
  codimd = throw "'codimd' has been renamed to/replaced by 'hedgedoc'"; # Converted to throw 2024-10-17
  inherit (libsForQt5.mauiPackages) communicator; # added 2022-05-17
  concurrencykit = throw "'concurrencykit' has been renamed to/replaced by 'libck'"; # Converted to throw 2024-10-17
  containerpilot = throw "'containerpilot' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-06-09
  crack_attack = throw "'crack_attack' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  crackmapexec = throw "'crackmapexec' has been removed as it was unmaintained. Use 'netexec' instead"; # 2024-08-11
  critcl = tclPackages.critcl; # Added 2024-10-02
  cudaPackages_10_0 = throw "CUDA 10.0 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cudaPackages_10_1 = throw "CUDA 10.1 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cudaPackages_10_2 = throw "CUDA 10.2 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cudaPackages_10 = throw "CUDA 10 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2024-11-20
  cups-kyodialog3 = cups-kyodialog; # Added 2022-11-12
  cvs_fast_export = throw "'cvs_fast_export' has been renamed to/replaced by 'cvs-fast-export'"; # Converted to throw 2024-10-17

  # these are for convenience, not for backward compat and shouldn't expire
  clang9Stdenv = throw "clang9Stdenv has been removed from nixpkgs"; # Added 2024-04-08
  clang12Stdenv = lowPrio llvmPackages_12.stdenv;
  clang13Stdenv = lowPrio llvmPackages_13.stdenv;
  clang14Stdenv = lowPrio llvmPackages_14.stdenv;
  clang15Stdenv = lowPrio llvmPackages_15.stdenv;
  clang16Stdenv = lowPrio llvmPackages_16.stdenv;
  clang17Stdenv = lowPrio llvmPackages_17.stdenv;
  clang18Stdenv = lowPrio llvmPackages_18.stdenv;
  clang19Stdenv = lowPrio llvmPackages_19.stdenv;

  clang-tools_9 = throw "clang-tools_9 has been removed from nixpkgs"; # Added 2024-04-08
  clang_9 = throw "clang_9 has been removed from nixpkgs"; # Added 2024-04-08

  clang-tools_12 = llvmPackages_12.clang-tools; # Added 2024-04-22
  clang-tools_13 = llvmPackages_13.clang-tools; # Added 2024-04-22
  clang-tools_14 = llvmPackages_14.clang-tools; # Added 2024-04-22
  clang-tools_15 = llvmPackages_15.clang-tools; # Added 2024-04-22
  clang-tools_16 = llvmPackages_16.clang-tools; # Added 2024-04-22
  clang-tools_17 = llvmPackages_17.clang-tools; # Added 2024-04-22
  clang-tools_18 = llvmPackages_18.clang-tools; # Added 2024-04-22
  clang-tools_19 = llvmPackages_19.clang-tools; # Added 2024-08-21

  cq-editor = throw "cq-editor has been removed, as it use a dependency that was disabled since python 3.8 and was last updated in 2021"; # Added 2024-05-13

  ### D ###

  dart_stable = throw "'dart_stable' has been renamed to/replaced by 'dart'"; # Converted to throw 2024-10-17
  dart-sass-embedded = throw "dart-sass-embedded has been removed from nixpkgs, as is now included in Dart Sass itself.";
  dat = nodePackages.dat;
  dbeaver = throw "'dbeaver' has been renamed to/replaced by 'dbeaver-bin'"; # Added 2024-05-16
  dbus-map = throw "'dbus-map' has been dropped as it is unmaintained"; # Added 2024-11-01
  deadpixi-sam = deadpixi-sam-unstable;

  debugedit-unstable = throw "'debugedit-unstable' has been renamed to/replaced by 'debugedit'"; # Converted to throw 2024-10-17
  deltachat-electron = throw "'deltachat-electron' has been renamed to/replaced by 'deltachat-desktop'"; # Converted to throw 2024-10-17

  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  dgsh = throw "'dgsh' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  dibbler = throw "dibbler was removed because it is not maintained anymore"; # Added 2024-05-14
  dillong = throw "'dillong' has been removed, as upstream is abandoned since 2021-12-13. Use either 'dillo' or 'dillo-plus'. The latter integrates features from dillong."; # Added 2024-10-07
  dnnl = throw "'dnnl' has been renamed to/replaced by 'oneDNN'"; # Converted to throw 2024-10-17
  dnscrypt-wrapper = throw "dnscrypt-wrapper was removed because it has been effectively unmaintained since 2018. Use DNSCcrypt support in dnsdist instead"; # Added 2024-09-14
  docear = throw "Docear was removed because it was unmaintained upstream. JabRef, Zotero, or Mendeley are potential replacements."; # Added 2024-11-02
  docker-compose_1 = throw "'docker-compose_1' has been removed because it has been unmaintained since May 2021. Use docker-compose instead."; # Added 2024-07-29
  docker-distribution = distribution; # Added 2023-12-26
  dolphin-emu-beta = dolphin-emu; # Added 2023-02-11
  dolphinEmu = throw "'dolphinEmu' has been renamed to/replaced by 'dolphin-emu'"; # Converted to throw 2024-10-17
  dolphinEmuMaster = throw "'dolphinEmuMaster' has been renamed to/replaced by 'dolphin-emu-beta'"; # Converted to throw 2024-10-17
  dotty = scala_3; # Added 2023-08-20
  dotnet-netcore = throw "'dotnet-netcore' has been renamed to/replaced by 'dotnet-runtime'"; # Converted to throw 2024-10-17
  dotnet-sdk_2 = throw "'dotnet-sdk_2' has been renamed to/replaced by 'dotnetCorePackages.sdk_2_1'"; # Converted to throw 2024-10-17
  dotnet-sdk_3 = throw "'dotnet-sdk_3' has been renamed to/replaced by 'dotnetCorePackages.sdk_3_1'"; # Converted to throw 2024-10-17
  dotnet-sdk_5 = throw "'dotnet-sdk_5' has been renamed to/replaced by 'dotnetCorePackages.sdk_5_0'"; # Converted to throw 2024-10-17
  drush = throw "drush as a standalone package has been removed because it's no longer supported as a standalone tool";
  dtv-scan-tables_linuxtv = dtv-scan-tables; # Added 2023-03-03
  dtv-scan-tables_tvheadend = dtv-scan-tables; # Added 2023-03-03
  du-dust = dust; # Added 2024-01-19
  dylibbundler = throw "'dylibbundler' has been renamed to/replaced by 'macdylibbundler'"; # Converted to throw 2024-10-17

  ### E ###

  EBTKS = ebtks; # Added 2024-01-21
  eask = eask-cli; # Added 2024-09-05
  eboard = throw "'eboard' has been removed due to lack of maintenance upstream. Consider using 'kdePackages.knights' instead"; # Added 2024-10-19
  ec2_ami_tools = throw "'ec2_ami_tools' has been renamed to/replaced by 'ec2-ami-tools'"; # Converted to throw 2024-10-17
  ec2_api_tools = throw "'ec2_api_tools' has been renamed to/replaced by 'ec2-api-tools'"; # Converted to throw 2024-10-17
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01

  edUnstable = throw "edUnstable was removed; use ed instead"; # Added 2024-07-01
  elasticsearch7Plugins = elasticsearchPlugins;

  element-desktop-wayland = throw "element-desktop-wayland has been removed. Consider setting NIXOS_OZONE_WL=1 via 'environment.sessionVariables' instead"; # Added 2024-12-17


  elixir_ls = elixir-ls; # Added 2023-03-20

  # Emacs
  emacs28-gtk2 = throw "emacs28-gtk2 was removed because GTK2 is EOL; migrate to emacs28{,-gtk3,-nox} or to more recent versions of Emacs."; # Added 2024-09-20
  emacs28NativeComp = emacs28; # Added 2022-06-08
  emacs28Packages = throw "'emacs28Packages' has been renamed to/replaced by 'emacs28.pkgs'"; # Converted to throw 2024-10-17
  emacs28WithPackages = throw "'emacs28WithPackages' has been renamed to/replaced by 'emacs28.pkgs.withPackages'"; # Converted to throw 2024-10-17
  emacsMacport = emacs-macport; # Added 2023-08-10
  emacsNativeComp = emacs28NativeComp; # Added 2022-06-08
  emacsWithPackages = throw "'emacsWithPackages' has been renamed to/replaced by 'emacs.pkgs.withPackages'"; # Converted to throw 2024-10-17

  EmptyEpsilon = empty-epsilon; # Added 2024-07-14
  enyo-doom = enyo-launcher; # Added 2022-09-09
  epdfview = throw "'epdfview' has been removed due to lack of maintenance upstream. Consider using 'qpdfview' instead"; # Added 2024-10-19
  epoxy = throw "'epoxy' has been renamed to/replaced by 'libepoxy'"; # Converted to throw 2024-10-17

  erlang_24 = throw "erlang_24 has been removed as it is unmaintained upstream";
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

  ethabi = throw "ethabi has been removed due to lack of maintainence upstream and no updates in Nixpkgs"; # Added 2024-07-16
  eww-wayland = lib.warnOnInstantiate "eww now can build for X11 and wayland simultaneously, so `eww-wayland` is deprecated, use the normal `eww` package instead." eww;

  ### F ###

  fahcontrol = throw "fahcontrol has been removed because the download is no longer available"; # added 2024-09-24
  fahviewer = throw "fahviewer has been removed because the download is no longer available"; # added 2024-09-24
  fam = throw "'fam' (aliased to 'gamin') has been removed as it is unmaintained upstream"; # Added 2024-04-19
  faustStk = faustPhysicalModeling; # Added 2023-05-16
  fastnlo = throw "'fastnlo' has been renamed to/replaced by 'fastnlo-toolkit'"; # Converted to throw 2024-10-17
  fastnlo_toolkit = fastnlo-toolkit; # Added 2024-01-03
  fcitx5-catppuccin = catppuccin-fcitx5; # Added 2024-06-19
  inherit (luaPackages) fennel; # Added 2022-09-24
  ferdi = throw "'ferdi' has been removed, upstream does not exist anymore and the package is insecure"; # Added 2024-08-22
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve
  ffmpeg_5 = throw "ffmpeg_5 has been removed, please use another version"; # Added 2024-07-12
  ffmpeg_5-headless = throw "ffmpeg_5-headless has been removed, please use another version"; # Added 2024-07-12
  ffmpeg_5-full = throw "ffmpeg_5-full has been removed, please use another version"; # Added 2024-07-12
  FIL-plugins = fil-plugins; # Added 2024-06-12
  fileschanged = throw "'fileschanged' has been removed as it is unmaintained upstream"; # Added 2024-04-19
  finger_bsd = bsd-finger;
  fingerd_bsd = bsd-fingerd;
  fira-code-nerdfont = lib.warnOnInstantiate "fira-code-nerdfont is redundant. Use nerd-fonts.fira-code instead." nerd-fonts.fira-code; # Added 2024-11-10
  firefox-esr-115 = throw "The Firefox 115 ESR series has reached its end of life. Upgrade to `firefox-esr` or `firefox-esr-128` instead.";
  firefox-esr-115-unwrapped = throw "The Firefox 115 ESR series has reached its end of life. Upgrade to `firefox-esr-unwrapped` or `firefox-esr-128-unwrapped` instead.";
  firefox-wayland = firefox; # Added 2022-11-15
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  fit-trackee = fittrackee; # added 2024-09-03
  flashrom-stable = flashprog;   # Added 2024-03-01
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  flutter313 = throw "flutter313 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter316 = throw "flutter316 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter322 = throw "flutter322 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  flutter323 = throw "flutter323 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-10-05
  fluxus = throw "fluxus has been removed because it hasn't been updated in 9 years and depended on insecure Racket 7.9"; # Added 2024-12-06
  fmt_8 = throw "fmt_8 has been removed as it is obsolete and was no longer used in the tree"; # Added 2024-11-12
  foldingathome = throw "'foldingathome' has been renamed to/replaced by 'fahclient'"; # Converted to throw 2024-10-17
  forgejo-actions-runner = forgejo-runner; # Added 2024-04-04

  fractal-next = fractal; # added 2023-11-25
  framework-system-tools = framework-tool; # added 2023-12-09
  francis = kdePackages.francis; # added 2024-07-13
  frostwire = throw "frostwire was removed, as it was broken due to reproducibility issues, use `frostwire-bin` package instead."; # added 2024-05-17
  fuse2fs = if stdenv.hostPlatform.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  fuse-common = throw "fuse-common was removed, because the udev rule was early included by systemd-udevd and the config is done by NixOS module `programs.fuse`"; # added 2024-09-29
  futuresql = libsForQt5.futuresql; # added 2023-11-11
  fx_cast_bridge = fx-cast-bridge; # added 2023-07-26


  fcitx5-chinese-addons = libsForQt5.fcitx5-chinese-addons; # Added 2024-03-01
  fcitx5-configtool = libsForQt5.fcitx5-configtool; # Added 2024-03-01
  fcitx5-skk-qt = libsForQt5.fcitx5-skk-qt; # Added 2024-03-01
  fcitx5-unikey = libsForQt5.fcitx5-unikey; # Added 2024-03-01
  fcitx5-with-addons = libsForQt5.fcitx5-with-addons; # Added 2024-03-01

  ### G ###

  g4music = gapless; # Added 2024-07-26
  g4py = throw "'g4py' has been renamed to/replaced by 'python3Packages.geant4'"; # Converted to throw 2024-10-17
  gamin = throw "'gamin' has been removed as it is unmaintained upstream"; # Added 2024-04-19
  gcc48 = throw "gcc48 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-10
  gcc49 = throw "gcc49 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-11
  gcc49Stdenv = throw "gcc49Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-11
  gcc6 = throw "gcc6 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  gcc6Stdenv = throw "gcc6Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  gcc7 = throw "gcc7 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc7Stdenv = throw "gcc7Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc8 = throw "gcc8 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc8Stdenv = throw "gcc8Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gcc10StdenvCompat = if stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11" then gcc10Stdenv else stdenv; # Added 2024-03-21
  gcj = gcj6; # Added 2024-09-13
  gcj6 = throw "gcj6 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  gcolor2 = throw "'gcolor2' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'gcolor3' or 'eyedropper' instead"; # Added 2024-09-15
  geos_3_11 = throw "geos_3_11 has been removed from nixpgks. Please use a more recent 'geos' instead.";
  gfortran48 = throw "'gfortran48' has been removed from nixpkgs"; # Added 2024-09-10
  gfortran49 = throw "'gfortran49' has been removed from nixpkgs"; # Added 2024-09-11
  gfortran7 = throw "gfortran7 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  gfortran8 = throw "gfortran8 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  ghostwriter = libsForQt5.kdeGear.ghostwriter; # Added 2023-03-18
  gmp5 = throw "'gmp5' has been removed as it is unmaintained. Consider using 'gmp' instead"; # Added 2024-10-28
  gmpc = throw "'gmpc' has been removed due to lack of maintenance upstream. Consider using 'plattenalbum' instead"; # Added 2024-09-14
  gmtk = throw "'gmtk' has been removed due to lack of maintenance upstream"; # Added 2024-09-14
  gmtp = throw "'gmtp' has been removed due to lack of maintenance upstream. Consider using 'gnome-music' instead"; # Added 2024-09-14
  gnome-latex = throw "'gnome-latex' has been superseded by 'enter-tex'"; # Added 2024-09-18
  gnu-cobol = gnucobol; # Added 2024-09-17
  gogs = throw ''
    Gogs development has stalled. Also, it has several unpatched, critical vulnerabilities that
    weren't addressed within a year: https://github.com/gogs/gogs/issues/7777

    Consider migrating to forgejo or gitea.
  ''; # Added 2024-10-12
  git-backup = throw "git-backup has been removed, as it has been abandoned upstream. Consider using git-backup-go instead.";
  git-credential-1password = throw "'git-credential-1password' has been removed, as the upstream project is deleted."; # Added 2024-05-20

  gitAndTools = self // {
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  }; # Added 2021-01-14

  gkraken = throw "'gkraken' has been deprecated by upstream. Consider using the replacement 'coolercontrol' instead."; # Added 2024-11-22
  glew-egl = lib.warnOnInstantiate "'glew-egl' is now provided by 'glew' directly" glew; # Added 2024-08-11
  glfw-wayland = glfw; # Added 2024-04-19
  glfw-wayland-minecraft = glfw3-minecraft; # Added 2024-05-08
  glxinfo = mesa-demos; # Added 2024-07-04
  gmailieer = throw "'gmailieer' has been renamed to/replaced by 'lieer'"; # Converted to throw 2024-10-17
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
  gnome-dictionary = throw "'gnome-dictionary' has been removed as it has been archived upstream. Consider using 'wordbook' instead"; # Added 2024-09-14
  gnome-firmware-updater = gnome-firmware; # added 2022-04-14
  gnome-hexgl = throw "'gnome-hexgl' has been removed due to lack of maintenance upstream"; # Added 2024-09-14
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome_mplayer = throw "'gnome_mplayer' has been removed due to lack of maintenance upstream. Consider using 'celluloid' instead"; # Added 2024-09-14
  gnome-resources = resources; # added 2023-12-10

  gmock = throw "'gmock' has been renamed to/replaced by 'gtest'"; # Converted to throw 2024-10-17

  gnome3 = throw "'gnome3' has been renamed to/replaced by 'gnome'"; # Converted to throw 2024-10-17
  gnuradio3_9 = throw "gnuradio3_9 has been removed because it is not compatible with the latest volk and it had no dependent packages which justified it's distribution"; # Added 2024-07-28
  gnuradio3_9Minimal = throw "gnuradio3_9Minimal has been removed because it is not compatible with the latest volk and it had no dependent packages which justified it's distribution"; # Added 2024-07-28
  gnuradio3_9Packages = throw "gnuradio3_9Minimal has been removed because it is not compatible with the latest volk and it had no dependent packages which justified it's distribution"; # Added 2024-07-28
  gnuradio3_8 = throw "gnuradio3_8 has been removed because it was too old and incompatible with a not EOL swig"; # Added 2024-11-18
  gnuradio3_8Minimal = throw "gnuradio3_8Minimal has been removed because it was too old and incompatible with a not EOL swig"; # Added 2024-11-18
  gnuradio3_8Packages = throw "gnuradio3_8Minimal has been removed because it was too old and incompatible with a not EOL swig"; # Added 2024-11-18
  gn1924 = throw "gn1924 has been removed because it was broken and no longer used by envoy."; # Added 2024-11-03
  gobby5 = throw "'gobby5' has been renamed to/replaced by 'gobby'"; # Converted to throw 2024-10-17
  gradle_6 = throw "Gradle 6 has been removed, as it is end-of-life (https://endoflife.date/gradle) and has many vulnerabilities that are not resolved until Gradle 7."; # Added 2024-10-30
  gradle_6-unwrapped = throw "Gradle 6 has been removed, as it is end-of-life (https://endoflife.date/gradle) and has many vulnerabilities that are not resolved until Gradle 7."; # Added 2024-10-30

  #godot


  go-thumbnailer = thud; # Added 2023-09-21
  go-upower-notify = upower-notify; # Added 2024-07-21
  gpicview = throw "'gpicview' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'loupe', 'gthumb' or 'image-roll' instead"; # Added 2024-09-15
  gprbuild-boot = gnatPackages.gprbuild-boot; # Added 2024-02-25;

  gqview = throw "'gqview' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'gthumb' instead";
  graalvmCEPackages = graalvmPackages; # Added 2024-08-10
  graalvm-ce = graalvmPackages.graalvm-ce; # Added 2024-08-10
  graalvm-oracle = graalvmPackages.graalvm-oracle; # Added 2024-12-17
  grafana_reporter = grafana-reporter; # Added 2024-06-09
  grapefruit = throw "'grapefruit' was removed due to being blocked by Roblox, rendering the package useless"; # Added 2024-08-23
  graylog-3_3 = throw "graylog 3.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 3.x to latest series."; # Added 2023-10-09
  graylog-4_0 = throw "graylog 4.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 4.x to latest series."; # Added 2023-10-09
  graylog-4_3 = throw "graylog 4.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 4.x to latest series."; # Added 2023-10-09
  graylog-5_0 = throw "graylog 5.0.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.0.x to latest series."; # Added 2024-02-15
  green-pdfviewer = throw "'green-pdfviewer' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  gringo = clingo; # added 2022-11-27
  grub2_full = grub2; # Added 2022-11-18
  gtetrinet = throw "'gtetrinet' has been removed because it depends on GNOME 2 libraries"; # Added 2024-06-27
  gtk-engine-bluecurve = "'gtk-engine-bluecurve' has been removed as it has been archived upstream."; # Added 2024-12-04
  gtk2fontsel = throw "'gtk2fontsel' has been removed due to lack of maintenance upstream. GTK now has a built-in font chooser so it's no longer needed for newer apps"; # Added 2024-10-19
  gtkcord4 = dissent; # Added 2024-03-10
  gtkperf = throw "'gtkperf' has been removed due to lack of maintenance upstream"; # Added 2024-09-14
  guardian-agent = throw "'guardian-agent' has been removed, as it hasn't been maintained upstream in years and accumulated many vulnerabilities"; # Added 2024-06-09
  guile-disarchive = disarchive; # Added 2023-10-27

  ### H ###

  HentaiAtHome = hentai-at-home; # Added 2024-06-12
  hll2390dw-cups = throw "The hll2390dw-cups package was dropped since it was unmaintained."; # Added 2024-06-21
  hop-cli = throw "hop-cli has been removed as the service has been shut-down"; # Added 2024-08-13
  hpp-fcl = coal; # Added 2024-11-15
  ht-rust = throw "'ht-rust' has been renamed to/replaced by 'xh'"; # Converted to throw 2024-10-17
  hydra_unstable = hydra; # Added 2024-08-22
  hydron = throw "hydron has been removed as the project has been archived upstream since 2022 and is affected by a severe remote code execution vulnerability";


  ### I ###

  i3-gaps = i3; # Added 2023-01-03
  ib-tws = throw "ib-tws has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  ib-controller = throw "ib-controller has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  imagemagick7Big = throw "'imagemagick7Big' has been renamed to/replaced by 'imagemagickBig'"; # Converted to throw 2024-10-17
  imagemagick7 = throw "'imagemagick7' has been renamed to/replaced by 'imagemagick'"; # Converted to throw 2024-10-17
  imagemagick7_light = throw "'imagemagick7_light' has been renamed to/replaced by 'imagemagick_light'"; # Converted to throw 2024-10-17
  immersed-vr = lib.warnOnInstantiate "'immersed-vr' has been renamed to 'immersed'" immersed; # Added 2024-08-11
  inconsolata-nerdfont = lib.warnOnInstantiate "inconsolata-nerdfont is redundant. Use nerd-fonts.inconsolata instead." nerd-fonts.inconsolata; # Added 2024-11-10
  incrtcl = tclPackages.incrtcl; # Added 2024-10-02
  input-utils = throw "The input-utils package was dropped since it was unmaintained."; # Added 2024-06-21
  index-fm = libsForQt5.mauiPackages.index; # added 2022-05-17
  inotifyTools = inotify-tools;
  inter-ui = throw "'inter-ui' has been renamed to/replaced by 'inter'"; # Converted to throw 2024-10-17
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  iproute = throw "'iproute' has been renamed to/replaced by 'iproute2'"; # Converted to throw 2024-10-17
  irrlichtmt = throw "irrlichtmt has been removed because it was moved into the Minetest repo"; # Added 2024-08-12
  isl_0_11 = throw "isl_0_11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  isl_0_14 = throw "isl_0_14 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-09-13
  isl_0_17 = throw "isl_0_17 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2024-11-20
  iso-flags-png-320x420 = lib.warnOnInstantiate "iso-flags-png-320x420 has been renamed to iso-flags-png-320x240" iso-flags-png-320x240; # Added 2024-07-17
  itktcl = tclPackages.itktcl; # Added 2024-10-02

  ### J ###


  jack2Full = throw "'jack2Full' has been renamed to/replaced by 'jack2'"; # Converted to throw 2024-10-17
  jami-client-qt = jami-client; # Added 2022-11-06
  jami-client = jami; # Added 2023-02-10
  jami-daemon = jami.daemon; # Added 2023-02-10
  javacard-devkit = throw "javacard-devkit was dropped due to having a dependency on the Oracle JDK, as well as being several years out-of-date."; # Added 2024-11-01
  jd-cli = throw "jd-cli has been removed due to upstream being unmaintained since 2019. Other Java decompilers in Nixpkgs include bytecode-viewer (GUI), cfr (CLI), and procyon (CLI)."; # Added 2024-10-30
  jd-gui = throw "jd-gui has been removed due to a dependency on the dead JCenter Bintray. Other Java decompilers in Nixpkgs include bytecode-viewer (GUI), cfr (CLI), and procyon (CLI)."; # Added 2024-10-30
  jsawk = throw "'jsawk' has been removed because it is unmaintained upstream"; # Added 2028-08-07

  # Julia
  julia_16-bin = throw "'julia_16-bin' has been removed from nixpkgs as it has reached end of life"; # Added 2024-10-08

  jush = throw "jush has been removed from nixpkgs because it is unmaintained"; # Added 2024-05-28

  ### K ###

  k3s_1_26 = throw "'k3s_1_26' has been removed from nixpkgs as it has reached end of life"; # Added 2024-05-20
  k3s_1_27 = throw "'k3s_1_27' has been removed from nixpkgs as it has reached end of life on 2024-06-28"; # Added 2024-06-01
  k3s_1_28 = throw "'k3s_1_28' has been removed from nixpkgs as it has reached end of life"; # Added 2024-12-15
  # k3d was a 3d editing software k-3d - "k3d has been removed because it was broken and has seen no release since 2016" Added 2022-01-04
  # now kube3d/k3d will take it's place
  kube3d = k3d; # Added 2022-0705
  kafkacat = throw "'kafkacat' has been renamed to/replaced by 'kcat'"; # Converted to throw 2024-10-17
  kak-lsp = kakoune-lsp; # Added 2024-04-01
  kargo = throw "kargo was removed as it is deprecated upstream and depends on the removed boto package"; # Added 2024-09-22
  kdbplus = throw "'kdbplus' has been removed from nixpkgs"; # Added 2024-05-06
  kdeconnect = throw "'kdeconnect' has been renamed to/replaced by 'plasma5Packages.kdeconnect-kde'"; # Converted to throw 2024-10-17
  keepkey_agent = keepkey-agent; # added 2024-01-06
  kerberos = throw "'kerberos' has been renamed to/replaced by 'krb5'"; # Converted to throw 2024-10-17
  kexectools = throw "'kexectools' has been renamed to/replaced by 'kexec-tools'"; # Converted to throw 2024-10-17
  keyfinger = throw "keyfinder has been removed as it was abandoned upstream and did not build; consider using mixxx or keyfinder-cli"; # Addd 2024-08-25
  keysmith = throw "'keysmith' has been renamed to/replaced by 'libsForQt5.kdeGear.keysmith'"; # Converted to throw 2024-10-17
  kgx = gnome-console; # Added 2022-02-19
  kibana7 = throw "Kibana 7.x has been removed from nixpkgs as it depends on an end of life Node.js version and received no maintenance in time."; # Added 2023-30-10
  kibana = kibana7;
  kio-admin = libsForQt5.kdeGear.kio-admin; # Added 2023-03-18
  kiwitalk = throw "KiwiTalk has been removed because the upstream has been deprecated at the request of Kakao and it's now obsolete."; # Added 2024-10-10
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  kramdown-rfc2629 = throw "'kramdown-rfc2629' has been renamed to/replaced by 'rubyPackages.kramdown-rfc2629'"; # Converted to throw 2024-10-17
  krb5Full = krb5;
  krita-beta = throw "'krita-beta' has been renamed to/replaced by 'krita'"; # Converted to throw 2024-10-17
  kubei = kubeclarity; # Added 2023-05-20
  kubo-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2024-09-24

  ### L ###

  l3afpad = throw "'l3afpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead"; # Added 2024-09-14
  larynx = piper-tts; # Added 2023-05-09
  LASzip = laszip; # Added 2024-06-12
  LASzip2 = laszip_2; # Added 2024-06-12
  latencytop = throw "'latencytop' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  latinmodern-math = lmmath;
  lazarus-qt = lazarus-qt5; # Added 2024-12-25
  leafpad = throw "'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead"; # Added 2024-10-19
  ledger_agent = ledger-agent; # Added 2024-01-07
  lfs = dysk; # Added 2023-07-03
  libAfterImage = throw "'libAfterImage' has been removed from nixpkgs, as it's no longer in development for a long time"; # Added 2024-06-01
  libav = throw "libav has been removed as it was insecure and abandoned upstream for over half a decade; please use FFmpeg"; # Added 2024-08-25
  libav_0_8 = libav; # Added 2024-08-25
  libav_11 = libav; # Added 2024-08-25
  libav_12 = libav; # Added 2024-08-25
  libav_all = libav; # Added 2024-08-25
  libayatana-indicator-gtk3 = libayatana-indicator; # Added 2022-10-18
  libayatana-appindicator-gtk3 = libayatana-appindicator; # Added 2022-10-18
  libbencodetools = bencodetools; # Added 2022-07-30
  libbpf_1 = libbpf; # Added 2022-12-06
  libbson = mongoc; # Added 2024-03-11
  libbitcoin = throw "libbitcoin has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-client = throw "libbitcoin-client has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-explorer = throw "libbitcoin-explorer has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-network = throw "libbitcoin-network has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libbitcoin-protocol = throw "libbitcoin-protocol has been removed as it required an obsolete version of Boost and had no maintainer in Nixpkgs"; # Added 2024-11-24
  libgme = game-music-emu; # Added 2022-07-20
  libgnome-keyring3 = libgnome-keyring; # Added 2024-06-22
  libgpgerror = throw "'libgpgerror' has been renamed to/replaced by 'libgpg-error'"; # Converted to throw 2024-10-17
  libheimdal = heimdal; # Added 2022-11-18
  libiconv-darwin = darwin.libiconv;
  libixp_hg = libixp;
  libjpeg_drop = throw "'libjpeg_drop' has been renamed to/replaced by 'libjpeg_original'"; # Converted to throw 2024-10-17
  liblastfm = throw "'liblastfm' has been renamed to/replaced by 'libsForQt5.liblastfm'"; # Converted to throw 2024-10-17
  libmx = throw "'libmx' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  liboop = throw "liboop has been removed as it is unmaintained upstream."; # Added 2024-08-14
  libosmo-sccp = libosmo-sigtran; # Added 2024-12-20
  libpqxx_6 = throw "libpqxx_6 has been removed, please use libpqxx"; # Added 2024-10-02
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libqt5pas = libsForQt5.libqtpas; # Added 2024-12-25
  libquotient = libsForQt5.libquotient; # Added 2023-11-11
  librarian-puppet-go = throw "'librarian-puppet-go' has been removed, as it's upstream is unmaintained"; # Added 2024-06-10
  librdf = throw "'librdf' has been renamed to/replaced by 'lrdf'"; # Converted to throw 2024-10-17
  LibreArp = librearp; # Added 2024-06-12
  LibreArp-lv2 = librearp-lv2; # Added 2024-06-12
  libreddit = throw "'libreddit' has been removed because it is unmaintained upstream. Consider using 'redlib', a maintained fork"; # Added 2024-07-17
  librtlsdr = rtl-sdr; # Added 2023-02-18
  librewolf-wayland = librewolf; # Added 2022-11-15
  libseat = throw "'libseat' has been renamed to/replaced by 'seatd'"; # Converted to throw 2024-10-17
  libsForQt515 = libsForQt5; # Added 2022-11-24
  libsoup = lib.warnOnInstantiate "‘libsoup’ has been renamed to ‘libsoup_2_4’" libsoup_2_4; # Added 2024-12-02
  libstdcxx5 = throw "libstdcxx5 is severly outdated and has been removed"; # Added 2024-11-24
  libtensorflow-bin = libtensorflow; # Added 2022-09-25
  libtorrentRasterbar = throw "'libtorrentRasterbar' has been renamed to/replaced by 'libtorrent-rasterbar'"; # Converted to throw 2024-10-17
  libtorrentRasterbar-1_2_x = throw "'libtorrentRasterbar-1_2_x' has been renamed to/replaced by 'libtorrent-rasterbar-1_2_x'"; # Converted to throw 2024-10-17
  libtorrentRasterbar-2_0_x = throw "'libtorrentRasterbar-2_0_x' has been renamed to/replaced by 'libtorrent-rasterbar-2_0_x'"; # Converted to throw 2024-10-17
  libungif = throw "'libungif' has been renamed to/replaced by 'giflib'"; # Converted to throw 2024-10-17
  libusb = throw "'libusb' has been renamed to/replaced by 'libusb1'"; # Converted to throw 2024-10-17
  libvpx_1_8 = throw "libvpx_1_8 has been removed because it is impacted by security issues and not used in nixpkgs, move to 'libvpx'"; # Added 2024-07-26
  libwnck3 = libwnck;
  libyamlcpp = yaml-cpp; # Added 2023-01-29
  libyamlcpp_0_3 = yaml-cpp_0_3; # Added 2023-01-29
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  lightstep-tracer-cpp = throw "lightstep-tracer-cpp is deprecated since 2022-08-29; the upstream recommends migration to opentelemetry projects.";
  limesctl = throw "limesctl has been removed because it is insignificant."; # Added 2024-11-25
  lispPackages_new = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  lispPackages = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  lispPackagesFor = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  litecoin = throw "litecoin has been removed as nobody was maintaining it and the packaged version had known vulnerabilities"; # Added 2024-11-24
  litecoind = throw "litecoind has been removed as nobody was maintaining it and the packaged version had known vulnerabilities"; # Added 2024-11-24
  Literate = literate; # Added 2024-06-12
  llama = walk; # Added 2023-01-23

  # Linux kernels
  linux-rt_5_10 = linuxKernel.kernels.linux_rt_5_10;
  linux-rt_5_15 = linuxKernel.kernels.linux_rt_5_15;
  linux-rt_5_4 = linuxKernel.kernels.linux_rt_5_4;
  linux-rt_6_1 = linuxKernel.kernels.linux_rt_6_1;
  linuxPackages_4_14 = linuxKernel.packages.linux_4_14;
  linuxPackages_4_19 = linuxKernel.packages.linux_4_19;
  linuxPackages_5_4 = linuxKernel.packages.linux_5_4;
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_6_1 = linuxKernel.packages.linux_6_1;
  linuxPackages_6_4 = linuxKernel.packages.linux_6_4;
  linuxPackages_6_5 = linuxKernel.packages.linux_6_5;
  linuxPackages_6_6 = linuxKernel.packages.linux_6_6;
  linuxPackages_6_7 = linuxKernel.packages.linux_6_7;
  linuxPackages_6_8 = linuxKernel.packages.linux_6_8;
  linuxPackages_6_9 = linuxKernel.packages.linux_6_9;
  linuxPackages_6_10 = linuxKernel.packages.linux_6_10;
  linuxPackages_6_11 = linuxKernel.packages.linux_6_11;
  linuxPackages_6_12 = linuxKernel.packages.linux_6_12;
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
  linux_5_4 = linuxKernel.kernels.linux_5_4;
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_6_1 = linuxKernel.kernels.linux_6_1;
  linux_6_4 = linuxKernel.kernels.linux_6_4;
  linux_6_5 = linuxKernel.kernels.linux_6_5;
  linux_6_6 = linuxKernel.kernels.linux_6_6;
  linux_6_7 = linuxKernel.kernels.linux_6_7;
  linux_6_8 = linuxKernel.kernels.linux_6_8;
  linux_6_9 = linuxKernel.kernels.linux_6_9;
  linux_6_10 = linuxKernel.kernels.linux_6_10;
  linux_6_11 = linuxKernel.kernels.linux_6_11;
  linux_6_12 = linuxKernel.kernels.linux_6_12;
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

  linuxstopmotion = stopmotion; # Added 2024-11-01

  llvmPackages_git = (callPackages ../development/compilers/llvm { }).git;

  lld_9 = throw "lld_9 has been removed from nixpkgs"; # Added 2024-04-08
  lldb_9 = throw "lldb_9 has been removed from nixpkgs"; # Added 2024-04-08
  llvmPackages_9 = throw "llvmPackages_9 has been removed from nixpkgs"; # Added 2024-04-08
  llvm_9 = throw "llvm_9 has been removed from nixpkgs"; # Added 2024-04-08

  lobster-two = throw "'lobster-two' has been renamed to/replaced by 'google-fonts'"; # Converted to throw 2024-10-17
  lsh = throw "lsh has been removed as it had no maintainer in Nixpkgs and hasn't seen an upstream release in over a decade"; # Added 2024-08-14
  luna-icons = throw "luna-icons has been removed as it was removed upstream"; # Added 2024-10-29
  lv_img_conv = throw "'lv_img_conv' has been removed from nixpkgs as it is broken"; # Added 2024-06-18
  lxd = lib.warnOnInstantiate "lxd has been renamed to lxd-lts" lxd-lts; # Added 2024-04-01
  lxd-unwrapped = lib.warnOnInstantiate "lxd-unwrapped has been renamed to lxd-unwrapped-lts" lxd-unwrapped-lts; # Added 2024-04-01
  lzma = throw "'lzma' has been renamed to/replaced by 'xz'"; # Converted to throw 2024-10-17

  ### M ###

  ma1sd = throw "ma1sd was dropped as it is unmaintained"; # Added 2024-07-10
  mac = monkeysAudio; # Added 2024-11-30
  MACS2 = macs2; # Added 2023-06-12
  mailctl = throw "mailctl has been renamed to oama"; # Added 2024-08-19
  mailman-rss = throw "The mailman-rss package was dropped since it was unmaintained."; # Added 2024-06-21
  mariadb_110 = throw "mariadb_110 has been removed from nixpkgs, please switch to another version like mariadb_114"; # Added 2024-08-15
  mariadb-client = hiPrio mariadb.client; #added 2019.07.28
  maligned = throw "maligned was deprecated upstream in favor of x/tools/go/analysis/passes/fieldalignment"; # Added 20204-08-24
  manicode = throw "manicode has been renamed to codebuff"; # Added 2024-12-10
  marwaita-manjaro = lib.warnOnInstantiate "marwaita-manjaro has been renamed to marwaita-teal" marwaita-teal; # Added 2024-07-08
  marwaita-peppermint = lib.warnOnInstantiate "marwaita-peppermint has been renamed to marwaita-red" marwaita-red; # Added 2024-07-01
  marwaita-ubuntu = lib.warnOnInstantiate "marwaita-ubuntu has been renamed to marwaita-orange" marwaita-orange; # Added 2024-07-08
  marwaita-pop_os = lib.warnOnInstantiate "marwaita-pop_os has been renamed to marwaita-yellow" marwaita-yellow; # Added 2024-10-29
  masari = throw "masari has been removed as it was abandoned upstream"; # Added 2024-07-11
  mathematica9 = throw "mathematica9 has been removed as it was obsolete, broken, and depended on OpenCV 2"; # Added 2024-08-20
  mathematica10 = throw "mathematica10 has been removed as it was obsolete, broken, and depended on OpenCV 2"; # Added 2024-08-20
  mathematica11 = throw "mathematica11 has been removed as it was obsolete, broken, and depended on OpenCV 2"; # Added 2024-08-20
  matomo_5 = matomo; # Added 2024-12-12
  matrique = throw "'matrique' has been renamed to/replaced by 'spectral'"; # Converted to throw 2024-10-17
  matrix-sliding-sync = throw "matrix-sliding-sync has been removed as matrix-synapse 114.0 and later covers its functionality"; # Added 2024-10-20
  maui-nota = libsForQt5.mauiPackages.nota; # added 2022-05-17
  maui-shell = throw "maui-shell has been removed from nixpkgs, it was broken"; # Added 2024-07-15
  mcomix3 = mcomix; # Added 2022-06-05
  mdt = md-tui; # Added 2024-09-03
  meme = throw "'meme' has been renamed to/replaced by 'meme-image-generator'"; # Converted to throw 2024-10-17
  memorymapping = throw "memorymapping has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  memorymappingHook = throw "memorymapping has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  memstream = throw "memstream has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  memstreamHook = throw "memstream has been removed, as it was only useful on old macOS versions that are no longer supported"; # Added 2024-10-05
  mhwaveedit = throw "'mkwaveedit' has been removed due to lack of maintenance upstream. Consider using 'audacity' or 'tenacity' instead";
  microcodeAmd = microcode-amd; # Added 2024-09-08
  microcodeIntel = microcode-intel; # Added 2024-09-08
  microsoft_gsl = microsoft-gsl; # Added 2023-05-26
  MIDIVisualizer = midivisualizer; # Added 2024-06-12
  mikutter = throw "'mikutter' has been removed because the package was broken and had no maintainers"; # Added 2024-10-01
  mime-types = mailcap; # Added 2022-01-21
  minetest = luanti; # Added 2024-11-11
  minetestclient = luanti-client; # Added 2024-11-11
  minetestserver = luanti-server; # Added 2024-11-11
  minetest-touch = luanti-client; # Added 2024-08-12
  minizip2 = pkgs.minizip-ng; # Added 2022-12-28
  mod_dnssd = throw "'mod_dnssd' has been renamed to/replaced by 'apacheHttpdPackages.mod_dnssd'"; # Converted to throw 2024-10-17
  mod_fastcgi = throw "'mod_fastcgi' has been renamed to/replaced by 'apacheHttpdPackages.mod_fastcgi'"; # Converted to throw 2024-10-17
  mod_python = throw "'mod_python' has been renamed to/replaced by 'apacheHttpdPackages.mod_python'"; # Converted to throw 2024-10-17
  mod_wsgi = throw "'mod_wsgi' has been renamed to/replaced by 'apacheHttpdPackages.mod_wsgi'"; # Converted to throw 2024-10-17
  mod_ca = throw "'mod_ca' has been renamed to/replaced by 'apacheHttpdPackages.mod_ca'"; # Converted to throw 2024-10-17
  mod_crl = throw "'mod_crl' has been renamed to/replaced by 'apacheHttpdPackages.mod_crl'"; # Converted to throw 2024-10-17
  mod_csr = throw "'mod_csr' has been renamed to/replaced by 'apacheHttpdPackages.mod_csr'"; # Converted to throw 2024-10-17
  mod_ocsp = throw "'mod_ocsp' has been renamed to/replaced by 'apacheHttpdPackages.mod_ocsp'"; # Converted to throw 2024-10-17
  mod_scep = throw "'mod_scep' has been renamed to/replaced by 'apacheHttpdPackages.mod_scep'"; # Converted to throw 2024-10-17
  mod_spkac = throw "'mod_spkac' has been renamed to/replaced by 'apacheHttpdPackages.mod_spkac'"; # Converted to throw 2024-10-17
  mod_pkcs12 = throw "'mod_pkcs12' has been renamed to/replaced by 'apacheHttpdPackages.mod_pkcs12'"; # Converted to throw 2024-10-17
  mod_timestamp = throw "'mod_timestamp' has been renamed to/replaced by 'apacheHttpdPackages.mod_timestamp'"; # Converted to throw 2024-10-17
  monero = throw "'monero' has been renamed to/replaced by 'monero-cli'"; # Converted to throw 2024-10-17
  mongodb-4_4 = throw "mongodb-4_4 has been removed, it's end of life since April 2024"; # Added 2024-04-11
  mongodb-5_0 = throw "mongodb-5_0 has been removed, it's end of life since October 2024"; # Added 2024-10-01
  moz-phab = mozphab; # Added 2022-08-09
  mp3info = throw "'mp3info' has been removed due to lack of maintenance upstream. Consider using 'eartag' or 'tagger' instead"; # Added 2024-09-14
  mpc-cli = mpc; # Added 2024-10-14
  mpc_cli = mpc; # Added 2024-10-14
  mpd_clientlib = throw "'mpd_clientlib' has been renamed to/replaced by 'libmpdclient'"; # Converted to throw 2024-10-17
  mpdevil = plattenalbum; # Added 2024-05-22
  mpg321 = throw "'mpg321' has been removed due to it being unmaintained by upstream. Consider using mpg123 instead."; # Added 2024-05-10
  mrkd = throw "'mrkd' has been removed as it is unmaintained since 2021"; # Added 2024-12-21
  msp430NewlibCross = msp430Newlib; # Added 2024-09-06
  mupdf_1_17 = throw "'mupdf_1_17' has been removed due to being outdated and insecure. Consider using 'mupdf' instead."; # Added 2024-08-22
  mustache-tcl = tclPackages.mustache-tcl; # Added 2024-10-02
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mysql-client = hiPrio mariadb.client;
  mysql = throw "'mysql' has been renamed to/replaced by 'mariadb'"; # Converted to throw 2024-10-17
  mesa_drivers = throw "'mesa_drivers' has been removed, use 'pkgs.mesa' or 'pkgs.mesa.drivers' depending on target use case."; # Converted to throw 2024-07-11

  ### N ###

  ncdu_2 = ncdu; # Added 2022-07-22
  neocities-cli = neocities; # Added 2024-07-31
  netbox_3_3 = throw "netbox 3.3 series has been removed as it was EOL"; # Added 2023-09-02
  netbox_3_5 = throw "netbox 3.5 series has been removed as it was EOL"; # Added 2024-01-22
  nextcloud27 = throw ''
    Nextcloud v27 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2024-06. Please upgrade to at least Nextcloud v28 by declaring

        services.nextcloud.package = pkgs.nextcloud28;

    in your NixOS config.

    WARNING: if you were on Nextcloud 26 you have to upgrade to Nextcloud 27
    first on 24.05 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2024-06-25
  nextcloud27Packages = throw "Nextcloud27 is EOL!"; # Added 2024-06-25
  nagiosPluginsOfficial = monitoring-plugins;
  neochat = libsForQt5.kdeGear.neochat; # added 2022-05-10
  nerdfonts = throw ''
    nerdfonts has been separated into individual font packages under the namespace nerd-fonts.
    For example change:
      fonts.packages = [
        ...
        (pkgs.nerdfonts.override { fonts = [ "0xproto" "DroidSansMono" ]; })
      ]
    to
      fonts.packages = [
        ...
        pkgs.nerd-fonts._0xproto
        pkgs.nerd-fonts.droid-sans-mono
      ]
    or for all fonts
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
  ''; # Added 2024-11-09
  newlibCross = newlib; # Added 2024-09-06
  newlib-nanoCross = newlib-nano; # Added 2024-09-06
  nix-direnv-flakes = nix-direnv;
  nix-ld-rs = nix-ld; # Added 2024-08-17
  nix-repl = throw (
    # Added 2018-08-26
    "nix-repl has been removed because it's not maintained anymore, " +
    "use `nix repl` instead. Also see https://github.com/NixOS/nixpkgs/pull/44903"
  );
  nix-simple-deploy = throw "'nix-simple-deploy' has been removed as it is broken and unmaintained"; # Added 2024-08-17
  nix-universal-prefetch = throw "The nix-universal-prefetch package was dropped since it was unmaintained."; # Added 2024-06-21
  nixFlakes = throw "'nixFlakes' has been renamed to/replaced by 'nixVersions.stable'"; # Converted to throw 2024-10-17
  nixStable = nixVersions.stable; # Added 2022-01-24
  nixUnstable = throw "nixUnstable has been removed. For bleeding edge (Nix master, roughly weekly updated) use nixVersions.git, otherwise use nixVersions.latest."; # Converted to throw 2024-04-22
  nix_2_3 = nixVersions.nix_2_3;
  nixfmt = lib.warnOnInstantiate "nixfmt was renamed to nixfmt-classic. The nixfmt attribute may be used for the new RFC 166-style formatter in the future, which is currently available as nixfmt-rfc-style" nixfmt-classic; # Added 2024-03-31

  # When the nixops_unstable alias is removed, nixops_unstable_minimal can be renamed to nixops_unstable.

  nixosTest = testers.nixosTest; # Added 2022-05-05
  nmap-unfree = throw "'nmap-unfree' has been renamed to/replaced by 'nmap'"; # Converted to throw 2024-10-17
  nodejs-18_x = nodejs_18; # Added 2022-11-06
  nodejs-slim-18_x = nodejs-slim_18; # Added 2022-11-06
  noto-fonts-cjk = throw "'noto-fonts-cjk' has been renamed to/replaced by 'noto-fonts-cjk-sans'"; # Converted to throw 2024-10-17
  noto-fonts-emoji = noto-fonts-color-emoji; # Added 2023-09-09
  noto-fonts-extra = noto-fonts; # Added 2023-04-08
  NSPlist = nsplist; # Added 2024-01-05
  nushellFull = lib.warnOnInstantiate "`nushellFull` has has been replaced by `nushell` as it's features no longer exist" nushell; # Added 2024-05-30
  nvidia-podman = throw "podman should use the Container Device Interface (CDI) instead. See https://web.archive.org/web/20240729183805/https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-podman"; # Added 2024-08-02
  nvidia-thrust = throw "nvidia-thrust has been removed because the project was deprecated; use cudaPackages.cuda_cccl";
  nvtop = lib.warnOnInstantiate "nvtop has been renamed to nvtopPackages.full" nvtopPackages.full; # Added 2024-02-25
  nvtop-amd = lib.warnOnInstantiate "nvtop-amd has been renamed to nvtopPackages.amd" nvtopPackages.amd; # Added 2024-02-25
  nvtop-nvidia = lib.warnOnInstantiate "nvtop-nvidia has been renamed to nvtopPackages.nvidia" nvtopPackages.nvidia; # Added 2024-02-25
  nvtop-intel = lib.warnOnInstantiate "nvtop-intel has been renamed to nvtopPackages.intel" nvtopPackages.intel; # Added 2024-02-25
  nvtop-msm = lib.warnOnInstantiate "nvtop-msm has been renamed to nvtopPackages.msm" nvtopPackages.msm; # Added 2024-02-25

  ### O ###

  o = orbiton; # Added 2023-04-09
  oathToolkit = oath-toolkit; # Added 2022-04-04
  oauth2_proxy = throw "'oauth2_proxy' has been renamed to/replaced by 'oauth2-proxy'"; # Converted to throw 2024-10-17
  oil = lib.warnOnInstantiate "Oil has been replaced with the faster native C++ version and renamed to 'oils-for-unix'. See also https://github.com/oils-for-unix/oils/wiki/Oils-Deployments" oils-for-unix; # Added 2024-10-22
  onevpl-intel-gpu = lib.warnOnInstantiate "onevpl-intel-gpu has been renamed to vpl-gpu-rt" vpl-gpu-rt; # Added 2024-06-04
  opencv2 = throw "opencv2 has been removed as it is obsolete and was not used by any other package; please migrate to OpenCV 4"; # Added 2024-08-20
  opencv3 = throw "opencv3 has been removed as it is obsolete and was not used by any other package; please migrate to OpenCV 4"; # Added 2024-08-20
  openafs_1_8 = openafs; # Added 2022-08-22
  opencl-info = throw "opencl-info has been removed, as the upstream is unmaintained; consider using 'clinfo' instead"; # Added 2024-06-12
  opencomposite-helper = throw "opencomposite-helper has been removed from nixpkgs as it causes issues with some applications. See https://wiki.nixos.org/wiki/VR#OpenComposite for the recommended setup"; # Added 2024-09-07
  openconnect_gnutls = openconnect; # Added 2022-03-29
  opendylan = throw "opendylan has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  opendylan_bin = throw "opendylan_bin has been removed from nixpkgs as it was broken"; # Added 2024-07-15
  openelec-dvb-firmware = throw "'openelec-dvb-firmware' has been renamed to/replaced by 'libreelec-dvb-firmware'"; # Converted to throw 2024-10-17
  openethereum = throw "openethereum development has ceased by upstream. Use alternate clients such as go-ethereum, erigon, or nethermind"; # Added 2024-05-13
  openimageio2 = openimageio; # Added 2023-01-05
  openisns = throw "'openisns' has been renamed to/replaced by 'open-isns'"; # Converted to throw 2024-10-17
  openjdk19 = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk19_headless = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk19 = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk19_headless = throw "OpenJDK 19 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk20 = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk20_headless = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk20 = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  jdk20_headless = throw "OpenJDK 20 was removed as it has reached its end of life"; # Added 2024-08-01
  openjdk22 = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  openjdk22_headless = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  jdk22 = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  jdk22_headless = throw "OpenJDK 22 was removed as it has reached its end of life"; # Added 2024-09-24
  openjfx11 = throw "OpenJFX 11 was removed as it has reached its end of life"; # Added 2024-10-07
  openjfx19 = throw "OpenJFX 19 was removed as it has reached its end of life"; # Added 2024-08-01
  openjfx20 = throw "OpenJFX 20 was removed as it has reached its end of life"; # Added 2024-08-01
  openjfx22 = throw "OpenJFX 22 was removed as it has reached its end of life"; # Added 2024-09-24
  openjpeg_2 = throw "'openjpeg_2' has been renamed to/replaced by 'openjpeg'"; # Converted to throw 2024-10-17
  openlens = throw "Lens Closed its source code, package obsolete/stale - consider lens as replacement"; # Added 2024-09-04
  openlp = throw "openlp has been removed for now because the outdated version depended on insecure and removed packages and it needs help to upgrade and maintain it; see https://github.com/NixOS/nixpkgs/pull/314882"; # Added 2024-07-29
  openmpt123 = throw "'openmpt123' has been renamed to/replaced by 'libopenmpt'"; # Converted to throw 2024-10-17
  openssl_3_0 = openssl_3; # Added 2022-06-27
  orchis = throw "'orchis' has been renamed to/replaced by 'orchis-theme'"; # Converted to throw 2024-10-17
  onlyoffice-bin = onlyoffice-desktopeditors; # Added 2024-09-20
  onlyoffice-bin_latest = onlyoffice-bin; # Added 2024-07-03
  onlyoffice-bin_7_2 = throw "onlyoffice-bin_7_2 has been removed. Please use the latest version available under onlyoffice-bin"; # Added 2024-07-03
  onlyoffice-bin_7_5 = throw "onlyoffice-bin_7_5 has been removed. Please use the latest version available under onlyoffice-bin"; # Added 2024-07-03
  openvswitch-lts = throw "openvswitch-lts has been removed. Please use the latest version available under openvswitch"; # Added 2024-08-24
  oraclejdk = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejdk8 = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejre = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejre8 = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  jrePlugin = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  jre8Plugin = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  jdkdistro = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejdk8distro = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  oraclejdk11 = throw "All Oracle JDKs and JREs were dropped due to being unmaintained and heavily insecure. OpenJDK provides compatible replacements for JDKs and JREs."; # Added 2024-11-01
  OSCAR = oscar; # Added 2024-06-12
  osxfuse = throw "'osxfuse' has been renamed to/replaced by 'macfuse-stubs'"; # Converted to throw 2024-10-17
  ovn-lts = throw "ovn-lts has been removed. Please use the latest version available under ovn"; # Added 2024-08-24
  oysttyer = throw "oysttyer has been removed; it is no longer maintained because of Twitter disabling free API access"; # Added 2024-09-23

  ### P ###

  PageEdit = pageedit; # Added 2024-01-21
  p2pvc = throw "p2pvc has been removed as it is unmaintained upstream and depends on OpenCV 2"; # Added 2024-08-20
  packet-cli = throw "'packet-cli' has been renamed to/replaced by 'metal-cli'"; # Converted to throw 2024-10-17
  paperoni = throw "paperoni has been removed, because it is unmaintained"; # Added 2024-07-14
  paperless = throw "'paperless' has been renamed to/replaced by 'paperless-ngx'"; # Converted to throw 2024-10-17
  paperless-ng = paperless-ngx; # Added 2022-04-11
  partition-manager = libsForQt5.partitionmanager; # Added 2024-01-08
  patchelfStable = patchelf; # Added 2024-01-25
  paup =  paup-cli; # Added 2024-09-11
  pcsctools = pcsc-tools; # Added 2023-12-07
  pcsxr = throw "pcsxr was removed as it has been abandoned for over a decade; please use DuckStation, Mednafen, or the RetroArch PCSX ReARMed core"; # Added 2024-08-20
  pdf4tcl = tclPackages.pdf4tcl; # Added 2024-10-02
  peach = asouldocs; # Added 2022-08-28
  percona-server_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-server; # Added 2024-10-13
  percona-server_lts = percona-server; # Added 2024-10-13
  percona-xtrabackup_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-xtrabackup; # Added 2024-10-13
  percona-xtrabackup_lts = percona-xtrabackup; # Added 2024-10-13
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  perldevel = throw "'perldevel' has been dropped due to lack of updates in nixpkgs and lack of consistent support for devel versions by 'perl-cross' releases, use 'perl' instead";
  perldevelPackages = perldevel;
  petrinizer = throw "'petrinizer' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  pg-gvm = throw "pg-gvm has been moved to postgresql.pkgs.pg-gvm to make it work with all versions of PostgreSQL"; # added 2024-11-30
  pgadmin = pgadmin4;
  pharo-spur64 = pharo; # Added 2022-08-03
  picom-next = picom; # Added 2024-02-13
  pict-rs_0_3 = throw "pict-rs_0_3 has been removed, as it was an outdated version and no longer compiled"; # Added 2024-08-20

  pipewire_0_2 = throw "pipewire_0_2 has been removed as it is outdated and no longer used"; # Added 2024-07-28
  pipewire-media-session = throw "pipewire-media-session is no longer maintained and has been removed. Please use Wireplumber instead.";
  playwright = lib.warnOnInstantiate "'playwright' will reference playwright-driver in 25.05. Reference 'python3Packages.playwright' for the python test launcher" (python3Packages.toPythonApplication python3Packages.playwright); # Added 2024-10-04
  pleroma-otp = throw "'pleroma-otp' has been renamed to/replaced by 'pleroma'"; # Converted to throw 2024-10-17
  pltScheme = racket; # just to be sure
  poretools = throw "poretools has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-06-03
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
  tex-match = throw "'tex-match' has been removed due to lack of maintenance upstream. Consider using 'hieroglyphic' instead"; # Added 2024-09-24
  texinfo5 = throw "'texinfo5' has been removed from nixpkgs"; # Added 2024-09-10
  timescaledb = postgresqlPackages.timescaledb;
  tsearch_extras = throw "'tsearch_extras' has been removed from nixpkgs"; # Added 2024-12-15

  postgresql_12 = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14
  postgresql_12_jit = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14
  postgresql12Packages = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14
  postgresql12JitPackages = throw "postgresql_12 has been removed since it reached its EOL upstream"; # Added 2024-11-14

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
  pinentry_qt5 = throw "'pinentry_qt5' has been renamed to/replaced by 'pinentry-qt'"; # Converted to throw 2024-10-17
  pivx = throw "pivx has been removed as it was marked as broken"; # Added 2024-07-15
  pivxd = throw "pivxd has been removed as it was marked as broken"; # Added 2024-07-15

  PlistCpp = plistcpp; # Added 2024-01-05
  pocket-updater-utility = pupdate; # Added 2024-01-25
  prismlauncher-qt5 = throw "'prismlauncher-qt5' has been removed from nixpkgs. Please use 'prismlauncher'"; # Added 2024-04-20
  prismlauncher-qt5-unwrapped = throw "'prismlauncher-qt5-unwrapped' has been removed from nixpkgs. Please use 'prismlauncher-unwrapped'"; # Added 2024-04-20
  probe-rs = probe-rs-tools; # Added 2024-05-23
  probe-run = throw "probe-run is deprecated upstream.  Use probe-rs instead."; # Added 2024-05-23
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-dovecot-exporter = dovecot_exporter; # Added 2024-06-10
  prometheus-openldap-exporter = throw "'prometheus-openldap-exporter' has been removed from nixpkgs, as it was unmaintained"; # Added 2024-09-01
  prometheus-minio-exporter = throw "'prometheus-minio-exporter' has been removed from nixpkgs, use Minio's built-in Prometheus integration instead"; # Added 2024-06-10
  prometheus-tor-exporter = throw "'prometheus-tor-exporter' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2024-10-30
  protobuf3_24 = protobuf_24;
  protobuf3_23 = protobuf_23;
  protobuf3_21 = protobuf_21;
  protonup = protonup-ng; # Added 2022-11-06
  protonvpn-gui_legacy = throw "protonvpn-gui_legacy source code was removed from upstream. Use protonvpn-gui instead."; # Added 2024-10-12
  proxmark3-rrg = proxmark3; # Added 2023-07-25
  psensor = throw "'psensor' has been removed due to lack of maintenance upstream. Consider using 'mission-center', 'resources' or 'monitorets' instead"; # Added 2024-09-14
  pyo3-pack = maturin;
  pypi2nix = throw "pypi2nix has been removed due to being unmaintained";
  pypolicyd-spf = spf-engine; # Added 2022-10-09
  python = python2; # Added 2022-01-11
  python-swiftclient = throw "'python-swiftclient' has been renamed to/replaced by 'swiftclient'"; # Converted to throw 2024-10-17
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11

  ### Q ###

  qbittorrent-qt5 = throw "'qbittorrent-qt5' has been removed as qBittorrent 5 dropped support for Qt 5. Please use 'qbittorrent'"; # Added 2024-09-30
  qcsxcad = throw "'qcsxcad' has been renamed to/replaced by 'libsForQt5.qcsxcad'"; # Converted to throw 2024-10-17
  qflipper = qFlipper; # Added 2022-02-11
  qscintilla = libsForQt5.qscintilla; # Added 2023-09-20
  qscintilla-qt6 = qt6Packages.qscintilla; # Added 2023-09-20
  qt515 = qt5; # Added 2022-11-24
  qt5ct = throw "'qt5ct' has been renamed to/replaced by 'libsForQt5.qt5ct'"; # Converted to throw 2024-10-17
  qt6ct = qt6Packages.qt6ct; # Added 2023-03-07
  qtcurve = throw "'qtcurve' has been renamed to/replaced by 'libsForQt5.qtcurve'"; # Converted to throw 2024-10-17
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
  qxw = throw "'qxw' has been removed due to lack of maintenance upstream. Consider using 'crosswords' instead"; # Added 2024-10-19

  ### R ###

  rabbitvcs = throw "rabbitvcs has been removed from nixpkgs, because it was broken"; # Added 2024-07-15
  racket_7_9 = throw "Racket 7.9 has been removed because it is insecure. Consider using 'racket' instead."; # Added 2024-12-06
  radare2-cutter = throw "'radare2-cutter' has been renamed to/replaced by 'cutter'"; # Converted to throw 2024-10-17
  radicale2 = throw "'radicale2' was removed because it was broken. Use 'radicale' (version 3) instead"; # Added 2024-11-29
  radicale3 = radicale; # Added 2024-11-29
  radicle-cli = throw "'radicle-cli' was removed in favor of 'radicle-node'"; # Added 2024-05-04
  radicle-upstream = throw "'radicle-upstream' was sunset, see <https://community.radworks.org/t/2962>"; # Added 2024-05-04
  railway-travel = diebahn; # Added 2024-04-01
  rambox-pro = rambox; # Added 2022-12-12
  rapidjson-unstable = lib.warnOnInstantiate "'rapidjson-unstable' has been renamed to 'rapidjson'" rapidjson; # Added 2024-07-28
  redocly-cli = redocly; # Added 2024-04-14
  redpanda = redpanda-client; # Added 2023-10-14
  redpanda-server = throw "'redpanda-server' has been removed because it was broken for a long time"; # Added 2024-06-10
  relibc = throw "relibc has been removed due to lack of maintenance"; # Added 2024-09-02
  replay-sorcery = throw "replay-sorcery has been removed as it is unmaintained upstream. Consider using gpu-screen-recorder or obs-studio instead."; # Added 2024-07-13
  restinio_0_6 = throw "restinio_0_6 has been removed from nixpkgs as it's not needed by downstream packages"; # Added 2024-07-04
  retroarchBare = retroarch-bare; # Added 2024-11-23
  retroarchFull = retroarch-full; # Added 2024-11-23
  retroshare06 = retroshare;
  rftg = throw "'rftg' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  rigsofrods = rigsofrods-bin; # Added 2023-03-22
  ring-daemon = throw "'ring-daemon' has been renamed to/replaced by 'jami-daemon'"; # Converted to throw 2024-10-17
  rippled = throw "rippled has been removed as it was broken and had not been updated since 2022"; # Added 2024-11-25
  rippled-validator-keys-tool = throw "rippled-validator-keys-tool has been removed as it was broken and had not been updated since 2022"; # Added 2024-11-25
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rpiboot-unstable = throw "'rpiboot-unstable' has been renamed to/replaced by 'rpiboot'"; # Converted to throw 2024-10-17
  rr-unstable = rr; # Added 2022-09-17
  rtx = mise; # Added 2024-01-05
  runCommandNoCC = runCommand;
  runCommandNoCCLocal = runCommandLocal;
  rustc-wasm32 = rustc; # Added 2023-12-01
  rustic-rs = rustic; # Added 2024-08-02
  rxvt_unicode = throw "'rxvt_unicode' has been renamed to/replaced by 'rxvt-unicode-unwrapped'"; # Converted to throw 2024-10-17
  rxvt_unicode-with-plugins = throw "'rxvt_unicode-with-plugins' has been renamed to/replaced by 'rxvt-unicode'"; # Converted to throw 2024-10-17

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtlwifi_new-firmware = throw "'rtlwifi_new-firmware' has been renamed to/replaced by 'rtw88-firmware'"; # Converted to throw 2024-10-17
  rtw88-firmware = throw "rtw88-firmware has been removed because linux-firmware now contains it."; # Added 2024-06-28

  ### S ###

  SDL_classic = SDL1; # Added 2024-09-03
  s2n = throw "'s2n' has been renamed to/replaced by 's2n-tls'"; # Converted to throw 2024-10-17
  sandboxfs = throw "'sandboxfs' has been removed due to being unmaintained, consider using linux namespaces for sandboxing instead"; # Added 2024-06-06
  sane-backends-git = throw "'sane-backends-git' has been renamed to/replaced by 'sane-backends'"; # Converted to throw 2024-10-17
  scantailor = scantailor-advanced; # Added 2022-05-26
  schildichat-web = throw ''
    schildichat has been removed as it is severely lacking behind the Element upstream and does not receive regular security fixes.
    Please participate in upstream discussion on getting out new releases:
    https://github.com/SchildiChat/schildichat-desktop/issues/212
    https://github.com/SchildiChat/schildichat-desktop/issues/215''; # Added 2023-12-05
  schildichat-desktop = schildichat-web;
  schildichat-desktop-wayland = schildichat-web;
  scitoken-cpp = scitokens-cpp; # Added 2024-02-12
  semeru-bin-16 = throw "Semeru 16 has been removed as it has reached its end of life"; # Added 2024-08-01
  semeru-jre-bin-16 = throw "Semeru 16 has been removed as it has reached its end of life"; # Added 2024-08-01
  sensu = throw "sensu has been removed as the upstream project is deprecated. Consider using `sensu-go`"; # Added 2024-10-28
  session-desktop-appimage = session-desktop;
  sequoia = sequoia-sq; # Added 2023-06-26
  sexp = sexpp; # Added 2023-07-03
  inherit (libsForQt5.mauiPackages) shelf; # added 2022-05-17
  shipyard = jumppad; # Added 2023-06-06
  signal-desktop-beta = throw "signal-desktop-beta has been removed to make the signal-desktop package easier to maintain";
  shout = nodePackages.shout; # Added unknown; moved 2024-10-19
  sky = throw "'sky' has been removed because its upstream website disappeared"; # Added 2024-07-21
  SkypeExport = skypeexport; # Added 2024-06-12
  slack-dark = throw "'slack-dark' has been renamed to/replaced by 'slack'"; # Converted to throw 2024-10-17
  slurm-llnl = slurm; # renamed July 2017
  snapTools = throw "snapTools was removed because makeSnap produced broken snaps and it was the only function in snapTools. See https://github.com/NixOS/nixpkgs/issues/100618 for more details."; # 2024-03-04;
  soldat-unstable = opensoldat; # Added 2022-07-02
  soundOfSorting = sound-of-sorting; # Added 2023-07-07
  SP800-90B_EntropyAssessment = sp800-90b-entropyassessment; # Added on 2024-06-12
  SPAdes = spades; # Added 2024-06-12
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


  solana-validator = throw "'solana-validator' is obsoleted by solana-cli, which also includes the validator binary"; # Added 2024-12-20
  spectral = throw "'spectral' has been renamed to/replaced by 'neochat'"; # Converted to throw 2024-10-17
  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spidermonkey = throw "'spidermonkey' has been renamed to/replaced by 'spidermonkey_78'"; # Converted to throw 2024-10-17
  spidermonkey_102 = throw "'spidermonkey_102' is EOL since 2023/03"; # Added 2024-08-07
  spotify-unwrapped = spotify; # added 2022-11-06
  spring-boot = throw "'spring-boot' has been renamed to/replaced by 'spring-boot-cli'"; # Converted to throw 2024-10-17
  sqldeveloper = throw "sqldeveloper was dropped due to being severely out-of-date and having a dependency on JavaFX for Java 8, which we do not support"; # Added 2024-11-02
  srvc = throw "'srvc' has been removed, as it was broken and unmaintained"; # Added 2024-09-09
  ssm-agent = amazon-ssm-agent; # Added 2023-10-17
  starpls-bin = starpls;
  starspace = throw "starspace has been removed from nixpkgs, as it was broken"; # Added 2024-07-15
  steamPackages = {
    steamArch = throw "`steamPackages.steamArch` has been removed as it's no longer applicable";
    steam = lib.warnOnInstantiate "`steamPackages.steam` has been moved to top level as `steam-unwrapped`" steam-unwrapped;
    steam-fhsenv = lib.warnOnInstantiate "`steamPackages.steam-fhsenv` has been moved to top level as `steam`" steam;
    steam-fhsenv-small = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-small` has been moved to top level as `steam`; there is no longer a -small variant" steam;
    steam-fhsenv-without-steam = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-without-steam` has been moved to top level as `steam-fhsenv-without-steam`" steam-fhsenv-without-steam;
    steam-runtime = throw "`steamPackages.steam-runtime` has been removed, as it's no longer supported or necessary";
    steam-runtime-wrapped = throw "`steamPackages.steam-runtime-wrapped` has been removed, as it's no longer supported or necessary";
    steamcmd = lib.warnOnInstantiate "`steamPackages.steamcmd` has been moved to top level as `steamcmd`" steamcmd;
  };
  steam-small = steam; # Added 2024-09-12
  steam-run-native = steam-run; # added 2022-02-21
  StormLib = stormlib; # Added 2024-01-21
  strawberry-qt5 = throw "strawberry-qt5 has been replaced by strawberry-qt6"; # Added 2024-11-22
  sumneko-lua-language-server = lua-language-server; # Added 2023-02-07
  sumokoin = throw "sumokoin has been removed as it was abandoned upstream"; # Added 2024-11-23
  swiProlog = lib.warnOnInstantiate "swiProlog has been renamed to swi-prolog" swi-prolog; # Added 2024-09-07
  swiPrologWithGui = lib.warnOnInstantiate "swiPrologWithGui has been renamed to swi-prolog-gui" swi-prolog-gui; # Added 2024-09-07
  swig1 = throw "swig1 has been removed as it is obsolete"; # Added 2024-08-23
  swig2 = throw "swig2 has been removed as it is obsolete"; # Added 2024-08-23
  swig3 = throw "swig3 has been removed as it is obsolete"; # Added 2024-11-18
  swig4 = swig; # Added 2024-09-12
  swigWithJava = throw "swigWithJava has been removed as the main swig package has supported Java since 2009"; # Added 2024-09-12
  swtpm-tpm2 = throw "'swtpm-tpm2' has been renamed to/replaced by 'swtpm'"; # Converted to throw 2024-10-17
  Sylk = sylk; # Added 2024-06-12
  symbiyosys = sby; # Added 2024-08-18
  sync = taler-sync; # Added 2024-09-04
  syncthing-cli = throw "'syncthing-cli' has been renamed to/replaced by 'syncthing'"; # Converted to throw 2024-10-17
  syncthingtray-qt6 = syncthingtray; # Added 2024-03-06

  ### T ###

  tabula = throw "tabula has been removed from nixpkgs, as it was broken"; # Added 2024-07-15
  tailor = throw "'tailor' has been removed from nixpkgs, as it was unmaintained upstream."; # Added 2024-11-02
  tangogps = throw "'tangogps' has been renamed to/replaced by 'foxtrotgps'"; # Converted to throw 2024-10-17
  taskwarrior = lib.warnOnInstantiate "taskwarrior was replaced by taskwarrior3, which requires manual transition from taskwarrior 2.6, read upstream's docs: https://taskwarrior.org/docs/upgrade-3/" taskwarrior2;
  taplo-cli = taplo; # Added 2022-07-30
  taplo-lsp = taplo; # Added 2022-07-30
  taro = taproot-assets; # Added 2023-07-04
  tbb_2021_5 = throw "tbb_2021_5 has been removed from nixpkgs, as it broke with GCC 14";
  tcl-fcgi = tclPackages.tcl-fcgi; # Added 2024-10-02
  tclcurl = tclPackages.tclcurl; # Added 2024-10-02
  tcllib = tclPackages.tcllib; # Added 2024-10-02
  tclmagick = tclPackages.tclmagick; # Added 2024-10-02
  tcltls = tclPackages.tcltls; # Added 2024-10-02
  tcludp = tclPackages.tcludp; # Added 2024-10-02
  tclvfs = tclPackages.tclvfs; # Added 2024-10-02
  tclx = tclPackages.tclx; # Added 2024-10-02
  tdesktop = telegram-desktop; # Added 2023-04-07
  tdom = tclPackages.tdom; # Added 2024-10-02
  teamspeak_client = teamspeak3; # Added 2024-11-07
  teck-programmer = throw "teck-programmer was removed because it was broken and unmaintained"; # added 2024-08-23
  teleport_13 = throw "teleport 13 has been removed as it is EOL. Please upgrade to Teleport 14 or later"; # Added 2024-05-26
  teleport_14 = throw "teleport 14 has been removed as it is EOL. Please upgrade to Teleport 15 or later"; # Added 2024-10-18
  terminus-nerdfont = lib.warnOnInstantiate "terminus-nerdfont is redundant. Use nerd-fonts.terminess-ttf instead." nerd-fonts.terminess-ttf; # Added 2024-11-10
  temurin-bin-20 = throw "Temurin 20 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-20 = throw "Temurin 20 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-bin-19 = throw "Temurin 19 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-19 = throw "Temurin 19 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-bin-18 = throw "Temurin 18 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-18 = throw "Temurin 18 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-bin-16 = throw "Temurin 16 has been removed as it has reached its end of life"; # Added 2024-08-01
  temurin-jre-bin-22 = throw "Temurin 22 has been removed as it has reached its end of life"; # Added 2024-09-24
  temurin-bin-22 = throw "Temurin 22 has been removed as it has reached its end of life"; # Added 2024-09-24
  tepl = libgedit-tepl; # Added 2024-04-29
  testVersion = testers.testVersion; # Added 2022-04-20
  tfplugindocs = terraform-plugin-docs; # Added 2023-11-01
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  timescale-prometheus = throw "'timescale-prometheus' has been renamed to/replaced by 'promscale'"; # Converted to throw 2024-10-17
  tightvnc = throw "'tightvnc' has been removed as the version 1.3 is not maintained upstream anymore and is insecure"; # Added 2024-08-22
  tix = tclPackages.tix; # Added 2024-10-02
  tkcvs = tkrev; # Added 2022-03-07
  tkimg = tclPackages.tkimg; # Added 2024-10-02
  toil = throw "toil was removed as it was broken and requires obsolete versions of libraries"; # Added 2024-09-22
  tokodon = plasma5Packages.tokodon;
  tokyo-night-gtk = tokyonight-gtk-theme; # Added 2024-01-28
  tomcat_connectors = apacheHttpdPackages.mod_jk; # Added 2024-06-07
  tor-browser-bundle-bin = tor-browser; # Added 2023-09-23
  torq = throw "torq has been removed because the project went closed source"; # Added 2024-11-24
  transmission = lib.warnOnInstantiate (transmission3Warning {}) transmission_3; # Added 2024-06-10
  transmission-gtk = lib.warnOnInstantiate (transmission3Warning {suffix = "-gtk";}) transmission_3-gtk; # Added 2024-06-10
  transmission-qt = lib.warnOnInstantiate (transmission3Warning {suffix = "-qt";}) transmission_3-qt; # Added 2024-06-10
  treefmt = treefmt2; # 2024-06-28
  libtransmission = lib.warnOnInstantiate (transmission3Warning {prefix = "lib";}) libtransmission_3; # Added 2024-06-10
  tracker = lib.warnOnInstantiate "tracker has been renamed to tinysparql" tinysparql; # Added 2024-09-30
  tracker-miners = lib.warnOnInstantiate "tracker-miners has been renamed to localsearch" localsearch; # Added 2024-09-30
  transfig = fig2dev; # Added 2022-02-15
  transifex-client = transifex-cli; # Added 2023-12-29
  trfl = throw "trfl has been removed, because it has not received an update for 3 years and was broken"; # Added 2024-07-25
  trezor_agent = trezor-agent; # Added 2024-01-07
  openai-triton-llvm = triton-llvm; # added 2024-07-18
  trust-dns = hickory-dns; # Added 2024-08-07
  tumpa = throw "tumpa has been removed, as it is broken"; # Added 2024-07-15
  turbogit = throw "turbogit has been removed as it is unmaintained upstream and depends on an insecure version of libgit2"; # Added 2024-08-25
  tvbrowser-bin = tvbrowser; # Added 2023-03-02
  tvheadend = throw "tvheadend has been removed as it nobody was willing to maintain it and it was stuck on an unmaintained version that required FFmpeg 4; please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version"; # Added 2024-08-21
  typst-fmt = typstfmt; # Added 2023-07-15
  typst-preview = throw "The features of 'typst-preview' have been consolidated to 'tinymist', an all-in-one language server for typst"; # Added 2024-07-07

  ### U ###

  uade123 = uade; # Added 2022-07-30
  uberwriter = throw "'uberwriter' has been renamed to/replaced by 'apostrophe'"; # Converted to throw 2024-10-17
  ubootBeagleboneBlack = throw "'ubootBeagleboneBlack' has been renamed to/replaced by 'ubootAmx335xEVM'"; # Converted to throw 2024-10-17
  ubuntu_font_family = ubuntu-classic; # Added 2024-02-19
  uclibc = uclibc-ng; # Added 2022-06-16
  uclibcCross = uclibc-ng; # Added 2022-06-16
  unicorn-emu = throw "'unicorn-emu' has been renamed to/replaced by 'unicorn'"; # Converted to throw 2024-10-17
  uniffi-bindgen = throw "uniffi-bindgen has been removed since upstream no longer provides a standalone package for the CLI";
  unifi-poller = unpoller; # Added 2022-11-24
  unifi-video = throw "unifi-video has been removed as it has been unsupported upstream since 2021"; # Added 2024-10-01
  unifi5 = throw "'unifi5' has been removed since its required MongoDB version is EOL."; # Added 2024-04-11
  unifi6 = throw "'unifi6' has been removed since its required MongoDB version is EOL."; # Added 2024-04-11
  unifi7 = throw "'unifi7' has been removed since it is vulnerable to CVE-2024-42025 and its required MongoDB version is EOL."; # Added 2024-10-01
  unifi8 = unifi; # Added 2024-11-15
  unifiLTS = throw "'unifiLTS' has been removed since UniFi no longer has LTS and stable releases. Use `pkgs.unifi` instead."; # Added 2024-04-11
  unifiStable = throw "'unifiStable' has been removed since UniFi no longer has LTS and stable releases. Use `pkgs.unifi` instead."; # Converted to throw 2024-04-11
  unl0kr = throw "'unl0kr' is now included with buffybox. Use `pkgs.buffybox` instead."; # Removed 2024-12-20
  untrunc = throw "'untrunc' has been renamed to/replaced by 'untrunc-anthwlock'"; # Converted to throw 2024-10-17
  urxvt_autocomplete_all_the_things = throw "'urxvt_autocomplete_all_the_things' has been renamed to/replaced by 'rxvt-unicode-plugins.autocomplete-all-the-things'"; # Converted to throw 2024-10-17
  urxvt_bidi = throw "'urxvt_bidi' has been renamed to/replaced by 'rxvt-unicode-plugins.bidi'"; # Converted to throw 2024-10-17
  urxvt_font_size = throw "'urxvt_font_size' has been renamed to/replaced by 'rxvt-unicode-plugins.font-size'"; # Converted to throw 2024-10-17
  urxvt_perl = throw "'urxvt_perl' has been renamed to/replaced by 'rxvt-unicode-plugins.perl'"; # Converted to throw 2024-10-17
  urxvt_perls = throw "'urxvt_perls' has been renamed to/replaced by 'rxvt-unicode-plugins.perls'"; # Converted to throw 2024-10-17
  urxvt_tabbedex = throw "'urxvt_tabbedex' has been renamed to/replaced by 'rxvt-unicode-plugins.tabbedex'"; # Converted to throw 2024-10-17
  urxvt_theme_switch = throw "'urxvt_theme_switch' has been renamed to/replaced by 'rxvt-unicode-plugins.theme-switch'"; # Converted to throw 2024-10-17
  urxvt_vtwheel = throw "'urxvt_vtwheel' has been renamed to/replaced by 'rxvt-unicode-plugins.vtwheel'"; # Converted to throw 2024-10-17
  ut2004Packages = throw "UT2004 requires libstdc++5 which is not supported by nixpkgs anymore"; # Added 2024-11-24
  ut2004demo = ut2004Packages; # Added 2024-11-24
  util-linuxCurses = util-linux; # Added 2022-04-12
  utillinux = util-linux; # Added 2020-11-24, keep until node2nix is phased out, see https://github.com/NixOS/nixpkgs/issues/229475

  ### V ###

  v8 = throw "`v8` has been removed as it's unmaintained for several years and has vulnerabilites. Please migrate to `nodejs.libv8`"; # Added 2024-12-21
  validphys2 = throw "validphys2 has been removed, since it has a broken dependency that was removed"; # Added 2024-08-21
  vamp = { vampSDK = vamp-plugin-sdk; }; # Added 2020-03-26
  vaapiIntel = intel-vaapi-driver; # Added 2023-05-31
  vaapiVdpau = libva-vdpau-driver; # Added 2024-06-05
  vaultwarden-vault = vaultwarden.webvault; # Added 2022-12-13
  varnish74 = throw "varnish 7.4 is EOL. Either use the LTS or upgrade."; # Added 2024-10-31
  varnish74Packages = throw "varnish 7.4 is EOL. Either use the LTS or upgrade."; # Added 2024-10-31
  vdirsyncerStable = vdirsyncer; # Added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  ventoy-bin = ventoy; # Added 2023-04-12
  ventoy-bin-full = ventoy-full; # Added 2023-04-12
  verilog = iverilog; # Added 2024-07-12
  ViennaRNA = viennarna; # Added 2023-08-23
  vimHugeX = vim-full; # Added 2022-12-04
  vim_configurable = vim-full; # Added 2022-12-04
  vinagre = throw "'vinagre' has been removed as it has been archived upstream. Consider using 'gnome-connections' or 'remmina' instead"; # Added 2024-09-14
  libviperfx = throw "'libviperfx' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  viper4linux-gui = throw "'viper4linux-gui' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  viper4linux = throw "'viper4linux' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  virtscreen = throw "'virtscreen' has been removed, as it was broken and unmaintained"; # Added 2024-10-17
  vkBasalt = vkbasalt; # Added 2022-11-22
  vkdt-wayland = vkdt; # Added 2024-04-19
  volnoti = throw "'volnoti' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  vuze = throw "'vuze' was removed because it is unmaintained upstream and insecure (CVE-2018-13417). BiglyBT is a maintained fork."; # Added 2024-11-22
  inherit (libsForQt5.mauiPackages) vvave; # added 2022-05-17

  ### W ###
  wakatime = wakatime-cli; # 2024-05-30
  wal_e = throw "wal_e was removed as it is unmaintained upstream and depends on the removed boto package; upstream recommends using wal-g or pgbackrest"; # Added 2024-09-22
  wapp = tclPackages.wapp; # Added 2024-10-02
  wayfireApplications-unwrapped = throw ''
    'wayfireApplications-unwrapped.wayfire' has been renamed to/replaced by 'wayfire'
    'wayfireApplications-unwrapped.wayfirePlugins' has been renamed to/replaced by 'wayfirePlugins'
    'wayfireApplications-unwrapped.wcm' has been renamed to/replaced by 'wayfirePlugins.wcm'
    'wayfireApplications-unwrapped.wlroots' has been removed
  ''; # Add 2023-07-29
  waypoint = throw "waypoint has been removed from nixpkgs as the upstream project was archived"; # Added 2024-04-24
  webkitgtk = lib.warnOnInstantiate "Explicitly set the ABI version of 'webkitgtk'" webkitgtk_4_0;
  wineWayland = wine-wayland;
  win-virtio = virtio-win; # Added 2023-10-17
  wkhtmltopdf-bin = wkhtmltopdf; # Added 2024-07-17
  wlroots_0_16 = throw "'wlroots_0_16' has been removed in favor of newer versions"; # Added 2024-07-14
  wlroots = wlroots_0_18; # wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  wordpress6_3 = throw "'wordpress6_3' has been removed in favor of the latest version"; # Added 2024-08-03
  wordpress6_4 = throw "'wordpress6_4' has been removed in favor of the latest version"; # Added 2024-08-03
  wordpress6_5 = wordpress_6_5; # Added 2024-08-03
  wordpress_6_5 = throw "'wordpress_6_5' has been removed in favor of the latest version"; # Added 2024-11-11
  wordpress_6_6 = throw "'wordpress_6_6' has been removed in favor of the latest version"; # Added 2024-11-17
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name
  wpa_supplicant_ro_ssids = lib.warnOnInstantiate "Deprecated package: Please use wpa_supplicant instead. Read-only SSID patches are now upstream!" wpa_supplicant;
  wrapLisp_old = throw "Lisp packages have been redesigned. See 'lisp-modules' in the nixpkgs manual."; # Added 2024-05-07
  wmii_hg = wmii;
  wrapGAppsHook = wrapGAppsHook3; # Added 2024-03-26
  write_stylus = styluslabs-write-bin; # Added 2024-10-09

  ### X ###

  x509-limbo = throw "'x509-limbo' has been removed from nixpkgs"; # Added 2024-10-22
  xarchive = throw "'xarchive' has been removed due to lack of maintenance upstream. Consider using 'file-roller' instead"; # Added 2024-10-19
  xbmc-retroarch-advanced-launchers = throw "'xbmc-retroarch-advanced-launchers' has been renamed to/replaced by 'kodi-retroarch-advanced-launchers'"; # Converted to throw 2024-10-17
  xboxdrv = throw "'xboxdrv' has been dropped as it has been superseded by an in-tree kernel driver"; # Added 2024-12-25
  xdg_utils = throw "'xdg_utils' has been renamed to/replaced by 'xdg-utils'"; # Converted to throw 2024-10-17
  xen-light = throw "'xen-light' has been renamed to/replaced by 'xen-slim'"; # Added 2024-06-30
  xen-slim = throw "'xen-slim' has been renamed to 'xen'. The old Xen package with built-in components no longer exists"; # Added 2024-10-05
  xen_4_16 = throw "While Xen 4.16 was still security-supported when it was removed from Nixpkgs, it would have reached its End of Life a couple of days after NixOS 24.11 released. To avoid shipping an insecure version of Xen, the Xen Project Hypervisor Maintenance Team decided to delete the derivation entirely"; # Added 2024-10-05
  xen_4_17 = throw "Due to technical challenges involving building older versions of Xen with newer dependencies, the Xen Project Hypervisor Maintenance Team decided to switch to a latest-only support cycle. As Xen 4.17 would have been the 'n-2' version, it was removed"; # Added 2024-10-05
  xen_4_18 = throw "Due to technical challenges involving building older versions of Xen with newer dependencies, the Xen Project Hypervisor Maintenance Team decided to switch to a latest-only support cycle. As Xen 4.18 would have been the 'n-1' version, it was removed"; # Added 2024-10-05
  xen_4_19 = throw "Use 'xen' instead"; # Added 2024-10-05
  xenPackages = throw "The attributes in the xenPackages set have been promoted to the top-level. (xenPackages.xen_4_19 -> xen)";
  xineLib = throw "'xineLib' has been renamed to/replaced by 'xine-lib'"; # Converted to throw 2024-10-17
  xineUI = throw "'xineUI' has been renamed to/replaced by 'xine-ui'"; # Converted to throw 2024-10-17
  xlsxgrep = throw "'xlsxgrep' has been dropped due to lack of maintenance."; # Added 2024-11-01
  xmlada = gnatPackages.xmlada; # Added 2024-02-25
  xmr-stak = throw "xmr-stak has been removed from nixpkgs because it was broken"; # Added 2024-07-15
  xmake-core-sv = throw "'xmake-core-sv' has been removed, use 'libsv' instead"; # Added 2024-10-10
  xournal = throw "'xournal' has been removed due to lack of activity upstream and depending on gnome2. Consider using 'xournalpp' instead."; # Added 2024-12-06
  xonsh-unwrapped = python3Packages.xonsh; # Added 2024-06-18
  xprite-editor = throw "'xprite-editor' has been removed due to lack of maintenance upstream. Consider using 'pablodraw' or 'aseprite' instead"; # Added 2024-09-14
  xulrunner = firefox-unwrapped; # Added 2023-11-03
  xvfb_run = throw "'xvfb_run' has been renamed to/replaced by 'xvfb-run'"; # Converted to throw 2024-10-17
  xwaylandvideobridge = libsForQt5.xwaylandvideobridge; # Added 2024-09-27

  ### Y ###

  yacc = throw "'yacc' has been renamed to/replaced by 'bison'"; # Converted to throw 2024-10-17
  yesplaymusic = throw "YesPlayMusic has been removed as it was broken, unmaintained, and used deprecated Node and Electron versions"; # Added 2024-12-13
  yafaray-core = libyafaray; # Added 2022-09-23
  youtrack_2022_3 = throw "'youtrack_2022_3' has been removed as it was deprecated. Please update to the 'youtrack' package."; # Added 2024-10-17
  yrd = throw "'yrd' has been removed, as it was broken and unmaintained"; # added 2024-05-27

  ### Z ###

  zfsStable = zfs; # Added 2024-02-26
  zfsUnstable = zfs_unstable; # Added 2024-02-26
  zinc = zincsearch; # Added 2023-05-28
  zk-shell = throw "zk-shell has been removed as it was broken and unmaintained"; # Added 2024-08-10
  zkg = throw "'zkg' has been replaced by 'zeek'";
  zq = zed.overrideAttrs (old: { meta = old.meta // { mainProgram = "zq"; }; }); # Added 2023-02-06
  zz = throw "'zz' has been removed because it was archived in 2022 and had no maintainer"; # added 2024-05-10

  ### UNSORTED ###


  dina-font-pcf = throw "'dina-font-pcf' has been renamed to/replaced by 'dina-font'"; # Converted to throw 2024-10-17
  dnscrypt-proxy2 = dnscrypt-proxy; # Added 2023-02-02

  posix_man_pages = throw "'posix_man_pages' has been renamed to/replaced by 'man-pages-posix'"; # Converted to throw 2024-10-17
  ttyrec = throw "'ttyrec' has been renamed to/replaced by 'ovh-ttyrec'"; # Converted to throw 2024-10-17
  zplugin = throw "'zplugin' has been renamed to/replaced by 'zinit'"; # Converted to throw 2024-10-17
  zyn-fusion = zynaddsubfx; # Added 2022-08-05

  inherit (stdenv.hostPlatform) system; # Added 2021-10-22
  inherit (stdenv) buildPlatform hostPlatform targetPlatform; # Added 2023-01-09

  freebsdCross = freebsd; # Added 2024-09-06
  netbsdCross = netbsd; # Added 2024-09-06
  openbsdCross = openbsd; # Added 2024-09-06

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_latest = llvmPackages_19;

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

}
