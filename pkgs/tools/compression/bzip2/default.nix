{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bzip2-1.0.4";
  builder = ./builder.sh;
    
  src = fetchurl {
    url = http://www.bzip.org/1.0.4/bzip2-1.0.4.tar.gz;
    md5 = "fc310b254f6ba5fbb5da018f04533688";
  };

  sharedLibrary =
    !stdenv.isDarwin && !(stdenv ? isDietLibC) && stdenv.system != "i686-cygwin";
}
