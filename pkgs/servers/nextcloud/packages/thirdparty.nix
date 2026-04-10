{ ncVersion }:
_:
{ apps, callPackage, ... }:
{

  apps = apps.extend (
    self: super: {
      hmr_enabler = callPackage ./apps/hmr_enabler.nix { };

      memories = callPackage ./apps/memories.nix { inherit ncVersion; };

      recognize = callPackage ./apps/recognize.nix { inherit ncVersion; };
    }
  );
}
