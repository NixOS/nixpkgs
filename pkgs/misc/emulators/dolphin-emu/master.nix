{ stdenv, fetchFromGitHub, pkgconfig, cmake, bluez, ffmpeg, libao, libGLU_combined, gtk2, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libSM, readline
, openal, libXdmcp, portaudio, libusb, libevdev
, libpulseaudio ? null
, curl

, qt5
# - Inputs used for Darwin
, CoreBluetooth, cf-private, ForceFeedback, IOKit, OpenGL
, wxGTK
, libpng
, hidapi

# options
, dolphin-wxgui ? true
, dolphin-qtgui ? false
}:
# XOR: ensure only wx XOR qt are enabled
assert dolphin-wxgui || dolphin-qtgui;
assert !(dolphin-wxgui && dolphin-qtgui);

stdenv.mkDerivation rec {
  name = "dolphin-emu-20171218";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "438e8b64a4b080370c7a65ed23af52838a4e7aaa";
    sha256 = "0rrd0g1vg9jk1p4wdr6w2z34cabb7pgmpwfcl2a372ark3vi4ysc";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
  ] ++ stdenv.lib.optionals (!dolphin-qtgui)  [ "-DENABLE_QT2=False" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "-DOSX_USE_DEFAULT_SEARCH_PATH=True" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ curl ffmpeg libao libGLU_combined gtk2 glib pcre
                  gettext libpthreadstubs libXrandr libXext libSM readline openal
                  libXdmcp portaudio libusb libpulseaudio libpng hidapi
                ] ++ stdenv.lib.optionals stdenv.isDarwin [ wxGTK CoreBluetooth cf-private ForceFeedback IOKit OpenGL ]
                  ++ stdenv.lib.optionals stdenv.isLinux  [ bluez libevdev  ]
                  ++ stdenv.lib.optionals dolphin-qtgui [ qt5.qtbase ];

  # - Change install path to Applications relative to $out
  # - Allow Dolphin to use nix-provided libraries instead of building them
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e 's,/Applications,Applications,g' Source/Core/DolphinWX/CMakeLists.txt
    sed -i -e 's,if(LIBUSB_FOUND AND NOT APPLE),if(LIBUSB_FOUND),g' CMakeLists.txt
    sed -i -e 's,if(NOT APPLE),if(true),g' CMakeLists.txt
  '';

  preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
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
