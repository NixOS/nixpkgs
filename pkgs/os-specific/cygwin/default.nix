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
      w32api = callPackage ./w32api { };
      w32api-headers = callPackage ./w32api { headersOnly = true; };

      newlib-cygwin = callPackage ./newlib-cygwin { };
      newlib-cygwin-headers = callPackage ./newlib-cygwin { headersOnly = true; };

      tests = callPackage ./tests { };
    };
}
