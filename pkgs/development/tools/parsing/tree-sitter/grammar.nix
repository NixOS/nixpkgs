{ stdenv
, tree-sitter
}:

# Build a parser grammar and put the resulting shared object in `$out/parser`

{
  # language name
  language
  # version of tree-sitter
, version
  # source for the language grammar
, source
}:

stdenv.mkDerivation {

  pname = "${language}-grammar";
  inherit version;

  src = source;

  buildInputs = [ tree-sitter ];

  dontUnpack = true;
  configurePhase= ":";
  buildPhase = ''
    runHook preBuild
    scanner_cc="$src/src/scanner.cc"
    if [ ! -f "$scanner_cc" ]; then
      scanner_cc=""
    fi
    scanner_c="$src/src/scanner.c"
    if [ ! -f "$scanner_c" ]; then
      scanner_c=""
    fi
    $CC -I$src/src/ -shared -o parser -Os $src/src/parser.c $scanner_cc $scanner_c -lstdc++
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    runHook postInstall
  '';
}
