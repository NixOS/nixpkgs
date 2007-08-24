{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-4.17";
  src = fetchurl {
    url = ftp://ftp.astron.com/pub/file/file-4.17.tar.gz;
    md5 = "50919c65e0181423d66bb25d7fe7b0fd";
  };
}
