{ stdenv
, nodejs
, tree-sitter
, lib
, emscripten
}:

{ language
, version
, src
, wasmName
, location ? null
, generate ? false
, ...
}@args:

stdenv.mkDerivation ({
  pname = "${language}-grammar-wasm";

  inherit src version;

  nativeBuildInputs = [
    emscripten
    tree-sitter
  ] ++ lib.lists.optional generate nodejs;

  configurePhase = lib.optionalString (location != null) ''
    cd ${location}
  '' + lib.optionalString generate ''
    tree-sitter generate
  '';

  buildPhase = ''
    runHook preBuild
    tree-sitter build-wasm
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp tree-sitter-${wasmName}.wasm $out
    runHook postInstall
  '';
} // removeAttrs args [ "language" "wasmName" "location" ])
