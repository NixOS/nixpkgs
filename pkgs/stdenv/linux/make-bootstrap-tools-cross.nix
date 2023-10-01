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
  armv5tel   = sheevaplug;
  armv6l     = raspberryPi;
  armv7l     = armv7l-hf-multiplatform;
  aarch64    = aarch64-multiplatform;
  x86_64-musl  = musl64;
  armv6l-musl  = muslpi;
  aarch64-musl = aarch64-multiplatform-musl;
  riscv64 = riscv64;
  mips64el-linux-gnuabin32 = mips64el-linux-gnuabin32;
  mips64el-linux-gnuabi64  = mips64el-linux-gnuabi64;
  mipsel-linux-gnu         = mipsel-linux-gnu;
  powerpc64le = powernv;
})
