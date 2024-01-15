self: super: {
  nonDerivation = self.callPackage ./someDrv.nix { };
}
