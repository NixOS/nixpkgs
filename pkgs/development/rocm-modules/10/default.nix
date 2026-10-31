{
  lib,
  config,
  callPackage,
  newScope,
  python3Packages,
  openmpi,
  stdenv,
}:

let
  outer = lib.makeScope newScope (
    self:
    let
      inherit (self) llvm;
      origStdenv = stdenv;
      pyPackages = python3Packages;
      openmpi-orig = openmpi;
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

      # Replaces hip, opencl-runtime, and rocclr
      clr = self.callPackage ./clr { };

      hipify = self.callPackage ./hipify {
        stdenv = origStdenv;
      };

      # hsakmt was merged into rocm-runtime
      hsakmt = self.rocm-runtime;
      rocprofiler-register = self.callPackage ./rocprofiler-register {
        inherit (llvm) clang;
      };

      roctracer = self.callPackage ./roctracer { };

      half = self.callPackage ./half { };

      # Even if config.rocmSupport is false we need rocmSupport true
      # version of ucc/ucx in openmpi in this package set
      openmpi = openmpi-orig.override (
        prev:
        let
          ucx = prev.ucx.override {
            enableCuda = false;
            enableRocm = true;
            rocmPackages = self;
          };
        in
        {
          inherit ucx;
          ucc = prev.ucc.override {
            enableCuda = false;
            inherit ucx;
          };
        }
      );
      mpi = self.openmpi;
    }
  );
  scopeForArches =
    arches:
    outer.overrideScope (
      _final: prev: {
        clr = prev.clr.override {
          localGpuTargets = arches;
        };
      }
    );
in
outer
// lib.genAttrs outer.clr.gpuTargets (arch: scopeForArches [ arch ])
// {
  gfx9 = scopeForArches [
    "gfx906"
    "gfx908"
    "gfx90a"
    "gfx942"
  ];
  gfx10 = scopeForArches [
    "gfx1010"
    "gfx1030"
  ];
  gfx11 = scopeForArches [
    "gfx1100"
    "gfx1101"
    "gfx1102"
    "gfx1150"
    "gfx1151"
  ];
  gfx12 = scopeForArches [
    "gfx1200"
    "gfx1201"
  ];
}
