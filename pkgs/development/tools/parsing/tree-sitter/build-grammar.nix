{
  stdenv,
  nodejs,
  tree-sitter,
  lib,
}:

{
  language,
  version,
  src,
  generate ? false,
  ...
}@args:

let
  /**
    Tree-sitter grammar packages contain a `tree-sitter.json` file at their
    root. This provides package metadata that can be used here.

    See https://tree-sitter.github.io/tree-sitter/cli/init.html for spec.
  */
  package =
    let
      path = "${src}/tree-sitter.json";
    in
    if lib.pathExists path then
      let
        json = lib.importJSON path;
        srcVersion = json.metadata.version;
      in
      lib.warnIf (
        srcVersion != lib.head (lib.splitString "+" version)
      ) "${language} grammar version (${version}) differs from source (${srcVersion})" json
    else
      # Older grammars may not contain this file. The tree-sitter CLI provides
      # a warning rather than hard fail unless ABI > 14, mirror that behaviour.
      lib.warn "${language} grammar is missing tree-sitter.json in source root" {
        grammars = [ { name = language; } ];
        metadata = { inherit version; };
      };

  /**
    The grammar metadata.

    Each package may contain one or more grammars. `language` must match one of
    these and is used for further discovery.
  */
  grammar = lib.findFirst (lib.matchAttrs {
    name = language;
  }) (lib.warn "no grammar defined for '${language}' in ${src}" { }) package.grammars;

  /**
    A relative path from the directory containing tree-sitter.json to another
    directory containing the src/ folder, which contains the actual generated
    parser.
  */
  # FIXME: neovim and nvim-treesitter currently rely on passing location rather
  # than a src attribute with a correctly positioned root (e.g. for grammars in
  # monorepos). Use this if present for now.
  location = args.location or grammar.path or ".";
in
stdenv.mkDerivation (
  {
    pname = "tree-sitter-${language}";

    inherit version src;

    nativeBuildInputs = lib.optionals generate [
      nodejs
      tree-sitter
    ];

    CFLAGS = [
      "-Isrc"
      "-O2"
    ];
    CXXFLAGS = [
      "-Isrc"
      "-O2"
    ];

    stripDebugList = [ "parser" ];

    configurePhase =
      lib.optionalString (location != ".") ''
        cd ${location}
      ''
      + lib.optionalString generate ''
        tree-sitter generate
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
  }
  // removeAttrs args [
    "language"
    "generate"
  ]
)
