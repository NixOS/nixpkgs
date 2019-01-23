{ buildOpenRAMod, fetchFromGitHub, abbrevCommit, extraPostFetch }:

let
  unsafeBuildOpenRAMod = attrs: name: (buildOpenRAMod attrs name).overrideAttrs (_: {
    doCheck = false;
  });

in {
  ca = buildOpenRAMod {
    version = "93";
    title = "Combined Arms";
    description = "A game that combines units from the official OpenRA Red Alert and Tiberian Dawn mods";
    homepage = https://github.com/Inq8/CAmod;
    src = fetchFromGitHub {
      owner = "Inq8";
      repo = "CAmod";
      rev = "16fb77d037be7005c3805382712c33cec1a2788c";
      sha256 = "11fjyr3692cy2a09bqzk5ya1hf6plh8hmdrgzds581r9xbj0q4pr";
    };
    engine = let commit = "b8a7dd52ff893ed8225726d4ed4e14ecad748404"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAengine" ;
        rev = commit;
        sha256 = "0dyk861qagibx8ldshz7d2nrki9q550f6f0wy8pvayvf1gv1dbxj";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  d2 = unsafeBuildOpenRAMod rec {
    version = "128";
    title = "Dune II";
    description = "A modernization of the original ${title} game";
    homepage = https://github.com/OpenRA/d2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "bc969207b532a2def69e0d6ac09a4e8fb5d4e946";
      sha256 = "18v154kf1fmfk2gnymb3ggsfy73ql8rr7jvbhiw60yhzwx89cdk8";
    };
    engine = rec {
      version = "20181215";
      mods = [ "cnc" "d2k" "ra" ];
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "release-${version}";
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/d2/wiki
    '';
  };

  dr = buildOpenRAMod rec {
    version = "244";
    title = "Dark Reign";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/drogoganor/DarkReign;
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "e21db398f4d995c91b9e1a0f31ffaa7d54f43742";
      sha256 = "1gzvdf6idmx0rr8afaxd9dsbnxljif2kic6znkd9vcrwnqmp1fjr";
    };
    engine = let commit = "7fcfb1dcb2bd472fa6680ffa37bd3bbedb2c44c5"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "drogoganor";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0x7k96j3q16dgay4jjlyv9kcgn4sc4v9ksw6ijnjws7q1r2rjs0m";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  gen = buildOpenRAMod {
    version = "1133";
    title = "Generals Alpha";
    description = "Re-imagination of the original Command & Conquer: Generals game";
    homepage = https://github.com/MustaphaTR/Generals-Alpha;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "277d20d5a8b5e11eac9443031af133dc110c653f";
      sha256 = "1k37545l99q7zphnh1ykvimsyp5daykannps07d4dgr2w9l7bmhg";
    };
    engine = rec {
      version = "gen-20180905";
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "0wy1h7fg0n8dpy6y91md7x0qnr9rk4xf6155jali4bi8gghw2g5v";
        name = "generals-alpha-engine";
        inherit extraPostFetch;
      };
    };
  };

  kknd = buildOpenRAMod rec {
    version = "142";
    title = "Krush, Kill 'n' Destroy";
    description = "Re-imagination of the original ${title} game";
    homepage = https://kknd-game.com/;
    src = fetchFromGitHub {
      owner = "IceReaper";
      repo = "KKnD";
      rev = "54d34292168d5c47529688c8d5ca7693c4001ef3";
      sha256 = "1rsdig282cfr8b4iamr9ri6sshgppp8gllfyib6c2hvqqr301720";
    };
    engine = let commit = "4e8eab4ca00d1910203c8a103dfd2c002714daa8"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "1yyqparf93x8yzy1f46gsymgkj5jls25v2yc7ighr3f7mi3igdvq";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  mw = buildOpenRAMod rec {
    version = "235";
    title = "Medieval Warfare";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/CombinE88/Medieval-Warfare;
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "1e4fc7ea24d0806c5a7cd753490e967d804a3567";
      sha256 = "0swa66mzb6wr8vf1yivrss54dl98jzzwh9b8qrjfwmfrq2i356iq";
    };
    engine = let commit = "9f9617aa359ebc1923252b7a4a79def73ecfa8a2"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "CombinE88";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "02h29xnc1cb5zr001cnmaww5qnfnfaza4v28251jgzkby593r32q";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ra2 = buildOpenRAMod rec {
    version = "876";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "6a864b2a5887ae42291768fb3dec73082fee44ee";
      sha256 = "19m4z9r00dj67746ps2f9a8i1icq8nm0iiww6dl975yl6gaxp5qy";
    };
    engine = rec {
      version = "20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "release-${version}";
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  raclassic = buildOpenRAMod {
    version = "171";
    title = "Red Alert Classic";
    description = "A modernization of the original Command & Conquer: Red Alert game";
    homepage = https://github.com/OpenRA/raclassic;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "raclassic";
      rev = "a2319b3dfb367a8d4278bf7baf55a10abf615fbc";
      sha256 = "1k67fx4d9hg8mckzp7pp8lxa6ngqxnnrnbqyfls99dqc4df1iw0a";
    };
    engine = rec {
      version = "20181215";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "release-${version}";
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  rv = unsafeBuildOpenRAMod {
    version = "1294";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "c21cb11579d7e12354c5ccb5c3c47e567c6b3d4f";
      sha256 = "1vmc5b9awx8q0mahwv11fzgplw9w7m8kzvnx5cl7xr1w5wk87428";
    };
    engine = let commit = "e9e99074b294c32fbe88dd8727581cb8c512c2e2"; in {
      version = abbrevCommit commit;
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "GraionDilach";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0bibnakpmbxwglf2dka6g04xp8dzwyms1zk5kqlbm8gpdp0aqmxp";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  sp = unsafeBuildOpenRAMod {
    version = "153";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "89148b8cf89bf13911fafb74a1aa2b4cacf027e0";
      sha256 = "1bb8hzd3mhnn76iqiah1161qz98f0yvyryhmrghq03xlbin3mhbi";
    };
    engine = let commit = "82a2f234bdf3b768cea06408e3de30f9fbbe9412"; in {
      version = abbrevCommit commit;
      mods = [ "as" "ts" ];
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "1nl3brvx1bikxm5rmpc7xmd32n722jiyjh86pnar6b6idr1zj2ws";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ss = buildOpenRAMod rec {
    version = "72";
    title = "Sole Survivor";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/MustaphaTR/sole-survivor;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "fad65579c8b487cef9a8145e872390ed77c16c69";
      sha256 = "0h7is7x2qyvq7vqp0jgw5zrdkw8g7ndd82d843ldhnb0a3vyrk34";
    };
    engine = let commit = "becfc154c5cd3891d695339ff86883db8b5790a5"; in {
      version = abbrevCommit commit;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = commit;
        sha256 = "0id8vf3cjr7h5pz4sw8pdaz3sc45lxr21k1fk4309kixsrpa7i0y";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ura = buildOpenRAMod {
    version = "431";
    title = "Red Alert Unplugged";
    description = "Re-imagination of the original Command & Conquer: Red Alert game";
    homepage = http://redalertunplugged.com/;
    src = fetchFromGitHub {
      owner = "RAunplugged";
      repo = "uRA";
      rev = "128dc53741fae923f4af556f2293ceaa0cf571f0";
      sha256 = "1mhr8kyh313z52gdrqv31d6z7jvdldiajalca5mcr8gzg6mph66p";
    };
    engine = rec {
      version = "unplugged-cd82382";
      src = fetchFromGitHub {
        owner = "RAunplugged";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1p5hgxxvxlz8480vj0qkmnxjh7zj3hahk312m0zljxfdb40652w1";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  yr = unsafeBuildOpenRAMod rec {
    version = "117";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "1d4beeb0687fe4b39b01ec31f3702cfb90a7f4f7";
      sha256 = "1rd962ja1x72rz68kbmp19yiip3iif50hzlj3v8k1f5l94r2x2pn";
    };
    engine = rec {
      version = "20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "release-${version}";
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };
}
