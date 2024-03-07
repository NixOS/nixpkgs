self: super: {

  bar = (x: x) self.callPackage ./pkgs/by-name/fo/foo/package.nix { someFlag = true; };
  foo = self.bar;

}
