{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, bluez, ffmpeg, libao, libGL, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libXxf86vm, libXinerama, libSM, readline
, openal, libXdmcp, portaudio, libusb, libevdev, miniupnpc, sfml, mbedtls
, curl, wxGTKDev_2, libpng, hidapi
, alsaLib, libpulseaudio
, qt5

# - Inputs used for Darwin
, CoreBluetooth, cf-private, ForceFeedback, IOKit, OpenGL

# options
, dolphin-wxgui ? true
, dolphin-qtgui ? false
}:
# XOR: ensure only wx XOR qt are enabled
assert dolphin-wxgui || dolphin-qtgui;
assert !(dolphin-wxgui && dolphin-qtgui);

stdenv.mkDerivation rec {
  name = "dolphin-emu-2018-04-30";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "ad098283c023b0f5f0d314c646bc5d5756c35e3d";
    sha256 = "17fv3vz0nc5jax1bbl4wny1kzsshbbhms82dxd8rzcwwvd2ad1g7";
  };

  cmakeFlags =
    [ "-DENABLE_LTO=True" ]
    ++ lib.optional (!dolphin-qtgui) "-DENABLE_QT2=False"
    ++ lib.optional stdenv.isDarwin "-DOSX_USE_DEFAULT_SEARCH_PATH=True"
    ++ lib.optionals dolphin-wxgui [
      "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
      "-DGTK2_GDKCONFIG_INCLUDE_DIR=${wxGTKDev_2.gtk.out}/lib/gtk-2.0/include"
      "-DGTK2_INCLUDE_DIRS=${wxGTKDev_2.gtk.dev}/include/gtk-2.0"
    ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ curl ffmpeg libao libGL glib pcre miniupnpc sfml
                  gettext libpthreadstubs libXrandr libXext libXxf86vm libXinerama libSM readline openal
                  libXdmcp portaudio libusb libpng hidapi
                ] ++ lib.optionals stdenv.isDarwin [ CoreBluetooth cf-private ForceFeedback IOKit OpenGL ]
                  ++ lib.optionals stdenv.isLinux [ alsaLib libpulseaudio bluez libevdev ]
                  ++ lib.optionals dolphin-wxgui [ wxGTKDev_2 wxGTKDev_2.gtk ]
                  ++ lib.optional dolphin-qtgui qt5.qtbase;

  # - Change install path to Applications relative to $out
  # - Allow Dolphin to use nix-provided libraries instead of building them
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e 's,/Applications,Applications,g' Source/Core/DolphinWX/CMakeLists.txt
    sed -i -e 's,if(LIBUSB_FOUND AND NOT APPLE),if(LIBUSB_FOUND),g' CMakeLists.txt
    sed -i -e 's,if(NOT APPLE),if(true),g' CMakeLists.txt
  '';

  preInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications"
  '';

  meta = {
    homepage = http://dolphin-emu.org/;
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARM";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
    branch = "master";
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
