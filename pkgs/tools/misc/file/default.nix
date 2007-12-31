{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-4.23";
  src = fetchurl {
    url = ftp://ftp.astron.com/pub/file/file-4.23.tar.gz;
    sha256 = "0iyiyzcs88k6r881l11zrg86ys3rnwjyh1bgx7hnfyjv8zk9db9g";
  };

  meta = {
    description = "A program that shows the type of files";
    homepage = ftp://ftp.astron.com/pub/file;
  };
}
