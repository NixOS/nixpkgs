{ stdenv, fetchFromGitHub, pkgconfig, cmake, makeWrapper, bluez, ffmpeg, libao, libGLU_combined, gtk2, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libXxf86vm, libXinerama, libSM, readline
, openal, libXdmcp, portaudio, libusb, libevdev, curl, qt5
, vulkan-loader ? null
, libpulseaudio ? null
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
  name = "dolphin-emu-20180609";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "1d87584d69e3fdd730502127274fcbd85cebd591";
    sha256 = "0sxzmmv8gvfsy96p1x1aya1cpq0237gip3zkl4bks4grgxf8958b";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
  ] ++ stdenv.lib.optionals (!dolphin-qtgui)  [ "-DENABLE_QT2=False" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "-DOSX_USE_DEFAULT_SEARCH_PATH=True" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ]
                      ++ stdenv.lib.optionals stdenv.isLinux [ makeWrapper ];

  buildInputs = [ curl ffmpeg libao libGLU_combined gtk2 glib pcre
                  gettext libpthreadstubs libXrandr libXext libXxf86vm libXinerama libSM readline openal
                  libXdmcp portaudio libusb libpulseaudio libpng hidapi
                ] ++ stdenv.lib.optionals stdenv.isDarwin [ wxGTK CoreBluetooth cf-private ForceFeedback IOKit OpenGL ]
                  ++ stdenv.lib.optionals stdenv.isLinux [ bluez libevdev vulkan-loader ]
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

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/dolphin-emu-nogui --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    wrapProgram $out/bin/dolphin-emu-wx --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
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
