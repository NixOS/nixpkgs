{stdenv, fetchurl, m4}:

assert m4 != null;

stdenv.mkDerivation {
  name = "bison-1.875";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bison-1.875.tar.bz2;
    md5 = "b7f8027b249ebd4dd0cc948943a71af0";
  };
  buildInputs = [m4];
} // {
  glrSupport = false;
}
