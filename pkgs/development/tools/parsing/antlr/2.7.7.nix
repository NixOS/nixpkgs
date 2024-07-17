{
  lib,
  stdenv,
  fetchurl,
  jdk,
}:

stdenv.mkDerivation rec {
  pname = "antlr";
  version = "2.7.7";
  src = fetchurl {
    url = "https://www.antlr2.org/download/antlr-${version}.tar.gz";
    sha256 = "1ffvcwdw73id0dk6pj2mlxjvbg0662qacx4ylayqcxgg381fnfl5";
  };
  patches = [ ./2.7.7-fixes.patch ];
  buildInputs = [ jdk ];

  CXXFLAGS = lib.optionalString stdenv.isDarwin "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION";

  meta = with lib; {
    description = "Powerful parser generator";
    longDescription = ''
      ANTLR (ANother Tool for Language Recognition) is a powerful parser
      generator for reading, processing, executing, or translating structured
      text or binary files. It's widely used to build languages, tools, and
      frameworks. From a grammar, ANTLR generates a parser that can build and
      walk parse trees.
    '';
    homepage = "https://www.antlr.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
