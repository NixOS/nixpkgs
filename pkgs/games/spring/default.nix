{ lib
, stdenv
, asciidoc
, boost
, cmake
, curl
, docbook_xsl
, docbook_xsl_ns
, fetchurl
, freetype
, glew
, jdk
, libdevil
, libGL
, libGLU
, libunwind
, libvorbis
, makeWrapper
, minizip
, openal
, p7zip
, python3
, SDL2
, xorg
, xz
, zlib
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:

stdenv.mkDerivation rec {
  pname = "spring";
  version = "106.0";

  src = fetchurl {
    url = "https://springrts.com/dl/buildbot/default/master/${version}/source/spring_${version}_src.tar.gz";
    sha256 = "sha256-mSA4ioIv68NMEB72lYnwDb1QOuWr1VHwu4+grAoHlV0=";
  };

  postPatch = ''
    patchShebangs .

    substituteInPlace ./rts/build/cmake/FindAsciiDoc.cmake \
      --replace "PATHS /usr /usr/share /usr/local /usr/local/share" "PATHS ${docbook_xsl}"\
      --replace "xsl/docbook/manpages" "share/xml/docbook-xsl/manpages"

    # The cmake included module correcly finds nix's glew, however
    # it has to be the bundled FindGLEW for headless or dedicated builds
    rm rts/build/cmake/FindGLEW.cmake
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON"
    "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON"
    "-DPREFER_STATIC_LIBS:BOOL=OFF"
  ];

  nativeBuildInputs = [ cmake makeWrapper docbook_xsl docbook_xsl_ns asciidoc ];
  buildInputs = [
    boost
    curl
    freetype
    glew
    libdevil
    libGL
    libGLU
    libunwind
    libvorbis
    minizip
    openal
    p7zip
    SDL2
    xorg.libX11
    xorg.libXcursor
    xz
    zlib
  ]
  ++ lib.optionals withAI [ python3 jdk ];

  postInstall = ''
    wrapProgram "$out/bin/spring" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    homepage = "https://springrts.com/";
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qknight domenkozar sorki ];
    platforms = [ "x86_64-linux" ];
  };
}
