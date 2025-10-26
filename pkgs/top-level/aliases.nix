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
  removeRecurseForDerivations =
    alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  transmission3Warning =
    {
      prefix ? "",
      suffix ? "",
    }:
    let
      p = "${prefix}transmission${suffix}";
      p3 = "${prefix}transmission_3${suffix}";
      p4 = "${prefix}transmission_4${suffix}";
    in
    "${p} has been renamed to ${p3} since ${p4} is also available. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)";

  deprecatedPlasma5Packages = {
    inherit (plasma5Packages)
      akonadi-calendar
      akonadi-calendar-tools
      akonadi-contacts
      akonadi-import-wizard
      akonadi-mime
      akonadi-notes
      akonadi-search
      akonadiconsole
      alligator
      analitza
      angelfish
      applet-window-appmenu
      applet-window-buttons
      audiotube
      aura-browser
      baloo-widgets
      bismuth
      booth
      buho
      calendarsupport
      calindori
      cantor
      clip
      communicator
      dolphin-plugins
      eventviews
      flatpak-kcm
      ghostwriter
      grantleetheme
      incidenceeditor
      index
      juk
      kaccounts-integration
      kaccounts-providers
      kalarm
      kalgebra
      kalk
      kamoso
      kasts
      kbreakout
      kcalutils
      kclock
      kde-inotify-survey
      kde2-decoration
      kdebugsettings
      kdeconnect-kde
      kdecoration
      kdegraphics-mobipocket
      kdegraphics-thumbnailers
      kdenetwork-filesharing
      kdepim-runtime
      keysmith
      kgeography
      khotkeys
      kidentitymanagement
      kimap
      kio-admin
      kio-extras
      kio-gdrive
      kipi-plugins
      kirigami-gallery
      kldap
      kmahjongg
      kmail-account-wizard
      kmailtransport
      kmbox
      kmime
      kmousetool
      knotes
      koko
      kolf
      kongress
      konqueror
      konquest
      kontactinterface
      kopeninghours
      kosmindoormap
      kpat
      kpimtextedit
      kpipewire
      kpmcore
      kpublictransport
      kqtquickcharts
      krecorder
      kreport
      kruler
      ksanecore
      ksmtp
      kspaceduel
      ksudoku
      ksystemstats
      ktnef
      ktrip
      kweather
      kzones
      layer-shell-qt
      libgravatar
      libkcddb
      libkdcraw
      libkdegames
      libkdepim
      libkexiv2
      libkgapi
      libkipi
      libkleo
      libkmahjongg
      libkomparediff2
      libksane
      libkscreen
      libksieve
      libksysguard
      libktorrent
      lightly
      mailcommon
      mailimporter
      mauikit
      mauikit-accounts
      mauikit-calendar
      mauikit-documents
      mauikit-filebrowsing
      mauikit-imagetools
      mauikit-terminal
      mauikit-texteditor
      mauiman
      mbox-importer
      messagelib
      oxygen-sounds
      palapeli
      parachute
      partitionmanager
      pim-data-exporter
      pim-sieve-editor
      pimcommon
      plank-player
      plasma-bigscreen
      plasma-dialer
      plasma-disks
      plasma-firewall
      plasma-phonebook
      plasma-remotecontrollers
      plasma-sdk
      plasma-settings
      plasma-welcome
      plasmatube
      polkit-kde-agent
      print-manager
      qmlkonsole
      rocs
      shelf
      sierra-breeze-enhanced
      soundkonverter
      station
      telly-skout
      tokodon
      umbrello
      vvave
      xwaylandvideobridge
      ;

    inherit (libsForQt5)
      neochat # added 2025-07-04
      itinerary # added 2025-07-04
      libquotient # added 2025-07-04
      ;

    kexi = throw ""; # Added 2025-08-21
  };

  makePlasma5Throw =
    name:
    throw (
      ''
        The libsForQt5.${name} package and the corresponding top-level ${name} alias have been removed, as KDE Gear 5 and Plasma 5 have reached end of life.
      ''
      + lib.optionalString (kdePackages ? ${name}) ''
        Please explicitly use kdePackages.${name} for the latest Qt 6-based version.
      ''
    );

  # Make sure that we are not shadowing something from all-packages.nix.
  checkInPkgs =
    n: alias:
    if builtins.hasAttr n super then abort "Alias ${n} is still in all-packages.nix" else alias;

  mapAliases =
    aliases: lib.mapAttrs (n: alias: removeRecurseForDerivations (checkInPkgs n alias)) aliases;

  plasma5Throws = mapAliases (lib.mapAttrs (k: _: makePlasma5Throw k) deprecatedPlasma5Packages);
in

mapAliases {
  forceSystem = system: _: (import self.path { localSystem = { inherit system; }; }); # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.

  # TODO: Remove from Nixpkgs and eventually turn into throws.
  system = stdenv.hostPlatform.system; # Added 2021-10-22
  buildPlatform = stdenv.buildPlatform; # Added 2023-01-09
  hostPlatform = stdenv.hostPlatform; # Added 2023-01-09
  targetPlatform = stdenv.targetPlatform; # Added 2023-01-09

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_latest = llvmPackages_21;
  llvmPackages_git = (callPackages ../development/compilers/llvm { }).git;
  # these are for convenience, not for backward compat., and shouldn't expire until the package is deprecated.
  clang18Stdenv = lowPrio llvmPackages_18.stdenv;
  clang19Stdenv = lowPrio llvmPackages_19.stdenv;

  # Various to preserve
  autoReconfHook = throw "You meant 'autoreconfHook', with a lowercase 'r'."; # preserve, reason: common typo
  elasticsearch7Plugins = elasticsearchPlugins; # preserve, reason: until v8
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve, reason: common typo
  fuse2fs = if stdenv.hostPlatform.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  wlroots = wlroots_0_19; # preserve, reason: wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name

  # keep-sorted start case=no numeric=yes block=yes

  _0verkill = throw "'_0verkill' has been removed due to lack of maintenance"; # Added 2025-08-27
  _1password = lib.warnOnInstantiate "_1password has been renamed to _1password-cli to better follow upstream name usage" _1password-cli; # Added 2024-10-24
  _2048-cli = throw "'_2048-cli' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-curses = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-terminal = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  a4term = a4; # Added 2023-10-06
  abseil-cpp_202301 = throw "abseil-cpp_202301 has been removed as it was unused in tree"; # Added 2025-08-09
  abseil-cpp_202501 = throw "abseil-cpp_202501 has been removed as it was unused in tree"; # Added 2025-09-15
  abseil-cpp_202505 = throw "abseil-cpp_202505 has been removed as it was unused in tree"; # Added 2025-09-15
  adminer-pematon = adminneo; # Added 2025-02-20
  adminerneo = adminneo; # Added 2025-02-27
  adobe-reader = throw "'adobe-reader' has been removed, as it was broken, outdated and insecure"; # added 2025-05-31
  afpfs-ng = throw "'afpfs-ng' has been removed as it was broken and unmaintained for 10 years"; # Added 2025-05-17
  akkoma-emoji = lib.warnOnInstantiate "'akkoma-emoji.blobs_gg' has been renamed to 'blobs_gg'" blobs_gg; # Added 2025-03-14
  akkoma-frontends.admin-fe = lib.warnOnInstantiate "'akkoma-frontends.admin-fe' has been renamed to 'akkoma-admin-fe'" akkoma-admin-fe; # Added 2025-03-14
  akkoma-frontends.akkoma-fe = lib.warnOnInstantiate "'akkoma-frontends.akkoma-fe' has been renamed to 'akkoma-fe'" akkoma-fe; # Added 2025-03-14
  amazon-qldb-shell = throw "'amazon-qldb-shell' has been removed due to being unmaintained upstream"; # Added 2025-07-30
  amdvlk = throw "'amdvlk' has been removed since it was deprecated by AMD. Its replacement, RADV, is enabled by default."; # Added 2025-09-20
  android-udev-rules = throw "'android-udev-rules' has been removed due to being superseded by built-in systemd uaccess rules."; # Added 2025-10-21
  androidndkPkgs_21 = throw "androidndkPkgs_21 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_23 = throw "androidndkPkgs_23 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_23b = throw "androidndkPkgs_23b has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_24 = throw "androidndkPkgs_24 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_25 = throw "androidndkPkgs_25 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_26 = throw "androidndkPkgs_26 has been removed, as it is EOL"; # Added 2025-08-09
  animeko = throw "'animeko' has been removed since it is unmaintained"; # Added 2025-08-20
  ansible-language-server = throw "ansible-language-server was removed, because it was unmaintained in nixpkgs."; # Added 2025-09-24
  ansible-later = throw "ansible-later has been discontinued. The author recommends switching to ansible-lint"; # Added 2025-08-24
  antlr4_8 = throw "antlr4_8 has been removed. Consider using a more recent version of antlr4"; # Added 2025-10-20
  ao = libfive; # Added 2024-10-11
  apacheAnt = ant; # Added 2024-11-28
  apacheKafka_3_7 = throw "apacheKafka_2_8 through _3_8 have been removed from nixpkgs as outdated"; # Added 2025-09-27
  apacheKafka_3_8 = throw "apacheKafka_2_8 through _3_8 have been removed from nixpkgs as outdated"; # Added 2025-09-27
  appthreat-depscan = dep-scan; # Added 2024-04-10
  arangodb = throw "arangodb has been removed, as it was unmaintained and the packaged version does not build with supported GCC versions"; # Added 2025-08-12
  arc-browser = throw "arc-browser was removed due to being unmaintained"; # Added 2025-09-03
  archipelago-minecraft = throw "archipelago-minecraft has been removed, as upstream no longer ships minecraft as a default APWorld."; # Added 2025-07-15
  archivebox = throw "archivebox has been removed, since the packaged version was stuck on django 3."; # Added 2025-08-01
  ardour_7 = throw "ardour_7 has been removed because it relies on gtk2, please use ardour instead."; # Aded 2025-10-04
  argo = argo-workflows; # Added 2025-02-01
  aria = aria2; # Added 2024-03-26
  arrayfire = throw "arrayfire was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  artim-dark = aritim-dark; # Added 2025-07-27
  aseprite-unfree = aseprite; # Added 2023-08-26
  asitop = macpm; # Added 2025-04-14
  asterisk_18 = throw "asterisk_18: Asterisk 18 is end of life and has been removed"; # Added 2025-10-19
  ats = throw "'ats' has been removed as it is unmaintained for 10 years and broken"; # Added 2025-05-17
  AusweisApp2 = ausweisapp; # Added 2023-11-08
  autoconf213 = throw "'autoconf213' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  autoconf264 = throw "'autoconf264' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  automake111x = throw "'automake111x' has been removed in favor of 'automake'"; # Added 2025-07-21
  autopanosiftc = throw "'autopanosiftc' has been removed, as it is unmaintained upstream"; # Added 2025-10-07
  autoreconfHook264 = throw "'autoreconfHook264' has been removed in favor of 'autoreconfHook'"; # Added 2025-07-21
  av-98 = throw "'av-98' has been removed because it has been broken since at least November 2024."; # Added 2025-10-03
  avr-sim = throw "'avr-sim' has been removed as it was broken and unmaintained. Possible alternatives are 'simavr', SimulAVR and AVRStudio."; # Added 2025-05-31
  awesome-4-0 = awesome; # Added 2022-05-05
  awf = throw "'awf' has been removed as the upstream project was archived in 2021"; # Added 2025-10-03
  axmldec = throw "'axmldec' has been removed as it was broken and unmaintained for 8 years"; # Added 2025-05-17
  backlight-auto = throw "'backlight-auto' has been removed as it relies on Zig 0.12 which has been dropped."; # Added 2025-08-22
  badtouch = authoscope; # Added 2021-06-26
  bandwidth = throw "'bandwidth' has been removed due to lack of maintenance"; # Added 2025-09-01
  banking = saldo; # added 2025-08-29
  barrier = throw "'barrier' has been removed as it is unmaintained. Consider 'deskflow' or 'input-leap' instead."; # Added 2025-09-29
  base16-builder = throw "'base16-builder' has been removed due to being unmaintained"; # Added 2025-06-03
  baserow = throw "baserow has been removed, due to lack of maintenance"; # Added 2025-08-02
  bazel_5 = throw "bazel_5 has been removed as it is EOL"; # Added 2025-08-09
  bazel_6 = throw "bazel_6 has been removed as it will be EOL by the release of Nixpkgs 25.11"; # Added 2025-08-19
  bc-decaf = throw "'bc-decaf' has been moved to 'linphonePackages.bc-decaf'"; # Added 2025-09-20
  bc-soci = throw "'bc-soci' has been moved to 'linphonePackages.bc-soci'"; # Added 2025-09-20
  bctoolbox = throw "'bctoolbox' has been moved to 'linphonePackages.bctoolbox'"; # Added 2025-09-20
  bcunit = throw "'bcunit' has been moved to 'linphonePackages.bcunit'"; # Added 2025-09-20
  beets-unstable = throw "beets-unstable has been removed in favor of beets since upstream is releasing versions frequently nowadays"; # Added 2025-10-16
  beetsPackages = throw "beetsPackages were replaced with python3.pkgs.beets- prefixed attributes, and top-level beets* attributes"; # Added 2025-10-16
  belcard = throw "'belcard' has been moved to 'linphonePackages.belcard'"; # Added 2025-09-20
  belle-sip = throw "'belle-sip' has been moved to 'linphonePackages.belle-sip'"; # Added 2025-09-20
  belr = throw "'belr' has been moved to 'linphonePackages.belr'"; # Added 2025-09-20
  bfc = throw "bfc has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  bindle = throw "bindle has been removed since it is vulnerable to CVE-2025-62518 and upstream has been archived"; # Added 2025-10-24
  bitbucket-server-cli = throw "bitbucket-server-cli has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  bitcoin-abc = throw "bitcoin-abc has been removed due to a lack of maintanance"; # Added 2025-06-17
  bitcoind-abc = throw "bitcoind-abc has been removed due to a lack of maintanance"; # Added 2025-06-17
  bitmeter = throw "bitmeter has been removed, use `x42-meter 18` from the x42-plugins pkg instead."; # Added 2025-10-03
  bitwarden = bitwarden-desktop; # Added 2024-02-25
  bitwarden_rs = vaultwarden; # Added 2021-07-01
  bitwarden_rs-mysql = vaultwarden-mysql; # Added 2021-07-01
  bitwarden_rs-postgresql = vaultwarden-postgresql; # Added 2021-07-01
  bitwarden_rs-sqlite = vaultwarden-sqlite; # Added 2021-07-01
  bitwarden_rs-vault = vaultwarden-vault; # Added 2021-07-01
  blas-reference = throw "blas-reference has been removed since it has been discontinued as free-standing package. It is now contained within lapack-reference."; # Added 2025-10-21
  blender-with-packages = throw "blender-with-packages is deprecated in in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"; # Converted to throw 2025-10-26
  blockbench-electron = blockbench; # Added 2024-03-16
  bloomeetunes = throw "bloomeetunes is unmaintained and has been removed"; # Added 2025-08-26
  bmap-tools = bmaptool; # Added 2024-08-05
  botan2 = throw "botan2 has been removed as it is EOL"; # Added 2025-10-20
  bower2nix = throw "bower2nix has been removed as bower was removed. It is recommended to migrate to yarn."; # Added 2025-09-17
  brasero-original = lib.warnOnInstantiate "Use 'brasero-unwrapped' instead of 'brasero-original'" brasero-unwrapped; # Added 2024-09-29
  breath-theme = throw "'breath-theme' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  brogue = lib.warnOnInstantiate "Use 'brogue-ce' instead of 'brogue' for updated releases" brogue-ce; # Added 2025-10-04
  buildBowerComponents = throw "buildBowerComponents has been removed as bower was removed. It is recommended to migrate to yarn."; # Added 2025-09-17
  buildGo123Module = throw "Go 1.23 is end-of-life, and 'buildGo123Module' has been removed. Please use a newer builder version."; # Added 2025-08-13
  buildXenPackage = throw "'buildXenPackage' has been removed as a custom Xen build can now be achieved by simply overriding 'xen'."; # Added 2025-05-12
  bwidget = tclPackages.bwidget; # Added 2024-10-02
  bzrtp = throw "'bzrtp' has been moved to 'linphonePackages.bzrtp'"; # Added 2025-09-20
  calculix = calculix-ccx; # Added 2024-12-18
  calligra = kdePackages.calligra; # Added 2024-09-27
  callPackage_i686 = pkgsi686Linux.callPackage; # Added 2018-07-26
  canonicalize-jars-hook = stripJavaArchivesHook; # Added 2024-03-17
  cardboard = throw "cardboard has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  cargo-espflash = espflash; # Added 2024-02-09
  cargonode = throw "'cargonode' has been removed due to lack of upstream maintenance"; # Added 2025-06-18
  cask = emacs.pkgs.cask; # Added 2022-11-12
  catalyst-browser = throw "'catalyst-browser' has been removed due to a lack of maintenance and not satisfying our security criteria for browsers."; # Added 2025-06-25
  cataract = throw "'cataract' has been removed due to a lack of maintenace"; # Added 2025-08-25
  cataract-unstable = throw "'cataract-unstable' has been removed due to a lack of maintenace"; # Added 2025-08-25
  catch = throw "catch has been removed. Please upgrade to catch2 or catch2_3"; # Added 2025-08-21
  cereal_1_3_0 = throw "cereal_1_3_0 has been removed as it was unused; use cereal intsead"; # Added 2025-09-12
  cereal_1_3_2 = throw "cereal_1_3_2 is now the only version and has been renamed to cereal"; # Added 2025-09-12
  certmgr-selfsigned = certmgr; # Added 2023-11-30
  challenger = taler-challenger; # Added 2024-09-04
  charmcraft = throw "charmcraft was removed in Sep 25 following removal of LXD from nixpkgs"; # added 2025-09-18
  chatgpt-retrieval-plugin = throw "chatgpt-retrieval-plugin has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  check-esxi-hardware = nagiosPlugins.check_esxi_hardware; # Added 2024-05-03
  check-mssql-health = nagiosPlugins.check_mssql_health; # Added 2024-05-03
  check-nwc-health = nagiosPlugins.check_nwc_health; # Added 2024-05-03
  check-openvpn = nagiosPlugins.check_openvpn; # Added 2024-05-03
  check-ups-health = nagiosPlugins.check_ups_health; # Added 2024-05-03
  check-uptime = nagiosPlugins.check_uptime; # Added 2024-05-03
  check-wmiplus = nagiosPlugins.check_wmi_plus; # Added 2024-05-03
  check_smartmon = nagiosPlugins.check_smartmon; # Added 2024-05-03
  check_systemd = nagiosPlugins.check_systemd; # Added 2024-05-03
  check_zfs = nagiosPlugins.check_zfs; # Added 2024-05-03
  checkSSLCert = nagiosPlugins.check_ssl_cert; # Added 2024-05-03
  chiaki4deck = chiaki-ng; # Added 2024-08-04
  chkrootkit = throw "chkrootkit has been removed as it is unmaintained and archived upstream and didn't even work on NixOS"; # Added 2025-09-12
  chocolateDoom = chocolate-doom; # Added 2023-05-01
  ChowCentaur = chow-centaur; # Added 2024-06-12
  ChowKick = chow-kick; # Added 2024-06-12
  ChowPhaser = chow-phaser; # Added 2024-06-12
  CHOWTapeModel = chow-tape-model; # Added 2024-06-12
  chrome-gnome-shell = gnome-browser-connector; # Added 2022-07-27
  ci-edit = throw "'ci-edit' has been removed due to lack of maintenance upstream"; # Added 2025-08-26
  cinnamon-common = cinnamon; # Added 2025-08-06
  clamsmtp = throw "'clamsmtp' has been removed as it is unmaintained and broken"; # Added 2025-05-17
  clang12Stdenv = throw "clang12Stdenv has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang13Stdenv = throw "clang13Stdenv has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang14Stdenv = throw "clang14Stdenv has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang15Stdenv = throw "clang15Stdenv has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  clang16Stdenv = throw "clang16Stdenv has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clang17Stdenv = throw "clang17Stdenv has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clang-tools_12 = throw "clang-tools_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang-tools_13 = throw "clang-tools_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang-tools_14 = throw "clang-tools_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang-tools_15 = throw "clang-tools_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  clang-tools_16 = throw "clang-tools_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clang-tools_17 = throw "clang-tools_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clang-tools_18 = llvmPackages_18.clang-tools; # Added 2024-04-22
  clang-tools_19 = llvmPackages_19.clang-tools; # Added 2024-08-21
  clang_12 = throw "clang_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang_13 = throw "clang_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang_14 = throw "clang_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang_15 = throw "clang_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  clang_16 = throw "clang_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clang_17 = throw "clang_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clasp = clingo; # added 2022-12-22
  cli-visualizer = throw "'cli-visualizer' has been removed as the upstream repository is gone"; # Added 2025-06-05
  clipbuzz = throw "clipbuzz has been removed, as it does not build with supported Zig versions"; # Added 2025-08-09
  cloudlogoffline = throw "cloudlogoffline has been removed"; # added 2025-05-18
  cockroachdb-bin = cockroachdb; # 2024-03-15
  code-browser-gtk2 = throw "'code-browser-gtk2' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  code-browser-gtk = throw "'code-browser-gtk' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  code-browser-qt = throw "'code-browser-qt' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  cog = throw "'cog' has been removed as it depends on unmaintained libraries"; # Added 2025-10-08
  CoinMP = coinmp; # Added 2024-06-12
  collada2gltf = throw "collada2gltf has been removed from Nixpkgs, as it has been unmaintained upstream for 5 years and does not build with supported GCC versions"; # Addd 2025-08-08
  colloid-kde = throw "'colloid-kde' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  colorstorm = throw "'colorstorm' has been removed because it was unmaintained in nixpkgs and upstream was rewritten."; # Added 2025-06-15
  conduwuit = throw "'conduwuit' has been removed as the upstream repository has been deleted. Consider migrating to 'matrix-conduit', 'matrix-continuwuity' or 'matrix-tuwunel' instead."; # Added 2025-08-08
  cone = throw "cone has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  connman-ncurses = throw "'connman-ncurses' has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  copilot-language-server-fhs = lib.warnOnInstantiate "The package set `copilot-language-server-fhs` has been renamed to `copilot-language-server`." copilot-language-server; # Added 2025-09-07
  copper = throw "'copper' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  cordless = throw "'cordless' has been removed due to being archived upstream. Consider using 'discordo' instead."; # Added 2025-06-07
  cosmic-tasks = tasks; # Added 2024-07-04
  cotton = throw "'cotton' has been removed since it is vulnerable to CVE-2025-62518 and upstream is unmaintained"; # Added 2025-10-26
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  crispyDoom = crispy-doom; # Added 2023-05-01
  critcl = tclPackages.critcl; # Added 2024-10-02
  cromite = throw "'cromite' has been removed from nixpkgs due to it not being maintained"; # Added 2025-06-12
  crossLibcStdenv = stdenvNoLibc; # Added 2024-09-06
  crystal_1_11 = throw "'crystal_1_11' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-09-04
  cstore_fdw = throw "'cstore_fdw' has been removed. Use 'postgresqlPackages.cstore_fdw' instead."; # Added 2025-07-19
  cudaPackages_11 = throw "CUDA 11 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_0 = throw "CUDA 11.0 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_1 = throw "CUDA 11.1 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_2 = throw "CUDA 11.2 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_3 = throw "CUDA 11.3 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_4 = throw "CUDA 11.4 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_5 = throw "CUDA 11.5 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_6 = throw "CUDA 11.6 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_7 = throw "CUDA 11.7 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_8 = throw "CUDA 11.8 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_0 = throw "CUDA 12.0 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_1 = throw "CUDA 12.1 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_2 = throw "CUDA 12.2 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_3 = throw "CUDA 12.3 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_4 = throw "CUDA 12.4 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_5 = throw "CUDA 12.5 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cups-kyodialog3 = cups-kyodialog; # Added 2022-11-12
  curlHTTP3 = lib.warnOnInstantiate "'curlHTTP3' has been removed, as 'curl' now has HTTP/3 support enabled by default" curl; # Added 2025-08-22
  cyber = throw "cyber has been removed, as it does not build with supported Zig versions"; # Added 2025-08-09
  dale = throw "dale has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  daq = throw "'daq' has been removed as it is unmaintained and broken. Snort2 has also been removed, which depended on this"; # Added 2025-05-21
  daytona-bin = throw "'daytona-bin' has been removed, as it was unmaintained in nixpkgs"; # Added 2025-07-21
  dbench = throw "'dbench' has been removed as it is unmaintained for 14 years and broken"; # Added 2025-05-17
  dbus-sharp-1_0 = throw "'dbus-sharp-1_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dbus-sharp-2_0 = throw "'dbus-sharp-2_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dbus-sharp-glib-1_0 = throw "'dbus-sharp-glib-1_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dbus-sharp-glib-2_0 = throw "'dbus-sharp-glib-2_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dclib = throw "'dclib' has been removed as it is unmaintained for 16 years and broken"; # Added 2025-05-25
  deadpixi-sam = deadpixi-sam-unstable; # Added 2018-05-01
  deepin = throw "the Deepin desktop environment and associated tools have been removed from nixpkgs due to lack of maintenance"; # Added 2025-08-21
  deepsea = throw "deepsea has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  degit-rs = throw "'degit-rs' has been removed because it is unmaintained upstream and has vulnerable dependencies."; # Added 2025-07-11
  deltachat-cursed = arcanechat-tui; # added 2025-02-25
  devdocs-desktop = throw "'devdocs-desktop' has been removed as it is unmaintained upstream and vendors insecure dependencies"; # Added 2025-06-11
  dfilemanager = throw "'dfilemanager' has been dropped as it was unmaintained"; # Added 2025-06-03
  dleyna-connector-dbus = dleyna; # Added 2025-04-19
  dleyna-core = dleyna; # Added 2025-04-19
  dleyna-renderer = dleyna; # Added 2025-04-19
  dleyna-server = dleyna; # Added 2025-04-19
  dnscrypt-proxy2 = dnscrypt-proxy; # Added 2023-02-02
  docker-distribution = distribution; # Added 2023-12-26
  docker-sync = throw "'docker-sync' has been removed because it was broken and unmaintained"; # Added 2025-08-26
  docker_26 = throw "'docker_26' has been removed because it has been unmaintained since February 2025. Use docker_28 or newer instead."; # Added 2025-06-21
  docker_27 = throw "'docker_27' has been removed because it has been unmaintained since May 2025. Use docker_28 or newer instead."; # Added 2025-06-15
  dockerfile-language-server-nodejs = lib.warnOnInstantiate "'dockerfile-language-server-nodejs' has been renamed to 'dockerfile-language-server'" dockerfile-language-server; # Added 2025-09-12
  dolphin-emu-beta = dolphin-emu; # Added 2023-02-11
  dotnetenv = throw "'dotnetenv' has been removed because it was unmaintained in Nixpkgs"; # Added 2025-07-11
  dotty = scala_3; # Added 2023-08-20
  dovecot_fts_xapian = throw "'dovecot_fts_xapian' has been removed because it was unmaintained in Nixpkgs. Consider using dovecot-fts-flatcurve instead"; # Added 2025-08-16
  dsd = throw "dsd has been removed, as it was broken and lack of upstream maintenance"; # Added 2025-08-25
  dtv-scan-tables_linuxtv = dtv-scan-tables; # Added 2023-03-03
  dtv-scan-tables_tvheadend = dtv-scan-tables; # Added 2023-03-03
  du-dust = dust; # Added 2024-01-19
  duckstation-bin = duckstation; # Added 2025-09-20
  dumb = throw "'dumb' has been archived by upstream. Upstream recommends libopenmpt as a replacement."; # Added 2025-09-14
  dump1090 = dump1090-fa; # Added 2024-02-12
  eask = eask-cli; # Added 2024-09-05
  easyloggingpp = throw "easyloggingpp has been removed, as it is deprecated upstream and does not build with CMake 4"; # Added 2025-09-17
  EBTKS = ebtks; # Added 2024-01-21
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01
  edid-decode = v4l-utils; # Added 2025-06-20
  eidolon = throw "eidolon was removed as it is unmaintained upstream."; # Added 2025-05-28
  eintopf = lauti; # Project was renamed, added 2025-05-01
  elementsd-simplicity = throw "'elementsd-simplicity' has been removed due to lack of maintenance, consider using 'elementsd' instead"; # Added 2025-06-04
  elixir_ls = elixir-ls; # Added 2023-03-20
  elm-github-install = throw "'elm-github-install' has been removed as it is abandoned upstream and only supports Elm 0.18.0"; # Added 2025-08-25
  emacsMacport = emacs-macport; # Added 2023-08-10
  emacsNativeComp = emacs; # Added 2022-06-08
  emacsPackages = emacs.pkgs; # Added 2025-03-02
  embree2 = throw "embree2 has been removed, as it is unmaintained upstream and depended on tbb_2020"; # Added 2025-09-14
  EmptyEpsilon = empty-epsilon; # Added 2024-07-14
  emulationstation = throw "emulationstation was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  emulationstation-de = throw "emulationstation-de was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  enyo-doom = enyo-launcher; # Added 2022-09-09
  epapirus-icon-theme = throw "'epapirus-icon-theme' has been removed because 'papirus-icon-theme' no longer supports building with elementaryOS icon support"; # Added 2025-06-15
  eris-go = throw "'eris-go' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  eriscmd = throw "'eriscmd' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  erlang-ls = throw "'erlang-ls' has been removed as it has been archived upstream. Consider using 'erlang-language-platform' instead"; # Added 2025-10-02
  eww-wayland = lib.warnOnInstantiate "eww now can build for X11 and wayland simultaneously, so `eww-wayland` is deprecated, use the normal `eww` package instead." eww; # Added 2024-02-17
  f3d_egl = lib.warnOnInstantiate "'f3d' now build with egl support by default, so `f3d_egl` is deprecated, consider using 'f3d' instead." f3d; # added 2025-07-18
  fastnlo_toolkit = fastnlo-toolkit; # Added 2024-01-03
  faustStk = faustPhysicalModeling; # Added 2023-05-16
  fbjni = throw "fbjni has been removed, as it was broken"; # Added 2025-08-25
  fcitx5-catppuccin = catppuccin-fcitx5; # Added 2024-06-19
  fcitx5-chinese-addons = qt6Packages.fcitx5-chinese-addons; # Added 2024-03-01
  fcitx5-configtool = qt6Packages.fcitx5-configtool; # Added 2024-03-01
  fcitx5-skk-qt = qt6Packages.fcitx5-skk-qt; # Added 2024-03-01
  fcitx5-unikey = qt6Packages.fcitx5-unikey; # Added 2024-03-01
  fcitx5-with-addons = qt6Packages.fcitx5-with-addons; # Added 2024-03-01
  fennel = luaPackages.fennel; # Added 2022-09-24
  fetchbower = throw "fetchbower has been removed as bower was removed. It is recommended to migrate to yarn."; # Added 2025-09-17
  FIL-plugins = fil-plugins; # Added 2024-06-12
  filesender = throw "'filesender' has been removed because of its simplesamlphp dependency"; # Added 2025-10-17
  finger_bsd = bsd-finger; # Added 2022-03-14
  fingerd_bsd = bsd-fingerd; # Added 2022-03-14
  fira-code-nerdfont = lib.warnOnInstantiate "fira-code-nerdfont is redundant. Use nerd-fonts.fira-code instead." nerd-fonts.fira-code; # Added 2024-11-10
  firebird_2_5 = throw "'firebird_2_5' has been removed as it has reached end-of-life and does not build."; # Added 2025-06-10
  firefox-beta-bin = lib.warnOnInstantiate "`firefox-beta-bin` is removed.  Please use `firefox-beta` or `firefox-bin` instead." firefox-beta; # Added 2025-06-06
  firefox-devedition-bin = lib.warnOnInstantiate "`firefox-devedition-bin` is removed.  Please use `firefox-devedition` or `firefox-bin` instead." firefox-devedition; # Added 2025-06-06
  firefox-esr-128 = throw "The Firefox 128 ESR series has reached its end of life. Upgrade to `firefox-esr` or `firefox-esr-140` instead."; # Added 2025-08-21
  firefox-esr-128-unwrapped = throw "The Firefox 128 ESR series has reached its end of life. Upgrade to `firefox-esr-unwrapped` or `firefox-esr-140-unwrapped` instead."; # Added 2025-08-21
  firefox-wayland = firefox; # Added 2022-11-15
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  fit-trackee = fittrackee; # added 2024-09-03
  flashrom-stable = flashprog; # Added 2024-03-01
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  flint3 = flint; # Added 2025-09-21
  floorp = throw "floorp has been replaced with floorp-bin, as building from upstream sources has become unfeasible starting with version 12.x"; # Added 2025-09-06
  floorp-unwrapped = throw "floorp-unwrapped has been replaced with floorp-bin-unwrapped, as building from upstream sources has become unfeasible starting with version 12.x"; # Added 2025-09-06
  flow-editor = flow-control; # Added 2025-03-05
  flut-renamer = throw "flut-renamer is unmaintained and has been removed"; # Added 2025-08-26
  flutter326 = throw "flutter326 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2025-06-08
  fmsynth = throw "'fmsynth' has been removed as it was broken and unmaintained both upstream and in nixpkgs."; # Added 2025-09-01
  follow = lib.warnOnInstantiate "follow has been renamed to folo" folo; # Added 2025-05-18
  forge = throw "forge was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  forgejo-actions-runner = forgejo-runner; # Added 2024-04-04
  fractal-next = fractal; # added 2023-11-25
  framework-system-tools = framework-tool; # added 2023-12-09
  francis = kdePackages.francis; # added 2024-07-13
  freebsdCross = freebsd; # Added 2024-09-06
  freecad-qt6 = freecad; # added 2025-06-14
  freecad-wayland = freecad; # added 2025-06-14
  freeimage = throw "freeimage was removed due to numerous vulnerabilities"; # Added 2025-10-23
  freerdp3 = freerdp; # added 2025-03-25
  freerdpUnstable = freerdp; # added 2025-03-25
  fusee-launcher = throw "'fusee-launcher' was removed as upstream removed the original source repository fearing legal repercussions"; # added 2025-07-05
  futuresql = libsForQt5.futuresql; # added 2023-11-11
  fx_cast_bridge = fx-cast-bridge; # added 2023-07-26
  g4music = gapless; # Added 2024-07-26
  gamecube-tools = throw "gamecube-tools was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  garage_0_8 = throw "'garage_0_8' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_0_8_7 = throw "'garage_0_8_7' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_0_9 = throw "'garage_0_9' has been removed as it is unmaintained upstream"; # Added 2025-09-16
  garage_0_9_4 = throw "'garage_0_9_4' has been removed as it is unmaintained upstream"; # Added 2025-09-16
  garage_1_2_0 = throw "'garage_1_2_0' has been removed. Use 'garage_1' instead."; # Added 2025-09-16
  garage_1_x = lib.warnOnInstantiate "'garage_1_x' has been renamed to 'garage_1'" garage_1; # Added 2025-06-23
  garage_2_0_0 = throw "'garage_2_0_0' has been removed. Use 'garage_2' instead."; # Added 2025-09-16
  gcc9 = throw "gcc9 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc9Stdenv = throw "gcc9Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc10 = throw "gcc10 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc10Stdenv = throw "gcc10Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc10StdenvCompat = throw "gcc10StdenvCompat has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc11 = throw "gcc11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc11Stdenv = throw "gcc11Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc12 = throw "gcc12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc12Stdenv = throw "gcc12Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gccgo12 = throw "gccgo12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gdc11 = throw "gdc11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gdc = throw "gdc has been removed from Nixpkgs, as recent versions require complex bootstrapping"; # Added 2025-08-08
  gdmd = throw "gdmd has been removed from Nixpkgs, as it depends on GDC which was removed"; # Added 2025-08-08
  geos_3_9 = throw "geos_3_9 has been removed from nixpkgs. Please use a more recent 'geos' instead."; # Added 2025-09-21
  gfortran9 = throw "gfortran9 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran10 = throw "gfortran10 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran11 = throw "gfortran11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran12 = throw "gfortran12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gg = go-graft; # Added 2025-03-07
  ggobi = throw "'ggobi' has been removed from Nixpkgs, as it is unmaintained and broken"; # Added 2025-05-18
  gimp3 = gimp; # added 2025-10-03
  gimp3-with-plugins = gimp-with-plugins; # added 2025-10-03
  gimp3Plugins = gimpPlugins; # added 2025-10-03
  gitAndTools = throw "gitAndTools has been removed, as the packages are now available at the top level"; # Converted to throw 2025-10-26
  gitversion = throw "'gitversion' has been removed because it produced a broken build and was unmaintained"; # Added 2025-08-30
  gjay = throw "'gjay' has been removed as it is unmaintained upstream"; # Added 2025-05-25
  glabels = throw "'glabels' has been removed because it is no longer maintained. Consider using 'glabels-qt', which is an active fork."; # Added 2025-09-16
  glaxnimate = kdePackages.glaxnimate; # Added 2025-09-17
  glew-egl = lib.warnOnInstantiate "'glew-egl' is now provided by 'glew' directly" glew; # Added 2024-08-11
  glfw-wayland = glfw; # Added 2024-04-19
  glfw-wayland-minecraft = glfw3-minecraft; # Added 2024-05-08
  glxinfo = mesa-demos; # Added 2024-07-04
  gmnisrv = throw "'gmnisrv' has been removed due to lack of maintenance upstream"; # Added 2025-06-07
  gnat11 = throw "gnat11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat12 = throw "gnat12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat12Packages = throw "gnat12Packages has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat-bootstrap11 = throw "gnat-bootstrap11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat-bootstrap12 = throw "gnat-bootstrap12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot11 = throw "gnatboot11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot12 = throw "gnatboot12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot = gnat-bootstrap; # Added 2023-04-07
  gnatcoll-core = gnatPackages.gnatcoll-core; # Added 2024-02-25
  gnatcoll-db2ada = gnatPackages.gnatcoll-db2ada; # Added 2024-02-25
  gnatcoll-gmp = gnatPackages.gnatcoll-gmp; # Added 2024-02-25
  gnatcoll-iconv = gnatPackages.gnatcoll-iconv; # Added 2024-02-25
  gnatcoll-lzma = gnatPackages.gnatcoll-lzma; # Added 2024-02-25
  gnatcoll-omp = gnatPackages.gnatcoll-omp; # Added 2024-02-25
  gnatcoll-postgres = gnatPackages.gnatcoll-postgres; # Added 2024-02-25
  gnatcoll-python3 = gnatPackages.gnatcoll-python3; # Added 2024-02-25
  gnatcoll-readline = gnatPackages.gnatcoll-readline; # Added 2024-02-25
  gnatcoll-sql = gnatPackages.gnatcoll-sql; # Added 2024-02-25
  gnatcoll-sqlite = gnatPackages.gnatcoll-sqlite; # Added 2024-02-25
  gnatcoll-syslog = gnatPackages.gnatcoll-syslog; # Added 2024-02-25
  gnatcoll-xref = gnatPackages.gnatcoll-xref; # Added 2024-02-25
  gnatcoll-zlib = gnatPackages.gnatcoll-zlib; # Added 2024-02-25
  gnatinspect = gnatPackages.gnatinspect; # Added 2024-02-25
  gnome-firmware-updater = gnome-firmware; # added 2022-04-14
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome-resources = resources; # added 2023-12-10
  gnu-cobol = gnucobol; # Added 2024-09-17
  gnubik = throw "'gnubik' has been removed due to lack of maintainance upstream and its dependency on GTK 2"; # Added 2025-09-16
  go-thumbnailer = thud; # Added 2023-09-21
  go-upower-notify = upower-notify; # Added 2024-07-21
  go_1_23 = throw "Go 1.23 is end-of-life and 'go_1_23' has been removed. Please use a newer Go toolchain."; # Added 2025-08-13
  godot-export-templates = lib.warnOnInstantiate "godot-export-templates has been renamed to godot-export-templates-bin" godot-export-templates-bin; # Added 2025-03-27
  godot_4-export-templates = lib.warnOnInstantiate "godot_4-export-templates has been renamed to godot_4-export-templates-bin" godot_4-export-templates-bin; # Added 2025-03-27
  godot_4_3-export-templates = lib.warnOnInstantiate "godot_4_3-export-templates has been renamed to godot_4_3-export-templates-bin" godot_4_3-export-templates-bin; # Added 2025-03-27
  godot_4_4-export-templates = lib.warnOnInstantiate "godot_4_4-export-templates has been renamed to godot_4_4-export-templates-bin" godot_4_4-export-templates-bin; # Added 2025-03-27
  goldwarden = throw "'goldwarden' has been removed, as it no longer works with new Bitwarden versions and is abandoned upstream"; # Added 2025-09-16
  gprbuild-boot = gnatPackages.gprbuild-boot; # Added 2024-02-25
  gpxsee-qt5 = throw "gpxsee-qt5 was removed, use gpxsee instead"; # added 2025-09-09
  gpxsee-qt6 = gpxsee; # added 2025-09-09
  gr-framework = throw "gr-framework has been removed, as it was broken"; # Added 2025-08-25
  graalvm-ce = graalvmPackages.graalvm-ce; # Added 2024-08-10
  graalvm-oracle = graalvmPackages.graalvm-oracle; # Added 2024-12-17
  graalvmCEPackages = graalvmPackages; # Added 2024-08-10
  gradience = throw "`gradience` has been removed because it was archived upstream."; # Added 2025-09-20
  grafana_reporter = grafana-reporter; # Added 2024-06-09
  graphite-kde-theme = throw "'graphite-kde-theme' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  gringo = clingo; # added 2022-11-27
  grub2_full = grub2; # Added 2022-11-18
  gtkcord4 = dissent; # Added 2024-03-10
  gtkextra = throw "'gtkextra' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  guile-disarchive = disarchive; # Added 2023-10-27
  guile-sdl = throw "guile-sdl has been removed, as it was broken"; # Added 2025-08-25
  gutenprintBin = gutenprint-bin; # Added 2025-08-21
  gxneur = throw "'gxneur' has been removed due to lack of maintenance and reliance on gnome2 and 2to3."; # Added 2025-08-17
  hacpack = throw "hacpack has been removed from nixpkgs, as it has been taken down upstream"; # added 2025-09-26
  harmony-music = throw "harmony-music is unmaintained and has been removed"; # Added 2025-08-26
  HentaiAtHome = hentai-at-home; # Added 2024-06-12
  hiawatha = throw "hiawatha has been removed, since it is no longer actively supported upstream, nor well maintained in nixpkgs"; # Added 2025-09-10
  hibernate = throw "hibernate has been removed due to lack of maintenance"; # Added 2025-09-10
  hiddify-app = throw "hiddify-app has been removed, since it is unmaintained"; # added 2025-08-20
  himitsu-firefox = throw "himitsu-firefox has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-11
  hobbes = throw "hobbes has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-20
  hpmyroom = throw "hpmyroom has been removed because it has been marked as broken since May 2024."; # Added 2025-10-11
  hpp-fcl = coal; # Added 2024-11-15
  hydra_unstable = hydra; # Added 2024-08-22
  i3-gaps = i3; # Added 2023-01-03
  ibm-sw-tpm2 = throw "ibm-sw-tpm2 has been removed, as it was broken"; # Added 2025-08-25
  ikos = throw "ikos has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  imaginer = throw "'imaginer' has been removed due to lack of upstream maintenance"; # Added 2025-08-15
  immersed-vr = lib.warnOnInstantiate "'immersed-vr' has been renamed to 'immersed'" immersed; # Added 2024-08-11
  inconsolata-nerdfont = lib.warnOnInstantiate "inconsolata-nerdfont is redundant. Use nerd-fonts.inconsolata instead." nerd-fonts.inconsolata; # Added 2024-11-10
  incrtcl = tclPackages.incrtcl; # Added 2024-10-02
  inotifyTools = inotify-tools; # Added 2015-09-01
  insync-emblem-icons = throw "'insync-emblem-icons' has been removed, use 'insync-nautilus' instead"; # Added 2025-05-14
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  invoiceplane = throw "'invoiceplane' doesn't support non-EOL PHP versions"; # Added 2025-10-03
  ioccheck = throw "ioccheck was dropped since it was unmaintained."; # Added 2025-07-06
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ir.lv2 = ir-lv2; # Added 2025-09-37
  isl_0_24 = throw "isl_0_24 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-10-18
  iso-flags-png-320x420 = lib.warnOnInstantiate "iso-flags-png-320x420 has been renamed to iso-flags-png-320x240" iso-flags-png-320x240; # Added 2024-07-17
  itktcl = tclPackages.itktcl; # Added 2024-10-02
  itpp = throw "itpp has been removed, as it was broken"; # Added 2025-08-25
  jack_rack = throw "'jack_rack' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jami-client = jami; # Added 2023-02-10
  jami-client-qt = jami-client; # Added 2022-11-06
  jami-daemon = jami.daemon; # Added 2023-02-10
  jdk24 = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  jdk24_headless = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  jikespg = throw "'jikespg' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jing = jing-trang; # Added 2025-09-18
  jscoverage = throw "jscoverage has been removed, as it was broken"; # Added 2025-08-25
  k2pdfopt = throw "'k2pdfopt' has been removed from nixpkgs as it was broken"; # Added 2025-09-27
  k3s_1_30 = throw "'k3s_1_30' has been removed from nixpkgs as it has reached end of life"; # Added 2025-09-01
  kak-lsp = kakoune-lsp; # Added 2024-04-01
  kanidm = lib.warnOnInstantiate "'kanidm' will be removed before 26.05. You must use a versioned package, e.g. 'kanidm_1_x'." kanidm_1_7; # Added 2025-09-01
  kanidm_1_4 = throw "'kanidm_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kanidmWithSecretProvisioning = lib.warnOnInstantiate "'kanidmWithSecretProvisioning' will be removed before 26.05. You must use a versioned package, e.g. 'kanidmWithSecretProvisioning_1_x'." kanidmWithSecretProvisioning_1_7; # Added 2025-09-01
  kanidmWithSecretProvisioning_1_4 = throw "'kanidmWithSecretProvisioning_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kbibtex = throw "'kbibtex' has been removed, as it is unmaintained upstream"; # Added 2025-08-30
  kcli = throw "kcli has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  keepkey_agent = keepkey-agent; # added 2024-01-06
  kgx = gnome-console; # Added 2022-02-19
  khoj = throw "khoj has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-11
  kmplayer = throw "'kmplayer' has been removed, as it is unmaintained upstream"; # Added 2025-08-30
  kodiGBM = kodi-gbm; # Added 2021-03-09
  kodiPlain = kodi; # Added 2021-03-09
  kodiPlainWayland = kodi-wayland; # Added 2021-03-09
  kodiPlugins = kodiPackages; # Added 2021-03-09
  krb5Full = krb5; # Added 2022-11-17
  krunner-pass = throw "'krunner-pass' has been removed, as it only works on Plasma 5"; # Added 2025-08-30
  krunner-translator = throw "'krunner-translator' has been removed, as it only works on Plasma 5"; # Added 2025-08-30
  # k3d was a 3d editing software k-3d - "k3d has been removed because it was broken and has seen no release since 2016"
  # now kube3d/k3d will take its place
  kube3d = k3d; # Added 2022-07-05
  kubei = kubeclarity; # Added 2023-05-20
  kubo-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2024-09-24
  languageMachines.frog = frog; # Added 2025-10-7
  languageMachines.frogdata = frogdata; # Added 2025-10-7
  languageMachines.libfolia = libfolia; # Added 2025-10-7
  languageMachines.mbt = mbt; # Added 2025-10-7
  languageMachines.test = frog.tests.simple; # Added 2025-10-7
  languageMachines.ticcutils = ticcutils; # Added 2025-10-7
  languageMachines.timbl = timbl; # Added 2025-10-7
  languageMachines.timblserver = timblserver; # Added 2025-10-7
  languageMachines.ucto = ucto; # Added 2025-10-7
  languageMachines.uctodata = uctodata; # Added 2025-10-7
  lanzaboote-tool = throw "lanzaboote-tool has been removed due to lack of integration maintenance with nixpkgs. Consider using the Nix expressions provided by https://github.com/nix-community/lanzaboote"; # Added 2025-07-23
  larynx = piper-tts; # Added 2023-05-09
  LASzip2 = laszip_2; # Added 2024-06-12
  LASzip = laszip; # Added 2024-06-12
  latinmodern-math = lmmath; # Added 2020-03-17
  latte-dock = throw "'latte-dock' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  layan-kde = throw "'layan-kde' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  lazarus-qt = lazarus-qt5; # Added 2024-12-25
  ledger_agent = ledger-agent; # Added 2024-01-07
  lesstif = throw "'lesstif' has been removed due to its being broken and unmaintained upstream. Consider using 'motif' instead."; # Added 2024-06-09
  lfs = dysk; # Added 2023-07-03
  libast = throw "'libast' has been removed due to lack of maintenance upstream."; # Added 2025-06-09
  libayatana-appindicator-gtk3 = libayatana-appindicator; # Added 2022-10-18
  libayatana-indicator-gtk3 = libayatana-indicator; # Added 2022-10-18
  libbencodetools = bencodetools; # Added 2022-07-30
  libbpf_1 = libbpf; # Added 2022-12-06
  libbson = mongoc; # Added 2024-03-11
  libdevil = throw "libdevil has been removed, as it was unmaintained in Nixpkgs and upstream since 2017"; # Added 2025-09-16
  libdevil-nox = throw "libdevil has been removed, as it was unmaintained in Nixpkgs and upstream since 2017"; # Added 2025-09-16
  libdwarf-lite = throw "`libdwarf-lite` has been replaced by `libdwarf` as it's mostly a mirror"; # Added 2025-06-16
  libfpx = throw "libfpx has been removed as it was unmaintained in Nixpkgs and had known vulnerabilities"; # Added 2025-05-20
  libgadu = throw "'libgadu' has been removed as upstream is unmaintained and has no dependents or maintainers in Nixpkgs"; # Added 2025-05-17
  libgda = lib.warnOnInstantiate "'libgda' has been renamed to 'libgda5'" libgda5; # Added 2025-01-21
  libgme = game-music-emu; # Added 2022-07-20
  libgnome-keyring3 = libgnome-keyring; # Added 2024-06-22
  libheimdal = heimdal; # Added 2022-11-18
  libiconv-darwin = darwin.libiconv; # Added 2024-09-22
  libixp_hg = libixp; # Added 2022-04-25
  libkkc = throw "'libkkc' has been removed due to lack of maintenance. Consider using anthy instead"; # added 2025-08-28
  libkkc-data = throw "'libkkc-data' has been removed as it depended on libkkc which was removed"; # Added 2025-08-28
  liblinphone = throw "'liblinphone' has been moved to 'linphonePackages.liblinphone'"; # Added 2025-09-20
  libmp3splt = throw "'libmp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  libmusicbrainz3 = throw "libmusicbrainz3 has been removed as it was obsolete and unused"; # Added 2025-09-16
  libmusicbrainz5 = libmusicbrainz; # Added 2025-09-16
  libosmo-sccp = libosmo-sigtran; # Added 2024-12-20
  libpromhttp = throw "'libpromhttp' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-16
  libpseudo = throw "'libpseudo' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libqt5pas = libsForQt5.libqtpas; # Added 2024-12-25
  libquotient = throw "'libquotient' for qt5 was removed as upstream removed qt5 support. Consider explicitly upgrading to qt6 'libquotient'"; # Converted to throw 2025-07-04
  LibreArp = librearp; # Added 2024-06-12
  LibreArp-lv2 = librearp-lv2; # Added 2024-06-12
  libreoffice-qt6 = libreoffice-qt; # Added 2025-08-30
  libreoffice-qt6-fresh = libreoffice-qt-fresh; # Added 2025-08-30
  libreoffice-qt6-fresh-unwrapped = libreoffice-qt-fresh.unwrapped; # Added 2025-08-30
  libreoffice-qt6-still = libreoffice-qt-still; # Added 2025-08-30
  libreoffice-qt6-still-unwrapped = libreoffice-qt-still.unwrapped; # Added 2025-08-30
  libreoffice-qt6-unwrapped = libreoffice-qt.unwrapped; # Added 2025-08-30
  librewolf-wayland = librewolf; # Added 2022-11-15
  librtlsdr = rtl-sdr; # Added 2023-02-18
  libsForQt515 = libsForQt5; # Added 2022-11-24
  libsmartcols = lib.warnOnInstantiate "'util-linux' should be used instead of 'libsmartcols'" util-linux; # Added 2025-09-03
  libsoup = lib.warnOnInstantiate "'libsoup' has been renamed to 'libsoup_2_4'" libsoup_2_4; # Added 2024-12-02
  libtap = throw "libtap has been removed, as it was unused and deprecated by its author in favour of cmocka"; # Added 2025-09-16
  libtcod = throw "'libtcod' has been removed due to being unused and having an incompatible build-system"; # Added 2025-10-04
  libtensorflow-bin = libtensorflow; # Added 2022-09-25
  libtorrent = throw "'libtorrent' has been renamed to 'libtorrent-rakshasa' for clearer distinction from 'libtorrent-rasterbar'"; # Added 2025-09-10
  libtransmission = lib.warnOnInstantiate (transmission3Warning {
    prefix = "lib";
  }) libtransmission_3; # Added 2024-06-10
  libviper = throw "'libviper' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libwnck3 = libwnck; # Added 2021-06-23
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  lightly-boehs = throw "'lightly-boehs' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  lightly-qt = throw "'lightly-qt' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  ligo = throw "ligo has been removed from nixpkgs for lack of maintainance"; # Added 2025-06-03
  lima-bin = lib.warnOnInstantiate "lima-bin has been replaced by lima" lima; # Added 2025-05-13
  lincity_ng = lib.warnOnInstantiate "lincity_ng has been renamed to lincity-ng" lincity-ng; # Added 2025-10-09
  linphone = linphonePackages.linphone-desktop; # Added 2025-09-20
  linux-libre = throw "linux_libre has been removed due to lack of maintenance"; # Added 2025-10-01
  linux-rt_5_4 = throw "linux_rt 5.4 has been removed because it will reach its end of life within 25.11"; # Added 2025-10-22
  linux-rt_5_10 = linuxKernel.kernels.linux_rt_5_10;
  linux-rt_5_15 = linuxKernel.kernels.linux_rt_5_15;
  linux-rt_6_1 = linuxKernel.kernels.linux_rt_6_1;
  linux_5_4 = throw "linux 5.4 was removed because it will reach its end of life within 25.11"; # Added 2025-10-26
  linux_5_4_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_10_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_5_15_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linux_6_1 = linuxKernel.kernels.linux_6_1;
  linux_6_1_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linux_6_6 = linuxKernel.kernels.linux_6_6;
  linux_6_6_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linux_6_12 = linuxKernel.kernels.linux_6_12;
  linux_6_12_hardened = linuxKernel.kernels.linux_6_12_hardened;
  linux_6_13 = throw "linux 6.13 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linux_6_13_hardened = throw "linux 6.13 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linux_6_14 = throw "linux 6.14 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linux_6_14_hardened = throw "linux 6.14 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linux_6_15 = throw "linux 6.15 was removed because it has reached its end of life upstream"; # Added 2025-08-30
  linux_6_16 = throw "linux 6.16 was removed because it has reached its end of life upstream"; # Added 2025-10-22
  linux_6_17 = linuxKernel.kernels.linux_6_17;
  linux_ham = throw "linux_ham has been removed in favour of the standard kernel packages"; # Added 2025-06-24
  linux_hardened = linuxPackages_hardened.kernel; # Added 2025-08-10
  linux_latest-libre = throw "linux_latest_libre has been removed due to lack of maintenance"; # Added 2025-10-01
  linux_rpi0 = linuxKernel.kernels.linux_rpi1;
  linux_rpi1 = linuxKernel.kernels.linux_rpi1;
  linux_rpi2 = linuxKernel.kernels.linux_rpi2;
  linux_rpi02w = linuxKernel.kernels.linux_rpi3;
  linux_rpi3 = linuxKernel.kernels.linux_rpi3;
  linux_rpi4 = linuxKernel.kernels.linux_rpi4;
  linuxPackages-libre = throw "linux_libre has been removed due to lack of maintenance"; # Added 2025-10-01
  linuxPackages_5_4 = throw "linux 5.4 was removed because it will reach its end of life within 25.11"; # Added 2025-10-26
  linuxPackages_5_4_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_10_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_5_15_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linuxPackages_6_1 = linuxKernel.packages.linux_6_1;
  linuxPackages_6_1_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linuxPackages_6_6 = linuxKernel.packages.linux_6_6;
  linuxPackages_6_6_hardened = throw "linux_hardened on nixpkgs only contains latest stable and latest LTS"; # Added 2025-08-10
  linuxPackages_6_12 = linuxKernel.packages.linux_6_12;
  linuxPackages_6_12_hardened = linuxKernel.packages.linux_6_12_hardened; # Added 2025-08-10
  linuxPackages_6_13 = throw "linux 6.13 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linuxPackages_6_13_hardened = throw "linux 6.13 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linuxPackages_6_14 = throw "linux 6.14 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linuxPackages_6_14_hardened = throw "linux 6.14 was removed because it has reached its end of life upstream"; # Added 2025-06-29
  linuxPackages_6_15 = throw "linux 6.15 was removed because it has reached its end of life upstream"; # Added 2025-08-30
  linuxPackages_6_16 = throw "linux 6.16 was removed because it has reached its end of life upstream"; # Added 2025-10-22
  linuxPackages_6_17 = linuxKernel.packages.linux_6_17;
  linuxPackages_ham = throw "linux_ham has been removed in favour of the standard kernel packages"; # Added 2025-06-24
  linuxPackages_hardened = linuxKernel.packages.linux_hardened; # Added 2025-08-10
  linuxPackages_latest-libre = throw "linux_latest_libre has been removed due to lack of maintenance"; # Added 2025-10-01
  linuxPackages_latest_xen_dom0 = linuxPackages_latest; # Added 2021-04-04
  linuxPackages_rpi0 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi1 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi2 = linuxKernel.packages.linux_rpi2;
  linuxPackages_rpi02w = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi3 = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi4 = linuxKernel.packages.linux_rpi4;
  linuxPackages_rt_5_4 = throw "linux_rt 5.4 has been removed because it will reach its end of life within 25.11"; # Added 2025-10-22
  linuxPackages_rt_5_10 = linuxKernel.packages.linux_rt_5_10;
  linuxPackages_rt_5_15 = linuxKernel.packages.linux_rt_5_15;
  linuxPackages_rt_6_1 = linuxKernel.packages.linux_rt_6_1;
  linuxPackages_xen_dom0 = linuxPackages; # Added 2021-04-04
  linuxPackages_xen_dom0_hardened = linuxPackages_hardened; # Added 2021-04-04
  linuxstopmotion = stopmotion; # Added 2024-11-01
  Literate = literate; # Added 2024-06-12
  littlenavmap = throw "littlenavmap has been removed as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  live-chart = throw "live-chart has been removed as it is no longer used in Nixpkgs. livechart-2 (elementary's fork) is available as pantheon.live-chart"; # Added 2025-10-10
  lixVersions = lixPackageSets.renamedDeprecatedLixVersions; # Added 2025-03-20, warning in ../tools/package-management/lix/default.nix
  lizardfs = throw "lizardfs has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  llama = walk; # Added 2023-01-23
  lld_12 = throw "lld_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  lld_13 = throw "lld_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  lld_14 = throw "lld_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  lld_15 = throw "lld_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  lld_16 = throw "lld_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  lld_17 = throw "lld_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  lldb_12 = throw "lldb_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  lldb_13 = throw "lldb_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  lldb_14 = throw "lldb_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  lldb_15 = throw "lldb_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  lldb_16 = throw "lldb_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  lldb_17 = throw "lldb_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  llvm_12 = throw "llvm_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  llvm_13 = throw "llvm_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  llvm_14 = throw "llvm_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  llvm_15 = throw "llvm_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  llvm_16 = throw "llvm_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  llvm_17 = throw "llvm_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  llvmPackages_12 = throw "llvmPackages_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  llvmPackages_13 = throw "llvmPackages_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  llvmPackages_14 = throw "llvmPackages_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  llvmPackages_15 = throw "llvmPackages_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  llvmPackages_16 = throw "llvmPackages_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  llvmPackages_17 = throw "llvmPackages_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  loco-cli = loco; # Added 2025-02-24
  LPCNet = lpcnet; # Added 2025-05-05
  luci-go = throw "luci-go has been removed since it was unused and failing to build for 5 months"; # Added 2025-08-27
  lxd = throw "
    LXD has been removed from NixOS due to lack of Nixpkgs maintenance.
    Consider migrating or switching to Incus, or remove from your configuration.
    https://linuxcontainers.org/incus/docs/main/howto/server_migrate_lxd/
  "; # Added 2025-09-05
  lxd-lts = throw "
    LXD has been removed from NixOS due to lack of Nixpkgs maintenance.
    Consider migrating or switching to Incus, or remove from your configuration.
    https://linuxcontainers.org/incus/docs/main/howto/server_migrate_lxd/
  "; # Added 2025-09-05
  lxd-ui = throw "
    LXD has been removed from NixOS due to lack of Nixpkgs maintenance.
    Consider migrating or switching to Incus, or remove from your configuration.
    https://linuxcontainers.org/incus/docs/main/howto/server_migrate_lxd/
  "; # Added 2025-09-05
  lxd-unwrapped = throw "
    LXD has been removed from NixOS due to lack of Nixpkgs maintenance.
    Consider migrating or switching to Incus, or remove from your configuration.
    https://linuxcontainers.org/incus/docs/main/howto/server_migrate_lxd/
  "; # Added 2025-09-05
  lxd-unwrapped-lts = throw "
    LXD has been removed from NixOS due to lack of Nixpkgs maintenance.
    Consider migrating or switching to Incus, or remove from your configuration.
    https://linuxcontainers.org/incus/docs/main/howto/server_migrate_lxd/
  "; # Added 2025-09-05
  lxde.gtk2-x11 = throw "'lxde.gtk2-x11' has been removed. Use 'gtk2-x11' directly."; # added 2025-08-31
  lxde.lxappearance = throw "'lxappearance' has been moved to top-level. Use 'lxappearance' directly"; # added 2025-08-31
  lxde.lxappearance-gtk2 = throw "'lxappearance-gtk2' has been moved to top-level. Use 'lxappearance-gtk2' directly"; # added 2025-08-31
  lxde.lxmenu-data = throw "'lxmenu-data' has been moved to top-level. Use 'lxmenu-data' directly"; # added 2025-08-31
  lxde.lxpanel = throw "'lxpanel' has been moved to top-level. Use 'lxpanel' directly"; # added 2025-08-31
  lxde.lxrandr = throw "'lxrandr' has been moved to top-level. Use 'lxrandr' directly"; # added 2025-08-31
  lxde.lxsession = throw "'lxsession' has been moved to top-level. Use 'lxsession' directly"; # added 2025-08-31
  lxde.lxtask = throw "'lxtask' has been moved to top-level. Use 'lxtask' directly"; # added 2025-08-31
  lxdvdrip = throw "'lxdvdrip' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  mac = monkeysAudio; # Added 2024-11-30
  MACS2 = macs2; # Added 2023-06-12
  magma_2_6_2 = throw "'magma_2_6_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  magma_2_7_2 = throw "'magma_2_7_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  mailcore2 = throw "'mailcore2' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  mailnag = throw "mailnag has been removed because it has been marked as broken since 2022."; # Added 2025-10-12
  mailnagWithPlugins = throw "mailnagWithPlugins has been removed because mailnag has been marked as broken since 2022."; # Added 2025-10-12
  manaplus = throw "manaplus has been removed, as it was broken"; # Added 2025-08-25
  mariadb-client = throw "mariadb-client has been renamed to mariadb.client"; # Converted to throw 2025-10-26
  marwaita-manjaro = lib.warnOnInstantiate "marwaita-manjaro has been renamed to marwaita-teal" marwaita-teal; # Added 2024-07-08
  marwaita-peppermint = lib.warnOnInstantiate "marwaita-peppermint has been renamed to marwaita-red" marwaita-red; # Added 2024-07-01
  marwaita-pop_os = lib.warnOnInstantiate "marwaita-pop_os has been renamed to marwaita-yellow" marwaita-yellow; # Added 2024-10-29
  marwaita-ubuntu = lib.warnOnInstantiate "marwaita-ubuntu has been renamed to marwaita-orange" marwaita-orange; # Added 2024-07-08
  material-kwin-decoration = throw "'material-kwin-decoration' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  mathlibtools = throw "mathlibtools has been removed as it was archived upstream in 2023"; # Added 2025-07-09
  matomo_5 = matomo; # Added 2024-12-12
  matrix-synapse-tools.rust-synapse-compress-state = lib.warnOnInstantiate "`matrix-synapse-tools.rust-synapse-compress-state` has been renamed to `rust-synapse-compress-state`" rust-synapse-compress-state; # Added 2025-03-04
  matrix-synapse-tools.synadm = lib.warnOnInstantiate "`matrix-synapse-tools.synadm` has been renamed to `synadm`" synadm; # Added 2025-02-20
  mcomix3 = mcomix; # Added 2022-06-05
  mdt = md-tui; # Added 2024-09-03
  mediastreamer = throw "'mediastreamer' has been moved to 'linphonePackages.mediastreamer2'"; # Added 2025-09-20
  mediastreamer-openh264 = throw "'mediastreamer-openh264' has been moved to 'linphonePackages.msopenh264'"; # Added 2025-09-20
  meilisearch_1_11 = throw "'meilisearch_1_11' has been removed, as it is no longer supported"; # Added 2025-10-03
  melmatcheq.lv2 = melmatcheq-lv2; # Added 2025-09-27
  meteo = throw "'meteo' has been removed as it was unmaintained and depends on deprecated webkitgtk_4_0"; # Added 2025-10-09
  microcodeAmd = microcode-amd; # Added 2024-09-08
  microcodeIntel = microcode-intel; # Added 2024-09-08
  microsoft_gsl = microsoft-gsl; # Added 2023-05-26
  MIDIVisualizer = midivisualizer; # Added 2024-06-12
  midori = throw "'midori' original project has been abandonned upstream and the package was broken for a while in nixpkgs"; # Added 2025-05-19
  midori-unwrapped = throw "'midori' original project has been abandonned upstream and the package was broken for a while in nixpkgs"; # Added 2025-05-19
  migra = throw "migra has been removed because it has transitively been marked as broken since May 2024, and is unmaintained upstream."; # Added 2025-10-11
  mihomo-party = throw "'mihomo-party' has been removed due to upstream license violation"; # Added 2025-08-20
  mime-types = mailcap; # Added 2022-01-21
  minecraft = throw "'minecraft' has been removed because the package was broken. Consider using 'prismlauncher' instead"; # Added 2025-09-06
  minetest = luanti; # Added 2024-11-11
  minetest-touch = luanti-client; # Added 2024-08-12
  minetestclient = luanti-client; # Added 2024-11-11
  minetestserver = luanti-server; # Added 2024-11-11
  minizip2 = pkgs.minizip-ng; # Added 2022-12-28
  miru = throw "'miru' has been removed due to lack maintenance"; # Added 2025-08-21
  mlir_16 = throw "mlir_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  mlir_17 = throw "mlir_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  mmsd = throw "'mmsd' has been removed due to being unmaintained upstream. Consider using 'mmsd-tng' instead"; # Added 2025-06-07
  mmutils = throw "'mmutils' has been removed due to being unmaintained upstream"; # Added 2025-08-29
  moar = lib.warnOnInstantiate "`moar` has been renamed to `moor` by upstream in v2.0.0. See https://github.com/walles/moor/pull/305 for more." pkgs.moor; # Added 2025-09-02
  mongodb-6_0 = throw "mongodb-6_0 has been removed, it's end of life since July 2025"; # Added 2025-07-23
  monitor = pantheon.elementary-monitor; # Added 2025-10-10
  mono4 = mono6; # Added 2025-08-25
  mono5 = mono6; # Added 2025-08-25
  mono-addins = throw "mono-addins has been removed due to its dependency on the removed mono4. Consider alternative frameworks or migrate to newer .NET technologies."; # Added 2025-08-25
  monotoneViz = throw "monotoneViz was removed because it relies on a broken version of graphviz"; # added 2025-10-19
  moralerspace-hwnf = throw "moralerspace-hwnf has been removed, use moralerspace-hw instead."; # Added 2025-08-30
  moralerspace-nf = throw "moralerspace-nf has been removed, use moralerspace instead."; # Added 2025-08-30
  morty = throw "morty has been removed, as searxng removed support for it and it was unmaintained."; # Added 2025-09-26
  moz-phab = mozphab; # Added 2022-08-09
  mp3splt = throw "'mp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  mpc-cli = mpc; # Added 2024-10-14
  mpc_cli = mpc; # Added 2024-10-14
  mpdevil = plattenalbum; # Added 2024-05-22
  mpdWithFeatures = lib.warnOnInstantiate "mpdWithFeatures has been replaced by mpd.override" mpd.override; # Added 2025-08-08
  mpris-discord-rpc = throw "'mpris-discord-rpc' has been renamed to 'music-discord-rpc'."; # Added 2025-09-14
  mpw = throw "'mpw' has been removed, as upstream development has moved to Spectre, which is packaged as 'spectre-cli'"; # Added 2025-10-26
  mrxvt = throw "'mrxvt' has been removed due to lack of maintainence upstream"; # Added 2025-09-25
  msgpack = throw "msgpack has been split into msgpack-c and msgpack-cxx"; # Added 2025-09-14
  msp430NewlibCross = msp430Newlib; # Added 2024-09-06
  mumps_par = lib.warnOnInstantiate "mumps_par has been renamed to mumps-mpi" mumps-mpi; # Added 2025-05-07
  mustache-tcl = tclPackages.mustache-tcl; # Added 2024-10-02
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mx-puppet-discord = throw "mx-puppet-discord was removed since the packaging was unmaintained and was the sole user of sha1 hashes in nixpkgs"; # Added 2025-07-24
  mysql-client = throw "mysql-client has been replaced by mariadb.client"; # Converted to throw 2025-10-26
  n98-magerun = throw "n98-magerun doesn't support new PHP newer than 8.1"; # Added 2025-10-03
  nagiosPluginsOfficial = monitoring-plugins; # Added 2017-08-07
  namazu = throw "namazu has been removed, as it was broken"; # Added 2025-08-25
  nanoblogger = throw "nanoblogger has been removed as upstream stopped developement in 2013"; # Added 2025-09-10
  nasc = throw "'nasc' has been removed as it was unmaintained and depends on deprecated webkitgtk_4_0"; # Added 2025-10-09
  nats-streaming-server = throw "'nats-streaming-server' has been removed as critical bug fixes and security fixes will no longer be performed as of June of 2023"; # added 2025-10-13
  ncdu_2 = ncdu; # Added 2022-07-22
  neardal = throw "neardal has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-29
  neocities-cli = neocities; # Added 2024-07-31
  netbox_4_1 = throw "netbox 4.1 series has been removed as it was EOL"; # Added 2025-10-14
  netbsdCross = netbsd; # Added 2024-09-06
  netsurf.browser = lib.warnOnInstantiate "'netsurf.browser' has been renamed to 'netsurf-browser'" netsurf-browser; # Added 2025-03-26
  netsurf.buildsystem = lib.warnOnInstantiate "'netsurf.buildsystem' has been renamed to 'netsurf-buildsystem'" netsurf-buildsystem; # Added 2025-03-26
  netsurf.libcss = lib.warnOnInstantiate "'netsurf.libcss' has been renamed to 'libcss'" libcss; # Added 2025-03-26
  netsurf.libdom = lib.warnOnInstantiate "'netsurf.libdom' has been renamed to 'libdom'" libdom; # Added 2025-03-26
  netsurf.libhubbub = lib.warnOnInstantiate "'netsurf.libhubbub' has been renamed to 'libhubbub'" libhubbub; # Added 2025-03-26
  netsurf.libnsbmp = lib.warnOnInstantiate "'netsurf.libnsbmp' has been renamed to 'libnsbmp'" libnsbmp; # Added 2025-03-26
  netsurf.libnsfb = lib.warnOnInstantiate "'netsurf.libnsfb' has been renamed to 'libnsfb'" libnsfb; # Added 2025-03-26
  netsurf.libnsgif = lib.warnOnInstantiate "'netsurf.libnsgif' has been renamed to 'libnsgif'" libnsgif; # Added 2025-03-26
  netsurf.libnslog = lib.warnOnInstantiate "'netsurf.libnslog' has been renamed to 'libnslog'" libnslog; # Added 2025-03-26
  netsurf.libnspsl = lib.warnOnInstantiate "'netsurf.libnspsl' has been renamed to 'libnspsl'" libnspsl; # Added 2025-03-26
  netsurf.libnsutils = lib.warnOnInstantiate "'netsurf.libnsutils' has been renamed to 'libnsutils'" libnsutils; # Added 2025-03-26
  netsurf.libparserutils = lib.warnOnInstantiate "'netsurf.libparserutils' has been renamed to 'libparserutils'" libparserutils; # Added 2025-03-26
  netsurf.libsvgtiny = lib.warnOnInstantiate "'netsurf.libsvgtiny' has been renamed to 'libsvgtiny'" libsvgtiny; # Added 2025-03-26
  netsurf.libutf8proc = lib.warnOnInstantiate "'netsurf.libutf8proc' has been renamed to 'libutf8proc'" libutf8proc; # Added 2025-03-26
  netsurf.libwapcaplet = lib.warnOnInstantiate "'netsurf.libwapcaplet' has been renamed to 'libwapcaplet'" libwapcaplet; # Added 2025-03-26
  netsurf.nsgenbind = lib.warnOnInstantiate "'netsurf.nsgenbind' has been renamed to 'nsgenbind'" nsgenbind; # Added 2025-03-26
  nettools = net-tools; # Added 2025-06-11
  networkmanager_strongswan = networkmanager-strongswan; # added 2025-06-29
  newlib-nanoCross = newlib-nano; # Added 2024-09-06
  newlibCross = newlib; # Added 2024-09-06
  newt-go = fosrl-newt; # Added 2025-06-24
  nextcloud30 = throw "
    Nextcloud v30 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2025-09. Please upgrade to at least Nextcloud v31 by declaring

        services.nextcloud.package = pkgs.nextcloud31;

    in your NixOS config.

    WARNING: if you were on Nextcloud 29 you have to upgrade to Nextcloud 30
    first on 25.05 because Nextcloud doesn't support upgrades across multiple major versions!
  "; # Added 2025-09-25
  nextcloud30Packages = throw "Nextcloud 30 is EOL!"; # Added 2025-09-25
  nfstrace = throw "nfstrace has been removed, as it was broken"; # Added 2025-08-25
  nix-direnv-flakes = nix-direnv; # Added 2021-11-09
  nix-ld-rs = nix-ld; # Added 2024-08-17
  nix-linter = throw "nix-linter has been removed as it was broken for 3 years and unmaintained upstream"; # Added 2025-09-06
  nix-plugin-pijul = throw "nix-plugin-pijul has been removed due to being discontinued"; # added 2025-05-18
  nix_2_3 = throw "'nix_2_3' has been removed, because it was unmaintained and insecure."; # Converted to throw 2025-07-24
  nixfmt-classic =
    (
      if lib.oldestSupportedReleaseIsAtLeast 2605 then
        throw "nixfmt-classic has been removed as it is deprecated and unmaintained."
      else if lib.oldestSupportedReleaseIsAtLeast 2511 then
        lib.warnOnInstantiate "nixfmt-classic is deprecated and unmaintained. We recommend switching to nixfmt."
      else
        lib.id
    )
      haskellPackages.nixfmt.bin;
  nixfmt-rfc-style =
    if lib.oldestSupportedReleaseIsAtLeast 2511 then
      lib.warnOnInstantiate
        "nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead."
        nixfmt # Added 2025-07-14
    else
      nixfmt;
  nixForLinking = throw "nixForLinking has been removed, use `nixVersions.nixComponents_<version>` instead"; # Added 2025-08-14
  nixosTest = testers.nixosTest; # Added 2022-05-05
  nixStable = nixVersions.stable; # Added 2022-01-24
  nm-tray = throw "'nm-tray' has been removed, as it only works with Plasma 5"; # Added 2025-08-30
  nomacs-qt6 = nomacs; # Added 2025-08-30
  norouter = throw "norouter has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-29
  notes-up = throw "'notes-up' has been removed as it was unmaintained and depends on deprecated webkitgtk_4_0"; # Added 2025-10-09
  notify-sharp = throw "'notify-sharp' has been removed as it was unmaintained and depends on deprecated dbus-sharp versions"; # Added 2025-08-25
  noto-fonts-emoji = noto-fonts-color-emoji; # Added 2023-09-09
  noto-fonts-extra = noto-fonts; # Added 2023-04-08
  NSPlist = nsplist; # Added 2024-01-05
  nuget-to-nix = throw "nuget-to-nix has been removed as it was deprecated in favor of nuget-to-json. Please use nuget-to-json instead"; # Added 2025-08-28
  nushellFull = lib.warnOnInstantiate "`nushellFull` has has been replaced by `nushell` as its features no longer exist" nushell; # Added 2024-05-30
  o = orbiton; # Added 2023-04-09
  oathToolkit = oath-toolkit; # Added 2022-04-04
  obb = throw "obb has been removed because it has been marked as broken since 2023."; # Added 2025-10-11
  obliv-c = throw "obliv-c has been removed from Nixpkgs, as it has been unmaintained upstream for 4 years and does not build with supported GCC versions"; # Added 2025-08-18
  oclgrind = throw "oclgrind has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  oil = lib.warnOnInstantiate "Oil has been replaced with the faster native C++ version and renamed to 'oils-for-unix'. See also https://github.com/oils-for-unix/oils/wiki/Oils-Deployments" oils-for-unix; # Added 2024-10-22
  onevpl-intel-gpu = lib.warnOnInstantiate "onevpl-intel-gpu has been renamed to vpl-gpu-rt" vpl-gpu-rt; # Added 2024-06-04
  onlyoffice-bin = onlyoffice-desktopeditors; # Added 2024-09-20
  onlyoffice-bin_latest = onlyoffice-bin; # Added 2024-07-03
  onscripter-en = throw "onscripter-en has been removed due to lack of maintenance in both upstream and Nixpkgs; onscripter is available instead"; # Added 2025-10-17
  onthespot = throw "onethespot has been removed due to lack of upstream maintenance"; # Added 2025-09-26
  opae = throw "opae has been removed because it has been marked as broken since June 2023."; # Added 2025-10-11
  open-timeline-io = lib.warnOnInstantiate "'open-timeline-io' has been renamed to 'opentimelineio'" opentimelineio; # Added 2025-08-10
  openafs_1_8 = openafs; # Added 2022-08-22
  openai-triton-llvm = triton-llvm; # added 2024-07-18
  openai-whisper-cpp = whisper-cpp; # Added 2024-12-13
  openbabel2 = throw "openbabel2 has been removed, as it was unused and unmaintained upstream; please use openbabel"; # Added 2025-09-17
  openbabel3 = openbabel; # Added 2025-09-17
  openbsdCross = openbsd; # Added 2024-09-06
  opencl-clang = throw "opencl-clang has been integrated into intel-graphics-compiler"; # Added 2025-09-10
  openconnect_gnutls = openconnect; # Added 2022-03-29
  openexr_3 = openexr; # Added 2025-03-12
  openimageio2 = openimageio; # Added 2023-01-05
  openjdk24 = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  openjdk24_headless = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  openjfx24 = throw "OpenJFX 24 was removed as it has reached its end of life"; # Added 2025-10-04
  openmw-tes3mp = throw "'openmw-tes3mp' has been removed due to lack of maintenance upstream"; # Added 2025-08-30
  openssl_3_0 = openssl_3; # Added 2022-06-27
  opensycl = lib.warnOnInstantiate "'opensycl' has been renamed to 'adaptivecpp'" adaptivecpp; # Added 2024-12-04
  opensyclWithRocm = lib.warnOnInstantiate "'opensyclWithRocm' has been renamed to 'adaptivecppWithRocm'" adaptivecppWithRocm; # Added 2024-12-04
  opentofu-ls = lib.warnOnInstantiate "'opentofu-ls' has been renamed to 'tofu-ls'" tofu-ls; # Added 2025-06-10
  opentracing-cpp = throw "'opentracingc-cpp' has been removed as it was archived upstream in 2024"; # Added 2025-10-19
  opera = throw "'opera' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-05-19
  orogene = throw "'orogene' uses a wasm-specific fork of async-tar that is vulnerable to CVE-2025-62518, which is not supported by its upstream"; # Added 2025-10-24
  ortp = throw "'ortp' has been moved to 'linphonePackages.ortp'"; # Added 2025-09-20
  OSCAR = oscar; # Added 2024-06-12
  osm2xmap = throw "osm2xmap has been removed, as it is unmaintained upstream and depended on old dependencies with broken builds"; # Added 2025-09-16
  overrideLibcxx = throw "overrideLibcxx has been removed, as it was no longer used and Darwin now uses libc++ from the latest SDK; see the Nixpkgs 25.11 release notes for details"; # Added 2025-09-15
  overrideSDK = throw "overrideSDK has been removed as it was a legacy compatibility stub. See <https://nixos.org/manual/nixpkgs/stable/#sec-darwin-legacy-frameworks-overrides> for migration instructions"; # Added 2025-08-04
  pacup = perlPackages.pacup; # Added 2025-01-21
  PageEdit = pageedit; # Added 2024-01-21
  pal = throw "pal has been removed, as it was broken"; # Added 2025-08-25
  paperless-ng = paperless-ngx; # Added 2022-04-11
  patchelfStable = patchelf; # Added 2024-01-25
  paup = paup-cli; # Added 2024-09-11
  pcp = throw "'pcp' has been removed because the upstream repo was archived and it hasn't been updated since 2021"; # Added 2025-09-23
  pcre16 = throw "'pcre16' has been removed because it is obsolete. Consider migrating to 'pcre2' instead."; # Added 2025-05-29
  pcsctools = pcsc-tools; # Added 2023-12-07
  pdf4tcl = tclPackages.pdf4tcl; # Added 2024-10-02
  pds = lib.warnOnInstantiate "'pds' has been renamed to 'bluesky-pds'" bluesky-pds; # Added 2025-08-20
  pdsadmin = lib.warnOnInstantiate "'pdsadmin' has been renamed to 'bluesky-pdsadmin'" bluesky-pdsadmin; # Added 2025-08-20
  peach = asouldocs; # Added 2022-08-28
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  perceptual-diff = throw "perceptual-diff was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  percona-server_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-server; # Added 2024-10-13
  percona-server_lts = percona-server; # Added 2024-10-13
  percona-xtrabackup_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-xtrabackup; # Added 2024-10-13
  percona-xtrabackup_lts = percona-xtrabackup; # Added 2024-10-13
  peruse = throw "'peruse' has been removed as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  pg_cron = throw "'pg_cron' has been removed. Use 'postgresqlPackages.pg_cron' instead."; # Added 2025-07-19
  pg_hll = throw "'pg_hll' has been removed. Use 'postgresqlPackages.pg_hll' instead."; # Added 2025-07-19
  pg_repack = throw "'pg_repack' has been removed. Use 'postgresqlPackages.pg_repack' instead."; # Added 2025-07-19
  pg_similarity = throw "'pg_similarity' has been removed. Use 'postgresqlPackages.pg_similarity' instead."; # Added 2025-07-19
  pg_topn = throw "'pg_topn' has been removed. Use 'postgresqlPackages.pg_topn' instead."; # Added 2025-07-19
  pgadmin = pgadmin4; # Added 2022-01-14
  pgf_graphics = throw "pgf_graphics was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  pgjwt = throw "'pgjwt' has been removed. Use 'postgresqlPackages.pgjwt' instead."; # Added 2025-07-19
  pgroonga = throw "'pgroonga' has been removed. Use 'postgresqlPackages.pgroonga' instead."; # Added 2025-07-19
  pgtap = throw "'pgtap' has been removed. Use 'postgresqlPackages.pgtap' instead."; # Added 2025-07-19
  pharo-spur64 = pharo; # Added 2022-08-03
  php81 = throw "php81 is EOL"; # Added 2025-10-04
  php81Extensions = throw "php81 is EOL"; # Added 2025-10-04
  php81Packages = throw "php81 is EOL"; # Added 2025-10-04
  picom-next = picom; # Added 2024-02-13
  pidgin-carbons = pidginPackages.pidgin-carbons; # Added 2023-07-17
  pidgin-indicator = pidginPackages.pidgin-indicator; # Added 2023-07-17
  pidgin-latex = pidginPackages.pidgin-latex; # Added 2023-07-17
  pidgin-mra = throw "'pidgin-mra' has been removed since mail.ru agent service has stopped functioning in 2024."; # Added 2025-09-17
  pidgin-msn-pecan = throw "'pidgin-msn-pecan' has been removed as it's unmaintained upstream and doesn't work with escargot"; # Added 2025-09-17
  pidgin-opensteamworks = throw "'pidgin-opensteamworks' has been removed as it is unmaintained and no longer works with Steam."; # Added 2025-09-17
  pidgin-osd = pidginPackages.pidgin-osd; # Added 2023-07-17
  pidgin-otr = pidginPackages.pidgin-otr; # Added 2023-07-17
  pidgin-sipe = pidginPackages.pidgin-sipe; # Added 2023-07-17
  pidgin-skypeweb = throw "'pidgin-skypeweb' has been removed since Skype was shut down in May 2025"; # Added 2025-09-15
  pidgin-window-merge = pidginPackages.pidgin-window-merge; # Added 2023-07-17
  pidgin-xmpp-receipts = pidginPackages.pidgin-xmpp-receipts; # Added 2023-07-17
  pilipalax = throw "'pilipalax' has been removed from nixpkgs due to it not being maintained"; # Added 2025-07-25
  pinentry = throw "'pinentry' has been removed. Pick an appropriate variant like 'pinentry-curses' or 'pinentry-gnome3'"; # Converted to throw 2025-10-26
  piper-train = throw "piper-train is now part of the piper package using the `withTrain` override"; # Added 2025-09-03
  plasma-applet-volumewin7mixer = throw "'plasma-applet-volumewin7mixer' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  plasma-pass = throw "'plasma-pass' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  plasma-theme-switcher = throw "'plasma-theme-switcher' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  platformioPackages.platformio-chrootenv = platformio-chrootenv; # Added 2025-09-04
  platformioPackages.platformio-core = platformio-core; # Added 2025-09-04
  plex-media-player = throw "'plex-media-player' has been discontinued, the new official client is available as 'plex-desktop'"; # Added 2025-05-28
  PlistCpp = plistcpp; # Added 2024-01-05
  pltScheme = racket; # Added 2013-02-24
  plv8 = throw "'plv8' has been removed. Use 'postgresqlPackages.plv8' instead."; # Added 2025-07-19
  pn = throw "'pn' has been removed as upstream was archived in 2020"; # Added 2025-10-17
  poac = cabinpkg; # Added 2025-01-22
  pocket-updater-utility = pupdate; # Added 2024-01-25
  podofo010 = podofo_0_10; # Added 2025-06-01
  polipo = throw "'polipo' has been removed as it is unmaintained upstream"; # Added 2025-05-18
  polypane = throw "'polypane' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-25
  poppler_utils = poppler-utils; # Added 2025-02-27
  posterazor = throw "posterazor was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  postfixadmin = throw "'postfixadmin' has been removed due to lack of maintenance and missing support for PHP >8.1"; # Added 2025-10-03
  postgis = throw "'postgis' has been removed. Use 'postgresqlPackages.postgis' instead."; # Added 2025-07-19
  postgresql13JitPackages = postgresql13Packages; # Added 2025-04-12
  postgresql14JitPackages = postgresql14Packages; # Added 2025-04-12
  postgresql15JitPackages = postgresql15Packages; # Added 2025-04-12
  postgresql16JitPackages = postgresql16Packages; # Added 2025-04-12
  postgresql17JitPackages = postgresql17Packages; # Added 2025-04-12
  # Ever since building with JIT by default, those are the same.
  postgresqlJitPackages = postgresqlPackages; # Added 2025-04-12
  pot = throw "'pot' has been removed as it requires libsoup 2.4 which is EOL"; # Added 2025-10-09
  powerdns = pdns; # Added 2022-03-28
  prboom-plus = throw "'prboom-plus' has been removed since it is unmaintained upstream."; # Added 2025-09-14
  presage = throw "presage has been removed, as it has been unmaintained since 2018"; # Added 2024-03-24
  preserves-nim = throw "'preserves-nim' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  private-gpt = throw "'private-gpt' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2025-07-28
  probe-rs = probe-rs-tools; # Added 2024-05-23
  proj_7 = throw "proj_7 has been removed, as it was broken and unused"; # Added 2025-09-16
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-dovecot-exporter = dovecot_exporter; # Added 2024-06-10
  protobuf3_21 = protobuf_21; # Added 2023-10-05
  protobuf3_24 = throw "'protobuf_24' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-07-14
  protobuf_24 = throw "'protobuf_24' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-07-14
  protobuf_26 = throw "'protobuf_26' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-29
  protobuf_28 = throw "'protobuf_28' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-14
  proton-caller = throw "'proton-caller' has been removed from nixpkgs due to being unmaintained and lack of upstream maintenance."; # Added 2025-09-25
  proton-vpn-local-agent = throw "'proton-vpn-local-agent' has been renamed to 'python3Packages.proton-vpn-local-agent'"; # Converted to throw 2025-10-26
  protonup = protonup-ng; # Added 2022-11-06
  protonvpn-cli = throw "protonvpn-cli source code was removed from upstream. Use protonvpn-gui instead."; # Added 2025-10-16
  protonvpn-cli_2 = throw "protonvpn-cli_2 has been removed due to being deprecated. Use protonvpn-gui instead."; # Added 2025-10-16
  proxmark3-rrg = proxmark3; # Added 2023-07-25
  purple-discord = pidginPackages.purple-discord; # Added 2023-07-17
  purple-facebook = throw "'purple-facebook' has been removed as it is unmaintained and doesn't support e2ee enforced by facebook."; # Added 2025-09-17
  purple-googlechat = pidginPackages.purple-googlechat; # Added 2023-07-17
  purple-hangouts = throw "'purple-hangouts' has been removed as Hangouts Classic is obsolete and migrated to Google Chat."; # Added 2025-09-17
  purple-lurch = pidginPackages.purple-lurch; # Added 2023-07-17
  purple-matrix = throw "'purple-matrix' has been unmaintained since April 2022, so it was removed."; # Added 2025-09-01
  purple-mm-sms = pidginPackages.purple-mm-sms; # Added 2023-07-17
  purple-plugin-pack = pidginPackages.purple-plugin-pack; # Added 2023-07-17
  purple-slack = pidginPackages.purple-slack; # Added 2023-07-17
  purple-vk-plugin = throw "'purple-vk-plugin' has been removed as upstream repository was deleted and no active forks are found."; # Added 2025-09-17
  purple-xmpp-http-upload = pidginPackages.purple-xmpp-http-upload; # Added 2023-07-17
  pyo3-pack = maturin; # Added 2019-08-30
  pypolicyd-spf = spf-engine; # Added 2022-10-09
  python3Full = throw "python3Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python310Full = throw "python310Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python311Full = throw "python311Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python312Full = throw "python312Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python313Full = throw "python313Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python314Full = throw "python314Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python = python2; # Added 2022-01-11
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11
  qcachegrind = throw "'qcachegrind' has been removed, as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  qflipper = qFlipper; # Added 2022-02-11
  qnial = throw "'qnial' has been removed due to failing to build and being unmaintained"; # Added 2025-06-26
  qrscan = throw "qrscan has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-19
  qscintilla = libsForQt5.qscintilla; # Added 2023-09-20
  qscintilla-qt6 = qt6Packages.qscintilla; # Added 2023-09-20
  qt5Full = throw "qt5Full has been removed. Please use individual packages instead."; # Added 2025-10-18
  qt6ct = qt6Packages.qt6ct; # Added 2023-03-07
  qt515 = qt5; # Added 2022-11-24
  qt-video-wlr = throw "'qt-video-wlr' has been removed, as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  qtchan = throw "'qtchan' has been removed due to lack of maintenance upstream"; # Added 2025-07-01
  qtile-unwrapped = python3.pkgs.qtile; # Added 2023-05-12
  quantum-espresso-mpi = quantum-espresso; # Added 2023-11-23
  quaternion-qt5 = throw "'quaternion-qt5' has been removed as quaternion dropped Qt5 support with v0.0.97.1"; # Added 2025-05-24
  qubes-core-vchan-xen = throw "'qubes-core-vchan-xen' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-11
  quicksynergy = throw "'quicksynergy' has been removed due to lack of maintenance upstream. Consider using 'deskflow' instead."; # Added 2025-06-18
  qv2ray = throw "'qv2ray' has been removed as it was unmaintained"; # Added 2025-06-03
  radicale3 = radicale; # Added 2024-11-29
  railway-travel = diebahn; # Added 2024-04-01
  rambox-pro = rambox; # Added 2022-12-12
  rapidjson-unstable = lib.warnOnInstantiate "'rapidjson-unstable' has been renamed to 'rapidjson'" rapidjson; # Added 2024-07-28
  redict = throw "'redict' has been removed due to lack of nixpkgs maintenance and a slow upstream development pace. Consider using 'valkey'."; # Added 2025-10-16
  redoc-cli = throw "'redoc-cli' been removed because it has been marked as broken since at least November 2024. Consider using 'redocly' instead."; # Added 2025-10-01
  redocly-cli = redocly; # Added 2024-04-14
  redpanda = redpanda-client; # Added 2023-10-14
  remotebox = throw "remotebox has been removed because it was unmaintained and broken for a long time"; # Added 2025-09-11
  responsively-app = throw "'responsively-app' has been removed due to lack of maintainance upstream."; # Added 2025-06-25
  retroarchBare = retroarch-bare; # Added 2024-11-23
  retroarchFull = retroarch-full; # Added 2024-11-23
  retroshare06 = retroshare; # Added 2020-11-07
  rewind-ai = throw "'rewind-ai' has been removed due to lack of of maintenance upstream"; # Added 2025-08-03
  rigsofrods = rigsofrods-bin; # Added 2023-03-22
  river = throw "'river' has been renamed to/replaced by 'river-classic'"; # Added 2025-08-30
  rke2_1_29 = throw "'rke2_1_29' has been removed from nixpkgs as it has reached end of life"; # Added 2025-05-05
  rl_json = tclPackages.rl_json; # Added 2025-05-03
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rockcraft = throw "rockcraft was removed in Sep 25 following removal of LXD from nixpkgs"; # added 2025-09-18
  rofi-emoji-wayland = throw "'rofi-emoji-wayland' has been merged into `rofi-emoji as 'rofi-wayland' has been merged into 'rofi'"; # Added 2025-09-06
  rofi-wayland = throw "'rofi-wayland' has been merged into 'rofi'"; # Added 2025-09-06
  rofi-wayland-unwrapped = throw "'rofi-wayland-unwrapped' has been merged into 'rofi-unwrapped'"; # Added 2025-09-06
  root5 = throw "root5 has been removed from nixpkgs because it's a legacy version"; # Added 2025-07-17
  rote = throw "rote has been removed due to lack of upstream maintenance"; # Added 2025-09-10
  rquickshare-legacy = throw "The legacy version depends on insecure package libsoup2, please use the main version"; # Added 2025-10-09
  rr-unstable = rr; # Added 2022-09-17
  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.
  rtx = mise; # Added 2024-01-05
  ruby-zoom = throw "'ruby-zoom' has been removed due to lack of maintaince and had not been updated since 2020"; # Added 2025-08-24
  ruby_3_1 = throw "ruby_3_1 has been removed, as it is has reached end‐of‐life upstream"; # Added 2025-10-12
  ruby_3_2 = throw "ruby_3_2 has been removed, as it will reach end‐of‐life upstream during Nixpkgs 25.11’s support cycle"; # Added 2025-10-12
  rubyPackages_3_1 = throw "rubyPackages_3_1 has been removed, as it is has reached end‐of‐life upstream"; # Added 2025-10-12
  rubyPackages_3_2 = throw "rubyPackages_3_2 has been removed, as it will reach end‐of‐life upstream during Nixpkgs 25.11’s support cycle"; # Added 2025-10-12
  rucksack = throw "rucksack was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  runCommandNoCC = runCommand; # Added 2021-08-15
  runCommandNoCCLocal = runCommandLocal; # Added 2021-08-15
  rust-synapse-state-compress = rust-synapse-compress-state; # Added 2025-03-08
  rustc-wasm32 = rustc; # Added 2023-12-01
  rustic-rs = rustic; # Added 2024-08-02
  ryujinx = throw "'ryujinx' has been replaced by 'ryubing' as the new upstream"; # Added 2025-07-30
  ryujinx-greemdev = ryubing; # Added 2025-01-20
  scantailor = scantailor-advanced; # Added 2022-05-26
  scitoken-cpp = scitokens-cpp; # Added 2024-02-12
  scudcloud = throw "'scudcloud' has been removed as it was archived by upstream"; # Added 2025-07-24
  SDL2_classic = throw "'SDL2_classic' has been removed. Consider upgrading to 'sdl2-compat', also available as 'SDL2'."; # Added 2025-05-20
  SDL2_classic_image = throw "'SDL2_classic_image' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_image' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_mixer = throw "'SDL2_classic_mixer' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_mixer' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_ttf = throw "'SDL2_classic_ttf' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_ttf' built with 'sdl2-compat'."; # Added 2025-05-20
  seafile-server = throw "'seafile-server' has been removed as it is unmaintained"; # Added 2025-08-21
  seahub = throw "'seahub' has been removed as it is unmaintained"; # Added 2025-08-21
  sequoia = sequoia-sq; # Added 2023-06-26
  session-desktop-appimage = session-desktop; # Added 2022-08-31
  setserial = throw "'setserial' has been removed as it had been abandoned upstream"; # Added 2025-05-18
  sexp = sexpp; # Added 2023-07-03
  shadered = throw "shadered has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  shipyard = jumppad; # Added 2023-06-06
  siduck76-st = st-snazzy; # Added 2024-12-24
  sierra-breeze-enhanced = throw "'sierra-breeze-enhanced' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  signal-desktop-source = lib.warnOnInstantiate "'signal-desktop-source' is now exposed at 'signal-desktop'." signal-desktop; # Added 2025-04-16
  simplesamlphp = throw "'simplesamlphp' was removed because it was unmaintained in nixpkgs"; # Added 2025-10-17
  siproxd = throw "'siproxd' has been removed as it was unmaintained and incompatible with newer libosip versions"; # Added 2025-05-18
  sipwitch = throw "'sipwitch' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  sisco.lv2 = throw "'sisco.lv2' has been removed as it was unmaintained and broken"; # Added 2025-08-26
  SkypeExport = throw "'skypeexport' was removed since Skype has been shut down in May 2025"; # Added 2025-09-15
  skypeexport = throw "'skypeexport' was removed since Skype has been shut down in May 2025"; # Added 2025-09-15
  sladeUnstable = slade-unstable; # Added 2025-08-26
  slic3r = throw "'slic3r' has been removed because it is unmaintained"; # Added 2025-08-26
  sloccount = throw "'sloccount' has been removed because it is unmaintained. Consider migrating to 'loccount'"; # added 2025-05-17
  slrn = throw "'slrn' has been removed because it is unmaintained upstream and broken."; # Added 2025-06-11
  slurm-llnl = slurm; # Added 2017-07-31
  smartgithg = smartgit; # Added 2025-03-31
  snapcraft = throw "snapcraft was removed in Sep 25 following removal of LXD from nixpkgs"; # added 2025-09-18
  snort2 = throw "snort2 has been removed as it is deprecated and unmaintained by upstream. Consider using snort (snort3) package instead."; # 2025-05-21
  snowman = throw "snowman has been removed as it is unmaintained by upstream"; # 2025-10-12
  soldat-unstable = opensoldat; # Added 2022-07-02
  somatic-sniper = throw "somatic-sniper has been removed as it was archived in 2020 and fails to build."; # Added 2025-10-14
  sonusmix = throw "'sonusmix' has been removed due to lack of maintenance"; # Added 2025-08-27
  soulseekqt = throw "'soulseekqt' has been removed due to lack of maintenance in Nixpkgs in a long time. Consider using 'nicotine-plus' or 'slskd' instead."; # Added 2025-06-07
  soundkonverter = throw "'soundkonverter' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  soundOfSorting = sound-of-sorting; # Added 2023-07-07
  source-han-sans-japanese = source-han-sans; # Added 2020-02-10
  source-han-sans-korean = source-han-sans; # Added 2020-02-10
  source-han-sans-simplified-chinese = source-han-sans; # Added 2020-02-10
  source-han-sans-traditional-chinese = source-han-sans; # Added 2020-02-10
  source-han-serif-japanese = source-han-serif; # Added 2020-02-10
  source-han-serif-korean = source-han-serif; # Added 2020-02-10
  source-han-serif-simplified-chinese = source-han-serif; # Added 2020-02-10
  source-han-serif-traditional-chinese = source-han-serif; # Added 2020-02-10
  sourceHanSansPackages.japanese = source-han-sans; # Added 2020-02-10
  sourceHanSansPackages.korean = source-han-sans; # Added 2020-02-10
  sourceHanSansPackages.simplified-chinese = source-han-sans; # Added 2020-02-10
  sourceHanSansPackages.traditional-chinese = source-han-sans; # Added 2020-02-10
  sourceHanSerifPackages.japanese = source-han-serif; # Added 2020-02-10
  sourceHanSerifPackages.korean = source-han-serif; # Added 2020-02-10
  sourceHanSerifPackages.simplified-chinese = source-han-serif; # Added 2020-02-10
  sourceHanSerifPackages.traditional-chinese = source-han-serif; # Added 2020-02-10
  sourcehut = throw "'sourcehut.*' has been removed due to being broken and unmaintained"; # Added 2025-06-15
  SP800-90B_EntropyAssessment = sp800-90b-entropyassessment; # Added on 2024-06-12
  space-orbit = throw "'space-orbit' has been removed because it is unmaintained; Debian upstream stopped tracking it in 2011."; # Added 2025-06-08
  SPAdes = spades; # Added 2024-06-12
  spago = spago-legacy; # Added 2025-09-23, pkgs.spago should become spago@next which hasn't been packaged yet
  spark2014 = gnatprove; # Added 2024-02-25
  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spidermonkey_91 = throw "'spidermonkey_91 is EOL since 2022/09"; # Added 2025-08-26
  spotify-unwrapped = spotify; # added 2022-11-06
  spring = throw "spring has been removed, as it had been broken since 2023 (it was a game; maybe you’re thinking of spring-boot-cli?)"; # Added 2025-09-16
  springLobby = throw "springLobby has been removed, as it had been broken since 2023"; # Added 2025-09-16
  sqlbag = throw "sqlbag has been removed because it has been marked as broken since May 2024."; # Added 2025-10-11
  ssm-agent = amazon-ssm-agent; # Added 2023-10-17
  starpls-bin = starpls; # Added 2024-10-30
  station = throw "station has been removed from nixpkgs, as there were no committers among its maintainers to unblock security issues"; # added 2025-06-16
  steam-run-native = steam-run; # added 2022-02-21
  steam-small = steam; # Added 2024-09-12
  steamcontroller = throw "'steamcontroller' has been removed due to lack of upstream maintenance. Consider using 'sc-controller' instead."; # Added 2025-09-20
  steamPackages.steam = lib.warnOnInstantiate "`steamPackages.steam` has been moved to top level as `steam-unwrapped`" steam-unwrapped; # Added 2024-10-16
  steamPackages.steam-fhsenv = lib.warnOnInstantiate "`steamPackages.steam-fhsenv` has been moved to top level as `steam`" steam; # Added 2024-10-16
  steamPackages.steam-fhsenv-small = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-small` has been moved to top level as `steam`; there is no longer a -small variant" steam; # Added 2024-10-16
  steamPackages.steamcmd = lib.warnOnInstantiate "`steamPackages.steamcmd` has been moved to top level as `steamcmd`" steamcmd; # Added 2024-10-16
  StormLib = stormlib; # Added 2024-01-21
  strawberry-qt5 = throw "strawberry-qt5 has been replaced by strawberry"; # Added 2024-11-22 and updated 2025-07-19
  strawberry-qt6 = throw "strawberry-qt6 has been replaced by strawberry"; # Added 2025-07-19
  subberthehut = throw "'subberthehut' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  sublime-music = throw "`sublime-music` has been removed because upstream has announced it is no longer maintained. Upstream suggests using `supersonic` instead."; # Added 2025-09-20
  substituteAll = throw "`substituteAll` has been removed. Use `replaceVars` instead."; # Added 2025-05-23
  substituteAllFiles = throw "`substituteAllFiles` has been removed. Use `replaceVars` for each file instead."; # Added 2025-05-23
  suitesparse_4_2 = throw "'suitesparse_4_2' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  suitesparse_4_4 = throw "'suitesparse_4_4' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  sumaclust = throw "'sumaclust' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumalibs = throw "'sumalibs' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumatra = throw "'sumatra' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumneko-lua-language-server = lua-language-server; # Added 2023-02-07
  swig4 = swig; # Added 2024-09-12
  swiProlog = lib.warnOnInstantiate "swiProlog has been renamed to swi-prolog" swi-prolog; # Added 2024-09-07
  swiPrologWithGui = lib.warnOnInstantiate "swiPrologWithGui has been renamed to swi-prolog-gui" swi-prolog-gui; # Added 2024-09-07
  Sylk = sylk; # Added 2024-06-12
  symbiyosys = sby; # Added 2024-08-18
  syn2mas = throw "'syn2mas' has been removed. It has been integrated into the main matrix-authentication-service CLI as a subcommand: 'mas-cli syn2mas'."; # Added 2025-07-07
  sync = taler-sync; # Added 2024-09-04
  syncall = throw "'syncall' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  syncthing-tray = throw "syncthing-tray has been removed because it is broken and unmaintained"; # Added 2025-05-18
  syncthingtray-qt6 = syncthingtray; # Added 2024-03-06
  syndicate_utils = throw "'syndicate_utils' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  t1lib = throw "'t1lib' has been removed as it was broken and unmaintained upstream."; # Added 2025-06-11
  tamgamp.lv2 = tamgamp-lv2; # Added 2025-09-27
  taplo-cli = taplo; # Added 2022-07-30
  taplo-lsp = taplo; # Added 2022-07-30
  targetcli = targetcli-fb; # Added 2025-03-14
  taro = taproot-assets; # Added 2023-07-04
  taskwarrior = lib.warnOnInstantiate "taskwarrior was replaced by taskwarrior3, which requires manual transition from taskwarrior 2.6, read upstream's docs: https://taskwarrior.org/docs/upgrade-3/" taskwarrior2; # Added 2024-08-14
  tbb = onetbb; # Added 2025-09-14
  tbb_2020 = throw "tbb_2020 has been removed because it is unmaintained upstream and had no remaining users; use onetbb"; # Added 2025-09-14
  tbb_2021 = throw "tbb_2021 has been removed because it is unmaintained upstream and had no remaining users; use onetbb"; # Added 2025-09-13
  tbb_2022 = onetbb; # Added 2025-09-14
  tcl-fcgi = tclPackages.tcl-fcgi; # Added 2024-10-02
  tclcurl = tclPackages.tclcurl; # Added 2024-10-02
  tcllib = tclPackages.tcllib; # Added 2024-10-02
  tclmagick = tclPackages.tclmagick; # Added 2024-10-02
  tcltls = tclPackages.tcltls; # Added 2024-10-02
  tcludp = tclPackages.tcludp; # Added 2024-10-02
  tclvfs = tclPackages.tclvfs; # Added 2024-10-02
  tclx = tclPackages.tclx; # Added 2024-10-02
  tcp-cutter = throw "tcp-cutter has been removed because it fails to compile and the source url is dead"; # Added 2025-05-25
  tdesktop = telegram-desktop; # Added 2023-04-07
  tdlib-purple = pidginPackages.tdlib-purple; # Added 2023-07-17
  tdom = tclPackages.tdom; # Added 2024-10-02
  teamspeak5_client = teamspeak6-client; # Added 2025-01-29
  teamspeak_client = teamspeak3; # Added 2024-11-07
  tegaki-zinnia-japanese = throw "'tegaki-zinnia-japanese' has been removed due to lack of maintenance"; # Added 2025-09-10
  temporalite = throw "'temporalite' has been removed as it is obsolete and unmaintained, please use 'temporal-cli' instead (with `temporal server start-dev`)"; # Added 2025-06-26
  temurin-bin-24 = throw "Temurin 24 has been removed as it has reached its end of life"; # Added 2025-10-04
  temurin-jre-bin-24 = throw "Temurin 24 has been removed as it has reached its end of life"; # Added 2025-10-04
  tepl = libgedit-tepl; # Added 2024-04-29
  terminus-nerdfont = lib.warnOnInstantiate "terminus-nerdfont is redundant. Use nerd-fonts.terminess-ttf instead." nerd-fonts.terminess-ttf; # Added 2024-11-10
  testVersion = testers.testVersion; # Added 2022-04-20
  tet = throw "'tet' has been removed for lack of maintenance"; # Added 2025-10-12
  texinfo4 = throw "'texinfo4' has been removed in favor of the latest version"; # Added 2025-06-08
  textual-paint = throw "'textual-paint' has been removed as it is broken"; # Added 2025-09-10
  tezos-rust-libs = throw "ligo has been removed from nixpkgs for lack of maintainance"; # Added 2025-06-03
  tfplugindocs = terraform-plugin-docs; # Added 2023-11-01
  thefuck = throw "'thefuck' has been removed due to lack of maintenance upstream and incompatible with python 3.12+. Consider using 'pay-respects' instead"; # Added 2025-05-30
  theLoungePlugins = throw "'theLoungePlugins' has been removed due to only containing throws"; # Added 2025-09-25
  thrust = throw "'thrust' has been removed due to lack of maintenance"; # Added 2025-08-21
  thunderbird-128 = throw "Thunderbird 128 support ended in August 2025"; # Added 2025-09-30
  thunderbird-128-unwrapped = throw "Thunderbird 128 support ended in August 2025"; # Added 2025-09-30
  ticpp = throw "'ticpp' has been removed due to being unmaintained"; # Added 2025-09-10
  timescaledb = throw "'timescaledb' has been removed. Use 'postgresqlPackages.timescaledb' instead."; # Added 2025-07-19
  tinyxml2 = throw "The 'tinyxml2' alias has been removed, use 'tinyxml' for https://sourceforge.net/projects/tinyxml/ or 'tinyxml-2' for https://github.com/leethomason/tinyxml2"; # Added 2025-10-11
  tix = tclPackages.tix; # Added 2024-10-02
  tkcvs = tkrev; # Added 2022-03-07
  tkgate = throw "'tkgate' has been removed as it is unmaintained"; # Added 2025-05-17
  tkimg = tclPackages.tkimg; # Added 2024-10-02
  tlaplusToolbox = tlaplus-toolbox; # Added 2025-08-21
  tokyo-night-gtk = tokyonight-gtk-theme; # Added 2024-01-28
  tomcat_connectors = apacheHttpdPackages.mod_jk; # Added 2024-06-07
  tooling-language-server = deputy; # Added 2025-06-22
  tor-browser-bundle-bin = tor-browser; # Added 2023-09-23
  tracker = lib.warnOnInstantiate "tracker has been renamed to tinysparql" tinysparql; # Added 2024-09-30
  tracker-miners = lib.warnOnInstantiate "tracker-miners has been renamed to localsearch" localsearch; # Added 2024-09-30
  transfig = fig2dev; # Added 2022-02-15
  transifex-client = transifex-cli; # Added 2023-12-29
  transmission = lib.warnOnInstantiate (transmission3Warning { }) transmission_3; # Added 2024-06-10
  transmission-gtk = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-gtk";
  }) transmission_3-gtk; # Added 2024-06-10
  transmission-qt = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-qt";
  }) transmission_3-qt; # Added 2024-06-10
  treefmt2 = lib.warnOnInstantiate "treefmt2 has been renamed to treefmt" treefmt; # 2025-03-06
  trenchbroom = throw "trenchbroom was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  trezor_agent = trezor-agent; # Added 2024-01-07
  trilium-next-desktop = trilium-desktop; # Added 2025-08-30
  trilium-next-server = trilium-server; # Added 2025-08-30
  trojita = throw "'trojita' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  trust-dns = hickory-dns; # Added 2024-08-07
  tt-rss = throw "'tt-rss' has been removed, as it was discontinued on 2025-11-01"; # Added 2025-10-03
  tt-rss-plugin-auth-ldap = throw "'tt-rss-plugin-auth-ldap' has been removed, as tt-rss was discontinued and removed"; # Added 2025-10-03
  tt-rss-plugin-data-migration = throw "'tt-rss-plugin-data-migration' has been removed, as tt-rss was discontinued and removed"; # Added 2025-10-03
  tt-rss-plugin-feediron = throw "'tt-rss-plugin-feediron' has been removed, as tt-rss was discontinued and removed"; # Added 2025-10-03
  tt-rss-plugin-feedly = throw "'tt-rss-plugin-feedly' has been removed, as tt-rss was discontinued and removed"; # Added 2025-10-03
  tt-rss-plugin-ff-instagram = throw "'tt-rss-plugin-ff-instagram' has been removed, as tt-rss was discontinued and removed"; # Added 2025-10-03
  tt-rss-plugin-freshapi = throw "'tt-rss-plugin-freshapi' has been removed, as tt-rss was discontinued and removed"; # Added 2025-10-03
  tvbrowser-bin = tvbrowser; # Added 2023-03-02
  typst-fmt = typstfmt; # Added 2023-07-15
  uade123 = uade; # Added 2022-07-30
  uae = throw "'uae' has been removed due to lack of upstream maintenance. Consider using 'fsuae' instead."; # Added 2025-06-11
  ubuntu_font_family = ubuntu-classic; # Added 2024-02-19
  uclibc = uclibc-ng; # Added 2022-06-16
  unicap = throw "'unicap' has been removed because it is unmaintained"; # Added 2025-05-17
  unifi-poller = unpoller; # Added 2022-11-24
  unzoo = throw "'unzoo' has been removed since it is unmaintained upstream and doesn't compile with newer versions of GCC anymore"; # Removed 2025-05-24
  util-linuxCurses = util-linux; # Added 2022-04-12
  utillinux = util-linux; # Added 2020-11-24
  vaapiIntel = intel-vaapi-driver; # Added 2023-05-31
  vaapiVdpau = libva-vdpau-driver; # Added 2024-06-05
  valum = throw "'valum' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  vamp.vampSDK = vamp-plugin-sdk; # Added 2020-03-26
  vaultwarden-vault = vaultwarden.webvault; # Added 2022-12-13
  vbetool = throw "'vbetool' has been removed as it is broken and not maintained upstream."; # Added 2025-06-11
  vc_0_7 = throw "'vc_0_7' has been removed as it was broken, unused in nixpkgs and unmaintained"; # Added 2025-10-20
  vdirsyncerStable = vdirsyncer; # Added 2020-11-08
  ventoy-bin = ventoy; # Added 2023-04-12
  ventoy-bin-full = ventoy-full; # Added 2023-04-12
  verilog = iverilog; # Added 2024-07-12
  veriT = verit; # Added 2025-08-21
  vieb = throw "'vieb' has been removed as it doesn't satisfy our security criteria for browsers."; # Added 2025-06-25
  ViennaRNA = viennarna; # Added 2023-08-23
  vim_configurable = vim-full; # Added 2022-12-04
  vimHugeX = vim-full; # Added 2022-12-04
  virt-manager-qt = throw "'virt-manager-qt' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  virtkey = throw "'virtkey' has been removed, as it was unmaintained, abandoned upstream, and relied on gtk2."; # Added 2025-10-12
  vistafonts = vista-fonts; # Added 2025-02-03
  vistafonts-chs = vista-fonts-chs; # Added 2025-02-03
  vistafonts-cht = vista-fonts-cht; # Added 2025-02-03
  vkBasalt = vkbasalt; # Added 2022-11-22
  vkdt-wayland = vkdt; # Added 2024-04-19
  volk_2 = throw "'volk_2' has been removed after not being used by any package for a long time"; # Added 2025-10-25
  voxelands = throw "'voxelands' has been removed due to lack of upstream maintenance"; # Added 2025-08-30
  vtk_9 = lib.warnOnInstantiate "'vtk_9' has been renamed to 'vtk_9_5'" vtk_9_5; # Added 2025-07-18
  vtk_9_egl = lib.warnOnInstantiate "'vtk_9_5' now build with egl support by default, so `vtk_9_egl` is deprecated, consider using 'vtk_9_5' instead." vtk_9_5; # Added 2025-07-18
  vtk_9_withQt5 = throw "'vtk_9_withQt5' has been removed, Consider using 'vtkWithQt6' instead."; # Added 2025-07-18
  vtkWithQt5 = throw "'vtkWithQt5' has been removed. Consider using 'vtkWithQt6' instead."; # Added 2025-09-06
  vwm = throw "'vwm' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  w_scan = throw "'w_scan' has been removed due to lack of upstream maintenance"; # Added 2025-08-29
  waitron = throw "'waitron' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  wakatime = wakatime-cli; # 2024-05-30
  wapp = tclPackages.wapp; # Added 2024-10-02
  warsow = throw "'warsow' has been removed as it is unmaintained and is broken"; # Added 2025-10-09
  warsow-engine = throw "'warsow-engine' has been removed as it is unmaintained and is broken"; # Added 2025-10-09
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_104;
  wavebox = throw "'wavebox' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-24
  wavm = throw "wavm has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  wcurl = throw "'wcurl' has been removed due to being bundled with 'curl'"; # Added 2025-07-04
  wdomirror = throw "'wdomirror' has been removed as it is unmaintained upstream, Consider using 'wl-mirror' instead"; # Added 2025-09-04
  webfontkitgenerator = webfont-bundler; # Added 2025-07-27
  webkitgtk = throw "'webkitgtk' attribute has been removed from nixpkgs, use attribute with ABI version set explicitly"; # Added 2025-06-11
  webkitgtk_4_0 = throw "'webkitgtk_4_0' has been removed, port to `libsoup_3` and switch to `webkitgtk_4_1`"; # Added 2025-10-08
  whatsapp-for-linux = wasistlos; # Added 2025-01-30
  wifi-password = throw "'wifi-password' has been removed as it was unmaintained upstream"; # Added 2025-08-29
  win-pvdrivers = throw "'win-pvdrivers' has been removed as it was subject to the Xen build machine compromise (XSN-01) and has open security vulnerabilities (XSA-468)"; # Added 2025-08-29
  win-virtio = virtio-win; # Added 2023-10-17
  wineWayland = wine-wayland; # Added 2022-01-03
  winhelpcgi = throw "'winhelpcgi' has been removed as it was unmaintained upstream and broken with GCC 14"; # Added 2025-06-14
  wkhtmltopdf-bin = wkhtmltopdf; # Added 2024-07-17
  wmii_hg = wmii; # Added 2022-04-26
  woof = throw "'woof' has been removed as it is broken and unmaintained upstream"; # Added 2025-09-04
  worldengine-cli = throw "'worldengine-cli' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-04
  wpa_supplicant_ro_ssids = lib.warnOnInstantiate "Deprecated package: Please use wpa_supplicant instead. Read-only SSID patches are now upstream!" wpa_supplicant; # Added 2024-07-28
  wrapGAppsHook = wrapGAppsHook3; # Added 2024-03-26
  write_stylus = styluslabs-write-bin; # Added 2024-10-09
  wxGTK33 = wxwidgets_3_3; # Added 2025-07-20
  xbrightness = throw "'xbrightness' has been removed as it is unmaintained"; # Added 2025-08-28
  xbursttools = throw "'xbursttools' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-12
  xdragon = dragon-drop; # Added 2025-03-22
  xflux = throw "'xflux' has been removed as it was unmaintained"; # Added 2025-08-22
  xflux-gui = throw "'xflux-gui' has been removed as it was unmaintained"; # Added 2025-08-22
  xinput_calibrator = xinput-calibrator; # Added 2025-08-28
  xjump = throw "'xjump' has been removed as it is unmaintained"; # Added 2025-08-22
  xmlada = gnatPackages.xmlada; # Added 2024-02-25
  xmlroff = throw "'xmlroff' has been removed as it is unmaintained and broken"; # Added 2025-05-18
  xo = throw "Use 'dbtpl' instead of 'xo'"; # Added 2025-09-28
  xonsh-unwrapped = python3Packages.xonsh; # Added 2024-06-18
  xorg-autoconf = util-macros; # Added 2025-08-18
  xsw = throw "'xsw' has been removed due to lack of upstream maintenance"; # Added 2025-08-22
  xulrunner = firefox-unwrapped; # Added 2023-11-03
  yabar = throw "'yabar' has been removed as the upstream project was archived"; # Added 2025-06-10
  yabar-unstable = throw "'yabar' has been removed as the upstream project was archived"; # Added 2025-06-10
  yafaray-core = libyafaray; # Added 2022-09-23
  yaml-cpp_0_3 = throw "yaml-cpp_0_3 has been removed, as it was unused"; # Added 2025-09-16
  yamlpath = throw "'yamlpath' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  yeahwm = throw "'yeahwm' has been removed, as it was broken and unmaintained upstream."; # Added 2025-06-12
  yubikey-manager-qt = throw "'yubikey-manager-qt' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  yubikey-personalization-gui = throw "'yubikey-personalization-gui' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  zandronum-alpha = throw "'zandronum-alpha' has been removed as it was broken and the stable version has caught up"; # Added 2025-10-19
  zandronum-alpha-server = throw "'zandronum-alpha-server' has been removed as it was broken and the stable version has caught up"; # Added 2025-10-19
  zbackup = throw "'zbackup' has been removed due to being unmaintained upstream"; # Added 2025-08-22
  zeal-qt5 = lib.warnOnInstantiate "'zeal-qt5' has been removed from nixpkgs. Please use 'zeal' instead" zeal; # Added 2025-08-31
  zeal-qt6 = lib.warnOnInstantiate "'zeal-qt6' has been renamed to 'zeal'" zeal; # Added 2025-08-31
  zeroadPackages.zeroad = lib.warnOnInstantiate "'zeroadPackages.zeroad' has been renamed to 'zeroad'" zeroad; # Added 2025-03-22
  zeroadPackages.zeroad-data = lib.warnOnInstantiate "'zeroadPackages.zeroad-data' has been renamed to 'zeroad-data'" zeroad-data; # Added 2025-03-22
  zeroadPackages.zeroad-unwrapped = lib.warnOnInstantiate "'zeroadPackages.zeroad-unwrapped' has been renamed to 'zeroad-unwrapped'" zeroad-unwrapped; # Added 2025-03-22
  zeromq4 = zeromq; # Added 2024-11-03
  zfsStable = zfs; # Added 2024-02-26
  zfsUnstable = zfs_unstable; # Added 2024-02-26
  zig_0_12 = throw "zig 0.12 has been removed, upgrade to a newer version instead"; # Added 2025-08-18
  zigbee2mqtt_1 = throw "Zigbee2MQTT 1.x has been removed, upgrade to the unversioned attribute."; # Added 2025-08-11
  zigbee2mqtt_2 = zigbee2mqtt; # Added 2025-08-11
  zinc = zincsearch; # Added 2023-05-28
  zint = zint-qt; # Added 2025-05-15
  zombietrackergps = throw "'zombietrackergps' has been dropped, as it depends on KDE Gear 5 and is unmaintained"; # Added 2025-08-20
  zotify = throw "zotify has been removed due to lack of upstream maintenance"; # Added 2025-09-26
  zq = throw "zq has been replaced by zed"; # Converted to throw 2025-10-26
  zsh-git-prompt = throw "zsh-git-prompt was removed as it is unmaintained upstream"; # Added 2025-08-28
  zyn-fusion = zynaddsubfx; # Added 2022-08-05
  # keep-sorted end
}
// plasma5Throws
