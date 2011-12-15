{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xlibs, SDL, mesa
, jdk ? null, python ? null
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:
stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "0.83.0";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_83.0_src.tar.lzma";
    sha256 = "073x1mlzil588r8xgzc323293xmi0xbw6w0k6psxl5cs0gqrvfqa";
  };

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL
    xlibs.libX11 xlibs.libXcursor mesa glew ]
    ++ stdenv.lib.optional withAI jdk
    ++ stdenv.lib.optional withAI python;

  prePatch = ''
    substituteInPlace cont/base/make_gamedata_arch.sh --replace "#!/bin/sh" "#!${stdenv.shell}/bin/sh" \
      --replace "which" "type -p"
  '';

  #patches = [ ./gcc44.patch];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://springrts.com/;
    description = "A powerful real-time strategy(RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
