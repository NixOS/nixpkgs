{ lib
, stdenv
, SDL
, SDL2
, alsa-lib
, boost
, buildPackages
, cmake
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg
, fluidsynth
, gettext
, hexdump
, hidapi
, icu
, libGL
, libGLU
, libevdev
, libjpeg
, libpcap
, libpng
, libvorbis
, libzip
, makeWrapper
, nasm
, openssl
, pcre
, pkg-config
, portaudio
, python27
, python3
, retroarch
, sfml
, snappy
, udev
, which
, xorg
, zlib
}:

let

  d2u = lib.replaceChars [ "-" ] [ "_" ];

  mkLibRetroCore =
    { core
    , src
    , description
    , license
    , broken ? false
    , version ? "unstable-2021-11-16"
    , ...
    }@args:
    lib.makeOverridable stdenv.mkDerivation ((rec {

      name = "libretro-${core}-${version}";
      inherit src version;

      buildInputs = [ zlib ] ++ args.extraBuildInputs or [ ];
      nativeBuildInputs = [ makeWrapper ] ++ args.extraNativeBuildInputs or [ ];

      makefile = "Makefile.libretro";
      makeFlags = [
        "platform=${{
        linux = "unix";
        darwin = "osx";
        windows = "win";
      }.${stdenv.hostPlatform.parsed.kernel.name} or stdenv.hostPlatform.parsed.kernel.name}"
        "ARCH=${{
        armv7l = "arm";
        armv6l = "arm";
        i686 = "x86";
      }.${stdenv.hostPlatform.parsed.cpu.name} or stdenv.hostPlatform.parsed.cpu.name}"
      ] ++ (args.makeFlags or [ ]);

      installPhase = ''
        COREDIR="$out/lib/retroarch/cores"
        mkdir -p $out/bin
        mkdir -p $COREDIR
        mv ${d2u args.core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary} $COREDIR
        makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch-${core} \
          --add-flags "-L $COREDIR/${d2u core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary} $@"
      '';

      passthru = {
        inherit core;
        libretroCore = "/lib/retroarch/cores";
      };

      meta = with lib; {
        inherit broken description license;
        homepage = "https://www.libretro.com/";
        maintainers = with maintainers; [ edwtjo hrdinka MP2E ];
        platforms = platforms.unix;
      };
    }) // builtins.removeAttrs args [ "core" "src" "description" "license" "makeFlags" ]);

  hashesFile = builtins.fromJSON (builtins.readFile ./hashes.json);

  getCoreSrc = core:
    fetchFromGitHub (builtins.getAttr core hashesFile);

in
with lib.licenses;

{

  atari800 = mkLibRetroCore rec {
    core = "atari800";
    src = getCoreSrc core;
    description = "Port of Atari800 to libretro";
    license = gpl2;
    makefile = "Makefile";
    makeFlags = [ "GIT_VERSION=" ];
  };

  beetle-snes = mkLibRetroCore {
    core = "mednafen-snes";
    src = getCoreSrc "beetle-snes";
    description = "Port of Mednafen's SNES core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-gba = mkLibRetroCore {
    core = "mednafen-gba";
    src = getCoreSrc "beetle-gba";
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-lynx = mkLibRetroCore {
    core = "mednafen-lynx";
    src = getCoreSrc "beetle-lynx";
    description = "Port of Mednafen's Lynx core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-ngp = mkLibRetroCore {
    core = "mednafen-ngp";
    src = getCoreSrc "beetle-ngp";
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-pce-fast =
    let drv = mkLibRetroCore {
      core = "mednafen-pce-fast";
      src = getCoreSrc "beetle-pce-fast";
      description = "Port of Mednafen's PC Engine core to libretro";
      license = gpl2;
      makefile = "Makefile";
    }; in
    drv.override {
      name = "beetle-pce-fast-${drv.version}";
    };

  beetle-pcfx = mkLibRetroCore rec {
    core = "mednafen-pcfx";
    src = getCoreSrc "beetle-pcfx";
    description = "Port of Mednafen's PCFX core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-psx = let drv = (mkLibRetroCore {
    core = "mednafen-psx";
    src = getCoreSrc "beetle-psx";
    description = "Port of Mednafen's PSX Engine core to libretro";
    license = gpl2;
    makefile = "Makefile";
    makeFlags = [ "HAVE_HW=0" "HAVE_LIGHTREC=1" ];
  }); in
    drv.override {
      name = "beetle-psx-${drv.version}";
    };

  beetle-psx-hw = let drv = (mkLibRetroCore {
    core = "mednafen-psx-hw";
    src = getCoreSrc "beetle-psx";
    description = "Port of Mednafen's PSX Engine (with HW accel) core to libretro";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = [ "HAVE_VULKAN=1" "HAVE_OPENGL=1" "HAVE_HW=1" "HAVE_LIGHTREC=1" ];
  }); in
    drv.override {
      name = "beetle-psx-hw-${drv.version}";
    };

  beetle-saturn = let drv = (mkLibRetroCore {
    core = "mednafen-saturn";
    src = getCoreSrc "beetle-saturn";
    description = "Port of Mednafen's Saturn core to libretro";
    license = gpl2;
    makefile = "Makefile";
    makeFlags = [ "HAVE_HW=0" ];
    meta.platforms = [ "x86_64-linux" "aarch64-linux" ];
  }); in
    drv.override {
      name = "beetle-saturn-${drv.version}";
    };

  beetle-saturn-hw = let drv = (mkLibRetroCore {
    core = "mednafen-saturn-hw";
    src = getCoreSrc "beetle-saturn";
    description = "Port of Mednafen's Saturn core to libretro";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = [ "HAVE_OPENGL=1" "HAVE_HW=1" ];
    meta.platforms = [ "x86_64-linux" "aarch64-linux" ];
  }); in
    drv.override {
      name = "beetle-saturn-${drv.version}";
    };

  beetle-supergrafx = mkLibRetroCore rec {
    core = "mednafen-supergrafx";
    src = getCoreSrc "beetle-supergrafx";
    description = "Port of Mednafen's SuperGrafx core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-wswan = mkLibRetroCore rec {
    core = "mednafen-wswan";
    src = getCoreSrc "beetle-wswan";
    description = "Port of Mednafen's WonderSwan core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-vb = mkLibRetroCore rec {
    core = "mednafen-vb";
    src = getCoreSrc "beetle-vb";
    description = "Port of Mednafen's VirtualBoy core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  bluemsx = mkLibRetroCore rec {
    core = "bluemsx";
    src = getCoreSrc core;
    description = "Port of BlueMSX to libretro";
    license = gpl2;
  };

  bsnes-mercury = let bname = "bsnes-mercury"; in
    mkLibRetroCore {
      core = bname + "-accuracy";
      src = getCoreSrc "bsnes-mercury";
      description = "Fork of bsnes with HLE DSP emulation restored";
      license = gpl3;
      makefile = "Makefile";
      makeFlags = [ "PROFILE=accuracy" ];
    };

  citra = mkLibRetroCore rec {
    core = "citra";
    # `nix-prefetch-github` doesn't support `deepClone`, necessary for citra
    # https://github.com/seppeljordan/nix-prefetch-github/issues/41
    src = fetchFromGitHub {
      inherit (hashesFile.citra) owner repo rev fetchSubmodules;
      deepClone = true;
      sha256 = "sha256-bwnYkMvbtRF5bGZRYVtMWxnCu9P45qeX4+ntOj9eRds=";
    };
    description = "Port of Citra to libretro";
    license = gpl2Plus;
    extraNativeBuildInputs = [ cmake pkg-config ];
    extraBuildInputs = [ libGLU libGL boost ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DENABLE_LIBRETRO=ON"
      "-DENABLE_QT=OFF"
      "-DENABLE_SDL2=OFF"
      "-DENABLE_WEB_SERVICE=OFF"
      "-DENABLE_DISCORD_PRESENCE=OFF"
    ];
    preConfigure = "sed -e '77d' -i externals/cmake-modules/GetGitRevisionDescription.cmake";
    postBuild = "cd src/citra_libretro";
  };

  desmume = mkLibRetroCore rec {
    core = "desmume";
    src = getCoreSrc core;
    description = "libretro wrapper for desmume NDS emulator";
    license = gpl2;
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
    preBuild = "cd desmume/src/frontend/libretro";
    makeFlags = lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
      ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";
  };

  desmume2015 = mkLibRetroCore rec {
    core = "desmume2015";
    src = getCoreSrc core;
    description = "libretro wrapper for desmume NDS emulator from 2015";
    license = gpl2;
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
    makeFlags = lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
      ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";
    preBuild = "cd desmume";
  };

  dolphin = mkLibRetroCore rec {
    core = "dolphin";
    src = getCoreSrc core;
    description = "Port of Dolphin to libretro";
    license = gpl2Plus;

    extraNativeBuildInputs = [ cmake curl pkg-config ];
    extraBuildInputs = [
      libGLU
      libGL
      pcre
      sfml
      gettext
      hidapi
      libevdev
      udev
    ] ++ (with xorg; [ libSM libX11 libXi libpthreadstubs libxcb xcbutil libXext libXrandr libXinerama libXxf86vm ]);
    makefile = "Makefile";
    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLIBRETRO=ON"
      "-DLIBRETRO_STATIC=1"
      "-DENABLE_QT=OFF"
      "-DENABLE_LTO=OFF"
      "-DUSE_UPNP=OFF"
      "-DUSE_DISCORD_PRESENCE=OFF"
    ];
    dontUseCmakeBuildDir = true;
  };

  dosbox = mkLibRetroCore rec {
    core = "dosbox";
    src = getCoreSrc core;
    description = "Port of DOSBox to libretro";
    license = gpl2;
  };

  eightyone = mkLibRetroCore rec {
    core = "81";
    src = getCoreSrc "eightyone";
    description = "Port of EightyOne to libretro";
    license = gpl3;
  };

  fbalpha2012 = mkLibRetroCore rec {
    core = "fbalpha2012";
    src = getCoreSrc core;
    description = "Port of Final Burn Alpha ~2012 to libretro";
    license = "Non-commercial";
    makefile = "makefile.libretro";
    preBuild = "cd svn-current/trunk";
  };

  fbneo = mkLibRetroCore rec {
    core = "fbneo";
    src = getCoreSrc core;
    description = "Port of FBNeo to libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    postPatch = ''
      sed -i -e 's:-Wall:-Wall -Wno-format-security:g' src/burner/libretro/Makefile
    '';
    preBuild = "cd src/burner/libretro";
    makeFlags = [ "USE_EXPERIMENTAL_FLAGS=1" ];
  };

  fceumm = mkLibRetroCore rec {
    core = "fceumm";
    src = getCoreSrc core;
    description = "FCEUmm libretro port";
    license = gpl2;
  };

  flycast = mkLibRetroCore rec {
    core = "flycast";
    src = getCoreSrc core;
    description = "Flycast libretro port";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = lib.optional stdenv.hostPlatform.isAarch64 [ "platform=arm64" ];
    meta.platforms = [ "aarch64-linux" "x86_64-linux" ];
  };

  fmsx = mkLibRetroCore rec {
    core = "fmsx";
    src = getCoreSrc core;
    description = "FMSX libretro port";
    license = "Non-commercial";
    makefile = "Makefile";
  };

  freeintv = mkLibRetroCore rec {
    core = "freeintv";
    src = getCoreSrc core;
    description = "FreeIntv libretro port";
    license = gpl3;
    makefile = "Makefile";
  };

  gambatte = mkLibRetroCore rec {
    core = "gambatte";
    src = getCoreSrc core;
    description = "Gambatte libretro port";
    license = gpl2;
  };

  genesis-plus-gx = mkLibRetroCore rec {
    core = "genesis-plus-gx";
    src = getCoreSrc core;
    description = "Enhanced Genesis Plus libretro port";
    license = "Non-commercial";
  };

  gpsp = mkLibRetroCore rec {
    core = "gpsp";
    src = getCoreSrc core;
    description = "Port of gpSP to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  gw = mkLibRetroCore rec {
    core = "gw";
    src = getCoreSrc core;
    description = "Port of Game and Watch to libretro";
    license = lib.licenses.zlib;
    makefile = "Makefile";
  };

  handy = mkLibRetroCore rec {
    core = "handy";
    src = getCoreSrc core;
    description = "Port of Handy to libretro";
    license = "Handy-License";
    makefile = "Makefile";
  };

  hatari = mkLibRetroCore rec {
    core = "hatari";
    src = getCoreSrc core;
    description = "Port of Hatari to libretro";
    license = gpl2;
    extraBuildInputs = [ SDL zlib ];
    extraNativeBuildInputs = [ cmake which ];
    dontUseCmakeConfigure = true;
    dontConfigure = true;
    makeFlags = [ "EXTERNAL_ZLIB=1" ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];
  };

  mame = mkLibRetroCore rec {
    core = "mame";
    src = getCoreSrc core;
    description = "Port of MAME to libretro";
    license = gpl2Plus;

    extraBuildInputs = [ alsa-lib libGLU libGL portaudio python3 xorg.libX11 ];
    postPatch = ''
      # Prevent the failure during the parallel building of:
      # make -C 3rdparty/genie/build/gmake.linux -f genie.make obj/Release/src/host/lua-5.3.0/src/lgc.o
      mkdir -p 3rdparty/genie/build/gmake.linux/obj/Release/src/host/lua-5.3.0/src
    '';
    makefile = "Makefile.libretro";
  };

  mame2000 = mkLibRetroCore rec {
    core = "mame2000";
    src = getCoreSrc core;
    description = "Port of MAME ~2000 to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "IS_X86=0";
  };

  mame2003 = mkLibRetroCore rec {
    core = "mame2003";
    src = getCoreSrc core;
    description = "Port of MAME ~2003 to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
  };

  mame2003-plus = mkLibRetroCore rec {
    core = "mame2003-plus";
    src = getCoreSrc core;
    description = "Port of MAME ~2003+ to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
  };

  mame2010 = mkLibRetroCore rec {
    core = "mame2010";
    src = getCoreSrc core;
    description = "Port of MAME ~2010 to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
    makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [ "PTR64=1" "ARM_ENABLED=1" "X86_SH2DRC=0" "FORCE_DRC_C_BACKEND=1" ];
  };

  mame2015 = mkLibRetroCore rec {
    core = "mame2015";
    src = getCoreSrc core;
    description = "Port of MAME ~2015 to libretro";
    license = gpl2Plus;
    extraNativeBuildInputs = [ python27 ];
    extraBuildInputs = [ alsa-lib ];
    makefile = "Makefile";
  };

  mame2016 = mkLibRetroCore rec {
    core = "mame2016";
    src = getCoreSrc core;
    patches = [
      (fetchpatch {
        name = "fix_mame_build_on_make-4.3.patch";
        url = "https://github.com/libretro/mame2016-libretro/commit/5874fae3d124f5e7c8a91634f5473a8eac902e47.patch";
        sha256 = "061f1lcm72glksf475ikl8w10pnbgqa7049ylw06nikis2qdjlfn";
      })
    ];
    description = "Port of MAME ~2016 to libretro";
    license = gpl2Plus;
    extraNativeBuildInputs = [ python27 ];
    extraBuildInputs = [ alsa-lib ];
    postPatch = ''
      # Prevent the failure during the parallel building of:
      # make -C 3rdparty/genie/build/gmake.linux -f genie.make obj/Release/src/host/lua-5.3.0/src/lgc.o
      mkdir -p 3rdparty/genie/build/gmake.linux/obj/Release/src/host/lua-5.3.0/src
    '';
  };

  mesen = mkLibRetroCore rec {
    core = "mesen";
    src = getCoreSrc core;
    description = "Port of Mesen to libretro";
    license = gpl3;
    makefile = "Makefile";
    preBuild = "cd Libretro";
  };

  meteor = mkLibRetroCore rec {
    core = "meteor";
    src = getCoreSrc core;
    description = "Port of Meteor to libretro";
    license = gpl3;
    makefile = "Makefile";
    preBuild = "cd libretro";
  };

  mgba = mkLibRetroCore rec {
    core = "mgba";
    src = getCoreSrc core;
    description = "Port of mGBA to libretro";
    license = mpl20;
  };

  mupen64plus = mkLibRetroCore {
    core = "mupen64plus-next";
    src = getCoreSrc "mupen64plus";
    description = "Libretro port of Mupen64 Plus, GL only";
    license = gpl2;

    extraBuildInputs = [ libGLU libGL libpng nasm xorg.libX11 ];
    makefile = "Makefile";
  };

  neocd = mkLibRetroCore rec {
    core = "neocd";
    src = getCoreSrc core;
    description = "NeoCD libretro port";
    license = gpl3;
    makefile = "Makefile";
  };

  nestopia = mkLibRetroCore rec {
    core = "nestopia";
    src = getCoreSrc core;
    description = "Nestopia libretro port";
    license = gpl2;
    makefile = "Makefile";
    preBuild = "cd libretro";
  };

  np2kai = mkLibRetroCore rec {
    core = "np2kai";
    src = getCoreSrc core;
    description = "Neko Project II kai libretro port";
    license = mit;
    makefile = "Makefile.libretro";
    makeFlags = [
      # See https://github.com/AZO234/NP2kai/tags
      "NP2KAI_VERSION=rev.22"
      "NP2KAI_HASH=${src.rev}"
    ];
    preBuild = "cd sdl";
  };

  o2em = mkLibRetroCore rec {
    core = "o2em";
    src = getCoreSrc core;
    description = "Port of O2EM to libretro";
    license = artistic1;
    makefile = "Makefile";
  };

  opera = mkLibRetroCore rec {
    core = "opera";
    src = getCoreSrc core;
    description = "Opera is a port of 4DO/libfreedo to libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];
  };

  parallel-n64 = mkLibRetroCore rec {
    core = "parallel-n64";
    src = getCoreSrc core;
    description = "Parallel Mupen64plus rewrite for libretro.";
    license = gpl2;
    extraBuildInputs = [ libGLU libGL libpng ];
    makefile = "Makefile";
    postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
      sed -i -e '1 i\CPUFLAGS += -DARM_FIX -DNO_ASM -DARM_ASM -DDONT_WANT_ARM_OPTIMIZATIONS -DARM64' Makefile \
      && sed -i -e 's,CPUFLAGS  :=,,g' Makefile
    '';
  };

  pcsx_rearmed = mkLibRetroCore rec {
    core = "pcsx_rearmed";
    src = getCoreSrc core;
    description = "Port of PCSX ReARMed with GNU lightning to libretro";
    license = gpl2;
    dontConfigure = true;
  };

  picodrive = mkLibRetroCore rec {
    core = "picodrive";
    src = getCoreSrc core;
    description = "Fast MegaDrive/MegaCD/32X emulator";
    license = "MAME";

    extraBuildInputs = [ libpng SDL ];
    SDL_CONFIG = "${SDL.dev}/bin/sdl-config";
    dontAddPrefix = true;
    configurePlatforms = [ ];
    makeFlags = lib.optional stdenv.hostPlatform.isAarch64 [ "platform=aarch64" ];
  };

  play = mkLibRetroCore rec {
    core = "play";
    src = getCoreSrc core;
    description = "Port of Play! to libretro";
    license = bsd2;
    extraBuildInputs = [ boost ];
    extraNativeBuildInputs = [ cmake openssl curl icu libGL libGLU xorg.libX11 ];
    makefile = "Makefile";
    cmakeFlags = [ "-DBUILD_PLAY=OFF -DBUILD_LIBRETRO_CORE=ON" ];
    postBuild = "mv Source/ui_libretro/play_libretro${stdenv.hostPlatform.extensions.sharedLibrary} play_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
    broken = true; # since 2021-01-03
  };

  ppsspp = mkLibRetroCore rec {
    core = "ppsspp";
    src = getCoreSrc core;
    description = "ppsspp libretro port";
    license = gpl2;
    extraNativeBuildInputs = [ cmake pkg-config python3 ];
    extraBuildInputs = [ libGLU libGL libzip ffmpeg snappy xorg.libX11 ];
    makefile = "Makefile";
    cmakeFlags = [ "-DLIBRETRO=ON -DUSE_SYSTEM_FFMPEG=ON -DUSE_SYSTEM_SNAPPY=ON -DUSE_SYSTEM_LIBZIP=ON -DOpenGL_GL_PREFERENCE=GLVND" ];
    postBuild = "mv lib/ppsspp_libretro${stdenv.hostPlatform.extensions.sharedLibrary} ppsspp_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  prboom = mkLibRetroCore rec {
    core = "prboom";
    src = getCoreSrc core;
    description = "Prboom libretro port";
    license = gpl2;
    makefile = "Makefile";
  };

  prosystem = mkLibRetroCore rec {
    core = "prosystem";
    src = getCoreSrc core;
    description = "Port of ProSystem to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  quicknes = mkLibRetroCore rec {
    core = "quicknes";
    src = getCoreSrc core;
    description = "QuickNES libretro port";
    license = lgpl21Plus;
    makefile = "Makefile";
  };

  sameboy = mkLibRetroCore rec {
    core = "sameboy";
    src = getCoreSrc core;
    description = "SameBoy libretro port";
    license = mit;
    extraNativeBuildInputs = [ which hexdump ];
    preBuild = "cd libretro";
    makefile = "Makefile";
  };

  scummvm = mkLibRetroCore rec {
    core = "scummvm";
    src = getCoreSrc core;
    description = "Libretro port of ScummVM";
    license = gpl2;
    extraBuildInputs = [ fluidsynth libjpeg libvorbis libGLU libGL SDL ];
    makefile = "Makefile";
    preConfigure = "cd backends/platform/libretro/build";
  };

  smsplus-gx = mkLibRetroCore rec {
    core = "smsplus";
    src = getCoreSrc "smsplus-gx";
    description = "SMS Plus GX libretro port";
    license = gpl2Plus;
  };

  snes9x = mkLibRetroCore rec {
    core = "snes9x";
    src = getCoreSrc core;
    description = "Port of SNES9x git to libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    preBuild = "cd libretro";
  };

  snes9x2002 = mkLibRetroCore rec {
    core = "snes9x2002";
    src = getCoreSrc core;
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    license = "Non-commercial";
    makefile = "Makefile";
  };

  snes9x2005 = mkLibRetroCore rec {
    core = "snes9x2005";
    src = getCoreSrc core;
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    makeFlags = [ "USE_BLARGG_APU=1" ];
    postBuild = "mv snes9x2005_plus_libretro${stdenv.hostPlatform.extensions.sharedLibrary} snes9x2005_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  snes9x2010 = mkLibRetroCore rec {
    core = "snes9x2010";
    src = getCoreSrc core;
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    license = "Non-commercial";
  };

  stella = mkLibRetroCore rec {
    core = "stella";
    src = getCoreSrc core;
    description = "Port of Stella to libretro";
    license = gpl2;
    extraBuildInputs = [ libpng pkg-config SDL ];
    makefile = "Makefile";
    preBuild = "cd src/libretro";
    dontConfigure = true;
  };

  stella2014 = mkLibRetroCore rec {
    core = "stella2014";
    src = getCoreSrc core;
    description = "Port of Stella to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  tgbdual = mkLibRetroCore rec {
    core = "tgbdual";
    src = getCoreSrc core;
    description = "Port of TGBDual to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  thepowdertoy = mkLibRetroCore rec {
    core = "thepowdertoy";
    src = getCoreSrc core;
    description = "Port of The Powder Toy to libretro";
    license = gpl3Only;
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    postBuild = "cd src/";
  };

  tic80 = mkLibRetroCore rec {
    core = "tic80";
    src = getCoreSrc core;
    description = "Port of TIC-80 to libretro";
    license = mit;
    extraNativeBuildInputs = [ cmake pkg-config libGL libGLU ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DBUILD_LIBRETRO=ON"
      "-DBUILD_DEMO_CARTS=OFF"
      "-DBUILD_PRO=OFF"
      "-DBUILD_PLAYER=OFF"
      "-DBUILD_SDL=OFF"
      "-DBUILD_SOKOL=OFF"
    ];
    postBuild = "cd lib";
  };

  vba-next = mkLibRetroCore rec {
    core = "vba-next";
    src = getCoreSrc core;
    description = "VBA-M libretro port with modifications for speed";
    license = gpl2;
  };

  vba-m = mkLibRetroCore rec {
    core = "vbam";
    src = getCoreSrc "vba-m";
    description = "vanilla VBA-M libretro port";
    license = gpl2;
    makefile = "Makefile";
    preBuild = "cd src/libretro";
  };

  vecx = mkLibRetroCore rec {
    core = "vecx";
    src = getCoreSrc core;
    description = "Port of Vecx to libretro";
    license = gpl3;
    extraBuildInputs = [ libGL libGLU ];
  };

  virtualjaguar = mkLibRetroCore rec {
    core = "virtualjaguar";
    src = getCoreSrc core;
    description = "Port of VirtualJaguar to libretro";
    license = gpl3;
    makefile = "Makefile";
  };

  yabause = mkLibRetroCore rec {
    core = "yabause";
    src = getCoreSrc core;
    description = "Port of Yabause to libretro";
    license = gpl2;
    makefile = "Makefile";
    # Disable SSE for non-x86. DYNAREC doesn't build on either Aarch64 or x86_64.
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "HAVE_SSE=0";
    preBuild = "cd yabause/src/libretro";
  };

}
