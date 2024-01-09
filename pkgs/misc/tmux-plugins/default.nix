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
      sha256 = "1gx5f6qylzcqn6y3i1l92j277rqjrin7kn86njvn174d32wi78y8";
    };
  };

  better-mouse-mode = mkTmuxPlugin {
    pluginName = "better-mouse-mode";
    version = "unstable-2017-10-16";
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
    version = "unstable-2023-11-01";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "47e33044b4b47b1c1faca1e42508fc92be12131a";
      hash = "sha256-kn3kf7eiiwXj57tgA7fs5N2+B2r441OtBlM8IBBLl4I=";
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
    version = "unstable-2022-07-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-continuum";
      rev = "3e4bc35da41f956c873aea716c97555bf1afce5d";
      sha256 = "1py8qfs2f93hkxhk039m813bjgcs5k54si662gx05g3czqy06pb7";
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
      sha256 = "0nclcmrk0dpa2y9d94xvyfz416xqkslzlfgdj3z8yb6a8vz2xlyr";
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
      sha256 = "1vmji41kl3av9ginc3wh4mgaw7w6w5v7j7wh6xhdk0r9382l7cr2";
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
    version = "unstable-2023-11-04";
    src = fetchFromGitHub {
      owner = "laktak";
      repo = "extrakto";
      rev = "f8d15d9150f151305cc6da67fc7a0b695ead0321";
      sha256 = "1y77g7bp7bwyb3405wdk0cfaqvm5wiar8xjkdx2dq5afzg0mgb19";
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
    version = "2.1.1";
    src = fetchFromGitHub {
      owner = "Morantron";
      repo = "tmux-fingers";
      rev = version;
      sha256 = "0im0psrin97chakwrz5bfh4vjl09svkv1mqky6gm5s0cdzm230ym";
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
    version = "unstable-2022-09-19";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-fpp";
      rev = "1f5e795c04098955ae65df09146007e07718be42";
      sha256 = "0mnvnfi4niqmnj83pz9mky14rwf40abn23wx16rgy363xbg871zl";
    };
    postInstall = ''
      sed -i -e 's|fpp |${pkgs.fpp}/bin/fpp |g' $target/fpp.tmux
    '';
  };

  fuzzback = mkTmuxPlugin {
    pluginName = "fuzzback";
    version = "unstable-2023-10-05";
    src = fetchFromGitHub {
      owner = "roosta";
      repo = "tmux-fuzzback";
      rev = "f272cdecb767f996fa181144a5e465d90bb849ef";
      sha256 = "05d0p1nm8q4y2yf0s481dbm2x1402np9byh29q33wnac9h14dyd9";
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
    version = "unstable-2023-11-04";
    src = fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-fzf-url";
      rev = "5ad2fe23dbf46976a7e6323fda7cf28dc7adac7a";
      sha256 = "0mz3vhyf1p4vd70zm70sjqw3p9fmln5i99lqdmm0xlxv2k7prcm5";
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
      sha256 = "1frk1c0p5qxy7aadnc875pyaw5wg8sk8xlc239ckhj8410lm00ff";
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
      sha256 = "168wb14vpf984bmm5pnx3jz4chx8mad1z759xrllfqxl3igx8c1m";
    };
  };

  mode-indicator = mkTmuxPlugin {
    pluginName = "mode-indicator";
    version = "unstable-2023-03-24";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "tmux-mode-indicator";
      rev = "7027903adca37c54cb8f5fa99fc113b11c23c2c4";
      sha256 = "1zbci8kmkr4kis2zv0lgzi04knbjzx6zsxyxwrpc46z8hagyq328";
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
      sha256 = "19q9s3rpdwzm6y5hzap7p88b8c5w6hva162mxljli6nzi7d70jnn";
    };
  };

  online-status = mkTmuxPlugin {
    pluginName = "online-status";
    version = "unstable-2018-11-30";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-online-status";
      rev = "82f4fbcaee7ece775f37cf7ed201f9d4beab76b8";
      sha256 = "062qwxi46j7mjkk7d0mijx3rn4aznx5md7arw45ncaqpywwpzi5y";
    };
  };

  open = mkTmuxPlugin {
    pluginName = "open";
    version = "3.0.0-unstable-2022-08-22";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-open";
      rev = "763d0a852e6703ce0f5090a508330012a7e6788e";
      sha256 = "1xwc0bzn4bd08agjz7bhq1gwjriq4crk7zrrnqfslc5m7pna462f";
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
      sha256 = "19jljshwp2p83b634cd1mw69091x42jj0dg40ipw61qy6642h2m5";
    };
  };

  pain-control = mkTmuxPlugin {
    pluginName = "pain-control";
    version = "unstable-2021-08-09";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-pain-control";
      rev = "32b760f6652f2305dfef0acd444afc311cf5c077";
      sha256 = "06rbr0n7pabi4wr7idpb2ri1r14gr2nmgbkq2y3x73ssng1kslnr";
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
    version = "unstable-2023-11-08";
    src = pkgs.fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-power";
      rev = "1d73c304573b3ae369567d2ef635f0e1c3de7ecc";
      sha256 = "0v4y5d66xgy6zwwfwjbsj733sqm777rs3g8j1djg4jl6dlp2gr8w";
    };
  };

  prefix-highlight = mkTmuxPlugin {
    pluginName = "prefix-highlight";
    version = "unstable-2023-10-10";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-prefix-highlight";
      rev = "13a16701207f3aac846cf7daed3f45ed3e7ea756";
      sha256 = "1gv5qdcy0xz3g397mzf2xi6v1q8wf8wzzf71dhmjg9k2dspshdwk";
    };
  };

  resurrect = mkTmuxPlugin {
    pluginName = "resurrect";
    version = "unstable-2023-03-06";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-resurrect";
      rev = "cff343cf9e81983d3da0c8562b01616f12e8d548";
      sha256 = "0djfz7m4l8v2ccn1a97cgss5iljhx9k2p8k9z50wsp534mis7i0m";
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
      sha256 = "0y747qnryvlfch6kd37dwi1svmnnf5l4ijajckfnggz6ikan03xk";
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
      sha256 = "1nzb3q7lrl3adywsbxf0w4rsxv97qzlnjh96wgq3b3gfwaz0sbw8";
    };
  };

  sidebar = mkTmuxPlugin {
    pluginName = "sidebar";
    version = "0.7.0-unstable-2022-12-08";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-sidebar";
      rev = "a41d72c019093fd6a1216b044e111dd300684f1a";
      sha256 = "1pk1md6kn9zqf11vym8idchpnsz9mzp083rarpgk0q6phnz15qp7";
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
      sha256 = "10lg4jc591mpsqv2104bcghw703fylmvl6ykn0wv5r9c8asglp1k";
    };
  };

  tmux-fzf = mkTmuxPlugin {
    pluginName = "tmux-fzf";
    rtpFilePath = "main.tmux";
    version = "unstable-2023-12-06";
    src = fetchFromGitHub {
      owner = "sainnhe";
      repo = "tmux-fzf";
      rev = "f9c98cd0f86f1a48cb51fc65972c52fc36776a54";
      hash = "sha256-UZPcOofO0tzquWgbMwsDkZBzo/iX1txcns9v56oWlK8=";
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
    version = "unstable-2016-03-03";
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
    version = "1.0.0-unstable-2021-04-27";
    src = fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "vim-tmux-focus-events";
      rev = "b1330e04ffb95ede8e02b2f7df1f238190c67056";
      sha256 = "19r8gslq4m70rgi51bnlazhppggiy3crnmaqyvjc25f59f1213a7";
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
    version = "1.0-unstable-2023-09-16";
    src = fetchFromGitHub {
      owner = "christoomey";
      repo = "vim-tmux-navigator";
      rev = "7db70e08ea03b3e4d91f63713d76134512e28d7e";
      hash = "sha256-xCgiaJFS438FY4IAA1UynaCNwOU0s3tct2oqwC4NvxY=";
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
      sha256 = "142ybm3wdqbdmdc7502am2xscrrabn72cnanyaflvndihdmcz4gz";
    };
  };
}
