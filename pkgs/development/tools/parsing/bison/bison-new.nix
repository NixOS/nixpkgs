{stdenv, fetchurl, m4}:

assert m4 != null;

stdenv.mkDerivation {
  name = "bison-1.875c";
  src = fetchurl {
    url = ftp://alpha.gnu.org/pub/gnu/bison/bison-1.875c.tar.gz;
    md5 = "bba317725fc84013b9d0a6b2576dfaa7";
  };
  buildInputs = [m4];
} // {
  glrSupport = true;
}
