{ pname, version, src, branchName
, stdenv, lib, fetchFromGitHub, fetchpatch, wrapQtAppsHook
, cmake, pkg-config
, libpulseaudio, libjack2, alsaLib, sndio
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
    libpulseaudio libjack2 alsaLib sndio
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

  patches = [
    (fetchpatch { # Without this, yuzu tries to read version info from .git which is not present.
      url = "https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/28cbf656e3188b80eda0031d0b2713708ecd630f/inject-git-info.patch";
      sha256 = "1zxh5fwdr7jl0aagb3yfwd0995vyyk54f0f748f7c4rqvg6867fd";
    })
  ];

  cmakeFlags = [
    "-DENABLE_QT_TRANSLATION=ON"
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
    # Shows errors about not being able to find .git at runtime if you do not set these
    "-DGIT_BRANCH=\"\""
    "-DGIT_DESC=\"\""
  ];

  preConfigure = ''
    # Trick the configure system. This prevents a check for submodule directories.
    rm -f .gitmodules

    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=\"yuzu ${branchName} ${version}\""
      "-DTITLE_BAR_FORMAT_RUNNING=\"yuzu ${branchName} ${version} \| \{3\}\""
    )
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
