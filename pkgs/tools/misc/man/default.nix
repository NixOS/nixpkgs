{stdenv, fetchurl, db4, groff}:
 
stdenv.mkDerivation {
  name = "man_db-2.4.3";
  src = fetchurl {
    url = http://savannah.nongnu.org/download/man-db/man-db-2.4.3.tar.gz;
    md5 = "30814a47f209f43b152659ba51fc7937";
  };
  buildInputs = [db4 groff];
}
