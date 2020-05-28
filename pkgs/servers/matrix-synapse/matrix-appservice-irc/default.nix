# TODO: This has a bunch of duplication with matrix-appservice-slack

{ pkgs, nodejs, stdenv, lib, ... }:

let

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages."${packageName}".override {
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-irc" \
    --add-flags "$out/lib/node_modules/matrix-appservice-irc/app.js"
  '';

  meta = with lib; {
    description = "A Matrix <--> IRC bridge";
    maintainers = with maintainers; [ puffnfresh ];
    license = licenses.asl20;
  };
}
