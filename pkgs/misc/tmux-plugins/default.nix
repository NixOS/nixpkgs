{
  lib,
  fetchFromGitHub,
  pkgs,
  stdenv,
  config,
}:

let
  rtpPath = "share/tmux-plugins";

  addRtp =
    path: rtpFilePath: attrs: derivation:
    derivation
    // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    }
    // {
      overrideAttrs = f: mkTmuxPlugin (attrs // (if lib.isFunction f then f attrs else f));
    };

  mkTmuxPlugin =
    a@{
      pluginName,
      rtpFilePath ? (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux",
      namePrefix ? "tmuxplugin-",
      src,
      unpackPhase ? "",
      configurePhase ? ":",
      buildPhase ? ":",
      addonInfo ? null,
      preInstall ? "",
      postInstall ? "",
      path ? lib.getName pluginName,
      ...
    }:
    if lib.hasAttr "dependencies" a then
      throw "dependencies attribute is obselete. see NixOS/nixpkgs#118034" # added 2021-04-01
    else
      addRtp "${rtpPath}/${path}" rtpFilePath a (
        stdenv.mkDerivation (
          a
          // {
            pname = namePrefix + pluginName;

            inherit
              pluginName
              unpackPhase
              configurePhase
              buildPhase
              addonInfo
              preInstall
              postInstall
              ;

            installPhase = ''
              runHook preInstall

              target=$out/${rtpPath}/${path}
              mkdir -p $out/${rtpPath}
              cp -r . $target
              if [ -n "$addonInfo" ]; then
                echo "$addonInfo" > $target/addon-info.json
              fi

              runHook postInstall
            '';
          }
        )
      );

in
{
  inherit mkTmuxPlugin;

  battery = mkTmuxPlugin {
    pluginName = "battery";
    version = "unstable-2019-07-04";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-battery";
      rev = "f8b8e8451990365e0c98c38c184962e4f83b793b";
      hash = "sha256-NfKaM4dPt7YaxG7kHMNxf95Mz0hIEhxqlVi2Obr+Da4=";
    };
  };

  better-mouse-mode = mkTmuxPlugin {
    pluginName = "better-mouse-mode";
    version = "unstable-2021-08-02";
    src = fetchFromGitHub {
      owner = "NHDaly";
      repo = "tmux-better-mouse-mode";
      rev = "aa59077c635ab21b251bd8cb4dc24c415e64a58e";
      hash = "sha256-nPNa3JvDgptGvy2vpo0WSZytyu7kFSEn/Jp/OGA0ZBg=";
    };
    rtpFilePath = "scroll_copy_mode.tmux";
    meta = {
      homepage = "https://github.com/NHDaly/tmux-better-mouse-mode";
      description = "Better mouse support for tmux";
      longDescription = ''
        Features:

          * Emulate mouse-support for full-screen programs like less that don't provide built in mouse support.
          * Exit copy-mode and return to your prompt by scrolling back all the way down to the bottom.
          * Adjust your scrolling speed.
      '';
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ chrispickard ];
    };
  };

  catppuccin = mkTmuxPlugin rec {
    pluginName = "catppuccin";
    version = "2.1.3";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v${version}";
      hash = "sha256-Is0CQ1ZJMXIwpDjrI5MDNHJtq+R3jlNcd9NXQESUe2w=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
    meta = with lib; {
      homepage = "https://github.com/catppuccin/tmux";
      description = "Soothing pastel theme for Tmux";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [ ];
    };
  };

  continuum = mkTmuxPlugin {
    pluginName = "continuum";
    version = "unstable-2022-01-25";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "fc2f31d79537a5b349f55b74c8ca69abaac1ddbb";
      hash = "sha256-S1YuZHX4SnSVlMZKv/a87/qj0seRdaWyOXz5ONCVIRo=";
    };
    meta = {
      homepage = "https://github.com/tmux-plugins/tmux-continuum";
      description = "Continuous saving of tmux environment";
      longDescription = ''
        Features:
        * continuous saving of tmux environment
        * automatic tmux start when computer/server is turned on
        * automatic restore when tmux is started

        Together, these features enable uninterrupted tmux usage. No matter the
        computer or server restarts, if the machine is on, tmux will be there how
        you left it off the last time it was used.
      '';
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ ronanmacf ];
    };
  };

  copy-toolkit = mkTmuxPlugin {
    pluginName = "copy-toolkit";
    rtpFilePath = "copytk.tmux";
    version = "2021-12-20";
    src = fetchFromGitHub {
      owner = "CrispyConductor";
      repo = "tmux-copy-toolkit";
      rev = "c80c2c068059fe04f840ea9f125c21b83cb6f81f";
      hash = "sha256-cLeOoJ+4MF8lSpwy5lkcPakvB3cpgey0RfLbVTwERNk=";
    };
    postInstall = ''
      sed -i -e 's|python3 |${pkgs.python3}/bin/python3 |g' $target/copytk.tmux
      sed -i -e 's|python3|${pkgs.python3}/bin/python3|g;s|/bin/bash|${pkgs.bash}/bin/bash|g;s|/bin/cat|${pkgs.coreutils}/bin/cat|g' $target/copytk.py
    '';
    meta = {
      homepage = "https://github.com/CrispyConductor/tmux-copy-toolkit";
      description = "Various copy-mode tools";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        deejayem
        sedlund
      ];
    };
  };

  copycat = mkTmuxPlugin {
    pluginName = "copycat";
    version = "unstable-2020-01-09";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-copycat";
      rev = "77ca3aab2aed8ede3e2b941079b1c92dd221cf5f";
      hash = "sha256-ugVk1zpKeUjOlDWi3LEkJPFsCqyZEivGzGWiqODnkK0=";
    };
  };

  cpu = mkTmuxPlugin {
    pluginName = "cpu";
    version = "unstable-2023-01-06";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "98d787191bc3e8f19c3de54b96ba1caf61385861";
      hash = "sha256-ymmCI6VYvf94Ot7h2GAboTRBXPIREP+EB33+px5aaJk=";
    };
  };

  ctrlw = mkTmuxPlugin rec {
    pluginName = "ctrlw";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "tmux-ctrlw";
      rev = "v${version}";
      hash = "sha256-YYbPkGQmukIDD1fcYleioETFai/SOJni+aZ9Jh2+Zc8=";
    };
  };

  dracula = mkTmuxPlugin rec {
    pluginName = "dracula";
    version = "3.1.0";
    src = fetchFromGitHub {
      owner = "dracula";
      repo = "tmux";
      tag = "v${version}";
      hash = "sha256-WNgCa8F618JQiHDM1YxHj7oR7w+7U6SU89K90RYIUh8=";
    };
    meta = {
      homepage = "https://draculatheme.com/tmux";
      downloadPage = "https://github.com/dracula/tmux";
      description = "Feature packed Dracula theme for tmux";
      changelog = "https://github.com/dracula/tmux/releases/tag/v${version}/CHANGELOG.md";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ ethancedwards8 ];
    };
  };

  dotbar = mkTmuxPlugin rec {
    pluginName = "dotbar";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "vaaleyard";
      repo = "tmux-dotbar";
      tag = version;
      hash = "sha256-n9k18pJnd5mnp9a7VsMBmEHDwo3j06K6/G6p7/DTyIY=";
    };
    meta = {
      homepage = "https://github.com/vaaleyard/tmux-dotbar";
      downloadPage = "https://github.com/vaaleyard/tmux-dotbar";
      description = "Simple and minimalist status bar for tmux";
      changelog = "https://github.com/vaaleyard/tmux-dotbar/releases/tag/${version}";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ FKouhai ];
    };
  };

  extrakto = mkTmuxPlugin {
    pluginName = "extrakto";
    version = "0-unstable-2025-07-27";
    src = fetchFromGitHub {
      owner = "laktak";
      repo = "extrakto";
      rev = "b04dcf14496ffda629d8aa3a2ac63e4e08d2fdc9";
      hash = "sha256-lknfek9Fu/RDHbq5HMaiNqc24deni5phzExWOkYRS+o";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [ pkgs.python3 ];
    postInstall = ''
      patchShebangs extrakto.py extrakto_plugin.py

       wrapProgram $target/scripts/open.sh \
         --prefix PATH : ${
           with pkgs;
           lib.makeBinPath (
             [ fzf ]
             ++ lib.optionals stdenv.hostPlatform.isLinux [
               xclip
               wl-clipboard
             ]
           )
         }
    '';
    meta = {
      homepage = "https://github.com/laktak/extrakto";
      description = "Fuzzy find your text with fzf instead of selecting it by hand ";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        kidd
        fnune
        deejayem
      ];
    };
  };

  fingers = pkgs.callPackage ./tmux-fingers {
    inherit mkTmuxPlugin;
  };

  fpp = mkTmuxPlugin {
    pluginName = "fpp";
    version = "unstable-2016-03-08";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-fpp";
      rev = "ca125d5a9c80bb156ac114ac3f3d5951a795c80e";
      hash = "sha256-mhf1PPlo7AaAx7haRDgS+LYW7eFCOB6LPtHF76rRCa0=";
    };
    postInstall = ''
      sed -i -e 's|fpp |${pkgs.fpp}/bin/fpp |g' $target/fpp.tmux
    '';
  };

  fuzzback = mkTmuxPlugin {
    pluginName = "fuzzback";
    version = "unstable-2022-11-21";
    src = fetchFromGitHub {
      owner = "roosta";
      repo = "tmux-fuzzback";
      rev = "bfd9cf0ef1c35488f0080f0c5ca4fddfdd7e18ec";
      hash = "sha256-w788xDBkfiLdUVv1oJi0YikFPqVk6LiN6PDfHu8on5E=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for f in fuzzback.sh preview.sh supported.sh; do
        chmod +x $target/scripts/$f
        wrapProgram $target/scripts/$f \
          --prefix PATH : ${
            with pkgs;
            lib.makeBinPath [
              coreutils
              fzf
              gawk
              gnused
            ]
          }
      done
    '';
    meta = {
      homepage = "https://github.com/roosta/tmux-fuzzback";
      description = "Fuzzy search for terminal scrollback";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ deejayem ];
    };
  };

  fzf-tmux-url = mkTmuxPlugin {
    pluginName = "fzf-tmux-url";
    rtpFilePath = "fzf-url.tmux";
    version = "unstable-2024-04-14";
    src = fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-fzf-url";
      rev = "28ed7ce3c73a328d8463d4f4aaa6ccb851e520fa";
      hash = "sha256-tl0SjG/CeolrN7OIHj6MgkB9lFmFgEuJevsSuwVs+78=";
    };
    meta = with lib; {
      homepage = "https://github.com/wfxr/tmux-fzf-url";
      description = "Quickly open urls on your terminal screen";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };

  gruvbox = mkTmuxPlugin rec {
    pluginName = "gruvbox";
    rtpFilePath = "gruvbox-tpm.tmux";
    version = "2.0.1";
    src = fetchFromGitHub {
      owner = "egel";
      repo = "tmux-gruvbox";
      tag = "v${version}";
      hash = "sha256-TuWPw6sk61k7GnHwN2zH6x6mGurTHiA9f0E6NJfMa6g=";
    };
  };

  harpoon = mkTmuxPlugin {
    pluginName = "harpoon";
    rtpFilePath = "harpoon.tmux";
    version = "0.4.0";
    src = fetchFromGitHub {
      owner = "chaitanyabsprip";
      repo = "tmux-harpoon";
      rev = "v0.4.0";
      hash = "sha256-+IakWkPoQFhIQ4m/98NVYWe5tFKmtfKBnPXZcfU9iOk=";
    };
    meta = {
      homepage = "https://github.com/Chaitanyabsprip/tmux-harpoon";
      downloadPage = "https://github.com/Chaitanyabsprip/tmux-harpoon";
      description = "Tool to bookmark session supporting auto create for sessions";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ FKouhai ];
    };
  };

  jump = mkTmuxPlugin {
    pluginName = "jump";
    version = "2020-06-26";
    rtpFilePath = "tmux-jump.tmux";
    src = fetchFromGitHub {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "416f613d3eaadbe1f6f9eda77c49430527ebaffb";
      hash = "sha256-XxdQtJPkTTCbaGUw4ebtzPQq+QuJOOSAjQKrp6Fvf/U=";
    };
    postInstall = ''
      sed -i -e 's|ruby|${pkgs.ruby}/bin/ruby|g' $target/scripts/tmux-jump.sh
    '';
    meta = with lib; {
      homepage = "https://github.com/schasse/tmux-jump";
      description = "Vimium/Easymotion like navigation for tmux";
      license = licenses.gpl3;
      platforms = platforms.unix;
      maintainers = with maintainers; [ arnarg ];
    };
  };

  kanagawa = mkTmuxPlugin {
    pluginName = "kanagawa";
    version = "0-unstable-2025-02-10";
    src = fetchFromGitHub {
      owner = "Nybkox";
      repo = "tmux-kanagawa";
      rev = "5440b9476627bf5f7f3526156a17ae0e3fd232dd";
      hash = "sha256-sFL9/PMdPJxN7tgpc4YbUHW4PkCXlKmY7a7gi7PLcn8=";
    };
    meta = {
      homepage = "https://github.com/Nybkox/tmux-kanagawa";
      downloadPage = "https://github.com/Nybkox/tmux-kanagawa";
      description = "Feature packed kanagawa theme for tmux";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ FKouhai ];
    };
  };

  logging = mkTmuxPlugin {
    pluginName = "logging";
    version = "unstable-2019-04-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-logging";
      rev = "b085ad423b5d59a2c8b8d71772352e7028b8e1d0";
      hash = "sha256-Wp4xY2nxv4jl/G7bjNokYk3TcbS9waLERBFSpT1XGlw=";
    };
  };

  minimal-tmux-status = mkTmuxPlugin {
    pluginName = "minimal-tmux-status";
    rtpFilePath = "minimal.tmux";
    version = "0-unstable-2025-06-04";
    src = fetchFromGitHub {
      owner = "niksingh710";
      repo = "minimal-tmux-status";
      rev = "de2bb049a743e0f05c08531a0461f7f81da0fc72";
      hash = "sha256-0gXtFVan+Urb79AjFOjHdjl3Q73m8M3wFSo3ZhjxcBA=";
    };
    meta = {
      description = "Minimal tmux status line plugin with prefix key indicator";
      longDescription = ''
        minimal-tmux-status is a lightweight plugin for tmux that provides a simple, customizable status line.
        In addition to basic session info, it shows whether the tmux prefix key is currently pressed, helping users
        quickly identify the prefix state. Designed to be minimal in appearance and dependencies, it is ideal for users
        who want essential information without clutter.
      '';
      homepage = "https://github.com/niksingh710/minimal-tmux-status.git";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        niksingh710
      ];
      platforms = lib.platforms.unix;
    };
  };

  mode-indicator = mkTmuxPlugin {
    pluginName = "mode-indicator";
    version = "unstable-2021-10-01";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "tmux-mode-indicator";
      rev = "11520829210a34dc9c7e5be9dead152eaf3a4423";
      hash = "sha256-hlhBKC6UzkpUrCanJehs2FxK5SoYBoiGiioXdx6trC4=";
    };
    meta = with lib; {
      homepage = "https://github.com/MunifTanjim/tmux-mode-indicator";
      description = "Plugin that displays prompt indicating currently active Tmux mode";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ aacebedo ];
    };
  };

  net-speed = mkTmuxPlugin {
    pluginName = "net-speed";
    version = "unstable-2018-12-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-net-speed";
      rev = "58abb615971cb617821e2e7e41c660334f55a92d";
      hash = "sha256-LFPcPDBiSvsOhOhlAScajr/Y/Uw2CPdl87qzD9szQKo=";
    };
  };

  nord = mkTmuxPlugin {
    pluginName = "nord";
    version = "0.3.0-unstable-2023-03-03";
    src = pkgs.fetchFromGitHub {
      owner = "nordtheme";
      repo = "tmux";
      rev = "f7b6da07ab55fe32ee5f7d62da56d8e5ac691a92";
      hash = "sha256-mcmVYNWOUoQLiu4eM/EUudRg67Gcou13xuC6zv9aMKA=";
    };
    meta = {
      homepage = "https://www.nordtheme.com/ports/tmux";
      description = "Nord Tmux theme with plugin support";
      longDescription = ''
        > An arctic, north-bluish clean and elegant tmux theme.
        > Designed for a fluent and clear workflow with support for third-party plugins.

        This plugin requires that tmux be used with a Nord terminal emulator
        theme in order to work properly.
      '';
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.sigmasquadron ];
    };
  };

  maildir-counter = mkTmuxPlugin {
    pluginName = "maildir-counter";
    version = "unstable-2016-11-25";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-maildir-counter";
      rev = "9415f0207e71e37cbd870c9443426dbea6da78b9";
      hash = "sha256-RFdnF/ScOPoeVgGXWhQs28tS7CmsRA0DyFyutCPEmzc=";
    };
  };

  online-status = mkTmuxPlugin {
    pluginName = "online-status";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-online-status";
      rev = "ea86704ced8a20f4a431116aa43f57edcf5a6312";
      hash = "sha256-OQW2WcNDVBMgX5IIlykn7f1wI8miXuqLQTlqsdHbw8M=";
    };
  };

  open = mkTmuxPlugin {
    pluginName = "open";
    version = "unstable-2019-12-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-open";
      rev = "cedb4584908bd8458fadc8d3e64101d3cbb48d46";
      hash = "sha256-sFl+wkvQ498irwKWXXAT6/XBrziYLT+CvLCBV2HrQIM=";
    };
  };

  onedark-theme = mkTmuxPlugin {
    pluginName = "onedark-theme";
    rtpFilePath = "tmux-onedark-theme.tmux";
    version = "unstable-2020-06-07";
    src = fetchFromGitHub {
      owner = "odedlaz";
      repo = "tmux-onedark-theme";
      rev = "3607ef889a47dd3b4b31f66cda7f36da6f81b85c";
      hash = "sha256-pQooiDEeB8NvBOQ1IKUgPSSQDK+hMTLMGuiKy6GWVKY=";
    };
  };

  pain-control = mkTmuxPlugin {
    pluginName = "pain-control";
    version = "unstable-2020-02-18";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-pain-control";
      rev = "2db63de3b08fc64831d833240749133cecb67d92";
      hash = "sha256-84NJtxoz4KTVv+i3cde235WcHhRSBIkZjtobZIk16nA=";
    };
  };

  pass = mkTmuxPlugin {
    pluginName = "pass";
    version = "0-unstable-2025-02-20";
    rtpFilePath = "plugin.tmux";
    src = fetchFromGitHub {
      owner = "rafi";
      repo = "tmux-pass";
      rev = "c853c8b5e31dea93d17551ef3e18be16c063e28e";
      hash = "sha256-fDAqQcr0SC9WrKbGgt7z03ex2ORZ7ChOzDGl6HFXMaA";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      rm $target/README.md
      rm -r $target/test

      wrapProgram $target/scripts/main.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            findutils
            fzf
            gnugrep
            gnused
            ncurses
            pkgs.pass
            tmux
          ]
        }
    '';

    meta = {
      description = "Password-store browser using fzf in tmux";
      homepage = "https://github.com/rafi/tmux-pass";
      license = lib.licenses.gpl3Only;
      maintainers = [ lib.maintainers.ethancedwards8 ];
    };
  };

  plumb = mkTmuxPlugin rec {
    pluginName = "plumb";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "tmux-plumb";
      rev = "v${version}";
      hash = "sha256-WcTyAeuGAF+Xsqeb3MtRtHDSXiUmTJNDQOkrQJsj07A=";
    };
    postInstall = ''
      sed -i -e 's,9 plumb,${pkgs.plan9port}/bin/9 plumb,' $target/scripts/plumb
    '';
  };

  power-theme = mkTmuxPlugin {
    pluginName = "power";
    rtpFilePath = "tmux-power.tmux";
    version = "unstable-2024-05-12";
    src = pkgs.fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-power";
      rev = "16bbde801378a70512059541d104c5ae35be32b9";
      hash = "sha256-IyYQyIONMnVBwhhcI3anOPxKpv2TfI2KZgJ5o5JtZ8I=";
    };
    meta = with lib; {
      description = "Tmux powerline theme";
      homepage = "https://github.com/wfxr/tmux-power";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };

  prefix-highlight = mkTmuxPlugin {
    pluginName = "prefix-highlight";
    version = "unstable-2021-03-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-prefix-highlight";
      rev = "15acc6172300bc2eb13c81718dc53da6ae69de4f";
      hash = "sha256-9LWRV0Hw8MmDwn5hWl3DrBuYUqBjLCO02K9bbx11MyM=";
    };
  };

  resurrect = mkTmuxPlugin {
    pluginName = "resurrect";
    version = "unstable-2022-05-01";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "ca6468e2deef11efadfe3a62832ae67742505432";
      hash = "sha256-wl9/5XvFq+AjV8CwYgIZjPOE0/kIuEYBNQqNDidjNFo=";
      fetchSubmodules = true;
    };
    meta = {
      homepage = "https://github.com/tmux-plugins/tmux-resurrect";
      description = "Restore tmux environment after system restart";
      longDescription = ''
        This plugin goes to great lengths to save and restore all the details
        from your tmux environment. Here's what's been taken care of:

        * all sessions, windows, panes and their order
        * current working directory for each pane
        * exact pane layouts within windows (even when zoomed)
        * active and alternative session
        * active and alternative window for each session
        * windows with focus
        * active pane for each window
        * "grouped sessions" (useful feature when using tmux with multiple monitors)
        * programs running within a pane! More details in the restoring programs doc.

        Optional:
        * restoring vim and neovim sessions
        * restoring pane contents
      '';
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ ronanmacf ];
    };
  };

  rose-pine = mkTmuxPlugin {
    pluginName = "rose-pine";
    version = "unstable-2024-01-08";
    rtpFilePath = "rose-pine.tmux";
    src = fetchFromGitHub {
      owner = "rose-pine";
      repo = "tmux";
      rev = "dd6d01338ac4afeb96542dcf24e4a7fe179b69e6";
      hash = "sha256-Tccb4VjdotOSw7flJV4N0H4557NxRhXiCecZBPU9ICQ=";
    };
    meta = {
      homepage = "https://github.com/rose-pine/tmux";
      description = "Rosé Pine theme for tmux";
      license = lib.licenses.mit;
    };
  };

  sensible = mkTmuxPlugin {
    pluginName = "sensible";
    version = "unstable-2022-08-14";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sensible";
      rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
      hash = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
    };
    postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -e 's:reattach-to-user-namespace:${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace:g' -i $target/sensible.tmux
    '';
  };

  session-wizard = mkTmuxPlugin rec {
    pluginName = "session-wizard";
    rtpFilePath = "session-wizard.tmux";
    version = "1.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "27medkamal";
      repo = "tmux-session-wizard";
      rev = "V${version}";
      hash = "sha256-mLpZQSo8nildawsPxGwkcETNwlRq6O1pfy/VusMNMaw=";
    };
    meta = with lib; {
      homepage = "https://github.com/27medkamal/tmux-session-wizard";
      description = "Tmux plugin for creating and switching between sessions based on recently accessed directories";
      longDescription = ''
        Session Wizard is using fzf and zoxide to do all the magic. Features:
        * Creating a new session from a list of recently accessed directories
        * Naming a session after a folder/project
        * Switching sessions
        * Viewing current or creating new sessions in one popup
      '';
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ mandos ];
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for f in .gitignore Dockerfile flake.* scripts tests; do
        rm -rf $target/$f
      done
      substituteInPlace $target/session-wizard.tmux --replace  \$CURRENT_DIR $target
      wrapProgram $target/bin/t \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            fzf
            zoxide
            coreutils
            gnugrep
            gnused
          ]
        }
    '';
  };

  sessionist = mkTmuxPlugin {
    pluginName = "sessionist";
    version = "unstable-2017-12-03";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sessionist";
      rev = "09ec86be38eae98ffc27bd0dde605ed10ae0dc89";
      hash = "sha256-hFNrdbhmBUAyJ73RCG4RILzJ3LHIYiuNYGsqJGsVGAw=";
    };
  };

  sidebar = mkTmuxPlugin {
    pluginName = "sidebar";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sidebar";
      rev = "aacbdb45bc5ab69db448a72de4155d0b8dbac677";
      hash = "sha256-7MCouewjpTCMGmWMaTWWQevlR0LrLTBjXGumsNcH6a4=";
    };
  };

  sysstat = mkTmuxPlugin {
    pluginName = "sysstat";
    version = "unstable-2017-12-12";
    src = fetchFromGitHub {
      owner = "samoshkin";
      repo = "tmux-plugin-sysstat";
      rev = "29e150f403151f2341f3abcb2b2487a5f011dd23";
      hash = "sha256-2EMSV6z9FZHq20dkPna0qELSVIOIAnOHpiCLbG7adQQ=";
    };
  };

  tilish = mkTmuxPlugin {
    pluginName = "tilish";
    version = "unstable-2023-09-20";
    src = fetchFromGitHub {
      owner = "jabirali";
      repo = "tmux-tilish";
      rev = "22f7920837d827dc6cb31143ea916afa677c24c1";
      hash = "sha256-wP3c+p/DM6ve7GUhi0QEzggct7NS4XUa78sVQFSKrfo=";
    };

    meta = with lib; {
      homepage = "https://github.com/jabirali/tmux-tilish";
      description = "Plugin which makes tmux work and feel like i3wm";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ arnarg ];
    };
  };

  tokyo-night-tmux = mkTmuxPlugin {
    pluginName = "tokyo-night-tmux";
    rtpFilePath = "tokyo-night.tmux";
    version = "1.6.6";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "caf6cbb4c3a32d716dfedc02bc63ec8cf238f632";
      hash = "sha256-TOS9+eOEMInAgosB3D9KhahudW2i1ZEH+IXEc0RCpU0=";
    };
    meta = with lib; {
      homepage = "https://github.com/janoamaral/tokyo-night-tmux";
      description = "Clean, dark Tmux theme that celebrates the lights of Downtown Tokyo at night";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ redyf ];
    };
  };

  tmux-colors-solarized = mkTmuxPlugin {
    pluginName = "tmuxcolors";
    version = "unstable-2019-07-14";
    src = fetchFromGitHub {
      owner = "seebi";
      repo = "tmux-colors-solarized";
      rev = "e5e7b4f1af37f8f3fc81ca17eadee5ae5d82cd09";
      hash = "sha256-nVA4fkmxf8he3lxG6P0sASvH6HlSt8dKGovEv5RAcdA=";
    };
  };

  tmux-floax = mkTmuxPlugin {
    pluginName = "tmux-floax";
    rtpFilePath = "floax.tmux";
    version = "0-unstable-2024-07-24";
    src = fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-floax";
      rev = "46c0a6a8c3cf79b83d1b338f547acbbd1d306301";
      hash = "sha256-bALZfVWcoAzcTeWwkBHhi7TzUQJicOBTNdeJh3O/Bj8=";
    };
    meta = {
      description = "Floating pane for Tmux";
      homepage = "https://github.com/omerxx/tmux-floax";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ redyf ];
      mainProgram = "tmux-floax";
      platforms = lib.platforms.all;
    };
  };

  tmux-fzf = mkTmuxPlugin {
    pluginName = "tmux-fzf";
    rtpFilePath = "main.tmux";
    version = "unstable-2023-10-24";
    src = fetchFromGitHub {
      owner = "sainnhe";
      repo = "tmux-fzf";
      rev = "d62b6865c0e7c956ad1f0396823a6f34cf7452a7";
      hash = "sha256-hVkSQYvBXrkXbKc98V9hwwvFp6z7/mX1K4N3N9j4NN4=";
    };
    postInstall = ''
      find $target -type f -print0 | xargs -0 sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g'
      find $target -type f -print0 | xargs -0 sed -i -e 's|sed |${pkgs.gnused}/bin/sed |g'
      find $target -type f -print0 | xargs -0 sed -i -e 's|tput |${pkgs.ncurses}/bin/tput |g'
    '';
    meta = {
      homepage = "https://github.com/sainnhe/tmux-fzf";
      description = "Use fzf to manage your tmux work environment! ";
      longDescription = ''
        Features:
        * Manage sessions (attach, detach*, rename, kill*).
        * Manage windows (switch, link, move, swap, rename, kill*).
        * Manage panes (switch, break, join*, swap, layout, kill*, resize).
        * Multiple selection (support for actions marked by *).
        * Search commands and append to command prompt.
        * Search key bindings and execute.
        * User menu.
        * Popup window support.
      '';
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ kyleondy ];
    };
  };

  tmux-powerline = mkTmuxPlugin {
    pluginName = "powerline";
    version = "3.0.0";
    src = fetchFromGitHub {
      owner = "erikw";
      repo = "tmux-powerline";
      rev = "2480e5531e0027e49a90eaf540f973e624443937";
      hash = "sha256-25uG7OI8OHkdZ3GrTxG1ETNeDtW1K+sHu2DfJtVHVbk=";
    };
    rtpFilePath = "main.tmux";
    meta = {
      homepage = "https://github.com/erikw/tmux-powerline";
      description = "Empowering your tmux (status bar) experience";
      longDescription = "A tmux plugin giving you a hackable status bar consisting of dynamic & beautiful looking powerline segments, written purely in bash.";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ thomasjm ];
    };
  };

  tmux-sessionx = mkTmuxPlugin {
    pluginName = "sessionx";
    version = "0-unstable-2024-09-22";
    src = fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-sessionx";
      rev = "508359b8a6e2e242a9270292160624406be3bbca";
      hash = "sha256-nbzn3qxMGRzxFnLBVrjqGl09++9YOK4QrLoYiHUS9jY=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postPatch = ''
      substituteInPlace sessionx.tmux \
        --replace-fail "\$CURRENT_DIR/scripts/sessionx.sh" "$out/share/tmux-plugins/sessionx/scripts/sessionx.sh"
      substituteInPlace scripts/sessionx.sh \
        --replace-fail "/tmux-sessionx/scripts/preview.sh" "$out/share/tmux-plugins/sessionx/scripts/preview.sh"
      substituteInPlace scripts/sessionx.sh \
        --replace-fail "/tmux-sessionx/scripts/reload_sessions.sh" "$out/share/tmux-plugins/sessionx/scripts/reload_sessions.sh"
    '';
    postInstall = ''
      chmod +x $target/scripts/sessionx.sh
      wrapProgram $target/scripts/sessionx.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            zoxide
            fzf
            gnugrep
            gnused
            coreutils
          ]
        }
      chmod +x $target/scripts/preview.sh
      wrapProgram $target/scripts/preview.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            coreutils
            gnugrep
            gnused
          ]
        }
      chmod +x $target/scripts/reload_sessions.sh
      wrapProgram $target/scripts/reload_sessions.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            coreutils
            gnugrep
            gnused
          ]
        }
    '';
    meta = {
      description = "Tmux session manager, with preview, fuzzy finding, and MORE";
      homepage = "https://github.com/omerxx/tmux-sessionx";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ okwilkins ];
      platforms = lib.platforms.all;
    };
  };

  tmux-thumbs = pkgs.callPackage ./tmux-thumbs {
    inherit mkTmuxPlugin;
  };

  t-smart-tmux-session-manager = mkTmuxPlugin rec {
    pluginName = "t-smart-tmux-session-manager";
    version = "2.8.0";
    rtpFilePath = "t-smart-tmux-session-manager.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "t-smart-tmux-session-manager";
      rev = "v${version}";
      hash = "sha256-EMDEEIWJ+XFOk0WsQPAwj9BFBVDNwFUCyd1ScceqKpc=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/share/tmux-plugins/t-smart-tmux-session-manager/bin/t \
          --prefix PATH : ${

            lib.makeBinPath [
              pkgs.fzf
              pkgs.zoxide
            ]
          }

      find $target -type f -print0 | xargs -0 sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g'
      find $target -type f -print0 | xargs -0 sed -i -e 's|zoxide |${pkgs.zoxide}/bin/zoxide |g'
    '';
  };

  urlview = mkTmuxPlugin {
    pluginName = "urlview";
    version = "unstable-2016-01-06";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-urlview";
      rev = "b84c876cffdd22990b4ab51247e795cbd7813d53";
      hash = "sha256-1oEJDgHPIM6AEVlGcavRqP2YjPdmkxHHMiFYdgqW5Mo=";
    };
    postInstall = ''
      sed -i -e '14,20{s|extract_url|${pkgs.extract_url}/bin/extract_url|g}' $target/urlview.tmux
    '';
  };

  vim-tmux-focus-events = mkTmuxPlugin {
    pluginName = "vim-tmux-focus-events";
    version = "unstable-2020-10-05";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "vim-tmux-focus-events";
      rev = "a568192ca0de4ca0bd7b3cd0249aad491625c941";
      hash = "sha256-ITZMu2q80deOf0zqgYJDDgWQHWhJEzZlK6lVFPY4FIw=";
    };

    meta = with lib; {
      homepage = "https://github.com/tmux-plugins/vim-tmux-focus-events";
      description = "Makes FocusGained and FocusLost autocommand events work in vim when using tmux";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ ronanmacf ];
    };
  };

  vim-tmux-navigator = mkTmuxPlugin {
    pluginName = "vim-tmux-navigator";
    rtpFilePath = "vim-tmux-navigator.tmux";
    version = "unstable-2025-07-15";
    src = fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "c45243dc1f32ac6bcf6068e5300f3b2b237e576a";
      hash = "sha256-IEPnr/GdsAnHzdTjFnXCuMyoNLm3/Jz4cBAM0AJBrj8=";
    };
  };

  weather = mkTmuxPlugin {
    pluginName = "weather";
    rtpFilePath = "tmux-weather.tmux";
    version = "unstable-2020-02-08";
    src = fetchFromGitHub {
      owner = "xamut";
      repo = "tmux-weather";
      rev = "28a5fbe75bb25a408193d454304e28ddd75e9338";
      hash = "sha256-of9E/npEsF1JVc9ttwrbC5WkIAwCNBJAgTfExfj79i4=";
    };

    meta = with lib; {
      homepage = "https://github.com/xamut/tmux-weather";
      description = "Shows weather in the status line";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ jfvillablanca ];
    };
  };

  tmux-which-key = pkgs.callPackage ./tmux-which-key {
    inherit mkTmuxPlugin;
  };

  yank = mkTmuxPlugin {
    pluginName = "yank";
    version = "unstable-2023-07-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-yank";
      rev = "acfd36e4fcba99f8310a7dfb432111c242fe7392";
      hash = "sha256-/5HPaoOx2U2d8lZZJo5dKmemu6hKgHJYq23hxkddXpA=";
    };
  };

  tmux-nova = mkTmuxPlugin rec {
    pluginName = "tmux-nova";
    rtpFilePath = "nova.tmux";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "o0th";
      repo = "tmux-nova";
      rev = "v${version}";
      hash = "sha256-0LIql8as2+OendEHVqR0F3pmQTxC1oqapwhxT+34lJo=";
    };
    meta = with lib; {
      homepage = "https://github.com/o0th/tmux-nova";
      description = "Tmux-nova theme";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ o0th ];
    };
  };

  tmux-toggle-popup = mkTmuxPlugin rec {
    pluginName = "tmux-toggle-popup";
    rtpFilePath = "toggle-popup.tmux";
    version = "0.4.4";
    src = fetchFromGitHub {
      owner = "loichyan";
      repo = "tmux-toggle-popup";
      tag = "v${version}";
      hash = "sha256-tiiM5ETSrceyAyqhYRXjG1qCbjzZ0NJL5GWWbWX7Cbo=";
    };
    meta = with lib; {
      homepage = "https://github.com/loichyan/tmux-toggle-popup";
      description = "Handy plugin to create toggleable popups";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ szaffarano ];
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  mkDerivation = throw "tmuxPlugins.mkDerivation is deprecated, use tmuxPlugins.mkTmuxPlugin instead"; # added 2021-03-14
}
