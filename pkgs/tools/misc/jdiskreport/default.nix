{ stdenv, fetchurl, unzip, jdk }:

stdenv.mkDerivation rec {
  name = "jdiskreport-1.4.0";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.jgoodies.com/download/jdiskreport/jdiskreport-1_4_0.zip;
    sha256 = "0kx43480p89wlyza94lzqygqfafsdf964syc2c24q28y42psz4kd";
  };
  
  buildInputs = [ unzip ];
  
  inherit jdk;

  meta = {
    homepage = http://www.jgoodies.com/freeware/jdiskreport/;
    description = "A graphical utility to visualize disk usage";
    license = "unfree-redistributable";
  };  
}
