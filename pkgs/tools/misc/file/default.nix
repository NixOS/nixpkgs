{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-5.04";

  src = fetchurl {
    url = ftp://ftp.astron.com/pub/file/file-5.04.tar.gz;
    sha256 = "0316lj3jxmp2g8azv0iykmmwjsnjanq93bklccwb6k77jiwnx7jc";
  };

  meta = {
    description = "A program that shows the type of files";
    homepage = ftp://ftp.astron.com/pub/file;
  };
}
