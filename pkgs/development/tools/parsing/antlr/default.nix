{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "antlr-3.0b3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.antlr.org/download/antlr-3.0b3.tar.gz;
    md5 = "6a7e70ccece8149b735cc3aaa24241cc";
  };
  inherit jre;

  meta = with stdenv.lib; {
    description = "Powerful parser generator";
    longDescription = ''
      ANTLR (ANother Tool for Language Recognition) is a powerful parser
      generator for reading, processing, executing, or translating structured
      text or binary files. It's widely used to build languages, tools, and
      frameworks. From a grammar, ANTLR generates a parser that can build and
      walk parse trees.
    '';
    homepage = http://www.antlr.org/;
    platforms = platforms.linux;
  };
}
