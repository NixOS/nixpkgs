self: super: {
  set = self.callPackages ({ callPackage }: {
    foo = callPackage ({ someDrv }: someDrv) { };
  }) { };

  inherit (self.set) foo;
}
