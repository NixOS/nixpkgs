self: super: {
  foo = self.callPackage ./pkgs/by-name/fo/foo/package.nix {
    enableBar = true;
  };
}
