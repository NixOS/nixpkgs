{ runCommand, jq }:

let
  src = import ./source-unpatched.nix;
  version = import ./version.nix;

in
  runCommand "mastodon-src-patched" {
    buildInputs = [ jq ];
  } ''
    cp -r ${src} $out
    chmod -R u+w $out
    jq ". + {version: \"${version}\"}" ${src}/package.json > "$out/package.json"
  ''
