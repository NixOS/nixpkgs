{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in nodePackages."matrix-appservice-irc-git+https://github.com/matrix-org/matrix-appservice-irc.git#0.20.3".override {
  nativeBuildInputs = [ pkgs.makeWrapper pkgs.nodePackages.node-gyp-build ];

  postInstall = ''
    # server wrapper
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-irc" \
      --add-flags "$out/lib/node_modules/matrix-appservice-irc/app.js"

  '';

  # other metadata generated and inherited from ./node-package.nix
  meta.maintainers = with stdenv.lib.maintainers; [ gdamjan ];
}
