{ stdenv, gcc, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libSM, readline
, openal, libXdmcp, portaudio, fetchFromGitHub, libusb, libevdev
, libpulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20170902";
  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "b073db51e5f3df8c9890e09a3f4f8a2276c31e3f";
    sha256 = "0pr5inkd7swc6s7im7axhvmkdbqidhrha2wpflnr25aiwq0dzm10";
  };

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0
    -DENABLE_LTO=True
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gcc cmake bluez ffmpeg libao mesa gtk2 glib pcre
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
