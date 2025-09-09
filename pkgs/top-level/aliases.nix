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
      akonadi
      akonadi-calendar
      akonadi-calendar-tools
      akonadi-contacts
      akonadi-import-wizard
      akonadi-mime
      akonadi-notes
      akonadi-search
      akonadiconsole
      akregator
      alligator
      analitza
      angelfish
      applet-window-appmenu
      applet-window-buttons
      arianna
      ark
      audiotube
      aura-browser
      baloo-widgets
      bismuth
      bluedevil
      bomber
      booth
      bovo
      breeze-grub
      breeze-gtk
      breeze-plymouth
      breeze-qt5
      buho
      calendarsupport
      calindori
      cantor
      clip
      colord-kde
      communicator
      dolphin
      dolphin-plugins
      dragon
      elisa
      eventviews
      falkon
      ffmpegthumbs
      filelight
      flatpak-kcm
      ghostwriter
      granatier
      grantleetheme
      gwenview
      incidenceeditor
      index
      juk
      kaccounts-integration
      kaccounts-providers
      kactivitymanagerd
      kaddressbook
      kalarm
      kalgebra
      kalk
      kalzium
      kamoso
      kapman
      kapptemplate
      kasts
      kate
      katomic
      kblackbox
      kblocks
      kbounce
      kbreakout
      kcachegrind
      kcalc
      kcalutils
      kcharselect
      kclock
      kcolorchooser
      kde-cli-tools
      kde-gtk-config
      kde-inotify-survey
      kde2-decoration
      kdebugsettings
      kdeconnect-kde
      kdecoration
      kdegraphics-mobipocket
      kdegraphics-thumbnailers
      kdenetwork-filesharing
      kdenlive
      kdepim-runtime
      kdeplasma-addons
      kdev-php
      kdev-python
      kdevelop
      kdevelop-pg-qt
      kdevelop-unwrapped
      kdf
      kdialog
      kdiamond
      keditbookmarks
      keysmith
      kfind
      kgamma5
      kgeography
      kget
      kgpg
      khelpcenter
      khotkeys
      kidentitymanagement
      kig
      kigo
      killbots
      kimap
      kinfocenter
      kio-admin
      kio-extras
      kio-gdrive
      kipi-plugins
      kirigami-gallery
      kldap
      kleopatra
      klettres
      klines
      kmag
      kmahjongg
      kmail-account-wizard
      kmailtransport
      kmbox
      kmenuedit
      kmime
      kmines
      kmix
      kmousetool
      kmplot
      knavalbattle
      knetwalk
      knights
      knotes
      koko
      kolf
      kollision
      kolourpaint
      kompare
      kongress
      konqueror
      konquest
      konsole
      kontactinterface
      konversation
      kopeninghours
      korganizer
      kosmindoormap
      kpat
      kpimtextedit
      kpipewire
      kpkpass
      kpmcore
      kpublictransport
      kqtquickcharts
      krdc
      krecorder
      kreport
      kreversi
      krfb
      kruler
      ksanecore
      kscreen
      kscreenlocker
      kshisen
      ksmtp
      kspaceduel
      ksquares
      ksshaskpass
      ksudoku
      ksystemlog
      ksystemstats
      kteatime
      ktimer
      ktnef
      ktorrent
      ktrip
      kturtle
      kwallet-pam
      kwalletmanager
      kwave
      kwayland-integration
      kweather
      kwin
      kwrited
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
      marble
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
      merkuro
      messagelib
      milou
      minuet
      okular
      oxygen
      oxygen-sounds
      palapeli
      parachute
      partitionmanager
      picmi
      pim-data-exporter
      pim-sieve-editor
      pimcommon
      plank-player
      plasma-bigscreen
      plasma-browser-integration
      plasma-desktop
      plasma-dialer
      plasma-disks
      plasma-firewall
      plasma-integration
      plasma-mobile
      plasma-nano
      plasma-nm
      plasma-pa
      plasma-phonebook
      plasma-remotecontrollers
      plasma-sdk
      plasma-settings
      plasma-systemmonitor
      plasma-thunderbolt
      plasma-vault
      plasma-welcome
      plasma-workspace
      plasma-workspace-wallpapers
      plasmatube
      polkit-kde-agent
      powerdevil
      print-manager
      qmlkonsole
      qqc2-breeze-style
      rocs
      sddm-kcm
      shelf
      sierra-breeze-enhanced
      skanlite
      skanpage
      soundkonverter
      spectacle
      station
      systemsettings
      telly-skout
      tokodon
      umbrello
      vvave
      xdg-desktop-portal-kde
      xwaylandvideobridge
      yakuake
      zanshin
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
      neochat # added 2025-07-04
      itinerary # added 2025-07-04
      libquotient # added 2025-07-04
      ;
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

{
}
// mapAliases (import ./aliases/drop-in-26.05.nix)
// mapAliases (import ./aliases/drop-in-25.11.nix)
// mapAliases {
  # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.
  forceSystem = system: _: (import self.path { localSystem = { inherit system; }; });

  ### _ ###
  _0verkill = throw "'_0verkill' has been removed due to lack of maintenance"; # Added 2025-08-27
  _1password = lib.warnOnInstantiate "_1password has been renamed to _1password-cli to better follow upstream name usage" _1password-cli; # Added 2024-10-24
  _2048-cli = throw "'_2048-cli' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-curses = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _2048-cli-terminal = throw "'_2048-cli-curses' has been removed due to archived upstream. Consider using '_2048-in-terminal' instead."; # Added 2025-06-07
  _5etools = throw "'_5etools' has been removed, as upstream is in a questionable legal position and the build was broken."; # Added 2025-05-05
  "7z2hashcat" =
    throw "'7z2hashcat' has been renamed to '_7z2hashcat' as the former isn't a valid variable name."; # Added 2024-11-27

  ### A ###

  AusweisApp2 = ausweisapp; # Added 2023-11-08
  a4term = a4; # Added 2023-10-06
  abseil-cpp_202301 = throw "abseil-cpp_202301 has been removed as it was unused in tree"; # Added 2025-08-09
  adminer-pematon = adminneo; # Added 2025-02-20
  adminerneo = adminneo; # Added 2025-02-27
  adobe-reader = throw "'adobe-reader' has been removed, as it was broken, outdated and insecure"; # added 2025-05-31
  afpfs-ng = throw "'afpfs-ng' has been removed as it was broken and unmaintained for 10 years"; # Added 2025-05-17
  ajour = throw "ajour has been removed, the project was archived upstream on 2024-09-17."; # Added 2025-03-12
  akkoma-emoji = recurseIntoAttrs {
    blobs_gg = lib.warnOnInstantiate "'akkoma-emoji.blobs_gg' has been renamed to 'blobs_gg'" blobs_gg; # Added 2025-03-14
  };
  akkoma-frontends = recurseIntoAttrs {
    admin-fe = lib.warnOnInstantiate "'akkoma-frontends.admin-fe' has been renamed to 'akkoma-admin-fe'" akkoma-admin-fe; # Added 2025-03-14
    akkoma-fe = lib.warnOnInstantiate "'akkoma-frontends.akkoma-fe' has been renamed to 'akkoma-fe'" akkoma-fe; # Added 2025-03-14
  };
  alass = throw "'alass' has been removed due to being unmaintained upstream"; # Added 2025-01-25
  amazon-qldb-shell = throw "'amazon-qldb-shell' has been removed due to being unmaintained upstream"; # Added 2025-07-30
  animeko = throw "'animeko' has been removed since it is unmaintained"; # Added 2025-08-20
  ansible-later = throw "ansible-later has been discontinued. The author recommends switching to ansible-lint"; # Added 2025-08-24
  antennas = throw "antennas has been removed as it only works with tvheadend, which nobody was willing to maintain and was stuck on an unmaintained version that required FFmpeg 4. Please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version"; # Added 2024-08-21
  androidndkPkgs_21 = throw "androidndkPkgs_21 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_23 = throw "androidndkPkgs_23 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_23b = throw "androidndkPkgs_23b has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_24 = throw "androidndkPkgs_24 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_25 = throw "androidndkPkgs_25 has been removed, as it is EOL"; # Added 2025-08-09
  androidndkPkgs_26 = throw "androidndkPkgs_26 has been removed, as it is EOL"; # Added 2025-08-09
  ao = libfive; # Added 2024-10-11
  anbox = throw "'anbox' has been removed as the upstream project is unmaintained, see https://github.com/anbox/.github/blob/main/profile/README.md"; # Added 2025-01-04
  antic = throw "'antic' has been removed as it has been merged into 'flint3'"; # Added 2025-03-28
  anevicon = throw "'anevicon' has been removed because the upstream repository no longer exists"; # Added 2025-01-26
  apacheAnt = ant; # Added 2024-11-28
  apparmor-kernel-patches = throw "'apparmor-kernel-patches' has been removed as they were unmaintained, irrelevant and effectively broken"; # Added 2025-04-20
  appimagekit = throw "'appimagekit' has been removed as it was broken in nixpkgs and archived upstream"; # Added 2025-04-19
  appthreat-depscan = dep-scan; # Added 2024-04-10
  arangodb = throw "arangodb has been removed, as it was unmaintained and the packaged version does not build with supported GCC versions"; # Added 2025-08-12
  arb = throw "'arb' has been removed as it has been merged into 'flint3'"; # Added 2025-03-28
  arc-browser = throw "arc-browser was removed due to being unmaintained"; # Added 2025-09-03
  archipelago-minecraft = throw "archipelago-minecraft has been removed, as upstream no longer ships minecraft as a default APWorld."; # Added 2025-07-15
  archivebox = throw "archivebox has been removed, since the packaged version was stuck on django 3."; # Added 2025-08-01
  argo = argo-workflows; # Added 2025-02-01
  aria = aria2; # Added 2024-03-26
  artim-dark = aritim-dark; # Added 2025-07-27
  aseprite-unfree = aseprite; # Added 2023-08-26
  asitop = macpm; # 'macpm' is a better-maintained downstream; keep 'asitop' for backwards-compatibility
  async = throw "'async' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  ats = throw "'ats' has been removed as it is unmaintained for 10 years and broken"; # Added 2025-05-17
  autoconf213 = throw "'autoconf213' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  autoconf264 = throw "'autoconf264' has been removed in favor of 'autoconf'"; # Added 2025-07-21
  automake111x = throw "'automake111x' has been removed in favor of 'automake'"; # Added 2025-07-21
  autoReconfHook = throw "You meant 'autoreconfHook', with a lowercase 'r'."; # preserve
  autoreconfHook264 = throw "'autoreconfHook264' has been removed in favor of 'autoreconfHook'"; # Added 2025-07-21
  autoadb = throw "'autoadb' has been removed due to lack of maintenance upstream"; # Added 2025-01-25
  avr-sim = throw "'avr-sim' has been removed as it was broken and unmaintained. Possible alternatives are 'simavr', SimulAVR and AVRStudio."; # Added 2025-05-31
  axmldec = throw "'axmldec' has been removed as it was broken and unmaintained for 8 years"; # Added 2025-05-17
  awesome-4-0 = awesome; # Added 2022-05-05

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  badwolf = throw "'badwolf' has been removed due to being unmaintained"; # Added 2025-04-15
  bandwidth = throw "'bandwidth' has been removed due to lack of maintenance"; # Added 2025-09-01
  banking = saldo; # added 2025-08-29
  base16-builder = throw "'base16-builder' has been removed due to being unmaintained"; # Added 2025-06-03
  baserow = throw "baserow has been removed, due to lack of maintenance"; # Added 2025-08-02
  bareboxTools = throw "bareboxTools has been removed due to lack of interest in maintaining it in nixpkgs"; # Added 2025-04-19
  bazel_5 = throw "bazel_5 has been removed as it is EOL"; # Added 2025-08-09
  bazel_6 = throw "bazel_6 has been removed as it will be EOL by the release of Nixpkgs 25.11"; # Added 2025-08-19
  BeatSaberModManager = beatsabermodmanager; # Added 2024-06-12
  beam_nox = throw "beam_nox has been removed in favor of beam_minimal or beamMinimalPackages"; # Added 2025-04-01
  beatsabermodmanager = throw "'beatsabermodmanager' has been removed due to lack of upstream maintainenance. Consider using 'bs-manager' instead"; # Added 2025-03-18
  bitbucket-server-cli = throw "bitbucket-server-cli has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  bitcoin-abc = throw "bitcoin-abc has been removed due to a lack of maintanance"; # Added 2025-06-17
  bitcoind-abc = throw "bitcoind-abc has been removed due to a lack of maintanance"; # Added 2025-06-17
  bird = throw "The bird alias was ambiguous and has been removed for the time being. Please explicitly choose bird2 or bird3."; # Added 2025-01-11
  bitwarden = bitwarden-desktop; # Added 2024-02-25
  blender-with-packages =
    args:
    lib.warnOnInstantiate
      "blender-with-packages is deprecated in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"
      (blender.withPackages (_: args.packages)).overrideAttrs
      (lib.optionalAttrs (args ? name) { pname = "blender-" + args.name; }); # Added 2023-10-30
  blockbench-electron = blockbench; # Added 2024-03-16
  bloomeetunes = throw "bloomeetunes is unmaintained and has been removed"; # Added 2025-08-26
  bmap-tools = bmaptool; # Added 2024-08-05
  brasero-original = lib.warnOnInstantiate "Use 'brasero-unwrapped' instead of 'brasero-original'" brasero-unwrapped; # Added 2024-09-29
  breath-theme = throw "'breath-theme' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  bridgand = throw "'brigand' has been removed due to being unmaintained"; # Added 2025-04-30

  buildBarebox = throw "buildBarebox has been removed due to lack of interest in maintaining it in nixpkgs"; # Added 2025-04-19
  buildGo122Module = throw "Go 1.22 is end-of-life, and 'buildGo122Module' has been removed. Please use a newer builder version."; # Added 2025-03-28
  buildXenPackage = throw "'buildXenPackage' has been removed as a custom Xen build can now be achieved by simply overriding 'xen'."; # Added 2025-05-12

  bwidget = tclPackages.bwidget; # Added 2024-10-02
  buildFHSUserEnv = throw "'buildFHSUserEnv' has been renamed to 'buildFHSEnv' and was removed in 25.11"; # Converted to throw 2025-05-31
  buildFHSUserEnvChroot = throw "'buildFHSUserEnvChroot' has been renamed to 'buildFHSEnvChroot' and was removed in 25.11"; # Converted to throw 2025-05-31
  buildFHSUserEnvBubblewrap = throw "'buildFHSUserEnvBubblewrap' has been renamed to 'buildFHSEnvBubblewrap' and was removed in 25.11"; # Converted to throw 2025-05-31

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = vaultwarden;
  bitwarden_rs-mysql = vaultwarden-mysql;
  bitwarden_rs-postgresql = vaultwarden-postgresql;
  bitwarden_rs-sqlite = vaultwarden-sqlite;
  bitwarden_rs-vault = vaultwarden-vault;

  ### C ###

  calcium = throw "'calcium' has been removed as it has been merged into 'flint3'"; # Added 2025-03-28
  calculix = calculix-ccx; # Added 2024-12-18
  calligra = kdePackages.calligra; # Added 2024-09-27
  callPackage_i686 = pkgsi686Linux.callPackage;
  cargo-asm = throw "'cargo-asm' has been removed due to lack of upstream maintenance. Consider 'cargo-show-asm' as an alternative."; # Added 2025-01-29
  cask = emacs.pkgs.cask; # Added 2022-11-12
  catcli = throw "catcli has been superseded by gocatcli"; # Added 2025-04-19
  canonicalize-jars-hook = stripJavaArchivesHook; # Added 2024-03-17
  cargo-espflash = espflash;
  cargo-kcov = throw "'cargo-kcov' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  cargo-information = throw "'cargo-information' has been removed due to being merged upstream into 'cargo'"; # Added 2025-03-09
  cargo-inspect = throw "'cargo-inspect' has been removed due to lack of upstream maintenance. Upstream recommends cargo-expand."; # Added 2025-01-26
  cargo-web = throw "'cargo-web' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  cargonode = throw "'cargonode' has been removed due to lack of upstream maintenance"; # Added 2025-06-18
  cassandra_3_0 = throw "'cassandra_3_0' has been removed has it reached end-of-life"; # Added 2025-03-23
  cassandra_3_11 = throw "'cassandra_3_11' has been removed has it reached end-of-life"; # Added 2025-03-23
  catalyst-browser = throw "'catalyst-browser' has been removed due to a lack of maintenance and not satisfying our security criteria for browsers."; # Added 2025-06-25
  cataract = throw "'cataract' has been removed due to a lack of maintenace"; # Added 2025-08-25
  cataract-unstable = throw "'cataract-unstable' has been removed due to a lack of maintenace"; # Added 2025-08-25
  cde = throw "'cde' has been removed as it is unmaintained and broken"; # Added 2025-05-17
  centerim = throw "centerim has been removed due to upstream disappearing"; # Added 2025-04-18
  certmgr-selfsigned = certmgr; # Added 2023-11-30
  cgal_4 = throw "cgal_4 has been removed as it is obsolete use cgal instead"; # Added 2024-12-30

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
  chromatic = throw "chromatic has been removed due to being unmaintained and failing to build"; # Added 2025-04-18
  chrome-gnome-shell = gnome-browser-connector; # Added 2022-07-27
  cinnamon-common = cinnamon; # Added 2025-08-06
  ci-edit = throw "'ci-edit' has been removed due to lack of maintenance upstream"; # Added 2025-08-26
  clamsmtp = throw "'clamsmtp' has been removed as it is unmaintained and broken"; # Added 2025-05-17
  clang-sierraHack-stdenv = clang-sierraHack; # Added 2024-10-05
  cli-visualizer = throw "'cli-visualizer' has been removed as the upstream repository is gone"; # Added 2025-06-05
  clipbuzz = throw "clipbuzz has been removed, as it does not build with supported Zig versions"; # Added 2025-08-09
  cloudlogoffline = throw "cloudlogoffline has been removed"; # added 2025-05-18
  CoinMP = coinmp; # Added 2024-06-12
  code-browser-gtk = throw "'code-browser-gtk' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  code-browser-gtk2 = throw "'code-browser-gtk2' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  code-browser-qt = throw "'code-browser-qt' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  collada-dom = opencollada; # added 2024-02-21
  collada2gltf = throw "collada2gltf has been removed from Nixpkgs, as it has been unmaintained upstream for 5 years and does not build with supported GCC versions"; # Addd 2025-08-08
  colloid-kde = throw "'colloid-kde' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  colorstorm = throw "'colorstorm' has been removed because it was unmaintained in nixpkgs and upstream was rewritten."; # Added 2025-06-15
  connman-ncurses = throw "'connman-ncurses' has been removed due to lack of maintenance upstream."; # Added 2025-05-27
  copilot-language-server-fhs = lib.warnOnInstantiate "The package set `copilot-language-server-fhs` has been renamed to `copilot-language-server`." copilot-language-server; # Added 2025-09-07
  copper = throw "'copper' has been removed, as it was broken since 22.11"; # Added 2025-08-22
  cordless = throw "'cordless' has been removed due to being archived upstream. Consider using 'discordo' instead."; # Added 2025-06-07
  cosmic-tasks = tasks; # Added 2024-07-04
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  crispyDoom = crispy-doom; # Added 2023-05-01
  cromite = throw "'cromite' has been removed from nixpkgs due to it not being maintained"; # Added 2025-06-12
  crossLibcStdenv = stdenvNoLibc; # Added 2024-09-06
  crystal_1_2 = throw "'crystal_1_2' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_7 = throw "'crystal_1_7' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_8 = throw "'crystal_1_8' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_9 = throw "'crystal_1_9' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-13
  crystal_1_11 = throw "'crystal_1_11' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-09-04
  crystal_1_12 = throw "'crystal_1_12' has been removed as it is obsolete and no longer used in the tree. Consider using 'crystal' instead"; # Added 2025-02-19
  clasp = clingo; # added 2022-12-22
  clubhouse-cli = throw "'clubhouse-cli' has been removed due to lack of interest to maintain it in Nixpkgs and failing to build."; # added 2025-04-21
  cockroachdb-bin = cockroachdb; # 2024-03-15
  conduwuit = throw "'conduwuit' has been removed as the upstream repository has been deleted. Consider migrating to 'matrix-conduit', 'matrix-continuwuity' or 'matrix-tuwunel' instead."; # Added 2025-08-08
  crack_attack = throw "'crack_attack' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  create-react-app = throw "'create-react-app' has been removed as it was deprecated. Upstream suggests using a framework for React."; # Added 2025-05-17
  critcl = tclPackages.critcl; # Added 2024-10-02
  crunchy-cli = throw "'crunchy-cli' was sunset, see <https://github.com/crunchy-labs/crunchy-cli/issues/362>"; # Added 2025-03-26
  cudaPackages_11_0 = throw "CUDA 11.0 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_1 = throw "CUDA 11.1 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_2 = throw "CUDA 11.2 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_3 = throw "CUDA 11.3 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_4 = throw "CUDA 11.4 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_5 = throw "CUDA 11.5 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_6 = throw "CUDA 11.6 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_7 = throw "CUDA 11.7 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11_8 = throw "CUDA 11.8 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_11 = throw "CUDA 11 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_0 = throw "CUDA 12.0 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_1 = throw "CUDA 12.1 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_2 = throw "CUDA 12.2 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_3 = throw "CUDA 12.3 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_4 = throw "CUDA 12.4 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cudaPackages_12_5 = throw "CUDA 12.5 has been removed from Nixpkgs, as it is unmaintained upstream and depends on unsupported compilers"; # Added 2025-08-08
  cups-kyodialog3 = cups-kyodialog; # Added 2022-11-12
  cutemarked-ng = throw "'cutemarked-ng' has been removed due to lack of maintenance upstream. Consider using 'kdePackages.ghostwriter' instead"; # Added 2024-12-27
  cyber = throw "cyber has been removed, as it does not build with supported Zig versions"; # Added 2025-08-09

  # these are for convenience, not for backward compat and shouldn't expire
  clang12Stdenv = lowPrio llvmPackages_12.stdenv;
  clang13Stdenv = lowPrio llvmPackages_13.stdenv;
  clang14Stdenv = lowPrio llvmPackages_14.stdenv;
  clang15Stdenv = lowPrio llvmPackages_15.stdenv;
  clang16Stdenv = lowPrio llvmPackages_16.stdenv;
  clang17Stdenv = lowPrio llvmPackages_17.stdenv;
  clang18Stdenv = lowPrio llvmPackages_18.stdenv;
  clang19Stdenv = lowPrio llvmPackages_19.stdenv;

  clang-tools_12 = llvmPackages_12.clang-tools; # Added 2024-04-22
  clang-tools_13 = llvmPackages_13.clang-tools; # Added 2024-04-22
  clang-tools_14 = llvmPackages_14.clang-tools; # Added 2024-04-22
  clang-tools_15 = llvmPackages_15.clang-tools; # Added 2024-04-22
  clang-tools_16 = llvmPackages_16.clang-tools; # Added 2024-04-22
  clang-tools_17 = llvmPackages_17.clang-tools; # Added 2024-04-22
  clang-tools_18 = llvmPackages_18.clang-tools; # Added 2024-04-22
  clang-tools_19 = llvmPackages_19.clang-tools; # Added 2024-08-21

  cligh = throw "'cligh' has been removed since it was unmaintained and its upstream deleted"; # Added 2025-05-05

  ### D ###

  dap = throw "'dap' has been removed because it doesn't compile and has been unmaintained since 2014"; # Added 2025-05-10
  daq = throw "'daq' has been removed as it is unmaintained and broken. Snort2 has also been removed, which depended on this"; # Added 2025-05-21
  darling = throw "'darling' has been removed due to vendoring Python2"; # Added 2025-05-10
  dat = nodePackages.dat;
  dave = throw "'dave' has been removed as it has been archived upstream. Consider using 'webdav' instead"; # Added 2025-02-03
  daytona-bin = throw "'daytona-bin' has been removed, as it was unmaintained in nixpkgs"; # Added 2025-07-21
  dbench = throw "'dbench' has been removed as it is unmaintained for 14 years and broken"; # Added 2025-05-17
  dbus-sharp-1_0 = throw "'dbus-sharp-1_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dbus-sharp-2_0 = throw "'dbus-sharp-2_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dbus-sharp-glib-1_0 = throw "'dbus-sharp-glib-1_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dbus-sharp-glib-2_0 = throw "'dbus-sharp-glib-2_0' has been removed as it was unmaintained and had no dependents"; # Added 2025-08-25
  dclib = throw "'dclib' has been removed as it is unmaintained for 16 years and broken"; # Added 2025-05-25
  deadpixi-sam = deadpixi-sam-unstable;

  deepin = throw "the Deepin desktop environment and associated tools have been removed from nixpkgs due to lack of maintenance"; # Added 2025-08-21
  degit-rs = throw "'degit-rs' has been removed because it is unmaintained upstream and has vulnerable dependencies."; # Added 2025-07-11
  deltachat-cursed = arcanechat-tui; # added 2025-02-25

  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  devdash = throw "'devdash' has been removed as the upstream project was archived"; # Added 2025-03-27
  devdocs-desktop = throw "'devdocs-desktop' has been removed as it is unmaintained upstream and vendors insecure dependencies"; # Added 2025-06-11
  dfilemanager = throw "'dfilemanager' has been dropped as it was unmaintained"; # Added 2025-06-03
  directvnc = throw "'directvnc' has been removed as it was unmaintained upstream since 2015 and failed to build with gcc 14"; # Added 2025-05-17
  diskonaut = throw "'diskonaut' was removed due to lack of upstream maintenance"; # Added 2025-01-25
  dispad = throw "dispad has been remove because it doesn't compile and has been unmaintained since 2014"; # Added 2025-04-25
  dleyna-core = dleyna; # Added 2025-04-19
  dleyna-connector-dbus = dleyna; # Added 2025-04-19
  dleyna-renderer = dleyna; # Added 2025-04-19
  dleyna-server = dleyna; # Added 2025-04-19
  dnscrypt-proxy2 = dnscrypt-proxy; # Added 2023-02-02
  docker_24 = throw "'docker_24' has been removed because it has been unmaintained since June 2024. Use docker_25 or newer instead."; # Added 2024-12-21
  docker_26 = throw "'docker_26' has been removed because it has been unmaintained since February 2025. Use docker_28 or newer instead."; # Added 2025-06-21
  docker_27 = throw "'docker_27' has been removed because it has been unmaintained since May 2025. Use docker_28 or newer instead."; # Added 2025-06-15
  docker-distribution = distribution; # Added 2023-12-26
  docker-sync = throw "'docker-sync' has been removed because it was broken and unmaintained"; # Added 2025-08-26
  dolphin-emu-beta = dolphin-emu; # Added 2023-02-11
  dotty = scala_3; # Added 2023-08-20
  dotnetenv = throw "'dotnetenv' has been removed because it was unmaintained in Nixpkgs"; # Added 2025-07-11
  downonspot = throw "'downonspot' was removed because upstream has been taken down by a cease and desist"; # Added 2025-01-25
  dozenal = throw "dozenal has been removed because it does not compile and only minimal functionality"; # Added 2025-03-30
  dsd = throw "dsd has been removed, as it was broken and lack of upstream maintenance"; # Added 2025-08-25
  dstat = throw "'dstat' has been removed because it has been unmaintained since 2020. Use 'dool' instead."; # Added 2025-01-21
  dtv-scan-tables_linuxtv = dtv-scan-tables; # Added 2023-03-03
  dtv-scan-tables_tvheadend = dtv-scan-tables; # Added 2023-03-03
  du-dust = dust; # Added 2024-01-19
  duckstation = throw "'duckstation' has been removed due to being unmaintained"; # Added 2025-08-03
  duckstation-bin = throw "'duckstation-bin' has been removed due to being unmaintained"; # Added 2025-08-03
  dump1090 = dump1090-fa; # Added 2024-02-12
  dwfv = throw "'dwfv' has been removed due to lack of upstream maintenance"; # Added 2025-01-26

  ### E ###

  EBTKS = ebtks; # Added 2024-01-21
  eask = eask-cli; # Added 2024-09-05
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01

  ecryptfs-helper = throw "'ecryptfs-helper' has been removed, for filesystem-level encryption, use fscrypt"; # Added 2025-04-08
  edbrowse = throw "'edbrowse' has been removed as it was unmaintained in Nixpkgs"; # Added 2025-05-18
  edgedb = throw "edgedb replaced to gel because of change of upstream"; # Added 2025-02-24
  edge-runtime = throw "'edge-runtime' was removed as it was unused, unmaintained, likely insecure and failed to build"; # Added 2025-05-18
  edid-decode = v4l-utils; # Added 2025-06-20
  eidolon = throw "eidolon was removed as it is unmaintained upstream."; # Added 2025-05-28
  eintopf = lauti; # Project was renamed, added 2025-05-01
  elasticsearch7Plugins = elasticsearchPlugins;
  electronplayer = throw "'electronplayer' has been removed as it had been discontinued upstream since October 2024"; # Added 2024-12-17
  elm-github-install = throw "'elm-github-install' has been removed as it is abandoned upstream and only supports Elm 0.18.0"; # Added 2025-08-25
  element-desktop-wayland = throw "element-desktop-wayland has been removed. Consider setting NIXOS_OZONE_WL=1 via 'environment.sessionVariables' instead"; # Added 2024-12-17
  elementsd-simplicity = throw "'elementsd-simplicity' has been removed due to lack of maintenance, consider using 'elementsd' instead"; # Added 2025-06-04

  elixir_ls = elixir-ls; # Added 2023-03-20

  # Emacs
  emacs28 = throw "Emacs 28 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs28-gtk3 = throw "Emacs 28 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs28-macport = throw "Emacs 28 Macport is removed due to CVEs which are fixed in Emacs 30 and backported to Emacs 29 Macport"; # Added 2025-04-06
  emacs28-nox = throw "Emacs 28 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs28NativeComp = emacs28; # Added 2022-06-08
  emacs29 = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs29-gtk3 = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs29-nox = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacs29-pgtk = throw "Emacs 29 is removed due to CVEs which are fixed in Emacs 30"; # Added 2025-03-03
  emacsMacport = emacs-macport; # Added 2023-08-10
  emacsNativeComp = emacs; # Added 2022-06-08
  emacsPackages = emacs.pkgs; # Added 2025-03-02

  EmptyEpsilon = empty-epsilon; # Added 2024-07-14
  enyo-doom = enyo-launcher; # Added 2022-09-09
  eolie = throw "'eolie' has been removed due to being unmaintained"; # Added 2025-04-15
  epapirus-icon-theme = throw "'epapirus-icon-theme' has been removed because 'papirus-icon-theme' no longer supports building with elementaryOS icon support"; # Added 2025-06-15
  ephemeral = throw "'ephemeral' has been archived upstream since 2022-04-02"; # added 2025-04-12

  eris-go = throw "'eris-go' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01
  eriscmd = throw "'eriscmd' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01

  erlang_24 = throw "erlang_24 has been removed as it is unmaintained upstream"; # Added 2024-12-26
  erlang_nox = throw "erlang_nox has been removed in favor of beam_minimal.packages.erlang or beamMinimalPackages.erlang"; # added 2025-04-01
  erlang_25 = throw "erlang_25 has been removed as it is unmaintained upstream"; # added 2025-03-31

  erlang_language_platform = throw "erlang_language_platform has been renamed erlang-language-platform"; # added 2025-04-04

  est-sfs = throw "'est-sfs' has been removed as it was unmaintained in Nixpkgs"; # Added 2025-05-18

  eww-wayland = lib.warnOnInstantiate "eww now can build for X11 and wayland simultaneously, so `eww-wayland` is deprecated, use the normal `eww` package instead." eww;

  ### F ###

  f3d_egl = lib.warnOnInstantiate "'f3d' now build with egl support by default, so `f3d_egl` is deprecated, consider using 'f3d' instead." f3d; # added 2025-07-18
  faustStk = faustPhysicalModeling; # Added 2023-05-16
  fastnlo_toolkit = fastnlo-toolkit; # Added 2024-01-03
  fbjni = throw "fbjni has been removed, as it was broken"; # Added 2025-08-25
  fcitx5-catppuccin = catppuccin-fcitx5; # Added 2024-06-19
  fdr = throw "fdr has been removed, as it cannot be built from source and depends on Python 2.x"; # Added 2025-03-19
  inherit (luaPackages) fennel; # Added 2022-09-24
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve
  FIL-plugins = fil-plugins; # Added 2024-06-12
  filet = throw "'filet' has been removed as the upstream repo has been deleted"; # Added 2025-02-07
  finger_bsd = bsd-finger;
  fingerd_bsd = bsd-fingerd;
  fira-code-nerdfont = lib.warnOnInstantiate "fira-code-nerdfont is redundant. Use nerd-fonts.fira-code instead." nerd-fonts.fira-code; # Added 2024-11-10
  firebird_2_5 = throw "'firebird_2_5' has been removed as it has reached end-of-life and does not build."; # Added 2025-06-10
  firefox-beta-bin = lib.warnOnInstantiate "`firefox-beta-bin` is removed.  Please use `firefox-beta` or `firefox-bin` instead." firefox-beta;
  firefox-devedition-bin = lib.warnOnInstantiate "`firefox-devedition-bin` is removed.  Please use `firefox-devedition` or `firefox-bin` instead." firefox-devedition;
  firefox-esr-128 = throw "The Firefox 128 ESR series has reached its end of life. Upgrade to `firefox-esr` or `firefox-esr-140` instead."; # Added 2025-08-20
  firefox-esr-128-unwrapped = throw "The Firefox 128 ESR series has reached its end of life. Upgrade to `firefox-esr-unwrapped` or `firefox-esr-140-unwrapped` instead."; # Added 2025-08-20
  firefox-wayland = firefox; # Added 2022-11-15
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  fit-trackee = fittrackee; # added 2024-09-03
  flashrom-stable = flashprog; # Added 2024-03-01
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  flatcam = throw "flatcam has been removed because it is unmaintained since 2022 and doesn't support Python > 3.10"; # Added 2025-01-25
  flow-editor = flow-control; # Added 2025-03-05
  flut-renamer = throw "flut-renamer is unmaintained and has been removed"; # Added 2025-08-26
  flutter319 = throw "flutter319 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2024-12-03
  flutter326 = throw "flutter326 has been removed because it isn't updated anymore, and no packages in nixpkgs use it. If you still need it, use flutter.mkFlutter to get a custom version"; # Added 2025-06-08
  fluxctl = throw "fluxctl is unmaintained and has been removed. Migration to flux2 is recommended"; # Added 2025-05-11
  fluxus = throw "fluxus has been removed because it hasn't been updated in 9 years and depended on insecure Racket 7.9"; # Added 2024-12-06
  fmsynth = throw "'fmsynth' has been removed as it was broken and unmaintained both upstream and in nixpkgs."; # Added 2025-09-01
  fntsample = throw "fntsample has been removed as it is unmaintained upstream"; # Added 2025-04-21
  follow = lib.warnOnInstantiate "follow has been renamed to folo" folo; # Added 2025-05-18
  forgejo-actions-runner = forgejo-runner; # Added 2024-04-04
  fornalder = throw "'fornalder' has been removed as it is unmaintained upstream"; # Added 2025-01-25
  foundationdb71 = throw "foundationdb71 has been removed; please upgrade to foundationdb73"; # Added 2024-12-28

  fractal-next = fractal; # added 2023-11-25
  framework-system-tools = framework-tool; # added 2023-12-09
  francis = kdePackages.francis; # added 2024-07-13
  freecad-qt6 = freecad; # added 2025-06-14
  freecad-wayland = freecad; # added 2025-06-14
  freerdp3 = freerdp; # added 2025-03-25
  freerdpUnstable = freerdp; # added 2025-03-25
  ftjam = throw "ftjam was removed, as it hasn't been updated since 2007 and fails to build"; # added 2025-01-02
  fuse2fs = if stdenv.hostPlatform.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  fusee-launcher = throw "'fusee-launcher' was removed as upstream removed the original source repository fearing legal repercussions"; # added 2025-07-05
  futuresql = libsForQt5.futuresql; # added 2023-11-11
  fx_cast_bridge = fx-cast-bridge; # added 2023-07-26

  fcitx5-chinese-addons = qt6Packages.fcitx5-chinese-addons; # Added 2024-03-01
  fcitx5-configtool = qt6Packages.fcitx5-configtool; # Added 2024-03-01
  fcitx5-skk-qt = qt6Packages.fcitx5-skk-qt; # Added 2024-03-01
  fcitx5-unikey = qt6Packages.fcitx5-unikey; # Added 2024-03-01
  fcitx5-with-addons = qt6Packages.fcitx5-with-addons; # Added 2024-03-01

  ### G ###

  g4music = gapless; # Added 2024-07-26
  garage_0_8 = throw "'garage_0_8' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_0_8_7 = throw "'garage_0_8_7' has been removed as it is unmaintained upstream"; # Added 2025-06-23
  garage_1_x = lib.warnOnInstantiate "'garage_1_x' has been renamed to 'garage_1'" garage_1; # Added 2025-06-23
  gbl = throw "'gbl' has been removed because the upstream repository no longer exists"; # Added 2025-01-26
  gcc9 = throw "gcc9 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc9Stdenv = throw "gcc9Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc10 = throw "gcc10 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc10Stdenv = throw "gcc10Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc10StdenvCompat = throw "gcc10StdenvCompat has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc11 = throw "gcc11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc11Stdenv = throw "gcc11Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc12 = throw "gcc12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc12Stdenv = throw "gcc12Stdenv has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcc-arm-embedded-6 = throw "gcc-arm-embedded-6 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-7 = throw "gcc-arm-embedded-7 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-8 = throw "gcc-arm-embedded-8 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-9 = throw "gcc-arm-embedded-9 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-10 = throw "gcc-arm-embedded-10 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-11 = throw "gcc-arm-embedded-11 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gcc-arm-embedded-12 = throw "gcc-arm-embedded-12 has been removed from Nixpkgs as it is unmaintained and obsolete"; # Added 2025-04-12
  gccgo12 = throw "gccgo12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gcj = gcj6; # Added 2024-09-13
  gdc = throw "gdc has been removed from Nixpkgs, as recent versions require complex bootstrapping"; # Added 2025-08-08
  gdc11 = throw "gdc11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gdmd = throw "gdmd has been removed from Nixpkgs, as it depends on GDC which was removed"; # Added 2025-08-08
  gdome2 = throw "'gdome2' has been removed from nixpkgs, as it is umaintained and obsolete"; # Added 2024-12-29
  geocode-glib = throw "throw 'geocode-glib' has been removed, as it was unused and used outdated libraries"; # Added 2025-04-16
  geos_3_11 = throw "geos_3_11 has been removed from nixpgks. Please use a more recent 'geos' instead."; # Added 2024-12-07
  gfbgraph = throw "'gfbgraph' has been removed as it was archived upstream and unused in nixpkgs"; # Added 2025-04-20
  gfortran9 = throw "gfortran9 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran10 = throw "gfortran10 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran11 = throw "gfortran11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gfortran12 = throw "gfortran12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gg = go-graft; # Added 2025-03-07
  ggobi = throw "'ggobi' has been removed from Nixpkgs, as it is unmaintained and broken"; # Added 2025-05-18
  ghostwriter = makePlasma5Throw "ghostwriter"; # Added 2023-03-18
  git-annex-utils = throw "'git-annex-utils' has been removed as it is unmaintained"; # Added 2025-05-18
  git-codeowners = throw "'git-codeowners' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  gjay = throw "'gjay' has been removed as it is unmaintained upstream"; # Added 2025-05-25
  gmni = throw "gmni has been removed as it is no longer maintained upstream"; # Added 2025-05-02
  gnu-cobol = gnucobol; # Added 2024-09-17
  gnupg1orig = throw "'gnupg1orig' has been removed due to lack of active upstream maintainance. Consider using 'gnupg' instead"; # Added 2025-01-11
  gnupg22 = throw "'gnupg22' is end-of-life. Consider using 'gnupg24' instead"; # Added 2025-01-05
  gogs = throw ''
    Gogs development has stalled. Also, it has several unpatched, critical vulnerabilities that
    weren't addressed within a year: https://github.com/gogs/gogs/issues/7777

    Consider migrating to forgejo or gitea.
  ''; # Added 2024-10-12
  git-stree = throw "'git-stree' has been deprecated by upstream. Upstream recommends using 'git-subrepo' as a replacement."; # Added 2025-05-05

  gitAndTools = self // {
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  }; # Added 2021-01-14
  github-copilot-cli = throw "'github-copilot-cli' has been removed because GitHub has replaced it with 'gh-copilot'."; # Added 2025-06-01
  gitversion = throw "'gitversion' has been removed because it produced a broken build and was unmaintained"; # Added 2025-08-30
  givaro_3 = throw "'givaro_3' has been removed as it is end-of-life. Consider using the up-to-date 'givaro' instead"; # Added 2025-05-07
  givaro_3_7 = throw "'givaro_3_7' has been removed as it is end-of-life. Consider using the up-to-date 'givaro' instead"; # Added 2025-05-07
  glew-egl = lib.warnOnInstantiate "'glew-egl' is now provided by 'glew' directly" glew; # Added 2024-08-11
  glfw-wayland = glfw; # Added 2024-04-19
  glfw-wayland-minecraft = glfw3-minecraft; # Added 2024-05-08
  glxinfo = mesa-demos; # Added 2024-07-04
  gmnisrv = throw "'gmnisrv' has been removed due to lack of maintenance upstream"; # Added 2025-06-07
  gmp4 = throw "'gmp4' is end-of-life, consider using 'gmp' instead"; # Added 2024-12-24
  gnat11 = throw "gnat11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat-bootstrap11 = throw "gnat-bootstrap11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot11 = throw "gnatboot11 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat12 = throw "gnat12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat-bootstrap12 = throw "gnat-bootstrap12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot12 = throw "gnatboot12 has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnat12Packages = throw "gnat12Packages has been removed from Nixpkgs, as it is unmaintained and obsolete"; # Added 2025-08-08
  gnatboot = gnat-bootstrap;
  gnatcoll-core = gnatPackages.gnatcoll-core; # Added 2024-02-25
  gnatcoll-gmp = gnatPackages.gnatcoll-gmp; # Added 2024-02-25
  gnatcoll-iconv = gnatPackages.gnatcoll-iconv; # Added 2024-02-25
  gnatcoll-lzma = gnatPackages.gnatcoll-lzma; # Added 2024-02-25
  gnatcoll-omp = gnatPackages.gnatcoll-omp; # Added 2024-02-25
  gnatcoll-python3 = gnatPackages.gnatcoll-python3; # Added 2024-02-25
  gnatcoll-readline = gnatPackages.gnatcoll-readline; # Added 2024-02-25
  gnatcoll-syslog = gnatPackages.gnatcoll-syslog; # Added 2024-02-25
  gnatcoll-zlib = gnatPackages.gnatcoll-zlib; # Added 2024-02-25
  gnatcoll-postgres = gnatPackages.gnatcoll-postgres; # Added 2024-02-25
  gnatcoll-sql = gnatPackages.gnatcoll-sql; # Added 2024-02-25
  gnatcoll-sqlite = gnatPackages.gnatcoll-sqlite; # Added 2024-02-25
  gnatcoll-xref = gnatPackages.gnatcoll-xref; # Added 2024-02-25
  gnatcoll-db2ada = gnatPackages.gnatcoll-db2ada; # Added 2024-02-25
  gnatinspect = gnatPackages.gnatinspect; # Added 2024-02-25
  gnome-firmware-updater = gnome-firmware; # added 2022-04-14
  gnome-passwordsafe = gnome-secrets; # added 2022-01-30
  gnome-resources = resources; # added 2023-12-10

  gnufdisk = throw "'gnufdisk' has been removed due to lack of maintenance upstream"; # Added 2024-12-31
  gnustep = throw "The gnustep scope has been replaced with top-level packages: gnustep-back, -base, -gui, -libobjc, -make, -systempreferences; gorm, gworkspace, projectcenter."; # Added 2025-01-25
  grafana-agent = throw "'grafana-agent' has been removed, as it only works with an EOL compiler and will become EOL during the 25.05 release. Consider migrating to 'grafana-alloy' instead"; # Added 2025-04-02
  graphite-kde-theme = throw "'graphite-kde-theme' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20

  #godot
  godot_4_3-export-templates = lib.warnOnInstantiate "godot_4_3-export-templates has been renamed to godot_4_3-export-templates-bin" godot_4_3-export-templates-bin;
  godot_4_4-export-templates = lib.warnOnInstantiate "godot_4_4-export-templates has been renamed to godot_4_4-export-templates-bin" godot_4_4-export-templates-bin;
  godot_4-export-templates = lib.warnOnInstantiate "godot_4-export-templates has been renamed to godot_4-export-templates-bin" godot_4-export-templates-bin;
  godot-export-templates = lib.warnOnInstantiate "godot-export-templates has been renamed to godot-export-templates-bin" godot-export-templates-bin;

  go-thumbnailer = thud; # Added 2023-09-21
  go-upower-notify = upower-notify; # Added 2024-07-21
  googler = throw "'googler' has been removed, as it no longer works and is abandoned upstream"; # Added 2025-04-01
  gprbuild-boot = gnatPackages.gprbuild-boot; # Added 2024-02-25;

  gr-framework = throw "gr-framework has been removed, as it was broken"; # Added 2025-08-25
  graalvmCEPackages = graalvmPackages; # Added 2024-08-10
  graalvm-ce = graalvmPackages.graalvm-ce; # Added 2024-08-10
  graalvm-oracle = graalvmPackages.graalvm-oracle; # Added 2024-12-17
  grafana_reporter = grafana-reporter; # Added 2024-06-09
  graylog-5_0 = throw "graylog 5.0.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.0.x to latest series."; # Added 2024-02-15
  graylog-5_1 = throw "graylog 5.1.x is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.1.x to latest series."; # Added 2024-10-16
  graylog-5_2 = throw "graylog 5.2 is EOL. Please consider downgrading nixpkgs if you need an upgrade from 5.2 to latest series."; # Added 2025-03-21
  green-pdfviewer = throw "'green-pdfviewer' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  gringo = clingo; # added 2022-11-27
  grub2_full = grub2; # Added 2022-11-18
  grun = throw "grun has been removed due to lack of maintenance upstream and depending on gtk2"; # Added 2025-03-29
  gsignond = throw "'gsignond' and its plugins have been removed due to lack of maintenance upstream"; # added 2025-04-17
  gsignondPlugins = throw "'gsignondPlugins' have been removed alongside 'gsignond' due to lack of maintenance upstream and depending on libsoup_2"; # added 2025-04-17
  gtk-engine-bluecurve = throw "'gtk-engine-bluecurve' has been removed as it has been archived upstream."; # Added 2024-12-04
  gtkcord4 = dissent; # Added 2024-03-10
  gtkextra = throw "'gtkextra' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  guile-disarchive = disarchive; # Added 2023-10-27
  guile-sdl = throw "guile-sdl has been removed, as it was broken"; # Added 2025-08-25
  gutenprintBin = gutenprint-bin; # Added 2025-08-21
  gxneur = throw "'gxneur' has been removed due to lack of maintenance and reliance on gnome2 and 2to3."; # Added 2025-08-17

  ### H ###

  hacksaw = throw "'hacksaw' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  haka = throw "haka has been removed because it failed to build and was unmaintained for 9 years"; # Added 2025-03-11
  hardinfo = throw "'hardinfo' has been removed as it was abandoned upstream. Consider using 'hardinfo2' instead."; # added 2025-04-17
  harmony-music = throw "harmony-music is unmaintained and has been removed"; # Added 2025-08-26
  hasura-graphql-engine = throw "hasura-graphql-engine has been removed because was broken and its packaging severly out of date"; # Added 2025-02-14
  haven-cli = throw "'haven-cli' has been removed due to the official announcement of the project closure. Read more at https://havenprotocol.org/2024/12/12/project-closure-announcement"; # Added 2025-02-25
  hawknl = throw "'hawknl' has been removed as it was unmaintained and the upstream unavailable"; # Added 2025-05-07
  HentaiAtHome = hentai-at-home; # Added 2024-06-12
  hiddify-app = throw "hiddify-app has been removed, since it is unmaintained"; # added 2025-08-20
  hoarder = throw "'hoarder' has been renamed to 'karakeep'"; # Added 2025-04-21
  hmetis = throw "'hmetis' has been removed as it was unmaintained and the upstream was unavailable"; # Added 2025-05-05
  hpp-fcl = coal; # Added 2024-11-15
  hydra_unstable = hydra; # Added 2024-08-22
  hyenae = throw "hyenae has been removed because it fails to build and was unmaintained for 15 years"; # Added 2025-04-04
  hyprgui = throw "hyprgui has been removed as the repository is deleted"; # Added 2024-12-27
  hyprlauncher = throw "hyprlauncher has been removed as the repository is deleted"; # Added 2024-12-27
  hyprswitch = throw "hyprswitch has been renamed to hyprshell"; # Added 2025-06-01
  hyprwall = throw "hyprwall has been removed as the repository is deleted"; # Added 2024-12-27

  ### I ###

  i3-gaps = i3; # Added 2023-01-03
  i3nator = throw "'i3nator' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  ibniz = throw "ibniz has been removed because it fails to compile and the source url is dead"; # Added 2025-04-07
  ibm-sw-tpm2 = throw "ibm-sw-tpm2 has been removed, as it was broken"; # Added 2025-08-25
  icuReal = throw "icuReal has been removed from nixpkgs as a mistake"; # Added 2025-02-18
  imaginer = throw "'imaginer' has been removed due to lack of upstream maintenance"; # Added 2025-08-15
  immersed-vr = lib.warnOnInstantiate "'immersed-vr' has been renamed to 'immersed'" immersed; # Added 2024-08-11
  inconsolata-nerdfont = lib.warnOnInstantiate "inconsolata-nerdfont is redundant. Use nerd-fonts.inconsolata instead." nerd-fonts.inconsolata; # Added 2024-11-10
  incrtcl = tclPackages.incrtcl; # Added 2024-10-02
  inotifyTools = inotify-tools;
  insync-emblem-icons = throw "'insync-emblem-icons' has been removed, use 'insync-nautilus' instead"; # Added 2025-05-14
  ioccheck = throw "ioccheck was dropped since it was unmaintained."; # Added 2025-07-06
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  istatmenus = throw "istatmenus has beend renamed to istat-menus"; # Added 2025-05-05
  iso-flags-png-320x420 = lib.warnOnInstantiate "iso-flags-png-320x420 has been renamed to iso-flags-png-320x240" iso-flags-png-320x240; # Added 2024-07-17
  itktcl = tclPackages.itktcl; # Added 2024-10-02
  itpp = throw "itpp has been removed, as it was broken"; # Added 2025-08-25
  iv = throw "iv has been removed as it was no longer required for neuron and broken"; # Added 2025-04-18
  ix = throw "ix has been removed from Nixpkgs, as the ix.io pastebin has been offline since Dec. 2023"; # Added 2025-04-11

  ### J ###

  jack_rack = throw "'jack_rack' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jami-client-qt = jami-client; # Added 2022-11-06
  jami-client = jami; # Added 2023-02-10
  jami-daemon = jami.daemon; # Added 2023-02-10
  jikespg = throw "'jikespg' has been removed due to lack of maintenance upstream."; # Added 2025-06-10
  jscoverage = throw "jscoverage has been removed, as it was broken"; # Added 2025-08-25

  # Julia

  ### K ###

  k3s_1_28 = throw "'k3s_1_28' has been removed from nixpkgs as it has reached end of life"; # Added 2024-12-15
  k3s_1_29 = throw "'k3s_1_29' has been removed from nixpkgs as it has reached end of life"; # Added 2025-05-05
  k3s_1_30 = throw "'k3s_1_30' has been removed from nixpkgs as it has reached end of life"; # Added 2025-09-01
  # k3d was a 3d editing software k-3d - "k3d has been removed because it was broken and has seen no release since 2016" Added 2022-01-04
  # now kube3d/k3d will take its place
  kube3d = k3d; # Added 2022-0705
  kak-lsp = kakoune-lsp; # Added 2024-04-01
  kanidm = lib.warnOnInstantiate "'kanidm' will be removed before 26.05. You must use a versioned package, e.g. 'kanidm_1_x'." kanidm_1_7; # Added 2025-09-01
  kanidmWithSecretProvisioning = lib.warnOnInstantiate "'kanidmWithSecretProvisioning' will be removed before 26.05. You must use a versioned package, e.g. 'kanidmWithSecretProvisioning_1_x'." kanidmWithSecretProvisioning_1_7; # Added 2025-09-01
  kanidm_1_3 = throw "'kanidm_1_3' has been removed as it has reached end of life"; # Added 2025-03-10
  kanidm_1_4 = throw "'kanidm_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kanidmWithSecretProvisioning_1_4 = throw "'kanidmWithSecretProvisioning_1_4' has been removed as it has reached end of life"; # Added 2025-06-18
  kbibtex = throw "'kbibtex' has been removed, as it is unmaintained upstream"; # Added 2025-08-30
  keepkey_agent = keepkey-agent; # added 2024-01-06
  kexi = makePlasma5Throw "kexi";
  kgx = gnome-console; # Added 2022-02-19
  kio-admin = makePlasma5Throw "kio-admin"; # Added 2023-03-18
  kmplayer = throw "'kmplayer' has been removed, as it is unmaintained upstream"; # Added 2025-08-30
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  krb5Full = krb5;
  kreative-square-fonts = throw "'kreative-square-fonts' has been renamed to 'kreative-square'"; # Added 2025-04-16
  krun = throw "'krun' has been renamed to/replaced by 'muvm'"; # Added 2025-05-01
  krunner-pass = throw "'krunner-pass' has been removed, as it only works on Plasma 5"; # Added 2025-08-30
  krunner-translator = throw "'krunner-translator' has been removed, as it only works on Plasma 5"; # Added 2025-08-30
  kubei = kubeclarity; # Added 2023-05-20
  kubo-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2024-09-24

  ### L ###

  larynx = piper-tts; # Added 2023-05-09
  LASzip = laszip; # Added 2024-06-12
  LASzip2 = laszip_2; # Added 2024-06-12
  lanzaboote-tool = throw "lanzaboote-tool has been removed due to lack of integration maintenance with nixpkgs. Consider using the Nix expressions provided by https://github.com/nix-community/lanzaboote"; # Added 2025-07-23
  latencytop = throw "'latencytop' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  latinmodern-math = lmmath;
  latte-dock = throw "'latte-dock' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  layan-kde = throw "'layan-kde' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  lazarus-qt = lazarus-qt5; # Added 2024-12-25
  ledger_agent = ledger-agent; # Added 2024-01-07
  lfs = dysk; # Added 2023-07-03
  libast = throw "'libast' has been removed due to lack of maintenance upstream."; # Added 2025-06-09
  libav_0_8 = libav; # Added 2024-08-25
  libav_11 = libav; # Added 2024-08-25
  libav_12 = libav; # Added 2024-08-25
  libav_all = libav; # Added 2024-08-25
  libayatana-indicator-gtk3 = libayatana-indicator; # Added 2022-10-18
  libayatana-appindicator-gtk3 = libayatana-appindicator; # Added 2022-10-18
  libbencodetools = bencodetools; # Added 2022-07-30
  libbpf_1 = libbpf; # Added 2022-12-06
  libbson = mongoc; # Added 2024-03-11
  libchop = throw "libchop has been removed due to failing to build and being unmaintained upstream"; # Added 2025-05-02
  libdwarf-lite = throw "`libdwarf-lite` has been replaced by `libdwarf` as it's mostly a mirror"; # Added 2025-06-16
  libdwg = throw "libdwg has been removed as upstream is unmaintained, the code doesn't build without significant patches, and the package had no reverse dependencies"; # Added 2024-12-28
  libfpx = throw "libfpx has been removed as it was unmaintained in Nixpkgs and had known vulnerabilities"; # Added 2025-05-20
  libgadu = throw "'libgadu' has been removed as upstream is unmaintained and has no dependents or maintainers in Nixpkgs"; # Added 2025-05-17
  libgcrypt_1_8 = throw "'libgcrypt_1_8' is end-of-life. Consider using 'libgcrypt' instead"; # Added 2025-01-05
  libgda = lib.warnOnInstantiate "‘libgda’ has been renamed to ‘libgda5’" libgda5; # Added 2025-01-21
  lightly-boehs = throw "'lightly-boehs' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  lightly-qt = throw "'lightly-qt' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  libgme = game-music-emu; # Added 2022-07-20
  libgnome-keyring3 = libgnome-keyring; # Added 2024-06-22
  libgrss = throw "'libgrss' has been removed as it was archived upstream and had no users in nixpkgs"; # Added 2025-04-17
  libheimdal = heimdal; # Added 2022-11-18
  libhttpseverywhere = throw "'libhttpseverywhere' has been removed due to lack of upstream maintenance. It was no longer used in nixpkgs."; # Added 2025-04-17
  libiconv-darwin = darwin.libiconv;
  libixp_hg = libixp;
  libmp3splt = throw "'libmp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  libmx = throw "'libmx' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  libosmo-sccp = libosmo-sigtran; # Added 2024-12-20
  libpromhttp = throw "'libpromhttp' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-16
  libpseudo = throw "'libpseudo' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libqt5pas = libsForQt5.libqtpas; # Added 2024-12-25
  libquotient = throw "'libquotient' for qt5 was removed as upstream removed qt5 support. Consider explicitly upgrading to qt6 'libquotient'"; # Converted to throw 2025-07-04
  librdf_raptor = throw "librdf_raptor has been remove due to failing to build and being unmaintained"; # Added 2025-04-14
  LibreArp = librearp; # Added 2024-06-12
  LibreArp-lv2 = librearp-lv2; # Added 2024-06-12
  librtlsdr = rtl-sdr; # Added 2023-02-18
  libreoffice-qt6 = libreoffice-qt; # Added 2025-08-30
  libreoffice-qt6-unwrapped = libreoffice-qt.unwrapped; # Added 2025-08-30
  libreoffice-qt6-fresh = libreoffice-qt-fresh; # Added 2025-08-30
  libreoffice-qt6-fresh-unwrapped = libreoffice-qt-fresh.unwrapped; # Added 2025-08-30
  libreoffice-qt6-still = libreoffice-qt-still; # Added 2025-08-30
  libreoffice-qt6-still-unwrapped = libreoffice-qt-still.unwrapped; # Added 2025-08-30
  librewolf-wayland = librewolf; # Added 2022-11-15
  libsForQt515 = libsForQt5; # Added 2022-11-24
  libsmartcols = lib.warnOnInstantiate "'util-linux' should be used instead of 'libsmartcols'" util-linux; # Added 2025-09-03
  libsoup = lib.warnOnInstantiate "‘libsoup’ has been renamed to ‘libsoup_2_4’" libsoup_2_4; # Added 2024-12-02
  libtensorflow-bin = libtensorflow; # Added 2022-09-25
  libwnck3 = libwnck;
  libxplayer-plparser = throw "libxplayer-plparser has been removed as the upstream project was archived"; # Added 2024-12-27
  libyamlcpp = yaml-cpp; # Added 2023-01-29
  libyamlcpp_0_3 = yaml-cpp_0_3; # Added 2023-01-29
  libzapojit = throw "'libzapojit' has been removed due to lack of upstream maintenance and archival"; # Added 2025-04-16
  licensor = throw "'licensor' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  ligo = throw "ligo has been removed from nixpkgs for lack of maintainance"; # Added 2025-06-03
  lima-bin = lib.warnOnInstantiate "lima-bin has been replaced by lima" lima; # Added 2025-05-13
  lime3ds = throw "lime3ds is deprecated, use 'azahar' instead."; # Added 2025-03-22
  linenoise-ng = throw "'linenoise-ng' has been removed as the upstream project was archived. Consider using 'linenoise' instead."; # Added 2025-05-05
  Literate = literate; # Added 2024-06-12
  littlenavmap = throw "littlenavmap has been removed as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  llama = walk; # Added 2023-01-23

  # Linux kernels
  linux-rt_5_10 = linuxKernel.kernels.linux_rt_5_10;
  linux-rt_5_15 = linuxKernel.kernels.linux_rt_5_15;
  linux-rt_5_4 = linuxKernel.kernels.linux_rt_5_4;
  linux-rt_6_1 = linuxKernel.kernels.linux_rt_6_1;
  linuxPackages_4_19 = linuxKernel.packages.linux_4_19;
  linuxPackages_5_4 = linuxKernel.packages.linux_5_4;
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_6_1 = linuxKernel.packages.linux_6_1;
  linuxPackages_6_6 = linuxKernel.packages.linux_6_6;
  linuxPackages_6_9 = linuxKernel.packages.linux_6_9;
  linuxPackages_6_10 = linuxKernel.packages.linux_6_10;
  linuxPackages_6_11 = linuxKernel.packages.linux_6_11;
  linuxPackages_6_12 = linuxKernel.packages.linux_6_12;
  linuxPackages_6_13 = linuxKernel.packages.linux_6_13;
  linuxPackages_6_14 = linuxKernel.packages.linux_6_14;
  linuxPackages_6_15 = linuxKernel.packages.linux_6_15;
  linuxPackages_6_16 = linuxKernel.packages.linux_6_16;
  linuxPackages_ham = linuxKernel.packages.linux_ham;
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
  linux_4_19 = linuxKernel.kernels.linux_4_19;
  linux_5_4 = linuxKernel.kernels.linux_5_4;
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_6_1 = linuxKernel.kernels.linux_6_1;
  linux_6_6 = linuxKernel.kernels.linux_6_6;
  linux_6_9 = linuxKernel.kernels.linux_6_9;
  linux_6_10 = linuxKernel.kernels.linux_6_10;
  linux_6_11 = linuxKernel.kernels.linux_6_11;
  linux_6_12 = linuxKernel.kernels.linux_6_12;
  linux_6_13 = linuxKernel.kernels.linux_6_13;
  linux_6_14 = linuxKernel.kernels.linux_6_14;
  linux_6_15 = linuxKernel.kernels.linux_6_15;
  linux_6_16 = linuxKernel.kernels.linux_6_16;
  linux_ham = linuxKernel.kernels.linux_ham;
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
  linuxPackages_6_13_hardened = linuxKernel.packages.linux_6_13_hardened;
  linux_6_13_hardened = linuxKernel.kernels.linux_6_13_hardened;
  linuxPackages_6_14_hardened = linuxKernel.packages.linux_6_14_hardened;
  linux_6_14_hardened = linuxKernel.kernels.linux_6_14_hardened;
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

  # Added 2025-08-10
  linuxPackages_hardened = linuxKernel.packages.linux_hardened;
  linux_hardened = linuxPackages_hardened.kernel;
  linuxPackages_5_4_hardened = linuxKernel.packages.linux_5_4_hardened;
  linux_5_4_hardened = linuxKernel.kernels.linux_5_4_hardened;
  linuxPackages_5_10_hardened = linuxKernel.packages.linux_5_10_hardened;
  linux_5_10_hardened = linuxKernel.kernels.linux_5_10_hardened;
  linuxPackages_5_15_hardened = linuxKernel.packages.linux_5_15_hardened;
  linux_5_15_hardened = linuxKernel.kernels.linux_5_15_hardened;
  linuxPackages_6_1_hardened = linuxKernel.packages.linux_6_1_hardened;
  linux_6_1_hardened = linuxKernel.kernels.linux_6_1_hardened;
  linuxPackages_6_6_hardened = linuxKernel.packages.linux_6_6_hardened;
  linux_6_6_hardened = linuxKernel.kernels.linux_6_6_hardened;
  linuxPackages_6_12_hardened = linuxKernel.packages.linux_6_12_hardened;
  linux_6_12_hardened = linuxKernel.kernels.linux_6_12_hardened;

  linuxstopmotion = stopmotion; # Added 2024-11-01

  lixVersions = lixPackageSets.renamedDeprecatedLixVersions; # Added 2025-03-20, warning in ../tools/package-management/lix/default.nix

  llvmPackages_git = (callPackages ../development/compilers/llvm { }).git;

  loc = throw "'loc' has been removed due to lack of upstream maintenance. Consider 'tokei' as an alternative."; # Added 2025-01-25
  loco-cli = loco; # Added 2025-02-24
  loop = throw "'loop' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  ltwheelconf = throw "'ltwheelconf' has been removed because it is obsolete"; # Added 2025-05-07
  lucene = throw "lucene has been removed since it was both wildly out of date and was not even built properly for 4 years"; # Added 2025-04-10
  luci-go = throw "luci-go has been removed since it was unused and failing to build for 5 months"; # Added 2025-08-27
  lumail = throw "'lumail' has been removed since its upstream is unavailable"; # Added 2025-05-07
  lxd = lib.warnOnInstantiate "lxd has been renamed to lxd-lts" lxd-lts; # Added 2024-04-01

  lxde = {
    gtk2-x11 = throw "'lxde.gtk2-x11' has been removed. Use 'gtk2-x11' directly."; # added 2025-08-31
    lxappearance = throw "'lxappearance' has been moved to top-level. Use 'lxappearance' directly"; # added 2025-08-31
    lxappearance-gtk2 = throw "'lxappearance-gtk2' has been moved to top-level. Use 'lxappearance-gtk2' directly"; # added 2025-08-31
    lxmenu-data = throw "'lxmenu-data' has been moved to top-level. Use 'lxmenu-data' directly"; # added 2025-08-31
    lxpanel = throw "'lxpanel' has been moved to top-level. Use 'lxpanel' directly"; # added 2025-08-31
    lxrandr = throw "'lxrandr' has been moved to top-level. Use 'lxrandr' directly"; # added 2025-08-31
    lxsession = throw "'lxsession' has been moved to top-level. Use 'lxsession' directly"; # added 2025-08-31
    lxtask = throw "'lxtask' has been moved to top-level. Use 'lxtask' directly"; # added 2025-08-31
  };

  lxd-unwrapped = lib.warnOnInstantiate "lxd-unwrapped has been renamed to lxd-unwrapped-lts" lxd-unwrapped-lts; # Added 2024-04-01
  lxdvdrip = throw "'lxdvdrip' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  lzwolf = throw "'lzwolf' has been removed because it's no longer maintained upstream. Consider using 'ecwolf'"; # Added 2025-03-02

  ### M ###

  mac = monkeysAudio; # Added 2024-11-30
  MACS2 = macs2; # Added 2023-06-12
  magma_2_6_2 = throw "'magma_2_6_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  magma_2_7_2 = throw "'magma_2_7_2' has been removed, use the latest 'magma' package instead."; # Added 2025-07-20
  mailcore2 = throw "'mailcore2' has been removed due to lack of upstream maintenance."; # Added 2025-06-09
  mariadb_105 = throw "'mariadb_105' has been removed because it reached its End of Life. Consider upgrading to 'mariadb_106'."; # Added 2025-04-26
  mariadb-client = hiPrio mariadb.client; # added 2019.07.28
  manicode = throw "manicode has been renamed to codebuff"; # Added 2024-12-10
  manaplus = throw "manaplus has been removed, as it was broken"; # Added 2025-08-25
  manta = throw "manta does not support python3, and development has been abandoned upstream"; # Added 2025-03-17
  manticore = throw "manticore is no longer maintained since 2020, and doesn't build since smlnj-110.99.7.1"; # Added 2025-05-17

  maple-mono-NF = throw ''
    maple-mono-NF had been moved to maple-mono.NF.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  ''; # Added 2025-03-18
  maple-mono-otf = throw ''
    maple-mono-otf had been moved to maple-mono.opentype.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  ''; # Added 2025-03-18
  maple-mono-woff2 = throw ''
    maple-mono-woff2 had been moved to maple-mono.woff2.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  ''; # Added 2025-03-18
  maple-mono-SC-NF = throw ''
    mono-SC-NF had been superseded by maple-mono.NF-CN.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  ''; # Added 2025-03-18
  maple-mono-autohint = throw ''
    maple-mono-autohint had been moved to maple-mono.truetype-autohint.
    for installing all maple-mono:
      fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.maple-mono)
  ''; # Added 2025-03-18

  mapmap = throw "'mapmap' has been removed as it has been unmaintained since 2021"; # Added 2025-05-17
  markets = throw "'markets' has been removed as it was archived upstream in 2023"; # Added 2025-04-17
  marwaita-manjaro = lib.warnOnInstantiate "marwaita-manjaro has been renamed to marwaita-teal" marwaita-teal; # Added 2024-07-08
  marwaita-peppermint = lib.warnOnInstantiate "marwaita-peppermint has been renamed to marwaita-red" marwaita-red; # Added 2024-07-01
  marwaita-ubuntu = lib.warnOnInstantiate "marwaita-ubuntu has been renamed to marwaita-orange" marwaita-orange; # Added 2024-07-08
  marwaita-pop_os = lib.warnOnInstantiate "marwaita-pop_os has been renamed to marwaita-yellow" marwaita-yellow; # Added 2024-10-29
  material-kwin-decoration = throw "'material-kwin-decoration' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  mathlibtools = throw "mathlibtools has been removed as it was archived upstream in 2023"; # Added 2025-07-09
  matomo_5 = matomo; # Added 2024-12-12
  matomo-beta = throw "matomo-beta has been removed as it mostly just pointed to the latest matomo release, use `matomo.overrideAttrs` to access a specific beta version instead"; # Added 2025-01-15
  matrix-synapse-tools = recurseIntoAttrs {
    rust-synapse-compress-state = lib.warnOnInstantiate "`matrix-synapse-tools.rust-synapse-compress-state` has been renamed to `rust-synapse-compress-state`" rust-synapse-compress-state;
    synadm = lib.warnOnInstantiate "`matrix-synapse-tools.synadm` has been renamed to `synadm`" synadm;
  }; # Added 2025-02-20
  mcomix3 = mcomix; # Added 2022-06-05
  mdt = md-tui; # Added 2024-09-03
  microcodeAmd = microcode-amd; # Added 2024-09-08
  microcodeIntel = microcode-intel; # Added 2024-09-08
  micropad = throw "micropad has been removed, since it was unmaintained and blocked the Electron 27 removal."; # Added 2025-02-24
  microsoft_gsl = microsoft-gsl; # Added 2023-05-26
  midori = throw "'midori' original project has been abandonned upstream and the package was broken for a while in nixpkgs"; # Added 2025-05-19
  midori-unwrapped = midori; # Added 2025-05-19
  MIDIVisualizer = midivisualizer; # Added 2024-06-12
  mihomo-party = throw "'mihomo-party' has been removed due to upstream license violation"; # Added 2025-08-20
  mime-types = mailcap; # Added 2022-01-21
  minecraft = throw "'minecraft' has been removed because the package was broken. Consider using 'prismlauncher' instead"; # Added 2025-09-06
  minetest = luanti; # Added 2024-11-11
  minetestclient = luanti-client; # Added 2024-11-11
  minetestserver = luanti-server; # Added 2024-11-11
  minetest-touch = luanti-client; # Added 2024-08-12
  minizip2 = pkgs.minizip-ng; # Added 2022-12-28
  miru = throw "'miru' has been removed due to lack maintenance"; # Added 2025-08-21
  mmsd = throw "'mmsd' has been removed due to being unmaintained upstream. Consider using 'mmsd-tng' instead"; # Added 2025-06-07
  mmutils = throw "'mmutils' has been removed due to being unmaintained upstream"; # Added 2025-08-29
  mono-addins = throw "mono-addins has been removed due to its dependency on the removed mono4. Consider alternative frameworks or migrate to newer .NET technologies."; # Added 2025-08-25
  mono4 = mono6; # Added 2025-08-25
  mono5 = mono6; # Added 2025-08-25
  mongodb-6_0 = throw "mongodb-6_0 has been removed, it's end of life since July 2025"; # Added 2025-07-23
  moralerspace-nf = throw "moralerspace-nf has been removed, use moralerspace instead."; # Added 2025-08-30
  moralerspace-hwnf = throw "moralerspace-hwnf has been removed, use moralerspace-hw instead."; # Added 2025-08-30
  moz-phab = mozphab; # Added 2022-08-09
  mp3splt = throw "'mp3splt' has been removed due to lack of maintenance upstream."; # Added 2025-05-17
  mpc-cli = mpc; # Added 2024-10-14
  mpc_cli = mpc; # Added 2024-10-14
  mpdWithFeatures = lib.warnOnInstantiate "mpdWithFeatures has been replaced by mpd.override" mpd.override; # Added 2025-08-08
  mpdevil = plattenalbum; # Added 2024-05-22
  mq-cli = throw "'mq-cli' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  mrkd = throw "'mrkd' has been removed as it is unmaintained since 2021"; # Added 2024-12-21
  msp430NewlibCross = msp430Newlib; # Added 2024-09-06
  mumps_par = lib.warnOnInstantiate "mumps_par has been renamed to mumps-mpi" mumps-mpi; # Added 2025-05-07
  music-player = throw "'music-player' has been removed due to lack of maintenance upstream. Consider using 'fum' or 'termusic' instead."; # Added 2025-05-02
  mustache-tcl = tclPackages.mustache-tcl; # Added 2024-10-02
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mx-puppet-discord = throw "mx-puppet-discord was removed since the packaging was unmaintained and was the sole user of sha1 hashes in nixpkgs"; # Added 2025-07-24
  mysql-client = hiPrio mariadb.client;

  ### N ###

  namazu = throw "namazu has been removed, as it was broken"; # Added 2025-08-25
  ncdu_2 = ncdu; # Added 2022-07-22
  neocities-cli = neocities; # Added 2024-07-31
  neocomp = throw "neocomp has been remove because it fails to build and was unmaintained upstream"; # Added 2025-04-28
  netbox_3_7 = throw "netbox 3.7 series has been removed as it was EOL"; # Added 2025-04-23
  nettools = net-tools; # Added 2025-06-11
  newt-go = fosrl-newt; # Added 2025-06-24
  notify-sharp = throw "'notify-sharp' has been removed as it was unmaintained and depends on deprecated dbus-sharp versions"; # Added 2025-08-25
  nextcloud29 = throw ''
    Nextcloud v29 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2025-04. Please upgrade to at least Nextcloud v30 by declaring

        services.nextcloud.package = pkgs.nextcloud30;

    in your NixOS config.

    WARNING: if you were on Nextcloud 28 you have to upgrade to Nextcloud 29
    first on 24.11 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2025-04-11
  nextcloud29Packages = throw "Nextcloud 29 is EOL!"; # Added 2025-04-11
  nextcloud28 = throw ''
    Nextcloud v28 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2025-01. Please upgrade to at least Nextcloud v29 by declaring

        services.nextcloud.package = pkgs.nextcloud29;

    in your NixOS config.

    WARNING: if you were on Nextcloud 27 you have to upgrade to Nextcloud 28
    first on 24.11 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2025-01-19
  nextcloud28Packages = throw "Nextcloud 28 is EOL!"; # Added 2025-01-19
  nextcloud27 = throw ''
    Nextcloud v27 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2024-06. Please upgrade to at least Nextcloud v28 by declaring

        services.nextcloud.package = pkgs.nextcloud28;

    in your NixOS config.

    WARNING: if you were on Nextcloud 26 you have to upgrade to Nextcloud 27
    first on 24.05 because Nextcloud doesn't support upgrades across multiple major versions!
  ''; # Added 2024-06-25
  nextcloud-news-updater = throw "nextcloud-news-updater has been removed because the project is unmaintained"; # Added 2025-03-28
  nixForLinking = throw "nixForLinking has been removed, use `nixVersions.nixComponents_<version>` instead"; # Added 2025-08-14
  nagiosPluginsOfficial = monitoring-plugins;
  neochat = makePlasma5Throw "neochat"; # added 2022-05-10
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
  networkmanager_strongswan = networkmanager-strongswan; # added 2025-06-29
  newlibCross = newlib; # Added 2024-09-06
  newlib-nanoCross = newlib-nano; # Added 2024-09-06
  nfstrace = throw "nfstrace has been removed, as it was broken"; # Added 2025-08-25
  nix-direnv-flakes = nix-direnv;
  nix-ld-rs = nix-ld; # Added 2024-08-17
  nix-linter = throw "nix-linter has been removed as it was broken for 3 years and unmaintained upstream"; # Added 2025-09-06
  nix-plugin-pijul = throw "nix-plugin-pijul has been removed due to being discontinued"; # added 2025-05-18
  nixStable = nixVersions.stable; # Added 2022-01-24
  nix_2_3 = throw "'nix_2_3' has been removed, because it was unmaintained and insecure."; # Converted to throw 2025-07-24
  nixfmt-rfc-style =
    if lib.oldestSupportedReleaseIsAtLeast 2511 then
      lib.warnOnInstantiate
        "nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead."
        nixfmt # Added 2025-07-14
    else
      nixfmt;

  # When the nixops_unstable alias is removed, nixops_unstable_minimal can be renamed to nixops_unstable.

  nixosTest = testers.nixosTest; # Added 2022-05-05
  nm-tray = throw "'nm-tray' has been removed, as it only works with Plasma 5"; # Added 2025-08-30
  noah = throw "'noah' has been removed because it was broken and its upstream archived"; # Added 2025-05-10
  nodejs_18 = throw "Node.js 18.x has reached End-Of-Life and has been removed"; # Added 2025-04-23
  nodejs-slim_18 = nodejs_18; # Added 2025-04-23
  corepack_18 = nodejs_18; # Added 2025-04-23
  nodejs-18_x = nodejs_18; # Added 2022-11-06
  nodejs-slim-18_x = nodejs-slim_18; # Added 2022-11-06
  nomacs-qt6 = nomacs; # Added 2025-08-30
  nomad_1_4 = throw "nomad_1_4 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-02-02
  nomad_1_5 = throw "nomad_1_5 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-02-02
  nomad_1_6 = throw "nomad_1_6 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-02-02
  nomad_1_7 = throw "nomad_1_7 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-03-27
  nomad_1_8 = throw "nomad_1_8 is no longer supported upstream. You can switch to using a newer version of the nomad package, or revert to older nixpkgs if you cannot upgrade"; # Added 2025-03-27
  noto-fonts-emoji = noto-fonts-color-emoji; # Added 2023-09-09
  noto-fonts-extra = noto-fonts; # Added 2023-04-08
  NSPlist = nsplist; # Added 2024-01-05
  nuget-to-nix = throw "nuget-to-nix has been removed as it was deprecated in favor of nuget-to-json. Please use nuget-to-json instead"; # Added 2025-08-28
  nushellFull = lib.warnOnInstantiate "`nushellFull` has has been replaced by `nushell` as its features no longer exist" nushell; # Added 2024-05-30
  nux = throw "nux has been removed because it has been abandoned for 4 years"; # Added 2025-03-22

  ### O ###

  o = orbiton; # Added 2023-04-09
  oathToolkit = oath-toolkit; # Added 2022-04-04
  obliv-c = throw "obliv-c has been removed from Nixpkgs, as it has been unmaintained upstream for 4 years and does not build with supported GCC versions"; # Added 2025-08-18
  ocis-bin = throw "ocis-bin has been renamed to ocis_5-bin'. Future major.minor versions will be made available as separate packages"; # Added 2025-03-30
  odoo15 = throw "odoo15 has been removed from nixpkgs as it is unsupported; migrate to a newer version of odoo"; # Added 2025-05-06
  offrss = throw "offrss has been removed due to lack of upstream maintenance; consider using another rss reader"; # Added 2025-06-01
  oil = lib.warnOnInstantiate "Oil has been replaced with the faster native C++ version and renamed to 'oils-for-unix'. See also https://github.com/oils-for-unix/oils/wiki/Oils-Deployments" oils-for-unix; # Added 2024-10-22
  oneDNN_2 = throw "oneDNN_2 has been removed as it was only used by rocmPackages.migraphx"; # added 2025-07-18
  onevpl-intel-gpu = lib.warnOnInstantiate "onevpl-intel-gpu has been renamed to vpl-gpu-rt" vpl-gpu-rt; # Added 2024-06-04
  openai-triton-llvm = triton-llvm; # added 2024-07-18
  openai-whisper-cpp = whisper-cpp; # Added 2024-12-13
  openafs_1_8 = openafs; # Added 2022-08-22
  openconnect_gnutls = openconnect; # Added 2022-03-29
  openexr_3 = openexr; # Added 2025-03-12
  openimageio2 = openimageio; # Added 2023-01-05
  oobicpl = throw "oobicpl was removed as it is unmaintained upstream"; # Added 2025-04-26
  opensmtpd-extras = throw "opensmtpd-extras has been removed in favor of separate opensmtpd-table-* packages"; # Added 2025-01-26
  openssl_3_0 = openssl_3; # Added 2022-06-27
  opensycl = lib.warnOnInstantiate "'opensycl' has been renamed to 'adaptivecpp'" adaptivecpp; # Added 2024-12-04
  opensyclWithRocm = lib.warnOnInstantiate "'opensyclWithRocm' has been renamed to 'adaptivecppWithRocm'" adaptivecppWithRocm; # Added 2024-12-04
  open-timeline-io = lib.warnOnInstantiate "'open-timeline-io' has been renamed to 'opentimelineio'" opentimelineio; # Added 2025-08-10
  opentofu-ls = lib.warnOnInstantiate "'opentofu-ls' has been renamed to 'tofu-ls'" tofu-ls; # Added 2025-06-10
  openvdb_11 = throw "'openvdb_11' has been removed in favor of the latest version'"; # Added 2025-05-03
  opera = throw "'opera' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-05-19
  omping = throw "'omping' has been removed because its upstream has been archived"; # Added 2025-05-10
  onlyoffice-bin = onlyoffice-desktopeditors; # Added 2024-09-20
  onlyoffice-bin_latest = onlyoffice-bin; # Added 2024-07-03
  OSCAR = oscar; # Added 2024-06-12
  overrideSDK = "overrideSDK has been removed as it was a legacy compatibility stub. See <https://nixos.org/manual/nixpkgs/stable/#sec-darwin-legacy-frameworks-overrides> for migration instructions"; # Added 2025-08-04
  oxygen-icons5 = throw ''
    The top-level oxygen-icons5 alias has been removed.

    Please explicitly use kdePackages.oxygen-icons for the latest Qt 6-based version,
    or libsForQt5.oxygen-icons5 for the deprecated Qt 5 version.

    Note that Qt 5 versions of most KDE software will be removed in NixOS 25.11.
  ''; # Added 2025-03-15;

  ### P ###

  pax-rs = throw "'pax-rs' has been removed because upstream has disappeared"; # Added 2025-01-25
  PageEdit = pageedit; # Added 2024-01-21
  passky-desktop = throw "passky-desktop has been removed, as it was unmaintained and blocking the Electron 29 removal."; # Added 2025-02-24
  paco = throw "'paco' has been removed as it has been abandoned"; # Added 2025-04-30
  inherit (perlPackages) pacup;
  pal = throw "pal has been removed, as it was broken"; # Added 2025-08-25
  panopticon = throw "'panopticon' has been removed because it is unmaintained upstream"; # Added 2025-01-25
  pathsFromGraph = throw "pathsFromGraph has been removed, use closureInfo instead"; # Added 2025-01-23
  paperless-ng = paperless-ngx; # Added 2022-04-11
  partition-manager = makePlasma5Throw "partitionmanager"; # Added 2024-01-08
  patchelfStable = patchelf; # Added 2024-01-25
  paup = paup-cli; # Added 2024-09-11
  pcre16 = throw "'pcre16' has been removed because it is obsolete. Consider migrating to 'pcre2' instead."; # Added 2025-05-29
  pcsctools = pcsc-tools; # Added 2023-12-07
  pdf4tcl = tclPackages.pdf4tcl; # Added 2024-10-02
  pds = lib.warnOnInstantiate "'pds' has been renamed to 'bluesky-pds'" bluesky-pds; # Added 2025-08-20
  pdsadmin = lib.warnOnInstantiate "'pdsadmin' has been renamed to 'bluesky-pdsadmin'" bluesky-pdsadmin; # Added 2025-08-20
  peach = asouldocs; # Added 2022-08-28
  percona-server_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-server; # Added 2024-10-13
  percona-server_lts = percona-server; # Added 2024-10-13
  percona-xtrabackup_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-xtrabackup; # Added 2024-10-13
  percona-xtrabackup_lts = percona-xtrabackup; # Added 2024-10-13
  peroxide = throw "'peroxide' has been dropped due to lack of upstream maintenance."; # Added 2025-03-31
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  peruse = throw "'peruse' has been removed as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  pgadmin = pgadmin4;
  pharo-spur64 = pharo; # Added 2022-08-03
  phlare = throw "'phlare' has been removed as the upstream project was archived."; # Added 2025-03-27
  picom-next = picom; # Added 2024-02-13
  pilipalax = throw "'pilipalax' has been removed from nixpkgs due to it not being maintained"; # Added 2025-07-25
  pio = throw "pio has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  platformioPackages = {
    inherit
      platformio-core
      platformio-chrootenv
      ;
  }; # Added 2025-09-04
  platypus = throw "platypus is unmaintained and has not merged Python3 support"; # Added 2025-03-20
  plex-media-player = throw "'plex-media-player' has been discontinued, the new official client is available as 'plex-desktop'"; # Added 2025-05-28
  plots = throw "'plots' has been replaced by 'gnome-graphs'"; # Added 2025-02-05
  pltScheme = racket; # just to be sure
  poac = cabinpkg; # Added 2025-01-22
  podofo010 = podofo_0_10; # Added 2025-06-01
  polkit-kde-agent = throw ''
    The top-level polkit-kde-agent alias has been removed.

    Please explicitly use kdePackages.polkit-kde-agent-1 for the latest Qt 6-based version,
    or libsForQt5.polkit-kde-agent for the deprecated Qt 5 version.

    Note that Qt 5 versions of most KDE software will be removed in NixOS 25.11.
  ''; # Added 2025-03-07
  polypane = throw "'polypane' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-25
  powerdns = pdns; # Added 2022-03-28
  preserves-nim = throw "'preserves-nim' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01

  cstore_fdw = throw "'cstore_fdw' has been removed. Use 'postgresqlPackages.cstore_fdw' instead."; # Added 2025-07-19
  pg_cron = throw "'pg_cron' has been removed. Use 'postgresqlPackages.pg_cron' instead."; # Added 2025-07-19
  pg_hll = throw "'pg_hll' has been removed. Use 'postgresqlPackages.pg_hll' instead."; # Added 2025-07-19
  pg_repack = throw "'pg_repack' has been removed. Use 'postgresqlPackages.pg_repack' instead."; # Added 2025-07-19
  pg_similarity = throw "'pg_similarity' has been removed. Use 'postgresqlPackages.pg_similarity' instead."; # Added 2025-07-19
  pg_topn = throw "'pg_topn' has been removed. Use 'postgresqlPackages.pg_topn' instead."; # Added 2025-07-19
  pgf1 = throw "'pgf1' has been removed since it is unmaintained. Consider using 'pgf' instead"; # Added 2025-05-10
  pgjwt = throw "'pgjwt' has been removed. Use 'postgresqlPackages.pgjwt' instead."; # Added 2025-07-19
  pgroonga = throw "'pgroonga' has been removed. Use 'postgresqlPackages.pgroonga' instead."; # Added 2025-07-19
  pgtap = throw "'pgtap' has been removed. Use 'postgresqlPackages.pgtap' instead."; # Added 2025-07-19
  plv8 = throw "'plv8' has been removed. Use 'postgresqlPackages.plv8' instead."; # Added 2025-07-19
  postcss-cli = throw "postcss-cli has been removed because it was broken"; # added 2025-03-24
  postgis = throw "'postgis' has been removed. Use 'postgresqlPackages.postgis' instead."; # Added 2025-07-19
  timescaledb = throw "'timescaledb' has been removed. Use 'postgresqlPackages.timescaledb' instead."; # Added 2025-07-19
  thrust = throw "'thrust' has been removed due to lack of maintenance"; # Added 2025-08-21
  tsearch_extras = throw "'tsearch_extras' has been removed from nixpkgs"; # Added 2024-12-15

  # Ever since building with JIT by default, those are the same.
  postgresqlJitPackages = postgresqlPackages; # Added 2025-04-12
  postgresql13JitPackages = postgresql13Packages; # Added 2025-04-12
  postgresql14JitPackages = postgresql14Packages; # Added 2025-04-12
  postgresql15JitPackages = postgresql15Packages; # Added 2025-04-12
  postgresql16JitPackages = postgresql16Packages; # Added 2025-04-12
  postgresql17JitPackages = postgresql17Packages; # Added 2025-04-12

  # pinentry was using multiple outputs, this emulates the old interface for i.e. home-manager
  # soon: throw "'pinentry' has been removed. Pick an appropriate variant like 'pinentry-curses' or 'pinentry-gnome3'";
  pinentry = pinentry-all // {
    curses = pinentry-curses;
    emacs = pinentry-emacs;
    gnome3 = pinentry-gnome3;
    gtk2 = pinentry-gtk2;
    qt = pinentry-qt;
    tty = pinentry-tty;
    flavors = [
      "curses"
      "emacs"
      "gnome3"
      "gtk2"
      "qt"
      "tty"
    ];
  }; # added 2024-01-15

  plasma-applet-volumewin7mixer = throw "'plasma-applet-volumewin7mixer' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  plasma-pass = throw "'plasma-pass' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  plasma-theme-switcher = throw "'plasma-theme-switcher' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  PlistCpp = plistcpp; # Added 2024-01-05
  pocket-updater-utility = pupdate; # Added 2024-01-25
  polipo = throw "'polipo' has been removed as it is unmaintained upstream"; # Added 2025-05-18
  poppler_utils = poppler-utils; # Added 2025-02-27
  powerline-rs = throw "'powerline-rs' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  premake3 = throw "'premake3' has been removed since it is unmaintained. Consider using 'premake' instead"; # Added 2025-05-10
  private-gpt = throw "'private-gpt' has been removed from nixpkgs, as it was broken and unmaintained"; # Added 2025-07-28
  probe-rs = probe-rs-tools; # Added 2024-05-23
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-dovecot-exporter = dovecot_exporter; # Added 2024-06-10
  protobuf_23 = throw "'protobuf_23' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-04-20
  protobuf_24 = throw "'protobuf_24' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-07-14
  protobuf_26 = throw "'protobuf_26' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-29
  protobuf_28 = throw "'protobuf_28' has been removed from nixpkgs. Consider using a more recent version of the protobuf library"; # Added 2025-06-14
  protobuf3_24 = protobuf_24;
  protobuf3_23 = protobuf_23;
  protobuf3_21 = protobuf_21;
  protoc-gen-connect-es = throw "'protoc-gen-connect-es' has been removed because it is deprecated upstream. Functionality has been integrated into 'protoc-gen-es' v2."; # Added 2025-02-18
  protonup = protonup-ng; # Added 2022-11-06
  proton-vpn-local-agent = lib.warnOnInstantiate "'proton-vpn-local-agent' has been renamed to 'python3Packages.proton-vpn-local-agent'" (
    python3Packages.toPythonApplication python3Packages.proton-vpn-local-agent
  ); # Added 2025-04-23
  proxmark3-rrg = proxmark3; # Added 2023-07-25
  psstop = throw "'psstop' has been removed because the upstream repo has been archived"; # Added 2025-05-10
  ptask = throw "'ptask' has been removed because its upstream is unavailable"; # Added 2025-05-10
  purple-signald = throw "'purple-signald' has been removed due to lack of upstream maintenance"; # Added 2025-05-17
  pwndbg = throw "'pwndbg' has been removed due to dependency version incompatibilities that are infeasible to maintain in nixpkgs. Use the downstream flake that pwndbg provides instead: https://github.com/pwndbg/pwndbg"; # Added 2025-02-09
  pxlib = throw "pxlib has been removed due to failing to build and lack of upstream maintenance"; # Added 2025-04-28
  pxview = throw "pxview has been removed due to failing to build and lack of upstream maintenance"; # Added 2025-04-28
  pynac = throw "'pynac' has been removed as it was broken and unmaintained"; # Added 2025-03-18
  pyo3-pack = maturin;
  pypolicyd-spf = spf-engine; # Added 2022-10-09
  pypy39Packages = throw "pypy 3.9 has been removed, use pypy 3.10 instead"; # Added 2025-01-07
  python = python2; # Added 2022-01-11
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11
  pypy39 = throw "pypy 3.9 has been removed, use pypy 3.10 instead"; # Added 2025-01-03

  ### Q ###

  qcachegrind = throw "'qcachegrind' has been removed, as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  qflipper = qFlipper; # Added 2022-02-11
  qnial = throw "'qnial' has been removed due to failing to build and being unmaintained"; # Added 2025-06-26
  qscintilla = libsForQt5.qscintilla; # Added 2023-09-20
  qscintilla-qt6 = qt6Packages.qscintilla; # Added 2023-09-20
  qt-video-wlr = throw "'qt-video-wlr' has been removed, as it depends on KDE Gear 5, which has reached EOL"; # Added 2025-08-20
  qt515 = qt5; # Added 2022-11-24
  qt6ct = qt6Packages.qt6ct; # Added 2023-03-07
  qtchan = throw "'qtchan' has been removed due to lack of maintenance upstream"; # Added 2025-07-01
  qtile-unwrapped = python3.pkgs.qtile; # Added 2023-05-12
  quantum-espresso-mpi = quantum-espresso; # Added 2023-11-23
  quaternion-qt5 = throw "'quaternion-qt5' has been removed as quaternion dropped Qt5 support with v0.0.97.1"; # Added 2025-05-24
  quickbms = throw "'quickbms' has been removed due to being unmaintained for many years."; # Added 2025-05-17
  quickserve = throw "'quickserve' has been removed because its upstream is unavailable"; # Added 2025-05-10
  quicksynergy = throw "'quicksynergy' has been removed due to lack of maintenance upstream. Consider using 'deskflow' instead."; # Added 2025-06-18
  qv2ray = throw "'qv2ray' has been removed as it was unmaintained"; # Added 2025-06-03

  ### R ###

  rabbitmq-java-client = throw "rabbitmq-java-client has been removed due to its dependency on Python2 and a lack of maintenance within the nixpkgs tree"; # Added 2025-03-29
  racket_7_9 = throw "Racket 7.9 has been removed because it is insecure. Consider using 'racket' instead."; # Added 2024-12-06
  radicale3 = radicale; # Added 2024-11-29
  railway-travel = diebahn; # Added 2024-04-01
  rambox-pro = rambox; # Added 2022-12-12
  rapidjson-unstable = lib.warnOnInstantiate "'rapidjson-unstable' has been renamed to 'rapidjson'" rapidjson; # Added 2024-07-28
  rargs = throw "'rargs' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  rebazel = throw "'rebazel' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  redocly-cli = redocly; # Added 2024-04-14
  redpanda = redpanda-client; # Added 2023-10-14
  retroarchBare = retroarch-bare; # Added 2024-11-23
  retroarchFull = retroarch-full; # Added 2024-11-23
  retroshare06 = retroshare;
  rewind-ai = throw "'rewind-ai' has been removed due to lack of of maintenance upstream"; # Added 2025-08-03
  responsively-app = throw "'responsively-app' has been removed due to lack of maintainance upstream."; # Added 2025-06-25
  rftg = throw "'rftg' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  rigsofrods = rigsofrods-bin; # Added 2023-03-22
  riko4 = throw "'riko4' has been removed as it was unmaintained, failed to build and dependend on outdated libraries"; # Added 2025-05-18
  river = throw "'river' has been renamed to/replaced by 'river-classic'"; # Added 2025-08-30
  rke2_1_29 = throw "'rke2_1_29' has been removed from nixpkgs as it has reached end of life"; # Added 2025-05-05
  rke2_testing = throw "'rke2_testing' has been removed from nixpkgs as the RKE2 testing channel no longer serves releases"; # Added 2025-06-02
  rl_json = tclPackages.rl_json; # Added 2025-05-03
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rocmPackages_5 = throw "ROCm 5 has been removed in favor of newer versions"; # Added 2025-02-18
  root5 = throw "root5 has been removed from nixpkgs because it's a legacy version"; # Added 2025-07-17
  rnix-hashes = throw "'rnix-hashes' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  rr-unstable = rr; # Added 2022-09-17
  rtx = mise; # Added 2024-01-05
  runCommandNoCC = runCommand;
  runCommandNoCCLocal = runCommandLocal;
  run-scaled = throw "run-scaled has been removed due to being deprecated. Consider using run_scaled from 'xpra' instead"; # Added 2025-03-17
  rust-synapse-state-compress = rust-synapse-compress-state;
  rustc-wasm32 = rustc; # Added 2023-12-01
  rustfilt = throw "'rustfilt' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  rustic-rs = rustic; # Added 2024-08-02
  ryujinx = throw "'ryujinx' has been replaced by 'ryubing' as the new upstream"; # Added 2025-07-30
  ryujinx-greemdev = ryubing; # Added 2025-01-20

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.

  ### S ###

  SDL_classic = SDL1; # Added 2024-09-03
  SDL1 = throw "'SDL1' has been removed as development ended long ago with SDL 2.0 replacing it, use SDL_compat instead"; # Added 2025-03-27
  SDL_gpu = throw "'SDL_gpu' has been removed due to lack of upstream maintenance and known users"; # Added 2025-03-15
  SDL_image_2_0 = throw "'SDL_image_2_0' has been removed in favor of the latest version"; # Added 2025-04-20
  SDL2_mixer_2_0 = throw "'SDL2_mixer_2_0' has been removed in favor of the latest version"; # Added 2025-04-27
  SDL2_classic = throw "'SDL2_classic' has been removed. Consider upgrading to 'sdl2-compat', also available as 'SDL2'."; # Added 2025-05-20
  SDL2_classic_image = throw "'SDL2_classic_image' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_image' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_mixer_2_0 = throw "'SDL2_classic_mixer_2_0' has been removed in favor of the latest version"; # Added 2025-04-27
  SDL2_classic_mixer = throw "'SDL2_classic_mixer' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_mixer' built with 'sdl2-compat'."; # Added 2025-05-20
  SDL2_classic_ttf = throw "'SDL2_classic_ttf' has been removed as part of the deprecation of 'SDL2_classic'. Consider upgrading to 'SDL2_ttf' built with 'sdl2-compat'."; # Added 2025-05-20
  samtools_0_1_19 = throw "'samtools_0_1_19' has been removed because it is unmaintained. Consider using 'samtools' instead"; # Added 2025-05-10
  scantailor = scantailor-advanced; # Added 2022-05-26
  schildichat-web = throw ''
    schildichat has been removed as it is severely lacking behind the Element upstream and does not receive regular security fixes.
    Please participate in upstream discussion on getting out new releases:
    https://github.com/SchildiChat/schildichat-desktop/issues/212
    https://github.com/SchildiChat/schildichat-desktop/issues/215''; # Added 2023-12-05
  schildichat-desktop = schildichat-web;
  schildichat-desktop-wayland = schildichat-web;
  scitoken-cpp = scitokens-cpp; # Added 2024-02-12
  scry = throw "'scry' has been removed as it was archived upstream. Use 'crystalline' instead"; # Added 2025-02-12
  scudcloud = throw "'scudcloud' has been removed as it was archived by upstream"; # Added 2025-07-24
  seafile-server = throw "'seafile-server' has been removed as it is unmaintained"; # Added 2025-08-21
  seahub = throw "'seahub' has been removed as it is unmaintained"; # Added 2025-08-21
  serial-unit-testing = throw "'serial-unit-testing' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  serious-sans = throw "'serious-sans' has been renamed to 'serious-shanns', which is not currently packaged"; # Added 2025-01-26
  session-desktop-appimage = session-desktop;
  setserial = throw "'setserial' has been removed as it had been abandoned upstream"; # Added 2025-05-18
  sequoia = sequoia-sq; # Added 2023-06-26
  sexp = sexpp; # Added 2023-07-03
  sgrep = throw "'sgrep' has been removed as it was unmaintained upstream since 1998 and broken with gcc 14"; # Added 2025-05-17
  shallot = throw "'shallot' has been removed as it is broken and the upstream repository was removed. Consider using 'mkp224o'"; # Added 2025-03-16
  shell-hist = throw "'shell-hist' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  shipyard = jumppad; # Added 2023-06-06
  siduck76-st = st-snazzy; # Added 2024-12-24
  sierra-breeze-enhanced = throw "'sierra-breeze-enhanced' has been removed, as it is only compatible with Plasma 5, which is EOL"; # Added 2025-08-20
  signald = throw "'signald' has been removed due to lack of upstream maintenance"; # Added 2025-05-17
  signaldctl = throw "'signaldctl' has been removed due to lack of upstream maintenance"; # Added 2025-05-17
  signal-desktop-source = lib.warnOnInstantiate "'signal-desktop-source' is now exposed at 'signal-desktop'." signal-desktop; # Added 2025-04-16
  silc_server = throw "'silc_server' has been removed because it is unmaintained"; # Added 2025-05-12
  silc_client = throw "'silc_client' has been removed because it is unmaintained"; # Added 2025-05-12
  siproxd = throw "'siproxd' has been removed as it was unmaintained and incompatible with newer libosip versions"; # Added 2025-05-18
  sisco.lv2 = throw "'sisco.lv2' has been removed as it was unmaintained and broken"; # Added 2025-08-26
  sheesy-cli = throw "'sheesy-cli' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  shout = nodePackages.shout; # Added unknown; moved 2024-10-19
  SkypeExport = skypeexport; # Added 2024-06-12
  skypeforlinux = throw "Skype has been shut down in May 2025"; # Added 2025-05-05
  sladeUnstable = slade-unstable; # Added 2025-08-26
  slic3r = throw "'slic3r' has been removed because it is unmaintained"; # Added 2025-08-26
  slimerjs = throw "slimerjs does not work with any version of Firefox newer than 59; upstream ended the project in 2021. <https://slimerjs.org/faq.html#end-of-development>"; # added 2025-01-06
  sloccount = throw "'sloccount' has been removed because it is unmaintained. Consider migrating to 'loccount'"; # added 2025-05-17
  slrn = throw "'slrn' has been removed because it is unmaintained upstream and broken."; # Added 2025-06-11
  slurm-llnl = slurm; # renamed July 2017
  smartgithg = smartgit; # renamed March 2025
  snort2 = throw "snort2 has been removed as it is deprecated and unmaintained by upstream. Consider using snort (snort3) package instead."; # 2025-05-21
  soldat-unstable = opensoldat; # Added 2022-07-02
  soulseekqt = throw "'soulseekqt' has been removed due to lack of maintenance in Nixpkgs in a long time. Consider using 'nicotine-plus' or 'slskd' instead."; # Added 2025-06-07
  soundkonverter = throw "'soundkonverter' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  soundOfSorting = sound-of-sorting; # Added 2023-07-07
  SP800-90B_EntropyAssessment = sp800-90b-entropyassessment; # Added on 2024-06-12
  SPAdes = spades; # Added 2024-06-12
  spark2014 = gnatprove; # Added 2024-02-25
  space-orbit = throw "'space-orbit' has been removed because it is unmaintained; Debian upstream stopped tracking it in 2011."; # Added 2025-06-08
  spatialite_gui = throw "spatialite_gui has been renamed to spatialite-gui"; # Added 2025-01-12
  spatialite_tools = throw "spatialite_tools has been renamed to spatialite-tools"; # Added 2025-02-06
  sonusmix = throw "'sonusmix' has been removed due to lack of maintenance"; # Added 2025-08-27

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

  sourcehut = throw "'sourcehut.*' has been removed due to being broken and unmaintained"; # Added 2025-06-15
  solana-validator = throw "'solana-validator' is obsoleted by solana-cli, which also includes the validator binary"; # Added 2024-12-20
  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spidermonkey_78 = throw "'spidermonkey_78' has been removed because it was unused."; # Added 2025-02-02
  spotify-unwrapped = spotify; # added 2022-11-06
  ssm-agent = amazon-ssm-agent; # Added 2023-10-17
  starpls-bin = starpls;
  station = throw "station has been removed from nixpkgs, as there were no committers among its maintainers to unblock security issues"; # added 2025-06-16
  steamPackages = {
    steam = lib.warnOnInstantiate "`steamPackages.steam` has been moved to top level as `steam-unwrapped`" steam-unwrapped;
    steam-fhsenv = lib.warnOnInstantiate "`steamPackages.steam-fhsenv` has been moved to top level as `steam`" steam;
    steam-fhsenv-small = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-small` has been moved to top level as `steam`. There is no longer a -small variant" steam;
    steamcmd = lib.warnOnInstantiate "`steamPackages.steamcmd` has been moved to top level as `steamcmd`" steamcmd;
  };
  steam-small = steam; # Added 2024-09-12
  steam-run-native = steam-run; # added 2022-02-21
  StormLib = stormlib; # Added 2024-01-21
  strawberry-qt5 = throw "strawberry-qt5 has been replaced by strawberry"; # Added 2024-11-22 and updated 2025-07-19
  strawberry-qt6 = throw "strawberry-qt6 has been replaced by strawberry"; # Added 2025-07-19
  strelka = throw "strelka depends on Python 2.6+, and does not support Python 3."; # Added 2025-03-17
  subberthehut = throw "'subberthehut' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  substituteAll = throw "`substituteAll` has been removed. Use `replaceVars` instead."; # Added 2025-05-23
  substituteAllFiles = throw "`substituteAllFiles` has been removed. Use `replaceVars` for each file instead."; # Added 2025-05-23
  suidChroot = throw "'suidChroot' has been dropped as it was unmaintained, failed to build and had questionable security considerations"; # Added 2025-05-17
  suitesparse_4_2 = throw "'suitesparse_4_2' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  suitesparse_4_4 = throw "'suitesparse_4_4' has been removed as it was unmaintained upstream"; # Added 2025-05-17
  sumaclust = throw "'sumaclust' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumalibs = throw "'sumalibs' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumatra = throw "'sumatra' has been removed as it was archived upstream and broken with GCC 14"; # Added 2025-06-14
  sumneko-lua-language-server = lua-language-server; # Added 2023-02-07
  supertag = throw "supertag has been removed as it was abandoned upstream and fails to build"; # Added 2025-04-20
  suyu = throw "suyu has been removed from nixpkgs, as it is subject to a DMCA takedown"; # Added 2025-05-12
  swiProlog = lib.warnOnInstantiate "swiProlog has been renamed to swi-prolog" swi-prolog; # Added 2024-09-07
  swiPrologWithGui = lib.warnOnInstantiate "swiPrologWithGui has been renamed to swi-prolog-gui" swi-prolog-gui; # Added 2024-09-07
  swig4 = swig; # Added 2024-09-12
  swt_jdk8 = throw "'swt_jdk8' has been removed due to being unused and broken for a long time"; # Added 2025-01-07
  Sylk = sylk; # Added 2024-06-12
  symbiyosys = sby; # Added 2024-08-18
  syn2mas = throw "'syn2mas' has been removed. It has been integrated into the main matrix-authentication-service CLI as a subcommand: 'mas-cli syn2mas'."; # Added 2025-07-07
  sync = taler-sync; # Added 2024-09-04
  syncthingtray-qt6 = syncthingtray; # Added 2024-03-06
  syncthing-tray = throw "syncthing-tray has been removed because it is broken and unmaintained"; # Added 2025-05-18
  syndicate_utils = throw "'syndicate_utils' has been removed due to a hostile upstream moving tags and breaking src FODs"; # Added 2025-09-01

  ### T ###

  t1lib = throw "'t1lib' has been removed as it was broken and unmaintained upstream."; # Added 2025-06-11
  taskwarrior = lib.warnOnInstantiate "taskwarrior was replaced by taskwarrior3, which requires manual transition from taskwarrior 2.6, read upstream's docs: https://taskwarrior.org/docs/upgrade-3/" taskwarrior2;
  taplo-cli = taplo; # Added 2022-07-30
  taplo-lsp = taplo; # Added 2022-07-30
  targetcli = targetcli-fb; # Added 2025-03-14
  taro = taproot-assets; # Added 2023-07-04
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
  tdom = tclPackages.tdom; # Added 2024-10-02
  teamspeak_client = teamspeak3; # Added 2024-11-07
  teamspeak5_client = teamspeak6-client; # Added 2025-01-29
  telepathy-gabble = throw "'telepathy-gabble' has been removed as it was unmaintained, unused, broken and used outdated libraries"; # Added 2025-04-20
  telepathy-logger = throw "'telepathy-logger' has been removed as it was unmaintained, unused and broken"; # Added 2025-04-20
  teleport_15 = throw "teleport 15 has been removed as it is EOL. Please upgrade to Teleport 16 or later"; # Added 2025-03-28
  temporalite = throw "'temporalite' has been removed as it is obsolete and unmaintained, please use 'temporal-cli' instead (with `temporal server start-dev`)"; # Added 2025-06-26
  terminus-nerdfont = lib.warnOnInstantiate "terminus-nerdfont is redundant. Use nerd-fonts.terminess-ttf instead." nerd-fonts.terminess-ttf; # Added 2024-11-10
  tepl = libgedit-tepl; # Added 2024-04-29
  termplay = throw "'termplay' has been removed due to lack of maintenance upstream"; # Added 2025-01-25
  testVersion = testers.testVersion; # Added 2022-04-20
  texinfo4 = throw "'texinfo4' has been removed in favor of the latest version"; # Added 2025-06-08
  tezos-rust-libs = ligo; # Added 2025-06-03
  tfplugindocs = terraform-plugin-docs; # Added 2023-11-01
  thiefmd = throw "'thiefmd' has been removed due to lack of maintenance upstream and incompatible with newer Pandoc. Please use 'apostrophe' or 'folio' instead"; # Added 2025-02-20
  thefuck = throw "'thefuck' has been removed due to lack of maintenance upstream and incompatible with python 3.12+. Consider using 'pay-respects' instead"; # Added 2025-05-30
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  tijolo = throw "'tijolo' has been removed due to being unmaintained"; # Added 2024-12-27
  timelens = throw "'timelens' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  tix = tclPackages.tix; # Added 2024-10-02
  tkcvs = tkrev; # Added 2022-03-07
  tkgate = throw "'tkgate' has been removed as it is unmaintained"; # Added 2025-05-17
  tkimg = tclPackages.tkimg; # Added 2024-10-02
  tlaplusToolbox = tlaplus-toolbox; # Added 2025-08-21
  todiff = throw "'todiff' was removed due to lack of known users"; # Added 2025-01-25
  tokyo-night-gtk = tokyonight-gtk-theme; # Added 2024-01-28
  tomcat_connectors = apacheHttpdPackages.mod_jk; # Added 2024-06-07
  ton = throw "'ton' has been removed as there were insufficient maintainer resources to keep up with updates"; # Added 2025-04-27
  tooling-language-server = deputy; # Added 2025-06-22
  tor-browser-bundle-bin = tor-browser; # Added 2023-09-23
  torrenttools = throw "torrenttools has been removed due to lack of maintanance upstream"; # Added 2025-04-06
  torzu = throw "torzu has been removed from nixpkgs, as it is subject to a DMCA takedown"; # Added 2025-05-12
  transmission = lib.warnOnInstantiate (transmission3Warning { }) transmission_3; # Added 2024-06-10
  transmission-gtk = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-gtk";
  }) transmission_3-gtk; # Added 2024-06-10
  transmission-qt = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-qt";
  }) transmission_3-qt; # Added 2024-06-10
  treefmt1 = throw "treefmt1 has been removed as it is not maintained anymore. Consider using `treefmt` instead."; # 2025-03-06
  treefmt2 = lib.warnOnInstantiate "treefmt2 has been renamed to treefmt" treefmt; # 2025-03-06
  libtransmission = lib.warnOnInstantiate (transmission3Warning {
    prefix = "lib";
  }) libtransmission_3; # Added 2024-06-10
  lpcnetfreedv = throw "lpcnetfreedv was removed in favor of LPCNet"; # Added 2025-05-05
  LPCNet = lpcnet; # Added 2025-05-05
  tracker = lib.warnOnInstantiate "tracker has been renamed to tinysparql" tinysparql; # Added 2024-09-30
  tracker-miners = lib.warnOnInstantiate "tracker-miners has been renamed to localsearch" localsearch; # Added 2024-09-30
  transcode = throw "transcode has been removed as it is unmaintained"; # Added 2024-12-11
  transfig = fig2dev; # Added 2022-02-15
  transifex-client = transifex-cli; # Added 2023-12-29
  trezor_agent = trezor-agent; # Added 2024-01-07
  trilium-next-desktop = trilium-desktop; # Added 2025-08-30
  trilium-next-server = trilium-server; # Added 2025-08-30
  trojita = throw "'trojita' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  trust-dns = hickory-dns; # Added 2024-08-07
  tuic = throw "`tuic` has been removed due to lack of upstream maintenance, consider using other tuic implementations"; # Added 2025-02-08
  tvbrowser-bin = tvbrowser; # Added 2023-03-02
  tvheadend = throw "tvheadend has been removed as it nobody was willing to maintain it and it was stuck on an unmaintained version that required FFmpeg 4. Please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version"; # Added 2024-08-21
  typst-fmt = typstfmt; # Added 2023-07-15
  typst-lsp = throw "'typst-lsp' has been removed due to lack of upstream maintenance, consider using 'tinymist' instead"; # Added 2025-01-25

  ### U ###

  uade123 = uade; # Added 2022-07-30
  uae = throw "'uae' has been removed due to lack of upstream maintenance. Consider using 'fsuae' instead."; # Added 2025-06-11
  ubuntu_font_family = ubuntu-classic; # Added 2024-02-19
  uclibc = uclibc-ng; # Added 2022-06-16
  unicap = throw "'unicap' has been removed because it is unmaintained"; # Added 2025-05-17
  unifi-poller = unpoller; # Added 2022-11-24
  unifi8 = throw "'unifi8' has been removed. Use `pkgs.unifi` instead."; # Converted to throw 2025-05-10
  unl0kr = throw "'unl0kr' is now included with buffybox. Use `pkgs.buffybox` instead."; # Removed 2024-12-20
  unzoo = throw "'unzoo' has been removed since it is unmaintained upstream and doesn't compile with newer versions of GCC anymore"; # Removed 2025-05-24
  uq = throw "'uq' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  ut2004demo = ut2004Packages; # Added 2024-11-24
  util-linuxCurses = util-linux; # Added 2022-04-12
  utillinux = util-linux; # Added 2020-11-24, keep until node2nix is phased out, see https://github.com/NixOS/nixpkgs/issues/229475

  ### V ###

  v8 = throw "`v8` has been removed as it's unmaintained for several years and has vulnerabilites. Please migrate to `nodejs.libv8`"; # Added 2024-12-21
  vamp = {
    vampSDK = vamp-plugin-sdk;
  }; # Added 2020-03-26
  vaapiIntel = intel-vaapi-driver; # Added 2023-05-31
  vaapiVdpau = libva-vdpau-driver; # Added 2024-06-05
  vaultwarden-vault = vaultwarden.webvault; # Added 2022-12-13
  varnish75 = throw "varnish 7.5 is EOL. Either use the LTS or upgrade."; # Added 2025-03-29
  varnish75Packages = throw "varnish 7.5 is EOL. Either use the LTS or upgrade."; # Added 2025-03-29
  varnish76 = throw "varnish 7.6 is EOL. Either use the LTS or upgrade."; # Added 2025-05-15
  varnish76Packages = throw "varnish 7.6 is EOL. Either use the LTS or upgrade."; # Added 2025-05-15
  vbetool = throw "'vbetool' has been removed as it is broken and not maintained upstream."; # Added 2025-06-11
  vdirsyncerStable = vdirsyncer; # Added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  ventoy-bin = ventoy; # Added 2023-04-12
  ventoy-bin-full = ventoy-full; # Added 2023-04-12
  verilog = iverilog; # Added 2024-07-12
  veriT = verit; # Added 2025-08-21
  vieb = throw "'vieb' has been removed as it doesn't satisfy our security criteria for browsers."; # Added 2025-06-25
  ViennaRNA = viennarna; # Added 2023-08-23
  vimHugeX = vim-full; # Added 2022-12-04
  vim_configurable = vim-full; # Added 2022-12-04
  libviper = throw "'libviper' was removed as it is broken and not maintained upstream"; # Added 2025-05-17
  libviperfx = throw "'libviperfx' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  vimix-cursor-theme = throw "'vimix-cursor-theme' has been superseded by 'vimix-cursors'"; # Added 2025-03-04
  viper4linux-gui = throw "'viper4linux-gui' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  viper4linux = throw "'viper4linux' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
  virt-manager-qt = throw "'virt-manager-qt' has been dropped as it depends on KDE Gear 5, and is unmaintained"; # Added 2025-08-20
  vistafonts = vista-fonts; # Added 2025-02-03
  vistafonts-chs = vista-fonts-chs; # Added 2025-02-03
  vistafonts-cht = vista-fonts-cht; # Added 2025-02-03
  vkBasalt = vkbasalt; # Added 2022-11-22
  vkdt-wayland = vkdt; # Added 2024-04-19
  vmware-horizon-client = throw "'vmware-horizon-client' has been renamed to 'omnissa-horizon-client'"; # Added 2025-04-24
  vocal = throw "'vocal' has been archived upstream. Consider using 'gnome-podcasts' or 'kasts' instead."; # Added 2025-04-12
  void = throw "'void' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  volnoti = throw "'volnoti' has been removed due to lack of maintenance upstream."; # Added 2024-12-04
  voxelands = throw "'voxelands' has been removed due to lack of upstream maintenance"; # Added 2025-08-30
  vtk_9 = lib.warnOnInstantiate "'vtk_9' has been renamed to 'vtk_9_5'" vtk_9_5; # Added 2025-07-18
  vtk_9_egl = lib.warnOnInstantiate "'vtk_9_5' now build with egl support by default, so `vtk_9_egl` is deprecated, consider using 'vtk_9_5' instead." vtk_9_5; # Added 2025-07-18
  vtk_9_withQt5 = throw "'vtk_9_withQt5' has been removed, Consider using 'vtkWithQt5' instead." vtkWithQt5; # Added 2025-07-18
  vwm = throw "'vwm' was removed as it is broken and not maintained upstream"; # Added 2025-05-17

  ### W ###
  w_scan = throw "'w_scan' has been removed due to lack of upstream maintenance"; # Added 2025-08-29
  wakatime = wakatime-cli; # 2024-05-30
  wapp = tclPackages.wapp; # Added 2024-10-02
  wavebox = throw "'wavebox' has been removed due to lack of maintenance in nixpkgs"; # Added 2025-06-24
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_100;
  watershot = throw "'watershot' has been removed as it is unmaintained upstream and no longer works"; # Added 2025-06-01
  wayfireApplications-unwrapped = throw ''
    'wayfireApplications-unwrapped.wayfire' has been renamed to/replaced by 'wayfire'
    'wayfireApplications-unwrapped.wayfirePlugins' has been renamed to/replaced by 'wayfirePlugins'
    'wayfireApplications-unwrapped.wcm' has been renamed to/replaced by 'wayfirePlugins.wcm'
    'wayfireApplications-unwrapped.wlroots' has been removed
  ''; # Add 2023-07-29
  wcurl = throw "'wcurl' has been removed due to being bundled with 'curl'"; # Added 2025-07-04
  webfontkitgenerator = webfont-bundler; # Added 2025-07-27
  webkitgtk = throw "'webkitgtk' attribute has been removed from nixpkgs, use attribute with ABI version set explicitly"; # Added 2025-06-11
  webmetro = throw "'webmetro' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  wg-bond = throw "'wg-bond' has been removed due to lack of upstream maintenance"; # Added 2025-01-25
  whatsapp-for-linux = wasistlos; # Added 2025-01-30
  wifi-password = throw "'wifi-password' has been removed as it was unmaintained upstream"; # Added 2025-08-29
  wineWayland = wine-wayland;
  winhelpcgi = throw "'winhelpcgi' has been removed as it was unmaintained upstream and broken with GCC 14"; # Added 2025-06-14
  win-pvdrivers = throw "'win-pvdrivers' has been removed as it was subject to the Xen build machine compromise (XSN-01) and has open security vulnerabilities (XSA-468)"; # Added 2025-08-29
  win-virtio = virtio-win; # Added 2023-10-17
  wireguard-vanity-address = throw "'wireguard-vanity-address' has been removed due to lack of upstream maintenance"; # Added 2025-01-26
  wkhtmltopdf-bin = wkhtmltopdf; # Added 2024-07-17
  wlroots = wlroots_0_19; # wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  woof = throw "'woof' has been removed as it is broken and unmaintained upstream"; # Added 2025-09-04
  wdomirror = throw "'wdomirror' has been removed as it is unmaintained upstream, Consider using 'wl-mirror' instead"; # Added 2025-09-04
  wordpress6_5 = wordpress_6_5; # Added 2024-08-03
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name
  wpa_supplicant_ro_ssids = lib.warnOnInstantiate "Deprecated package: Please use wpa_supplicant instead. Read-only SSID patches are now upstream!" wpa_supplicant;
  wmii_hg = wmii;
  wrapGAppsHook = wrapGAppsHook3; # Added 2024-03-26
  write_stylus = styluslabs-write-bin; # Added 2024-10-09
  wxGTK33 = wxwidgets_3_3; # Added 2025-07-20

  ### X ###

  x11idle = throw "'x11idle' has been removed as the upstream is no longer available. Please see 'xprintidle' as an alternative"; # Added 2025-03-10
  xboxdrv = throw "'xboxdrv' has been dropped as it has been superseded by an in-tree kernel driver"; # Added 2024-12-25
  xbrightness = throw "'xbrightness' has been removed as it is unmaintained"; # Added 2025-08-28
  xbursttools = throw "'xbursttools' has been removed as it is broken and unmaintained upstream."; # Added 2025-06-12
  xdragon = dragon-drop; # Added 2025-03-22
  xflux-gui = throw "'xflux-gui' has been removed as it was unmaintained"; # Added 2025-08-22
  xflux = throw "'xflux' has been removed as it was unmaintained"; # Added 2025-08-22
  xinput_calibrator = xinput-calibrator; # Added 2025-08-28
  xjump = throw "'xjump' has been removed as it is unmaintained"; # Added 2025-08-22
  xmlada = gnatPackages.xmlada; # Added 2024-02-25
  xmlroff = throw "'xmlroff' has been removed as it is unmaintained and broken"; # Added 2025-05-18
  xournal = throw "'xournal' has been removed due to lack of activity upstream and depending on gnome2. Consider using 'xournalpp' instead."; # Added 2024-12-06
  xonsh-unwrapped = python3Packages.xonsh; # Added 2024-06-18
  xplayer = throw "xplayer has been removed as the upstream project was archived"; # Added 2024-12-27
  xsd = throw "'xsd' has been removed."; # Added 2025-04-02
  xsv = throw "'xsv' has been removed due to lack of upstream maintenance. Please see 'xan' for a maintained alternative"; # Added 2025-01-30
  xsw = throw "'xsw' has been removed due to lack of upstream maintenance"; # Added 2025-08-22
  xtrlock-pam = throw "xtrlock-pam has been removed because it is unmaintained for 10 years and doesn't support Python 3.10 or newer"; # Added 2025-01-25
  xulrunner = firefox-unwrapped; # Added 2023-11-03
  xwaylandvideobridge = makePlasma5Throw "xwaylandvideobridge"; # Added 2024-09-27
  xxv = throw "'xxv' has been removed due to lack of upstream maintenance"; # Added 2025-01-25

  ### Y ###

  yesplaymusic = throw "YesPlayMusic has been removed as it was broken, unmaintained, and used deprecated Node and Electron versions"; # Added 2024-12-13
  yafaray-core = libyafaray; # Added 2022-09-23
  yandex-browser = throw "'yandex-browser' has been removed, as it was broken and unmaintained"; # Added 2025-04-17
  yandex-browser-beta = throw "'yandex-browser-beta' has been removed, as it was broken and unmaintained"; # Added 2025-04-17
  yandex-browser-corporate = throw "'yandex-browser-corporate' has been removed, as it was broken and unmaintained"; # Added 2025-04-17
  yabar = throw "'yabar' has been removed as the upstream project was archived"; # Added 2025-06-10
  yabar-unstable = yabar; # Added 2025-06-10
  yeahwm = throw "'yeahwm' has been removed, as it was broken and unmaintained upstream."; # Added 2025-06-12
  yubikey-manager-qt = throw "'yubikey-manager-qt' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07
  yubikey-personalization-gui = throw "'yubikey-personalization-gui' has been removed due to being archived upstream. Consider using 'yubioath-flutter' instead."; # Added 2025-06-07

  ### Z ###

  z3_4_11 = throw "'z3_4_11' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_12 = throw "'z3_4_12' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_13 = throw "'z3_4_13' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_14 = throw "'z3_4_14' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_8_5 = throw "'z3_4_8_5' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  z3_4_8 = throw "'z3_4_8' has been removed in favour of the latest version. Use 'z3'."; # Added 2025-05-18
  zabbix50 = throw "'zabbix50' has been removed, it would have reached its End of Life a few days after the release of NixOS 25.05. Consider upgrading to 'zabbix60' or 'zabbix70'."; # Added 2025-04-22
  zabbix64 = throw "'zabbix64' has been removed because it reached its End of Life. Consider upgrading to 'zabbix70'."; # Added 2025-04-22
  zbackup = throw "'zbackup' has been removed due to being unmaintained upstream"; # Added 2025-08-22
  zeal-qt5 = lib.warnOnInstantiate "'zeal-qt5' has been removed from nixpkgs. Please use 'zeal' instead" zeal; # Added 2025-08-31
  zeal-qt6 = lib.warnOnInstantiate "'zeal-qt6' has been renamed to 'zeal'" zeal; # Added 2025-08-31
  zeroadPackages = recurseIntoAttrs {
    zeroad = lib.warnOnInstantiate "'zeroadPackages.zeroad' has been renamed to 'zeroad'" zeroad; # Added 2025-03-22
    zeroad-data = lib.warnOnInstantiate "'zeroadPackages.zeroad-data' has been renamed to 'zeroad-data'" zeroad-data; # Added 2025-03-22
    zeroad-unwrapped = lib.warnOnInstantiate "'zeroadPackages.zeroad-unwrapped' has been renamed to 'zeroad-unwrapped'" zeroad-unwrapped; # Added 2025-03-22
  };
  zeromq4 = zeromq; # Added 2024-11-03
  zfsStable = zfs; # Added 2024-02-26
  zfsUnstable = zfs_unstable; # Added 2024-02-26
  zfs_2_1 = throw "zfs 2.1 has been removed as it is EOL. Please upgrade to a newer version"; # Added 2024-12-25
  zig_0_9 = throw "zig 0.9 has been removed, upgrade to a newer version instead"; # Added 2025-01-24
  zig_0_10 = throw "zig 0.10 has been removed, upgrade to a newer version instead"; # Added 2025-01-24
  zig_0_11 = throw "zig 0.11 has been removed, upgrade to a newer version instead"; # Added 2025-04-09
  zig_0_12 = throw "zig 0.12 has been removed, upgrade to a newer version instead"; # Added 2025-08-18
  zigbee2mqtt_1 = throw "Zigbee2MQTT 1.x has been removed, upgrade to the unversioned attribute."; # Added 2025-08-11
  zigbee2mqtt_2 = zigbee2mqtt; # Added 2025-08-11
  zimlib = throw "'zimlib' has been removed because it was an outdated and unused version of 'libzim'"; # Added 2025-03-07
  zinc = zincsearch; # Added 2023-05-28
  zint = zint-qt; # Added 2025-05-15
  zombietrackergps = throw "'zombietrackergps' has been dropped, as it depends on KDE Gear 5 and is unmaintained"; # Added 2025-08-20
  zsh-git-prompt = throw "zsh-git-prompt was removed as it is unmaintained upstream"; # Added 2025-08-28
  zsh-history = throw "'zsh-history' has been removed as it was unmaintained"; # Added 2025-04-17
  zq = zed.overrideAttrs (old: {
    meta = old.meta // {
      mainProgram = "zq";
    };
  }); # Added 2023-02-06
  zyn-fusion = zynaddsubfx; # Added 2022-08-05

  ### UNSORTED ###

  inherit (stdenv.hostPlatform) system; # Added 2021-10-22
  inherit (stdenv) buildPlatform hostPlatform targetPlatform; # Added 2023-01-09

  freebsdCross = freebsd; # Added 2024-09-06
  netbsdCross = netbsd; # Added 2024-09-06
  openbsdCross = openbsd; # Added 2024-09-06

  # LLVM packages for (integration) testing that should not be used inside Nixpkgs:
  llvmPackages_latest = llvmPackages_20;

  /*
    If these are in the scope of all-packages.nix, they cause collisions
      between mixed versions of qt. See:
    https://github.com/NixOS/nixpkgs/pull/101369
  */

  kalendar = merkuro; # Renamed in 23.08

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
    purple-slack
    purple-vk-plugin
    purple-xmpp-http-upload
    tdlib-purple
    pidgin-opensteamworks
    purple-facebook
    ;

}
// plasma5Throws
