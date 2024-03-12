self: super: {
  foo = self._internalCallByNamePackageFile ./foo.nix;
  bar = self._internalCallByNamePackageFile ./foo.nix;
}
