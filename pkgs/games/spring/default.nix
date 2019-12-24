{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xorg, SDL2, libGLU_combined
, asciidoc, libxslt, docbook_xsl, docbook_xsl_ns, curl, makeWrapper
, jdk ? null, python ? null, systemd, libunwind, which, minizip
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:

stdenv.mkDerivation rec {

  pname = "spring";
  version = "104.0";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_${version}_src.tar.lzma";
    sha256 = "05pclcbw7v481pqz7bgirlk37494hy4hx4jghhnlzhdaz1cvzc6f";
  };

  # The cmake included module correcly finds nix's glew, however
  # it has to be the bundled FindGLEW for headless or dedicated builds
  prePatch = ''
    substituteInPlace ./rts/build/cmake/FindAsciiDoc.cmake \
      --replace "PATHS /usr /usr/share /usr/local /usr/local/share" "PATHS ${docbook_xsl}"\
      --replace "xsl/docbook/manpages" "share/xml/docbook-xsl/manpages"
    patchShebangs .
    rm rts/build/cmake/FindGLEW.cmake
  '';

  cmakeFlags = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON"
                "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON"
                "-DPREFER_STATIC_LIBS:BOOL=OFF"];

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL2
    xorg.libX11 xorg.libXcursor libGLU_combined glew asciidoc libxslt docbook_xsl curl makeWrapper
    docbook_xsl_ns systemd libunwind which minizip ]
    ++ stdenv.lib.optional withAI jdk
    ++ stdenv.lib.optional withAI python;

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-fpermissive"; # GL header minor incompatibility

  postInstall = ''
    wrapProgram "$out/bin/spring" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc systemd ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://springrts.com/;
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.qknight maintainers.domenkozar ];
    platforms = platforms.linux;
    broken = true;
  };
}
