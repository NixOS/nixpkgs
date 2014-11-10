{ stdenv, fetchgit, pkgconfig, makeWrapper, python27, retroarch
, fluidsynth, mesa, SDL, ffmpeg, libpng, libjpeg, libvorbis, zlib }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "20141109";
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
      homepage = "http://www.libretro.com/";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.edwtjo ];
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
      rev = "be95d71e0a7f9cd5f378b9a9793ef38a16d81f26";
      sha256 = "0s8fs42xa01c2qaznhnlvi4syafgyzrw8lzz8l5lipyrzrawj9dm";
    };
    description = "Port of 4DO/libfreedo to libretro";
  }).override {
    buildPhase = "make";
  };

  bsnes-mercury = (mkLibRetroCore rec {
    core = "bsnes-mercury";
    src = fetchRetro {
      repo = core;
      rev = "41e0425b5e13be15c46be847ea00c757f241ab58";
      sha256 = "0i6lvf6m702pam8jngg9arcysmwm6g4cv83n987h9c0ny3lf0n90";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
  }).override {
    buildPhase = "make && cd out";
  };

  desmume = (mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core;
      rev = "4aefde628b35cda78a2bdf47f2f0a565c0a386a0";
      sha256 = "0rkf4vdjlqj850b28drjm4w3vq0jj02ipsbfhpr23i79n4r2pi5a";
    };
    description = "libretro wrapper for desmume NDS emulator";
  }).override {
    configurePhase = "cd desmume";
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "1655de8b6ca8ad36287e04ac6179e6618521d41f";
      sha256 = "0v4kais1qhbc0nxaarc99cx3vnc5sgr2yp4ajh97wb90srsdkh46";
    };
    description = "FCEUmm libretro port";
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "586ea5e4a1bd61f3d209dfbf18bca66b1bbb92cc";
      sha256 = "0cqaqxirf5l1i4fwcdsjd7nnzb3xgfr5k9vdlj9y9k4viffd6drd";
    };
    description = "Port of Final Burn Alpha to libretro";
  }).override {
    buildPhase = ''
      cd svn-current/trunk \
      && make -f makefile.libretro \
      && mv fb_alpha_libretro.so fba_libretro.so
    '';
  };

  gambatte = (mkLibRetroCore rec {
    core = "gambatte";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "3283b2943a9164d3bb88bd62a20f74e33fffc058";
      sha256 = "0yl03zrb09n1w5ija38z7vi7vvaqdmy65v397g3bfm99rrl8g2kw";
    };
    description = "Gambatte libretro port";
  }).override {
    configurePhase = "cd libgambatte";
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "67d86709a279422f2c3c769ac910682df29397db";
      sha256 = "18m03yjakjg2hcasrjqyz54r55vrn8wwq768zhk6x8gdnnhqc1hy";
    };
    description = "Enhanced Genesis Plus libretro port";
  };

  mednafen-pce-fast = (mkLibRetroCore rec {
    core = "mednafen-pce-fast";
    src = fetchRetro {
      repo = "beetle-pce-fast-libretro";
      rev = "a26abf39887bb994f9b3e7645e46e6455e992729";
      sha256 = "0iws9fyw7m6wpr9vly66nzrfmiafrb96bnxidb1mdqgnldkwh8zi";
    };
    description = "Port of Mednafen's PC Engine core to libretro";
  }).override {
    buildPhase = "make";
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "fc97025211c82e4298034b9a7fe9f0a074c9eef7";
      sha256 = "04dq7rygfk47bix18a12cajb2k1k3absk5jmykcbg8znvcnlf4pi";
    };
    description = "Libretro port of Mupen64 Plus, GL only";

    extraBuildInputs = [ mesa ];
  }).override {
    buildPhase = "make WITH_DYNAREC=${if stdenv.system == "x86_64-linux" then "x86_64" else "x86"}";
  };

  nestopia = (mkLibRetroCore rec {
    core = "nestopia";
    src = fetchRetro {
      repo = core;
      rev = "d3d9ed1b3f8e32e8cbf90e72e8ed37d9fe1624c3";
      sha256 = "081dhxgr05m1warqga3fxmdnzyaa9c9bjw1b6glbsdgbl9iq4wq9";
    };
    description = "nestopia undead libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "54c1a1e8c284ede3e0da887ec4ce088f78f7fc30";
      sha256 = "0qd3daxgq5jdp46gff6ih65nnksil8j26v0wdf798mignknq4p44";
    };
    description = "Fast MegaDrive/MegaCD/32X emulator";

    extraBuildInputs = [ libpng SDL ];
  }).override {
    patchPhase = "sed -i -e 's,SDL_CONFIG=\".*\",SDL_CONFIG=\"${SDL}/bin/sdl-config\",' configure";
    configurePhase = "./configure";
  };

  prboom = (mkLibRetroCore rec {
    core = "prboom";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "5adbe263ce9771c8c5e007f94cfbb193979158ac";
      sha256 = "0yj8fy3ax52k9kmsf70g57dh889m80hjc3wqz9f3fp6xyxzpvz1j";
    };
    description = "Prboom libretro port";
  }).override {
    buildPhase = "make";
  };

  ppsspp = (mkLibRetroCore rec {
    core = "ppsspp";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "a4956befd41f388ebfc28ea555e0f9325b76c1d3";
      sha256 = "0v91i6257b7rpdlylcswcxfkan6knswb166ia5y4yr8pldc1kbj6";
    };
    description = "ppsspp libretro port";
    extraBuildInputs = [ mesa ffmpeg ];
  }).override {
    buildPhase = "cd libretro && make";
  };

  quicknes = (mkLibRetroCore rec {
    core = "quicknes";
    src = fetchRetro {
      repo = "QuickNES_Core";
      rev = "06f83f603c52ad8fae197beca6fdf241ed338dc3";
      sha256 = "065yy5jm0b43xdn0dswp06h2b11dzvbyrsyjvigrax5mjy5mi6wd";
    };
    description = "QuickNES libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "7dc8e24f1759dfca852014451dfca9103d8b1f04";
      sha256 = "12ya5g6d1bpsf332w5h49jjcxbr3dbjqiaddd3p7s6gzlyzzg1xf";
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
      rev = "e57447bbfd5daf62a00e1a31cfa400b419fe7963";
      sha256 = "06p7m8whazy9gih968f4nzdsp66n1fg6q3g2lbwwzj6izlli5cyg";
    };
    description = " Port of SNES9x git to libretro";
  }).override {
    buildPhase = "cd libretro && make";
  };

  snes9x-next = mkLibRetroCore rec {
    core = "snes9x-next";
    src = fetchRetro {
      repo = core;
      rev = "8fd34aeadf421c758702d820dedb58a4d10b01a2";
      sha256 = "0vwg6qkpdqzkb4cvk50czl5g69qg8n5s2fhi9rvaq383ngv6sdsh";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "31a455828e8f72c53283cb782e799ce54e4f1ee6";
      sha256 = "0ab7prnc2igbmzlh6gh7ln25c6767w4ypgskl1xsbn93k2dwzkpx";
    };
    description = "Port of Stella to libretro";
  }).override {
    buildPhase = "make";
  };

  vba-m = (mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "9b851867cffab8416edd89d8fe92bbad7f82810e";
      sha256 = "1n6wgxwcg7xm3vy0xigr1qbjkyxj5b2ih1pqpifjx83c47a9m9ka";
    };
    description = "vanilla VBA-M libretro port";
  }).override {
    buildPhase = "cd src/libretro && make";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "97a74706f57a9d01c02cb764b5140185308f80c8";
      sha256 = "0m80bd843pvagbggi5xxnwljaijl97lcqml76n62zx4rzx8256y7";
    };
    description = "VBA-M libretro port with modifications for speed";
  };
}
