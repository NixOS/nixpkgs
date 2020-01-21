{ stdenv, fetchurl, nasm
, alsaLib, curl, flac, fluidsynth, freetype, libjpeg, libmad, libmpeg2, libogg, libvorbis, libGLU, libGL, SDL2, zlib
}:

stdenv.mkDerivation rec {
  pname = "scummvm";
  version = "2.1.0";

  src = fetchurl {
    url = "http://scummvm.org/frs/scummvm/${version}/${pname}-${version}.tar.xz";
    sha256 = "6b50c6596a1536b52865f556dc05ded20f86b6ffabe4bccbd746b5587b15f727";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs = [
    alsaLib curl freetype flac fluidsynth libjpeg libmad libmpeg2 libogg libvorbis libGLU libGL SDL2 zlib
  ];

  dontDisableStatic = true;

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
