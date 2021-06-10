{ alsa-lib
, cmake
, fetchFromGitHub
, fmt
, gcc-unwrapped
, gettext
, glib
, gtk3
, harfbuzz
, libaio
, libpcap
, libpng
, libpulseaudio
, libsamplerate
, libxml2
, makeWrapper
, perl
, pkg-config
, portaudio
, SDL2
, soundtouch
, lib, stdenv
, udev
, wrapGAppsHook
, wxGTK
, zlib
}:

stdenv.mkDerivation {
  pname = "pcsx2";
  version = "unstable-2020-11-13";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "319287dbe552c8405720b25dfdf5fa518deeee0b";
    sha256 = "1kswc8vw9hbv2nigp8cxrgf2s0ik7p4i203cbqci8zjmnkaqpsai";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DDISABLE_ADVANCE_SIMD=TRUE"
    "-DDISABLE_PCSX2_WRAPPER=TRUE"
    "-DDOC_DIR=${placeholder "out"}/share/doc/pcsx2"
    "-DGAMEINDEX_DIR=${placeholder "out"}/share/pcsx2"
    "-DGLSL_SHADER_DIR=${placeholder "out"}/share/pcsx2"
    "-DGTK3_API=TRUE"
    "-DPACKAGE_MODE=TRUE"
    "-DPLUGIN_DIR=${placeholder "out"}/lib/pcsx2"
    "-DREBUILD_SHADER=TRUE"
    "-DUSE_LTO=TRUE"
    "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK}/bin/wx-config"
    "-DwxWidgets_INCLUDE_DIRS=${wxGTK}/include"
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
    "-DXDG_STD=TRUE"
  ];

  postPatch = ''
    substituteInPlace cmake/BuildParameters.cmake \
      --replace /usr/bin/gcc-ar ${gcc-unwrapped}/bin/gcc-ar \
      --replace /usr/bin/gcc-nm ${gcc-unwrapped}/bin/gcc-nm \
      --replace /usr/bin/gcc-ranlib ${gcc-unwrapped}/bin/gcc-ranlib
  '';

  postFixup = ''
    wrapProgram $out/bin/PCSX2 \
      --set __GL_THREADED_OPTIMIZATIONS 1
  '';

  nativeBuildInputs = [ cmake makeWrapper perl pkg-config wrapGAppsHook ];

  buildInputs = [
    alsa-lib
    fmt
    gettext
    glib
    gtk3
    harfbuzz
    libaio
    libpcap
    libpng
    libpulseaudio
    libsamplerate
    libxml2
    portaudio
    SDL2
    soundtouch
    udev
    wxGTK
    zlib
  ];

  meta = with lib; {
    description = "Playstation 2 emulator";
    longDescription= ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose
      is to emulate the PS2 hardware, using a combination of MIPS CPU
      Interpreters, Recompilers and a Virtual Machine which manages hardware
      states and PS2 system memory. This allows you to play PS2 games on your
      PC, with many additional features and benefits.
    '';
    homepage = "https://pcsx2.net";
    maintainers = with maintainers; [ hrdinka govanify ];
    mainProgram = "PCSX2";

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
    platforms = platforms.x86;
  };
}
