{ lib, runCommand }:
runCommand "documentation-highlighter"
  {
    meta = with lib; {
      description = "Highlight.js sources for the Nix Ecosystem's documentation";
      homepage = "https://highlightjs.org";
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = [ maintainers.grahamc ];
    };
    src = lib.sources.cleanSourceWith {
      src = ./.;
      filter =
        path: type:
        lib.elem (baseNameOf path) ([
          "highlight.pack.js"
          "LICENSE"
          "loader.js"
          "mono-blue.css"
          "README.md"
        ]);
    };
  }
  ''
    cp -r "$src" "$out"
  ''
