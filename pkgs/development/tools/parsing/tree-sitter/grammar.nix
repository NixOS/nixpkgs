{ stdenv
, nodejs
, tree-sitter
, lib
}:

# Build a parser grammar and put the resulting shared object in `$out/parser`

{
  # language name
  language
, version
, src
, location ? null
, generate ? false
, isBroken ? false
, ...
}@args:

stdenv.mkDerivation ({
  pname = "${language}-grammar";

  inherit src version;

  nativeBuildInputs = lib.optionals generate [ nodejs tree-sitter ];

  CFLAGS = [ "-Isrc" "-O2" ];
  CXXFLAGS = [ "-Isrc" "-O2" ];

  stripDebugList = [ "parser" ];

  configurePhase = lib.optionalString (location != null) ''
    cd ${location}
  '' + lib.optionalString generate ''
    tree-sitter generate
  '';

  doCheck = !isBroken;
  checkPhase = ''
    # HOME is needed because tree-sitter needs a writable home folder
    HOME=. ${lib.getExe tree-sitter} test
  '';

  # When both scanner.{c,cc} exist, we should not link both since they may be the same but in
  # different languages. Just randomly prefer C++ if that happens.
  buildPhase = ''
    runHook preBuild
    if [[ -e src/scanner.cc ]]; then
      $CXX -fPIC -c src/scanner.cc -o scanner.o $CXXFLAGS
    elif [[ -e src/scanner.c ]]; then
      $CC -fPIC -c src/scanner.c -o scanner.o $CFLAGS
    fi
    $CC -fPIC -c src/parser.c -o parser.o $CFLAGS
    rm -rf parser
    $CXX -shared -o parser *.o
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    if [[ -d queries ]]; then
      cp -r queries $out
    fi
    runHook postInstall
  '';

  meta = {
    broken = isBroken;
  };

} // removeAttrs args [ "language" "location" "generate" ])
