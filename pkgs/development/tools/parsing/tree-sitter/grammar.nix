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

  # When both scanner.{c,cc} exist, we should not link both since they may be the same but in
  # different languages. Just randomly prefer C++ if that happens.
  buildPhase = ''
    runHook preBuild
    if [[ -e "$src/src/scanner.cc" ]]; then
      $CXX -c "$src/src/scanner.cc" -o scanner.o $CXXFLAGS
    elif [[ -e "$src/src/scanner.c" ]]; then
      $CC -c "$src/src/scanner.c" -o scanner.o $CFLAGS
    fi
    $CC -c "$src/src/parser.c" -o parser.o $CFLAGS
    $CXX -shared -o parser *.o
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    runHook postInstall
  '';

  # Strip failed on darwin: strip: error: symbols referenced by indirect symbol table entries that can't be stripped
  fixupPhase = lib.optionalString stdenv.isLinux ''
    runHook preFixup
    $STRIP $out/parser
    runHook postFixup
  '';
}
