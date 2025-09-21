{
  makeScopeWithSplicing',
  generateSplicesForMkScope,
}:

let
  otherSplices = generateSplicesForMkScope "cygwin";
in
makeScopeWithSplicing' {
  inherit otherSplices;
  f =
    self:
    let
      callPackage = self.callPackage;
    in
    {
      w32api-headers = callPackage ./w32api { };
    };
}
