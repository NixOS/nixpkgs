{ mkDerivation
, aeson
, base
, bytestring
, containers
, deepseq
, directory
, effectful
, fetchFromGitHub
, filemanip
, filepath
, lib
, MissingH
, optparse-applicative
, parsec
, pretty
, signal
, uu-parsinglib
, uuagc
, uuagc-cabal
}:
mkDerivation rec {
  pname = "glualint";
  version = "1.24.3";

  src = fetchFromGitHub {
    owner = "FPtje";
    repo = "GLuaFixer";
    rev = version;
    hash = "sha256-FmgQYONm1UciYa4Grmn+y1uVh9RSL90hO2rWusya0C0=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryToolDepends = [ uuagc uuagc-cabal ];
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    containers
    MissingH
    parsec
    pretty
    uu-parsinglib
    uuagc
    uuagc-cabal
  ];
  executableHaskellDepends = [
    aeson
    base
    bytestring
    containers
    deepseq
    directory
    effectful
    filemanip
    filepath
    optparse-applicative
    signal
  ];

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
