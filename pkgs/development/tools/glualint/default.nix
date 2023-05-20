{ mkDerivation
, aeson
, array
, base
, bytestring
, containers
, directory
, deepseq
, filemanip
, filepath
, ListLike
, MissingH
, mtl
, optparse-applicative
, parsec
, pretty
, signal
, lib
, uu-parsinglib
, uuagc
, uuagc-cabal
, vector
, pkgs
, fetchFromGitHub
}:
mkDerivation rec {
  pname = "glualint";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "FPtje";
    repo = "GLuaFixer";
    rev = version;
    hash = "sha256-zL0GcrNihSOaw5JkDi04ipOmBq8idj2m0VCKU2J1ZbA=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryToolDepends = [ uuagc uuagc-cabal ];
  libraryHaskellDepends = [
    aeson
    array
    base
    bytestring
    containers
    directory
    filemanip
    filepath
    ListLike
    MissingH
    mtl
    optparse-applicative
    parsec
    pretty
    signal
    uu-parsinglib
    uuagc
    uuagc-cabal
    deepseq
    vector
  ];
  executableHaskellDepends = [ base directory ];

  preBuild = ''
    echo "Generating attribute grammar haskell files"
    uuagc --haskellsyntax --data src/GLua/AG/AST.ag
    uuagc --haskellsyntax --data --strictdata src/GLua/AG/Token.ag
    uuagc --catas --haskellsyntax --semfuns --wrappers --signatures src/GLua/AG/PrettyPrint.ag
    uuagc --catas --haskellsyntax --semfuns --wrappers --signatures --optimize src/GLuaFixer/AG/LexLint.ag
    uuagc --catas --haskellsyntax --semfuns --wrappers --signatures --optimize src/GLuaFixer/AG/ASTLint.ag
  '';

  homepage = "https://github.com/FPtje/GLuaFixer";
  description = "Linter for Garry's mod Lua";
  license = lib.licenses.lgpl21;
  maintainers = with lib.maintainers; [ ruby0b ];
}
