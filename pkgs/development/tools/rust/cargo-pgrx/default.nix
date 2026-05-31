{
  lib,
  callPackage,
}:

lib.mapAttrs (_: callPackage ./generic.nix { }) (
  (import ./pinned.nix)
  // {
    # Default version for direct usage.
    # Not to be used with buildPgrxExtension, where it should be pinned.
    # When you make an extension use the latest version, *copy* this to a separate pinned attribute.
    cargo-pgrx = {
      version = "0.18.0";
      hash = "sha256-sBezVDNnyqFQwvFm/CkhlY1zm7Ii2NQPeTfoUQu55e0=";
      cargoHash = "sha256-/miOlhZ87fnKT1f+XVaWK4xAzHje8OGVlYl4iU0Sf34=";
    };
  }
)
