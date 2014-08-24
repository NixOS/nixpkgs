{ stdenv, fetchurl, cmake, SDL, openal, zlib, libpng, python, libvorbis }:

assert stdenv.gcc.libc != null;

stdenv.mkDerivation rec {
  name = "gemrb-0.8.0.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/gemrb/${name}.tar.gz";
    sha256 = "0v9iypls4iawnfkc91hcdnmc4vyg3ix7v7lmw3knv73q145v0ksd";
  };

  buildInputs = [ cmake python openal SDL zlib libpng libvorbis ];
  # TODO: make libpng, libvorbis, sdl_mixer, freetype, vlc, glew (and other gl reqs) optional

  # Necessary to find libdl.
  CMAKE_LIBRARY_PATH = "${stdenv.gcc.libc}/lib";

  # Can't have -werror because of the Vorbis header files.
  cmakeFlags = "-DDISABLE_WERROR=ON -DCMAKE_VERBOSE_MAKEFILE=ON";

  # upstream prefers some symbols to remain
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    longDescription = ''
      GemRB (Game engine made with pre-Rendered Background) is a portable open-source implementation of
      Bioware's Infinity Engine. It was written to support pseudo-3D role playing games based on the
      Dungeons & Dragons ruleset (Baldur's Gate and Icewind Dale series, Planescape: Torment).
    '';
    homepage = http://gemrb.org/;
    license = licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
