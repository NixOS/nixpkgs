self: super: {
  foo = self._internalCallByNamePackageFile ./foo.nix;
}
