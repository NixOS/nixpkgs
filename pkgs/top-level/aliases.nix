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
      isoimagewriter
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
      neochat # Added 2025-07-04
      itinerary # Added 2025-07-04
      libquotient # Added 2025-07-04
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

  warnAlias =
    msg: v:
    if lib.isDerivation v then
      lib.warnOnInstantiate msg v
    else if lib.isAttrs v then
      lib.mapAttrs (_: lib.warn msg) v
    else if lib.isFunction v then
      arg: lib.warn msg (v arg)
    else if lib.isList v then
      map (lib.warn msg) v
    else
      # Can’t do better than this, and a `throw` would be more
      # disruptive for users…
      #
      # `nix search` flags up warnings already, so hopefully this won’t
      # make things much worse until we have proper CI for aliases,
      # especially since aliases of paths and numbers are presumably
      # not common.
      lib.warn msg v;
in

mapAliases {
  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_latest = llvmPackages_21;
  llvmPackages_git = (callPackages ../development/compilers/llvm { }).git;
  # these are for convenience, not for backward compat., and shouldn't expire until the package is deprecated.
  clang18Stdenv = lib.lowPrio llvmPackages_18.stdenv;
  clang19Stdenv = lib.lowPrio llvmPackages_19.stdenv;

  # Various to preserve
  autoReconfHook = throw "You meant 'autoreconfHook', with a lowercase 'r'."; # preserve, reason: common typo
  elasticsearch7Plugins = elasticsearchPlugins; # preserve, reason: until v8
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve, reason: common typo
  fuse2fs = if stdenv.hostPlatform.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  uclibc = uclibc-ng; # preserve, because uclibc-ng can't be used in config string
  wlroots = wlroots_0_19; # preserve, reason: wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name

  # keep-sorted start case=no numeric=yes block=yes

  _0verkill = throw "'_0verkill' has been removed due to lack of maintenance"; # Added 2025-08-27
  _1password = throw "'_1password' has been renamed to/replaced by '_1password-cli'"; # Converted to throw 2025-10-27
  _2048-cli = throw "'_2048-cli' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-curses = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-terminal = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  a4term = throw "'a4term' has been renamed to/replaced by 'a4'"; # Converted to throw 2025-10-27
  abseil-cpp_202301 = throw "abseil-cpp_202301 has been removed as it was unused in tree"; # Added 2025-08-09
  abseil-cpp_202501 = throw "abseil-cpp_202501 has been removed as it was unused in tree"; # Added 2025-09-15
  adminer-pematon = throw "'adminer-pematon' has been renamed to/replaced by 'adminneo'"; # Converted to throw 2025-10-27
  adminerneo = throw "'adminerneo' has been renamed to/replaced by 'adminneo'"; # Converted to throw 2025-10-27
  adobe-reader = throw "'adobe-reader' has been removed, as it was broken, outdated and insecure"; # Added 2025-05-31
  afpfs-ng = throw "'afpfs-ng' has been removed as it was broken and unmaintained for 10 years"; # Added 2025-05-17
  akkoma-emoji = throw "'akkoma-emoji' has been renamed to/replaced by 'blobs_gg'"; # Converted to throw 2025-10-27
  akkoma-frontends.admin-fe = throw "'akkoma-frontends.admin-fe' has been renamed to/replaced by 'akkoma-admin-fe'"; # Converted to throw 2025-10-27
  akkoma-frontends.akkoma-fe = throw "'akkoma-frontends.akkoma-fe' has been renamed to/replaced by 'akkoma-fe'"; # Converted to throw 2025-10-27
  amazon-qldb-shell = throw "'amazon-qldb-shell' has been removed due to being unmaintained upstream"; # Added 2025-07-30
  amdvlk = throw "'amdvlk' has been removed since it was deprecated by AMD. Its replacement, RADV, is enabled by default."; # Added 2025-09-20
  ams-lv2 = throw "'ams-lv2' has been removed due to being archived upstream."; # Added 2025-10-26
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
  ao = throw "'ao' has been renamed to/replaced by 'libfive'"; # Converted to throw 2025-10-27
  apacheAnt = throw "'apacheAnt' has been renamed to/replaced by 'ant'"; # Converted to throw 2025-10-27
  apacheKafka_3_7 = throw "apacheKafka_2_8 through _3_8 have been removed from nixpkgs as outdated"; # Added 2025-09-27
  apacheKafka_3_8 = throw "apacheKafka_2_8 through _3_8 have been removed from nixpkgs as outdated"; # Added 2025-09-27
  apple-sdk_11 = throw "apple-sdk_11 was removed as Nixpkgs no longer supports macOS 11; see the 25.11 release notes"; # Added 2025-05-10
  apple-sdk_12 = throw "apple-sdk_12 was removed as Nixpkgs no longer supports macOS 12; see the 25.11 release notes"; # Added 2025-05-10
  apple-sdk_13 = throw "apple-sdk_13 was removed as Nixpkgs no longer supports macOS 13; see the 25.11 release notes"; # Added 2025-05-10
  appthreat-depscan = throw "'appthreat-depscan' has been renamed to/replaced by 'dep-scan'"; # Converted to throw 2025-10-27
  arangodb = throw "arangodb has been removed, as it was unmaintained and the packaged version does not build with supported GCC versions"; # Added 2025-08-12
  arc-browser = throw "arc-browser was removed due to being unmaintained"; # Added 2025-09-03
  archi = throw "'archi' has been removed, since its upstream maintainers do not want it packaged"; # Added 2025-11-18
  archipelago-minecraft = throw "archipelago-minecraft has been removed, as upstream no longer ships minecraft as a default APWorld."; # Added 2025-07-15
  archivebox = throw "archivebox has been removed, since the packaged version was stuck on django 3."; # Added 2025-08-01
  ardour_7 = throw "ardour_7 has been removed because it relies on gtk2, please use ardour instead."; # Added 2025-10-04
  argo = throw "'argo' has been renamed to/replaced by 'argo-workflows'"; # Converted to throw 2025-10-27
  aria = throw "'aria' has been renamed to/replaced by 'aria2'"; # Converted to throw 2025-10-27
  arrayfire = throw "arrayfire was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  artichoke = throw "artichoke has been removed due to being archived upstream."; # Added 2025-11-04
  artim-dark = aritim-dark; # Added 2025-07-27
  aseprite-unfree = throw "'aseprite-unfree' has been renamed to/replaced by 'aseprite'"; # Converted to throw 2025-10-27
  asitop = throw "'asitop' has been renamed to/replaced by 'macpm'"; # Converted to throw 2025-10-27
  asterisk_18 = throw "asterisk_18: Asterisk 18 is end of life and has been removed"; # Added 2025-10-19
  atlassian-cli = appfire-cli; # Added 2025-09-29
  ats = throw "'ats' has been removed as it is unmaintained for 10 years and broken"; # Added 2025-05-17
  AusweisApp2 = throw "'AusweisApp2' has been renamed to/replaced by 'ausweisapp'"; # Converted to throw 2025-10-27
  autoconf213 = throw "'autoconf213' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  autoconf264 = throw "'autoconf264' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  automake111x = throw "'automake111x' has been removed in favor of 'automake'"; # Added 2025-07-21
  autopanosiftc = throw "'autopanosiftc' has been removed, as it is unmaintained upstream"; # Added 2025-10-07
  autoreconfHook264 = throw "'autoreconfHook264' has been removed in favor of 'autoreconfHook'"; # Added 2025-07-21
  av-98 = throw "'av-98' has been removed because it has been broken since at least November 2024."; # Added 2025-10-03
  avr-sim = throw "'avr-sim' has been removed as it was broken and unmaintained. Possible alternatives are 'simavr', SimulAVR and AVRStudio."; # Added 2025-05-31
  awesome-4-0 = throw "'awesome-4-0' has been renamed to/replaced by 'awesome'"; # Converted to throw 2025-10-27
  awf = throw "'awf' has been removed as the upstream project was archived in 2021"; # Added 2025-10-03
  axmldec = throw "'axmldec' has been removed as it was broken and unmaintained for 8 years"; # Added 2025-05-17
  backlight-auto = throw "'backlight-auto' has been removed as it relies on Zig 0.12 which has been dropped."; # Added 2025-08-22
  badtouch = throw "'badtouch' has been renamed to/replaced by 'authoscope'"; # Converted to throw 2025-10-27
  bandwidth = throw "'bandwidth' has been removed due to lack of maintenance"; # Added 2025-09-01
  banking = saldo; # Added 2025-08-29
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
  binserve = throw "'binserve' has been removed because it is unmaintained upstream."; # Added 2025-11-29
  bitbucket-server-cli = throw "bitbucket-server-cli has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  bitcoin-abc = throw "bitcoin-abc has been removed due to a lack of maintanance"; # Added 2025-06-17
  bitcoind-abc = throw "bitcoind-abc has been removed due to a lack of maintanance"; # Added 2025-06-17
  bitmeter = throw "bitmeter has been removed, use `x42-meter 18` from the x42-plugins pkg instead."; # Added 2025-10-03
  bitwarden = throw "'bitwarden' has been renamed to/replaced by 'bitwarden-desktop'"; # Converted to throw 2025-10-27
  bitwarden_rs = throw "'bitwarden_rs' has been renamed to/replaced by 'vaultwarden'"; # Converted to throw 2025-10-27
  bitwarden_rs-mysql = throw "'bitwarden_rs-mysql' has been renamed to/replaced by 'vaultwarden-mysql'"; # Converted to throw 2025-10-27
  bitwarden_rs-postgresql = throw "'bitwarden_rs-postgresql' has been renamed to/replaced by 'vaultwarden-postgresql'"; # Converted to throw 2025-10-27
  bitwarden_rs-sqlite = throw "'bitwarden_rs-sqlite' has been renamed to/replaced by 'vaultwarden-sqlite'"; # Converted to throw 2025-10-27
  bitwarden_rs-vault = throw "'bitwarden_rs-vault' has been renamed to/replaced by 'vaultwarden-vault'"; # Converted to throw 2025-10-27
  blas-reference = throw "blas-reference has been removed since it has been discontinued as free-standing package. It is now contained within lapack-reference."; # Added 2025-10-21
  blender-with-packages = throw "blender-with-packages is deprecated in in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"; # Converted to throw 2025-10-26
  blockbench-electron = throw "'blockbench-electron' has been renamed to/replaced by 'blockbench'"; # Converted to throw 2025-10-27
  bloomeetunes = throw "bloomeetunes is unmaintained and has been removed"; # Added 2025-08-26
  bmap-tools = throw "'bmap-tools' has been renamed to/replaced by 'bmaptool'"; # Converted to throw 2025-10-27
  botan2 = throw "botan2 has been removed as it is EOL"; # Added 2025-10-20
  bower2nix = throw "bower2nix has been removed as bower was removed. It is recommended to migrate to yarn."; # Added 2025-09-17
  brasero-original = throw "'brasero-original' has been renamed to/replaced by 'brasero-unwrapped'"; # Converted to throw 2025-10-27
  breath-theme = throw "'breath-theme' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  brogue = warnAlias "Use 'brogue-ce' instead of 'brogue' for updated releases" brogue-ce; # Added 2025-10-04
  btanks = throw "'btanks' has been removed as it's been unmaintained since 2010 and fails to build"; # Added 2025-11-29
  buildBowerComponents = throw "buildBowerComponents has been removed as bower was removed. It is recommended to migrate to yarn."; # Added 2025-09-17
  buildGo123Module = throw "Go 1.23 is end-of-life, and 'buildGo123Module' has been removed. Please use a newer builder version."; # Added 2025-08-13
  buildPlatform = warnAlias "'buildPlatform' has been renamed to/replaced by 'stdenv.buildPlatform'" stdenv.buildPlatform; # Converted to warning 2025-10-28
  buildXenPackage = throw "'buildXenPackage' has been removed as a custom Xen build can now be achieved by simply overriding 'xen'."; # Added 2025-05-12
  bullet-roboschool = throw "'bullet-roboschool' has been removed as its build was broken and it was deprecated with its last update in 2019."; # Added 2025-11-15
  bwidget = throw "'bwidget' has been renamed to/replaced by 'tclPackages.bwidget'"; # Converted to throw 2025-10-27
  bzrtp = throw "'bzrtp' has been moved to 'linphonePackages.bzrtp'"; # Added 2025-09-20
  calculix = throw "'calculix' has been renamed to/replaced by 'calculix-ccx'"; # Converted to throw 2025-10-27
  calligra = throw "'calligra' has been renamed to/replaced by 'kdePackages.calligra'"; # Converted to throw 2025-10-27
  callPackage_i686 = throw "'callPackage_i686' has been renamed to/replaced by 'pkgsi686Linux.callPackage'"; # Converted to throw 2025-10-27
  canonicalize-jars-hook = throw "'canonicalize-jars-hook' has been renamed to/replaced by 'stripJavaArchivesHook'"; # Converted to throw 2025-10-27
  cardboard = throw "cardboard has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  cargo-espflash = throw "'cargo-espflash' has been renamed to/replaced by 'espflash'"; # Converted to throw 2025-10-27
  cargonode = throw "'cargonode' has been removed due to lack of upstream maintenance"; # Added 2025-06-18
  cask = throw "'cask' has been renamed to/replaced by 'emacs.pkgs.cask'"; # Converted to throw 2025-10-27
  catalyst-browser = throw "'catalyst-browser' has been removed due to a lack of maintenance and not satisfying our security criteria for browsers."; # Added 2025-06-25
  cataract = throw "'cataract' has been removed due to a lack of maintenace"; # Added 2025-08-25
  cataract-unstable = throw "'cataract-unstable' has been removed due to a lack of maintenace"; # Added 2025-08-25
  catch = throw "catch has been removed. Please upgrade to catch2 or catch2_3"; # Added 2025-08-21
  cereal_1_3_0 = throw "cereal_1_3_0 has been removed as it was unused; use cereal intsead"; # Added 2025-09-12
  cereal_1_3_2 = throw "cereal_1_3_2 is now the only version and has been renamed to cereal"; # Added 2025-09-12
  certmgr-selfsigned = throw "'certmgr-selfsigned' has been renamed to/replaced by 'certmgr'"; # Converted to throw 2025-10-27
  challenger = throw "'challenger' has been renamed to/replaced by 'taler-challenger'"; # Converted to throw 2025-10-27
  charmcraft = throw "charmcraft was removed in Sep 25 following removal of LXD from nixpkgs"; # Added 2025-09-18
  chatgpt-retrieval-plugin = throw "chatgpt-retrieval-plugin has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  check-esxi-hardware = throw "'check-esxi-hardware' has been renamed to/replaced by 'nagiosPlugins.check_esxi_hardware'"; # Converted to throw 2025-10-27
  check-mssql-health = throw "'check-mssql-health' has been renamed to/replaced by 'nagiosPlugins.check_mssql_health'"; # Converted to throw 2025-10-27
  check-nwc-health = throw "'check-nwc-health' has been renamed to/replaced by 'nagiosPlugins.check_nwc_health'"; # Converted to throw 2025-10-27
  check-openvpn = throw "'check-openvpn' has been renamed to/replaced by 'nagiosPlugins.check_openvpn'"; # Converted to throw 2025-10-27
  check-ups-health = throw "'check-ups-health' has been renamed to/replaced by 'nagiosPlugins.check_ups_health'"; # Converted to throw 2025-10-27
  check-uptime = throw "'check-uptime' has been renamed to/replaced by 'nagiosPlugins.check_uptime'"; # Converted to throw 2025-10-27
  check-wmiplus = throw "'check-wmiplus' has been renamed to/replaced by 'nagiosPlugins.check_wmi_plus'"; # Converted to throw 2025-10-27
  check_smartmon = throw "'check_smartmon' has been renamed to/replaced by 'nagiosPlugins.check_smartmon'"; # Converted to throw 2025-10-27
  check_systemd = throw "'check_systemd' has been renamed to/replaced by 'nagiosPlugins.check_systemd'"; # Converted to throw 2025-10-27
  check_zfs = throw "'check_zfs' has been renamed to/replaced by 'nagiosPlugins.check_zfs'"; # Converted to throw 2025-10-27
  checkSSLCert = throw "'checkSSLCert' has been renamed to/replaced by 'nagiosPlugins.check_ssl_cert'"; # Converted to throw 2025-10-27
  chiaki4deck = throw "'chiaki4deck' has been renamed to/replaced by 'chiaki-ng'"; # Converted to throw 2025-10-27
  chit = throw "'chit' has been removed from nixpkgs because it was unmaintained upstream and used insecure dependencies"; # Added 2025-11-28
  chkrootkit = throw "chkrootkit has been removed as it is unmaintained and archived upstream and didn't even work on NixOS"; # Added 2025-09-12
  chocolateDoom = throw "'chocolateDoom' has been renamed to/replaced by 'chocolate-doom'"; # Converted to throw 2025-10-27
  ChowCentaur = throw "'ChowCentaur' has been renamed to/replaced by 'chow-centaur'"; # Converted to throw 2025-10-27
  ChowKick = throw "'ChowKick' has been renamed to/replaced by 'chow-kick'"; # Converted to throw 2025-10-27
  ChowPhaser = throw "'ChowPhaser' has been renamed to/replaced by 'chow-phaser'"; # Converted to throw 2025-10-27
  CHOWTapeModel = throw "'CHOWTapeModel' has been renamed to/replaced by 'chow-tape-model'"; # Converted to throw 2025-10-27
  chrome-gnome-shell = throw "'chrome-gnome-shell' has been renamed to/replaced by 'gnome-browser-connector'"; # Converted to throw 2025-10-27
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
  clang-tools_18 = throw "'clang-tools_18' has been renamed to/replaced by 'llvmPackages_18.clang-tools'"; # Converted to throw 2025-10-27
  clang-tools_19 = throw "'clang-tools_19' has been renamed to/replaced by 'llvmPackages_19.clang-tools'"; # Converted to throw 2025-10-27
  clang_12 = throw "clang_12 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang_13 = throw "clang_13 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang_14 = throw "clang_14 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-10
  clang_15 = throw "clang_15 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-12
  clang_16 = throw "clang_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clang_17 = throw "clang_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  clasp = throw "'clasp' has been renamed to/replaced by 'clingo'"; # Converted to throw 2025-10-27
  cli-visualizer = throw "'cli-visualizer' has been removed as the upstream repository is gone"; # Added 2025-06-05
  clipbuzz = throw "clipbuzz has been removed, as it does not build with supported Zig versions"; # Added 2025-08-09
  cloudlogoffline = throw "cloudlogoffline has been removed"; # Added 2025-05-18
  cockroachdb-bin = throw "'cockroachdb-bin' has been renamed to/replaced by 'cockroachdb'"; # Converted to throw 2025-10-27
  code-browser-gtk2 = throw "'code-browser-gtk2' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  code-browser-gtk = throw "'code-browser-gtk' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  code-browser-qt = throw "'code-browser-qt' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  cog = throw "'cog' has been removed as it depends on unmaintained libraries"; # Added 2025-10-08
  CoinMP = throw "'CoinMP' has been renamed to/replaced by 'coinmp'"; # Converted to throw 2025-10-27
  collada2gltf = throw "collada2gltf has been removed from Nixpkgs, as it has been unmaintained upstream for 5 years and does not build with supported GCC versions"; # Addd 2025-08-08
  colloid-kde = throw "'colloid-kde' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  colorstorm = throw "'colorstorm' has been removed because it was unmaintained in nixpkgs and upstream was rewritten."; # Added 2025-06-15
  conduwuit = throw "'conduwuit' has been removed as the upstream repository has been deleted. Consider migrating to 'matrix-conduit', 'matrix-continuwuity' or 'matrix-tuwunel' instead."; # Added 2025-08-08
  cone = throw "cone has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  connman-ncurses = throw "'connman-ncurses' has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  copilot-language-server-fhs = warnAlias "The package set `copilot-language-server-fhs` has been renamed to `copilot-language-server`." copilot-language-server; # Added 2025-09-07
  copper = throw "'copper' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  cordless = throw "'cordless' has been removed due to being archived upstream. Consider using 'discordo' instead."; # Added 2025-06-07
  corepack_latest = throw "'corepack_latest' has been removed, use 'corepack.override { nodejs = pkgs.nodejs_latest; }' instead"; # Added 2025-10-25
  cosmic-tasks = throw "'cosmic-tasks' has been renamed to/replaced by 'tasks'"; # Converted to throw 2025-10-27
  cotton = throw "'cotton' has been removed since it is vulnerable to CVE-2025-62518 and upstream is unmaintained"; # Added 2025-10-26
  cpp-ipfs-api = throw "'cpp-ipfs-api' has been renamed to/replaced by 'cpp-ipfs-http-client'"; # Converted to throw 2025-10-27
  cpr = warnAlias "'cpr' has been renamed to/replaced by 'libcpr'" libcpr; # Added 2025-11-17
  create-cycle-app = throw "'create-cycle-app' has been removed because it is unmaintained and has issues installing with recent nodejs versions."; # Added 2025-11-01
  crispyDoom = throw "'crispyDoom' has been renamed to/replaced by 'crispy-doom'"; # Converted to throw 2025-10-27
  critcl = throw "'critcl' has been renamed to/replaced by 'tclPackages.critcl'"; # Converted to throw 2025-10-27
  cromite = throw "'cromite' has been removed from nixpkgs due to it not being maintained"; # Added 2025-06-12
  crossLibcStdenv = throw "'crossLibcStdenv' has been renamed to/replaced by 'stdenvNoLibc'"; # Converted to throw 2025-10-27
  crystal_1_11 = throw "'crystal_1_11' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-09-04
  csslint = throw "'csslint' has been removed as upstream considers it abandoned."; # Addeed 2025-11-07
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
  cups-kyodialog3 = throw "'cups-kyodialog3' has been renamed to/replaced by 'cups-kyodialog'"; # Converted to throw 2025-10-27
  curlHTTP3 = warnAlias "'curlHTTP3' has been removed, as 'curl' now has HTTP/3 support enabled by default" curl; # Added 2025-08-22
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
  deadpixi-sam = throw "'deadpixi-sam' has been renamed to/replaced by 'deadpixi-sam-unstable'"; # Converted to throw 2025-10-27
  deepin = throw "the Deepin desktop environment and associated tools have been removed from nixpkgs due to lack of maintenance"; # Added 2025-08-21
  deepsea = throw "deepsea has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  degit-rs = throw "'degit-rs' has been removed because it is unmaintained upstream and has vulnerable dependencies."; # Added 2025-07-11
  deltachat-cursed = throw "'deltachat-cursed' has been renamed to/replaced by 'arcanechat-tui'"; # Converted to throw 2025-10-27
  devdocs-desktop = throw "'devdocs-desktop' has been removed as it is unmaintained upstream and vendors insecure dependencies"; # Added 2025-06-11
  dfilemanager = throw "'dfilemanager' has been dropped as it was unmaintained"; # Added 2025-06-03
  discord-screenaudio = throw "discord-screenaudio has been removed because it was archived upstream. Use vesktop instead."; # added 2025-11-29
  dleyna-connector-dbus = throw "'dleyna-connector-dbus' has been renamed to/replaced by 'dleyna'"; # Converted to throw 2025-10-27
  dleyna-core = throw "'dleyna-core' has been renamed to/replaced by 'dleyna'"; # Converted to throw 2025-10-27
  dleyna-renderer = throw "'dleyna-renderer' has been renamed to/replaced by 'dleyna'"; # Converted to throw 2025-10-27
  dleyna-server = throw "'dleyna-server' has been renamed to/replaced by 'dleyna'"; # Converted to throw 2025-10-27
  dnscrypt-proxy2 = throw "'dnscrypt-proxy2' has been renamed to/replaced by 'dnscrypt-proxy'"; # Converted to throw 2025-10-27
  docker-distribution = throw "'docker-distribution' has been renamed to/replaced by 'distribution'"; # Converted to throw 2025-10-27
  docker-sync = throw "'docker-sync' has been removed because it was broken and unmaintained"; # Added 2025-08-26
  docker_26 = throw "'docker_26' has been removed because it has been unmaintained since February 2025. Use docker_28 or newer instead."; # Added 2025-06-21
  docker_27 = throw "'docker_27' has been removed because it has been unmaintained since May 2025. Use docker_28 or newer instead."; # Added 2025-06-15
  dockerfile-language-server-nodejs = warnAlias "'dockerfile-language-server-nodejs' has been renamed to 'dockerfile-language-server'" dockerfile-language-server; # Added 2025-09-12
  dolphin-emu-beta = throw "'dolphin-emu-beta' has been renamed to/replaced by 'dolphin-emu'"; # Converted to throw 2025-10-27
  dontRecurseIntoAttrs = warnAlias "dontRecurseIntoAttrs has been removed from pkgs, use `lib.dontRecurseIntoAttrs` instead" lib.dontRecurseIntoAttrs; # Added 2025-10-30
  dotnetenv = throw "'dotnetenv' has been removed because it was unmaintained in Nixpkgs"; # Added 2025-07-11
  dotty = throw "'dotty' has been renamed to/replaced by 'scala_3'"; # Converted to throw 2025-10-27
  dovecot_fts_xapian = throw "'dovecot_fts_xapian' has been removed because it was unmaintained in Nixpkgs. Consider using dovecot-fts-flatcurve instead"; # Added 2025-08-16
  dsd = throw "dsd has been removed, as it was broken and lack of upstream maintenance"; # Added 2025-08-25
  dtv-scan-tables_linuxtv = throw "'dtv-scan-tables_linuxtv' has been renamed to/replaced by 'dtv-scan-tables'"; # Converted to throw 2025-10-27
  dtv-scan-tables_tvheadend = throw "'dtv-scan-tables_tvheadend' has been renamed to/replaced by 'dtv-scan-tables'"; # Converted to throw 2025-10-27
  du-dust = throw "'du-dust' has been renamed to/replaced by 'dust'"; # Converted to throw 2025-10-27
  duckstation-bin = duckstation; # Added 2025-09-20
  dumb = throw "'dumb' has been archived by upstream. Upstream recommends libopenmpt as a replacement."; # Added 2025-09-14
  dump1090 = throw "'dump1090' has been renamed to/replaced by 'dump1090-fa'"; # Converted to throw 2025-10-27
  dune_1 = throw "'dune_1' has been removed"; # Added 2025-11-13
  eask = throw "'eask' has been renamed to/replaced by 'eask-cli'"; # Converted to throw 2025-10-27
  easyloggingpp = throw "easyloggingpp has been removed, as it is deprecated upstream and does not build with CMake 4"; # Added 2025-09-17
  EBTKS = throw "'EBTKS' has been renamed to/replaced by 'ebtks'"; # Converted to throw 2025-10-27
  ec2-utils = throw "'ec2-utils' has been renamed to/replaced by 'amazon-ec2-utils'"; # Converted to throw 2025-10-27
  edid-decode = v4l-utils; # Added 2025-06-20
  eidolon = throw "eidolon was removed as it is unmaintained upstream."; # Added 2025-05-28
  eintopf = throw "'eintopf' has been renamed to/replaced by 'lauti'"; # Converted to throw 2025-10-27
  electron-chromedriver_35 = throw "electron-chromedriver_35 has been removed in favor of newer versions"; # Added 2025-11-10
  electron_35 = throw "electron_35 has been removed in favor of newer versions"; # Added 2025-11-06
  electron_35-bin = throw "electron_35-bin has been removed in favor of newer versions"; # Added 2025-11-06
  elementsd-simplicity = throw "'elementsd-simplicity' has been removed due to lack of maintenance, consider using 'elementsd' instead"; # Added 2025-06-04
  elixir_ls = throw "'elixir_ls' has been renamed to/replaced by 'elixir-ls'"; # Converted to throw 2025-10-27
  elm-github-install = throw "'elm-github-install' has been removed as it is abandoned upstream and only supports Elm 0.18.0"; # Added 2025-08-25
  emacsMacport = throw "'emacsMacport' has been renamed to/replaced by 'emacs-macport'"; # Converted to throw 2025-10-27
  emacsNativeComp = throw "'emacsNativeComp' has been renamed to/replaced by 'emacs'"; # Converted to throw 2025-10-27
  emanote = throw "'emanote' has been removed due to lack of a Nixpkgs maintainer"; # Added 2025-09-18
  embree2 = throw "embree2 has been removed, as it is unmaintained upstream and depended on tbb_2020"; # Added 2025-09-14
  emojione = throw "emojione has beem removed, as it has been archived upstream."; # Added 2025-11-06
  EmptyEpsilon = throw "'EmptyEpsilon' has been renamed to/replaced by 'empty-epsilon'"; # Converted to throw 2025-10-27
  emulationstation = throw "emulationstation was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  emulationstation-de = throw "emulationstation-de was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  enyo-doom = throw "'enyo-doom' has been renamed to/replaced by 'enyo-launcher'"; # Converted to throw 2025-10-27
  epapirus-icon-theme = throw "'epapirus-icon-theme' has been removed because 'papirus-icon-theme' no longer supports building with elementaryOS icon support"; # Added 2025-06-15
  eris-go = throw "'eris-go' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  eriscmd = throw "'eriscmd' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  erlang-ls = throw "'erlang-ls' has been removed as it has been archived upstream. Consider using 'erlang-language-platform' instead"; # Added 2025-10-02
  ethersync = warnAlias "'ethersync' has been renamed to 'teamtype'" teamtype; # Added 2025-10-31
  eww-wayland = throw "'eww-wayland' has been renamed to/replaced by 'eww'"; # Converted to throw 2025-10-27
  f3d_egl = warnAlias "'f3d' now build with egl support by default, so `f3d_egl` is deprecated, consider using 'f3d' instead." f3d; # Added 2025-07-18
  fast-cli = throw "'fast-cli' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  fastnlo_toolkit = throw "'fastnlo_toolkit' has been renamed to/replaced by 'fastnlo-toolkit'"; # Converted to throw 2025-10-27
  faustStk = throw "'faustStk' has been renamed to/replaced by 'faustPhysicalModeling'"; # Converted to throw 2025-10-27
  fbjni = throw "fbjni has been removed, as it was broken"; # Added 2025-08-25
  fcitx5-catppuccin = throw "'fcitx5-catppuccin' has been renamed to/replaced by 'catppuccin-fcitx5'"; # Converted to throw 2025-10-27
  fcitx5-chinese-addons = throw "'fcitx5-chinese-addons' has been renamed to/replaced by 'qt6Packages.fcitx5-chinese-addons'"; # Converted to throw 2025-10-27
  fcitx5-configtool = throw "'fcitx5-configtool' has been renamed to/replaced by 'qt6Packages.fcitx5-configtool'"; # Converted to throw 2025-10-27
  fcitx5-skk-qt = throw "'fcitx5-skk-qt' has been renamed to/replaced by 'qt6Packages.fcitx5-skk-qt'"; # Converted to throw 2025-10-27
  fcitx5-unikey = throw "'fcitx5-unikey' has been renamed to/replaced by 'qt6Packages.fcitx5-unikey'"; # Converted to throw 2025-10-27
  fcitx5-with-addons = throw "'fcitx5-with-addons' has been renamed to/replaced by 'qt6Packages.fcitx5-with-addons'"; # Converted to throw 2025-10-27
  fennel = throw "'fennel' has been renamed to/replaced by 'luaPackages.fennel'"; # Converted to throw 2025-10-27
  fetchbower = throw "fetchbower has been removed as bower was removed. It is recommended to migrate to yarn."; # Added 2025-09-17
  FIL-plugins = throw "'FIL-plugins' has been renamed to/replaced by 'fil-plugins'"; # Converted to throw 2025-10-27
  filesender = throw "'filesender' has been removed because of its simplesamlphp dependency"; # Added 2025-10-17
  finger_bsd = throw "'finger_bsd' has been renamed to/replaced by 'bsd-finger'"; # Converted to throw 2025-10-27
  fingerd_bsd = throw "'fingerd_bsd' has been renamed to/replaced by 'bsd-fingerd'"; # Converted to throw 2025-10-27
  fira-code-nerdfont = throw "'fira-code-nerdfont' has been renamed to/replaced by 'nerd-fonts.fira-code'"; # Converted to throw 2025-10-27
  firebird_2_5 = throw "'firebird_2_5' has been removed as it has reached end-of-life and does not build."; # Added 2025-06-10
  firefox-beta-bin = warnAlias "`firefox-beta-bin` is removed.  Please use `firefox-beta` or `firefox-bin` instead." firefox-beta; # Added 2025-06-06
  firefox-devedition-bin = warnAlias "`firefox-devedition-bin` is removed.  Please use `firefox-devedition` or `firefox-bin` instead." firefox-devedition; # Added 2025-06-06
  firefox-esr-128 = throw "The Firefox 128 ESR series has reached its end of life. Upgrade to `firefox-esr` or `firefox-esr-140` instead."; # Added 2025-08-21
  firefox-esr-128-unwrapped = throw "The Firefox 128 ESR series has reached its end of life. Upgrade to `firefox-esr-unwrapped` or `firefox-esr-140-unwrapped` instead."; # Added 2025-08-21
  firefox-wayland = throw "'firefox-wayland' has been renamed to/replaced by 'firefox'"; # Converted to throw 2025-10-27
  firmwareLinuxNonfree = throw "'firmwareLinuxNonfree' has been renamed to/replaced by 'linux-firmware'"; # Converted to throw 2025-10-27
  fishfight = throw "'fishfight' has been renamed to/replaced by 'jumpy'"; # Converted to throw 2025-10-27
  fit-trackee = throw "'fit-trackee' has been renamed to/replaced by 'fittrackee'"; # Converted to throw 2025-10-27
  flashrom-stable = throw "'flashrom-stable' has been renamed to/replaced by 'flashprog'"; # Converted to throw 2025-10-27
  flatbuffers_2_0 = throw "'flatbuffers_2_0' has been renamed to/replaced by 'flatbuffers'"; # Converted to throw 2025-10-27
  flint3 = flint; # Added 2025-09-21
  floorp = throw "floorp has been replaced with floorp-bin, as building from upstream sources has become unfeasible starting with version 12.x"; # Added 2025-09-06
  floorp-unwrapped = throw "floorp-unwrapped has been replaced with floorp-bin-unwrapped, as building from upstream sources has become unfeasible starting with version 12.x"; # Added 2025-09-06
  flow-editor = throw "'flow-editor' has been renamed to/replaced by 'flow-control'"; # Converted to throw 2025-10-27
  flut-renamer = throw "flut-renamer is unmaintained and has been removed"; # Added 2025-08-26
  flutter324 = throw "flutter324 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2025-10-28
  flutter326 = throw "flutter326 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2025-06-08
  flutter327 = throw "flutter327 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2025-10-28
  fmsynth = throw "'fmsynth' has been removed as it was broken and unmaintained both upstream and in nixpkgs."; # Added 2025-09-01
  follow = warnAlias "follow has been renamed to folo" folo; # Added 2025-05-18
  forceSystem = warnAlias "forceSystem is deprecated in favour of explicitly importing Nixpkgs" (
    system: _: (import self.path { localSystem = { inherit system; }; })
  ); # Converted to warning 2025-10-28
  forge = throw "forge was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  forgejo-actions-runner = throw "'forgejo-actions-runner' has been renamed to/replaced by 'forgejo-runner'"; # Converted to throw 2025-10-27
  fractal-next = throw "'fractal-next' has been renamed to/replaced by 'fractal'"; # Converted to throw 2025-10-27
  framework-system-tools = throw "'framework-system-tools' has been renamed to/replaced by 'framework-tool'"; # Converted to throw 2025-10-27
  francis = throw "'francis' has been renamed to/replaced by 'kdePackages.francis'"; # Converted to throw 2025-10-27
  freebsdCross = throw "'freebsdCross' has been renamed to/replaced by 'freebsd'"; # Converted to throw 2025-10-27
  freecad-qt6 = freecad; # Added 2025-06-14
  freecad-wayland = freecad; # Added 2025-06-14
  freeimage = throw "freeimage was removed due to numerous vulnerabilities"; # Added 2025-10-23
  freerdp3 = throw "'freerdp3' has been renamed to/replaced by 'freerdp'"; # Converted to throw 2025-10-27
  freerdpUnstable = throw "'freerdpUnstable' has been renamed to/replaced by 'freerdp'"; # Converted to throw 2025-10-27
  fusee-launcher = throw "'fusee-launcher' was removed as upstream removed the original source repository fearing legal repercussions"; # Added 2025-07-05
  futuresql = throw "'futuresql' has been renamed to/replaced by 'libsForQt5.futuresql'"; # Converted to throw 2025-10-27
  fx_cast_bridge = throw "'fx_cast_bridge' has been renamed to/replaced by 'fx-cast-bridge'"; # Converted to throw 2025-10-27
  g4music = throw "'g4music' has been renamed to/replaced by 'gapless'"; # Converted to throw 2025-10-27
  gamecube-tools = throw "gamecube-tools was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  garage_0_8 = throw "'garage_0_8' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_0_8_7 = throw "'garage_0_8_7' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_0_9 = throw "'garage_0_9' has been removed as it is unmaintained upstream"; # Added 2025-09-16
  garage_0_9_4 = throw "'garage_0_9_4' has been removed as it is unmaintained upstream"; # Added 2025-09-16
  garage_1_2_0 = throw "'garage_1_2_0' has been removed. Use 'garage_1' instead."; # Added 2025-09-16
  garage_1_x = warnAlias "'garage_1_x' has been renamed to 'garage_1'" garage_1; # Added 2025-06-23
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
  gensgs = throw "gensgs has been removed as it was unmaintained, abandoned upstream since 2009 and relied on gtk2"; # Added 2025-10-29
  geos_3_9 = throw "geos_3_9 has been removed from nixpkgs. Please use a more recent 'geos' instead."; # Added 2025-09-21
  gfn-electron = throw "gfn-electron has been removed from Nixpkgs as it's abandoned upstream"; # Added 2025-11-05
  gfortran9 = throw "gfortran9 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran10 = throw "gfortran10 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran11 = throw "gfortran11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran12 = throw "gfortran12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gg = throw "'gg' has been renamed to/replaced by 'go-graft'"; # Converted to throw 2025-10-27
  ggobi = throw "'ggobi' has been removed from Nixpkgs, as it is unmaintained and broken"; # Added 2025-05-18
  gimp3 = gimp; # Added 2025-10-03
  gimp3-with-plugins = gimp-with-plugins; # Added 2025-10-03
  gimp3Plugins = gimpPlugins; # Added 2025-10-03
  gitAndTools = throw "gitAndTools has been removed, as the packages are now available at the top level"; # Converted to throw 2025-10-26
  gitversion = throw "'gitversion' has been removed because it produced a broken build and was unmaintained"; # Added 2025-08-30
  gjay = throw "'gjay' has been removed as it is unmaintained upstream"; # Added 2025-05-25
  glabels = throw "'glabels' has been removed because it is no longer maintained. Consider using 'glabels-qt', which is an active fork."; # Added 2025-09-16
  glaxnimate = kdePackages.glaxnimate; # Added 2025-09-17
  glew-egl = throw "'glew-egl' has been renamed to/replaced by 'glew'"; # Converted to throw 2025-10-27
  glfw-wayland = throw "'glfw-wayland' has been renamed to/replaced by 'glfw'"; # Converted to throw 2025-10-27
  glfw-wayland-minecraft = throw "'glfw-wayland-minecraft' has been renamed to/replaced by 'glfw3-minecraft'"; # Converted to throw 2025-10-27
  glxinfo = throw "'glxinfo' has been renamed to/replaced by 'mesa-demos'"; # Converted to throw 2025-10-27
  gmnisrv = throw "'gmnisrv' has been removed due to lack of maintenance upstream"; # Added 2025-06-07
  gnat11 = throw "gnat11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat12 = throw "gnat12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat12Packages = throw "gnat12Packages has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat-bootstrap11 = throw "gnat-bootstrap11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat-bootstrap12 = throw "gnat-bootstrap12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot11 = throw "gnatboot11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot12 = throw "gnatboot12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot = throw "'gnatboot' has been renamed to/replaced by 'gnat-bootstrap'"; # Converted to throw 2025-10-27
  gnatcoll-core = throw "'gnatcoll-core' has been renamed to/replaced by 'gnatPackages.gnatcoll-core'"; # Converted to throw 2025-10-27
  gnatcoll-db2ada = throw "'gnatcoll-db2ada' has been renamed to/replaced by 'gnatPackages.gnatcoll-db2ada'"; # Converted to throw 2025-10-27
  gnatcoll-gmp = throw "'gnatcoll-gmp' has been renamed to/replaced by 'gnatPackages.gnatcoll-gmp'"; # Converted to throw 2025-10-27
  gnatcoll-iconv = throw "'gnatcoll-iconv' has been renamed to/replaced by 'gnatPackages.gnatcoll-iconv'"; # Converted to throw 2025-10-27
  gnatcoll-lzma = throw "'gnatcoll-lzma' has been renamed to/replaced by 'gnatPackages.gnatcoll-lzma'"; # Converted to throw 2025-10-27
  gnatcoll-omp = throw "'gnatcoll-omp' has been renamed to/replaced by 'gnatPackages.gnatcoll-omp'"; # Converted to throw 2025-10-27
  gnatcoll-postgres = throw "'gnatcoll-postgres' has been renamed to/replaced by 'gnatPackages.gnatcoll-postgres'"; # Converted to throw 2025-10-27
  gnatcoll-python3 = throw "'gnatcoll-python3' has been renamed to/replaced by 'gnatPackages.gnatcoll-python3'"; # Converted to throw 2025-10-27
  gnatcoll-readline = throw "'gnatcoll-readline' has been renamed to/replaced by 'gnatPackages.gnatcoll-readline'"; # Converted to throw 2025-10-27
  gnatcoll-sql = throw "'gnatcoll-sql' has been renamed to/replaced by 'gnatPackages.gnatcoll-sql'"; # Converted to throw 2025-10-27
  gnatcoll-sqlite = throw "'gnatcoll-sqlite' has been renamed to/replaced by 'gnatPackages.gnatcoll-sqlite'"; # Converted to throw 2025-10-27
  gnatcoll-syslog = throw "'gnatcoll-syslog' has been renamed to/replaced by 'gnatPackages.gnatcoll-syslog'"; # Converted to throw 2025-10-27
  gnatcoll-xref = throw "'gnatcoll-xref' has been renamed to/replaced by 'gnatPackages.gnatcoll-xref'"; # Converted to throw 2025-10-27
  gnatcoll-zlib = throw "'gnatcoll-zlib' has been renamed to/replaced by 'gnatPackages.gnatcoll-zlib'"; # Converted to throw 2025-10-27
  gnatinspect = throw "'gnatinspect' has been renamed to/replaced by 'gnatPackages.gnatinspect'"; # Converted to throw 2025-10-27
  gnome-firmware-updater = throw "'gnome-firmware-updater' has been renamed to/replaced by 'gnome-firmware'"; # Converted to throw 2025-10-27
  gnome-passwordsafe = throw "'gnome-passwordsafe' has been renamed to/replaced by 'gnome-secrets'"; # Converted to throw 2025-10-27
  gnome-recipes = throw "'gnome-recipes' has been removed due to lack of upstream maintenance and dependency on insecure libraries"; # Added 2025-09-06
  gnome-resources = throw "'gnome-resources' has been renamed to/replaced by 'resources'"; # Converted to throw 2025-10-27
  gnu-cobol = throw "'gnu-cobol' has been renamed to/replaced by 'gnucobol'"; # Converted to throw 2025-10-27
  gnubik = throw "'gnubik' has been removed due to lack of maintenance upstream and its dependency on GTK 2"; # Added 2025-09-16
  go-thumbnailer = throw "'go-thumbnailer' has been renamed to/replaced by 'thud'"; # Converted to throw 2025-10-27
  go-upower-notify = throw "'go-upower-notify' has been renamed to/replaced by 'upower-notify'"; # Converted to throw 2025-10-27
  go_1_23 = throw "Go 1.23 is end-of-life and 'go_1_23' has been removed. Please use a newer Go toolchain."; # Added 2025-08-13
  godot-export-templates = throw "'godot-export-templates' has been renamed to/replaced by 'godot-export-templates-bin'"; # Converted to throw 2025-10-27
  godot_4-export-templates = throw "'godot_4-export-templates' has been renamed to/replaced by 'godot_4-export-templates-bin'"; # Converted to throw 2025-10-27
  godot_4_3-export-templates = throw "'godot_4_3-export-templates' has been renamed to/replaced by 'godot_4_3-export-templates-bin'"; # Converted to throw 2025-10-27
  godot_4_4-export-templates = throw "'godot_4_4-export-templates' has been renamed to/replaced by 'godot_4_4-export-templates-bin'"; # Converted to throw 2025-10-27
  goldwarden = throw "'goldwarden' has been removed, as it no longer works with new Bitwarden versions and is abandoned upstream"; # Added 2025-09-16
  gphotos-sync = throw "'gphotos-sync' has been removed, as it was archived upstream due to API changes that ceased its functions"; # Added 2025-11-06
  gprbuild-boot = throw "'gprbuild-boot' has been renamed to/replaced by 'gnatPackages.gprbuild-boot'"; # Converted to throw 2025-10-27
  gpxsee-qt5 = throw "gpxsee-qt5 was removed, use gpxsee instead"; # Added 2025-09-09
  gpxsee-qt6 = gpxsee; # Added 2025-09-09
  gr-framework = throw "gr-framework has been removed, as it was broken"; # Added 2025-08-25
  graalvm-ce = throw "'graalvm-ce' has been renamed to/replaced by 'graalvmPackages.graalvm-ce'"; # Converted to throw 2025-10-27
  graalvm-oracle = throw "'graalvm-oracle' has been renamed to/replaced by 'graalvmPackages.graalvm-oracle'"; # Converted to throw 2025-10-27
  graalvmCEPackages = throw "'graalvmCEPackages' has been renamed to/replaced by 'graalvmPackages'"; # Converted to throw 2025-10-27
  gradience = throw "`gradience` has been removed because it was archived upstream."; # Added 2025-09-20
  gradleGen = throw "'gradleGen' has been moved to `gradle-packages.mkGradle`."; # Added 2025-11-02
  grafana_reporter = throw "'grafana_reporter' has been renamed to/replaced by 'grafana-reporter'"; # Converted to throw 2025-10-27
  graphite-kde-theme = throw "'graphite-kde-theme' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  gringo = throw "'gringo' has been renamed to/replaced by 'clingo'"; # Converted to throw 2025-10-27
  grub2_full = throw "'grub2_full' has been renamed to/replaced by 'grub2'"; # Converted to throw 2025-10-27
  gtkcord4 = throw "'gtkcord4' has been renamed to/replaced by 'dissent'"; # Converted to throw 2025-10-27
  gtkextra = throw "'gtkextra' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  guile-disarchive = throw "'guile-disarchive' has been renamed to/replaced by 'disarchive'"; # Converted to throw 2025-10-27
  guile-sdl = throw "guile-sdl has been removed, as it was broken"; # Added 2025-08-25
  gutenprintBin = gutenprint-bin; # Added 2025-08-21
  gxneur = throw "'gxneur' has been removed due to lack of maintenance and reliance on gnome2 and 2to3."; # Added 2025-08-17
  hacpack = throw "hacpack has been removed from nixpkgs, as it has been taken down upstream"; # Added 2025-09-26
  harmony-music = throw "harmony-music is unmaintained and has been removed"; # Added 2025-08-26
  HentaiAtHome = throw "'HentaiAtHome' has been renamed to/replaced by 'hentai-at-home'"; # Converted to throw 2025-10-27
  hiawatha = throw "hiawatha has been removed, since it is no longer actively supported upstream, nor well maintained in nixpkgs"; # Added 2025-09-10
  hibernate = throw "hibernate has been removed due to lack of maintenance"; # Added 2025-09-10
  hiddify-app = throw "hiddify-app has been removed, since it is unmaintained"; # Added 2025-08-20
  himitsu-firefox = throw "himitsu-firefox has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-11
  hiPrio = warnAlias "'hiPrio' has been removed from pkgs, use `lib.hiPrio` instead" lib.hiPrio; # Added 2025-10-30
  hobbes = throw "hobbes has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-20
  hop = throw "'hop' has been removed due to lack of maintenance"; # Added 2025-11-08
  hostPlatform = warnAlias "'hostPlatform' has been renamed to/replaced by 'stdenv.hostPlatform'" stdenv.hostPlatform; # Converted to warning 2025-10-28
  hpmyroom = throw "hpmyroom has been removed because it has been marked as broken since May 2024."; # Added 2025-10-11
  hpp-fcl = throw "'hpp-fcl' has been renamed to/replaced by 'coal'"; # Converted to throw 2025-10-27
  http-prompt = throw "'http-prompt' has been removed as it was broken and unmaintained upstream"; # Added 2025-11-26
  hydra_unstable = throw "'hydra_unstable' has been renamed to/replaced by 'hydra'"; # Converted to throw 2025-10-27
  i3-gaps = throw "'i3-gaps' has been renamed to/replaced by 'i3'"; # Converted to throw 2025-10-27
  ibm-sw-tpm2 = throw "ibm-sw-tpm2 has been removed, as it was broken"; # Added 2025-08-25
  igvm-tooling = throw "'igvm-tooling' has been removed as it is poorly maintained upstream and a dependency has been marked insecure."; # Added 2025-09-03
  ikos = throw "ikos has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  imaginer = throw "'imaginer' has been removed due to lack of upstream maintenance"; # Added 2025-08-15
  imapnotify = throw "'imapnotify' has been removed because it is unmaintained upstream"; # Added 2025-11-14
  immersed-vr = throw "'immersed-vr' has been renamed to/replaced by 'immersed'"; # Converted to throw 2025-10-27
  inconsolata-nerdfont = throw "'inconsolata-nerdfont' has been renamed to/replaced by 'nerd-fonts.inconsolata'"; # Converted to throw 2025-10-27
  incrtcl = throw "'incrtcl' has been renamed to/replaced by 'tclPackages.incrtcl'"; # Converted to throw 2025-10-27
  inotifyTools = throw "'inotifyTools' has been renamed to/replaced by 'inotify-tools'"; # Converted to throw 2025-10-27
  insync-emblem-icons = throw "'insync-emblem-icons' has been removed, use 'insync-nautilus' instead"; # Added 2025-05-14
  invalidateFetcherByDrvHash = throw "'invalidateFetcherByDrvHash' has been renamed to/replaced by 'testers.invalidateFetcherByDrvHash'"; # Converted to throw 2025-10-27
  invoiceplane = throw "'invoiceplane' doesn't support non-EOL PHP versions"; # Added 2025-10-03
  ioccheck = throw "ioccheck was dropped since it was unmaintained."; # Added 2025-07-06
  ipfs = throw "'ipfs' has been renamed to/replaced by 'kubo'"; # Converted to throw 2025-10-27
  ipfs-migrator = throw "'ipfs-migrator' has been renamed to/replaced by 'kubo-migrator'"; # Converted to throw 2025-10-27
  ipfs-migrator-all-fs-repo-migrations = throw "'ipfs-migrator-all-fs-repo-migrations' has been renamed to/replaced by 'kubo-fs-repo-migrations'"; # Converted to throw 2025-10-27
  ipfs-migrator-unwrapped = throw "'ipfs-migrator-unwrapped' has been renamed to/replaced by 'kubo-migrator-unwrapped'"; # Converted to throw 2025-10-27
  ir.lv2 = ir-lv2; # Added 2025-09-37
  isl_0_24 = throw "isl_0_24 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-10-18
  iso-flags-png-320x420 = throw "'iso-flags-png-320x420' has been renamed to/replaced by 'iso-flags-png-320x240'"; # Converted to throw 2025-10-27
  itktcl = throw "'itktcl' has been renamed to/replaced by 'tclPackages.itktcl'"; # Converted to throw 2025-10-27
  itpp = throw "itpp has been removed, as it was broken"; # Added 2025-08-25
  jack_rack = throw "'jack_rack' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jami-client = throw "'jami-client' has been renamed to/replaced by 'jami'"; # Converted to throw 2025-10-27
  jami-client-qt = throw "'jami-client-qt' has been renamed to/replaced by 'jami-client'"; # Converted to throw 2025-10-27
  jami-daemon = throw "'jami-daemon' has been renamed to/replaced by 'jami.daemon'"; # Converted to throw 2025-10-27
  jdk23 = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  jdk23_headless = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  jdk24 = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  jdk24_headless = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  jesec-rtorrent = throw "'jesec-rtorrent' has been removed due to lack of maintenance upstream."; # Added 2025-11-20
  jikespg = throw "'jikespg' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jing = jing-trang; # Added 2025-09-18
  joplin = joplin-cli; # Added 2025-11-03
  jscoverage = throw "jscoverage has been removed, as it was broken"; # Added 2025-08-25
  julia_19 = throw "Julia 1.9 has reached its end of life and 'julia_19' has been removed. Please use a supported version."; # Added 2025-10-29
  julia_19-bin = throw "Julia 1.9 has reached its end of life and 'julia_19-bin' has been removed. Please use a supported version."; # Added 2025-10-29
  k2pdfopt = throw "'k2pdfopt' has been removed from nixpkgs as it was broken"; # Added 2025-09-27
  k3s_1_30 = throw "'k3s_1_30' has been removed from nixpkgs as it has reached end of life"; # Added 2025-09-01
  kak-lsp = throw "'kak-lsp' has been renamed to/replaced by 'kakoune-lsp'"; # Converted to throw 2025-10-27
  kanidm = warnAlias "'kanidm' will be removed before 26.05. You must use a versioned package, e.g. 'kanidm_1_x'." kanidm_1_7; # Added 2025-09-01
  kanidm_1_4 = throw "'kanidm_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kanidmWithSecretProvisioning = warnAlias "'kanidmWithSecretProvisioning' will be removed before 26.05. You must use a versioned package, e.g. 'kanidmWithSecretProvisioning_1_x'." kanidmWithSecretProvisioning_1_7; # Added 2025-09-01
  kanidmWithSecretProvisioning_1_4 = throw "'kanidmWithSecretProvisioning_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kapitano = throw "'kapitano' has been removed, as it is unmaintained upstream"; # Added 2025-10-29
  kbibtex = throw "'kbibtex' has been removed, as it is unmaintained upstream"; # Added 2025-08-30
  kcli = throw "kcli has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  keepkey_agent = throw "'keepkey_agent' has been renamed to/replaced by 'keepkey-agent'"; # Converted to throw 2025-10-27
  keydb = throw "'keydb' has been removed as it was broken, vulnerable, and unmaintained upstream"; # Added 2025-11-08
  kgx = throw "'kgx' has been renamed to/replaced by 'gnome-console'"; # Converted to throw 2025-10-27
  khoj = throw "khoj has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-11
  kmplayer = throw "'kmplayer' has been removed, as it is unmaintained upstream"; # Added 2025-08-30
  kodiGBM = throw "'kodiGBM' has been renamed to/replaced by 'kodi-gbm'"; # Converted to throw 2025-10-27
  kodiPlain = throw "'kodiPlain' has been renamed to/replaced by 'kodi'"; # Converted to throw 2025-10-27
  kodiPlainWayland = throw "'kodiPlainWayland' has been renamed to/replaced by 'kodi-wayland'"; # Converted to throw 2025-10-27
  kodiPlugins = throw "'kodiPlugins' has been renamed to/replaced by 'kodiPackages'"; # Converted to throw 2025-10-27
  krb5Full = throw "'krb5Full' has been renamed to/replaced by 'krb5'"; # Converted to throw 2025-10-27
  krunner-pass = throw "'krunner-pass' has been removed, as it only works on Plasma 5"; # Added 2025-08-30
  krunner-translator = throw "'krunner-translator' has been removed, as it only works on Plasma 5"; # Added 2025-08-30
  kube3d = throw "'kube3d' has been renamed to/replaced by 'k3d'"; # Converted to throw 2025-10-27
  kubei = throw "'kubei' has been renamed to/replaced by 'kubeclarity'"; # Converted to throw 2025-10-27
  kubo-migrator-all-fs-repo-migrations = throw "'kubo-migrator-all-fs-repo-migrations' has been renamed to/replaced by 'kubo-fs-repo-migrations'"; # Converted to throw 2025-10-27
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
  larynx = throw "'larynx' has been renamed to/replaced by 'piper-tts'"; # Converted to throw 2025-10-27
  LASzip2 = throw "'LASzip2' has been renamed to/replaced by 'laszip_2'"; # Converted to throw 2025-10-27
  LASzip = throw "'LASzip' has been renamed to/replaced by 'laszip'"; # Converted to throw 2025-10-27
  latinmodern-math = throw "'latinmodern-math' has been renamed to/replaced by 'lmmath'"; # Converted to throw 2025-10-27
  latte-dock = throw "'latte-dock' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  layan-kde = throw "'layan-kde' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  lazarus-qt = throw "'lazarus-qt' has been renamed to/replaced by 'lazarus-qt5'"; # Converted to throw 2025-10-27
  ledger_agent = throw "'ledger_agent' has been renamed to/replaced by 'ledger-agent'"; # Converted to throw 2025-10-27
  lesstif = throw "'lesstif' has been removed due to its being broken and unmaintained upstream. Consider using 'motif' instead."; # Added 2025-06-09
  lfs = throw "'lfs' has been renamed to/replaced by 'dysk'"; # Converted to throw 2025-10-27
  libast = throw "'libast' has been removed due to lack of maintenance upstream."; # Added 2025-06-09
  libayatana-appindicator-gtk3 = throw "'libayatana-appindicator-gtk3' has been renamed to/replaced by 'libayatana-appindicator'"; # Converted to throw 2025-10-27
  libayatana-indicator-gtk3 = throw "'libayatana-indicator-gtk3' has been renamed to/replaced by 'libayatana-indicator'"; # Converted to throw 2025-10-27
  libbencodetools = throw "'libbencodetools' has been renamed to/replaced by 'bencodetools'"; # Converted to throw 2025-10-27
  libbpf_1 = throw "'libbpf_1' has been renamed to/replaced by 'libbpf'"; # Converted to throw 2025-10-27
  libbson = throw "'libbson' has been renamed to/replaced by 'mongoc'"; # Converted to throw 2025-10-27
  libcef = throw "'libcef' has been removed, as no packages depend on it"; # Added 2025-11-06
  libdevil = throw "libdevil has been removed, as it was unmaintained in Nixpkgs and upstream since 2017"; # Added 2025-09-16
  libdevil-nox = throw "libdevil has been removed, as it was unmaintained in Nixpkgs and upstream since 2017"; # Added 2025-09-16
  libdwarf-lite = throw "`libdwarf-lite` has been replaced by `libdwarf` as it's mostly a mirror"; # Added 2025-06-16
  libevdevplus = throw "'libevdevplus' has been removed, as it was unmaintained upstream since 2021, no longer builds, and is no longer used by anything"; # Added 2025-11-02
  libfprint-focaltech-2808-a658 = throw "'libfprint-focaltech-2808-a658' has been removed as it was broken and upstream was taken down"; # Added 2025-11-04
  libfpx = throw "libfpx has been removed as it was unmaintained in Nixpkgs and had known vulnerabilities"; # Added 2025-05-20
  libgadu = throw "'libgadu' has been removed as upstream is unmaintained and has no dependents or maintainers in Nixpkgs"; # Added 2025-05-17
  libgda = throw "'libgda' has been renamed to/replaced by 'libgda5'"; # Converted to throw 2025-10-27
  libgme = throw "'libgme' has been renamed to/replaced by 'game-music-emu'"; # Converted to throw 2025-10-27
  libgnome-keyring3 = throw "'libgnome-keyring3' has been renamed to/replaced by 'libgnome-keyring'"; # Converted to throw 2025-10-27
  libheimdal = throw "'libheimdal' has been renamed to/replaced by 'heimdal'"; # Converted to throw 2025-10-27
  libiconv-darwin = throw "'libiconv-darwin' has been renamed to/replaced by 'darwin.libiconv'"; # Converted to throw 2025-10-27
  libixp_hg = throw "'libixp_hg' has been renamed to/replaced by 'libixp'"; # Converted to throw 2025-10-27
  libkkc = throw "'libkkc' has been removed due to lack of maintenance. Consider using anthy instead"; # Added 2025-08-28
  libkkc-data = throw "'libkkc-data' has been removed as it depended on libkkc which was removed"; # Added 2025-08-28
  liblinphone = throw "'liblinphone' has been moved to 'linphonePackages.liblinphone'"; # Added 2025-09-20
  libmp3splt = throw "'libmp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  libmusicbrainz3 = throw "libmusicbrainz3 has been removed as it was obsolete and unused"; # Added 2025-09-16
  libmusicbrainz5 = libmusicbrainz; # Added 2025-09-16
  libosmo-sccp = throw "'libosmo-sccp' has been renamed to/replaced by 'libosmo-sigtran'"; # Converted to throw 2025-10-27
  libpromhttp = throw "'libpromhttp' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-16
  libpseudo = throw "'libpseudo' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libpulseaudio-vanilla = throw "'libpulseaudio-vanilla' has been renamed to/replaced by 'libpulseaudio'"; # Converted to throw 2025-10-27
  libqt5pas = throw "'libqt5pas' has been renamed to/replaced by 'libsForQt5.libqtpas'"; # Converted to throw 2025-10-27
  libquotient = throw "'libquotient' for qt5 was removed as upstream removed qt5 support. Consider explicitly upgrading to qt6 'libquotient'"; # Converted to throw 2025-07-04
  LibreArp = throw "'LibreArp' has been renamed to/replaced by 'librearp'"; # Converted to throw 2025-10-27
  LibreArp-lv2 = throw "'LibreArp-lv2' has been renamed to/replaced by 'librearp-lv2'"; # Converted to throw 2025-10-27
  libreoffice-qt6 = libreoffice-qt; # Added 2025-08-30
  libreoffice-qt6-fresh = libreoffice-qt-fresh; # Added 2025-08-30
  libreoffice-qt6-fresh-unwrapped = libreoffice-qt-fresh.unwrapped; # Added 2025-08-30
  libreoffice-qt6-still = libreoffice-qt-still; # Added 2025-08-30
  libreoffice-qt6-still-unwrapped = libreoffice-qt-still.unwrapped; # Added 2025-08-30
  libreoffice-qt6-unwrapped = libreoffice-qt.unwrapped; # Added 2025-08-30
  librewolf-wayland = throw "'librewolf-wayland' has been renamed to/replaced by 'librewolf'"; # Converted to throw 2025-10-27
  librtlsdr = throw "'librtlsdr' has been renamed to/replaced by 'rtl-sdr'"; # Converted to throw 2025-10-27
  libsForQt515 = throw "'libsForQt515' has been renamed to/replaced by 'libsForQt5'"; # Converted to throw 2025-10-27
  libsmartcols = warnAlias "'util-linux' should be used instead of 'libsmartcols'" util-linux; # Added 2025-09-03
  libsoup = throw "'libsoup' has been renamed to/replaced by 'libsoup_2_4'"; # Converted to throw 2025-10-27
  libtap = throw "libtap has been removed, as it was unused and deprecated by its author in favour of cmocka"; # Added 2025-09-16
  libtcod = throw "'libtcod' has been removed due to being unused and having an incompatible build-system"; # Added 2025-10-04
  libtensorflow-bin = throw "'libtensorflow-bin' has been renamed to/replaced by 'libtensorflow'"; # Converted to throw 2025-10-27
  libtorrent = throw "'libtorrent' has been renamed to 'libtorrent-rakshasa' for clearer distinction from 'libtorrent-rasterbar'"; # Added 2025-09-10
  libtransmission = throw "libtransmission_3 has been removed in favour of libtransmission_4. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Converted to throw 2025-10-26
  libtransmission_3 = throw "libtransmission_3 has been removed in favour of libtransmission_4. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Converted to throw 2025-10-26
  libuinputplus = throw "'libuinputplus' has been removed, as it was unmaintained upstream since 2021, no longer builds, and is no longer used by anything"; # Added 2025-11-02
  libviper = throw "'libviper' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libwnck3 = throw "'libwnck3' has been renamed to/replaced by 'libwnck'"; # Converted to throw 2025-10-27
  lightdm_gtk_greeter = throw "'lightdm_gtk_greeter' has been renamed to/replaced by 'lightdm-gtk-greeter'"; # Converted to throw 2025-10-27
  lightly-boehs = throw "'lightly-boehs' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  lightly-qt = throw "'lightly-qt' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  ligo = throw "ligo has been removed from nixpkgs for lack of maintenance"; # Added 2025-06-03
  lima-bin = warnAlias "lima-bin has been replaced by lima" lima; # Added 2025-05-13
  limbo = warnAlias "limbo has been renamed to turso" turso; # Added 2025-11-07
  lincity_ng = warnAlias "lincity_ng has been renamed to lincity-ng" lincity-ng; # Added 2025-10-09
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
  linux_6_18 = linuxKernel.kernels.linux_6_18;
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
  linuxPackages_6_18 = linuxKernel.packages.linux_6_18;
  linuxPackages_ham = throw "linux_ham has been removed in favour of the standard kernel packages"; # Added 2025-06-24
  linuxPackages_hardened = linuxKernel.packages.linux_hardened; # Added 2025-08-10
  linuxPackages_latest-libre = throw "linux_latest_libre has been removed due to lack of maintenance"; # Added 2025-10-01
  linuxPackages_latest_xen_dom0 = throw "'linuxPackages_latest_xen_dom0' has been renamed to/replaced by 'linuxPackages_latest'"; # Converted to throw 2025-10-27
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
  linuxPackages_xen_dom0 = throw "'linuxPackages_xen_dom0' has been renamed to/replaced by 'linuxPackages'"; # Converted to throw 2025-10-27
  linuxPackages_xen_dom0_hardened = throw "'linuxPackages_xen_dom0_hardened' has been renamed to/replaced by 'linuxPackages_hardened'"; # Converted to throw 2025-10-27
  linuxstopmotion = throw "'linuxstopmotion' has been renamed to/replaced by 'stopmotion'"; # Converted to throw 2025-10-27
  Literate = throw "'Literate' has been renamed to/replaced by 'literate'"; # Converted to throw 2025-10-27
  littlenavmap = throw "littlenavmap has been removed as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  live-chart = throw "live-chart has been removed as it is no longer used in Nixpkgs. livechart-2 (elementary's fork) is available as pantheon.live-chart"; # Added 2025-10-10
  lixVersions = lixPackageSets.renamedDeprecatedLixVersions; # Added 2025-03-20, warning in ../tools/package-management/lix/default.nix
  lizardfs = throw "lizardfs has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-28
  llama = throw "'llama' has been renamed to/replaced by 'walk'"; # Converted to throw 2025-10-27
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
  loco-cli = throw "'loco-cli' has been renamed to/replaced by 'loco'"; # Converted to throw 2025-10-27
  log4j-detect = throw "'log4j-detect' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4j-scan = throw "'log4j-scan' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4j-sniffer = throw "'log4j-sniffer' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4j-vuln-scanner = throw "'log4j-vuln-scanner' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4jcheck = throw "'log4jcheck' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4shell-detector = throw "'log4shell-detector' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  lowPrio = warnAlias "'lowPrio' has been removed from pkgs, use `lib.lowPrio` instead" lib.lowPrio; # Added 2025-10-30
  LPCNet = throw "'LPCNet' has been renamed to/replaced by 'lpcnet'"; # Converted to throw 2025-10-27
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
  lxde.gtk2-x11 = throw "'lxde.gtk2-x11' has been removed. Use 'gtk2-x11' directly."; # Added 2025-08-31
  lxde.lxappearance = throw "'lxappearance' has been moved to top-level. Use 'lxappearance' directly"; # Added 2025-08-31
  lxde.lxappearance-gtk2 = throw "'lxappearance-gtk2' has been moved to top-level. Use 'lxappearance-gtk2' directly"; # Added 2025-08-31
  lxde.lxmenu-data = throw "'lxmenu-data' has been moved to top-level. Use 'lxmenu-data' directly"; # Added 2025-08-31
  lxde.lxpanel = throw "'lxpanel' has been moved to top-level. Use 'lxpanel' directly"; # Added 2025-08-31
  lxde.lxrandr = throw "'lxrandr' has been moved to top-level. Use 'lxrandr' directly"; # Added 2025-08-31
  lxde.lxsession = throw "'lxsession' has been moved to top-level. Use 'lxsession' directly"; # Added 2025-08-31
  lxde.lxtask = throw "'lxtask' has been moved to top-level. Use 'lxtask' directly"; # Added 2025-08-31
  lxdvdrip = throw "'lxdvdrip' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  mac = throw "'mac' has been renamed to/replaced by 'monkeysAudio'"; # Converted to throw 2025-10-27
  MACS2 = throw "'MACS2' has been renamed to/replaced by 'macs2'"; # Converted to throw 2025-10-27
  magma_2_6_2 = throw "'magma_2_6_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  magma_2_7_2 = throw "'magma_2_7_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  mailcore2 = throw "'mailcore2' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  mailnag = throw "mailnag has been removed because it has been marked as broken since 2022."; # Added 2025-10-12
  mailnagWithPlugins = throw "mailnagWithPlugins has been removed because mailnag has been marked as broken since 2022."; # Added 2025-10-12
  makeOverridable = warnAlias "'makeOverridable' has been removed from pkgs, use `lib.makeOverridable` instead" lib.makeOverridable; # Added 2025-10-30
  manaplus = throw "manaplus has been removed, as it was broken"; # Added 2025-08-25
  mariadb-client = throw "mariadb-client has been renamed to mariadb.client"; # Converted to throw 2025-10-26
  marwaita-manjaro = throw "'marwaita-manjaro' has been renamed to/replaced by 'marwaita-teal'"; # Converted to throw 2025-10-27
  marwaita-peppermint = throw "'marwaita-peppermint' has been renamed to/replaced by 'marwaita-red'"; # Converted to throw 2025-10-27
  marwaita-pop_os = throw "'marwaita-pop_os' has been renamed to/replaced by 'marwaita-yellow'"; # Converted to throw 2025-10-27
  marwaita-ubuntu = throw "'marwaita-ubuntu' has been renamed to/replaced by 'marwaita-orange'"; # Converted to throw 2025-10-27
  mastodon-bot = throw "'mastodon-bot' has been removed because it was archived by upstream in 2021."; # Added 2025-11-07
  material-kwin-decoration = throw "'material-kwin-decoration' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  mathlibtools = throw "mathlibtools has been removed as it was archived upstream in 2023"; # Added 2025-07-09
  matomo_5 = throw "'matomo_5' has been renamed to/replaced by 'matomo'"; # Converted to throw 2025-10-27
  matrix-appservice-slack = throw "'matrix-appservice-slack' has been removed, as it relies on Classic Slack Apps, which no longer exist, and is abandoned upstream"; # Added 2025-11-11
  matrix-synapse-tools.rust-synapse-compress-state = throw "'matrix-synapse-tools.rust-synapse-compress-state' has been renamed to/replaced by 'rust-synapse-compress-state'"; # Converted to throw 2025-10-27
  matrix-synapse-tools.synadm = throw "'matrix-synapse-tools.synadm' has been renamed to/replaced by 'synadm'"; # Converted to throw 2025-10-27
  mcomix3 = throw "'mcomix3' has been renamed to/replaced by 'mcomix'"; # Converted to throw 2025-10-27
  mdt = throw "'mdt' has been renamed to/replaced by 'md-tui'"; # Converted to throw 2025-10-27
  mediastreamer = throw "'mediastreamer' has been moved to 'linphonePackages.mediastreamer2'"; # Added 2025-09-20
  mediastreamer-openh264 = throw "'mediastreamer-openh264' has been moved to 'linphonePackages.msopenh264'"; # Added 2025-09-20
  meilisearch_1_11 = throw "'meilisearch_1_11' has been removed, as it is no longer supported"; # Added 2025-10-03
  melmatcheq.lv2 = melmatcheq-lv2; # Added 2025-09-27
  meshlab-unstable = throw "meshlab-unstable has been removed, as it was behind meshlab"; # Added 2025-09-21
  meteo = throw "'meteo' has been removed as it was unmaintained and depends on deprecated webkitgtk_4_0"; # Added 2025-10-09
  microcodeAmd = throw "'microcodeAmd' has been renamed to/replaced by 'microcode-amd'"; # Converted to throw 2025-10-27
  microcodeIntel = throw "'microcodeIntel' has been renamed to/replaced by 'microcode-intel'"; # Converted to throw 2025-10-27
  microsoft_gsl = throw "'microsoft_gsl' has been renamed to/replaced by 'microsoft-gsl'"; # Converted to throw 2025-10-27
  MIDIVisualizer = throw "'MIDIVisualizer' has been renamed to/replaced by 'midivisualizer'"; # Converted to throw 2025-10-27
  midori = throw "'midori' original project has been abandonned upstream and the package was broken for a while in nixpkgs"; # Added 2025-05-19
  midori-unwrapped = throw "'midori' original project has been abandonned upstream and the package was broken for a while in nixpkgs"; # Added 2025-05-19
  migra = throw "migra has been removed because it has transitively been marked as broken since May 2024, and is unmaintained upstream."; # Added 2025-10-11
  mihomo-party = throw "'mihomo-party' has been removed due to upstream license violation"; # Added 2025-08-20
  mime-types = throw "'mime-types' has been renamed to/replaced by 'mailcap'"; # Converted to throw 2025-10-27
  minecraft = throw "'minecraft' has been removed because the package was broken. Consider using 'prismlauncher' instead"; # Added 2025-09-06
  minetest = throw "'minetest' has been renamed to/replaced by 'luanti'"; # Converted to throw 2025-10-27
  minetest-touch = throw "'minetest-touch' has been renamed to/replaced by 'luanti-client'"; # Converted to throw 2025-10-27
  minetestclient = throw "'minetestclient' has been renamed to/replaced by 'luanti-client'"; # Converted to throw 2025-10-27
  minetestserver = throw "'minetestserver' has been renamed to/replaced by 'luanti-server'"; # Converted to throw 2025-10-27
  minizip2 = throw "'minizip2' has been renamed to/replaced by 'minizip-ng'"; # Converted to throw 2025-10-27
  miru = throw "'miru' has been removed due to lack maintenance"; # Added 2025-08-21
  mlir_16 = throw "mlir_16 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  mlir_17 = throw "mlir_17 has been removed, as it is unmaintained and obsolete"; # Added 2025-08-09
  mmsd = throw "'mmsd' has been removed due to being unmaintained upstream. Consider using 'mmsd-tng' instead"; # Added 2025-06-07
  mmutils = throw "'mmutils' has been removed due to being unmaintained upstream"; # Added 2025-08-29
  moar = warnAlias "`moar` has been renamed to `moor` by upstream in v2.0.0. See https://github.com/walles/moor/pull/305 for more." pkgs.moor; # Added 2025-09-02
  mongodb-6_0 = throw "mongodb-6_0 has been removed, it's end of life since July 2025"; # Added 2025-07-23
  monitor = pantheon.elementary-monitor; # Added 2025-10-10
  mono4 = mono6; # Added 2025-08-25
  mono5 = mono6; # Added 2025-08-25
  mono-addins = throw "mono-addins has been removed due to its dependency on the removed mono4. Consider alternative frameworks or migrate to newer .NET technologies."; # Added 2025-08-25
  monotoneViz = throw "monotoneViz was removed because it relies on a broken version of graphviz"; # Added 2025-10-19
  moralerspace-hwnf = throw "moralerspace-hwnf has been removed, use moralerspace-hw instead."; # Added 2025-08-30
  moralerspace-nf = throw "moralerspace-nf has been removed, use moralerspace instead."; # Added 2025-08-30
  morty = throw "morty has been removed, as searxng removed support for it and it was unmaintained."; # Added 2025-09-26
  moz-phab = throw "'moz-phab' has been renamed to/replaced by 'mozphab'"; # Converted to throw 2025-10-27
  mp3splt = throw "'mp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  mpc-cli = throw "'mpc-cli' has been renamed to/replaced by 'mpc'"; # Converted to throw 2025-10-27
  mpc_cli = throw "'mpc_cli' has been renamed to/replaced by 'mpc'"; # Converted to throw 2025-10-27
  mpdevil = throw "'mpdevil' has been renamed to/replaced by 'plattenalbum'"; # Converted to throw 2025-10-27
  mpdWithFeatures = warnAlias "mpdWithFeatures has been replaced by mpd.override" mpd.override; # Added 2025-08-08
  mpris-discord-rpc = throw "'mpris-discord-rpc' has been renamed to 'music-discord-rpc'."; # Added 2025-09-14
  mpw = throw "'mpw' has been removed, as upstream development has moved to Spectre, which is packaged as 'spectre-cli'"; # Added 2025-10-26
  mrxvt = throw "'mrxvt' has been removed due to lack of maintainence upstream"; # Added 2025-09-25
  msgpack = throw "msgpack has been split into msgpack-c and msgpack-cxx"; # Added 2025-09-14
  msp430NewlibCross = throw "'msp430NewlibCross' has been renamed to/replaced by 'msp430Newlib'"; # Converted to throw 2025-10-27
  multipass = throw "multipass was dropped since it was unmaintained."; # Added 2025-11-29
  mumps_par = throw "'mumps_par' has been renamed to/replaced by 'mumps-mpi'"; # Converted to throw 2025-10-27
  mustache-tcl = throw "'mustache-tcl' has been renamed to/replaced by 'tclPackages.mustache-tcl'"; # Converted to throw 2025-10-27
  mutt-with-sidebar = throw "'mutt-with-sidebar' has been renamed to/replaced by 'mutt'"; # Converted to throw 2025-10-27
  mx-puppet-discord = throw "mx-puppet-discord was removed since the packaging was unmaintained and was the sole user of sha1 hashes in nixpkgs"; # Added 2025-07-24
  mysql-client = throw "mysql-client has been replaced by mariadb.client"; # Converted to throw 2025-10-26
  n98-magerun = throw "n98-magerun doesn't support new PHP newer than 8.1"; # Added 2025-10-03
  nagiosPluginsOfficial = throw "'nagiosPluginsOfficial' has been renamed to/replaced by 'monitoring-plugins'"; # Converted to throw 2025-10-27
  namazu = throw "namazu has been removed, as it was broken"; # Added 2025-08-25
  nanoblogger = throw "nanoblogger has been removed as upstream stopped developement in 2013"; # Added 2025-09-10
  nasc = throw "'nasc' has been removed as it was unmaintained and depends on deprecated webkitgtk_4_0"; # Added 2025-10-09
  nats-streaming-server = throw "'nats-streaming-server' has been removed as critical bug fixes and security fixes will no longer be performed as of June of 2023"; # Added 2025-10-13
  ncdu_2 = throw "'ncdu_2' has been renamed to/replaced by 'ncdu'"; # Converted to throw 2025-10-27
  near-cli = throw "'near-cli' has been removed as upstream has deprecated it and archived the source code repo"; # Added 2025-11-10
  neardal = throw "neardal has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-29
  nekoray = lib.warnOnInstantiate "nekoray has been renamed to throne" throne; # Added 2025-11-10
  neo4j-desktop = throw "neo4j-desktop has been removed as it was out-of-date"; # Added 2025-11-01
  neocities-cli = throw "'neocities-cli' has been renamed to/replaced by 'neocities'"; # Converted to throw 2025-10-27
  netbox_4_1 = throw "netbox 4.1 series has been removed as it was EOL"; # Added 2025-10-14
  netbsdCross = throw "'netbsdCross' has been renamed to/replaced by 'netbsd'"; # Converted to throw 2025-10-27
  netsurf.browser = throw "'netsurf.browser' has been renamed to/replaced by 'netsurf-browser'"; # Converted to throw 2025-10-27
  netsurf.buildsystem = throw "'netsurf.buildsystem' has been renamed to/replaced by 'netsurf-buildsystem'"; # Converted to throw 2025-10-27
  netsurf.libcss = throw "'netsurf.libcss' has been renamed to/replaced by 'libcss'"; # Converted to throw 2025-10-27
  netsurf.libdom = throw "'netsurf.libdom' has been renamed to/replaced by 'libdom'"; # Converted to throw 2025-10-27
  netsurf.libhubbub = throw "'netsurf.libhubbub' has been renamed to/replaced by 'libhubbub'"; # Converted to throw 2025-10-27
  netsurf.libnsbmp = throw "'netsurf.libnsbmp' has been renamed to/replaced by 'libnsbmp'"; # Converted to throw 2025-10-27
  netsurf.libnsfb = throw "'netsurf.libnsfb' has been renamed to/replaced by 'libnsfb'"; # Converted to throw 2025-10-27
  netsurf.libnsgif = throw "'netsurf.libnsgif' has been renamed to/replaced by 'libnsgif'"; # Converted to throw 2025-10-27
  netsurf.libnslog = throw "'netsurf.libnslog' has been renamed to/replaced by 'libnslog'"; # Converted to throw 2025-10-27
  netsurf.libnspsl = throw "'netsurf.libnspsl' has been renamed to/replaced by 'libnspsl'"; # Converted to throw 2025-10-27
  netsurf.libnsutils = throw "'netsurf.libnsutils' has been renamed to/replaced by 'libnsutils'"; # Converted to throw 2025-10-27
  netsurf.libparserutils = throw "'netsurf.libparserutils' has been renamed to/replaced by 'libparserutils'"; # Converted to throw 2025-10-27
  netsurf.libsvgtiny = throw "'netsurf.libsvgtiny' has been renamed to/replaced by 'libsvgtiny'"; # Converted to throw 2025-10-27
  netsurf.libutf8proc = throw "'netsurf.libutf8proc' has been renamed to/replaced by 'libutf8proc'"; # Converted to throw 2025-10-27
  netsurf.libwapcaplet = throw "'netsurf.libwapcaplet' has been renamed to/replaced by 'libwapcaplet'"; # Converted to throw 2025-10-27
  netsurf.nsgenbind = throw "'netsurf.nsgenbind' has been renamed to/replaced by 'nsgenbind'"; # Converted to throw 2025-10-27
  nettools = net-tools; # Added 2025-06-11
  networkmanager_strongswan = networkmanager-strongswan; # Added 2025-06-29
  newlib-nanoCross = throw "'newlib-nanoCross' has been renamed to/replaced by 'newlib-nano'"; # Converted to throw 2025-10-27
  newlibCross = throw "'newlibCross' has been renamed to/replaced by 'newlib'"; # Converted to throw 2025-10-27
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
  nginxQuic = throw "'nginxQuic' has been removed. QUIC support is now available in the default nginx builds.";
  ngrid = throw "'ngrid' has been removed as it has been unmaintained upstream and broken"; # Added 2025-11-15
  nix-direnv-flakes = throw "'nix-direnv-flakes' has been renamed to/replaced by 'nix-direnv'"; # Converted to throw 2025-10-27
  nix-ld-rs = throw "'nix-ld-rs' has been renamed to/replaced by 'nix-ld'"; # Converted to throw 2025-10-27
  nix-linter = throw "nix-linter has been removed as it was broken for 3 years and unmaintained upstream"; # Added 2025-09-06
  nix-plugin-pijul = throw "nix-plugin-pijul has been removed due to being discontinued"; # Added 2025-05-18
  nix_2_3 = throw "'nix_2_3' has been removed, because it was unmaintained and insecure."; # Converted to throw 2025-07-24
  nixfmt-classic =
    (
      if lib.oldestSupportedReleaseIsAtLeast 2605 then
        throw "nixfmt-classic has been removed as it is deprecated and unmaintained."
      else if lib.oldestSupportedReleaseIsAtLeast 2511 then
        warnAlias "nixfmt-classic is deprecated and unmaintained. We recommend switching to nixfmt."
      else
        lib.id
    )
      haskellPackages.nixfmt.bin;
  nixfmt-rfc-style =
    if lib.oldestSupportedReleaseIsAtLeast 2511 then
      warnAlias "nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead." nixfmt # Added 2025-07-14
    else
      nixfmt;
  nixForLinking = throw "nixForLinking has been removed, use `nixVersions.nixComponents_<version>` instead"; # Added 2025-08-14
  nixosTest = throw "'nixosTest' has been renamed to/replaced by 'testers.nixosTest'"; # Converted to throw 2025-10-27
  nixStable = throw "'nixStable' has been renamed to/replaced by 'nixVersions.stable'"; # Converted to throw 2025-10-27
  nm-tray = throw "'nm-tray' has been removed, as it only works with Plasma 5"; # Added 2025-08-30
  nomacs-qt6 = nomacs; # Added 2025-08-30
  norouter = throw "norouter has been removed because it has been marked as broken since at least November 2024."; # Added 2025-09-29
  notary = throw "'notary' has been removed due to being archived upstream. Consider using 'notation' instead."; # Added 2025-11-13
  notes-up = throw "'notes-up' has been removed as it was unmaintained and depends on deprecated webkitgtk_4_0"; # Added 2025-10-09
  notify-sharp = throw "'notify-sharp' has been removed as it was unmaintained and depends on deprecated dbus-sharp versions"; # Added 2025-08-25
  noto-fonts-emoji = throw "'noto-fonts-emoji' has been renamed to/replaced by 'noto-fonts-color-emoji'"; # Converted to throw 2025-10-27
  noto-fonts-extra = throw "'noto-fonts-extra' has been renamed to/replaced by 'noto-fonts'"; # Converted to throw 2025-10-27
  NSPlist = throw "'NSPlist' has been renamed to/replaced by 'nsplist'"; # Converted to throw 2025-10-27
  nuget-to-nix = throw "nuget-to-nix has been removed as it was deprecated in favor of nuget-to-json. Please use nuget-to-json instead"; # Added 2025-08-28
  nushellFull = throw "'nushellFull' has been renamed to/replaced by 'nushell'"; # Converted to throw 2025-10-27
  o = throw "'o' has been renamed to/replaced by 'orbiton'"; # Converted to throw 2025-10-27
  oathToolkit = throw "'oathToolkit' has been renamed to/replaced by 'oath-toolkit'"; # Converted to throw 2025-10-27
  obb = throw "obb has been removed because it has been marked as broken since 2023."; # Added 2025-10-11
  obliv-c = throw "obliv-c has been removed from Nixpkgs, as it has been unmaintained upstream for 4 years and does not build with supported GCC versions"; # Added 2025-08-18
  oclgrind = throw "oclgrind has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  oil = throw "'oil' has been renamed to/replaced by 'oils-for-unix'"; # Converted to throw 2025-10-27
  onevpl-intel-gpu = throw "'onevpl-intel-gpu' has been renamed to/replaced by 'vpl-gpu-rt'"; # Converted to throw 2025-10-27
  onlyoffice-bin = throw "'onlyoffice-bin' has been renamed to/replaced by 'onlyoffice-desktopeditors'"; # Converted to throw 2025-10-27
  onlyoffice-bin_latest = throw "'onlyoffice-bin_latest' has been renamed to/replaced by 'onlyoffice-bin'"; # Converted to throw 2025-10-27
  onscripter-en = throw "onscripter-en has been removed due to lack of maintenance in both upstream and Nixpkgs; onscripter is available instead"; # Added 2025-10-17
  onthespot = throw "onethespot has been removed due to lack of upstream maintenance"; # Added 2025-09-26
  opae = throw "opae has been removed because it has been marked as broken since June 2023."; # Added 2025-10-11
  open-timeline-io = warnAlias "'open-timeline-io' has been renamed to 'opentimelineio'" opentimelineio; # Added 2025-08-10
  openafs_1_8 = throw "'openafs_1_8' has been renamed to/replaced by 'openafs'"; # Converted to throw 2025-10-27
  openai-triton-llvm = throw "'openai-triton-llvm' has been renamed to/replaced by 'triton-llvm'"; # Converted to throw 2025-10-27
  openai-whisper-cpp = throw "'openai-whisper-cpp' has been renamed to/replaced by 'whisper-cpp'"; # Converted to throw 2025-10-27
  openbabel2 = throw "openbabel2 has been removed, as it was unused and unmaintained upstream; please use openbabel"; # Added 2025-09-17
  openbabel3 = openbabel; # Added 2025-09-17
  openbsdCross = throw "'openbsdCross' has been renamed to/replaced by 'openbsd'"; # Converted to throw 2025-10-27
  opencl-clang = throw "opencl-clang has been integrated into intel-graphics-compiler"; # Added 2025-09-10
  openconnect_gnutls = throw "'openconnect_gnutls' has been renamed to/replaced by 'openconnect'"; # Converted to throw 2025-10-27
  openexr_3 = throw "'openexr_3' has been renamed to/replaced by 'openexr'"; # Converted to throw 2025-10-27
  openimageio2 = throw "'openimageio2' has been renamed to/replaced by 'openimageio'"; # Converted to throw 2025-10-27
  openjdk23 = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  openjdk23_headless = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  openjdk24 = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  openjdk24_headless = throw "OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-10-04
  openjfx23 = throw "OpenJFX 23 was removed as it has reached its end of life"; # Added 2025-11-04
  openjfx24 = throw "OpenJFX 24 was removed as it has reached its end of life"; # Added 2025-10-04
  openmw-tes3mp = throw "'openmw-tes3mp' has been removed due to lack of maintenance upstream"; # Added 2025-08-30
  openssl_3_0 = throw "'openssl_3_0' has been renamed to/replaced by 'openssl_3'"; # Converted to throw 2025-10-27
  opensycl = throw "'opensycl' has been renamed to/replaced by 'adaptivecpp'"; # Converted to throw 2025-10-27
  opensyclWithRocm = throw "'opensyclWithRocm' has been renamed to/replaced by 'adaptivecppWithRocm'"; # Converted to throw 2025-10-27
  opentofu-ls = warnAlias "'opentofu-ls' has been renamed to 'tofu-ls'" tofu-ls; # Added 2025-06-10
  opentracing-cpp = throw "'opentracingc-cpp' has been removed as it was archived upstream in 2024"; # Added 2025-10-19
  opera = throw "'opera' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-05-19
  orogene = throw "'orogene' uses a wasm-specific fork of async-tar that is vulnerable to CVE-2025-62518, which is not supported by its upstream"; # Added 2025-10-24
  ortp = throw "'ortp' has been moved to 'linphonePackages.ortp'"; # Added 2025-09-20
  OSCAR = throw "'OSCAR' has been renamed to/replaced by 'oscar'"; # Converted to throw 2025-10-27
  osm2xmap = throw "osm2xmap has been removed, as it is unmaintained upstream and depended on old dependencies with broken builds"; # Added 2025-09-16
  ossec-agent = throw "'ossec-agent' has been removed due to lack of maintenance"; # Added 2025-11-08
  ossec-server = throw "'ossec-server' has been removed due to lack of maintenance"; # Added 2025-11-08
  overrideLibcxx = throw "overrideLibcxx has been removed, as it was no longer used and Darwin now uses libc++ from the latest SDK; see the Nixpkgs 25.11 release notes for details"; # Added 2025-09-15
  overrideSDK = throw "overrideSDK has been removed as it was a legacy compatibility stub. See <https://nixos.org/manual/nixpkgs/stable/#sec-darwin-legacy-frameworks-overrides> for migration instructions"; # Added 2025-08-04
  pacup = throw "'pacup' has been renamed to/replaced by 'perlPackages.pacup'"; # Converted to throw 2025-10-27
  PageEdit = throw "'PageEdit' has been renamed to/replaced by 'pageedit'"; # Converted to throw 2025-10-27
  pal = throw "pal has been removed, as it was broken"; # Added 2025-08-25
  pangolin = throw "pangolin has been removed due to lack of maintenance"; # Added 2025-11-17
  paperless-ng = throw "'paperless-ng' has been renamed to/replaced by 'paperless-ngx'"; # Converted to throw 2025-10-27
  parcellite = throw "'parcellite' was remove due to lack of maintenance and relying on gtk2"; # Added 2025-10-03
  patchelfStable = throw "'patchelfStable' has been renamed to/replaced by 'patchelf'"; # Converted to throw 2025-10-27
  path-of-building = lib.warnOnInstantiate "'path-of-building' has been replaced by 'rusty-path-of-building'" rusty-path-of-building; # Added 2025-10-30
  paup = throw "'paup' has been renamed to/replaced by 'paup-cli'"; # Converted to throw 2025-10-27
  pcp = throw "'pcp' has been removed because the upstream repo was archived and it hasn't been updated since 2021"; # Added 2025-09-23
  pcre16 = throw "'pcre16' has been removed because it is obsolete. Consider migrating to 'pcre2' instead."; # Added 2025-05-29
  pcsctools = throw "'pcsctools' has been renamed to/replaced by 'pcsc-tools'"; # Converted to throw 2025-10-27
  pdf4tcl = throw "'pdf4tcl' has been renamed to/replaced by 'tclPackages.pdf4tcl'"; # Converted to throw 2025-10-27
  pds = warnAlias "'pds' has been renamed to 'bluesky-pds'" bluesky-pds; # Added 2025-08-20
  pdsadmin = warnAlias "'pdsadmin' has been renamed to 'bluesky-pdsadmin'" bluesky-pdsadmin; # Added 2025-08-20
  peach = throw "'peach' has been renamed to/replaced by 'asouldocs'"; # Converted to throw 2025-10-27
  pentablet-driver = throw "'pentablet-driver' has been renamed to/replaced by 'xp-pen-g430-driver'"; # Converted to throw 2025-10-27
  perceptual-diff = throw "perceptual-diff was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  percona-server_innovation = throw "'percona-server_innovation' has been renamed to/replaced by 'percona-server'"; # Converted to throw 2025-10-27
  percona-server_lts = throw "'percona-server_lts' has been renamed to/replaced by 'percona-server'"; # Converted to throw 2025-10-27
  percona-xtrabackup_innovation = throw "'percona-xtrabackup_innovation' has been renamed to/replaced by 'percona-xtrabackup'"; # Converted to throw 2025-10-27
  percona-xtrabackup_lts = throw "'percona-xtrabackup_lts' has been renamed to/replaced by 'percona-xtrabackup'"; # Converted to throw 2025-10-27
  peruse = throw "'peruse' has been removed as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  pg_cron = throw "'pg_cron' has been removed. Use 'postgresqlPackages.pg_cron' instead."; # Added 2025-07-19
  pg_hll = throw "'pg_hll' has been removed. Use 'postgresqlPackages.pg_hll' instead."; # Added 2025-07-19
  pg_repack = throw "'pg_repack' has been removed. Use 'postgresqlPackages.pg_repack' instead."; # Added 2025-07-19
  pg_similarity = throw "'pg_similarity' has been removed. Use 'postgresqlPackages.pg_similarity' instead."; # Added 2025-07-19
  pg_topn = throw "'pg_topn' has been removed. Use 'postgresqlPackages.pg_topn' instead."; # Added 2025-07-19
  pgadmin = throw "'pgadmin' has been renamed to/replaced by 'pgadmin4'"; # Converted to throw 2025-10-27
  pgf_graphics = throw "pgf_graphics was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  pgjwt = throw "'pgjwt' has been removed. Use 'postgresqlPackages.pgjwt' instead."; # Added 2025-07-19
  pgroonga = throw "'pgroonga' has been removed. Use 'postgresqlPackages.pgroonga' instead."; # Added 2025-07-19
  pgtap = throw "'pgtap' has been removed. Use 'postgresqlPackages.pgtap' instead."; # Added 2025-07-19
  pharo-spur64 = throw "'pharo-spur64' has been renamed to/replaced by 'pharo'"; # Converted to throw 2025-10-27
  php81 = throw "php81 is EOL"; # Added 2025-10-04
  php81Extensions = throw "php81 is EOL"; # Added 2025-10-04
  php81Packages = throw "php81 is EOL"; # Added 2025-10-04
  picom-next = throw "'picom-next' has been renamed to/replaced by 'picom'"; # Converted to throw 2025-10-27
  pidgin-carbons = throw "'pidgin-carbons' has been renamed to/replaced by 'pidginPackages.pidgin-carbons'"; # Converted to throw 2025-10-27
  pidgin-indicator = throw "'pidgin-indicator' has been renamed to/replaced by 'pidginPackages.pidgin-indicator'"; # Converted to throw 2025-10-27
  pidgin-latex = throw "'pidgin-latex' has been renamed to/replaced by 'pidginPackages.pidgin-latex'"; # Converted to throw 2025-10-27
  pidgin-mra = throw "'pidgin-mra' has been removed since mail.ru agent service has stopped functioning in 2024."; # Added 2025-09-17
  pidgin-msn-pecan = throw "'pidgin-msn-pecan' has been removed as it's unmaintained upstream and doesn't work with escargot"; # Added 2025-09-17
  pidgin-opensteamworks = throw "'pidgin-opensteamworks' has been removed as it is unmaintained and no longer works with Steam."; # Added 2025-09-17
  pidgin-osd = throw "'pidgin-osd' has been renamed to/replaced by 'pidginPackages.pidgin-osd'"; # Converted to throw 2025-10-27
  pidgin-otr = throw "'pidgin-otr' has been renamed to/replaced by 'pidginPackages.pidgin-otr'"; # Converted to throw 2025-10-27
  pidgin-sipe = throw "'pidgin-sipe' has been renamed to/replaced by 'pidginPackages.pidgin-sipe'"; # Converted to throw 2025-10-27
  pidgin-skypeweb = throw "'pidgin-skypeweb' has been removed since Skype was shut down in May 2025"; # Added 2025-09-15
  pidgin-window-merge = throw "'pidgin-window-merge' has been renamed to/replaced by 'pidginPackages.pidgin-window-merge'"; # Converted to throw 2025-10-27
  pidgin-xmpp-receipts = throw "'pidgin-xmpp-receipts' has been renamed to/replaced by 'pidginPackages.pidgin-xmpp-receipts'"; # Converted to throw 2025-10-27
  pilipalax = throw "'pilipalax' has been removed from nixpkgs due to it not being maintained"; # Added 2025-07-25
  pinentry = throw "'pinentry' has been removed. Pick an appropriate variant like 'pinentry-curses' or 'pinentry-gnome3'"; # Converted to throw 2025-10-26
  piper-train = throw "piper-train is now part of the piper package using the `withTrain` override"; # Added 2025-09-03
  plasma-applet-volumewin7mixer = throw "'plasma-applet-volumewin7mixer' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  plasma-pass = throw "'plasma-pass' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  plasma-theme-switcher = throw "'plasma-theme-switcher' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  platformioPackages.platformio-chrootenv = platformio-chrootenv; # Added 2025-09-04
  platformioPackages.platformio-core = platformio-core; # Added 2025-09-04
  plex-media-player = throw "'plex-media-player' has been discontinued, the new official client is available as 'plex-desktop'"; # Added 2025-05-28
  PlistCpp = throw "'PlistCpp' has been renamed to/replaced by 'plistcpp'"; # Converted to throw 2025-10-27
  pltScheme = throw "'pltScheme' has been renamed to/replaced by 'racket'"; # Converted to throw 2025-10-27
  plv8 = throw "'plv8' has been removed. Use 'postgresqlPackages.plv8' instead."; # Added 2025-07-19
  pn = throw "'pn' has been removed as upstream was archived in 2020"; # Added 2025-10-17
  poac = throw "'poac' has been renamed to/replaced by 'cabinpkg'"; # Converted to throw 2025-10-27
  pocket-updater-utility = throw "'pocket-updater-utility' has been renamed to/replaced by 'pupdate'"; # Converted to throw 2025-10-27
  podofo010 = throw "'podofo010' has been renamed to/replaced by 'podofo_0_10'"; # Converted to throw 2025-10-27
  polipo = throw "'polipo' has been removed as it is unmaintained upstream"; # Added 2025-05-18
  polypane = throw "'polypane' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-25
  poppler_utils = throw "'poppler_utils' has been renamed to/replaced by 'poppler-utils'"; # Converted to throw 2025-10-27
  posterazor = throw "posterazor was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  postgis = throw "'postgis' has been removed. Use 'postgresqlPackages.postgis' instead."; # Added 2025-07-19
  postgres-lsp = warnAlias "'postgres-lsp' has been renamed to 'postgres-language-server'" postgres-language-server; # Added 2025-10-28
  postgresql13JitPackages = throw "'postgresql13JitPackages' has been renamed to/replaced by 'postgresql13Packages'"; # Converted to throw 2025-10-27
  postgresql13Packages = throw "postgresql13Packages has been removed since it reached its EOL upstream"; # Added 2025-11-17
  postgresql14JitPackages = throw "'postgresql14JitPackages' has been renamed to/replaced by 'postgresql14Packages'"; # Converted to throw 2025-10-27
  postgresql15JitPackages = throw "'postgresql15JitPackages' has been renamed to/replaced by 'postgresql15Packages'"; # Converted to throw 2025-10-27
  postgresql16JitPackages = throw "'postgresql16JitPackages' has been renamed to/replaced by 'postgresql16Packages'"; # Converted to throw 2025-10-27
  postgresql17JitPackages = throw "'postgresql17JitPackages' has been renamed to/replaced by 'postgresql17Packages'"; # Converted to throw 2025-10-27
  postgresql_13 = throw "postgresql_13 has been removed since it reached its EOL upstream"; # Added 2025-11-17
  postgresql_13_jit = throw "postgresql_13_jit has been removed since it reached its EOL upstream"; # Added 2025-11-17
  postgresqlJitPackages = throw "'postgresqlJitPackages' has been renamed to/replaced by 'postgresqlPackages'"; # Converted to throw 2025-10-27
  pot = throw "'pot' has been removed as it requires libsoup 2.4 which is EOL"; # Added 2025-10-09
  powerdns = throw "'powerdns' has been renamed to/replaced by 'pdns'"; # Converted to throw 2025-10-27
  prboom-plus = throw "'prboom-plus' has been removed since it is unmaintained upstream."; # Added 2025-09-14
  preload = throw "'preload' has been removed due to lack of usage and being broken since its introduction into nixpkgs"; # Added 2025-11-29
  presage = throw "presage has been removed, as it has been unmaintained since 2018"; # Added 2025-06-19
  preserves-nim = throw "'preserves-nim' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  private-gpt = throw "'private-gpt' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2025-07-28
  probe-rs = throw "'probe-rs' has been renamed to/replaced by 'probe-rs-tools'"; # Converted to throw 2025-10-27
  proj_7 = throw "proj_7 has been removed, as it was broken and unused"; # Added 2025-09-16
  prometheus-dmarc-exporter = throw "'prometheus-dmarc-exporter' has been renamed to/replaced by 'dmarc-metrics-exporter'"; # Converted to throw 2025-10-27
  prometheus-dovecot-exporter = throw "'prometheus-dovecot-exporter' has been renamed to/replaced by 'dovecot_exporter'"; # Converted to throw 2025-10-27
  protobuf3_21 = throw "'protobuf3_21' has been renamed to/replaced by 'protobuf_21'"; # Converted to throw 2025-10-27
  protobuf3_24 = throw "'protobuf_24' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-07-14
  protobuf_24 = throw "'protobuf_24' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-07-14
  protobuf_26 = throw "'protobuf_26' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-29
  protobuf_28 = throw "'protobuf_28' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-14
  proton-caller = throw "'proton-caller' has been removed from nixpkgs due to being unmaintained and lack of upstream maintenance."; # Added 2025-09-25
  proton-vpn-local-agent = throw "'proton-vpn-local-agent' has been renamed to 'python3Packages.proton-vpn-local-agent'"; # Converted to throw 2025-10-26
  protonup = throw "'protonup' has been renamed to/replaced by 'protonup-ng'"; # Converted to throw 2025-10-27
  protonvpn-cli = throw "protonvpn-cli source code was removed from upstream. Use protonvpn-gui instead."; # Added 2025-10-16
  protonvpn-cli_2 = throw "protonvpn-cli_2 has been removed due to being deprecated. Use protonvpn-gui instead."; # Added 2025-10-16
  proxmark3-rrg = throw "'proxmark3-rrg' has been renamed to/replaced by 'proxmark3'"; # Converted to throw 2025-10-27
  purple-discord = throw "'purple-discord' has been renamed to/replaced by 'pidginPackages.purple-discord'"; # Converted to throw 2025-10-27
  purple-facebook = throw "'purple-facebook' has been removed as it is unmaintained and doesn't support e2ee enforced by facebook."; # Added 2025-09-17
  purple-googlechat = throw "'purple-googlechat' has been renamed to/replaced by 'pidginPackages.purple-googlechat'"; # Converted to throw 2025-10-27
  purple-hangouts = throw "'purple-hangouts' has been removed as Hangouts Classic is obsolete and migrated to Google Chat."; # Added 2025-09-17
  purple-lurch = throw "'purple-lurch' has been renamed to/replaced by 'pidginPackages.purple-lurch'"; # Converted to throw 2025-10-27
  purple-matrix = throw "'purple-matrix' has been unmaintained since April 2022, so it was removed."; # Added 2025-09-01
  purple-mm-sms = throw "'purple-mm-sms' has been renamed to/replaced by 'pidginPackages.purple-mm-sms'"; # Converted to throw 2025-10-27
  purple-plugin-pack = throw "'purple-plugin-pack' has been renamed to/replaced by 'pidginPackages.purple-plugin-pack'"; # Converted to throw 2025-10-27
  purple-slack = throw "'purple-slack' has been renamed to/replaced by 'pidginPackages.purple-slack'"; # Converted to throw 2025-10-27
  purple-vk-plugin = throw "'purple-vk-plugin' has been removed as upstream repository was deleted and no active forks are found."; # Added 2025-09-17
  purple-xmpp-http-upload = throw "'purple-xmpp-http-upload' has been renamed to/replaced by 'pidginPackages.purple-xmpp-http-upload'"; # Converted to throw 2025-10-27
  pyo3-pack = throw "'pyo3-pack' has been renamed to/replaced by 'maturin'"; # Converted to throw 2025-10-27
  pypolicyd-spf = throw "'pypolicyd-spf' has been renamed to/replaced by 'spf-engine'"; # Converted to throw 2025-10-27
  python3Full = throw "python3Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python310Full = throw "python310Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python311Full = throw "python311Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python312Full = throw "python312Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python313Full = throw "python313Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python314Full = throw "python314Full has been removed. Bluetooth support is now enabled by default. The tkinter package is available within the package set."; # Added 2025-08-30
  python = throw "`python` previously pointed to Python 2; use `python3` or `python2` if necessary"; # Converted to throw 2025-10-27
  pythonFull = throw "'pythonFull' previously pointed to Python 2; use `python3` or `python2Full` if necessary"; # Converted to throw 2025-10-27
  pythonPackages = throw "`pythonPackages` previously pointed to Python 2; use `python3Packages` or `python2.pkgs` if necessary"; # Converted to throw 2025-10-27
  qcachegrind = throw "'qcachegrind' has been removed, as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  qflipper = throw "'qflipper' has been renamed to/replaced by 'qFlipper'"; # Converted to throw 2025-10-27
  qnial = throw "'qnial' has been removed due to failing to build and being unmaintained"; # Added 2025-06-26
  qrscan = throw "qrscan has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-19
  qscintilla = throw "'qscintilla' has been renamed to/replaced by 'libsForQt5.qscintilla'"; # Converted to throw 2025-10-27
  qscintilla-qt6 = throw "'qscintilla-qt6' has been renamed to/replaced by 'qt6Packages.qscintilla'"; # Converted to throw 2025-10-27
  qt5Full = throw "qt5Full has been removed. Please use individual packages instead."; # Added 2025-10-18
  qt6ct = throw "'qt6ct' has been renamed to/replaced by 'qt6Packages.qt6ct'"; # Converted to throw 2025-10-27
  qt515 = throw "'qt515' has been renamed to/replaced by 'qt5'"; # Converted to throw 2025-10-27
  qt-video-wlr = throw "'qt-video-wlr' has been removed, as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  qtchan = throw "'qtchan' has been removed due to lack of maintenance upstream"; # Added 2025-07-01
  qtile-unwrapped = throw "'qtile-unwrapped' has been renamed to/replaced by 'python3.pkgs.qtile'"; # Converted to throw 2025-10-27
  quantum-espresso-mpi = throw "'quantum-espresso-mpi' has been renamed to/replaced by 'quantum-espresso'"; # Converted to throw 2025-10-27
  quaternion-qt5 = throw "'quaternion-qt5' has been removed as quaternion dropped Qt5 support with v0.0.97.1"; # Added 2025-05-24
  qubes-core-vchan-xen = throw "'qubes-core-vchan-xen' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-11
  quicksynergy = throw "'quicksynergy' has been removed due to lack of maintenance upstream. Consider using 'deskflow' instead."; # Added 2025-06-18
  quictls = throw "'quictls' has been removed. QUIC support is now available in `openssl`.";
  quorum = throw "'quorum' has been removed as it was broken and unmaintained upstream"; # Added 2025-11-07
  qv2ray = throw "'qv2ray' has been removed as it was unmaintained"; # Added 2025-06-03
  ra-multiplex = lib.warnOnInstantiate "'ra-multiplex' has been renamed to/replaced by 'lspmux'" lspmux; # Added 2025-10-27
  radicale3 = throw "'radicale3' has been renamed to/replaced by 'radicale'"; # Converted to throw 2025-10-27
  railway-travel = throw "'railway-travel' has been renamed to/replaced by 'diebahn'"; # Converted to throw 2025-10-27
  rambox-pro = throw "'rambox-pro' has been renamed to/replaced by 'rambox'"; # Converted to throw 2025-10-27
  rapidjson-unstable = throw "'rapidjson-unstable' has been renamed to/replaced by 'rapidjson'"; # Converted to throw 2025-10-27
  react-static = throw "'react-static' has been removed due to lack of maintenance upstream"; # Added 2025-11-04
  recurseIntoAttrs = warnAlias "'recurseIntoAttrs' has been removed from pkgs, use `lib.recurseIntoAttrs` instead" lib.recurseIntoAttrs; # Added 2025-10-30
  redict = throw "'redict' has been removed due to lack of nixpkgs maintenance and a slow upstream development pace. Consider using 'valkey'."; # Added 2025-10-16
  redoc-cli = throw "'redoc-cli' been removed because it has been marked as broken since at least November 2024. Consider using 'redocly' instead."; # Added 2025-10-01
  redocly-cli = throw "'redocly-cli' has been renamed to/replaced by 'redocly'"; # Converted to throw 2025-10-27
  redpanda = throw "'redpanda' has been renamed to/replaced by 'redpanda-client'"; # Converted to throw 2025-10-27
  redshift-plasma-applet = throw "'redshift-plasma-applet' has been removed as it is obsolete and lacks maintenance upstream."; # Added 2025-11-09
  remotebox = throw "remotebox has been removed because it was unmaintained and broken for a long time"; # Added 2025-09-11
  responsively-app = throw "'responsively-app' has been removed due to lack of maintenance upstream."; # Added 2025-06-25
  retroarchBare = throw "'retroarchBare' has been renamed to/replaced by 'retroarch-bare'"; # Converted to throw 2025-10-27
  retroarchFull = throw "'retroarchFull' has been renamed to/replaced by 'retroarch-full'"; # Converted to throw 2025-10-27
  retroshare06 = throw "'retroshare06' has been renamed to/replaced by 'retroshare'"; # Converted to throw 2025-10-27
  rewind-ai = throw "'rewind-ai' has been removed due to lack of of maintenance upstream"; # Added 2025-08-03
  rigsofrods = throw "'rigsofrods' has been renamed to/replaced by 'rigsofrods-bin'"; # Converted to throw 2025-10-27
  river = throw "'river' has been renamed to/replaced by 'river-classic'"; # Added 2025-08-30
  rke2_1_29 = throw "'rke2_1_29' has been removed from nixpkgs as it has reached end of life"; # Added 2025-05-05
  rke2_1_30 = throw "'rke2_1_30' has been removed from nixpkgs as it has reached end of life"; # Added 2025-11-04
  rl_json = throw "'rl_json' has been renamed to/replaced by 'tclPackages.rl_json'"; # Converted to throw 2025-10-27
  rockbox_utility = throw "'rockbox_utility' has been renamed to/replaced by 'rockbox-utility'"; # Converted to throw 2025-10-27
  rockcraft = throw "rockcraft was removed in Sep 25 following removal of LXD from nixpkgs"; # Added 2025-09-18
  rofi-emoji-wayland = throw "'rofi-emoji-wayland' has been merged into `rofi-emoji as 'rofi-wayland' has been merged into 'rofi'"; # Added 2025-09-06
  rofi-wayland = throw "'rofi-wayland' has been merged into 'rofi'"; # Added 2025-09-06
  rofi-wayland-unwrapped = throw "'rofi-wayland-unwrapped' has been merged into 'rofi-unwrapped'"; # Added 2025-09-06
  root5 = throw "root5 has been removed from nixpkgs because it's a legacy version"; # Added 2025-07-17
  rote = throw "rote has been removed due to lack of upstream maintenance"; # Added 2025-09-10
  rquickshare-legacy = throw "The legacy version depends on insecure package libsoup2, please use the main version"; # Added 2025-10-09
  rr-unstable = throw "'rr-unstable' has been renamed to/replaced by 'rr'"; # Converted to throw 2025-10-27
  rtx = throw "'rtx' has been renamed to/replaced by 'mise'"; # Converted to throw 2025-10-27
  ruby-zoom = throw "'ruby-zoom' has been removed due to lack of maintaince and had not been updated since 2020"; # Added 2025-08-24
  ruby_3_1 = throw "ruby_3_1 has been removed, as it is has reached end‐of‐life upstream"; # Added 2025-10-12
  ruby_3_2 = throw "ruby_3_2 has been removed, as it will reach end‐of‐life upstream during Nixpkgs 25.11’s support cycle"; # Added 2025-10-12
  rubyPackages_3_1 = throw "rubyPackages_3_1 has been removed, as it is has reached end‐of‐life upstream"; # Added 2025-10-12
  rubyPackages_3_2 = throw "rubyPackages_3_2 has been removed, as it will reach end‐of‐life upstream during Nixpkgs 25.11’s support cycle"; # Added 2025-10-12
  rucksack = throw "rucksack was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  runCommandNoCC = warnAlias "'runCommandNoCC' has been renamed to/replaced by 'runCommand'" runCommand; # Converted to warning 2025-10-28
  runCommandNoCCLocal = warnAlias "'runCommandNoCCLocal' has been renamed to/replaced by 'runCommandLocal'" runCommandLocal; # Converted to warning 2025-10-28
  rust-synapse-state-compress = throw "'rust-synapse-state-compress' has been renamed to/replaced by 'rust-synapse-compress-state'"; # Converted to throw 2025-10-27
  rustc-wasm32 = throw "'rustc-wasm32' has been renamed to/replaced by 'rustc'"; # Converted to throw 2025-10-27
  rustic-rs = throw "'rustic-rs' has been renamed to/replaced by 'rustic'"; # Converted to throw 2025-10-27
  ryujinx = throw "'ryujinx' has been replaced by 'ryubing' as the new upstream"; # Added 2025-07-30
  ryujinx-greemdev = throw "'ryujinx-greemdev' has been renamed to/replaced by 'ryubing'"; # Converted to throw 2025-10-27
  scantailor = throw "'scantailor' has been renamed to/replaced by 'scantailor-advanced'"; # Converted to throw 2025-10-27
  scitoken-cpp = throw "'scitoken-cpp' has been renamed to/replaced by 'scitokens-cpp'"; # Converted to throw 2025-10-27
  scudcloud = throw "'scudcloud' has been removed as it was archived by upstream"; # Added 2025-07-24
  SDL2_classic = throw "'SDL2_classic' has been removed. Consider upgrading to 'sdl2-compat', also available as 'SDL2'."; # Added 2025-05-20
  SDL2_classic_image = throw "'SDL2_classic_image' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_image' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_mixer = throw "'SDL2_classic_mixer' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_mixer' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_ttf = throw "'SDL2_classic_ttf' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_ttf' built with 'sdl2-compat'."; # Added 2025-05-20
  seafile-server = throw "'seafile-server' has been removed as it is unmaintained"; # Added 2025-08-21
  seahub = throw "'seahub' has been removed as it is unmaintained"; # Added 2025-08-21
  semiphemeral = throw "'semiphemeral' has been removed as it is archived upstream"; # Added 2025-11-06
  sequoia = throw "'sequoia' has been renamed to/replaced by 'sequoia-sq'"; # Converted to throw 2025-10-27
  serverless = throw "'serverless' has been removed because version 3.x is unmaintained upstream and vulnerable, and version 4.x lacks a suitable binary or source download."; # Added 2025-11-22
  session-desktop-appimage = throw "'session-desktop-appimage' has been renamed to/replaced by 'session-desktop'"; # Converted to throw 2025-10-27
  setserial = throw "'setserial' has been removed as it had been abandoned upstream"; # Added 2025-05-18
  sexp = throw "'sexp' has been renamed to/replaced by 'sexpp'"; # Converted to throw 2025-10-27
  shadered = throw "shadered has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  shared_desktop_ontologies = throw "'shared_desktop_ontologies' has been removed as it had been abandoned upstream"; # Added 2025-11-09
  shipyard = throw "'shipyard' has been renamed to/replaced by 'jumppad'"; # Converted to throw 2025-10-27
  siduck76-st = throw "'siduck76-st' has been renamed to/replaced by 'st-snazzy'"; # Converted to throw 2025-10-27
  sierra-breeze-enhanced = throw "'sierra-breeze-enhanced' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  signal-desktop-source = throw "'signal-desktop-source' has been renamed to/replaced by 'signal-desktop'"; # Converted to throw 2025-10-27
  simplesamlphp = throw "'simplesamlphp' was removed because it was unmaintained in nixpkgs"; # Added 2025-10-17
  siproxd = throw "'siproxd' has been removed as it was unmaintained and incompatible with newer libosip versions"; # Added 2025-05-18
  sipwitch = throw "'sipwitch' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  sisco.lv2 = throw "'sisco.lv2' has been removed as it was unmaintained and broken"; # Added 2025-08-26
  SkypeExport = throw "'skypeexport' was removed since Skype has been shut down in May 2025"; # Added 2025-09-15
  skypeexport = throw "'skypeexport' was removed since Skype has been shut down in May 2025"; # Added 2025-09-15
  sladeUnstable = slade-unstable; # Added 2025-08-26
  slic3r = throw "'slic3r' has been removed because it is unmaintained"; # Added 2025-08-26
  sloccount = throw "'sloccount' has been removed because it is unmaintained. Consider migrating to 'loccount'"; # Added 2025-05-17
  slrn = throw "'slrn' has been removed because it is unmaintained upstream and broken."; # Added 2025-06-11
  slurm-llnl = throw "'slurm-llnl' has been renamed to/replaced by 'slurm'"; # Converted to throw 2025-10-27
  smartgithg = throw "'smartgithg' has been renamed to/replaced by 'smartgit'"; # Converted to throw 2025-10-27
  snapcraft = throw "snapcraft was removed in Sep 25 following removal of LXD from nixpkgs"; # Added 2025-09-18
  snort2 = throw "snort2 has been removed as it is deprecated and unmaintained by upstream. Consider using snort (snort3) package instead."; # 2025-05-21
  snowman = throw "snowman has been removed as it is unmaintained by upstream"; # 2025-10-12
  soldat-unstable = throw "'soldat-unstable' has been renamed to/replaced by 'opensoldat'"; # Converted to throw 2025-10-27
  somatic-sniper = throw "somatic-sniper has been removed as it was archived in 2020 and fails to build."; # Added 2025-10-14
  sonusmix = throw "'sonusmix' has been removed due to lack of maintenance"; # Added 2025-08-27
  soulseekqt = throw "'soulseekqt' has been removed due to lack of maintenance in Nixpkgs in a long time. Consider using 'nicotine-plus' or 'slskd' instead."; # Added 2025-06-07
  soundkonverter = throw "'soundkonverter' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  soundOfSorting = throw "'soundOfSorting' has been renamed to/replaced by 'sound-of-sorting'"; # Converted to throw 2025-10-27
  source-han-sans-japanese = throw "'source-han-sans-japanese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  source-han-sans-korean = throw "'source-han-sans-korean' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  source-han-sans-simplified-chinese = throw "'source-han-sans-simplified-chinese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  source-han-sans-traditional-chinese = throw "'source-han-sans-traditional-chinese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  source-han-serif-japanese = throw "'source-han-serif-japanese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  source-han-serif-korean = throw "'source-han-serif-korean' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  source-han-serif-simplified-chinese = throw "'source-han-serif-simplified-chinese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  source-han-serif-traditional-chinese = throw "'source-han-serif-traditional-chinese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  sourceHanSansPackages.japanese = throw "'sourceHanSansPackages.japanese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  sourceHanSansPackages.korean = throw "'sourceHanSansPackages.korean' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  sourceHanSansPackages.simplified-chinese = throw "'sourceHanSansPackages.simplified-chinese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  sourceHanSansPackages.traditional-chinese = throw "'sourceHanSansPackages.traditional-chinese' has been renamed to/replaced by 'source-han-sans'"; # Converted to throw 2025-10-27
  sourceHanSerifPackages.japanese = throw "'sourceHanSerifPackages.japanese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  sourceHanSerifPackages.korean = throw "'sourceHanSerifPackages.korean' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  sourceHanSerifPackages.simplified-chinese = throw "'sourceHanSerifPackages.simplified-chinese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  sourceHanSerifPackages.traditional-chinese = throw "'sourceHanSerifPackages.traditional-chinese' has been renamed to/replaced by 'source-han-serif'"; # Converted to throw 2025-10-27
  sourcehut = throw "'sourcehut.*' has been removed due to being broken and unmaintained"; # Added 2025-06-15
  SP800-90B_EntropyAssessment = throw "'SP800-90B_EntropyAssessment' has been renamed to/replaced by 'sp800-90b-entropyassessment'"; # Converted to throw 2025-10-27
  space-orbit = throw "'space-orbit' has been removed because it is unmaintained; Debian upstream stopped tracking it in 2011."; # Added 2025-06-08
  SPAdes = throw "'SPAdes' has been renamed to/replaced by 'spades'"; # Converted to throw 2025-10-27
  spago = spago-legacy; # Added 2025-09-23, pkgs.spago should become spago@next which hasn't been packaged yet
  spark2014 = throw "'spark2014' has been renamed to/replaced by 'gnatprove'"; # Converted to throw 2025-10-27
  spidermonkey_91 = throw "'spidermonkey_91 is EOL since 2022/09"; # Added 2025-08-26
  spoof = throw "'spoof' has been removed, as it is broken with the latest MacOS versions and is unmaintained upstream"; # Added 2025-11-14
  spotify-unwrapped = throw "'spotify-unwrapped' has been renamed to/replaced by 'spotify'"; # Converted to throw 2025-10-27
  spring = throw "spring has been removed, as it had been broken since 2023 (it was a game; maybe you’re thinking of spring-boot-cli?)"; # Added 2025-09-16
  springLobby = throw "springLobby has been removed, as it had been broken since 2023"; # Added 2025-09-16
  sqlbag = throw "sqlbag has been removed because it has been marked as broken since May 2024."; # Added 2025-10-11
  ssm-agent = throw "'ssm-agent' has been renamed to/replaced by 'amazon-ssm-agent'"; # Converted to throw 2025-10-27
  stacer = throw "'stacer' has been removed because it was abandoned upstream and relied upon vulnerable software"; # Added 2025-11-08
  starpls-bin = throw "'starpls-bin' has been renamed to/replaced by 'starpls'"; # Converted to throw 2025-10-27
  station = throw "station has been removed from nixpkgs, as there were no committers among its maintainers to unblock security issues"; # Added 2025-06-16
  steam-run-native = throw "'steam-run-native' has been renamed to/replaced by 'steam-run'"; # Converted to throw 2025-10-27
  steam-small = throw "'steam-small' has been renamed to/replaced by 'steam'"; # Converted to throw 2025-10-27
  steamcontroller = throw "'steamcontroller' has been removed due to lack of upstream maintenance. Consider using 'sc-controller' instead."; # Added 2025-09-20
  steamPackages.steam = throw "'steamPackages.steam' has been renamed to/replaced by 'steam-unwrapped'"; # Converted to throw 2025-10-27
  steamPackages.steam-fhsenv = throw "'steamPackages.steam-fhsenv' has been renamed to/replaced by 'steam'"; # Converted to throw 2025-10-27
  steamPackages.steam-fhsenv-small = throw "'steamPackages.steam-fhsenv-small' has been renamed to/replaced by 'steam'"; # Converted to throw 2025-10-27
  steamPackages.steamcmd = throw "'steamPackages.steamcmd' has been renamed to/replaced by 'steamcmd'"; # Converted to throw 2025-10-27
  StormLib = throw "'StormLib' has been renamed to/replaced by 'stormlib'"; # Converted to throw 2025-10-27
  strawberry-qt5 = throw "strawberry-qt5 has been replaced by strawberry"; # Converted to throw 2025-07-19
  strawberry-qt6 = throw "strawberry-qt6 has been replaced by strawberry"; # Added 2025-07-19
  stringsWithDeps = warnAlias "'stringsWithDeps' has been removed from pkgs, use `lib.stringsWithDeps` instead" lib.stringsWithDeps; # Added 2025-10-30
  subberthehut = throw "'subberthehut' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  sublime-music = throw "`sublime-music` has been removed because upstream has announced it is no longer maintained. Upstream suggests using `supersonic` instead."; # Added 2025-09-20
  substituteAll = throw "`substituteAll` has been removed. Use `replaceVars` instead."; # Added 2025-05-23
  substituteAllFiles = throw "`substituteAllFiles` has been removed. Use `replaceVars` for each file instead."; # Added 2025-05-23
  suitesparse_4_2 = throw "'suitesparse_4_2' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  suitesparse_4_4 = throw "'suitesparse_4_4' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  sumaclust = throw "'sumaclust' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumalibs = throw "'sumalibs' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumatra = throw "'sumatra' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumneko-lua-language-server = throw "'sumneko-lua-language-server' has been renamed to/replaced by 'lua-language-server'"; # Converted to throw 2025-10-27
  swig4 = throw "'swig4' has been renamed to/replaced by 'swig'"; # Converted to throw 2025-10-27
  swiProlog = throw "'swiProlog' has been renamed to/replaced by 'swi-prolog'"; # Converted to throw 2025-10-27
  swiPrologWithGui = throw "'swiPrologWithGui' has been renamed to/replaced by 'swi-prolog-gui'"; # Converted to throw 2025-10-27
  Sylk = throw "'Sylk' has been renamed to/replaced by 'sylk'"; # Converted to throw 2025-10-27
  symbiyosys = throw "'symbiyosys' has been renamed to/replaced by 'sby'"; # Converted to throw 2025-10-27
  syn2mas = throw "'syn2mas' has been removed. It has been integrated into the main matrix-authentication-service CLI as a subcommand: 'mas-cli syn2mas'."; # Added 2025-07-07
  sync = throw "'sync' has been renamed to/replaced by 'taler-sync'"; # Converted to throw 2025-10-27
  syncall = throw "'syncall' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  syncthing-tray = throw "syncthing-tray has been removed because it is broken and unmaintained"; # Added 2025-05-18
  syncthingtray-qt6 = throw "'syncthingtray-qt6' has been renamed to/replaced by 'syncthingtray'"; # Converted to throw 2025-10-27
  syndicate_utils = throw "'syndicate_utils' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  synth = throw "'synth' has been removed because it is unmaintained"; # Added 2025-11-15
  system = warnAlias "'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'" stdenv.hostPlatform.system; # Converted to warning 2025-10-28
  t1lib = throw "'t1lib' has been removed as it was broken and unmaintained upstream."; # Added 2025-06-11
  tamgamp.lv2 = tamgamp-lv2; # Added 2025-09-27
  taplo-cli = throw "'taplo-cli' has been renamed to/replaced by 'taplo'"; # Converted to throw 2025-10-27
  taplo-lsp = throw "'taplo-lsp' has been renamed to/replaced by 'taplo'"; # Converted to throw 2025-10-27
  targetcli = throw "'targetcli' has been renamed to/replaced by 'targetcli-fb'"; # Converted to throw 2025-10-27
  targetPlatform = warnAlias "'targetPlatform' has been renamed to/replaced by 'stdenv.targetPlatform'" stdenv.targetPlatform; # Converted to warning 2025-10-28
  taro = throw "'taro' has been renamed to/replaced by 'taproot-assets'"; # Converted to throw 2025-10-27
  taskwarrior = throw "'taskwarrior' has been renamed to/replaced by 'taskwarrior2'"; # Converted to throw 2025-10-27
  tbb = onetbb; # Added 2025-09-14
  tbb_2020 = throw "tbb_2020 has been removed because it is unmaintained upstream and had no remaining users; use onetbb"; # Added 2025-09-14
  tbb_2021 = throw "tbb_2021 has been removed because it is unmaintained upstream and had no remaining users; use onetbb"; # Added 2025-09-13
  tbb_2022 = onetbb; # Added 2025-09-14
  tcl-fcgi = throw "'tcl-fcgi' has been renamed to/replaced by 'tclPackages.tcl-fcgi'"; # Converted to throw 2025-10-27
  tclcurl = throw "'tclcurl' has been renamed to/replaced by 'tclPackages.tclcurl'"; # Converted to throw 2025-10-27
  tcllib = throw "'tcllib' has been renamed to/replaced by 'tclPackages.tcllib'"; # Converted to throw 2025-10-27
  tclmagick = throw "'tclmagick' has been renamed to/replaced by 'tclPackages.tclmagick'"; # Converted to throw 2025-10-27
  tcltls = throw "'tcltls' has been renamed to/replaced by 'tclPackages.tcltls'"; # Converted to throw 2025-10-27
  tcludp = throw "'tcludp' has been renamed to/replaced by 'tclPackages.tcludp'"; # Converted to throw 2025-10-27
  tclvfs = throw "'tclvfs' has been renamed to/replaced by 'tclPackages.tclvfs'"; # Converted to throw 2025-10-27
  tclx = throw "'tclx' has been renamed to/replaced by 'tclPackages.tclx'"; # Converted to throw 2025-10-27
  tcp-cutter = throw "tcp-cutter has been removed because it fails to compile and the source url is dead"; # Added 2025-05-25
  tdesktop = throw "'tdesktop' has been renamed to/replaced by 'telegram-desktop'"; # Converted to throw 2025-10-27
  tdlib-purple = throw "'tdlib-purple' has been renamed to/replaced by 'pidginPackages.tdlib-purple'"; # Converted to throw 2025-10-27
  tdom = throw "'tdom' has been renamed to/replaced by 'tclPackages.tdom'"; # Converted to throw 2025-10-27
  teamspeak5_client = throw "'teamspeak5_client' has been renamed to/replaced by 'teamspeak6-client'"; # Converted to throw 2025-10-27
  teamspeak_client = throw "'teamspeak_client' has been renamed to/replaced by 'teamspeak3'"; # Converted to throw 2025-10-27
  tegaki-zinnia-japanese = throw "'tegaki-zinnia-japanese' has been removed due to lack of maintenance"; # Added 2025-09-10
  telepathy-haze = throw "'telepathy-haze' has been removed due to being unmaintained and broken since 2023"; # Added 2025-11-04
  teleport_16 = throw "teleport 16 has been removed as it is EOL. Please upgrade to Teleport 17 or later"; # Added 2025-11-10
  temporalite = throw "'temporalite' has been removed as it is obsolete and unmaintained, please use 'temporal-cli' instead (with `temporal server start-dev`)"; # Added 2025-06-26
  temurin-bin-23 = throw "Temurin 23 has been removed as it has reached its end of life"; # Added 2025-11-04
  temurin-bin-24 = throw "Temurin 24 has been removed as it has reached its end of life"; # Added 2025-10-04
  temurin-jre-bin-23 = throw "Temurin 23 has been removed as it has reached its end of life"; # Added 2025-11-04
  temurin-jre-bin-24 = throw "Temurin 24 has been removed as it has reached its end of life"; # Added 2025-10-04
  tepl = throw "'tepl' has been renamed to/replaced by 'libgedit-tepl'"; # Converted to throw 2025-10-27
  terminus-nerdfont = throw "'terminus-nerdfont' has been renamed to/replaced by 'nerd-fonts.terminess-ttf'"; # Converted to throw 2025-10-27
  testVersion = throw "'testVersion' has been renamed to/replaced by 'testers.testVersion'"; # Converted to throw 2025-10-27
  tet = throw "'tet' has been removed for lack of maintenance"; # Added 2025-10-12
  texinfo4 = throw "'texinfo4' has been removed in favor of the latest version"; # Added 2025-06-08
  textual-paint = throw "'textual-paint' has been removed as it is broken"; # Added 2025-09-10
  tezos-rust-libs = throw "ligo has been removed from nixpkgs for lack of maintenance"; # Added 2025-06-03
  tfplugindocs = throw "'tfplugindocs' has been renamed to/replaced by 'terraform-plugin-docs'"; # Converted to throw 2025-10-27
  thefuck = throw "'thefuck' has been removed due to lack of maintenance upstream and incompatible with python 3.12+. Consider using 'pay-respects' instead"; # Added 2025-05-30
  theLoungePlugins = throw "'theLoungePlugins' has been removed due to only containing throws"; # Added 2025-09-25
  thrust = throw "'thrust' has been removed due to lack of maintenance"; # Added 2025-08-21
  thunderbird-128 = throw "Thunderbird 128 support ended in August 2025"; # Added 2025-09-30
  thunderbird-128-unwrapped = throw "Thunderbird 128 support ended in August 2025"; # Added 2025-09-30
  ticpp = throw "'ticpp' has been removed due to being unmaintained"; # Added 2025-09-10
  timescaledb = throw "'timescaledb' has been removed. Use 'postgresqlPackages.timescaledb' instead."; # Added 2025-07-19
  tinyxml2 = throw "The 'tinyxml2' alias has been removed, use 'tinyxml' for https://sourceforge.net/projects/tinyxml/ or 'tinyxml-2' for https://github.com/leethomason/tinyxml2"; # Added 2025-10-11
  tix = throw "'tix' has been renamed to/replaced by 'tclPackages.tix'"; # Converted to throw 2025-10-27
  tkcvs = throw "'tkcvs' has been renamed to/replaced by 'tkrev'"; # Converted to throw 2025-10-27
  tkgate = throw "'tkgate' has been removed as it is unmaintained"; # Added 2025-05-17
  tkimg = throw "'tkimg' has been renamed to/replaced by 'tclPackages.tkimg'"; # Converted to throw 2025-10-27
  tlaplusToolbox = tlaplus-toolbox; # Added 2025-08-21
  tokyo-night-gtk = throw "'tokyo-night-gtk' has been renamed to/replaced by 'tokyonight-gtk-theme'"; # Converted to throw 2025-10-27
  tomcat_connectors = throw "'tomcat_connectors' has been renamed to/replaced by 'apacheHttpdPackages.mod_jk'"; # Converted to throw 2025-10-27
  tooling-language-server = deputy; # Added 2025-06-22
  tor-browser-bundle-bin = throw "'tor-browser-bundle-bin' has been renamed to/replaced by 'tor-browser'"; # Converted to throw 2025-10-27
  tracker = throw "'tracker' has been renamed to/replaced by 'tinysparql'"; # Converted to throw 2025-10-27
  tracker-miners = throw "'tracker-miners' has been renamed to/replaced by 'localsearch'"; # Converted to throw 2025-10-27
  transfig = throw "'transfig' has been renamed to/replaced by 'fig2dev'"; # Converted to throw 2025-10-27
  transifex-client = throw "'transifex-client' has been renamed to/replaced by 'transifex-cli'"; # Converted to throw 2025-10-27
  transmission = throw "transmission_3 has been removed in favour of transmission_4. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Converted to throw 2025-10-26
  transmission-gtk = throw "transmission_3-gtk has been removed in favour of transmission_4-gtk. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Converted to throw 2025-10-26
  transmission-qt = throw "transmission_3-qt has been removed in favour of transmission_4-qt. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Converted to throw 2025-10-26
  transmission_3 = throw "transmission_3 has been removed in favour of transmission_4. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Added 2025-10-26
  transmission_3-gtk = throw "transmission_3-gtk has been removed in favour of transmission_4-gtk. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Added 2025-10-26
  transmission_3-qt = throw "transmission_3-qt has been removed in favour of transmission_4-qt. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Added 2025-10-26
  transmission_3_noSystemd = throw "transmission_3_noSystemd has been removed in favour of transmission_4. Note that upgrade caused data loss for some users so backup is recommended (see NixOS 24.11 release notes for details)"; # Added 2025-10-26
  treefmt2 = throw "'treefmt2' has been renamed to/replaced by 'treefmt'"; # Converted to throw 2025-10-27
  tremor-language-server = throw "'tremor-language-server' has been removed because it is unmaintained"; # Added 2025-11-17
  tremor-rs = throw "'tremor-rs' has been removed because it is unmaintained"; # Added 2025-11-17
  trenchbroom = throw "trenchbroom was removed due to numerous vulnerabilities in freeimage"; # Added 2025-10-23
  trezor_agent = throw "'trezor_agent' has been renamed to/replaced by 'trezor-agent'"; # Converted to throw 2025-10-27
  trilium-next-desktop = trilium-desktop; # Added 2025-08-30
  trilium-next-server = trilium-server; # Added 2025-08-30
  trojita = throw "'trojita' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  trust-dns = throw "'trust-dns' has been renamed to/replaced by 'hickory-dns'"; # Converted to throw 2025-10-27
  tvbrowser-bin = throw "'tvbrowser-bin' has been renamed to/replaced by 'tvbrowser'"; # Converted to throw 2025-10-27
  typst-fmt = throw "'typst-fmt' has been renamed to/replaced by 'typstfmt'"; # Converted to throw 2025-10-27
  typstfmt = throw "'typstfmt' has been removed due to lack of upstream maintenance, consider using 'typstyle' instead"; # Added 2025-10-26
  uade123 = throw "'uade123' has been renamed to/replaced by 'uade'"; # Converted to throw 2025-10-27
  uae = throw "'uae' has been removed due to lack of upstream maintenance. Consider using 'fsuae' instead."; # Added 2025-06-11
  ubuntu_font_family = throw "'ubuntu_font_family' has been renamed to/replaced by 'ubuntu-classic'"; # Converted to throw 2025-10-27
  udisks2 = udisks; # Added 2025-10-30
  unicap = throw "'unicap' has been removed because it is unmaintained"; # Added 2025-05-17
  unifi-poller = throw "'unifi-poller' has been renamed to/replaced by 'unpoller'"; # Converted to throw 2025-10-27
  unzoo = throw "'unzoo' has been removed since it is unmaintained upstream and doesn't compile with newer versions of GCC anymore"; # Removed 2025-05-24
  util-linuxCurses = throw "'util-linuxCurses' has been renamed to/replaced by 'util-linux'"; # Converted to throw 2025-10-27
  utillinux = warnAlias "'utillinux' has been renamed to/replaced by 'util-linux'" util-linux; # Converted to warning 2025-10-28
  vaapiIntel = throw "'vaapiIntel' has been renamed to/replaced by 'intel-vaapi-driver'"; # Converted to throw 2025-10-27
  vaapiVdpau = throw "'vaapiVdpau' has been renamed to/replaced by 'libva-vdpau-driver'"; # Converted to throw 2025-10-27
  valum = throw "'valum' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  vamp.vampSDK = throw "'vamp.vampSDK' has been renamed to/replaced by 'vamp-plugin-sdk'"; # Converted to throw 2025-10-27
  vaultwarden-vault = throw "'vaultwarden-vault' has been renamed to/replaced by 'vaultwarden.webvault'"; # Converted to throw 2025-10-27
  vbetool = throw "'vbetool' has been removed as it is broken and not maintained upstream."; # Added 2025-06-11
  vboot_reference = vboot-utils; # Added 2025-11-01
  vc_0_7 = throw "'vc_0_7' has been removed as it was broken, unused in nixpkgs and unmaintained"; # Added 2025-10-20
  vdirsyncerStable = throw "'vdirsyncerStable' has been renamed to/replaced by 'vdirsyncer'"; # Converted to throw 2025-10-27
  ventoy-bin = throw "'ventoy-bin' has been renamed to/replaced by 'ventoy'"; # Converted to throw 2025-10-27
  ventoy-bin-full = throw "'ventoy-bin-full' has been renamed to/replaced by 'ventoy-full'"; # Converted to throw 2025-10-27
  verilog = throw "'verilog' has been renamed to/replaced by 'iverilog'"; # Converted to throw 2025-10-27
  veriT = verit; # Added 2025-08-21
  vieb = throw "'vieb' has been removed as it doesn't satisfy our security criteria for browsers."; # Added 2025-06-25
  ViennaRNA = throw "'ViennaRNA' has been renamed to/replaced by 'viennarna'"; # Converted to throw 2025-10-27
  vim_configurable = throw "'vim_configurable' has been renamed to/replaced by 'vim-full'"; # Converted to throw 2025-10-27
  vimHugeX = throw "'vimHugeX' has been renamed to/replaced by 'vim-full'"; # Converted to throw 2025-10-27
  virt-manager-qt = throw "'virt-manager-qt' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  virtkey = throw "'virtkey' has been removed, as it was unmaintained, abandoned upstream, and relied on gtk2."; # Added 2025-10-12
  vistafonts = throw "'vistafonts' has been renamed to/replaced by 'vista-fonts'"; # Converted to throw 2025-10-27
  vistafonts-chs = throw "'vistafonts-chs' has been renamed to/replaced by 'vista-fonts-chs'"; # Converted to throw 2025-10-27
  vistafonts-cht = throw "'vistafonts-cht' has been renamed to/replaced by 'vista-fonts-cht'"; # Converted to throw 2025-10-27
  vkBasalt = throw "'vkBasalt' has been renamed to/replaced by 'vkbasalt'"; # Converted to throw 2025-10-27
  vkdt-wayland = throw "'vkdt-wayland' has been renamed to/replaced by 'vkdt'"; # Converted to throw 2025-10-27
  volk_2 = throw "'volk_2' has been removed after not being used by any package for a long time"; # Added 2025-10-25
  voxelands = throw "'voxelands' has been removed due to lack of upstream maintenance"; # Added 2025-08-30
  vtk_9 = warnAlias "'vtk_9' has been renamed to 'vtk_9_5'" vtk_9_5; # Added 2025-07-18
  vtk_9_egl = warnAlias "'vtk_9_5' now build with egl support by default, so `vtk_9_egl` is deprecated, consider using 'vtk_9_5' instead." vtk_9_5; # Added 2025-07-18
  vtk_9_withQt5 = throw "'vtk_9_withQt5' has been removed, Consider using 'vtkWithQt6' instead."; # Added 2025-07-18
  vtkWithQt5 = throw "'vtkWithQt5' has been removed. Consider using 'vtkWithQt6' instead."; # Added 2025-09-06
  vwm = throw "'vwm' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  w_scan = throw "'w_scan' has been removed due to lack of upstream maintenance"; # Added 2025-08-29
  waitron = throw "'waitron' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  wakatime = throw "'wakatime' has been renamed to/replaced by 'wakatime-cli'"; # Converted to throw 2025-10-27
  wapp = throw "'wapp' has been renamed to/replaced by 'tclPackages.wapp'"; # Converted to throw 2025-10-27
  warmux = throw "'warmux' has been removed as it is unmaintained and broken"; # Added 2025-11-03
  warsow = throw "'warsow' has been removed as it is unmaintained and is broken"; # Added 2025-10-09
  warsow-engine = throw "'warsow-engine' has been removed as it is unmaintained and is broken"; # Added 2025-10-09
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_104;
  wasm-strip = throw "'wasm-strip' has been removed due to upstream deprecation. Use 'wabt' instead."; # Added 2025-11-06
  wavebox = throw "'wavebox' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-24
  wavm = throw "wavm has been removed, as it does not build with supported LLVM versions"; # Added 2025-08-10
  wcurl = throw "'wcurl' has been removed due to being bundled with 'curl'"; # Added 2025-07-04
  wdomirror = throw "'wdomirror' has been removed as it is unmaintained upstream, Consider using 'wl-mirror' instead"; # Added 2025-09-04
  webfontkitgenerator = webfont-bundler; # Added 2025-07-27
  webkitgtk = throw "'webkitgtk' attribute has been removed from nixpkgs, use attribute with ABI version set explicitly"; # Added 2025-06-11
  webkitgtk_4_0 = throw "'webkitgtk_4_0' has been removed, port to `libsoup_3` and switch to `webkitgtk_4_1`"; # Added 2025-10-08
  whatsapp-for-linux = throw "'whatsapp-for-linux' has been renamed to/replaced by 'wasistlos'"; # Converted to throw 2025-10-27
  wifi-password = throw "'wifi-password' has been removed as it was unmaintained upstream"; # Added 2025-08-29
  win-pvdrivers = throw "'win-pvdrivers' has been removed as it was subject to the Xen build machine compromise (XSN-01) and has open security vulnerabilities (XSA-468)"; # Added 2025-08-29
  win-virtio = throw "'win-virtio' has been renamed to/replaced by 'virtio-win'"; # Converted to throw 2025-10-27
  wineWayland = throw "'wineWayland' has been renamed to/replaced by 'wine-wayland'"; # Converted to throw 2025-10-27
  winhelpcgi = throw "'winhelpcgi' has been removed as it was unmaintained upstream and broken with GCC 14"; # Added 2025-06-14
  wkhtmltopdf-bin = throw "'wkhtmltopdf-bin' has been renamed to/replaced by 'wkhtmltopdf'"; # Converted to throw 2025-10-27
  wmii_hg = throw "'wmii_hg' has been renamed to/replaced by 'wmii'"; # Converted to throw 2025-10-27
  woof = throw "'woof' has been removed as it is broken and unmaintained upstream"; # Added 2025-09-04
  worldengine-cli = throw "'worldengine-cli' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-04
  wpa_supplicant_ro_ssids = throw "'wpa_supplicant_ro_ssids' has been renamed to/replaced by 'wpa_supplicant'"; # Converted to throw 2025-10-27
  wrapGAppsHook = throw "'wrapGAppsHook' has been renamed to/replaced by 'wrapGAppsHook3'"; # Converted to throw 2025-10-27
  wrapGradle = throw "'wrapGradle' has been removed; use `gradle-packages.wrapGradle` or `(gradle-packages.mkGradle { ... }).wrapped` instead"; # Added 2025-11-02
  wring = throw "'wring' has been removed since it has been abandoned upstream"; # Added 2025-11-07
  write_stylus = throw "'write_stylus' has been renamed to/replaced by 'styluslabs-write-bin'"; # Converted to throw 2025-10-27
  wxGTK33 = wxwidgets_3_3; # Added 2025-07-20
  xbrightness = throw "'xbrightness' has been removed as it is unmaintained"; # Added 2025-08-28
  xbursttools = throw "'xbursttools' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-12
  xdragon = throw "'xdragon' has been renamed to/replaced by 'dragon-drop'"; # Converted to throw 2025-10-27
  xflux = throw "'xflux' has been removed as it was unmaintained"; # Added 2025-08-22
  xflux-gui = throw "'xflux-gui' has been removed as it was unmaintained"; # Added 2025-08-22
  xinput_calibrator = xinput-calibrator; # Added 2025-08-28
  xjump = throw "'xjump' has been removed as it is unmaintained"; # Added 2025-08-22
  xmlada = throw "'xmlada' has been renamed to/replaced by 'gnatPackages.xmlada'"; # Converted to throw 2025-10-27
  xmlroff = throw "'xmlroff' has been removed as it is unmaintained and broken"; # Added 2025-05-18
  xo = throw "Use 'dbtpl' instead of 'xo'"; # Added 2025-09-28
  xonsh-unwrapped = throw "'xonsh-unwrapped' has been renamed to/replaced by 'python3Packages.xonsh'"; # Converted to throw 2025-10-27
  xorg-autoconf = util-macros; # Added 2025-08-18
  xsw = throw "'xsw' has been removed due to lack of upstream maintenance"; # Added 2025-08-22
  xulrunner = throw "'xulrunner' has been renamed to/replaced by 'firefox-unwrapped'"; # Converted to throw 2025-10-27
  yabar = throw "'yabar' has been removed as the upstream project was archived"; # Added 2025-06-10
  yabar-unstable = throw "'yabar' has been removed as the upstream project was archived"; # Added 2025-06-10
  yafaray-core = throw "'yafaray-core' has been renamed to/replaced by 'libyafaray'"; # Converted to throw 2025-10-27
  yaml-cpp_0_3 = throw "yaml-cpp_0_3 has been removed, as it was unused"; # Added 2025-09-16
  yamlpath = throw "'yamlpath' has been removed because it has been marked as broken since at least November 2024."; # Added 2025-10-01
  yeahwm = throw "'yeahwm' has been removed, as it was broken and unmaintained upstream."; # Added 2025-06-12
  yubikey-manager-qt = throw "'yubikey-manager-qt' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  yubikey-personalization-gui = throw "'yubikey-personalization-gui' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  zandronum-alpha = throw "'zandronum-alpha' has been removed as it was broken and the stable version has caught up"; # Added 2025-10-19
  zandronum-alpha-server = throw "'zandronum-alpha-server' has been removed as it was broken and the stable version has caught up"; # Added 2025-10-19
  zbackup = throw "'zbackup' has been removed due to being unmaintained upstream"; # Added 2025-08-22
  zeal-qt5 = warnAlias "'zeal-qt5' has been removed from nixpkgs. Please use 'zeal' instead" zeal; # Added 2025-08-31
  zeal-qt6 = warnAlias "'zeal-qt6' has been renamed to 'zeal'" zeal; # Added 2025-08-31
  zeroadPackages.zeroad = throw "'zeroadPackages.zeroad' has been renamed to/replaced by 'zeroad'"; # Converted to throw 2025-10-27
  zeroadPackages.zeroad-data = throw "'zeroadPackages.zeroad-data' has been renamed to/replaced by 'zeroad-data'"; # Converted to throw 2025-10-27
  zeroadPackages.zeroad-unwrapped = throw "'zeroadPackages.zeroad-unwrapped' has been renamed to/replaced by 'zeroad-unwrapped'"; # Converted to throw 2025-10-27
  zeromq4 = throw "'zeromq4' has been renamed to/replaced by 'zeromq'"; # Converted to throw 2025-10-27
  zfs_2_2 = throw "'zfs_2_2' has been removed, upgrade to a newer version instead"; # Added 2025-11-08
  zfsStable = throw "'zfsStable' has been renamed to/replaced by 'zfs'"; # Converted to throw 2025-10-27
  zfsUnstable = throw "'zfsUnstable' has been renamed to/replaced by 'zfs_unstable'"; # Converted to throw 2025-10-27
  zig_0_12 = throw "zig 0.12 has been removed, upgrade to a newer version instead"; # Added 2025-08-18
  zigbee2mqtt_1 = throw "Zigbee2MQTT 1.x has been removed, upgrade to the unversioned attribute."; # Added 2025-08-11
  zigbee2mqtt_2 = zigbee2mqtt; # Added 2025-08-11
  zinc = throw "'zinc' has been renamed to/replaced by 'zincsearch'"; # Converted to throw 2025-10-27
  zint = throw "'zint' has been renamed to/replaced by 'zint-qt'"; # Converted to throw 2025-10-27
  zombietrackergps = throw "'zombietrackergps' has been dropped, as it depends on KDE Gear 5 and is unmaintained"; # Added 2025-08-20
  zotify = throw "zotify has been removed due to lack of upstream maintenance"; # Added 2025-09-26
  zq = throw "zq has been replaced by zed"; # Converted to throw 2025-10-26
  zsh-git-prompt = throw "zsh-git-prompt was removed as it is unmaintained upstream"; # Added 2025-08-28
  zulu23 = throw "Zulu OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-14
  zulu24 = throw "Zulu OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-11-14
  zyn-fusion = throw "'zyn-fusion' has been renamed to/replaced by 'zynaddsubfx'"; # Converted to throw 2025-10-27
  # keep-sorted end
}
// plasma5Throws
