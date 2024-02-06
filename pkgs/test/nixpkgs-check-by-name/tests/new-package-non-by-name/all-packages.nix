self: super: {
  before = self.callPackage ({ someDrv }: someDrv) { };
  new1 = self.callPackage ({ someDrv }: someDrv) { };
  new2 = self.callPackage ./without-config.nix { };
  new3 = self.callPackage ({ someDrv, enableNew }: someDrv) {
    enableNew = null;
  };
  new4 = self.callPackage ./with-config.nix {
    enableNew = null;
  };
}
