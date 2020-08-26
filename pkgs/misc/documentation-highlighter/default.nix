{ stdenv, runCommand }:
runCommand "documentation-highlighter" {
  meta = {
    description = "Highlight.js sources for the Nix Ecosystem's documentation.";
    homepage = "https://highlightjs.org";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.grahamc ];
  };
} ''
  cp -r ${./.} $out
''
