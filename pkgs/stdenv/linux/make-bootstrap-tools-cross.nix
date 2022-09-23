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
  pogoplug4  = pogoplug4;
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
  powerpc64 = ppc64;
  powerpc64-musl = ppc64-musl;
  powerpc64le = powernv;
  powerpc64le-musl = musl-power;
})
