{ pname, version, src, branchName
, stdenv, lib, fetchFromGitHub, wrapQtAppsHook
, cmake, pkg-config
, libpulseaudio, libjack2, alsaLib, sndio, ecasound
, vulkan-loader, vulkan-headers
, qtbase, qtwebengine, qttools
, nlohmann_json, rapidjson
, zlib, zstd, libzip, lz4
, glslang
, boost173
, catch2
, fmt
, SDL2
, udev
, libusb1
, ffmpeg
}:

stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    libpulseaudio libjack2 alsaLib sndio ecasound
    vulkan-loader vulkan-headers
    qtbase qtwebengine qttools
    nlohmann_json rapidjson
    zlib zstd libzip lz4
    glslang
    boost173
    catch2
    fmt
    SDL2
    udev
    libusb1
    ffmpeg
  ];

  cmakeFlags = [
    "-DENABLE_QT_TRANSLATION=ON"
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
  ];

  # Trick the configure system. This prevents a check for submodule directories.
  preConfigure = ''
    rm -f .gitmodules
  '';

  # Fix vulkan detection
  postFixup = ''
    wrapProgram $out/bin/yuzu --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    wrapProgram $out/bin/yuzu-cmd --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  meta = with lib; {
    homepage = "https://yuzu-emu.org";
    description = "The ${branchName} branch of an experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the mainline branch is recommanded for general usage.
      Using the early-access branch is recommanded if you would like to try out experimental features, with a cost of stability.
    '';
    license = with licenses; [
      gpl2Plus
      # Icons
      cc-by-nd-30 cc0
    ];
    maintainers = with maintainers; [ ivar joshuafern ];
    platforms = platforms.linux;
  };
}
