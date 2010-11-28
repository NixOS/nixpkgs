{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "xdelta-3.0z";
  
  src = fetchurl {
    url = http://xdelta.googlecode.com/files/xdelta3.0z.tar.gz;
    sha256 = "1rpk4n3yz8x81vakzn3n75h79a2ycm06p5v72djklx0wn9gb412m";
  };

  installPhase =
    ''
      mkdir -p $out/bin
      cp xdelta3 $out/bin/

      mkdir -p $out/share/man/man1
      cp xdelta3.1 $out/share/man/man1/
    '';

  meta = {
    homepage = http://xdelta.org/;
    description = "A binary diff tool that uses the VCDIFF (RFC 3284) format and compression";
  };
}
