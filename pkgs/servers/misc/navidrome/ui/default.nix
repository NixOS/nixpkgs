{ buildPackages, nodejs, stdenv, src, version }:

let

  nodeComposition = import ./node-composition.nix {
    inherit (buildPackages) nodejs;
    inherit (stdenv.hostPlatform) system;
    pkgs = buildPackages;
  };

in

nodeComposition.package.override {

  pname = "navidrome";
  inherit version;
  src = "${src}/ui";

  dontNpmInstall = true;

  postInstall = ''
    npm run build
    cd $out
    mv lib/node_modules/navidrome-ui/build/* .
    rm -rf lib
  '';
}
