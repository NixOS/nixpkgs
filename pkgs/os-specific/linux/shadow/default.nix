{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "shadow-4.0.6";
   
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.pld.org.pl/software/shadow/shadow-4.0.6.tar.bz2;
    md5 = "3ca79b02c0aaa82128f4c32cb68ffe4f";
  };
   
}
