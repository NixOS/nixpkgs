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
// mapAliases (import ./aliases/drop-in-27.05.nix)
// mapAliases (import ./aliases/drop-in-26.11.nix)
// mapAliases (import ./aliases/drop-in-26.05.nix)
// mapAliases (import ./aliases/drop-in-25.11.nix)
// mapAliases {
  # Added 2018-07-16 preserve, reason: forceSystem should not be used directly in Nixpkgs.
  forceSystem = system: _: (import self.path { localSystem = { inherit system; }; });

  ### _ ###
  _1password = lib.warnOnInstantiate "_1password has been renamed to _1password-cli to better follow upstream name usage" _1password-cli; # Added 2024-10-24

  ### A ###

  AusweisApp2 = ausweisapp; # Added 2023-11-08
  a4term = a4; # Added 2023-10-06
  adminer-pematon = adminneo; # Added 2025-02-20
  adminerneo = adminneo; # Added 2025-02-27
  akkoma-emoji = recurseIntoAttrs {
    blobs_gg = lib.warnOnInstantiate "'akkoma-emoji.blobs_gg' has been renamed to 'blobs_gg'" blobs_gg; # Added 2025-03-14
  };
  akkoma-frontends = recurseIntoAttrs {
    admin-fe = lib.warnOnInstantiate "'akkoma-frontends.admin-fe' has been renamed to 'akkoma-admin-fe'" akkoma-admin-fe; # Added 2025-03-14
    akkoma-fe = lib.warnOnInstantiate "'akkoma-frontends.akkoma-fe' has been renamed to 'akkoma-fe'" akkoma-fe; # Added 2025-03-14
  };
  ao = libfive; # Added 2024-10-11
  apacheAnt = ant; # Added 2024-11-28
  appthreat-depscan = dep-scan; # Added 2024-04-10
  argo = argo-workflows; # Added 2025-02-01
  aria = aria2; # Added 2024-03-26
  artim-dark = aritim-dark; # Added 2025-07-27
  aseprite-unfree = aseprite; # Added 2023-08-26
  asitop = macpm; # 'macpm' is a better-maintained downstream; keep 'asitop' for backwards-compatibility
  autoReconfHook = throw "You meant 'autoreconfHook', with a lowercase 'r'."; # preserve
  awesome-4-0 = awesome; # Added 2022-05-05

  ### B ###

  badtouch = authoscope; # Project was renamed, added 20210626
  banking = saldo; # added 2025-08-29
  BeatSaberModManager = beatsabermodmanager; # Added 2024-06-12
  bitwarden = bitwarden-desktop; # Added 2024-02-25
  blender-with-packages =
    args:
    lib.warnOnInstantiate
      "blender-with-packages is deprecated in favor of blender.withPackages, e.g. `blender.withPackages(ps: [ ps.foobar ])`"
      (blender.withPackages (_: args.packages)).overrideAttrs
      (lib.optionalAttrs (args ? name) { pname = "blender-" + args.name; }); # Added 2023-10-30
  blockbench-electron = blockbench; # Added 2024-03-16
  bmap-tools = bmaptool; # Added 2024-08-05
  brasero-original = lib.warnOnInstantiate "Use 'brasero-unwrapped' instead of 'brasero-original'" brasero-unwrapped; # Added 2024-09-29

  bwidget = tclPackages.bwidget; # Added 2024-10-02

  # bitwarden_rs renamed to vaultwarden with release 1.21.0 (2021-04-30)
  bitwarden_rs = vaultwarden;
  bitwarden_rs-mysql = vaultwarden-mysql;
  bitwarden_rs-postgresql = vaultwarden-postgresql;
  bitwarden_rs-sqlite = vaultwarden-sqlite;
  bitwarden_rs-vault = vaultwarden-vault;

  ### C ###

  calculix = calculix-ccx; # Added 2024-12-18
  calligra = kdePackages.calligra; # Added 2024-09-27
  callPackage_i686 = pkgsi686Linux.callPackage;
  cask = emacs.pkgs.cask; # Added 2022-11-12
  canonicalize-jars-hook = stripJavaArchivesHook; # Added 2024-03-17
  cargo-espflash = espflash;
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
  cinnamon-common = cinnamon; # Added 2025-08-06
  clang-sierraHack-stdenv = clang-sierraHack; # Added 2024-10-05
  CoinMP = coinmp; # Added 2024-06-12
  collada-dom = opencollada; # added 2024-02-21
  copilot-language-server-fhs = lib.warnOnInstantiate "The package set `copilot-language-server-fhs` has been renamed to `copilot-language-server`." copilot-language-server; # Added 2025-09-07
  cosmic-tasks = tasks; # Added 2024-07-04
  cpp-ipfs-api = cpp-ipfs-http-client; # Project has been renamed. Added 2022-05-15
  crispyDoom = crispy-doom; # Added 2023-05-01
  crossLibcStdenv = stdenvNoLibc; # Added 2024-09-06
  clasp = clingo; # added 2022-12-22
  cockroachdb-bin = cockroachdb; # 2024-03-15
  critcl = tclPackages.critcl; # Added 2024-10-02
  cups-kyodialog3 = cups-kyodialog; # Added 2022-11-12

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

  ### D ###

  dat = nodePackages.dat;
  deadpixi-sam = deadpixi-sam-unstable;

  deltachat-cursed = arcanechat-tui; # added 2025-02-25

  demjson = with python3Packages; toPythonApplication demjson; # Added 2022-01-18
  dleyna-core = dleyna; # Added 2025-04-19
  dleyna-connector-dbus = dleyna; # Added 2025-04-19
  dleyna-renderer = dleyna; # Added 2025-04-19
  dleyna-server = dleyna; # Added 2025-04-19
  dnscrypt-proxy2 = dnscrypt-proxy; # Added 2023-02-02
  docker-distribution = distribution; # Added 2023-12-26
  dolphin-emu-beta = dolphin-emu; # Added 2023-02-11
  dotty = scala_3; # Added 2023-08-20
  dtv-scan-tables_linuxtv = dtv-scan-tables; # Added 2023-03-03
  dtv-scan-tables_tvheadend = dtv-scan-tables; # Added 2023-03-03
  du-dust = dust; # Added 2024-01-19
  dump1090 = dump1090-fa; # Added 2024-02-12

  ### E ###

  EBTKS = ebtks; # Added 2024-01-21
  eask = eask-cli; # Added 2024-09-05
  ec2-utils = amazon-ec2-utils; # Added 2022-02-01

  edid-decode = v4l-utils; # Added 2025-06-20
  eintopf = lauti; # Project was renamed, added 2025-05-01
  elasticsearch7Plugins = elasticsearchPlugins;

  elixir_ls = elixir-ls; # Added 2023-03-20

  # Emacs
  emacs28NativeComp = emacs28; # Added 2022-06-08
  emacsMacport = emacs-macport; # Added 2023-08-10
  emacsNativeComp = emacs; # Added 2022-06-08
  emacsPackages = emacs.pkgs; # Added 2025-03-02

  EmptyEpsilon = empty-epsilon; # Added 2024-07-14
  enyo-doom = enyo-launcher; # Added 2022-09-09

  eww-wayland = lib.warnOnInstantiate "eww now can build for X11 and wayland simultaneously, so `eww-wayland` is deprecated, use the normal `eww` package instead." eww;

  ### F ###

  f3d_egl = lib.warnOnInstantiate "'f3d' now build with egl support by default, so `f3d_egl` is deprecated, consider using 'f3d' instead." f3d; # added 2025-07-18
  faustStk = faustPhysicalModeling; # Added 2023-05-16
  fastnlo_toolkit = fastnlo-toolkit; # Added 2024-01-03
  fcitx5-catppuccin = catppuccin-fcitx5; # Added 2024-06-19
  inherit (luaPackages) fennel; # Added 2022-09-24
  fetchFromGithub = throw "You meant fetchFromGitHub, with a capital H"; # preserve
  FIL-plugins = fil-plugins; # Added 2024-06-12
  finger_bsd = bsd-finger;
  fingerd_bsd = bsd-fingerd;
  fira-code-nerdfont = lib.warnOnInstantiate "fira-code-nerdfont is redundant. Use nerd-fonts.fira-code instead." nerd-fonts.fira-code; # Added 2024-11-10
  firefox-beta-bin = lib.warnOnInstantiate "`firefox-beta-bin` is removed.  Please use `firefox-beta` or `firefox-bin` instead." firefox-beta;
  firefox-devedition-bin = lib.warnOnInstantiate "`firefox-devedition-bin` is removed.  Please use `firefox-devedition` or `firefox-bin` instead." firefox-devedition;
  firefox-wayland = firefox; # Added 2022-11-15
  firmwareLinuxNonfree = linux-firmware; # Added 2022-01-09
  fishfight = jumpy; # Added 2022-08-03
  fit-trackee = fittrackee; # added 2024-09-03
  flashrom-stable = flashprog; # Added 2024-03-01
  flatbuffers_2_0 = flatbuffers; # Added 2022-05-12
  flow-editor = flow-control; # Added 2025-03-05
  follow = lib.warnOnInstantiate "follow has been renamed to folo" folo; # Added 2025-05-18
  forgejo-actions-runner = forgejo-runner; # Added 2024-04-04

  fractal-next = fractal; # added 2023-11-25
  framework-system-tools = framework-tool; # added 2023-12-09
  francis = kdePackages.francis; # added 2024-07-13
  freecad-qt6 = freecad; # added 2025-06-14
  freecad-wayland = freecad; # added 2025-06-14
  freerdp3 = freerdp; # added 2025-03-25
  freerdpUnstable = freerdp; # added 2025-03-25
  fuse2fs = if stdenv.hostPlatform.isLinux then e2fsprogs.fuse2fs else null; # Added 2022-03-27 preserve, reason: convenience, arch has a package named fuse2fs too.
  futuresql = libsForQt5.futuresql; # added 2023-11-11
  fx_cast_bridge = fx-cast-bridge; # added 2023-07-26

  fcitx5-chinese-addons = qt6Packages.fcitx5-chinese-addons; # Added 2024-03-01
  fcitx5-configtool = qt6Packages.fcitx5-configtool; # Added 2024-03-01
  fcitx5-skk-qt = qt6Packages.fcitx5-skk-qt; # Added 2024-03-01
  fcitx5-unikey = qt6Packages.fcitx5-unikey; # Added 2024-03-01
  fcitx5-with-addons = qt6Packages.fcitx5-with-addons; # Added 2024-03-01

  ### G ###

  g4music = gapless; # Added 2024-07-26
  garage_1_x = lib.warnOnInstantiate "'garage_1_x' has been renamed to 'garage_1'" garage_1; # Added 2025-06-23
  gcj = gcj6; # Added 2024-09-13
  gg = go-graft; # Added 2025-03-07
  ghostwriter = makePlasma5Throw "ghostwriter"; # Added 2023-03-18
  gnu-cobol = gnucobol; # Added 2024-09-17

  gitAndTools = self // {
    darcsToGit = darcs-to-git;
    gitAnnex = git-annex;
    gitBrunch = git-brunch;
    gitFastExport = git-fast-export;
    gitRemoteGcrypt = git-remote-gcrypt;
    svn_all_fast_export = svn-all-fast-export;
    topGit = top-git;
  }; # Added 2021-01-14
  glew-egl = lib.warnOnInstantiate "'glew-egl' is now provided by 'glew' directly" glew; # Added 2024-08-11
  glfw-wayland = glfw; # Added 2024-04-19
  glfw-wayland-minecraft = glfw3-minecraft; # Added 2024-05-08
  glxinfo = mesa-demos; # Added 2024-07-04
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

  #godot
  godot_4_3-export-templates = lib.warnOnInstantiate "godot_4_3-export-templates has been renamed to godot_4_3-export-templates-bin" godot_4_3-export-templates-bin;
  godot_4_4-export-templates = lib.warnOnInstantiate "godot_4_4-export-templates has been renamed to godot_4_4-export-templates-bin" godot_4_4-export-templates-bin;
  godot_4-export-templates = lib.warnOnInstantiate "godot_4-export-templates has been renamed to godot_4-export-templates-bin" godot_4-export-templates-bin;
  godot-export-templates = lib.warnOnInstantiate "godot-export-templates has been renamed to godot-export-templates-bin" godot-export-templates-bin;

  go-thumbnailer = thud; # Added 2023-09-21
  go-upower-notify = upower-notify; # Added 2024-07-21
  gprbuild-boot = gnatPackages.gprbuild-boot; # Added 2024-02-25;

  graalvmCEPackages = graalvmPackages; # Added 2024-08-10
  graalvm-ce = graalvmPackages.graalvm-ce; # Added 2024-08-10
  graalvm-oracle = graalvmPackages.graalvm-oracle; # Added 2024-12-17
  grafana_reporter = grafana-reporter; # Added 2024-06-09
  gringo = clingo; # added 2022-11-27
  grub2_full = grub2; # Added 2022-11-18
  gtkcord4 = dissent; # Added 2024-03-10
  guile-disarchive = disarchive; # Added 2023-10-27
  gutenprintBin = gutenprint-bin; # Added 2025-08-21

  ### H ###

  HentaiAtHome = hentai-at-home; # Added 2024-06-12
  hpp-fcl = coal; # Added 2024-11-15
  hydra_unstable = hydra; # Added 2024-08-22

  ### I ###

  i3-gaps = i3; # Added 2023-01-03
  immersed-vr = lib.warnOnInstantiate "'immersed-vr' has been renamed to 'immersed'" immersed; # Added 2024-08-11
  inconsolata-nerdfont = lib.warnOnInstantiate "inconsolata-nerdfont is redundant. Use nerd-fonts.inconsolata instead." nerd-fonts.inconsolata; # Added 2024-11-10
  incrtcl = tclPackages.incrtcl; # Added 2024-10-02
  inotifyTools = inotify-tools;
  ipfs = kubo; # Added 2022-09-27
  ipfs-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2022-09-27
  ipfs-migrator-unwrapped = kubo-migrator-unwrapped; # Added 2022-09-27
  ipfs-migrator = kubo-migrator; # Added 2022-09-27
  iso-flags-png-320x420 = lib.warnOnInstantiate "iso-flags-png-320x420 has been renamed to iso-flags-png-320x240" iso-flags-png-320x240; # Added 2024-07-17
  itktcl = tclPackages.itktcl; # Added 2024-10-02

  ### J ###

  jami-client-qt = jami-client; # Added 2022-11-06
  jami-client = jami; # Added 2023-02-10
  jami-daemon = jami.daemon; # Added 2023-02-10

  # Julia

  ### K ###

  # k3d was a 3d editing software k-3d - "k3d has been removed because it was broken and has seen no release since 2016" Added 2022-01-04
  # now kube3d/k3d will take its place
  kube3d = k3d; # Added 2022-0705
  kak-lsp = kakoune-lsp; # Added 2024-04-01
  kanidm = lib.warnOnInstantiate "'kanidm' will be removed before 26.05. You must use a versioned package, e.g. 'kanidm_1_x'." kanidm_1_7; # Added 2025-09-01
  kanidmWithSecretProvisioning = lib.warnOnInstantiate "'kanidmWithSecretProvisioning' will be removed before 26.05. You must use a versioned package, e.g. 'kanidmWithSecretProvisioning_1_x'." kanidmWithSecretProvisioning_1_7; # Added 2025-09-01
  keepkey_agent = keepkey-agent; # added 2024-01-06
  kexi = makePlasma5Throw "kexi";
  kgx = gnome-console; # Added 2022-02-19
  kio-admin = makePlasma5Throw "kio-admin"; # Added 2023-03-18
  kodiGBM = kodi-gbm;
  kodiPlain = kodi;
  kodiPlainWayland = kodi-wayland;
  kodiPlugins = kodiPackages; # Added 2021-03-09;
  krb5Full = krb5;
  kubei = kubeclarity; # Added 2023-05-20
  kubo-migrator-all-fs-repo-migrations = kubo-fs-repo-migrations; # Added 2024-09-24

  ### L ###

  larynx = piper-tts; # Added 2023-05-09
  LASzip = laszip; # Added 2024-06-12
  LASzip2 = laszip_2; # Added 2024-06-12
  latinmodern-math = lmmath;
  lazarus-qt = lazarus-qt5; # Added 2024-12-25
  ledger_agent = ledger-agent; # Added 2024-01-07
  lfs = dysk; # Added 2023-07-03
  libav_0_8 = libav; # Added 2024-08-25
  libav_11 = libav; # Added 2024-08-25
  libav_12 = libav; # Added 2024-08-25
  libav_all = libav; # Added 2024-08-25
  libayatana-indicator-gtk3 = libayatana-indicator; # Added 2022-10-18
  libayatana-appindicator-gtk3 = libayatana-appindicator; # Added 2022-10-18
  libbencodetools = bencodetools; # Added 2022-07-30
  libbpf_1 = libbpf; # Added 2022-12-06
  libbson = mongoc; # Added 2024-03-11
  libgda = lib.warnOnInstantiate "‘libgda’ has been renamed to ‘libgda5’" libgda5; # Added 2025-01-21
  libgme = game-music-emu; # Added 2022-07-20
  libgnome-keyring3 = libgnome-keyring; # Added 2024-06-22
  libheimdal = heimdal; # Added 2022-11-18
  libiconv-darwin = darwin.libiconv;
  libixp_hg = libixp;
  libosmo-sccp = libosmo-sigtran; # Added 2024-12-20
  libpulseaudio-vanilla = libpulseaudio; # Added 2022-04-20
  libqt5pas = libsForQt5.libqtpas; # Added 2024-12-25
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
  libyamlcpp = yaml-cpp; # Added 2023-01-29
  libyamlcpp_0_3 = yaml-cpp_0_3; # Added 2023-01-29
  lightdm_gtk_greeter = lightdm-gtk-greeter; # Added 2022-08-01
  lima-bin = lib.warnOnInstantiate "lima-bin has been replaced by lima" lima; # Added 2025-05-13
  Literate = literate; # Added 2024-06-12
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

  loco-cli = loco; # Added 2025-02-24
  lxd = lib.warnOnInstantiate "lxd has been renamed to lxd-lts" lxd-lts; # Added 2024-04-01

  lxd-unwrapped = lib.warnOnInstantiate "lxd-unwrapped has been renamed to lxd-unwrapped-lts" lxd-unwrapped-lts; # Added 2024-04-01

  ### M ###

  mac = monkeysAudio; # Added 2024-11-30
  MACS2 = macs2; # Added 2023-06-12
  mariadb-client = hiPrio mariadb.client; # added 2019.07.28

  marwaita-manjaro = lib.warnOnInstantiate "marwaita-manjaro has been renamed to marwaita-teal" marwaita-teal; # Added 2024-07-08
  marwaita-peppermint = lib.warnOnInstantiate "marwaita-peppermint has been renamed to marwaita-red" marwaita-red; # Added 2024-07-01
  marwaita-ubuntu = lib.warnOnInstantiate "marwaita-ubuntu has been renamed to marwaita-orange" marwaita-orange; # Added 2024-07-08
  marwaita-pop_os = lib.warnOnInstantiate "marwaita-pop_os has been renamed to marwaita-yellow" marwaita-yellow; # Added 2024-10-29
  matomo_5 = matomo; # Added 2024-12-12
  matrix-synapse-tools = recurseIntoAttrs {
    rust-synapse-compress-state = lib.warnOnInstantiate "`matrix-synapse-tools.rust-synapse-compress-state` has been renamed to `rust-synapse-compress-state`" rust-synapse-compress-state;
    synadm = lib.warnOnInstantiate "`matrix-synapse-tools.synadm` has been renamed to `synadm`" synadm;
  }; # Added 2025-02-20
  mcomix3 = mcomix; # Added 2022-06-05
  mdt = md-tui; # Added 2024-09-03
  microcodeAmd = microcode-amd; # Added 2024-09-08
  microcodeIntel = microcode-intel; # Added 2024-09-08
  microsoft_gsl = microsoft-gsl; # Added 2023-05-26
  midori-unwrapped = midori; # Added 2025-05-19
  MIDIVisualizer = midivisualizer; # Added 2024-06-12
  mime-types = mailcap; # Added 2022-01-21
  minetest = luanti; # Added 2024-11-11
  minetestclient = luanti-client; # Added 2024-11-11
  minetestserver = luanti-server; # Added 2024-11-11
  minetest-touch = luanti-client; # Added 2024-08-12
  minizip2 = pkgs.minizip-ng; # Added 2022-12-28
  mono4 = mono6; # Added 2025-08-25
  mono5 = mono6; # Added 2025-08-25
  moz-phab = mozphab; # Added 2022-08-09
  mpc-cli = mpc; # Added 2024-10-14
  mpc_cli = mpc; # Added 2024-10-14
  mpdWithFeatures = lib.warnOnInstantiate "mpdWithFeatures has been replaced by mpd.override" mpd.override; # Added 2025-08-08
  mpdevil = plattenalbum; # Added 2024-05-22
  msp430NewlibCross = msp430Newlib; # Added 2024-09-06
  mumps_par = lib.warnOnInstantiate "mumps_par has been renamed to mumps-mpi" mumps-mpi; # Added 2025-05-07
  mustache-tcl = tclPackages.mustache-tcl; # Added 2024-10-02
  mutt-with-sidebar = mutt; # Added 2022-09-17
  mysql-client = hiPrio mariadb.client;

  ### N ###

  ncdu_2 = ncdu; # Added 2022-07-22
  neocities-cli = neocities; # Added 2024-07-31
  nettools = net-tools; # Added 2025-06-11
  newt-go = fosrl-newt; # Added 2025-06-24
  nagiosPluginsOfficial = monitoring-plugins;
  neochat = makePlasma5Throw "neochat"; # added 2022-05-10
  networkmanager_strongswan = networkmanager-strongswan; # added 2025-06-29
  newlibCross = newlib; # Added 2024-09-06
  newlib-nanoCross = newlib-nano; # Added 2024-09-06
  nix-direnv-flakes = nix-direnv;
  nix-ld-rs = nix-ld; # Added 2024-08-17
  nixStable = nixVersions.stable; # Added 2022-01-24
  nixfmt-rfc-style =
    if lib.oldestSupportedReleaseIsAtLeast 2511 then
      lib.warnOnInstantiate
        "nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead."
        nixfmt # Added 2025-07-14
    else
      nixfmt;

  # When the nixops_unstable alias is removed, nixops_unstable_minimal can be renamed to nixops_unstable.

  nixosTest = testers.nixosTest; # Added 2022-05-05
  nodejs-slim_18 = nodejs_18; # Added 2025-04-23
  corepack_18 = nodejs_18; # Added 2025-04-23
  nodejs-18_x = nodejs_18; # Added 2022-11-06
  nodejs-slim-18_x = nodejs-slim_18; # Added 2022-11-06
  nomacs-qt6 = nomacs; # Added 2025-08-30
  noto-fonts-emoji = noto-fonts-color-emoji; # Added 2023-09-09
  noto-fonts-extra = noto-fonts; # Added 2023-04-08
  NSPlist = nsplist; # Added 2024-01-05
  nushellFull = lib.warnOnInstantiate "`nushellFull` has has been replaced by `nushell` as its features no longer exist" nushell; # Added 2024-05-30

  ### O ###

  o = orbiton; # Added 2023-04-09
  oathToolkit = oath-toolkit; # Added 2022-04-04
  oil = lib.warnOnInstantiate "Oil has been replaced with the faster native C++ version and renamed to 'oils-for-unix'. See also https://github.com/oils-for-unix/oils/wiki/Oils-Deployments" oils-for-unix; # Added 2024-10-22
  onevpl-intel-gpu = lib.warnOnInstantiate "onevpl-intel-gpu has been renamed to vpl-gpu-rt" vpl-gpu-rt; # Added 2024-06-04
  openai-triton-llvm = triton-llvm; # added 2024-07-18
  openai-whisper-cpp = whisper-cpp; # Added 2024-12-13
  openafs_1_8 = openafs; # Added 2022-08-22
  openconnect_gnutls = openconnect; # Added 2022-03-29
  openexr_3 = openexr; # Added 2025-03-12
  openimageio2 = openimageio; # Added 2023-01-05
  openssl_3_0 = openssl_3; # Added 2022-06-27
  opensycl = lib.warnOnInstantiate "'opensycl' has been renamed to 'adaptivecpp'" adaptivecpp; # Added 2024-12-04
  opensyclWithRocm = lib.warnOnInstantiate "'opensyclWithRocm' has been renamed to 'adaptivecppWithRocm'" adaptivecppWithRocm; # Added 2024-12-04
  open-timeline-io = lib.warnOnInstantiate "'open-timeline-io' has been renamed to 'opentimelineio'" opentimelineio; # Added 2025-08-10
  opentofu-ls = lib.warnOnInstantiate "'opentofu-ls' has been renamed to 'tofu-ls'" tofu-ls; # Added 2025-06-10
  onlyoffice-bin = onlyoffice-desktopeditors; # Added 2024-09-20
  onlyoffice-bin_latest = onlyoffice-bin; # Added 2024-07-03
  OSCAR = oscar; # Added 2024-06-12
  overrideSDK = "overrideSDK has been removed as it was a legacy compatibility stub. See <https://nixos.org/manual/nixpkgs/stable/#sec-darwin-legacy-frameworks-overrides> for migration instructions"; # Added 2025-08-04

  ### P ###

  PageEdit = pageedit; # Added 2024-01-21
  inherit (perlPackages) pacup;
  paperless-ng = paperless-ngx; # Added 2022-04-11
  partition-manager = makePlasma5Throw "partitionmanager"; # Added 2024-01-08
  patchelfStable = patchelf; # Added 2024-01-25
  paup = paup-cli; # Added 2024-09-11
  pcsctools = pcsc-tools; # Added 2023-12-07
  pdf4tcl = tclPackages.pdf4tcl; # Added 2024-10-02
  pds = lib.warnOnInstantiate "'pds' has been renamed to 'bluesky-pds'" bluesky-pds; # Added 2025-08-20
  pdsadmin = lib.warnOnInstantiate "'pdsadmin' has been renamed to 'bluesky-pdsadmin'" bluesky-pdsadmin; # Added 2025-08-20
  peach = asouldocs; # Added 2022-08-28
  percona-server_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-server; # Added 2024-10-13
  percona-server_lts = percona-server; # Added 2024-10-13
  percona-xtrabackup_innovation = lib.warnOnInstantiate "Percona upstream has decided to skip all Innovation releases of MySQL and only release LTS versions." percona-xtrabackup; # Added 2024-10-13
  percona-xtrabackup_lts = percona-xtrabackup; # Added 2024-10-13
  pentablet-driver = xp-pen-g430-driver; # Added 2022-06-23
  pgadmin = pgadmin4;
  pharo-spur64 = pharo; # Added 2022-08-03
  picom-next = picom; # Added 2024-02-13
  platformioPackages = {
    inherit
      platformio-core
      platformio-chrootenv
      ;
  }; # Added 2025-09-04
  pltScheme = racket; # just to be sure
  poac = cabinpkg; # Added 2025-01-22
  podofo010 = podofo_0_10; # Added 2025-06-01
  powerdns = pdns; # Added 2022-03-28

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

  PlistCpp = plistcpp; # Added 2024-01-05
  pocket-updater-utility = pupdate; # Added 2024-01-25
  poppler_utils = poppler-utils; # Added 2025-02-27
  probe-rs = probe-rs-tools; # Added 2024-05-23
  prometheus-dmarc-exporter = dmarc-metrics-exporter; # added 2022-05-31
  prometheus-dovecot-exporter = dovecot_exporter; # Added 2024-06-10
  protobuf3_24 = protobuf_24;
  protobuf3_23 = protobuf_23;
  protobuf3_21 = protobuf_21;
  protonup = protonup-ng; # Added 2022-11-06
  proton-vpn-local-agent = lib.warnOnInstantiate "'proton-vpn-local-agent' has been renamed to 'python3Packages.proton-vpn-local-agent'" (
    python3Packages.toPythonApplication python3Packages.proton-vpn-local-agent
  ); # Added 2025-04-23
  proxmark3-rrg = proxmark3; # Added 2023-07-25
  pyo3-pack = maturin;
  pypolicyd-spf = spf-engine; # Added 2022-10-09
  python = python2; # Added 2022-01-11
  pythonFull = python2Full; # Added 2022-01-11
  pythonPackages = python.pkgs; # Added 2022-01-11

  ### Q ###

  qflipper = qFlipper; # Added 2022-02-11
  qscintilla = libsForQt5.qscintilla; # Added 2023-09-20
  qscintilla-qt6 = qt6Packages.qscintilla; # Added 2023-09-20
  qt515 = qt5; # Added 2022-11-24
  qt6ct = qt6Packages.qt6ct; # Added 2023-03-07
  qtile-unwrapped = python3.pkgs.qtile; # Added 2023-05-12
  quantum-espresso-mpi = quantum-espresso; # Added 2023-11-23

  ### R ###

  radicale3 = radicale; # Added 2024-11-29
  railway-travel = diebahn; # Added 2024-04-01
  rambox-pro = rambox; # Added 2022-12-12
  rapidjson-unstable = lib.warnOnInstantiate "'rapidjson-unstable' has been renamed to 'rapidjson'" rapidjson; # Added 2024-07-28
  redocly-cli = redocly; # Added 2024-04-14
  redpanda = redpanda-client; # Added 2023-10-14
  retroarchBare = retroarch-bare; # Added 2024-11-23
  retroarchFull = retroarch-full; # Added 2024-11-23
  retroshare06 = retroshare;
  rigsofrods = rigsofrods-bin; # Added 2023-03-22
  rl_json = tclPackages.rl_json; # Added 2025-05-03
  rockbox_utility = rockbox-utility; # Added 2022-03-17
  rr-unstable = rr; # Added 2022-09-17
  rtx = mise; # Added 2024-01-05
  runCommandNoCC = runCommand;
  runCommandNoCCLocal = runCommandLocal;
  rust-synapse-state-compress = rust-synapse-compress-state;
  rustc-wasm32 = rustc; # Added 2023-12-01
  rustic-rs = rustic; # Added 2024-08-02
  ryujinx-greemdev = ryubing; # Added 2025-01-20

  # The alias for linuxPackages*.rtlwifi_new is defined in ./all-packages.nix,
  # due to it being inside the linuxPackagesFor function.

  ### S ###

  SDL_classic = SDL1; # Added 2024-09-03
  scantailor = scantailor-advanced; # Added 2022-05-26
  scitoken-cpp = scitokens-cpp; # Added 2024-02-12
  session-desktop-appimage = session-desktop;
  sequoia = sequoia-sq; # Added 2023-06-26
  sexp = sexpp; # Added 2023-07-03
  shipyard = jumppad; # Added 2023-06-06
  siduck76-st = st-snazzy; # Added 2024-12-24
  signal-desktop-source = lib.warnOnInstantiate "'signal-desktop-source' is now exposed at 'signal-desktop'." signal-desktop; # Added 2025-04-16
  shout = nodePackages.shout; # Added unknown; moved 2024-10-19
  SkypeExport = skypeexport; # Added 2024-06-12
  sladeUnstable = slade-unstable; # Added 2025-08-26
  slurm-llnl = slurm; # renamed July 2017
  smartgithg = smartgit; # renamed March 2025
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

  # spidermonkey is not ABI upwards-compatible, so only allow this for nix-shell
  spotify-unwrapped = spotify; # added 2022-11-06
  ssm-agent = amazon-ssm-agent; # Added 2023-10-17
  starpls-bin = starpls;
  steamPackages = {
    steam = lib.warnOnInstantiate "`steamPackages.steam` has been moved to top level as `steam-unwrapped`" steam-unwrapped;
    steam-fhsenv = lib.warnOnInstantiate "`steamPackages.steam-fhsenv` has been moved to top level as `steam`" steam;
    steam-fhsenv-small = lib.warnOnInstantiate "`steamPackages.steam-fhsenv-small` has been moved to top level as `steam`. There is no longer a -small variant" steam;
    steamcmd = lib.warnOnInstantiate "`steamPackages.steamcmd` has been moved to top level as `steamcmd`" steamcmd;
  };
  steam-small = steam; # Added 2024-09-12
  steam-run-native = steam-run; # added 2022-02-21
  StormLib = stormlib; # Added 2024-01-21
  sumneko-lua-language-server = lua-language-server; # Added 2023-02-07
  swiProlog = lib.warnOnInstantiate "swiProlog has been renamed to swi-prolog" swi-prolog; # Added 2024-09-07
  swiPrologWithGui = lib.warnOnInstantiate "swiPrologWithGui has been renamed to swi-prolog-gui" swi-prolog-gui; # Added 2024-09-07
  swig4 = swig; # Added 2024-09-12
  Sylk = sylk; # Added 2024-06-12
  symbiyosys = sby; # Added 2024-08-18
  sync = taler-sync; # Added 2024-09-04
  syncthingtray-qt6 = syncthingtray; # Added 2024-03-06

  ### T ###

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
  tdesktop = telegram-desktop; # Added 2023-04-07
  tdom = tclPackages.tdom; # Added 2024-10-02
  teamspeak_client = teamspeak3; # Added 2024-11-07
  teamspeak5_client = teamspeak6-client; # Added 2025-01-29
  terminus-nerdfont = lib.warnOnInstantiate "terminus-nerdfont is redundant. Use nerd-fonts.terminess-ttf instead." nerd-fonts.terminess-ttf; # Added 2024-11-10
  tepl = libgedit-tepl; # Added 2024-04-29
  testVersion = testers.testVersion; # Added 2022-04-20
  tezos-rust-libs = ligo; # Added 2025-06-03
  tfplugindocs = terraform-plugin-docs; # Added 2023-11-01
  invalidateFetcherByDrvHash = testers.invalidateFetcherByDrvHash; # Added 2022-05-05
  tix = tclPackages.tix; # Added 2024-10-02
  tkcvs = tkrev; # Added 2022-03-07
  tkimg = tclPackages.tkimg; # Added 2024-10-02
  tlaplusToolbox = tlaplus-toolbox; # Added 2025-08-21
  tokyo-night-gtk = tokyonight-gtk-theme; # Added 2024-01-28
  tomcat_connectors = apacheHttpdPackages.mod_jk; # Added 2024-06-07
  tooling-language-server = deputy; # Added 2025-06-22
  tor-browser-bundle-bin = tor-browser; # Added 2023-09-23
  transmission = lib.warnOnInstantiate (transmission3Warning { }) transmission_3; # Added 2024-06-10
  transmission-gtk = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-gtk";
  }) transmission_3-gtk; # Added 2024-06-10
  transmission-qt = lib.warnOnInstantiate (transmission3Warning {
    suffix = "-qt";
  }) transmission_3-qt; # Added 2024-06-10
  treefmt2 = lib.warnOnInstantiate "treefmt2 has been renamed to treefmt" treefmt; # 2025-03-06
  libtransmission = lib.warnOnInstantiate (transmission3Warning {
    prefix = "lib";
  }) libtransmission_3; # Added 2024-06-10
  LPCNet = lpcnet; # Added 2025-05-05
  tracker = lib.warnOnInstantiate "tracker has been renamed to tinysparql" tinysparql; # Added 2024-09-30
  tracker-miners = lib.warnOnInstantiate "tracker-miners has been renamed to localsearch" localsearch; # Added 2024-09-30
  transfig = fig2dev; # Added 2022-02-15
  transifex-client = transifex-cli; # Added 2023-12-29
  trezor_agent = trezor-agent; # Added 2024-01-07
  trilium-next-desktop = trilium-desktop; # Added 2025-08-30
  trilium-next-server = trilium-server; # Added 2025-08-30
  trust-dns = hickory-dns; # Added 2024-08-07
  tvbrowser-bin = tvbrowser; # Added 2023-03-02
  typst-fmt = typstfmt; # Added 2023-07-15

  ### U ###

  uade123 = uade; # Added 2022-07-30
  ubuntu_font_family = ubuntu-classic; # Added 2024-02-19
  uclibc = uclibc-ng; # Added 2022-06-16
  unifi-poller = unpoller; # Added 2022-11-24
  ut2004demo = ut2004Packages; # Added 2024-11-24
  util-linuxCurses = util-linux; # Added 2022-04-12
  utillinux = util-linux; # Added 2020-11-24, keep until node2nix is phased out, see https://github.com/NixOS/nixpkgs/issues/229475

  ### V ###

  vamp = {
    vampSDK = vamp-plugin-sdk;
  }; # Added 2020-03-26
  vaapiIntel = intel-vaapi-driver; # Added 2023-05-31
  vaapiVdpau = libva-vdpau-driver; # Added 2024-06-05
  vaultwarden-vault = vaultwarden.webvault; # Added 2022-12-13
  vdirsyncerStable = vdirsyncer; # Added 2020-11-08, see https://github.com/NixOS/nixpkgs/issues/103026#issuecomment-723428168
  ventoy-bin = ventoy; # Added 2023-04-12
  ventoy-bin-full = ventoy-full; # Added 2023-04-12
  verilog = iverilog; # Added 2024-07-12
  veriT = verit; # Added 2025-08-21
  ViennaRNA = viennarna; # Added 2023-08-23
  vimHugeX = vim-full; # Added 2022-12-04
  vim_configurable = vim-full; # Added 2022-12-04
  vistafonts = vista-fonts; # Added 2025-02-03
  vistafonts-chs = vista-fonts-chs; # Added 2025-02-03
  vistafonts-cht = vista-fonts-cht; # Added 2025-02-03
  vkBasalt = vkbasalt; # Added 2022-11-22
  vkdt-wayland = vkdt; # Added 2024-04-19
  vtk_9 = lib.warnOnInstantiate "'vtk_9' has been renamed to 'vtk_9_5'" vtk_9_5; # Added 2025-07-18
  vtk_9_egl = lib.warnOnInstantiate "'vtk_9_5' now build with egl support by default, so `vtk_9_egl` is deprecated, consider using 'vtk_9_5' instead." vtk_9_5; # Added 2025-07-18

  ### W ###
  wakatime = wakatime-cli; # 2024-05-30
  wapp = tclPackages.wapp; # Added 2024-10-02
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_100;
  webfontkitgenerator = webfont-bundler; # Added 2025-07-27
  whatsapp-for-linux = wasistlos; # Added 2025-01-30
  wineWayland = wine-wayland;
  win-virtio = virtio-win; # Added 2023-10-17
  wkhtmltopdf-bin = wkhtmltopdf; # Added 2024-07-17
  wlroots = wlroots_0_19; # wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  wordpress6_5 = wordpress_6_5; # Added 2024-08-03
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name
  wpa_supplicant_ro_ssids = lib.warnOnInstantiate "Deprecated package: Please use wpa_supplicant instead. Read-only SSID patches are now upstream!" wpa_supplicant;
  wmii_hg = wmii;
  wrapGAppsHook = wrapGAppsHook3; # Added 2024-03-26
  write_stylus = styluslabs-write-bin; # Added 2024-10-09
  wxGTK33 = wxwidgets_3_3; # Added 2025-07-20

  ### X ###

  xdragon = dragon-drop; # Added 2025-03-22
  xinput_calibrator = xinput-calibrator; # Added 2025-08-28
  xmlada = gnatPackages.xmlada; # Added 2024-02-25
  xonsh-unwrapped = python3Packages.xonsh; # Added 2024-06-18
  xulrunner = firefox-unwrapped; # Added 2023-11-03
  xwaylandvideobridge = makePlasma5Throw "xwaylandvideobridge"; # Added 2024-09-27

  ### Y ###

  yafaray-core = libyafaray; # Added 2022-09-23
  yabar-unstable = yabar; # Added 2025-06-10

  ### Z ###

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
  zigbee2mqtt_2 = zigbee2mqtt; # Added 2025-08-11
  zinc = zincsearch; # Added 2023-05-28
  zint = zint-qt; # Added 2025-05-15
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
