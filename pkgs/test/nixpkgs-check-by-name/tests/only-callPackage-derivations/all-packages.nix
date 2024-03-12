self: super: {
  alternateCallPackage = self.myScope.callPackage ({ myScopeValue, someDrv }:
    assert myScopeValue;
    someDrv
  ) { };

  myScope = self.lib.makeScope self.newScope (self: {
    myScopeValue = true;
  });

  myPackages = self.callPackages ({ someDrv }: {
    a = someDrv;
    b = someDrv;
  }) { };
  inherit (self.myPackages) a b;
}
