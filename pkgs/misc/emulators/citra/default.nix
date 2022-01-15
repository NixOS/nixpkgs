{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, boost17x
, pkg-config
, libusb1
, zstd
, libressl
, enableSdl2 ? true, SDL2
, enableQt ? true, qtbase, qtmultimedia
, enableQtTranslation ? enableQt, qttools
, enableWebService ? true
, enableCubeb ? true, libpulseaudio
, enableFfmpegAudioDecoder ? true
, enableFfmpegVideoDumper ? true
, ffmpeg
, useDiscordRichPresence ? true, rapidjson
, enableFdk ? false, fdk_aac
}:
assert lib.assertMsg (!enableFfmpegAudioDecoder || !enableFdk) "Can't enable both enableFfmpegAudioDecoder and enableFdk";

stdenv.mkDerivation {
  pname = "citra";
  version = "2021-11-01";

  src = fetchFromGitHub {
    owner = "citra-emu";
    repo = "citra";
    rev = "5a7d80172dd115ad9bc6e8e85cee6ed9511c48d0";
    sha256 = "sha256-vy2JMizBsnRK9NBEZ1dxT7fP/HFhOZSsC+5P+Dzi27s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals enableQt [ wrapQtAppsHook ];

  buildInputs = [
    boost17x
    libusb1
  ]
  ++ lib.optionals enableSdl2 [ SDL2 ]
  ++ lib.optionals enableQt [ qtbase qtmultimedia ]
  ++ lib.optionals enableQtTranslation [ qttools ]
  ++ lib.optionals enableCubeb [ libpulseaudio ]
  ++ lib.optionals (enableFfmpegAudioDecoder || enableFfmpegVideoDumper) [ ffmpeg ]
  ++ lib.optionals useDiscordRichPresence [ rapidjson ]
  ++ lib.optionals enableFdk [ fdk_aac ];

  cmakeFlags = [
    "-DUSE_SYSTEM_BOOST=ON"
  ]
  ++ lib.optionals (!enableSdl2) [ "-DENABLE_SDL2=OFF" ]
  ++ lib.optionals (!enableQt) [ "-DENABLE_QT=OFF" ]
  ++ lib.optionals enableQtTranslation [ "-DENABLE_QT_TRANSLATION=ON" ]
  ++ lib.optionals (!enableWebService) [ "-DENABLE_WEB_SERVICE=OFF" ]
  ++ lib.optionals (!enableCubeb) [ "-DENABLE_CUBEB=OFF" ]
  ++ lib.optionals enableFfmpegAudioDecoder [ "-DENABLE_FFMPEG_AUDIO_DECODER=ON"]
  ++ lib.optionals enableFfmpegVideoDumper [ "-DENABLE_FFMPEG_VIDEO_DUMPER=ON" ]
  ++ lib.optionals useDiscordRichPresence [ "-DUSE_DISCORD_PRESENCE=ON" ]
  ++ lib.optionals enableFdk [ "-DENABLE_FDK=ON" ];

  postPatch = ''
    # We already know the submodules are present
    substituteInPlace CMakeLists.txt \
      --replace "check_submodules_present()" ""

    # Devendoring
    rm -rf externals/zstd externals/libressl
    cp -r ${zstd.src} externals/zstd
    tar xf ${libressl.src} -C externals/
    mv externals/${libressl.name} externals/libressl
    chmod -R a+w externals/zstd
  '';

  # Todo: cubeb audio backend (the default one) doesn't work on the SDL interface.
  # This seems to be a problem with libpulseaudio, other applications have similar problems (e.g Duckstation).
  # Note that the two interfaces have two separate configuration files.

  meta = with lib; {
    homepage = "https://citra-emu.org";
    description = "An open-source emulator for the Nintendo 3DS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
