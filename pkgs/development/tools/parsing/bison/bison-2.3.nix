{stdenv, fetchurl, m4}:

assert m4 != null;

stdenv.mkDerivation {
  name = "bison-2.3";
  src = fetchurl {
    url = mirror://gnu/bison/bison-2.3.tar.bz2;
    md5 = "c18640c6ec31a169d351e3117ecce3ec";
  };
  buildInputs = [m4];

  meta = {
    description = "A yacc-compatible parser generator";
  };
} // {
  glrSupport = true;
}
