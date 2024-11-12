{ callPackages, lib, ... }@args:
let
  f = args: rec {
    teleport_15 = import ./15 args;
    teleport_16 = import ./16 args;
    teleport = teleport_16;
  };
  # Ensure the following callPackages invocation includes everything 'generic' needs.
  f' = lib.setFunctionArgs f (builtins.functionArgs (import ./generic.nix));
in
callPackages f' (builtins.removeAttrs args [ "callPackages" ])
