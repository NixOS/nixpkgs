{lib, stdenv, fetchurl, allegro, openal, libGLU, libGL, zlib, hawknl, freeglut, libX11,
  libXxf86vm, libXcursor, libXpm }:

stdenv.mkDerivation rec {
  pname = "fakenes";
  version = "0.5.9-beta3";

  src = fetchurl {
    url = "mirror://sourceforge/fakenes/fakenes-${version}.tar.gz";
    sha256 = "026h67s4pzc1vma59pmzk02iy379255qbai2q74wln9bxqcpniy4";
  };

  buildInputs = [ allegro openal libGLU libGL zlib hawknl freeglut libX11
    libXxf86vm libXcursor libXpm ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    cp fakenes $out/bin
  '';

  NIX_LDFLAGS = "-lX11 -lXxf86vm -lXcursor -lXpm";

  patches = [ ./build.patch ];

  meta = {
    homepage = "http://fakenes.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    description = "Portable Open Source NES Emulator";
    platforms = lib.platforms.linux;
    broken = true;
  };
}
