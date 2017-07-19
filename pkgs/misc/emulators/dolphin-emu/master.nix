{ stdenv, gcc, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libSM, readline
, openal, libXdmcp, portaudio, fetchFromGitHub, libusb, libevdev
, libpulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20170705";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "29cc009706f133aac39ebaa7003d37555b926109";
    sha256 = "0axd2z14lyqlaxrjssc0dkqnjdk3ccxh2fqrhya0jc2rsm8ighlz";
  };

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0
    -DENABLE_LTO=True
  '';

  enableParallelBuilding = true;

  buildInputs = [ gcc pkgconfig cmake bluez ffmpeg libao mesa gtk2 glib pcre
                  gettext libpthreadstubs libXrandr libXext libSM readline openal
                  libevdev libXdmcp portaudio libusb libpulseaudio ];

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
