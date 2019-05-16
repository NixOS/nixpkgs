{ fetchgit
, lib
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
    path ? (builtins.parseDrvName pluginName).name,
    dependencies ? [],
    ...
  }:
    addRtp "${rtpPath}/${path}" rtpFilePath a (stdenv.mkDerivation (a // {
      name = namePrefix + pluginName;

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
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-battery";
      rev = "09be78c35ee84f858f724442b94ad045ade23eb0";
      sha256 = "0gm6qiay0k5b3yzrabfmh4inyh9r6rfhja2l3r4cixcvc8sgvh8l";
    };
  };

  continuum = mkDerivation {
    pluginName = "continuum";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-continuum";
      rev = "90f4a00c41de094864dd4e29231253bcd80d4409";
      sha256 = "1hviqz62mnq5h4vgcy9bl5004q18yz5b90bnih0ibsna877x3nbc";
    };
    dependencies = [ resurrect ];
  };

  copycat = mkDerivation {
    pluginName = "copycat";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-copycat";
      rev = "6f9b9cd2d93872cef60e3ea7f7ae89598569ed25";
      sha256 = "12dgn5wnzrhd6sqa64w875ld3lrrny8xvdq6b6lzxyain9q49mrf";
    };
  };

  cpu = mkDerivation {
    pluginName = "cpu";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-cpu";
      rev = "12f7a74e25bf59701456e2c0d98b39bb19ec7039";
      sha256 = "0qxn8ngg297980lj6w8ih2m8m8bxxdbcz5hsjmlia92h5rdkm5kl";
    };
  };

  fpp = mkDerivation {
    pluginName = "fpp";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-fpp";
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
    src = fetchgit {
      url = "https://github.com/wfxr/tmux-fzf-url";
      rev = "ecd518eec1067234598c01e655b048ff9d06ef2f";
      sha256 = "0png8hdv91y2nivq5vdii2192mb2qcrkwwn69lzxrdnbfa27qrgv";
    };
  };

  logging = mkDerivation {
    pluginName = "logging";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-logging";
      rev = "b2706119cd587230beae02980d3d7fa2d5afebe9";
      sha256 = "1w1ymscfbz87lypaxgjdva1rg7jw2jyf7nnfgyngghw9m1l2xk2c";
    };
  };

  net-speed = mkDerivation {
    pluginName = "net-speed";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-net-speed";
      rev = "536d2bdd053a3bdfcc5cf7680c0dba76127c95ca";
      sha256 = "1bly5f40dgiym378jkfwm7qag9xl6qvziqiqnj65yblqd5py325z";
    };
  };

  maildir-counter = mkDerivation {
    pluginName = "maildir-counter";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-maildir-counter";
      rev = "9415f0207e71e37cbd870c9443426dbea6da78b9";
      sha256 = "0dwvqhiv9bjwr01hsi5c57n55jyv5ha5m5q1aqgglf4wyhbnfms4";
    };
  };

  online-status = mkDerivation {
    pluginName = "online-status";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-online-status";
      rev = "ea86704ced8a20f4a431116aa43f57edcf5a6312";
      sha256 = "1hy3vg8v2sir865ylpm2r4ip1zgd4wlrf24jbwh16m23qdcvc19r";
    };
  };

  open = mkDerivation {
    pluginName = "open";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-open";
      rev = "f99d3189c445188eae5fa9bfeabc95df16deca92";
      sha256 = "13q3zd5jv7akkjjwhgimmfylrvalxdn54fnpfb14g6xam6h8808m";
    };
  };

  pain-control = mkDerivation {
    pluginName = "pain-control";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-pain-control";
      rev = "731667692da46d51a6a9dffb4c43384a5d68ff28";
      sha256 = "1ihpl5wgjmhfgcrasgnydd7vpsar865sx2whra19gpfm4bglmdzl";
    };
  };

  prefix-highlight = mkDerivation {
    pluginName = "prefix-highlight";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-prefix-highlight";
      rev = "34f7125ae46e5123bedad03e08027332d1186186";
      sha256 = "16z8sm8pifg1m9lmv0z50fb0ws9mk5zqs7a1ddl2bfwkqi7yc0c0";
    };
  };

  resurrect = mkDerivation {
    pluginName = "resurrect";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-resurrect";
      rev = "7c77c70483b818d331e46c4cf64c716ded09a152";
      sha256 = "08gjxwdmfy16xpgi87rp9dj5338imqsy392pixf7xcnr05413ap1";
    };
  };

  sensible = mkDerivation {
    pluginName = "sensible";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-sensible";
      rev = "e91b178ff832b7bcbbf4d99d9f467f63fd1b76b5";
      sha256 = "1z8dfbwblrbmb8sgb0k8h1q0dvfdz7gw57las8nwd5gj6ss1jyvx";
    };
    postInstall = lib.optionalString pkgs.stdenv.isDarwin ''
      sed -e 's:reattach-to-user-namespace:${reattach-to-user-namespace}/bin/reattach-to-user-namespace:g' -i $target/sensible.tmux
    '';
  };

  sessionist = mkDerivation {
    pluginName = "sessionist";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-sessionist";
      rev = "09ec86be38eae98ffc27bd0dde605ed10ae0dc89";
      sha256 = "030q2mmj8akbc26jnqn8n7fckg1025p0ildx4wr401b6p1snnlw4";
    };
  };

  sidebar = mkDerivation {
    pluginName = "sidebar";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-sidebar";
      rev = "23014524cab53f8d36373983500fe05a527a444d";
      sha256 = "1w363587isdip1r81h0vkp5163lpa83lvasg8l04h43sbip2y6i8";
    };
  };

  urlview = mkDerivation {
    pluginName = "urlview";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-urlview";
      rev = "b84c876cffdd22990b4ab51247e795cbd7813d53";
      sha256 = "1jp4jq57cn116b3i34v6yy69izd8s6mp2ijr260cw86g0470k0fn";
    };
    postInstall = ''
      sed -i -e '14,20{s|urlview|${pkgs.urlview}/bin/urlview|g}' $target/urlview.tmux
    '';
    dependencies = [ pkgs.urlview ];
  };

  vim-tmux-navigator = mkDerivation {
    pluginName = "vim-tmux-navigator";
    rtpFilePath = "vim-tmux-navigator.tmux";
    src = fetchgit {
      url = "https://github.com/christoomey/vim-tmux-navigator";
      rev = "4e1a877f51a17a961b8c2a285ee80aebf05ccf42";
      sha256 = "1b8sgbzl4pcpaabqk254n97mjz767ganrmqbsr6rqzz3j9a3s1fv";
    };
  };

  yank = mkDerivation {
    pluginName = "yank";
    src = fetchgit {
      url = "https://github.com/tmux-plugins/tmux-yank";
      rev = "feb9611b7d1c323ca54cd8a5111a53e3e8265b59";
      sha256 = "1ywbm09jfh6cm2m6gracmdc3pp5p2dwraalbhfaafqaydjr22qc3";
    };
  };

}
