{ stdenv, lib, fetchgit, darwin, buildPlatform
, buildRustCrate, buildRustCrateHelpers, defaultCrateOverrides }:

((import ./Cargo.nix {
  inherit lib buildPlatform buildRustCrate buildRustCrateHelpers fetchgit;
  cratesIO = import ./crates-io.nix { inherit lib buildRustCrate buildRustCrateHelpers; };
}).systemfd {}).override {
  crateOverrides = defaultCrateOverrides // {
    systemfd = attrs: {
        meta = {
          description = "A convenient helper for passing sockets into another process.";
          homepage = "https://github.com/mitsuhiko/systemfd";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.adisbladis ];
        };
    };
  };
}
