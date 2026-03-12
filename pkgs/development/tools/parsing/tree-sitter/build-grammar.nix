{
  stdenv,
  nodejs,
  tree-sitter,
  jq,
  lib,
}:

{
  language,
  version,
  src,
  meta ? { },
  generate ? false,
  ...
}@args:

stdenv.mkDerivation (
  {
    pname = "tree-sitter-${language}";

    inherit version src;

    nativeBuildInputs = [
      jq
    ]
    ++ lib.optionals generate [
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

    # Tree-sitter grammar packages contain a `tree-sitter.json` file at their
    # root. This provides package metadata that can be used to infer build
    # details.
    #
    # See https://tree-sitter.github.io/tree-sitter/cli/init.html for spec.
    configurePhase = ''
      runHook preConfigure
      if [[ -e tree-sitter.json ]]; then
        # Check nix package version matches grammar source
        NIX_VERSION=${lib.head (lib.splitString "+" version)}
        SRC_VERSION=$(jq -r '.metadata.version' tree-sitter.json)
        if [[ "$NIX_VERSION" != "$SRC_VERSION" ]]; then
          nixErrorLog "grammar version ($NIX_VERSION) differs from source ($SRC_VERSION)"
        fi

        # Check language name matches source
        GRAMMAR=$(jq -c 'first(.grammars[] | select(.name == env.language))' tree-sitter.json)
        if [[ -z "$GRAMMAR" ]]; then
          GRAMMAR=$(jq -c 'first(.grammars[]) // {}' tree-sitter.json)
          NAME=$(jq -r '.name' <<< "$GRAMMAR")
          SRC_LANGS=$(jq -r '[.grammars[].name] | join(", ")' tree-sitter.json)
          nixErrorLog "grammar name ($language) not found in source grammars ($SRC_LANGS), continuing with $NAME"
        fi

        # Move to the appropriate working directory for build
        cd -- $(jq -r '.path // "."' <<< $GRAMMAR)
      else
        # Older grammars may not contain this file. The tree-sitter CLI provides
        # a warning rather than fail unless ABI > 14. Mirror that behaviour
        # while older grammars age out.
        nixWarnLog "grammar source is missing tree-sitter.json"
      fi
      runHook postConfigure
    '';

    # Optionally regenerate the parser source from the defined grammar. In most
    # cases this should not be required as convention is to have this checked
    # in to the source repo.
    preBuild = lib.optionalString generate ''
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

    # Merge default meta attrs with any explicitly defined on the source.
    meta = {
      description = "Tree-sitter grammar for ${language}";
    }
    // (lib.optionalAttrs (src ? meta.homepage) {
      homepage = src.meta.homepage;
    })
    // meta;
  }
  # FIXME: neovim and nvim-treesitter currently rely on passing location rather
  # than a src attribute with a correctly positioned root (e.g. for grammars in
  # monorepos). Use this if present for now.
  // (lib.optionalAttrs (args ? location && args.location != null) {
    setSourceRoot = "sourceRoot=$(echo */${args.location})";
  })
  // removeAttrs args [
    "generate"
    "meta"
  ]
)
