{stdenv, fetchurl, aterm, getopt}:
stdenv.mkDerivation {
  name = "sdf2-1.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-1.6.tar.gz;
    md5 = "283be0b4c7c9575c1b5cc735316e6192";
  };
  aterm = aterm;
  getopt = getopt;
}
