{ callPackage }:
{
  rust-synapse-compress-state = callPackage ./rust-synapse-compress-state { };

  synadm = callPackage ./synadm.nix { };
}
