{ stdenv, fetchgit, pkgconfig, makeWrapper, python27, retroarch
, fluidsynth, mesa, SDL, ffmpeg, libpng, libjpeg, libvorbis, zlib }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "20141224";
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
      maintainers = [ maintainers.edwtjo maintainers.MP2E ];
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
      rev = "47fee1687d8946e84af2ef4d28a693f5f14199d3";
      sha256 = "0bhn761akcb5623yvbndm79pbfackbhaqcaqhrqwvk0ja13pry4l";
    };
    description = "Port of 4DO/libfreedo to libretro";
  }).override {
    buildPhase = "make";
  };

  bsnes-mercury = (mkLibRetroCore rec {
    core = "bsnes-mercury";
    src = fetchRetro {
      repo = core;
      rev = "6e08947a3eeee4c3ac0c33a5e6739cde02dbda3c";
      sha256 = "1dkbjhm99r26fagypqlgdrp6v4dhs554cspzp1maryl3nrr57wf8";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
  }).override {
    buildPhase = "make && cd out";
  };

  desmume = (mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core;
      rev = "362fee2cc242082d73cd0f7260554e202dd80d78";
      sha256 = "0n27kgjqam81q0cbmnmlq1dslyg9wbnz96r8pwjlbv7pp97rp7br";
    };
    description = "libretro wrapper for desmume NDS emulator";
  }).override {
    configurePhase = "cd desmume";
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "b10d6d4600bfe6b0f2d793785d19a46479a4e7ef";
      sha256 = "1nrs8hb5yb0iigz1nhzzamlmybjyhjcb41y07ckwx9kzx0w72sjz";
    };
    description = "FCEUmm libretro port";
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "55023b0466465f9d50ad82fd6f1549a89234bcab";
      sha256 = "147a9if99mnv12fp70r4h3171m95gzmiq6rlf9axf4693h6kzb02";
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
      rev = "6aa6a514b58671106352a525cbc9c39ce8633cdd";
      sha256 = "0ai0l8wwi61rsq4cm3h5n039s78xrhrxvxn4nbav1mn70ynzijx7";
    };
    description = "Gambatte libretro port";
  }).override {
    configurePhase = "cd libgambatte";
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "3b3eae18e742b99142ea2a412e80b9152933ab59";
      sha256 = "01mn2m1wg026wy1ffcv36wv0pvm18xnin27v681vd7bma96dl7p0";
    };
    description = "Enhanced Genesis Plus libretro port";
  };

  mednafen-pce-fast = (mkLibRetroCore rec {
    core = "mednafen-pce-fast";
    src = fetchRetro {
      repo = "beetle-pce-fast-libretro";
      rev = "0a389287025c0166e7b89bf0320ab1c6f8a5a561";
      sha256 = "1s8l3pddgw060wb177wx6ysa040k45wy5vlvbjjvq1rj3352izk4";
    };
    description = "Port of Mednafen's PC Engine core to libretro";
  }).override {
    buildPhase = "make";
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "b97ce52e49d255cd3e87fd6dc44ddd9a596d0be4";
      sha256 = "1disddd35c45ffp7irsgcf0y906f44d7rkjv96gxs6vvzwxifiih";
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
      rev = "3b030c93edcc8f49e2f6323b1df7fc78759accd8";
      sha256 = "0gr4s6p40j5qiyg94kpa8v3083cbp2ccdq5zp6kkpjskxzkdfhqg";
    };
    description = "nestopia undead libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "2babf3518e258cc3d6649f6e34a267e83dffd7d9";
      sha256 = "13l9ppr8v33a7jmgjpg9hqwim30mybscnwqj2bch5v0w6h3qynzh";
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
      rev = "437fd00bf58158bf3c5e2e49237d9344f320584a";
      sha256 = "0g9dvmywph5r8ly20bn3xkm12271n726s5g9z0f2pd75pnv13q86";
    };
    description = "Prboom libretro port";
  }).override {
    buildPhase = "make";
  };

  ppsspp = (mkLibRetroCore rec {
    core = "ppsspp";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "b82a36232f677f48e95d6f284184cb8c935d4ad2";
      sha256 = "0bzqs9v37qyh6dl5jsrmm46iwy04h7ypgnibxajrxg1795ccb3rr";
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
      rev = "0dab65e2a962640c517f23f2668b76315faf977e";
      sha256 = "12cv2ph72y6c0clcqssdyma1jxn8yi7x2ifyf2g77rbaswxr26r4";
    };
    description = "QuickNES libretro port";
  }).override {
    buildPhase = "cd libretro && make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "bf30f7a146ab3d0ea5bcff43b1db489118b78cdf";
      sha256 = "1xgl2vsssa5mxhavcyghxrbab4lfbp9gnpy6ckhrxdd0n08kvyys";
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
      rev = "e41b0a2832fdcacc30498f23ddadd193376f837f";
      sha256 = "0k9zxc9g6hhkc18mdgskjp99ljgay8jqmqhir4aahsfqyxhwypgm";
    };
    description = " Port of SNES9x git to libretro";
  }).override {
    buildPhase = "cd libretro && make";
  };

  snes9x-next = mkLibRetroCore rec {
    core = "snes9x-next";
    src = fetchRetro {
      repo = core;
      rev = "c04566c04b1f07979f8a8f6d5bbcb844d7594aec";
      sha256 = "0lmrbmjk7qnkgz7n7dm744nps8zgbv76kz62vcja2kl5bq24kaxc";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "4c8e93ce4b250b3b2d2743bae48eca25983f29db";
      sha256 = "1r016r9a0vwdnlms9s9hnzvszvkhpshjiyi2zql0zs2c1jbja6ia";
    };
    description = "Port of Stella to libretro";
  }).override {
    buildPhase = "make";
  };

  vba-m = (mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "9baba21956add58fba7c411ddd752682f0d93270";
      sha256 = "1dxshbkgv7xjg3lzv9lwsyhgxjmxzfsvd6xpwmdmh3pjllfrgy1p";
    };
    description = "vanilla VBA-M libretro port";
  }).override {
    buildPhase = "cd src/libretro && make";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "54c37ea9e26c5480352eee92a80eb659c9b5cb39";
      sha256 = "0hkd1n00i3kwr5ids7b2c034xvx3nskg2316nli99ky511yq5cfd";
    };
    description = "VBA-M libretro port with modifications for speed";
  };
}
