# !!! this should be moved to default.nix eventually (but I delay
# doing that since it would cause a rebuild of lots of stuff).

{stdenv, fetchurl, yacc}:

assert !isNull yacc;

derivation {
  name = "flex-2.5.31";
  system = stdenv.system;
  builder = ./builder-new.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/lex/flex-2.5.31.tar.bz2;
    md5 = "363dcc4afc917dc51306eb9d3de0152f";
  };
  stdenv = stdenv;
  yacc = yacc;
}
