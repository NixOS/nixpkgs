self: super: {

  alt.callPackage = self.lib.callPackageWith {};

  foo = self.alt.callPackage ({ }: self.someDrv) { };

}
