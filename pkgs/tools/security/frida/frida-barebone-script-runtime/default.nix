{ lib, buildNpmPackage, src, hash }:

let
  package = lib.importJSON "${src}/package.json";
in

buildNpmPackage {
  pname = package.name;
  inherit (package) version;

  inherit src;
  npmDepsHash = hash;

  postInstall = ''
    mkdir -p $out/share/$pname
    mv $out/lib/node_modules/$pname/script-runtime.js $out/share/$pname
    rm -rf $out/lib
  '';
}
