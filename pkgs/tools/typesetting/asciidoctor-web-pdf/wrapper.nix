{ lib, makeWrapper, runCommand, asciidoctor-web-pdf-unwrapped, plugins ? [] }:
let
  pluginPath = lib.concatStringsSep ":" (map (p: "${p}/libexec/${p.pname}/node_modules") plugins);
in runCommand "asciidoctor-web-pdf" {
  inherit (asciidoctor-web-pdf-unwrapped) pname version meta;

  buildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin
  for name in asciidoctor-web-pdf asciidoctor-pdf; do
    makeWrapper ${asciidoctor-web-pdf-unwrapped}/bin/$name $out/bin/$name --set NODE_PATH "${pluginPath}"
  done
''
