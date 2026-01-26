{ lib, runCommand }:
runCommand "documentation-highlighter"
  {
    pname = "documentation-highlighter";
    version = "11.9.0";

    meta = {
      description = "Highlight.js sources for the Nix Ecosystem's documentation";
      homepage = "https://highlightjs.org";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
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
