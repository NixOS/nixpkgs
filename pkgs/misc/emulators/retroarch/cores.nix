{ lib, stdenv, fetchgit, fetchFromGitHub, fetchFromGitLab, fetchpatch, cmake, pkg-config, makeWrapper, python27, python37, retroarch
, alsaLib, fluidsynth, curl, hidapi, libGLU, gettext, glib, gtk2, portaudio, SDL, SDL_net, SDL2, SDL2_image, libGL
, ffmpeg_3, pcre, libevdev, libpng, libjpeg, libzip, udev, libvorbis, snappy, which, hexdump
, miniupnpc, sfml, xorg, zlib, nasm, libpcap, boost, icu, openssl
, buildPackages }:

let

  d2u = lib.replaceChars ["-"] ["_"];

  mkLibRetroCore = { core, src, description, license, broken ? false, ... }@a:
  lib.makeOverridable stdenv.mkDerivation ((rec {

    name = "libretro-${a.core}-${version}";
    version = "2020-03-06";
    inherit (a) src;

    buildInputs = [ zlib ] ++ a.extraBuildInputs or [];
    nativeBuildInputs = [ makeWrapper ] ++ a.extraNativeBuildInputs or [];

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
    ] ++ (a.makeFlags or []);

    installPhase = ''
      COREDIR="$out/lib/retroarch/cores"
      mkdir -p $out/bin
      mkdir -p $COREDIR
      mv ${d2u a.core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary} $COREDIR
      makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch-${core} \
        --add-flags "-L $COREDIR/${d2u core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary} $@"
    '';

    passthru = {
      inherit (a) core;
      libretroCore = "/lib/retroarch/cores";
    };

    meta = with lib; {
      inherit (a) description license;
      broken = a.broken or false;
      homepage = "https://www.libretro.com/";
      maintainers = with maintainers; [ edwtjo hrdinka MP2E ];
      platforms = platforms.unix;
    };
  }) // builtins.removeAttrs a ["core" "src" "description" "license" "makeFlags"]);

  fetchRetro = { repo, rev, sha256 }:
  fetchgit {
    inherit rev sha256;
    url = "https://github.com/libretro/${repo}.git";
    fetchSubmodules = true;
  };

in with lib.licenses;

{

  atari800 = mkLibRetroCore rec {
    core = "atari800";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "f9bf53b864344b8bbe8d425ed2f3c628eb10519c";
      sha256 = "0sgk93zs423pwiqzvj0x1gfwcn9gacnlrrdq53ps395k64lig6lk";
    };
    description = "Port of Atari800 to libretro";
    license = gpl2;
    makefile = "Makefile";
    makeFlags = [ "GIT_VERSION=" ];
  };

  beetle-snes = mkLibRetroCore {
    core = "mednafen-snes";
    src = fetchRetro {
      repo = "beetle-bsnes-libretro";
      rev = "de22d8420ea606f1b2f72afd4dda34619cf2cc20";
      sha256 = "1nd4f8frmlhp1lyxz9zpxvwwz70x0i0rrp560cn9qlm1jzdv3xvf";
    };
    description = "Port of Mednafen's SNES core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-gba = mkLibRetroCore {
    core = "mednafen-gba";
    src = fetchRetro {
      repo = "beetle-gba-libretro";
      rev = "135afdbb9591655a3e016b75abba07e481f6d406";
      sha256 = "0fc0x24qn4y7pz3mp1mm1ain31aj9pznp1irr0k7hvazyklzy9g3";
    };
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-lynx = mkLibRetroCore {
    core = "mednafen-lynx";
    src = fetchRetro {
      repo = "beetle-lynx-libretro";
      rev = "74dde204c0ec6c4bc4cd7821c14548387fbd9ce8";
      sha256 = "05kwibjr30laalqzazswvmn9smm3mwqsz1i0z1s0pj7idfdhjfw0";
    };
    description = "Port of Mednafen's Lynx core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-ngp = mkLibRetroCore {
    core = "mednafen-ngp";
    src = fetchRetro {
      repo = "beetle-ngp-libretro";
      rev = "6f15532b6ad17a2d5eb9dc8241d6af62416e796b";
      sha256 = "05r8mk9rc19nzs3gpfsjr6i7pm6xx3gn3b4xs8ab7v4vcmfg4cn2";
    };
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-pce-fast = let der = mkLibRetroCore {
    core = "mednafen-pce-fast";
    src = fetchRetro {
      repo = "beetle-pce-fast-libretro";
      rev = "40a42b7f43f029760c92bf0b2097e7d4b90ed29c";
      sha256 = "1gr6wg4bd4chm4c39w0c1b5zfzr05zd7234vvlmr1imk0v6m0wj6";
    };
    description = "Port of Mednafen's PC Engine core to libretro";
    license = gpl2;
    makefile = "Makefile";
  }; in der.override {
    name = "beetle-pce-fast-${der.version}";
  };

  beetle-pcfx = mkLibRetroCore rec {
    core = "mednafen-pcfx";
    src = fetchRetro {
      repo = "beetle-pcfx-libretro";
      rev = "7bba6699d6f903bd701b0aa525d845de8427fee6";
      sha256 = "1lh7dh96fyi005fcg3xaf7r4ssgkq840p6anldlqy52vfwmglw3p";
    };
    description = "Port of Mednafen's PCFX core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-psx = let der = (mkLibRetroCore {
    core = "mednafen-psx";
    src = fetchRetro {
      repo = "beetle-psx-libretro";
      rev = "0f1e7e60827cad49ebba628abdc83ad97652ab89";
      sha256 = "1j92jgddyl970v775d6gyb50l8md6yfym2fpqhfxcr4gj1b4ivwq";
    };
    description = "Port of Mednafen's PSX Engine core to libretro";
    license = gpl2;
    makefile = "Makefile";
    makeFlags = [ "HAVE_HW=0" "HAVE_LIGHTREC=1" ];
  }); in der.override {
    name = "beetle-psx-${der.version}";
  };

  beetle-psx-hw = let der = (mkLibRetroCore {
    core = "mednafen-psx-hw";
    src = fetchRetro {
      repo = "beetle-psx-libretro";
      rev = "0f1e7e60827cad49ebba628abdc83ad97652ab89";
      sha256 = "1j92jgddyl970v775d6gyb50l8md6yfym2fpqhfxcr4gj1b4ivwq";
    };
    description = "Port of Mednafen's PSX Engine (with HW accel) core to libretro";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = [ "HAVE_VULKAN=1" "HAVE_OPENGL=1" "HAVE_HW=1" "HAVE_LIGHTREC=1" ];
  }); in der.override {
    name = "beetle-psx-hw-${der.version}";
  };

  beetle-saturn = let der = (mkLibRetroCore {
    core = "mednafen-saturn";
    src = fetchRetro {
      repo = "beetle-saturn-libretro";
      rev = "8a65943bb7bbc3183eeb0d57c4ac3e663f1bcc11";
      sha256 = "1f0cd9wmvarsmf4jw0p6h3lbzs6515aja7krrwapja7i4xmgbrnh";
    };
    description = "Port of Mednafen's Saturn core to libretro";
    license = gpl2;
    makefile = "Makefile";
    makeFlags = [ "HAVE_HW=0" ];
    meta.platforms = [ "x86_64-linux" "aarch64-linux" ];
  }); in der.override {
    name = "beetle-saturn-${der.version}";
  };

  beetle-saturn-hw = let der = (mkLibRetroCore {
    core = "mednafen-saturn-hw";
    src = fetchRetro {
      repo = "beetle-saturn-libretro";
      rev = "8a65943bb7bbc3183eeb0d57c4ac3e663f1bcc11";
      sha256 = "1f0cd9wmvarsmf4jw0p6h3lbzs6515aja7krrwapja7i4xmgbrnh";
    };
    description = "Port of Mednafen's Saturn core to libretro";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = [ "HAVE_OPENGL=1" "HAVE_HW=1" ];
    meta.platforms = [ "x86_64-linux" "aarch64-linux" ];
  }); in der.override {
    name = "beetle-saturn-${der.version}";
  };

  beetle-supergrafx = mkLibRetroCore rec {
    core = "mednafen-supergrafx";
    src = fetchRetro {
      repo = "beetle-supergrafx-libretro";
      rev = "fadef23d59fa5ec17bc99e1e722cfd9e10535695";
      sha256 = "15rm7p5q38qy3xpyvamhphjnna8h91fsbcqnl9vhzx9cmjg0wf54";
    };
    description = "Port of Mednafen's SuperGrafx core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-wswan = mkLibRetroCore rec {
    core = "mednafen-wswan";
    src = fetchRetro {
      repo = "beetle-wswan-libretro";
      rev = "5b03d1b09f70dc208387d3c8b59e12e1f0d2692f";
      sha256 = "1sm6ww3y9m85lhp74dpxbs05yxdhhqqmj2022j9s0m235z29iygc";
    };
    description = "Port of Mednafen's WonderSwan core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  beetle-vb = mkLibRetroCore rec {
    core = "mednafen-vb";
    src = fetchRetro {
      repo = "beetle-vb-libretro";
      rev = "9a4e604a7320a3c6ed30601989fe0bc417fa9ad3";
      sha256 = "1gallwbqxn5qbmwxr1vxb41nncksai4rxc739a7vqvp65k5kl0qp";
    };
    description = "Port of Mednafen's VirtualBoy core to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  bluemsx = mkLibRetroCore rec {
    core = "bluemsx";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "7a1d40e750860580ab7cc21fbc244b5bc6db6586";
      sha256 = "05hnkyr47djccspr8v438zimdfsgym7v0jn1hwpkqc4i5zf70981";
    };
    description = "Port of BlueMSX to libretro";
    license = gpl2;
  };

  bsnes-mercury = let bname = "bsnes-mercury"; in mkLibRetroCore {
    core = bname + "-accuracy";
    src = fetchRetro {
      repo = bname;
      rev = "4a382621da58ae6da850f1bb003ace8b5f67968c";
      sha256 = "0z8psz24nx8497vpk2wya9vs451rzzw915lkw3qiq9bzlzg9r2wv";
    };
    description = "Fork of bsnes with HLE DSP emulation restored";
    license = gpl3;
    makefile = "Makefile";
    postBuild = "cd out";
  };

  citra = mkLibRetroCore rec {
    core = "citra";
    src = fetchgit {
      url = "https://github.com/libretro/citra.git";
      rev = "84f31e95160b029e6d614053705054ed6a34bb38";
      sha256 = "0gkgxpwrh0q098cpx56hprvmazi5qi448c23svwa8ar1myh8p248";
      fetchSubmodules = true;
      deepClone = true;
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
    src = fetchRetro {
      repo = core;
      rev = "e8cf461f83eebb195f09e70090f57b07d1bcdd9f";
      sha256 = "0rc8s5226wn39jqs5yxi30jc1snc0p106sfym7kgi98hy5na8yab";
    };
    description = "libretro wrapper for desmume NDS emulator";
    license = gpl2;
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
    preBuild = "cd desmume/src/frontend/libretro";
    makeFlags = lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
             ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";
  };

  desmume2015 = mkLibRetroCore rec {
    core = "desmume2015";
    src = fetchRetro {
      repo = core;
      rev = "93d5789d60f82436e20ccad05ce9cb43c6e3656e";
      sha256 = "12nii2pbnqgh7f7jkphbwjpr2hiy2mzbwpas3xyhpf9wpy3qiasg";
    };
    description = "libretro wrapper for desmume NDS emulator from 2015";
    license = gpl2;
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
    makeFlags = lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
             ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";
    preBuild = "cd desmume";
  };

  dolphin = mkLibRetroCore {
    core = "dolphin";
    src = fetchRetro {
      repo = "dolphin";
      rev = "1fbd59911d1b718c142d6448dee3ede98152e395";
      sha256 = "1rymsvs034l1hbxc3w8zi9lhmgka2qaj3jynjy152dccd480nnd4";
    };
    description = "Port of Dolphin to libretro";
    license = gpl2Plus;

    extraNativeBuildInputs = [ cmake curl pkg-config ];
    extraBuildInputs = [
      libGLU libGL pcre sfml
      gettext hidapi
      libevdev udev
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
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "e4ed503b14ed59d5d745396ef1cc7d52cf912328";
      sha256 = "13bx0ln9hwn6hy4sv0ivqmjgjbfq8svx15dsa24hwd8lkf0kakl4";
    };
    description = "Port of DOSBox to libretro";
    license = gpl2;
  };

  eightyone = mkLibRetroCore rec {
    core = "81";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "4352130bd2363954262a804b086f86b9d13d97f9";
      sha256 = "057ynnv85imjqhgixrx7p28wn42v88vsm3fc1lp3mpcfi2bk266h";
    };
    description = "Port of EightyOne to libretro";
    license = gpl3;
  };

  fbalpha2012 = mkLibRetroCore rec {
    core = "fbalpha2012";
    src = fetchRetro {
      repo = core;
      rev = "fa97cd2784a337f8ac774c2ce8a136aee69b5f43";
      sha256 = "1i75k0r6838hl77bjjmzvan33ka5qjrdpirmclzj20g5j97lmas7";
    };
    description = "Port of Final Burn Alpha ~2012 to libretro";
    license = "Non-commercial";
    makefile = "makefile.libretro";
    preBuild = "cd svn-current/trunk";
  };

  fbneo = mkLibRetroCore rec {
    core = "fbneo";
    src = fetchRetro {
      repo = core;
      rev = "cf43fdb1755f9f5c886266e86ba40d339bc8f5d7";
      sha256 = "13g3c6mbwhcf0rp95ga4klszh8dab2d4ahh2vzzlmd57r69lf2lv";
    };
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
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "9ed22e5a9a1360a7f599a64283af9fe24b858e3d";
      sha256 = "0rz6iy281jpybmsz5rh06k5xvmd9id9w2q2gd0qdv9a2ylwv7s2j";
    };
    description = "FCEUmm libretro port";
    license = gpl2;
  };

  flycast = mkLibRetroCore rec {
    core = "flycast";
    src = fetchRetro {
      repo = core;
      rev = "b12f3726d9093acb4e441b1cdcf6cd11403c8644";
      sha256 = "0nczjhdqr7svq9aflczf7rwz64bih1wqy9q0gyglb55xlslf5jqc";
    };
    description = "Flycast libretro port";
    license = gpl2;
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = lib.optional stdenv.hostPlatform.isAarch64 [ "platform=arm64" ];
    meta.platforms = [ "aarch64-linux" "x86_64-linux" ];
  };

  fmsx = mkLibRetroCore rec {
    core = "fmsx";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "3de916bbf15062de1ab322432d38a1fee29d5e68";
      sha256 = "1krr4lmdiv0d7bxk37fqz5y412znb5bmxapv9g7ci6fp87sr69jq";
    };
    description = "FMSX libretro port";
    license = "Non-commercial";
    makefile = "Makefile";
  };

  freeintv = mkLibRetroCore rec {
    core = "freeintv";
    src = fetchRetro {
      repo = core;
      rev = "45030e10cc1a50cf7a80c5d921aa8cba0aeaca91";
      sha256 = "10lngk3p012bgrg752426701hfzsiy359h8i0vzsa64pgyjbqlag";
    };
    description = "FreeIntv libretro port";
    license = gpl3;
    makefile = "Makefile";
  };

  gambatte = mkLibRetroCore rec {
    core = "gambatte";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "132f36e990dfc6effdafa6cf261373432464f9bf";
      sha256 = "19w5k9yc1cl99c5hiqbp6j54g6z06xcblpvd3x6nmhxij81yqxy7";
    };
    description = "Gambatte libretro port";
    license = gpl2;
  };

  genesis-plus-gx = mkLibRetroCore {
    core = "genesis-plus-gx";
    src = fetchRetro {
      repo = "Genesis-Plus-GX";
      rev = "50551066f71f8a5ea782ea3747891fd6d24ebe67";
      sha256 = "150lgdrv7idcq7jbd1jj7902rcsyixd7kfjs2m5xdinjvl22kihr";
    };
    description = "Enhanced Genesis Plus libretro port";
    license = "Non-commercial";
  };

  gpsp = mkLibRetroCore rec {
    core = "gpsp";
    src = fetchRetro {
      repo = core;
      rev = "3f2f57c982ffead643957db5b26931df4913596f";
      sha256 = "09fa1c623rmy1w9zx85r75viv8q1vknhbs8fn6xbss9rhpxhivwg";
    };
    description = "Port of gpSP to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  gw = mkLibRetroCore rec {
    core = "gw";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "819b1dde560013003eeac86c2069c5be7af25c6d";
      sha256 = "1jhgfys8hiipvbwq3gc48d7v6wq645d10rbr4w5m6px0fk6csshk";
    };
    description = "Port of Game and Watch to libretro";
    license = lib.licenses.zlib;
    makefile = "Makefile";
  };

  handy = mkLibRetroCore rec {
    core = "handy";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "c9fe65d1a2df454ee11404ac27bdc9be319dd9a2";
      sha256 = "1l1gi8z68mv2cpdy7a6wvhd86q55khj3mv3drf43ak4kj2ij8cvq";
    };
    description = "Port of Handy to libretro";
    license = "Handy-License";
    makefile = "Makefile";
  };

  hatari = mkLibRetroCore rec {
    core = "hatari";
    src = fetchRetro {
      repo = core;
      rev = "ec1b59c4b6c7ca7d0d23d60cfe2cb61911b11173";
      sha256 = "1pm821s2cz93xr7qx7dv0imr44bi4pvdvlnjl486p83vff9yawfg";
    };
    description = "Port of Hatari to libretro";
    license = gpl2;
    extraBuildInputs = [ SDL zlib ];
    extraNativeBuildInputs = [ cmake which ];
    dontUseCmakeConfigure = true;
    dontConfigure = true;
    makeFlags = [ "EXTERNAL_ZLIB=1" ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];
  };

  mame = mkLibRetroCore {
    core = "mame";
    src = fetchRetro {
      repo = "mame";
      rev = "ed987ad07964a938351ff3cc1ad42e02ffd2af6d";
      sha256 = "0qc66mvraffx6ws972skx3wgblich17q6z42798qn13q1a264p4j";
    };
    description = "Port of MAME to libretro";
    license = gpl2Plus;

    extraBuildInputs = [ alsaLib libGLU libGL portaudio python27 xorg.libX11 ];
    postPatch = ''
      # Prevent the failure during the parallel building of:
      # make -C 3rdparty/genie/build/gmake.linux -f genie.make obj/Release/src/host/lua-5.3.0/src/lgc.o
      mkdir -p 3rdparty/genie/build/gmake.linux/obj/Release/src/host/lua-5.3.0/src
    '';
    makefile = "Makefile.libretro";
  };

  mame2000 = mkLibRetroCore rec {
    core = "mame2000";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "e5d4a934c60adc6d42a3f87319312aad89595a15";
      sha256 = "1zn63yqyrsnsk196v5f3nm7cx41mvsm3icpis1yxbma2r3dk3f89";
    };
    description = "Port of MAME ~2000 to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "IS_X86=0";
  };

  mame2003 = mkLibRetroCore rec {
    core = "mame2003";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "82596014905ad38c80c9eb322ab08c625d1d92cd";
      sha256 = "17dp2rz6p7q7nr0lajn3vhk9ghngxz16f7c6c87r6wgsy4y3xw0m";
    };
    description = "Port of MAME ~2003 to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
  };

  mame2003-plus = mkLibRetroCore rec {
    core = "mame2003-plus";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "0134c428b75882aa474f78dbbf2c6ecde49b97b7";
      sha256 = "0jln2ys6v9hrsrkhqd87jfslwvkca425f40mf7866g6b4pz56mwc";
    };
    description = "Port of MAME ~2003+ to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
  };

  mame2010 = mkLibRetroCore rec {
    core = "mame2010";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "d3151837758eade73c85c28c20e7d2a8706f30c6";
      sha256 = "0hj0yhc8zs32fkzn8j341ybhvrsknv0k6x0z2fv3l9ic7swgb93i";
    };
    description = "Port of MAME ~2010 to libretro";
    license = gpl2Plus;
    makefile = "Makefile";
    makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [ "PTR64=1" "ARM_ENABLED=1" "X86_SH2DRC=0" "FORCE_DRC_C_BACKEND=1" ];
  };

  mame2015 = mkLibRetroCore rec {
    core = "mame2015";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "37333ed6fda4c798a1d6b055fe4708f9f0dcf5a7";
      sha256 = "1asldlj1ywgmhabbhaagagg5hn0359122al07802q3l57ns41l64";
    };
    description = "Port of MAME ~2015 to libretro";
    license = gpl2Plus;
    extraNativeBuildInputs = [ python27 ];
    extraBuildInputs = [ alsaLib ];
    makefile = "Makefile";
  };

  mame2016 = mkLibRetroCore rec {
    core = "mame2016";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "02987af9b81a9c3294af8fb9d5a34f9826a2cf4d";
      sha256 = "0gl7irmn5d8lk7kf484vgw6kb325fq4ghwsni3il4nm5n2a8yglh";
    };
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
    extraBuildInputs = [ alsaLib ];
    postPatch = ''
      # Prevent the failure during the parallel building of:
      # make -C 3rdparty/genie/build/gmake.linux -f genie.make obj/Release/src/host/lua-5.3.0/src/lgc.o
      mkdir -p 3rdparty/genie/build/gmake.linux/obj/Release/src/host/lua-5.3.0/src
    '';
  };

  mesen = mkLibRetroCore rec {
    core = "mesen";
    src = fetchFromGitHub {
      owner = "SourMesen";
      repo = core;
      rev = "cfc5bf6976f62ebd42ea30d5a803c138fc357509";
      sha256 = "0ihlgvzvni1yqcyi5yxdvg36q20fsqd6n67zavwfb2ph09cqv7kz";
    };
    description = "Port of Mesen to libretro";
    license = gpl3;
    makefile = "Makefile";
    preBuild = "cd Libretro";
  };

  meteor = mkLibRetroCore rec {
    core = "meteor";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "3d21e3b5a7596918bee0fcaca5752ae76624c05e";
      sha256 = "0fghnxxbdrkdz6zswkd06w2r3dvr4ikvcp8jbr7nb9fc5yzn0avw";
    };
    description = "Port of Meteor to libretro";
    license = gpl3;
    makefile = "Makefile";
    preBuild = "cd libretro";
  };

  mgba = mkLibRetroCore rec {
    core = "mgba";
    src = fetchRetro {
      repo = core;
      rev = "f87f9ef6cb38537e07dcaedeb82aecac6537d42e";
      sha256 = "0yixvnzgk7qvcfz12r5y8i85czqxbxx6bvl1c7yms8riqn9ssvb7";
    };
    description = "Port of mGBA to libretro";
    license = mpl20;
  };

  mupen64plus = mkLibRetroCore {
    core = "mupen64plus-next";
    src = fetchRetro {
      repo = "mupen64plus-libretro-nx";
      rev = "81a58df0263c90b10b7fc11b6deee04d47e3aa40";
      sha256 = "1brqyrsdzdq53a68q7ph01q2bx5y4m8b3ymvpp25229imm88lgkn";
    };
    description = "Libretro port of Mupen64 Plus, GL only";
    license = gpl2;

    extraBuildInputs = [ libGLU libGL libpng nasm xorg.libX11 ];
    makefile = "Makefile";
  };

  neocd = mkLibRetroCore rec {
    core = "neocd";
    src = fetchRetro {
      repo = core + "_libretro";
      rev = "3825848fe7dd7e0ef859729eefcb29e2ea2956b7";
      sha256 = "018vfmjsx62zk45yx3pwisp4j133yxjbm7fnwwr244gnyms57711";
    };
    description = "NeoCD libretro port";
    license = gpl3;
    makefile = "Makefile";
  };

  nestopia = mkLibRetroCore rec {
    core = "nestopia";
    src = fetchRetro {
      repo = core;
      rev = "70c53f08c0cc92e90d095d6558ab737ce20431ac";
      sha256 = "1hlfqml66wy6fn40f1iiy892vq9y9fj20vv3ynd2s3b3qxhwfx73";
    };
    description = "Nestopia libretro port";
    license = gpl2;
    makefile = "Makefile";
    preBuild = "cd libretro";
  };

  np2kai = mkLibRetroCore rec {
    core = "np2kai";
    src = fetchFromGitHub rec {
      owner = "AZO234";
      repo = "NP2kai";
      rev = "4a317747724669343e4c33ebdd34783fb7043221";
      sha256 = "0kxysxhx6jyk82mx30ni0ydzmwdcbnlxlnarrlq018rsnwb4md72";
    };
    description = "Neko Project II kai libretro port";
    license = mit;
    makefile = "Makefile.libretro";
    preBuild = ''
      cd sdl2
      substituteInPlace ${makefile} \
        --replace 'GIT_VERSION :=' 'GIT_VERSION ?='
      export GIT_VERSION=${builtins.substring 0 7 src.rev}
    '';
  };

  o2em = mkLibRetroCore rec {
    core = "o2em";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "b23a796dd3490e979ff43710317df6d43bd661e1";
      sha256 = "1pkbq7nig394zdjdic0mzdsvx8xhzamsh53xh2hzznipyj46b7z0";
    };
    description = "Port of O2EM to libretro";
    license = artistic1;
    makefile = "Makefile";
  };

  opera = mkLibRetroCore rec {
    core = "opera";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "27bc2653ed469072a6a95102a8212a35fbb1e590";
      sha256 = "10cxjpsd35rb4fjc5ycs1h00gvshpn2mxxvwb6xzrfrzva0kjw1l";
    };
    description = "Opera is a port of 4DO/libfreedo to libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];
  };

  parallel-n64 = mkLibRetroCore rec {
    core = "parallel-n64";
    src = fetchRetro {
      repo = core;
      rev = "8fe07c62a364d0af1e22b7f75e839d42872dae7f";
      sha256 = "0p3fpldw6w4n4l60bv55c17vhqwq4q39fp36h8iqmnj7c32c61kf";
    };
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
    src = fetchRetro {
      repo = core;
      rev = "8fda5dd0e28fe46621fb1ab57781c316143017da";
      sha256 = "0k371d0xqzqwy8ishvxssgasm36q83qj7ksn2av110n879n4knwb";
    };
    description = "Port of PCSX ReARMed with GNU lightning to libretro";
    license = gpl2;
    dontConfigure = true;
  };

  picodrive = mkLibRetroCore rec {
    core = "picodrive";
    src = fetchRetro {
      repo = core;
      rev = "600894ec6eb657586a972a9ecd268f50907a279c";
      sha256 = "1bxphwnq4b80ssmairy8sfc5cp4m6jyvrcjcj63q1vk7cs6qls7p";
    };
    description = "Fast MegaDrive/MegaCD/32X emulator";
    license = "MAME";

    extraBuildInputs = [ libpng SDL ];
    SDL_CONFIG = "${SDL.dev}/bin/sdl-config";
    dontAddPrefix = true;
    configurePlatforms = [];
    makeFlags = lib.optional stdenv.hostPlatform.isAarch64 [ "platform=aarch64" ];
  };

  play = mkLibRetroCore {
    core = "play";
    src = fetchRetro {
      repo = "play-";
      rev = "884ae3b96c631f235cd18b2643d1f318fa6951fb";
      sha256 = "0m9pk20jh4y02visgzfw64bpbw93bzs15x3a3bnd19yivm34dbfc";
    };
    description = "Port of Play! to libretro";
    license = bsd2;
    extraBuildInputs = [ boost ];
    extraNativeBuildInputs = [ cmake openssl curl icu libGL libGLU xorg.libX11 ];
    makefile = "Makefile";
    cmakeFlags = [ "-DBUILD_PLAY=OFF -DBUILD_LIBRETRO_CORE=ON" ];
    postBuild = "mv Source/ui_libretro/play_libretro${stdenv.hostPlatform.extensions.sharedLibrary} play_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  ppsspp = mkLibRetroCore {
    core = "ppsspp";
    src = fetchgit {
      url = "https://github.com/hrydgard/ppsspp";
      rev = "bf1777f7d3702e6a0f71c7ec1fc51976e23c2327";
      sha256 = "17sym0vk72lzbh9a1501mhw98c78x1gq7k1fpy69nvvb119j37wa";
    };
    description = "ppsspp libretro port";
    license = gpl2;
    extraNativeBuildInputs = [ cmake pkg-config ];
    extraBuildInputs = [ libGLU libGL libzip ffmpeg_3 python37 snappy xorg.libX11 ];
    makefile = "Makefile";
    cmakeFlags = [ "-DLIBRETRO=ON -DUSE_SYSTEM_FFMPEG=ON -DUSE_SYSTEM_SNAPPY=ON -DUSE_SYSTEM_LIBZIP=ON -DOpenGL_GL_PREFERENCE=GLVND" ];
    postBuild = "mv lib/ppsspp_libretro${stdenv.hostPlatform.extensions.sharedLibrary} ppsspp_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  prboom = mkLibRetroCore rec {
    core = "prboom";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "991016b3c7a9c8b0e49b2bc9c72f68c60800fc7b";
      sha256 = "1abv9qgfvh3x84shgyl3y90bjz77mjj17vibag7bg6i8hgjikjgq";
    };
    description = "Prboom libretro port";
    license = gpl2;
    makefile = "Makefile";
  };

  prosystem = mkLibRetroCore rec {
    core = "prosystem";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "6f7e34aea89db5ba2fbf674e5ff0ad6fc68a198e";
      sha256 = "0pqkb0f51s8ma0l4m9xk2y85z2kh3fgay9g4g8fingbgqq1klvzs";
    };
    description = "Port of ProSystem to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  quicknes = mkLibRetroCore {
    core = "quicknes";
    src = fetchRetro {
      repo = "QuickNES_Core";
      rev = "31654810b9ebf8b07f9c4dc27197af7714364ea7";
      sha256 = "15fr5a9hv7wgndb0fpmr6ws969him41jidzir2ix9xkb0mmvcm86";
    };
    description = "QuickNES libretro port";
    license = lgpl21Plus;
    makefile = "Makefile";
  };

  sameboy = mkLibRetroCore rec {
    core = "sameboy";
    src = fetchRetro {
      repo = "sameboy";
      rev = "c9e547c1063fd62c40a4b7a86e7db99dc9089051";
      sha256 = "0bff6gicm24d7h270aqvgd8il6mi7j689nj5zl9ij0wc77hrrpmq";
    };
    description = "SameBoy libretro port";
    license = mit;
    extraNativeBuildInputs = [ which hexdump ];
    preBuild = "cd libretro";
    makefile = "Makefile";
  };

  scummvm = mkLibRetroCore rec {
    core = "scummvm";
    src = fetchRetro {
      repo = core;
      rev = "de91bf9bcbf4449f91e2f50fde173496a2b52ee0";
      sha256 = "06h9xaf2b1cjk85nbslpjj0fm9iy9b2lxr1wf3i09hgs4sh6x464";
    };
    description = "Libretro port of ScummVM";
    license = gpl2;
    extraBuildInputs = [ fluidsynth libjpeg libvorbis libGLU libGL SDL ];
    makefile = "Makefile";
    preConfigure = "cd backends/platform/libretro/build";
  };

  smsplus-gx = mkLibRetroCore rec {
    core = "smsplus";
    src = fetchRetro {
      repo = core + "-gx";
      rev = "36c82768c03d889f1cf4b66369edac2297acba32";
      sha256 = "1f9waikyp7kp2abb76wlv9hmf2jpc76zjmfqyc7wk2pc70ljm3l4";
    };
    description = "SMS Plus GX libretro port";
    license = gpl2Plus;
  };

  snes9x = mkLibRetroCore rec {
    core = "snes9x";
    src = fetchFromGitHub {
      owner = "snes9xgit";
      repo = core;
      rev = "bd9246ddd75a5e9f78d6189c8c57754d843630f7";
      sha256 = "10fm7ah3aha9lf4k9hgw0dlhdvshzpig2d0ylcb12gf9zz0i22ns";
    };
    description = "Port of SNES9x git to libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    preBuild = "cd libretro";
  };

  snes9x2002 = mkLibRetroCore rec {
    core = "snes9x2002";
    src = fetchRetro {
      repo = core;
      rev = "a869da7f22c63ee1cb316f79c6dd7691a369da3e";
      sha256 = "11lcwscnxg6sk9as2xlr4nai051qhidbsymyis4nz3r4dmgzf8j8";
    };
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    license = "Non-commercial";
    makefile = "Makefile";
  };

  snes9x2005 = mkLibRetroCore rec {
    core = "snes9x2005";
    src = fetchRetro {
      repo = core;
      rev = "c216559b9e0dc3d7f059dcf31b813402ad47fea5";
      sha256 = "19b2rpj6i32c34ryvlna4yca84y5ypza78w4x9l17qlhp021h9pv";
    };
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    license = "Non-commercial";
    makefile = "Makefile";
    makeFlags = [ "USE_BLARGG_APU=1" ];
    postBuild = "mv snes9x2005_plus_libretro${stdenv.hostPlatform.extensions.sharedLibrary} snes9x2005_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  snes9x2010 = mkLibRetroCore rec {
    core = "snes9x2010";
    src = fetchRetro {
      repo = core;
      rev = "ba9f2240360f8db270fb6ba5465c79c317070560";
      sha256 = "00y53sjrsp8sccpp1qqw88iawsz30g6d370cbqcxs4ya1r6awn5x";
    };
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    license = "Non-commercial";
  };

  stella = mkLibRetroCore rec {
    core = "stella";
    src = fetchFromGitHub {
      owner = "stella-emu";
      repo = core;
      rev = "506bb0bd0618e676b1959931dcc00a9d0f5f0f3d";
      sha256 = "09nclx0ksixngnxkkjjcyhf3d0vl4ykm8fx7m307lvag8nxj7z03";
    };
    description = "Port of Stella to libretro";
    license = gpl2;
    extraBuildInputs = [ libpng pkg-config SDL ];
    makefile = "Makefile";
    preBuild = "cd src/libretro";
    dontConfigure = true;
  };

  stella2014 = mkLibRetroCore rec {
    core = "stella2014";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "fc87f2c78d3b177f4b9b19698557dce452ac3ce7";
      sha256 = "0yqzavk1w0d0ngpls32c4wlihii97fz2g6zsgadhm48apwjvn3xx";
    };
    description = "Port of Stella to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  tgbdual = mkLibRetroCore rec {
    core = "tgbdual";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "9be31d373224cbf288db404afc785df41e61b213";
      sha256 = "19m3f3hj3jyg711z1xq8qn1hgsr593krl6s6hi0r6vf8p5x0zbzw";
    };
    description = "Port of TGBDual to libretro";
    license = gpl2;
    makefile = "Makefile";
  };

  thepowdertoy = mkLibRetroCore rec {
    core = "thepowdertoy";
    src = fetchRetro {
      repo = "ThePowderToy";
      rev = "0ff547e89ae9d6475b0226db76832daf03eec937";
      sha256 = "kDpmo/RPYRvROOX3AhsB5pIl0MfHbQmbyTMciLPDNew=";
    };
    description = "Port of The Powder Toy to libretro";
    license = gpl3Only;
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    postBuild = "cd src/";
  };

  tic80 = mkLibRetroCore {
    core = "tic80";
    src = fetchRetro {
      repo = "tic-80";
      rev = "f43bad908d5f05f2a66d5cd1d6f21b234d4abd2c";
      sha256 = "0bp34r8qqyw52alws1z4ib9j7bs4d641q6nvqszd07snp9lpvwym";
    };
    description = "Port of TIC-80 to libretro";
    license = mit;
    extraNativeBuildInputs = [ cmake pkg-config ];
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
    src = fetchRetro {
      repo = core;
      rev = "019132daf41e33a9529036b8728891a221a8ce2e";
      sha256 = "0hab4rhvvcg30jifd9h9jq5q2vqk2hz5i1q456w6v2d10hl1lf15";
    };
    description = "VBA-M libretro port with modifications for speed";
    license = gpl2;
  };

  vba-m = mkLibRetroCore rec {
    core = "vbam";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "7d88e045a2fe44e56b3f84846beec446b4c4b2d9";
      sha256 = "04f8adg99a36qkqhij54vkw5z18m5ld33p78lbmv8cxk7k7g7yhy";
    };
    description = "vanilla VBA-M libretro port";
    license = gpl2;
    makefile = "Makefile";
    preBuild = "cd src/libretro";
  };

  vecx = mkLibRetroCore rec {
    core = "vecx";
    src = fetchRetro {
      repo = "libretro-" + core;
      rev = "321205271b1c6be5dbdb8d309097a5b5c2032dbd";
      sha256 = "1w54394yhf2yqmq1b8wi5y7lvixc5hpjxpyiancrdbjd0af7pdvd";
    };
    description = "Port of Vecx to libretro";
    license = gpl3;
  };

  virtualjaguar = mkLibRetroCore rec {
    core = "virtualjaguar";
    src = fetchRetro {
      repo = core + "-libretro";
      rev = "a162fb75926f5509f187e9bfc69958bced40b0a6";
      sha256 = "06k8xpn5y9rzmi2lwfw0v9v9pz4wvmpalycc608bw9cl39lmz10h";
    };
    description = "Port of VirtualJaguar to libretro";
    license = gpl3;
    makefile = "Makefile";
  };

  yabause = mkLibRetroCore rec {
    core = "yabause";
    src = fetchRetro {
      repo = core;
      rev = "9be109f9032afa793d2a79b837c4cc232cea5929";
      sha256 = "0aj862bs4dmnldy62wdssj5l63ibfkbzqvkxcqa3wyvdz4i367jc";
    };
    description = "Port of Yabause to libretro";
    license = gpl2;
    makefile = "Makefile";
    # Disable SSE for non-x86. DYNAREC doesn't build on either Aarch64 or x86_64.
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "HAVE_SSE=0";
    preBuild = "cd yabause/src/libretro";
  };

}
