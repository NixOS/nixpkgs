{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xlibs, SDL, mesa
, jdk ? null, python ? null
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:
stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "0.82.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_${version}_src.tar.lzma";
    sha256 = "1bi64jgc390sqc514scz80a0pdgc5n9kx45sppky2152y725900n";
  };

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL
    xlibs.libX11 xlibs.libXcursor mesa glew ]
    ++ stdenv.lib.optional withAI jdk
    ++ stdenv.lib.optional withAI python;

  prePatch = ''
    substituteInPlace cont/base/make_gamedata_arch.sh --replace "#!/bin/sh" "#!${stdenv.shell}/bin/sh" \
      --replace "which" "type -p"    
  '';

  patches = [ ./gcc44.patch];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://springrts.com/;
    description = "A powerful real-time strategy(RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
  };
}