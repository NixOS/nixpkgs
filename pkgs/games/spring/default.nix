{ stdenv, fetchFromGitHub, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xorg, SDL2, libGLU, libGL
, asciidoc, libxslt, docbook_xsl, docbook_xsl_ns, curl, makeWrapper
, jdk ? null, python ? null, systemd, libunwind, which, minizip
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:

stdenv.mkDerivation rec {
  pname = "spring";
  version = "104.0.1-${buildId}-g${shortRev}";
  # usually the latest in https://github.com/spring/spring/commits/maintenance
  rev = "c4e1654d5d2758fb8bf8f5c9769dd4be2a3eb866";
  shortRev = builtins.substring 0 7 rev;
  buildId = "1482";

  # taken from https://github.com/spring/spring/commits/maintenance
  src = fetchFromGitHub {
    owner = "spring";
    repo = "spring";
    inherit rev;
    sha256 = "1rnpn8i4m5spkf3jjndz17ldh4h09q7bh6zaxzmpgxilh8gjdj92";
    fetchSubmodules = true;
  };

  # The cmake included module correcly finds nix's glew, however
  # it has to be the bundled FindGLEW for headless or dedicated builds
  prePatch = ''
    substituteInPlace ./rts/build/cmake/FindAsciiDoc.cmake \
      --replace "PATHS /usr /usr/share /usr/local /usr/local/share" "PATHS ${docbook_xsl}"\
      --replace "xsl/docbook/manpages" "share/xml/docbook-xsl/manpages"
    substituteInPlace ./rts/Rendering/GL/myGL.cpp \
      --replace "static constexpr const GLubyte* qcriProcName" "static const GLubyte* qcriProcName"
    patchShebangs .
    rm rts/build/cmake/FindGLEW.cmake

    echo "${version} maintenance" > VERSION
  '';

  cmakeFlags = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON"
                "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON"
                "-DPREFER_STATIC_LIBS:BOOL=OFF"];

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL2
    xorg.libX11 xorg.libXcursor libGLU libGL glew asciidoc libxslt docbook_xsl curl makeWrapper
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
    homepage = "https://springrts.com/";
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.qknight maintainers.domenkozar maintainers.sorki ];
    platforms = platforms.linux;
  };
}
