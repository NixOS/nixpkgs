{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-4.13";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/file-4.13.tar.gz;
    md5 = "2bfc0f878ee22e50441b68df2ccbb984";
  };
}
