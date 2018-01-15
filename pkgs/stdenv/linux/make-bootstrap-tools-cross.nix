{system ? builtins.currentSystem}:

let
  make = crossSystem: import ./make-bootstrap-tools.nix {
    localSystem = { inherit system; };
    inherit crossSystem;
  };

in with (import ../../../lib).systems.examples; {
  armv5tel   = make sheevaplug;
  scaleway   = make scaleway-c1;
  pogoplug4  = make pogoplug4;
  armv6l     = make raspberryPi;
  armv7l     = make armv7l-hf-multiplatform;
  aarch64    = make aarch64-multiplatform;
  x86_64-musl  = make musl64;
  i686-musl    = make musl32;
  armv6l-musl  = make muslpi;
  aarch64-musl = make aarch64-multiplatform-musl;
}
