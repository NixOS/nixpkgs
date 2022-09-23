{ callPackage }:
{
  rust-synapse-compress-state = callPackage ./rust-synapse-compress-state.nix { };

  synadm = callPackage ./synadm.nix { };
}
