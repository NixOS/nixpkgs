{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in nodePackages."matrix-appservice-discord-git+https://github.com/Half-Shot/matrix-appservice-discord.git#v0.5.2".override {
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postInstall = ''
    # compile Typescript sources
    npm run build

    # server wrapper
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-discord" \
      --add-flags "$out/lib/node_modules/matrix-appservice-discord/build/src/discordas.js"

    # admin tools wrappers
    for toolPath in $out/lib/node_modules/matrix-appservice-discord/build/tools/*; do
      makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-discord-$(basename $toolPath .js)" \
        --add-flags "$toolPath"
    done
  '';

  # other metadata generated and inherited from ./node-package.nix
  meta.maintainers = with stdenv.lib.maintainers; [ pacien ];
}
