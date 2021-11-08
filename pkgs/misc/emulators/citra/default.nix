{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, SDL2
, qtbase
, qtmultimedia
, boost17x
, libpulseaudio
, pkg-config
, libusb1
, zstd
, libressl
, alsa-lib
, rapidjson
, aacHleDecoding ? true
, fdk_aac
, ffmpeg-full
}:

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

  nativeBuildInputs = [ cmake wrapQtAppsHook pkg-config ];
  buildInputs = [
    SDL2
    qtbase
    qtmultimedia
    libpulseaudio
    boost17x
    libusb1
    alsa-lib
    rapidjson # for discord-rpc
  ] ++ lib.optional aacHleDecoding [ fdk_aac ffmpeg-full ];

  cmakeFlags = [
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
  ] ++ lib.optionals aacHleDecoding [
    "-DENABLE_FFMPEG_AUDIO_DECODER=ON"
    "-DCITRA_USE_BUNDLED_FFMPEG=OFF"
  ];

  postPatch = ''
    # we already know the submodules are present
    substituteInPlace CMakeLists.txt \
      --replace "check_submodules_present()" ""

    # Trick configure system.
    sed -n 's,^ *path = \(.*\),\1,p' .gitmodules | while read path; do
    mkdir "$path/.git"
    done

    rm -rf externals/zstd externals/libressl
    cp -r ${zstd.src} externals/zstd
    tar xf ${libressl.src} -C externals/
    mv externals/${libressl.name} externals/libressl
    chmod -R a+w externals/zstd
  '';

  # Todo: cubeb audio backend (the default one) doesn't work on the SDL interface.
  # Note that the two interfaces have two separate configuration files.

  meta = with lib; {
    homepage = "https://citra-emu.org";
    description = "An open-source emulator for the Nintendo 3DS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
