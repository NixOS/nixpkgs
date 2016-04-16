{ stdenv, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, gettext, libpthreadstubs, libXrandr, libXext, readline
, openal, libXdmcp, portaudio, SDL, wxGTK30, fetchurl
, libpulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-4.0.2";
  src = fetchurl {
    url = https://github.com/dolphin-emu/dolphin/archive/4.0.2.tar.gz;
    sha256 = "0a8ikcxdify9d7lqz8fn2axk2hq4q1nvbcsi1b8vb9z0mdrhzw89";
  };

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0
    -DCMAKE_BUILD_TYPE=Release
    -DENABLE_LTO=True
  '';

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig cmake bluez ffmpeg libao mesa gtk2 glib
                  gettext libpthreadstubs libXrandr libXext readline openal
                  libXdmcp portaudio SDL wxGTK30 libpulseaudio ];

  meta = {
    homepage = http://dolphin-emu.org/;
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARM";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
    broken = true;
  };
}
