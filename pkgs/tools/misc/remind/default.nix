{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "remind-3.1.6";
  src = fetchurl {
    url = http://www.roaringpenguin.com/files/download/remind-03.01.06.tar.gz;
    sha256 = "acdf73904c95de55b615d80c7c007abe58d75e41978a16a43333a22583ac7738";
  };

  meta = {
    homepage = http://www.roaringpenguin.com/products/remind;
    description = "Sophisticated calendar and alarm program for the console";
    license = "GPLv2";
  };
}
