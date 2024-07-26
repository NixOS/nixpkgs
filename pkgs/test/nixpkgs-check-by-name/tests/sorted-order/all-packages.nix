self: super: {
  a = self.callPackage ./pkgs/by-name/a/a/package.nix { };
  b = self.callPackage ({ someDrv }: someDrv) { };
  c = self.callPackage ./pkgs/by-name/c/c/package.nix { };
  d = self.callPackage ({ someDrv }: someDrv) { };
}
