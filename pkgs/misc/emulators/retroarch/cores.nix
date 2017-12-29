{ stdenv, fetchgit, cmake, pkgconfig, makeWrapper, python27, retroarch
, alsaLib, fluidsynth, curl, hidapi, mesa, gettext, glib, gtk2, portaudio, SDL
, ffmpeg, pcre, libevdev, libpng, libjpeg, libudev, libvorbis
, miniupnpc, sfml, xorg, zlib }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "2017-06-04";
    inherit src;

    buildInputs = [ makeWrapper retroarch zlib ] ++ a.extraBuildInputs or [];

    buildPhase = "make -f Makefile.libretro";
    installPhase = ''
      COREDIR="$out/lib/retroarch/cores"
      mkdir -p $out/bin
      mkdir -p $COREDIR
      mv ${d2u core}_libretro.so $COREDIR/.
      makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch-${core} \
        --add-flags "-L $COREDIR/${d2u core}_libretro.so $@"
    '';

    passthru = {
      core = core;
      libretroCore = "/lib/retroarch/cores";
    };

    meta = with stdenv.lib; {
      inherit description;
      homepage = https://www.libretro.com/;
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ edwtjo hrdinka MP2E ];
      platforms = platforms.linux;
    };
  } // a);

  fetchRetro = { repo, rev, sha256 }:
  fetchgit {
    inherit rev sha256;
    url = "https://github.com/libretro/${repo}.git";
    fetchSubmodules = true;
  };

in

{

  _4do = (mkLibRetroCore rec {
    core = "4do";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "52d881743dd8614d96b4de8bd153cb725b87d474";
      sha256 = "1n42f70vni2zavppayaq8xmsyx5cn40qi4zk4pgq1w3hh2q8mj72";
    };
    description = "Port of 4DO/libfreedo to libretro";
  }).override {
    buildPhase = "make";
  };

  beetle-pce-fast = (mkLibRetroCore rec {
    core = "mednafen-pce-fast";
    src = fetchRetro {
      repo = "beetle-pce-fast-libretro";
      rev = "2954e645d668ee73d93803dc30da4462fc7a459b";
      sha256 = "0p0k7kqfd6xg1qh6vgzgwp122miprb2bpzljgxd9kvigxihsl6f7";
    };
    description = "Port of Mednafen's PC Engine core to libretro";
  }).override {
    buildPhase = "make";
    name = "beetle-pce-fast";
  };

  beetle-psx = (mkLibRetroCore rec {
    core = "mednafen-psx";
    src = fetchRetro {
      repo = "beetle-psx-libretro";
      rev = "76862abefdde9097561e2b795e75b49247deff17";
      sha256 = "1k4b7g50ajzchjrm6d3v68hvri4k3hzvacn2l99i5yq3hxp7vs7x";
    };
    description = "Port of Mednafen's PSX Engine core to libretro";
  }).override {
    buildPhase = "make";
    name = "beetle-psx";
  };

  beetle-saturn = (mkLibRetroCore rec {
    core = "mednafen-saturn";
    src = fetchRetro {
      repo = "beetle-saturn-libretro";
      rev = "3f1661b39ef249e105e6e2e655854ad0c87cd497";
      sha256 = "1d1brysynwr6inlwfgv7gwkl3i9mf4lsaxd9wm2szw86g4diyn4c";
    };
    description = "Port of Mednafen's Saturn core to libretro";
  }).override {
    buildPhase = "make";
    name = "beetle-saturn";
    meta.platforms = [ "x86_64-linux" ];
  };

  bsnes-mercury = let bname = "bsnes-mercury"; in (mkLibRetroCore rec {
    core = bname + "-accuracy";
    src = fetchRetro {
      repo = bname;
      rev = "e89c9a2e0a12d588366ee4f5c76b7d75139d938b";
      sha256 = "0vkn1f38vwazpp3kbvvv8c467ghak6yfx00s48wkxwvhmak74a3s";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
  }).override {
    buildPhase = "make && cd out";
  };

  desmume = (mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core;
      rev = "ce1f93abb4c3aa55099f56298e5438a03a3c2bbd";
      sha256 = "064gzfbr7yizmvi91ry5y6bzikj633kdqhvzycb9f1g6kspf8yyl";
    };
    description = "libretro wrapper for desmume NDS emulator";
  }).override {
    configurePhase = "cd desmume";
  };

  dolphin = (mkLibRetroCore {
    core = "dolphin";
    src = fetchRetro {
      repo = "dolphin";
      rev = "a6ad451fdd4ac8753fd1a8e2234ec34674677754";
      sha256 = "1cshlfmhph8dl3vgvn37imvp2b7xs2cx1r1ifp5js5psvhycrbz3";
    };
    description = "Port of Dolphin to libretro";

    extraBuildInputs = [
      cmake curl mesa pcre pkgconfig sfml miniupnpc
      gettext glib gtk2 hidapi
      libevdev libudev
    ] ++ (with xorg; [ libSM libX11 libXi libpthreadstubs libxcb xcbutil ]);
  }).override {
    cmakeFlags = [
        "-DLINUX_LOCAL_DEV=true"
        "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
        "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
        "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    ];
    dontUseCmakeBuildDir = "yes";
    buildPhase = ''
      cd Source/Core/DolphinLibretro
      make
    '';
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "9146c18ac989c619256d1cb8954d49e728e44ea3";
      sha256 = "159dww8mxi95xz4ypw38vsn1g4k6z8sv415qqf0qriydwhw6mh2m";
    };
    description = "Port of Final Burn Alpha to libretro";
  }).override {
    buildPhase = ''
      cd svn-current/trunk \
      && make -f makefile.libretro \
      && mv fbalpha2012_libretro.so fba_libretro.so
    '';
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "45f773a1c221121746bbe2680e3aaaf92776a87e";
      sha256 = "0jnwh1338q710x47bzrx319g5xbq9ipv35kyjlbkrzhqjq1blz0b";
    };
    description = "FCEUmm libretro port";
  };

  gambatte = mkLibRetroCore rec {
    core = "gambatte";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "db7af6cf6ea39fd5e39eea137ff752649599a4e4";
      sha256 = "0h7hyj630nk1s32wx02y4q9x2lp6wbnh6nkc9ihf4pygcsignmwr";
    };
    description = "Gambatte libretro port";
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "365a28c7349b691e6aaa3ad59b055261c42bd130";
      sha256 = "0s11ddpnb44q4xjkl7dylldhi9y5zqywqavpk0bbwyj84r1cbz3c";
    };
    description = "Enhanced Genesis Plus libretro port";
  };

  mame = mkLibRetroCore {
    core = "mame";
    src = fetchRetro {
      repo = "mame";
      rev = "9f8a36adeb4dc54ec2ecac992ce91bcdb377519e";
      sha256 = "0blfvq28hgv9kkpijd8c9d9sa5g2qr448clwi7wrj8kqfdnrr8m1";
    };
    description = "Port of MAME to libretro";

    extraBuildInputs = [ alsaLib mesa portaudio python27 xorg.libX11 ];
  };

  mgba = mkLibRetroCore rec {
    core = "mgba";
    src = fetchRetro {
      repo = core;
      rev = "fdaaaee661e59f28c94c7cfa4e82e70b71e24a9d";
      sha256 = "1b30sa861r4bhbqkx6vkklh4iy625bpzki2ks4ivvjns1ijczvc7";
    };
    description = "Port of mGBA to libretro";
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "407bcd40b3a42bff6b856a6d6f88a7d5d670bf9e";
      sha256 = "0q5kvjz7rpk7mp75cdywqjgmy10c0h7ky26hh1x90d39y94idcd8";
    };
    description = "Libretro port of Mupen64 Plus, GL only";

    extraBuildInputs = [ mesa libpng ];
  }).override {
    buildPhase = "make WITH_DYNAREC=${if stdenv.system == "x86_64-linux" then "x86_64" else "x86"}";
  };

  nestopia = (mkLibRetroCore rec {
    core = "nestopia";
    src = fetchRetro {
      repo = core;
      rev = "ecfa170a582e5b8ec11225ca645843fa064955ca";
      sha256 = "17ac7dhasch6f4lpill8c5scsvaix0jvbf1cp797qbll4hk84f2q";
    };
    description = "nestopia undead libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  parallel-n64 = (mkLibRetroCore rec {
    core = "parallel-n64";
    src = fetchRetro {
      repo = core;
      rev = "3276db27547bf7ca85896427f0b82d4658694d88";
      sha256 = "19396v50azrb52ifjk298zgcbxn8dvfvp6zwrnzsk6mp8ff7qcqw";
    };
    description = "Parallel Mupen64plus rewrite for libretro.";

    extraBuildInputs = [ mesa libpng ];
  }).override {
    buildPhase = "make WITH_DYNAREC=${if stdenv.system == "x86_64-linux" then "x86_64" else "x86"}";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "cbc93b68dca1d72882d07b54bbe1ef25b980558a";
      sha256 = "0fl9r6jj2x9231md5zc4scra79j5hfn1n2z67scff1375xg1k64h";
    };
    description = "Fast MegaDrive/MegaCD/32X emulator";

    extraBuildInputs = [ libpng SDL ];
  }).override {
    patchPhase = "sed -i -e 's,SDL_CONFIG=\".*\",SDL_CONFIG=\"${SDL.dev}/bin/sdl-config\",' configure";
    configurePhase = "./configure";
  };

  ppsspp = (mkLibRetroCore rec {
    core = "ppsspp";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "5f7bcf7bfc15f83d405bcecd7a163a55ad1e7573";
      sha256 = "06k1gzmypz61dslynrw4b5i161rhj43y6wnr2nhbzvwcv5bw8w8r";
    };
    description = "ppsspp libretro port";
    extraBuildInputs = [ mesa ffmpeg ];
  }).override {
    buildPhase = "cd libretro && make";
  };

  prboom = (mkLibRetroCore rec {
    core = "prboom";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "4c690eb6b569a276c5b2a87680718f715477eae2";
      sha256 = "02vkl3y5dmyzifsviphspqv03a2rdyf36zpjpgfg7x0s226f56ja";
    };
    description = "Prboom libretro port";
  }).override {
    buildPhase = "make";
  };

  quicknes = (mkLibRetroCore rec {
    core = "quicknes";
    src = fetchRetro {
      repo = "QuickNES_Core";
      rev = "8613b48cee97f1472145bbafa76e543854b2bbd5";
      sha256 = "18lizdb9zjlfhh8ibvmcscldlf3mw4aj8nds3pah68cd2lw170w1";
    };
    description = "QuickNES libretro port";
  }).override {
    buildPhase = "make";
  };

  reicast = (mkLibRetroCore rec {
    core = "reicast";
    src = fetchRetro {
      repo = core + "-emulator";
      rev = "40d4e8af2dd67a3f317c14224873c8ec0e1f9d11";
      sha256 = "0d8wzpv7pcyh437gmvi439vim26wyrjmi5hj97wvyvggywjwrx8m";
    };
    description = "Reicast libretro port";
    extraBuildInputs = [ mesa ];
  }).override {
    buildPhase = "make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "de8d7e58caa23f071ce9d1bc5133f45d16c3ff1c";
      sha256 = "097i2dq3hw14hicsplrs36j1qa3r45vhzny5v4aw6qw4aj34hksy";
    };
    description = "Libretro port of ScummVM";
    extraBuildInputs = [ fluidsynth libjpeg libvorbis mesa SDL ];
  }).override {
    buildPhase = "cd backends/platform/libretro/build && make";
  };

  snes9x = (mkLibRetroCore rec {
    core = "snes9x";
    src = fetchRetro {
      repo = core;
      rev = "db4bfaba3b0d5a067fe9aea323503656837a8d9a";
      sha256 = "02f04ss45km32lp68diyfkix1gryx89qy8cc80189ipwnx80pgip";
    };
    description = "Port of SNES9x git to libretro";
  }).override {
    buildPhase = "cd libretro && make";
  };

  snes9x-next = (mkLibRetroCore rec {
    core = "snes9x-next";
    src = fetchRetro {
      repo = core;
      rev = "b2a69de0df1eb39ed362806f9c9633f4544272af";
      sha256 = "1vhgsrg9l562nincfvpj2h2dqkkblg1qmh0v47jqlqgmgl2b1zij";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
  }).override {
    buildPhase = ''
      make -f Makefile.libretro
      mv snes9x2010_libretro.so snes9x_next_libretro.so
    '';
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "bbe65db0e344dcb38905586bd853076b65963e5a";
      sha256 = "18r1yyfzvjq2hq04d94y37kzsq6aywh1aim69a3imk8kh46gwrh0";
    };
    description = "Port of Stella to libretro";
  }).override {
    buildPhase = "make";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "e7734756d228ea604f8fa872cea1bba987780791";
      sha256 = "03s4rh7dbbhbfc4pfdvr9jcbxrp4ijg8yp49s1xhr7sxsblj2vpv";
    };
    description = "VBA-M libretro port with modifications for speed";
  };

  vba-m = (mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "1b82fc2d761f027567632692f787482d1e287ec2";
      sha256 = "043djmqvh2grc25hwjw4b5kfx57b89ryp6fcl8v632sm35l3dd6z";
    };
    description = "vanilla VBA-M libretro port";
  }).override {
    buildPhase = "cd src/libretro && make";
  };

}
