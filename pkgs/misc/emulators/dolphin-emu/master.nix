{ stdenv, fetchFromGitHub, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
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
  name = "dolphin-emu-20170902";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "b073db51e5f3df8c9890e09a3f4f8a2276c31e3f";
    sha256 = "0pr5inkd7swc6s7im7axhvmkdbqidhrha2wpflnr25aiwq0dzm10";
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

  buildInputs = [ curl ffmpeg libao mesa gtk2 glib pcre
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
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
