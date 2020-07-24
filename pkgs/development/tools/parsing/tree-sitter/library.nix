{ stdenv
, language
, tree-sitter
, version
, source
}:

stdenv.mkDerivation {

  pname = "tree-sitter-${language}-library";
  inherit version;

  src = source;

  buildInputs = [ tree-sitter ];

  dontUnpack = true;
  configurePhase= ":";
  buildPhase = ''
    runHook preBuild
    $CC -I$src/src/ -shared -o parser -Os $src/src/parser.c
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    runHook postInstall
  '';
}
