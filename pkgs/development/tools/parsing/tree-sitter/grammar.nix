{ stdenv
, tree-sitter
, lib
}:

# Build a parser grammar and put the resulting shared object in `$out/parser`

{
  # language name
  language
  # version of tree-sitter
, version
  # source for the language grammar
, source
, location ? null
}:

stdenv.mkDerivation rec {

  pname = "${language}-grammar";
  inherit version;

  src = if location == null then source else "${source}/${location}";

  buildInputs = [ tree-sitter ];

  dontUnpack = true;
  dontConfigure = true;

  CFLAGS = [ "-I${src}/src" "-O2" ];
  CXXFLAGS = [ "-I${src}/src" "-O2" ];

  stripDebugList = [ "parser" ];

  # When both scanner.{c,cc} exist, we should not link both since they may be the same but in
  # different languages. Just randomly prefer C++ if that happens.
  buildPhase = ''
    runHook preBuild
    if [[ -e "$src/src/scanner.cc" ]]; then
      $CXX -fPIC -c "$src/src/scanner.cc" -o scanner.o $CXXFLAGS
    elif [[ -e "$src/src/scanner.c" ]]; then
      $CC -fPIC -c "$src/src/scanner.c" -o scanner.o $CFLAGS
    fi
    $CC -fPIC -c "$src/src/parser.c" -o parser.o $CFLAGS
    $CXX -shared -o parser *.o
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    if [[ -d "$src/queries" ]]; then
      cp -r $src/queries $out/
    fi
    runHook postInstall
  '';
}
