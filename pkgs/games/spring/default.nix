{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xlibs, SDL, mesa, binutils
, asciidoc, libxslt, docbook_xsl, curl
, jdk ? null, python ? null
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:
stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "96.0";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_${version}_src.tar.lzma";
    sha256 = "1axyqkxgv3a0zg0afzlc7j3lyi412zd551j317ci41yqz2qzf0px";
  };

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL
    xlibs.libX11 xlibs.libXcursor mesa glew asciidoc libxslt docbook_xsl curl ]
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
