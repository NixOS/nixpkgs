{
  lib,
  callPackage,
  newScope,
}:

let
  outer = lib.makeScope newScope (
    self:
    let
      inherit (self) llvm;
    in
    {

      rocmUpdateScript = self.callPackage ../update.nix {
        maxMajor = 10;
        tagPrefixes = [
          "rocm"
          "therock"
        ];
        setName = "rocmPackages_10";
      };

      ## ROCm ##
      llvm = lib.recurseIntoAttrs (
        callPackage ./llvm/default.nix {
          # rocm-device-libs is used for .src only
          # otherwise would cause infinite recursion
          inherit (self) rocm-device-libs;
        }
      );
    }
  );
in
outer
