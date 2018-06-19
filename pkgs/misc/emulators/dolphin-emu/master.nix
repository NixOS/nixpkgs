{ stdenv, fetchFromGitHub, pkgconfig, cmake, makeWrapper, bluez, ffmpeg, libao
, libGLU_combined, gtk2, glib, pcre, gettext, libpthreadstubs, libXrandr, libusb
, libXext, libXxf86vm, libXinerama, libSM, readline, openal, libXdmcp, libevdev
, portaudio, curl, qt5, vulkan-loader ? null, libpulseaudio ? null

# - Inputs used for Darwin
, CoreBluetooth, cf-private, ForceFeedback, IOKit, OpenGL, wxGTK, libpng, hidapi

# options
, dolphin-wxgui ? true
, dolphin-qtgui ? false
}:
# XOR: ensure only wx XOR qt are enabled
assert dolphin-wxgui || dolphin-qtgui;
assert !(dolphin-wxgui && dolphin-qtgui);

stdenv.mkDerivation rec {
  name = "dolphin-emu-20180618";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "091efcc41d59dbe0e478ea96f891c1b47b99ddde";
    sha256 = "1djsd41kdaphyyd3jyk669hjl39mskm186v86nijwg4a0c70kb2r";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isLinux [ makeWrapper ];

  buildInputs = [
    curl ffmpeg libao libGLU_combined gtk2 glib pcre gettext libpthreadstubs
    libXrandr libXext libXxf86vm libXinerama libSM readline openal libXdmcp
    portaudio libusb libpulseaudio libpng hidapi
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ wxGTK CoreBluetooth cf-private ForceFeedback IOKit OpenGL ]
    ++ stdenv.lib.optionals stdenv.isLinux [ bluez libevdev vulkan-loader ]
    ++ stdenv.lib.optionals dolphin-qtgui [ qt5.qtbase ];

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
  ] ++ stdenv.lib.optionals (!dolphin-qtgui)  [ "-DENABLE_QT2=False" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "-DOSX_USE_DEFAULT_SEARCH_PATH=True" ];

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

  meta = with stdenv.lib; {
    homepage = "http://dolphin-emu.org";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARM";
    license = licenses.gpl2;
    maintainers = with maintainers; [ MP2E ];
    branch = "master";
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
