{stdenv, fetchurl, unzip, jdk}:

#assert jdk.swingSupport;

stdenv.mkDerivation {
  name = "jdiskreport-1.2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.jgoodies.com/download/jdiskreport/jdiskreport-1_2_3.zip;
    md5 = "4a33c5c1344ed9e0fa531e2cb1875cb8";
  };
  buildInputs = [unzip];
  inherit jdk;
}
