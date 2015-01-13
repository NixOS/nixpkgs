{ stdenv, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, gettext, git, libpthreadstubs, libXrandr, libXext, readline
, openal, libXdmcp, portaudio, SDL, wxGTK30, fetchgit
, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20150103";
  src = fetchgit {
    url = git://github.com/dolphin-emu/dolphin.git;
    rev = "03f716e651128a2da01f6afdd26545fafdd49971";
    sha256 = "01dq5552wpfn7dvfvdxxzfxn1z08abqwpm4gf33c081bhhbsyny6";
    fetchSubmodules = false;
  };

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2}/include/gtk-2.0
    -DCMAKE_BUILD_TYPE=Release
    -DENABLE_LTO=True
  '';

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig cmake bluez ffmpeg libao mesa gtk2 glib
                  gettext libpthreadstubs libXrandr libXext readline openal
                  git libXdmcp portaudio SDL wxGTK30 pulseaudio ];

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
