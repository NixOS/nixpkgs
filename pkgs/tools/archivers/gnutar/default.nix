{stdenv, fetchurl}:

derivation {
  name = "gnutar-1.13.25";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://alpha.gnu.org/gnu/tar/tar-1.13.25.tar.gz;
    md5 = "6ef8c906e81eee441f8335652670ac4a";
  };
  inherit stdenv;
}
