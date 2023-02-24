{ callPackage }:
{
  rust-synapse-compress-state = callPackage ./rust-synapse-compress-state.nix { };

  matrix-synapse-diskspace-janitor = callPackage ./matrix-synapse-diskspace-janitor.nix { };

  synadm = callPackage ./synadm.nix { };
}
