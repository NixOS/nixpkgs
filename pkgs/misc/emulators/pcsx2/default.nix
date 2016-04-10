{ alsaLib, cmake, fetchFromGitHub, glib, gtk2, gettext, libaio, libpng
, makeWrapper, perl, pkgconfig, portaudio, SDL2, soundtouch, stdenv
, wxGTK30, zlib }:

assert stdenv.isi686;

stdenv.mkDerivation rec {
  name = "pcsx2-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    rev = "v${version}";
    sha256 = "0s7mxq2cgzwjfsq0vhpz6ljk7wr725nxg48128iyirf85585l691";
  };

  configurePhase = ''
    mkdir -p build
    cd build

    cmake \
      -DBIN_DIR="$out/bin" \
      -DCMAKE_BUILD_PO=TRUE \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="$out" \
      -DDISABLE_ADVANCE_SIMD=TRUE \
      -DDISABLE_PCSX2_WRAPPER=TRUE \
      -DDOC_DIR="$out/share/doc/pcsx2" \
      -DGAMEINDEX_DIR="$out/share/pcsx2" \
      -DGLSL_SHADER_DIR="$out/share/pcsx2" \
      -DGTK2_GLIBCONFIG_INCLUDE_DIR='${glib}/lib/glib-2.0/include' \
      -DGTK2_GDKCONFIG_INCLUDE_DIR='${gtk2}/lib/gtk-2.0/include' \
      -DGTK2_INCLUDE_DIRS='${gtk2}/include/gtk-2.0' \
      -DPACKAGE_MODE=TRUE \
      -DPLUGIN_DIR="$out/lib/pcsx2" \
      -DREBUILD_SHADER=TRUE \
      ..
  '';

  postFixup = ''
    wrapProgram $out/bin/PCSX2 \
      --set __GL_THREADED_OPTIMIZATIONS 1
  '';

  nativeBuildInputs = [ cmake perl pkgconfig ];

  buildInputs = [
    alsaLib glib gettext gtk2 libaio libpng makeWrapper portaudio SDL2
    soundtouch wxGTK30 zlib
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
    homepage = http://pcsx2.net;
    maintainers = with maintainers; [ hrdinka ];

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
    platforms = platforms.i686;
  };
}
