{ ncVersion }:
_:
{ apps, callPackage, ... }:
{

  apps = apps.extend (
    self: super: {

      hmr_enabler = callPackage ./apps/hmr_enabler.nix { };
      recognize = callPackage ./apps/recognize.nix { inherit ncVersion; };

    }
  );
}
