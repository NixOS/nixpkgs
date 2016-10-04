{ stdenv, fetchgit, pkgconfig, makeWrapper, python27, retroarch
, alsaLib, fluidsynth, mesa, portaudio, SDL, ffmpeg, libpng, libjpeg
, libvorbis, zlib }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "2015-11-20";
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
      rev = "cbd700e2bb95f08f241ca24330fa732aa6af8018";
      sha256 = "1xp43hpd23rhj96pns13fz9mjp66gmxzl5frqa8q9fqcn2qkx7b1";
    };
    description = "Port of 4DO/libfreedo to libretro";
  }).override {
    buildPhase = "make";
  };

  bsnes-mercury = let bname = "bsnes-mercury"; in (mkLibRetroCore rec {
    core = bname + "-accuracy";
    src = fetchRetro {
      repo = bname;
      rev = "0bfe7f4f895af0927cec1c06dcae096b59416159";
      sha256 = "0dmaa1vy6nfj9jk6xkvrbbcxa9j3f3zrp24zflnqbizc088vncb9";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
  }).override {
    buildPhase = "make && cd out";
  };

  desmume = (mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core;
      rev = "cae5945149a72b1dc0b130d6e60e2690b88a925a";
      sha256 = "1qzlbw0vy87zi3w6hp5zj9dxdkj3qc9czjf41sj70irwyvqi0kii";
    };
    description = "libretro wrapper for desmume NDS emulator";
  }).override {
    configurePhase = "cd desmume";
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "b642e054a1f581fbac16c08f4b8df9ab6c474203";
      sha256 = "0jxbzjhpyw1fzipm2ai2nv62vb0q5cb203m093vakr1zdsx7si2n";
    };
    description = "Port of Final Burn Alpha to libretro";
  }).override {
    buildPhase = ''
      cd svn-current/trunk \
      && make -f makefile.libretro \
      && mv fb_alpha_libretro.so fba_libretro.so
    '';
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "eb19d48804ebeb381b20e74db7033c321f6b6d04";
      sha256 = "18wm6yzwshqfkd75kkcv035p1s2yhnchn98bcn9aj15aw5qyhvd4";
    };
    description = "FCEUmm libretro port";
  };

  gambatte = (mkLibRetroCore rec {
    core = "gambatte";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "59fb6a652e0de3c3a3b29e58af5ac035958da37e";
      sha256 = "0n2416lgqbzah1q3ji1hhpcdi9h29563gz739kf9libmnz86vd6f";
    };
    description = "Gambatte libretro port";
  }).override {
    configurePhase = "cd libgambatte";
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "7d8d5f1026af8cfd00cdf32c67a999bd1e454a09";
      sha256 = "16jm97h66bb2sqlimjlks31sapb23x4q8sr16wdqn1xgi670xw3c";
    };
    description = "Enhanced Genesis Plus libretro port";
  };

  mame = mkLibRetroCore {
    core = "mame";
    src = fetchRetro {
      repo = "mame";
      rev = "8da2303292bb8530f9f4ffad8bf1df95ee4cab74";
      sha256 = "0afsxsm1d4x9jn28qz6v47hhnp7q9i0yqk62i4lk4d7i7m4dq5j9";
    };
    description = "Port of MAME to libretro";

    extraBuildInputs = [ alsaLib portaudio python27 ];
  };

  mednafen-pce-fast = (mkLibRetroCore rec {
    core = "mednafen-pce-fast";
    src = fetchRetro {
      repo = "beetle-pce-fast-libretro";
      rev = "6e2eaf75da2eb3dfcf2fd64413f471c8c90cf885";
      sha256 = "0m946108wzawg0c4xvqpv6yzfmjngz6lji5hn4swgk0z5f2bj5a5";
    };
    description = "Port of Mednafen's PC Engine core to libretro";
  }).override {
    buildPhase = "make";
  };

  mednafen-psx = (mkLibRetroCore rec {
    core = "mednafen-psx";
    src = fetchRetro {
      repo = "beetle-psx-libretro";
      rev = "20c9b0eb0062b8768cc40aca0e2b2d626f1002a2";
      sha256 = "192xzvdbjjqlxrnxxn45hmrr6yjpxw3gapkbax6nhrabnxhva43k";
    };
    description = "Port of Mednafen's PSX Engine core to libretro";
  }).override {
    buildPhase = "make";
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "7db9296453629a44de806589f3ff64e824e775ad";
      sha256 = "075lpmwmj99yf9d9905x7apawd4bqz0whr37mh2fgr3jf730yiyl";
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
      rev = "dcaed965760669161d6fd44755887545ea393041";
      sha256 = "03fy5hb181ffx8sk9wmm415k084zqqhfqga4crgc7hdqi16s3r5v";
    };
    description = "nestopia undead libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "e912fdf26376bfa5d7d6488055fe6fdbd13c2e49";
      sha256 = "1mi36y8kx6s76cgygpj11zw35p44gd66mxygmxliz7k6xsd7ww41";
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
      rev = "ea17e27fcf16b9f875718b6550fe7145c6257c06";
      sha256 = "0w5njj5pamqc4a022hdplb7vapwkf34ad1w4acz3c8b05vkl457d";
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
      rev = "90ad0db331c53e8851581e1547b7377fb9fffe5b";
      sha256 = "0jk73nakrs9jxj3d0dmjs0csskjhddn8a4sky3mpk9vp30csx0ll";
    };
    description = "Prboom libretro port";
  }).override {
    buildPhase = "make";
  };

  quicknes = (mkLibRetroCore rec {
    core = "quicknes";
    src = fetchRetro {
      repo = "QuickNES_Core";
      rev = "518638b8064c9d0cb1b5aa29d96419f8528c9de5";
      sha256 = "0jv1z65m4j3hbfnb3chklh0dhwlc4gdqr0asswdsc1y4iwp0331c";
    };
    description = "QuickNES libretro port";
  }).override {
    buildPhase = "make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "c3e719acc08c1873609bab3578939b7c9e606511";
      sha256 = "03wvffy3h62qc7f3d8042wd234m8ikd843ggp903y285sgh54r9y";
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
      rev = "ccf1ee2eae73ed1e4044c8dd9536dd4ac1be6d8b";
      sha256 = "1bwjk817m8v69s13fc9kcj605ig6707rsj57wmz2ri2ggmydhvcb";
    };
    description = "Port of SNES9x git to libretro";
  }).override {
    buildPhase = "cd libretro && make";
  };

  snes9x-next = mkLibRetroCore rec {
    core = "snes9x-next";
    src = fetchRetro {
      repo = core;
      rev = "dfb7eef46d6bc2dbcc98f25e2bfadc9d2cff5cfd";
      sha256 = "0vdfjdwr6b5izh3gy63lcfnrdvr99qhlqfibjw4mmyqk9gkjrwm8";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "ada5c57d632ace0ba915ce7a470d504a5d89ebcc";
      sha256 = "090isch1l5hm07l22l8hja31cdiaxc0vgc3i01qs8zgdyvsx4vvg";
    };
    description = "Port of Stella to libretro";
  }).override {
    buildPhase = "make";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "0c20cd92bc8684340d7a1bcae14a603001ad5e4a";
      sha256 = "016vm2xyjfkkcqkqfw3n09if4bxxppk3g6p92waa9bv2ni4xli69";
    };
    description = "VBA-M libretro port with modifications for speed";
  };

  vba-m = (mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "bedddba614bc4fcbcf5b0d8565f94619b094c20c";
      sha256 = "1hvq4wsznb2vzg11iqmy5dnfjpiga368p1lmsx9d7ci7dcqyw7wy";
    };
    description = "vanilla VBA-M libretro port";
  }).override {
    buildPhase = "cd src/libretro && make";
  };

}
