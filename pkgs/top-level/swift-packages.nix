{
  lib,
  clangStdenv,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  otherSplices ? generateSplicesForMkScope "swiftPackages_ng",
}:

makeScopeWithSplicing' {
  inherit otherSplices;
  extra = self: { };
  f = self: {
    stdenv = clangStdenv;
  };
}
