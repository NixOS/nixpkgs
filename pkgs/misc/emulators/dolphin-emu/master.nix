{ stdenv, fetchFromGitHub, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, pcre, gettext, libpthreadstubs, libXrandr, libXext, libSM, readline
, openal, libXdmcp, portaudio, libusb, libevdev
, libpulseaudio ? null
, curl
# - Inputs used for Darwin
, CoreBluetooth, cf-private, ForceFeedback, IOKit, OpenGL
, wxGTK
, libpng
, hidapi
}:

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
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ "-DOSX_USE_DEFAULT_SEARCH_PATH=True" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ curl ffmpeg libao mesa gtk2 glib pcre
                  gettext libpthreadstubs libXrandr libXext libSM readline openal
                  libXdmcp portaudio libusb libpulseaudio libpng hidapi
                ] ++ stdenv.lib.optionals stdenv.isDarwin [ wxGTK CoreBluetooth cf-private ForceFeedback IOKit OpenGL ]
                  ++ stdenv.lib.optionals stdenv.isLinux  [ bluez libevdev  ];

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
