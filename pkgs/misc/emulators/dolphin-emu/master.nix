{ stdenv, gcc, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, gettext, git, libpthreadstubs, libXrandr, libXext, readline
, openal, libXdmcp, portaudio, fetchgit, libusb, libevdev
, libpulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20150802";
  src = fetchgit {
    url = git://github.com/dolphin-emu/dolphin.git;
    rev = "5097a22844b850b429872f4de390bd958b11a616";
    sha256 = "09jx61cxvfimnq1snkv6w3m9qidrgp0j0w81c7pbkpmcwysz8xya";
    fetchSubmodules = false;
  };

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0
    -DCMAKE_BUILD_TYPE=Release
    -DENABLE_LTO=True
  '';

  enableParallelBuilding = true;

  buildInputs = [ gcc pkgconfig cmake bluez ffmpeg libao mesa gtk2 glib
                  gettext libpthreadstubs libXrandr libXext readline openal
                  libevdev git libXdmcp portaudio libusb libpulseaudio ];

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
