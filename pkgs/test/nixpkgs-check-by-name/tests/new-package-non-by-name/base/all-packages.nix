self: super: {

  before = self.callPackage ({ someDrv }: someDrv) { };

}
