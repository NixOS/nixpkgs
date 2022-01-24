{ pname, version, src, branchDesc
, lib, stdenv, config, fetchFromGitHub
, catch2, cmake, ninja, pkg-config, wrapQtAppsHook
, qtbase, qtdeclarative, qtmultimedia, qttools
, boost17x, ffmpeg, libusb1, rapidjson, SDL2, zstd, libressl
, alsaSupport      ? stdenv.isLinux, alsa-lib
, pulseSupport     ? stdenv.isLinux, libpulseaudio
, udevSupport      ? stdenv.isLinux, udev
, sndioSupport     ? true, sndio
, fdkSupport       ? true, fdk_aac
, jackaudioSupport ? true, libjack2
, discordSupport   ? true
, onlineSupport    ? true
}:

let
  inherit (lib) optional;
  compat-src = ./compatibility_list.json; # Updated 1/12/22 from https://api.citra-emu.org/gamedb/
in stdenv.mkDerivation {
  inherit pname version src;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DCITRA_ENABLE_COMPATIBILITY_REPORTING=ON"
    "-DCITRA_USE_BUNDLED_FFMPEG=OFF"
    "-DCITRA_USE_BUNDLED_QT=OFF"
    "-DCITRA_USE_BUNDLED_SDL2=OFF"
    "-DDYNARMIC_ENABLE_CPU_FEATURE_DETECTION=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # Sacrifices reproducibility
    "-DENABLE_FFMPEG_VIDEO_DUMPER=ON"
    "-DENABLE_QT_TRANSLATION=ON"
    "-DUSE_SYSTEM_BOOST=ON"
    "-GNinja"
    "-Wno-dev"
    "-DUSE_DISCORD_PRESENCE=${if discordSupport then "ON" else "OFF"}"
    "-DENABLE_WEB_SERVICE=${if onlineSupport then "ON" else "OFF"}"
    (if fdkSupport then "-DENABLE_FDK=ON" else "-DENABLE_FFMPEG_AUDIO_DECODER=ON")
  ];

  nativeBuildInputs = [ catch2 cmake ninja pkg-config qttools wrapQtAppsHook ];

  buildInputs = [ boost17x ffmpeg libusb1 qtbase qtdeclarative qtmultimedia rapidjson SDL2
  ] ++ optional alsaSupport      alsa-lib
    ++ optional fdkSupport       fdk_aac
    ++ optional jackaudioSupport libjack2
    ++ optional pulseSupport     libpulseaudio
    ++ optional sndioSupport     sndio
    ++ optional udevSupport      udev;

  postPatch = ''
    # Prep compatibilitylist
    ln -s ${compat-src} ./dist/compatibility_list/compatibility_list.json

    # Devendor some submodules
    rm -rf externals/{libressl,zstd}
    tar -xf ${libressl.src} --strip-components 1 --one-top-level="externals/libressl"
    cp -r ${zstd.src} ./externals/zstd
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
    platforms = platforms.linux;
    mainProgram = "citra-qt";
  };
}
