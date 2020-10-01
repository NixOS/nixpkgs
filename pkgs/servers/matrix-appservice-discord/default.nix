{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in nodePackages."matrix-appservice-discord-git+https://github.com/Half-Shot/matrix-appservice-discord.git#v0.5.2".override {
  nativeBuildInputs = [ pkgs.makeWrapper ];

  # Discord's API is migrating from discordapp.com to discord.com
  # and will only be accessible through the latter domain after 2020-11-07.
  # The CDN domain (cdn.discordapp.com) remains unchanged.
  # https://github.com/Half-Shot/matrix-appservice-discord/issues/611
  preRebuild = ''
    shopt -s globstar
    sed -i 's|https://discordapp.com|https://discord.com|g' \
      ./node_modules/discord.js/src/**/*.js \
      ./src/**/*.ts
  '';

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
