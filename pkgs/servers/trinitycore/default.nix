{ lib, callPackage }:
{
  trinitycore_335 = callPackage ./335.nix { };
  trinitycore_434 = callPackage ./434.nix { };
  trinitycore_rolling = callPackage ./rolling.nix { };
}
