self: super: {

  foo = self.callPackage ({ someDrv, someFlag }: someDrv) { someFlag = true; };

}
