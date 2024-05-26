{ callPackages, lib, ... }@args:
let
  f = args: rec {
    teleport_14 = import ./14 args;
    teleport_15 = import ./15 args;
    teleport = teleport_15;
  };
  # Ensure the following callPackages invocation includes everything 'generic' needs.
  f' = lib.setFunctionArgs f (builtins.functionArgs (import ./generic.nix));
in
callPackages f' (builtins.removeAttrs args [ "callPackages" ])
