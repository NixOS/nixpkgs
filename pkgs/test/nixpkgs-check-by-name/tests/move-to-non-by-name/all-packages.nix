self: super: {
  foo1 = self.callPackage ({ someDrv }: someDrv) { };
  foo2 = self.callPackage ./without-config.nix { };
  foo3 = self.callPackage ({ someDrv, enableFoo }: someDrv) {
    enableFoo = null;
  };
  foo4 = self.callPackage ./with-config.nix {
    enableFoo = null;
  };
}
