self: super: {
  nonDerivation = self.callPackage ({ someDrv }: someDrv) { };
}
