{ fetchFromGitHub }:

let
  extraPostFetch = ''
    sed -i 's/curl/curl --insecure/g' $out/thirdparty/{fetch-thirdparty-deps,noget}.sh
    $out/thirdparty/fetch-thirdparty-deps.sh
  '';

in [
  {
    mod = {
      name = "ca";
      version = "93";
      title = "Combined Arms";
      description = "Re-imaginging of the original Command & Conquer: Red Alert game";
      homepage = https://github.com/Inq8/CAmod;
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAmod";
        rev = "16fb77d037be7005c3805382712c33cec1a2788c";
        sha256 = "11fjyr3692cy2a09bqzk5ya1hf6plh8hmdrgzds581r9xbj0q4pr";
        name = "mod";
      };
      makefilePatch = ./Makefile-ca.patch;
    };
    engine = rec {
      version = "b8a7dd5";
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAengine" ;
        rev = version;
        sha256 = "0dyk861qagibx8ldshz7d2nrki9q550f6f0wy8pvayvf1gv1dbxj";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  }
  {
    mod = {
      name = "d2";
      version = "124";
      title = "Dune II";
      description = "Re-imaginging of the original Command & Conquer: Red Alert 2 game";
      homepage = https://github.com/OpenRA/d2;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "d2";
        rev = "30ab6e1c2489594000639416fb8099995f4ec657";
        sha256 = "06mjy8330fqkvfmdmj1mw0qd4mkg0zgi0f1nfb5qjj9a272v4vsb";
        name = "mod";
      };
      makefilePatch = ./Makefile-d2.patch;
    };
    engine = rec {
      version = "release-20181215";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    engineMods = [ "cnc" "d2k" "ra" ];
  }
  {
    mod = {
      name = "gen";
      version = "1133";
      title = "Generals Alpha";
      description = "Re-imaginging of the original Command & Conquer: Generals game";
      homepage = https://github.com/MustaphaTR/Generals-Alpha;
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "Generals-Alpha";
        rev = "277d20d5a8b5e11eac9443031af133dc110c653f";
        sha256 = "1k37545l99q7zphnh1ykvimsyp5daykannps07d4dgr2w9l7bmhg";
        name = "mod";
      };
      makefilePatch = ./Makefile-gen.patch;
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
  }
  {
    mod = {
      name = "kknd";
      version = "136";
      title = "Krush, Kill n' Destroy";
      description = "Re-imaginging of the original Krush, Kill n' Destroy game";
      homepage = https://kknd-game.com/;
      src = fetchFromGitHub {
        owner = "IceReaper";
        repo = "KKnD";
        rev = "fcf0f93e7d5cdb4e7884c7dcb8bca51486c60a15";
        sha256 = "0ncdhgn9qwa2ca8pkhyy8q4jb8g2nig793i7nvxygbnh2lb233xg";
        name = "mod";
      };
      makefilePatch = ./Makefile-kknd.patch;
    };
    engine = rec {
      version = "84936abee6d5d287104f40b7cfcb43b8d7f8b52b";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1lr8aindnx91ywgz1sapb448k7kgjisz94l31q87s1bf59h3xw4d";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  }
  {
    mod = {
      name = "ra2";
      version = "874";
      title = "Red Alert 2";
      description = "Re-imaginging of the original Command & Conquer: Red Alert 2 game";
      homepage = https://github.com/OpenRA/ra2;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "ra2";
        rev = "05b1b7633d45a0d92d7a081303e2e1544d1f5a02";
        sha256 = "0wwn7pipk87pwwlyfp0b19phldfy393lmbkxibkhccgsvh58y46n";
        name = "mod";
      };
      makefilePatch = ./Makefile-ra2.patch;
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  }
  {
    mod = {
      name = "raclassic";
      version = "171";
      title = "Red Alert Classic";
      description = "A modernization of the original Command & Conquer: Red Alert game";
      homepage = https://github.com/OpenRA/raclassic;
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "raclassic";
        rev = "a2319b3dfb367a8d4278bf7baf55a10abf615fbc";
        sha256 = "1k67fx4d9hg8mckzp7pp8lxa6ngqxnnrnbqyfls99dqc4df1iw0a";
        name = "mod";
      };
      makefilePatch = ./Makefile-raclassic.patch;
    };
    engine = rec {
      version = "release-20181215";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  }
  {
    mod = {
      name = "rv";
      version = "1250";
      title = "Romanov's Vengeance";
      description = "Re-imaginging of the original Command & Conquer: Red Alert 2 game";
      homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "Romanovs-Vengeance";
        rev = "c8cd7491c0f14681fcd63b021cdd0e66aec8b936";
        sha256 = "0hnxwdf1wryhz0hfjwhds46npw9rkryv3r86r43njmzsrllq8xvz";
        name = "mod";
      };
      makefilePatch = ./Makefile-rv.patch;
    };
    engine = rec {
      version = "810d59c";
      src = fetchFromGitHub {
        owner = "GraionDilach";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "0q201x6yc5i0z05048cr9mc43n3df5nzk8425d22rnjanin9jhbd";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    engineMods = [ "as" ];
  }
  {
    mod = {
      name = "sp";
      version = "153";
      title = "Shattered Paradise";
      description = "Re-imaginging of the original Command & Conquer: Tiberian Sun game";
      homepage = https://github.com/ABrandau/Shattered-Paradise;
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRAModSDK";
        rev = "89148b8cf89bf13911fafb74a1aa2b4cacf027e0";
        sha256 = "1bb8hzd3mhnn76iqiah1161qz98f0yvyryhmrghq03xlbin3mhbi";
        name = "mod";
      };
      makefilePatch = ./Makefile-sp.patch;
    };
    engine = rec {
      version = "NAs-Test-Build";
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1nl3brvx1bikxm5rmpc7xmd32n722jiyjh86pnar6b6idr1zj2ws";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    engineMods = [ "as" "ts" ];
  }
  {
    mod = {
      name = "ura";
      version = "431";
      title = "Red Alert Unplugged";
      description = "Re-imaginging of the original Command & Conquer: Red Alert game";
      homepage = http://redalertunplugged.com/;
      src = fetchFromGitHub {
        owner = "RAunplugged";
        repo = "uRA";
        rev = "128dc53741fae923f4af556f2293ceaa0cf571f0";
        sha256 = "1mhr8kyh313z52gdrqv31d6z7jvdldiajalca5mcr8gzg6mph66p";
        name = "mod";
      };
      makefilePatch = ./Makefile-ura.patch;
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
  }
  {
    mod = {
      name = "yr";
      version = "114";
      homepage = https://github.com/cookgreen/yr;
      title = "Yuri's Revenge";
      description = "Re-imaginging of the original Command & Conquer: Yuri's Revenge game";
      src = fetchFromGitHub {
        owner = "cookgreen";
        repo = "yr";
        rev = "a9150114808dc2823b47b97e39969bdb6b27cf98";
        sha256 = "1bjagkbqlkw6djxv86h1wfhnj6n2ggmfd5qp1b444inxblgk8wrf";
        name = "mod";
      };
      makefilePatch = ./Makefile-yr.patch;
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  }
]
