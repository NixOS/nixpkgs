{ stdenv, pkgconfig, cmake, bluez, ffmpeg, libao, glib, libGL
, gettext, libpthreadstubs, libXrandr, libXext, readline, openal
, libXdmcp, portaudio, fetchFromGitHub, libusb, libevdev
, wxGTK_2, soundtouch, miniupnpc, mbedtls, curl, lzo, sfml
, alsaLib, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-${version}";
  version = "5.0";

  src = fetchFromGitHub {
    owner  = "dolphin-emu";
    repo   = "dolphin";
    rev    = version;
    sha256 = "07mlfnh0hwvk6xarcg315x7z2j0qbg9g7cm040df9c8psiahc3g6";
  };

  postPatch = ''
    substituteInPlace Source/Core/VideoBackends/OGL/RasterFont.cpp \
      --replace " CHAR_WIDTH " " CHARWIDTH "
  '';

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${wxGTK_2.gtk.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${wxGTK_2.gtk.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ bluez ffmpeg libao libGL glib
                  gettext libpthreadstubs libXrandr libXext readline openal
                  alsaLib libevdev libXdmcp portaudio libusb libpulseaudio
                  wxGTK_2 wxGTK_2.gtk soundtouch miniupnpc mbedtls curl lzo sfml ];

  meta = {
    homepage = http://dolphin-emu.org/;
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARM";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    platforms = [ "x86_64-linux" ];
  };
}
