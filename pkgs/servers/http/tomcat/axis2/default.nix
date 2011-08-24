{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {
  name = "axis2-1.5.4";

  src = fetchurl {
    url = http://apache.mirror.easycolocate.nl/axis/axis2/java/core/1.5.4/axis2-1.5.4-bin.zip;
    sha256 = "0mqnsj14g8aqmh3gjxgys6kwa7q8jkjgczb0hlcr4v2par0hdfng";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;
}
