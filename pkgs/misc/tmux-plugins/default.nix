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
      description = "continous saving of tmux environment";
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
    version = "unstable-2021-12-15";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "9eb3dba66672c5b43065e144cc3a1031f77ad67e";
      sha256 = "sha256-v/jZxsa+JwsSKjmA32VK/4gBNHP/SyOzTaYSSz2c0+4=";
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
    version = "2.0.0";
    src = fetchFromGitHub {
      owner = "dracula";
      repo = "tmux";
      rev = "v${version}";
      sha256 = "ILs+GMltb2AYNUecFMyQZ/AuETB0PCFF2InSnptVBos=";
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
    pluginName = "fingers";
    rtpFilePath = "tmux-fingers.tmux";
    version = "1.0.1";
    src = fetchFromGitHub {
      owner = "Morantron";
      repo = "tmux-fingers";
      rev = version;
      sha256 = "0gp37m3d0irrsih96qv2yalvr1wmf1n64589d4qzyzq16lzyjcr0";
      fetchSubmodules = true;
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for f in config.sh tmux-fingers.sh setup-fingers-mode-bindings.sh; do
      wrapProgram $target/scripts/$f \
        --prefix PATH : ${with pkgs; lib.makeBinPath (
          [ gawk ] ++ lib.optionals stdenv.isDarwin [ reattach-to-user-namespace ]
        )}
      done
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

  fzf-tmux-url = mkTmuxPlugin {
    pluginName = "fzf-tmux-url";
    rtpFilePath = "fzf-url.tmux";
    version = "unstable-2019-12-02";
    src = fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-fzf-url";
      rev = "2baa410bf7a0f6ceb62a83770baf90d570406ac0";
      sha256 = "0rjzzlmxgjrr8g19bg2idcqr9ny07mrq2s39vndg24n0m7znh3fz";
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
    version = "2020-08-12";
    src = fetchFromGitHub {
      owner = "jabirali";
      repo = "tmux-tilish";
      rev = "73d2404cdc0ef6bd7fbc8982edae0b0e2a4dd860";
      sha256 = "1x58h3bg9d69j40fh8rcjpxvg0i6j04pj8p3jk57l3cghxis5j05";
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
    version = "unstable-2021-10-20";
    src = fetchFromGitHub {
      owner = "sainnhe";
      repo = "tmux-fzf";
      rev = "1801dd525b39154745ea668fb6916035023949e3";
      sha256 = "e929Jqletmobp3WAR1tPU3pJuYTYVynxc5CvB80gig8=";
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
      sed -i -e '14,20{s|urlview|${pkgs.urlview}/bin/urlview|g}' $target/urlview.tmux
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
    version = "unstable-2019-12-10";
    src = fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "8fdf78292bb3aed1c9de880be7e03efdbf23d306";
      sha256 = "0y92na4dcfcsj5zbs3m7y6csl3sd46a9968id78cdn9cgg8iwzac";
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
}
