{ lib, runCommand }:
runCommand "documentation-highlighter" {
  meta = {
    description = "Highlight.js sources for the Nix Ecosystem's documentation";
    homepage = "https://highlightjs.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.grahamc ];
  };
  src = lib.sources.cleanSourceWith {
    src = ./.;
<<<<<<< HEAD
    filter = path: type: lib.elem (baseNameOf path) ([
      "highlight.pack.js"
      "LICENSE"
      "loader.js"
      "mono-blue.css"
      "README.md"
=======
    filter = path: type: lib.elem path (map toString [
      ./highlight.pack.js
      ./LICENSE
      ./loader.js
      ./mono-blue.css
      ./README.md
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ]);
  };
} ''
  cp -r "$src" "$out"
''
