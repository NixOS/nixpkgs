{ stdenv, fetchurl, libX11, zlib, xproto, mesa ? null, freeglut ? null }:

stdenv.mkDerivation rec {
  name = "construo-${version}";
  version = "0.2.3";

  src = fetchurl {
    url = "https://github.com/Construo/construo/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1wmj527hbj1qv44cdsj6ahfjrnrjwg2dp8gdick8nd07vm062qxa";
  };

  buildInputs = [ libX11 zlib xproto ]
    ++ stdenv.lib.optional (mesa != null) mesa
    ++ stdenv.lib.optional (freeglut != null) freeglut;

  preConfigure = ''
    substituteInPlace src/Makefile.in \
      --replace games bin
  '';

  meta = {
    description = "Masses and springs simulation game";
    homepage = http://fs.fsf.org/construo/;
  };
}
