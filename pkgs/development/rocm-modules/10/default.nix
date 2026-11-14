{
  lib,
  callPackage,
  newScope,
  stdenv,
}:

let
  outer = lib.makeScope newScope (
    self:
    let
      inherit (self) llvm;
      rocmClangStdenv = llvm.rocmClangStdenv;
    in
    {
      inherit rocmClangStdenv;
      stdenv = rocmClangStdenv;

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
      inherit (self.llvm) rocm-toolchain clang openmp;

      rocm-device-libs = self.callPackage ./rocm-device-libs { };
    }
  );
in
outer
