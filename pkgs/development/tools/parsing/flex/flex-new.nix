# !!! this should be moved to default.nix eventually (but I delay
# doing that since it would cause a rebuild of lots of stuff).

{stdenv, fetchurl, yacc, m4}:

assert yacc != null && m4 != null;

stdenv.mkDerivation {
  name = "flex-2.5.31";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/flex-2.5.31.tar.bz2;
    md5 = "363dcc4afc917dc51306eb9d3de0152f";
  };
  buildInputs = [yacc];
  propagatedBuildInputs = [m4];
}
