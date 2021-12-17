{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, SDL2
, qtbase
, wrapQtAppsHook
, qttools
, ninja
, gtk3
, libevdev
, curl
, libpulseaudio
, sndio
, mesa
, vulkan-loader
, wayland
}:
mkDerivation rec {
  pname = "duckstation";
  version = "unstable-2021-10-29";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = pname;
    rev = "287b1e1abc98ef3f01d8530e0b428b58d8e77e96";
    sha256 = "sha256-1s7oBdOOkK6a3DKCZ70dAilFzlzrURwhx+MRTmOPWJE=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config extra-cmake-modules wrapQtAppsHook qttools ];

  buildInputs = [
    SDL2
    qtbase
    gtk3
    libevdev
    sndio
    mesa
    curl
    libpulseaudio
    wayland
    vulkan-loader
  ];

  cmakeFlags = [
    "-DUSE_DRMKMS=ON" # Broken in combination with Wayland, https://github.com/stenzek/duckstation/issues/2630
    "-DUSE_WAYLAND=ON"
  ];

  postPatch = ''
    substituteInPlace extras/linux-desktop-files/duckstation-qt.desktop \
      --replace "duckstation-qt" "duckstation" \
      --replace "TryExec=duckstation" "tryExec=duckstation-qt" \
      --replace "Exec=duckstation" "Exec=duckstation-qt"
    substituteInPlace extras/linux-desktop-files/duckstation-nogui.desktop \
      --replace "duckstation-nogui" "duckstation" \
      --replace "TryExec=duckstation" "tryExec=duckstation-nogui" \
      --replace "Exec=duckstation" "Exec=duckstation-nogui"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share $out/share/pixmaps $out/share/applications
    rm bin/common-tests

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-{qt,nogui} $out/bin/

    cp ../extras/icons/icon-256px.png $out/share/pixmaps/duckstation.png
    cp ../extras/linux-desktop-files/* $out/share/applications/
    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./bin/common-tests
    runHook postCheck
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  # TODO:
  # - default sound backend (cubeb) does not work, but SDL does. Strangely, switching to cubeb while a game is running makes it work.

  meta = with lib; {
    description = "PlayStation 1 emulator focusing on playability, speed and long-term maintainability";
    homepage = "https://github.com/stenzek/duckstation";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.guibou ];
  };
}
