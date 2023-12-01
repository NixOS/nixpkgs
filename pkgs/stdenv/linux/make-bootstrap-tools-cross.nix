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

  armv5tel-unknown-linux-gnueabi = sheevaplug;
  armv6l-unknown-linux-gnueabihf = raspberryPi;
  armv7l-unknown-linux-gnueabihf = armv7l-hf-multiplatform;
  aarch64-unknown-linux-gnu = aarch64-multiplatform;
  mipsel-unknown-linux-gnu = mipsel-linux-gnu;
  mips64el-unknown-linux-gnuabin32 = mips64el-linux-gnuabin32;
  mips64el-unknown-linux-gnuabi64 = mips64el-linux-gnuabi64;
  powerpc64le-unknown-linux-gnu = powernv;
  riscv64-unknown-linux-gnu = riscv64;

  # musl
  aarch64-unknown-linux-musl = aarch64-multiplatform-musl;
  armv6l-unknown-linux-musleabihf = muslpi;
  x86_64-unknown-linux-musl = musl64;
})
