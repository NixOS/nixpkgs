lib: self: super:

### Deprecated aliases - for backward compatibility
### Please maintain this list in ASCIIbetical ordering.

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

  deprecatedPlasma5Packages = [
    "akonadi-calendar"
    "akonadi-calendar-tools"
    "akonadi-contacts"
    "akonadi-import-wizard"
    "akonadi-mime"
    "akonadi-notes"
    "akonadi-search"
    "akonadiconsole"
    "alligator"
    "analitza"
    "angelfish"
    "applet-window-appmenu"
    "applet-window-buttons"
    "audiotube"
    "aura-browser"
    "baloo-widgets"
    "bismuth"
    "booth"
    "buho"
    "calendarsupport"
    "calindori"
    "cantor"
    "clip"
    "communicator"
    "dolphin-plugins"
    "eventviews"
    "extra-cmake-modules"
    "flatpak-kcm"
    "ghostwriter"
    "grantleetheme"
    "incidenceeditor"
    "index"
    "isoimagewriter"
    "juk"
    "kaccounts-integration"
    "kaccounts-providers"
    "kalarm"
    "kalgebra"
    "kalk"
    "kamoso"
    "kasts"
    "kbreakout"
    "kcalutils"
    "kclock"
    "kde-inotify-survey"
    "kde2-decoration"
    "kdebugsettings"
    "kdeconnect-kde"
    "kdecoration"
    "kdegraphics-mobipocket"
    "kdegraphics-thumbnailers"
    "kdenetwork-filesharing"
    "kdepim-runtime"
    "keysmith"
    "kgeography"
    "khotkeys"
    "kidentitymanagement"
    "kimap"
    "kio-admin"
    "kio-extras"
    "kio-gdrive"
    "kipi-plugins"
    "kirigami-gallery"
    "kldap"
    "kmahjongg"
    "kmail-account-wizard"
    "kmailtransport"
    "kmbox"
    "kmime"
    "kmousetool"
    "knotes"
    "koko"
    "kolf"
    "kongress"
    "konqueror"
    "konquest"
    "kontactinterface"
    "kopeninghours"
    "kosmindoormap"
    "kpat"
    "kpimtextedit"
    "kpipewire"
    "kpmcore"
    "kpublictransport"
    "kqtquickcharts"
    "krecorder"
    "kreport"
    "kruler"
    "ksanecore"
    "ksmtp"
    "kspaceduel"
    "ksudoku"
    "ksystemstats"
    "ktnef"
    "ktrip"
    "kweather"
    "kzones"
    "layer-shell-qt"
    "libgravatar"
    "libkcddb"
    "libkdcraw"
    "libkdegames"
    "libkdepim"
    "libkexiv2"
    "libkgapi"
    "libkipi"
    "libkleo"
    "libkmahjongg"
    "libkomparediff2"
    "libksane"
    "libkscreen"
    "libksieve"
    "libksysguard"
    "libktorrent"
    "lightly"
    "mailcommon"
    "mailimporter"
    "mauikit"
    "mauikit-accounts"
    "mauikit-calendar"
    "mauikit-documents"
    "mauikit-filebrowsing"
    "mauikit-imagetools"
    "mauikit-terminal"
    "mauikit-texteditor"
    "mauiman"
    "mbox-importer"
    "messagelib"
    "oxygen-sounds"
    "palapeli"
    "parachute"
    "partitionmanager"
    "pim-data-exporter"
    "pim-sieve-editor"
    "pimcommon"
    "plank-player"
    "plasma-bigscreen"
    "plasma-dialer"
    "plasma-disks"
    "plasma-firewall"
    "plasma-pass"
    "plasma-phonebook"
    "plasma-remotecontrollers"
    "plasma-sdk"
    "plasma-settings"
    "plasma-welcome"
    "plasmatube"
    "polkit-kde-agent"
    "print-manager"
    "qmlkonsole"
    "rocs"
    "shelf"
    "sierra-breeze-enhanced"
    "soundkonverter"
    "station"
    "telly-skout"
    "tokodon"
    "umbrello"
    "vvave"
    "xwaylandvideobridge"
    "neochat" # Added 2025-07-04
    "itinerary" # Added 2025-07-04
    "libquotient" # Added 2025-07-04
    "kexi" # Added 2025-08-21
    "qtwebengine" # Added 2026-01-15
    "qtwebview" # Added 2026-04-03
  ];

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

  plasma5Throws = mapAliases (lib.genAttrs deprecatedPlasma5Packages makePlasma5Throw);

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
  llvmPackages_latest = llvmPackages_22;
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
  utfcpp = utf8cpp; # Added 2026-04-02. preserve, reason: Upstream calls it `utfcpp`, but `utf8cpp` is as common as `utfcpp` in other distros, see https://repology.org/project/utfcpp/information
  wlroots = wlroots_0_20; # preserve, reason: wlroots is unstable, we must keep depending on 'wlroots_0_*', convert to package after a stable(1.x) release
  wormhole-rs = magic-wormhole-rs; # Added 2022-05-30. preserve, reason: Arch package name, main binary name

  # keep-sorted start case=no numeric=yes block=yes

  _9pfs = throw "'9pfs' was removed as it is unmaintained and depends on fuse2, which is deprecated"; # Added 2026-06-05
  _86Box = warnAlias "'_86Box' has been renamed to '_86box'" _86box; # Added 2026-02-08
  _86Box-with-roms = warnAlias "'_86Box-with-roms' has been renamed to '_86box-with-roms'" _86box-with-roms; # Added 2026-02-08
  abbreviate = throw "'abbreviate' has been removed, as it has been unmaintained upstream since July 2024"; # Added 2026-01-01
  acd-cli = throw "adc-cli has been removed as it was unmaintained"; # Added 2026-05-02
  adjustor = throw "adjustor has been removed as it part of the 'handheld-daemon' package"; # Added 2025-11-16
  aefs = throw "'aefs' has been removed, as it depends on unsupported fuse2 and unmaintained upstream"; # Added 2026-05-30
  afuse = throw "'afuse' has been removed as it is unmaintained upstream, and depends on fuse2, which is deprecated"; # Added 2026-05-05
  agrep = throw "'agrep' has been removed due to lack of upstream maintenance. Consider using 'tre' or 'ugrep' instead."; # Added 2025-12-28
  alexandria = throw "'alexandria' has been removed as it was unmaintained upstream and depended on webkitgtk 4.0 and libsoup 2.4 via Tauri v1"; # Added 2026-06-07
  amazon-ecs-cli = throw "'amazon-ecs-cli' has been removed due to being unmaintained upstream"; # Added 2026-01-19
  AMB-plugins = warnAlias "'AMB-plugins' has been renamed to/replaced by 'amb-plugins'" amb-plugins; # Converted to warning 2026-07-01
  anew = throw "'anew' has been removed, as it has been unmaintained upstream since March 2022"; # Added 2026-01-01
  anime-downloader = throw "'anime-downloader' has been removed as it was broken and unmaintained. Consider using 'animdl' instead"; # Added 2026-05-03
  anonymousPro = warnAlias "'anonymousPro' has been renamed to/replaced by 'anonymous-pro-fonts'" anonymous-pro-fonts; # Converted to warning 2026-07-01
  ansible_2_16 = throw "ansible_2_16 has been removed, as it is EOL"; # Added 2025-11-10
  ansible_2_17 = throw "ansible_2_17 has been removed, as it is EOL"; # Added 2025-11-10
  ansible_2_18 = throw "ansible_2_18 has been removed; use overridePythonAttrs if you need a specific version"; # Added 2025-11-10
  ansible_2_19 = throw "ansible_2_19 has been removed; use overridePythonAttrs if you need a specific version"; # Added 2025-11-10
  antibody = throw "antibody has been removed because it was deprecated and archived upstream. Consider using antidote instead"; # Added 2026-01-16
  apmplanner2 = throw "'apmplanner2' has been removed as it depends on insecure&unmaintained qtwebkit"; # Added 2026-04-26
  archi = throw "'archi' has been removed, since its upstream maintainers do not want it packaged"; # Added 2025-11-18
  ArchiSteamFarm = warnAlias "ArchiSteamFarm has been renamed to/replaced by 'archisteamfarm'" archisteamfarm; # Added 2026-01-31
  archiver = throw "archiver has been removed, as it has been unmaintained upstream since November 2024"; # Added 2026-01-15
  arduinoOTA = warnAlias "'arduinoOTA' has been renamed to 'arduino-ota'" arduino-ota; # Added 2026-02-08
  artha = throw "'artha' has been removed, as the packaged GTK 2 application is unmaintained upstream. Consider using 'wordnet' instead."; # Added 2026-05-22
  artichoke = throw "artichoke has been removed due to being archived upstream."; # Added 2025-11-04
  artim-dark = warnAlias "'artim-dark' has been renamed to/replaced by 'aritim-dark'" aritim-dark; # Converted to warning 2026-07-01
  artyFX = warnAlias "'artyFX' has been renamed to/replaced by 'openav-artyfx'" openav-artyfx; # Converted to warning 2026-07-01
  asciinema-automation = throw "'asciinema-automation' has been removed as it doesn't work with asciinema version 3+"; # Added 2026-05-07
  asciinema_3 = warnAlias "'asciinema_3' has been renamed to 'asciinema'" asciinema; # Added 2026-05-07
  asio_1_10 = throw "'asio_1_10' has been removed as it is outdated and unused. Use 'asio' instead"; # Added 2025-12-03
  astronomer = throw "'astronomer' has been removed, as it has been unmaintained upstream since August 2020"; # Added 2026-01-01
  atlassian-cli = warnAlias "'atlassian-cli' has been renamed to/replaced by 'appfire-cli'" appfire-cli; # Converted to warning 2026-07-01
  audio-recorder = throw "'audio-recorder' has been removed, as it is unmaintained upstream and broken. Consider using 'gnome-sound-recorder' or 'reco' instead"; # Added 2026-01-02
  august = throw "'august' has been removed, as it has been unmaintained since august 2023"; # Added 2025-12-25
  autoconf271 = throw "'autoconf271' has been removed in favor of 'autoconf'"; # Added 2026-03-29
  autoreconfHook271 = throw "'autoreconfHook271' has been removed in favor of 'autoreconfHook'"; # Added 2026-03-29
  avocode = throw "'avocode' has been removed as it was sunset in October 2023"; # Added 2026-05-27
  aws-shell = throw "'aws-shell' has been removed because it is unmaintained upstream"; # Added 2026-01-18
  aws_mturk_clt = throw "'aws_mturk_clt' has been removed due to being unmaintained upstream. Use 'awscli' with 'mturk' subcommands instead."; # Added 2026-01-19
  b43FirmwareCutter = warnAlias "'b43FirmwareCutter' has been renamed to 'b43-fwcutter'" b43-fwcutter; # Added 2026-02-08
  banana-vera = throw "'banana-vera' has been removed as it relies on python3.10"; # Added 2026-02-09
  banking = warnAlias "'banking' has been renamed to/replaced by 'saldo'" saldo; # Converted to warning 2026-07-01
  basedmypy = throw "basedmypy has been deprecated by upstream. Use instead 'basedpyright' or 'ty'"; # added 2026-02-03
  bashSnippets = warnAlias "'bashSnippets' has been renamed to 'bash-snippets'" bash-snippets; # Added 2026-02-08
  bencode = throw "'bencode' has been removed because it is unmaintained upstream"; # Added 2026-04-09
  bfr = throw "bfr has been removed, did not update since 2004, fails to build on gcc-15, no homepage"; # Added 2026-01-28
  biff = throw "biff has been renamed to/replaced by 'bttf'"; # Added 2026-06-04
  binserve = throw "'binserve' has been removed because it is unmaintained upstream."; # Added 2025-11-29
  bkyml = throw "''bkyml' has been removed due to a lack of upstream maintainance"; # Added 2026-06-16
  blackbox = throw "'blackbox' has been removed since it has been deprecated and archived upstream. Consider using pass instead"; # Added 2026-01-16
  blender-hip = throw "blender-hip has been removed in favor of setting `config.rocmSupport = true` or using `pkgsRocm.blender`"; # Added 2026-01-04
  blueberry = throw "'blueberry' has been removed as it is unmaintained upstream. Consider using blueman instead"; # Added 2026-03-09
  bob = throw "'bob' has been removed as it is unmaintained upstream and has vulnerable dependencies."; # Added 2025-12-29
  bodyclose = throw "'bodyclose' has been removed because it was broken for an entire release cycle."; # Added 2026-05-31
  boost177 = throw "Boost 1.77 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2026-04-20
  botamusique = throw "botamusique has been removed as upstream stopped maintenance"; # Added 2026-06-28
  boxfs = throw "'boxfs' has been removed, as it depends on unsupported fuse2 and unmaintained upstream"; # Added 2026-05-30
  breads-ad = throw "'breads-ad' has been removed because its source is no longer available"; # Added 2025-12-20
  break-time = throw "'break-time' has been removed because it is not maintained upstream and has insecure dependencies."; # Added 2025-12-01
  brogue = throw "'brogue' has been renamed to/replaced by 'brogue-ce'"; # Converted to throw 2026-07-01
  btanks = throw "'btanks' has been removed as it's been unmaintained since 2010 and fails to build"; # Added 2025-11-29
  buck = throw "'buck' has been removed has it was deprecated and archived upstream. Consider moving to buck2"; # Added 2026-01-16
  budgie-screensaver = throw "'budgie-screensaver' has been removed, no longer used by budgie-desktop."; # Added 2025-11-19
  buildFHSEnvChroot = throw "'buildFHSEnvChroot' is deprecated, please use 'buildFHSEnv'"; # Added 2026-05-21
  buildPlatform = throw "'buildPlatform' has been renamed to/replaced by 'stdenv.buildPlatform'"; # Converted to throw 2026-07-01
  bullet-roboschool = throw "'bullet-roboschool' has been removed as its build was broken and it was deprecated with its last update in 2019."; # Added 2025-11-15
  bzip2_1_1 = throw "'bzip2_1_1' has been removed as it was an unmaintained 2020 snapshot with no remaining users; use 'bzip2' instead"; # Added 2026-05-31
  c0 = throw "'c0' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  caddyfile-language-server = throw "'caddyfile-language-server' has been removed as it is unmaintained upstream"; # Added 2026-06-17
  caido = warnAlias "'caido' has been split into 'caido-cli' and 'caido-desktop'." caido-desktop; # Added 2026-03-03
  cargo-raze = throw "'cargo-raze' has been removed, as it is unmaintained"; # Added 2026-05-04
  cargo-sync-readme = throw "'cargo-sync-readme' has been removed because upstream 404s"; # Converted to throw 2025-12-18
  cargo-tauri_1 = throw "'cargo-tauri_1' has been removed as it required webkitgtk 4.0 and libsoup 2.4"; # Added 2026-06-07
  carp = throw "'carp' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  catfs = throw "'catfs' has been removed as it was unmaintained upstream"; # Added 2026-05-31
  catnip-gtk4 = throw "'catnip-gtk4' has been removed, as it has been unmaintained upstream since June 2023, use cavasik or cavalier instead"; # Added 2026-01-01
  cb2bib = throw "'cb2bib' has been removed as it depends on insecure&unmaintained qtwebkit"; # Added 2026-04-26
  cdktf-cli = warnAlias "'cdktf-cli' has been renamed to/replaced by 'cdktn-cli'" cdktn-cli; # Added 2026-02-18
  cdparanoiaIII = warnAlias "'cdparanoiaIII' has been renamed to/replaced by 'cdparanoia-iii'" cdparanoia-iii; # Converted to warning 2026-07-01
  cdwe = throw "'cdwe' has been removed, as it has been unmaintained upstream since June 2023"; # Added 2026-01-01
  cedille = throw "'cedille' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  cgit-pink = throw "cgit-pink has been removed, as it is unmaintained upstream"; # Added 2026-01-21
  charis-sil = throw "'charis-sil' has renamed to/replaced by 'charis'"; # Added 2025-12-01
  charybdis = throw "charybdis was removed since its upstream repo was archived in 2021"; # Added 2026-01-13
  chatbox = throw "chatbox was removed for bundling a vastly end-of-life electron version"; # Added 2026-05-30
  chatmcp = throw "chatmcp has been removed, as it is unmaintained"; # Added 2026-04-09
  chemtool = throw "'chemtool' has been removed, as it is unmaintained upstream and depends on GTK 2. Consider using 'avogadro2' instead."; # Added 2026-05-22
  chit = throw "'chit' has been removed from nixpkgs because it was unmaintained upstream and used insecure dependencies"; # Added 2025-11-28
  chromium-xorg-conf = throw "'chromium-xorg-conf' has been removed as it was only used by the 'cmt' NixOS module, which was removed"; # Added 2026-05-25
  cinnamon-common = warnAlias "'cinnamon-common' has been renamed to/replaced by 'cinnamon'" cinnamon; # Converted to warning 2026-07-01
  ciopfs = throw "'ciopfs' has been removed due to lack of fuse 3 support."; # Added 2026-06-05
  cisco-packet-tracer_8 = throw "'cisco-packet-tracer_8' has been removed as it vendored qt5 webengine. Consider updating to 'cisco-packet-tracer_9' instead."; # Added 2026-04-26
  ciscoPacketTracer7 = throw "'ciscoPacketTracer7' has been removed in favor of 'cisco-packet-tracer_8' and 'cisco-packet-tracer_9'"; # Added 2026-02-08
  ciscoPacketTracer8 = warnAlias "'ciscoPacketTracer8' has been renamed to/replaced by 'cisco-packet-tracer_8'" cisco-packet-tracer_8; # Converted to warning 2026-07-01
  ciscoPacketTracer9 = warnAlias "'ciscoPacketTracer9' has been renamed to/replaced by 'cisco-packet-tracer_9'" cisco-packet-tracer_9; # Converted to warning 2026-07-01
  citrix_workspace = warnAlias "'citrix_workspace' has been renamed to 'citrix-workspace'" citrix-workspace; # Added 2026-06-17
  citrix_workspace_23_11_0 = throw "'citrix_workspace_23_11_0' has been removed because it has reached EOL."; # Added 2025-11-25
  citrix_workspace_24_02_0 = throw "'citrix_workspace_24_02_0' has been removed because it has reached EOL."; # Added 2025-11-25
  citrix_workspace_24_05_0 = throw "'citrix_workspace_24_05_0' has been removed because it depended on the removed webkitgtk_4_0."; # Added 2025-11-25
  citrix_workspace_24_08_0 = throw "'citrix_workspace_24_08_0' has been removed because it depended on the removed webkitgtk_4_0."; # Added 2025-11-25
  citrix_workspace_24_11_0 = throw "'citrix_workspace_24_11_0' has been removed because it depended on the removed webkitgtk_4_0."; # Added 2025-11-25
  citrix_workspace_25_03_0 = throw "'citrix_workspace_25_03_0' has been removed because it depended on the removed webkitgtk_4_0."; # Added 2025-11-25
  citrix_workspace_25_05_0 = throw "'citrix_workspace_25_05_0' has been removed because it depended on the removed webkitgtk_4_0."; # Added 2025-11-25
  citrix_workspace_25_08_10 = throw "'citrix_workspace_25_08_10' has been removed because it depended on libsoup 2.4. Use 'citrix-workspace' instead."; # Added 2026-06-08
  citrix_workspace_26_01_0 = throw "'citrix_workspace_26_01_0' has been removed because it depended on libsoup 2.4. Use 'citrix-workspace' instead."; # Added 2026-06-08
  citrix_workspace_26_04_0 = warnAlias "'citrix_workspace_26_04_0' has been renamed to 'citrix-workspace'" citrix-workspace; # Added 2026-06-17
  citron-emu = throw "citron-emu was discontinued in february 2026"; # added 2026-02-19
  clashmi = throw "'clashmi' has been removed, as it is unmaintained in nixpkgs"; # Added 2026-01-31
  classads = throw "'classads' has been removed, as it is unmaintained both upstream and in nixpkgs"; # Added 2026-06-27
  claude-code-acp = warnAlias "'claude-code-acp' has been renamed to 'claude-agent-acp'" claude-agent-acp; # Added 2026-03-31
  claude-code-bin = warnAlias "'claude-code-bin' has been merged into 'claude-code'" claude-code; # Added 2026-04-18
  clearlyU = warnAlias "'clearlyU' has been renamed to/replaced by 'clearly-u'" clearly-u; # Converted to warning 2026-07-01
  clima = throw "'clima' has been removed, as it has been unmaintained upstream since December 2024, use glow instead"; # Added 2026-01-01
  clipgrab = throw "'clipgrab' has been removed, as it was unmaintained in nixpkgs since 2022 and depended on vulnerable qt5 webengine."; # Added 2026-02-11
  clipit = throw "'clipit' has been removed as it is unmaintained upstream and broken"; # Added 2026-05-16
  clorinde = throw "'clorinde' has been merged into 'cornucopia'"; # Added 2026-06-03
  clucene_core = warnAlias "'clucene_core' has been renamed to 'clucene-core'" clucene-core; # Added 2026-01-12
  clucene_core_2 = warnAlias "'clucene_core_2' has been renamed to 'clucene-core_2'" clucene-core_2; # Added 2026-01-12
  cmtk = throw "'cmtk' has been dropped due to being broken since September 2025, with no complaints by any users of the package."; # Added 2026-04-05
  coc-cmake = throw "'coc-cmake' has been removed, as it required pnpm 8 (EOL) and its upstream lockfile is incompatible with newer pnpm"; # Added 2026-06-10
  coc-sumneko-lua = throw "'coc-sumneko-lua' has been removed due to unmaintained and broken package. 'lua_ls' can be used as a replacement"; # Added 2026-02-04
  commonsBcel = warnAlias "'commonsBcel' has been renamed to 'commons-bcel'" commons-bcel; # Added 2026-02-08
  commonsBsf = warnAlias "'commonsBsf' has been renamed to 'commons-bsf'" commons-bsf; # Added 2026-02-08
  commonsCompress = warnAlias "'commonsCompress' has been renamed to 'commons-compress'" commons-compress; # Added 2026-02-08
  commonsDaemon = warnAlias "'commonsDaemon' has been renamed to 'commons-daemon'" commons-daemon; # Added 2026-02-08
  commonsFileUpload = warnAlias "'commonsFileUpload' has been renamed to 'commons-fileupload'" commons-fileupload; # Added 2026-02-08
  commonsIo = warnAlias "'commonsIo' has been renamed to 'commons-io'" commons-io; # Added 2026-02-08
  commonsLang = warnAlias "'commonsLang' has been renamed to 'commons-lang'" commons-lang; # Added 2026-02-08
  commonsLogging = warnAlias "'commonsLogging' has been renamed to 'commons-logging'" commons-logging; # Added 2026-02-08
  commonsMath = warnAlias "'commonsMath' has been renamed to 'commons-math'" commons-math; # Added 2026-02-08
  computecpp = throw "'computecpp' has been removed because its source has been pulled"; # Added 2025-12-20
  computecpp-unwrapped = throw "'computecpp-unwrapped' has been removed because its source has been pulled"; # Added 2025-12-20
  copilot-cli = throw "'copilot-cli' was removed due to upstream end-of-life."; # Added 2026-05-11
  copilot-language-server-fhs = throw "'copilot-language-server-fhs' has been renamed to/replaced by 'copilot-language-server'"; # Converted to throw 2026-07-01
  coreth = throw "'coreth' has been moved to 'avalanchego' by upstream"; # Added 2026-01-15
  cpr = warnAlias "'cpr' has been renamed to/replaced by 'libcpr'" libcpr; # Added 2025-11-17
  cqrlog = throw "'cqrlog' was removed due to lack of maintenance and relying on gtk2"; # Added 2025-12-02
  crabfit-api = throw "'crabfit-api' has been removed because it is unmaintained upstream and insecure."; # Added 2025-11-29
  crabfit-frontend = throw "'crabfit-frontend' has been removed because it is unmaintained upstream and it is to be used with 'crabfit-api', which is insecure."; # Added 2025-11-29
  credslayer = throw "'credslayer' has been removed as it was broken for 2 years"; # Added 2026-05-20
  cringify = throw "'cringify' has been removed as it is unmaintained"; # Added 2025-12-16
  criticality-score = throw "'criticality-score' has been removed, as it is unmaintained upstream"; # Added 2026-02-18
  cromfs = throw "'cromfs' has been removed due to lack of fuse 3 support. You can try replacing it with dwarfs: https://github.com/mhx/dwarfs#with-cromfs"; # Added 2026-06-05
  csslint = throw "'csslint' has been removed as upstream considers it abandoned."; # Addeed 2025-11-07
  ctpp2 = throw "'ctpp2' has been removed due to lack of maintenance."; # Added 2025-12-31
  cup-docker = throw "'cup-docker' has been removed, due to being orphaned and packaged in an unreproducible manner"; # Added 2026-06-27
  cup-docker-noserver = throw "'cup-docker-noserver' has been removed, due to being orphaned and packaged in an unreproducible manner"; # Added 2026-06-27
  cura = throw "'cura' has been removed, as it was unmaintained in nixpkgs"; # Added 2026-05-22
  curaengine = throw "'curaengine' has been removed, as it was unmaintained in nixpkgs"; # Added 2026-05-22
  curaPlugins = throw "'curaPlugins' has been removed, as it was unmaintained in nixpkgs"; # Added 2026-05-22
  curl-impersonate-chrome = warnAlias "curl-impersonate-chrome has been renamed to curl-impersonate" curl-impersonate; # Added 2025-11-02
  curl-impersonate-ff = throw "curl-impersonate-ff has been removed because it is unmaintained upstream and has vulnerable dependencies. Use curl-impersonate instead."; # Added 2025-11-02
  curlftpfs = throw "'curlftpfs' has been removed due to lack of fuse 3 support."; # Added 2026-06-05
  curlHTTP3 = throw "'curlHTTP3' has been renamed to/replaced by 'curl'"; # Converted to throw 2026-07-01
  cvemap = warnAlias "'cvemap' has been renamed to/replaced by 'vulnx'" vulnx; # Converted to warning 2026-07-01
  cwe-client-cli = throw "cwe-client-cli has been removed because it is archived and has unclear licensing"; # Added 2026-01-10
  darkly-qt5 = throw "'darkly-qt' has been removed due to outdated KF5 dependencies"; # Added 2026-05-01
  deco = throw "'deco' has been removed as it is unused"; # Added 2025-12-18
  defuddle-cli = warnAlias "defuddle-cli has been renamed to/replaced by 'defuddle'" defuddle; # Added 2026-04-16
  deltatouch = throw "'deltatouch' has been removed as it depended on qt5 webengine which reached EOL"; # Added 2026-04-25
  desktop-postflop = throw "'desktop-postflop' has been removed as it has been unmaintained upstream since October 2023 and depended on webkitgtk 4.0"; # Added 2026-06-07
  discord-screenaudio = throw "discord-screenaudio has been removed because it was archived upstream. Use vesktop instead."; # added 2025-11-29
  DisnixWebService = warnAlias "'DisnixWebService' has been renamed to 'disnix-web-service'" disnix-web-service; # Added 2026-01-14
  djmount = throw "'djmount' has been removed as it is no longer maintained"; # Added 2026-05-19
  docker_28 = throw "'docker_28' has been removed because it has been unmaintained since November 2025. Use docker_29 or newer instead."; # Added 2026-05-18
  dockerfile-language-server-nodejs = throw "'dockerfile-language-server-nodejs' has been renamed to/replaced by 'dockerfile-language-server'"; # Converted to throw 2026-07-01
  doctave = throw "'doctave' has been removed as it has been unmaintained upstream since April 2022"; # Added 2026-02-07
  docui = throw "'docui' has removed as it was deprecated and archived upstream. Consider using lazydocker instead"; # Added 2026-01-16
  dogdns = throw "'dogdns' has been removed as it is unmaintained upstream and vendors insecure dependencies. Consider switching to 'doggo', a similar tool."; # Added 2025-12-31
  done = throw "'done' has been removed as it was marked discontinued upstream since April 2024"; # Added 2026-02-07
  dontgo403 = throw "`dontgo403` has been renamed to `nomore403`"; # Added 2026-05-24
  dontRecurseIntoAttrs = throw "'dontRecurseIntoAttrs' has been renamed to/replaced by 'lib.dontRecurseIntoAttrs'"; # Converted to throw 2026-07-01
  dotnetfx35 = throw "'dotnetfx35' has been removed because it was unmaintained in Nixpkgs"; # Added 2026-01-27
  dotnetfx40 = throw "'dotnetfx40' has been removed because it was unmaintained in Nixpkgs"; # Added 2026-01-27
  duckstation = throw "'duckstation' has been removed following upstream request. Please use the appimage instead"; # Added 2026-03-14
  duckstation-bin = warnAlias "'duckstation-bin' has been renamed to/replaced by 'duckstation'" duckstation; # Converted to warning 2026-07-01
  dune_1 = throw "'dune_1' has been removed"; # Added 2025-11-13
  e17gtk = throw "'e17gtk' has been removed because it was archived upstream."; # Added 2026-01-15
  e-search = throw "'e-search' has been removed due to outdated KF5 dependencies"; # Added 2026-05-01
  eagle = throw "'eagle' has been removed because official support ends 2026-06-07. It depended on qt5 webengine, which was removed for its numerous security issues. For more details, see the autodesk announcement at https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Autodesk-EAGLE-Announcement-Next-steps-and-FAQ.html"; # Added 2026-04-26
  ebpf-verifier = warnAlias "'ebpf-verifier' has been renamed to 'prevail'" prevail; # Added 2026-04-01
  ecryptfs = throw "'ecryptfs' has been removed due to lack of maintenance. Consider using 'fscrypt', 'gocryptfs' or 'cryfs' instead."; # Added 2026-01-14
  edid-decode = warnAlias "'edid-decode' has been renamed to/replaced by 'v4l-utils'" v4l-utils; # Converted to warning 2026-07-01
  electron-chromedriver_35 = throw "electron-chromedriver_35 has been removed in favor of newer versions"; # Added 2025-11-10
  electron-chromedriver_36 = throw "electron-chromedriver_36 has been removed in favor of newer versions"; # Added 2026-02-02
  electron-chromedriver_37 = throw "electron-chromedriver_37 has been removed in favor of newer versions"; # Added 2026-03-20
  electron_35 = throw "electron_35 has been removed in favor of newer versions"; # Added 2025-11-06
  electron_35-bin = throw "electron_35-bin has been removed in favor of newer versions"; # Added 2025-11-06
  electron_36 = throw "electron_36 has been removed in favor of newer versions"; # Added 2026-02-02
  electron_36-bin = throw "electron_36-bin has been removed in favor of newer versions"; # Added 2026-02-02
  electron_37 = throw "electron_37 has been removed in favor of newer versions"; # Added 2026-03-20
  electron_37-bin = throw "electron_37-bin has been removed in favor of newer versions"; # Added 2026-03-20
  elixir = warnAlias "'elixir' is deprecated in favor of using the beamPackages sets. Use 'beamPackages.elixir' instead." beamPackages.elixir; # added 2026-06-15
  elixir_1_15 = throw "'elixir_1_15' has been removed, due to the removal of erlang_26 as EOL"; # added 2026-04-01
  elixir_1_16 = throw "'elixir_1_16' has been removed, due to the removal of erlang_26 as EOL"; # added 2026-04-01
  elixir_1_17 = warnAlias "'elixir_1_17' is deprecated in favor of using the beamPackages sets. Use 'beamPackages.elixir_1_17' instead." beamPackages.elixir_1_17; # added 2026-06-15
  elixir_1_18 = warnAlias "'elixir_1_18' is deprecated in favor of using the beamPackages sets. Use 'beamPackages.elixir_1_18' instead." beamPackages.elixir_1_18; # added 2026-06-15
  elixir_1_19 = warnAlias "'elixir_1_19' is deprecated in favor of using the beamPackages sets. Use 'beamPackages.elixir_1_19' instead." beamPackages.elixir_1_19; # added 2026-06-15
  emem = throw "'emem' has been removed as it is unused"; # Added 2025-12-18
  emojione = throw "emojione has beem removed, as it has been archived upstream."; # Added 2025-11-06
  encfs = throw "'encfs' has been removed as it depends on fuse2, which is deprecated"; # Added 2026-05-05
  enchant2 = warnAlias "'enchant2' has been renamed to 'enchant_2'" enchant_2; # Added 2026-01-14
  encodings = warnAlias "'encodings' has been renamed to/replaced by 'font-encodings'" font-encodings; # Converted to warning 2026-07-01
  epick = throw "'epick' has been removed as it has been unmaintained upstream since November 2022"; # Added 2026-02-07
  erlang = warnAlias "'erlang' is deprecated in favor of using the beamPackages sets. Use 'beamPackages.erlang' instead." beamPackages.erlang; # added 2026-06-15
  erlang_26 = throw "'erlang_26' has been removed, as it is EOL"; # added 2026-04-01
  erlang_27 = warnAlias "'erlang_27' is deprecated in favor of using the beamPackages sets. Use 'beam27Packages.erlang' instead." beam27Packages.erlang; # added 2026-06-15
  erlang_28 = warnAlias "'erlang_28' is deprecated in favor of using the beamPackages sets. Use 'beam28Packages.erlang' instead." beam28Packages.erlang; # added 2026-06-15
  esbuild-config = throw "'esbuild-config' has been removed as it has been unmaintained upstream since September 2022"; # Added 2026-02-07
  esbuild_netlify = throw "'esbuild_netlify' has been removed, as the netlify esbuild fork is abandoned upstream and no longer used by netlify-cli; use 'esbuild' instead"; # Added 2026-06-08
  etBook = warnAlias "'etBook' has been renamed to 'et-book'" et-book; # Added 2026-02-08
  ethercalc = throw "'ethercalc' has been removed from nixpkgs as the project was old, unmaintained, and could not be packaged well in nixpkgs"; # Added 2025-11-28
  ethersync = throw "'ethersync' has been renamed to/replaced by 'teamtype'"; # Converted to throw 2026-07-01
  eureka-ideas = throw "'eureka-ideas' has been removed as it has been unmaintained upstream since April 2023"; # Added 2026-02-07
  everspace = throw "'everspace' has been removed, as it relies on gtk2 libraries"; # Added 2026-06-15
  evolve-core = throw "'evolve-core' has been removed, as it hindered the removal of flutter329"; # Added 2026-01-25
  ex_doc = warnAlias "'ex_doc' is deprecated in favor of using the beamPackages sets. Use 'beamPackages.ex_doc' instead." beamPackages.ex_doc; # added 2026-06-15
  f3d_egl = throw "'f3d_egl' has been renamed to/replaced by 'f3d'"; # Converted to throw 2026-07-01
  fabs = throw "'fabs' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  falcon = throw "'falcon' has been removed as it is unmaintained and depends on pcre, which is deprecated"; # Added 2026-06-16
  fancontrol-gui = throw "'fancontrol-gui' has been removed due to outdated KF5 dependencies"; # Added 2026-05-01
  fast-cli = throw "'fast-cli' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  fastfetchMinimal = warnAlias "'fastfetchMinimal' has been renamed to 'fastfetch-unwrapped'" fastfetch-unwrapped; # Added 2026-05-18
  fastJson = warnAlias "'fastJson' has been renamed to 'libfastjson'" libfastjson; # Added 2026-02-08
  faustPhysicalModeling = warnAlias "'faustPhysicalModeling' has been renamed to 'faust-physicalmodeling'" faust-physicalmodeling; # Added 2026-02-08
  fbpanel = throw "'fbpanel' has been removed as it was broken and unmaintained upstream"; # Added 2026-05-16
  fedifetcher = throw "'fedifetcher' has been removed because there is now a similar native feature in Mastodon."; # Added 2025-12-08
  firefox-beta-bin = throw "'firefox-beta-bin' has been renamed to/replaced by 'firefox-beta'"; # Converted to throw 2026-07-01
  firefox-devedition-bin = throw "'firefox-devedition-bin' has been renamed to/replaced by 'firefox-devedition'"; # Converted to throw 2026-07-01
  fixup_yarn_lock = throw "`fixup_yarn_lock` has been removed, please use `fixup-yarn-lock` instead."; # Added 2026-04-25
  flattenReferencesGraph = warnAlias "'flattenReferencesGraph' has been renamed to 'flatten-references-graph'" flatten-references-graph; # Added 2026-02-08
  flint3 = warnAlias "'flint3' has been renamed to/replaced by 'flint'" flint; # Converted to warning 2026-07-01
  fltk13 = warnAlias "'fltk13' has been renamed to 'fltk_1_3'" fltk_1_3; # Added 2026-01-14
  fltk13-minimal = warnAlias "'fltk13-minimal' has been renamed to 'fltk_1_3-minimal'" fltk_1_3-minimal; # Added 2026-01-14
  fltk14 = warnAlias "'fltk14' has been renamed to 'fltk_1_4'" fltk_1_4; # Added 2026-01-14
  fltk14-minimal = warnAlias "'fltk14-minimal' has been renamed to 'fltk_1_4-minimal'" fltk_1_4-minimal; # Added 2026-01-14
  follow = throw "'follow' has been renamed to/replaced by 'folo'"; # Converted to throw 2026-07-01
  fondo = throw "'fondo' has been removed as it was unmaintained upstream and depended on libsoup 2.4"; # Added 2026-06-07
  fontadobe75dpi = warnAlias "'fontadobe75dpi' has been renamed to/replaced by 'font-adobe-75dpi'" font-adobe-75dpi; # Converted to warning 2026-07-01
  fontadobe100dpi = warnAlias "'fontadobe100dpi' has been renamed to/replaced by 'font-adobe-100dpi'" font-adobe-100dpi; # Converted to warning 2026-07-01
  fontadobeutopia75dpi = warnAlias "'fontadobeutopia75dpi' has been renamed to/replaced by 'font-adobe-utopia-75dpi'" font-adobe-utopia-75dpi; # Converted to warning 2026-07-01
  fontadobeutopia100dpi = warnAlias "'fontadobeutopia100dpi' has been renamed to/replaced by 'font-adobe-utopia-100dpi'" font-adobe-utopia-100dpi; # Converted to warning 2026-07-01
  fontadobeutopiatype1 = warnAlias "'fontadobeutopiatype1' has been renamed to/replaced by 'font-adobe-utopia-type1'" font-adobe-utopia-type1; # Converted to warning 2026-07-01
  fontalias = warnAlias "'fontalias' has been renamed to/replaced by 'font-alias'" font-alias; # Converted to warning 2026-07-01
  fontarabicmisc = warnAlias "'fontarabicmisc' has been renamed to/replaced by 'font-arabic-misc'" font-arabic-misc; # Converted to warning 2026-07-01
  fontbh75dpi = warnAlias "'fontbh75dpi' has been renamed to/replaced by 'font-bh-75dpi'" font-bh-75dpi; # Converted to warning 2026-07-01
  fontbh100dpi = warnAlias "'fontbh100dpi' has been renamed to/replaced by 'font-bh-100dpi'" font-bh-100dpi; # Converted to warning 2026-07-01
  fontbhlucidatypewriter75dpi = warnAlias "'fontbhlucidatypewriter75dpi' has been renamed to/replaced by 'font-bh-lucidatypewriter-75dpi'" font-bh-lucidatypewriter-75dpi; # Converted to warning 2026-07-01
  fontbhlucidatypewriter100dpi = warnAlias "'fontbhlucidatypewriter100dpi' has been renamed to/replaced by 'font-bh-lucidatypewriter-100dpi'" font-bh-lucidatypewriter-100dpi; # Converted to warning 2026-07-01
  fontbhttf = warnAlias "'fontbhttf' has been renamed to/replaced by 'font-bh-ttf'" font-bh-ttf; # Converted to warning 2026-07-01
  fontbhtype1 = warnAlias "'fontbhtype1' has been renamed to/replaced by 'font-bh-type1'" font-bh-type1; # Converted to warning 2026-07-01
  fontbitstream75dpi = warnAlias "'fontbitstream75dpi' has been renamed to/replaced by 'font-bitstream-75dpi'" font-bitstream-75dpi; # Converted to warning 2026-07-01
  fontbitstream100dpi = warnAlias "'fontbitstream100dpi' has been renamed to/replaced by 'font-bitstream-100dpi'" font-bitstream-100dpi; # Converted to warning 2026-07-01
  fontbitstreamtype1 = warnAlias "'fontbitstreamtype1' has been renamed to/replaced by 'font-bitstream-type1'" font-bitstream-type1; # Converted to warning 2026-07-01
  fontcronyxcyrillic = warnAlias "'fontcronyxcyrillic' has been renamed to/replaced by 'font-cronyx-cyrillic'" font-cronyx-cyrillic; # Converted to warning 2026-07-01
  fontcursormisc = warnAlias "'fontcursormisc' has been renamed to/replaced by 'font-cursor-misc'" font-cursor-misc; # Converted to warning 2026-07-01
  fontdaewoomisc = warnAlias "'fontdaewoomisc' has been renamed to/replaced by 'font-daewoo-misc'" font-daewoo-misc; # Converted to warning 2026-07-01
  fontdecmisc = warnAlias "'fontdecmisc' has been renamed to/replaced by 'font-dec-misc'" font-dec-misc; # Converted to warning 2026-07-01
  fontfinder = throw "'fontfinder' has been remved as it has been unmaintained upstream since April 2023"; # Added 2026-02-07
  fontibmtype1 = warnAlias "'fontibmtype1' has been renamed to/replaced by 'font-ibm-type1'" font-ibm-type1; # Converted to warning 2026-07-01
  fontisasmisc = warnAlias "'fontisasmisc' has been renamed to/replaced by 'font-isas-misc'" font-isas-misc; # Converted to warning 2026-07-01
  fontjismisc = warnAlias "'fontjismisc' has been renamed to/replaced by 'font-jis-misc'" font-jis-misc; # Converted to warning 2026-07-01
  fontmatrix = throw "'fontmatrix' has been removed as upstream was archived 2024-10-24"; # Added 2026-04-26
  fontmicromisc = warnAlias "'fontmicromisc' has been renamed to/replaced by 'font-micro-misc'" font-micro-misc; # Converted to warning 2026-07-01
  fontmisccyrillic = warnAlias "'fontmisccyrillic' has been renamed to/replaced by 'font-misc-cyrillic'" font-misc-cyrillic; # Converted to warning 2026-07-01
  fontmiscethiopic = warnAlias "'fontmiscethiopic' has been renamed to/replaced by 'font-misc-ethiopic'" font-misc-ethiopic; # Converted to warning 2026-07-01
  fontmiscmeltho = warnAlias "'fontmiscmeltho' has been renamed to/replaced by 'font-misc-meltho'" font-misc-meltho; # Converted to warning 2026-07-01
  fontmiscmisc = warnAlias "'fontmiscmisc' has been renamed to/replaced by 'font-misc-misc'" font-misc-misc; # Converted to warning 2026-07-01
  fontmuttmisc = warnAlias "'fontmuttmisc' has been renamed to/replaced by 'font-mutt-misc'" font-mutt-misc; # Converted to warning 2026-07-01
  fontschumachermisc = warnAlias "'fontschumachermisc' has been renamed to/replaced by 'font-schumacher-misc'" font-schumacher-misc; # Converted to warning 2026-07-01
  fontscreencyrillic = warnAlias "'fontscreencyrillic' has been renamed to/replaced by 'font-screen-cyrillic'" font-screen-cyrillic; # Converted to warning 2026-07-01
  fontsonymisc = warnAlias "'fontsonymisc' has been renamed to/replaced by 'font-sony-misc'" font-sony-misc; # Converted to warning 2026-07-01
  fontsunmisc = warnAlias "'fontsunmisc' has been renamed to/replaced by 'font-sun-misc'" font-sun-misc; # Converted to warning 2026-07-01
  fontutil = warnAlias "'fontutil' has been renamed to/replaced by 'font-util'" font-util; # Converted to warning 2026-07-01
  fontwinitzkicyrillic = warnAlias "'fontwinitzkicyrillic' has been renamed to/replaced by 'font-winitzki-cyrillic'" font-winitzki-cyrillic; # Converted to warning 2026-07-01
  fontxfree86type1 = warnAlias "'fontxfree86type1' has been renamed to/replaced by 'font-xfree86-type1'" font-xfree86-type1; # Converted to warning 2026-07-01
  forceSystem = throw "forceSystem is deprecated in favour of explicitly importing Nixpkgs"; # Converted to throw 2026-07-01
  fped = throw "'fped' has been removed, as it is unmaintained upstream and depends on GTK 2. Consider using 'kicad' instead."; # Added 2026-05-22
  framac = warnAlias "'framac' has been renamed to/replaced by 'frama-c'" frama-c; # Converted to warning 2026-07-01
  freecad-qt6 = warnAlias "'freecad-qt6' has been renamed to/replaced by 'freecad'" freecad; # Converted to warning 2026-07-01
  freecad-wayland = warnAlias "'freecad-wayland' has been renamed to/replaced by 'freecad'" freecad; # Converted to warning 2026-07-01
  frozen-bubble = throw "'frozen-bubble' has been removed because it is broken and unmaintained"; # Added 2026-05-17
  frugal = throw "'frugal' was removed because upstream has been pulled"; # Added 2025-12-20
  fuse-7z-ng = throw "'fuse-7z-ng' was removed as it is unmaintained, and depends on fuse2"; # Added 2026-05-05
  fuseiso = throw "'fuseiso' has been removed as it is unmaintained upstream, and depends on fuse2"; # Added 2026-05-05
  fusionInventory = warnAlias "'fusionInventory' has been renamed to 'fusioninventory-agent'" fusioninventory-agent; # Added 2026-02-08
  fzf-zsh = throw "'fzf-zsh' has been removed because it was superseed by its builtin equivalent and archived upstream."; # Added 2026-01-17
  galene-stt = throw "'galene-stt' has been removed as it is unmaintained and broken"; # Added 2026-01-27
  gamehub = throw "'gamehub' has been removed as it was archived upstream and depended on webkitgtk 4.0"; # Added 2026-06-07
  gandi-cli = throw "'gandi-cli' has been removed as it is unmaintained upstream"; # Added 2026-01-11
  garage-webui = throw "'garage-webui' has been removed as it is unmaintained upstream"; # Added 2026-06-23
  garage_1_x = throw "'garage_1_x' has been renamed to/replaced by 'garage_1'"; # Converted to throw 2026-07-01
  gavrasm = throw "'gavrasm' has been removed. Use 'avra' instead."; # Added 2025-12-21
  gbdfed = throw "'gbdfed' has been removed, as it is unmaintained upstream and depends on GTK 2. Consider using 'fontforge' instead."; # Added 2026-05-22
  gencfsm = throw "'gnecfsm' has been removed as it depends on encfs, which depends on the deprecated fuse2"; # Added 2026-05-05
  gfie = throw "'gfie' has been removed as it depended on EOL qt5 webengine"; # Added 2026-04-17
  gfn-electron = throw "gfn-electron has been removed from Nixpkgs as it's abandoned upstream"; # Added 2025-11-05
  gh-cherry-pick = warnAlias "'gh-cherry-pick' has been renamed to 'ghcherry'" ghcherry; # Added 2026-05-17
  gh-copilot = throw "'gh-copilot' has been removed since it has been deprecated and archived upstream. Consider using 'github-copilot-cli' instead"; # Added 2026-01-20
  gImageReader = warnAlias "'gImageReader' has been renamed to/replaced by 'gimagereader'" gimagereader; # Converted to warning 2026-07-01
  gImageReader-qt = warnAlias "'gImageReader-qt' has been renamed to/replaced by 'gimagereader-qt'" gimagereader-qt; # Converted to warning 2026-07-01
  gimp3 = warnAlias "'gimp3' has been renamed to/replaced by 'gimp'" gimp; # Converted to warning 2026-07-01
  gimp3-with-plugins = warnAlias "'gimp3-with-plugins' has been renamed to/replaced by 'gimp-with-plugins'" gimp-with-plugins; # Converted to warning 2026-07-01
  gimp3Plugins = warnAlias "'gimp3Plugins' has been renamed to/replaced by 'gimpPlugins'" gimpPlugins; # Converted to warning 2026-07-01
  gitfs = throw "'gitfs' has been removed, as it is broken and unmaintained upstream"; # Added 2026-05-22
  glaxnimate = warnAlias "'glaxnimate' has been renamed to/replaced by 'kdePackages.glaxnimate'" kdePackages.glaxnimate; # Converted to warning 2026-07-01
  glew110 = warnAlias "'glew110' has been renamed to 'glew_1_10'" glew_1_10; # Added 2026-01-14
  globalprotect-openconnect = throw "'globalprotect-openconnect' was removed because it was unmaintained in Nixpkgs and needed upgrading to the Tauri rewrite, as the old version depends on the removed Qt 5 WebEngine"; # Added 2026-04-26
  glom = throw "'glom' has been removed as it was archived upstream and depended on libsoup 2.4"; # Added 2026-06-07
  gmu = throw "'gmu' has been removed as it was broken and unmaintained in Nixpkgs"; # Added 2026-04-04
  gnaural = throw "'gnaural' has been removed due to lack of maintainance and relying on gtk2. Consider using 'sbagen' instead"; # Added 2026-05-22
  gnome-bluetooth_1_0 = throw "'gnome-bluetooth_1_0' has been removed as it is unmaintained upstream"; # Added 2026-03-09
  gnome-settings-daemon46 = throw "'gnome-settings-daemon46' has been removed, no longer used by Pantheon"; # Added 2026-01-24
  gns3Packages = throw "'gns3Packages' has been removed. Use 'gns3-gui' and 'gns3-server' instead."; # Added 2026-01-18
  gobang = throw "'gobang' has been removed as it is unmaintained upstream. Consider using `lazysql` or `rainfrog` instead."; # added 2026-04-25
  goldendict = throw "'goldendict' has been removed as upstream goldendict/goldendict is unmaintained and depends on deprecated qtwebkit; use the actively-developed Qt6 fork 'goldendict-ng' instead"; # Added 2026-04-26
  goocanvas2 = warnAlias "'goocanvas2' has been renamed to goocanvas_2" goocanvas_2; # Added 2026-01-17
  goocanvas3 = warnAlias "'goocanvas3' has been renamed to goocanvas_3" goocanvas_3; # Added 2026-01-17
  goocanvas = warnAlias "'goocanvas' has been renamed to goocanvas_1" goocanvas_1; # Added 2026-01-17
  gphotos-sync = throw "'gphotos-sync' has been removed, as it was archived upstream due to API changes that ceased its functions"; # Added 2025-11-06
  gpredict-unstable = throw "'gpredict-unstable' has been removed, as it was behind 'gpredict'"; # Added 2026-04-29
  gpt-box = throw "'gpt-box' has been removed, as it is unmaintained"; # Added 2026-01-25
  gpxsee-qt6 = warnAlias "'gpxsee-qt6' has been renamed to/replaced by 'gpxsee'" gpxsee; # Converted to warning 2026-07-01
  gradleGen = throw "'gradleGen' has been moved to `gradle-packages.mkGradle`."; # Added 2025-11-02
  graphia = throw "'graphia' has been removed due to being unmaintained and broken"; # Added 2026-05-05
  grub4dos = throw "'grub4dos' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  gscrabble = throw "'gscrabble' has been removed, as it is unmaintained upstream, and broken in nixpkgs"; # Added 2026-01-03
  gsettings-qt = warnAlias "'gsettings-qt' has been renamed to/replaced by 'lomiri.gsettings-qt'" lomiri.gsettings-qt; # Converted to warning 2026-07-01
  gssdp = throw "'gssdp' (version 1.4) has been removed as it was unmaintained upstream and depended on libsoup 2.4. Consider using `gssdp_1_6` instead"; # Added 2026-06-07
  gtdialog = throw "'gtdialog' has been removed, as it depended on GTK 2. Consider using 'yad' or 'zenity' instead."; # Added 2026-05-22
  gtkgnutella = gtk-gnutella; # Added 2026-05-21
  gtklp = throw "'gtklp' has been removed, as it depended on GTK 2. Consider using 'system-config-printer' instead."; # Added 2026-05-22
  gtkradiant = throw "'gtkradiant' has been removed, as it relies on gtk2"; # Added 2026-06-18
  gtuber = throw "'gtuber' has been removed due to being discontinued by upstream."; # Added 2025-12-12
  gui-for-clash = throw "'gui-for-clash' has been removed, as it is unmaintained"; # Added 2026-05-28
  gupnp = throw "'gupnp' (version 1.4) has been removed as it was unmaintained upstream and depended on libsoup 2.4. Consider using 'gupnp_1_6' instead"; # Added 2026-06-07
  gutenprintBin = warnAlias "'gutenprintBin' has been renamed to/replaced by 'gutenprint-bin'" gutenprint-bin; # Converted to warning 2026-07-01
  gwrap = warnAlias "The 'gwrap' alias has been removed. The correct name of the package is 'g-wrap'" g-wrap; # Added 2026-01-25
  hasmail = throw "'hasmail' has been removed, as the GTK 2 project is no longer maintained upstream."; # Added 2026-05-22
  haxe_4_0 = throw "'haxe_4_0' has been removed as it reached its end of life. Migrate to 'haxe_4_3'."; # Added 2026-05-06
  haxe_4_1 = throw "'haxe_4_1' has been removed as it reached its end of life. Migrate to 'haxe_4_3'."; # Added 2026-05-06
  haxor-news = throw "'haxor-news' has been removed as it is unmaintained"; # Added 2026-06-16
  helix-gpt = throw "helix-gpt was deprecated in January 2026 and has been since removed"; # Added 2026-02-05
  hiPrio = throw "'hiPrio' has been renamed to/replaced by 'lib.hiPrio'"; # Converted to throw 2026-07-01
  hop = throw "'hop' has been removed due to lack of maintenance"; # Added 2025-11-08
  hors = throw "'hors' has been removed due to being unmaintained upstream"; # Added 2026-05-04
  hostPlatform = throw "'hostPlatform' has been renamed to/replaced by 'stdenv.hostPlatform'"; # Converted to throw 2026-07-01
  hspellDicts = throw "'hspellDicts' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  http-prompt = throw "'http-prompt' has been removed as it was broken and unmaintained upstream"; # Added 2025-11-26
  httperf = throw "'httperf' has been removed as it was unmaintained and broken"; # Added 2026-05-04
  httpfs2 = throw "'httpfs2' has been removed as it was unmaintained upstream"; # Added 2026-05-31
  httplz = throw "'httplz' has been removed as it was unmaintained upstream"; # Added 2026-04-25
  hubicfuse = throw "'hubicfuse' has been removed as the hubic service was discontinued and the project is unmaintained upstream"; # Added 2026-05-08
  hydraAntLogger = warnAlias "'hydraAntLogger' has been renamed to 'hydra-ant-logger'" hydra-ant-logger; # Added 2026-02-08
  hyprfreeze = warnAlias "'hyprfreeze' has been renamed to 'wl-freeze'" wl-freeze; # Added 2026-04-10
  i3lock-pixeled = throw "'i3lock-pixeled' has been unmaintained for several years now."; # Converted to throw 2026-01-24
  icu69 = throw "ICU 69 has been removed as it is obsolete and no longer used by anything in Nixpkgs"; # Added 2026-04-20
  imagemagick6 = throw "'imagemagick6' was removed because it is outdated. Use 'imagemagick' instead."; # added 2026-02-27
  imagemagick6_light = throw "'imagemagick6_light' was removed because it is outdated. Use 'imagemagick_light' instead."; # added 2026-02-27
  imagemagick6Big = throw "'imagemagick6Big' was removed because it is outdated. Use 'imagemagickBig' instead."; # added 2026-02-27
  imapnotify = throw "'imapnotify' has been removed because it is unmaintained upstream"; # Added 2025-11-14
  infamousPlugins = warnAlias "'infamousPlugins' has been renamed to/replaced by 'infamousplugins'" infamousplugins; # Converted to warning 2026-07-01
  intel2200BGFirmware = warnAlias "'intel2200BGFirmware' has been renamed to 'ipw2200-firmware'" ipw2200-firmware; # Added 2026-02-08
  intel-oneapi = {
    base = warnAlias "'intel-oneapi.base' and 'intel-oneapi.hpc' have been merged upstream into a single package. Please switch to 'intel-oneapi-toolkit'" intel-oneapi-toolkit; # Added 2026-05-04
    hpc = warnAlias "'intel-oneapi.base' and 'intel-oneapi.hpc' have been merged upstream into a single package. Please switch to 'intel-oneapi-toolkit'" intel-oneapi-toolkit; # Added 2026-05-04
  }; # Added 2026-05-04
  ion3 = throw "ion3 was dropped since it was unmaintained."; # Added 2026-02-18
  iqueue = throw "'iqueue' has been removed, as it was broken and unmaintained upstream"; # Added 2026-04-10
  ir.lv2 = warnAlias "'ir.lv2' has been renamed to/replaced by 'ir-lv2'" ir-lv2; # Converted to warning 2026-07-01
  ircdHybrid = warnAlias "'ircdHybrid' has been renamed to 'ircd-hybrid'" ircd-hybrid; # Added 2026-02-08
  iroh = throw "iroh has been split into iroh-dns-server and iroh-relay"; # Added 2025-11-06
  itm-tools = throw "'itm-tools' has been removed because it was deprecated and archived upstream."; # Added 2026-01-15
  jarowinkler-cpp = throw "'jarowinkler-cpp' has been removed because it was deprecated and archived upstream. Consider using 'rapidfuzz-cpp' instead"; # Added 2026-01-15
  javaCup = warnAlias "'javaCup' has been renamed to 'java-cup'" java-cup; # Added 2026-02-08
  jdk23 = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  jdk23_headless = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  jellyfin-media-player = warnAlias "'jellyfin-media-player' has been renamed to/replaced by 'jellyfin-desktop'" jellyfin-desktop; # Converted to warning 2026-07-01
  jellyseerr = warnAlias "'jellyseerr' has been renamed to 'seerr'" seerr; # Added 2026-03-17
  jesec-rtorrent = throw "'jesec-rtorrent' has been removed due to lack of maintenance upstream."; # Added 2025-11-20
  jextract-21 = throw "'jextract-21' has been removed due to lack of maintenance upstream. Please use 'jextract'"; # Added 2026-05-13
  jhentai = throw "'jhentai' has been removed, as it is unmaintained"; # Added 2026-01-25
  jing = warnAlias "'jing' has been renamed to/replaced by 'jing-trang'" jing-trang; # Converted to warning 2026-07-01
  joplin = warnAlias "'joplin' has been renamed to/replaced by 'joplin-cli'" joplin-cli; # Converted to warning 2026-07-01
  jsduck = throw "jsduck has been removed, as it was broken and and unmaintained upstream."; # Added 2025-12-02
  k3s_1_31 = throw "'k3s_1_31' has been removed from nixpkgs as it has reached end of life"; # Added 2025-12-08
  k3s_1_32 = throw "'k3s_1_32' has been removed from nixpkgs as it has reached end of life"; # Added 2026-03-31
  k4dirstat = throw "'k4dirstat' has been removed due to outdated KF5 dependencies; consider using 'qdirstat' instead."; # Added 2026-05-01
  kaffeine = throw "'kaffeine' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  kanidm = throw "'kanidm' alias has been removed. You must use a versioned package, e.g. 'kanidm_1_x'."; # Added 2026-01-29
  kanidm_1_5 = throw "'kanidm_1_5' has been removed as it has reached end of life"; # Added 2026-01-29
  kanidm_1_6 = throw "'kanidm_1_6' has been removed as it has reached end of life"; # Added 2026-01-29
  kanidmWithSecretProvisioning = throw "'kanidmWithSecretProvisioning' was removed. You must use a versioned package, e.g. 'kanidmWithSecretProvisioning_1_x'."; # Added 2026-04-30
  kanidmWithSecretProvisioning_1_5 = throw "'kanidmWithSecretProvisioning_1_5' has been removed as it has reached end of life"; # Added 2026-01-29
  kanidmWithSecretProvisioning_1_6 = throw "'kanidmWithSecretProvisioning_1_6' has been removed as it has reached end of life"; # Added 2026-01-29
  karing = throw "'karing' has been removed, as it is unmaintained in nixpkgs"; # Added 2026-01-31
  katawa-shoujo = throw "'katawa-shoujo' has been removed, as it bundles insecure Python 2. You may install 'katawa-shoujo-re-engineered' instead, which is an updated version remade by Fleeting Heartbeat Studios."; # Added 2026-03-27
  kchmviewer = throw "'kchmviewer' has been removed as it was unmaintained upstream since 2022 and depended on qt5 webengine. Consider switching to 'uchmviewer', a fork of 'kchmviewer'."; # Added 2026-02-10
  kdash = throw "'kdash' has been removed because upstream tag changes broke the source derivation and trust in future tag stability"; # Added 2026-06-11
  kdeltacht = throw "'kdeltachat' has been removed as it depended on EOL qt5 webengine and was unmaintained"; # Added 2026-04-17
  kdesvn = throw "'kdesvn' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  keepkey-agent = throw "keepkey-agent has been removed because upstream dropped KeepKey support"; # Added 2026-03-11
  keepkey_agent = throw "keepkey-agent has been removed because upstream dropped KeepKey support"; # Added 2026-03-11
  keydb = throw "'keydb' has been removed as it was broken, vulnerable, and unmaintained upstream"; # Added 2025-11-08
  kgraphviewer = throw "'kgraphviewer' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  khd = throw "'khd' has been removed as it has been pulled upstream"; # Added 2025-12-18
  kilocode-cli = warnAlias "'kilocode-cli' has been renamed to/replaced by 'kilo'" kilo; # Added 2026-04-30
  kio-fuse = throw "'kio-fuse' has been removed, as Plasma 5 has reached end of life. Use 'kdePackages.kio-fuse' for Plasma 6."; # Added 2026-05-01
  knot-resolver = warnAlias "'knot-resolver' is currently aliased to 'knot-resolver_5'. This will change with the knot-resolver 6 being declared as stable. Please explicitly use the 'knot-resolver_5' or 'knot-resolver_6' package until then." knot-resolver_5; # Added 2025-11-30
  ksmoothdock = throw "'ksmoothdock' has been removed, as Plasma 5 has reached end of life."; # Added 2026-05-01
  ktextaddons = throw "'ktextaddons' has been removed due to outdated KF5 dependencies. A Qt6 version is available at 'kdePackages.ktextaddons'."; # Added 2026-05-01
  kup = throw "'kup' has been removed due to outdated KF5 dependencies. A Qt6 version is available at 'kdePackages.kup'."; # Added 2026-05-01
  kwalletcli = throw "'kwalletcli' has been removed, as Plasma 5 has reached end of life. A Qt6 version is available at 'kdePackages.kwallet' with the application 'kwallet-query'."; # Added 2026-05-14
  kwm = throw "'kwm' has been removed since upstream is a 404"; # Added 2025-12-21
  ladspaH = warnAlias "'ladspaH' has been renamed to 'ladspa-header'" ladspa-header; # Added 2026-02-08
  languageMachines.frog = warnAlias "'languageMachines.frog' has been renamed to/replaced by 'frog'" frog; # Converted to warning 2026-07-01
  languageMachines.frogdata = warnAlias "'languageMachines.frogdata' has been renamed to/replaced by 'frogdata'" frogdata; # Converted to warning 2026-07-01
  languageMachines.libfolia = warnAlias "'languageMachines.libfolia' has been renamed to/replaced by 'libfolia'" libfolia; # Converted to warning 2026-07-01
  languageMachines.mbt = warnAlias "'languageMachines.mbt' has been renamed to/replaced by 'mbt'" mbt; # Converted to warning 2026-07-01
  languageMachines.test = warnAlias "'languageMachines.test' has been renamed to/replaced by 'frog.tests.simple'" frog.tests.simple; # Converted to warning 2026-07-01
  languageMachines.ticcutils = warnAlias "'languageMachines.ticcutils' has been renamed to/replaced by 'ticcutils'" ticcutils; # Converted to warning 2026-07-01
  languageMachines.timbl = warnAlias "'languageMachines.timbl' has been renamed to/replaced by 'timbl'" timbl; # Converted to warning 2026-07-01
  languageMachines.timblserver = warnAlias "'languageMachines.timblserver' has been renamed to/replaced by 'timblserver'" timblserver; # Converted to warning 2026-07-01
  languageMachines.ucto = warnAlias "'languageMachines.ucto' has been renamed to/replaced by 'ucto'" ucto; # Converted to warning 2026-07-01
  languageMachines.uctodata = warnAlias "'languageMachines.uctodata' has been renamed to/replaced by 'uctodata'" uctodata; # Converted to warning 2026-07-01
  larswm = throw "'larswm' has been removed, as it is unmaintained upstream"; # Added 2026-05-24
  lash = throw "'lash' has been removed, as it is unmaintained upstream"; # Added 2026-01-02
  LAStools = warnAlias "'LAStools' has been renamed to/replaced by 'lastools'" lastools; # Converted to warning 2026-07-01
  leaf = throw "'leaf' has been removed as it is unmaintained. Consider using 'fastfetch' instead"; # Added 2026-04-24
  ledger-agent = throw "ledger-agent has been removed because upstream dropped Ledger support"; # Added 2026-03-11
  ledger_agent = throw "ledger-agent has been removed because upstream dropped Ledger support"; # Added 2026-03-11
  lexical = throw "'lexical' has been removed because it was deprecated and archived upstream. Consider using 'beamPackages.expert' instead"; # Added 2026-02-24
  lfe = warnAlias "'lfe' is deprecated in favor of using the beamPackages sets. Use 'beam27Packages.lfe' instead." beam27Packages.lfe; # added 2026-06-15
  libAppleWM = warnAlias "'libAppleWM' has been renamed to/replaced by 'libapplewm'" libapplewm; # Converted to warning 2026-07-01
  libbaseencode = throw "'libbaseencode' has been removed because it was deprecated and archived upstream. Consider using 'libcotp' instead"; # Added 2026-01-15
  libcef = throw "'libcef' has been removed, as no packages depend on it"; # Added 2025-11-06
  libchamplain = throw "'libchamplain' has been removed due to reliance on insecure libsoup 2.4. Consider using 'libchamplain_libsoup3' instead"; # Added 2026-05-29
  libdbiDrivers = warnAlias "'libdbiDrivers' has been renamed to 'libdbi-drivers'" libdbi-drivers; # Added 2026-02-08
  libdbiDriversBase = warnAlias "'libdbiDriversBase' has been renamed to 'libdbi-drivers-base'" libdbi-drivers-base; # Added 2026-02-08
  libdynd = throw "'libdynd' has been removed due to lack of maintenance"; # Added 2026-03-24
  libepc = throw "'libepc' has been removed as it was archived upstream and depended on libsoup 2.4"; # Added 2026-06-07
  libertine-g = warnAlias "'libertine-g' has been renamed to 'linux-libertine-g'" linux-libertine-g; # Added 2026-02-20
  libevdevplus = throw "'libevdevplus' has been removed, as it was unmaintained upstream since 2021, no longer builds, and is no longer used by anything"; # Added 2025-11-02
  libfakeXinerama = warnAlias "'libfakeXinerama' has been renamed to 'libfakexinerama'" libfakexinerama; # Added 2026-02-08
  libfprint-focaltech-2808-a658 = throw "'libfprint-focaltech-2808-a658' has been removed as it was broken and upstream was taken down"; # Added 2025-11-04
  libFS = warnAlias "'libFS' has been renamed to/replaced by 'libfs'" libfs; # Converted to warning 2026-07-01
  libgdata = throw "'libgdata' has been removed due to being archived upstream."; # Added 2026-05-29
  libGDSII = warnAlias "'libGDSII' has been renamed to/replaced by 'libgdsii'" libgdsii; # Converted to warning 2026-07-01
  libgestures = throw "'libgestures' has been removed as it was broken and unmaintained upstream"; # Added 2026-05-09
  libgnome-games-support_2_0 = throw "'libgnome-games-support_2_0' has been removed. Upstream has converted this library to a copylib and no more releases will happen"; # Added 2026-03-27
  libHX = warnAlias "'libHX' has been renamed to/replaced by 'libhx'" libhx; # Converted to warning 2026-07-01
  libICE = warnAlias "'libICE' has been renamed to/replaced by 'libice'" libice; # Converted to warning 2026-07-01
  libLAS = warnAlias "'libLAS' has been renamed to/replaced by 'liblas'" liblas; # Converted to warning 2026-07-01
  liblastfmSF = warnAlias "'liblastfmSF' has been renamed to 'liblastfm-vambrose'" liblastfm-vambrose; # Added 2026-02-08
  libmesode = throw "'libmesode' has been removed because it was deprecated and archived upstream. Consider using 'libstrophe' instead"; # Added 2026-01-15
  libmkv = throw "'libmkv' has been removed as it is abandoned upstream"; # Added 2026-01-18
  libmusicbrainz5 = warnAlias "'libmusicbrainz5' has been renamed to/replaced by 'libmusicbrainz'" libmusicbrainz; # Converted to warning 2026-07-01
  libpthreadstubs = warnAlias "'libpthreadstubs' has been renamed to/replaced by 'libpthread-stubs'" libpthread-stubs; # Converted to warning 2026-07-01
  libqtdbusmock = warnAlias "'libqtdbusmock' has been renamed to 'libsForQt5.libqtdbusmock'"; # Added 2026-03-10
  libqtdbustest = warnAlias "'libqtdbustest' has been renamed to 'libsForQt5.libqtdbustest'"; # Added 2026-03-10
  libreoffice-qt6 = warnAlias "'libreoffice-qt6' has been renamed to/replaced by 'libreoffice-qt'" libreoffice-qt; # Converted to warning 2026-07-01
  libreoffice-qt6-fresh = warnAlias "'libreoffice-qt6-fresh' has been renamed to/replaced by 'libreoffice-qt-fresh'" libreoffice-qt-fresh; # Converted to warning 2026-07-01
  libreoffice-qt6-fresh-unwrapped = warnAlias "'libreoffice-qt6-fresh-unwrapped' has been renamed to/replaced by 'libreoffice-qt-fresh.unwrapped'" libreoffice-qt-fresh.unwrapped; # Converted to warning 2026-07-01
  libreoffice-qt6-still = warnAlias "'libreoffice-qt6-still' has been renamed to/replaced by 'libreoffice-qt-still'" libreoffice-qt-still; # Converted to warning 2026-07-01
  libreoffice-qt6-still-unwrapped = warnAlias "'libreoffice-qt6-still-unwrapped' has been renamed to/replaced by 'libreoffice-qt-still.unwrapped'" libreoffice-qt-still.unwrapped; # Converted to warning 2026-07-01
  libreoffice-qt6-unwrapped = warnAlias "'libreoffice-qt6-unwrapped' has been renamed to/replaced by 'libreoffice-qt.unwrapped'" libreoffice-qt.unwrapped; # Converted to warning 2026-07-01
  librest_1_0 = warnAlias "'librest_1_0' has been renamed to/replaced by 'librest'" librest; # Added 2026-05-30
  libSM = warnAlias "'libSM' has been renamed to/replaced by 'libsm'" libsm; # Converted to warning 2026-07-01
  libsmartcols = throw "'libsmartcols' has been renamed to/replaced by 'util-linux'"; # Converted to throw 2026-07-01
  libsoup_2_4 = throw "'libsoup_2_4' has been removed as it was end-of-life and has many known unfixed security issues. Consider migrating to 'libsoup_3' instead"; # Added 2026-06-07
  libubox-wolfssl = throw "'libubox-wolfssl' has been removed, use 'libubox' or 'libubox-mbedtls'"; # Added 2026-03-29
  libuinputplus = throw "'libuinputplus' has been removed, as it was unmaintained upstream since 2021, no longer builds, and is no longer used by anything"; # Added 2025-11-02
  libva1 = throw "'libva1' has been removed, as it is no longer required. Please use libva."; # Added 2026-05-14
  libva1-minimal = throw "'libva1-minimal' has been removed, as it is no longer required. Please use libva-minimal."; # Added 2026-05-14
  libWindowsWM = warnAlias "'libWindowsWM' has been renamed to/replaced by 'libwindowswm'" libwindowswm; # Converted to warning 2026-07-01
  libX11 = warnAlias "'libX11' has been renamed to/replaced by 'libx11'" libx11; # Converted to warning 2026-07-01
  libXau = warnAlias "'libXau' has been renamed to/replaced by 'libxau'" libxau; # Converted to warning 2026-07-01
  libXaw = warnAlias "'libXaw' has been renamed to/replaced by 'libxaw'" libxaw; # Converted to warning 2026-07-01
  libXcomposite = warnAlias "'libXcomposite' has been renamed to/replaced by 'libxcomposite'" libxcomposite; # Converted to warning 2026-07-01
  libXcursor = warnAlias "'libXcursor' has been renamed to/replaced by 'libxcursor'" libxcursor; # Converted to warning 2026-07-01
  libXdamage = warnAlias "'libXdamage' has been renamed to/replaced by 'libxdamage'" libxdamage; # Converted to warning 2026-07-01
  libXdmcp = warnAlias "'libXdmcp' has been renamed to/replaced by 'libxdmcp'" libxdmcp; # Converted to warning 2026-07-01
  libXext = warnAlias "'libXext' has been renamed to/replaced by 'libxext'" libxext; # Converted to warning 2026-07-01
  libXfixes = warnAlias "'libXfixes' has been renamed to/replaced by 'libxfixes'" libxfixes; # Converted to warning 2026-07-01
  libXfont2 = warnAlias "'libXfont2' has been renamed to/replaced by 'libxfont_2'" libxfont_2; # Converted to warning 2026-07-01
  libXfont = warnAlias "'libXfont' has been renamed to/replaced by 'libxfont_1'" libxfont_1; # Converted to warning 2026-07-01
  libXft = warnAlias "'libXft' has been renamed to/replaced by 'libxft'" libxft; # Converted to warning 2026-07-01
  libXi = warnAlias "'libXi' has been renamed to/replaced by 'libxi'" libxi; # Converted to warning 2026-07-01
  libXinerama = warnAlias "'libXinerama' has been renamed to/replaced by 'libxinerama'" libxinerama; # Converted to warning 2026-07-01
  libXmu = warnAlias "'libXmu' has been renamed to/replaced by 'libxmu'" libxmu; # Converted to warning 2026-07-01
  libXp = warnAlias "'libXp' has been renamed to/replaced by 'libxp'" libxp; # Converted to warning 2026-07-01
  libXpm = warnAlias "'libXpm' has been renamed to/replaced by 'libxpm'" libxpm; # Converted to warning 2026-07-01
  libXpresent = warnAlias "'libXpresent' has been renamed to/replaced by 'libxpresent'" libxpresent; # Converted to warning 2026-07-01
  libXrandr = warnAlias "'libXrandr' has been renamed to/replaced by 'libxrandr'" libxrandr; # Converted to warning 2026-07-01
  libXrender = warnAlias "'libXrender' has been renamed to/replaced by 'libxrender'" libxrender; # Converted to warning 2026-07-01
  libXres = warnAlias "'libXres' has been renamed to/replaced by 'libxres'" libxres; # Converted to warning 2026-07-01
  libXScrnSaver = warnAlias "'libXScrnSaver' has been renamed to/replaced by 'libxscrnsaver'" libxscrnsaver; # Converted to warning 2026-07-01
  libXt = warnAlias "'libXt' has been renamed to/replaced by 'libxt'" libxt; # Converted to warning 2026-07-01
  libXtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
  libXtst = warnAlias "'libXtst' has been renamed to/replaced by 'libxtst'" libxtst; # Converted to warning 2026-07-01
  libXv = warnAlias "'libXv' has been renamed to/replaced by 'libxv'" libxv; # Converted to warning 2026-07-01
  libXvMC = warnAlias "'libXvMC' has been renamed to/replaced by 'libxvmc'" libxvmc; # Converted to warning 2026-07-01
  libXxf86dga = warnAlias "'libXxf86dga' has been renamed to/replaced by 'libxxf86dga'" libxxf86dga; # Converted to warning 2026-07-01
  libXxf86misc = warnAlias "'libXxf86misc' has been renamed to/replaced by 'libxxf86misc'" libxxf86misc; # Converted to warning 2026-07-01
  libXxf86vm = warnAlias "'libXxf86vm' has been renamed to/replaced by 'libxxf86vm'" libxxf86vm; # Converted to warning 2026-07-01
  light = throw "'light' has been removed because it was unmaintained. 'brightnessctl' and 'acpilight' provide similar functionality."; # Added 2026-02-24
  lima-bin = throw "'lima-bin' has been renamed to/replaced by 'lima'"; # Converted to throw 2026-07-01
  limbo = warnAlias "limbo has been renamed to turso" turso; # Added 2025-11-07
  lincity_ng = throw "'lincity_ng' has been renamed to/replaced by 'lincity-ng'"; # Converted to throw 2026-07-01
  linphone = warnAlias "'linphone' has been renamed to/replaced by 'linphonePackages.linphone-desktop'" linphonePackages.linphone-desktop; # Converted to warning 2026-07-01
  linux-rt = throw "linux-rt has been removed due to lack of maintenance"; # Added 2026-03-24
  linux-rt_5_10 = throw "linux-rt_5_10 has been removed due to lack of maintenance"; # Added 2026-03-24
  linux-rt_5_15 = throw "linux-rt_5_15 has been removed due to lack of maintenance"; # Added 2026-03-24
  linux-rt_6_1 = throw "linux_rt_6_1 has been removed due to lack of maintenance"; # Added 2026-03-24
  linux-rt_latest = throw "linux-rt_latest has been removed due to lack of maintenance"; # Added 2026-03-24
  linux_5_10 = linuxKernel.kernels.linux_5_10;
  linux_5_15 = linuxKernel.kernels.linux_5_15;
  linux_6_1 = linuxKernel.kernels.linux_6_1;
  linux_6_6 = linuxKernel.kernels.linux_6_6;
  linux_6_12 = linuxKernel.kernels.linux_6_12;
  linux_6_12_hardened = throw "linux_6_12_hardened has been removed due to lack of maintenance"; # Added 2026-03-18
  linux_6_17 = linuxKernel.kernels.linux_6_17;
  linux_6_18 = linuxKernel.kernels.linux_6_18;
  linux_6_19 = linuxKernel.kernels.linux_6_19;
  linux_7_0 = linuxKernel.kernels.linux_7_0;
  linux_7_1 = linuxKernel.kernels.linux_7_1;
  linux_hardened = throw "linux_hardened has been removed due to lack of maintenance"; # Added 2026-03-18
  linux_lqx = throw "linux_lqx has been removed due to lack of maintenance"; # Added 2026-03-13
  linux_rpi0 = linuxKernel.kernels.linux_rpi1;
  linux_rpi1 = linuxKernel.kernels.linux_rpi1;
  linux_rpi2 = linuxKernel.kernels.linux_rpi2;
  linux_rpi02w = linuxKernel.kernels.linux_rpi3;
  linux_rpi3 = linuxKernel.kernels.linux_rpi3;
  linux_rpi4 = linuxKernel.kernels.linux_rpi4;
  linuxPackages-rt = throw "linuxPackages-rt has been removed due to lack of maintenance"; # Added 2026-03-24
  linuxPackages-rt_latest = throw "linuxPackages-rt_latest has been removed due to lack of maintenance"; # Added 2026-03-24
  linuxPackages_5_10 = linuxKernel.packages.linux_5_10;
  linuxPackages_5_15 = linuxKernel.packages.linux_5_15;
  linuxPackages_6_1 = linuxKernel.packages.linux_6_1;
  linuxPackages_6_6 = linuxKernel.packages.linux_6_6;
  linuxPackages_6_12 = linuxKernel.packages.linux_6_12;
  linuxPackages_6_12_hardened = throw "linuxPackages_6_12_hardened has been removed due to lack of maintenance"; # Added 2026-03-18
  linuxPackages_6_17 = linuxKernel.packages.linux_6_17;
  linuxPackages_6_18 = linuxKernel.packages.linux_6_18;
  linuxPackages_6_19 = linuxKernel.packages.linux_6_19;
  linuxPackages_7_0 = linuxKernel.packages.linux_7_0;
  linuxPackages_7_1 = linuxKernel.packages.linux_7_1;
  linuxPackages_hardened = throw "linuxPackages_hardened has been removed due to lack of maintenance"; # Added 2026-03-18
  linuxPackages_lqx = throw "linuxPackages_lqx has been removed due to lack of maintenance"; # Added 2026-03-13
  linuxPackages_rpi0 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi1 = linuxKernel.packages.linux_rpi1;
  linuxPackages_rpi2 = linuxKernel.packages.linux_rpi2;
  linuxPackages_rpi02w = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi3 = linuxKernel.packages.linux_rpi3;
  linuxPackages_rpi4 = linuxKernel.packages.linux_rpi4;
  linuxPackages_rt_5_10 = throw "linuxPackages_rt_5_10 has been removed due to lack of maintenance"; # Added 2026-03-24
  linuxPackages_rt_5_15 = throw "linuxPackages_rt_5_15 has been removed due to lack of maintenance"; # Added 2026-03-24
  linuxPackages_rt_6_1 = throw "linuxPackages_rt_6_1 has been removed due to lack of maintenance"; # Added 2026-03-24
  liquidfun = throw "liquidfun has been removed, as it has failed to build (and so presumed unused) for 10 years"; # Added 2025-12-19
  littlefs-fuse = throw "'littlefs-fuse' has been removed as it depends on fues2, which has has been deprecated"; # Added 2026-05-05
  lixVersions = lixPackageSets.renamedDeprecatedLixVersions; # Added 2025-03-20, warning in ../tools/package-management/lix/default.nix
  lnreader = warnAlias "'lnreader' has been renamed to 'pdf-cli'" pdf-cli; # Added 2026-03-18
  lockfileProgs = warnAlias "'lockfileProgs' has been renamed to 'lockfile-progs'" lockfile-progs; # Added 2026-02-08
  log4j-detect = throw "'log4j-detect' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4j-scan = throw "'log4j-scan' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4j-sniffer = throw "'log4j-sniffer' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4j-vuln-scanner = throw "'log4j-vuln-scanner' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4jcheck = throw "'log4jcheck' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  log4shell-detector = throw "'log4shell-detector' has been removed, as it was unmaintained upstream and no longer relevant given that the Log4Shell vulnerability has been fixed."; # Added 2025-11-15
  lowPrio = throw "'lowPrio' has been renamed to/replaced by 'lib.lowPrio'"; # Converted to throw 2026-07-01
  lttv = throw "'lttv' has been removed, as it is broken and unmaintained. Upstream suggests using 'tracecompass' or 'babeltrace2' instead"; # Added 2026-05-04
  luminanceHDR = throw "'luminanceHDR' has been removed as it depended on EOL qt5 webengine and was unmaintained"; # Added 2026-04-17
  lunarvim = throw "'lunarvim' has been removed since it was abandoned upstream and relied on an older version of 'neovim' to work properly"; # Added 2026-02-05
  lunatic = throw "'lunatic' has been removed, as it is unmaintained"; # Added 2026-05-04
  LycheeSlicer = warnAlias "'LycheeSlicer' has been renamed to 'lycheeslicer'" lycheeslicer; # Added 2026-02-08
  m2r = throw "'m2r' has been removed because it was marked broken for a long time."; # Added 2026-05-27
  magpie = throw "'magpie' has been removed, no longer used by budgie-desktop."; # Added 2025-11-19
  maia-icon-theme = throw "'maia-icon-theme' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  makeOverridable = throw "'makeOverridable' has been renamed to/replaced by 'lib.makeOverridable'"; # Converted to throw 2026-07-01
  mangowc = throw "'mangowc' has been renamed to 'mango'"; # Added 2026-06-23
  manrope = throw "'manrope' has been removed because its source has been pulled"; # Added 2025-12-20
  massif-visualizer = throw "'massif-visualizer' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  mastodon-bot = throw "'mastodon-bot' has been removed because it was archived by upstream in 2021."; # Added 2025-11-07
  matrix-appservice-slack = throw "'matrix-appservice-slack' has been removed, as it relies on Classic Slack Apps, which no longer exist, and is abandoned upstream"; # Added 2025-11-11
  mbedtls_2 = throw "'mbedtls_2' has been removed as it reached its end of life. Migrate to 'mbedtls'."; # Added 2026-05-06
  mdbook-alerts = throw "'mdbook-alerts' has been removed because it is deprecated and natively supported by mdbook since version 0.5.0"; # Added 2026-01-07
  mdbook-linkcheck = throw "'mdbook-linkcheck' has been removed and replaced by 'mdbook-linkcheck2' due to incompatibility with mdbook version 0.5.0+"; # Added 2026-03-03
  mellowplayer = throw "'mellowplayer' has been removed as it was discontinued upstream in 2021."; # Added 2026-02-10
  melmatcheq.lv2 = warnAlias "'melmatcheq.lv2' has been renamed to/replaced by 'melmatcheq-lv2'" melmatcheq-lv2; # Converted to warning 2026-07-01
  melonDS = warnAlias "'melonDS' has been renamed to 'melonds'" melonds; # Added 2026-02-08
  metaBuildEnv = throw "'metaBuildEnv' has been removed, due to it being ancient unmaintained software"; # Added 2026-02-11
  metersLv2 = warnAlias "'metersLv2' has been renamed to 'meters-lv2'" meters-lv2; # Added 2026-02-08
  mhddfs = throw "'mhddfs' has been removed because upstream marked it as unmaintained on 2015-03-17. Consider using 'mergerfs' as potential alternative"; # Added 2026-05-31
  mindforger = throw "'mindforger' has been removed as it depended on EOL qt5 webengine"; # Added 2026-04-15
  miniHttpd = warnAlias "'miniHttpd' has been renamed to/replaced by 'mini-httpd'" mini-httpd; # Converted to warning 2026-07-01
  minio_legacy_fs = throw "'minio_legacy_fs' has been removed. Users should migrate to alternatives such as Garage, SeaweedFS, or Ceph. S3-compatible clients such as rclone can be used to move data."; # Added 2026-02-02
  minizincide = warnAlias "'minizincide' has been renamed to 'minizinc-ide'" minizinc-ide; # Added 2026-01-03
  mkYarnModules = throw "'yarn2nix' and its tooling has been removed as it was unusable within nodePackages. Use the standard yarn v1 hooks available in nixpkgs instead."; # Added 2026-04-25
  mkYarnPackage = throw "'yarn2nix' and its tooling has been removed as it was unusable within nodePackages. Use the standard yarn v1 hooks available in nixpkgs instead."; # Added 2026-04-25
  MMA = warnAlias "'MMA' has been renamed to/replaced by 'mma'" mma; # Converted to warning 2026-07-01
  moar = throw "'moar' has been renamed to/replaced by 'moor'"; # Converted to throw 2026-07-01
  mold-wrapped = warnAlias "'mold-wrapped' has been renamed to 'mold'" pkgs.mold; # Added 2025-11-12
  monitor = warnAlias "'monitor' has been renamed to/replaced by 'pantheon.elementary-monitor'" pantheon.elementary-monitor; # Converted to warning 2026-07-01
  monkeysAudio = warnAlias "'monkeysAudio' has been renamed to/replaced by 'monkeys-audio'" monkeys-audio; # Converted to warning 2026-07-01
  mono4 = warnAlias "'mono4' has been renamed to/replaced by 'mono6'" mono6; # Converted to warning 2026-07-01
  mono5 = warnAlias "'mono5' has been renamed to/replaced by 'mono6'" mono6; # Converted to warning 2026-07-01
  mooSpace = warnAlias "'mooSpace' has been renamed to/replaced by 'moospace'" moospace; # Converted to warning 2026-07-01
  mouse-actions-gui = throw "'mouse-actions-gui' has been removed as it depended on webkitgtk 4.0 and libsoup 2.4"; # Added 2026-06-07
  move-mount-beneath = throw "move-mount-beneath has been removed, it is now superseded by util-linux's mount"; # Added 2026-05-19
  mpage = throw "'mpage' has been removed due to being unmaintained and broken"; # Added 2026-05-05
  mpdWithFeatures = throw "'mpdWithFeatures' has been renamed to/replaced by 'mpd.override'"; # Converted to throw 2026-07-01
  msalsdk-dbusclient = throw "'msalsdk-dbusclient' has been removed, as it is no longer needed by 'intune-portal'"; # Added 2026-02-11
  mullvad-closest = throw "'mullvad-closest' has been removed as it was unmaintained. Consider using 'mullvad-compass' instead."; # Added 2026-01-13
  multipass = throw "multipass was dropped since it was unmaintained."; # Added 2025-11-29
  mutter46 = throw "'mutter46' has been removed, no longer used by Pantheon"; # Added 2026-01-24
  muzika = throw "muzika was discontinued upstream in november 2024"; # Added 2025-12-15
  mysql80 = throw "'mysql80' reached end of life on 2026-04-30 and has been removed."; # Added 2026-04-08
  ndjbdns = throw "'ndjbdns' has been removed as it has been pulled upstream"; # Added 2025-12-18
  near-cli = throw "'near-cli' has been removed as upstream has deprecated it and archived the source code repo"; # Added 2025-11-10
  nekoray = warnAlias "'nekoray' has been renamed to/replaced by 'lib.warnOnInstantiate'" lib.warnOnInstantiate; # Converted to warning 2026-07-01
  neofetch = throw "'neofetch' has been removed because it was unmaintained upstream. Consider using the updated fork 'neowofetch' provided by the 'hyfetch' package or the alternative 'fastfetch' instead."; # Added 2026-03-02
  nettools = warnAlias "'nettools' has been renamed to/replaced by 'net-tools'" net-tools; # Converted to warning 2026-07-01
  networkmanager_strongswan = warnAlias "'networkmanager_strongswan' has been renamed to/replaced by 'networkmanager-strongswan'" networkmanager-strongswan; # Converted to warning 2026-07-01
  newt-go = warnAlias "'newt-go' has been renamed to/replaced by 'fosrl-newt'" fosrl-newt; # Converted to warning 2026-07-01
  next-ls = throw "'next-ls' has been removed because it was deprecated and archived upstream. Consider using 'beamPackages.expert' instead"; # Added 2026-02-24
  nextcloud31 = throw "
    Nextcloud v31 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2025-09. Please upgrade to at least Nextcloud v32 by declaring

        services.nextcloud.package = pkgs.nextcloud32;

    in your NixOS config.

    WARNING: if you were on Nextcloud 30 you have to upgrade to Nextcloud 31
    first on 25.11 because Nextcloud doesn't support upgrades across multiple major versions!
  "; # Added 2026-02-20
  nextcloud31Packages = throw "Nextcloud 31 is EOL!"; # Added 2026-02-20
  nginxQuic = throw "'nginxQuic' has been removed. QUIC support is now available in the default nginx builds."; # Added 2025-11-24
  ngrid = throw "'ngrid' has been removed as it has been unmaintained upstream and broken"; # Added 2025-11-15
  nimbo = throw "'nimbo' has been removed due to being archived upstream."; # Added 2026-01-18
  nitrokey-fido2-firmware = throw "'nitrokey-fido2-firmware' has been removed as it was broken and unmaintained upstream since 2022"; # Added 2026-03-23
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
  nixnote2 = throw "'nixnote2' has been removed as upstream has been unmaintained since 2017"; # Added 2026-04-26
  nixos-rebuild = warnAlias "'nixos-rebuild' has been renamed to/replaced by 'nixos-rebuild-ng'" nixos-rebuild-ng; # Converted to warning 2026-07-01
  nmapsi4 = throw "'nmapsi4' has been removed as it depended on qt5 webengine, which is EOL"; # Added 2026-04-25
  node2nix = throw "node2nix has been removed because it was only used to maintain the now-removed nodePackages set. Use the newer builders in nixpkgs instead, such as buildNpmPackage"; # Added 2026-03-03
  nodejs-slim_25 = warnAlias "'nodejs-slim_25' has been renamed to/replaced by 'nodejs_25'" nodejs_25; # Converted to warning 2026-07-01
  nodejs_25 = throw "Node.js 25 support was removed given upstream End-of-Life on 2026-06-01"; # Added 2026-04-26
  nodePackages = throw "nodePackages has been removed. Many packages are now available at the top level (e.g. `pkgs.package-name`). Check on https://search.nixos.org to see if the package is still available."; # Added 2026-03-03
  nodePackages_latest = throw "nodePackages has been removed. Many packages are now available at the top level (e.g. `pkgs.package-name`). Check on https://search.nixos.org to see if the package is still available."; # Added 2026-03-03
  nofi = throw "'nofi' has been removed due to being archived upstream."; # Added 2026-01-16
  nomacs-qt6 = warnAlias "'nomacs-qt6' has been renamed to/replaced by 'nomacs'" nomacs; # Converted to warning 2026-07-01
  notary = throw "'notary' has been removed due to being archived upstream. Consider using 'notation' instead."; # Added 2025-11-13
  notepadqq = throw "'notepadqq' has been removed due to upstream stopping maintenance in 2023."; # Added 2026-02-10
  notify-osd-customizable = throw "'notify-osd-customizable' has been removed as it was broken and unmaintained"; # Added 2026-04-17
  nrpl = throw "'nrpl' has been removed as it depends on pcre, which is deprecated"; # Added 2026-06-25
  nuXmv = warnAlias "'nuXmv' has been renamed to 'nuxmv'" nuxmv; # Added 2026-02-08
  oam-tools = throw "'oam-tools' has been become part of amass"; # Added 2025-12-21
  obexfs = throw "'obexfs'  has been removed as it was unmaintained upstream"; # Added 2026-05-31
  oguri = throw "'oguri' has been removed from nixpkgs because the upstream repository was archived. Please see https://github.com/vilhalmer/oguri#notice-unmaintained for upstream's suggested replacements."; # Added 2026-05-04
  olaris-server = throw "'olaris-server' has been removed as it failed to build since 2024"; # Added 2026-01-15
  olive-editor = throw "'olive-editor' has been removed as it is unmaintained upstream and broken"; # Added 2026-05-22
  oneDNN = warnAlias "'oneDNN' has been renamed to/replaced by 'onednn'" onednn; # Converted to warning 2026-07-01
  oneDNN_2 = warnAlias "'oneDNN_2' has been renamed to/replaced by 'onednn_2'" onednn_2; # Converted to warning 2026-07-01
  open-stage-control = throw "'open-stage-control' has been removed due to being broken for more than a year; see RFC 180. Consider using open-stage-control-headless instead."; # Added 2026-05-04
  open-timeline-io = throw "'open-timeline-io' has been renamed to/replaced by 'opentimelineio'"; # Converted to throw 2026-07-01
  openai = throw "'openai' has been removed, since upstream removed the legacy CLI in v2.35.0; use 'python3Packages.openai' instead"; # Added 2026-06-10
  openalSoft = warnAlias "'openalSoft' has been renamed to 'openal-soft'" openal-soft; # Added 2026-02-09
  openbabel3 = warnAlias "'openbabel3' has been renamed to/replaced by 'openbabel'" openbabel; # Converted to warning 2026-07-01
  opencollada = throw "opencollada has been removed, as it is unmaintained upstream"; # Added 2026-04-26
  opencollada-blender = throw "opencollada-blender has been removed, as it is unmaintained upstream"; # Added 2026-04-26
  opencolorio_1 = throw "'opencolorio_1' has been removed. Use opencolorio instead"; # Added 2026-01-03
  opengfw = throw "'opengfw' has been removed because the upstream repository was deleted"; # Added 2026-03-16
  openhmd = throw "'openhmd' has been removed due to being unmaintained upstream"; # Added 2025-11-05
  openjdk23 = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  openjdk23_headless = throw "OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-04
  openjfx23 = throw "OpenJFX 23 was removed as it has reached its end of life"; # Added 2025-11-04
  openmodelica = throw "'openmodelica' has been removed as it was unmaintained in nixpkgs and depends on insecure&unmtaintained qtwebkit"; # Added 2026-04-26
  opentofu-ls = throw "'opentofu-ls' has been renamed to/replaced by 'tofu-ls'"; # Converted to throw 2026-07-01
  openzwave = throw "openzwave was removed because upstream is no longer maintained. Consider using zwave-js-server"; # Added 2026-05-14
  opusTools = warnAlias "'opusTools' has been renamed to 'opus-tools'" opus-tools; # Added 2026-02-12
  osl = warnAlias "'osl' has been renamed to/replaced by 'openshadinglanguage'" openshadinglanguage; # Converted to warning 2026-07-01
  osmtogeojson = throw "'osmtogeojson' has been removed as it was unmaintained upstream"; # Added 2026-02-22
  ossec-agent = throw "'ossec-agent' has been removed due to lack of maintenance"; # Added 2025-11-08
  ossec-server = throw "'ossec-server' has been removed due to lack of maintenance"; # Added 2025-11-08
  pactorio = throw "'pactorio' has been removed, as it has been unmaintained upstream since February 2024"; # Added 2026-01-01
  pam_pgsql = warnAlias "'pam_pgsql' has been renamed to/replaced by 'pam-pgsql'" pam-pgsql; # Converted to warning 2026-07-01
  pangolin = throw "pangolin has been removed due to lack of maintenance"; # Added 2025-11-17
  paper-plane = throw "'paper-plane' has been removed as it is unmaintained upstream and depends on vulnerable tdlib version."; # Added 2026-02-26
  path-of-building = warnAlias "'path-of-building' has been renamed to/replaced by 'lib.warnOnInstantiate'" lib.warnOnInstantiate; # Converted to warning 2026-07-01
  pcmanx-gtk2 = throw "'pcmanx-gtk2' has been removed has gtk2 has reach end of life"; # Added 2026-03-19
  pcmciaUtils = warnAlias "'pcmciaUtils' has been renamed to 'pcmciautils'" pcmciautils; # Added 2026-02-12
  pdf2djvu = throw "pdf2djvu has been removed because it was broken and archived upstream"; # added 2025-12-06
  pdf-quench = throw "'pdf-quench' has been removed as it was unmaintained upstream and depended on the outdated and vulnerable pypdf2"; # Added 2026-03-29
  pdfslicer = throw "'pdfslicer' has been removed because it was broken and abandoned upstream"; # added 2026-03-26
  pds = throw "'pds' has been renamed to/replaced by 'bluesky-pds'"; # Converted to throw 2026-07-01
  pdsadmin = throw "'pdsadmin' has been renamed to/replaced by 'bluesky-pdsadmin'"; # Converted to throw 2026-07-01
  pell = throw "'pell' has been removed as it is unused and unmaintained upstream"; # Added 2025-12-18
  pentobi = throw "'pentobi' has been removed as it was unmaintained in nixpkgs and still depended on qt5 webengine"; # Added 2026-04-25
  percona-server_8_0 = throw "'percona-server_8_0' reaches end of life on 2026-04-30 and has been removed. Use 'percona-server_8_4'"; # Added 2026-04-09
  percona-xtrabackup_8_0 = throw "'percona-xtrabackup_8_0' reaches end of life on 2026-04-30 and has been removed. Use 'percona-xtrabackup_8_4'"; # Added 2026-04-09
  petrifoo = throw "'petrifoo' was remove due to lack of maintenance and relying on gtk2"; # Added 2025-12-02
  pfstools = throw "'pfstools' was removed because it was broken and depends on an old version of ImageMagick"; # added 2026-02-26
  pinecone = throw "'pinecone' has been removed, as it is unmaintained and obsolete"; # Added 2026-03-31
  pingvin-share = throw "'pingvin-share' has been removed as it was broken and archived upstream"; # Added 2025-11-08
  pipecontrol = throw "'pipecontrol' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  plandex = throw "plandex has been removed, as it is not maintained anymore"; # Added 2026-05-18
  plandex-server = throw "plandex has been removed, as it is not maintained anymore"; # Added 2026-05-18
  plant-it = throw "plant-it backend was discontinued in september 2025"; # Added 2026-01-30
  plant-it-frontend = throw "plant-it-frontend has been presented as being Android-only since the server-side was discontinued in september 2025"; # Added 2026-01-30
  platformioPackages.platformio-chrootenv = warnAlias "'platformioPackages.platformio-chrootenv' has been renamed to/replaced by 'platformio-chrootenv'" platformio-chrootenv; # Converted to warning 2026-07-01
  platformioPackages.platformio-core = warnAlias "'platformioPackages.platformio-core' has been renamed to/replaced by 'platformio-core'" platformio-core; # Converted to warning 2026-07-01
  playbar2 = throw "'playbar2' has been removed, as Plasma 5 has reached end of life."; # Added 2026-05-01
  podofo_0_9 = throw "'podofo_0_9' has been deprecated, it may be replaced by 'podofo0'"; # Added 2026-05-08
  podofo_0_10 = warnAlias "'podofo_0_10' has been renamed to 'podofo0'" podofo0; # Added 2026-05-08
  podofo_1_0 = throw "'podofo_1_0' has been deprecated in favour of 'podofo'"; # Added 2026-05-08
  polyml56 = throw "'polyml56' has been deprecated in favor of polyml"; # Added 2026-06-01
  polyml57 = throw "'polyml57' has been deprecated in favor of polyml"; # Added 2026-06-01
  popura = throw "'popura' is abandoned upstream and in nixpkgs and has been removed"; # Added 2026-01-15
  postgres-lsp = throw "'postgres-lsp' has been renamed to/replaced by 'postgres-language-server'"; # Converted to throw 2026-07-01
  postgresql13Packages = throw "postgresql13Packages has been removed since it reached its EOL upstream"; # Added 2025-11-17
  postgresql_13 = throw "postgresql_13 has been removed since it reached its EOL upstream"; # Added 2025-11-17
  postgresql_13_jit = throw "postgresql_13_jit has been removed since it reached its EOL upstream"; # Added 2025-11-17
  pothos = throw "'pothos' has been removed as it relies on pcre, and is unmaintained upstream"; # Added 2026-06-17
  pqos-wrapper = throw "'pqos-wrapper' has been removed, since it's unmaintained since 2022 and archived upstream"; # Added 2026-05-13
  preload = throw "'preload' has been removed due to lack of usage and being broken since its introduction into nixpkgs"; # Added 2025-11-29
  premid = throw "'premid' has been removed, as it has been archived upstream since July 2024. Consider using the browser extension instead."; # Added 2026-04-04
  primusLib = warnAlias "'primusLib' has been renamed to 'primus-lib'" primus-lib; # Added 2026-02-12
  prisma = warnAlias "'prisma' has been renamed to/replaced by 'prisma_7'" prisma_7; # Converted to warning 2026-07-01
  prisma-engines = warnAlias "'prisma-engines' has been renamed to/replaced by 'prisma-engines_7'" prisma-engines_7; # Converted to warning 2026-07-01
  promtail = throw "promtail has been removed, as it reached its end of life. Consider migrating to 'grafana-alloy' or 'fluent-bit'"; # Added 2026-03-30
  protonvpn-gui = warnAlias "'protonvpn-gui' has been renamed to/replaced by 'proton-vpn'" proton-vpn; # Added 2026-02-23
  pscid = throw "'pscid' has been removed because it was unmaintained upstream"; # Added 2025-12-12
  psi = throw "'psi' has been removed as it depended on EOL qt5 webengine. Consider moving to psi-plus, a somewhat more maintained fork."; # Added 2026-04-15
  pulp = throw "'pulp' has been removed because it was unmaintained upstream"; # Added 2025-12-12
  purescript-psa = throw "'purescript-psa' has been removed because it was unmaintained within nixpkgs"; # Added 2025-12-12
  pyCA = warnAlias "'pyCA' was renamed to 'pyca'" pyca; # Added 2026-02-12
  pylint-exit = throw "'pylint-exit' was removed as it dependent on m2r which was removed."; # Added 2026-05-27
  pyload-ng = throw "'pyload-ng' has been removed due to vulnerabilities and being unmaintained"; # Added 2026-03-21
  pyotherside = warnAlias "'pyotherside' has been renamed to 'libsForQt5.pyotherside'. A Qt6 build is available at 'qt6Packages.pyotherside'."; # Added 2026-03-27
  python2 = throw "python2 has been removed; Python 2 is end-of-life. Use `python3` instead."; # Added 2026-05-03
  python2Full = throw "python2Full has been removed; Python 2 is end-of-life. Use `python3` instead."; # Added 2026-05-03
  python2Packages = throw "python2Packages has been removed; Python 2 is end-of-life. Use `python3Packages` instead."; # Added 2026-05-03
  python27 = throw "python27 has been removed from the top-level package set; Python 2 is end-of-life. Use `python3` instead."; # Added 2026-05-03
  python27Full = throw "python27Full has been removed; Python 2 is end-of-life. Use `python3` instead."; # Added 2026-05-03
  python27Packages = throw "python27Packages has been removed; Python 2 is end-of-life. Use `python3Packages` instead."; # Added 2026-05-03
  pywal = warnAlias "'pywal' has been renamed to/replaced by 'pywal16'" pywal16; # Converted to warning 2026-07-01
  q2pro = throw "'q2pro' has been removed as upstream repository was deleted and no direct active forks were available."; # Added 2025-12-27
  qes = throw "'qes' has been removed, as it has been merged into shkd"; # Added 2025-12-21
  qMasterPassword = warnAlias "'qMasterPassword' has been renamed to/replaced by 'qmasterpassword'" qmasterpassword; # Added 2026-02-01
  qMasterPassword-wayland = warnAlias "'qMasterPassword-wayland' has been renamed to/replaced by 'qmasterpassword-wayland'" qmasterpassword-wayland; # Added 2026-02-01
  qmenumodel = warnAlias "'qmenumodel' has been renamed to 'libsForQt5.qmenumodel'"; # Added 2026-03-26
  qsyncthingtray = throw "'qsyncthingtray' has been removed as it was unmaintained. Switch to 'syncthingtray' or 'syncthingtray-minimal'"; # Added 2026-01-29
  QuadProgpp = warnAlias "'QuadProgpp' has been renamed to 'quadprogpp'" quadprogpp; # Added 2026-02-12
  quaternion-qt6 = warnAlias "'quaternion-qt6 has been renamed to quaternion" quaternion; # Added 2025-12-31
  quictls = throw "'quictls' has been removed. QUIC support is now available in `openssl`."; # Added 2025-11-25
  quiterss = throw "'quiterss' has been removed as upstream has been unmaintained since March 2022"; # Added 2026-04-26
  quorum = throw "'quorum' has been removed as it was broken and unmaintained upstream"; # Added 2025-11-07
  qutebrowser-qt5 = warnAlias "'qutebrowser-qt5' has been renamed to/replaced by 'lib.warnOnInstantiate'" lib.warnOnInstantiate; # Converted to warning 2026-07-01
  ra-multiplex = warnAlias "'ra-multiplex' has been renamed to/replaced by 'lib.warnOnInstantiate'" lib.warnOnInstantiate; # Converted to warning 2026-07-01
  rabbit = throw "'rabbit' has been renamed to/replaced by 'rabbit-ng'"; # Added 2026-02-18
  radiance = throw "'radiance' has been removed as it was broken for a long time"; # Added 2026-01-02
  ragnarwm = throw "'ragnarwm' has been removed as it was broken"; # Added 2026-04-21
  rar2fs = throw "'rar2fs' has been removed as it is unmaintained, and depends on the unmaintained fuse2 library"; # Added 2026-05-19
  react-static = throw "'react-static' has been removed due to lack of maintenance upstream"; # Added 2025-11-04
  recurseIntoAttrs = throw "'recurseIntoAttrs' has been renamed to/replaced by 'lib.recurseIntoAttrs'"; # Converted to throw 2026-07-01
  redshift-plasma-applet = throw "'redshift-plasma-applet' has been removed as it is obsolete and lacks maintenance upstream."; # Added 2025-11-09
  reiserfsprogs = throw "'reiserfsprogs' has been removed as ReiserFS has not been actively maintained for many years."; # Added 2025-11-13
  remodel = throw "'remodel' has been removed because it was unmaintained upstream, deprecated in favor of 'lune'"; # Added 2026-05-08
  resp-app = throw "'resp-app' has been replaced by 'redisinsight'"; # Added 2025-12-17
  rili = throw "'rili' has been dropped in favor of its maintained fork 'li-ri'"; # Added 2026-01-03
  rke2_1_30 = throw "'rke2_1_30' has been removed from nixpkgs as it has reached end of life"; # Added 2025-11-04
  rke2_1_31 = throw "'rke2_1_31' has been removed from nixpkgs as it has reached end of life"; # Added 2025-12-08
  rke2_1_32 = throw "'rke2_1_32' has been removed from nixpkgs as it has reached end of life"; # Added 2026-04-04
  romdirfs = throw "'romdirfs' has been removed as it is unmaintained, and depends on fuse2"; # Added 2026-05-05
  rott = throw "'rott' has been dropped in favor of its maintained fork 'taradino'"; # Added 2026-01-25
  rott-shareware = throw "'rott-shareware' has been dropped in favor of its maintained fork 'taradino-shareware'"; # Added 2026-01-25
  rpPPPoE = warnAlias "'rpPPPoE' has been renamed to 'rp-pppoe'" rp-pppoe; # Added 2026-02-12
  rss-glx = throw "'rss-glx' has been removed because it was broken and depends on an outdated version of ImageMagick"; # added 2026-02-26
  ruby_3_5 = warnAlias "'ruby_3_5' has been renamed to/replaced by 'ruby_4_0'" ruby_4_0; # Converted to warning 2026-07-01
  rubyPackages_3_5 = warnAlias "'rubyPackages_3_5' has been renamed to/replaced by 'rubyPackages_4_0'" rubyPackages_4_0; # Converted to warning 2026-07-01
  runCommandNoCC = throw "'runCommandNoCC' has been renamed to/replaced by 'runCommand'"; # Converted to throw 2026-07-01
  runCommandNoCCLocal = throw "'runCommandNoCCLocal' has been renamed to/replaced by 'runCommandLocal'"; # Converted to throw 2026-07-01
  runescape = throw "'runescape' was removed due to a lack of maintenance, insecure dependencies, and incompatibility with Jagex accounts. Please consider using 'bolt-launcher' instead."; # Added 2026-02-24
  rust-hypervisor-firmware = throw "rust-hypevisor-firmware was removed, as it is no longer needed by Cloud Hypervisor and was broken"; # Added 2026-02-19
  rx = throw "'rx' has been dropped due to being broken since September 2025, with no complaints by any users of the package."; # Added 2026-04-05
  rymcast = throw "'rymcast' has been removed because it depended on the removed webkitgtk_4_0 and has been marked broken since October 2025"; # Added 2026-06-26
  scaphandre = throw "'scaphandre' was broken with no upstream progress since February 2025"; # Added 2026-06-14
  SDL_compat = sdl12-compat; # Added 2026-05-19
  securefs = throw "'securefs' has been removed as it depends on fuse2"; # Added 2026-05-05
  semantik = throw "'semantik' has been removed as it depended on EOL qt5 webengine"; # Added 2026-04-17
  semiphemeral = throw "'semiphemeral' has been removed as it is archived upstream"; # Added 2025-11-06
  sequoia-sqop = warnAlias "'sequoia-sqop' has been renamed to/replaced by 'sequoia-sop'" sequoia-sop; # Converted to warning 2026-07-01
  serverless = throw "'serverless' has been removed because version 3.x is unmaintained upstream and vulnerable, and version 4.x lacks a suitable binary or source download."; # Added 2025-11-22
  sgx-sdk = throw "'sgx-sdk' has been removed as it was unmaintained and broken"; # Added 2026-02-20
  sgx-ssl = throw "'sgx-ssl' has been removed as it was unmaintained and broken"; # Added 2026-02-20
  shades-of-gray-theme = throw "'shades-of-gray-theme' has been removed because upstream is a 404"; # Added 2025-12-20
  shared_desktop_ontologies = throw "'shared_desktop_ontologies' has been removed as it had been abandoned upstream"; # Added 2025-11-09
  shisho = throw "'shisho' has been removed, as it is archived upstream. Consider using 'semgrep', 'opengrep', or 'ast-grep' instead"; # Added 2026-04-28
  sic-image-cli = warnAlias "'sic-image-cli' has been renamed to 'imagineer'" imagineer; # Added 2026-03-29
  signal-desktop-bin = throw "'signal-desktop-bin' has been replaced by 'signal-desktop' which is built from source"; # Added 2026-03-02
  silver-searcher = throw "'silver-searcher' has been removed as it has seen no development since 2020 and is stuck on the obsolete pcre library. Consider using 'silver-searcher-ng', which is a fork with support for PCRE2."; # Added 2026-05-30
  simpleBluez = warnAlias "'simpleBluez' has been renamed to 'simplebluez'" simplebluez; # Added 2026-02-18
  simpleDBus = warnAlias "'simpleDBus' has been renamed to 'simpledbus'" simpledbus; # Added 2026-02-12
  simpleTpmPk11 = warnAlias "'simpleTpmPk11' has been renamed to 'simple-tpm-pk11'" simple-tpm-pk11; # Added 2026-02-12
  sioclient = throw "'sioclient' has been removed as it is no longer used by freedv, and doesn't build with newer asio"; # Added 2025-12-03
  skeu = throw "'skeu' has been removed as its source is unavailable"; # Added 2025-12-23
  sladeUnstable = warnAlias "'sladeUnstable' has been renamed to/replaced by 'slade-unstable'" slade-unstable; # Converted to warning 2026-07-01
  smtube = throw "'smtube' has been removed as it depends on insecure&unmaintained qtwebkit"; # Added 2026-04-26
  soundfont-generaluser = warnAlias "'soundfont-generaluser' has been renamed to 'soundfont-generaluser-gs'" soundfont-generaluser-gs; # Added 2026-02-26
  soundmodem = throw "'soundmodem' was removed due to lack of maintenance and relying on gtk2"; # Added 2025-12-02
  sourceHanPackages.mono = warnAlias "'sourceHanPackages.mono' has been renamed to 'source-han-mono'" source-han-mono; # Added 2025-11-03
  sourceHanPackages.sans = warnAlias "'sourceHanPackages.sans' has been renamed to 'source-han-sans'" source-han-sans; # Added 2025-11-03
  sourceHanPackages.sans-vf-otf = warnAlias "'sourceHanPackages.sans-vf-otf' has been renamed to 'source-han-sans-vf-otf'" source-han-sans-vf-otf; # Added 2025-11-03
  sourceHanPackages.sans-vf-ttf = warnAlias "'sourceHanPackages.sans-vf-ttf' has been renamed to 'source-han-sans-vf-ttf'" source-han-sans-vf-ttf; # Added 2025-11-03
  sourceHanPackages.serif = warnAlias "'sourceHanPackages.serif' has been renamed to 'source-han-serif'" source-han-serif; # Added 2025-11-03
  sourceHanPackages.serif-vf-otf = warnAlias "'sourceHanPackages.serif-vf-otf' has been renamed to 'source-han-serif-vf-otf'" source-han-serif-vf-otf; # Added 2025-11-03
  sourceHanPackages.serif-vf-ttf = warnAlias "'sourceHanPackages.serif-vf-ttf' has been renamed to 'source-han-serif-vf-ttf'" source-han-serif-vf-ttf; # Added 2025-11-03
  spacefm = throw "spacefm was dropped since it was unmaintained upstream."; # Added 2026-01-24
  spacevim = throw "'spacevim' has been removed due to being archived upstream."; # Added 2026-02-10
  spago = spago-legacy; # Added 2025-09-23, pkgs.spago should become spago@next which hasn't been packaged yet
  spectrojack = throw "'spectrojack' was remove due to lack of upstream maintenance and relying on gtk2"; # Added 2025-12-02
  speed_dreams = warnAlias "'speed_dreams' has been renamed to/replaced by 'speed-dreams'" speed-dreams; # Converted to warning 2026-07-01
  spoof = throw "'spoof' has been removed, as it is broken with the latest MacOS versions and is unmaintained upstream"; # Added 2025-11-14
  sqlar = throw "'sqlar' has been removed, as it is umaintained upstream, and depends on fuse2. Consider using the sqlite builtin VACUUM"; # Added 2026-06-05
  squirreldisk = throw "'squirreldisk' has been removed as it depended on webkitgtk 4.0"; # Added 2026-06-07
  src = throw "The \"src\" package has been renamed to \"simple-revision-control\". If you encounter this error and did not intend to use that package you may have a falsely constructed overlay."; # Added 2025-11-19
  stacer = throw "'stacer' has been removed because it was abandoned upstream and relied upon vulnerable software"; # Added 2025-11-08
  stalwart = warnAlias "`stalwart` is currently pinned to `0.15.5`. If `0.16.x` is needed, it is available as `stalwart_0_16`. Note: `stalwart_0_16` is not compatible with `services.stalwart` at this time." stalwart_0_15;
  stalwart-mail = warnAlias "'stalwart-mail' has been renamed to/replaced by 'stalwart'" stalwart; # Added 2026-01-19
  stremio = throw "'stremio' has been removed as it depended on the vulnerable and outdated qt5 webengine. On Linux, consider using 'stremio-linux-shell' instead."; # Added 2026-02-11
  stringsWithDeps = throw "'stringsWithDeps' has been renamed to/replaced by 'lib.stringsWithDeps'"; # Converted to throw 2026-07-01
  sublime = throw "'sublime' (version 2) has been removed as it was unmaintained and broken. Consider using 'sublime3' or 'sublime4' instead."; # Added 2026-06-13
  superTux = warnAlias "'superTux' has been renamed to 'supertux'" supertux; # Added 2026-02-12
  superTuxKart = warnAlias "'superTuxKart' has been renamed to 'supertuxkart'" supertuxkart; # Added 2026-02-12
  surge-XT = warnAlias "'surge-XT' has been renamed to 'surge-xt'" surge-xt; # Added 2026-02-12
  svnfs = throw "'svnfs' has been removed as it was unmaintained upstream"; # Added 2026-06-01
  svox = warnAlias "'svox' has been renamed to/replaced by 'picotts'" picotts; # Added 2026-03-04
  svt-av1-psy = warnAlias "'svt-av1-psy' has been replaced by 'svt-av1-psyex'" svt-av1-psyex; # Added 2026-01-10
  svt-av1-psyex = throw "'svt-av1-psyex' has been removed. Upstream suggests 'svt-av1-hdr' instead"; # Converted to throw 2026-06-23
  swagger-cli = throw "'swagger-cli' has been removed as it is broken and unmaintained. Upstream suggests using 'redocly' instead"; # Added 2026-04-23
  swww = warnAlias "'swww' has been renamed to 'awww'" awww; # Added 2026-03-22
  sylpheed = throw "'sylpheed' has been removed because it is broken and unmaintained, please use 'claws-mail' instead"; # Added 2026-04-22
  synapse-admin-etkecc = warnAlias "'synapse-admin-etkecc' has been renamed to 'ketesa'" ketesa; # Added 2026-04-03
  synth = throw "'synth' has been removed because it is unmaintained"; # Added 2025-11-15
  system = throw "'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'"; # Converted to throw 2026-07-01
  tamgamp.lv2 = warnAlias "'tamgamp.lv2' has been renamed to/replaced by 'tamgamp-lv2'" tamgamp-lv2; # Converted to warning 2026-07-01
  targetPlatform = throw "'targetPlatform' has been renamed to/replaced by 'stdenv.targetPlatform'"; # Converted to throw 2026-07-01
  tau-hydrogen = throw "'tau-hydrogen' has been removed because it's unmaintained upstream."; # Added 2026-04-26
  tbb = warnAlias "'tbb' has been renamed to/replaced by 'onetbb'" onetbb; # Converted to warning 2026-07-01
  tbb_2022 = warnAlias "'tbb_2022' has been renamed to/replaced by 'onetbb'" onetbb; # Converted to warning 2026-07-01
  tcptrace = throw "tcptrace has been removed as it was broken and upstream is gone"; # Added 2026-02-02
  tdfgo = throw "'tdfgo' has been removed because it was removed from upstream"; # Added 2025-12-18
  tdlib-purple = throw "'tdlib-purple' has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  teamspeak3 = throw "'teamspeak3' has been removed as it depended on qt5 webengine which is EOL"; # Added 2026-04-25
  ted = throw "'ted' has been removed as it is unmaintained and depends on pcre, which is deprecated"; # Added 2026-06-17
  telepathy-haze = throw "'telepathy-haze' has been removed due to being unmaintained and broken since 2023"; # Added 2025-11-04
  teleport_16 = throw "teleport 16 has been removed as it is EOL. Please upgrade to Teleport 17 or later"; # Added 2025-11-10
  temurin-bin-23 = throw "Temurin 23 has been removed as it has reached its end of life"; # Added 2025-11-04
  temurin-jre-bin-23 = throw "Temurin 23 has been removed as it has reached its end of life"; # Added 2025-11-04
  termbook = throw "'termbook' has been removed because it is not maintained upstream and has insecure dependencies."; # Added 2025-12-01
  termite = throw "'termite' has been removed as it was broken and unmaintained upstream"; # Added 2026-05-22
  tewi-font = throw "'tewi-font' has been removed because it was removed from upstream"; # Added 2025-12-18
  texinfo6 = throw "'texinfo6' has been removed in favor of the latest version"; # Added 2025-12-17
  tf2pulumi = throw "'tf2pulumi' has been removed because upstream removed the repo. Consider using https://github.com/pulumi/pulumi-converter-terraform instead"; # Added 2025-12-21
  thinkingRock = throw "'thinkingRock' has been removed due to being unmaintained decades old software"; # Added 2026-02-12
  tibia = throw "'tibia' has been removed from nixpkgs due to being broken and unmaintained"; # Added 2026-05-16
  tidb = throw "TiDB has been removed because of hard dependency on TiKV which is challenging to package"; # Added 2026-05-03
  tla = throw "'tla' has been removed as it is broken and unmaintained. Please use 'breezy' instead"; # Added 2026-04-23
  tlaplusToolbox = warnAlias "'tlaplusToolbox' has been renamed to/replaced by 'tlaplus-toolbox'" tlaplus-toolbox; # Converted to warning 2026-07-01
  tm = throw "'tm' has been removed as it is broken and hasn't been maintained upstream since 2014"; # Added 2026-05-05
  tooling-language-server = warnAlias "'tooling-language-server' has been renamed to/replaced by 'deputy'" deputy; # Converted to warning 2026-07-01
  tora = throw "'tora' has been removed due to outdated KF5 dependencies."; # Added 2026-05-01
  torrent7z = throw "torrent7z is unmaintained and used a p7zip version from 2009. Consider using p7zip with the arguments to remove entropy instead"; # added 2026-05-09
  transmission_4-qt5 = lib.warnOnInstantiate "'transmission_4-qt5' has been removed in favour of 'transmission_4-qt'" transmission_4-qt; # Added 2026-06-25
  transmission_4-qt6 = lib.warnOnInstantiate "'transmission_4-qt6' has been renamed to 'transmission_4-qt'" transmission_4-qt; # Added 2026-06-25
  travis = throw "'travis' has been removed because upstream has stopped maintaining it, and it contains dependencies with security vulnerabilities."; # Added 2026-02-14
  tremor-language-server = throw "'tremor-language-server' has been removed because it is unmaintained"; # Added 2025-11-17
  tremor-rs = throw "'tremor-rs' has been removed because it is unmaintained"; # Added 2025-11-17
  trilium-next-desktop = warnAlias "'trilium-next-desktop' has been renamed to/replaced by 'trilium-desktop'" trilium-desktop; # Converted to warning 2026-07-01
  trilium-next-server = warnAlias "'trilium-next-server' has been renamed to/replaced by 'trilium-server'" trilium-server; # Converted to warning 2026-07-01
  twitterBootstrap = warnAlias "'twitterBootstrap' has been renamed to 'twitter-bootstrap'"; # Added 2026-02-12
  typodermic-free-fonts = throw "'typodermic-free-fonts' has been removed as it is unmaintained in nixpkgs, and the src is prone to breakage."; # Added 2026-05-07
  typodermic-public-domain = throw "'typodermic-public-domain' has been removed as it is unmaintained in nixpkgs, and the src is prone to breakage."; # Added 2026-05-07
  udisks2 = warnAlias "'udisks2' has been renamed to/replaced by 'udisks'" udisks; # Converted to warning 2026-07-01
  ue4demos = throw "'ue4demos' has been removed because it is unmaintained"; # Added 2026-02-07
  ugarit-manifest-maker = throw "'ugarit-manifest-maker' has been removed because it is unmaintained"; # Added 2026-05-07
  uhttpmock_1_0 = warnAlias "'uhttpmock_1_0' has been renamed to 'uhttpmock'" uhttpmock; # Added 2026-05-30
  unixODBC = warnAlias "'unixODBC' has been renamed to 'unixodbc'" unixodbc; # Added 2026-02-12
  unixODBCDrivers = warnAlias "'unixODBCDrivers' has been renamed to 'unixodbcDrivers'" unixodbcDrivers; # Added 2026-02-12
  unrar_6 = throw "'unrar_6' has been renamed to/replaced by 'unrar'"; # Added 2026-03-11
  ustream-ssl-wolfssl = throw "'ustream-ssl-wolfssl' has been removed, use 'ustream-ssl' or 'ustream-ssl-mbedtls'"; # Added 2026-03-29
  usync = throw "'usync' has been removed as it is unused and unmaintained upstream"; # Added 2025-12-18
  utillinux = throw "'utillinux' has been renamed to/replaced by 'util-linux'"; # Converted to throw 2026-07-01
  utilmacros = warnAlias "'utilmacros' has been renamed to/replaced by 'util-macros'" util-macros; # Converted to warning 2026-07-01
  vacuum = throw "'vacuum' has been removed as upstream Vacuum-IM has been unmaintained since December 2021"; # Added 2026-04-26
  vapoursynth-nnedi3 = throw "'vapoursynth-nnedi3' has been removed per upstream. Use vapoursynth-znedi3 instead."; # Added 2026-04-20
  varnish60 = throw "varnish 6.0 has been removed as it used unmaintaned dependencies. Please upgrade to 'varnish80' or 'vinyl-cache_9'."; # Added 2026-05-29
  varnish60Packages = throw "varnish 6.0 has been removed as it used unmaintained dependencies.  Please upgrade to 'varnish80' or 'vinyl-cache_9'."; # Added 2026-05-29
  varnish77 = throw "varnish 7.7 is EOL. Please upgrade to 'varnish80' or 'vinyl-cache_9'."; # Added 2026-05-01
  varnish77Packages = throw "varnish 7.7 is EOL. Please upgrade to 'varnish80' or 'vinyl-cache_9'."; # Added 2026-05-01
  vazir-fonts = throw "'vazir-fonts' has been renamed to 'vazirmatn'"; # Added 2026-06-15
  vboot_reference = warnAlias "'vboot_reference' has been renamed to/replaced by 'vboot-utils'" vboot-utils; # Converted to warning 2026-07-01
  vcstool = throw "'vcstool' has been removed, as it has been unmaintained upstream since January 2022. Please switch to 'vcs2l'"; # Added 2026-03-13
  vdhcoapp = throw "VDH >= 10 doesn't require a companion app and the repo has been archived."; # Added 2026-01-26
  verco = throw "'verco' has been removed, as it has been unmaintained upstream since November 2023"; # Added 2026-01-01
  veriT = warnAlias "'veriT' has been renamed to/replaced by 'verit'" verit; # Converted to warning 2026-07-01
  video2midi = throw "'video2midi' has been removed due to lack of maintenance"; # Added 2026-01-01
  vimpc = throw "'vimpc' has been removed as it is unmaintained and depends on pcre, which is deprecated"; # Added 2026-06-06
  vmfs-tools = throw "'vmfs-tools' has been removed as it depends on unsupported fuse2 and is unmaintained upstream"; # Added 2026-06-07
  vpWithSixel = throw "'vpWithSixel' has been removed as vp switched to SDL2 which does not support sixel"; # Added 2026-02-06
  vtk_9 = throw "'vtk_9' has been renamed to/replaced by 'vtk_9_5'"; # Converted to throw 2026-07-01
  vtk_9_egl = throw "'vtk_9_egl' has been renamed to/replaced by 'vtk_9_5'"; # Converted to throw 2026-07-01
  warmux = throw "'warmux' has been removed as it is unmaintained and broken"; # Added 2025-11-03
  wasistlos = throw "'wasistlos' has been removed because it was unmaintained and archived upstream. Consider using 'karere' instead"; # Added 2026-04-13
  wasm3 = throw "'wasm3' has been removed as it is unmaintained upstream and has many known vulnerabilities"; # Added 2026-06-03
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_121;
  wasm-strip = throw "'wasm-strip' has been removed due to upstream deprecation. Use 'wabt' instead."; # Added 2025-11-06
  wayv = throw "'wayv' has been removed as it is broken and unmaintained upstream"; # Added 2026-05-05
  wayvr-dashboard = throw "'wayvr-dashboard' and 'wlx-overlay-s' have been merged into a single application. Please switch to 'wayvr'"; # Added 2026-01-09
  wdfs = throw "'wdfs' has been removed as it is unmaintained, and depends on fuse2. Consider using 'davfs2' instead"; # Added 2026-05-05
  webfontkitgenerator = warnAlias "'webfontkitgenerator' has been renamed to/replaced by 'webfont-bundler'" webfont-bundler; # Converted to warning 2026-07-01
  webmacs = throw "webmacs has been removed as it was unmaintained upstream"; # Added 2026-02-03
  welkin = throw "welkin was removed as it is unmaintained upstream"; # Added 2026-01-01
  whalebird = throw "'whalebird' has been removed because it was using an EOL electron version"; # Added 2026-03-20
  whisper = throw "'whisper' was removed as it is unmaintained upstream and vendored insecure outdated libraries"; # Added 2026-05-01
  windsurf = warnAlias "'windsurf' has been rebranded and replaced as 'devin-desktop'" devin-desktop;
  wineWowPackages =
    warnAlias
      "'wineWowPackages' is deprecated as it is no longer preferred by upstream. Use wineWow64Packages instead"
      lib.recurseIntoAttrs
      (winePackagesFor "wineWow");
  wingpanel-indicator-ayatana = throw "'wingpanel-indicator-ayatana' has been removed as it is archived upstream and doesn't work with pantheon 8 and onwards. Use wingpanel-indicator-namarupa instead"; # Added 2026-01-14
  wireshark-qt = warnAlias "'wireshark-qt' has been renamed to/replaced by 'wireshark'" wireshark; # Added 2026-01-23
  wlroots_0_17 = throw "'wlroots_0_17' has been removed in favor of newer versions"; # Added 2026-03-07
  wlroots_0_18 = throw "'wlroots_0_18' has been removed in favor of newer versions"; # Added 2026-05-13
  wlx-overlay-s = throw "'wlx-overlay-s' and 'wayvr-dashboard' have been merged into a single application. Please switch to 'wayvr'"; # Added 2026-01-09
  wolfssl = throw "'wolfssl' has been removed because it has an unclear licensing situation and no remaining users in Nixpkgs"; # Added 2026-04-03
  wordpress_6_7 = throw "'wordpress_6_7' has been removed in favor of the new release, as it is unmaintained upstream"; # Added 2026-05-22
  wrangler_1 = throw "'wrangler_1' has been removed as it has been abandoned upstream and has known vulnerabilities, consider using 'wrangler' instead."; # Added 2026-02-01
  wrapGradle = throw "'wrapGradle' has been removed; use `gradle-packages.wrapGradle` or `(gradle-packages.mkGradle { ... }).wrapped` instead"; # Added 2025-11-02
  wring = throw "'wring' has been removed since it has been abandoned upstream"; # Added 2025-11-07
  wslu = throw "'wslu' has been removed because the project has been discontinued and the repository has been archived"; # Added 2026-04-08
  wxGTK31 = warnAlias "'wxGTK31' has been renamed to 'wxwidgets_3_1'" wxwidgets_3_1; # Added 2026-02-12
  wxGTK32 = warnAlias "'wxGTK32' has been renamed to 'wxwidgets_3_2'" wxwidgets_3_2; # Added 2026-02-12
  wxGTK33 = warnAlias "'wxGTK33' has been renamed to/replaced by 'wxwidgets_3_3'" wxwidgets_3_3; # Converted to warning 2026-07-01
  wxSVG = warnAlias "'wxSVG' has been renamed to 'wxsvg'" wxsvg; # Added 2026-02-12
  Xaw3d = warnAlias "'Xaw3d' has been renamed to 'libxaw3d'" libxaw3d; # Added 2026-02-12
  xbindkeys-config = throw "'xbindkeys-config' has been removed as it is broken and unmaintained upstream"; # Added 2026-04-18
  xcb-util-cursor = warnAlias "'xcb-util-cursor' has been renamed to/replaced by 'libxcb-cursor'" libxcb-cursor; # Converted to warning 2026-07-01
  xcb-util-cursor-HEAD = warnAlias "'xcb-util-cursor-HEAD' has been removed; use 'libxcb-cursor' instead" libxcb-cursor; # added 2026-01-12
  xcbutil = warnAlias "'xcbutil' has been renamed to/replaced by 'libxcb-util'" libxcb-util; # Converted to warning 2026-07-01
  xcbutilcursor = warnAlias "'xcbutilcursor' has been renamed to/replaced by 'libxcb-cursor'" libxcb-cursor; # Converted to warning 2026-07-01
  xcbutilerrors = warnAlias "'xcbutilerrors' has been renamed to/replaced by 'libxcb-errors'" libxcb-errors; # Converted to warning 2026-07-01
  xcbutilimage = warnAlias "'xcbutilimage' has been renamed to/replaced by 'libxcb-image'" libxcb-image; # Converted to warning 2026-07-01
  xcbutilkeysyms = warnAlias "'xcbutilkeysyms' has been renamed to/replaced by 'libxcb-keysyms'" libxcb-keysyms; # Converted to warning 2026-07-01
  xcbutilrenderutil = warnAlias "'xcbutilrenderutil' has been renamed to/replaced by 'libxcb-render-util'" libxcb-render-util; # Converted to warning 2026-07-01
  xcbutilwm = warnAlias "'xcbutilwm' has been renamed to/replaced by 'libxcb-wm'" libxcb-wm; # Converted to warning 2026-07-01
  xcursorthemes = warnAlias "'xcursorthemes' has been renamed to/replaced by 'xcursor-themes'" xcursor-themes; # Converted to warning 2026-07-01
  xdeltaUnstable = throw "'xdeltaUnstable' has been replaced by 'xdelta'"; # Added 2026-02-17
  xdg-terminal-exec-mkhl = warnAlias "
    'xdg-terminal-exec-mkhl' has been removed due to being behind the xdg-terminal-exec spec for too long,
    use the reference implementation 'xdg-terminal-exec' instead.
  " xdg-terminal-exec; # Added 2026-01-14
  xf86-input-cmt = throw "'xf86-input-cmt' has been removed as it was broken and unmaintained upstream"; # Added 2026-05-09
  xf86_input_cmt = warnAlias "'xf86_input_cmt' has been renamed to/replaced by 'xf86-input-cmt'" xf86-input-cmt; # Converted to warning 2026-07-01
  xf86_input_wacom = warnAlias "'xf86_input_wacom' has been renamed to/replaced by 'xf86-input-wacom'" xf86-input-wacom; # Converted to warning 2026-07-01
  xf86_video_nested = warnAlias "'xf86_video_nested' has been renamed to/replaced by 'xf86-video-nested'" xf86-video-nested; # Converted to warning 2026-07-01
  xf86inputevdev = warnAlias "'xf86inputevdev' has been renamed to/replaced by 'xf86-input-evdev'" xf86-input-evdev; # Converted to warning 2026-07-01
  xf86inputjoystick = warnAlias "'xf86inputjoystick' has been renamed to/replaced by 'xf86-input-joystick'" xf86-input-joystick; # Converted to warning 2026-07-01
  xf86inputkeyboard = warnAlias "'xf86inputkeyboard' has been renamed to/replaced by 'xf86-input-keyboard'" xf86-input-keyboard; # Converted to warning 2026-07-01
  xf86inputlibinput = warnAlias "'xf86inputlibinput' has been renamed to/replaced by 'xf86-input-libinput'" xf86-input-libinput; # Converted to warning 2026-07-01
  xf86inputmouse = warnAlias "'xf86inputmouse' has been renamed to/replaced by 'xf86-input-mouse'" xf86-input-mouse; # Converted to warning 2026-07-01
  xf86inputsynaptics = warnAlias "'xf86inputsynaptics' has been renamed to/replaced by 'xf86-input-synaptics'" xf86-input-synaptics; # Converted to warning 2026-07-01
  xf86inputvmmouse = warnAlias "'xf86inputvmmouse' has been renamed to/replaced by 'xf86-input-vmmouse'" xf86-input-vmmouse; # Converted to warning 2026-07-01
  xf86inputvoid = warnAlias "'xf86inputvoid' has been renamed to/replaced by 'xf86-input-void'" xf86-input-void; # Converted to warning 2026-07-01
  xf86videoamdgpu = warnAlias "'xf86videoamdgpu' has been renamed to/replaced by 'xf86-video-amdgpu'" xf86-video-amdgpu; # Converted to warning 2026-07-01
  xf86videoapm = warnAlias "'xf86videoapm' has been renamed to/replaced by 'xf86-video-apm'" xf86-video-apm; # Converted to warning 2026-07-01
  xf86videoark = warnAlias "'xf86videoark' has been renamed to/replaced by 'xf86-video-ark'" xf86-video-ark; # Converted to warning 2026-07-01
  xf86videoast = warnAlias "'xf86videoast' has been renamed to/replaced by 'xf86-video-ast'" xf86-video-ast; # Converted to warning 2026-07-01
  xf86videoati = warnAlias "'xf86videoati' has been renamed to/replaced by 'xf86-video-ati'" xf86-video-ati; # Converted to warning 2026-07-01
  xf86videochips = warnAlias "'xf86videochips' has been renamed to/replaced by 'xf86-video-chips'" xf86-video-chips; # Converted to warning 2026-07-01
  xf86videocirrus = warnAlias "'xf86videocirrus' has been renamed to/replaced by 'xf86-video-cirrus'" xf86-video-cirrus; # Converted to warning 2026-07-01
  xf86videodummy = warnAlias "'xf86videodummy' has been renamed to/replaced by 'xf86-video-dummy'" xf86-video-dummy; # Converted to warning 2026-07-01
  xf86videofbdev = warnAlias "'xf86videofbdev' has been renamed to/replaced by 'xf86-video-fbdev'" xf86-video-fbdev; # Converted to warning 2026-07-01
  xf86videogeode = warnAlias "'xf86videogeode' has been renamed to/replaced by 'xf86-video-geode'" xf86-video-geode; # Converted to warning 2026-07-01
  xf86videoglide = throw "The Xorg Glide video driver has been archived upstream due to being obsolete"; # added 2025-12-13
  xf86videoglint = throw "The Xorg GLINT/Permedia video driver has been broken since xorg 21. see https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1"; # added 2025-12-13
  xf86videoi128 = warnAlias "'xf86videoi128' has been renamed to/replaced by 'xf86-video-i128'" xf86-video-i128; # Converted to warning 2026-07-01
  xf86videoi740 = warnAlias "'xf86videoi740' has been renamed to/replaced by 'xf86-video-i740'" xf86-video-i740; # Converted to warning 2026-07-01
  xf86videointel = warnAlias "'xf86videointel' has been renamed to/replaced by 'xf86-video-intel'" xf86-video-intel; # Converted to warning 2026-07-01
  xf86videomga = warnAlias "'xf86videomga' has been renamed to/replaced by 'xf86-video-mga'" xf86-video-mga; # Converted to warning 2026-07-01
  xf86videoneomagic = warnAlias "'xf86videoneomagic' has been renamed to/replaced by 'xf86-video-neomagic'" xf86-video-neomagic; # Converted to warning 2026-07-01
  xf86videonewport = throw "The Xorg Newport video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xf86videonouveau = warnAlias "'xf86videonouveau' has been renamed to/replaced by 'xf86-video-nouveau'" xf86-video-nouveau; # Converted to warning 2026-07-01
  xf86videonv = warnAlias "'xf86videonv' has been renamed to/replaced by 'xf86-video-nv'" xf86-video-nv; # Converted to warning 2026-07-01
  xf86videoomap = warnAlias "'xf86videoomap' has been renamed to/replaced by 'xf86-video-omap'" xf86-video-omap; # Converted to warning 2026-07-01
  xf86videoopenchrome = warnAlias "'xf86videoopenchrome' has been renamed to/replaced by 'xf86-video-openchrome'" xf86-video-openchrome; # Converted to warning 2026-07-01
  xf86videoqxl = warnAlias "'xf86videoqxl' has been renamed to/replaced by 'xf86-video-qxl'" xf86-video-qxl; # Converted to warning 2026-07-01
  xf86videor128 = warnAlias "'xf86videor128' has been renamed to/replaced by 'xf86-video-r128'" xf86-video-r128; # Converted to warning 2026-07-01
  xf86videos3virge = warnAlias "'xf86videos3virge' has been renamed to/replaced by 'xf86-video-s3virge'" xf86-video-s3virge; # Converted to warning 2026-07-01
  xf86videosavage = warnAlias "'xf86videosavage' has been renamed to/replaced by 'xf86-video-savage'" xf86-video-savage; # Converted to warning 2026-07-01
  xf86videosiliconmotion = warnAlias "'xf86videosiliconmotion' has been renamed to/replaced by 'xf86-video-siliconmotion'" xf86-video-siliconmotion; # Converted to warning 2026-07-01
  xf86videosis = warnAlias "'xf86videosis' has been renamed to/replaced by 'xf86-video-sis'" xf86-video-sis; # Converted to warning 2026-07-01
  xf86videosisusb = warnAlias "'xf86videosisusb' has been renamed to/replaced by 'xf86-video-sisusb'" xf86-video-sisusb; # Converted to warning 2026-07-01
  xf86videosuncg6 = warnAlias "'xf86videosuncg6' has been renamed to/replaced by 'xf86-video-suncg6'" xf86-video-suncg6; # Converted to warning 2026-07-01
  xf86videosunffb = warnAlias "'xf86videosunffb' has been renamed to/replaced by 'xf86-video-sunffb'" xf86-video-sunffb; # Converted to warning 2026-07-01
  xf86videosunleo = warnAlias "'xf86videosunleo' has been renamed to/replaced by 'xf86-video-sunleo'" xf86-video-sunleo; # Converted to warning 2026-07-01
  xf86videotdfx = warnAlias "'xf86videotdfx' has been renamed to/replaced by 'xf86-video-tdfx'" xf86-video-tdfx; # Converted to warning 2026-07-01
  xf86videotga = throw "The Xorg TGA (aka DEC 21030) video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xf86videotrident = warnAlias "'xf86videotrident' has been renamed to/replaced by 'xf86-video-trident'" xf86-video-trident; # Converted to warning 2026-07-01
  xf86videov4l = warnAlias "'xf86videov4l' has been renamed to/replaced by 'xf86-video-v4l'" xf86-video-v4l; # Converted to warning 2026-07-01
  xf86videovboxvideo = warnAlias "'xf86videovboxvideo' has been renamed to/replaced by 'xf86-video-vbox'" xf86-video-vbox; # Converted to warning 2026-07-01
  xf86videovesa = warnAlias "'xf86videovesa' has been renamed to/replaced by 'xf86-video-vesa'" xf86-video-vesa; # Converted to warning 2026-07-01
  xf86videovmware = warnAlias "'xf86videovmware' has been renamed to/replaced by 'xf86-video-vmware'" xf86-video-vmware; # Converted to warning 2026-07-01
  xf86videovoodoo = warnAlias "'xf86videovoodoo' has been renamed to/replaced by 'xf86-video-voodoo'" xf86-video-voodoo; # Converted to warning 2026-07-01
  xf86videowsfb = throw "The Xorg BSD wsdisplay framebuffer video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xinput_calibrator = warnAlias "'xinput_calibrator' has been renamed to/replaced by 'xinput-calibrator'" xinput-calibrator; # Converted to warning 2026-07-01
  xkeyboardconfig = warnAlias "'xkeyboardconfig' has been renamed to/replaced by 'xkeyboard-config'" xkeyboard-config; # Converted to warning 2026-07-01
  xkeyboardconfig_custom = warnAlias "'xkeyboardconfig_custom' has been renamed to/replaced by 'xkeyboard-config_custom'" xkeyboard-config_custom; # Converted to warning 2026-07-01
  xloadimage = throw "'xloadimage' has been removed as it was unmaintained upstream"; # Added 2026-05-05
  xneur = throw "'xneur' has been removed as it is unmaintained and depends on pcre, which is deprecated"; # Added 2026-06-06
  xorg =
    warnAlias "'xorg' has been renamed to/replaced by '#'" # ; # Converted to warning 2026-07-01
      lib.mapAttrs
      (
        name: value:
        warnAlias "The xorg package set has been deprecated, 'xorg.${name}' has been renamed to '${name}'" value
      )
      {
        inherit
          # keep-sorted start case=no numeric=no block=yes
          appres
          bdftopcf
          bitmap
          editres
          fonttosfnt
          gccmakedep
          iceauth
          ico
          imake
          libdmx
          libfontenc
          libpciaccess
          libxcb
          libxcvt
          libxkbfile
          libxshmfence
          listres
          lndir
          luit
          makedepend
          mkfontscale
          oclock
          pixman
          sessreg
          setxkbmap
          smproxy
          transset
          viewres
          wrapWithXFileSearchPathHook
          x11perf
          xauth
          xbacklight
          xbitmaps
          xcalc
          xclock
          xcmsdb
          xcompmgr
          xconsole
          xcursorgen
          xdm
          xdpyinfo
          xdriinfo
          xev
          xeyes
          xfd
          xfontsel
          xfs
          xfsinfo
          xgamma
          xgc
          xhost
          xinit
          xinput
          xkbcomp
          xkbevd
          xkbprint
          xkbutils
          xkill
          xload
          xlsatoms
          xlsclients
          xlsfonts
          xmag
          xmessage
          xmodmap
          xmore
          xorgproto
          xpr
          xprop
          xrandr
          xrdb
          xrefresh
          xset
          xsetroot
          xsm
          xstdcmap
          xtrans
          xvfb
          xvinfo
          xwd
          xwininfo
          xwud
          # keep-sorted end
          ;
      }
    //
      lib.mapAttrs
        (
          name: value:
          warnAlias "The xorg package set has been deprecated, 'xorg.${name}' has been renamed to '${value}'"
            self.${value}
        )
        {
          # keep-sorted start case=no numeric=no block=yes
          encodings = "font-encodings";
          fontadobe100dpi = "font-adobe-100dpi";
          fontadobe75dpi = "font-adobe-75dpi";
          fontadobeutopia100dpi = "font-adobe-utopia-100dpi";
          fontadobeutopia75dpi = "font-adobe-utopia-75dpi";
          fontadobeutopiatype1 = "font-adobe-utopia-type1";
          fontalias = "font-alias";
          fontarabicmisc = "font-arabic-misc";
          fontbh100dpi = "font-bh-100dpi";
          fontbh75dpi = "font-bh-75dpi";
          fontbhlucidatypewriter100dpi = "font-bh-lucidatypewriter-100dpi";
          fontbhlucidatypewriter75dpi = "font-bh-lucidatypewriter-75dpi";
          fontbhttf = "font-bh-ttf";
          fontbhtype1 = "font-bh-type1";
          fontbitstream100dpi = "font-bitstream-100dpi";
          fontbitstream75dpi = "font-bitstream-75dpi";
          fontbitstreamtype1 = "font-bitstream-type1";
          fontcronyxcyrillic = "font-cronyx-cyrillic";
          fontcursormisc = "font-cursor-misc";
          fontdaewoomisc = "font-daewoo-misc";
          fontdecmisc = "font-dec-misc";
          fontibmtype1 = "font-ibm-type1";
          fontisasmisc = "font-isas-misc";
          fontjismisc = "font-jis-misc";
          fontmicromisc = "font-micro-misc";
          fontmisccyrillic = "font-misc-cyrillic";
          fontmiscethiopic = "font-misc-ethiopic";
          fontmiscmeltho = "font-misc-meltho";
          fontmiscmisc = "font-misc-misc";
          fontmuttmisc = "font-mutt-misc";
          fontschumachermisc = "font-schumacher-misc";
          fontscreencyrillic = "font-screen-cyrillic";
          fontsonymisc = "font-sony-misc";
          fontsunmisc = "font-sun-misc";
          fontutil = "font-util";
          fontwinitzkicyrillic = "font-winitzki-cyrillic";
          fontxfree86type1 = "font-xfree86-type1";
          libAppleWM = "libapplewm";
          libFS = "libfs";
          libICE = "libice";
          libpthreadstubs = "libpthread-stubs";
          libSM = "libsm";
          libWindowsWM = "libwindowswm";
          libX11 = "libx11";
          libXau = "libxau";
          libXaw = "libxaw";
          libXcomposite = "libxcomposite";
          libXcursor = "libxcursor";
          libXdamage = "libxdamage";
          libXdmcp = "libxdmcp";
          libXext = "libxext";
          libXfixes = "libxfixes";
          libXfont = "libxfont_1";
          libXfont2 = "libxfont_2";
          libXft = "libxft";
          libXi = "libxi";
          libXinerama = "libxinerama";
          libXmu = "libxmu";
          libXp = "libxp";
          libXpm = "libxpm";
          libXpresent = "libxpresent";
          libXrandr = "libxrandr";
          libXrender = "libxrender";
          libXres = "libxres";
          libXScrnSaver = "libxscrnsaver";
          libXt = "libxt";
          libXtst = "libxtst";
          libXv = "libxv";
          libXvMC = "libxvmc";
          libXxf86dga = "libxxf86dga";
          libXxf86misc = "libxxf86misc";
          libXxf86vm = "libxxf86vm";
          mkfontdir = "mkfontscale";
          twm = "tab-window-manager";
          utilmacros = "util-macros";
          xcbproto = "xcb-proto";
          xcbutil = "libxcb-util";
          xcbutilcursor = "libxcb-cursor";
          xcbutilerrors = "libxcb-errors";
          xcbutilimage = "libxcb-image";
          xcbutilkeysyms = "libxcb-keysyms";
          xcbutilrenderutil = "libxcb-render-util";
          xcbutilwm = "libxcb-wm";
          xcursorthemes = "xcursor-themes";
          xf86inputevdev = "xf86-input-evdev";
          xf86inputjoystick = "xf86-input-joystick";
          xf86inputkeyboard = "xf86-input-keyboard";
          xf86inputlibinput = "xf86-input-libinput";
          xf86inputmouse = "xf86-input-mouse";
          xf86inputsynaptics = "xf86-input-synaptics";
          xf86inputvmmouse = "xf86-input-vmmouse";
          xf86inputvoid = "xf86-input-void";
          xf86videoamdgpu = "xf86-video-amdgpu";
          xf86videoapm = "xf86-video-apm";
          xf86videoark = "xf86-video-ark";
          xf86videoast = "xf86-video-ast";
          xf86videoati = "xf86-video-ati";
          xf86videochips = "xf86-video-chips";
          xf86videocirrus = "xf86-video-cirrus";
          xf86videodummy = "xf86-video-dummy";
          xf86videofbdev = "xf86-video-fbdev";
          xf86videogeode = "xf86-video-geode";
          xf86videoi128 = "xf86-video-i128";
          xf86videoi740 = "xf86-video-i740";
          xf86videointel = "xf86-video-intel";
          xf86videomga = "xf86-video-mga";
          xf86videoneomagic = "xf86-video-neomagic";
          xf86videonouveau = "xf86-video-nouveau";
          xf86videonv = "xf86-video-nv";
          xf86videoomap = "xf86-video-omap";
          xf86videoopenchrome = "xf86-video-openchrome";
          xf86videoqxl = "xf86-video-qxl";
          xf86videor128 = "xf86-video-r128";
          xf86videos3virge = "xf86-video-s3virge";
          xf86videosavage = "xf86-video-savage";
          xf86videosiliconmotion = "xf86-video-siliconmotion";
          xf86videosis = "xf86-video-sis";
          xf86videosisusb = "xf86-video-sisusb";
          xf86videosuncg6 = "xf86-video-suncg6";
          xf86videosunffb = "xf86-video-sunffb";
          xf86videosunleo = "xf86-video-sunleo";
          xf86videotdfx = "xf86-video-tdfx";
          xf86videotrident = "xf86-video-trident";
          xf86videov4l = "xf86-video-v4l";
          xf86videovboxvideo = "xf86-video-vbox";
          xf86videovesa = "xf86-video-vesa";
          xf86videovmware = "xf86-video-vmware";
          xf86videovoodoo = "xf86-video-voodoo";
          xkeyboardconfig = "xkeyboard-config";
          xkeyboardconfig_custom = "xkeyboard-config_custom";
          xorgcffiles = "xorg-cf-files";
          xorgdocs = "xorg-docs";
          xorgserver = "xorg-server";
          xorgsgmldoctools = "xorg-sgml-doctools";
          # keep-sorted end
        }
    // {
      # keep-sorted start case=no numeric=no block=yes
      callPackage = throw "The xorg package set has been moved to the top level."; # Added 2026-01-29
      libXtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
      newScope = throw "The xorg package set has been moved to the top level."; # Added 2026-01-29
      overrideScope = throw "The xorg package set has been moved to the top level."; # Added 2026-01-29
      packages = throw "The xorg package set has been moved to the top level."; # Added 2026-01-29
      xf86videoglide = throw "The Xorg Glide video driver has been archived upstream due to being obsolete"; # added 2025-12-13
      xf86videoglint = throw ''
        The Xorg GLINT/Permedia video driver has been broken since xorg 21.
        see https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1''; # added 2025-12-13
      xf86videonewport = throw "The Xorg Newport video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
      xf86videotga = throw "The Xorg TGA (aka DEC 21030) video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
      xf86videowsfb = throw "The Xorg BSD wsdisplay framebuffer video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
      xtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
      # keep-sorted end
    };
  xorg-autoconf = warnAlias "'xorg-autoconf' has been renamed to/replaced by 'util-macros'" util-macros; # Converted to warning 2026-07-01
  xorgcffiles = warnAlias "'xorgcffiles' has been renamed to/replaced by 'xorg-cf-files'" xorg-cf-files; # Converted to warning 2026-07-01
  xorgdocs = warnAlias "'xorgdocs' has been renamed to/replaced by 'xorg-docs'" xorg-docs; # Converted to warning 2026-07-01
  xorgserver = warnAlias "'xorgserver' has been renamed to/replaced by 'xorg-server'" xorg-server; # Converted to warning 2026-07-01
  xorgsgmldoctools = warnAlias "'xorgsgmldoctools' has been renamed to/replaced by 'xorg-sgml-doctools'" xorg-sgml-doctools; # Converted to warning 2026-07-01
  xow_dongle-firmware = throw "'xow_dongle-firmware' has been renamed to/replaced by 'xone-dongle-firmware'"; # Added 2025-12-30
  xp-pen-deco-01-v2-driver = warnAlias "'xp-pen-deco-01-v2-driver' has been replaced by 'xppen_4'. Consider using it with 'programs.xppen' module." xppen_4; # Added 2026-02-02
  xp-pen-g430-driver = warnAlias "'xp-pen-g430-driver' has been replaced by 'xppen_3'. Consider using it with 'programs.xppen' module." xppen_3; # Added 2026-02-02
  xplorer = throw "'xplorer' has been removed as was unmaintained in Nixpkgs and needed upgrading to the experimental Tauri v2 rewrite, as the old version depended on webkitgtk 4.0"; # Added 2026-06-07
  xsynth-dssi = throw "'xsynth-dssi' was removed due to lack of upstream maintenance and relying on gtk2"; # Added 2025-12-02
  xtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
  xtreemfs = throw "'xtreemfs' has been removed as it was broken and unmaintained upstream"; # Added 2026-05-05
  xxHash = warnAlias "'xxHash' has been renamed to 'xxhash'" xxhash; # Added 2026-02-12
  xzgv = throw "'xzgv' has been removed, as it depended on GTK 2. Consider using 'geeqie' or 'gthumb' instead."; # Added 2026-05-22
  yacas-gui = throw "'yacas-gui' has been removed, as it depended on qt5 webengine. Upstream is considering deprecation of the gui entirely, see https://github.com/grzegorzmazur/yacas/issues/361."; # Added 2026-02-11
  yarGen = warnAlias "'yarGen' has been renamed to 'yargen'" yargen; # Added 2026-02-12
  yarn2nix = throw "'yarn2nix' and its tooling has been removed as it was unusable within nodePackages. Use the standard yarn v1 hooks available in nixpkgs instead."; # Added 2026-04-25
  yarn2nix-moretea = throw "'yarn2nix' and its tooling has been removed as it was unusable within nodePackages. Use the standard yarn v1 hooks available in nixpkgs instead."; # Added 2026-04-25
  yojimbo = throw "'yojimbo' has been removed as it used an EOL TLS library and was broken."; # Added 2026-05-06
  yosys-synlig = throw "yosys-synlig has been removed because it is unmaintained upstream and incompatible with current Yosys versions."; # Added 2026-01-06
  youtube-music = warnAlias "'youtube-music' has been renamed to/replaced by 'lib.warnOnInstantiate'" lib.warnOnInstantiate; # Converted to warning 2026-07-01
  zabbix72 = throw "'zabbix72' was removed as it has reached its end of life"; # Added 2026-02-11
  zap-chip-gui = throw "the gui variant of zap-chip was removed as it was not really functional"; # Added 2026-05-30
  zdoom = throw "'zdoom' has been removed as it was broken and unmaintained upstream. Consider using UZDoom instead."; # Added 2026-04-04
  zeal-qt5 = throw "'zeal-qt5' has been renamed to/replaced by 'zeal'"; # Converted to throw 2026-07-01
  zeal-qt6 = throw "'zeal-qt6' has been renamed to/replaced by 'zeal'"; # Converted to throw 2026-07-01
  zfs_2_2 = throw "'zfs_2_2' has been removed, upgrade to a newer version instead"; # Added 2025-11-08
  zigbee2mqtt_2 = warnAlias "'zigbee2mqtt_2' has been renamed to/replaced by 'zigbee2mqtt'" zigbee2mqtt; # Converted to warning 2026-07-01
  zmkBATx = warnAlias "'zmkBATx' has been renamed to 'zmkbatx'" zmkbatx; # Added 2026-02-18
  zotero-beta = throw "'zotero-beta' has been removed. Use 'zotero' instead."; # Added 2026-03-05
  zotero_7 = throw "'zotero_7' has been renamed to/replaced by 'zotero'"; # Added 2025-12-09
  zulu23 = throw "Zulu OpenJDK 23 was removed as it has reached its end of life"; # Added 2025-11-14
  zulu24 = throw "Zulu OpenJDK 24 was removed as it has reached its end of life"; # Added 2025-11-14
  # keep-sorted end
}
// plasma5Throws
