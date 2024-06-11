{ lib, stdenv
, fetchurl
, libX11
, zlib
, xorgproto
, libGL ? null
, libGLU ? null
, freeglut ? null
}:

stdenv.mkDerivation rec {
  pname = "construo";
  version = "0.2.3";

  src = fetchurl {
    url = "https://github.com/Construo/construo/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1wmj527hbj1qv44cdsj6ahfjrnrjwg2dp8gdick8nd07vm062qxa";
  };

  buildInputs = [ libX11 zlib xorgproto ]
    ++ lib.optional (libGL != null) libGL
    ++ lib.optional (libGLU != null) libGLU
    ++ lib.optional (freeglut != null) freeglut;

  preConfigure = ''
    substituteInPlace src/Makefile.in \
      --replace games bin
  '';

  meta = {
    description = "Masses and springs simulation game";
    mainProgram = "construo.x11";
    homepage = "http://fs.fsf.org/construo/";
    license = lib.licenses.gpl3;
  };
}
