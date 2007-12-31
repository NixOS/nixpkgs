{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cabextract-1.2";
  src = fetchurl {
    url = http://www.cabextract.org.uk/cabextract-1.2.tar.gz;
    sha256 = "1sr5f7qicj5q2h5m4wbmfcaaqxg5zkl5vkxlhyc11spwfh58d75f";
  };
}
