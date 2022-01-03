{ pname, version, src, branchDesc, branchName
, lib, stdenv, config, fetchFromGitHub
, catch2, cmake, ninja, pkg-config, wrapQtAppsHook
, enet, fmt, inih, libressl, soundtouch, zstd, discord-rpc
, boost173, ffmpeg, libusb1, qtbase, qtdeclarative, qtmultimedia, qttools, rapidjson, SDL2
, alsaSupport      ? stdenv.isLinux,                      alsa-lib
, discordSupport   ? true
, fdkSupport       ? true,                                fdk_aac
, jackaudioSupport ? true,                                libjack2
, onlineSupport    ? true
, pulseSupport     ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, sndioSupport     ? true,                                sndio
, udevSupport      ? stdenv.isLinux,                      udev
}:

with lib;
let
  cpp-jwt-src = fetchFromGitHub {
    owner = "arun11299";
    repo = "cpp-jwt";
    rev = "6e27aa4c8671e183f11e327a2e1f556c64fdc4a9";
    sha256 = "1mqcgyp9sm846n8za85i18hgw2x0z8f0npdgfpd9gykzwf72mqmv";
  };
  cryptopp-src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "f320e7d92a33ee80ae42deef79da78cfc30868af";
    sha256 = "19sxiwzbr82zhjm36qd2p1zx710ilzgvj9945yd5mz7bvzpbpw5q";
  };
  cubeb-src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "1d66483ad2b93f0e00e175f9480c771af90003a7";
    sha256 = "06rlmdarrk9hwm8svmh2nl2cd4ybmzm2jhp7ih6xzzrba31hg7n3";
    fetchSubmodules = true;
  };
  dynarmic-src = fetchFromGitHub {
    owner = "citra-emu";
    repo = "dynarmic";
    rev = "af0d4a7c18ee90d544866a8cf24e6a0d48d3edc4";
    sha256 = "1hsl8vdd2y2h2rmhx3bvh4a8l3m33xnsnk5v64jkwdfcl15iyh2a";
  };
  lodepng-src = fetchFromGitHub {
    owner = "lvandeve";
    repo = "lodepng";
    rev = "31d9704fdcca0b68fb9656d4764fa0fb60e460c2";
    sha256 = "1il97cq1rms3078zsyq00acgb75kva1smcrkb8r450p6c1rmwsii";
  };
  nihstro-src = fetchFromGitHub {
    owner = "neobrain";
    repo = "nihstro";
    rev = "fd69de1a1b960ec296cc67d32257b0f9e2d89ac6";
    sha256 = "1lfx92lpszmz1xsvb80a349r3i7g5msxixkb29v1qvi4a8v3ak58";
  };
  soundtouch-src = fetchFromGitHub {
    owner = "citra-emu";
    repo = "ext-soundtouch";
    rev = "060181eaf273180d3a7e87349895bd0cb6ccbf4a";
    sha256 = "0x92a5wb2hcaqzckpdqsggbf863a9kicpa4xz4g4gdyid19n3ci9";
  };
  teakra-src = fetchFromGitHub {
    owner = "wwylele";
    repo = "teakra";
    rev = "3e032a73d7e97eb434a053391d95029eebd7e189";
    sha256 = "1cpxj8jvkj52f3jpy7rsgzs09h8cd3jmx6f2282dh9w2daaga4w8";
  };
  xbyak-src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    rev = "c306b8e5786eeeb87b8925a8af5c3bf057ff5a90";
    sha256 = "13l5yyaf67h6s0zlzksah4rybv4xsl1a7939frvwahxch88wfslr";
  };
  # Last updated Thu, 28 Oct 2021 12:43:04 GMT from https://api.citra-emu.org/gamedb/
  compat-src = ./compatibility_list.json;
in stdenv.mkDerivation {
  inherit pname version src;
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DCITRA_USE_BUNDLED_SDL2=OFF"
    "-DCITRA_USE_BUNDLED_QT=OFF"
    "-DCITRA_USE_BUNDLED_FFMPEG=OFF"
    "-DDYNARMIC_ENABLE_CPU_FEATURE_DETECTION=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # Sacrifices reproducibility
    "-DCITRA_ENABLE_COMPATIBILITY_REPORTING=ON"
    "-DENABLE_FFMPEG_VIDEO_DUMPER=ON"
    "-DENABLE_QT_TRANSLATION=ON"
    "-DUSE_SYSTEM_BOOST=ON"
    "-GNinja"
    "-Wno-dev"
    "-DUSE_DISCORD_PRESENCE=${if discordSupport then "ON" else "OFF"}"
    "-DENABLE_WEB_SERVICE=${if onlineSupport then "ON" else "OFF"}"
    (if fdkSupport     then "-DENABLE_FDK=ON"           else "-DENABLE_FFMPEG_AUDIO_DECODER=ON")
  ];

  nativeBuildInputs = [ catch2 cmake ninja pkg-config qttools wrapQtAppsHook
    enet fmt inih libressl soundtouch zstd discord-rpc
  ];
  buildInputs = [ boost173 ffmpeg libusb1 qtbase qtdeclarative qtmultimedia rapidjson SDL2
  ] ++ optional alsaSupport        alsa-lib
    ++ optional fdkSupport         fdk_aac
    ++ optional jackaudioSupport   libjack2
    ++ optional pulseSupport       libpulseaudio
    ++ optional sndioSupport       sndio
    ++ optional udevSupport        udev;

  postPatch = ''
    # Manually prepare all our externals instead of fetching git submodules.
    # It's important we copy and not link the sources so we can trick the configure system later on.
    # Prep boost
    rm -r ./externals/boost
    pushd ./externals
    tar xf ${boost173.src}
    mv boost_* boost
    popd
    # Prep catch
    rm -r ./externals/catch
    cp -r ${catch2.src} ./externals/catch
    # Prep cpp-jwt
    rm -r ./externals/cpp-jwt
    cp -r ${cpp-jwt-src} ./externals/cpp-jwt
    # Prep cryptopp
    rm -r ./externals/cryptopp/cryptopp
    cp -r ${cryptopp-src} ./externals/cryptopp/cryptopp
    # Prep cubeb
    rm -r ./externals/cubeb
    cp -r ${cubeb-src} ./externals/cubeb
    # Prep discord-rpc
    rm -r ./externals/discord-rpc
    cp -r ${discord-rpc.src} ./externals/discord-rpc
    # Prep dynarmic
    rm -r ./externals/dynarmic
    cp -r ${dynarmic-src} ./externals/dynarmic
    # Prep enet
    rm -r ./externals/enet
    pushd ./externals
    tar xf ${enet.src}
    mv enet-* enet
    popd
    # Prep fmt
    rm -r ./externals/fmt
    cp -r ${fmt.src} ./externals/fmt
    # Prep inih
    rm -r ./externals/inih/inih
    cp -r ${inih.src} ./externals/inih/inih
    # Prep libressl
    rm -r ./externals/libressl
    pushd ./externals
    tar xf ${libressl.src}
    mv libressl-* libressl
    popd
    # Prep libusb
    rm -r ./externals/libusb/libusb
    cp -r ${libusb1.src} ./externals/libusb/libusb
    # Prep lodepng
    rm -r ./externals/lodepng/lodepng
    cp -r ${lodepng-src} ./externals/lodepng/lodepng
    # Prep nihstro
    rm -r ./externals/nihstro
    cp -r ${nihstro-src} ./externals/nihstro
    # Prep soundtouch
    rm -r ./externals/soundtouch
    cp -r ${soundtouch-src} ./externals/soundtouch
    # Prep teakra
    rm -r ./externals/teakra
    cp -r ${teakra-src} ./externals/teakra
    # Prep xbyak
    rm -r ./externals/xbyak
    cp -r ${xbyak-src} ./externals/xbyak
    # Prep zstd
    rm -r ./externals/zstd
    cp -r ${zstd.src} ./externals/zstd
    # Prep compatibilitylist
    cp -r ${compat-src} ./dist/compatibility_list/compatibility_list.json
  '';

  preConfigure = ''
    # Trick the configure system. CMakeLists.txt#L55 function(check_submodules_present)
    chmod 775 -R ./externals
    sed -n 's,^ *path = \(.*\),\1,p' .gitmodules | while read path; do
      mkdir "$path/.git"
    done
  '';

  meta = with lib; {
    homepage = "https://citra-emu.org";
    description = branchDesc;
    longDescription = ''
      A Nintendo 3DS Emulator written in C++
      Using the nightly branch is recommanded for general usage.
      Using the canary branch is recommanded if you would like to try out experimental features, with a cost of stability.
    '';
    maintainers = with maintainers; [ ivar joshuafern ];
    platforms = with platforms; linux;
  };
}
