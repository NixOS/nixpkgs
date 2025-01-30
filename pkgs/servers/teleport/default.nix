{
  callPackages,
  lib,
  wasm-bindgen-cli_0_2_92,
  wasm-bindgen-cli_0_2_93,
  ...
}@args:
let
  f = args: rec {
    # wasm-bindgen-cli version must match the version of wasm-bindgen in Cargo.lock
    teleport_15 = import ./15 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_92;
      }
    );
    teleport_16 = import ./16 (
      args
      // {
        wasm-bindgen-cli = wasm-bindgen-cli_0_2_93;
      }
    );
    teleport = teleport_16;
  };
  # Ensure the following callPackages invocation includes everything 'generic' needs.
  f' = lib.setFunctionArgs f (builtins.functionArgs (import ./generic.nix));
in
callPackages f' (
  builtins.removeAttrs args [
    "callPackages"
    "wasm-bindgen-cli_0_2_92"
    "wasm-bindgen-cli_0_2_93"
  ]
)
