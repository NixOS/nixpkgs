{system ? builtins.currentSystem}:

let
  make = crossSystem: import ./make-bootstrap-tools.nix {
    localSystem = { inherit system; };
    inherit crossSystem;
  };
  lib = import ../../../lib;
in lib.mapAttrs (n: make) (with lib.systems.examples; {
  armv5tel   = sheevaplug;
  scaleway   = scaleway-c1;
  pogoplug4  = pogoplug4;
  armv6l     = raspberryPi;
  armv7l     = armv7l-hf-multiplatform;
  aarch64    = aarch64-multiplatform;
  x86_64-musl  = musl64;
  armv6l-musl  = muslpi;
  aarch64-musl = aarch64-multiplatform-musl;
  riscv64 = riscv64;
  powerpc64le = powernv;
  powerpc64le-musl = musl-power;
})
