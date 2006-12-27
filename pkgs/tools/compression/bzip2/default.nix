{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bzip2-1.0.3";
  builder = ./builder.sh;
    
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bzip2-1.0.3.tar.gz;
    md5 = "8a716bebecb6e647d2e8a29ea5d8447f";
  };

  sharedLibrary =
    !stdenv.isDarwin && !(stdenv ? isDietLibC) && stdenv.system != "i686-cygwin";
}
