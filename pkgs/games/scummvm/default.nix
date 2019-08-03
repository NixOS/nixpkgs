{ stdenv, fetchurl, nasm
, alsaLib, flac, fluidsynth, freetype, libjpeg, libmad, libmpeg2, libogg, libvorbis, libGLU_combined, SDL2, zlib
}:

stdenv.mkDerivation rec {
  name = "scummvm-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "http://scummvm.org/frs/scummvm/${version}/${name}.tar.xz";
    sha256 = "0q6aiw97wsrf8cjw9vjilzhqqsr2rw2lll99s8i5i9svan6l314p";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs = [
    alsaLib freetype flac fluidsynth libjpeg libmad libmpeg2 libogg libvorbis libGLU_combined SDL2 zlib
  ];

  enableParallelBuilding = true;

  configurePlatforms = [ "host" ];
  configureFlags = [
    "--enable-c++11"
    "--enable-release"
  ];

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure = ''
    sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
  '';

  meta = with stdenv.lib; {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = https://www.scummvm.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.peterhoeg ];
    platforms = platforms.linux;
  };
}
