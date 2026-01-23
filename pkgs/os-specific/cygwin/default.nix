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
      # this is here to avoid symlinks being made to cygwin1.dll in /nix/store
      newlib-cygwin-nobin = callPackage ./newlib-cygwin/nobin.nix { };
      newlib-cygwin-headers = callPackage ./newlib-cygwin { headersOnly = true; };
    };
}
