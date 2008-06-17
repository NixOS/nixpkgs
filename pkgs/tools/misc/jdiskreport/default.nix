{stdenv, fetchurl, unzip, jdk}:

#assert jdk.swingSupport;

stdenv.mkDerivation {
  name = "jdiskreport-1.3.0";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.jgoodies.com/download/jdiskreport/jdiskreport-1_3_0.zip;
    sha256 = "1vgiq797gqc6i89w4kscg57snn74wi8x566bhi9xn8r0fbphihxb";
  };
  
  buildInputs = [unzip];
  
  inherit jdk;
}
