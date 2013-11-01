{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xlibs, SDL, mesa, binutils
, jdk ? null, python ? null
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:
stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "94.1";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_${version}_src.tar.lzma";
    sha256 = "19myqwpz4mi4zdlcv8318dps0ymmw7qpawhq1rgk73ycmaiyaaka";
  };

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL
    xlibs.libX11 xlibs.libXcursor mesa glew ]
    ++ stdenv.lib.optional withAI jdk
    ++ stdenv.lib.optional withAI python;

  prePatch = ''
    substituteInPlace cont/base/make_gamedata_arch.sh --replace "#!/bin/sh" "#!${stdenv.shell}/bin/sh" \
      --replace "which" "type -p"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://springrts.com/;
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.qknight ];
    platforms = platforms.mesaPlatforms;
  };
}
