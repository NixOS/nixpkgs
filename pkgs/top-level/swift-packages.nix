let
  autoCalledPackages = import ./by-name-overlay.nix ../development/compilers/swift_ng/by-name;

  swift_sources_6_2 = builtins.fromJSON (
    builtins.readFile ../development/compilers/swift_ng/sources-6.2.json
  );
in

{
  lib,
  clangStdenv,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  otherSplices ? generateSplicesForMkScope "swiftPackages_ng",
}:

makeScopeWithSplicing' {
  inherit otherSplices;
  extra = self: {
    swift_sources = swift_sources_6_2;
  };
  f = lib.extends autoCalledPackages (self: {
    stdenv = clangStdenv;
    swift_release = "6.2.4";
  });
}
