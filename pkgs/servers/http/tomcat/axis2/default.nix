{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {
  name = "axis2-1.5.1";

  src = fetchurl {
    url = http://www.bizdirusa.com/mirrors/apache/ws/axis2/1_5_1/axis2-1.5.1-bin.zip;
    sha256 = "04zcn9g4r7pxfpp5g5rpjjlddr5mibqmsz4lfbkz2vjf3jrldgy5";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;
}
