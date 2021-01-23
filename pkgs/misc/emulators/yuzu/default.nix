{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, wrapQtAppsHook
, boost173, catch2, fmt, lz4, nlohmann_json, rapidjson, zlib, zstd, SDL2
, udev, libusb1, libzip, qtbase, qtwebengine, qttools, ffmpeg
, libpulseaudio, libjack2, alsaLib, sndio, ecasound
, useVulkan ? true, vulkan-loader, vulkan-headers
}:

stdenv.mkDerivation rec {
  pname = "yuzu";
  version = "482";

  src = fetchFromGitHub {
    owner = "yuzu-emu";
    repo = "yuzu-mainline"; # They use a separate repo for mainline “branch”
    rev = "mainline-0-${version}";
    sha256 = "1bhkdbhj1dv33qv0np26gzsw65p4z88whjmd6bc7mh2b5lvrjwxm";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ qtbase qtwebengine qttools boost173 catch2 fmt lz4 nlohmann_json rapidjson zlib zstd SDL2 udev libusb1 libpulseaudio alsaLib sndio ecasound libjack2 libzip ffmpeg ]
    ++ lib.optionals useVulkan [ vulkan-loader vulkan-headers ];
  cmakeFlags = [ "-DENABLE_QT_TRANSLATION=ON" "-DYUZU_USE_QT_WEB_ENGINE=ON" "-DUSE_DISCORD_PRESENCE=ON" ]
    ++ lib.optionals (!useVulkan) [ "-DENABLE_VULKAN=No" ];

  # Trick the configure system. This prevents a check for submodule directories.
  preConfigure = "rm .gitmodules";

  # Fix vulkan detection
  postFixup = lib.optionals useVulkan ''
    wrapProgram $out/bin/yuzu --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    wrapProgram $out/bin/yuzu-cmd --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  meta = with lib; {
    homepage = "https://yuzu-emu.org";
    description = "An experimental Nintendo Switch emulator written in C++";
    license = with licenses; [
      gpl2Plus
      # Icons
      cc-by-nd-30 cc0
    ];
    maintainers = with maintainers; [ ivar joshuafern ];
    platforms = platforms.linux;
  };
}
