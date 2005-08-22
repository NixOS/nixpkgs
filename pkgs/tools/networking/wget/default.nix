{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "wget-1.9.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/wget-1.9.1.tar.gz;
    md5 = "e6051f1e1487ec0ebfdbda72bedc70ad";
  };
}
