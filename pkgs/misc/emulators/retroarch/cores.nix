{ stdenv, fetchgit, pkgconfig, makeWrapper, python27, retroarch
, fluidsynth, mesa, SDL, ffmpeg, libpng, libjpeg, libvorbis, zlib }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "20141009";
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
      rev = "700e5c2b28252ed7d3fb086ab016b3b964a5030a";
      sha256 = "0wxiapbp6i3r9ir75xgmah0jhrfvy9jgqr6i22grgmnga1qv5pcf";
    };
    description = "Port of 4DO/libfreedo to libretro";
  }).override {
    buildPhase = "make";
  };

  bsnes-mercury = (mkLibRetroCore rec {
    core = "bsnes-mercury";
    src = fetchRetro {
      repo = core;
      rev = "5fa7c035a604cd207c5833af0fdd55d7cf68acb0";
      sha256 = "19drxpspid0y3wi3zp3ls4jlhx1ndqmr51jici7w2vsajk9x9dyg";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
  }).override {
    buildPhase = "make && cd out";
  };

  desmume = (mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core;
      rev = "57bbabfe71fb8e131fa14ab1504f1959937b8ce5";
      sha256 = "19kbl361ggzhmmc5alsfwq9gcl0zc9zhz0nx562l6k2lj7fwwr0g";
    };
    description = "libretro wrapper for desmume NDS emulator";
  }).override {
    configurePhase = "cd desmume";
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "1b27f5abafa4ace43badebea82a8374be3a5a96b";
      sha256 = "04v0in7nazmkfsbvl0wn5klnz4f8rpjsar1v3c07j2qrma42k60w";
    };
    description = "FCEUmm libretro port";
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "21a78df085a0d964828c5c0940c03e656e2ad808";
      sha256 = "01ycszinral19ni22a3x8afiz23y9xw6idzx9a22xnc6zqvj0fjm";
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
      rev = "6f3c97d86483368ec446b6b08ae21b1cb644312c";
      sha256 = "19kbisbl5lqxfsaff4knp2rrl17af21c1kgccxhgp5liqnqk92k5";
    };
    description = "Gambatte libretro port";
  }).override {
    configurePhase = "cd libgambatte";
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "d634da83d29d39d293c1aba3c14f6259e13e525e";
      sha256 = "0mhn2h2wr2kh5rgda5rj7xkmg4b6glg4rnd0f1ak6rp3sh8dfhv1";
    };
    description = "Enhanced Genesis Plus libretro port";
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "021ab383e2ac44533e9babd3e7f5fed97a988225";
      sha256 = "13hph19b24bbp9d6s8zm4a939dhy96n2fbkcknmsp473kfnm9mf6";
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
      rev = "3468f3c16c80935e8c4078a5771e9379a981989c";
      sha256 = "1k9kd25z4hyna48gwxb8rkm9q402xzhw18wmgbzkf8y6zqxn50j0";
    };
    description = "nestopia undead libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "3f4b091194d29dd90a3cb88fd6520f677ffece65";
      sha256 = "0jb89g5xmq7nzx4gm1mam1hym20fcyzp95k9as0k2gnwxrd4ymxv";
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
      rev = "7c5e74a8f8a973278d46604f2816aae538e9cce7";
      sha256 = "1mkxc7zcyc2nj7spsrasbnz6k182g8i1snahbbwj4qi41db6cjc9";
    };
    description = "Prboom libretro port";
  }).override {
    buildPhase = "make";
  };

  ppsspp = (mkLibRetroCore rec {
    core = "ppsspp";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "af5050be6b421e08be42d4edf0015693ceba1f06";
      sha256 = "0h4crdq6n6npbv6sidp3bgz5g2z3ws6ikg37f0amshh3rj36p7q0";
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
      rev = "3e8935cc937d3bf64dc44b63cef5d584ec2673fa";
      sha256 = "003hrxkskrkqv5h39p4gd9mg2k3ki5l1cmm0kxq7c454yliljjxc";
    };
    description = "QuickNES libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "0a703f6546c5a0d8ef835aa624681f7877c36df6";
      sha256 = "1v1a6zvc1sjvvnvcarcmdym7qwyqyvl4b6ianjgzbpaxwmw457g0";
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
      rev = "0724786eb2ed1436946a2e2b42c77cddf8412a63";
      sha256 = "15wnq12mkfz766dzafhlmmh8a8b463ybssj84fhijj8c1x75scd1";
    };
    description = " Port of SNES9x git to libretro";
  }).override {
    buildPhase = "cd libretro && make";
  };

  snes9x-next = mkLibRetroCore rec {
    core = "snes9x-next";
    src = fetchRetro {
      repo = core;
      rev = "c701a1e4357bc80e46cae5bdfa0d359bcbce23ad";
      sha256 = "0410dj7rxcadvyghc1yqwqidn1g3scm52i3gb9d8haymg9q1zbjs";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "394ef8c10b8057fe3f92ff9d7c73886ae2eefec2";
      sha256 = "1a5m157fqpspi2zafmqhcd6864dvfpwh44d4n47ngswp6ii9bq0f";
    };
    description = "Port of Stella to libretro";
  }).override {
    buildPhase = "make";
  };

  vba-m = (mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "26a030ce01a6473d35bac2a6db4f0a360989d72f";
      sha256 = "065gljk2nijnjg2c2zbnpg25s5zam7x0z8lq7kbz9zb87sp73ha1";
    };
    description = "vanilla VBA-M libretro port";
  }).override {
    buildPhase = "cd src/libretro && make";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "136fe2020e941f27036754dd0524bfec750025dc";
      sha256 = "17bvx2wp2r5lkgffvqrirhgic1bfy39m7c1v74z245hg6z1jvqcf";
    };
    description = "VBA-M libretro port with modifications for speed";
  };
}