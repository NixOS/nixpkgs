{ stdenv, fetchgit, pkgconfig, makeWrapper, python27
, retroarch, fluidsynth, mesa, SDL, libav, libpng, libjpeg, libvorbis
, zlib }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "20140902";
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

    passthru.libretroCore = "/lib/retroarch/cores";

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
      rev = "961812bc421f3fbfd83ea211783bb511a0b6d31c";
      sha256 = "0217iq8sj8gn161c3mj632csl1da8ir2ffxxdillpcddv6ppsayl";
    };
    description = "Port of 4DO/libfreedo to libretro";
  }).override {
    buildPhase = "make";
  };

  bsnes-mercury = (mkLibRetroCore rec {
    core = "bsnes-mercury";
    src = fetchRetro {
      repo = core;
      rev = "cc44e91bfba6f7b3d1d3d51a9fa28b39a579f5e0";
      sha256 = "0nzwjrbfvzywsimrvp4vbpj7zxf9iwpghd9z7f9f1q027l0vj42f";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
  }).override {
    buildPhase = "make && cd out";
  };

  desmume = mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "1dd58e4a9fa375b6909cd8718165a429d4b8bd6d";
      sha256 = "137bw9316qxm8s6p0bzyvk39dv5b5bn60fgllmyj9z5y8x5lrc9l";
    };
    description = "libretro wrapper for desmume NDS emulator";
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "17e081541c9d36d0658e7139afa5b085aa0316c9";
      sha256 = "0cn74z976rgjh7hf0yb1sdjlm347157893s2z397rgjvks8xssb0";
    };
    description = "FCEUmm libretro port";
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "da6355526a9b02a642447994414baababe904c1e";
      sha256 = "14kba506m9dnldmkpq3vgw416pm7cgc167hgm3f0l59ylp2592ff";
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
      rev = "267a4e09bf8f0877483abdffde6295f29d7235ee";
      sha256 = "1swx3mjb6qmlg6grcakhl17vrmy4vdvimxkv5gbv6gnj5riya4vl";
    };
    description = "Gambatte libretro port";
  }).override {
    configurePhase = "cd libgambatte";
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "c0015e27e3ae607ea0490b2accfe31097ef3cbce";
      sha256 = "1k4b5wib7nqzk53qwvhkh4a70gc4pq7vkrpvmfzp5f2c4vrbw1i7";
    };
    description = "Enhanced Genesis Plus libretro port";
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "2251b3aba2a5bb233ff49dd9b6472f2c0feb9b83";
      sha256 = "04g93kj6n5vddbzfb30d8n711kg0yxfnl5v567aa854misn6gfxd";
    };
    description = "Libretro port of Mupen64 Plus, GL only";

    extraBuildInputs = [ mesa ];
  }).override {
    buildPhase = "make WITH_DYNAREC=${if stdenv.system == "x86_64-linux" then "x86_64" else "x86"}";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "d84817550ac064fbba7ee718fb3baeda7d5546da";
      sha256 = "17zh9m2v7h1cifzz8dcwqm4wn94zyhz6g85gf0aw6xylxahza627";
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
      rev = "de2f0a0fab1a73a28cd501fdb9291ffc7dc357f5";
      sha256 = "01gxa6hh9vijic2n44q1lndhdyw0kdpmajabs0nizn7bni51b29c";
    };
    description = "Prboom libretro port";
  }).override {
    buildPhase = "make";
  };

  ppsspp = (mkLibRetroCore rec {
    core = "ppsspp";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "6ee828171218b26e124c5e8fa7877e6ee1d5ff79";
      sha256 = "1559d4k3h0a2dv3684j4w924p2dg8z2j1fwhy7w9mhb5z4kddjhk";
    };
    description = "ppsspp libretro port";

    extraBuildInputs = [ mesa libav ];
  }).override{
    buildPhase = "cd libretro && make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "c00247171ba8201614e85556c638b8825dc9f225";
      sha256 = "1wir3x928b37va6gn14bmwsydkpk4afma5hppmbivw4qp8mj25pa";
    };
    description = "Libretro port of ScummVM";

    extraBuildInputs = [ fluidsynth libjpeg libvorbis mesa SDL ];
  }).override {
    buildPhase = "cd backends/platform/libretro/build/;make";
  };

  snes9x-next = mkLibRetroCore rec {
    core = "snes9x-next";
    src = fetchRetro {
      repo = core;
      rev = "461d92be09e1857d215f51aeea448a8e180bbfdd";
      sha256 = "0ci453qsyrv3brmy2szngis2xyvxilcv9yhc2qjz285mirg6fj57";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "c7ee7ca7e8a29c986f49306c75832972f5749f72";
      sha256 = "15wy9h3a2qk66lh8x40b3a9il0zkdflqil1h51zjmhq2zzsq8p95";
    };
    description = "Port of Stella to libretro";
  }).override {
    buildPhase = "make";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "fb095107f83df5f93b8ba4833eaf43901f42c0c0";
      sha256 = "0fvq1dfll27vjbmyh4qsp2nw166jsd91sjmf1sl84z56ab3q3iw8";
    };
    description = "VBA-M libretro port";
  };

}