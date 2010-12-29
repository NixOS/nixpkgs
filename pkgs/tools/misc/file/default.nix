{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-5.03";

  src = fetchurl {
    url = ftp://ftp.astron.com/pub/file/file-5.03.tar.gz;
    sha256 = "1fwmpplwc6h2g89ribq7w8x2np0yn5k7bw042815rv7jkrzv9nhy";
  };

  meta = {
    description = "A program that shows the type of files";
    homepage = ftp://ftp.astron.com/pub/file;
  };
}
