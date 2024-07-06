{ libsForQt5, qt6Packages }:
{
  new-engine = qt6Packages.callPackage (import ./new-engine.nix) {};
  old-engine = libsForQt5.callPackage (import ./old-engine.nix) {};
}
