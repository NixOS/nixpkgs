{ alsaLib, cmake, fetchFromGitHub, gcc-unwrapped, gettext, glib, gtk3, harfbuzz
, libaio, libpcap, libpng, libxml2, makeWrapper, perl, pkgconfig, portaudio
, SDL2, soundtouch, stdenv, udev, wrapGAppsHook, wxGTK, zlib
}:

stdenv.mkDerivation {
  pname = "pcsx2";
  version = "unstable-2020-10-10";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    rev = "7e2ccd64e8e6049b6059141e8767037463421c33";
    sha256 = "0c7m74ch68p4y9xlld34a9r38kb2py6wlkg4vranc6dicxvi1b3r";
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

  nativeBuildInputs = [ cmake makeWrapper perl pkgconfig wrapGAppsHook ];

  buildInputs = [
    alsaLib
    gettext
    glib
    gtk3
    harfbuzz
    libaio
    libpcap
    libpng
    libxml2
    portaudio
    SDL2
    soundtouch
    udev
    wxGTK
    zlib
  ];

  meta = with stdenv.lib; {
    description = "Playstation 2 emulator";
    longDescription= ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose
      is to emulate the PS2 hardware, using a combination of MIPS CPU
      Interpreters, Recompilers and a Virtual Machine which manages hardware
      states and PS2 system memory. This allows you to play PS2 games on your
      PC, with many additional features and benefits.
    '';
    homepage = "https://pcsx2.net";
    maintainers = with maintainers; [ hrdinka samuelgrf ];

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
    platforms = platforms.x86;
  };
}
