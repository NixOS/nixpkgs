{
  callPackages,
  lib,
  wasm-bindgen-cli_0_2_92,
  wasm-bindgen-cli_0_2_95,
  buildGo122Module,
  buildGo123Module,
  ...
}@args:
let
  f = args: rec {
    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    teleport_15 = import ./15 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_92;
        buildGoModule = buildGo122Module;
      }
    );
    teleport_16 = import ./16 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
        buildGoModule = buildGo122Module;
      }
    );
    teleport = teleport_16;
    teleport_17 = import ./17 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
        buildGoModule = buildGo123Module;
      }
    );
  };
  # Ensure the following callPackages invocation includes everything 'generic' needs.
  f' = lib.setFunctionArgs f (builtins.functionArgs (import ./generic.nix));
in
callPackages f' (
  builtins.removeAttrs args [
    "callPackages"
    "wasm-bindgen-cli_0_2_92"
    "wasm-bindgen-cli_0_2_95"
    "buildGo122Module"
    "buildGo123Module"
  ]
)
