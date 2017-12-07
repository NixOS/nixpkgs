{ stdenv, gcc, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libSM, readline
, openal, libXdmcp, portaudio, fetchFromGitHub, libusb, libevdev
, libpulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20170730";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "141fb0f03ca4e0d05f7ccbf3e020997097f60dbe";
    sha256 = "1b4ygrfj1dpmyv7qqfnqrrvm96a3b68cwcnvv2pknrcpc17g52im";
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
