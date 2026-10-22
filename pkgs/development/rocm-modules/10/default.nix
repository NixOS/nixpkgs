{
  lib,
  callPackage,
  newScope,
  python3Packages,
  stdenv,
}:

let
  outer = lib.makeScope newScope (
    self:
    let
      inherit (self) llvm;
      origStdenv = stdenv;
      pyPackages = python3Packages;
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

      rocm-core = self.callPackage ./rocm-core { stdenv = origStdenv; };

      rocm-cmake = self.callPackage ./rocm-cmake { stdenv = origStdenv; };

      rocm-device-libs = self.callPackage ./rocm-device-libs { };

      rocm-runtime = self.callPackage ./rocm-runtime {
        stdenv = origStdenv;
      };

      rocm-comgr = self.callPackage ./rocm-comgr { };

      rocminfo = self.callPackage ./rocminfo { stdenv = origStdenv; };

      amdsmi = pyPackages.callPackage ./amdsmi {
        inherit (self) rocmUpdateScript;
      };

      rocm-smi = pyPackages.callPackage ./rocm-smi {
        inherit (self) rocmUpdateScript;
      };

      rocm-docs-core = python3Packages.callPackage ../rocm-docs-core { };

      hip-common = self.callPackage ./hip-common { };

      hipcc = self.callPackage ../hipcc { stdenv = origStdenv; };
      rocprofiler-register = self.callPackage ./rocprofiler-register {
        inherit (llvm) clang;
      };

      roctracer = self.callPackage ./roctracer { };
    }
  );
in
outer
