{stdenv, fetchurl}:

derivation {
  name = "wget-1.9.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.net/pub/gnu/wget/wget-1.9.1.tar.gz;
    md5 = "e6051f1e1487ec0ebfdbda72bedc70ad";
  };
  inherit stdenv;
}
