{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "asf-library-1.0";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asf-library/asf-library-1.0.tar.gz;
    md5 = "e531f78941e2d2dab1b87a56522e9fb5";
  };
}

