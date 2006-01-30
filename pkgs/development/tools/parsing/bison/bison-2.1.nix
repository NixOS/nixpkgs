{stdenv, fetchurl, m4}:

assert m4 != null;

stdenv.mkDerivation {
  name = "bison-2.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bison-2.1.tar.bz2;
    md5 = "ef3110077462b1140b2ae612626e8486";
  };
  buildInputs = [m4];
} // {
  glrSupport = true;
}
