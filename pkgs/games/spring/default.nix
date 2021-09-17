{ lib, stdenv, fetchFromGitHub, cmake, xz, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xorg, SDL2, libGLU, libGL
, asciidoc, docbook_xsl, docbook_xsl_ns, curl, makeWrapper
, jdk ? null, python ? null, systemd, libunwind, which, minizip
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:

stdenv.mkDerivation rec {
  pname = "spring";
  version = "105.0.1-${buildId}-g${shortRev}";
  # usually the latest in https://github.com/spring/spring/commits/maintenance
  rev = "8581792eac65e07cbed182ccb1e90424ce3bd8fc";
  shortRev = builtins.substring 0 7 rev;
  buildId = "1486";

  # taken from https://github.com/spring/spring/commits/maintenance
  src = fetchFromGitHub {
    owner = "spring";
    repo = pname;
    inherit rev;
    sha256 = "05lvd8grqmv7vl8rrx02rhl0qhmm58dyi6s78b64j3fkia4sfj1r";
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

  nativeBuildInputs = [ cmake makeWrapper docbook_xsl docbook_xsl_ns asciidoc ];
  buildInputs = [ xz boost libdevil zlib p7zip openal libvorbis freetype SDL2
    xorg.libX11 xorg.libXcursor libGLU libGL glew curl
    systemd libunwind which minizip ]
    ++ lib.optional withAI jdk
    ++ lib.optional withAI python;

  NIX_CFLAGS_COMPILE = "-fpermissive"; # GL header minor incompatibility

  postInstall = ''
    wrapProgram "$out/bin/spring" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc systemd ]}"
  '';

  meta = with lib; {
    homepage = "https://springrts.com/";
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom qknight domenkozar sorki ];
    platforms = platforms.linux;
  };
}
