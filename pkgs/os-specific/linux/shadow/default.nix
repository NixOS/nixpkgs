{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "shadow-4.0.4.1";
   
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.pld.org.pl/software/shadow/old/shadow-4.0.4.1.tar.bz2;
    md5 = "3a3d17d3d7c630b602baf66ae7434c61";
  };
   
}
