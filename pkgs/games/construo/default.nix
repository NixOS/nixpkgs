{ stdenv
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
    ++ stdenv.lib.optional (libGL != null) libGL
    ++ stdenv.lib.optional (libGLU != null) libGLU
    ++ stdenv.lib.optional (freeglut != null) freeglut;

  preConfigure = ''
    substituteInPlace src/Makefile.in \
      --replace games bin
  '';

  meta = {
    description = "Masses and springs simulation game";
    homepage = "http://fs.fsf.org/construo/";
    license = stdenv.lib.licenses.gpl3;
  };
}
