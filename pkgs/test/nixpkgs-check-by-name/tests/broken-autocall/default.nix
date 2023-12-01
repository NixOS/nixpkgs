args:
builtins.removeAttrs
  (import ../mock-nixpkgs.nix { root = ./.; } args)
  [ "foo" ]
