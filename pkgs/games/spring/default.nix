{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xlibs, SDL, mesa
, jdk ? null, python ? null
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:
stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "0.86.0";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_86.0_src.tar.lzma";
    sha256 = "728bc95ac551d2199539f9ec9a79254ebd4414e6aa81e03a6c4534cec61f7bca";
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
