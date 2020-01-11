{ stdenv, fetchgit, fetchFromGitHub, fetchFromGitLab, cmake, pkgconfig, makeWrapper, python27, python37, retroarch
, alsaLib, fluidsynth, curl, hidapi, libGLU, gettext, glib, gtk2, portaudio, SDL, libGL
, ffmpeg, pcre, libevdev, libpng, libjpeg, udev, libvorbis
, miniupnpc, sfml, xorg, zlib, nasm, libpcap, boost }:

let

  d2u = stdenv.lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = ({ core, src, description, license, broken ? false, ... }@a:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {

    name = "libretro-${core}-${version}";
    version = "2019-09-29";
    inherit src;

    buildInputs = [ makeWrapper retroarch zlib ] ++ a.extraBuildInputs or [];

    makefile = "Makefile.libretro";

    installPhase = ''
      COREDIR="$out/lib/retroarch/cores"
      mkdir -p $out/bin
      mkdir -p $COREDIR
      mv ${d2u core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary} $COREDIR/.
      makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch-${core} \
        --add-flags "-L $COREDIR/${d2u core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary} $@"
    '';

    enableParallelBuilding = true;

    passthru = {
      core = core;
      libretroCore = "/lib/retroarch/cores";
    };

    meta = with stdenv.lib; {
      inherit description;
      homepage = https://www.libretro.com/;
      inherit license;
      maintainers = with maintainers; [ edwtjo hrdinka MP2E ];
      platforms = platforms.unix;
    };
  } // a);

  fetchRetro = { repo, rev, sha256 }:
  fetchgit {
    inherit rev sha256;
    url = "https://github.com/libretro/${repo}.git";
    fetchSubmodules = true;
  };

in with stdenv.lib.licenses;

{

  _4do = (mkLibRetroCore rec {
    core = "4do";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "b6ad4bc8548f2f3792cd929ccf26d9078b73a1c0";
      sha256 = "0j2bd9cnnd5k99l9qr4wd5q9b4ciplia6ywp90xg6422s1im2iw0";
    };
    description = "Port of 4DO/libfreedo to libretro";
    license = "Non-commercial";
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  atari800 = (mkLibRetroCore rec {
    core = "atari800";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "efc0bc71e3cb8a4f957d07fe808cc002ed9c13b9";
      sha256 = "150hmazi4p5p18gpjmkrn1k9j719cd9gy7jn0jiy3jbk2cxxsjn6";
    };
    description = "Port of Atari800 to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-snes = (mkLibRetroCore rec {
    core = "mednafen-snes";
    src = fetchRetro {
      repo = "beetle-bsnes-libretro";
      rev = "6aee84d454570bb17dff5975df28febdbcb72938";
      sha256 = "0nk9xlypg3jhpbwd9z5bjbgzlkz842hy9rq14k1nwn0qz6d88kld";
    };
    description = "Port of Mednafen's SNES core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-gba = (mkLibRetroCore rec {
    core = "mednafen-gba";
    src = fetchRetro {
      repo = "beetle-gba-libretro";
      rev = "135afdbb9591655a3e016b75abba07e481f6d406";
      sha256 = "0fc0x24qn4y7pz3mp1mm1ain31aj9pznp1irr0k7hvazyklzy9g3";
    };
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-lynx = (mkLibRetroCore rec {
    core = "mednafen-lynx";
    src = fetchRetro {
      repo = "beetle-lynx-libretro";
      rev = "928f7cf5b39f0363e55667572ff455e37489998e";
      sha256 = "0f03wzdr6f0fpy889i9a2834jg5lvcriyl98pajp75m7whm9r9cc";
    };
    description = "Port of Mednafen's Lynx core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-ngp = (mkLibRetroCore rec {
    core = "mednafen-ngp";
    src = fetchRetro {
      repo = "beetle-ngp-libretro";
      rev = "6130e4057c3d8f9172f0c49bb9b6c61bd1a572d5";
      sha256 = "10k7spjrhggjgzb370bwv7fgk0nb6xri9ym6cm4qvnrkcwxm7i9p";
    };
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-pce-fast = let der = (mkLibRetroCore {
    core = "mednafen-pce-fast";
    src = fetchRetro {
      repo = "beetle-pce-fast-libretro";
      rev = "7bbbdf111c1ce52ab4a97e911ebdaa6836ee881a";
      sha256 = "1p0kk5a2yi05yl0hspzv9q0n96yx9riaaacbmnq76li0i3ihkf6l";
    };
    description = "Port of Mednafen's PC Engine core to libretro";
    license = gpl2;
  }); in der.override {
    makefile = "Makefile";
    buildPhase = "make";
    name = "beetle-pce-fast-${der.version}";
  };

  beetle-pcfx = (mkLibRetroCore rec {
    core = "mednafen-pcfx";
    src = fetchRetro {
      repo = "beetle-pcfx-libretro";
      rev = "e04f695202a7295e4b6f2122ae947279ac9df007";
      sha256 = "0pdlz05pjqxp19da13dr3wd20hgxw8z5swhflyf7ksjgvz5rxb4r";
    };
    description = "Port of Mednafen's PCFX core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-psx = let der = (mkLibRetroCore {
    core = "mednafen-psx";
    src = fetchRetro {
      repo = "beetle-psx-libretro";
      rev = "f55db8655408104a6e20af667657423f08566c85";
      sha256 = "17iz8r2wy8zqh63j78ijwxasdnmg8dh9mmqn1qr4hvf4fj53ckk8";
    };
    description = "Port of Mednafen's PSX Engine core to libretro";
    license = gpl2;
  }); in der.override {
    makefile = "Makefile";
    buildPhase = "make";
    name = "beetle-psx-${der.version}";
  };

  beetle-saturn = let der = (mkLibRetroCore {
    core = "mednafen-saturn";
    src = fetchRetro {
      repo = "beetle-saturn-libretro";
      rev = "3313cc6760c14cffa9226e0cfd41debc11df8bdd";
      sha256 = "1z2zfn5cpsr3x6bvr562vqvmp4pjjhv5a6jcp09gfsy2gkyispr2";
    };
    description = "Port of Mednafen's Saturn core to libretro";
    license = gpl2;
  }); in der.override {
    makefile = "Makefile";
    buildPhase = "make";
    name = "beetle-saturn-${der.version}";
    meta.platforms = [ "x86_64-linux" "aarch64-linux" ];
  };

  beetle-supergrafx = (mkLibRetroCore rec {
    core = "mednafen-supergrafx";
    src = fetchRetro {
      repo = "beetle-supergrafx-libretro";
      rev = "857e41146e3b0a51def3baea49d2eec80f18102b";
      sha256 = "0r3v4qy4rx4mnr7w4s779f6f2bjyp69m42blimacl1l9f6hmcv5h";
    };
    description = "Port of Mednafen's SuperGrafx core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-wswan = (mkLibRetroCore rec {
    core = "mednafen-wswan";
    src = fetchRetro {
      repo = "beetle-wswan-libretro";
      rev = "925cb8c77af1678ceab24f04c2790cb95389def1";
      sha256 = "0kqsqn655z6nnr2s1xdbf37ds99gyhqfd7dx0wmx3sy1fshjg5wm";
    };
    description = "Port of Mednafen's WonderSwan core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  beetle-vb = (mkLibRetroCore rec {
    core = "mednafen-vb";
    src = fetchRetro {
      repo = "beetle-vb-libretro";
      rev = "9066cdafa29ac054243a679baded49212661f47b";
      sha256 = "0gsniz5kk4xdiprcfyqjcss2vkrphi48wbr29gqvpf7l8gpnwx8p";
    };
    description = "Port of Mednafen's VirtualBoy core to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  bluemsx = (mkLibRetroCore rec {
    core = "bluemsx";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "ddd89ff1fa534816e48521bd930b721f2d39975a";
      sha256 = "0hiqhc1ckj3ydy0q1v8hwjkkyh2564f7wlqypmshjcc47n296xyf";
    };
    description = "Port of BlueMSX to libretro";
    license = gpl2;
  }).override {
    buildPhase = "make";
  };

  bsnes-mercury = let bname = "bsnes-mercury"; in (mkLibRetroCore {
    core = bname + "-accuracy";
    src = fetchRetro {
      repo = bname;
      rev = "4a382621da58ae6da850f1bb003ace8b5f67968c";
      sha256 = "0z8psz24nx8497vpk2wya9vs451rzzw915lkw3qiq9bzlzg9r2wv";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
    license = gpl3;
  }).override {
    makefile = "Makefile";
    buildPhase = "make && cd out";
  };

  desmume = (mkLibRetroCore rec {
    core = "desmume";
    src = fetchRetro {
      repo = core;
      rev = "e8cf461f83eebb195f09e70090f57b07d1bcdd9f";
      sha256 = "0rc8s5226wn39jqs5yxi30jc1snc0p106sfym7kgi98hy5na8yab";
    };
    description = "libretro wrapper for desmume NDS emulator";
    license = gpl2;
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
  }).override {
    makefile = "desmume/src/frontend/libretro/Makefile.libretro";
    configurePhase = "cd desmume/src/frontend/libretro";
    buildPhase = "make";
  };

  desmume2015 = (mkLibRetroCore rec {
    core = "desmume2015";
    src = fetchRetro {
      repo = core;
      rev = "c27bb71aa28250f6da1576e069b4b8cc61986beb";
      sha256 = "1m7g1wwpnnprmki3rixknggjmxbp7d4hwxgkqr041shmrm0rhafd";
    };
    description = "libretro wrapper for desmume NDS emulator from 2015";
    license = gpl2;
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
  }).override {
    makefile = "desmume/Makefile.libretro";
    configurePhase = "cd desmume";
    buildPhase = "make";
  };

  dolphin = (mkLibRetroCore {
    core = "dolphin";
    src = fetchRetro {
      repo = "dolphin";
      rev = "11a7ed402c7178da1d9d57c6e5e5a05a4dc6a2c8";
      sha256 = "11jrcczkbyns01rvxb5rd22fbkbfn2h81f6pfxbhi13fl4ljim9x";
    };
    description = "Port of Dolphin to libretro";
    license = gpl2Plus;
    broken = true;

    extraBuildInputs = [
      cmake curl libGLU libGL pcre pkgconfig sfml
      gettext hidapi
      libevdev udev
    ] ++ (with xorg; [ libSM libX11 libXi libpthreadstubs libxcb xcbutil libXext libXrandr libXinerama libXxf86vm ]);
  }).override {
    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLIBRETRO=ON"
      "-DLIBRETRO_STATIC=1"
      "-DENABLE_QT=OFF"
      "-DENABLE_LTO=OFF"
      "-DUSE_UPNP=OFF"
      "-DUSE_DISCORD_PRESENCE=OFF"
    ];
    dontUseCmakeBuildDir = "yes";
    buildPhase = "make";
  };

  dosbox = (mkLibRetroCore rec {
    core = "dosbox";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "e4ed503b14ed59d5d745396ef1cc7d52cf912328";
      sha256 = "13bx0ln9hwn6hy4sv0ivqmjgjbfq8svx15dsa24hwd8lkf0kakl4";
    };
    description = "Port of DOSBox to libretro";
    license = gpl2;
  }).override {
    buildPhase = "make";
  };

  fba = (mkLibRetroCore rec {
    core = "fba";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "89245384c7d181e286d6f34995253419f946becb";
      sha256 = "1pg351qhbq5x8qmaq6c30v8ynic8jv3gbxy2kq5iknka80g1lkck";
    };
    description = "Port of Final Burn Alpha to libretro";
    license = "Non-commercial";
  }).override {
    makefile = "svn-current/trunk/makefile.libretro";
    buildPhase = ''
      cd svn-current/trunk \
      && make -f makefile.libretro \
      && mv fbalpha2012_libretro${stdenv.hostPlatform.extensions.sharedLibrary} fba_libretro${stdenv.hostPlatform.extensions.sharedLibrary}
    '';
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "0e315e0ca0093ebda06a97835cec6ad4af81db7a";
      sha256 = "12bvvxmvafjvrvwxl5gzr583g48s0isx2fgvjgkrx175vk2amaf4";
    };
    description = "FCEUmm libretro port";
    license = gpl2;
  };

  flycast = (mkLibRetroCore rec {
    core = "flycast";
    src = fetchRetro {
      repo = core;
      rev = "45a15205dfc05cfc4df2488cad7c2b4988c5aa0f";
      sha256 = "18glxd57kddq6p2bwq0qknyq6bv8dxklqks4w2jy2yccvwxdxy2i";
    };
    description = "Flycast libretro port";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  gambatte = mkLibRetroCore rec {
    core = "gambatte";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "4d9ad7b29946ec0a914b2d6a735b6c2704ed1f23";
      sha256 = "156pvvlch5izbgbw4ddxhiwgzpp52irr3nqaz813i5f02fiq5wya";
    };
    description = "Gambatte libretro port";
    license = gpl2;
  };

  genesis-plus-gx = mkLibRetroCore {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "0e4357bd64533d7fd93b5f01620b92595025fab5";
      sha256 = "1nryy00844h3ra97j40g38lj7036ibm2l8002qid7r5r9kggclqx";
    };
    description = "Enhanced Genesis Plus libretro port";
    license = "Non-commercial";
  };

  gpsp = (mkLibRetroCore rec {
    core = "gpsp";
    src = fetchRetro {
      repo = core;
      rev = "24af89596e6484ff5a7a08efecfa8288cfbc02f3";
      sha256 = "1jc5i70cab5f23yc9sfv8iyvmwmc4sb33f413il2vlhsfdxklyk7";
    };
    description = "Port of gpSP to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  handy = (mkLibRetroCore rec {
    core = "handy";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "6b19a4fad1b394f6a1351c88f60991d4878ff05b";
      sha256 = "0lhkrwh3rirdidxb8kfcg8wk9gjsc7g6qpkv74h6f09rb4y75w1y";
    };
    description = "Port of Handy to libretro";
    license = "Handy-License";
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  hatari = (mkLibRetroCore rec {
    core = "hatari";
    src = fetchRetro {
      repo = core;
      rev = "ec1b59c4b6c7ca7d0d23d60cfe2cb61911b11173";
      sha256 = "1pm821s2cz93xr7qx7dv0imr44bi4pvdvlnjl486p83vff9yawfg";
    };
    description = "Port of Hatari to libretro";
    license = gpl2;
    extraBuildInputs = [ cmake SDL ];
  }).override {
    makefile = "Makefile.libretro";
    buildPhase = "make";
  };

  higan-sfc = (mkLibRetroCore {
    core = "higan-sfc";
    src = fetchFromGitLab {
      owner = "higan";
      repo = "higan";
      rev = "d3f592013a27cb78f17d84f90a6be6cf6f6af1d1";
      sha256 = "19d4cbwg8d085xq5lmql4v5l4ckgwqzc59ha5yfgv3w4qfp4dmij";
    };
    description = "Accurate SNES / Super Famicom emulator";
    license = gpl3;
    broken = true;

  }).override {
    makefile = "GNUmakefile";
    buildPhase = "cd higan && make compiler=g++ target=libretro binary=library && cd out";
  };

  mame = (mkLibRetroCore {
    core = "mame";
    src = fetchRetro {
      repo = "mame";
      rev = "f4aac49f3d56fbd653628ac456c23ac9a6b857ae";
      sha256 = "1pjpnwdj73319hgcjhganzrcz2zn4fnjydah989haqh3id5j3zam";
    };
    description = "Port of MAME to libretro";
    license = gpl2Plus;

    extraBuildInputs = [ alsaLib libGLU libGL portaudio python27 xorg.libX11 ];
  }).override {
    postPatch = ''
      # Prevent the failure during the parallel building of:
      # make -C 3rdparty/genie/build/gmake.linux -f genie.make obj/Release/src/host/lua-5.3.0/src/lgc.o
      mkdir -p 3rdparty/genie/build/gmake.linux/obj/Release/src/host/lua-5.3.0/src
    '';
    buildPhase = "make -f Makefile.libretro";
  };

  mame2000 = (mkLibRetroCore rec {
    core = "mame2000";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "0a8a174f5e755cdd476895207003c5d07cfa6af2";
      sha256 = "03k0cfgd4wfl31dv5xb6xjd4h7sh0k0qw6wbspwi0lgswmhz97bb";
    };
    description = "Port of MAME ~2000 to libretro";
    license = gpl2Plus;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  mame2003 = (mkLibRetroCore rec {
    core = "mame2003";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "170d5b6490953d40edc39defe69945d005f8ec03";
      sha256 = "0slsf59sn5lijr1mrx5ffc9z81ra1wcw7810mb52djqyvm15r9zl";
    };
    description = "Port of MAME ~2003 to libretro";
    license = gpl2Plus;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  mame2003-plus = (mkLibRetroCore rec {
    core = "mame2003-plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "d9a56a3af908ae9100b4c9feebff4b918363f241";
      sha256 = "1c16chfs4b2j1x1bmrklh8ssqki850k787qwq7b95dyxksj2bpx1";
    };
    description = "Port of MAME ~2003+ to libretro";
    license = gpl2Plus;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  mame2010 = (mkLibRetroCore rec {
    core = "mame2010";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "4ced2c31f1100eefc7f4483b474b8a680a3b3f2b";
      sha256 = "1a8ijj0sixr6xrqfgimna0ipfj2bb2kvj4mb45hb8a18mwn6y0mc";
    };
    description = "Port of MAME ~2010 to libretro";
    license = gpl2Plus;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  mame2015 = (mkLibRetroCore rec {
    core = "mame2015";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "e3a28398f54cd6b2c24b7165d215b046b79c10f5";
      sha256 = "1fgwi37zgp2s92bkz03gch3ivgyjgdi3xycrd8z7x87gi20a79x9";
    };
    description = "Port of MAME ~2015 to libretro";
    license = gpl2Plus;
    extraBuildInputs = [ python27 alsaLib ];
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  mame2016 = (mkLibRetroCore rec {
    core = "mame2016";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "ea4c1ffa75eb3fb0096158b71706b8b84d86d12c";
      sha256 = "1qyvdymmjv5q0k3najgfdxzf1yr6bnysnsl19v753yj29xs4hwzp";
    };
    description = "Port of MAME ~2016 to libretro";
    license = gpl2Plus;
    extraBuildInputs = [ python27 alsaLib ];
  }).override {
    postPatch = ''
      # Prevent the failure during the parallel building of:
      # make -C 3rdparty/genie/build/gmake.linux -f genie.make obj/Release/src/host/lua-5.3.0/src/lgc.o
      mkdir -p 3rdparty/genie/build/gmake.linux/obj/Release/src/host/lua-5.3.0/src
    '';
    buildPhase = "make -f Makefile.libretro";
  };

  mesen = (mkLibRetroCore rec {
    core = "mesen";
    src = fetchFromGitHub {
      owner = "SourMesen";
      repo = core;
      rev = "942633dd3dbb73cc3abd748f6d5440c78abbea09";
      sha256 = "0a95wd64vnblksacapxwxla9j2iw8a5hbdm111cldrni12q87iq2";
    };
    description = "Port of Mesen to libretro";
    license = gpl3;
  }).override {
    makefile = "Libretro/Makefile";
    buildPhase = "cd Libretro && make";
  };

  mgba = mkLibRetroCore rec {
    core = "mgba";
    src = fetchRetro {
      repo = core;
      rev = "4865aaabc2a46c635f218f7b51f8fc5cc2c4c8ac";
      sha256 = "1mdzwcsl5bafmgqfh0a1bgfgilisffxsygcby0igsq2bgkal47mm";
    };
    description = "Port of mGBA to libretro";
    license = mpl20;
  };

  mupen64plus = (mkLibRetroCore rec {
    core = "mupen64plus-next";
    src = fetchRetro {
      repo = "mupen64plus-libretro-nx"; # + "-libretro-nx";
      rev = "f77c16f9f1dd911fd2254becc8a28adcdafe8aa1";
      sha256 = "0j6vrkwch9lwmlhyz7fp1ha0bby54gvbwk91hwbv35f6dvs0aw0d";
    };
    description = "Libretro port of Mupen64 Plus, GL only";
    license = gpl2;

    extraBuildInputs = [ libGLU libGL libpng nasm xorg.libX11 ];
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  nestopia = (mkLibRetroCore rec {
    core = "nestopia";
    src = fetchRetro {
      repo = core;
      rev = "7f48c211c281880d122981da119a4455a9bebbde";
      sha256 = "05p3a559633dzw222rs1fh48v657mdyirl1qfqzkhqiar9rxf31g";
    };
    description = "nestopia undead libretro port";
    license = gpl2;
  }).override {
    makefile = "libretro/Makefile";
    buildPhase = "cd libretro && make";
  };

  o2em = (mkLibRetroCore rec {
    core = "o2em";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "d6731b9b2592654ce4f1b64c1b1da17b32e7c94c";
      sha256 = "0809qw16y7ablxfayf0lbzvq7wqdmjp0afdb0vcgv193vvhhp58q";
    };
    description = "Port of O2EM to libretro";
    license = artistic1;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  parallel-n64 = (mkLibRetroCore rec {
    core = "parallel-n64";
    src = fetchRetro {
      repo = core;
      rev = "30f4fd3c2456145763eb76aead7485a1b86ba6bd";
      sha256 = "0kbyzmscmfi6f842clzaff4k6xcb5410fwhv8n6vv42xk6ljfvgh";
    };
    description = "Parallel Mupen64plus rewrite for libretro.";
    license = gpl2;

    extraBuildInputs = [ libGLU libGL libpng ];
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  pcsx_rearmed = (mkLibRetroCore rec {
    core = "pcsx_rearmed";
    src = fetchRetro {
      repo = core;
      rev = "eb6943ee04b0f30a6f1cebfe399a94bacd1dfb45";
      sha256 = "0xikdirvjal4mdr5y9dl9gcxhdilqzq43f909b0z8vc069vj1wjz";
    };
    description = "Port of PCSX ReARMed to libretro";
    license = gpl2;
  }).override {
    configurePhase = "rm configure";
    buildPhase = "make -f Makefile.libretro";
  };

  picodrive = (mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "28dcfd6f43434e6828ee647223a0576bfe858c24";
      sha256 = "19a1b6q8fhf7wxzyf690va1ixzlxlzyslv1zxm0ll5pfsqf2y3gx";
    };
    description = "Fast MegaDrive/MegaCD/32X emulator";
    license = "MAME";

    extraBuildInputs = [ libpng SDL ];
  }).override {
    patchPhase = "sed -i -e 's,SDL_CONFIG=\".*\",SDL_CONFIG=\"${SDL.dev}/bin/sdl-config\",' configure";
    configurePhase = "./configure";
  };

  play = (mkLibRetroCore rec {
    core = "play";
    src = fetchRetro {
      repo = "play-";
      rev = "fedc1e1c2918a7490a881cdb4ec951a828c19671";
      sha256 = "0hwxx7h61gd29a2gagwjbvxk2hgwdk1wxg4nx90zrizb8nczwnl6";
    };
    description = "Port of Play! to libretro";
    license = bsd2;
    extraBuildInputs = [ cmake boost ];
  }).override {
    cmakeFlags = [ "-DBUILD_PLAY=OFF -DBUILD_LIBRETRO_CORE=ON" ];
    buildPhase = "make";
  };

  ppsspp = (mkLibRetroCore rec {
    core = "ppsspp";
    src = fetchgit {
      url = "https://github.com/hrydgard/ppsspp";
      rev = "bf1777f7d3702e6a0f71c7ec1fc51976e23c2327";
      sha256 = "17sym0vk72lzbh9a1501mhw98c78x1gq7k1fpy69nvvb119j37wa";
    };
    description = "ppsspp libretro port";
    license = gpl2;
    extraBuildInputs = [ cmake libGLU libGL ffmpeg python37 xorg.libX11 ];
  }).override {
    cmakeFlags = [ "-DLIBRETRO=ON" ];
    makefile = "Makefile";
    buildPhase = ''
      make \
      && mv lib/ppsspp_libretro${stdenv.hostPlatform.extensions.sharedLibrary} ppsspp_libretro${stdenv.hostPlatform.extensions.sharedLibrary}
    '';
  };

  prboom = (mkLibRetroCore rec {
    core = "prboom";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "4c690eb6b569a276c5b2a87680718f715477eae2";
      sha256 = "02vkl3y5dmyzifsviphspqv03a2rdyf36zpjpgfg7x0s226f56ja";
    };
    description = "Prboom libretro port";
    license = gpl2;
  }).override {
    buildPhase = "make";
  };

  prosystem = (mkLibRetroCore rec {
    core = "prosystem";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "cb4aa3ee72f98b0891a7bac5c9dac458cdba4d34";
      sha256 = "0yvzmks9zz1hf7mv6cd2qin1p3yx00dbrcxlm0yysy5q5jiigblg";
    };
    description = "Port of ProSystem to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  quicknes = (mkLibRetroCore rec {
    core = "quicknes";
    src = fetchRetro {
      repo = "QuickNES_Core";
      rev = "cd302d998d102c9461a924b81817e48b9ea1518f";
      sha256 = "1sczs1jqcbhpkb5xpcqqdcnxlz7bqmanm4gdnnc12c19snl7999b";
    };
    description = "QuickNES libretro port";
    license = lgpl21Plus;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  scummvm = (mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "e07a6ede61c364fb87630fa7507a4f8482d882e0";
      sha256 = "0i88z53q28lwzmadxincab4m66qbzcbmasgildybj8db0z2z8jm0";
    };
    description = "Libretro port of ScummVM";
    license = gpl2;
    extraBuildInputs = [ fluidsynth libjpeg libvorbis libGLU libGL SDL ];
  }).override {
    makefile = "backends/platform/libretro/build/Makefile";
    buildPhase = "cd backends/platform/libretro/build && make";
  };

  snes9x = (mkLibRetroCore rec {
    core = "snes9x";
    src = fetchFromGitHub {
      owner = "snes9xgit";
      repo = core;
      rev = "04692e1ee45cc647423774ee17c63208c2713638";
      sha256 = "09p9m85fxwrrrapjb08rcxknpgq5d6a87arrm1jn94r56glxlcfa";
    };
    description = "Port of SNES9x git to libretro";
    license = "Non-commercial";
  }).override {
    makefile = "libretro/Makefile";
    buildPhase = "cd libretro && make";
  };

  snes9x2002 = (mkLibRetroCore rec {
    core = "snes9x2002";
    src = fetchRetro {
      repo = core;
      rev = "354bcb5acea0aa45b56ae553e0b2b4f10792dfeb";
      sha256 = "05gvjjxy6ci5pax3frd9g8k9mkqskab5g6rvfjab7cc4zrxrg23f";
    };
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    license = "Non-commercial";
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  snes9x2005 = (mkLibRetroCore rec {
    core = "snes9x2005";
    src = fetchRetro {
      repo = core;
      rev = "e5cadd2f21fb64e8c7194ad006b39e6f555c4a5b";
      sha256 = "1q0xrw3f8zm2k19sva8cz28yx815w8a6y1xsl0i6bb3cai3q1hyx";
    };
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    license = "Non-commercial";
  }).override {
    makefile = "Makefile";
    buildPhase = ''
      make USE_BLARGG_APU=1 \
      && mv snes9x2005_plus_libretro${stdenv.hostPlatform.extensions.sharedLibrary} snes9x2005_libretro${stdenv.hostPlatform.extensions.sharedLibrary}
    '';
  };

  snes9x2010 = (mkLibRetroCore rec {
    core = "snes9x2010";
    src = fetchRetro {
      repo = core;
      rev = "e945cbae0f8c472e1567a319817c9228b775dd71";
      sha256 = "1pj5p4a2hy7hk90bzy4vnkz3b6nc8n1niqibgwhyfsc22xlxqsfr";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    license = "Non-commercial";
  }).override {
    buildPhase = ''
      make -f Makefile.libretro
    '';
  };

  stella = (mkLibRetroCore rec {
    core = "stella";
    src = fetchRetro {
      repo = core + "2014-libretro";
      rev = "6d74ad9a0fd779145108cf1213229798d409ed37";
      sha256 = "0b1nsk92rr64xxj8jc9vpjqgrmm3554096zl031ymr94j5cc87q9";
    };
    description = "Port of Stella to libretro";
    license = gpl2;
  }).override {
    makefile = "Makefile";
    buildPhase = ''
      make \
      && mv stella2014_libretro${stdenv.hostPlatform.extensions.sharedLibrary} stella_libretro${stdenv.hostPlatform.extensions.sharedLibrary}
    '';
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = fetchRetro {
      repo = core;
      rev = "3580ae6acb1a90c4e982e57597458da07eca4f41";
      sha256 = "0fz8z04kf9g1i5x5slyvx5kb07garzxvhcqnwmqn5j574xh1lc6d";
    };
    description = "VBA-M libretro port with modifications for speed";
    license = gpl2;
  };

  vba-m = (mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "9ccdeac3aa9db00720bb80eff5c9924362144efa";
      sha256 = "0rq89i9f483j93shhp2p3vqsnb2abpwz6wdnsycfwxgblczmi22y";
    };
    description = "vanilla VBA-M libretro port";
    license = gpl2;
  }).override {
    makefile = "src/libretro/Makefile";
    buildPhase = "cd src/libretro && make";
  };

  vecx = (mkLibRetroCore rec {
    core = "vecx";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "26585ee701499550e484c11f005db18e926827d9";
      sha256 = "0vz2aksc8mqnw55f2bvvawj21mxf60fp93r0sr55hdccn9h7355k";
    };
    description = "Port of Vecx to libretro";
    license = gpl3;
  }).override {
    buildPhase = "make";
  };

  virtualjaguar = (mkLibRetroCore rec {
    core = "virtualjaguar";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "7bdd8658880b53bf2bcbae0741323fe18f9041f5";
      sha256 = "0zbrsfhvx293ijazy1w19qha19hprsi0zv8295sa0gq8kyh0xhyw";
    };
    description = "Port of VirtualJaguar to libretro";
    license = gpl3;
  }).override {
    makefile = "Makefile";
    buildPhase = "make";
  };

  yabause = (mkLibRetroCore rec {
    core = "yabause";
    src = fetchRetro {
      repo = core;
      rev = "08d09cb88a69ee4c2986693fb813e0eb58d71481";
      sha256 = "0z55yam1l7m21kbjwn44sp4md9g7p95b27vcxr7i0v08gnkwwvv1";
    };
    description = "Port of Yabause to libretro";
    license = gpl2;
  }).override {
    makefile = "yabause/src/libretro/Makefile";
    buildPhase = "cd yabause/src/libretro && make";
  };

}
