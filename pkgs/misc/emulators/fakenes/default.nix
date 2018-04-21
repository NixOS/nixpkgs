{stdenv, fetchurl, allegro, openal, libGLU_combined, zlib, hawknl, freeglut, libX11,
  libXxf86vm, libXcursor, libXpm }:

stdenv.mkDerivation {
  name = "fakenes-0.5.9b3";
  src = fetchurl {
    url = mirror://sourceforge/fakenes/fakenes-0.5.9-beta3.tar.gz;
    sha256 = "026h67s4pzc1vma59pmzk02iy379255qbai2q74wln9bxqcpniy4";
  };

  buildInputs = [ allegro openal libGLU_combined zlib hawknl freeglut libX11
    libXxf86vm libXcursor libXpm ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    cp fakenes $out/bin
  '';

  NIX_LDFLAGS = "-lX11 -lXxf86vm -lXcursor -lXpm";

  patches = [ ./build.patch ];

  meta = {
    homepage = http://fakenes.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Portable Open Source NES Emulator";
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
