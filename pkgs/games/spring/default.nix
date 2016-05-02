{ stdenv, fetchurl, cmake, lzma, boost, libdevil, zlib, p7zip
, openal, libvorbis, glew, freetype, xorg, SDL, mesa, binutils
, asciidoc, libxslt, docbook_xsl, docbook_xsl_ns, curl, makeWrapper
, jdk ? null, python ? null, systemd
, withAI ? true # support for AI Interfaces and Skirmish AIs
}:

stdenv.mkDerivation rec {

  name = "spring-${version}";
  version = "96.0";

  src = fetchurl {
    url = "mirror://sourceforge/springrts/spring_${version}_src.tar.lzma";
    sha256 = "1axyqkxgv3a0zg0afzlc7j3lyi412zd551j317ci41yqz2qzf0px";
  };

  cmakeFlags = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON"
                "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON"
                "-DPREFER_STATIC_LIBS:BOOL=OFF"];

  buildInputs = [ cmake lzma boost libdevil zlib p7zip openal libvorbis freetype SDL
    xorg.libX11 xorg.libXcursor mesa glew asciidoc libxslt docbook_xsl curl makeWrapper
    docbook_xsl_ns systemd ]
    ++ stdenv.lib.optional withAI jdk
    ++ stdenv.lib.optional withAI python;

  # reported upstream http://springrts.com/mantis/view.php?id=4305
  #enableParallelBuilding = true; # occasionally missing generated files on Hydra

  NIX_CFLAGS_COMPILE = "-fpermissive"; # GL header minor incompatibility

  postInstall = ''
    wrapProgram "$out/bin/spring" \
      --prefix LD_LIBRARY_PATH : "${stdenv.cc.cc.lib}/lib::${systemd}/lib"
  '';

  meta = with stdenv.lib; {
    homepage = http://springrts.com/;
    description = "A powerful real-time strategy (RTS) game engine";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.qknight maintainers.iElectric ];
    platforms = platforms.linux;
  };
}
