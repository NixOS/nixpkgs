{ lib
, fetchFromGitHub
, pkgs
, stdenv
}:

let
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // { rtp = "${derivation}/${path}/${rtpFilePath}"; } // {
      overrideAttrs = f: mkTmuxPlugin (attrs // f attrs);
    };

  mkTmuxPlugin = a@{
    pluginName,
    rtpFilePath ? (builtins.replaceStrings ["-"] ["_"] pluginName) + ".tmux",
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
    else addRtp "${rtpPath}/${path}" rtpFilePath a (stdenv.mkDerivation (a // {
      pname = namePrefix + pluginName;

      inherit pluginName unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

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
    }));

in rec {
  inherit mkTmuxPlugin;

  battery = mkTmuxPlugin {
    pluginName = "battery";
    version = "unstable-2023-12-01";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-battery";
      rev = "48fae59ba4503cf345d25e4e66d79685aa3ceb75";
      hash = "sha256-yKMTuRiNnGC3tAbZeWzMEudzhBSJhji8sZh96rFxpb8=";
    };
  };

  better-mouse-mode = mkTmuxPlugin {
    pluginName = "better-mouse-mode";
    version = "unstable-2017-10-16";
    src = fetchFromGitHub {
      owner = "NHDaly";
      repo = "tmux-better-mouse-mode";
      rev = "aa59077c635ab21b251bd8cb4dc24c415e64a58e";
      hash = "sha256-nPNa3JvDgptGvy2vpo0WSZytyu7kFSEn/Jp/OGA0ZBg=";
    };
    rtpFilePath = "scroll_copy_mode.tmux";
    meta = {
      homepage = "https://github.com/NHDaly/tmux-better-mouse-mode";
      description = "better mouse support for tmux";
      longDescription =
      ''
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

  catppuccin = mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2024-05-15";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "697087f593dae0163e01becf483b192894e69e33";
      hash = "sha256-EHinWa6Zbpumu+ciwcMo6JIIvYFfWWEKH1lwfyZUNTo=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
    meta = with lib; {
      homepage = "https://github.com/catppuccin/tmux";
      description = "Soothing pastel theme for Tmux!";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ jnsgruk ];
    };
  };

  continuum = mkTmuxPlugin {
    pluginName = "continuum";
    version = "unstable-2024-01-20";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "0698e8f4b17d6454c71bf5212895ec055c578da0";
      hash = "sha256-W71QyLwC/MXz3bcLR2aJeWcoXFI/A3itjpcWKAdVFJY=";
    };
    meta = {
      homepage = "https://github.com/tmux-plugins/tmux-continuum";
      description = "continuous saving of tmux environment";
      longDescription =
      ''
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

  copy-toolkit = mkTmuxPlugin rec {
    pluginName = "copy-toolkit";
    rtpFilePath = "copytk.tmux";
    version = "1.1";
    src = fetchFromGitHub {
      owner = "CrispyConductor";
      repo = "tmux-copy-toolkit";
      rev = "v${version}";
      sha256 = "MEMC9klm+PH66UHwrB2SqdCaZX0LAujL+Woo/hV84m4=";
    };
    postInstall = ''
      sed -i -e 's|python3 |${pkgs.python3}/bin/python3 |g' $target/copytk.tmux
      sed -i -e 's|/bin/bash|${pkgs.bash}/bin/bash|g;s|/bin/cat|${pkgs.coreutils}/bin/cat|g' $target/copytk.py
    '';
    meta = {
      homepage = "https://github.com/CrispyConductor/tmux-copy-toolkit";
      description = "Various copy-mode tools";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ deejayem ];
    };
  };

  copycat = mkTmuxPlugin {
    pluginName = "copycat";
    version = "unstable-2020-07-24";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-copycat";
      rev = "d7f7e6c1de0bc0d6915f4beea5be6a8a42045c09";
      hash = "sha256-2dMu/kbKLI/+kO05+qmeuJtAvvO7k9SSF+o2MHNllFk=";
    };
  };

  cpu = mkTmuxPlugin {
    pluginName = "cpu";
    version = "unstable-2023-01-06";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "98d787191bc3e8f19c3de54b96ba1caf61385861";
      sha256 = "sha256-ymmCI6VYvf94Ot7h2GAboTRBXPIREP+EB33+px5aaJk=";
    };
  };

  ctrlw = mkTmuxPlugin rec {
    pluginName = "ctrlw";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "tmux-ctrlw";
      rev = "v${version}";
      sha256 = "1kv5pqfjczd6z7i9jf6j5xmcai50l9bn5p2p1w1l5fi6cj8cz1k1";
    };
  };

  dracula = mkTmuxPlugin rec {
    pluginName = "dracula";
    version = "2.3.0";
    src = fetchFromGitHub {
      owner = "dracula";
      repo = "tmux";
      rev = "v${version}";
      hash = "sha256-IrNDBRopg9lgN5AfeXbhhh+uXiWQD2bjS1sNOgOJsu4=";
    };
    meta = with lib; {
      homepage = "https://draculatheme.com/tmux";
      description = "A feature packed Dracula theme for tmux!";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ ethancedwards8 ];
    };
  };

  extrakto = mkTmuxPlugin {
    pluginName = "extrakto";
    version = "unstable-2024-05-09";
    src = fetchFromGitHub {
      owner = "laktak";
      repo = "extrakto";
      rev = "a3d76b8b94571e13958e433608ffc278ae839d2e";
      hash = "sha256-/26brPVo8z+0Sq5K/onYndAARn2WBAtQVl3PgTyNaz8=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
    for f in scripts/extrakto.sh scripts/helpers.sh scripts/open.sh extrakto.tmux; do
      chmod +x $target/$f
      wrapProgram $target/$f \
        --prefix PATH : ${with pkgs; lib.makeBinPath (
        [ fzf python3 xclip ]
        )}
    done

    '';
    meta = {
      homepage = "https://github.com/laktak/extrakto";
      description = "Fuzzy find your text with fzf instead of selecting it by hand ";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ kidd ];
    };
  };

  fingers = mkTmuxPlugin rec {
    pluginName = "fingers";
    rtpFilePath = "tmux-fingers.tmux";
    version = "2.1.5";
    src = fetchFromGitHub {
      owner = "Morantron";
      repo = "tmux-fingers";
      rev = version;
      hash = "sha256-gR3u5IVgFxd6uj7l8Ou8GnEvh8AkjRFgIWKCviISweQ=";
      fetchSubmodules = true;
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      chmod +x $target/tmux-fingers.tmux
      wrapProgram $target/tmux-fingers.tmux \
        --prefix PATH : ${with pkgs; lib.makeBinPath (
          [ gawk ] ++ lib.optionals stdenv.isDarwin [ reattach-to-user-namespace ]
        )}
    '';
  };

  fpp = mkTmuxPlugin {
    pluginName = "fpp";
    version = "unstable-2024-01-29";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-fpp";
      rev = "878302f228ee14f0fa59717f63743d396b327a21";
      hash = "sha256-ULBwyqXFjA9YACv2oVbni54O8kXpVIERtxIrC6njrUA=";
    };
    postInstall = ''
      sed -i -e 's|fpp |${pkgs.fpp}/bin/fpp |g' $target/fpp.tmux
    '';
  };

  fuzzback = mkTmuxPlugin {
    pluginName = "fuzzback";
    version = "unstable-2024-01-20";
    src = fetchFromGitHub {
      owner = "roosta";
      repo = "tmux-fuzzback";
      rev = "48fa13a2422bab9832543df1c6b4e9c6393e647c";
      hash = "sha256-T3rHudl9o4AP13Q4poccfXiDg41LRWThFW0r5IZxGjw=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for f in fuzzback.sh preview.sh supported.sh; do
        chmod +x $target/scripts/$f
        wrapProgram $target/scripts/$f \
          --prefix PATH : ${with pkgs; lib.makeBinPath [ coreutils fzf gawk gnused ]}
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
  };

  gruvbox = mkTmuxPlugin {
    pluginName = "gruvbox";
    rtpFilePath = "gruvbox-tpm.tmux";
    version = "unstable-2022-04-19";
    src = fetchFromGitHub {
      owner = "egel";
      repo = "tmux-gruvbox";
      rev = "3f9e38d7243179730b419b5bfafb4e22b0a969ad";
      sha256 = "1l0kq77rk3cbv0rvh7bmfn90vvqqmywn9jk6gbl9mg3qbynq5wcf";
    };
  };

  jump = mkTmuxPlugin {
    pluginName = "jump";
    version = "unstable-2023-05-09";
    rtpFilePath = "tmux-jump.tmux";
    src = fetchFromGitHub {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "2ff4940f043cd4ad80fa25c6efa33063fb3b386b";
      hash = "sha256-zgFQKQgESThZGoLRjqZGjxeu/C0HMduUOr7jcgELM7s=";
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

  logging = mkTmuxPlugin {
    pluginName = "logging";
    version = "2.1.0-unstable-2021-06-10";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-logging";
      rev = "b5c5f7b9bc679ca161a442e932d6186da8d3538f";
      hash = "sha256-NTDUXxy0Y0dp7qmcH5qqqENGvhzd3lLrIii5u0lYHJk=";
    };
  };

  mode-indicator = mkTmuxPlugin {
    pluginName = "mode-indicator";
    version = "unstable-2023-03-24";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "tmux-mode-indicator";
      rev = "7027903adca37c54cb8f5fa99fc113b11c23c2c4";
      hash = "sha256-SAzsn4LoG8Ju5t13/U3/ctlJQPyPgv2FjpPkWSeKbP0=";
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
      sha256 = "1aj06gdhzcxsydjzf21n9kyxigwf38kh2rg8hh7gnjk260ydqlrc";
    };
  };

  nord = mkTmuxPlugin rec {
    pluginName = "nord";
    version = "0.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "arcticicestudio";
      repo = "nord-tmux";
      rev = "v${version}";
      sha256 = "14xhh49izvjw4ycwq5gx4if7a0bcnvgsf3irywc3qps6jjcf5ymk";
    };
  };

  maildir-counter = mkTmuxPlugin {
    pluginName = "maildir-counter";
    version = "unstable-2021-03-15";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-maildir-counter";
      rev = "68136a8020815f99eeba88bc0aae807a465e0e29";
      hash = "sha256-1kpw2onfmkgl7VWYoDY0vDC0ELrnqg+LN/XzdvPQCac=";
    };
  };

  online-status = mkTmuxPlugin {
    pluginName = "online-status";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-online-status";
      rev = "82f4fbcaee7ece775f37cf7ed201f9d4beab76b8";
      hash = "sha256-vsR/OfcXK2YL4VmdVku3XxGbR5exgnbmlPVIQ2LnWBg=";
    };
  };

  open = mkTmuxPlugin {
    pluginName = "open";
    version = "3.0.0-unstable-2022-08-22";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-open";
      rev = "763d0a852e6703ce0f5090a508330012a7e6788e";
      hash = "sha256-Thii7D21MKodtjn/MzMjOGbJX8BwnS+fQqAtYv8CjPc=";
    };
  };

  onedark-theme = mkTmuxPlugin {
    pluginName = "onedark-theme";
    rtpFilePath = "tmux-onedark-theme.tmux";
    version = "unstable-2020-02-25";
    src = fetchFromGitHub {
      owner = "odedlaz";
      repo = "tmux-onedark-theme";
      rev = "3607ef889a47dd3b4b31f66cda7f36da6f81b85c";
      hash = "sha256-pQooiDEeB8NvBOQ1IKUgPSSQDK+hMTLMGuiKy6GWVKY=";
    };
  };

  pain-control = mkTmuxPlugin {
    pluginName = "pain-control";
    version = "unstable-2021-08-09";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-pain-control";
      rev = "32b760f6652f2305dfef0acd444afc311cf5c077";
      hash = "sha256-2VI9w7Naj9OHF3iuV63Ij4QcYhbrtngyJ3GpeyzIKxs=";
    };
  };

  plumb = mkTmuxPlugin rec {
    pluginName = "plumb";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "tmux-plumb";
      rev = "v${version}";
      sha256 = "1c6k4fdl0az9811r6k164mgd4w5la75xr6x7nabmy046xc0z5i2r";
    };
    postInstall = ''
      sed -i -e 's,9 plumb,${pkgs.plan9port}/bin/9 plumb,' $target/scripts/plumb
    '';
  };

  power-theme = mkTmuxPlugin {
    pluginName = "power";
    rtpFilePath = "tmux-power.tmux";
    version = "unstable-2024-04-14";
    src = pkgs.fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-power";
      rev = "16bbde801378a70512059541d104c5ae35be32b9";
      hash = "sha256-IyYQyIONMnVBwhhcI3anOPxKpv2TfI2KZgJ5o5JtZ8I=";
    };
  };

  prefix-highlight = mkTmuxPlugin {
    pluginName = "prefix-highlight";
    version = "unstable-2024-01-14";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-prefix-highlight";
      rev = "489a96189778a21d2f5f4dbbbc0ad2cec8f6c854";
      hash = "sha256-GXqlwl1TPgXX1Je/ORjGFwfCyz17ZgdsoyOK1P3XF18=";
    };
  };

  resurrect = mkTmuxPlugin {
    pluginName = "resurrect";
    version = "unstable-2023-03-06";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "cff343cf9e81983d3da0c8562b01616f12e8d548";
      hash = "sha256-FcSjYyWjXM1B+WmiK2bqUNJYtH7sJBUsY2IjSur5TjY=";
    };
    meta = {
      homepage = "https://github.com/tmux-plugins/tmux-resurrect";
      description = "Restore tmux environment after system restart";
      longDescription =
        ''
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

  sensible = mkTmuxPlugin {
    pluginName = "sensible";
    version = "unstable-2022-08-14";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sensible";
      rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
      hash = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
    };
    postInstall = lib.optionalString stdenv.isDarwin ''
      sed -e 's:reattach-to-user-namespace:${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace:g' -i $target/sensible.tmux
    '';
  };

  sessionist = mkTmuxPlugin {
    pluginName = "sessionist";
    version = "2.3.0-unstable-2023-05-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sessionist";
      rev = "a315c423328d9bdf5cf796435ce7075fa5e1bffb";
      hash = "sha256-iC8NvuLujTXw4yZBaenHJ+2uM+HA9aW5b2rQTA8e69s=";
    };
  };

  sidebar = mkTmuxPlugin {
    pluginName = "sidebar";
    version = "0.7.0-unstable-2022-12-08";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sidebar";
      rev = "a41d72c019093fd6a1216b044e111dd300684f1a";
      hash = "sha256-5+ISvoXXYDDfzSoPBO6v6Wt7IWsRVb9DcPgnO02rYd4=";
    };
  };

  sysstat = mkTmuxPlugin {
    pluginName = "sysstat";
    version = "unstable-2017-12-12";
    src = fetchFromGitHub {
      owner = "samoshkin";
      repo = "tmux-plugin-sysstat";
      rev = "29e150f403151f2341f3abcb2b2487a5f011dd23";
      sha256 = "013mv9p6r2r0ls3p60l8hdad4hm8niv3wr27vgm925gxmibi4hyq";
    };
  };

  tilish = mkTmuxPlugin {
    pluginName = "tilish";
    version = "unstable-2023-09-20";
    src = fetchFromGitHub {
      owner = "jabirali";
      repo = "tmux-tilish";
      rev = "22f7920837d827dc6cb31143ea916afa677c24c1";
      sha256 = "wP3c+p/DM6ve7GUhi0QEzggct7NS4XUa78sVQFSKrfo=";
    };

    meta = with lib; {
      homepage = "https://github.com/jabirali/tmux-tilish";
      description = "Plugin which makes tmux work and feel like i3wm";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ arnarg ];
    };
  };

  tmux-colors-solarized = mkTmuxPlugin {
    pluginName = "tmuxcolors";
    version = "unstable-2022-06-10";
    src = fetchFromGitHub {
      owner = "seebi";
      repo = "tmux-colors-solarized";
      rev = "4d07f3cc1ce2bdc0c8391290c5b0cf098abddddc";
      hash = "sha256-M1z6tEIs5bI5sNMbuiv1boDD4WOLgCA21reGVJgkj4I=";
    };
  };

  tmux-fzf = mkTmuxPlugin {
    pluginName = "tmux-fzf";
    rtpFilePath = "main.tmux";
    version = "unstable-2024-04-15";
    src = fetchFromGitHub {
      owner = "sainnhe";
      repo = "tmux-fzf";
      rev = "231c835681ff47a17a99fb4f73307e67a25f52c0";
      hash = "sha256-8coYAmthLH5UI2JGKBUpKpYY1FQF5Ztl9c5spLtxGnI=";
    };
    postInstall = ''
      find $target -type f -print0 | xargs -0 sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g'
      find $target -type f -print0 | xargs -0 sed -i -e 's|sed |${pkgs.gnused}/bin/sed |g'
      find $target -type f -print0 | xargs -0 sed -i -e 's|tput |${pkgs.ncurses}/bin/tput |g'
    '';
    meta = {
      homepage = "https://github.com/sainnhe/tmux-fzf";
      description = "Use fzf to manage your tmux work environment! ";
      longDescription =
        ''
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

  tmux-thumbs = pkgs.callPackage ./tmux-thumbs {
    inherit mkTmuxPlugin;
  };

  vim-tmux-focus-events = mkTmuxPlugin {
    pluginName = "vim-tmux-focus-events";
    version = "1.0.0-unstable-2021-04-27";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "vim-tmux-focus-events";
      rev = "b1330e04ffb95ede8e02b2f7df1f238190c67056";
      hash = "sha256-R40ggkvFFcHk9lhVm9nw8b174VfUrlDiy+BUgql+KKc=";
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
    version = "1.0-unstable-2024-04-13";
    src = fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "a26954a585b02a2ac02f87145e204f8798a7cbc2";
      hash = "sha256-6StvzZghkv1pv0Mdy3fvYHXfCxeTMNDG4ERwYTXr2AY=";
    };
  };

  weather = mkTmuxPlugin {
    pluginName = "weather";
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

  yank = mkTmuxPlugin {
    pluginName = "yank";
    version = "2.3.0-unstable-2023-07-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-yank";
      rev = "acfd36e4fcba99f8310a7dfb432111c242fe7392";
      hash = "sha256-/5HPaoOx2U2d8lZZJo5dKmemu6hKgHJYq23hxkddXpA=";
    };
  };
}
