{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-4.13";
  src = fetchurl {
    url = ftp://ftp.astron.com/pub/file/file-4.13.tar.gz;
    md5 = "2bfc0f878ee22e50441b68df2ccbb984";
  };
}
