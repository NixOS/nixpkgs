{ lib, runCommand }:
runCommand "documentation-highlighter" {
  meta = {
    description = "Highlight.js sources for the Nix Ecosystem's documentation";
    homepage = "https://highlightjs.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.grahamc ];
  };
} ''
  cp -r ${./.} $out
''
