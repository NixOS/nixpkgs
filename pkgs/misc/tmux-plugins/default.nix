{ lib
, fetchFromGitHub
, pkgs
, reattach-to-user-namespace
, stdenv
}:

let
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // { rtp = "${derivation}/${path}/${rtpFilePath}"; } // {
      overrideAttrs = f: mkDerivation (attrs // f attrs);
    };

  mkDerivation = a@{
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
    dependencies ? [],
    ...
  }:
    addRtp "${rtpPath}/${path}" rtpFilePath a (stdenv.mkDerivation (a // {
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

      dependencies = [ pkgs.bash ] ++ dependencies;
    }));

in rec {

  inherit mkDerivation;

  battery = mkDerivation {
    pluginName = "battery";
    version = "unstable-2019-07-04";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-battery";
      rev = "f8b8e8451990365e0c98c38c184962e4f83b793b";
      sha256 = "1bhdzsx3kdjqjmm1q4j8937lrpkzf71irr3fqhdbddsghwrrmwim";
    };
  };

  continuum = mkDerivation {
    pluginName = "continuum";
    version = "unstable-2020-10-16";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "26eb5ffce0b559d682b9f98c8d4b6c370ecb639b";
      sha256 = "1glwa89bv2r92qz579a49prk3jf612cpd5hw46j4wfb35xhnj3ab";
    };
    dependencies = [ resurrect ];
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
      license = stdenv.lib.licenses.mit;
      platforms = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ ronanmacf ];
    };
  };

  copycat = mkDerivation {
    pluginName = "copycat";
    version = "unstable-2020-01-09";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-copycat";
      rev = "77ca3aab2aed8ede3e2b941079b1c92dd221cf5f";
      sha256 = "1bchwzhai8k5rk32n4lrmh56rw944jqxr8imjk74hyaa7bbn81ds";
    };
  };

  cpu = mkDerivation {
    pluginName = "cpu";
    version = "unstable-2020-07-25";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "20120a38ade17057441482b43eb5390e6ea2c1c1";
      sha256 = "1gdz2awyd9icvyiw2p40gwymh6ngjhb9mkiv63ix53snp9ii794i";
    };
  };

  ctrlw = mkDerivation rec {
    pluginName = "ctrlw";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "tmux-ctrlw";
      rev = "v${version}";
      sha256 = "1kv5pqfjczd6z7i9jf6j5xmcai50l9bn5p2p1w1l5fi6cj8cz1k1";
    };
  };

  dracula = mkDerivation rec {
    pluginName = "dracula";
    version = "unstable-2020-12-2";
    src = fetchFromGitHub {
      owner = "dracula";
      repo = "tmux";
      rev = "cc310e585acbeaf3304eda662476f7f657010b01";
      sha256 = "003nbv2rz2ihyqf3ryvdwn43ly0gi5z2r0pnqr9s9vw8dmwx0r3x";
    };
    meta = with stdenv.lib; {
      homepage = "https://draculatheme.com/tmux";
      description = "A feature packed Dracula theme for tmux!";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ ethancedwards8 ];
    };
  };

  fingers = mkDerivation rec {
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
    dependencies = [ pkgs.gawk ];
  };

  fpp = mkDerivation {
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
    dependencies = [ pkgs.fpp ];
  };

  fzf-tmux-url = mkDerivation {
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

  gruvbox = mkDerivation {
    pluginName = "gruvbox";
    rtpFilePath = "gruvbox-tpm.tmux";
    version = "unstable-2019-05-05";
    src = fetchFromGitHub {
      owner = "egel";
      repo = "tmux-gruvbox";
      rev = "6149fd8b5d6924925b4d5aa6935039780e94f3d6";
      sha256 = "1ykr4yardavd0x7yfrnshd4b0gi8p31pji7i79ib0nss134zncpb";
    };
  };

  jump = mkDerivation {
    pluginName = "jump";
    version = "2020-06-26";
    rtpFilePath = "tmux-jump.tmux";
    src = fetchFromGitHub {
      owner = "schasse";
      repo = "tmux-jump";
      rev = "416f613d3eaadbe1f6f9eda77c49430527ebaffb";
      sha256 = "1xbzdyhsgaq2in0f8f491gwjmx6cxpkf2c35d2dk0kg4jfs505sz";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/schasse/tmux-jump";
      description = "Vimium/Easymotion like navigation for tmux";
      license = licenses.gpl3;
      platforms = platforms.unix;
      maintainers = with maintainers; [ arnarg ];
    };
  };

  logging = mkDerivation {
    pluginName = "logging";
    version = "unstable-2019-04-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-logging";
      rev = "b085ad423b5d59a2c8b8d71772352e7028b8e1d0";
      sha256 = "0p0sawysalhi8k2a5hdxniqx6kb24kd8rnvfzkjqigzid5ik37js";
    };
  };

  net-speed = mkDerivation {
    pluginName = "net-speed";
    version = "unstable-2018-12-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-net-speed";
      rev = "58abb615971cb617821e2e7e41c660334f55a92d";
      sha256 = "1aj06gdhzcxsydjzf21n9kyxigwf38kh2rg8hh7gnjk260ydqlrc";
    };
  };

  nord = mkDerivation rec {
    pluginName = "nord";
    version = "0.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "arcticicestudio";
      repo = "nord-tmux";
      rev = "v${version}";
      sha256 = "14xhh49izvjw4ycwq5gx4if7a0bcnvgsf3irywc3qps6jjcf5ymk";
    };
  };

  maildir-counter = mkDerivation {
    pluginName = "maildir-counter";
    version = "unstable-2016-11-25";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-maildir-counter";
      rev = "9415f0207e71e37cbd870c9443426dbea6da78b9";
      sha256 = "0dwvqhiv9bjwr01hsi5c57n55jyv5ha5m5q1aqgglf4wyhbnfms4";
    };
  };

  online-status = mkDerivation {
    pluginName = "online-status";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-online-status";
      rev = "ea86704ced8a20f4a431116aa43f57edcf5a6312";
      sha256 = "1hy3vg8v2sir865ylpm2r4ip1zgd4wlrf24jbwh16m23qdcvc19r";
    };
  };

  open = mkDerivation {
    pluginName = "open";
    version = "unstable-2019-12-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-open";
      rev = "cedb4584908bd8458fadc8d3e64101d3cbb48d46";
      sha256 = "10s0xdhmg0dhpj13ybcq72pw3xgb2dq5v5h2mwidzqyh9g17wndh";
    };
  };

  onedark-theme = mkDerivation {
    pluginName = "onedark-theme";
    version = "unstable-2020-06-07";
    src = fetchFromGitHub {
      owner = "odedlaz";
      repo = "tmux-onedark-theme";
      rev = "3607ef889a47dd3b4b31f66cda7f36da6f81b85c";
      sha256 = "19jljshwp2p83b634cd1mw69091x42jj0dg40ipw61qy6642h2m5";
    };
  };

  pain-control = mkDerivation {
    pluginName = "pain-control";
    version = "unstable-2020-02-18";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-pain-control";
      rev = "2db63de3b08fc64831d833240749133cecb67d92";
      sha256 = "0w7a6n4n86ysiqcqj12j2hg9r5fznvbp3dz8pzas9q1k3avlk0zk";
    };
  };

  plumb = mkDerivation rec {
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

  prefix-highlight = mkDerivation {
    pluginName = "prefix-highlight";
    version = "unstable-2020-03-26";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-prefix-highlight";
      rev = "1db6e735aad54503b076391d791c56e1af213917";
      sha256 = "0ws9blzg00zhz548m51cm6zbrkqlz7jazkr5029vka1f6qk36x0g";
    };
  };

  resurrect = mkDerivation {
    pluginName = "resurrect";
    version = "unstable-2020-09-18";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "e4825055c92e54b0c6ec572afc9b6c4723aba6c8";
      sha256 = "0a96drkx1kpadkbxabcnvb542p75xdh2dbizvlq2lac5ldpb4hmx";
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
      license = stdenv.lib.licenses.mit;
      platforms = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ ronanmacf ];
    };
  };

  sensible = mkDerivation {
    pluginName = "sensible";
    version = "unstable-2017-09-05";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sensible";
      rev = "e91b178ff832b7bcbbf4d99d9f467f63fd1b76b5";
      sha256 = "1z8dfbwblrbmb8sgb0k8h1q0dvfdz7gw57las8nwd5gj6ss1jyvx";
    };
    postInstall = lib.optionalString pkgs.stdenv.isDarwin ''
      sed -e 's:reattach-to-user-namespace:${reattach-to-user-namespace}/bin/reattach-to-user-namespace:g' -i $target/sensible.tmux
    '';
  };

  sessionist = mkDerivation {
    pluginName = "sessionist";
    version = "unstable-2017-12-03";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sessionist";
      rev = "09ec86be38eae98ffc27bd0dde605ed10ae0dc89";
      sha256 = "030q2mmj8akbc26jnqn8n7fckg1025p0ildx4wr401b6p1snnlw4";
    };
  };

  sidebar = mkDerivation {
    pluginName = "sidebar";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sidebar";
      rev = "aacbdb45bc5ab69db448a72de4155d0b8dbac677";
      sha256 = "1bp90zbv19kbbiik0bgb893ybss1jqsnk3353a631993xjwsih7c";
    };
  };

  sysstat = mkDerivation {
    pluginName = "sysstat";
    version = "unstable-2017-12-12";
    src = fetchFromGitHub {
      owner = "samoshkin";
      repo = "tmux-plugin-sysstat";
      rev = "29e150f403151f2341f3abcb2b2487a5f011dd23";
      sha256 = "013mv9p6r2r0ls3p60l8hdad4hm8niv3wr27vgm925gxmibi4hyq";
    };
  };

  tilish = mkDerivation {
    pluginName = "tilish";
    version = "2020-08-12";
    src = fetchFromGitHub {
      owner = "jabirali";
      repo = "tmux-tilish";
      rev = "73d2404cdc0ef6bd7fbc8982edae0b0e2a4dd860";
      sha256 = "1x58h3bg9d69j40fh8rcjpxvg0i6j04pj8p3jk57l3cghxis5j05";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/jabirali/tmux-tilish";
      description = "Plugin which makes tmux work and feel like i3wm";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ arnarg ];
    };
  };

  tmux-colors-solarized = mkDerivation {
    pluginName = "tmuxcolors";
    version = "unstable-2019-07-14";
    src = fetchFromGitHub {
      owner = "seebi";
      repo = "tmux-colors-solarized";
      rev = "e5e7b4f1af37f8f3fc81ca17eadee5ae5d82cd09";
      sha256 = "1l3i82abzi4b395cgdsjg7lcfaq15kyyhijwvrgchzxi95z3hl4x";
    };
  };

  tmux-fzf = mkDerivation {
    pluginName = "tmux-fzf";
    version = "unstable-2020-11-23";
    src = fetchFromGitHub {
      owner = "sainnhe";
      repo = "tmux-fzf";
      rev = "312685b2a7747b61f1f4a96bd807819f1450479d";
      sha256 = "1z0zmsf8asxs9wbwvkiyd81h93wb2ikl8nxxc26sdpi6l333q5s9";
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
      license = stdenv.lib.licenses.mit;
      platforms = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ kyleondy ];
    };
  };

  urlview = mkDerivation {
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
    dependencies = [ pkgs.urlview ];
  };

  vim-tmux-focus-events = mkDerivation {
    pluginName = "vim-tmux-focus-events";
    version = "unstable-2020-10-05";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "vim-tmux-focus-events";
      rev = "a568192ca0de4ca0bd7b3cd0249aad491625c941";
      sha256 = "130l73v18md95djkc4s9d0fr018f8f183sjcgy7dgldwdaxlqdi1";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/tmux-plugins/vim-tmux-focus-events";
      description = "Makes FocusGained and FocusLost autocommand events work in vim when using tmux";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ ronanmacf ];
    };
  };

  vim-tmux-navigator = mkDerivation {
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

  yank = mkDerivation {
    pluginName = "yank";
    version = "unstable-2019-12-02";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-yank";
      rev = "648005db64d9bf3c4650eff694ecb6cf3e42b0c8";
      sha256 = "1zg9k8yk1iw01vl8m44w4sv20lln4l0lq9dafc09lxmgxm9dllj4";
    };
  };

}
