{ lib, runCommand }:
runCommand "documentation-highlighter"
  {
    meta = {
      description = "Highlight.js sources for the Nix Ecosystem's documentation";
      homepage = "https://highlightjs.org";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.grahamc ];
    };
    src = lib.sources.cleanSourceWith {
      src = ./.;
      filter =
        path: type:
        lib.elem (baseNameOf path) [
          "highlight.pack.js"
          "LICENSE"
          "loader.js"
          "mono-blue.css"
          "README.md"
        ];
    };
  }
  ''
    cp -r "$src" "$out"
  ''
