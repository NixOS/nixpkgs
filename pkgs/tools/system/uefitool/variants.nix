{ libsForQt5, qt6Packages }:
{
  new-engine = qt6Packages.callPackage ./new-engine.nix { };
  old-engine = libsForQt5.callPackage ./old-engine.nix { };
}
