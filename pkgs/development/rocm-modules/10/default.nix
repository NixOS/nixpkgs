{
  lib,
  newScope,
}:

let
  outer = lib.makeScope newScope (self: {

    rocmUpdateScript = self.callPackage ../update.nix {
      maxMajor = 10;
      tagPrefixes = [
        "rocm"
        "therock"
      ];
      setName = "rocmPackages_10";
    };
  });
in
outer
