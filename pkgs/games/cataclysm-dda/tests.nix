{
  lib,
  dark-days-ahead,
  dark-days-ahead-unstable,
  bright-nights,
  the-last-generation,
}:
# Test building the various games in different
# permutations
let
  testGame = game: {
    "${game.pname}-base" = game;
    "${game.pname}-tiles" = game.withTiles;
    "${game.pname}-mods" = game.withTiles.withMods (p: [ p.tileSets.undead-people ]);
  };
in
lib.mergeAttrsList (
  lib.map testGame [
    dark-days-ahead
    dark-days-ahead-unstable
    bright-nights
    the-last-generation
  ]
)
