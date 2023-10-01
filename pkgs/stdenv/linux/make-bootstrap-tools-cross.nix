{system ? builtins.currentSystem}:

let
  inherit (releaseLib) lib;
  releaseLib = import ../../top-level/release-lib.nix {
    # We're not using any functions from release-lib.nix that look at
    # supportedSystems.
    supportedSystems = [];
  };

  make = crossSystem: import ./make-bootstrap-tools.nix {
    pkgs = releaseLib.pkgsForCross crossSystem system;
  };
in lib.mapAttrs (n: make) (with lib.systems.examples; {
  # NOTE: Only add platforms for which there are files in `./bootstrap-files`.
  # Sort following the sorting in `./default.nix` `bootstrapFiles` argument.

  armv5tel   = sheevaplug;
  armv6l     = raspberryPi;
  armv7l     = armv7l-hf-multiplatform;
  aarch64    = aarch64-multiplatform;
  mipsel-linux-gnu         = mipsel-linux-gnu;
  mips64el-linux-gnuabin32 = mips64el-linux-gnuabin32;
  mips64el-linux-gnuabi64  = mips64el-linux-gnuabi64;
  powerpc64le = powernv;
  riscv64 = riscv64;

  # musl
  aarch64-musl = aarch64-multiplatform-musl;
  armv6l-musl  = muslpi;
  x86_64-musl  = musl64;
})
