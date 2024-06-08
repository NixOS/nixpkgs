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

  mkDerivation = throw "tmuxPlugins.mkDerivation is deprecated, use tmuxPlugins.mkTmuxPlugin instead"; # added 2021-03-14

  battery = mkTmuxPlugin {
    pluginName = "battery";
    version = "unstable-2019-07-04";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-battery";
      rev = "f8b8e8451990365e0c98c38c184962e4f83b793b";
      sha256 = "1bhdzsx3kdjqjmm1q4j8937lrpkzf71irr3fqhdbddsghwrrmwim";
    };
  };

  better-mouse-mode = mkTmuxPlugin {
    pluginName = "better-mouse-mode";
    version = "unstable-2021-08-02";
    src = fetchFromGitHub {
      owner = "NHDaly";
      repo = "tmux-better-mouse-mode";
      rev = "aa59077c635ab21b251bd8cb4dc24c415e64a58e";
      sha256 = "06346ih3hzwszhkj25g4xv5av7292s6sdbrdpx39p0n3kgf5mwww";
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
    version = "unstable-2022-01-25";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "fc2f31d79537a5b349f55b74c8ca69abaac1ddbb";
      sha256 = "06i1jp83iybw76raaxciqz9a7ypgpkvbyjn6jjap8jpqfmj2wmjb";
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
    version = "unstable-2020-01-09";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-copycat";
      rev = "77ca3aab2aed8ede3e2b941079b1c92dd221cf5f";
      sha256 = "1bchwzhai8k5rk32n4lrmh56rw944jqxr8imjk74hyaa7bbn81ds";
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
      sha256 = "IrNDBRopg9lgN5AfeXbhhh+uXiWQD2bjS1sNOgOJsu4=";
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
    version = "unstable-2021-04-04";
    src = fetchFromGitHub {
      owner = "laktak";
      repo = "extrakto";
      rev = "de8ac3e8a9fa887382649784ed8cae81f5757f77";
      sha256 = "0mkp9r6mipdm7408w7ls1vfn6i3hj19nmir2bvfcp12b69zlzc47";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
    for f in extrakto.sh open.sh tmux-extrakto.sh; do
      wrapProgram $target/scripts/$f \
        --prefix PATH : ${with pkgs; lib.makeBinPath (
        [ pkgs.fzf pkgs.python3 pkgs.xclip ]
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
    pluginName = "tmux-fingers";
    rtpFilePath = "load-config.tmux";
    version = "2.1.1";
    src = fetchFromGitHub {
      owner = "Morantron";
      repo = "tmux-fingers";
      rev = "${version}";
      sha256 = "sha256-1YMh6m8M6FKf8RPXsOfWCVC5CXSr/MynguwkG7O+oEY=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper pkgs.crystal pkgs.shards ];
    postInstall = ''
      shards build --production
      rm -rf $target/* $target/.*
      cp -r bin $target/bin
      echo "$target/bin/${pluginName} load-config" > $target/${rtpFilePath}
      chmod +x $target/${rtpFilePath}

      wrapProgram $target/${rtpFilePath} \
        --prefix PATH : ${with pkgs; lib.makeBinPath (
          [ gawk ] ++ lib.optionals stdenv.isDarwin [ reattach-to-user-namespace ]
        )}
    '';
  };

  fpp = mkTmuxPlugin {
    pluginName = "fpp";
    version = "unstable-2016-03-08";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-fpp";
      rev = "ca125d5a9c80bb156ac114ac3f3d5951a795c80e";
      sha256 = "1b89s6mfzifi7s5iwf22w7niddpq28w48nmqqy00dv38z4yga5ws";
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
      sha256 = "w788xDBkfiLdUVv1oJi0YikFPqVk6LiN6PDfHu8on5E=";
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
    meta = with lib; {
      homepage = "https://github.com/wfxr/tmux-fzf-url";
      description = "Quickly open urls on your terminal screen!";
      license = licenses.mit;
      platforms = platforms.unix;
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
    version = "2020-06-26";
    rtpFilePath = "tmux-jump.tmux";
    src = fetchFromGitHub {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "416f613d3eaadbe1f6f9eda77c49430527ebaffb";
      sha256 = "1xbzdyhsgaq2in0f8f491gwjmx6cxpkf2c35d2dk0kg4jfs505sz";
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
    version = "unstable-2019-04-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-logging";
      rev = "b085ad423b5d59a2c8b8d71772352e7028b8e1d0";
      sha256 = "0p0sawysalhi8k2a5hdxniqx6kb24kd8rnvfzkjqigzid5ik37js";
    };
  };

  mode-indicator = mkTmuxPlugin rec {
    pluginName = "mode-indicator";
    version = "unstable-2021-10-01";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "tmux-mode-indicator";
      rev = "11520829210a34dc9c7e5be9dead152eaf3a4423";
      sha256 = "sha256-hlhBKC6UzkpUrCanJehs2FxK5SoYBoiGiioXdx6trC4=";
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
      owner = "nordtheme";
      repo = "tmux";
      rev = "v${version}";
      hash = "sha256-s/rimJRGXzwY9zkOp9+2bAF1XCT9FcyZJ1zuHxOBsJM=";
    };
    meta = {
      homepage = "https://www.nordtheme.com/ports/tmux";
      description = "Nord Tmux theme with plugin support";
      longDescription =
        ''
          > An arctic, north-bluish clean and elegant tmux theme.
          > Designed for a fluent and clear workflow with support for third-party plugins.

          This plugin requires that tmux be used with a Nord terminal emulator
          theme in order to work properly.
      '';
      license = lib.licenses.mit;
    };
  };

  maildir-counter = mkTmuxPlugin {
    pluginName = "maildir-counter";
    version = "unstable-2016-11-25";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-maildir-counter";
      rev = "9415f0207e71e37cbd870c9443426dbea6da78b9";
      sha256 = "0dwvqhiv9bjwr01hsi5c57n55jyv5ha5m5q1aqgglf4wyhbnfms4";
    };
  };

  online-status = mkTmuxPlugin {
    pluginName = "online-status";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-online-status";
      rev = "ea86704ced8a20f4a431116aa43f57edcf5a6312";
      sha256 = "1hy3vg8v2sir865ylpm2r4ip1zgd4wlrf24jbwh16m23qdcvc19r";
    };
  };

  open = mkTmuxPlugin {
    pluginName = "open";
    version = "unstable-2019-12-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-open";
      rev = "cedb4584908bd8458fadc8d3e64101d3cbb48d46";
      sha256 = "10s0xdhmg0dhpj13ybcq72pw3xgb2dq5v5h2mwidzqyh9g17wndh";
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
      sha256 = "19jljshwp2p83b634cd1mw69091x42jj0dg40ipw61qy6642h2m5";
    };
  };

  pain-control = mkTmuxPlugin {
    pluginName = "pain-control";
    version = "unstable-2020-02-18";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-pain-control";
      rev = "2db63de3b08fc64831d833240749133cecb67d92";
      sha256 = "0w7a6n4n86ysiqcqj12j2hg9r5fznvbp3dz8pzas9q1k3avlk0zk";
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
    version = "unstable-2020-11-18";
    src = pkgs.fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-power";
      rev = "aec44aa5e00cc39eb71c668b1d73823270058e7d";
      sha256 = "11nm8cylx10d565g17acy0bj12n6dcbxp71zca2bmg0j1dq859cm";
    };
  };

  prefix-highlight = mkTmuxPlugin {
    pluginName = "prefix-highlight";
    version = "unstable-2021-03-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-prefix-highlight";
      rev = "15acc6172300bc2eb13c81718dc53da6ae69de4f";
      sha256 = "08rkflfnynxgv2s26b33l199h6xcqdfmlqbyqa1wkw7h85br3dgl";
    };
  };

  resurrect = mkTmuxPlugin {
    pluginName = "resurrect";
    version = "unstable-2022-05-01";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "ca6468e2deef11efadfe3a62832ae67742505432";
      sha256 = "0d7jg5dy4jq64679rf2zqmqbvgiqvpcj5jxfljk7d7y86dnqhj3n";
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

  rose-pine = mkTmuxPlugin {
    pluginName = "rose-pine";
    version = "unstable-2024-01-08";
    rtpFilePath = "rose-pine.tmux";
    src = fetchFromGitHub {
      owner = "rose-pine";
      repo = "tmux";
      rev = "dd6d01338ac4afeb96542dcf24e4a7fe179b69e6";
      sha256 = "sha256-Tccb4VjdotOSw7flJV4N0H4557NxRhXiCecZBPU9ICQ=";
    };
    meta = {
      homepage = "https://github.com/rose-pine/tmux";
      description = "Rosé Pine theme for tmux";
      license = lib.licenses.mit;
    };
  };

  sensible = mkTmuxPlugin {
    pluginName = "sensible";
    version = "unstable-2017-09-05";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sensible";
      rev = "e91b178ff832b7bcbbf4d99d9f467f63fd1b76b5";
      sha256 = "1z8dfbwblrbmb8sgb0k8h1q0dvfdz7gw57las8nwd5gj6ss1jyvx";
    };
    postInstall = lib.optionalString stdenv.isDarwin ''
      sed -e 's:reattach-to-user-namespace:${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace:g' -i $target/sensible.tmux
    '';
  };

  session-wizard = mkTmuxPlugin rec {
    pluginName = "session-wizard";
    rtpFilePath = "session-wizard.tmux";
    version = "1.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "27medkamal";
      repo = "tmux-session-wizard";
      rev = "V${version}";
      sha256 = "sha256-nJaC5aX+cR/+ks3I/lW/tUnVG0CrEYfsIjPDisgMrTE=";
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
        --prefix PATH : ${with pkgs; lib.makeBinPath ([ fzf zoxide coreutils gnugrep gnused ])}
    '';
  };

  sessionist = mkTmuxPlugin {
    pluginName = "sessionist";
    version = "unstable-2017-12-03";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sessionist";
      rev = "09ec86be38eae98ffc27bd0dde605ed10ae0dc89";
      sha256 = "030q2mmj8akbc26jnqn8n7fckg1025p0ildx4wr401b6p1snnlw4";
    };
  };

  sidebar = mkTmuxPlugin {
    pluginName = "sidebar";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sidebar";
      rev = "aacbdb45bc5ab69db448a72de4155d0b8dbac677";
      sha256 = "1bp90zbv19kbbiik0bgb893ybss1jqsnk3353a631993xjwsih7c";
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
    version = "unstable-2019-07-14";
    src = fetchFromGitHub {
      owner = "seebi";
      repo = "tmux-colors-solarized";
      rev = "e5e7b4f1af37f8f3fc81ca17eadee5ae5d82cd09";
      sha256 = "1l3i82abzi4b395cgdsjg7lcfaq15kyyhijwvrgchzxi95z3hl4x";
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

  t-smart-tmux-session-manager = mkTmuxPlugin rec {
    pluginName = "t-smart-tmux-session-manager";
    version = "2.8.0";
    rtpFilePath = "t-smart-tmux-session-manager.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "t-smart-tmux-session-manager";
      rev = "v${version}";
      sha256 = "sha256-EMDEEIWJ+XFOk0WsQPAwj9BFBVDNwFUCyd1ScceqKpc=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/share/tmux-plugins/t-smart-tmux-session-manager/bin/t \
          --prefix PATH : ${with pkgs; lib.makeBinPath (
            [ pkgs.fzf pkgs.zoxide ]
          )}

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
      sha256 = "1jp4jq57cn116b3i34v6yy69izd8s6mp2ijr260cw86g0470k0fn";
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
      sha256 = "130l73v18md95djkc4s9d0fr018f8f183sjcgy7dgldwdaxlqdi1";
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
    version = "unstable-2022-08-21";
    src = fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "afb45a55b452b9238159047ce7c6e161bd4a9907";
      hash = "sha256-8A+Yt9uhhAP76EiqUopE8vl7/UXkgU2x000EOcF7pl0=";
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
    version = "unstable-2021-06-20";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-yank";
      rev = "1b1a436e19f095ae8f825243dbe29800a8acd25c";
      sha256 = "hRvkBf+YrWycecnDixAsD4CAHg3KsioomfJ/nLl5Zgs=";
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
      sha256 = "16llz3nlyw88lyd8mmj27i0ncyhpfjj5c1yikngf7nxcqsbjmcnh";
    };
    meta = with lib; {
      homepage = "https://github.com/o0th/tmux-nova";
      description = "tmux-nova theme";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ o0th ];
    };
  };
}
