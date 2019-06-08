{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in nodePackages.matrix-appservice-irc.override {
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-irc" \
      --add-flags "$out/lib/node_modules/matrix-appservice-irc/app.js"
  '';

  # other metadata generated and inherited from ./node-package.nix
  meta.maintainers = with stdenv.lib.maintainers; [ pacien ];
}

